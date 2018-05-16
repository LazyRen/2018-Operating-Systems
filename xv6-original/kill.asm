
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 f2 07 00 00       	push   $0x7f2
  21:	6a 02                	push   $0x2
  23:	e8 14 04 00 00       	call   43c <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 99 02 00 00       	call   2c9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 9a 02 00 00       	call   2f9 <kill>
  5f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
  exit();
  6d:	e8 57 02 00 00       	call   2c9 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  a8:	8d 42 01             	lea    0x1(%edx),%eax
  ab:	89 45 0c             	mov    %eax,0xc(%ebp)
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 48 01             	lea    0x1(%eax),%ecx
  b4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 47 01 00 00       	call   2e1 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d5:	7f b3                	jg     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
      break;
 1d9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 42 01             	lea    0x1(%edx),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a4:	8d 48 01             	lea    0x1(%eax),%ecx
 2a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 18             	sub    $0x18,%esp
 36f:	8b 45 0c             	mov    0xc(%ebp),%eax
 372:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 375:	83 ec 04             	sub    $0x4,%esp
 378:	6a 01                	push   $0x1
 37a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37d:	50                   	push   %eax
 37e:	ff 75 08             	pushl  0x8(%ebp)
 381:	e8 63 ff ff ff       	call   2e9 <write>
 386:	83 c4 10             	add    $0x10,%esp
}
 389:	90                   	nop
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 399:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39d:	74 17                	je     3b6 <printint+0x2a>
 39f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a3:	79 11                	jns    3b6 <printint+0x2a>
    neg = 1;
 3a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 3af:	f7 d8                	neg    %eax
 3b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b4:	eb 06                	jmp    3bc <printint+0x30>
  } else {
    x = xx;
 3b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ce:	f7 f1                	div    %ecx
 3d0:	89 d1                	mov    %edx,%ecx
 3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d5:	8d 50 01             	lea    0x1(%eax),%edx
 3d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3db:	0f b6 91 58 0a 00 00 	movzbl 0xa58(%ecx),%edx
 3e2:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ec:	ba 00 00 00 00       	mov    $0x0,%edx
 3f1:	f7 f1                	div    %ecx
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fa:	75 c7                	jne    3c3 <printint+0x37>
  if(neg)
 3fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 400:	74 2d                	je     42f <printint+0xa3>
    buf[i++] = '-';
 402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 405:	8d 50 01             	lea    0x1(%eax),%edx
 408:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 410:	eb 1d                	jmp    42f <printint+0xa3>
    putc(fd, buf[i]);
 412:	8d 55 dc             	lea    -0x24(%ebp),%edx
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	01 d0                	add    %edx,%eax
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	0f be c0             	movsbl %al,%eax
 420:	83 ec 08             	sub    $0x8,%esp
 423:	50                   	push   %eax
 424:	ff 75 08             	pushl  0x8(%ebp)
 427:	e8 3d ff ff ff       	call   369 <putc>
 42c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 42f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 437:	79 d9                	jns    412 <printint+0x86>
}
 439:	90                   	nop
 43a:	c9                   	leave  
 43b:	c3                   	ret    

0000043c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 442:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 449:	8d 45 0c             	lea    0xc(%ebp),%eax
 44c:	83 c0 04             	add    $0x4,%eax
 44f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 452:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 459:	e9 59 01 00 00       	jmp    5b7 <printf+0x17b>
    c = fmt[i] & 0xff;
 45e:	8b 55 0c             	mov    0xc(%ebp),%edx
 461:	8b 45 f0             	mov    -0x10(%ebp),%eax
 464:	01 d0                	add    %edx,%eax
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	0f be c0             	movsbl %al,%eax
 46c:	25 ff 00 00 00       	and    $0xff,%eax
 471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 474:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 478:	75 2c                	jne    4a6 <printf+0x6a>
      if(c == '%'){
 47a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47e:	75 0c                	jne    48c <printf+0x50>
        state = '%';
 480:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 487:	e9 27 01 00 00       	jmp    5b3 <printf+0x177>
      } else {
        putc(fd, c);
 48c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48f:	0f be c0             	movsbl %al,%eax
 492:	83 ec 08             	sub    $0x8,%esp
 495:	50                   	push   %eax
 496:	ff 75 08             	pushl  0x8(%ebp)
 499:	e8 cb fe ff ff       	call   369 <putc>
 49e:	83 c4 10             	add    $0x10,%esp
 4a1:	e9 0d 01 00 00       	jmp    5b3 <printf+0x177>
      }
    } else if(state == '%'){
 4a6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4aa:	0f 85 03 01 00 00    	jne    5b3 <printf+0x177>
      if(c == 'd'){
 4b0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b4:	75 1e                	jne    4d4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b9:	8b 00                	mov    (%eax),%eax
 4bb:	6a 01                	push   $0x1
 4bd:	6a 0a                	push   $0xa
 4bf:	50                   	push   %eax
 4c0:	ff 75 08             	pushl  0x8(%ebp)
 4c3:	e8 c4 fe ff ff       	call   38c <printint>
 4c8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cf:	e9 d8 00 00 00       	jmp    5ac <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d8:	74 06                	je     4e0 <printf+0xa4>
 4da:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4de:	75 1e                	jne    4fe <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e3:	8b 00                	mov    (%eax),%eax
 4e5:	6a 00                	push   $0x0
 4e7:	6a 10                	push   $0x10
 4e9:	50                   	push   %eax
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 9a fe ff ff       	call   38c <printint>
 4f2:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f9:	e9 ae 00 00 00       	jmp    5ac <printf+0x170>
      } else if(c == 's'){
 4fe:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 502:	75 43                	jne    547 <printf+0x10b>
        s = (char*)*ap;
 504:	8b 45 e8             	mov    -0x18(%ebp),%eax
 507:	8b 00                	mov    (%eax),%eax
 509:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 50c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 514:	75 25                	jne    53b <printf+0xff>
          s = "(null)";
 516:	c7 45 f4 06 08 00 00 	movl   $0x806,-0xc(%ebp)
        while(*s != 0){
 51d:	eb 1c                	jmp    53b <printf+0xff>
          putc(fd, *s);
 51f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 522:	0f b6 00             	movzbl (%eax),%eax
 525:	0f be c0             	movsbl %al,%eax
 528:	83 ec 08             	sub    $0x8,%esp
 52b:	50                   	push   %eax
 52c:	ff 75 08             	pushl  0x8(%ebp)
 52f:	e8 35 fe ff ff       	call   369 <putc>
 534:	83 c4 10             	add    $0x10,%esp
          s++;
 537:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	84 c0                	test   %al,%al
 543:	75 da                	jne    51f <printf+0xe3>
 545:	eb 65                	jmp    5ac <printf+0x170>
        }
      } else if(c == 'c'){
 547:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 54b:	75 1d                	jne    56a <printf+0x12e>
        putc(fd, *ap);
 54d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 550:	8b 00                	mov    (%eax),%eax
 552:	0f be c0             	movsbl %al,%eax
 555:	83 ec 08             	sub    $0x8,%esp
 558:	50                   	push   %eax
 559:	ff 75 08             	pushl  0x8(%ebp)
 55c:	e8 08 fe ff ff       	call   369 <putc>
 561:	83 c4 10             	add    $0x10,%esp
        ap++;
 564:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 568:	eb 42                	jmp    5ac <printf+0x170>
      } else if(c == '%'){
 56a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56e:	75 17                	jne    587 <printf+0x14b>
        putc(fd, c);
 570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	83 ec 08             	sub    $0x8,%esp
 579:	50                   	push   %eax
 57a:	ff 75 08             	pushl  0x8(%ebp)
 57d:	e8 e7 fd ff ff       	call   369 <putc>
 582:	83 c4 10             	add    $0x10,%esp
 585:	eb 25                	jmp    5ac <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 587:	83 ec 08             	sub    $0x8,%esp
 58a:	6a 25                	push   $0x25
 58c:	ff 75 08             	pushl  0x8(%ebp)
 58f:	e8 d5 fd ff ff       	call   369 <putc>
 594:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59a:	0f be c0             	movsbl %al,%eax
 59d:	83 ec 08             	sub    $0x8,%esp
 5a0:	50                   	push   %eax
 5a1:	ff 75 08             	pushl  0x8(%ebp)
 5a4:	e8 c0 fd ff ff       	call   369 <putc>
 5a9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5b3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bd:	01 d0                	add    %edx,%eax
 5bf:	0f b6 00             	movzbl (%eax),%eax
 5c2:	84 c0                	test   %al,%al
 5c4:	0f 85 94 fe ff ff    	jne    45e <printf+0x22>
    }
  }
}
 5ca:	90                   	nop
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    

000005cd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	83 e8 08             	sub    $0x8,%eax
 5d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dc:	a1 74 0a 00 00       	mov    0xa74,%eax
 5e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e4:	eb 24                	jmp    60a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5ee:	72 12                	jb     602 <free+0x35>
 5f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f6:	77 24                	ja     61c <free+0x4f>
 5f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 600:	72 1a                	jb     61c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 610:	76 d4                	jbe    5e6 <free+0x19>
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 61a:	73 ca                	jae    5e6 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	8b 40 04             	mov    0x4(%eax),%eax
 622:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	01 c2                	add    %eax,%edx
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	39 c2                	cmp    %eax,%edx
 635:	75 24                	jne    65b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 50 04             	mov    0x4(%eax),%edx
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	8b 40 04             	mov    0x4(%eax),%eax
 645:	01 c2                	add    %eax,%edx
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	8b 10                	mov    (%eax),%edx
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	89 10                	mov    %edx,(%eax)
 659:	eb 0a                	jmp    665 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 10                	mov    (%eax),%edx
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 40 04             	mov    0x4(%eax),%eax
 66b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	01 d0                	add    %edx,%eax
 677:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 67a:	75 20                	jne    69c <free+0xcf>
    p->s.size += bp->s.size;
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 50 04             	mov    0x4(%eax),%edx
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 40 04             	mov    0x4(%eax),%eax
 688:	01 c2                	add    %eax,%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 690:	8b 45 f8             	mov    -0x8(%ebp),%eax
 693:	8b 10                	mov    (%eax),%edx
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	89 10                	mov    %edx,(%eax)
 69a:	eb 08                	jmp    6a4 <free+0xd7>
  } else
    p->s.ptr = bp;
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	a3 74 0a 00 00       	mov    %eax,0xa74
}
 6ac:	90                   	nop
 6ad:	c9                   	leave  
 6ae:	c3                   	ret    

000006af <morecore>:

static Header*
morecore(uint nu)
{
 6af:	55                   	push   %ebp
 6b0:	89 e5                	mov    %esp,%ebp
 6b2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6bc:	77 07                	ja     6c5 <morecore+0x16>
    nu = 4096;
 6be:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	c1 e0 03             	shl    $0x3,%eax
 6cb:	83 ec 0c             	sub    $0xc,%esp
 6ce:	50                   	push   %eax
 6cf:	e8 7d fc ff ff       	call   351 <sbrk>
 6d4:	83 c4 10             	add    $0x10,%esp
 6d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6da:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6de:	75 07                	jne    6e7 <morecore+0x38>
    return 0;
 6e0:	b8 00 00 00 00       	mov    $0x0,%eax
 6e5:	eb 26                	jmp    70d <morecore+0x5e>
  hp = (Header*)p;
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f0:	8b 55 08             	mov    0x8(%ebp),%edx
 6f3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f9:	83 c0 08             	add    $0x8,%eax
 6fc:	83 ec 0c             	sub    $0xc,%esp
 6ff:	50                   	push   %eax
 700:	e8 c8 fe ff ff       	call   5cd <free>
 705:	83 c4 10             	add    $0x10,%esp
  return freep;
 708:	a1 74 0a 00 00       	mov    0xa74,%eax
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <malloc>:

void*
malloc(uint nbytes)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	83 c0 07             	add    $0x7,%eax
 71b:	c1 e8 03             	shr    $0x3,%eax
 71e:	83 c0 01             	add    $0x1,%eax
 721:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 724:	a1 74 0a 00 00       	mov    0xa74,%eax
 729:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 730:	75 23                	jne    755 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 732:	c7 45 f0 6c 0a 00 00 	movl   $0xa6c,-0x10(%ebp)
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	a3 74 0a 00 00       	mov    %eax,0xa74
 741:	a1 74 0a 00 00       	mov    0xa74,%eax
 746:	a3 6c 0a 00 00       	mov    %eax,0xa6c
    base.s.size = 0;
 74b:	c7 05 70 0a 00 00 00 	movl   $0x0,0xa70
 752:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 766:	77 4d                	ja     7b5 <malloc+0xa6>
      if(p->s.size == nunits)
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 771:	75 0c                	jne    77f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	89 10                	mov    %edx,(%eax)
 77d:	eb 26                	jmp    7a5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	2b 45 ec             	sub    -0x14(%ebp),%eax
 788:	89 c2                	mov    %eax,%edx
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	c1 e0 03             	shl    $0x3,%eax
 799:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	a3 74 0a 00 00       	mov    %eax,0xa74
      return (void*)(p + 1);
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	83 c0 08             	add    $0x8,%eax
 7b3:	eb 3b                	jmp    7f0 <malloc+0xe1>
    }
    if(p == freep)
 7b5:	a1 74 0a 00 00       	mov    0xa74,%eax
 7ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bd:	75 1e                	jne    7dd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7bf:	83 ec 0c             	sub    $0xc,%esp
 7c2:	ff 75 ec             	pushl  -0x14(%ebp)
 7c5:	e8 e5 fe ff ff       	call   6af <morecore>
 7ca:	83 c4 10             	add    $0x10,%esp
 7cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d4:	75 07                	jne    7dd <malloc+0xce>
        return 0;
 7d6:	b8 00 00 00 00       	mov    $0x0,%eax
 7db:	eb 13                	jmp    7f0 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7eb:	e9 6d ff ff ff       	jmp    75d <malloc+0x4e>
  }
}
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    
