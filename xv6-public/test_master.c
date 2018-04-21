/**
 *  This program runs child test programs concurrently.
 */

#include "types.h"
#include "stat.h"
#include "user.h"

#define CNT_TEST					6
// Number of child programs
#define CNT_CHILD           15
#define CNT_EXCEED          5

// Name of child test program that tests Stride scheduler
#define NAME_CHILD_STRIDE   "test_stride"
// Name of child test program that tests MLFQ scheduler
#define NAME_CHILD_MLFQ     "test_mlfq"
#define NOOP					"NOOP"

char *child_argv[CNT_TEST][CNT_CHILD][3] = {
	{ {NOOP, 0, 0},
	  {NOOP, 0, 0},

	}
  { {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_STRIDE, "20", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_STRIDE, "30", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_STRIDE, "10", 0} },
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
    {NAME_CHILD_STRIDE, "10", 0},
    {NAME_CHILD_STRIDE, "5", 0},
    {NAME_CHILD_STRIDE, "3", 0},
    {NAME_CHILD_STRIDE, "6", 0},
    {NAME_CHILD_STRIDE, "1", 0} },
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
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "0", 0},},
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
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},
    {NAME_CHILD_MLFQ, "0", 0},},
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
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},
    {NAME_CHILD_MLFQ, "1", 0},},
};

char *exceed_argv[CNT_CHILD][3] = {
  {NAME_CHILD_STRIDE, "10", 0},
  {NAME_CHILD_STRIDE, "20", 0},
  {NAME_CHILD_STRIDE, "30", 0},
  {NAME_CHILD_STRIDE, "15", 0},
  {NAME_CHILD_STRIDE, "6", 0},
};

int
main(int argc, char *argv[])
{
  int pid;
  int i, j;
  for (i = 0; i < CNT_TEST; i++) {
    for (j = 0; j < CNT_CHILD; j++) {
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

    for (i = 0; i < CNT_CHILD; i++) {
      wait();
    }
    printf("\n%d test done\n\n", i+1)
  }
  for (i = 0; i < CNT_EXCEED; i++) {
    pid = fork();
    if (pid > 0) {
      // parent
      continue;
    } else if (pid == 0) {
      // child
      exec(exceed_argv[i][0], exceed_argv[i]);
      printf(1, "exec failed!!\n");
      exit();
    } else {
      printf(1, "fork failed!!\n");
      exit();
    }
  }
  for (i = 0; i < CNT_EXCEED; i++) {
    wait();
  }
  exit();
}
