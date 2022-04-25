
user/_setpriority:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84ae                	mv	s1,a1
  if(argc != 3 ){
   e:	478d                	li	a5,3
  10:	02f50163          	beq	a0,a5,32 <main+0x32>
    fprintf(2, "Usage: %s priority command\n", argv[0]);
  14:	6190                	ld	a2,0(a1)
  16:	00001597          	auipc	a1,0x1
  1a:	84a58593          	addi	a1,a1,-1974 # 860 <malloc+0xec>
  1e:	4509                	li	a0,2
  20:	00000097          	auipc	ra,0x0
  24:	666080e7          	jalr	1638(ra) # 686 <fprintf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	00000097          	auipc	ra,0x0
  2e:	2fa080e7          	jalr	762(ra) # 324 <exit>
  }

  int val = setpriority(atoi(argv[1]),atoi(argv[2]));
  32:	6588                	ld	a0,8(a1)
  34:	00000097          	auipc	ra,0x0
  38:	1e4080e7          	jalr	484(ra) # 218 <atoi>
  3c:	892a                	mv	s2,a0
  3e:	6888                	ld	a0,16(s1)
  40:	00000097          	auipc	ra,0x0
  44:	1d8080e7          	jalr	472(ra) # 218 <atoi>
  48:	85aa                	mv	a1,a0
  4a:	854a                	mv	a0,s2
  4c:	00000097          	auipc	ra,0x0
  50:	388080e7          	jalr	904(ra) # 3d4 <setpriority>
  if (val < 0) {
  54:	02054163          	bltz	a0,76 <main+0x76>
    fprintf(2, "%s: setpriority failed\n", argv[0]);
    exit(1);
  }

  printf("Old static priority of process with pid %s = %d\n", argv[2], val);
  58:	862a                	mv	a2,a0
  5a:	688c                	ld	a1,16(s1)
  5c:	00001517          	auipc	a0,0x1
  60:	83c50513          	addi	a0,a0,-1988 # 898 <malloc+0x124>
  64:	00000097          	auipc	ra,0x0
  68:	650080e7          	jalr	1616(ra) # 6b4 <printf>
  exit(0);
  6c:	4501                	li	a0,0
  6e:	00000097          	auipc	ra,0x0
  72:	2b6080e7          	jalr	694(ra) # 324 <exit>
    fprintf(2, "%s: setpriority failed\n", argv[0]);
  76:	6090                	ld	a2,0(s1)
  78:	00001597          	auipc	a1,0x1
  7c:	80858593          	addi	a1,a1,-2040 # 880 <malloc+0x10c>
  80:	4509                	li	a0,2
  82:	00000097          	auipc	ra,0x0
  86:	604080e7          	jalr	1540(ra) # 686 <fprintf>
    exit(1);
  8a:	4505                	li	a0,1
  8c:	00000097          	auipc	ra,0x0
  90:	298080e7          	jalr	664(ra) # 324 <exit>

0000000000000094 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	87aa                	mv	a5,a0
  9c:	0585                	addi	a1,a1,1
  9e:	0785                	addi	a5,a5,1
  a0:	fff5c703          	lbu	a4,-1(a1)
  a4:	fee78fa3          	sb	a4,-1(a5)
  a8:	fb75                	bnez	a4,9c <strcpy+0x8>
    ;
  return os;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strcmp+0x26>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71b63          	bne	a4,a5,d6 <strcmp+0x26>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	c789                	beqz	a5,d6 <strcmp+0x26>
  ce:	0005c703          	lbu	a4,0(a1)
  d2:	fef709e3          	beq	a4,a5,c4 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	4685                	li	a3,1
  f6:	9e89                	subw	a3,a3,a0
  f8:	00f6853b          	addw	a0,a3,a5
  fc:	0785                	addi	a5,a5,1
  fe:	fff7c703          	lbu	a4,-1(a5)
 102:	fb7d                	bnez	a4,f8 <strlen+0x14>
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ce09                	beqz	a2,12e <memset+0x20>
 116:	87aa                	mv	a5,a0
 118:	fff6071b          	addiw	a4,a2,-1
 11c:	1702                	slli	a4,a4,0x20
 11e:	9301                	srli	a4,a4,0x20
 120:	0705                	addi	a4,a4,1
 122:	972a                	add	a4,a4,a0
    cdst[i] = c;
 124:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 128:	0785                	addi	a5,a5,1
 12a:	fee79de3          	bne	a5,a4,124 <memset+0x16>
  }
  return dst;
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strchr>:

char*
strchr(const char *s, char c)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf91                	beqz	a5,15a <strchr+0x26>
    if(*s == c)
 140:	00f58a63          	beq	a1,a5,154 <strchr+0x20>
  for(; *s; s++)
 144:	0505                	addi	a0,a0,1
 146:	00054783          	lbu	a5,0(a0)
 14a:	c781                	beqz	a5,152 <strchr+0x1e>
    if(*s == c)
 14c:	feb79ce3          	bne	a5,a1,144 <strchr+0x10>
 150:	a011                	j	154 <strchr+0x20>
      return (char*)s;
  return 0;
 152:	4501                	li	a0,0
}
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret
  return 0;
 15a:	4501                	li	a0,0
 15c:	bfe5                	j	154 <strchr+0x20>

000000000000015e <gets>:

char*
gets(char *buf, int max)
{
 15e:	711d                	addi	sp,sp,-96
 160:	ec86                	sd	ra,88(sp)
 162:	e8a2                	sd	s0,80(sp)
 164:	e4a6                	sd	s1,72(sp)
 166:	e0ca                	sd	s2,64(sp)
 168:	fc4e                	sd	s3,56(sp)
 16a:	f852                	sd	s4,48(sp)
 16c:	f456                	sd	s5,40(sp)
 16e:	f05a                	sd	s6,32(sp)
 170:	ec5e                	sd	s7,24(sp)
 172:	1080                	addi	s0,sp,96
 174:	8baa                	mv	s7,a0
 176:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 178:	892a                	mv	s2,a0
 17a:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17c:	4aa9                	li	s5,10
 17e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 180:	0019849b          	addiw	s1,s3,1
 184:	0344d863          	bge	s1,s4,1b4 <gets+0x56>
    cc = read(0, &c, 1);
 188:	4605                	li	a2,1
 18a:	faf40593          	addi	a1,s0,-81
 18e:	4501                	li	a0,0
 190:	00000097          	auipc	ra,0x0
 194:	1ac080e7          	jalr	428(ra) # 33c <read>
    if(cc < 1)
 198:	00a05e63          	blez	a0,1b4 <gets+0x56>
    buf[i++] = c;
 19c:	faf44783          	lbu	a5,-81(s0)
 1a0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a4:	01578763          	beq	a5,s5,1b2 <gets+0x54>
 1a8:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 1aa:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 1ac:	fd679ae3          	bne	a5,s6,180 <gets+0x22>
 1b0:	a011                	j	1b4 <gets+0x56>
  for(i=0; i+1 < max; ){
 1b2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b4:	99de                	add	s3,s3,s7
 1b6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ba:	855e                	mv	a0,s7
 1bc:	60e6                	ld	ra,88(sp)
 1be:	6446                	ld	s0,80(sp)
 1c0:	64a6                	ld	s1,72(sp)
 1c2:	6906                	ld	s2,64(sp)
 1c4:	79e2                	ld	s3,56(sp)
 1c6:	7a42                	ld	s4,48(sp)
 1c8:	7aa2                	ld	s5,40(sp)
 1ca:	7b02                	ld	s6,32(sp)
 1cc:	6be2                	ld	s7,24(sp)
 1ce:	6125                	addi	sp,sp,96
 1d0:	8082                	ret

00000000000001d2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d2:	1101                	addi	sp,sp,-32
 1d4:	ec06                	sd	ra,24(sp)
 1d6:	e822                	sd	s0,16(sp)
 1d8:	e426                	sd	s1,8(sp)
 1da:	e04a                	sd	s2,0(sp)
 1dc:	1000                	addi	s0,sp,32
 1de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e0:	4581                	li	a1,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	182080e7          	jalr	386(ra) # 364 <open>
  if(fd < 0)
 1ea:	02054563          	bltz	a0,214 <stat+0x42>
 1ee:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f0:	85ca                	mv	a1,s2
 1f2:	00000097          	auipc	ra,0x0
 1f6:	18a080e7          	jalr	394(ra) # 37c <fstat>
 1fa:	892a                	mv	s2,a0
  close(fd);
 1fc:	8526                	mv	a0,s1
 1fe:	00000097          	auipc	ra,0x0
 202:	14e080e7          	jalr	334(ra) # 34c <close>
  return r;
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	64a2                	ld	s1,8(sp)
 20e:	6902                	ld	s2,0(sp)
 210:	6105                	addi	sp,sp,32
 212:	8082                	ret
    return -1;
 214:	597d                	li	s2,-1
 216:	bfc5                	j	206 <stat+0x34>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21e:	00054683          	lbu	a3,0(a0)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	andi	a5,a5,255
 22a:	4725                	li	a4,9
 22c:	02f76963          	bltu	a4,a5,25e <atoi+0x46>
 230:	862a                	mv	a2,a0
  n = 0;
 232:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 234:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 236:	0605                	addi	a2,a2,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00064683          	lbu	a3,0(a2)
 24c:	fd06871b          	addiw	a4,a3,-48
 250:	0ff77713          	andi	a4,a4,255
 254:	fee5f1e3          	bgeu	a1,a4,236 <atoi+0x1e>
  return n;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <atoi+0x40>

0000000000000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 268:	02b57663          	bgeu	a0,a1,294 <memmove+0x32>
    while(n-- > 0)
 26c:	02c05163          	blez	a2,28e <memmove+0x2c>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	0785                	addi	a5,a5,1
 27a:	97aa                	add	a5,a5,a0
  dst = vdst;
 27c:	872a                	mv	a4,a0
      *dst++ = *src++;
 27e:	0585                	addi	a1,a1,1
 280:	0705                	addi	a4,a4,1
 282:	fff5c683          	lbu	a3,-1(a1)
 286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
    dst += n;
 294:	00c50733          	add	a4,a0,a2
    src += n;
 298:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29a:	fec05ae3          	blez	a2,28e <memmove+0x2c>
 29e:	fff6079b          	addiw	a5,a2,-1
 2a2:	1782                	slli	a5,a5,0x20
 2a4:	9381                	srli	a5,a5,0x20
 2a6:	fff7c793          	not	a5,a5
 2aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ac:	15fd                	addi	a1,a1,-1
 2ae:	177d                	addi	a4,a4,-1
 2b0:	0005c683          	lbu	a3,0(a1)
 2b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x4a>
 2bc:	bfc9                	j	28e <memmove+0x2c>

00000000000002be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c4:	ce15                	beqz	a2,300 <memcmp+0x42>
 2c6:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	0005c703          	lbu	a4,0(a1)
 2d2:	02e79063          	bne	a5,a4,2f2 <memcmp+0x34>
 2d6:	1682                	slli	a3,a3,0x20
 2d8:	9281                	srli	a3,a3,0x20
 2da:	0685                	addi	a3,a3,1
 2dc:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 2de:	0505                	addi	a0,a0,1
    p2++;
 2e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e2:	00d50d63          	beq	a0,a3,2fc <memcmp+0x3e>
    if (*p1 != *p2) {
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	fee788e3          	beq	a5,a4,2de <memcmp+0x20>
      return *p1 - *p2;
 2f2:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  return 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <memcmp+0x38>
 300:	4501                	li	a0,0
 302:	bfd5                	j	2f6 <memcmp+0x38>

0000000000000304 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30c:	00000097          	auipc	ra,0x0
 310:	f56080e7          	jalr	-170(ra) # 262 <memmove>
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31c:	4885                	li	a7,1
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <exit>:
.global exit
exit:
 li a7, SYS_exit
 324:	4889                	li	a7,2
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <wait>:
.global wait
wait:
 li a7, SYS_wait
 32c:	488d                	li	a7,3
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 334:	4891                	li	a7,4
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <read>:
.global read
read:
 li a7, SYS_read
 33c:	4895                	li	a7,5
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <write>:
.global write
write:
 li a7, SYS_write
 344:	48c1                	li	a7,16
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <close>:
.global close
close:
 li a7, SYS_close
 34c:	48d5                	li	a7,21
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <kill>:
.global kill
kill:
 li a7, SYS_kill
 354:	4899                	li	a7,6
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <exec>:
.global exec
exec:
 li a7, SYS_exec
 35c:	489d                	li	a7,7
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <open>:
.global open
open:
 li a7, SYS_open
 364:	48bd                	li	a7,15
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36c:	48c5                	li	a7,17
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 374:	48c9                	li	a7,18
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37c:	48a1                	li	a7,8
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <link>:
.global link
link:
 li a7, SYS_link
 384:	48cd                	li	a7,19
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38c:	48d1                	li	a7,20
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 394:	48a5                	li	a7,9
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <dup>:
.global dup
dup:
 li a7, SYS_dup
 39c:	48a9                	li	a7,10
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a4:	48ad                	li	a7,11
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ac:	48b1                	li	a7,12
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b4:	48b5                	li	a7,13
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3bc:	48b9                	li	a7,14
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3c4:	48d9                	li	a7,22
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <trace>:
.global trace
trace:
 li a7, SYS_trace
 3cc:	48dd                	li	a7,23
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3d4:	48e1                	li	a7,24
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3dc:	1101                	addi	sp,sp,-32
 3de:	ec06                	sd	ra,24(sp)
 3e0:	e822                	sd	s0,16(sp)
 3e2:	1000                	addi	s0,sp,32
 3e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e8:	4605                	li	a2,1
 3ea:	fef40593          	addi	a1,s0,-17
 3ee:	00000097          	auipc	ra,0x0
 3f2:	f56080e7          	jalr	-170(ra) # 344 <write>
}
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6105                	addi	sp,sp,32
 3fc:	8082                	ret

00000000000003fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fe:	7139                	addi	sp,sp,-64
 400:	fc06                	sd	ra,56(sp)
 402:	f822                	sd	s0,48(sp)
 404:	f426                	sd	s1,40(sp)
 406:	f04a                	sd	s2,32(sp)
 408:	ec4e                	sd	s3,24(sp)
 40a:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40c:	c299                	beqz	a3,412 <printint+0x14>
 40e:	0005cd63          	bltz	a1,428 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 412:	2581                	sext.w	a1,a1
  neg = 0;
 414:	4301                	li	t1,0
 416:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 41a:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 41c:	2601                	sext.w	a2,a2
 41e:	00000897          	auipc	a7,0x0
 422:	4b288893          	addi	a7,a7,1202 # 8d0 <digits>
 426:	a801                	j	436 <printint+0x38>
    x = -xx;
 428:	40b005bb          	negw	a1,a1
 42c:	2581                	sext.w	a1,a1
    neg = 1;
 42e:	4305                	li	t1,1
    x = -xx;
 430:	b7dd                	j	416 <printint+0x18>
  }while((x /= base) != 0);
 432:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 434:	8836                	mv	a6,a3
 436:	0018069b          	addiw	a3,a6,1
 43a:	02c5f7bb          	remuw	a5,a1,a2
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	97c6                	add	a5,a5,a7
 444:	0007c783          	lbu	a5,0(a5)
 448:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 44c:	0705                	addi	a4,a4,1
 44e:	02c5d7bb          	divuw	a5,a1,a2
 452:	fec5f0e3          	bgeu	a1,a2,432 <printint+0x34>
  if(neg)
 456:	00030b63          	beqz	t1,46c <printint+0x6e>
    buf[i++] = '-';
 45a:	fd040793          	addi	a5,s0,-48
 45e:	96be                	add	a3,a3,a5
 460:	02d00793          	li	a5,45
 464:	fef68823          	sb	a5,-16(a3)
 468:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 46c:	02d05963          	blez	a3,49e <printint+0xa0>
 470:	89aa                	mv	s3,a0
 472:	fc040793          	addi	a5,s0,-64
 476:	00d784b3          	add	s1,a5,a3
 47a:	fff78913          	addi	s2,a5,-1
 47e:	9936                	add	s2,s2,a3
 480:	36fd                	addiw	a3,a3,-1
 482:	1682                	slli	a3,a3,0x20
 484:	9281                	srli	a3,a3,0x20
 486:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 48a:	fff4c583          	lbu	a1,-1(s1)
 48e:	854e                	mv	a0,s3
 490:	00000097          	auipc	ra,0x0
 494:	f4c080e7          	jalr	-180(ra) # 3dc <putc>
  while(--i >= 0)
 498:	14fd                	addi	s1,s1,-1
 49a:	ff2498e3          	bne	s1,s2,48a <printint+0x8c>
}
 49e:	70e2                	ld	ra,56(sp)
 4a0:	7442                	ld	s0,48(sp)
 4a2:	74a2                	ld	s1,40(sp)
 4a4:	7902                	ld	s2,32(sp)
 4a6:	69e2                	ld	s3,24(sp)
 4a8:	6121                	addi	sp,sp,64
 4aa:	8082                	ret

00000000000004ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ac:	7119                	addi	sp,sp,-128
 4ae:	fc86                	sd	ra,120(sp)
 4b0:	f8a2                	sd	s0,112(sp)
 4b2:	f4a6                	sd	s1,104(sp)
 4b4:	f0ca                	sd	s2,96(sp)
 4b6:	ecce                	sd	s3,88(sp)
 4b8:	e8d2                	sd	s4,80(sp)
 4ba:	e4d6                	sd	s5,72(sp)
 4bc:	e0da                	sd	s6,64(sp)
 4be:	fc5e                	sd	s7,56(sp)
 4c0:	f862                	sd	s8,48(sp)
 4c2:	f466                	sd	s9,40(sp)
 4c4:	f06a                	sd	s10,32(sp)
 4c6:	ec6e                	sd	s11,24(sp)
 4c8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ca:	0005c483          	lbu	s1,0(a1)
 4ce:	18048d63          	beqz	s1,668 <vprintf+0x1bc>
 4d2:	8aaa                	mv	s5,a0
 4d4:	8b32                	mv	s6,a2
 4d6:	00158913          	addi	s2,a1,1
  state = 0;
 4da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dc:	02500a13          	li	s4,37
      if(c == 'd'){
 4e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4e4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4e8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4ec:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f0:	00000b97          	auipc	s7,0x0
 4f4:	3e0b8b93          	addi	s7,s7,992 # 8d0 <digits>
 4f8:	a839                	j	516 <vprintf+0x6a>
        putc(fd, c);
 4fa:	85a6                	mv	a1,s1
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	ede080e7          	jalr	-290(ra) # 3dc <putc>
 506:	a019                	j	50c <vprintf+0x60>
    } else if(state == '%'){
 508:	01498f63          	beq	s3,s4,526 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 50c:	0905                	addi	s2,s2,1
 50e:	fff94483          	lbu	s1,-1(s2)
 512:	14048b63          	beqz	s1,668 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 516:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51a:	fe0997e3          	bnez	s3,508 <vprintf+0x5c>
      if(c == '%'){
 51e:	fd479ee3          	bne	a5,s4,4fa <vprintf+0x4e>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7e5                	j	50c <vprintf+0x60>
      if(c == 'd'){
 526:	05878063          	beq	a5,s8,566 <vprintf+0xba>
      } else if(c == 'l') {
 52a:	05978c63          	beq	a5,s9,582 <vprintf+0xd6>
      } else if(c == 'x') {
 52e:	07a78863          	beq	a5,s10,59e <vprintf+0xf2>
      } else if(c == 'p') {
 532:	09b78463          	beq	a5,s11,5ba <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 536:	07300713          	li	a4,115
 53a:	0ce78563          	beq	a5,a4,604 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53e:	06300713          	li	a4,99
 542:	0ee78c63          	beq	a5,a4,63a <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 546:	11478663          	beq	a5,s4,652 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54a:	85d2                	mv	a1,s4
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	e8e080e7          	jalr	-370(ra) # 3dc <putc>
        putc(fd, c);
 556:	85a6                	mv	a1,s1
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e82080e7          	jalr	-382(ra) # 3dc <putc>
      }
      state = 0;
 562:	4981                	li	s3,0
 564:	b765                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 566:	008b0493          	addi	s1,s6,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000b2583          	lw	a1,0(s6)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e8a080e7          	jalr	-374(ra) # 3fe <printint>
 57c:	8b26                	mv	s6,s1
      state = 0;
 57e:	4981                	li	s3,0
 580:	b771                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 582:	008b0493          	addi	s1,s6,8
 586:	4681                	li	a3,0
 588:	4629                	li	a2,10
 58a:	000b2583          	lw	a1,0(s6)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e6e080e7          	jalr	-402(ra) # 3fe <printint>
 598:	8b26                	mv	s6,s1
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bf85                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 59e:	008b0493          	addi	s1,s6,8
 5a2:	4681                	li	a3,0
 5a4:	4641                	li	a2,16
 5a6:	000b2583          	lw	a1,0(s6)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e52080e7          	jalr	-430(ra) # 3fe <printint>
 5b4:	8b26                	mv	s6,s1
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bf91                	j	50c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ba:	008b0793          	addi	a5,s6,8
 5be:	f8f43423          	sd	a5,-120(s0)
 5c2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5c6:	03000593          	li	a1,48
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e10080e7          	jalr	-496(ra) # 3dc <putc>
  putc(fd, 'x');
 5d4:	85ea                	mv	a1,s10
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e04080e7          	jalr	-508(ra) # 3dc <putc>
 5e0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e2:	03c9d793          	srli	a5,s3,0x3c
 5e6:	97de                	add	a5,a5,s7
 5e8:	0007c583          	lbu	a1,0(a5)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	dee080e7          	jalr	-530(ra) # 3dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f6:	0992                	slli	s3,s3,0x4
 5f8:	34fd                	addiw	s1,s1,-1
 5fa:	f4e5                	bnez	s1,5e2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5fc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 600:	4981                	li	s3,0
 602:	b729                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 604:	008b0993          	addi	s3,s6,8
 608:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 60c:	c085                	beqz	s1,62c <vprintf+0x180>
        while(*s != 0){
 60e:	0004c583          	lbu	a1,0(s1)
 612:	c9a1                	beqz	a1,662 <vprintf+0x1b6>
          putc(fd, *s);
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	dc6080e7          	jalr	-570(ra) # 3dc <putc>
          s++;
 61e:	0485                	addi	s1,s1,1
        while(*s != 0){
 620:	0004c583          	lbu	a1,0(s1)
 624:	f9e5                	bnez	a1,614 <vprintf+0x168>
        s = va_arg(ap, char*);
 626:	8b4e                	mv	s6,s3
      state = 0;
 628:	4981                	li	s3,0
 62a:	b5cd                	j	50c <vprintf+0x60>
          s = "(null)";
 62c:	00000497          	auipc	s1,0x0
 630:	2bc48493          	addi	s1,s1,700 # 8e8 <digits+0x18>
        while(*s != 0){
 634:	02800593          	li	a1,40
 638:	bff1                	j	614 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 63a:	008b0493          	addi	s1,s6,8
 63e:	000b4583          	lbu	a1,0(s6)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	d98080e7          	jalr	-616(ra) # 3dc <putc>
 64c:	8b26                	mv	s6,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	bd75                	j	50c <vprintf+0x60>
        putc(fd, c);
 652:	85d2                	mv	a1,s4
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	d86080e7          	jalr	-634(ra) # 3dc <putc>
      state = 0;
 65e:	4981                	li	s3,0
 660:	b575                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 662:	8b4e                	mv	s6,s3
      state = 0;
 664:	4981                	li	s3,0
 666:	b55d                	j	50c <vprintf+0x60>
    }
  }
}
 668:	70e6                	ld	ra,120(sp)
 66a:	7446                	ld	s0,112(sp)
 66c:	74a6                	ld	s1,104(sp)
 66e:	7906                	ld	s2,96(sp)
 670:	69e6                	ld	s3,88(sp)
 672:	6a46                	ld	s4,80(sp)
 674:	6aa6                	ld	s5,72(sp)
 676:	6b06                	ld	s6,64(sp)
 678:	7be2                	ld	s7,56(sp)
 67a:	7c42                	ld	s8,48(sp)
 67c:	7ca2                	ld	s9,40(sp)
 67e:	7d02                	ld	s10,32(sp)
 680:	6de2                	ld	s11,24(sp)
 682:	6109                	addi	sp,sp,128
 684:	8082                	ret

0000000000000686 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 686:	715d                	addi	sp,sp,-80
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	addi	s0,sp,32
 68e:	e010                	sd	a2,0(s0)
 690:	e414                	sd	a3,8(s0)
 692:	e818                	sd	a4,16(s0)
 694:	ec1c                	sd	a5,24(s0)
 696:	03043023          	sd	a6,32(s0)
 69a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 69e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a2:	8622                	mv	a2,s0
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e08080e7          	jalr	-504(ra) # 4ac <vprintf>
}
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	6161                	addi	sp,sp,80
 6b2:	8082                	ret

00000000000006b4 <printf>:

void
printf(const char *fmt, ...)
{
 6b4:	711d                	addi	sp,sp,-96
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	e40c                	sd	a1,8(s0)
 6be:	e810                	sd	a2,16(s0)
 6c0:	ec14                	sd	a3,24(s0)
 6c2:	f018                	sd	a4,32(s0)
 6c4:	f41c                	sd	a5,40(s0)
 6c6:	03043823          	sd	a6,48(s0)
 6ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	00840613          	addi	a2,s0,8
 6d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d6:	85aa                	mv	a1,a0
 6d8:	4505                	li	a0,1
 6da:	00000097          	auipc	ra,0x0
 6de:	dd2080e7          	jalr	-558(ra) # 4ac <vprintf>
}
 6e2:	60e2                	ld	ra,24(sp)
 6e4:	6442                	ld	s0,16(sp)
 6e6:	6125                	addi	sp,sp,96
 6e8:	8082                	ret

00000000000006ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ea:	1141                	addi	sp,sp,-16
 6ec:	e422                	sd	s0,8(sp)
 6ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f4:	00000797          	auipc	a5,0x0
 6f8:	1fc78793          	addi	a5,a5,508 # 8f0 <freep>
 6fc:	639c                	ld	a5,0(a5)
 6fe:	a805                	j	72e <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 700:	4618                	lw	a4,8(a2)
 702:	9db9                	addw	a1,a1,a4
 704:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 708:	6398                	ld	a4,0(a5)
 70a:	6318                	ld	a4,0(a4)
 70c:	fee53823          	sd	a4,-16(a0)
 710:	a091                	j	754 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 712:	ff852703          	lw	a4,-8(a0)
 716:	9e39                	addw	a2,a2,a4
 718:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 71a:	ff053703          	ld	a4,-16(a0)
 71e:	e398                	sd	a4,0(a5)
 720:	a099                	j	766 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	6398                	ld	a4,0(a5)
 724:	00e7e463          	bltu	a5,a4,72c <free+0x42>
 728:	00e6ea63          	bltu	a3,a4,73c <free+0x52>
{
 72c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72e:	fed7fae3          	bgeu	a5,a3,722 <free+0x38>
 732:	6398                	ld	a4,0(a5)
 734:	00e6e463          	bltu	a3,a4,73c <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	fee7eae3          	bltu	a5,a4,72c <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 73c:	ff852583          	lw	a1,-8(a0)
 740:	6390                	ld	a2,0(a5)
 742:	02059713          	slli	a4,a1,0x20
 746:	9301                	srli	a4,a4,0x20
 748:	0712                	slli	a4,a4,0x4
 74a:	9736                	add	a4,a4,a3
 74c:	fae60ae3          	beq	a2,a4,700 <free+0x16>
    bp->s.ptr = p->s.ptr;
 750:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 754:	4790                	lw	a2,8(a5)
 756:	02061713          	slli	a4,a2,0x20
 75a:	9301                	srli	a4,a4,0x20
 75c:	0712                	slli	a4,a4,0x4
 75e:	973e                	add	a4,a4,a5
 760:	fae689e3          	beq	a3,a4,712 <free+0x28>
  } else
    p->s.ptr = bp;
 764:	e394                	sd	a3,0(a5)
  freep = p;
 766:	00000717          	auipc	a4,0x0
 76a:	18f73523          	sd	a5,394(a4) # 8f0 <freep>
}
 76e:	6422                	ld	s0,8(sp)
 770:	0141                	addi	sp,sp,16
 772:	8082                	ret

0000000000000774 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 774:	7139                	addi	sp,sp,-64
 776:	fc06                	sd	ra,56(sp)
 778:	f822                	sd	s0,48(sp)
 77a:	f426                	sd	s1,40(sp)
 77c:	f04a                	sd	s2,32(sp)
 77e:	ec4e                	sd	s3,24(sp)
 780:	e852                	sd	s4,16(sp)
 782:	e456                	sd	s5,8(sp)
 784:	e05a                	sd	s6,0(sp)
 786:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 788:	02051993          	slli	s3,a0,0x20
 78c:	0209d993          	srli	s3,s3,0x20
 790:	09bd                	addi	s3,s3,15
 792:	0049d993          	srli	s3,s3,0x4
 796:	2985                	addiw	s3,s3,1
 798:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 79c:	00000797          	auipc	a5,0x0
 7a0:	15478793          	addi	a5,a5,340 # 8f0 <freep>
 7a4:	6388                	ld	a0,0(a5)
 7a6:	c515                	beqz	a0,7d2 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7aa:	4798                	lw	a4,8(a5)
 7ac:	03277f63          	bgeu	a4,s2,7ea <malloc+0x76>
 7b0:	8a4e                	mv	s4,s3
 7b2:	0009871b          	sext.w	a4,s3
 7b6:	6685                	lui	a3,0x1
 7b8:	00d77363          	bgeu	a4,a3,7be <malloc+0x4a>
 7bc:	6a05                	lui	s4,0x1
 7be:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 7c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c6:	00000497          	auipc	s1,0x0
 7ca:	12a48493          	addi	s1,s1,298 # 8f0 <freep>
  if(p == (char*)-1)
 7ce:	5b7d                	li	s6,-1
 7d0:	a885                	j	840 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 7d2:	00000797          	auipc	a5,0x0
 7d6:	12678793          	addi	a5,a5,294 # 8f8 <base>
 7da:	00000717          	auipc	a4,0x0
 7de:	10f73b23          	sd	a5,278(a4) # 8f0 <freep>
 7e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e8:	b7e1                	j	7b0 <malloc+0x3c>
      if(p->s.size == nunits)
 7ea:	02e90b63          	beq	s2,a4,820 <malloc+0xac>
        p->s.size -= nunits;
 7ee:	4137073b          	subw	a4,a4,s3
 7f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f4:	1702                	slli	a4,a4,0x20
 7f6:	9301                	srli	a4,a4,0x20
 7f8:	0712                	slli	a4,a4,0x4
 7fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 800:	00000717          	auipc	a4,0x0
 804:	0ea73823          	sd	a0,240(a4) # 8f0 <freep>
      return (void*)(p + 1);
 808:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 80c:	70e2                	ld	ra,56(sp)
 80e:	7442                	ld	s0,48(sp)
 810:	74a2                	ld	s1,40(sp)
 812:	7902                	ld	s2,32(sp)
 814:	69e2                	ld	s3,24(sp)
 816:	6a42                	ld	s4,16(sp)
 818:	6aa2                	ld	s5,8(sp)
 81a:	6b02                	ld	s6,0(sp)
 81c:	6121                	addi	sp,sp,64
 81e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	e118                	sd	a4,0(a0)
 824:	bff1                	j	800 <malloc+0x8c>
  hp->s.size = nu;
 826:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 82a:	0541                	addi	a0,a0,16
 82c:	00000097          	auipc	ra,0x0
 830:	ebe080e7          	jalr	-322(ra) # 6ea <free>
  return freep;
 834:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 836:	d979                	beqz	a0,80c <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83a:	4798                	lw	a4,8(a5)
 83c:	fb2777e3          	bgeu	a4,s2,7ea <malloc+0x76>
    if(p == freep)
 840:	6098                	ld	a4,0(s1)
 842:	853e                	mv	a0,a5
 844:	fef71ae3          	bne	a4,a5,838 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 848:	8552                	mv	a0,s4
 84a:	00000097          	auipc	ra,0x0
 84e:	b62080e7          	jalr	-1182(ra) # 3ac <sbrk>
  if(p == (char*)-1)
 852:	fd651ae3          	bne	a0,s6,826 <malloc+0xb2>
        return 0;
 856:	4501                	li	a0,0
 858:	bf55                	j	80c <malloc+0x98>
