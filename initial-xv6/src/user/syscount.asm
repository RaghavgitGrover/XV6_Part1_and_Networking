
user/_syscount:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <syscall_name>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/syscall.h"
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

char* syscall_name(int mask) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
        "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open", "write",
        "mknod", "unlink", "link", "mkdir", "close", "waitx", "getsyscount"
    };
    // printf("Debug: Initial mask value = %d\n", mask);
    int index = -1;
    while (mask > 1) {
   6:	4785                	li	a5,1
   8:	04a7d163          	bge	a5,a0,4a <syscall_name+0x4a>
    int index = -1;
   c:	57fd                	li	a5,-1
    while (mask > 1) {
   e:	460d                	li	a2,3
        mask /= 2;  
  10:	872a                	mv	a4,a0
  12:	01f5569b          	srliw	a3,a0,0x1f
  16:	9d35                	addw	a0,a0,a3
  18:	4015551b          	sraiw	a0,a0,0x1
        index++;
  1c:	2785                	addiw	a5,a5,1
    while (mask > 1) {
  1e:	fee649e3          	blt	a2,a4,10 <syscall_name+0x10>
    }
    // printf("Debug: Index = %d\n", index);
    if (index >= 0 && index < NELEM(syscalls)) return syscalls[index];
  22:	0007871b          	sext.w	a4,a5
  26:	46d9                	li	a3,22
    return "unknown";
  28:	00001517          	auipc	a0,0x1
  2c:	8e850513          	addi	a0,a0,-1816 # 910 <malloc+0xea>
    if (index >= 0 && index < NELEM(syscalls)) return syscalls[index];
  30:	00e6f563          	bgeu	a3,a4,3a <syscall_name+0x3a>
}
  34:	6422                	ld	s0,8(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret
    if (index >= 0 && index < NELEM(syscalls)) return syscalls[index];
  3a:	078e                	slli	a5,a5,0x3
  3c:	00001717          	auipc	a4,0x1
  40:	a3c70713          	addi	a4,a4,-1476 # a78 <syscalls.0>
  44:	97ba                	add	a5,a5,a4
  46:	6388                	ld	a0,0(a5)
  48:	b7f5                	j	34 <syscall_name+0x34>
    return "unknown";
  4a:	00001517          	auipc	a0,0x1
  4e:	8c650513          	addi	a0,a0,-1850 # 910 <malloc+0xea>
  52:	b7cd                	j	34 <syscall_name+0x34>

0000000000000054 <main>:

int main(int argc, char *argv[]) {
  54:	7179                	addi	sp,sp,-48
  56:	f406                	sd	ra,40(sp)
  58:	f022                	sd	s0,32(sp)
  5a:	ec26                	sd	s1,24(sp)
  5c:	e84a                	sd	s2,16(sp)
  5e:	e44e                	sd	s3,8(sp)
  60:	1800                	addi	s0,sp,48
//   if (argc < 3) {
  if (argc < 3) {
  62:	4789                	li	a5,2
  64:	00a7cf63          	blt	a5,a0,82 <main+0x2e>
    printf("Usage: syscount <mask> command [args]\n");
  68:	00001517          	auipc	a0,0x1
  6c:	8b050513          	addi	a0,a0,-1872 # 918 <malloc+0xf2>
  70:	00000097          	auipc	ra,0x0
  74:	6f8080e7          	jalr	1784(ra) # 768 <printf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	00000097          	auipc	ra,0x0
  7e:	356080e7          	jalr	854(ra) # 3d0 <exit>
  82:	84ae                	mv	s1,a1
  }
  int mask = atoi(argv[1]);
  84:	6588                	ld	a0,8(a1)
  86:	00000097          	auipc	ra,0x0
  8a:	24e080e7          	jalr	590(ra) # 2d4 <atoi>
  8e:	892a                	mv	s2,a0
  // check if mask is a power of 2
  if ((mask & (mask - 1)) != 0) {
  90:	fff5079b          	addiw	a5,a0,-1
  94:	8fe9                	and	a5,a5,a0
  96:	2781                	sext.w	a5,a5
  98:	cf99                	beqz	a5,b6 <main+0x62>
      printf("Invalid mask %d\n", mask);
  9a:	85aa                	mv	a1,a0
  9c:	00001517          	auipc	a0,0x1
  a0:	8ac50513          	addi	a0,a0,-1876 # 948 <malloc+0x122>
  a4:	00000097          	auipc	ra,0x0
  a8:	6c4080e7          	jalr	1732(ra) # 768 <printf>
      exit(1);
  ac:	4505                	li	a0,1
  ae:	00000097          	auipc	ra,0x0
  b2:	322080e7          	jalr	802(ra) # 3d0 <exit>
  }
  int pid = fork();
  b6:	00000097          	auipc	ra,0x0
  ba:	312080e7          	jalr	786(ra) # 3c8 <fork>
  be:	89aa                	mv	s3,a0
  if (pid < 0) {
  c0:	02054763          	bltz	a0,ee <main+0x9a>
    printf("Couldn't execute fork\n");
    exit(1);
  }
  if (pid == 0) {    
  c4:	e131                	bnez	a0,108 <main+0xb4>
    exec(argv[2], &argv[2]);
  c6:	01048593          	addi	a1,s1,16
  ca:	6888                	ld	a0,16(s1)
  cc:	00000097          	auipc	ra,0x0
  d0:	33c080e7          	jalr	828(ra) # 408 <exec>
    printf("Couldn't execute exec\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	8a450513          	addi	a0,a0,-1884 # 978 <malloc+0x152>
  dc:	00000097          	auipc	ra,0x0
  e0:	68c080e7          	jalr	1676(ra) # 768 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	2ea080e7          	jalr	746(ra) # 3d0 <exit>
    printf("Couldn't execute fork\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	87250513          	addi	a0,a0,-1934 # 960 <malloc+0x13a>
  f6:	00000097          	auipc	ra,0x0
  fa:	672080e7          	jalr	1650(ra) # 768 <printf>
    exit(1);
  fe:	4505                	li	a0,1
 100:	00000097          	auipc	ra,0x0
 104:	2d0080e7          	jalr	720(ra) # 3d0 <exit>
  } 
  else {    
    wait(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2ce080e7          	jalr	718(ra) # 3d8 <wait>
    int count = getsyscount(mask);
 112:	854a                	mv	a0,s2
 114:	00000097          	auipc	ra,0x0
 118:	364080e7          	jalr	868(ra) # 478 <getsyscount>
 11c:	84aa                	mv	s1,a0
    printf("PID %d called %s %d times\n", pid, syscall_name(mask), count);
 11e:	854a                	mv	a0,s2
 120:	00000097          	auipc	ra,0x0
 124:	ee0080e7          	jalr	-288(ra) # 0 <syscall_name>
 128:	862a                	mv	a2,a0
 12a:	86a6                	mv	a3,s1
 12c:	85ce                	mv	a1,s3
 12e:	00001517          	auipc	a0,0x1
 132:	86250513          	addi	a0,a0,-1950 # 990 <malloc+0x16a>
 136:	00000097          	auipc	ra,0x0
 13a:	632080e7          	jalr	1586(ra) # 768 <printf>
  }
  exit(0);
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	290080e7          	jalr	656(ra) # 3d0 <exit>

0000000000000148 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 150:	00000097          	auipc	ra,0x0
 154:	f04080e7          	jalr	-252(ra) # 54 <main>
  exit(0);
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	276080e7          	jalr	630(ra) # 3d0 <exit>

0000000000000162 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 168:	87aa                	mv	a5,a0
 16a:	0585                	addi	a1,a1,1
 16c:	0785                	addi	a5,a5,1
 16e:	fff5c703          	lbu	a4,-1(a1)
 172:	fee78fa3          	sb	a4,-1(a5)
 176:	fb75                	bnez	a4,16a <strcpy+0x8>
    ;
  return os;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb91                	beqz	a5,19c <strcmp+0x1e>
 18a:	0005c703          	lbu	a4,0(a1)
 18e:	00f71763          	bne	a4,a5,19c <strcmp+0x1e>
    p++, q++;
 192:	0505                	addi	a0,a0,1
 194:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbe5                	bnez	a5,18a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19c:	0005c503          	lbu	a0,0(a1)
}
 1a0:	40a7853b          	subw	a0,a5,a0
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strlen>:

uint
strlen(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf91                	beqz	a5,1d0 <strlen+0x26>
 1b6:	0505                	addi	a0,a0,1
 1b8:	87aa                	mv	a5,a0
 1ba:	4685                	li	a3,1
 1bc:	9e89                	subw	a3,a3,a0
 1be:	00f6853b          	addw	a0,a3,a5
 1c2:	0785                	addi	a5,a5,1
 1c4:	fff7c703          	lbu	a4,-1(a5)
 1c8:	fb7d                	bnez	a4,1be <strlen+0x14>
    ;
  return n;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  for(n = 0; s[n]; n++)
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strlen+0x20>

00000000000001d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1da:	ca19                	beqz	a2,1f0 <memset+0x1c>
 1dc:	87aa                	mv	a5,a0
 1de:	1602                	slli	a2,a2,0x20
 1e0:	9201                	srli	a2,a2,0x20
 1e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ea:	0785                	addi	a5,a5,1
 1ec:	fee79de3          	bne	a5,a4,1e6 <memset+0x12>
  }
  return dst;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret

00000000000001f6 <strchr>:

char*
strchr(const char *s, char c)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	cb99                	beqz	a5,216 <strchr+0x20>
    if(*s == c)
 202:	00f58763          	beq	a1,a5,210 <strchr+0x1a>
  for(; *s; s++)
 206:	0505                	addi	a0,a0,1
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbfd                	bnez	a5,202 <strchr+0xc>
      return (char*)s;
  return 0;
 20e:	4501                	li	a0,0
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  return 0;
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <strchr+0x1a>

000000000000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	711d                	addi	sp,sp,-96
 21c:	ec86                	sd	ra,88(sp)
 21e:	e8a2                	sd	s0,80(sp)
 220:	e4a6                	sd	s1,72(sp)
 222:	e0ca                	sd	s2,64(sp)
 224:	fc4e                	sd	s3,56(sp)
 226:	f852                	sd	s4,48(sp)
 228:	f456                	sd	s5,40(sp)
 22a:	f05a                	sd	s6,32(sp)
 22c:	ec5e                	sd	s7,24(sp)
 22e:	1080                	addi	s0,sp,96
 230:	8baa                	mv	s7,a0
 232:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	892a                	mv	s2,a0
 236:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 238:	4aa9                	li	s5,10
 23a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23c:	89a6                	mv	s3,s1
 23e:	2485                	addiw	s1,s1,1
 240:	0344d863          	bge	s1,s4,270 <gets+0x56>
    cc = read(0, &c, 1);
 244:	4605                	li	a2,1
 246:	faf40593          	addi	a1,s0,-81
 24a:	4501                	li	a0,0
 24c:	00000097          	auipc	ra,0x0
 250:	19c080e7          	jalr	412(ra) # 3e8 <read>
    if(cc < 1)
 254:	00a05e63          	blez	a0,270 <gets+0x56>
    buf[i++] = c;
 258:	faf44783          	lbu	a5,-81(s0)
 25c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 260:	01578763          	beq	a5,s5,26e <gets+0x54>
 264:	0905                	addi	s2,s2,1
 266:	fd679be3          	bne	a5,s6,23c <gets+0x22>
  for(i=0; i+1 < max; ){
 26a:	89a6                	mv	s3,s1
 26c:	a011                	j	270 <gets+0x56>
 26e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 270:	99de                	add	s3,s3,s7
 272:	00098023          	sb	zero,0(s3)
  return buf;
}
 276:	855e                	mv	a0,s7
 278:	60e6                	ld	ra,88(sp)
 27a:	6446                	ld	s0,80(sp)
 27c:	64a6                	ld	s1,72(sp)
 27e:	6906                	ld	s2,64(sp)
 280:	79e2                	ld	s3,56(sp)
 282:	7a42                	ld	s4,48(sp)
 284:	7aa2                	ld	s5,40(sp)
 286:	7b02                	ld	s6,32(sp)
 288:	6be2                	ld	s7,24(sp)
 28a:	6125                	addi	sp,sp,96
 28c:	8082                	ret

000000000000028e <stat>:

int
stat(const char *n, struct stat *st)
{
 28e:	1101                	addi	sp,sp,-32
 290:	ec06                	sd	ra,24(sp)
 292:	e822                	sd	s0,16(sp)
 294:	e426                	sd	s1,8(sp)
 296:	e04a                	sd	s2,0(sp)
 298:	1000                	addi	s0,sp,32
 29a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29c:	4581                	li	a1,0
 29e:	00000097          	auipc	ra,0x0
 2a2:	172080e7          	jalr	370(ra) # 410 <open>
  if(fd < 0)
 2a6:	02054563          	bltz	a0,2d0 <stat+0x42>
 2aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ac:	85ca                	mv	a1,s2
 2ae:	00000097          	auipc	ra,0x0
 2b2:	17a080e7          	jalr	378(ra) # 428 <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	00000097          	auipc	ra,0x0
 2be:	13e080e7          	jalr	318(ra) # 3f8 <close>
  return r;
}
 2c2:	854a                	mv	a0,s2
 2c4:	60e2                	ld	ra,24(sp)
 2c6:	6442                	ld	s0,16(sp)
 2c8:	64a2                	ld	s1,8(sp)
 2ca:	6902                	ld	s2,0(sp)
 2cc:	6105                	addi	sp,sp,32
 2ce:	8082                	ret
    return -1;
 2d0:	597d                	li	s2,-1
 2d2:	bfc5                	j	2c2 <stat+0x34>

00000000000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2da:	00054603          	lbu	a2,0(a0)
 2de:	fd06079b          	addiw	a5,a2,-48
 2e2:	0ff7f793          	zext.b	a5,a5
 2e6:	4725                	li	a4,9
 2e8:	02f76963          	bltu	a4,a5,31a <atoi+0x46>
 2ec:	86aa                	mv	a3,a0
  n = 0;
 2ee:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f2:	0685                	addi	a3,a3,1
 2f4:	0025179b          	slliw	a5,a0,0x2
 2f8:	9fa9                	addw	a5,a5,a0
 2fa:	0017979b          	slliw	a5,a5,0x1
 2fe:	9fb1                	addw	a5,a5,a2
 300:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 304:	0006c603          	lbu	a2,0(a3)
 308:	fd06071b          	addiw	a4,a2,-48
 30c:	0ff77713          	zext.b	a4,a4
 310:	fee5f1e3          	bgeu	a1,a4,2f2 <atoi+0x1e>
  return n;
}
 314:	6422                	ld	s0,8(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
  n = 0;
 31a:	4501                	li	a0,0
 31c:	bfe5                	j	314 <atoi+0x40>

000000000000031e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e422                	sd	s0,8(sp)
 322:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 324:	02b57463          	bgeu	a0,a1,34c <memmove+0x2e>
    while(n-- > 0)
 328:	00c05f63          	blez	a2,346 <memmove+0x28>
 32c:	1602                	slli	a2,a2,0x20
 32e:	9201                	srli	a2,a2,0x20
 330:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 334:	872a                	mv	a4,a0
      *dst++ = *src++;
 336:	0585                	addi	a1,a1,1
 338:	0705                	addi	a4,a4,1
 33a:	fff5c683          	lbu	a3,-1(a1)
 33e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret
    dst += n;
 34c:	00c50733          	add	a4,a0,a2
    src += n;
 350:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 352:	fec05ae3          	blez	a2,346 <memmove+0x28>
 356:	fff6079b          	addiw	a5,a2,-1
 35a:	1782                	slli	a5,a5,0x20
 35c:	9381                	srli	a5,a5,0x20
 35e:	fff7c793          	not	a5,a5
 362:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 364:	15fd                	addi	a1,a1,-1
 366:	177d                	addi	a4,a4,-1
 368:	0005c683          	lbu	a3,0(a1)
 36c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 370:	fee79ae3          	bne	a5,a4,364 <memmove+0x46>
 374:	bfc9                	j	346 <memmove+0x28>

0000000000000376 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37c:	ca05                	beqz	a2,3ac <memcmp+0x36>
 37e:	fff6069b          	addiw	a3,a2,-1
 382:	1682                	slli	a3,a3,0x20
 384:	9281                	srli	a3,a3,0x20
 386:	0685                	addi	a3,a3,1
 388:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 38a:	00054783          	lbu	a5,0(a0)
 38e:	0005c703          	lbu	a4,0(a1)
 392:	00e79863          	bne	a5,a4,3a2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 396:	0505                	addi	a0,a0,1
    p2++;
 398:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39a:	fed518e3          	bne	a0,a3,38a <memcmp+0x14>
  }
  return 0;
 39e:	4501                	li	a0,0
 3a0:	a019                	j	3a6 <memcmp+0x30>
      return *p1 - *p2;
 3a2:	40e7853b          	subw	a0,a5,a4
}
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret
  return 0;
 3ac:	4501                	li	a0,0
 3ae:	bfe5                	j	3a6 <memcmp+0x30>

00000000000003b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e406                	sd	ra,8(sp)
 3b4:	e022                	sd	s0,0(sp)
 3b6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b8:	00000097          	auipc	ra,0x0
 3bc:	f66080e7          	jalr	-154(ra) # 31e <memmove>
}
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret

00000000000003c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c8:	4885                	li	a7,1
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d0:	4889                	li	a7,2
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d8:	488d                	li	a7,3
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e0:	4891                	li	a7,4
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <read>:
.global read
read:
 li a7, SYS_read
 3e8:	4895                	li	a7,5
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <write>:
.global write
write:
 li a7, SYS_write
 3f0:	48c1                	li	a7,16
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <close>:
.global close
close:
 li a7, SYS_close
 3f8:	48d5                	li	a7,21
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <kill>:
.global kill
kill:
 li a7, SYS_kill
 400:	4899                	li	a7,6
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <exec>:
.global exec
exec:
 li a7, SYS_exec
 408:	489d                	li	a7,7
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <open>:
.global open
open:
 li a7, SYS_open
 410:	48bd                	li	a7,15
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 418:	48c5                	li	a7,17
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 420:	48c9                	li	a7,18
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 428:	48a1                	li	a7,8
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <link>:
.global link
link:
 li a7, SYS_link
 430:	48cd                	li	a7,19
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 438:	48d1                	li	a7,20
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 440:	48a5                	li	a7,9
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <dup>:
.global dup
dup:
 li a7, SYS_dup
 448:	48a9                	li	a7,10
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 450:	48ad                	li	a7,11
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 458:	48b1                	li	a7,12
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 460:	48b5                	li	a7,13
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 468:	48b9                	li	a7,14
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 470:	48d9                	li	a7,22
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 478:	48dd                	li	a7,23
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 480:	48e1                	li	a7,24
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 488:	48e5                	li	a7,25
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 490:	1101                	addi	sp,sp,-32
 492:	ec06                	sd	ra,24(sp)
 494:	e822                	sd	s0,16(sp)
 496:	1000                	addi	s0,sp,32
 498:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 49c:	4605                	li	a2,1
 49e:	fef40593          	addi	a1,s0,-17
 4a2:	00000097          	auipc	ra,0x0
 4a6:	f4e080e7          	jalr	-178(ra) # 3f0 <write>
}
 4aa:	60e2                	ld	ra,24(sp)
 4ac:	6442                	ld	s0,16(sp)
 4ae:	6105                	addi	sp,sp,32
 4b0:	8082                	ret

00000000000004b2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b2:	7139                	addi	sp,sp,-64
 4b4:	fc06                	sd	ra,56(sp)
 4b6:	f822                	sd	s0,48(sp)
 4b8:	f426                	sd	s1,40(sp)
 4ba:	f04a                	sd	s2,32(sp)
 4bc:	ec4e                	sd	s3,24(sp)
 4be:	0080                	addi	s0,sp,64
 4c0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c2:	c299                	beqz	a3,4c8 <printint+0x16>
 4c4:	0805c863          	bltz	a1,554 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c8:	2581                	sext.w	a1,a1
  neg = 0;
 4ca:	4881                	li	a7,0
 4cc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4d0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4d2:	2601                	sext.w	a2,a2
 4d4:	00000517          	auipc	a0,0x0
 4d8:	65c50513          	addi	a0,a0,1628 # b30 <digits>
 4dc:	883a                	mv	a6,a4
 4de:	2705                	addiw	a4,a4,1
 4e0:	02c5f7bb          	remuw	a5,a1,a2
 4e4:	1782                	slli	a5,a5,0x20
 4e6:	9381                	srli	a5,a5,0x20
 4e8:	97aa                	add	a5,a5,a0
 4ea:	0007c783          	lbu	a5,0(a5)
 4ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f2:	0005879b          	sext.w	a5,a1
 4f6:	02c5d5bb          	divuw	a1,a1,a2
 4fa:	0685                	addi	a3,a3,1
 4fc:	fec7f0e3          	bgeu	a5,a2,4dc <printint+0x2a>
  if(neg)
 500:	00088b63          	beqz	a7,516 <printint+0x64>
    buf[i++] = '-';
 504:	fd040793          	addi	a5,s0,-48
 508:	973e                	add	a4,a4,a5
 50a:	02d00793          	li	a5,45
 50e:	fef70823          	sb	a5,-16(a4)
 512:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 516:	02e05863          	blez	a4,546 <printint+0x94>
 51a:	fc040793          	addi	a5,s0,-64
 51e:	00e78933          	add	s2,a5,a4
 522:	fff78993          	addi	s3,a5,-1
 526:	99ba                	add	s3,s3,a4
 528:	377d                	addiw	a4,a4,-1
 52a:	1702                	slli	a4,a4,0x20
 52c:	9301                	srli	a4,a4,0x20
 52e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 532:	fff94583          	lbu	a1,-1(s2)
 536:	8526                	mv	a0,s1
 538:	00000097          	auipc	ra,0x0
 53c:	f58080e7          	jalr	-168(ra) # 490 <putc>
  while(--i >= 0)
 540:	197d                	addi	s2,s2,-1
 542:	ff3918e3          	bne	s2,s3,532 <printint+0x80>
}
 546:	70e2                	ld	ra,56(sp)
 548:	7442                	ld	s0,48(sp)
 54a:	74a2                	ld	s1,40(sp)
 54c:	7902                	ld	s2,32(sp)
 54e:	69e2                	ld	s3,24(sp)
 550:	6121                	addi	sp,sp,64
 552:	8082                	ret
    x = -xx;
 554:	40b005bb          	negw	a1,a1
    neg = 1;
 558:	4885                	li	a7,1
    x = -xx;
 55a:	bf8d                	j	4cc <printint+0x1a>

000000000000055c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55c:	7119                	addi	sp,sp,-128
 55e:	fc86                	sd	ra,120(sp)
 560:	f8a2                	sd	s0,112(sp)
 562:	f4a6                	sd	s1,104(sp)
 564:	f0ca                	sd	s2,96(sp)
 566:	ecce                	sd	s3,88(sp)
 568:	e8d2                	sd	s4,80(sp)
 56a:	e4d6                	sd	s5,72(sp)
 56c:	e0da                	sd	s6,64(sp)
 56e:	fc5e                	sd	s7,56(sp)
 570:	f862                	sd	s8,48(sp)
 572:	f466                	sd	s9,40(sp)
 574:	f06a                	sd	s10,32(sp)
 576:	ec6e                	sd	s11,24(sp)
 578:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 57a:	0005c903          	lbu	s2,0(a1)
 57e:	18090f63          	beqz	s2,71c <vprintf+0x1c0>
 582:	8aaa                	mv	s5,a0
 584:	8b32                	mv	s6,a2
 586:	00158493          	addi	s1,a1,1
  state = 0;
 58a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 58c:	02500a13          	li	s4,37
      if(c == 'd'){
 590:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 594:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 598:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 59c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a0:	00000b97          	auipc	s7,0x0
 5a4:	590b8b93          	addi	s7,s7,1424 # b30 <digits>
 5a8:	a839                	j	5c6 <vprintf+0x6a>
        putc(fd, c);
 5aa:	85ca                	mv	a1,s2
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	ee2080e7          	jalr	-286(ra) # 490 <putc>
 5b6:	a019                	j	5bc <vprintf+0x60>
    } else if(state == '%'){
 5b8:	01498f63          	beq	s3,s4,5d6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5bc:	0485                	addi	s1,s1,1
 5be:	fff4c903          	lbu	s2,-1(s1)
 5c2:	14090d63          	beqz	s2,71c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5c6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ca:	fe0997e3          	bnez	s3,5b8 <vprintf+0x5c>
      if(c == '%'){
 5ce:	fd479ee3          	bne	a5,s4,5aa <vprintf+0x4e>
        state = '%';
 5d2:	89be                	mv	s3,a5
 5d4:	b7e5                	j	5bc <vprintf+0x60>
      if(c == 'd'){
 5d6:	05878063          	beq	a5,s8,616 <vprintf+0xba>
      } else if(c == 'l') {
 5da:	05978c63          	beq	a5,s9,632 <vprintf+0xd6>
      } else if(c == 'x') {
 5de:	07a78863          	beq	a5,s10,64e <vprintf+0xf2>
      } else if(c == 'p') {
 5e2:	09b78463          	beq	a5,s11,66a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5e6:	07300713          	li	a4,115
 5ea:	0ce78663          	beq	a5,a4,6b6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ee:	06300713          	li	a4,99
 5f2:	0ee78e63          	beq	a5,a4,6ee <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5f6:	11478863          	beq	a5,s4,706 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fa:	85d2                	mv	a1,s4
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e92080e7          	jalr	-366(ra) # 490 <putc>
        putc(fd, c);
 606:	85ca                	mv	a1,s2
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e86080e7          	jalr	-378(ra) # 490 <putc>
      }
      state = 0;
 612:	4981                	li	s3,0
 614:	b765                	j	5bc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 616:	008b0913          	addi	s2,s6,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000b2583          	lw	a1,0(s6)
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	e8e080e7          	jalr	-370(ra) # 4b2 <printint>
 62c:	8b4a                	mv	s6,s2
      state = 0;
 62e:	4981                	li	s3,0
 630:	b771                	j	5bc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	008b0913          	addi	s2,s6,8
 636:	4681                	li	a3,0
 638:	4629                	li	a2,10
 63a:	000b2583          	lw	a1,0(s6)
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	e72080e7          	jalr	-398(ra) # 4b2 <printint>
 648:	8b4a                	mv	s6,s2
      state = 0;
 64a:	4981                	li	s3,0
 64c:	bf85                	j	5bc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 64e:	008b0913          	addi	s2,s6,8
 652:	4681                	li	a3,0
 654:	4641                	li	a2,16
 656:	000b2583          	lw	a1,0(s6)
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	e56080e7          	jalr	-426(ra) # 4b2 <printint>
 664:	8b4a                	mv	s6,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	bf91                	j	5bc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 66a:	008b0793          	addi	a5,s6,8
 66e:	f8f43423          	sd	a5,-120(s0)
 672:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 676:	03000593          	li	a1,48
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e14080e7          	jalr	-492(ra) # 490 <putc>
  putc(fd, 'x');
 684:	85ea                	mv	a1,s10
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e08080e7          	jalr	-504(ra) # 490 <putc>
 690:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 692:	03c9d793          	srli	a5,s3,0x3c
 696:	97de                	add	a5,a5,s7
 698:	0007c583          	lbu	a1,0(a5)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	df2080e7          	jalr	-526(ra) # 490 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a6:	0992                	slli	s3,s3,0x4
 6a8:	397d                	addiw	s2,s2,-1
 6aa:	fe0914e3          	bnez	s2,692 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6ae:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b721                	j	5bc <vprintf+0x60>
        s = va_arg(ap, char*);
 6b6:	008b0993          	addi	s3,s6,8
 6ba:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6be:	02090163          	beqz	s2,6e0 <vprintf+0x184>
        while(*s != 0){
 6c2:	00094583          	lbu	a1,0(s2)
 6c6:	c9a1                	beqz	a1,716 <vprintf+0x1ba>
          putc(fd, *s);
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	dc6080e7          	jalr	-570(ra) # 490 <putc>
          s++;
 6d2:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d4:	00094583          	lbu	a1,0(s2)
 6d8:	f9e5                	bnez	a1,6c8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6da:	8b4e                	mv	s6,s3
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bdf9                	j	5bc <vprintf+0x60>
          s = "(null)";
 6e0:	00000917          	auipc	s2,0x0
 6e4:	39090913          	addi	s2,s2,912 # a70 <malloc+0x24a>
        while(*s != 0){
 6e8:	02800593          	li	a1,40
 6ec:	bff1                	j	6c8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6ee:	008b0913          	addi	s2,s6,8
 6f2:	000b4583          	lbu	a1,0(s6)
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	d98080e7          	jalr	-616(ra) # 490 <putc>
 700:	8b4a                	mv	s6,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	bd65                	j	5bc <vprintf+0x60>
        putc(fd, c);
 706:	85d2                	mv	a1,s4
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	d86080e7          	jalr	-634(ra) # 490 <putc>
      state = 0;
 712:	4981                	li	s3,0
 714:	b565                	j	5bc <vprintf+0x60>
        s = va_arg(ap, char*);
 716:	8b4e                	mv	s6,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	b54d                	j	5bc <vprintf+0x60>
    }
  }
}
 71c:	70e6                	ld	ra,120(sp)
 71e:	7446                	ld	s0,112(sp)
 720:	74a6                	ld	s1,104(sp)
 722:	7906                	ld	s2,96(sp)
 724:	69e6                	ld	s3,88(sp)
 726:	6a46                	ld	s4,80(sp)
 728:	6aa6                	ld	s5,72(sp)
 72a:	6b06                	ld	s6,64(sp)
 72c:	7be2                	ld	s7,56(sp)
 72e:	7c42                	ld	s8,48(sp)
 730:	7ca2                	ld	s9,40(sp)
 732:	7d02                	ld	s10,32(sp)
 734:	6de2                	ld	s11,24(sp)
 736:	6109                	addi	sp,sp,128
 738:	8082                	ret

000000000000073a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e010                	sd	a2,0(s0)
 744:	e414                	sd	a3,8(s0)
 746:	e818                	sd	a4,16(s0)
 748:	ec1c                	sd	a5,24(s0)
 74a:	03043023          	sd	a6,32(s0)
 74e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	8622                	mv	a2,s0
 758:	00000097          	auipc	ra,0x0
 75c:	e04080e7          	jalr	-508(ra) # 55c <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6161                	addi	sp,sp,80
 766:	8082                	ret

0000000000000768 <printf>:

void
printf(const char *fmt, ...)
{
 768:	711d                	addi	sp,sp,-96
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	addi	s0,sp,32
 770:	e40c                	sd	a1,8(s0)
 772:	e810                	sd	a2,16(s0)
 774:	ec14                	sd	a3,24(s0)
 776:	f018                	sd	a4,32(s0)
 778:	f41c                	sd	a5,40(s0)
 77a:	03043823          	sd	a6,48(s0)
 77e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 782:	00840613          	addi	a2,s0,8
 786:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78a:	85aa                	mv	a1,a0
 78c:	4505                	li	a0,1
 78e:	00000097          	auipc	ra,0x0
 792:	dce080e7          	jalr	-562(ra) # 55c <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6125                	addi	sp,sp,96
 79c:	8082                	ret

000000000000079e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79e:	1141                	addi	sp,sp,-16
 7a0:	e422                	sd	s0,8(sp)
 7a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	00001797          	auipc	a5,0x1
 7ac:	8587b783          	ld	a5,-1960(a5) # 1000 <freep>
 7b0:	a805                	j	7e0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b2:	4618                	lw	a4,8(a2)
 7b4:	9db9                	addw	a1,a1,a4
 7b6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ba:	6398                	ld	a4,0(a5)
 7bc:	6318                	ld	a4,0(a4)
 7be:	fee53823          	sd	a4,-16(a0)
 7c2:	a091                	j	806 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c4:	ff852703          	lw	a4,-8(a0)
 7c8:	9e39                	addw	a2,a2,a4
 7ca:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7cc:	ff053703          	ld	a4,-16(a0)
 7d0:	e398                	sd	a4,0(a5)
 7d2:	a099                	j	818 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e7e463          	bltu	a5,a4,7de <free+0x40>
 7da:	00e6ea63          	bltu	a3,a4,7ee <free+0x50>
{
 7de:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e0:	fed7fae3          	bgeu	a5,a3,7d4 <free+0x36>
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e6e463          	bltu	a3,a4,7ee <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	fee7eae3          	bltu	a5,a4,7de <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7ee:	ff852583          	lw	a1,-8(a0)
 7f2:	6390                	ld	a2,0(a5)
 7f4:	02059713          	slli	a4,a1,0x20
 7f8:	9301                	srli	a4,a4,0x20
 7fa:	0712                	slli	a4,a4,0x4
 7fc:	9736                	add	a4,a4,a3
 7fe:	fae60ae3          	beq	a2,a4,7b2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 802:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 806:	4790                	lw	a2,8(a5)
 808:	02061713          	slli	a4,a2,0x20
 80c:	9301                	srli	a4,a4,0x20
 80e:	0712                	slli	a4,a4,0x4
 810:	973e                	add	a4,a4,a5
 812:	fae689e3          	beq	a3,a4,7c4 <free+0x26>
  } else
    p->s.ptr = bp;
 816:	e394                	sd	a3,0(a5)
  freep = p;
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73423          	sd	a5,2024(a4) # 1000 <freep>
}
 820:	6422                	ld	s0,8(sp)
 822:	0141                	addi	sp,sp,16
 824:	8082                	ret

0000000000000826 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 826:	7139                	addi	sp,sp,-64
 828:	fc06                	sd	ra,56(sp)
 82a:	f822                	sd	s0,48(sp)
 82c:	f426                	sd	s1,40(sp)
 82e:	f04a                	sd	s2,32(sp)
 830:	ec4e                	sd	s3,24(sp)
 832:	e852                	sd	s4,16(sp)
 834:	e456                	sd	s5,8(sp)
 836:	e05a                	sd	s6,0(sp)
 838:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83a:	02051493          	slli	s1,a0,0x20
 83e:	9081                	srli	s1,s1,0x20
 840:	04bd                	addi	s1,s1,15
 842:	8091                	srli	s1,s1,0x4
 844:	0014899b          	addiw	s3,s1,1
 848:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 84a:	00000517          	auipc	a0,0x0
 84e:	7b653503          	ld	a0,1974(a0) # 1000 <freep>
 852:	c515                	beqz	a0,87e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 856:	4798                	lw	a4,8(a5)
 858:	02977f63          	bgeu	a4,s1,896 <malloc+0x70>
 85c:	8a4e                	mv	s4,s3
 85e:	0009871b          	sext.w	a4,s3
 862:	6685                	lui	a3,0x1
 864:	00d77363          	bgeu	a4,a3,86a <malloc+0x44>
 868:	6a05                	lui	s4,0x1
 86a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 872:	00000917          	auipc	s2,0x0
 876:	78e90913          	addi	s2,s2,1934 # 1000 <freep>
  if(p == (char*)-1)
 87a:	5afd                	li	s5,-1
 87c:	a88d                	j	8ee <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 87e:	00000797          	auipc	a5,0x0
 882:	79278793          	addi	a5,a5,1938 # 1010 <base>
 886:	00000717          	auipc	a4,0x0
 88a:	76f73d23          	sd	a5,1914(a4) # 1000 <freep>
 88e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 890:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 894:	b7e1                	j	85c <malloc+0x36>
      if(p->s.size == nunits)
 896:	02e48b63          	beq	s1,a4,8cc <malloc+0xa6>
        p->s.size -= nunits;
 89a:	4137073b          	subw	a4,a4,s3
 89e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a0:	1702                	slli	a4,a4,0x20
 8a2:	9301                	srli	a4,a4,0x20
 8a4:	0712                	slli	a4,a4,0x4
 8a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ac:	00000717          	auipc	a4,0x0
 8b0:	74a73a23          	sd	a0,1876(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b8:	70e2                	ld	ra,56(sp)
 8ba:	7442                	ld	s0,48(sp)
 8bc:	74a2                	ld	s1,40(sp)
 8be:	7902                	ld	s2,32(sp)
 8c0:	69e2                	ld	s3,24(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	6121                	addi	sp,sp,64
 8ca:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	e118                	sd	a4,0(a0)
 8d0:	bff1                	j	8ac <malloc+0x86>
  hp->s.size = nu;
 8d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d6:	0541                	addi	a0,a0,16
 8d8:	00000097          	auipc	ra,0x0
 8dc:	ec6080e7          	jalr	-314(ra) # 79e <free>
  return freep;
 8e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e4:	d971                	beqz	a0,8b8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e8:	4798                	lw	a4,8(a5)
 8ea:	fa9776e3          	bgeu	a4,s1,896 <malloc+0x70>
    if(p == freep)
 8ee:	00093703          	ld	a4,0(s2)
 8f2:	853e                	mv	a0,a5
 8f4:	fef719e3          	bne	a4,a5,8e6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8f8:	8552                	mv	a0,s4
 8fa:	00000097          	auipc	ra,0x0
 8fe:	b5e080e7          	jalr	-1186(ra) # 458 <sbrk>
  if(p == (char*)-1)
 902:	fd5518e3          	bne	a0,s5,8d2 <malloc+0xac>
        return 0;
 906:	4501                	li	a0,0
 908:	bf45                	j	8b8 <malloc+0x92>
