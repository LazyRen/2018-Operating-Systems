// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
  int ticks;                   // Runtime of program before change of priority
  int curticks;                // Runtime of program before yield
  int priority;                // Current position of queue(if MLFQ)
  int timequantum;             // Maximum time program can run without timer interrupt
  int timeallotment;           // Priority will be decreased if reached.
  int percentage;              // If 0, it means it's MLFQ. Else consider it as a stride scheduler.
  int pass;                    // Counter for stride sceduling
  int threads;                 // Counts number of threads. If it is LWP, it will be set to 0. Check main thread for accurate number.
  struct proc *mthread;        // Points to main thread. pthread = myproc() means itself is main thread.
  struct proc *cthread[NPROC]; // Only main thread will take care of this array. Has direct access to all threads under the process including itself.
  void *ret[NPROC];
  int rrlast;                  // Will be used for scheduling. Only main thread will be chosen from scheduler.
                               // And which thread to run under process is determined by round robin.
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap

struct mlfq {
  struct proc *queue[3][NPROC]; // 0 is the highest priority
  int index[3];                 // Indicate start position for the round robin scheduling.
  int percentage;                  // If 0, it means it's MLFQ. Else consider it as a stride scheduler.
  int pass;                     // Counter for stride sceduling
};
