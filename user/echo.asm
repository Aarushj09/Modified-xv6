
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	826a0a13          	addi	s4,s4,-2010 # 850 <malloc+0xec>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	09c080e7          	jalr	156(ra) # d4 <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2ec080e7          	jalr	748(ra) # 334 <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2d8080e7          	jalr	728(ra) # 334 <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00000597          	auipc	a1,0x0
  6c:	7f058593          	addi	a1,a1,2032 # 858 <malloc+0xf4>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2c2080e7          	jalr	706(ra) # 334 <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	298080e7          	jalr	664(ra) # 314 <exit>

0000000000000084 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
    ;
  return os;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cf91                	beqz	a5,c6 <strcmp+0x26>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71b63          	bne	a4,a5,c6 <strcmp+0x26>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	c789                	beqz	a5,c6 <strcmp+0x26>
  be:	0005c703          	lbu	a4,0(a1)
  c2:	fef709e3          	beq	a4,a5,b4 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf91                	beqz	a5,fa <strlen+0x26>
  e0:	0505                	addi	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	4685                	li	a3,1
  e6:	9e89                	subw	a3,a3,a0
  e8:	00f6853b          	addw	a0,a3,a5
  ec:	0785                	addi	a5,a5,1
  ee:	fff7c703          	lbu	a4,-1(a5)
  f2:	fb7d                	bnez	a4,e8 <strlen+0x14>
    ;
  return n;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  for(n = 0; s[n]; n++)
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strlen+0x20>

00000000000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 104:	ce09                	beqz	a2,11e <memset+0x20>
 106:	87aa                	mv	a5,a0
 108:	fff6071b          	addiw	a4,a2,-1
 10c:	1702                	slli	a4,a4,0x20
 10e:	9301                	srli	a4,a4,0x20
 110:	0705                	addi	a4,a4,1
 112:	972a                	add	a4,a4,a0
    cdst[i] = c;
 114:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 118:	0785                	addi	a5,a5,1
 11a:	fee79de3          	bne	a5,a4,114 <memset+0x16>
  }
  return dst;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strchr>:

char*
strchr(const char *s, char c)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cf91                	beqz	a5,14a <strchr+0x26>
    if(*s == c)
 130:	00f58a63          	beq	a1,a5,144 <strchr+0x20>
  for(; *s; s++)
 134:	0505                	addi	a0,a0,1
 136:	00054783          	lbu	a5,0(a0)
 13a:	c781                	beqz	a5,142 <strchr+0x1e>
    if(*s == c)
 13c:	feb79ce3          	bne	a5,a1,134 <strchr+0x10>
 140:	a011                	j	144 <strchr+0x20>
      return (char*)s;
  return 0;
 142:	4501                	li	a0,0
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfe5                	j	144 <strchr+0x20>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	711d                	addi	sp,sp,-96
 150:	ec86                	sd	ra,88(sp)
 152:	e8a2                	sd	s0,80(sp)
 154:	e4a6                	sd	s1,72(sp)
 156:	e0ca                	sd	s2,64(sp)
 158:	fc4e                	sd	s3,56(sp)
 15a:	f852                	sd	s4,48(sp)
 15c:	f456                	sd	s5,40(sp)
 15e:	f05a                	sd	s6,32(sp)
 160:	ec5e                	sd	s7,24(sp)
 162:	1080                	addi	s0,sp,96
 164:	8baa                	mv	s7,a0
 166:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	892a                	mv	s2,a0
 16a:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16c:	4aa9                	li	s5,10
 16e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 170:	0019849b          	addiw	s1,s3,1
 174:	0344d863          	bge	s1,s4,1a4 <gets+0x56>
    cc = read(0, &c, 1);
 178:	4605                	li	a2,1
 17a:	faf40593          	addi	a1,s0,-81
 17e:	4501                	li	a0,0
 180:	00000097          	auipc	ra,0x0
 184:	1ac080e7          	jalr	428(ra) # 32c <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x56>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x54>
 198:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 19a:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 19c:	fd679ae3          	bne	a5,s6,170 <gets+0x22>
 1a0:	a011                	j	1a4 <gets+0x56>
  for(i=0; i+1 < max; ){
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	addi	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	1101                	addi	sp,sp,-32
 1c4:	ec06                	sd	ra,24(sp)
 1c6:	e822                	sd	s0,16(sp)
 1c8:	e426                	sd	s1,8(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	00000097          	auipc	ra,0x0
 1d6:	182080e7          	jalr	386(ra) # 354 <open>
  if(fd < 0)
 1da:	02054563          	bltz	a0,204 <stat+0x42>
 1de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e0:	85ca                	mv	a1,s2
 1e2:	00000097          	auipc	ra,0x0
 1e6:	18a080e7          	jalr	394(ra) # 36c <fstat>
 1ea:	892a                	mv	s2,a0
  close(fd);
 1ec:	8526                	mv	a0,s1
 1ee:	00000097          	auipc	ra,0x0
 1f2:	14e080e7          	jalr	334(ra) # 33c <close>
  return r;
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	64a2                	ld	s1,8(sp)
 1fe:	6902                	ld	s2,0(sp)
 200:	6105                	addi	sp,sp,32
 202:	8082                	ret
    return -1;
 204:	597d                	li	s2,-1
 206:	bfc5                	j	1f6 <stat+0x34>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20e:	00054683          	lbu	a3,0(a0)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	andi	a5,a5,255
 21a:	4725                	li	a4,9
 21c:	02f76963          	bltu	a4,a5,24e <atoi+0x46>
 220:	862a                	mv	a2,a0
  n = 0;
 222:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 224:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 226:	0605                	addi	a2,a2,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00064683          	lbu	a3,0(a2)
 23c:	fd06871b          	addiw	a4,a3,-48
 240:	0ff77713          	andi	a4,a4,255
 244:	fee5f1e3          	bgeu	a1,a4,226 <atoi+0x1e>
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <atoi+0x40>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 258:	02b57663          	bgeu	a0,a1,284 <memmove+0x32>
    while(n-- > 0)
 25c:	02c05163          	blez	a2,27e <memmove+0x2c>
 260:	fff6079b          	addiw	a5,a2,-1
 264:	1782                	slli	a5,a5,0x20
 266:	9381                	srli	a5,a5,0x20
 268:	0785                	addi	a5,a5,1
 26a:	97aa                	add	a5,a5,a0
  dst = vdst;
 26c:	872a                	mv	a4,a0
      *dst++ = *src++;
 26e:	0585                	addi	a1,a1,1
 270:	0705                	addi	a4,a4,1
 272:	fff5c683          	lbu	a3,-1(a1)
 276:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
    dst += n;
 284:	00c50733          	add	a4,a0,a2
    src += n;
 288:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 28a:	fec05ae3          	blez	a2,27e <memmove+0x2c>
 28e:	fff6079b          	addiw	a5,a2,-1
 292:	1782                	slli	a5,a5,0x20
 294:	9381                	srli	a5,a5,0x20
 296:	fff7c793          	not	a5,a5
 29a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29c:	15fd                	addi	a1,a1,-1
 29e:	177d                	addi	a4,a4,-1
 2a0:	0005c683          	lbu	a3,0(a1)
 2a4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a8:	fef71ae3          	bne	a4,a5,29c <memmove+0x4a>
 2ac:	bfc9                	j	27e <memmove+0x2c>

00000000000002ae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b4:	ce15                	beqz	a2,2f0 <memcmp+0x42>
 2b6:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	02e79063          	bne	a5,a4,2e2 <memcmp+0x34>
 2c6:	1682                	slli	a3,a3,0x20
 2c8:	9281                	srli	a3,a3,0x20
 2ca:	0685                	addi	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 2ce:	0505                	addi	a0,a0,1
    p2++;
 2d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d2:	00d50d63          	beq	a0,a3,2ec <memcmp+0x3e>
    if (*p1 != *p2) {
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	0005c703          	lbu	a4,0(a1)
 2de:	fee788e3          	beq	a5,a4,2ce <memcmp+0x20>
      return *p1 - *p2;
 2e2:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  return 0;
 2ec:	4501                	li	a0,0
 2ee:	bfe5                	j	2e6 <memcmp+0x38>
 2f0:	4501                	li	a0,0
 2f2:	bfd5                	j	2e6 <memcmp+0x38>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fc:	00000097          	auipc	ra,0x0
 300:	f56080e7          	jalr	-170(ra) # 252 <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3b4:	48d9                	li	a7,22
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <trace>:
.global trace
trace:
 li a7, SYS_trace
 3bc:	48dd                	li	a7,23
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3c4:	48e1                	li	a7,24
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	addi	a1,s0,-17
 3de:	00000097          	auipc	ra,0x0
 3e2:	f56080e7          	jalr	-170(ra) # 334 <write>
}
 3e6:	60e2                	ld	ra,24(sp)
 3e8:	6442                	ld	s0,16(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret

00000000000003ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ee:	7139                	addi	sp,sp,-64
 3f0:	fc06                	sd	ra,56(sp)
 3f2:	f822                	sd	s0,48(sp)
 3f4:	f426                	sd	s1,40(sp)
 3f6:	f04a                	sd	s2,32(sp)
 3f8:	ec4e                	sd	s3,24(sp)
 3fa:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fc:	c299                	beqz	a3,402 <printint+0x14>
 3fe:	0005cd63          	bltz	a1,418 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 402:	2581                	sext.w	a1,a1
  neg = 0;
 404:	4301                	li	t1,0
 406:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 40a:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 40c:	2601                	sext.w	a2,a2
 40e:	00000897          	auipc	a7,0x0
 412:	45288893          	addi	a7,a7,1106 # 860 <digits>
 416:	a801                	j	426 <printint+0x38>
    x = -xx;
 418:	40b005bb          	negw	a1,a1
 41c:	2581                	sext.w	a1,a1
    neg = 1;
 41e:	4305                	li	t1,1
    x = -xx;
 420:	b7dd                	j	406 <printint+0x18>
  }while((x /= base) != 0);
 422:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 424:	8836                	mv	a6,a3
 426:	0018069b          	addiw	a3,a6,1
 42a:	02c5f7bb          	remuw	a5,a1,a2
 42e:	1782                	slli	a5,a5,0x20
 430:	9381                	srli	a5,a5,0x20
 432:	97c6                	add	a5,a5,a7
 434:	0007c783          	lbu	a5,0(a5)
 438:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 43c:	0705                	addi	a4,a4,1
 43e:	02c5d7bb          	divuw	a5,a1,a2
 442:	fec5f0e3          	bgeu	a1,a2,422 <printint+0x34>
  if(neg)
 446:	00030b63          	beqz	t1,45c <printint+0x6e>
    buf[i++] = '-';
 44a:	fd040793          	addi	a5,s0,-48
 44e:	96be                	add	a3,a3,a5
 450:	02d00793          	li	a5,45
 454:	fef68823          	sb	a5,-16(a3)
 458:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 45c:	02d05963          	blez	a3,48e <printint+0xa0>
 460:	89aa                	mv	s3,a0
 462:	fc040793          	addi	a5,s0,-64
 466:	00d784b3          	add	s1,a5,a3
 46a:	fff78913          	addi	s2,a5,-1
 46e:	9936                	add	s2,s2,a3
 470:	36fd                	addiw	a3,a3,-1
 472:	1682                	slli	a3,a3,0x20
 474:	9281                	srli	a3,a3,0x20
 476:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 47a:	fff4c583          	lbu	a1,-1(s1)
 47e:	854e                	mv	a0,s3
 480:	00000097          	auipc	ra,0x0
 484:	f4c080e7          	jalr	-180(ra) # 3cc <putc>
  while(--i >= 0)
 488:	14fd                	addi	s1,s1,-1
 48a:	ff2498e3          	bne	s1,s2,47a <printint+0x8c>
}
 48e:	70e2                	ld	ra,56(sp)
 490:	7442                	ld	s0,48(sp)
 492:	74a2                	ld	s1,40(sp)
 494:	7902                	ld	s2,32(sp)
 496:	69e2                	ld	s3,24(sp)
 498:	6121                	addi	sp,sp,64
 49a:	8082                	ret

000000000000049c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49c:	7119                	addi	sp,sp,-128
 49e:	fc86                	sd	ra,120(sp)
 4a0:	f8a2                	sd	s0,112(sp)
 4a2:	f4a6                	sd	s1,104(sp)
 4a4:	f0ca                	sd	s2,96(sp)
 4a6:	ecce                	sd	s3,88(sp)
 4a8:	e8d2                	sd	s4,80(sp)
 4aa:	e4d6                	sd	s5,72(sp)
 4ac:	e0da                	sd	s6,64(sp)
 4ae:	fc5e                	sd	s7,56(sp)
 4b0:	f862                	sd	s8,48(sp)
 4b2:	f466                	sd	s9,40(sp)
 4b4:	f06a                	sd	s10,32(sp)
 4b6:	ec6e                	sd	s11,24(sp)
 4b8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ba:	0005c483          	lbu	s1,0(a1)
 4be:	18048d63          	beqz	s1,658 <vprintf+0x1bc>
 4c2:	8aaa                	mv	s5,a0
 4c4:	8b32                	mv	s6,a2
 4c6:	00158913          	addi	s2,a1,1
  state = 0;
 4ca:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4cc:	02500a13          	li	s4,37
      if(c == 'd'){
 4d0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4d4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4d8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4dc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4e0:	00000b97          	auipc	s7,0x0
 4e4:	380b8b93          	addi	s7,s7,896 # 860 <digits>
 4e8:	a839                	j	506 <vprintf+0x6a>
        putc(fd, c);
 4ea:	85a6                	mv	a1,s1
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	ede080e7          	jalr	-290(ra) # 3cc <putc>
 4f6:	a019                	j	4fc <vprintf+0x60>
    } else if(state == '%'){
 4f8:	01498f63          	beq	s3,s4,516 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4fc:	0905                	addi	s2,s2,1
 4fe:	fff94483          	lbu	s1,-1(s2)
 502:	14048b63          	beqz	s1,658 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 506:	0004879b          	sext.w	a5,s1
    if(state == 0){
 50a:	fe0997e3          	bnez	s3,4f8 <vprintf+0x5c>
      if(c == '%'){
 50e:	fd479ee3          	bne	a5,s4,4ea <vprintf+0x4e>
        state = '%';
 512:	89be                	mv	s3,a5
 514:	b7e5                	j	4fc <vprintf+0x60>
      if(c == 'd'){
 516:	05878063          	beq	a5,s8,556 <vprintf+0xba>
      } else if(c == 'l') {
 51a:	05978c63          	beq	a5,s9,572 <vprintf+0xd6>
      } else if(c == 'x') {
 51e:	07a78863          	beq	a5,s10,58e <vprintf+0xf2>
      } else if(c == 'p') {
 522:	09b78463          	beq	a5,s11,5aa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 526:	07300713          	li	a4,115
 52a:	0ce78563          	beq	a5,a4,5f4 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52e:	06300713          	li	a4,99
 532:	0ee78c63          	beq	a5,a4,62a <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 536:	11478663          	beq	a5,s4,642 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 53a:	85d2                	mv	a1,s4
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e8e080e7          	jalr	-370(ra) # 3cc <putc>
        putc(fd, c);
 546:	85a6                	mv	a1,s1
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e82080e7          	jalr	-382(ra) # 3cc <putc>
      }
      state = 0;
 552:	4981                	li	s3,0
 554:	b765                	j	4fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b0493          	addi	s1,s6,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000b2583          	lw	a1,0(s6)
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e8a080e7          	jalr	-374(ra) # 3ee <printint>
 56c:	8b26                	mv	s6,s1
      state = 0;
 56e:	4981                	li	s3,0
 570:	b771                	j	4fc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 572:	008b0493          	addi	s1,s6,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000b2583          	lw	a1,0(s6)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e6e080e7          	jalr	-402(ra) # 3ee <printint>
 588:	8b26                	mv	s6,s1
      state = 0;
 58a:	4981                	li	s3,0
 58c:	bf85                	j	4fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 58e:	008b0493          	addi	s1,s6,8
 592:	4681                	li	a3,0
 594:	4641                	li	a2,16
 596:	000b2583          	lw	a1,0(s6)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e52080e7          	jalr	-430(ra) # 3ee <printint>
 5a4:	8b26                	mv	s6,s1
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bf91                	j	4fc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5aa:	008b0793          	addi	a5,s6,8
 5ae:	f8f43423          	sd	a5,-120(s0)
 5b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5b6:	03000593          	li	a1,48
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e10080e7          	jalr	-496(ra) # 3cc <putc>
  putc(fd, 'x');
 5c4:	85ea                	mv	a1,s10
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e04080e7          	jalr	-508(ra) # 3cc <putc>
 5d0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d2:	03c9d793          	srli	a5,s3,0x3c
 5d6:	97de                	add	a5,a5,s7
 5d8:	0007c583          	lbu	a1,0(a5)
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	dee080e7          	jalr	-530(ra) # 3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e6:	0992                	slli	s3,s3,0x4
 5e8:	34fd                	addiw	s1,s1,-1
 5ea:	f4e5                	bnez	s1,5d2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5ec:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b729                	j	4fc <vprintf+0x60>
        s = va_arg(ap, char*);
 5f4:	008b0993          	addi	s3,s6,8
 5f8:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 5fc:	c085                	beqz	s1,61c <vprintf+0x180>
        while(*s != 0){
 5fe:	0004c583          	lbu	a1,0(s1)
 602:	c9a1                	beqz	a1,652 <vprintf+0x1b6>
          putc(fd, *s);
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	dc6080e7          	jalr	-570(ra) # 3cc <putc>
          s++;
 60e:	0485                	addi	s1,s1,1
        while(*s != 0){
 610:	0004c583          	lbu	a1,0(s1)
 614:	f9e5                	bnez	a1,604 <vprintf+0x168>
        s = va_arg(ap, char*);
 616:	8b4e                	mv	s6,s3
      state = 0;
 618:	4981                	li	s3,0
 61a:	b5cd                	j	4fc <vprintf+0x60>
          s = "(null)";
 61c:	00000497          	auipc	s1,0x0
 620:	25c48493          	addi	s1,s1,604 # 878 <digits+0x18>
        while(*s != 0){
 624:	02800593          	li	a1,40
 628:	bff1                	j	604 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 62a:	008b0493          	addi	s1,s6,8
 62e:	000b4583          	lbu	a1,0(s6)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	d98080e7          	jalr	-616(ra) # 3cc <putc>
 63c:	8b26                	mv	s6,s1
      state = 0;
 63e:	4981                	li	s3,0
 640:	bd75                	j	4fc <vprintf+0x60>
        putc(fd, c);
 642:	85d2                	mv	a1,s4
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	d86080e7          	jalr	-634(ra) # 3cc <putc>
      state = 0;
 64e:	4981                	li	s3,0
 650:	b575                	j	4fc <vprintf+0x60>
        s = va_arg(ap, char*);
 652:	8b4e                	mv	s6,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	b55d                	j	4fc <vprintf+0x60>
    }
  }
}
 658:	70e6                	ld	ra,120(sp)
 65a:	7446                	ld	s0,112(sp)
 65c:	74a6                	ld	s1,104(sp)
 65e:	7906                	ld	s2,96(sp)
 660:	69e6                	ld	s3,88(sp)
 662:	6a46                	ld	s4,80(sp)
 664:	6aa6                	ld	s5,72(sp)
 666:	6b06                	ld	s6,64(sp)
 668:	7be2                	ld	s7,56(sp)
 66a:	7c42                	ld	s8,48(sp)
 66c:	7ca2                	ld	s9,40(sp)
 66e:	7d02                	ld	s10,32(sp)
 670:	6de2                	ld	s11,24(sp)
 672:	6109                	addi	sp,sp,128
 674:	8082                	ret

0000000000000676 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 676:	715d                	addi	sp,sp,-80
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	1000                	addi	s0,sp,32
 67e:	e010                	sd	a2,0(s0)
 680:	e414                	sd	a3,8(s0)
 682:	e818                	sd	a4,16(s0)
 684:	ec1c                	sd	a5,24(s0)
 686:	03043023          	sd	a6,32(s0)
 68a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 692:	8622                	mv	a2,s0
 694:	00000097          	auipc	ra,0x0
 698:	e08080e7          	jalr	-504(ra) # 49c <vprintf>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6161                	addi	sp,sp,80
 6a2:	8082                	ret

00000000000006a4 <printf>:

void
printf(const char *fmt, ...)
{
 6a4:	711d                	addi	sp,sp,-96
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e40c                	sd	a1,8(s0)
 6ae:	e810                	sd	a2,16(s0)
 6b0:	ec14                	sd	a3,24(s0)
 6b2:	f018                	sd	a4,32(s0)
 6b4:	f41c                	sd	a5,40(s0)
 6b6:	03043823          	sd	a6,48(s0)
 6ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6be:	00840613          	addi	a2,s0,8
 6c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c6:	85aa                	mv	a1,a0
 6c8:	4505                	li	a0,1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	dd2080e7          	jalr	-558(ra) # 49c <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6125                	addi	sp,sp,96
 6d8:	8082                	ret

00000000000006da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6da:	1141                	addi	sp,sp,-16
 6dc:	e422                	sd	s0,8(sp)
 6de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	00000797          	auipc	a5,0x0
 6e8:	19c78793          	addi	a5,a5,412 # 880 <freep>
 6ec:	639c                	ld	a5,0(a5)
 6ee:	a805                	j	71e <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f0:	4618                	lw	a4,8(a2)
 6f2:	9db9                	addw	a1,a1,a4
 6f4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	6398                	ld	a4,0(a5)
 6fa:	6318                	ld	a4,0(a4)
 6fc:	fee53823          	sd	a4,-16(a0)
 700:	a091                	j	744 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 702:	ff852703          	lw	a4,-8(a0)
 706:	9e39                	addw	a2,a2,a4
 708:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 70a:	ff053703          	ld	a4,-16(a0)
 70e:	e398                	sd	a4,0(a5)
 710:	a099                	j	756 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	6398                	ld	a4,0(a5)
 714:	00e7e463          	bltu	a5,a4,71c <free+0x42>
 718:	00e6ea63          	bltu	a3,a4,72c <free+0x52>
{
 71c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	fed7fae3          	bgeu	a5,a3,712 <free+0x38>
 722:	6398                	ld	a4,0(a5)
 724:	00e6e463          	bltu	a3,a4,72c <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	fee7eae3          	bltu	a5,a4,71c <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 72c:	ff852583          	lw	a1,-8(a0)
 730:	6390                	ld	a2,0(a5)
 732:	02059713          	slli	a4,a1,0x20
 736:	9301                	srli	a4,a4,0x20
 738:	0712                	slli	a4,a4,0x4
 73a:	9736                	add	a4,a4,a3
 73c:	fae60ae3          	beq	a2,a4,6f0 <free+0x16>
    bp->s.ptr = p->s.ptr;
 740:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 744:	4790                	lw	a2,8(a5)
 746:	02061713          	slli	a4,a2,0x20
 74a:	9301                	srli	a4,a4,0x20
 74c:	0712                	slli	a4,a4,0x4
 74e:	973e                	add	a4,a4,a5
 750:	fae689e3          	beq	a3,a4,702 <free+0x28>
  } else
    p->s.ptr = bp;
 754:	e394                	sd	a3,0(a5)
  freep = p;
 756:	00000717          	auipc	a4,0x0
 75a:	12f73523          	sd	a5,298(a4) # 880 <freep>
}
 75e:	6422                	ld	s0,8(sp)
 760:	0141                	addi	sp,sp,16
 762:	8082                	ret

0000000000000764 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 764:	7139                	addi	sp,sp,-64
 766:	fc06                	sd	ra,56(sp)
 768:	f822                	sd	s0,48(sp)
 76a:	f426                	sd	s1,40(sp)
 76c:	f04a                	sd	s2,32(sp)
 76e:	ec4e                	sd	s3,24(sp)
 770:	e852                	sd	s4,16(sp)
 772:	e456                	sd	s5,8(sp)
 774:	e05a                	sd	s6,0(sp)
 776:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	02051993          	slli	s3,a0,0x20
 77c:	0209d993          	srli	s3,s3,0x20
 780:	09bd                	addi	s3,s3,15
 782:	0049d993          	srli	s3,s3,0x4
 786:	2985                	addiw	s3,s3,1
 788:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 78c:	00000797          	auipc	a5,0x0
 790:	0f478793          	addi	a5,a5,244 # 880 <freep>
 794:	6388                	ld	a0,0(a5)
 796:	c515                	beqz	a0,7c2 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79a:	4798                	lw	a4,8(a5)
 79c:	03277f63          	bgeu	a4,s2,7da <malloc+0x76>
 7a0:	8a4e                	mv	s4,s3
 7a2:	0009871b          	sext.w	a4,s3
 7a6:	6685                	lui	a3,0x1
 7a8:	00d77363          	bgeu	a4,a3,7ae <malloc+0x4a>
 7ac:	6a05                	lui	s4,0x1
 7ae:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 7b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b6:	00000497          	auipc	s1,0x0
 7ba:	0ca48493          	addi	s1,s1,202 # 880 <freep>
  if(p == (char*)-1)
 7be:	5b7d                	li	s6,-1
 7c0:	a885                	j	830 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 7c2:	00000797          	auipc	a5,0x0
 7c6:	0c678793          	addi	a5,a5,198 # 888 <base>
 7ca:	00000717          	auipc	a4,0x0
 7ce:	0af73b23          	sd	a5,182(a4) # 880 <freep>
 7d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d8:	b7e1                	j	7a0 <malloc+0x3c>
      if(p->s.size == nunits)
 7da:	02e90b63          	beq	s2,a4,810 <malloc+0xac>
        p->s.size -= nunits;
 7de:	4137073b          	subw	a4,a4,s3
 7e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7e4:	1702                	slli	a4,a4,0x20
 7e6:	9301                	srli	a4,a4,0x20
 7e8:	0712                	slli	a4,a4,0x4
 7ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f0:	00000717          	auipc	a4,0x0
 7f4:	08a73823          	sd	a0,144(a4) # 880 <freep>
      return (void*)(p + 1);
 7f8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7fc:	70e2                	ld	ra,56(sp)
 7fe:	7442                	ld	s0,48(sp)
 800:	74a2                	ld	s1,40(sp)
 802:	7902                	ld	s2,32(sp)
 804:	69e2                	ld	s3,24(sp)
 806:	6a42                	ld	s4,16(sp)
 808:	6aa2                	ld	s5,8(sp)
 80a:	6b02                	ld	s6,0(sp)
 80c:	6121                	addi	sp,sp,64
 80e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 810:	6398                	ld	a4,0(a5)
 812:	e118                	sd	a4,0(a0)
 814:	bff1                	j	7f0 <malloc+0x8c>
  hp->s.size = nu;
 816:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 81a:	0541                	addi	a0,a0,16
 81c:	00000097          	auipc	ra,0x0
 820:	ebe080e7          	jalr	-322(ra) # 6da <free>
  return freep;
 824:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 826:	d979                	beqz	a0,7fc <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	fb2777e3          	bgeu	a4,s2,7da <malloc+0x76>
    if(p == freep)
 830:	6098                	ld	a4,0(s1)
 832:	853e                	mv	a0,a5
 834:	fef71ae3          	bne	a4,a5,828 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 838:	8552                	mv	a0,s4
 83a:	00000097          	auipc	ra,0x0
 83e:	b62080e7          	jalr	-1182(ra) # 39c <sbrk>
  if(p == (char*)-1)
 842:	fd651ae3          	bne	a0,s6,816 <malloc+0xb2>
        return 0;
 846:	4501                	li	a0,0
 848:	bf55                	j	7fc <malloc+0x98>
