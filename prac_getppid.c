#include "types.h"
#include "defs.h"
#include "proc.h"

int
sys_getppid(void)
{
	return myproc()->parent->pid;
}
