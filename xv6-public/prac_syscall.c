#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

//Simple system call
int
printk_str(char *str)
{
	cprintf("%s\n", str);
	return 0xABCDABCD;
}
int
sys_myfunction(void)
{
	char *str;
	//Decode argument using argstr
	if (argstr(0, &str) < 0)
		return -1;
	return printk_str(str);
}
