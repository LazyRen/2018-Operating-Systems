
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 f4 07 00 00       	push   $0x7f4
  1e:	6a 02                	push   $0x2
  20:	e8 19 04 00 00       	call   43e <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9e 02 00 00       	call   2cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e4 02 00 00       	call   32b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 07 08 00 00       	push   $0x807
  65:	6a 02                	push   $0x2
  67:	e8 d2 03 00 00       	call   43e <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 42 01             	lea    0x1(%edx),%eax
  ad:	89 45 0c             	mov    %eax,0xc(%ebp)
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8d 48 01             	lea    0x1(%eax),%ecx
  b6:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d7:	7f b3                	jg     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
      break;
 1db:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29d:	8d 42 01             	lea    0x1(%edx),%eax
 2a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 48 01             	lea    0x1(%eax),%ecx
 2a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 18             	sub    $0x18,%esp
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 377:	83 ec 04             	sub    $0x4,%esp
 37a:	6a 01                	push   $0x1
 37c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37f:	50                   	push   %eax
 380:	ff 75 08             	pushl  0x8(%ebp)
 383:	e8 63 ff ff ff       	call   2eb <write>
 388:	83 c4 10             	add    $0x10,%esp
}
 38b:	90                   	nop
 38c:	c9                   	leave  
 38d:	c3                   	ret    

0000038e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 394:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39f:	74 17                	je     3b8 <printint+0x2a>
 3a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a5:	79 11                	jns    3b8 <printint+0x2a>
    neg = 1;
 3a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	f7 d8                	neg    %eax
 3b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b6:	eb 06                	jmp    3be <printint+0x30>
  } else {
    x = xx;
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cb:	ba 00 00 00 00       	mov    $0x0,%edx
 3d0:	f7 f1                	div    %ecx
 3d2:	89 d1                	mov    %edx,%ecx
 3d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d7:	8d 50 01             	lea    0x1(%eax),%edx
 3da:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3dd:	0f b6 91 6c 0a 00 00 	movzbl 0xa6c(%ecx),%edx
 3e4:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ee:	ba 00 00 00 00       	mov    $0x0,%edx
 3f3:	f7 f1                	div    %ecx
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fc:	75 c7                	jne    3c5 <printint+0x37>
  if(neg)
 3fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 402:	74 2d                	je     431 <printint+0xa3>
    buf[i++] = '-';
 404:	8b 45 f4             	mov    -0xc(%ebp),%eax
 407:	8d 50 01             	lea    0x1(%eax),%edx
 40a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 412:	eb 1d                	jmp    431 <printint+0xa3>
    putc(fd, buf[i]);
 414:	8d 55 dc             	lea    -0x24(%ebp),%edx
 417:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41a:	01 d0                	add    %edx,%eax
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	0f be c0             	movsbl %al,%eax
 422:	83 ec 08             	sub    $0x8,%esp
 425:	50                   	push   %eax
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 3d ff ff ff       	call   36b <putc>
 42e:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 431:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 435:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 439:	79 d9                	jns    414 <printint+0x86>
}
 43b:	90                   	nop
 43c:	c9                   	leave  
 43d:	c3                   	ret    

0000043e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43e:	55                   	push   %ebp
 43f:	89 e5                	mov    %esp,%ebp
 441:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 444:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44b:	8d 45 0c             	lea    0xc(%ebp),%eax
 44e:	83 c0 04             	add    $0x4,%eax
 451:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 454:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45b:	e9 59 01 00 00       	jmp    5b9 <printf+0x17b>
    c = fmt[i] & 0xff;
 460:	8b 55 0c             	mov    0xc(%ebp),%edx
 463:	8b 45 f0             	mov    -0x10(%ebp),%eax
 466:	01 d0                	add    %edx,%eax
 468:	0f b6 00             	movzbl (%eax),%eax
 46b:	0f be c0             	movsbl %al,%eax
 46e:	25 ff 00 00 00       	and    $0xff,%eax
 473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 476:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47a:	75 2c                	jne    4a8 <printf+0x6a>
      if(c == '%'){
 47c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 480:	75 0c                	jne    48e <printf+0x50>
        state = '%';
 482:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 489:	e9 27 01 00 00       	jmp    5b5 <printf+0x177>
      } else {
        putc(fd, c);
 48e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 491:	0f be c0             	movsbl %al,%eax
 494:	83 ec 08             	sub    $0x8,%esp
 497:	50                   	push   %eax
 498:	ff 75 08             	pushl  0x8(%ebp)
 49b:	e8 cb fe ff ff       	call   36b <putc>
 4a0:	83 c4 10             	add    $0x10,%esp
 4a3:	e9 0d 01 00 00       	jmp    5b5 <printf+0x177>
      }
    } else if(state == '%'){
 4a8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ac:	0f 85 03 01 00 00    	jne    5b5 <printf+0x177>
      if(c == 'd'){
 4b2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b6:	75 1e                	jne    4d6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bb:	8b 00                	mov    (%eax),%eax
 4bd:	6a 01                	push   $0x1
 4bf:	6a 0a                	push   $0xa
 4c1:	50                   	push   %eax
 4c2:	ff 75 08             	pushl  0x8(%ebp)
 4c5:	e8 c4 fe ff ff       	call   38e <printint>
 4ca:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d1:	e9 d8 00 00 00       	jmp    5ae <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4da:	74 06                	je     4e2 <printf+0xa4>
 4dc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e0:	75 1e                	jne    500 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e5:	8b 00                	mov    (%eax),%eax
 4e7:	6a 00                	push   $0x0
 4e9:	6a 10                	push   $0x10
 4eb:	50                   	push   %eax
 4ec:	ff 75 08             	pushl  0x8(%ebp)
 4ef:	e8 9a fe ff ff       	call   38e <printint>
 4f4:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fb:	e9 ae 00 00 00       	jmp    5ae <printf+0x170>
      } else if(c == 's'){
 500:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 504:	75 43                	jne    549 <printf+0x10b>
        s = (char*)*ap;
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 50e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 516:	75 25                	jne    53d <printf+0xff>
          s = "(null)";
 518:	c7 45 f4 1b 08 00 00 	movl   $0x81b,-0xc(%ebp)
        while(*s != 0){
 51f:	eb 1c                	jmp    53d <printf+0xff>
          putc(fd, *s);
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	0f b6 00             	movzbl (%eax),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	83 ec 08             	sub    $0x8,%esp
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 35 fe ff ff       	call   36b <putc>
 536:	83 c4 10             	add    $0x10,%esp
          s++;
 539:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 53d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	84 c0                	test   %al,%al
 545:	75 da                	jne    521 <printf+0xe3>
 547:	eb 65                	jmp    5ae <printf+0x170>
        }
      } else if(c == 'c'){
 549:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 54d:	75 1d                	jne    56c <printf+0x12e>
        putc(fd, *ap);
 54f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 552:	8b 00                	mov    (%eax),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	83 ec 08             	sub    $0x8,%esp
 55a:	50                   	push   %eax
 55b:	ff 75 08             	pushl  0x8(%ebp)
 55e:	e8 08 fe ff ff       	call   36b <putc>
 563:	83 c4 10             	add    $0x10,%esp
        ap++;
 566:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56a:	eb 42                	jmp    5ae <printf+0x170>
      } else if(c == '%'){
 56c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 570:	75 17                	jne    589 <printf+0x14b>
        putc(fd, c);
 572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 e7 fd ff ff       	call   36b <putc>
 584:	83 c4 10             	add    $0x10,%esp
 587:	eb 25                	jmp    5ae <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 589:	83 ec 08             	sub    $0x8,%esp
 58c:	6a 25                	push   $0x25
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 d5 fd ff ff       	call   36b <putc>
 596:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	83 ec 08             	sub    $0x8,%esp
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 c0 fd ff ff       	call   36b <putc>
 5ab:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5b5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bf:	01 d0                	add    %edx,%eax
 5c1:	0f b6 00             	movzbl (%eax),%eax
 5c4:	84 c0                	test   %al,%al
 5c6:	0f 85 94 fe ff ff    	jne    460 <printf+0x22>
    }
  }
}
 5cc:	90                   	nop
 5cd:	c9                   	leave  
 5ce:	c3                   	ret    

000005cf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cf:	55                   	push   %ebp
 5d0:	89 e5                	mov    %esp,%ebp
 5d2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	83 e8 08             	sub    $0x8,%eax
 5db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5de:	a1 88 0a 00 00       	mov    0xa88,%eax
 5e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e6:	eb 24                	jmp    60c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5eb:	8b 00                	mov    (%eax),%eax
 5ed:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5f0:	72 12                	jb     604 <free+0x35>
 5f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f8:	77 24                	ja     61e <free+0x4f>
 5fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fd:	8b 00                	mov    (%eax),%eax
 5ff:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 602:	72 1a                	jb     61e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 604:	8b 45 fc             	mov    -0x4(%ebp),%eax
 607:	8b 00                	mov    (%eax),%eax
 609:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 612:	76 d4                	jbe    5e8 <free+0x19>
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 61c:	73 ca                	jae    5e8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	8b 40 04             	mov    0x4(%eax),%eax
 624:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	01 c2                	add    %eax,%edx
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	39 c2                	cmp    %eax,%edx
 637:	75 24                	jne    65d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	8b 50 04             	mov    0x4(%eax),%edx
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	8b 40 04             	mov    0x4(%eax),%eax
 647:	01 c2                	add    %eax,%edx
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	8b 10                	mov    (%eax),%edx
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	89 10                	mov    %edx,(%eax)
 65b:	eb 0a                	jmp    667 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 10                	mov    (%eax),%edx
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	01 d0                	add    %edx,%eax
 679:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 67c:	75 20                	jne    69e <free+0xcf>
    p->s.size += bp->s.size;
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 50 04             	mov    0x4(%eax),%edx
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	8b 40 04             	mov    0x4(%eax),%eax
 68a:	01 c2                	add    %eax,%edx
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
 69c:	eb 08                	jmp    6a6 <free+0xd7>
  } else
    p->s.ptr = bp;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	a3 88 0a 00 00       	mov    %eax,0xa88
}
 6ae:	90                   	nop
 6af:	c9                   	leave  
 6b0:	c3                   	ret    

000006b1 <morecore>:

static Header*
morecore(uint nu)
{
 6b1:	55                   	push   %ebp
 6b2:	89 e5                	mov    %esp,%ebp
 6b4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6be:	77 07                	ja     6c7 <morecore+0x16>
    nu = 4096;
 6c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ca:	c1 e0 03             	shl    $0x3,%eax
 6cd:	83 ec 0c             	sub    $0xc,%esp
 6d0:	50                   	push   %eax
 6d1:	e8 7d fc ff ff       	call   353 <sbrk>
 6d6:	83 c4 10             	add    $0x10,%esp
 6d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6dc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e0:	75 07                	jne    6e9 <morecore+0x38>
    return 0;
 6e2:	b8 00 00 00 00       	mov    $0x0,%eax
 6e7:	eb 26                	jmp    70f <morecore+0x5e>
  hp = (Header*)p;
 6e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f2:	8b 55 08             	mov    0x8(%ebp),%edx
 6f5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fb:	83 c0 08             	add    $0x8,%eax
 6fe:	83 ec 0c             	sub    $0xc,%esp
 701:	50                   	push   %eax
 702:	e8 c8 fe ff ff       	call   5cf <free>
 707:	83 c4 10             	add    $0x10,%esp
  return freep;
 70a:	a1 88 0a 00 00       	mov    0xa88,%eax
}
 70f:	c9                   	leave  
 710:	c3                   	ret    

00000711 <malloc>:

void*
malloc(uint nbytes)
{
 711:	55                   	push   %ebp
 712:	89 e5                	mov    %esp,%ebp
 714:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	83 c0 07             	add    $0x7,%eax
 71d:	c1 e8 03             	shr    $0x3,%eax
 720:	83 c0 01             	add    $0x1,%eax
 723:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 726:	a1 88 0a 00 00       	mov    0xa88,%eax
 72b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 732:	75 23                	jne    757 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 734:	c7 45 f0 80 0a 00 00 	movl   $0xa80,-0x10(%ebp)
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	a3 88 0a 00 00       	mov    %eax,0xa88
 743:	a1 88 0a 00 00       	mov    0xa88,%eax
 748:	a3 80 0a 00 00       	mov    %eax,0xa80
    base.s.size = 0;
 74d:	c7 05 84 0a 00 00 00 	movl   $0x0,0xa84
 754:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 757:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 762:	8b 40 04             	mov    0x4(%eax),%eax
 765:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 768:	77 4d                	ja     7b7 <malloc+0xa6>
      if(p->s.size == nunits)
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 773:	75 0c                	jne    781 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	8b 10                	mov    (%eax),%edx
 77a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77d:	89 10                	mov    %edx,(%eax)
 77f:	eb 26                	jmp    7a7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	2b 45 ec             	sub    -0x14(%ebp),%eax
 78a:	89 c2                	mov    %eax,%edx
 78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	8b 40 04             	mov    0x4(%eax),%eax
 798:	c1 e0 03             	shl    $0x3,%eax
 79b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7aa:	a3 88 0a 00 00       	mov    %eax,0xa88
      return (void*)(p + 1);
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	83 c0 08             	add    $0x8,%eax
 7b5:	eb 3b                	jmp    7f2 <malloc+0xe1>
    }
    if(p == freep)
 7b7:	a1 88 0a 00 00       	mov    0xa88,%eax
 7bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bf:	75 1e                	jne    7df <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7c1:	83 ec 0c             	sub    $0xc,%esp
 7c4:	ff 75 ec             	pushl  -0x14(%ebp)
 7c7:	e8 e5 fe ff ff       	call   6b1 <morecore>
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d6:	75 07                	jne    7df <malloc+0xce>
        return 0;
 7d8:	b8 00 00 00 00       	mov    $0x0,%eax
 7dd:	eb 13                	jmp    7f2 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 00                	mov    (%eax),%eax
 7ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ed:	e9 6d ff ff ff       	jmp    75f <malloc+0x4e>
  }
}
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    
