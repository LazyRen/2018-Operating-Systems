
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 c6 10 80       	mov    $0x8010c630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 5e 38 10 80       	mov    $0x8010385e,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 f0 82 10 80       	push   $0x801082f0
80100042:	68 40 c6 10 80       	push   $0x8010c640
80100047:	e8 ee 4e 00 00       	call   80104f3a <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
80100056:	0d 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
80100060:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
8010006a:	eb 47                	jmp    801000b3 <binit+0x7f>
    b->next = bcache.head.next;
8010006c:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	83 c0 0c             	add    $0xc,%eax
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	68 f7 82 10 80       	push   $0x801082f7
80100090:	50                   	push   %eax
80100091:	e8 47 4d 00 00       	call   80104ddd <initsleeplock>
80100096:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
80100099:	a1 90 0d 11 80       	mov    0x80110d90,%eax
8010009e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ac:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b3:	b8 3c 0d 11 80       	mov    $0x80110d3c,%eax
801000b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bb:	72 af                	jb     8010006c <binit+0x38>
  }
}
801000bd:	90                   	nop
801000be:	c9                   	leave  
801000bf:	c3                   	ret    

801000c0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c6:	83 ec 0c             	sub    $0xc,%esp
801000c9:	68 40 c6 10 80       	push   $0x8010c640
801000ce:	e8 89 4e 00 00       	call   80104f5c <acquire>
801000d3:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d6:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801000db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000de:	eb 58                	jmp    80100138 <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
801000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e3:	8b 40 04             	mov    0x4(%eax),%eax
801000e6:	39 45 08             	cmp    %eax,0x8(%ebp)
801000e9:	75 44                	jne    8010012f <bget+0x6f>
801000eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ee:	8b 40 08             	mov    0x8(%eax),%eax
801000f1:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000f4:	75 39                	jne    8010012f <bget+0x6f>
      b->refcnt++;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 40 4c             	mov    0x4c(%eax),%eax
801000fc:	8d 50 01             	lea    0x1(%eax),%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 40 c6 10 80       	push   $0x8010c640
8010010d:	e8 b8 4e 00 00       	call   80104fca <release>
80100112:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	83 c0 0c             	add    $0xc,%eax
8010011b:	83 ec 0c             	sub    $0xc,%esp
8010011e:	50                   	push   %eax
8010011f:	e8 f5 4c 00 00       	call   80104e19 <acquiresleep>
80100124:	83 c4 10             	add    $0x10,%esp
      return b;
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	e9 9d 00 00 00       	jmp    801001cc <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 54             	mov    0x54(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
8010013f:	75 9f                	jne    801000e0 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 8c 0d 11 80       	mov    0x80110d8c,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 6b                	jmp    801001b6 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100151:	85 c0                	test   %eax,%eax
80100153:	75 58                	jne    801001ad <bget+0xed>
80100155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100158:	8b 00                	mov    (%eax),%eax
8010015a:	83 e0 04             	and    $0x4,%eax
8010015d:	85 c0                	test   %eax,%eax
8010015f:	75 4c                	jne    801001ad <bget+0xed>
      b->dev = dev;
80100161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100164:	8b 55 08             	mov    0x8(%ebp),%edx
80100167:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100170:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100186:	83 ec 0c             	sub    $0xc,%esp
80100189:	68 40 c6 10 80       	push   $0x8010c640
8010018e:	e8 37 4e 00 00       	call   80104fca <release>
80100193:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	83 c0 0c             	add    $0xc,%eax
8010019c:	83 ec 0c             	sub    $0xc,%esp
8010019f:	50                   	push   %eax
801001a0:	e8 74 4c 00 00       	call   80104e19 <acquiresleep>
801001a5:	83 c4 10             	add    $0x10,%esp
      return b;
801001a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ab:	eb 1f                	jmp    801001cc <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b0:	8b 40 50             	mov    0x50(%eax),%eax
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
801001bd:	75 8c                	jne    8010014b <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001bf:	83 ec 0c             	sub    $0xc,%esp
801001c2:	68 fe 82 10 80       	push   $0x801082fe
801001c7:	e8 d0 03 00 00       	call   8010059c <panic>
}
801001cc:	c9                   	leave  
801001cd:	c3                   	ret    

801001ce <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001ce:	55                   	push   %ebp
801001cf:	89 e5                	mov    %esp,%ebp
801001d1:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001d4:	83 ec 08             	sub    $0x8,%esp
801001d7:	ff 75 0c             	pushl  0xc(%ebp)
801001da:	ff 75 08             	pushl  0x8(%ebp)
801001dd:	e8 de fe ff ff       	call   801000c0 <bget>
801001e2:	83 c4 10             	add    $0x10,%esp
801001e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001eb:	8b 00                	mov    (%eax),%eax
801001ed:	83 e0 02             	and    $0x2,%eax
801001f0:	85 c0                	test   %eax,%eax
801001f2:	75 0e                	jne    80100202 <bread+0x34>
    iderw(b);
801001f4:	83 ec 0c             	sub    $0xc,%esp
801001f7:	ff 75 f4             	pushl  -0xc(%ebp)
801001fa:	e8 5c 27 00 00       	call   8010295b <iderw>
801001ff:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100202:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100205:	c9                   	leave  
80100206:	c3                   	ret    

80100207 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100207:	55                   	push   %ebp
80100208:	89 e5                	mov    %esp,%ebp
8010020a:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010020d:	8b 45 08             	mov    0x8(%ebp),%eax
80100210:	83 c0 0c             	add    $0xc,%eax
80100213:	83 ec 0c             	sub    $0xc,%esp
80100216:	50                   	push   %eax
80100217:	e8 af 4c 00 00       	call   80104ecb <holdingsleep>
8010021c:	83 c4 10             	add    $0x10,%esp
8010021f:	85 c0                	test   %eax,%eax
80100221:	75 0d                	jne    80100230 <bwrite+0x29>
    panic("bwrite");
80100223:	83 ec 0c             	sub    $0xc,%esp
80100226:	68 0f 83 10 80       	push   $0x8010830f
8010022b:	e8 6c 03 00 00       	call   8010059c <panic>
  b->flags |= B_DIRTY;
80100230:	8b 45 08             	mov    0x8(%ebp),%eax
80100233:	8b 00                	mov    (%eax),%eax
80100235:	83 c8 04             	or     $0x4,%eax
80100238:	89 c2                	mov    %eax,%edx
8010023a:	8b 45 08             	mov    0x8(%ebp),%eax
8010023d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010023f:	83 ec 0c             	sub    $0xc,%esp
80100242:	ff 75 08             	pushl  0x8(%ebp)
80100245:	e8 11 27 00 00       	call   8010295b <iderw>
8010024a:	83 c4 10             	add    $0x10,%esp
}
8010024d:	90                   	nop
8010024e:	c9                   	leave  
8010024f:	c3                   	ret    

80100250 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100256:	8b 45 08             	mov    0x8(%ebp),%eax
80100259:	83 c0 0c             	add    $0xc,%eax
8010025c:	83 ec 0c             	sub    $0xc,%esp
8010025f:	50                   	push   %eax
80100260:	e8 66 4c 00 00       	call   80104ecb <holdingsleep>
80100265:	83 c4 10             	add    $0x10,%esp
80100268:	85 c0                	test   %eax,%eax
8010026a:	75 0d                	jne    80100279 <brelse+0x29>
    panic("brelse");
8010026c:	83 ec 0c             	sub    $0xc,%esp
8010026f:	68 16 83 10 80       	push   $0x80108316
80100274:	e8 23 03 00 00       	call   8010059c <panic>

  releasesleep(&b->lock);
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	83 c0 0c             	add    $0xc,%eax
8010027f:	83 ec 0c             	sub    $0xc,%esp
80100282:	50                   	push   %eax
80100283:	e8 f5 4b 00 00       	call   80104e7d <releasesleep>
80100288:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
8010028b:	83 ec 0c             	sub    $0xc,%esp
8010028e:	68 40 c6 10 80       	push   $0x8010c640
80100293:	e8 c4 4c 00 00       	call   80104f5c <acquire>
80100298:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010029b:	8b 45 08             	mov    0x8(%ebp),%eax
8010029e:	8b 40 4c             	mov    0x4c(%eax),%eax
801002a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002aa:	8b 45 08             	mov    0x8(%ebp),%eax
801002ad:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 47                	jne    801002fb <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002b4:	8b 45 08             	mov    0x8(%ebp),%eax
801002b7:	8b 40 54             	mov    0x54(%eax),%eax
801002ba:	8b 55 08             	mov    0x8(%ebp),%edx
801002bd:	8b 52 50             	mov    0x50(%edx),%edx
801002c0:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002c3:	8b 45 08             	mov    0x8(%ebp),%eax
801002c6:	8b 40 50             	mov    0x50(%eax),%eax
801002c9:	8b 55 08             	mov    0x8(%ebp),%edx
801002cc:	8b 52 54             	mov    0x54(%edx),%edx
801002cf:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002d2:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    bcache.head.next->prev = b;
801002e8:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  }
  
  release(&bcache.lock);
801002fb:	83 ec 0c             	sub    $0xc,%esp
801002fe:	68 40 c6 10 80       	push   $0x8010c640
80100303:	e8 c2 4c 00 00       	call   80104fca <release>
80100308:	83 c4 10             	add    $0x10,%esp
}
8010030b:	90                   	nop
8010030c:	c9                   	leave  
8010030d:	c3                   	ret    

8010030e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010030e:	55                   	push   %ebp
8010030f:	89 e5                	mov    %esp,%ebp
80100311:	83 ec 14             	sub    $0x14,%esp
80100314:	8b 45 08             	mov    0x8(%ebp),%eax
80100317:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010031b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010031f:	89 c2                	mov    %eax,%edx
80100321:	ec                   	in     (%dx),%al
80100322:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80100325:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100329:	c9                   	leave  
8010032a:	c3                   	ret    

8010032b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010032b:	55                   	push   %ebp
8010032c:	89 e5                	mov    %esp,%ebp
8010032e:	83 ec 08             	sub    $0x8,%esp
80100331:	8b 55 08             	mov    0x8(%ebp),%edx
80100334:	8b 45 0c             	mov    0xc(%ebp),%eax
80100337:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010033b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010033e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100342:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100346:	ee                   	out    %al,(%dx)
}
80100347:	90                   	nop
80100348:	c9                   	leave  
80100349:	c3                   	ret    

8010034a <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010034a:	55                   	push   %ebp
8010034b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010034d:	fa                   	cli    
}
8010034e:	90                   	nop
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    

80100351 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100351:	55                   	push   %ebp
80100352:	89 e5                	mov    %esp,%ebp
80100354:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100357:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010035b:	74 1c                	je     80100379 <printint+0x28>
8010035d:	8b 45 08             	mov    0x8(%ebp),%eax
80100360:	c1 e8 1f             	shr    $0x1f,%eax
80100363:	0f b6 c0             	movzbl %al,%eax
80100366:	89 45 10             	mov    %eax,0x10(%ebp)
80100369:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036d:	74 0a                	je     80100379 <printint+0x28>
    x = -xx;
8010036f:	8b 45 08             	mov    0x8(%ebp),%eax
80100372:	f7 d8                	neg    %eax
80100374:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100377:	eb 06                	jmp    8010037f <printint+0x2e>
  else
    x = xx;
80100379:	8b 45 08             	mov    0x8(%ebp),%eax
8010037c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010037f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100386:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010038c:	ba 00 00 00 00       	mov    $0x0,%edx
80100391:	f7 f1                	div    %ecx
80100393:	89 d1                	mov    %edx,%ecx
80100395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100398:	8d 50 01             	lea    0x1(%eax),%edx
8010039b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010039e:	0f b6 91 04 90 10 80 	movzbl -0x7fef6ffc(%ecx),%edx
801003a5:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003af:	ba 00 00 00 00       	mov    $0x0,%edx
801003b4:	f7 f1                	div    %ecx
801003b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003bd:	75 c7                	jne    80100386 <printint+0x35>

  if(sign)
801003bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c3:	74 2a                	je     801003ef <printint+0x9e>
    buf[i++] = '-';
801003c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003c8:	8d 50 01             	lea    0x1(%eax),%edx
801003cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003ce:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003d3:	eb 1a                	jmp    801003ef <printint+0x9e>
    consputc(buf[i]);
801003d5:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003db:	01 d0                	add    %edx,%eax
801003dd:	0f b6 00             	movzbl (%eax),%eax
801003e0:	0f be c0             	movsbl %al,%eax
801003e3:	83 ec 0c             	sub    $0xc,%esp
801003e6:	50                   	push   %eax
801003e7:	e8 dd 03 00 00       	call   801007c9 <consputc>
801003ec:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003ef:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003f7:	79 dc                	jns    801003d5 <printint+0x84>
}
801003f9:	90                   	nop
801003fa:	c9                   	leave  
801003fb:	c3                   	ret    

801003fc <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003fc:	55                   	push   %ebp
801003fd:	89 e5                	mov    %esp,%ebp
801003ff:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100402:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
80100407:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010040a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010040e:	74 10                	je     80100420 <cprintf+0x24>
    acquire(&cons.lock);
80100410:	83 ec 0c             	sub    $0xc,%esp
80100413:	68 a0 b5 10 80       	push   $0x8010b5a0
80100418:	e8 3f 4b 00 00       	call   80104f5c <acquire>
8010041d:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100420:	8b 45 08             	mov    0x8(%ebp),%eax
80100423:	85 c0                	test   %eax,%eax
80100425:	75 0d                	jne    80100434 <cprintf+0x38>
    panic("null fmt");
80100427:	83 ec 0c             	sub    $0xc,%esp
8010042a:	68 1d 83 10 80       	push   $0x8010831d
8010042f:	e8 68 01 00 00       	call   8010059c <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100434:	8d 45 0c             	lea    0xc(%ebp),%eax
80100437:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010043a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100441:	e9 1a 01 00 00       	jmp    80100560 <cprintf+0x164>
    if(c != '%'){
80100446:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010044a:	74 13                	je     8010045f <cprintf+0x63>
      consputc(c);
8010044c:	83 ec 0c             	sub    $0xc,%esp
8010044f:	ff 75 e4             	pushl  -0x1c(%ebp)
80100452:	e8 72 03 00 00       	call   801007c9 <consputc>
80100457:	83 c4 10             	add    $0x10,%esp
      continue;
8010045a:	e9 fd 00 00 00       	jmp    8010055c <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
8010045f:	8b 55 08             	mov    0x8(%ebp),%edx
80100462:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100469:	01 d0                	add    %edx,%eax
8010046b:	0f b6 00             	movzbl (%eax),%eax
8010046e:	0f be c0             	movsbl %al,%eax
80100471:	25 ff 00 00 00       	and    $0xff,%eax
80100476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100479:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010047d:	0f 84 ff 00 00 00    	je     80100582 <cprintf+0x186>
      break;
    switch(c){
80100483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100486:	83 f8 70             	cmp    $0x70,%eax
80100489:	74 47                	je     801004d2 <cprintf+0xd6>
8010048b:	83 f8 70             	cmp    $0x70,%eax
8010048e:	7f 13                	jg     801004a3 <cprintf+0xa7>
80100490:	83 f8 25             	cmp    $0x25,%eax
80100493:	0f 84 98 00 00 00    	je     80100531 <cprintf+0x135>
80100499:	83 f8 64             	cmp    $0x64,%eax
8010049c:	74 14                	je     801004b2 <cprintf+0xb6>
8010049e:	e9 9d 00 00 00       	jmp    80100540 <cprintf+0x144>
801004a3:	83 f8 73             	cmp    $0x73,%eax
801004a6:	74 47                	je     801004ef <cprintf+0xf3>
801004a8:	83 f8 78             	cmp    $0x78,%eax
801004ab:	74 25                	je     801004d2 <cprintf+0xd6>
801004ad:	e9 8e 00 00 00       	jmp    80100540 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
801004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b5:	8d 50 04             	lea    0x4(%eax),%edx
801004b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bb:	8b 00                	mov    (%eax),%eax
801004bd:	83 ec 04             	sub    $0x4,%esp
801004c0:	6a 01                	push   $0x1
801004c2:	6a 0a                	push   $0xa
801004c4:	50                   	push   %eax
801004c5:	e8 87 fe ff ff       	call   80100351 <printint>
801004ca:	83 c4 10             	add    $0x10,%esp
      break;
801004cd:	e9 8a 00 00 00       	jmp    8010055c <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d5:	8d 50 04             	lea    0x4(%eax),%edx
801004d8:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004db:	8b 00                	mov    (%eax),%eax
801004dd:	83 ec 04             	sub    $0x4,%esp
801004e0:	6a 00                	push   $0x0
801004e2:	6a 10                	push   $0x10
801004e4:	50                   	push   %eax
801004e5:	e8 67 fe ff ff       	call   80100351 <printint>
801004ea:	83 c4 10             	add    $0x10,%esp
      break;
801004ed:	eb 6d                	jmp    8010055c <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004f2:	8d 50 04             	lea    0x4(%eax),%edx
801004f5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004f8:	8b 00                	mov    (%eax),%eax
801004fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100501:	75 22                	jne    80100525 <cprintf+0x129>
        s = "(null)";
80100503:	c7 45 ec 26 83 10 80 	movl   $0x80108326,-0x14(%ebp)
      for(; *s; s++)
8010050a:	eb 19                	jmp    80100525 <cprintf+0x129>
        consputc(*s);
8010050c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010050f:	0f b6 00             	movzbl (%eax),%eax
80100512:	0f be c0             	movsbl %al,%eax
80100515:	83 ec 0c             	sub    $0xc,%esp
80100518:	50                   	push   %eax
80100519:	e8 ab 02 00 00       	call   801007c9 <consputc>
8010051e:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100521:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100525:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100528:	0f b6 00             	movzbl (%eax),%eax
8010052b:	84 c0                	test   %al,%al
8010052d:	75 dd                	jne    8010050c <cprintf+0x110>
      break;
8010052f:	eb 2b                	jmp    8010055c <cprintf+0x160>
    case '%':
      consputc('%');
80100531:	83 ec 0c             	sub    $0xc,%esp
80100534:	6a 25                	push   $0x25
80100536:	e8 8e 02 00 00       	call   801007c9 <consputc>
8010053b:	83 c4 10             	add    $0x10,%esp
      break;
8010053e:	eb 1c                	jmp    8010055c <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100540:	83 ec 0c             	sub    $0xc,%esp
80100543:	6a 25                	push   $0x25
80100545:	e8 7f 02 00 00       	call   801007c9 <consputc>
8010054a:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	ff 75 e4             	pushl  -0x1c(%ebp)
80100553:	e8 71 02 00 00       	call   801007c9 <consputc>
80100558:	83 c4 10             	add    $0x10,%esp
      break;
8010055b:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010055c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100560:	8b 55 08             	mov    0x8(%ebp),%edx
80100563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100566:	01 d0                	add    %edx,%eax
80100568:	0f b6 00             	movzbl (%eax),%eax
8010056b:	0f be c0             	movsbl %al,%eax
8010056e:	25 ff 00 00 00       	and    $0xff,%eax
80100573:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100576:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010057a:	0f 85 c6 fe ff ff    	jne    80100446 <cprintf+0x4a>
80100580:	eb 01                	jmp    80100583 <cprintf+0x187>
      break;
80100582:	90                   	nop
    }
  }

  if(locking)
80100583:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100587:	74 10                	je     80100599 <cprintf+0x19d>
    release(&cons.lock);
80100589:	83 ec 0c             	sub    $0xc,%esp
8010058c:	68 a0 b5 10 80       	push   $0x8010b5a0
80100591:	e8 34 4a 00 00       	call   80104fca <release>
80100596:	83 c4 10             	add    $0x10,%esp
}
80100599:	90                   	nop
8010059a:	c9                   	leave  
8010059b:	c3                   	ret    

8010059c <panic>:

void
panic(char *s)
{
8010059c:	55                   	push   %ebp
8010059d:	89 e5                	mov    %esp,%ebp
8010059f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005a2:	e8 a3 fd ff ff       	call   8010034a <cli>
  cons.locking = 0;
801005a7:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
801005ae:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005b1:	e8 34 2a 00 00       	call   80102fea <lapicid>
801005b6:	83 ec 08             	sub    $0x8,%esp
801005b9:	50                   	push   %eax
801005ba:	68 2d 83 10 80       	push   $0x8010832d
801005bf:	e8 38 fe ff ff       	call   801003fc <cprintf>
801005c4:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005c7:	8b 45 08             	mov    0x8(%ebp),%eax
801005ca:	83 ec 0c             	sub    $0xc,%esp
801005cd:	50                   	push   %eax
801005ce:	e8 29 fe ff ff       	call   801003fc <cprintf>
801005d3:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005d6:	83 ec 0c             	sub    $0xc,%esp
801005d9:	68 41 83 10 80       	push   $0x80108341
801005de:	e8 19 fe ff ff       	call   801003fc <cprintf>
801005e3:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005e6:	83 ec 08             	sub    $0x8,%esp
801005e9:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005ec:	50                   	push   %eax
801005ed:	8d 45 08             	lea    0x8(%ebp),%eax
801005f0:	50                   	push   %eax
801005f1:	e8 26 4a 00 00       	call   8010501c <getcallerpcs>
801005f6:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100600:	eb 1c                	jmp    8010061e <panic+0x82>
    cprintf(" %p", pcs[i]);
80100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100605:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100609:	83 ec 08             	sub    $0x8,%esp
8010060c:	50                   	push   %eax
8010060d:	68 43 83 10 80       	push   $0x80108343
80100612:	e8 e5 fd ff ff       	call   801003fc <cprintf>
80100617:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
8010061a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010061e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100622:	7e de                	jle    80100602 <panic+0x66>
  panicked = 1; // freeze other CPU
80100624:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
8010062b:	00 00 00 
  for(;;)
8010062e:	eb fe                	jmp    8010062e <panic+0x92>

80100630 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	53                   	push   %ebx
80100634:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100637:	6a 0e                	push   $0xe
80100639:	68 d4 03 00 00       	push   $0x3d4
8010063e:	e8 e8 fc ff ff       	call   8010032b <outb>
80100643:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100646:	68 d5 03 00 00       	push   $0x3d5
8010064b:	e8 be fc ff ff       	call   8010030e <inb>
80100650:	83 c4 04             	add    $0x4,%esp
80100653:	0f b6 c0             	movzbl %al,%eax
80100656:	c1 e0 08             	shl    $0x8,%eax
80100659:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010065c:	6a 0f                	push   $0xf
8010065e:	68 d4 03 00 00       	push   $0x3d4
80100663:	e8 c3 fc ff ff       	call   8010032b <outb>
80100668:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010066b:	68 d5 03 00 00       	push   $0x3d5
80100670:	e8 99 fc ff ff       	call   8010030e <inb>
80100675:	83 c4 04             	add    $0x4,%esp
80100678:	0f b6 c0             	movzbl %al,%eax
8010067b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010067e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100682:	75 30                	jne    801006b4 <cgaputc+0x84>
    pos += 80 - pos%80;
80100684:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100687:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010068c:	89 c8                	mov    %ecx,%eax
8010068e:	f7 ea                	imul   %edx
80100690:	c1 fa 05             	sar    $0x5,%edx
80100693:	89 c8                	mov    %ecx,%eax
80100695:	c1 f8 1f             	sar    $0x1f,%eax
80100698:	29 c2                	sub    %eax,%edx
8010069a:	89 d0                	mov    %edx,%eax
8010069c:	c1 e0 02             	shl    $0x2,%eax
8010069f:	01 d0                	add    %edx,%eax
801006a1:	c1 e0 04             	shl    $0x4,%eax
801006a4:	29 c1                	sub    %eax,%ecx
801006a6:	89 ca                	mov    %ecx,%edx
801006a8:	b8 50 00 00 00       	mov    $0x50,%eax
801006ad:	29 d0                	sub    %edx,%eax
801006af:	01 45 f4             	add    %eax,-0xc(%ebp)
801006b2:	eb 38                	jmp    801006ec <cgaputc+0xbc>
  else if(c == BACKSPACE){
801006b4:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006bb:	75 0c                	jne    801006c9 <cgaputc+0x99>
    if(pos > 0) --pos;
801006bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006c1:	7e 29                	jle    801006ec <cgaputc+0xbc>
801006c3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006c7:	eb 23                	jmp    801006ec <cgaputc+0xbc>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	0f b6 c0             	movzbl %al,%eax
801006cf:	80 cc 07             	or     $0x7,%ah
801006d2:	89 c3                	mov    %eax,%ebx
801006d4:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006dd:	8d 50 01             	lea    0x1(%eax),%edx
801006e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006e3:	01 c0                	add    %eax,%eax
801006e5:	01 c8                	add    %ecx,%eax
801006e7:	89 da                	mov    %ebx,%edx
801006e9:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006f0:	78 09                	js     801006fb <cgaputc+0xcb>
801006f2:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006f9:	7e 0d                	jle    80100708 <cgaputc+0xd8>
    panic("pos under/overflow");
801006fb:	83 ec 0c             	sub    $0xc,%esp
801006fe:	68 47 83 10 80       	push   $0x80108347
80100703:	e8 94 fe ff ff       	call   8010059c <panic>

  if((pos/80) >= 24){  // Scroll up.
80100708:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010070f:	7e 4c                	jle    8010075d <cgaputc+0x12d>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100711:	a1 00 90 10 80       	mov    0x80109000,%eax
80100716:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010071c:	a1 00 90 10 80       	mov    0x80109000,%eax
80100721:	83 ec 04             	sub    $0x4,%esp
80100724:	68 60 0e 00 00       	push   $0xe60
80100729:	52                   	push   %edx
8010072a:	50                   	push   %eax
8010072b:	e8 62 4b 00 00       	call   80105292 <memmove>
80100730:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100733:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100737:	b8 80 07 00 00       	mov    $0x780,%eax
8010073c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010073f:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100742:	a1 00 90 10 80       	mov    0x80109000,%eax
80100747:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010074a:	01 c9                	add    %ecx,%ecx
8010074c:	01 c8                	add    %ecx,%eax
8010074e:	83 ec 04             	sub    $0x4,%esp
80100751:	52                   	push   %edx
80100752:	6a 00                	push   $0x0
80100754:	50                   	push   %eax
80100755:	e8 79 4a 00 00       	call   801051d3 <memset>
8010075a:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
8010075d:	83 ec 08             	sub    $0x8,%esp
80100760:	6a 0e                	push   $0xe
80100762:	68 d4 03 00 00       	push   $0x3d4
80100767:	e8 bf fb ff ff       	call   8010032b <outb>
8010076c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010076f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100772:	c1 f8 08             	sar    $0x8,%eax
80100775:	0f b6 c0             	movzbl %al,%eax
80100778:	83 ec 08             	sub    $0x8,%esp
8010077b:	50                   	push   %eax
8010077c:	68 d5 03 00 00       	push   $0x3d5
80100781:	e8 a5 fb ff ff       	call   8010032b <outb>
80100786:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100789:	83 ec 08             	sub    $0x8,%esp
8010078c:	6a 0f                	push   $0xf
8010078e:	68 d4 03 00 00       	push   $0x3d4
80100793:	e8 93 fb ff ff       	call   8010032b <outb>
80100798:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010079b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010079e:	0f b6 c0             	movzbl %al,%eax
801007a1:	83 ec 08             	sub    $0x8,%esp
801007a4:	50                   	push   %eax
801007a5:	68 d5 03 00 00       	push   $0x3d5
801007aa:	e8 7c fb ff ff       	call   8010032b <outb>
801007af:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007b2:	a1 00 90 10 80       	mov    0x80109000,%eax
801007b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007ba:	01 d2                	add    %edx,%edx
801007bc:	01 d0                	add    %edx,%eax
801007be:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007c3:	90                   	nop
801007c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007c7:	c9                   	leave  
801007c8:	c3                   	ret    

801007c9 <consputc>:

void
consputc(int c)
{
801007c9:	55                   	push   %ebp
801007ca:	89 e5                	mov    %esp,%ebp
801007cc:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007cf:	a1 80 b5 10 80       	mov    0x8010b580,%eax
801007d4:	85 c0                	test   %eax,%eax
801007d6:	74 07                	je     801007df <consputc+0x16>
    cli();
801007d8:	e8 6d fb ff ff       	call   8010034a <cli>
    for(;;)
801007dd:	eb fe                	jmp    801007dd <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007df:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007e6:	75 29                	jne    80100811 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	6a 08                	push   $0x8
801007ed:	e8 bb 62 00 00       	call   80106aad <uartputc>
801007f2:	83 c4 10             	add    $0x10,%esp
801007f5:	83 ec 0c             	sub    $0xc,%esp
801007f8:	6a 20                	push   $0x20
801007fa:	e8 ae 62 00 00       	call   80106aad <uartputc>
801007ff:	83 c4 10             	add    $0x10,%esp
80100802:	83 ec 0c             	sub    $0xc,%esp
80100805:	6a 08                	push   $0x8
80100807:	e8 a1 62 00 00       	call   80106aad <uartputc>
8010080c:	83 c4 10             	add    $0x10,%esp
8010080f:	eb 0e                	jmp    8010081f <consputc+0x56>
  } else
    uartputc(c);
80100811:	83 ec 0c             	sub    $0xc,%esp
80100814:	ff 75 08             	pushl  0x8(%ebp)
80100817:	e8 91 62 00 00       	call   80106aad <uartputc>
8010081c:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010081f:	83 ec 0c             	sub    $0xc,%esp
80100822:	ff 75 08             	pushl  0x8(%ebp)
80100825:	e8 06 fe ff ff       	call   80100630 <cgaputc>
8010082a:	83 c4 10             	add    $0x10,%esp
}
8010082d:	90                   	nop
8010082e:	c9                   	leave  
8010082f:	c3                   	ret    

80100830 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100830:	55                   	push   %ebp
80100831:	89 e5                	mov    %esp,%ebp
80100833:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
8010083d:	83 ec 0c             	sub    $0xc,%esp
80100840:	68 a0 b5 10 80       	push   $0x8010b5a0
80100845:	e8 12 47 00 00       	call   80104f5c <acquire>
8010084a:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010084d:	e9 44 01 00 00       	jmp    80100996 <consoleintr+0x166>
    switch(c){
80100852:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100855:	83 f8 10             	cmp    $0x10,%eax
80100858:	74 1e                	je     80100878 <consoleintr+0x48>
8010085a:	83 f8 10             	cmp    $0x10,%eax
8010085d:	7f 0a                	jg     80100869 <consoleintr+0x39>
8010085f:	83 f8 08             	cmp    $0x8,%eax
80100862:	74 6b                	je     801008cf <consoleintr+0x9f>
80100864:	e9 9b 00 00 00       	jmp    80100904 <consoleintr+0xd4>
80100869:	83 f8 15             	cmp    $0x15,%eax
8010086c:	74 33                	je     801008a1 <consoleintr+0x71>
8010086e:	83 f8 7f             	cmp    $0x7f,%eax
80100871:	74 5c                	je     801008cf <consoleintr+0x9f>
80100873:	e9 8c 00 00 00       	jmp    80100904 <consoleintr+0xd4>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100878:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010087f:	e9 12 01 00 00       	jmp    80100996 <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100884:	a1 28 10 11 80       	mov    0x80111028,%eax
80100889:	83 e8 01             	sub    $0x1,%eax
8010088c:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100891:	83 ec 0c             	sub    $0xc,%esp
80100894:	68 00 01 00 00       	push   $0x100
80100899:	e8 2b ff ff ff       	call   801007c9 <consputc>
8010089e:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
801008a1:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801008a7:	a1 24 10 11 80       	mov    0x80111024,%eax
801008ac:	39 c2                	cmp    %eax,%edx
801008ae:	0f 84 e2 00 00 00    	je     80100996 <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b4:	a1 28 10 11 80       	mov    0x80111028,%eax
801008b9:	83 e8 01             	sub    $0x1,%eax
801008bc:	83 e0 7f             	and    $0x7f,%eax
801008bf:	0f b6 80 a0 0f 11 80 	movzbl -0x7feef060(%eax),%eax
      while(input.e != input.w &&
801008c6:	3c 0a                	cmp    $0xa,%al
801008c8:	75 ba                	jne    80100884 <consoleintr+0x54>
      }
      break;
801008ca:	e9 c7 00 00 00       	jmp    80100996 <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008cf:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801008d5:	a1 24 10 11 80       	mov    0x80111024,%eax
801008da:	39 c2                	cmp    %eax,%edx
801008dc:	0f 84 b4 00 00 00    	je     80100996 <consoleintr+0x166>
        input.e--;
801008e2:	a1 28 10 11 80       	mov    0x80111028,%eax
801008e7:	83 e8 01             	sub    $0x1,%eax
801008ea:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
801008ef:	83 ec 0c             	sub    $0xc,%esp
801008f2:	68 00 01 00 00       	push   $0x100
801008f7:	e8 cd fe ff ff       	call   801007c9 <consputc>
801008fc:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008ff:	e9 92 00 00 00       	jmp    80100996 <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100904:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100908:	0f 84 87 00 00 00    	je     80100995 <consoleintr+0x165>
8010090e:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100914:	a1 20 10 11 80       	mov    0x80111020,%eax
80100919:	29 c2                	sub    %eax,%edx
8010091b:	89 d0                	mov    %edx,%eax
8010091d:	83 f8 7f             	cmp    $0x7f,%eax
80100920:	77 73                	ja     80100995 <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
80100922:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100926:	74 05                	je     8010092d <consoleintr+0xfd>
80100928:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010092b:	eb 05                	jmp    80100932 <consoleintr+0x102>
8010092d:	b8 0a 00 00 00       	mov    $0xa,%eax
80100932:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100935:	a1 28 10 11 80       	mov    0x80111028,%eax
8010093a:	8d 50 01             	lea    0x1(%eax),%edx
8010093d:	89 15 28 10 11 80    	mov    %edx,0x80111028
80100943:	83 e0 7f             	and    $0x7f,%eax
80100946:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100949:	88 90 a0 0f 11 80    	mov    %dl,-0x7feef060(%eax)
        consputc(c);
8010094f:	83 ec 0c             	sub    $0xc,%esp
80100952:	ff 75 f0             	pushl  -0x10(%ebp)
80100955:	e8 6f fe ff ff       	call   801007c9 <consputc>
8010095a:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010095d:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100961:	74 18                	je     8010097b <consoleintr+0x14b>
80100963:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100967:	74 12                	je     8010097b <consoleintr+0x14b>
80100969:	a1 28 10 11 80       	mov    0x80111028,%eax
8010096e:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100974:	83 ea 80             	sub    $0xffffff80,%edx
80100977:	39 d0                	cmp    %edx,%eax
80100979:	75 1a                	jne    80100995 <consoleintr+0x165>
          input.w = input.e;
8010097b:	a1 28 10 11 80       	mov    0x80111028,%eax
80100980:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
80100985:	83 ec 0c             	sub    $0xc,%esp
80100988:	68 20 10 11 80       	push   $0x80111020
8010098d:	e8 97 42 00 00       	call   80104c29 <wakeup>
80100992:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100995:	90                   	nop
  while((c = getc()) >= 0){
80100996:	8b 45 08             	mov    0x8(%ebp),%eax
80100999:	ff d0                	call   *%eax
8010099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010099e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009a2:	0f 89 aa fe ff ff    	jns    80100852 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
801009a8:	83 ec 0c             	sub    $0xc,%esp
801009ab:	68 a0 b5 10 80       	push   $0x8010b5a0
801009b0:	e8 15 46 00 00       	call   80104fca <release>
801009b5:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009bc:	74 05                	je     801009c3 <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
801009be:	e8 21 43 00 00       	call   80104ce4 <procdump>
  }
}
801009c3:	90                   	nop
801009c4:	c9                   	leave  
801009c5:	c3                   	ret    

801009c6 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009c6:	55                   	push   %ebp
801009c7:	89 e5                	mov    %esp,%ebp
801009c9:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009cc:	83 ec 0c             	sub    $0xc,%esp
801009cf:	ff 75 08             	pushl  0x8(%ebp)
801009d2:	e8 50 11 00 00       	call   80101b27 <iunlock>
801009d7:	83 c4 10             	add    $0x10,%esp
  target = n;
801009da:	8b 45 10             	mov    0x10(%ebp),%eax
801009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009e0:	83 ec 0c             	sub    $0xc,%esp
801009e3:	68 a0 b5 10 80       	push   $0x8010b5a0
801009e8:	e8 6f 45 00 00       	call   80104f5c <acquire>
801009ed:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009f0:	e9 ab 00 00 00       	jmp    80100aa0 <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009f5:	e8 92 38 00 00       	call   8010428c <myproc>
801009fa:	8b 40 24             	mov    0x24(%eax),%eax
801009fd:	85 c0                	test   %eax,%eax
801009ff:	74 28                	je     80100a29 <consoleread+0x63>
        release(&cons.lock);
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	68 a0 b5 10 80       	push   $0x8010b5a0
80100a09:	e8 bc 45 00 00       	call   80104fca <release>
80100a0e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a11:	83 ec 0c             	sub    $0xc,%esp
80100a14:	ff 75 08             	pushl  0x8(%ebp)
80100a17:	e8 f8 0f 00 00       	call   80101a14 <ilock>
80100a1c:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a24:	e9 ab 00 00 00       	jmp    80100ad4 <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
80100a29:	83 ec 08             	sub    $0x8,%esp
80100a2c:	68 a0 b5 10 80       	push   $0x8010b5a0
80100a31:	68 20 10 11 80       	push   $0x80111020
80100a36:	e8 08 41 00 00       	call   80104b43 <sleep>
80100a3b:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a3e:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100a44:	a1 24 10 11 80       	mov    0x80111024,%eax
80100a49:	39 c2                	cmp    %eax,%edx
80100a4b:	74 a8                	je     801009f5 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a4d:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a52:	8d 50 01             	lea    0x1(%eax),%edx
80100a55:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100a5b:	83 e0 7f             	and    $0x7f,%eax
80100a5e:	0f b6 80 a0 0f 11 80 	movzbl -0x7feef060(%eax),%eax
80100a65:	0f be c0             	movsbl %al,%eax
80100a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a6b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a6f:	75 17                	jne    80100a88 <consoleread+0xc2>
      if(n < target){
80100a71:	8b 45 10             	mov    0x10(%ebp),%eax
80100a74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a77:	76 2f                	jbe    80100aa8 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a79:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a7e:	83 e8 01             	sub    $0x1,%eax
80100a81:	a3 20 10 11 80       	mov    %eax,0x80111020
      }
      break;
80100a86:	eb 20                	jmp    80100aa8 <consoleread+0xe2>
    }
    *dst++ = c;
80100a88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a8b:	8d 50 01             	lea    0x1(%eax),%edx
80100a8e:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a94:	88 10                	mov    %dl,(%eax)
    --n;
80100a96:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a9a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a9e:	74 0b                	je     80100aab <consoleread+0xe5>
  while(n > 0){
80100aa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100aa4:	7f 98                	jg     80100a3e <consoleread+0x78>
80100aa6:	eb 04                	jmp    80100aac <consoleread+0xe6>
      break;
80100aa8:	90                   	nop
80100aa9:	eb 01                	jmp    80100aac <consoleread+0xe6>
      break;
80100aab:	90                   	nop
  }
  release(&cons.lock);
80100aac:	83 ec 0c             	sub    $0xc,%esp
80100aaf:	68 a0 b5 10 80       	push   $0x8010b5a0
80100ab4:	e8 11 45 00 00       	call   80104fca <release>
80100ab9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100abc:	83 ec 0c             	sub    $0xc,%esp
80100abf:	ff 75 08             	pushl  0x8(%ebp)
80100ac2:	e8 4d 0f 00 00       	call   80101a14 <ilock>
80100ac7:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100aca:	8b 45 10             	mov    0x10(%ebp),%eax
80100acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad0:	29 c2                	sub    %eax,%edx
80100ad2:	89 d0                	mov    %edx,%eax
}
80100ad4:	c9                   	leave  
80100ad5:	c3                   	ret    

80100ad6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ad6:	55                   	push   %ebp
80100ad7:	89 e5                	mov    %esp,%ebp
80100ad9:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100adc:	83 ec 0c             	sub    $0xc,%esp
80100adf:	ff 75 08             	pushl  0x8(%ebp)
80100ae2:	e8 40 10 00 00       	call   80101b27 <iunlock>
80100ae7:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aea:	83 ec 0c             	sub    $0xc,%esp
80100aed:	68 a0 b5 10 80       	push   $0x8010b5a0
80100af2:	e8 65 44 00 00       	call   80104f5c <acquire>
80100af7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b01:	eb 21                	jmp    80100b24 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b06:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b09:	01 d0                	add    %edx,%eax
80100b0b:	0f b6 00             	movzbl (%eax),%eax
80100b0e:	0f be c0             	movsbl %al,%eax
80100b11:	0f b6 c0             	movzbl %al,%eax
80100b14:	83 ec 0c             	sub    $0xc,%esp
80100b17:	50                   	push   %eax
80100b18:	e8 ac fc ff ff       	call   801007c9 <consputc>
80100b1d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b27:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b2a:	7c d7                	jl     80100b03 <consolewrite+0x2d>
  release(&cons.lock);
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	68 a0 b5 10 80       	push   $0x8010b5a0
80100b34:	e8 91 44 00 00       	call   80104fca <release>
80100b39:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	ff 75 08             	pushl  0x8(%ebp)
80100b42:	e8 cd 0e 00 00       	call   80101a14 <ilock>
80100b47:	83 c4 10             	add    $0x10,%esp

  return n;
80100b4a:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b4d:	c9                   	leave  
80100b4e:	c3                   	ret    

80100b4f <consoleinit>:

void
consoleinit(void)
{
80100b4f:	55                   	push   %ebp
80100b50:	89 e5                	mov    %esp,%ebp
80100b52:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b55:	83 ec 08             	sub    $0x8,%esp
80100b58:	68 5a 83 10 80       	push   $0x8010835a
80100b5d:	68 a0 b5 10 80       	push   $0x8010b5a0
80100b62:	e8 d3 43 00 00       	call   80104f3a <initlock>
80100b67:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b6a:	c7 05 ec 19 11 80 d6 	movl   $0x80100ad6,0x801119ec
80100b71:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b74:	c7 05 e8 19 11 80 c6 	movl   $0x801009c6,0x801119e8
80100b7b:	09 10 80 
  cons.locking = 1;
80100b7e:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100b85:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b88:	83 ec 08             	sub    $0x8,%esp
80100b8b:	6a 00                	push   $0x0
80100b8d:	6a 01                	push   $0x1
80100b8f:	e8 8f 1f 00 00       	call   80102b23 <ioapicenable>
80100b94:	83 c4 10             	add    $0x10,%esp
}
80100b97:	90                   	nop
80100b98:	c9                   	leave  
80100b99:	c3                   	ret    

80100b9a <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b9a:	55                   	push   %ebp
80100b9b:	89 e5                	mov    %esp,%ebp
80100b9d:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100ba3:	e8 e4 36 00 00       	call   8010428c <myproc>
80100ba8:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100bab:	e8 86 29 00 00       	call   80103536 <begin_op>

  if((ip = namei(path)) == 0){
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	ff 75 08             	pushl  0x8(%ebp)
80100bb6:	e8 94 19 00 00       	call   8010254f <namei>
80100bbb:	83 c4 10             	add    $0x10,%esp
80100bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bc5:	75 1f                	jne    80100be6 <exec+0x4c>
    end_op();
80100bc7:	e8 f6 29 00 00       	call   801035c2 <end_op>
    cprintf("exec: fail\n");
80100bcc:	83 ec 0c             	sub    $0xc,%esp
80100bcf:	68 62 83 10 80       	push   $0x80108362
80100bd4:	e8 23 f8 ff ff       	call   801003fc <cprintf>
80100bd9:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be1:	e9 f1 03 00 00       	jmp    80100fd7 <exec+0x43d>
  }
  ilock(ip);
80100be6:	83 ec 0c             	sub    $0xc,%esp
80100be9:	ff 75 d8             	pushl  -0x28(%ebp)
80100bec:	e8 23 0e 00 00       	call   80101a14 <ilock>
80100bf1:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bf4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bfb:	6a 34                	push   $0x34
80100bfd:	6a 00                	push   $0x0
80100bff:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c05:	50                   	push   %eax
80100c06:	ff 75 d8             	pushl  -0x28(%ebp)
80100c09:	e8 f2 12 00 00       	call   80101f00 <readi>
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 34             	cmp    $0x34,%eax
80100c14:	0f 85 66 03 00 00    	jne    80100f80 <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c1a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c20:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c25:	0f 85 58 03 00 00    	jne    80100f83 <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c2b:	e8 79 6e 00 00       	call   80107aa9 <setupkvm>
80100c30:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c33:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c37:	0f 84 49 03 00 00    	je     80100f86 <exec+0x3ec>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c3d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c44:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c4b:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c51:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c54:	e9 de 00 00 00       	jmp    80100d37 <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c5c:	6a 20                	push   $0x20
80100c5e:	50                   	push   %eax
80100c5f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c65:	50                   	push   %eax
80100c66:	ff 75 d8             	pushl  -0x28(%ebp)
80100c69:	e8 92 12 00 00       	call   80101f00 <readi>
80100c6e:	83 c4 10             	add    $0x10,%esp
80100c71:	83 f8 20             	cmp    $0x20,%eax
80100c74:	0f 85 0f 03 00 00    	jne    80100f89 <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c7a:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c80:	83 f8 01             	cmp    $0x1,%eax
80100c83:	0f 85 a0 00 00 00    	jne    80100d29 <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100c89:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c8f:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c95:	39 c2                	cmp    %eax,%edx
80100c97:	0f 82 ef 02 00 00    	jb     80100f8c <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c9d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca3:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100ca9:	01 c2                	add    %eax,%edx
80100cab:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cb1:	39 c2                	cmp    %eax,%edx
80100cb3:	0f 82 d6 02 00 00    	jb     80100f8f <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cbf:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cc5:	01 d0                	add    %edx,%eax
80100cc7:	83 ec 04             	sub    $0x4,%esp
80100cca:	50                   	push   %eax
80100ccb:	ff 75 e0             	pushl  -0x20(%ebp)
80100cce:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cd1:	e8 7b 71 00 00       	call   80107e51 <allocuvm>
80100cd6:	83 c4 10             	add    $0x10,%esp
80100cd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cdc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ce0:	0f 84 ac 02 00 00    	je     80100f92 <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ce6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cec:	25 ff 0f 00 00       	and    $0xfff,%eax
80100cf1:	85 c0                	test   %eax,%eax
80100cf3:	0f 85 9c 02 00 00    	jne    80100f95 <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cf9:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100cff:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d0b:	83 ec 0c             	sub    $0xc,%esp
80100d0e:	52                   	push   %edx
80100d0f:	50                   	push   %eax
80100d10:	ff 75 d8             	pushl  -0x28(%ebp)
80100d13:	51                   	push   %ecx
80100d14:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d17:	e8 68 70 00 00       	call   80107d84 <loaduvm>
80100d1c:	83 c4 20             	add    $0x20,%esp
80100d1f:	85 c0                	test   %eax,%eax
80100d21:	0f 88 71 02 00 00    	js     80100f98 <exec+0x3fe>
80100d27:	eb 01                	jmp    80100d2a <exec+0x190>
      continue;
80100d29:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d2a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d31:	83 c0 20             	add    $0x20,%eax
80100d34:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d37:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d3e:	0f b7 c0             	movzwl %ax,%eax
80100d41:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d44:	0f 8c 0f ff ff ff    	jl     80100c59 <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d4a:	83 ec 0c             	sub    $0xc,%esp
80100d4d:	ff 75 d8             	pushl  -0x28(%ebp)
80100d50:	e8 f0 0e 00 00       	call   80101c45 <iunlockput>
80100d55:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d58:	e8 65 28 00 00       	call   801035c2 <end_op>
  ip = 0;
80100d5d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d67:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d71:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d77:	05 00 20 00 00       	add    $0x2000,%eax
80100d7c:	83 ec 04             	sub    $0x4,%esp
80100d7f:	50                   	push   %eax
80100d80:	ff 75 e0             	pushl  -0x20(%ebp)
80100d83:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d86:	e8 c6 70 00 00       	call   80107e51 <allocuvm>
80100d8b:	83 c4 10             	add    $0x10,%esp
80100d8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d95:	0f 84 00 02 00 00    	je     80100f9b <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9e:	2d 00 20 00 00       	sub    $0x2000,%eax
80100da3:	83 ec 08             	sub    $0x8,%esp
80100da6:	50                   	push   %eax
80100da7:	ff 75 d4             	pushl  -0x2c(%ebp)
80100daa:	e8 04 73 00 00       	call   801080b3 <clearpteu>
80100daf:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db5:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dbf:	e9 96 00 00 00       	jmp    80100e5a <exec+0x2c0>
    if(argc >= MAXARG)
80100dc4:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dc8:	0f 87 d0 01 00 00    	ja     80100f9e <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ddb:	01 d0                	add    %edx,%eax
80100ddd:	8b 00                	mov    (%eax),%eax
80100ddf:	83 ec 0c             	sub    $0xc,%esp
80100de2:	50                   	push   %eax
80100de3:	e8 38 46 00 00       	call   80105420 <strlen>
80100de8:	83 c4 10             	add    $0x10,%esp
80100deb:	89 c2                	mov    %eax,%edx
80100ded:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100df0:	29 d0                	sub    %edx,%eax
80100df2:	83 e8 01             	sub    $0x1,%eax
80100df5:	83 e0 fc             	and    $0xfffffffc,%eax
80100df8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e05:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e08:	01 d0                	add    %edx,%eax
80100e0a:	8b 00                	mov    (%eax),%eax
80100e0c:	83 ec 0c             	sub    $0xc,%esp
80100e0f:	50                   	push   %eax
80100e10:	e8 0b 46 00 00       	call   80105420 <strlen>
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	83 c0 01             	add    $0x1,%eax
80100e1b:	89 c1                	mov    %eax,%ecx
80100e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e2a:	01 d0                	add    %edx,%eax
80100e2c:	8b 00                	mov    (%eax),%eax
80100e2e:	51                   	push   %ecx
80100e2f:	50                   	push   %eax
80100e30:	ff 75 dc             	pushl  -0x24(%ebp)
80100e33:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e36:	e8 17 74 00 00       	call   80108252 <copyout>
80100e3b:	83 c4 10             	add    $0x10,%esp
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	0f 88 5b 01 00 00    	js     80100fa1 <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e49:	8d 50 03             	lea    0x3(%eax),%edx
80100e4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e4f:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e56:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e67:	01 d0                	add    %edx,%eax
80100e69:	8b 00                	mov    (%eax),%eax
80100e6b:	85 c0                	test   %eax,%eax
80100e6d:	0f 85 51 ff ff ff    	jne    80100dc4 <exec+0x22a>
  }
  ustack[3+argc] = 0;
80100e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e76:	83 c0 03             	add    $0x3,%eax
80100e79:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e80:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e84:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e8b:	ff ff ff 
  ustack[1] = argc;
80100e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e91:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e9a:	83 c0 01             	add    $0x1,%eax
80100e9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ea4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea7:	29 d0                	sub    %edx,%eax
80100ea9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb2:	83 c0 04             	add    $0x4,%eax
80100eb5:	c1 e0 02             	shl    $0x2,%eax
80100eb8:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ebe:	83 c0 04             	add    $0x4,%eax
80100ec1:	c1 e0 02             	shl    $0x2,%eax
80100ec4:	50                   	push   %eax
80100ec5:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ecb:	50                   	push   %eax
80100ecc:	ff 75 dc             	pushl  -0x24(%ebp)
80100ecf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ed2:	e8 7b 73 00 00       	call   80108252 <copyout>
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	0f 88 c2 00 00 00    	js     80100fa4 <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100eee:	eb 17                	jmp    80100f07 <exec+0x36d>
    if(*s == '/')
80100ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef3:	0f b6 00             	movzbl (%eax),%eax
80100ef6:	3c 2f                	cmp    $0x2f,%al
80100ef8:	75 09                	jne    80100f03 <exec+0x369>
      last = s+1;
80100efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100efd:	83 c0 01             	add    $0x1,%eax
80100f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f03:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f0a:	0f b6 00             	movzbl (%eax),%eax
80100f0d:	84 c0                	test   %al,%al
80100f0f:	75 df                	jne    80100ef0 <exec+0x356>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f11:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f14:	83 c0 6c             	add    $0x6c,%eax
80100f17:	83 ec 04             	sub    $0x4,%esp
80100f1a:	6a 10                	push   $0x10
80100f1c:	ff 75 f0             	pushl  -0x10(%ebp)
80100f1f:	50                   	push   %eax
80100f20:	e8 b1 44 00 00       	call   801053d6 <safestrcpy>
80100f25:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f28:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f2b:	8b 40 04             	mov    0x4(%eax),%eax
80100f2e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f31:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f34:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f37:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f40:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f42:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f45:	8b 40 18             	mov    0x18(%eax),%eax
80100f48:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f4e:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f51:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f54:	8b 40 18             	mov    0x18(%eax),%eax
80100f57:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f5a:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 d0             	pushl  -0x30(%ebp)
80100f63:	e8 0b 6c 00 00       	call   80107b73 <switchuvm>
80100f68:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f6b:	83 ec 0c             	sub    $0xc,%esp
80100f6e:	ff 75 cc             	pushl  -0x34(%ebp)
80100f71:	e8 a4 70 00 00       	call   8010801a <freevm>
80100f76:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f79:	b8 00 00 00 00       	mov    $0x0,%eax
80100f7e:	eb 57                	jmp    80100fd7 <exec+0x43d>
    goto bad;
80100f80:	90                   	nop
80100f81:	eb 22                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100f83:	90                   	nop
80100f84:	eb 1f                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100f86:	90                   	nop
80100f87:	eb 1c                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f89:	90                   	nop
80100f8a:	eb 19                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f8c:	90                   	nop
80100f8d:	eb 16                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f8f:	90                   	nop
80100f90:	eb 13                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f92:	90                   	nop
80100f93:	eb 10                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f95:	90                   	nop
80100f96:	eb 0d                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f98:	90                   	nop
80100f99:	eb 0a                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100f9b:	90                   	nop
80100f9c:	eb 07                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100f9e:	90                   	nop
80100f9f:	eb 04                	jmp    80100fa5 <exec+0x40b>
      goto bad;
80100fa1:	90                   	nop
80100fa2:	eb 01                	jmp    80100fa5 <exec+0x40b>
    goto bad;
80100fa4:	90                   	nop

 bad:
  if(pgdir)
80100fa5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fa9:	74 0e                	je     80100fb9 <exec+0x41f>
    freevm(pgdir);
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fb1:	e8 64 70 00 00       	call   8010801a <freevm>
80100fb6:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fb9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fbd:	74 13                	je     80100fd2 <exec+0x438>
    iunlockput(ip);
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	ff 75 d8             	pushl  -0x28(%ebp)
80100fc5:	e8 7b 0c 00 00       	call   80101c45 <iunlockput>
80100fca:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fcd:	e8 f0 25 00 00       	call   801035c2 <end_op>
  }
  return -1;
80100fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd7:	c9                   	leave  
80100fd8:	c3                   	ret    

80100fd9 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fd9:	55                   	push   %ebp
80100fda:	89 e5                	mov    %esp,%ebp
80100fdc:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fdf:	83 ec 08             	sub    $0x8,%esp
80100fe2:	68 6e 83 10 80       	push   $0x8010836e
80100fe7:	68 40 10 11 80       	push   $0x80111040
80100fec:	e8 49 3f 00 00       	call   80104f3a <initlock>
80100ff1:	83 c4 10             	add    $0x10,%esp
}
80100ff4:	90                   	nop
80100ff5:	c9                   	leave  
80100ff6:	c3                   	ret    

80100ff7 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ff7:	55                   	push   %ebp
80100ff8:	89 e5                	mov    %esp,%ebp
80100ffa:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ffd:	83 ec 0c             	sub    $0xc,%esp
80101000:	68 40 10 11 80       	push   $0x80111040
80101005:	e8 52 3f 00 00       	call   80104f5c <acquire>
8010100a:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010100d:	c7 45 f4 74 10 11 80 	movl   $0x80111074,-0xc(%ebp)
80101014:	eb 2d                	jmp    80101043 <filealloc+0x4c>
    if(f->ref == 0){
80101016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	75 1f                	jne    8010103f <filealloc+0x48>
      f->ref = 1;
80101020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101023:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010102a:	83 ec 0c             	sub    $0xc,%esp
8010102d:	68 40 10 11 80       	push   $0x80111040
80101032:	e8 93 3f 00 00       	call   80104fca <release>
80101037:	83 c4 10             	add    $0x10,%esp
      return f;
8010103a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010103d:	eb 23                	jmp    80101062 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010103f:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101043:	b8 d4 19 11 80       	mov    $0x801119d4,%eax
80101048:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010104b:	72 c9                	jb     80101016 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
8010104d:	83 ec 0c             	sub    $0xc,%esp
80101050:	68 40 10 11 80       	push   $0x80111040
80101055:	e8 70 3f 00 00       	call   80104fca <release>
8010105a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010105d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101062:	c9                   	leave  
80101063:	c3                   	ret    

80101064 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101064:	55                   	push   %ebp
80101065:	89 e5                	mov    %esp,%ebp
80101067:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010106a:	83 ec 0c             	sub    $0xc,%esp
8010106d:	68 40 10 11 80       	push   $0x80111040
80101072:	e8 e5 3e 00 00       	call   80104f5c <acquire>
80101077:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010107a:	8b 45 08             	mov    0x8(%ebp),%eax
8010107d:	8b 40 04             	mov    0x4(%eax),%eax
80101080:	85 c0                	test   %eax,%eax
80101082:	7f 0d                	jg     80101091 <filedup+0x2d>
    panic("filedup");
80101084:	83 ec 0c             	sub    $0xc,%esp
80101087:	68 75 83 10 80       	push   $0x80108375
8010108c:	e8 0b f5 ff ff       	call   8010059c <panic>
  f->ref++;
80101091:	8b 45 08             	mov    0x8(%ebp),%eax
80101094:	8b 40 04             	mov    0x4(%eax),%eax
80101097:	8d 50 01             	lea    0x1(%eax),%edx
8010109a:	8b 45 08             	mov    0x8(%ebp),%eax
8010109d:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010a0:	83 ec 0c             	sub    $0xc,%esp
801010a3:	68 40 10 11 80       	push   $0x80111040
801010a8:	e8 1d 3f 00 00       	call   80104fca <release>
801010ad:	83 c4 10             	add    $0x10,%esp
  return f;
801010b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010b3:	c9                   	leave  
801010b4:	c3                   	ret    

801010b5 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010b5:	55                   	push   %ebp
801010b6:	89 e5                	mov    %esp,%ebp
801010b8:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	68 40 10 11 80       	push   $0x80111040
801010c3:	e8 94 3e 00 00       	call   80104f5c <acquire>
801010c8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010cb:	8b 45 08             	mov    0x8(%ebp),%eax
801010ce:	8b 40 04             	mov    0x4(%eax),%eax
801010d1:	85 c0                	test   %eax,%eax
801010d3:	7f 0d                	jg     801010e2 <fileclose+0x2d>
    panic("fileclose");
801010d5:	83 ec 0c             	sub    $0xc,%esp
801010d8:	68 7d 83 10 80       	push   $0x8010837d
801010dd:	e8 ba f4 ff ff       	call   8010059c <panic>
  if(--f->ref > 0){
801010e2:	8b 45 08             	mov    0x8(%ebp),%eax
801010e5:	8b 40 04             	mov    0x4(%eax),%eax
801010e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801010eb:	8b 45 08             	mov    0x8(%ebp),%eax
801010ee:	89 50 04             	mov    %edx,0x4(%eax)
801010f1:	8b 45 08             	mov    0x8(%ebp),%eax
801010f4:	8b 40 04             	mov    0x4(%eax),%eax
801010f7:	85 c0                	test   %eax,%eax
801010f9:	7e 15                	jle    80101110 <fileclose+0x5b>
    release(&ftable.lock);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	68 40 10 11 80       	push   $0x80111040
80101103:	e8 c2 3e 00 00       	call   80104fca <release>
80101108:	83 c4 10             	add    $0x10,%esp
8010110b:	e9 8b 00 00 00       	jmp    8010119b <fileclose+0xe6>
    return;
  }
  ff = *f;
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 10                	mov    (%eax),%edx
80101115:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101118:	8b 50 04             	mov    0x4(%eax),%edx
8010111b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010111e:	8b 50 08             	mov    0x8(%eax),%edx
80101121:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101124:	8b 50 0c             	mov    0xc(%eax),%edx
80101127:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010112a:	8b 50 10             	mov    0x10(%eax),%edx
8010112d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101130:	8b 40 14             	mov    0x14(%eax),%eax
80101133:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101149:	83 ec 0c             	sub    $0xc,%esp
8010114c:	68 40 10 11 80       	push   $0x80111040
80101151:	e8 74 3e 00 00       	call   80104fca <release>
80101156:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101159:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010115c:	83 f8 01             	cmp    $0x1,%eax
8010115f:	75 19                	jne    8010117a <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101161:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101165:	0f be d0             	movsbl %al,%edx
80101168:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010116b:	83 ec 08             	sub    $0x8,%esp
8010116e:	52                   	push   %edx
8010116f:	50                   	push   %eax
80101170:	e8 a1 2d 00 00       	call   80103f16 <pipeclose>
80101175:	83 c4 10             	add    $0x10,%esp
80101178:	eb 21                	jmp    8010119b <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010117a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010117d:	83 f8 02             	cmp    $0x2,%eax
80101180:	75 19                	jne    8010119b <fileclose+0xe6>
    begin_op();
80101182:	e8 af 23 00 00       	call   80103536 <begin_op>
    iput(ff.ip);
80101187:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010118a:	83 ec 0c             	sub    $0xc,%esp
8010118d:	50                   	push   %eax
8010118e:	e8 e2 09 00 00       	call   80101b75 <iput>
80101193:	83 c4 10             	add    $0x10,%esp
    end_op();
80101196:	e8 27 24 00 00       	call   801035c2 <end_op>
  }
}
8010119b:	c9                   	leave  
8010119c:	c3                   	ret    

8010119d <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010119d:	55                   	push   %ebp
8010119e:	89 e5                	mov    %esp,%ebp
801011a0:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011a3:	8b 45 08             	mov    0x8(%ebp),%eax
801011a6:	8b 00                	mov    (%eax),%eax
801011a8:	83 f8 02             	cmp    $0x2,%eax
801011ab:	75 40                	jne    801011ed <filestat+0x50>
    ilock(f->ip);
801011ad:	8b 45 08             	mov    0x8(%ebp),%eax
801011b0:	8b 40 10             	mov    0x10(%eax),%eax
801011b3:	83 ec 0c             	sub    $0xc,%esp
801011b6:	50                   	push   %eax
801011b7:	e8 58 08 00 00       	call   80101a14 <ilock>
801011bc:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011bf:	8b 45 08             	mov    0x8(%ebp),%eax
801011c2:	8b 40 10             	mov    0x10(%eax),%eax
801011c5:	83 ec 08             	sub    $0x8,%esp
801011c8:	ff 75 0c             	pushl  0xc(%ebp)
801011cb:	50                   	push   %eax
801011cc:	e8 e9 0c 00 00       	call   80101eba <stati>
801011d1:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	8b 40 10             	mov    0x10(%eax),%eax
801011da:	83 ec 0c             	sub    $0xc,%esp
801011dd:	50                   	push   %eax
801011de:	e8 44 09 00 00       	call   80101b27 <iunlock>
801011e3:	83 c4 10             	add    $0x10,%esp
    return 0;
801011e6:	b8 00 00 00 00       	mov    $0x0,%eax
801011eb:	eb 05                	jmp    801011f2 <filestat+0x55>
  }
  return -1;
801011ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011f2:	c9                   	leave  
801011f3:	c3                   	ret    

801011f4 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011f4:	55                   	push   %ebp
801011f5:	89 e5                	mov    %esp,%ebp
801011f7:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011fa:	8b 45 08             	mov    0x8(%ebp),%eax
801011fd:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101201:	84 c0                	test   %al,%al
80101203:	75 0a                	jne    8010120f <fileread+0x1b>
    return -1;
80101205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010120a:	e9 9b 00 00 00       	jmp    801012aa <fileread+0xb6>
  if(f->type == FD_PIPE)
8010120f:	8b 45 08             	mov    0x8(%ebp),%eax
80101212:	8b 00                	mov    (%eax),%eax
80101214:	83 f8 01             	cmp    $0x1,%eax
80101217:	75 1a                	jne    80101233 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 40 0c             	mov    0xc(%eax),%eax
8010121f:	83 ec 04             	sub    $0x4,%esp
80101222:	ff 75 10             	pushl  0x10(%ebp)
80101225:	ff 75 0c             	pushl  0xc(%ebp)
80101228:	50                   	push   %eax
80101229:	e8 94 2e 00 00       	call   801040c2 <piperead>
8010122e:	83 c4 10             	add    $0x10,%esp
80101231:	eb 77                	jmp    801012aa <fileread+0xb6>
  if(f->type == FD_INODE){
80101233:	8b 45 08             	mov    0x8(%ebp),%eax
80101236:	8b 00                	mov    (%eax),%eax
80101238:	83 f8 02             	cmp    $0x2,%eax
8010123b:	75 60                	jne    8010129d <fileread+0xa9>
    ilock(f->ip);
8010123d:	8b 45 08             	mov    0x8(%ebp),%eax
80101240:	8b 40 10             	mov    0x10(%eax),%eax
80101243:	83 ec 0c             	sub    $0xc,%esp
80101246:	50                   	push   %eax
80101247:	e8 c8 07 00 00       	call   80101a14 <ilock>
8010124c:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010124f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 50 14             	mov    0x14(%eax),%edx
80101258:	8b 45 08             	mov    0x8(%ebp),%eax
8010125b:	8b 40 10             	mov    0x10(%eax),%eax
8010125e:	51                   	push   %ecx
8010125f:	52                   	push   %edx
80101260:	ff 75 0c             	pushl  0xc(%ebp)
80101263:	50                   	push   %eax
80101264:	e8 97 0c 00 00       	call   80101f00 <readi>
80101269:	83 c4 10             	add    $0x10,%esp
8010126c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010126f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101273:	7e 11                	jle    80101286 <fileread+0x92>
      f->off += r;
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	8b 50 14             	mov    0x14(%eax),%edx
8010127b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010127e:	01 c2                	add    %eax,%edx
80101280:	8b 45 08             	mov    0x8(%ebp),%eax
80101283:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101286:	8b 45 08             	mov    0x8(%ebp),%eax
80101289:	8b 40 10             	mov    0x10(%eax),%eax
8010128c:	83 ec 0c             	sub    $0xc,%esp
8010128f:	50                   	push   %eax
80101290:	e8 92 08 00 00       	call   80101b27 <iunlock>
80101295:	83 c4 10             	add    $0x10,%esp
    return r;
80101298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010129b:	eb 0d                	jmp    801012aa <fileread+0xb6>
  }
  panic("fileread");
8010129d:	83 ec 0c             	sub    $0xc,%esp
801012a0:	68 87 83 10 80       	push   $0x80108387
801012a5:	e8 f2 f2 ff ff       	call   8010059c <panic>
}
801012aa:	c9                   	leave  
801012ab:	c3                   	ret    

801012ac <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012ac:	55                   	push   %ebp
801012ad:	89 e5                	mov    %esp,%ebp
801012af:	53                   	push   %ebx
801012b0:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012ba:	84 c0                	test   %al,%al
801012bc:	75 0a                	jne    801012c8 <filewrite+0x1c>
    return -1;
801012be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012c3:	e9 1b 01 00 00       	jmp    801013e3 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012c8:	8b 45 08             	mov    0x8(%ebp),%eax
801012cb:	8b 00                	mov    (%eax),%eax
801012cd:	83 f8 01             	cmp    $0x1,%eax
801012d0:	75 1d                	jne    801012ef <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012d2:	8b 45 08             	mov    0x8(%ebp),%eax
801012d5:	8b 40 0c             	mov    0xc(%eax),%eax
801012d8:	83 ec 04             	sub    $0x4,%esp
801012db:	ff 75 10             	pushl  0x10(%ebp)
801012de:	ff 75 0c             	pushl  0xc(%ebp)
801012e1:	50                   	push   %eax
801012e2:	e8 d9 2c 00 00       	call   80103fc0 <pipewrite>
801012e7:	83 c4 10             	add    $0x10,%esp
801012ea:	e9 f4 00 00 00       	jmp    801013e3 <filewrite+0x137>
  if(f->type == FD_INODE){
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	8b 00                	mov    (%eax),%eax
801012f4:	83 f8 02             	cmp    $0x2,%eax
801012f7:	0f 85 d9 00 00 00    	jne    801013d6 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801012fd:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010130b:	e9 a3 00 00 00       	jmp    801013b3 <filewrite+0x107>
      int n1 = n - i;
80101310:	8b 45 10             	mov    0x10(%ebp),%eax
80101313:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101316:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101319:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010131c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010131f:	7e 06                	jle    80101327 <filewrite+0x7b>
        n1 = max;
80101321:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101324:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101327:	e8 0a 22 00 00       	call   80103536 <begin_op>
      ilock(f->ip);
8010132c:	8b 45 08             	mov    0x8(%ebp),%eax
8010132f:	8b 40 10             	mov    0x10(%eax),%eax
80101332:	83 ec 0c             	sub    $0xc,%esp
80101335:	50                   	push   %eax
80101336:	e8 d9 06 00 00       	call   80101a14 <ilock>
8010133b:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010133e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101341:	8b 45 08             	mov    0x8(%ebp),%eax
80101344:	8b 50 14             	mov    0x14(%eax),%edx
80101347:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010134a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010134d:	01 c3                	add    %eax,%ebx
8010134f:	8b 45 08             	mov    0x8(%ebp),%eax
80101352:	8b 40 10             	mov    0x10(%eax),%eax
80101355:	51                   	push   %ecx
80101356:	52                   	push   %edx
80101357:	53                   	push   %ebx
80101358:	50                   	push   %eax
80101359:	e8 f9 0c 00 00       	call   80102057 <writei>
8010135e:	83 c4 10             	add    $0x10,%esp
80101361:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101364:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101368:	7e 11                	jle    8010137b <filewrite+0xcf>
        f->off += r;
8010136a:	8b 45 08             	mov    0x8(%ebp),%eax
8010136d:	8b 50 14             	mov    0x14(%eax),%edx
80101370:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101373:	01 c2                	add    %eax,%edx
80101375:	8b 45 08             	mov    0x8(%ebp),%eax
80101378:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010137b:	8b 45 08             	mov    0x8(%ebp),%eax
8010137e:	8b 40 10             	mov    0x10(%eax),%eax
80101381:	83 ec 0c             	sub    $0xc,%esp
80101384:	50                   	push   %eax
80101385:	e8 9d 07 00 00       	call   80101b27 <iunlock>
8010138a:	83 c4 10             	add    $0x10,%esp
      end_op();
8010138d:	e8 30 22 00 00       	call   801035c2 <end_op>

      if(r < 0)
80101392:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101396:	78 29                	js     801013c1 <filewrite+0x115>
        break;
      if(r != n1)
80101398:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010139b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010139e:	74 0d                	je     801013ad <filewrite+0x101>
        panic("short filewrite");
801013a0:	83 ec 0c             	sub    $0xc,%esp
801013a3:	68 90 83 10 80       	push   $0x80108390
801013a8:	e8 ef f1 ff ff       	call   8010059c <panic>
      i += r;
801013ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b0:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b9:	0f 8c 51 ff ff ff    	jl     80101310 <filewrite+0x64>
801013bf:	eb 01                	jmp    801013c2 <filewrite+0x116>
        break;
801013c1:	90                   	nop
    }
    return i == n ? n : -1;
801013c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c5:	3b 45 10             	cmp    0x10(%ebp),%eax
801013c8:	75 05                	jne    801013cf <filewrite+0x123>
801013ca:	8b 45 10             	mov    0x10(%ebp),%eax
801013cd:	eb 14                	jmp    801013e3 <filewrite+0x137>
801013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013d4:	eb 0d                	jmp    801013e3 <filewrite+0x137>
  }
  panic("filewrite");
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	68 a0 83 10 80       	push   $0x801083a0
801013de:	e8 b9 f1 ff ff       	call   8010059c <panic>
}
801013e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013e6:	c9                   	leave  
801013e7:	c3                   	ret    

801013e8 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013e8:	55                   	push   %ebp
801013e9:	89 e5                	mov    %esp,%ebp
801013eb:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013ee:	8b 45 08             	mov    0x8(%ebp),%eax
801013f1:	83 ec 08             	sub    $0x8,%esp
801013f4:	6a 01                	push   $0x1
801013f6:	50                   	push   %eax
801013f7:	e8 d2 ed ff ff       	call   801001ce <bread>
801013fc:	83 c4 10             	add    $0x10,%esp
801013ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101405:	83 c0 5c             	add    $0x5c,%eax
80101408:	83 ec 04             	sub    $0x4,%esp
8010140b:	6a 1c                	push   $0x1c
8010140d:	50                   	push   %eax
8010140e:	ff 75 0c             	pushl  0xc(%ebp)
80101411:	e8 7c 3e 00 00       	call   80105292 <memmove>
80101416:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101419:	83 ec 0c             	sub    $0xc,%esp
8010141c:	ff 75 f4             	pushl  -0xc(%ebp)
8010141f:	e8 2c ee ff ff       	call   80100250 <brelse>
80101424:	83 c4 10             	add    $0x10,%esp
}
80101427:	90                   	nop
80101428:	c9                   	leave  
80101429:	c3                   	ret    

8010142a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010142a:	55                   	push   %ebp
8010142b:	89 e5                	mov    %esp,%ebp
8010142d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101430:	8b 55 0c             	mov    0xc(%ebp),%edx
80101433:	8b 45 08             	mov    0x8(%ebp),%eax
80101436:	83 ec 08             	sub    $0x8,%esp
80101439:	52                   	push   %edx
8010143a:	50                   	push   %eax
8010143b:	e8 8e ed ff ff       	call   801001ce <bread>
80101440:	83 c4 10             	add    $0x10,%esp
80101443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101449:	83 c0 5c             	add    $0x5c,%eax
8010144c:	83 ec 04             	sub    $0x4,%esp
8010144f:	68 00 02 00 00       	push   $0x200
80101454:	6a 00                	push   $0x0
80101456:	50                   	push   %eax
80101457:	e8 77 3d 00 00       	call   801051d3 <memset>
8010145c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	ff 75 f4             	pushl  -0xc(%ebp)
80101465:	e8 04 23 00 00       	call   8010376e <log_write>
8010146a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010146d:	83 ec 0c             	sub    $0xc,%esp
80101470:	ff 75 f4             	pushl  -0xc(%ebp)
80101473:	e8 d8 ed ff ff       	call   80100250 <brelse>
80101478:	83 c4 10             	add    $0x10,%esp
}
8010147b:	90                   	nop
8010147c:	c9                   	leave  
8010147d:	c3                   	ret    

8010147e <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010147e:	55                   	push   %ebp
8010147f:	89 e5                	mov    %esp,%ebp
80101481:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101484:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010148b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101492:	e9 13 01 00 00       	jmp    801015aa <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010149a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014a0:	85 c0                	test   %eax,%eax
801014a2:	0f 48 c2             	cmovs  %edx,%eax
801014a5:	c1 f8 0c             	sar    $0xc,%eax
801014a8:	89 c2                	mov    %eax,%edx
801014aa:	a1 58 1a 11 80       	mov    0x80111a58,%eax
801014af:	01 d0                	add    %edx,%eax
801014b1:	83 ec 08             	sub    $0x8,%esp
801014b4:	50                   	push   %eax
801014b5:	ff 75 08             	pushl  0x8(%ebp)
801014b8:	e8 11 ed ff ff       	call   801001ce <bread>
801014bd:	83 c4 10             	add    $0x10,%esp
801014c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014ca:	e9 a6 00 00 00       	jmp    80101575 <balloc+0xf7>
      m = 1 << (bi % 8);
801014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d2:	99                   	cltd   
801014d3:	c1 ea 1d             	shr    $0x1d,%edx
801014d6:	01 d0                	add    %edx,%eax
801014d8:	83 e0 07             	and    $0x7,%eax
801014db:	29 d0                	sub    %edx,%eax
801014dd:	ba 01 00 00 00       	mov    $0x1,%edx
801014e2:	89 c1                	mov    %eax,%ecx
801014e4:	d3 e2                	shl    %cl,%edx
801014e6:	89 d0                	mov    %edx,%eax
801014e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ee:	8d 50 07             	lea    0x7(%eax),%edx
801014f1:	85 c0                	test   %eax,%eax
801014f3:	0f 48 c2             	cmovs  %edx,%eax
801014f6:	c1 f8 03             	sar    $0x3,%eax
801014f9:	89 c2                	mov    %eax,%edx
801014fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014fe:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101503:	0f b6 c0             	movzbl %al,%eax
80101506:	23 45 e8             	and    -0x18(%ebp),%eax
80101509:	85 c0                	test   %eax,%eax
8010150b:	75 64                	jne    80101571 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010150d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101510:	8d 50 07             	lea    0x7(%eax),%edx
80101513:	85 c0                	test   %eax,%eax
80101515:	0f 48 c2             	cmovs  %edx,%eax
80101518:	c1 f8 03             	sar    $0x3,%eax
8010151b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010151e:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101523:	89 d1                	mov    %edx,%ecx
80101525:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101528:	09 ca                	or     %ecx,%edx
8010152a:	89 d1                	mov    %edx,%ecx
8010152c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010152f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101533:	83 ec 0c             	sub    $0xc,%esp
80101536:	ff 75 ec             	pushl  -0x14(%ebp)
80101539:	e8 30 22 00 00       	call   8010376e <log_write>
8010153e:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101541:	83 ec 0c             	sub    $0xc,%esp
80101544:	ff 75 ec             	pushl  -0x14(%ebp)
80101547:	e8 04 ed ff ff       	call   80100250 <brelse>
8010154c:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101555:	01 c2                	add    %eax,%edx
80101557:	8b 45 08             	mov    0x8(%ebp),%eax
8010155a:	83 ec 08             	sub    $0x8,%esp
8010155d:	52                   	push   %edx
8010155e:	50                   	push   %eax
8010155f:	e8 c6 fe ff ff       	call   8010142a <bzero>
80101564:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101567:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156d:	01 d0                	add    %edx,%eax
8010156f:	eb 57                	jmp    801015c8 <balloc+0x14a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101571:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101575:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010157c:	7f 17                	jg     80101595 <balloc+0x117>
8010157e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101581:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101584:	01 d0                	add    %edx,%eax
80101586:	89 c2                	mov    %eax,%edx
80101588:	a1 40 1a 11 80       	mov    0x80111a40,%eax
8010158d:	39 c2                	cmp    %eax,%edx
8010158f:	0f 82 3a ff ff ff    	jb     801014cf <balloc+0x51>
      }
    }
    brelse(bp);
80101595:	83 ec 0c             	sub    $0xc,%esp
80101598:	ff 75 ec             	pushl  -0x14(%ebp)
8010159b:	e8 b0 ec ff ff       	call   80100250 <brelse>
801015a0:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801015a3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015aa:	8b 15 40 1a 11 80    	mov    0x80111a40,%edx
801015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015b3:	39 c2                	cmp    %eax,%edx
801015b5:	0f 87 dc fe ff ff    	ja     80101497 <balloc+0x19>
  }
  panic("balloc: out of blocks");
801015bb:	83 ec 0c             	sub    $0xc,%esp
801015be:	68 ac 83 10 80       	push   $0x801083ac
801015c3:	e8 d4 ef ff ff       	call   8010059c <panic>
}
801015c8:	c9                   	leave  
801015c9:	c3                   	ret    

801015ca <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015ca:	55                   	push   %ebp
801015cb:	89 e5                	mov    %esp,%ebp
801015cd:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 40 1a 11 80       	push   $0x80111a40
801015d8:	ff 75 08             	pushl  0x8(%ebp)
801015db:	e8 08 fe ff ff       	call   801013e8 <readsb>
801015e0:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e6:	c1 e8 0c             	shr    $0xc,%eax
801015e9:	89 c2                	mov    %eax,%edx
801015eb:	a1 58 1a 11 80       	mov    0x80111a58,%eax
801015f0:	01 c2                	add    %eax,%edx
801015f2:	8b 45 08             	mov    0x8(%ebp),%eax
801015f5:	83 ec 08             	sub    $0x8,%esp
801015f8:	52                   	push   %edx
801015f9:	50                   	push   %eax
801015fa:	e8 cf eb ff ff       	call   801001ce <bread>
801015ff:	83 c4 10             	add    $0x10,%esp
80101602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101605:	8b 45 0c             	mov    0xc(%ebp),%eax
80101608:	25 ff 0f 00 00       	and    $0xfff,%eax
8010160d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101610:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101613:	99                   	cltd   
80101614:	c1 ea 1d             	shr    $0x1d,%edx
80101617:	01 d0                	add    %edx,%eax
80101619:	83 e0 07             	and    $0x7,%eax
8010161c:	29 d0                	sub    %edx,%eax
8010161e:	ba 01 00 00 00       	mov    $0x1,%edx
80101623:	89 c1                	mov    %eax,%ecx
80101625:	d3 e2                	shl    %cl,%edx
80101627:	89 d0                	mov    %edx,%eax
80101629:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162f:	8d 50 07             	lea    0x7(%eax),%edx
80101632:	85 c0                	test   %eax,%eax
80101634:	0f 48 c2             	cmovs  %edx,%eax
80101637:	c1 f8 03             	sar    $0x3,%eax
8010163a:	89 c2                	mov    %eax,%edx
8010163c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010163f:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101644:	0f b6 c0             	movzbl %al,%eax
80101647:	23 45 ec             	and    -0x14(%ebp),%eax
8010164a:	85 c0                	test   %eax,%eax
8010164c:	75 0d                	jne    8010165b <bfree+0x91>
    panic("freeing free block");
8010164e:	83 ec 0c             	sub    $0xc,%esp
80101651:	68 c2 83 10 80       	push   $0x801083c2
80101656:	e8 41 ef ff ff       	call   8010059c <panic>
  bp->data[bi/8] &= ~m;
8010165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165e:	8d 50 07             	lea    0x7(%eax),%edx
80101661:	85 c0                	test   %eax,%eax
80101663:	0f 48 c2             	cmovs  %edx,%eax
80101666:	c1 f8 03             	sar    $0x3,%eax
80101669:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010166c:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101671:	89 d1                	mov    %edx,%ecx
80101673:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101676:	f7 d2                	not    %edx
80101678:	21 ca                	and    %ecx,%edx
8010167a:	89 d1                	mov    %edx,%ecx
8010167c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010167f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101683:	83 ec 0c             	sub    $0xc,%esp
80101686:	ff 75 f4             	pushl  -0xc(%ebp)
80101689:	e8 e0 20 00 00       	call   8010376e <log_write>
8010168e:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101691:	83 ec 0c             	sub    $0xc,%esp
80101694:	ff 75 f4             	pushl  -0xc(%ebp)
80101697:	e8 b4 eb ff ff       	call   80100250 <brelse>
8010169c:	83 c4 10             	add    $0x10,%esp
}
8010169f:	90                   	nop
801016a0:	c9                   	leave  
801016a1:	c3                   	ret    

801016a2 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016a2:	55                   	push   %ebp
801016a3:	89 e5                	mov    %esp,%ebp
801016a5:	57                   	push   %edi
801016a6:	56                   	push   %esi
801016a7:	53                   	push   %ebx
801016a8:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
801016ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	68 d5 83 10 80       	push   $0x801083d5
801016ba:	68 60 1a 11 80       	push   $0x80111a60
801016bf:	e8 76 38 00 00       	call   80104f3a <initlock>
801016c4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016ce:	eb 2d                	jmp    801016fd <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016d3:	89 d0                	mov    %edx,%eax
801016d5:	c1 e0 03             	shl    $0x3,%eax
801016d8:	01 d0                	add    %edx,%eax
801016da:	c1 e0 04             	shl    $0x4,%eax
801016dd:	83 c0 30             	add    $0x30,%eax
801016e0:	05 60 1a 11 80       	add    $0x80111a60,%eax
801016e5:	83 c0 10             	add    $0x10,%eax
801016e8:	83 ec 08             	sub    $0x8,%esp
801016eb:	68 dc 83 10 80       	push   $0x801083dc
801016f0:	50                   	push   %eax
801016f1:	e8 e7 36 00 00       	call   80104ddd <initsleeplock>
801016f6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016f9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016fd:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101701:	7e cd                	jle    801016d0 <iinit+0x2e>
  }

  readsb(dev, &sb);
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	68 40 1a 11 80       	push   $0x80111a40
8010170b:	ff 75 08             	pushl  0x8(%ebp)
8010170e:	e8 d5 fc ff ff       	call   801013e8 <readsb>
80101713:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101716:	a1 58 1a 11 80       	mov    0x80111a58,%eax
8010171b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010171e:	8b 3d 54 1a 11 80    	mov    0x80111a54,%edi
80101724:	8b 35 50 1a 11 80    	mov    0x80111a50,%esi
8010172a:	8b 1d 4c 1a 11 80    	mov    0x80111a4c,%ebx
80101730:	8b 0d 48 1a 11 80    	mov    0x80111a48,%ecx
80101736:	8b 15 44 1a 11 80    	mov    0x80111a44,%edx
8010173c:	a1 40 1a 11 80       	mov    0x80111a40,%eax
80101741:	ff 75 d4             	pushl  -0x2c(%ebp)
80101744:	57                   	push   %edi
80101745:	56                   	push   %esi
80101746:	53                   	push   %ebx
80101747:	51                   	push   %ecx
80101748:	52                   	push   %edx
80101749:	50                   	push   %eax
8010174a:	68 e4 83 10 80       	push   $0x801083e4
8010174f:	e8 a8 ec ff ff       	call   801003fc <cprintf>
80101754:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101757:	90                   	nop
80101758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010175b:	5b                   	pop    %ebx
8010175c:	5e                   	pop    %esi
8010175d:	5f                   	pop    %edi
8010175e:	5d                   	pop    %ebp
8010175f:	c3                   	ret    

80101760 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	83 ec 28             	sub    $0x28,%esp
80101766:	8b 45 0c             	mov    0xc(%ebp),%eax
80101769:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010176d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101774:	e9 9e 00 00 00       	jmp    80101817 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177c:	c1 e8 03             	shr    $0x3,%eax
8010177f:	89 c2                	mov    %eax,%edx
80101781:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101786:	01 d0                	add    %edx,%eax
80101788:	83 ec 08             	sub    $0x8,%esp
8010178b:	50                   	push   %eax
8010178c:	ff 75 08             	pushl  0x8(%ebp)
8010178f:	e8 3a ea ff ff       	call   801001ce <bread>
80101794:	83 c4 10             	add    $0x10,%esp
80101797:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010179a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179d:	8d 50 5c             	lea    0x5c(%eax),%edx
801017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a3:	83 e0 07             	and    $0x7,%eax
801017a6:	c1 e0 06             	shl    $0x6,%eax
801017a9:	01 d0                	add    %edx,%eax
801017ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017b1:	0f b7 00             	movzwl (%eax),%eax
801017b4:	66 85 c0             	test   %ax,%ax
801017b7:	75 4c                	jne    80101805 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017b9:	83 ec 04             	sub    $0x4,%esp
801017bc:	6a 40                	push   $0x40
801017be:	6a 00                	push   $0x0
801017c0:	ff 75 ec             	pushl  -0x14(%ebp)
801017c3:	e8 0b 3a 00 00       	call   801051d3 <memset>
801017c8:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ce:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017d2:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017d5:	83 ec 0c             	sub    $0xc,%esp
801017d8:	ff 75 f0             	pushl  -0x10(%ebp)
801017db:	e8 8e 1f 00 00       	call   8010376e <log_write>
801017e0:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017e3:	83 ec 0c             	sub    $0xc,%esp
801017e6:	ff 75 f0             	pushl  -0x10(%ebp)
801017e9:	e8 62 ea ff ff       	call   80100250 <brelse>
801017ee:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f4:	83 ec 08             	sub    $0x8,%esp
801017f7:	50                   	push   %eax
801017f8:	ff 75 08             	pushl  0x8(%ebp)
801017fb:	e8 f8 00 00 00       	call   801018f8 <iget>
80101800:	83 c4 10             	add    $0x10,%esp
80101803:	eb 30                	jmp    80101835 <ialloc+0xd5>
    }
    brelse(bp);
80101805:	83 ec 0c             	sub    $0xc,%esp
80101808:	ff 75 f0             	pushl  -0x10(%ebp)
8010180b:	e8 40 ea ff ff       	call   80100250 <brelse>
80101810:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101813:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101817:	8b 15 48 1a 11 80    	mov    0x80111a48,%edx
8010181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101820:	39 c2                	cmp    %eax,%edx
80101822:	0f 87 51 ff ff ff    	ja     80101779 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101828:	83 ec 0c             	sub    $0xc,%esp
8010182b:	68 37 84 10 80       	push   $0x80108437
80101830:	e8 67 ed ff ff       	call   8010059c <panic>
}
80101835:	c9                   	leave  
80101836:	c3                   	ret    

80101837 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101837:	55                   	push   %ebp
80101838:	89 e5                	mov    %esp,%ebp
8010183a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010183d:	8b 45 08             	mov    0x8(%ebp),%eax
80101840:	8b 40 04             	mov    0x4(%eax),%eax
80101843:	c1 e8 03             	shr    $0x3,%eax
80101846:	89 c2                	mov    %eax,%edx
80101848:	a1 54 1a 11 80       	mov    0x80111a54,%eax
8010184d:	01 c2                	add    %eax,%edx
8010184f:	8b 45 08             	mov    0x8(%ebp),%eax
80101852:	8b 00                	mov    (%eax),%eax
80101854:	83 ec 08             	sub    $0x8,%esp
80101857:	52                   	push   %edx
80101858:	50                   	push   %eax
80101859:	e8 70 e9 ff ff       	call   801001ce <bread>
8010185e:	83 c4 10             	add    $0x10,%esp
80101861:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101867:	8d 50 5c             	lea    0x5c(%eax),%edx
8010186a:	8b 45 08             	mov    0x8(%ebp),%eax
8010186d:	8b 40 04             	mov    0x4(%eax),%eax
80101870:	83 e0 07             	and    $0x7,%eax
80101873:	c1 e0 06             	shl    $0x6,%eax
80101876:	01 d0                	add    %edx,%eax
80101878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010187b:	8b 45 08             	mov    0x8(%ebp),%eax
8010187e:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101882:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101885:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101888:	8b 45 08             	mov    0x8(%ebp),%eax
8010188b:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010188f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101892:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101896:	8b 45 08             	mov    0x8(%ebp),%eax
80101899:	0f b7 50 54          	movzwl 0x54(%eax),%edx
8010189d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a0:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018a4:	8b 45 08             	mov    0x8(%ebp),%eax
801018a7:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801018ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ae:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018b2:	8b 45 08             	mov    0x8(%ebp),%eax
801018b5:	8b 50 58             	mov    0x58(%eax),%edx
801018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018bb:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018be:	8b 45 08             	mov    0x8(%ebp),%eax
801018c1:	8d 50 5c             	lea    0x5c(%eax),%edx
801018c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c7:	83 c0 0c             	add    $0xc,%eax
801018ca:	83 ec 04             	sub    $0x4,%esp
801018cd:	6a 34                	push   $0x34
801018cf:	52                   	push   %edx
801018d0:	50                   	push   %eax
801018d1:	e8 bc 39 00 00       	call   80105292 <memmove>
801018d6:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018d9:	83 ec 0c             	sub    $0xc,%esp
801018dc:	ff 75 f4             	pushl  -0xc(%ebp)
801018df:	e8 8a 1e 00 00       	call   8010376e <log_write>
801018e4:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018e7:	83 ec 0c             	sub    $0xc,%esp
801018ea:	ff 75 f4             	pushl  -0xc(%ebp)
801018ed:	e8 5e e9 ff ff       	call   80100250 <brelse>
801018f2:	83 c4 10             	add    $0x10,%esp
}
801018f5:	90                   	nop
801018f6:	c9                   	leave  
801018f7:	c3                   	ret    

801018f8 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018f8:	55                   	push   %ebp
801018f9:	89 e5                	mov    %esp,%ebp
801018fb:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018fe:	83 ec 0c             	sub    $0xc,%esp
80101901:	68 60 1a 11 80       	push   $0x80111a60
80101906:	e8 51 36 00 00       	call   80104f5c <acquire>
8010190b:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010190e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101915:	c7 45 f4 94 1a 11 80 	movl   $0x80111a94,-0xc(%ebp)
8010191c:	eb 60                	jmp    8010197e <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101921:	8b 40 08             	mov    0x8(%eax),%eax
80101924:	85 c0                	test   %eax,%eax
80101926:	7e 39                	jle    80101961 <iget+0x69>
80101928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192b:	8b 00                	mov    (%eax),%eax
8010192d:	39 45 08             	cmp    %eax,0x8(%ebp)
80101930:	75 2f                	jne    80101961 <iget+0x69>
80101932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101935:	8b 40 04             	mov    0x4(%eax),%eax
80101938:	39 45 0c             	cmp    %eax,0xc(%ebp)
8010193b:	75 24                	jne    80101961 <iget+0x69>
      ip->ref++;
8010193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101940:	8b 40 08             	mov    0x8(%eax),%eax
80101943:	8d 50 01             	lea    0x1(%eax),%edx
80101946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101949:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010194c:	83 ec 0c             	sub    $0xc,%esp
8010194f:	68 60 1a 11 80       	push   $0x80111a60
80101954:	e8 71 36 00 00       	call   80104fca <release>
80101959:	83 c4 10             	add    $0x10,%esp
      return ip;
8010195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195f:	eb 77                	jmp    801019d8 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101961:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101965:	75 10                	jne    80101977 <iget+0x7f>
80101967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196a:	8b 40 08             	mov    0x8(%eax),%eax
8010196d:	85 c0                	test   %eax,%eax
8010196f:	75 06                	jne    80101977 <iget+0x7f>
      empty = ip;
80101971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101974:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101977:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010197e:	81 7d f4 b4 36 11 80 	cmpl   $0x801136b4,-0xc(%ebp)
80101985:	72 97                	jb     8010191e <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101987:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010198b:	75 0d                	jne    8010199a <iget+0xa2>
    panic("iget: no inodes");
8010198d:	83 ec 0c             	sub    $0xc,%esp
80101990:	68 49 84 10 80       	push   $0x80108449
80101995:	e8 02 ec ff ff       	call   8010059c <panic>

  ip = empty;
8010199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a3:	8b 55 08             	mov    0x8(%ebp),%edx
801019a6:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801019ae:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019be:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019c5:	83 ec 0c             	sub    $0xc,%esp
801019c8:	68 60 1a 11 80       	push   $0x80111a60
801019cd:	e8 f8 35 00 00       	call   80104fca <release>
801019d2:	83 c4 10             	add    $0x10,%esp

  return ip;
801019d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019d8:	c9                   	leave  
801019d9:	c3                   	ret    

801019da <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019da:	55                   	push   %ebp
801019db:	89 e5                	mov    %esp,%ebp
801019dd:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	68 60 1a 11 80       	push   $0x80111a60
801019e8:	e8 6f 35 00 00       	call   80104f5c <acquire>
801019ed:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019f0:	8b 45 08             	mov    0x8(%ebp),%eax
801019f3:	8b 40 08             	mov    0x8(%eax),%eax
801019f6:	8d 50 01             	lea    0x1(%eax),%edx
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019ff:	83 ec 0c             	sub    $0xc,%esp
80101a02:	68 60 1a 11 80       	push   $0x80111a60
80101a07:	e8 be 35 00 00       	call   80104fca <release>
80101a0c:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a12:	c9                   	leave  
80101a13:	c3                   	ret    

80101a14 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a1e:	74 0a                	je     80101a2a <ilock+0x16>
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	8b 40 08             	mov    0x8(%eax),%eax
80101a26:	85 c0                	test   %eax,%eax
80101a28:	7f 0d                	jg     80101a37 <ilock+0x23>
    panic("ilock");
80101a2a:	83 ec 0c             	sub    $0xc,%esp
80101a2d:	68 59 84 10 80       	push   $0x80108459
80101a32:	e8 65 eb ff ff       	call   8010059c <panic>

  acquiresleep(&ip->lock);
80101a37:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3a:	83 c0 0c             	add    $0xc,%eax
80101a3d:	83 ec 0c             	sub    $0xc,%esp
80101a40:	50                   	push   %eax
80101a41:	e8 d3 33 00 00       	call   80104e19 <acquiresleep>
80101a46:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a4f:	85 c0                	test   %eax,%eax
80101a51:	0f 85 cd 00 00 00    	jne    80101b24 <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a57:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5a:	8b 40 04             	mov    0x4(%eax),%eax
80101a5d:	c1 e8 03             	shr    $0x3,%eax
80101a60:	89 c2                	mov    %eax,%edx
80101a62:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101a67:	01 c2                	add    %eax,%edx
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 00                	mov    (%eax),%eax
80101a6e:	83 ec 08             	sub    $0x8,%esp
80101a71:	52                   	push   %edx
80101a72:	50                   	push   %eax
80101a73:	e8 56 e7 ff ff       	call   801001ce <bread>
80101a78:	83 c4 10             	add    $0x10,%esp
80101a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a81:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a84:	8b 45 08             	mov    0x8(%ebp),%eax
80101a87:	8b 40 04             	mov    0x4(%eax),%eax
80101a8a:	83 e0 07             	and    $0x7,%eax
80101a8d:	c1 e0 06             	shl    $0x6,%eax
80101a90:	01 d0                	add    %edx,%eax
80101a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a98:	0f b7 10             	movzwl (%eax),%edx
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa5:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab3:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac1:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac8:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101acf:	8b 50 08             	mov    0x8(%eax),%edx
80101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad5:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101adb:	8d 50 0c             	lea    0xc(%eax),%edx
80101ade:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae1:	83 c0 5c             	add    $0x5c,%eax
80101ae4:	83 ec 04             	sub    $0x4,%esp
80101ae7:	6a 34                	push   $0x34
80101ae9:	52                   	push   %edx
80101aea:	50                   	push   %eax
80101aeb:	e8 a2 37 00 00       	call   80105292 <memmove>
80101af0:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101af3:	83 ec 0c             	sub    $0xc,%esp
80101af6:	ff 75 f4             	pushl  -0xc(%ebp)
80101af9:	e8 52 e7 ff ff       	call   80100250 <brelse>
80101afe:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101b01:	8b 45 08             	mov    0x8(%ebp),%eax
80101b04:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0e:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101b12:	66 85 c0             	test   %ax,%ax
80101b15:	75 0d                	jne    80101b24 <ilock+0x110>
      panic("ilock: no type");
80101b17:	83 ec 0c             	sub    $0xc,%esp
80101b1a:	68 5f 84 10 80       	push   $0x8010845f
80101b1f:	e8 78 ea ff ff       	call   8010059c <panic>
  }
}
80101b24:	90                   	nop
80101b25:	c9                   	leave  
80101b26:	c3                   	ret    

80101b27 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b27:	55                   	push   %ebp
80101b28:	89 e5                	mov    %esp,%ebp
80101b2a:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b31:	74 20                	je     80101b53 <iunlock+0x2c>
80101b33:	8b 45 08             	mov    0x8(%ebp),%eax
80101b36:	83 c0 0c             	add    $0xc,%eax
80101b39:	83 ec 0c             	sub    $0xc,%esp
80101b3c:	50                   	push   %eax
80101b3d:	e8 89 33 00 00       	call   80104ecb <holdingsleep>
80101b42:	83 c4 10             	add    $0x10,%esp
80101b45:	85 c0                	test   %eax,%eax
80101b47:	74 0a                	je     80101b53 <iunlock+0x2c>
80101b49:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4c:	8b 40 08             	mov    0x8(%eax),%eax
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	7f 0d                	jg     80101b60 <iunlock+0x39>
    panic("iunlock");
80101b53:	83 ec 0c             	sub    $0xc,%esp
80101b56:	68 6e 84 10 80       	push   $0x8010846e
80101b5b:	e8 3c ea ff ff       	call   8010059c <panic>

  releasesleep(&ip->lock);
80101b60:	8b 45 08             	mov    0x8(%ebp),%eax
80101b63:	83 c0 0c             	add    $0xc,%eax
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	50                   	push   %eax
80101b6a:	e8 0e 33 00 00       	call   80104e7d <releasesleep>
80101b6f:	83 c4 10             	add    $0x10,%esp
}
80101b72:	90                   	nop
80101b73:	c9                   	leave  
80101b74:	c3                   	ret    

80101b75 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b75:	55                   	push   %ebp
80101b76:	89 e5                	mov    %esp,%ebp
80101b78:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7e:	83 c0 0c             	add    $0xc,%eax
80101b81:	83 ec 0c             	sub    $0xc,%esp
80101b84:	50                   	push   %eax
80101b85:	e8 8f 32 00 00       	call   80104e19 <acquiresleep>
80101b8a:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b90:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b93:	85 c0                	test   %eax,%eax
80101b95:	74 6a                	je     80101c01 <iput+0x8c>
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b9e:	66 85 c0             	test   %ax,%ax
80101ba1:	75 5e                	jne    80101c01 <iput+0x8c>
    acquire(&icache.lock);
80101ba3:	83 ec 0c             	sub    $0xc,%esp
80101ba6:	68 60 1a 11 80       	push   $0x80111a60
80101bab:	e8 ac 33 00 00       	call   80104f5c <acquire>
80101bb0:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb6:	8b 40 08             	mov    0x8(%eax),%eax
80101bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101bbc:	83 ec 0c             	sub    $0xc,%esp
80101bbf:	68 60 1a 11 80       	push   $0x80111a60
80101bc4:	e8 01 34 00 00       	call   80104fca <release>
80101bc9:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101bcc:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bd0:	75 2f                	jne    80101c01 <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bd2:	83 ec 0c             	sub    $0xc,%esp
80101bd5:	ff 75 08             	pushl  0x8(%ebp)
80101bd8:	e8 ad 01 00 00       	call   80101d8a <itrunc>
80101bdd:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101be0:	8b 45 08             	mov    0x8(%ebp),%eax
80101be3:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	ff 75 08             	pushl  0x8(%ebp)
80101bef:	e8 43 fc ff ff       	call   80101837 <iupdate>
80101bf4:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfa:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101c01:	8b 45 08             	mov    0x8(%ebp),%eax
80101c04:	83 c0 0c             	add    $0xc,%eax
80101c07:	83 ec 0c             	sub    $0xc,%esp
80101c0a:	50                   	push   %eax
80101c0b:	e8 6d 32 00 00       	call   80104e7d <releasesleep>
80101c10:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101c13:	83 ec 0c             	sub    $0xc,%esp
80101c16:	68 60 1a 11 80       	push   $0x80111a60
80101c1b:	e8 3c 33 00 00       	call   80104f5c <acquire>
80101c20:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c23:	8b 45 08             	mov    0x8(%ebp),%eax
80101c26:	8b 40 08             	mov    0x8(%eax),%eax
80101c29:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c32:	83 ec 0c             	sub    $0xc,%esp
80101c35:	68 60 1a 11 80       	push   $0x80111a60
80101c3a:	e8 8b 33 00 00       	call   80104fca <release>
80101c3f:	83 c4 10             	add    $0x10,%esp
}
80101c42:	90                   	nop
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    

80101c45 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c45:	55                   	push   %ebp
80101c46:	89 e5                	mov    %esp,%ebp
80101c48:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c4b:	83 ec 0c             	sub    $0xc,%esp
80101c4e:	ff 75 08             	pushl  0x8(%ebp)
80101c51:	e8 d1 fe ff ff       	call   80101b27 <iunlock>
80101c56:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c59:	83 ec 0c             	sub    $0xc,%esp
80101c5c:	ff 75 08             	pushl  0x8(%ebp)
80101c5f:	e8 11 ff ff ff       	call   80101b75 <iput>
80101c64:	83 c4 10             	add    $0x10,%esp
}
80101c67:	90                   	nop
80101c68:	c9                   	leave  
80101c69:	c3                   	ret    

80101c6a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c6a:	55                   	push   %ebp
80101c6b:	89 e5                	mov    %esp,%ebp
80101c6d:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c70:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c74:	77 42                	ja     80101cb8 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c76:	8b 45 08             	mov    0x8(%ebp),%eax
80101c79:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c7c:	83 c2 14             	add    $0x14,%edx
80101c7f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c8a:	75 24                	jne    80101cb0 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8f:	8b 00                	mov    (%eax),%eax
80101c91:	83 ec 0c             	sub    $0xc,%esp
80101c94:	50                   	push   %eax
80101c95:	e8 e4 f7 ff ff       	call   8010147e <balloc>
80101c9a:	83 c4 10             	add    $0x10,%esp
80101c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ca6:	8d 4a 14             	lea    0x14(%edx),%ecx
80101ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cac:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cb3:	e9 d0 00 00 00       	jmp    80101d88 <bmap+0x11e>
  }
  bn -= NDIRECT;
80101cb8:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cbc:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cc0:	0f 87 b5 00 00 00    	ja     80101d7b <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc9:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cd6:	75 20                	jne    80101cf8 <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdb:	8b 00                	mov    (%eax),%eax
80101cdd:	83 ec 0c             	sub    $0xc,%esp
80101ce0:	50                   	push   %eax
80101ce1:	e8 98 f7 ff ff       	call   8010147e <balloc>
80101ce6:	83 c4 10             	add    $0x10,%esp
80101ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cec:	8b 45 08             	mov    0x8(%ebp),%eax
80101cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cf2:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfb:	8b 00                	mov    (%eax),%eax
80101cfd:	83 ec 08             	sub    $0x8,%esp
80101d00:	ff 75 f4             	pushl  -0xc(%ebp)
80101d03:	50                   	push   %eax
80101d04:	e8 c5 e4 ff ff       	call   801001ce <bread>
80101d09:	83 c4 10             	add    $0x10,%esp
80101d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d12:	83 c0 5c             	add    $0x5c,%eax
80101d15:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d18:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d22:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d25:	01 d0                	add    %edx,%eax
80101d27:	8b 00                	mov    (%eax),%eax
80101d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d30:	75 36                	jne    80101d68 <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	8b 00                	mov    (%eax),%eax
80101d37:	83 ec 0c             	sub    $0xc,%esp
80101d3a:	50                   	push   %eax
80101d3b:	e8 3e f7 ff ff       	call   8010147e <balloc>
80101d40:	83 c4 10             	add    $0x10,%esp
80101d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d53:	01 c2                	add    %eax,%edx
80101d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d58:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d5a:	83 ec 0c             	sub    $0xc,%esp
80101d5d:	ff 75 f0             	pushl  -0x10(%ebp)
80101d60:	e8 09 1a 00 00       	call   8010376e <log_write>
80101d65:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d68:	83 ec 0c             	sub    $0xc,%esp
80101d6b:	ff 75 f0             	pushl  -0x10(%ebp)
80101d6e:	e8 dd e4 ff ff       	call   80100250 <brelse>
80101d73:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d79:	eb 0d                	jmp    80101d88 <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d7b:	83 ec 0c             	sub    $0xc,%esp
80101d7e:	68 76 84 10 80       	push   $0x80108476
80101d83:	e8 14 e8 ff ff       	call   8010059c <panic>
}
80101d88:	c9                   	leave  
80101d89:	c3                   	ret    

80101d8a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d8a:	55                   	push   %ebp
80101d8b:	89 e5                	mov    %esp,%ebp
80101d8d:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d97:	eb 45                	jmp    80101dde <itrunc+0x54>
    if(ip->addrs[i]){
80101d99:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9f:	83 c2 14             	add    $0x14,%edx
80101da2:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101da6:	85 c0                	test   %eax,%eax
80101da8:	74 30                	je     80101dda <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101daa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101db0:	83 c2 14             	add    $0x14,%edx
80101db3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101db7:	8b 55 08             	mov    0x8(%ebp),%edx
80101dba:	8b 12                	mov    (%edx),%edx
80101dbc:	83 ec 08             	sub    $0x8,%esp
80101dbf:	50                   	push   %eax
80101dc0:	52                   	push   %edx
80101dc1:	e8 04 f8 ff ff       	call   801015ca <bfree>
80101dc6:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dcf:	83 c2 14             	add    $0x14,%edx
80101dd2:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dd9:	00 
  for(i = 0; i < NDIRECT; i++){
80101dda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dde:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101de2:	7e b5                	jle    80101d99 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101de4:	8b 45 08             	mov    0x8(%ebp),%eax
80101de7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ded:	85 c0                	test   %eax,%eax
80101def:	0f 84 aa 00 00 00    	je     80101e9f <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101df5:	8b 45 08             	mov    0x8(%ebp),%eax
80101df8:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80101e01:	8b 00                	mov    (%eax),%eax
80101e03:	83 ec 08             	sub    $0x8,%esp
80101e06:	52                   	push   %edx
80101e07:	50                   	push   %eax
80101e08:	e8 c1 e3 ff ff       	call   801001ce <bread>
80101e0d:	83 c4 10             	add    $0x10,%esp
80101e10:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e16:	83 c0 5c             	add    $0x5c,%eax
80101e19:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e23:	eb 3c                	jmp    80101e61 <itrunc+0xd7>
      if(a[j])
80101e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e32:	01 d0                	add    %edx,%eax
80101e34:	8b 00                	mov    (%eax),%eax
80101e36:	85 c0                	test   %eax,%eax
80101e38:	74 23                	je     80101e5d <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e47:	01 d0                	add    %edx,%eax
80101e49:	8b 00                	mov    (%eax),%eax
80101e4b:	8b 55 08             	mov    0x8(%ebp),%edx
80101e4e:	8b 12                	mov    (%edx),%edx
80101e50:	83 ec 08             	sub    $0x8,%esp
80101e53:	50                   	push   %eax
80101e54:	52                   	push   %edx
80101e55:	e8 70 f7 ff ff       	call   801015ca <bfree>
80101e5a:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e5d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e64:	83 f8 7f             	cmp    $0x7f,%eax
80101e67:	76 bc                	jbe    80101e25 <itrunc+0x9b>
    }
    brelse(bp);
80101e69:	83 ec 0c             	sub    $0xc,%esp
80101e6c:	ff 75 ec             	pushl  -0x14(%ebp)
80101e6f:	e8 dc e3 ff ff       	call   80100250 <brelse>
80101e74:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e77:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7a:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e80:	8b 55 08             	mov    0x8(%ebp),%edx
80101e83:	8b 12                	mov    (%edx),%edx
80101e85:	83 ec 08             	sub    $0x8,%esp
80101e88:	50                   	push   %eax
80101e89:	52                   	push   %edx
80101e8a:	e8 3b f7 ff ff       	call   801015ca <bfree>
80101e8f:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e92:	8b 45 08             	mov    0x8(%ebp),%eax
80101e95:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e9c:	00 00 00 
  }

  ip->size = 0;
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101ea9:	83 ec 0c             	sub    $0xc,%esp
80101eac:	ff 75 08             	pushl  0x8(%ebp)
80101eaf:	e8 83 f9 ff ff       	call   80101837 <iupdate>
80101eb4:	83 c4 10             	add    $0x10,%esp
}
80101eb7:	90                   	nop
80101eb8:	c9                   	leave  
80101eb9:	c3                   	ret    

80101eba <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101eba:	55                   	push   %ebp
80101ebb:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec0:	8b 00                	mov    (%eax),%eax
80101ec2:	89 c2                	mov    %eax,%edx
80101ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec7:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101eca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecd:	8b 50 04             	mov    0x4(%eax),%edx
80101ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed3:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ed6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed9:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101edd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee0:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee6:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eed:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef4:	8b 50 58             	mov    0x58(%eax),%edx
80101ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101efa:	89 50 10             	mov    %edx,0x10(%eax)
}
80101efd:	90                   	nop
80101efe:	5d                   	pop    %ebp
80101eff:	c3                   	ret    

80101f00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f06:	8b 45 08             	mov    0x8(%ebp),%eax
80101f09:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f0d:	66 83 f8 03          	cmp    $0x3,%ax
80101f11:	75 5c                	jne    80101f6f <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f13:	8b 45 08             	mov    0x8(%ebp),%eax
80101f16:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f1a:	66 85 c0             	test   %ax,%ax
80101f1d:	78 20                	js     80101f3f <readi+0x3f>
80101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f22:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f26:	66 83 f8 09          	cmp    $0x9,%ax
80101f2a:	7f 13                	jg     80101f3f <readi+0x3f>
80101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f33:	98                   	cwtl   
80101f34:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101f3b:	85 c0                	test   %eax,%eax
80101f3d:	75 0a                	jne    80101f49 <readi+0x49>
      return -1;
80101f3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f44:	e9 0c 01 00 00       	jmp    80102055 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f49:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f50:	98                   	cwtl   
80101f51:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101f58:	8b 55 14             	mov    0x14(%ebp),%edx
80101f5b:	83 ec 04             	sub    $0x4,%esp
80101f5e:	52                   	push   %edx
80101f5f:	ff 75 0c             	pushl  0xc(%ebp)
80101f62:	ff 75 08             	pushl  0x8(%ebp)
80101f65:	ff d0                	call   *%eax
80101f67:	83 c4 10             	add    $0x10,%esp
80101f6a:	e9 e6 00 00 00       	jmp    80102055 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	8b 40 58             	mov    0x58(%eax),%eax
80101f75:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f78:	77 0d                	ja     80101f87 <readi+0x87>
80101f7a:	8b 55 10             	mov    0x10(%ebp),%edx
80101f7d:	8b 45 14             	mov    0x14(%ebp),%eax
80101f80:	01 d0                	add    %edx,%eax
80101f82:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f85:	76 0a                	jbe    80101f91 <readi+0x91>
    return -1;
80101f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f8c:	e9 c4 00 00 00       	jmp    80102055 <readi+0x155>
  if(off + n > ip->size)
80101f91:	8b 55 10             	mov    0x10(%ebp),%edx
80101f94:	8b 45 14             	mov    0x14(%ebp),%eax
80101f97:	01 c2                	add    %eax,%edx
80101f99:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9c:	8b 40 58             	mov    0x58(%eax),%eax
80101f9f:	39 c2                	cmp    %eax,%edx
80101fa1:	76 0c                	jbe    80101faf <readi+0xaf>
    n = ip->size - off;
80101fa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa6:	8b 40 58             	mov    0x58(%eax),%eax
80101fa9:	2b 45 10             	sub    0x10(%ebp),%eax
80101fac:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fb6:	e9 8b 00 00 00       	jmp    80102046 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fbb:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbe:	c1 e8 09             	shr    $0x9,%eax
80101fc1:	83 ec 08             	sub    $0x8,%esp
80101fc4:	50                   	push   %eax
80101fc5:	ff 75 08             	pushl  0x8(%ebp)
80101fc8:	e8 9d fc ff ff       	call   80101c6a <bmap>
80101fcd:	83 c4 10             	add    $0x10,%esp
80101fd0:	89 c2                	mov    %eax,%edx
80101fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd5:	8b 00                	mov    (%eax),%eax
80101fd7:	83 ec 08             	sub    $0x8,%esp
80101fda:	52                   	push   %edx
80101fdb:	50                   	push   %eax
80101fdc:	e8 ed e1 ff ff       	call   801001ce <bread>
80101fe1:	83 c4 10             	add    $0x10,%esp
80101fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fea:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fef:	ba 00 02 00 00       	mov    $0x200,%edx
80101ff4:	29 c2                	sub    %eax,%edx
80101ff6:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff9:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101ffc:	39 c2                	cmp    %eax,%edx
80101ffe:	0f 46 c2             	cmovbe %edx,%eax
80102001:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102004:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102007:	8d 50 5c             	lea    0x5c(%eax),%edx
8010200a:	8b 45 10             	mov    0x10(%ebp),%eax
8010200d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102012:	01 d0                	add    %edx,%eax
80102014:	83 ec 04             	sub    $0x4,%esp
80102017:	ff 75 ec             	pushl  -0x14(%ebp)
8010201a:	50                   	push   %eax
8010201b:	ff 75 0c             	pushl  0xc(%ebp)
8010201e:	e8 6f 32 00 00       	call   80105292 <memmove>
80102023:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102026:	83 ec 0c             	sub    $0xc,%esp
80102029:	ff 75 f0             	pushl  -0x10(%ebp)
8010202c:	e8 1f e2 ff ff       	call   80100250 <brelse>
80102031:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102034:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102037:	01 45 f4             	add    %eax,-0xc(%ebp)
8010203a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203d:	01 45 10             	add    %eax,0x10(%ebp)
80102040:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102043:	01 45 0c             	add    %eax,0xc(%ebp)
80102046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102049:	3b 45 14             	cmp    0x14(%ebp),%eax
8010204c:	0f 82 69 ff ff ff    	jb     80101fbb <readi+0xbb>
  }
  return n;
80102052:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102055:	c9                   	leave  
80102056:	c3                   	ret    

80102057 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102057:	55                   	push   %ebp
80102058:	89 e5                	mov    %esp,%ebp
8010205a:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010205d:	8b 45 08             	mov    0x8(%ebp),%eax
80102060:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102064:	66 83 f8 03          	cmp    $0x3,%ax
80102068:	75 5c                	jne    801020c6 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010206a:	8b 45 08             	mov    0x8(%ebp),%eax
8010206d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102071:	66 85 c0             	test   %ax,%ax
80102074:	78 20                	js     80102096 <writei+0x3f>
80102076:	8b 45 08             	mov    0x8(%ebp),%eax
80102079:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010207d:	66 83 f8 09          	cmp    $0x9,%ax
80102081:	7f 13                	jg     80102096 <writei+0x3f>
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010208a:	98                   	cwtl   
8010208b:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80102092:	85 c0                	test   %eax,%eax
80102094:	75 0a                	jne    801020a0 <writei+0x49>
      return -1;
80102096:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010209b:	e9 3d 01 00 00       	jmp    801021dd <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801020a0:	8b 45 08             	mov    0x8(%ebp),%eax
801020a3:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020a7:	98                   	cwtl   
801020a8:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
801020af:	8b 55 14             	mov    0x14(%ebp),%edx
801020b2:	83 ec 04             	sub    $0x4,%esp
801020b5:	52                   	push   %edx
801020b6:	ff 75 0c             	pushl  0xc(%ebp)
801020b9:	ff 75 08             	pushl  0x8(%ebp)
801020bc:	ff d0                	call   *%eax
801020be:	83 c4 10             	add    $0x10,%esp
801020c1:	e9 17 01 00 00       	jmp    801021dd <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020c6:	8b 45 08             	mov    0x8(%ebp),%eax
801020c9:	8b 40 58             	mov    0x58(%eax),%eax
801020cc:	39 45 10             	cmp    %eax,0x10(%ebp)
801020cf:	77 0d                	ja     801020de <writei+0x87>
801020d1:	8b 55 10             	mov    0x10(%ebp),%edx
801020d4:	8b 45 14             	mov    0x14(%ebp),%eax
801020d7:	01 d0                	add    %edx,%eax
801020d9:	39 45 10             	cmp    %eax,0x10(%ebp)
801020dc:	76 0a                	jbe    801020e8 <writei+0x91>
    return -1;
801020de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e3:	e9 f5 00 00 00       	jmp    801021dd <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801020e8:	8b 55 10             	mov    0x10(%ebp),%edx
801020eb:	8b 45 14             	mov    0x14(%ebp),%eax
801020ee:	01 d0                	add    %edx,%eax
801020f0:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020f5:	76 0a                	jbe    80102101 <writei+0xaa>
    return -1;
801020f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020fc:	e9 dc 00 00 00       	jmp    801021dd <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102108:	e9 99 00 00 00       	jmp    801021a6 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010210d:	8b 45 10             	mov    0x10(%ebp),%eax
80102110:	c1 e8 09             	shr    $0x9,%eax
80102113:	83 ec 08             	sub    $0x8,%esp
80102116:	50                   	push   %eax
80102117:	ff 75 08             	pushl  0x8(%ebp)
8010211a:	e8 4b fb ff ff       	call   80101c6a <bmap>
8010211f:	83 c4 10             	add    $0x10,%esp
80102122:	89 c2                	mov    %eax,%edx
80102124:	8b 45 08             	mov    0x8(%ebp),%eax
80102127:	8b 00                	mov    (%eax),%eax
80102129:	83 ec 08             	sub    $0x8,%esp
8010212c:	52                   	push   %edx
8010212d:	50                   	push   %eax
8010212e:	e8 9b e0 ff ff       	call   801001ce <bread>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102139:	8b 45 10             	mov    0x10(%ebp),%eax
8010213c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102141:	ba 00 02 00 00       	mov    $0x200,%edx
80102146:	29 c2                	sub    %eax,%edx
80102148:	8b 45 14             	mov    0x14(%ebp),%eax
8010214b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010214e:	39 c2                	cmp    %eax,%edx
80102150:	0f 46 c2             	cmovbe %edx,%eax
80102153:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102159:	8d 50 5c             	lea    0x5c(%eax),%edx
8010215c:	8b 45 10             	mov    0x10(%ebp),%eax
8010215f:	25 ff 01 00 00       	and    $0x1ff,%eax
80102164:	01 d0                	add    %edx,%eax
80102166:	83 ec 04             	sub    $0x4,%esp
80102169:	ff 75 ec             	pushl  -0x14(%ebp)
8010216c:	ff 75 0c             	pushl  0xc(%ebp)
8010216f:	50                   	push   %eax
80102170:	e8 1d 31 00 00       	call   80105292 <memmove>
80102175:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	ff 75 f0             	pushl  -0x10(%ebp)
8010217e:	e8 eb 15 00 00       	call   8010376e <log_write>
80102183:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102186:	83 ec 0c             	sub    $0xc,%esp
80102189:	ff 75 f0             	pushl  -0x10(%ebp)
8010218c:	e8 bf e0 ff ff       	call   80100250 <brelse>
80102191:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102194:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102197:	01 45 f4             	add    %eax,-0xc(%ebp)
8010219a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219d:	01 45 10             	add    %eax,0x10(%ebp)
801021a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021a3:	01 45 0c             	add    %eax,0xc(%ebp)
801021a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021a9:	3b 45 14             	cmp    0x14(%ebp),%eax
801021ac:	0f 82 5b ff ff ff    	jb     8010210d <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
801021b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021b6:	74 22                	je     801021da <writei+0x183>
801021b8:	8b 45 08             	mov    0x8(%ebp),%eax
801021bb:	8b 40 58             	mov    0x58(%eax),%eax
801021be:	39 45 10             	cmp    %eax,0x10(%ebp)
801021c1:	76 17                	jbe    801021da <writei+0x183>
    ip->size = off;
801021c3:	8b 45 08             	mov    0x8(%ebp),%eax
801021c6:	8b 55 10             	mov    0x10(%ebp),%edx
801021c9:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021cc:	83 ec 0c             	sub    $0xc,%esp
801021cf:	ff 75 08             	pushl  0x8(%ebp)
801021d2:	e8 60 f6 ff ff       	call   80101837 <iupdate>
801021d7:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021da:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021dd:	c9                   	leave  
801021de:	c3                   	ret    

801021df <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021df:	55                   	push   %ebp
801021e0:	89 e5                	mov    %esp,%ebp
801021e2:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021e5:	83 ec 04             	sub    $0x4,%esp
801021e8:	6a 0e                	push   $0xe
801021ea:	ff 75 0c             	pushl  0xc(%ebp)
801021ed:	ff 75 08             	pushl  0x8(%ebp)
801021f0:	e8 33 31 00 00       	call   80105328 <strncmp>
801021f5:	83 c4 10             	add    $0x10,%esp
}
801021f8:	c9                   	leave  
801021f9:	c3                   	ret    

801021fa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021fa:	55                   	push   %ebp
801021fb:	89 e5                	mov    %esp,%ebp
801021fd:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102200:	8b 45 08             	mov    0x8(%ebp),%eax
80102203:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102207:	66 83 f8 01          	cmp    $0x1,%ax
8010220b:	74 0d                	je     8010221a <dirlookup+0x20>
    panic("dirlookup not DIR");
8010220d:	83 ec 0c             	sub    $0xc,%esp
80102210:	68 89 84 10 80       	push   $0x80108489
80102215:	e8 82 e3 ff ff       	call   8010059c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010221a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102221:	eb 7b                	jmp    8010229e <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102223:	6a 10                	push   $0x10
80102225:	ff 75 f4             	pushl  -0xc(%ebp)
80102228:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222b:	50                   	push   %eax
8010222c:	ff 75 08             	pushl  0x8(%ebp)
8010222f:	e8 cc fc ff ff       	call   80101f00 <readi>
80102234:	83 c4 10             	add    $0x10,%esp
80102237:	83 f8 10             	cmp    $0x10,%eax
8010223a:	74 0d                	je     80102249 <dirlookup+0x4f>
      panic("dirlookup read");
8010223c:	83 ec 0c             	sub    $0xc,%esp
8010223f:	68 9b 84 10 80       	push   $0x8010849b
80102244:	e8 53 e3 ff ff       	call   8010059c <panic>
    if(de.inum == 0)
80102249:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010224d:	66 85 c0             	test   %ax,%ax
80102250:	74 47                	je     80102299 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102252:	83 ec 08             	sub    $0x8,%esp
80102255:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102258:	83 c0 02             	add    $0x2,%eax
8010225b:	50                   	push   %eax
8010225c:	ff 75 0c             	pushl  0xc(%ebp)
8010225f:	e8 7b ff ff ff       	call   801021df <namecmp>
80102264:	83 c4 10             	add    $0x10,%esp
80102267:	85 c0                	test   %eax,%eax
80102269:	75 2f                	jne    8010229a <dirlookup+0xa0>
      // entry matches path element
      if(poff)
8010226b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010226f:	74 08                	je     80102279 <dirlookup+0x7f>
        *poff = off;
80102271:	8b 45 10             	mov    0x10(%ebp),%eax
80102274:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102277:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102279:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010227d:	0f b7 c0             	movzwl %ax,%eax
80102280:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102283:	8b 45 08             	mov    0x8(%ebp),%eax
80102286:	8b 00                	mov    (%eax),%eax
80102288:	83 ec 08             	sub    $0x8,%esp
8010228b:	ff 75 f0             	pushl  -0x10(%ebp)
8010228e:	50                   	push   %eax
8010228f:	e8 64 f6 ff ff       	call   801018f8 <iget>
80102294:	83 c4 10             	add    $0x10,%esp
80102297:	eb 19                	jmp    801022b2 <dirlookup+0xb8>
      continue;
80102299:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010229a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010229e:	8b 45 08             	mov    0x8(%ebp),%eax
801022a1:	8b 40 58             	mov    0x58(%eax),%eax
801022a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801022a7:	0f 82 76 ff ff ff    	jb     80102223 <dirlookup+0x29>
    }
  }

  return 0;
801022ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022b2:	c9                   	leave  
801022b3:	c3                   	ret    

801022b4 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022b4:	55                   	push   %ebp
801022b5:	89 e5                	mov    %esp,%ebp
801022b7:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022ba:	83 ec 04             	sub    $0x4,%esp
801022bd:	6a 00                	push   $0x0
801022bf:	ff 75 0c             	pushl  0xc(%ebp)
801022c2:	ff 75 08             	pushl  0x8(%ebp)
801022c5:	e8 30 ff ff ff       	call   801021fa <dirlookup>
801022ca:	83 c4 10             	add    $0x10,%esp
801022cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022d4:	74 18                	je     801022ee <dirlink+0x3a>
    iput(ip);
801022d6:	83 ec 0c             	sub    $0xc,%esp
801022d9:	ff 75 f0             	pushl  -0x10(%ebp)
801022dc:	e8 94 f8 ff ff       	call   80101b75 <iput>
801022e1:	83 c4 10             	add    $0x10,%esp
    return -1;
801022e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022e9:	e9 9c 00 00 00       	jmp    8010238a <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022f5:	eb 39                	jmp    80102330 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fa:	6a 10                	push   $0x10
801022fc:	50                   	push   %eax
801022fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102300:	50                   	push   %eax
80102301:	ff 75 08             	pushl  0x8(%ebp)
80102304:	e8 f7 fb ff ff       	call   80101f00 <readi>
80102309:	83 c4 10             	add    $0x10,%esp
8010230c:	83 f8 10             	cmp    $0x10,%eax
8010230f:	74 0d                	je     8010231e <dirlink+0x6a>
      panic("dirlink read");
80102311:	83 ec 0c             	sub    $0xc,%esp
80102314:	68 aa 84 10 80       	push   $0x801084aa
80102319:	e8 7e e2 ff ff       	call   8010059c <panic>
    if(de.inum == 0)
8010231e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102322:	66 85 c0             	test   %ax,%ax
80102325:	74 18                	je     8010233f <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232a:	83 c0 10             	add    $0x10,%eax
8010232d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102330:	8b 45 08             	mov    0x8(%ebp),%eax
80102333:	8b 50 58             	mov    0x58(%eax),%edx
80102336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102339:	39 c2                	cmp    %eax,%edx
8010233b:	77 ba                	ja     801022f7 <dirlink+0x43>
8010233d:	eb 01                	jmp    80102340 <dirlink+0x8c>
      break;
8010233f:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102340:	83 ec 04             	sub    $0x4,%esp
80102343:	6a 0e                	push   $0xe
80102345:	ff 75 0c             	pushl  0xc(%ebp)
80102348:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010234b:	83 c0 02             	add    $0x2,%eax
8010234e:	50                   	push   %eax
8010234f:	e8 2a 30 00 00       	call   8010537e <strncpy>
80102354:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102357:	8b 45 10             	mov    0x10(%ebp),%eax
8010235a:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102361:	6a 10                	push   $0x10
80102363:	50                   	push   %eax
80102364:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102367:	50                   	push   %eax
80102368:	ff 75 08             	pushl  0x8(%ebp)
8010236b:	e8 e7 fc ff ff       	call   80102057 <writei>
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 f8 10             	cmp    $0x10,%eax
80102376:	74 0d                	je     80102385 <dirlink+0xd1>
    panic("dirlink");
80102378:	83 ec 0c             	sub    $0xc,%esp
8010237b:	68 b7 84 10 80       	push   $0x801084b7
80102380:	e8 17 e2 ff ff       	call   8010059c <panic>

  return 0;
80102385:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010238a:	c9                   	leave  
8010238b:	c3                   	ret    

8010238c <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010238c:	55                   	push   %ebp
8010238d:	89 e5                	mov    %esp,%ebp
8010238f:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102392:	eb 04                	jmp    80102398 <skipelem+0xc>
    path++;
80102394:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
8010239b:	0f b6 00             	movzbl (%eax),%eax
8010239e:	3c 2f                	cmp    $0x2f,%al
801023a0:	74 f2                	je     80102394 <skipelem+0x8>
  if(*path == 0)
801023a2:	8b 45 08             	mov    0x8(%ebp),%eax
801023a5:	0f b6 00             	movzbl (%eax),%eax
801023a8:	84 c0                	test   %al,%al
801023aa:	75 07                	jne    801023b3 <skipelem+0x27>
    return 0;
801023ac:	b8 00 00 00 00       	mov    $0x0,%eax
801023b1:	eb 7b                	jmp    8010242e <skipelem+0xa2>
  s = path;
801023b3:	8b 45 08             	mov    0x8(%ebp),%eax
801023b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023b9:	eb 04                	jmp    801023bf <skipelem+0x33>
    path++;
801023bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801023bf:	8b 45 08             	mov    0x8(%ebp),%eax
801023c2:	0f b6 00             	movzbl (%eax),%eax
801023c5:	3c 2f                	cmp    $0x2f,%al
801023c7:	74 0a                	je     801023d3 <skipelem+0x47>
801023c9:	8b 45 08             	mov    0x8(%ebp),%eax
801023cc:	0f b6 00             	movzbl (%eax),%eax
801023cf:	84 c0                	test   %al,%al
801023d1:	75 e8                	jne    801023bb <skipelem+0x2f>
  len = path - s;
801023d3:	8b 55 08             	mov    0x8(%ebp),%edx
801023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d9:	29 c2                	sub    %eax,%edx
801023db:	89 d0                	mov    %edx,%eax
801023dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023e0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023e4:	7e 15                	jle    801023fb <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801023e6:	83 ec 04             	sub    $0x4,%esp
801023e9:	6a 0e                	push   $0xe
801023eb:	ff 75 f4             	pushl  -0xc(%ebp)
801023ee:	ff 75 0c             	pushl  0xc(%ebp)
801023f1:	e8 9c 2e 00 00       	call   80105292 <memmove>
801023f6:	83 c4 10             	add    $0x10,%esp
801023f9:	eb 26                	jmp    80102421 <skipelem+0x95>
  else {
    memmove(name, s, len);
801023fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023fe:	83 ec 04             	sub    $0x4,%esp
80102401:	50                   	push   %eax
80102402:	ff 75 f4             	pushl  -0xc(%ebp)
80102405:	ff 75 0c             	pushl  0xc(%ebp)
80102408:	e8 85 2e 00 00       	call   80105292 <memmove>
8010240d:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102410:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102413:	8b 45 0c             	mov    0xc(%ebp),%eax
80102416:	01 d0                	add    %edx,%eax
80102418:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010241b:	eb 04                	jmp    80102421 <skipelem+0x95>
    path++;
8010241d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102421:	8b 45 08             	mov    0x8(%ebp),%eax
80102424:	0f b6 00             	movzbl (%eax),%eax
80102427:	3c 2f                	cmp    $0x2f,%al
80102429:	74 f2                	je     8010241d <skipelem+0x91>
  return path;
8010242b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010242e:	c9                   	leave  
8010242f:	c3                   	ret    

80102430 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102436:	8b 45 08             	mov    0x8(%ebp),%eax
80102439:	0f b6 00             	movzbl (%eax),%eax
8010243c:	3c 2f                	cmp    $0x2f,%al
8010243e:	75 17                	jne    80102457 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102440:	83 ec 08             	sub    $0x8,%esp
80102443:	6a 01                	push   $0x1
80102445:	6a 01                	push   $0x1
80102447:	e8 ac f4 ff ff       	call   801018f8 <iget>
8010244c:	83 c4 10             	add    $0x10,%esp
8010244f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102452:	e9 ba 00 00 00       	jmp    80102511 <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
80102457:	e8 30 1e 00 00       	call   8010428c <myproc>
8010245c:	8b 40 68             	mov    0x68(%eax),%eax
8010245f:	83 ec 0c             	sub    $0xc,%esp
80102462:	50                   	push   %eax
80102463:	e8 72 f5 ff ff       	call   801019da <idup>
80102468:	83 c4 10             	add    $0x10,%esp
8010246b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010246e:	e9 9e 00 00 00       	jmp    80102511 <namex+0xe1>
    ilock(ip);
80102473:	83 ec 0c             	sub    $0xc,%esp
80102476:	ff 75 f4             	pushl  -0xc(%ebp)
80102479:	e8 96 f5 ff ff       	call   80101a14 <ilock>
8010247e:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102484:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102488:	66 83 f8 01          	cmp    $0x1,%ax
8010248c:	74 18                	je     801024a6 <namex+0x76>
      iunlockput(ip);
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	ff 75 f4             	pushl  -0xc(%ebp)
80102494:	e8 ac f7 ff ff       	call   80101c45 <iunlockput>
80102499:	83 c4 10             	add    $0x10,%esp
      return 0;
8010249c:	b8 00 00 00 00       	mov    $0x0,%eax
801024a1:	e9 a7 00 00 00       	jmp    8010254d <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
801024a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024aa:	74 20                	je     801024cc <namex+0x9c>
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	0f b6 00             	movzbl (%eax),%eax
801024b2:	84 c0                	test   %al,%al
801024b4:	75 16                	jne    801024cc <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	ff 75 f4             	pushl  -0xc(%ebp)
801024bc:	e8 66 f6 ff ff       	call   80101b27 <iunlock>
801024c1:	83 c4 10             	add    $0x10,%esp
      return ip;
801024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024c7:	e9 81 00 00 00       	jmp    8010254d <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024cc:	83 ec 04             	sub    $0x4,%esp
801024cf:	6a 00                	push   $0x0
801024d1:	ff 75 10             	pushl  0x10(%ebp)
801024d4:	ff 75 f4             	pushl  -0xc(%ebp)
801024d7:	e8 1e fd ff ff       	call   801021fa <dirlookup>
801024dc:	83 c4 10             	add    $0x10,%esp
801024df:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024e6:	75 15                	jne    801024fd <namex+0xcd>
      iunlockput(ip);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	ff 75 f4             	pushl  -0xc(%ebp)
801024ee:	e8 52 f7 ff ff       	call   80101c45 <iunlockput>
801024f3:	83 c4 10             	add    $0x10,%esp
      return 0;
801024f6:	b8 00 00 00 00       	mov    $0x0,%eax
801024fb:	eb 50                	jmp    8010254d <namex+0x11d>
    }
    iunlockput(ip);
801024fd:	83 ec 0c             	sub    $0xc,%esp
80102500:	ff 75 f4             	pushl  -0xc(%ebp)
80102503:	e8 3d f7 ff ff       	call   80101c45 <iunlockput>
80102508:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102511:	83 ec 08             	sub    $0x8,%esp
80102514:	ff 75 10             	pushl  0x10(%ebp)
80102517:	ff 75 08             	pushl  0x8(%ebp)
8010251a:	e8 6d fe ff ff       	call   8010238c <skipelem>
8010251f:	83 c4 10             	add    $0x10,%esp
80102522:	89 45 08             	mov    %eax,0x8(%ebp)
80102525:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102529:	0f 85 44 ff ff ff    	jne    80102473 <namex+0x43>
  }
  if(nameiparent){
8010252f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102533:	74 15                	je     8010254a <namex+0x11a>
    iput(ip);
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	ff 75 f4             	pushl  -0xc(%ebp)
8010253b:	e8 35 f6 ff ff       	call   80101b75 <iput>
80102540:	83 c4 10             	add    $0x10,%esp
    return 0;
80102543:	b8 00 00 00 00       	mov    $0x0,%eax
80102548:	eb 03                	jmp    8010254d <namex+0x11d>
  }
  return ip;
8010254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010254d:	c9                   	leave  
8010254e:	c3                   	ret    

8010254f <namei>:

struct inode*
namei(char *path)
{
8010254f:	55                   	push   %ebp
80102550:	89 e5                	mov    %esp,%ebp
80102552:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102555:	83 ec 04             	sub    $0x4,%esp
80102558:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010255b:	50                   	push   %eax
8010255c:	6a 00                	push   $0x0
8010255e:	ff 75 08             	pushl  0x8(%ebp)
80102561:	e8 ca fe ff ff       	call   80102430 <namex>
80102566:	83 c4 10             	add    $0x10,%esp
}
80102569:	c9                   	leave  
8010256a:	c3                   	ret    

8010256b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010256b:	55                   	push   %ebp
8010256c:	89 e5                	mov    %esp,%ebp
8010256e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102571:	83 ec 04             	sub    $0x4,%esp
80102574:	ff 75 0c             	pushl  0xc(%ebp)
80102577:	6a 01                	push   $0x1
80102579:	ff 75 08             	pushl  0x8(%ebp)
8010257c:	e8 af fe ff ff       	call   80102430 <namex>
80102581:	83 c4 10             	add    $0x10,%esp
}
80102584:	c9                   	leave  
80102585:	c3                   	ret    

80102586 <inb>:
{
80102586:	55                   	push   %ebp
80102587:	89 e5                	mov    %esp,%ebp
80102589:	83 ec 14             	sub    $0x14,%esp
8010258c:	8b 45 08             	mov    0x8(%ebp),%eax
8010258f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102593:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102597:	89 c2                	mov    %eax,%edx
80102599:	ec                   	in     (%dx),%al
8010259a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010259d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025a1:	c9                   	leave  
801025a2:	c3                   	ret    

801025a3 <insl>:
{
801025a3:	55                   	push   %ebp
801025a4:	89 e5                	mov    %esp,%ebp
801025a6:	57                   	push   %edi
801025a7:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025a8:	8b 55 08             	mov    0x8(%ebp),%edx
801025ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025ae:	8b 45 10             	mov    0x10(%ebp),%eax
801025b1:	89 cb                	mov    %ecx,%ebx
801025b3:	89 df                	mov    %ebx,%edi
801025b5:	89 c1                	mov    %eax,%ecx
801025b7:	fc                   	cld    
801025b8:	f3 6d                	rep insl (%dx),%es:(%edi)
801025ba:	89 c8                	mov    %ecx,%eax
801025bc:	89 fb                	mov    %edi,%ebx
801025be:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025c1:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025c4:	90                   	nop
801025c5:	5b                   	pop    %ebx
801025c6:	5f                   	pop    %edi
801025c7:	5d                   	pop    %ebp
801025c8:	c3                   	ret    

801025c9 <outb>:
{
801025c9:	55                   	push   %ebp
801025ca:	89 e5                	mov    %esp,%ebp
801025cc:	83 ec 08             	sub    $0x8,%esp
801025cf:	8b 55 08             	mov    0x8(%ebp),%edx
801025d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801025d5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025d9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025dc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025e0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025e4:	ee                   	out    %al,(%dx)
}
801025e5:	90                   	nop
801025e6:	c9                   	leave  
801025e7:	c3                   	ret    

801025e8 <outsl>:
{
801025e8:	55                   	push   %ebp
801025e9:	89 e5                	mov    %esp,%ebp
801025eb:	56                   	push   %esi
801025ec:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025ed:	8b 55 08             	mov    0x8(%ebp),%edx
801025f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025f3:	8b 45 10             	mov    0x10(%ebp),%eax
801025f6:	89 cb                	mov    %ecx,%ebx
801025f8:	89 de                	mov    %ebx,%esi
801025fa:	89 c1                	mov    %eax,%ecx
801025fc:	fc                   	cld    
801025fd:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025ff:	89 c8                	mov    %ecx,%eax
80102601:	89 f3                	mov    %esi,%ebx
80102603:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102606:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102609:	90                   	nop
8010260a:	5b                   	pop    %ebx
8010260b:	5e                   	pop    %esi
8010260c:	5d                   	pop    %ebp
8010260d:	c3                   	ret    

8010260e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010260e:	55                   	push   %ebp
8010260f:	89 e5                	mov    %esp,%ebp
80102611:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102614:	90                   	nop
80102615:	68 f7 01 00 00       	push   $0x1f7
8010261a:	e8 67 ff ff ff       	call   80102586 <inb>
8010261f:	83 c4 04             	add    $0x4,%esp
80102622:	0f b6 c0             	movzbl %al,%eax
80102625:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102628:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010262b:	25 c0 00 00 00       	and    $0xc0,%eax
80102630:	83 f8 40             	cmp    $0x40,%eax
80102633:	75 e0                	jne    80102615 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102635:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102639:	74 11                	je     8010264c <idewait+0x3e>
8010263b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010263e:	83 e0 21             	and    $0x21,%eax
80102641:	85 c0                	test   %eax,%eax
80102643:	74 07                	je     8010264c <idewait+0x3e>
    return -1;
80102645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264a:	eb 05                	jmp    80102651 <idewait+0x43>
  return 0;
8010264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102651:	c9                   	leave  
80102652:	c3                   	ret    

80102653 <ideinit>:

void
ideinit(void)
{
80102653:	55                   	push   %ebp
80102654:	89 e5                	mov    %esp,%ebp
80102656:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102659:	83 ec 08             	sub    $0x8,%esp
8010265c:	68 bf 84 10 80       	push   $0x801084bf
80102661:	68 e0 b5 10 80       	push   $0x8010b5e0
80102666:	e8 cf 28 00 00       	call   80104f3a <initlock>
8010266b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010266e:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80102673:	83 e8 01             	sub    $0x1,%eax
80102676:	83 ec 08             	sub    $0x8,%esp
80102679:	50                   	push   %eax
8010267a:	6a 0e                	push   $0xe
8010267c:	e8 a2 04 00 00       	call   80102b23 <ioapicenable>
80102681:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102684:	83 ec 0c             	sub    $0xc,%esp
80102687:	6a 00                	push   $0x0
80102689:	e8 80 ff ff ff       	call   8010260e <idewait>
8010268e:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102691:	83 ec 08             	sub    $0x8,%esp
80102694:	68 f0 00 00 00       	push   $0xf0
80102699:	68 f6 01 00 00       	push   $0x1f6
8010269e:	e8 26 ff ff ff       	call   801025c9 <outb>
801026a3:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026ad:	eb 24                	jmp    801026d3 <ideinit+0x80>
    if(inb(0x1f7) != 0){
801026af:	83 ec 0c             	sub    $0xc,%esp
801026b2:	68 f7 01 00 00       	push   $0x1f7
801026b7:	e8 ca fe ff ff       	call   80102586 <inb>
801026bc:	83 c4 10             	add    $0x10,%esp
801026bf:	84 c0                	test   %al,%al
801026c1:	74 0c                	je     801026cf <ideinit+0x7c>
      havedisk1 = 1;
801026c3:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
801026ca:	00 00 00 
      break;
801026cd:	eb 0d                	jmp    801026dc <ideinit+0x89>
  for(i=0; i<1000; i++){
801026cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026d3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026da:	7e d3                	jle    801026af <ideinit+0x5c>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026dc:	83 ec 08             	sub    $0x8,%esp
801026df:	68 e0 00 00 00       	push   $0xe0
801026e4:	68 f6 01 00 00       	push   $0x1f6
801026e9:	e8 db fe ff ff       	call   801025c9 <outb>
801026ee:	83 c4 10             	add    $0x10,%esp
}
801026f1:	90                   	nop
801026f2:	c9                   	leave  
801026f3:	c3                   	ret    

801026f4 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026f4:	55                   	push   %ebp
801026f5:	89 e5                	mov    %esp,%ebp
801026f7:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026fe:	75 0d                	jne    8010270d <idestart+0x19>
    panic("idestart");
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 c3 84 10 80       	push   $0x801084c3
80102708:	e8 8f de ff ff       	call   8010059c <panic>
  if(b->blockno >= FSSIZE)
8010270d:	8b 45 08             	mov    0x8(%ebp),%eax
80102710:	8b 40 08             	mov    0x8(%eax),%eax
80102713:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102718:	76 0d                	jbe    80102727 <idestart+0x33>
    panic("incorrect blockno");
8010271a:	83 ec 0c             	sub    $0xc,%esp
8010271d:	68 cc 84 10 80       	push   $0x801084cc
80102722:	e8 75 de ff ff       	call   8010059c <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102727:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010272e:	8b 45 08             	mov    0x8(%ebp),%eax
80102731:	8b 50 08             	mov    0x8(%eax),%edx
80102734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102737:	0f af c2             	imul   %edx,%eax
8010273a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010273d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102741:	75 07                	jne    8010274a <idestart+0x56>
80102743:	b8 20 00 00 00       	mov    $0x20,%eax
80102748:	eb 05                	jmp    8010274f <idestart+0x5b>
8010274a:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010274f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102752:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102756:	75 07                	jne    8010275f <idestart+0x6b>
80102758:	b8 30 00 00 00       	mov    $0x30,%eax
8010275d:	eb 05                	jmp    80102764 <idestart+0x70>
8010275f:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102764:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102767:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010276b:	7e 0d                	jle    8010277a <idestart+0x86>
8010276d:	83 ec 0c             	sub    $0xc,%esp
80102770:	68 c3 84 10 80       	push   $0x801084c3
80102775:	e8 22 de ff ff       	call   8010059c <panic>

  idewait(0);
8010277a:	83 ec 0c             	sub    $0xc,%esp
8010277d:	6a 00                	push   $0x0
8010277f:	e8 8a fe ff ff       	call   8010260e <idewait>
80102784:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102787:	83 ec 08             	sub    $0x8,%esp
8010278a:	6a 00                	push   $0x0
8010278c:	68 f6 03 00 00       	push   $0x3f6
80102791:	e8 33 fe ff ff       	call   801025c9 <outb>
80102796:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279c:	0f b6 c0             	movzbl %al,%eax
8010279f:	83 ec 08             	sub    $0x8,%esp
801027a2:	50                   	push   %eax
801027a3:	68 f2 01 00 00       	push   $0x1f2
801027a8:	e8 1c fe ff ff       	call   801025c9 <outb>
801027ad:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b3:	0f b6 c0             	movzbl %al,%eax
801027b6:	83 ec 08             	sub    $0x8,%esp
801027b9:	50                   	push   %eax
801027ba:	68 f3 01 00 00       	push   $0x1f3
801027bf:	e8 05 fe ff ff       	call   801025c9 <outb>
801027c4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027ca:	c1 f8 08             	sar    $0x8,%eax
801027cd:	0f b6 c0             	movzbl %al,%eax
801027d0:	83 ec 08             	sub    $0x8,%esp
801027d3:	50                   	push   %eax
801027d4:	68 f4 01 00 00       	push   $0x1f4
801027d9:	e8 eb fd ff ff       	call   801025c9 <outb>
801027de:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027e4:	c1 f8 10             	sar    $0x10,%eax
801027e7:	0f b6 c0             	movzbl %al,%eax
801027ea:	83 ec 08             	sub    $0x8,%esp
801027ed:	50                   	push   %eax
801027ee:	68 f5 01 00 00       	push   $0x1f5
801027f3:	e8 d1 fd ff ff       	call   801025c9 <outb>
801027f8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	8b 40 04             	mov    0x4(%eax),%eax
80102801:	c1 e0 04             	shl    $0x4,%eax
80102804:	83 e0 10             	and    $0x10,%eax
80102807:	89 c2                	mov    %eax,%edx
80102809:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010280c:	c1 f8 18             	sar    $0x18,%eax
8010280f:	83 e0 0f             	and    $0xf,%eax
80102812:	09 d0                	or     %edx,%eax
80102814:	83 c8 e0             	or     $0xffffffe0,%eax
80102817:	0f b6 c0             	movzbl %al,%eax
8010281a:	83 ec 08             	sub    $0x8,%esp
8010281d:	50                   	push   %eax
8010281e:	68 f6 01 00 00       	push   $0x1f6
80102823:	e8 a1 fd ff ff       	call   801025c9 <outb>
80102828:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010282b:	8b 45 08             	mov    0x8(%ebp),%eax
8010282e:	8b 00                	mov    (%eax),%eax
80102830:	83 e0 04             	and    $0x4,%eax
80102833:	85 c0                	test   %eax,%eax
80102835:	74 35                	je     8010286c <idestart+0x178>
    outb(0x1f7, write_cmd);
80102837:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010283a:	0f b6 c0             	movzbl %al,%eax
8010283d:	83 ec 08             	sub    $0x8,%esp
80102840:	50                   	push   %eax
80102841:	68 f7 01 00 00       	push   $0x1f7
80102846:	e8 7e fd ff ff       	call   801025c9 <outb>
8010284b:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	83 c0 5c             	add    $0x5c,%eax
80102854:	83 ec 04             	sub    $0x4,%esp
80102857:	68 80 00 00 00       	push   $0x80
8010285c:	50                   	push   %eax
8010285d:	68 f0 01 00 00       	push   $0x1f0
80102862:	e8 81 fd ff ff       	call   801025e8 <outsl>
80102867:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010286a:	eb 17                	jmp    80102883 <idestart+0x18f>
    outb(0x1f7, read_cmd);
8010286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010286f:	0f b6 c0             	movzbl %al,%eax
80102872:	83 ec 08             	sub    $0x8,%esp
80102875:	50                   	push   %eax
80102876:	68 f7 01 00 00       	push   $0x1f7
8010287b:	e8 49 fd ff ff       	call   801025c9 <outb>
80102880:	83 c4 10             	add    $0x10,%esp
}
80102883:	90                   	nop
80102884:	c9                   	leave  
80102885:	c3                   	ret    

80102886 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102886:	55                   	push   %ebp
80102887:	89 e5                	mov    %esp,%ebp
80102889:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010288c:	83 ec 0c             	sub    $0xc,%esp
8010288f:	68 e0 b5 10 80       	push   $0x8010b5e0
80102894:	e8 c3 26 00 00       	call   80104f5c <acquire>
80102899:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
8010289c:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028a8:	75 15                	jne    801028bf <ideintr+0x39>
    release(&idelock);
801028aa:	83 ec 0c             	sub    $0xc,%esp
801028ad:	68 e0 b5 10 80       	push   $0x8010b5e0
801028b2:	e8 13 27 00 00       	call   80104fca <release>
801028b7:	83 c4 10             	add    $0x10,%esp
    return;
801028ba:	e9 9a 00 00 00       	jmp    80102959 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c2:	8b 40 58             	mov    0x58(%eax),%eax
801028c5:	a3 14 b6 10 80       	mov    %eax,0x8010b614

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cd:	8b 00                	mov    (%eax),%eax
801028cf:	83 e0 04             	and    $0x4,%eax
801028d2:	85 c0                	test   %eax,%eax
801028d4:	75 2d                	jne    80102903 <ideintr+0x7d>
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	6a 01                	push   $0x1
801028db:	e8 2e fd ff ff       	call   8010260e <idewait>
801028e0:	83 c4 10             	add    $0x10,%esp
801028e3:	85 c0                	test   %eax,%eax
801028e5:	78 1c                	js     80102903 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ea:	83 c0 5c             	add    $0x5c,%eax
801028ed:	83 ec 04             	sub    $0x4,%esp
801028f0:	68 80 00 00 00       	push   $0x80
801028f5:	50                   	push   %eax
801028f6:	68 f0 01 00 00       	push   $0x1f0
801028fb:	e8 a3 fc ff ff       	call   801025a3 <insl>
80102900:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102906:	8b 00                	mov    (%eax),%eax
80102908:	83 c8 02             	or     $0x2,%eax
8010290b:	89 c2                	mov    %eax,%edx
8010290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102910:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102915:	8b 00                	mov    (%eax),%eax
80102917:	83 e0 fb             	and    $0xfffffffb,%eax
8010291a:	89 c2                	mov    %eax,%edx
8010291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291f:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102921:	83 ec 0c             	sub    $0xc,%esp
80102924:	ff 75 f4             	pushl  -0xc(%ebp)
80102927:	e8 fd 22 00 00       	call   80104c29 <wakeup>
8010292c:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010292f:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102934:	85 c0                	test   %eax,%eax
80102936:	74 11                	je     80102949 <ideintr+0xc3>
    idestart(idequeue);
80102938:	a1 14 b6 10 80       	mov    0x8010b614,%eax
8010293d:	83 ec 0c             	sub    $0xc,%esp
80102940:	50                   	push   %eax
80102941:	e8 ae fd ff ff       	call   801026f4 <idestart>
80102946:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102949:	83 ec 0c             	sub    $0xc,%esp
8010294c:	68 e0 b5 10 80       	push   $0x8010b5e0
80102951:	e8 74 26 00 00       	call   80104fca <release>
80102956:	83 c4 10             	add    $0x10,%esp
}
80102959:	c9                   	leave  
8010295a:	c3                   	ret    

8010295b <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010295b:	55                   	push   %ebp
8010295c:	89 e5                	mov    %esp,%ebp
8010295e:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102961:	8b 45 08             	mov    0x8(%ebp),%eax
80102964:	83 c0 0c             	add    $0xc,%eax
80102967:	83 ec 0c             	sub    $0xc,%esp
8010296a:	50                   	push   %eax
8010296b:	e8 5b 25 00 00       	call   80104ecb <holdingsleep>
80102970:	83 c4 10             	add    $0x10,%esp
80102973:	85 c0                	test   %eax,%eax
80102975:	75 0d                	jne    80102984 <iderw+0x29>
    panic("iderw: buf not locked");
80102977:	83 ec 0c             	sub    $0xc,%esp
8010297a:	68 de 84 10 80       	push   $0x801084de
8010297f:	e8 18 dc ff ff       	call   8010059c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102984:	8b 45 08             	mov    0x8(%ebp),%eax
80102987:	8b 00                	mov    (%eax),%eax
80102989:	83 e0 06             	and    $0x6,%eax
8010298c:	83 f8 02             	cmp    $0x2,%eax
8010298f:	75 0d                	jne    8010299e <iderw+0x43>
    panic("iderw: nothing to do");
80102991:	83 ec 0c             	sub    $0xc,%esp
80102994:	68 f4 84 10 80       	push   $0x801084f4
80102999:	e8 fe db ff ff       	call   8010059c <panic>
  if(b->dev != 0 && !havedisk1)
8010299e:	8b 45 08             	mov    0x8(%ebp),%eax
801029a1:	8b 40 04             	mov    0x4(%eax),%eax
801029a4:	85 c0                	test   %eax,%eax
801029a6:	74 16                	je     801029be <iderw+0x63>
801029a8:	a1 18 b6 10 80       	mov    0x8010b618,%eax
801029ad:	85 c0                	test   %eax,%eax
801029af:	75 0d                	jne    801029be <iderw+0x63>
    panic("iderw: ide disk 1 not present");
801029b1:	83 ec 0c             	sub    $0xc,%esp
801029b4:	68 09 85 10 80       	push   $0x80108509
801029b9:	e8 de db ff ff       	call   8010059c <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029be:	83 ec 0c             	sub    $0xc,%esp
801029c1:	68 e0 b5 10 80       	push   $0x8010b5e0
801029c6:	e8 91 25 00 00       	call   80104f5c <acquire>
801029cb:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029ce:	8b 45 08             	mov    0x8(%ebp),%eax
801029d1:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029d8:	c7 45 f4 14 b6 10 80 	movl   $0x8010b614,-0xc(%ebp)
801029df:	eb 0b                	jmp    801029ec <iderw+0x91>
801029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e4:	8b 00                	mov    (%eax),%eax
801029e6:	83 c0 58             	add    $0x58,%eax
801029e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ef:	8b 00                	mov    (%eax),%eax
801029f1:	85 c0                	test   %eax,%eax
801029f3:	75 ec                	jne    801029e1 <iderw+0x86>
    ;
  *pp = b;
801029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f8:	8b 55 08             	mov    0x8(%ebp),%edx
801029fb:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801029fd:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102a02:	39 45 08             	cmp    %eax,0x8(%ebp)
80102a05:	75 23                	jne    80102a2a <iderw+0xcf>
    idestart(b);
80102a07:	83 ec 0c             	sub    $0xc,%esp
80102a0a:	ff 75 08             	pushl  0x8(%ebp)
80102a0d:	e8 e2 fc ff ff       	call   801026f4 <idestart>
80102a12:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a15:	eb 13                	jmp    80102a2a <iderw+0xcf>
    sleep(b, &idelock);
80102a17:	83 ec 08             	sub    $0x8,%esp
80102a1a:	68 e0 b5 10 80       	push   $0x8010b5e0
80102a1f:	ff 75 08             	pushl  0x8(%ebp)
80102a22:	e8 1c 21 00 00       	call   80104b43 <sleep>
80102a27:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2d:	8b 00                	mov    (%eax),%eax
80102a2f:	83 e0 06             	and    $0x6,%eax
80102a32:	83 f8 02             	cmp    $0x2,%eax
80102a35:	75 e0                	jne    80102a17 <iderw+0xbc>
  }


  release(&idelock);
80102a37:	83 ec 0c             	sub    $0xc,%esp
80102a3a:	68 e0 b5 10 80       	push   $0x8010b5e0
80102a3f:	e8 86 25 00 00       	call   80104fca <release>
80102a44:	83 c4 10             	add    $0x10,%esp
}
80102a47:	90                   	nop
80102a48:	c9                   	leave  
80102a49:	c3                   	ret    

80102a4a <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a4a:	55                   	push   %ebp
80102a4b:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a4d:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a52:	8b 55 08             	mov    0x8(%ebp),%edx
80102a55:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a57:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a5c:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a5f:	5d                   	pop    %ebp
80102a60:	c3                   	ret    

80102a61 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a61:	55                   	push   %ebp
80102a62:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a64:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a69:	8b 55 08             	mov    0x8(%ebp),%edx
80102a6c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a6e:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a73:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a76:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a79:	90                   	nop
80102a7a:	5d                   	pop    %ebp
80102a7b:	c3                   	ret    

80102a7c <ioapicinit>:

void
ioapicinit(void)
{
80102a7c:	55                   	push   %ebp
80102a7d:	89 e5                	mov    %esp,%ebp
80102a7f:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a82:	c7 05 b4 36 11 80 00 	movl   $0xfec00000,0x801136b4
80102a89:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a8c:	6a 01                	push   $0x1
80102a8e:	e8 b7 ff ff ff       	call   80102a4a <ioapicread>
80102a93:	83 c4 04             	add    $0x4,%esp
80102a96:	c1 e8 10             	shr    $0x10,%eax
80102a99:	25 ff 00 00 00       	and    $0xff,%eax
80102a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102aa1:	6a 00                	push   $0x0
80102aa3:	e8 a2 ff ff ff       	call   80102a4a <ioapicread>
80102aa8:	83 c4 04             	add    $0x4,%esp
80102aab:	c1 e8 18             	shr    $0x18,%eax
80102aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ab1:	0f b6 05 e0 37 11 80 	movzbl 0x801137e0,%eax
80102ab8:	0f b6 c0             	movzbl %al,%eax
80102abb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102abe:	74 10                	je     80102ad0 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ac0:	83 ec 0c             	sub    $0xc,%esp
80102ac3:	68 28 85 10 80       	push   $0x80108528
80102ac8:	e8 2f d9 ff ff       	call   801003fc <cprintf>
80102acd:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ad0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ad7:	eb 3f                	jmp    80102b18 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102adc:	83 c0 20             	add    $0x20,%eax
80102adf:	0d 00 00 01 00       	or     $0x10000,%eax
80102ae4:	89 c2                	mov    %eax,%edx
80102ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae9:	83 c0 08             	add    $0x8,%eax
80102aec:	01 c0                	add    %eax,%eax
80102aee:	83 ec 08             	sub    $0x8,%esp
80102af1:	52                   	push   %edx
80102af2:	50                   	push   %eax
80102af3:	e8 69 ff ff ff       	call   80102a61 <ioapicwrite>
80102af8:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afe:	83 c0 08             	add    $0x8,%eax
80102b01:	01 c0                	add    %eax,%eax
80102b03:	83 c0 01             	add    $0x1,%eax
80102b06:	83 ec 08             	sub    $0x8,%esp
80102b09:	6a 00                	push   $0x0
80102b0b:	50                   	push   %eax
80102b0c:	e8 50 ff ff ff       	call   80102a61 <ioapicwrite>
80102b11:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102b14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b1e:	7e b9                	jle    80102ad9 <ioapicinit+0x5d>
  }
}
80102b20:	90                   	nop
80102b21:	c9                   	leave  
80102b22:	c3                   	ret    

80102b23 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b23:	55                   	push   %ebp
80102b24:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b26:	8b 45 08             	mov    0x8(%ebp),%eax
80102b29:	83 c0 20             	add    $0x20,%eax
80102b2c:	89 c2                	mov    %eax,%edx
80102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b31:	83 c0 08             	add    $0x8,%eax
80102b34:	01 c0                	add    %eax,%eax
80102b36:	52                   	push   %edx
80102b37:	50                   	push   %eax
80102b38:	e8 24 ff ff ff       	call   80102a61 <ioapicwrite>
80102b3d:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b40:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b43:	c1 e0 18             	shl    $0x18,%eax
80102b46:	89 c2                	mov    %eax,%edx
80102b48:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4b:	83 c0 08             	add    $0x8,%eax
80102b4e:	01 c0                	add    %eax,%eax
80102b50:	83 c0 01             	add    $0x1,%eax
80102b53:	52                   	push   %edx
80102b54:	50                   	push   %eax
80102b55:	e8 07 ff ff ff       	call   80102a61 <ioapicwrite>
80102b5a:	83 c4 08             	add    $0x8,%esp
}
80102b5d:	90                   	nop
80102b5e:	c9                   	leave  
80102b5f:	c3                   	ret    

80102b60 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b66:	83 ec 08             	sub    $0x8,%esp
80102b69:	68 5a 85 10 80       	push   $0x8010855a
80102b6e:	68 c0 36 11 80       	push   $0x801136c0
80102b73:	e8 c2 23 00 00       	call   80104f3a <initlock>
80102b78:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b7b:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102b82:	00 00 00 
  freerange(vstart, vend);
80102b85:	83 ec 08             	sub    $0x8,%esp
80102b88:	ff 75 0c             	pushl  0xc(%ebp)
80102b8b:	ff 75 08             	pushl  0x8(%ebp)
80102b8e:	e8 2a 00 00 00       	call   80102bbd <freerange>
80102b93:	83 c4 10             	add    $0x10,%esp
}
80102b96:	90                   	nop
80102b97:	c9                   	leave  
80102b98:	c3                   	ret    

80102b99 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b99:	55                   	push   %ebp
80102b9a:	89 e5                	mov    %esp,%ebp
80102b9c:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b9f:	83 ec 08             	sub    $0x8,%esp
80102ba2:	ff 75 0c             	pushl  0xc(%ebp)
80102ba5:	ff 75 08             	pushl  0x8(%ebp)
80102ba8:	e8 10 00 00 00       	call   80102bbd <freerange>
80102bad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bb0:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
80102bb7:	00 00 00 
}
80102bba:	90                   	nop
80102bbb:	c9                   	leave  
80102bbc:	c3                   	ret    

80102bbd <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bbd:	55                   	push   %ebp
80102bbe:	89 e5                	mov    %esp,%ebp
80102bc0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc6:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd3:	eb 15                	jmp    80102bea <freerange+0x2d>
    kfree(p);
80102bd5:	83 ec 0c             	sub    $0xc,%esp
80102bd8:	ff 75 f4             	pushl  -0xc(%ebp)
80102bdb:	e8 1a 00 00 00       	call   80102bfa <kfree>
80102be0:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102be3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bed:	05 00 10 00 00       	add    $0x1000,%eax
80102bf2:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102bf5:	73 de                	jae    80102bd5 <freerange+0x18>
}
80102bf7:	90                   	nop
80102bf8:	c9                   	leave  
80102bf9:	c3                   	ret    

80102bfa <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bfa:	55                   	push   %ebp
80102bfb:	89 e5                	mov    %esp,%ebp
80102bfd:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c00:	8b 45 08             	mov    0x8(%ebp),%eax
80102c03:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c08:	85 c0                	test   %eax,%eax
80102c0a:	75 18                	jne    80102c24 <kfree+0x2a>
80102c0c:	81 7d 08 28 65 11 80 	cmpl   $0x80116528,0x8(%ebp)
80102c13:	72 0f                	jb     80102c24 <kfree+0x2a>
80102c15:	8b 45 08             	mov    0x8(%ebp),%eax
80102c18:	05 00 00 00 80       	add    $0x80000000,%eax
80102c1d:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c22:	76 0d                	jbe    80102c31 <kfree+0x37>
    panic("kfree");
80102c24:	83 ec 0c             	sub    $0xc,%esp
80102c27:	68 5f 85 10 80       	push   $0x8010855f
80102c2c:	e8 6b d9 ff ff       	call   8010059c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c31:	83 ec 04             	sub    $0x4,%esp
80102c34:	68 00 10 00 00       	push   $0x1000
80102c39:	6a 01                	push   $0x1
80102c3b:	ff 75 08             	pushl  0x8(%ebp)
80102c3e:	e8 90 25 00 00       	call   801051d3 <memset>
80102c43:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c46:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c4b:	85 c0                	test   %eax,%eax
80102c4d:	74 10                	je     80102c5f <kfree+0x65>
    acquire(&kmem.lock);
80102c4f:	83 ec 0c             	sub    $0xc,%esp
80102c52:	68 c0 36 11 80       	push   $0x801136c0
80102c57:	e8 00 23 00 00       	call   80104f5c <acquire>
80102c5c:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c65:	8b 15 f8 36 11 80    	mov    0x801136f8,%edx
80102c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c73:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102c78:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c7d:	85 c0                	test   %eax,%eax
80102c7f:	74 10                	je     80102c91 <kfree+0x97>
    release(&kmem.lock);
80102c81:	83 ec 0c             	sub    $0xc,%esp
80102c84:	68 c0 36 11 80       	push   $0x801136c0
80102c89:	e8 3c 23 00 00       	call   80104fca <release>
80102c8e:	83 c4 10             	add    $0x10,%esp
}
80102c91:	90                   	nop
80102c92:	c9                   	leave  
80102c93:	c3                   	ret    

80102c94 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c9a:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102c9f:	85 c0                	test   %eax,%eax
80102ca1:	74 10                	je     80102cb3 <kalloc+0x1f>
    acquire(&kmem.lock);
80102ca3:	83 ec 0c             	sub    $0xc,%esp
80102ca6:	68 c0 36 11 80       	push   $0x801136c0
80102cab:	e8 ac 22 00 00       	call   80104f5c <acquire>
80102cb0:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102cb3:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cbf:	74 0a                	je     80102ccb <kalloc+0x37>
    kmem.freelist = r->next;
80102cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc4:	8b 00                	mov    (%eax),%eax
80102cc6:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102ccb:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102cd0:	85 c0                	test   %eax,%eax
80102cd2:	74 10                	je     80102ce4 <kalloc+0x50>
    release(&kmem.lock);
80102cd4:	83 ec 0c             	sub    $0xc,%esp
80102cd7:	68 c0 36 11 80       	push   $0x801136c0
80102cdc:	e8 e9 22 00 00       	call   80104fca <release>
80102ce1:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ce7:	c9                   	leave  
80102ce8:	c3                   	ret    

80102ce9 <inb>:
{
80102ce9:	55                   	push   %ebp
80102cea:	89 e5                	mov    %esp,%ebp
80102cec:	83 ec 14             	sub    $0x14,%esp
80102cef:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cfa:	89 c2                	mov    %eax,%edx
80102cfc:	ec                   	in     (%dx),%al
80102cfd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d00:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d04:	c9                   	leave  
80102d05:	c3                   	ret    

80102d06 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d06:	55                   	push   %ebp
80102d07:	89 e5                	mov    %esp,%ebp
80102d09:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d0c:	6a 64                	push   $0x64
80102d0e:	e8 d6 ff ff ff       	call   80102ce9 <inb>
80102d13:	83 c4 04             	add    $0x4,%esp
80102d16:	0f b6 c0             	movzbl %al,%eax
80102d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d1f:	83 e0 01             	and    $0x1,%eax
80102d22:	85 c0                	test   %eax,%eax
80102d24:	75 0a                	jne    80102d30 <kbdgetc+0x2a>
    return -1;
80102d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d2b:	e9 23 01 00 00       	jmp    80102e53 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d30:	6a 60                	push   $0x60
80102d32:	e8 b2 ff ff ff       	call   80102ce9 <inb>
80102d37:	83 c4 04             	add    $0x4,%esp
80102d3a:	0f b6 c0             	movzbl %al,%eax
80102d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d40:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d47:	75 17                	jne    80102d60 <kbdgetc+0x5a>
    shift |= E0ESC;
80102d49:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d4e:	83 c8 40             	or     $0x40,%eax
80102d51:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102d56:	b8 00 00 00 00       	mov    $0x0,%eax
80102d5b:	e9 f3 00 00 00       	jmp    80102e53 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d63:	25 80 00 00 00       	and    $0x80,%eax
80102d68:	85 c0                	test   %eax,%eax
80102d6a:	74 45                	je     80102db1 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d6c:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d71:	83 e0 40             	and    $0x40,%eax
80102d74:	85 c0                	test   %eax,%eax
80102d76:	75 08                	jne    80102d80 <kbdgetc+0x7a>
80102d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7b:	83 e0 7f             	and    $0x7f,%eax
80102d7e:	eb 03                	jmp    80102d83 <kbdgetc+0x7d>
80102d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d89:	05 20 90 10 80       	add    $0x80109020,%eax
80102d8e:	0f b6 00             	movzbl (%eax),%eax
80102d91:	83 c8 40             	or     $0x40,%eax
80102d94:	0f b6 c0             	movzbl %al,%eax
80102d97:	f7 d0                	not    %eax
80102d99:	89 c2                	mov    %eax,%edx
80102d9b:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102da0:	21 d0                	and    %edx,%eax
80102da2:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102da7:	b8 00 00 00 00       	mov    $0x0,%eax
80102dac:	e9 a2 00 00 00       	jmp    80102e53 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102db1:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102db6:	83 e0 40             	and    $0x40,%eax
80102db9:	85 c0                	test   %eax,%eax
80102dbb:	74 14                	je     80102dd1 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dbd:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102dc4:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102dc9:	83 e0 bf             	and    $0xffffffbf,%eax
80102dcc:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  }

  shift |= shiftcode[data];
80102dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd4:	05 20 90 10 80       	add    $0x80109020,%eax
80102dd9:	0f b6 00             	movzbl (%eax),%eax
80102ddc:	0f b6 d0             	movzbl %al,%edx
80102ddf:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102de4:	09 d0                	or     %edx,%eax
80102de6:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  shift ^= togglecode[data];
80102deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dee:	05 20 91 10 80       	add    $0x80109120,%eax
80102df3:	0f b6 00             	movzbl (%eax),%eax
80102df6:	0f b6 d0             	movzbl %al,%edx
80102df9:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102dfe:	31 d0                	xor    %edx,%eax
80102e00:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e05:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102e0a:	83 e0 03             	and    $0x3,%eax
80102e0d:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e17:	01 d0                	add    %edx,%eax
80102e19:	0f b6 00             	movzbl (%eax),%eax
80102e1c:	0f b6 c0             	movzbl %al,%eax
80102e1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e22:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102e27:	83 e0 08             	and    $0x8,%eax
80102e2a:	85 c0                	test   %eax,%eax
80102e2c:	74 22                	je     80102e50 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e2e:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e32:	76 0c                	jbe    80102e40 <kbdgetc+0x13a>
80102e34:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e38:	77 06                	ja     80102e40 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e3a:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e3e:	eb 10                	jmp    80102e50 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e40:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e44:	76 0a                	jbe    80102e50 <kbdgetc+0x14a>
80102e46:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e4a:	77 04                	ja     80102e50 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e4c:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e53:	c9                   	leave  
80102e54:	c3                   	ret    

80102e55 <kbdintr>:

void
kbdintr(void)
{
80102e55:	55                   	push   %ebp
80102e56:	89 e5                	mov    %esp,%ebp
80102e58:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e5b:	83 ec 0c             	sub    $0xc,%esp
80102e5e:	68 06 2d 10 80       	push   $0x80102d06
80102e63:	e8 c8 d9 ff ff       	call   80100830 <consoleintr>
80102e68:	83 c4 10             	add    $0x10,%esp
}
80102e6b:	90                   	nop
80102e6c:	c9                   	leave  
80102e6d:	c3                   	ret    

80102e6e <inb>:
{
80102e6e:	55                   	push   %ebp
80102e6f:	89 e5                	mov    %esp,%ebp
80102e71:	83 ec 14             	sub    $0x14,%esp
80102e74:	8b 45 08             	mov    0x8(%ebp),%eax
80102e77:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e7b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e7f:	89 c2                	mov    %eax,%edx
80102e81:	ec                   	in     (%dx),%al
80102e82:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e85:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e89:	c9                   	leave  
80102e8a:	c3                   	ret    

80102e8b <outb>:
{
80102e8b:	55                   	push   %ebp
80102e8c:	89 e5                	mov    %esp,%ebp
80102e8e:	83 ec 08             	sub    $0x8,%esp
80102e91:	8b 55 08             	mov    0x8(%ebp),%edx
80102e94:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e97:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e9b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e9e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ea2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ea6:	ee                   	out    %al,(%dx)
}
80102ea7:	90                   	nop
80102ea8:	c9                   	leave  
80102ea9:	c3                   	ret    

80102eaa <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102ead:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102eb2:	8b 55 08             	mov    0x8(%ebp),%edx
80102eb5:	c1 e2 02             	shl    $0x2,%edx
80102eb8:	01 c2                	add    %eax,%edx
80102eba:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ebd:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ebf:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102ec4:	83 c0 20             	add    $0x20,%eax
80102ec7:	8b 00                	mov    (%eax),%eax
}
80102ec9:	90                   	nop
80102eca:	5d                   	pop    %ebp
80102ecb:	c3                   	ret    

80102ecc <lapicinit>:

void
lapicinit(void)
{
80102ecc:	55                   	push   %ebp
80102ecd:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ecf:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102ed4:	85 c0                	test   %eax,%eax
80102ed6:	0f 84 0b 01 00 00    	je     80102fe7 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102edc:	68 3f 01 00 00       	push   $0x13f
80102ee1:	6a 3c                	push   $0x3c
80102ee3:	e8 c2 ff ff ff       	call   80102eaa <lapicw>
80102ee8:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102eeb:	6a 0b                	push   $0xb
80102eed:	68 f8 00 00 00       	push   $0xf8
80102ef2:	e8 b3 ff ff ff       	call   80102eaa <lapicw>
80102ef7:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102efa:	68 20 00 02 00       	push   $0x20020
80102eff:	68 c8 00 00 00       	push   $0xc8
80102f04:	e8 a1 ff ff ff       	call   80102eaa <lapicw>
80102f09:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102f0c:	68 80 96 98 00       	push   $0x989680
80102f11:	68 e0 00 00 00       	push   $0xe0
80102f16:	e8 8f ff ff ff       	call   80102eaa <lapicw>
80102f1b:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f1e:	68 00 00 01 00       	push   $0x10000
80102f23:	68 d4 00 00 00       	push   $0xd4
80102f28:	e8 7d ff ff ff       	call   80102eaa <lapicw>
80102f2d:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f30:	68 00 00 01 00       	push   $0x10000
80102f35:	68 d8 00 00 00       	push   $0xd8
80102f3a:	e8 6b ff ff ff       	call   80102eaa <lapicw>
80102f3f:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f42:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f47:	83 c0 30             	add    $0x30,%eax
80102f4a:	8b 00                	mov    (%eax),%eax
80102f4c:	c1 e8 10             	shr    $0x10,%eax
80102f4f:	0f b6 c0             	movzbl %al,%eax
80102f52:	83 f8 03             	cmp    $0x3,%eax
80102f55:	76 12                	jbe    80102f69 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f57:	68 00 00 01 00       	push   $0x10000
80102f5c:	68 d0 00 00 00       	push   $0xd0
80102f61:	e8 44 ff ff ff       	call   80102eaa <lapicw>
80102f66:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f69:	6a 33                	push   $0x33
80102f6b:	68 dc 00 00 00       	push   $0xdc
80102f70:	e8 35 ff ff ff       	call   80102eaa <lapicw>
80102f75:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f78:	6a 00                	push   $0x0
80102f7a:	68 a0 00 00 00       	push   $0xa0
80102f7f:	e8 26 ff ff ff       	call   80102eaa <lapicw>
80102f84:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f87:	6a 00                	push   $0x0
80102f89:	68 a0 00 00 00       	push   $0xa0
80102f8e:	e8 17 ff ff ff       	call   80102eaa <lapicw>
80102f93:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f96:	6a 00                	push   $0x0
80102f98:	6a 2c                	push   $0x2c
80102f9a:	e8 0b ff ff ff       	call   80102eaa <lapicw>
80102f9f:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fa2:	6a 00                	push   $0x0
80102fa4:	68 c4 00 00 00       	push   $0xc4
80102fa9:	e8 fc fe ff ff       	call   80102eaa <lapicw>
80102fae:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fb1:	68 00 85 08 00       	push   $0x88500
80102fb6:	68 c0 00 00 00       	push   $0xc0
80102fbb:	e8 ea fe ff ff       	call   80102eaa <lapicw>
80102fc0:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fc3:	90                   	nop
80102fc4:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102fc9:	05 00 03 00 00       	add    $0x300,%eax
80102fce:	8b 00                	mov    (%eax),%eax
80102fd0:	25 00 10 00 00       	and    $0x1000,%eax
80102fd5:	85 c0                	test   %eax,%eax
80102fd7:	75 eb                	jne    80102fc4 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fd9:	6a 00                	push   $0x0
80102fdb:	6a 20                	push   $0x20
80102fdd:	e8 c8 fe ff ff       	call   80102eaa <lapicw>
80102fe2:	83 c4 08             	add    $0x8,%esp
80102fe5:	eb 01                	jmp    80102fe8 <lapicinit+0x11c>
    return;
80102fe7:	90                   	nop
}
80102fe8:	c9                   	leave  
80102fe9:	c3                   	ret    

80102fea <lapicid>:

int
lapicid(void)
{
80102fea:	55                   	push   %ebp
80102feb:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fed:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102ff2:	85 c0                	test   %eax,%eax
80102ff4:	75 07                	jne    80102ffd <lapicid+0x13>
    return 0;
80102ff6:	b8 00 00 00 00       	mov    $0x0,%eax
80102ffb:	eb 0d                	jmp    8010300a <lapicid+0x20>
  return lapic[ID] >> 24;
80102ffd:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103002:	83 c0 20             	add    $0x20,%eax
80103005:	8b 00                	mov    (%eax),%eax
80103007:	c1 e8 18             	shr    $0x18,%eax
}
8010300a:	5d                   	pop    %ebp
8010300b:	c3                   	ret    

8010300c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010300c:	55                   	push   %ebp
8010300d:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010300f:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80103014:	85 c0                	test   %eax,%eax
80103016:	74 0c                	je     80103024 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103018:	6a 00                	push   $0x0
8010301a:	6a 2c                	push   $0x2c
8010301c:	e8 89 fe ff ff       	call   80102eaa <lapicw>
80103021:	83 c4 08             	add    $0x8,%esp
}
80103024:	90                   	nop
80103025:	c9                   	leave  
80103026:	c3                   	ret    

80103027 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103027:	55                   	push   %ebp
80103028:	89 e5                	mov    %esp,%ebp
}
8010302a:	90                   	nop
8010302b:	5d                   	pop    %ebp
8010302c:	c3                   	ret    

8010302d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010302d:	55                   	push   %ebp
8010302e:	89 e5                	mov    %esp,%ebp
80103030:	83 ec 14             	sub    $0x14,%esp
80103033:	8b 45 08             	mov    0x8(%ebp),%eax
80103036:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103039:	6a 0f                	push   $0xf
8010303b:	6a 70                	push   $0x70
8010303d:	e8 49 fe ff ff       	call   80102e8b <outb>
80103042:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103045:	6a 0a                	push   $0xa
80103047:	6a 71                	push   $0x71
80103049:	e8 3d fe ff ff       	call   80102e8b <outb>
8010304e:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103051:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103058:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010305b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103060:	8b 45 0c             	mov    0xc(%ebp),%eax
80103063:	c1 e8 04             	shr    $0x4,%eax
80103066:	89 c2                	mov    %eax,%edx
80103068:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010306b:	83 c0 02             	add    $0x2,%eax
8010306e:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103071:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103075:	c1 e0 18             	shl    $0x18,%eax
80103078:	50                   	push   %eax
80103079:	68 c4 00 00 00       	push   $0xc4
8010307e:	e8 27 fe ff ff       	call   80102eaa <lapicw>
80103083:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103086:	68 00 c5 00 00       	push   $0xc500
8010308b:	68 c0 00 00 00       	push   $0xc0
80103090:	e8 15 fe ff ff       	call   80102eaa <lapicw>
80103095:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103098:	68 c8 00 00 00       	push   $0xc8
8010309d:	e8 85 ff ff ff       	call   80103027 <microdelay>
801030a2:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801030a5:	68 00 85 00 00       	push   $0x8500
801030aa:	68 c0 00 00 00       	push   $0xc0
801030af:	e8 f6 fd ff ff       	call   80102eaa <lapicw>
801030b4:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030b7:	6a 64                	push   $0x64
801030b9:	e8 69 ff ff ff       	call   80103027 <microdelay>
801030be:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030c8:	eb 3d                	jmp    80103107 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
801030ca:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030ce:	c1 e0 18             	shl    $0x18,%eax
801030d1:	50                   	push   %eax
801030d2:	68 c4 00 00 00       	push   $0xc4
801030d7:	e8 ce fd ff ff       	call   80102eaa <lapicw>
801030dc:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030df:	8b 45 0c             	mov    0xc(%ebp),%eax
801030e2:	c1 e8 0c             	shr    $0xc,%eax
801030e5:	80 cc 06             	or     $0x6,%ah
801030e8:	50                   	push   %eax
801030e9:	68 c0 00 00 00       	push   $0xc0
801030ee:	e8 b7 fd ff ff       	call   80102eaa <lapicw>
801030f3:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030f6:	68 c8 00 00 00       	push   $0xc8
801030fb:	e8 27 ff ff ff       	call   80103027 <microdelay>
80103100:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103103:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103107:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010310b:	7e bd                	jle    801030ca <lapicstartap+0x9d>
  }
}
8010310d:	90                   	nop
8010310e:	c9                   	leave  
8010310f:	c3                   	ret    

80103110 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103113:	8b 45 08             	mov    0x8(%ebp),%eax
80103116:	0f b6 c0             	movzbl %al,%eax
80103119:	50                   	push   %eax
8010311a:	6a 70                	push   $0x70
8010311c:	e8 6a fd ff ff       	call   80102e8b <outb>
80103121:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103124:	68 c8 00 00 00       	push   $0xc8
80103129:	e8 f9 fe ff ff       	call   80103027 <microdelay>
8010312e:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103131:	6a 71                	push   $0x71
80103133:	e8 36 fd ff ff       	call   80102e6e <inb>
80103138:	83 c4 04             	add    $0x4,%esp
8010313b:	0f b6 c0             	movzbl %al,%eax
}
8010313e:	c9                   	leave  
8010313f:	c3                   	ret    

80103140 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103143:	6a 00                	push   $0x0
80103145:	e8 c6 ff ff ff       	call   80103110 <cmos_read>
8010314a:	83 c4 04             	add    $0x4,%esp
8010314d:	89 c2                	mov    %eax,%edx
8010314f:	8b 45 08             	mov    0x8(%ebp),%eax
80103152:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103154:	6a 02                	push   $0x2
80103156:	e8 b5 ff ff ff       	call   80103110 <cmos_read>
8010315b:	83 c4 04             	add    $0x4,%esp
8010315e:	89 c2                	mov    %eax,%edx
80103160:	8b 45 08             	mov    0x8(%ebp),%eax
80103163:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103166:	6a 04                	push   $0x4
80103168:	e8 a3 ff ff ff       	call   80103110 <cmos_read>
8010316d:	83 c4 04             	add    $0x4,%esp
80103170:	89 c2                	mov    %eax,%edx
80103172:	8b 45 08             	mov    0x8(%ebp),%eax
80103175:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103178:	6a 07                	push   $0x7
8010317a:	e8 91 ff ff ff       	call   80103110 <cmos_read>
8010317f:	83 c4 04             	add    $0x4,%esp
80103182:	89 c2                	mov    %eax,%edx
80103184:	8b 45 08             	mov    0x8(%ebp),%eax
80103187:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010318a:	6a 08                	push   $0x8
8010318c:	e8 7f ff ff ff       	call   80103110 <cmos_read>
80103191:	83 c4 04             	add    $0x4,%esp
80103194:	89 c2                	mov    %eax,%edx
80103196:	8b 45 08             	mov    0x8(%ebp),%eax
80103199:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010319c:	6a 09                	push   $0x9
8010319e:	e8 6d ff ff ff       	call   80103110 <cmos_read>
801031a3:	83 c4 04             	add    $0x4,%esp
801031a6:	89 c2                	mov    %eax,%edx
801031a8:	8b 45 08             	mov    0x8(%ebp),%eax
801031ab:	89 50 14             	mov    %edx,0x14(%eax)
}
801031ae:	90                   	nop
801031af:	c9                   	leave  
801031b0:	c3                   	ret    

801031b1 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031b1:	55                   	push   %ebp
801031b2:	89 e5                	mov    %esp,%ebp
801031b4:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031b7:	6a 0b                	push   $0xb
801031b9:	e8 52 ff ff ff       	call   80103110 <cmos_read>
801031be:	83 c4 04             	add    $0x4,%esp
801031c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c7:	83 e0 04             	and    $0x4,%eax
801031ca:	85 c0                	test   %eax,%eax
801031cc:	0f 94 c0             	sete   %al
801031cf:	0f b6 c0             	movzbl %al,%eax
801031d2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801031d5:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031d8:	50                   	push   %eax
801031d9:	e8 62 ff ff ff       	call   80103140 <fill_rtcdate>
801031de:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801031e1:	6a 0a                	push   $0xa
801031e3:	e8 28 ff ff ff       	call   80103110 <cmos_read>
801031e8:	83 c4 04             	add    $0x4,%esp
801031eb:	25 80 00 00 00       	and    $0x80,%eax
801031f0:	85 c0                	test   %eax,%eax
801031f2:	75 27                	jne    8010321b <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801031f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f7:	50                   	push   %eax
801031f8:	e8 43 ff ff ff       	call   80103140 <fill_rtcdate>
801031fd:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103200:	83 ec 04             	sub    $0x4,%esp
80103203:	6a 18                	push   $0x18
80103205:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103208:	50                   	push   %eax
80103209:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010320c:	50                   	push   %eax
8010320d:	e8 28 20 00 00       	call   8010523a <memcmp>
80103212:	83 c4 10             	add    $0x10,%esp
80103215:	85 c0                	test   %eax,%eax
80103217:	74 05                	je     8010321e <cmostime+0x6d>
80103219:	eb ba                	jmp    801031d5 <cmostime+0x24>
        continue;
8010321b:	90                   	nop
    fill_rtcdate(&t1);
8010321c:	eb b7                	jmp    801031d5 <cmostime+0x24>
      break;
8010321e:	90                   	nop
  }

  // convert
  if(bcd) {
8010321f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103223:	0f 84 b4 00 00 00    	je     801032dd <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103229:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010322c:	c1 e8 04             	shr    $0x4,%eax
8010322f:	89 c2                	mov    %eax,%edx
80103231:	89 d0                	mov    %edx,%eax
80103233:	c1 e0 02             	shl    $0x2,%eax
80103236:	01 d0                	add    %edx,%eax
80103238:	01 c0                	add    %eax,%eax
8010323a:	89 c2                	mov    %eax,%edx
8010323c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010323f:	83 e0 0f             	and    $0xf,%eax
80103242:	01 d0                	add    %edx,%eax
80103244:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103247:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010324a:	c1 e8 04             	shr    $0x4,%eax
8010324d:	89 c2                	mov    %eax,%edx
8010324f:	89 d0                	mov    %edx,%eax
80103251:	c1 e0 02             	shl    $0x2,%eax
80103254:	01 d0                	add    %edx,%eax
80103256:	01 c0                	add    %eax,%eax
80103258:	89 c2                	mov    %eax,%edx
8010325a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010325d:	83 e0 0f             	and    $0xf,%eax
80103260:	01 d0                	add    %edx,%eax
80103262:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103265:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103268:	c1 e8 04             	shr    $0x4,%eax
8010326b:	89 c2                	mov    %eax,%edx
8010326d:	89 d0                	mov    %edx,%eax
8010326f:	c1 e0 02             	shl    $0x2,%eax
80103272:	01 d0                	add    %edx,%eax
80103274:	01 c0                	add    %eax,%eax
80103276:	89 c2                	mov    %eax,%edx
80103278:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010327b:	83 e0 0f             	and    $0xf,%eax
8010327e:	01 d0                	add    %edx,%eax
80103280:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103286:	c1 e8 04             	shr    $0x4,%eax
80103289:	89 c2                	mov    %eax,%edx
8010328b:	89 d0                	mov    %edx,%eax
8010328d:	c1 e0 02             	shl    $0x2,%eax
80103290:	01 d0                	add    %edx,%eax
80103292:	01 c0                	add    %eax,%eax
80103294:	89 c2                	mov    %eax,%edx
80103296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103299:	83 e0 0f             	and    $0xf,%eax
8010329c:	01 d0                	add    %edx,%eax
8010329e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801032a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032a4:	c1 e8 04             	shr    $0x4,%eax
801032a7:	89 c2                	mov    %eax,%edx
801032a9:	89 d0                	mov    %edx,%eax
801032ab:	c1 e0 02             	shl    $0x2,%eax
801032ae:	01 d0                	add    %edx,%eax
801032b0:	01 c0                	add    %eax,%eax
801032b2:	89 c2                	mov    %eax,%edx
801032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032b7:	83 e0 0f             	and    $0xf,%eax
801032ba:	01 d0                	add    %edx,%eax
801032bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032c2:	c1 e8 04             	shr    $0x4,%eax
801032c5:	89 c2                	mov    %eax,%edx
801032c7:	89 d0                	mov    %edx,%eax
801032c9:	c1 e0 02             	shl    $0x2,%eax
801032cc:	01 d0                	add    %edx,%eax
801032ce:	01 c0                	add    %eax,%eax
801032d0:	89 c2                	mov    %eax,%edx
801032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032d5:	83 e0 0f             	and    $0xf,%eax
801032d8:	01 d0                	add    %edx,%eax
801032da:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032dd:	8b 45 08             	mov    0x8(%ebp),%eax
801032e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032e3:	89 10                	mov    %edx,(%eax)
801032e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032e8:	89 50 04             	mov    %edx,0x4(%eax)
801032eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032ee:	89 50 08             	mov    %edx,0x8(%eax)
801032f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032f4:	89 50 0c             	mov    %edx,0xc(%eax)
801032f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032fa:	89 50 10             	mov    %edx,0x10(%eax)
801032fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103300:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103303:	8b 45 08             	mov    0x8(%ebp),%eax
80103306:	8b 40 14             	mov    0x14(%eax),%eax
80103309:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010330f:	8b 45 08             	mov    0x8(%ebp),%eax
80103312:	89 50 14             	mov    %edx,0x14(%eax)
}
80103315:	90                   	nop
80103316:	c9                   	leave  
80103317:	c3                   	ret    

80103318 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103318:	55                   	push   %ebp
80103319:	89 e5                	mov    %esp,%ebp
8010331b:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010331e:	83 ec 08             	sub    $0x8,%esp
80103321:	68 65 85 10 80       	push   $0x80108565
80103326:	68 00 37 11 80       	push   $0x80113700
8010332b:	e8 0a 1c 00 00       	call   80104f3a <initlock>
80103330:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103333:	83 ec 08             	sub    $0x8,%esp
80103336:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103339:	50                   	push   %eax
8010333a:	ff 75 08             	pushl  0x8(%ebp)
8010333d:	e8 a6 e0 ff ff       	call   801013e8 <readsb>
80103342:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103345:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103348:	a3 34 37 11 80       	mov    %eax,0x80113734
  log.size = sb.nlog;
8010334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103350:	a3 38 37 11 80       	mov    %eax,0x80113738
  log.dev = dev;
80103355:	8b 45 08             	mov    0x8(%ebp),%eax
80103358:	a3 44 37 11 80       	mov    %eax,0x80113744
  recover_from_log();
8010335d:	e8 b2 01 00 00       	call   80103514 <recover_from_log>
}
80103362:	90                   	nop
80103363:	c9                   	leave  
80103364:	c3                   	ret    

80103365 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103365:	55                   	push   %ebp
80103366:	89 e5                	mov    %esp,%ebp
80103368:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010336b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103372:	e9 95 00 00 00       	jmp    8010340c <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103377:	8b 15 34 37 11 80    	mov    0x80113734,%edx
8010337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103380:	01 d0                	add    %edx,%eax
80103382:	83 c0 01             	add    $0x1,%eax
80103385:	89 c2                	mov    %eax,%edx
80103387:	a1 44 37 11 80       	mov    0x80113744,%eax
8010338c:	83 ec 08             	sub    $0x8,%esp
8010338f:	52                   	push   %edx
80103390:	50                   	push   %eax
80103391:	e8 38 ce ff ff       	call   801001ce <bread>
80103396:	83 c4 10             	add    $0x10,%esp
80103399:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010339f:	83 c0 10             	add    $0x10,%eax
801033a2:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801033a9:	89 c2                	mov    %eax,%edx
801033ab:	a1 44 37 11 80       	mov    0x80113744,%eax
801033b0:	83 ec 08             	sub    $0x8,%esp
801033b3:	52                   	push   %edx
801033b4:	50                   	push   %eax
801033b5:	e8 14 ce ff ff       	call   801001ce <bread>
801033ba:	83 c4 10             	add    $0x10,%esp
801033bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c3:	8d 50 5c             	lea    0x5c(%eax),%edx
801033c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c9:	83 c0 5c             	add    $0x5c,%eax
801033cc:	83 ec 04             	sub    $0x4,%esp
801033cf:	68 00 02 00 00       	push   $0x200
801033d4:	52                   	push   %edx
801033d5:	50                   	push   %eax
801033d6:	e8 b7 1e 00 00       	call   80105292 <memmove>
801033db:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033de:	83 ec 0c             	sub    $0xc,%esp
801033e1:	ff 75 ec             	pushl  -0x14(%ebp)
801033e4:	e8 1e ce ff ff       	call   80100207 <bwrite>
801033e9:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
801033ec:	83 ec 0c             	sub    $0xc,%esp
801033ef:	ff 75 f0             	pushl  -0x10(%ebp)
801033f2:	e8 59 ce ff ff       	call   80100250 <brelse>
801033f7:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033fa:	83 ec 0c             	sub    $0xc,%esp
801033fd:	ff 75 ec             	pushl  -0x14(%ebp)
80103400:	e8 4b ce ff ff       	call   80100250 <brelse>
80103405:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103408:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010340c:	a1 48 37 11 80       	mov    0x80113748,%eax
80103411:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103414:	0f 8c 5d ff ff ff    	jl     80103377 <install_trans+0x12>
  }
}
8010341a:	90                   	nop
8010341b:	c9                   	leave  
8010341c:	c3                   	ret    

8010341d <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010341d:	55                   	push   %ebp
8010341e:	89 e5                	mov    %esp,%ebp
80103420:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103423:	a1 34 37 11 80       	mov    0x80113734,%eax
80103428:	89 c2                	mov    %eax,%edx
8010342a:	a1 44 37 11 80       	mov    0x80113744,%eax
8010342f:	83 ec 08             	sub    $0x8,%esp
80103432:	52                   	push   %edx
80103433:	50                   	push   %eax
80103434:	e8 95 cd ff ff       	call   801001ce <bread>
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103442:	83 c0 5c             	add    $0x5c,%eax
80103445:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103448:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010344b:	8b 00                	mov    (%eax),%eax
8010344d:	a3 48 37 11 80       	mov    %eax,0x80113748
  for (i = 0; i < log.lh.n; i++) {
80103452:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103459:	eb 1b                	jmp    80103476 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010345e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103461:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103465:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103468:	83 c2 10             	add    $0x10,%edx
8010346b:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103472:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103476:	a1 48 37 11 80       	mov    0x80113748,%eax
8010347b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010347e:	7c db                	jl     8010345b <read_head+0x3e>
  }
  brelse(buf);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	ff 75 f0             	pushl  -0x10(%ebp)
80103486:	e8 c5 cd ff ff       	call   80100250 <brelse>
8010348b:	83 c4 10             	add    $0x10,%esp
}
8010348e:	90                   	nop
8010348f:	c9                   	leave  
80103490:	c3                   	ret    

80103491 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103491:	55                   	push   %ebp
80103492:	89 e5                	mov    %esp,%ebp
80103494:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103497:	a1 34 37 11 80       	mov    0x80113734,%eax
8010349c:	89 c2                	mov    %eax,%edx
8010349e:	a1 44 37 11 80       	mov    0x80113744,%eax
801034a3:	83 ec 08             	sub    $0x8,%esp
801034a6:	52                   	push   %edx
801034a7:	50                   	push   %eax
801034a8:	e8 21 cd ff ff       	call   801001ce <bread>
801034ad:	83 c4 10             	add    $0x10,%esp
801034b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b6:	83 c0 5c             	add    $0x5c,%eax
801034b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034bc:	8b 15 48 37 11 80    	mov    0x80113748,%edx
801034c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034c5:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034ce:	eb 1b                	jmp    801034eb <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034d3:	83 c0 10             	add    $0x10,%eax
801034d6:	8b 0c 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%ecx
801034dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034e3:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034eb:	a1 48 37 11 80       	mov    0x80113748,%eax
801034f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801034f3:	7c db                	jl     801034d0 <write_head+0x3f>
  }
  bwrite(buf);
801034f5:	83 ec 0c             	sub    $0xc,%esp
801034f8:	ff 75 f0             	pushl  -0x10(%ebp)
801034fb:	e8 07 cd ff ff       	call   80100207 <bwrite>
80103500:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103503:	83 ec 0c             	sub    $0xc,%esp
80103506:	ff 75 f0             	pushl  -0x10(%ebp)
80103509:	e8 42 cd ff ff       	call   80100250 <brelse>
8010350e:	83 c4 10             	add    $0x10,%esp
}
80103511:	90                   	nop
80103512:	c9                   	leave  
80103513:	c3                   	ret    

80103514 <recover_from_log>:

static void
recover_from_log(void)
{
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010351a:	e8 fe fe ff ff       	call   8010341d <read_head>
  install_trans(); // if committed, copy from log to disk
8010351f:	e8 41 fe ff ff       	call   80103365 <install_trans>
  log.lh.n = 0;
80103524:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
8010352b:	00 00 00 
  write_head(); // clear the log
8010352e:	e8 5e ff ff ff       	call   80103491 <write_head>
}
80103533:	90                   	nop
80103534:	c9                   	leave  
80103535:	c3                   	ret    

80103536 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103536:	55                   	push   %ebp
80103537:	89 e5                	mov    %esp,%ebp
80103539:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010353c:	83 ec 0c             	sub    $0xc,%esp
8010353f:	68 00 37 11 80       	push   $0x80113700
80103544:	e8 13 1a 00 00       	call   80104f5c <acquire>
80103549:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010354c:	a1 40 37 11 80       	mov    0x80113740,%eax
80103551:	85 c0                	test   %eax,%eax
80103553:	74 17                	je     8010356c <begin_op+0x36>
      sleep(&log, &log.lock);
80103555:	83 ec 08             	sub    $0x8,%esp
80103558:	68 00 37 11 80       	push   $0x80113700
8010355d:	68 00 37 11 80       	push   $0x80113700
80103562:	e8 dc 15 00 00       	call   80104b43 <sleep>
80103567:	83 c4 10             	add    $0x10,%esp
8010356a:	eb e0                	jmp    8010354c <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010356c:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
80103572:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103577:	8d 50 01             	lea    0x1(%eax),%edx
8010357a:	89 d0                	mov    %edx,%eax
8010357c:	c1 e0 02             	shl    $0x2,%eax
8010357f:	01 d0                	add    %edx,%eax
80103581:	01 c0                	add    %eax,%eax
80103583:	01 c8                	add    %ecx,%eax
80103585:	83 f8 1e             	cmp    $0x1e,%eax
80103588:	7e 17                	jle    801035a1 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010358a:	83 ec 08             	sub    $0x8,%esp
8010358d:	68 00 37 11 80       	push   $0x80113700
80103592:	68 00 37 11 80       	push   $0x80113700
80103597:	e8 a7 15 00 00       	call   80104b43 <sleep>
8010359c:	83 c4 10             	add    $0x10,%esp
8010359f:	eb ab                	jmp    8010354c <begin_op+0x16>
    } else {
      log.outstanding += 1;
801035a1:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801035a6:	83 c0 01             	add    $0x1,%eax
801035a9:	a3 3c 37 11 80       	mov    %eax,0x8011373c
      release(&log.lock);
801035ae:	83 ec 0c             	sub    $0xc,%esp
801035b1:	68 00 37 11 80       	push   $0x80113700
801035b6:	e8 0f 1a 00 00       	call   80104fca <release>
801035bb:	83 c4 10             	add    $0x10,%esp
      break;
801035be:	90                   	nop
    }
  }
}
801035bf:	90                   	nop
801035c0:	c9                   	leave  
801035c1:	c3                   	ret    

801035c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035c2:	55                   	push   %ebp
801035c3:	89 e5                	mov    %esp,%ebp
801035c5:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035cf:	83 ec 0c             	sub    $0xc,%esp
801035d2:	68 00 37 11 80       	push   $0x80113700
801035d7:	e8 80 19 00 00       	call   80104f5c <acquire>
801035dc:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035df:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801035e4:	83 e8 01             	sub    $0x1,%eax
801035e7:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  if(log.committing)
801035ec:	a1 40 37 11 80       	mov    0x80113740,%eax
801035f1:	85 c0                	test   %eax,%eax
801035f3:	74 0d                	je     80103602 <end_op+0x40>
    panic("log.committing");
801035f5:	83 ec 0c             	sub    $0xc,%esp
801035f8:	68 69 85 10 80       	push   $0x80108569
801035fd:	e8 9a cf ff ff       	call   8010059c <panic>
  if(log.outstanding == 0){
80103602:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103607:	85 c0                	test   %eax,%eax
80103609:	75 13                	jne    8010361e <end_op+0x5c>
    do_commit = 1;
8010360b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103612:	c7 05 40 37 11 80 01 	movl   $0x1,0x80113740
80103619:	00 00 00 
8010361c:	eb 10                	jmp    8010362e <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
8010361e:	83 ec 0c             	sub    $0xc,%esp
80103621:	68 00 37 11 80       	push   $0x80113700
80103626:	e8 fe 15 00 00       	call   80104c29 <wakeup>
8010362b:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010362e:	83 ec 0c             	sub    $0xc,%esp
80103631:	68 00 37 11 80       	push   $0x80113700
80103636:	e8 8f 19 00 00       	call   80104fca <release>
8010363b:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010363e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103642:	74 3f                	je     80103683 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103644:	e8 f5 00 00 00       	call   8010373e <commit>
    acquire(&log.lock);
80103649:	83 ec 0c             	sub    $0xc,%esp
8010364c:	68 00 37 11 80       	push   $0x80113700
80103651:	e8 06 19 00 00       	call   80104f5c <acquire>
80103656:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103659:	c7 05 40 37 11 80 00 	movl   $0x0,0x80113740
80103660:	00 00 00 
    wakeup(&log);
80103663:	83 ec 0c             	sub    $0xc,%esp
80103666:	68 00 37 11 80       	push   $0x80113700
8010366b:	e8 b9 15 00 00       	call   80104c29 <wakeup>
80103670:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103673:	83 ec 0c             	sub    $0xc,%esp
80103676:	68 00 37 11 80       	push   $0x80113700
8010367b:	e8 4a 19 00 00       	call   80104fca <release>
80103680:	83 c4 10             	add    $0x10,%esp
  }
}
80103683:	90                   	nop
80103684:	c9                   	leave  
80103685:	c3                   	ret    

80103686 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103686:	55                   	push   %ebp
80103687:	89 e5                	mov    %esp,%ebp
80103689:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010368c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103693:	e9 95 00 00 00       	jmp    8010372d <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103698:	8b 15 34 37 11 80    	mov    0x80113734,%edx
8010369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036a1:	01 d0                	add    %edx,%eax
801036a3:	83 c0 01             	add    $0x1,%eax
801036a6:	89 c2                	mov    %eax,%edx
801036a8:	a1 44 37 11 80       	mov    0x80113744,%eax
801036ad:	83 ec 08             	sub    $0x8,%esp
801036b0:	52                   	push   %edx
801036b1:	50                   	push   %eax
801036b2:	e8 17 cb ff ff       	call   801001ce <bread>
801036b7:	83 c4 10             	add    $0x10,%esp
801036ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c0:	83 c0 10             	add    $0x10,%eax
801036c3:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801036ca:	89 c2                	mov    %eax,%edx
801036cc:	a1 44 37 11 80       	mov    0x80113744,%eax
801036d1:	83 ec 08             	sub    $0x8,%esp
801036d4:	52                   	push   %edx
801036d5:	50                   	push   %eax
801036d6:	e8 f3 ca ff ff       	call   801001ce <bread>
801036db:	83 c4 10             	add    $0x10,%esp
801036de:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036e4:	8d 50 5c             	lea    0x5c(%eax),%edx
801036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ea:	83 c0 5c             	add    $0x5c,%eax
801036ed:	83 ec 04             	sub    $0x4,%esp
801036f0:	68 00 02 00 00       	push   $0x200
801036f5:	52                   	push   %edx
801036f6:	50                   	push   %eax
801036f7:	e8 96 1b 00 00       	call   80105292 <memmove>
801036fc:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036ff:	83 ec 0c             	sub    $0xc,%esp
80103702:	ff 75 f0             	pushl  -0x10(%ebp)
80103705:	e8 fd ca ff ff       	call   80100207 <bwrite>
8010370a:	83 c4 10             	add    $0x10,%esp
    brelse(from);
8010370d:	83 ec 0c             	sub    $0xc,%esp
80103710:	ff 75 ec             	pushl  -0x14(%ebp)
80103713:	e8 38 cb ff ff       	call   80100250 <brelse>
80103718:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	ff 75 f0             	pushl  -0x10(%ebp)
80103721:	e8 2a cb ff ff       	call   80100250 <brelse>
80103726:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103729:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010372d:	a1 48 37 11 80       	mov    0x80113748,%eax
80103732:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103735:	0f 8c 5d ff ff ff    	jl     80103698 <write_log+0x12>
  }
}
8010373b:	90                   	nop
8010373c:	c9                   	leave  
8010373d:	c3                   	ret    

8010373e <commit>:

static void
commit()
{
8010373e:	55                   	push   %ebp
8010373f:	89 e5                	mov    %esp,%ebp
80103741:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103744:	a1 48 37 11 80       	mov    0x80113748,%eax
80103749:	85 c0                	test   %eax,%eax
8010374b:	7e 1e                	jle    8010376b <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010374d:	e8 34 ff ff ff       	call   80103686 <write_log>
    write_head();    // Write header to disk -- the real commit
80103752:	e8 3a fd ff ff       	call   80103491 <write_head>
    install_trans(); // Now install writes to home locations
80103757:	e8 09 fc ff ff       	call   80103365 <install_trans>
    log.lh.n = 0;
8010375c:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80103763:	00 00 00 
    write_head();    // Erase the transaction from the log
80103766:	e8 26 fd ff ff       	call   80103491 <write_head>
  }
}
8010376b:	90                   	nop
8010376c:	c9                   	leave  
8010376d:	c3                   	ret    

8010376e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010376e:	55                   	push   %ebp
8010376f:	89 e5                	mov    %esp,%ebp
80103771:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103774:	a1 48 37 11 80       	mov    0x80113748,%eax
80103779:	83 f8 1d             	cmp    $0x1d,%eax
8010377c:	7f 12                	jg     80103790 <log_write+0x22>
8010377e:	a1 48 37 11 80       	mov    0x80113748,%eax
80103783:	8b 15 38 37 11 80    	mov    0x80113738,%edx
80103789:	83 ea 01             	sub    $0x1,%edx
8010378c:	39 d0                	cmp    %edx,%eax
8010378e:	7c 0d                	jl     8010379d <log_write+0x2f>
    panic("too big a transaction");
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	68 78 85 10 80       	push   $0x80108578
80103798:	e8 ff cd ff ff       	call   8010059c <panic>
  if (log.outstanding < 1)
8010379d:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801037a2:	85 c0                	test   %eax,%eax
801037a4:	7f 0d                	jg     801037b3 <log_write+0x45>
    panic("log_write outside of trans");
801037a6:	83 ec 0c             	sub    $0xc,%esp
801037a9:	68 8e 85 10 80       	push   $0x8010858e
801037ae:	e8 e9 cd ff ff       	call   8010059c <panic>

  acquire(&log.lock);
801037b3:	83 ec 0c             	sub    $0xc,%esp
801037b6:	68 00 37 11 80       	push   $0x80113700
801037bb:	e8 9c 17 00 00       	call   80104f5c <acquire>
801037c0:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801037c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037ca:	eb 1d                	jmp    801037e9 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037cf:	83 c0 10             	add    $0x10,%eax
801037d2:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801037d9:	89 c2                	mov    %eax,%edx
801037db:	8b 45 08             	mov    0x8(%ebp),%eax
801037de:	8b 40 08             	mov    0x8(%eax),%eax
801037e1:	39 c2                	cmp    %eax,%edx
801037e3:	74 10                	je     801037f5 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801037e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037e9:	a1 48 37 11 80       	mov    0x80113748,%eax
801037ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801037f1:	7c d9                	jl     801037cc <log_write+0x5e>
801037f3:	eb 01                	jmp    801037f6 <log_write+0x88>
      break;
801037f5:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801037f6:	8b 45 08             	mov    0x8(%ebp),%eax
801037f9:	8b 40 08             	mov    0x8(%eax),%eax
801037fc:	89 c2                	mov    %eax,%edx
801037fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103801:	83 c0 10             	add    $0x10,%eax
80103804:	89 14 85 0c 37 11 80 	mov    %edx,-0x7feec8f4(,%eax,4)
  if (i == log.lh.n)
8010380b:	a1 48 37 11 80       	mov    0x80113748,%eax
80103810:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103813:	75 0d                	jne    80103822 <log_write+0xb4>
    log.lh.n++;
80103815:	a1 48 37 11 80       	mov    0x80113748,%eax
8010381a:	83 c0 01             	add    $0x1,%eax
8010381d:	a3 48 37 11 80       	mov    %eax,0x80113748
  b->flags |= B_DIRTY; // prevent eviction
80103822:	8b 45 08             	mov    0x8(%ebp),%eax
80103825:	8b 00                	mov    (%eax),%eax
80103827:	83 c8 04             	or     $0x4,%eax
8010382a:	89 c2                	mov    %eax,%edx
8010382c:	8b 45 08             	mov    0x8(%ebp),%eax
8010382f:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103831:	83 ec 0c             	sub    $0xc,%esp
80103834:	68 00 37 11 80       	push   $0x80113700
80103839:	e8 8c 17 00 00       	call   80104fca <release>
8010383e:	83 c4 10             	add    $0x10,%esp
}
80103841:	90                   	nop
80103842:	c9                   	leave  
80103843:	c3                   	ret    

80103844 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103844:	55                   	push   %ebp
80103845:	89 e5                	mov    %esp,%ebp
80103847:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010384a:	8b 55 08             	mov    0x8(%ebp),%edx
8010384d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103850:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103853:	f0 87 02             	lock xchg %eax,(%edx)
80103856:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103859:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010385c:	c9                   	leave  
8010385d:	c3                   	ret    

8010385e <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010385e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103862:	83 e4 f0             	and    $0xfffffff0,%esp
80103865:	ff 71 fc             	pushl  -0x4(%ecx)
80103868:	55                   	push   %ebp
80103869:	89 e5                	mov    %esp,%ebp
8010386b:	51                   	push   %ecx
8010386c:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010386f:	83 ec 08             	sub    $0x8,%esp
80103872:	68 00 00 40 80       	push   $0x80400000
80103877:	68 28 65 11 80       	push   $0x80116528
8010387c:	e8 df f2 ff ff       	call   80102b60 <kinit1>
80103881:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103884:	e8 b9 42 00 00       	call   80107b42 <kvmalloc>
  mpinit();        // detect other processors
80103889:	e8 ba 03 00 00       	call   80103c48 <mpinit>
  lapicinit();     // interrupt controller
8010388e:	e8 39 f6 ff ff       	call   80102ecc <lapicinit>
  seginit();       // segment descriptors
80103893:	e8 95 3d 00 00       	call   8010762d <seginit>
  picinit();       // disable pic
80103898:	e8 fc 04 00 00       	call   80103d99 <picinit>
  ioapicinit();    // another interrupt controller
8010389d:	e8 da f1 ff ff       	call   80102a7c <ioapicinit>
  consoleinit();   // console hardware
801038a2:	e8 a8 d2 ff ff       	call   80100b4f <consoleinit>
  uartinit();      // serial port
801038a7:	e8 1a 31 00 00       	call   801069c6 <uartinit>
  pinit();         // process table
801038ac:	e8 24 09 00 00       	call   801041d5 <pinit>
  tvinit();        // trap vectors
801038b1:	e8 f2 2c 00 00       	call   801065a8 <tvinit>
  binit();         // buffer cache
801038b6:	e8 79 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038bb:	e8 19 d7 ff ff       	call   80100fd9 <fileinit>
  ideinit();       // disk 
801038c0:	e8 8e ed ff ff       	call   80102653 <ideinit>
  startothers();   // start other processors
801038c5:	e8 80 00 00 00       	call   8010394a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038ca:	83 ec 08             	sub    $0x8,%esp
801038cd:	68 00 00 00 8e       	push   $0x8e000000
801038d2:	68 00 00 40 80       	push   $0x80400000
801038d7:	e8 bd f2 ff ff       	call   80102b99 <kinit2>
801038dc:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038df:	e8 d7 0a 00 00       	call   801043bb <userinit>
  mpmain();        // finish this processor's setup
801038e4:	e8 1a 00 00 00       	call   80103903 <mpmain>

801038e9 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038e9:	55                   	push   %ebp
801038ea:	89 e5                	mov    %esp,%ebp
801038ec:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038ef:	e8 66 42 00 00       	call   80107b5a <switchkvm>
  seginit();
801038f4:	e8 34 3d 00 00       	call   8010762d <seginit>
  lapicinit();
801038f9:	e8 ce f5 ff ff       	call   80102ecc <lapicinit>
  mpmain();
801038fe:	e8 00 00 00 00       	call   80103903 <mpmain>

80103903 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103903:	55                   	push   %ebp
80103904:	89 e5                	mov    %esp,%ebp
80103906:	53                   	push   %ebx
80103907:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
8010390a:	e8 e4 08 00 00       	call   801041f3 <cpuid>
8010390f:	89 c3                	mov    %eax,%ebx
80103911:	e8 dd 08 00 00       	call   801041f3 <cpuid>
80103916:	83 ec 04             	sub    $0x4,%esp
80103919:	53                   	push   %ebx
8010391a:	50                   	push   %eax
8010391b:	68 a9 85 10 80       	push   $0x801085a9
80103920:	e8 d7 ca ff ff       	call   801003fc <cprintf>
80103925:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103928:	e8 f1 2d 00 00       	call   8010671e <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
8010392d:	e8 e2 08 00 00       	call   80104214 <mycpu>
80103932:	05 a0 00 00 00       	add    $0xa0,%eax
80103937:	83 ec 08             	sub    $0x8,%esp
8010393a:	6a 01                	push   $0x1
8010393c:	50                   	push   %eax
8010393d:	e8 02 ff ff ff       	call   80103844 <xchg>
80103942:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103945:	e8 06 10 00 00       	call   80104950 <scheduler>

8010394a <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010394a:	55                   	push   %ebp
8010394b:	89 e5                	mov    %esp,%ebp
8010394d:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103950:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103957:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010395c:	83 ec 04             	sub    $0x4,%esp
8010395f:	50                   	push   %eax
80103960:	68 ec b4 10 80       	push   $0x8010b4ec
80103965:	ff 75 f0             	pushl  -0x10(%ebp)
80103968:	e8 25 19 00 00       	call   80105292 <memmove>
8010396d:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103970:	c7 45 f4 00 38 11 80 	movl   $0x80113800,-0xc(%ebp)
80103977:	eb 79                	jmp    801039f2 <startothers+0xa8>
    if(c == mycpu())  // We've started already.
80103979:	e8 96 08 00 00       	call   80104214 <mycpu>
8010397e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103981:	74 67                	je     801039ea <startothers+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103983:	e8 0c f3 ff ff       	call   80102c94 <kalloc>
80103988:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010398b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010398e:	83 e8 04             	sub    $0x4,%eax
80103991:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103994:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010399a:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010399c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010399f:	83 e8 08             	sub    $0x8,%eax
801039a2:	c7 00 e9 38 10 80    	movl   $0x801038e9,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801039a8:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801039ad:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b6:	83 e8 0c             	sub    $0xc,%eax
801039b9:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801039bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039be:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801039c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c7:	0f b6 00             	movzbl (%eax),%eax
801039ca:	0f b6 c0             	movzbl %al,%eax
801039cd:	83 ec 08             	sub    $0x8,%esp
801039d0:	52                   	push   %edx
801039d1:	50                   	push   %eax
801039d2:	e8 56 f6 ff ff       	call   8010302d <lapicstartap>
801039d7:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039da:	90                   	nop
801039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039de:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801039e4:	85 c0                	test   %eax,%eax
801039e6:	74 f3                	je     801039db <startothers+0x91>
801039e8:	eb 01                	jmp    801039eb <startothers+0xa1>
      continue;
801039ea:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
801039eb:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801039f2:	a1 80 3d 11 80       	mov    0x80113d80,%eax
801039f7:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039fd:	05 00 38 11 80       	add    $0x80113800,%eax
80103a02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a05:	0f 82 6e ff ff ff    	jb     80103979 <startothers+0x2f>
      ;
  }
}
80103a0b:	90                   	nop
80103a0c:	c9                   	leave  
80103a0d:	c3                   	ret    

80103a0e <inb>:
{
80103a0e:	55                   	push   %ebp
80103a0f:	89 e5                	mov    %esp,%ebp
80103a11:	83 ec 14             	sub    $0x14,%esp
80103a14:	8b 45 08             	mov    0x8(%ebp),%eax
80103a17:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a1b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a1f:	89 c2                	mov    %eax,%edx
80103a21:	ec                   	in     (%dx),%al
80103a22:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a25:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a29:	c9                   	leave  
80103a2a:	c3                   	ret    

80103a2b <outb>:
{
80103a2b:	55                   	push   %ebp
80103a2c:	89 e5                	mov    %esp,%ebp
80103a2e:	83 ec 08             	sub    $0x8,%esp
80103a31:	8b 55 08             	mov    0x8(%ebp),%edx
80103a34:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a37:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a3b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a3e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a42:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a46:	ee                   	out    %al,(%dx)
}
80103a47:	90                   	nop
80103a48:	c9                   	leave  
80103a49:	c3                   	ret    

80103a4a <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103a4a:	55                   	push   %ebp
80103a4b:	89 e5                	mov    %esp,%ebp
80103a4d:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103a50:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a5e:	eb 15                	jmp    80103a75 <sum+0x2b>
    sum += addr[i];
80103a60:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a63:	8b 45 08             	mov    0x8(%ebp),%eax
80103a66:	01 d0                	add    %edx,%eax
80103a68:	0f b6 00             	movzbl (%eax),%eax
80103a6b:	0f b6 c0             	movzbl %al,%eax
80103a6e:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a71:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a78:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a7b:	7c e3                	jl     80103a60 <sum+0x16>
  return sum;
80103a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a80:	c9                   	leave  
80103a81:	c3                   	ret    

80103a82 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a82:	55                   	push   %ebp
80103a83:	89 e5                	mov    %esp,%ebp
80103a85:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a88:	8b 45 08             	mov    0x8(%ebp),%eax
80103a8b:	05 00 00 00 80       	add    $0x80000000,%eax
80103a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a93:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a99:	01 d0                	add    %edx,%eax
80103a9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa4:	eb 36                	jmp    80103adc <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103aa6:	83 ec 04             	sub    $0x4,%esp
80103aa9:	6a 04                	push   $0x4
80103aab:	68 c0 85 10 80       	push   $0x801085c0
80103ab0:	ff 75 f4             	pushl  -0xc(%ebp)
80103ab3:	e8 82 17 00 00       	call   8010523a <memcmp>
80103ab8:	83 c4 10             	add    $0x10,%esp
80103abb:	85 c0                	test   %eax,%eax
80103abd:	75 19                	jne    80103ad8 <mpsearch1+0x56>
80103abf:	83 ec 08             	sub    $0x8,%esp
80103ac2:	6a 10                	push   $0x10
80103ac4:	ff 75 f4             	pushl  -0xc(%ebp)
80103ac7:	e8 7e ff ff ff       	call   80103a4a <sum>
80103acc:	83 c4 10             	add    $0x10,%esp
80103acf:	84 c0                	test   %al,%al
80103ad1:	75 05                	jne    80103ad8 <mpsearch1+0x56>
      return (struct mp*)p;
80103ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad6:	eb 11                	jmp    80103ae9 <mpsearch1+0x67>
  for(p = addr; p < e; p += sizeof(struct mp))
80103ad8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103adf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ae2:	72 c2                	jb     80103aa6 <mpsearch1+0x24>
  return 0;
80103ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ae9:	c9                   	leave  
80103aea:	c3                   	ret    

80103aeb <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103aeb:	55                   	push   %ebp
80103aec:	89 e5                	mov    %esp,%ebp
80103aee:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103af1:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afb:	83 c0 0f             	add    $0xf,%eax
80103afe:	0f b6 00             	movzbl (%eax),%eax
80103b01:	0f b6 c0             	movzbl %al,%eax
80103b04:	c1 e0 08             	shl    $0x8,%eax
80103b07:	89 c2                	mov    %eax,%edx
80103b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0c:	83 c0 0e             	add    $0xe,%eax
80103b0f:	0f b6 00             	movzbl (%eax),%eax
80103b12:	0f b6 c0             	movzbl %al,%eax
80103b15:	09 d0                	or     %edx,%eax
80103b17:	c1 e0 04             	shl    $0x4,%eax
80103b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b21:	74 21                	je     80103b44 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b23:	83 ec 08             	sub    $0x8,%esp
80103b26:	68 00 04 00 00       	push   $0x400
80103b2b:	ff 75 f0             	pushl  -0x10(%ebp)
80103b2e:	e8 4f ff ff ff       	call   80103a82 <mpsearch1>
80103b33:	83 c4 10             	add    $0x10,%esp
80103b36:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b3d:	74 51                	je     80103b90 <mpsearch+0xa5>
      return mp;
80103b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b42:	eb 61                	jmp    80103ba5 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b47:	83 c0 14             	add    $0x14,%eax
80103b4a:	0f b6 00             	movzbl (%eax),%eax
80103b4d:	0f b6 c0             	movzbl %al,%eax
80103b50:	c1 e0 08             	shl    $0x8,%eax
80103b53:	89 c2                	mov    %eax,%edx
80103b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b58:	83 c0 13             	add    $0x13,%eax
80103b5b:	0f b6 00             	movzbl (%eax),%eax
80103b5e:	0f b6 c0             	movzbl %al,%eax
80103b61:	09 d0                	or     %edx,%eax
80103b63:	c1 e0 0a             	shl    $0xa,%eax
80103b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6c:	2d 00 04 00 00       	sub    $0x400,%eax
80103b71:	83 ec 08             	sub    $0x8,%esp
80103b74:	68 00 04 00 00       	push   $0x400
80103b79:	50                   	push   %eax
80103b7a:	e8 03 ff ff ff       	call   80103a82 <mpsearch1>
80103b7f:	83 c4 10             	add    $0x10,%esp
80103b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b89:	74 05                	je     80103b90 <mpsearch+0xa5>
      return mp;
80103b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b8e:	eb 15                	jmp    80103ba5 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b90:	83 ec 08             	sub    $0x8,%esp
80103b93:	68 00 00 01 00       	push   $0x10000
80103b98:	68 00 00 0f 00       	push   $0xf0000
80103b9d:	e8 e0 fe ff ff       	call   80103a82 <mpsearch1>
80103ba2:	83 c4 10             	add    $0x10,%esp
}
80103ba5:	c9                   	leave  
80103ba6:	c3                   	ret    

80103ba7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ba7:	55                   	push   %ebp
80103ba8:	89 e5                	mov    %esp,%ebp
80103baa:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bad:	e8 39 ff ff ff       	call   80103aeb <mpsearch>
80103bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bb9:	74 0a                	je     80103bc5 <mpconfig+0x1e>
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	8b 40 04             	mov    0x4(%eax),%eax
80103bc1:	85 c0                	test   %eax,%eax
80103bc3:	75 07                	jne    80103bcc <mpconfig+0x25>
    return 0;
80103bc5:	b8 00 00 00 00       	mov    $0x0,%eax
80103bca:	eb 7a                	jmp    80103c46 <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bcf:	8b 40 04             	mov    0x4(%eax),%eax
80103bd2:	05 00 00 00 80       	add    $0x80000000,%eax
80103bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bda:	83 ec 04             	sub    $0x4,%esp
80103bdd:	6a 04                	push   $0x4
80103bdf:	68 c5 85 10 80       	push   $0x801085c5
80103be4:	ff 75 f0             	pushl  -0x10(%ebp)
80103be7:	e8 4e 16 00 00       	call   8010523a <memcmp>
80103bec:	83 c4 10             	add    $0x10,%esp
80103bef:	85 c0                	test   %eax,%eax
80103bf1:	74 07                	je     80103bfa <mpconfig+0x53>
    return 0;
80103bf3:	b8 00 00 00 00       	mov    $0x0,%eax
80103bf8:	eb 4c                	jmp    80103c46 <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
80103bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bfd:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c01:	3c 01                	cmp    $0x1,%al
80103c03:	74 12                	je     80103c17 <mpconfig+0x70>
80103c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c08:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c0c:	3c 04                	cmp    $0x4,%al
80103c0e:	74 07                	je     80103c17 <mpconfig+0x70>
    return 0;
80103c10:	b8 00 00 00 00       	mov    $0x0,%eax
80103c15:	eb 2f                	jmp    80103c46 <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
80103c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c1a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c1e:	0f b7 c0             	movzwl %ax,%eax
80103c21:	83 ec 08             	sub    $0x8,%esp
80103c24:	50                   	push   %eax
80103c25:	ff 75 f0             	pushl  -0x10(%ebp)
80103c28:	e8 1d fe ff ff       	call   80103a4a <sum>
80103c2d:	83 c4 10             	add    $0x10,%esp
80103c30:	84 c0                	test   %al,%al
80103c32:	74 07                	je     80103c3b <mpconfig+0x94>
    return 0;
80103c34:	b8 00 00 00 00       	mov    $0x0,%eax
80103c39:	eb 0b                	jmp    80103c46 <mpconfig+0x9f>
  *pmp = mp;
80103c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c41:	89 10                	mov    %edx,(%eax)
  return conf;
80103c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c46:	c9                   	leave  
80103c47:	c3                   	ret    

80103c48 <mpinit>:

void
mpinit(void)
{
80103c48:	55                   	push   %ebp
80103c49:	89 e5                	mov    %esp,%ebp
80103c4b:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103c4e:	83 ec 0c             	sub    $0xc,%esp
80103c51:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103c54:	50                   	push   %eax
80103c55:	e8 4d ff ff ff       	call   80103ba7 <mpconfig>
80103c5a:	83 c4 10             	add    $0x10,%esp
80103c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c64:	75 0d                	jne    80103c73 <mpinit+0x2b>
    panic("Expect to run on an SMP");
80103c66:	83 ec 0c             	sub    $0xc,%esp
80103c69:	68 ca 85 10 80       	push   $0x801085ca
80103c6e:	e8 29 c9 ff ff       	call   8010059c <panic>
  ismp = 1;
80103c73:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c7d:	8b 40 24             	mov    0x24(%eax),%eax
80103c80:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c88:	83 c0 2c             	add    $0x2c,%eax
80103c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c91:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c95:	0f b7 d0             	movzwl %ax,%edx
80103c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c9b:	01 d0                	add    %edx,%eax
80103c9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103ca0:	eb 7b                	jmp    80103d1d <mpinit+0xd5>
    switch(*p){
80103ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca5:	0f b6 00             	movzbl (%eax),%eax
80103ca8:	0f b6 c0             	movzbl %al,%eax
80103cab:	83 f8 04             	cmp    $0x4,%eax
80103cae:	77 65                	ja     80103d15 <mpinit+0xcd>
80103cb0:	8b 04 85 04 86 10 80 	mov    -0x7fef79fc(,%eax,4),%eax
80103cb7:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103cbf:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103cc4:	83 f8 07             	cmp    $0x7,%eax
80103cc7:	7f 28                	jg     80103cf1 <mpinit+0xa9>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103cc9:	8b 15 80 3d 11 80    	mov    0x80113d80,%edx
80103ccf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103cd2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cd6:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103cdc:	81 c2 00 38 11 80    	add    $0x80113800,%edx
80103ce2:	88 02                	mov    %al,(%edx)
        ncpu++;
80103ce4:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103ce9:	83 c0 01             	add    $0x1,%eax
80103cec:	a3 80 3d 11 80       	mov    %eax,0x80113d80
      }
      p += sizeof(struct mpproc);
80103cf1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103cf5:	eb 26                	jmp    80103d1d <mpinit+0xd5>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d00:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d04:	a2 e0 37 11 80       	mov    %al,0x801137e0
      p += sizeof(struct mpioapic);
80103d09:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d0d:	eb 0e                	jmp    80103d1d <mpinit+0xd5>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d0f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d13:	eb 08                	jmp    80103d1d <mpinit+0xd5>
    default:
      ismp = 0;
80103d15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103d1c:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d20:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103d23:	0f 82 79 ff ff ff    	jb     80103ca2 <mpinit+0x5a>
    }
  }
  if(!ismp)
80103d29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d2d:	75 0d                	jne    80103d3c <mpinit+0xf4>
    panic("Didn't find a suitable machine");
80103d2f:	83 ec 0c             	sub    $0xc,%esp
80103d32:	68 e4 85 10 80       	push   $0x801085e4
80103d37:	e8 60 c8 ff ff       	call   8010059c <panic>

  if(mp->imcrp){
80103d3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d3f:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d43:	84 c0                	test   %al,%al
80103d45:	74 30                	je     80103d77 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d47:	83 ec 08             	sub    $0x8,%esp
80103d4a:	6a 70                	push   $0x70
80103d4c:	6a 22                	push   $0x22
80103d4e:	e8 d8 fc ff ff       	call   80103a2b <outb>
80103d53:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d56:	83 ec 0c             	sub    $0xc,%esp
80103d59:	6a 23                	push   $0x23
80103d5b:	e8 ae fc ff ff       	call   80103a0e <inb>
80103d60:	83 c4 10             	add    $0x10,%esp
80103d63:	83 c8 01             	or     $0x1,%eax
80103d66:	0f b6 c0             	movzbl %al,%eax
80103d69:	83 ec 08             	sub    $0x8,%esp
80103d6c:	50                   	push   %eax
80103d6d:	6a 23                	push   $0x23
80103d6f:	e8 b7 fc ff ff       	call   80103a2b <outb>
80103d74:	83 c4 10             	add    $0x10,%esp
  }
}
80103d77:	90                   	nop
80103d78:	c9                   	leave  
80103d79:	c3                   	ret    

80103d7a <outb>:
{
80103d7a:	55                   	push   %ebp
80103d7b:	89 e5                	mov    %esp,%ebp
80103d7d:	83 ec 08             	sub    $0x8,%esp
80103d80:	8b 55 08             	mov    0x8(%ebp),%edx
80103d83:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d86:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d8a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d8d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d91:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d95:	ee                   	out    %al,(%dx)
}
80103d96:	90                   	nop
80103d97:	c9                   	leave  
80103d98:	c3                   	ret    

80103d99 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103d99:	55                   	push   %ebp
80103d9a:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103d9c:	68 ff 00 00 00       	push   $0xff
80103da1:	6a 21                	push   $0x21
80103da3:	e8 d2 ff ff ff       	call   80103d7a <outb>
80103da8:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103dab:	68 ff 00 00 00       	push   $0xff
80103db0:	68 a1 00 00 00       	push   $0xa1
80103db5:	e8 c0 ff ff ff       	call   80103d7a <outb>
80103dba:	83 c4 08             	add    $0x8,%esp
}
80103dbd:	90                   	nop
80103dbe:	c9                   	leave  
80103dbf:	c3                   	ret    

80103dc0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103dc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd9:	8b 10                	mov    (%eax),%edx
80103ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dde:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103de0:	e8 12 d2 ff ff       	call   80100ff7 <filealloc>
80103de5:	89 c2                	mov    %eax,%edx
80103de7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dea:	89 10                	mov    %edx,(%eax)
80103dec:	8b 45 08             	mov    0x8(%ebp),%eax
80103def:	8b 00                	mov    (%eax),%eax
80103df1:	85 c0                	test   %eax,%eax
80103df3:	0f 84 ca 00 00 00    	je     80103ec3 <pipealloc+0x103>
80103df9:	e8 f9 d1 ff ff       	call   80100ff7 <filealloc>
80103dfe:	89 c2                	mov    %eax,%edx
80103e00:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e03:	89 10                	mov    %edx,(%eax)
80103e05:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e08:	8b 00                	mov    (%eax),%eax
80103e0a:	85 c0                	test   %eax,%eax
80103e0c:	0f 84 b1 00 00 00    	je     80103ec3 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103e12:	e8 7d ee ff ff       	call   80102c94 <kalloc>
80103e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e1e:	0f 84 a2 00 00 00    	je     80103ec6 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80103e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e27:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103e2e:	00 00 00 
  p->writeopen = 1;
80103e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e34:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103e3b:	00 00 00 
  p->nwrite = 0;
80103e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e41:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103e48:	00 00 00 
  p->nread = 0;
80103e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e4e:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103e55:	00 00 00 
  initlock(&p->lock, "pipe");
80103e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e5b:	83 ec 08             	sub    $0x8,%esp
80103e5e:	68 18 86 10 80       	push   $0x80108618
80103e63:	50                   	push   %eax
80103e64:	e8 d1 10 00 00       	call   80104f3a <initlock>
80103e69:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6f:	8b 00                	mov    (%eax),%eax
80103e71:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e77:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7a:	8b 00                	mov    (%eax),%eax
80103e7c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e80:	8b 45 08             	mov    0x8(%ebp),%eax
80103e83:	8b 00                	mov    (%eax),%eax
80103e85:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e89:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8c:	8b 00                	mov    (%eax),%eax
80103e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e91:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e94:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e97:	8b 00                	mov    (%eax),%eax
80103e99:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ea2:	8b 00                	mov    (%eax),%eax
80103ea4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103eab:	8b 00                	mov    (%eax),%eax
80103ead:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103eb4:	8b 00                	mov    (%eax),%eax
80103eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103eb9:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ebc:	b8 00 00 00 00       	mov    $0x0,%eax
80103ec1:	eb 51                	jmp    80103f14 <pipealloc+0x154>

//PAGEBREAK: 20
 bad:
80103ec3:	90                   	nop
80103ec4:	eb 01                	jmp    80103ec7 <pipealloc+0x107>
    goto bad;
80103ec6:	90                   	nop
  if(p)
80103ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ecb:	74 0e                	je     80103edb <pipealloc+0x11b>
    kfree((char*)p);
80103ecd:	83 ec 0c             	sub    $0xc,%esp
80103ed0:	ff 75 f4             	pushl  -0xc(%ebp)
80103ed3:	e8 22 ed ff ff       	call   80102bfa <kfree>
80103ed8:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103edb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ede:	8b 00                	mov    (%eax),%eax
80103ee0:	85 c0                	test   %eax,%eax
80103ee2:	74 11                	je     80103ef5 <pipealloc+0x135>
    fileclose(*f0);
80103ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee7:	8b 00                	mov    (%eax),%eax
80103ee9:	83 ec 0c             	sub    $0xc,%esp
80103eec:	50                   	push   %eax
80103eed:	e8 c3 d1 ff ff       	call   801010b5 <fileclose>
80103ef2:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ef8:	8b 00                	mov    (%eax),%eax
80103efa:	85 c0                	test   %eax,%eax
80103efc:	74 11                	je     80103f0f <pipealloc+0x14f>
    fileclose(*f1);
80103efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f01:	8b 00                	mov    (%eax),%eax
80103f03:	83 ec 0c             	sub    $0xc,%esp
80103f06:	50                   	push   %eax
80103f07:	e8 a9 d1 ff ff       	call   801010b5 <fileclose>
80103f0c:	83 c4 10             	add    $0x10,%esp
  return -1;
80103f0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f14:	c9                   	leave  
80103f15:	c3                   	ret    

80103f16 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103f16:	55                   	push   %ebp
80103f17:	89 e5                	mov    %esp,%ebp
80103f19:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1f:	83 ec 0c             	sub    $0xc,%esp
80103f22:	50                   	push   %eax
80103f23:	e8 34 10 00 00       	call   80104f5c <acquire>
80103f28:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103f2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103f2f:	74 23                	je     80103f54 <pipeclose+0x3e>
    p->writeopen = 0;
80103f31:	8b 45 08             	mov    0x8(%ebp),%eax
80103f34:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103f3b:	00 00 00 
    wakeup(&p->nread);
80103f3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f41:	05 34 02 00 00       	add    $0x234,%eax
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	50                   	push   %eax
80103f4a:	e8 da 0c 00 00       	call   80104c29 <wakeup>
80103f4f:	83 c4 10             	add    $0x10,%esp
80103f52:	eb 21                	jmp    80103f75 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103f54:	8b 45 08             	mov    0x8(%ebp),%eax
80103f57:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103f5e:	00 00 00 
    wakeup(&p->nwrite);
80103f61:	8b 45 08             	mov    0x8(%ebp),%eax
80103f64:	05 38 02 00 00       	add    $0x238,%eax
80103f69:	83 ec 0c             	sub    $0xc,%esp
80103f6c:	50                   	push   %eax
80103f6d:	e8 b7 0c 00 00       	call   80104c29 <wakeup>
80103f72:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103f75:	8b 45 08             	mov    0x8(%ebp),%eax
80103f78:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103f7e:	85 c0                	test   %eax,%eax
80103f80:	75 2c                	jne    80103fae <pipeclose+0x98>
80103f82:	8b 45 08             	mov    0x8(%ebp),%eax
80103f85:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f8b:	85 c0                	test   %eax,%eax
80103f8d:	75 1f                	jne    80103fae <pipeclose+0x98>
    release(&p->lock);
80103f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f92:	83 ec 0c             	sub    $0xc,%esp
80103f95:	50                   	push   %eax
80103f96:	e8 2f 10 00 00       	call   80104fca <release>
80103f9b:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103f9e:	83 ec 0c             	sub    $0xc,%esp
80103fa1:	ff 75 08             	pushl  0x8(%ebp)
80103fa4:	e8 51 ec ff ff       	call   80102bfa <kfree>
80103fa9:	83 c4 10             	add    $0x10,%esp
80103fac:	eb 0f                	jmp    80103fbd <pipeclose+0xa7>
  } else
    release(&p->lock);
80103fae:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb1:	83 ec 0c             	sub    $0xc,%esp
80103fb4:	50                   	push   %eax
80103fb5:	e8 10 10 00 00       	call   80104fca <release>
80103fba:	83 c4 10             	add    $0x10,%esp
}
80103fbd:	90                   	nop
80103fbe:	c9                   	leave  
80103fbf:	c3                   	ret    

80103fc0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	53                   	push   %ebx
80103fc4:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	50                   	push   %eax
80103fce:	e8 89 0f 00 00       	call   80104f5c <acquire>
80103fd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103fd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103fdd:	e9 ad 00 00 00       	jmp    8010408f <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80103fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103feb:	85 c0                	test   %eax,%eax
80103fed:	74 0c                	je     80103ffb <pipewrite+0x3b>
80103fef:	e8 98 02 00 00       	call   8010428c <myproc>
80103ff4:	8b 40 24             	mov    0x24(%eax),%eax
80103ff7:	85 c0                	test   %eax,%eax
80103ff9:	74 19                	je     80104014 <pipewrite+0x54>
        release(&p->lock);
80103ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	50                   	push   %eax
80104002:	e8 c3 0f 00 00       	call   80104fca <release>
80104007:	83 c4 10             	add    $0x10,%esp
        return -1;
8010400a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010400f:	e9 a9 00 00 00       	jmp    801040bd <pipewrite+0xfd>
      }
      wakeup(&p->nread);
80104014:	8b 45 08             	mov    0x8(%ebp),%eax
80104017:	05 34 02 00 00       	add    $0x234,%eax
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	50                   	push   %eax
80104020:	e8 04 0c 00 00       	call   80104c29 <wakeup>
80104025:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104028:	8b 45 08             	mov    0x8(%ebp),%eax
8010402b:	8b 55 08             	mov    0x8(%ebp),%edx
8010402e:	81 c2 38 02 00 00    	add    $0x238,%edx
80104034:	83 ec 08             	sub    $0x8,%esp
80104037:	50                   	push   %eax
80104038:	52                   	push   %edx
80104039:	e8 05 0b 00 00       	call   80104b43 <sleep>
8010403e:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104041:	8b 45 08             	mov    0x8(%ebp),%eax
80104044:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010404a:	8b 45 08             	mov    0x8(%ebp),%eax
8010404d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104053:	05 00 02 00 00       	add    $0x200,%eax
80104058:	39 c2                	cmp    %eax,%edx
8010405a:	74 86                	je     80103fe2 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010405c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010405f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104062:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104065:	8b 45 08             	mov    0x8(%ebp),%eax
80104068:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010406e:	8d 48 01             	lea    0x1(%eax),%ecx
80104071:	8b 55 08             	mov    0x8(%ebp),%edx
80104074:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010407a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010407f:	89 c1                	mov    %eax,%ecx
80104081:	0f b6 13             	movzbl (%ebx),%edx
80104084:	8b 45 08             	mov    0x8(%ebp),%eax
80104087:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
8010408b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010408f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104092:	3b 45 10             	cmp    0x10(%ebp),%eax
80104095:	7c aa                	jl     80104041 <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104097:	8b 45 08             	mov    0x8(%ebp),%eax
8010409a:	05 34 02 00 00       	add    $0x234,%eax
8010409f:	83 ec 0c             	sub    $0xc,%esp
801040a2:	50                   	push   %eax
801040a3:	e8 81 0b 00 00       	call   80104c29 <wakeup>
801040a8:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801040ab:	8b 45 08             	mov    0x8(%ebp),%eax
801040ae:	83 ec 0c             	sub    $0xc,%esp
801040b1:	50                   	push   %eax
801040b2:	e8 13 0f 00 00       	call   80104fca <release>
801040b7:	83 c4 10             	add    $0x10,%esp
  return n;
801040ba:	8b 45 10             	mov    0x10(%ebp),%eax
}
801040bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c0:	c9                   	leave  
801040c1:	c3                   	ret    

801040c2 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801040c2:	55                   	push   %ebp
801040c3:	89 e5                	mov    %esp,%ebp
801040c5:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801040c8:	8b 45 08             	mov    0x8(%ebp),%eax
801040cb:	83 ec 0c             	sub    $0xc,%esp
801040ce:	50                   	push   %eax
801040cf:	e8 88 0e 00 00       	call   80104f5c <acquire>
801040d4:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801040d7:	eb 3e                	jmp    80104117 <piperead+0x55>
    if(myproc()->killed){
801040d9:	e8 ae 01 00 00       	call   8010428c <myproc>
801040de:	8b 40 24             	mov    0x24(%eax),%eax
801040e1:	85 c0                	test   %eax,%eax
801040e3:	74 19                	je     801040fe <piperead+0x3c>
      release(&p->lock);
801040e5:	8b 45 08             	mov    0x8(%ebp),%eax
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	50                   	push   %eax
801040ec:	e8 d9 0e 00 00       	call   80104fca <release>
801040f1:	83 c4 10             	add    $0x10,%esp
      return -1;
801040f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040f9:	e9 be 00 00 00       	jmp    801041bc <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801040fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104101:	8b 55 08             	mov    0x8(%ebp),%edx
80104104:	81 c2 34 02 00 00    	add    $0x234,%edx
8010410a:	83 ec 08             	sub    $0x8,%esp
8010410d:	50                   	push   %eax
8010410e:	52                   	push   %edx
8010410f:	e8 2f 0a 00 00       	call   80104b43 <sleep>
80104114:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104117:	8b 45 08             	mov    0x8(%ebp),%eax
8010411a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104120:	8b 45 08             	mov    0x8(%ebp),%eax
80104123:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104129:	39 c2                	cmp    %eax,%edx
8010412b:	75 0d                	jne    8010413a <piperead+0x78>
8010412d:	8b 45 08             	mov    0x8(%ebp),%eax
80104130:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104136:	85 c0                	test   %eax,%eax
80104138:	75 9f                	jne    801040d9 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010413a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104141:	eb 48                	jmp    8010418b <piperead+0xc9>
    if(p->nread == p->nwrite)
80104143:	8b 45 08             	mov    0x8(%ebp),%eax
80104146:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010414c:	8b 45 08             	mov    0x8(%ebp),%eax
8010414f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104155:	39 c2                	cmp    %eax,%edx
80104157:	74 3c                	je     80104195 <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104159:	8b 45 08             	mov    0x8(%ebp),%eax
8010415c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104162:	8d 48 01             	lea    0x1(%eax),%ecx
80104165:	8b 55 08             	mov    0x8(%ebp),%edx
80104168:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010416e:	25 ff 01 00 00       	and    $0x1ff,%eax
80104173:	89 c1                	mov    %eax,%ecx
80104175:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104178:	8b 45 0c             	mov    0xc(%ebp),%eax
8010417b:	01 c2                	add    %eax,%edx
8010417d:	8b 45 08             	mov    0x8(%ebp),%eax
80104180:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80104185:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104187:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010418b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418e:	3b 45 10             	cmp    0x10(%ebp),%eax
80104191:	7c b0                	jl     80104143 <piperead+0x81>
80104193:	eb 01                	jmp    80104196 <piperead+0xd4>
      break;
80104195:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	05 38 02 00 00       	add    $0x238,%eax
8010419e:	83 ec 0c             	sub    $0xc,%esp
801041a1:	50                   	push   %eax
801041a2:	e8 82 0a 00 00       	call   80104c29 <wakeup>
801041a7:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801041aa:	8b 45 08             	mov    0x8(%ebp),%eax
801041ad:	83 ec 0c             	sub    $0xc,%esp
801041b0:	50                   	push   %eax
801041b1:	e8 14 0e 00 00       	call   80104fca <release>
801041b6:	83 c4 10             	add    $0x10,%esp
  return i;
801041b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801041bc:	c9                   	leave  
801041bd:	c3                   	ret    

801041be <readeflags>:
{
801041be:	55                   	push   %ebp
801041bf:	89 e5                	mov    %esp,%ebp
801041c1:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041c4:	9c                   	pushf  
801041c5:	58                   	pop    %eax
801041c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801041c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801041cc:	c9                   	leave  
801041cd:	c3                   	ret    

801041ce <sti>:
{
801041ce:	55                   	push   %ebp
801041cf:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801041d1:	fb                   	sti    
}
801041d2:	90                   	nop
801041d3:	5d                   	pop    %ebp
801041d4:	c3                   	ret    

801041d5 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801041d5:	55                   	push   %ebp
801041d6:	89 e5                	mov    %esp,%ebp
801041d8:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801041db:	83 ec 08             	sub    $0x8,%esp
801041de:	68 20 86 10 80       	push   $0x80108620
801041e3:	68 a0 3d 11 80       	push   $0x80113da0
801041e8:	e8 4d 0d 00 00       	call   80104f3a <initlock>
801041ed:	83 c4 10             	add    $0x10,%esp
}
801041f0:	90                   	nop
801041f1:	c9                   	leave  
801041f2:	c3                   	ret    

801041f3 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801041f3:	55                   	push   %ebp
801041f4:	89 e5                	mov    %esp,%ebp
801041f6:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801041f9:	e8 16 00 00 00       	call   80104214 <mycpu>
801041fe:	89 c2                	mov    %eax,%edx
80104200:	b8 00 38 11 80       	mov    $0x80113800,%eax
80104205:	29 c2                	sub    %eax,%edx
80104207:	89 d0                	mov    %edx,%eax
80104209:	c1 f8 04             	sar    $0x4,%eax
8010420c:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104212:	c9                   	leave  
80104213:	c3                   	ret    

80104214 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010421a:	e8 9f ff ff ff       	call   801041be <readeflags>
8010421f:	25 00 02 00 00       	and    $0x200,%eax
80104224:	85 c0                	test   %eax,%eax
80104226:	74 0d                	je     80104235 <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 28 86 10 80       	push   $0x80108628
80104230:	e8 67 c3 ff ff       	call   8010059c <panic>
  
  apicid = lapicid();
80104235:	e8 b0 ed ff ff       	call   80102fea <lapicid>
8010423a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010423d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104244:	eb 2d                	jmp    80104273 <mycpu+0x5f>
    if (cpus[i].apicid == apicid)
80104246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104249:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010424f:	05 00 38 11 80       	add    $0x80113800,%eax
80104254:	0f b6 00             	movzbl (%eax),%eax
80104257:	0f b6 c0             	movzbl %al,%eax
8010425a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010425d:	75 10                	jne    8010426f <mycpu+0x5b>
      return &cpus[i];
8010425f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104262:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104268:	05 00 38 11 80       	add    $0x80113800,%eax
8010426d:	eb 1b                	jmp    8010428a <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
8010426f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104273:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80104278:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010427b:	7c c9                	jl     80104246 <mycpu+0x32>
  }
  panic("unknown apicid\n");
8010427d:	83 ec 0c             	sub    $0xc,%esp
80104280:	68 4e 86 10 80       	push   $0x8010864e
80104285:	e8 12 c3 ff ff       	call   8010059c <panic>
}
8010428a:	c9                   	leave  
8010428b:	c3                   	ret    

8010428c <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
8010428c:	55                   	push   %ebp
8010428d:	89 e5                	mov    %esp,%ebp
8010428f:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104292:	e8 30 0e 00 00       	call   801050c7 <pushcli>
  c = mycpu();
80104297:	e8 78 ff ff ff       	call   80104214 <mycpu>
8010429c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
8010429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801042a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801042ab:	e8 65 0e 00 00       	call   80105115 <popcli>
  return p;
801042b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801042b3:	c9                   	leave  
801042b4:	c3                   	ret    

801042b5 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801042b5:	55                   	push   %ebp
801042b6:	89 e5                	mov    %esp,%ebp
801042b8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801042bb:	83 ec 0c             	sub    $0xc,%esp
801042be:	68 a0 3d 11 80       	push   $0x80113da0
801042c3:	e8 94 0c 00 00       	call   80104f5c <acquire>
801042c8:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042cb:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801042d2:	eb 0e                	jmp    801042e2 <allocproc+0x2d>
    if(p->state == UNUSED)
801042d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d7:	8b 40 0c             	mov    0xc(%eax),%eax
801042da:	85 c0                	test   %eax,%eax
801042dc:	74 27                	je     80104305 <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042de:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801042e2:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
801042e9:	72 e9                	jb     801042d4 <allocproc+0x1f>
      goto found;

  release(&ptable.lock);
801042eb:	83 ec 0c             	sub    $0xc,%esp
801042ee:	68 a0 3d 11 80       	push   $0x80113da0
801042f3:	e8 d2 0c 00 00       	call   80104fca <release>
801042f8:	83 c4 10             	add    $0x10,%esp
  return 0;
801042fb:	b8 00 00 00 00       	mov    $0x0,%eax
80104300:	e9 b4 00 00 00       	jmp    801043b9 <allocproc+0x104>
      goto found;
80104305:	90                   	nop

found:
  p->state = EMBRYO;
80104306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104309:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104310:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104315:	8d 50 01             	lea    0x1(%eax),%edx
80104318:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
8010431e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104321:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104324:	83 ec 0c             	sub    $0xc,%esp
80104327:	68 a0 3d 11 80       	push   $0x80113da0
8010432c:	e8 99 0c 00 00       	call   80104fca <release>
80104331:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104334:	e8 5b e9 ff ff       	call   80102c94 <kalloc>
80104339:	89 c2                	mov    %eax,%edx
8010433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433e:	89 50 08             	mov    %edx,0x8(%eax)
80104341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104344:	8b 40 08             	mov    0x8(%eax),%eax
80104347:	85 c0                	test   %eax,%eax
80104349:	75 11                	jne    8010435c <allocproc+0xa7>
    p->state = UNUSED;
8010434b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104355:	b8 00 00 00 00       	mov    $0x0,%eax
8010435a:	eb 5d                	jmp    801043b9 <allocproc+0x104>
  }
  sp = p->kstack + KSTACKSIZE;
8010435c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435f:	8b 40 08             	mov    0x8(%eax),%eax
80104362:	05 00 10 00 00       	add    $0x1000,%eax
80104367:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010436a:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010436e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104371:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104374:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104377:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010437b:	ba 62 65 10 80       	mov    $0x80106562,%edx
80104380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104383:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104385:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010438f:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104395:	8b 40 1c             	mov    0x1c(%eax),%eax
80104398:	83 ec 04             	sub    $0x4,%esp
8010439b:	6a 14                	push   $0x14
8010439d:	6a 00                	push   $0x0
8010439f:	50                   	push   %eax
801043a0:	e8 2e 0e 00 00       	call   801051d3 <memset>
801043a5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801043a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ab:	8b 40 1c             	mov    0x1c(%eax),%eax
801043ae:	ba fd 4a 10 80       	mov    $0x80104afd,%edx
801043b3:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801043b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043b9:	c9                   	leave  
801043ba:	c3                   	ret    

801043bb <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801043bb:	55                   	push   %ebp
801043bc:	89 e5                	mov    %esp,%ebp
801043be:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801043c1:	e8 ef fe ff ff       	call   801042b5 <allocproc>
801043c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
801043c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cc:	a3 20 b6 10 80       	mov    %eax,0x8010b620
  if((p->pgdir = setupkvm()) == 0)
801043d1:	e8 d3 36 00 00       	call   80107aa9 <setupkvm>
801043d6:	89 c2                	mov    %eax,%edx
801043d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043db:	89 50 04             	mov    %edx,0x4(%eax)
801043de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e1:	8b 40 04             	mov    0x4(%eax),%eax
801043e4:	85 c0                	test   %eax,%eax
801043e6:	75 0d                	jne    801043f5 <userinit+0x3a>
    panic("userinit: out of memory?");
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	68 5e 86 10 80       	push   $0x8010865e
801043f0:	e8 a7 c1 ff ff       	call   8010059c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801043f5:	ba 2c 00 00 00       	mov    $0x2c,%edx
801043fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043fd:	8b 40 04             	mov    0x4(%eax),%eax
80104400:	83 ec 04             	sub    $0x4,%esp
80104403:	52                   	push   %edx
80104404:	68 c0 b4 10 80       	push   $0x8010b4c0
80104409:	50                   	push   %eax
8010440a:	e8 05 39 00 00       	call   80107d14 <inituvm>
8010440f:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104415:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010441b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441e:	8b 40 18             	mov    0x18(%eax),%eax
80104421:	83 ec 04             	sub    $0x4,%esp
80104424:	6a 4c                	push   $0x4c
80104426:	6a 00                	push   $0x0
80104428:	50                   	push   %eax
80104429:	e8 a5 0d 00 00       	call   801051d3 <memset>
8010442e:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104431:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104434:	8b 40 18             	mov    0x18(%eax),%eax
80104437:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010443d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104440:	8b 40 18             	mov    0x18(%eax),%eax
80104443:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444c:	8b 50 18             	mov    0x18(%eax),%edx
8010444f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104452:	8b 40 18             	mov    0x18(%eax),%eax
80104455:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104459:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104460:	8b 50 18             	mov    0x18(%eax),%edx
80104463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104466:	8b 40 18             	mov    0x18(%eax),%eax
80104469:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010446d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104474:	8b 40 18             	mov    0x18(%eax),%eax
80104477:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010447e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104481:	8b 40 18             	mov    0x18(%eax),%eax
80104484:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010448b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448e:	8b 40 18             	mov    0x18(%eax),%eax
80104491:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449b:	83 c0 6c             	add    $0x6c,%eax
8010449e:	83 ec 04             	sub    $0x4,%esp
801044a1:	6a 10                	push   $0x10
801044a3:	68 77 86 10 80       	push   $0x80108677
801044a8:	50                   	push   %eax
801044a9:	e8 28 0f 00 00       	call   801053d6 <safestrcpy>
801044ae:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801044b1:	83 ec 0c             	sub    $0xc,%esp
801044b4:	68 80 86 10 80       	push   $0x80108680
801044b9:	e8 91 e0 ff ff       	call   8010254f <namei>
801044be:	83 c4 10             	add    $0x10,%esp
801044c1:	89 c2                	mov    %eax,%edx
801044c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c6:	89 50 68             	mov    %edx,0x68(%eax)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801044c9:	83 ec 0c             	sub    $0xc,%esp
801044cc:	68 a0 3d 11 80       	push   $0x80113da0
801044d1:	e8 86 0a 00 00       	call   80104f5c <acquire>
801044d6:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
801044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801044e3:	83 ec 0c             	sub    $0xc,%esp
801044e6:	68 a0 3d 11 80       	push   $0x80113da0
801044eb:	e8 da 0a 00 00       	call   80104fca <release>
801044f0:	83 c4 10             	add    $0x10,%esp
}
801044f3:	90                   	nop
801044f4:	c9                   	leave  
801044f5:	c3                   	ret    

801044f6 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801044f6:	55                   	push   %ebp
801044f7:	89 e5                	mov    %esp,%ebp
801044f9:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
801044fc:	e8 8b fd ff ff       	call   8010428c <myproc>
80104501:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104504:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104507:	8b 00                	mov    (%eax),%eax
80104509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010450c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104510:	7e 2e                	jle    80104540 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104512:	8b 55 08             	mov    0x8(%ebp),%edx
80104515:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104518:	01 c2                	add    %eax,%edx
8010451a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010451d:	8b 40 04             	mov    0x4(%eax),%eax
80104520:	83 ec 04             	sub    $0x4,%esp
80104523:	52                   	push   %edx
80104524:	ff 75 f4             	pushl  -0xc(%ebp)
80104527:	50                   	push   %eax
80104528:	e8 24 39 00 00       	call   80107e51 <allocuvm>
8010452d:	83 c4 10             	add    $0x10,%esp
80104530:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104537:	75 3b                	jne    80104574 <growproc+0x7e>
      return -1;
80104539:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453e:	eb 4f                	jmp    8010458f <growproc+0x99>
  } else if(n < 0){
80104540:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104544:	79 2e                	jns    80104574 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104546:	8b 55 08             	mov    0x8(%ebp),%edx
80104549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454c:	01 c2                	add    %eax,%edx
8010454e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104551:	8b 40 04             	mov    0x4(%eax),%eax
80104554:	83 ec 04             	sub    $0x4,%esp
80104557:	52                   	push   %edx
80104558:	ff 75 f4             	pushl  -0xc(%ebp)
8010455b:	50                   	push   %eax
8010455c:	e8 f5 39 00 00       	call   80107f56 <deallocuvm>
80104561:	83 c4 10             	add    $0x10,%esp
80104564:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010456b:	75 07                	jne    80104574 <growproc+0x7e>
      return -1;
8010456d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104572:	eb 1b                	jmp    8010458f <growproc+0x99>
  }
  curproc->sz = sz;
80104574:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104577:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010457a:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
8010457c:	83 ec 0c             	sub    $0xc,%esp
8010457f:	ff 75 f0             	pushl  -0x10(%ebp)
80104582:	e8 ec 35 00 00       	call   80107b73 <switchuvm>
80104587:	83 c4 10             	add    $0x10,%esp
  return 0;
8010458a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010458f:	c9                   	leave  
80104590:	c3                   	ret    

80104591 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104591:	55                   	push   %ebp
80104592:	89 e5                	mov    %esp,%ebp
80104594:	57                   	push   %edi
80104595:	56                   	push   %esi
80104596:	53                   	push   %ebx
80104597:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
8010459a:	e8 ed fc ff ff       	call   8010428c <myproc>
8010459f:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801045a2:	e8 0e fd ff ff       	call   801042b5 <allocproc>
801045a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801045aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801045ae:	75 0a                	jne    801045ba <fork+0x29>
    return -1;
801045b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045b5:	e9 4e 01 00 00       	jmp    80104708 <fork+0x177>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801045ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045bd:	8b 10                	mov    (%eax),%edx
801045bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045c2:	8b 40 04             	mov    0x4(%eax),%eax
801045c5:	83 ec 08             	sub    $0x8,%esp
801045c8:	52                   	push   %edx
801045c9:	50                   	push   %eax
801045ca:	e8 25 3b 00 00       	call   801080f4 <copyuvm>
801045cf:	83 c4 10             	add    $0x10,%esp
801045d2:	89 c2                	mov    %eax,%edx
801045d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045d7:	89 50 04             	mov    %edx,0x4(%eax)
801045da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045dd:	8b 40 04             	mov    0x4(%eax),%eax
801045e0:	85 c0                	test   %eax,%eax
801045e2:	75 30                	jne    80104614 <fork+0x83>
    kfree(np->kstack);
801045e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045e7:	8b 40 08             	mov    0x8(%eax),%eax
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	50                   	push   %eax
801045ee:	e8 07 e6 ff ff       	call   80102bfa <kfree>
801045f3:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801045f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104600:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104603:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010460a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010460f:	e9 f4 00 00 00       	jmp    80104708 <fork+0x177>
  }
  np->sz = curproc->sz;
80104614:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104617:	8b 10                	mov    (%eax),%edx
80104619:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010461c:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010461e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104621:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104624:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104627:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010462a:	8b 48 18             	mov    0x18(%eax),%ecx
8010462d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104630:	8b 40 18             	mov    0x18(%eax),%eax
80104633:	89 c2                	mov    %eax,%edx
80104635:	89 cb                	mov    %ecx,%ebx
80104637:	b8 13 00 00 00       	mov    $0x13,%eax
8010463c:	89 d7                	mov    %edx,%edi
8010463e:	89 de                	mov    %ebx,%esi
80104640:	89 c1                	mov    %eax,%ecx
80104642:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104644:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104647:	8b 40 18             	mov    0x18(%eax),%eax
8010464a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104651:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104658:	eb 3d                	jmp    80104697 <fork+0x106>
    if(curproc->ofile[i])
8010465a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010465d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104660:	83 c2 08             	add    $0x8,%edx
80104663:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104667:	85 c0                	test   %eax,%eax
80104669:	74 28                	je     80104693 <fork+0x102>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010466b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010466e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104671:	83 c2 08             	add    $0x8,%edx
80104674:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	50                   	push   %eax
8010467c:	e8 e3 c9 ff ff       	call   80101064 <filedup>
80104681:	83 c4 10             	add    $0x10,%esp
80104684:	89 c1                	mov    %eax,%ecx
80104686:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104689:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010468c:	83 c2 08             	add    $0x8,%edx
8010468f:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  for(i = 0; i < NOFILE; i++)
80104693:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104697:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010469b:	7e bd                	jle    8010465a <fork+0xc9>
  np->cwd = idup(curproc->cwd);
8010469d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046a0:	8b 40 68             	mov    0x68(%eax),%eax
801046a3:	83 ec 0c             	sub    $0xc,%esp
801046a6:	50                   	push   %eax
801046a7:	e8 2e d3 ff ff       	call   801019da <idup>
801046ac:	83 c4 10             	add    $0x10,%esp
801046af:	89 c2                	mov    %eax,%edx
801046b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046b4:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801046b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046ba:	8d 50 6c             	lea    0x6c(%eax),%edx
801046bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046c0:	83 c0 6c             	add    $0x6c,%eax
801046c3:	83 ec 04             	sub    $0x4,%esp
801046c6:	6a 10                	push   $0x10
801046c8:	52                   	push   %edx
801046c9:	50                   	push   %eax
801046ca:	e8 07 0d 00 00       	call   801053d6 <safestrcpy>
801046cf:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801046d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046d5:	8b 40 10             	mov    0x10(%eax),%eax
801046d8:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
801046db:	83 ec 0c             	sub    $0xc,%esp
801046de:	68 a0 3d 11 80       	push   $0x80113da0
801046e3:	e8 74 08 00 00       	call   80104f5c <acquire>
801046e8:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
801046eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046ee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801046f5:	83 ec 0c             	sub    $0xc,%esp
801046f8:	68 a0 3d 11 80       	push   $0x80113da0
801046fd:	e8 c8 08 00 00       	call   80104fca <release>
80104702:	83 c4 10             	add    $0x10,%esp

  return pid;
80104705:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104708:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010470b:	5b                   	pop    %ebx
8010470c:	5e                   	pop    %esi
8010470d:	5f                   	pop    %edi
8010470e:	5d                   	pop    %ebp
8010470f:	c3                   	ret    

80104710 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104716:	e8 71 fb ff ff       	call   8010428c <myproc>
8010471b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010471e:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104723:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104726:	75 0d                	jne    80104735 <exit+0x25>
    panic("init exiting");
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	68 82 86 10 80       	push   $0x80108682
80104730:	e8 67 be ff ff       	call   8010059c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104735:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010473c:	eb 3f                	jmp    8010477d <exit+0x6d>
    if(curproc->ofile[fd]){
8010473e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104741:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104744:	83 c2 08             	add    $0x8,%edx
80104747:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010474b:	85 c0                	test   %eax,%eax
8010474d:	74 2a                	je     80104779 <exit+0x69>
      fileclose(curproc->ofile[fd]);
8010474f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104752:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104755:	83 c2 08             	add    $0x8,%edx
80104758:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010475c:	83 ec 0c             	sub    $0xc,%esp
8010475f:	50                   	push   %eax
80104760:	e8 50 c9 ff ff       	call   801010b5 <fileclose>
80104765:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104768:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010476b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010476e:	83 c2 08             	add    $0x8,%edx
80104771:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104778:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104779:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010477d:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104781:	7e bb                	jle    8010473e <exit+0x2e>
    }
  }

  begin_op();
80104783:	e8 ae ed ff ff       	call   80103536 <begin_op>
  iput(curproc->cwd);
80104788:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010478b:	8b 40 68             	mov    0x68(%eax),%eax
8010478e:	83 ec 0c             	sub    $0xc,%esp
80104791:	50                   	push   %eax
80104792:	e8 de d3 ff ff       	call   80101b75 <iput>
80104797:	83 c4 10             	add    $0x10,%esp
  end_op();
8010479a:	e8 23 ee ff ff       	call   801035c2 <end_op>
  curproc->cwd = 0;
8010479f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047a2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801047a9:	83 ec 0c             	sub    $0xc,%esp
801047ac:	68 a0 3d 11 80       	push   $0x80113da0
801047b1:	e8 a6 07 00 00       	call   80104f5c <acquire>
801047b6:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801047b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047bc:	8b 40 14             	mov    0x14(%eax),%eax
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	50                   	push   %eax
801047c3:	e8 22 04 00 00       	call   80104bea <wakeup1>
801047c8:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047cb:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801047d2:	eb 37                	jmp    8010480b <exit+0xfb>
    if(p->parent == curproc){
801047d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d7:	8b 40 14             	mov    0x14(%eax),%eax
801047da:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801047dd:	75 28                	jne    80104807 <exit+0xf7>
      p->parent = initproc;
801047df:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
801047e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e8:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801047eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ee:	8b 40 0c             	mov    0xc(%eax),%eax
801047f1:	83 f8 05             	cmp    $0x5,%eax
801047f4:	75 11                	jne    80104807 <exit+0xf7>
        wakeup1(initproc);
801047f6:	a1 20 b6 10 80       	mov    0x8010b620,%eax
801047fb:	83 ec 0c             	sub    $0xc,%esp
801047fe:	50                   	push   %eax
801047ff:	e8 e6 03 00 00       	call   80104bea <wakeup1>
80104804:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104807:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010480b:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104812:	72 c0                	jb     801047d4 <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104814:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104817:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010481e:	e8 e5 01 00 00       	call   80104a08 <sched>
  panic("zombie exit");
80104823:	83 ec 0c             	sub    $0xc,%esp
80104826:	68 8f 86 10 80       	push   $0x8010868f
8010482b:	e8 6c bd ff ff       	call   8010059c <panic>

80104830 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104836:	e8 51 fa ff ff       	call   8010428c <myproc>
8010483b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010483e:	83 ec 0c             	sub    $0xc,%esp
80104841:	68 a0 3d 11 80       	push   $0x80113da0
80104846:	e8 11 07 00 00       	call   80104f5c <acquire>
8010484b:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010484e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104855:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
8010485c:	e9 a1 00 00 00       	jmp    80104902 <wait+0xd2>
      if(p->parent != curproc)
80104861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104864:	8b 40 14             	mov    0x14(%eax),%eax
80104867:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010486a:	0f 85 8d 00 00 00    	jne    801048fd <wait+0xcd>
        continue;
      havekids = 1;
80104870:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487a:	8b 40 0c             	mov    0xc(%eax),%eax
8010487d:	83 f8 05             	cmp    $0x5,%eax
80104880:	75 7c                	jne    801048fe <wait+0xce>
        // Found one.
        pid = p->pid;
80104882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104885:	8b 40 10             	mov    0x10(%eax),%eax
80104888:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010488b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010488e:	8b 40 08             	mov    0x8(%eax),%eax
80104891:	83 ec 0c             	sub    $0xc,%esp
80104894:	50                   	push   %eax
80104895:	e8 60 e3 ff ff       	call   80102bfa <kfree>
8010489a:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010489d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801048a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048aa:	8b 40 04             	mov    0x4(%eax),%eax
801048ad:	83 ec 0c             	sub    $0xc,%esp
801048b0:	50                   	push   %eax
801048b1:	e8 64 37 00 00       	call   8010801a <freevm>
801048b6:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801048b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048bc:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801048c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801048cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d0:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801048de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	68 a0 3d 11 80       	push   $0x80113da0
801048f0:	e8 d5 06 00 00       	call   80104fca <release>
801048f5:	83 c4 10             	add    $0x10,%esp
        return pid;
801048f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048fb:	eb 51                	jmp    8010494e <wait+0x11e>
        continue;
801048fd:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048fe:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104902:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104909:	0f 82 52 ff ff ff    	jb     80104861 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010490f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104913:	74 0a                	je     8010491f <wait+0xef>
80104915:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104918:	8b 40 24             	mov    0x24(%eax),%eax
8010491b:	85 c0                	test   %eax,%eax
8010491d:	74 17                	je     80104936 <wait+0x106>
      release(&ptable.lock);
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	68 a0 3d 11 80       	push   $0x80113da0
80104927:	e8 9e 06 00 00       	call   80104fca <release>
8010492c:	83 c4 10             	add    $0x10,%esp
      return -1;
8010492f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104934:	eb 18                	jmp    8010494e <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104936:	83 ec 08             	sub    $0x8,%esp
80104939:	68 a0 3d 11 80       	push   $0x80113da0
8010493e:	ff 75 ec             	pushl  -0x14(%ebp)
80104941:	e8 fd 01 00 00       	call   80104b43 <sleep>
80104946:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104949:	e9 00 ff ff ff       	jmp    8010484e <wait+0x1e>
  }
}
8010494e:	c9                   	leave  
8010494f:	c3                   	ret    

80104950 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104956:	e8 b9 f8 ff ff       	call   80104214 <mycpu>
8010495b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
8010495e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104961:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104968:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
8010496b:	e8 5e f8 ff ff       	call   801041ce <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104970:	83 ec 0c             	sub    $0xc,%esp
80104973:	68 a0 3d 11 80       	push   $0x80113da0
80104978:	e8 df 05 00 00       	call   80104f5c <acquire>
8010497d:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104980:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104987:	eb 61                	jmp    801049ea <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010498c:	8b 40 0c             	mov    0xc(%eax),%eax
8010498f:	83 f8 03             	cmp    $0x3,%eax
80104992:	75 51                	jne    801049e5 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104997:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010499a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	ff 75 f4             	pushl  -0xc(%ebp)
801049a6:	e8 c8 31 00 00       	call   80107b73 <switchuvm>
801049ab:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801049ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b1:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801049b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049bb:	8b 40 1c             	mov    0x1c(%eax),%eax
801049be:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049c1:	83 c2 04             	add    $0x4,%edx
801049c4:	83 ec 08             	sub    $0x8,%esp
801049c7:	50                   	push   %eax
801049c8:	52                   	push   %edx
801049c9:	e8 79 0a 00 00       	call   80105447 <swtch>
801049ce:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801049d1:	e8 84 31 00 00       	call   80107b5a <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801049d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049d9:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801049e0:	00 00 00 
801049e3:	eb 01                	jmp    801049e6 <scheduler+0x96>
        continue;
801049e5:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049e6:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801049ea:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
801049f1:	72 96                	jb     80104989 <scheduler+0x39>
    }
    release(&ptable.lock);
801049f3:	83 ec 0c             	sub    $0xc,%esp
801049f6:	68 a0 3d 11 80       	push   $0x80113da0
801049fb:	e8 ca 05 00 00       	call   80104fca <release>
80104a00:	83 c4 10             	add    $0x10,%esp
    sti();
80104a03:	e9 63 ff ff ff       	jmp    8010496b <scheduler+0x1b>

80104a08 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104a08:	55                   	push   %ebp
80104a09:	89 e5                	mov    %esp,%ebp
80104a0b:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104a0e:	e8 79 f8 ff ff       	call   8010428c <myproc>
80104a13:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104a16:	83 ec 0c             	sub    $0xc,%esp
80104a19:	68 a0 3d 11 80       	push   $0x80113da0
80104a1e:	e8 73 06 00 00       	call   80105096 <holding>
80104a23:	83 c4 10             	add    $0x10,%esp
80104a26:	85 c0                	test   %eax,%eax
80104a28:	75 0d                	jne    80104a37 <sched+0x2f>
    panic("sched ptable.lock");
80104a2a:	83 ec 0c             	sub    $0xc,%esp
80104a2d:	68 9b 86 10 80       	push   $0x8010869b
80104a32:	e8 65 bb ff ff       	call   8010059c <panic>
  if(mycpu()->ncli != 1)
80104a37:	e8 d8 f7 ff ff       	call   80104214 <mycpu>
80104a3c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a42:	83 f8 01             	cmp    $0x1,%eax
80104a45:	74 0d                	je     80104a54 <sched+0x4c>
    panic("sched locks");
80104a47:	83 ec 0c             	sub    $0xc,%esp
80104a4a:	68 ad 86 10 80       	push   $0x801086ad
80104a4f:	e8 48 bb ff ff       	call   8010059c <panic>
  if(p->state == RUNNING)
80104a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a57:	8b 40 0c             	mov    0xc(%eax),%eax
80104a5a:	83 f8 04             	cmp    $0x4,%eax
80104a5d:	75 0d                	jne    80104a6c <sched+0x64>
    panic("sched running");
80104a5f:	83 ec 0c             	sub    $0xc,%esp
80104a62:	68 b9 86 10 80       	push   $0x801086b9
80104a67:	e8 30 bb ff ff       	call   8010059c <panic>
  if(readeflags()&FL_IF)
80104a6c:	e8 4d f7 ff ff       	call   801041be <readeflags>
80104a71:	25 00 02 00 00       	and    $0x200,%eax
80104a76:	85 c0                	test   %eax,%eax
80104a78:	74 0d                	je     80104a87 <sched+0x7f>
    panic("sched interruptible");
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 c7 86 10 80       	push   $0x801086c7
80104a82:	e8 15 bb ff ff       	call   8010059c <panic>
  intena = mycpu()->intena;
80104a87:	e8 88 f7 ff ff       	call   80104214 <mycpu>
80104a8c:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104a95:	e8 7a f7 ff ff       	call   80104214 <mycpu>
80104a9a:	8b 40 04             	mov    0x4(%eax),%eax
80104a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aa0:	83 c2 1c             	add    $0x1c,%edx
80104aa3:	83 ec 08             	sub    $0x8,%esp
80104aa6:	50                   	push   %eax
80104aa7:	52                   	push   %edx
80104aa8:	e8 9a 09 00 00       	call   80105447 <swtch>
80104aad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104ab0:	e8 5f f7 ff ff       	call   80104214 <mycpu>
80104ab5:	89 c2                	mov    %eax,%edx
80104ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aba:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
}
80104ac0:	90                   	nop
80104ac1:	c9                   	leave  
80104ac2:	c3                   	ret    

80104ac3 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104ac3:	55                   	push   %ebp
80104ac4:	89 e5                	mov    %esp,%ebp
80104ac6:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104ac9:	83 ec 0c             	sub    $0xc,%esp
80104acc:	68 a0 3d 11 80       	push   $0x80113da0
80104ad1:	e8 86 04 00 00       	call   80104f5c <acquire>
80104ad6:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104ad9:	e8 ae f7 ff ff       	call   8010428c <myproc>
80104ade:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104ae5:	e8 1e ff ff ff       	call   80104a08 <sched>
  release(&ptable.lock);
80104aea:	83 ec 0c             	sub    $0xc,%esp
80104aed:	68 a0 3d 11 80       	push   $0x80113da0
80104af2:	e8 d3 04 00 00       	call   80104fca <release>
80104af7:	83 c4 10             	add    $0x10,%esp
}
80104afa:	90                   	nop
80104afb:	c9                   	leave  
80104afc:	c3                   	ret    

80104afd <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104afd:	55                   	push   %ebp
80104afe:	89 e5                	mov    %esp,%ebp
80104b00:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b03:	83 ec 0c             	sub    $0xc,%esp
80104b06:	68 a0 3d 11 80       	push   $0x80113da0
80104b0b:	e8 ba 04 00 00       	call   80104fca <release>
80104b10:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104b13:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104b18:	85 c0                	test   %eax,%eax
80104b1a:	74 24                	je     80104b40 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104b1c:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80104b23:	00 00 00 
    iinit(ROOTDEV);
80104b26:	83 ec 0c             	sub    $0xc,%esp
80104b29:	6a 01                	push   $0x1
80104b2b:	e8 72 cb ff ff       	call   801016a2 <iinit>
80104b30:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104b33:	83 ec 0c             	sub    $0xc,%esp
80104b36:	6a 01                	push   $0x1
80104b38:	e8 db e7 ff ff       	call   80103318 <initlog>
80104b3d:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104b40:	90                   	nop
80104b41:	c9                   	leave  
80104b42:	c3                   	ret    

80104b43 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104b43:	55                   	push   %ebp
80104b44:	89 e5                	mov    %esp,%ebp
80104b46:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80104b49:	e8 3e f7 ff ff       	call   8010428c <myproc>
80104b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104b55:	75 0d                	jne    80104b64 <sleep+0x21>
    panic("sleep");
80104b57:	83 ec 0c             	sub    $0xc,%esp
80104b5a:	68 db 86 10 80       	push   $0x801086db
80104b5f:	e8 38 ba ff ff       	call   8010059c <panic>

  if(lk == 0)
80104b64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b68:	75 0d                	jne    80104b77 <sleep+0x34>
    panic("sleep without lk");
80104b6a:	83 ec 0c             	sub    $0xc,%esp
80104b6d:	68 e1 86 10 80       	push   $0x801086e1
80104b72:	e8 25 ba ff ff       	call   8010059c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b77:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104b7e:	74 1e                	je     80104b9e <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	68 a0 3d 11 80       	push   $0x80113da0
80104b88:	e8 cf 03 00 00       	call   80104f5c <acquire>
80104b8d:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	ff 75 0c             	pushl  0xc(%ebp)
80104b96:	e8 2f 04 00 00       	call   80104fca <release>
80104b9b:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba1:	8b 55 08             	mov    0x8(%ebp),%edx
80104ba4:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104baa:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104bb1:	e8 52 fe ff ff       	call   80104a08 <sched>

  // Tidy up.
  p->chan = 0;
80104bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104bc0:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104bc7:	74 1e                	je     80104be7 <sleep+0xa4>
    release(&ptable.lock);
80104bc9:	83 ec 0c             	sub    $0xc,%esp
80104bcc:	68 a0 3d 11 80       	push   $0x80113da0
80104bd1:	e8 f4 03 00 00       	call   80104fca <release>
80104bd6:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104bd9:	83 ec 0c             	sub    $0xc,%esp
80104bdc:	ff 75 0c             	pushl  0xc(%ebp)
80104bdf:	e8 78 03 00 00       	call   80104f5c <acquire>
80104be4:	83 c4 10             	add    $0x10,%esp
  }
}
80104be7:	90                   	nop
80104be8:	c9                   	leave  
80104be9:	c3                   	ret    

80104bea <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104bea:	55                   	push   %ebp
80104beb:	89 e5                	mov    %esp,%ebp
80104bed:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bf0:	c7 45 fc d4 3d 11 80 	movl   $0x80113dd4,-0x4(%ebp)
80104bf7:	eb 24                	jmp    80104c1d <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bfc:	8b 40 0c             	mov    0xc(%eax),%eax
80104bff:	83 f8 02             	cmp    $0x2,%eax
80104c02:	75 15                	jne    80104c19 <wakeup1+0x2f>
80104c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c07:	8b 40 20             	mov    0x20(%eax),%eax
80104c0a:	39 45 08             	cmp    %eax,0x8(%ebp)
80104c0d:	75 0a                	jne    80104c19 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c12:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c19:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104c1d:	81 7d fc d4 5c 11 80 	cmpl   $0x80115cd4,-0x4(%ebp)
80104c24:	72 d3                	jb     80104bf9 <wakeup1+0xf>
}
80104c26:	90                   	nop
80104c27:	c9                   	leave  
80104c28:	c3                   	ret    

80104c29 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104c29:	55                   	push   %ebp
80104c2a:	89 e5                	mov    %esp,%ebp
80104c2c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104c2f:	83 ec 0c             	sub    $0xc,%esp
80104c32:	68 a0 3d 11 80       	push   $0x80113da0
80104c37:	e8 20 03 00 00       	call   80104f5c <acquire>
80104c3c:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	ff 75 08             	pushl  0x8(%ebp)
80104c45:	e8 a0 ff ff ff       	call   80104bea <wakeup1>
80104c4a:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104c4d:	83 ec 0c             	sub    $0xc,%esp
80104c50:	68 a0 3d 11 80       	push   $0x80113da0
80104c55:	e8 70 03 00 00       	call   80104fca <release>
80104c5a:	83 c4 10             	add    $0x10,%esp
}
80104c5d:	90                   	nop
80104c5e:	c9                   	leave  
80104c5f:	c3                   	ret    

80104c60 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c66:	83 ec 0c             	sub    $0xc,%esp
80104c69:	68 a0 3d 11 80       	push   $0x80113da0
80104c6e:	e8 e9 02 00 00       	call   80104f5c <acquire>
80104c73:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c76:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104c7d:	eb 45                	jmp    80104cc4 <kill+0x64>
    if(p->pid == pid){
80104c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c82:	8b 40 10             	mov    0x10(%eax),%eax
80104c85:	39 45 08             	cmp    %eax,0x8(%ebp)
80104c88:	75 36                	jne    80104cc0 <kill+0x60>
      p->killed = 1;
80104c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c97:	8b 40 0c             	mov    0xc(%eax),%eax
80104c9a:	83 f8 02             	cmp    $0x2,%eax
80104c9d:	75 0a                	jne    80104ca9 <kill+0x49>
        p->state = RUNNABLE;
80104c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104ca9:	83 ec 0c             	sub    $0xc,%esp
80104cac:	68 a0 3d 11 80       	push   $0x80113da0
80104cb1:	e8 14 03 00 00       	call   80104fca <release>
80104cb6:	83 c4 10             	add    $0x10,%esp
      return 0;
80104cb9:	b8 00 00 00 00       	mov    $0x0,%eax
80104cbe:	eb 22                	jmp    80104ce2 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc0:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104cc4:	81 7d f4 d4 5c 11 80 	cmpl   $0x80115cd4,-0xc(%ebp)
80104ccb:	72 b2                	jb     80104c7f <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104ccd:	83 ec 0c             	sub    $0xc,%esp
80104cd0:	68 a0 3d 11 80       	push   $0x80113da0
80104cd5:	e8 f0 02 00 00       	call   80104fca <release>
80104cda:	83 c4 10             	add    $0x10,%esp
  return -1;
80104cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce2:	c9                   	leave  
80104ce3:	c3                   	ret    

80104ce4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cea:	c7 45 f0 d4 3d 11 80 	movl   $0x80113dd4,-0x10(%ebp)
80104cf1:	e9 d7 00 00 00       	jmp    80104dcd <procdump+0xe9>
    if(p->state == UNUSED)
80104cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cf9:	8b 40 0c             	mov    0xc(%eax),%eax
80104cfc:	85 c0                	test   %eax,%eax
80104cfe:	0f 84 c4 00 00 00    	je     80104dc8 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d07:	8b 40 0c             	mov    0xc(%eax),%eax
80104d0a:	83 f8 05             	cmp    $0x5,%eax
80104d0d:	77 23                	ja     80104d32 <procdump+0x4e>
80104d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d12:	8b 40 0c             	mov    0xc(%eax),%eax
80104d15:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104d1c:	85 c0                	test   %eax,%eax
80104d1e:	74 12                	je     80104d32 <procdump+0x4e>
      state = states[p->state];
80104d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d23:	8b 40 0c             	mov    0xc(%eax),%eax
80104d26:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104d2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104d30:	eb 07                	jmp    80104d39 <procdump+0x55>
    else
      state = "???";
80104d32:	c7 45 ec f2 86 10 80 	movl   $0x801086f2,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d3c:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d42:	8b 40 10             	mov    0x10(%eax),%eax
80104d45:	52                   	push   %edx
80104d46:	ff 75 ec             	pushl  -0x14(%ebp)
80104d49:	50                   	push   %eax
80104d4a:	68 f6 86 10 80       	push   $0x801086f6
80104d4f:	e8 a8 b6 ff ff       	call   801003fc <cprintf>
80104d54:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d5a:	8b 40 0c             	mov    0xc(%eax),%eax
80104d5d:	83 f8 02             	cmp    $0x2,%eax
80104d60:	75 54                	jne    80104db6 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d65:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d68:	8b 40 0c             	mov    0xc(%eax),%eax
80104d6b:	83 c0 08             	add    $0x8,%eax
80104d6e:	89 c2                	mov    %eax,%edx
80104d70:	83 ec 08             	sub    $0x8,%esp
80104d73:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d76:	50                   	push   %eax
80104d77:	52                   	push   %edx
80104d78:	e8 9f 02 00 00       	call   8010501c <getcallerpcs>
80104d7d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104d80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d87:	eb 1c                	jmp    80104da5 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d90:	83 ec 08             	sub    $0x8,%esp
80104d93:	50                   	push   %eax
80104d94:	68 ff 86 10 80       	push   $0x801086ff
80104d99:	e8 5e b6 ff ff       	call   801003fc <cprintf>
80104d9e:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104da1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104da5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104da9:	7f 0b                	jg     80104db6 <procdump+0xd2>
80104dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dae:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104db2:	85 c0                	test   %eax,%eax
80104db4:	75 d3                	jne    80104d89 <procdump+0xa5>
    }
    cprintf("\n");
80104db6:	83 ec 0c             	sub    $0xc,%esp
80104db9:	68 03 87 10 80       	push   $0x80108703
80104dbe:	e8 39 b6 ff ff       	call   801003fc <cprintf>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	eb 01                	jmp    80104dc9 <procdump+0xe5>
      continue;
80104dc8:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dc9:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104dcd:	81 7d f0 d4 5c 11 80 	cmpl   $0x80115cd4,-0x10(%ebp)
80104dd4:	0f 82 1c ff ff ff    	jb     80104cf6 <procdump+0x12>
  }
}
80104dda:	90                   	nop
80104ddb:	c9                   	leave  
80104ddc:	c3                   	ret    

80104ddd <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ddd:	55                   	push   %ebp
80104dde:	89 e5                	mov    %esp,%ebp
80104de0:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80104de3:	8b 45 08             	mov    0x8(%ebp),%eax
80104de6:	83 c0 04             	add    $0x4,%eax
80104de9:	83 ec 08             	sub    $0x8,%esp
80104dec:	68 2f 87 10 80       	push   $0x8010872f
80104df1:	50                   	push   %eax
80104df2:	e8 43 01 00 00       	call   80104f3a <initlock>
80104df7:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80104dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e00:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104e03:	8b 45 08             	mov    0x8(%ebp),%eax
80104e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0f:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104e16:	90                   	nop
80104e17:	c9                   	leave  
80104e18:	c3                   	ret    

80104e19 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e19:	55                   	push   %ebp
80104e1a:	89 e5                	mov    %esp,%ebp
80104e1c:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104e22:	83 c0 04             	add    $0x4,%eax
80104e25:	83 ec 0c             	sub    $0xc,%esp
80104e28:	50                   	push   %eax
80104e29:	e8 2e 01 00 00       	call   80104f5c <acquire>
80104e2e:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104e31:	eb 15                	jmp    80104e48 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104e33:	8b 45 08             	mov    0x8(%ebp),%eax
80104e36:	83 c0 04             	add    $0x4,%eax
80104e39:	83 ec 08             	sub    $0x8,%esp
80104e3c:	50                   	push   %eax
80104e3d:	ff 75 08             	pushl  0x8(%ebp)
80104e40:	e8 fe fc ff ff       	call   80104b43 <sleep>
80104e45:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104e48:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4b:	8b 00                	mov    (%eax),%eax
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	75 e2                	jne    80104e33 <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104e51:	8b 45 08             	mov    0x8(%ebp),%eax
80104e54:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104e5a:	e8 2d f4 ff ff       	call   8010428c <myproc>
80104e5f:	8b 50 10             	mov    0x10(%eax),%edx
80104e62:	8b 45 08             	mov    0x8(%ebp),%eax
80104e65:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104e68:	8b 45 08             	mov    0x8(%ebp),%eax
80104e6b:	83 c0 04             	add    $0x4,%eax
80104e6e:	83 ec 0c             	sub    $0xc,%esp
80104e71:	50                   	push   %eax
80104e72:	e8 53 01 00 00       	call   80104fca <release>
80104e77:	83 c4 10             	add    $0x10,%esp
}
80104e7a:	90                   	nop
80104e7b:	c9                   	leave  
80104e7c:	c3                   	ret    

80104e7d <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104e7d:	55                   	push   %ebp
80104e7e:	89 e5                	mov    %esp,%ebp
80104e80:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104e83:	8b 45 08             	mov    0x8(%ebp),%eax
80104e86:	83 c0 04             	add    $0x4,%eax
80104e89:	83 ec 0c             	sub    $0xc,%esp
80104e8c:	50                   	push   %eax
80104e8d:	e8 ca 00 00 00       	call   80104f5c <acquire>
80104e92:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104e95:	8b 45 08             	mov    0x8(%ebp),%eax
80104e98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104e9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea1:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104ea8:	83 ec 0c             	sub    $0xc,%esp
80104eab:	ff 75 08             	pushl  0x8(%ebp)
80104eae:	e8 76 fd ff ff       	call   80104c29 <wakeup>
80104eb3:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80104eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb9:	83 c0 04             	add    $0x4,%eax
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	50                   	push   %eax
80104ec0:	e8 05 01 00 00       	call   80104fca <release>
80104ec5:	83 c4 10             	add    $0x10,%esp
}
80104ec8:	90                   	nop
80104ec9:	c9                   	leave  
80104eca:	c3                   	ret    

80104ecb <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104ecb:	55                   	push   %ebp
80104ecc:	89 e5                	mov    %esp,%ebp
80104ece:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80104ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed4:	83 c0 04             	add    $0x4,%eax
80104ed7:	83 ec 0c             	sub    $0xc,%esp
80104eda:	50                   	push   %eax
80104edb:	e8 7c 00 00 00       	call   80104f5c <acquire>
80104ee0:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80104ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee6:	8b 00                	mov    (%eax),%eax
80104ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80104eee:	83 c0 04             	add    $0x4,%eax
80104ef1:	83 ec 0c             	sub    $0xc,%esp
80104ef4:	50                   	push   %eax
80104ef5:	e8 d0 00 00 00       	call   80104fca <release>
80104efa:	83 c4 10             	add    $0x10,%esp
  return r;
80104efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104f00:	c9                   	leave  
80104f01:	c3                   	ret    

80104f02 <readeflags>:
{
80104f02:	55                   	push   %ebp
80104f03:	89 e5                	mov    %esp,%ebp
80104f05:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f08:	9c                   	pushf  
80104f09:	58                   	pop    %eax
80104f0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f10:	c9                   	leave  
80104f11:	c3                   	ret    

80104f12 <cli>:
{
80104f12:	55                   	push   %ebp
80104f13:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f15:	fa                   	cli    
}
80104f16:	90                   	nop
80104f17:	5d                   	pop    %ebp
80104f18:	c3                   	ret    

80104f19 <sti>:
{
80104f19:	55                   	push   %ebp
80104f1a:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f1c:	fb                   	sti    
}
80104f1d:	90                   	nop
80104f1e:	5d                   	pop    %ebp
80104f1f:	c3                   	ret    

80104f20 <xchg>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104f26:	8b 55 08             	mov    0x8(%ebp),%edx
80104f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f2f:	f0 87 02             	lock xchg %eax,(%edx)
80104f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f38:	c9                   	leave  
80104f39:	c3                   	ret    

80104f3a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f3a:	55                   	push   %ebp
80104f3b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f40:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f43:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f46:	8b 45 08             	mov    0x8(%ebp),%eax
80104f49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f59:	90                   	nop
80104f5a:	5d                   	pop    %ebp
80104f5b:	c3                   	ret    

80104f5c <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f5c:	55                   	push   %ebp
80104f5d:	89 e5                	mov    %esp,%ebp
80104f5f:	53                   	push   %ebx
80104f60:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f63:	e8 5f 01 00 00       	call   801050c7 <pushcli>
  if(holding(lk))
80104f68:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6b:	83 ec 0c             	sub    $0xc,%esp
80104f6e:	50                   	push   %eax
80104f6f:	e8 22 01 00 00       	call   80105096 <holding>
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	85 c0                	test   %eax,%eax
80104f79:	74 0d                	je     80104f88 <acquire+0x2c>
    panic("acquire");
80104f7b:	83 ec 0c             	sub    $0xc,%esp
80104f7e:	68 3a 87 10 80       	push   $0x8010873a
80104f83:	e8 14 b6 ff ff       	call   8010059c <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104f88:	90                   	nop
80104f89:	8b 45 08             	mov    0x8(%ebp),%eax
80104f8c:	83 ec 08             	sub    $0x8,%esp
80104f8f:	6a 01                	push   $0x1
80104f91:	50                   	push   %eax
80104f92:	e8 89 ff ff ff       	call   80104f20 <xchg>
80104f97:	83 c4 10             	add    $0x10,%esp
80104f9a:	85 c0                	test   %eax,%eax
80104f9c:	75 eb                	jne    80104f89 <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104f9e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104fa3:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fa6:	e8 69 f2 ff ff       	call   80104214 <mycpu>
80104fab:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104fae:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb1:	83 c0 0c             	add    $0xc,%eax
80104fb4:	83 ec 08             	sub    $0x8,%esp
80104fb7:	50                   	push   %eax
80104fb8:	8d 45 08             	lea    0x8(%ebp),%eax
80104fbb:	50                   	push   %eax
80104fbc:	e8 5b 00 00 00       	call   8010501c <getcallerpcs>
80104fc1:	83 c4 10             	add    $0x10,%esp
}
80104fc4:	90                   	nop
80104fc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fc8:	c9                   	leave  
80104fc9:	c3                   	ret    

80104fca <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fca:	55                   	push   %ebp
80104fcb:	89 e5                	mov    %esp,%ebp
80104fcd:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104fd0:	83 ec 0c             	sub    $0xc,%esp
80104fd3:	ff 75 08             	pushl  0x8(%ebp)
80104fd6:	e8 bb 00 00 00       	call   80105096 <holding>
80104fdb:	83 c4 10             	add    $0x10,%esp
80104fde:	85 c0                	test   %eax,%eax
80104fe0:	75 0d                	jne    80104fef <release+0x25>
    panic("release");
80104fe2:	83 ec 0c             	sub    $0xc,%esp
80104fe5:	68 42 87 10 80       	push   $0x80108742
80104fea:	e8 ad b5 ff ff       	call   8010059c <panic>

  lk->pcs[0] = 0;
80104fef:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80104ffc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105003:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105008:	8b 45 08             	mov    0x8(%ebp),%eax
8010500b:	8b 55 08             	mov    0x8(%ebp),%edx
8010500e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105014:	e8 fc 00 00 00       	call   80105115 <popcli>
}
80105019:	90                   	nop
8010501a:	c9                   	leave  
8010501b:	c3                   	ret    

8010501c <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010501c:	55                   	push   %ebp
8010501d:	89 e5                	mov    %esp,%ebp
8010501f:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105022:	8b 45 08             	mov    0x8(%ebp),%eax
80105025:	83 e8 08             	sub    $0x8,%eax
80105028:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010502b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105032:	eb 38                	jmp    8010506c <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105034:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105038:	74 53                	je     8010508d <getcallerpcs+0x71>
8010503a:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105041:	76 4a                	jbe    8010508d <getcallerpcs+0x71>
80105043:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105047:	74 44                	je     8010508d <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105049:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010504c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105053:	8b 45 0c             	mov    0xc(%ebp),%eax
80105056:	01 c2                	add    %eax,%edx
80105058:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010505b:	8b 40 04             	mov    0x4(%eax),%eax
8010505e:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105060:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105063:	8b 00                	mov    (%eax),%eax
80105065:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105068:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010506c:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105070:	7e c2                	jle    80105034 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105072:	eb 19                	jmp    8010508d <getcallerpcs+0x71>
    pcs[i] = 0;
80105074:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010507e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105081:	01 d0                	add    %edx,%eax
80105083:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105089:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010508d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105091:	7e e1                	jle    80105074 <getcallerpcs+0x58>
}
80105093:	90                   	nop
80105094:	c9                   	leave  
80105095:	c3                   	ret    

80105096 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105096:	55                   	push   %ebp
80105097:	89 e5                	mov    %esp,%ebp
80105099:	53                   	push   %ebx
8010509a:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
8010509d:	8b 45 08             	mov    0x8(%ebp),%eax
801050a0:	8b 00                	mov    (%eax),%eax
801050a2:	85 c0                	test   %eax,%eax
801050a4:	74 16                	je     801050bc <holding+0x26>
801050a6:	8b 45 08             	mov    0x8(%ebp),%eax
801050a9:	8b 58 08             	mov    0x8(%eax),%ebx
801050ac:	e8 63 f1 ff ff       	call   80104214 <mycpu>
801050b1:	39 c3                	cmp    %eax,%ebx
801050b3:	75 07                	jne    801050bc <holding+0x26>
801050b5:	b8 01 00 00 00       	mov    $0x1,%eax
801050ba:	eb 05                	jmp    801050c1 <holding+0x2b>
801050bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050c1:	83 c4 04             	add    $0x4,%esp
801050c4:	5b                   	pop    %ebx
801050c5:	5d                   	pop    %ebp
801050c6:	c3                   	ret    

801050c7 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050c7:	55                   	push   %ebp
801050c8:	89 e5                	mov    %esp,%ebp
801050ca:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801050cd:	e8 30 fe ff ff       	call   80104f02 <readeflags>
801050d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801050d5:	e8 38 fe ff ff       	call   80104f12 <cli>
  if(mycpu()->ncli == 0)
801050da:	e8 35 f1 ff ff       	call   80104214 <mycpu>
801050df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050e5:	85 c0                	test   %eax,%eax
801050e7:	75 15                	jne    801050fe <pushcli+0x37>
    mycpu()->intena = eflags & FL_IF;
801050e9:	e8 26 f1 ff ff       	call   80104214 <mycpu>
801050ee:	89 c2                	mov    %eax,%edx
801050f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f3:	25 00 02 00 00       	and    $0x200,%eax
801050f8:	89 82 a8 00 00 00    	mov    %eax,0xa8(%edx)
  mycpu()->ncli += 1;
801050fe:	e8 11 f1 ff ff       	call   80104214 <mycpu>
80105103:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105109:	83 c2 01             	add    $0x1,%edx
8010510c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105112:	90                   	nop
80105113:	c9                   	leave  
80105114:	c3                   	ret    

80105115 <popcli>:

void
popcli(void)
{
80105115:	55                   	push   %ebp
80105116:	89 e5                	mov    %esp,%ebp
80105118:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010511b:	e8 e2 fd ff ff       	call   80104f02 <readeflags>
80105120:	25 00 02 00 00       	and    $0x200,%eax
80105125:	85 c0                	test   %eax,%eax
80105127:	74 0d                	je     80105136 <popcli+0x21>
    panic("popcli - interruptible");
80105129:	83 ec 0c             	sub    $0xc,%esp
8010512c:	68 4a 87 10 80       	push   $0x8010874a
80105131:	e8 66 b4 ff ff       	call   8010059c <panic>
  if(--mycpu()->ncli < 0)
80105136:	e8 d9 f0 ff ff       	call   80104214 <mycpu>
8010513b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105141:	83 ea 01             	sub    $0x1,%edx
80105144:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
8010514a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105150:	85 c0                	test   %eax,%eax
80105152:	79 0d                	jns    80105161 <popcli+0x4c>
    panic("popcli");
80105154:	83 ec 0c             	sub    $0xc,%esp
80105157:	68 61 87 10 80       	push   $0x80108761
8010515c:	e8 3b b4 ff ff       	call   8010059c <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105161:	e8 ae f0 ff ff       	call   80104214 <mycpu>
80105166:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010516c:	85 c0                	test   %eax,%eax
8010516e:	75 14                	jne    80105184 <popcli+0x6f>
80105170:	e8 9f f0 ff ff       	call   80104214 <mycpu>
80105175:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010517b:	85 c0                	test   %eax,%eax
8010517d:	74 05                	je     80105184 <popcli+0x6f>
    sti();
8010517f:	e8 95 fd ff ff       	call   80104f19 <sti>
}
80105184:	90                   	nop
80105185:	c9                   	leave  
80105186:	c3                   	ret    

80105187 <stosb>:
{
80105187:	55                   	push   %ebp
80105188:	89 e5                	mov    %esp,%ebp
8010518a:	57                   	push   %edi
8010518b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010518c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010518f:	8b 55 10             	mov    0x10(%ebp),%edx
80105192:	8b 45 0c             	mov    0xc(%ebp),%eax
80105195:	89 cb                	mov    %ecx,%ebx
80105197:	89 df                	mov    %ebx,%edi
80105199:	89 d1                	mov    %edx,%ecx
8010519b:	fc                   	cld    
8010519c:	f3 aa                	rep stos %al,%es:(%edi)
8010519e:	89 ca                	mov    %ecx,%edx
801051a0:	89 fb                	mov    %edi,%ebx
801051a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051a5:	89 55 10             	mov    %edx,0x10(%ebp)
}
801051a8:	90                   	nop
801051a9:	5b                   	pop    %ebx
801051aa:	5f                   	pop    %edi
801051ab:	5d                   	pop    %ebp
801051ac:	c3                   	ret    

801051ad <stosl>:
{
801051ad:	55                   	push   %ebp
801051ae:	89 e5                	mov    %esp,%ebp
801051b0:	57                   	push   %edi
801051b1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051b5:	8b 55 10             	mov    0x10(%ebp),%edx
801051b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bb:	89 cb                	mov    %ecx,%ebx
801051bd:	89 df                	mov    %ebx,%edi
801051bf:	89 d1                	mov    %edx,%ecx
801051c1:	fc                   	cld    
801051c2:	f3 ab                	rep stos %eax,%es:(%edi)
801051c4:	89 ca                	mov    %ecx,%edx
801051c6:	89 fb                	mov    %edi,%ebx
801051c8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051cb:	89 55 10             	mov    %edx,0x10(%ebp)
}
801051ce:	90                   	nop
801051cf:	5b                   	pop    %ebx
801051d0:	5f                   	pop    %edi
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret    

801051d3 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051d3:	55                   	push   %ebp
801051d4:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801051d6:	8b 45 08             	mov    0x8(%ebp),%eax
801051d9:	83 e0 03             	and    $0x3,%eax
801051dc:	85 c0                	test   %eax,%eax
801051de:	75 43                	jne    80105223 <memset+0x50>
801051e0:	8b 45 10             	mov    0x10(%ebp),%eax
801051e3:	83 e0 03             	and    $0x3,%eax
801051e6:	85 c0                	test   %eax,%eax
801051e8:	75 39                	jne    80105223 <memset+0x50>
    c &= 0xFF;
801051ea:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051f1:	8b 45 10             	mov    0x10(%ebp),%eax
801051f4:	c1 e8 02             	shr    $0x2,%eax
801051f7:	89 c1                	mov    %eax,%ecx
801051f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801051fc:	c1 e0 18             	shl    $0x18,%eax
801051ff:	89 c2                	mov    %eax,%edx
80105201:	8b 45 0c             	mov    0xc(%ebp),%eax
80105204:	c1 e0 10             	shl    $0x10,%eax
80105207:	09 c2                	or     %eax,%edx
80105209:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520c:	c1 e0 08             	shl    $0x8,%eax
8010520f:	09 d0                	or     %edx,%eax
80105211:	0b 45 0c             	or     0xc(%ebp),%eax
80105214:	51                   	push   %ecx
80105215:	50                   	push   %eax
80105216:	ff 75 08             	pushl  0x8(%ebp)
80105219:	e8 8f ff ff ff       	call   801051ad <stosl>
8010521e:	83 c4 0c             	add    $0xc,%esp
80105221:	eb 12                	jmp    80105235 <memset+0x62>
  } else
    stosb(dst, c, n);
80105223:	8b 45 10             	mov    0x10(%ebp),%eax
80105226:	50                   	push   %eax
80105227:	ff 75 0c             	pushl  0xc(%ebp)
8010522a:	ff 75 08             	pushl  0x8(%ebp)
8010522d:	e8 55 ff ff ff       	call   80105187 <stosb>
80105232:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105235:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105238:	c9                   	leave  
80105239:	c3                   	ret    

8010523a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010523a:	55                   	push   %ebp
8010523b:	89 e5                	mov    %esp,%ebp
8010523d:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105240:	8b 45 08             	mov    0x8(%ebp),%eax
80105243:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105246:	8b 45 0c             	mov    0xc(%ebp),%eax
80105249:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010524c:	eb 30                	jmp    8010527e <memcmp+0x44>
    if(*s1 != *s2)
8010524e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105251:	0f b6 10             	movzbl (%eax),%edx
80105254:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105257:	0f b6 00             	movzbl (%eax),%eax
8010525a:	38 c2                	cmp    %al,%dl
8010525c:	74 18                	je     80105276 <memcmp+0x3c>
      return *s1 - *s2;
8010525e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105261:	0f b6 00             	movzbl (%eax),%eax
80105264:	0f b6 d0             	movzbl %al,%edx
80105267:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010526a:	0f b6 00             	movzbl (%eax),%eax
8010526d:	0f b6 c0             	movzbl %al,%eax
80105270:	29 c2                	sub    %eax,%edx
80105272:	89 d0                	mov    %edx,%eax
80105274:	eb 1a                	jmp    80105290 <memcmp+0x56>
    s1++, s2++;
80105276:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010527a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
8010527e:	8b 45 10             	mov    0x10(%ebp),%eax
80105281:	8d 50 ff             	lea    -0x1(%eax),%edx
80105284:	89 55 10             	mov    %edx,0x10(%ebp)
80105287:	85 c0                	test   %eax,%eax
80105289:	75 c3                	jne    8010524e <memcmp+0x14>
  }

  return 0;
8010528b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105290:	c9                   	leave  
80105291:	c3                   	ret    

80105292 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105292:	55                   	push   %ebp
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105298:	8b 45 0c             	mov    0xc(%ebp),%eax
8010529b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010529e:	8b 45 08             	mov    0x8(%ebp),%eax
801052a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052aa:	73 54                	jae    80105300 <memmove+0x6e>
801052ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052af:	8b 45 10             	mov    0x10(%ebp),%eax
801052b2:	01 d0                	add    %edx,%eax
801052b4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801052b7:	73 47                	jae    80105300 <memmove+0x6e>
    s += n;
801052b9:	8b 45 10             	mov    0x10(%ebp),%eax
801052bc:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801052bf:	8b 45 10             	mov    0x10(%ebp),%eax
801052c2:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801052c5:	eb 13                	jmp    801052da <memmove+0x48>
      *--d = *--s;
801052c7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052cb:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d2:	0f b6 10             	movzbl (%eax),%edx
801052d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052d8:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801052da:	8b 45 10             	mov    0x10(%ebp),%eax
801052dd:	8d 50 ff             	lea    -0x1(%eax),%edx
801052e0:	89 55 10             	mov    %edx,0x10(%ebp)
801052e3:	85 c0                	test   %eax,%eax
801052e5:	75 e0                	jne    801052c7 <memmove+0x35>
  if(s < d && s + n > d){
801052e7:	eb 24                	jmp    8010530d <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
801052e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052ec:	8d 42 01             	lea    0x1(%edx),%eax
801052ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
801052f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052f5:	8d 48 01             	lea    0x1(%eax),%ecx
801052f8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
801052fb:	0f b6 12             	movzbl (%edx),%edx
801052fe:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105300:	8b 45 10             	mov    0x10(%ebp),%eax
80105303:	8d 50 ff             	lea    -0x1(%eax),%edx
80105306:	89 55 10             	mov    %edx,0x10(%ebp)
80105309:	85 c0                	test   %eax,%eax
8010530b:	75 dc                	jne    801052e9 <memmove+0x57>

  return dst;
8010530d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105310:	c9                   	leave  
80105311:	c3                   	ret    

80105312 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105312:	55                   	push   %ebp
80105313:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105315:	ff 75 10             	pushl  0x10(%ebp)
80105318:	ff 75 0c             	pushl  0xc(%ebp)
8010531b:	ff 75 08             	pushl  0x8(%ebp)
8010531e:	e8 6f ff ff ff       	call   80105292 <memmove>
80105323:	83 c4 0c             	add    $0xc,%esp
}
80105326:	c9                   	leave  
80105327:	c3                   	ret    

80105328 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105328:	55                   	push   %ebp
80105329:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010532b:	eb 0c                	jmp    80105339 <strncmp+0x11>
    n--, p++, q++;
8010532d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105331:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105335:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010533d:	74 1a                	je     80105359 <strncmp+0x31>
8010533f:	8b 45 08             	mov    0x8(%ebp),%eax
80105342:	0f b6 00             	movzbl (%eax),%eax
80105345:	84 c0                	test   %al,%al
80105347:	74 10                	je     80105359 <strncmp+0x31>
80105349:	8b 45 08             	mov    0x8(%ebp),%eax
8010534c:	0f b6 10             	movzbl (%eax),%edx
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105352:	0f b6 00             	movzbl (%eax),%eax
80105355:	38 c2                	cmp    %al,%dl
80105357:	74 d4                	je     8010532d <strncmp+0x5>
  if(n == 0)
80105359:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010535d:	75 07                	jne    80105366 <strncmp+0x3e>
    return 0;
8010535f:	b8 00 00 00 00       	mov    $0x0,%eax
80105364:	eb 16                	jmp    8010537c <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105366:	8b 45 08             	mov    0x8(%ebp),%eax
80105369:	0f b6 00             	movzbl (%eax),%eax
8010536c:	0f b6 d0             	movzbl %al,%edx
8010536f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105372:	0f b6 00             	movzbl (%eax),%eax
80105375:	0f b6 c0             	movzbl %al,%eax
80105378:	29 c2                	sub    %eax,%edx
8010537a:	89 d0                	mov    %edx,%eax
}
8010537c:	5d                   	pop    %ebp
8010537d:	c3                   	ret    

8010537e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010537e:	55                   	push   %ebp
8010537f:	89 e5                	mov    %esp,%ebp
80105381:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105384:	8b 45 08             	mov    0x8(%ebp),%eax
80105387:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010538a:	90                   	nop
8010538b:	8b 45 10             	mov    0x10(%ebp),%eax
8010538e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105391:	89 55 10             	mov    %edx,0x10(%ebp)
80105394:	85 c0                	test   %eax,%eax
80105396:	7e 2c                	jle    801053c4 <strncpy+0x46>
80105398:	8b 55 0c             	mov    0xc(%ebp),%edx
8010539b:	8d 42 01             	lea    0x1(%edx),%eax
8010539e:	89 45 0c             	mov    %eax,0xc(%ebp)
801053a1:	8b 45 08             	mov    0x8(%ebp),%eax
801053a4:	8d 48 01             	lea    0x1(%eax),%ecx
801053a7:	89 4d 08             	mov    %ecx,0x8(%ebp)
801053aa:	0f b6 12             	movzbl (%edx),%edx
801053ad:	88 10                	mov    %dl,(%eax)
801053af:	0f b6 00             	movzbl (%eax),%eax
801053b2:	84 c0                	test   %al,%al
801053b4:	75 d5                	jne    8010538b <strncpy+0xd>
    ;
  while(n-- > 0)
801053b6:	eb 0c                	jmp    801053c4 <strncpy+0x46>
    *s++ = 0;
801053b8:	8b 45 08             	mov    0x8(%ebp),%eax
801053bb:	8d 50 01             	lea    0x1(%eax),%edx
801053be:	89 55 08             	mov    %edx,0x8(%ebp)
801053c1:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
801053c4:	8b 45 10             	mov    0x10(%ebp),%eax
801053c7:	8d 50 ff             	lea    -0x1(%eax),%edx
801053ca:	89 55 10             	mov    %edx,0x10(%ebp)
801053cd:	85 c0                	test   %eax,%eax
801053cf:	7f e7                	jg     801053b8 <strncpy+0x3a>
  return os;
801053d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053d4:	c9                   	leave  
801053d5:	c3                   	ret    

801053d6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053d6:	55                   	push   %ebp
801053d7:	89 e5                	mov    %esp,%ebp
801053d9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801053dc:	8b 45 08             	mov    0x8(%ebp),%eax
801053df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053e6:	7f 05                	jg     801053ed <safestrcpy+0x17>
    return os;
801053e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053eb:	eb 31                	jmp    8010541e <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801053ed:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053f5:	7e 1e                	jle    80105415 <safestrcpy+0x3f>
801053f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801053fa:	8d 42 01             	lea    0x1(%edx),%eax
801053fd:	89 45 0c             	mov    %eax,0xc(%ebp)
80105400:	8b 45 08             	mov    0x8(%ebp),%eax
80105403:	8d 48 01             	lea    0x1(%eax),%ecx
80105406:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105409:	0f b6 12             	movzbl (%edx),%edx
8010540c:	88 10                	mov    %dl,(%eax)
8010540e:	0f b6 00             	movzbl (%eax),%eax
80105411:	84 c0                	test   %al,%al
80105413:	75 d8                	jne    801053ed <safestrcpy+0x17>
    ;
  *s = 0;
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010541b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010541e:	c9                   	leave  
8010541f:	c3                   	ret    

80105420 <strlen>:

int
strlen(const char *s)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010542d:	eb 04                	jmp    80105433 <strlen+0x13>
8010542f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105433:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105436:	8b 45 08             	mov    0x8(%ebp),%eax
80105439:	01 d0                	add    %edx,%eax
8010543b:	0f b6 00             	movzbl (%eax),%eax
8010543e:	84 c0                	test   %al,%al
80105440:	75 ed                	jne    8010542f <strlen+0xf>
    ;
  return n;
80105442:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    

80105447 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105447:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010544b:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010544f:	55                   	push   %ebp
  pushl %ebx
80105450:	53                   	push   %ebx
  pushl %esi
80105451:	56                   	push   %esi
  pushl %edi
80105452:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105453:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105455:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105457:	5f                   	pop    %edi
  popl %esi
80105458:	5e                   	pop    %esi
  popl %ebx
80105459:	5b                   	pop    %ebx
  popl %ebp
8010545a:	5d                   	pop    %ebp
  ret
8010545b:	c3                   	ret    

8010545c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010545c:	55                   	push   %ebp
8010545d:	89 e5                	mov    %esp,%ebp
8010545f:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105462:	e8 25 ee ff ff       	call   8010428c <myproc>
80105467:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010546a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010546d:	8b 00                	mov    (%eax),%eax
8010546f:	39 45 08             	cmp    %eax,0x8(%ebp)
80105472:	73 0f                	jae    80105483 <fetchint+0x27>
80105474:	8b 45 08             	mov    0x8(%ebp),%eax
80105477:	8d 50 04             	lea    0x4(%eax),%edx
8010547a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547d:	8b 00                	mov    (%eax),%eax
8010547f:	39 c2                	cmp    %eax,%edx
80105481:	76 07                	jbe    8010548a <fetchint+0x2e>
    return -1;
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105488:	eb 0f                	jmp    80105499 <fetchint+0x3d>
  *ip = *(int*)(addr);
8010548a:	8b 45 08             	mov    0x8(%ebp),%eax
8010548d:	8b 10                	mov    (%eax),%edx
8010548f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105492:	89 10                	mov    %edx,(%eax)
  return 0;
80105494:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105499:	c9                   	leave  
8010549a:	c3                   	ret    

8010549b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010549b:	55                   	push   %ebp
8010549c:	89 e5                	mov    %esp,%ebp
8010549e:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801054a1:	e8 e6 ed ff ff       	call   8010428c <myproc>
801054a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801054a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054ac:	8b 00                	mov    (%eax),%eax
801054ae:	39 45 08             	cmp    %eax,0x8(%ebp)
801054b1:	72 07                	jb     801054ba <fetchstr+0x1f>
    return -1;
801054b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b8:	eb 43                	jmp    801054fd <fetchstr+0x62>
  *pp = (char*)addr;
801054ba:	8b 55 08             	mov    0x8(%ebp),%edx
801054bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c0:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801054c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054c5:	8b 00                	mov    (%eax),%eax
801054c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801054ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cd:	8b 00                	mov    (%eax),%eax
801054cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054d2:	eb 1c                	jmp    801054f0 <fetchstr+0x55>
    if(*s == 0)
801054d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d7:	0f b6 00             	movzbl (%eax),%eax
801054da:	84 c0                	test   %al,%al
801054dc:	75 0e                	jne    801054ec <fetchstr+0x51>
      return s - *pp;
801054de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801054e4:	8b 00                	mov    (%eax),%eax
801054e6:	29 c2                	sub    %eax,%edx
801054e8:	89 d0                	mov    %edx,%eax
801054ea:	eb 11                	jmp    801054fd <fetchstr+0x62>
  for(s = *pp; s < ep; s++){
801054ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801054f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801054f6:	72 dc                	jb     801054d4 <fetchstr+0x39>
  }
  return -1;
801054f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fd:	c9                   	leave  
801054fe:	c3                   	ret    

801054ff <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054ff:	55                   	push   %ebp
80105500:	89 e5                	mov    %esp,%ebp
80105502:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105505:	e8 82 ed ff ff       	call   8010428c <myproc>
8010550a:	8b 40 18             	mov    0x18(%eax),%eax
8010550d:	8b 40 44             	mov    0x44(%eax),%eax
80105510:	8b 55 08             	mov    0x8(%ebp),%edx
80105513:	c1 e2 02             	shl    $0x2,%edx
80105516:	01 d0                	add    %edx,%eax
80105518:	83 c0 04             	add    $0x4,%eax
8010551b:	83 ec 08             	sub    $0x8,%esp
8010551e:	ff 75 0c             	pushl  0xc(%ebp)
80105521:	50                   	push   %eax
80105522:	e8 35 ff ff ff       	call   8010545c <fetchint>
80105527:	83 c4 10             	add    $0x10,%esp
}
8010552a:	c9                   	leave  
8010552b:	c3                   	ret    

8010552c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010552c:	55                   	push   %ebp
8010552d:	89 e5                	mov    %esp,%ebp
8010552f:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105532:	e8 55 ed ff ff       	call   8010428c <myproc>
80105537:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
8010553a:	83 ec 08             	sub    $0x8,%esp
8010553d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105540:	50                   	push   %eax
80105541:	ff 75 08             	pushl  0x8(%ebp)
80105544:	e8 b6 ff ff ff       	call   801054ff <argint>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	85 c0                	test   %eax,%eax
8010554e:	79 07                	jns    80105557 <argptr+0x2b>
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105555:	eb 3b                	jmp    80105592 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105557:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010555b:	78 1f                	js     8010557c <argptr+0x50>
8010555d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105560:	8b 00                	mov    (%eax),%eax
80105562:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105565:	39 d0                	cmp    %edx,%eax
80105567:	76 13                	jbe    8010557c <argptr+0x50>
80105569:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010556c:	89 c2                	mov    %eax,%edx
8010556e:	8b 45 10             	mov    0x10(%ebp),%eax
80105571:	01 c2                	add    %eax,%edx
80105573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105576:	8b 00                	mov    (%eax),%eax
80105578:	39 c2                	cmp    %eax,%edx
8010557a:	76 07                	jbe    80105583 <argptr+0x57>
    return -1;
8010557c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105581:	eb 0f                	jmp    80105592 <argptr+0x66>
  *pp = (char*)i;
80105583:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105586:	89 c2                	mov    %eax,%edx
80105588:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558b:	89 10                	mov    %edx,(%eax)
  return 0;
8010558d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105592:	c9                   	leave  
80105593:	c3                   	ret    

80105594 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105594:	55                   	push   %ebp
80105595:	89 e5                	mov    %esp,%ebp
80105597:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010559a:	83 ec 08             	sub    $0x8,%esp
8010559d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055a0:	50                   	push   %eax
801055a1:	ff 75 08             	pushl  0x8(%ebp)
801055a4:	e8 56 ff ff ff       	call   801054ff <argint>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	85 c0                	test   %eax,%eax
801055ae:	79 07                	jns    801055b7 <argstr+0x23>
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b5:	eb 12                	jmp    801055c9 <argstr+0x35>
  return fetchstr(addr, pp);
801055b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ba:	83 ec 08             	sub    $0x8,%esp
801055bd:	ff 75 0c             	pushl  0xc(%ebp)
801055c0:	50                   	push   %eax
801055c1:	e8 d5 fe ff ff       	call   8010549b <fetchstr>
801055c6:	83 c4 10             	add    $0x10,%esp
}
801055c9:	c9                   	leave  
801055ca:	c3                   	ret    

801055cb <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801055cb:	55                   	push   %ebp
801055cc:	89 e5                	mov    %esp,%ebp
801055ce:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
801055d1:	e8 b6 ec ff ff       	call   8010428c <myproc>
801055d6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801055d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055dc:	8b 40 18             	mov    0x18(%eax),%eax
801055df:	8b 40 1c             	mov    0x1c(%eax),%eax
801055e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055e9:	7e 2f                	jle    8010561a <syscall+0x4f>
801055eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ee:	83 f8 15             	cmp    $0x15,%eax
801055f1:	77 27                	ja     8010561a <syscall+0x4f>
801055f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f6:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
801055fd:	85 c0                	test   %eax,%eax
801055ff:	74 19                	je     8010561a <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105601:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105604:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
8010560b:	ff d0                	call   *%eax
8010560d:	89 c2                	mov    %eax,%edx
8010560f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105612:	8b 40 18             	mov    0x18(%eax),%eax
80105615:	89 50 1c             	mov    %edx,0x1c(%eax)
80105618:	eb 2b                	jmp    80105645 <syscall+0x7a>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010561a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010561d:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105623:	8b 40 10             	mov    0x10(%eax),%eax
80105626:	ff 75 f0             	pushl  -0x10(%ebp)
80105629:	52                   	push   %edx
8010562a:	50                   	push   %eax
8010562b:	68 68 87 10 80       	push   $0x80108768
80105630:	e8 c7 ad ff ff       	call   801003fc <cprintf>
80105635:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563b:	8b 40 18             	mov    0x18(%eax),%eax
8010563e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105645:	90                   	nop
80105646:	c9                   	leave  
80105647:	c3                   	ret    

80105648 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105648:	55                   	push   %ebp
80105649:	89 e5                	mov    %esp,%ebp
8010564b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010564e:	83 ec 08             	sub    $0x8,%esp
80105651:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105654:	50                   	push   %eax
80105655:	ff 75 08             	pushl  0x8(%ebp)
80105658:	e8 a2 fe ff ff       	call   801054ff <argint>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	79 07                	jns    8010566b <argfd+0x23>
    return -1;
80105664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105669:	eb 51                	jmp    801056bc <argfd+0x74>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010566b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566e:	85 c0                	test   %eax,%eax
80105670:	78 22                	js     80105694 <argfd+0x4c>
80105672:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105675:	83 f8 0f             	cmp    $0xf,%eax
80105678:	7f 1a                	jg     80105694 <argfd+0x4c>
8010567a:	e8 0d ec ff ff       	call   8010428c <myproc>
8010567f:	89 c2                	mov    %eax,%edx
80105681:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105684:	83 c0 08             	add    $0x8,%eax
80105687:	8b 44 82 08          	mov    0x8(%edx,%eax,4),%eax
8010568b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010568e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105692:	75 07                	jne    8010569b <argfd+0x53>
    return -1;
80105694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105699:	eb 21                	jmp    801056bc <argfd+0x74>
  if(pfd)
8010569b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010569f:	74 08                	je     801056a9 <argfd+0x61>
    *pfd = fd;
801056a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a7:	89 10                	mov    %edx,(%eax)
  if(pf)
801056a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056ad:	74 08                	je     801056b7 <argfd+0x6f>
    *pf = f;
801056af:	8b 45 10             	mov    0x10(%ebp),%eax
801056b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b5:	89 10                	mov    %edx,(%eax)
  return 0;
801056b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056bc:	c9                   	leave  
801056bd:	c3                   	ret    

801056be <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056be:	55                   	push   %ebp
801056bf:	89 e5                	mov    %esp,%ebp
801056c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801056c4:	e8 c3 eb ff ff       	call   8010428c <myproc>
801056c9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801056cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801056d3:	eb 2a                	jmp    801056ff <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801056d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056db:	83 c2 08             	add    $0x8,%edx
801056de:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056e2:	85 c0                	test   %eax,%eax
801056e4:	75 15                	jne    801056fb <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801056e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056ec:	8d 4a 08             	lea    0x8(%edx),%ecx
801056ef:	8b 55 08             	mov    0x8(%ebp),%edx
801056f2:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801056f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f9:	eb 0f                	jmp    8010570a <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
801056fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801056ff:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105703:	7e d0                	jle    801056d5 <fdalloc+0x17>
    }
  }
  return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    

8010570c <sys_dup>:

int
sys_dup(void)
{
8010570c:	55                   	push   %ebp
8010570d:	89 e5                	mov    %esp,%ebp
8010570f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105712:	83 ec 04             	sub    $0x4,%esp
80105715:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105718:	50                   	push   %eax
80105719:	6a 00                	push   $0x0
8010571b:	6a 00                	push   $0x0
8010571d:	e8 26 ff ff ff       	call   80105648 <argfd>
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	85 c0                	test   %eax,%eax
80105727:	79 07                	jns    80105730 <sys_dup+0x24>
    return -1;
80105729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572e:	eb 31                	jmp    80105761 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105730:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105733:	83 ec 0c             	sub    $0xc,%esp
80105736:	50                   	push   %eax
80105737:	e8 82 ff ff ff       	call   801056be <fdalloc>
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105746:	79 07                	jns    8010574f <sys_dup+0x43>
    return -1;
80105748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574d:	eb 12                	jmp    80105761 <sys_dup+0x55>
  filedup(f);
8010574f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105752:	83 ec 0c             	sub    $0xc,%esp
80105755:	50                   	push   %eax
80105756:	e8 09 b9 ff ff       	call   80101064 <filedup>
8010575b:	83 c4 10             	add    $0x10,%esp
  return fd;
8010575e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105761:	c9                   	leave  
80105762:	c3                   	ret    

80105763 <sys_read>:

int
sys_read(void)
{
80105763:	55                   	push   %ebp
80105764:	89 e5                	mov    %esp,%ebp
80105766:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105769:	83 ec 04             	sub    $0x4,%esp
8010576c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010576f:	50                   	push   %eax
80105770:	6a 00                	push   $0x0
80105772:	6a 00                	push   $0x0
80105774:	e8 cf fe ff ff       	call   80105648 <argfd>
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	85 c0                	test   %eax,%eax
8010577e:	78 2e                	js     801057ae <sys_read+0x4b>
80105780:	83 ec 08             	sub    $0x8,%esp
80105783:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105786:	50                   	push   %eax
80105787:	6a 02                	push   $0x2
80105789:	e8 71 fd ff ff       	call   801054ff <argint>
8010578e:	83 c4 10             	add    $0x10,%esp
80105791:	85 c0                	test   %eax,%eax
80105793:	78 19                	js     801057ae <sys_read+0x4b>
80105795:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105798:	83 ec 04             	sub    $0x4,%esp
8010579b:	50                   	push   %eax
8010579c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579f:	50                   	push   %eax
801057a0:	6a 01                	push   $0x1
801057a2:	e8 85 fd ff ff       	call   8010552c <argptr>
801057a7:	83 c4 10             	add    $0x10,%esp
801057aa:	85 c0                	test   %eax,%eax
801057ac:	79 07                	jns    801057b5 <sys_read+0x52>
    return -1;
801057ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b3:	eb 17                	jmp    801057cc <sys_read+0x69>
  return fileread(f, p, n);
801057b5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057be:	83 ec 04             	sub    $0x4,%esp
801057c1:	51                   	push   %ecx
801057c2:	52                   	push   %edx
801057c3:	50                   	push   %eax
801057c4:	e8 2b ba ff ff       	call   801011f4 <fileread>
801057c9:	83 c4 10             	add    $0x10,%esp
}
801057cc:	c9                   	leave  
801057cd:	c3                   	ret    

801057ce <sys_write>:

int
sys_write(void)
{
801057ce:	55                   	push   %ebp
801057cf:	89 e5                	mov    %esp,%ebp
801057d1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057d4:	83 ec 04             	sub    $0x4,%esp
801057d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057da:	50                   	push   %eax
801057db:	6a 00                	push   $0x0
801057dd:	6a 00                	push   $0x0
801057df:	e8 64 fe ff ff       	call   80105648 <argfd>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	78 2e                	js     80105819 <sys_write+0x4b>
801057eb:	83 ec 08             	sub    $0x8,%esp
801057ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057f1:	50                   	push   %eax
801057f2:	6a 02                	push   $0x2
801057f4:	e8 06 fd ff ff       	call   801054ff <argint>
801057f9:	83 c4 10             	add    $0x10,%esp
801057fc:	85 c0                	test   %eax,%eax
801057fe:	78 19                	js     80105819 <sys_write+0x4b>
80105800:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105803:	83 ec 04             	sub    $0x4,%esp
80105806:	50                   	push   %eax
80105807:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010580a:	50                   	push   %eax
8010580b:	6a 01                	push   $0x1
8010580d:	e8 1a fd ff ff       	call   8010552c <argptr>
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	85 c0                	test   %eax,%eax
80105817:	79 07                	jns    80105820 <sys_write+0x52>
    return -1;
80105819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581e:	eb 17                	jmp    80105837 <sys_write+0x69>
  return filewrite(f, p, n);
80105820:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105823:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105829:	83 ec 04             	sub    $0x4,%esp
8010582c:	51                   	push   %ecx
8010582d:	52                   	push   %edx
8010582e:	50                   	push   %eax
8010582f:	e8 78 ba ff ff       	call   801012ac <filewrite>
80105834:	83 c4 10             	add    $0x10,%esp
}
80105837:	c9                   	leave  
80105838:	c3                   	ret    

80105839 <sys_close>:

int
sys_close(void)
{
80105839:	55                   	push   %ebp
8010583a:	89 e5                	mov    %esp,%ebp
8010583c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010583f:	83 ec 04             	sub    $0x4,%esp
80105842:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105845:	50                   	push   %eax
80105846:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105849:	50                   	push   %eax
8010584a:	6a 00                	push   $0x0
8010584c:	e8 f7 fd ff ff       	call   80105648 <argfd>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	85 c0                	test   %eax,%eax
80105856:	79 07                	jns    8010585f <sys_close+0x26>
    return -1;
80105858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585d:	eb 29                	jmp    80105888 <sys_close+0x4f>
  myproc()->ofile[fd] = 0;
8010585f:	e8 28 ea ff ff       	call   8010428c <myproc>
80105864:	89 c2                	mov    %eax,%edx
80105866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105869:	83 c0 08             	add    $0x8,%eax
8010586c:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
80105873:	00 
  fileclose(f);
80105874:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105877:	83 ec 0c             	sub    $0xc,%esp
8010587a:	50                   	push   %eax
8010587b:	e8 35 b8 ff ff       	call   801010b5 <fileclose>
80105880:	83 c4 10             	add    $0x10,%esp
  return 0;
80105883:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105888:	c9                   	leave  
80105889:	c3                   	ret    

8010588a <sys_fstat>:

int
sys_fstat(void)
{
8010588a:	55                   	push   %ebp
8010588b:	89 e5                	mov    %esp,%ebp
8010588d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105890:	83 ec 04             	sub    $0x4,%esp
80105893:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105896:	50                   	push   %eax
80105897:	6a 00                	push   $0x0
80105899:	6a 00                	push   $0x0
8010589b:	e8 a8 fd ff ff       	call   80105648 <argfd>
801058a0:	83 c4 10             	add    $0x10,%esp
801058a3:	85 c0                	test   %eax,%eax
801058a5:	78 17                	js     801058be <sys_fstat+0x34>
801058a7:	83 ec 04             	sub    $0x4,%esp
801058aa:	6a 14                	push   $0x14
801058ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058af:	50                   	push   %eax
801058b0:	6a 01                	push   $0x1
801058b2:	e8 75 fc ff ff       	call   8010552c <argptr>
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	85 c0                	test   %eax,%eax
801058bc:	79 07                	jns    801058c5 <sys_fstat+0x3b>
    return -1;
801058be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c3:	eb 13                	jmp    801058d8 <sys_fstat+0x4e>
  return filestat(f, st);
801058c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cb:	83 ec 08             	sub    $0x8,%esp
801058ce:	52                   	push   %edx
801058cf:	50                   	push   %eax
801058d0:	e8 c8 b8 ff ff       	call   8010119d <filestat>
801058d5:	83 c4 10             	add    $0x10,%esp
}
801058d8:	c9                   	leave  
801058d9:	c3                   	ret    

801058da <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801058da:	55                   	push   %ebp
801058db:	89 e5                	mov    %esp,%ebp
801058dd:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801058e6:	50                   	push   %eax
801058e7:	6a 00                	push   $0x0
801058e9:	e8 a6 fc ff ff       	call   80105594 <argstr>
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	85 c0                	test   %eax,%eax
801058f3:	78 15                	js     8010590a <sys_link+0x30>
801058f5:	83 ec 08             	sub    $0x8,%esp
801058f8:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058fb:	50                   	push   %eax
801058fc:	6a 01                	push   $0x1
801058fe:	e8 91 fc ff ff       	call   80105594 <argstr>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	79 0a                	jns    80105914 <sys_link+0x3a>
    return -1;
8010590a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590f:	e9 68 01 00 00       	jmp    80105a7c <sys_link+0x1a2>

  begin_op();
80105914:	e8 1d dc ff ff       	call   80103536 <begin_op>
  if((ip = namei(old)) == 0){
80105919:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010591c:	83 ec 0c             	sub    $0xc,%esp
8010591f:	50                   	push   %eax
80105920:	e8 2a cc ff ff       	call   8010254f <namei>
80105925:	83 c4 10             	add    $0x10,%esp
80105928:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010592b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010592f:	75 0f                	jne    80105940 <sys_link+0x66>
    end_op();
80105931:	e8 8c dc ff ff       	call   801035c2 <end_op>
    return -1;
80105936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593b:	e9 3c 01 00 00       	jmp    80105a7c <sys_link+0x1a2>
  }

  ilock(ip);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	ff 75 f4             	pushl  -0xc(%ebp)
80105946:	e8 c9 c0 ff ff       	call   80101a14 <ilock>
8010594b:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010594e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105951:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105955:	66 83 f8 01          	cmp    $0x1,%ax
80105959:	75 1d                	jne    80105978 <sys_link+0x9e>
    iunlockput(ip);
8010595b:	83 ec 0c             	sub    $0xc,%esp
8010595e:	ff 75 f4             	pushl  -0xc(%ebp)
80105961:	e8 df c2 ff ff       	call   80101c45 <iunlockput>
80105966:	83 c4 10             	add    $0x10,%esp
    end_op();
80105969:	e8 54 dc ff ff       	call   801035c2 <end_op>
    return -1;
8010596e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105973:	e9 04 01 00 00       	jmp    80105a7c <sys_link+0x1a2>
  }

  ip->nlink++;
80105978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597b:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010597f:	83 c0 01             	add    $0x1,%eax
80105982:	89 c2                	mov    %eax,%edx
80105984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105987:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010598b:	83 ec 0c             	sub    $0xc,%esp
8010598e:	ff 75 f4             	pushl  -0xc(%ebp)
80105991:	e8 a1 be ff ff       	call   80101837 <iupdate>
80105996:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105999:	83 ec 0c             	sub    $0xc,%esp
8010599c:	ff 75 f4             	pushl  -0xc(%ebp)
8010599f:	e8 83 c1 ff ff       	call   80101b27 <iunlock>
801059a4:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801059a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059aa:	83 ec 08             	sub    $0x8,%esp
801059ad:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801059b0:	52                   	push   %edx
801059b1:	50                   	push   %eax
801059b2:	e8 b4 cb ff ff       	call   8010256b <nameiparent>
801059b7:	83 c4 10             	add    $0x10,%esp
801059ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059c1:	74 71                	je     80105a34 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801059c3:	83 ec 0c             	sub    $0xc,%esp
801059c6:	ff 75 f0             	pushl  -0x10(%ebp)
801059c9:	e8 46 c0 ff ff       	call   80101a14 <ilock>
801059ce:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d4:	8b 10                	mov    (%eax),%edx
801059d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d9:	8b 00                	mov    (%eax),%eax
801059db:	39 c2                	cmp    %eax,%edx
801059dd:	75 1d                	jne    801059fc <sys_link+0x122>
801059df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e2:	8b 40 04             	mov    0x4(%eax),%eax
801059e5:	83 ec 04             	sub    $0x4,%esp
801059e8:	50                   	push   %eax
801059e9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801059ec:	50                   	push   %eax
801059ed:	ff 75 f0             	pushl  -0x10(%ebp)
801059f0:	e8 bf c8 ff ff       	call   801022b4 <dirlink>
801059f5:	83 c4 10             	add    $0x10,%esp
801059f8:	85 c0                	test   %eax,%eax
801059fa:	79 10                	jns    80105a0c <sys_link+0x132>
    iunlockput(dp);
801059fc:	83 ec 0c             	sub    $0xc,%esp
801059ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105a02:	e8 3e c2 ff ff       	call   80101c45 <iunlockput>
80105a07:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105a0a:	eb 29                	jmp    80105a35 <sys_link+0x15b>
  }
  iunlockput(dp);
80105a0c:	83 ec 0c             	sub    $0xc,%esp
80105a0f:	ff 75 f0             	pushl  -0x10(%ebp)
80105a12:	e8 2e c2 ff ff       	call   80101c45 <iunlockput>
80105a17:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105a1a:	83 ec 0c             	sub    $0xc,%esp
80105a1d:	ff 75 f4             	pushl  -0xc(%ebp)
80105a20:	e8 50 c1 ff ff       	call   80101b75 <iput>
80105a25:	83 c4 10             	add    $0x10,%esp

  end_op();
80105a28:	e8 95 db ff ff       	call   801035c2 <end_op>

  return 0;
80105a2d:	b8 00 00 00 00       	mov    $0x0,%eax
80105a32:	eb 48                	jmp    80105a7c <sys_link+0x1a2>
    goto bad;
80105a34:	90                   	nop

bad:
  ilock(ip);
80105a35:	83 ec 0c             	sub    $0xc,%esp
80105a38:	ff 75 f4             	pushl  -0xc(%ebp)
80105a3b:	e8 d4 bf ff ff       	call   80101a14 <ilock>
80105a40:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a46:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105a4a:	83 e8 01             	sub    $0x1,%eax
80105a4d:	89 c2                	mov    %eax,%edx
80105a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a52:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105a56:	83 ec 0c             	sub    $0xc,%esp
80105a59:	ff 75 f4             	pushl  -0xc(%ebp)
80105a5c:	e8 d6 bd ff ff       	call   80101837 <iupdate>
80105a61:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105a64:	83 ec 0c             	sub    $0xc,%esp
80105a67:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6a:	e8 d6 c1 ff ff       	call   80101c45 <iunlockput>
80105a6f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a72:	e8 4b db ff ff       	call   801035c2 <end_op>
  return -1;
80105a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a7c:	c9                   	leave  
80105a7d:	c3                   	ret    

80105a7e <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a7e:	55                   	push   %ebp
80105a7f:	89 e5                	mov    %esp,%ebp
80105a81:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a84:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a8b:	eb 40                	jmp    80105acd <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a90:	6a 10                	push   $0x10
80105a92:	50                   	push   %eax
80105a93:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a96:	50                   	push   %eax
80105a97:	ff 75 08             	pushl  0x8(%ebp)
80105a9a:	e8 61 c4 ff ff       	call   80101f00 <readi>
80105a9f:	83 c4 10             	add    $0x10,%esp
80105aa2:	83 f8 10             	cmp    $0x10,%eax
80105aa5:	74 0d                	je     80105ab4 <isdirempty+0x36>
      panic("isdirempty: readi");
80105aa7:	83 ec 0c             	sub    $0xc,%esp
80105aaa:	68 84 87 10 80       	push   $0x80108784
80105aaf:	e8 e8 aa ff ff       	call   8010059c <panic>
    if(de.inum != 0)
80105ab4:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105ab8:	66 85 c0             	test   %ax,%ax
80105abb:	74 07                	je     80105ac4 <isdirempty+0x46>
      return 0;
80105abd:	b8 00 00 00 00       	mov    $0x0,%eax
80105ac2:	eb 1b                	jmp    80105adf <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac7:	83 c0 10             	add    $0x10,%eax
80105aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105acd:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad0:	8b 50 58             	mov    0x58(%eax),%edx
80105ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad6:	39 c2                	cmp    %eax,%edx
80105ad8:	77 b3                	ja     80105a8d <isdirempty+0xf>
  }
  return 1;
80105ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105adf:	c9                   	leave  
80105ae0:	c3                   	ret    

80105ae1 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105ae1:	55                   	push   %ebp
80105ae2:	89 e5                	mov    %esp,%ebp
80105ae4:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ae7:	83 ec 08             	sub    $0x8,%esp
80105aea:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105aed:	50                   	push   %eax
80105aee:	6a 00                	push   $0x0
80105af0:	e8 9f fa ff ff       	call   80105594 <argstr>
80105af5:	83 c4 10             	add    $0x10,%esp
80105af8:	85 c0                	test   %eax,%eax
80105afa:	79 0a                	jns    80105b06 <sys_unlink+0x25>
    return -1;
80105afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b01:	e9 bf 01 00 00       	jmp    80105cc5 <sys_unlink+0x1e4>

  begin_op();
80105b06:	e8 2b da ff ff       	call   80103536 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b0e:	83 ec 08             	sub    $0x8,%esp
80105b11:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b14:	52                   	push   %edx
80105b15:	50                   	push   %eax
80105b16:	e8 50 ca ff ff       	call   8010256b <nameiparent>
80105b1b:	83 c4 10             	add    $0x10,%esp
80105b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b25:	75 0f                	jne    80105b36 <sys_unlink+0x55>
    end_op();
80105b27:	e8 96 da ff ff       	call   801035c2 <end_op>
    return -1;
80105b2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b31:	e9 8f 01 00 00       	jmp    80105cc5 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105b36:	83 ec 0c             	sub    $0xc,%esp
80105b39:	ff 75 f4             	pushl  -0xc(%ebp)
80105b3c:	e8 d3 be ff ff       	call   80101a14 <ilock>
80105b41:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b44:	83 ec 08             	sub    $0x8,%esp
80105b47:	68 96 87 10 80       	push   $0x80108796
80105b4c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b4f:	50                   	push   %eax
80105b50:	e8 8a c6 ff ff       	call   801021df <namecmp>
80105b55:	83 c4 10             	add    $0x10,%esp
80105b58:	85 c0                	test   %eax,%eax
80105b5a:	0f 84 49 01 00 00    	je     80105ca9 <sys_unlink+0x1c8>
80105b60:	83 ec 08             	sub    $0x8,%esp
80105b63:	68 98 87 10 80       	push   $0x80108798
80105b68:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b6b:	50                   	push   %eax
80105b6c:	e8 6e c6 ff ff       	call   801021df <namecmp>
80105b71:	83 c4 10             	add    $0x10,%esp
80105b74:	85 c0                	test   %eax,%eax
80105b76:	0f 84 2d 01 00 00    	je     80105ca9 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b7c:	83 ec 04             	sub    $0x4,%esp
80105b7f:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b82:	50                   	push   %eax
80105b83:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b86:	50                   	push   %eax
80105b87:	ff 75 f4             	pushl  -0xc(%ebp)
80105b8a:	e8 6b c6 ff ff       	call   801021fa <dirlookup>
80105b8f:	83 c4 10             	add    $0x10,%esp
80105b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b99:	0f 84 0d 01 00 00    	je     80105cac <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105b9f:	83 ec 0c             	sub    $0xc,%esp
80105ba2:	ff 75 f0             	pushl  -0x10(%ebp)
80105ba5:	e8 6a be ff ff       	call   80101a14 <ilock>
80105baa:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105bb4:	66 85 c0             	test   %ax,%ax
80105bb7:	7f 0d                	jg     80105bc6 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	68 9b 87 10 80       	push   $0x8010879b
80105bc1:	e8 d6 a9 ff ff       	call   8010059c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc9:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105bcd:	66 83 f8 01          	cmp    $0x1,%ax
80105bd1:	75 25                	jne    80105bf8 <sys_unlink+0x117>
80105bd3:	83 ec 0c             	sub    $0xc,%esp
80105bd6:	ff 75 f0             	pushl  -0x10(%ebp)
80105bd9:	e8 a0 fe ff ff       	call   80105a7e <isdirempty>
80105bde:	83 c4 10             	add    $0x10,%esp
80105be1:	85 c0                	test   %eax,%eax
80105be3:	75 13                	jne    80105bf8 <sys_unlink+0x117>
    iunlockput(ip);
80105be5:	83 ec 0c             	sub    $0xc,%esp
80105be8:	ff 75 f0             	pushl  -0x10(%ebp)
80105beb:	e8 55 c0 ff ff       	call   80101c45 <iunlockput>
80105bf0:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105bf3:	e9 b5 00 00 00       	jmp    80105cad <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105bf8:	83 ec 04             	sub    $0x4,%esp
80105bfb:	6a 10                	push   $0x10
80105bfd:	6a 00                	push   $0x0
80105bff:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c02:	50                   	push   %eax
80105c03:	e8 cb f5 ff ff       	call   801051d3 <memset>
80105c08:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c0b:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105c0e:	6a 10                	push   $0x10
80105c10:	50                   	push   %eax
80105c11:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c14:	50                   	push   %eax
80105c15:	ff 75 f4             	pushl  -0xc(%ebp)
80105c18:	e8 3a c4 ff ff       	call   80102057 <writei>
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	83 f8 10             	cmp    $0x10,%eax
80105c23:	74 0d                	je     80105c32 <sys_unlink+0x151>
    panic("unlink: writei");
80105c25:	83 ec 0c             	sub    $0xc,%esp
80105c28:	68 ad 87 10 80       	push   $0x801087ad
80105c2d:	e8 6a a9 ff ff       	call   8010059c <panic>
  if(ip->type == T_DIR){
80105c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c35:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105c39:	66 83 f8 01          	cmp    $0x1,%ax
80105c3d:	75 21                	jne    80105c60 <sys_unlink+0x17f>
    dp->nlink--;
80105c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c42:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105c46:	83 e8 01             	sub    $0x1,%eax
80105c49:	89 c2                	mov    %eax,%edx
80105c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4e:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105c52:	83 ec 0c             	sub    $0xc,%esp
80105c55:	ff 75 f4             	pushl  -0xc(%ebp)
80105c58:	e8 da bb ff ff       	call   80101837 <iupdate>
80105c5d:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	ff 75 f4             	pushl  -0xc(%ebp)
80105c66:	e8 da bf ff ff       	call   80101c45 <iunlockput>
80105c6b:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c71:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105c75:	83 e8 01             	sub    $0x1,%eax
80105c78:	89 c2                	mov    %eax,%edx
80105c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c7d:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105c81:	83 ec 0c             	sub    $0xc,%esp
80105c84:	ff 75 f0             	pushl  -0x10(%ebp)
80105c87:	e8 ab bb ff ff       	call   80101837 <iupdate>
80105c8c:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c8f:	83 ec 0c             	sub    $0xc,%esp
80105c92:	ff 75 f0             	pushl  -0x10(%ebp)
80105c95:	e8 ab bf ff ff       	call   80101c45 <iunlockput>
80105c9a:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c9d:	e8 20 d9 ff ff       	call   801035c2 <end_op>

  return 0;
80105ca2:	b8 00 00 00 00       	mov    $0x0,%eax
80105ca7:	eb 1c                	jmp    80105cc5 <sys_unlink+0x1e4>

bad:
80105ca9:	90                   	nop
80105caa:	eb 01                	jmp    80105cad <sys_unlink+0x1cc>
    goto bad;
80105cac:	90                   	nop
  iunlockput(dp);
80105cad:	83 ec 0c             	sub    $0xc,%esp
80105cb0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb3:	e8 8d bf ff ff       	call   80101c45 <iunlockput>
80105cb8:	83 c4 10             	add    $0x10,%esp
  end_op();
80105cbb:	e8 02 d9 ff ff       	call   801035c2 <end_op>
  return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    

80105cc7 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cc7:	55                   	push   %ebp
80105cc8:	89 e5                	mov    %esp,%ebp
80105cca:	83 ec 38             	sub    $0x38,%esp
80105ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105cd0:	8b 55 10             	mov    0x10(%ebp),%edx
80105cd3:	8b 45 14             	mov    0x14(%ebp),%eax
80105cd6:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105cda:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105cde:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ce2:	83 ec 08             	sub    $0x8,%esp
80105ce5:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ce8:	50                   	push   %eax
80105ce9:	ff 75 08             	pushl  0x8(%ebp)
80105cec:	e8 7a c8 ff ff       	call   8010256b <nameiparent>
80105cf1:	83 c4 10             	add    $0x10,%esp
80105cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cfb:	75 0a                	jne    80105d07 <create+0x40>
    return 0;
80105cfd:	b8 00 00 00 00       	mov    $0x0,%eax
80105d02:	e9 90 01 00 00       	jmp    80105e97 <create+0x1d0>
  ilock(dp);
80105d07:	83 ec 0c             	sub    $0xc,%esp
80105d0a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d0d:	e8 02 bd ff ff       	call   80101a14 <ilock>
80105d12:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d15:	83 ec 04             	sub    $0x4,%esp
80105d18:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d1b:	50                   	push   %eax
80105d1c:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d1f:	50                   	push   %eax
80105d20:	ff 75 f4             	pushl  -0xc(%ebp)
80105d23:	e8 d2 c4 ff ff       	call   801021fa <dirlookup>
80105d28:	83 c4 10             	add    $0x10,%esp
80105d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d32:	74 50                	je     80105d84 <create+0xbd>
    iunlockput(dp);
80105d34:	83 ec 0c             	sub    $0xc,%esp
80105d37:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3a:	e8 06 bf ff ff       	call   80101c45 <iunlockput>
80105d3f:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105d42:	83 ec 0c             	sub    $0xc,%esp
80105d45:	ff 75 f0             	pushl  -0x10(%ebp)
80105d48:	e8 c7 bc ff ff       	call   80101a14 <ilock>
80105d4d:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105d50:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d55:	75 15                	jne    80105d6c <create+0xa5>
80105d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d5e:	66 83 f8 02          	cmp    $0x2,%ax
80105d62:	75 08                	jne    80105d6c <create+0xa5>
      return ip;
80105d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d67:	e9 2b 01 00 00       	jmp    80105e97 <create+0x1d0>
    iunlockput(ip);
80105d6c:	83 ec 0c             	sub    $0xc,%esp
80105d6f:	ff 75 f0             	pushl  -0x10(%ebp)
80105d72:	e8 ce be ff ff       	call   80101c45 <iunlockput>
80105d77:	83 c4 10             	add    $0x10,%esp
    return 0;
80105d7a:	b8 00 00 00 00       	mov    $0x0,%eax
80105d7f:	e9 13 01 00 00       	jmp    80105e97 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d84:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d8b:	8b 00                	mov    (%eax),%eax
80105d8d:	83 ec 08             	sub    $0x8,%esp
80105d90:	52                   	push   %edx
80105d91:	50                   	push   %eax
80105d92:	e8 c9 b9 ff ff       	call   80101760 <ialloc>
80105d97:	83 c4 10             	add    $0x10,%esp
80105d9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105da1:	75 0d                	jne    80105db0 <create+0xe9>
    panic("create: ialloc");
80105da3:	83 ec 0c             	sub    $0xc,%esp
80105da6:	68 bc 87 10 80       	push   $0x801087bc
80105dab:	e8 ec a7 ff ff       	call   8010059c <panic>

  ilock(ip);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	ff 75 f0             	pushl  -0x10(%ebp)
80105db6:	e8 59 bc ff ff       	call   80101a14 <ilock>
80105dbb:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc1:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105dc5:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcc:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105dd0:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd7:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	ff 75 f0             	pushl  -0x10(%ebp)
80105de3:	e8 4f ba ff ff       	call   80101837 <iupdate>
80105de8:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105deb:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105df0:	75 6a                	jne    80105e5c <create+0x195>
    dp->nlink++;  // for ".."
80105df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df5:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105df9:	83 c0 01             	add    $0x1,%eax
80105dfc:	89 c2                	mov    %eax,%edx
80105dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e01:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105e05:	83 ec 0c             	sub    $0xc,%esp
80105e08:	ff 75 f4             	pushl  -0xc(%ebp)
80105e0b:	e8 27 ba ff ff       	call   80101837 <iupdate>
80105e10:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e16:	8b 40 04             	mov    0x4(%eax),%eax
80105e19:	83 ec 04             	sub    $0x4,%esp
80105e1c:	50                   	push   %eax
80105e1d:	68 96 87 10 80       	push   $0x80108796
80105e22:	ff 75 f0             	pushl  -0x10(%ebp)
80105e25:	e8 8a c4 ff ff       	call   801022b4 <dirlink>
80105e2a:	83 c4 10             	add    $0x10,%esp
80105e2d:	85 c0                	test   %eax,%eax
80105e2f:	78 1e                	js     80105e4f <create+0x188>
80105e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e34:	8b 40 04             	mov    0x4(%eax),%eax
80105e37:	83 ec 04             	sub    $0x4,%esp
80105e3a:	50                   	push   %eax
80105e3b:	68 98 87 10 80       	push   $0x80108798
80105e40:	ff 75 f0             	pushl  -0x10(%ebp)
80105e43:	e8 6c c4 ff ff       	call   801022b4 <dirlink>
80105e48:	83 c4 10             	add    $0x10,%esp
80105e4b:	85 c0                	test   %eax,%eax
80105e4d:	79 0d                	jns    80105e5c <create+0x195>
      panic("create dots");
80105e4f:	83 ec 0c             	sub    $0xc,%esp
80105e52:	68 cb 87 10 80       	push   $0x801087cb
80105e57:	e8 40 a7 ff ff       	call   8010059c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5f:	8b 40 04             	mov    0x4(%eax),%eax
80105e62:	83 ec 04             	sub    $0x4,%esp
80105e65:	50                   	push   %eax
80105e66:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e69:	50                   	push   %eax
80105e6a:	ff 75 f4             	pushl  -0xc(%ebp)
80105e6d:	e8 42 c4 ff ff       	call   801022b4 <dirlink>
80105e72:	83 c4 10             	add    $0x10,%esp
80105e75:	85 c0                	test   %eax,%eax
80105e77:	79 0d                	jns    80105e86 <create+0x1bf>
    panic("create: dirlink");
80105e79:	83 ec 0c             	sub    $0xc,%esp
80105e7c:	68 d7 87 10 80       	push   $0x801087d7
80105e81:	e8 16 a7 ff ff       	call   8010059c <panic>

  iunlockput(dp);
80105e86:	83 ec 0c             	sub    $0xc,%esp
80105e89:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8c:	e8 b4 bd ff ff       	call   80101c45 <iunlockput>
80105e91:	83 c4 10             	add    $0x10,%esp

  return ip;
80105e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e97:	c9                   	leave  
80105e98:	c3                   	ret    

80105e99 <sys_open>:

int
sys_open(void)
{
80105e99:	55                   	push   %ebp
80105e9a:	89 e5                	mov    %esp,%ebp
80105e9c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e9f:	83 ec 08             	sub    $0x8,%esp
80105ea2:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ea5:	50                   	push   %eax
80105ea6:	6a 00                	push   $0x0
80105ea8:	e8 e7 f6 ff ff       	call   80105594 <argstr>
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	85 c0                	test   %eax,%eax
80105eb2:	78 15                	js     80105ec9 <sys_open+0x30>
80105eb4:	83 ec 08             	sub    $0x8,%esp
80105eb7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eba:	50                   	push   %eax
80105ebb:	6a 01                	push   $0x1
80105ebd:	e8 3d f6 ff ff       	call   801054ff <argint>
80105ec2:	83 c4 10             	add    $0x10,%esp
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	79 0a                	jns    80105ed3 <sys_open+0x3a>
    return -1;
80105ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ece:	e9 61 01 00 00       	jmp    80106034 <sys_open+0x19b>

  begin_op();
80105ed3:	e8 5e d6 ff ff       	call   80103536 <begin_op>

  if(omode & O_CREATE){
80105ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105edb:	25 00 02 00 00       	and    $0x200,%eax
80105ee0:	85 c0                	test   %eax,%eax
80105ee2:	74 2a                	je     80105f0e <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ee7:	6a 00                	push   $0x0
80105ee9:	6a 00                	push   $0x0
80105eeb:	6a 02                	push   $0x2
80105eed:	50                   	push   %eax
80105eee:	e8 d4 fd ff ff       	call   80105cc7 <create>
80105ef3:	83 c4 10             	add    $0x10,%esp
80105ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105ef9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105efd:	75 75                	jne    80105f74 <sys_open+0xdb>
      end_op();
80105eff:	e8 be d6 ff ff       	call   801035c2 <end_op>
      return -1;
80105f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f09:	e9 26 01 00 00       	jmp    80106034 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f11:	83 ec 0c             	sub    $0xc,%esp
80105f14:	50                   	push   %eax
80105f15:	e8 35 c6 ff ff       	call   8010254f <namei>
80105f1a:	83 c4 10             	add    $0x10,%esp
80105f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f24:	75 0f                	jne    80105f35 <sys_open+0x9c>
      end_op();
80105f26:	e8 97 d6 ff ff       	call   801035c2 <end_op>
      return -1;
80105f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f30:	e9 ff 00 00 00       	jmp    80106034 <sys_open+0x19b>
    }
    ilock(ip);
80105f35:	83 ec 0c             	sub    $0xc,%esp
80105f38:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3b:	e8 d4 ba ff ff       	call   80101a14 <ilock>
80105f40:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f46:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f4a:	66 83 f8 01          	cmp    $0x1,%ax
80105f4e:	75 24                	jne    80105f74 <sys_open+0xdb>
80105f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f53:	85 c0                	test   %eax,%eax
80105f55:	74 1d                	je     80105f74 <sys_open+0xdb>
      iunlockput(ip);
80105f57:	83 ec 0c             	sub    $0xc,%esp
80105f5a:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5d:	e8 e3 bc ff ff       	call   80101c45 <iunlockput>
80105f62:	83 c4 10             	add    $0x10,%esp
      end_op();
80105f65:	e8 58 d6 ff ff       	call   801035c2 <end_op>
      return -1;
80105f6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6f:	e9 c0 00 00 00       	jmp    80106034 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f74:	e8 7e b0 ff ff       	call   80100ff7 <filealloc>
80105f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f80:	74 17                	je     80105f99 <sys_open+0x100>
80105f82:	83 ec 0c             	sub    $0xc,%esp
80105f85:	ff 75 f0             	pushl  -0x10(%ebp)
80105f88:	e8 31 f7 ff ff       	call   801056be <fdalloc>
80105f8d:	83 c4 10             	add    $0x10,%esp
80105f90:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f97:	79 2e                	jns    80105fc7 <sys_open+0x12e>
    if(f)
80105f99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f9d:	74 0e                	je     80105fad <sys_open+0x114>
      fileclose(f);
80105f9f:	83 ec 0c             	sub    $0xc,%esp
80105fa2:	ff 75 f0             	pushl  -0x10(%ebp)
80105fa5:	e8 0b b1 ff ff       	call   801010b5 <fileclose>
80105faa:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105fad:	83 ec 0c             	sub    $0xc,%esp
80105fb0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb3:	e8 8d bc ff ff       	call   80101c45 <iunlockput>
80105fb8:	83 c4 10             	add    $0x10,%esp
    end_op();
80105fbb:	e8 02 d6 ff ff       	call   801035c2 <end_op>
    return -1;
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc5:	eb 6d                	jmp    80106034 <sys_open+0x19b>
  }
  iunlock(ip);
80105fc7:	83 ec 0c             	sub    $0xc,%esp
80105fca:	ff 75 f4             	pushl  -0xc(%ebp)
80105fcd:	e8 55 bb ff ff       	call   80101b27 <iunlock>
80105fd2:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fd5:	e8 e8 d5 ff ff       	call   801035c2 <end_op>

  f->type = FD_INODE;
80105fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fdd:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fe9:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fef:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff9:	83 e0 01             	and    $0x1,%eax
80105ffc:	85 c0                	test   %eax,%eax
80105ffe:	0f 94 c0             	sete   %al
80106001:	89 c2                	mov    %eax,%edx
80106003:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106006:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010600c:	83 e0 01             	and    $0x1,%eax
8010600f:	85 c0                	test   %eax,%eax
80106011:	75 0a                	jne    8010601d <sys_open+0x184>
80106013:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106016:	83 e0 02             	and    $0x2,%eax
80106019:	85 c0                	test   %eax,%eax
8010601b:	74 07                	je     80106024 <sys_open+0x18b>
8010601d:	b8 01 00 00 00       	mov    $0x1,%eax
80106022:	eb 05                	jmp    80106029 <sys_open+0x190>
80106024:	b8 00 00 00 00       	mov    $0x0,%eax
80106029:	89 c2                	mov    %eax,%edx
8010602b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602e:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106031:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106034:	c9                   	leave  
80106035:	c3                   	ret    

80106036 <sys_mkdir>:

int
sys_mkdir(void)
{
80106036:	55                   	push   %ebp
80106037:	89 e5                	mov    %esp,%ebp
80106039:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010603c:	e8 f5 d4 ff ff       	call   80103536 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106041:	83 ec 08             	sub    $0x8,%esp
80106044:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106047:	50                   	push   %eax
80106048:	6a 00                	push   $0x0
8010604a:	e8 45 f5 ff ff       	call   80105594 <argstr>
8010604f:	83 c4 10             	add    $0x10,%esp
80106052:	85 c0                	test   %eax,%eax
80106054:	78 1b                	js     80106071 <sys_mkdir+0x3b>
80106056:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106059:	6a 00                	push   $0x0
8010605b:	6a 00                	push   $0x0
8010605d:	6a 01                	push   $0x1
8010605f:	50                   	push   %eax
80106060:	e8 62 fc ff ff       	call   80105cc7 <create>
80106065:	83 c4 10             	add    $0x10,%esp
80106068:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010606b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010606f:	75 0c                	jne    8010607d <sys_mkdir+0x47>
    end_op();
80106071:	e8 4c d5 ff ff       	call   801035c2 <end_op>
    return -1;
80106076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607b:	eb 18                	jmp    80106095 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010607d:	83 ec 0c             	sub    $0xc,%esp
80106080:	ff 75 f4             	pushl  -0xc(%ebp)
80106083:	e8 bd bb ff ff       	call   80101c45 <iunlockput>
80106088:	83 c4 10             	add    $0x10,%esp
  end_op();
8010608b:	e8 32 d5 ff ff       	call   801035c2 <end_op>
  return 0;
80106090:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106095:	c9                   	leave  
80106096:	c3                   	ret    

80106097 <sys_mknod>:

int
sys_mknod(void)
{
80106097:	55                   	push   %ebp
80106098:	89 e5                	mov    %esp,%ebp
8010609a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010609d:	e8 94 d4 ff ff       	call   80103536 <begin_op>
  if((argstr(0, &path)) < 0 ||
801060a2:	83 ec 08             	sub    $0x8,%esp
801060a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060a8:	50                   	push   %eax
801060a9:	6a 00                	push   $0x0
801060ab:	e8 e4 f4 ff ff       	call   80105594 <argstr>
801060b0:	83 c4 10             	add    $0x10,%esp
801060b3:	85 c0                	test   %eax,%eax
801060b5:	78 4f                	js     80106106 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
801060b7:	83 ec 08             	sub    $0x8,%esp
801060ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060bd:	50                   	push   %eax
801060be:	6a 01                	push   $0x1
801060c0:	e8 3a f4 ff ff       	call   801054ff <argint>
801060c5:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
801060c8:	85 c0                	test   %eax,%eax
801060ca:	78 3a                	js     80106106 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
801060cc:	83 ec 08             	sub    $0x8,%esp
801060cf:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060d2:	50                   	push   %eax
801060d3:	6a 02                	push   $0x2
801060d5:	e8 25 f4 ff ff       	call   801054ff <argint>
801060da:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
801060dd:	85 c0                	test   %eax,%eax
801060df:	78 25                	js     80106106 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
801060e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060e4:	0f bf c8             	movswl %ax,%ecx
801060e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060ea:	0f bf d0             	movswl %ax,%edx
801060ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801060f0:	51                   	push   %ecx
801060f1:	52                   	push   %edx
801060f2:	6a 03                	push   $0x3
801060f4:	50                   	push   %eax
801060f5:	e8 cd fb ff ff       	call   80105cc7 <create>
801060fa:	83 c4 10             	add    $0x10,%esp
801060fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106104:	75 0c                	jne    80106112 <sys_mknod+0x7b>
    end_op();
80106106:	e8 b7 d4 ff ff       	call   801035c2 <end_op>
    return -1;
8010610b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106110:	eb 18                	jmp    8010612a <sys_mknod+0x93>
  }
  iunlockput(ip);
80106112:	83 ec 0c             	sub    $0xc,%esp
80106115:	ff 75 f4             	pushl  -0xc(%ebp)
80106118:	e8 28 bb ff ff       	call   80101c45 <iunlockput>
8010611d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106120:	e8 9d d4 ff ff       	call   801035c2 <end_op>
  return 0;
80106125:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010612a:	c9                   	leave  
8010612b:	c3                   	ret    

8010612c <sys_chdir>:

int
sys_chdir(void)
{
8010612c:	55                   	push   %ebp
8010612d:	89 e5                	mov    %esp,%ebp
8010612f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106132:	e8 55 e1 ff ff       	call   8010428c <myproc>
80106137:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
8010613a:	e8 f7 d3 ff ff       	call   80103536 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010613f:	83 ec 08             	sub    $0x8,%esp
80106142:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106145:	50                   	push   %eax
80106146:	6a 00                	push   $0x0
80106148:	e8 47 f4 ff ff       	call   80105594 <argstr>
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	85 c0                	test   %eax,%eax
80106152:	78 18                	js     8010616c <sys_chdir+0x40>
80106154:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106157:	83 ec 0c             	sub    $0xc,%esp
8010615a:	50                   	push   %eax
8010615b:	e8 ef c3 ff ff       	call   8010254f <namei>
80106160:	83 c4 10             	add    $0x10,%esp
80106163:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106166:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010616a:	75 0c                	jne    80106178 <sys_chdir+0x4c>
    end_op();
8010616c:	e8 51 d4 ff ff       	call   801035c2 <end_op>
    return -1;
80106171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106176:	eb 68                	jmp    801061e0 <sys_chdir+0xb4>
  }
  ilock(ip);
80106178:	83 ec 0c             	sub    $0xc,%esp
8010617b:	ff 75 f0             	pushl  -0x10(%ebp)
8010617e:	e8 91 b8 ff ff       	call   80101a14 <ilock>
80106183:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106189:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010618d:	66 83 f8 01          	cmp    $0x1,%ax
80106191:	74 1a                	je     801061ad <sys_chdir+0x81>
    iunlockput(ip);
80106193:	83 ec 0c             	sub    $0xc,%esp
80106196:	ff 75 f0             	pushl  -0x10(%ebp)
80106199:	e8 a7 ba ff ff       	call   80101c45 <iunlockput>
8010619e:	83 c4 10             	add    $0x10,%esp
    end_op();
801061a1:	e8 1c d4 ff ff       	call   801035c2 <end_op>
    return -1;
801061a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ab:	eb 33                	jmp    801061e0 <sys_chdir+0xb4>
  }
  iunlock(ip);
801061ad:	83 ec 0c             	sub    $0xc,%esp
801061b0:	ff 75 f0             	pushl  -0x10(%ebp)
801061b3:	e8 6f b9 ff ff       	call   80101b27 <iunlock>
801061b8:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
801061bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061be:	8b 40 68             	mov    0x68(%eax),%eax
801061c1:	83 ec 0c             	sub    $0xc,%esp
801061c4:	50                   	push   %eax
801061c5:	e8 ab b9 ff ff       	call   80101b75 <iput>
801061ca:	83 c4 10             	add    $0x10,%esp
  end_op();
801061cd:	e8 f0 d3 ff ff       	call   801035c2 <end_op>
  curproc->cwd = ip;
801061d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801061d8:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801061db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061e0:	c9                   	leave  
801061e1:	c3                   	ret    

801061e2 <sys_exec>:

int
sys_exec(void)
{
801061e2:	55                   	push   %ebp
801061e3:	89 e5                	mov    %esp,%ebp
801061e5:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061eb:	83 ec 08             	sub    $0x8,%esp
801061ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061f1:	50                   	push   %eax
801061f2:	6a 00                	push   $0x0
801061f4:	e8 9b f3 ff ff       	call   80105594 <argstr>
801061f9:	83 c4 10             	add    $0x10,%esp
801061fc:	85 c0                	test   %eax,%eax
801061fe:	78 18                	js     80106218 <sys_exec+0x36>
80106200:	83 ec 08             	sub    $0x8,%esp
80106203:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106209:	50                   	push   %eax
8010620a:	6a 01                	push   $0x1
8010620c:	e8 ee f2 ff ff       	call   801054ff <argint>
80106211:	83 c4 10             	add    $0x10,%esp
80106214:	85 c0                	test   %eax,%eax
80106216:	79 0a                	jns    80106222 <sys_exec+0x40>
    return -1;
80106218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010621d:	e9 c6 00 00 00       	jmp    801062e8 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106222:	83 ec 04             	sub    $0x4,%esp
80106225:	68 80 00 00 00       	push   $0x80
8010622a:	6a 00                	push   $0x0
8010622c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106232:	50                   	push   %eax
80106233:	e8 9b ef ff ff       	call   801051d3 <memset>
80106238:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010623b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106245:	83 f8 1f             	cmp    $0x1f,%eax
80106248:	76 0a                	jbe    80106254 <sys_exec+0x72>
      return -1;
8010624a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624f:	e9 94 00 00 00       	jmp    801062e8 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106254:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106257:	c1 e0 02             	shl    $0x2,%eax
8010625a:	89 c2                	mov    %eax,%edx
8010625c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106262:	01 c2                	add    %eax,%edx
80106264:	83 ec 08             	sub    $0x8,%esp
80106267:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010626d:	50                   	push   %eax
8010626e:	52                   	push   %edx
8010626f:	e8 e8 f1 ff ff       	call   8010545c <fetchint>
80106274:	83 c4 10             	add    $0x10,%esp
80106277:	85 c0                	test   %eax,%eax
80106279:	79 07                	jns    80106282 <sys_exec+0xa0>
      return -1;
8010627b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106280:	eb 66                	jmp    801062e8 <sys_exec+0x106>
    if(uarg == 0){
80106282:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106288:	85 c0                	test   %eax,%eax
8010628a:	75 27                	jne    801062b3 <sys_exec+0xd1>
      argv[i] = 0;
8010628c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010628f:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106296:	00 00 00 00 
      break;
8010629a:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010629b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010629e:	83 ec 08             	sub    $0x8,%esp
801062a1:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801062a7:	52                   	push   %edx
801062a8:	50                   	push   %eax
801062a9:	e8 ec a8 ff ff       	call   80100b9a <exec>
801062ae:	83 c4 10             	add    $0x10,%esp
801062b1:	eb 35                	jmp    801062e8 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
801062b3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062bc:	c1 e2 02             	shl    $0x2,%edx
801062bf:	01 c2                	add    %eax,%edx
801062c1:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062c7:	83 ec 08             	sub    $0x8,%esp
801062ca:	52                   	push   %edx
801062cb:	50                   	push   %eax
801062cc:	e8 ca f1 ff ff       	call   8010549b <fetchstr>
801062d1:	83 c4 10             	add    $0x10,%esp
801062d4:	85 c0                	test   %eax,%eax
801062d6:	79 07                	jns    801062df <sys_exec+0xfd>
      return -1;
801062d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062dd:	eb 09                	jmp    801062e8 <sys_exec+0x106>
  for(i=0;; i++){
801062df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
801062e3:	e9 5a ff ff ff       	jmp    80106242 <sys_exec+0x60>
}
801062e8:	c9                   	leave  
801062e9:	c3                   	ret    

801062ea <sys_pipe>:

int
sys_pipe(void)
{
801062ea:	55                   	push   %ebp
801062eb:	89 e5                	mov    %esp,%ebp
801062ed:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062f0:	83 ec 04             	sub    $0x4,%esp
801062f3:	6a 08                	push   $0x8
801062f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062f8:	50                   	push   %eax
801062f9:	6a 00                	push   $0x0
801062fb:	e8 2c f2 ff ff       	call   8010552c <argptr>
80106300:	83 c4 10             	add    $0x10,%esp
80106303:	85 c0                	test   %eax,%eax
80106305:	79 0a                	jns    80106311 <sys_pipe+0x27>
    return -1;
80106307:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010630c:	e9 b0 00 00 00       	jmp    801063c1 <sys_pipe+0xd7>
  if(pipealloc(&rf, &wf) < 0)
80106311:	83 ec 08             	sub    $0x8,%esp
80106314:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106317:	50                   	push   %eax
80106318:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010631b:	50                   	push   %eax
8010631c:	e8 9f da ff ff       	call   80103dc0 <pipealloc>
80106321:	83 c4 10             	add    $0x10,%esp
80106324:	85 c0                	test   %eax,%eax
80106326:	79 0a                	jns    80106332 <sys_pipe+0x48>
    return -1;
80106328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010632d:	e9 8f 00 00 00       	jmp    801063c1 <sys_pipe+0xd7>
  fd0 = -1;
80106332:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106339:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010633c:	83 ec 0c             	sub    $0xc,%esp
8010633f:	50                   	push   %eax
80106340:	e8 79 f3 ff ff       	call   801056be <fdalloc>
80106345:	83 c4 10             	add    $0x10,%esp
80106348:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010634b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010634f:	78 18                	js     80106369 <sys_pipe+0x7f>
80106351:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106354:	83 ec 0c             	sub    $0xc,%esp
80106357:	50                   	push   %eax
80106358:	e8 61 f3 ff ff       	call   801056be <fdalloc>
8010635d:	83 c4 10             	add    $0x10,%esp
80106360:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106363:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106367:	79 40                	jns    801063a9 <sys_pipe+0xbf>
    if(fd0 >= 0)
80106369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010636d:	78 15                	js     80106384 <sys_pipe+0x9a>
      myproc()->ofile[fd0] = 0;
8010636f:	e8 18 df ff ff       	call   8010428c <myproc>
80106374:	89 c2                	mov    %eax,%edx
80106376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106379:	83 c0 08             	add    $0x8,%eax
8010637c:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
80106383:	00 
    fileclose(rf);
80106384:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106387:	83 ec 0c             	sub    $0xc,%esp
8010638a:	50                   	push   %eax
8010638b:	e8 25 ad ff ff       	call   801010b5 <fileclose>
80106390:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106396:	83 ec 0c             	sub    $0xc,%esp
80106399:	50                   	push   %eax
8010639a:	e8 16 ad ff ff       	call   801010b5 <fileclose>
8010639f:	83 c4 10             	add    $0x10,%esp
    return -1;
801063a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a7:	eb 18                	jmp    801063c1 <sys_pipe+0xd7>
  }
  fd[0] = fd0;
801063a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063af:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801063b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063b4:	8d 50 04             	lea    0x4(%eax),%edx
801063b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ba:	89 02                	mov    %eax,(%edx)
  return 0;
801063bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063c1:	c9                   	leave  
801063c2:	c3                   	ret    

801063c3 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063c3:	55                   	push   %ebp
801063c4:	89 e5                	mov    %esp,%ebp
801063c6:	83 ec 08             	sub    $0x8,%esp
  return fork();
801063c9:	e8 c3 e1 ff ff       	call   80104591 <fork>
}
801063ce:	c9                   	leave  
801063cf:	c3                   	ret    

801063d0 <sys_exit>:

int
sys_exit(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801063d6:	e8 35 e3 ff ff       	call   80104710 <exit>
  return 0;  // not reached
801063db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063e0:	c9                   	leave  
801063e1:	c3                   	ret    

801063e2 <sys_wait>:

int
sys_wait(void)
{
801063e2:	55                   	push   %ebp
801063e3:	89 e5                	mov    %esp,%ebp
801063e5:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063e8:	e8 43 e4 ff ff       	call   80104830 <wait>
}
801063ed:	c9                   	leave  
801063ee:	c3                   	ret    

801063ef <sys_kill>:

int
sys_kill(void)
{
801063ef:	55                   	push   %ebp
801063f0:	89 e5                	mov    %esp,%ebp
801063f2:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063f5:	83 ec 08             	sub    $0x8,%esp
801063f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063fb:	50                   	push   %eax
801063fc:	6a 00                	push   $0x0
801063fe:	e8 fc f0 ff ff       	call   801054ff <argint>
80106403:	83 c4 10             	add    $0x10,%esp
80106406:	85 c0                	test   %eax,%eax
80106408:	79 07                	jns    80106411 <sys_kill+0x22>
    return -1;
8010640a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640f:	eb 0f                	jmp    80106420 <sys_kill+0x31>
  return kill(pid);
80106411:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106414:	83 ec 0c             	sub    $0xc,%esp
80106417:	50                   	push   %eax
80106418:	e8 43 e8 ff ff       	call   80104c60 <kill>
8010641d:	83 c4 10             	add    $0x10,%esp
}
80106420:	c9                   	leave  
80106421:	c3                   	ret    

80106422 <sys_getpid>:

int
sys_getpid(void)
{
80106422:	55                   	push   %ebp
80106423:	89 e5                	mov    %esp,%ebp
80106425:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106428:	e8 5f de ff ff       	call   8010428c <myproc>
8010642d:	8b 40 10             	mov    0x10(%eax),%eax
}
80106430:	c9                   	leave  
80106431:	c3                   	ret    

80106432 <sys_sbrk>:

int
sys_sbrk(void)
{
80106432:	55                   	push   %ebp
80106433:	89 e5                	mov    %esp,%ebp
80106435:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106438:	83 ec 08             	sub    $0x8,%esp
8010643b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010643e:	50                   	push   %eax
8010643f:	6a 00                	push   $0x0
80106441:	e8 b9 f0 ff ff       	call   801054ff <argint>
80106446:	83 c4 10             	add    $0x10,%esp
80106449:	85 c0                	test   %eax,%eax
8010644b:	79 07                	jns    80106454 <sys_sbrk+0x22>
    return -1;
8010644d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106452:	eb 27                	jmp    8010647b <sys_sbrk+0x49>
  addr = myproc()->sz;
80106454:	e8 33 de ff ff       	call   8010428c <myproc>
80106459:	8b 00                	mov    (%eax),%eax
8010645b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010645e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106461:	83 ec 0c             	sub    $0xc,%esp
80106464:	50                   	push   %eax
80106465:	e8 8c e0 ff ff       	call   801044f6 <growproc>
8010646a:	83 c4 10             	add    $0x10,%esp
8010646d:	85 c0                	test   %eax,%eax
8010646f:	79 07                	jns    80106478 <sys_sbrk+0x46>
    return -1;
80106471:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106476:	eb 03                	jmp    8010647b <sys_sbrk+0x49>
  return addr;
80106478:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010647b:	c9                   	leave  
8010647c:	c3                   	ret    

8010647d <sys_sleep>:

int
sys_sleep(void)
{
8010647d:	55                   	push   %ebp
8010647e:	89 e5                	mov    %esp,%ebp
80106480:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106483:	83 ec 08             	sub    $0x8,%esp
80106486:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106489:	50                   	push   %eax
8010648a:	6a 00                	push   $0x0
8010648c:	e8 6e f0 ff ff       	call   801054ff <argint>
80106491:	83 c4 10             	add    $0x10,%esp
80106494:	85 c0                	test   %eax,%eax
80106496:	79 07                	jns    8010649f <sys_sleep+0x22>
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649d:	eb 76                	jmp    80106515 <sys_sleep+0x98>
  acquire(&tickslock);
8010649f:	83 ec 0c             	sub    $0xc,%esp
801064a2:	68 e0 5c 11 80       	push   $0x80115ce0
801064a7:	e8 b0 ea ff ff       	call   80104f5c <acquire>
801064ac:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064af:	a1 20 65 11 80       	mov    0x80116520,%eax
801064b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064b7:	eb 38                	jmp    801064f1 <sys_sleep+0x74>
    if(myproc()->killed){
801064b9:	e8 ce dd ff ff       	call   8010428c <myproc>
801064be:	8b 40 24             	mov    0x24(%eax),%eax
801064c1:	85 c0                	test   %eax,%eax
801064c3:	74 17                	je     801064dc <sys_sleep+0x5f>
      release(&tickslock);
801064c5:	83 ec 0c             	sub    $0xc,%esp
801064c8:	68 e0 5c 11 80       	push   $0x80115ce0
801064cd:	e8 f8 ea ff ff       	call   80104fca <release>
801064d2:	83 c4 10             	add    $0x10,%esp
      return -1;
801064d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064da:	eb 39                	jmp    80106515 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
801064dc:	83 ec 08             	sub    $0x8,%esp
801064df:	68 e0 5c 11 80       	push   $0x80115ce0
801064e4:	68 20 65 11 80       	push   $0x80116520
801064e9:	e8 55 e6 ff ff       	call   80104b43 <sleep>
801064ee:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
801064f1:	a1 20 65 11 80       	mov    0x80116520,%eax
801064f6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801064f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064fc:	39 d0                	cmp    %edx,%eax
801064fe:	72 b9                	jb     801064b9 <sys_sleep+0x3c>
  }
  release(&tickslock);
80106500:	83 ec 0c             	sub    $0xc,%esp
80106503:	68 e0 5c 11 80       	push   $0x80115ce0
80106508:	e8 bd ea ff ff       	call   80104fca <release>
8010650d:	83 c4 10             	add    $0x10,%esp
  return 0;
80106510:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106515:	c9                   	leave  
80106516:	c3                   	ret    

80106517 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106517:	55                   	push   %ebp
80106518:	89 e5                	mov    %esp,%ebp
8010651a:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
8010651d:	83 ec 0c             	sub    $0xc,%esp
80106520:	68 e0 5c 11 80       	push   $0x80115ce0
80106525:	e8 32 ea ff ff       	call   80104f5c <acquire>
8010652a:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010652d:	a1 20 65 11 80       	mov    0x80116520,%eax
80106532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106535:	83 ec 0c             	sub    $0xc,%esp
80106538:	68 e0 5c 11 80       	push   $0x80115ce0
8010653d:	e8 88 ea ff ff       	call   80104fca <release>
80106542:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106545:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106548:	c9                   	leave  
80106549:	c3                   	ret    

8010654a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010654a:	1e                   	push   %ds
  pushl %es
8010654b:	06                   	push   %es
  pushl %fs
8010654c:	0f a0                	push   %fs
  pushl %gs
8010654e:	0f a8                	push   %gs
  pushal
80106550:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106551:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106555:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106557:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106559:	54                   	push   %esp
  call trap
8010655a:	e8 d7 01 00 00       	call   80106736 <trap>
  addl $4, %esp
8010655f:	83 c4 04             	add    $0x4,%esp

80106562 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106562:	61                   	popa   
  popl %gs
80106563:	0f a9                	pop    %gs
  popl %fs
80106565:	0f a1                	pop    %fs
  popl %es
80106567:	07                   	pop    %es
  popl %ds
80106568:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106569:	83 c4 08             	add    $0x8,%esp
  iret
8010656c:	cf                   	iret   

8010656d <lidt>:
{
8010656d:	55                   	push   %ebp
8010656e:	89 e5                	mov    %esp,%ebp
80106570:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106573:	8b 45 0c             	mov    0xc(%ebp),%eax
80106576:	83 e8 01             	sub    $0x1,%eax
80106579:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010657d:	8b 45 08             	mov    0x8(%ebp),%eax
80106580:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106584:	8b 45 08             	mov    0x8(%ebp),%eax
80106587:	c1 e8 10             	shr    $0x10,%eax
8010658a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010658e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106591:	0f 01 18             	lidtl  (%eax)
}
80106594:	90                   	nop
80106595:	c9                   	leave  
80106596:	c3                   	ret    

80106597 <rcr2>:

static inline uint
rcr2(void)
{
80106597:	55                   	push   %ebp
80106598:	89 e5                	mov    %esp,%ebp
8010659a:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010659d:	0f 20 d0             	mov    %cr2,%eax
801065a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801065a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065a6:	c9                   	leave  
801065a7:	c3                   	ret    

801065a8 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801065a8:	55                   	push   %ebp
801065a9:	89 e5                	mov    %esp,%ebp
801065ab:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801065ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065b5:	e9 c3 00 00 00       	jmp    8010667d <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801065ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065bd:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
801065c4:	89 c2                	mov    %eax,%edx
801065c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c9:	66 89 14 c5 20 5d 11 	mov    %dx,-0x7feea2e0(,%eax,8)
801065d0:	80 
801065d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d4:	66 c7 04 c5 22 5d 11 	movw   $0x8,-0x7feea2de(,%eax,8)
801065db:	80 08 00 
801065de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e1:	0f b6 14 c5 24 5d 11 	movzbl -0x7feea2dc(,%eax,8),%edx
801065e8:	80 
801065e9:	83 e2 e0             	and    $0xffffffe0,%edx
801065ec:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
801065f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f6:	0f b6 14 c5 24 5d 11 	movzbl -0x7feea2dc(,%eax,8),%edx
801065fd:	80 
801065fe:	83 e2 1f             	and    $0x1f,%edx
80106601:	88 14 c5 24 5d 11 80 	mov    %dl,-0x7feea2dc(,%eax,8)
80106608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660b:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
80106612:	80 
80106613:	83 e2 f0             	and    $0xfffffff0,%edx
80106616:	83 ca 0e             	or     $0xe,%edx
80106619:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
80106620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106623:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
8010662a:	80 
8010662b:	83 e2 ef             	and    $0xffffffef,%edx
8010662e:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
80106635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106638:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
8010663f:	80 
80106640:	83 e2 9f             	and    $0xffffff9f,%edx
80106643:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
8010664a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664d:	0f b6 14 c5 25 5d 11 	movzbl -0x7feea2db(,%eax,8),%edx
80106654:	80 
80106655:	83 ca 80             	or     $0xffffff80,%edx
80106658:	88 14 c5 25 5d 11 80 	mov    %dl,-0x7feea2db(,%eax,8)
8010665f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106662:	8b 04 85 78 b0 10 80 	mov    -0x7fef4f88(,%eax,4),%eax
80106669:	c1 e8 10             	shr    $0x10,%eax
8010666c:	89 c2                	mov    %eax,%edx
8010666e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106671:	66 89 14 c5 26 5d 11 	mov    %dx,-0x7feea2da(,%eax,8)
80106678:	80 
  for(i = 0; i < 256; i++)
80106679:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010667d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106684:	0f 8e 30 ff ff ff    	jle    801065ba <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010668a:	a1 78 b1 10 80       	mov    0x8010b178,%eax
8010668f:	66 a3 20 5f 11 80    	mov    %ax,0x80115f20
80106695:	66 c7 05 22 5f 11 80 	movw   $0x8,0x80115f22
8010669c:	08 00 
8010669e:	0f b6 05 24 5f 11 80 	movzbl 0x80115f24,%eax
801066a5:	83 e0 e0             	and    $0xffffffe0,%eax
801066a8:	a2 24 5f 11 80       	mov    %al,0x80115f24
801066ad:	0f b6 05 24 5f 11 80 	movzbl 0x80115f24,%eax
801066b4:	83 e0 1f             	and    $0x1f,%eax
801066b7:	a2 24 5f 11 80       	mov    %al,0x80115f24
801066bc:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
801066c3:	83 c8 0f             	or     $0xf,%eax
801066c6:	a2 25 5f 11 80       	mov    %al,0x80115f25
801066cb:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
801066d2:	83 e0 ef             	and    $0xffffffef,%eax
801066d5:	a2 25 5f 11 80       	mov    %al,0x80115f25
801066da:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
801066e1:	83 c8 60             	or     $0x60,%eax
801066e4:	a2 25 5f 11 80       	mov    %al,0x80115f25
801066e9:	0f b6 05 25 5f 11 80 	movzbl 0x80115f25,%eax
801066f0:	83 c8 80             	or     $0xffffff80,%eax
801066f3:	a2 25 5f 11 80       	mov    %al,0x80115f25
801066f8:	a1 78 b1 10 80       	mov    0x8010b178,%eax
801066fd:	c1 e8 10             	shr    $0x10,%eax
80106700:	66 a3 26 5f 11 80    	mov    %ax,0x80115f26

  initlock(&tickslock, "time");
80106706:	83 ec 08             	sub    $0x8,%esp
80106709:	68 e8 87 10 80       	push   $0x801087e8
8010670e:	68 e0 5c 11 80       	push   $0x80115ce0
80106713:	e8 22 e8 ff ff       	call   80104f3a <initlock>
80106718:	83 c4 10             	add    $0x10,%esp
}
8010671b:	90                   	nop
8010671c:	c9                   	leave  
8010671d:	c3                   	ret    

8010671e <idtinit>:

void
idtinit(void)
{
8010671e:	55                   	push   %ebp
8010671f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106721:	68 00 08 00 00       	push   $0x800
80106726:	68 20 5d 11 80       	push   $0x80115d20
8010672b:	e8 3d fe ff ff       	call   8010656d <lidt>
80106730:	83 c4 08             	add    $0x8,%esp
}
80106733:	90                   	nop
80106734:	c9                   	leave  
80106735:	c3                   	ret    

80106736 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106736:	55                   	push   %ebp
80106737:	89 e5                	mov    %esp,%ebp
80106739:	57                   	push   %edi
8010673a:	56                   	push   %esi
8010673b:	53                   	push   %ebx
8010673c:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010673f:	8b 45 08             	mov    0x8(%ebp),%eax
80106742:	8b 40 30             	mov    0x30(%eax),%eax
80106745:	83 f8 40             	cmp    $0x40,%eax
80106748:	75 3d                	jne    80106787 <trap+0x51>
    if(myproc()->killed)
8010674a:	e8 3d db ff ff       	call   8010428c <myproc>
8010674f:	8b 40 24             	mov    0x24(%eax),%eax
80106752:	85 c0                	test   %eax,%eax
80106754:	74 05                	je     8010675b <trap+0x25>
      exit();
80106756:	e8 b5 df ff ff       	call   80104710 <exit>
    myproc()->tf = tf;
8010675b:	e8 2c db ff ff       	call   8010428c <myproc>
80106760:	89 c2                	mov    %eax,%edx
80106762:	8b 45 08             	mov    0x8(%ebp),%eax
80106765:	89 42 18             	mov    %eax,0x18(%edx)
    syscall();
80106768:	e8 5e ee ff ff       	call   801055cb <syscall>
    if(myproc()->killed)
8010676d:	e8 1a db ff ff       	call   8010428c <myproc>
80106772:	8b 40 24             	mov    0x24(%eax),%eax
80106775:	85 c0                	test   %eax,%eax
80106777:	0f 84 04 02 00 00    	je     80106981 <trap+0x24b>
      exit();
8010677d:	e8 8e df ff ff       	call   80104710 <exit>
    return;
80106782:	e9 fa 01 00 00       	jmp    80106981 <trap+0x24b>
  }

  switch(tf->trapno){
80106787:	8b 45 08             	mov    0x8(%ebp),%eax
8010678a:	8b 40 30             	mov    0x30(%eax),%eax
8010678d:	83 e8 20             	sub    $0x20,%eax
80106790:	83 f8 1f             	cmp    $0x1f,%eax
80106793:	0f 87 b5 00 00 00    	ja     8010684e <trap+0x118>
80106799:	8b 04 85 90 88 10 80 	mov    -0x7fef7770(,%eax,4),%eax
801067a0:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801067a2:	e8 4c da ff ff       	call   801041f3 <cpuid>
801067a7:	85 c0                	test   %eax,%eax
801067a9:	75 3d                	jne    801067e8 <trap+0xb2>
      acquire(&tickslock);
801067ab:	83 ec 0c             	sub    $0xc,%esp
801067ae:	68 e0 5c 11 80       	push   $0x80115ce0
801067b3:	e8 a4 e7 ff ff       	call   80104f5c <acquire>
801067b8:	83 c4 10             	add    $0x10,%esp
      ticks++;
801067bb:	a1 20 65 11 80       	mov    0x80116520,%eax
801067c0:	83 c0 01             	add    $0x1,%eax
801067c3:	a3 20 65 11 80       	mov    %eax,0x80116520
      wakeup(&ticks);
801067c8:	83 ec 0c             	sub    $0xc,%esp
801067cb:	68 20 65 11 80       	push   $0x80116520
801067d0:	e8 54 e4 ff ff       	call   80104c29 <wakeup>
801067d5:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801067d8:	83 ec 0c             	sub    $0xc,%esp
801067db:	68 e0 5c 11 80       	push   $0x80115ce0
801067e0:	e8 e5 e7 ff ff       	call   80104fca <release>
801067e5:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801067e8:	e8 1f c8 ff ff       	call   8010300c <lapiceoi>
    break;
801067ed:	e9 0f 01 00 00       	jmp    80106901 <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801067f2:	e8 8f c0 ff ff       	call   80102886 <ideintr>
    lapiceoi();
801067f7:	e8 10 c8 ff ff       	call   8010300c <lapiceoi>
    break;
801067fc:	e9 00 01 00 00       	jmp    80106901 <trap+0x1cb>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106801:	e8 4f c6 ff ff       	call   80102e55 <kbdintr>
    lapiceoi();
80106806:	e8 01 c8 ff ff       	call   8010300c <lapiceoi>
    break;
8010680b:	e9 f1 00 00 00       	jmp    80106901 <trap+0x1cb>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106810:	e8 40 03 00 00       	call   80106b55 <uartintr>
    lapiceoi();
80106815:	e8 f2 c7 ff ff       	call   8010300c <lapiceoi>
    break;
8010681a:	e9 e2 00 00 00       	jmp    80106901 <trap+0x1cb>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010681f:	8b 45 08             	mov    0x8(%ebp),%eax
80106822:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106825:	8b 45 08             	mov    0x8(%ebp),%eax
80106828:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010682c:	0f b7 d8             	movzwl %ax,%ebx
8010682f:	e8 bf d9 ff ff       	call   801041f3 <cpuid>
80106834:	56                   	push   %esi
80106835:	53                   	push   %ebx
80106836:	50                   	push   %eax
80106837:	68 f0 87 10 80       	push   $0x801087f0
8010683c:	e8 bb 9b ff ff       	call   801003fc <cprintf>
80106841:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106844:	e8 c3 c7 ff ff       	call   8010300c <lapiceoi>
    break;
80106849:	e9 b3 00 00 00       	jmp    80106901 <trap+0x1cb>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010684e:	e8 39 da ff ff       	call   8010428c <myproc>
80106853:	85 c0                	test   %eax,%eax
80106855:	74 11                	je     80106868 <trap+0x132>
80106857:	8b 45 08             	mov    0x8(%ebp),%eax
8010685a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010685e:	0f b7 c0             	movzwl %ax,%eax
80106861:	83 e0 03             	and    $0x3,%eax
80106864:	85 c0                	test   %eax,%eax
80106866:	75 3b                	jne    801068a3 <trap+0x16d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106868:	e8 2a fd ff ff       	call   80106597 <rcr2>
8010686d:	89 c6                	mov    %eax,%esi
8010686f:	8b 45 08             	mov    0x8(%ebp),%eax
80106872:	8b 58 38             	mov    0x38(%eax),%ebx
80106875:	e8 79 d9 ff ff       	call   801041f3 <cpuid>
8010687a:	89 c2                	mov    %eax,%edx
8010687c:	8b 45 08             	mov    0x8(%ebp),%eax
8010687f:	8b 40 30             	mov    0x30(%eax),%eax
80106882:	83 ec 0c             	sub    $0xc,%esp
80106885:	56                   	push   %esi
80106886:	53                   	push   %ebx
80106887:	52                   	push   %edx
80106888:	50                   	push   %eax
80106889:	68 14 88 10 80       	push   $0x80108814
8010688e:	e8 69 9b ff ff       	call   801003fc <cprintf>
80106893:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106896:	83 ec 0c             	sub    $0xc,%esp
80106899:	68 46 88 10 80       	push   $0x80108846
8010689e:	e8 f9 9c ff ff       	call   8010059c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068a3:	e8 ef fc ff ff       	call   80106597 <rcr2>
801068a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068ab:	8b 45 08             	mov    0x8(%ebp),%eax
801068ae:	8b 78 38             	mov    0x38(%eax),%edi
801068b1:	e8 3d d9 ff ff       	call   801041f3 <cpuid>
801068b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068b9:	8b 45 08             	mov    0x8(%ebp),%eax
801068bc:	8b 70 34             	mov    0x34(%eax),%esi
801068bf:	8b 45 08             	mov    0x8(%ebp),%eax
801068c2:	8b 58 30             	mov    0x30(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801068c5:	e8 c2 d9 ff ff       	call   8010428c <myproc>
801068ca:	8d 48 6c             	lea    0x6c(%eax),%ecx
801068cd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801068d0:	e8 b7 d9 ff ff       	call   8010428c <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068d5:	8b 40 10             	mov    0x10(%eax),%eax
801068d8:	ff 75 e4             	pushl  -0x1c(%ebp)
801068db:	57                   	push   %edi
801068dc:	ff 75 e0             	pushl  -0x20(%ebp)
801068df:	56                   	push   %esi
801068e0:	53                   	push   %ebx
801068e1:	ff 75 dc             	pushl  -0x24(%ebp)
801068e4:	50                   	push   %eax
801068e5:	68 4c 88 10 80       	push   $0x8010884c
801068ea:	e8 0d 9b ff ff       	call   801003fc <cprintf>
801068ef:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801068f2:	e8 95 d9 ff ff       	call   8010428c <myproc>
801068f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801068fe:	eb 01                	jmp    80106901 <trap+0x1cb>
    break;
80106900:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106901:	e8 86 d9 ff ff       	call   8010428c <myproc>
80106906:	85 c0                	test   %eax,%eax
80106908:	74 23                	je     8010692d <trap+0x1f7>
8010690a:	e8 7d d9 ff ff       	call   8010428c <myproc>
8010690f:	8b 40 24             	mov    0x24(%eax),%eax
80106912:	85 c0                	test   %eax,%eax
80106914:	74 17                	je     8010692d <trap+0x1f7>
80106916:	8b 45 08             	mov    0x8(%ebp),%eax
80106919:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010691d:	0f b7 c0             	movzwl %ax,%eax
80106920:	83 e0 03             	and    $0x3,%eax
80106923:	83 f8 03             	cmp    $0x3,%eax
80106926:	75 05                	jne    8010692d <trap+0x1f7>
    exit();
80106928:	e8 e3 dd ff ff       	call   80104710 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010692d:	e8 5a d9 ff ff       	call   8010428c <myproc>
80106932:	85 c0                	test   %eax,%eax
80106934:	74 1d                	je     80106953 <trap+0x21d>
80106936:	e8 51 d9 ff ff       	call   8010428c <myproc>
8010693b:	8b 40 0c             	mov    0xc(%eax),%eax
8010693e:	83 f8 04             	cmp    $0x4,%eax
80106941:	75 10                	jne    80106953 <trap+0x21d>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106943:	8b 45 08             	mov    0x8(%ebp),%eax
80106946:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106949:	83 f8 20             	cmp    $0x20,%eax
8010694c:	75 05                	jne    80106953 <trap+0x21d>
    yield();
8010694e:	e8 70 e1 ff ff       	call   80104ac3 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106953:	e8 34 d9 ff ff       	call   8010428c <myproc>
80106958:	85 c0                	test   %eax,%eax
8010695a:	74 26                	je     80106982 <trap+0x24c>
8010695c:	e8 2b d9 ff ff       	call   8010428c <myproc>
80106961:	8b 40 24             	mov    0x24(%eax),%eax
80106964:	85 c0                	test   %eax,%eax
80106966:	74 1a                	je     80106982 <trap+0x24c>
80106968:	8b 45 08             	mov    0x8(%ebp),%eax
8010696b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010696f:	0f b7 c0             	movzwl %ax,%eax
80106972:	83 e0 03             	and    $0x3,%eax
80106975:	83 f8 03             	cmp    $0x3,%eax
80106978:	75 08                	jne    80106982 <trap+0x24c>
    exit();
8010697a:	e8 91 dd ff ff       	call   80104710 <exit>
8010697f:	eb 01                	jmp    80106982 <trap+0x24c>
    return;
80106981:	90                   	nop
}
80106982:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret    

8010698a <inb>:
{
8010698a:	55                   	push   %ebp
8010698b:	89 e5                	mov    %esp,%ebp
8010698d:	83 ec 14             	sub    $0x14,%esp
80106990:	8b 45 08             	mov    0x8(%ebp),%eax
80106993:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106997:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010699b:	89 c2                	mov    %eax,%edx
8010699d:	ec                   	in     (%dx),%al
8010699e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801069a1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801069a5:	c9                   	leave  
801069a6:	c3                   	ret    

801069a7 <outb>:
{
801069a7:	55                   	push   %ebp
801069a8:	89 e5                	mov    %esp,%ebp
801069aa:	83 ec 08             	sub    $0x8,%esp
801069ad:	8b 55 08             	mov    0x8(%ebp),%edx
801069b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801069b3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069b7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069ba:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069be:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069c2:	ee                   	out    %al,(%dx)
}
801069c3:	90                   	nop
801069c4:	c9                   	leave  
801069c5:	c3                   	ret    

801069c6 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801069c6:	55                   	push   %ebp
801069c7:	89 e5                	mov    %esp,%ebp
801069c9:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801069cc:	6a 00                	push   $0x0
801069ce:	68 fa 03 00 00       	push   $0x3fa
801069d3:	e8 cf ff ff ff       	call   801069a7 <outb>
801069d8:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801069db:	68 80 00 00 00       	push   $0x80
801069e0:	68 fb 03 00 00       	push   $0x3fb
801069e5:	e8 bd ff ff ff       	call   801069a7 <outb>
801069ea:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801069ed:	6a 0c                	push   $0xc
801069ef:	68 f8 03 00 00       	push   $0x3f8
801069f4:	e8 ae ff ff ff       	call   801069a7 <outb>
801069f9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801069fc:	6a 00                	push   $0x0
801069fe:	68 f9 03 00 00       	push   $0x3f9
80106a03:	e8 9f ff ff ff       	call   801069a7 <outb>
80106a08:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a0b:	6a 03                	push   $0x3
80106a0d:	68 fb 03 00 00       	push   $0x3fb
80106a12:	e8 90 ff ff ff       	call   801069a7 <outb>
80106a17:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106a1a:	6a 00                	push   $0x0
80106a1c:	68 fc 03 00 00       	push   $0x3fc
80106a21:	e8 81 ff ff ff       	call   801069a7 <outb>
80106a26:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a29:	6a 01                	push   $0x1
80106a2b:	68 f9 03 00 00       	push   $0x3f9
80106a30:	e8 72 ff ff ff       	call   801069a7 <outb>
80106a35:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106a38:	68 fd 03 00 00       	push   $0x3fd
80106a3d:	e8 48 ff ff ff       	call   8010698a <inb>
80106a42:	83 c4 04             	add    $0x4,%esp
80106a45:	3c ff                	cmp    $0xff,%al
80106a47:	74 61                	je     80106aaa <uartinit+0xe4>
    return;
  uart = 1;
80106a49:	c7 05 24 b6 10 80 01 	movl   $0x1,0x8010b624
80106a50:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106a53:	68 fa 03 00 00       	push   $0x3fa
80106a58:	e8 2d ff ff ff       	call   8010698a <inb>
80106a5d:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106a60:	68 f8 03 00 00       	push   $0x3f8
80106a65:	e8 20 ff ff ff       	call   8010698a <inb>
80106a6a:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106a6d:	83 ec 08             	sub    $0x8,%esp
80106a70:	6a 00                	push   $0x0
80106a72:	6a 04                	push   $0x4
80106a74:	e8 aa c0 ff ff       	call   80102b23 <ioapicenable>
80106a79:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106a7c:	c7 45 f4 10 89 10 80 	movl   $0x80108910,-0xc(%ebp)
80106a83:	eb 19                	jmp    80106a9e <uartinit+0xd8>
    uartputc(*p);
80106a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a88:	0f b6 00             	movzbl (%eax),%eax
80106a8b:	0f be c0             	movsbl %al,%eax
80106a8e:	83 ec 0c             	sub    $0xc,%esp
80106a91:	50                   	push   %eax
80106a92:	e8 16 00 00 00       	call   80106aad <uartputc>
80106a97:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106a9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa1:	0f b6 00             	movzbl (%eax),%eax
80106aa4:	84 c0                	test   %al,%al
80106aa6:	75 dd                	jne    80106a85 <uartinit+0xbf>
80106aa8:	eb 01                	jmp    80106aab <uartinit+0xe5>
    return;
80106aaa:	90                   	nop
}
80106aab:	c9                   	leave  
80106aac:	c3                   	ret    

80106aad <uartputc>:

void
uartputc(int c)
{
80106aad:	55                   	push   %ebp
80106aae:	89 e5                	mov    %esp,%ebp
80106ab0:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106ab3:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106ab8:	85 c0                	test   %eax,%eax
80106aba:	74 53                	je     80106b0f <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106abc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ac3:	eb 11                	jmp    80106ad6 <uartputc+0x29>
    microdelay(10);
80106ac5:	83 ec 0c             	sub    $0xc,%esp
80106ac8:	6a 0a                	push   $0xa
80106aca:	e8 58 c5 ff ff       	call   80103027 <microdelay>
80106acf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ad2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ad6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106ada:	7f 1a                	jg     80106af6 <uartputc+0x49>
80106adc:	83 ec 0c             	sub    $0xc,%esp
80106adf:	68 fd 03 00 00       	push   $0x3fd
80106ae4:	e8 a1 fe ff ff       	call   8010698a <inb>
80106ae9:	83 c4 10             	add    $0x10,%esp
80106aec:	0f b6 c0             	movzbl %al,%eax
80106aef:	83 e0 20             	and    $0x20,%eax
80106af2:	85 c0                	test   %eax,%eax
80106af4:	74 cf                	je     80106ac5 <uartputc+0x18>
  outb(COM1+0, c);
80106af6:	8b 45 08             	mov    0x8(%ebp),%eax
80106af9:	0f b6 c0             	movzbl %al,%eax
80106afc:	83 ec 08             	sub    $0x8,%esp
80106aff:	50                   	push   %eax
80106b00:	68 f8 03 00 00       	push   $0x3f8
80106b05:	e8 9d fe ff ff       	call   801069a7 <outb>
80106b0a:	83 c4 10             	add    $0x10,%esp
80106b0d:	eb 01                	jmp    80106b10 <uartputc+0x63>
    return;
80106b0f:	90                   	nop
}
80106b10:	c9                   	leave  
80106b11:	c3                   	ret    

80106b12 <uartgetc>:

static int
uartgetc(void)
{
80106b12:	55                   	push   %ebp
80106b13:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b15:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106b1a:	85 c0                	test   %eax,%eax
80106b1c:	75 07                	jne    80106b25 <uartgetc+0x13>
    return -1;
80106b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b23:	eb 2e                	jmp    80106b53 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106b25:	68 fd 03 00 00       	push   $0x3fd
80106b2a:	e8 5b fe ff ff       	call   8010698a <inb>
80106b2f:	83 c4 04             	add    $0x4,%esp
80106b32:	0f b6 c0             	movzbl %al,%eax
80106b35:	83 e0 01             	and    $0x1,%eax
80106b38:	85 c0                	test   %eax,%eax
80106b3a:	75 07                	jne    80106b43 <uartgetc+0x31>
    return -1;
80106b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b41:	eb 10                	jmp    80106b53 <uartgetc+0x41>
  return inb(COM1+0);
80106b43:	68 f8 03 00 00       	push   $0x3f8
80106b48:	e8 3d fe ff ff       	call   8010698a <inb>
80106b4d:	83 c4 04             	add    $0x4,%esp
80106b50:	0f b6 c0             	movzbl %al,%eax
}
80106b53:	c9                   	leave  
80106b54:	c3                   	ret    

80106b55 <uartintr>:

void
uartintr(void)
{
80106b55:	55                   	push   %ebp
80106b56:	89 e5                	mov    %esp,%ebp
80106b58:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106b5b:	83 ec 0c             	sub    $0xc,%esp
80106b5e:	68 12 6b 10 80       	push   $0x80106b12
80106b63:	e8 c8 9c ff ff       	call   80100830 <consoleintr>
80106b68:	83 c4 10             	add    $0x10,%esp
}
80106b6b:	90                   	nop
80106b6c:	c9                   	leave  
80106b6d:	c3                   	ret    

80106b6e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $0
80106b70:	6a 00                	push   $0x0
  jmp alltraps
80106b72:	e9 d3 f9 ff ff       	jmp    8010654a <alltraps>

80106b77 <vector1>:
.globl vector1
vector1:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $1
80106b79:	6a 01                	push   $0x1
  jmp alltraps
80106b7b:	e9 ca f9 ff ff       	jmp    8010654a <alltraps>

80106b80 <vector2>:
.globl vector2
vector2:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $2
80106b82:	6a 02                	push   $0x2
  jmp alltraps
80106b84:	e9 c1 f9 ff ff       	jmp    8010654a <alltraps>

80106b89 <vector3>:
.globl vector3
vector3:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $3
80106b8b:	6a 03                	push   $0x3
  jmp alltraps
80106b8d:	e9 b8 f9 ff ff       	jmp    8010654a <alltraps>

80106b92 <vector4>:
.globl vector4
vector4:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $4
80106b94:	6a 04                	push   $0x4
  jmp alltraps
80106b96:	e9 af f9 ff ff       	jmp    8010654a <alltraps>

80106b9b <vector5>:
.globl vector5
vector5:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $5
80106b9d:	6a 05                	push   $0x5
  jmp alltraps
80106b9f:	e9 a6 f9 ff ff       	jmp    8010654a <alltraps>

80106ba4 <vector6>:
.globl vector6
vector6:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $6
80106ba6:	6a 06                	push   $0x6
  jmp alltraps
80106ba8:	e9 9d f9 ff ff       	jmp    8010654a <alltraps>

80106bad <vector7>:
.globl vector7
vector7:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $7
80106baf:	6a 07                	push   $0x7
  jmp alltraps
80106bb1:	e9 94 f9 ff ff       	jmp    8010654a <alltraps>

80106bb6 <vector8>:
.globl vector8
vector8:
  pushl $8
80106bb6:	6a 08                	push   $0x8
  jmp alltraps
80106bb8:	e9 8d f9 ff ff       	jmp    8010654a <alltraps>

80106bbd <vector9>:
.globl vector9
vector9:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $9
80106bbf:	6a 09                	push   $0x9
  jmp alltraps
80106bc1:	e9 84 f9 ff ff       	jmp    8010654a <alltraps>

80106bc6 <vector10>:
.globl vector10
vector10:
  pushl $10
80106bc6:	6a 0a                	push   $0xa
  jmp alltraps
80106bc8:	e9 7d f9 ff ff       	jmp    8010654a <alltraps>

80106bcd <vector11>:
.globl vector11
vector11:
  pushl $11
80106bcd:	6a 0b                	push   $0xb
  jmp alltraps
80106bcf:	e9 76 f9 ff ff       	jmp    8010654a <alltraps>

80106bd4 <vector12>:
.globl vector12
vector12:
  pushl $12
80106bd4:	6a 0c                	push   $0xc
  jmp alltraps
80106bd6:	e9 6f f9 ff ff       	jmp    8010654a <alltraps>

80106bdb <vector13>:
.globl vector13
vector13:
  pushl $13
80106bdb:	6a 0d                	push   $0xd
  jmp alltraps
80106bdd:	e9 68 f9 ff ff       	jmp    8010654a <alltraps>

80106be2 <vector14>:
.globl vector14
vector14:
  pushl $14
80106be2:	6a 0e                	push   $0xe
  jmp alltraps
80106be4:	e9 61 f9 ff ff       	jmp    8010654a <alltraps>

80106be9 <vector15>:
.globl vector15
vector15:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $15
80106beb:	6a 0f                	push   $0xf
  jmp alltraps
80106bed:	e9 58 f9 ff ff       	jmp    8010654a <alltraps>

80106bf2 <vector16>:
.globl vector16
vector16:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $16
80106bf4:	6a 10                	push   $0x10
  jmp alltraps
80106bf6:	e9 4f f9 ff ff       	jmp    8010654a <alltraps>

80106bfb <vector17>:
.globl vector17
vector17:
  pushl $17
80106bfb:	6a 11                	push   $0x11
  jmp alltraps
80106bfd:	e9 48 f9 ff ff       	jmp    8010654a <alltraps>

80106c02 <vector18>:
.globl vector18
vector18:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $18
80106c04:	6a 12                	push   $0x12
  jmp alltraps
80106c06:	e9 3f f9 ff ff       	jmp    8010654a <alltraps>

80106c0b <vector19>:
.globl vector19
vector19:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $19
80106c0d:	6a 13                	push   $0x13
  jmp alltraps
80106c0f:	e9 36 f9 ff ff       	jmp    8010654a <alltraps>

80106c14 <vector20>:
.globl vector20
vector20:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $20
80106c16:	6a 14                	push   $0x14
  jmp alltraps
80106c18:	e9 2d f9 ff ff       	jmp    8010654a <alltraps>

80106c1d <vector21>:
.globl vector21
vector21:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $21
80106c1f:	6a 15                	push   $0x15
  jmp alltraps
80106c21:	e9 24 f9 ff ff       	jmp    8010654a <alltraps>

80106c26 <vector22>:
.globl vector22
vector22:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $22
80106c28:	6a 16                	push   $0x16
  jmp alltraps
80106c2a:	e9 1b f9 ff ff       	jmp    8010654a <alltraps>

80106c2f <vector23>:
.globl vector23
vector23:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $23
80106c31:	6a 17                	push   $0x17
  jmp alltraps
80106c33:	e9 12 f9 ff ff       	jmp    8010654a <alltraps>

80106c38 <vector24>:
.globl vector24
vector24:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $24
80106c3a:	6a 18                	push   $0x18
  jmp alltraps
80106c3c:	e9 09 f9 ff ff       	jmp    8010654a <alltraps>

80106c41 <vector25>:
.globl vector25
vector25:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $25
80106c43:	6a 19                	push   $0x19
  jmp alltraps
80106c45:	e9 00 f9 ff ff       	jmp    8010654a <alltraps>

80106c4a <vector26>:
.globl vector26
vector26:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $26
80106c4c:	6a 1a                	push   $0x1a
  jmp alltraps
80106c4e:	e9 f7 f8 ff ff       	jmp    8010654a <alltraps>

80106c53 <vector27>:
.globl vector27
vector27:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $27
80106c55:	6a 1b                	push   $0x1b
  jmp alltraps
80106c57:	e9 ee f8 ff ff       	jmp    8010654a <alltraps>

80106c5c <vector28>:
.globl vector28
vector28:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $28
80106c5e:	6a 1c                	push   $0x1c
  jmp alltraps
80106c60:	e9 e5 f8 ff ff       	jmp    8010654a <alltraps>

80106c65 <vector29>:
.globl vector29
vector29:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $29
80106c67:	6a 1d                	push   $0x1d
  jmp alltraps
80106c69:	e9 dc f8 ff ff       	jmp    8010654a <alltraps>

80106c6e <vector30>:
.globl vector30
vector30:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $30
80106c70:	6a 1e                	push   $0x1e
  jmp alltraps
80106c72:	e9 d3 f8 ff ff       	jmp    8010654a <alltraps>

80106c77 <vector31>:
.globl vector31
vector31:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $31
80106c79:	6a 1f                	push   $0x1f
  jmp alltraps
80106c7b:	e9 ca f8 ff ff       	jmp    8010654a <alltraps>

80106c80 <vector32>:
.globl vector32
vector32:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $32
80106c82:	6a 20                	push   $0x20
  jmp alltraps
80106c84:	e9 c1 f8 ff ff       	jmp    8010654a <alltraps>

80106c89 <vector33>:
.globl vector33
vector33:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $33
80106c8b:	6a 21                	push   $0x21
  jmp alltraps
80106c8d:	e9 b8 f8 ff ff       	jmp    8010654a <alltraps>

80106c92 <vector34>:
.globl vector34
vector34:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $34
80106c94:	6a 22                	push   $0x22
  jmp alltraps
80106c96:	e9 af f8 ff ff       	jmp    8010654a <alltraps>

80106c9b <vector35>:
.globl vector35
vector35:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $35
80106c9d:	6a 23                	push   $0x23
  jmp alltraps
80106c9f:	e9 a6 f8 ff ff       	jmp    8010654a <alltraps>

80106ca4 <vector36>:
.globl vector36
vector36:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $36
80106ca6:	6a 24                	push   $0x24
  jmp alltraps
80106ca8:	e9 9d f8 ff ff       	jmp    8010654a <alltraps>

80106cad <vector37>:
.globl vector37
vector37:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $37
80106caf:	6a 25                	push   $0x25
  jmp alltraps
80106cb1:	e9 94 f8 ff ff       	jmp    8010654a <alltraps>

80106cb6 <vector38>:
.globl vector38
vector38:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $38
80106cb8:	6a 26                	push   $0x26
  jmp alltraps
80106cba:	e9 8b f8 ff ff       	jmp    8010654a <alltraps>

80106cbf <vector39>:
.globl vector39
vector39:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $39
80106cc1:	6a 27                	push   $0x27
  jmp alltraps
80106cc3:	e9 82 f8 ff ff       	jmp    8010654a <alltraps>

80106cc8 <vector40>:
.globl vector40
vector40:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $40
80106cca:	6a 28                	push   $0x28
  jmp alltraps
80106ccc:	e9 79 f8 ff ff       	jmp    8010654a <alltraps>

80106cd1 <vector41>:
.globl vector41
vector41:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $41
80106cd3:	6a 29                	push   $0x29
  jmp alltraps
80106cd5:	e9 70 f8 ff ff       	jmp    8010654a <alltraps>

80106cda <vector42>:
.globl vector42
vector42:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $42
80106cdc:	6a 2a                	push   $0x2a
  jmp alltraps
80106cde:	e9 67 f8 ff ff       	jmp    8010654a <alltraps>

80106ce3 <vector43>:
.globl vector43
vector43:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $43
80106ce5:	6a 2b                	push   $0x2b
  jmp alltraps
80106ce7:	e9 5e f8 ff ff       	jmp    8010654a <alltraps>

80106cec <vector44>:
.globl vector44
vector44:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $44
80106cee:	6a 2c                	push   $0x2c
  jmp alltraps
80106cf0:	e9 55 f8 ff ff       	jmp    8010654a <alltraps>

80106cf5 <vector45>:
.globl vector45
vector45:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $45
80106cf7:	6a 2d                	push   $0x2d
  jmp alltraps
80106cf9:	e9 4c f8 ff ff       	jmp    8010654a <alltraps>

80106cfe <vector46>:
.globl vector46
vector46:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $46
80106d00:	6a 2e                	push   $0x2e
  jmp alltraps
80106d02:	e9 43 f8 ff ff       	jmp    8010654a <alltraps>

80106d07 <vector47>:
.globl vector47
vector47:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $47
80106d09:	6a 2f                	push   $0x2f
  jmp alltraps
80106d0b:	e9 3a f8 ff ff       	jmp    8010654a <alltraps>

80106d10 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $48
80106d12:	6a 30                	push   $0x30
  jmp alltraps
80106d14:	e9 31 f8 ff ff       	jmp    8010654a <alltraps>

80106d19 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $49
80106d1b:	6a 31                	push   $0x31
  jmp alltraps
80106d1d:	e9 28 f8 ff ff       	jmp    8010654a <alltraps>

80106d22 <vector50>:
.globl vector50
vector50:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $50
80106d24:	6a 32                	push   $0x32
  jmp alltraps
80106d26:	e9 1f f8 ff ff       	jmp    8010654a <alltraps>

80106d2b <vector51>:
.globl vector51
vector51:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $51
80106d2d:	6a 33                	push   $0x33
  jmp alltraps
80106d2f:	e9 16 f8 ff ff       	jmp    8010654a <alltraps>

80106d34 <vector52>:
.globl vector52
vector52:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $52
80106d36:	6a 34                	push   $0x34
  jmp alltraps
80106d38:	e9 0d f8 ff ff       	jmp    8010654a <alltraps>

80106d3d <vector53>:
.globl vector53
vector53:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $53
80106d3f:	6a 35                	push   $0x35
  jmp alltraps
80106d41:	e9 04 f8 ff ff       	jmp    8010654a <alltraps>

80106d46 <vector54>:
.globl vector54
vector54:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $54
80106d48:	6a 36                	push   $0x36
  jmp alltraps
80106d4a:	e9 fb f7 ff ff       	jmp    8010654a <alltraps>

80106d4f <vector55>:
.globl vector55
vector55:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $55
80106d51:	6a 37                	push   $0x37
  jmp alltraps
80106d53:	e9 f2 f7 ff ff       	jmp    8010654a <alltraps>

80106d58 <vector56>:
.globl vector56
vector56:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $56
80106d5a:	6a 38                	push   $0x38
  jmp alltraps
80106d5c:	e9 e9 f7 ff ff       	jmp    8010654a <alltraps>

80106d61 <vector57>:
.globl vector57
vector57:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $57
80106d63:	6a 39                	push   $0x39
  jmp alltraps
80106d65:	e9 e0 f7 ff ff       	jmp    8010654a <alltraps>

80106d6a <vector58>:
.globl vector58
vector58:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $58
80106d6c:	6a 3a                	push   $0x3a
  jmp alltraps
80106d6e:	e9 d7 f7 ff ff       	jmp    8010654a <alltraps>

80106d73 <vector59>:
.globl vector59
vector59:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $59
80106d75:	6a 3b                	push   $0x3b
  jmp alltraps
80106d77:	e9 ce f7 ff ff       	jmp    8010654a <alltraps>

80106d7c <vector60>:
.globl vector60
vector60:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $60
80106d7e:	6a 3c                	push   $0x3c
  jmp alltraps
80106d80:	e9 c5 f7 ff ff       	jmp    8010654a <alltraps>

80106d85 <vector61>:
.globl vector61
vector61:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $61
80106d87:	6a 3d                	push   $0x3d
  jmp alltraps
80106d89:	e9 bc f7 ff ff       	jmp    8010654a <alltraps>

80106d8e <vector62>:
.globl vector62
vector62:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $62
80106d90:	6a 3e                	push   $0x3e
  jmp alltraps
80106d92:	e9 b3 f7 ff ff       	jmp    8010654a <alltraps>

80106d97 <vector63>:
.globl vector63
vector63:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $63
80106d99:	6a 3f                	push   $0x3f
  jmp alltraps
80106d9b:	e9 aa f7 ff ff       	jmp    8010654a <alltraps>

80106da0 <vector64>:
.globl vector64
vector64:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $64
80106da2:	6a 40                	push   $0x40
  jmp alltraps
80106da4:	e9 a1 f7 ff ff       	jmp    8010654a <alltraps>

80106da9 <vector65>:
.globl vector65
vector65:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $65
80106dab:	6a 41                	push   $0x41
  jmp alltraps
80106dad:	e9 98 f7 ff ff       	jmp    8010654a <alltraps>

80106db2 <vector66>:
.globl vector66
vector66:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $66
80106db4:	6a 42                	push   $0x42
  jmp alltraps
80106db6:	e9 8f f7 ff ff       	jmp    8010654a <alltraps>

80106dbb <vector67>:
.globl vector67
vector67:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $67
80106dbd:	6a 43                	push   $0x43
  jmp alltraps
80106dbf:	e9 86 f7 ff ff       	jmp    8010654a <alltraps>

80106dc4 <vector68>:
.globl vector68
vector68:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $68
80106dc6:	6a 44                	push   $0x44
  jmp alltraps
80106dc8:	e9 7d f7 ff ff       	jmp    8010654a <alltraps>

80106dcd <vector69>:
.globl vector69
vector69:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $69
80106dcf:	6a 45                	push   $0x45
  jmp alltraps
80106dd1:	e9 74 f7 ff ff       	jmp    8010654a <alltraps>

80106dd6 <vector70>:
.globl vector70
vector70:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $70
80106dd8:	6a 46                	push   $0x46
  jmp alltraps
80106dda:	e9 6b f7 ff ff       	jmp    8010654a <alltraps>

80106ddf <vector71>:
.globl vector71
vector71:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $71
80106de1:	6a 47                	push   $0x47
  jmp alltraps
80106de3:	e9 62 f7 ff ff       	jmp    8010654a <alltraps>

80106de8 <vector72>:
.globl vector72
vector72:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $72
80106dea:	6a 48                	push   $0x48
  jmp alltraps
80106dec:	e9 59 f7 ff ff       	jmp    8010654a <alltraps>

80106df1 <vector73>:
.globl vector73
vector73:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $73
80106df3:	6a 49                	push   $0x49
  jmp alltraps
80106df5:	e9 50 f7 ff ff       	jmp    8010654a <alltraps>

80106dfa <vector74>:
.globl vector74
vector74:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $74
80106dfc:	6a 4a                	push   $0x4a
  jmp alltraps
80106dfe:	e9 47 f7 ff ff       	jmp    8010654a <alltraps>

80106e03 <vector75>:
.globl vector75
vector75:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $75
80106e05:	6a 4b                	push   $0x4b
  jmp alltraps
80106e07:	e9 3e f7 ff ff       	jmp    8010654a <alltraps>

80106e0c <vector76>:
.globl vector76
vector76:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $76
80106e0e:	6a 4c                	push   $0x4c
  jmp alltraps
80106e10:	e9 35 f7 ff ff       	jmp    8010654a <alltraps>

80106e15 <vector77>:
.globl vector77
vector77:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $77
80106e17:	6a 4d                	push   $0x4d
  jmp alltraps
80106e19:	e9 2c f7 ff ff       	jmp    8010654a <alltraps>

80106e1e <vector78>:
.globl vector78
vector78:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $78
80106e20:	6a 4e                	push   $0x4e
  jmp alltraps
80106e22:	e9 23 f7 ff ff       	jmp    8010654a <alltraps>

80106e27 <vector79>:
.globl vector79
vector79:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $79
80106e29:	6a 4f                	push   $0x4f
  jmp alltraps
80106e2b:	e9 1a f7 ff ff       	jmp    8010654a <alltraps>

80106e30 <vector80>:
.globl vector80
vector80:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $80
80106e32:	6a 50                	push   $0x50
  jmp alltraps
80106e34:	e9 11 f7 ff ff       	jmp    8010654a <alltraps>

80106e39 <vector81>:
.globl vector81
vector81:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $81
80106e3b:	6a 51                	push   $0x51
  jmp alltraps
80106e3d:	e9 08 f7 ff ff       	jmp    8010654a <alltraps>

80106e42 <vector82>:
.globl vector82
vector82:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $82
80106e44:	6a 52                	push   $0x52
  jmp alltraps
80106e46:	e9 ff f6 ff ff       	jmp    8010654a <alltraps>

80106e4b <vector83>:
.globl vector83
vector83:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $83
80106e4d:	6a 53                	push   $0x53
  jmp alltraps
80106e4f:	e9 f6 f6 ff ff       	jmp    8010654a <alltraps>

80106e54 <vector84>:
.globl vector84
vector84:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $84
80106e56:	6a 54                	push   $0x54
  jmp alltraps
80106e58:	e9 ed f6 ff ff       	jmp    8010654a <alltraps>

80106e5d <vector85>:
.globl vector85
vector85:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $85
80106e5f:	6a 55                	push   $0x55
  jmp alltraps
80106e61:	e9 e4 f6 ff ff       	jmp    8010654a <alltraps>

80106e66 <vector86>:
.globl vector86
vector86:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $86
80106e68:	6a 56                	push   $0x56
  jmp alltraps
80106e6a:	e9 db f6 ff ff       	jmp    8010654a <alltraps>

80106e6f <vector87>:
.globl vector87
vector87:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $87
80106e71:	6a 57                	push   $0x57
  jmp alltraps
80106e73:	e9 d2 f6 ff ff       	jmp    8010654a <alltraps>

80106e78 <vector88>:
.globl vector88
vector88:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $88
80106e7a:	6a 58                	push   $0x58
  jmp alltraps
80106e7c:	e9 c9 f6 ff ff       	jmp    8010654a <alltraps>

80106e81 <vector89>:
.globl vector89
vector89:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $89
80106e83:	6a 59                	push   $0x59
  jmp alltraps
80106e85:	e9 c0 f6 ff ff       	jmp    8010654a <alltraps>

80106e8a <vector90>:
.globl vector90
vector90:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $90
80106e8c:	6a 5a                	push   $0x5a
  jmp alltraps
80106e8e:	e9 b7 f6 ff ff       	jmp    8010654a <alltraps>

80106e93 <vector91>:
.globl vector91
vector91:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $91
80106e95:	6a 5b                	push   $0x5b
  jmp alltraps
80106e97:	e9 ae f6 ff ff       	jmp    8010654a <alltraps>

80106e9c <vector92>:
.globl vector92
vector92:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $92
80106e9e:	6a 5c                	push   $0x5c
  jmp alltraps
80106ea0:	e9 a5 f6 ff ff       	jmp    8010654a <alltraps>

80106ea5 <vector93>:
.globl vector93
vector93:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $93
80106ea7:	6a 5d                	push   $0x5d
  jmp alltraps
80106ea9:	e9 9c f6 ff ff       	jmp    8010654a <alltraps>

80106eae <vector94>:
.globl vector94
vector94:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $94
80106eb0:	6a 5e                	push   $0x5e
  jmp alltraps
80106eb2:	e9 93 f6 ff ff       	jmp    8010654a <alltraps>

80106eb7 <vector95>:
.globl vector95
vector95:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $95
80106eb9:	6a 5f                	push   $0x5f
  jmp alltraps
80106ebb:	e9 8a f6 ff ff       	jmp    8010654a <alltraps>

80106ec0 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ec0:	6a 00                	push   $0x0
  pushl $96
80106ec2:	6a 60                	push   $0x60
  jmp alltraps
80106ec4:	e9 81 f6 ff ff       	jmp    8010654a <alltraps>

80106ec9 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $97
80106ecb:	6a 61                	push   $0x61
  jmp alltraps
80106ecd:	e9 78 f6 ff ff       	jmp    8010654a <alltraps>

80106ed2 <vector98>:
.globl vector98
vector98:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $98
80106ed4:	6a 62                	push   $0x62
  jmp alltraps
80106ed6:	e9 6f f6 ff ff       	jmp    8010654a <alltraps>

80106edb <vector99>:
.globl vector99
vector99:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $99
80106edd:	6a 63                	push   $0x63
  jmp alltraps
80106edf:	e9 66 f6 ff ff       	jmp    8010654a <alltraps>

80106ee4 <vector100>:
.globl vector100
vector100:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $100
80106ee6:	6a 64                	push   $0x64
  jmp alltraps
80106ee8:	e9 5d f6 ff ff       	jmp    8010654a <alltraps>

80106eed <vector101>:
.globl vector101
vector101:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $101
80106eef:	6a 65                	push   $0x65
  jmp alltraps
80106ef1:	e9 54 f6 ff ff       	jmp    8010654a <alltraps>

80106ef6 <vector102>:
.globl vector102
vector102:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $102
80106ef8:	6a 66                	push   $0x66
  jmp alltraps
80106efa:	e9 4b f6 ff ff       	jmp    8010654a <alltraps>

80106eff <vector103>:
.globl vector103
vector103:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $103
80106f01:	6a 67                	push   $0x67
  jmp alltraps
80106f03:	e9 42 f6 ff ff       	jmp    8010654a <alltraps>

80106f08 <vector104>:
.globl vector104
vector104:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $104
80106f0a:	6a 68                	push   $0x68
  jmp alltraps
80106f0c:	e9 39 f6 ff ff       	jmp    8010654a <alltraps>

80106f11 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f11:	6a 00                	push   $0x0
  pushl $105
80106f13:	6a 69                	push   $0x69
  jmp alltraps
80106f15:	e9 30 f6 ff ff       	jmp    8010654a <alltraps>

80106f1a <vector106>:
.globl vector106
vector106:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $106
80106f1c:	6a 6a                	push   $0x6a
  jmp alltraps
80106f1e:	e9 27 f6 ff ff       	jmp    8010654a <alltraps>

80106f23 <vector107>:
.globl vector107
vector107:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $107
80106f25:	6a 6b                	push   $0x6b
  jmp alltraps
80106f27:	e9 1e f6 ff ff       	jmp    8010654a <alltraps>

80106f2c <vector108>:
.globl vector108
vector108:
  pushl $0
80106f2c:	6a 00                	push   $0x0
  pushl $108
80106f2e:	6a 6c                	push   $0x6c
  jmp alltraps
80106f30:	e9 15 f6 ff ff       	jmp    8010654a <alltraps>

80106f35 <vector109>:
.globl vector109
vector109:
  pushl $0
80106f35:	6a 00                	push   $0x0
  pushl $109
80106f37:	6a 6d                	push   $0x6d
  jmp alltraps
80106f39:	e9 0c f6 ff ff       	jmp    8010654a <alltraps>

80106f3e <vector110>:
.globl vector110
vector110:
  pushl $0
80106f3e:	6a 00                	push   $0x0
  pushl $110
80106f40:	6a 6e                	push   $0x6e
  jmp alltraps
80106f42:	e9 03 f6 ff ff       	jmp    8010654a <alltraps>

80106f47 <vector111>:
.globl vector111
vector111:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $111
80106f49:	6a 6f                	push   $0x6f
  jmp alltraps
80106f4b:	e9 fa f5 ff ff       	jmp    8010654a <alltraps>

80106f50 <vector112>:
.globl vector112
vector112:
  pushl $0
80106f50:	6a 00                	push   $0x0
  pushl $112
80106f52:	6a 70                	push   $0x70
  jmp alltraps
80106f54:	e9 f1 f5 ff ff       	jmp    8010654a <alltraps>

80106f59 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $113
80106f5b:	6a 71                	push   $0x71
  jmp alltraps
80106f5d:	e9 e8 f5 ff ff       	jmp    8010654a <alltraps>

80106f62 <vector114>:
.globl vector114
vector114:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $114
80106f64:	6a 72                	push   $0x72
  jmp alltraps
80106f66:	e9 df f5 ff ff       	jmp    8010654a <alltraps>

80106f6b <vector115>:
.globl vector115
vector115:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $115
80106f6d:	6a 73                	push   $0x73
  jmp alltraps
80106f6f:	e9 d6 f5 ff ff       	jmp    8010654a <alltraps>

80106f74 <vector116>:
.globl vector116
vector116:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $116
80106f76:	6a 74                	push   $0x74
  jmp alltraps
80106f78:	e9 cd f5 ff ff       	jmp    8010654a <alltraps>

80106f7d <vector117>:
.globl vector117
vector117:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $117
80106f7f:	6a 75                	push   $0x75
  jmp alltraps
80106f81:	e9 c4 f5 ff ff       	jmp    8010654a <alltraps>

80106f86 <vector118>:
.globl vector118
vector118:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $118
80106f88:	6a 76                	push   $0x76
  jmp alltraps
80106f8a:	e9 bb f5 ff ff       	jmp    8010654a <alltraps>

80106f8f <vector119>:
.globl vector119
vector119:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $119
80106f91:	6a 77                	push   $0x77
  jmp alltraps
80106f93:	e9 b2 f5 ff ff       	jmp    8010654a <alltraps>

80106f98 <vector120>:
.globl vector120
vector120:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $120
80106f9a:	6a 78                	push   $0x78
  jmp alltraps
80106f9c:	e9 a9 f5 ff ff       	jmp    8010654a <alltraps>

80106fa1 <vector121>:
.globl vector121
vector121:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $121
80106fa3:	6a 79                	push   $0x79
  jmp alltraps
80106fa5:	e9 a0 f5 ff ff       	jmp    8010654a <alltraps>

80106faa <vector122>:
.globl vector122
vector122:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $122
80106fac:	6a 7a                	push   $0x7a
  jmp alltraps
80106fae:	e9 97 f5 ff ff       	jmp    8010654a <alltraps>

80106fb3 <vector123>:
.globl vector123
vector123:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $123
80106fb5:	6a 7b                	push   $0x7b
  jmp alltraps
80106fb7:	e9 8e f5 ff ff       	jmp    8010654a <alltraps>

80106fbc <vector124>:
.globl vector124
vector124:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $124
80106fbe:	6a 7c                	push   $0x7c
  jmp alltraps
80106fc0:	e9 85 f5 ff ff       	jmp    8010654a <alltraps>

80106fc5 <vector125>:
.globl vector125
vector125:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $125
80106fc7:	6a 7d                	push   $0x7d
  jmp alltraps
80106fc9:	e9 7c f5 ff ff       	jmp    8010654a <alltraps>

80106fce <vector126>:
.globl vector126
vector126:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $126
80106fd0:	6a 7e                	push   $0x7e
  jmp alltraps
80106fd2:	e9 73 f5 ff ff       	jmp    8010654a <alltraps>

80106fd7 <vector127>:
.globl vector127
vector127:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $127
80106fd9:	6a 7f                	push   $0x7f
  jmp alltraps
80106fdb:	e9 6a f5 ff ff       	jmp    8010654a <alltraps>

80106fe0 <vector128>:
.globl vector128
vector128:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $128
80106fe2:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106fe7:	e9 5e f5 ff ff       	jmp    8010654a <alltraps>

80106fec <vector129>:
.globl vector129
vector129:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $129
80106fee:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106ff3:	e9 52 f5 ff ff       	jmp    8010654a <alltraps>

80106ff8 <vector130>:
.globl vector130
vector130:
  pushl $0
80106ff8:	6a 00                	push   $0x0
  pushl $130
80106ffa:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106fff:	e9 46 f5 ff ff       	jmp    8010654a <alltraps>

80107004 <vector131>:
.globl vector131
vector131:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $131
80107006:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010700b:	e9 3a f5 ff ff       	jmp    8010654a <alltraps>

80107010 <vector132>:
.globl vector132
vector132:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $132
80107012:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107017:	e9 2e f5 ff ff       	jmp    8010654a <alltraps>

8010701c <vector133>:
.globl vector133
vector133:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $133
8010701e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107023:	e9 22 f5 ff ff       	jmp    8010654a <alltraps>

80107028 <vector134>:
.globl vector134
vector134:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $134
8010702a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010702f:	e9 16 f5 ff ff       	jmp    8010654a <alltraps>

80107034 <vector135>:
.globl vector135
vector135:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $135
80107036:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010703b:	e9 0a f5 ff ff       	jmp    8010654a <alltraps>

80107040 <vector136>:
.globl vector136
vector136:
  pushl $0
80107040:	6a 00                	push   $0x0
  pushl $136
80107042:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107047:	e9 fe f4 ff ff       	jmp    8010654a <alltraps>

8010704c <vector137>:
.globl vector137
vector137:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $137
8010704e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107053:	e9 f2 f4 ff ff       	jmp    8010654a <alltraps>

80107058 <vector138>:
.globl vector138
vector138:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $138
8010705a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010705f:	e9 e6 f4 ff ff       	jmp    8010654a <alltraps>

80107064 <vector139>:
.globl vector139
vector139:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $139
80107066:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010706b:	e9 da f4 ff ff       	jmp    8010654a <alltraps>

80107070 <vector140>:
.globl vector140
vector140:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $140
80107072:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107077:	e9 ce f4 ff ff       	jmp    8010654a <alltraps>

8010707c <vector141>:
.globl vector141
vector141:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $141
8010707e:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107083:	e9 c2 f4 ff ff       	jmp    8010654a <alltraps>

80107088 <vector142>:
.globl vector142
vector142:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $142
8010708a:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010708f:	e9 b6 f4 ff ff       	jmp    8010654a <alltraps>

80107094 <vector143>:
.globl vector143
vector143:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $143
80107096:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010709b:	e9 aa f4 ff ff       	jmp    8010654a <alltraps>

801070a0 <vector144>:
.globl vector144
vector144:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $144
801070a2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801070a7:	e9 9e f4 ff ff       	jmp    8010654a <alltraps>

801070ac <vector145>:
.globl vector145
vector145:
  pushl $0
801070ac:	6a 00                	push   $0x0
  pushl $145
801070ae:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801070b3:	e9 92 f4 ff ff       	jmp    8010654a <alltraps>

801070b8 <vector146>:
.globl vector146
vector146:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $146
801070ba:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801070bf:	e9 86 f4 ff ff       	jmp    8010654a <alltraps>

801070c4 <vector147>:
.globl vector147
vector147:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $147
801070c6:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801070cb:	e9 7a f4 ff ff       	jmp    8010654a <alltraps>

801070d0 <vector148>:
.globl vector148
vector148:
  pushl $0
801070d0:	6a 00                	push   $0x0
  pushl $148
801070d2:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801070d7:	e9 6e f4 ff ff       	jmp    8010654a <alltraps>

801070dc <vector149>:
.globl vector149
vector149:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $149
801070de:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801070e3:	e9 62 f4 ff ff       	jmp    8010654a <alltraps>

801070e8 <vector150>:
.globl vector150
vector150:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $150
801070ea:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801070ef:	e9 56 f4 ff ff       	jmp    8010654a <alltraps>

801070f4 <vector151>:
.globl vector151
vector151:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $151
801070f6:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801070fb:	e9 4a f4 ff ff       	jmp    8010654a <alltraps>

80107100 <vector152>:
.globl vector152
vector152:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $152
80107102:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107107:	e9 3e f4 ff ff       	jmp    8010654a <alltraps>

8010710c <vector153>:
.globl vector153
vector153:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $153
8010710e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107113:	e9 32 f4 ff ff       	jmp    8010654a <alltraps>

80107118 <vector154>:
.globl vector154
vector154:
  pushl $0
80107118:	6a 00                	push   $0x0
  pushl $154
8010711a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010711f:	e9 26 f4 ff ff       	jmp    8010654a <alltraps>

80107124 <vector155>:
.globl vector155
vector155:
  pushl $0
80107124:	6a 00                	push   $0x0
  pushl $155
80107126:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010712b:	e9 1a f4 ff ff       	jmp    8010654a <alltraps>

80107130 <vector156>:
.globl vector156
vector156:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $156
80107132:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107137:	e9 0e f4 ff ff       	jmp    8010654a <alltraps>

8010713c <vector157>:
.globl vector157
vector157:
  pushl $0
8010713c:	6a 00                	push   $0x0
  pushl $157
8010713e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107143:	e9 02 f4 ff ff       	jmp    8010654a <alltraps>

80107148 <vector158>:
.globl vector158
vector158:
  pushl $0
80107148:	6a 00                	push   $0x0
  pushl $158
8010714a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010714f:	e9 f6 f3 ff ff       	jmp    8010654a <alltraps>

80107154 <vector159>:
.globl vector159
vector159:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $159
80107156:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010715b:	e9 ea f3 ff ff       	jmp    8010654a <alltraps>

80107160 <vector160>:
.globl vector160
vector160:
  pushl $0
80107160:	6a 00                	push   $0x0
  pushl $160
80107162:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107167:	e9 de f3 ff ff       	jmp    8010654a <alltraps>

8010716c <vector161>:
.globl vector161
vector161:
  pushl $0
8010716c:	6a 00                	push   $0x0
  pushl $161
8010716e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107173:	e9 d2 f3 ff ff       	jmp    8010654a <alltraps>

80107178 <vector162>:
.globl vector162
vector162:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $162
8010717a:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010717f:	e9 c6 f3 ff ff       	jmp    8010654a <alltraps>

80107184 <vector163>:
.globl vector163
vector163:
  pushl $0
80107184:	6a 00                	push   $0x0
  pushl $163
80107186:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010718b:	e9 ba f3 ff ff       	jmp    8010654a <alltraps>

80107190 <vector164>:
.globl vector164
vector164:
  pushl $0
80107190:	6a 00                	push   $0x0
  pushl $164
80107192:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107197:	e9 ae f3 ff ff       	jmp    8010654a <alltraps>

8010719c <vector165>:
.globl vector165
vector165:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $165
8010719e:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801071a3:	e9 a2 f3 ff ff       	jmp    8010654a <alltraps>

801071a8 <vector166>:
.globl vector166
vector166:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $166
801071aa:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801071af:	e9 96 f3 ff ff       	jmp    8010654a <alltraps>

801071b4 <vector167>:
.globl vector167
vector167:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $167
801071b6:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801071bb:	e9 8a f3 ff ff       	jmp    8010654a <alltraps>

801071c0 <vector168>:
.globl vector168
vector168:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $168
801071c2:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801071c7:	e9 7e f3 ff ff       	jmp    8010654a <alltraps>

801071cc <vector169>:
.globl vector169
vector169:
  pushl $0
801071cc:	6a 00                	push   $0x0
  pushl $169
801071ce:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801071d3:	e9 72 f3 ff ff       	jmp    8010654a <alltraps>

801071d8 <vector170>:
.globl vector170
vector170:
  pushl $0
801071d8:	6a 00                	push   $0x0
  pushl $170
801071da:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801071df:	e9 66 f3 ff ff       	jmp    8010654a <alltraps>

801071e4 <vector171>:
.globl vector171
vector171:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $171
801071e6:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801071eb:	e9 5a f3 ff ff       	jmp    8010654a <alltraps>

801071f0 <vector172>:
.globl vector172
vector172:
  pushl $0
801071f0:	6a 00                	push   $0x0
  pushl $172
801071f2:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801071f7:	e9 4e f3 ff ff       	jmp    8010654a <alltraps>

801071fc <vector173>:
.globl vector173
vector173:
  pushl $0
801071fc:	6a 00                	push   $0x0
  pushl $173
801071fe:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107203:	e9 42 f3 ff ff       	jmp    8010654a <alltraps>

80107208 <vector174>:
.globl vector174
vector174:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $174
8010720a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010720f:	e9 36 f3 ff ff       	jmp    8010654a <alltraps>

80107214 <vector175>:
.globl vector175
vector175:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $175
80107216:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010721b:	e9 2a f3 ff ff       	jmp    8010654a <alltraps>

80107220 <vector176>:
.globl vector176
vector176:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $176
80107222:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107227:	e9 1e f3 ff ff       	jmp    8010654a <alltraps>

8010722c <vector177>:
.globl vector177
vector177:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $177
8010722e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107233:	e9 12 f3 ff ff       	jmp    8010654a <alltraps>

80107238 <vector178>:
.globl vector178
vector178:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $178
8010723a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010723f:	e9 06 f3 ff ff       	jmp    8010654a <alltraps>

80107244 <vector179>:
.globl vector179
vector179:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $179
80107246:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010724b:	e9 fa f2 ff ff       	jmp    8010654a <alltraps>

80107250 <vector180>:
.globl vector180
vector180:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $180
80107252:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107257:	e9 ee f2 ff ff       	jmp    8010654a <alltraps>

8010725c <vector181>:
.globl vector181
vector181:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $181
8010725e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107263:	e9 e2 f2 ff ff       	jmp    8010654a <alltraps>

80107268 <vector182>:
.globl vector182
vector182:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $182
8010726a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010726f:	e9 d6 f2 ff ff       	jmp    8010654a <alltraps>

80107274 <vector183>:
.globl vector183
vector183:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $183
80107276:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010727b:	e9 ca f2 ff ff       	jmp    8010654a <alltraps>

80107280 <vector184>:
.globl vector184
vector184:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $184
80107282:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107287:	e9 be f2 ff ff       	jmp    8010654a <alltraps>

8010728c <vector185>:
.globl vector185
vector185:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $185
8010728e:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107293:	e9 b2 f2 ff ff       	jmp    8010654a <alltraps>

80107298 <vector186>:
.globl vector186
vector186:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $186
8010729a:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010729f:	e9 a6 f2 ff ff       	jmp    8010654a <alltraps>

801072a4 <vector187>:
.globl vector187
vector187:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $187
801072a6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801072ab:	e9 9a f2 ff ff       	jmp    8010654a <alltraps>

801072b0 <vector188>:
.globl vector188
vector188:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $188
801072b2:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801072b7:	e9 8e f2 ff ff       	jmp    8010654a <alltraps>

801072bc <vector189>:
.globl vector189
vector189:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $189
801072be:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801072c3:	e9 82 f2 ff ff       	jmp    8010654a <alltraps>

801072c8 <vector190>:
.globl vector190
vector190:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $190
801072ca:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801072cf:	e9 76 f2 ff ff       	jmp    8010654a <alltraps>

801072d4 <vector191>:
.globl vector191
vector191:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $191
801072d6:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801072db:	e9 6a f2 ff ff       	jmp    8010654a <alltraps>

801072e0 <vector192>:
.globl vector192
vector192:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $192
801072e2:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801072e7:	e9 5e f2 ff ff       	jmp    8010654a <alltraps>

801072ec <vector193>:
.globl vector193
vector193:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $193
801072ee:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801072f3:	e9 52 f2 ff ff       	jmp    8010654a <alltraps>

801072f8 <vector194>:
.globl vector194
vector194:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $194
801072fa:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801072ff:	e9 46 f2 ff ff       	jmp    8010654a <alltraps>

80107304 <vector195>:
.globl vector195
vector195:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $195
80107306:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010730b:	e9 3a f2 ff ff       	jmp    8010654a <alltraps>

80107310 <vector196>:
.globl vector196
vector196:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $196
80107312:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107317:	e9 2e f2 ff ff       	jmp    8010654a <alltraps>

8010731c <vector197>:
.globl vector197
vector197:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $197
8010731e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107323:	e9 22 f2 ff ff       	jmp    8010654a <alltraps>

80107328 <vector198>:
.globl vector198
vector198:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $198
8010732a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010732f:	e9 16 f2 ff ff       	jmp    8010654a <alltraps>

80107334 <vector199>:
.globl vector199
vector199:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $199
80107336:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010733b:	e9 0a f2 ff ff       	jmp    8010654a <alltraps>

80107340 <vector200>:
.globl vector200
vector200:
  pushl $0
80107340:	6a 00                	push   $0x0
  pushl $200
80107342:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107347:	e9 fe f1 ff ff       	jmp    8010654a <alltraps>

8010734c <vector201>:
.globl vector201
vector201:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $201
8010734e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107353:	e9 f2 f1 ff ff       	jmp    8010654a <alltraps>

80107358 <vector202>:
.globl vector202
vector202:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $202
8010735a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010735f:	e9 e6 f1 ff ff       	jmp    8010654a <alltraps>

80107364 <vector203>:
.globl vector203
vector203:
  pushl $0
80107364:	6a 00                	push   $0x0
  pushl $203
80107366:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010736b:	e9 da f1 ff ff       	jmp    8010654a <alltraps>

80107370 <vector204>:
.globl vector204
vector204:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $204
80107372:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107377:	e9 ce f1 ff ff       	jmp    8010654a <alltraps>

8010737c <vector205>:
.globl vector205
vector205:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $205
8010737e:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107383:	e9 c2 f1 ff ff       	jmp    8010654a <alltraps>

80107388 <vector206>:
.globl vector206
vector206:
  pushl $0
80107388:	6a 00                	push   $0x0
  pushl $206
8010738a:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010738f:	e9 b6 f1 ff ff       	jmp    8010654a <alltraps>

80107394 <vector207>:
.globl vector207
vector207:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $207
80107396:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010739b:	e9 aa f1 ff ff       	jmp    8010654a <alltraps>

801073a0 <vector208>:
.globl vector208
vector208:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $208
801073a2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801073a7:	e9 9e f1 ff ff       	jmp    8010654a <alltraps>

801073ac <vector209>:
.globl vector209
vector209:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $209
801073ae:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801073b3:	e9 92 f1 ff ff       	jmp    8010654a <alltraps>

801073b8 <vector210>:
.globl vector210
vector210:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $210
801073ba:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801073bf:	e9 86 f1 ff ff       	jmp    8010654a <alltraps>

801073c4 <vector211>:
.globl vector211
vector211:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $211
801073c6:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801073cb:	e9 7a f1 ff ff       	jmp    8010654a <alltraps>

801073d0 <vector212>:
.globl vector212
vector212:
  pushl $0
801073d0:	6a 00                	push   $0x0
  pushl $212
801073d2:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801073d7:	e9 6e f1 ff ff       	jmp    8010654a <alltraps>

801073dc <vector213>:
.globl vector213
vector213:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $213
801073de:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801073e3:	e9 62 f1 ff ff       	jmp    8010654a <alltraps>

801073e8 <vector214>:
.globl vector214
vector214:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $214
801073ea:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801073ef:	e9 56 f1 ff ff       	jmp    8010654a <alltraps>

801073f4 <vector215>:
.globl vector215
vector215:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $215
801073f6:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801073fb:	e9 4a f1 ff ff       	jmp    8010654a <alltraps>

80107400 <vector216>:
.globl vector216
vector216:
  pushl $0
80107400:	6a 00                	push   $0x0
  pushl $216
80107402:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107407:	e9 3e f1 ff ff       	jmp    8010654a <alltraps>

8010740c <vector217>:
.globl vector217
vector217:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $217
8010740e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107413:	e9 32 f1 ff ff       	jmp    8010654a <alltraps>

80107418 <vector218>:
.globl vector218
vector218:
  pushl $0
80107418:	6a 00                	push   $0x0
  pushl $218
8010741a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010741f:	e9 26 f1 ff ff       	jmp    8010654a <alltraps>

80107424 <vector219>:
.globl vector219
vector219:
  pushl $0
80107424:	6a 00                	push   $0x0
  pushl $219
80107426:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010742b:	e9 1a f1 ff ff       	jmp    8010654a <alltraps>

80107430 <vector220>:
.globl vector220
vector220:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $220
80107432:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107437:	e9 0e f1 ff ff       	jmp    8010654a <alltraps>

8010743c <vector221>:
.globl vector221
vector221:
  pushl $0
8010743c:	6a 00                	push   $0x0
  pushl $221
8010743e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107443:	e9 02 f1 ff ff       	jmp    8010654a <alltraps>

80107448 <vector222>:
.globl vector222
vector222:
  pushl $0
80107448:	6a 00                	push   $0x0
  pushl $222
8010744a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010744f:	e9 f6 f0 ff ff       	jmp    8010654a <alltraps>

80107454 <vector223>:
.globl vector223
vector223:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $223
80107456:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010745b:	e9 ea f0 ff ff       	jmp    8010654a <alltraps>

80107460 <vector224>:
.globl vector224
vector224:
  pushl $0
80107460:	6a 00                	push   $0x0
  pushl $224
80107462:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107467:	e9 de f0 ff ff       	jmp    8010654a <alltraps>

8010746c <vector225>:
.globl vector225
vector225:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $225
8010746e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107473:	e9 d2 f0 ff ff       	jmp    8010654a <alltraps>

80107478 <vector226>:
.globl vector226
vector226:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $226
8010747a:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010747f:	e9 c6 f0 ff ff       	jmp    8010654a <alltraps>

80107484 <vector227>:
.globl vector227
vector227:
  pushl $0
80107484:	6a 00                	push   $0x0
  pushl $227
80107486:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010748b:	e9 ba f0 ff ff       	jmp    8010654a <alltraps>

80107490 <vector228>:
.globl vector228
vector228:
  pushl $0
80107490:	6a 00                	push   $0x0
  pushl $228
80107492:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107497:	e9 ae f0 ff ff       	jmp    8010654a <alltraps>

8010749c <vector229>:
.globl vector229
vector229:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $229
8010749e:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801074a3:	e9 a2 f0 ff ff       	jmp    8010654a <alltraps>

801074a8 <vector230>:
.globl vector230
vector230:
  pushl $0
801074a8:	6a 00                	push   $0x0
  pushl $230
801074aa:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801074af:	e9 96 f0 ff ff       	jmp    8010654a <alltraps>

801074b4 <vector231>:
.globl vector231
vector231:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $231
801074b6:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801074bb:	e9 8a f0 ff ff       	jmp    8010654a <alltraps>

801074c0 <vector232>:
.globl vector232
vector232:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $232
801074c2:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801074c7:	e9 7e f0 ff ff       	jmp    8010654a <alltraps>

801074cc <vector233>:
.globl vector233
vector233:
  pushl $0
801074cc:	6a 00                	push   $0x0
  pushl $233
801074ce:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801074d3:	e9 72 f0 ff ff       	jmp    8010654a <alltraps>

801074d8 <vector234>:
.globl vector234
vector234:
  pushl $0
801074d8:	6a 00                	push   $0x0
  pushl $234
801074da:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801074df:	e9 66 f0 ff ff       	jmp    8010654a <alltraps>

801074e4 <vector235>:
.globl vector235
vector235:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $235
801074e6:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801074eb:	e9 5a f0 ff ff       	jmp    8010654a <alltraps>

801074f0 <vector236>:
.globl vector236
vector236:
  pushl $0
801074f0:	6a 00                	push   $0x0
  pushl $236
801074f2:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801074f7:	e9 4e f0 ff ff       	jmp    8010654a <alltraps>

801074fc <vector237>:
.globl vector237
vector237:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $237
801074fe:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107503:	e9 42 f0 ff ff       	jmp    8010654a <alltraps>

80107508 <vector238>:
.globl vector238
vector238:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $238
8010750a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010750f:	e9 36 f0 ff ff       	jmp    8010654a <alltraps>

80107514 <vector239>:
.globl vector239
vector239:
  pushl $0
80107514:	6a 00                	push   $0x0
  pushl $239
80107516:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010751b:	e9 2a f0 ff ff       	jmp    8010654a <alltraps>

80107520 <vector240>:
.globl vector240
vector240:
  pushl $0
80107520:	6a 00                	push   $0x0
  pushl $240
80107522:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107527:	e9 1e f0 ff ff       	jmp    8010654a <alltraps>

8010752c <vector241>:
.globl vector241
vector241:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $241
8010752e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107533:	e9 12 f0 ff ff       	jmp    8010654a <alltraps>

80107538 <vector242>:
.globl vector242
vector242:
  pushl $0
80107538:	6a 00                	push   $0x0
  pushl $242
8010753a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010753f:	e9 06 f0 ff ff       	jmp    8010654a <alltraps>

80107544 <vector243>:
.globl vector243
vector243:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $243
80107546:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010754b:	e9 fa ef ff ff       	jmp    8010654a <alltraps>

80107550 <vector244>:
.globl vector244
vector244:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $244
80107552:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107557:	e9 ee ef ff ff       	jmp    8010654a <alltraps>

8010755c <vector245>:
.globl vector245
vector245:
  pushl $0
8010755c:	6a 00                	push   $0x0
  pushl $245
8010755e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107563:	e9 e2 ef ff ff       	jmp    8010654a <alltraps>

80107568 <vector246>:
.globl vector246
vector246:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $246
8010756a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010756f:	e9 d6 ef ff ff       	jmp    8010654a <alltraps>

80107574 <vector247>:
.globl vector247
vector247:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $247
80107576:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010757b:	e9 ca ef ff ff       	jmp    8010654a <alltraps>

80107580 <vector248>:
.globl vector248
vector248:
  pushl $0
80107580:	6a 00                	push   $0x0
  pushl $248
80107582:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107587:	e9 be ef ff ff       	jmp    8010654a <alltraps>

8010758c <vector249>:
.globl vector249
vector249:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $249
8010758e:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107593:	e9 b2 ef ff ff       	jmp    8010654a <alltraps>

80107598 <vector250>:
.globl vector250
vector250:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $250
8010759a:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010759f:	e9 a6 ef ff ff       	jmp    8010654a <alltraps>

801075a4 <vector251>:
.globl vector251
vector251:
  pushl $0
801075a4:	6a 00                	push   $0x0
  pushl $251
801075a6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801075ab:	e9 9a ef ff ff       	jmp    8010654a <alltraps>

801075b0 <vector252>:
.globl vector252
vector252:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $252
801075b2:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801075b7:	e9 8e ef ff ff       	jmp    8010654a <alltraps>

801075bc <vector253>:
.globl vector253
vector253:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $253
801075be:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801075c3:	e9 82 ef ff ff       	jmp    8010654a <alltraps>

801075c8 <vector254>:
.globl vector254
vector254:
  pushl $0
801075c8:	6a 00                	push   $0x0
  pushl $254
801075ca:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801075cf:	e9 76 ef ff ff       	jmp    8010654a <alltraps>

801075d4 <vector255>:
.globl vector255
vector255:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $255
801075d6:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801075db:	e9 6a ef ff ff       	jmp    8010654a <alltraps>

801075e0 <lgdt>:
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801075e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e9:	83 e8 01             	sub    $0x1,%eax
801075ec:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801075f0:	8b 45 08             	mov    0x8(%ebp),%eax
801075f3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801075f7:	8b 45 08             	mov    0x8(%ebp),%eax
801075fa:	c1 e8 10             	shr    $0x10,%eax
801075fd:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107601:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107604:	0f 01 10             	lgdtl  (%eax)
}
80107607:	90                   	nop
80107608:	c9                   	leave  
80107609:	c3                   	ret    

8010760a <ltr>:
{
8010760a:	55                   	push   %ebp
8010760b:	89 e5                	mov    %esp,%ebp
8010760d:	83 ec 04             	sub    $0x4,%esp
80107610:	8b 45 08             	mov    0x8(%ebp),%eax
80107613:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107617:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010761b:	0f 00 d8             	ltr    %ax
}
8010761e:	90                   	nop
8010761f:	c9                   	leave  
80107620:	c3                   	ret    

80107621 <lcr3>:

static inline void
lcr3(uint val)
{
80107621:	55                   	push   %ebp
80107622:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107624:	8b 45 08             	mov    0x8(%ebp),%eax
80107627:	0f 22 d8             	mov    %eax,%cr3
}
8010762a:	90                   	nop
8010762b:	5d                   	pop    %ebp
8010762c:	c3                   	ret    

8010762d <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010762d:	55                   	push   %ebp
8010762e:	89 e5                	mov    %esp,%ebp
80107630:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107633:	e8 bb cb ff ff       	call   801041f3 <cpuid>
80107638:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010763e:	05 00 38 11 80       	add    $0x80113800,%eax
80107643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107649:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010764f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107652:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010765f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107662:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107666:	83 e2 f0             	and    $0xfffffff0,%edx
80107669:	83 ca 0a             	or     $0xa,%edx
8010766c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010766f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107672:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107676:	83 ca 10             	or     $0x10,%edx
80107679:	88 50 7d             	mov    %dl,0x7d(%eax)
8010767c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107683:	83 e2 9f             	and    $0xffffff9f,%edx
80107686:	88 50 7d             	mov    %dl,0x7d(%eax)
80107689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107690:	83 ca 80             	or     $0xffffff80,%edx
80107693:	88 50 7d             	mov    %dl,0x7d(%eax)
80107696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107699:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010769d:	83 ca 0f             	or     $0xf,%edx
801076a0:	88 50 7e             	mov    %dl,0x7e(%eax)
801076a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076aa:	83 e2 ef             	and    $0xffffffef,%edx
801076ad:	88 50 7e             	mov    %dl,0x7e(%eax)
801076b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076b7:	83 e2 df             	and    $0xffffffdf,%edx
801076ba:	88 50 7e             	mov    %dl,0x7e(%eax)
801076bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076c4:	83 ca 40             	or     $0x40,%edx
801076c7:	88 50 7e             	mov    %dl,0x7e(%eax)
801076ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076cd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076d1:	83 ca 80             	or     $0xffffff80,%edx
801076d4:	88 50 7e             	mov    %dl,0x7e(%eax)
801076d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076da:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801076de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e1:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801076e8:	ff ff 
801076ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ed:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801076f4:	00 00 
801076f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f9:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107703:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010770a:	83 e2 f0             	and    $0xfffffff0,%edx
8010770d:	83 ca 02             	or     $0x2,%edx
80107710:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107719:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107720:	83 ca 10             	or     $0x10,%edx
80107723:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107733:	83 e2 9f             	and    $0xffffff9f,%edx
80107736:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010773c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107746:	83 ca 80             	or     $0xffffff80,%edx
80107749:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010774f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107752:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107759:	83 ca 0f             	or     $0xf,%edx
8010775c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107765:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010776c:	83 e2 ef             	and    $0xffffffef,%edx
8010776f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107778:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010777f:	83 e2 df             	and    $0xffffffdf,%edx
80107782:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107792:	83 ca 40             	or     $0x40,%edx
80107795:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010779b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077a5:	83 ca 80             	or     $0xffffff80,%edx
801077a8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b1:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801077b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bb:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801077c2:	ff ff 
801077c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c7:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801077ce:	00 00 
801077d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d3:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801077da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077dd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801077e4:	83 e2 f0             	and    $0xfffffff0,%edx
801077e7:	83 ca 0a             	or     $0xa,%edx
801077ea:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801077f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801077fa:	83 ca 10             	or     $0x10,%edx
801077fd:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107806:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010780d:	83 ca 60             	or     $0x60,%edx
80107810:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107819:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107820:	83 ca 80             	or     $0xffffff80,%edx
80107823:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107833:	83 ca 0f             	or     $0xf,%edx
80107836:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010783c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107846:	83 e2 ef             	and    $0xffffffef,%edx
80107849:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010784f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107852:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107859:	83 e2 df             	and    $0xffffffdf,%edx
8010785c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107865:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010786c:	83 ca 40             	or     $0x40,%edx
8010786f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107878:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010787f:	83 ca 80             	or     $0xffffff80,%edx
80107882:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788b:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107895:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010789c:	ff ff 
8010789e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a1:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801078a8:	00 00 
801078aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ad:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801078b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078be:	83 e2 f0             	and    $0xfffffff0,%edx
801078c1:	83 ca 02             	or     $0x2,%edx
801078c4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078d4:	83 ca 10             	or     $0x10,%edx
801078d7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078e7:	83 ca 60             	or     $0x60,%edx
801078ea:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078fa:	83 ca 80             	or     $0xffffff80,%edx
801078fd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107906:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010790d:	83 ca 0f             	or     $0xf,%edx
80107910:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107919:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107920:	83 e2 ef             	and    $0xffffffef,%edx
80107923:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107933:	83 e2 df             	and    $0xffffffdf,%edx
80107936:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010793c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107946:	83 ca 40             	or     $0x40,%edx
80107949:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010794f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107952:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107959:	83 ca 80             	or     $0xffffff80,%edx
8010795c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107965:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010796c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796f:	83 c0 70             	add    $0x70,%eax
80107972:	83 ec 08             	sub    $0x8,%esp
80107975:	6a 30                	push   $0x30
80107977:	50                   	push   %eax
80107978:	e8 63 fc ff ff       	call   801075e0 <lgdt>
8010797d:	83 c4 10             	add    $0x10,%esp
}
80107980:	90                   	nop
80107981:	c9                   	leave  
80107982:	c3                   	ret    

80107983 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107983:	55                   	push   %ebp
80107984:	89 e5                	mov    %esp,%ebp
80107986:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107989:	8b 45 0c             	mov    0xc(%ebp),%eax
8010798c:	c1 e8 16             	shr    $0x16,%eax
8010798f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107996:	8b 45 08             	mov    0x8(%ebp),%eax
80107999:	01 d0                	add    %edx,%eax
8010799b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010799e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079a1:	8b 00                	mov    (%eax),%eax
801079a3:	83 e0 01             	and    $0x1,%eax
801079a6:	85 c0                	test   %eax,%eax
801079a8:	74 14                	je     801079be <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ad:	8b 00                	mov    (%eax),%eax
801079af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079b4:	05 00 00 00 80       	add    $0x80000000,%eax
801079b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079bc:	eb 42                	jmp    80107a00 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801079be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801079c2:	74 0e                	je     801079d2 <walkpgdir+0x4f>
801079c4:	e8 cb b2 ff ff       	call   80102c94 <kalloc>
801079c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079d0:	75 07                	jne    801079d9 <walkpgdir+0x56>
      return 0;
801079d2:	b8 00 00 00 00       	mov    $0x0,%eax
801079d7:	eb 3e                	jmp    80107a17 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801079d9:	83 ec 04             	sub    $0x4,%esp
801079dc:	68 00 10 00 00       	push   $0x1000
801079e1:	6a 00                	push   $0x0
801079e3:	ff 75 f4             	pushl  -0xc(%ebp)
801079e6:	e8 e8 d7 ff ff       	call   801051d3 <memset>
801079eb:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801079ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f1:	05 00 00 00 80       	add    $0x80000000,%eax
801079f6:	83 c8 07             	or     $0x7,%eax
801079f9:	89 c2                	mov    %eax,%edx
801079fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079fe:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107a00:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a03:	c1 e8 0c             	shr    $0xc,%eax
80107a06:	25 ff 03 00 00       	and    $0x3ff,%eax
80107a0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a15:	01 d0                	add    %edx,%eax
}
80107a17:	c9                   	leave  
80107a18:	c3                   	ret    

80107a19 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107a19:	55                   	push   %ebp
80107a1a:	89 e5                	mov    %esp,%ebp
80107a1c:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a2d:	8b 45 10             	mov    0x10(%ebp),%eax
80107a30:	01 d0                	add    %edx,%eax
80107a32:	83 e8 01             	sub    $0x1,%eax
80107a35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a3d:	83 ec 04             	sub    $0x4,%esp
80107a40:	6a 01                	push   $0x1
80107a42:	ff 75 f4             	pushl  -0xc(%ebp)
80107a45:	ff 75 08             	pushl  0x8(%ebp)
80107a48:	e8 36 ff ff ff       	call   80107983 <walkpgdir>
80107a4d:	83 c4 10             	add    $0x10,%esp
80107a50:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a57:	75 07                	jne    80107a60 <mappages+0x47>
      return -1;
80107a59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a5e:	eb 47                	jmp    80107aa7 <mappages+0x8e>
    if(*pte & PTE_P)
80107a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a63:	8b 00                	mov    (%eax),%eax
80107a65:	83 e0 01             	and    $0x1,%eax
80107a68:	85 c0                	test   %eax,%eax
80107a6a:	74 0d                	je     80107a79 <mappages+0x60>
      panic("remap");
80107a6c:	83 ec 0c             	sub    $0xc,%esp
80107a6f:	68 18 89 10 80       	push   $0x80108918
80107a74:	e8 23 8b ff ff       	call   8010059c <panic>
    *pte = pa | perm | PTE_P;
80107a79:	8b 45 18             	mov    0x18(%ebp),%eax
80107a7c:	0b 45 14             	or     0x14(%ebp),%eax
80107a7f:	83 c8 01             	or     $0x1,%eax
80107a82:	89 c2                	mov    %eax,%edx
80107a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a87:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107a8f:	74 10                	je     80107aa1 <mappages+0x88>
      break;
    a += PGSIZE;
80107a91:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107a98:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a9f:	eb 9c                	jmp    80107a3d <mappages+0x24>
      break;
80107aa1:	90                   	nop
  }
  return 0;
80107aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107aa7:	c9                   	leave  
80107aa8:	c3                   	ret    

80107aa9 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107aa9:	55                   	push   %ebp
80107aaa:	89 e5                	mov    %esp,%ebp
80107aac:	53                   	push   %ebx
80107aad:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107ab0:	e8 df b1 ff ff       	call   80102c94 <kalloc>
80107ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ab8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107abc:	75 07                	jne    80107ac5 <setupkvm+0x1c>
    return 0;
80107abe:	b8 00 00 00 00       	mov    $0x0,%eax
80107ac3:	eb 78                	jmp    80107b3d <setupkvm+0x94>
  memset(pgdir, 0, PGSIZE);
80107ac5:	83 ec 04             	sub    $0x4,%esp
80107ac8:	68 00 10 00 00       	push   $0x1000
80107acd:	6a 00                	push   $0x0
80107acf:	ff 75 f0             	pushl  -0x10(%ebp)
80107ad2:	e8 fc d6 ff ff       	call   801051d3 <memset>
80107ad7:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ada:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
80107ae1:	eb 4e                	jmp    80107b31 <setupkvm+0x88>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae6:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aec:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af2:	8b 58 08             	mov    0x8(%eax),%ebx
80107af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af8:	8b 40 04             	mov    0x4(%eax),%eax
80107afb:	29 c3                	sub    %eax,%ebx
80107afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b00:	8b 00                	mov    (%eax),%eax
80107b02:	83 ec 0c             	sub    $0xc,%esp
80107b05:	51                   	push   %ecx
80107b06:	52                   	push   %edx
80107b07:	53                   	push   %ebx
80107b08:	50                   	push   %eax
80107b09:	ff 75 f0             	pushl  -0x10(%ebp)
80107b0c:	e8 08 ff ff ff       	call   80107a19 <mappages>
80107b11:	83 c4 20             	add    $0x20,%esp
80107b14:	85 c0                	test   %eax,%eax
80107b16:	79 15                	jns    80107b2d <setupkvm+0x84>
      freevm(pgdir);
80107b18:	83 ec 0c             	sub    $0xc,%esp
80107b1b:	ff 75 f0             	pushl  -0x10(%ebp)
80107b1e:	e8 f7 04 00 00       	call   8010801a <freevm>
80107b23:	83 c4 10             	add    $0x10,%esp
      return 0;
80107b26:	b8 00 00 00 00       	mov    $0x0,%eax
80107b2b:	eb 10                	jmp    80107b3d <setupkvm+0x94>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b2d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107b31:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
80107b38:	72 a9                	jb     80107ae3 <setupkvm+0x3a>
    }
  return pgdir;
80107b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107b3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b40:	c9                   	leave  
80107b41:	c3                   	ret    

80107b42 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107b42:	55                   	push   %ebp
80107b43:	89 e5                	mov    %esp,%ebp
80107b45:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b48:	e8 5c ff ff ff       	call   80107aa9 <setupkvm>
80107b4d:	a3 24 65 11 80       	mov    %eax,0x80116524
  switchkvm();
80107b52:	e8 03 00 00 00       	call   80107b5a <switchkvm>
}
80107b57:	90                   	nop
80107b58:	c9                   	leave  
80107b59:	c3                   	ret    

80107b5a <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107b5a:	55                   	push   %ebp
80107b5b:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b5d:	a1 24 65 11 80       	mov    0x80116524,%eax
80107b62:	05 00 00 00 80       	add    $0x80000000,%eax
80107b67:	50                   	push   %eax
80107b68:	e8 b4 fa ff ff       	call   80107621 <lcr3>
80107b6d:	83 c4 04             	add    $0x4,%esp
}
80107b70:	90                   	nop
80107b71:	c9                   	leave  
80107b72:	c3                   	ret    

80107b73 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107b73:	55                   	push   %ebp
80107b74:	89 e5                	mov    %esp,%ebp
80107b76:	56                   	push   %esi
80107b77:	53                   	push   %ebx
80107b78:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80107b7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107b7f:	75 0d                	jne    80107b8e <switchuvm+0x1b>
    panic("switchuvm: no process");
80107b81:	83 ec 0c             	sub    $0xc,%esp
80107b84:	68 1e 89 10 80       	push   $0x8010891e
80107b89:	e8 0e 8a ff ff       	call   8010059c <panic>
  if(p->kstack == 0)
80107b8e:	8b 45 08             	mov    0x8(%ebp),%eax
80107b91:	8b 40 08             	mov    0x8(%eax),%eax
80107b94:	85 c0                	test   %eax,%eax
80107b96:	75 0d                	jne    80107ba5 <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107b98:	83 ec 0c             	sub    $0xc,%esp
80107b9b:	68 34 89 10 80       	push   $0x80108934
80107ba0:	e8 f7 89 ff ff       	call   8010059c <panic>
  if(p->pgdir == 0)
80107ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba8:	8b 40 04             	mov    0x4(%eax),%eax
80107bab:	85 c0                	test   %eax,%eax
80107bad:	75 0d                	jne    80107bbc <switchuvm+0x49>
    panic("switchuvm: no pgdir");
80107baf:	83 ec 0c             	sub    $0xc,%esp
80107bb2:	68 49 89 10 80       	push   $0x80108949
80107bb7:	e8 e0 89 ff ff       	call   8010059c <panic>

  pushcli();
80107bbc:	e8 06 d5 ff ff       	call   801050c7 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107bc1:	e8 4e c6 ff ff       	call   80104214 <mycpu>
80107bc6:	89 c3                	mov    %eax,%ebx
80107bc8:	e8 47 c6 ff ff       	call   80104214 <mycpu>
80107bcd:	83 c0 08             	add    $0x8,%eax
80107bd0:	89 c6                	mov    %eax,%esi
80107bd2:	e8 3d c6 ff ff       	call   80104214 <mycpu>
80107bd7:	83 c0 08             	add    $0x8,%eax
80107bda:	c1 e8 10             	shr    $0x10,%eax
80107bdd:	88 45 f7             	mov    %al,-0x9(%ebp)
80107be0:	e8 2f c6 ff ff       	call   80104214 <mycpu>
80107be5:	83 c0 08             	add    $0x8,%eax
80107be8:	c1 e8 18             	shr    $0x18,%eax
80107beb:	89 c2                	mov    %eax,%edx
80107bed:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107bf4:	67 00 
80107bf6:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
80107bfd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107c01:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107c07:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c0e:	83 e0 f0             	and    $0xfffffff0,%eax
80107c11:	83 c8 09             	or     $0x9,%eax
80107c14:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c1a:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c21:	83 c8 10             	or     $0x10,%eax
80107c24:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c2a:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c31:	83 e0 9f             	and    $0xffffff9f,%eax
80107c34:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c3a:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107c41:	83 c8 80             	or     $0xffffff80,%eax
80107c44:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107c4a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c51:	83 e0 f0             	and    $0xfffffff0,%eax
80107c54:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c5a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c61:	83 e0 ef             	and    $0xffffffef,%eax
80107c64:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c6a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c71:	83 e0 df             	and    $0xffffffdf,%eax
80107c74:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c7a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c81:	83 c8 40             	or     $0x40,%eax
80107c84:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c8a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107c91:	83 e0 7f             	and    $0x7f,%eax
80107c94:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107c9a:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107ca0:	e8 6f c5 ff ff       	call   80104214 <mycpu>
80107ca5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cac:	83 e2 ef             	and    $0xffffffef,%edx
80107caf:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107cb5:	e8 5a c5 ff ff       	call   80104214 <mycpu>
80107cba:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80107cc3:	8b 40 08             	mov    0x8(%eax),%eax
80107cc6:	89 c3                	mov    %eax,%ebx
80107cc8:	e8 47 c5 ff ff       	call   80104214 <mycpu>
80107ccd:	89 c2                	mov    %eax,%edx
80107ccf:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80107cd5:	89 42 0c             	mov    %eax,0xc(%edx)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107cd8:	e8 37 c5 ff ff       	call   80104214 <mycpu>
80107cdd:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107ce3:	83 ec 0c             	sub    $0xc,%esp
80107ce6:	6a 28                	push   $0x28
80107ce8:	e8 1d f9 ff ff       	call   8010760a <ltr>
80107ced:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf3:	8b 40 04             	mov    0x4(%eax),%eax
80107cf6:	05 00 00 00 80       	add    $0x80000000,%eax
80107cfb:	83 ec 0c             	sub    $0xc,%esp
80107cfe:	50                   	push   %eax
80107cff:	e8 1d f9 ff ff       	call   80107621 <lcr3>
80107d04:	83 c4 10             	add    $0x10,%esp
  popcli();
80107d07:	e8 09 d4 ff ff       	call   80105115 <popcli>
}
80107d0c:	90                   	nop
80107d0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d10:	5b                   	pop    %ebx
80107d11:	5e                   	pop    %esi
80107d12:	5d                   	pop    %ebp
80107d13:	c3                   	ret    

80107d14 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107d14:	55                   	push   %ebp
80107d15:	89 e5                	mov    %esp,%ebp
80107d17:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107d1a:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107d21:	76 0d                	jbe    80107d30 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107d23:	83 ec 0c             	sub    $0xc,%esp
80107d26:	68 5d 89 10 80       	push   $0x8010895d
80107d2b:	e8 6c 88 ff ff       	call   8010059c <panic>
  mem = kalloc();
80107d30:	e8 5f af ff ff       	call   80102c94 <kalloc>
80107d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107d38:	83 ec 04             	sub    $0x4,%esp
80107d3b:	68 00 10 00 00       	push   $0x1000
80107d40:	6a 00                	push   $0x0
80107d42:	ff 75 f4             	pushl  -0xc(%ebp)
80107d45:	e8 89 d4 ff ff       	call   801051d3 <memset>
80107d4a:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d50:	05 00 00 00 80       	add    $0x80000000,%eax
80107d55:	83 ec 0c             	sub    $0xc,%esp
80107d58:	6a 06                	push   $0x6
80107d5a:	50                   	push   %eax
80107d5b:	68 00 10 00 00       	push   $0x1000
80107d60:	6a 00                	push   $0x0
80107d62:	ff 75 08             	pushl  0x8(%ebp)
80107d65:	e8 af fc ff ff       	call   80107a19 <mappages>
80107d6a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107d6d:	83 ec 04             	sub    $0x4,%esp
80107d70:	ff 75 10             	pushl  0x10(%ebp)
80107d73:	ff 75 0c             	pushl  0xc(%ebp)
80107d76:	ff 75 f4             	pushl  -0xc(%ebp)
80107d79:	e8 14 d5 ff ff       	call   80105292 <memmove>
80107d7e:	83 c4 10             	add    $0x10,%esp
}
80107d81:	90                   	nop
80107d82:	c9                   	leave  
80107d83:	c3                   	ret    

80107d84 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107d84:	55                   	push   %ebp
80107d85:	89 e5                	mov    %esp,%ebp
80107d87:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80107d92:	85 c0                	test   %eax,%eax
80107d94:	74 0d                	je     80107da3 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107d96:	83 ec 0c             	sub    $0xc,%esp
80107d99:	68 78 89 10 80       	push   $0x80108978
80107d9e:	e8 f9 87 ff ff       	call   8010059c <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107da3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107daa:	e9 8f 00 00 00       	jmp    80107e3e <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107daf:	8b 55 0c             	mov    0xc(%ebp),%edx
80107db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db5:	01 d0                	add    %edx,%eax
80107db7:	83 ec 04             	sub    $0x4,%esp
80107dba:	6a 00                	push   $0x0
80107dbc:	50                   	push   %eax
80107dbd:	ff 75 08             	pushl  0x8(%ebp)
80107dc0:	e8 be fb ff ff       	call   80107983 <walkpgdir>
80107dc5:	83 c4 10             	add    $0x10,%esp
80107dc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107dcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107dcf:	75 0d                	jne    80107dde <loaduvm+0x5a>
      panic("loaduvm: address should exist");
80107dd1:	83 ec 0c             	sub    $0xc,%esp
80107dd4:	68 9b 89 10 80       	push   $0x8010899b
80107dd9:	e8 be 87 ff ff       	call   8010059c <panic>
    pa = PTE_ADDR(*pte);
80107dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107de1:	8b 00                	mov    (%eax),%eax
80107de3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107de8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107deb:	8b 45 18             	mov    0x18(%ebp),%eax
80107dee:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107df1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107df6:	77 0b                	ja     80107e03 <loaduvm+0x7f>
      n = sz - i;
80107df8:	8b 45 18             	mov    0x18(%ebp),%eax
80107dfb:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e01:	eb 07                	jmp    80107e0a <loaduvm+0x86>
    else
      n = PGSIZE;
80107e03:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e0a:	8b 55 14             	mov    0x14(%ebp),%edx
80107e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e10:	01 d0                	add    %edx,%eax
80107e12:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107e15:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107e1b:	ff 75 f0             	pushl  -0x10(%ebp)
80107e1e:	50                   	push   %eax
80107e1f:	52                   	push   %edx
80107e20:	ff 75 10             	pushl  0x10(%ebp)
80107e23:	e8 d8 a0 ff ff       	call   80101f00 <readi>
80107e28:	83 c4 10             	add    $0x10,%esp
80107e2b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107e2e:	74 07                	je     80107e37 <loaduvm+0xb3>
      return -1;
80107e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e35:	eb 18                	jmp    80107e4f <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
80107e37:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e41:	3b 45 18             	cmp    0x18(%ebp),%eax
80107e44:	0f 82 65 ff ff ff    	jb     80107daf <loaduvm+0x2b>
  }
  return 0;
80107e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e4f:	c9                   	leave  
80107e50:	c3                   	ret    

80107e51 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e51:	55                   	push   %ebp
80107e52:	89 e5                	mov    %esp,%ebp
80107e54:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107e57:	8b 45 10             	mov    0x10(%ebp),%eax
80107e5a:	85 c0                	test   %eax,%eax
80107e5c:	79 0a                	jns    80107e68 <allocuvm+0x17>
    return 0;
80107e5e:	b8 00 00 00 00       	mov    $0x0,%eax
80107e63:	e9 ec 00 00 00       	jmp    80107f54 <allocuvm+0x103>
  if(newsz < oldsz)
80107e68:	8b 45 10             	mov    0x10(%ebp),%eax
80107e6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e6e:	73 08                	jae    80107e78 <allocuvm+0x27>
    return oldsz;
80107e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e73:	e9 dc 00 00 00       	jmp    80107f54 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e7b:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107e88:	e9 b8 00 00 00       	jmp    80107f45 <allocuvm+0xf4>
    mem = kalloc();
80107e8d:	e8 02 ae ff ff       	call   80102c94 <kalloc>
80107e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107e95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e99:	75 2e                	jne    80107ec9 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107e9b:	83 ec 0c             	sub    $0xc,%esp
80107e9e:	68 b9 89 10 80       	push   $0x801089b9
80107ea3:	e8 54 85 ff ff       	call   801003fc <cprintf>
80107ea8:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107eab:	83 ec 04             	sub    $0x4,%esp
80107eae:	ff 75 0c             	pushl  0xc(%ebp)
80107eb1:	ff 75 10             	pushl  0x10(%ebp)
80107eb4:	ff 75 08             	pushl  0x8(%ebp)
80107eb7:	e8 9a 00 00 00       	call   80107f56 <deallocuvm>
80107ebc:	83 c4 10             	add    $0x10,%esp
      return 0;
80107ebf:	b8 00 00 00 00       	mov    $0x0,%eax
80107ec4:	e9 8b 00 00 00       	jmp    80107f54 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107ec9:	83 ec 04             	sub    $0x4,%esp
80107ecc:	68 00 10 00 00       	push   $0x1000
80107ed1:	6a 00                	push   $0x0
80107ed3:	ff 75 f0             	pushl  -0x10(%ebp)
80107ed6:	e8 f8 d2 ff ff       	call   801051d3 <memset>
80107edb:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ee1:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eea:	83 ec 0c             	sub    $0xc,%esp
80107eed:	6a 06                	push   $0x6
80107eef:	52                   	push   %edx
80107ef0:	68 00 10 00 00       	push   $0x1000
80107ef5:	50                   	push   %eax
80107ef6:	ff 75 08             	pushl  0x8(%ebp)
80107ef9:	e8 1b fb ff ff       	call   80107a19 <mappages>
80107efe:	83 c4 20             	add    $0x20,%esp
80107f01:	85 c0                	test   %eax,%eax
80107f03:	79 39                	jns    80107f3e <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107f05:	83 ec 0c             	sub    $0xc,%esp
80107f08:	68 d1 89 10 80       	push   $0x801089d1
80107f0d:	e8 ea 84 ff ff       	call   801003fc <cprintf>
80107f12:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107f15:	83 ec 04             	sub    $0x4,%esp
80107f18:	ff 75 0c             	pushl  0xc(%ebp)
80107f1b:	ff 75 10             	pushl  0x10(%ebp)
80107f1e:	ff 75 08             	pushl  0x8(%ebp)
80107f21:	e8 30 00 00 00       	call   80107f56 <deallocuvm>
80107f26:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107f29:	83 ec 0c             	sub    $0xc,%esp
80107f2c:	ff 75 f0             	pushl  -0x10(%ebp)
80107f2f:	e8 c6 ac ff ff       	call   80102bfa <kfree>
80107f34:	83 c4 10             	add    $0x10,%esp
      return 0;
80107f37:	b8 00 00 00 00       	mov    $0x0,%eax
80107f3c:	eb 16                	jmp    80107f54 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107f3e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f48:	3b 45 10             	cmp    0x10(%ebp),%eax
80107f4b:	0f 82 3c ff ff ff    	jb     80107e8d <allocuvm+0x3c>
    }
  }
  return newsz;
80107f51:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107f54:	c9                   	leave  
80107f55:	c3                   	ret    

80107f56 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107f56:	55                   	push   %ebp
80107f57:	89 e5                	mov    %esp,%ebp
80107f59:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107f5c:	8b 45 10             	mov    0x10(%ebp),%eax
80107f5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f62:	72 08                	jb     80107f6c <deallocuvm+0x16>
    return oldsz;
80107f64:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f67:	e9 ac 00 00 00       	jmp    80108018 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107f6c:	8b 45 10             	mov    0x10(%ebp),%eax
80107f6f:	05 ff 0f 00 00       	add    $0xfff,%eax
80107f74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107f7c:	e9 88 00 00 00       	jmp    80108009 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f84:	83 ec 04             	sub    $0x4,%esp
80107f87:	6a 00                	push   $0x0
80107f89:	50                   	push   %eax
80107f8a:	ff 75 08             	pushl  0x8(%ebp)
80107f8d:	e8 f1 f9 ff ff       	call   80107983 <walkpgdir>
80107f92:	83 c4 10             	add    $0x10,%esp
80107f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107f98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f9c:	75 16                	jne    80107fb4 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa1:	c1 e8 16             	shr    $0x16,%eax
80107fa4:	83 c0 01             	add    $0x1,%eax
80107fa7:	c1 e0 16             	shl    $0x16,%eax
80107faa:	2d 00 10 00 00       	sub    $0x1000,%eax
80107faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107fb2:	eb 4e                	jmp    80108002 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fb7:	8b 00                	mov    (%eax),%eax
80107fb9:	83 e0 01             	and    $0x1,%eax
80107fbc:	85 c0                	test   %eax,%eax
80107fbe:	74 42                	je     80108002 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fc3:	8b 00                	mov    (%eax),%eax
80107fc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fca:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107fcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107fd1:	75 0d                	jne    80107fe0 <deallocuvm+0x8a>
        panic("kfree");
80107fd3:	83 ec 0c             	sub    $0xc,%esp
80107fd6:	68 ed 89 10 80       	push   $0x801089ed
80107fdb:	e8 bc 85 ff ff       	call   8010059c <panic>
      char *v = P2V(pa);
80107fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fe3:	05 00 00 00 80       	add    $0x80000000,%eax
80107fe8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107feb:	83 ec 0c             	sub    $0xc,%esp
80107fee:	ff 75 e8             	pushl  -0x18(%ebp)
80107ff1:	e8 04 ac ff ff       	call   80102bfa <kfree>
80107ff6:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108002:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010800f:	0f 82 6c ff ff ff    	jb     80107f81 <deallocuvm+0x2b>
    }
  }
  return newsz;
80108015:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108018:	c9                   	leave  
80108019:	c3                   	ret    

8010801a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010801a:	55                   	push   %ebp
8010801b:	89 e5                	mov    %esp,%ebp
8010801d:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108020:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108024:	75 0d                	jne    80108033 <freevm+0x19>
    panic("freevm: no pgdir");
80108026:	83 ec 0c             	sub    $0xc,%esp
80108029:	68 f3 89 10 80       	push   $0x801089f3
8010802e:	e8 69 85 ff ff       	call   8010059c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108033:	83 ec 04             	sub    $0x4,%esp
80108036:	6a 00                	push   $0x0
80108038:	68 00 00 00 80       	push   $0x80000000
8010803d:	ff 75 08             	pushl  0x8(%ebp)
80108040:	e8 11 ff ff ff       	call   80107f56 <deallocuvm>
80108045:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108048:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010804f:	eb 48                	jmp    80108099 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80108051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108054:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010805b:	8b 45 08             	mov    0x8(%ebp),%eax
8010805e:	01 d0                	add    %edx,%eax
80108060:	8b 00                	mov    (%eax),%eax
80108062:	83 e0 01             	and    $0x1,%eax
80108065:	85 c0                	test   %eax,%eax
80108067:	74 2c                	je     80108095 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108073:	8b 45 08             	mov    0x8(%ebp),%eax
80108076:	01 d0                	add    %edx,%eax
80108078:	8b 00                	mov    (%eax),%eax
8010807a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010807f:	05 00 00 00 80       	add    $0x80000000,%eax
80108084:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108087:	83 ec 0c             	sub    $0xc,%esp
8010808a:	ff 75 f0             	pushl  -0x10(%ebp)
8010808d:	e8 68 ab ff ff       	call   80102bfa <kfree>
80108092:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108095:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108099:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801080a0:	76 af                	jbe    80108051 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801080a2:	83 ec 0c             	sub    $0xc,%esp
801080a5:	ff 75 08             	pushl  0x8(%ebp)
801080a8:	e8 4d ab ff ff       	call   80102bfa <kfree>
801080ad:	83 c4 10             	add    $0x10,%esp
}
801080b0:	90                   	nop
801080b1:	c9                   	leave  
801080b2:	c3                   	ret    

801080b3 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801080b3:	55                   	push   %ebp
801080b4:	89 e5                	mov    %esp,%ebp
801080b6:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080b9:	83 ec 04             	sub    $0x4,%esp
801080bc:	6a 00                	push   $0x0
801080be:	ff 75 0c             	pushl  0xc(%ebp)
801080c1:	ff 75 08             	pushl  0x8(%ebp)
801080c4:	e8 ba f8 ff ff       	call   80107983 <walkpgdir>
801080c9:	83 c4 10             	add    $0x10,%esp
801080cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801080cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080d3:	75 0d                	jne    801080e2 <clearpteu+0x2f>
    panic("clearpteu");
801080d5:	83 ec 0c             	sub    $0xc,%esp
801080d8:	68 04 8a 10 80       	push   $0x80108a04
801080dd:	e8 ba 84 ff ff       	call   8010059c <panic>
  *pte &= ~PTE_U;
801080e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e5:	8b 00                	mov    (%eax),%eax
801080e7:	83 e0 fb             	and    $0xfffffffb,%eax
801080ea:	89 c2                	mov    %eax,%edx
801080ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ef:	89 10                	mov    %edx,(%eax)
}
801080f1:	90                   	nop
801080f2:	c9                   	leave  
801080f3:	c3                   	ret    

801080f4 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801080f4:	55                   	push   %ebp
801080f5:	89 e5                	mov    %esp,%ebp
801080f7:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801080fa:	e8 aa f9 ff ff       	call   80107aa9 <setupkvm>
801080ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108102:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108106:	75 0a                	jne    80108112 <copyuvm+0x1e>
    return 0;
80108108:	b8 00 00 00 00       	mov    $0x0,%eax
8010810d:	e9 eb 00 00 00       	jmp    801081fd <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80108112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108119:	e9 b7 00 00 00       	jmp    801081d5 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010811e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108121:	83 ec 04             	sub    $0x4,%esp
80108124:	6a 00                	push   $0x0
80108126:	50                   	push   %eax
80108127:	ff 75 08             	pushl  0x8(%ebp)
8010812a:	e8 54 f8 ff ff       	call   80107983 <walkpgdir>
8010812f:	83 c4 10             	add    $0x10,%esp
80108132:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108135:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108139:	75 0d                	jne    80108148 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
8010813b:	83 ec 0c             	sub    $0xc,%esp
8010813e:	68 0e 8a 10 80       	push   $0x80108a0e
80108143:	e8 54 84 ff ff       	call   8010059c <panic>
    if(!(*pte & PTE_P))
80108148:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010814b:	8b 00                	mov    (%eax),%eax
8010814d:	83 e0 01             	and    $0x1,%eax
80108150:	85 c0                	test   %eax,%eax
80108152:	75 0d                	jne    80108161 <copyuvm+0x6d>
      panic("copyuvm: page not present");
80108154:	83 ec 0c             	sub    $0xc,%esp
80108157:	68 28 8a 10 80       	push   $0x80108a28
8010815c:	e8 3b 84 ff ff       	call   8010059c <panic>
    pa = PTE_ADDR(*pte);
80108161:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108164:	8b 00                	mov    (%eax),%eax
80108166:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010816b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010816e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108171:	8b 00                	mov    (%eax),%eax
80108173:	25 ff 0f 00 00       	and    $0xfff,%eax
80108178:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010817b:	e8 14 ab ff ff       	call   80102c94 <kalloc>
80108180:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108183:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108187:	74 5d                	je     801081e6 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108189:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010818c:	05 00 00 00 80       	add    $0x80000000,%eax
80108191:	83 ec 04             	sub    $0x4,%esp
80108194:	68 00 10 00 00       	push   $0x1000
80108199:	50                   	push   %eax
8010819a:	ff 75 e0             	pushl  -0x20(%ebp)
8010819d:	e8 f0 d0 ff ff       	call   80105292 <memmove>
801081a2:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801081a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081ab:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801081b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b4:	83 ec 0c             	sub    $0xc,%esp
801081b7:	52                   	push   %edx
801081b8:	51                   	push   %ecx
801081b9:	68 00 10 00 00       	push   $0x1000
801081be:	50                   	push   %eax
801081bf:	ff 75 f0             	pushl  -0x10(%ebp)
801081c2:	e8 52 f8 ff ff       	call   80107a19 <mappages>
801081c7:	83 c4 20             	add    $0x20,%esp
801081ca:	85 c0                	test   %eax,%eax
801081cc:	78 1b                	js     801081e9 <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
801081ce:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081db:	0f 82 3d ff ff ff    	jb     8010811e <copyuvm+0x2a>
      goto bad;
  }
  return d;
801081e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e4:	eb 17                	jmp    801081fd <copyuvm+0x109>
      goto bad;
801081e6:	90                   	nop
801081e7:	eb 01                	jmp    801081ea <copyuvm+0xf6>
      goto bad;
801081e9:	90                   	nop

bad:
  freevm(d);
801081ea:	83 ec 0c             	sub    $0xc,%esp
801081ed:	ff 75 f0             	pushl  -0x10(%ebp)
801081f0:	e8 25 fe ff ff       	call   8010801a <freevm>
801081f5:	83 c4 10             	add    $0x10,%esp
  return 0;
801081f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081fd:	c9                   	leave  
801081fe:	c3                   	ret    

801081ff <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801081ff:	55                   	push   %ebp
80108200:	89 e5                	mov    %esp,%ebp
80108202:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108205:	83 ec 04             	sub    $0x4,%esp
80108208:	6a 00                	push   $0x0
8010820a:	ff 75 0c             	pushl  0xc(%ebp)
8010820d:	ff 75 08             	pushl  0x8(%ebp)
80108210:	e8 6e f7 ff ff       	call   80107983 <walkpgdir>
80108215:	83 c4 10             	add    $0x10,%esp
80108218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010821b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821e:	8b 00                	mov    (%eax),%eax
80108220:	83 e0 01             	and    $0x1,%eax
80108223:	85 c0                	test   %eax,%eax
80108225:	75 07                	jne    8010822e <uva2ka+0x2f>
    return 0;
80108227:	b8 00 00 00 00       	mov    $0x0,%eax
8010822c:	eb 22                	jmp    80108250 <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
8010822e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108231:	8b 00                	mov    (%eax),%eax
80108233:	83 e0 04             	and    $0x4,%eax
80108236:	85 c0                	test   %eax,%eax
80108238:	75 07                	jne    80108241 <uva2ka+0x42>
    return 0;
8010823a:	b8 00 00 00 00       	mov    $0x0,%eax
8010823f:	eb 0f                	jmp    80108250 <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80108241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108244:	8b 00                	mov    (%eax),%eax
80108246:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010824b:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108250:	c9                   	leave  
80108251:	c3                   	ret    

80108252 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108252:	55                   	push   %ebp
80108253:	89 e5                	mov    %esp,%ebp
80108255:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108258:	8b 45 10             	mov    0x10(%ebp),%eax
8010825b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010825e:	eb 7f                	jmp    801082df <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108260:	8b 45 0c             	mov    0xc(%ebp),%eax
80108263:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108268:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010826b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010826e:	83 ec 08             	sub    $0x8,%esp
80108271:	50                   	push   %eax
80108272:	ff 75 08             	pushl  0x8(%ebp)
80108275:	e8 85 ff ff ff       	call   801081ff <uva2ka>
8010827a:	83 c4 10             	add    $0x10,%esp
8010827d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108280:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108284:	75 07                	jne    8010828d <copyout+0x3b>
      return -1;
80108286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010828b:	eb 61                	jmp    801082ee <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010828d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108290:	2b 45 0c             	sub    0xc(%ebp),%eax
80108293:	05 00 10 00 00       	add    $0x1000,%eax
80108298:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010829b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010829e:	3b 45 14             	cmp    0x14(%ebp),%eax
801082a1:	76 06                	jbe    801082a9 <copyout+0x57>
      n = len;
801082a3:	8b 45 14             	mov    0x14(%ebp),%eax
801082a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801082a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
801082af:	89 c2                	mov    %eax,%edx
801082b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082b4:	01 d0                	add    %edx,%eax
801082b6:	83 ec 04             	sub    $0x4,%esp
801082b9:	ff 75 f0             	pushl  -0x10(%ebp)
801082bc:	ff 75 f4             	pushl  -0xc(%ebp)
801082bf:	50                   	push   %eax
801082c0:	e8 cd cf ff ff       	call   80105292 <memmove>
801082c5:	83 c4 10             	add    $0x10,%esp
    len -= n;
801082c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082cb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801082ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082d1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801082d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082d7:	05 00 10 00 00       	add    $0x1000,%eax
801082dc:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801082df:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801082e3:	0f 85 77 ff ff ff    	jne    80108260 <copyout+0xe>
  }
  return 0;
801082e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082ee:	c9                   	leave  
801082ef:	c3                   	ret    
