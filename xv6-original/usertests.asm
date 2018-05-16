
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 78 64 00 00       	mov    0x6478,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 36 45 00 00       	push   $0x4536
      13:	50                   	push   %eax
      14:	e8 50 41 00 00       	call   4169 <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 41 45 00 00       	push   $0x4541
      24:	e8 35 40 00 00       	call   405e <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 78 64 00 00       	mov    0x6478,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 49 45 00 00       	push   $0x4549
      3d:	50                   	push   %eax
      3e:	e8 26 41 00 00       	call   4169 <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 ab 3f 00 00       	call   3ff6 <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 41 45 00 00       	push   $0x4541
      53:	e8 0e 40 00 00       	call   4066 <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 78 64 00 00       	mov    0x6478,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 57 45 00 00       	push   $0x4557
      6c:	50                   	push   %eax
      6d:	e8 f7 40 00 00       	call   4169 <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 7c 3f 00 00       	call   3ff6 <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 6d 45 00 00       	push   $0x456d
      82:	e8 bf 3f 00 00       	call   4046 <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 78 64 00 00       	mov    0x6478,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 78 45 00 00       	push   $0x4578
      9b:	50                   	push   %eax
      9c:	e8 c8 40 00 00       	call   4169 <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 4d 3f 00 00       	call   3ff6 <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 92 45 00 00       	push   $0x4592
      b1:	e8 b0 3f 00 00       	call   4066 <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 78 64 00 00       	mov    0x6478,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 94 45 00 00       	push   $0x4594
      ca:	50                   	push   %eax
      cb:	e8 99 40 00 00       	call   4169 <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 1e 3f 00 00       	call   3ff6 <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 78 64 00 00       	mov    0x6478,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 a4 45 00 00       	push   $0x45a4
      e5:	50                   	push   %eax
      e6:	e8 7e 40 00 00       	call   4169 <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	90                   	nop
      ef:	c9                   	leave  
      f0:	c3                   	ret    

000000f1 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f1:	55                   	push   %ebp
      f2:	89 e5                	mov    %esp,%ebp
      f4:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f7:	a1 78 64 00 00       	mov    0x6478,%eax
      fc:	83 ec 08             	sub    $0x8,%esp
      ff:	68 b2 45 00 00       	push   $0x45b2
     104:	50                   	push   %eax
     105:	e8 5f 40 00 00       	call   4169 <printf>
     10a:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10d:	e8 dc 3e 00 00       	call   3fee <fork>
     112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     119:	79 1b                	jns    136 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11b:	a1 78 64 00 00       	mov    0x6478,%eax
     120:	83 ec 08             	sub    $0x8,%esp
     123:	68 c1 45 00 00       	push   $0x45c1
     128:	50                   	push   %eax
     129:	e8 3b 40 00 00       	call   4169 <printf>
     12e:	83 c4 10             	add    $0x10,%esp
    exit();
     131:	e8 c0 3e 00 00       	call   3ff6 <exit>
  }
  if(pid == 0){
     136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     13a:	0f 85 92 00 00 00    	jne    1d2 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 41 45 00 00       	push   $0x4541
     148:	e8 11 3f 00 00       	call   405e <mkdir>
     14d:	83 c4 10             	add    $0x10,%esp
     150:	85 c0                	test   %eax,%eax
     152:	79 1b                	jns    16f <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     154:	a1 78 64 00 00       	mov    0x6478,%eax
     159:	83 ec 08             	sub    $0x8,%esp
     15c:	68 49 45 00 00       	push   $0x4549
     161:	50                   	push   %eax
     162:	e8 02 40 00 00       	call   4169 <printf>
     167:	83 c4 10             	add    $0x10,%esp
      exit();
     16a:	e8 87 3e 00 00       	call   3ff6 <exit>
    }
    if(chdir("iputdir") < 0){
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	68 41 45 00 00       	push   $0x4541
     177:	e8 ea 3e 00 00       	call   4066 <chdir>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	85 c0                	test   %eax,%eax
     181:	79 1b                	jns    19e <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     183:	a1 78 64 00 00       	mov    0x6478,%eax
     188:	83 ec 08             	sub    $0x8,%esp
     18b:	68 ce 45 00 00       	push   $0x45ce
     190:	50                   	push   %eax
     191:	e8 d3 3f 00 00       	call   4169 <printf>
     196:	83 c4 10             	add    $0x10,%esp
      exit();
     199:	e8 58 3e 00 00       	call   3ff6 <exit>
    }
    if(unlink("../iputdir") < 0){
     19e:	83 ec 0c             	sub    $0xc,%esp
     1a1:	68 6d 45 00 00       	push   $0x456d
     1a6:	e8 9b 3e 00 00       	call   4046 <unlink>
     1ab:	83 c4 10             	add    $0x10,%esp
     1ae:	85 c0                	test   %eax,%eax
     1b0:	79 1b                	jns    1cd <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b2:	a1 78 64 00 00       	mov    0x6478,%eax
     1b7:	83 ec 08             	sub    $0x8,%esp
     1ba:	68 78 45 00 00       	push   $0x4578
     1bf:	50                   	push   %eax
     1c0:	e8 a4 3f 00 00       	call   4169 <printf>
     1c5:	83 c4 10             	add    $0x10,%esp
      exit();
     1c8:	e8 29 3e 00 00       	call   3ff6 <exit>
    }
    exit();
     1cd:	e8 24 3e 00 00       	call   3ff6 <exit>
  }
  wait();
     1d2:	e8 27 3e 00 00       	call   3ffe <wait>
  printf(stdout, "exitiput test ok\n");
     1d7:	a1 78 64 00 00       	mov    0x6478,%eax
     1dc:	83 ec 08             	sub    $0x8,%esp
     1df:	68 e2 45 00 00       	push   $0x45e2
     1e4:	50                   	push   %eax
     1e5:	e8 7f 3f 00 00       	call   4169 <printf>
     1ea:	83 c4 10             	add    $0x10,%esp
}
     1ed:	90                   	nop
     1ee:	c9                   	leave  
     1ef:	c3                   	ret    

000001f0 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f6:	a1 78 64 00 00       	mov    0x6478,%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	68 f4 45 00 00       	push   $0x45f4
     203:	50                   	push   %eax
     204:	e8 60 3f 00 00       	call   4169 <printf>
     209:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	68 03 46 00 00       	push   $0x4603
     214:	e8 45 3e 00 00       	call   405e <mkdir>
     219:	83 c4 10             	add    $0x10,%esp
     21c:	85 c0                	test   %eax,%eax
     21e:	79 1b                	jns    23b <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     220:	a1 78 64 00 00       	mov    0x6478,%eax
     225:	83 ec 08             	sub    $0x8,%esp
     228:	68 09 46 00 00       	push   $0x4609
     22d:	50                   	push   %eax
     22e:	e8 36 3f 00 00       	call   4169 <printf>
     233:	83 c4 10             	add    $0x10,%esp
    exit();
     236:	e8 bb 3d 00 00       	call   3ff6 <exit>
  }
  pid = fork();
     23b:	e8 ae 3d 00 00       	call   3fee <fork>
     240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     247:	79 1b                	jns    264 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     249:	a1 78 64 00 00       	mov    0x6478,%eax
     24e:	83 ec 08             	sub    $0x8,%esp
     251:	68 c1 45 00 00       	push   $0x45c1
     256:	50                   	push   %eax
     257:	e8 0d 3f 00 00       	call   4169 <printf>
     25c:	83 c4 10             	add    $0x10,%esp
    exit();
     25f:	e8 92 3d 00 00       	call   3ff6 <exit>
  }
  if(pid == 0){
     264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     268:	75 3b                	jne    2a5 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     26a:	83 ec 08             	sub    $0x8,%esp
     26d:	6a 02                	push   $0x2
     26f:	68 03 46 00 00       	push   $0x4603
     274:	e8 bd 3d 00 00       	call   4036 <open>
     279:	83 c4 10             	add    $0x10,%esp
     27c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     283:	78 1b                	js     2a0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     285:	a1 78 64 00 00       	mov    0x6478,%eax
     28a:	83 ec 08             	sub    $0x8,%esp
     28d:	68 20 46 00 00       	push   $0x4620
     292:	50                   	push   %eax
     293:	e8 d1 3e 00 00       	call   4169 <printf>
     298:	83 c4 10             	add    $0x10,%esp
      exit();
     29b:	e8 56 3d 00 00       	call   3ff6 <exit>
    }
    exit();
     2a0:	e8 51 3d 00 00       	call   3ff6 <exit>
  }
  sleep(1);
     2a5:	83 ec 0c             	sub    $0xc,%esp
     2a8:	6a 01                	push   $0x1
     2aa:	e8 d7 3d 00 00       	call   4086 <sleep>
     2af:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b2:	83 ec 0c             	sub    $0xc,%esp
     2b5:	68 03 46 00 00       	push   $0x4603
     2ba:	e8 87 3d 00 00       	call   4046 <unlink>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	85 c0                	test   %eax,%eax
     2c4:	74 1b                	je     2e1 <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c6:	a1 78 64 00 00       	mov    0x6478,%eax
     2cb:	83 ec 08             	sub    $0x8,%esp
     2ce:	68 44 46 00 00       	push   $0x4644
     2d3:	50                   	push   %eax
     2d4:	e8 90 3e 00 00       	call   4169 <printf>
     2d9:	83 c4 10             	add    $0x10,%esp
    exit();
     2dc:	e8 15 3d 00 00       	call   3ff6 <exit>
  }
  wait();
     2e1:	e8 18 3d 00 00       	call   3ffe <wait>
  printf(stdout, "openiput test ok\n");
     2e6:	a1 78 64 00 00       	mov    0x6478,%eax
     2eb:	83 ec 08             	sub    $0x8,%esp
     2ee:	68 53 46 00 00       	push   $0x4653
     2f3:	50                   	push   %eax
     2f4:	e8 70 3e 00 00       	call   4169 <printf>
     2f9:	83 c4 10             	add    $0x10,%esp
}
     2fc:	90                   	nop
     2fd:	c9                   	leave  
     2fe:	c3                   	ret    

000002ff <opentest>:

// simple file system tests

void
opentest(void)
{
     2ff:	55                   	push   %ebp
     300:	89 e5                	mov    %esp,%ebp
     302:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     305:	a1 78 64 00 00       	mov    0x6478,%eax
     30a:	83 ec 08             	sub    $0x8,%esp
     30d:	68 65 46 00 00       	push   $0x4665
     312:	50                   	push   %eax
     313:	e8 51 3e 00 00       	call   4169 <printf>
     318:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     31b:	83 ec 08             	sub    $0x8,%esp
     31e:	6a 00                	push   $0x0
     320:	68 20 45 00 00       	push   $0x4520
     325:	e8 0c 3d 00 00       	call   4036 <open>
     32a:	83 c4 10             	add    $0x10,%esp
     32d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     334:	79 1b                	jns    351 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     336:	a1 78 64 00 00       	mov    0x6478,%eax
     33b:	83 ec 08             	sub    $0x8,%esp
     33e:	68 70 46 00 00       	push   $0x4670
     343:	50                   	push   %eax
     344:	e8 20 3e 00 00       	call   4169 <printf>
     349:	83 c4 10             	add    $0x10,%esp
    exit();
     34c:	e8 a5 3c 00 00       	call   3ff6 <exit>
  }
  close(fd);
     351:	83 ec 0c             	sub    $0xc,%esp
     354:	ff 75 f4             	pushl  -0xc(%ebp)
     357:	e8 c2 3c 00 00       	call   401e <close>
     35c:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35f:	83 ec 08             	sub    $0x8,%esp
     362:	6a 00                	push   $0x0
     364:	68 83 46 00 00       	push   $0x4683
     369:	e8 c8 3c 00 00       	call   4036 <open>
     36e:	83 c4 10             	add    $0x10,%esp
     371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     378:	78 1b                	js     395 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     37a:	a1 78 64 00 00       	mov    0x6478,%eax
     37f:	83 ec 08             	sub    $0x8,%esp
     382:	68 90 46 00 00       	push   $0x4690
     387:	50                   	push   %eax
     388:	e8 dc 3d 00 00       	call   4169 <printf>
     38d:	83 c4 10             	add    $0x10,%esp
    exit();
     390:	e8 61 3c 00 00       	call   3ff6 <exit>
  }
  printf(stdout, "open test ok\n");
     395:	a1 78 64 00 00       	mov    0x6478,%eax
     39a:	83 ec 08             	sub    $0x8,%esp
     39d:	68 ae 46 00 00       	push   $0x46ae
     3a2:	50                   	push   %eax
     3a3:	e8 c1 3d 00 00       	call   4169 <printf>
     3a8:	83 c4 10             	add    $0x10,%esp
}
     3ab:	90                   	nop
     3ac:	c9                   	leave  
     3ad:	c3                   	ret    

000003ae <writetest>:

void
writetest(void)
{
     3ae:	55                   	push   %ebp
     3af:	89 e5                	mov    %esp,%ebp
     3b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b4:	a1 78 64 00 00       	mov    0x6478,%eax
     3b9:	83 ec 08             	sub    $0x8,%esp
     3bc:	68 bc 46 00 00       	push   $0x46bc
     3c1:	50                   	push   %eax
     3c2:	e8 a2 3d 00 00       	call   4169 <printf>
     3c7:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3ca:	83 ec 08             	sub    $0x8,%esp
     3cd:	68 02 02 00 00       	push   $0x202
     3d2:	68 cd 46 00 00       	push   $0x46cd
     3d7:	e8 5a 3c 00 00       	call   4036 <open>
     3dc:	83 c4 10             	add    $0x10,%esp
     3df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e6:	78 22                	js     40a <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e8:	a1 78 64 00 00       	mov    0x6478,%eax
     3ed:	83 ec 08             	sub    $0x8,%esp
     3f0:	68 d3 46 00 00       	push   $0x46d3
     3f5:	50                   	push   %eax
     3f6:	e8 6e 3d 00 00       	call   4169 <printf>
     3fb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     405:	e9 8f 00 00 00       	jmp    499 <writetest+0xeb>
    printf(stdout, "error: creat small failed!\n");
     40a:	a1 78 64 00 00       	mov    0x6478,%eax
     40f:	83 ec 08             	sub    $0x8,%esp
     412:	68 ee 46 00 00       	push   $0x46ee
     417:	50                   	push   %eax
     418:	e8 4c 3d 00 00       	call   4169 <printf>
     41d:	83 c4 10             	add    $0x10,%esp
    exit();
     420:	e8 d1 3b 00 00       	call   3ff6 <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     425:	83 ec 04             	sub    $0x4,%esp
     428:	6a 0a                	push   $0xa
     42a:	68 0a 47 00 00       	push   $0x470a
     42f:	ff 75 f0             	pushl  -0x10(%ebp)
     432:	e8 df 3b 00 00       	call   4016 <write>
     437:	83 c4 10             	add    $0x10,%esp
     43a:	83 f8 0a             	cmp    $0xa,%eax
     43d:	74 1e                	je     45d <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43f:	a1 78 64 00 00       	mov    0x6478,%eax
     444:	83 ec 04             	sub    $0x4,%esp
     447:	ff 75 f4             	pushl  -0xc(%ebp)
     44a:	68 18 47 00 00       	push   $0x4718
     44f:	50                   	push   %eax
     450:	e8 14 3d 00 00       	call   4169 <printf>
     455:	83 c4 10             	add    $0x10,%esp
      exit();
     458:	e8 99 3b 00 00       	call   3ff6 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     45d:	83 ec 04             	sub    $0x4,%esp
     460:	6a 0a                	push   $0xa
     462:	68 3c 47 00 00       	push   $0x473c
     467:	ff 75 f0             	pushl  -0x10(%ebp)
     46a:	e8 a7 3b 00 00       	call   4016 <write>
     46f:	83 c4 10             	add    $0x10,%esp
     472:	83 f8 0a             	cmp    $0xa,%eax
     475:	74 1e                	je     495 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     477:	a1 78 64 00 00       	mov    0x6478,%eax
     47c:	83 ec 04             	sub    $0x4,%esp
     47f:	ff 75 f4             	pushl  -0xc(%ebp)
     482:	68 48 47 00 00       	push   $0x4748
     487:	50                   	push   %eax
     488:	e8 dc 3c 00 00       	call   4169 <printf>
     48d:	83 c4 10             	add    $0x10,%esp
      exit();
     490:	e8 61 3b 00 00       	call   3ff6 <exit>
  for(i = 0; i < 100; i++){
     495:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     499:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     49d:	7e 86                	jle    425 <writetest+0x77>
    }
  }
  printf(stdout, "writes ok\n");
     49f:	a1 78 64 00 00       	mov    0x6478,%eax
     4a4:	83 ec 08             	sub    $0x8,%esp
     4a7:	68 6c 47 00 00       	push   $0x476c
     4ac:	50                   	push   %eax
     4ad:	e8 b7 3c 00 00       	call   4169 <printf>
     4b2:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b5:	83 ec 0c             	sub    $0xc,%esp
     4b8:	ff 75 f0             	pushl  -0x10(%ebp)
     4bb:	e8 5e 3b 00 00       	call   401e <close>
     4c0:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4c3:	83 ec 08             	sub    $0x8,%esp
     4c6:	6a 00                	push   $0x0
     4c8:	68 cd 46 00 00       	push   $0x46cd
     4cd:	e8 64 3b 00 00       	call   4036 <open>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4dc:	78 3c                	js     51a <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     4de:	a1 78 64 00 00       	mov    0x6478,%eax
     4e3:	83 ec 08             	sub    $0x8,%esp
     4e6:	68 77 47 00 00       	push   $0x4777
     4eb:	50                   	push   %eax
     4ec:	e8 78 3c 00 00       	call   4169 <printf>
     4f1:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4f4:	83 ec 04             	sub    $0x4,%esp
     4f7:	68 d0 07 00 00       	push   $0x7d0
     4fc:	68 60 8c 00 00       	push   $0x8c60
     501:	ff 75 f0             	pushl  -0x10(%ebp)
     504:	e8 05 3b 00 00       	call   400e <read>
     509:	83 c4 10             	add    $0x10,%esp
     50c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50f:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     516:	75 57                	jne    56f <writetest+0x1c1>
     518:	eb 1b                	jmp    535 <writetest+0x187>
    printf(stdout, "error: open small failed!\n");
     51a:	a1 78 64 00 00       	mov    0x6478,%eax
     51f:	83 ec 08             	sub    $0x8,%esp
     522:	68 90 47 00 00       	push   $0x4790
     527:	50                   	push   %eax
     528:	e8 3c 3c 00 00       	call   4169 <printf>
     52d:	83 c4 10             	add    $0x10,%esp
    exit();
     530:	e8 c1 3a 00 00       	call   3ff6 <exit>
    printf(stdout, "read succeeded ok\n");
     535:	a1 78 64 00 00       	mov    0x6478,%eax
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	68 ab 47 00 00       	push   $0x47ab
     542:	50                   	push   %eax
     543:	e8 21 3c 00 00       	call   4169 <printf>
     548:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     54b:	83 ec 0c             	sub    $0xc,%esp
     54e:	ff 75 f0             	pushl  -0x10(%ebp)
     551:	e8 c8 3a 00 00       	call   401e <close>
     556:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     559:	83 ec 0c             	sub    $0xc,%esp
     55c:	68 cd 46 00 00       	push   $0x46cd
     561:	e8 e0 3a 00 00       	call   4046 <unlink>
     566:	83 c4 10             	add    $0x10,%esp
     569:	85 c0                	test   %eax,%eax
     56b:	79 38                	jns    5a5 <writetest+0x1f7>
     56d:	eb 1b                	jmp    58a <writetest+0x1dc>
    printf(stdout, "read failed\n");
     56f:	a1 78 64 00 00       	mov    0x6478,%eax
     574:	83 ec 08             	sub    $0x8,%esp
     577:	68 be 47 00 00       	push   $0x47be
     57c:	50                   	push   %eax
     57d:	e8 e7 3b 00 00       	call   4169 <printf>
     582:	83 c4 10             	add    $0x10,%esp
    exit();
     585:	e8 6c 3a 00 00       	call   3ff6 <exit>
    printf(stdout, "unlink small failed\n");
     58a:	a1 78 64 00 00       	mov    0x6478,%eax
     58f:	83 ec 08             	sub    $0x8,%esp
     592:	68 cb 47 00 00       	push   $0x47cb
     597:	50                   	push   %eax
     598:	e8 cc 3b 00 00       	call   4169 <printf>
     59d:	83 c4 10             	add    $0x10,%esp
    exit();
     5a0:	e8 51 3a 00 00       	call   3ff6 <exit>
  }
  printf(stdout, "small file test ok\n");
     5a5:	a1 78 64 00 00       	mov    0x6478,%eax
     5aa:	83 ec 08             	sub    $0x8,%esp
     5ad:	68 e0 47 00 00       	push   $0x47e0
     5b2:	50                   	push   %eax
     5b3:	e8 b1 3b 00 00       	call   4169 <printf>
     5b8:	83 c4 10             	add    $0x10,%esp
}
     5bb:	90                   	nop
     5bc:	c9                   	leave  
     5bd:	c3                   	ret    

000005be <writetest1>:

void
writetest1(void)
{
     5be:	55                   	push   %ebp
     5bf:	89 e5                	mov    %esp,%ebp
     5c1:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5c4:	a1 78 64 00 00       	mov    0x6478,%eax
     5c9:	83 ec 08             	sub    $0x8,%esp
     5cc:	68 f4 47 00 00       	push   $0x47f4
     5d1:	50                   	push   %eax
     5d2:	e8 92 3b 00 00       	call   4169 <printf>
     5d7:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5da:	83 ec 08             	sub    $0x8,%esp
     5dd:	68 02 02 00 00       	push   $0x202
     5e2:	68 04 48 00 00       	push   $0x4804
     5e7:	e8 4a 3a 00 00       	call   4036 <open>
     5ec:	83 c4 10             	add    $0x10,%esp
     5ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f6:	79 1b                	jns    613 <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f8:	a1 78 64 00 00       	mov    0x6478,%eax
     5fd:	83 ec 08             	sub    $0x8,%esp
     600:	68 08 48 00 00       	push   $0x4808
     605:	50                   	push   %eax
     606:	e8 5e 3b 00 00       	call   4169 <printf>
     60b:	83 c4 10             	add    $0x10,%esp
    exit();
     60e:	e8 e3 39 00 00       	call   3ff6 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     61a:	eb 4b                	jmp    667 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     61c:	ba 60 8c 00 00       	mov    $0x8c60,%edx
     621:	8b 45 f4             	mov    -0xc(%ebp),%eax
     624:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     626:	83 ec 04             	sub    $0x4,%esp
     629:	68 00 02 00 00       	push   $0x200
     62e:	68 60 8c 00 00       	push   $0x8c60
     633:	ff 75 ec             	pushl  -0x14(%ebp)
     636:	e8 db 39 00 00       	call   4016 <write>
     63b:	83 c4 10             	add    $0x10,%esp
     63e:	3d 00 02 00 00       	cmp    $0x200,%eax
     643:	74 1e                	je     663 <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     645:	a1 78 64 00 00       	mov    0x6478,%eax
     64a:	83 ec 04             	sub    $0x4,%esp
     64d:	ff 75 f4             	pushl  -0xc(%ebp)
     650:	68 22 48 00 00       	push   $0x4822
     655:	50                   	push   %eax
     656:	e8 0e 3b 00 00       	call   4169 <printf>
     65b:	83 c4 10             	add    $0x10,%esp
      exit();
     65e:	e8 93 39 00 00       	call   3ff6 <exit>
  for(i = 0; i < MAXFILE; i++){
     663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     667:	8b 45 f4             	mov    -0xc(%ebp),%eax
     66a:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     66f:	76 ab                	jbe    61c <writetest1+0x5e>
    }
  }

  close(fd);
     671:	83 ec 0c             	sub    $0xc,%esp
     674:	ff 75 ec             	pushl  -0x14(%ebp)
     677:	e8 a2 39 00 00       	call   401e <close>
     67c:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     67f:	83 ec 08             	sub    $0x8,%esp
     682:	6a 00                	push   $0x0
     684:	68 04 48 00 00       	push   $0x4804
     689:	e8 a8 39 00 00       	call   4036 <open>
     68e:	83 c4 10             	add    $0x10,%esp
     691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     698:	79 1b                	jns    6b5 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     69a:	a1 78 64 00 00       	mov    0x6478,%eax
     69f:	83 ec 08             	sub    $0x8,%esp
     6a2:	68 40 48 00 00       	push   $0x4840
     6a7:	50                   	push   %eax
     6a8:	e8 bc 3a 00 00       	call   4169 <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
    exit();
     6b0:	e8 41 39 00 00       	call   3ff6 <exit>
  }

  n = 0;
     6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6bc:	83 ec 04             	sub    $0x4,%esp
     6bf:	68 00 02 00 00       	push   $0x200
     6c4:	68 60 8c 00 00       	push   $0x8c60
     6c9:	ff 75 ec             	pushl  -0x14(%ebp)
     6cc:	e8 3d 39 00 00       	call   400e <read>
     6d1:	83 c4 10             	add    $0x10,%esp
     6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6db:	75 27                	jne    704 <writetest1+0x146>
      if(n == MAXFILE - 1){
     6dd:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6e4:	75 7d                	jne    763 <writetest1+0x1a5>
        printf(stdout, "read only %d blocks from big", n);
     6e6:	a1 78 64 00 00       	mov    0x6478,%eax
     6eb:	83 ec 04             	sub    $0x4,%esp
     6ee:	ff 75 f0             	pushl  -0x10(%ebp)
     6f1:	68 59 48 00 00       	push   $0x4859
     6f6:	50                   	push   %eax
     6f7:	e8 6d 3a 00 00       	call   4169 <printf>
     6fc:	83 c4 10             	add    $0x10,%esp
        exit();
     6ff:	e8 f2 38 00 00       	call   3ff6 <exit>
      }
      break;
    } else if(i != 512){
     704:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     70b:	74 1e                	je     72b <writetest1+0x16d>
      printf(stdout, "read failed %d\n", i);
     70d:	a1 78 64 00 00       	mov    0x6478,%eax
     712:	83 ec 04             	sub    $0x4,%esp
     715:	ff 75 f4             	pushl  -0xc(%ebp)
     718:	68 76 48 00 00       	push   $0x4876
     71d:	50                   	push   %eax
     71e:	e8 46 3a 00 00       	call   4169 <printf>
     723:	83 c4 10             	add    $0x10,%esp
      exit();
     726:	e8 cb 38 00 00       	call   3ff6 <exit>
    }
    if(((int*)buf)[0] != n){
     72b:	b8 60 8c 00 00       	mov    $0x8c60,%eax
     730:	8b 00                	mov    (%eax),%eax
     732:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     735:	74 23                	je     75a <writetest1+0x19c>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     737:	b8 60 8c 00 00       	mov    $0x8c60,%eax
      printf(stdout, "read content of block %d is %d\n",
     73c:	8b 10                	mov    (%eax),%edx
     73e:	a1 78 64 00 00       	mov    0x6478,%eax
     743:	52                   	push   %edx
     744:	ff 75 f0             	pushl  -0x10(%ebp)
     747:	68 88 48 00 00       	push   $0x4888
     74c:	50                   	push   %eax
     74d:	e8 17 3a 00 00       	call   4169 <printf>
     752:	83 c4 10             	add    $0x10,%esp
      exit();
     755:	e8 9c 38 00 00       	call   3ff6 <exit>
    }
    n++;
     75a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    i = read(fd, buf, 512);
     75e:	e9 59 ff ff ff       	jmp    6bc <writetest1+0xfe>
      break;
     763:	90                   	nop
  }
  close(fd);
     764:	83 ec 0c             	sub    $0xc,%esp
     767:	ff 75 ec             	pushl  -0x14(%ebp)
     76a:	e8 af 38 00 00       	call   401e <close>
     76f:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     772:	83 ec 0c             	sub    $0xc,%esp
     775:	68 04 48 00 00       	push   $0x4804
     77a:	e8 c7 38 00 00       	call   4046 <unlink>
     77f:	83 c4 10             	add    $0x10,%esp
     782:	85 c0                	test   %eax,%eax
     784:	79 1b                	jns    7a1 <writetest1+0x1e3>
    printf(stdout, "unlink big failed\n");
     786:	a1 78 64 00 00       	mov    0x6478,%eax
     78b:	83 ec 08             	sub    $0x8,%esp
     78e:	68 a8 48 00 00       	push   $0x48a8
     793:	50                   	push   %eax
     794:	e8 d0 39 00 00       	call   4169 <printf>
     799:	83 c4 10             	add    $0x10,%esp
    exit();
     79c:	e8 55 38 00 00       	call   3ff6 <exit>
  }
  printf(stdout, "big files ok\n");
     7a1:	a1 78 64 00 00       	mov    0x6478,%eax
     7a6:	83 ec 08             	sub    $0x8,%esp
     7a9:	68 bb 48 00 00       	push   $0x48bb
     7ae:	50                   	push   %eax
     7af:	e8 b5 39 00 00       	call   4169 <printf>
     7b4:	83 c4 10             	add    $0x10,%esp
}
     7b7:	90                   	nop
     7b8:	c9                   	leave  
     7b9:	c3                   	ret    

000007ba <createtest>:

void
createtest(void)
{
     7ba:	55                   	push   %ebp
     7bb:	89 e5                	mov    %esp,%ebp
     7bd:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7c0:	a1 78 64 00 00       	mov    0x6478,%eax
     7c5:	83 ec 08             	sub    $0x8,%esp
     7c8:	68 cc 48 00 00       	push   $0x48cc
     7cd:	50                   	push   %eax
     7ce:	e8 96 39 00 00       	call   4169 <printf>
     7d3:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7d6:	c6 05 60 ac 00 00 61 	movb   $0x61,0xac60
  name[2] = '\0';
     7dd:	c6 05 62 ac 00 00 00 	movb   $0x0,0xac62
  for(i = 0; i < 52; i++){
     7e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7eb:	eb 35                	jmp    822 <createtest+0x68>
    name[1] = '0' + i;
     7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f0:	83 c0 30             	add    $0x30,%eax
     7f3:	a2 61 ac 00 00       	mov    %al,0xac61
    fd = open(name, O_CREATE|O_RDWR);
     7f8:	83 ec 08             	sub    $0x8,%esp
     7fb:	68 02 02 00 00       	push   $0x202
     800:	68 60 ac 00 00       	push   $0xac60
     805:	e8 2c 38 00 00       	call   4036 <open>
     80a:	83 c4 10             	add    $0x10,%esp
     80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     810:	83 ec 0c             	sub    $0xc,%esp
     813:	ff 75 f0             	pushl  -0x10(%ebp)
     816:	e8 03 38 00 00       	call   401e <close>
     81b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     81e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     822:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     826:	7e c5                	jle    7ed <createtest+0x33>
  }
  name[0] = 'a';
     828:	c6 05 60 ac 00 00 61 	movb   $0x61,0xac60
  name[2] = '\0';
     82f:	c6 05 62 ac 00 00 00 	movb   $0x0,0xac62
  for(i = 0; i < 52; i++){
     836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     83d:	eb 1f                	jmp    85e <createtest+0xa4>
    name[1] = '0' + i;
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	83 c0 30             	add    $0x30,%eax
     845:	a2 61 ac 00 00       	mov    %al,0xac61
    unlink(name);
     84a:	83 ec 0c             	sub    $0xc,%esp
     84d:	68 60 ac 00 00       	push   $0xac60
     852:	e8 ef 37 00 00       	call   4046 <unlink>
     857:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     85a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     85e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     862:	7e db                	jle    83f <createtest+0x85>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     864:	a1 78 64 00 00       	mov    0x6478,%eax
     869:	83 ec 08             	sub    $0x8,%esp
     86c:	68 f4 48 00 00       	push   $0x48f4
     871:	50                   	push   %eax
     872:	e8 f2 38 00 00       	call   4169 <printf>
     877:	83 c4 10             	add    $0x10,%esp
}
     87a:	90                   	nop
     87b:	c9                   	leave  
     87c:	c3                   	ret    

0000087d <dirtest>:

void dirtest(void)
{
     87d:	55                   	push   %ebp
     87e:	89 e5                	mov    %esp,%ebp
     880:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     883:	a1 78 64 00 00       	mov    0x6478,%eax
     888:	83 ec 08             	sub    $0x8,%esp
     88b:	68 1a 49 00 00       	push   $0x491a
     890:	50                   	push   %eax
     891:	e8 d3 38 00 00       	call   4169 <printf>
     896:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     899:	83 ec 0c             	sub    $0xc,%esp
     89c:	68 26 49 00 00       	push   $0x4926
     8a1:	e8 b8 37 00 00       	call   405e <mkdir>
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	85 c0                	test   %eax,%eax
     8ab:	79 1b                	jns    8c8 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8ad:	a1 78 64 00 00       	mov    0x6478,%eax
     8b2:	83 ec 08             	sub    $0x8,%esp
     8b5:	68 49 45 00 00       	push   $0x4549
     8ba:	50                   	push   %eax
     8bb:	e8 a9 38 00 00       	call   4169 <printf>
     8c0:	83 c4 10             	add    $0x10,%esp
    exit();
     8c3:	e8 2e 37 00 00       	call   3ff6 <exit>
  }

  if(chdir("dir0") < 0){
     8c8:	83 ec 0c             	sub    $0xc,%esp
     8cb:	68 26 49 00 00       	push   $0x4926
     8d0:	e8 91 37 00 00       	call   4066 <chdir>
     8d5:	83 c4 10             	add    $0x10,%esp
     8d8:	85 c0                	test   %eax,%eax
     8da:	79 1b                	jns    8f7 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8dc:	a1 78 64 00 00       	mov    0x6478,%eax
     8e1:	83 ec 08             	sub    $0x8,%esp
     8e4:	68 2b 49 00 00       	push   $0x492b
     8e9:	50                   	push   %eax
     8ea:	e8 7a 38 00 00       	call   4169 <printf>
     8ef:	83 c4 10             	add    $0x10,%esp
    exit();
     8f2:	e8 ff 36 00 00       	call   3ff6 <exit>
  }

  if(chdir("..") < 0){
     8f7:	83 ec 0c             	sub    $0xc,%esp
     8fa:	68 3e 49 00 00       	push   $0x493e
     8ff:	e8 62 37 00 00       	call   4066 <chdir>
     904:	83 c4 10             	add    $0x10,%esp
     907:	85 c0                	test   %eax,%eax
     909:	79 1b                	jns    926 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     90b:	a1 78 64 00 00       	mov    0x6478,%eax
     910:	83 ec 08             	sub    $0x8,%esp
     913:	68 41 49 00 00       	push   $0x4941
     918:	50                   	push   %eax
     919:	e8 4b 38 00 00       	call   4169 <printf>
     91e:	83 c4 10             	add    $0x10,%esp
    exit();
     921:	e8 d0 36 00 00       	call   3ff6 <exit>
  }

  if(unlink("dir0") < 0){
     926:	83 ec 0c             	sub    $0xc,%esp
     929:	68 26 49 00 00       	push   $0x4926
     92e:	e8 13 37 00 00       	call   4046 <unlink>
     933:	83 c4 10             	add    $0x10,%esp
     936:	85 c0                	test   %eax,%eax
     938:	79 1b                	jns    955 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     93a:	a1 78 64 00 00       	mov    0x6478,%eax
     93f:	83 ec 08             	sub    $0x8,%esp
     942:	68 52 49 00 00       	push   $0x4952
     947:	50                   	push   %eax
     948:	e8 1c 38 00 00       	call   4169 <printf>
     94d:	83 c4 10             	add    $0x10,%esp
    exit();
     950:	e8 a1 36 00 00       	call   3ff6 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     955:	a1 78 64 00 00       	mov    0x6478,%eax
     95a:	83 ec 08             	sub    $0x8,%esp
     95d:	68 66 49 00 00       	push   $0x4966
     962:	50                   	push   %eax
     963:	e8 01 38 00 00       	call   4169 <printf>
     968:	83 c4 10             	add    $0x10,%esp
}
     96b:	90                   	nop
     96c:	c9                   	leave  
     96d:	c3                   	ret    

0000096e <exectest>:

void
exectest(void)
{
     96e:	55                   	push   %ebp
     96f:	89 e5                	mov    %esp,%ebp
     971:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     974:	a1 78 64 00 00       	mov    0x6478,%eax
     979:	83 ec 08             	sub    $0x8,%esp
     97c:	68 75 49 00 00       	push   $0x4975
     981:	50                   	push   %eax
     982:	e8 e2 37 00 00       	call   4169 <printf>
     987:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     98a:	83 ec 08             	sub    $0x8,%esp
     98d:	68 64 64 00 00       	push   $0x6464
     992:	68 20 45 00 00       	push   $0x4520
     997:	e8 92 36 00 00       	call   402e <exec>
     99c:	83 c4 10             	add    $0x10,%esp
     99f:	85 c0                	test   %eax,%eax
     9a1:	79 1b                	jns    9be <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     9a3:	a1 78 64 00 00       	mov    0x6478,%eax
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	68 80 49 00 00       	push   $0x4980
     9b0:	50                   	push   %eax
     9b1:	e8 b3 37 00 00       	call   4169 <printf>
     9b6:	83 c4 10             	add    $0x10,%esp
    exit();
     9b9:	e8 38 36 00 00       	call   3ff6 <exit>
  }
}
     9be:	90                   	nop
     9bf:	c9                   	leave  
     9c0:	c3                   	ret    

000009c1 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9c1:	55                   	push   %ebp
     9c2:	89 e5                	mov    %esp,%ebp
     9c4:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9c7:	83 ec 0c             	sub    $0xc,%esp
     9ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9cd:	50                   	push   %eax
     9ce:	e8 33 36 00 00       	call   4006 <pipe>
     9d3:	83 c4 10             	add    $0x10,%esp
     9d6:	85 c0                	test   %eax,%eax
     9d8:	74 17                	je     9f1 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9da:	83 ec 08             	sub    $0x8,%esp
     9dd:	68 92 49 00 00       	push   $0x4992
     9e2:	6a 01                	push   $0x1
     9e4:	e8 80 37 00 00       	call   4169 <printf>
     9e9:	83 c4 10             	add    $0x10,%esp
    exit();
     9ec:	e8 05 36 00 00       	call   3ff6 <exit>
  }
  pid = fork();
     9f1:	e8 f8 35 00 00       	call   3fee <fork>
     9f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a04:	0f 85 89 00 00 00    	jne    a93 <pipe1+0xd2>
    close(fds[0]);
     a0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a0d:	83 ec 0c             	sub    $0xc,%esp
     a10:	50                   	push   %eax
     a11:	e8 08 36 00 00       	call   401e <close>
     a16:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a20:	eb 66                	jmp    a88 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a29:	eb 19                	jmp    a44 <pipe1+0x83>
        buf[i] = seq++;
     a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a2e:	8d 50 01             	lea    0x1(%eax),%edx
     a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a34:	89 c2                	mov    %eax,%edx
     a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a39:	05 60 8c 00 00       	add    $0x8c60,%eax
     a3e:	88 10                	mov    %dl,(%eax)
      for(i = 0; i < 1033; i++)
     a40:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a44:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a4b:	7e de                	jle    a2b <pipe1+0x6a>
      if(write(fds[1], buf, 1033) != 1033){
     a4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a50:	83 ec 04             	sub    $0x4,%esp
     a53:	68 09 04 00 00       	push   $0x409
     a58:	68 60 8c 00 00       	push   $0x8c60
     a5d:	50                   	push   %eax
     a5e:	e8 b3 35 00 00       	call   4016 <write>
     a63:	83 c4 10             	add    $0x10,%esp
     a66:	3d 09 04 00 00       	cmp    $0x409,%eax
     a6b:	74 17                	je     a84 <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     a6d:	83 ec 08             	sub    $0x8,%esp
     a70:	68 a1 49 00 00       	push   $0x49a1
     a75:	6a 01                	push   $0x1
     a77:	e8 ed 36 00 00       	call   4169 <printf>
     a7c:	83 c4 10             	add    $0x10,%esp
        exit();
     a7f:	e8 72 35 00 00       	call   3ff6 <exit>
    for(n = 0; n < 5; n++){
     a84:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a88:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a8c:	7e 94                	jle    a22 <pipe1+0x61>
      }
    }
    exit();
     a8e:	e8 63 35 00 00       	call   3ff6 <exit>
  } else if(pid > 0){
     a93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a97:	0f 8e f4 00 00 00    	jle    b91 <pipe1+0x1d0>
    close(fds[1]);
     a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     aa0:	83 ec 0c             	sub    $0xc,%esp
     aa3:	50                   	push   %eax
     aa4:	e8 75 35 00 00       	call   401e <close>
     aa9:	83 c4 10             	add    $0x10,%esp
    total = 0;
     aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     ab3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     aba:	eb 66                	jmp    b22 <pipe1+0x161>
      for(i = 0; i < n; i++){
     abc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ac3:	eb 3b                	jmp    b00 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac8:	05 60 8c 00 00       	add    $0x8c60,%eax
     acd:	0f b6 00             	movzbl (%eax),%eax
     ad0:	0f be c8             	movsbl %al,%ecx
     ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad6:	8d 50 01             	lea    0x1(%eax),%edx
     ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     adc:	31 c8                	xor    %ecx,%eax
     ade:	0f b6 c0             	movzbl %al,%eax
     ae1:	85 c0                	test   %eax,%eax
     ae3:	74 17                	je     afc <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     ae5:	83 ec 08             	sub    $0x8,%esp
     ae8:	68 af 49 00 00       	push   $0x49af
     aed:	6a 01                	push   $0x1
     aef:	e8 75 36 00 00       	call   4169 <printf>
     af4:	83 c4 10             	add    $0x10,%esp
     af7:	e9 ac 00 00 00       	jmp    ba8 <pipe1+0x1e7>
      for(i = 0; i < n; i++){
     afc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b06:	7c bd                	jl     ac5 <pipe1+0x104>
          return;
        }
      }
      total += n;
     b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b0b:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b0e:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b14:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b19:	76 07                	jbe    b22 <pipe1+0x161>
        cc = sizeof(buf);
     b1b:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     b22:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b25:	83 ec 04             	sub    $0x4,%esp
     b28:	ff 75 e8             	pushl  -0x18(%ebp)
     b2b:	68 60 8c 00 00       	push   $0x8c60
     b30:	50                   	push   %eax
     b31:	e8 d8 34 00 00       	call   400e <read>
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b40:	0f 8f 76 ff ff ff    	jg     abc <pipe1+0xfb>
    }
    if(total != 5 * 1033){
     b46:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b4d:	74 1a                	je     b69 <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b4f:	83 ec 04             	sub    $0x4,%esp
     b52:	ff 75 e4             	pushl  -0x1c(%ebp)
     b55:	68 bd 49 00 00       	push   $0x49bd
     b5a:	6a 01                	push   $0x1
     b5c:	e8 08 36 00 00       	call   4169 <printf>
     b61:	83 c4 10             	add    $0x10,%esp
      exit();
     b64:	e8 8d 34 00 00       	call   3ff6 <exit>
    }
    close(fds[0]);
     b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b6c:	83 ec 0c             	sub    $0xc,%esp
     b6f:	50                   	push   %eax
     b70:	e8 a9 34 00 00       	call   401e <close>
     b75:	83 c4 10             	add    $0x10,%esp
    wait();
     b78:	e8 81 34 00 00       	call   3ffe <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b7d:	83 ec 08             	sub    $0x8,%esp
     b80:	68 e3 49 00 00       	push   $0x49e3
     b85:	6a 01                	push   $0x1
     b87:	e8 dd 35 00 00       	call   4169 <printf>
     b8c:	83 c4 10             	add    $0x10,%esp
     b8f:	eb 17                	jmp    ba8 <pipe1+0x1e7>
    printf(1, "fork() failed\n");
     b91:	83 ec 08             	sub    $0x8,%esp
     b94:	68 d4 49 00 00       	push   $0x49d4
     b99:	6a 01                	push   $0x1
     b9b:	e8 c9 35 00 00       	call   4169 <printf>
     ba0:	83 c4 10             	add    $0x10,%esp
    exit();
     ba3:	e8 4e 34 00 00       	call   3ff6 <exit>
}
     ba8:	c9                   	leave  
     ba9:	c3                   	ret    

00000baa <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     baa:	55                   	push   %ebp
     bab:	89 e5                	mov    %esp,%ebp
     bad:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	68 ed 49 00 00       	push   $0x49ed
     bb8:	6a 01                	push   $0x1
     bba:	e8 aa 35 00 00       	call   4169 <printf>
     bbf:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bc2:	e8 27 34 00 00       	call   3fee <fork>
     bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bce:	75 02                	jne    bd2 <preempt+0x28>
    for(;;)
     bd0:	eb fe                	jmp    bd0 <preempt+0x26>
      ;

  pid2 = fork();
     bd2:	e8 17 34 00 00       	call   3fee <fork>
     bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bde:	75 02                	jne    be2 <preempt+0x38>
    for(;;)
     be0:	eb fe                	jmp    be0 <preempt+0x36>
      ;

  pipe(pfds);
     be2:	83 ec 0c             	sub    $0xc,%esp
     be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be8:	50                   	push   %eax
     be9:	e8 18 34 00 00       	call   4006 <pipe>
     bee:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bf1:	e8 f8 33 00 00       	call   3fee <fork>
     bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bfd:	75 4d                	jne    c4c <preempt+0xa2>
    close(pfds[0]);
     bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c02:	83 ec 0c             	sub    $0xc,%esp
     c05:	50                   	push   %eax
     c06:	e8 13 34 00 00       	call   401e <close>
     c0b:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c11:	83 ec 04             	sub    $0x4,%esp
     c14:	6a 01                	push   $0x1
     c16:	68 f7 49 00 00       	push   $0x49f7
     c1b:	50                   	push   %eax
     c1c:	e8 f5 33 00 00       	call   4016 <write>
     c21:	83 c4 10             	add    $0x10,%esp
     c24:	83 f8 01             	cmp    $0x1,%eax
     c27:	74 12                	je     c3b <preempt+0x91>
      printf(1, "preempt write error");
     c29:	83 ec 08             	sub    $0x8,%esp
     c2c:	68 f9 49 00 00       	push   $0x49f9
     c31:	6a 01                	push   $0x1
     c33:	e8 31 35 00 00       	call   4169 <printf>
     c38:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3e:	83 ec 0c             	sub    $0xc,%esp
     c41:	50                   	push   %eax
     c42:	e8 d7 33 00 00       	call   401e <close>
     c47:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c4a:	eb fe                	jmp    c4a <preempt+0xa0>
      ;
  }

  close(pfds[1]);
     c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c4f:	83 ec 0c             	sub    $0xc,%esp
     c52:	50                   	push   %eax
     c53:	e8 c6 33 00 00       	call   401e <close>
     c58:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c5e:	83 ec 04             	sub    $0x4,%esp
     c61:	68 00 20 00 00       	push   $0x2000
     c66:	68 60 8c 00 00       	push   $0x8c60
     c6b:	50                   	push   %eax
     c6c:	e8 9d 33 00 00       	call   400e <read>
     c71:	83 c4 10             	add    $0x10,%esp
     c74:	83 f8 01             	cmp    $0x1,%eax
     c77:	74 14                	je     c8d <preempt+0xe3>
    printf(1, "preempt read error");
     c79:	83 ec 08             	sub    $0x8,%esp
     c7c:	68 0d 4a 00 00       	push   $0x4a0d
     c81:	6a 01                	push   $0x1
     c83:	e8 e1 34 00 00       	call   4169 <printf>
     c88:	83 c4 10             	add    $0x10,%esp
     c8b:	eb 7e                	jmp    d0b <preempt+0x161>
    return;
  }
  close(pfds[0]);
     c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c90:	83 ec 0c             	sub    $0xc,%esp
     c93:	50                   	push   %eax
     c94:	e8 85 33 00 00       	call   401e <close>
     c99:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c9c:	83 ec 08             	sub    $0x8,%esp
     c9f:	68 20 4a 00 00       	push   $0x4a20
     ca4:	6a 01                	push   $0x1
     ca6:	e8 be 34 00 00       	call   4169 <printf>
     cab:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     cae:	83 ec 0c             	sub    $0xc,%esp
     cb1:	ff 75 f4             	pushl  -0xc(%ebp)
     cb4:	e8 6d 33 00 00       	call   4026 <kill>
     cb9:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     cbc:	83 ec 0c             	sub    $0xc,%esp
     cbf:	ff 75 f0             	pushl  -0x10(%ebp)
     cc2:	e8 5f 33 00 00       	call   4026 <kill>
     cc7:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     cca:	83 ec 0c             	sub    $0xc,%esp
     ccd:	ff 75 ec             	pushl  -0x14(%ebp)
     cd0:	e8 51 33 00 00       	call   4026 <kill>
     cd5:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     cd8:	83 ec 08             	sub    $0x8,%esp
     cdb:	68 29 4a 00 00       	push   $0x4a29
     ce0:	6a 01                	push   $0x1
     ce2:	e8 82 34 00 00       	call   4169 <printf>
     ce7:	83 c4 10             	add    $0x10,%esp
  wait();
     cea:	e8 0f 33 00 00       	call   3ffe <wait>
  wait();
     cef:	e8 0a 33 00 00       	call   3ffe <wait>
  wait();
     cf4:	e8 05 33 00 00       	call   3ffe <wait>
  printf(1, "preempt ok\n");
     cf9:	83 ec 08             	sub    $0x8,%esp
     cfc:	68 32 4a 00 00       	push   $0x4a32
     d01:	6a 01                	push   $0x1
     d03:	e8 61 34 00 00       	call   4169 <printf>
     d08:	83 c4 10             	add    $0x10,%esp
}
     d0b:	c9                   	leave  
     d0c:	c3                   	ret    

00000d0d <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     d0d:	55                   	push   %ebp
     d0e:	89 e5                	mov    %esp,%ebp
     d10:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d1a:	eb 4f                	jmp    d6b <exitwait+0x5e>
    pid = fork();
     d1c:	e8 cd 32 00 00       	call   3fee <fork>
     d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d28:	79 14                	jns    d3e <exitwait+0x31>
      printf(1, "fork failed\n");
     d2a:	83 ec 08             	sub    $0x8,%esp
     d2d:	68 c1 45 00 00       	push   $0x45c1
     d32:	6a 01                	push   $0x1
     d34:	e8 30 34 00 00       	call   4169 <printf>
     d39:	83 c4 10             	add    $0x10,%esp
      return;
     d3c:	eb 45                	jmp    d83 <exitwait+0x76>
    }
    if(pid){
     d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d42:	74 1e                	je     d62 <exitwait+0x55>
      if(wait() != pid){
     d44:	e8 b5 32 00 00       	call   3ffe <wait>
     d49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     d4c:	74 19                	je     d67 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d4e:	83 ec 08             	sub    $0x8,%esp
     d51:	68 3e 4a 00 00       	push   $0x4a3e
     d56:	6a 01                	push   $0x1
     d58:	e8 0c 34 00 00       	call   4169 <printf>
     d5d:	83 c4 10             	add    $0x10,%esp
        return;
     d60:	eb 21                	jmp    d83 <exitwait+0x76>
      }
    } else {
      exit();
     d62:	e8 8f 32 00 00       	call   3ff6 <exit>
  for(i = 0; i < 100; i++){
     d67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d6b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d6f:	7e ab                	jle    d1c <exitwait+0xf>
    }
  }
  printf(1, "exitwait ok\n");
     d71:	83 ec 08             	sub    $0x8,%esp
     d74:	68 4e 4a 00 00       	push   $0x4a4e
     d79:	6a 01                	push   $0x1
     d7b:	e8 e9 33 00 00       	call   4169 <printf>
     d80:	83 c4 10             	add    $0x10,%esp
}
     d83:	c9                   	leave  
     d84:	c3                   	ret    

00000d85 <mem>:

void
mem(void)
{
     d85:	55                   	push   %ebp
     d86:	89 e5                	mov    %esp,%ebp
     d88:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d8b:	83 ec 08             	sub    $0x8,%esp
     d8e:	68 5b 4a 00 00       	push   $0x4a5b
     d93:	6a 01                	push   $0x1
     d95:	e8 cf 33 00 00       	call   4169 <printf>
     d9a:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     d9d:	e8 d4 32 00 00       	call   4076 <getpid>
     da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     da5:	e8 44 32 00 00       	call   3fee <fork>
     daa:	89 45 ec             	mov    %eax,-0x14(%ebp)
     dad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     db1:	0f 85 b7 00 00 00    	jne    e6e <mem+0xe9>
    m1 = 0;
     db7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     dbe:	eb 0e                	jmp    dce <mem+0x49>
      *(char**)m2 = m1;
     dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dc6:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     dce:	83 ec 0c             	sub    $0xc,%esp
     dd1:	68 11 27 00 00       	push   $0x2711
     dd6:	e8 61 36 00 00       	call   443c <malloc>
     ddb:	83 c4 10             	add    $0x10,%esp
     dde:	89 45 e8             	mov    %eax,-0x18(%ebp)
     de1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     de5:	75 d9                	jne    dc0 <mem+0x3b>
    }
    while(m1){
     de7:	eb 1c                	jmp    e05 <mem+0x80>
      m2 = *(char**)m1;
     de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dec:	8b 00                	mov    (%eax),%eax
     dee:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     df1:	83 ec 0c             	sub    $0xc,%esp
     df4:	ff 75 f4             	pushl  -0xc(%ebp)
     df7:	e8 fe 34 00 00       	call   42fa <free>
     dfc:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(m1){
     e05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e09:	75 de                	jne    de9 <mem+0x64>
    }
    m1 = malloc(1024*20);
     e0b:	83 ec 0c             	sub    $0xc,%esp
     e0e:	68 00 50 00 00       	push   $0x5000
     e13:	e8 24 36 00 00       	call   443c <malloc>
     e18:	83 c4 10             	add    $0x10,%esp
     e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e22:	75 25                	jne    e49 <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     e24:	83 ec 08             	sub    $0x8,%esp
     e27:	68 65 4a 00 00       	push   $0x4a65
     e2c:	6a 01                	push   $0x1
     e2e:	e8 36 33 00 00       	call   4169 <printf>
     e33:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     e36:	83 ec 0c             	sub    $0xc,%esp
     e39:	ff 75 f0             	pushl  -0x10(%ebp)
     e3c:	e8 e5 31 00 00       	call   4026 <kill>
     e41:	83 c4 10             	add    $0x10,%esp
      exit();
     e44:	e8 ad 31 00 00       	call   3ff6 <exit>
    }
    free(m1);
     e49:	83 ec 0c             	sub    $0xc,%esp
     e4c:	ff 75 f4             	pushl  -0xc(%ebp)
     e4f:	e8 a6 34 00 00       	call   42fa <free>
     e54:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e57:	83 ec 08             	sub    $0x8,%esp
     e5a:	68 7f 4a 00 00       	push   $0x4a7f
     e5f:	6a 01                	push   $0x1
     e61:	e8 03 33 00 00       	call   4169 <printf>
     e66:	83 c4 10             	add    $0x10,%esp
    exit();
     e69:	e8 88 31 00 00       	call   3ff6 <exit>
  } else {
    wait();
     e6e:	e8 8b 31 00 00       	call   3ffe <wait>
  }
}
     e73:	90                   	nop
     e74:	c9                   	leave  
     e75:	c3                   	ret    

00000e76 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e76:	55                   	push   %ebp
     e77:	89 e5                	mov    %esp,%ebp
     e79:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e7c:	83 ec 08             	sub    $0x8,%esp
     e7f:	68 87 4a 00 00       	push   $0x4a87
     e84:	6a 01                	push   $0x1
     e86:	e8 de 32 00 00       	call   4169 <printf>
     e8b:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     e8e:	83 ec 0c             	sub    $0xc,%esp
     e91:	68 96 4a 00 00       	push   $0x4a96
     e96:	e8 ab 31 00 00       	call   4046 <unlink>
     e9b:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e9e:	83 ec 08             	sub    $0x8,%esp
     ea1:	68 02 02 00 00       	push   $0x202
     ea6:	68 96 4a 00 00       	push   $0x4a96
     eab:	e8 86 31 00 00       	call   4036 <open>
     eb0:	83 c4 10             	add    $0x10,%esp
     eb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     eb6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     eba:	79 17                	jns    ed3 <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     ebc:	83 ec 08             	sub    $0x8,%esp
     ebf:	68 a0 4a 00 00       	push   $0x4aa0
     ec4:	6a 01                	push   $0x1
     ec6:	e8 9e 32 00 00       	call   4169 <printf>
     ecb:	83 c4 10             	add    $0x10,%esp
    return;
     ece:	e9 84 01 00 00       	jmp    1057 <sharedfd+0x1e1>
  }
  pid = fork();
     ed3:	e8 16 31 00 00       	call   3fee <fork>
     ed8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     edb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     edf:	75 07                	jne    ee8 <sharedfd+0x72>
     ee1:	b8 63 00 00 00       	mov    $0x63,%eax
     ee6:	eb 05                	jmp    eed <sharedfd+0x77>
     ee8:	b8 70 00 00 00       	mov    $0x70,%eax
     eed:	83 ec 04             	sub    $0x4,%esp
     ef0:	6a 0a                	push   $0xa
     ef2:	50                   	push   %eax
     ef3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ef6:	50                   	push   %eax
     ef7:	e8 5f 2f 00 00       	call   3e5b <memset>
     efc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     eff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f06:	eb 31                	jmp    f39 <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f08:	83 ec 04             	sub    $0x4,%esp
     f0b:	6a 0a                	push   $0xa
     f0d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f10:	50                   	push   %eax
     f11:	ff 75 e8             	pushl  -0x18(%ebp)
     f14:	e8 fd 30 00 00       	call   4016 <write>
     f19:	83 c4 10             	add    $0x10,%esp
     f1c:	83 f8 0a             	cmp    $0xa,%eax
     f1f:	74 14                	je     f35 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     f21:	83 ec 08             	sub    $0x8,%esp
     f24:	68 cc 4a 00 00       	push   $0x4acc
     f29:	6a 01                	push   $0x1
     f2b:	e8 39 32 00 00       	call   4169 <printf>
     f30:	83 c4 10             	add    $0x10,%esp
      break;
     f33:	eb 0d                	jmp    f42 <sharedfd+0xcc>
  for(i = 0; i < 1000; i++){
     f35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f39:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f40:	7e c6                	jle    f08 <sharedfd+0x92>
    }
  }
  if(pid == 0)
     f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f46:	75 05                	jne    f4d <sharedfd+0xd7>
    exit();
     f48:	e8 a9 30 00 00       	call   3ff6 <exit>
  else
    wait();
     f4d:	e8 ac 30 00 00       	call   3ffe <wait>
  close(fd);
     f52:	83 ec 0c             	sub    $0xc,%esp
     f55:	ff 75 e8             	pushl  -0x18(%ebp)
     f58:	e8 c1 30 00 00       	call   401e <close>
     f5d:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f60:	83 ec 08             	sub    $0x8,%esp
     f63:	6a 00                	push   $0x0
     f65:	68 96 4a 00 00       	push   $0x4a96
     f6a:	e8 c7 30 00 00       	call   4036 <open>
     f6f:	83 c4 10             	add    $0x10,%esp
     f72:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f79:	79 17                	jns    f92 <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f7b:	83 ec 08             	sub    $0x8,%esp
     f7e:	68 ec 4a 00 00       	push   $0x4aec
     f83:	6a 01                	push   $0x1
     f85:	e8 df 31 00 00       	call   4169 <printf>
     f8a:	83 c4 10             	add    $0x10,%esp
    return;
     f8d:	e9 c5 00 00 00       	jmp    1057 <sharedfd+0x1e1>
  }
  nc = np = 0;
     f92:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f9f:	eb 3b                	jmp    fdc <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
     fa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fa8:	eb 2a                	jmp    fd4 <sharedfd+0x15e>
      if(buf[i] == 'c')
     faa:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fb0:	01 d0                	add    %edx,%eax
     fb2:	0f b6 00             	movzbl (%eax),%eax
     fb5:	3c 63                	cmp    $0x63,%al
     fb7:	75 04                	jne    fbd <sharedfd+0x147>
        nc++;
     fb9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     fbd:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc3:	01 d0                	add    %edx,%eax
     fc5:	0f b6 00             	movzbl (%eax),%eax
     fc8:	3c 70                	cmp    $0x70,%al
     fca:	75 04                	jne    fd0 <sharedfd+0x15a>
        np++;
     fcc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
     fd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fd7:	83 f8 09             	cmp    $0x9,%eax
     fda:	76 ce                	jbe    faa <sharedfd+0x134>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fdc:	83 ec 04             	sub    $0x4,%esp
     fdf:	6a 0a                	push   $0xa
     fe1:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fe4:	50                   	push   %eax
     fe5:	ff 75 e8             	pushl  -0x18(%ebp)
     fe8:	e8 21 30 00 00       	call   400e <read>
     fed:	83 c4 10             	add    $0x10,%esp
     ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
     ff3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     ff7:	7f a8                	jg     fa1 <sharedfd+0x12b>
    }
  }
  close(fd);
     ff9:	83 ec 0c             	sub    $0xc,%esp
     ffc:	ff 75 e8             	pushl  -0x18(%ebp)
     fff:	e8 1a 30 00 00       	call   401e <close>
    1004:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
    1007:	83 ec 0c             	sub    $0xc,%esp
    100a:	68 96 4a 00 00       	push   $0x4a96
    100f:	e8 32 30 00 00       	call   4046 <unlink>
    1014:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    1017:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    101e:	75 1d                	jne    103d <sharedfd+0x1c7>
    1020:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    1027:	75 14                	jne    103d <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
    1029:	83 ec 08             	sub    $0x8,%esp
    102c:	68 17 4b 00 00       	push   $0x4b17
    1031:	6a 01                	push   $0x1
    1033:	e8 31 31 00 00       	call   4169 <printf>
    1038:	83 c4 10             	add    $0x10,%esp
    103b:	eb 1a                	jmp    1057 <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    103d:	ff 75 ec             	pushl  -0x14(%ebp)
    1040:	ff 75 f0             	pushl  -0x10(%ebp)
    1043:	68 24 4b 00 00       	push   $0x4b24
    1048:	6a 01                	push   $0x1
    104a:	e8 1a 31 00 00       	call   4169 <printf>
    104f:	83 c4 10             	add    $0x10,%esp
    exit();
    1052:	e8 9f 2f 00 00       	call   3ff6 <exit>
  }
}
    1057:	c9                   	leave  
    1058:	c3                   	ret    

00001059 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1059:	55                   	push   %ebp
    105a:	89 e5                	mov    %esp,%ebp
    105c:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    105f:	c7 45 c8 39 4b 00 00 	movl   $0x4b39,-0x38(%ebp)
    1066:	c7 45 cc 3c 4b 00 00 	movl   $0x4b3c,-0x34(%ebp)
    106d:	c7 45 d0 3f 4b 00 00 	movl   $0x4b3f,-0x30(%ebp)
    1074:	c7 45 d4 42 4b 00 00 	movl   $0x4b42,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    107b:	83 ec 08             	sub    $0x8,%esp
    107e:	68 45 4b 00 00       	push   $0x4b45
    1083:	6a 01                	push   $0x1
    1085:	e8 df 30 00 00       	call   4169 <printf>
    108a:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    108d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1094:	e9 f0 00 00 00       	jmp    1189 <fourfiles+0x130>
    fname = names[pi];
    1099:	8b 45 e8             	mov    -0x18(%ebp),%eax
    109c:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    10a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    10a3:	83 ec 0c             	sub    $0xc,%esp
    10a6:	ff 75 e4             	pushl  -0x1c(%ebp)
    10a9:	e8 98 2f 00 00       	call   4046 <unlink>
    10ae:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    10b1:	e8 38 2f 00 00       	call   3fee <fork>
    10b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if(pid < 0){
    10b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    10bd:	79 17                	jns    10d6 <fourfiles+0x7d>
      printf(1, "fork failed\n");
    10bf:	83 ec 08             	sub    $0x8,%esp
    10c2:	68 c1 45 00 00       	push   $0x45c1
    10c7:	6a 01                	push   $0x1
    10c9:	e8 9b 30 00 00       	call   4169 <printf>
    10ce:	83 c4 10             	add    $0x10,%esp
      exit();
    10d1:	e8 20 2f 00 00       	call   3ff6 <exit>
    }

    if(pid == 0){
    10d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    10da:	0f 85 a5 00 00 00    	jne    1185 <fourfiles+0x12c>
      fd = open(fname, O_CREATE | O_RDWR);
    10e0:	83 ec 08             	sub    $0x8,%esp
    10e3:	68 02 02 00 00       	push   $0x202
    10e8:	ff 75 e4             	pushl  -0x1c(%ebp)
    10eb:	e8 46 2f 00 00       	call   4036 <open>
    10f0:	83 c4 10             	add    $0x10,%esp
    10f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(fd < 0){
    10f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10fa:	79 17                	jns    1113 <fourfiles+0xba>
        printf(1, "create failed\n");
    10fc:	83 ec 08             	sub    $0x8,%esp
    10ff:	68 55 4b 00 00       	push   $0x4b55
    1104:	6a 01                	push   $0x1
    1106:	e8 5e 30 00 00       	call   4169 <printf>
    110b:	83 c4 10             	add    $0x10,%esp
        exit();
    110e:	e8 e3 2e 00 00       	call   3ff6 <exit>
      }

      memset(buf, '0'+pi, 512);
    1113:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1116:	83 c0 30             	add    $0x30,%eax
    1119:	83 ec 04             	sub    $0x4,%esp
    111c:	68 00 02 00 00       	push   $0x200
    1121:	50                   	push   %eax
    1122:	68 60 8c 00 00       	push   $0x8c60
    1127:	e8 2f 2d 00 00       	call   3e5b <memset>
    112c:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    112f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1136:	eb 42                	jmp    117a <fourfiles+0x121>
        if((n = write(fd, buf, 500)) != 500){
    1138:	83 ec 04             	sub    $0x4,%esp
    113b:	68 f4 01 00 00       	push   $0x1f4
    1140:	68 60 8c 00 00       	push   $0x8c60
    1145:	ff 75 e0             	pushl  -0x20(%ebp)
    1148:	e8 c9 2e 00 00       	call   4016 <write>
    114d:	83 c4 10             	add    $0x10,%esp
    1150:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1153:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
    115a:	74 1a                	je     1176 <fourfiles+0x11d>
          printf(1, "write failed %d\n", n);
    115c:	83 ec 04             	sub    $0x4,%esp
    115f:	ff 75 dc             	pushl  -0x24(%ebp)
    1162:	68 64 4b 00 00       	push   $0x4b64
    1167:	6a 01                	push   $0x1
    1169:	e8 fb 2f 00 00       	call   4169 <printf>
    116e:	83 c4 10             	add    $0x10,%esp
          exit();
    1171:	e8 80 2e 00 00       	call   3ff6 <exit>
      for(i = 0; i < 12; i++){
    1176:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    117a:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    117e:	7e b8                	jle    1138 <fourfiles+0xdf>
        }
      }
      exit();
    1180:	e8 71 2e 00 00       	call   3ff6 <exit>
  for(pi = 0; pi < 4; pi++){
    1185:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1189:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    118d:	0f 8e 06 ff ff ff    	jle    1099 <fourfiles+0x40>
    }
  }

  for(pi = 0; pi < 4; pi++){
    1193:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    119a:	eb 09                	jmp    11a5 <fourfiles+0x14c>
    wait();
    119c:	e8 5d 2e 00 00       	call   3ffe <wait>
  for(pi = 0; pi < 4; pi++){
    11a1:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    11a5:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11a9:	7e f1                	jle    119c <fourfiles+0x143>
  }

  for(i = 0; i < 2; i++){
    11ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11b2:	e9 d4 00 00 00       	jmp    128b <fourfiles+0x232>
    fname = names[i];
    11b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ba:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    11c1:	83 ec 08             	sub    $0x8,%esp
    11c4:	6a 00                	push   $0x0
    11c6:	ff 75 e4             	pushl  -0x1c(%ebp)
    11c9:	e8 68 2e 00 00       	call   4036 <open>
    11ce:	83 c4 10             	add    $0x10,%esp
    11d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
    11d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11db:	eb 4a                	jmp    1227 <fourfiles+0x1ce>
      for(j = 0; j < n; j++){
    11dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11e4:	eb 33                	jmp    1219 <fourfiles+0x1c0>
        if(buf[j] != '0'+i){
    11e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11e9:	05 60 8c 00 00       	add    $0x8c60,%eax
    11ee:	0f b6 00             	movzbl (%eax),%eax
    11f1:	0f be c0             	movsbl %al,%eax
    11f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11f7:	83 c2 30             	add    $0x30,%edx
    11fa:	39 d0                	cmp    %edx,%eax
    11fc:	74 17                	je     1215 <fourfiles+0x1bc>
          printf(1, "wrong char\n");
    11fe:	83 ec 08             	sub    $0x8,%esp
    1201:	68 75 4b 00 00       	push   $0x4b75
    1206:	6a 01                	push   $0x1
    1208:	e8 5c 2f 00 00       	call   4169 <printf>
    120d:	83 c4 10             	add    $0x10,%esp
          exit();
    1210:	e8 e1 2d 00 00       	call   3ff6 <exit>
      for(j = 0; j < n; j++){
    1215:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1219:	8b 45 f0             	mov    -0x10(%ebp),%eax
    121c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    121f:	7c c5                	jl     11e6 <fourfiles+0x18d>
        }
      }
      total += n;
    1221:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1224:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1227:	83 ec 04             	sub    $0x4,%esp
    122a:	68 00 20 00 00       	push   $0x2000
    122f:	68 60 8c 00 00       	push   $0x8c60
    1234:	ff 75 e0             	pushl  -0x20(%ebp)
    1237:	e8 d2 2d 00 00       	call   400e <read>
    123c:	83 c4 10             	add    $0x10,%esp
    123f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1242:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1246:	7f 95                	jg     11dd <fourfiles+0x184>
    }
    close(fd);
    1248:	83 ec 0c             	sub    $0xc,%esp
    124b:	ff 75 e0             	pushl  -0x20(%ebp)
    124e:	e8 cb 2d 00 00       	call   401e <close>
    1253:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    1256:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    125d:	74 1a                	je     1279 <fourfiles+0x220>
      printf(1, "wrong length %d\n", total);
    125f:	83 ec 04             	sub    $0x4,%esp
    1262:	ff 75 ec             	pushl  -0x14(%ebp)
    1265:	68 81 4b 00 00       	push   $0x4b81
    126a:	6a 01                	push   $0x1
    126c:	e8 f8 2e 00 00       	call   4169 <printf>
    1271:	83 c4 10             	add    $0x10,%esp
      exit();
    1274:	e8 7d 2d 00 00       	call   3ff6 <exit>
    }
    unlink(fname);
    1279:	83 ec 0c             	sub    $0xc,%esp
    127c:	ff 75 e4             	pushl  -0x1c(%ebp)
    127f:	e8 c2 2d 00 00       	call   4046 <unlink>
    1284:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 2; i++){
    1287:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    128b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    128f:	0f 8e 22 ff ff ff    	jle    11b7 <fourfiles+0x15e>
  }

  printf(1, "fourfiles ok\n");
    1295:	83 ec 08             	sub    $0x8,%esp
    1298:	68 92 4b 00 00       	push   $0x4b92
    129d:	6a 01                	push   $0x1
    129f:	e8 c5 2e 00 00       	call   4169 <printf>
    12a4:	83 c4 10             	add    $0x10,%esp
}
    12a7:	90                   	nop
    12a8:	c9                   	leave  
    12a9:	c3                   	ret    

000012aa <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12aa:	55                   	push   %ebp
    12ab:	89 e5                	mov    %esp,%ebp
    12ad:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12b0:	83 ec 08             	sub    $0x8,%esp
    12b3:	68 a0 4b 00 00       	push   $0x4ba0
    12b8:	6a 01                	push   $0x1
    12ba:	e8 aa 2e 00 00       	call   4169 <printf>
    12bf:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    12c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12c9:	e9 f6 00 00 00       	jmp    13c4 <createdelete+0x11a>
    pid = fork();
    12ce:	e8 1b 2d 00 00       	call   3fee <fork>
    12d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    12d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12da:	79 17                	jns    12f3 <createdelete+0x49>
      printf(1, "fork failed\n");
    12dc:	83 ec 08             	sub    $0x8,%esp
    12df:	68 c1 45 00 00       	push   $0x45c1
    12e4:	6a 01                	push   $0x1
    12e6:	e8 7e 2e 00 00       	call   4169 <printf>
    12eb:	83 c4 10             	add    $0x10,%esp
      exit();
    12ee:	e8 03 2d 00 00       	call   3ff6 <exit>
    }

    if(pid == 0){
    12f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12f7:	0f 85 c3 00 00 00    	jne    13c0 <createdelete+0x116>
      name[0] = 'p' + pi;
    12fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1300:	83 c0 70             	add    $0x70,%eax
    1303:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1306:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    130a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1311:	e9 9b 00 00 00       	jmp    13b1 <createdelete+0x107>
        name[1] = '0' + i;
    1316:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1319:	83 c0 30             	add    $0x30,%eax
    131c:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    131f:	83 ec 08             	sub    $0x8,%esp
    1322:	68 02 02 00 00       	push   $0x202
    1327:	8d 45 c8             	lea    -0x38(%ebp),%eax
    132a:	50                   	push   %eax
    132b:	e8 06 2d 00 00       	call   4036 <open>
    1330:	83 c4 10             	add    $0x10,%esp
    1333:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if(fd < 0){
    1336:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    133a:	79 17                	jns    1353 <createdelete+0xa9>
          printf(1, "create failed\n");
    133c:	83 ec 08             	sub    $0x8,%esp
    133f:	68 55 4b 00 00       	push   $0x4b55
    1344:	6a 01                	push   $0x1
    1346:	e8 1e 2e 00 00       	call   4169 <printf>
    134b:	83 c4 10             	add    $0x10,%esp
          exit();
    134e:	e8 a3 2c 00 00       	call   3ff6 <exit>
        }
        close(fd);
    1353:	83 ec 0c             	sub    $0xc,%esp
    1356:	ff 75 ec             	pushl  -0x14(%ebp)
    1359:	e8 c0 2c 00 00       	call   401e <close>
    135e:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    1361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1365:	7e 46                	jle    13ad <createdelete+0x103>
    1367:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136a:	83 e0 01             	and    $0x1,%eax
    136d:	85 c0                	test   %eax,%eax
    136f:	75 3c                	jne    13ad <createdelete+0x103>
          name[1] = '0' + (i / 2);
    1371:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1374:	89 c2                	mov    %eax,%edx
    1376:	c1 ea 1f             	shr    $0x1f,%edx
    1379:	01 d0                	add    %edx,%eax
    137b:	d1 f8                	sar    %eax
    137d:	83 c0 30             	add    $0x30,%eax
    1380:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1383:	83 ec 0c             	sub    $0xc,%esp
    1386:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1389:	50                   	push   %eax
    138a:	e8 b7 2c 00 00       	call   4046 <unlink>
    138f:	83 c4 10             	add    $0x10,%esp
    1392:	85 c0                	test   %eax,%eax
    1394:	79 17                	jns    13ad <createdelete+0x103>
            printf(1, "unlink failed\n");
    1396:	83 ec 08             	sub    $0x8,%esp
    1399:	68 44 46 00 00       	push   $0x4644
    139e:	6a 01                	push   $0x1
    13a0:	e8 c4 2d 00 00       	call   4169 <printf>
    13a5:	83 c4 10             	add    $0x10,%esp
            exit();
    13a8:	e8 49 2c 00 00       	call   3ff6 <exit>
      for(i = 0; i < N; i++){
    13ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13b1:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    13b5:	0f 8e 5b ff ff ff    	jle    1316 <createdelete+0x6c>
          }
        }
      }
      exit();
    13bb:	e8 36 2c 00 00       	call   3ff6 <exit>
  for(pi = 0; pi < 4; pi++){
    13c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13c4:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13c8:	0f 8e 00 ff ff ff    	jle    12ce <createdelete+0x24>
    }
  }

  for(pi = 0; pi < 4; pi++){
    13ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13d5:	eb 09                	jmp    13e0 <createdelete+0x136>
    wait();
    13d7:	e8 22 2c 00 00       	call   3ffe <wait>
  for(pi = 0; pi < 4; pi++){
    13dc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13e0:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13e4:	7e f1                	jle    13d7 <createdelete+0x12d>
  }

  name[0] = name[1] = name[2] = 0;
    13e6:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13ea:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13ee:	88 45 c9             	mov    %al,-0x37(%ebp)
    13f1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13f5:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13ff:	e9 b2 00 00 00       	jmp    14b6 <createdelete+0x20c>
    for(pi = 0; pi < 4; pi++){
    1404:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    140b:	e9 98 00 00 00       	jmp    14a8 <createdelete+0x1fe>
      name[0] = 'p' + pi;
    1410:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1413:	83 c0 70             	add    $0x70,%eax
    1416:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1419:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141c:	83 c0 30             	add    $0x30,%eax
    141f:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1422:	83 ec 08             	sub    $0x8,%esp
    1425:	6a 00                	push   $0x0
    1427:	8d 45 c8             	lea    -0x38(%ebp),%eax
    142a:	50                   	push   %eax
    142b:	e8 06 2c 00 00       	call   4036 <open>
    1430:	83 c4 10             	add    $0x10,%esp
    1433:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    143a:	74 06                	je     1442 <createdelete+0x198>
    143c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1440:	7e 21                	jle    1463 <createdelete+0x1b9>
    1442:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1446:	79 1b                	jns    1463 <createdelete+0x1b9>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1448:	83 ec 04             	sub    $0x4,%esp
    144b:	8d 45 c8             	lea    -0x38(%ebp),%eax
    144e:	50                   	push   %eax
    144f:	68 b4 4b 00 00       	push   $0x4bb4
    1454:	6a 01                	push   $0x1
    1456:	e8 0e 2d 00 00       	call   4169 <printf>
    145b:	83 c4 10             	add    $0x10,%esp
        exit();
    145e:	e8 93 2b 00 00       	call   3ff6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1467:	7e 27                	jle    1490 <createdelete+0x1e6>
    1469:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    146d:	7f 21                	jg     1490 <createdelete+0x1e6>
    146f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1473:	78 1b                	js     1490 <createdelete+0x1e6>
        printf(1, "oops createdelete %s did exist\n", name);
    1475:	83 ec 04             	sub    $0x4,%esp
    1478:	8d 45 c8             	lea    -0x38(%ebp),%eax
    147b:	50                   	push   %eax
    147c:	68 d8 4b 00 00       	push   $0x4bd8
    1481:	6a 01                	push   $0x1
    1483:	e8 e1 2c 00 00       	call   4169 <printf>
    1488:	83 c4 10             	add    $0x10,%esp
        exit();
    148b:	e8 66 2b 00 00       	call   3ff6 <exit>
      }
      if(fd >= 0)
    1490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1494:	78 0e                	js     14a4 <createdelete+0x1fa>
        close(fd);
    1496:	83 ec 0c             	sub    $0xc,%esp
    1499:	ff 75 ec             	pushl  -0x14(%ebp)
    149c:	e8 7d 2b 00 00       	call   401e <close>
    14a1:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    14a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14a8:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14ac:	0f 8e 5e ff ff ff    	jle    1410 <createdelete+0x166>
  for(i = 0; i < N; i++){
    14b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14b6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14ba:	0f 8e 44 ff ff ff    	jle    1404 <createdelete+0x15a>
    }
  }

  for(i = 0; i < N; i++){
    14c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14c7:	eb 38                	jmp    1501 <createdelete+0x257>
    for(pi = 0; pi < 4; pi++){
    14c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14d0:	eb 25                	jmp    14f7 <createdelete+0x24d>
      name[0] = 'p' + i;
    14d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d5:	83 c0 70             	add    $0x70,%eax
    14d8:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14de:	83 c0 30             	add    $0x30,%eax
    14e1:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14e4:	83 ec 0c             	sub    $0xc,%esp
    14e7:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14ea:	50                   	push   %eax
    14eb:	e8 56 2b 00 00       	call   4046 <unlink>
    14f0:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    14f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14f7:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14fb:	7e d5                	jle    14d2 <createdelete+0x228>
  for(i = 0; i < N; i++){
    14fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1501:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1505:	7e c2                	jle    14c9 <createdelete+0x21f>
    }
  }

  printf(1, "createdelete ok\n");
    1507:	83 ec 08             	sub    $0x8,%esp
    150a:	68 f8 4b 00 00       	push   $0x4bf8
    150f:	6a 01                	push   $0x1
    1511:	e8 53 2c 00 00       	call   4169 <printf>
    1516:	83 c4 10             	add    $0x10,%esp
}
    1519:	90                   	nop
    151a:	c9                   	leave  
    151b:	c3                   	ret    

0000151c <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    151c:	55                   	push   %ebp
    151d:	89 e5                	mov    %esp,%ebp
    151f:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1522:	83 ec 08             	sub    $0x8,%esp
    1525:	68 09 4c 00 00       	push   $0x4c09
    152a:	6a 01                	push   $0x1
    152c:	e8 38 2c 00 00       	call   4169 <printf>
    1531:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1534:	83 ec 08             	sub    $0x8,%esp
    1537:	68 02 02 00 00       	push   $0x202
    153c:	68 1a 4c 00 00       	push   $0x4c1a
    1541:	e8 f0 2a 00 00       	call   4036 <open>
    1546:	83 c4 10             	add    $0x10,%esp
    1549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    154c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1550:	79 17                	jns    1569 <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    1552:	83 ec 08             	sub    $0x8,%esp
    1555:	68 25 4c 00 00       	push   $0x4c25
    155a:	6a 01                	push   $0x1
    155c:	e8 08 2c 00 00       	call   4169 <printf>
    1561:	83 c4 10             	add    $0x10,%esp
    exit();
    1564:	e8 8d 2a 00 00       	call   3ff6 <exit>
  }
  write(fd, "hello", 5);
    1569:	83 ec 04             	sub    $0x4,%esp
    156c:	6a 05                	push   $0x5
    156e:	68 3f 4c 00 00       	push   $0x4c3f
    1573:	ff 75 f4             	pushl  -0xc(%ebp)
    1576:	e8 9b 2a 00 00       	call   4016 <write>
    157b:	83 c4 10             	add    $0x10,%esp
  close(fd);
    157e:	83 ec 0c             	sub    $0xc,%esp
    1581:	ff 75 f4             	pushl  -0xc(%ebp)
    1584:	e8 95 2a 00 00       	call   401e <close>
    1589:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    158c:	83 ec 08             	sub    $0x8,%esp
    158f:	6a 02                	push   $0x2
    1591:	68 1a 4c 00 00       	push   $0x4c1a
    1596:	e8 9b 2a 00 00       	call   4036 <open>
    159b:	83 c4 10             	add    $0x10,%esp
    159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    15a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15a5:	79 17                	jns    15be <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    15a7:	83 ec 08             	sub    $0x8,%esp
    15aa:	68 45 4c 00 00       	push   $0x4c45
    15af:	6a 01                	push   $0x1
    15b1:	e8 b3 2b 00 00       	call   4169 <printf>
    15b6:	83 c4 10             	add    $0x10,%esp
    exit();
    15b9:	e8 38 2a 00 00       	call   3ff6 <exit>
  }
  if(unlink("unlinkread") != 0){
    15be:	83 ec 0c             	sub    $0xc,%esp
    15c1:	68 1a 4c 00 00       	push   $0x4c1a
    15c6:	e8 7b 2a 00 00       	call   4046 <unlink>
    15cb:	83 c4 10             	add    $0x10,%esp
    15ce:	85 c0                	test   %eax,%eax
    15d0:	74 17                	je     15e9 <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    15d2:	83 ec 08             	sub    $0x8,%esp
    15d5:	68 5d 4c 00 00       	push   $0x4c5d
    15da:	6a 01                	push   $0x1
    15dc:	e8 88 2b 00 00       	call   4169 <printf>
    15e1:	83 c4 10             	add    $0x10,%esp
    exit();
    15e4:	e8 0d 2a 00 00       	call   3ff6 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15e9:	83 ec 08             	sub    $0x8,%esp
    15ec:	68 02 02 00 00       	push   $0x202
    15f1:	68 1a 4c 00 00       	push   $0x4c1a
    15f6:	e8 3b 2a 00 00       	call   4036 <open>
    15fb:	83 c4 10             	add    $0x10,%esp
    15fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1601:	83 ec 04             	sub    $0x4,%esp
    1604:	6a 03                	push   $0x3
    1606:	68 77 4c 00 00       	push   $0x4c77
    160b:	ff 75 f0             	pushl  -0x10(%ebp)
    160e:	e8 03 2a 00 00       	call   4016 <write>
    1613:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    1616:	83 ec 0c             	sub    $0xc,%esp
    1619:	ff 75 f0             	pushl  -0x10(%ebp)
    161c:	e8 fd 29 00 00       	call   401e <close>
    1621:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    1624:	83 ec 04             	sub    $0x4,%esp
    1627:	68 00 20 00 00       	push   $0x2000
    162c:	68 60 8c 00 00       	push   $0x8c60
    1631:	ff 75 f4             	pushl  -0xc(%ebp)
    1634:	e8 d5 29 00 00       	call   400e <read>
    1639:	83 c4 10             	add    $0x10,%esp
    163c:	83 f8 05             	cmp    $0x5,%eax
    163f:	74 17                	je     1658 <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    1641:	83 ec 08             	sub    $0x8,%esp
    1644:	68 7b 4c 00 00       	push   $0x4c7b
    1649:	6a 01                	push   $0x1
    164b:	e8 19 2b 00 00       	call   4169 <printf>
    1650:	83 c4 10             	add    $0x10,%esp
    exit();
    1653:	e8 9e 29 00 00       	call   3ff6 <exit>
  }
  if(buf[0] != 'h'){
    1658:	0f b6 05 60 8c 00 00 	movzbl 0x8c60,%eax
    165f:	3c 68                	cmp    $0x68,%al
    1661:	74 17                	je     167a <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    1663:	83 ec 08             	sub    $0x8,%esp
    1666:	68 92 4c 00 00       	push   $0x4c92
    166b:	6a 01                	push   $0x1
    166d:	e8 f7 2a 00 00       	call   4169 <printf>
    1672:	83 c4 10             	add    $0x10,%esp
    exit();
    1675:	e8 7c 29 00 00       	call   3ff6 <exit>
  }
  if(write(fd, buf, 10) != 10){
    167a:	83 ec 04             	sub    $0x4,%esp
    167d:	6a 0a                	push   $0xa
    167f:	68 60 8c 00 00       	push   $0x8c60
    1684:	ff 75 f4             	pushl  -0xc(%ebp)
    1687:	e8 8a 29 00 00       	call   4016 <write>
    168c:	83 c4 10             	add    $0x10,%esp
    168f:	83 f8 0a             	cmp    $0xa,%eax
    1692:	74 17                	je     16ab <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    1694:	83 ec 08             	sub    $0x8,%esp
    1697:	68 a9 4c 00 00       	push   $0x4ca9
    169c:	6a 01                	push   $0x1
    169e:	e8 c6 2a 00 00       	call   4169 <printf>
    16a3:	83 c4 10             	add    $0x10,%esp
    exit();
    16a6:	e8 4b 29 00 00       	call   3ff6 <exit>
  }
  close(fd);
    16ab:	83 ec 0c             	sub    $0xc,%esp
    16ae:	ff 75 f4             	pushl  -0xc(%ebp)
    16b1:	e8 68 29 00 00       	call   401e <close>
    16b6:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    16b9:	83 ec 0c             	sub    $0xc,%esp
    16bc:	68 1a 4c 00 00       	push   $0x4c1a
    16c1:	e8 80 29 00 00       	call   4046 <unlink>
    16c6:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    16c9:	83 ec 08             	sub    $0x8,%esp
    16cc:	68 c2 4c 00 00       	push   $0x4cc2
    16d1:	6a 01                	push   $0x1
    16d3:	e8 91 2a 00 00       	call   4169 <printf>
    16d8:	83 c4 10             	add    $0x10,%esp
}
    16db:	90                   	nop
    16dc:	c9                   	leave  
    16dd:	c3                   	ret    

000016de <linktest>:

void
linktest(void)
{
    16de:	55                   	push   %ebp
    16df:	89 e5                	mov    %esp,%ebp
    16e1:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    16e4:	83 ec 08             	sub    $0x8,%esp
    16e7:	68 d1 4c 00 00       	push   $0x4cd1
    16ec:	6a 01                	push   $0x1
    16ee:	e8 76 2a 00 00       	call   4169 <printf>
    16f3:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    16f6:	83 ec 0c             	sub    $0xc,%esp
    16f9:	68 db 4c 00 00       	push   $0x4cdb
    16fe:	e8 43 29 00 00       	call   4046 <unlink>
    1703:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    1706:	83 ec 0c             	sub    $0xc,%esp
    1709:	68 df 4c 00 00       	push   $0x4cdf
    170e:	e8 33 29 00 00       	call   4046 <unlink>
    1713:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    1716:	83 ec 08             	sub    $0x8,%esp
    1719:	68 02 02 00 00       	push   $0x202
    171e:	68 db 4c 00 00       	push   $0x4cdb
    1723:	e8 0e 29 00 00       	call   4036 <open>
    1728:	83 c4 10             	add    $0x10,%esp
    172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    172e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1732:	79 17                	jns    174b <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    1734:	83 ec 08             	sub    $0x8,%esp
    1737:	68 e3 4c 00 00       	push   $0x4ce3
    173c:	6a 01                	push   $0x1
    173e:	e8 26 2a 00 00       	call   4169 <printf>
    1743:	83 c4 10             	add    $0x10,%esp
    exit();
    1746:	e8 ab 28 00 00       	call   3ff6 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    174b:	83 ec 04             	sub    $0x4,%esp
    174e:	6a 05                	push   $0x5
    1750:	68 3f 4c 00 00       	push   $0x4c3f
    1755:	ff 75 f4             	pushl  -0xc(%ebp)
    1758:	e8 b9 28 00 00       	call   4016 <write>
    175d:	83 c4 10             	add    $0x10,%esp
    1760:	83 f8 05             	cmp    $0x5,%eax
    1763:	74 17                	je     177c <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    1765:	83 ec 08             	sub    $0x8,%esp
    1768:	68 f6 4c 00 00       	push   $0x4cf6
    176d:	6a 01                	push   $0x1
    176f:	e8 f5 29 00 00       	call   4169 <printf>
    1774:	83 c4 10             	add    $0x10,%esp
    exit();
    1777:	e8 7a 28 00 00       	call   3ff6 <exit>
  }
  close(fd);
    177c:	83 ec 0c             	sub    $0xc,%esp
    177f:	ff 75 f4             	pushl  -0xc(%ebp)
    1782:	e8 97 28 00 00       	call   401e <close>
    1787:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    178a:	83 ec 08             	sub    $0x8,%esp
    178d:	68 df 4c 00 00       	push   $0x4cdf
    1792:	68 db 4c 00 00       	push   $0x4cdb
    1797:	e8 ba 28 00 00       	call   4056 <link>
    179c:	83 c4 10             	add    $0x10,%esp
    179f:	85 c0                	test   %eax,%eax
    17a1:	79 17                	jns    17ba <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    17a3:	83 ec 08             	sub    $0x8,%esp
    17a6:	68 08 4d 00 00       	push   $0x4d08
    17ab:	6a 01                	push   $0x1
    17ad:	e8 b7 29 00 00       	call   4169 <printf>
    17b2:	83 c4 10             	add    $0x10,%esp
    exit();
    17b5:	e8 3c 28 00 00       	call   3ff6 <exit>
  }
  unlink("lf1");
    17ba:	83 ec 0c             	sub    $0xc,%esp
    17bd:	68 db 4c 00 00       	push   $0x4cdb
    17c2:	e8 7f 28 00 00       	call   4046 <unlink>
    17c7:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    17ca:	83 ec 08             	sub    $0x8,%esp
    17cd:	6a 00                	push   $0x0
    17cf:	68 db 4c 00 00       	push   $0x4cdb
    17d4:	e8 5d 28 00 00       	call   4036 <open>
    17d9:	83 c4 10             	add    $0x10,%esp
    17dc:	85 c0                	test   %eax,%eax
    17de:	78 17                	js     17f7 <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    17e0:	83 ec 08             	sub    $0x8,%esp
    17e3:	68 20 4d 00 00       	push   $0x4d20
    17e8:	6a 01                	push   $0x1
    17ea:	e8 7a 29 00 00       	call   4169 <printf>
    17ef:	83 c4 10             	add    $0x10,%esp
    exit();
    17f2:	e8 ff 27 00 00       	call   3ff6 <exit>
  }

  fd = open("lf2", 0);
    17f7:	83 ec 08             	sub    $0x8,%esp
    17fa:	6a 00                	push   $0x0
    17fc:	68 df 4c 00 00       	push   $0x4cdf
    1801:	e8 30 28 00 00       	call   4036 <open>
    1806:	83 c4 10             	add    $0x10,%esp
    1809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    180c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1810:	79 17                	jns    1829 <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    1812:	83 ec 08             	sub    $0x8,%esp
    1815:	68 45 4d 00 00       	push   $0x4d45
    181a:	6a 01                	push   $0x1
    181c:	e8 48 29 00 00       	call   4169 <printf>
    1821:	83 c4 10             	add    $0x10,%esp
    exit();
    1824:	e8 cd 27 00 00       	call   3ff6 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1829:	83 ec 04             	sub    $0x4,%esp
    182c:	68 00 20 00 00       	push   $0x2000
    1831:	68 60 8c 00 00       	push   $0x8c60
    1836:	ff 75 f4             	pushl  -0xc(%ebp)
    1839:	e8 d0 27 00 00       	call   400e <read>
    183e:	83 c4 10             	add    $0x10,%esp
    1841:	83 f8 05             	cmp    $0x5,%eax
    1844:	74 17                	je     185d <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    1846:	83 ec 08             	sub    $0x8,%esp
    1849:	68 56 4d 00 00       	push   $0x4d56
    184e:	6a 01                	push   $0x1
    1850:	e8 14 29 00 00       	call   4169 <printf>
    1855:	83 c4 10             	add    $0x10,%esp
    exit();
    1858:	e8 99 27 00 00       	call   3ff6 <exit>
  }
  close(fd);
    185d:	83 ec 0c             	sub    $0xc,%esp
    1860:	ff 75 f4             	pushl  -0xc(%ebp)
    1863:	e8 b6 27 00 00       	call   401e <close>
    1868:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    186b:	83 ec 08             	sub    $0x8,%esp
    186e:	68 df 4c 00 00       	push   $0x4cdf
    1873:	68 df 4c 00 00       	push   $0x4cdf
    1878:	e8 d9 27 00 00       	call   4056 <link>
    187d:	83 c4 10             	add    $0x10,%esp
    1880:	85 c0                	test   %eax,%eax
    1882:	78 17                	js     189b <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1884:	83 ec 08             	sub    $0x8,%esp
    1887:	68 67 4d 00 00       	push   $0x4d67
    188c:	6a 01                	push   $0x1
    188e:	e8 d6 28 00 00       	call   4169 <printf>
    1893:	83 c4 10             	add    $0x10,%esp
    exit();
    1896:	e8 5b 27 00 00       	call   3ff6 <exit>
  }

  unlink("lf2");
    189b:	83 ec 0c             	sub    $0xc,%esp
    189e:	68 df 4c 00 00       	push   $0x4cdf
    18a3:	e8 9e 27 00 00       	call   4046 <unlink>
    18a8:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    18ab:	83 ec 08             	sub    $0x8,%esp
    18ae:	68 db 4c 00 00       	push   $0x4cdb
    18b3:	68 df 4c 00 00       	push   $0x4cdf
    18b8:	e8 99 27 00 00       	call   4056 <link>
    18bd:	83 c4 10             	add    $0x10,%esp
    18c0:	85 c0                	test   %eax,%eax
    18c2:	78 17                	js     18db <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    18c4:	83 ec 08             	sub    $0x8,%esp
    18c7:	68 88 4d 00 00       	push   $0x4d88
    18cc:	6a 01                	push   $0x1
    18ce:	e8 96 28 00 00       	call   4169 <printf>
    18d3:	83 c4 10             	add    $0x10,%esp
    exit();
    18d6:	e8 1b 27 00 00       	call   3ff6 <exit>
  }

  if(link(".", "lf1") >= 0){
    18db:	83 ec 08             	sub    $0x8,%esp
    18de:	68 db 4c 00 00       	push   $0x4cdb
    18e3:	68 ab 4d 00 00       	push   $0x4dab
    18e8:	e8 69 27 00 00       	call   4056 <link>
    18ed:	83 c4 10             	add    $0x10,%esp
    18f0:	85 c0                	test   %eax,%eax
    18f2:	78 17                	js     190b <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    18f4:	83 ec 08             	sub    $0x8,%esp
    18f7:	68 ad 4d 00 00       	push   $0x4dad
    18fc:	6a 01                	push   $0x1
    18fe:	e8 66 28 00 00       	call   4169 <printf>
    1903:	83 c4 10             	add    $0x10,%esp
    exit();
    1906:	e8 eb 26 00 00       	call   3ff6 <exit>
  }

  printf(1, "linktest ok\n");
    190b:	83 ec 08             	sub    $0x8,%esp
    190e:	68 c9 4d 00 00       	push   $0x4dc9
    1913:	6a 01                	push   $0x1
    1915:	e8 4f 28 00 00       	call   4169 <printf>
    191a:	83 c4 10             	add    $0x10,%esp
}
    191d:	90                   	nop
    191e:	c9                   	leave  
    191f:	c3                   	ret    

00001920 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1920:	55                   	push   %ebp
    1921:	89 e5                	mov    %esp,%ebp
    1923:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1926:	83 ec 08             	sub    $0x8,%esp
    1929:	68 d6 4d 00 00       	push   $0x4dd6
    192e:	6a 01                	push   $0x1
    1930:	e8 34 28 00 00       	call   4169 <printf>
    1935:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    1938:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    193c:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1947:	e9 fc 00 00 00       	jmp    1a48 <concreate+0x128>
    file[1] = '0' + i;
    194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194f:	83 c0 30             	add    $0x30,%eax
    1952:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1955:	83 ec 0c             	sub    $0xc,%esp
    1958:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    195b:	50                   	push   %eax
    195c:	e8 e5 26 00 00       	call   4046 <unlink>
    1961:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    1964:	e8 85 26 00 00       	call   3fee <fork>
    1969:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid && (i % 3) == 1){
    196c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1970:	74 3b                	je     19ad <concreate+0x8d>
    1972:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1975:	ba 56 55 55 55       	mov    $0x55555556,%edx
    197a:	89 c8                	mov    %ecx,%eax
    197c:	f7 ea                	imul   %edx
    197e:	89 c8                	mov    %ecx,%eax
    1980:	c1 f8 1f             	sar    $0x1f,%eax
    1983:	29 c2                	sub    %eax,%edx
    1985:	89 d0                	mov    %edx,%eax
    1987:	01 c0                	add    %eax,%eax
    1989:	01 d0                	add    %edx,%eax
    198b:	29 c1                	sub    %eax,%ecx
    198d:	89 ca                	mov    %ecx,%edx
    198f:	83 fa 01             	cmp    $0x1,%edx
    1992:	75 19                	jne    19ad <concreate+0x8d>
      link("C0", file);
    1994:	83 ec 08             	sub    $0x8,%esp
    1997:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    199a:	50                   	push   %eax
    199b:	68 e6 4d 00 00       	push   $0x4de6
    19a0:	e8 b1 26 00 00       	call   4056 <link>
    19a5:	83 c4 10             	add    $0x10,%esp
    19a8:	e9 87 00 00 00       	jmp    1a34 <concreate+0x114>
    } else if(pid == 0 && (i % 5) == 1){
    19ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19b1:	75 3b                	jne    19ee <concreate+0xce>
    19b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19b6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19bb:	89 c8                	mov    %ecx,%eax
    19bd:	f7 ea                	imul   %edx
    19bf:	d1 fa                	sar    %edx
    19c1:	89 c8                	mov    %ecx,%eax
    19c3:	c1 f8 1f             	sar    $0x1f,%eax
    19c6:	29 c2                	sub    %eax,%edx
    19c8:	89 d0                	mov    %edx,%eax
    19ca:	c1 e0 02             	shl    $0x2,%eax
    19cd:	01 d0                	add    %edx,%eax
    19cf:	29 c1                	sub    %eax,%ecx
    19d1:	89 ca                	mov    %ecx,%edx
    19d3:	83 fa 01             	cmp    $0x1,%edx
    19d6:	75 16                	jne    19ee <concreate+0xce>
      link("C0", file);
    19d8:	83 ec 08             	sub    $0x8,%esp
    19db:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19de:	50                   	push   %eax
    19df:	68 e6 4d 00 00       	push   $0x4de6
    19e4:	e8 6d 26 00 00       	call   4056 <link>
    19e9:	83 c4 10             	add    $0x10,%esp
    19ec:	eb 46                	jmp    1a34 <concreate+0x114>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19ee:	83 ec 08             	sub    $0x8,%esp
    19f1:	68 02 02 00 00       	push   $0x202
    19f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19f9:	50                   	push   %eax
    19fa:	e8 37 26 00 00       	call   4036 <open>
    19ff:	83 c4 10             	add    $0x10,%esp
    1a02:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(fd < 0){
    1a05:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a09:	79 1b                	jns    1a26 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    1a0b:	83 ec 04             	sub    $0x4,%esp
    1a0e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a11:	50                   	push   %eax
    1a12:	68 e9 4d 00 00       	push   $0x4de9
    1a17:	6a 01                	push   $0x1
    1a19:	e8 4b 27 00 00       	call   4169 <printf>
    1a1e:	83 c4 10             	add    $0x10,%esp
        exit();
    1a21:	e8 d0 25 00 00       	call   3ff6 <exit>
      }
      close(fd);
    1a26:	83 ec 0c             	sub    $0xc,%esp
    1a29:	ff 75 ec             	pushl  -0x14(%ebp)
    1a2c:	e8 ed 25 00 00       	call   401e <close>
    1a31:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1a38:	75 05                	jne    1a3f <concreate+0x11f>
      exit();
    1a3a:	e8 b7 25 00 00       	call   3ff6 <exit>
    else
      wait();
    1a3f:	e8 ba 25 00 00       	call   3ffe <wait>
  for(i = 0; i < 40; i++){
    1a44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a48:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a4c:	0f 8e fa fe ff ff    	jle    194c <concreate+0x2c>
  }

  memset(fa, 0, sizeof(fa));
    1a52:	83 ec 04             	sub    $0x4,%esp
    1a55:	6a 28                	push   $0x28
    1a57:	6a 00                	push   $0x0
    1a59:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a5c:	50                   	push   %eax
    1a5d:	e8 f9 23 00 00       	call   3e5b <memset>
    1a62:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1a65:	83 ec 08             	sub    $0x8,%esp
    1a68:	6a 00                	push   $0x0
    1a6a:	68 ab 4d 00 00       	push   $0x4dab
    1a6f:	e8 c2 25 00 00       	call   4036 <open>
    1a74:	83 c4 10             	add    $0x10,%esp
    1a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  n = 0;
    1a7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a81:	e9 93 00 00 00       	jmp    1b19 <concreate+0x1f9>
    if(de.inum == 0)
    1a86:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a8a:	66 85 c0             	test   %ax,%ax
    1a8d:	75 05                	jne    1a94 <concreate+0x174>
      continue;
    1a8f:	e9 85 00 00 00       	jmp    1b19 <concreate+0x1f9>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a94:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a98:	3c 43                	cmp    $0x43,%al
    1a9a:	75 7d                	jne    1b19 <concreate+0x1f9>
    1a9c:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1aa0:	84 c0                	test   %al,%al
    1aa2:	75 75                	jne    1b19 <concreate+0x1f9>
      i = de.name[1] - '0';
    1aa4:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1aa8:	0f be c0             	movsbl %al,%eax
    1aab:	83 e8 30             	sub    $0x30,%eax
    1aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ab5:	78 08                	js     1abf <concreate+0x19f>
    1ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aba:	83 f8 27             	cmp    $0x27,%eax
    1abd:	76 1e                	jbe    1add <concreate+0x1bd>
        printf(1, "concreate weird file %s\n", de.name);
    1abf:	83 ec 04             	sub    $0x4,%esp
    1ac2:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ac5:	83 c0 02             	add    $0x2,%eax
    1ac8:	50                   	push   %eax
    1ac9:	68 05 4e 00 00       	push   $0x4e05
    1ace:	6a 01                	push   $0x1
    1ad0:	e8 94 26 00 00       	call   4169 <printf>
    1ad5:	83 c4 10             	add    $0x10,%esp
        exit();
    1ad8:	e8 19 25 00 00       	call   3ff6 <exit>
      }
      if(fa[i]){
    1add:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae3:	01 d0                	add    %edx,%eax
    1ae5:	0f b6 00             	movzbl (%eax),%eax
    1ae8:	84 c0                	test   %al,%al
    1aea:	74 1e                	je     1b0a <concreate+0x1ea>
        printf(1, "concreate duplicate file %s\n", de.name);
    1aec:	83 ec 04             	sub    $0x4,%esp
    1aef:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1af2:	83 c0 02             	add    $0x2,%eax
    1af5:	50                   	push   %eax
    1af6:	68 1e 4e 00 00       	push   $0x4e1e
    1afb:	6a 01                	push   $0x1
    1afd:	e8 67 26 00 00       	call   4169 <printf>
    1b02:	83 c4 10             	add    $0x10,%esp
        exit();
    1b05:	e8 ec 24 00 00       	call   3ff6 <exit>
      }
      fa[i] = 1;
    1b0a:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b10:	01 d0                	add    %edx,%eax
    1b12:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b15:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1b19:	83 ec 04             	sub    $0x4,%esp
    1b1c:	6a 10                	push   $0x10
    1b1e:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b21:	50                   	push   %eax
    1b22:	ff 75 ec             	pushl  -0x14(%ebp)
    1b25:	e8 e4 24 00 00       	call   400e <read>
    1b2a:	83 c4 10             	add    $0x10,%esp
    1b2d:	85 c0                	test   %eax,%eax
    1b2f:	0f 8f 51 ff ff ff    	jg     1a86 <concreate+0x166>
    }
  }
  close(fd);
    1b35:	83 ec 0c             	sub    $0xc,%esp
    1b38:	ff 75 ec             	pushl  -0x14(%ebp)
    1b3b:	e8 de 24 00 00       	call   401e <close>
    1b40:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1b43:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b47:	74 17                	je     1b60 <concreate+0x240>
    printf(1, "concreate not enough files in directory listing\n");
    1b49:	83 ec 08             	sub    $0x8,%esp
    1b4c:	68 3c 4e 00 00       	push   $0x4e3c
    1b51:	6a 01                	push   $0x1
    1b53:	e8 11 26 00 00       	call   4169 <printf>
    1b58:	83 c4 10             	add    $0x10,%esp
    exit();
    1b5b:	e8 96 24 00 00       	call   3ff6 <exit>
  }

  for(i = 0; i < 40; i++){
    1b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b67:	e9 45 01 00 00       	jmp    1cb1 <concreate+0x391>
    file[1] = '0' + i;
    1b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b6f:	83 c0 30             	add    $0x30,%eax
    1b72:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b75:	e8 74 24 00 00       	call   3fee <fork>
    1b7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    1b7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1b81:	79 17                	jns    1b9a <concreate+0x27a>
      printf(1, "fork failed\n");
    1b83:	83 ec 08             	sub    $0x8,%esp
    1b86:	68 c1 45 00 00       	push   $0x45c1
    1b8b:	6a 01                	push   $0x1
    1b8d:	e8 d7 25 00 00       	call   4169 <printf>
    1b92:	83 c4 10             	add    $0x10,%esp
      exit();
    1b95:	e8 5c 24 00 00       	call   3ff6 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b9a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1b9d:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1ba2:	89 c8                	mov    %ecx,%eax
    1ba4:	f7 ea                	imul   %edx
    1ba6:	89 c8                	mov    %ecx,%eax
    1ba8:	c1 f8 1f             	sar    $0x1f,%eax
    1bab:	29 c2                	sub    %eax,%edx
    1bad:	89 d0                	mov    %edx,%eax
    1baf:	89 c2                	mov    %eax,%edx
    1bb1:	01 d2                	add    %edx,%edx
    1bb3:	01 c2                	add    %eax,%edx
    1bb5:	89 c8                	mov    %ecx,%eax
    1bb7:	29 d0                	sub    %edx,%eax
    1bb9:	85 c0                	test   %eax,%eax
    1bbb:	75 06                	jne    1bc3 <concreate+0x2a3>
    1bbd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1bc1:	74 28                	je     1beb <concreate+0x2cb>
       ((i % 3) == 1 && pid != 0)){
    1bc3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bc6:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bcb:	89 c8                	mov    %ecx,%eax
    1bcd:	f7 ea                	imul   %edx
    1bcf:	89 c8                	mov    %ecx,%eax
    1bd1:	c1 f8 1f             	sar    $0x1f,%eax
    1bd4:	29 c2                	sub    %eax,%edx
    1bd6:	89 d0                	mov    %edx,%eax
    1bd8:	01 c0                	add    %eax,%eax
    1bda:	01 d0                	add    %edx,%eax
    1bdc:	29 c1                	sub    %eax,%ecx
    1bde:	89 ca                	mov    %ecx,%edx
    if(((i % 3) == 0 && pid == 0) ||
    1be0:	83 fa 01             	cmp    $0x1,%edx
    1be3:	75 7c                	jne    1c61 <concreate+0x341>
       ((i % 3) == 1 && pid != 0)){
    1be5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1be9:	74 76                	je     1c61 <concreate+0x341>
      close(open(file, 0));
    1beb:	83 ec 08             	sub    $0x8,%esp
    1bee:	6a 00                	push   $0x0
    1bf0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bf3:	50                   	push   %eax
    1bf4:	e8 3d 24 00 00       	call   4036 <open>
    1bf9:	83 c4 10             	add    $0x10,%esp
    1bfc:	83 ec 0c             	sub    $0xc,%esp
    1bff:	50                   	push   %eax
    1c00:	e8 19 24 00 00       	call   401e <close>
    1c05:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c08:	83 ec 08             	sub    $0x8,%esp
    1c0b:	6a 00                	push   $0x0
    1c0d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c10:	50                   	push   %eax
    1c11:	e8 20 24 00 00       	call   4036 <open>
    1c16:	83 c4 10             	add    $0x10,%esp
    1c19:	83 ec 0c             	sub    $0xc,%esp
    1c1c:	50                   	push   %eax
    1c1d:	e8 fc 23 00 00       	call   401e <close>
    1c22:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c25:	83 ec 08             	sub    $0x8,%esp
    1c28:	6a 00                	push   $0x0
    1c2a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c2d:	50                   	push   %eax
    1c2e:	e8 03 24 00 00       	call   4036 <open>
    1c33:	83 c4 10             	add    $0x10,%esp
    1c36:	83 ec 0c             	sub    $0xc,%esp
    1c39:	50                   	push   %eax
    1c3a:	e8 df 23 00 00       	call   401e <close>
    1c3f:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c42:	83 ec 08             	sub    $0x8,%esp
    1c45:	6a 00                	push   $0x0
    1c47:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c4a:	50                   	push   %eax
    1c4b:	e8 e6 23 00 00       	call   4036 <open>
    1c50:	83 c4 10             	add    $0x10,%esp
    1c53:	83 ec 0c             	sub    $0xc,%esp
    1c56:	50                   	push   %eax
    1c57:	e8 c2 23 00 00       	call   401e <close>
    1c5c:	83 c4 10             	add    $0x10,%esp
    1c5f:	eb 3c                	jmp    1c9d <concreate+0x37d>
    } else {
      unlink(file);
    1c61:	83 ec 0c             	sub    $0xc,%esp
    1c64:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c67:	50                   	push   %eax
    1c68:	e8 d9 23 00 00       	call   4046 <unlink>
    1c6d:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c70:	83 ec 0c             	sub    $0xc,%esp
    1c73:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c76:	50                   	push   %eax
    1c77:	e8 ca 23 00 00       	call   4046 <unlink>
    1c7c:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c7f:	83 ec 0c             	sub    $0xc,%esp
    1c82:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c85:	50                   	push   %eax
    1c86:	e8 bb 23 00 00       	call   4046 <unlink>
    1c8b:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c8e:	83 ec 0c             	sub    $0xc,%esp
    1c91:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c94:	50                   	push   %eax
    1c95:	e8 ac 23 00 00       	call   4046 <unlink>
    1c9a:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1c9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1ca1:	75 05                	jne    1ca8 <concreate+0x388>
      exit();
    1ca3:	e8 4e 23 00 00       	call   3ff6 <exit>
    else
      wait();
    1ca8:	e8 51 23 00 00       	call   3ffe <wait>
  for(i = 0; i < 40; i++){
    1cad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cb1:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1cb5:	0f 8e b1 fe ff ff    	jle    1b6c <concreate+0x24c>
  }

  printf(1, "concreate ok\n");
    1cbb:	83 ec 08             	sub    $0x8,%esp
    1cbe:	68 6d 4e 00 00       	push   $0x4e6d
    1cc3:	6a 01                	push   $0x1
    1cc5:	e8 9f 24 00 00       	call   4169 <printf>
    1cca:	83 c4 10             	add    $0x10,%esp
}
    1ccd:	90                   	nop
    1cce:	c9                   	leave  
    1ccf:	c3                   	ret    

00001cd0 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cd0:	55                   	push   %ebp
    1cd1:	89 e5                	mov    %esp,%ebp
    1cd3:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cd6:	83 ec 08             	sub    $0x8,%esp
    1cd9:	68 7b 4e 00 00       	push   $0x4e7b
    1cde:	6a 01                	push   $0x1
    1ce0:	e8 84 24 00 00       	call   4169 <printf>
    1ce5:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1ce8:	83 ec 0c             	sub    $0xc,%esp
    1ceb:	68 f7 49 00 00       	push   $0x49f7
    1cf0:	e8 51 23 00 00       	call   4046 <unlink>
    1cf5:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1cf8:	e8 f1 22 00 00       	call   3fee <fork>
    1cfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d04:	79 17                	jns    1d1d <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d06:	83 ec 08             	sub    $0x8,%esp
    1d09:	68 c1 45 00 00       	push   $0x45c1
    1d0e:	6a 01                	push   $0x1
    1d10:	e8 54 24 00 00       	call   4169 <printf>
    1d15:	83 c4 10             	add    $0x10,%esp
    exit();
    1d18:	e8 d9 22 00 00       	call   3ff6 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d21:	74 07                	je     1d2a <linkunlink+0x5a>
    1d23:	b8 01 00 00 00       	mov    $0x1,%eax
    1d28:	eb 05                	jmp    1d2f <linkunlink+0x5f>
    1d2a:	b8 61 00 00 00       	mov    $0x61,%eax
    1d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d39:	e9 9a 00 00 00       	jmp    1dd8 <linkunlink+0x108>
    x = x * 1103515245 + 12345;
    1d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d41:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d47:	05 39 30 00 00       	add    $0x3039,%eax
    1d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d4f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d52:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d57:	89 c8                	mov    %ecx,%eax
    1d59:	f7 e2                	mul    %edx
    1d5b:	89 d0                	mov    %edx,%eax
    1d5d:	d1 e8                	shr    %eax
    1d5f:	89 c2                	mov    %eax,%edx
    1d61:	01 d2                	add    %edx,%edx
    1d63:	01 c2                	add    %eax,%edx
    1d65:	89 c8                	mov    %ecx,%eax
    1d67:	29 d0                	sub    %edx,%eax
    1d69:	85 c0                	test   %eax,%eax
    1d6b:	75 23                	jne    1d90 <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    1d6d:	83 ec 08             	sub    $0x8,%esp
    1d70:	68 02 02 00 00       	push   $0x202
    1d75:	68 f7 49 00 00       	push   $0x49f7
    1d7a:	e8 b7 22 00 00       	call   4036 <open>
    1d7f:	83 c4 10             	add    $0x10,%esp
    1d82:	83 ec 0c             	sub    $0xc,%esp
    1d85:	50                   	push   %eax
    1d86:	e8 93 22 00 00       	call   401e <close>
    1d8b:	83 c4 10             	add    $0x10,%esp
    1d8e:	eb 44                	jmp    1dd4 <linkunlink+0x104>
    } else if((x % 3) == 1){
    1d90:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d93:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d98:	89 c8                	mov    %ecx,%eax
    1d9a:	f7 e2                	mul    %edx
    1d9c:	d1 ea                	shr    %edx
    1d9e:	89 d0                	mov    %edx,%eax
    1da0:	01 c0                	add    %eax,%eax
    1da2:	01 d0                	add    %edx,%eax
    1da4:	29 c1                	sub    %eax,%ecx
    1da6:	89 ca                	mov    %ecx,%edx
    1da8:	83 fa 01             	cmp    $0x1,%edx
    1dab:	75 17                	jne    1dc4 <linkunlink+0xf4>
      link("cat", "x");
    1dad:	83 ec 08             	sub    $0x8,%esp
    1db0:	68 f7 49 00 00       	push   $0x49f7
    1db5:	68 8c 4e 00 00       	push   $0x4e8c
    1dba:	e8 97 22 00 00       	call   4056 <link>
    1dbf:	83 c4 10             	add    $0x10,%esp
    1dc2:	eb 10                	jmp    1dd4 <linkunlink+0x104>
    } else {
      unlink("x");
    1dc4:	83 ec 0c             	sub    $0xc,%esp
    1dc7:	68 f7 49 00 00       	push   $0x49f7
    1dcc:	e8 75 22 00 00       	call   4046 <unlink>
    1dd1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1dd4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1dd8:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1ddc:	0f 8e 5c ff ff ff    	jle    1d3e <linkunlink+0x6e>
    }
  }

  if(pid)
    1de2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1de6:	74 07                	je     1def <linkunlink+0x11f>
    wait();
    1de8:	e8 11 22 00 00       	call   3ffe <wait>
    1ded:	eb 05                	jmp    1df4 <linkunlink+0x124>
  else
    exit();
    1def:	e8 02 22 00 00       	call   3ff6 <exit>

  printf(1, "linkunlink ok\n");
    1df4:	83 ec 08             	sub    $0x8,%esp
    1df7:	68 90 4e 00 00       	push   $0x4e90
    1dfc:	6a 01                	push   $0x1
    1dfe:	e8 66 23 00 00       	call   4169 <printf>
    1e03:	83 c4 10             	add    $0x10,%esp
}
    1e06:	90                   	nop
    1e07:	c9                   	leave  
    1e08:	c3                   	ret    

00001e09 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e09:	55                   	push   %ebp
    1e0a:	89 e5                	mov    %esp,%ebp
    1e0c:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e0f:	83 ec 08             	sub    $0x8,%esp
    1e12:	68 9f 4e 00 00       	push   $0x4e9f
    1e17:	6a 01                	push   $0x1
    1e19:	e8 4b 23 00 00       	call   4169 <printf>
    1e1e:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1e21:	83 ec 0c             	sub    $0xc,%esp
    1e24:	68 ac 4e 00 00       	push   $0x4eac
    1e29:	e8 18 22 00 00       	call   4046 <unlink>
    1e2e:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1e31:	83 ec 08             	sub    $0x8,%esp
    1e34:	68 00 02 00 00       	push   $0x200
    1e39:	68 ac 4e 00 00       	push   $0x4eac
    1e3e:	e8 f3 21 00 00       	call   4036 <open>
    1e43:	83 c4 10             	add    $0x10,%esp
    1e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e4d:	79 17                	jns    1e66 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1e4f:	83 ec 08             	sub    $0x8,%esp
    1e52:	68 af 4e 00 00       	push   $0x4eaf
    1e57:	6a 01                	push   $0x1
    1e59:	e8 0b 23 00 00       	call   4169 <printf>
    1e5e:	83 c4 10             	add    $0x10,%esp
    exit();
    1e61:	e8 90 21 00 00       	call   3ff6 <exit>
  }
  close(fd);
    1e66:	83 ec 0c             	sub    $0xc,%esp
    1e69:	ff 75 f0             	pushl  -0x10(%ebp)
    1e6c:	e8 ad 21 00 00       	call   401e <close>
    1e71:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e7b:	eb 63                	jmp    1ee0 <bigdir+0xd7>
    name[0] = 'x';
    1e7d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e84:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e87:	85 c0                	test   %eax,%eax
    1e89:	0f 48 c2             	cmovs  %edx,%eax
    1e8c:	c1 f8 06             	sar    $0x6,%eax
    1e8f:	83 c0 30             	add    $0x30,%eax
    1e92:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e98:	99                   	cltd   
    1e99:	c1 ea 1a             	shr    $0x1a,%edx
    1e9c:	01 d0                	add    %edx,%eax
    1e9e:	83 e0 3f             	and    $0x3f,%eax
    1ea1:	29 d0                	sub    %edx,%eax
    1ea3:	83 c0 30             	add    $0x30,%eax
    1ea6:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1ea9:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1ead:	83 ec 08             	sub    $0x8,%esp
    1eb0:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1eb3:	50                   	push   %eax
    1eb4:	68 ac 4e 00 00       	push   $0x4eac
    1eb9:	e8 98 21 00 00       	call   4056 <link>
    1ebe:	83 c4 10             	add    $0x10,%esp
    1ec1:	85 c0                	test   %eax,%eax
    1ec3:	74 17                	je     1edc <bigdir+0xd3>
      printf(1, "bigdir link failed\n");
    1ec5:	83 ec 08             	sub    $0x8,%esp
    1ec8:	68 c5 4e 00 00       	push   $0x4ec5
    1ecd:	6a 01                	push   $0x1
    1ecf:	e8 95 22 00 00       	call   4169 <printf>
    1ed4:	83 c4 10             	add    $0x10,%esp
      exit();
    1ed7:	e8 1a 21 00 00       	call   3ff6 <exit>
  for(i = 0; i < 500; i++){
    1edc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ee0:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ee7:	7e 94                	jle    1e7d <bigdir+0x74>
    }
  }

  unlink("bd");
    1ee9:	83 ec 0c             	sub    $0xc,%esp
    1eec:	68 ac 4e 00 00       	push   $0x4eac
    1ef1:	e8 50 21 00 00       	call   4046 <unlink>
    1ef6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1ef9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f00:	eb 5e                	jmp    1f60 <bigdir+0x157>
    name[0] = 'x';
    1f02:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f09:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f0c:	85 c0                	test   %eax,%eax
    1f0e:	0f 48 c2             	cmovs  %edx,%eax
    1f11:	c1 f8 06             	sar    $0x6,%eax
    1f14:	83 c0 30             	add    $0x30,%eax
    1f17:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f1d:	99                   	cltd   
    1f1e:	c1 ea 1a             	shr    $0x1a,%edx
    1f21:	01 d0                	add    %edx,%eax
    1f23:	83 e0 3f             	and    $0x3f,%eax
    1f26:	29 d0                	sub    %edx,%eax
    1f28:	83 c0 30             	add    $0x30,%eax
    1f2b:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f2e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f32:	83 ec 0c             	sub    $0xc,%esp
    1f35:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f38:	50                   	push   %eax
    1f39:	e8 08 21 00 00       	call   4046 <unlink>
    1f3e:	83 c4 10             	add    $0x10,%esp
    1f41:	85 c0                	test   %eax,%eax
    1f43:	74 17                	je     1f5c <bigdir+0x153>
      printf(1, "bigdir unlink failed");
    1f45:	83 ec 08             	sub    $0x8,%esp
    1f48:	68 d9 4e 00 00       	push   $0x4ed9
    1f4d:	6a 01                	push   $0x1
    1f4f:	e8 15 22 00 00       	call   4169 <printf>
    1f54:	83 c4 10             	add    $0x10,%esp
      exit();
    1f57:	e8 9a 20 00 00       	call   3ff6 <exit>
  for(i = 0; i < 500; i++){
    1f5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f60:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f67:	7e 99                	jle    1f02 <bigdir+0xf9>
    }
  }

  printf(1, "bigdir ok\n");
    1f69:	83 ec 08             	sub    $0x8,%esp
    1f6c:	68 ee 4e 00 00       	push   $0x4eee
    1f71:	6a 01                	push   $0x1
    1f73:	e8 f1 21 00 00       	call   4169 <printf>
    1f78:	83 c4 10             	add    $0x10,%esp
}
    1f7b:	90                   	nop
    1f7c:	c9                   	leave  
    1f7d:	c3                   	ret    

00001f7e <subdir>:

void
subdir(void)
{
    1f7e:	55                   	push   %ebp
    1f7f:	89 e5                	mov    %esp,%ebp
    1f81:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f84:	83 ec 08             	sub    $0x8,%esp
    1f87:	68 f9 4e 00 00       	push   $0x4ef9
    1f8c:	6a 01                	push   $0x1
    1f8e:	e8 d6 21 00 00       	call   4169 <printf>
    1f93:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1f96:	83 ec 0c             	sub    $0xc,%esp
    1f99:	68 06 4f 00 00       	push   $0x4f06
    1f9e:	e8 a3 20 00 00       	call   4046 <unlink>
    1fa3:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1fa6:	83 ec 0c             	sub    $0xc,%esp
    1fa9:	68 09 4f 00 00       	push   $0x4f09
    1fae:	e8 ab 20 00 00       	call   405e <mkdir>
    1fb3:	83 c4 10             	add    $0x10,%esp
    1fb6:	85 c0                	test   %eax,%eax
    1fb8:	74 17                	je     1fd1 <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1fba:	83 ec 08             	sub    $0x8,%esp
    1fbd:	68 0c 4f 00 00       	push   $0x4f0c
    1fc2:	6a 01                	push   $0x1
    1fc4:	e8 a0 21 00 00       	call   4169 <printf>
    1fc9:	83 c4 10             	add    $0x10,%esp
    exit();
    1fcc:	e8 25 20 00 00       	call   3ff6 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fd1:	83 ec 08             	sub    $0x8,%esp
    1fd4:	68 02 02 00 00       	push   $0x202
    1fd9:	68 24 4f 00 00       	push   $0x4f24
    1fde:	e8 53 20 00 00       	call   4036 <open>
    1fe3:	83 c4 10             	add    $0x10,%esp
    1fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fed:	79 17                	jns    2006 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1fef:	83 ec 08             	sub    $0x8,%esp
    1ff2:	68 2a 4f 00 00       	push   $0x4f2a
    1ff7:	6a 01                	push   $0x1
    1ff9:	e8 6b 21 00 00       	call   4169 <printf>
    1ffe:	83 c4 10             	add    $0x10,%esp
    exit();
    2001:	e8 f0 1f 00 00       	call   3ff6 <exit>
  }
  write(fd, "ff", 2);
    2006:	83 ec 04             	sub    $0x4,%esp
    2009:	6a 02                	push   $0x2
    200b:	68 06 4f 00 00       	push   $0x4f06
    2010:	ff 75 f4             	pushl  -0xc(%ebp)
    2013:	e8 fe 1f 00 00       	call   4016 <write>
    2018:	83 c4 10             	add    $0x10,%esp
  close(fd);
    201b:	83 ec 0c             	sub    $0xc,%esp
    201e:	ff 75 f4             	pushl  -0xc(%ebp)
    2021:	e8 f8 1f 00 00       	call   401e <close>
    2026:	83 c4 10             	add    $0x10,%esp

  if(unlink("dd") >= 0){
    2029:	83 ec 0c             	sub    $0xc,%esp
    202c:	68 09 4f 00 00       	push   $0x4f09
    2031:	e8 10 20 00 00       	call   4046 <unlink>
    2036:	83 c4 10             	add    $0x10,%esp
    2039:	85 c0                	test   %eax,%eax
    203b:	78 17                	js     2054 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    203d:	83 ec 08             	sub    $0x8,%esp
    2040:	68 40 4f 00 00       	push   $0x4f40
    2045:	6a 01                	push   $0x1
    2047:	e8 1d 21 00 00       	call   4169 <printf>
    204c:	83 c4 10             	add    $0x10,%esp
    exit();
    204f:	e8 a2 1f 00 00       	call   3ff6 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2054:	83 ec 0c             	sub    $0xc,%esp
    2057:	68 66 4f 00 00       	push   $0x4f66
    205c:	e8 fd 1f 00 00       	call   405e <mkdir>
    2061:	83 c4 10             	add    $0x10,%esp
    2064:	85 c0                	test   %eax,%eax
    2066:	74 17                	je     207f <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    2068:	83 ec 08             	sub    $0x8,%esp
    206b:	68 6d 4f 00 00       	push   $0x4f6d
    2070:	6a 01                	push   $0x1
    2072:	e8 f2 20 00 00       	call   4169 <printf>
    2077:	83 c4 10             	add    $0x10,%esp
    exit();
    207a:	e8 77 1f 00 00       	call   3ff6 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    207f:	83 ec 08             	sub    $0x8,%esp
    2082:	68 02 02 00 00       	push   $0x202
    2087:	68 88 4f 00 00       	push   $0x4f88
    208c:	e8 a5 1f 00 00       	call   4036 <open>
    2091:	83 c4 10             	add    $0x10,%esp
    2094:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    209b:	79 17                	jns    20b4 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    209d:	83 ec 08             	sub    $0x8,%esp
    20a0:	68 91 4f 00 00       	push   $0x4f91
    20a5:	6a 01                	push   $0x1
    20a7:	e8 bd 20 00 00       	call   4169 <printf>
    20ac:	83 c4 10             	add    $0x10,%esp
    exit();
    20af:	e8 42 1f 00 00       	call   3ff6 <exit>
  }
  write(fd, "FF", 2);
    20b4:	83 ec 04             	sub    $0x4,%esp
    20b7:	6a 02                	push   $0x2
    20b9:	68 a9 4f 00 00       	push   $0x4fa9
    20be:	ff 75 f4             	pushl  -0xc(%ebp)
    20c1:	e8 50 1f 00 00       	call   4016 <write>
    20c6:	83 c4 10             	add    $0x10,%esp
  close(fd);
    20c9:	83 ec 0c             	sub    $0xc,%esp
    20cc:	ff 75 f4             	pushl  -0xc(%ebp)
    20cf:	e8 4a 1f 00 00       	call   401e <close>
    20d4:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    20d7:	83 ec 08             	sub    $0x8,%esp
    20da:	6a 00                	push   $0x0
    20dc:	68 ac 4f 00 00       	push   $0x4fac
    20e1:	e8 50 1f 00 00       	call   4036 <open>
    20e6:	83 c4 10             	add    $0x10,%esp
    20e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20f0:	79 17                	jns    2109 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    20f2:	83 ec 08             	sub    $0x8,%esp
    20f5:	68 b8 4f 00 00       	push   $0x4fb8
    20fa:	6a 01                	push   $0x1
    20fc:	e8 68 20 00 00       	call   4169 <printf>
    2101:	83 c4 10             	add    $0x10,%esp
    exit();
    2104:	e8 ed 1e 00 00       	call   3ff6 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2109:	83 ec 04             	sub    $0x4,%esp
    210c:	68 00 20 00 00       	push   $0x2000
    2111:	68 60 8c 00 00       	push   $0x8c60
    2116:	ff 75 f4             	pushl  -0xc(%ebp)
    2119:	e8 f0 1e 00 00       	call   400e <read>
    211e:	83 c4 10             	add    $0x10,%esp
    2121:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2124:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2128:	75 0b                	jne    2135 <subdir+0x1b7>
    212a:	0f b6 05 60 8c 00 00 	movzbl 0x8c60,%eax
    2131:	3c 66                	cmp    $0x66,%al
    2133:	74 17                	je     214c <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    2135:	83 ec 08             	sub    $0x8,%esp
    2138:	68 d1 4f 00 00       	push   $0x4fd1
    213d:	6a 01                	push   $0x1
    213f:	e8 25 20 00 00       	call   4169 <printf>
    2144:	83 c4 10             	add    $0x10,%esp
    exit();
    2147:	e8 aa 1e 00 00       	call   3ff6 <exit>
  }
  close(fd);
    214c:	83 ec 0c             	sub    $0xc,%esp
    214f:	ff 75 f4             	pushl  -0xc(%ebp)
    2152:	e8 c7 1e 00 00       	call   401e <close>
    2157:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    215a:	83 ec 08             	sub    $0x8,%esp
    215d:	68 ec 4f 00 00       	push   $0x4fec
    2162:	68 88 4f 00 00       	push   $0x4f88
    2167:	e8 ea 1e 00 00       	call   4056 <link>
    216c:	83 c4 10             	add    $0x10,%esp
    216f:	85 c0                	test   %eax,%eax
    2171:	74 17                	je     218a <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2173:	83 ec 08             	sub    $0x8,%esp
    2176:	68 f8 4f 00 00       	push   $0x4ff8
    217b:	6a 01                	push   $0x1
    217d:	e8 e7 1f 00 00       	call   4169 <printf>
    2182:	83 c4 10             	add    $0x10,%esp
    exit();
    2185:	e8 6c 1e 00 00       	call   3ff6 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    218a:	83 ec 0c             	sub    $0xc,%esp
    218d:	68 88 4f 00 00       	push   $0x4f88
    2192:	e8 af 1e 00 00       	call   4046 <unlink>
    2197:	83 c4 10             	add    $0x10,%esp
    219a:	85 c0                	test   %eax,%eax
    219c:	74 17                	je     21b5 <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    219e:	83 ec 08             	sub    $0x8,%esp
    21a1:	68 19 50 00 00       	push   $0x5019
    21a6:	6a 01                	push   $0x1
    21a8:	e8 bc 1f 00 00       	call   4169 <printf>
    21ad:	83 c4 10             	add    $0x10,%esp
    exit();
    21b0:	e8 41 1e 00 00       	call   3ff6 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21b5:	83 ec 08             	sub    $0x8,%esp
    21b8:	6a 00                	push   $0x0
    21ba:	68 88 4f 00 00       	push   $0x4f88
    21bf:	e8 72 1e 00 00       	call   4036 <open>
    21c4:	83 c4 10             	add    $0x10,%esp
    21c7:	85 c0                	test   %eax,%eax
    21c9:	78 17                	js     21e2 <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21cb:	83 ec 08             	sub    $0x8,%esp
    21ce:	68 34 50 00 00       	push   $0x5034
    21d3:	6a 01                	push   $0x1
    21d5:	e8 8f 1f 00 00       	call   4169 <printf>
    21da:	83 c4 10             	add    $0x10,%esp
    exit();
    21dd:	e8 14 1e 00 00       	call   3ff6 <exit>
  }

  if(chdir("dd") != 0){
    21e2:	83 ec 0c             	sub    $0xc,%esp
    21e5:	68 09 4f 00 00       	push   $0x4f09
    21ea:	e8 77 1e 00 00       	call   4066 <chdir>
    21ef:	83 c4 10             	add    $0x10,%esp
    21f2:	85 c0                	test   %eax,%eax
    21f4:	74 17                	je     220d <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    21f6:	83 ec 08             	sub    $0x8,%esp
    21f9:	68 58 50 00 00       	push   $0x5058
    21fe:	6a 01                	push   $0x1
    2200:	e8 64 1f 00 00       	call   4169 <printf>
    2205:	83 c4 10             	add    $0x10,%esp
    exit();
    2208:	e8 e9 1d 00 00       	call   3ff6 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    220d:	83 ec 0c             	sub    $0xc,%esp
    2210:	68 69 50 00 00       	push   $0x5069
    2215:	e8 4c 1e 00 00       	call   4066 <chdir>
    221a:	83 c4 10             	add    $0x10,%esp
    221d:	85 c0                	test   %eax,%eax
    221f:	74 17                	je     2238 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    2221:	83 ec 08             	sub    $0x8,%esp
    2224:	68 75 50 00 00       	push   $0x5075
    2229:	6a 01                	push   $0x1
    222b:	e8 39 1f 00 00       	call   4169 <printf>
    2230:	83 c4 10             	add    $0x10,%esp
    exit();
    2233:	e8 be 1d 00 00       	call   3ff6 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2238:	83 ec 0c             	sub    $0xc,%esp
    223b:	68 8f 50 00 00       	push   $0x508f
    2240:	e8 21 1e 00 00       	call   4066 <chdir>
    2245:	83 c4 10             	add    $0x10,%esp
    2248:	85 c0                	test   %eax,%eax
    224a:	74 17                	je     2263 <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    224c:	83 ec 08             	sub    $0x8,%esp
    224f:	68 75 50 00 00       	push   $0x5075
    2254:	6a 01                	push   $0x1
    2256:	e8 0e 1f 00 00       	call   4169 <printf>
    225b:	83 c4 10             	add    $0x10,%esp
    exit();
    225e:	e8 93 1d 00 00       	call   3ff6 <exit>
  }
  if(chdir("./..") != 0){
    2263:	83 ec 0c             	sub    $0xc,%esp
    2266:	68 9e 50 00 00       	push   $0x509e
    226b:	e8 f6 1d 00 00       	call   4066 <chdir>
    2270:	83 c4 10             	add    $0x10,%esp
    2273:	85 c0                	test   %eax,%eax
    2275:	74 17                	je     228e <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    2277:	83 ec 08             	sub    $0x8,%esp
    227a:	68 a3 50 00 00       	push   $0x50a3
    227f:	6a 01                	push   $0x1
    2281:	e8 e3 1e 00 00       	call   4169 <printf>
    2286:	83 c4 10             	add    $0x10,%esp
    exit();
    2289:	e8 68 1d 00 00       	call   3ff6 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    228e:	83 ec 08             	sub    $0x8,%esp
    2291:	6a 00                	push   $0x0
    2293:	68 ec 4f 00 00       	push   $0x4fec
    2298:	e8 99 1d 00 00       	call   4036 <open>
    229d:	83 c4 10             	add    $0x10,%esp
    22a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22a7:	79 17                	jns    22c0 <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    22a9:	83 ec 08             	sub    $0x8,%esp
    22ac:	68 b6 50 00 00       	push   $0x50b6
    22b1:	6a 01                	push   $0x1
    22b3:	e8 b1 1e 00 00       	call   4169 <printf>
    22b8:	83 c4 10             	add    $0x10,%esp
    exit();
    22bb:	e8 36 1d 00 00       	call   3ff6 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22c0:	83 ec 04             	sub    $0x4,%esp
    22c3:	68 00 20 00 00       	push   $0x2000
    22c8:	68 60 8c 00 00       	push   $0x8c60
    22cd:	ff 75 f4             	pushl  -0xc(%ebp)
    22d0:	e8 39 1d 00 00       	call   400e <read>
    22d5:	83 c4 10             	add    $0x10,%esp
    22d8:	83 f8 02             	cmp    $0x2,%eax
    22db:	74 17                	je     22f4 <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    22dd:	83 ec 08             	sub    $0x8,%esp
    22e0:	68 ce 50 00 00       	push   $0x50ce
    22e5:	6a 01                	push   $0x1
    22e7:	e8 7d 1e 00 00       	call   4169 <printf>
    22ec:	83 c4 10             	add    $0x10,%esp
    exit();
    22ef:	e8 02 1d 00 00       	call   3ff6 <exit>
  }
  close(fd);
    22f4:	83 ec 0c             	sub    $0xc,%esp
    22f7:	ff 75 f4             	pushl  -0xc(%ebp)
    22fa:	e8 1f 1d 00 00       	call   401e <close>
    22ff:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2302:	83 ec 08             	sub    $0x8,%esp
    2305:	6a 00                	push   $0x0
    2307:	68 88 4f 00 00       	push   $0x4f88
    230c:	e8 25 1d 00 00       	call   4036 <open>
    2311:	83 c4 10             	add    $0x10,%esp
    2314:	85 c0                	test   %eax,%eax
    2316:	78 17                	js     232f <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2318:	83 ec 08             	sub    $0x8,%esp
    231b:	68 ec 50 00 00       	push   $0x50ec
    2320:	6a 01                	push   $0x1
    2322:	e8 42 1e 00 00       	call   4169 <printf>
    2327:	83 c4 10             	add    $0x10,%esp
    exit();
    232a:	e8 c7 1c 00 00       	call   3ff6 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    232f:	83 ec 08             	sub    $0x8,%esp
    2332:	68 02 02 00 00       	push   $0x202
    2337:	68 11 51 00 00       	push   $0x5111
    233c:	e8 f5 1c 00 00       	call   4036 <open>
    2341:	83 c4 10             	add    $0x10,%esp
    2344:	85 c0                	test   %eax,%eax
    2346:	78 17                	js     235f <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    2348:	83 ec 08             	sub    $0x8,%esp
    234b:	68 1a 51 00 00       	push   $0x511a
    2350:	6a 01                	push   $0x1
    2352:	e8 12 1e 00 00       	call   4169 <printf>
    2357:	83 c4 10             	add    $0x10,%esp
    exit();
    235a:	e8 97 1c 00 00       	call   3ff6 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    235f:	83 ec 08             	sub    $0x8,%esp
    2362:	68 02 02 00 00       	push   $0x202
    2367:	68 36 51 00 00       	push   $0x5136
    236c:	e8 c5 1c 00 00       	call   4036 <open>
    2371:	83 c4 10             	add    $0x10,%esp
    2374:	85 c0                	test   %eax,%eax
    2376:	78 17                	js     238f <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    2378:	83 ec 08             	sub    $0x8,%esp
    237b:	68 3f 51 00 00       	push   $0x513f
    2380:	6a 01                	push   $0x1
    2382:	e8 e2 1d 00 00       	call   4169 <printf>
    2387:	83 c4 10             	add    $0x10,%esp
    exit();
    238a:	e8 67 1c 00 00       	call   3ff6 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    238f:	83 ec 08             	sub    $0x8,%esp
    2392:	68 00 02 00 00       	push   $0x200
    2397:	68 09 4f 00 00       	push   $0x4f09
    239c:	e8 95 1c 00 00       	call   4036 <open>
    23a1:	83 c4 10             	add    $0x10,%esp
    23a4:	85 c0                	test   %eax,%eax
    23a6:	78 17                	js     23bf <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    23a8:	83 ec 08             	sub    $0x8,%esp
    23ab:	68 5b 51 00 00       	push   $0x515b
    23b0:	6a 01                	push   $0x1
    23b2:	e8 b2 1d 00 00       	call   4169 <printf>
    23b7:	83 c4 10             	add    $0x10,%esp
    exit();
    23ba:	e8 37 1c 00 00       	call   3ff6 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23bf:	83 ec 08             	sub    $0x8,%esp
    23c2:	6a 02                	push   $0x2
    23c4:	68 09 4f 00 00       	push   $0x4f09
    23c9:	e8 68 1c 00 00       	call   4036 <open>
    23ce:	83 c4 10             	add    $0x10,%esp
    23d1:	85 c0                	test   %eax,%eax
    23d3:	78 17                	js     23ec <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    23d5:	83 ec 08             	sub    $0x8,%esp
    23d8:	68 71 51 00 00       	push   $0x5171
    23dd:	6a 01                	push   $0x1
    23df:	e8 85 1d 00 00       	call   4169 <printf>
    23e4:	83 c4 10             	add    $0x10,%esp
    exit();
    23e7:	e8 0a 1c 00 00       	call   3ff6 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23ec:	83 ec 08             	sub    $0x8,%esp
    23ef:	6a 01                	push   $0x1
    23f1:	68 09 4f 00 00       	push   $0x4f09
    23f6:	e8 3b 1c 00 00       	call   4036 <open>
    23fb:	83 c4 10             	add    $0x10,%esp
    23fe:	85 c0                	test   %eax,%eax
    2400:	78 17                	js     2419 <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    2402:	83 ec 08             	sub    $0x8,%esp
    2405:	68 8a 51 00 00       	push   $0x518a
    240a:	6a 01                	push   $0x1
    240c:	e8 58 1d 00 00       	call   4169 <printf>
    2411:	83 c4 10             	add    $0x10,%esp
    exit();
    2414:	e8 dd 1b 00 00       	call   3ff6 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2419:	83 ec 08             	sub    $0x8,%esp
    241c:	68 a5 51 00 00       	push   $0x51a5
    2421:	68 11 51 00 00       	push   $0x5111
    2426:	e8 2b 1c 00 00       	call   4056 <link>
    242b:	83 c4 10             	add    $0x10,%esp
    242e:	85 c0                	test   %eax,%eax
    2430:	75 17                	jne    2449 <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2432:	83 ec 08             	sub    $0x8,%esp
    2435:	68 b0 51 00 00       	push   $0x51b0
    243a:	6a 01                	push   $0x1
    243c:	e8 28 1d 00 00       	call   4169 <printf>
    2441:	83 c4 10             	add    $0x10,%esp
    exit();
    2444:	e8 ad 1b 00 00       	call   3ff6 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2449:	83 ec 08             	sub    $0x8,%esp
    244c:	68 a5 51 00 00       	push   $0x51a5
    2451:	68 36 51 00 00       	push   $0x5136
    2456:	e8 fb 1b 00 00       	call   4056 <link>
    245b:	83 c4 10             	add    $0x10,%esp
    245e:	85 c0                	test   %eax,%eax
    2460:	75 17                	jne    2479 <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2462:	83 ec 08             	sub    $0x8,%esp
    2465:	68 d4 51 00 00       	push   $0x51d4
    246a:	6a 01                	push   $0x1
    246c:	e8 f8 1c 00 00       	call   4169 <printf>
    2471:	83 c4 10             	add    $0x10,%esp
    exit();
    2474:	e8 7d 1b 00 00       	call   3ff6 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2479:	83 ec 08             	sub    $0x8,%esp
    247c:	68 ec 4f 00 00       	push   $0x4fec
    2481:	68 24 4f 00 00       	push   $0x4f24
    2486:	e8 cb 1b 00 00       	call   4056 <link>
    248b:	83 c4 10             	add    $0x10,%esp
    248e:	85 c0                	test   %eax,%eax
    2490:	75 17                	jne    24a9 <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2492:	83 ec 08             	sub    $0x8,%esp
    2495:	68 f8 51 00 00       	push   $0x51f8
    249a:	6a 01                	push   $0x1
    249c:	e8 c8 1c 00 00       	call   4169 <printf>
    24a1:	83 c4 10             	add    $0x10,%esp
    exit();
    24a4:	e8 4d 1b 00 00       	call   3ff6 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24a9:	83 ec 0c             	sub    $0xc,%esp
    24ac:	68 11 51 00 00       	push   $0x5111
    24b1:	e8 a8 1b 00 00       	call   405e <mkdir>
    24b6:	83 c4 10             	add    $0x10,%esp
    24b9:	85 c0                	test   %eax,%eax
    24bb:	75 17                	jne    24d4 <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24bd:	83 ec 08             	sub    $0x8,%esp
    24c0:	68 1a 52 00 00       	push   $0x521a
    24c5:	6a 01                	push   $0x1
    24c7:	e8 9d 1c 00 00       	call   4169 <printf>
    24cc:	83 c4 10             	add    $0x10,%esp
    exit();
    24cf:	e8 22 1b 00 00       	call   3ff6 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24d4:	83 ec 0c             	sub    $0xc,%esp
    24d7:	68 36 51 00 00       	push   $0x5136
    24dc:	e8 7d 1b 00 00       	call   405e <mkdir>
    24e1:	83 c4 10             	add    $0x10,%esp
    24e4:	85 c0                	test   %eax,%eax
    24e6:	75 17                	jne    24ff <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24e8:	83 ec 08             	sub    $0x8,%esp
    24eb:	68 35 52 00 00       	push   $0x5235
    24f0:	6a 01                	push   $0x1
    24f2:	e8 72 1c 00 00       	call   4169 <printf>
    24f7:	83 c4 10             	add    $0x10,%esp
    exit();
    24fa:	e8 f7 1a 00 00       	call   3ff6 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24ff:	83 ec 0c             	sub    $0xc,%esp
    2502:	68 ec 4f 00 00       	push   $0x4fec
    2507:	e8 52 1b 00 00       	call   405e <mkdir>
    250c:	83 c4 10             	add    $0x10,%esp
    250f:	85 c0                	test   %eax,%eax
    2511:	75 17                	jne    252a <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2513:	83 ec 08             	sub    $0x8,%esp
    2516:	68 50 52 00 00       	push   $0x5250
    251b:	6a 01                	push   $0x1
    251d:	e8 47 1c 00 00       	call   4169 <printf>
    2522:	83 c4 10             	add    $0x10,%esp
    exit();
    2525:	e8 cc 1a 00 00       	call   3ff6 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    252a:	83 ec 0c             	sub    $0xc,%esp
    252d:	68 36 51 00 00       	push   $0x5136
    2532:	e8 0f 1b 00 00       	call   4046 <unlink>
    2537:	83 c4 10             	add    $0x10,%esp
    253a:	85 c0                	test   %eax,%eax
    253c:	75 17                	jne    2555 <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    253e:	83 ec 08             	sub    $0x8,%esp
    2541:	68 6d 52 00 00       	push   $0x526d
    2546:	6a 01                	push   $0x1
    2548:	e8 1c 1c 00 00       	call   4169 <printf>
    254d:	83 c4 10             	add    $0x10,%esp
    exit();
    2550:	e8 a1 1a 00 00       	call   3ff6 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2555:	83 ec 0c             	sub    $0xc,%esp
    2558:	68 11 51 00 00       	push   $0x5111
    255d:	e8 e4 1a 00 00       	call   4046 <unlink>
    2562:	83 c4 10             	add    $0x10,%esp
    2565:	85 c0                	test   %eax,%eax
    2567:	75 17                	jne    2580 <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2569:	83 ec 08             	sub    $0x8,%esp
    256c:	68 89 52 00 00       	push   $0x5289
    2571:	6a 01                	push   $0x1
    2573:	e8 f1 1b 00 00       	call   4169 <printf>
    2578:	83 c4 10             	add    $0x10,%esp
    exit();
    257b:	e8 76 1a 00 00       	call   3ff6 <exit>
  }
  if(chdir("dd/ff") == 0){
    2580:	83 ec 0c             	sub    $0xc,%esp
    2583:	68 24 4f 00 00       	push   $0x4f24
    2588:	e8 d9 1a 00 00       	call   4066 <chdir>
    258d:	83 c4 10             	add    $0x10,%esp
    2590:	85 c0                	test   %eax,%eax
    2592:	75 17                	jne    25ab <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    2594:	83 ec 08             	sub    $0x8,%esp
    2597:	68 a5 52 00 00       	push   $0x52a5
    259c:	6a 01                	push   $0x1
    259e:	e8 c6 1b 00 00       	call   4169 <printf>
    25a3:	83 c4 10             	add    $0x10,%esp
    exit();
    25a6:	e8 4b 1a 00 00       	call   3ff6 <exit>
  }
  if(chdir("dd/xx") == 0){
    25ab:	83 ec 0c             	sub    $0xc,%esp
    25ae:	68 bd 52 00 00       	push   $0x52bd
    25b3:	e8 ae 1a 00 00       	call   4066 <chdir>
    25b8:	83 c4 10             	add    $0x10,%esp
    25bb:	85 c0                	test   %eax,%eax
    25bd:	75 17                	jne    25d6 <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    25bf:	83 ec 08             	sub    $0x8,%esp
    25c2:	68 c3 52 00 00       	push   $0x52c3
    25c7:	6a 01                	push   $0x1
    25c9:	e8 9b 1b 00 00       	call   4169 <printf>
    25ce:	83 c4 10             	add    $0x10,%esp
    exit();
    25d1:	e8 20 1a 00 00       	call   3ff6 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25d6:	83 ec 0c             	sub    $0xc,%esp
    25d9:	68 ec 4f 00 00       	push   $0x4fec
    25de:	e8 63 1a 00 00       	call   4046 <unlink>
    25e3:	83 c4 10             	add    $0x10,%esp
    25e6:	85 c0                	test   %eax,%eax
    25e8:	74 17                	je     2601 <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    25ea:	83 ec 08             	sub    $0x8,%esp
    25ed:	68 19 50 00 00       	push   $0x5019
    25f2:	6a 01                	push   $0x1
    25f4:	e8 70 1b 00 00       	call   4169 <printf>
    25f9:	83 c4 10             	add    $0x10,%esp
    exit();
    25fc:	e8 f5 19 00 00       	call   3ff6 <exit>
  }
  if(unlink("dd/ff") != 0){
    2601:	83 ec 0c             	sub    $0xc,%esp
    2604:	68 24 4f 00 00       	push   $0x4f24
    2609:	e8 38 1a 00 00       	call   4046 <unlink>
    260e:	83 c4 10             	add    $0x10,%esp
    2611:	85 c0                	test   %eax,%eax
    2613:	74 17                	je     262c <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    2615:	83 ec 08             	sub    $0x8,%esp
    2618:	68 db 52 00 00       	push   $0x52db
    261d:	6a 01                	push   $0x1
    261f:	e8 45 1b 00 00       	call   4169 <printf>
    2624:	83 c4 10             	add    $0x10,%esp
    exit();
    2627:	e8 ca 19 00 00       	call   3ff6 <exit>
  }
  if(unlink("dd") == 0){
    262c:	83 ec 0c             	sub    $0xc,%esp
    262f:	68 09 4f 00 00       	push   $0x4f09
    2634:	e8 0d 1a 00 00       	call   4046 <unlink>
    2639:	83 c4 10             	add    $0x10,%esp
    263c:	85 c0                	test   %eax,%eax
    263e:	75 17                	jne    2657 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    2640:	83 ec 08             	sub    $0x8,%esp
    2643:	68 f0 52 00 00       	push   $0x52f0
    2648:	6a 01                	push   $0x1
    264a:	e8 1a 1b 00 00       	call   4169 <printf>
    264f:	83 c4 10             	add    $0x10,%esp
    exit();
    2652:	e8 9f 19 00 00       	call   3ff6 <exit>
  }
  if(unlink("dd/dd") < 0){
    2657:	83 ec 0c             	sub    $0xc,%esp
    265a:	68 10 53 00 00       	push   $0x5310
    265f:	e8 e2 19 00 00       	call   4046 <unlink>
    2664:	83 c4 10             	add    $0x10,%esp
    2667:	85 c0                	test   %eax,%eax
    2669:	79 17                	jns    2682 <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    266b:	83 ec 08             	sub    $0x8,%esp
    266e:	68 16 53 00 00       	push   $0x5316
    2673:	6a 01                	push   $0x1
    2675:	e8 ef 1a 00 00       	call   4169 <printf>
    267a:	83 c4 10             	add    $0x10,%esp
    exit();
    267d:	e8 74 19 00 00       	call   3ff6 <exit>
  }
  if(unlink("dd") < 0){
    2682:	83 ec 0c             	sub    $0xc,%esp
    2685:	68 09 4f 00 00       	push   $0x4f09
    268a:	e8 b7 19 00 00       	call   4046 <unlink>
    268f:	83 c4 10             	add    $0x10,%esp
    2692:	85 c0                	test   %eax,%eax
    2694:	79 17                	jns    26ad <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    2696:	83 ec 08             	sub    $0x8,%esp
    2699:	68 2b 53 00 00       	push   $0x532b
    269e:	6a 01                	push   $0x1
    26a0:	e8 c4 1a 00 00       	call   4169 <printf>
    26a5:	83 c4 10             	add    $0x10,%esp
    exit();
    26a8:	e8 49 19 00 00       	call   3ff6 <exit>
  }

  printf(1, "subdir ok\n");
    26ad:	83 ec 08             	sub    $0x8,%esp
    26b0:	68 3d 53 00 00       	push   $0x533d
    26b5:	6a 01                	push   $0x1
    26b7:	e8 ad 1a 00 00       	call   4169 <printf>
    26bc:	83 c4 10             	add    $0x10,%esp
}
    26bf:	90                   	nop
    26c0:	c9                   	leave  
    26c1:	c3                   	ret    

000026c2 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26c2:	55                   	push   %ebp
    26c3:	89 e5                	mov    %esp,%ebp
    26c5:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26c8:	83 ec 08             	sub    $0x8,%esp
    26cb:	68 48 53 00 00       	push   $0x5348
    26d0:	6a 01                	push   $0x1
    26d2:	e8 92 1a 00 00       	call   4169 <printf>
    26d7:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    26da:	83 ec 0c             	sub    $0xc,%esp
    26dd:	68 57 53 00 00       	push   $0x5357
    26e2:	e8 5f 19 00 00       	call   4046 <unlink>
    26e7:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    26ea:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26f1:	e9 a8 00 00 00       	jmp    279e <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26f6:	83 ec 08             	sub    $0x8,%esp
    26f9:	68 02 02 00 00       	push   $0x202
    26fe:	68 57 53 00 00       	push   $0x5357
    2703:	e8 2e 19 00 00       	call   4036 <open>
    2708:	83 c4 10             	add    $0x10,%esp
    270b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    270e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2712:	79 17                	jns    272b <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    2714:	83 ec 08             	sub    $0x8,%esp
    2717:	68 60 53 00 00       	push   $0x5360
    271c:	6a 01                	push   $0x1
    271e:	e8 46 1a 00 00       	call   4169 <printf>
    2723:	83 c4 10             	add    $0x10,%esp
      exit();
    2726:	e8 cb 18 00 00       	call   3ff6 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    272b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2732:	eb 3f                	jmp    2773 <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    2734:	83 ec 04             	sub    $0x4,%esp
    2737:	ff 75 f4             	pushl  -0xc(%ebp)
    273a:	68 60 8c 00 00       	push   $0x8c60
    273f:	ff 75 ec             	pushl  -0x14(%ebp)
    2742:	e8 cf 18 00 00       	call   4016 <write>
    2747:	83 c4 10             	add    $0x10,%esp
    274a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    274d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2750:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2753:	74 1a                	je     276f <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2755:	ff 75 e8             	pushl  -0x18(%ebp)
    2758:	ff 75 f4             	pushl  -0xc(%ebp)
    275b:	68 78 53 00 00       	push   $0x5378
    2760:	6a 01                	push   $0x1
    2762:	e8 02 1a 00 00       	call   4169 <printf>
    2767:	83 c4 10             	add    $0x10,%esp
        exit();
    276a:	e8 87 18 00 00       	call   3ff6 <exit>
    for(i = 0; i < 2; i++){
    276f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2773:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2777:	7e bb                	jle    2734 <bigwrite+0x72>
      }
    }
    close(fd);
    2779:	83 ec 0c             	sub    $0xc,%esp
    277c:	ff 75 ec             	pushl  -0x14(%ebp)
    277f:	e8 9a 18 00 00       	call   401e <close>
    2784:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2787:	83 ec 0c             	sub    $0xc,%esp
    278a:	68 57 53 00 00       	push   $0x5357
    278f:	e8 b2 18 00 00       	call   4046 <unlink>
    2794:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2797:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    279e:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    27a5:	0f 8e 4b ff ff ff    	jle    26f6 <bigwrite+0x34>
  }

  printf(1, "bigwrite ok\n");
    27ab:	83 ec 08             	sub    $0x8,%esp
    27ae:	68 8a 53 00 00       	push   $0x538a
    27b3:	6a 01                	push   $0x1
    27b5:	e8 af 19 00 00       	call   4169 <printf>
    27ba:	83 c4 10             	add    $0x10,%esp
}
    27bd:	90                   	nop
    27be:	c9                   	leave  
    27bf:	c3                   	ret    

000027c0 <bigfile>:

void
bigfile(void)
{
    27c0:	55                   	push   %ebp
    27c1:	89 e5                	mov    %esp,%ebp
    27c3:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27c6:	83 ec 08             	sub    $0x8,%esp
    27c9:	68 97 53 00 00       	push   $0x5397
    27ce:	6a 01                	push   $0x1
    27d0:	e8 94 19 00 00       	call   4169 <printf>
    27d5:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    27d8:	83 ec 0c             	sub    $0xc,%esp
    27db:	68 a5 53 00 00       	push   $0x53a5
    27e0:	e8 61 18 00 00       	call   4046 <unlink>
    27e5:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    27e8:	83 ec 08             	sub    $0x8,%esp
    27eb:	68 02 02 00 00       	push   $0x202
    27f0:	68 a5 53 00 00       	push   $0x53a5
    27f5:	e8 3c 18 00 00       	call   4036 <open>
    27fa:	83 c4 10             	add    $0x10,%esp
    27fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2800:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2804:	79 17                	jns    281d <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    2806:	83 ec 08             	sub    $0x8,%esp
    2809:	68 ad 53 00 00       	push   $0x53ad
    280e:	6a 01                	push   $0x1
    2810:	e8 54 19 00 00       	call   4169 <printf>
    2815:	83 c4 10             	add    $0x10,%esp
    exit();
    2818:	e8 d9 17 00 00       	call   3ff6 <exit>
  }
  for(i = 0; i < 20; i++){
    281d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2824:	eb 52                	jmp    2878 <bigfile+0xb8>
    memset(buf, i, 600);
    2826:	83 ec 04             	sub    $0x4,%esp
    2829:	68 58 02 00 00       	push   $0x258
    282e:	ff 75 f4             	pushl  -0xc(%ebp)
    2831:	68 60 8c 00 00       	push   $0x8c60
    2836:	e8 20 16 00 00       	call   3e5b <memset>
    283b:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    283e:	83 ec 04             	sub    $0x4,%esp
    2841:	68 58 02 00 00       	push   $0x258
    2846:	68 60 8c 00 00       	push   $0x8c60
    284b:	ff 75 ec             	pushl  -0x14(%ebp)
    284e:	e8 c3 17 00 00       	call   4016 <write>
    2853:	83 c4 10             	add    $0x10,%esp
    2856:	3d 58 02 00 00       	cmp    $0x258,%eax
    285b:	74 17                	je     2874 <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    285d:	83 ec 08             	sub    $0x8,%esp
    2860:	68 c3 53 00 00       	push   $0x53c3
    2865:	6a 01                	push   $0x1
    2867:	e8 fd 18 00 00       	call   4169 <printf>
    286c:	83 c4 10             	add    $0x10,%esp
      exit();
    286f:	e8 82 17 00 00       	call   3ff6 <exit>
  for(i = 0; i < 20; i++){
    2874:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2878:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    287c:	7e a8                	jle    2826 <bigfile+0x66>
    }
  }
  close(fd);
    287e:	83 ec 0c             	sub    $0xc,%esp
    2881:	ff 75 ec             	pushl  -0x14(%ebp)
    2884:	e8 95 17 00 00       	call   401e <close>
    2889:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    288c:	83 ec 08             	sub    $0x8,%esp
    288f:	6a 00                	push   $0x0
    2891:	68 a5 53 00 00       	push   $0x53a5
    2896:	e8 9b 17 00 00       	call   4036 <open>
    289b:	83 c4 10             	add    $0x10,%esp
    289e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    28a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28a5:	79 17                	jns    28be <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    28a7:	83 ec 08             	sub    $0x8,%esp
    28aa:	68 d9 53 00 00       	push   $0x53d9
    28af:	6a 01                	push   $0x1
    28b1:	e8 b3 18 00 00       	call   4169 <printf>
    28b6:	83 c4 10             	add    $0x10,%esp
    exit();
    28b9:	e8 38 17 00 00       	call   3ff6 <exit>
  }
  total = 0;
    28be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28cc:	83 ec 04             	sub    $0x4,%esp
    28cf:	68 2c 01 00 00       	push   $0x12c
    28d4:	68 60 8c 00 00       	push   $0x8c60
    28d9:	ff 75 ec             	pushl  -0x14(%ebp)
    28dc:	e8 2d 17 00 00       	call   400e <read>
    28e1:	83 c4 10             	add    $0x10,%esp
    28e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28eb:	79 17                	jns    2904 <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    28ed:	83 ec 08             	sub    $0x8,%esp
    28f0:	68 ee 53 00 00       	push   $0x53ee
    28f5:	6a 01                	push   $0x1
    28f7:	e8 6d 18 00 00       	call   4169 <printf>
    28fc:	83 c4 10             	add    $0x10,%esp
      exit();
    28ff:	e8 f2 16 00 00       	call   3ff6 <exit>
    }
    if(cc == 0)
    2904:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2908:	74 7a                	je     2984 <bigfile+0x1c4>
      break;
    if(cc != 300){
    290a:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2911:	74 17                	je     292a <bigfile+0x16a>
      printf(1, "short read bigfile\n");
    2913:	83 ec 08             	sub    $0x8,%esp
    2916:	68 03 54 00 00       	push   $0x5403
    291b:	6a 01                	push   $0x1
    291d:	e8 47 18 00 00       	call   4169 <printf>
    2922:	83 c4 10             	add    $0x10,%esp
      exit();
    2925:	e8 cc 16 00 00       	call   3ff6 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    292a:	0f b6 05 60 8c 00 00 	movzbl 0x8c60,%eax
    2931:	0f be d0             	movsbl %al,%edx
    2934:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2937:	89 c1                	mov    %eax,%ecx
    2939:	c1 e9 1f             	shr    $0x1f,%ecx
    293c:	01 c8                	add    %ecx,%eax
    293e:	d1 f8                	sar    %eax
    2940:	39 c2                	cmp    %eax,%edx
    2942:	75 1a                	jne    295e <bigfile+0x19e>
    2944:	0f b6 05 8b 8d 00 00 	movzbl 0x8d8b,%eax
    294b:	0f be d0             	movsbl %al,%edx
    294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2951:	89 c1                	mov    %eax,%ecx
    2953:	c1 e9 1f             	shr    $0x1f,%ecx
    2956:	01 c8                	add    %ecx,%eax
    2958:	d1 f8                	sar    %eax
    295a:	39 c2                	cmp    %eax,%edx
    295c:	74 17                	je     2975 <bigfile+0x1b5>
      printf(1, "read bigfile wrong data\n");
    295e:	83 ec 08             	sub    $0x8,%esp
    2961:	68 17 54 00 00       	push   $0x5417
    2966:	6a 01                	push   $0x1
    2968:	e8 fc 17 00 00       	call   4169 <printf>
    296d:	83 c4 10             	add    $0x10,%esp
      exit();
    2970:	e8 81 16 00 00       	call   3ff6 <exit>
    }
    total += cc;
    2975:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2978:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    297b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    cc = read(fd, buf, 300);
    297f:	e9 48 ff ff ff       	jmp    28cc <bigfile+0x10c>
      break;
    2984:	90                   	nop
  }
  close(fd);
    2985:	83 ec 0c             	sub    $0xc,%esp
    2988:	ff 75 ec             	pushl  -0x14(%ebp)
    298b:	e8 8e 16 00 00       	call   401e <close>
    2990:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    2993:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    299a:	74 17                	je     29b3 <bigfile+0x1f3>
    printf(1, "read bigfile wrong total\n");
    299c:	83 ec 08             	sub    $0x8,%esp
    299f:	68 30 54 00 00       	push   $0x5430
    29a4:	6a 01                	push   $0x1
    29a6:	e8 be 17 00 00       	call   4169 <printf>
    29ab:	83 c4 10             	add    $0x10,%esp
    exit();
    29ae:	e8 43 16 00 00       	call   3ff6 <exit>
  }
  unlink("bigfile");
    29b3:	83 ec 0c             	sub    $0xc,%esp
    29b6:	68 a5 53 00 00       	push   $0x53a5
    29bb:	e8 86 16 00 00       	call   4046 <unlink>
    29c0:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    29c3:	83 ec 08             	sub    $0x8,%esp
    29c6:	68 4a 54 00 00       	push   $0x544a
    29cb:	6a 01                	push   $0x1
    29cd:	e8 97 17 00 00       	call   4169 <printf>
    29d2:	83 c4 10             	add    $0x10,%esp
}
    29d5:	90                   	nop
    29d6:	c9                   	leave  
    29d7:	c3                   	ret    

000029d8 <fourteen>:

void
fourteen(void)
{
    29d8:	55                   	push   %ebp
    29d9:	89 e5                	mov    %esp,%ebp
    29db:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29de:	83 ec 08             	sub    $0x8,%esp
    29e1:	68 5b 54 00 00       	push   $0x545b
    29e6:	6a 01                	push   $0x1
    29e8:	e8 7c 17 00 00       	call   4169 <printf>
    29ed:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    29f0:	83 ec 0c             	sub    $0xc,%esp
    29f3:	68 6a 54 00 00       	push   $0x546a
    29f8:	e8 61 16 00 00       	call   405e <mkdir>
    29fd:	83 c4 10             	add    $0x10,%esp
    2a00:	85 c0                	test   %eax,%eax
    2a02:	74 17                	je     2a1b <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a04:	83 ec 08             	sub    $0x8,%esp
    2a07:	68 79 54 00 00       	push   $0x5479
    2a0c:	6a 01                	push   $0x1
    2a0e:	e8 56 17 00 00       	call   4169 <printf>
    2a13:	83 c4 10             	add    $0x10,%esp
    exit();
    2a16:	e8 db 15 00 00       	call   3ff6 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a1b:	83 ec 0c             	sub    $0xc,%esp
    2a1e:	68 98 54 00 00       	push   $0x5498
    2a23:	e8 36 16 00 00       	call   405e <mkdir>
    2a28:	83 c4 10             	add    $0x10,%esp
    2a2b:	85 c0                	test   %eax,%eax
    2a2d:	74 17                	je     2a46 <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a2f:	83 ec 08             	sub    $0x8,%esp
    2a32:	68 b8 54 00 00       	push   $0x54b8
    2a37:	6a 01                	push   $0x1
    2a39:	e8 2b 17 00 00       	call   4169 <printf>
    2a3e:	83 c4 10             	add    $0x10,%esp
    exit();
    2a41:	e8 b0 15 00 00       	call   3ff6 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a46:	83 ec 08             	sub    $0x8,%esp
    2a49:	68 00 02 00 00       	push   $0x200
    2a4e:	68 e8 54 00 00       	push   $0x54e8
    2a53:	e8 de 15 00 00       	call   4036 <open>
    2a58:	83 c4 10             	add    $0x10,%esp
    2a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a62:	79 17                	jns    2a7b <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a64:	83 ec 08             	sub    $0x8,%esp
    2a67:	68 18 55 00 00       	push   $0x5518
    2a6c:	6a 01                	push   $0x1
    2a6e:	e8 f6 16 00 00       	call   4169 <printf>
    2a73:	83 c4 10             	add    $0x10,%esp
    exit();
    2a76:	e8 7b 15 00 00       	call   3ff6 <exit>
  }
  close(fd);
    2a7b:	83 ec 0c             	sub    $0xc,%esp
    2a7e:	ff 75 f4             	pushl  -0xc(%ebp)
    2a81:	e8 98 15 00 00       	call   401e <close>
    2a86:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a89:	83 ec 08             	sub    $0x8,%esp
    2a8c:	6a 00                	push   $0x0
    2a8e:	68 58 55 00 00       	push   $0x5558
    2a93:	e8 9e 15 00 00       	call   4036 <open>
    2a98:	83 c4 10             	add    $0x10,%esp
    2a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aa2:	79 17                	jns    2abb <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2aa4:	83 ec 08             	sub    $0x8,%esp
    2aa7:	68 88 55 00 00       	push   $0x5588
    2aac:	6a 01                	push   $0x1
    2aae:	e8 b6 16 00 00       	call   4169 <printf>
    2ab3:	83 c4 10             	add    $0x10,%esp
    exit();
    2ab6:	e8 3b 15 00 00       	call   3ff6 <exit>
  }
  close(fd);
    2abb:	83 ec 0c             	sub    $0xc,%esp
    2abe:	ff 75 f4             	pushl  -0xc(%ebp)
    2ac1:	e8 58 15 00 00       	call   401e <close>
    2ac6:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2ac9:	83 ec 0c             	sub    $0xc,%esp
    2acc:	68 c2 55 00 00       	push   $0x55c2
    2ad1:	e8 88 15 00 00       	call   405e <mkdir>
    2ad6:	83 c4 10             	add    $0x10,%esp
    2ad9:	85 c0                	test   %eax,%eax
    2adb:	75 17                	jne    2af4 <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2add:	83 ec 08             	sub    $0x8,%esp
    2ae0:	68 e0 55 00 00       	push   $0x55e0
    2ae5:	6a 01                	push   $0x1
    2ae7:	e8 7d 16 00 00       	call   4169 <printf>
    2aec:	83 c4 10             	add    $0x10,%esp
    exit();
    2aef:	e8 02 15 00 00       	call   3ff6 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2af4:	83 ec 0c             	sub    $0xc,%esp
    2af7:	68 10 56 00 00       	push   $0x5610
    2afc:	e8 5d 15 00 00       	call   405e <mkdir>
    2b01:	83 c4 10             	add    $0x10,%esp
    2b04:	85 c0                	test   %eax,%eax
    2b06:	75 17                	jne    2b1f <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b08:	83 ec 08             	sub    $0x8,%esp
    2b0b:	68 30 56 00 00       	push   $0x5630
    2b10:	6a 01                	push   $0x1
    2b12:	e8 52 16 00 00       	call   4169 <printf>
    2b17:	83 c4 10             	add    $0x10,%esp
    exit();
    2b1a:	e8 d7 14 00 00       	call   3ff6 <exit>
  }

  printf(1, "fourteen ok\n");
    2b1f:	83 ec 08             	sub    $0x8,%esp
    2b22:	68 61 56 00 00       	push   $0x5661
    2b27:	6a 01                	push   $0x1
    2b29:	e8 3b 16 00 00       	call   4169 <printf>
    2b2e:	83 c4 10             	add    $0x10,%esp
}
    2b31:	90                   	nop
    2b32:	c9                   	leave  
    2b33:	c3                   	ret    

00002b34 <rmdot>:

void
rmdot(void)
{
    2b34:	55                   	push   %ebp
    2b35:	89 e5                	mov    %esp,%ebp
    2b37:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2b3a:	83 ec 08             	sub    $0x8,%esp
    2b3d:	68 6e 56 00 00       	push   $0x566e
    2b42:	6a 01                	push   $0x1
    2b44:	e8 20 16 00 00       	call   4169 <printf>
    2b49:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2b4c:	83 ec 0c             	sub    $0xc,%esp
    2b4f:	68 7a 56 00 00       	push   $0x567a
    2b54:	e8 05 15 00 00       	call   405e <mkdir>
    2b59:	83 c4 10             	add    $0x10,%esp
    2b5c:	85 c0                	test   %eax,%eax
    2b5e:	74 17                	je     2b77 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b60:	83 ec 08             	sub    $0x8,%esp
    2b63:	68 7f 56 00 00       	push   $0x567f
    2b68:	6a 01                	push   $0x1
    2b6a:	e8 fa 15 00 00       	call   4169 <printf>
    2b6f:	83 c4 10             	add    $0x10,%esp
    exit();
    2b72:	e8 7f 14 00 00       	call   3ff6 <exit>
  }
  if(chdir("dots") != 0){
    2b77:	83 ec 0c             	sub    $0xc,%esp
    2b7a:	68 7a 56 00 00       	push   $0x567a
    2b7f:	e8 e2 14 00 00       	call   4066 <chdir>
    2b84:	83 c4 10             	add    $0x10,%esp
    2b87:	85 c0                	test   %eax,%eax
    2b89:	74 17                	je     2ba2 <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2b8b:	83 ec 08             	sub    $0x8,%esp
    2b8e:	68 92 56 00 00       	push   $0x5692
    2b93:	6a 01                	push   $0x1
    2b95:	e8 cf 15 00 00       	call   4169 <printf>
    2b9a:	83 c4 10             	add    $0x10,%esp
    exit();
    2b9d:	e8 54 14 00 00       	call   3ff6 <exit>
  }
  if(unlink(".") == 0){
    2ba2:	83 ec 0c             	sub    $0xc,%esp
    2ba5:	68 ab 4d 00 00       	push   $0x4dab
    2baa:	e8 97 14 00 00       	call   4046 <unlink>
    2baf:	83 c4 10             	add    $0x10,%esp
    2bb2:	85 c0                	test   %eax,%eax
    2bb4:	75 17                	jne    2bcd <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2bb6:	83 ec 08             	sub    $0x8,%esp
    2bb9:	68 a5 56 00 00       	push   $0x56a5
    2bbe:	6a 01                	push   $0x1
    2bc0:	e8 a4 15 00 00       	call   4169 <printf>
    2bc5:	83 c4 10             	add    $0x10,%esp
    exit();
    2bc8:	e8 29 14 00 00       	call   3ff6 <exit>
  }
  if(unlink("..") == 0){
    2bcd:	83 ec 0c             	sub    $0xc,%esp
    2bd0:	68 3e 49 00 00       	push   $0x493e
    2bd5:	e8 6c 14 00 00       	call   4046 <unlink>
    2bda:	83 c4 10             	add    $0x10,%esp
    2bdd:	85 c0                	test   %eax,%eax
    2bdf:	75 17                	jne    2bf8 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2be1:	83 ec 08             	sub    $0x8,%esp
    2be4:	68 b3 56 00 00       	push   $0x56b3
    2be9:	6a 01                	push   $0x1
    2beb:	e8 79 15 00 00       	call   4169 <printf>
    2bf0:	83 c4 10             	add    $0x10,%esp
    exit();
    2bf3:	e8 fe 13 00 00       	call   3ff6 <exit>
  }
  if(chdir("/") != 0){
    2bf8:	83 ec 0c             	sub    $0xc,%esp
    2bfb:	68 92 45 00 00       	push   $0x4592
    2c00:	e8 61 14 00 00       	call   4066 <chdir>
    2c05:	83 c4 10             	add    $0x10,%esp
    2c08:	85 c0                	test   %eax,%eax
    2c0a:	74 17                	je     2c23 <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2c0c:	83 ec 08             	sub    $0x8,%esp
    2c0f:	68 94 45 00 00       	push   $0x4594
    2c14:	6a 01                	push   $0x1
    2c16:	e8 4e 15 00 00       	call   4169 <printf>
    2c1b:	83 c4 10             	add    $0x10,%esp
    exit();
    2c1e:	e8 d3 13 00 00       	call   3ff6 <exit>
  }
  if(unlink("dots/.") == 0){
    2c23:	83 ec 0c             	sub    $0xc,%esp
    2c26:	68 c2 56 00 00       	push   $0x56c2
    2c2b:	e8 16 14 00 00       	call   4046 <unlink>
    2c30:	83 c4 10             	add    $0x10,%esp
    2c33:	85 c0                	test   %eax,%eax
    2c35:	75 17                	jne    2c4e <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2c37:	83 ec 08             	sub    $0x8,%esp
    2c3a:	68 c9 56 00 00       	push   $0x56c9
    2c3f:	6a 01                	push   $0x1
    2c41:	e8 23 15 00 00       	call   4169 <printf>
    2c46:	83 c4 10             	add    $0x10,%esp
    exit();
    2c49:	e8 a8 13 00 00       	call   3ff6 <exit>
  }
  if(unlink("dots/..") == 0){
    2c4e:	83 ec 0c             	sub    $0xc,%esp
    2c51:	68 e0 56 00 00       	push   $0x56e0
    2c56:	e8 eb 13 00 00       	call   4046 <unlink>
    2c5b:	83 c4 10             	add    $0x10,%esp
    2c5e:	85 c0                	test   %eax,%eax
    2c60:	75 17                	jne    2c79 <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2c62:	83 ec 08             	sub    $0x8,%esp
    2c65:	68 e8 56 00 00       	push   $0x56e8
    2c6a:	6a 01                	push   $0x1
    2c6c:	e8 f8 14 00 00       	call   4169 <printf>
    2c71:	83 c4 10             	add    $0x10,%esp
    exit();
    2c74:	e8 7d 13 00 00       	call   3ff6 <exit>
  }
  if(unlink("dots") != 0){
    2c79:	83 ec 0c             	sub    $0xc,%esp
    2c7c:	68 7a 56 00 00       	push   $0x567a
    2c81:	e8 c0 13 00 00       	call   4046 <unlink>
    2c86:	83 c4 10             	add    $0x10,%esp
    2c89:	85 c0                	test   %eax,%eax
    2c8b:	74 17                	je     2ca4 <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2c8d:	83 ec 08             	sub    $0x8,%esp
    2c90:	68 00 57 00 00       	push   $0x5700
    2c95:	6a 01                	push   $0x1
    2c97:	e8 cd 14 00 00       	call   4169 <printf>
    2c9c:	83 c4 10             	add    $0x10,%esp
    exit();
    2c9f:	e8 52 13 00 00       	call   3ff6 <exit>
  }
  printf(1, "rmdot ok\n");
    2ca4:	83 ec 08             	sub    $0x8,%esp
    2ca7:	68 15 57 00 00       	push   $0x5715
    2cac:	6a 01                	push   $0x1
    2cae:	e8 b6 14 00 00       	call   4169 <printf>
    2cb3:	83 c4 10             	add    $0x10,%esp
}
    2cb6:	90                   	nop
    2cb7:	c9                   	leave  
    2cb8:	c3                   	ret    

00002cb9 <dirfile>:

void
dirfile(void)
{
    2cb9:	55                   	push   %ebp
    2cba:	89 e5                	mov    %esp,%ebp
    2cbc:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cbf:	83 ec 08             	sub    $0x8,%esp
    2cc2:	68 1f 57 00 00       	push   $0x571f
    2cc7:	6a 01                	push   $0x1
    2cc9:	e8 9b 14 00 00       	call   4169 <printf>
    2cce:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2cd1:	83 ec 08             	sub    $0x8,%esp
    2cd4:	68 00 02 00 00       	push   $0x200
    2cd9:	68 2c 57 00 00       	push   $0x572c
    2cde:	e8 53 13 00 00       	call   4036 <open>
    2ce3:	83 c4 10             	add    $0x10,%esp
    2ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ced:	79 17                	jns    2d06 <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2cef:	83 ec 08             	sub    $0x8,%esp
    2cf2:	68 34 57 00 00       	push   $0x5734
    2cf7:	6a 01                	push   $0x1
    2cf9:	e8 6b 14 00 00       	call   4169 <printf>
    2cfe:	83 c4 10             	add    $0x10,%esp
    exit();
    2d01:	e8 f0 12 00 00       	call   3ff6 <exit>
  }
  close(fd);
    2d06:	83 ec 0c             	sub    $0xc,%esp
    2d09:	ff 75 f4             	pushl  -0xc(%ebp)
    2d0c:	e8 0d 13 00 00       	call   401e <close>
    2d11:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2d14:	83 ec 0c             	sub    $0xc,%esp
    2d17:	68 2c 57 00 00       	push   $0x572c
    2d1c:	e8 45 13 00 00       	call   4066 <chdir>
    2d21:	83 c4 10             	add    $0x10,%esp
    2d24:	85 c0                	test   %eax,%eax
    2d26:	75 17                	jne    2d3f <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2d28:	83 ec 08             	sub    $0x8,%esp
    2d2b:	68 4b 57 00 00       	push   $0x574b
    2d30:	6a 01                	push   $0x1
    2d32:	e8 32 14 00 00       	call   4169 <printf>
    2d37:	83 c4 10             	add    $0x10,%esp
    exit();
    2d3a:	e8 b7 12 00 00       	call   3ff6 <exit>
  }
  fd = open("dirfile/xx", 0);
    2d3f:	83 ec 08             	sub    $0x8,%esp
    2d42:	6a 00                	push   $0x0
    2d44:	68 65 57 00 00       	push   $0x5765
    2d49:	e8 e8 12 00 00       	call   4036 <open>
    2d4e:	83 c4 10             	add    $0x10,%esp
    2d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d58:	78 17                	js     2d71 <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2d5a:	83 ec 08             	sub    $0x8,%esp
    2d5d:	68 70 57 00 00       	push   $0x5770
    2d62:	6a 01                	push   $0x1
    2d64:	e8 00 14 00 00       	call   4169 <printf>
    2d69:	83 c4 10             	add    $0x10,%esp
    exit();
    2d6c:	e8 85 12 00 00       	call   3ff6 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d71:	83 ec 08             	sub    $0x8,%esp
    2d74:	68 00 02 00 00       	push   $0x200
    2d79:	68 65 57 00 00       	push   $0x5765
    2d7e:	e8 b3 12 00 00       	call   4036 <open>
    2d83:	83 c4 10             	add    $0x10,%esp
    2d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d8d:	78 17                	js     2da6 <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2d8f:	83 ec 08             	sub    $0x8,%esp
    2d92:	68 70 57 00 00       	push   $0x5770
    2d97:	6a 01                	push   $0x1
    2d99:	e8 cb 13 00 00       	call   4169 <printf>
    2d9e:	83 c4 10             	add    $0x10,%esp
    exit();
    2da1:	e8 50 12 00 00       	call   3ff6 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2da6:	83 ec 0c             	sub    $0xc,%esp
    2da9:	68 65 57 00 00       	push   $0x5765
    2dae:	e8 ab 12 00 00       	call   405e <mkdir>
    2db3:	83 c4 10             	add    $0x10,%esp
    2db6:	85 c0                	test   %eax,%eax
    2db8:	75 17                	jne    2dd1 <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2dba:	83 ec 08             	sub    $0x8,%esp
    2dbd:	68 8e 57 00 00       	push   $0x578e
    2dc2:	6a 01                	push   $0x1
    2dc4:	e8 a0 13 00 00       	call   4169 <printf>
    2dc9:	83 c4 10             	add    $0x10,%esp
    exit();
    2dcc:	e8 25 12 00 00       	call   3ff6 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dd1:	83 ec 0c             	sub    $0xc,%esp
    2dd4:	68 65 57 00 00       	push   $0x5765
    2dd9:	e8 68 12 00 00       	call   4046 <unlink>
    2dde:	83 c4 10             	add    $0x10,%esp
    2de1:	85 c0                	test   %eax,%eax
    2de3:	75 17                	jne    2dfc <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2de5:	83 ec 08             	sub    $0x8,%esp
    2de8:	68 ab 57 00 00       	push   $0x57ab
    2ded:	6a 01                	push   $0x1
    2def:	e8 75 13 00 00       	call   4169 <printf>
    2df4:	83 c4 10             	add    $0x10,%esp
    exit();
    2df7:	e8 fa 11 00 00       	call   3ff6 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2dfc:	83 ec 08             	sub    $0x8,%esp
    2dff:	68 65 57 00 00       	push   $0x5765
    2e04:	68 c9 57 00 00       	push   $0x57c9
    2e09:	e8 48 12 00 00       	call   4056 <link>
    2e0e:	83 c4 10             	add    $0x10,%esp
    2e11:	85 c0                	test   %eax,%eax
    2e13:	75 17                	jne    2e2c <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e15:	83 ec 08             	sub    $0x8,%esp
    2e18:	68 d0 57 00 00       	push   $0x57d0
    2e1d:	6a 01                	push   $0x1
    2e1f:	e8 45 13 00 00       	call   4169 <printf>
    2e24:	83 c4 10             	add    $0x10,%esp
    exit();
    2e27:	e8 ca 11 00 00       	call   3ff6 <exit>
  }
  if(unlink("dirfile") != 0){
    2e2c:	83 ec 0c             	sub    $0xc,%esp
    2e2f:	68 2c 57 00 00       	push   $0x572c
    2e34:	e8 0d 12 00 00       	call   4046 <unlink>
    2e39:	83 c4 10             	add    $0x10,%esp
    2e3c:	85 c0                	test   %eax,%eax
    2e3e:	74 17                	je     2e57 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2e40:	83 ec 08             	sub    $0x8,%esp
    2e43:	68 ef 57 00 00       	push   $0x57ef
    2e48:	6a 01                	push   $0x1
    2e4a:	e8 1a 13 00 00       	call   4169 <printf>
    2e4f:	83 c4 10             	add    $0x10,%esp
    exit();
    2e52:	e8 9f 11 00 00       	call   3ff6 <exit>
  }

  fd = open(".", O_RDWR);
    2e57:	83 ec 08             	sub    $0x8,%esp
    2e5a:	6a 02                	push   $0x2
    2e5c:	68 ab 4d 00 00       	push   $0x4dab
    2e61:	e8 d0 11 00 00       	call   4036 <open>
    2e66:	83 c4 10             	add    $0x10,%esp
    2e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e70:	78 17                	js     2e89 <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2e72:	83 ec 08             	sub    $0x8,%esp
    2e75:	68 08 58 00 00       	push   $0x5808
    2e7a:	6a 01                	push   $0x1
    2e7c:	e8 e8 12 00 00       	call   4169 <printf>
    2e81:	83 c4 10             	add    $0x10,%esp
    exit();
    2e84:	e8 6d 11 00 00       	call   3ff6 <exit>
  }
  fd = open(".", 0);
    2e89:	83 ec 08             	sub    $0x8,%esp
    2e8c:	6a 00                	push   $0x0
    2e8e:	68 ab 4d 00 00       	push   $0x4dab
    2e93:	e8 9e 11 00 00       	call   4036 <open>
    2e98:	83 c4 10             	add    $0x10,%esp
    2e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e9e:	83 ec 04             	sub    $0x4,%esp
    2ea1:	6a 01                	push   $0x1
    2ea3:	68 f7 49 00 00       	push   $0x49f7
    2ea8:	ff 75 f4             	pushl  -0xc(%ebp)
    2eab:	e8 66 11 00 00       	call   4016 <write>
    2eb0:	83 c4 10             	add    $0x10,%esp
    2eb3:	85 c0                	test   %eax,%eax
    2eb5:	7e 17                	jle    2ece <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2eb7:	83 ec 08             	sub    $0x8,%esp
    2eba:	68 27 58 00 00       	push   $0x5827
    2ebf:	6a 01                	push   $0x1
    2ec1:	e8 a3 12 00 00       	call   4169 <printf>
    2ec6:	83 c4 10             	add    $0x10,%esp
    exit();
    2ec9:	e8 28 11 00 00       	call   3ff6 <exit>
  }
  close(fd);
    2ece:	83 ec 0c             	sub    $0xc,%esp
    2ed1:	ff 75 f4             	pushl  -0xc(%ebp)
    2ed4:	e8 45 11 00 00       	call   401e <close>
    2ed9:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2edc:	83 ec 08             	sub    $0x8,%esp
    2edf:	68 3b 58 00 00       	push   $0x583b
    2ee4:	6a 01                	push   $0x1
    2ee6:	e8 7e 12 00 00       	call   4169 <printf>
    2eeb:	83 c4 10             	add    $0x10,%esp
}
    2eee:	90                   	nop
    2eef:	c9                   	leave  
    2ef0:	c3                   	ret    

00002ef1 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2ef1:	55                   	push   %ebp
    2ef2:	89 e5                	mov    %esp,%ebp
    2ef4:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2ef7:	83 ec 08             	sub    $0x8,%esp
    2efa:	68 4b 58 00 00       	push   $0x584b
    2eff:	6a 01                	push   $0x1
    2f01:	e8 63 12 00 00       	call   4169 <printf>
    2f06:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f10:	e9 e7 00 00 00       	jmp    2ffc <iref+0x10b>
    if(mkdir("irefd") != 0){
    2f15:	83 ec 0c             	sub    $0xc,%esp
    2f18:	68 5c 58 00 00       	push   $0x585c
    2f1d:	e8 3c 11 00 00       	call   405e <mkdir>
    2f22:	83 c4 10             	add    $0x10,%esp
    2f25:	85 c0                	test   %eax,%eax
    2f27:	74 17                	je     2f40 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f29:	83 ec 08             	sub    $0x8,%esp
    2f2c:	68 62 58 00 00       	push   $0x5862
    2f31:	6a 01                	push   $0x1
    2f33:	e8 31 12 00 00       	call   4169 <printf>
    2f38:	83 c4 10             	add    $0x10,%esp
      exit();
    2f3b:	e8 b6 10 00 00       	call   3ff6 <exit>
    }
    if(chdir("irefd") != 0){
    2f40:	83 ec 0c             	sub    $0xc,%esp
    2f43:	68 5c 58 00 00       	push   $0x585c
    2f48:	e8 19 11 00 00       	call   4066 <chdir>
    2f4d:	83 c4 10             	add    $0x10,%esp
    2f50:	85 c0                	test   %eax,%eax
    2f52:	74 17                	je     2f6b <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2f54:	83 ec 08             	sub    $0x8,%esp
    2f57:	68 76 58 00 00       	push   $0x5876
    2f5c:	6a 01                	push   $0x1
    2f5e:	e8 06 12 00 00       	call   4169 <printf>
    2f63:	83 c4 10             	add    $0x10,%esp
      exit();
    2f66:	e8 8b 10 00 00       	call   3ff6 <exit>
    }

    mkdir("");
    2f6b:	83 ec 0c             	sub    $0xc,%esp
    2f6e:	68 8a 58 00 00       	push   $0x588a
    2f73:	e8 e6 10 00 00       	call   405e <mkdir>
    2f78:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2f7b:	83 ec 08             	sub    $0x8,%esp
    2f7e:	68 8a 58 00 00       	push   $0x588a
    2f83:	68 c9 57 00 00       	push   $0x57c9
    2f88:	e8 c9 10 00 00       	call   4056 <link>
    2f8d:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2f90:	83 ec 08             	sub    $0x8,%esp
    2f93:	68 00 02 00 00       	push   $0x200
    2f98:	68 8a 58 00 00       	push   $0x588a
    2f9d:	e8 94 10 00 00       	call   4036 <open>
    2fa2:	83 c4 10             	add    $0x10,%esp
    2fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fac:	78 0e                	js     2fbc <iref+0xcb>
      close(fd);
    2fae:	83 ec 0c             	sub    $0xc,%esp
    2fb1:	ff 75 f0             	pushl  -0x10(%ebp)
    2fb4:	e8 65 10 00 00       	call   401e <close>
    2fb9:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2fbc:	83 ec 08             	sub    $0x8,%esp
    2fbf:	68 00 02 00 00       	push   $0x200
    2fc4:	68 8b 58 00 00       	push   $0x588b
    2fc9:	e8 68 10 00 00       	call   4036 <open>
    2fce:	83 c4 10             	add    $0x10,%esp
    2fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fd8:	78 0e                	js     2fe8 <iref+0xf7>
      close(fd);
    2fda:	83 ec 0c             	sub    $0xc,%esp
    2fdd:	ff 75 f0             	pushl  -0x10(%ebp)
    2fe0:	e8 39 10 00 00       	call   401e <close>
    2fe5:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2fe8:	83 ec 0c             	sub    $0xc,%esp
    2feb:	68 8b 58 00 00       	push   $0x588b
    2ff0:	e8 51 10 00 00       	call   4046 <unlink>
    2ff5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 50 + 1; i++){
    2ff8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2ffc:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3000:	0f 8e 0f ff ff ff    	jle    2f15 <iref+0x24>
  }

  chdir("/");
    3006:	83 ec 0c             	sub    $0xc,%esp
    3009:	68 92 45 00 00       	push   $0x4592
    300e:	e8 53 10 00 00       	call   4066 <chdir>
    3013:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    3016:	83 ec 08             	sub    $0x8,%esp
    3019:	68 8e 58 00 00       	push   $0x588e
    301e:	6a 01                	push   $0x1
    3020:	e8 44 11 00 00       	call   4169 <printf>
    3025:	83 c4 10             	add    $0x10,%esp
}
    3028:	90                   	nop
    3029:	c9                   	leave  
    302a:	c3                   	ret    

0000302b <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    302b:	55                   	push   %ebp
    302c:	89 e5                	mov    %esp,%ebp
    302e:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    3031:	83 ec 08             	sub    $0x8,%esp
    3034:	68 a2 58 00 00       	push   $0x58a2
    3039:	6a 01                	push   $0x1
    303b:	e8 29 11 00 00       	call   4169 <printf>
    3040:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    3043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    304a:	eb 1d                	jmp    3069 <forktest+0x3e>
    pid = fork();
    304c:	e8 9d 0f 00 00       	call   3fee <fork>
    3051:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3054:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3058:	78 1a                	js     3074 <forktest+0x49>
      break;
    if(pid == 0)
    305a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    305e:	75 05                	jne    3065 <forktest+0x3a>
      exit();
    3060:	e8 91 0f 00 00       	call   3ff6 <exit>
  for(n=0; n<1000; n++){
    3065:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3069:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3070:	7e da                	jle    304c <forktest+0x21>
    3072:	eb 01                	jmp    3075 <forktest+0x4a>
      break;
    3074:	90                   	nop
  }

  if(n == 1000){
    3075:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    307c:	75 3b                	jne    30b9 <forktest+0x8e>
    printf(1, "fork claimed to work 1000 times!\n");
    307e:	83 ec 08             	sub    $0x8,%esp
    3081:	68 b0 58 00 00       	push   $0x58b0
    3086:	6a 01                	push   $0x1
    3088:	e8 dc 10 00 00       	call   4169 <printf>
    308d:	83 c4 10             	add    $0x10,%esp
    exit();
    3090:	e8 61 0f 00 00       	call   3ff6 <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
    3095:	e8 64 0f 00 00       	call   3ffe <wait>
    309a:	85 c0                	test   %eax,%eax
    309c:	79 17                	jns    30b5 <forktest+0x8a>
      printf(1, "wait stopped early\n");
    309e:	83 ec 08             	sub    $0x8,%esp
    30a1:	68 d2 58 00 00       	push   $0x58d2
    30a6:	6a 01                	push   $0x1
    30a8:	e8 bc 10 00 00       	call   4169 <printf>
    30ad:	83 c4 10             	add    $0x10,%esp
      exit();
    30b0:	e8 41 0f 00 00       	call   3ff6 <exit>
  for(; n > 0; n--){
    30b5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30bd:	7f d6                	jg     3095 <forktest+0x6a>
    }
  }

  if(wait() != -1){
    30bf:	e8 3a 0f 00 00       	call   3ffe <wait>
    30c4:	83 f8 ff             	cmp    $0xffffffff,%eax
    30c7:	74 17                	je     30e0 <forktest+0xb5>
    printf(1, "wait got too many\n");
    30c9:	83 ec 08             	sub    $0x8,%esp
    30cc:	68 e6 58 00 00       	push   $0x58e6
    30d1:	6a 01                	push   $0x1
    30d3:	e8 91 10 00 00       	call   4169 <printf>
    30d8:	83 c4 10             	add    $0x10,%esp
    exit();
    30db:	e8 16 0f 00 00       	call   3ff6 <exit>
  }

  printf(1, "fork test OK\n");
    30e0:	83 ec 08             	sub    $0x8,%esp
    30e3:	68 f9 58 00 00       	push   $0x58f9
    30e8:	6a 01                	push   $0x1
    30ea:	e8 7a 10 00 00       	call   4169 <printf>
    30ef:	83 c4 10             	add    $0x10,%esp
}
    30f2:	90                   	nop
    30f3:	c9                   	leave  
    30f4:	c3                   	ret    

000030f5 <sbrktest>:

void
sbrktest(void)
{
    30f5:	55                   	push   %ebp
    30f6:	89 e5                	mov    %esp,%ebp
    30f8:	53                   	push   %ebx
    30f9:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30fc:	a1 78 64 00 00       	mov    0x6478,%eax
    3101:	83 ec 08             	sub    $0x8,%esp
    3104:	68 07 59 00 00       	push   $0x5907
    3109:	50                   	push   %eax
    310a:	e8 5a 10 00 00       	call   4169 <printf>
    310f:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    3112:	83 ec 0c             	sub    $0xc,%esp
    3115:	6a 00                	push   $0x0
    3117:	e8 62 0f 00 00       	call   407e <sbrk>
    311c:	83 c4 10             	add    $0x10,%esp
    311f:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3122:	83 ec 0c             	sub    $0xc,%esp
    3125:	6a 00                	push   $0x0
    3127:	e8 52 0f 00 00       	call   407e <sbrk>
    312c:	83 c4 10             	add    $0x10,%esp
    312f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){
    3132:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3139:	eb 4f                	jmp    318a <sbrktest+0x95>
    b = sbrk(1);
    313b:	83 ec 0c             	sub    $0xc,%esp
    313e:	6a 01                	push   $0x1
    3140:	e8 39 0f 00 00       	call   407e <sbrk>
    3145:	83 c4 10             	add    $0x10,%esp
    3148:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(b != a){
    314b:	8b 45 d0             	mov    -0x30(%ebp),%eax
    314e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3151:	74 24                	je     3177 <sbrktest+0x82>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3153:	a1 78 64 00 00       	mov    0x6478,%eax
    3158:	83 ec 0c             	sub    $0xc,%esp
    315b:	ff 75 d0             	pushl  -0x30(%ebp)
    315e:	ff 75 f4             	pushl  -0xc(%ebp)
    3161:	ff 75 f0             	pushl  -0x10(%ebp)
    3164:	68 12 59 00 00       	push   $0x5912
    3169:	50                   	push   %eax
    316a:	e8 fa 0f 00 00       	call   4169 <printf>
    316f:	83 c4 20             	add    $0x20,%esp
      exit();
    3172:	e8 7f 0e 00 00       	call   3ff6 <exit>
    }
    *b = 1;
    3177:	8b 45 d0             	mov    -0x30(%ebp),%eax
    317a:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    317d:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3180:	83 c0 01             	add    $0x1,%eax
    3183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){
    3186:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    318a:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3191:	7e a8                	jle    313b <sbrktest+0x46>
  }
  pid = fork();
    3193:	e8 56 0e 00 00       	call   3fee <fork>
    3198:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
    319b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    319f:	79 1b                	jns    31bc <sbrktest+0xc7>
    printf(stdout, "sbrk test fork failed\n");
    31a1:	a1 78 64 00 00       	mov    0x6478,%eax
    31a6:	83 ec 08             	sub    $0x8,%esp
    31a9:	68 2d 59 00 00       	push   $0x592d
    31ae:	50                   	push   %eax
    31af:	e8 b5 0f 00 00       	call   4169 <printf>
    31b4:	83 c4 10             	add    $0x10,%esp
    exit();
    31b7:	e8 3a 0e 00 00       	call   3ff6 <exit>
  }
  c = sbrk(1);
    31bc:	83 ec 0c             	sub    $0xc,%esp
    31bf:	6a 01                	push   $0x1
    31c1:	e8 b8 0e 00 00       	call   407e <sbrk>
    31c6:	83 c4 10             	add    $0x10,%esp
    31c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c = sbrk(1);
    31cc:	83 ec 0c             	sub    $0xc,%esp
    31cf:	6a 01                	push   $0x1
    31d1:	e8 a8 0e 00 00       	call   407e <sbrk>
    31d6:	83 c4 10             	add    $0x10,%esp
    31d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a + 1){
    31dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31df:	83 c0 01             	add    $0x1,%eax
    31e2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    31e5:	74 1b                	je     3202 <sbrktest+0x10d>
    printf(stdout, "sbrk test failed post-fork\n");
    31e7:	a1 78 64 00 00       	mov    0x6478,%eax
    31ec:	83 ec 08             	sub    $0x8,%esp
    31ef:	68 44 59 00 00       	push   $0x5944
    31f4:	50                   	push   %eax
    31f5:	e8 6f 0f 00 00       	call   4169 <printf>
    31fa:	83 c4 10             	add    $0x10,%esp
    exit();
    31fd:	e8 f4 0d 00 00       	call   3ff6 <exit>
  }
  if(pid == 0)
    3202:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3206:	75 05                	jne    320d <sbrktest+0x118>
    exit();
    3208:	e8 e9 0d 00 00       	call   3ff6 <exit>
  wait();
    320d:	e8 ec 0d 00 00       	call   3ffe <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3212:	83 ec 0c             	sub    $0xc,%esp
    3215:	6a 00                	push   $0x0
    3217:	e8 62 0e 00 00       	call   407e <sbrk>
    321c:	83 c4 10             	add    $0x10,%esp
    321f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3222:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3225:	ba 00 00 40 06       	mov    $0x6400000,%edx
    322a:	29 c2                	sub    %eax,%edx
    322c:	89 d0                	mov    %edx,%eax
    322e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  p = sbrk(amt);
    3231:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3234:	83 ec 0c             	sub    $0xc,%esp
    3237:	50                   	push   %eax
    3238:	e8 41 0e 00 00       	call   407e <sbrk>
    323d:	83 c4 10             	add    $0x10,%esp
    3240:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (p != a) {
    3243:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3249:	74 1b                	je     3266 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    324b:	a1 78 64 00 00       	mov    0x6478,%eax
    3250:	83 ec 08             	sub    $0x8,%esp
    3253:	68 60 59 00 00       	push   $0x5960
    3258:	50                   	push   %eax
    3259:	e8 0b 0f 00 00       	call   4169 <printf>
    325e:	83 c4 10             	add    $0x10,%esp
    exit();
    3261:	e8 90 0d 00 00       	call   3ff6 <exit>
  }
  lastaddr = (char*) (BIG-1);
    3266:	c7 45 d8 ff ff 3f 06 	movl   $0x63fffff,-0x28(%ebp)
  *lastaddr = 99;
    326d:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3270:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3273:	83 ec 0c             	sub    $0xc,%esp
    3276:	6a 00                	push   $0x0
    3278:	e8 01 0e 00 00       	call   407e <sbrk>
    327d:	83 c4 10             	add    $0x10,%esp
    3280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3283:	83 ec 0c             	sub    $0xc,%esp
    3286:	68 00 f0 ff ff       	push   $0xfffff000
    328b:	e8 ee 0d 00 00       	call   407e <sbrk>
    3290:	83 c4 10             	add    $0x10,%esp
    3293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c == (char*)0xffffffff){
    3296:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    329a:	75 1b                	jne    32b7 <sbrktest+0x1c2>
    printf(stdout, "sbrk could not deallocate\n");
    329c:	a1 78 64 00 00       	mov    0x6478,%eax
    32a1:	83 ec 08             	sub    $0x8,%esp
    32a4:	68 9e 59 00 00       	push   $0x599e
    32a9:	50                   	push   %eax
    32aa:	e8 ba 0e 00 00       	call   4169 <printf>
    32af:	83 c4 10             	add    $0x10,%esp
    exit();
    32b2:	e8 3f 0d 00 00       	call   3ff6 <exit>
  }
  c = sbrk(0);
    32b7:	83 ec 0c             	sub    $0xc,%esp
    32ba:	6a 00                	push   $0x0
    32bc:	e8 bd 0d 00 00       	call   407e <sbrk>
    32c1:	83 c4 10             	add    $0x10,%esp
    32c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a - 4096){
    32c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32ca:	2d 00 10 00 00       	sub    $0x1000,%eax
    32cf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    32d2:	74 1e                	je     32f2 <sbrktest+0x1fd>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32d4:	a1 78 64 00 00       	mov    0x6478,%eax
    32d9:	ff 75 e4             	pushl  -0x1c(%ebp)
    32dc:	ff 75 f4             	pushl  -0xc(%ebp)
    32df:	68 bc 59 00 00       	push   $0x59bc
    32e4:	50                   	push   %eax
    32e5:	e8 7f 0e 00 00       	call   4169 <printf>
    32ea:	83 c4 10             	add    $0x10,%esp
    exit();
    32ed:	e8 04 0d 00 00       	call   3ff6 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32f2:	83 ec 0c             	sub    $0xc,%esp
    32f5:	6a 00                	push   $0x0
    32f7:	e8 82 0d 00 00       	call   407e <sbrk>
    32fc:	83 c4 10             	add    $0x10,%esp
    32ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3302:	83 ec 0c             	sub    $0xc,%esp
    3305:	68 00 10 00 00       	push   $0x1000
    330a:	e8 6f 0d 00 00       	call   407e <sbrk>
    330f:	83 c4 10             	add    $0x10,%esp
    3312:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3318:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    331b:	75 1b                	jne    3338 <sbrktest+0x243>
    331d:	83 ec 0c             	sub    $0xc,%esp
    3320:	6a 00                	push   $0x0
    3322:	e8 57 0d 00 00       	call   407e <sbrk>
    3327:	83 c4 10             	add    $0x10,%esp
    332a:	89 c2                	mov    %eax,%edx
    332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    332f:	05 00 10 00 00       	add    $0x1000,%eax
    3334:	39 c2                	cmp    %eax,%edx
    3336:	74 1e                	je     3356 <sbrktest+0x261>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3338:	a1 78 64 00 00       	mov    0x6478,%eax
    333d:	ff 75 e4             	pushl  -0x1c(%ebp)
    3340:	ff 75 f4             	pushl  -0xc(%ebp)
    3343:	68 f4 59 00 00       	push   $0x59f4
    3348:	50                   	push   %eax
    3349:	e8 1b 0e 00 00       	call   4169 <printf>
    334e:	83 c4 10             	add    $0x10,%esp
    exit();
    3351:	e8 a0 0c 00 00       	call   3ff6 <exit>
  }
  if(*lastaddr == 99){
    3356:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3359:	0f b6 00             	movzbl (%eax),%eax
    335c:	3c 63                	cmp    $0x63,%al
    335e:	75 1b                	jne    337b <sbrktest+0x286>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3360:	a1 78 64 00 00       	mov    0x6478,%eax
    3365:	83 ec 08             	sub    $0x8,%esp
    3368:	68 1c 5a 00 00       	push   $0x5a1c
    336d:	50                   	push   %eax
    336e:	e8 f6 0d 00 00       	call   4169 <printf>
    3373:	83 c4 10             	add    $0x10,%esp
    exit();
    3376:	e8 7b 0c 00 00       	call   3ff6 <exit>
  }

  a = sbrk(0);
    337b:	83 ec 0c             	sub    $0xc,%esp
    337e:	6a 00                	push   $0x0
    3380:	e8 f9 0c 00 00       	call   407e <sbrk>
    3385:	83 c4 10             	add    $0x10,%esp
    3388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    338b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    338e:	83 ec 0c             	sub    $0xc,%esp
    3391:	6a 00                	push   $0x0
    3393:	e8 e6 0c 00 00       	call   407e <sbrk>
    3398:	83 c4 10             	add    $0x10,%esp
    339b:	29 c3                	sub    %eax,%ebx
    339d:	89 d8                	mov    %ebx,%eax
    339f:	83 ec 0c             	sub    $0xc,%esp
    33a2:	50                   	push   %eax
    33a3:	e8 d6 0c 00 00       	call   407e <sbrk>
    33a8:	83 c4 10             	add    $0x10,%esp
    33ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a){
    33ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    33b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33b4:	74 1e                	je     33d4 <sbrktest+0x2df>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33b6:	a1 78 64 00 00       	mov    0x6478,%eax
    33bb:	ff 75 e4             	pushl  -0x1c(%ebp)
    33be:	ff 75 f4             	pushl  -0xc(%ebp)
    33c1:	68 4c 5a 00 00       	push   $0x5a4c
    33c6:	50                   	push   %eax
    33c7:	e8 9d 0d 00 00       	call   4169 <printf>
    33cc:	83 c4 10             	add    $0x10,%esp
    exit();
    33cf:	e8 22 0c 00 00       	call   3ff6 <exit>
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33d4:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33db:	eb 76                	jmp    3453 <sbrktest+0x35e>
    ppid = getpid();
    33dd:	e8 94 0c 00 00       	call   4076 <getpid>
    33e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    pid = fork();
    33e5:	e8 04 0c 00 00       	call   3fee <fork>
    33ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    33ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    33f1:	79 1b                	jns    340e <sbrktest+0x319>
      printf(stdout, "fork failed\n");
    33f3:	a1 78 64 00 00       	mov    0x6478,%eax
    33f8:	83 ec 08             	sub    $0x8,%esp
    33fb:	68 c1 45 00 00       	push   $0x45c1
    3400:	50                   	push   %eax
    3401:	e8 63 0d 00 00       	call   4169 <printf>
    3406:	83 c4 10             	add    $0x10,%esp
      exit();
    3409:	e8 e8 0b 00 00       	call   3ff6 <exit>
    }
    if(pid == 0){
    340e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3412:	75 33                	jne    3447 <sbrktest+0x352>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3414:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3417:	0f b6 00             	movzbl (%eax),%eax
    341a:	0f be d0             	movsbl %al,%edx
    341d:	a1 78 64 00 00       	mov    0x6478,%eax
    3422:	52                   	push   %edx
    3423:	ff 75 f4             	pushl  -0xc(%ebp)
    3426:	68 6d 5a 00 00       	push   $0x5a6d
    342b:	50                   	push   %eax
    342c:	e8 38 0d 00 00       	call   4169 <printf>
    3431:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    3434:	83 ec 0c             	sub    $0xc,%esp
    3437:	ff 75 d4             	pushl  -0x2c(%ebp)
    343a:	e8 e7 0b 00 00       	call   4026 <kill>
    343f:	83 c4 10             	add    $0x10,%esp
      exit();
    3442:	e8 af 0b 00 00       	call   3ff6 <exit>
    }
    wait();
    3447:	e8 b2 0b 00 00       	call   3ffe <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    344c:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    3453:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    345a:	76 81                	jbe    33dd <sbrktest+0x2e8>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    345c:	83 ec 0c             	sub    $0xc,%esp
    345f:	8d 45 c8             	lea    -0x38(%ebp),%eax
    3462:	50                   	push   %eax
    3463:	e8 9e 0b 00 00       	call   4006 <pipe>
    3468:	83 c4 10             	add    $0x10,%esp
    346b:	85 c0                	test   %eax,%eax
    346d:	74 17                	je     3486 <sbrktest+0x391>
    printf(1, "pipe() failed\n");
    346f:	83 ec 08             	sub    $0x8,%esp
    3472:	68 92 49 00 00       	push   $0x4992
    3477:	6a 01                	push   $0x1
    3479:	e8 eb 0c 00 00       	call   4169 <printf>
    347e:	83 c4 10             	add    $0x10,%esp
    exit();
    3481:	e8 70 0b 00 00       	call   3ff6 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3486:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    348d:	e9 88 00 00 00       	jmp    351a <sbrktest+0x425>
    if((pids[i] = fork()) == 0){
    3492:	e8 57 0b 00 00       	call   3fee <fork>
    3497:	89 c2                	mov    %eax,%edx
    3499:	8b 45 f0             	mov    -0x10(%ebp),%eax
    349c:	89 54 85 a0          	mov    %edx,-0x60(%ebp,%eax,4)
    34a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34a3:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34a7:	85 c0                	test   %eax,%eax
    34a9:	75 4a                	jne    34f5 <sbrktest+0x400>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34ab:	83 ec 0c             	sub    $0xc,%esp
    34ae:	6a 00                	push   $0x0
    34b0:	e8 c9 0b 00 00       	call   407e <sbrk>
    34b5:	83 c4 10             	add    $0x10,%esp
    34b8:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34bd:	29 c2                	sub    %eax,%edx
    34bf:	89 d0                	mov    %edx,%eax
    34c1:	83 ec 0c             	sub    $0xc,%esp
    34c4:	50                   	push   %eax
    34c5:	e8 b4 0b 00 00       	call   407e <sbrk>
    34ca:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    34cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34d0:	83 ec 04             	sub    $0x4,%esp
    34d3:	6a 01                	push   $0x1
    34d5:	68 f7 49 00 00       	push   $0x49f7
    34da:	50                   	push   %eax
    34db:	e8 36 0b 00 00       	call   4016 <write>
    34e0:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    34e3:	83 ec 0c             	sub    $0xc,%esp
    34e6:	68 e8 03 00 00       	push   $0x3e8
    34eb:	e8 96 0b 00 00       	call   4086 <sleep>
    34f0:	83 c4 10             	add    $0x10,%esp
    34f3:	eb ee                	jmp    34e3 <sbrktest+0x3ee>
    }
    if(pids[i] != -1)
    34f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34f8:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34fc:	83 f8 ff             	cmp    $0xffffffff,%eax
    34ff:	74 15                	je     3516 <sbrktest+0x421>
      read(fds[0], &scratch, 1);
    3501:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3504:	83 ec 04             	sub    $0x4,%esp
    3507:	6a 01                	push   $0x1
    3509:	8d 55 9f             	lea    -0x61(%ebp),%edx
    350c:	52                   	push   %edx
    350d:	50                   	push   %eax
    350e:	e8 fb 0a 00 00       	call   400e <read>
    3513:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3516:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    351a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    351d:	83 f8 09             	cmp    $0x9,%eax
    3520:	0f 86 6c ff ff ff    	jbe    3492 <sbrktest+0x39d>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3526:	83 ec 0c             	sub    $0xc,%esp
    3529:	68 00 10 00 00       	push   $0x1000
    352e:	e8 4b 0b 00 00       	call   407e <sbrk>
    3533:	83 c4 10             	add    $0x10,%esp
    3536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3540:	eb 2b                	jmp    356d <sbrktest+0x478>
    if(pids[i] == -1)
    3542:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3545:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3549:	83 f8 ff             	cmp    $0xffffffff,%eax
    354c:	74 1a                	je     3568 <sbrktest+0x473>
      continue;
    kill(pids[i]);
    354e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3551:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3555:	83 ec 0c             	sub    $0xc,%esp
    3558:	50                   	push   %eax
    3559:	e8 c8 0a 00 00       	call   4026 <kill>
    355e:	83 c4 10             	add    $0x10,%esp
    wait();
    3561:	e8 98 0a 00 00       	call   3ffe <wait>
    3566:	eb 01                	jmp    3569 <sbrktest+0x474>
      continue;
    3568:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3569:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    356d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3570:	83 f8 09             	cmp    $0x9,%eax
    3573:	76 cd                	jbe    3542 <sbrktest+0x44d>
  }
  if(c == (char*)0xffffffff){
    3575:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    3579:	75 1b                	jne    3596 <sbrktest+0x4a1>
    printf(stdout, "failed sbrk leaked memory\n");
    357b:	a1 78 64 00 00       	mov    0x6478,%eax
    3580:	83 ec 08             	sub    $0x8,%esp
    3583:	68 86 5a 00 00       	push   $0x5a86
    3588:	50                   	push   %eax
    3589:	e8 db 0b 00 00       	call   4169 <printf>
    358e:	83 c4 10             	add    $0x10,%esp
    exit();
    3591:	e8 60 0a 00 00       	call   3ff6 <exit>
  }

  if(sbrk(0) > oldbrk)
    3596:	83 ec 0c             	sub    $0xc,%esp
    3599:	6a 00                	push   $0x0
    359b:	e8 de 0a 00 00       	call   407e <sbrk>
    35a0:	83 c4 10             	add    $0x10,%esp
    35a3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    35a6:	73 20                	jae    35c8 <sbrktest+0x4d3>
    sbrk(-(sbrk(0) - oldbrk));
    35a8:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35ab:	83 ec 0c             	sub    $0xc,%esp
    35ae:	6a 00                	push   $0x0
    35b0:	e8 c9 0a 00 00       	call   407e <sbrk>
    35b5:	83 c4 10             	add    $0x10,%esp
    35b8:	29 c3                	sub    %eax,%ebx
    35ba:	89 d8                	mov    %ebx,%eax
    35bc:	83 ec 0c             	sub    $0xc,%esp
    35bf:	50                   	push   %eax
    35c0:	e8 b9 0a 00 00       	call   407e <sbrk>
    35c5:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    35c8:	a1 78 64 00 00       	mov    0x6478,%eax
    35cd:	83 ec 08             	sub    $0x8,%esp
    35d0:	68 a1 5a 00 00       	push   $0x5aa1
    35d5:	50                   	push   %eax
    35d6:	e8 8e 0b 00 00       	call   4169 <printf>
    35db:	83 c4 10             	add    $0x10,%esp
}
    35de:	90                   	nop
    35df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    35e2:	c9                   	leave  
    35e3:	c3                   	ret    

000035e4 <validateint>:

void
validateint(int *p)
{
    35e4:	55                   	push   %ebp
    35e5:	89 e5                	mov    %esp,%ebp
    35e7:	53                   	push   %ebx
    35e8:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35eb:	b8 0d 00 00 00       	mov    $0xd,%eax
    35f0:	8b 55 08             	mov    0x8(%ebp),%edx
    35f3:	89 d1                	mov    %edx,%ecx
    35f5:	89 e3                	mov    %esp,%ebx
    35f7:	89 cc                	mov    %ecx,%esp
    35f9:	cd 40                	int    $0x40
    35fb:	89 dc                	mov    %ebx,%esp
    35fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3600:	90                   	nop
    3601:	83 c4 10             	add    $0x10,%esp
    3604:	5b                   	pop    %ebx
    3605:	5d                   	pop    %ebp
    3606:	c3                   	ret    

00003607 <validatetest>:

void
validatetest(void)
{
    3607:	55                   	push   %ebp
    3608:	89 e5                	mov    %esp,%ebp
    360a:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    360d:	a1 78 64 00 00       	mov    0x6478,%eax
    3612:	83 ec 08             	sub    $0x8,%esp
    3615:	68 af 5a 00 00       	push   $0x5aaf
    361a:	50                   	push   %eax
    361b:	e8 49 0b 00 00       	call   4169 <printf>
    3620:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    3623:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    362a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3631:	e9 8a 00 00 00       	jmp    36c0 <validatetest+0xb9>
    if((pid = fork()) == 0){
    3636:	e8 b3 09 00 00       	call   3fee <fork>
    363b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    363e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3642:	75 14                	jne    3658 <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3644:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3647:	83 ec 0c             	sub    $0xc,%esp
    364a:	50                   	push   %eax
    364b:	e8 94 ff ff ff       	call   35e4 <validateint>
    3650:	83 c4 10             	add    $0x10,%esp
      exit();
    3653:	e8 9e 09 00 00       	call   3ff6 <exit>
    }
    sleep(0);
    3658:	83 ec 0c             	sub    $0xc,%esp
    365b:	6a 00                	push   $0x0
    365d:	e8 24 0a 00 00       	call   4086 <sleep>
    3662:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    3665:	83 ec 0c             	sub    $0xc,%esp
    3668:	6a 00                	push   $0x0
    366a:	e8 17 0a 00 00       	call   4086 <sleep>
    366f:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    3672:	83 ec 0c             	sub    $0xc,%esp
    3675:	ff 75 ec             	pushl  -0x14(%ebp)
    3678:	e8 a9 09 00 00       	call   4026 <kill>
    367d:	83 c4 10             	add    $0x10,%esp
    wait();
    3680:	e8 79 09 00 00       	call   3ffe <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3685:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3688:	83 ec 08             	sub    $0x8,%esp
    368b:	50                   	push   %eax
    368c:	68 be 5a 00 00       	push   $0x5abe
    3691:	e8 c0 09 00 00       	call   4056 <link>
    3696:	83 c4 10             	add    $0x10,%esp
    3699:	83 f8 ff             	cmp    $0xffffffff,%eax
    369c:	74 1b                	je     36b9 <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    369e:	a1 78 64 00 00       	mov    0x6478,%eax
    36a3:	83 ec 08             	sub    $0x8,%esp
    36a6:	68 c9 5a 00 00       	push   $0x5ac9
    36ab:	50                   	push   %eax
    36ac:	e8 b8 0a 00 00       	call   4169 <printf>
    36b1:	83 c4 10             	add    $0x10,%esp
      exit();
    36b4:	e8 3d 09 00 00       	call   3ff6 <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    36b9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36c3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    36c6:	0f 86 6a ff ff ff    	jbe    3636 <validatetest+0x2f>
    }
  }

  printf(stdout, "validate ok\n");
    36cc:	a1 78 64 00 00       	mov    0x6478,%eax
    36d1:	83 ec 08             	sub    $0x8,%esp
    36d4:	68 e2 5a 00 00       	push   $0x5ae2
    36d9:	50                   	push   %eax
    36da:	e8 8a 0a 00 00       	call   4169 <printf>
    36df:	83 c4 10             	add    $0x10,%esp
}
    36e2:	90                   	nop
    36e3:	c9                   	leave  
    36e4:	c3                   	ret    

000036e5 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36e5:	55                   	push   %ebp
    36e6:	89 e5                	mov    %esp,%ebp
    36e8:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    36eb:	a1 78 64 00 00       	mov    0x6478,%eax
    36f0:	83 ec 08             	sub    $0x8,%esp
    36f3:	68 ef 5a 00 00       	push   $0x5aef
    36f8:	50                   	push   %eax
    36f9:	e8 6b 0a 00 00       	call   4169 <printf>
    36fe:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    3701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3708:	eb 2e                	jmp    3738 <bsstest+0x53>
    if(uninit[i] != '\0'){
    370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    370d:	05 40 65 00 00       	add    $0x6540,%eax
    3712:	0f b6 00             	movzbl (%eax),%eax
    3715:	84 c0                	test   %al,%al
    3717:	74 1b                	je     3734 <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    3719:	a1 78 64 00 00       	mov    0x6478,%eax
    371e:	83 ec 08             	sub    $0x8,%esp
    3721:	68 f9 5a 00 00       	push   $0x5af9
    3726:	50                   	push   %eax
    3727:	e8 3d 0a 00 00       	call   4169 <printf>
    372c:	83 c4 10             	add    $0x10,%esp
      exit();
    372f:	e8 c2 08 00 00       	call   3ff6 <exit>
  for(i = 0; i < sizeof(uninit); i++){
    3734:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3738:	8b 45 f4             	mov    -0xc(%ebp),%eax
    373b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3740:	76 c8                	jbe    370a <bsstest+0x25>
    }
  }
  printf(stdout, "bss test ok\n");
    3742:	a1 78 64 00 00       	mov    0x6478,%eax
    3747:	83 ec 08             	sub    $0x8,%esp
    374a:	68 0a 5b 00 00       	push   $0x5b0a
    374f:	50                   	push   %eax
    3750:	e8 14 0a 00 00       	call   4169 <printf>
    3755:	83 c4 10             	add    $0x10,%esp
}
    3758:	90                   	nop
    3759:	c9                   	leave  
    375a:	c3                   	ret    

0000375b <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    375b:	55                   	push   %ebp
    375c:	89 e5                	mov    %esp,%ebp
    375e:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3761:	83 ec 0c             	sub    $0xc,%esp
    3764:	68 17 5b 00 00       	push   $0x5b17
    3769:	e8 d8 08 00 00       	call   4046 <unlink>
    376e:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3771:	e8 78 08 00 00       	call   3fee <fork>
    3776:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3779:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    377d:	0f 85 97 00 00 00    	jne    381a <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3783:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    378a:	eb 12                	jmp    379e <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    378c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    378f:	c7 04 85 a0 64 00 00 	movl   $0x5b24,0x64a0(,%eax,4)
    3796:	24 5b 00 00 
    for(i = 0; i < MAXARG-1; i++)
    379a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    379e:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    37a2:	7e e8                	jle    378c <bigargtest+0x31>
    args[MAXARG-1] = 0;
    37a4:	c7 05 1c 65 00 00 00 	movl   $0x0,0x651c
    37ab:	00 00 00 
    printf(stdout, "bigarg test\n");
    37ae:	a1 78 64 00 00       	mov    0x6478,%eax
    37b3:	83 ec 08             	sub    $0x8,%esp
    37b6:	68 01 5c 00 00       	push   $0x5c01
    37bb:	50                   	push   %eax
    37bc:	e8 a8 09 00 00       	call   4169 <printf>
    37c1:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    37c4:	83 ec 08             	sub    $0x8,%esp
    37c7:	68 a0 64 00 00       	push   $0x64a0
    37cc:	68 20 45 00 00       	push   $0x4520
    37d1:	e8 58 08 00 00       	call   402e <exec>
    37d6:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    37d9:	a1 78 64 00 00       	mov    0x6478,%eax
    37de:	83 ec 08             	sub    $0x8,%esp
    37e1:	68 0e 5c 00 00       	push   $0x5c0e
    37e6:	50                   	push   %eax
    37e7:	e8 7d 09 00 00       	call   4169 <printf>
    37ec:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    37ef:	83 ec 08             	sub    $0x8,%esp
    37f2:	68 00 02 00 00       	push   $0x200
    37f7:	68 17 5b 00 00       	push   $0x5b17
    37fc:	e8 35 08 00 00       	call   4036 <open>
    3801:	83 c4 10             	add    $0x10,%esp
    3804:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3807:	83 ec 0c             	sub    $0xc,%esp
    380a:	ff 75 ec             	pushl  -0x14(%ebp)
    380d:	e8 0c 08 00 00       	call   401e <close>
    3812:	83 c4 10             	add    $0x10,%esp
    exit();
    3815:	e8 dc 07 00 00       	call   3ff6 <exit>
  } else if(pid < 0){
    381a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    381e:	79 1b                	jns    383b <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    3820:	a1 78 64 00 00       	mov    0x6478,%eax
    3825:	83 ec 08             	sub    $0x8,%esp
    3828:	68 1e 5c 00 00       	push   $0x5c1e
    382d:	50                   	push   %eax
    382e:	e8 36 09 00 00       	call   4169 <printf>
    3833:	83 c4 10             	add    $0x10,%esp
    exit();
    3836:	e8 bb 07 00 00       	call   3ff6 <exit>
  }
  wait();
    383b:	e8 be 07 00 00       	call   3ffe <wait>
  fd = open("bigarg-ok", 0);
    3840:	83 ec 08             	sub    $0x8,%esp
    3843:	6a 00                	push   $0x0
    3845:	68 17 5b 00 00       	push   $0x5b17
    384a:	e8 e7 07 00 00       	call   4036 <open>
    384f:	83 c4 10             	add    $0x10,%esp
    3852:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3855:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3859:	79 1b                	jns    3876 <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    385b:	a1 78 64 00 00       	mov    0x6478,%eax
    3860:	83 ec 08             	sub    $0x8,%esp
    3863:	68 37 5c 00 00       	push   $0x5c37
    3868:	50                   	push   %eax
    3869:	e8 fb 08 00 00       	call   4169 <printf>
    386e:	83 c4 10             	add    $0x10,%esp
    exit();
    3871:	e8 80 07 00 00       	call   3ff6 <exit>
  }
  close(fd);
    3876:	83 ec 0c             	sub    $0xc,%esp
    3879:	ff 75 ec             	pushl  -0x14(%ebp)
    387c:	e8 9d 07 00 00       	call   401e <close>
    3881:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3884:	83 ec 0c             	sub    $0xc,%esp
    3887:	68 17 5b 00 00       	push   $0x5b17
    388c:	e8 b5 07 00 00       	call   4046 <unlink>
    3891:	83 c4 10             	add    $0x10,%esp
}
    3894:	90                   	nop
    3895:	c9                   	leave  
    3896:	c3                   	ret    

00003897 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3897:	55                   	push   %ebp
    3898:	89 e5                	mov    %esp,%ebp
    389a:	53                   	push   %ebx
    389b:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    389e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    38a5:	83 ec 08             	sub    $0x8,%esp
    38a8:	68 4c 5c 00 00       	push   $0x5c4c
    38ad:	6a 01                	push   $0x1
    38af:	e8 b5 08 00 00       	call   4169 <printf>
    38b4:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    38b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38be:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38c5:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38ca:	89 c8                	mov    %ecx,%eax
    38cc:	f7 ea                	imul   %edx
    38ce:	c1 fa 06             	sar    $0x6,%edx
    38d1:	89 c8                	mov    %ecx,%eax
    38d3:	c1 f8 1f             	sar    $0x1f,%eax
    38d6:	29 c2                	sub    %eax,%edx
    38d8:	89 d0                	mov    %edx,%eax
    38da:	83 c0 30             	add    $0x30,%eax
    38dd:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38e0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38e3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38e8:	89 d8                	mov    %ebx,%eax
    38ea:	f7 ea                	imul   %edx
    38ec:	c1 fa 06             	sar    $0x6,%edx
    38ef:	89 d8                	mov    %ebx,%eax
    38f1:	c1 f8 1f             	sar    $0x1f,%eax
    38f4:	89 d1                	mov    %edx,%ecx
    38f6:	29 c1                	sub    %eax,%ecx
    38f8:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    38fe:	29 c3                	sub    %eax,%ebx
    3900:	89 d9                	mov    %ebx,%ecx
    3902:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3907:	89 c8                	mov    %ecx,%eax
    3909:	f7 ea                	imul   %edx
    390b:	c1 fa 05             	sar    $0x5,%edx
    390e:	89 c8                	mov    %ecx,%eax
    3910:	c1 f8 1f             	sar    $0x1f,%eax
    3913:	29 c2                	sub    %eax,%edx
    3915:	89 d0                	mov    %edx,%eax
    3917:	83 c0 30             	add    $0x30,%eax
    391a:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    391d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3920:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3925:	89 d8                	mov    %ebx,%eax
    3927:	f7 ea                	imul   %edx
    3929:	c1 fa 05             	sar    $0x5,%edx
    392c:	89 d8                	mov    %ebx,%eax
    392e:	c1 f8 1f             	sar    $0x1f,%eax
    3931:	89 d1                	mov    %edx,%ecx
    3933:	29 c1                	sub    %eax,%ecx
    3935:	6b c1 64             	imul   $0x64,%ecx,%eax
    3938:	29 c3                	sub    %eax,%ebx
    393a:	89 d9                	mov    %ebx,%ecx
    393c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3941:	89 c8                	mov    %ecx,%eax
    3943:	f7 ea                	imul   %edx
    3945:	c1 fa 02             	sar    $0x2,%edx
    3948:	89 c8                	mov    %ecx,%eax
    394a:	c1 f8 1f             	sar    $0x1f,%eax
    394d:	29 c2                	sub    %eax,%edx
    394f:	89 d0                	mov    %edx,%eax
    3951:	83 c0 30             	add    $0x30,%eax
    3954:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3957:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    395a:	ba 67 66 66 66       	mov    $0x66666667,%edx
    395f:	89 c8                	mov    %ecx,%eax
    3961:	f7 ea                	imul   %edx
    3963:	c1 fa 02             	sar    $0x2,%edx
    3966:	89 c8                	mov    %ecx,%eax
    3968:	c1 f8 1f             	sar    $0x1f,%eax
    396b:	29 c2                	sub    %eax,%edx
    396d:	89 d0                	mov    %edx,%eax
    396f:	c1 e0 02             	shl    $0x2,%eax
    3972:	01 d0                	add    %edx,%eax
    3974:	01 c0                	add    %eax,%eax
    3976:	29 c1                	sub    %eax,%ecx
    3978:	89 ca                	mov    %ecx,%edx
    397a:	89 d0                	mov    %edx,%eax
    397c:	83 c0 30             	add    $0x30,%eax
    397f:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3982:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3986:	83 ec 04             	sub    $0x4,%esp
    3989:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    398c:	50                   	push   %eax
    398d:	68 59 5c 00 00       	push   $0x5c59
    3992:	6a 01                	push   $0x1
    3994:	e8 d0 07 00 00       	call   4169 <printf>
    3999:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    399c:	83 ec 08             	sub    $0x8,%esp
    399f:	68 02 02 00 00       	push   $0x202
    39a4:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39a7:	50                   	push   %eax
    39a8:	e8 89 06 00 00       	call   4036 <open>
    39ad:	83 c4 10             	add    $0x10,%esp
    39b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    39b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39b7:	79 18                	jns    39d1 <fsfull+0x13a>
      printf(1, "open %s failed\n", name);
    39b9:	83 ec 04             	sub    $0x4,%esp
    39bc:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39bf:	50                   	push   %eax
    39c0:	68 65 5c 00 00       	push   $0x5c65
    39c5:	6a 01                	push   $0x1
    39c7:	e8 9d 07 00 00       	call   4169 <printf>
    39cc:	83 c4 10             	add    $0x10,%esp
      break;
    39cf:	eb 6b                	jmp    3a3c <fsfull+0x1a5>
    }
    int total = 0;
    39d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39d8:	83 ec 04             	sub    $0x4,%esp
    39db:	68 00 02 00 00       	push   $0x200
    39e0:	68 60 8c 00 00       	push   $0x8c60
    39e5:	ff 75 e8             	pushl  -0x18(%ebp)
    39e8:	e8 29 06 00 00       	call   4016 <write>
    39ed:	83 c4 10             	add    $0x10,%esp
    39f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    39f3:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    39fa:	7e 0c                	jle    3a08 <fsfull+0x171>
        break;
      total += cc;
    39fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    39ff:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a02:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while(1){
    3a06:	eb d0                	jmp    39d8 <fsfull+0x141>
        break;
    3a08:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    3a09:	83 ec 04             	sub    $0x4,%esp
    3a0c:	ff 75 ec             	pushl  -0x14(%ebp)
    3a0f:	68 75 5c 00 00       	push   $0x5c75
    3a14:	6a 01                	push   $0x1
    3a16:	e8 4e 07 00 00       	call   4169 <printf>
    3a1b:	83 c4 10             	add    $0x10,%esp
    close(fd);
    3a1e:	83 ec 0c             	sub    $0xc,%esp
    3a21:	ff 75 e8             	pushl  -0x18(%ebp)
    3a24:	e8 f5 05 00 00       	call   401e <close>
    3a29:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3a2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a30:	74 09                	je     3a3b <fsfull+0x1a4>
  for(nfiles = 0; ; nfiles++){
    3a32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3a36:	e9 83 fe ff ff       	jmp    38be <fsfull+0x27>
      break;
    3a3b:	90                   	nop
  }

  while(nfiles >= 0){
    3a3c:	e9 db 00 00 00       	jmp    3b1c <fsfull+0x285>
    char name[64];
    name[0] = 'f';
    3a41:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a45:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a48:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a4d:	89 c8                	mov    %ecx,%eax
    3a4f:	f7 ea                	imul   %edx
    3a51:	c1 fa 06             	sar    $0x6,%edx
    3a54:	89 c8                	mov    %ecx,%eax
    3a56:	c1 f8 1f             	sar    $0x1f,%eax
    3a59:	29 c2                	sub    %eax,%edx
    3a5b:	89 d0                	mov    %edx,%eax
    3a5d:	83 c0 30             	add    $0x30,%eax
    3a60:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a63:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a66:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a6b:	89 d8                	mov    %ebx,%eax
    3a6d:	f7 ea                	imul   %edx
    3a6f:	c1 fa 06             	sar    $0x6,%edx
    3a72:	89 d8                	mov    %ebx,%eax
    3a74:	c1 f8 1f             	sar    $0x1f,%eax
    3a77:	89 d1                	mov    %edx,%ecx
    3a79:	29 c1                	sub    %eax,%ecx
    3a7b:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a81:	29 c3                	sub    %eax,%ebx
    3a83:	89 d9                	mov    %ebx,%ecx
    3a85:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a8a:	89 c8                	mov    %ecx,%eax
    3a8c:	f7 ea                	imul   %edx
    3a8e:	c1 fa 05             	sar    $0x5,%edx
    3a91:	89 c8                	mov    %ecx,%eax
    3a93:	c1 f8 1f             	sar    $0x1f,%eax
    3a96:	29 c2                	sub    %eax,%edx
    3a98:	89 d0                	mov    %edx,%eax
    3a9a:	83 c0 30             	add    $0x30,%eax
    3a9d:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3aa0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3aa3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3aa8:	89 d8                	mov    %ebx,%eax
    3aaa:	f7 ea                	imul   %edx
    3aac:	c1 fa 05             	sar    $0x5,%edx
    3aaf:	89 d8                	mov    %ebx,%eax
    3ab1:	c1 f8 1f             	sar    $0x1f,%eax
    3ab4:	89 d1                	mov    %edx,%ecx
    3ab6:	29 c1                	sub    %eax,%ecx
    3ab8:	6b c1 64             	imul   $0x64,%ecx,%eax
    3abb:	29 c3                	sub    %eax,%ebx
    3abd:	89 d9                	mov    %ebx,%ecx
    3abf:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ac4:	89 c8                	mov    %ecx,%eax
    3ac6:	f7 ea                	imul   %edx
    3ac8:	c1 fa 02             	sar    $0x2,%edx
    3acb:	89 c8                	mov    %ecx,%eax
    3acd:	c1 f8 1f             	sar    $0x1f,%eax
    3ad0:	29 c2                	sub    %eax,%edx
    3ad2:	89 d0                	mov    %edx,%eax
    3ad4:	83 c0 30             	add    $0x30,%eax
    3ad7:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3ada:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3add:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ae2:	89 c8                	mov    %ecx,%eax
    3ae4:	f7 ea                	imul   %edx
    3ae6:	c1 fa 02             	sar    $0x2,%edx
    3ae9:	89 c8                	mov    %ecx,%eax
    3aeb:	c1 f8 1f             	sar    $0x1f,%eax
    3aee:	29 c2                	sub    %eax,%edx
    3af0:	89 d0                	mov    %edx,%eax
    3af2:	c1 e0 02             	shl    $0x2,%eax
    3af5:	01 d0                	add    %edx,%eax
    3af7:	01 c0                	add    %eax,%eax
    3af9:	29 c1                	sub    %eax,%ecx
    3afb:	89 ca                	mov    %ecx,%edx
    3afd:	89 d0                	mov    %edx,%eax
    3aff:	83 c0 30             	add    $0x30,%eax
    3b02:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b05:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b09:	83 ec 0c             	sub    $0xc,%esp
    3b0c:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b0f:	50                   	push   %eax
    3b10:	e8 31 05 00 00       	call   4046 <unlink>
    3b15:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3b18:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  while(nfiles >= 0){
    3b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b20:	0f 89 1b ff ff ff    	jns    3a41 <fsfull+0x1aa>
  }

  printf(1, "fsfull test finished\n");
    3b26:	83 ec 08             	sub    $0x8,%esp
    3b29:	68 85 5c 00 00       	push   $0x5c85
    3b2e:	6a 01                	push   $0x1
    3b30:	e8 34 06 00 00       	call   4169 <printf>
    3b35:	83 c4 10             	add    $0x10,%esp
}
    3b38:	90                   	nop
    3b39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b3c:	c9                   	leave  
    3b3d:	c3                   	ret    

00003b3e <uio>:

void
uio()
{
    3b3e:	55                   	push   %ebp
    3b3f:	89 e5                	mov    %esp,%ebp
    3b41:	83 ec 18             	sub    $0x18,%esp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    3b44:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
  uchar val = 0;
    3b4a:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
  int pid;

  printf(1, "uio test\n");
    3b4e:	83 ec 08             	sub    $0x8,%esp
    3b51:	68 9b 5c 00 00       	push   $0x5c9b
    3b56:	6a 01                	push   $0x1
    3b58:	e8 0c 06 00 00       	call   4169 <printf>
    3b5d:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3b60:	e8 89 04 00 00       	call   3fee <fork>
    3b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3b68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3b6c:	75 3a                	jne    3ba8 <uio+0x6a>
    port = RTC_ADDR;
    3b6e:	66 c7 45 f6 70 00    	movw   $0x70,-0xa(%ebp)
    val = 0x09;  /* year */
    3b74:	c6 45 f5 09          	movb   $0x9,-0xb(%ebp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3b78:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    3b7c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
    3b80:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    3b81:	66 c7 45 f6 71 00    	movw   $0x71,-0xa(%ebp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3b87:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    3b8b:	89 c2                	mov    %eax,%edx
    3b8d:	ec                   	in     (%dx),%al
    3b8e:	88 45 f5             	mov    %al,-0xb(%ebp)
    printf(1, "uio: uio succeeded; test FAILED\n");
    3b91:	83 ec 08             	sub    $0x8,%esp
    3b94:	68 a8 5c 00 00       	push   $0x5ca8
    3b99:	6a 01                	push   $0x1
    3b9b:	e8 c9 05 00 00       	call   4169 <printf>
    3ba0:	83 c4 10             	add    $0x10,%esp
    exit();
    3ba3:	e8 4e 04 00 00       	call   3ff6 <exit>
  } else if(pid < 0){
    3ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3bac:	79 17                	jns    3bc5 <uio+0x87>
    printf (1, "fork failed\n");
    3bae:	83 ec 08             	sub    $0x8,%esp
    3bb1:	68 c1 45 00 00       	push   $0x45c1
    3bb6:	6a 01                	push   $0x1
    3bb8:	e8 ac 05 00 00       	call   4169 <printf>
    3bbd:	83 c4 10             	add    $0x10,%esp
    exit();
    3bc0:	e8 31 04 00 00       	call   3ff6 <exit>
  }
  wait();
    3bc5:	e8 34 04 00 00       	call   3ffe <wait>
  printf(1, "uio test done\n");
    3bca:	83 ec 08             	sub    $0x8,%esp
    3bcd:	68 c9 5c 00 00       	push   $0x5cc9
    3bd2:	6a 01                	push   $0x1
    3bd4:	e8 90 05 00 00       	call   4169 <printf>
    3bd9:	83 c4 10             	add    $0x10,%esp
}
    3bdc:	90                   	nop
    3bdd:	c9                   	leave  
    3bde:	c3                   	ret    

00003bdf <argptest>:

void argptest()
{
    3bdf:	55                   	push   %ebp
    3be0:	89 e5                	mov    %esp,%ebp
    3be2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3be5:	83 ec 08             	sub    $0x8,%esp
    3be8:	6a 00                	push   $0x0
    3bea:	68 d8 5c 00 00       	push   $0x5cd8
    3bef:	e8 42 04 00 00       	call   4036 <open>
    3bf4:	83 c4 10             	add    $0x10,%esp
    3bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0) {
    3bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3bfe:	79 17                	jns    3c17 <argptest+0x38>
    printf(2, "open failed\n");
    3c00:	83 ec 08             	sub    $0x8,%esp
    3c03:	68 dd 5c 00 00       	push   $0x5cdd
    3c08:	6a 02                	push   $0x2
    3c0a:	e8 5a 05 00 00       	call   4169 <printf>
    3c0f:	83 c4 10             	add    $0x10,%esp
    exit();
    3c12:	e8 df 03 00 00       	call   3ff6 <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    3c17:	83 ec 0c             	sub    $0xc,%esp
    3c1a:	6a 00                	push   $0x0
    3c1c:	e8 5d 04 00 00       	call   407e <sbrk>
    3c21:	83 c4 10             	add    $0x10,%esp
    3c24:	83 e8 01             	sub    $0x1,%eax
    3c27:	83 ec 04             	sub    $0x4,%esp
    3c2a:	6a ff                	push   $0xffffffff
    3c2c:	50                   	push   %eax
    3c2d:	ff 75 f4             	pushl  -0xc(%ebp)
    3c30:	e8 d9 03 00 00       	call   400e <read>
    3c35:	83 c4 10             	add    $0x10,%esp
  close(fd);
    3c38:	83 ec 0c             	sub    $0xc,%esp
    3c3b:	ff 75 f4             	pushl  -0xc(%ebp)
    3c3e:	e8 db 03 00 00       	call   401e <close>
    3c43:	83 c4 10             	add    $0x10,%esp
  printf(1, "arg test passed\n");
    3c46:	83 ec 08             	sub    $0x8,%esp
    3c49:	68 ea 5c 00 00       	push   $0x5cea
    3c4e:	6a 01                	push   $0x1
    3c50:	e8 14 05 00 00       	call   4169 <printf>
    3c55:	83 c4 10             	add    $0x10,%esp
}
    3c58:	90                   	nop
    3c59:	c9                   	leave  
    3c5a:	c3                   	ret    

00003c5b <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3c5b:	55                   	push   %ebp
    3c5c:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3c5e:	a1 7c 64 00 00       	mov    0x647c,%eax
    3c63:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3c69:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3c6e:	a3 7c 64 00 00       	mov    %eax,0x647c
  return randstate;
    3c73:	a1 7c 64 00 00       	mov    0x647c,%eax
}
    3c78:	5d                   	pop    %ebp
    3c79:	c3                   	ret    

00003c7a <main>:

int
main(int argc, char *argv[])
{
    3c7a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3c7e:	83 e4 f0             	and    $0xfffffff0,%esp
    3c81:	ff 71 fc             	pushl  -0x4(%ecx)
    3c84:	55                   	push   %ebp
    3c85:	89 e5                	mov    %esp,%ebp
    3c87:	51                   	push   %ecx
    3c88:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3c8b:	83 ec 08             	sub    $0x8,%esp
    3c8e:	68 fb 5c 00 00       	push   $0x5cfb
    3c93:	6a 01                	push   $0x1
    3c95:	e8 cf 04 00 00       	call   4169 <printf>
    3c9a:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3c9d:	83 ec 08             	sub    $0x8,%esp
    3ca0:	6a 00                	push   $0x0
    3ca2:	68 0f 5d 00 00       	push   $0x5d0f
    3ca7:	e8 8a 03 00 00       	call   4036 <open>
    3cac:	83 c4 10             	add    $0x10,%esp
    3caf:	85 c0                	test   %eax,%eax
    3cb1:	78 17                	js     3cca <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3cb3:	83 ec 08             	sub    $0x8,%esp
    3cb6:	68 20 5d 00 00       	push   $0x5d20
    3cbb:	6a 01                	push   $0x1
    3cbd:	e8 a7 04 00 00       	call   4169 <printf>
    3cc2:	83 c4 10             	add    $0x10,%esp
    exit();
    3cc5:	e8 2c 03 00 00       	call   3ff6 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3cca:	83 ec 08             	sub    $0x8,%esp
    3ccd:	68 00 02 00 00       	push   $0x200
    3cd2:	68 0f 5d 00 00       	push   $0x5d0f
    3cd7:	e8 5a 03 00 00       	call   4036 <open>
    3cdc:	83 c4 10             	add    $0x10,%esp
    3cdf:	83 ec 0c             	sub    $0xc,%esp
    3ce2:	50                   	push   %eax
    3ce3:	e8 36 03 00 00       	call   401e <close>
    3ce8:	83 c4 10             	add    $0x10,%esp

  argptest();
    3ceb:	e8 ef fe ff ff       	call   3bdf <argptest>
  createdelete();
    3cf0:	e8 b5 d5 ff ff       	call   12aa <createdelete>
  linkunlink();
    3cf5:	e8 d6 df ff ff       	call   1cd0 <linkunlink>
  concreate();
    3cfa:	e8 21 dc ff ff       	call   1920 <concreate>
  fourfiles();
    3cff:	e8 55 d3 ff ff       	call   1059 <fourfiles>
  sharedfd();
    3d04:	e8 6d d1 ff ff       	call   e76 <sharedfd>

  bigargtest();
    3d09:	e8 4d fa ff ff       	call   375b <bigargtest>
  bigwrite();
    3d0e:	e8 af e9 ff ff       	call   26c2 <bigwrite>
  bigargtest();
    3d13:	e8 43 fa ff ff       	call   375b <bigargtest>
  bsstest();
    3d18:	e8 c8 f9 ff ff       	call   36e5 <bsstest>
  sbrktest();
    3d1d:	e8 d3 f3 ff ff       	call   30f5 <sbrktest>
  validatetest();
    3d22:	e8 e0 f8 ff ff       	call   3607 <validatetest>

  opentest();
    3d27:	e8 d3 c5 ff ff       	call   2ff <opentest>
  writetest();
    3d2c:	e8 7d c6 ff ff       	call   3ae <writetest>
  writetest1();
    3d31:	e8 88 c8 ff ff       	call   5be <writetest1>
  createtest();
    3d36:	e8 7f ca ff ff       	call   7ba <createtest>

  openiputtest();
    3d3b:	e8 b0 c4 ff ff       	call   1f0 <openiputtest>
  exitiputtest();
    3d40:	e8 ac c3 ff ff       	call   f1 <exitiputtest>
  iputtest();
    3d45:	e8 b6 c2 ff ff       	call   0 <iputtest>

  mem();
    3d4a:	e8 36 d0 ff ff       	call   d85 <mem>
  pipe1();
    3d4f:	e8 6d cc ff ff       	call   9c1 <pipe1>
  preempt();
    3d54:	e8 51 ce ff ff       	call   baa <preempt>
  exitwait();
    3d59:	e8 af cf ff ff       	call   d0d <exitwait>

  rmdot();
    3d5e:	e8 d1 ed ff ff       	call   2b34 <rmdot>
  fourteen();
    3d63:	e8 70 ec ff ff       	call   29d8 <fourteen>
  bigfile();
    3d68:	e8 53 ea ff ff       	call   27c0 <bigfile>
  subdir();
    3d6d:	e8 0c e2 ff ff       	call   1f7e <subdir>
  linktest();
    3d72:	e8 67 d9 ff ff       	call   16de <linktest>
  unlinkread();
    3d77:	e8 a0 d7 ff ff       	call   151c <unlinkread>
  dirfile();
    3d7c:	e8 38 ef ff ff       	call   2cb9 <dirfile>
  iref();
    3d81:	e8 6b f1 ff ff       	call   2ef1 <iref>
  forktest();
    3d86:	e8 a0 f2 ff ff       	call   302b <forktest>
  bigdir(); // slow
    3d8b:	e8 79 e0 ff ff       	call   1e09 <bigdir>

  uio();
    3d90:	e8 a9 fd ff ff       	call   3b3e <uio>

  exectest();
    3d95:	e8 d4 cb ff ff       	call   96e <exectest>

  exit();
    3d9a:	e8 57 02 00 00       	call   3ff6 <exit>

00003d9f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3d9f:	55                   	push   %ebp
    3da0:	89 e5                	mov    %esp,%ebp
    3da2:	57                   	push   %edi
    3da3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3da4:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3da7:	8b 55 10             	mov    0x10(%ebp),%edx
    3daa:	8b 45 0c             	mov    0xc(%ebp),%eax
    3dad:	89 cb                	mov    %ecx,%ebx
    3daf:	89 df                	mov    %ebx,%edi
    3db1:	89 d1                	mov    %edx,%ecx
    3db3:	fc                   	cld    
    3db4:	f3 aa                	rep stos %al,%es:(%edi)
    3db6:	89 ca                	mov    %ecx,%edx
    3db8:	89 fb                	mov    %edi,%ebx
    3dba:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3dbd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3dc0:	90                   	nop
    3dc1:	5b                   	pop    %ebx
    3dc2:	5f                   	pop    %edi
    3dc3:	5d                   	pop    %ebp
    3dc4:	c3                   	ret    

00003dc5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3dc5:	55                   	push   %ebp
    3dc6:	89 e5                	mov    %esp,%ebp
    3dc8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3dcb:	8b 45 08             	mov    0x8(%ebp),%eax
    3dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3dd1:	90                   	nop
    3dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
    3dd5:	8d 42 01             	lea    0x1(%edx),%eax
    3dd8:	89 45 0c             	mov    %eax,0xc(%ebp)
    3ddb:	8b 45 08             	mov    0x8(%ebp),%eax
    3dde:	8d 48 01             	lea    0x1(%eax),%ecx
    3de1:	89 4d 08             	mov    %ecx,0x8(%ebp)
    3de4:	0f b6 12             	movzbl (%edx),%edx
    3de7:	88 10                	mov    %dl,(%eax)
    3de9:	0f b6 00             	movzbl (%eax),%eax
    3dec:	84 c0                	test   %al,%al
    3dee:	75 e2                	jne    3dd2 <strcpy+0xd>
    ;
  return os;
    3df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3df3:	c9                   	leave  
    3df4:	c3                   	ret    

00003df5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3df5:	55                   	push   %ebp
    3df6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3df8:	eb 08                	jmp    3e02 <strcmp+0xd>
    p++, q++;
    3dfa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3dfe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    3e02:	8b 45 08             	mov    0x8(%ebp),%eax
    3e05:	0f b6 00             	movzbl (%eax),%eax
    3e08:	84 c0                	test   %al,%al
    3e0a:	74 10                	je     3e1c <strcmp+0x27>
    3e0c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e0f:	0f b6 10             	movzbl (%eax),%edx
    3e12:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e15:	0f b6 00             	movzbl (%eax),%eax
    3e18:	38 c2                	cmp    %al,%dl
    3e1a:	74 de                	je     3dfa <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    3e1c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e1f:	0f b6 00             	movzbl (%eax),%eax
    3e22:	0f b6 d0             	movzbl %al,%edx
    3e25:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e28:	0f b6 00             	movzbl (%eax),%eax
    3e2b:	0f b6 c0             	movzbl %al,%eax
    3e2e:	29 c2                	sub    %eax,%edx
    3e30:	89 d0                	mov    %edx,%eax
}
    3e32:	5d                   	pop    %ebp
    3e33:	c3                   	ret    

00003e34 <strlen>:

uint
strlen(char *s)
{
    3e34:	55                   	push   %ebp
    3e35:	89 e5                	mov    %esp,%ebp
    3e37:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3e3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3e41:	eb 04                	jmp    3e47 <strlen+0x13>
    3e43:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3e47:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e4a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e4d:	01 d0                	add    %edx,%eax
    3e4f:	0f b6 00             	movzbl (%eax),%eax
    3e52:	84 c0                	test   %al,%al
    3e54:	75 ed                	jne    3e43 <strlen+0xf>
    ;
  return n;
    3e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e59:	c9                   	leave  
    3e5a:	c3                   	ret    

00003e5b <memset>:

void*
memset(void *dst, int c, uint n)
{
    3e5b:	55                   	push   %ebp
    3e5c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3e5e:	8b 45 10             	mov    0x10(%ebp),%eax
    3e61:	50                   	push   %eax
    3e62:	ff 75 0c             	pushl  0xc(%ebp)
    3e65:	ff 75 08             	pushl  0x8(%ebp)
    3e68:	e8 32 ff ff ff       	call   3d9f <stosb>
    3e6d:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3e70:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e73:	c9                   	leave  
    3e74:	c3                   	ret    

00003e75 <strchr>:

char*
strchr(const char *s, char c)
{
    3e75:	55                   	push   %ebp
    3e76:	89 e5                	mov    %esp,%ebp
    3e78:	83 ec 04             	sub    $0x4,%esp
    3e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e7e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3e81:	eb 14                	jmp    3e97 <strchr+0x22>
    if(*s == c)
    3e83:	8b 45 08             	mov    0x8(%ebp),%eax
    3e86:	0f b6 00             	movzbl (%eax),%eax
    3e89:	38 45 fc             	cmp    %al,-0x4(%ebp)
    3e8c:	75 05                	jne    3e93 <strchr+0x1e>
      return (char*)s;
    3e8e:	8b 45 08             	mov    0x8(%ebp),%eax
    3e91:	eb 13                	jmp    3ea6 <strchr+0x31>
  for(; *s; s++)
    3e93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3e97:	8b 45 08             	mov    0x8(%ebp),%eax
    3e9a:	0f b6 00             	movzbl (%eax),%eax
    3e9d:	84 c0                	test   %al,%al
    3e9f:	75 e2                	jne    3e83 <strchr+0xe>
  return 0;
    3ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3ea6:	c9                   	leave  
    3ea7:	c3                   	ret    

00003ea8 <gets>:

char*
gets(char *buf, int max)
{
    3ea8:	55                   	push   %ebp
    3ea9:	89 e5                	mov    %esp,%ebp
    3eab:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3eb5:	eb 42                	jmp    3ef9 <gets+0x51>
    cc = read(0, &c, 1);
    3eb7:	83 ec 04             	sub    $0x4,%esp
    3eba:	6a 01                	push   $0x1
    3ebc:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3ebf:	50                   	push   %eax
    3ec0:	6a 00                	push   $0x0
    3ec2:	e8 47 01 00 00       	call   400e <read>
    3ec7:	83 c4 10             	add    $0x10,%esp
    3eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ed1:	7e 33                	jle    3f06 <gets+0x5e>
      break;
    buf[i++] = c;
    3ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ed6:	8d 50 01             	lea    0x1(%eax),%edx
    3ed9:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3edc:	89 c2                	mov    %eax,%edx
    3ede:	8b 45 08             	mov    0x8(%ebp),%eax
    3ee1:	01 c2                	add    %eax,%edx
    3ee3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3ee7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3ee9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3eed:	3c 0a                	cmp    $0xa,%al
    3eef:	74 16                	je     3f07 <gets+0x5f>
    3ef1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3ef5:	3c 0d                	cmp    $0xd,%al
    3ef7:	74 0e                	je     3f07 <gets+0x5f>
  for(i=0; i+1 < max; ){
    3ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3efc:	83 c0 01             	add    $0x1,%eax
    3eff:	39 45 0c             	cmp    %eax,0xc(%ebp)
    3f02:	7f b3                	jg     3eb7 <gets+0xf>
    3f04:	eb 01                	jmp    3f07 <gets+0x5f>
      break;
    3f06:	90                   	nop
      break;
  }
  buf[i] = '\0';
    3f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3f0a:	8b 45 08             	mov    0x8(%ebp),%eax
    3f0d:	01 d0                	add    %edx,%eax
    3f0f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3f12:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3f15:	c9                   	leave  
    3f16:	c3                   	ret    

00003f17 <stat>:

int
stat(char *n, struct stat *st)
{
    3f17:	55                   	push   %ebp
    3f18:	89 e5                	mov    %esp,%ebp
    3f1a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3f1d:	83 ec 08             	sub    $0x8,%esp
    3f20:	6a 00                	push   $0x0
    3f22:	ff 75 08             	pushl  0x8(%ebp)
    3f25:	e8 0c 01 00 00       	call   4036 <open>
    3f2a:	83 c4 10             	add    $0x10,%esp
    3f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3f34:	79 07                	jns    3f3d <stat+0x26>
    return -1;
    3f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3f3b:	eb 25                	jmp    3f62 <stat+0x4b>
  r = fstat(fd, st);
    3f3d:	83 ec 08             	sub    $0x8,%esp
    3f40:	ff 75 0c             	pushl  0xc(%ebp)
    3f43:	ff 75 f4             	pushl  -0xc(%ebp)
    3f46:	e8 03 01 00 00       	call   404e <fstat>
    3f4b:	83 c4 10             	add    $0x10,%esp
    3f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3f51:	83 ec 0c             	sub    $0xc,%esp
    3f54:	ff 75 f4             	pushl  -0xc(%ebp)
    3f57:	e8 c2 00 00 00       	call   401e <close>
    3f5c:	83 c4 10             	add    $0x10,%esp
  return r;
    3f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3f62:	c9                   	leave  
    3f63:	c3                   	ret    

00003f64 <atoi>:

int
atoi(const char *s)
{
    3f64:	55                   	push   %ebp
    3f65:	89 e5                	mov    %esp,%ebp
    3f67:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3f71:	eb 25                	jmp    3f98 <atoi+0x34>
    n = n*10 + *s++ - '0';
    3f73:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3f76:	89 d0                	mov    %edx,%eax
    3f78:	c1 e0 02             	shl    $0x2,%eax
    3f7b:	01 d0                	add    %edx,%eax
    3f7d:	01 c0                	add    %eax,%eax
    3f7f:	89 c1                	mov    %eax,%ecx
    3f81:	8b 45 08             	mov    0x8(%ebp),%eax
    3f84:	8d 50 01             	lea    0x1(%eax),%edx
    3f87:	89 55 08             	mov    %edx,0x8(%ebp)
    3f8a:	0f b6 00             	movzbl (%eax),%eax
    3f8d:	0f be c0             	movsbl %al,%eax
    3f90:	01 c8                	add    %ecx,%eax
    3f92:	83 e8 30             	sub    $0x30,%eax
    3f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3f98:	8b 45 08             	mov    0x8(%ebp),%eax
    3f9b:	0f b6 00             	movzbl (%eax),%eax
    3f9e:	3c 2f                	cmp    $0x2f,%al
    3fa0:	7e 0a                	jle    3fac <atoi+0x48>
    3fa2:	8b 45 08             	mov    0x8(%ebp),%eax
    3fa5:	0f b6 00             	movzbl (%eax),%eax
    3fa8:	3c 39                	cmp    $0x39,%al
    3faa:	7e c7                	jle    3f73 <atoi+0xf>
  return n;
    3fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3faf:	c9                   	leave  
    3fb0:	c3                   	ret    

00003fb1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3fb1:	55                   	push   %ebp
    3fb2:	89 e5                	mov    %esp,%ebp
    3fb4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    3fb7:	8b 45 08             	mov    0x8(%ebp),%eax
    3fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3fc3:	eb 17                	jmp    3fdc <memmove+0x2b>
    *dst++ = *src++;
    3fc5:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3fc8:	8d 42 01             	lea    0x1(%edx),%eax
    3fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    3fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fd1:	8d 48 01             	lea    0x1(%eax),%ecx
    3fd4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    3fd7:	0f b6 12             	movzbl (%edx),%edx
    3fda:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    3fdc:	8b 45 10             	mov    0x10(%ebp),%eax
    3fdf:	8d 50 ff             	lea    -0x1(%eax),%edx
    3fe2:	89 55 10             	mov    %edx,0x10(%ebp)
    3fe5:	85 c0                	test   %eax,%eax
    3fe7:	7f dc                	jg     3fc5 <memmove+0x14>
  return vdst;
    3fe9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3fec:	c9                   	leave  
    3fed:	c3                   	ret    

00003fee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3fee:	b8 01 00 00 00       	mov    $0x1,%eax
    3ff3:	cd 40                	int    $0x40
    3ff5:	c3                   	ret    

00003ff6 <exit>:
SYSCALL(exit)
    3ff6:	b8 02 00 00 00       	mov    $0x2,%eax
    3ffb:	cd 40                	int    $0x40
    3ffd:	c3                   	ret    

00003ffe <wait>:
SYSCALL(wait)
    3ffe:	b8 03 00 00 00       	mov    $0x3,%eax
    4003:	cd 40                	int    $0x40
    4005:	c3                   	ret    

00004006 <pipe>:
SYSCALL(pipe)
    4006:	b8 04 00 00 00       	mov    $0x4,%eax
    400b:	cd 40                	int    $0x40
    400d:	c3                   	ret    

0000400e <read>:
SYSCALL(read)
    400e:	b8 05 00 00 00       	mov    $0x5,%eax
    4013:	cd 40                	int    $0x40
    4015:	c3                   	ret    

00004016 <write>:
SYSCALL(write)
    4016:	b8 10 00 00 00       	mov    $0x10,%eax
    401b:	cd 40                	int    $0x40
    401d:	c3                   	ret    

0000401e <close>:
SYSCALL(close)
    401e:	b8 15 00 00 00       	mov    $0x15,%eax
    4023:	cd 40                	int    $0x40
    4025:	c3                   	ret    

00004026 <kill>:
SYSCALL(kill)
    4026:	b8 06 00 00 00       	mov    $0x6,%eax
    402b:	cd 40                	int    $0x40
    402d:	c3                   	ret    

0000402e <exec>:
SYSCALL(exec)
    402e:	b8 07 00 00 00       	mov    $0x7,%eax
    4033:	cd 40                	int    $0x40
    4035:	c3                   	ret    

00004036 <open>:
SYSCALL(open)
    4036:	b8 0f 00 00 00       	mov    $0xf,%eax
    403b:	cd 40                	int    $0x40
    403d:	c3                   	ret    

0000403e <mknod>:
SYSCALL(mknod)
    403e:	b8 11 00 00 00       	mov    $0x11,%eax
    4043:	cd 40                	int    $0x40
    4045:	c3                   	ret    

00004046 <unlink>:
SYSCALL(unlink)
    4046:	b8 12 00 00 00       	mov    $0x12,%eax
    404b:	cd 40                	int    $0x40
    404d:	c3                   	ret    

0000404e <fstat>:
SYSCALL(fstat)
    404e:	b8 08 00 00 00       	mov    $0x8,%eax
    4053:	cd 40                	int    $0x40
    4055:	c3                   	ret    

00004056 <link>:
SYSCALL(link)
    4056:	b8 13 00 00 00       	mov    $0x13,%eax
    405b:	cd 40                	int    $0x40
    405d:	c3                   	ret    

0000405e <mkdir>:
SYSCALL(mkdir)
    405e:	b8 14 00 00 00       	mov    $0x14,%eax
    4063:	cd 40                	int    $0x40
    4065:	c3                   	ret    

00004066 <chdir>:
SYSCALL(chdir)
    4066:	b8 09 00 00 00       	mov    $0x9,%eax
    406b:	cd 40                	int    $0x40
    406d:	c3                   	ret    

0000406e <dup>:
SYSCALL(dup)
    406e:	b8 0a 00 00 00       	mov    $0xa,%eax
    4073:	cd 40                	int    $0x40
    4075:	c3                   	ret    

00004076 <getpid>:
SYSCALL(getpid)
    4076:	b8 0b 00 00 00       	mov    $0xb,%eax
    407b:	cd 40                	int    $0x40
    407d:	c3                   	ret    

0000407e <sbrk>:
SYSCALL(sbrk)
    407e:	b8 0c 00 00 00       	mov    $0xc,%eax
    4083:	cd 40                	int    $0x40
    4085:	c3                   	ret    

00004086 <sleep>:
SYSCALL(sleep)
    4086:	b8 0d 00 00 00       	mov    $0xd,%eax
    408b:	cd 40                	int    $0x40
    408d:	c3                   	ret    

0000408e <uptime>:
SYSCALL(uptime)
    408e:	b8 0e 00 00 00       	mov    $0xe,%eax
    4093:	cd 40                	int    $0x40
    4095:	c3                   	ret    

00004096 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    4096:	55                   	push   %ebp
    4097:	89 e5                	mov    %esp,%ebp
    4099:	83 ec 18             	sub    $0x18,%esp
    409c:	8b 45 0c             	mov    0xc(%ebp),%eax
    409f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    40a2:	83 ec 04             	sub    $0x4,%esp
    40a5:	6a 01                	push   $0x1
    40a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
    40aa:	50                   	push   %eax
    40ab:	ff 75 08             	pushl  0x8(%ebp)
    40ae:	e8 63 ff ff ff       	call   4016 <write>
    40b3:	83 c4 10             	add    $0x10,%esp
}
    40b6:	90                   	nop
    40b7:	c9                   	leave  
    40b8:	c3                   	ret    

000040b9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    40b9:	55                   	push   %ebp
    40ba:	89 e5                	mov    %esp,%ebp
    40bc:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    40bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    40c6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    40ca:	74 17                	je     40e3 <printint+0x2a>
    40cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    40d0:	79 11                	jns    40e3 <printint+0x2a>
    neg = 1;
    40d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    40d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    40dc:	f7 d8                	neg    %eax
    40de:	89 45 ec             	mov    %eax,-0x14(%ebp)
    40e1:	eb 06                	jmp    40e9 <printint+0x30>
  } else {
    x = xx;
    40e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    40e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    40e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    40f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
    40f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    40f6:	ba 00 00 00 00       	mov    $0x0,%edx
    40fb:	f7 f1                	div    %ecx
    40fd:	89 d1                	mov    %edx,%ecx
    40ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4102:	8d 50 01             	lea    0x1(%eax),%edx
    4105:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4108:	0f b6 91 80 64 00 00 	movzbl 0x6480(%ecx),%edx
    410f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    4113:	8b 4d 10             	mov    0x10(%ebp),%ecx
    4116:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4119:	ba 00 00 00 00       	mov    $0x0,%edx
    411e:	f7 f1                	div    %ecx
    4120:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4123:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4127:	75 c7                	jne    40f0 <printint+0x37>
  if(neg)
    4129:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    412d:	74 2d                	je     415c <printint+0xa3>
    buf[i++] = '-';
    412f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4132:	8d 50 01             	lea    0x1(%eax),%edx
    4135:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4138:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    413d:	eb 1d                	jmp    415c <printint+0xa3>
    putc(fd, buf[i]);
    413f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4142:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4145:	01 d0                	add    %edx,%eax
    4147:	0f b6 00             	movzbl (%eax),%eax
    414a:	0f be c0             	movsbl %al,%eax
    414d:	83 ec 08             	sub    $0x8,%esp
    4150:	50                   	push   %eax
    4151:	ff 75 08             	pushl  0x8(%ebp)
    4154:	e8 3d ff ff ff       	call   4096 <putc>
    4159:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    415c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4164:	79 d9                	jns    413f <printint+0x86>
}
    4166:	90                   	nop
    4167:	c9                   	leave  
    4168:	c3                   	ret    

00004169 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4169:	55                   	push   %ebp
    416a:	89 e5                	mov    %esp,%ebp
    416c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    416f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4176:	8d 45 0c             	lea    0xc(%ebp),%eax
    4179:	83 c0 04             	add    $0x4,%eax
    417c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    417f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4186:	e9 59 01 00 00       	jmp    42e4 <printf+0x17b>
    c = fmt[i] & 0xff;
    418b:	8b 55 0c             	mov    0xc(%ebp),%edx
    418e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4191:	01 d0                	add    %edx,%eax
    4193:	0f b6 00             	movzbl (%eax),%eax
    4196:	0f be c0             	movsbl %al,%eax
    4199:	25 ff 00 00 00       	and    $0xff,%eax
    419e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    41a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    41a5:	75 2c                	jne    41d3 <printf+0x6a>
      if(c == '%'){
    41a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41ab:	75 0c                	jne    41b9 <printf+0x50>
        state = '%';
    41ad:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    41b4:	e9 27 01 00 00       	jmp    42e0 <printf+0x177>
      } else {
        putc(fd, c);
    41b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41bc:	0f be c0             	movsbl %al,%eax
    41bf:	83 ec 08             	sub    $0x8,%esp
    41c2:	50                   	push   %eax
    41c3:	ff 75 08             	pushl  0x8(%ebp)
    41c6:	e8 cb fe ff ff       	call   4096 <putc>
    41cb:	83 c4 10             	add    $0x10,%esp
    41ce:	e9 0d 01 00 00       	jmp    42e0 <printf+0x177>
      }
    } else if(state == '%'){
    41d3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    41d7:	0f 85 03 01 00 00    	jne    42e0 <printf+0x177>
      if(c == 'd'){
    41dd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    41e1:	75 1e                	jne    4201 <printf+0x98>
        printint(fd, *ap, 10, 1);
    41e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    41e6:	8b 00                	mov    (%eax),%eax
    41e8:	6a 01                	push   $0x1
    41ea:	6a 0a                	push   $0xa
    41ec:	50                   	push   %eax
    41ed:	ff 75 08             	pushl  0x8(%ebp)
    41f0:	e8 c4 fe ff ff       	call   40b9 <printint>
    41f5:	83 c4 10             	add    $0x10,%esp
        ap++;
    41f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    41fc:	e9 d8 00 00 00       	jmp    42d9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    4201:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4205:	74 06                	je     420d <printf+0xa4>
    4207:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    420b:	75 1e                	jne    422b <printf+0xc2>
        printint(fd, *ap, 16, 0);
    420d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4210:	8b 00                	mov    (%eax),%eax
    4212:	6a 00                	push   $0x0
    4214:	6a 10                	push   $0x10
    4216:	50                   	push   %eax
    4217:	ff 75 08             	pushl  0x8(%ebp)
    421a:	e8 9a fe ff ff       	call   40b9 <printint>
    421f:	83 c4 10             	add    $0x10,%esp
        ap++;
    4222:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4226:	e9 ae 00 00 00       	jmp    42d9 <printf+0x170>
      } else if(c == 's'){
    422b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    422f:	75 43                	jne    4274 <printf+0x10b>
        s = (char*)*ap;
    4231:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4234:	8b 00                	mov    (%eax),%eax
    4236:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4239:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    423d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4241:	75 25                	jne    4268 <printf+0xff>
          s = "(null)";
    4243:	c7 45 f4 4a 5d 00 00 	movl   $0x5d4a,-0xc(%ebp)
        while(*s != 0){
    424a:	eb 1c                	jmp    4268 <printf+0xff>
          putc(fd, *s);
    424c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    424f:	0f b6 00             	movzbl (%eax),%eax
    4252:	0f be c0             	movsbl %al,%eax
    4255:	83 ec 08             	sub    $0x8,%esp
    4258:	50                   	push   %eax
    4259:	ff 75 08             	pushl  0x8(%ebp)
    425c:	e8 35 fe ff ff       	call   4096 <putc>
    4261:	83 c4 10             	add    $0x10,%esp
          s++;
    4264:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    4268:	8b 45 f4             	mov    -0xc(%ebp),%eax
    426b:	0f b6 00             	movzbl (%eax),%eax
    426e:	84 c0                	test   %al,%al
    4270:	75 da                	jne    424c <printf+0xe3>
    4272:	eb 65                	jmp    42d9 <printf+0x170>
        }
      } else if(c == 'c'){
    4274:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4278:	75 1d                	jne    4297 <printf+0x12e>
        putc(fd, *ap);
    427a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    427d:	8b 00                	mov    (%eax),%eax
    427f:	0f be c0             	movsbl %al,%eax
    4282:	83 ec 08             	sub    $0x8,%esp
    4285:	50                   	push   %eax
    4286:	ff 75 08             	pushl  0x8(%ebp)
    4289:	e8 08 fe ff ff       	call   4096 <putc>
    428e:	83 c4 10             	add    $0x10,%esp
        ap++;
    4291:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4295:	eb 42                	jmp    42d9 <printf+0x170>
      } else if(c == '%'){
    4297:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    429b:	75 17                	jne    42b4 <printf+0x14b>
        putc(fd, c);
    429d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    42a0:	0f be c0             	movsbl %al,%eax
    42a3:	83 ec 08             	sub    $0x8,%esp
    42a6:	50                   	push   %eax
    42a7:	ff 75 08             	pushl  0x8(%ebp)
    42aa:	e8 e7 fd ff ff       	call   4096 <putc>
    42af:	83 c4 10             	add    $0x10,%esp
    42b2:	eb 25                	jmp    42d9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    42b4:	83 ec 08             	sub    $0x8,%esp
    42b7:	6a 25                	push   $0x25
    42b9:	ff 75 08             	pushl  0x8(%ebp)
    42bc:	e8 d5 fd ff ff       	call   4096 <putc>
    42c1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    42c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    42c7:	0f be c0             	movsbl %al,%eax
    42ca:	83 ec 08             	sub    $0x8,%esp
    42cd:	50                   	push   %eax
    42ce:	ff 75 08             	pushl  0x8(%ebp)
    42d1:	e8 c0 fd ff ff       	call   4096 <putc>
    42d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    42d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    42e0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    42e4:	8b 55 0c             	mov    0xc(%ebp),%edx
    42e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42ea:	01 d0                	add    %edx,%eax
    42ec:	0f b6 00             	movzbl (%eax),%eax
    42ef:	84 c0                	test   %al,%al
    42f1:	0f 85 94 fe ff ff    	jne    418b <printf+0x22>
    }
  }
}
    42f7:	90                   	nop
    42f8:	c9                   	leave  
    42f9:	c3                   	ret    

000042fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    42fa:	55                   	push   %ebp
    42fb:	89 e5                	mov    %esp,%ebp
    42fd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4300:	8b 45 08             	mov    0x8(%ebp),%eax
    4303:	83 e8 08             	sub    $0x8,%eax
    4306:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4309:	a1 28 65 00 00       	mov    0x6528,%eax
    430e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4311:	eb 24                	jmp    4337 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4313:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4316:	8b 00                	mov    (%eax),%eax
    4318:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    431b:	72 12                	jb     432f <free+0x35>
    431d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4320:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4323:	77 24                	ja     4349 <free+0x4f>
    4325:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4328:	8b 00                	mov    (%eax),%eax
    432a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    432d:	72 1a                	jb     4349 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    432f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4332:	8b 00                	mov    (%eax),%eax
    4334:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4337:	8b 45 f8             	mov    -0x8(%ebp),%eax
    433a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    433d:	76 d4                	jbe    4313 <free+0x19>
    433f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4342:	8b 00                	mov    (%eax),%eax
    4344:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    4347:	73 ca                	jae    4313 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    4349:	8b 45 f8             	mov    -0x8(%ebp),%eax
    434c:	8b 40 04             	mov    0x4(%eax),%eax
    434f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4356:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4359:	01 c2                	add    %eax,%edx
    435b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    435e:	8b 00                	mov    (%eax),%eax
    4360:	39 c2                	cmp    %eax,%edx
    4362:	75 24                	jne    4388 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4364:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4367:	8b 50 04             	mov    0x4(%eax),%edx
    436a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    436d:	8b 00                	mov    (%eax),%eax
    436f:	8b 40 04             	mov    0x4(%eax),%eax
    4372:	01 c2                	add    %eax,%edx
    4374:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4377:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    437a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    437d:	8b 00                	mov    (%eax),%eax
    437f:	8b 10                	mov    (%eax),%edx
    4381:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4384:	89 10                	mov    %edx,(%eax)
    4386:	eb 0a                	jmp    4392 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    4388:	8b 45 fc             	mov    -0x4(%ebp),%eax
    438b:	8b 10                	mov    (%eax),%edx
    438d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4390:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4392:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4395:	8b 40 04             	mov    0x4(%eax),%eax
    4398:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    439f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43a2:	01 d0                	add    %edx,%eax
    43a4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    43a7:	75 20                	jne    43c9 <free+0xcf>
    p->s.size += bp->s.size;
    43a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43ac:	8b 50 04             	mov    0x4(%eax),%edx
    43af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43b2:	8b 40 04             	mov    0x4(%eax),%eax
    43b5:	01 c2                	add    %eax,%edx
    43b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43ba:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    43bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43c0:	8b 10                	mov    (%eax),%edx
    43c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43c5:	89 10                	mov    %edx,(%eax)
    43c7:	eb 08                	jmp    43d1 <free+0xd7>
  } else
    p->s.ptr = bp;
    43c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    43cf:	89 10                	mov    %edx,(%eax)
  freep = p;
    43d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43d4:	a3 28 65 00 00       	mov    %eax,0x6528
}
    43d9:	90                   	nop
    43da:	c9                   	leave  
    43db:	c3                   	ret    

000043dc <morecore>:

static Header*
morecore(uint nu)
{
    43dc:	55                   	push   %ebp
    43dd:	89 e5                	mov    %esp,%ebp
    43df:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    43e2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    43e9:	77 07                	ja     43f2 <morecore+0x16>
    nu = 4096;
    43eb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    43f2:	8b 45 08             	mov    0x8(%ebp),%eax
    43f5:	c1 e0 03             	shl    $0x3,%eax
    43f8:	83 ec 0c             	sub    $0xc,%esp
    43fb:	50                   	push   %eax
    43fc:	e8 7d fc ff ff       	call   407e <sbrk>
    4401:	83 c4 10             	add    $0x10,%esp
    4404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4407:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    440b:	75 07                	jne    4414 <morecore+0x38>
    return 0;
    440d:	b8 00 00 00 00       	mov    $0x0,%eax
    4412:	eb 26                	jmp    443a <morecore+0x5e>
  hp = (Header*)p;
    4414:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4417:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    441a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    441d:	8b 55 08             	mov    0x8(%ebp),%edx
    4420:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4423:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4426:	83 c0 08             	add    $0x8,%eax
    4429:	83 ec 0c             	sub    $0xc,%esp
    442c:	50                   	push   %eax
    442d:	e8 c8 fe ff ff       	call   42fa <free>
    4432:	83 c4 10             	add    $0x10,%esp
  return freep;
    4435:	a1 28 65 00 00       	mov    0x6528,%eax
}
    443a:	c9                   	leave  
    443b:	c3                   	ret    

0000443c <malloc>:

void*
malloc(uint nbytes)
{
    443c:	55                   	push   %ebp
    443d:	89 e5                	mov    %esp,%ebp
    443f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4442:	8b 45 08             	mov    0x8(%ebp),%eax
    4445:	83 c0 07             	add    $0x7,%eax
    4448:	c1 e8 03             	shr    $0x3,%eax
    444b:	83 c0 01             	add    $0x1,%eax
    444e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4451:	a1 28 65 00 00       	mov    0x6528,%eax
    4456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    445d:	75 23                	jne    4482 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    445f:	c7 45 f0 20 65 00 00 	movl   $0x6520,-0x10(%ebp)
    4466:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4469:	a3 28 65 00 00       	mov    %eax,0x6528
    446e:	a1 28 65 00 00       	mov    0x6528,%eax
    4473:	a3 20 65 00 00       	mov    %eax,0x6520
    base.s.size = 0;
    4478:	c7 05 24 65 00 00 00 	movl   $0x0,0x6524
    447f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4482:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4485:	8b 00                	mov    (%eax),%eax
    4487:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    448a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    448d:	8b 40 04             	mov    0x4(%eax),%eax
    4490:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    4493:	77 4d                	ja     44e2 <malloc+0xa6>
      if(p->s.size == nunits)
    4495:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4498:	8b 40 04             	mov    0x4(%eax),%eax
    449b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    449e:	75 0c                	jne    44ac <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    44a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44a3:	8b 10                	mov    (%eax),%edx
    44a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44a8:	89 10                	mov    %edx,(%eax)
    44aa:	eb 26                	jmp    44d2 <malloc+0x96>
      else {
        p->s.size -= nunits;
    44ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44af:	8b 40 04             	mov    0x4(%eax),%eax
    44b2:	2b 45 ec             	sub    -0x14(%ebp),%eax
    44b5:	89 c2                	mov    %eax,%edx
    44b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44ba:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    44bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44c0:	8b 40 04             	mov    0x4(%eax),%eax
    44c3:	c1 e0 03             	shl    $0x3,%eax
    44c6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    44c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
    44cf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    44d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44d5:	a3 28 65 00 00       	mov    %eax,0x6528
      return (void*)(p + 1);
    44da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44dd:	83 c0 08             	add    $0x8,%eax
    44e0:	eb 3b                	jmp    451d <malloc+0xe1>
    }
    if(p == freep)
    44e2:	a1 28 65 00 00       	mov    0x6528,%eax
    44e7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    44ea:	75 1e                	jne    450a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    44ec:	83 ec 0c             	sub    $0xc,%esp
    44ef:	ff 75 ec             	pushl  -0x14(%ebp)
    44f2:	e8 e5 fe ff ff       	call   43dc <morecore>
    44f7:	83 c4 10             	add    $0x10,%esp
    44fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    44fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4501:	75 07                	jne    450a <malloc+0xce>
        return 0;
    4503:	b8 00 00 00 00       	mov    $0x0,%eax
    4508:	eb 13                	jmp    451d <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    450a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    450d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4510:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4513:	8b 00                	mov    (%eax),%eax
    4515:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4518:	e9 6d ff ff ff       	jmp    448a <malloc+0x4e>
  }
}
    451d:	c9                   	leave  
    451e:	c3                   	ret    
