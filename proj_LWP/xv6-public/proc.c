#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct mlfq mlfq;         // mlfq structure added
  int minpass;              //minimum pass value of all proc.
} ptable;

static struct proc *initproc;
uint runningticks;
int nextpid = 1;

extern void forkret(void);
extern void trapret(void);

void wakeup1(void *chan);

// push newely created proc into highest priority queue.
// only diffrence between initpush & push is whether the input proc is a
// guaranteed to be executed for the next time.
void
initpush(struct proc* queue[], struct proc *p)
{
  for (int i = 0; i < NPROC; i++) {
    if (queue[i] == NULL) {
      for (int j = i; j > 0; j--)
        queue[j] = queue[j-1];
      queue[0] = p;
      ptable.mlfq.index[0] = -1;
      return;
    }
  }

  panic("failed to find empty place from queue\n");
}

// push proc into queue.
// It is not garanteed to be run firstly because
// push is also used to drop priority. And it seems
// not fair for the original procs to be scheduled back.
// ptable.lock is required.
void
push(struct proc* queue[], struct proc *p)
{
  for (int i = 0; i < NPROC; i++) {
    if (queue[i] == NULL) {
      // for (int j = i; j > 0; j--)
      //   queue[j] = queue[j-1];
      queue[i] = p;
      return;
    }
  }

  panic("failed to find empty place from queue\n");
}

// Search for the first runnable proc without pop.
// Note that rr & index is used to find
// start location for the searching.
// ptable.lock is required.
struct proc*
top(struct proc* queue[], int priority)
{
  int *rr = &ptable.mlfq.index[priority];
  struct proc *ret = NULL;
  for (int i = 0; i < NPROC; i++) {
    *rr = (*rr + 1) % NPROC;
    if (queue[*rr] == NULL)
      continue;
    if (queue[*rr]->state != RUNNABLE)
      continue;
    if (queue[*rr]->percentage != 0)
      continue;
    ret = queue[*rr];
    break;
  }
  return ret;
}

// Remove proc from the queue. Attempting to remove proc
// that does not exist will cause panic.
// It is guaranteed that next search will be started right
// after the poped proc.
// ptable.lock is required.
void
pop(struct proc* p)
{
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < NPROC; j++) {
      if (ptable.mlfq.queue[i][j] == NULL)
        continue;
      if (p != ptable.mlfq.queue[i][j])
        continue;
      for (int k = j; k < NPROC - 1; k++)
        ptable.mlfq.queue[i][k] = ptable.mlfq.queue[i][k+1];
      ptable.mlfq.queue[i][NPROC-1] = NULL;
      ptable.mlfq.index[i] = j;
      return;
    }
  }
  panic("failed to find proc in pop");
}

// POP from original queue and PUSH to the next priority queue.
// all var. relevent to priority will be changed.
// Attempting to drop priority of least priority proc will cause panic.
// ptable.lock is required.
void
droppriority(struct proc* p)
{
  pop(p);
  push(ptable.mlfq.queue[p->priority+1], p);
  switch(p->priority) {
    case 0:
      p->ticks = 0;
      p->curticks = 0;
      p->priority = 1;
      p->timequantum = 2;
      p->timeallotment = 10;
      break;
    case 1:
      p->ticks = 0;
      p->priority = 2;
      p->timequantum = 4;
      p->timeallotment = 100;
      break;
    default:
      panic("failed to identify priority");
  }
}

// make all procs in MLFQ to get highest priority
// in order to prevent starvation.
// This is the only function that can cause priority boost.
// ptable.lock is required.
void
boostpriority(void)
{
  struct proc *p;

  for (int i = 1; i < 3; i++) {
    int *rr = &ptable.mlfq.index[i];
    for (int j = 0; j < NPROC; j++) {
      *rr = (*rr + 1) % NPROC;
      if (ptable.mlfq.queue[i][*rr] == NULL)
        continue;
      p = ptable.mlfq.queue[i][*rr];
      p->ticks = 0;
      p->curticks = 0;
      p->priority = 0;
      p->timequantum = 1;
      p->timeallotment = 5;
      push(ptable.mlfq.queue[0], p);
      ptable.mlfq.queue[i][*rr] = NULL;
    }
  }
  ptable.mlfq.index[1] = ptable.mlfq.index[2] = 0;
}

// Returns priority of MLFQ.
// Attempting to get priority of stride proc is
// undefined behavior.
// (Such action will not cause any panic, but the return value
// has no meaning at all. It's just the last priority it had
// before called get_cpu_share.)
int
getlev(void)
{
  struct proc *p = myproc();
  return p->priority;
}


// Wrapper function for the getlev()
int
sys_getlev(void)
{
  return getlev();
}

// Turn MLFQ into stride Scheduling
// proc will be poped from MLFQ.
// and gain ticket according to the percentage.
// Total percentage of stride procs can not exceed 80%
// One proc may call function more than once
// If so, percentage will be set to the last call of function
// and any remain or lacking tickets will be exchanged with MLFQ tickets.
int
set_cpu_share(int percentage)
{
  struct proc* p = myproc()->mthread;
  acquire(&ptable.lock);

  // set_cpu_share already called before
  if (p->percentage != 0) {
    int diff = percentage - p->percentage;
    if (ptable.mlfq.percentage - diff < 20) {
      cprintf("MLFQ must have at least of 20%% tickets\n");
      release(&ptable.lock);
      return -1;
    }
    p->percentage += diff;
    ptable.mlfq.percentage -= diff;
    if (p->percentage == 0) {
      if (p->threads == 1)
        initpush(ptable.mlfq.queue[0], p);
      else {
        for (int i = 0; i < NPROC; i++)
          if (!p->cthread[i])
            initpush(ptable.mlfq.queue[0], p->cthread[i]);
      }
    }
    release(&ptable.lock);
  }
  else {
    if (ptable.mlfq.percentage - percentage < 20) {
      cprintf("MLFQ must have at least of 20%% tickets\n");
      release(&ptable.lock);
      return -1;
    }
    if (percentage == 0) {
      cprintf("0%% share is not accepted\n");
      return -1;
    }
    if (p->threads == 1)
      pop(p);
    else {
      for (int i = 0; i < NPROC; i++)
          if (!p->cthread[i])
            pop(p->cthread[i]);
    }
    p->percentage = percentage;
    p->pass = ptable.minpass;
    ptable.mlfq.percentage -= percentage;
    release(&ptable.lock);
  }

  return percentage;
}

// Wrapper function for the set_cpu_share
int
sys_set_cpu_share(void)
{
  int percentage;

  if (argint(0, &percentage) < 0) {
    return -1;
  }
  else
    return set_cpu_share(percentage);
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;

  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->ticks = 0;
  p->curticks = 0;
  p->priority = 0;
  p->timequantum = 1;
  p->timeallotment = 5;
  p->percentage = 0;
  p->pass = ptable.minpass;
  p->threads = 1;
  p->mthread = p;
  p->cthread[0] = p;
  for (int i = 1; i < NPROC; i++)
    p->cthread[i] = NULL;
  p->rrlast = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
  initpush(ptable.mlfq.queue[0], p);
  p->pass = ptable.minpass;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  initpush(ptable.mlfq.queue[0], np);
  np->pass = ptable.minpass;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to finds out it exited.
void
exit(void)
{
  struct proc *mproc = myproc()->mthread;
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // free resources of all LWP
  for (int i = 1; i < NPROC; i++) {
    p = mproc->cthread[i];
    if (p == NULL || p->state == ZOMBIE || p->state == UNUSED)
      continue;

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
      if(p->ofile[fd]){
        fileclose(p->ofile[fd]);
        p->ofile[fd] = 0;
      }
    }
    begin_op();
    iput(p->cwd);
    end_op();
    p->cwd = 0;
    p->parent = initproc;
    // Threads will be cleaned up by main thread's parent process later.
    acquire(&ptable.lock);
    p->state = ZOMBIE;
    release(&ptable.lock);
    wakeup1(initproc);
  }

  // After cleaning threads, clear main thread. Nothing to change.
  curproc = mproc;
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;

        // Clear shared address only if p is main thread
        if (p->mthread == p)
          freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        if (p->percentage == 0)
          pop(p);
        ptable.mlfq.percentage += p->percentage;
        p->ticks = 0;
        p->curticks = 0;
        p->priority  = 0;
        p->timequantum = 1;
        p->timeallotment = 5;
        p->percentage = 0;
        p->pass = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p = NULL;
  struct proc *mproc = NULL;
  struct cpu *c = mycpu();
  uint nextboost = PBOOST;

  runningticks = 0;
  c->proc = 0;

  //set MLFQ tickets to MAXTICKET. 100% cpu share.
  acquire(&ptable.lock);
  ptable.mlfq.percentage = 100;
  release(&ptable.lock);

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    //start checking pass val of all procs & MLFQ
    int minpass = ptable.mlfq.pass;

    //mlfq.tickets == MAXTICKET means there is no stride proc for now.
    //thus we can skip comparing part. Else look for the proc with min. pass.
    if (ptable.mlfq.percentage != 100){
      for (int i = 0; i < NPROC; i++) {
        if (ptable.proc[i].percentage == 0 || ptable.proc[i].state != RUNNABLE)
          continue;
        if (minpass > ptable.proc[i].pass) {
          mproc = &ptable.proc[i];
          minpass = mproc->pass;
        }
      }
    }
    ptable.minpass = minpass;

    // MLFQ scheduling
    if (minpass == ptable.mlfq.pass) {
      // If monopoly is set, there is no stride proc on the system for now.
      // run all queues until empty. If stride proc is found while running,
      // exit from the for loop.
      // If not set, run only one proc from the queue and go back to
      // finding min. pass.
      int done = 0, monopoly = 1;
      // Increment stride pass for MLFQ only if there is other stride proc running.
      if (ptable.mlfq.percentage != 100) {
        ptable.mlfq.pass += (int)(MAXTICKET/ptable.mlfq.percentage);
        monopoly = 0;
      }
      int i = 0;
      for (;;) {
        int boosted = 0;

        if (i >= 3)
          break;
        p = top(ptable.mlfq.queue[i], i);
        while (p != NULL && (monopoly || !done)) {
          c->proc = p;
          switchuvm(p);
          p->state = RUNNING;
          swtch(&(c->scheduler), p->context);
          done = 1;
          p->ticks++;
          p->curticks++;
          runningticks++;
          //Because MLFQ runs continuously, pass is increased by stride * quantum.
          if (ptable.mlfq.percentage != 100)
            ptable.mlfq.pass += (int)(MAXTICKET/ptable.mlfq.percentage) * (p->curticks - 1);
          // cprintf("p->tickets: %d\n", p->tickets);
          // If more than 100 ticks after previous boost is detected.
          // only calculates ticks occured during execution of MLFQ scheduling.
          if (runningticks >= nextboost) {
            nextboost = runningticks + PBOOST;
            boostpriority();
            boosted = 1;
            break;
          }
          if (p->priority != 2 && p->ticks >= p->timeallotment)
            droppriority(p);
          if (p->mthread->percentage != 0)// set_cpu_share has been called for current proc.
            monopoly = 0;
          p->curticks = 0;
          switchkvm();

          c->proc = 0;
          if (boosted)
            p = NULL;
          else
            p = top(ptable.mlfq.queue[i], i);
        }
        if (boosted)
          i = 0;
        else
          i++;
      }
    }
    // Stride Scheduling
    else {
      p = NULL;
      if (mproc->threads == 1)
        p = mproc;
      else {
        for (int j = 1; j < NPROC + 1; j++) {
          int cur = (mproc->rrlast + j) % NPROC;
          if (mproc->cthread[cur] == NULL)
            continue;
          if (mproc->cthread[cur]->state == RUNNABLE) {
            p = mproc->cthread[cur];
            mproc->rrlast = cur;
            break;
          }
        }
        if (p == NULL)
          continue;
      }
      // cprintf("p pass: %d\n", p->pass);
      if(p->state != RUNNABLE)
        continue;
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      mproc->pass += (int)(MAXTICKET/mproc->percentage);
      // cprintf("mlfq pass: %d\n", ptable.mlfq.pass);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// Wrapper function for yield in order to make it syscall
void
sys_yield(void)
{
  yield();
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
