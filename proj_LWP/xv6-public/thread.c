#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "spinlock.h"

#ifndef NULL
#define NULL 0
#endif
#define thread_t uint

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct mlfq mlfq;         // mlfq structure added
  int minpass;              //minimum pass value of all proc.
} ptable;

extern void initpush(struct proc* queue[], struct proc *p);
extern struct proc* allocproc_t(void);
extern void wakeup_t(void *chan);

int thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg);
void thread_exit(void *retval);
int thread_join(thread_t thread, void **retval);

int
sys_thread_create(void)
{
  int thread, start_routine, arg;

  if(argint(0, &thread) < 0)
      return -1;

  if(argint(1, &start_routine) < 0)
      return -1;

  if(argint(2, &arg) < 0)
      return -1;

  return thread_create((thread_t*)thread, (void*)start_routine, (void*)arg);
}

int
sys_thread_exit(void)
{
  int retval;

  if(argint(0, &retval) < 0)
      return -1;

  thread_exit((void*)retval);
  return 0;
}

int
sys_thread_join(void)
{
  int thread, retval;

  if(argint(0, &thread) < 0)
      return -1;

  if(argint(1, &retval) < 0)
      return -1;

  return thread_join((thread_t)thread,(void**)retval);
}

//Based on fork() from proc.c, user stack creation is copied from exec()
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg)
{
  int i;
  struct proc *np;
  struct proc *mproc = myproc()->mthread;   //This will always points to main thread of process.
  uint sz, sp, ustack[3];

  // Allocate process.
  if((np = allocproc_t()) == 0){
    return -1;
  }

  //setup user stack. Copied & modified from exec()
  if((sz = allocuvm(mproc->pgdir, mproc->sz, mproc->sz + 2*PGSIZE)) == 0) {
    np->state = UNUSED;
    return -1;
  }
  mproc->sz = sp = sz;
  clearpteu(mproc->pgdir, (char*)(mproc->sz - 2*PGSIZE));

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = (uint)arg;
  ustack[2] = 0;
  sp -= sizeof(ustack);
  if(copyout(mproc->pgdir, sp, ustack, sizeof(ustack)) < 0) {
    if((sz = deallocuvm(mproc->pgdir, mproc->sz, mproc->sz - 2*PGSIZE)) != 0)
      mproc->sz = sz;
    np->state = UNUSED;
    return -1;
  }
  //setup user stack done//


  np->pgdir = mproc->pgdir;            // shared address space
  np->sz = mproc->sz;                  // shared address space
  np->parent = mproc->parent;
  *np->tf = *mproc->tf;                // copy all tf from main thread.
  np->tf->esp = sp;                    // use user stack that has been created just before this code.

  for(i = 0; i < NOFILE; i++)
    if(mproc->ofile[i])
      np->ofile[i] = filedup(mproc->ofile[i]);
  np->cwd = idup(mproc->cwd);

  safestrcpy(np->name, mproc->name, sizeof(mproc->name));


  //thread related setting
  *thread = np->pid;                    // I don't see a reason to create new tid to indicate specific thread.
  np->mthread = mproc;                  // Parent process / main thread. Whatever we call it.
  np->threads = 0;                      // Only main threads will have this value set.
  np->cthread[0] = NULL;                // Only main threads will have this value set.
  np->tf->eip = (uint)start_routine;    //

  acquire(&ptable.lock);

  //update main thread. Under ptable.lock.
  mproc->threads++;
  for (i = 0; i < NPROC; i++)
    if (mproc->cthread[i] == NULL)
      mproc->cthread[i] = np;
  if (i == NPROC) {
    if((sz = deallocuvm(mproc->pgdir, mproc->sz, mproc->sz - 2*PGSIZE)) != 0)
      mproc->sz = sz;
    np->state = UNUSED;
    return -1;
  }

  np->state = RUNNABLE;
  if (mproc->percentage == 0) //Only if parent is MLFQ proc.
    initpush(ptable.mlfq.queue[0], np);
  np->pass = ptable.minpass;

  release(&ptable.lock);

  return 0;
}

void
thread_exit(void *retval)
{
  struct proc *curproc = myproc();
  struct proc *mproc = myproc()->mthread;
  int fd;

  //Called from main thread
  if (curproc->mthread == curproc)
    exit();

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  //save *retval into struct proc.
  for (int i = 1; i < NPROC; i++)
    if (mproc->cthread[i] == curproc)
      mproc->ret[i] = retval;

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Main thread might be sleeping in wait().
  wakeup_t(mproc);

  // Pass abandoned children to init.                     No need I believe
  // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  //   if(p->parent == curproc){
  //     p->parent = initproc;
  //     if(p->state == ZOMBIE)
  //       wakeup1(initproc);
  //   }
  // }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  // For some reason I cannot find solution, mac does not accept this panic.
  // If this panic is uncommented, xv6 won't boot from "booting from hard dsik"
  // panic("zombie thread_exit");
}

int
thread_join(thread_t thread, void **retval)
{
  int found = 0, i;
  struct proc *curproc = myproc();
  struct proc *mproc = myproc()->mthread;
  struct proc *cproc;
  uint sz;

  acquire(&ptable.lock);

  for (i = 0; i < NPROC; i++) {
    if (mproc->cthread[i] == NULL)
      continue;
    if (mproc->cthread[i]->pid == thread) {
      cproc = mproc->cthread[i];
      found = 1;
      break;
    }
  }
  if (!found) {
    release(&ptable.lock);
    return -1;
  }

  for(;;){
    if (cproc->state == ZOMBIE) {
      if(retval != NULL)
        *retval = mproc->ret[i];
      mproc->cthread[i] = NULL;
      mproc->ret[i] = NULL;
      mproc->rrlast = i;
      mproc->threads -= 1;
      kfree(cproc->kstack);
      //TODO do I have to change all main & other threads sz???
      if((sz = deallocuvm(cproc->pgdir, cproc->sz, cproc->sz - 2*PGSIZE)) != 0)
        cproc->sz = sz;
      cproc->pid = 0;
      cproc->parent = 0;
      cproc->name[0] = 0;
      cproc->killed = 0;
      cproc->state = UNUSED;
      if (mproc->percentage == 0)
        pop(cproc);
      cproc->ticks = 0;
      cproc->curticks = 0;
      cproc->priority  = 0;
      cproc->timequantum = 1;
      cproc->timeallotment = 5;
      cproc->percentage = 0;
      cproc->pass = 0;
      release(&ptable.lock);
      return 0;
    }

    // No point waiting if main thread or callee thread is killed.
    if(mproc->killed || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
