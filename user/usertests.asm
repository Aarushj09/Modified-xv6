
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	8d0080e7          	jalr	-1840(ra) # 58e0 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	8be080e7          	jalr	-1858(ra) # 58e0 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	1aa50513          	addi	a0,a0,426 # 61e8 <malloc+0x4f8>
      46:	00006097          	auipc	ra,0x6
      4a:	bea080e7          	jalr	-1046(ra) # 5c30 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	850080e7          	jalr	-1968(ra) # 58a0 <exit>

0000000000000058 <bsstest>:
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      58:	00009797          	auipc	a5,0x9
      5c:	6907c783          	lbu	a5,1680(a5) # 96e8 <uninit>
      60:	e385                	bnez	a5,80 <bsstest+0x28>
      62:	00009797          	auipc	a5,0x9
      66:	68778793          	addi	a5,a5,1671 # 96e9 <uninit+0x1>
      6a:	0000c697          	auipc	a3,0xc
      6e:	d8e68693          	addi	a3,a3,-626 # bdf8 <buf>
      72:	0007c703          	lbu	a4,0(a5)
      76:	e709                	bnez	a4,80 <bsstest+0x28>
  for(i = 0; i < sizeof(uninit); i++){
      78:	0785                	addi	a5,a5,1
      7a:	fed79ce3          	bne	a5,a3,72 <bsstest+0x1a>
      7e:	8082                	ret
{
      80:	1141                	addi	sp,sp,-16
      82:	e406                	sd	ra,8(sp)
      84:	e022                	sd	s0,0(sp)
      86:	0800                	addi	s0,sp,16
      88:	85aa                	mv	a1,a0
      printf("%s: bss test failed\n", s);
      8a:	00006517          	auipc	a0,0x6
      8e:	17e50513          	addi	a0,a0,382 # 6208 <malloc+0x518>
      92:	00006097          	auipc	ra,0x6
      96:	b9e080e7          	jalr	-1122(ra) # 5c30 <printf>
      exit(1);
      9a:	4505                	li	a0,1
      9c:	00006097          	auipc	ra,0x6
      a0:	804080e7          	jalr	-2044(ra) # 58a0 <exit>

00000000000000a4 <opentest>:
{
      a4:	1101                	addi	sp,sp,-32
      a6:	ec06                	sd	ra,24(sp)
      a8:	e822                	sd	s0,16(sp)
      aa:	e426                	sd	s1,8(sp)
      ac:	1000                	addi	s0,sp,32
      ae:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      b0:	4581                	li	a1,0
      b2:	00006517          	auipc	a0,0x6
      b6:	16e50513          	addi	a0,a0,366 # 6220 <malloc+0x530>
      ba:	00006097          	auipc	ra,0x6
      be:	826080e7          	jalr	-2010(ra) # 58e0 <open>
  if(fd < 0){
      c2:	02054663          	bltz	a0,ee <opentest+0x4a>
  close(fd);
      c6:	00006097          	auipc	ra,0x6
      ca:	802080e7          	jalr	-2046(ra) # 58c8 <close>
  fd = open("doesnotexist", 0);
      ce:	4581                	li	a1,0
      d0:	00006517          	auipc	a0,0x6
      d4:	17050513          	addi	a0,a0,368 # 6240 <malloc+0x550>
      d8:	00006097          	auipc	ra,0x6
      dc:	808080e7          	jalr	-2040(ra) # 58e0 <open>
  if(fd >= 0){
      e0:	02055563          	bgez	a0,10a <opentest+0x66>
}
      e4:	60e2                	ld	ra,24(sp)
      e6:	6442                	ld	s0,16(sp)
      e8:	64a2                	ld	s1,8(sp)
      ea:	6105                	addi	sp,sp,32
      ec:	8082                	ret
    printf("%s: open echo failed!\n", s);
      ee:	85a6                	mv	a1,s1
      f0:	00006517          	auipc	a0,0x6
      f4:	13850513          	addi	a0,a0,312 # 6228 <malloc+0x538>
      f8:	00006097          	auipc	ra,0x6
      fc:	b38080e7          	jalr	-1224(ra) # 5c30 <printf>
    exit(1);
     100:	4505                	li	a0,1
     102:	00005097          	auipc	ra,0x5
     106:	79e080e7          	jalr	1950(ra) # 58a0 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	14450513          	addi	a0,a0,324 # 6250 <malloc+0x560>
     114:	00006097          	auipc	ra,0x6
     118:	b1c080e7          	jalr	-1252(ra) # 5c30 <printf>
    exit(1);
     11c:	4505                	li	a0,1
     11e:	00005097          	auipc	ra,0x5
     122:	782080e7          	jalr	1922(ra) # 58a0 <exit>

0000000000000126 <truncate2>:
{
     126:	7179                	addi	sp,sp,-48
     128:	f406                	sd	ra,40(sp)
     12a:	f022                	sd	s0,32(sp)
     12c:	ec26                	sd	s1,24(sp)
     12e:	e84a                	sd	s2,16(sp)
     130:	e44e                	sd	s3,8(sp)
     132:	1800                	addi	s0,sp,48
     134:	89aa                	mv	s3,a0
  unlink("truncfile");
     136:	00006517          	auipc	a0,0x6
     13a:	14250513          	addi	a0,a0,322 # 6278 <malloc+0x588>
     13e:	00005097          	auipc	ra,0x5
     142:	7b2080e7          	jalr	1970(ra) # 58f0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     146:	60100593          	li	a1,1537
     14a:	00006517          	auipc	a0,0x6
     14e:	12e50513          	addi	a0,a0,302 # 6278 <malloc+0x588>
     152:	00005097          	auipc	ra,0x5
     156:	78e080e7          	jalr	1934(ra) # 58e0 <open>
     15a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     15c:	4611                	li	a2,4
     15e:	00006597          	auipc	a1,0x6
     162:	12a58593          	addi	a1,a1,298 # 6288 <malloc+0x598>
     166:	00005097          	auipc	ra,0x5
     16a:	75a080e7          	jalr	1882(ra) # 58c0 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     16e:	40100593          	li	a1,1025
     172:	00006517          	auipc	a0,0x6
     176:	10650513          	addi	a0,a0,262 # 6278 <malloc+0x588>
     17a:	00005097          	auipc	ra,0x5
     17e:	766080e7          	jalr	1894(ra) # 58e0 <open>
     182:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     184:	4605                	li	a2,1
     186:	00006597          	auipc	a1,0x6
     18a:	10a58593          	addi	a1,a1,266 # 6290 <malloc+0x5a0>
     18e:	8526                	mv	a0,s1
     190:	00005097          	auipc	ra,0x5
     194:	730080e7          	jalr	1840(ra) # 58c0 <write>
  if(n != -1){
     198:	57fd                	li	a5,-1
     19a:	02f51b63          	bne	a0,a5,1d0 <truncate2+0xaa>
  unlink("truncfile");
     19e:	00006517          	auipc	a0,0x6
     1a2:	0da50513          	addi	a0,a0,218 # 6278 <malloc+0x588>
     1a6:	00005097          	auipc	ra,0x5
     1aa:	74a080e7          	jalr	1866(ra) # 58f0 <unlink>
  close(fd1);
     1ae:	8526                	mv	a0,s1
     1b0:	00005097          	auipc	ra,0x5
     1b4:	718080e7          	jalr	1816(ra) # 58c8 <close>
  close(fd2);
     1b8:	854a                	mv	a0,s2
     1ba:	00005097          	auipc	ra,0x5
     1be:	70e080e7          	jalr	1806(ra) # 58c8 <close>
}
     1c2:	70a2                	ld	ra,40(sp)
     1c4:	7402                	ld	s0,32(sp)
     1c6:	64e2                	ld	s1,24(sp)
     1c8:	6942                	ld	s2,16(sp)
     1ca:	69a2                	ld	s3,8(sp)
     1cc:	6145                	addi	sp,sp,48
     1ce:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1d0:	862a                	mv	a2,a0
     1d2:	85ce                	mv	a1,s3
     1d4:	00006517          	auipc	a0,0x6
     1d8:	0c450513          	addi	a0,a0,196 # 6298 <malloc+0x5a8>
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a54080e7          	jalr	-1452(ra) # 5c30 <printf>
    exit(1);
     1e4:	4505                	li	a0,1
     1e6:	00005097          	auipc	ra,0x5
     1ea:	6ba080e7          	jalr	1722(ra) # 58a0 <exit>

00000000000001ee <createtest>:
{
     1ee:	7179                	addi	sp,sp,-48
     1f0:	f406                	sd	ra,40(sp)
     1f2:	f022                	sd	s0,32(sp)
     1f4:	ec26                	sd	s1,24(sp)
     1f6:	e84a                	sd	s2,16(sp)
     1f8:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1fa:	06100793          	li	a5,97
     1fe:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     202:	fc040d23          	sb	zero,-38(s0)
     206:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     20a:	06400913          	li	s2,100
    name[1] = '0' + i;
     20e:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     212:	20200593          	li	a1,514
     216:	fd840513          	addi	a0,s0,-40
     21a:	00005097          	auipc	ra,0x5
     21e:	6c6080e7          	jalr	1734(ra) # 58e0 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	6a6080e7          	jalr	1702(ra) # 58c8 <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	fd249fe3          	bne	s1,s2,20e <createtest+0x20>
  name[0] = 'a';
     234:	06100793          	li	a5,97
     238:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     23c:	fc040d23          	sb	zero,-38(s0)
     240:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     244:	06400913          	li	s2,100
    name[1] = '0' + i;
     248:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     24c:	fd840513          	addi	a0,s0,-40
     250:	00005097          	auipc	ra,0x5
     254:	6a0080e7          	jalr	1696(ra) # 58f0 <unlink>
  for(i = 0; i < N; i++){
     258:	2485                	addiw	s1,s1,1
     25a:	0ff4f493          	andi	s1,s1,255
     25e:	ff2495e3          	bne	s1,s2,248 <createtest+0x5a>
}
     262:	70a2                	ld	ra,40(sp)
     264:	7402                	ld	s0,32(sp)
     266:	64e2                	ld	s1,24(sp)
     268:	6942                	ld	s2,16(sp)
     26a:	6145                	addi	sp,sp,48
     26c:	8082                	ret

000000000000026e <bigwrite>:
{
     26e:	715d                	addi	sp,sp,-80
     270:	e486                	sd	ra,72(sp)
     272:	e0a2                	sd	s0,64(sp)
     274:	fc26                	sd	s1,56(sp)
     276:	f84a                	sd	s2,48(sp)
     278:	f44e                	sd	s3,40(sp)
     27a:	f052                	sd	s4,32(sp)
     27c:	ec56                	sd	s5,24(sp)
     27e:	e85a                	sd	s6,16(sp)
     280:	e45e                	sd	s7,8(sp)
     282:	0880                	addi	s0,sp,80
     284:	8baa                	mv	s7,a0
  unlink("bigwrite");
     286:	00006517          	auipc	a0,0x6
     28a:	03a50513          	addi	a0,a0,58 # 62c0 <malloc+0x5d0>
     28e:	00005097          	auipc	ra,0x5
     292:	662080e7          	jalr	1634(ra) # 58f0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     296:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     29a:	00006a17          	auipc	s4,0x6
     29e:	026a0a13          	addi	s4,s4,38 # 62c0 <malloc+0x5d0>
      int cc = write(fd, buf, sz);
     2a2:	0000c997          	auipc	s3,0xc
     2a6:	b5698993          	addi	s3,s3,-1194 # bdf8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2aa:	6b0d                	lui	s6,0x3
     2ac:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirtest+0x61>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b0:	20200593          	li	a1,514
     2b4:	8552                	mv	a0,s4
     2b6:	00005097          	auipc	ra,0x5
     2ba:	62a080e7          	jalr	1578(ra) # 58e0 <open>
     2be:	892a                	mv	s2,a0
    if(fd < 0){
     2c0:	04054d63          	bltz	a0,31a <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2c4:	8626                	mv	a2,s1
     2c6:	85ce                	mv	a1,s3
     2c8:	00005097          	auipc	ra,0x5
     2cc:	5f8080e7          	jalr	1528(ra) # 58c0 <write>
     2d0:	8aaa                	mv	s5,a0
      if(cc != sz){
     2d2:	06a49463          	bne	s1,a0,33a <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2d6:	8626                	mv	a2,s1
     2d8:	85ce                	mv	a1,s3
     2da:	854a                	mv	a0,s2
     2dc:	00005097          	auipc	ra,0x5
     2e0:	5e4080e7          	jalr	1508(ra) # 58c0 <write>
      if(cc != sz){
     2e4:	04951963          	bne	a0,s1,336 <bigwrite+0xc8>
    close(fd);
     2e8:	854a                	mv	a0,s2
     2ea:	00005097          	auipc	ra,0x5
     2ee:	5de080e7          	jalr	1502(ra) # 58c8 <close>
    unlink("bigwrite");
     2f2:	8552                	mv	a0,s4
     2f4:	00005097          	auipc	ra,0x5
     2f8:	5fc080e7          	jalr	1532(ra) # 58f0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2fc:	1d74849b          	addiw	s1,s1,471
     300:	fb6498e3          	bne	s1,s6,2b0 <bigwrite+0x42>
}
     304:	60a6                	ld	ra,72(sp)
     306:	6406                	ld	s0,64(sp)
     308:	74e2                	ld	s1,56(sp)
     30a:	7942                	ld	s2,48(sp)
     30c:	79a2                	ld	s3,40(sp)
     30e:	7a02                	ld	s4,32(sp)
     310:	6ae2                	ld	s5,24(sp)
     312:	6b42                	ld	s6,16(sp)
     314:	6ba2                	ld	s7,8(sp)
     316:	6161                	addi	sp,sp,80
     318:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     31a:	85de                	mv	a1,s7
     31c:	00006517          	auipc	a0,0x6
     320:	fb450513          	addi	a0,a0,-76 # 62d0 <malloc+0x5e0>
     324:	00006097          	auipc	ra,0x6
     328:	90c080e7          	jalr	-1780(ra) # 5c30 <printf>
      exit(1);
     32c:	4505                	li	a0,1
     32e:	00005097          	auipc	ra,0x5
     332:	572080e7          	jalr	1394(ra) # 58a0 <exit>
     336:	84d6                	mv	s1,s5
      int cc = write(fd, buf, sz);
     338:	8aaa                	mv	s5,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     33a:	86d6                	mv	a3,s5
     33c:	8626                	mv	a2,s1
     33e:	85de                	mv	a1,s7
     340:	00006517          	auipc	a0,0x6
     344:	fb050513          	addi	a0,a0,-80 # 62f0 <malloc+0x600>
     348:	00006097          	auipc	ra,0x6
     34c:	8e8080e7          	jalr	-1816(ra) # 5c30 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	00005097          	auipc	ra,0x5
     356:	54e080e7          	jalr	1358(ra) # 58a0 <exit>

000000000000035a <copyin>:
{
     35a:	711d                	addi	sp,sp,-96
     35c:	ec86                	sd	ra,88(sp)
     35e:	e8a2                	sd	s0,80(sp)
     360:	e4a6                	sd	s1,72(sp)
     362:	e0ca                	sd	s2,64(sp)
     364:	fc4e                	sd	s3,56(sp)
     366:	f852                	sd	s4,48(sp)
     368:	f456                	sd	s5,40(sp)
     36a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     36c:	4785                	li	a5,1
     36e:	07fe                	slli	a5,a5,0x1f
     370:	faf43823          	sd	a5,-80(s0)
     374:	57fd                	li	a5,-1
     376:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     37a:	fb040493          	addi	s1,s0,-80
     37e:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     382:	00006a17          	auipc	s4,0x6
     386:	f86a0a13          	addi	s4,s4,-122 # 6308 <malloc+0x618>
    uint64 addr = addrs[ai];
     38a:	0004b903          	ld	s2,0(s1)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     38e:	20100593          	li	a1,513
     392:	8552                	mv	a0,s4
     394:	00005097          	auipc	ra,0x5
     398:	54c080e7          	jalr	1356(ra) # 58e0 <open>
     39c:	89aa                	mv	s3,a0
    if(fd < 0){
     39e:	08054763          	bltz	a0,42c <copyin+0xd2>
    int n = write(fd, (void*)addr, 8192);
     3a2:	6609                	lui	a2,0x2
     3a4:	85ca                	mv	a1,s2
     3a6:	00005097          	auipc	ra,0x5
     3aa:	51a080e7          	jalr	1306(ra) # 58c0 <write>
    if(n >= 0){
     3ae:	08055c63          	bgez	a0,446 <copyin+0xec>
    close(fd);
     3b2:	854e                	mv	a0,s3
     3b4:	00005097          	auipc	ra,0x5
     3b8:	514080e7          	jalr	1300(ra) # 58c8 <close>
    unlink("copyin1");
     3bc:	8552                	mv	a0,s4
     3be:	00005097          	auipc	ra,0x5
     3c2:	532080e7          	jalr	1330(ra) # 58f0 <unlink>
    n = write(1, (char*)addr, 8192);
     3c6:	6609                	lui	a2,0x2
     3c8:	85ca                	mv	a1,s2
     3ca:	4505                	li	a0,1
     3cc:	00005097          	auipc	ra,0x5
     3d0:	4f4080e7          	jalr	1268(ra) # 58c0 <write>
    if(n > 0){
     3d4:	08a04863          	bgtz	a0,464 <copyin+0x10a>
    if(pipe(fds) < 0){
     3d8:	fa840513          	addi	a0,s0,-88
     3dc:	00005097          	auipc	ra,0x5
     3e0:	4d4080e7          	jalr	1236(ra) # 58b0 <pipe>
     3e4:	08054f63          	bltz	a0,482 <copyin+0x128>
    n = write(fds[1], (char*)addr, 8192);
     3e8:	6609                	lui	a2,0x2
     3ea:	85ca                	mv	a1,s2
     3ec:	fac42503          	lw	a0,-84(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	4d0080e7          	jalr	1232(ra) # 58c0 <write>
    if(n > 0){
     3f8:	0aa04263          	bgtz	a0,49c <copyin+0x142>
    close(fds[0]);
     3fc:	fa842503          	lw	a0,-88(s0)
     400:	00005097          	auipc	ra,0x5
     404:	4c8080e7          	jalr	1224(ra) # 58c8 <close>
    close(fds[1]);
     408:	fac42503          	lw	a0,-84(s0)
     40c:	00005097          	auipc	ra,0x5
     410:	4bc080e7          	jalr	1212(ra) # 58c8 <close>
  for(int ai = 0; ai < 2; ai++){
     414:	04a1                	addi	s1,s1,8
     416:	f7549ae3          	bne	s1,s5,38a <copyin+0x30>
}
     41a:	60e6                	ld	ra,88(sp)
     41c:	6446                	ld	s0,80(sp)
     41e:	64a6                	ld	s1,72(sp)
     420:	6906                	ld	s2,64(sp)
     422:	79e2                	ld	s3,56(sp)
     424:	7a42                	ld	s4,48(sp)
     426:	7aa2                	ld	s5,40(sp)
     428:	6125                	addi	sp,sp,96
     42a:	8082                	ret
      printf("open(copyin1) failed\n");
     42c:	00006517          	auipc	a0,0x6
     430:	ee450513          	addi	a0,a0,-284 # 6310 <malloc+0x620>
     434:	00005097          	auipc	ra,0x5
     438:	7fc080e7          	jalr	2044(ra) # 5c30 <printf>
      exit(1);
     43c:	4505                	li	a0,1
     43e:	00005097          	auipc	ra,0x5
     442:	462080e7          	jalr	1122(ra) # 58a0 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     446:	862a                	mv	a2,a0
     448:	85ca                	mv	a1,s2
     44a:	00006517          	auipc	a0,0x6
     44e:	ede50513          	addi	a0,a0,-290 # 6328 <malloc+0x638>
     452:	00005097          	auipc	ra,0x5
     456:	7de080e7          	jalr	2014(ra) # 5c30 <printf>
      exit(1);
     45a:	4505                	li	a0,1
     45c:	00005097          	auipc	ra,0x5
     460:	444080e7          	jalr	1092(ra) # 58a0 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     464:	862a                	mv	a2,a0
     466:	85ca                	mv	a1,s2
     468:	00006517          	auipc	a0,0x6
     46c:	ef050513          	addi	a0,a0,-272 # 6358 <malloc+0x668>
     470:	00005097          	auipc	ra,0x5
     474:	7c0080e7          	jalr	1984(ra) # 5c30 <printf>
      exit(1);
     478:	4505                	li	a0,1
     47a:	00005097          	auipc	ra,0x5
     47e:	426080e7          	jalr	1062(ra) # 58a0 <exit>
      printf("pipe() failed\n");
     482:	00006517          	auipc	a0,0x6
     486:	f0650513          	addi	a0,a0,-250 # 6388 <malloc+0x698>
     48a:	00005097          	auipc	ra,0x5
     48e:	7a6080e7          	jalr	1958(ra) # 5c30 <printf>
      exit(1);
     492:	4505                	li	a0,1
     494:	00005097          	auipc	ra,0x5
     498:	40c080e7          	jalr	1036(ra) # 58a0 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     49c:	862a                	mv	a2,a0
     49e:	85ca                	mv	a1,s2
     4a0:	00006517          	auipc	a0,0x6
     4a4:	ef850513          	addi	a0,a0,-264 # 6398 <malloc+0x6a8>
     4a8:	00005097          	auipc	ra,0x5
     4ac:	788080e7          	jalr	1928(ra) # 5c30 <printf>
      exit(1);
     4b0:	4505                	li	a0,1
     4b2:	00005097          	auipc	ra,0x5
     4b6:	3ee080e7          	jalr	1006(ra) # 58a0 <exit>

00000000000004ba <copyout>:
{
     4ba:	711d                	addi	sp,sp,-96
     4bc:	ec86                	sd	ra,88(sp)
     4be:	e8a2                	sd	s0,80(sp)
     4c0:	e4a6                	sd	s1,72(sp)
     4c2:	e0ca                	sd	s2,64(sp)
     4c4:	fc4e                	sd	s3,56(sp)
     4c6:	f852                	sd	s4,48(sp)
     4c8:	f456                	sd	s5,40(sp)
     4ca:	f05a                	sd	s6,32(sp)
     4cc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4ce:	4785                	li	a5,1
     4d0:	07fe                	slli	a5,a5,0x1f
     4d2:	faf43823          	sd	a5,-80(s0)
     4d6:	57fd                	li	a5,-1
     4d8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4dc:	fb040493          	addi	s1,s0,-80
     4e0:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     4e4:	00006a17          	auipc	s4,0x6
     4e8:	ee4a0a13          	addi	s4,s4,-284 # 63c8 <malloc+0x6d8>
    n = write(fds[1], "x", 1);
     4ec:	00006a97          	auipc	s5,0x6
     4f0:	da4a8a93          	addi	s5,s5,-604 # 6290 <malloc+0x5a0>
    uint64 addr = addrs[ai];
     4f4:	0004b983          	ld	s3,0(s1)
    int fd = open("README", 0);
     4f8:	4581                	li	a1,0
     4fa:	8552                	mv	a0,s4
     4fc:	00005097          	auipc	ra,0x5
     500:	3e4080e7          	jalr	996(ra) # 58e0 <open>
     504:	892a                	mv	s2,a0
    if(fd < 0){
     506:	08054563          	bltz	a0,590 <copyout+0xd6>
    int n = read(fd, (void*)addr, 8192);
     50a:	6609                	lui	a2,0x2
     50c:	85ce                	mv	a1,s3
     50e:	00005097          	auipc	ra,0x5
     512:	3aa080e7          	jalr	938(ra) # 58b8 <read>
    if(n > 0){
     516:	08a04a63          	bgtz	a0,5aa <copyout+0xf0>
    close(fd);
     51a:	854a                	mv	a0,s2
     51c:	00005097          	auipc	ra,0x5
     520:	3ac080e7          	jalr	940(ra) # 58c8 <close>
    if(pipe(fds) < 0){
     524:	fa840513          	addi	a0,s0,-88
     528:	00005097          	auipc	ra,0x5
     52c:	388080e7          	jalr	904(ra) # 58b0 <pipe>
     530:	08054c63          	bltz	a0,5c8 <copyout+0x10e>
    n = write(fds[1], "x", 1);
     534:	4605                	li	a2,1
     536:	85d6                	mv	a1,s5
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	384080e7          	jalr	900(ra) # 58c0 <write>
    if(n != 1){
     544:	4785                	li	a5,1
     546:	08f51e63          	bne	a0,a5,5e2 <copyout+0x128>
    n = read(fds[0], (void*)addr, 8192);
     54a:	6609                	lui	a2,0x2
     54c:	85ce                	mv	a1,s3
     54e:	fa842503          	lw	a0,-88(s0)
     552:	00005097          	auipc	ra,0x5
     556:	366080e7          	jalr	870(ra) # 58b8 <read>
    if(n > 0){
     55a:	0aa04163          	bgtz	a0,5fc <copyout+0x142>
    close(fds[0]);
     55e:	fa842503          	lw	a0,-88(s0)
     562:	00005097          	auipc	ra,0x5
     566:	366080e7          	jalr	870(ra) # 58c8 <close>
    close(fds[1]);
     56a:	fac42503          	lw	a0,-84(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	35a080e7          	jalr	858(ra) # 58c8 <close>
  for(int ai = 0; ai < 2; ai++){
     576:	04a1                	addi	s1,s1,8
     578:	f7649ee3          	bne	s1,s6,4f4 <copyout+0x3a>
}
     57c:	60e6                	ld	ra,88(sp)
     57e:	6446                	ld	s0,80(sp)
     580:	64a6                	ld	s1,72(sp)
     582:	6906                	ld	s2,64(sp)
     584:	79e2                	ld	s3,56(sp)
     586:	7a42                	ld	s4,48(sp)
     588:	7aa2                	ld	s5,40(sp)
     58a:	7b02                	ld	s6,32(sp)
     58c:	6125                	addi	sp,sp,96
     58e:	8082                	ret
      printf("open(README) failed\n");
     590:	00006517          	auipc	a0,0x6
     594:	e4050513          	addi	a0,a0,-448 # 63d0 <malloc+0x6e0>
     598:	00005097          	auipc	ra,0x5
     59c:	698080e7          	jalr	1688(ra) # 5c30 <printf>
      exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00005097          	auipc	ra,0x5
     5a6:	2fe080e7          	jalr	766(ra) # 58a0 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5aa:	862a                	mv	a2,a0
     5ac:	85ce                	mv	a1,s3
     5ae:	00006517          	auipc	a0,0x6
     5b2:	e3a50513          	addi	a0,a0,-454 # 63e8 <malloc+0x6f8>
     5b6:	00005097          	auipc	ra,0x5
     5ba:	67a080e7          	jalr	1658(ra) # 5c30 <printf>
      exit(1);
     5be:	4505                	li	a0,1
     5c0:	00005097          	auipc	ra,0x5
     5c4:	2e0080e7          	jalr	736(ra) # 58a0 <exit>
      printf("pipe() failed\n");
     5c8:	00006517          	auipc	a0,0x6
     5cc:	dc050513          	addi	a0,a0,-576 # 6388 <malloc+0x698>
     5d0:	00005097          	auipc	ra,0x5
     5d4:	660080e7          	jalr	1632(ra) # 5c30 <printf>
      exit(1);
     5d8:	4505                	li	a0,1
     5da:	00005097          	auipc	ra,0x5
     5de:	2c6080e7          	jalr	710(ra) # 58a0 <exit>
      printf("pipe write failed\n");
     5e2:	00006517          	auipc	a0,0x6
     5e6:	e3650513          	addi	a0,a0,-458 # 6418 <malloc+0x728>
     5ea:	00005097          	auipc	ra,0x5
     5ee:	646080e7          	jalr	1606(ra) # 5c30 <printf>
      exit(1);
     5f2:	4505                	li	a0,1
     5f4:	00005097          	auipc	ra,0x5
     5f8:	2ac080e7          	jalr	684(ra) # 58a0 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fc:	862a                	mv	a2,a0
     5fe:	85ce                	mv	a1,s3
     600:	00006517          	auipc	a0,0x6
     604:	e3050513          	addi	a0,a0,-464 # 6430 <malloc+0x740>
     608:	00005097          	auipc	ra,0x5
     60c:	628080e7          	jalr	1576(ra) # 5c30 <printf>
      exit(1);
     610:	4505                	li	a0,1
     612:	00005097          	auipc	ra,0x5
     616:	28e080e7          	jalr	654(ra) # 58a0 <exit>

000000000000061a <truncate1>:
{
     61a:	711d                	addi	sp,sp,-96
     61c:	ec86                	sd	ra,88(sp)
     61e:	e8a2                	sd	s0,80(sp)
     620:	e4a6                	sd	s1,72(sp)
     622:	e0ca                	sd	s2,64(sp)
     624:	fc4e                	sd	s3,56(sp)
     626:	f852                	sd	s4,48(sp)
     628:	f456                	sd	s5,40(sp)
     62a:	1080                	addi	s0,sp,96
     62c:	8aaa                	mv	s5,a0
  unlink("truncfile");
     62e:	00006517          	auipc	a0,0x6
     632:	c4a50513          	addi	a0,a0,-950 # 6278 <malloc+0x588>
     636:	00005097          	auipc	ra,0x5
     63a:	2ba080e7          	jalr	698(ra) # 58f0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     63e:	60100593          	li	a1,1537
     642:	00006517          	auipc	a0,0x6
     646:	c3650513          	addi	a0,a0,-970 # 6278 <malloc+0x588>
     64a:	00005097          	auipc	ra,0x5
     64e:	296080e7          	jalr	662(ra) # 58e0 <open>
     652:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     654:	4611                	li	a2,4
     656:	00006597          	auipc	a1,0x6
     65a:	c3258593          	addi	a1,a1,-974 # 6288 <malloc+0x598>
     65e:	00005097          	auipc	ra,0x5
     662:	262080e7          	jalr	610(ra) # 58c0 <write>
  close(fd1);
     666:	8526                	mv	a0,s1
     668:	00005097          	auipc	ra,0x5
     66c:	260080e7          	jalr	608(ra) # 58c8 <close>
  int fd2 = open("truncfile", O_RDONLY);
     670:	4581                	li	a1,0
     672:	00006517          	auipc	a0,0x6
     676:	c0650513          	addi	a0,a0,-1018 # 6278 <malloc+0x588>
     67a:	00005097          	auipc	ra,0x5
     67e:	266080e7          	jalr	614(ra) # 58e0 <open>
     682:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     684:	02000613          	li	a2,32
     688:	fa040593          	addi	a1,s0,-96
     68c:	00005097          	auipc	ra,0x5
     690:	22c080e7          	jalr	556(ra) # 58b8 <read>
  if(n != 4){
     694:	4791                	li	a5,4
     696:	0cf51e63          	bne	a0,a5,772 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69a:	40100593          	li	a1,1025
     69e:	00006517          	auipc	a0,0x6
     6a2:	bda50513          	addi	a0,a0,-1062 # 6278 <malloc+0x588>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	23a080e7          	jalr	570(ra) # 58e0 <open>
     6ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b0:	4581                	li	a1,0
     6b2:	00006517          	auipc	a0,0x6
     6b6:	bc650513          	addi	a0,a0,-1082 # 6278 <malloc+0x588>
     6ba:	00005097          	auipc	ra,0x5
     6be:	226080e7          	jalr	550(ra) # 58e0 <open>
     6c2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	00005097          	auipc	ra,0x5
     6d0:	1ec080e7          	jalr	492(ra) # 58b8 <read>
     6d4:	8a2a                	mv	s4,a0
  if(n != 0){
     6d6:	ed4d                	bnez	a0,790 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6d8:	02000613          	li	a2,32
     6dc:	fa040593          	addi	a1,s0,-96
     6e0:	8526                	mv	a0,s1
     6e2:	00005097          	auipc	ra,0x5
     6e6:	1d6080e7          	jalr	470(ra) # 58b8 <read>
     6ea:	8a2a                	mv	s4,a0
  if(n != 0){
     6ec:	e971                	bnez	a0,7c0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6ee:	4619                	li	a2,6
     6f0:	00006597          	auipc	a1,0x6
     6f4:	dd058593          	addi	a1,a1,-560 # 64c0 <malloc+0x7d0>
     6f8:	854e                	mv	a0,s3
     6fa:	00005097          	auipc	ra,0x5
     6fe:	1c6080e7          	jalr	454(ra) # 58c0 <write>
  n = read(fd3, buf, sizeof(buf));
     702:	02000613          	li	a2,32
     706:	fa040593          	addi	a1,s0,-96
     70a:	854a                	mv	a0,s2
     70c:	00005097          	auipc	ra,0x5
     710:	1ac080e7          	jalr	428(ra) # 58b8 <read>
  if(n != 6){
     714:	4799                	li	a5,6
     716:	0cf51d63          	bne	a0,a5,7f0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71a:	02000613          	li	a2,32
     71e:	fa040593          	addi	a1,s0,-96
     722:	8526                	mv	a0,s1
     724:	00005097          	auipc	ra,0x5
     728:	194080e7          	jalr	404(ra) # 58b8 <read>
  if(n != 2){
     72c:	4789                	li	a5,2
     72e:	0ef51063          	bne	a0,a5,80e <truncate1+0x1f4>
  unlink("truncfile");
     732:	00006517          	auipc	a0,0x6
     736:	b4650513          	addi	a0,a0,-1210 # 6278 <malloc+0x588>
     73a:	00005097          	auipc	ra,0x5
     73e:	1b6080e7          	jalr	438(ra) # 58f0 <unlink>
  close(fd1);
     742:	854e                	mv	a0,s3
     744:	00005097          	auipc	ra,0x5
     748:	184080e7          	jalr	388(ra) # 58c8 <close>
  close(fd2);
     74c:	8526                	mv	a0,s1
     74e:	00005097          	auipc	ra,0x5
     752:	17a080e7          	jalr	378(ra) # 58c8 <close>
  close(fd3);
     756:	854a                	mv	a0,s2
     758:	00005097          	auipc	ra,0x5
     75c:	170080e7          	jalr	368(ra) # 58c8 <close>
}
     760:	60e6                	ld	ra,88(sp)
     762:	6446                	ld	s0,80(sp)
     764:	64a6                	ld	s1,72(sp)
     766:	6906                	ld	s2,64(sp)
     768:	79e2                	ld	s3,56(sp)
     76a:	7a42                	ld	s4,48(sp)
     76c:	7aa2                	ld	s5,40(sp)
     76e:	6125                	addi	sp,sp,96
     770:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     772:	862a                	mv	a2,a0
     774:	85d6                	mv	a1,s5
     776:	00006517          	auipc	a0,0x6
     77a:	cea50513          	addi	a0,a0,-790 # 6460 <malloc+0x770>
     77e:	00005097          	auipc	ra,0x5
     782:	4b2080e7          	jalr	1202(ra) # 5c30 <printf>
    exit(1);
     786:	4505                	li	a0,1
     788:	00005097          	auipc	ra,0x5
     78c:	118080e7          	jalr	280(ra) # 58a0 <exit>
    printf("aaa fd3=%d\n", fd3);
     790:	85ca                	mv	a1,s2
     792:	00006517          	auipc	a0,0x6
     796:	cee50513          	addi	a0,a0,-786 # 6480 <malloc+0x790>
     79a:	00005097          	auipc	ra,0x5
     79e:	496080e7          	jalr	1174(ra) # 5c30 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a2:	8652                	mv	a2,s4
     7a4:	85d6                	mv	a1,s5
     7a6:	00006517          	auipc	a0,0x6
     7aa:	cea50513          	addi	a0,a0,-790 # 6490 <malloc+0x7a0>
     7ae:	00005097          	auipc	ra,0x5
     7b2:	482080e7          	jalr	1154(ra) # 5c30 <printf>
    exit(1);
     7b6:	4505                	li	a0,1
     7b8:	00005097          	auipc	ra,0x5
     7bc:	0e8080e7          	jalr	232(ra) # 58a0 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c0:	85a6                	mv	a1,s1
     7c2:	00006517          	auipc	a0,0x6
     7c6:	cee50513          	addi	a0,a0,-786 # 64b0 <malloc+0x7c0>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	466080e7          	jalr	1126(ra) # 5c30 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d2:	8652                	mv	a2,s4
     7d4:	85d6                	mv	a1,s5
     7d6:	00006517          	auipc	a0,0x6
     7da:	cba50513          	addi	a0,a0,-838 # 6490 <malloc+0x7a0>
     7de:	00005097          	auipc	ra,0x5
     7e2:	452080e7          	jalr	1106(ra) # 5c30 <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	0b8080e7          	jalr	184(ra) # 58a0 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f0:	862a                	mv	a2,a0
     7f2:	85d6                	mv	a1,s5
     7f4:	00006517          	auipc	a0,0x6
     7f8:	cd450513          	addi	a0,a0,-812 # 64c8 <malloc+0x7d8>
     7fc:	00005097          	auipc	ra,0x5
     800:	434080e7          	jalr	1076(ra) # 5c30 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	00005097          	auipc	ra,0x5
     80a:	09a080e7          	jalr	154(ra) # 58a0 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     80e:	862a                	mv	a2,a0
     810:	85d6                	mv	a1,s5
     812:	00006517          	auipc	a0,0x6
     816:	cd650513          	addi	a0,a0,-810 # 64e8 <malloc+0x7f8>
     81a:	00005097          	auipc	ra,0x5
     81e:	416080e7          	jalr	1046(ra) # 5c30 <printf>
    exit(1);
     822:	4505                	li	a0,1
     824:	00005097          	auipc	ra,0x5
     828:	07c080e7          	jalr	124(ra) # 58a0 <exit>

000000000000082c <writetest>:
{
     82c:	7139                	addi	sp,sp,-64
     82e:	fc06                	sd	ra,56(sp)
     830:	f822                	sd	s0,48(sp)
     832:	f426                	sd	s1,40(sp)
     834:	f04a                	sd	s2,32(sp)
     836:	ec4e                	sd	s3,24(sp)
     838:	e852                	sd	s4,16(sp)
     83a:	e456                	sd	s5,8(sp)
     83c:	e05a                	sd	s6,0(sp)
     83e:	0080                	addi	s0,sp,64
     840:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     842:	20200593          	li	a1,514
     846:	00006517          	auipc	a0,0x6
     84a:	cc250513          	addi	a0,a0,-830 # 6508 <malloc+0x818>
     84e:	00005097          	auipc	ra,0x5
     852:	092080e7          	jalr	146(ra) # 58e0 <open>
  if(fd < 0){
     856:	0a054d63          	bltz	a0,910 <writetest+0xe4>
     85a:	892a                	mv	s2,a0
     85c:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	00006997          	auipc	s3,0x6
     862:	cd298993          	addi	s3,s3,-814 # 6530 <malloc+0x840>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     866:	00006a97          	auipc	s5,0x6
     86a:	d02a8a93          	addi	s5,s5,-766 # 6568 <malloc+0x878>
  for(i = 0; i < N; i++){
     86e:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	048080e7          	jalr	72(ra) # 58c0 <write>
     880:	47a9                	li	a5,10
     882:	0af51563          	bne	a0,a5,92c <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     886:	4629                	li	a2,10
     888:	85d6                	mv	a1,s5
     88a:	854a                	mv	a0,s2
     88c:	00005097          	auipc	ra,0x5
     890:	034080e7          	jalr	52(ra) # 58c0 <write>
     894:	47a9                	li	a5,10
     896:	0af51a63          	bne	a0,a5,94a <writetest+0x11e>
  for(i = 0; i < N; i++){
     89a:	2485                	addiw	s1,s1,1
     89c:	fd449be3          	bne	s1,s4,872 <writetest+0x46>
  close(fd);
     8a0:	854a                	mv	a0,s2
     8a2:	00005097          	auipc	ra,0x5
     8a6:	026080e7          	jalr	38(ra) # 58c8 <close>
  fd = open("small", O_RDONLY);
     8aa:	4581                	li	a1,0
     8ac:	00006517          	auipc	a0,0x6
     8b0:	c5c50513          	addi	a0,a0,-932 # 6508 <malloc+0x818>
     8b4:	00005097          	auipc	ra,0x5
     8b8:	02c080e7          	jalr	44(ra) # 58e0 <open>
     8bc:	84aa                	mv	s1,a0
  if(fd < 0){
     8be:	0a054563          	bltz	a0,968 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8c2:	7d000613          	li	a2,2000
     8c6:	0000b597          	auipc	a1,0xb
     8ca:	53258593          	addi	a1,a1,1330 # bdf8 <buf>
     8ce:	00005097          	auipc	ra,0x5
     8d2:	fea080e7          	jalr	-22(ra) # 58b8 <read>
  if(i != N*SZ*2){
     8d6:	7d000793          	li	a5,2000
     8da:	0af51563          	bne	a0,a5,984 <writetest+0x158>
  close(fd);
     8de:	8526                	mv	a0,s1
     8e0:	00005097          	auipc	ra,0x5
     8e4:	fe8080e7          	jalr	-24(ra) # 58c8 <close>
  if(unlink("small") < 0){
     8e8:	00006517          	auipc	a0,0x6
     8ec:	c2050513          	addi	a0,a0,-992 # 6508 <malloc+0x818>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	000080e7          	jalr	ra # 58f0 <unlink>
     8f8:	0a054463          	bltz	a0,9a0 <writetest+0x174>
}
     8fc:	70e2                	ld	ra,56(sp)
     8fe:	7442                	ld	s0,48(sp)
     900:	74a2                	ld	s1,40(sp)
     902:	7902                	ld	s2,32(sp)
     904:	69e2                	ld	s3,24(sp)
     906:	6a42                	ld	s4,16(sp)
     908:	6aa2                	ld	s5,8(sp)
     90a:	6b02                	ld	s6,0(sp)
     90c:	6121                	addi	sp,sp,64
     90e:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     910:	85da                	mv	a1,s6
     912:	00006517          	auipc	a0,0x6
     916:	bfe50513          	addi	a0,a0,-1026 # 6510 <malloc+0x820>
     91a:	00005097          	auipc	ra,0x5
     91e:	316080e7          	jalr	790(ra) # 5c30 <printf>
    exit(1);
     922:	4505                	li	a0,1
     924:	00005097          	auipc	ra,0x5
     928:	f7c080e7          	jalr	-132(ra) # 58a0 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     92c:	8626                	mv	a2,s1
     92e:	85da                	mv	a1,s6
     930:	00006517          	auipc	a0,0x6
     934:	c1050513          	addi	a0,a0,-1008 # 6540 <malloc+0x850>
     938:	00005097          	auipc	ra,0x5
     93c:	2f8080e7          	jalr	760(ra) # 5c30 <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	f5e080e7          	jalr	-162(ra) # 58a0 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     94a:	8626                	mv	a2,s1
     94c:	85da                	mv	a1,s6
     94e:	00006517          	auipc	a0,0x6
     952:	c2a50513          	addi	a0,a0,-982 # 6578 <malloc+0x888>
     956:	00005097          	auipc	ra,0x5
     95a:	2da080e7          	jalr	730(ra) # 5c30 <printf>
      exit(1);
     95e:	4505                	li	a0,1
     960:	00005097          	auipc	ra,0x5
     964:	f40080e7          	jalr	-192(ra) # 58a0 <exit>
    printf("%s: error: open small failed!\n", s);
     968:	85da                	mv	a1,s6
     96a:	00006517          	auipc	a0,0x6
     96e:	c3650513          	addi	a0,a0,-970 # 65a0 <malloc+0x8b0>
     972:	00005097          	auipc	ra,0x5
     976:	2be080e7          	jalr	702(ra) # 5c30 <printf>
    exit(1);
     97a:	4505                	li	a0,1
     97c:	00005097          	auipc	ra,0x5
     980:	f24080e7          	jalr	-220(ra) # 58a0 <exit>
    printf("%s: read failed\n", s);
     984:	85da                	mv	a1,s6
     986:	00006517          	auipc	a0,0x6
     98a:	c3a50513          	addi	a0,a0,-966 # 65c0 <malloc+0x8d0>
     98e:	00005097          	auipc	ra,0x5
     992:	2a2080e7          	jalr	674(ra) # 5c30 <printf>
    exit(1);
     996:	4505                	li	a0,1
     998:	00005097          	auipc	ra,0x5
     99c:	f08080e7          	jalr	-248(ra) # 58a0 <exit>
    printf("%s: unlink small failed\n", s);
     9a0:	85da                	mv	a1,s6
     9a2:	00006517          	auipc	a0,0x6
     9a6:	c3650513          	addi	a0,a0,-970 # 65d8 <malloc+0x8e8>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	286080e7          	jalr	646(ra) # 5c30 <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	eec080e7          	jalr	-276(ra) # 58a0 <exit>

00000000000009bc <writebig>:
{
     9bc:	7139                	addi	sp,sp,-64
     9be:	fc06                	sd	ra,56(sp)
     9c0:	f822                	sd	s0,48(sp)
     9c2:	f426                	sd	s1,40(sp)
     9c4:	f04a                	sd	s2,32(sp)
     9c6:	ec4e                	sd	s3,24(sp)
     9c8:	e852                	sd	s4,16(sp)
     9ca:	e456                	sd	s5,8(sp)
     9cc:	0080                	addi	s0,sp,64
     9ce:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d0:	20200593          	li	a1,514
     9d4:	00006517          	auipc	a0,0x6
     9d8:	c2450513          	addi	a0,a0,-988 # 65f8 <malloc+0x908>
     9dc:	00005097          	auipc	ra,0x5
     9e0:	f04080e7          	jalr	-252(ra) # 58e0 <open>
     9e4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e8:	0000b917          	auipc	s2,0xb
     9ec:	41090913          	addi	s2,s2,1040 # bdf8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f0:	10c00a13          	li	s4,268
  if(fd < 0){
     9f4:	06054c63          	bltz	a0,a6c <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fc:	40000613          	li	a2,1024
     a00:	85ca                	mv	a1,s2
     a02:	854e                	mv	a0,s3
     a04:	00005097          	auipc	ra,0x5
     a08:	ebc080e7          	jalr	-324(ra) # 58c0 <write>
     a0c:	40000793          	li	a5,1024
     a10:	06f51c63          	bne	a0,a5,a88 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a14:	2485                	addiw	s1,s1,1
     a16:	ff4491e3          	bne	s1,s4,9f8 <writebig+0x3c>
  close(fd);
     a1a:	854e                	mv	a0,s3
     a1c:	00005097          	auipc	ra,0x5
     a20:	eac080e7          	jalr	-340(ra) # 58c8 <close>
  fd = open("big", O_RDONLY);
     a24:	4581                	li	a1,0
     a26:	00006517          	auipc	a0,0x6
     a2a:	bd250513          	addi	a0,a0,-1070 # 65f8 <malloc+0x908>
     a2e:	00005097          	auipc	ra,0x5
     a32:	eb2080e7          	jalr	-334(ra) # 58e0 <open>
     a36:	89aa                	mv	s3,a0
  n = 0;
     a38:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a3a:	0000b917          	auipc	s2,0xb
     a3e:	3be90913          	addi	s2,s2,958 # bdf8 <buf>
  if(fd < 0){
     a42:	06054263          	bltz	a0,aa6 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a46:	40000613          	li	a2,1024
     a4a:	85ca                	mv	a1,s2
     a4c:	854e                	mv	a0,s3
     a4e:	00005097          	auipc	ra,0x5
     a52:	e6a080e7          	jalr	-406(ra) # 58b8 <read>
    if(i == 0){
     a56:	c535                	beqz	a0,ac2 <writebig+0x106>
    } else if(i != BSIZE){
     a58:	40000793          	li	a5,1024
     a5c:	0af51f63          	bne	a0,a5,b1a <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a60:	00092683          	lw	a3,0(s2)
     a64:	0c969a63          	bne	a3,s1,b38 <writebig+0x17c>
    n++;
     a68:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a6a:	bff1                	j	a46 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a6c:	85d6                	mv	a1,s5
     a6e:	00006517          	auipc	a0,0x6
     a72:	b9250513          	addi	a0,a0,-1134 # 6600 <malloc+0x910>
     a76:	00005097          	auipc	ra,0x5
     a7a:	1ba080e7          	jalr	442(ra) # 5c30 <printf>
    exit(1);
     a7e:	4505                	li	a0,1
     a80:	00005097          	auipc	ra,0x5
     a84:	e20080e7          	jalr	-480(ra) # 58a0 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a88:	8626                	mv	a2,s1
     a8a:	85d6                	mv	a1,s5
     a8c:	00006517          	auipc	a0,0x6
     a90:	b9450513          	addi	a0,a0,-1132 # 6620 <malloc+0x930>
     a94:	00005097          	auipc	ra,0x5
     a98:	19c080e7          	jalr	412(ra) # 5c30 <printf>
      exit(1);
     a9c:	4505                	li	a0,1
     a9e:	00005097          	auipc	ra,0x5
     aa2:	e02080e7          	jalr	-510(ra) # 58a0 <exit>
    printf("%s: error: open big failed!\n", s);
     aa6:	85d6                	mv	a1,s5
     aa8:	00006517          	auipc	a0,0x6
     aac:	ba050513          	addi	a0,a0,-1120 # 6648 <malloc+0x958>
     ab0:	00005097          	auipc	ra,0x5
     ab4:	180080e7          	jalr	384(ra) # 5c30 <printf>
    exit(1);
     ab8:	4505                	li	a0,1
     aba:	00005097          	auipc	ra,0x5
     abe:	de6080e7          	jalr	-538(ra) # 58a0 <exit>
      if(n == MAXFILE - 1){
     ac2:	10b00793          	li	a5,267
     ac6:	02f48a63          	beq	s1,a5,afa <writebig+0x13e>
  close(fd);
     aca:	854e                	mv	a0,s3
     acc:	00005097          	auipc	ra,0x5
     ad0:	dfc080e7          	jalr	-516(ra) # 58c8 <close>
  if(unlink("big") < 0){
     ad4:	00006517          	auipc	a0,0x6
     ad8:	b2450513          	addi	a0,a0,-1244 # 65f8 <malloc+0x908>
     adc:	00005097          	auipc	ra,0x5
     ae0:	e14080e7          	jalr	-492(ra) # 58f0 <unlink>
     ae4:	06054963          	bltz	a0,b56 <writebig+0x19a>
}
     ae8:	70e2                	ld	ra,56(sp)
     aea:	7442                	ld	s0,48(sp)
     aec:	74a2                	ld	s1,40(sp)
     aee:	7902                	ld	s2,32(sp)
     af0:	69e2                	ld	s3,24(sp)
     af2:	6a42                	ld	s4,16(sp)
     af4:	6aa2                	ld	s5,8(sp)
     af6:	6121                	addi	sp,sp,64
     af8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     afa:	10b00613          	li	a2,267
     afe:	85d6                	mv	a1,s5
     b00:	00006517          	auipc	a0,0x6
     b04:	b6850513          	addi	a0,a0,-1176 # 6668 <malloc+0x978>
     b08:	00005097          	auipc	ra,0x5
     b0c:	128080e7          	jalr	296(ra) # 5c30 <printf>
        exit(1);
     b10:	4505                	li	a0,1
     b12:	00005097          	auipc	ra,0x5
     b16:	d8e080e7          	jalr	-626(ra) # 58a0 <exit>
      printf("%s: read failed %d\n", s, i);
     b1a:	862a                	mv	a2,a0
     b1c:	85d6                	mv	a1,s5
     b1e:	00006517          	auipc	a0,0x6
     b22:	b7250513          	addi	a0,a0,-1166 # 6690 <malloc+0x9a0>
     b26:	00005097          	auipc	ra,0x5
     b2a:	10a080e7          	jalr	266(ra) # 5c30 <printf>
      exit(1);
     b2e:	4505                	li	a0,1
     b30:	00005097          	auipc	ra,0x5
     b34:	d70080e7          	jalr	-656(ra) # 58a0 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b38:	8626                	mv	a2,s1
     b3a:	85d6                	mv	a1,s5
     b3c:	00006517          	auipc	a0,0x6
     b40:	b6c50513          	addi	a0,a0,-1172 # 66a8 <malloc+0x9b8>
     b44:	00005097          	auipc	ra,0x5
     b48:	0ec080e7          	jalr	236(ra) # 5c30 <printf>
      exit(1);
     b4c:	4505                	li	a0,1
     b4e:	00005097          	auipc	ra,0x5
     b52:	d52080e7          	jalr	-686(ra) # 58a0 <exit>
    printf("%s: unlink big failed\n", s);
     b56:	85d6                	mv	a1,s5
     b58:	00006517          	auipc	a0,0x6
     b5c:	b7850513          	addi	a0,a0,-1160 # 66d0 <malloc+0x9e0>
     b60:	00005097          	auipc	ra,0x5
     b64:	0d0080e7          	jalr	208(ra) # 5c30 <printf>
    exit(1);
     b68:	4505                	li	a0,1
     b6a:	00005097          	auipc	ra,0x5
     b6e:	d36080e7          	jalr	-714(ra) # 58a0 <exit>

0000000000000b72 <unlinkread>:
{
     b72:	7179                	addi	sp,sp,-48
     b74:	f406                	sd	ra,40(sp)
     b76:	f022                	sd	s0,32(sp)
     b78:	ec26                	sd	s1,24(sp)
     b7a:	e84a                	sd	s2,16(sp)
     b7c:	e44e                	sd	s3,8(sp)
     b7e:	1800                	addi	s0,sp,48
     b80:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b82:	20200593          	li	a1,514
     b86:	00006517          	auipc	a0,0x6
     b8a:	b6250513          	addi	a0,a0,-1182 # 66e8 <malloc+0x9f8>
     b8e:	00005097          	auipc	ra,0x5
     b92:	d52080e7          	jalr	-686(ra) # 58e0 <open>
  if(fd < 0){
     b96:	0e054563          	bltz	a0,c80 <unlinkread+0x10e>
     b9a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9c:	4615                	li	a2,5
     b9e:	00006597          	auipc	a1,0x6
     ba2:	b7a58593          	addi	a1,a1,-1158 # 6718 <malloc+0xa28>
     ba6:	00005097          	auipc	ra,0x5
     baa:	d1a080e7          	jalr	-742(ra) # 58c0 <write>
  close(fd);
     bae:	8526                	mv	a0,s1
     bb0:	00005097          	auipc	ra,0x5
     bb4:	d18080e7          	jalr	-744(ra) # 58c8 <close>
  fd = open("unlinkread", O_RDWR);
     bb8:	4589                	li	a1,2
     bba:	00006517          	auipc	a0,0x6
     bbe:	b2e50513          	addi	a0,a0,-1234 # 66e8 <malloc+0x9f8>
     bc2:	00005097          	auipc	ra,0x5
     bc6:	d1e080e7          	jalr	-738(ra) # 58e0 <open>
     bca:	84aa                	mv	s1,a0
  if(fd < 0){
     bcc:	0c054863          	bltz	a0,c9c <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bd0:	00006517          	auipc	a0,0x6
     bd4:	b1850513          	addi	a0,a0,-1256 # 66e8 <malloc+0x9f8>
     bd8:	00005097          	auipc	ra,0x5
     bdc:	d18080e7          	jalr	-744(ra) # 58f0 <unlink>
     be0:	ed61                	bnez	a0,cb8 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     be2:	20200593          	li	a1,514
     be6:	00006517          	auipc	a0,0x6
     bea:	b0250513          	addi	a0,a0,-1278 # 66e8 <malloc+0x9f8>
     bee:	00005097          	auipc	ra,0x5
     bf2:	cf2080e7          	jalr	-782(ra) # 58e0 <open>
     bf6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bf8:	460d                	li	a2,3
     bfa:	00006597          	auipc	a1,0x6
     bfe:	b6658593          	addi	a1,a1,-1178 # 6760 <malloc+0xa70>
     c02:	00005097          	auipc	ra,0x5
     c06:	cbe080e7          	jalr	-834(ra) # 58c0 <write>
  close(fd1);
     c0a:	854a                	mv	a0,s2
     c0c:	00005097          	auipc	ra,0x5
     c10:	cbc080e7          	jalr	-836(ra) # 58c8 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c14:	660d                	lui	a2,0x3
     c16:	0000b597          	auipc	a1,0xb
     c1a:	1e258593          	addi	a1,a1,482 # bdf8 <buf>
     c1e:	8526                	mv	a0,s1
     c20:	00005097          	auipc	ra,0x5
     c24:	c98080e7          	jalr	-872(ra) # 58b8 <read>
     c28:	4795                	li	a5,5
     c2a:	0af51563          	bne	a0,a5,cd4 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c2e:	0000b717          	auipc	a4,0xb
     c32:	1ca74703          	lbu	a4,458(a4) # bdf8 <buf>
     c36:	06800793          	li	a5,104
     c3a:	0af71b63          	bne	a4,a5,cf0 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c3e:	4629                	li	a2,10
     c40:	0000b597          	auipc	a1,0xb
     c44:	1b858593          	addi	a1,a1,440 # bdf8 <buf>
     c48:	8526                	mv	a0,s1
     c4a:	00005097          	auipc	ra,0x5
     c4e:	c76080e7          	jalr	-906(ra) # 58c0 <write>
     c52:	47a9                	li	a5,10
     c54:	0af51c63          	bne	a0,a5,d0c <unlinkread+0x19a>
  close(fd);
     c58:	8526                	mv	a0,s1
     c5a:	00005097          	auipc	ra,0x5
     c5e:	c6e080e7          	jalr	-914(ra) # 58c8 <close>
  unlink("unlinkread");
     c62:	00006517          	auipc	a0,0x6
     c66:	a8650513          	addi	a0,a0,-1402 # 66e8 <malloc+0x9f8>
     c6a:	00005097          	auipc	ra,0x5
     c6e:	c86080e7          	jalr	-890(ra) # 58f0 <unlink>
}
     c72:	70a2                	ld	ra,40(sp)
     c74:	7402                	ld	s0,32(sp)
     c76:	64e2                	ld	s1,24(sp)
     c78:	6942                	ld	s2,16(sp)
     c7a:	69a2                	ld	s3,8(sp)
     c7c:	6145                	addi	sp,sp,48
     c7e:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c80:	85ce                	mv	a1,s3
     c82:	00006517          	auipc	a0,0x6
     c86:	a7650513          	addi	a0,a0,-1418 # 66f8 <malloc+0xa08>
     c8a:	00005097          	auipc	ra,0x5
     c8e:	fa6080e7          	jalr	-90(ra) # 5c30 <printf>
    exit(1);
     c92:	4505                	li	a0,1
     c94:	00005097          	auipc	ra,0x5
     c98:	c0c080e7          	jalr	-1012(ra) # 58a0 <exit>
    printf("%s: open unlinkread failed\n", s);
     c9c:	85ce                	mv	a1,s3
     c9e:	00006517          	auipc	a0,0x6
     ca2:	a8250513          	addi	a0,a0,-1406 # 6720 <malloc+0xa30>
     ca6:	00005097          	auipc	ra,0x5
     caa:	f8a080e7          	jalr	-118(ra) # 5c30 <printf>
    exit(1);
     cae:	4505                	li	a0,1
     cb0:	00005097          	auipc	ra,0x5
     cb4:	bf0080e7          	jalr	-1040(ra) # 58a0 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cb8:	85ce                	mv	a1,s3
     cba:	00006517          	auipc	a0,0x6
     cbe:	a8650513          	addi	a0,a0,-1402 # 6740 <malloc+0xa50>
     cc2:	00005097          	auipc	ra,0x5
     cc6:	f6e080e7          	jalr	-146(ra) # 5c30 <printf>
    exit(1);
     cca:	4505                	li	a0,1
     ccc:	00005097          	auipc	ra,0x5
     cd0:	bd4080e7          	jalr	-1068(ra) # 58a0 <exit>
    printf("%s: unlinkread read failed", s);
     cd4:	85ce                	mv	a1,s3
     cd6:	00006517          	auipc	a0,0x6
     cda:	a9250513          	addi	a0,a0,-1390 # 6768 <malloc+0xa78>
     cde:	00005097          	auipc	ra,0x5
     ce2:	f52080e7          	jalr	-174(ra) # 5c30 <printf>
    exit(1);
     ce6:	4505                	li	a0,1
     ce8:	00005097          	auipc	ra,0x5
     cec:	bb8080e7          	jalr	-1096(ra) # 58a0 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cf0:	85ce                	mv	a1,s3
     cf2:	00006517          	auipc	a0,0x6
     cf6:	a9650513          	addi	a0,a0,-1386 # 6788 <malloc+0xa98>
     cfa:	00005097          	auipc	ra,0x5
     cfe:	f36080e7          	jalr	-202(ra) # 5c30 <printf>
    exit(1);
     d02:	4505                	li	a0,1
     d04:	00005097          	auipc	ra,0x5
     d08:	b9c080e7          	jalr	-1124(ra) # 58a0 <exit>
    printf("%s: unlinkread write failed\n", s);
     d0c:	85ce                	mv	a1,s3
     d0e:	00006517          	auipc	a0,0x6
     d12:	a9a50513          	addi	a0,a0,-1382 # 67a8 <malloc+0xab8>
     d16:	00005097          	auipc	ra,0x5
     d1a:	f1a080e7          	jalr	-230(ra) # 5c30 <printf>
    exit(1);
     d1e:	4505                	li	a0,1
     d20:	00005097          	auipc	ra,0x5
     d24:	b80080e7          	jalr	-1152(ra) # 58a0 <exit>

0000000000000d28 <linktest>:
{
     d28:	1101                	addi	sp,sp,-32
     d2a:	ec06                	sd	ra,24(sp)
     d2c:	e822                	sd	s0,16(sp)
     d2e:	e426                	sd	s1,8(sp)
     d30:	e04a                	sd	s2,0(sp)
     d32:	1000                	addi	s0,sp,32
     d34:	892a                	mv	s2,a0
  unlink("lf1");
     d36:	00006517          	auipc	a0,0x6
     d3a:	a9250513          	addi	a0,a0,-1390 # 67c8 <malloc+0xad8>
     d3e:	00005097          	auipc	ra,0x5
     d42:	bb2080e7          	jalr	-1102(ra) # 58f0 <unlink>
  unlink("lf2");
     d46:	00006517          	auipc	a0,0x6
     d4a:	a8a50513          	addi	a0,a0,-1398 # 67d0 <malloc+0xae0>
     d4e:	00005097          	auipc	ra,0x5
     d52:	ba2080e7          	jalr	-1118(ra) # 58f0 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d56:	20200593          	li	a1,514
     d5a:	00006517          	auipc	a0,0x6
     d5e:	a6e50513          	addi	a0,a0,-1426 # 67c8 <malloc+0xad8>
     d62:	00005097          	auipc	ra,0x5
     d66:	b7e080e7          	jalr	-1154(ra) # 58e0 <open>
  if(fd < 0){
     d6a:	10054763          	bltz	a0,e78 <linktest+0x150>
     d6e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d70:	4615                	li	a2,5
     d72:	00006597          	auipc	a1,0x6
     d76:	9a658593          	addi	a1,a1,-1626 # 6718 <malloc+0xa28>
     d7a:	00005097          	auipc	ra,0x5
     d7e:	b46080e7          	jalr	-1210(ra) # 58c0 <write>
     d82:	4795                	li	a5,5
     d84:	10f51863          	bne	a0,a5,e94 <linktest+0x16c>
  close(fd);
     d88:	8526                	mv	a0,s1
     d8a:	00005097          	auipc	ra,0x5
     d8e:	b3e080e7          	jalr	-1218(ra) # 58c8 <close>
  if(link("lf1", "lf2") < 0){
     d92:	00006597          	auipc	a1,0x6
     d96:	a3e58593          	addi	a1,a1,-1474 # 67d0 <malloc+0xae0>
     d9a:	00006517          	auipc	a0,0x6
     d9e:	a2e50513          	addi	a0,a0,-1490 # 67c8 <malloc+0xad8>
     da2:	00005097          	auipc	ra,0x5
     da6:	b5e080e7          	jalr	-1186(ra) # 5900 <link>
     daa:	10054363          	bltz	a0,eb0 <linktest+0x188>
  unlink("lf1");
     dae:	00006517          	auipc	a0,0x6
     db2:	a1a50513          	addi	a0,a0,-1510 # 67c8 <malloc+0xad8>
     db6:	00005097          	auipc	ra,0x5
     dba:	b3a080e7          	jalr	-1222(ra) # 58f0 <unlink>
  if(open("lf1", 0) >= 0){
     dbe:	4581                	li	a1,0
     dc0:	00006517          	auipc	a0,0x6
     dc4:	a0850513          	addi	a0,a0,-1528 # 67c8 <malloc+0xad8>
     dc8:	00005097          	auipc	ra,0x5
     dcc:	b18080e7          	jalr	-1256(ra) # 58e0 <open>
     dd0:	0e055e63          	bgez	a0,ecc <linktest+0x1a4>
  fd = open("lf2", 0);
     dd4:	4581                	li	a1,0
     dd6:	00006517          	auipc	a0,0x6
     dda:	9fa50513          	addi	a0,a0,-1542 # 67d0 <malloc+0xae0>
     dde:	00005097          	auipc	ra,0x5
     de2:	b02080e7          	jalr	-1278(ra) # 58e0 <open>
     de6:	84aa                	mv	s1,a0
  if(fd < 0){
     de8:	10054063          	bltz	a0,ee8 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dec:	660d                	lui	a2,0x3
     dee:	0000b597          	auipc	a1,0xb
     df2:	00a58593          	addi	a1,a1,10 # bdf8 <buf>
     df6:	00005097          	auipc	ra,0x5
     dfa:	ac2080e7          	jalr	-1342(ra) # 58b8 <read>
     dfe:	4795                	li	a5,5
     e00:	10f51263          	bne	a0,a5,f04 <linktest+0x1dc>
  close(fd);
     e04:	8526                	mv	a0,s1
     e06:	00005097          	auipc	ra,0x5
     e0a:	ac2080e7          	jalr	-1342(ra) # 58c8 <close>
  if(link("lf2", "lf2") >= 0){
     e0e:	00006597          	auipc	a1,0x6
     e12:	9c258593          	addi	a1,a1,-1598 # 67d0 <malloc+0xae0>
     e16:	852e                	mv	a0,a1
     e18:	00005097          	auipc	ra,0x5
     e1c:	ae8080e7          	jalr	-1304(ra) # 5900 <link>
     e20:	10055063          	bgez	a0,f20 <linktest+0x1f8>
  unlink("lf2");
     e24:	00006517          	auipc	a0,0x6
     e28:	9ac50513          	addi	a0,a0,-1620 # 67d0 <malloc+0xae0>
     e2c:	00005097          	auipc	ra,0x5
     e30:	ac4080e7          	jalr	-1340(ra) # 58f0 <unlink>
  if(link("lf2", "lf1") >= 0){
     e34:	00006597          	auipc	a1,0x6
     e38:	99458593          	addi	a1,a1,-1644 # 67c8 <malloc+0xad8>
     e3c:	00006517          	auipc	a0,0x6
     e40:	99450513          	addi	a0,a0,-1644 # 67d0 <malloc+0xae0>
     e44:	00005097          	auipc	ra,0x5
     e48:	abc080e7          	jalr	-1348(ra) # 5900 <link>
     e4c:	0e055863          	bgez	a0,f3c <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e50:	00006597          	auipc	a1,0x6
     e54:	97858593          	addi	a1,a1,-1672 # 67c8 <malloc+0xad8>
     e58:	00006517          	auipc	a0,0x6
     e5c:	a8050513          	addi	a0,a0,-1408 # 68d8 <malloc+0xbe8>
     e60:	00005097          	auipc	ra,0x5
     e64:	aa0080e7          	jalr	-1376(ra) # 5900 <link>
     e68:	0e055863          	bgez	a0,f58 <linktest+0x230>
}
     e6c:	60e2                	ld	ra,24(sp)
     e6e:	6442                	ld	s0,16(sp)
     e70:	64a2                	ld	s1,8(sp)
     e72:	6902                	ld	s2,0(sp)
     e74:	6105                	addi	sp,sp,32
     e76:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e78:	85ca                	mv	a1,s2
     e7a:	00006517          	auipc	a0,0x6
     e7e:	95e50513          	addi	a0,a0,-1698 # 67d8 <malloc+0xae8>
     e82:	00005097          	auipc	ra,0x5
     e86:	dae080e7          	jalr	-594(ra) # 5c30 <printf>
    exit(1);
     e8a:	4505                	li	a0,1
     e8c:	00005097          	auipc	ra,0x5
     e90:	a14080e7          	jalr	-1516(ra) # 58a0 <exit>
    printf("%s: write lf1 failed\n", s);
     e94:	85ca                	mv	a1,s2
     e96:	00006517          	auipc	a0,0x6
     e9a:	95a50513          	addi	a0,a0,-1702 # 67f0 <malloc+0xb00>
     e9e:	00005097          	auipc	ra,0x5
     ea2:	d92080e7          	jalr	-622(ra) # 5c30 <printf>
    exit(1);
     ea6:	4505                	li	a0,1
     ea8:	00005097          	auipc	ra,0x5
     eac:	9f8080e7          	jalr	-1544(ra) # 58a0 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     eb0:	85ca                	mv	a1,s2
     eb2:	00006517          	auipc	a0,0x6
     eb6:	95650513          	addi	a0,a0,-1706 # 6808 <malloc+0xb18>
     eba:	00005097          	auipc	ra,0x5
     ebe:	d76080e7          	jalr	-650(ra) # 5c30 <printf>
    exit(1);
     ec2:	4505                	li	a0,1
     ec4:	00005097          	auipc	ra,0x5
     ec8:	9dc080e7          	jalr	-1572(ra) # 58a0 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ecc:	85ca                	mv	a1,s2
     ece:	00006517          	auipc	a0,0x6
     ed2:	95a50513          	addi	a0,a0,-1702 # 6828 <malloc+0xb38>
     ed6:	00005097          	auipc	ra,0x5
     eda:	d5a080e7          	jalr	-678(ra) # 5c30 <printf>
    exit(1);
     ede:	4505                	li	a0,1
     ee0:	00005097          	auipc	ra,0x5
     ee4:	9c0080e7          	jalr	-1600(ra) # 58a0 <exit>
    printf("%s: open lf2 failed\n", s);
     ee8:	85ca                	mv	a1,s2
     eea:	00006517          	auipc	a0,0x6
     eee:	96e50513          	addi	a0,a0,-1682 # 6858 <malloc+0xb68>
     ef2:	00005097          	auipc	ra,0x5
     ef6:	d3e080e7          	jalr	-706(ra) # 5c30 <printf>
    exit(1);
     efa:	4505                	li	a0,1
     efc:	00005097          	auipc	ra,0x5
     f00:	9a4080e7          	jalr	-1628(ra) # 58a0 <exit>
    printf("%s: read lf2 failed\n", s);
     f04:	85ca                	mv	a1,s2
     f06:	00006517          	auipc	a0,0x6
     f0a:	96a50513          	addi	a0,a0,-1686 # 6870 <malloc+0xb80>
     f0e:	00005097          	auipc	ra,0x5
     f12:	d22080e7          	jalr	-734(ra) # 5c30 <printf>
    exit(1);
     f16:	4505                	li	a0,1
     f18:	00005097          	auipc	ra,0x5
     f1c:	988080e7          	jalr	-1656(ra) # 58a0 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f20:	85ca                	mv	a1,s2
     f22:	00006517          	auipc	a0,0x6
     f26:	96650513          	addi	a0,a0,-1690 # 6888 <malloc+0xb98>
     f2a:	00005097          	auipc	ra,0x5
     f2e:	d06080e7          	jalr	-762(ra) # 5c30 <printf>
    exit(1);
     f32:	4505                	li	a0,1
     f34:	00005097          	auipc	ra,0x5
     f38:	96c080e7          	jalr	-1684(ra) # 58a0 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f3c:	85ca                	mv	a1,s2
     f3e:	00006517          	auipc	a0,0x6
     f42:	97250513          	addi	a0,a0,-1678 # 68b0 <malloc+0xbc0>
     f46:	00005097          	auipc	ra,0x5
     f4a:	cea080e7          	jalr	-790(ra) # 5c30 <printf>
    exit(1);
     f4e:	4505                	li	a0,1
     f50:	00005097          	auipc	ra,0x5
     f54:	950080e7          	jalr	-1712(ra) # 58a0 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f58:	85ca                	mv	a1,s2
     f5a:	00006517          	auipc	a0,0x6
     f5e:	98650513          	addi	a0,a0,-1658 # 68e0 <malloc+0xbf0>
     f62:	00005097          	auipc	ra,0x5
     f66:	cce080e7          	jalr	-818(ra) # 5c30 <printf>
    exit(1);
     f6a:	4505                	li	a0,1
     f6c:	00005097          	auipc	ra,0x5
     f70:	934080e7          	jalr	-1740(ra) # 58a0 <exit>

0000000000000f74 <bigdir>:
{
     f74:	715d                	addi	sp,sp,-80
     f76:	e486                	sd	ra,72(sp)
     f78:	e0a2                	sd	s0,64(sp)
     f7a:	fc26                	sd	s1,56(sp)
     f7c:	f84a                	sd	s2,48(sp)
     f7e:	f44e                	sd	s3,40(sp)
     f80:	f052                	sd	s4,32(sp)
     f82:	ec56                	sd	s5,24(sp)
     f84:	e85a                	sd	s6,16(sp)
     f86:	0880                	addi	s0,sp,80
     f88:	89aa                	mv	s3,a0
  unlink("bd");
     f8a:	00006517          	auipc	a0,0x6
     f8e:	97650513          	addi	a0,a0,-1674 # 6900 <malloc+0xc10>
     f92:	00005097          	auipc	ra,0x5
     f96:	95e080e7          	jalr	-1698(ra) # 58f0 <unlink>
  fd = open("bd", O_CREATE);
     f9a:	20000593          	li	a1,512
     f9e:	00006517          	auipc	a0,0x6
     fa2:	96250513          	addi	a0,a0,-1694 # 6900 <malloc+0xc10>
     fa6:	00005097          	auipc	ra,0x5
     faa:	93a080e7          	jalr	-1734(ra) # 58e0 <open>
  if(fd < 0){
     fae:	0c054963          	bltz	a0,1080 <bigdir+0x10c>
  close(fd);
     fb2:	00005097          	auipc	ra,0x5
     fb6:	916080e7          	jalr	-1770(ra) # 58c8 <close>
  for(i = 0; i < N; i++){
     fba:	4901                	li	s2,0
    name[0] = 'x';
     fbc:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fc0:	00006a17          	auipc	s4,0x6
     fc4:	940a0a13          	addi	s4,s4,-1728 # 6900 <malloc+0xc10>
  for(i = 0; i < N; i++){
     fc8:	1f400b13          	li	s6,500
    name[0] = 'x';
     fcc:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fd0:	41f9579b          	sraiw	a5,s2,0x1f
     fd4:	01a7d71b          	srliw	a4,a5,0x1a
     fd8:	012707bb          	addw	a5,a4,s2
     fdc:	4067d69b          	sraiw	a3,a5,0x6
     fe0:	0306869b          	addiw	a3,a3,48
     fe4:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fe8:	03f7f793          	andi	a5,a5,63
     fec:	9f99                	subw	a5,a5,a4
     fee:	0307879b          	addiw	a5,a5,48
     ff2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     ff6:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     ffa:	fb040593          	addi	a1,s0,-80
     ffe:	8552                	mv	a0,s4
    1000:	00005097          	auipc	ra,0x5
    1004:	900080e7          	jalr	-1792(ra) # 5900 <link>
    1008:	84aa                	mv	s1,a0
    100a:	e949                	bnez	a0,109c <bigdir+0x128>
  for(i = 0; i < N; i++){
    100c:	2905                	addiw	s2,s2,1
    100e:	fb691fe3          	bne	s2,s6,fcc <bigdir+0x58>
  unlink("bd");
    1012:	00006517          	auipc	a0,0x6
    1016:	8ee50513          	addi	a0,a0,-1810 # 6900 <malloc+0xc10>
    101a:	00005097          	auipc	ra,0x5
    101e:	8d6080e7          	jalr	-1834(ra) # 58f0 <unlink>
    name[0] = 'x';
    1022:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1026:	1f400a13          	li	s4,500
    name[0] = 'x';
    102a:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    102e:	41f4d79b          	sraiw	a5,s1,0x1f
    1032:	01a7d71b          	srliw	a4,a5,0x1a
    1036:	009707bb          	addw	a5,a4,s1
    103a:	4067d69b          	sraiw	a3,a5,0x6
    103e:	0306869b          	addiw	a3,a3,48
    1042:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1046:	03f7f793          	andi	a5,a5,63
    104a:	9f99                	subw	a5,a5,a4
    104c:	0307879b          	addiw	a5,a5,48
    1050:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1054:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1058:	fb040513          	addi	a0,s0,-80
    105c:	00005097          	auipc	ra,0x5
    1060:	894080e7          	jalr	-1900(ra) # 58f0 <unlink>
    1064:	ed21                	bnez	a0,10bc <bigdir+0x148>
  for(i = 0; i < N; i++){
    1066:	2485                	addiw	s1,s1,1
    1068:	fd4491e3          	bne	s1,s4,102a <bigdir+0xb6>
}
    106c:	60a6                	ld	ra,72(sp)
    106e:	6406                	ld	s0,64(sp)
    1070:	74e2                	ld	s1,56(sp)
    1072:	7942                	ld	s2,48(sp)
    1074:	79a2                	ld	s3,40(sp)
    1076:	7a02                	ld	s4,32(sp)
    1078:	6ae2                	ld	s5,24(sp)
    107a:	6b42                	ld	s6,16(sp)
    107c:	6161                	addi	sp,sp,80
    107e:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1080:	85ce                	mv	a1,s3
    1082:	00006517          	auipc	a0,0x6
    1086:	88650513          	addi	a0,a0,-1914 # 6908 <malloc+0xc18>
    108a:	00005097          	auipc	ra,0x5
    108e:	ba6080e7          	jalr	-1114(ra) # 5c30 <printf>
    exit(1);
    1092:	4505                	li	a0,1
    1094:	00005097          	auipc	ra,0x5
    1098:	80c080e7          	jalr	-2036(ra) # 58a0 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    109c:	fb040613          	addi	a2,s0,-80
    10a0:	85ce                	mv	a1,s3
    10a2:	00006517          	auipc	a0,0x6
    10a6:	88650513          	addi	a0,a0,-1914 # 6928 <malloc+0xc38>
    10aa:	00005097          	auipc	ra,0x5
    10ae:	b86080e7          	jalr	-1146(ra) # 5c30 <printf>
      exit(1);
    10b2:	4505                	li	a0,1
    10b4:	00004097          	auipc	ra,0x4
    10b8:	7ec080e7          	jalr	2028(ra) # 58a0 <exit>
      printf("%s: bigdir unlink failed", s);
    10bc:	85ce                	mv	a1,s3
    10be:	00006517          	auipc	a0,0x6
    10c2:	88a50513          	addi	a0,a0,-1910 # 6948 <malloc+0xc58>
    10c6:	00005097          	auipc	ra,0x5
    10ca:	b6a080e7          	jalr	-1174(ra) # 5c30 <printf>
      exit(1);
    10ce:	4505                	li	a0,1
    10d0:	00004097          	auipc	ra,0x4
    10d4:	7d0080e7          	jalr	2000(ra) # 58a0 <exit>

00000000000010d8 <validatetest>:
{
    10d8:	7139                	addi	sp,sp,-64
    10da:	fc06                	sd	ra,56(sp)
    10dc:	f822                	sd	s0,48(sp)
    10de:	f426                	sd	s1,40(sp)
    10e0:	f04a                	sd	s2,32(sp)
    10e2:	ec4e                	sd	s3,24(sp)
    10e4:	e852                	sd	s4,16(sp)
    10e6:	e456                	sd	s5,8(sp)
    10e8:	e05a                	sd	s6,0(sp)
    10ea:	0080                	addi	s0,sp,64
    10ec:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ee:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10f0:	00006997          	auipc	s3,0x6
    10f4:	87898993          	addi	s3,s3,-1928 # 6968 <malloc+0xc78>
    10f8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fa:	6a85                	lui	s5,0x1
    10fc:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1100:	85a6                	mv	a1,s1
    1102:	854e                	mv	a0,s3
    1104:	00004097          	auipc	ra,0x4
    1108:	7fc080e7          	jalr	2044(ra) # 5900 <link>
    110c:	01251f63          	bne	a0,s2,112a <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1110:	94d6                	add	s1,s1,s5
    1112:	ff4497e3          	bne	s1,s4,1100 <validatetest+0x28>
}
    1116:	70e2                	ld	ra,56(sp)
    1118:	7442                	ld	s0,48(sp)
    111a:	74a2                	ld	s1,40(sp)
    111c:	7902                	ld	s2,32(sp)
    111e:	69e2                	ld	s3,24(sp)
    1120:	6a42                	ld	s4,16(sp)
    1122:	6aa2                	ld	s5,8(sp)
    1124:	6b02                	ld	s6,0(sp)
    1126:	6121                	addi	sp,sp,64
    1128:	8082                	ret
      printf("%s: link should not succeed\n", s);
    112a:	85da                	mv	a1,s6
    112c:	00006517          	auipc	a0,0x6
    1130:	84c50513          	addi	a0,a0,-1972 # 6978 <malloc+0xc88>
    1134:	00005097          	auipc	ra,0x5
    1138:	afc080e7          	jalr	-1284(ra) # 5c30 <printf>
      exit(1);
    113c:	4505                	li	a0,1
    113e:	00004097          	auipc	ra,0x4
    1142:	762080e7          	jalr	1890(ra) # 58a0 <exit>

0000000000001146 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1146:	7179                	addi	sp,sp,-48
    1148:	f406                	sd	ra,40(sp)
    114a:	f022                	sd	s0,32(sp)
    114c:	ec26                	sd	s1,24(sp)
    114e:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1150:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1154:	00007797          	auipc	a5,0x7
    1158:	47c78793          	addi	a5,a5,1148 # 85d0 <__SDATA_BEGIN__>
    115c:	6384                	ld	s1,0(a5)
    115e:	fd840593          	addi	a1,s0,-40
    1162:	8526                	mv	a0,s1
    1164:	00004097          	auipc	ra,0x4
    1168:	774080e7          	jalr	1908(ra) # 58d8 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    116c:	8526                	mv	a0,s1
    116e:	00004097          	auipc	ra,0x4
    1172:	742080e7          	jalr	1858(ra) # 58b0 <pipe>

  exit(0);
    1176:	4501                	li	a0,0
    1178:	00004097          	auipc	ra,0x4
    117c:	728080e7          	jalr	1832(ra) # 58a0 <exit>

0000000000001180 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1180:	7139                	addi	sp,sp,-64
    1182:	fc06                	sd	ra,56(sp)
    1184:	f822                	sd	s0,48(sp)
    1186:	f426                	sd	s1,40(sp)
    1188:	f04a                	sd	s2,32(sp)
    118a:	ec4e                	sd	s3,24(sp)
    118c:	0080                	addi	s0,sp,64
    118e:	64b1                	lui	s1,0xc
    1190:	35048493          	addi	s1,s1,848 # c350 <buf+0x558>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1194:	597d                	li	s2,-1
    1196:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    119a:	00005997          	auipc	s3,0x5
    119e:	08698993          	addi	s3,s3,134 # 6220 <malloc+0x530>
    argv[0] = (char*)0xffffffff;
    11a2:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    11a6:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11aa:	fc040593          	addi	a1,s0,-64
    11ae:	854e                	mv	a0,s3
    11b0:	00004097          	auipc	ra,0x4
    11b4:	728080e7          	jalr	1832(ra) # 58d8 <exec>
  for(int i = 0; i < 50000; i++){
    11b8:	34fd                	addiw	s1,s1,-1
    11ba:	f4e5                	bnez	s1,11a2 <badarg+0x22>
  }
  
  exit(0);
    11bc:	4501                	li	a0,0
    11be:	00004097          	auipc	ra,0x4
    11c2:	6e2080e7          	jalr	1762(ra) # 58a0 <exit>

00000000000011c6 <copyinstr2>:
{
    11c6:	7155                	addi	sp,sp,-208
    11c8:	e586                	sd	ra,200(sp)
    11ca:	e1a2                	sd	s0,192(sp)
    11cc:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11ce:	f6840793          	addi	a5,s0,-152
    11d2:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11d6:	07800713          	li	a4,120
    11da:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11de:	0785                	addi	a5,a5,1
    11e0:	fed79de3          	bne	a5,a3,11da <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11e4:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11e8:	f6840513          	addi	a0,s0,-152
    11ec:	00004097          	auipc	ra,0x4
    11f0:	704080e7          	jalr	1796(ra) # 58f0 <unlink>
  if(ret != -1){
    11f4:	57fd                	li	a5,-1
    11f6:	0ef51063          	bne	a0,a5,12d6 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11fa:	20100593          	li	a1,513
    11fe:	f6840513          	addi	a0,s0,-152
    1202:	00004097          	auipc	ra,0x4
    1206:	6de080e7          	jalr	1758(ra) # 58e0 <open>
  if(fd != -1){
    120a:	57fd                	li	a5,-1
    120c:	0ef51563          	bne	a0,a5,12f6 <copyinstr2+0x130>
  ret = link(b, b);
    1210:	f6840593          	addi	a1,s0,-152
    1214:	852e                	mv	a0,a1
    1216:	00004097          	auipc	ra,0x4
    121a:	6ea080e7          	jalr	1770(ra) # 5900 <link>
  if(ret != -1){
    121e:	57fd                	li	a5,-1
    1220:	0ef51b63          	bne	a0,a5,1316 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1224:	00007797          	auipc	a5,0x7
    1228:	94c78793          	addi	a5,a5,-1716 # 7b70 <malloc+0x1e80>
    122c:	f4f43c23          	sd	a5,-168(s0)
    1230:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1234:	f5840593          	addi	a1,s0,-168
    1238:	f6840513          	addi	a0,s0,-152
    123c:	00004097          	auipc	ra,0x4
    1240:	69c080e7          	jalr	1692(ra) # 58d8 <exec>
  if(ret != -1){
    1244:	57fd                	li	a5,-1
    1246:	0ef51963          	bne	a0,a5,1338 <copyinstr2+0x172>
  int pid = fork();
    124a:	00004097          	auipc	ra,0x4
    124e:	64e080e7          	jalr	1614(ra) # 5898 <fork>
  if(pid < 0){
    1252:	10054363          	bltz	a0,1358 <copyinstr2+0x192>
  if(pid == 0){
    1256:	12051463          	bnez	a0,137e <copyinstr2+0x1b8>
    125a:	00007797          	auipc	a5,0x7
    125e:	48678793          	addi	a5,a5,1158 # 86e0 <big.1299>
    1262:	00008697          	auipc	a3,0x8
    1266:	47e68693          	addi	a3,a3,1150 # 96e0 <__global_pointer$+0x910>
      big[i] = 'x';
    126a:	07800713          	li	a4,120
    126e:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1272:	0785                	addi	a5,a5,1
    1274:	fed79de3          	bne	a5,a3,126e <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1278:	00008797          	auipc	a5,0x8
    127c:	46078423          	sb	zero,1128(a5) # 96e0 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    1280:	00005797          	auipc	a5,0x5
    1284:	b5878793          	addi	a5,a5,-1192 # 5dd8 <malloc+0xe8>
    1288:	6390                	ld	a2,0(a5)
    128a:	6794                	ld	a3,8(a5)
    128c:	6b98                	ld	a4,16(a5)
    128e:	6f9c                	ld	a5,24(a5)
    1290:	f2c43823          	sd	a2,-208(s0)
    1294:	f2d43c23          	sd	a3,-200(s0)
    1298:	f4e43023          	sd	a4,-192(s0)
    129c:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    12a0:	f3040593          	addi	a1,s0,-208
    12a4:	00005517          	auipc	a0,0x5
    12a8:	f7c50513          	addi	a0,a0,-132 # 6220 <malloc+0x530>
    12ac:	00004097          	auipc	ra,0x4
    12b0:	62c080e7          	jalr	1580(ra) # 58d8 <exec>
    if(ret != -1){
    12b4:	57fd                	li	a5,-1
    12b6:	0af50e63          	beq	a0,a5,1372 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ba:	55fd                	li	a1,-1
    12bc:	00005517          	auipc	a0,0x5
    12c0:	76450513          	addi	a0,a0,1892 # 6a20 <malloc+0xd30>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	96c080e7          	jalr	-1684(ra) # 5c30 <printf>
      exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00004097          	auipc	ra,0x4
    12d2:	5d2080e7          	jalr	1490(ra) # 58a0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12d6:	862a                	mv	a2,a0
    12d8:	f6840593          	addi	a1,s0,-152
    12dc:	00005517          	auipc	a0,0x5
    12e0:	6bc50513          	addi	a0,a0,1724 # 6998 <malloc+0xca8>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	94c080e7          	jalr	-1716(ra) # 5c30 <printf>
    exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00004097          	auipc	ra,0x4
    12f2:	5b2080e7          	jalr	1458(ra) # 58a0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12f6:	862a                	mv	a2,a0
    12f8:	f6840593          	addi	a1,s0,-152
    12fc:	00005517          	auipc	a0,0x5
    1300:	6bc50513          	addi	a0,a0,1724 # 69b8 <malloc+0xcc8>
    1304:	00005097          	auipc	ra,0x5
    1308:	92c080e7          	jalr	-1748(ra) # 5c30 <printf>
    exit(1);
    130c:	4505                	li	a0,1
    130e:	00004097          	auipc	ra,0x4
    1312:	592080e7          	jalr	1426(ra) # 58a0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1316:	86aa                	mv	a3,a0
    1318:	f6840613          	addi	a2,s0,-152
    131c:	85b2                	mv	a1,a2
    131e:	00005517          	auipc	a0,0x5
    1322:	6ba50513          	addi	a0,a0,1722 # 69d8 <malloc+0xce8>
    1326:	00005097          	auipc	ra,0x5
    132a:	90a080e7          	jalr	-1782(ra) # 5c30 <printf>
    exit(1);
    132e:	4505                	li	a0,1
    1330:	00004097          	auipc	ra,0x4
    1334:	570080e7          	jalr	1392(ra) # 58a0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1338:	567d                	li	a2,-1
    133a:	f6840593          	addi	a1,s0,-152
    133e:	00005517          	auipc	a0,0x5
    1342:	6c250513          	addi	a0,a0,1730 # 6a00 <malloc+0xd10>
    1346:	00005097          	auipc	ra,0x5
    134a:	8ea080e7          	jalr	-1814(ra) # 5c30 <printf>
    exit(1);
    134e:	4505                	li	a0,1
    1350:	00004097          	auipc	ra,0x4
    1354:	550080e7          	jalr	1360(ra) # 58a0 <exit>
    printf("fork failed\n");
    1358:	00006517          	auipc	a0,0x6
    135c:	b4050513          	addi	a0,a0,-1216 # 6e98 <malloc+0x11a8>
    1360:	00005097          	auipc	ra,0x5
    1364:	8d0080e7          	jalr	-1840(ra) # 5c30 <printf>
    exit(1);
    1368:	4505                	li	a0,1
    136a:	00004097          	auipc	ra,0x4
    136e:	536080e7          	jalr	1334(ra) # 58a0 <exit>
    exit(747); // OK
    1372:	2eb00513          	li	a0,747
    1376:	00004097          	auipc	ra,0x4
    137a:	52a080e7          	jalr	1322(ra) # 58a0 <exit>
  int st = 0;
    137e:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1382:	f5440513          	addi	a0,s0,-172
    1386:	00004097          	auipc	ra,0x4
    138a:	522080e7          	jalr	1314(ra) # 58a8 <wait>
  if(st != 747){
    138e:	f5442703          	lw	a4,-172(s0)
    1392:	2eb00793          	li	a5,747
    1396:	00f71663          	bne	a4,a5,13a2 <copyinstr2+0x1dc>
}
    139a:	60ae                	ld	ra,200(sp)
    139c:	640e                	ld	s0,192(sp)
    139e:	6169                	addi	sp,sp,208
    13a0:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    13a2:	00005517          	auipc	a0,0x5
    13a6:	6a650513          	addi	a0,a0,1702 # 6a48 <malloc+0xd58>
    13aa:	00005097          	auipc	ra,0x5
    13ae:	886080e7          	jalr	-1914(ra) # 5c30 <printf>
    exit(1);
    13b2:	4505                	li	a0,1
    13b4:	00004097          	auipc	ra,0x4
    13b8:	4ec080e7          	jalr	1260(ra) # 58a0 <exit>

00000000000013bc <truncate3>:
{
    13bc:	7159                	addi	sp,sp,-112
    13be:	f486                	sd	ra,104(sp)
    13c0:	f0a2                	sd	s0,96(sp)
    13c2:	eca6                	sd	s1,88(sp)
    13c4:	e8ca                	sd	s2,80(sp)
    13c6:	e4ce                	sd	s3,72(sp)
    13c8:	e0d2                	sd	s4,64(sp)
    13ca:	fc56                	sd	s5,56(sp)
    13cc:	1880                	addi	s0,sp,112
    13ce:	8a2a                	mv	s4,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13d0:	60100593          	li	a1,1537
    13d4:	00005517          	auipc	a0,0x5
    13d8:	ea450513          	addi	a0,a0,-348 # 6278 <malloc+0x588>
    13dc:	00004097          	auipc	ra,0x4
    13e0:	504080e7          	jalr	1284(ra) # 58e0 <open>
    13e4:	00004097          	auipc	ra,0x4
    13e8:	4e4080e7          	jalr	1252(ra) # 58c8 <close>
  pid = fork();
    13ec:	00004097          	auipc	ra,0x4
    13f0:	4ac080e7          	jalr	1196(ra) # 5898 <fork>
  if(pid < 0){
    13f4:	08054063          	bltz	a0,1474 <truncate3+0xb8>
  if(pid == 0){
    13f8:	e969                	bnez	a0,14ca <truncate3+0x10e>
    13fa:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    13fe:	00005997          	auipc	s3,0x5
    1402:	e7a98993          	addi	s3,s3,-390 # 6278 <malloc+0x588>
      int n = write(fd, "1234567890", 10);
    1406:	00005a97          	auipc	s5,0x5
    140a:	6a2a8a93          	addi	s5,s5,1698 # 6aa8 <malloc+0xdb8>
      int fd = open("truncfile", O_WRONLY);
    140e:	4585                	li	a1,1
    1410:	854e                	mv	a0,s3
    1412:	00004097          	auipc	ra,0x4
    1416:	4ce080e7          	jalr	1230(ra) # 58e0 <open>
    141a:	84aa                	mv	s1,a0
      if(fd < 0){
    141c:	06054a63          	bltz	a0,1490 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1420:	4629                	li	a2,10
    1422:	85d6                	mv	a1,s5
    1424:	00004097          	auipc	ra,0x4
    1428:	49c080e7          	jalr	1180(ra) # 58c0 <write>
      if(n != 10){
    142c:	47a9                	li	a5,10
    142e:	06f51f63          	bne	a0,a5,14ac <truncate3+0xf0>
      close(fd);
    1432:	8526                	mv	a0,s1
    1434:	00004097          	auipc	ra,0x4
    1438:	494080e7          	jalr	1172(ra) # 58c8 <close>
      fd = open("truncfile", O_RDONLY);
    143c:	4581                	li	a1,0
    143e:	854e                	mv	a0,s3
    1440:	00004097          	auipc	ra,0x4
    1444:	4a0080e7          	jalr	1184(ra) # 58e0 <open>
    1448:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    144a:	02000613          	li	a2,32
    144e:	f9840593          	addi	a1,s0,-104
    1452:	00004097          	auipc	ra,0x4
    1456:	466080e7          	jalr	1126(ra) # 58b8 <read>
      close(fd);
    145a:	8526                	mv	a0,s1
    145c:	00004097          	auipc	ra,0x4
    1460:	46c080e7          	jalr	1132(ra) # 58c8 <close>
    for(int i = 0; i < 100; i++){
    1464:	397d                	addiw	s2,s2,-1
    1466:	fa0914e3          	bnez	s2,140e <truncate3+0x52>
    exit(0);
    146a:	4501                	li	a0,0
    146c:	00004097          	auipc	ra,0x4
    1470:	434080e7          	jalr	1076(ra) # 58a0 <exit>
    printf("%s: fork failed\n", s);
    1474:	85d2                	mv	a1,s4
    1476:	00005517          	auipc	a0,0x5
    147a:	60250513          	addi	a0,a0,1538 # 6a78 <malloc+0xd88>
    147e:	00004097          	auipc	ra,0x4
    1482:	7b2080e7          	jalr	1970(ra) # 5c30 <printf>
    exit(1);
    1486:	4505                	li	a0,1
    1488:	00004097          	auipc	ra,0x4
    148c:	418080e7          	jalr	1048(ra) # 58a0 <exit>
        printf("%s: open failed\n", s);
    1490:	85d2                	mv	a1,s4
    1492:	00005517          	auipc	a0,0x5
    1496:	5fe50513          	addi	a0,a0,1534 # 6a90 <malloc+0xda0>
    149a:	00004097          	auipc	ra,0x4
    149e:	796080e7          	jalr	1942(ra) # 5c30 <printf>
        exit(1);
    14a2:	4505                	li	a0,1
    14a4:	00004097          	auipc	ra,0x4
    14a8:	3fc080e7          	jalr	1020(ra) # 58a0 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14ac:	862a                	mv	a2,a0
    14ae:	85d2                	mv	a1,s4
    14b0:	00005517          	auipc	a0,0x5
    14b4:	60850513          	addi	a0,a0,1544 # 6ab8 <malloc+0xdc8>
    14b8:	00004097          	auipc	ra,0x4
    14bc:	778080e7          	jalr	1912(ra) # 5c30 <printf>
        exit(1);
    14c0:	4505                	li	a0,1
    14c2:	00004097          	auipc	ra,0x4
    14c6:	3de080e7          	jalr	990(ra) # 58a0 <exit>
    14ca:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ce:	00005997          	auipc	s3,0x5
    14d2:	daa98993          	addi	s3,s3,-598 # 6278 <malloc+0x588>
    int n = write(fd, "xxx", 3);
    14d6:	00005a97          	auipc	s5,0x5
    14da:	602a8a93          	addi	s5,s5,1538 # 6ad8 <malloc+0xde8>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14de:	60100593          	li	a1,1537
    14e2:	854e                	mv	a0,s3
    14e4:	00004097          	auipc	ra,0x4
    14e8:	3fc080e7          	jalr	1020(ra) # 58e0 <open>
    14ec:	84aa                	mv	s1,a0
    if(fd < 0){
    14ee:	04054763          	bltz	a0,153c <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14f2:	460d                	li	a2,3
    14f4:	85d6                	mv	a1,s5
    14f6:	00004097          	auipc	ra,0x4
    14fa:	3ca080e7          	jalr	970(ra) # 58c0 <write>
    if(n != 3){
    14fe:	478d                	li	a5,3
    1500:	04f51c63          	bne	a0,a5,1558 <truncate3+0x19c>
    close(fd);
    1504:	8526                	mv	a0,s1
    1506:	00004097          	auipc	ra,0x4
    150a:	3c2080e7          	jalr	962(ra) # 58c8 <close>
  for(int i = 0; i < 150; i++){
    150e:	397d                	addiw	s2,s2,-1
    1510:	fc0917e3          	bnez	s2,14de <truncate3+0x122>
  wait(&xstatus);
    1514:	fbc40513          	addi	a0,s0,-68
    1518:	00004097          	auipc	ra,0x4
    151c:	390080e7          	jalr	912(ra) # 58a8 <wait>
  unlink("truncfile");
    1520:	00005517          	auipc	a0,0x5
    1524:	d5850513          	addi	a0,a0,-680 # 6278 <malloc+0x588>
    1528:	00004097          	auipc	ra,0x4
    152c:	3c8080e7          	jalr	968(ra) # 58f0 <unlink>
  exit(xstatus);
    1530:	fbc42503          	lw	a0,-68(s0)
    1534:	00004097          	auipc	ra,0x4
    1538:	36c080e7          	jalr	876(ra) # 58a0 <exit>
      printf("%s: open failed\n", s);
    153c:	85d2                	mv	a1,s4
    153e:	00005517          	auipc	a0,0x5
    1542:	55250513          	addi	a0,a0,1362 # 6a90 <malloc+0xda0>
    1546:	00004097          	auipc	ra,0x4
    154a:	6ea080e7          	jalr	1770(ra) # 5c30 <printf>
      exit(1);
    154e:	4505                	li	a0,1
    1550:	00004097          	auipc	ra,0x4
    1554:	350080e7          	jalr	848(ra) # 58a0 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1558:	862a                	mv	a2,a0
    155a:	85d2                	mv	a1,s4
    155c:	00005517          	auipc	a0,0x5
    1560:	58450513          	addi	a0,a0,1412 # 6ae0 <malloc+0xdf0>
    1564:	00004097          	auipc	ra,0x4
    1568:	6cc080e7          	jalr	1740(ra) # 5c30 <printf>
      exit(1);
    156c:	4505                	li	a0,1
    156e:	00004097          	auipc	ra,0x4
    1572:	332080e7          	jalr	818(ra) # 58a0 <exit>

0000000000001576 <exectest>:
{
    1576:	715d                	addi	sp,sp,-80
    1578:	e486                	sd	ra,72(sp)
    157a:	e0a2                	sd	s0,64(sp)
    157c:	fc26                	sd	s1,56(sp)
    157e:	f84a                	sd	s2,48(sp)
    1580:	0880                	addi	s0,sp,80
    1582:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1584:	00005797          	auipc	a5,0x5
    1588:	c9c78793          	addi	a5,a5,-868 # 6220 <malloc+0x530>
    158c:	fcf43023          	sd	a5,-64(s0)
    1590:	00005797          	auipc	a5,0x5
    1594:	57078793          	addi	a5,a5,1392 # 6b00 <malloc+0xe10>
    1598:	fcf43423          	sd	a5,-56(s0)
    159c:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    15a0:	00005517          	auipc	a0,0x5
    15a4:	56850513          	addi	a0,a0,1384 # 6b08 <malloc+0xe18>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	348080e7          	jalr	840(ra) # 58f0 <unlink>
  pid = fork();
    15b0:	00004097          	auipc	ra,0x4
    15b4:	2e8080e7          	jalr	744(ra) # 5898 <fork>
  if(pid < 0) {
    15b8:	04054663          	bltz	a0,1604 <exectest+0x8e>
    15bc:	84aa                	mv	s1,a0
  if(pid == 0) {
    15be:	e959                	bnez	a0,1654 <exectest+0xde>
    close(1);
    15c0:	4505                	li	a0,1
    15c2:	00004097          	auipc	ra,0x4
    15c6:	306080e7          	jalr	774(ra) # 58c8 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15ca:	20100593          	li	a1,513
    15ce:	00005517          	auipc	a0,0x5
    15d2:	53a50513          	addi	a0,a0,1338 # 6b08 <malloc+0xe18>
    15d6:	00004097          	auipc	ra,0x4
    15da:	30a080e7          	jalr	778(ra) # 58e0 <open>
    if(fd < 0) {
    15de:	04054163          	bltz	a0,1620 <exectest+0xaa>
    if(fd != 1) {
    15e2:	4785                	li	a5,1
    15e4:	04f50c63          	beq	a0,a5,163c <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15e8:	85ca                	mv	a1,s2
    15ea:	00005517          	auipc	a0,0x5
    15ee:	53e50513          	addi	a0,a0,1342 # 6b28 <malloc+0xe38>
    15f2:	00004097          	auipc	ra,0x4
    15f6:	63e080e7          	jalr	1598(ra) # 5c30 <printf>
      exit(1);
    15fa:	4505                	li	a0,1
    15fc:	00004097          	auipc	ra,0x4
    1600:	2a4080e7          	jalr	676(ra) # 58a0 <exit>
     printf("%s: fork failed\n", s);
    1604:	85ca                	mv	a1,s2
    1606:	00005517          	auipc	a0,0x5
    160a:	47250513          	addi	a0,a0,1138 # 6a78 <malloc+0xd88>
    160e:	00004097          	auipc	ra,0x4
    1612:	622080e7          	jalr	1570(ra) # 5c30 <printf>
     exit(1);
    1616:	4505                	li	a0,1
    1618:	00004097          	auipc	ra,0x4
    161c:	288080e7          	jalr	648(ra) # 58a0 <exit>
      printf("%s: create failed\n", s);
    1620:	85ca                	mv	a1,s2
    1622:	00005517          	auipc	a0,0x5
    1626:	4ee50513          	addi	a0,a0,1262 # 6b10 <malloc+0xe20>
    162a:	00004097          	auipc	ra,0x4
    162e:	606080e7          	jalr	1542(ra) # 5c30 <printf>
      exit(1);
    1632:	4505                	li	a0,1
    1634:	00004097          	auipc	ra,0x4
    1638:	26c080e7          	jalr	620(ra) # 58a0 <exit>
    if(exec("echo", echoargv) < 0){
    163c:	fc040593          	addi	a1,s0,-64
    1640:	00005517          	auipc	a0,0x5
    1644:	be050513          	addi	a0,a0,-1056 # 6220 <malloc+0x530>
    1648:	00004097          	auipc	ra,0x4
    164c:	290080e7          	jalr	656(ra) # 58d8 <exec>
    1650:	02054163          	bltz	a0,1672 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1654:	fdc40513          	addi	a0,s0,-36
    1658:	00004097          	auipc	ra,0x4
    165c:	250080e7          	jalr	592(ra) # 58a8 <wait>
    1660:	02951763          	bne	a0,s1,168e <exectest+0x118>
  if(xstatus != 0)
    1664:	fdc42503          	lw	a0,-36(s0)
    1668:	cd0d                	beqz	a0,16a2 <exectest+0x12c>
    exit(xstatus);
    166a:	00004097          	auipc	ra,0x4
    166e:	236080e7          	jalr	566(ra) # 58a0 <exit>
      printf("%s: exec echo failed\n", s);
    1672:	85ca                	mv	a1,s2
    1674:	00005517          	auipc	a0,0x5
    1678:	4c450513          	addi	a0,a0,1220 # 6b38 <malloc+0xe48>
    167c:	00004097          	auipc	ra,0x4
    1680:	5b4080e7          	jalr	1460(ra) # 5c30 <printf>
      exit(1);
    1684:	4505                	li	a0,1
    1686:	00004097          	auipc	ra,0x4
    168a:	21a080e7          	jalr	538(ra) # 58a0 <exit>
    printf("%s: wait failed!\n", s);
    168e:	85ca                	mv	a1,s2
    1690:	00005517          	auipc	a0,0x5
    1694:	4c050513          	addi	a0,a0,1216 # 6b50 <malloc+0xe60>
    1698:	00004097          	auipc	ra,0x4
    169c:	598080e7          	jalr	1432(ra) # 5c30 <printf>
    16a0:	b7d1                	j	1664 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    16a2:	4581                	li	a1,0
    16a4:	00005517          	auipc	a0,0x5
    16a8:	46450513          	addi	a0,a0,1124 # 6b08 <malloc+0xe18>
    16ac:	00004097          	auipc	ra,0x4
    16b0:	234080e7          	jalr	564(ra) # 58e0 <open>
  if(fd < 0) {
    16b4:	02054a63          	bltz	a0,16e8 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16b8:	4609                	li	a2,2
    16ba:	fb840593          	addi	a1,s0,-72
    16be:	00004097          	auipc	ra,0x4
    16c2:	1fa080e7          	jalr	506(ra) # 58b8 <read>
    16c6:	4789                	li	a5,2
    16c8:	02f50e63          	beq	a0,a5,1704 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16cc:	85ca                	mv	a1,s2
    16ce:	00005517          	auipc	a0,0x5
    16d2:	ef250513          	addi	a0,a0,-270 # 65c0 <malloc+0x8d0>
    16d6:	00004097          	auipc	ra,0x4
    16da:	55a080e7          	jalr	1370(ra) # 5c30 <printf>
    exit(1);
    16de:	4505                	li	a0,1
    16e0:	00004097          	auipc	ra,0x4
    16e4:	1c0080e7          	jalr	448(ra) # 58a0 <exit>
    printf("%s: open failed\n", s);
    16e8:	85ca                	mv	a1,s2
    16ea:	00005517          	auipc	a0,0x5
    16ee:	3a650513          	addi	a0,a0,934 # 6a90 <malloc+0xda0>
    16f2:	00004097          	auipc	ra,0x4
    16f6:	53e080e7          	jalr	1342(ra) # 5c30 <printf>
    exit(1);
    16fa:	4505                	li	a0,1
    16fc:	00004097          	auipc	ra,0x4
    1700:	1a4080e7          	jalr	420(ra) # 58a0 <exit>
  unlink("echo-ok");
    1704:	00005517          	auipc	a0,0x5
    1708:	40450513          	addi	a0,a0,1028 # 6b08 <malloc+0xe18>
    170c:	00004097          	auipc	ra,0x4
    1710:	1e4080e7          	jalr	484(ra) # 58f0 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1714:	fb844703          	lbu	a4,-72(s0)
    1718:	04f00793          	li	a5,79
    171c:	00f71863          	bne	a4,a5,172c <exectest+0x1b6>
    1720:	fb944703          	lbu	a4,-71(s0)
    1724:	04b00793          	li	a5,75
    1728:	02f70063          	beq	a4,a5,1748 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    172c:	85ca                	mv	a1,s2
    172e:	00005517          	auipc	a0,0x5
    1732:	43a50513          	addi	a0,a0,1082 # 6b68 <malloc+0xe78>
    1736:	00004097          	auipc	ra,0x4
    173a:	4fa080e7          	jalr	1274(ra) # 5c30 <printf>
    exit(1);
    173e:	4505                	li	a0,1
    1740:	00004097          	auipc	ra,0x4
    1744:	160080e7          	jalr	352(ra) # 58a0 <exit>
    exit(0);
    1748:	4501                	li	a0,0
    174a:	00004097          	auipc	ra,0x4
    174e:	156080e7          	jalr	342(ra) # 58a0 <exit>

0000000000001752 <pipe1>:
{
    1752:	715d                	addi	sp,sp,-80
    1754:	e486                	sd	ra,72(sp)
    1756:	e0a2                	sd	s0,64(sp)
    1758:	fc26                	sd	s1,56(sp)
    175a:	f84a                	sd	s2,48(sp)
    175c:	f44e                	sd	s3,40(sp)
    175e:	f052                	sd	s4,32(sp)
    1760:	ec56                	sd	s5,24(sp)
    1762:	e85a                	sd	s6,16(sp)
    1764:	0880                	addi	s0,sp,80
    1766:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    1768:	fb840513          	addi	a0,s0,-72
    176c:	00004097          	auipc	ra,0x4
    1770:	144080e7          	jalr	324(ra) # 58b0 <pipe>
    1774:	e935                	bnez	a0,17e8 <pipe1+0x96>
    1776:	84aa                	mv	s1,a0
  pid = fork();
    1778:	00004097          	auipc	ra,0x4
    177c:	120080e7          	jalr	288(ra) # 5898 <fork>
  if(pid == 0){
    1780:	c151                	beqz	a0,1804 <pipe1+0xb2>
  } else if(pid > 0){
    1782:	18a05963          	blez	a0,1914 <pipe1+0x1c2>
    close(fds[1]);
    1786:	fbc42503          	lw	a0,-68(s0)
    178a:	00004097          	auipc	ra,0x4
    178e:	13e080e7          	jalr	318(ra) # 58c8 <close>
    total = 0;
    1792:	8aa6                	mv	s5,s1
    cc = 1;
    1794:	4a05                	li	s4,1
    while((n = read(fds[0], buf, cc)) > 0){
    1796:	0000a917          	auipc	s2,0xa
    179a:	66290913          	addi	s2,s2,1634 # bdf8 <buf>
      if(cc > sizeof(buf))
    179e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17a0:	8652                	mv	a2,s4
    17a2:	85ca                	mv	a1,s2
    17a4:	fb842503          	lw	a0,-72(s0)
    17a8:	00004097          	auipc	ra,0x4
    17ac:	110080e7          	jalr	272(ra) # 58b8 <read>
    17b0:	10a05d63          	blez	a0,18ca <pipe1+0x178>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b4:	0014879b          	addiw	a5,s1,1
    17b8:	00094683          	lbu	a3,0(s2)
    17bc:	0ff4f713          	andi	a4,s1,255
    17c0:	0ce69863          	bne	a3,a4,1890 <pipe1+0x13e>
    17c4:	0000a717          	auipc	a4,0xa
    17c8:	63570713          	addi	a4,a4,1589 # bdf9 <buf+0x1>
    17cc:	9ca9                	addw	s1,s1,a0
      for(i = 0; i < n; i++){
    17ce:	0e978463          	beq	a5,s1,18b6 <pipe1+0x164>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d2:	00074683          	lbu	a3,0(a4)
    17d6:	0017861b          	addiw	a2,a5,1
    17da:	0705                	addi	a4,a4,1
    17dc:	0ff7f793          	andi	a5,a5,255
    17e0:	0af69863          	bne	a3,a5,1890 <pipe1+0x13e>
    17e4:	87b2                	mv	a5,a2
    17e6:	b7e5                	j	17ce <pipe1+0x7c>
    printf("%s: pipe() failed\n", s);
    17e8:	85ce                	mv	a1,s3
    17ea:	00005517          	auipc	a0,0x5
    17ee:	39650513          	addi	a0,a0,918 # 6b80 <malloc+0xe90>
    17f2:	00004097          	auipc	ra,0x4
    17f6:	43e080e7          	jalr	1086(ra) # 5c30 <printf>
    exit(1);
    17fa:	4505                	li	a0,1
    17fc:	00004097          	auipc	ra,0x4
    1800:	0a4080e7          	jalr	164(ra) # 58a0 <exit>
    close(fds[0]);
    1804:	fb842503          	lw	a0,-72(s0)
    1808:	00004097          	auipc	ra,0x4
    180c:	0c0080e7          	jalr	192(ra) # 58c8 <close>
    for(n = 0; n < N; n++){
    1810:	0000aa97          	auipc	s5,0xa
    1814:	5e8a8a93          	addi	s5,s5,1512 # bdf8 <buf>
    1818:	0ffaf793          	andi	a5,s5,255
    181c:	40f004b3          	neg	s1,a5
    1820:	0ff4f493          	andi	s1,s1,255
    1824:	02d00a13          	li	s4,45
    1828:	40fa0a3b          	subw	s4,s4,a5
    182c:	0ffa7a13          	andi	s4,s4,255
    1830:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
    1834:	8b56                	mv	s6,s5
{
    1836:	87d6                	mv	a5,s5
        buf[i] = seq++;
    1838:	0097873b          	addw	a4,a5,s1
    183c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1840:	0785                	addi	a5,a5,1
    1842:	fef91be3          	bne	s2,a5,1838 <pipe1+0xe6>
      if(write(fds[1], buf, SZ) != SZ){
    1846:	40900613          	li	a2,1033
    184a:	85da                	mv	a1,s6
    184c:	fbc42503          	lw	a0,-68(s0)
    1850:	00004097          	auipc	ra,0x4
    1854:	070080e7          	jalr	112(ra) # 58c0 <write>
    1858:	40900793          	li	a5,1033
    185c:	00f51c63          	bne	a0,a5,1874 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1860:	24a5                	addiw	s1,s1,9
    1862:	0ff4f493          	andi	s1,s1,255
    1866:	fd4498e3          	bne	s1,s4,1836 <pipe1+0xe4>
    exit(0);
    186a:	4501                	li	a0,0
    186c:	00004097          	auipc	ra,0x4
    1870:	034080e7          	jalr	52(ra) # 58a0 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1874:	85ce                	mv	a1,s3
    1876:	00005517          	auipc	a0,0x5
    187a:	32250513          	addi	a0,a0,802 # 6b98 <malloc+0xea8>
    187e:	00004097          	auipc	ra,0x4
    1882:	3b2080e7          	jalr	946(ra) # 5c30 <printf>
        exit(1);
    1886:	4505                	li	a0,1
    1888:	00004097          	auipc	ra,0x4
    188c:	018080e7          	jalr	24(ra) # 58a0 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1890:	85ce                	mv	a1,s3
    1892:	00005517          	auipc	a0,0x5
    1896:	31e50513          	addi	a0,a0,798 # 6bb0 <malloc+0xec0>
    189a:	00004097          	auipc	ra,0x4
    189e:	396080e7          	jalr	918(ra) # 5c30 <printf>
}
    18a2:	60a6                	ld	ra,72(sp)
    18a4:	6406                	ld	s0,64(sp)
    18a6:	74e2                	ld	s1,56(sp)
    18a8:	7942                	ld	s2,48(sp)
    18aa:	79a2                	ld	s3,40(sp)
    18ac:	7a02                	ld	s4,32(sp)
    18ae:	6ae2                	ld	s5,24(sp)
    18b0:	6b42                	ld	s6,16(sp)
    18b2:	6161                	addi	sp,sp,80
    18b4:	8082                	ret
      total += n;
    18b6:	00aa8abb          	addw	s5,s5,a0
      cc = cc * 2;
    18ba:	001a179b          	slliw	a5,s4,0x1
    18be:	00078a1b          	sext.w	s4,a5
      if(cc > sizeof(buf))
    18c2:	ed4b7fe3          	bgeu	s6,s4,17a0 <pipe1+0x4e>
        cc = sizeof(buf);
    18c6:	8a5a                	mv	s4,s6
    18c8:	bde1                	j	17a0 <pipe1+0x4e>
    if(total != N * SZ){
    18ca:	6785                	lui	a5,0x1
    18cc:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x71>
    18d0:	02fa8063          	beq	s5,a5,18f0 <pipe1+0x19e>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18d4:	85d6                	mv	a1,s5
    18d6:	00005517          	auipc	a0,0x5
    18da:	2f250513          	addi	a0,a0,754 # 6bc8 <malloc+0xed8>
    18de:	00004097          	auipc	ra,0x4
    18e2:	352080e7          	jalr	850(ra) # 5c30 <printf>
      exit(1);
    18e6:	4505                	li	a0,1
    18e8:	00004097          	auipc	ra,0x4
    18ec:	fb8080e7          	jalr	-72(ra) # 58a0 <exit>
    close(fds[0]);
    18f0:	fb842503          	lw	a0,-72(s0)
    18f4:	00004097          	auipc	ra,0x4
    18f8:	fd4080e7          	jalr	-44(ra) # 58c8 <close>
    wait(&xstatus);
    18fc:	fb440513          	addi	a0,s0,-76
    1900:	00004097          	auipc	ra,0x4
    1904:	fa8080e7          	jalr	-88(ra) # 58a8 <wait>
    exit(xstatus);
    1908:	fb442503          	lw	a0,-76(s0)
    190c:	00004097          	auipc	ra,0x4
    1910:	f94080e7          	jalr	-108(ra) # 58a0 <exit>
    printf("%s: fork() failed\n", s);
    1914:	85ce                	mv	a1,s3
    1916:	00005517          	auipc	a0,0x5
    191a:	2d250513          	addi	a0,a0,722 # 6be8 <malloc+0xef8>
    191e:	00004097          	auipc	ra,0x4
    1922:	312080e7          	jalr	786(ra) # 5c30 <printf>
    exit(1);
    1926:	4505                	li	a0,1
    1928:	00004097          	auipc	ra,0x4
    192c:	f78080e7          	jalr	-136(ra) # 58a0 <exit>

0000000000001930 <exitwait>:
{
    1930:	7139                	addi	sp,sp,-64
    1932:	fc06                	sd	ra,56(sp)
    1934:	f822                	sd	s0,48(sp)
    1936:	f426                	sd	s1,40(sp)
    1938:	f04a                	sd	s2,32(sp)
    193a:	ec4e                	sd	s3,24(sp)
    193c:	e852                	sd	s4,16(sp)
    193e:	0080                	addi	s0,sp,64
    1940:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1942:	4481                	li	s1,0
    1944:	06400993          	li	s3,100
    pid = fork();
    1948:	00004097          	auipc	ra,0x4
    194c:	f50080e7          	jalr	-176(ra) # 5898 <fork>
    1950:	892a                	mv	s2,a0
    if(pid < 0){
    1952:	02054a63          	bltz	a0,1986 <exitwait+0x56>
    if(pid){
    1956:	c151                	beqz	a0,19da <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1958:	fcc40513          	addi	a0,s0,-52
    195c:	00004097          	auipc	ra,0x4
    1960:	f4c080e7          	jalr	-180(ra) # 58a8 <wait>
    1964:	03251f63          	bne	a0,s2,19a2 <exitwait+0x72>
      if(i != xstate) {
    1968:	fcc42783          	lw	a5,-52(s0)
    196c:	04979963          	bne	a5,s1,19be <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1970:	2485                	addiw	s1,s1,1
    1972:	fd349be3          	bne	s1,s3,1948 <exitwait+0x18>
}
    1976:	70e2                	ld	ra,56(sp)
    1978:	7442                	ld	s0,48(sp)
    197a:	74a2                	ld	s1,40(sp)
    197c:	7902                	ld	s2,32(sp)
    197e:	69e2                	ld	s3,24(sp)
    1980:	6a42                	ld	s4,16(sp)
    1982:	6121                	addi	sp,sp,64
    1984:	8082                	ret
      printf("%s: fork failed\n", s);
    1986:	85d2                	mv	a1,s4
    1988:	00005517          	auipc	a0,0x5
    198c:	0f050513          	addi	a0,a0,240 # 6a78 <malloc+0xd88>
    1990:	00004097          	auipc	ra,0x4
    1994:	2a0080e7          	jalr	672(ra) # 5c30 <printf>
      exit(1);
    1998:	4505                	li	a0,1
    199a:	00004097          	auipc	ra,0x4
    199e:	f06080e7          	jalr	-250(ra) # 58a0 <exit>
        printf("%s: wait wrong pid\n", s);
    19a2:	85d2                	mv	a1,s4
    19a4:	00005517          	auipc	a0,0x5
    19a8:	25c50513          	addi	a0,a0,604 # 6c00 <malloc+0xf10>
    19ac:	00004097          	auipc	ra,0x4
    19b0:	284080e7          	jalr	644(ra) # 5c30 <printf>
        exit(1);
    19b4:	4505                	li	a0,1
    19b6:	00004097          	auipc	ra,0x4
    19ba:	eea080e7          	jalr	-278(ra) # 58a0 <exit>
        printf("%s: wait wrong exit status\n", s);
    19be:	85d2                	mv	a1,s4
    19c0:	00005517          	auipc	a0,0x5
    19c4:	25850513          	addi	a0,a0,600 # 6c18 <malloc+0xf28>
    19c8:	00004097          	auipc	ra,0x4
    19cc:	268080e7          	jalr	616(ra) # 5c30 <printf>
        exit(1);
    19d0:	4505                	li	a0,1
    19d2:	00004097          	auipc	ra,0x4
    19d6:	ece080e7          	jalr	-306(ra) # 58a0 <exit>
      exit(i);
    19da:	8526                	mv	a0,s1
    19dc:	00004097          	auipc	ra,0x4
    19e0:	ec4080e7          	jalr	-316(ra) # 58a0 <exit>

00000000000019e4 <twochildren>:
{
    19e4:	1101                	addi	sp,sp,-32
    19e6:	ec06                	sd	ra,24(sp)
    19e8:	e822                	sd	s0,16(sp)
    19ea:	e426                	sd	s1,8(sp)
    19ec:	e04a                	sd	s2,0(sp)
    19ee:	1000                	addi	s0,sp,32
    19f0:	892a                	mv	s2,a0
    19f2:	3e800493          	li	s1,1000
    int pid1 = fork();
    19f6:	00004097          	auipc	ra,0x4
    19fa:	ea2080e7          	jalr	-350(ra) # 5898 <fork>
    if(pid1 < 0){
    19fe:	02054c63          	bltz	a0,1a36 <twochildren+0x52>
    if(pid1 == 0){
    1a02:	c921                	beqz	a0,1a52 <twochildren+0x6e>
      int pid2 = fork();
    1a04:	00004097          	auipc	ra,0x4
    1a08:	e94080e7          	jalr	-364(ra) # 5898 <fork>
      if(pid2 < 0){
    1a0c:	04054763          	bltz	a0,1a5a <twochildren+0x76>
      if(pid2 == 0){
    1a10:	c13d                	beqz	a0,1a76 <twochildren+0x92>
        wait(0);
    1a12:	4501                	li	a0,0
    1a14:	00004097          	auipc	ra,0x4
    1a18:	e94080e7          	jalr	-364(ra) # 58a8 <wait>
        wait(0);
    1a1c:	4501                	li	a0,0
    1a1e:	00004097          	auipc	ra,0x4
    1a22:	e8a080e7          	jalr	-374(ra) # 58a8 <wait>
  for(int i = 0; i < 1000; i++){
    1a26:	34fd                	addiw	s1,s1,-1
    1a28:	f4f9                	bnez	s1,19f6 <twochildren+0x12>
}
    1a2a:	60e2                	ld	ra,24(sp)
    1a2c:	6442                	ld	s0,16(sp)
    1a2e:	64a2                	ld	s1,8(sp)
    1a30:	6902                	ld	s2,0(sp)
    1a32:	6105                	addi	sp,sp,32
    1a34:	8082                	ret
      printf("%s: fork failed\n", s);
    1a36:	85ca                	mv	a1,s2
    1a38:	00005517          	auipc	a0,0x5
    1a3c:	04050513          	addi	a0,a0,64 # 6a78 <malloc+0xd88>
    1a40:	00004097          	auipc	ra,0x4
    1a44:	1f0080e7          	jalr	496(ra) # 5c30 <printf>
      exit(1);
    1a48:	4505                	li	a0,1
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	e56080e7          	jalr	-426(ra) # 58a0 <exit>
      exit(0);
    1a52:	00004097          	auipc	ra,0x4
    1a56:	e4e080e7          	jalr	-434(ra) # 58a0 <exit>
        printf("%s: fork failed\n", s);
    1a5a:	85ca                	mv	a1,s2
    1a5c:	00005517          	auipc	a0,0x5
    1a60:	01c50513          	addi	a0,a0,28 # 6a78 <malloc+0xd88>
    1a64:	00004097          	auipc	ra,0x4
    1a68:	1cc080e7          	jalr	460(ra) # 5c30 <printf>
        exit(1);
    1a6c:	4505                	li	a0,1
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	e32080e7          	jalr	-462(ra) # 58a0 <exit>
        exit(0);
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	e2a080e7          	jalr	-470(ra) # 58a0 <exit>

0000000000001a7e <forkfork>:
{
    1a7e:	7179                	addi	sp,sp,-48
    1a80:	f406                	sd	ra,40(sp)
    1a82:	f022                	sd	s0,32(sp)
    1a84:	ec26                	sd	s1,24(sp)
    1a86:	1800                	addi	s0,sp,48
    1a88:	84aa                	mv	s1,a0
    int pid = fork();
    1a8a:	00004097          	auipc	ra,0x4
    1a8e:	e0e080e7          	jalr	-498(ra) # 5898 <fork>
    if(pid < 0){
    1a92:	04054163          	bltz	a0,1ad4 <forkfork+0x56>
    if(pid == 0){
    1a96:	cd29                	beqz	a0,1af0 <forkfork+0x72>
    int pid = fork();
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	e00080e7          	jalr	-512(ra) # 5898 <fork>
    if(pid < 0){
    1aa0:	02054a63          	bltz	a0,1ad4 <forkfork+0x56>
    if(pid == 0){
    1aa4:	c531                	beqz	a0,1af0 <forkfork+0x72>
    wait(&xstatus);
    1aa6:	fdc40513          	addi	a0,s0,-36
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	dfe080e7          	jalr	-514(ra) # 58a8 <wait>
    if(xstatus != 0) {
    1ab2:	fdc42783          	lw	a5,-36(s0)
    1ab6:	ebbd                	bnez	a5,1b2c <forkfork+0xae>
    wait(&xstatus);
    1ab8:	fdc40513          	addi	a0,s0,-36
    1abc:	00004097          	auipc	ra,0x4
    1ac0:	dec080e7          	jalr	-532(ra) # 58a8 <wait>
    if(xstatus != 0) {
    1ac4:	fdc42783          	lw	a5,-36(s0)
    1ac8:	e3b5                	bnez	a5,1b2c <forkfork+0xae>
}
    1aca:	70a2                	ld	ra,40(sp)
    1acc:	7402                	ld	s0,32(sp)
    1ace:	64e2                	ld	s1,24(sp)
    1ad0:	6145                	addi	sp,sp,48
    1ad2:	8082                	ret
      printf("%s: fork failed", s);
    1ad4:	85a6                	mv	a1,s1
    1ad6:	00005517          	auipc	a0,0x5
    1ada:	16250513          	addi	a0,a0,354 # 6c38 <malloc+0xf48>
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	152080e7          	jalr	338(ra) # 5c30 <printf>
      exit(1);
    1ae6:	4505                	li	a0,1
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	db8080e7          	jalr	-584(ra) # 58a0 <exit>
{
    1af0:	0c800493          	li	s1,200
        int pid1 = fork();
    1af4:	00004097          	auipc	ra,0x4
    1af8:	da4080e7          	jalr	-604(ra) # 5898 <fork>
        if(pid1 < 0){
    1afc:	00054f63          	bltz	a0,1b1a <forkfork+0x9c>
        if(pid1 == 0){
    1b00:	c115                	beqz	a0,1b24 <forkfork+0xa6>
        wait(0);
    1b02:	4501                	li	a0,0
    1b04:	00004097          	auipc	ra,0x4
    1b08:	da4080e7          	jalr	-604(ra) # 58a8 <wait>
      for(int j = 0; j < 200; j++){
    1b0c:	34fd                	addiw	s1,s1,-1
    1b0e:	f0fd                	bnez	s1,1af4 <forkfork+0x76>
      exit(0);
    1b10:	4501                	li	a0,0
    1b12:	00004097          	auipc	ra,0x4
    1b16:	d8e080e7          	jalr	-626(ra) # 58a0 <exit>
          exit(1);
    1b1a:	4505                	li	a0,1
    1b1c:	00004097          	auipc	ra,0x4
    1b20:	d84080e7          	jalr	-636(ra) # 58a0 <exit>
          exit(0);
    1b24:	00004097          	auipc	ra,0x4
    1b28:	d7c080e7          	jalr	-644(ra) # 58a0 <exit>
      printf("%s: fork in child failed", s);
    1b2c:	85a6                	mv	a1,s1
    1b2e:	00005517          	auipc	a0,0x5
    1b32:	11a50513          	addi	a0,a0,282 # 6c48 <malloc+0xf58>
    1b36:	00004097          	auipc	ra,0x4
    1b3a:	0fa080e7          	jalr	250(ra) # 5c30 <printf>
      exit(1);
    1b3e:	4505                	li	a0,1
    1b40:	00004097          	auipc	ra,0x4
    1b44:	d60080e7          	jalr	-672(ra) # 58a0 <exit>

0000000000001b48 <reparent2>:
{
    1b48:	1101                	addi	sp,sp,-32
    1b4a:	ec06                	sd	ra,24(sp)
    1b4c:	e822                	sd	s0,16(sp)
    1b4e:	e426                	sd	s1,8(sp)
    1b50:	1000                	addi	s0,sp,32
    1b52:	32000493          	li	s1,800
    int pid1 = fork();
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	d42080e7          	jalr	-702(ra) # 5898 <fork>
    if(pid1 < 0){
    1b5e:	00054f63          	bltz	a0,1b7c <reparent2+0x34>
    if(pid1 == 0){
    1b62:	c915                	beqz	a0,1b96 <reparent2+0x4e>
    wait(0);
    1b64:	4501                	li	a0,0
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	d42080e7          	jalr	-702(ra) # 58a8 <wait>
  for(int i = 0; i < 800; i++){
    1b6e:	34fd                	addiw	s1,s1,-1
    1b70:	f0fd                	bnez	s1,1b56 <reparent2+0xe>
  exit(0);
    1b72:	4501                	li	a0,0
    1b74:	00004097          	auipc	ra,0x4
    1b78:	d2c080e7          	jalr	-724(ra) # 58a0 <exit>
      printf("fork failed\n");
    1b7c:	00005517          	auipc	a0,0x5
    1b80:	31c50513          	addi	a0,a0,796 # 6e98 <malloc+0x11a8>
    1b84:	00004097          	auipc	ra,0x4
    1b88:	0ac080e7          	jalr	172(ra) # 5c30 <printf>
      exit(1);
    1b8c:	4505                	li	a0,1
    1b8e:	00004097          	auipc	ra,0x4
    1b92:	d12080e7          	jalr	-750(ra) # 58a0 <exit>
      fork();
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	d02080e7          	jalr	-766(ra) # 5898 <fork>
      fork();
    1b9e:	00004097          	auipc	ra,0x4
    1ba2:	cfa080e7          	jalr	-774(ra) # 5898 <fork>
      exit(0);
    1ba6:	4501                	li	a0,0
    1ba8:	00004097          	auipc	ra,0x4
    1bac:	cf8080e7          	jalr	-776(ra) # 58a0 <exit>

0000000000001bb0 <createdelete>:
{
    1bb0:	7175                	addi	sp,sp,-144
    1bb2:	e506                	sd	ra,136(sp)
    1bb4:	e122                	sd	s0,128(sp)
    1bb6:	fca6                	sd	s1,120(sp)
    1bb8:	f8ca                	sd	s2,112(sp)
    1bba:	f4ce                	sd	s3,104(sp)
    1bbc:	f0d2                	sd	s4,96(sp)
    1bbe:	ecd6                	sd	s5,88(sp)
    1bc0:	e8da                	sd	s6,80(sp)
    1bc2:	e4de                	sd	s7,72(sp)
    1bc4:	e0e2                	sd	s8,64(sp)
    1bc6:	fc66                	sd	s9,56(sp)
    1bc8:	0900                	addi	s0,sp,144
    1bca:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bcc:	4901                	li	s2,0
    1bce:	4991                	li	s3,4
    pid = fork();
    1bd0:	00004097          	auipc	ra,0x4
    1bd4:	cc8080e7          	jalr	-824(ra) # 5898 <fork>
    1bd8:	84aa                	mv	s1,a0
    if(pid < 0){
    1bda:	02054f63          	bltz	a0,1c18 <createdelete+0x68>
    if(pid == 0){
    1bde:	c939                	beqz	a0,1c34 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1be0:	2905                	addiw	s2,s2,1
    1be2:	ff3917e3          	bne	s2,s3,1bd0 <createdelete+0x20>
    1be6:	4491                	li	s1,4
    wait(&xstatus);
    1be8:	f7c40513          	addi	a0,s0,-132
    1bec:	00004097          	auipc	ra,0x4
    1bf0:	cbc080e7          	jalr	-836(ra) # 58a8 <wait>
    if(xstatus != 0)
    1bf4:	f7c42903          	lw	s2,-132(s0)
    1bf8:	0e091263          	bnez	s2,1cdc <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bfc:	34fd                	addiw	s1,s1,-1
    1bfe:	f4ed                	bnez	s1,1be8 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1c00:	f8040123          	sb	zero,-126(s0)
    1c04:	03000993          	li	s3,48
    1c08:	5a7d                	li	s4,-1
    1c0a:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c0e:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1c10:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1c12:	07400a93          	li	s5,116
    1c16:	a29d                	j	1d7c <createdelete+0x1cc>
      printf("fork failed\n", s);
    1c18:	85e6                	mv	a1,s9
    1c1a:	00005517          	auipc	a0,0x5
    1c1e:	27e50513          	addi	a0,a0,638 # 6e98 <malloc+0x11a8>
    1c22:	00004097          	auipc	ra,0x4
    1c26:	00e080e7          	jalr	14(ra) # 5c30 <printf>
      exit(1);
    1c2a:	4505                	li	a0,1
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	c74080e7          	jalr	-908(ra) # 58a0 <exit>
      name[0] = 'p' + pi;
    1c34:	0709091b          	addiw	s2,s2,112
    1c38:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c3c:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c40:	4951                	li	s2,20
    1c42:	a015                	j	1c66 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c44:	85e6                	mv	a1,s9
    1c46:	00005517          	auipc	a0,0x5
    1c4a:	eca50513          	addi	a0,a0,-310 # 6b10 <malloc+0xe20>
    1c4e:	00004097          	auipc	ra,0x4
    1c52:	fe2080e7          	jalr	-30(ra) # 5c30 <printf>
          exit(1);
    1c56:	4505                	li	a0,1
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	c48080e7          	jalr	-952(ra) # 58a0 <exit>
      for(i = 0; i < N; i++){
    1c60:	2485                	addiw	s1,s1,1
    1c62:	07248863          	beq	s1,s2,1cd2 <createdelete+0x122>
        name[1] = '0' + i;
    1c66:	0304879b          	addiw	a5,s1,48
    1c6a:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c6e:	20200593          	li	a1,514
    1c72:	f8040513          	addi	a0,s0,-128
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	c6a080e7          	jalr	-918(ra) # 58e0 <open>
        if(fd < 0){
    1c7e:	fc0543e3          	bltz	a0,1c44 <createdelete+0x94>
        close(fd);
    1c82:	00004097          	auipc	ra,0x4
    1c86:	c46080e7          	jalr	-954(ra) # 58c8 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c8a:	fc905be3          	blez	s1,1c60 <createdelete+0xb0>
    1c8e:	0014f793          	andi	a5,s1,1
    1c92:	f7f9                	bnez	a5,1c60 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c94:	01f4d79b          	srliw	a5,s1,0x1f
    1c98:	9fa5                	addw	a5,a5,s1
    1c9a:	4017d79b          	sraiw	a5,a5,0x1
    1c9e:	0307879b          	addiw	a5,a5,48
    1ca2:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1ca6:	f8040513          	addi	a0,s0,-128
    1caa:	00004097          	auipc	ra,0x4
    1cae:	c46080e7          	jalr	-954(ra) # 58f0 <unlink>
    1cb2:	fa0557e3          	bgez	a0,1c60 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1cb6:	85e6                	mv	a1,s9
    1cb8:	00005517          	auipc	a0,0x5
    1cbc:	fb050513          	addi	a0,a0,-80 # 6c68 <malloc+0xf78>
    1cc0:	00004097          	auipc	ra,0x4
    1cc4:	f70080e7          	jalr	-144(ra) # 5c30 <printf>
            exit(1);
    1cc8:	4505                	li	a0,1
    1cca:	00004097          	auipc	ra,0x4
    1cce:	bd6080e7          	jalr	-1066(ra) # 58a0 <exit>
      exit(0);
    1cd2:	4501                	li	a0,0
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	bcc080e7          	jalr	-1076(ra) # 58a0 <exit>
      exit(1);
    1cdc:	4505                	li	a0,1
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	bc2080e7          	jalr	-1086(ra) # 58a0 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ce6:	f8040613          	addi	a2,s0,-128
    1cea:	85e6                	mv	a1,s9
    1cec:	00005517          	auipc	a0,0x5
    1cf0:	f9450513          	addi	a0,a0,-108 # 6c80 <malloc+0xf90>
    1cf4:	00004097          	auipc	ra,0x4
    1cf8:	f3c080e7          	jalr	-196(ra) # 5c30 <printf>
        exit(1);
    1cfc:	4505                	li	a0,1
    1cfe:	00004097          	auipc	ra,0x4
    1d02:	ba2080e7          	jalr	-1118(ra) # 58a0 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d06:	054b7163          	bgeu	s6,s4,1d48 <createdelete+0x198>
      if(fd >= 0)
    1d0a:	02055a63          	bgez	a0,1d3e <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1d0e:	2485                	addiw	s1,s1,1
    1d10:	0ff4f493          	andi	s1,s1,255
    1d14:	05548c63          	beq	s1,s5,1d6c <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1d18:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d1c:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d20:	4581                	li	a1,0
    1d22:	f8040513          	addi	a0,s0,-128
    1d26:	00004097          	auipc	ra,0x4
    1d2a:	bba080e7          	jalr	-1094(ra) # 58e0 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d2e:	00090463          	beqz	s2,1d36 <createdelete+0x186>
    1d32:	fd2bdae3          	bge	s7,s2,1d06 <createdelete+0x156>
    1d36:	fa0548e3          	bltz	a0,1ce6 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d3a:	014b7963          	bgeu	s6,s4,1d4c <createdelete+0x19c>
        close(fd);
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	b8a080e7          	jalr	-1142(ra) # 58c8 <close>
    1d46:	b7e1                	j	1d0e <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d48:	fc0543e3          	bltz	a0,1d0e <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d4c:	f8040613          	addi	a2,s0,-128
    1d50:	85e6                	mv	a1,s9
    1d52:	00005517          	auipc	a0,0x5
    1d56:	f5650513          	addi	a0,a0,-170 # 6ca8 <malloc+0xfb8>
    1d5a:	00004097          	auipc	ra,0x4
    1d5e:	ed6080e7          	jalr	-298(ra) # 5c30 <printf>
        exit(1);
    1d62:	4505                	li	a0,1
    1d64:	00004097          	auipc	ra,0x4
    1d68:	b3c080e7          	jalr	-1220(ra) # 58a0 <exit>
  for(i = 0; i < N; i++){
    1d6c:	2905                	addiw	s2,s2,1
    1d6e:	2a05                	addiw	s4,s4,1
    1d70:	2985                	addiw	s3,s3,1
    1d72:	0ff9f993          	andi	s3,s3,255
    1d76:	47d1                	li	a5,20
    1d78:	02f90a63          	beq	s2,a5,1dac <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d7c:	84e2                	mv	s1,s8
    1d7e:	bf69                	j	1d18 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d80:	2905                	addiw	s2,s2,1
    1d82:	0ff97913          	andi	s2,s2,255
    1d86:	2985                	addiw	s3,s3,1
    1d88:	0ff9f993          	andi	s3,s3,255
    1d8c:	03490863          	beq	s2,s4,1dbc <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d90:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d92:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d96:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d9a:	f8040513          	addi	a0,s0,-128
    1d9e:	00004097          	auipc	ra,0x4
    1da2:	b52080e7          	jalr	-1198(ra) # 58f0 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1da6:	34fd                	addiw	s1,s1,-1
    1da8:	f4ed                	bnez	s1,1d92 <createdelete+0x1e2>
    1daa:	bfd9                	j	1d80 <createdelete+0x1d0>
    1dac:	03000993          	li	s3,48
    1db0:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1db4:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1db6:	08400a13          	li	s4,132
    1dba:	bfd9                	j	1d90 <createdelete+0x1e0>
}
    1dbc:	60aa                	ld	ra,136(sp)
    1dbe:	640a                	ld	s0,128(sp)
    1dc0:	74e6                	ld	s1,120(sp)
    1dc2:	7946                	ld	s2,112(sp)
    1dc4:	79a6                	ld	s3,104(sp)
    1dc6:	7a06                	ld	s4,96(sp)
    1dc8:	6ae6                	ld	s5,88(sp)
    1dca:	6b46                	ld	s6,80(sp)
    1dcc:	6ba6                	ld	s7,72(sp)
    1dce:	6c06                	ld	s8,64(sp)
    1dd0:	7ce2                	ld	s9,56(sp)
    1dd2:	6149                	addi	sp,sp,144
    1dd4:	8082                	ret

0000000000001dd6 <linkunlink>:
{
    1dd6:	711d                	addi	sp,sp,-96
    1dd8:	ec86                	sd	ra,88(sp)
    1dda:	e8a2                	sd	s0,80(sp)
    1ddc:	e4a6                	sd	s1,72(sp)
    1dde:	e0ca                	sd	s2,64(sp)
    1de0:	fc4e                	sd	s3,56(sp)
    1de2:	f852                	sd	s4,48(sp)
    1de4:	f456                	sd	s5,40(sp)
    1de6:	f05a                	sd	s6,32(sp)
    1de8:	ec5e                	sd	s7,24(sp)
    1dea:	e862                	sd	s8,16(sp)
    1dec:	e466                	sd	s9,8(sp)
    1dee:	1080                	addi	s0,sp,96
    1df0:	84aa                	mv	s1,a0
  unlink("x");
    1df2:	00004517          	auipc	a0,0x4
    1df6:	49e50513          	addi	a0,a0,1182 # 6290 <malloc+0x5a0>
    1dfa:	00004097          	auipc	ra,0x4
    1dfe:	af6080e7          	jalr	-1290(ra) # 58f0 <unlink>
  pid = fork();
    1e02:	00004097          	auipc	ra,0x4
    1e06:	a96080e7          	jalr	-1386(ra) # 5898 <fork>
  if(pid < 0){
    1e0a:	02054b63          	bltz	a0,1e40 <linkunlink+0x6a>
    1e0e:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1e10:	4c85                	li	s9,1
    1e12:	e119                	bnez	a0,1e18 <linkunlink+0x42>
    1e14:	06100c93          	li	s9,97
    1e18:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e1c:	41c659b7          	lui	s3,0x41c65
    1e20:	e6d9899b          	addiw	s3,s3,-403
    1e24:	690d                	lui	s2,0x3
    1e26:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e2a:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e2c:	4b05                	li	s6,1
      unlink("x");
    1e2e:	00004a97          	auipc	s5,0x4
    1e32:	462a8a93          	addi	s5,s5,1122 # 6290 <malloc+0x5a0>
      link("cat", "x");
    1e36:	00005b97          	auipc	s7,0x5
    1e3a:	e9ab8b93          	addi	s7,s7,-358 # 6cd0 <malloc+0xfe0>
    1e3e:	a091                	j	1e82 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e40:	85a6                	mv	a1,s1
    1e42:	00005517          	auipc	a0,0x5
    1e46:	c3650513          	addi	a0,a0,-970 # 6a78 <malloc+0xd88>
    1e4a:	00004097          	auipc	ra,0x4
    1e4e:	de6080e7          	jalr	-538(ra) # 5c30 <printf>
    exit(1);
    1e52:	4505                	li	a0,1
    1e54:	00004097          	auipc	ra,0x4
    1e58:	a4c080e7          	jalr	-1460(ra) # 58a0 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e5c:	20200593          	li	a1,514
    1e60:	8556                	mv	a0,s5
    1e62:	00004097          	auipc	ra,0x4
    1e66:	a7e080e7          	jalr	-1410(ra) # 58e0 <open>
    1e6a:	00004097          	auipc	ra,0x4
    1e6e:	a5e080e7          	jalr	-1442(ra) # 58c8 <close>
    1e72:	a031                	j	1e7e <linkunlink+0xa8>
      unlink("x");
    1e74:	8556                	mv	a0,s5
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	a7a080e7          	jalr	-1414(ra) # 58f0 <unlink>
  for(i = 0; i < 100; i++){
    1e7e:	34fd                	addiw	s1,s1,-1
    1e80:	c09d                	beqz	s1,1ea6 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e82:	033c87bb          	mulw	a5,s9,s3
    1e86:	012787bb          	addw	a5,a5,s2
    1e8a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e8e:	0347f7bb          	remuw	a5,a5,s4
    1e92:	d7e9                	beqz	a5,1e5c <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e94:	ff6790e3          	bne	a5,s6,1e74 <linkunlink+0x9e>
      link("cat", "x");
    1e98:	85d6                	mv	a1,s5
    1e9a:	855e                	mv	a0,s7
    1e9c:	00004097          	auipc	ra,0x4
    1ea0:	a64080e7          	jalr	-1436(ra) # 5900 <link>
    1ea4:	bfe9                	j	1e7e <linkunlink+0xa8>
  if(pid)
    1ea6:	020c0463          	beqz	s8,1ece <linkunlink+0xf8>
    wait(0);
    1eaa:	4501                	li	a0,0
    1eac:	00004097          	auipc	ra,0x4
    1eb0:	9fc080e7          	jalr	-1540(ra) # 58a8 <wait>
}
    1eb4:	60e6                	ld	ra,88(sp)
    1eb6:	6446                	ld	s0,80(sp)
    1eb8:	64a6                	ld	s1,72(sp)
    1eba:	6906                	ld	s2,64(sp)
    1ebc:	79e2                	ld	s3,56(sp)
    1ebe:	7a42                	ld	s4,48(sp)
    1ec0:	7aa2                	ld	s5,40(sp)
    1ec2:	7b02                	ld	s6,32(sp)
    1ec4:	6be2                	ld	s7,24(sp)
    1ec6:	6c42                	ld	s8,16(sp)
    1ec8:	6ca2                	ld	s9,8(sp)
    1eca:	6125                	addi	sp,sp,96
    1ecc:	8082                	ret
    exit(0);
    1ece:	4501                	li	a0,0
    1ed0:	00004097          	auipc	ra,0x4
    1ed4:	9d0080e7          	jalr	-1584(ra) # 58a0 <exit>

0000000000001ed8 <manywrites>:
{
    1ed8:	711d                	addi	sp,sp,-96
    1eda:	ec86                	sd	ra,88(sp)
    1edc:	e8a2                	sd	s0,80(sp)
    1ede:	e4a6                	sd	s1,72(sp)
    1ee0:	e0ca                	sd	s2,64(sp)
    1ee2:	fc4e                	sd	s3,56(sp)
    1ee4:	f852                	sd	s4,48(sp)
    1ee6:	f456                	sd	s5,40(sp)
    1ee8:	f05a                	sd	s6,32(sp)
    1eea:	ec5e                	sd	s7,24(sp)
    1eec:	1080                	addi	s0,sp,96
    1eee:	8b2a                	mv	s6,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ef0:	4481                	li	s1,0
    1ef2:	4991                	li	s3,4
    int pid = fork();
    1ef4:	00004097          	auipc	ra,0x4
    1ef8:	9a4080e7          	jalr	-1628(ra) # 5898 <fork>
    1efc:	892a                	mv	s2,a0
    if(pid < 0){
    1efe:	02054963          	bltz	a0,1f30 <manywrites+0x58>
    if(pid == 0){
    1f02:	c521                	beqz	a0,1f4a <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1f04:	2485                	addiw	s1,s1,1
    1f06:	ff3497e3          	bne	s1,s3,1ef4 <manywrites+0x1c>
    1f0a:	4491                	li	s1,4
    int st = 0;
    1f0c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1f10:	fa840513          	addi	a0,s0,-88
    1f14:	00004097          	auipc	ra,0x4
    1f18:	994080e7          	jalr	-1644(ra) # 58a8 <wait>
    if(st != 0)
    1f1c:	fa842503          	lw	a0,-88(s0)
    1f20:	ed6d                	bnez	a0,201a <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1f22:	34fd                	addiw	s1,s1,-1
    1f24:	f4e5                	bnez	s1,1f0c <manywrites+0x34>
  exit(0);
    1f26:	4501                	li	a0,0
    1f28:	00004097          	auipc	ra,0x4
    1f2c:	978080e7          	jalr	-1672(ra) # 58a0 <exit>
      printf("fork failed\n");
    1f30:	00005517          	auipc	a0,0x5
    1f34:	f6850513          	addi	a0,a0,-152 # 6e98 <malloc+0x11a8>
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	cf8080e7          	jalr	-776(ra) # 5c30 <printf>
      exit(1);
    1f40:	4505                	li	a0,1
    1f42:	00004097          	auipc	ra,0x4
    1f46:	95e080e7          	jalr	-1698(ra) # 58a0 <exit>
      name[0] = 'b';
    1f4a:	06200793          	li	a5,98
    1f4e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f52:	0614879b          	addiw	a5,s1,97
    1f56:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f5a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f5e:	fa840513          	addi	a0,s0,-88
    1f62:	00004097          	auipc	ra,0x4
    1f66:	98e080e7          	jalr	-1650(ra) # 58f0 <unlink>
    1f6a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f6c:	0000aa97          	auipc	s5,0xa
    1f70:	e8ca8a93          	addi	s5,s5,-372 # bdf8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f74:	8a4a                	mv	s4,s2
    1f76:	0204ce63          	bltz	s1,1fb2 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f7a:	20200593          	li	a1,514
    1f7e:	fa840513          	addi	a0,s0,-88
    1f82:	00004097          	auipc	ra,0x4
    1f86:	95e080e7          	jalr	-1698(ra) # 58e0 <open>
    1f8a:	89aa                	mv	s3,a0
          if(fd < 0){
    1f8c:	04054763          	bltz	a0,1fda <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f90:	660d                	lui	a2,0x3
    1f92:	85d6                	mv	a1,s5
    1f94:	00004097          	auipc	ra,0x4
    1f98:	92c080e7          	jalr	-1748(ra) # 58c0 <write>
          if(cc != sz){
    1f9c:	678d                	lui	a5,0x3
    1f9e:	04f51e63          	bne	a0,a5,1ffa <manywrites+0x122>
          close(fd);
    1fa2:	854e                	mv	a0,s3
    1fa4:	00004097          	auipc	ra,0x4
    1fa8:	924080e7          	jalr	-1756(ra) # 58c8 <close>
        for(int i = 0; i < ci+1; i++){
    1fac:	2a05                	addiw	s4,s4,1
    1fae:	fd44d6e3          	bge	s1,s4,1f7a <manywrites+0xa2>
        unlink(name);
    1fb2:	fa840513          	addi	a0,s0,-88
    1fb6:	00004097          	auipc	ra,0x4
    1fba:	93a080e7          	jalr	-1734(ra) # 58f0 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1fbe:	3bfd                	addiw	s7,s7,-1
    1fc0:	fa0b9ae3          	bnez	s7,1f74 <manywrites+0x9c>
      unlink(name);
    1fc4:	fa840513          	addi	a0,s0,-88
    1fc8:	00004097          	auipc	ra,0x4
    1fcc:	928080e7          	jalr	-1752(ra) # 58f0 <unlink>
      exit(0);
    1fd0:	4501                	li	a0,0
    1fd2:	00004097          	auipc	ra,0x4
    1fd6:	8ce080e7          	jalr	-1842(ra) # 58a0 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fda:	fa840613          	addi	a2,s0,-88
    1fde:	85da                	mv	a1,s6
    1fe0:	00005517          	auipc	a0,0x5
    1fe4:	cf850513          	addi	a0,a0,-776 # 6cd8 <malloc+0xfe8>
    1fe8:	00004097          	auipc	ra,0x4
    1fec:	c48080e7          	jalr	-952(ra) # 5c30 <printf>
            exit(1);
    1ff0:	4505                	li	a0,1
    1ff2:	00004097          	auipc	ra,0x4
    1ff6:	8ae080e7          	jalr	-1874(ra) # 58a0 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1ffa:	86aa                	mv	a3,a0
    1ffc:	660d                	lui	a2,0x3
    1ffe:	85da                	mv	a1,s6
    2000:	00004517          	auipc	a0,0x4
    2004:	2f050513          	addi	a0,a0,752 # 62f0 <malloc+0x600>
    2008:	00004097          	auipc	ra,0x4
    200c:	c28080e7          	jalr	-984(ra) # 5c30 <printf>
            exit(1);
    2010:	4505                	li	a0,1
    2012:	00004097          	auipc	ra,0x4
    2016:	88e080e7          	jalr	-1906(ra) # 58a0 <exit>
      exit(st);
    201a:	00004097          	auipc	ra,0x4
    201e:	886080e7          	jalr	-1914(ra) # 58a0 <exit>

0000000000002022 <forktest>:
{
    2022:	7179                	addi	sp,sp,-48
    2024:	f406                	sd	ra,40(sp)
    2026:	f022                	sd	s0,32(sp)
    2028:	ec26                	sd	s1,24(sp)
    202a:	e84a                	sd	s2,16(sp)
    202c:	e44e                	sd	s3,8(sp)
    202e:	1800                	addi	s0,sp,48
    2030:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2032:	4481                	li	s1,0
    2034:	3e800913          	li	s2,1000
    pid = fork();
    2038:	00004097          	auipc	ra,0x4
    203c:	860080e7          	jalr	-1952(ra) # 5898 <fork>
    if(pid < 0)
    2040:	02054863          	bltz	a0,2070 <forktest+0x4e>
    if(pid == 0)
    2044:	c115                	beqz	a0,2068 <forktest+0x46>
  for(n=0; n<N; n++){
    2046:	2485                	addiw	s1,s1,1
    2048:	ff2498e3          	bne	s1,s2,2038 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    204c:	85ce                	mv	a1,s3
    204e:	00005517          	auipc	a0,0x5
    2052:	cba50513          	addi	a0,a0,-838 # 6d08 <malloc+0x1018>
    2056:	00004097          	auipc	ra,0x4
    205a:	bda080e7          	jalr	-1062(ra) # 5c30 <printf>
    exit(1);
    205e:	4505                	li	a0,1
    2060:	00004097          	auipc	ra,0x4
    2064:	840080e7          	jalr	-1984(ra) # 58a0 <exit>
      exit(0);
    2068:	00004097          	auipc	ra,0x4
    206c:	838080e7          	jalr	-1992(ra) # 58a0 <exit>
  if (n == 0) {
    2070:	cc9d                	beqz	s1,20ae <forktest+0x8c>
  if(n == N){
    2072:	3e800793          	li	a5,1000
    2076:	fcf48be3          	beq	s1,a5,204c <forktest+0x2a>
  for(; n > 0; n--){
    207a:	00905b63          	blez	s1,2090 <forktest+0x6e>
    if(wait(0) < 0){
    207e:	4501                	li	a0,0
    2080:	00004097          	auipc	ra,0x4
    2084:	828080e7          	jalr	-2008(ra) # 58a8 <wait>
    2088:	04054163          	bltz	a0,20ca <forktest+0xa8>
  for(; n > 0; n--){
    208c:	34fd                	addiw	s1,s1,-1
    208e:	f8e5                	bnez	s1,207e <forktest+0x5c>
  if(wait(0) != -1){
    2090:	4501                	li	a0,0
    2092:	00004097          	auipc	ra,0x4
    2096:	816080e7          	jalr	-2026(ra) # 58a8 <wait>
    209a:	57fd                	li	a5,-1
    209c:	04f51563          	bne	a0,a5,20e6 <forktest+0xc4>
}
    20a0:	70a2                	ld	ra,40(sp)
    20a2:	7402                	ld	s0,32(sp)
    20a4:	64e2                	ld	s1,24(sp)
    20a6:	6942                	ld	s2,16(sp)
    20a8:	69a2                	ld	s3,8(sp)
    20aa:	6145                	addi	sp,sp,48
    20ac:	8082                	ret
    printf("%s: no fork at all!\n", s);
    20ae:	85ce                	mv	a1,s3
    20b0:	00005517          	auipc	a0,0x5
    20b4:	c4050513          	addi	a0,a0,-960 # 6cf0 <malloc+0x1000>
    20b8:	00004097          	auipc	ra,0x4
    20bc:	b78080e7          	jalr	-1160(ra) # 5c30 <printf>
    exit(1);
    20c0:	4505                	li	a0,1
    20c2:	00003097          	auipc	ra,0x3
    20c6:	7de080e7          	jalr	2014(ra) # 58a0 <exit>
      printf("%s: wait stopped early\n", s);
    20ca:	85ce                	mv	a1,s3
    20cc:	00005517          	auipc	a0,0x5
    20d0:	c6450513          	addi	a0,a0,-924 # 6d30 <malloc+0x1040>
    20d4:	00004097          	auipc	ra,0x4
    20d8:	b5c080e7          	jalr	-1188(ra) # 5c30 <printf>
      exit(1);
    20dc:	4505                	li	a0,1
    20de:	00003097          	auipc	ra,0x3
    20e2:	7c2080e7          	jalr	1986(ra) # 58a0 <exit>
    printf("%s: wait got too many\n", s);
    20e6:	85ce                	mv	a1,s3
    20e8:	00005517          	auipc	a0,0x5
    20ec:	c6050513          	addi	a0,a0,-928 # 6d48 <malloc+0x1058>
    20f0:	00004097          	auipc	ra,0x4
    20f4:	b40080e7          	jalr	-1216(ra) # 5c30 <printf>
    exit(1);
    20f8:	4505                	li	a0,1
    20fa:	00003097          	auipc	ra,0x3
    20fe:	7a6080e7          	jalr	1958(ra) # 58a0 <exit>

0000000000002102 <kernmem>:
{
    2102:	715d                	addi	sp,sp,-80
    2104:	e486                	sd	ra,72(sp)
    2106:	e0a2                	sd	s0,64(sp)
    2108:	fc26                	sd	s1,56(sp)
    210a:	f84a                	sd	s2,48(sp)
    210c:	f44e                	sd	s3,40(sp)
    210e:	f052                	sd	s4,32(sp)
    2110:	ec56                	sd	s5,24(sp)
    2112:	0880                	addi	s0,sp,80
    2114:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2116:	4485                	li	s1,1
    2118:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    211a:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    211c:	69b1                	lui	s3,0xc
    211e:	35098993          	addi	s3,s3,848 # c350 <buf+0x558>
    2122:	1003d937          	lui	s2,0x1003d
    2126:	090e                	slli	s2,s2,0x3
    2128:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e678>
    pid = fork();
    212c:	00003097          	auipc	ra,0x3
    2130:	76c080e7          	jalr	1900(ra) # 5898 <fork>
    if(pid < 0){
    2134:	02054963          	bltz	a0,2166 <kernmem+0x64>
    if(pid == 0){
    2138:	c529                	beqz	a0,2182 <kernmem+0x80>
    wait(&xstatus);
    213a:	fbc40513          	addi	a0,s0,-68
    213e:	00003097          	auipc	ra,0x3
    2142:	76a080e7          	jalr	1898(ra) # 58a8 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2146:	fbc42783          	lw	a5,-68(s0)
    214a:	05479d63          	bne	a5,s4,21a4 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    214e:	94ce                	add	s1,s1,s3
    2150:	fd249ee3          	bne	s1,s2,212c <kernmem+0x2a>
}
    2154:	60a6                	ld	ra,72(sp)
    2156:	6406                	ld	s0,64(sp)
    2158:	74e2                	ld	s1,56(sp)
    215a:	7942                	ld	s2,48(sp)
    215c:	79a2                	ld	s3,40(sp)
    215e:	7a02                	ld	s4,32(sp)
    2160:	6ae2                	ld	s5,24(sp)
    2162:	6161                	addi	sp,sp,80
    2164:	8082                	ret
      printf("%s: fork failed\n", s);
    2166:	85d6                	mv	a1,s5
    2168:	00005517          	auipc	a0,0x5
    216c:	91050513          	addi	a0,a0,-1776 # 6a78 <malloc+0xd88>
    2170:	00004097          	auipc	ra,0x4
    2174:	ac0080e7          	jalr	-1344(ra) # 5c30 <printf>
      exit(1);
    2178:	4505                	li	a0,1
    217a:	00003097          	auipc	ra,0x3
    217e:	726080e7          	jalr	1830(ra) # 58a0 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2182:	0004c683          	lbu	a3,0(s1)
    2186:	8626                	mv	a2,s1
    2188:	85d6                	mv	a1,s5
    218a:	00005517          	auipc	a0,0x5
    218e:	bd650513          	addi	a0,a0,-1066 # 6d60 <malloc+0x1070>
    2192:	00004097          	auipc	ra,0x4
    2196:	a9e080e7          	jalr	-1378(ra) # 5c30 <printf>
      exit(1);
    219a:	4505                	li	a0,1
    219c:	00003097          	auipc	ra,0x3
    21a0:	704080e7          	jalr	1796(ra) # 58a0 <exit>
      exit(1);
    21a4:	4505                	li	a0,1
    21a6:	00003097          	auipc	ra,0x3
    21aa:	6fa080e7          	jalr	1786(ra) # 58a0 <exit>

00000000000021ae <MAXVAplus>:
{
    21ae:	7179                	addi	sp,sp,-48
    21b0:	f406                	sd	ra,40(sp)
    21b2:	f022                	sd	s0,32(sp)
    21b4:	ec26                	sd	s1,24(sp)
    21b6:	e84a                	sd	s2,16(sp)
    21b8:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    21ba:	4785                	li	a5,1
    21bc:	179a                	slli	a5,a5,0x26
    21be:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    21c2:	fd843783          	ld	a5,-40(s0)
    21c6:	cf85                	beqz	a5,21fe <MAXVAplus+0x50>
    21c8:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    21ca:	54fd                	li	s1,-1
    pid = fork();
    21cc:	00003097          	auipc	ra,0x3
    21d0:	6cc080e7          	jalr	1740(ra) # 5898 <fork>
    if(pid < 0){
    21d4:	02054b63          	bltz	a0,220a <MAXVAplus+0x5c>
    if(pid == 0){
    21d8:	c539                	beqz	a0,2226 <MAXVAplus+0x78>
    wait(&xstatus);
    21da:	fd440513          	addi	a0,s0,-44
    21de:	00003097          	auipc	ra,0x3
    21e2:	6ca080e7          	jalr	1738(ra) # 58a8 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21e6:	fd442783          	lw	a5,-44(s0)
    21ea:	06979463          	bne	a5,s1,2252 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    21ee:	fd843783          	ld	a5,-40(s0)
    21f2:	0786                	slli	a5,a5,0x1
    21f4:	fcf43c23          	sd	a5,-40(s0)
    21f8:	fd843783          	ld	a5,-40(s0)
    21fc:	fbe1                	bnez	a5,21cc <MAXVAplus+0x1e>
}
    21fe:	70a2                	ld	ra,40(sp)
    2200:	7402                	ld	s0,32(sp)
    2202:	64e2                	ld	s1,24(sp)
    2204:	6942                	ld	s2,16(sp)
    2206:	6145                	addi	sp,sp,48
    2208:	8082                	ret
      printf("%s: fork failed\n", s);
    220a:	85ca                	mv	a1,s2
    220c:	00005517          	auipc	a0,0x5
    2210:	86c50513          	addi	a0,a0,-1940 # 6a78 <malloc+0xd88>
    2214:	00004097          	auipc	ra,0x4
    2218:	a1c080e7          	jalr	-1508(ra) # 5c30 <printf>
      exit(1);
    221c:	4505                	li	a0,1
    221e:	00003097          	auipc	ra,0x3
    2222:	682080e7          	jalr	1666(ra) # 58a0 <exit>
      *(char*)a = 99;
    2226:	fd843783          	ld	a5,-40(s0)
    222a:	06300713          	li	a4,99
    222e:	00e78023          	sb	a4,0(a5) # 3000 <iputtest+0x56>
      printf("%s: oops wrote %x\n", s, a);
    2232:	fd843603          	ld	a2,-40(s0)
    2236:	85ca                	mv	a1,s2
    2238:	00005517          	auipc	a0,0x5
    223c:	b4850513          	addi	a0,a0,-1208 # 6d80 <malloc+0x1090>
    2240:	00004097          	auipc	ra,0x4
    2244:	9f0080e7          	jalr	-1552(ra) # 5c30 <printf>
      exit(1);
    2248:	4505                	li	a0,1
    224a:	00003097          	auipc	ra,0x3
    224e:	656080e7          	jalr	1622(ra) # 58a0 <exit>
      exit(1);
    2252:	4505                	li	a0,1
    2254:	00003097          	auipc	ra,0x3
    2258:	64c080e7          	jalr	1612(ra) # 58a0 <exit>

000000000000225c <bigargtest>:
{
    225c:	7179                	addi	sp,sp,-48
    225e:	f406                	sd	ra,40(sp)
    2260:	f022                	sd	s0,32(sp)
    2262:	ec26                	sd	s1,24(sp)
    2264:	1800                	addi	s0,sp,48
    2266:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2268:	00005517          	auipc	a0,0x5
    226c:	b3050513          	addi	a0,a0,-1232 # 6d98 <malloc+0x10a8>
    2270:	00003097          	auipc	ra,0x3
    2274:	680080e7          	jalr	1664(ra) # 58f0 <unlink>
  pid = fork();
    2278:	00003097          	auipc	ra,0x3
    227c:	620080e7          	jalr	1568(ra) # 5898 <fork>
  if(pid == 0){
    2280:	c121                	beqz	a0,22c0 <bigargtest+0x64>
  } else if(pid < 0){
    2282:	0a054063          	bltz	a0,2322 <bigargtest+0xc6>
  wait(&xstatus);
    2286:	fdc40513          	addi	a0,s0,-36
    228a:	00003097          	auipc	ra,0x3
    228e:	61e080e7          	jalr	1566(ra) # 58a8 <wait>
  if(xstatus != 0)
    2292:	fdc42503          	lw	a0,-36(s0)
    2296:	e545                	bnez	a0,233e <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2298:	4581                	li	a1,0
    229a:	00005517          	auipc	a0,0x5
    229e:	afe50513          	addi	a0,a0,-1282 # 6d98 <malloc+0x10a8>
    22a2:	00003097          	auipc	ra,0x3
    22a6:	63e080e7          	jalr	1598(ra) # 58e0 <open>
  if(fd < 0){
    22aa:	08054e63          	bltz	a0,2346 <bigargtest+0xea>
  close(fd);
    22ae:	00003097          	auipc	ra,0x3
    22b2:	61a080e7          	jalr	1562(ra) # 58c8 <close>
}
    22b6:	70a2                	ld	ra,40(sp)
    22b8:	7402                	ld	s0,32(sp)
    22ba:	64e2                	ld	s1,24(sp)
    22bc:	6145                	addi	sp,sp,48
    22be:	8082                	ret
    22c0:	00006797          	auipc	a5,0x6
    22c4:	32078793          	addi	a5,a5,800 # 85e0 <args.1888>
    22c8:	00006697          	auipc	a3,0x6
    22cc:	41068693          	addi	a3,a3,1040 # 86d8 <args.1888+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    22d0:	00005717          	auipc	a4,0x5
    22d4:	ad870713          	addi	a4,a4,-1320 # 6da8 <malloc+0x10b8>
    22d8:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    22da:	07a1                	addi	a5,a5,8
    22dc:	fed79ee3          	bne	a5,a3,22d8 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22e0:	00006597          	auipc	a1,0x6
    22e4:	30058593          	addi	a1,a1,768 # 85e0 <args.1888>
    22e8:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    22ec:	00004517          	auipc	a0,0x4
    22f0:	f3450513          	addi	a0,a0,-204 # 6220 <malloc+0x530>
    22f4:	00003097          	auipc	ra,0x3
    22f8:	5e4080e7          	jalr	1508(ra) # 58d8 <exec>
    fd = open("bigarg-ok", O_CREATE);
    22fc:	20000593          	li	a1,512
    2300:	00005517          	auipc	a0,0x5
    2304:	a9850513          	addi	a0,a0,-1384 # 6d98 <malloc+0x10a8>
    2308:	00003097          	auipc	ra,0x3
    230c:	5d8080e7          	jalr	1496(ra) # 58e0 <open>
    close(fd);
    2310:	00003097          	auipc	ra,0x3
    2314:	5b8080e7          	jalr	1464(ra) # 58c8 <close>
    exit(0);
    2318:	4501                	li	a0,0
    231a:	00003097          	auipc	ra,0x3
    231e:	586080e7          	jalr	1414(ra) # 58a0 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2322:	85a6                	mv	a1,s1
    2324:	00005517          	auipc	a0,0x5
    2328:	b6450513          	addi	a0,a0,-1180 # 6e88 <malloc+0x1198>
    232c:	00004097          	auipc	ra,0x4
    2330:	904080e7          	jalr	-1788(ra) # 5c30 <printf>
    exit(1);
    2334:	4505                	li	a0,1
    2336:	00003097          	auipc	ra,0x3
    233a:	56a080e7          	jalr	1386(ra) # 58a0 <exit>
    exit(xstatus);
    233e:	00003097          	auipc	ra,0x3
    2342:	562080e7          	jalr	1378(ra) # 58a0 <exit>
    printf("%s: bigarg test failed!\n", s);
    2346:	85a6                	mv	a1,s1
    2348:	00005517          	auipc	a0,0x5
    234c:	b6050513          	addi	a0,a0,-1184 # 6ea8 <malloc+0x11b8>
    2350:	00004097          	auipc	ra,0x4
    2354:	8e0080e7          	jalr	-1824(ra) # 5c30 <printf>
    exit(1);
    2358:	4505                	li	a0,1
    235a:	00003097          	auipc	ra,0x3
    235e:	546080e7          	jalr	1350(ra) # 58a0 <exit>

0000000000002362 <stacktest>:
{
    2362:	7179                	addi	sp,sp,-48
    2364:	f406                	sd	ra,40(sp)
    2366:	f022                	sd	s0,32(sp)
    2368:	ec26                	sd	s1,24(sp)
    236a:	1800                	addi	s0,sp,48
    236c:	84aa                	mv	s1,a0
  pid = fork();
    236e:	00003097          	auipc	ra,0x3
    2372:	52a080e7          	jalr	1322(ra) # 5898 <fork>
  if(pid == 0) {
    2376:	c115                	beqz	a0,239a <stacktest+0x38>
  } else if(pid < 0){
    2378:	04054463          	bltz	a0,23c0 <stacktest+0x5e>
  wait(&xstatus);
    237c:	fdc40513          	addi	a0,s0,-36
    2380:	00003097          	auipc	ra,0x3
    2384:	528080e7          	jalr	1320(ra) # 58a8 <wait>
  if(xstatus == -1)  // kernel killed child?
    2388:	fdc42503          	lw	a0,-36(s0)
    238c:	57fd                	li	a5,-1
    238e:	04f50763          	beq	a0,a5,23dc <stacktest+0x7a>
    exit(xstatus);
    2392:	00003097          	auipc	ra,0x3
    2396:	50e080e7          	jalr	1294(ra) # 58a0 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    239a:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    239c:	77fd                	lui	a5,0xfffff
    239e:	97ba                	add	a5,a5,a4
    23a0:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff01f8>
    23a4:	85a6                	mv	a1,s1
    23a6:	00005517          	auipc	a0,0x5
    23aa:	b2250513          	addi	a0,a0,-1246 # 6ec8 <malloc+0x11d8>
    23ae:	00004097          	auipc	ra,0x4
    23b2:	882080e7          	jalr	-1918(ra) # 5c30 <printf>
    exit(1);
    23b6:	4505                	li	a0,1
    23b8:	00003097          	auipc	ra,0x3
    23bc:	4e8080e7          	jalr	1256(ra) # 58a0 <exit>
    printf("%s: fork failed\n", s);
    23c0:	85a6                	mv	a1,s1
    23c2:	00004517          	auipc	a0,0x4
    23c6:	6b650513          	addi	a0,a0,1718 # 6a78 <malloc+0xd88>
    23ca:	00004097          	auipc	ra,0x4
    23ce:	866080e7          	jalr	-1946(ra) # 5c30 <printf>
    exit(1);
    23d2:	4505                	li	a0,1
    23d4:	00003097          	auipc	ra,0x3
    23d8:	4cc080e7          	jalr	1228(ra) # 58a0 <exit>
    exit(0);
    23dc:	4501                	li	a0,0
    23de:	00003097          	auipc	ra,0x3
    23e2:	4c2080e7          	jalr	1218(ra) # 58a0 <exit>

00000000000023e6 <copyinstr3>:
{
    23e6:	7179                	addi	sp,sp,-48
    23e8:	f406                	sd	ra,40(sp)
    23ea:	f022                	sd	s0,32(sp)
    23ec:	ec26                	sd	s1,24(sp)
    23ee:	1800                	addi	s0,sp,48
  sbrk(8192);
    23f0:	6509                	lui	a0,0x2
    23f2:	00003097          	auipc	ra,0x3
    23f6:	536080e7          	jalr	1334(ra) # 5928 <sbrk>
  uint64 top = (uint64) sbrk(0);
    23fa:	4501                	li	a0,0
    23fc:	00003097          	auipc	ra,0x3
    2400:	52c080e7          	jalr	1324(ra) # 5928 <sbrk>
  if((top % PGSIZE) != 0){
    2404:	6785                	lui	a5,0x1
    2406:	17fd                	addi	a5,a5,-1
    2408:	8fe9                	and	a5,a5,a0
    240a:	e3d1                	bnez	a5,248e <copyinstr3+0xa8>
  top = (uint64) sbrk(0);
    240c:	4501                	li	a0,0
    240e:	00003097          	auipc	ra,0x3
    2412:	51a080e7          	jalr	1306(ra) # 5928 <sbrk>
  if(top % PGSIZE){
    2416:	6785                	lui	a5,0x1
    2418:	17fd                	addi	a5,a5,-1
    241a:	8fe9                	and	a5,a5,a0
    241c:	e7c1                	bnez	a5,24a4 <copyinstr3+0xbe>
  char *b = (char *) (top - 1);
    241e:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x127>
  *b = 'x';
    2422:	07800793          	li	a5,120
    2426:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    242a:	8526                	mv	a0,s1
    242c:	00003097          	auipc	ra,0x3
    2430:	4c4080e7          	jalr	1220(ra) # 58f0 <unlink>
  if(ret != -1){
    2434:	57fd                	li	a5,-1
    2436:	08f51463          	bne	a0,a5,24be <copyinstr3+0xd8>
  int fd = open(b, O_CREATE | O_WRONLY);
    243a:	20100593          	li	a1,513
    243e:	8526                	mv	a0,s1
    2440:	00003097          	auipc	ra,0x3
    2444:	4a0080e7          	jalr	1184(ra) # 58e0 <open>
  if(fd != -1){
    2448:	57fd                	li	a5,-1
    244a:	08f51963          	bne	a0,a5,24dc <copyinstr3+0xf6>
  ret = link(b, b);
    244e:	85a6                	mv	a1,s1
    2450:	8526                	mv	a0,s1
    2452:	00003097          	auipc	ra,0x3
    2456:	4ae080e7          	jalr	1198(ra) # 5900 <link>
  if(ret != -1){
    245a:	57fd                	li	a5,-1
    245c:	08f51f63          	bne	a0,a5,24fa <copyinstr3+0x114>
  char *args[] = { "xx", 0 };
    2460:	00005797          	auipc	a5,0x5
    2464:	71078793          	addi	a5,a5,1808 # 7b70 <malloc+0x1e80>
    2468:	fcf43823          	sd	a5,-48(s0)
    246c:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2470:	fd040593          	addi	a1,s0,-48
    2474:	8526                	mv	a0,s1
    2476:	00003097          	auipc	ra,0x3
    247a:	462080e7          	jalr	1122(ra) # 58d8 <exec>
  if(ret != -1){
    247e:	57fd                	li	a5,-1
    2480:	08f51d63          	bne	a0,a5,251a <copyinstr3+0x134>
}
    2484:	70a2                	ld	ra,40(sp)
    2486:	7402                	ld	s0,32(sp)
    2488:	64e2                	ld	s1,24(sp)
    248a:	6145                	addi	sp,sp,48
    248c:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    248e:	6785                	lui	a5,0x1
    2490:	17fd                	addi	a5,a5,-1
    2492:	8d7d                	and	a0,a0,a5
    2494:	6785                	lui	a5,0x1
    2496:	40a7853b          	subw	a0,a5,a0
    249a:	00003097          	auipc	ra,0x3
    249e:	48e080e7          	jalr	1166(ra) # 5928 <sbrk>
    24a2:	b7ad                	j	240c <copyinstr3+0x26>
    printf("oops\n");
    24a4:	00005517          	auipc	a0,0x5
    24a8:	a4c50513          	addi	a0,a0,-1460 # 6ef0 <malloc+0x1200>
    24ac:	00003097          	auipc	ra,0x3
    24b0:	784080e7          	jalr	1924(ra) # 5c30 <printf>
    exit(1);
    24b4:	4505                	li	a0,1
    24b6:	00003097          	auipc	ra,0x3
    24ba:	3ea080e7          	jalr	1002(ra) # 58a0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    24be:	862a                	mv	a2,a0
    24c0:	85a6                	mv	a1,s1
    24c2:	00004517          	auipc	a0,0x4
    24c6:	4d650513          	addi	a0,a0,1238 # 6998 <malloc+0xca8>
    24ca:	00003097          	auipc	ra,0x3
    24ce:	766080e7          	jalr	1894(ra) # 5c30 <printf>
    exit(1);
    24d2:	4505                	li	a0,1
    24d4:	00003097          	auipc	ra,0x3
    24d8:	3cc080e7          	jalr	972(ra) # 58a0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    24dc:	862a                	mv	a2,a0
    24de:	85a6                	mv	a1,s1
    24e0:	00004517          	auipc	a0,0x4
    24e4:	4d850513          	addi	a0,a0,1240 # 69b8 <malloc+0xcc8>
    24e8:	00003097          	auipc	ra,0x3
    24ec:	748080e7          	jalr	1864(ra) # 5c30 <printf>
    exit(1);
    24f0:	4505                	li	a0,1
    24f2:	00003097          	auipc	ra,0x3
    24f6:	3ae080e7          	jalr	942(ra) # 58a0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    24fa:	86aa                	mv	a3,a0
    24fc:	8626                	mv	a2,s1
    24fe:	85a6                	mv	a1,s1
    2500:	00004517          	auipc	a0,0x4
    2504:	4d850513          	addi	a0,a0,1240 # 69d8 <malloc+0xce8>
    2508:	00003097          	auipc	ra,0x3
    250c:	728080e7          	jalr	1832(ra) # 5c30 <printf>
    exit(1);
    2510:	4505                	li	a0,1
    2512:	00003097          	auipc	ra,0x3
    2516:	38e080e7          	jalr	910(ra) # 58a0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    251a:	567d                	li	a2,-1
    251c:	85a6                	mv	a1,s1
    251e:	00004517          	auipc	a0,0x4
    2522:	4e250513          	addi	a0,a0,1250 # 6a00 <malloc+0xd10>
    2526:	00003097          	auipc	ra,0x3
    252a:	70a080e7          	jalr	1802(ra) # 5c30 <printf>
    exit(1);
    252e:	4505                	li	a0,1
    2530:	00003097          	auipc	ra,0x3
    2534:	370080e7          	jalr	880(ra) # 58a0 <exit>

0000000000002538 <rwsbrk>:
{
    2538:	1101                	addi	sp,sp,-32
    253a:	ec06                	sd	ra,24(sp)
    253c:	e822                	sd	s0,16(sp)
    253e:	e426                	sd	s1,8(sp)
    2540:	e04a                	sd	s2,0(sp)
    2542:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2544:	6509                	lui	a0,0x2
    2546:	00003097          	auipc	ra,0x3
    254a:	3e2080e7          	jalr	994(ra) # 5928 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    254e:	57fd                	li	a5,-1
    2550:	06f50263          	beq	a0,a5,25b4 <rwsbrk+0x7c>
    2554:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2556:	7579                	lui	a0,0xffffe
    2558:	00003097          	auipc	ra,0x3
    255c:	3d0080e7          	jalr	976(ra) # 5928 <sbrk>
    2560:	57fd                	li	a5,-1
    2562:	06f50663          	beq	a0,a5,25ce <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2566:	20100593          	li	a1,513
    256a:	00005517          	auipc	a0,0x5
    256e:	9c650513          	addi	a0,a0,-1594 # 6f30 <malloc+0x1240>
    2572:	00003097          	auipc	ra,0x3
    2576:	36e080e7          	jalr	878(ra) # 58e0 <open>
    257a:	892a                	mv	s2,a0
  if(fd < 0){
    257c:	06054663          	bltz	a0,25e8 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    2580:	6785                	lui	a5,0x1
    2582:	94be                	add	s1,s1,a5
    2584:	40000613          	li	a2,1024
    2588:	85a6                	mv	a1,s1
    258a:	00003097          	auipc	ra,0x3
    258e:	336080e7          	jalr	822(ra) # 58c0 <write>
  if(n >= 0){
    2592:	06054863          	bltz	a0,2602 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2596:	862a                	mv	a2,a0
    2598:	85a6                	mv	a1,s1
    259a:	00005517          	auipc	a0,0x5
    259e:	9b650513          	addi	a0,a0,-1610 # 6f50 <malloc+0x1260>
    25a2:	00003097          	auipc	ra,0x3
    25a6:	68e080e7          	jalr	1678(ra) # 5c30 <printf>
    exit(1);
    25aa:	4505                	li	a0,1
    25ac:	00003097          	auipc	ra,0x3
    25b0:	2f4080e7          	jalr	756(ra) # 58a0 <exit>
    printf("sbrk(rwsbrk) failed\n");
    25b4:	00005517          	auipc	a0,0x5
    25b8:	94450513          	addi	a0,a0,-1724 # 6ef8 <malloc+0x1208>
    25bc:	00003097          	auipc	ra,0x3
    25c0:	674080e7          	jalr	1652(ra) # 5c30 <printf>
    exit(1);
    25c4:	4505                	li	a0,1
    25c6:	00003097          	auipc	ra,0x3
    25ca:	2da080e7          	jalr	730(ra) # 58a0 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    25ce:	00005517          	auipc	a0,0x5
    25d2:	94250513          	addi	a0,a0,-1726 # 6f10 <malloc+0x1220>
    25d6:	00003097          	auipc	ra,0x3
    25da:	65a080e7          	jalr	1626(ra) # 5c30 <printf>
    exit(1);
    25de:	4505                	li	a0,1
    25e0:	00003097          	auipc	ra,0x3
    25e4:	2c0080e7          	jalr	704(ra) # 58a0 <exit>
    printf("open(rwsbrk) failed\n");
    25e8:	00005517          	auipc	a0,0x5
    25ec:	95050513          	addi	a0,a0,-1712 # 6f38 <malloc+0x1248>
    25f0:	00003097          	auipc	ra,0x3
    25f4:	640080e7          	jalr	1600(ra) # 5c30 <printf>
    exit(1);
    25f8:	4505                	li	a0,1
    25fa:	00003097          	auipc	ra,0x3
    25fe:	2a6080e7          	jalr	678(ra) # 58a0 <exit>
  close(fd);
    2602:	854a                	mv	a0,s2
    2604:	00003097          	auipc	ra,0x3
    2608:	2c4080e7          	jalr	708(ra) # 58c8 <close>
  unlink("rwsbrk");
    260c:	00005517          	auipc	a0,0x5
    2610:	92450513          	addi	a0,a0,-1756 # 6f30 <malloc+0x1240>
    2614:	00003097          	auipc	ra,0x3
    2618:	2dc080e7          	jalr	732(ra) # 58f0 <unlink>
  fd = open("README", O_RDONLY);
    261c:	4581                	li	a1,0
    261e:	00004517          	auipc	a0,0x4
    2622:	daa50513          	addi	a0,a0,-598 # 63c8 <malloc+0x6d8>
    2626:	00003097          	auipc	ra,0x3
    262a:	2ba080e7          	jalr	698(ra) # 58e0 <open>
    262e:	892a                	mv	s2,a0
  if(fd < 0){
    2630:	02054963          	bltz	a0,2662 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2634:	4629                	li	a2,10
    2636:	85a6                	mv	a1,s1
    2638:	00003097          	auipc	ra,0x3
    263c:	280080e7          	jalr	640(ra) # 58b8 <read>
  if(n >= 0){
    2640:	02054e63          	bltz	a0,267c <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2644:	862a                	mv	a2,a0
    2646:	85a6                	mv	a1,s1
    2648:	00005517          	auipc	a0,0x5
    264c:	93850513          	addi	a0,a0,-1736 # 6f80 <malloc+0x1290>
    2650:	00003097          	auipc	ra,0x3
    2654:	5e0080e7          	jalr	1504(ra) # 5c30 <printf>
    exit(1);
    2658:	4505                	li	a0,1
    265a:	00003097          	auipc	ra,0x3
    265e:	246080e7          	jalr	582(ra) # 58a0 <exit>
    printf("open(rwsbrk) failed\n");
    2662:	00005517          	auipc	a0,0x5
    2666:	8d650513          	addi	a0,a0,-1834 # 6f38 <malloc+0x1248>
    266a:	00003097          	auipc	ra,0x3
    266e:	5c6080e7          	jalr	1478(ra) # 5c30 <printf>
    exit(1);
    2672:	4505                	li	a0,1
    2674:	00003097          	auipc	ra,0x3
    2678:	22c080e7          	jalr	556(ra) # 58a0 <exit>
  close(fd);
    267c:	854a                	mv	a0,s2
    267e:	00003097          	auipc	ra,0x3
    2682:	24a080e7          	jalr	586(ra) # 58c8 <close>
  exit(0);
    2686:	4501                	li	a0,0
    2688:	00003097          	auipc	ra,0x3
    268c:	218080e7          	jalr	536(ra) # 58a0 <exit>

0000000000002690 <sbrkbasic>:
{
    2690:	715d                	addi	sp,sp,-80
    2692:	e486                	sd	ra,72(sp)
    2694:	e0a2                	sd	s0,64(sp)
    2696:	fc26                	sd	s1,56(sp)
    2698:	f84a                	sd	s2,48(sp)
    269a:	f44e                	sd	s3,40(sp)
    269c:	f052                	sd	s4,32(sp)
    269e:	ec56                	sd	s5,24(sp)
    26a0:	0880                	addi	s0,sp,80
    26a2:	8aaa                	mv	s5,a0
  pid = fork();
    26a4:	00003097          	auipc	ra,0x3
    26a8:	1f4080e7          	jalr	500(ra) # 5898 <fork>
  if(pid < 0){
    26ac:	02054c63          	bltz	a0,26e4 <sbrkbasic+0x54>
  if(pid == 0){
    26b0:	ed21                	bnez	a0,2708 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    26b2:	40000537          	lui	a0,0x40000
    26b6:	00003097          	auipc	ra,0x3
    26ba:	272080e7          	jalr	626(ra) # 5928 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    26be:	57fd                	li	a5,-1
    26c0:	02f50f63          	beq	a0,a5,26fe <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26c4:	400007b7          	lui	a5,0x40000
    26c8:	97aa                	add	a5,a5,a0
      *b = 99;
    26ca:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    26ce:	6705                	lui	a4,0x1
      *b = 99;
    26d0:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff11f8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26d4:	953a                	add	a0,a0,a4
    26d6:	fef51de3          	bne	a0,a5,26d0 <sbrkbasic+0x40>
    exit(1);
    26da:	4505                	li	a0,1
    26dc:	00003097          	auipc	ra,0x3
    26e0:	1c4080e7          	jalr	452(ra) # 58a0 <exit>
    printf("fork failed in sbrkbasic\n");
    26e4:	00005517          	auipc	a0,0x5
    26e8:	8c450513          	addi	a0,a0,-1852 # 6fa8 <malloc+0x12b8>
    26ec:	00003097          	auipc	ra,0x3
    26f0:	544080e7          	jalr	1348(ra) # 5c30 <printf>
    exit(1);
    26f4:	4505                	li	a0,1
    26f6:	00003097          	auipc	ra,0x3
    26fa:	1aa080e7          	jalr	426(ra) # 58a0 <exit>
      exit(0);
    26fe:	4501                	li	a0,0
    2700:	00003097          	auipc	ra,0x3
    2704:	1a0080e7          	jalr	416(ra) # 58a0 <exit>
  wait(&xstatus);
    2708:	fbc40513          	addi	a0,s0,-68
    270c:	00003097          	auipc	ra,0x3
    2710:	19c080e7          	jalr	412(ra) # 58a8 <wait>
  if(xstatus == 1){
    2714:	fbc42703          	lw	a4,-68(s0)
    2718:	4785                	li	a5,1
    271a:	00f70e63          	beq	a4,a5,2736 <sbrkbasic+0xa6>
  a = sbrk(0);
    271e:	4501                	li	a0,0
    2720:	00003097          	auipc	ra,0x3
    2724:	208080e7          	jalr	520(ra) # 5928 <sbrk>
    2728:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    272a:	4901                	li	s2,0
    *b = 1;
    272c:	4a05                	li	s4,1
  for(i = 0; i < 5000; i++){
    272e:	6985                	lui	s3,0x1
    2730:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1c2>
    2734:	a005                	j	2754 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    2736:	85d6                	mv	a1,s5
    2738:	00005517          	auipc	a0,0x5
    273c:	89050513          	addi	a0,a0,-1904 # 6fc8 <malloc+0x12d8>
    2740:	00003097          	auipc	ra,0x3
    2744:	4f0080e7          	jalr	1264(ra) # 5c30 <printf>
    exit(1);
    2748:	4505                	li	a0,1
    274a:	00003097          	auipc	ra,0x3
    274e:	156080e7          	jalr	342(ra) # 58a0 <exit>
    a = b + 1;
    2752:	84be                	mv	s1,a5
    b = sbrk(1);
    2754:	4505                	li	a0,1
    2756:	00003097          	auipc	ra,0x3
    275a:	1d2080e7          	jalr	466(ra) # 5928 <sbrk>
    if(b != a){
    275e:	04951b63          	bne	a0,s1,27b4 <sbrkbasic+0x124>
    *b = 1;
    2762:	01448023          	sb	s4,0(s1)
    a = b + 1;
    2766:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    276a:	2905                	addiw	s2,s2,1
    276c:	ff3913e3          	bne	s2,s3,2752 <sbrkbasic+0xc2>
  pid = fork();
    2770:	00003097          	auipc	ra,0x3
    2774:	128080e7          	jalr	296(ra) # 5898 <fork>
    2778:	892a                	mv	s2,a0
  if(pid < 0){
    277a:	04054e63          	bltz	a0,27d6 <sbrkbasic+0x146>
  c = sbrk(1);
    277e:	4505                	li	a0,1
    2780:	00003097          	auipc	ra,0x3
    2784:	1a8080e7          	jalr	424(ra) # 5928 <sbrk>
  c = sbrk(1);
    2788:	4505                	li	a0,1
    278a:	00003097          	auipc	ra,0x3
    278e:	19e080e7          	jalr	414(ra) # 5928 <sbrk>
  if(c != a + 1){
    2792:	0489                	addi	s1,s1,2
    2794:	04a48f63          	beq	s1,a0,27f2 <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    2798:	85d6                	mv	a1,s5
    279a:	00005517          	auipc	a0,0x5
    279e:	88e50513          	addi	a0,a0,-1906 # 7028 <malloc+0x1338>
    27a2:	00003097          	auipc	ra,0x3
    27a6:	48e080e7          	jalr	1166(ra) # 5c30 <printf>
    exit(1);
    27aa:	4505                	li	a0,1
    27ac:	00003097          	auipc	ra,0x3
    27b0:	0f4080e7          	jalr	244(ra) # 58a0 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    27b4:	872a                	mv	a4,a0
    27b6:	86a6                	mv	a3,s1
    27b8:	864a                	mv	a2,s2
    27ba:	85d6                	mv	a1,s5
    27bc:	00005517          	auipc	a0,0x5
    27c0:	82c50513          	addi	a0,a0,-2004 # 6fe8 <malloc+0x12f8>
    27c4:	00003097          	auipc	ra,0x3
    27c8:	46c080e7          	jalr	1132(ra) # 5c30 <printf>
      exit(1);
    27cc:	4505                	li	a0,1
    27ce:	00003097          	auipc	ra,0x3
    27d2:	0d2080e7          	jalr	210(ra) # 58a0 <exit>
    printf("%s: sbrk test fork failed\n", s);
    27d6:	85d6                	mv	a1,s5
    27d8:	00005517          	auipc	a0,0x5
    27dc:	83050513          	addi	a0,a0,-2000 # 7008 <malloc+0x1318>
    27e0:	00003097          	auipc	ra,0x3
    27e4:	450080e7          	jalr	1104(ra) # 5c30 <printf>
    exit(1);
    27e8:	4505                	li	a0,1
    27ea:	00003097          	auipc	ra,0x3
    27ee:	0b6080e7          	jalr	182(ra) # 58a0 <exit>
  if(pid == 0)
    27f2:	00091763          	bnez	s2,2800 <sbrkbasic+0x170>
    exit(0);
    27f6:	4501                	li	a0,0
    27f8:	00003097          	auipc	ra,0x3
    27fc:	0a8080e7          	jalr	168(ra) # 58a0 <exit>
  wait(&xstatus);
    2800:	fbc40513          	addi	a0,s0,-68
    2804:	00003097          	auipc	ra,0x3
    2808:	0a4080e7          	jalr	164(ra) # 58a8 <wait>
  exit(xstatus);
    280c:	fbc42503          	lw	a0,-68(s0)
    2810:	00003097          	auipc	ra,0x3
    2814:	090080e7          	jalr	144(ra) # 58a0 <exit>

0000000000002818 <sbrkmuch>:
{
    2818:	7179                	addi	sp,sp,-48
    281a:	f406                	sd	ra,40(sp)
    281c:	f022                	sd	s0,32(sp)
    281e:	ec26                	sd	s1,24(sp)
    2820:	e84a                	sd	s2,16(sp)
    2822:	e44e                	sd	s3,8(sp)
    2824:	e052                	sd	s4,0(sp)
    2826:	1800                	addi	s0,sp,48
    2828:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    282a:	4501                	li	a0,0
    282c:	00003097          	auipc	ra,0x3
    2830:	0fc080e7          	jalr	252(ra) # 5928 <sbrk>
    2834:	892a                	mv	s2,a0
  a = sbrk(0);
    2836:	4501                	li	a0,0
    2838:	00003097          	auipc	ra,0x3
    283c:	0f0080e7          	jalr	240(ra) # 5928 <sbrk>
    2840:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2842:	06400537          	lui	a0,0x6400
    2846:	9d05                	subw	a0,a0,s1
    2848:	00003097          	auipc	ra,0x3
    284c:	0e0080e7          	jalr	224(ra) # 5928 <sbrk>
  if (p != a) {
    2850:	0ca49763          	bne	s1,a0,291e <sbrkmuch+0x106>
  char *eee = sbrk(0);
    2854:	4501                	li	a0,0
    2856:	00003097          	auipc	ra,0x3
    285a:	0d2080e7          	jalr	210(ra) # 5928 <sbrk>
  for(char *pp = a; pp < eee; pp += 4096)
    285e:	00a4f963          	bgeu	s1,a0,2870 <sbrkmuch+0x58>
    *pp = 1;
    2862:	4705                	li	a4,1
  for(char *pp = a; pp < eee; pp += 4096)
    2864:	6785                	lui	a5,0x1
    *pp = 1;
    2866:	00e48023          	sb	a4,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    286a:	94be                	add	s1,s1,a5
    286c:	fea4ede3          	bltu	s1,a0,2866 <sbrkmuch+0x4e>
  *lastaddr = 99;
    2870:	064007b7          	lui	a5,0x6400
    2874:	06300713          	li	a4,99
    2878:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f11f7>
  a = sbrk(0);
    287c:	4501                	li	a0,0
    287e:	00003097          	auipc	ra,0x3
    2882:	0aa080e7          	jalr	170(ra) # 5928 <sbrk>
    2886:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2888:	757d                	lui	a0,0xfffff
    288a:	00003097          	auipc	ra,0x3
    288e:	09e080e7          	jalr	158(ra) # 5928 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2892:	57fd                	li	a5,-1
    2894:	0af50363          	beq	a0,a5,293a <sbrkmuch+0x122>
  c = sbrk(0);
    2898:	4501                	li	a0,0
    289a:	00003097          	auipc	ra,0x3
    289e:	08e080e7          	jalr	142(ra) # 5928 <sbrk>
  if(c != a - PGSIZE){
    28a2:	77fd                	lui	a5,0xfffff
    28a4:	97a6                	add	a5,a5,s1
    28a6:	0af51863          	bne	a0,a5,2956 <sbrkmuch+0x13e>
  a = sbrk(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	07c080e7          	jalr	124(ra) # 5928 <sbrk>
    28b4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    28b6:	6505                	lui	a0,0x1
    28b8:	00003097          	auipc	ra,0x3
    28bc:	070080e7          	jalr	112(ra) # 5928 <sbrk>
    28c0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    28c2:	0aa49a63          	bne	s1,a0,2976 <sbrkmuch+0x15e>
    28c6:	4501                	li	a0,0
    28c8:	00003097          	auipc	ra,0x3
    28cc:	060080e7          	jalr	96(ra) # 5928 <sbrk>
    28d0:	6785                	lui	a5,0x1
    28d2:	97a6                	add	a5,a5,s1
    28d4:	0af51163          	bne	a0,a5,2976 <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    28d8:	064007b7          	lui	a5,0x6400
    28dc:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f11f7>
    28e0:	06300793          	li	a5,99
    28e4:	0af70963          	beq	a4,a5,2996 <sbrkmuch+0x17e>
  a = sbrk(0);
    28e8:	4501                	li	a0,0
    28ea:	00003097          	auipc	ra,0x3
    28ee:	03e080e7          	jalr	62(ra) # 5928 <sbrk>
    28f2:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    28f4:	4501                	li	a0,0
    28f6:	00003097          	auipc	ra,0x3
    28fa:	032080e7          	jalr	50(ra) # 5928 <sbrk>
    28fe:	40a9053b          	subw	a0,s2,a0
    2902:	00003097          	auipc	ra,0x3
    2906:	026080e7          	jalr	38(ra) # 5928 <sbrk>
  if(c != a){
    290a:	0aa49463          	bne	s1,a0,29b2 <sbrkmuch+0x19a>
}
    290e:	70a2                	ld	ra,40(sp)
    2910:	7402                	ld	s0,32(sp)
    2912:	64e2                	ld	s1,24(sp)
    2914:	6942                	ld	s2,16(sp)
    2916:	69a2                	ld	s3,8(sp)
    2918:	6a02                	ld	s4,0(sp)
    291a:	6145                	addi	sp,sp,48
    291c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    291e:	85ce                	mv	a1,s3
    2920:	00004517          	auipc	a0,0x4
    2924:	72850513          	addi	a0,a0,1832 # 7048 <malloc+0x1358>
    2928:	00003097          	auipc	ra,0x3
    292c:	308080e7          	jalr	776(ra) # 5c30 <printf>
    exit(1);
    2930:	4505                	li	a0,1
    2932:	00003097          	auipc	ra,0x3
    2936:	f6e080e7          	jalr	-146(ra) # 58a0 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    293a:	85ce                	mv	a1,s3
    293c:	00004517          	auipc	a0,0x4
    2940:	75450513          	addi	a0,a0,1876 # 7090 <malloc+0x13a0>
    2944:	00003097          	auipc	ra,0x3
    2948:	2ec080e7          	jalr	748(ra) # 5c30 <printf>
    exit(1);
    294c:	4505                	li	a0,1
    294e:	00003097          	auipc	ra,0x3
    2952:	f52080e7          	jalr	-174(ra) # 58a0 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2956:	86aa                	mv	a3,a0
    2958:	8626                	mv	a2,s1
    295a:	85ce                	mv	a1,s3
    295c:	00004517          	auipc	a0,0x4
    2960:	75450513          	addi	a0,a0,1876 # 70b0 <malloc+0x13c0>
    2964:	00003097          	auipc	ra,0x3
    2968:	2cc080e7          	jalr	716(ra) # 5c30 <printf>
    exit(1);
    296c:	4505                	li	a0,1
    296e:	00003097          	auipc	ra,0x3
    2972:	f32080e7          	jalr	-206(ra) # 58a0 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2976:	86d2                	mv	a3,s4
    2978:	8626                	mv	a2,s1
    297a:	85ce                	mv	a1,s3
    297c:	00004517          	auipc	a0,0x4
    2980:	77450513          	addi	a0,a0,1908 # 70f0 <malloc+0x1400>
    2984:	00003097          	auipc	ra,0x3
    2988:	2ac080e7          	jalr	684(ra) # 5c30 <printf>
    exit(1);
    298c:	4505                	li	a0,1
    298e:	00003097          	auipc	ra,0x3
    2992:	f12080e7          	jalr	-238(ra) # 58a0 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2996:	85ce                	mv	a1,s3
    2998:	00004517          	auipc	a0,0x4
    299c:	78850513          	addi	a0,a0,1928 # 7120 <malloc+0x1430>
    29a0:	00003097          	auipc	ra,0x3
    29a4:	290080e7          	jalr	656(ra) # 5c30 <printf>
    exit(1);
    29a8:	4505                	li	a0,1
    29aa:	00003097          	auipc	ra,0x3
    29ae:	ef6080e7          	jalr	-266(ra) # 58a0 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    29b2:	86aa                	mv	a3,a0
    29b4:	8626                	mv	a2,s1
    29b6:	85ce                	mv	a1,s3
    29b8:	00004517          	auipc	a0,0x4
    29bc:	7a050513          	addi	a0,a0,1952 # 7158 <malloc+0x1468>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	270080e7          	jalr	624(ra) # 5c30 <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	ed6080e7          	jalr	-298(ra) # 58a0 <exit>

00000000000029d2 <sbrkarg>:
{
    29d2:	7179                	addi	sp,sp,-48
    29d4:	f406                	sd	ra,40(sp)
    29d6:	f022                	sd	s0,32(sp)
    29d8:	ec26                	sd	s1,24(sp)
    29da:	e84a                	sd	s2,16(sp)
    29dc:	e44e                	sd	s3,8(sp)
    29de:	1800                	addi	s0,sp,48
    29e0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    29e2:	6505                	lui	a0,0x1
    29e4:	00003097          	auipc	ra,0x3
    29e8:	f44080e7          	jalr	-188(ra) # 5928 <sbrk>
    29ec:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    29ee:	20100593          	li	a1,513
    29f2:	00004517          	auipc	a0,0x4
    29f6:	78e50513          	addi	a0,a0,1934 # 7180 <malloc+0x1490>
    29fa:	00003097          	auipc	ra,0x3
    29fe:	ee6080e7          	jalr	-282(ra) # 58e0 <open>
    2a02:	84aa                	mv	s1,a0
  unlink("sbrk");
    2a04:	00004517          	auipc	a0,0x4
    2a08:	77c50513          	addi	a0,a0,1916 # 7180 <malloc+0x1490>
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	ee4080e7          	jalr	-284(ra) # 58f0 <unlink>
  if(fd < 0)  {
    2a14:	0404c163          	bltz	s1,2a56 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2a18:	6605                	lui	a2,0x1
    2a1a:	85ca                	mv	a1,s2
    2a1c:	8526                	mv	a0,s1
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	ea2080e7          	jalr	-350(ra) # 58c0 <write>
    2a26:	04054663          	bltz	a0,2a72 <sbrkarg+0xa0>
  close(fd);
    2a2a:	8526                	mv	a0,s1
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	e9c080e7          	jalr	-356(ra) # 58c8 <close>
  a = sbrk(PGSIZE);
    2a34:	6505                	lui	a0,0x1
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	ef2080e7          	jalr	-270(ra) # 5928 <sbrk>
  if(pipe((int *) a) != 0){
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	e72080e7          	jalr	-398(ra) # 58b0 <pipe>
    2a46:	e521                	bnez	a0,2a8e <sbrkarg+0xbc>
}
    2a48:	70a2                	ld	ra,40(sp)
    2a4a:	7402                	ld	s0,32(sp)
    2a4c:	64e2                	ld	s1,24(sp)
    2a4e:	6942                	ld	s2,16(sp)
    2a50:	69a2                	ld	s3,8(sp)
    2a52:	6145                	addi	sp,sp,48
    2a54:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2a56:	85ce                	mv	a1,s3
    2a58:	00004517          	auipc	a0,0x4
    2a5c:	73050513          	addi	a0,a0,1840 # 7188 <malloc+0x1498>
    2a60:	00003097          	auipc	ra,0x3
    2a64:	1d0080e7          	jalr	464(ra) # 5c30 <printf>
    exit(1);
    2a68:	4505                	li	a0,1
    2a6a:	00003097          	auipc	ra,0x3
    2a6e:	e36080e7          	jalr	-458(ra) # 58a0 <exit>
    printf("%s: write sbrk failed\n", s);
    2a72:	85ce                	mv	a1,s3
    2a74:	00004517          	auipc	a0,0x4
    2a78:	72c50513          	addi	a0,a0,1836 # 71a0 <malloc+0x14b0>
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	1b4080e7          	jalr	436(ra) # 5c30 <printf>
    exit(1);
    2a84:	4505                	li	a0,1
    2a86:	00003097          	auipc	ra,0x3
    2a8a:	e1a080e7          	jalr	-486(ra) # 58a0 <exit>
    printf("%s: pipe() failed\n", s);
    2a8e:	85ce                	mv	a1,s3
    2a90:	00004517          	auipc	a0,0x4
    2a94:	0f050513          	addi	a0,a0,240 # 6b80 <malloc+0xe90>
    2a98:	00003097          	auipc	ra,0x3
    2a9c:	198080e7          	jalr	408(ra) # 5c30 <printf>
    exit(1);
    2aa0:	4505                	li	a0,1
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	dfe080e7          	jalr	-514(ra) # 58a0 <exit>

0000000000002aaa <argptest>:
{
    2aaa:	1101                	addi	sp,sp,-32
    2aac:	ec06                	sd	ra,24(sp)
    2aae:	e822                	sd	s0,16(sp)
    2ab0:	e426                	sd	s1,8(sp)
    2ab2:	e04a                	sd	s2,0(sp)
    2ab4:	1000                	addi	s0,sp,32
    2ab6:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2ab8:	4581                	li	a1,0
    2aba:	00004517          	auipc	a0,0x4
    2abe:	6fe50513          	addi	a0,a0,1790 # 71b8 <malloc+0x14c8>
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	e1e080e7          	jalr	-482(ra) # 58e0 <open>
  if (fd < 0) {
    2aca:	02054b63          	bltz	a0,2b00 <argptest+0x56>
    2ace:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2ad0:	4501                	li	a0,0
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	e56080e7          	jalr	-426(ra) # 5928 <sbrk>
    2ada:	567d                	li	a2,-1
    2adc:	fff50593          	addi	a1,a0,-1
    2ae0:	8526                	mv	a0,s1
    2ae2:	00003097          	auipc	ra,0x3
    2ae6:	dd6080e7          	jalr	-554(ra) # 58b8 <read>
  close(fd);
    2aea:	8526                	mv	a0,s1
    2aec:	00003097          	auipc	ra,0x3
    2af0:	ddc080e7          	jalr	-548(ra) # 58c8 <close>
}
    2af4:	60e2                	ld	ra,24(sp)
    2af6:	6442                	ld	s0,16(sp)
    2af8:	64a2                	ld	s1,8(sp)
    2afa:	6902                	ld	s2,0(sp)
    2afc:	6105                	addi	sp,sp,32
    2afe:	8082                	ret
    printf("%s: open failed\n", s);
    2b00:	85ca                	mv	a1,s2
    2b02:	00004517          	auipc	a0,0x4
    2b06:	f8e50513          	addi	a0,a0,-114 # 6a90 <malloc+0xda0>
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	126080e7          	jalr	294(ra) # 5c30 <printf>
    exit(1);
    2b12:	4505                	li	a0,1
    2b14:	00003097          	auipc	ra,0x3
    2b18:	d8c080e7          	jalr	-628(ra) # 58a0 <exit>

0000000000002b1c <sbrkbugs>:
{
    2b1c:	1141                	addi	sp,sp,-16
    2b1e:	e406                	sd	ra,8(sp)
    2b20:	e022                	sd	s0,0(sp)
    2b22:	0800                	addi	s0,sp,16
  int pid = fork();
    2b24:	00003097          	auipc	ra,0x3
    2b28:	d74080e7          	jalr	-652(ra) # 5898 <fork>
  if(pid < 0){
    2b2c:	02054363          	bltz	a0,2b52 <sbrkbugs+0x36>
  if(pid == 0){
    2b30:	ed15                	bnez	a0,2b6c <sbrkbugs+0x50>
    int sz = (uint64) sbrk(0);
    2b32:	00003097          	auipc	ra,0x3
    2b36:	df6080e7          	jalr	-522(ra) # 5928 <sbrk>
    sbrk(-sz);
    2b3a:	40a0053b          	negw	a0,a0
    2b3e:	2501                	sext.w	a0,a0
    2b40:	00003097          	auipc	ra,0x3
    2b44:	de8080e7          	jalr	-536(ra) # 5928 <sbrk>
    exit(0);
    2b48:	4501                	li	a0,0
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	d56080e7          	jalr	-682(ra) # 58a0 <exit>
    printf("fork failed\n");
    2b52:	00004517          	auipc	a0,0x4
    2b56:	34650513          	addi	a0,a0,838 # 6e98 <malloc+0x11a8>
    2b5a:	00003097          	auipc	ra,0x3
    2b5e:	0d6080e7          	jalr	214(ra) # 5c30 <printf>
    exit(1);
    2b62:	4505                	li	a0,1
    2b64:	00003097          	auipc	ra,0x3
    2b68:	d3c080e7          	jalr	-708(ra) # 58a0 <exit>
  wait(0);
    2b6c:	4501                	li	a0,0
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	d3a080e7          	jalr	-710(ra) # 58a8 <wait>
  pid = fork();
    2b76:	00003097          	auipc	ra,0x3
    2b7a:	d22080e7          	jalr	-734(ra) # 5898 <fork>
  if(pid < 0){
    2b7e:	02054563          	bltz	a0,2ba8 <sbrkbugs+0x8c>
  if(pid == 0){
    2b82:	e121                	bnez	a0,2bc2 <sbrkbugs+0xa6>
    int sz = (uint64) sbrk(0);
    2b84:	00003097          	auipc	ra,0x3
    2b88:	da4080e7          	jalr	-604(ra) # 5928 <sbrk>
    sbrk(-(sz - 3500));
    2b8c:	6785                	lui	a5,0x1
    2b8e:	dac7879b          	addiw	a5,a5,-596
    2b92:	40a7853b          	subw	a0,a5,a0
    2b96:	00003097          	auipc	ra,0x3
    2b9a:	d92080e7          	jalr	-622(ra) # 5928 <sbrk>
    exit(0);
    2b9e:	4501                	li	a0,0
    2ba0:	00003097          	auipc	ra,0x3
    2ba4:	d00080e7          	jalr	-768(ra) # 58a0 <exit>
    printf("fork failed\n");
    2ba8:	00004517          	auipc	a0,0x4
    2bac:	2f050513          	addi	a0,a0,752 # 6e98 <malloc+0x11a8>
    2bb0:	00003097          	auipc	ra,0x3
    2bb4:	080080e7          	jalr	128(ra) # 5c30 <printf>
    exit(1);
    2bb8:	4505                	li	a0,1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	ce6080e7          	jalr	-794(ra) # 58a0 <exit>
  wait(0);
    2bc2:	4501                	li	a0,0
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	ce4080e7          	jalr	-796(ra) # 58a8 <wait>
  pid = fork();
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	ccc080e7          	jalr	-820(ra) # 5898 <fork>
  if(pid < 0){
    2bd4:	02054a63          	bltz	a0,2c08 <sbrkbugs+0xec>
  if(pid == 0){
    2bd8:	e529                	bnez	a0,2c22 <sbrkbugs+0x106>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2bda:	00003097          	auipc	ra,0x3
    2bde:	d4e080e7          	jalr	-690(ra) # 5928 <sbrk>
    2be2:	67ad                	lui	a5,0xb
    2be4:	8007879b          	addiw	a5,a5,-2048
    2be8:	40a7853b          	subw	a0,a5,a0
    2bec:	00003097          	auipc	ra,0x3
    2bf0:	d3c080e7          	jalr	-708(ra) # 5928 <sbrk>
    sbrk(-10);
    2bf4:	5559                	li	a0,-10
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	d32080e7          	jalr	-718(ra) # 5928 <sbrk>
    exit(0);
    2bfe:	4501                	li	a0,0
    2c00:	00003097          	auipc	ra,0x3
    2c04:	ca0080e7          	jalr	-864(ra) # 58a0 <exit>
    printf("fork failed\n");
    2c08:	00004517          	auipc	a0,0x4
    2c0c:	29050513          	addi	a0,a0,656 # 6e98 <malloc+0x11a8>
    2c10:	00003097          	auipc	ra,0x3
    2c14:	020080e7          	jalr	32(ra) # 5c30 <printf>
    exit(1);
    2c18:	4505                	li	a0,1
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	c86080e7          	jalr	-890(ra) # 58a0 <exit>
  wait(0);
    2c22:	4501                	li	a0,0
    2c24:	00003097          	auipc	ra,0x3
    2c28:	c84080e7          	jalr	-892(ra) # 58a8 <wait>
  exit(0);
    2c2c:	4501                	li	a0,0
    2c2e:	00003097          	auipc	ra,0x3
    2c32:	c72080e7          	jalr	-910(ra) # 58a0 <exit>

0000000000002c36 <sbrklast>:
{
    2c36:	7179                	addi	sp,sp,-48
    2c38:	f406                	sd	ra,40(sp)
    2c3a:	f022                	sd	s0,32(sp)
    2c3c:	ec26                	sd	s1,24(sp)
    2c3e:	e84a                	sd	s2,16(sp)
    2c40:	e44e                	sd	s3,8(sp)
    2c42:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c44:	4501                	li	a0,0
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	ce2080e7          	jalr	-798(ra) # 5928 <sbrk>
  if((top % 4096) != 0)
    2c4e:	6785                	lui	a5,0x1
    2c50:	17fd                	addi	a5,a5,-1
    2c52:	8fe9                	and	a5,a5,a0
    2c54:	efc1                	bnez	a5,2cec <sbrklast+0xb6>
  sbrk(4096);
    2c56:	6505                	lui	a0,0x1
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	cd0080e7          	jalr	-816(ra) # 5928 <sbrk>
  sbrk(10);
    2c60:	4529                	li	a0,10
    2c62:	00003097          	auipc	ra,0x3
    2c66:	cc6080e7          	jalr	-826(ra) # 5928 <sbrk>
  sbrk(-20);
    2c6a:	5531                	li	a0,-20
    2c6c:	00003097          	auipc	ra,0x3
    2c70:	cbc080e7          	jalr	-836(ra) # 5928 <sbrk>
  top = (uint64) sbrk(0);
    2c74:	4501                	li	a0,0
    2c76:	00003097          	auipc	ra,0x3
    2c7a:	cb2080e7          	jalr	-846(ra) # 5928 <sbrk>
    2c7e:	892a                	mv	s2,a0
  char *p = (char *) (top - 64);
    2c80:	fc050493          	addi	s1,a0,-64 # fc0 <bigdir+0x4c>
  p[0] = 'x';
    2c84:	07800793          	li	a5,120
    2c88:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2c8c:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2c90:	20200593          	li	a1,514
    2c94:	8526                	mv	a0,s1
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	c4a080e7          	jalr	-950(ra) # 58e0 <open>
    2c9e:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ca0:	4605                	li	a2,1
    2ca2:	85a6                	mv	a1,s1
    2ca4:	00003097          	auipc	ra,0x3
    2ca8:	c1c080e7          	jalr	-996(ra) # 58c0 <write>
  close(fd);
    2cac:	854e                	mv	a0,s3
    2cae:	00003097          	auipc	ra,0x3
    2cb2:	c1a080e7          	jalr	-998(ra) # 58c8 <close>
  fd = open(p, O_RDWR);
    2cb6:	4589                	li	a1,2
    2cb8:	8526                	mv	a0,s1
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	c26080e7          	jalr	-986(ra) # 58e0 <open>
  p[0] = '\0';
    2cc2:	fc090023          	sb	zero,-64(s2)
  read(fd, p, 1);
    2cc6:	4605                	li	a2,1
    2cc8:	85a6                	mv	a1,s1
    2cca:	00003097          	auipc	ra,0x3
    2cce:	bee080e7          	jalr	-1042(ra) # 58b8 <read>
  if(p[0] != 'x')
    2cd2:	fc094703          	lbu	a4,-64(s2)
    2cd6:	07800793          	li	a5,120
    2cda:	02f71463          	bne	a4,a5,2d02 <sbrklast+0xcc>
}
    2cde:	70a2                	ld	ra,40(sp)
    2ce0:	7402                	ld	s0,32(sp)
    2ce2:	64e2                	ld	s1,24(sp)
    2ce4:	6942                	ld	s2,16(sp)
    2ce6:	69a2                	ld	s3,8(sp)
    2ce8:	6145                	addi	sp,sp,48
    2cea:	8082                	ret
    sbrk(4096 - (top % 4096));
    2cec:	6785                	lui	a5,0x1
    2cee:	17fd                	addi	a5,a5,-1
    2cf0:	8d7d                	and	a0,a0,a5
    2cf2:	6785                	lui	a5,0x1
    2cf4:	40a7853b          	subw	a0,a5,a0
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	c30080e7          	jalr	-976(ra) # 5928 <sbrk>
    2d00:	bf99                	j	2c56 <sbrklast+0x20>
    exit(1);
    2d02:	4505                	li	a0,1
    2d04:	00003097          	auipc	ra,0x3
    2d08:	b9c080e7          	jalr	-1124(ra) # 58a0 <exit>

0000000000002d0c <sbrk8000>:
{
    2d0c:	1141                	addi	sp,sp,-16
    2d0e:	e406                	sd	ra,8(sp)
    2d10:	e022                	sd	s0,0(sp)
    2d12:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2d14:	80000537          	lui	a0,0x80000
    2d18:	0511                	addi	a0,a0,4
    2d1a:	00003097          	auipc	ra,0x3
    2d1e:	c0e080e7          	jalr	-1010(ra) # 5928 <sbrk>
  volatile char *top = sbrk(0);
    2d22:	4501                	li	a0,0
    2d24:	00003097          	auipc	ra,0x3
    2d28:	c04080e7          	jalr	-1020(ra) # 5928 <sbrk>
  *(top-1) = *(top-1) + 1;
    2d2c:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <__BSS_END__+0xffffffff7fff11f7>
    2d30:	0785                	addi	a5,a5,1
    2d32:	0ff7f793          	andi	a5,a5,255
    2d36:	fef50fa3          	sb	a5,-1(a0)
}
    2d3a:	60a2                	ld	ra,8(sp)
    2d3c:	6402                	ld	s0,0(sp)
    2d3e:	0141                	addi	sp,sp,16
    2d40:	8082                	ret

0000000000002d42 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2d42:	715d                	addi	sp,sp,-80
    2d44:	e486                	sd	ra,72(sp)
    2d46:	e0a2                	sd	s0,64(sp)
    2d48:	fc26                	sd	s1,56(sp)
    2d4a:	f84a                	sd	s2,48(sp)
    2d4c:	f44e                	sd	s3,40(sp)
    2d4e:	f052                	sd	s4,32(sp)
    2d50:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2d52:	4901                	li	s2,0
    2d54:	49bd                	li	s3,15
    int pid = fork();
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	b42080e7          	jalr	-1214(ra) # 5898 <fork>
    2d5e:	84aa                	mv	s1,a0
    if(pid < 0){
    2d60:	02054063          	bltz	a0,2d80 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2d64:	c91d                	beqz	a0,2d9a <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2d66:	4501                	li	a0,0
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	b40080e7          	jalr	-1216(ra) # 58a8 <wait>
  for(int avail = 0; avail < 15; avail++){
    2d70:	2905                	addiw	s2,s2,1
    2d72:	ff3912e3          	bne	s2,s3,2d56 <execout+0x14>
    }
  }

  exit(0);
    2d76:	4501                	li	a0,0
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	b28080e7          	jalr	-1240(ra) # 58a0 <exit>
      printf("fork failed\n");
    2d80:	00004517          	auipc	a0,0x4
    2d84:	11850513          	addi	a0,a0,280 # 6e98 <malloc+0x11a8>
    2d88:	00003097          	auipc	ra,0x3
    2d8c:	ea8080e7          	jalr	-344(ra) # 5c30 <printf>
      exit(1);
    2d90:	4505                	li	a0,1
    2d92:	00003097          	auipc	ra,0x3
    2d96:	b0e080e7          	jalr	-1266(ra) # 58a0 <exit>
        if(a == 0xffffffffffffffffLL)
    2d9a:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2d9c:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2d9e:	6505                	lui	a0,0x1
    2da0:	00003097          	auipc	ra,0x3
    2da4:	b88080e7          	jalr	-1144(ra) # 5928 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2da8:	01350763          	beq	a0,s3,2db6 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2dac:	6785                	lui	a5,0x1
    2dae:	97aa                	add	a5,a5,a0
    2db0:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x8b>
      while(1){
    2db4:	b7ed                	j	2d9e <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2db6:	01205a63          	blez	s2,2dca <execout+0x88>
        sbrk(-4096);
    2dba:	757d                	lui	a0,0xfffff
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	b6c080e7          	jalr	-1172(ra) # 5928 <sbrk>
      for(int i = 0; i < avail; i++)
    2dc4:	2485                	addiw	s1,s1,1
    2dc6:	ff249ae3          	bne	s1,s2,2dba <execout+0x78>
      close(1);
    2dca:	4505                	li	a0,1
    2dcc:	00003097          	auipc	ra,0x3
    2dd0:	afc080e7          	jalr	-1284(ra) # 58c8 <close>
      char *args[] = { "echo", "x", 0 };
    2dd4:	00003517          	auipc	a0,0x3
    2dd8:	44c50513          	addi	a0,a0,1100 # 6220 <malloc+0x530>
    2ddc:	faa43c23          	sd	a0,-72(s0)
    2de0:	00003797          	auipc	a5,0x3
    2de4:	4b078793          	addi	a5,a5,1200 # 6290 <malloc+0x5a0>
    2de8:	fcf43023          	sd	a5,-64(s0)
    2dec:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2df0:	fb840593          	addi	a1,s0,-72
    2df4:	00003097          	auipc	ra,0x3
    2df8:	ae4080e7          	jalr	-1308(ra) # 58d8 <exec>
      exit(0);
    2dfc:	4501                	li	a0,0
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	aa2080e7          	jalr	-1374(ra) # 58a0 <exit>

0000000000002e06 <fourteen>:
{
    2e06:	1101                	addi	sp,sp,-32
    2e08:	ec06                	sd	ra,24(sp)
    2e0a:	e822                	sd	s0,16(sp)
    2e0c:	e426                	sd	s1,8(sp)
    2e0e:	1000                	addi	s0,sp,32
    2e10:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2e12:	00004517          	auipc	a0,0x4
    2e16:	57e50513          	addi	a0,a0,1406 # 7390 <malloc+0x16a0>
    2e1a:	00003097          	auipc	ra,0x3
    2e1e:	aee080e7          	jalr	-1298(ra) # 5908 <mkdir>
    2e22:	e165                	bnez	a0,2f02 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2e24:	00004517          	auipc	a0,0x4
    2e28:	3c450513          	addi	a0,a0,964 # 71e8 <malloc+0x14f8>
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	adc080e7          	jalr	-1316(ra) # 5908 <mkdir>
    2e34:	e56d                	bnez	a0,2f1e <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e36:	20000593          	li	a1,512
    2e3a:	00004517          	auipc	a0,0x4
    2e3e:	40650513          	addi	a0,a0,1030 # 7240 <malloc+0x1550>
    2e42:	00003097          	auipc	ra,0x3
    2e46:	a9e080e7          	jalr	-1378(ra) # 58e0 <open>
  if(fd < 0){
    2e4a:	0e054863          	bltz	a0,2f3a <fourteen+0x134>
  close(fd);
    2e4e:	00003097          	auipc	ra,0x3
    2e52:	a7a080e7          	jalr	-1414(ra) # 58c8 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2e56:	4581                	li	a1,0
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	46050513          	addi	a0,a0,1120 # 72b8 <malloc+0x15c8>
    2e60:	00003097          	auipc	ra,0x3
    2e64:	a80080e7          	jalr	-1408(ra) # 58e0 <open>
  if(fd < 0){
    2e68:	0e054763          	bltz	a0,2f56 <fourteen+0x150>
  close(fd);
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	a5c080e7          	jalr	-1444(ra) # 58c8 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2e74:	00004517          	auipc	a0,0x4
    2e78:	4b450513          	addi	a0,a0,1204 # 7328 <malloc+0x1638>
    2e7c:	00003097          	auipc	ra,0x3
    2e80:	a8c080e7          	jalr	-1396(ra) # 5908 <mkdir>
    2e84:	c57d                	beqz	a0,2f72 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2e86:	00004517          	auipc	a0,0x4
    2e8a:	4fa50513          	addi	a0,a0,1274 # 7380 <malloc+0x1690>
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	a7a080e7          	jalr	-1414(ra) # 5908 <mkdir>
    2e96:	cd65                	beqz	a0,2f8e <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2e98:	00004517          	auipc	a0,0x4
    2e9c:	4e850513          	addi	a0,a0,1256 # 7380 <malloc+0x1690>
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	a50080e7          	jalr	-1456(ra) # 58f0 <unlink>
  unlink("12345678901234/12345678901234");
    2ea8:	00004517          	auipc	a0,0x4
    2eac:	48050513          	addi	a0,a0,1152 # 7328 <malloc+0x1638>
    2eb0:	00003097          	auipc	ra,0x3
    2eb4:	a40080e7          	jalr	-1472(ra) # 58f0 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2eb8:	00004517          	auipc	a0,0x4
    2ebc:	40050513          	addi	a0,a0,1024 # 72b8 <malloc+0x15c8>
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	a30080e7          	jalr	-1488(ra) # 58f0 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	37850513          	addi	a0,a0,888 # 7240 <malloc+0x1550>
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	a20080e7          	jalr	-1504(ra) # 58f0 <unlink>
  unlink("12345678901234/123456789012345");
    2ed8:	00004517          	auipc	a0,0x4
    2edc:	31050513          	addi	a0,a0,784 # 71e8 <malloc+0x14f8>
    2ee0:	00003097          	auipc	ra,0x3
    2ee4:	a10080e7          	jalr	-1520(ra) # 58f0 <unlink>
  unlink("12345678901234");
    2ee8:	00004517          	auipc	a0,0x4
    2eec:	4a850513          	addi	a0,a0,1192 # 7390 <malloc+0x16a0>
    2ef0:	00003097          	auipc	ra,0x3
    2ef4:	a00080e7          	jalr	-1536(ra) # 58f0 <unlink>
}
    2ef8:	60e2                	ld	ra,24(sp)
    2efa:	6442                	ld	s0,16(sp)
    2efc:	64a2                	ld	s1,8(sp)
    2efe:	6105                	addi	sp,sp,32
    2f00:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2f02:	85a6                	mv	a1,s1
    2f04:	00004517          	auipc	a0,0x4
    2f08:	2bc50513          	addi	a0,a0,700 # 71c0 <malloc+0x14d0>
    2f0c:	00003097          	auipc	ra,0x3
    2f10:	d24080e7          	jalr	-732(ra) # 5c30 <printf>
    exit(1);
    2f14:	4505                	li	a0,1
    2f16:	00003097          	auipc	ra,0x3
    2f1a:	98a080e7          	jalr	-1654(ra) # 58a0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2f1e:	85a6                	mv	a1,s1
    2f20:	00004517          	auipc	a0,0x4
    2f24:	2e850513          	addi	a0,a0,744 # 7208 <malloc+0x1518>
    2f28:	00003097          	auipc	ra,0x3
    2f2c:	d08080e7          	jalr	-760(ra) # 5c30 <printf>
    exit(1);
    2f30:	4505                	li	a0,1
    2f32:	00003097          	auipc	ra,0x3
    2f36:	96e080e7          	jalr	-1682(ra) # 58a0 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f3a:	85a6                	mv	a1,s1
    2f3c:	00004517          	auipc	a0,0x4
    2f40:	33450513          	addi	a0,a0,820 # 7270 <malloc+0x1580>
    2f44:	00003097          	auipc	ra,0x3
    2f48:	cec080e7          	jalr	-788(ra) # 5c30 <printf>
    exit(1);
    2f4c:	4505                	li	a0,1
    2f4e:	00003097          	auipc	ra,0x3
    2f52:	952080e7          	jalr	-1710(ra) # 58a0 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2f56:	85a6                	mv	a1,s1
    2f58:	00004517          	auipc	a0,0x4
    2f5c:	39050513          	addi	a0,a0,912 # 72e8 <malloc+0x15f8>
    2f60:	00003097          	auipc	ra,0x3
    2f64:	cd0080e7          	jalr	-816(ra) # 5c30 <printf>
    exit(1);
    2f68:	4505                	li	a0,1
    2f6a:	00003097          	auipc	ra,0x3
    2f6e:	936080e7          	jalr	-1738(ra) # 58a0 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2f72:	85a6                	mv	a1,s1
    2f74:	00004517          	auipc	a0,0x4
    2f78:	3d450513          	addi	a0,a0,980 # 7348 <malloc+0x1658>
    2f7c:	00003097          	auipc	ra,0x3
    2f80:	cb4080e7          	jalr	-844(ra) # 5c30 <printf>
    exit(1);
    2f84:	4505                	li	a0,1
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	91a080e7          	jalr	-1766(ra) # 58a0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2f8e:	85a6                	mv	a1,s1
    2f90:	00004517          	auipc	a0,0x4
    2f94:	41050513          	addi	a0,a0,1040 # 73a0 <malloc+0x16b0>
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	c98080e7          	jalr	-872(ra) # 5c30 <printf>
    exit(1);
    2fa0:	4505                	li	a0,1
    2fa2:	00003097          	auipc	ra,0x3
    2fa6:	8fe080e7          	jalr	-1794(ra) # 58a0 <exit>

0000000000002faa <iputtest>:
{
    2faa:	1101                	addi	sp,sp,-32
    2fac:	ec06                	sd	ra,24(sp)
    2fae:	e822                	sd	s0,16(sp)
    2fb0:	e426                	sd	s1,8(sp)
    2fb2:	1000                	addi	s0,sp,32
    2fb4:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2fb6:	00004517          	auipc	a0,0x4
    2fba:	42250513          	addi	a0,a0,1058 # 73d8 <malloc+0x16e8>
    2fbe:	00003097          	auipc	ra,0x3
    2fc2:	94a080e7          	jalr	-1718(ra) # 5908 <mkdir>
    2fc6:	04054563          	bltz	a0,3010 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2fca:	00004517          	auipc	a0,0x4
    2fce:	40e50513          	addi	a0,a0,1038 # 73d8 <malloc+0x16e8>
    2fd2:	00003097          	auipc	ra,0x3
    2fd6:	93e080e7          	jalr	-1730(ra) # 5910 <chdir>
    2fda:	04054963          	bltz	a0,302c <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	43a50513          	addi	a0,a0,1082 # 7418 <malloc+0x1728>
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	90a080e7          	jalr	-1782(ra) # 58f0 <unlink>
    2fee:	04054d63          	bltz	a0,3048 <iputtest+0x9e>
  if(chdir("/") < 0){
    2ff2:	00004517          	auipc	a0,0x4
    2ff6:	45650513          	addi	a0,a0,1110 # 7448 <malloc+0x1758>
    2ffa:	00003097          	auipc	ra,0x3
    2ffe:	916080e7          	jalr	-1770(ra) # 5910 <chdir>
    3002:	06054163          	bltz	a0,3064 <iputtest+0xba>
}
    3006:	60e2                	ld	ra,24(sp)
    3008:	6442                	ld	s0,16(sp)
    300a:	64a2                	ld	s1,8(sp)
    300c:	6105                	addi	sp,sp,32
    300e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3010:	85a6                	mv	a1,s1
    3012:	00004517          	auipc	a0,0x4
    3016:	3ce50513          	addi	a0,a0,974 # 73e0 <malloc+0x16f0>
    301a:	00003097          	auipc	ra,0x3
    301e:	c16080e7          	jalr	-1002(ra) # 5c30 <printf>
    exit(1);
    3022:	4505                	li	a0,1
    3024:	00003097          	auipc	ra,0x3
    3028:	87c080e7          	jalr	-1924(ra) # 58a0 <exit>
    printf("%s: chdir iputdir failed\n", s);
    302c:	85a6                	mv	a1,s1
    302e:	00004517          	auipc	a0,0x4
    3032:	3ca50513          	addi	a0,a0,970 # 73f8 <malloc+0x1708>
    3036:	00003097          	auipc	ra,0x3
    303a:	bfa080e7          	jalr	-1030(ra) # 5c30 <printf>
    exit(1);
    303e:	4505                	li	a0,1
    3040:	00003097          	auipc	ra,0x3
    3044:	860080e7          	jalr	-1952(ra) # 58a0 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3048:	85a6                	mv	a1,s1
    304a:	00004517          	auipc	a0,0x4
    304e:	3de50513          	addi	a0,a0,990 # 7428 <malloc+0x1738>
    3052:	00003097          	auipc	ra,0x3
    3056:	bde080e7          	jalr	-1058(ra) # 5c30 <printf>
    exit(1);
    305a:	4505                	li	a0,1
    305c:	00003097          	auipc	ra,0x3
    3060:	844080e7          	jalr	-1980(ra) # 58a0 <exit>
    printf("%s: chdir / failed\n", s);
    3064:	85a6                	mv	a1,s1
    3066:	00004517          	auipc	a0,0x4
    306a:	3ea50513          	addi	a0,a0,1002 # 7450 <malloc+0x1760>
    306e:	00003097          	auipc	ra,0x3
    3072:	bc2080e7          	jalr	-1086(ra) # 5c30 <printf>
    exit(1);
    3076:	4505                	li	a0,1
    3078:	00003097          	auipc	ra,0x3
    307c:	828080e7          	jalr	-2008(ra) # 58a0 <exit>

0000000000003080 <exitiputtest>:
{
    3080:	7179                	addi	sp,sp,-48
    3082:	f406                	sd	ra,40(sp)
    3084:	f022                	sd	s0,32(sp)
    3086:	ec26                	sd	s1,24(sp)
    3088:	1800                	addi	s0,sp,48
    308a:	84aa                	mv	s1,a0
  pid = fork();
    308c:	00003097          	auipc	ra,0x3
    3090:	80c080e7          	jalr	-2036(ra) # 5898 <fork>
  if(pid < 0){
    3094:	04054663          	bltz	a0,30e0 <exitiputtest+0x60>
  if(pid == 0){
    3098:	ed45                	bnez	a0,3150 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    309a:	00004517          	auipc	a0,0x4
    309e:	33e50513          	addi	a0,a0,830 # 73d8 <malloc+0x16e8>
    30a2:	00003097          	auipc	ra,0x3
    30a6:	866080e7          	jalr	-1946(ra) # 5908 <mkdir>
    30aa:	04054963          	bltz	a0,30fc <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    30ae:	00004517          	auipc	a0,0x4
    30b2:	32a50513          	addi	a0,a0,810 # 73d8 <malloc+0x16e8>
    30b6:	00003097          	auipc	ra,0x3
    30ba:	85a080e7          	jalr	-1958(ra) # 5910 <chdir>
    30be:	04054d63          	bltz	a0,3118 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    30c2:	00004517          	auipc	a0,0x4
    30c6:	35650513          	addi	a0,a0,854 # 7418 <malloc+0x1728>
    30ca:	00003097          	auipc	ra,0x3
    30ce:	826080e7          	jalr	-2010(ra) # 58f0 <unlink>
    30d2:	06054163          	bltz	a0,3134 <exitiputtest+0xb4>
    exit(0);
    30d6:	4501                	li	a0,0
    30d8:	00002097          	auipc	ra,0x2
    30dc:	7c8080e7          	jalr	1992(ra) # 58a0 <exit>
    printf("%s: fork failed\n", s);
    30e0:	85a6                	mv	a1,s1
    30e2:	00004517          	auipc	a0,0x4
    30e6:	99650513          	addi	a0,a0,-1642 # 6a78 <malloc+0xd88>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	b46080e7          	jalr	-1210(ra) # 5c30 <printf>
    exit(1);
    30f2:	4505                	li	a0,1
    30f4:	00002097          	auipc	ra,0x2
    30f8:	7ac080e7          	jalr	1964(ra) # 58a0 <exit>
      printf("%s: mkdir failed\n", s);
    30fc:	85a6                	mv	a1,s1
    30fe:	00004517          	auipc	a0,0x4
    3102:	2e250513          	addi	a0,a0,738 # 73e0 <malloc+0x16f0>
    3106:	00003097          	auipc	ra,0x3
    310a:	b2a080e7          	jalr	-1238(ra) # 5c30 <printf>
      exit(1);
    310e:	4505                	li	a0,1
    3110:	00002097          	auipc	ra,0x2
    3114:	790080e7          	jalr	1936(ra) # 58a0 <exit>
      printf("%s: child chdir failed\n", s);
    3118:	85a6                	mv	a1,s1
    311a:	00004517          	auipc	a0,0x4
    311e:	34e50513          	addi	a0,a0,846 # 7468 <malloc+0x1778>
    3122:	00003097          	auipc	ra,0x3
    3126:	b0e080e7          	jalr	-1266(ra) # 5c30 <printf>
      exit(1);
    312a:	4505                	li	a0,1
    312c:	00002097          	auipc	ra,0x2
    3130:	774080e7          	jalr	1908(ra) # 58a0 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3134:	85a6                	mv	a1,s1
    3136:	00004517          	auipc	a0,0x4
    313a:	2f250513          	addi	a0,a0,754 # 7428 <malloc+0x1738>
    313e:	00003097          	auipc	ra,0x3
    3142:	af2080e7          	jalr	-1294(ra) # 5c30 <printf>
      exit(1);
    3146:	4505                	li	a0,1
    3148:	00002097          	auipc	ra,0x2
    314c:	758080e7          	jalr	1880(ra) # 58a0 <exit>
  wait(&xstatus);
    3150:	fdc40513          	addi	a0,s0,-36
    3154:	00002097          	auipc	ra,0x2
    3158:	754080e7          	jalr	1876(ra) # 58a8 <wait>
  exit(xstatus);
    315c:	fdc42503          	lw	a0,-36(s0)
    3160:	00002097          	auipc	ra,0x2
    3164:	740080e7          	jalr	1856(ra) # 58a0 <exit>

0000000000003168 <dirtest>:
{
    3168:	1101                	addi	sp,sp,-32
    316a:	ec06                	sd	ra,24(sp)
    316c:	e822                	sd	s0,16(sp)
    316e:	e426                	sd	s1,8(sp)
    3170:	1000                	addi	s0,sp,32
    3172:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3174:	00004517          	auipc	a0,0x4
    3178:	30c50513          	addi	a0,a0,780 # 7480 <malloc+0x1790>
    317c:	00002097          	auipc	ra,0x2
    3180:	78c080e7          	jalr	1932(ra) # 5908 <mkdir>
    3184:	04054563          	bltz	a0,31ce <dirtest+0x66>
  if(chdir("dir0") < 0){
    3188:	00004517          	auipc	a0,0x4
    318c:	2f850513          	addi	a0,a0,760 # 7480 <malloc+0x1790>
    3190:	00002097          	auipc	ra,0x2
    3194:	780080e7          	jalr	1920(ra) # 5910 <chdir>
    3198:	04054963          	bltz	a0,31ea <dirtest+0x82>
  if(chdir("..") < 0){
    319c:	00004517          	auipc	a0,0x4
    31a0:	30450513          	addi	a0,a0,772 # 74a0 <malloc+0x17b0>
    31a4:	00002097          	auipc	ra,0x2
    31a8:	76c080e7          	jalr	1900(ra) # 5910 <chdir>
    31ac:	04054d63          	bltz	a0,3206 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    31b0:	00004517          	auipc	a0,0x4
    31b4:	2d050513          	addi	a0,a0,720 # 7480 <malloc+0x1790>
    31b8:	00002097          	auipc	ra,0x2
    31bc:	738080e7          	jalr	1848(ra) # 58f0 <unlink>
    31c0:	06054163          	bltz	a0,3222 <dirtest+0xba>
}
    31c4:	60e2                	ld	ra,24(sp)
    31c6:	6442                	ld	s0,16(sp)
    31c8:	64a2                	ld	s1,8(sp)
    31ca:	6105                	addi	sp,sp,32
    31cc:	8082                	ret
    printf("%s: mkdir failed\n", s);
    31ce:	85a6                	mv	a1,s1
    31d0:	00004517          	auipc	a0,0x4
    31d4:	21050513          	addi	a0,a0,528 # 73e0 <malloc+0x16f0>
    31d8:	00003097          	auipc	ra,0x3
    31dc:	a58080e7          	jalr	-1448(ra) # 5c30 <printf>
    exit(1);
    31e0:	4505                	li	a0,1
    31e2:	00002097          	auipc	ra,0x2
    31e6:	6be080e7          	jalr	1726(ra) # 58a0 <exit>
    printf("%s: chdir dir0 failed\n", s);
    31ea:	85a6                	mv	a1,s1
    31ec:	00004517          	auipc	a0,0x4
    31f0:	29c50513          	addi	a0,a0,668 # 7488 <malloc+0x1798>
    31f4:	00003097          	auipc	ra,0x3
    31f8:	a3c080e7          	jalr	-1476(ra) # 5c30 <printf>
    exit(1);
    31fc:	4505                	li	a0,1
    31fe:	00002097          	auipc	ra,0x2
    3202:	6a2080e7          	jalr	1698(ra) # 58a0 <exit>
    printf("%s: chdir .. failed\n", s);
    3206:	85a6                	mv	a1,s1
    3208:	00004517          	auipc	a0,0x4
    320c:	2a050513          	addi	a0,a0,672 # 74a8 <malloc+0x17b8>
    3210:	00003097          	auipc	ra,0x3
    3214:	a20080e7          	jalr	-1504(ra) # 5c30 <printf>
    exit(1);
    3218:	4505                	li	a0,1
    321a:	00002097          	auipc	ra,0x2
    321e:	686080e7          	jalr	1670(ra) # 58a0 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3222:	85a6                	mv	a1,s1
    3224:	00004517          	auipc	a0,0x4
    3228:	29c50513          	addi	a0,a0,668 # 74c0 <malloc+0x17d0>
    322c:	00003097          	auipc	ra,0x3
    3230:	a04080e7          	jalr	-1532(ra) # 5c30 <printf>
    exit(1);
    3234:	4505                	li	a0,1
    3236:	00002097          	auipc	ra,0x2
    323a:	66a080e7          	jalr	1642(ra) # 58a0 <exit>

000000000000323e <subdir>:
{
    323e:	1101                	addi	sp,sp,-32
    3240:	ec06                	sd	ra,24(sp)
    3242:	e822                	sd	s0,16(sp)
    3244:	e426                	sd	s1,8(sp)
    3246:	e04a                	sd	s2,0(sp)
    3248:	1000                	addi	s0,sp,32
    324a:	892a                	mv	s2,a0
  unlink("ff");
    324c:	00004517          	auipc	a0,0x4
    3250:	3bc50513          	addi	a0,a0,956 # 7608 <malloc+0x1918>
    3254:	00002097          	auipc	ra,0x2
    3258:	69c080e7          	jalr	1692(ra) # 58f0 <unlink>
  if(mkdir("dd") != 0){
    325c:	00004517          	auipc	a0,0x4
    3260:	27c50513          	addi	a0,a0,636 # 74d8 <malloc+0x17e8>
    3264:	00002097          	auipc	ra,0x2
    3268:	6a4080e7          	jalr	1700(ra) # 5908 <mkdir>
    326c:	38051663          	bnez	a0,35f8 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3270:	20200593          	li	a1,514
    3274:	00004517          	auipc	a0,0x4
    3278:	28450513          	addi	a0,a0,644 # 74f8 <malloc+0x1808>
    327c:	00002097          	auipc	ra,0x2
    3280:	664080e7          	jalr	1636(ra) # 58e0 <open>
    3284:	84aa                	mv	s1,a0
  if(fd < 0){
    3286:	38054763          	bltz	a0,3614 <subdir+0x3d6>
  write(fd, "ff", 2);
    328a:	4609                	li	a2,2
    328c:	00004597          	auipc	a1,0x4
    3290:	37c58593          	addi	a1,a1,892 # 7608 <malloc+0x1918>
    3294:	00002097          	auipc	ra,0x2
    3298:	62c080e7          	jalr	1580(ra) # 58c0 <write>
  close(fd);
    329c:	8526                	mv	a0,s1
    329e:	00002097          	auipc	ra,0x2
    32a2:	62a080e7          	jalr	1578(ra) # 58c8 <close>
  if(unlink("dd") >= 0){
    32a6:	00004517          	auipc	a0,0x4
    32aa:	23250513          	addi	a0,a0,562 # 74d8 <malloc+0x17e8>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	642080e7          	jalr	1602(ra) # 58f0 <unlink>
    32b6:	36055d63          	bgez	a0,3630 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    32ba:	00004517          	auipc	a0,0x4
    32be:	29650513          	addi	a0,a0,662 # 7550 <malloc+0x1860>
    32c2:	00002097          	auipc	ra,0x2
    32c6:	646080e7          	jalr	1606(ra) # 5908 <mkdir>
    32ca:	38051163          	bnez	a0,364c <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    32ce:	20200593          	li	a1,514
    32d2:	00004517          	auipc	a0,0x4
    32d6:	2a650513          	addi	a0,a0,678 # 7578 <malloc+0x1888>
    32da:	00002097          	auipc	ra,0x2
    32de:	606080e7          	jalr	1542(ra) # 58e0 <open>
    32e2:	84aa                	mv	s1,a0
  if(fd < 0){
    32e4:	38054263          	bltz	a0,3668 <subdir+0x42a>
  write(fd, "FF", 2);
    32e8:	4609                	li	a2,2
    32ea:	00004597          	auipc	a1,0x4
    32ee:	2be58593          	addi	a1,a1,702 # 75a8 <malloc+0x18b8>
    32f2:	00002097          	auipc	ra,0x2
    32f6:	5ce080e7          	jalr	1486(ra) # 58c0 <write>
  close(fd);
    32fa:	8526                	mv	a0,s1
    32fc:	00002097          	auipc	ra,0x2
    3300:	5cc080e7          	jalr	1484(ra) # 58c8 <close>
  fd = open("dd/dd/../ff", 0);
    3304:	4581                	li	a1,0
    3306:	00004517          	auipc	a0,0x4
    330a:	2aa50513          	addi	a0,a0,682 # 75b0 <malloc+0x18c0>
    330e:	00002097          	auipc	ra,0x2
    3312:	5d2080e7          	jalr	1490(ra) # 58e0 <open>
    3316:	84aa                	mv	s1,a0
  if(fd < 0){
    3318:	36054663          	bltz	a0,3684 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    331c:	660d                	lui	a2,0x3
    331e:	00009597          	auipc	a1,0x9
    3322:	ada58593          	addi	a1,a1,-1318 # bdf8 <buf>
    3326:	00002097          	auipc	ra,0x2
    332a:	592080e7          	jalr	1426(ra) # 58b8 <read>
  if(cc != 2 || buf[0] != 'f'){
    332e:	4789                	li	a5,2
    3330:	36f51863          	bne	a0,a5,36a0 <subdir+0x462>
    3334:	00009717          	auipc	a4,0x9
    3338:	ac474703          	lbu	a4,-1340(a4) # bdf8 <buf>
    333c:	06600793          	li	a5,102
    3340:	36f71063          	bne	a4,a5,36a0 <subdir+0x462>
  close(fd);
    3344:	8526                	mv	a0,s1
    3346:	00002097          	auipc	ra,0x2
    334a:	582080e7          	jalr	1410(ra) # 58c8 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    334e:	00004597          	auipc	a1,0x4
    3352:	2b258593          	addi	a1,a1,690 # 7600 <malloc+0x1910>
    3356:	00004517          	auipc	a0,0x4
    335a:	22250513          	addi	a0,a0,546 # 7578 <malloc+0x1888>
    335e:	00002097          	auipc	ra,0x2
    3362:	5a2080e7          	jalr	1442(ra) # 5900 <link>
    3366:	34051b63          	bnez	a0,36bc <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    336a:	00004517          	auipc	a0,0x4
    336e:	20e50513          	addi	a0,a0,526 # 7578 <malloc+0x1888>
    3372:	00002097          	auipc	ra,0x2
    3376:	57e080e7          	jalr	1406(ra) # 58f0 <unlink>
    337a:	34051f63          	bnez	a0,36d8 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    337e:	4581                	li	a1,0
    3380:	00004517          	auipc	a0,0x4
    3384:	1f850513          	addi	a0,a0,504 # 7578 <malloc+0x1888>
    3388:	00002097          	auipc	ra,0x2
    338c:	558080e7          	jalr	1368(ra) # 58e0 <open>
    3390:	36055263          	bgez	a0,36f4 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3394:	00004517          	auipc	a0,0x4
    3398:	14450513          	addi	a0,a0,324 # 74d8 <malloc+0x17e8>
    339c:	00002097          	auipc	ra,0x2
    33a0:	574080e7          	jalr	1396(ra) # 5910 <chdir>
    33a4:	36051663          	bnez	a0,3710 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    33a8:	00004517          	auipc	a0,0x4
    33ac:	2f050513          	addi	a0,a0,752 # 7698 <malloc+0x19a8>
    33b0:	00002097          	auipc	ra,0x2
    33b4:	560080e7          	jalr	1376(ra) # 5910 <chdir>
    33b8:	36051a63          	bnez	a0,372c <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    33bc:	00004517          	auipc	a0,0x4
    33c0:	30c50513          	addi	a0,a0,780 # 76c8 <malloc+0x19d8>
    33c4:	00002097          	auipc	ra,0x2
    33c8:	54c080e7          	jalr	1356(ra) # 5910 <chdir>
    33cc:	36051e63          	bnez	a0,3748 <subdir+0x50a>
  if(chdir("./..") != 0){
    33d0:	00004517          	auipc	a0,0x4
    33d4:	32850513          	addi	a0,a0,808 # 76f8 <malloc+0x1a08>
    33d8:	00002097          	auipc	ra,0x2
    33dc:	538080e7          	jalr	1336(ra) # 5910 <chdir>
    33e0:	38051263          	bnez	a0,3764 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    33e4:	4581                	li	a1,0
    33e6:	00004517          	auipc	a0,0x4
    33ea:	21a50513          	addi	a0,a0,538 # 7600 <malloc+0x1910>
    33ee:	00002097          	auipc	ra,0x2
    33f2:	4f2080e7          	jalr	1266(ra) # 58e0 <open>
    33f6:	84aa                	mv	s1,a0
  if(fd < 0){
    33f8:	38054463          	bltz	a0,3780 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    33fc:	660d                	lui	a2,0x3
    33fe:	00009597          	auipc	a1,0x9
    3402:	9fa58593          	addi	a1,a1,-1542 # bdf8 <buf>
    3406:	00002097          	auipc	ra,0x2
    340a:	4b2080e7          	jalr	1202(ra) # 58b8 <read>
    340e:	4789                	li	a5,2
    3410:	38f51663          	bne	a0,a5,379c <subdir+0x55e>
  close(fd);
    3414:	8526                	mv	a0,s1
    3416:	00002097          	auipc	ra,0x2
    341a:	4b2080e7          	jalr	1202(ra) # 58c8 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    341e:	4581                	li	a1,0
    3420:	00004517          	auipc	a0,0x4
    3424:	15850513          	addi	a0,a0,344 # 7578 <malloc+0x1888>
    3428:	00002097          	auipc	ra,0x2
    342c:	4b8080e7          	jalr	1208(ra) # 58e0 <open>
    3430:	38055463          	bgez	a0,37b8 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3434:	20200593          	li	a1,514
    3438:	00004517          	auipc	a0,0x4
    343c:	35050513          	addi	a0,a0,848 # 7788 <malloc+0x1a98>
    3440:	00002097          	auipc	ra,0x2
    3444:	4a0080e7          	jalr	1184(ra) # 58e0 <open>
    3448:	38055663          	bgez	a0,37d4 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    344c:	20200593          	li	a1,514
    3450:	00004517          	auipc	a0,0x4
    3454:	36850513          	addi	a0,a0,872 # 77b8 <malloc+0x1ac8>
    3458:	00002097          	auipc	ra,0x2
    345c:	488080e7          	jalr	1160(ra) # 58e0 <open>
    3460:	38055863          	bgez	a0,37f0 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3464:	20000593          	li	a1,512
    3468:	00004517          	auipc	a0,0x4
    346c:	07050513          	addi	a0,a0,112 # 74d8 <malloc+0x17e8>
    3470:	00002097          	auipc	ra,0x2
    3474:	470080e7          	jalr	1136(ra) # 58e0 <open>
    3478:	38055a63          	bgez	a0,380c <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    347c:	4589                	li	a1,2
    347e:	00004517          	auipc	a0,0x4
    3482:	05a50513          	addi	a0,a0,90 # 74d8 <malloc+0x17e8>
    3486:	00002097          	auipc	ra,0x2
    348a:	45a080e7          	jalr	1114(ra) # 58e0 <open>
    348e:	38055d63          	bgez	a0,3828 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3492:	4585                	li	a1,1
    3494:	00004517          	auipc	a0,0x4
    3498:	04450513          	addi	a0,a0,68 # 74d8 <malloc+0x17e8>
    349c:	00002097          	auipc	ra,0x2
    34a0:	444080e7          	jalr	1092(ra) # 58e0 <open>
    34a4:	3a055063          	bgez	a0,3844 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    34a8:	00004597          	auipc	a1,0x4
    34ac:	3a058593          	addi	a1,a1,928 # 7848 <malloc+0x1b58>
    34b0:	00004517          	auipc	a0,0x4
    34b4:	2d850513          	addi	a0,a0,728 # 7788 <malloc+0x1a98>
    34b8:	00002097          	auipc	ra,0x2
    34bc:	448080e7          	jalr	1096(ra) # 5900 <link>
    34c0:	3a050063          	beqz	a0,3860 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    34c4:	00004597          	auipc	a1,0x4
    34c8:	38458593          	addi	a1,a1,900 # 7848 <malloc+0x1b58>
    34cc:	00004517          	auipc	a0,0x4
    34d0:	2ec50513          	addi	a0,a0,748 # 77b8 <malloc+0x1ac8>
    34d4:	00002097          	auipc	ra,0x2
    34d8:	42c080e7          	jalr	1068(ra) # 5900 <link>
    34dc:	3a050063          	beqz	a0,387c <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    34e0:	00004597          	auipc	a1,0x4
    34e4:	12058593          	addi	a1,a1,288 # 7600 <malloc+0x1910>
    34e8:	00004517          	auipc	a0,0x4
    34ec:	01050513          	addi	a0,a0,16 # 74f8 <malloc+0x1808>
    34f0:	00002097          	auipc	ra,0x2
    34f4:	410080e7          	jalr	1040(ra) # 5900 <link>
    34f8:	3a050063          	beqz	a0,3898 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    34fc:	00004517          	auipc	a0,0x4
    3500:	28c50513          	addi	a0,a0,652 # 7788 <malloc+0x1a98>
    3504:	00002097          	auipc	ra,0x2
    3508:	404080e7          	jalr	1028(ra) # 5908 <mkdir>
    350c:	3a050463          	beqz	a0,38b4 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3510:	00004517          	auipc	a0,0x4
    3514:	2a850513          	addi	a0,a0,680 # 77b8 <malloc+0x1ac8>
    3518:	00002097          	auipc	ra,0x2
    351c:	3f0080e7          	jalr	1008(ra) # 5908 <mkdir>
    3520:	3a050863          	beqz	a0,38d0 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3524:	00004517          	auipc	a0,0x4
    3528:	0dc50513          	addi	a0,a0,220 # 7600 <malloc+0x1910>
    352c:	00002097          	auipc	ra,0x2
    3530:	3dc080e7          	jalr	988(ra) # 5908 <mkdir>
    3534:	3a050c63          	beqz	a0,38ec <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3538:	00004517          	auipc	a0,0x4
    353c:	28050513          	addi	a0,a0,640 # 77b8 <malloc+0x1ac8>
    3540:	00002097          	auipc	ra,0x2
    3544:	3b0080e7          	jalr	944(ra) # 58f0 <unlink>
    3548:	3c050063          	beqz	a0,3908 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    354c:	00004517          	auipc	a0,0x4
    3550:	23c50513          	addi	a0,a0,572 # 7788 <malloc+0x1a98>
    3554:	00002097          	auipc	ra,0x2
    3558:	39c080e7          	jalr	924(ra) # 58f0 <unlink>
    355c:	3c050463          	beqz	a0,3924 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3560:	00004517          	auipc	a0,0x4
    3564:	f9850513          	addi	a0,a0,-104 # 74f8 <malloc+0x1808>
    3568:	00002097          	auipc	ra,0x2
    356c:	3a8080e7          	jalr	936(ra) # 5910 <chdir>
    3570:	3c050863          	beqz	a0,3940 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3574:	00004517          	auipc	a0,0x4
    3578:	42450513          	addi	a0,a0,1060 # 7998 <malloc+0x1ca8>
    357c:	00002097          	auipc	ra,0x2
    3580:	394080e7          	jalr	916(ra) # 5910 <chdir>
    3584:	3c050c63          	beqz	a0,395c <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3588:	00004517          	auipc	a0,0x4
    358c:	07850513          	addi	a0,a0,120 # 7600 <malloc+0x1910>
    3590:	00002097          	auipc	ra,0x2
    3594:	360080e7          	jalr	864(ra) # 58f0 <unlink>
    3598:	3e051063          	bnez	a0,3978 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    359c:	00004517          	auipc	a0,0x4
    35a0:	f5c50513          	addi	a0,a0,-164 # 74f8 <malloc+0x1808>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	34c080e7          	jalr	844(ra) # 58f0 <unlink>
    35ac:	3e051463          	bnez	a0,3994 <subdir+0x756>
  if(unlink("dd") == 0){
    35b0:	00004517          	auipc	a0,0x4
    35b4:	f2850513          	addi	a0,a0,-216 # 74d8 <malloc+0x17e8>
    35b8:	00002097          	auipc	ra,0x2
    35bc:	338080e7          	jalr	824(ra) # 58f0 <unlink>
    35c0:	3e050863          	beqz	a0,39b0 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    35c4:	00004517          	auipc	a0,0x4
    35c8:	44450513          	addi	a0,a0,1092 # 7a08 <malloc+0x1d18>
    35cc:	00002097          	auipc	ra,0x2
    35d0:	324080e7          	jalr	804(ra) # 58f0 <unlink>
    35d4:	3e054c63          	bltz	a0,39cc <subdir+0x78e>
  if(unlink("dd") < 0){
    35d8:	00004517          	auipc	a0,0x4
    35dc:	f0050513          	addi	a0,a0,-256 # 74d8 <malloc+0x17e8>
    35e0:	00002097          	auipc	ra,0x2
    35e4:	310080e7          	jalr	784(ra) # 58f0 <unlink>
    35e8:	40054063          	bltz	a0,39e8 <subdir+0x7aa>
}
    35ec:	60e2                	ld	ra,24(sp)
    35ee:	6442                	ld	s0,16(sp)
    35f0:	64a2                	ld	s1,8(sp)
    35f2:	6902                	ld	s2,0(sp)
    35f4:	6105                	addi	sp,sp,32
    35f6:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    35f8:	85ca                	mv	a1,s2
    35fa:	00004517          	auipc	a0,0x4
    35fe:	ee650513          	addi	a0,a0,-282 # 74e0 <malloc+0x17f0>
    3602:	00002097          	auipc	ra,0x2
    3606:	62e080e7          	jalr	1582(ra) # 5c30 <printf>
    exit(1);
    360a:	4505                	li	a0,1
    360c:	00002097          	auipc	ra,0x2
    3610:	294080e7          	jalr	660(ra) # 58a0 <exit>
    printf("%s: create dd/ff failed\n", s);
    3614:	85ca                	mv	a1,s2
    3616:	00004517          	auipc	a0,0x4
    361a:	eea50513          	addi	a0,a0,-278 # 7500 <malloc+0x1810>
    361e:	00002097          	auipc	ra,0x2
    3622:	612080e7          	jalr	1554(ra) # 5c30 <printf>
    exit(1);
    3626:	4505                	li	a0,1
    3628:	00002097          	auipc	ra,0x2
    362c:	278080e7          	jalr	632(ra) # 58a0 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3630:	85ca                	mv	a1,s2
    3632:	00004517          	auipc	a0,0x4
    3636:	eee50513          	addi	a0,a0,-274 # 7520 <malloc+0x1830>
    363a:	00002097          	auipc	ra,0x2
    363e:	5f6080e7          	jalr	1526(ra) # 5c30 <printf>
    exit(1);
    3642:	4505                	li	a0,1
    3644:	00002097          	auipc	ra,0x2
    3648:	25c080e7          	jalr	604(ra) # 58a0 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    364c:	85ca                	mv	a1,s2
    364e:	00004517          	auipc	a0,0x4
    3652:	f0a50513          	addi	a0,a0,-246 # 7558 <malloc+0x1868>
    3656:	00002097          	auipc	ra,0x2
    365a:	5da080e7          	jalr	1498(ra) # 5c30 <printf>
    exit(1);
    365e:	4505                	li	a0,1
    3660:	00002097          	auipc	ra,0x2
    3664:	240080e7          	jalr	576(ra) # 58a0 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3668:	85ca                	mv	a1,s2
    366a:	00004517          	auipc	a0,0x4
    366e:	f1e50513          	addi	a0,a0,-226 # 7588 <malloc+0x1898>
    3672:	00002097          	auipc	ra,0x2
    3676:	5be080e7          	jalr	1470(ra) # 5c30 <printf>
    exit(1);
    367a:	4505                	li	a0,1
    367c:	00002097          	auipc	ra,0x2
    3680:	224080e7          	jalr	548(ra) # 58a0 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3684:	85ca                	mv	a1,s2
    3686:	00004517          	auipc	a0,0x4
    368a:	f3a50513          	addi	a0,a0,-198 # 75c0 <malloc+0x18d0>
    368e:	00002097          	auipc	ra,0x2
    3692:	5a2080e7          	jalr	1442(ra) # 5c30 <printf>
    exit(1);
    3696:	4505                	li	a0,1
    3698:	00002097          	auipc	ra,0x2
    369c:	208080e7          	jalr	520(ra) # 58a0 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    36a0:	85ca                	mv	a1,s2
    36a2:	00004517          	auipc	a0,0x4
    36a6:	f3e50513          	addi	a0,a0,-194 # 75e0 <malloc+0x18f0>
    36aa:	00002097          	auipc	ra,0x2
    36ae:	586080e7          	jalr	1414(ra) # 5c30 <printf>
    exit(1);
    36b2:	4505                	li	a0,1
    36b4:	00002097          	auipc	ra,0x2
    36b8:	1ec080e7          	jalr	492(ra) # 58a0 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    36bc:	85ca                	mv	a1,s2
    36be:	00004517          	auipc	a0,0x4
    36c2:	f5250513          	addi	a0,a0,-174 # 7610 <malloc+0x1920>
    36c6:	00002097          	auipc	ra,0x2
    36ca:	56a080e7          	jalr	1386(ra) # 5c30 <printf>
    exit(1);
    36ce:	4505                	li	a0,1
    36d0:	00002097          	auipc	ra,0x2
    36d4:	1d0080e7          	jalr	464(ra) # 58a0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    36d8:	85ca                	mv	a1,s2
    36da:	00004517          	auipc	a0,0x4
    36de:	f5e50513          	addi	a0,a0,-162 # 7638 <malloc+0x1948>
    36e2:	00002097          	auipc	ra,0x2
    36e6:	54e080e7          	jalr	1358(ra) # 5c30 <printf>
    exit(1);
    36ea:	4505                	li	a0,1
    36ec:	00002097          	auipc	ra,0x2
    36f0:	1b4080e7          	jalr	436(ra) # 58a0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    36f4:	85ca                	mv	a1,s2
    36f6:	00004517          	auipc	a0,0x4
    36fa:	f6250513          	addi	a0,a0,-158 # 7658 <malloc+0x1968>
    36fe:	00002097          	auipc	ra,0x2
    3702:	532080e7          	jalr	1330(ra) # 5c30 <printf>
    exit(1);
    3706:	4505                	li	a0,1
    3708:	00002097          	auipc	ra,0x2
    370c:	198080e7          	jalr	408(ra) # 58a0 <exit>
    printf("%s: chdir dd failed\n", s);
    3710:	85ca                	mv	a1,s2
    3712:	00004517          	auipc	a0,0x4
    3716:	f6e50513          	addi	a0,a0,-146 # 7680 <malloc+0x1990>
    371a:	00002097          	auipc	ra,0x2
    371e:	516080e7          	jalr	1302(ra) # 5c30 <printf>
    exit(1);
    3722:	4505                	li	a0,1
    3724:	00002097          	auipc	ra,0x2
    3728:	17c080e7          	jalr	380(ra) # 58a0 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    372c:	85ca                	mv	a1,s2
    372e:	00004517          	auipc	a0,0x4
    3732:	f7a50513          	addi	a0,a0,-134 # 76a8 <malloc+0x19b8>
    3736:	00002097          	auipc	ra,0x2
    373a:	4fa080e7          	jalr	1274(ra) # 5c30 <printf>
    exit(1);
    373e:	4505                	li	a0,1
    3740:	00002097          	auipc	ra,0x2
    3744:	160080e7          	jalr	352(ra) # 58a0 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3748:	85ca                	mv	a1,s2
    374a:	00004517          	auipc	a0,0x4
    374e:	f8e50513          	addi	a0,a0,-114 # 76d8 <malloc+0x19e8>
    3752:	00002097          	auipc	ra,0x2
    3756:	4de080e7          	jalr	1246(ra) # 5c30 <printf>
    exit(1);
    375a:	4505                	li	a0,1
    375c:	00002097          	auipc	ra,0x2
    3760:	144080e7          	jalr	324(ra) # 58a0 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3764:	85ca                	mv	a1,s2
    3766:	00004517          	auipc	a0,0x4
    376a:	f9a50513          	addi	a0,a0,-102 # 7700 <malloc+0x1a10>
    376e:	00002097          	auipc	ra,0x2
    3772:	4c2080e7          	jalr	1218(ra) # 5c30 <printf>
    exit(1);
    3776:	4505                	li	a0,1
    3778:	00002097          	auipc	ra,0x2
    377c:	128080e7          	jalr	296(ra) # 58a0 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3780:	85ca                	mv	a1,s2
    3782:	00004517          	auipc	a0,0x4
    3786:	f9650513          	addi	a0,a0,-106 # 7718 <malloc+0x1a28>
    378a:	00002097          	auipc	ra,0x2
    378e:	4a6080e7          	jalr	1190(ra) # 5c30 <printf>
    exit(1);
    3792:	4505                	li	a0,1
    3794:	00002097          	auipc	ra,0x2
    3798:	10c080e7          	jalr	268(ra) # 58a0 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    379c:	85ca                	mv	a1,s2
    379e:	00004517          	auipc	a0,0x4
    37a2:	f9a50513          	addi	a0,a0,-102 # 7738 <malloc+0x1a48>
    37a6:	00002097          	auipc	ra,0x2
    37aa:	48a080e7          	jalr	1162(ra) # 5c30 <printf>
    exit(1);
    37ae:	4505                	li	a0,1
    37b0:	00002097          	auipc	ra,0x2
    37b4:	0f0080e7          	jalr	240(ra) # 58a0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    37b8:	85ca                	mv	a1,s2
    37ba:	00004517          	auipc	a0,0x4
    37be:	f9e50513          	addi	a0,a0,-98 # 7758 <malloc+0x1a68>
    37c2:	00002097          	auipc	ra,0x2
    37c6:	46e080e7          	jalr	1134(ra) # 5c30 <printf>
    exit(1);
    37ca:	4505                	li	a0,1
    37cc:	00002097          	auipc	ra,0x2
    37d0:	0d4080e7          	jalr	212(ra) # 58a0 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    37d4:	85ca                	mv	a1,s2
    37d6:	00004517          	auipc	a0,0x4
    37da:	fc250513          	addi	a0,a0,-62 # 7798 <malloc+0x1aa8>
    37de:	00002097          	auipc	ra,0x2
    37e2:	452080e7          	jalr	1106(ra) # 5c30 <printf>
    exit(1);
    37e6:	4505                	li	a0,1
    37e8:	00002097          	auipc	ra,0x2
    37ec:	0b8080e7          	jalr	184(ra) # 58a0 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    37f0:	85ca                	mv	a1,s2
    37f2:	00004517          	auipc	a0,0x4
    37f6:	fd650513          	addi	a0,a0,-42 # 77c8 <malloc+0x1ad8>
    37fa:	00002097          	auipc	ra,0x2
    37fe:	436080e7          	jalr	1078(ra) # 5c30 <printf>
    exit(1);
    3802:	4505                	li	a0,1
    3804:	00002097          	auipc	ra,0x2
    3808:	09c080e7          	jalr	156(ra) # 58a0 <exit>
    printf("%s: create dd succeeded!\n", s);
    380c:	85ca                	mv	a1,s2
    380e:	00004517          	auipc	a0,0x4
    3812:	fda50513          	addi	a0,a0,-38 # 77e8 <malloc+0x1af8>
    3816:	00002097          	auipc	ra,0x2
    381a:	41a080e7          	jalr	1050(ra) # 5c30 <printf>
    exit(1);
    381e:	4505                	li	a0,1
    3820:	00002097          	auipc	ra,0x2
    3824:	080080e7          	jalr	128(ra) # 58a0 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3828:	85ca                	mv	a1,s2
    382a:	00004517          	auipc	a0,0x4
    382e:	fde50513          	addi	a0,a0,-34 # 7808 <malloc+0x1b18>
    3832:	00002097          	auipc	ra,0x2
    3836:	3fe080e7          	jalr	1022(ra) # 5c30 <printf>
    exit(1);
    383a:	4505                	li	a0,1
    383c:	00002097          	auipc	ra,0x2
    3840:	064080e7          	jalr	100(ra) # 58a0 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3844:	85ca                	mv	a1,s2
    3846:	00004517          	auipc	a0,0x4
    384a:	fe250513          	addi	a0,a0,-30 # 7828 <malloc+0x1b38>
    384e:	00002097          	auipc	ra,0x2
    3852:	3e2080e7          	jalr	994(ra) # 5c30 <printf>
    exit(1);
    3856:	4505                	li	a0,1
    3858:	00002097          	auipc	ra,0x2
    385c:	048080e7          	jalr	72(ra) # 58a0 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3860:	85ca                	mv	a1,s2
    3862:	00004517          	auipc	a0,0x4
    3866:	ff650513          	addi	a0,a0,-10 # 7858 <malloc+0x1b68>
    386a:	00002097          	auipc	ra,0x2
    386e:	3c6080e7          	jalr	966(ra) # 5c30 <printf>
    exit(1);
    3872:	4505                	li	a0,1
    3874:	00002097          	auipc	ra,0x2
    3878:	02c080e7          	jalr	44(ra) # 58a0 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    387c:	85ca                	mv	a1,s2
    387e:	00004517          	auipc	a0,0x4
    3882:	00250513          	addi	a0,a0,2 # 7880 <malloc+0x1b90>
    3886:	00002097          	auipc	ra,0x2
    388a:	3aa080e7          	jalr	938(ra) # 5c30 <printf>
    exit(1);
    388e:	4505                	li	a0,1
    3890:	00002097          	auipc	ra,0x2
    3894:	010080e7          	jalr	16(ra) # 58a0 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3898:	85ca                	mv	a1,s2
    389a:	00004517          	auipc	a0,0x4
    389e:	00e50513          	addi	a0,a0,14 # 78a8 <malloc+0x1bb8>
    38a2:	00002097          	auipc	ra,0x2
    38a6:	38e080e7          	jalr	910(ra) # 5c30 <printf>
    exit(1);
    38aa:	4505                	li	a0,1
    38ac:	00002097          	auipc	ra,0x2
    38b0:	ff4080e7          	jalr	-12(ra) # 58a0 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    38b4:	85ca                	mv	a1,s2
    38b6:	00004517          	auipc	a0,0x4
    38ba:	01a50513          	addi	a0,a0,26 # 78d0 <malloc+0x1be0>
    38be:	00002097          	auipc	ra,0x2
    38c2:	372080e7          	jalr	882(ra) # 5c30 <printf>
    exit(1);
    38c6:	4505                	li	a0,1
    38c8:	00002097          	auipc	ra,0x2
    38cc:	fd8080e7          	jalr	-40(ra) # 58a0 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    38d0:	85ca                	mv	a1,s2
    38d2:	00004517          	auipc	a0,0x4
    38d6:	01e50513          	addi	a0,a0,30 # 78f0 <malloc+0x1c00>
    38da:	00002097          	auipc	ra,0x2
    38de:	356080e7          	jalr	854(ra) # 5c30 <printf>
    exit(1);
    38e2:	4505                	li	a0,1
    38e4:	00002097          	auipc	ra,0x2
    38e8:	fbc080e7          	jalr	-68(ra) # 58a0 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    38ec:	85ca                	mv	a1,s2
    38ee:	00004517          	auipc	a0,0x4
    38f2:	02250513          	addi	a0,a0,34 # 7910 <malloc+0x1c20>
    38f6:	00002097          	auipc	ra,0x2
    38fa:	33a080e7          	jalr	826(ra) # 5c30 <printf>
    exit(1);
    38fe:	4505                	li	a0,1
    3900:	00002097          	auipc	ra,0x2
    3904:	fa0080e7          	jalr	-96(ra) # 58a0 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3908:	85ca                	mv	a1,s2
    390a:	00004517          	auipc	a0,0x4
    390e:	02e50513          	addi	a0,a0,46 # 7938 <malloc+0x1c48>
    3912:	00002097          	auipc	ra,0x2
    3916:	31e080e7          	jalr	798(ra) # 5c30 <printf>
    exit(1);
    391a:	4505                	li	a0,1
    391c:	00002097          	auipc	ra,0x2
    3920:	f84080e7          	jalr	-124(ra) # 58a0 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3924:	85ca                	mv	a1,s2
    3926:	00004517          	auipc	a0,0x4
    392a:	03250513          	addi	a0,a0,50 # 7958 <malloc+0x1c68>
    392e:	00002097          	auipc	ra,0x2
    3932:	302080e7          	jalr	770(ra) # 5c30 <printf>
    exit(1);
    3936:	4505                	li	a0,1
    3938:	00002097          	auipc	ra,0x2
    393c:	f68080e7          	jalr	-152(ra) # 58a0 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3940:	85ca                	mv	a1,s2
    3942:	00004517          	auipc	a0,0x4
    3946:	03650513          	addi	a0,a0,54 # 7978 <malloc+0x1c88>
    394a:	00002097          	auipc	ra,0x2
    394e:	2e6080e7          	jalr	742(ra) # 5c30 <printf>
    exit(1);
    3952:	4505                	li	a0,1
    3954:	00002097          	auipc	ra,0x2
    3958:	f4c080e7          	jalr	-180(ra) # 58a0 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    395c:	85ca                	mv	a1,s2
    395e:	00004517          	auipc	a0,0x4
    3962:	04250513          	addi	a0,a0,66 # 79a0 <malloc+0x1cb0>
    3966:	00002097          	auipc	ra,0x2
    396a:	2ca080e7          	jalr	714(ra) # 5c30 <printf>
    exit(1);
    396e:	4505                	li	a0,1
    3970:	00002097          	auipc	ra,0x2
    3974:	f30080e7          	jalr	-208(ra) # 58a0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3978:	85ca                	mv	a1,s2
    397a:	00004517          	auipc	a0,0x4
    397e:	cbe50513          	addi	a0,a0,-834 # 7638 <malloc+0x1948>
    3982:	00002097          	auipc	ra,0x2
    3986:	2ae080e7          	jalr	686(ra) # 5c30 <printf>
    exit(1);
    398a:	4505                	li	a0,1
    398c:	00002097          	auipc	ra,0x2
    3990:	f14080e7          	jalr	-236(ra) # 58a0 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3994:	85ca                	mv	a1,s2
    3996:	00004517          	auipc	a0,0x4
    399a:	02a50513          	addi	a0,a0,42 # 79c0 <malloc+0x1cd0>
    399e:	00002097          	auipc	ra,0x2
    39a2:	292080e7          	jalr	658(ra) # 5c30 <printf>
    exit(1);
    39a6:	4505                	li	a0,1
    39a8:	00002097          	auipc	ra,0x2
    39ac:	ef8080e7          	jalr	-264(ra) # 58a0 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    39b0:	85ca                	mv	a1,s2
    39b2:	00004517          	auipc	a0,0x4
    39b6:	02e50513          	addi	a0,a0,46 # 79e0 <malloc+0x1cf0>
    39ba:	00002097          	auipc	ra,0x2
    39be:	276080e7          	jalr	630(ra) # 5c30 <printf>
    exit(1);
    39c2:	4505                	li	a0,1
    39c4:	00002097          	auipc	ra,0x2
    39c8:	edc080e7          	jalr	-292(ra) # 58a0 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    39cc:	85ca                	mv	a1,s2
    39ce:	00004517          	auipc	a0,0x4
    39d2:	04250513          	addi	a0,a0,66 # 7a10 <malloc+0x1d20>
    39d6:	00002097          	auipc	ra,0x2
    39da:	25a080e7          	jalr	602(ra) # 5c30 <printf>
    exit(1);
    39de:	4505                	li	a0,1
    39e0:	00002097          	auipc	ra,0x2
    39e4:	ec0080e7          	jalr	-320(ra) # 58a0 <exit>
    printf("%s: unlink dd failed\n", s);
    39e8:	85ca                	mv	a1,s2
    39ea:	00004517          	auipc	a0,0x4
    39ee:	04650513          	addi	a0,a0,70 # 7a30 <malloc+0x1d40>
    39f2:	00002097          	auipc	ra,0x2
    39f6:	23e080e7          	jalr	574(ra) # 5c30 <printf>
    exit(1);
    39fa:	4505                	li	a0,1
    39fc:	00002097          	auipc	ra,0x2
    3a00:	ea4080e7          	jalr	-348(ra) # 58a0 <exit>

0000000000003a04 <rmdot>:
{
    3a04:	1101                	addi	sp,sp,-32
    3a06:	ec06                	sd	ra,24(sp)
    3a08:	e822                	sd	s0,16(sp)
    3a0a:	e426                	sd	s1,8(sp)
    3a0c:	1000                	addi	s0,sp,32
    3a0e:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3a10:	00004517          	auipc	a0,0x4
    3a14:	03850513          	addi	a0,a0,56 # 7a48 <malloc+0x1d58>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	ef0080e7          	jalr	-272(ra) # 5908 <mkdir>
    3a20:	e549                	bnez	a0,3aaa <rmdot+0xa6>
  if(chdir("dots") != 0){
    3a22:	00004517          	auipc	a0,0x4
    3a26:	02650513          	addi	a0,a0,38 # 7a48 <malloc+0x1d58>
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	ee6080e7          	jalr	-282(ra) # 5910 <chdir>
    3a32:	e951                	bnez	a0,3ac6 <rmdot+0xc2>
  if(unlink(".") == 0){
    3a34:	00003517          	auipc	a0,0x3
    3a38:	ea450513          	addi	a0,a0,-348 # 68d8 <malloc+0xbe8>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	eb4080e7          	jalr	-332(ra) # 58f0 <unlink>
    3a44:	cd59                	beqz	a0,3ae2 <rmdot+0xde>
  if(unlink("..") == 0){
    3a46:	00004517          	auipc	a0,0x4
    3a4a:	a5a50513          	addi	a0,a0,-1446 # 74a0 <malloc+0x17b0>
    3a4e:	00002097          	auipc	ra,0x2
    3a52:	ea2080e7          	jalr	-350(ra) # 58f0 <unlink>
    3a56:	c545                	beqz	a0,3afe <rmdot+0xfa>
  if(chdir("/") != 0){
    3a58:	00004517          	auipc	a0,0x4
    3a5c:	9f050513          	addi	a0,a0,-1552 # 7448 <malloc+0x1758>
    3a60:	00002097          	auipc	ra,0x2
    3a64:	eb0080e7          	jalr	-336(ra) # 5910 <chdir>
    3a68:	e94d                	bnez	a0,3b1a <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3a6a:	00004517          	auipc	a0,0x4
    3a6e:	04650513          	addi	a0,a0,70 # 7ab0 <malloc+0x1dc0>
    3a72:	00002097          	auipc	ra,0x2
    3a76:	e7e080e7          	jalr	-386(ra) # 58f0 <unlink>
    3a7a:	cd55                	beqz	a0,3b36 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3a7c:	00004517          	auipc	a0,0x4
    3a80:	05c50513          	addi	a0,a0,92 # 7ad8 <malloc+0x1de8>
    3a84:	00002097          	auipc	ra,0x2
    3a88:	e6c080e7          	jalr	-404(ra) # 58f0 <unlink>
    3a8c:	c179                	beqz	a0,3b52 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	fba50513          	addi	a0,a0,-70 # 7a48 <malloc+0x1d58>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	e5a080e7          	jalr	-422(ra) # 58f0 <unlink>
    3a9e:	e961                	bnez	a0,3b6e <rmdot+0x16a>
}
    3aa0:	60e2                	ld	ra,24(sp)
    3aa2:	6442                	ld	s0,16(sp)
    3aa4:	64a2                	ld	s1,8(sp)
    3aa6:	6105                	addi	sp,sp,32
    3aa8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3aaa:	85a6                	mv	a1,s1
    3aac:	00004517          	auipc	a0,0x4
    3ab0:	fa450513          	addi	a0,a0,-92 # 7a50 <malloc+0x1d60>
    3ab4:	00002097          	auipc	ra,0x2
    3ab8:	17c080e7          	jalr	380(ra) # 5c30 <printf>
    exit(1);
    3abc:	4505                	li	a0,1
    3abe:	00002097          	auipc	ra,0x2
    3ac2:	de2080e7          	jalr	-542(ra) # 58a0 <exit>
    printf("%s: chdir dots failed\n", s);
    3ac6:	85a6                	mv	a1,s1
    3ac8:	00004517          	auipc	a0,0x4
    3acc:	fa050513          	addi	a0,a0,-96 # 7a68 <malloc+0x1d78>
    3ad0:	00002097          	auipc	ra,0x2
    3ad4:	160080e7          	jalr	352(ra) # 5c30 <printf>
    exit(1);
    3ad8:	4505                	li	a0,1
    3ada:	00002097          	auipc	ra,0x2
    3ade:	dc6080e7          	jalr	-570(ra) # 58a0 <exit>
    printf("%s: rm . worked!\n", s);
    3ae2:	85a6                	mv	a1,s1
    3ae4:	00004517          	auipc	a0,0x4
    3ae8:	f9c50513          	addi	a0,a0,-100 # 7a80 <malloc+0x1d90>
    3aec:	00002097          	auipc	ra,0x2
    3af0:	144080e7          	jalr	324(ra) # 5c30 <printf>
    exit(1);
    3af4:	4505                	li	a0,1
    3af6:	00002097          	auipc	ra,0x2
    3afa:	daa080e7          	jalr	-598(ra) # 58a0 <exit>
    printf("%s: rm .. worked!\n", s);
    3afe:	85a6                	mv	a1,s1
    3b00:	00004517          	auipc	a0,0x4
    3b04:	f9850513          	addi	a0,a0,-104 # 7a98 <malloc+0x1da8>
    3b08:	00002097          	auipc	ra,0x2
    3b0c:	128080e7          	jalr	296(ra) # 5c30 <printf>
    exit(1);
    3b10:	4505                	li	a0,1
    3b12:	00002097          	auipc	ra,0x2
    3b16:	d8e080e7          	jalr	-626(ra) # 58a0 <exit>
    printf("%s: chdir / failed\n", s);
    3b1a:	85a6                	mv	a1,s1
    3b1c:	00004517          	auipc	a0,0x4
    3b20:	93450513          	addi	a0,a0,-1740 # 7450 <malloc+0x1760>
    3b24:	00002097          	auipc	ra,0x2
    3b28:	10c080e7          	jalr	268(ra) # 5c30 <printf>
    exit(1);
    3b2c:	4505                	li	a0,1
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	d72080e7          	jalr	-654(ra) # 58a0 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3b36:	85a6                	mv	a1,s1
    3b38:	00004517          	auipc	a0,0x4
    3b3c:	f8050513          	addi	a0,a0,-128 # 7ab8 <malloc+0x1dc8>
    3b40:	00002097          	auipc	ra,0x2
    3b44:	0f0080e7          	jalr	240(ra) # 5c30 <printf>
    exit(1);
    3b48:	4505                	li	a0,1
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	d56080e7          	jalr	-682(ra) # 58a0 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3b52:	85a6                	mv	a1,s1
    3b54:	00004517          	auipc	a0,0x4
    3b58:	f8c50513          	addi	a0,a0,-116 # 7ae0 <malloc+0x1df0>
    3b5c:	00002097          	auipc	ra,0x2
    3b60:	0d4080e7          	jalr	212(ra) # 5c30 <printf>
    exit(1);
    3b64:	4505                	li	a0,1
    3b66:	00002097          	auipc	ra,0x2
    3b6a:	d3a080e7          	jalr	-710(ra) # 58a0 <exit>
    printf("%s: unlink dots failed!\n", s);
    3b6e:	85a6                	mv	a1,s1
    3b70:	00004517          	auipc	a0,0x4
    3b74:	f9050513          	addi	a0,a0,-112 # 7b00 <malloc+0x1e10>
    3b78:	00002097          	auipc	ra,0x2
    3b7c:	0b8080e7          	jalr	184(ra) # 5c30 <printf>
    exit(1);
    3b80:	4505                	li	a0,1
    3b82:	00002097          	auipc	ra,0x2
    3b86:	d1e080e7          	jalr	-738(ra) # 58a0 <exit>

0000000000003b8a <dirfile>:
{
    3b8a:	1101                	addi	sp,sp,-32
    3b8c:	ec06                	sd	ra,24(sp)
    3b8e:	e822                	sd	s0,16(sp)
    3b90:	e426                	sd	s1,8(sp)
    3b92:	e04a                	sd	s2,0(sp)
    3b94:	1000                	addi	s0,sp,32
    3b96:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3b98:	20000593          	li	a1,512
    3b9c:	00004517          	auipc	a0,0x4
    3ba0:	f8450513          	addi	a0,a0,-124 # 7b20 <malloc+0x1e30>
    3ba4:	00002097          	auipc	ra,0x2
    3ba8:	d3c080e7          	jalr	-708(ra) # 58e0 <open>
  if(fd < 0){
    3bac:	0e054d63          	bltz	a0,3ca6 <dirfile+0x11c>
  close(fd);
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	d18080e7          	jalr	-744(ra) # 58c8 <close>
  if(chdir("dirfile") == 0){
    3bb8:	00004517          	auipc	a0,0x4
    3bbc:	f6850513          	addi	a0,a0,-152 # 7b20 <malloc+0x1e30>
    3bc0:	00002097          	auipc	ra,0x2
    3bc4:	d50080e7          	jalr	-688(ra) # 5910 <chdir>
    3bc8:	cd6d                	beqz	a0,3cc2 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3bca:	4581                	li	a1,0
    3bcc:	00004517          	auipc	a0,0x4
    3bd0:	f9c50513          	addi	a0,a0,-100 # 7b68 <malloc+0x1e78>
    3bd4:	00002097          	auipc	ra,0x2
    3bd8:	d0c080e7          	jalr	-756(ra) # 58e0 <open>
  if(fd >= 0){
    3bdc:	10055163          	bgez	a0,3cde <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3be0:	20000593          	li	a1,512
    3be4:	00004517          	auipc	a0,0x4
    3be8:	f8450513          	addi	a0,a0,-124 # 7b68 <malloc+0x1e78>
    3bec:	00002097          	auipc	ra,0x2
    3bf0:	cf4080e7          	jalr	-780(ra) # 58e0 <open>
  if(fd >= 0){
    3bf4:	10055363          	bgez	a0,3cfa <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3bf8:	00004517          	auipc	a0,0x4
    3bfc:	f7050513          	addi	a0,a0,-144 # 7b68 <malloc+0x1e78>
    3c00:	00002097          	auipc	ra,0x2
    3c04:	d08080e7          	jalr	-760(ra) # 5908 <mkdir>
    3c08:	10050763          	beqz	a0,3d16 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3c0c:	00004517          	auipc	a0,0x4
    3c10:	f5c50513          	addi	a0,a0,-164 # 7b68 <malloc+0x1e78>
    3c14:	00002097          	auipc	ra,0x2
    3c18:	cdc080e7          	jalr	-804(ra) # 58f0 <unlink>
    3c1c:	10050b63          	beqz	a0,3d32 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3c20:	00004597          	auipc	a1,0x4
    3c24:	f4858593          	addi	a1,a1,-184 # 7b68 <malloc+0x1e78>
    3c28:	00002517          	auipc	a0,0x2
    3c2c:	7a050513          	addi	a0,a0,1952 # 63c8 <malloc+0x6d8>
    3c30:	00002097          	auipc	ra,0x2
    3c34:	cd0080e7          	jalr	-816(ra) # 5900 <link>
    3c38:	10050b63          	beqz	a0,3d4e <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3c3c:	00004517          	auipc	a0,0x4
    3c40:	ee450513          	addi	a0,a0,-284 # 7b20 <malloc+0x1e30>
    3c44:	00002097          	auipc	ra,0x2
    3c48:	cac080e7          	jalr	-852(ra) # 58f0 <unlink>
    3c4c:	10051f63          	bnez	a0,3d6a <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3c50:	4589                	li	a1,2
    3c52:	00003517          	auipc	a0,0x3
    3c56:	c8650513          	addi	a0,a0,-890 # 68d8 <malloc+0xbe8>
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	c86080e7          	jalr	-890(ra) # 58e0 <open>
  if(fd >= 0){
    3c62:	12055263          	bgez	a0,3d86 <dirfile+0x1fc>
  fd = open(".", 0);
    3c66:	4581                	li	a1,0
    3c68:	00003517          	auipc	a0,0x3
    3c6c:	c7050513          	addi	a0,a0,-912 # 68d8 <malloc+0xbe8>
    3c70:	00002097          	auipc	ra,0x2
    3c74:	c70080e7          	jalr	-912(ra) # 58e0 <open>
    3c78:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3c7a:	4605                	li	a2,1
    3c7c:	00002597          	auipc	a1,0x2
    3c80:	61458593          	addi	a1,a1,1556 # 6290 <malloc+0x5a0>
    3c84:	00002097          	auipc	ra,0x2
    3c88:	c3c080e7          	jalr	-964(ra) # 58c0 <write>
    3c8c:	10a04b63          	bgtz	a0,3da2 <dirfile+0x218>
  close(fd);
    3c90:	8526                	mv	a0,s1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	c36080e7          	jalr	-970(ra) # 58c8 <close>
}
    3c9a:	60e2                	ld	ra,24(sp)
    3c9c:	6442                	ld	s0,16(sp)
    3c9e:	64a2                	ld	s1,8(sp)
    3ca0:	6902                	ld	s2,0(sp)
    3ca2:	6105                	addi	sp,sp,32
    3ca4:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3ca6:	85ca                	mv	a1,s2
    3ca8:	00004517          	auipc	a0,0x4
    3cac:	e8050513          	addi	a0,a0,-384 # 7b28 <malloc+0x1e38>
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	f80080e7          	jalr	-128(ra) # 5c30 <printf>
    exit(1);
    3cb8:	4505                	li	a0,1
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	be6080e7          	jalr	-1050(ra) # 58a0 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3cc2:	85ca                	mv	a1,s2
    3cc4:	00004517          	auipc	a0,0x4
    3cc8:	e8450513          	addi	a0,a0,-380 # 7b48 <malloc+0x1e58>
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	f64080e7          	jalr	-156(ra) # 5c30 <printf>
    exit(1);
    3cd4:	4505                	li	a0,1
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	bca080e7          	jalr	-1078(ra) # 58a0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3cde:	85ca                	mv	a1,s2
    3ce0:	00004517          	auipc	a0,0x4
    3ce4:	e9850513          	addi	a0,a0,-360 # 7b78 <malloc+0x1e88>
    3ce8:	00002097          	auipc	ra,0x2
    3cec:	f48080e7          	jalr	-184(ra) # 5c30 <printf>
    exit(1);
    3cf0:	4505                	li	a0,1
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	bae080e7          	jalr	-1106(ra) # 58a0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3cfa:	85ca                	mv	a1,s2
    3cfc:	00004517          	auipc	a0,0x4
    3d00:	e7c50513          	addi	a0,a0,-388 # 7b78 <malloc+0x1e88>
    3d04:	00002097          	auipc	ra,0x2
    3d08:	f2c080e7          	jalr	-212(ra) # 5c30 <printf>
    exit(1);
    3d0c:	4505                	li	a0,1
    3d0e:	00002097          	auipc	ra,0x2
    3d12:	b92080e7          	jalr	-1134(ra) # 58a0 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3d16:	85ca                	mv	a1,s2
    3d18:	00004517          	auipc	a0,0x4
    3d1c:	e8850513          	addi	a0,a0,-376 # 7ba0 <malloc+0x1eb0>
    3d20:	00002097          	auipc	ra,0x2
    3d24:	f10080e7          	jalr	-240(ra) # 5c30 <printf>
    exit(1);
    3d28:	4505                	li	a0,1
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	b76080e7          	jalr	-1162(ra) # 58a0 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3d32:	85ca                	mv	a1,s2
    3d34:	00004517          	auipc	a0,0x4
    3d38:	e9450513          	addi	a0,a0,-364 # 7bc8 <malloc+0x1ed8>
    3d3c:	00002097          	auipc	ra,0x2
    3d40:	ef4080e7          	jalr	-268(ra) # 5c30 <printf>
    exit(1);
    3d44:	4505                	li	a0,1
    3d46:	00002097          	auipc	ra,0x2
    3d4a:	b5a080e7          	jalr	-1190(ra) # 58a0 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3d4e:	85ca                	mv	a1,s2
    3d50:	00004517          	auipc	a0,0x4
    3d54:	ea050513          	addi	a0,a0,-352 # 7bf0 <malloc+0x1f00>
    3d58:	00002097          	auipc	ra,0x2
    3d5c:	ed8080e7          	jalr	-296(ra) # 5c30 <printf>
    exit(1);
    3d60:	4505                	li	a0,1
    3d62:	00002097          	auipc	ra,0x2
    3d66:	b3e080e7          	jalr	-1218(ra) # 58a0 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3d6a:	85ca                	mv	a1,s2
    3d6c:	00004517          	auipc	a0,0x4
    3d70:	eac50513          	addi	a0,a0,-340 # 7c18 <malloc+0x1f28>
    3d74:	00002097          	auipc	ra,0x2
    3d78:	ebc080e7          	jalr	-324(ra) # 5c30 <printf>
    exit(1);
    3d7c:	4505                	li	a0,1
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	b22080e7          	jalr	-1246(ra) # 58a0 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3d86:	85ca                	mv	a1,s2
    3d88:	00004517          	auipc	a0,0x4
    3d8c:	eb050513          	addi	a0,a0,-336 # 7c38 <malloc+0x1f48>
    3d90:	00002097          	auipc	ra,0x2
    3d94:	ea0080e7          	jalr	-352(ra) # 5c30 <printf>
    exit(1);
    3d98:	4505                	li	a0,1
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	b06080e7          	jalr	-1274(ra) # 58a0 <exit>
    printf("%s: write . succeeded!\n", s);
    3da2:	85ca                	mv	a1,s2
    3da4:	00004517          	auipc	a0,0x4
    3da8:	ebc50513          	addi	a0,a0,-324 # 7c60 <malloc+0x1f70>
    3dac:	00002097          	auipc	ra,0x2
    3db0:	e84080e7          	jalr	-380(ra) # 5c30 <printf>
    exit(1);
    3db4:	4505                	li	a0,1
    3db6:	00002097          	auipc	ra,0x2
    3dba:	aea080e7          	jalr	-1302(ra) # 58a0 <exit>

0000000000003dbe <iref>:
{
    3dbe:	7139                	addi	sp,sp,-64
    3dc0:	fc06                	sd	ra,56(sp)
    3dc2:	f822                	sd	s0,48(sp)
    3dc4:	f426                	sd	s1,40(sp)
    3dc6:	f04a                	sd	s2,32(sp)
    3dc8:	ec4e                	sd	s3,24(sp)
    3dca:	e852                	sd	s4,16(sp)
    3dcc:	e456                	sd	s5,8(sp)
    3dce:	e05a                	sd	s6,0(sp)
    3dd0:	0080                	addi	s0,sp,64
    3dd2:	8b2a                	mv	s6,a0
    3dd4:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3dd8:	00004a17          	auipc	s4,0x4
    3ddc:	ea0a0a13          	addi	s4,s4,-352 # 7c78 <malloc+0x1f88>
    mkdir("");
    3de0:	00004497          	auipc	s1,0x4
    3de4:	9a048493          	addi	s1,s1,-1632 # 7780 <malloc+0x1a90>
    link("README", "");
    3de8:	00002a97          	auipc	s5,0x2
    3dec:	5e0a8a93          	addi	s5,s5,1504 # 63c8 <malloc+0x6d8>
    fd = open("xx", O_CREATE);
    3df0:	00004997          	auipc	s3,0x4
    3df4:	d8098993          	addi	s3,s3,-640 # 7b70 <malloc+0x1e80>
    3df8:	a891                	j	3e4c <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3dfa:	85da                	mv	a1,s6
    3dfc:	00004517          	auipc	a0,0x4
    3e00:	e8450513          	addi	a0,a0,-380 # 7c80 <malloc+0x1f90>
    3e04:	00002097          	auipc	ra,0x2
    3e08:	e2c080e7          	jalr	-468(ra) # 5c30 <printf>
      exit(1);
    3e0c:	4505                	li	a0,1
    3e0e:	00002097          	auipc	ra,0x2
    3e12:	a92080e7          	jalr	-1390(ra) # 58a0 <exit>
      printf("%s: chdir irefd failed\n", s);
    3e16:	85da                	mv	a1,s6
    3e18:	00004517          	auipc	a0,0x4
    3e1c:	e8050513          	addi	a0,a0,-384 # 7c98 <malloc+0x1fa8>
    3e20:	00002097          	auipc	ra,0x2
    3e24:	e10080e7          	jalr	-496(ra) # 5c30 <printf>
      exit(1);
    3e28:	4505                	li	a0,1
    3e2a:	00002097          	auipc	ra,0x2
    3e2e:	a76080e7          	jalr	-1418(ra) # 58a0 <exit>
      close(fd);
    3e32:	00002097          	auipc	ra,0x2
    3e36:	a96080e7          	jalr	-1386(ra) # 58c8 <close>
    3e3a:	a889                	j	3e8c <iref+0xce>
    unlink("xx");
    3e3c:	854e                	mv	a0,s3
    3e3e:	00002097          	auipc	ra,0x2
    3e42:	ab2080e7          	jalr	-1358(ra) # 58f0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e46:	397d                	addiw	s2,s2,-1
    3e48:	06090063          	beqz	s2,3ea8 <iref+0xea>
    if(mkdir("irefd") != 0){
    3e4c:	8552                	mv	a0,s4
    3e4e:	00002097          	auipc	ra,0x2
    3e52:	aba080e7          	jalr	-1350(ra) # 5908 <mkdir>
    3e56:	f155                	bnez	a0,3dfa <iref+0x3c>
    if(chdir("irefd") != 0){
    3e58:	8552                	mv	a0,s4
    3e5a:	00002097          	auipc	ra,0x2
    3e5e:	ab6080e7          	jalr	-1354(ra) # 5910 <chdir>
    3e62:	f955                	bnez	a0,3e16 <iref+0x58>
    mkdir("");
    3e64:	8526                	mv	a0,s1
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	aa2080e7          	jalr	-1374(ra) # 5908 <mkdir>
    link("README", "");
    3e6e:	85a6                	mv	a1,s1
    3e70:	8556                	mv	a0,s5
    3e72:	00002097          	auipc	ra,0x2
    3e76:	a8e080e7          	jalr	-1394(ra) # 5900 <link>
    fd = open("", O_CREATE);
    3e7a:	20000593          	li	a1,512
    3e7e:	8526                	mv	a0,s1
    3e80:	00002097          	auipc	ra,0x2
    3e84:	a60080e7          	jalr	-1440(ra) # 58e0 <open>
    if(fd >= 0)
    3e88:	fa0555e3          	bgez	a0,3e32 <iref+0x74>
    fd = open("xx", O_CREATE);
    3e8c:	20000593          	li	a1,512
    3e90:	854e                	mv	a0,s3
    3e92:	00002097          	auipc	ra,0x2
    3e96:	a4e080e7          	jalr	-1458(ra) # 58e0 <open>
    if(fd >= 0)
    3e9a:	fa0541e3          	bltz	a0,3e3c <iref+0x7e>
      close(fd);
    3e9e:	00002097          	auipc	ra,0x2
    3ea2:	a2a080e7          	jalr	-1494(ra) # 58c8 <close>
    3ea6:	bf59                	j	3e3c <iref+0x7e>
    3ea8:	03300493          	li	s1,51
    chdir("..");
    3eac:	00003997          	auipc	s3,0x3
    3eb0:	5f498993          	addi	s3,s3,1524 # 74a0 <malloc+0x17b0>
    unlink("irefd");
    3eb4:	00004917          	auipc	s2,0x4
    3eb8:	dc490913          	addi	s2,s2,-572 # 7c78 <malloc+0x1f88>
    chdir("..");
    3ebc:	854e                	mv	a0,s3
    3ebe:	00002097          	auipc	ra,0x2
    3ec2:	a52080e7          	jalr	-1454(ra) # 5910 <chdir>
    unlink("irefd");
    3ec6:	854a                	mv	a0,s2
    3ec8:	00002097          	auipc	ra,0x2
    3ecc:	a28080e7          	jalr	-1496(ra) # 58f0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ed0:	34fd                	addiw	s1,s1,-1
    3ed2:	f4ed                	bnez	s1,3ebc <iref+0xfe>
  chdir("/");
    3ed4:	00003517          	auipc	a0,0x3
    3ed8:	57450513          	addi	a0,a0,1396 # 7448 <malloc+0x1758>
    3edc:	00002097          	auipc	ra,0x2
    3ee0:	a34080e7          	jalr	-1484(ra) # 5910 <chdir>
}
    3ee4:	70e2                	ld	ra,56(sp)
    3ee6:	7442                	ld	s0,48(sp)
    3ee8:	74a2                	ld	s1,40(sp)
    3eea:	7902                	ld	s2,32(sp)
    3eec:	69e2                	ld	s3,24(sp)
    3eee:	6a42                	ld	s4,16(sp)
    3ef0:	6aa2                	ld	s5,8(sp)
    3ef2:	6b02                	ld	s6,0(sp)
    3ef4:	6121                	addi	sp,sp,64
    3ef6:	8082                	ret

0000000000003ef8 <openiputtest>:
{
    3ef8:	7179                	addi	sp,sp,-48
    3efa:	f406                	sd	ra,40(sp)
    3efc:	f022                	sd	s0,32(sp)
    3efe:	ec26                	sd	s1,24(sp)
    3f00:	1800                	addi	s0,sp,48
    3f02:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3f04:	00004517          	auipc	a0,0x4
    3f08:	dac50513          	addi	a0,a0,-596 # 7cb0 <malloc+0x1fc0>
    3f0c:	00002097          	auipc	ra,0x2
    3f10:	9fc080e7          	jalr	-1540(ra) # 5908 <mkdir>
    3f14:	04054263          	bltz	a0,3f58 <openiputtest+0x60>
  pid = fork();
    3f18:	00002097          	auipc	ra,0x2
    3f1c:	980080e7          	jalr	-1664(ra) # 5898 <fork>
  if(pid < 0){
    3f20:	04054a63          	bltz	a0,3f74 <openiputtest+0x7c>
  if(pid == 0){
    3f24:	e93d                	bnez	a0,3f9a <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3f26:	4589                	li	a1,2
    3f28:	00004517          	auipc	a0,0x4
    3f2c:	d8850513          	addi	a0,a0,-632 # 7cb0 <malloc+0x1fc0>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	9b0080e7          	jalr	-1616(ra) # 58e0 <open>
    if(fd >= 0){
    3f38:	04054c63          	bltz	a0,3f90 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3f3c:	85a6                	mv	a1,s1
    3f3e:	00004517          	auipc	a0,0x4
    3f42:	d9250513          	addi	a0,a0,-622 # 7cd0 <malloc+0x1fe0>
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	cea080e7          	jalr	-790(ra) # 5c30 <printf>
      exit(1);
    3f4e:	4505                	li	a0,1
    3f50:	00002097          	auipc	ra,0x2
    3f54:	950080e7          	jalr	-1712(ra) # 58a0 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3f58:	85a6                	mv	a1,s1
    3f5a:	00004517          	auipc	a0,0x4
    3f5e:	d5e50513          	addi	a0,a0,-674 # 7cb8 <malloc+0x1fc8>
    3f62:	00002097          	auipc	ra,0x2
    3f66:	cce080e7          	jalr	-818(ra) # 5c30 <printf>
    exit(1);
    3f6a:	4505                	li	a0,1
    3f6c:	00002097          	auipc	ra,0x2
    3f70:	934080e7          	jalr	-1740(ra) # 58a0 <exit>
    printf("%s: fork failed\n", s);
    3f74:	85a6                	mv	a1,s1
    3f76:	00003517          	auipc	a0,0x3
    3f7a:	b0250513          	addi	a0,a0,-1278 # 6a78 <malloc+0xd88>
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	cb2080e7          	jalr	-846(ra) # 5c30 <printf>
    exit(1);
    3f86:	4505                	li	a0,1
    3f88:	00002097          	auipc	ra,0x2
    3f8c:	918080e7          	jalr	-1768(ra) # 58a0 <exit>
    exit(0);
    3f90:	4501                	li	a0,0
    3f92:	00002097          	auipc	ra,0x2
    3f96:	90e080e7          	jalr	-1778(ra) # 58a0 <exit>
  sleep(1);
    3f9a:	4505                	li	a0,1
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	994080e7          	jalr	-1644(ra) # 5930 <sleep>
  if(unlink("oidir") != 0){
    3fa4:	00004517          	auipc	a0,0x4
    3fa8:	d0c50513          	addi	a0,a0,-756 # 7cb0 <malloc+0x1fc0>
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	944080e7          	jalr	-1724(ra) # 58f0 <unlink>
    3fb4:	cd19                	beqz	a0,3fd2 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3fb6:	85a6                	mv	a1,s1
    3fb8:	00003517          	auipc	a0,0x3
    3fbc:	cb050513          	addi	a0,a0,-848 # 6c68 <malloc+0xf78>
    3fc0:	00002097          	auipc	ra,0x2
    3fc4:	c70080e7          	jalr	-912(ra) # 5c30 <printf>
    exit(1);
    3fc8:	4505                	li	a0,1
    3fca:	00002097          	auipc	ra,0x2
    3fce:	8d6080e7          	jalr	-1834(ra) # 58a0 <exit>
  wait(&xstatus);
    3fd2:	fdc40513          	addi	a0,s0,-36
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	8d2080e7          	jalr	-1838(ra) # 58a8 <wait>
  exit(xstatus);
    3fde:	fdc42503          	lw	a0,-36(s0)
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	8be080e7          	jalr	-1858(ra) # 58a0 <exit>

0000000000003fea <forkforkfork>:
{
    3fea:	1101                	addi	sp,sp,-32
    3fec:	ec06                	sd	ra,24(sp)
    3fee:	e822                	sd	s0,16(sp)
    3ff0:	e426                	sd	s1,8(sp)
    3ff2:	1000                	addi	s0,sp,32
    3ff4:	84aa                	mv	s1,a0
  unlink("stopforking");
    3ff6:	00004517          	auipc	a0,0x4
    3ffa:	d0250513          	addi	a0,a0,-766 # 7cf8 <malloc+0x2008>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	8f2080e7          	jalr	-1806(ra) # 58f0 <unlink>
  int pid = fork();
    4006:	00002097          	auipc	ra,0x2
    400a:	892080e7          	jalr	-1902(ra) # 5898 <fork>
  if(pid < 0){
    400e:	04054563          	bltz	a0,4058 <forkforkfork+0x6e>
  if(pid == 0){
    4012:	c12d                	beqz	a0,4074 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4014:	4551                	li	a0,20
    4016:	00002097          	auipc	ra,0x2
    401a:	91a080e7          	jalr	-1766(ra) # 5930 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    401e:	20200593          	li	a1,514
    4022:	00004517          	auipc	a0,0x4
    4026:	cd650513          	addi	a0,a0,-810 # 7cf8 <malloc+0x2008>
    402a:	00002097          	auipc	ra,0x2
    402e:	8b6080e7          	jalr	-1866(ra) # 58e0 <open>
    4032:	00002097          	auipc	ra,0x2
    4036:	896080e7          	jalr	-1898(ra) # 58c8 <close>
  wait(0);
    403a:	4501                	li	a0,0
    403c:	00002097          	auipc	ra,0x2
    4040:	86c080e7          	jalr	-1940(ra) # 58a8 <wait>
  sleep(10); // one second
    4044:	4529                	li	a0,10
    4046:	00002097          	auipc	ra,0x2
    404a:	8ea080e7          	jalr	-1814(ra) # 5930 <sleep>
}
    404e:	60e2                	ld	ra,24(sp)
    4050:	6442                	ld	s0,16(sp)
    4052:	64a2                	ld	s1,8(sp)
    4054:	6105                	addi	sp,sp,32
    4056:	8082                	ret
    printf("%s: fork failed", s);
    4058:	85a6                	mv	a1,s1
    405a:	00003517          	auipc	a0,0x3
    405e:	bde50513          	addi	a0,a0,-1058 # 6c38 <malloc+0xf48>
    4062:	00002097          	auipc	ra,0x2
    4066:	bce080e7          	jalr	-1074(ra) # 5c30 <printf>
    exit(1);
    406a:	4505                	li	a0,1
    406c:	00002097          	auipc	ra,0x2
    4070:	834080e7          	jalr	-1996(ra) # 58a0 <exit>
      int fd = open("stopforking", 0);
    4074:	00004497          	auipc	s1,0x4
    4078:	c8448493          	addi	s1,s1,-892 # 7cf8 <malloc+0x2008>
    407c:	4581                	li	a1,0
    407e:	8526                	mv	a0,s1
    4080:	00002097          	auipc	ra,0x2
    4084:	860080e7          	jalr	-1952(ra) # 58e0 <open>
      if(fd >= 0){
    4088:	02055463          	bgez	a0,40b0 <forkforkfork+0xc6>
      if(fork() < 0){
    408c:	00002097          	auipc	ra,0x2
    4090:	80c080e7          	jalr	-2036(ra) # 5898 <fork>
    4094:	fe0554e3          	bgez	a0,407c <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4098:	20200593          	li	a1,514
    409c:	8526                	mv	a0,s1
    409e:	00002097          	auipc	ra,0x2
    40a2:	842080e7          	jalr	-1982(ra) # 58e0 <open>
    40a6:	00002097          	auipc	ra,0x2
    40aa:	822080e7          	jalr	-2014(ra) # 58c8 <close>
    40ae:	b7f9                	j	407c <forkforkfork+0x92>
        exit(0);
    40b0:	4501                	li	a0,0
    40b2:	00001097          	auipc	ra,0x1
    40b6:	7ee080e7          	jalr	2030(ra) # 58a0 <exit>

00000000000040ba <killstatus>:
{
    40ba:	7139                	addi	sp,sp,-64
    40bc:	fc06                	sd	ra,56(sp)
    40be:	f822                	sd	s0,48(sp)
    40c0:	f426                	sd	s1,40(sp)
    40c2:	f04a                	sd	s2,32(sp)
    40c4:	ec4e                	sd	s3,24(sp)
    40c6:	e852                	sd	s4,16(sp)
    40c8:	0080                	addi	s0,sp,64
    40ca:	8a2a                	mv	s4,a0
    40cc:	06400913          	li	s2,100
    if(xst != -1) {
    40d0:	59fd                	li	s3,-1
    int pid1 = fork();
    40d2:	00001097          	auipc	ra,0x1
    40d6:	7c6080e7          	jalr	1990(ra) # 5898 <fork>
    40da:	84aa                	mv	s1,a0
    if(pid1 < 0){
    40dc:	02054f63          	bltz	a0,411a <killstatus+0x60>
    if(pid1 == 0){
    40e0:	c939                	beqz	a0,4136 <killstatus+0x7c>
    sleep(1);
    40e2:	4505                	li	a0,1
    40e4:	00002097          	auipc	ra,0x2
    40e8:	84c080e7          	jalr	-1972(ra) # 5930 <sleep>
    kill(pid1);
    40ec:	8526                	mv	a0,s1
    40ee:	00001097          	auipc	ra,0x1
    40f2:	7e2080e7          	jalr	2018(ra) # 58d0 <kill>
    wait(&xst);
    40f6:	fcc40513          	addi	a0,s0,-52
    40fa:	00001097          	auipc	ra,0x1
    40fe:	7ae080e7          	jalr	1966(ra) # 58a8 <wait>
    if(xst != -1) {
    4102:	fcc42783          	lw	a5,-52(s0)
    4106:	03379d63          	bne	a5,s3,4140 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    410a:	397d                	addiw	s2,s2,-1
    410c:	fc0913e3          	bnez	s2,40d2 <killstatus+0x18>
  exit(0);
    4110:	4501                	li	a0,0
    4112:	00001097          	auipc	ra,0x1
    4116:	78e080e7          	jalr	1934(ra) # 58a0 <exit>
      printf("%s: fork failed\n", s);
    411a:	85d2                	mv	a1,s4
    411c:	00003517          	auipc	a0,0x3
    4120:	95c50513          	addi	a0,a0,-1700 # 6a78 <malloc+0xd88>
    4124:	00002097          	auipc	ra,0x2
    4128:	b0c080e7          	jalr	-1268(ra) # 5c30 <printf>
      exit(1);
    412c:	4505                	li	a0,1
    412e:	00001097          	auipc	ra,0x1
    4132:	772080e7          	jalr	1906(ra) # 58a0 <exit>
        getpid();
    4136:	00001097          	auipc	ra,0x1
    413a:	7ea080e7          	jalr	2026(ra) # 5920 <getpid>
      while(1) {
    413e:	bfe5                	j	4136 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4140:	85d2                	mv	a1,s4
    4142:	00004517          	auipc	a0,0x4
    4146:	bc650513          	addi	a0,a0,-1082 # 7d08 <malloc+0x2018>
    414a:	00002097          	auipc	ra,0x2
    414e:	ae6080e7          	jalr	-1306(ra) # 5c30 <printf>
       exit(1);
    4152:	4505                	li	a0,1
    4154:	00001097          	auipc	ra,0x1
    4158:	74c080e7          	jalr	1868(ra) # 58a0 <exit>

000000000000415c <preempt>:
{
    415c:	7139                	addi	sp,sp,-64
    415e:	fc06                	sd	ra,56(sp)
    4160:	f822                	sd	s0,48(sp)
    4162:	f426                	sd	s1,40(sp)
    4164:	f04a                	sd	s2,32(sp)
    4166:	ec4e                	sd	s3,24(sp)
    4168:	e852                	sd	s4,16(sp)
    416a:	0080                	addi	s0,sp,64
    416c:	8a2a                	mv	s4,a0
  pid1 = fork();
    416e:	00001097          	auipc	ra,0x1
    4172:	72a080e7          	jalr	1834(ra) # 5898 <fork>
  if(pid1 < 0) {
    4176:	00054563          	bltz	a0,4180 <preempt+0x24>
    417a:	89aa                	mv	s3,a0
  if(pid1 == 0)
    417c:	e105                	bnez	a0,419c <preempt+0x40>
    for(;;)
    417e:	a001                	j	417e <preempt+0x22>
    printf("%s: fork failed", s);
    4180:	85d2                	mv	a1,s4
    4182:	00003517          	auipc	a0,0x3
    4186:	ab650513          	addi	a0,a0,-1354 # 6c38 <malloc+0xf48>
    418a:	00002097          	auipc	ra,0x2
    418e:	aa6080e7          	jalr	-1370(ra) # 5c30 <printf>
    exit(1);
    4192:	4505                	li	a0,1
    4194:	00001097          	auipc	ra,0x1
    4198:	70c080e7          	jalr	1804(ra) # 58a0 <exit>
  pid2 = fork();
    419c:	00001097          	auipc	ra,0x1
    41a0:	6fc080e7          	jalr	1788(ra) # 5898 <fork>
    41a4:	892a                	mv	s2,a0
  if(pid2 < 0) {
    41a6:	00054463          	bltz	a0,41ae <preempt+0x52>
  if(pid2 == 0)
    41aa:	e105                	bnez	a0,41ca <preempt+0x6e>
    for(;;)
    41ac:	a001                	j	41ac <preempt+0x50>
    printf("%s: fork failed\n", s);
    41ae:	85d2                	mv	a1,s4
    41b0:	00003517          	auipc	a0,0x3
    41b4:	8c850513          	addi	a0,a0,-1848 # 6a78 <malloc+0xd88>
    41b8:	00002097          	auipc	ra,0x2
    41bc:	a78080e7          	jalr	-1416(ra) # 5c30 <printf>
    exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00001097          	auipc	ra,0x1
    41c6:	6de080e7          	jalr	1758(ra) # 58a0 <exit>
  pipe(pfds);
    41ca:	fc840513          	addi	a0,s0,-56
    41ce:	00001097          	auipc	ra,0x1
    41d2:	6e2080e7          	jalr	1762(ra) # 58b0 <pipe>
  pid3 = fork();
    41d6:	00001097          	auipc	ra,0x1
    41da:	6c2080e7          	jalr	1730(ra) # 5898 <fork>
    41de:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    41e0:	02054e63          	bltz	a0,421c <preempt+0xc0>
  if(pid3 == 0){
    41e4:	e525                	bnez	a0,424c <preempt+0xf0>
    close(pfds[0]);
    41e6:	fc842503          	lw	a0,-56(s0)
    41ea:	00001097          	auipc	ra,0x1
    41ee:	6de080e7          	jalr	1758(ra) # 58c8 <close>
    if(write(pfds[1], "x", 1) != 1)
    41f2:	4605                	li	a2,1
    41f4:	00002597          	auipc	a1,0x2
    41f8:	09c58593          	addi	a1,a1,156 # 6290 <malloc+0x5a0>
    41fc:	fcc42503          	lw	a0,-52(s0)
    4200:	00001097          	auipc	ra,0x1
    4204:	6c0080e7          	jalr	1728(ra) # 58c0 <write>
    4208:	4785                	li	a5,1
    420a:	02f51763          	bne	a0,a5,4238 <preempt+0xdc>
    close(pfds[1]);
    420e:	fcc42503          	lw	a0,-52(s0)
    4212:	00001097          	auipc	ra,0x1
    4216:	6b6080e7          	jalr	1718(ra) # 58c8 <close>
    for(;;)
    421a:	a001                	j	421a <preempt+0xbe>
     printf("%s: fork failed\n", s);
    421c:	85d2                	mv	a1,s4
    421e:	00003517          	auipc	a0,0x3
    4222:	85a50513          	addi	a0,a0,-1958 # 6a78 <malloc+0xd88>
    4226:	00002097          	auipc	ra,0x2
    422a:	a0a080e7          	jalr	-1526(ra) # 5c30 <printf>
     exit(1);
    422e:	4505                	li	a0,1
    4230:	00001097          	auipc	ra,0x1
    4234:	670080e7          	jalr	1648(ra) # 58a0 <exit>
      printf("%s: preempt write error", s);
    4238:	85d2                	mv	a1,s4
    423a:	00004517          	auipc	a0,0x4
    423e:	aee50513          	addi	a0,a0,-1298 # 7d28 <malloc+0x2038>
    4242:	00002097          	auipc	ra,0x2
    4246:	9ee080e7          	jalr	-1554(ra) # 5c30 <printf>
    424a:	b7d1                	j	420e <preempt+0xb2>
  close(pfds[1]);
    424c:	fcc42503          	lw	a0,-52(s0)
    4250:	00001097          	auipc	ra,0x1
    4254:	678080e7          	jalr	1656(ra) # 58c8 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4258:	660d                	lui	a2,0x3
    425a:	00008597          	auipc	a1,0x8
    425e:	b9e58593          	addi	a1,a1,-1122 # bdf8 <buf>
    4262:	fc842503          	lw	a0,-56(s0)
    4266:	00001097          	auipc	ra,0x1
    426a:	652080e7          	jalr	1618(ra) # 58b8 <read>
    426e:	4785                	li	a5,1
    4270:	02f50363          	beq	a0,a5,4296 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4274:	85d2                	mv	a1,s4
    4276:	00004517          	auipc	a0,0x4
    427a:	aca50513          	addi	a0,a0,-1334 # 7d40 <malloc+0x2050>
    427e:	00002097          	auipc	ra,0x2
    4282:	9b2080e7          	jalr	-1614(ra) # 5c30 <printf>
}
    4286:	70e2                	ld	ra,56(sp)
    4288:	7442                	ld	s0,48(sp)
    428a:	74a2                	ld	s1,40(sp)
    428c:	7902                	ld	s2,32(sp)
    428e:	69e2                	ld	s3,24(sp)
    4290:	6a42                	ld	s4,16(sp)
    4292:	6121                	addi	sp,sp,64
    4294:	8082                	ret
  close(pfds[0]);
    4296:	fc842503          	lw	a0,-56(s0)
    429a:	00001097          	auipc	ra,0x1
    429e:	62e080e7          	jalr	1582(ra) # 58c8 <close>
  printf("kill... ");
    42a2:	00004517          	auipc	a0,0x4
    42a6:	ab650513          	addi	a0,a0,-1354 # 7d58 <malloc+0x2068>
    42aa:	00002097          	auipc	ra,0x2
    42ae:	986080e7          	jalr	-1658(ra) # 5c30 <printf>
  kill(pid1);
    42b2:	854e                	mv	a0,s3
    42b4:	00001097          	auipc	ra,0x1
    42b8:	61c080e7          	jalr	1564(ra) # 58d0 <kill>
  kill(pid2);
    42bc:	854a                	mv	a0,s2
    42be:	00001097          	auipc	ra,0x1
    42c2:	612080e7          	jalr	1554(ra) # 58d0 <kill>
  kill(pid3);
    42c6:	8526                	mv	a0,s1
    42c8:	00001097          	auipc	ra,0x1
    42cc:	608080e7          	jalr	1544(ra) # 58d0 <kill>
  printf("wait... ");
    42d0:	00004517          	auipc	a0,0x4
    42d4:	a9850513          	addi	a0,a0,-1384 # 7d68 <malloc+0x2078>
    42d8:	00002097          	auipc	ra,0x2
    42dc:	958080e7          	jalr	-1704(ra) # 5c30 <printf>
  wait(0);
    42e0:	4501                	li	a0,0
    42e2:	00001097          	auipc	ra,0x1
    42e6:	5c6080e7          	jalr	1478(ra) # 58a8 <wait>
  wait(0);
    42ea:	4501                	li	a0,0
    42ec:	00001097          	auipc	ra,0x1
    42f0:	5bc080e7          	jalr	1468(ra) # 58a8 <wait>
  wait(0);
    42f4:	4501                	li	a0,0
    42f6:	00001097          	auipc	ra,0x1
    42fa:	5b2080e7          	jalr	1458(ra) # 58a8 <wait>
    42fe:	b761                	j	4286 <preempt+0x12a>

0000000000004300 <reparent>:
{
    4300:	7179                	addi	sp,sp,-48
    4302:	f406                	sd	ra,40(sp)
    4304:	f022                	sd	s0,32(sp)
    4306:	ec26                	sd	s1,24(sp)
    4308:	e84a                	sd	s2,16(sp)
    430a:	e44e                	sd	s3,8(sp)
    430c:	e052                	sd	s4,0(sp)
    430e:	1800                	addi	s0,sp,48
    4310:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4312:	00001097          	auipc	ra,0x1
    4316:	60e080e7          	jalr	1550(ra) # 5920 <getpid>
    431a:	8a2a                	mv	s4,a0
    431c:	0c800913          	li	s2,200
    int pid = fork();
    4320:	00001097          	auipc	ra,0x1
    4324:	578080e7          	jalr	1400(ra) # 5898 <fork>
    4328:	84aa                	mv	s1,a0
    if(pid < 0){
    432a:	02054263          	bltz	a0,434e <reparent+0x4e>
    if(pid){
    432e:	cd21                	beqz	a0,4386 <reparent+0x86>
      if(wait(0) != pid){
    4330:	4501                	li	a0,0
    4332:	00001097          	auipc	ra,0x1
    4336:	576080e7          	jalr	1398(ra) # 58a8 <wait>
    433a:	02951863          	bne	a0,s1,436a <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    433e:	397d                	addiw	s2,s2,-1
    4340:	fe0910e3          	bnez	s2,4320 <reparent+0x20>
  exit(0);
    4344:	4501                	li	a0,0
    4346:	00001097          	auipc	ra,0x1
    434a:	55a080e7          	jalr	1370(ra) # 58a0 <exit>
      printf("%s: fork failed\n", s);
    434e:	85ce                	mv	a1,s3
    4350:	00002517          	auipc	a0,0x2
    4354:	72850513          	addi	a0,a0,1832 # 6a78 <malloc+0xd88>
    4358:	00002097          	auipc	ra,0x2
    435c:	8d8080e7          	jalr	-1832(ra) # 5c30 <printf>
      exit(1);
    4360:	4505                	li	a0,1
    4362:	00001097          	auipc	ra,0x1
    4366:	53e080e7          	jalr	1342(ra) # 58a0 <exit>
        printf("%s: wait wrong pid\n", s);
    436a:	85ce                	mv	a1,s3
    436c:	00003517          	auipc	a0,0x3
    4370:	89450513          	addi	a0,a0,-1900 # 6c00 <malloc+0xf10>
    4374:	00002097          	auipc	ra,0x2
    4378:	8bc080e7          	jalr	-1860(ra) # 5c30 <printf>
        exit(1);
    437c:	4505                	li	a0,1
    437e:	00001097          	auipc	ra,0x1
    4382:	522080e7          	jalr	1314(ra) # 58a0 <exit>
      int pid2 = fork();
    4386:	00001097          	auipc	ra,0x1
    438a:	512080e7          	jalr	1298(ra) # 5898 <fork>
      if(pid2 < 0){
    438e:	00054763          	bltz	a0,439c <reparent+0x9c>
      exit(0);
    4392:	4501                	li	a0,0
    4394:	00001097          	auipc	ra,0x1
    4398:	50c080e7          	jalr	1292(ra) # 58a0 <exit>
        kill(master_pid);
    439c:	8552                	mv	a0,s4
    439e:	00001097          	auipc	ra,0x1
    43a2:	532080e7          	jalr	1330(ra) # 58d0 <kill>
        exit(1);
    43a6:	4505                	li	a0,1
    43a8:	00001097          	auipc	ra,0x1
    43ac:	4f8080e7          	jalr	1272(ra) # 58a0 <exit>

00000000000043b0 <sbrkfail>:
{
    43b0:	7119                	addi	sp,sp,-128
    43b2:	fc86                	sd	ra,120(sp)
    43b4:	f8a2                	sd	s0,112(sp)
    43b6:	f4a6                	sd	s1,104(sp)
    43b8:	f0ca                	sd	s2,96(sp)
    43ba:	ecce                	sd	s3,88(sp)
    43bc:	e8d2                	sd	s4,80(sp)
    43be:	e4d6                	sd	s5,72(sp)
    43c0:	0100                	addi	s0,sp,128
    43c2:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    43c4:	fb040513          	addi	a0,s0,-80
    43c8:	00001097          	auipc	ra,0x1
    43cc:	4e8080e7          	jalr	1256(ra) # 58b0 <pipe>
    43d0:	e901                	bnez	a0,43e0 <sbrkfail+0x30>
    43d2:	f8040493          	addi	s1,s0,-128
    43d6:	fa840993          	addi	s3,s0,-88
    43da:	8926                	mv	s2,s1
    if(pids[i] != -1)
    43dc:	5a7d                	li	s4,-1
    43de:	a085                	j	443e <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    43e0:	85d6                	mv	a1,s5
    43e2:	00002517          	auipc	a0,0x2
    43e6:	79e50513          	addi	a0,a0,1950 # 6b80 <malloc+0xe90>
    43ea:	00002097          	auipc	ra,0x2
    43ee:	846080e7          	jalr	-1978(ra) # 5c30 <printf>
    exit(1);
    43f2:	4505                	li	a0,1
    43f4:	00001097          	auipc	ra,0x1
    43f8:	4ac080e7          	jalr	1196(ra) # 58a0 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    43fc:	00001097          	auipc	ra,0x1
    4400:	52c080e7          	jalr	1324(ra) # 5928 <sbrk>
    4404:	064007b7          	lui	a5,0x6400
    4408:	40a7853b          	subw	a0,a5,a0
    440c:	00001097          	auipc	ra,0x1
    4410:	51c080e7          	jalr	1308(ra) # 5928 <sbrk>
      write(fds[1], "x", 1);
    4414:	4605                	li	a2,1
    4416:	00002597          	auipc	a1,0x2
    441a:	e7a58593          	addi	a1,a1,-390 # 6290 <malloc+0x5a0>
    441e:	fb442503          	lw	a0,-76(s0)
    4422:	00001097          	auipc	ra,0x1
    4426:	49e080e7          	jalr	1182(ra) # 58c0 <write>
      for(;;) sleep(1000);
    442a:	3e800513          	li	a0,1000
    442e:	00001097          	auipc	ra,0x1
    4432:	502080e7          	jalr	1282(ra) # 5930 <sleep>
    4436:	bfd5                	j	442a <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4438:	0911                	addi	s2,s2,4
    443a:	03390563          	beq	s2,s3,4464 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    443e:	00001097          	auipc	ra,0x1
    4442:	45a080e7          	jalr	1114(ra) # 5898 <fork>
    4446:	00a92023          	sw	a0,0(s2)
    444a:	d94d                	beqz	a0,43fc <sbrkfail+0x4c>
    if(pids[i] != -1)
    444c:	ff4506e3          	beq	a0,s4,4438 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4450:	4605                	li	a2,1
    4452:	faf40593          	addi	a1,s0,-81
    4456:	fb042503          	lw	a0,-80(s0)
    445a:	00001097          	auipc	ra,0x1
    445e:	45e080e7          	jalr	1118(ra) # 58b8 <read>
    4462:	bfd9                	j	4438 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4464:	6505                	lui	a0,0x1
    4466:	00001097          	auipc	ra,0x1
    446a:	4c2080e7          	jalr	1218(ra) # 5928 <sbrk>
    446e:	892a                	mv	s2,a0
    if(pids[i] == -1)
    4470:	5a7d                	li	s4,-1
    4472:	a021                	j	447a <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4474:	0491                	addi	s1,s1,4
    4476:	01348f63          	beq	s1,s3,4494 <sbrkfail+0xe4>
    if(pids[i] == -1)
    447a:	4088                	lw	a0,0(s1)
    447c:	ff450ce3          	beq	a0,s4,4474 <sbrkfail+0xc4>
    kill(pids[i]);
    4480:	00001097          	auipc	ra,0x1
    4484:	450080e7          	jalr	1104(ra) # 58d0 <kill>
    wait(0);
    4488:	4501                	li	a0,0
    448a:	00001097          	auipc	ra,0x1
    448e:	41e080e7          	jalr	1054(ra) # 58a8 <wait>
    4492:	b7cd                	j	4474 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4494:	57fd                	li	a5,-1
    4496:	04f90163          	beq	s2,a5,44d8 <sbrkfail+0x128>
  pid = fork();
    449a:	00001097          	auipc	ra,0x1
    449e:	3fe080e7          	jalr	1022(ra) # 5898 <fork>
    44a2:	84aa                	mv	s1,a0
  if(pid < 0){
    44a4:	04054863          	bltz	a0,44f4 <sbrkfail+0x144>
  if(pid == 0){
    44a8:	c525                	beqz	a0,4510 <sbrkfail+0x160>
  wait(&xstatus);
    44aa:	fbc40513          	addi	a0,s0,-68
    44ae:	00001097          	auipc	ra,0x1
    44b2:	3fa080e7          	jalr	1018(ra) # 58a8 <wait>
  if(xstatus != -1 && xstatus != 2)
    44b6:	fbc42783          	lw	a5,-68(s0)
    44ba:	577d                	li	a4,-1
    44bc:	00e78563          	beq	a5,a4,44c6 <sbrkfail+0x116>
    44c0:	4709                	li	a4,2
    44c2:	08e79d63          	bne	a5,a4,455c <sbrkfail+0x1ac>
}
    44c6:	70e6                	ld	ra,120(sp)
    44c8:	7446                	ld	s0,112(sp)
    44ca:	74a6                	ld	s1,104(sp)
    44cc:	7906                	ld	s2,96(sp)
    44ce:	69e6                	ld	s3,88(sp)
    44d0:	6a46                	ld	s4,80(sp)
    44d2:	6aa6                	ld	s5,72(sp)
    44d4:	6109                	addi	sp,sp,128
    44d6:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    44d8:	85d6                	mv	a1,s5
    44da:	00004517          	auipc	a0,0x4
    44de:	89e50513          	addi	a0,a0,-1890 # 7d78 <malloc+0x2088>
    44e2:	00001097          	auipc	ra,0x1
    44e6:	74e080e7          	jalr	1870(ra) # 5c30 <printf>
    exit(1);
    44ea:	4505                	li	a0,1
    44ec:	00001097          	auipc	ra,0x1
    44f0:	3b4080e7          	jalr	948(ra) # 58a0 <exit>
    printf("%s: fork failed\n", s);
    44f4:	85d6                	mv	a1,s5
    44f6:	00002517          	auipc	a0,0x2
    44fa:	58250513          	addi	a0,a0,1410 # 6a78 <malloc+0xd88>
    44fe:	00001097          	auipc	ra,0x1
    4502:	732080e7          	jalr	1842(ra) # 5c30 <printf>
    exit(1);
    4506:	4505                	li	a0,1
    4508:	00001097          	auipc	ra,0x1
    450c:	398080e7          	jalr	920(ra) # 58a0 <exit>
    a = sbrk(0);
    4510:	4501                	li	a0,0
    4512:	00001097          	auipc	ra,0x1
    4516:	416080e7          	jalr	1046(ra) # 5928 <sbrk>
    451a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    451c:	3e800537          	lui	a0,0x3e800
    4520:	00001097          	auipc	ra,0x1
    4524:	408080e7          	jalr	1032(ra) # 5928 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4528:	874a                	mv	a4,s2
    452a:	3e8007b7          	lui	a5,0x3e800
    452e:	97ca                	add	a5,a5,s2
    4530:	6685                	lui	a3,0x1
      n += *(a+i);
    4532:	00074603          	lbu	a2,0(a4)
    4536:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4538:	9736                	add	a4,a4,a3
    453a:	fee79ce3          	bne	a5,a4,4532 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    453e:	8626                	mv	a2,s1
    4540:	85d6                	mv	a1,s5
    4542:	00004517          	auipc	a0,0x4
    4546:	85650513          	addi	a0,a0,-1962 # 7d98 <malloc+0x20a8>
    454a:	00001097          	auipc	ra,0x1
    454e:	6e6080e7          	jalr	1766(ra) # 5c30 <printf>
    exit(1);
    4552:	4505                	li	a0,1
    4554:	00001097          	auipc	ra,0x1
    4558:	34c080e7          	jalr	844(ra) # 58a0 <exit>
    exit(1);
    455c:	4505                	li	a0,1
    455e:	00001097          	auipc	ra,0x1
    4562:	342080e7          	jalr	834(ra) # 58a0 <exit>

0000000000004566 <mem>:
{
    4566:	7139                	addi	sp,sp,-64
    4568:	fc06                	sd	ra,56(sp)
    456a:	f822                	sd	s0,48(sp)
    456c:	f426                	sd	s1,40(sp)
    456e:	f04a                	sd	s2,32(sp)
    4570:	ec4e                	sd	s3,24(sp)
    4572:	0080                	addi	s0,sp,64
    4574:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4576:	00001097          	auipc	ra,0x1
    457a:	322080e7          	jalr	802(ra) # 5898 <fork>
    m1 = 0;
    457e:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4580:	6909                	lui	s2,0x2
    4582:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x81>
  if((pid = fork()) == 0){
    4586:	e135                	bnez	a0,45ea <mem+0x84>
    while((m2 = malloc(10001)) != 0){
    4588:	854a                	mv	a0,s2
    458a:	00001097          	auipc	ra,0x1
    458e:	766080e7          	jalr	1894(ra) # 5cf0 <malloc>
    4592:	c501                	beqz	a0,459a <mem+0x34>
      *(char**)m2 = m1;
    4594:	e104                	sd	s1,0(a0)
      m1 = m2;
    4596:	84aa                	mv	s1,a0
    4598:	bfc5                	j	4588 <mem+0x22>
    while(m1){
    459a:	c899                	beqz	s1,45b0 <mem+0x4a>
      m2 = *(char**)m1;
    459c:	0004b903          	ld	s2,0(s1)
      free(m1);
    45a0:	8526                	mv	a0,s1
    45a2:	00001097          	auipc	ra,0x1
    45a6:	6c4080e7          	jalr	1732(ra) # 5c66 <free>
      m1 = m2;
    45aa:	84ca                	mv	s1,s2
    while(m1){
    45ac:	fe0918e3          	bnez	s2,459c <mem+0x36>
    m1 = malloc(1024*20);
    45b0:	6515                	lui	a0,0x5
    45b2:	00001097          	auipc	ra,0x1
    45b6:	73e080e7          	jalr	1854(ra) # 5cf0 <malloc>
    if(m1 == 0){
    45ba:	c911                	beqz	a0,45ce <mem+0x68>
    free(m1);
    45bc:	00001097          	auipc	ra,0x1
    45c0:	6aa080e7          	jalr	1706(ra) # 5c66 <free>
    exit(0);
    45c4:	4501                	li	a0,0
    45c6:	00001097          	auipc	ra,0x1
    45ca:	2da080e7          	jalr	730(ra) # 58a0 <exit>
      printf("couldn't allocate mem?!!\n", s);
    45ce:	85ce                	mv	a1,s3
    45d0:	00003517          	auipc	a0,0x3
    45d4:	7f850513          	addi	a0,a0,2040 # 7dc8 <malloc+0x20d8>
    45d8:	00001097          	auipc	ra,0x1
    45dc:	658080e7          	jalr	1624(ra) # 5c30 <printf>
      exit(1);
    45e0:	4505                	li	a0,1
    45e2:	00001097          	auipc	ra,0x1
    45e6:	2be080e7          	jalr	702(ra) # 58a0 <exit>
    wait(&xstatus);
    45ea:	fcc40513          	addi	a0,s0,-52
    45ee:	00001097          	auipc	ra,0x1
    45f2:	2ba080e7          	jalr	698(ra) # 58a8 <wait>
    if(xstatus == -1){
    45f6:	fcc42503          	lw	a0,-52(s0)
    45fa:	57fd                	li	a5,-1
    45fc:	00f50663          	beq	a0,a5,4608 <mem+0xa2>
    exit(xstatus);
    4600:	00001097          	auipc	ra,0x1
    4604:	2a0080e7          	jalr	672(ra) # 58a0 <exit>
      exit(0);
    4608:	4501                	li	a0,0
    460a:	00001097          	auipc	ra,0x1
    460e:	296080e7          	jalr	662(ra) # 58a0 <exit>

0000000000004612 <sharedfd>:
{
    4612:	7159                	addi	sp,sp,-112
    4614:	f486                	sd	ra,104(sp)
    4616:	f0a2                	sd	s0,96(sp)
    4618:	eca6                	sd	s1,88(sp)
    461a:	e8ca                	sd	s2,80(sp)
    461c:	e4ce                	sd	s3,72(sp)
    461e:	e0d2                	sd	s4,64(sp)
    4620:	fc56                	sd	s5,56(sp)
    4622:	f85a                	sd	s6,48(sp)
    4624:	f45e                	sd	s7,40(sp)
    4626:	1880                	addi	s0,sp,112
    4628:	89aa                	mv	s3,a0
  unlink("sharedfd");
    462a:	00003517          	auipc	a0,0x3
    462e:	7be50513          	addi	a0,a0,1982 # 7de8 <malloc+0x20f8>
    4632:	00001097          	auipc	ra,0x1
    4636:	2be080e7          	jalr	702(ra) # 58f0 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    463a:	20200593          	li	a1,514
    463e:	00003517          	auipc	a0,0x3
    4642:	7aa50513          	addi	a0,a0,1962 # 7de8 <malloc+0x20f8>
    4646:	00001097          	auipc	ra,0x1
    464a:	29a080e7          	jalr	666(ra) # 58e0 <open>
  if(fd < 0){
    464e:	04054a63          	bltz	a0,46a2 <sharedfd+0x90>
    4652:	892a                	mv	s2,a0
  pid = fork();
    4654:	00001097          	auipc	ra,0x1
    4658:	244080e7          	jalr	580(ra) # 5898 <fork>
    465c:	8a2a                	mv	s4,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    465e:	06300593          	li	a1,99
    4662:	c119                	beqz	a0,4668 <sharedfd+0x56>
    4664:	07000593          	li	a1,112
    4668:	4629                	li	a2,10
    466a:	fa040513          	addi	a0,s0,-96
    466e:	00001097          	auipc	ra,0x1
    4672:	01c080e7          	jalr	28(ra) # 568a <memset>
    4676:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    467a:	4629                	li	a2,10
    467c:	fa040593          	addi	a1,s0,-96
    4680:	854a                	mv	a0,s2
    4682:	00001097          	auipc	ra,0x1
    4686:	23e080e7          	jalr	574(ra) # 58c0 <write>
    468a:	47a9                	li	a5,10
    468c:	02f51963          	bne	a0,a5,46be <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4690:	34fd                	addiw	s1,s1,-1
    4692:	f4e5                	bnez	s1,467a <sharedfd+0x68>
  if(pid == 0) {
    4694:	040a1363          	bnez	s4,46da <sharedfd+0xc8>
    exit(0);
    4698:	4501                	li	a0,0
    469a:	00001097          	auipc	ra,0x1
    469e:	206080e7          	jalr	518(ra) # 58a0 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    46a2:	85ce                	mv	a1,s3
    46a4:	00003517          	auipc	a0,0x3
    46a8:	75450513          	addi	a0,a0,1876 # 7df8 <malloc+0x2108>
    46ac:	00001097          	auipc	ra,0x1
    46b0:	584080e7          	jalr	1412(ra) # 5c30 <printf>
    exit(1);
    46b4:	4505                	li	a0,1
    46b6:	00001097          	auipc	ra,0x1
    46ba:	1ea080e7          	jalr	490(ra) # 58a0 <exit>
      printf("%s: write sharedfd failed\n", s);
    46be:	85ce                	mv	a1,s3
    46c0:	00003517          	auipc	a0,0x3
    46c4:	76050513          	addi	a0,a0,1888 # 7e20 <malloc+0x2130>
    46c8:	00001097          	auipc	ra,0x1
    46cc:	568080e7          	jalr	1384(ra) # 5c30 <printf>
      exit(1);
    46d0:	4505                	li	a0,1
    46d2:	00001097          	auipc	ra,0x1
    46d6:	1ce080e7          	jalr	462(ra) # 58a0 <exit>
    wait(&xstatus);
    46da:	f9c40513          	addi	a0,s0,-100
    46de:	00001097          	auipc	ra,0x1
    46e2:	1ca080e7          	jalr	458(ra) # 58a8 <wait>
    if(xstatus != 0)
    46e6:	f9c42a03          	lw	s4,-100(s0)
    46ea:	000a0763          	beqz	s4,46f8 <sharedfd+0xe6>
      exit(xstatus);
    46ee:	8552                	mv	a0,s4
    46f0:	00001097          	auipc	ra,0x1
    46f4:	1b0080e7          	jalr	432(ra) # 58a0 <exit>
  close(fd);
    46f8:	854a                	mv	a0,s2
    46fa:	00001097          	auipc	ra,0x1
    46fe:	1ce080e7          	jalr	462(ra) # 58c8 <close>
  fd = open("sharedfd", 0);
    4702:	4581                	li	a1,0
    4704:	00003517          	auipc	a0,0x3
    4708:	6e450513          	addi	a0,a0,1764 # 7de8 <malloc+0x20f8>
    470c:	00001097          	auipc	ra,0x1
    4710:	1d4080e7          	jalr	468(ra) # 58e0 <open>
    4714:	8baa                	mv	s7,a0
  nc = np = 0;
    4716:	8ad2                	mv	s5,s4
  if(fd < 0){
    4718:	02054563          	bltz	a0,4742 <sharedfd+0x130>
    471c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4720:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4724:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4728:	4629                	li	a2,10
    472a:	fa040593          	addi	a1,s0,-96
    472e:	855e                	mv	a0,s7
    4730:	00001097          	auipc	ra,0x1
    4734:	188080e7          	jalr	392(ra) # 58b8 <read>
    4738:	02a05f63          	blez	a0,4776 <sharedfd+0x164>
    473c:	fa040793          	addi	a5,s0,-96
    4740:	a01d                	j	4766 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4742:	85ce                	mv	a1,s3
    4744:	00003517          	auipc	a0,0x3
    4748:	6fc50513          	addi	a0,a0,1788 # 7e40 <malloc+0x2150>
    474c:	00001097          	auipc	ra,0x1
    4750:	4e4080e7          	jalr	1252(ra) # 5c30 <printf>
    exit(1);
    4754:	4505                	li	a0,1
    4756:	00001097          	auipc	ra,0x1
    475a:	14a080e7          	jalr	330(ra) # 58a0 <exit>
        nc++;
    475e:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    4760:	0785                	addi	a5,a5,1
    4762:	fd2783e3          	beq	a5,s2,4728 <sharedfd+0x116>
      if(buf[i] == 'c')
    4766:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f11f8>
    476a:	fe970ae3          	beq	a4,s1,475e <sharedfd+0x14c>
      if(buf[i] == 'p')
    476e:	ff6719e3          	bne	a4,s6,4760 <sharedfd+0x14e>
        np++;
    4772:	2a85                	addiw	s5,s5,1
    4774:	b7f5                	j	4760 <sharedfd+0x14e>
  close(fd);
    4776:	855e                	mv	a0,s7
    4778:	00001097          	auipc	ra,0x1
    477c:	150080e7          	jalr	336(ra) # 58c8 <close>
  unlink("sharedfd");
    4780:	00003517          	auipc	a0,0x3
    4784:	66850513          	addi	a0,a0,1640 # 7de8 <malloc+0x20f8>
    4788:	00001097          	auipc	ra,0x1
    478c:	168080e7          	jalr	360(ra) # 58f0 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4790:	6789                	lui	a5,0x2
    4792:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x80>
    4796:	00fa1763          	bne	s4,a5,47a4 <sharedfd+0x192>
    479a:	6789                	lui	a5,0x2
    479c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x80>
    47a0:	02fa8063          	beq	s5,a5,47c0 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    47a4:	85ce                	mv	a1,s3
    47a6:	00003517          	auipc	a0,0x3
    47aa:	6c250513          	addi	a0,a0,1730 # 7e68 <malloc+0x2178>
    47ae:	00001097          	auipc	ra,0x1
    47b2:	482080e7          	jalr	1154(ra) # 5c30 <printf>
    exit(1);
    47b6:	4505                	li	a0,1
    47b8:	00001097          	auipc	ra,0x1
    47bc:	0e8080e7          	jalr	232(ra) # 58a0 <exit>
    exit(0);
    47c0:	4501                	li	a0,0
    47c2:	00001097          	auipc	ra,0x1
    47c6:	0de080e7          	jalr	222(ra) # 58a0 <exit>

00000000000047ca <fourfiles>:
{
    47ca:	7135                	addi	sp,sp,-160
    47cc:	ed06                	sd	ra,152(sp)
    47ce:	e922                	sd	s0,144(sp)
    47d0:	e526                	sd	s1,136(sp)
    47d2:	e14a                	sd	s2,128(sp)
    47d4:	fcce                	sd	s3,120(sp)
    47d6:	f8d2                	sd	s4,112(sp)
    47d8:	f4d6                	sd	s5,104(sp)
    47da:	f0da                	sd	s6,96(sp)
    47dc:	ecde                	sd	s7,88(sp)
    47de:	e8e2                	sd	s8,80(sp)
    47e0:	e4e6                	sd	s9,72(sp)
    47e2:	e0ea                	sd	s10,64(sp)
    47e4:	fc6e                	sd	s11,56(sp)
    47e6:	1100                	addi	s0,sp,160
    47e8:	8d2a                	mv	s10,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    47ea:	00003797          	auipc	a5,0x3
    47ee:	69678793          	addi	a5,a5,1686 # 7e80 <malloc+0x2190>
    47f2:	f6f43823          	sd	a5,-144(s0)
    47f6:	00003797          	auipc	a5,0x3
    47fa:	69278793          	addi	a5,a5,1682 # 7e88 <malloc+0x2198>
    47fe:	f6f43c23          	sd	a5,-136(s0)
    4802:	00003797          	auipc	a5,0x3
    4806:	68e78793          	addi	a5,a5,1678 # 7e90 <malloc+0x21a0>
    480a:	f8f43023          	sd	a5,-128(s0)
    480e:	00003797          	auipc	a5,0x3
    4812:	68a78793          	addi	a5,a5,1674 # 7e98 <malloc+0x21a8>
    4816:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    481a:	f7040b13          	addi	s6,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    481e:	895a                	mv	s2,s6
  for(pi = 0; pi < NCHILD; pi++){
    4820:	4481                	li	s1,0
    4822:	4a11                	li	s4,4
    fname = names[pi];
    4824:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4828:	854e                	mv	a0,s3
    482a:	00001097          	auipc	ra,0x1
    482e:	0c6080e7          	jalr	198(ra) # 58f0 <unlink>
    pid = fork();
    4832:	00001097          	auipc	ra,0x1
    4836:	066080e7          	jalr	102(ra) # 5898 <fork>
    if(pid < 0){
    483a:	04054063          	bltz	a0,487a <fourfiles+0xb0>
    if(pid == 0){
    483e:	cd21                	beqz	a0,4896 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4840:	2485                	addiw	s1,s1,1
    4842:	0921                	addi	s2,s2,8
    4844:	ff4490e3          	bne	s1,s4,4824 <fourfiles+0x5a>
    4848:	4491                	li	s1,4
    wait(&xstatus);
    484a:	f6c40513          	addi	a0,s0,-148
    484e:	00001097          	auipc	ra,0x1
    4852:	05a080e7          	jalr	90(ra) # 58a8 <wait>
    if(xstatus != 0)
    4856:	f6c42503          	lw	a0,-148(s0)
    485a:	e961                	bnez	a0,492a <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    485c:	34fd                	addiw	s1,s1,-1
    485e:	f4f5                	bnez	s1,484a <fourfiles+0x80>
    4860:	03000a93          	li	s5,48
    total = 0;
    4864:	8daa                	mv	s11,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4866:	00007997          	auipc	s3,0x7
    486a:	59298993          	addi	s3,s3,1426 # bdf8 <buf>
    if(total != N*SZ){
    486e:	6c05                	lui	s8,0x1
    4870:	770c0c13          	addi	s8,s8,1904 # 1770 <pipe1+0x1e>
  for(i = 0; i < NCHILD; i++){
    4874:	03400c93          	li	s9,52
    4878:	aa15                	j	49ac <fourfiles+0x1e2>
      printf("fork failed\n", s);
    487a:	85ea                	mv	a1,s10
    487c:	00002517          	auipc	a0,0x2
    4880:	61c50513          	addi	a0,a0,1564 # 6e98 <malloc+0x11a8>
    4884:	00001097          	auipc	ra,0x1
    4888:	3ac080e7          	jalr	940(ra) # 5c30 <printf>
      exit(1);
    488c:	4505                	li	a0,1
    488e:	00001097          	auipc	ra,0x1
    4892:	012080e7          	jalr	18(ra) # 58a0 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4896:	20200593          	li	a1,514
    489a:	854e                	mv	a0,s3
    489c:	00001097          	auipc	ra,0x1
    48a0:	044080e7          	jalr	68(ra) # 58e0 <open>
    48a4:	892a                	mv	s2,a0
      if(fd < 0){
    48a6:	04054663          	bltz	a0,48f2 <fourfiles+0x128>
      memset(buf, '0'+pi, SZ);
    48aa:	1f400613          	li	a2,500
    48ae:	0304859b          	addiw	a1,s1,48
    48b2:	00007517          	auipc	a0,0x7
    48b6:	54650513          	addi	a0,a0,1350 # bdf8 <buf>
    48ba:	00001097          	auipc	ra,0x1
    48be:	dd0080e7          	jalr	-560(ra) # 568a <memset>
    48c2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    48c4:	00007997          	auipc	s3,0x7
    48c8:	53498993          	addi	s3,s3,1332 # bdf8 <buf>
    48cc:	1f400613          	li	a2,500
    48d0:	85ce                	mv	a1,s3
    48d2:	854a                	mv	a0,s2
    48d4:	00001097          	auipc	ra,0x1
    48d8:	fec080e7          	jalr	-20(ra) # 58c0 <write>
    48dc:	1f400793          	li	a5,500
    48e0:	02f51763          	bne	a0,a5,490e <fourfiles+0x144>
      for(i = 0; i < N; i++){
    48e4:	34fd                	addiw	s1,s1,-1
    48e6:	f0fd                	bnez	s1,48cc <fourfiles+0x102>
      exit(0);
    48e8:	4501                	li	a0,0
    48ea:	00001097          	auipc	ra,0x1
    48ee:	fb6080e7          	jalr	-74(ra) # 58a0 <exit>
        printf("create failed\n", s);
    48f2:	85ea                	mv	a1,s10
    48f4:	00003517          	auipc	a0,0x3
    48f8:	5ac50513          	addi	a0,a0,1452 # 7ea0 <malloc+0x21b0>
    48fc:	00001097          	auipc	ra,0x1
    4900:	334080e7          	jalr	820(ra) # 5c30 <printf>
        exit(1);
    4904:	4505                	li	a0,1
    4906:	00001097          	auipc	ra,0x1
    490a:	f9a080e7          	jalr	-102(ra) # 58a0 <exit>
          printf("write failed %d\n", n);
    490e:	85aa                	mv	a1,a0
    4910:	00003517          	auipc	a0,0x3
    4914:	5a050513          	addi	a0,a0,1440 # 7eb0 <malloc+0x21c0>
    4918:	00001097          	auipc	ra,0x1
    491c:	318080e7          	jalr	792(ra) # 5c30 <printf>
          exit(1);
    4920:	4505                	li	a0,1
    4922:	00001097          	auipc	ra,0x1
    4926:	f7e080e7          	jalr	-130(ra) # 58a0 <exit>
      exit(xstatus);
    492a:	00001097          	auipc	ra,0x1
    492e:	f76080e7          	jalr	-138(ra) # 58a0 <exit>
      total += n;
    4932:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4936:	660d                	lui	a2,0x3
    4938:	85ce                	mv	a1,s3
    493a:	8552                	mv	a0,s4
    493c:	00001097          	auipc	ra,0x1
    4940:	f7c080e7          	jalr	-132(ra) # 58b8 <read>
    4944:	04a05463          	blez	a0,498c <fourfiles+0x1c2>
        if(buf[j] != '0'+i){
    4948:	0009c783          	lbu	a5,0(s3)
    494c:	02979263          	bne	a5,s1,4970 <fourfiles+0x1a6>
    4950:	00007797          	auipc	a5,0x7
    4954:	4a978793          	addi	a5,a5,1193 # bdf9 <buf+0x1>
    4958:	fff5069b          	addiw	a3,a0,-1
    495c:	1682                	slli	a3,a3,0x20
    495e:	9281                	srli	a3,a3,0x20
    4960:	96be                	add	a3,a3,a5
      for(j = 0; j < n; j++){
    4962:	fcd788e3          	beq	a5,a3,4932 <fourfiles+0x168>
        if(buf[j] != '0'+i){
    4966:	0007c703          	lbu	a4,0(a5)
    496a:	0785                	addi	a5,a5,1
    496c:	fe970be3          	beq	a4,s1,4962 <fourfiles+0x198>
          printf("wrong char\n", s);
    4970:	85ea                	mv	a1,s10
    4972:	00003517          	auipc	a0,0x3
    4976:	55650513          	addi	a0,a0,1366 # 7ec8 <malloc+0x21d8>
    497a:	00001097          	auipc	ra,0x1
    497e:	2b6080e7          	jalr	694(ra) # 5c30 <printf>
          exit(1);
    4982:	4505                	li	a0,1
    4984:	00001097          	auipc	ra,0x1
    4988:	f1c080e7          	jalr	-228(ra) # 58a0 <exit>
    close(fd);
    498c:	8552                	mv	a0,s4
    498e:	00001097          	auipc	ra,0x1
    4992:	f3a080e7          	jalr	-198(ra) # 58c8 <close>
    if(total != N*SZ){
    4996:	03891863          	bne	s2,s8,49c6 <fourfiles+0x1fc>
    unlink(fname);
    499a:	855e                	mv	a0,s7
    499c:	00001097          	auipc	ra,0x1
    49a0:	f54080e7          	jalr	-172(ra) # 58f0 <unlink>
  for(i = 0; i < NCHILD; i++){
    49a4:	0b21                	addi	s6,s6,8
    49a6:	2a85                	addiw	s5,s5,1
    49a8:	039a8d63          	beq	s5,s9,49e2 <fourfiles+0x218>
    fname = names[i];
    49ac:	000b3b83          	ld	s7,0(s6) # 3000 <iputtest+0x56>
    fd = open(fname, 0);
    49b0:	4581                	li	a1,0
    49b2:	855e                	mv	a0,s7
    49b4:	00001097          	auipc	ra,0x1
    49b8:	f2c080e7          	jalr	-212(ra) # 58e0 <open>
    49bc:	8a2a                	mv	s4,a0
    total = 0;
    49be:	896e                	mv	s2,s11
    49c0:	000a849b          	sext.w	s1,s5
    while((n = read(fd, buf, sizeof(buf))) > 0){
    49c4:	bf8d                	j	4936 <fourfiles+0x16c>
      printf("wrong length %d\n", total);
    49c6:	85ca                	mv	a1,s2
    49c8:	00003517          	auipc	a0,0x3
    49cc:	51050513          	addi	a0,a0,1296 # 7ed8 <malloc+0x21e8>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	260080e7          	jalr	608(ra) # 5c30 <printf>
      exit(1);
    49d8:	4505                	li	a0,1
    49da:	00001097          	auipc	ra,0x1
    49de:	ec6080e7          	jalr	-314(ra) # 58a0 <exit>
}
    49e2:	60ea                	ld	ra,152(sp)
    49e4:	644a                	ld	s0,144(sp)
    49e6:	64aa                	ld	s1,136(sp)
    49e8:	690a                	ld	s2,128(sp)
    49ea:	79e6                	ld	s3,120(sp)
    49ec:	7a46                	ld	s4,112(sp)
    49ee:	7aa6                	ld	s5,104(sp)
    49f0:	7b06                	ld	s6,96(sp)
    49f2:	6be6                	ld	s7,88(sp)
    49f4:	6c46                	ld	s8,80(sp)
    49f6:	6ca6                	ld	s9,72(sp)
    49f8:	6d06                	ld	s10,64(sp)
    49fa:	7de2                	ld	s11,56(sp)
    49fc:	610d                	addi	sp,sp,160
    49fe:	8082                	ret

0000000000004a00 <concreate>:
{
    4a00:	7135                	addi	sp,sp,-160
    4a02:	ed06                	sd	ra,152(sp)
    4a04:	e922                	sd	s0,144(sp)
    4a06:	e526                	sd	s1,136(sp)
    4a08:	e14a                	sd	s2,128(sp)
    4a0a:	fcce                	sd	s3,120(sp)
    4a0c:	f8d2                	sd	s4,112(sp)
    4a0e:	f4d6                	sd	s5,104(sp)
    4a10:	f0da                	sd	s6,96(sp)
    4a12:	ecde                	sd	s7,88(sp)
    4a14:	1100                	addi	s0,sp,160
    4a16:	89aa                	mv	s3,a0
  file[0] = 'C';
    4a18:	04300793          	li	a5,67
    4a1c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4a20:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4a24:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4a26:	4b0d                	li	s6,3
    4a28:	4a85                	li	s5,1
      link("C0", file);
    4a2a:	00003b97          	auipc	s7,0x3
    4a2e:	4c6b8b93          	addi	s7,s7,1222 # 7ef0 <malloc+0x2200>
  for(i = 0; i < N; i++){
    4a32:	02800a13          	li	s4,40
    4a36:	acc1                	j	4d06 <concreate+0x306>
      link("C0", file);
    4a38:	fa840593          	addi	a1,s0,-88
    4a3c:	855e                	mv	a0,s7
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	ec2080e7          	jalr	-318(ra) # 5900 <link>
    if(pid == 0) {
    4a46:	a45d                	j	4cec <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4a48:	4795                	li	a5,5
    4a4a:	02f9693b          	remw	s2,s2,a5
    4a4e:	4785                	li	a5,1
    4a50:	02f90b63          	beq	s2,a5,4a86 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4a54:	20200593          	li	a1,514
    4a58:	fa840513          	addi	a0,s0,-88
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	e84080e7          	jalr	-380(ra) # 58e0 <open>
      if(fd < 0){
    4a64:	26055b63          	bgez	a0,4cda <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4a68:	fa840593          	addi	a1,s0,-88
    4a6c:	00003517          	auipc	a0,0x3
    4a70:	48c50513          	addi	a0,a0,1164 # 7ef8 <malloc+0x2208>
    4a74:	00001097          	auipc	ra,0x1
    4a78:	1bc080e7          	jalr	444(ra) # 5c30 <printf>
        exit(1);
    4a7c:	4505                	li	a0,1
    4a7e:	00001097          	auipc	ra,0x1
    4a82:	e22080e7          	jalr	-478(ra) # 58a0 <exit>
      link("C0", file);
    4a86:	fa840593          	addi	a1,s0,-88
    4a8a:	00003517          	auipc	a0,0x3
    4a8e:	46650513          	addi	a0,a0,1126 # 7ef0 <malloc+0x2200>
    4a92:	00001097          	auipc	ra,0x1
    4a96:	e6e080e7          	jalr	-402(ra) # 5900 <link>
      exit(0);
    4a9a:	4501                	li	a0,0
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	e04080e7          	jalr	-508(ra) # 58a0 <exit>
        exit(1);
    4aa4:	4505                	li	a0,1
    4aa6:	00001097          	auipc	ra,0x1
    4aaa:	dfa080e7          	jalr	-518(ra) # 58a0 <exit>
  memset(fa, 0, sizeof(fa));
    4aae:	02800613          	li	a2,40
    4ab2:	4581                	li	a1,0
    4ab4:	f8040513          	addi	a0,s0,-128
    4ab8:	00001097          	auipc	ra,0x1
    4abc:	bd2080e7          	jalr	-1070(ra) # 568a <memset>
  fd = open(".", 0);
    4ac0:	4581                	li	a1,0
    4ac2:	00002517          	auipc	a0,0x2
    4ac6:	e1650513          	addi	a0,a0,-490 # 68d8 <malloc+0xbe8>
    4aca:	00001097          	auipc	ra,0x1
    4ace:	e16080e7          	jalr	-490(ra) # 58e0 <open>
    4ad2:	892a                	mv	s2,a0
  n = 0;
    4ad4:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4ad6:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4ada:	02700b13          	li	s6,39
      fa[i] = 1;
    4ade:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4ae0:	4641                	li	a2,16
    4ae2:	f7040593          	addi	a1,s0,-144
    4ae6:	854a                	mv	a0,s2
    4ae8:	00001097          	auipc	ra,0x1
    4aec:	dd0080e7          	jalr	-560(ra) # 58b8 <read>
    4af0:	08a05163          	blez	a0,4b72 <concreate+0x172>
    if(de.inum == 0)
    4af4:	f7045783          	lhu	a5,-144(s0)
    4af8:	d7e5                	beqz	a5,4ae0 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4afa:	f7244783          	lbu	a5,-142(s0)
    4afe:	ff4791e3          	bne	a5,s4,4ae0 <concreate+0xe0>
    4b02:	f7444783          	lbu	a5,-140(s0)
    4b06:	ffe9                	bnez	a5,4ae0 <concreate+0xe0>
      i = de.name[1] - '0';
    4b08:	f7344783          	lbu	a5,-141(s0)
    4b0c:	fd07879b          	addiw	a5,a5,-48
    4b10:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4b14:	00eb6f63          	bltu	s6,a4,4b32 <concreate+0x132>
      if(fa[i]){
    4b18:	fb040793          	addi	a5,s0,-80
    4b1c:	97ba                	add	a5,a5,a4
    4b1e:	fd07c783          	lbu	a5,-48(a5)
    4b22:	eb85                	bnez	a5,4b52 <concreate+0x152>
      fa[i] = 1;
    4b24:	fb040793          	addi	a5,s0,-80
    4b28:	973e                	add	a4,a4,a5
    4b2a:	fd770823          	sb	s7,-48(a4)
      n++;
    4b2e:	2a85                	addiw	s5,s5,1
    4b30:	bf45                	j	4ae0 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4b32:	f7240613          	addi	a2,s0,-142
    4b36:	85ce                	mv	a1,s3
    4b38:	00003517          	auipc	a0,0x3
    4b3c:	3e050513          	addi	a0,a0,992 # 7f18 <malloc+0x2228>
    4b40:	00001097          	auipc	ra,0x1
    4b44:	0f0080e7          	jalr	240(ra) # 5c30 <printf>
        exit(1);
    4b48:	4505                	li	a0,1
    4b4a:	00001097          	auipc	ra,0x1
    4b4e:	d56080e7          	jalr	-682(ra) # 58a0 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4b52:	f7240613          	addi	a2,s0,-142
    4b56:	85ce                	mv	a1,s3
    4b58:	00003517          	auipc	a0,0x3
    4b5c:	3e050513          	addi	a0,a0,992 # 7f38 <malloc+0x2248>
    4b60:	00001097          	auipc	ra,0x1
    4b64:	0d0080e7          	jalr	208(ra) # 5c30 <printf>
        exit(1);
    4b68:	4505                	li	a0,1
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	d36080e7          	jalr	-714(ra) # 58a0 <exit>
  close(fd);
    4b72:	854a                	mv	a0,s2
    4b74:	00001097          	auipc	ra,0x1
    4b78:	d54080e7          	jalr	-684(ra) # 58c8 <close>
  if(n != N){
    4b7c:	02800793          	li	a5,40
    4b80:	00fa9763          	bne	s5,a5,4b8e <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4b84:	4a8d                	li	s5,3
    4b86:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4b88:	02800a13          	li	s4,40
    4b8c:	a8c9                	j	4c5e <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4b8e:	85ce                	mv	a1,s3
    4b90:	00003517          	auipc	a0,0x3
    4b94:	3d050513          	addi	a0,a0,976 # 7f60 <malloc+0x2270>
    4b98:	00001097          	auipc	ra,0x1
    4b9c:	098080e7          	jalr	152(ra) # 5c30 <printf>
    exit(1);
    4ba0:	4505                	li	a0,1
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	cfe080e7          	jalr	-770(ra) # 58a0 <exit>
      printf("%s: fork failed\n", s);
    4baa:	85ce                	mv	a1,s3
    4bac:	00002517          	auipc	a0,0x2
    4bb0:	ecc50513          	addi	a0,a0,-308 # 6a78 <malloc+0xd88>
    4bb4:	00001097          	auipc	ra,0x1
    4bb8:	07c080e7          	jalr	124(ra) # 5c30 <printf>
      exit(1);
    4bbc:	4505                	li	a0,1
    4bbe:	00001097          	auipc	ra,0x1
    4bc2:	ce2080e7          	jalr	-798(ra) # 58a0 <exit>
      close(open(file, 0));
    4bc6:	4581                	li	a1,0
    4bc8:	fa840513          	addi	a0,s0,-88
    4bcc:	00001097          	auipc	ra,0x1
    4bd0:	d14080e7          	jalr	-748(ra) # 58e0 <open>
    4bd4:	00001097          	auipc	ra,0x1
    4bd8:	cf4080e7          	jalr	-780(ra) # 58c8 <close>
      close(open(file, 0));
    4bdc:	4581                	li	a1,0
    4bde:	fa840513          	addi	a0,s0,-88
    4be2:	00001097          	auipc	ra,0x1
    4be6:	cfe080e7          	jalr	-770(ra) # 58e0 <open>
    4bea:	00001097          	auipc	ra,0x1
    4bee:	cde080e7          	jalr	-802(ra) # 58c8 <close>
      close(open(file, 0));
    4bf2:	4581                	li	a1,0
    4bf4:	fa840513          	addi	a0,s0,-88
    4bf8:	00001097          	auipc	ra,0x1
    4bfc:	ce8080e7          	jalr	-792(ra) # 58e0 <open>
    4c00:	00001097          	auipc	ra,0x1
    4c04:	cc8080e7          	jalr	-824(ra) # 58c8 <close>
      close(open(file, 0));
    4c08:	4581                	li	a1,0
    4c0a:	fa840513          	addi	a0,s0,-88
    4c0e:	00001097          	auipc	ra,0x1
    4c12:	cd2080e7          	jalr	-814(ra) # 58e0 <open>
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	cb2080e7          	jalr	-846(ra) # 58c8 <close>
      close(open(file, 0));
    4c1e:	4581                	li	a1,0
    4c20:	fa840513          	addi	a0,s0,-88
    4c24:	00001097          	auipc	ra,0x1
    4c28:	cbc080e7          	jalr	-836(ra) # 58e0 <open>
    4c2c:	00001097          	auipc	ra,0x1
    4c30:	c9c080e7          	jalr	-868(ra) # 58c8 <close>
      close(open(file, 0));
    4c34:	4581                	li	a1,0
    4c36:	fa840513          	addi	a0,s0,-88
    4c3a:	00001097          	auipc	ra,0x1
    4c3e:	ca6080e7          	jalr	-858(ra) # 58e0 <open>
    4c42:	00001097          	auipc	ra,0x1
    4c46:	c86080e7          	jalr	-890(ra) # 58c8 <close>
    if(pid == 0)
    4c4a:	08090363          	beqz	s2,4cd0 <concreate+0x2d0>
      wait(0);
    4c4e:	4501                	li	a0,0
    4c50:	00001097          	auipc	ra,0x1
    4c54:	c58080e7          	jalr	-936(ra) # 58a8 <wait>
  for(i = 0; i < N; i++){
    4c58:	2485                	addiw	s1,s1,1
    4c5a:	0f448563          	beq	s1,s4,4d44 <concreate+0x344>
    file[1] = '0' + i;
    4c5e:	0304879b          	addiw	a5,s1,48
    4c62:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4c66:	00001097          	auipc	ra,0x1
    4c6a:	c32080e7          	jalr	-974(ra) # 5898 <fork>
    4c6e:	892a                	mv	s2,a0
    if(pid < 0){
    4c70:	f2054de3          	bltz	a0,4baa <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4c74:	0354e73b          	remw	a4,s1,s5
    4c78:	00a767b3          	or	a5,a4,a0
    4c7c:	2781                	sext.w	a5,a5
    4c7e:	d7a1                	beqz	a5,4bc6 <concreate+0x1c6>
    4c80:	01671363          	bne	a4,s6,4c86 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4c84:	f129                	bnez	a0,4bc6 <concreate+0x1c6>
      unlink(file);
    4c86:	fa840513          	addi	a0,s0,-88
    4c8a:	00001097          	auipc	ra,0x1
    4c8e:	c66080e7          	jalr	-922(ra) # 58f0 <unlink>
      unlink(file);
    4c92:	fa840513          	addi	a0,s0,-88
    4c96:	00001097          	auipc	ra,0x1
    4c9a:	c5a080e7          	jalr	-934(ra) # 58f0 <unlink>
      unlink(file);
    4c9e:	fa840513          	addi	a0,s0,-88
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	c4e080e7          	jalr	-946(ra) # 58f0 <unlink>
      unlink(file);
    4caa:	fa840513          	addi	a0,s0,-88
    4cae:	00001097          	auipc	ra,0x1
    4cb2:	c42080e7          	jalr	-958(ra) # 58f0 <unlink>
      unlink(file);
    4cb6:	fa840513          	addi	a0,s0,-88
    4cba:	00001097          	auipc	ra,0x1
    4cbe:	c36080e7          	jalr	-970(ra) # 58f0 <unlink>
      unlink(file);
    4cc2:	fa840513          	addi	a0,s0,-88
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	c2a080e7          	jalr	-982(ra) # 58f0 <unlink>
    4cce:	bfb5                	j	4c4a <concreate+0x24a>
      exit(0);
    4cd0:	4501                	li	a0,0
    4cd2:	00001097          	auipc	ra,0x1
    4cd6:	bce080e7          	jalr	-1074(ra) # 58a0 <exit>
      close(fd);
    4cda:	00001097          	auipc	ra,0x1
    4cde:	bee080e7          	jalr	-1042(ra) # 58c8 <close>
    if(pid == 0) {
    4ce2:	bb65                	j	4a9a <concreate+0x9a>
      close(fd);
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	be4080e7          	jalr	-1052(ra) # 58c8 <close>
      wait(&xstatus);
    4cec:	f6c40513          	addi	a0,s0,-148
    4cf0:	00001097          	auipc	ra,0x1
    4cf4:	bb8080e7          	jalr	-1096(ra) # 58a8 <wait>
      if(xstatus != 0)
    4cf8:	f6c42483          	lw	s1,-148(s0)
    4cfc:	da0494e3          	bnez	s1,4aa4 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4d00:	2905                	addiw	s2,s2,1
    4d02:	db4906e3          	beq	s2,s4,4aae <concreate+0xae>
    file[1] = '0' + i;
    4d06:	0309079b          	addiw	a5,s2,48
    4d0a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4d0e:	fa840513          	addi	a0,s0,-88
    4d12:	00001097          	auipc	ra,0x1
    4d16:	bde080e7          	jalr	-1058(ra) # 58f0 <unlink>
    pid = fork();
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	b7e080e7          	jalr	-1154(ra) # 5898 <fork>
    if(pid && (i % 3) == 1){
    4d22:	d20503e3          	beqz	a0,4a48 <concreate+0x48>
    4d26:	036967bb          	remw	a5,s2,s6
    4d2a:	d15787e3          	beq	a5,s5,4a38 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4d2e:	20200593          	li	a1,514
    4d32:	fa840513          	addi	a0,s0,-88
    4d36:	00001097          	auipc	ra,0x1
    4d3a:	baa080e7          	jalr	-1110(ra) # 58e0 <open>
      if(fd < 0){
    4d3e:	fa0553e3          	bgez	a0,4ce4 <concreate+0x2e4>
    4d42:	b31d                	j	4a68 <concreate+0x68>
}
    4d44:	60ea                	ld	ra,152(sp)
    4d46:	644a                	ld	s0,144(sp)
    4d48:	64aa                	ld	s1,136(sp)
    4d4a:	690a                	ld	s2,128(sp)
    4d4c:	79e6                	ld	s3,120(sp)
    4d4e:	7a46                	ld	s4,112(sp)
    4d50:	7aa6                	ld	s5,104(sp)
    4d52:	7b06                	ld	s6,96(sp)
    4d54:	6be6                	ld	s7,88(sp)
    4d56:	610d                	addi	sp,sp,160
    4d58:	8082                	ret

0000000000004d5a <bigfile>:
{
    4d5a:	7139                	addi	sp,sp,-64
    4d5c:	fc06                	sd	ra,56(sp)
    4d5e:	f822                	sd	s0,48(sp)
    4d60:	f426                	sd	s1,40(sp)
    4d62:	f04a                	sd	s2,32(sp)
    4d64:	ec4e                	sd	s3,24(sp)
    4d66:	e852                	sd	s4,16(sp)
    4d68:	e456                	sd	s5,8(sp)
    4d6a:	0080                	addi	s0,sp,64
    4d6c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4d6e:	00003517          	auipc	a0,0x3
    4d72:	22a50513          	addi	a0,a0,554 # 7f98 <malloc+0x22a8>
    4d76:	00001097          	auipc	ra,0x1
    4d7a:	b7a080e7          	jalr	-1158(ra) # 58f0 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4d7e:	20200593          	li	a1,514
    4d82:	00003517          	auipc	a0,0x3
    4d86:	21650513          	addi	a0,a0,534 # 7f98 <malloc+0x22a8>
    4d8a:	00001097          	auipc	ra,0x1
    4d8e:	b56080e7          	jalr	-1194(ra) # 58e0 <open>
    4d92:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4d94:	4481                	li	s1,0
    memset(buf, i, SZ);
    4d96:	00007917          	auipc	s2,0x7
    4d9a:	06290913          	addi	s2,s2,98 # bdf8 <buf>
  for(i = 0; i < N; i++){
    4d9e:	4a51                	li	s4,20
  if(fd < 0){
    4da0:	0a054063          	bltz	a0,4e40 <bigfile+0xe6>
    memset(buf, i, SZ);
    4da4:	25800613          	li	a2,600
    4da8:	85a6                	mv	a1,s1
    4daa:	854a                	mv	a0,s2
    4dac:	00001097          	auipc	ra,0x1
    4db0:	8de080e7          	jalr	-1826(ra) # 568a <memset>
    if(write(fd, buf, SZ) != SZ){
    4db4:	25800613          	li	a2,600
    4db8:	85ca                	mv	a1,s2
    4dba:	854e                	mv	a0,s3
    4dbc:	00001097          	auipc	ra,0x1
    4dc0:	b04080e7          	jalr	-1276(ra) # 58c0 <write>
    4dc4:	25800793          	li	a5,600
    4dc8:	08f51a63          	bne	a0,a5,4e5c <bigfile+0x102>
  for(i = 0; i < N; i++){
    4dcc:	2485                	addiw	s1,s1,1
    4dce:	fd449be3          	bne	s1,s4,4da4 <bigfile+0x4a>
  close(fd);
    4dd2:	854e                	mv	a0,s3
    4dd4:	00001097          	auipc	ra,0x1
    4dd8:	af4080e7          	jalr	-1292(ra) # 58c8 <close>
  fd = open("bigfile.dat", 0);
    4ddc:	4581                	li	a1,0
    4dde:	00003517          	auipc	a0,0x3
    4de2:	1ba50513          	addi	a0,a0,442 # 7f98 <malloc+0x22a8>
    4de6:	00001097          	auipc	ra,0x1
    4dea:	afa080e7          	jalr	-1286(ra) # 58e0 <open>
    4dee:	8a2a                	mv	s4,a0
  total = 0;
    4df0:	4981                	li	s3,0
  for(i = 0; ; i++){
    4df2:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4df4:	00007917          	auipc	s2,0x7
    4df8:	00490913          	addi	s2,s2,4 # bdf8 <buf>
  if(fd < 0){
    4dfc:	06054e63          	bltz	a0,4e78 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4e00:	12c00613          	li	a2,300
    4e04:	85ca                	mv	a1,s2
    4e06:	8552                	mv	a0,s4
    4e08:	00001097          	auipc	ra,0x1
    4e0c:	ab0080e7          	jalr	-1360(ra) # 58b8 <read>
    if(cc < 0){
    4e10:	08054263          	bltz	a0,4e94 <bigfile+0x13a>
    if(cc == 0)
    4e14:	c971                	beqz	a0,4ee8 <bigfile+0x18e>
    if(cc != SZ/2){
    4e16:	12c00793          	li	a5,300
    4e1a:	08f51b63          	bne	a0,a5,4eb0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4e1e:	01f4d79b          	srliw	a5,s1,0x1f
    4e22:	9fa5                	addw	a5,a5,s1
    4e24:	4017d79b          	sraiw	a5,a5,0x1
    4e28:	00094703          	lbu	a4,0(s2)
    4e2c:	0af71063          	bne	a4,a5,4ecc <bigfile+0x172>
    4e30:	12b94703          	lbu	a4,299(s2)
    4e34:	08f71c63          	bne	a4,a5,4ecc <bigfile+0x172>
    total += cc;
    4e38:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4e3c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4e3e:	b7c9                	j	4e00 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4e40:	85d6                	mv	a1,s5
    4e42:	00003517          	auipc	a0,0x3
    4e46:	16650513          	addi	a0,a0,358 # 7fa8 <malloc+0x22b8>
    4e4a:	00001097          	auipc	ra,0x1
    4e4e:	de6080e7          	jalr	-538(ra) # 5c30 <printf>
    exit(1);
    4e52:	4505                	li	a0,1
    4e54:	00001097          	auipc	ra,0x1
    4e58:	a4c080e7          	jalr	-1460(ra) # 58a0 <exit>
      printf("%s: write bigfile failed\n", s);
    4e5c:	85d6                	mv	a1,s5
    4e5e:	00003517          	auipc	a0,0x3
    4e62:	16a50513          	addi	a0,a0,362 # 7fc8 <malloc+0x22d8>
    4e66:	00001097          	auipc	ra,0x1
    4e6a:	dca080e7          	jalr	-566(ra) # 5c30 <printf>
      exit(1);
    4e6e:	4505                	li	a0,1
    4e70:	00001097          	auipc	ra,0x1
    4e74:	a30080e7          	jalr	-1488(ra) # 58a0 <exit>
    printf("%s: cannot open bigfile\n", s);
    4e78:	85d6                	mv	a1,s5
    4e7a:	00003517          	auipc	a0,0x3
    4e7e:	16e50513          	addi	a0,a0,366 # 7fe8 <malloc+0x22f8>
    4e82:	00001097          	auipc	ra,0x1
    4e86:	dae080e7          	jalr	-594(ra) # 5c30 <printf>
    exit(1);
    4e8a:	4505                	li	a0,1
    4e8c:	00001097          	auipc	ra,0x1
    4e90:	a14080e7          	jalr	-1516(ra) # 58a0 <exit>
      printf("%s: read bigfile failed\n", s);
    4e94:	85d6                	mv	a1,s5
    4e96:	00003517          	auipc	a0,0x3
    4e9a:	17250513          	addi	a0,a0,370 # 8008 <malloc+0x2318>
    4e9e:	00001097          	auipc	ra,0x1
    4ea2:	d92080e7          	jalr	-622(ra) # 5c30 <printf>
      exit(1);
    4ea6:	4505                	li	a0,1
    4ea8:	00001097          	auipc	ra,0x1
    4eac:	9f8080e7          	jalr	-1544(ra) # 58a0 <exit>
      printf("%s: short read bigfile\n", s);
    4eb0:	85d6                	mv	a1,s5
    4eb2:	00003517          	auipc	a0,0x3
    4eb6:	17650513          	addi	a0,a0,374 # 8028 <malloc+0x2338>
    4eba:	00001097          	auipc	ra,0x1
    4ebe:	d76080e7          	jalr	-650(ra) # 5c30 <printf>
      exit(1);
    4ec2:	4505                	li	a0,1
    4ec4:	00001097          	auipc	ra,0x1
    4ec8:	9dc080e7          	jalr	-1572(ra) # 58a0 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4ecc:	85d6                	mv	a1,s5
    4ece:	00003517          	auipc	a0,0x3
    4ed2:	17250513          	addi	a0,a0,370 # 8040 <malloc+0x2350>
    4ed6:	00001097          	auipc	ra,0x1
    4eda:	d5a080e7          	jalr	-678(ra) # 5c30 <printf>
      exit(1);
    4ede:	4505                	li	a0,1
    4ee0:	00001097          	auipc	ra,0x1
    4ee4:	9c0080e7          	jalr	-1600(ra) # 58a0 <exit>
  close(fd);
    4ee8:	8552                	mv	a0,s4
    4eea:	00001097          	auipc	ra,0x1
    4eee:	9de080e7          	jalr	-1570(ra) # 58c8 <close>
  if(total != N*SZ){
    4ef2:	678d                	lui	a5,0x3
    4ef4:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0xda>
    4ef8:	02f99363          	bne	s3,a5,4f1e <bigfile+0x1c4>
  unlink("bigfile.dat");
    4efc:	00003517          	auipc	a0,0x3
    4f00:	09c50513          	addi	a0,a0,156 # 7f98 <malloc+0x22a8>
    4f04:	00001097          	auipc	ra,0x1
    4f08:	9ec080e7          	jalr	-1556(ra) # 58f0 <unlink>
}
    4f0c:	70e2                	ld	ra,56(sp)
    4f0e:	7442                	ld	s0,48(sp)
    4f10:	74a2                	ld	s1,40(sp)
    4f12:	7902                	ld	s2,32(sp)
    4f14:	69e2                	ld	s3,24(sp)
    4f16:	6a42                	ld	s4,16(sp)
    4f18:	6aa2                	ld	s5,8(sp)
    4f1a:	6121                	addi	sp,sp,64
    4f1c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4f1e:	85d6                	mv	a1,s5
    4f20:	00003517          	auipc	a0,0x3
    4f24:	14050513          	addi	a0,a0,320 # 8060 <malloc+0x2370>
    4f28:	00001097          	auipc	ra,0x1
    4f2c:	d08080e7          	jalr	-760(ra) # 5c30 <printf>
    exit(1);
    4f30:	4505                	li	a0,1
    4f32:	00001097          	auipc	ra,0x1
    4f36:	96e080e7          	jalr	-1682(ra) # 58a0 <exit>

0000000000004f3a <fsfull>:
{
    4f3a:	7171                	addi	sp,sp,-176
    4f3c:	f506                	sd	ra,168(sp)
    4f3e:	f122                	sd	s0,160(sp)
    4f40:	ed26                	sd	s1,152(sp)
    4f42:	e94a                	sd	s2,144(sp)
    4f44:	e54e                	sd	s3,136(sp)
    4f46:	e152                	sd	s4,128(sp)
    4f48:	fcd6                	sd	s5,120(sp)
    4f4a:	f8da                	sd	s6,112(sp)
    4f4c:	f4de                	sd	s7,104(sp)
    4f4e:	f0e2                	sd	s8,96(sp)
    4f50:	ece6                	sd	s9,88(sp)
    4f52:	e8ea                	sd	s10,80(sp)
    4f54:	e4ee                	sd	s11,72(sp)
    4f56:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4f58:	00003517          	auipc	a0,0x3
    4f5c:	12850513          	addi	a0,a0,296 # 8080 <malloc+0x2390>
    4f60:	00001097          	auipc	ra,0x1
    4f64:	cd0080e7          	jalr	-816(ra) # 5c30 <printf>
  for(nfiles = 0; ; nfiles++){
    4f68:	4481                	li	s1,0
    name[0] = 'f';
    4f6a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f6e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f72:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f76:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4f78:	00003c97          	auipc	s9,0x3
    4f7c:	118c8c93          	addi	s9,s9,280 # 8090 <malloc+0x23a0>
    int total = 0;
    4f80:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4f82:	00007a17          	auipc	s4,0x7
    4f86:	e76a0a13          	addi	s4,s4,-394 # bdf8 <buf>
    name[0] = 'f';
    4f8a:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f8e:	0384c7bb          	divw	a5,s1,s8
    4f92:	0307879b          	addiw	a5,a5,48
    4f96:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f9a:	0384e7bb          	remw	a5,s1,s8
    4f9e:	0377c7bb          	divw	a5,a5,s7
    4fa2:	0307879b          	addiw	a5,a5,48
    4fa6:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4faa:	0374e7bb          	remw	a5,s1,s7
    4fae:	0367c7bb          	divw	a5,a5,s6
    4fb2:	0307879b          	addiw	a5,a5,48
    4fb6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4fba:	0364e7bb          	remw	a5,s1,s6
    4fbe:	0307879b          	addiw	a5,a5,48
    4fc2:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4fc6:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4fca:	f5040593          	addi	a1,s0,-176
    4fce:	8566                	mv	a0,s9
    4fd0:	00001097          	auipc	ra,0x1
    4fd4:	c60080e7          	jalr	-928(ra) # 5c30 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4fd8:	20200593          	li	a1,514
    4fdc:	f5040513          	addi	a0,s0,-176
    4fe0:	00001097          	auipc	ra,0x1
    4fe4:	900080e7          	jalr	-1792(ra) # 58e0 <open>
    4fe8:	89aa                	mv	s3,a0
    if(fd < 0){
    4fea:	0a055663          	bgez	a0,5096 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4fee:	f5040593          	addi	a1,s0,-176
    4ff2:	00003517          	auipc	a0,0x3
    4ff6:	0ae50513          	addi	a0,a0,174 # 80a0 <malloc+0x23b0>
    4ffa:	00001097          	auipc	ra,0x1
    4ffe:	c36080e7          	jalr	-970(ra) # 5c30 <printf>
  while(nfiles >= 0){
    5002:	0604c363          	bltz	s1,5068 <fsfull+0x12e>
    name[0] = 'f';
    5006:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    500a:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    500e:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5012:	4929                	li	s2,10
  while(nfiles >= 0){
    5014:	5afd                	li	s5,-1
    name[0] = 'f';
    5016:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    501a:	0344c7bb          	divw	a5,s1,s4
    501e:	0307879b          	addiw	a5,a5,48
    5022:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5026:	0344e7bb          	remw	a5,s1,s4
    502a:	0337c7bb          	divw	a5,a5,s3
    502e:	0307879b          	addiw	a5,a5,48
    5032:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5036:	0334e7bb          	remw	a5,s1,s3
    503a:	0327c7bb          	divw	a5,a5,s2
    503e:	0307879b          	addiw	a5,a5,48
    5042:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5046:	0324e7bb          	remw	a5,s1,s2
    504a:	0307879b          	addiw	a5,a5,48
    504e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5052:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5056:	f5040513          	addi	a0,s0,-176
    505a:	00001097          	auipc	ra,0x1
    505e:	896080e7          	jalr	-1898(ra) # 58f0 <unlink>
    nfiles--;
    5062:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5064:	fb5499e3          	bne	s1,s5,5016 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5068:	00003517          	auipc	a0,0x3
    506c:	05850513          	addi	a0,a0,88 # 80c0 <malloc+0x23d0>
    5070:	00001097          	auipc	ra,0x1
    5074:	bc0080e7          	jalr	-1088(ra) # 5c30 <printf>
}
    5078:	70aa                	ld	ra,168(sp)
    507a:	740a                	ld	s0,160(sp)
    507c:	64ea                	ld	s1,152(sp)
    507e:	694a                	ld	s2,144(sp)
    5080:	69aa                	ld	s3,136(sp)
    5082:	6a0a                	ld	s4,128(sp)
    5084:	7ae6                	ld	s5,120(sp)
    5086:	7b46                	ld	s6,112(sp)
    5088:	7ba6                	ld	s7,104(sp)
    508a:	7c06                	ld	s8,96(sp)
    508c:	6ce6                	ld	s9,88(sp)
    508e:	6d46                	ld	s10,80(sp)
    5090:	6da6                	ld	s11,72(sp)
    5092:	614d                	addi	sp,sp,176
    5094:	8082                	ret
    int total = 0;
    5096:	896e                	mv	s2,s11
      if(cc < BSIZE)
    5098:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    509c:	40000613          	li	a2,1024
    50a0:	85d2                	mv	a1,s4
    50a2:	854e                	mv	a0,s3
    50a4:	00001097          	auipc	ra,0x1
    50a8:	81c080e7          	jalr	-2020(ra) # 58c0 <write>
      if(cc < BSIZE)
    50ac:	00aad563          	bge	s5,a0,50b6 <fsfull+0x17c>
      total += cc;
    50b0:	00a9093b          	addw	s2,s2,a0
    while(1){
    50b4:	b7e5                	j	509c <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    50b6:	85ca                	mv	a1,s2
    50b8:	00003517          	auipc	a0,0x3
    50bc:	ff850513          	addi	a0,a0,-8 # 80b0 <malloc+0x23c0>
    50c0:	00001097          	auipc	ra,0x1
    50c4:	b70080e7          	jalr	-1168(ra) # 5c30 <printf>
    close(fd);
    50c8:	854e                	mv	a0,s3
    50ca:	00000097          	auipc	ra,0x0
    50ce:	7fe080e7          	jalr	2046(ra) # 58c8 <close>
    if(total == 0)
    50d2:	f20908e3          	beqz	s2,5002 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    50d6:	2485                	addiw	s1,s1,1
    50d8:	bd4d                	j	4f8a <fsfull+0x50>

00000000000050da <badwrite>:
{
    50da:	7179                	addi	sp,sp,-48
    50dc:	f406                	sd	ra,40(sp)
    50de:	f022                	sd	s0,32(sp)
    50e0:	ec26                	sd	s1,24(sp)
    50e2:	e84a                	sd	s2,16(sp)
    50e4:	e44e                	sd	s3,8(sp)
    50e6:	e052                	sd	s4,0(sp)
    50e8:	1800                	addi	s0,sp,48
  unlink("junk");
    50ea:	00003517          	auipc	a0,0x3
    50ee:	fee50513          	addi	a0,a0,-18 # 80d8 <malloc+0x23e8>
    50f2:	00000097          	auipc	ra,0x0
    50f6:	7fe080e7          	jalr	2046(ra) # 58f0 <unlink>
    50fa:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    50fe:	00003997          	auipc	s3,0x3
    5102:	fda98993          	addi	s3,s3,-38 # 80d8 <malloc+0x23e8>
    write(fd, (char*)0xffffffffffL, 1);
    5106:	5a7d                	li	s4,-1
    5108:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    510c:	20100593          	li	a1,513
    5110:	854e                	mv	a0,s3
    5112:	00000097          	auipc	ra,0x0
    5116:	7ce080e7          	jalr	1998(ra) # 58e0 <open>
    511a:	84aa                	mv	s1,a0
    if(fd < 0){
    511c:	06054b63          	bltz	a0,5192 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    5120:	4605                	li	a2,1
    5122:	85d2                	mv	a1,s4
    5124:	00000097          	auipc	ra,0x0
    5128:	79c080e7          	jalr	1948(ra) # 58c0 <write>
    close(fd);
    512c:	8526                	mv	a0,s1
    512e:	00000097          	auipc	ra,0x0
    5132:	79a080e7          	jalr	1946(ra) # 58c8 <close>
    unlink("junk");
    5136:	854e                	mv	a0,s3
    5138:	00000097          	auipc	ra,0x0
    513c:	7b8080e7          	jalr	1976(ra) # 58f0 <unlink>
  for(int i = 0; i < assumed_free; i++){
    5140:	397d                	addiw	s2,s2,-1
    5142:	fc0915e3          	bnez	s2,510c <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    5146:	20100593          	li	a1,513
    514a:	00003517          	auipc	a0,0x3
    514e:	f8e50513          	addi	a0,a0,-114 # 80d8 <malloc+0x23e8>
    5152:	00000097          	auipc	ra,0x0
    5156:	78e080e7          	jalr	1934(ra) # 58e0 <open>
    515a:	84aa                	mv	s1,a0
  if(fd < 0){
    515c:	04054863          	bltz	a0,51ac <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    5160:	4605                	li	a2,1
    5162:	00001597          	auipc	a1,0x1
    5166:	12e58593          	addi	a1,a1,302 # 6290 <malloc+0x5a0>
    516a:	00000097          	auipc	ra,0x0
    516e:	756080e7          	jalr	1878(ra) # 58c0 <write>
    5172:	4785                	li	a5,1
    5174:	04f50963          	beq	a0,a5,51c6 <badwrite+0xec>
    printf("write failed\n");
    5178:	00003517          	auipc	a0,0x3
    517c:	f8050513          	addi	a0,a0,-128 # 80f8 <malloc+0x2408>
    5180:	00001097          	auipc	ra,0x1
    5184:	ab0080e7          	jalr	-1360(ra) # 5c30 <printf>
    exit(1);
    5188:	4505                	li	a0,1
    518a:	00000097          	auipc	ra,0x0
    518e:	716080e7          	jalr	1814(ra) # 58a0 <exit>
      printf("open junk failed\n");
    5192:	00003517          	auipc	a0,0x3
    5196:	f4e50513          	addi	a0,a0,-178 # 80e0 <malloc+0x23f0>
    519a:	00001097          	auipc	ra,0x1
    519e:	a96080e7          	jalr	-1386(ra) # 5c30 <printf>
      exit(1);
    51a2:	4505                	li	a0,1
    51a4:	00000097          	auipc	ra,0x0
    51a8:	6fc080e7          	jalr	1788(ra) # 58a0 <exit>
    printf("open junk failed\n");
    51ac:	00003517          	auipc	a0,0x3
    51b0:	f3450513          	addi	a0,a0,-204 # 80e0 <malloc+0x23f0>
    51b4:	00001097          	auipc	ra,0x1
    51b8:	a7c080e7          	jalr	-1412(ra) # 5c30 <printf>
    exit(1);
    51bc:	4505                	li	a0,1
    51be:	00000097          	auipc	ra,0x0
    51c2:	6e2080e7          	jalr	1762(ra) # 58a0 <exit>
  close(fd);
    51c6:	8526                	mv	a0,s1
    51c8:	00000097          	auipc	ra,0x0
    51cc:	700080e7          	jalr	1792(ra) # 58c8 <close>
  unlink("junk");
    51d0:	00003517          	auipc	a0,0x3
    51d4:	f0850513          	addi	a0,a0,-248 # 80d8 <malloc+0x23e8>
    51d8:	00000097          	auipc	ra,0x0
    51dc:	718080e7          	jalr	1816(ra) # 58f0 <unlink>
  exit(0);
    51e0:	4501                	li	a0,0
    51e2:	00000097          	auipc	ra,0x0
    51e6:	6be080e7          	jalr	1726(ra) # 58a0 <exit>

00000000000051ea <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    51ea:	7139                	addi	sp,sp,-64
    51ec:	fc06                	sd	ra,56(sp)
    51ee:	f822                	sd	s0,48(sp)
    51f0:	f426                	sd	s1,40(sp)
    51f2:	f04a                	sd	s2,32(sp)
    51f4:	ec4e                	sd	s3,24(sp)
    51f6:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    51f8:	fc840513          	addi	a0,s0,-56
    51fc:	00000097          	auipc	ra,0x0
    5200:	6b4080e7          	jalr	1716(ra) # 58b0 <pipe>
    5204:	06054863          	bltz	a0,5274 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5208:	00000097          	auipc	ra,0x0
    520c:	690080e7          	jalr	1680(ra) # 5898 <fork>

  if(pid < 0){
    5210:	06054f63          	bltz	a0,528e <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5214:	ed59                	bnez	a0,52b2 <countfree+0xc8>
    close(fds[0]);
    5216:	fc842503          	lw	a0,-56(s0)
    521a:	00000097          	auipc	ra,0x0
    521e:	6ae080e7          	jalr	1710(ra) # 58c8 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5222:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5224:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5226:	00001917          	auipc	s2,0x1
    522a:	06a90913          	addi	s2,s2,106 # 6290 <malloc+0x5a0>
      uint64 a = (uint64) sbrk(4096);
    522e:	6505                	lui	a0,0x1
    5230:	00000097          	auipc	ra,0x0
    5234:	6f8080e7          	jalr	1784(ra) # 5928 <sbrk>
      if(a == 0xffffffffffffffff){
    5238:	06950863          	beq	a0,s1,52a8 <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    523c:	6785                	lui	a5,0x1
    523e:	97aa                	add	a5,a5,a0
    5240:	ff378fa3          	sb	s3,-1(a5) # fff <bigdir+0x8b>
      if(write(fds[1], "x", 1) != 1){
    5244:	4605                	li	a2,1
    5246:	85ca                	mv	a1,s2
    5248:	fcc42503          	lw	a0,-52(s0)
    524c:	00000097          	auipc	ra,0x0
    5250:	674080e7          	jalr	1652(ra) # 58c0 <write>
    5254:	4785                	li	a5,1
    5256:	fcf50ce3          	beq	a0,a5,522e <countfree+0x44>
        printf("write() failed in countfree()\n");
    525a:	00003517          	auipc	a0,0x3
    525e:	eee50513          	addi	a0,a0,-274 # 8148 <malloc+0x2458>
    5262:	00001097          	auipc	ra,0x1
    5266:	9ce080e7          	jalr	-1586(ra) # 5c30 <printf>
        exit(1);
    526a:	4505                	li	a0,1
    526c:	00000097          	auipc	ra,0x0
    5270:	634080e7          	jalr	1588(ra) # 58a0 <exit>
    printf("pipe() failed in countfree()\n");
    5274:	00003517          	auipc	a0,0x3
    5278:	e9450513          	addi	a0,a0,-364 # 8108 <malloc+0x2418>
    527c:	00001097          	auipc	ra,0x1
    5280:	9b4080e7          	jalr	-1612(ra) # 5c30 <printf>
    exit(1);
    5284:	4505                	li	a0,1
    5286:	00000097          	auipc	ra,0x0
    528a:	61a080e7          	jalr	1562(ra) # 58a0 <exit>
    printf("fork failed in countfree()\n");
    528e:	00003517          	auipc	a0,0x3
    5292:	e9a50513          	addi	a0,a0,-358 # 8128 <malloc+0x2438>
    5296:	00001097          	auipc	ra,0x1
    529a:	99a080e7          	jalr	-1638(ra) # 5c30 <printf>
    exit(1);
    529e:	4505                	li	a0,1
    52a0:	00000097          	auipc	ra,0x0
    52a4:	600080e7          	jalr	1536(ra) # 58a0 <exit>
      }
    }

    exit(0);
    52a8:	4501                	li	a0,0
    52aa:	00000097          	auipc	ra,0x0
    52ae:	5f6080e7          	jalr	1526(ra) # 58a0 <exit>
  }

  close(fds[1]);
    52b2:	fcc42503          	lw	a0,-52(s0)
    52b6:	00000097          	auipc	ra,0x0
    52ba:	612080e7          	jalr	1554(ra) # 58c8 <close>

  int n = 0;
    52be:	4481                	li	s1,0
    52c0:	a839                	j	52de <countfree+0xf4>
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    if(cc < 0){
      printf("read() failed in countfree()\n");
    52c2:	00003517          	auipc	a0,0x3
    52c6:	ea650513          	addi	a0,a0,-346 # 8168 <malloc+0x2478>
    52ca:	00001097          	auipc	ra,0x1
    52ce:	966080e7          	jalr	-1690(ra) # 5c30 <printf>
      exit(1);
    52d2:	4505                	li	a0,1
    52d4:	00000097          	auipc	ra,0x0
    52d8:	5cc080e7          	jalr	1484(ra) # 58a0 <exit>
    }
    if(cc == 0)
      break;
    n += 1;
    52dc:	2485                	addiw	s1,s1,1
    int cc = read(fds[0], &c, 1);
    52de:	4605                	li	a2,1
    52e0:	fc740593          	addi	a1,s0,-57
    52e4:	fc842503          	lw	a0,-56(s0)
    52e8:	00000097          	auipc	ra,0x0
    52ec:	5d0080e7          	jalr	1488(ra) # 58b8 <read>
    if(cc < 0){
    52f0:	fc0549e3          	bltz	a0,52c2 <countfree+0xd8>
    if(cc == 0)
    52f4:	f565                	bnez	a0,52dc <countfree+0xf2>
  }

  close(fds[0]);
    52f6:	fc842503          	lw	a0,-56(s0)
    52fa:	00000097          	auipc	ra,0x0
    52fe:	5ce080e7          	jalr	1486(ra) # 58c8 <close>
  wait((int*)0);
    5302:	4501                	li	a0,0
    5304:	00000097          	auipc	ra,0x0
    5308:	5a4080e7          	jalr	1444(ra) # 58a8 <wait>
  
  return n;
}
    530c:	8526                	mv	a0,s1
    530e:	70e2                	ld	ra,56(sp)
    5310:	7442                	ld	s0,48(sp)
    5312:	74a2                	ld	s1,40(sp)
    5314:	7902                	ld	s2,32(sp)
    5316:	69e2                	ld	s3,24(sp)
    5318:	6121                	addi	sp,sp,64
    531a:	8082                	ret

000000000000531c <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    531c:	7179                	addi	sp,sp,-48
    531e:	f406                	sd	ra,40(sp)
    5320:	f022                	sd	s0,32(sp)
    5322:	ec26                	sd	s1,24(sp)
    5324:	e84a                	sd	s2,16(sp)
    5326:	1800                	addi	s0,sp,48
    5328:	84aa                	mv	s1,a0
    532a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    532c:	00003517          	auipc	a0,0x3
    5330:	e5c50513          	addi	a0,a0,-420 # 8188 <malloc+0x2498>
    5334:	00001097          	auipc	ra,0x1
    5338:	8fc080e7          	jalr	-1796(ra) # 5c30 <printf>
  if((pid = fork()) < 0) {
    533c:	00000097          	auipc	ra,0x0
    5340:	55c080e7          	jalr	1372(ra) # 5898 <fork>
    5344:	02054e63          	bltz	a0,5380 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5348:	c929                	beqz	a0,539a <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    534a:	fdc40513          	addi	a0,s0,-36
    534e:	00000097          	auipc	ra,0x0
    5352:	55a080e7          	jalr	1370(ra) # 58a8 <wait>
    if(xstatus != 0) 
    5356:	fdc42783          	lw	a5,-36(s0)
    535a:	c7b9                	beqz	a5,53a8 <run+0x8c>
      printf("FAILED\n");
    535c:	00003517          	auipc	a0,0x3
    5360:	e5450513          	addi	a0,a0,-428 # 81b0 <malloc+0x24c0>
    5364:	00001097          	auipc	ra,0x1
    5368:	8cc080e7          	jalr	-1844(ra) # 5c30 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    536c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5370:	00153513          	seqz	a0,a0
    5374:	70a2                	ld	ra,40(sp)
    5376:	7402                	ld	s0,32(sp)
    5378:	64e2                	ld	s1,24(sp)
    537a:	6942                	ld	s2,16(sp)
    537c:	6145                	addi	sp,sp,48
    537e:	8082                	ret
    printf("runtest: fork error\n");
    5380:	00003517          	auipc	a0,0x3
    5384:	e1850513          	addi	a0,a0,-488 # 8198 <malloc+0x24a8>
    5388:	00001097          	auipc	ra,0x1
    538c:	8a8080e7          	jalr	-1880(ra) # 5c30 <printf>
    exit(1);
    5390:	4505                	li	a0,1
    5392:	00000097          	auipc	ra,0x0
    5396:	50e080e7          	jalr	1294(ra) # 58a0 <exit>
    f(s);
    539a:	854a                	mv	a0,s2
    539c:	9482                	jalr	s1
    exit(0);
    539e:	4501                	li	a0,0
    53a0:	00000097          	auipc	ra,0x0
    53a4:	500080e7          	jalr	1280(ra) # 58a0 <exit>
      printf("OK\n");
    53a8:	00003517          	auipc	a0,0x3
    53ac:	e1050513          	addi	a0,a0,-496 # 81b8 <malloc+0x24c8>
    53b0:	00001097          	auipc	ra,0x1
    53b4:	880080e7          	jalr	-1920(ra) # 5c30 <printf>
    53b8:	bf55                	j	536c <run+0x50>

00000000000053ba <main>:

int
main(int argc, char *argv[])
{
    53ba:	bd010113          	addi	sp,sp,-1072
    53be:	42113423          	sd	ra,1064(sp)
    53c2:	42813023          	sd	s0,1056(sp)
    53c6:	40913c23          	sd	s1,1048(sp)
    53ca:	41213823          	sd	s2,1040(sp)
    53ce:	41313423          	sd	s3,1032(sp)
    53d2:	41413023          	sd	s4,1024(sp)
    53d6:	3f513c23          	sd	s5,1016(sp)
    53da:	3f613823          	sd	s6,1008(sp)
    53de:	43010413          	addi	s0,sp,1072
    53e2:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    53e4:	4789                	li	a5,2
    53e6:	0af50063          	beq	a0,a5,5486 <main+0xcc>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    53ea:	4785                	li	a5,1
    53ec:	0ca7cb63          	blt	a5,a0,54c2 <main+0x108>
  char *justone = 0;
    53f0:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    53f2:	00001797          	auipc	a5,0x1
    53f6:	a0678793          	addi	a5,a5,-1530 # 5df8 <malloc+0x108>
    53fa:	bd040713          	addi	a4,s0,-1072
    53fe:	00001317          	auipc	t1,0x1
    5402:	dea30313          	addi	t1,t1,-534 # 61e8 <malloc+0x4f8>
    5406:	0007b883          	ld	a7,0(a5)
    540a:	0087b803          	ld	a6,8(a5)
    540e:	6b88                	ld	a0,16(a5)
    5410:	6f8c                	ld	a1,24(a5)
    5412:	7390                	ld	a2,32(a5)
    5414:	7794                	ld	a3,40(a5)
    5416:	01173023          	sd	a7,0(a4)
    541a:	01073423          	sd	a6,8(a4)
    541e:	eb08                	sd	a0,16(a4)
    5420:	ef0c                	sd	a1,24(a4)
    5422:	f310                	sd	a2,32(a4)
    5424:	f714                	sd	a3,40(a4)
    5426:	03078793          	addi	a5,a5,48
    542a:	03070713          	addi	a4,a4,48
    542e:	fc679ce3          	bne	a5,t1,5406 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5432:	00003517          	auipc	a0,0x3
    5436:	e3e50513          	addi	a0,a0,-450 # 8270 <malloc+0x2580>
    543a:	00000097          	auipc	ra,0x0
    543e:	7f6080e7          	jalr	2038(ra) # 5c30 <printf>
  int free0 = countfree();
    5442:	00000097          	auipc	ra,0x0
    5446:	da8080e7          	jalr	-600(ra) # 51ea <countfree>
    544a:	8b2a                	mv	s6,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    544c:	bd843903          	ld	s2,-1064(s0)
    5450:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    5454:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5456:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5458:	0a091a63          	bnez	s2,550c <main+0x152>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    545c:	00000097          	auipc	ra,0x0
    5460:	d8e080e7          	jalr	-626(ra) # 51ea <countfree>
    5464:	85aa                	mv	a1,a0
    5466:	0f655463          	bge	a0,s6,554e <main+0x194>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    546a:	865a                	mv	a2,s6
    546c:	00003517          	auipc	a0,0x3
    5470:	dbc50513          	addi	a0,a0,-580 # 8228 <malloc+0x2538>
    5474:	00000097          	auipc	ra,0x0
    5478:	7bc080e7          	jalr	1980(ra) # 5c30 <printf>
    exit(1);
    547c:	4505                	li	a0,1
    547e:	00000097          	auipc	ra,0x0
    5482:	422080e7          	jalr	1058(ra) # 58a0 <exit>
    5486:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5488:	00003597          	auipc	a1,0x3
    548c:	d3858593          	addi	a1,a1,-712 # 81c0 <malloc+0x24d0>
    5490:	6488                	ld	a0,8(s1)
    5492:	00000097          	auipc	ra,0x0
    5496:	19a080e7          	jalr	410(ra) # 562c <strcmp>
    549a:	10050863          	beqz	a0,55aa <main+0x1f0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    549e:	00003597          	auipc	a1,0x3
    54a2:	e0a58593          	addi	a1,a1,-502 # 82a8 <malloc+0x25b8>
    54a6:	6488                	ld	a0,8(s1)
    54a8:	00000097          	auipc	ra,0x0
    54ac:	184080e7          	jalr	388(ra) # 562c <strcmp>
    54b0:	cd75                	beqz	a0,55ac <main+0x1f2>
  } else if(argc == 2 && argv[1][0] != '-'){
    54b2:	0084b983          	ld	s3,8(s1)
    54b6:	0009c703          	lbu	a4,0(s3)
    54ba:	02d00793          	li	a5,45
    54be:	f2f71ae3          	bne	a4,a5,53f2 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    54c2:	00003517          	auipc	a0,0x3
    54c6:	d0650513          	addi	a0,a0,-762 # 81c8 <malloc+0x24d8>
    54ca:	00000097          	auipc	ra,0x0
    54ce:	766080e7          	jalr	1894(ra) # 5c30 <printf>
    exit(1);
    54d2:	4505                	li	a0,1
    54d4:	00000097          	auipc	ra,0x0
    54d8:	3cc080e7          	jalr	972(ra) # 58a0 <exit>
          exit(1);
    54dc:	4505                	li	a0,1
    54de:	00000097          	auipc	ra,0x0
    54e2:	3c2080e7          	jalr	962(ra) # 58a0 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    54e6:	40a905bb          	subw	a1,s2,a0
    54ea:	855a                	mv	a0,s6
    54ec:	00000097          	auipc	ra,0x0
    54f0:	744080e7          	jalr	1860(ra) # 5c30 <printf>
        if(continuous != 2)
    54f4:	09498763          	beq	s3,s4,5582 <main+0x1c8>
          exit(1);
    54f8:	4505                	li	a0,1
    54fa:	00000097          	auipc	ra,0x0
    54fe:	3a6080e7          	jalr	934(ra) # 58a0 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5502:	04c1                	addi	s1,s1,16
    5504:	0084b903          	ld	s2,8(s1)
    5508:	02090463          	beqz	s2,5530 <main+0x176>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    550c:	00098963          	beqz	s3,551e <main+0x164>
    5510:	85ce                	mv	a1,s3
    5512:	854a                	mv	a0,s2
    5514:	00000097          	auipc	ra,0x0
    5518:	118080e7          	jalr	280(ra) # 562c <strcmp>
    551c:	f17d                	bnez	a0,5502 <main+0x148>
      if(!run(t->f, t->s))
    551e:	85ca                	mv	a1,s2
    5520:	6088                	ld	a0,0(s1)
    5522:	00000097          	auipc	ra,0x0
    5526:	dfa080e7          	jalr	-518(ra) # 531c <run>
    552a:	fd61                	bnez	a0,5502 <main+0x148>
        fail = 1;
    552c:	8a56                	mv	s4,s5
    552e:	bfd1                	j	5502 <main+0x148>
  if(fail){
    5530:	f20a06e3          	beqz	s4,545c <main+0xa2>
    printf("SOME TESTS FAILED\n");
    5534:	00003517          	auipc	a0,0x3
    5538:	cdc50513          	addi	a0,a0,-804 # 8210 <malloc+0x2520>
    553c:	00000097          	auipc	ra,0x0
    5540:	6f4080e7          	jalr	1780(ra) # 5c30 <printf>
    exit(1);
    5544:	4505                	li	a0,1
    5546:	00000097          	auipc	ra,0x0
    554a:	35a080e7          	jalr	858(ra) # 58a0 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    554e:	00003517          	auipc	a0,0x3
    5552:	d0a50513          	addi	a0,a0,-758 # 8258 <malloc+0x2568>
    5556:	00000097          	auipc	ra,0x0
    555a:	6da080e7          	jalr	1754(ra) # 5c30 <printf>
    exit(0);
    555e:	4501                	li	a0,0
    5560:	00000097          	auipc	ra,0x0
    5564:	340080e7          	jalr	832(ra) # 58a0 <exit>
        printf("SOME TESTS FAILED\n");
    5568:	8556                	mv	a0,s5
    556a:	00000097          	auipc	ra,0x0
    556e:	6c6080e7          	jalr	1734(ra) # 5c30 <printf>
        if(continuous != 2)
    5572:	f74995e3          	bne	s3,s4,54dc <main+0x122>
      int free1 = countfree();
    5576:	00000097          	auipc	ra,0x0
    557a:	c74080e7          	jalr	-908(ra) # 51ea <countfree>
      if(free1 < free0){
    557e:	f72544e3          	blt	a0,s2,54e6 <main+0x12c>
      int free0 = countfree();
    5582:	00000097          	auipc	ra,0x0
    5586:	c68080e7          	jalr	-920(ra) # 51ea <countfree>
    558a:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    558c:	bd843583          	ld	a1,-1064(s0)
    5590:	d1fd                	beqz	a1,5576 <main+0x1bc>
    5592:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    5596:	6088                	ld	a0,0(s1)
    5598:	00000097          	auipc	ra,0x0
    559c:	d84080e7          	jalr	-636(ra) # 531c <run>
    55a0:	d561                	beqz	a0,5568 <main+0x1ae>
      for (struct test *t = tests; t->s != 0; t++) {
    55a2:	04c1                	addi	s1,s1,16
    55a4:	648c                	ld	a1,8(s1)
    55a6:	f9e5                	bnez	a1,5596 <main+0x1dc>
    55a8:	b7f9                	j	5576 <main+0x1bc>
    continuous = 1;
    55aa:	4985                	li	s3,1
  } tests[] = {
    55ac:	00001797          	auipc	a5,0x1
    55b0:	84c78793          	addi	a5,a5,-1972 # 5df8 <malloc+0x108>
    55b4:	bd040713          	addi	a4,s0,-1072
    55b8:	00001317          	auipc	t1,0x1
    55bc:	c3030313          	addi	t1,t1,-976 # 61e8 <malloc+0x4f8>
    55c0:	0007b883          	ld	a7,0(a5)
    55c4:	0087b803          	ld	a6,8(a5)
    55c8:	6b88                	ld	a0,16(a5)
    55ca:	6f8c                	ld	a1,24(a5)
    55cc:	7390                	ld	a2,32(a5)
    55ce:	7794                	ld	a3,40(a5)
    55d0:	01173023          	sd	a7,0(a4)
    55d4:	01073423          	sd	a6,8(a4)
    55d8:	eb08                	sd	a0,16(a4)
    55da:	ef0c                	sd	a1,24(a4)
    55dc:	f310                	sd	a2,32(a4)
    55de:	f714                	sd	a3,40(a4)
    55e0:	03078793          	addi	a5,a5,48
    55e4:	03070713          	addi	a4,a4,48
    55e8:	fc679ce3          	bne	a5,t1,55c0 <main+0x206>
    printf("continuous usertests starting\n");
    55ec:	00003517          	auipc	a0,0x3
    55f0:	c9c50513          	addi	a0,a0,-868 # 8288 <malloc+0x2598>
    55f4:	00000097          	auipc	ra,0x0
    55f8:	63c080e7          	jalr	1596(ra) # 5c30 <printf>
        printf("SOME TESTS FAILED\n");
    55fc:	00003a97          	auipc	s5,0x3
    5600:	c14a8a93          	addi	s5,s5,-1004 # 8210 <malloc+0x2520>
        if(continuous != 2)
    5604:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5606:	00003b17          	auipc	s6,0x3
    560a:	beab0b13          	addi	s6,s6,-1046 # 81f0 <malloc+0x2500>
    560e:	bf95                	j	5582 <main+0x1c8>

0000000000005610 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5610:	1141                	addi	sp,sp,-16
    5612:	e422                	sd	s0,8(sp)
    5614:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5616:	87aa                	mv	a5,a0
    5618:	0585                	addi	a1,a1,1
    561a:	0785                	addi	a5,a5,1
    561c:	fff5c703          	lbu	a4,-1(a1)
    5620:	fee78fa3          	sb	a4,-1(a5)
    5624:	fb75                	bnez	a4,5618 <strcpy+0x8>
    ;
  return os;
}
    5626:	6422                	ld	s0,8(sp)
    5628:	0141                	addi	sp,sp,16
    562a:	8082                	ret

000000000000562c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    562c:	1141                	addi	sp,sp,-16
    562e:	e422                	sd	s0,8(sp)
    5630:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5632:	00054783          	lbu	a5,0(a0)
    5636:	cf91                	beqz	a5,5652 <strcmp+0x26>
    5638:	0005c703          	lbu	a4,0(a1)
    563c:	00f71b63          	bne	a4,a5,5652 <strcmp+0x26>
    p++, q++;
    5640:	0505                	addi	a0,a0,1
    5642:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5644:	00054783          	lbu	a5,0(a0)
    5648:	c789                	beqz	a5,5652 <strcmp+0x26>
    564a:	0005c703          	lbu	a4,0(a1)
    564e:	fef709e3          	beq	a4,a5,5640 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    5652:	0005c503          	lbu	a0,0(a1)
}
    5656:	40a7853b          	subw	a0,a5,a0
    565a:	6422                	ld	s0,8(sp)
    565c:	0141                	addi	sp,sp,16
    565e:	8082                	ret

0000000000005660 <strlen>:

uint
strlen(const char *s)
{
    5660:	1141                	addi	sp,sp,-16
    5662:	e422                	sd	s0,8(sp)
    5664:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5666:	00054783          	lbu	a5,0(a0)
    566a:	cf91                	beqz	a5,5686 <strlen+0x26>
    566c:	0505                	addi	a0,a0,1
    566e:	87aa                	mv	a5,a0
    5670:	4685                	li	a3,1
    5672:	9e89                	subw	a3,a3,a0
    5674:	00f6853b          	addw	a0,a3,a5
    5678:	0785                	addi	a5,a5,1
    567a:	fff7c703          	lbu	a4,-1(a5)
    567e:	fb7d                	bnez	a4,5674 <strlen+0x14>
    ;
  return n;
}
    5680:	6422                	ld	s0,8(sp)
    5682:	0141                	addi	sp,sp,16
    5684:	8082                	ret
  for(n = 0; s[n]; n++)
    5686:	4501                	li	a0,0
    5688:	bfe5                	j	5680 <strlen+0x20>

000000000000568a <memset>:

void*
memset(void *dst, int c, uint n)
{
    568a:	1141                	addi	sp,sp,-16
    568c:	e422                	sd	s0,8(sp)
    568e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5690:	ce09                	beqz	a2,56aa <memset+0x20>
    5692:	87aa                	mv	a5,a0
    5694:	fff6071b          	addiw	a4,a2,-1
    5698:	1702                	slli	a4,a4,0x20
    569a:	9301                	srli	a4,a4,0x20
    569c:	0705                	addi	a4,a4,1
    569e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    56a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    56a4:	0785                	addi	a5,a5,1
    56a6:	fee79de3          	bne	a5,a4,56a0 <memset+0x16>
  }
  return dst;
}
    56aa:	6422                	ld	s0,8(sp)
    56ac:	0141                	addi	sp,sp,16
    56ae:	8082                	ret

00000000000056b0 <strchr>:

char*
strchr(const char *s, char c)
{
    56b0:	1141                	addi	sp,sp,-16
    56b2:	e422                	sd	s0,8(sp)
    56b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
    56b6:	00054783          	lbu	a5,0(a0)
    56ba:	cf91                	beqz	a5,56d6 <strchr+0x26>
    if(*s == c)
    56bc:	00f58a63          	beq	a1,a5,56d0 <strchr+0x20>
  for(; *s; s++)
    56c0:	0505                	addi	a0,a0,1
    56c2:	00054783          	lbu	a5,0(a0)
    56c6:	c781                	beqz	a5,56ce <strchr+0x1e>
    if(*s == c)
    56c8:	feb79ce3          	bne	a5,a1,56c0 <strchr+0x10>
    56cc:	a011                	j	56d0 <strchr+0x20>
      return (char*)s;
  return 0;
    56ce:	4501                	li	a0,0
}
    56d0:	6422                	ld	s0,8(sp)
    56d2:	0141                	addi	sp,sp,16
    56d4:	8082                	ret
  return 0;
    56d6:	4501                	li	a0,0
    56d8:	bfe5                	j	56d0 <strchr+0x20>

00000000000056da <gets>:

char*
gets(char *buf, int max)
{
    56da:	711d                	addi	sp,sp,-96
    56dc:	ec86                	sd	ra,88(sp)
    56de:	e8a2                	sd	s0,80(sp)
    56e0:	e4a6                	sd	s1,72(sp)
    56e2:	e0ca                	sd	s2,64(sp)
    56e4:	fc4e                	sd	s3,56(sp)
    56e6:	f852                	sd	s4,48(sp)
    56e8:	f456                	sd	s5,40(sp)
    56ea:	f05a                	sd	s6,32(sp)
    56ec:	ec5e                	sd	s7,24(sp)
    56ee:	1080                	addi	s0,sp,96
    56f0:	8baa                	mv	s7,a0
    56f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    56f4:	892a                	mv	s2,a0
    56f6:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    56f8:	4aa9                	li	s5,10
    56fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    56fc:	0019849b          	addiw	s1,s3,1
    5700:	0344d863          	bge	s1,s4,5730 <gets+0x56>
    cc = read(0, &c, 1);
    5704:	4605                	li	a2,1
    5706:	faf40593          	addi	a1,s0,-81
    570a:	4501                	li	a0,0
    570c:	00000097          	auipc	ra,0x0
    5710:	1ac080e7          	jalr	428(ra) # 58b8 <read>
    if(cc < 1)
    5714:	00a05e63          	blez	a0,5730 <gets+0x56>
    buf[i++] = c;
    5718:	faf44783          	lbu	a5,-81(s0)
    571c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5720:	01578763          	beq	a5,s5,572e <gets+0x54>
    5724:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
    5726:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
    5728:	fd679ae3          	bne	a5,s6,56fc <gets+0x22>
    572c:	a011                	j	5730 <gets+0x56>
  for(i=0; i+1 < max; ){
    572e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5730:	99de                	add	s3,s3,s7
    5732:	00098023          	sb	zero,0(s3)
  return buf;
}
    5736:	855e                	mv	a0,s7
    5738:	60e6                	ld	ra,88(sp)
    573a:	6446                	ld	s0,80(sp)
    573c:	64a6                	ld	s1,72(sp)
    573e:	6906                	ld	s2,64(sp)
    5740:	79e2                	ld	s3,56(sp)
    5742:	7a42                	ld	s4,48(sp)
    5744:	7aa2                	ld	s5,40(sp)
    5746:	7b02                	ld	s6,32(sp)
    5748:	6be2                	ld	s7,24(sp)
    574a:	6125                	addi	sp,sp,96
    574c:	8082                	ret

000000000000574e <stat>:

int
stat(const char *n, struct stat *st)
{
    574e:	1101                	addi	sp,sp,-32
    5750:	ec06                	sd	ra,24(sp)
    5752:	e822                	sd	s0,16(sp)
    5754:	e426                	sd	s1,8(sp)
    5756:	e04a                	sd	s2,0(sp)
    5758:	1000                	addi	s0,sp,32
    575a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    575c:	4581                	li	a1,0
    575e:	00000097          	auipc	ra,0x0
    5762:	182080e7          	jalr	386(ra) # 58e0 <open>
  if(fd < 0)
    5766:	02054563          	bltz	a0,5790 <stat+0x42>
    576a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    576c:	85ca                	mv	a1,s2
    576e:	00000097          	auipc	ra,0x0
    5772:	18a080e7          	jalr	394(ra) # 58f8 <fstat>
    5776:	892a                	mv	s2,a0
  close(fd);
    5778:	8526                	mv	a0,s1
    577a:	00000097          	auipc	ra,0x0
    577e:	14e080e7          	jalr	334(ra) # 58c8 <close>
  return r;
}
    5782:	854a                	mv	a0,s2
    5784:	60e2                	ld	ra,24(sp)
    5786:	6442                	ld	s0,16(sp)
    5788:	64a2                	ld	s1,8(sp)
    578a:	6902                	ld	s2,0(sp)
    578c:	6105                	addi	sp,sp,32
    578e:	8082                	ret
    return -1;
    5790:	597d                	li	s2,-1
    5792:	bfc5                	j	5782 <stat+0x34>

0000000000005794 <atoi>:

int
atoi(const char *s)
{
    5794:	1141                	addi	sp,sp,-16
    5796:	e422                	sd	s0,8(sp)
    5798:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    579a:	00054683          	lbu	a3,0(a0)
    579e:	fd06879b          	addiw	a5,a3,-48
    57a2:	0ff7f793          	andi	a5,a5,255
    57a6:	4725                	li	a4,9
    57a8:	02f76963          	bltu	a4,a5,57da <atoi+0x46>
    57ac:	862a                	mv	a2,a0
  n = 0;
    57ae:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    57b0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    57b2:	0605                	addi	a2,a2,1
    57b4:	0025179b          	slliw	a5,a0,0x2
    57b8:	9fa9                	addw	a5,a5,a0
    57ba:	0017979b          	slliw	a5,a5,0x1
    57be:	9fb5                	addw	a5,a5,a3
    57c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    57c4:	00064683          	lbu	a3,0(a2) # 3000 <iputtest+0x56>
    57c8:	fd06871b          	addiw	a4,a3,-48
    57cc:	0ff77713          	andi	a4,a4,255
    57d0:	fee5f1e3          	bgeu	a1,a4,57b2 <atoi+0x1e>
  return n;
}
    57d4:	6422                	ld	s0,8(sp)
    57d6:	0141                	addi	sp,sp,16
    57d8:	8082                	ret
  n = 0;
    57da:	4501                	li	a0,0
    57dc:	bfe5                	j	57d4 <atoi+0x40>

00000000000057de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    57de:	1141                	addi	sp,sp,-16
    57e0:	e422                	sd	s0,8(sp)
    57e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    57e4:	02b57663          	bgeu	a0,a1,5810 <memmove+0x32>
    while(n-- > 0)
    57e8:	02c05163          	blez	a2,580a <memmove+0x2c>
    57ec:	fff6079b          	addiw	a5,a2,-1
    57f0:	1782                	slli	a5,a5,0x20
    57f2:	9381                	srli	a5,a5,0x20
    57f4:	0785                	addi	a5,a5,1
    57f6:	97aa                	add	a5,a5,a0
  dst = vdst;
    57f8:	872a                	mv	a4,a0
      *dst++ = *src++;
    57fa:	0585                	addi	a1,a1,1
    57fc:	0705                	addi	a4,a4,1
    57fe:	fff5c683          	lbu	a3,-1(a1)
    5802:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5806:	fee79ae3          	bne	a5,a4,57fa <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    580a:	6422                	ld	s0,8(sp)
    580c:	0141                	addi	sp,sp,16
    580e:	8082                	ret
    dst += n;
    5810:	00c50733          	add	a4,a0,a2
    src += n;
    5814:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5816:	fec05ae3          	blez	a2,580a <memmove+0x2c>
    581a:	fff6079b          	addiw	a5,a2,-1
    581e:	1782                	slli	a5,a5,0x20
    5820:	9381                	srli	a5,a5,0x20
    5822:	fff7c793          	not	a5,a5
    5826:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5828:	15fd                	addi	a1,a1,-1
    582a:	177d                	addi	a4,a4,-1
    582c:	0005c683          	lbu	a3,0(a1)
    5830:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5834:	fef71ae3          	bne	a4,a5,5828 <memmove+0x4a>
    5838:	bfc9                	j	580a <memmove+0x2c>

000000000000583a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    583a:	1141                	addi	sp,sp,-16
    583c:	e422                	sd	s0,8(sp)
    583e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5840:	ce15                	beqz	a2,587c <memcmp+0x42>
    5842:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
    5846:	00054783          	lbu	a5,0(a0)
    584a:	0005c703          	lbu	a4,0(a1)
    584e:	02e79063          	bne	a5,a4,586e <memcmp+0x34>
    5852:	1682                	slli	a3,a3,0x20
    5854:	9281                	srli	a3,a3,0x20
    5856:	0685                	addi	a3,a3,1
    5858:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
    585a:	0505                	addi	a0,a0,1
    p2++;
    585c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    585e:	00d50d63          	beq	a0,a3,5878 <memcmp+0x3e>
    if (*p1 != *p2) {
    5862:	00054783          	lbu	a5,0(a0)
    5866:	0005c703          	lbu	a4,0(a1)
    586a:	fee788e3          	beq	a5,a4,585a <memcmp+0x20>
      return *p1 - *p2;
    586e:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
    5872:	6422                	ld	s0,8(sp)
    5874:	0141                	addi	sp,sp,16
    5876:	8082                	ret
  return 0;
    5878:	4501                	li	a0,0
    587a:	bfe5                	j	5872 <memcmp+0x38>
    587c:	4501                	li	a0,0
    587e:	bfd5                	j	5872 <memcmp+0x38>

0000000000005880 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5880:	1141                	addi	sp,sp,-16
    5882:	e406                	sd	ra,8(sp)
    5884:	e022                	sd	s0,0(sp)
    5886:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5888:	00000097          	auipc	ra,0x0
    588c:	f56080e7          	jalr	-170(ra) # 57de <memmove>
}
    5890:	60a2                	ld	ra,8(sp)
    5892:	6402                	ld	s0,0(sp)
    5894:	0141                	addi	sp,sp,16
    5896:	8082                	ret

0000000000005898 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5898:	4885                	li	a7,1
 ecall
    589a:	00000073          	ecall
 ret
    589e:	8082                	ret

00000000000058a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    58a0:	4889                	li	a7,2
 ecall
    58a2:	00000073          	ecall
 ret
    58a6:	8082                	ret

00000000000058a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
    58a8:	488d                	li	a7,3
 ecall
    58aa:	00000073          	ecall
 ret
    58ae:	8082                	ret

00000000000058b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    58b0:	4891                	li	a7,4
 ecall
    58b2:	00000073          	ecall
 ret
    58b6:	8082                	ret

00000000000058b8 <read>:
.global read
read:
 li a7, SYS_read
    58b8:	4895                	li	a7,5
 ecall
    58ba:	00000073          	ecall
 ret
    58be:	8082                	ret

00000000000058c0 <write>:
.global write
write:
 li a7, SYS_write
    58c0:	48c1                	li	a7,16
 ecall
    58c2:	00000073          	ecall
 ret
    58c6:	8082                	ret

00000000000058c8 <close>:
.global close
close:
 li a7, SYS_close
    58c8:	48d5                	li	a7,21
 ecall
    58ca:	00000073          	ecall
 ret
    58ce:	8082                	ret

00000000000058d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    58d0:	4899                	li	a7,6
 ecall
    58d2:	00000073          	ecall
 ret
    58d6:	8082                	ret

00000000000058d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    58d8:	489d                	li	a7,7
 ecall
    58da:	00000073          	ecall
 ret
    58de:	8082                	ret

00000000000058e0 <open>:
.global open
open:
 li a7, SYS_open
    58e0:	48bd                	li	a7,15
 ecall
    58e2:	00000073          	ecall
 ret
    58e6:	8082                	ret

00000000000058e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    58e8:	48c5                	li	a7,17
 ecall
    58ea:	00000073          	ecall
 ret
    58ee:	8082                	ret

00000000000058f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    58f0:	48c9                	li	a7,18
 ecall
    58f2:	00000073          	ecall
 ret
    58f6:	8082                	ret

00000000000058f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    58f8:	48a1                	li	a7,8
 ecall
    58fa:	00000073          	ecall
 ret
    58fe:	8082                	ret

0000000000005900 <link>:
.global link
link:
 li a7, SYS_link
    5900:	48cd                	li	a7,19
 ecall
    5902:	00000073          	ecall
 ret
    5906:	8082                	ret

0000000000005908 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5908:	48d1                	li	a7,20
 ecall
    590a:	00000073          	ecall
 ret
    590e:	8082                	ret

0000000000005910 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5910:	48a5                	li	a7,9
 ecall
    5912:	00000073          	ecall
 ret
    5916:	8082                	ret

0000000000005918 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5918:	48a9                	li	a7,10
 ecall
    591a:	00000073          	ecall
 ret
    591e:	8082                	ret

0000000000005920 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5920:	48ad                	li	a7,11
 ecall
    5922:	00000073          	ecall
 ret
    5926:	8082                	ret

0000000000005928 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5928:	48b1                	li	a7,12
 ecall
    592a:	00000073          	ecall
 ret
    592e:	8082                	ret

0000000000005930 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5930:	48b5                	li	a7,13
 ecall
    5932:	00000073          	ecall
 ret
    5936:	8082                	ret

0000000000005938 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5938:	48b9                	li	a7,14
 ecall
    593a:	00000073          	ecall
 ret
    593e:	8082                	ret

0000000000005940 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5940:	48d9                	li	a7,22
 ecall
    5942:	00000073          	ecall
 ret
    5946:	8082                	ret

0000000000005948 <trace>:
.global trace
trace:
 li a7, SYS_trace
    5948:	48dd                	li	a7,23
 ecall
    594a:	00000073          	ecall
 ret
    594e:	8082                	ret

0000000000005950 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
    5950:	48e1                	li	a7,24
 ecall
    5952:	00000073          	ecall
 ret
    5956:	8082                	ret

0000000000005958 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5958:	1101                	addi	sp,sp,-32
    595a:	ec06                	sd	ra,24(sp)
    595c:	e822                	sd	s0,16(sp)
    595e:	1000                	addi	s0,sp,32
    5960:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5964:	4605                	li	a2,1
    5966:	fef40593          	addi	a1,s0,-17
    596a:	00000097          	auipc	ra,0x0
    596e:	f56080e7          	jalr	-170(ra) # 58c0 <write>
}
    5972:	60e2                	ld	ra,24(sp)
    5974:	6442                	ld	s0,16(sp)
    5976:	6105                	addi	sp,sp,32
    5978:	8082                	ret

000000000000597a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    597a:	7139                	addi	sp,sp,-64
    597c:	fc06                	sd	ra,56(sp)
    597e:	f822                	sd	s0,48(sp)
    5980:	f426                	sd	s1,40(sp)
    5982:	f04a                	sd	s2,32(sp)
    5984:	ec4e                	sd	s3,24(sp)
    5986:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5988:	c299                	beqz	a3,598e <printint+0x14>
    598a:	0005cd63          	bltz	a1,59a4 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    598e:	2581                	sext.w	a1,a1
  neg = 0;
    5990:	4301                	li	t1,0
    5992:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
    5996:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
    5998:	2601                	sext.w	a2,a2
    599a:	00003897          	auipc	a7,0x3
    599e:	c1688893          	addi	a7,a7,-1002 # 85b0 <digits>
    59a2:	a801                	j	59b2 <printint+0x38>
    x = -xx;
    59a4:	40b005bb          	negw	a1,a1
    59a8:	2581                	sext.w	a1,a1
    neg = 1;
    59aa:	4305                	li	t1,1
    x = -xx;
    59ac:	b7dd                	j	5992 <printint+0x18>
  }while((x /= base) != 0);
    59ae:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
    59b0:	8836                	mv	a6,a3
    59b2:	0018069b          	addiw	a3,a6,1
    59b6:	02c5f7bb          	remuw	a5,a1,a2
    59ba:	1782                	slli	a5,a5,0x20
    59bc:	9381                	srli	a5,a5,0x20
    59be:	97c6                	add	a5,a5,a7
    59c0:	0007c783          	lbu	a5,0(a5)
    59c4:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
    59c8:	0705                	addi	a4,a4,1
    59ca:	02c5d7bb          	divuw	a5,a1,a2
    59ce:	fec5f0e3          	bgeu	a1,a2,59ae <printint+0x34>
  if(neg)
    59d2:	00030b63          	beqz	t1,59e8 <printint+0x6e>
    buf[i++] = '-';
    59d6:	fd040793          	addi	a5,s0,-48
    59da:	96be                	add	a3,a3,a5
    59dc:	02d00793          	li	a5,45
    59e0:	fef68823          	sb	a5,-16(a3) # ff0 <bigdir+0x7c>
    59e4:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
    59e8:	02d05963          	blez	a3,5a1a <printint+0xa0>
    59ec:	89aa                	mv	s3,a0
    59ee:	fc040793          	addi	a5,s0,-64
    59f2:	00d784b3          	add	s1,a5,a3
    59f6:	fff78913          	addi	s2,a5,-1
    59fa:	9936                	add	s2,s2,a3
    59fc:	36fd                	addiw	a3,a3,-1
    59fe:	1682                	slli	a3,a3,0x20
    5a00:	9281                	srli	a3,a3,0x20
    5a02:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
    5a06:	fff4c583          	lbu	a1,-1(s1)
    5a0a:	854e                	mv	a0,s3
    5a0c:	00000097          	auipc	ra,0x0
    5a10:	f4c080e7          	jalr	-180(ra) # 5958 <putc>
  while(--i >= 0)
    5a14:	14fd                	addi	s1,s1,-1
    5a16:	ff2498e3          	bne	s1,s2,5a06 <printint+0x8c>
}
    5a1a:	70e2                	ld	ra,56(sp)
    5a1c:	7442                	ld	s0,48(sp)
    5a1e:	74a2                	ld	s1,40(sp)
    5a20:	7902                	ld	s2,32(sp)
    5a22:	69e2                	ld	s3,24(sp)
    5a24:	6121                	addi	sp,sp,64
    5a26:	8082                	ret

0000000000005a28 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5a28:	7119                	addi	sp,sp,-128
    5a2a:	fc86                	sd	ra,120(sp)
    5a2c:	f8a2                	sd	s0,112(sp)
    5a2e:	f4a6                	sd	s1,104(sp)
    5a30:	f0ca                	sd	s2,96(sp)
    5a32:	ecce                	sd	s3,88(sp)
    5a34:	e8d2                	sd	s4,80(sp)
    5a36:	e4d6                	sd	s5,72(sp)
    5a38:	e0da                	sd	s6,64(sp)
    5a3a:	fc5e                	sd	s7,56(sp)
    5a3c:	f862                	sd	s8,48(sp)
    5a3e:	f466                	sd	s9,40(sp)
    5a40:	f06a                	sd	s10,32(sp)
    5a42:	ec6e                	sd	s11,24(sp)
    5a44:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5a46:	0005c483          	lbu	s1,0(a1)
    5a4a:	18048d63          	beqz	s1,5be4 <vprintf+0x1bc>
    5a4e:	8aaa                	mv	s5,a0
    5a50:	8b32                	mv	s6,a2
    5a52:	00158913          	addi	s2,a1,1
  state = 0;
    5a56:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5a58:	02500a13          	li	s4,37
      if(c == 'd'){
    5a5c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5a60:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5a64:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5a68:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a6c:	00003b97          	auipc	s7,0x3
    5a70:	b44b8b93          	addi	s7,s7,-1212 # 85b0 <digits>
    5a74:	a839                	j	5a92 <vprintf+0x6a>
        putc(fd, c);
    5a76:	85a6                	mv	a1,s1
    5a78:	8556                	mv	a0,s5
    5a7a:	00000097          	auipc	ra,0x0
    5a7e:	ede080e7          	jalr	-290(ra) # 5958 <putc>
    5a82:	a019                	j	5a88 <vprintf+0x60>
    } else if(state == '%'){
    5a84:	01498f63          	beq	s3,s4,5aa2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5a88:	0905                	addi	s2,s2,1
    5a8a:	fff94483          	lbu	s1,-1(s2)
    5a8e:	14048b63          	beqz	s1,5be4 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
    5a92:	0004879b          	sext.w	a5,s1
    if(state == 0){
    5a96:	fe0997e3          	bnez	s3,5a84 <vprintf+0x5c>
      if(c == '%'){
    5a9a:	fd479ee3          	bne	a5,s4,5a76 <vprintf+0x4e>
        state = '%';
    5a9e:	89be                	mv	s3,a5
    5aa0:	b7e5                	j	5a88 <vprintf+0x60>
      if(c == 'd'){
    5aa2:	05878063          	beq	a5,s8,5ae2 <vprintf+0xba>
      } else if(c == 'l') {
    5aa6:	05978c63          	beq	a5,s9,5afe <vprintf+0xd6>
      } else if(c == 'x') {
    5aaa:	07a78863          	beq	a5,s10,5b1a <vprintf+0xf2>
      } else if(c == 'p') {
    5aae:	09b78463          	beq	a5,s11,5b36 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5ab2:	07300713          	li	a4,115
    5ab6:	0ce78563          	beq	a5,a4,5b80 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5aba:	06300713          	li	a4,99
    5abe:	0ee78c63          	beq	a5,a4,5bb6 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5ac2:	11478663          	beq	a5,s4,5bce <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5ac6:	85d2                	mv	a1,s4
    5ac8:	8556                	mv	a0,s5
    5aca:	00000097          	auipc	ra,0x0
    5ace:	e8e080e7          	jalr	-370(ra) # 5958 <putc>
        putc(fd, c);
    5ad2:	85a6                	mv	a1,s1
    5ad4:	8556                	mv	a0,s5
    5ad6:	00000097          	auipc	ra,0x0
    5ada:	e82080e7          	jalr	-382(ra) # 5958 <putc>
      }
      state = 0;
    5ade:	4981                	li	s3,0
    5ae0:	b765                	j	5a88 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5ae2:	008b0493          	addi	s1,s6,8
    5ae6:	4685                	li	a3,1
    5ae8:	4629                	li	a2,10
    5aea:	000b2583          	lw	a1,0(s6)
    5aee:	8556                	mv	a0,s5
    5af0:	00000097          	auipc	ra,0x0
    5af4:	e8a080e7          	jalr	-374(ra) # 597a <printint>
    5af8:	8b26                	mv	s6,s1
      state = 0;
    5afa:	4981                	li	s3,0
    5afc:	b771                	j	5a88 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5afe:	008b0493          	addi	s1,s6,8
    5b02:	4681                	li	a3,0
    5b04:	4629                	li	a2,10
    5b06:	000b2583          	lw	a1,0(s6)
    5b0a:	8556                	mv	a0,s5
    5b0c:	00000097          	auipc	ra,0x0
    5b10:	e6e080e7          	jalr	-402(ra) # 597a <printint>
    5b14:	8b26                	mv	s6,s1
      state = 0;
    5b16:	4981                	li	s3,0
    5b18:	bf85                	j	5a88 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5b1a:	008b0493          	addi	s1,s6,8
    5b1e:	4681                	li	a3,0
    5b20:	4641                	li	a2,16
    5b22:	000b2583          	lw	a1,0(s6)
    5b26:	8556                	mv	a0,s5
    5b28:	00000097          	auipc	ra,0x0
    5b2c:	e52080e7          	jalr	-430(ra) # 597a <printint>
    5b30:	8b26                	mv	s6,s1
      state = 0;
    5b32:	4981                	li	s3,0
    5b34:	bf91                	j	5a88 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5b36:	008b0793          	addi	a5,s6,8
    5b3a:	f8f43423          	sd	a5,-120(s0)
    5b3e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5b42:	03000593          	li	a1,48
    5b46:	8556                	mv	a0,s5
    5b48:	00000097          	auipc	ra,0x0
    5b4c:	e10080e7          	jalr	-496(ra) # 5958 <putc>
  putc(fd, 'x');
    5b50:	85ea                	mv	a1,s10
    5b52:	8556                	mv	a0,s5
    5b54:	00000097          	auipc	ra,0x0
    5b58:	e04080e7          	jalr	-508(ra) # 5958 <putc>
    5b5c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5b5e:	03c9d793          	srli	a5,s3,0x3c
    5b62:	97de                	add	a5,a5,s7
    5b64:	0007c583          	lbu	a1,0(a5)
    5b68:	8556                	mv	a0,s5
    5b6a:	00000097          	auipc	ra,0x0
    5b6e:	dee080e7          	jalr	-530(ra) # 5958 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b72:	0992                	slli	s3,s3,0x4
    5b74:	34fd                	addiw	s1,s1,-1
    5b76:	f4e5                	bnez	s1,5b5e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5b78:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5b7c:	4981                	li	s3,0
    5b7e:	b729                	j	5a88 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b80:	008b0993          	addi	s3,s6,8
    5b84:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    5b88:	c085                	beqz	s1,5ba8 <vprintf+0x180>
        while(*s != 0){
    5b8a:	0004c583          	lbu	a1,0(s1)
    5b8e:	c9a1                	beqz	a1,5bde <vprintf+0x1b6>
          putc(fd, *s);
    5b90:	8556                	mv	a0,s5
    5b92:	00000097          	auipc	ra,0x0
    5b96:	dc6080e7          	jalr	-570(ra) # 5958 <putc>
          s++;
    5b9a:	0485                	addi	s1,s1,1
        while(*s != 0){
    5b9c:	0004c583          	lbu	a1,0(s1)
    5ba0:	f9e5                	bnez	a1,5b90 <vprintf+0x168>
        s = va_arg(ap, char*);
    5ba2:	8b4e                	mv	s6,s3
      state = 0;
    5ba4:	4981                	li	s3,0
    5ba6:	b5cd                	j	5a88 <vprintf+0x60>
          s = "(null)";
    5ba8:	00003497          	auipc	s1,0x3
    5bac:	a2048493          	addi	s1,s1,-1504 # 85c8 <digits+0x18>
        while(*s != 0){
    5bb0:	02800593          	li	a1,40
    5bb4:	bff1                	j	5b90 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    5bb6:	008b0493          	addi	s1,s6,8
    5bba:	000b4583          	lbu	a1,0(s6)
    5bbe:	8556                	mv	a0,s5
    5bc0:	00000097          	auipc	ra,0x0
    5bc4:	d98080e7          	jalr	-616(ra) # 5958 <putc>
    5bc8:	8b26                	mv	s6,s1
      state = 0;
    5bca:	4981                	li	s3,0
    5bcc:	bd75                	j	5a88 <vprintf+0x60>
        putc(fd, c);
    5bce:	85d2                	mv	a1,s4
    5bd0:	8556                	mv	a0,s5
    5bd2:	00000097          	auipc	ra,0x0
    5bd6:	d86080e7          	jalr	-634(ra) # 5958 <putc>
      state = 0;
    5bda:	4981                	li	s3,0
    5bdc:	b575                	j	5a88 <vprintf+0x60>
        s = va_arg(ap, char*);
    5bde:	8b4e                	mv	s6,s3
      state = 0;
    5be0:	4981                	li	s3,0
    5be2:	b55d                	j	5a88 <vprintf+0x60>
    }
  }
}
    5be4:	70e6                	ld	ra,120(sp)
    5be6:	7446                	ld	s0,112(sp)
    5be8:	74a6                	ld	s1,104(sp)
    5bea:	7906                	ld	s2,96(sp)
    5bec:	69e6                	ld	s3,88(sp)
    5bee:	6a46                	ld	s4,80(sp)
    5bf0:	6aa6                	ld	s5,72(sp)
    5bf2:	6b06                	ld	s6,64(sp)
    5bf4:	7be2                	ld	s7,56(sp)
    5bf6:	7c42                	ld	s8,48(sp)
    5bf8:	7ca2                	ld	s9,40(sp)
    5bfa:	7d02                	ld	s10,32(sp)
    5bfc:	6de2                	ld	s11,24(sp)
    5bfe:	6109                	addi	sp,sp,128
    5c00:	8082                	ret

0000000000005c02 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5c02:	715d                	addi	sp,sp,-80
    5c04:	ec06                	sd	ra,24(sp)
    5c06:	e822                	sd	s0,16(sp)
    5c08:	1000                	addi	s0,sp,32
    5c0a:	e010                	sd	a2,0(s0)
    5c0c:	e414                	sd	a3,8(s0)
    5c0e:	e818                	sd	a4,16(s0)
    5c10:	ec1c                	sd	a5,24(s0)
    5c12:	03043023          	sd	a6,32(s0)
    5c16:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5c1a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5c1e:	8622                	mv	a2,s0
    5c20:	00000097          	auipc	ra,0x0
    5c24:	e08080e7          	jalr	-504(ra) # 5a28 <vprintf>
}
    5c28:	60e2                	ld	ra,24(sp)
    5c2a:	6442                	ld	s0,16(sp)
    5c2c:	6161                	addi	sp,sp,80
    5c2e:	8082                	ret

0000000000005c30 <printf>:

void
printf(const char *fmt, ...)
{
    5c30:	711d                	addi	sp,sp,-96
    5c32:	ec06                	sd	ra,24(sp)
    5c34:	e822                	sd	s0,16(sp)
    5c36:	1000                	addi	s0,sp,32
    5c38:	e40c                	sd	a1,8(s0)
    5c3a:	e810                	sd	a2,16(s0)
    5c3c:	ec14                	sd	a3,24(s0)
    5c3e:	f018                	sd	a4,32(s0)
    5c40:	f41c                	sd	a5,40(s0)
    5c42:	03043823          	sd	a6,48(s0)
    5c46:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5c4a:	00840613          	addi	a2,s0,8
    5c4e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5c52:	85aa                	mv	a1,a0
    5c54:	4505                	li	a0,1
    5c56:	00000097          	auipc	ra,0x0
    5c5a:	dd2080e7          	jalr	-558(ra) # 5a28 <vprintf>
}
    5c5e:	60e2                	ld	ra,24(sp)
    5c60:	6442                	ld	s0,16(sp)
    5c62:	6125                	addi	sp,sp,96
    5c64:	8082                	ret

0000000000005c66 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c66:	1141                	addi	sp,sp,-16
    5c68:	e422                	sd	s0,8(sp)
    5c6a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5c6c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c70:	00003797          	auipc	a5,0x3
    5c74:	96878793          	addi	a5,a5,-1688 # 85d8 <freep>
    5c78:	639c                	ld	a5,0(a5)
    5c7a:	a805                	j	5caa <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5c7c:	4618                	lw	a4,8(a2)
    5c7e:	9db9                	addw	a1,a1,a4
    5c80:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c84:	6398                	ld	a4,0(a5)
    5c86:	6318                	ld	a4,0(a4)
    5c88:	fee53823          	sd	a4,-16(a0)
    5c8c:	a091                	j	5cd0 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c8e:	ff852703          	lw	a4,-8(a0)
    5c92:	9e39                	addw	a2,a2,a4
    5c94:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5c96:	ff053703          	ld	a4,-16(a0)
    5c9a:	e398                	sd	a4,0(a5)
    5c9c:	a099                	j	5ce2 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c9e:	6398                	ld	a4,0(a5)
    5ca0:	00e7e463          	bltu	a5,a4,5ca8 <free+0x42>
    5ca4:	00e6ea63          	bltu	a3,a4,5cb8 <free+0x52>
{
    5ca8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5caa:	fed7fae3          	bgeu	a5,a3,5c9e <free+0x38>
    5cae:	6398                	ld	a4,0(a5)
    5cb0:	00e6e463          	bltu	a3,a4,5cb8 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5cb4:	fee7eae3          	bltu	a5,a4,5ca8 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    5cb8:	ff852583          	lw	a1,-8(a0)
    5cbc:	6390                	ld	a2,0(a5)
    5cbe:	02059713          	slli	a4,a1,0x20
    5cc2:	9301                	srli	a4,a4,0x20
    5cc4:	0712                	slli	a4,a4,0x4
    5cc6:	9736                	add	a4,a4,a3
    5cc8:	fae60ae3          	beq	a2,a4,5c7c <free+0x16>
    bp->s.ptr = p->s.ptr;
    5ccc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5cd0:	4790                	lw	a2,8(a5)
    5cd2:	02061713          	slli	a4,a2,0x20
    5cd6:	9301                	srli	a4,a4,0x20
    5cd8:	0712                	slli	a4,a4,0x4
    5cda:	973e                	add	a4,a4,a5
    5cdc:	fae689e3          	beq	a3,a4,5c8e <free+0x28>
  } else
    p->s.ptr = bp;
    5ce0:	e394                	sd	a3,0(a5)
  freep = p;
    5ce2:	00003717          	auipc	a4,0x3
    5ce6:	8ef73b23          	sd	a5,-1802(a4) # 85d8 <freep>
}
    5cea:	6422                	ld	s0,8(sp)
    5cec:	0141                	addi	sp,sp,16
    5cee:	8082                	ret

0000000000005cf0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5cf0:	7139                	addi	sp,sp,-64
    5cf2:	fc06                	sd	ra,56(sp)
    5cf4:	f822                	sd	s0,48(sp)
    5cf6:	f426                	sd	s1,40(sp)
    5cf8:	f04a                	sd	s2,32(sp)
    5cfa:	ec4e                	sd	s3,24(sp)
    5cfc:	e852                	sd	s4,16(sp)
    5cfe:	e456                	sd	s5,8(sp)
    5d00:	e05a                	sd	s6,0(sp)
    5d02:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5d04:	02051993          	slli	s3,a0,0x20
    5d08:	0209d993          	srli	s3,s3,0x20
    5d0c:	09bd                	addi	s3,s3,15
    5d0e:	0049d993          	srli	s3,s3,0x4
    5d12:	2985                	addiw	s3,s3,1
    5d14:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    5d18:	00003797          	auipc	a5,0x3
    5d1c:	8c078793          	addi	a5,a5,-1856 # 85d8 <freep>
    5d20:	6388                	ld	a0,0(a5)
    5d22:	c515                	beqz	a0,5d4e <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d26:	4798                	lw	a4,8(a5)
    5d28:	03277f63          	bgeu	a4,s2,5d66 <malloc+0x76>
    5d2c:	8a4e                	mv	s4,s3
    5d2e:	0009871b          	sext.w	a4,s3
    5d32:	6685                	lui	a3,0x1
    5d34:	00d77363          	bgeu	a4,a3,5d3a <malloc+0x4a>
    5d38:	6a05                	lui	s4,0x1
    5d3a:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    5d3e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5d42:	00003497          	auipc	s1,0x3
    5d46:	89648493          	addi	s1,s1,-1898 # 85d8 <freep>
  if(p == (char*)-1)
    5d4a:	5b7d                	li	s6,-1
    5d4c:	a885                	j	5dbc <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    5d4e:	00009797          	auipc	a5,0x9
    5d52:	0aa78793          	addi	a5,a5,170 # edf8 <base>
    5d56:	00003717          	auipc	a4,0x3
    5d5a:	88f73123          	sd	a5,-1918(a4) # 85d8 <freep>
    5d5e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5d60:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5d64:	b7e1                	j	5d2c <malloc+0x3c>
      if(p->s.size == nunits)
    5d66:	02e90b63          	beq	s2,a4,5d9c <malloc+0xac>
        p->s.size -= nunits;
    5d6a:	4137073b          	subw	a4,a4,s3
    5d6e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d70:	1702                	slli	a4,a4,0x20
    5d72:	9301                	srli	a4,a4,0x20
    5d74:	0712                	slli	a4,a4,0x4
    5d76:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d78:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d7c:	00003717          	auipc	a4,0x3
    5d80:	84a73e23          	sd	a0,-1956(a4) # 85d8 <freep>
      return (void*)(p + 1);
    5d84:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5d88:	70e2                	ld	ra,56(sp)
    5d8a:	7442                	ld	s0,48(sp)
    5d8c:	74a2                	ld	s1,40(sp)
    5d8e:	7902                	ld	s2,32(sp)
    5d90:	69e2                	ld	s3,24(sp)
    5d92:	6a42                	ld	s4,16(sp)
    5d94:	6aa2                	ld	s5,8(sp)
    5d96:	6b02                	ld	s6,0(sp)
    5d98:	6121                	addi	sp,sp,64
    5d9a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5d9c:	6398                	ld	a4,0(a5)
    5d9e:	e118                	sd	a4,0(a0)
    5da0:	bff1                	j	5d7c <malloc+0x8c>
  hp->s.size = nu;
    5da2:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    5da6:	0541                	addi	a0,a0,16
    5da8:	00000097          	auipc	ra,0x0
    5dac:	ebe080e7          	jalr	-322(ra) # 5c66 <free>
  return freep;
    5db0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5db2:	d979                	beqz	a0,5d88 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5db4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5db6:	4798                	lw	a4,8(a5)
    5db8:	fb2777e3          	bgeu	a4,s2,5d66 <malloc+0x76>
    if(p == freep)
    5dbc:	6098                	ld	a4,0(s1)
    5dbe:	853e                	mv	a0,a5
    5dc0:	fef71ae3          	bne	a4,a5,5db4 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    5dc4:	8552                	mv	a0,s4
    5dc6:	00000097          	auipc	ra,0x0
    5dca:	b62080e7          	jalr	-1182(ra) # 5928 <sbrk>
  if(p == (char*)-1)
    5dce:	fd651ae3          	bne	a0,s6,5da2 <malloc+0xb2>
        return 0;
    5dd2:	4501                	li	a0,0
    5dd4:	bf55                	j	5d88 <malloc+0x98>
