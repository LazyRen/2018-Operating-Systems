#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

#ifndef NULL
#define NULL 0
#endif

extern struct proc *initproc;

int
exec(char *path, char **argv)
{
  char *s, *last;
  int i, off, shouldfree = 0;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
  struct proc *mproc = curproc->mthread;
  if (curproc->mthread == ZOMBIE || curproc->mthread == UNUSED || curproc->mthread->killed)
    return -1;
  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = mproc->pgdir;
  if (curproc == mproc)
    shouldfree = 1;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;
  for (i = 0; i < NPROC; i++) {
    if (mproc->cthread[i] != curproc && mproc->cthread[i] != NULL) {
      // Close all open files.
      // for(int fd = 0; fd < NOFILE; fd++){
      //   if(mproc->cthread[i]->ofile[fd]){
      //     fileclose(mproc->cthread[i]->ofile[fd]);
      //     mproc->cthread[i]->ofile[fd] = 0;
      //   }
      // }

      mproc->cthread[i]->state = ZOMBIE;
      wakeup_t(mproc->parent);
      wakeup_t(initproc);
    }
    else if (mproc->cthread[i] == curproc)
      mproc->cthread[i] = NULL;
  }
  curproc->threads = 1;
  curproc->mthread = curproc;
  for (i = 0; i < NPROC; i++) {
    curproc->cthread[i] = NULL;
    *curproc->ret = NULL;
  }
  curproc->cthread[0] = curproc;
  curproc->rrlast = 0;
  switchuvm(curproc);
  if (!shouldfree)
    mproc->state = ZOMBIE;
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
// int
// exec(char *path, char **argv)
// {
//   char *s, *last;
//   int i, off, shouldfree = 0;
//   uint argc, sz, sp, ustack[3+MAXARG+1];
//   struct elfhdr elf;
//   struct inode *ip;
//   struct proghdr ph;
//   pde_t *pgdir, *oldpgdir;
//   struct proc *curproc = myproc();

//   begin_op();

//   if((ip = namei(path)) == 0){
//     end_op();
//     cprintf("exec: fail\n");
//     return -1;
//   }
//   ilock(ip);
//   pgdir = 0;

//   // Check ELF header
//   if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
//     goto bad;
//   if(elf.magic != ELF_MAGIC)
//     goto bad;

//   if((pgdir = setupkvm()) == 0)
//     goto bad;

//   // Load program into memory.
//   sz = 0;
//   for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
//     if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
//       goto bad;
//     if(ph.type != ELF_PROG_LOAD)
//       continue;
//     if(ph.memsz < ph.filesz)
//       goto bad;
//     if(ph.vaddr + ph.memsz < ph.vaddr)
//       goto bad;
//     if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
//       goto bad;
//     if(ph.vaddr % PGSIZE != 0)
//       goto bad;
//     if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
//       goto bad;
//   }
//   iunlockput(ip);
//   end_op();
//   ip = 0;

//   // Allocate two pages at the next page boundary.
//   // Make the first inaccessible.  Use the second as the user stack.
//   sz = PGROUNDUP(sz);
//   if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
//     goto bad;
//   clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
//   sp = sz;

//   // Push argument strings, prepare rest of stack in ustack.
//   for(argc = 0; argv[argc]; argc++) {
//     if(argc >= MAXARG)
//       goto bad;
//     sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
//     if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
//       goto bad;
//     ustack[3+argc] = sp;
//   }
//   ustack[3+argc] = 0;

//   ustack[0] = 0xffffffff;  // fake return PC
//   ustack[1] = argc;
//   ustack[2] = sp - (argc+1)*4;  // argv pointer

//   sp -= (3+argc+1) * 4;
//   if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
//     goto bad;

//   // Save program name for debugging.
//   for(last=s=path; *s; s++)
//     if(*s == '/')
//       last = s+1;
//   safestrcpy(curproc->name, last, sizeof(curproc->name));

//   // Commit to the user image.
//   oldpgdir = curproc->pgdir;
//   if (curproc == curproc->mthread)
//     shouldfree = 1;
//   curproc->pgdir = pgdir;
//   curproc->sz = sz;
//   curproc->tf->eip = elf.entry;  // main
//   curproc->tf->esp = sp;
//   for (i = 1; i < NPROC; i++) {
//     if (curproc->mthread->cthread[i] == curproc) {
//       curproc->mthread->threads -= 1;
//       //curproc->mthread->cthread[i] = NULL;
//       break;
//     }
//   }
//   int newm = i;
//   for (i = 1; i < NPROC; i++) {
//     if(i != newm){
//       if(curproc->mthread->cthread[i] != NULL)
//         curproc->cthread[i]->state = ZOMBIE;
//     }
//   }
//     curproc->threads = 1;
//   if(!shouldfree)
//     curproc->mthread->state = ZOMBIE;
//   curproc->mthread = curproc;
//   *curproc->ret = NULL;

//   curproc->cthread[0] = curproc;
//   curproc->rrlast = 0;
//   switchuvm(curproc);

//   freevm(oldpgdir);
//   return 0;

//  bad:
//   if(pgdir)
//     freevm(pgdir);
//   if(ip){
//     iunlockput(ip);
//     end_op();
//   }
//   return -1;
// }
