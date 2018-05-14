#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "spinlock.h"

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct mlfq mlfq;         // mlfq structure added
  int minpass;              //minimum pass value of all proc.
  thread_t nexttid;
} ptable;

extern void initpush(struct proc* queue[], struct proc *p);
extern struct proc* allocproc(void);
extern void wakeup1(void *chan);

int thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg);
void thread_exit(void *retval);
int thread_join(thread_t thread, void **retval);


//Based on fork() from proc.c, user stack creation is copied from exec()
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg)
{
  int i;
  struct proc *np;
  struct proc *mproc = myproc()->mthread;   //This will always points to main thread of process.
  uint sz, sp, ustack[2];

  // Allocate process.
  if((np = allocproc()) == 0){
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
  sp -= 2 * 4;
  if(copyout(mproc->pgdir, sp, ustack, 2 * 4) < 0) {
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

  np->state = RUNNABLE;
  if (mproc->percentage == 0) //Only if parent is MLFQ proc.
    initpush(ptable.mlfq.queue[0], np);
  np->pass = ptable.minpass;

  release(&ptable.lock);

  return 0;
}

void thread_exit(void *retval)
{
  struct proc *curproc = myproc();
  struct proc *mproc = myproc()->mthread;
  int fd;

  //Called from main thread
  if (curproc->threads != 0)
    exit();

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  //save *retval into struct proc.
  curproc->ret = retval;

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Main thread might be sleeping in wait().
  wakeup1(mproc);

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
  panic("zombie thread_exit");
}
