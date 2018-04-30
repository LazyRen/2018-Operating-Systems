#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "umalloc.c"
#include "queue.h"
//included all headers from proc.c + umalloc.c

struct queue*
initqueue()
{
	struct queue *newQueue;
	newQueue = malloc(sizeof(struct queue));
	newQueue->front = newQueue->end = NULL;
	newQueue->size = 0;
	return newQueue;
}

void
push(struct queue *q, struct proc *p)
{
	struct node *newNode;
	newNode = malloc(sizerof(struct node));
	newNode->p = p;
	newNode->next = newNode->prev = NULL;
	if (q->front == NULL) {
		q->front = q->end = newNode;
		q->size += 1;
	}
	else {
		newNode->prev = q->end;
		q->end->next = newNode;
		q->end = newNode;
		q->size += 1;
	}
}

struct node*
top(struct queue *q)
{
	struct node *cur;
	struct proc *ret;

	if (q->front == NULL)
		return NULL;

	return q->front;
}

void
pop(struct queue *q)
{
	struct node *cur;

	if (q->front == NULL)
		return NULL;
	cur = q->front;
	ret = q->front->p;
	if (cur->next)
		cur->next->prev = NULL;
	q->front = cur->next;
	q->size -= 1;
	free(cur);
}

//if queue is empty return 1 else return 0
int
isEmpty(struct queue *q)
{
	if (q->size != 0)
		return 0;
	else
		return 1;
}
