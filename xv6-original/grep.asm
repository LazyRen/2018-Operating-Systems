
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 00 0e 00 00       	add    $0xe00,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 43 05 00 00       	call   5ad <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
    }
    if(p == buf)
  8f:	81 7d f0 00 0e 00 00 	cmpl   $0xe00,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba 00 0e 00 00       	mov    $0xe00,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	pushl  -0xc(%ebp)
  b8:	ff 75 f0             	pushl  -0x10(%ebp)
  bb:	68 00 0e 00 00       	push   $0xe00
  c0:	e8 83 04 00 00       	call   548 <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 00 0e 00 00       	add    $0xe00,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	e8 ba 04 00 00       	call   5a5 <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	pushl  -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 b8 0a 00 00       	push   $0xab8
 11f:	6a 02                	push   $0x2
 121:	e8 da 05 00 00       	call   700 <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 5f 04 00 00       	call   58d <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 3c 04 00 00       	call   58d <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 57 04 00 00       	call   5cd <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 d8 0a 00 00       	push   $0xad8
 19c:	6a 01                	push   $0x1
 19e:	e8 5d 05 00 00       	call   700 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 e2 03 00 00       	call   58d <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	pushl  -0x14(%ebp)
 1b1:	ff 75 f0             	pushl  -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	pushl  -0x14(%ebp)
 1c2:	e8 ee 03 00 00       	call   5b5 <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
  }
  exit();
 1d5:	e8 b3 03 00 00       	call   58d <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	pushl  0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 08             	pushl  0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	pushl  0x10(%ebp)
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	39 45 08             	cmp    %eax,0x8(%ebp)
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	57                   	push   %edi
 33a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33e:	8b 55 10             	mov    0x10(%ebp),%edx
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 cb                	mov    %ecx,%ebx
 346:	89 df                	mov    %ebx,%edi
 348:	89 d1                	mov    %edx,%ecx
 34a:	fc                   	cld    
 34b:	f3 aa                	rep stos %al,%es:(%edi)
 34d:	89 ca                	mov    %ecx,%edx
 34f:	89 fb                	mov    %edi,%ebx
 351:	89 5d 08             	mov    %ebx,0x8(%ebp)
 354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 357:	90                   	nop
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 55 0c             	mov    0xc(%ebp),%edx
 36c:	8d 42 01             	lea    0x1(%edx),%eax
 36f:	89 45 0c             	mov    %eax,0xc(%ebp)
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	8d 48 01             	lea    0x1(%eax),%ecx
 378:	89 4d 08             	mov    %ecx,0x8(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	pushl  0xc(%ebp)
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 32 ff ff ff       	call   336 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	38 45 fc             	cmp    %al,-0x4(%ebp)
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 42                	jmp    490 <gets+0x51>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 47 01 00 00       	call   5a5 <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7e 33                	jle    49d <gets+0x5e>
      break;
    buf[i++] = c;
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	89 c2                	mov    %eax,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 c2                	add    %eax,%edx
 47a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0a                	cmp    $0xa,%al
 486:	74 16                	je     49e <gets+0x5f>
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	3c 0d                	cmp    $0xd,%al
 48e:	74 0e                	je     49e <gets+0x5f>
  for(i=0; i+1 < max; ){
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	39 45 0c             	cmp    %eax,0xc(%ebp)
 499:	7f b3                	jg     44e <gets+0xf>
 49b:	eb 01                	jmp    49e <gets+0x5f>
      break;
 49d:	90                   	nop
      break;
  }
  buf[i] = '\0';
 49e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <stat>:

int
stat(char *n, struct stat *st)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 0c 01 00 00       	call   5cd <open>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cb:	79 07                	jns    4d4 <stat+0x26>
    return -1;
 4cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d2:	eb 25                	jmp    4f9 <stat+0x4b>
  r = fstat(fd, st);
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	ff 75 0c             	pushl  0xc(%ebp)
 4da:	ff 75 f4             	pushl  -0xc(%ebp)
 4dd:	e8 03 01 00 00       	call   5e5 <fstat>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	ff 75 f4             	pushl  -0xc(%ebp)
 4ee:	e8 c2 00 00 00       	call   5b5 <close>
 4f3:	83 c4 10             	add    $0x10,%esp
  return r;
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <atoi>:

int
atoi(const char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 508:	eb 25                	jmp    52f <atoi+0x34>
    n = n*10 + *s++ - '0';
 50a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 50d:	89 d0                	mov    %edx,%eax
 50f:	c1 e0 02             	shl    $0x2,%eax
 512:	01 d0                	add    %edx,%eax
 514:	01 c0                	add    %eax,%eax
 516:	89 c1                	mov    %eax,%ecx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	8d 50 01             	lea    0x1(%eax),%edx
 51e:	89 55 08             	mov    %edx,0x8(%ebp)
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	01 c8                	add    %ecx,%eax
 529:	83 e8 30             	sub    $0x30,%eax
 52c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	3c 2f                	cmp    $0x2f,%al
 537:	7e 0a                	jle    543 <atoi+0x48>
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	0f b6 00             	movzbl (%eax),%eax
 53f:	3c 39                	cmp    $0x39,%al
 541:	7e c7                	jle    50a <atoi+0xf>
  return n;
 543:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 546:	c9                   	leave  
 547:	c3                   	ret    

00000548 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 548:	55                   	push   %ebp
 549:	89 e5                	mov    %esp,%ebp
 54b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 554:	8b 45 0c             	mov    0xc(%ebp),%eax
 557:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 55a:	eb 17                	jmp    573 <memmove+0x2b>
    *dst++ = *src++;
 55c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 55f:	8d 42 01             	lea    0x1(%edx),%eax
 562:	89 45 f8             	mov    %eax,-0x8(%ebp)
 565:	8b 45 fc             	mov    -0x4(%ebp),%eax
 568:	8d 48 01             	lea    0x1(%eax),%ecx
 56b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 56e:	0f b6 12             	movzbl (%edx),%edx
 571:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 573:	8b 45 10             	mov    0x10(%ebp),%eax
 576:	8d 50 ff             	lea    -0x1(%eax),%edx
 579:	89 55 10             	mov    %edx,0x10(%ebp)
 57c:	85 c0                	test   %eax,%eax
 57e:	7f dc                	jg     55c <memmove+0x14>
  return vdst;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
}
 583:	c9                   	leave  
 584:	c3                   	ret    

00000585 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 585:	b8 01 00 00 00       	mov    $0x1,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <exit>:
SYSCALL(exit)
 58d:	b8 02 00 00 00       	mov    $0x2,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <wait>:
SYSCALL(wait)
 595:	b8 03 00 00 00       	mov    $0x3,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <pipe>:
SYSCALL(pipe)
 59d:	b8 04 00 00 00       	mov    $0x4,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <read>:
SYSCALL(read)
 5a5:	b8 05 00 00 00       	mov    $0x5,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <write>:
SYSCALL(write)
 5ad:	b8 10 00 00 00       	mov    $0x10,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <close>:
SYSCALL(close)
 5b5:	b8 15 00 00 00       	mov    $0x15,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <kill>:
SYSCALL(kill)
 5bd:	b8 06 00 00 00       	mov    $0x6,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <exec>:
SYSCALL(exec)
 5c5:	b8 07 00 00 00       	mov    $0x7,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <open>:
SYSCALL(open)
 5cd:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <mknod>:
SYSCALL(mknod)
 5d5:	b8 11 00 00 00       	mov    $0x11,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <unlink>:
SYSCALL(unlink)
 5dd:	b8 12 00 00 00       	mov    $0x12,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <fstat>:
SYSCALL(fstat)
 5e5:	b8 08 00 00 00       	mov    $0x8,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <link>:
SYSCALL(link)
 5ed:	b8 13 00 00 00       	mov    $0x13,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <mkdir>:
SYSCALL(mkdir)
 5f5:	b8 14 00 00 00       	mov    $0x14,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <chdir>:
SYSCALL(chdir)
 5fd:	b8 09 00 00 00       	mov    $0x9,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <dup>:
SYSCALL(dup)
 605:	b8 0a 00 00 00       	mov    $0xa,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <getpid>:
SYSCALL(getpid)
 60d:	b8 0b 00 00 00       	mov    $0xb,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <sbrk>:
SYSCALL(sbrk)
 615:	b8 0c 00 00 00       	mov    $0xc,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <sleep>:
SYSCALL(sleep)
 61d:	b8 0d 00 00 00       	mov    $0xd,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <uptime>:
SYSCALL(uptime)
 625:	b8 0e 00 00 00       	mov    $0xe,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 62d:	55                   	push   %ebp
 62e:	89 e5                	mov    %esp,%ebp
 630:	83 ec 18             	sub    $0x18,%esp
 633:	8b 45 0c             	mov    0xc(%ebp),%eax
 636:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 639:	83 ec 04             	sub    $0x4,%esp
 63c:	6a 01                	push   $0x1
 63e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 641:	50                   	push   %eax
 642:	ff 75 08             	pushl  0x8(%ebp)
 645:	e8 63 ff ff ff       	call   5ad <write>
 64a:	83 c4 10             	add    $0x10,%esp
}
 64d:	90                   	nop
 64e:	c9                   	leave  
 64f:	c3                   	ret    

00000650 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 656:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 65d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 661:	74 17                	je     67a <printint+0x2a>
 663:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 667:	79 11                	jns    67a <printint+0x2a>
    neg = 1;
 669:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 670:	8b 45 0c             	mov    0xc(%ebp),%eax
 673:	f7 d8                	neg    %eax
 675:	89 45 ec             	mov    %eax,-0x14(%ebp)
 678:	eb 06                	jmp    680 <printint+0x30>
  } else {
    x = xx;
 67a:	8b 45 0c             	mov    0xc(%ebp),%eax
 67d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 680:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 687:	8b 4d 10             	mov    0x10(%ebp),%ecx
 68a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68d:	ba 00 00 00 00       	mov    $0x0,%edx
 692:	f7 f1                	div    %ecx
 694:	89 d1                	mov    %edx,%ecx
 696:	8b 45 f4             	mov    -0xc(%ebp),%eax
 699:	8d 50 01             	lea    0x1(%eax),%edx
 69c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 69f:	0f b6 91 c0 0d 00 00 	movzbl 0xdc0(%ecx),%edx
 6a6:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b0:	ba 00 00 00 00       	mov    $0x0,%edx
 6b5:	f7 f1                	div    %ecx
 6b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6be:	75 c7                	jne    687 <printint+0x37>
  if(neg)
 6c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6c4:	74 2d                	je     6f3 <printint+0xa3>
    buf[i++] = '-';
 6c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c9:	8d 50 01             	lea    0x1(%eax),%edx
 6cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6cf:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6d4:	eb 1d                	jmp    6f3 <printint+0xa3>
    putc(fd, buf[i]);
 6d6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6dc:	01 d0                	add    %edx,%eax
 6de:	0f b6 00             	movzbl (%eax),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	83 ec 08             	sub    $0x8,%esp
 6e7:	50                   	push   %eax
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 3d ff ff ff       	call   62d <putc>
 6f0:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 6f3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6fb:	79 d9                	jns    6d6 <printint+0x86>
}
 6fd:	90                   	nop
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 706:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 70d:	8d 45 0c             	lea    0xc(%ebp),%eax
 710:	83 c0 04             	add    $0x4,%eax
 713:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 716:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 71d:	e9 59 01 00 00       	jmp    87b <printf+0x17b>
    c = fmt[i] & 0xff;
 722:	8b 55 0c             	mov    0xc(%ebp),%edx
 725:	8b 45 f0             	mov    -0x10(%ebp),%eax
 728:	01 d0                	add    %edx,%eax
 72a:	0f b6 00             	movzbl (%eax),%eax
 72d:	0f be c0             	movsbl %al,%eax
 730:	25 ff 00 00 00       	and    $0xff,%eax
 735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 738:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 73c:	75 2c                	jne    76a <printf+0x6a>
      if(c == '%'){
 73e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 742:	75 0c                	jne    750 <printf+0x50>
        state = '%';
 744:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 74b:	e9 27 01 00 00       	jmp    877 <printf+0x177>
      } else {
        putc(fd, c);
 750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	83 ec 08             	sub    $0x8,%esp
 759:	50                   	push   %eax
 75a:	ff 75 08             	pushl  0x8(%ebp)
 75d:	e8 cb fe ff ff       	call   62d <putc>
 762:	83 c4 10             	add    $0x10,%esp
 765:	e9 0d 01 00 00       	jmp    877 <printf+0x177>
      }
    } else if(state == '%'){
 76a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 76e:	0f 85 03 01 00 00    	jne    877 <printf+0x177>
      if(c == 'd'){
 774:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 778:	75 1e                	jne    798 <printf+0x98>
        printint(fd, *ap, 10, 1);
 77a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77d:	8b 00                	mov    (%eax),%eax
 77f:	6a 01                	push   $0x1
 781:	6a 0a                	push   $0xa
 783:	50                   	push   %eax
 784:	ff 75 08             	pushl  0x8(%ebp)
 787:	e8 c4 fe ff ff       	call   650 <printint>
 78c:	83 c4 10             	add    $0x10,%esp
        ap++;
 78f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 793:	e9 d8 00 00 00       	jmp    870 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 798:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 79c:	74 06                	je     7a4 <printf+0xa4>
 79e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7a2:	75 1e                	jne    7c2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	6a 00                	push   $0x0
 7ab:	6a 10                	push   $0x10
 7ad:	50                   	push   %eax
 7ae:	ff 75 08             	pushl  0x8(%ebp)
 7b1:	e8 9a fe ff ff       	call   650 <printint>
 7b6:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7bd:	e9 ae 00 00 00       	jmp    870 <printf+0x170>
      } else if(c == 's'){
 7c2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c6:	75 43                	jne    80b <printf+0x10b>
        s = (char*)*ap;
 7c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d8:	75 25                	jne    7ff <printf+0xff>
          s = "(null)";
 7da:	c7 45 f4 ee 0a 00 00 	movl   $0xaee,-0xc(%ebp)
        while(*s != 0){
 7e1:	eb 1c                	jmp    7ff <printf+0xff>
          putc(fd, *s);
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	0f b6 00             	movzbl (%eax),%eax
 7e9:	0f be c0             	movsbl %al,%eax
 7ec:	83 ec 08             	sub    $0x8,%esp
 7ef:	50                   	push   %eax
 7f0:	ff 75 08             	pushl  0x8(%ebp)
 7f3:	e8 35 fe ff ff       	call   62d <putc>
 7f8:	83 c4 10             	add    $0x10,%esp
          s++;
 7fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	0f b6 00             	movzbl (%eax),%eax
 805:	84 c0                	test   %al,%al
 807:	75 da                	jne    7e3 <printf+0xe3>
 809:	eb 65                	jmp    870 <printf+0x170>
        }
      } else if(c == 'c'){
 80b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 80f:	75 1d                	jne    82e <printf+0x12e>
        putc(fd, *ap);
 811:	8b 45 e8             	mov    -0x18(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	50                   	push   %eax
 81d:	ff 75 08             	pushl  0x8(%ebp)
 820:	e8 08 fe ff ff       	call   62d <putc>
 825:	83 c4 10             	add    $0x10,%esp
        ap++;
 828:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 82c:	eb 42                	jmp    870 <printf+0x170>
      } else if(c == '%'){
 82e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 832:	75 17                	jne    84b <printf+0x14b>
        putc(fd, c);
 834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 837:	0f be c0             	movsbl %al,%eax
 83a:	83 ec 08             	sub    $0x8,%esp
 83d:	50                   	push   %eax
 83e:	ff 75 08             	pushl  0x8(%ebp)
 841:	e8 e7 fd ff ff       	call   62d <putc>
 846:	83 c4 10             	add    $0x10,%esp
 849:	eb 25                	jmp    870 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 84b:	83 ec 08             	sub    $0x8,%esp
 84e:	6a 25                	push   $0x25
 850:	ff 75 08             	pushl  0x8(%ebp)
 853:	e8 d5 fd ff ff       	call   62d <putc>
 858:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 85b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85e:	0f be c0             	movsbl %al,%eax
 861:	83 ec 08             	sub    $0x8,%esp
 864:	50                   	push   %eax
 865:	ff 75 08             	pushl  0x8(%ebp)
 868:	e8 c0 fd ff ff       	call   62d <putc>
 86d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 870:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 877:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 87b:	8b 55 0c             	mov    0xc(%ebp),%edx
 87e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 881:	01 d0                	add    %edx,%eax
 883:	0f b6 00             	movzbl (%eax),%eax
 886:	84 c0                	test   %al,%al
 888:	0f 85 94 fe ff ff    	jne    722 <printf+0x22>
    }
  }
}
 88e:	90                   	nop
 88f:	c9                   	leave  
 890:	c3                   	ret    

00000891 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 891:	55                   	push   %ebp
 892:	89 e5                	mov    %esp,%ebp
 894:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	83 e8 08             	sub    $0x8,%eax
 89d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a0:	a1 e8 0d 00 00       	mov    0xde8,%eax
 8a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a8:	eb 24                	jmp    8ce <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ad:	8b 00                	mov    (%eax),%eax
 8af:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8b2:	72 12                	jb     8c6 <free+0x35>
 8b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ba:	77 24                	ja     8e0 <free+0x4f>
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8c4:	72 1a                	jb     8e0 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d4:	76 d4                	jbe    8aa <free+0x19>
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8de:	73 ca                	jae    8aa <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f0:	01 c2                	add    %eax,%edx
 8f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f5:	8b 00                	mov    (%eax),%eax
 8f7:	39 c2                	cmp    %eax,%edx
 8f9:	75 24                	jne    91f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fe:	8b 50 04             	mov    0x4(%eax),%edx
 901:	8b 45 fc             	mov    -0x4(%ebp),%eax
 904:	8b 00                	mov    (%eax),%eax
 906:	8b 40 04             	mov    0x4(%eax),%eax
 909:	01 c2                	add    %eax,%edx
 90b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	8b 00                	mov    (%eax),%eax
 916:	8b 10                	mov    (%eax),%edx
 918:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91b:	89 10                	mov    %edx,(%eax)
 91d:	eb 0a                	jmp    929 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 10                	mov    (%eax),%edx
 924:	8b 45 f8             	mov    -0x8(%ebp),%eax
 927:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 40 04             	mov    0x4(%eax),%eax
 92f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
 939:	01 d0                	add    %edx,%eax
 93b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 93e:	75 20                	jne    960 <free+0xcf>
    p->s.size += bp->s.size;
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 50 04             	mov    0x4(%eax),%edx
 946:	8b 45 f8             	mov    -0x8(%ebp),%eax
 949:	8b 40 04             	mov    0x4(%eax),%eax
 94c:	01 c2                	add    %eax,%edx
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 954:	8b 45 f8             	mov    -0x8(%ebp),%eax
 957:	8b 10                	mov    (%eax),%edx
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	89 10                	mov    %edx,(%eax)
 95e:	eb 08                	jmp    968 <free+0xd7>
  } else
    p->s.ptr = bp;
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	8b 55 f8             	mov    -0x8(%ebp),%edx
 966:	89 10                	mov    %edx,(%eax)
  freep = p;
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	a3 e8 0d 00 00       	mov    %eax,0xde8
}
 970:	90                   	nop
 971:	c9                   	leave  
 972:	c3                   	ret    

00000973 <morecore>:

static Header*
morecore(uint nu)
{
 973:	55                   	push   %ebp
 974:	89 e5                	mov    %esp,%ebp
 976:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 979:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 980:	77 07                	ja     989 <morecore+0x16>
    nu = 4096;
 982:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 989:	8b 45 08             	mov    0x8(%ebp),%eax
 98c:	c1 e0 03             	shl    $0x3,%eax
 98f:	83 ec 0c             	sub    $0xc,%esp
 992:	50                   	push   %eax
 993:	e8 7d fc ff ff       	call   615 <sbrk>
 998:	83 c4 10             	add    $0x10,%esp
 99b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 99e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9a2:	75 07                	jne    9ab <morecore+0x38>
    return 0;
 9a4:	b8 00 00 00 00       	mov    $0x0,%eax
 9a9:	eb 26                	jmp    9d1 <morecore+0x5e>
  hp = (Header*)p;
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b4:	8b 55 08             	mov    0x8(%ebp),%edx
 9b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bd:	83 c0 08             	add    $0x8,%eax
 9c0:	83 ec 0c             	sub    $0xc,%esp
 9c3:	50                   	push   %eax
 9c4:	e8 c8 fe ff ff       	call   891 <free>
 9c9:	83 c4 10             	add    $0x10,%esp
  return freep;
 9cc:	a1 e8 0d 00 00       	mov    0xde8,%eax
}
 9d1:	c9                   	leave  
 9d2:	c3                   	ret    

000009d3 <malloc>:

void*
malloc(uint nbytes)
{
 9d3:	55                   	push   %ebp
 9d4:	89 e5                	mov    %esp,%ebp
 9d6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d9:	8b 45 08             	mov    0x8(%ebp),%eax
 9dc:	83 c0 07             	add    $0x7,%eax
 9df:	c1 e8 03             	shr    $0x3,%eax
 9e2:	83 c0 01             	add    $0x1,%eax
 9e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e8:	a1 e8 0d 00 00       	mov    0xde8,%eax
 9ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9f4:	75 23                	jne    a19 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9f6:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
 9fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a00:	a3 e8 0d 00 00       	mov    %eax,0xde8
 a05:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a0a:	a3 e0 0d 00 00       	mov    %eax,0xde0
    base.s.size = 0;
 a0f:	c7 05 e4 0d 00 00 00 	movl   $0x0,0xde4
 a16:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1c:	8b 00                	mov    (%eax),%eax
 a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a24:	8b 40 04             	mov    0x4(%eax),%eax
 a27:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a2a:	77 4d                	ja     a79 <malloc+0xa6>
      if(p->s.size == nunits)
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	8b 40 04             	mov    0x4(%eax),%eax
 a32:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a35:	75 0c                	jne    a43 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	8b 10                	mov    (%eax),%edx
 a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3f:	89 10                	mov    %edx,(%eax)
 a41:	eb 26                	jmp    a69 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a46:	8b 40 04             	mov    0x4(%eax),%eax
 a49:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a4c:	89 c2                	mov    %eax,%edx
 a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a51:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a57:	8b 40 04             	mov    0x4(%eax),%eax
 a5a:	c1 e0 03             	shl    $0x3,%eax
 a5d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a63:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a66:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6c:	a3 e8 0d 00 00       	mov    %eax,0xde8
      return (void*)(p + 1);
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	83 c0 08             	add    $0x8,%eax
 a77:	eb 3b                	jmp    ab4 <malloc+0xe1>
    }
    if(p == freep)
 a79:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a7e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a81:	75 1e                	jne    aa1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a83:	83 ec 0c             	sub    $0xc,%esp
 a86:	ff 75 ec             	pushl  -0x14(%ebp)
 a89:	e8 e5 fe ff ff       	call   973 <morecore>
 a8e:	83 c4 10             	add    $0x10,%esp
 a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a98:	75 07                	jne    aa1 <malloc+0xce>
        return 0;
 a9a:	b8 00 00 00 00       	mov    $0x0,%eax
 a9f:	eb 13                	jmp    ab4 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaa:	8b 00                	mov    (%eax),%eax
 aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aaf:	e9 6d ff ff ff       	jmp    a21 <malloc+0x4e>
  }
}
 ab4:	c9                   	leave  
 ab5:	c3                   	ret    
