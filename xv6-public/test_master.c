/**
 *  This program runs child test programs concurrently.
 */

#include "types.h"
#include "stat.h"
#include "user.h"

#define CNT_TEST					15
// Number of child programs
#define CNT_CHILD           10
#define CNT_EXCEED          5

// Name of child test program that tests Stride scheduler
#define NAME_CHILD_STRIDE   "test_stride"
// Name of child test program that tests MLFQ scheduler
#define NAME_CHILD_MLFQ     "test_mlfq"
#define NOOP					"NOOP"

char *child_argv[CNT_TEST][CNT_CHILD][3] = {
  //MLFQ Only Testing
	{ {NAME_CHILD_MLFQ, "0", 0},
    {NOOP, 0, 0} },
  { {NAME_CHILD_MLFQ, "1", 0},
    {NOOP, 0, 0} },
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NOOP, 0, 0} },
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0} },
  { {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0} },
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0} },

  //STRIDE Only Testing
  { {NAME_CHILD_STRIDE, "40", 0},
    {NOOP, 0, 0} },
  { {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_STRIDE, "30", 0},
    {NAME_CHILD_STRIDE, "40", 0},
    {NOOP, 0, 0} },
  { {NAME_CHILD_STRIDE, "1", 0},
    {NAME_CHILD_STRIDE, "2", 0},
    {NAME_CHILD_STRIDE, "3", 0},
    {NAME_CHILD_STRIDE, "4", 0},
    {NAME_CHILD_STRIDE, "5", 0},
    {NAME_CHILD_STRIDE, "6", 0},
    {NAME_CHILD_STRIDE, "7", 0},
    {NAME_CHILD_STRIDE, "8", 0},
    {NAME_CHILD_STRIDE, "9", 0},
    {NAME_CHILD_STRIDE, "10", 0} },
  { {NAME_CHILD_STRIDE, "80", 0},
    {NOOP, 0, 0} },

  //Stride Out of Limit
  { {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_STRIDE, "20", 0},
    {NAME_CHILD_STRIDE, "30", 0},
    {NAME_CHILD_STRIDE, "15", 0},
    {NAME_CHILD_STRIDE, "6", 0},
    {NOOP, 0, 0} },
  { {NAME_CHILD_STRIDE, "81", 0},
    {NOOP, 0, 0} },
  //MLFQ & STRIDE Mixed Testing
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_STRIDE, "20", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_STRIDE, "30", 0} },
  { {NAME_CHILD_STRIDE, "81", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NOOP, 0, 0} },
  { {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_STRIDE, "20", 0},
    {NAME_CHILD_STRIDE, "30", 0},
    {NAME_CHILD_STRIDE, "15", 0},
    {NAME_CHILD_STRIDE, "6", 0},
    {NOOP, 0, 0} },
};

int
main(int argc, char *argv[])
{
  int pid;
  int i, j, k;
  for (i = 0; i < CNT_TEST; i++) {
    k = 0;
    for (j = 0; j < CNT_CHILD; j++) {
      if (!strcmp(child_argv[i][j][0], NOOP))
        break;
      k++;
      pid = fork();
      if (pid > 0) {
        // parent
        continue;
      } else if (pid == 0) {
        // child
        exec(child_argv[i][j][0], child_argv[i][j]);
        printf(1, "exec failed!!\n");
        exit();
      } else {
        printf(1, "fork failed!!\n");
        exit();
      }
    }

    for (j = 0; j < k; j++) {
      wait();
    }
    printf(1, "\n%d test done\n\n", i+1);
  }

  exit();
}
