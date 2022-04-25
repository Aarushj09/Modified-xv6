
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d44e>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x22d8>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd61d>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	67050513          	addi	a0,a0,1648 # 16d0 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	e84080e7          	jalr	-380(ra) # f14 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	32e50513          	addi	a0,a0,814 # 13c8 <malloc+0xec>
      a2:	00001097          	auipc	ra,0x1
      a6:	e52080e7          	jalr	-430(ra) # ef4 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	31e50513          	addi	a0,a0,798 # 13c8 <malloc+0xec>
      b2:	00001097          	auipc	ra,0x1
      b6:	e4a080e7          	jalr	-438(ra) # efc <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	31450513          	addi	a0,a0,788 # 13d0 <malloc+0xf4>
      c4:	00001097          	auipc	ra,0x1
      c8:	158080e7          	jalr	344(ra) # 121c <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	dbe080e7          	jalr	-578(ra) # e8c <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	31a50513          	addi	a0,a0,794 # 13f0 <malloc+0x114>
      de:	00001097          	auipc	ra,0x1
      e2:	e1e080e7          	jalr	-482(ra) # efc <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001917          	auipc	s2,0x1
      ea:	31a90913          	addi	s2,s2,794 # 1400 <malloc+0x124>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001917          	auipc	s2,0x1
      f4:	30890913          	addi	s2,s2,776 # 13f8 <malloc+0x11c>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	59fd                	li	s3,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
      fc:	00001a17          	auipc	s4,0x1
     100:	5e4a0a13          	addi	s4,s4,1508 # 16e0 <buf.1266>
     104:	a825                	j	13c <go+0xc4>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	2fe50513          	addi	a0,a0,766 # 1408 <malloc+0x12c>
     112:	00001097          	auipc	ra,0x1
     116:	dba080e7          	jalr	-582(ra) # ecc <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	d9a080e7          	jalr	-614(ra) # eb4 <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ca                	mv	a1,s2
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	d78080e7          	jalr	-648(ra) # eac <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	4789                	li	a5,2
     152:	18f50b63          	beq	a0,a5,2e8 <go+0x270>
    } else if(what == 3){
     156:	478d                	li	a5,3
     158:	1af50763          	beq	a0,a5,306 <go+0x28e>
    } else if(what == 4){
     15c:	4791                	li	a5,4
     15e:	1af50d63          	beq	a0,a5,318 <go+0x2a0>
    } else if(what == 5){
     162:	4795                	li	a5,5
     164:	20f50163          	beq	a0,a5,366 <go+0x2ee>
    } else if(what == 6){
     168:	4799                	li	a5,6
     16a:	20f50f63          	beq	a0,a5,388 <go+0x310>
    } else if(what == 7){
     16e:	479d                	li	a5,7
     170:	22f50d63          	beq	a0,a5,3aa <go+0x332>
    } else if(what == 8){
     174:	47a1                	li	a5,8
     176:	24f50363          	beq	a0,a5,3bc <go+0x344>
    } else if(what == 9){
     17a:	47a5                	li	a5,9
     17c:	24f50963          	beq	a0,a5,3ce <go+0x356>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     180:	47a9                	li	a5,10
     182:	28f50563          	beq	a0,a5,40c <go+0x394>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     186:	47ad                	li	a5,11
     188:	2cf50163          	beq	a0,a5,44a <go+0x3d2>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     18c:	47b1                	li	a5,12
     18e:	2ef50363          	beq	a0,a5,474 <go+0x3fc>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     192:	47b5                	li	a5,13
     194:	30f50563          	beq	a0,a5,49e <go+0x426>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 14){
     198:	47b9                	li	a5,14
     19a:	34f50063          	beq	a0,a5,4da <go+0x462>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
     19e:	47bd                	li	a5,15
     1a0:	38f50463          	beq	a0,a5,528 <go+0x4b0>
      sbrk(6011);
    } else if(what == 16){
     1a4:	47c1                	li	a5,16
     1a6:	38f50963          	beq	a0,a5,538 <go+0x4c0>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1aa:	47c5                	li	a5,17
     1ac:	3af50963          	beq	a0,a5,55e <go+0x4e6>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     1b0:	47c9                	li	a5,18
     1b2:	42f50f63          	beq	a0,a5,5f0 <go+0x578>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b6:	47cd                	li	a5,19
     1b8:	48f50363          	beq	a0,a5,63e <go+0x5c6>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1bc:	47d1                	li	a5,20
     1be:	56f50463          	beq	a0,a5,726 <go+0x6ae>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c2:	47d5                	li	a5,21
     1c4:	60f50263          	beq	a0,a5,7c8 <go+0x750>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c8:	47d9                	li	a5,22
     1ca:	f4f51ce3          	bne	a0,a5,122 <go+0xaa>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1ce:	f9840513          	addi	a0,s0,-104
     1d2:	00001097          	auipc	ra,0x1
     1d6:	cca080e7          	jalr	-822(ra) # e9c <pipe>
     1da:	6e054b63          	bltz	a0,8d0 <go+0x858>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1de:	fa040513          	addi	a0,s0,-96
     1e2:	00001097          	auipc	ra,0x1
     1e6:	cba080e7          	jalr	-838(ra) # e9c <pipe>
     1ea:	70054163          	bltz	a0,8ec <go+0x874>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ee:	00001097          	auipc	ra,0x1
     1f2:	c96080e7          	jalr	-874(ra) # e84 <fork>
      if(pid1 == 0){
     1f6:	70050963          	beqz	a0,908 <go+0x890>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1fa:	7c054163          	bltz	a0,9bc <go+0x944>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fe:	00001097          	auipc	ra,0x1
     202:	c86080e7          	jalr	-890(ra) # e84 <fork>
      if(pid2 == 0){
     206:	7c050963          	beqz	a0,9d8 <go+0x960>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     20a:	0a0545e3          	bltz	a0,ab4 <go+0xa3c>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20e:	f9842503          	lw	a0,-104(s0)
     212:	00001097          	auipc	ra,0x1
     216:	ca2080e7          	jalr	-862(ra) # eb4 <close>
      close(aa[1]);
     21a:	f9c42503          	lw	a0,-100(s0)
     21e:	00001097          	auipc	ra,0x1
     222:	c96080e7          	jalr	-874(ra) # eb4 <close>
      close(bb[1]);
     226:	fa442503          	lw	a0,-92(s0)
     22a:	00001097          	auipc	ra,0x1
     22e:	c8a080e7          	jalr	-886(ra) # eb4 <close>
      char buf[4] = { 0, 0, 0, 0 };
     232:	f8040823          	sb	zero,-112(s0)
     236:	f80408a3          	sb	zero,-111(s0)
     23a:	f8040923          	sb	zero,-110(s0)
     23e:	f80409a3          	sb	zero,-109(s0)
      read(bb[0], buf+0, 1);
     242:	4605                	li	a2,1
     244:	f9040593          	addi	a1,s0,-112
     248:	fa042503          	lw	a0,-96(s0)
     24c:	00001097          	auipc	ra,0x1
     250:	c58080e7          	jalr	-936(ra) # ea4 <read>
      read(bb[0], buf+1, 1);
     254:	4605                	li	a2,1
     256:	f9140593          	addi	a1,s0,-111
     25a:	fa042503          	lw	a0,-96(s0)
     25e:	00001097          	auipc	ra,0x1
     262:	c46080e7          	jalr	-954(ra) # ea4 <read>
      read(bb[0], buf+2, 1);
     266:	4605                	li	a2,1
     268:	f9240593          	addi	a1,s0,-110
     26c:	fa042503          	lw	a0,-96(s0)
     270:	00001097          	auipc	ra,0x1
     274:	c34080e7          	jalr	-972(ra) # ea4 <read>
      close(bb[0]);
     278:	fa042503          	lw	a0,-96(s0)
     27c:	00001097          	auipc	ra,0x1
     280:	c38080e7          	jalr	-968(ra) # eb4 <close>
      int st1, st2;
      wait(&st1);
     284:	f9440513          	addi	a0,s0,-108
     288:	00001097          	auipc	ra,0x1
     28c:	c0c080e7          	jalr	-1012(ra) # e94 <wait>
      wait(&st2);
     290:	fa840513          	addi	a0,s0,-88
     294:	00001097          	auipc	ra,0x1
     298:	c00080e7          	jalr	-1024(ra) # e94 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     29c:	f9442783          	lw	a5,-108(s0)
     2a0:	fa842703          	lw	a4,-88(s0)
     2a4:	8fd9                	or	a5,a5,a4
     2a6:	2781                	sext.w	a5,a5
     2a8:	ef89                	bnez	a5,2c2 <go+0x24a>
     2aa:	00001597          	auipc	a1,0x1
     2ae:	3d658593          	addi	a1,a1,982 # 1680 <malloc+0x3a4>
     2b2:	f9040513          	addi	a0,s0,-112
     2b6:	00001097          	auipc	ra,0x1
     2ba:	962080e7          	jalr	-1694(ra) # c18 <strcmp>
     2be:	e60502e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2c2:	f9040693          	addi	a3,s0,-112
     2c6:	fa842603          	lw	a2,-88(s0)
     2ca:	f9442583          	lw	a1,-108(s0)
     2ce:	00001517          	auipc	a0,0x1
     2d2:	3ba50513          	addi	a0,a0,954 # 1688 <malloc+0x3ac>
     2d6:	00001097          	auipc	ra,0x1
     2da:	f46080e7          	jalr	-186(ra) # 121c <printf>
        exit(1);
     2de:	4505                	li	a0,1
     2e0:	00001097          	auipc	ra,0x1
     2e4:	bac080e7          	jalr	-1108(ra) # e8c <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2e8:	20200593          	li	a1,514
     2ec:	00001517          	auipc	a0,0x1
     2f0:	12c50513          	addi	a0,a0,300 # 1418 <malloc+0x13c>
     2f4:	00001097          	auipc	ra,0x1
     2f8:	bd8080e7          	jalr	-1064(ra) # ecc <open>
     2fc:	00001097          	auipc	ra,0x1
     300:	bb8080e7          	jalr	-1096(ra) # eb4 <close>
     304:	bd39                	j	122 <go+0xaa>
      unlink("grindir/../a");
     306:	00001517          	auipc	a0,0x1
     30a:	10250513          	addi	a0,a0,258 # 1408 <malloc+0x12c>
     30e:	00001097          	auipc	ra,0x1
     312:	bce080e7          	jalr	-1074(ra) # edc <unlink>
     316:	b531                	j	122 <go+0xaa>
      if(chdir("grindir") != 0){
     318:	00001517          	auipc	a0,0x1
     31c:	0b050513          	addi	a0,a0,176 # 13c8 <malloc+0xec>
     320:	00001097          	auipc	ra,0x1
     324:	bdc080e7          	jalr	-1060(ra) # efc <chdir>
     328:	e115                	bnez	a0,34c <go+0x2d4>
      unlink("../b");
     32a:	00001517          	auipc	a0,0x1
     32e:	10650513          	addi	a0,a0,262 # 1430 <malloc+0x154>
     332:	00001097          	auipc	ra,0x1
     336:	baa080e7          	jalr	-1110(ra) # edc <unlink>
      chdir("/");
     33a:	00001517          	auipc	a0,0x1
     33e:	0b650513          	addi	a0,a0,182 # 13f0 <malloc+0x114>
     342:	00001097          	auipc	ra,0x1
     346:	bba080e7          	jalr	-1094(ra) # efc <chdir>
     34a:	bbe1                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     34c:	00001517          	auipc	a0,0x1
     350:	08450513          	addi	a0,a0,132 # 13d0 <malloc+0xf4>
     354:	00001097          	auipc	ra,0x1
     358:	ec8080e7          	jalr	-312(ra) # 121c <printf>
        exit(1);
     35c:	4505                	li	a0,1
     35e:	00001097          	auipc	ra,0x1
     362:	b2e080e7          	jalr	-1234(ra) # e8c <exit>
      close(fd);
     366:	854e                	mv	a0,s3
     368:	00001097          	auipc	ra,0x1
     36c:	b4c080e7          	jalr	-1204(ra) # eb4 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     370:	20200593          	li	a1,514
     374:	00001517          	auipc	a0,0x1
     378:	0c450513          	addi	a0,a0,196 # 1438 <malloc+0x15c>
     37c:	00001097          	auipc	ra,0x1
     380:	b50080e7          	jalr	-1200(ra) # ecc <open>
     384:	89aa                	mv	s3,a0
     386:	bb71                	j	122 <go+0xaa>
      close(fd);
     388:	854e                	mv	a0,s3
     38a:	00001097          	auipc	ra,0x1
     38e:	b2a080e7          	jalr	-1238(ra) # eb4 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     392:	20200593          	li	a1,514
     396:	00001517          	auipc	a0,0x1
     39a:	0b250513          	addi	a0,a0,178 # 1448 <malloc+0x16c>
     39e:	00001097          	auipc	ra,0x1
     3a2:	b2e080e7          	jalr	-1234(ra) # ecc <open>
     3a6:	89aa                	mv	s3,a0
     3a8:	bbad                	j	122 <go+0xaa>
      write(fd, buf, sizeof(buf));
     3aa:	3e700613          	li	a2,999
     3ae:	85d2                	mv	a1,s4
     3b0:	854e                	mv	a0,s3
     3b2:	00001097          	auipc	ra,0x1
     3b6:	afa080e7          	jalr	-1286(ra) # eac <write>
     3ba:	b3a5                	j	122 <go+0xaa>
      read(fd, buf, sizeof(buf));
     3bc:	3e700613          	li	a2,999
     3c0:	85d2                	mv	a1,s4
     3c2:	854e                	mv	a0,s3
     3c4:	00001097          	auipc	ra,0x1
     3c8:	ae0080e7          	jalr	-1312(ra) # ea4 <read>
     3cc:	bb99                	j	122 <go+0xaa>
      mkdir("grindir/../a");
     3ce:	00001517          	auipc	a0,0x1
     3d2:	03a50513          	addi	a0,a0,58 # 1408 <malloc+0x12c>
     3d6:	00001097          	auipc	ra,0x1
     3da:	b1e080e7          	jalr	-1250(ra) # ef4 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3de:	20200593          	li	a1,514
     3e2:	00001517          	auipc	a0,0x1
     3e6:	07e50513          	addi	a0,a0,126 # 1460 <malloc+0x184>
     3ea:	00001097          	auipc	ra,0x1
     3ee:	ae2080e7          	jalr	-1310(ra) # ecc <open>
     3f2:	00001097          	auipc	ra,0x1
     3f6:	ac2080e7          	jalr	-1342(ra) # eb4 <close>
      unlink("a/a");
     3fa:	00001517          	auipc	a0,0x1
     3fe:	07650513          	addi	a0,a0,118 # 1470 <malloc+0x194>
     402:	00001097          	auipc	ra,0x1
     406:	ada080e7          	jalr	-1318(ra) # edc <unlink>
     40a:	bb21                	j	122 <go+0xaa>
      mkdir("/../b");
     40c:	00001517          	auipc	a0,0x1
     410:	06c50513          	addi	a0,a0,108 # 1478 <malloc+0x19c>
     414:	00001097          	auipc	ra,0x1
     418:	ae0080e7          	jalr	-1312(ra) # ef4 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     41c:	20200593          	li	a1,514
     420:	00001517          	auipc	a0,0x1
     424:	06050513          	addi	a0,a0,96 # 1480 <malloc+0x1a4>
     428:	00001097          	auipc	ra,0x1
     42c:	aa4080e7          	jalr	-1372(ra) # ecc <open>
     430:	00001097          	auipc	ra,0x1
     434:	a84080e7          	jalr	-1404(ra) # eb4 <close>
      unlink("b/b");
     438:	00001517          	auipc	a0,0x1
     43c:	05850513          	addi	a0,a0,88 # 1490 <malloc+0x1b4>
     440:	00001097          	auipc	ra,0x1
     444:	a9c080e7          	jalr	-1380(ra) # edc <unlink>
     448:	b9e9                	j	122 <go+0xaa>
      unlink("b");
     44a:	00001517          	auipc	a0,0x1
     44e:	00e50513          	addi	a0,a0,14 # 1458 <malloc+0x17c>
     452:	00001097          	auipc	ra,0x1
     456:	a8a080e7          	jalr	-1398(ra) # edc <unlink>
      link("../grindir/./../a", "../b");
     45a:	00001597          	auipc	a1,0x1
     45e:	fd658593          	addi	a1,a1,-42 # 1430 <malloc+0x154>
     462:	00001517          	auipc	a0,0x1
     466:	03650513          	addi	a0,a0,54 # 1498 <malloc+0x1bc>
     46a:	00001097          	auipc	ra,0x1
     46e:	a82080e7          	jalr	-1406(ra) # eec <link>
     472:	b945                	j	122 <go+0xaa>
      unlink("../grindir/../a");
     474:	00001517          	auipc	a0,0x1
     478:	03c50513          	addi	a0,a0,60 # 14b0 <malloc+0x1d4>
     47c:	00001097          	auipc	ra,0x1
     480:	a60080e7          	jalr	-1440(ra) # edc <unlink>
      link(".././b", "/grindir/../a");
     484:	00001597          	auipc	a1,0x1
     488:	fb458593          	addi	a1,a1,-76 # 1438 <malloc+0x15c>
     48c:	00001517          	auipc	a0,0x1
     490:	03450513          	addi	a0,a0,52 # 14c0 <malloc+0x1e4>
     494:	00001097          	auipc	ra,0x1
     498:	a58080e7          	jalr	-1448(ra) # eec <link>
     49c:	b159                	j	122 <go+0xaa>
      int pid = fork();
     49e:	00001097          	auipc	ra,0x1
     4a2:	9e6080e7          	jalr	-1562(ra) # e84 <fork>
      if(pid == 0){
     4a6:	c909                	beqz	a0,4b8 <go+0x440>
      } else if(pid < 0){
     4a8:	00054c63          	bltz	a0,4c0 <go+0x448>
      wait(0);
     4ac:	4501                	li	a0,0
     4ae:	00001097          	auipc	ra,0x1
     4b2:	9e6080e7          	jalr	-1562(ra) # e94 <wait>
     4b6:	b1b5                	j	122 <go+0xaa>
        exit(0);
     4b8:	00001097          	auipc	ra,0x1
     4bc:	9d4080e7          	jalr	-1580(ra) # e8c <exit>
        printf("grind: fork failed\n");
     4c0:	00001517          	auipc	a0,0x1
     4c4:	00850513          	addi	a0,a0,8 # 14c8 <malloc+0x1ec>
     4c8:	00001097          	auipc	ra,0x1
     4cc:	d54080e7          	jalr	-684(ra) # 121c <printf>
        exit(1);
     4d0:	4505                	li	a0,1
     4d2:	00001097          	auipc	ra,0x1
     4d6:	9ba080e7          	jalr	-1606(ra) # e8c <exit>
      int pid = fork();
     4da:	00001097          	auipc	ra,0x1
     4de:	9aa080e7          	jalr	-1622(ra) # e84 <fork>
      if(pid == 0){
     4e2:	c909                	beqz	a0,4f4 <go+0x47c>
      } else if(pid < 0){
     4e4:	02054563          	bltz	a0,50e <go+0x496>
      wait(0);
     4e8:	4501                	li	a0,0
     4ea:	00001097          	auipc	ra,0x1
     4ee:	9aa080e7          	jalr	-1622(ra) # e94 <wait>
     4f2:	b905                	j	122 <go+0xaa>
        fork();
     4f4:	00001097          	auipc	ra,0x1
     4f8:	990080e7          	jalr	-1648(ra) # e84 <fork>
        fork();
     4fc:	00001097          	auipc	ra,0x1
     500:	988080e7          	jalr	-1656(ra) # e84 <fork>
        exit(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	986080e7          	jalr	-1658(ra) # e8c <exit>
        printf("grind: fork failed\n");
     50e:	00001517          	auipc	a0,0x1
     512:	fba50513          	addi	a0,a0,-70 # 14c8 <malloc+0x1ec>
     516:	00001097          	auipc	ra,0x1
     51a:	d06080e7          	jalr	-762(ra) # 121c <printf>
        exit(1);
     51e:	4505                	li	a0,1
     520:	00001097          	auipc	ra,0x1
     524:	96c080e7          	jalr	-1684(ra) # e8c <exit>
      sbrk(6011);
     528:	6505                	lui	a0,0x1
     52a:	77b50513          	addi	a0,a0,1915 # 177b <buf.1266+0x9b>
     52e:	00001097          	auipc	ra,0x1
     532:	9e6080e7          	jalr	-1562(ra) # f14 <sbrk>
     536:	b6f5                	j	122 <go+0xaa>
      if(sbrk(0) > break0)
     538:	4501                	li	a0,0
     53a:	00001097          	auipc	ra,0x1
     53e:	9da080e7          	jalr	-1574(ra) # f14 <sbrk>
     542:	beaaf0e3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     546:	4501                	li	a0,0
     548:	00001097          	auipc	ra,0x1
     54c:	9cc080e7          	jalr	-1588(ra) # f14 <sbrk>
     550:	40aa853b          	subw	a0,s5,a0
     554:	00001097          	auipc	ra,0x1
     558:	9c0080e7          	jalr	-1600(ra) # f14 <sbrk>
     55c:	b6d9                	j	122 <go+0xaa>
      int pid = fork();
     55e:	00001097          	auipc	ra,0x1
     562:	926080e7          	jalr	-1754(ra) # e84 <fork>
     566:	8b2a                	mv	s6,a0
      if(pid == 0){
     568:	c51d                	beqz	a0,596 <go+0x51e>
      } else if(pid < 0){
     56a:	04054963          	bltz	a0,5bc <go+0x544>
      if(chdir("../grindir/..") != 0){
     56e:	00001517          	auipc	a0,0x1
     572:	f7250513          	addi	a0,a0,-142 # 14e0 <malloc+0x204>
     576:	00001097          	auipc	ra,0x1
     57a:	986080e7          	jalr	-1658(ra) # efc <chdir>
     57e:	ed21                	bnez	a0,5d6 <go+0x55e>
      kill(pid);
     580:	855a                	mv	a0,s6
     582:	00001097          	auipc	ra,0x1
     586:	93a080e7          	jalr	-1734(ra) # ebc <kill>
      wait(0);
     58a:	4501                	li	a0,0
     58c:	00001097          	auipc	ra,0x1
     590:	908080e7          	jalr	-1784(ra) # e94 <wait>
     594:	b679                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     596:	20200593          	li	a1,514
     59a:	00001517          	auipc	a0,0x1
     59e:	f0e50513          	addi	a0,a0,-242 # 14a8 <malloc+0x1cc>
     5a2:	00001097          	auipc	ra,0x1
     5a6:	92a080e7          	jalr	-1750(ra) # ecc <open>
     5aa:	00001097          	auipc	ra,0x1
     5ae:	90a080e7          	jalr	-1782(ra) # eb4 <close>
        exit(0);
     5b2:	4501                	li	a0,0
     5b4:	00001097          	auipc	ra,0x1
     5b8:	8d8080e7          	jalr	-1832(ra) # e8c <exit>
        printf("grind: fork failed\n");
     5bc:	00001517          	auipc	a0,0x1
     5c0:	f0c50513          	addi	a0,a0,-244 # 14c8 <malloc+0x1ec>
     5c4:	00001097          	auipc	ra,0x1
     5c8:	c58080e7          	jalr	-936(ra) # 121c <printf>
        exit(1);
     5cc:	4505                	li	a0,1
     5ce:	00001097          	auipc	ra,0x1
     5d2:	8be080e7          	jalr	-1858(ra) # e8c <exit>
        printf("grind: chdir failed\n");
     5d6:	00001517          	auipc	a0,0x1
     5da:	f1a50513          	addi	a0,a0,-230 # 14f0 <malloc+0x214>
     5de:	00001097          	auipc	ra,0x1
     5e2:	c3e080e7          	jalr	-962(ra) # 121c <printf>
        exit(1);
     5e6:	4505                	li	a0,1
     5e8:	00001097          	auipc	ra,0x1
     5ec:	8a4080e7          	jalr	-1884(ra) # e8c <exit>
      int pid = fork();
     5f0:	00001097          	auipc	ra,0x1
     5f4:	894080e7          	jalr	-1900(ra) # e84 <fork>
      if(pid == 0){
     5f8:	c909                	beqz	a0,60a <go+0x592>
      } else if(pid < 0){
     5fa:	02054563          	bltz	a0,624 <go+0x5ac>
      wait(0);
     5fe:	4501                	li	a0,0
     600:	00001097          	auipc	ra,0x1
     604:	894080e7          	jalr	-1900(ra) # e94 <wait>
     608:	be29                	j	122 <go+0xaa>
        kill(getpid());
     60a:	00001097          	auipc	ra,0x1
     60e:	902080e7          	jalr	-1790(ra) # f0c <getpid>
     612:	00001097          	auipc	ra,0x1
     616:	8aa080e7          	jalr	-1878(ra) # ebc <kill>
        exit(0);
     61a:	4501                	li	a0,0
     61c:	00001097          	auipc	ra,0x1
     620:	870080e7          	jalr	-1936(ra) # e8c <exit>
        printf("grind: fork failed\n");
     624:	00001517          	auipc	a0,0x1
     628:	ea450513          	addi	a0,a0,-348 # 14c8 <malloc+0x1ec>
     62c:	00001097          	auipc	ra,0x1
     630:	bf0080e7          	jalr	-1040(ra) # 121c <printf>
        exit(1);
     634:	4505                	li	a0,1
     636:	00001097          	auipc	ra,0x1
     63a:	856080e7          	jalr	-1962(ra) # e8c <exit>
      if(pipe(fds) < 0){
     63e:	fa840513          	addi	a0,s0,-88
     642:	00001097          	auipc	ra,0x1
     646:	85a080e7          	jalr	-1958(ra) # e9c <pipe>
     64a:	02054b63          	bltz	a0,680 <go+0x608>
      int pid = fork();
     64e:	00001097          	auipc	ra,0x1
     652:	836080e7          	jalr	-1994(ra) # e84 <fork>
      if(pid == 0){
     656:	c131                	beqz	a0,69a <go+0x622>
      } else if(pid < 0){
     658:	0a054a63          	bltz	a0,70c <go+0x694>
      close(fds[0]);
     65c:	fa842503          	lw	a0,-88(s0)
     660:	00001097          	auipc	ra,0x1
     664:	854080e7          	jalr	-1964(ra) # eb4 <close>
      close(fds[1]);
     668:	fac42503          	lw	a0,-84(s0)
     66c:	00001097          	auipc	ra,0x1
     670:	848080e7          	jalr	-1976(ra) # eb4 <close>
      wait(0);
     674:	4501                	li	a0,0
     676:	00001097          	auipc	ra,0x1
     67a:	81e080e7          	jalr	-2018(ra) # e94 <wait>
     67e:	b455                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     680:	00001517          	auipc	a0,0x1
     684:	e8850513          	addi	a0,a0,-376 # 1508 <malloc+0x22c>
     688:	00001097          	auipc	ra,0x1
     68c:	b94080e7          	jalr	-1132(ra) # 121c <printf>
        exit(1);
     690:	4505                	li	a0,1
     692:	00000097          	auipc	ra,0x0
     696:	7fa080e7          	jalr	2042(ra) # e8c <exit>
        fork();
     69a:	00000097          	auipc	ra,0x0
     69e:	7ea080e7          	jalr	2026(ra) # e84 <fork>
        fork();
     6a2:	00000097          	auipc	ra,0x0
     6a6:	7e2080e7          	jalr	2018(ra) # e84 <fork>
        if(write(fds[1], "x", 1) != 1)
     6aa:	4605                	li	a2,1
     6ac:	00001597          	auipc	a1,0x1
     6b0:	e7458593          	addi	a1,a1,-396 # 1520 <malloc+0x244>
     6b4:	fac42503          	lw	a0,-84(s0)
     6b8:	00000097          	auipc	ra,0x0
     6bc:	7f4080e7          	jalr	2036(ra) # eac <write>
     6c0:	4785                	li	a5,1
     6c2:	02f51363          	bne	a0,a5,6e8 <go+0x670>
        if(read(fds[0], &c, 1) != 1)
     6c6:	4605                	li	a2,1
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	fa842503          	lw	a0,-88(s0)
     6d0:	00000097          	auipc	ra,0x0
     6d4:	7d4080e7          	jalr	2004(ra) # ea4 <read>
     6d8:	4785                	li	a5,1
     6da:	02f51063          	bne	a0,a5,6fa <go+0x682>
        exit(0);
     6de:	4501                	li	a0,0
     6e0:	00000097          	auipc	ra,0x0
     6e4:	7ac080e7          	jalr	1964(ra) # e8c <exit>
          printf("grind: pipe write failed\n");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	e4050513          	addi	a0,a0,-448 # 1528 <malloc+0x24c>
     6f0:	00001097          	auipc	ra,0x1
     6f4:	b2c080e7          	jalr	-1236(ra) # 121c <printf>
     6f8:	b7f9                	j	6c6 <go+0x64e>
          printf("grind: pipe read failed\n");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	e4e50513          	addi	a0,a0,-434 # 1548 <malloc+0x26c>
     702:	00001097          	auipc	ra,0x1
     706:	b1a080e7          	jalr	-1254(ra) # 121c <printf>
     70a:	bfd1                	j	6de <go+0x666>
        printf("grind: fork failed\n");
     70c:	00001517          	auipc	a0,0x1
     710:	dbc50513          	addi	a0,a0,-580 # 14c8 <malloc+0x1ec>
     714:	00001097          	auipc	ra,0x1
     718:	b08080e7          	jalr	-1272(ra) # 121c <printf>
        exit(1);
     71c:	4505                	li	a0,1
     71e:	00000097          	auipc	ra,0x0
     722:	76e080e7          	jalr	1902(ra) # e8c <exit>
      int pid = fork();
     726:	00000097          	auipc	ra,0x0
     72a:	75e080e7          	jalr	1886(ra) # e84 <fork>
      if(pid == 0){
     72e:	c909                	beqz	a0,740 <go+0x6c8>
      } else if(pid < 0){
     730:	06054f63          	bltz	a0,7ae <go+0x736>
      wait(0);
     734:	4501                	li	a0,0
     736:	00000097          	auipc	ra,0x0
     73a:	75e080e7          	jalr	1886(ra) # e94 <wait>
     73e:	b2d5                	j	122 <go+0xaa>
        unlink("a");
     740:	00001517          	auipc	a0,0x1
     744:	d6850513          	addi	a0,a0,-664 # 14a8 <malloc+0x1cc>
     748:	00000097          	auipc	ra,0x0
     74c:	794080e7          	jalr	1940(ra) # edc <unlink>
        mkdir("a");
     750:	00001517          	auipc	a0,0x1
     754:	d5850513          	addi	a0,a0,-680 # 14a8 <malloc+0x1cc>
     758:	00000097          	auipc	ra,0x0
     75c:	79c080e7          	jalr	1948(ra) # ef4 <mkdir>
        chdir("a");
     760:	00001517          	auipc	a0,0x1
     764:	d4850513          	addi	a0,a0,-696 # 14a8 <malloc+0x1cc>
     768:	00000097          	auipc	ra,0x0
     76c:	794080e7          	jalr	1940(ra) # efc <chdir>
        unlink("../a");
     770:	00001517          	auipc	a0,0x1
     774:	ca050513          	addi	a0,a0,-864 # 1410 <malloc+0x134>
     778:	00000097          	auipc	ra,0x0
     77c:	764080e7          	jalr	1892(ra) # edc <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     780:	20200593          	li	a1,514
     784:	00001517          	auipc	a0,0x1
     788:	d9c50513          	addi	a0,a0,-612 # 1520 <malloc+0x244>
     78c:	00000097          	auipc	ra,0x0
     790:	740080e7          	jalr	1856(ra) # ecc <open>
        unlink("x");
     794:	00001517          	auipc	a0,0x1
     798:	d8c50513          	addi	a0,a0,-628 # 1520 <malloc+0x244>
     79c:	00000097          	auipc	ra,0x0
     7a0:	740080e7          	jalr	1856(ra) # edc <unlink>
        exit(0);
     7a4:	4501                	li	a0,0
     7a6:	00000097          	auipc	ra,0x0
     7aa:	6e6080e7          	jalr	1766(ra) # e8c <exit>
        printf("grind: fork failed\n");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	d1a50513          	addi	a0,a0,-742 # 14c8 <malloc+0x1ec>
     7b6:	00001097          	auipc	ra,0x1
     7ba:	a66080e7          	jalr	-1434(ra) # 121c <printf>
        exit(1);
     7be:	4505                	li	a0,1
     7c0:	00000097          	auipc	ra,0x0
     7c4:	6cc080e7          	jalr	1740(ra) # e8c <exit>
      unlink("c");
     7c8:	00001517          	auipc	a0,0x1
     7cc:	da050513          	addi	a0,a0,-608 # 1568 <malloc+0x28c>
     7d0:	00000097          	auipc	ra,0x0
     7d4:	70c080e7          	jalr	1804(ra) # edc <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7d8:	20200593          	li	a1,514
     7dc:	00001517          	auipc	a0,0x1
     7e0:	d8c50513          	addi	a0,a0,-628 # 1568 <malloc+0x28c>
     7e4:	00000097          	auipc	ra,0x0
     7e8:	6e8080e7          	jalr	1768(ra) # ecc <open>
     7ec:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7ee:	04054f63          	bltz	a0,84c <go+0x7d4>
      if(write(fd1, "x", 1) != 1){
     7f2:	4605                	li	a2,1
     7f4:	00001597          	auipc	a1,0x1
     7f8:	d2c58593          	addi	a1,a1,-724 # 1520 <malloc+0x244>
     7fc:	00000097          	auipc	ra,0x0
     800:	6b0080e7          	jalr	1712(ra) # eac <write>
     804:	4785                	li	a5,1
     806:	06f51063          	bne	a0,a5,866 <go+0x7ee>
      if(fstat(fd1, &st) != 0){
     80a:	fa840593          	addi	a1,s0,-88
     80e:	855a                	mv	a0,s6
     810:	00000097          	auipc	ra,0x0
     814:	6d4080e7          	jalr	1748(ra) # ee4 <fstat>
     818:	e525                	bnez	a0,880 <go+0x808>
      if(st.size != 1){
     81a:	fb843583          	ld	a1,-72(s0)
     81e:	4785                	li	a5,1
     820:	06f59d63          	bne	a1,a5,89a <go+0x822>
      if(st.ino > 200){
     824:	fac42583          	lw	a1,-84(s0)
     828:	0c800793          	li	a5,200
     82c:	08b7e563          	bltu	a5,a1,8b6 <go+0x83e>
      close(fd1);
     830:	855a                	mv	a0,s6
     832:	00000097          	auipc	ra,0x0
     836:	682080e7          	jalr	1666(ra) # eb4 <close>
      unlink("c");
     83a:	00001517          	auipc	a0,0x1
     83e:	d2e50513          	addi	a0,a0,-722 # 1568 <malloc+0x28c>
     842:	00000097          	auipc	ra,0x0
     846:	69a080e7          	jalr	1690(ra) # edc <unlink>
     84a:	b8e1                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     84c:	00001517          	auipc	a0,0x1
     850:	d2450513          	addi	a0,a0,-732 # 1570 <malloc+0x294>
     854:	00001097          	auipc	ra,0x1
     858:	9c8080e7          	jalr	-1592(ra) # 121c <printf>
        exit(1);
     85c:	4505                	li	a0,1
     85e:	00000097          	auipc	ra,0x0
     862:	62e080e7          	jalr	1582(ra) # e8c <exit>
        printf("grind: write c failed\n");
     866:	00001517          	auipc	a0,0x1
     86a:	d2250513          	addi	a0,a0,-734 # 1588 <malloc+0x2ac>
     86e:	00001097          	auipc	ra,0x1
     872:	9ae080e7          	jalr	-1618(ra) # 121c <printf>
        exit(1);
     876:	4505                	li	a0,1
     878:	00000097          	auipc	ra,0x0
     87c:	614080e7          	jalr	1556(ra) # e8c <exit>
        printf("grind: fstat failed\n");
     880:	00001517          	auipc	a0,0x1
     884:	d2050513          	addi	a0,a0,-736 # 15a0 <malloc+0x2c4>
     888:	00001097          	auipc	ra,0x1
     88c:	994080e7          	jalr	-1644(ra) # 121c <printf>
        exit(1);
     890:	4505                	li	a0,1
     892:	00000097          	auipc	ra,0x0
     896:	5fa080e7          	jalr	1530(ra) # e8c <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     89a:	2581                	sext.w	a1,a1
     89c:	00001517          	auipc	a0,0x1
     8a0:	d1c50513          	addi	a0,a0,-740 # 15b8 <malloc+0x2dc>
     8a4:	00001097          	auipc	ra,0x1
     8a8:	978080e7          	jalr	-1672(ra) # 121c <printf>
        exit(1);
     8ac:	4505                	li	a0,1
     8ae:	00000097          	auipc	ra,0x0
     8b2:	5de080e7          	jalr	1502(ra) # e8c <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     8b6:	00001517          	auipc	a0,0x1
     8ba:	d2a50513          	addi	a0,a0,-726 # 15e0 <malloc+0x304>
     8be:	00001097          	auipc	ra,0x1
     8c2:	95e080e7          	jalr	-1698(ra) # 121c <printf>
        exit(1);
     8c6:	4505                	li	a0,1
     8c8:	00000097          	auipc	ra,0x0
     8cc:	5c4080e7          	jalr	1476(ra) # e8c <exit>
        fprintf(2, "grind: pipe failed\n");
     8d0:	00001597          	auipc	a1,0x1
     8d4:	c3858593          	addi	a1,a1,-968 # 1508 <malloc+0x22c>
     8d8:	4509                	li	a0,2
     8da:	00001097          	auipc	ra,0x1
     8de:	914080e7          	jalr	-1772(ra) # 11ee <fprintf>
        exit(1);
     8e2:	4505                	li	a0,1
     8e4:	00000097          	auipc	ra,0x0
     8e8:	5a8080e7          	jalr	1448(ra) # e8c <exit>
        fprintf(2, "grind: pipe failed\n");
     8ec:	00001597          	auipc	a1,0x1
     8f0:	c1c58593          	addi	a1,a1,-996 # 1508 <malloc+0x22c>
     8f4:	4509                	li	a0,2
     8f6:	00001097          	auipc	ra,0x1
     8fa:	8f8080e7          	jalr	-1800(ra) # 11ee <fprintf>
        exit(1);
     8fe:	4505                	li	a0,1
     900:	00000097          	auipc	ra,0x0
     904:	58c080e7          	jalr	1420(ra) # e8c <exit>
        close(bb[0]);
     908:	fa042503          	lw	a0,-96(s0)
     90c:	00000097          	auipc	ra,0x0
     910:	5a8080e7          	jalr	1448(ra) # eb4 <close>
        close(bb[1]);
     914:	fa442503          	lw	a0,-92(s0)
     918:	00000097          	auipc	ra,0x0
     91c:	59c080e7          	jalr	1436(ra) # eb4 <close>
        close(aa[0]);
     920:	f9842503          	lw	a0,-104(s0)
     924:	00000097          	auipc	ra,0x0
     928:	590080e7          	jalr	1424(ra) # eb4 <close>
        close(1);
     92c:	4505                	li	a0,1
     92e:	00000097          	auipc	ra,0x0
     932:	586080e7          	jalr	1414(ra) # eb4 <close>
        if(dup(aa[1]) != 1){
     936:	f9c42503          	lw	a0,-100(s0)
     93a:	00000097          	auipc	ra,0x0
     93e:	5ca080e7          	jalr	1482(ra) # f04 <dup>
     942:	4785                	li	a5,1
     944:	02f50063          	beq	a0,a5,964 <go+0x8ec>
          fprintf(2, "grind: dup failed\n");
     948:	00001597          	auipc	a1,0x1
     94c:	cc058593          	addi	a1,a1,-832 # 1608 <malloc+0x32c>
     950:	4509                	li	a0,2
     952:	00001097          	auipc	ra,0x1
     956:	89c080e7          	jalr	-1892(ra) # 11ee <fprintf>
          exit(1);
     95a:	4505                	li	a0,1
     95c:	00000097          	auipc	ra,0x0
     960:	530080e7          	jalr	1328(ra) # e8c <exit>
        close(aa[1]);
     964:	f9c42503          	lw	a0,-100(s0)
     968:	00000097          	auipc	ra,0x0
     96c:	54c080e7          	jalr	1356(ra) # eb4 <close>
        char *args[3] = { "echo", "hi", 0 };
     970:	00001797          	auipc	a5,0x1
     974:	cb078793          	addi	a5,a5,-848 # 1620 <malloc+0x344>
     978:	faf43423          	sd	a5,-88(s0)
     97c:	00001797          	auipc	a5,0x1
     980:	cac78793          	addi	a5,a5,-852 # 1628 <malloc+0x34c>
     984:	faf43823          	sd	a5,-80(s0)
     988:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     98c:	fa840593          	addi	a1,s0,-88
     990:	00001517          	auipc	a0,0x1
     994:	ca050513          	addi	a0,a0,-864 # 1630 <malloc+0x354>
     998:	00000097          	auipc	ra,0x0
     99c:	52c080e7          	jalr	1324(ra) # ec4 <exec>
        fprintf(2, "grind: echo: not found\n");
     9a0:	00001597          	auipc	a1,0x1
     9a4:	ca058593          	addi	a1,a1,-864 # 1640 <malloc+0x364>
     9a8:	4509                	li	a0,2
     9aa:	00001097          	auipc	ra,0x1
     9ae:	844080e7          	jalr	-1980(ra) # 11ee <fprintf>
        exit(2);
     9b2:	4509                	li	a0,2
     9b4:	00000097          	auipc	ra,0x0
     9b8:	4d8080e7          	jalr	1240(ra) # e8c <exit>
        fprintf(2, "grind: fork failed\n");
     9bc:	00001597          	auipc	a1,0x1
     9c0:	b0c58593          	addi	a1,a1,-1268 # 14c8 <malloc+0x1ec>
     9c4:	4509                	li	a0,2
     9c6:	00001097          	auipc	ra,0x1
     9ca:	828080e7          	jalr	-2008(ra) # 11ee <fprintf>
        exit(3);
     9ce:	450d                	li	a0,3
     9d0:	00000097          	auipc	ra,0x0
     9d4:	4bc080e7          	jalr	1212(ra) # e8c <exit>
        close(aa[1]);
     9d8:	f9c42503          	lw	a0,-100(s0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	4d8080e7          	jalr	1240(ra) # eb4 <close>
        close(bb[0]);
     9e4:	fa042503          	lw	a0,-96(s0)
     9e8:	00000097          	auipc	ra,0x0
     9ec:	4cc080e7          	jalr	1228(ra) # eb4 <close>
        close(0);
     9f0:	4501                	li	a0,0
     9f2:	00000097          	auipc	ra,0x0
     9f6:	4c2080e7          	jalr	1218(ra) # eb4 <close>
        if(dup(aa[0]) != 0){
     9fa:	f9842503          	lw	a0,-104(s0)
     9fe:	00000097          	auipc	ra,0x0
     a02:	506080e7          	jalr	1286(ra) # f04 <dup>
     a06:	cd19                	beqz	a0,a24 <go+0x9ac>
          fprintf(2, "grind: dup failed\n");
     a08:	00001597          	auipc	a1,0x1
     a0c:	c0058593          	addi	a1,a1,-1024 # 1608 <malloc+0x32c>
     a10:	4509                	li	a0,2
     a12:	00000097          	auipc	ra,0x0
     a16:	7dc080e7          	jalr	2012(ra) # 11ee <fprintf>
          exit(4);
     a1a:	4511                	li	a0,4
     a1c:	00000097          	auipc	ra,0x0
     a20:	470080e7          	jalr	1136(ra) # e8c <exit>
        close(aa[0]);
     a24:	f9842503          	lw	a0,-104(s0)
     a28:	00000097          	auipc	ra,0x0
     a2c:	48c080e7          	jalr	1164(ra) # eb4 <close>
        close(1);
     a30:	4505                	li	a0,1
     a32:	00000097          	auipc	ra,0x0
     a36:	482080e7          	jalr	1154(ra) # eb4 <close>
        if(dup(bb[1]) != 1){
     a3a:	fa442503          	lw	a0,-92(s0)
     a3e:	00000097          	auipc	ra,0x0
     a42:	4c6080e7          	jalr	1222(ra) # f04 <dup>
     a46:	4785                	li	a5,1
     a48:	02f50063          	beq	a0,a5,a68 <go+0x9f0>
          fprintf(2, "grind: dup failed\n");
     a4c:	00001597          	auipc	a1,0x1
     a50:	bbc58593          	addi	a1,a1,-1092 # 1608 <malloc+0x32c>
     a54:	4509                	li	a0,2
     a56:	00000097          	auipc	ra,0x0
     a5a:	798080e7          	jalr	1944(ra) # 11ee <fprintf>
          exit(5);
     a5e:	4515                	li	a0,5
     a60:	00000097          	auipc	ra,0x0
     a64:	42c080e7          	jalr	1068(ra) # e8c <exit>
        close(bb[1]);
     a68:	fa442503          	lw	a0,-92(s0)
     a6c:	00000097          	auipc	ra,0x0
     a70:	448080e7          	jalr	1096(ra) # eb4 <close>
        char *args[2] = { "cat", 0 };
     a74:	00001797          	auipc	a5,0x1
     a78:	be478793          	addi	a5,a5,-1052 # 1658 <malloc+0x37c>
     a7c:	faf43423          	sd	a5,-88(s0)
     a80:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a84:	fa840593          	addi	a1,s0,-88
     a88:	00001517          	auipc	a0,0x1
     a8c:	bd850513          	addi	a0,a0,-1064 # 1660 <malloc+0x384>
     a90:	00000097          	auipc	ra,0x0
     a94:	434080e7          	jalr	1076(ra) # ec4 <exec>
        fprintf(2, "grind: cat: not found\n");
     a98:	00001597          	auipc	a1,0x1
     a9c:	bd058593          	addi	a1,a1,-1072 # 1668 <malloc+0x38c>
     aa0:	4509                	li	a0,2
     aa2:	00000097          	auipc	ra,0x0
     aa6:	74c080e7          	jalr	1868(ra) # 11ee <fprintf>
        exit(6);
     aaa:	4519                	li	a0,6
     aac:	00000097          	auipc	ra,0x0
     ab0:	3e0080e7          	jalr	992(ra) # e8c <exit>
        fprintf(2, "grind: fork failed\n");
     ab4:	00001597          	auipc	a1,0x1
     ab8:	a1458593          	addi	a1,a1,-1516 # 14c8 <malloc+0x1ec>
     abc:	4509                	li	a0,2
     abe:	00000097          	auipc	ra,0x0
     ac2:	730080e7          	jalr	1840(ra) # 11ee <fprintf>
        exit(7);
     ac6:	451d                	li	a0,7
     ac8:	00000097          	auipc	ra,0x0
     acc:	3c4080e7          	jalr	964(ra) # e8c <exit>

0000000000000ad0 <iter>:
  }
}

void
iter()
{
     ad0:	7179                	addi	sp,sp,-48
     ad2:	f406                	sd	ra,40(sp)
     ad4:	f022                	sd	s0,32(sp)
     ad6:	ec26                	sd	s1,24(sp)
     ad8:	e84a                	sd	s2,16(sp)
     ada:	1800                	addi	s0,sp,48
  unlink("a");
     adc:	00001517          	auipc	a0,0x1
     ae0:	9cc50513          	addi	a0,a0,-1588 # 14a8 <malloc+0x1cc>
     ae4:	00000097          	auipc	ra,0x0
     ae8:	3f8080e7          	jalr	1016(ra) # edc <unlink>
  unlink("b");
     aec:	00001517          	auipc	a0,0x1
     af0:	96c50513          	addi	a0,a0,-1684 # 1458 <malloc+0x17c>
     af4:	00000097          	auipc	ra,0x0
     af8:	3e8080e7          	jalr	1000(ra) # edc <unlink>
  
  int pid1 = fork();
     afc:	00000097          	auipc	ra,0x0
     b00:	388080e7          	jalr	904(ra) # e84 <fork>
  if(pid1 < 0){
     b04:	00054e63          	bltz	a0,b20 <iter+0x50>
     b08:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b0a:	e905                	bnez	a0,b3a <iter+0x6a>
    rand_next = 31;
     b0c:	47fd                	li	a5,31
     b0e:	00001717          	auipc	a4,0x1
     b12:	bcf73123          	sd	a5,-1086(a4) # 16d0 <rand_next>
    go(0);
     b16:	4501                	li	a0,0
     b18:	fffff097          	auipc	ra,0xfffff
     b1c:	560080e7          	jalr	1376(ra) # 78 <go>
    printf("grind: fork failed\n");
     b20:	00001517          	auipc	a0,0x1
     b24:	9a850513          	addi	a0,a0,-1624 # 14c8 <malloc+0x1ec>
     b28:	00000097          	auipc	ra,0x0
     b2c:	6f4080e7          	jalr	1780(ra) # 121c <printf>
    exit(1);
     b30:	4505                	li	a0,1
     b32:	00000097          	auipc	ra,0x0
     b36:	35a080e7          	jalr	858(ra) # e8c <exit>
    exit(0);
  }

  int pid2 = fork();
     b3a:	00000097          	auipc	ra,0x0
     b3e:	34a080e7          	jalr	842(ra) # e84 <fork>
     b42:	892a                	mv	s2,a0
  if(pid2 < 0){
     b44:	00054f63          	bltz	a0,b62 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b48:	e915                	bnez	a0,b7c <iter+0xac>
    rand_next = 7177;
     b4a:	6789                	lui	a5,0x2
     b4c:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x131>
     b50:	00001717          	auipc	a4,0x1
     b54:	b8f73023          	sd	a5,-1152(a4) # 16d0 <rand_next>
    go(1);
     b58:	4505                	li	a0,1
     b5a:	fffff097          	auipc	ra,0xfffff
     b5e:	51e080e7          	jalr	1310(ra) # 78 <go>
    printf("grind: fork failed\n");
     b62:	00001517          	auipc	a0,0x1
     b66:	96650513          	addi	a0,a0,-1690 # 14c8 <malloc+0x1ec>
     b6a:	00000097          	auipc	ra,0x0
     b6e:	6b2080e7          	jalr	1714(ra) # 121c <printf>
    exit(1);
     b72:	4505                	li	a0,1
     b74:	00000097          	auipc	ra,0x0
     b78:	318080e7          	jalr	792(ra) # e8c <exit>
    exit(0);
  }

  int st1 = -1;
     b7c:	57fd                	li	a5,-1
     b7e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b82:	fdc40513          	addi	a0,s0,-36
     b86:	00000097          	auipc	ra,0x0
     b8a:	30e080e7          	jalr	782(ra) # e94 <wait>
  if(st1 != 0){
     b8e:	fdc42783          	lw	a5,-36(s0)
     b92:	ef99                	bnez	a5,bb0 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b94:	57fd                	li	a5,-1
     b96:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b9a:	fd840513          	addi	a0,s0,-40
     b9e:	00000097          	auipc	ra,0x0
     ba2:	2f6080e7          	jalr	758(ra) # e94 <wait>

  exit(0);
     ba6:	4501                	li	a0,0
     ba8:	00000097          	auipc	ra,0x0
     bac:	2e4080e7          	jalr	740(ra) # e8c <exit>
    kill(pid1);
     bb0:	8526                	mv	a0,s1
     bb2:	00000097          	auipc	ra,0x0
     bb6:	30a080e7          	jalr	778(ra) # ebc <kill>
    kill(pid2);
     bba:	854a                	mv	a0,s2
     bbc:	00000097          	auipc	ra,0x0
     bc0:	300080e7          	jalr	768(ra) # ebc <kill>
     bc4:	bfc1                	j	b94 <iter+0xc4>

0000000000000bc6 <main>:
}

int
main()
{
     bc6:	1141                	addi	sp,sp,-16
     bc8:	e406                	sd	ra,8(sp)
     bca:	e022                	sd	s0,0(sp)
     bcc:	0800                	addi	s0,sp,16
     bce:	a811                	j	be2 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     bd0:	00000097          	auipc	ra,0x0
     bd4:	f00080e7          	jalr	-256(ra) # ad0 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     bd8:	4551                	li	a0,20
     bda:	00000097          	auipc	ra,0x0
     bde:	342080e7          	jalr	834(ra) # f1c <sleep>
    int pid = fork();
     be2:	00000097          	auipc	ra,0x0
     be6:	2a2080e7          	jalr	674(ra) # e84 <fork>
    if(pid == 0){
     bea:	d17d                	beqz	a0,bd0 <main+0xa>
    if(pid > 0){
     bec:	fea056e3          	blez	a0,bd8 <main+0x12>
      wait(0);
     bf0:	4501                	li	a0,0
     bf2:	00000097          	auipc	ra,0x0
     bf6:	2a2080e7          	jalr	674(ra) # e94 <wait>
     bfa:	bff9                	j	bd8 <main+0x12>

0000000000000bfc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     bfc:	1141                	addi	sp,sp,-16
     bfe:	e422                	sd	s0,8(sp)
     c00:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c02:	87aa                	mv	a5,a0
     c04:	0585                	addi	a1,a1,1
     c06:	0785                	addi	a5,a5,1
     c08:	fff5c703          	lbu	a4,-1(a1)
     c0c:	fee78fa3          	sb	a4,-1(a5)
     c10:	fb75                	bnez	a4,c04 <strcpy+0x8>
    ;
  return os;
}
     c12:	6422                	ld	s0,8(sp)
     c14:	0141                	addi	sp,sp,16
     c16:	8082                	ret

0000000000000c18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c18:	1141                	addi	sp,sp,-16
     c1a:	e422                	sd	s0,8(sp)
     c1c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c1e:	00054783          	lbu	a5,0(a0)
     c22:	cf91                	beqz	a5,c3e <strcmp+0x26>
     c24:	0005c703          	lbu	a4,0(a1)
     c28:	00f71b63          	bne	a4,a5,c3e <strcmp+0x26>
    p++, q++;
     c2c:	0505                	addi	a0,a0,1
     c2e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c30:	00054783          	lbu	a5,0(a0)
     c34:	c789                	beqz	a5,c3e <strcmp+0x26>
     c36:	0005c703          	lbu	a4,0(a1)
     c3a:	fef709e3          	beq	a4,a5,c2c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     c3e:	0005c503          	lbu	a0,0(a1)
}
     c42:	40a7853b          	subw	a0,a5,a0
     c46:	6422                	ld	s0,8(sp)
     c48:	0141                	addi	sp,sp,16
     c4a:	8082                	ret

0000000000000c4c <strlen>:

uint
strlen(const char *s)
{
     c4c:	1141                	addi	sp,sp,-16
     c4e:	e422                	sd	s0,8(sp)
     c50:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c52:	00054783          	lbu	a5,0(a0)
     c56:	cf91                	beqz	a5,c72 <strlen+0x26>
     c58:	0505                	addi	a0,a0,1
     c5a:	87aa                	mv	a5,a0
     c5c:	4685                	li	a3,1
     c5e:	9e89                	subw	a3,a3,a0
     c60:	00f6853b          	addw	a0,a3,a5
     c64:	0785                	addi	a5,a5,1
     c66:	fff7c703          	lbu	a4,-1(a5)
     c6a:	fb7d                	bnez	a4,c60 <strlen+0x14>
    ;
  return n;
}
     c6c:	6422                	ld	s0,8(sp)
     c6e:	0141                	addi	sp,sp,16
     c70:	8082                	ret
  for(n = 0; s[n]; n++)
     c72:	4501                	li	a0,0
     c74:	bfe5                	j	c6c <strlen+0x20>

0000000000000c76 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c76:	1141                	addi	sp,sp,-16
     c78:	e422                	sd	s0,8(sp)
     c7a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c7c:	ce09                	beqz	a2,c96 <memset+0x20>
     c7e:	87aa                	mv	a5,a0
     c80:	fff6071b          	addiw	a4,a2,-1
     c84:	1702                	slli	a4,a4,0x20
     c86:	9301                	srli	a4,a4,0x20
     c88:	0705                	addi	a4,a4,1
     c8a:	972a                	add	a4,a4,a0
    cdst[i] = c;
     c8c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c90:	0785                	addi	a5,a5,1
     c92:	fee79de3          	bne	a5,a4,c8c <memset+0x16>
  }
  return dst;
}
     c96:	6422                	ld	s0,8(sp)
     c98:	0141                	addi	sp,sp,16
     c9a:	8082                	ret

0000000000000c9c <strchr>:

char*
strchr(const char *s, char c)
{
     c9c:	1141                	addi	sp,sp,-16
     c9e:	e422                	sd	s0,8(sp)
     ca0:	0800                	addi	s0,sp,16
  for(; *s; s++)
     ca2:	00054783          	lbu	a5,0(a0)
     ca6:	cf91                	beqz	a5,cc2 <strchr+0x26>
    if(*s == c)
     ca8:	00f58a63          	beq	a1,a5,cbc <strchr+0x20>
  for(; *s; s++)
     cac:	0505                	addi	a0,a0,1
     cae:	00054783          	lbu	a5,0(a0)
     cb2:	c781                	beqz	a5,cba <strchr+0x1e>
    if(*s == c)
     cb4:	feb79ce3          	bne	a5,a1,cac <strchr+0x10>
     cb8:	a011                	j	cbc <strchr+0x20>
      return (char*)s;
  return 0;
     cba:	4501                	li	a0,0
}
     cbc:	6422                	ld	s0,8(sp)
     cbe:	0141                	addi	sp,sp,16
     cc0:	8082                	ret
  return 0;
     cc2:	4501                	li	a0,0
     cc4:	bfe5                	j	cbc <strchr+0x20>

0000000000000cc6 <gets>:

char*
gets(char *buf, int max)
{
     cc6:	711d                	addi	sp,sp,-96
     cc8:	ec86                	sd	ra,88(sp)
     cca:	e8a2                	sd	s0,80(sp)
     ccc:	e4a6                	sd	s1,72(sp)
     cce:	e0ca                	sd	s2,64(sp)
     cd0:	fc4e                	sd	s3,56(sp)
     cd2:	f852                	sd	s4,48(sp)
     cd4:	f456                	sd	s5,40(sp)
     cd6:	f05a                	sd	s6,32(sp)
     cd8:	ec5e                	sd	s7,24(sp)
     cda:	1080                	addi	s0,sp,96
     cdc:	8baa                	mv	s7,a0
     cde:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ce0:	892a                	mv	s2,a0
     ce2:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ce4:	4aa9                	li	s5,10
     ce6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     ce8:	0019849b          	addiw	s1,s3,1
     cec:	0344d863          	bge	s1,s4,d1c <gets+0x56>
    cc = read(0, &c, 1);
     cf0:	4605                	li	a2,1
     cf2:	faf40593          	addi	a1,s0,-81
     cf6:	4501                	li	a0,0
     cf8:	00000097          	auipc	ra,0x0
     cfc:	1ac080e7          	jalr	428(ra) # ea4 <read>
    if(cc < 1)
     d00:	00a05e63          	blez	a0,d1c <gets+0x56>
    buf[i++] = c;
     d04:	faf44783          	lbu	a5,-81(s0)
     d08:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d0c:	01578763          	beq	a5,s5,d1a <gets+0x54>
     d10:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
     d12:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
     d14:	fd679ae3          	bne	a5,s6,ce8 <gets+0x22>
     d18:	a011                	j	d1c <gets+0x56>
  for(i=0; i+1 < max; ){
     d1a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d1c:	99de                	add	s3,s3,s7
     d1e:	00098023          	sb	zero,0(s3)
  return buf;
}
     d22:	855e                	mv	a0,s7
     d24:	60e6                	ld	ra,88(sp)
     d26:	6446                	ld	s0,80(sp)
     d28:	64a6                	ld	s1,72(sp)
     d2a:	6906                	ld	s2,64(sp)
     d2c:	79e2                	ld	s3,56(sp)
     d2e:	7a42                	ld	s4,48(sp)
     d30:	7aa2                	ld	s5,40(sp)
     d32:	7b02                	ld	s6,32(sp)
     d34:	6be2                	ld	s7,24(sp)
     d36:	6125                	addi	sp,sp,96
     d38:	8082                	ret

0000000000000d3a <stat>:

int
stat(const char *n, struct stat *st)
{
     d3a:	1101                	addi	sp,sp,-32
     d3c:	ec06                	sd	ra,24(sp)
     d3e:	e822                	sd	s0,16(sp)
     d40:	e426                	sd	s1,8(sp)
     d42:	e04a                	sd	s2,0(sp)
     d44:	1000                	addi	s0,sp,32
     d46:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d48:	4581                	li	a1,0
     d4a:	00000097          	auipc	ra,0x0
     d4e:	182080e7          	jalr	386(ra) # ecc <open>
  if(fd < 0)
     d52:	02054563          	bltz	a0,d7c <stat+0x42>
     d56:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d58:	85ca                	mv	a1,s2
     d5a:	00000097          	auipc	ra,0x0
     d5e:	18a080e7          	jalr	394(ra) # ee4 <fstat>
     d62:	892a                	mv	s2,a0
  close(fd);
     d64:	8526                	mv	a0,s1
     d66:	00000097          	auipc	ra,0x0
     d6a:	14e080e7          	jalr	334(ra) # eb4 <close>
  return r;
}
     d6e:	854a                	mv	a0,s2
     d70:	60e2                	ld	ra,24(sp)
     d72:	6442                	ld	s0,16(sp)
     d74:	64a2                	ld	s1,8(sp)
     d76:	6902                	ld	s2,0(sp)
     d78:	6105                	addi	sp,sp,32
     d7a:	8082                	ret
    return -1;
     d7c:	597d                	li	s2,-1
     d7e:	bfc5                	j	d6e <stat+0x34>

0000000000000d80 <atoi>:

int
atoi(const char *s)
{
     d80:	1141                	addi	sp,sp,-16
     d82:	e422                	sd	s0,8(sp)
     d84:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d86:	00054683          	lbu	a3,0(a0)
     d8a:	fd06879b          	addiw	a5,a3,-48
     d8e:	0ff7f793          	andi	a5,a5,255
     d92:	4725                	li	a4,9
     d94:	02f76963          	bltu	a4,a5,dc6 <atoi+0x46>
     d98:	862a                	mv	a2,a0
  n = 0;
     d9a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d9c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d9e:	0605                	addi	a2,a2,1
     da0:	0025179b          	slliw	a5,a0,0x2
     da4:	9fa9                	addw	a5,a5,a0
     da6:	0017979b          	slliw	a5,a5,0x1
     daa:	9fb5                	addw	a5,a5,a3
     dac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     db0:	00064683          	lbu	a3,0(a2)
     db4:	fd06871b          	addiw	a4,a3,-48
     db8:	0ff77713          	andi	a4,a4,255
     dbc:	fee5f1e3          	bgeu	a1,a4,d9e <atoi+0x1e>
  return n;
}
     dc0:	6422                	ld	s0,8(sp)
     dc2:	0141                	addi	sp,sp,16
     dc4:	8082                	ret
  n = 0;
     dc6:	4501                	li	a0,0
     dc8:	bfe5                	j	dc0 <atoi+0x40>

0000000000000dca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     dca:	1141                	addi	sp,sp,-16
     dcc:	e422                	sd	s0,8(sp)
     dce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dd0:	02b57663          	bgeu	a0,a1,dfc <memmove+0x32>
    while(n-- > 0)
     dd4:	02c05163          	blez	a2,df6 <memmove+0x2c>
     dd8:	fff6079b          	addiw	a5,a2,-1
     ddc:	1782                	slli	a5,a5,0x20
     dde:	9381                	srli	a5,a5,0x20
     de0:	0785                	addi	a5,a5,1
     de2:	97aa                	add	a5,a5,a0
  dst = vdst;
     de4:	872a                	mv	a4,a0
      *dst++ = *src++;
     de6:	0585                	addi	a1,a1,1
     de8:	0705                	addi	a4,a4,1
     dea:	fff5c683          	lbu	a3,-1(a1)
     dee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     df2:	fee79ae3          	bne	a5,a4,de6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     df6:	6422                	ld	s0,8(sp)
     df8:	0141                	addi	sp,sp,16
     dfa:	8082                	ret
    dst += n;
     dfc:	00c50733          	add	a4,a0,a2
    src += n;
     e00:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e02:	fec05ae3          	blez	a2,df6 <memmove+0x2c>
     e06:	fff6079b          	addiw	a5,a2,-1
     e0a:	1782                	slli	a5,a5,0x20
     e0c:	9381                	srli	a5,a5,0x20
     e0e:	fff7c793          	not	a5,a5
     e12:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e14:	15fd                	addi	a1,a1,-1
     e16:	177d                	addi	a4,a4,-1
     e18:	0005c683          	lbu	a3,0(a1)
     e1c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e20:	fef71ae3          	bne	a4,a5,e14 <memmove+0x4a>
     e24:	bfc9                	j	df6 <memmove+0x2c>

0000000000000e26 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e26:	1141                	addi	sp,sp,-16
     e28:	e422                	sd	s0,8(sp)
     e2a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e2c:	ce15                	beqz	a2,e68 <memcmp+0x42>
     e2e:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
     e32:	00054783          	lbu	a5,0(a0)
     e36:	0005c703          	lbu	a4,0(a1)
     e3a:	02e79063          	bne	a5,a4,e5a <memcmp+0x34>
     e3e:	1682                	slli	a3,a3,0x20
     e40:	9281                	srli	a3,a3,0x20
     e42:	0685                	addi	a3,a3,1
     e44:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
     e46:	0505                	addi	a0,a0,1
    p2++;
     e48:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e4a:	00d50d63          	beq	a0,a3,e64 <memcmp+0x3e>
    if (*p1 != *p2) {
     e4e:	00054783          	lbu	a5,0(a0)
     e52:	0005c703          	lbu	a4,0(a1)
     e56:	fee788e3          	beq	a5,a4,e46 <memcmp+0x20>
      return *p1 - *p2;
     e5a:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
     e5e:	6422                	ld	s0,8(sp)
     e60:	0141                	addi	sp,sp,16
     e62:	8082                	ret
  return 0;
     e64:	4501                	li	a0,0
     e66:	bfe5                	j	e5e <memcmp+0x38>
     e68:	4501                	li	a0,0
     e6a:	bfd5                	j	e5e <memcmp+0x38>

0000000000000e6c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e6c:	1141                	addi	sp,sp,-16
     e6e:	e406                	sd	ra,8(sp)
     e70:	e022                	sd	s0,0(sp)
     e72:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e74:	00000097          	auipc	ra,0x0
     e78:	f56080e7          	jalr	-170(ra) # dca <memmove>
}
     e7c:	60a2                	ld	ra,8(sp)
     e7e:	6402                	ld	s0,0(sp)
     e80:	0141                	addi	sp,sp,16
     e82:	8082                	ret

0000000000000e84 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e84:	4885                	li	a7,1
 ecall
     e86:	00000073          	ecall
 ret
     e8a:	8082                	ret

0000000000000e8c <exit>:
.global exit
exit:
 li a7, SYS_exit
     e8c:	4889                	li	a7,2
 ecall
     e8e:	00000073          	ecall
 ret
     e92:	8082                	ret

0000000000000e94 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e94:	488d                	li	a7,3
 ecall
     e96:	00000073          	ecall
 ret
     e9a:	8082                	ret

0000000000000e9c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e9c:	4891                	li	a7,4
 ecall
     e9e:	00000073          	ecall
 ret
     ea2:	8082                	ret

0000000000000ea4 <read>:
.global read
read:
 li a7, SYS_read
     ea4:	4895                	li	a7,5
 ecall
     ea6:	00000073          	ecall
 ret
     eaa:	8082                	ret

0000000000000eac <write>:
.global write
write:
 li a7, SYS_write
     eac:	48c1                	li	a7,16
 ecall
     eae:	00000073          	ecall
 ret
     eb2:	8082                	ret

0000000000000eb4 <close>:
.global close
close:
 li a7, SYS_close
     eb4:	48d5                	li	a7,21
 ecall
     eb6:	00000073          	ecall
 ret
     eba:	8082                	ret

0000000000000ebc <kill>:
.global kill
kill:
 li a7, SYS_kill
     ebc:	4899                	li	a7,6
 ecall
     ebe:	00000073          	ecall
 ret
     ec2:	8082                	ret

0000000000000ec4 <exec>:
.global exec
exec:
 li a7, SYS_exec
     ec4:	489d                	li	a7,7
 ecall
     ec6:	00000073          	ecall
 ret
     eca:	8082                	ret

0000000000000ecc <open>:
.global open
open:
 li a7, SYS_open
     ecc:	48bd                	li	a7,15
 ecall
     ece:	00000073          	ecall
 ret
     ed2:	8082                	ret

0000000000000ed4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ed4:	48c5                	li	a7,17
 ecall
     ed6:	00000073          	ecall
 ret
     eda:	8082                	ret

0000000000000edc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     edc:	48c9                	li	a7,18
 ecall
     ede:	00000073          	ecall
 ret
     ee2:	8082                	ret

0000000000000ee4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ee4:	48a1                	li	a7,8
 ecall
     ee6:	00000073          	ecall
 ret
     eea:	8082                	ret

0000000000000eec <link>:
.global link
link:
 li a7, SYS_link
     eec:	48cd                	li	a7,19
 ecall
     eee:	00000073          	ecall
 ret
     ef2:	8082                	ret

0000000000000ef4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ef4:	48d1                	li	a7,20
 ecall
     ef6:	00000073          	ecall
 ret
     efa:	8082                	ret

0000000000000efc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     efc:	48a5                	li	a7,9
 ecall
     efe:	00000073          	ecall
 ret
     f02:	8082                	ret

0000000000000f04 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f04:	48a9                	li	a7,10
 ecall
     f06:	00000073          	ecall
 ret
     f0a:	8082                	ret

0000000000000f0c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f0c:	48ad                	li	a7,11
 ecall
     f0e:	00000073          	ecall
 ret
     f12:	8082                	ret

0000000000000f14 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f14:	48b1                	li	a7,12
 ecall
     f16:	00000073          	ecall
 ret
     f1a:	8082                	ret

0000000000000f1c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f1c:	48b5                	li	a7,13
 ecall
     f1e:	00000073          	ecall
 ret
     f22:	8082                	ret

0000000000000f24 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f24:	48b9                	li	a7,14
 ecall
     f26:	00000073          	ecall
 ret
     f2a:	8082                	ret

0000000000000f2c <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
     f2c:	48d9                	li	a7,22
 ecall
     f2e:	00000073          	ecall
 ret
     f32:	8082                	ret

0000000000000f34 <trace>:
.global trace
trace:
 li a7, SYS_trace
     f34:	48dd                	li	a7,23
 ecall
     f36:	00000073          	ecall
 ret
     f3a:	8082                	ret

0000000000000f3c <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
     f3c:	48e1                	li	a7,24
 ecall
     f3e:	00000073          	ecall
 ret
     f42:	8082                	ret

0000000000000f44 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f44:	1101                	addi	sp,sp,-32
     f46:	ec06                	sd	ra,24(sp)
     f48:	e822                	sd	s0,16(sp)
     f4a:	1000                	addi	s0,sp,32
     f4c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f50:	4605                	li	a2,1
     f52:	fef40593          	addi	a1,s0,-17
     f56:	00000097          	auipc	ra,0x0
     f5a:	f56080e7          	jalr	-170(ra) # eac <write>
}
     f5e:	60e2                	ld	ra,24(sp)
     f60:	6442                	ld	s0,16(sp)
     f62:	6105                	addi	sp,sp,32
     f64:	8082                	ret

0000000000000f66 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f66:	7139                	addi	sp,sp,-64
     f68:	fc06                	sd	ra,56(sp)
     f6a:	f822                	sd	s0,48(sp)
     f6c:	f426                	sd	s1,40(sp)
     f6e:	f04a                	sd	s2,32(sp)
     f70:	ec4e                	sd	s3,24(sp)
     f72:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f74:	c299                	beqz	a3,f7a <printint+0x14>
     f76:	0005cd63          	bltz	a1,f90 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f7a:	2581                	sext.w	a1,a1
  neg = 0;
     f7c:	4301                	li	t1,0
     f7e:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
     f82:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
     f84:	2601                	sext.w	a2,a2
     f86:	00000897          	auipc	a7,0x0
     f8a:	72a88893          	addi	a7,a7,1834 # 16b0 <digits>
     f8e:	a801                	j	f9e <printint+0x38>
    x = -xx;
     f90:	40b005bb          	negw	a1,a1
     f94:	2581                	sext.w	a1,a1
    neg = 1;
     f96:	4305                	li	t1,1
    x = -xx;
     f98:	b7dd                	j	f7e <printint+0x18>
  }while((x /= base) != 0);
     f9a:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
     f9c:	8836                	mv	a6,a3
     f9e:	0018069b          	addiw	a3,a6,1
     fa2:	02c5f7bb          	remuw	a5,a1,a2
     fa6:	1782                	slli	a5,a5,0x20
     fa8:	9381                	srli	a5,a5,0x20
     faa:	97c6                	add	a5,a5,a7
     fac:	0007c783          	lbu	a5,0(a5)
     fb0:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
     fb4:	0705                	addi	a4,a4,1
     fb6:	02c5d7bb          	divuw	a5,a1,a2
     fba:	fec5f0e3          	bgeu	a1,a2,f9a <printint+0x34>
  if(neg)
     fbe:	00030b63          	beqz	t1,fd4 <printint+0x6e>
    buf[i++] = '-';
     fc2:	fd040793          	addi	a5,s0,-48
     fc6:	96be                	add	a3,a3,a5
     fc8:	02d00793          	li	a5,45
     fcc:	fef68823          	sb	a5,-16(a3)
     fd0:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
     fd4:	02d05963          	blez	a3,1006 <printint+0xa0>
     fd8:	89aa                	mv	s3,a0
     fda:	fc040793          	addi	a5,s0,-64
     fde:	00d784b3          	add	s1,a5,a3
     fe2:	fff78913          	addi	s2,a5,-1
     fe6:	9936                	add	s2,s2,a3
     fe8:	36fd                	addiw	a3,a3,-1
     fea:	1682                	slli	a3,a3,0x20
     fec:	9281                	srli	a3,a3,0x20
     fee:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
     ff2:	fff4c583          	lbu	a1,-1(s1)
     ff6:	854e                	mv	a0,s3
     ff8:	00000097          	auipc	ra,0x0
     ffc:	f4c080e7          	jalr	-180(ra) # f44 <putc>
  while(--i >= 0)
    1000:	14fd                	addi	s1,s1,-1
    1002:	ff2498e3          	bne	s1,s2,ff2 <printint+0x8c>
}
    1006:	70e2                	ld	ra,56(sp)
    1008:	7442                	ld	s0,48(sp)
    100a:	74a2                	ld	s1,40(sp)
    100c:	7902                	ld	s2,32(sp)
    100e:	69e2                	ld	s3,24(sp)
    1010:	6121                	addi	sp,sp,64
    1012:	8082                	ret

0000000000001014 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1014:	7119                	addi	sp,sp,-128
    1016:	fc86                	sd	ra,120(sp)
    1018:	f8a2                	sd	s0,112(sp)
    101a:	f4a6                	sd	s1,104(sp)
    101c:	f0ca                	sd	s2,96(sp)
    101e:	ecce                	sd	s3,88(sp)
    1020:	e8d2                	sd	s4,80(sp)
    1022:	e4d6                	sd	s5,72(sp)
    1024:	e0da                	sd	s6,64(sp)
    1026:	fc5e                	sd	s7,56(sp)
    1028:	f862                	sd	s8,48(sp)
    102a:	f466                	sd	s9,40(sp)
    102c:	f06a                	sd	s10,32(sp)
    102e:	ec6e                	sd	s11,24(sp)
    1030:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1032:	0005c483          	lbu	s1,0(a1)
    1036:	18048d63          	beqz	s1,11d0 <vprintf+0x1bc>
    103a:	8aaa                	mv	s5,a0
    103c:	8b32                	mv	s6,a2
    103e:	00158913          	addi	s2,a1,1
  state = 0;
    1042:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1044:	02500a13          	li	s4,37
      if(c == 'd'){
    1048:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    104c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1050:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1054:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1058:	00000b97          	auipc	s7,0x0
    105c:	658b8b93          	addi	s7,s7,1624 # 16b0 <digits>
    1060:	a839                	j	107e <vprintf+0x6a>
        putc(fd, c);
    1062:	85a6                	mv	a1,s1
    1064:	8556                	mv	a0,s5
    1066:	00000097          	auipc	ra,0x0
    106a:	ede080e7          	jalr	-290(ra) # f44 <putc>
    106e:	a019                	j	1074 <vprintf+0x60>
    } else if(state == '%'){
    1070:	01498f63          	beq	s3,s4,108e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1074:	0905                	addi	s2,s2,1
    1076:	fff94483          	lbu	s1,-1(s2)
    107a:	14048b63          	beqz	s1,11d0 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
    107e:	0004879b          	sext.w	a5,s1
    if(state == 0){
    1082:	fe0997e3          	bnez	s3,1070 <vprintf+0x5c>
      if(c == '%'){
    1086:	fd479ee3          	bne	a5,s4,1062 <vprintf+0x4e>
        state = '%';
    108a:	89be                	mv	s3,a5
    108c:	b7e5                	j	1074 <vprintf+0x60>
      if(c == 'd'){
    108e:	05878063          	beq	a5,s8,10ce <vprintf+0xba>
      } else if(c == 'l') {
    1092:	05978c63          	beq	a5,s9,10ea <vprintf+0xd6>
      } else if(c == 'x') {
    1096:	07a78863          	beq	a5,s10,1106 <vprintf+0xf2>
      } else if(c == 'p') {
    109a:	09b78463          	beq	a5,s11,1122 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    109e:	07300713          	li	a4,115
    10a2:	0ce78563          	beq	a5,a4,116c <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    10a6:	06300713          	li	a4,99
    10aa:	0ee78c63          	beq	a5,a4,11a2 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    10ae:	11478663          	beq	a5,s4,11ba <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10b2:	85d2                	mv	a1,s4
    10b4:	8556                	mv	a0,s5
    10b6:	00000097          	auipc	ra,0x0
    10ba:	e8e080e7          	jalr	-370(ra) # f44 <putc>
        putc(fd, c);
    10be:	85a6                	mv	a1,s1
    10c0:	8556                	mv	a0,s5
    10c2:	00000097          	auipc	ra,0x0
    10c6:	e82080e7          	jalr	-382(ra) # f44 <putc>
      }
      state = 0;
    10ca:	4981                	li	s3,0
    10cc:	b765                	j	1074 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    10ce:	008b0493          	addi	s1,s6,8
    10d2:	4685                	li	a3,1
    10d4:	4629                	li	a2,10
    10d6:	000b2583          	lw	a1,0(s6)
    10da:	8556                	mv	a0,s5
    10dc:	00000097          	auipc	ra,0x0
    10e0:	e8a080e7          	jalr	-374(ra) # f66 <printint>
    10e4:	8b26                	mv	s6,s1
      state = 0;
    10e6:	4981                	li	s3,0
    10e8:	b771                	j	1074 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10ea:	008b0493          	addi	s1,s6,8
    10ee:	4681                	li	a3,0
    10f0:	4629                	li	a2,10
    10f2:	000b2583          	lw	a1,0(s6)
    10f6:	8556                	mv	a0,s5
    10f8:	00000097          	auipc	ra,0x0
    10fc:	e6e080e7          	jalr	-402(ra) # f66 <printint>
    1100:	8b26                	mv	s6,s1
      state = 0;
    1102:	4981                	li	s3,0
    1104:	bf85                	j	1074 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1106:	008b0493          	addi	s1,s6,8
    110a:	4681                	li	a3,0
    110c:	4641                	li	a2,16
    110e:	000b2583          	lw	a1,0(s6)
    1112:	8556                	mv	a0,s5
    1114:	00000097          	auipc	ra,0x0
    1118:	e52080e7          	jalr	-430(ra) # f66 <printint>
    111c:	8b26                	mv	s6,s1
      state = 0;
    111e:	4981                	li	s3,0
    1120:	bf91                	j	1074 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1122:	008b0793          	addi	a5,s6,8
    1126:	f8f43423          	sd	a5,-120(s0)
    112a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    112e:	03000593          	li	a1,48
    1132:	8556                	mv	a0,s5
    1134:	00000097          	auipc	ra,0x0
    1138:	e10080e7          	jalr	-496(ra) # f44 <putc>
  putc(fd, 'x');
    113c:	85ea                	mv	a1,s10
    113e:	8556                	mv	a0,s5
    1140:	00000097          	auipc	ra,0x0
    1144:	e04080e7          	jalr	-508(ra) # f44 <putc>
    1148:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    114a:	03c9d793          	srli	a5,s3,0x3c
    114e:	97de                	add	a5,a5,s7
    1150:	0007c583          	lbu	a1,0(a5)
    1154:	8556                	mv	a0,s5
    1156:	00000097          	auipc	ra,0x0
    115a:	dee080e7          	jalr	-530(ra) # f44 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    115e:	0992                	slli	s3,s3,0x4
    1160:	34fd                	addiw	s1,s1,-1
    1162:	f4e5                	bnez	s1,114a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1164:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1168:	4981                	li	s3,0
    116a:	b729                	j	1074 <vprintf+0x60>
        s = va_arg(ap, char*);
    116c:	008b0993          	addi	s3,s6,8
    1170:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    1174:	c085                	beqz	s1,1194 <vprintf+0x180>
        while(*s != 0){
    1176:	0004c583          	lbu	a1,0(s1)
    117a:	c9a1                	beqz	a1,11ca <vprintf+0x1b6>
          putc(fd, *s);
    117c:	8556                	mv	a0,s5
    117e:	00000097          	auipc	ra,0x0
    1182:	dc6080e7          	jalr	-570(ra) # f44 <putc>
          s++;
    1186:	0485                	addi	s1,s1,1
        while(*s != 0){
    1188:	0004c583          	lbu	a1,0(s1)
    118c:	f9e5                	bnez	a1,117c <vprintf+0x168>
        s = va_arg(ap, char*);
    118e:	8b4e                	mv	s6,s3
      state = 0;
    1190:	4981                	li	s3,0
    1192:	b5cd                	j	1074 <vprintf+0x60>
          s = "(null)";
    1194:	00000497          	auipc	s1,0x0
    1198:	53448493          	addi	s1,s1,1332 # 16c8 <digits+0x18>
        while(*s != 0){
    119c:	02800593          	li	a1,40
    11a0:	bff1                	j	117c <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    11a2:	008b0493          	addi	s1,s6,8
    11a6:	000b4583          	lbu	a1,0(s6)
    11aa:	8556                	mv	a0,s5
    11ac:	00000097          	auipc	ra,0x0
    11b0:	d98080e7          	jalr	-616(ra) # f44 <putc>
    11b4:	8b26                	mv	s6,s1
      state = 0;
    11b6:	4981                	li	s3,0
    11b8:	bd75                	j	1074 <vprintf+0x60>
        putc(fd, c);
    11ba:	85d2                	mv	a1,s4
    11bc:	8556                	mv	a0,s5
    11be:	00000097          	auipc	ra,0x0
    11c2:	d86080e7          	jalr	-634(ra) # f44 <putc>
      state = 0;
    11c6:	4981                	li	s3,0
    11c8:	b575                	j	1074 <vprintf+0x60>
        s = va_arg(ap, char*);
    11ca:	8b4e                	mv	s6,s3
      state = 0;
    11cc:	4981                	li	s3,0
    11ce:	b55d                	j	1074 <vprintf+0x60>
    }
  }
}
    11d0:	70e6                	ld	ra,120(sp)
    11d2:	7446                	ld	s0,112(sp)
    11d4:	74a6                	ld	s1,104(sp)
    11d6:	7906                	ld	s2,96(sp)
    11d8:	69e6                	ld	s3,88(sp)
    11da:	6a46                	ld	s4,80(sp)
    11dc:	6aa6                	ld	s5,72(sp)
    11de:	6b06                	ld	s6,64(sp)
    11e0:	7be2                	ld	s7,56(sp)
    11e2:	7c42                	ld	s8,48(sp)
    11e4:	7ca2                	ld	s9,40(sp)
    11e6:	7d02                	ld	s10,32(sp)
    11e8:	6de2                	ld	s11,24(sp)
    11ea:	6109                	addi	sp,sp,128
    11ec:	8082                	ret

00000000000011ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11ee:	715d                	addi	sp,sp,-80
    11f0:	ec06                	sd	ra,24(sp)
    11f2:	e822                	sd	s0,16(sp)
    11f4:	1000                	addi	s0,sp,32
    11f6:	e010                	sd	a2,0(s0)
    11f8:	e414                	sd	a3,8(s0)
    11fa:	e818                	sd	a4,16(s0)
    11fc:	ec1c                	sd	a5,24(s0)
    11fe:	03043023          	sd	a6,32(s0)
    1202:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1206:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    120a:	8622                	mv	a2,s0
    120c:	00000097          	auipc	ra,0x0
    1210:	e08080e7          	jalr	-504(ra) # 1014 <vprintf>
}
    1214:	60e2                	ld	ra,24(sp)
    1216:	6442                	ld	s0,16(sp)
    1218:	6161                	addi	sp,sp,80
    121a:	8082                	ret

000000000000121c <printf>:

void
printf(const char *fmt, ...)
{
    121c:	711d                	addi	sp,sp,-96
    121e:	ec06                	sd	ra,24(sp)
    1220:	e822                	sd	s0,16(sp)
    1222:	1000                	addi	s0,sp,32
    1224:	e40c                	sd	a1,8(s0)
    1226:	e810                	sd	a2,16(s0)
    1228:	ec14                	sd	a3,24(s0)
    122a:	f018                	sd	a4,32(s0)
    122c:	f41c                	sd	a5,40(s0)
    122e:	03043823          	sd	a6,48(s0)
    1232:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1236:	00840613          	addi	a2,s0,8
    123a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    123e:	85aa                	mv	a1,a0
    1240:	4505                	li	a0,1
    1242:	00000097          	auipc	ra,0x0
    1246:	dd2080e7          	jalr	-558(ra) # 1014 <vprintf>
}
    124a:	60e2                	ld	ra,24(sp)
    124c:	6442                	ld	s0,16(sp)
    124e:	6125                	addi	sp,sp,96
    1250:	8082                	ret

0000000000001252 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1252:	1141                	addi	sp,sp,-16
    1254:	e422                	sd	s0,8(sp)
    1256:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1258:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    125c:	00000797          	auipc	a5,0x0
    1260:	47c78793          	addi	a5,a5,1148 # 16d8 <freep>
    1264:	639c                	ld	a5,0(a5)
    1266:	a805                	j	1296 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1268:	4618                	lw	a4,8(a2)
    126a:	9db9                	addw	a1,a1,a4
    126c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1270:	6398                	ld	a4,0(a5)
    1272:	6318                	ld	a4,0(a4)
    1274:	fee53823          	sd	a4,-16(a0)
    1278:	a091                	j	12bc <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    127a:	ff852703          	lw	a4,-8(a0)
    127e:	9e39                	addw	a2,a2,a4
    1280:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1282:	ff053703          	ld	a4,-16(a0)
    1286:	e398                	sd	a4,0(a5)
    1288:	a099                	j	12ce <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    128a:	6398                	ld	a4,0(a5)
    128c:	00e7e463          	bltu	a5,a4,1294 <free+0x42>
    1290:	00e6ea63          	bltu	a3,a4,12a4 <free+0x52>
{
    1294:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1296:	fed7fae3          	bgeu	a5,a3,128a <free+0x38>
    129a:	6398                	ld	a4,0(a5)
    129c:	00e6e463          	bltu	a3,a4,12a4 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12a0:	fee7eae3          	bltu	a5,a4,1294 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    12a4:	ff852583          	lw	a1,-8(a0)
    12a8:	6390                	ld	a2,0(a5)
    12aa:	02059713          	slli	a4,a1,0x20
    12ae:	9301                	srli	a4,a4,0x20
    12b0:	0712                	slli	a4,a4,0x4
    12b2:	9736                	add	a4,a4,a3
    12b4:	fae60ae3          	beq	a2,a4,1268 <free+0x16>
    bp->s.ptr = p->s.ptr;
    12b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12bc:	4790                	lw	a2,8(a5)
    12be:	02061713          	slli	a4,a2,0x20
    12c2:	9301                	srli	a4,a4,0x20
    12c4:	0712                	slli	a4,a4,0x4
    12c6:	973e                	add	a4,a4,a5
    12c8:	fae689e3          	beq	a3,a4,127a <free+0x28>
  } else
    p->s.ptr = bp;
    12cc:	e394                	sd	a3,0(a5)
  freep = p;
    12ce:	00000717          	auipc	a4,0x0
    12d2:	40f73523          	sd	a5,1034(a4) # 16d8 <freep>
}
    12d6:	6422                	ld	s0,8(sp)
    12d8:	0141                	addi	sp,sp,16
    12da:	8082                	ret

00000000000012dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12dc:	7139                	addi	sp,sp,-64
    12de:	fc06                	sd	ra,56(sp)
    12e0:	f822                	sd	s0,48(sp)
    12e2:	f426                	sd	s1,40(sp)
    12e4:	f04a                	sd	s2,32(sp)
    12e6:	ec4e                	sd	s3,24(sp)
    12e8:	e852                	sd	s4,16(sp)
    12ea:	e456                	sd	s5,8(sp)
    12ec:	e05a                	sd	s6,0(sp)
    12ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12f0:	02051993          	slli	s3,a0,0x20
    12f4:	0209d993          	srli	s3,s3,0x20
    12f8:	09bd                	addi	s3,s3,15
    12fa:	0049d993          	srli	s3,s3,0x4
    12fe:	2985                	addiw	s3,s3,1
    1300:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    1304:	00000797          	auipc	a5,0x0
    1308:	3d478793          	addi	a5,a5,980 # 16d8 <freep>
    130c:	6388                	ld	a0,0(a5)
    130e:	c515                	beqz	a0,133a <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1310:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1312:	4798                	lw	a4,8(a5)
    1314:	03277f63          	bgeu	a4,s2,1352 <malloc+0x76>
    1318:	8a4e                	mv	s4,s3
    131a:	0009871b          	sext.w	a4,s3
    131e:	6685                	lui	a3,0x1
    1320:	00d77363          	bgeu	a4,a3,1326 <malloc+0x4a>
    1324:	6a05                	lui	s4,0x1
    1326:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    132a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    132e:	00000497          	auipc	s1,0x0
    1332:	3aa48493          	addi	s1,s1,938 # 16d8 <freep>
  if(p == (char*)-1)
    1336:	5b7d                	li	s6,-1
    1338:	a885                	j	13a8 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    133a:	00000797          	auipc	a5,0x0
    133e:	78e78793          	addi	a5,a5,1934 # 1ac8 <base>
    1342:	00000717          	auipc	a4,0x0
    1346:	38f73b23          	sd	a5,918(a4) # 16d8 <freep>
    134a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    134c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1350:	b7e1                	j	1318 <malloc+0x3c>
      if(p->s.size == nunits)
    1352:	02e90b63          	beq	s2,a4,1388 <malloc+0xac>
        p->s.size -= nunits;
    1356:	4137073b          	subw	a4,a4,s3
    135a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    135c:	1702                	slli	a4,a4,0x20
    135e:	9301                	srli	a4,a4,0x20
    1360:	0712                	slli	a4,a4,0x4
    1362:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1364:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1368:	00000717          	auipc	a4,0x0
    136c:	36a73823          	sd	a0,880(a4) # 16d8 <freep>
      return (void*)(p + 1);
    1370:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1374:	70e2                	ld	ra,56(sp)
    1376:	7442                	ld	s0,48(sp)
    1378:	74a2                	ld	s1,40(sp)
    137a:	7902                	ld	s2,32(sp)
    137c:	69e2                	ld	s3,24(sp)
    137e:	6a42                	ld	s4,16(sp)
    1380:	6aa2                	ld	s5,8(sp)
    1382:	6b02                	ld	s6,0(sp)
    1384:	6121                	addi	sp,sp,64
    1386:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1388:	6398                	ld	a4,0(a5)
    138a:	e118                	sd	a4,0(a0)
    138c:	bff1                	j	1368 <malloc+0x8c>
  hp->s.size = nu;
    138e:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    1392:	0541                	addi	a0,a0,16
    1394:	00000097          	auipc	ra,0x0
    1398:	ebe080e7          	jalr	-322(ra) # 1252 <free>
  return freep;
    139c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    139e:	d979                	beqz	a0,1374 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13a2:	4798                	lw	a4,8(a5)
    13a4:	fb2777e3          	bgeu	a4,s2,1352 <malloc+0x76>
    if(p == freep)
    13a8:	6098                	ld	a4,0(s1)
    13aa:	853e                	mv	a0,a5
    13ac:	fef71ae3          	bne	a4,a5,13a0 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    13b0:	8552                	mv	a0,s4
    13b2:	00000097          	auipc	ra,0x0
    13b6:	b62080e7          	jalr	-1182(ra) # f14 <sbrk>
  if(p == (char*)-1)
    13ba:	fd651ae3          	bne	a0,s6,138e <malloc+0xb2>
        return 0;
    13be:	4501                	li	a0,0
    13c0:	bf55                	j	1374 <malloc+0x98>
