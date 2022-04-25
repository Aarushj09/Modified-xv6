
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8b250513          	addi	a0,a0,-1870 # 8c0 <malloc+0xe8>
  16:	00000097          	auipc	ra,0x0
  1a:	3b2080e7          	jalr	946(ra) # 3c8 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3dc080e7          	jalr	988(ra) # 400 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3d2080e7          	jalr	978(ra) # 400 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	89290913          	addi	s2,s2,-1902 # 8c8 <malloc+0xf0>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6d8080e7          	jalr	1752(ra) # 718 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	338080e7          	jalr	824(ra) # 380 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	336080e7          	jalr	822(ra) # 390 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	8ae50513          	addi	a0,a0,-1874 # 918 <malloc+0x140>
  72:	00000097          	auipc	ra,0x0
  76:	6a6080e7          	jalr	1702(ra) # 718 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	30c080e7          	jalr	780(ra) # 388 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	83850513          	addi	a0,a0,-1992 # 8c0 <malloc+0xe8>
  90:	00000097          	auipc	ra,0x0
  94:	340080e7          	jalr	832(ra) # 3d0 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	82650513          	addi	a0,a0,-2010 # 8c0 <malloc+0xe8>
  a2:	00000097          	auipc	ra,0x0
  a6:	326080e7          	jalr	806(ra) # 3c8 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	83450513          	addi	a0,a0,-1996 # 8e0 <malloc+0x108>
  b4:	00000097          	auipc	ra,0x0
  b8:	664080e7          	jalr	1636(ra) # 718 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2ca080e7          	jalr	714(ra) # 388 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	89258593          	addi	a1,a1,-1902 # 958 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	82a50513          	addi	a0,a0,-2006 # 8f8 <malloc+0x120>
  d6:	00000097          	auipc	ra,0x0
  da:	2ea080e7          	jalr	746(ra) # 3c0 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	82250513          	addi	a0,a0,-2014 # 900 <malloc+0x128>
  e6:	00000097          	auipc	ra,0x0
  ea:	632080e7          	jalr	1586(ra) # 718 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	298080e7          	jalr	664(ra) # 388 <exit>

00000000000000f8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strcmp+0x26>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71b63          	bne	a4,a5,13a <strcmp+0x26>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	c789                	beqz	a5,13a <strcmp+0x26>
 132:	0005c703          	lbu	a4,0(a1)
 136:	fef709e3          	beq	a4,a5,128 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 13a:	0005c503          	lbu	a0,0(a1)
}
 13e:	40a7853b          	subw	a0,a5,a0
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 14e:	00054783          	lbu	a5,0(a0)
 152:	cf91                	beqz	a5,16e <strlen+0x26>
 154:	0505                	addi	a0,a0,1
 156:	87aa                	mv	a5,a0
 158:	4685                	li	a3,1
 15a:	9e89                	subw	a3,a3,a0
 15c:	00f6853b          	addw	a0,a3,a5
 160:	0785                	addi	a5,a5,1
 162:	fff7c703          	lbu	a4,-1(a5)
 166:	fb7d                	bnez	a4,15c <strlen+0x14>
    ;
  return n;
}
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret
  for(n = 0; s[n]; n++)
 16e:	4501                	li	a0,0
 170:	bfe5                	j	168 <strlen+0x20>

0000000000000172 <memset>:

void*
memset(void *dst, int c, uint n)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 178:	ce09                	beqz	a2,192 <memset+0x20>
 17a:	87aa                	mv	a5,a0
 17c:	fff6071b          	addiw	a4,a2,-1
 180:	1702                	slli	a4,a4,0x20
 182:	9301                	srli	a4,a4,0x20
 184:	0705                	addi	a4,a4,1
 186:	972a                	add	a4,a4,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x16>
  }
  return dst;
}
 192:	6422                	ld	s0,8(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <strchr>:

char*
strchr(const char *s, char c)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	cf91                	beqz	a5,1be <strchr+0x26>
    if(*s == c)
 1a4:	00f58a63          	beq	a1,a5,1b8 <strchr+0x20>
  for(; *s; s++)
 1a8:	0505                	addi	a0,a0,1
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	c781                	beqz	a5,1b6 <strchr+0x1e>
    if(*s == c)
 1b0:	feb79ce3          	bne	a5,a1,1a8 <strchr+0x10>
 1b4:	a011                	j	1b8 <strchr+0x20>
      return (char*)s;
  return 0;
 1b6:	4501                	li	a0,0
}
 1b8:	6422                	ld	s0,8(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret
  return 0;
 1be:	4501                	li	a0,0
 1c0:	bfe5                	j	1b8 <strchr+0x20>

00000000000001c2 <gets>:

char*
gets(char *buf, int max)
{
 1c2:	711d                	addi	sp,sp,-96
 1c4:	ec86                	sd	ra,88(sp)
 1c6:	e8a2                	sd	s0,80(sp)
 1c8:	e4a6                	sd	s1,72(sp)
 1ca:	e0ca                	sd	s2,64(sp)
 1cc:	fc4e                	sd	s3,56(sp)
 1ce:	f852                	sd	s4,48(sp)
 1d0:	f456                	sd	s5,40(sp)
 1d2:	f05a                	sd	s6,32(sp)
 1d4:	ec5e                	sd	s7,24(sp)
 1d6:	1080                	addi	s0,sp,96
 1d8:	8baa                	mv	s7,a0
 1da:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dc:	892a                	mv	s2,a0
 1de:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e0:	4aa9                	li	s5,10
 1e2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e4:	0019849b          	addiw	s1,s3,1
 1e8:	0344d863          	bge	s1,s4,218 <gets+0x56>
    cc = read(0, &c, 1);
 1ec:	4605                	li	a2,1
 1ee:	faf40593          	addi	a1,s0,-81
 1f2:	4501                	li	a0,0
 1f4:	00000097          	auipc	ra,0x0
 1f8:	1ac080e7          	jalr	428(ra) # 3a0 <read>
    if(cc < 1)
 1fc:	00a05e63          	blez	a0,218 <gets+0x56>
    buf[i++] = c;
 200:	faf44783          	lbu	a5,-81(s0)
 204:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 208:	01578763          	beq	a5,s5,216 <gets+0x54>
 20c:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 20e:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 210:	fd679ae3          	bne	a5,s6,1e4 <gets+0x22>
 214:	a011                	j	218 <gets+0x56>
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 218:	99de                	add	s3,s3,s7
 21a:	00098023          	sb	zero,0(s3)
  return buf;
}
 21e:	855e                	mv	a0,s7
 220:	60e6                	ld	ra,88(sp)
 222:	6446                	ld	s0,80(sp)
 224:	64a6                	ld	s1,72(sp)
 226:	6906                	ld	s2,64(sp)
 228:	79e2                	ld	s3,56(sp)
 22a:	7a42                	ld	s4,48(sp)
 22c:	7aa2                	ld	s5,40(sp)
 22e:	7b02                	ld	s6,32(sp)
 230:	6be2                	ld	s7,24(sp)
 232:	6125                	addi	sp,sp,96
 234:	8082                	ret

0000000000000236 <stat>:

int
stat(const char *n, struct stat *st)
{
 236:	1101                	addi	sp,sp,-32
 238:	ec06                	sd	ra,24(sp)
 23a:	e822                	sd	s0,16(sp)
 23c:	e426                	sd	s1,8(sp)
 23e:	e04a                	sd	s2,0(sp)
 240:	1000                	addi	s0,sp,32
 242:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	4581                	li	a1,0
 246:	00000097          	auipc	ra,0x0
 24a:	182080e7          	jalr	386(ra) # 3c8 <open>
  if(fd < 0)
 24e:	02054563          	bltz	a0,278 <stat+0x42>
 252:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 254:	85ca                	mv	a1,s2
 256:	00000097          	auipc	ra,0x0
 25a:	18a080e7          	jalr	394(ra) # 3e0 <fstat>
 25e:	892a                	mv	s2,a0
  close(fd);
 260:	8526                	mv	a0,s1
 262:	00000097          	auipc	ra,0x0
 266:	14e080e7          	jalr	334(ra) # 3b0 <close>
  return r;
}
 26a:	854a                	mv	a0,s2
 26c:	60e2                	ld	ra,24(sp)
 26e:	6442                	ld	s0,16(sp)
 270:	64a2                	ld	s1,8(sp)
 272:	6902                	ld	s2,0(sp)
 274:	6105                	addi	sp,sp,32
 276:	8082                	ret
    return -1;
 278:	597d                	li	s2,-1
 27a:	bfc5                	j	26a <stat+0x34>

000000000000027c <atoi>:

int
atoi(const char *s)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 282:	00054683          	lbu	a3,0(a0)
 286:	fd06879b          	addiw	a5,a3,-48
 28a:	0ff7f793          	andi	a5,a5,255
 28e:	4725                	li	a4,9
 290:	02f76963          	bltu	a4,a5,2c2 <atoi+0x46>
 294:	862a                	mv	a2,a0
  n = 0;
 296:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 298:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 29a:	0605                	addi	a2,a2,1
 29c:	0025179b          	slliw	a5,a0,0x2
 2a0:	9fa9                	addw	a5,a5,a0
 2a2:	0017979b          	slliw	a5,a5,0x1
 2a6:	9fb5                	addw	a5,a5,a3
 2a8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ac:	00064683          	lbu	a3,0(a2)
 2b0:	fd06871b          	addiw	a4,a3,-48
 2b4:	0ff77713          	andi	a4,a4,255
 2b8:	fee5f1e3          	bgeu	a1,a4,29a <atoi+0x1e>
  return n;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  n = 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <atoi+0x40>

00000000000002c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2cc:	02b57663          	bgeu	a0,a1,2f8 <memmove+0x32>
    while(n-- > 0)
 2d0:	02c05163          	blez	a2,2f2 <memmove+0x2c>
 2d4:	fff6079b          	addiw	a5,a2,-1
 2d8:	1782                	slli	a5,a5,0x20
 2da:	9381                	srli	a5,a5,0x20
 2dc:	0785                	addi	a5,a5,1
 2de:	97aa                	add	a5,a5,a0
  dst = vdst;
 2e0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e2:	0585                	addi	a1,a1,1
 2e4:	0705                	addi	a4,a4,1
 2e6:	fff5c683          	lbu	a3,-1(a1)
 2ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ee:	fee79ae3          	bne	a5,a4,2e2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
    dst += n;
 2f8:	00c50733          	add	a4,a0,a2
    src += n;
 2fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fe:	fec05ae3          	blez	a2,2f2 <memmove+0x2c>
 302:	fff6079b          	addiw	a5,a2,-1
 306:	1782                	slli	a5,a5,0x20
 308:	9381                	srli	a5,a5,0x20
 30a:	fff7c793          	not	a5,a5
 30e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 310:	15fd                	addi	a1,a1,-1
 312:	177d                	addi	a4,a4,-1
 314:	0005c683          	lbu	a3,0(a1)
 318:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31c:	fef71ae3          	bne	a4,a5,310 <memmove+0x4a>
 320:	bfc9                	j	2f2 <memmove+0x2c>

0000000000000322 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 328:	ce15                	beqz	a2,364 <memcmp+0x42>
 32a:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 32e:	00054783          	lbu	a5,0(a0)
 332:	0005c703          	lbu	a4,0(a1)
 336:	02e79063          	bne	a5,a4,356 <memcmp+0x34>
 33a:	1682                	slli	a3,a3,0x20
 33c:	9281                	srli	a3,a3,0x20
 33e:	0685                	addi	a3,a3,1
 340:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 342:	0505                	addi	a0,a0,1
    p2++;
 344:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 346:	00d50d63          	beq	a0,a3,360 <memcmp+0x3e>
    if (*p1 != *p2) {
 34a:	00054783          	lbu	a5,0(a0)
 34e:	0005c703          	lbu	a4,0(a1)
 352:	fee788e3          	beq	a5,a4,342 <memcmp+0x20>
      return *p1 - *p2;
 356:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  return 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <memcmp+0x38>
 364:	4501                	li	a0,0
 366:	bfd5                	j	35a <memcmp+0x38>

0000000000000368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 370:	00000097          	auipc	ra,0x0
 374:	f56080e7          	jalr	-170(ra) # 2c6 <memmove>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 380:	4885                	li	a7,1
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exit>:
.global exit
exit:
 li a7, SYS_exit
 388:	4889                	li	a7,2
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <wait>:
.global wait
wait:
 li a7, SYS_wait
 390:	488d                	li	a7,3
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 398:	4891                	li	a7,4
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <read>:
.global read
read:
 li a7, SYS_read
 3a0:	4895                	li	a7,5
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <write>:
.global write
write:
 li a7, SYS_write
 3a8:	48c1                	li	a7,16
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <close>:
.global close
close:
 li a7, SYS_close
 3b0:	48d5                	li	a7,21
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b8:	4899                	li	a7,6
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c0:	489d                	li	a7,7
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <open>:
.global open
open:
 li a7, SYS_open
 3c8:	48bd                	li	a7,15
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d0:	48c5                	li	a7,17
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d8:	48c9                	li	a7,18
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e0:	48a1                	li	a7,8
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <link>:
.global link
link:
 li a7, SYS_link
 3e8:	48cd                	li	a7,19
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f0:	48d1                	li	a7,20
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f8:	48a5                	li	a7,9
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <dup>:
.global dup
dup:
 li a7, SYS_dup
 400:	48a9                	li	a7,10
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 408:	48ad                	li	a7,11
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 410:	48b1                	li	a7,12
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 418:	48b5                	li	a7,13
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 420:	48b9                	li	a7,14
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 428:	48d9                	li	a7,22
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <trace>:
.global trace
trace:
 li a7, SYS_trace
 430:	48dd                	li	a7,23
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 438:	48e1                	li	a7,24
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 440:	1101                	addi	sp,sp,-32
 442:	ec06                	sd	ra,24(sp)
 444:	e822                	sd	s0,16(sp)
 446:	1000                	addi	s0,sp,32
 448:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44c:	4605                	li	a2,1
 44e:	fef40593          	addi	a1,s0,-17
 452:	00000097          	auipc	ra,0x0
 456:	f56080e7          	jalr	-170(ra) # 3a8 <write>
}
 45a:	60e2                	ld	ra,24(sp)
 45c:	6442                	ld	s0,16(sp)
 45e:	6105                	addi	sp,sp,32
 460:	8082                	ret

0000000000000462 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 462:	7139                	addi	sp,sp,-64
 464:	fc06                	sd	ra,56(sp)
 466:	f822                	sd	s0,48(sp)
 468:	f426                	sd	s1,40(sp)
 46a:	f04a                	sd	s2,32(sp)
 46c:	ec4e                	sd	s3,24(sp)
 46e:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 470:	c299                	beqz	a3,476 <printint+0x14>
 472:	0005cd63          	bltz	a1,48c <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 476:	2581                	sext.w	a1,a1
  neg = 0;
 478:	4301                	li	t1,0
 47a:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 47e:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 480:	2601                	sext.w	a2,a2
 482:	00000897          	auipc	a7,0x0
 486:	4b688893          	addi	a7,a7,1206 # 938 <digits>
 48a:	a801                	j	49a <printint+0x38>
    x = -xx;
 48c:	40b005bb          	negw	a1,a1
 490:	2581                	sext.w	a1,a1
    neg = 1;
 492:	4305                	li	t1,1
    x = -xx;
 494:	b7dd                	j	47a <printint+0x18>
  }while((x /= base) != 0);
 496:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 498:	8836                	mv	a6,a3
 49a:	0018069b          	addiw	a3,a6,1
 49e:	02c5f7bb          	remuw	a5,a1,a2
 4a2:	1782                	slli	a5,a5,0x20
 4a4:	9381                	srli	a5,a5,0x20
 4a6:	97c6                	add	a5,a5,a7
 4a8:	0007c783          	lbu	a5,0(a5)
 4ac:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 4b0:	0705                	addi	a4,a4,1
 4b2:	02c5d7bb          	divuw	a5,a1,a2
 4b6:	fec5f0e3          	bgeu	a1,a2,496 <printint+0x34>
  if(neg)
 4ba:	00030b63          	beqz	t1,4d0 <printint+0x6e>
    buf[i++] = '-';
 4be:	fd040793          	addi	a5,s0,-48
 4c2:	96be                	add	a3,a3,a5
 4c4:	02d00793          	li	a5,45
 4c8:	fef68823          	sb	a5,-16(a3)
 4cc:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 4d0:	02d05963          	blez	a3,502 <printint+0xa0>
 4d4:	89aa                	mv	s3,a0
 4d6:	fc040793          	addi	a5,s0,-64
 4da:	00d784b3          	add	s1,a5,a3
 4de:	fff78913          	addi	s2,a5,-1
 4e2:	9936                	add	s2,s2,a3
 4e4:	36fd                	addiw	a3,a3,-1
 4e6:	1682                	slli	a3,a3,0x20
 4e8:	9281                	srli	a3,a3,0x20
 4ea:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 4ee:	fff4c583          	lbu	a1,-1(s1)
 4f2:	854e                	mv	a0,s3
 4f4:	00000097          	auipc	ra,0x0
 4f8:	f4c080e7          	jalr	-180(ra) # 440 <putc>
  while(--i >= 0)
 4fc:	14fd                	addi	s1,s1,-1
 4fe:	ff2498e3          	bne	s1,s2,4ee <printint+0x8c>
}
 502:	70e2                	ld	ra,56(sp)
 504:	7442                	ld	s0,48(sp)
 506:	74a2                	ld	s1,40(sp)
 508:	7902                	ld	s2,32(sp)
 50a:	69e2                	ld	s3,24(sp)
 50c:	6121                	addi	sp,sp,64
 50e:	8082                	ret

0000000000000510 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 510:	7119                	addi	sp,sp,-128
 512:	fc86                	sd	ra,120(sp)
 514:	f8a2                	sd	s0,112(sp)
 516:	f4a6                	sd	s1,104(sp)
 518:	f0ca                	sd	s2,96(sp)
 51a:	ecce                	sd	s3,88(sp)
 51c:	e8d2                	sd	s4,80(sp)
 51e:	e4d6                	sd	s5,72(sp)
 520:	e0da                	sd	s6,64(sp)
 522:	fc5e                	sd	s7,56(sp)
 524:	f862                	sd	s8,48(sp)
 526:	f466                	sd	s9,40(sp)
 528:	f06a                	sd	s10,32(sp)
 52a:	ec6e                	sd	s11,24(sp)
 52c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c483          	lbu	s1,0(a1)
 532:	18048d63          	beqz	s1,6cc <vprintf+0x1bc>
 536:	8aaa                	mv	s5,a0
 538:	8b32                	mv	s6,a2
 53a:	00158913          	addi	s2,a1,1
  state = 0;
 53e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 540:	02500a13          	li	s4,37
      if(c == 'd'){
 544:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 548:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 54c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 550:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 554:	00000b97          	auipc	s7,0x0
 558:	3e4b8b93          	addi	s7,s7,996 # 938 <digits>
 55c:	a839                	j	57a <vprintf+0x6a>
        putc(fd, c);
 55e:	85a6                	mv	a1,s1
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	ede080e7          	jalr	-290(ra) # 440 <putc>
 56a:	a019                	j	570 <vprintf+0x60>
    } else if(state == '%'){
 56c:	01498f63          	beq	s3,s4,58a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 570:	0905                	addi	s2,s2,1
 572:	fff94483          	lbu	s1,-1(s2)
 576:	14048b63          	beqz	s1,6cc <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 57a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 57e:	fe0997e3          	bnez	s3,56c <vprintf+0x5c>
      if(c == '%'){
 582:	fd479ee3          	bne	a5,s4,55e <vprintf+0x4e>
        state = '%';
 586:	89be                	mv	s3,a5
 588:	b7e5                	j	570 <vprintf+0x60>
      if(c == 'd'){
 58a:	05878063          	beq	a5,s8,5ca <vprintf+0xba>
      } else if(c == 'l') {
 58e:	05978c63          	beq	a5,s9,5e6 <vprintf+0xd6>
      } else if(c == 'x') {
 592:	07a78863          	beq	a5,s10,602 <vprintf+0xf2>
      } else if(c == 'p') {
 596:	09b78463          	beq	a5,s11,61e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 59a:	07300713          	li	a4,115
 59e:	0ce78563          	beq	a5,a4,668 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a2:	06300713          	li	a4,99
 5a6:	0ee78c63          	beq	a5,a4,69e <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5aa:	11478663          	beq	a5,s4,6b6 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ae:	85d2                	mv	a1,s4
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e8e080e7          	jalr	-370(ra) # 440 <putc>
        putc(fd, c);
 5ba:	85a6                	mv	a1,s1
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e82080e7          	jalr	-382(ra) # 440 <putc>
      }
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b765                	j	570 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5ca:	008b0493          	addi	s1,s6,8
 5ce:	4685                	li	a3,1
 5d0:	4629                	li	a2,10
 5d2:	000b2583          	lw	a1,0(s6)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e8a080e7          	jalr	-374(ra) # 462 <printint>
 5e0:	8b26                	mv	s6,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b771                	j	570 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	008b0493          	addi	s1,s6,8
 5ea:	4681                	li	a3,0
 5ec:	4629                	li	a2,10
 5ee:	000b2583          	lw	a1,0(s6)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e6e080e7          	jalr	-402(ra) # 462 <printint>
 5fc:	8b26                	mv	s6,s1
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bf85                	j	570 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 602:	008b0493          	addi	s1,s6,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000b2583          	lw	a1,0(s6)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e52080e7          	jalr	-430(ra) # 462 <printint>
 618:	8b26                	mv	s6,s1
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bf91                	j	570 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 61e:	008b0793          	addi	a5,s6,8
 622:	f8f43423          	sd	a5,-120(s0)
 626:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 62a:	03000593          	li	a1,48
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e10080e7          	jalr	-496(ra) # 440 <putc>
  putc(fd, 'x');
 638:	85ea                	mv	a1,s10
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e04080e7          	jalr	-508(ra) # 440 <putc>
 644:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 646:	03c9d793          	srli	a5,s3,0x3c
 64a:	97de                	add	a5,a5,s7
 64c:	0007c583          	lbu	a1,0(a5)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	dee080e7          	jalr	-530(ra) # 440 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65a:	0992                	slli	s3,s3,0x4
 65c:	34fd                	addiw	s1,s1,-1
 65e:	f4e5                	bnez	s1,646 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 660:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 664:	4981                	li	s3,0
 666:	b729                	j	570 <vprintf+0x60>
        s = va_arg(ap, char*);
 668:	008b0993          	addi	s3,s6,8
 66c:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 670:	c085                	beqz	s1,690 <vprintf+0x180>
        while(*s != 0){
 672:	0004c583          	lbu	a1,0(s1)
 676:	c9a1                	beqz	a1,6c6 <vprintf+0x1b6>
          putc(fd, *s);
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	dc6080e7          	jalr	-570(ra) # 440 <putc>
          s++;
 682:	0485                	addi	s1,s1,1
        while(*s != 0){
 684:	0004c583          	lbu	a1,0(s1)
 688:	f9e5                	bnez	a1,678 <vprintf+0x168>
        s = va_arg(ap, char*);
 68a:	8b4e                	mv	s6,s3
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b5cd                	j	570 <vprintf+0x60>
          s = "(null)";
 690:	00000497          	auipc	s1,0x0
 694:	2c048493          	addi	s1,s1,704 # 950 <digits+0x18>
        while(*s != 0){
 698:	02800593          	li	a1,40
 69c:	bff1                	j	678 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 69e:	008b0493          	addi	s1,s6,8
 6a2:	000b4583          	lbu	a1,0(s6)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	d98080e7          	jalr	-616(ra) # 440 <putc>
 6b0:	8b26                	mv	s6,s1
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bd75                	j	570 <vprintf+0x60>
        putc(fd, c);
 6b6:	85d2                	mv	a1,s4
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	d86080e7          	jalr	-634(ra) # 440 <putc>
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b575                	j	570 <vprintf+0x60>
        s = va_arg(ap, char*);
 6c6:	8b4e                	mv	s6,s3
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b55d                	j	570 <vprintf+0x60>
    }
  }
}
 6cc:	70e6                	ld	ra,120(sp)
 6ce:	7446                	ld	s0,112(sp)
 6d0:	74a6                	ld	s1,104(sp)
 6d2:	7906                	ld	s2,96(sp)
 6d4:	69e6                	ld	s3,88(sp)
 6d6:	6a46                	ld	s4,80(sp)
 6d8:	6aa6                	ld	s5,72(sp)
 6da:	6b06                	ld	s6,64(sp)
 6dc:	7be2                	ld	s7,56(sp)
 6de:	7c42                	ld	s8,48(sp)
 6e0:	7ca2                	ld	s9,40(sp)
 6e2:	7d02                	ld	s10,32(sp)
 6e4:	6de2                	ld	s11,24(sp)
 6e6:	6109                	addi	sp,sp,128
 6e8:	8082                	ret

00000000000006ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ea:	715d                	addi	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e010                	sd	a2,0(s0)
 6f4:	e414                	sd	a3,8(s0)
 6f6:	e818                	sd	a4,16(s0)
 6f8:	ec1c                	sd	a5,24(s0)
 6fa:	03043023          	sd	a6,32(s0)
 6fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 706:	8622                	mv	a2,s0
 708:	00000097          	auipc	ra,0x0
 70c:	e08080e7          	jalr	-504(ra) # 510 <vprintf>
}
 710:	60e2                	ld	ra,24(sp)
 712:	6442                	ld	s0,16(sp)
 714:	6161                	addi	sp,sp,80
 716:	8082                	ret

0000000000000718 <printf>:

void
printf(const char *fmt, ...)
{
 718:	711d                	addi	sp,sp,-96
 71a:	ec06                	sd	ra,24(sp)
 71c:	e822                	sd	s0,16(sp)
 71e:	1000                	addi	s0,sp,32
 720:	e40c                	sd	a1,8(s0)
 722:	e810                	sd	a2,16(s0)
 724:	ec14                	sd	a3,24(s0)
 726:	f018                	sd	a4,32(s0)
 728:	f41c                	sd	a5,40(s0)
 72a:	03043823          	sd	a6,48(s0)
 72e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 732:	00840613          	addi	a2,s0,8
 736:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73a:	85aa                	mv	a1,a0
 73c:	4505                	li	a0,1
 73e:	00000097          	auipc	ra,0x0
 742:	dd2080e7          	jalr	-558(ra) # 510 <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6125                	addi	sp,sp,96
 74c:	8082                	ret

000000000000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	1141                	addi	sp,sp,-16
 750:	e422                	sd	s0,8(sp)
 752:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	00000797          	auipc	a5,0x0
 75c:	21078793          	addi	a5,a5,528 # 968 <freep>
 760:	639c                	ld	a5,0(a5)
 762:	a805                	j	792 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 764:	4618                	lw	a4,8(a2)
 766:	9db9                	addw	a1,a1,a4
 768:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76c:	6398                	ld	a4,0(a5)
 76e:	6318                	ld	a4,0(a4)
 770:	fee53823          	sd	a4,-16(a0)
 774:	a091                	j	7b8 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 776:	ff852703          	lw	a4,-8(a0)
 77a:	9e39                	addw	a2,a2,a4
 77c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 77e:	ff053703          	ld	a4,-16(a0)
 782:	e398                	sd	a4,0(a5)
 784:	a099                	j	7ca <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 786:	6398                	ld	a4,0(a5)
 788:	00e7e463          	bltu	a5,a4,790 <free+0x42>
 78c:	00e6ea63          	bltu	a3,a4,7a0 <free+0x52>
{
 790:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	fed7fae3          	bgeu	a5,a3,786 <free+0x38>
 796:	6398                	ld	a4,0(a5)
 798:	00e6e463          	bltu	a3,a4,7a0 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	fee7eae3          	bltu	a5,a4,790 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 7a0:	ff852583          	lw	a1,-8(a0)
 7a4:	6390                	ld	a2,0(a5)
 7a6:	02059713          	slli	a4,a1,0x20
 7aa:	9301                	srli	a4,a4,0x20
 7ac:	0712                	slli	a4,a4,0x4
 7ae:	9736                	add	a4,a4,a3
 7b0:	fae60ae3          	beq	a2,a4,764 <free+0x16>
    bp->s.ptr = p->s.ptr;
 7b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b8:	4790                	lw	a2,8(a5)
 7ba:	02061713          	slli	a4,a2,0x20
 7be:	9301                	srli	a4,a4,0x20
 7c0:	0712                	slli	a4,a4,0x4
 7c2:	973e                	add	a4,a4,a5
 7c4:	fae689e3          	beq	a3,a4,776 <free+0x28>
  } else
    p->s.ptr = bp;
 7c8:	e394                	sd	a3,0(a5)
  freep = p;
 7ca:	00000717          	auipc	a4,0x0
 7ce:	18f73f23          	sd	a5,414(a4) # 968 <freep>
}
 7d2:	6422                	ld	s0,8(sp)
 7d4:	0141                	addi	sp,sp,16
 7d6:	8082                	ret

00000000000007d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d8:	7139                	addi	sp,sp,-64
 7da:	fc06                	sd	ra,56(sp)
 7dc:	f822                	sd	s0,48(sp)
 7de:	f426                	sd	s1,40(sp)
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	ec4e                	sd	s3,24(sp)
 7e4:	e852                	sd	s4,16(sp)
 7e6:	e456                	sd	s5,8(sp)
 7e8:	e05a                	sd	s6,0(sp)
 7ea:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ec:	02051993          	slli	s3,a0,0x20
 7f0:	0209d993          	srli	s3,s3,0x20
 7f4:	09bd                	addi	s3,s3,15
 7f6:	0049d993          	srli	s3,s3,0x4
 7fa:	2985                	addiw	s3,s3,1
 7fc:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 800:	00000797          	auipc	a5,0x0
 804:	16878793          	addi	a5,a5,360 # 968 <freep>
 808:	6388                	ld	a0,0(a5)
 80a:	c515                	beqz	a0,836 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	03277f63          	bgeu	a4,s2,84e <malloc+0x76>
 814:	8a4e                	mv	s4,s3
 816:	0009871b          	sext.w	a4,s3
 81a:	6685                	lui	a3,0x1
 81c:	00d77363          	bgeu	a4,a3,822 <malloc+0x4a>
 820:	6a05                	lui	s4,0x1
 822:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 826:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82a:	00000497          	auipc	s1,0x0
 82e:	13e48493          	addi	s1,s1,318 # 968 <freep>
  if(p == (char*)-1)
 832:	5b7d                	li	s6,-1
 834:	a885                	j	8a4 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 836:	00000797          	auipc	a5,0x0
 83a:	13a78793          	addi	a5,a5,314 # 970 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	12f73523          	sd	a5,298(a4) # 968 <freep>
 846:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 848:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84c:	b7e1                	j	814 <malloc+0x3c>
      if(p->s.size == nunits)
 84e:	02e90b63          	beq	s2,a4,884 <malloc+0xac>
        p->s.size -= nunits;
 852:	4137073b          	subw	a4,a4,s3
 856:	c798                	sw	a4,8(a5)
        p += p->s.size;
 858:	1702                	slli	a4,a4,0x20
 85a:	9301                	srli	a4,a4,0x20
 85c:	0712                	slli	a4,a4,0x4
 85e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 860:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 864:	00000717          	auipc	a4,0x0
 868:	10a73223          	sd	a0,260(a4) # 968 <freep>
      return (void*)(p + 1);
 86c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 870:	70e2                	ld	ra,56(sp)
 872:	7442                	ld	s0,48(sp)
 874:	74a2                	ld	s1,40(sp)
 876:	7902                	ld	s2,32(sp)
 878:	69e2                	ld	s3,24(sp)
 87a:	6a42                	ld	s4,16(sp)
 87c:	6aa2                	ld	s5,8(sp)
 87e:	6b02                	ld	s6,0(sp)
 880:	6121                	addi	sp,sp,64
 882:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	e118                	sd	a4,0(a0)
 888:	bff1                	j	864 <malloc+0x8c>
  hp->s.size = nu;
 88a:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 88e:	0541                	addi	a0,a0,16
 890:	00000097          	auipc	ra,0x0
 894:	ebe080e7          	jalr	-322(ra) # 74e <free>
  return freep;
 898:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 89a:	d979                	beqz	a0,870 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89e:	4798                	lw	a4,8(a5)
 8a0:	fb2777e3          	bgeu	a4,s2,84e <malloc+0x76>
    if(p == freep)
 8a4:	6098                	ld	a4,0(s1)
 8a6:	853e                	mv	a0,a5
 8a8:	fef71ae3          	bne	a4,a5,89c <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 8ac:	8552                	mv	a0,s4
 8ae:	00000097          	auipc	ra,0x0
 8b2:	b62080e7          	jalr	-1182(ra) # 410 <sbrk>
  if(p == (char*)-1)
 8b6:	fd651ae3          	bne	a0,s6,88a <malloc+0xb2>
        return 0;
 8ba:	4501                	li	a0,0
 8bc:	bf55                	j	870 <malloc+0x98>
