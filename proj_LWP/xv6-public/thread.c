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

int thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg);
void thread_exit(void *retval);
int thread_join(thread_t thread, void **retval);


//Based on fork() from proc.c. user stack creation is copied from exec()
int
thread_create(thread_t *thread, void *(*start_routine)(void *), void *arg)
{
  int i;
  struct proc *np;
  struct proc *pproc = myproc()->pthread;   //This will always points to main thread of process.
  uint sz, sp, ustack[2];

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  //setup user stack. Copied & modified from exec()
  if((sz = allocuvm(pproc->pgdir, pproc->sz, pproc->sz + 2*PGSIZE)) == 0) {
    np->state = UNUSED;
    return -1;
  }
  pproc->sz = sp = sz;
  clearpteu(pproc->pgdir, (char*)(pproc->sz - 2*PGSIZE));

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = (uint)arg;
  sp -= 2 * 4;
  if(copyout(pproc->pgdir, sp, ustack, 2 * 4) < 0) {
    if((sz = deallocuvm(pproc->pgdir, pproc->sz, pproc->sz - 2*PGSIZE)) != 0)
      pproc->sz = sz;
    np->state = UNUSED;
    return -1;
  }
  //setup user stack done//


  np->pgdir = pproc->pgdir;     // shared address space
  np->sz = pproc->sz;           // shared address space
  np->parent = pproc->parent;
  *np->tf = *pproc->tf;         // copy all tf from main thread.
  np->tf->esp = sp;             // use user stack that has been created just before this code.

  for(i = 0; i < NOFILE; i++)
    if(pproc->ofile[i])
      np->ofile[i] = filedup(pproc->ofile[i]);
  np->cwd = idup(pproc->cwd);

  safestrcpy(np->name, pproc->name, sizeof(pproc->name));


  //thread related setting
  *thread = np->pid;          // I don't see a reason to create new tid to indicate specific thread.
  np->pthread = pproc;
  np->threads = 0;
  np->cthread[0] = NULL;
  np->tf->eip = (uint)start_routine;

  acquire(&ptable.lock);

  //update main thread. Under ptable.lock.
  pproc->threads++;
  for (i = 0; i < NPROC; i++)
    if (pproc->cthread[i] == NULL)
      pproc->cthread[i] = np;

  np->state = RUNNABLE;
  if (pproc->percentage == 0) //Only if parent is MLFQ proc.
    initpush(ptable.mlfq.queue[0], np);
  np->pass = ptable.minpass;

  release(&ptable.lock);

  return 0;
}
