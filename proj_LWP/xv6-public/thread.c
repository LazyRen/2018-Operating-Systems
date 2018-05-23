#ifndef THREAD_H_
#define THREAD_H_

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

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct mlfq mlfq;         // mlfq structure added
  int minpass;              //minimum pass value of all proc.
} ptable;

extern void initpush(struct proc* queue[], struct proc *p);
extern struct proc* allocproc(void);
extern void wakeup1(void *chan);

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
  uint sp = 0, ustack[3];

  // Allocate process.
  if((np = allocproc()) == 0) {
    // cprintf("allocoroc from thread_create failed\n");
    return -1;
  }

  /* setup user stack. */
  acquire(&ptable.lock);
  for (i = 0; i < NPROC; i++) {
    if (mproc->cthread[i] == NULL) {
      mproc->cthread[i] = np;
      sp = mproc->ustack[i];
      memset((void*)(sp - PGSIZE), 0, PGSIZE);
      break;
    }
  }

  if (i == NPROC) {
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = (uint)arg;
  ustack[2] = 0;
  sp -= sizeof(ustack);
  if(copyout(mproc->pgdir, sp, ustack, sizeof(ustack)) < 0) {
    mproc->cthread[i] = NULL;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  /* setup user stack done */


  np->pgdir = mproc->pgdir;            // shared address space
  np->sz = mproc->sz;                  // shared address space
  *np->tf = *mproc->tf;                // copy all tf from main thread.
  np->tf->esp = sp;                    // use user stack that has been set just before this code.

  for(i = 0; i < NOFILE; i++)
    if(mproc->ofile[i])
      np->ofile[i] = filedup(mproc->ofile[i]);
  np->cwd = idup(mproc->cwd);

  safestrcpy(np->name, mproc->name, sizeof(mproc->name));


  //thread related setting
  np->pid = mproc->pid;                 // Because "process" id can exist only one within one process...
  *thread = np->tid;                    // thread_t is eqaul to tid.
  np->mthread = mproc;                  // Parent process / main thread. Whatever we call it.
  np->parent = mproc->parent;           // All threads within one process have same parent.
  np->cthread[0] = NULL;                // Onl main threads will have this value set.
  np->tf->eip = (uint)start_routine;    // Start location of thread is equal to start_routine param.


  np->state = RUNNABLE;
  if (mproc->percentage == 0 && !np->inqueue) //Only if parent is MLFQ proc.
    initpush(ptable.mlfq.queue[0], np);

  release(&ptable.lock);

  return 0;
}

// Exit from the thread. Save retval to main thread's ret[].
// If main thread calls thread_exit(), call exit() so process itself terminates.
void
thread_exit(void *retval)
{
  struct proc *curproc = myproc();
  struct proc *mproc = curproc->mthread;
  int fd;

  //Called from main thread
  if (curproc == mproc)
    exit();

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  //save *retval into struct proc.
  for (int i = 0; i < NPROC; i++)
    if (mproc->cthread[i] == curproc)
      mproc->ret[i] = retval;

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Main thread might be sleeping in wait().
  wakeup1(mproc);

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  // For some reason I cannot find solution, mac does not accept this panic.
  // If this panic is uncommented, xv6 won't boot from "booting from hard dsik"
  // panic("zombie thread_exit");
}

// Acquire retval from thread_exit().
// Clean up ZOMBIE worker thread so proc can be reused later.
// If thread_join is called before actual thread is created via thread_join,
// thread_join will return -1 to indicate ERROR.
int
thread_join(thread_t thread, void **retval)
{
  int found = 0, i;
  struct proc *curproc = myproc();
  struct proc *mproc = curproc->mthread;
  struct proc *cproc;

  acquire(&ptable.lock);

  for(;;){
    found = 0;

    for (i = 0; i < NPROC; i++) { // Find worker thread
      if (mproc->cthread[i] && mproc->cthread[i]->tid == thread) {
        cproc = mproc->cthread[i];
        found = 1;
        break;
      }
    }

    if (!found) {// If there is no such thread exist, ERROR occurs.
      // You must create thread before ask for join.
      release(&ptable.lock);
      return -1;
    }


    if (cproc->state == ZOMBIE) {// If the thread is dead(thread_exit) clean up messes.
      if(retval != NULL)
        *retval = mproc->ret[i];

      mproc->cthread[i] = NULL;
      mproc->ret[i] = NULL;

      kfree(cproc->kstack);
      cproc->pid = 0;
      cproc->parent = 0;
      cproc->name[0] = 0;
      cproc->killed = 0;
      cproc->state = UNUSED;
      if (cproc->inqueue)
        pop(cproc);
      cproc->ticks = 0;
      cproc->curticks = 0;
      cproc->priority  = 0;
      cproc->timequantum = 1;
      cproc->timeallotment = 5;
      cproc->percentage = 0;
      cproc->pass = 0;
      cproc->tid = 0;
      cproc->mthread = NULL;
      release(&ptable.lock);
      return 0;
    }

    // No point waiting if main thread or callee thread is killed.
    if(mproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(mproc, &ptable.lock);  //DOC: wait-sleep
  }
}

#endif
