
user/_strace:     file format elf64-littleriscv


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
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  if(argc < 3 || (argv[1][0] < '0' || argv[1][0] > '9')){
   c:	4789                	li	a5,2
   e:	00a7dc63          	bge	a5,a0,26 <main+0x26>
  12:	6588                	ld	a0,8(a1)
  14:	00054783          	lbu	a5,0(a0)
  18:	fd07879b          	addiw	a5,a5,-48
  1c:	0ff7f793          	andi	a5,a5,255
  20:	4725                	li	a4,9
  22:	02f77163          	bgeu	a4,a5,44 <main+0x44>
    fprintf(2, "Usage: %s mask command\n", argv[0]);
  26:	6090                	ld	a2,0(s1)
  28:	00001597          	auipc	a1,0x1
  2c:	83058593          	addi	a1,a1,-2000 # 858 <malloc+0xea>
  30:	4509                	li	a0,2
  32:	00000097          	auipc	ra,0x0
  36:	64e080e7          	jalr	1614(ra) # 680 <fprintf>
    exit(1);
  3a:	4505                	li	a0,1
  3c:	00000097          	auipc	ra,0x0
  40:	2e2080e7          	jalr	738(ra) # 31e <exit>
  }
    
  if (trace(atoi(argv[1])) < 0) {
  44:	00000097          	auipc	ra,0x0
  48:	1ce080e7          	jalr	462(ra) # 212 <atoi>
  4c:	00000097          	auipc	ra,0x0
  50:	37a080e7          	jalr	890(ra) # 3c6 <trace>
  54:	00054e63          	bltz	a0,70 <main+0x70>
    fprintf(2, "%s: trace failed\n", argv[0]);
    exit(1);
  }
  
  exec(argv[2], argv+2);
  58:	01048593          	addi	a1,s1,16
  5c:	6888                	ld	a0,16(s1)
  5e:	00000097          	auipc	ra,0x0
  62:	2f8080e7          	jalr	760(ra) # 356 <exec>
  exit(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	2b6080e7          	jalr	694(ra) # 31e <exit>
    fprintf(2, "%s: trace failed\n", argv[0]);
  70:	6090                	ld	a2,0(s1)
  72:	00000597          	auipc	a1,0x0
  76:	7fe58593          	addi	a1,a1,2046 # 870 <malloc+0x102>
  7a:	4509                	li	a0,2
  7c:	00000097          	auipc	ra,0x0
  80:	604080e7          	jalr	1540(ra) # 680 <fprintf>
    exit(1);
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	298080e7          	jalr	664(ra) # 31e <exit>

000000000000008e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0x8>
    ;
  return os;
}
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf91                	beqz	a5,d0 <strcmp+0x26>
  b6:	0005c703          	lbu	a4,0(a1)
  ba:	00f71b63          	bne	a4,a5,d0 <strcmp+0x26>
    p++, q++;
  be:	0505                	addi	a0,a0,1
  c0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	c789                	beqz	a5,d0 <strcmp+0x26>
  c8:	0005c703          	lbu	a4,0(a1)
  cc:	fef709e3          	beq	a4,a5,be <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  d0:	0005c503          	lbu	a0,0(a1)
}
  d4:	40a7853b          	subw	a0,a5,a0
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strlen>:

uint
strlen(const char *s)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x26>
  ea:	0505                	addi	a0,a0,1
  ec:	87aa                	mv	a5,a0
  ee:	4685                	li	a3,1
  f0:	9e89                	subw	a3,a3,a0
  f2:	00f6853b          	addw	a0,a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	fb7d                	bnez	a4,f2 <strlen+0x14>
    ;
  return n;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret
  for(n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfe5                	j	fe <strlen+0x20>

0000000000000108 <memset>:

void*
memset(void *dst, int c, uint n)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10e:	ce09                	beqz	a2,128 <memset+0x20>
 110:	87aa                	mv	a5,a0
 112:	fff6071b          	addiw	a4,a2,-1
 116:	1702                	slli	a4,a4,0x20
 118:	9301                	srli	a4,a4,0x20
 11a:	0705                	addi	a4,a4,1
 11c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x16>
  }
  return dst;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char*
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  for(; *s; s++)
 134:	00054783          	lbu	a5,0(a0)
 138:	cf91                	beqz	a5,154 <strchr+0x26>
    if(*s == c)
 13a:	00f58a63          	beq	a1,a5,14e <strchr+0x20>
  for(; *s; s++)
 13e:	0505                	addi	a0,a0,1
 140:	00054783          	lbu	a5,0(a0)
 144:	c781                	beqz	a5,14c <strchr+0x1e>
    if(*s == c)
 146:	feb79ce3          	bne	a5,a1,13e <strchr+0x10>
 14a:	a011                	j	14e <strchr+0x20>
      return (char*)s;
  return 0;
 14c:	4501                	li	a0,0
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfe5                	j	14e <strchr+0x20>

0000000000000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	711d                	addi	sp,sp,-96
 15a:	ec86                	sd	ra,88(sp)
 15c:	e8a2                	sd	s0,80(sp)
 15e:	e4a6                	sd	s1,72(sp)
 160:	e0ca                	sd	s2,64(sp)
 162:	fc4e                	sd	s3,56(sp)
 164:	f852                	sd	s4,48(sp)
 166:	f456                	sd	s5,40(sp)
 168:	f05a                	sd	s6,32(sp)
 16a:	ec5e                	sd	s7,24(sp)
 16c:	1080                	addi	s0,sp,96
 16e:	8baa                	mv	s7,a0
 170:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	892a                	mv	s2,a0
 174:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 176:	4aa9                	li	s5,10
 178:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 17a:	0019849b          	addiw	s1,s3,1
 17e:	0344d863          	bge	s1,s4,1ae <gets+0x56>
    cc = read(0, &c, 1);
 182:	4605                	li	a2,1
 184:	faf40593          	addi	a1,s0,-81
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	1ac080e7          	jalr	428(ra) # 336 <read>
    if(cc < 1)
 192:	00a05e63          	blez	a0,1ae <gets+0x56>
    buf[i++] = c;
 196:	faf44783          	lbu	a5,-81(s0)
 19a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19e:	01578763          	beq	a5,s5,1ac <gets+0x54>
 1a2:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 1a4:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 1a6:	fd679ae3          	bne	a5,s6,17a <gets+0x22>
 1aa:	a011                	j	1ae <gets+0x56>
  for(i=0; i+1 < max; ){
 1ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ae:	99de                	add	s3,s3,s7
 1b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1b4:	855e                	mv	a0,s7
 1b6:	60e6                	ld	ra,88(sp)
 1b8:	6446                	ld	s0,80(sp)
 1ba:	64a6                	ld	s1,72(sp)
 1bc:	6906                	ld	s2,64(sp)
 1be:	79e2                	ld	s3,56(sp)
 1c0:	7a42                	ld	s4,48(sp)
 1c2:	7aa2                	ld	s5,40(sp)
 1c4:	7b02                	ld	s6,32(sp)
 1c6:	6be2                	ld	s7,24(sp)
 1c8:	6125                	addi	sp,sp,96
 1ca:	8082                	ret

00000000000001cc <stat>:

int
stat(const char *n, struct stat *st)
{
 1cc:	1101                	addi	sp,sp,-32
 1ce:	ec06                	sd	ra,24(sp)
 1d0:	e822                	sd	s0,16(sp)
 1d2:	e426                	sd	s1,8(sp)
 1d4:	e04a                	sd	s2,0(sp)
 1d6:	1000                	addi	s0,sp,32
 1d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1da:	4581                	li	a1,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	182080e7          	jalr	386(ra) # 35e <open>
  if(fd < 0)
 1e4:	02054563          	bltz	a0,20e <stat+0x42>
 1e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ea:	85ca                	mv	a1,s2
 1ec:	00000097          	auipc	ra,0x0
 1f0:	18a080e7          	jalr	394(ra) # 376 <fstat>
 1f4:	892a                	mv	s2,a0
  close(fd);
 1f6:	8526                	mv	a0,s1
 1f8:	00000097          	auipc	ra,0x0
 1fc:	14e080e7          	jalr	334(ra) # 346 <close>
  return r;
}
 200:	854a                	mv	a0,s2
 202:	60e2                	ld	ra,24(sp)
 204:	6442                	ld	s0,16(sp)
 206:	64a2                	ld	s1,8(sp)
 208:	6902                	ld	s2,0(sp)
 20a:	6105                	addi	sp,sp,32
 20c:	8082                	ret
    return -1;
 20e:	597d                	li	s2,-1
 210:	bfc5                	j	200 <stat+0x34>

0000000000000212 <atoi>:

int
atoi(const char *s)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 218:	00054683          	lbu	a3,0(a0)
 21c:	fd06879b          	addiw	a5,a3,-48
 220:	0ff7f793          	andi	a5,a5,255
 224:	4725                	li	a4,9
 226:	02f76963          	bltu	a4,a5,258 <atoi+0x46>
 22a:	862a                	mv	a2,a0
  n = 0;
 22c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 22e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 230:	0605                	addi	a2,a2,1
 232:	0025179b          	slliw	a5,a0,0x2
 236:	9fa9                	addw	a5,a5,a0
 238:	0017979b          	slliw	a5,a5,0x1
 23c:	9fb5                	addw	a5,a5,a3
 23e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 242:	00064683          	lbu	a3,0(a2)
 246:	fd06871b          	addiw	a4,a3,-48
 24a:	0ff77713          	andi	a4,a4,255
 24e:	fee5f1e3          	bgeu	a1,a4,230 <atoi+0x1e>
  return n;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  n = 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <atoi+0x40>

000000000000025c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 262:	02b57663          	bgeu	a0,a1,28e <memmove+0x32>
    while(n-- > 0)
 266:	02c05163          	blez	a2,288 <memmove+0x2c>
 26a:	fff6079b          	addiw	a5,a2,-1
 26e:	1782                	slli	a5,a5,0x20
 270:	9381                	srli	a5,a5,0x20
 272:	0785                	addi	a5,a5,1
 274:	97aa                	add	a5,a5,a0
  dst = vdst;
 276:	872a                	mv	a4,a0
      *dst++ = *src++;
 278:	0585                	addi	a1,a1,1
 27a:	0705                	addi	a4,a4,1
 27c:	fff5c683          	lbu	a3,-1(a1)
 280:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 284:	fee79ae3          	bne	a5,a4,278 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
    dst += n;
 28e:	00c50733          	add	a4,a0,a2
    src += n;
 292:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 294:	fec05ae3          	blez	a2,288 <memmove+0x2c>
 298:	fff6079b          	addiw	a5,a2,-1
 29c:	1782                	slli	a5,a5,0x20
 29e:	9381                	srli	a5,a5,0x20
 2a0:	fff7c793          	not	a5,a5
 2a4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a6:	15fd                	addi	a1,a1,-1
 2a8:	177d                	addi	a4,a4,-1
 2aa:	0005c683          	lbu	a3,0(a1)
 2ae:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b2:	fef71ae3          	bne	a4,a5,2a6 <memmove+0x4a>
 2b6:	bfc9                	j	288 <memmove+0x2c>

00000000000002b8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2be:	ce15                	beqz	a2,2fa <memcmp+0x42>
 2c0:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	02e79063          	bne	a5,a4,2ec <memcmp+0x34>
 2d0:	1682                	slli	a3,a3,0x20
 2d2:	9281                	srli	a3,a3,0x20
 2d4:	0685                	addi	a3,a3,1
 2d6:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 2d8:	0505                	addi	a0,a0,1
    p2++;
 2da:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2dc:	00d50d63          	beq	a0,a3,2f6 <memcmp+0x3e>
    if (*p1 != *p2) {
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	0005c703          	lbu	a4,0(a1)
 2e8:	fee788e3          	beq	a5,a4,2d8 <memcmp+0x20>
      return *p1 - *p2;
 2ec:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <memcmp+0x38>
 2fa:	4501                	li	a0,0
 2fc:	bfd5                	j	2f0 <memcmp+0x38>

00000000000002fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 306:	00000097          	auipc	ra,0x0
 30a:	f56080e7          	jalr	-170(ra) # 25c <memmove>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 316:	4885                	li	a7,1
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exit>:
.global exit
exit:
 li a7, SYS_exit
 31e:	4889                	li	a7,2
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <wait>:
.global wait
wait:
 li a7, SYS_wait
 326:	488d                	li	a7,3
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32e:	4891                	li	a7,4
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <read>:
.global read
read:
 li a7, SYS_read
 336:	4895                	li	a7,5
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <write>:
.global write
write:
 li a7, SYS_write
 33e:	48c1                	li	a7,16
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <close>:
.global close
close:
 li a7, SYS_close
 346:	48d5                	li	a7,21
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <kill>:
.global kill
kill:
 li a7, SYS_kill
 34e:	4899                	li	a7,6
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exec>:
.global exec
exec:
 li a7, SYS_exec
 356:	489d                	li	a7,7
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <open>:
.global open
open:
 li a7, SYS_open
 35e:	48bd                	li	a7,15
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 366:	48c5                	li	a7,17
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36e:	48c9                	li	a7,18
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 376:	48a1                	li	a7,8
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <link>:
.global link
link:
 li a7, SYS_link
 37e:	48cd                	li	a7,19
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 386:	48d1                	li	a7,20
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38e:	48a5                	li	a7,9
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <dup>:
.global dup
dup:
 li a7, SYS_dup
 396:	48a9                	li	a7,10
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39e:	48ad                	li	a7,11
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a6:	48b1                	li	a7,12
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ae:	48b5                	li	a7,13
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b6:	48b9                	li	a7,14
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3be:	48d9                	li	a7,22
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c6:	48dd                	li	a7,23
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3ce:	48e1                	li	a7,24
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d6:	1101                	addi	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	1000                	addi	s0,sp,32
 3de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e2:	4605                	li	a2,1
 3e4:	fef40593          	addi	a1,s0,-17
 3e8:	00000097          	auipc	ra,0x0
 3ec:	f56080e7          	jalr	-170(ra) # 33e <write>
}
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	6105                	addi	sp,sp,32
 3f6:	8082                	ret

00000000000003f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f8:	7139                	addi	sp,sp,-64
 3fa:	fc06                	sd	ra,56(sp)
 3fc:	f822                	sd	s0,48(sp)
 3fe:	f426                	sd	s1,40(sp)
 400:	f04a                	sd	s2,32(sp)
 402:	ec4e                	sd	s3,24(sp)
 404:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 406:	c299                	beqz	a3,40c <printint+0x14>
 408:	0005cd63          	bltz	a1,422 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 40c:	2581                	sext.w	a1,a1
  neg = 0;
 40e:	4301                	li	t1,0
 410:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 414:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 416:	2601                	sext.w	a2,a2
 418:	00000897          	auipc	a7,0x0
 41c:	47088893          	addi	a7,a7,1136 # 888 <digits>
 420:	a801                	j	430 <printint+0x38>
    x = -xx;
 422:	40b005bb          	negw	a1,a1
 426:	2581                	sext.w	a1,a1
    neg = 1;
 428:	4305                	li	t1,1
    x = -xx;
 42a:	b7dd                	j	410 <printint+0x18>
  }while((x /= base) != 0);
 42c:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 42e:	8836                	mv	a6,a3
 430:	0018069b          	addiw	a3,a6,1
 434:	02c5f7bb          	remuw	a5,a1,a2
 438:	1782                	slli	a5,a5,0x20
 43a:	9381                	srli	a5,a5,0x20
 43c:	97c6                	add	a5,a5,a7
 43e:	0007c783          	lbu	a5,0(a5)
 442:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 446:	0705                	addi	a4,a4,1
 448:	02c5d7bb          	divuw	a5,a1,a2
 44c:	fec5f0e3          	bgeu	a1,a2,42c <printint+0x34>
  if(neg)
 450:	00030b63          	beqz	t1,466 <printint+0x6e>
    buf[i++] = '-';
 454:	fd040793          	addi	a5,s0,-48
 458:	96be                	add	a3,a3,a5
 45a:	02d00793          	li	a5,45
 45e:	fef68823          	sb	a5,-16(a3)
 462:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 466:	02d05963          	blez	a3,498 <printint+0xa0>
 46a:	89aa                	mv	s3,a0
 46c:	fc040793          	addi	a5,s0,-64
 470:	00d784b3          	add	s1,a5,a3
 474:	fff78913          	addi	s2,a5,-1
 478:	9936                	add	s2,s2,a3
 47a:	36fd                	addiw	a3,a3,-1
 47c:	1682                	slli	a3,a3,0x20
 47e:	9281                	srli	a3,a3,0x20
 480:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 484:	fff4c583          	lbu	a1,-1(s1)
 488:	854e                	mv	a0,s3
 48a:	00000097          	auipc	ra,0x0
 48e:	f4c080e7          	jalr	-180(ra) # 3d6 <putc>
  while(--i >= 0)
 492:	14fd                	addi	s1,s1,-1
 494:	ff2498e3          	bne	s1,s2,484 <printint+0x8c>
}
 498:	70e2                	ld	ra,56(sp)
 49a:	7442                	ld	s0,48(sp)
 49c:	74a2                	ld	s1,40(sp)
 49e:	7902                	ld	s2,32(sp)
 4a0:	69e2                	ld	s3,24(sp)
 4a2:	6121                	addi	sp,sp,64
 4a4:	8082                	ret

00000000000004a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a6:	7119                	addi	sp,sp,-128
 4a8:	fc86                	sd	ra,120(sp)
 4aa:	f8a2                	sd	s0,112(sp)
 4ac:	f4a6                	sd	s1,104(sp)
 4ae:	f0ca                	sd	s2,96(sp)
 4b0:	ecce                	sd	s3,88(sp)
 4b2:	e8d2                	sd	s4,80(sp)
 4b4:	e4d6                	sd	s5,72(sp)
 4b6:	e0da                	sd	s6,64(sp)
 4b8:	fc5e                	sd	s7,56(sp)
 4ba:	f862                	sd	s8,48(sp)
 4bc:	f466                	sd	s9,40(sp)
 4be:	f06a                	sd	s10,32(sp)
 4c0:	ec6e                	sd	s11,24(sp)
 4c2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c4:	0005c483          	lbu	s1,0(a1)
 4c8:	18048d63          	beqz	s1,662 <vprintf+0x1bc>
 4cc:	8aaa                	mv	s5,a0
 4ce:	8b32                	mv	s6,a2
 4d0:	00158913          	addi	s2,a1,1
  state = 0;
 4d4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d6:	02500a13          	li	s4,37
      if(c == 'd'){
 4da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4de:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4e2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4e6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ea:	00000b97          	auipc	s7,0x0
 4ee:	39eb8b93          	addi	s7,s7,926 # 888 <digits>
 4f2:	a839                	j	510 <vprintf+0x6a>
        putc(fd, c);
 4f4:	85a6                	mv	a1,s1
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	ede080e7          	jalr	-290(ra) # 3d6 <putc>
 500:	a019                	j	506 <vprintf+0x60>
    } else if(state == '%'){
 502:	01498f63          	beq	s3,s4,520 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 506:	0905                	addi	s2,s2,1
 508:	fff94483          	lbu	s1,-1(s2)
 50c:	14048b63          	beqz	s1,662 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 510:	0004879b          	sext.w	a5,s1
    if(state == 0){
 514:	fe0997e3          	bnez	s3,502 <vprintf+0x5c>
      if(c == '%'){
 518:	fd479ee3          	bne	a5,s4,4f4 <vprintf+0x4e>
        state = '%';
 51c:	89be                	mv	s3,a5
 51e:	b7e5                	j	506 <vprintf+0x60>
      if(c == 'd'){
 520:	05878063          	beq	a5,s8,560 <vprintf+0xba>
      } else if(c == 'l') {
 524:	05978c63          	beq	a5,s9,57c <vprintf+0xd6>
      } else if(c == 'x') {
 528:	07a78863          	beq	a5,s10,598 <vprintf+0xf2>
      } else if(c == 'p') {
 52c:	09b78463          	beq	a5,s11,5b4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 530:	07300713          	li	a4,115
 534:	0ce78563          	beq	a5,a4,5fe <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 538:	06300713          	li	a4,99
 53c:	0ee78c63          	beq	a5,a4,634 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 540:	11478663          	beq	a5,s4,64c <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 544:	85d2                	mv	a1,s4
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e8e080e7          	jalr	-370(ra) # 3d6 <putc>
        putc(fd, c);
 550:	85a6                	mv	a1,s1
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e82080e7          	jalr	-382(ra) # 3d6 <putc>
      }
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b765                	j	506 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 560:	008b0493          	addi	s1,s6,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000b2583          	lw	a1,0(s6)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e8a080e7          	jalr	-374(ra) # 3f8 <printint>
 576:	8b26                	mv	s6,s1
      state = 0;
 578:	4981                	li	s3,0
 57a:	b771                	j	506 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	008b0493          	addi	s1,s6,8
 580:	4681                	li	a3,0
 582:	4629                	li	a2,10
 584:	000b2583          	lw	a1,0(s6)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e6e080e7          	jalr	-402(ra) # 3f8 <printint>
 592:	8b26                	mv	s6,s1
      state = 0;
 594:	4981                	li	s3,0
 596:	bf85                	j	506 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 598:	008b0493          	addi	s1,s6,8
 59c:	4681                	li	a3,0
 59e:	4641                	li	a2,16
 5a0:	000b2583          	lw	a1,0(s6)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e52080e7          	jalr	-430(ra) # 3f8 <printint>
 5ae:	8b26                	mv	s6,s1
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bf91                	j	506 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5b4:	008b0793          	addi	a5,s6,8
 5b8:	f8f43423          	sd	a5,-120(s0)
 5bc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5c0:	03000593          	li	a1,48
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e10080e7          	jalr	-496(ra) # 3d6 <putc>
  putc(fd, 'x');
 5ce:	85ea                	mv	a1,s10
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e04080e7          	jalr	-508(ra) # 3d6 <putc>
 5da:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5dc:	03c9d793          	srli	a5,s3,0x3c
 5e0:	97de                	add	a5,a5,s7
 5e2:	0007c583          	lbu	a1,0(a5)
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	dee080e7          	jalr	-530(ra) # 3d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f0:	0992                	slli	s3,s3,0x4
 5f2:	34fd                	addiw	s1,s1,-1
 5f4:	f4e5                	bnez	s1,5dc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5f6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b729                	j	506 <vprintf+0x60>
        s = va_arg(ap, char*);
 5fe:	008b0993          	addi	s3,s6,8
 602:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 606:	c085                	beqz	s1,626 <vprintf+0x180>
        while(*s != 0){
 608:	0004c583          	lbu	a1,0(s1)
 60c:	c9a1                	beqz	a1,65c <vprintf+0x1b6>
          putc(fd, *s);
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	dc6080e7          	jalr	-570(ra) # 3d6 <putc>
          s++;
 618:	0485                	addi	s1,s1,1
        while(*s != 0){
 61a:	0004c583          	lbu	a1,0(s1)
 61e:	f9e5                	bnez	a1,60e <vprintf+0x168>
        s = va_arg(ap, char*);
 620:	8b4e                	mv	s6,s3
      state = 0;
 622:	4981                	li	s3,0
 624:	b5cd                	j	506 <vprintf+0x60>
          s = "(null)";
 626:	00000497          	auipc	s1,0x0
 62a:	27a48493          	addi	s1,s1,634 # 8a0 <digits+0x18>
        while(*s != 0){
 62e:	02800593          	li	a1,40
 632:	bff1                	j	60e <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 634:	008b0493          	addi	s1,s6,8
 638:	000b4583          	lbu	a1,0(s6)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	d98080e7          	jalr	-616(ra) # 3d6 <putc>
 646:	8b26                	mv	s6,s1
      state = 0;
 648:	4981                	li	s3,0
 64a:	bd75                	j	506 <vprintf+0x60>
        putc(fd, c);
 64c:	85d2                	mv	a1,s4
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	d86080e7          	jalr	-634(ra) # 3d6 <putc>
      state = 0;
 658:	4981                	li	s3,0
 65a:	b575                	j	506 <vprintf+0x60>
        s = va_arg(ap, char*);
 65c:	8b4e                	mv	s6,s3
      state = 0;
 65e:	4981                	li	s3,0
 660:	b55d                	j	506 <vprintf+0x60>
    }
  }
}
 662:	70e6                	ld	ra,120(sp)
 664:	7446                	ld	s0,112(sp)
 666:	74a6                	ld	s1,104(sp)
 668:	7906                	ld	s2,96(sp)
 66a:	69e6                	ld	s3,88(sp)
 66c:	6a46                	ld	s4,80(sp)
 66e:	6aa6                	ld	s5,72(sp)
 670:	6b06                	ld	s6,64(sp)
 672:	7be2                	ld	s7,56(sp)
 674:	7c42                	ld	s8,48(sp)
 676:	7ca2                	ld	s9,40(sp)
 678:	7d02                	ld	s10,32(sp)
 67a:	6de2                	ld	s11,24(sp)
 67c:	6109                	addi	sp,sp,128
 67e:	8082                	ret

0000000000000680 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 680:	715d                	addi	sp,sp,-80
 682:	ec06                	sd	ra,24(sp)
 684:	e822                	sd	s0,16(sp)
 686:	1000                	addi	s0,sp,32
 688:	e010                	sd	a2,0(s0)
 68a:	e414                	sd	a3,8(s0)
 68c:	e818                	sd	a4,16(s0)
 68e:	ec1c                	sd	a5,24(s0)
 690:	03043023          	sd	a6,32(s0)
 694:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 698:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 69c:	8622                	mv	a2,s0
 69e:	00000097          	auipc	ra,0x0
 6a2:	e08080e7          	jalr	-504(ra) # 4a6 <vprintf>
}
 6a6:	60e2                	ld	ra,24(sp)
 6a8:	6442                	ld	s0,16(sp)
 6aa:	6161                	addi	sp,sp,80
 6ac:	8082                	ret

00000000000006ae <printf>:

void
printf(const char *fmt, ...)
{
 6ae:	711d                	addi	sp,sp,-96
 6b0:	ec06                	sd	ra,24(sp)
 6b2:	e822                	sd	s0,16(sp)
 6b4:	1000                	addi	s0,sp,32
 6b6:	e40c                	sd	a1,8(s0)
 6b8:	e810                	sd	a2,16(s0)
 6ba:	ec14                	sd	a3,24(s0)
 6bc:	f018                	sd	a4,32(s0)
 6be:	f41c                	sd	a5,40(s0)
 6c0:	03043823          	sd	a6,48(s0)
 6c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	00840613          	addi	a2,s0,8
 6cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d0:	85aa                	mv	a1,a0
 6d2:	4505                	li	a0,1
 6d4:	00000097          	auipc	ra,0x0
 6d8:	dd2080e7          	jalr	-558(ra) # 4a6 <vprintf>
}
 6dc:	60e2                	ld	ra,24(sp)
 6de:	6442                	ld	s0,16(sp)
 6e0:	6125                	addi	sp,sp,96
 6e2:	8082                	ret

00000000000006e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e4:	1141                	addi	sp,sp,-16
 6e6:	e422                	sd	s0,8(sp)
 6e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ee:	00000797          	auipc	a5,0x0
 6f2:	1ba78793          	addi	a5,a5,442 # 8a8 <freep>
 6f6:	639c                	ld	a5,0(a5)
 6f8:	a805                	j	728 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fa:	4618                	lw	a4,8(a2)
 6fc:	9db9                	addw	a1,a1,a4
 6fe:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 702:	6398                	ld	a4,0(a5)
 704:	6318                	ld	a4,0(a4)
 706:	fee53823          	sd	a4,-16(a0)
 70a:	a091                	j	74e <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 70c:	ff852703          	lw	a4,-8(a0)
 710:	9e39                	addw	a2,a2,a4
 712:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 714:	ff053703          	ld	a4,-16(a0)
 718:	e398                	sd	a4,0(a5)
 71a:	a099                	j	760 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71c:	6398                	ld	a4,0(a5)
 71e:	00e7e463          	bltu	a5,a4,726 <free+0x42>
 722:	00e6ea63          	bltu	a3,a4,736 <free+0x52>
{
 726:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	fed7fae3          	bgeu	a5,a3,71c <free+0x38>
 72c:	6398                	ld	a4,0(a5)
 72e:	00e6e463          	bltu	a3,a4,736 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	fee7eae3          	bltu	a5,a4,726 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 736:	ff852583          	lw	a1,-8(a0)
 73a:	6390                	ld	a2,0(a5)
 73c:	02059713          	slli	a4,a1,0x20
 740:	9301                	srli	a4,a4,0x20
 742:	0712                	slli	a4,a4,0x4
 744:	9736                	add	a4,a4,a3
 746:	fae60ae3          	beq	a2,a4,6fa <free+0x16>
    bp->s.ptr = p->s.ptr;
 74a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74e:	4790                	lw	a2,8(a5)
 750:	02061713          	slli	a4,a2,0x20
 754:	9301                	srli	a4,a4,0x20
 756:	0712                	slli	a4,a4,0x4
 758:	973e                	add	a4,a4,a5
 75a:	fae689e3          	beq	a3,a4,70c <free+0x28>
  } else
    p->s.ptr = bp;
 75e:	e394                	sd	a3,0(a5)
  freep = p;
 760:	00000717          	auipc	a4,0x0
 764:	14f73423          	sd	a5,328(a4) # 8a8 <freep>
}
 768:	6422                	ld	s0,8(sp)
 76a:	0141                	addi	sp,sp,16
 76c:	8082                	ret

000000000000076e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76e:	7139                	addi	sp,sp,-64
 770:	fc06                	sd	ra,56(sp)
 772:	f822                	sd	s0,48(sp)
 774:	f426                	sd	s1,40(sp)
 776:	f04a                	sd	s2,32(sp)
 778:	ec4e                	sd	s3,24(sp)
 77a:	e852                	sd	s4,16(sp)
 77c:	e456                	sd	s5,8(sp)
 77e:	e05a                	sd	s6,0(sp)
 780:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	02051993          	slli	s3,a0,0x20
 786:	0209d993          	srli	s3,s3,0x20
 78a:	09bd                	addi	s3,s3,15
 78c:	0049d993          	srli	s3,s3,0x4
 790:	2985                	addiw	s3,s3,1
 792:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 796:	00000797          	auipc	a5,0x0
 79a:	11278793          	addi	a5,a5,274 # 8a8 <freep>
 79e:	6388                	ld	a0,0(a5)
 7a0:	c515                	beqz	a0,7cc <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a4:	4798                	lw	a4,8(a5)
 7a6:	03277f63          	bgeu	a4,s2,7e4 <malloc+0x76>
 7aa:	8a4e                	mv	s4,s3
 7ac:	0009871b          	sext.w	a4,s3
 7b0:	6685                	lui	a3,0x1
 7b2:	00d77363          	bgeu	a4,a3,7b8 <malloc+0x4a>
 7b6:	6a05                	lui	s4,0x1
 7b8:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 7bc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c0:	00000497          	auipc	s1,0x0
 7c4:	0e848493          	addi	s1,s1,232 # 8a8 <freep>
  if(p == (char*)-1)
 7c8:	5b7d                	li	s6,-1
 7ca:	a885                	j	83a <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 7cc:	00000797          	auipc	a5,0x0
 7d0:	0e478793          	addi	a5,a5,228 # 8b0 <base>
 7d4:	00000717          	auipc	a4,0x0
 7d8:	0cf73a23          	sd	a5,212(a4) # 8a8 <freep>
 7dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e2:	b7e1                	j	7aa <malloc+0x3c>
      if(p->s.size == nunits)
 7e4:	02e90b63          	beq	s2,a4,81a <malloc+0xac>
        p->s.size -= nunits;
 7e8:	4137073b          	subw	a4,a4,s3
 7ec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ee:	1702                	slli	a4,a4,0x20
 7f0:	9301                	srli	a4,a4,0x20
 7f2:	0712                	slli	a4,a4,0x4
 7f4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7f6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7fa:	00000717          	auipc	a4,0x0
 7fe:	0aa73723          	sd	a0,174(a4) # 8a8 <freep>
      return (void*)(p + 1);
 802:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 806:	70e2                	ld	ra,56(sp)
 808:	7442                	ld	s0,48(sp)
 80a:	74a2                	ld	s1,40(sp)
 80c:	7902                	ld	s2,32(sp)
 80e:	69e2                	ld	s3,24(sp)
 810:	6a42                	ld	s4,16(sp)
 812:	6aa2                	ld	s5,8(sp)
 814:	6b02                	ld	s6,0(sp)
 816:	6121                	addi	sp,sp,64
 818:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 81a:	6398                	ld	a4,0(a5)
 81c:	e118                	sd	a4,0(a0)
 81e:	bff1                	j	7fa <malloc+0x8c>
  hp->s.size = nu;
 820:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 824:	0541                	addi	a0,a0,16
 826:	00000097          	auipc	ra,0x0
 82a:	ebe080e7          	jalr	-322(ra) # 6e4 <free>
  return freep;
 82e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 830:	d979                	beqz	a0,806 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	fb2777e3          	bgeu	a4,s2,7e4 <malloc+0x76>
    if(p == freep)
 83a:	6098                	ld	a4,0(s1)
 83c:	853e                	mv	a0,a5
 83e:	fef71ae3          	bne	a4,a5,832 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 842:	8552                	mv	a0,s4
 844:	00000097          	auipc	ra,0x0
 848:	b62080e7          	jalr	-1182(ra) # 3a6 <sbrk>
  if(p == (char*)-1)
 84c:	fd651ae3          	bne	a0,s6,820 <malloc+0xb2>
        return 0;
 850:	4501                	li	a0,0
 852:	bf55                	j	806 <malloc+0x98>
