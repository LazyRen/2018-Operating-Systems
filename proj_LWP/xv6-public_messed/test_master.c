/**
 *  This program runs child test programs concurrently.
 */

#include "types.h"
#include "stat.h"
#include "user.h"

#define CNT_TEST					15
// Number of child programs
#define CNT_CHILD           11
#define CNT_EXCEED          5

// Name of child test program that tests Stride scheduler
#define NAME_CHILD_STRIDE   "test_stride"
// Name of child test program that tests MLFQ scheduler
#define NAME_CHILD_MLFQ     "test_mlfq"
#define NOOP					"NOOP"

char *child_argv[CNT_TEST][CNT_CHILD][3] = {
  //MLFQ Only Testing
	{ {NAME_CHILD_MLFQ, "0", 0},
    {NOOP, 0, 0} },// 1
  { {NAME_CHILD_MLFQ, "1", 0},
    {NOOP, 0, 0} },// 2
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NOOP, 0, 0} },// 3
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NOOP, 0, 0} },// 4
  { {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NOOP, 0, 0} },// 5
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NOOP, 0, 0} },// 6

  //STRIDE Only Testing
  { {NAME_CHILD_STRIDE, "40", 0},
    {NOOP, 0, 0} },// 7
  { {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_STRIDE, "30", 0},
    {NAME_CHILD_STRIDE, "40", 0},
    {NOOP, 0, 0} },// 8
  { {NAME_CHILD_STRIDE, "1", 0},
    {NAME_CHILD_STRIDE, "2", 0},
    {NAME_CHILD_STRIDE, "3", 0},
    {NAME_CHILD_STRIDE, "4", 0},
    {NAME_CHILD_STRIDE, "5", 0},
    {NAME_CHILD_STRIDE, "6", 0},
    {NAME_CHILD_STRIDE, "7", 0},
    {NAME_CHILD_STRIDE, "8", 0},
    {NAME_CHILD_STRIDE, "9", 0},
    {NAME_CHILD_STRIDE, "10", 0},
    {NOOP, 0, 0} },// 9
  { {NAME_CHILD_STRIDE, "80", 0},
    {NOOP, 0, 0} },// 10

  //Stride Out of Limit
  { {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_STRIDE, "20", 0},
    {NAME_CHILD_STRIDE, "30", 0},
    {NAME_CHILD_STRIDE, "15", 0},
    {NAME_CHILD_STRIDE, "6", 0},
    {NOOP, 0, 0} },// 11
  { {NAME_CHILD_STRIDE, "81", 0},
    {NOOP, 0, 0} },// 12

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
    {NAME_CHILD_STRIDE, "30", 0},
    {NOOP, 0, 0} },// 13
  { {NAME_CHILD_STRIDE, "81", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NOOP, 0, 0} },// 14
  { {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_STRIDE, "20", 0},
    {NAME_CHILD_STRIDE, "30", 0},
    {NAME_CHILD_STRIDE, "15", 0},
    {NAME_CHILD_STRIDE, "6", 0},
    {NOOP, 0, 0} },// 15
};

int
main(int argc, char *argv[])
{
  int pid;
  int i, j, k, stride, mlfq;
  for (i = 7; i < CNT_TEST; i++) {
    mlfq = stride = k = 0;
    for (j = 0; j < CNT_CHILD; j++) {
      if (!strcmp(child_argv[i][j][0], NOOP))
        break;
      else if (!strcmp(child_argv[i][j][0], NAME_CHILD_MLFQ))
        mlfq++;
      else if (!strcmp(child_argv[i][j][0], NAME_CHILD_STRIDE))
        stride++;
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
      }
        exit();
    }

    for (j = 0; j < k; j++) {
      wait();
    }
    printf(1, "\nMLFQ: %d STRIDE: %d\nTOTAL:%d procs\ntest %d done\n\n", mlfq, stride, mlfq+stride, i+1);
  }

  exit();
}
