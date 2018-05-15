struct node {
	struct proc *p;
	struct node *next;
	struct node *prev;
};

struct queue {
  struct node *front;
  struct node *end;
  int size;
};

struct mlfqueue {
  int isInit;
  struct queue *q0;
  struct queue *q1;
  struct queue *q2;
};

struct queue* initqueue();
void push(struct queue *q, struct proc *p);
struct proc* top(struct queue *q);
struct proc* pop(struct queue *q);
int isEmpty(struct queue *q);
