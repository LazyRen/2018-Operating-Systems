#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define NUM_THREAD       10
#define FILESIZE         (1600*1024)  // 1.6 MB
// #define FILESIZE         (100 * 1024)  // 1.6 MB
#define BUFSIZE          512
#define FSIZE_PER_THREAD ((FILESIZE) / (NUM_THREAD))

char *filepath = "myfile";
int fd; // Shared among threads

void pwritetest();
void pwriteholetest(int exclude);
void preadtest();
void preadholetest(int exclude);
void stresstest(int times);

int
main(int argc, char *argv[])
{
  printf(1, "\n1. Start pwrite test\n");
  pwritetest();
  printf(1, "Finished\n");

  printf(1, "\n2. Start pread test\n");
  preadtest();
  printf(1, "Finished\n");

  unlink(filepath);

  printf(1, "\n3. Start pwrite with hole test\n");;
  pwriteholetest(3);
  printf(1, "Finished\n");

  printf(1, "\n4, Start pwrite with hole test\n");
  preadholetest(3);
  printf(1, "Finished\n");

  // unlink(filepath);

  // printf(1, "\n5, Start pwrite stress test\n");
  // stresstest(100);
  // printf(1, "Finished\n");

  exit();
}


void
pwritetestmain(void *arg)
{
  int tid = (int) arg;
  int r, i, off;
  char data[BUFSIZE];

  if (tid == -1)
    thread_exit((void *)0);

  int start = FSIZE_PER_THREAD * tid;
  int end = start + FSIZE_PER_THREAD;

  for(i = 0; i < BUFSIZE; i++)
    data[i] = (tid + i) % 128;

  printf(1, "Thread #%d is writing (%d ~ %d)\n", tid, start, end);

  for (off = start; off < end; off+=BUFSIZE){
    if ((off / BUFSIZE) % 300 == 0){
      printf(1, "Thread %d: %d bytes written\n", tid, off - start);
    }
    if ((r = pwrite(fd, data, sizeof(data), off)) != sizeof(data)){
      printf(1, "pwrite returned %d : failed\n", r);
      exit();
    }
  }

  printf(1, "Thread %d: writing finished\n", tid);
  thread_exit((void *)0);
}

void
pwritetest()
{
  thread_t threads[NUM_THREAD];
  int i;
  void* retval;

  // Open file (file is shared among thread)
  fd = open(filepath, O_CREATE | O_RDWR);

  for (i = 0; i < NUM_THREAD; i++){
    if(thread_create(&threads[i], pwritetestmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      close(fd);
      return;
    }
  }

  // Make sure pwrite does not change offset of file
  char data[BUFSIZE];
  for(i = 0; i < BUFSIZE; i++)
    data[i] = i % 128;
  printf(1, "Main Thread is writing (0 ~ %d)\n", FSIZE_PER_THREAD);
  for (int off = 0; off < FSIZE_PER_THREAD; off+=BUFSIZE){
    if ((off / BUFSIZE) % 300 == 0){
      printf(1, "Main Thread: %d bytes written\n", off);
    }
    int r;
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
      printf(1, "pwrite returned %d : failed\n", r);
      exit();
    }
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      close(fd);
      return;
    }
  }
  close(fd);
}

void
pwriteholetest(int exclude)
{
  thread_t threads[NUM_THREAD];
  int i;
  void* retval;

  // Open file (file is shared among thread)
  fd = open(filepath, O_CREATE | O_RDWR);

  for (i = 0; i < NUM_THREAD; i++){
    if (i == exclude) {
        if (thread_create(&threads[i], pwritetestmain, (void*)(-1)) != 0){
        printf(1, "panic at thread_create\n");
        close(fd);
        return;
      }
    }
    else if (thread_create(&threads[i], pwritetestmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      close(fd);
      return;
    }
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (i == exclude)
      continue;
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      close(fd);
      return;
    }
  }
  close(fd);
}

void
preadtestmain(void *arg)
{
  int tid = (int) arg;
  int r, off, i;
  char buf[BUFSIZE];

  int start = FSIZE_PER_THREAD * tid;
  int end = start + FSIZE_PER_THREAD;

  printf(1, "Thread #%d is reading (%d ~ %d)\n", tid, start, end);

  for (off = start; off < end; off+=BUFSIZE){
    if ((r = pread(fd, buf, sizeof(buf), off)) != sizeof(buf)){
      printf(1, "pread returned %d : failed\n", r);
      exit();
    }
    for (i = 0; i < BUFSIZE; i++) {
      if (buf[i] != (tid + i) % 128) {
        printf(1, "data inconsistency detected from tid %d at %d %d:%d\n", tid, i, buf[i], (tid+i) % 128);
        exit();
      }
    }
  }
  thread_exit((void *)0);
}

void
preadtest()
{
  thread_t threads[NUM_THREAD];
  int i;
  void* retval;

  // Open file (file is shared among thread)
  fd = open(filepath, O_RDONLY);

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], preadtestmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      close(fd);
      return;
    }
  }

  char buf[BUFSIZE];
  printf(1, "Main Thread is reading (0 ~ %d)\n", FSIZE_PER_THREAD);
  for (int off = 0; off < FSIZE_PER_THREAD; off+=BUFSIZE){
    int r;
    if ((r = read(fd, buf, sizeof(buf))) != sizeof(buf)){
      printf(1, "pread returned %d : failed\n", r);
      exit();
    }
    for (i = 0; i < BUFSIZE; i++) {
      if (buf[i] != i % 128) {
        printf(1, "data inconsistency detected from main thread at %d %d:%d\n", i, buf[i], i % 128);
        exit();
      }
    }
  }
  printf(1, "Main Thread reading finished\n");

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      close(fd);
      return;
    }
  }
  close(fd);
}

void
preadholetestmain(void *arg)
{
  int tid = (int) arg;
  int r, off, i;
  char buf[BUFSIZE];

  int start = FSIZE_PER_THREAD * tid;
  int end = start + FSIZE_PER_THREAD;

  printf(1, "Thread #%d is reading (%d ~ %d)\n", tid, start, end);

  for (off = start; off < end; off+=BUFSIZE){
    if ((r = pread(fd, buf, sizeof(buf), off)) != sizeof(buf)){
      printf(1, "pread returned %d : failed\n", r);
      exit();
    }
    for (i = 0; i < BUFSIZE; i++) {
      if (buf[i] != 0) {
        printf(1, "data inconsistency detected from tid %d at %d %d:%d\n", tid, i, buf[i], (tid+i) % 128);
        exit();
      }
    }
  }

  thread_exit((void *)0);
}

void
preadholetest(int exclude)
{
  thread_t threads[NUM_THREAD];
  int i;
  void* retval;

  // Open file (file is shared among thread)
  fd = open(filepath, O_RDONLY);

  for (i = 0; i < NUM_THREAD; i++){
    if (i == exclude) {
      if (thread_create(&threads[i], preadholetestmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        close(fd);
        return;
      }
      continue;
    }
    if (thread_create(&threads[i], preadtestmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      close(fd);
      return;
    }
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      close(fd);
      return;
    }
  }
  close(fd);
}

void
stresstest(int times)
{
  int r, off;
  char buf[BUFSIZE], data[BUFSIZE];

  for (int t = 0; t < times; t++) {
    fd = open(filepath, O_CREATE | O_RDWR);
    int skip = t % NUM_THREAD;
    for (int j = NUM_THREAD-1; j >= 0; j--) {
      int start = FSIZE_PER_THREAD * j;
      int end = start + FSIZE_PER_THREAD;
      if (j == skip)
        continue;

      for(int i = 0; i < BUFSIZE; i++)
        data[i] = (j + i) % 128;

      for (off = start; off < end; off+=BUFSIZE){
        if ((r = pwrite(fd, data, sizeof(data), off)) != sizeof(data)){
          printf(1, "pwrite returned %d : failed\n", r);
          exit();
        }
      }
    }

    for (int j = NUM_THREAD-1; j >= 0; j--) {
      int start = FSIZE_PER_THREAD * j;
      int end = start + FSIZE_PER_THREAD;
      if (j == skip)
        continue;

      for (off = start; off < end; off+=BUFSIZE){
        if ((r = pread(fd, buf, sizeof(buf), off)) != sizeof(buf)){
          printf(1, "pread returned %d : failed\n", r);
          exit();
        }
        for (int i = 0; i < BUFSIZE; i++) {
          if (j == skip) {
            if (buf[i] != 0) {
              printf(1, "data inconsistency detected from hole\n");
              exit();
            }
          }
          else {
            if (buf[i] != (j + i) % 128) {
              printf(1, "data inconsistency detected at %d trial\n", i+1);
              exit();
            }
          }
        }
      }
    }
    printf(1, "%d times finished\n", t+1);
    close(fd);
    unlink(filepath);
  }
}
