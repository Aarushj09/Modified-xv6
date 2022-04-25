
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	ae013103          	ld	sp,-1312(sp) # 80008ae0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f1402773          	csrr	a4,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	2701                	sext.w	a4,a4

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000028:	0037161b          	slliw	a2,a4,0x3
    8000002c:	020047b7          	lui	a5,0x2004
    80000030:	963e                	add	a2,a2,a5
    80000032:	0200c7b7          	lui	a5,0x200c
    80000036:	ff87b783          	ld	a5,-8(a5) # 200bff8 <_entry-0x7dff4008>
    8000003a:	000f46b7          	lui	a3,0xf4
    8000003e:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000042:	97b6                	add	a5,a5,a3
    80000044:	e21c                	sd	a5,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000046:	00271793          	slli	a5,a4,0x2
    8000004a:	97ba                	add	a5,a5,a4
    8000004c:	00379713          	slli	a4,a5,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	ff078793          	addi	a5,a5,-16 # 80009040 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	1ee78793          	addi	a5,a5,494 # 80006250 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd77ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e5278793          	addi	a5,a5,-430 # 80000efe <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05663          	blez	a2,8000015e <consolewrite+0x5e>
    80000116:	8a2a                	mv	s4,a0
    80000118:	892e                	mv	s2,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4481                	li	s1,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	864a                	mv	a2,s2
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	5fe080e7          	jalr	1534(ra) # 80002728 <either_copyin>
    80000132:	01550c63          	beq	a0,s5,8000014a <consolewrite+0x4a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7d2080e7          	jalr	2002(ra) # 8000090c <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2485                	addiw	s1,s1,1
    80000144:	0905                	addi	s2,s2,1
    80000146:	fc999de3          	bne	s3,s1,80000120 <consolewrite+0x20>
  }

  return i;
}
    8000014a:	8526                	mv	a0,s1
    8000014c:	60a6                	ld	ra,72(sp)
    8000014e:	6406                	ld	s0,64(sp)
    80000150:	74e2                	ld	s1,56(sp)
    80000152:	7942                	ld	s2,48(sp)
    80000154:	79a2                	ld	s3,40(sp)
    80000156:	7a02                	ld	s4,32(sp)
    80000158:	6ae2                	ld	s5,24(sp)
    8000015a:	6161                	addi	sp,sp,80
    8000015c:	8082                	ret
  for(i = 0; i < n; i++){
    8000015e:	4481                	li	s1,0
    80000160:	b7ed                	j	8000014a <consolewrite+0x4a>

0000000080000162 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000162:	7119                	addi	sp,sp,-128
    80000164:	fc86                	sd	ra,120(sp)
    80000166:	f8a2                	sd	s0,112(sp)
    80000168:	f4a6                	sd	s1,104(sp)
    8000016a:	f0ca                	sd	s2,96(sp)
    8000016c:	ecce                	sd	s3,88(sp)
    8000016e:	e8d2                	sd	s4,80(sp)
    80000170:	e4d6                	sd	s5,72(sp)
    80000172:	e0da                	sd	s6,64(sp)
    80000174:	fc5e                	sd	s7,56(sp)
    80000176:	f862                	sd	s8,48(sp)
    80000178:	f466                	sd	s9,40(sp)
    8000017a:	f06a                	sd	s10,32(sp)
    8000017c:	ec6e                	sd	s11,24(sp)
    8000017e:	0100                	addi	s0,sp,128
    80000180:	8caa                	mv	s9,a0
    80000182:	8aae                	mv	s5,a1
    80000184:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	ff650513          	addi	a0,a0,-10 # 80011180 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	aa0080e7          	jalr	-1376(ra) # 80000c32 <acquire>
  while(n > 0){
    8000019a:	09405663          	blez	s4,80000226 <consoleread+0xc4>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00011497          	auipc	s1,0x11
    800001a2:	fe248493          	addi	s1,s1,-30 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	89a6                	mv	s3,s1
    800001a8:	00011917          	auipc	s2,0x11
    800001ac:	07090913          	addi	s2,s2,112 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b0:	4c11                	li	s8,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b2:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b4:	4da9                	li	s11,10
    while(cons.r == cons.w){
    800001b6:	0984a783          	lw	a5,152(s1)
    800001ba:	09c4a703          	lw	a4,156(s1)
    800001be:	02f71463          	bne	a4,a5,800001e6 <consoleread+0x84>
      if(myproc()->killed){
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	876080e7          	jalr	-1930(ra) # 80001a38 <myproc>
    800001ca:	551c                	lw	a5,40(a0)
    800001cc:	eba5                	bnez	a5,8000023c <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800001ce:	85ce                	mv	a1,s3
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	fd8080e7          	jalr	-40(ra) # 800021aa <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fef700e3          	beq	a4,a5,800001c2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001e6:	0017871b          	addiw	a4,a5,1
    800001ea:	08e4ac23          	sw	a4,152(s1)
    800001ee:	07f7f713          	andi	a4,a5,127
    800001f2:	9726                	add	a4,a4,s1
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070b9b          	sext.w	s7,a4
    if(c == C('D')){  // end-of-file
    800001fc:	078b8863          	beq	s7,s8,8000026c <consoleread+0x10a>
    cbuf = c;
    80000200:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000204:	4685                	li	a3,1
    80000206:	f8f40613          	addi	a2,s0,-113
    8000020a:	85d6                	mv	a1,s5
    8000020c:	8566                	mv	a0,s9
    8000020e:	00002097          	auipc	ra,0x2
    80000212:	4c4080e7          	jalr	1220(ra) # 800026d2 <either_copyout>
    80000216:	01a50863          	beq	a0,s10,80000226 <consoleread+0xc4>
    dst++;
    8000021a:	0a85                	addi	s5,s5,1
    --n;
    8000021c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000021e:	01bb8463          	beq	s7,s11,80000226 <consoleread+0xc4>
  while(n > 0){
    80000222:	f80a1ae3          	bnez	s4,800001b6 <consoleread+0x54>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	f5a50513          	addi	a0,a0,-166 # 80011180 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	ab8080e7          	jalr	-1352(ra) # 80000ce6 <release>

  return target - n;
    80000236:	414b053b          	subw	a0,s6,s4
    8000023a:	a811                	j	8000024e <consoleread+0xec>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	f4450513          	addi	a0,a0,-188 # 80011180 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	aa2080e7          	jalr	-1374(ra) # 80000ce6 <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70e6                	ld	ra,120(sp)
    80000250:	7446                	ld	s0,112(sp)
    80000252:	74a6                	ld	s1,104(sp)
    80000254:	7906                	ld	s2,96(sp)
    80000256:	69e6                	ld	s3,88(sp)
    80000258:	6a46                	ld	s4,80(sp)
    8000025a:	6aa6                	ld	s5,72(sp)
    8000025c:	6b06                	ld	s6,64(sp)
    8000025e:	7be2                	ld	s7,56(sp)
    80000260:	7c42                	ld	s8,48(sp)
    80000262:	7ca2                	ld	s9,40(sp)
    80000264:	7d02                	ld	s10,32(sp)
    80000266:	6de2                	ld	s11,24(sp)
    80000268:	6109                	addi	sp,sp,128
    8000026a:	8082                	ret
      if(n < target){
    8000026c:	000a071b          	sext.w	a4,s4
    80000270:	fb677be3          	bgeu	a4,s6,80000226 <consoleread+0xc4>
        cons.r--;
    80000274:	00011717          	auipc	a4,0x11
    80000278:	faf72223          	sw	a5,-92(a4) # 80011218 <cons+0x98>
    8000027c:	b76d                	j	80000226 <consoleread+0xc4>

000000008000027e <consputc>:
{
    8000027e:	1141                	addi	sp,sp,-16
    80000280:	e406                	sd	ra,8(sp)
    80000282:	e022                	sd	s0,0(sp)
    80000284:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000286:	10000793          	li	a5,256
    8000028a:	00f50a63          	beq	a0,a5,8000029e <consputc+0x20>
    uartputc_sync(c);
    8000028e:	00000097          	auipc	ra,0x0
    80000292:	58a080e7          	jalr	1418(ra) # 80000818 <uartputc_sync>
}
    80000296:	60a2                	ld	ra,8(sp)
    80000298:	6402                	ld	s0,0(sp)
    8000029a:	0141                	addi	sp,sp,16
    8000029c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	578080e7          	jalr	1400(ra) # 80000818 <uartputc_sync>
    800002a8:	02000513          	li	a0,32
    800002ac:	00000097          	auipc	ra,0x0
    800002b0:	56c080e7          	jalr	1388(ra) # 80000818 <uartputc_sync>
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	562080e7          	jalr	1378(ra) # 80000818 <uartputc_sync>
    800002be:	bfe1                	j	80000296 <consputc+0x18>

00000000800002c0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c0:	1101                	addi	sp,sp,-32
    800002c2:	ec06                	sd	ra,24(sp)
    800002c4:	e822                	sd	s0,16(sp)
    800002c6:	e426                	sd	s1,8(sp)
    800002c8:	e04a                	sd	s2,0(sp)
    800002ca:	1000                	addi	s0,sp,32
    800002cc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ce:	00011517          	auipc	a0,0x11
    800002d2:	eb250513          	addi	a0,a0,-334 # 80011180 <cons>
    800002d6:	00001097          	auipc	ra,0x1
    800002da:	95c080e7          	jalr	-1700(ra) # 80000c32 <acquire>

  switch(c){
    800002de:	47c1                	li	a5,16
    800002e0:	12f48463          	beq	s1,a5,80000408 <consoleintr+0x148>
    800002e4:	0297df63          	bge	a5,s1,80000322 <consoleintr+0x62>
    800002e8:	47d5                	li	a5,21
    800002ea:	0af48863          	beq	s1,a5,8000039a <consoleintr+0xda>
    800002ee:	07f00793          	li	a5,127
    800002f2:	02f49b63          	bne	s1,a5,80000328 <consoleintr+0x68>
      consputc(BACKSPACE);
    }
    break;
  case C('H'): // Backspace
  case '\x7f':
    if(cons.e != cons.w){
    800002f6:	00011717          	auipc	a4,0x11
    800002fa:	e8a70713          	addi	a4,a4,-374 # 80011180 <cons>
    800002fe:	0a072783          	lw	a5,160(a4)
    80000302:	09c72703          	lw	a4,156(a4)
    80000306:	10f70563          	beq	a4,a5,80000410 <consoleintr+0x150>
      cons.e--;
    8000030a:	37fd                	addiw	a5,a5,-1
    8000030c:	00011717          	auipc	a4,0x11
    80000310:	f0f72a23          	sw	a5,-236(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    80000314:	10000513          	li	a0,256
    80000318:	00000097          	auipc	ra,0x0
    8000031c:	f66080e7          	jalr	-154(ra) # 8000027e <consputc>
    80000320:	a8c5                	j	80000410 <consoleintr+0x150>
  switch(c){
    80000322:	47a1                	li	a5,8
    80000324:	fcf489e3          	beq	s1,a5,800002f6 <consoleintr+0x36>
    }
    break;
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000328:	c4e5                	beqz	s1,80000410 <consoleintr+0x150>
    8000032a:	00011717          	auipc	a4,0x11
    8000032e:	e5670713          	addi	a4,a4,-426 # 80011180 <cons>
    80000332:	0a072783          	lw	a5,160(a4)
    80000336:	09872703          	lw	a4,152(a4)
    8000033a:	9f99                	subw	a5,a5,a4
    8000033c:	07f00713          	li	a4,127
    80000340:	0cf76863          	bltu	a4,a5,80000410 <consoleintr+0x150>
      c = (c == '\r') ? '\n' : c;
    80000344:	47b5                	li	a5,13
    80000346:	0ef48363          	beq	s1,a5,8000042c <consoleintr+0x16c>

      // echo back to the user.
      consputc(c);
    8000034a:	8526                	mv	a0,s1
    8000034c:	00000097          	auipc	ra,0x0
    80000350:	f32080e7          	jalr	-206(ra) # 8000027e <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000354:	00011797          	auipc	a5,0x11
    80000358:	e2c78793          	addi	a5,a5,-468 # 80011180 <cons>
    8000035c:	0a07a703          	lw	a4,160(a5)
    80000360:	0017069b          	addiw	a3,a4,1
    80000364:	0006861b          	sext.w	a2,a3
    80000368:	0ad7a023          	sw	a3,160(a5)
    8000036c:	07f77713          	andi	a4,a4,127
    80000370:	97ba                	add	a5,a5,a4
    80000372:	00978c23          	sb	s1,24(a5)

      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000376:	47a9                	li	a5,10
    80000378:	0ef48163          	beq	s1,a5,8000045a <consoleintr+0x19a>
    8000037c:	4791                	li	a5,4
    8000037e:	0cf48e63          	beq	s1,a5,8000045a <consoleintr+0x19a>
    80000382:	00011797          	auipc	a5,0x11
    80000386:	dfe78793          	addi	a5,a5,-514 # 80011180 <cons>
    8000038a:	0987a783          	lw	a5,152(a5)
    8000038e:	0807879b          	addiw	a5,a5,128
    80000392:	06f61f63          	bne	a2,a5,80000410 <consoleintr+0x150>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000396:	863e                	mv	a2,a5
    80000398:	a0c9                	j	8000045a <consoleintr+0x19a>
    while(cons.e != cons.w &&
    8000039a:	00011717          	auipc	a4,0x11
    8000039e:	de670713          	addi	a4,a4,-538 # 80011180 <cons>
    800003a2:	0a072783          	lw	a5,160(a4)
    800003a6:	09c72703          	lw	a4,156(a4)
    800003aa:	06f70363          	beq	a4,a5,80000410 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003ae:	37fd                	addiw	a5,a5,-1
    800003b0:	0007871b          	sext.w	a4,a5
    800003b4:	07f7f793          	andi	a5,a5,127
    800003b8:	00011697          	auipc	a3,0x11
    800003bc:	dc868693          	addi	a3,a3,-568 # 80011180 <cons>
    800003c0:	97b6                	add	a5,a5,a3
    while(cons.e != cons.w &&
    800003c2:	0187c683          	lbu	a3,24(a5)
    800003c6:	47a9                	li	a5,10
      cons.e--;
    800003c8:	00011497          	auipc	s1,0x11
    800003cc:	db848493          	addi	s1,s1,-584 # 80011180 <cons>
    while(cons.e != cons.w &&
    800003d0:	4929                	li	s2,10
    800003d2:	02f68f63          	beq	a3,a5,80000410 <consoleintr+0x150>
      cons.e--;
    800003d6:	0ae4a023          	sw	a4,160(s1)
      consputc(BACKSPACE);
    800003da:	10000513          	li	a0,256
    800003de:	00000097          	auipc	ra,0x0
    800003e2:	ea0080e7          	jalr	-352(ra) # 8000027e <consputc>
    while(cons.e != cons.w &&
    800003e6:	0a04a783          	lw	a5,160(s1)
    800003ea:	09c4a703          	lw	a4,156(s1)
    800003ee:	02f70163          	beq	a4,a5,80000410 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003f2:	37fd                	addiw	a5,a5,-1
    800003f4:	0007871b          	sext.w	a4,a5
    800003f8:	07f7f793          	andi	a5,a5,127
    800003fc:	97a6                	add	a5,a5,s1
    while(cons.e != cons.w &&
    800003fe:	0187c783          	lbu	a5,24(a5)
    80000402:	fd279ae3          	bne	a5,s2,800003d6 <consoleintr+0x116>
    80000406:	a029                	j	80000410 <consoleintr+0x150>
    procdump();
    80000408:	00002097          	auipc	ra,0x2
    8000040c:	376080e7          	jalr	886(ra) # 8000277e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000410:	00011517          	auipc	a0,0x11
    80000414:	d7050513          	addi	a0,a0,-656 # 80011180 <cons>
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	8ce080e7          	jalr	-1842(ra) # 80000ce6 <release>
}
    80000420:	60e2                	ld	ra,24(sp)
    80000422:	6442                	ld	s0,16(sp)
    80000424:	64a2                	ld	s1,8(sp)
    80000426:	6902                	ld	s2,0(sp)
    80000428:	6105                	addi	sp,sp,32
    8000042a:	8082                	ret
      consputc(c);
    8000042c:	4529                	li	a0,10
    8000042e:	00000097          	auipc	ra,0x0
    80000432:	e50080e7          	jalr	-432(ra) # 8000027e <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000436:	00011797          	auipc	a5,0x11
    8000043a:	d4a78793          	addi	a5,a5,-694 # 80011180 <cons>
    8000043e:	0a07a703          	lw	a4,160(a5)
    80000442:	0017069b          	addiw	a3,a4,1
    80000446:	0006861b          	sext.w	a2,a3
    8000044a:	0ad7a023          	sw	a3,160(a5)
    8000044e:	07f77713          	andi	a4,a4,127
    80000452:	97ba                	add	a5,a5,a4
    80000454:	4729                	li	a4,10
    80000456:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000045a:	00011797          	auipc	a5,0x11
    8000045e:	dcc7a123          	sw	a2,-574(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    80000462:	00011517          	auipc	a0,0x11
    80000466:	db650513          	addi	a0,a0,-586 # 80011218 <cons+0x98>
    8000046a:	00002097          	auipc	ra,0x2
    8000046e:	026080e7          	jalr	38(ra) # 80002490 <wakeup>
    80000472:	bf79                	j	80000410 <consoleintr+0x150>

0000000080000474 <consoleinit>:

void
consoleinit(void)
{
    80000474:	1141                	addi	sp,sp,-16
    80000476:	e406                	sd	ra,8(sp)
    80000478:	e022                	sd	s0,0(sp)
    8000047a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000047c:	00008597          	auipc	a1,0x8
    80000480:	b9458593          	addi	a1,a1,-1132 # 80008010 <etext+0x10>
    80000484:	00011517          	auipc	a0,0x11
    80000488:	cfc50513          	addi	a0,a0,-772 # 80011180 <cons>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	716080e7          	jalr	1814(ra) # 80000ba2 <initlock>

  uartinit();
    80000494:	00000097          	auipc	ra,0x0
    80000498:	334080e7          	jalr	820(ra) # 800007c8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000049c:	00022797          	auipc	a5,0x22
    800004a0:	c7c78793          	addi	a5,a5,-900 # 80022118 <devsw>
    800004a4:	00000717          	auipc	a4,0x0
    800004a8:	cbe70713          	addi	a4,a4,-834 # 80000162 <consoleread>
    800004ac:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004ae:	00000717          	auipc	a4,0x0
    800004b2:	c5270713          	addi	a4,a4,-942 # 80000100 <consolewrite>
    800004b6:	ef98                	sd	a4,24(a5)
}
    800004b8:	60a2                	ld	ra,8(sp)
    800004ba:	6402                	ld	s0,0(sp)
    800004bc:	0141                	addi	sp,sp,16
    800004be:	8082                	ret

00000000800004c0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004c0:	7179                	addi	sp,sp,-48
    800004c2:	f406                	sd	ra,40(sp)
    800004c4:	f022                	sd	s0,32(sp)
    800004c6:	ec26                	sd	s1,24(sp)
    800004c8:	e84a                	sd	s2,16(sp)
    800004ca:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004cc:	c219                	beqz	a2,800004d2 <printint+0x12>
    800004ce:	00054d63          	bltz	a0,800004e8 <printint+0x28>
    x = -xx;
  else
    x = xx;
    800004d2:	2501                	sext.w	a0,a0
    800004d4:	4881                	li	a7,0
    800004d6:	fd040713          	addi	a4,s0,-48

  i = 0;
    800004da:	4601                	li	a2,0
  do {
    buf[i++] = digits[x % base];
    800004dc:	2581                	sext.w	a1,a1
    800004de:	00008817          	auipc	a6,0x8
    800004e2:	b3a80813          	addi	a6,a6,-1222 # 80008018 <digits>
    800004e6:	a801                	j	800004f6 <printint+0x36>
    x = -xx;
    800004e8:	40a0053b          	negw	a0,a0
    800004ec:	2501                	sext.w	a0,a0
  if(sign && (sign = xx < 0))
    800004ee:	4885                	li	a7,1
    x = -xx;
    800004f0:	b7dd                	j	800004d6 <printint+0x16>
  } while((x /= base) != 0);
    800004f2:	853e                	mv	a0,a5
    buf[i++] = digits[x % base];
    800004f4:	8636                	mv	a2,a3
    800004f6:	0016069b          	addiw	a3,a2,1
    800004fa:	02b577bb          	remuw	a5,a0,a1
    800004fe:	1782                	slli	a5,a5,0x20
    80000500:	9381                	srli	a5,a5,0x20
    80000502:	97c2                	add	a5,a5,a6
    80000504:	0007c783          	lbu	a5,0(a5)
    80000508:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    8000050c:	0705                	addi	a4,a4,1
    8000050e:	02b557bb          	divuw	a5,a0,a1
    80000512:	feb570e3          	bgeu	a0,a1,800004f2 <printint+0x32>

  if(sign)
    80000516:	00088b63          	beqz	a7,8000052c <printint+0x6c>
    buf[i++] = '-';
    8000051a:	fe040793          	addi	a5,s0,-32
    8000051e:	96be                	add	a3,a3,a5
    80000520:	02d00793          	li	a5,45
    80000524:	fef68823          	sb	a5,-16(a3)
    80000528:	0026069b          	addiw	a3,a2,2

  while(--i >= 0)
    8000052c:	02d05763          	blez	a3,8000055a <printint+0x9a>
    80000530:	fd040793          	addi	a5,s0,-48
    80000534:	00d784b3          	add	s1,a5,a3
    80000538:	fff78913          	addi	s2,a5,-1
    8000053c:	9936                	add	s2,s2,a3
    8000053e:	36fd                	addiw	a3,a3,-1
    80000540:	1682                	slli	a3,a3,0x20
    80000542:	9281                	srli	a3,a3,0x20
    80000544:	40d90933          	sub	s2,s2,a3
    consputc(buf[i]);
    80000548:	fff4c503          	lbu	a0,-1(s1)
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	d32080e7          	jalr	-718(ra) # 8000027e <consputc>
  while(--i >= 0)
    80000554:	14fd                	addi	s1,s1,-1
    80000556:	ff2499e3          	bne	s1,s2,80000548 <printint+0x88>
}
    8000055a:	70a2                	ld	ra,40(sp)
    8000055c:	7402                	ld	s0,32(sp)
    8000055e:	64e2                	ld	s1,24(sp)
    80000560:	6942                	ld	s2,16(sp)
    80000562:	6145                	addi	sp,sp,48
    80000564:	8082                	ret

0000000080000566 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000566:	1101                	addi	sp,sp,-32
    80000568:	ec06                	sd	ra,24(sp)
    8000056a:	e822                	sd	s0,16(sp)
    8000056c:	e426                	sd	s1,8(sp)
    8000056e:	1000                	addi	s0,sp,32
    80000570:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000572:	00011797          	auipc	a5,0x11
    80000576:	cc07a723          	sw	zero,-818(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000057a:	00008517          	auipc	a0,0x8
    8000057e:	ab650513          	addi	a0,a0,-1354 # 80008030 <digits+0x18>
    80000582:	00000097          	auipc	ra,0x0
    80000586:	02e080e7          	jalr	46(ra) # 800005b0 <printf>
  printf(s);
    8000058a:	8526                	mv	a0,s1
    8000058c:	00000097          	auipc	ra,0x0
    80000590:	024080e7          	jalr	36(ra) # 800005b0 <printf>
  printf("\n");
    80000594:	00008517          	auipc	a0,0x8
    80000598:	b3450513          	addi	a0,a0,-1228 # 800080c8 <digits+0xb0>
    8000059c:	00000097          	auipc	ra,0x0
    800005a0:	014080e7          	jalr	20(ra) # 800005b0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800005a4:	4785                	li	a5,1
    800005a6:	00009717          	auipc	a4,0x9
    800005aa:	a4f72d23          	sw	a5,-1446(a4) # 80009000 <panicked>
  for(;;)
    800005ae:	a001                	j	800005ae <panic+0x48>

00000000800005b0 <printf>:
{
    800005b0:	7131                	addi	sp,sp,-192
    800005b2:	fc86                	sd	ra,120(sp)
    800005b4:	f8a2                	sd	s0,112(sp)
    800005b6:	f4a6                	sd	s1,104(sp)
    800005b8:	f0ca                	sd	s2,96(sp)
    800005ba:	ecce                	sd	s3,88(sp)
    800005bc:	e8d2                	sd	s4,80(sp)
    800005be:	e4d6                	sd	s5,72(sp)
    800005c0:	e0da                	sd	s6,64(sp)
    800005c2:	fc5e                	sd	s7,56(sp)
    800005c4:	f862                	sd	s8,48(sp)
    800005c6:	f466                	sd	s9,40(sp)
    800005c8:	f06a                	sd	s10,32(sp)
    800005ca:	ec6e                	sd	s11,24(sp)
    800005cc:	0100                	addi	s0,sp,128
    800005ce:	8aaa                	mv	s5,a0
    800005d0:	e40c                	sd	a1,8(s0)
    800005d2:	e810                	sd	a2,16(s0)
    800005d4:	ec14                	sd	a3,24(s0)
    800005d6:	f018                	sd	a4,32(s0)
    800005d8:	f41c                	sd	a5,40(s0)
    800005da:	03043823          	sd	a6,48(s0)
    800005de:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005e2:	00011797          	auipc	a5,0x11
    800005e6:	c4678793          	addi	a5,a5,-954 # 80011228 <pr>
    800005ea:	0187ad83          	lw	s11,24(a5)
  if(locking)
    800005ee:	020d9b63          	bnez	s11,80000624 <printf+0x74>
  if (fmt == 0)
    800005f2:	020a8f63          	beqz	s5,80000630 <printf+0x80>
  va_start(ap, fmt);
    800005f6:	00840793          	addi	a5,s0,8
    800005fa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005fe:	000ac503          	lbu	a0,0(s5)
    80000602:	16050063          	beqz	a0,80000762 <printf+0x1b2>
    80000606:	4481                	li	s1,0
    if(c != '%'){
    80000608:	02500a13          	li	s4,37
    switch(c){
    8000060c:	07000b13          	li	s6,112
  consputc('x');
    80000610:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000612:	00008b97          	auipc	s7,0x8
    80000616:	a06b8b93          	addi	s7,s7,-1530 # 80008018 <digits>
    switch(c){
    8000061a:	07300c93          	li	s9,115
    8000061e:	06400c13          	li	s8,100
    80000622:	a815                	j	80000656 <printf+0xa6>
    acquire(&pr.lock);
    80000624:	853e                	mv	a0,a5
    80000626:	00000097          	auipc	ra,0x0
    8000062a:	60c080e7          	jalr	1548(ra) # 80000c32 <acquire>
    8000062e:	b7d1                	j	800005f2 <printf+0x42>
    panic("null fmt");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a1050513          	addi	a0,a0,-1520 # 80008040 <digits+0x28>
    80000638:	00000097          	auipc	ra,0x0
    8000063c:	f2e080e7          	jalr	-210(ra) # 80000566 <panic>
      consputc(c);
    80000640:	00000097          	auipc	ra,0x0
    80000644:	c3e080e7          	jalr	-962(ra) # 8000027e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000648:	2485                	addiw	s1,s1,1
    8000064a:	009a87b3          	add	a5,s5,s1
    8000064e:	0007c503          	lbu	a0,0(a5)
    80000652:	10050863          	beqz	a0,80000762 <printf+0x1b2>
    if(c != '%'){
    80000656:	ff4515e3          	bne	a0,s4,80000640 <printf+0x90>
    c = fmt[++i] & 0xff;
    8000065a:	2485                	addiw	s1,s1,1
    8000065c:	009a87b3          	add	a5,s5,s1
    80000660:	0007c783          	lbu	a5,0(a5)
    80000664:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000668:	0e090d63          	beqz	s2,80000762 <printf+0x1b2>
    switch(c){
    8000066c:	05678a63          	beq	a5,s6,800006c0 <printf+0x110>
    80000670:	02fb7663          	bgeu	s6,a5,8000069c <printf+0xec>
    80000674:	09978963          	beq	a5,s9,80000706 <printf+0x156>
    80000678:	07800713          	li	a4,120
    8000067c:	0ce79863          	bne	a5,a4,8000074c <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000680:	f8843783          	ld	a5,-120(s0)
    80000684:	00878713          	addi	a4,a5,8
    80000688:	f8e43423          	sd	a4,-120(s0)
    8000068c:	4605                	li	a2,1
    8000068e:	85ea                	mv	a1,s10
    80000690:	4388                	lw	a0,0(a5)
    80000692:	00000097          	auipc	ra,0x0
    80000696:	e2e080e7          	jalr	-466(ra) # 800004c0 <printint>
      break;
    8000069a:	b77d                	j	80000648 <printf+0x98>
    switch(c){
    8000069c:	0b478263          	beq	a5,s4,80000740 <printf+0x190>
    800006a0:	0b879663          	bne	a5,s8,8000074c <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800006a4:	f8843783          	ld	a5,-120(s0)
    800006a8:	00878713          	addi	a4,a5,8
    800006ac:	f8e43423          	sd	a4,-120(s0)
    800006b0:	4605                	li	a2,1
    800006b2:	45a9                	li	a1,10
    800006b4:	4388                	lw	a0,0(a5)
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	e0a080e7          	jalr	-502(ra) # 800004c0 <printint>
      break;
    800006be:	b769                	j	80000648 <printf+0x98>
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	baa080e7          	jalr	-1110(ra) # 8000027e <consputc>
  consputc('x');
    800006dc:	07800513          	li	a0,120
    800006e0:	00000097          	auipc	ra,0x0
    800006e4:	b9e080e7          	jalr	-1122(ra) # 8000027e <consputc>
    800006e8:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ea:	03c9d793          	srli	a5,s3,0x3c
    800006ee:	97de                	add	a5,a5,s7
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b8a080e7          	jalr	-1142(ra) # 8000027e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006fc:	0992                	slli	s3,s3,0x4
    800006fe:	397d                	addiw	s2,s2,-1
    80000700:	fe0915e3          	bnez	s2,800006ea <printf+0x13a>
    80000704:	b791                	j	80000648 <printf+0x98>
      if((s = va_arg(ap, char*)) == 0)
    80000706:	f8843783          	ld	a5,-120(s0)
    8000070a:	00878713          	addi	a4,a5,8
    8000070e:	f8e43423          	sd	a4,-120(s0)
    80000712:	0007b903          	ld	s2,0(a5)
    80000716:	00090e63          	beqz	s2,80000732 <printf+0x182>
      for(; *s; s++)
    8000071a:	00094503          	lbu	a0,0(s2)
    8000071e:	d50d                	beqz	a0,80000648 <printf+0x98>
        consputc(*s);
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5e080e7          	jalr	-1186(ra) # 8000027e <consputc>
      for(; *s; s++)
    80000728:	0905                	addi	s2,s2,1
    8000072a:	00094503          	lbu	a0,0(s2)
    8000072e:	f96d                	bnez	a0,80000720 <printf+0x170>
    80000730:	bf21                	j	80000648 <printf+0x98>
        s = "(null)";
    80000732:	00008917          	auipc	s2,0x8
    80000736:	90690913          	addi	s2,s2,-1786 # 80008038 <digits+0x20>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7cd                	j	80000720 <printf+0x170>
      consputc('%');
    80000740:	8552                	mv	a0,s4
    80000742:	00000097          	auipc	ra,0x0
    80000746:	b3c080e7          	jalr	-1220(ra) # 8000027e <consputc>
      break;
    8000074a:	bdfd                	j	80000648 <printf+0x98>
      consputc('%');
    8000074c:	8552                	mv	a0,s4
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	b30080e7          	jalr	-1232(ra) # 8000027e <consputc>
      consputc(c);
    80000756:	854a                	mv	a0,s2
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	b26080e7          	jalr	-1242(ra) # 8000027e <consputc>
      break;
    80000760:	b5e5                	j	80000648 <printf+0x98>
  if(locking)
    80000762:	020d9163          	bnez	s11,80000784 <printf+0x1d4>
}
    80000766:	70e6                	ld	ra,120(sp)
    80000768:	7446                	ld	s0,112(sp)
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6a46                	ld	s4,80(sp)
    80000772:	6aa6                	ld	s5,72(sp)
    80000774:	6b06                	ld	s6,64(sp)
    80000776:	7be2                	ld	s7,56(sp)
    80000778:	7c42                	ld	s8,48(sp)
    8000077a:	7ca2                	ld	s9,40(sp)
    8000077c:	7d02                	ld	s10,32(sp)
    8000077e:	6de2                	ld	s11,24(sp)
    80000780:	6129                	addi	sp,sp,192
    80000782:	8082                	ret
    release(&pr.lock);
    80000784:	00011517          	auipc	a0,0x11
    80000788:	aa450513          	addi	a0,a0,-1372 # 80011228 <pr>
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	55a080e7          	jalr	1370(ra) # 80000ce6 <release>
}
    80000794:	bfc9                	j	80000766 <printf+0x1b6>

0000000080000796 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000796:	1101                	addi	sp,sp,-32
    80000798:	ec06                	sd	ra,24(sp)
    8000079a:	e822                	sd	s0,16(sp)
    8000079c:	e426                	sd	s1,8(sp)
    8000079e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007a0:	00011497          	auipc	s1,0x11
    800007a4:	a8848493          	addi	s1,s1,-1400 # 80011228 <pr>
    800007a8:	00008597          	auipc	a1,0x8
    800007ac:	8a858593          	addi	a1,a1,-1880 # 80008050 <digits+0x38>
    800007b0:	8526                	mv	a0,s1
    800007b2:	00000097          	auipc	ra,0x0
    800007b6:	3f0080e7          	jalr	1008(ra) # 80000ba2 <initlock>
  pr.locking = 1;
    800007ba:	4785                	li	a5,1
    800007bc:	cc9c                	sw	a5,24(s1)
}
    800007be:	60e2                	ld	ra,24(sp)
    800007c0:	6442                	ld	s0,16(sp)
    800007c2:	64a2                	ld	s1,8(sp)
    800007c4:	6105                	addi	sp,sp,32
    800007c6:	8082                	ret

00000000800007c8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007c8:	1141                	addi	sp,sp,-16
    800007ca:	e406                	sd	ra,8(sp)
    800007cc:	e022                	sd	s0,0(sp)
    800007ce:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007d0:	100007b7          	lui	a5,0x10000
    800007d4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007d8:	f8000713          	li	a4,-128
    800007dc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007e0:	470d                	li	a4,3
    800007e2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007e6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007ea:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ee:	469d                	li	a3,7
    800007f0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007f4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007f8:	00008597          	auipc	a1,0x8
    800007fc:	86058593          	addi	a1,a1,-1952 # 80008058 <digits+0x40>
    80000800:	00011517          	auipc	a0,0x11
    80000804:	a4850513          	addi	a0,a0,-1464 # 80011248 <uart_tx_lock>
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	39a080e7          	jalr	922(ra) # 80000ba2 <initlock>
}
    80000810:	60a2                	ld	ra,8(sp)
    80000812:	6402                	ld	s0,0(sp)
    80000814:	0141                	addi	sp,sp,16
    80000816:	8082                	ret

0000000080000818 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000818:	1101                	addi	sp,sp,-32
    8000081a:	ec06                	sd	ra,24(sp)
    8000081c:	e822                	sd	s0,16(sp)
    8000081e:	e426                	sd	s1,8(sp)
    80000820:	1000                	addi	s0,sp,32
    80000822:	84aa                	mv	s1,a0
  push_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	3c2080e7          	jalr	962(ra) # 80000be6 <push_off>

  if(panicked){
    8000082c:	00008797          	auipc	a5,0x8
    80000830:	7d478793          	addi	a5,a5,2004 # 80009000 <panicked>
    80000834:	439c                	lw	a5,0(a5)
    80000836:	2781                	sext.w	a5,a5
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000838:	10000737          	lui	a4,0x10000
  if(panicked){
    8000083c:	c391                	beqz	a5,80000840 <uartputc_sync+0x28>
    for(;;)
    8000083e:	a001                	j	8000083e <uartputc_sync+0x26>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000840:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000844:	0ff7f793          	andi	a5,a5,255
    80000848:	0207f793          	andi	a5,a5,32
    8000084c:	dbf5                	beqz	a5,80000840 <uartputc_sync+0x28>
    ;
  WriteReg(THR, c);
    8000084e:	0ff4f793          	andi	a5,s1,255
    80000852:	10000737          	lui	a4,0x10000
    80000856:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	42c080e7          	jalr	1068(ra) # 80000c86 <pop_off>
}
    80000862:	60e2                	ld	ra,24(sp)
    80000864:	6442                	ld	s0,16(sp)
    80000866:	64a2                	ld	s1,8(sp)
    80000868:	6105                	addi	sp,sp,32
    8000086a:	8082                	ret

000000008000086c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000086c:	00008797          	auipc	a5,0x8
    80000870:	79c78793          	addi	a5,a5,1948 # 80009008 <uart_tx_r>
    80000874:	639c                	ld	a5,0(a5)
    80000876:	00008717          	auipc	a4,0x8
    8000087a:	79a70713          	addi	a4,a4,1946 # 80009010 <uart_tx_w>
    8000087e:	6318                	ld	a4,0(a4)
    80000880:	08f70563          	beq	a4,a5,8000090a <uartstart+0x9e>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000884:	10000737          	lui	a4,0x10000
    80000888:	00574703          	lbu	a4,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000088c:	0ff77713          	andi	a4,a4,255
    80000890:	02077713          	andi	a4,a4,32
    80000894:	cb3d                	beqz	a4,8000090a <uartstart+0x9e>
{
    80000896:	7139                	addi	sp,sp,-64
    80000898:	fc06                	sd	ra,56(sp)
    8000089a:	f822                	sd	s0,48(sp)
    8000089c:	f426                	sd	s1,40(sp)
    8000089e:	f04a                	sd	s2,32(sp)
    800008a0:	ec4e                	sd	s3,24(sp)
    800008a2:	e852                	sd	s4,16(sp)
    800008a4:	e456                	sd	s5,8(sp)
    800008a6:	0080                	addi	s0,sp,64
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008a8:	00011a17          	auipc	s4,0x11
    800008ac:	9a0a0a13          	addi	s4,s4,-1632 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    800008b0:	00008497          	auipc	s1,0x8
    800008b4:	75848493          	addi	s1,s1,1880 # 80009008 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008b8:	10000937          	lui	s2,0x10000
    if(uart_tx_w == uart_tx_r){
    800008bc:	00008997          	auipc	s3,0x8
    800008c0:	75498993          	addi	s3,s3,1876 # 80009010 <uart_tx_w>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c4:	01f7f713          	andi	a4,a5,31
    800008c8:	9752                	add	a4,a4,s4
    800008ca:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008ce:	0785                	addi	a5,a5,1
    800008d0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008d2:	8526                	mv	a0,s1
    800008d4:	00002097          	auipc	ra,0x2
    800008d8:	bbc080e7          	jalr	-1092(ra) # 80002490 <wakeup>
    WriteReg(THR, c);
    800008dc:	01590023          	sb	s5,0(s2) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008e0:	609c                	ld	a5,0(s1)
    800008e2:	0009b703          	ld	a4,0(s3)
    800008e6:	00f70963          	beq	a4,a5,800008f8 <uartstart+0x8c>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ea:	00594703          	lbu	a4,5(s2)
    800008ee:	0ff77713          	andi	a4,a4,255
    800008f2:	02077713          	andi	a4,a4,32
    800008f6:	f779                	bnez	a4,800008c4 <uartstart+0x58>
  }
}
    800008f8:	70e2                	ld	ra,56(sp)
    800008fa:	7442                	ld	s0,48(sp)
    800008fc:	74a2                	ld	s1,40(sp)
    800008fe:	7902                	ld	s2,32(sp)
    80000900:	69e2                	ld	s3,24(sp)
    80000902:	6a42                	ld	s4,16(sp)
    80000904:	6aa2                	ld	s5,8(sp)
    80000906:	6121                	addi	sp,sp,64
    80000908:	8082                	ret
    8000090a:	8082                	ret

000000008000090c <uartputc>:
{
    8000090c:	7179                	addi	sp,sp,-48
    8000090e:	f406                	sd	ra,40(sp)
    80000910:	f022                	sd	s0,32(sp)
    80000912:	ec26                	sd	s1,24(sp)
    80000914:	e84a                	sd	s2,16(sp)
    80000916:	e44e                	sd	s3,8(sp)
    80000918:	e052                	sd	s4,0(sp)
    8000091a:	1800                	addi	s0,sp,48
    8000091c:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000091e:	00011517          	auipc	a0,0x11
    80000922:	92a50513          	addi	a0,a0,-1750 # 80011248 <uart_tx_lock>
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	30c080e7          	jalr	780(ra) # 80000c32 <acquire>
  if(panicked){
    8000092e:	00008797          	auipc	a5,0x8
    80000932:	6d278793          	addi	a5,a5,1746 # 80009000 <panicked>
    80000936:	439c                	lw	a5,0(a5)
    80000938:	2781                	sext.w	a5,a5
    8000093a:	c391                	beqz	a5,8000093e <uartputc+0x32>
    for(;;)
    8000093c:	a001                	j	8000093c <uartputc+0x30>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000093e:	00008797          	auipc	a5,0x8
    80000942:	6d278793          	addi	a5,a5,1746 # 80009010 <uart_tx_w>
    80000946:	639c                	ld	a5,0(a5)
    80000948:	00008717          	auipc	a4,0x8
    8000094c:	6c070713          	addi	a4,a4,1728 # 80009008 <uart_tx_r>
    80000950:	6318                	ld	a4,0(a4)
    80000952:	02070713          	addi	a4,a4,32
    80000956:	02f71b63          	bne	a4,a5,8000098c <uartputc+0x80>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000095a:	00011a17          	auipc	s4,0x11
    8000095e:	8eea0a13          	addi	s4,s4,-1810 # 80011248 <uart_tx_lock>
    80000962:	00008497          	auipc	s1,0x8
    80000966:	6a648493          	addi	s1,s1,1702 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096a:	00008917          	auipc	s2,0x8
    8000096e:	6a690913          	addi	s2,s2,1702 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000972:	85d2                	mv	a1,s4
    80000974:	8526                	mv	a0,s1
    80000976:	00002097          	auipc	ra,0x2
    8000097a:	834080e7          	jalr	-1996(ra) # 800021aa <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000097e:	00093783          	ld	a5,0(s2)
    80000982:	6098                	ld	a4,0(s1)
    80000984:	02070713          	addi	a4,a4,32
    80000988:	fef705e3          	beq	a4,a5,80000972 <uartputc+0x66>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000098c:	00011497          	auipc	s1,0x11
    80000990:	8bc48493          	addi	s1,s1,-1860 # 80011248 <uart_tx_lock>
    80000994:	01f7f713          	andi	a4,a5,31
    80000998:	9726                	add	a4,a4,s1
    8000099a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000099e:	0785                	addi	a5,a5,1
    800009a0:	00008717          	auipc	a4,0x8
    800009a4:	66f73823          	sd	a5,1648(a4) # 80009010 <uart_tx_w>
      uartstart();
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	ec4080e7          	jalr	-316(ra) # 8000086c <uartstart>
      release(&uart_tx_lock);
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	334080e7          	jalr	820(ra) # 80000ce6 <release>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ca:	1141                	addi	sp,sp,-16
    800009cc:	e422                	sd	s0,8(sp)
    800009ce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009d0:	100007b7          	lui	a5,0x10000
    800009d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009d8:	8b85                	andi	a5,a5,1
    800009da:	cb91                	beqz	a5,800009ee <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009dc:	100007b7          	lui	a5,0x10000
    800009e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009e4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009e8:	6422                	ld	s0,8(sp)
    800009ea:	0141                	addi	sp,sp,16
    800009ec:	8082                	ret
    return -1;
    800009ee:	557d                	li	a0,-1
    800009f0:	bfe5                	j	800009e8 <uartgetc+0x1e>

00000000800009f2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009f2:	1101                	addi	sp,sp,-32
    800009f4:	ec06                	sd	ra,24(sp)
    800009f6:	e822                	sd	s0,16(sp)
    800009f8:	e426                	sd	s1,8(sp)
    800009fa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009fc:	54fd                	li	s1,-1
    int c = uartgetc();
    800009fe:	00000097          	auipc	ra,0x0
    80000a02:	fcc080e7          	jalr	-52(ra) # 800009ca <uartgetc>
    if(c == -1)
    80000a06:	00950763          	beq	a0,s1,80000a14 <uartintr+0x22>
      break;
    consoleintr(c);
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	8b6080e7          	jalr	-1866(ra) # 800002c0 <consoleintr>
  while(1){
    80000a12:	b7f5                	j	800009fe <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a14:	00011497          	auipc	s1,0x11
    80000a18:	83448493          	addi	s1,s1,-1996 # 80011248 <uart_tx_lock>
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	214080e7          	jalr	532(ra) # 80000c32 <acquire>
  uartstart();
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	e46080e7          	jalr	-442(ra) # 8000086c <uartstart>
  release(&uart_tx_lock);
    80000a2e:	8526                	mv	a0,s1
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	2b6080e7          	jalr	694(ra) # 80000ce6 <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	6785                	lui	a5,0x1
    80000a50:	17fd                	addi	a5,a5,-1
    80000a52:	8fe9                	and	a5,a5,a0
    80000a54:	ebb9                	bnez	a5,80000aaa <kfree+0x68>
    80000a56:	84aa                	mv	s1,a0
    80000a58:	00026797          	auipc	a5,0x26
    80000a5c:	5a878793          	addi	a5,a5,1448 # 80027000 <end>
    80000a60:	04f56563          	bltu	a0,a5,80000aaa <kfree+0x68>
    80000a64:	47c5                	li	a5,17
    80000a66:	07ee                	slli	a5,a5,0x1b
    80000a68:	04f57163          	bgeu	a0,a5,80000aaa <kfree+0x68>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6c:	6605                	lui	a2,0x1
    80000a6e:	4585                	li	a1,1
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	2be080e7          	jalr	702(ra) # 80000d2e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a78:	00011917          	auipc	s2,0x11
    80000a7c:	80890913          	addi	s2,s2,-2040 # 80011280 <kmem>
    80000a80:	854a                	mv	a0,s2
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	1b0080e7          	jalr	432(ra) # 80000c32 <acquire>
  r->next = kmem.freelist;
    80000a8a:	01893783          	ld	a5,24(s2)
    80000a8e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a90:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a94:	854a                	mv	a0,s2
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	250080e7          	jalr	592(ra) # 80000ce6 <release>
}
    80000a9e:	60e2                	ld	ra,24(sp)
    80000aa0:	6442                	ld	s0,16(sp)
    80000aa2:	64a2                	ld	s1,8(sp)
    80000aa4:	6902                	ld	s2,0(sp)
    80000aa6:	6105                	addi	sp,sp,32
    80000aa8:	8082                	ret
    panic("kfree");
    80000aaa:	00007517          	auipc	a0,0x7
    80000aae:	5b650513          	addi	a0,a0,1462 # 80008060 <digits+0x48>
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	ab4080e7          	jalr	-1356(ra) # 80000566 <panic>

0000000080000aba <freerange>:
{
    80000aba:	7179                	addi	sp,sp,-48
    80000abc:	f406                	sd	ra,40(sp)
    80000abe:	f022                	sd	s0,32(sp)
    80000ac0:	ec26                	sd	s1,24(sp)
    80000ac2:	e84a                	sd	s2,16(sp)
    80000ac4:	e44e                	sd	s3,8(sp)
    80000ac6:	e052                	sd	s4,0(sp)
    80000ac8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aca:	6705                	lui	a4,0x1
    80000acc:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80000ad0:	00f504b3          	add	s1,a0,a5
    80000ad4:	77fd                	lui	a5,0xfffff
    80000ad6:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad8:	94ba                	add	s1,s1,a4
    80000ada:	0095ee63          	bltu	a1,s1,80000af6 <freerange+0x3c>
    80000ade:	892e                	mv	s2,a1
    kfree(p);
    80000ae0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae2:	6985                	lui	s3,0x1
    kfree(p);
    80000ae4:	01448533          	add	a0,s1,s4
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	f5a080e7          	jalr	-166(ra) # 80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	94ce                	add	s1,s1,s3
    80000af2:	fe9979e3          	bgeu	s2,s1,80000ae4 <freerange+0x2a>
}
    80000af6:	70a2                	ld	ra,40(sp)
    80000af8:	7402                	ld	s0,32(sp)
    80000afa:	64e2                	ld	s1,24(sp)
    80000afc:	6942                	ld	s2,16(sp)
    80000afe:	69a2                	ld	s3,8(sp)
    80000b00:	6a02                	ld	s4,0(sp)
    80000b02:	6145                	addi	sp,sp,48
    80000b04:	8082                	ret

0000000080000b06 <kinit>:
{
    80000b06:	1141                	addi	sp,sp,-16
    80000b08:	e406                	sd	ra,8(sp)
    80000b0a:	e022                	sd	s0,0(sp)
    80000b0c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b0e:	00007597          	auipc	a1,0x7
    80000b12:	55a58593          	addi	a1,a1,1370 # 80008068 <digits+0x50>
    80000b16:	00010517          	auipc	a0,0x10
    80000b1a:	76a50513          	addi	a0,a0,1898 # 80011280 <kmem>
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	084080e7          	jalr	132(ra) # 80000ba2 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b26:	45c5                	li	a1,17
    80000b28:	05ee                	slli	a1,a1,0x1b
    80000b2a:	00026517          	auipc	a0,0x26
    80000b2e:	4d650513          	addi	a0,a0,1238 # 80027000 <end>
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	f88080e7          	jalr	-120(ra) # 80000aba <freerange>
}
    80000b3a:	60a2                	ld	ra,8(sp)
    80000b3c:	6402                	ld	s0,0(sp)
    80000b3e:	0141                	addi	sp,sp,16
    80000b40:	8082                	ret

0000000080000b42 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b42:	1101                	addi	sp,sp,-32
    80000b44:	ec06                	sd	ra,24(sp)
    80000b46:	e822                	sd	s0,16(sp)
    80000b48:	e426                	sd	s1,8(sp)
    80000b4a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b4c:	00010497          	auipc	s1,0x10
    80000b50:	73448493          	addi	s1,s1,1844 # 80011280 <kmem>
    80000b54:	8526                	mv	a0,s1
    80000b56:	00000097          	auipc	ra,0x0
    80000b5a:	0dc080e7          	jalr	220(ra) # 80000c32 <acquire>
  r = kmem.freelist;
    80000b5e:	6c84                	ld	s1,24(s1)
  if(r)
    80000b60:	c885                	beqz	s1,80000b90 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b62:	609c                	ld	a5,0(s1)
    80000b64:	00010517          	auipc	a0,0x10
    80000b68:	71c50513          	addi	a0,a0,1820 # 80011280 <kmem>
    80000b6c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	178080e7          	jalr	376(ra) # 80000ce6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b76:	6605                	lui	a2,0x1
    80000b78:	4595                	li	a1,5
    80000b7a:	8526                	mv	a0,s1
    80000b7c:	00000097          	auipc	ra,0x0
    80000b80:	1b2080e7          	jalr	434(ra) # 80000d2e <memset>
  return (void*)r;
}
    80000b84:	8526                	mv	a0,s1
    80000b86:	60e2                	ld	ra,24(sp)
    80000b88:	6442                	ld	s0,16(sp)
    80000b8a:	64a2                	ld	s1,8(sp)
    80000b8c:	6105                	addi	sp,sp,32
    80000b8e:	8082                	ret
  release(&kmem.lock);
    80000b90:	00010517          	auipc	a0,0x10
    80000b94:	6f050513          	addi	a0,a0,1776 # 80011280 <kmem>
    80000b98:	00000097          	auipc	ra,0x0
    80000b9c:	14e080e7          	jalr	334(ra) # 80000ce6 <release>
  if(r)
    80000ba0:	b7d5                	j	80000b84 <kalloc+0x42>

0000000080000ba2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ba2:	1141                	addi	sp,sp,-16
    80000ba4:	e422                	sd	s0,8(sp)
    80000ba6:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ba8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000baa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bae:	00053823          	sd	zero,16(a0)
}
    80000bb2:	6422                	ld	s0,8(sp)
    80000bb4:	0141                	addi	sp,sp,16
    80000bb6:	8082                	ret

0000000080000bb8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	411c                	lw	a5,0(a0)
    80000bba:	e399                	bnez	a5,80000bc0 <holding+0x8>
    80000bbc:	4501                	li	a0,0
  return r;
}
    80000bbe:	8082                	ret
{
    80000bc0:	1101                	addi	sp,sp,-32
    80000bc2:	ec06                	sd	ra,24(sp)
    80000bc4:	e822                	sd	s0,16(sp)
    80000bc6:	e426                	sd	s1,8(sp)
    80000bc8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bca:	6904                	ld	s1,16(a0)
    80000bcc:	00001097          	auipc	ra,0x1
    80000bd0:	e50080e7          	jalr	-432(ra) # 80001a1c <mycpu>
    80000bd4:	40a48533          	sub	a0,s1,a0
    80000bd8:	00153513          	seqz	a0,a0
}
    80000bdc:	60e2                	ld	ra,24(sp)
    80000bde:	6442                	ld	s0,16(sp)
    80000be0:	64a2                	ld	s1,8(sp)
    80000be2:	6105                	addi	sp,sp,32
    80000be4:	8082                	ret

0000000080000be6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000be6:	1101                	addi	sp,sp,-32
    80000be8:	ec06                	sd	ra,24(sp)
    80000bea:	e822                	sd	s0,16(sp)
    80000bec:	e426                	sd	s1,8(sp)
    80000bee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf0:	100024f3          	csrr	s1,sstatus
    80000bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bfa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bfe:	00001097          	auipc	ra,0x1
    80000c02:	e1e080e7          	jalr	-482(ra) # 80001a1c <mycpu>
    80000c06:	5d3c                	lw	a5,120(a0)
    80000c08:	cf89                	beqz	a5,80000c22 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c0a:	00001097          	auipc	ra,0x1
    80000c0e:	e12080e7          	jalr	-494(ra) # 80001a1c <mycpu>
    80000c12:	5d3c                	lw	a5,120(a0)
    80000c14:	2785                	addiw	a5,a5,1
    80000c16:	dd3c                	sw	a5,120(a0)
}
    80000c18:	60e2                	ld	ra,24(sp)
    80000c1a:	6442                	ld	s0,16(sp)
    80000c1c:	64a2                	ld	s1,8(sp)
    80000c1e:	6105                	addi	sp,sp,32
    80000c20:	8082                	ret
    mycpu()->intena = old;
    80000c22:	00001097          	auipc	ra,0x1
    80000c26:	dfa080e7          	jalr	-518(ra) # 80001a1c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c2a:	8085                	srli	s1,s1,0x1
    80000c2c:	8885                	andi	s1,s1,1
    80000c2e:	dd64                	sw	s1,124(a0)
    80000c30:	bfe9                	j	80000c0a <push_off+0x24>

0000000080000c32 <acquire>:
{
    80000c32:	1101                	addi	sp,sp,-32
    80000c34:	ec06                	sd	ra,24(sp)
    80000c36:	e822                	sd	s0,16(sp)
    80000c38:	e426                	sd	s1,8(sp)
    80000c3a:	1000                	addi	s0,sp,32
    80000c3c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c3e:	00000097          	auipc	ra,0x0
    80000c42:	fa8080e7          	jalr	-88(ra) # 80000be6 <push_off>
  if(holding(lk))
    80000c46:	8526                	mv	a0,s1
    80000c48:	00000097          	auipc	ra,0x0
    80000c4c:	f70080e7          	jalr	-144(ra) # 80000bb8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c50:	4705                	li	a4,1
  if(holding(lk))
    80000c52:	e115                	bnez	a0,80000c76 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c54:	87ba                	mv	a5,a4
    80000c56:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c5a:	2781                	sext.w	a5,a5
    80000c5c:	ffe5                	bnez	a5,80000c54 <acquire+0x22>
  __sync_synchronize();
    80000c5e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c62:	00001097          	auipc	ra,0x1
    80000c66:	dba080e7          	jalr	-582(ra) # 80001a1c <mycpu>
    80000c6a:	e888                	sd	a0,16(s1)
}
    80000c6c:	60e2                	ld	ra,24(sp)
    80000c6e:	6442                	ld	s0,16(sp)
    80000c70:	64a2                	ld	s1,8(sp)
    80000c72:	6105                	addi	sp,sp,32
    80000c74:	8082                	ret
    panic("acquire");
    80000c76:	00007517          	auipc	a0,0x7
    80000c7a:	3fa50513          	addi	a0,a0,1018 # 80008070 <digits+0x58>
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	8e8080e7          	jalr	-1816(ra) # 80000566 <panic>

0000000080000c86 <pop_off>:

void
pop_off(void)
{
    80000c86:	1141                	addi	sp,sp,-16
    80000c88:	e406                	sd	ra,8(sp)
    80000c8a:	e022                	sd	s0,0(sp)
    80000c8c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c8e:	00001097          	auipc	ra,0x1
    80000c92:	d8e080e7          	jalr	-626(ra) # 80001a1c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c96:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c9a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c9c:	e78d                	bnez	a5,80000cc6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c9e:	5d3c                	lw	a5,120(a0)
    80000ca0:	02f05b63          	blez	a5,80000cd6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000ca4:	37fd                	addiw	a5,a5,-1
    80000ca6:	0007871b          	sext.w	a4,a5
    80000caa:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cac:	eb09                	bnez	a4,80000cbe <pop_off+0x38>
    80000cae:	5d7c                	lw	a5,124(a0)
    80000cb0:	c799                	beqz	a5,80000cbe <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cb6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cba:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cbe:	60a2                	ld	ra,8(sp)
    80000cc0:	6402                	ld	s0,0(sp)
    80000cc2:	0141                	addi	sp,sp,16
    80000cc4:	8082                	ret
    panic("pop_off - interruptible");
    80000cc6:	00007517          	auipc	a0,0x7
    80000cca:	3b250513          	addi	a0,a0,946 # 80008078 <digits+0x60>
    80000cce:	00000097          	auipc	ra,0x0
    80000cd2:	898080e7          	jalr	-1896(ra) # 80000566 <panic>
    panic("pop_off");
    80000cd6:	00007517          	auipc	a0,0x7
    80000cda:	3ba50513          	addi	a0,a0,954 # 80008090 <digits+0x78>
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	888080e7          	jalr	-1912(ra) # 80000566 <panic>

0000000080000ce6 <release>:
{
    80000ce6:	1101                	addi	sp,sp,-32
    80000ce8:	ec06                	sd	ra,24(sp)
    80000cea:	e822                	sd	s0,16(sp)
    80000cec:	e426                	sd	s1,8(sp)
    80000cee:	1000                	addi	s0,sp,32
    80000cf0:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cf2:	00000097          	auipc	ra,0x0
    80000cf6:	ec6080e7          	jalr	-314(ra) # 80000bb8 <holding>
    80000cfa:	c115                	beqz	a0,80000d1e <release+0x38>
  lk->cpu = 0;
    80000cfc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d00:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d04:	0f50000f          	fence	iorw,ow
    80000d08:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d0c:	00000097          	auipc	ra,0x0
    80000d10:	f7a080e7          	jalr	-134(ra) # 80000c86 <pop_off>
}
    80000d14:	60e2                	ld	ra,24(sp)
    80000d16:	6442                	ld	s0,16(sp)
    80000d18:	64a2                	ld	s1,8(sp)
    80000d1a:	6105                	addi	sp,sp,32
    80000d1c:	8082                	ret
    panic("release");
    80000d1e:	00007517          	auipc	a0,0x7
    80000d22:	37a50513          	addi	a0,a0,890 # 80008098 <digits+0x80>
    80000d26:	00000097          	auipc	ra,0x0
    80000d2a:	840080e7          	jalr	-1984(ra) # 80000566 <panic>

0000000080000d2e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d34:	ce09                	beqz	a2,80000d4e <memset+0x20>
    80000d36:	87aa                	mv	a5,a0
    80000d38:	fff6071b          	addiw	a4,a2,-1
    80000d3c:	1702                	slli	a4,a4,0x20
    80000d3e:	9301                	srli	a4,a4,0x20
    80000d40:	0705                	addi	a4,a4,1
    80000d42:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d44:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffd8000>
  for(i = 0; i < n; i++){
    80000d48:	0785                	addi	a5,a5,1
    80000d4a:	fee79de3          	bne	a5,a4,80000d44 <memset+0x16>
  }
  return dst;
}
    80000d4e:	6422                	ld	s0,8(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret

0000000080000d54 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d54:	1141                	addi	sp,sp,-16
    80000d56:	e422                	sd	s0,8(sp)
    80000d58:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d5a:	ce15                	beqz	a2,80000d96 <memcmp+0x42>
    80000d5c:	fff6069b          	addiw	a3,a2,-1
    if(*s1 != *s2)
    80000d60:	00054783          	lbu	a5,0(a0)
    80000d64:	0005c703          	lbu	a4,0(a1)
    80000d68:	02e79063          	bne	a5,a4,80000d88 <memcmp+0x34>
    80000d6c:	1682                	slli	a3,a3,0x20
    80000d6e:	9281                	srli	a3,a3,0x20
    80000d70:	0685                	addi	a3,a3,1
    80000d72:	96aa                	add	a3,a3,a0
      return *s1 - *s2;
    s1++, s2++;
    80000d74:	0505                	addi	a0,a0,1
    80000d76:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d78:	00d50d63          	beq	a0,a3,80000d92 <memcmp+0x3e>
    if(*s1 != *s2)
    80000d7c:	00054783          	lbu	a5,0(a0)
    80000d80:	0005c703          	lbu	a4,0(a1)
    80000d84:	fee788e3          	beq	a5,a4,80000d74 <memcmp+0x20>
      return *s1 - *s2;
    80000d88:	40e7853b          	subw	a0,a5,a4
  }

  return 0;
}
    80000d8c:	6422                	ld	s0,8(sp)
    80000d8e:	0141                	addi	sp,sp,16
    80000d90:	8082                	ret
  return 0;
    80000d92:	4501                	li	a0,0
    80000d94:	bfe5                	j	80000d8c <memcmp+0x38>
    80000d96:	4501                	li	a0,0
    80000d98:	bfd5                	j	80000d8c <memcmp+0x38>

0000000080000d9a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d9a:	1141                	addi	sp,sp,-16
    80000d9c:	e422                	sd	s0,8(sp)
    80000d9e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000da0:	ca0d                	beqz	a2,80000dd2 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000da2:	00a5f963          	bgeu	a1,a0,80000db4 <memmove+0x1a>
    80000da6:	02061693          	slli	a3,a2,0x20
    80000daa:	9281                	srli	a3,a3,0x20
    80000dac:	00d58733          	add	a4,a1,a3
    80000db0:	02e56463          	bltu	a0,a4,80000dd8 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000db4:	fff6079b          	addiw	a5,a2,-1
    80000db8:	1782                	slli	a5,a5,0x20
    80000dba:	9381                	srli	a5,a5,0x20
    80000dbc:	0785                	addi	a5,a5,1
    80000dbe:	97ae                	add	a5,a5,a1
    80000dc0:	872a                	mv	a4,a0
      *d++ = *s++;
    80000dc2:	0585                	addi	a1,a1,1
    80000dc4:	0705                	addi	a4,a4,1
    80000dc6:	fff5c683          	lbu	a3,-1(a1)
    80000dca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dce:	fef59ae3          	bne	a1,a5,80000dc2 <memmove+0x28>

  return dst;
}
    80000dd2:	6422                	ld	s0,8(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret
    d += n;
    80000dd8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dda:	fff6079b          	addiw	a5,a2,-1
    80000dde:	1782                	slli	a5,a5,0x20
    80000de0:	9381                	srli	a5,a5,0x20
    80000de2:	fff7c793          	not	a5,a5
    80000de6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000de8:	177d                	addi	a4,a4,-1
    80000dea:	16fd                	addi	a3,a3,-1
    80000dec:	00074603          	lbu	a2,0(a4)
    80000df0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000df4:	fee79ae3          	bne	a5,a4,80000de8 <memmove+0x4e>
    80000df8:	bfe9                	j	80000dd2 <memmove+0x38>

0000000080000dfa <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dfa:	1141                	addi	sp,sp,-16
    80000dfc:	e406                	sd	ra,8(sp)
    80000dfe:	e022                	sd	s0,0(sp)
    80000e00:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e02:	00000097          	auipc	ra,0x0
    80000e06:	f98080e7          	jalr	-104(ra) # 80000d9a <memmove>
}
    80000e0a:	60a2                	ld	ra,8(sp)
    80000e0c:	6402                	ld	s0,0(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e18:	c229                	beqz	a2,80000e5a <strncmp+0x48>
    80000e1a:	00054783          	lbu	a5,0(a0)
    80000e1e:	c795                	beqz	a5,80000e4a <strncmp+0x38>
    80000e20:	0005c703          	lbu	a4,0(a1)
    80000e24:	02f71363          	bne	a4,a5,80000e4a <strncmp+0x38>
    80000e28:	fff6071b          	addiw	a4,a2,-1
    80000e2c:	1702                	slli	a4,a4,0x20
    80000e2e:	9301                	srli	a4,a4,0x20
    80000e30:	0705                	addi	a4,a4,1
    80000e32:	972a                	add	a4,a4,a0
    n--, p++, q++;
    80000e34:	0505                	addi	a0,a0,1
    80000e36:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e38:	02e50363          	beq	a0,a4,80000e5e <strncmp+0x4c>
    80000e3c:	00054783          	lbu	a5,0(a0)
    80000e40:	c789                	beqz	a5,80000e4a <strncmp+0x38>
    80000e42:	0005c683          	lbu	a3,0(a1)
    80000e46:	fef687e3          	beq	a3,a5,80000e34 <strncmp+0x22>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
    80000e4a:	00054503          	lbu	a0,0(a0)
    80000e4e:	0005c783          	lbu	a5,0(a1)
    80000e52:	9d1d                	subw	a0,a0,a5
}
    80000e54:	6422                	ld	s0,8(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret
    return 0;
    80000e5a:	4501                	li	a0,0
    80000e5c:	bfe5                	j	80000e54 <strncmp+0x42>
    80000e5e:	4501                	li	a0,0
    80000e60:	bfd5                	j	80000e54 <strncmp+0x42>

0000000080000e62 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e68:	872a                	mv	a4,a0
    80000e6a:	a011                	j	80000e6e <strncpy+0xc>
    80000e6c:	8636                	mv	a2,a3
    80000e6e:	fff6069b          	addiw	a3,a2,-1
    80000e72:	00c05963          	blez	a2,80000e84 <strncpy+0x22>
    80000e76:	0705                	addi	a4,a4,1
    80000e78:	0005c783          	lbu	a5,0(a1)
    80000e7c:	fef70fa3          	sb	a5,-1(a4)
    80000e80:	0585                	addi	a1,a1,1
    80000e82:	f7ed                	bnez	a5,80000e6c <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e84:	00d05c63          	blez	a3,80000e9c <strncpy+0x3a>
    80000e88:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e8a:	0685                	addi	a3,a3,1
    80000e8c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e90:	fff6c793          	not	a5,a3
    80000e94:	9fb9                	addw	a5,a5,a4
    80000e96:	9fb1                	addw	a5,a5,a2
    80000e98:	fef049e3          	bgtz	a5,80000e8a <strncpy+0x28>
  return os;
}
    80000e9c:	6422                	ld	s0,8(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret

0000000080000ea2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ea2:	1141                	addi	sp,sp,-16
    80000ea4:	e422                	sd	s0,8(sp)
    80000ea6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000ea8:	02c05363          	blez	a2,80000ece <safestrcpy+0x2c>
    80000eac:	fff6069b          	addiw	a3,a2,-1
    80000eb0:	1682                	slli	a3,a3,0x20
    80000eb2:	9281                	srli	a3,a3,0x20
    80000eb4:	96ae                	add	a3,a3,a1
    80000eb6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000eb8:	00d58963          	beq	a1,a3,80000eca <safestrcpy+0x28>
    80000ebc:	0585                	addi	a1,a1,1
    80000ebe:	0785                	addi	a5,a5,1
    80000ec0:	fff5c703          	lbu	a4,-1(a1)
    80000ec4:	fee78fa3          	sb	a4,-1(a5)
    80000ec8:	fb65                	bnez	a4,80000eb8 <safestrcpy+0x16>
    ;
  *s = 0;
    80000eca:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ece:	6422                	ld	s0,8(sp)
    80000ed0:	0141                	addi	sp,sp,16
    80000ed2:	8082                	ret

0000000080000ed4 <strlen>:

int
strlen(const char *s)
{
    80000ed4:	1141                	addi	sp,sp,-16
    80000ed6:	e422                	sd	s0,8(sp)
    80000ed8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eda:	00054783          	lbu	a5,0(a0)
    80000ede:	cf91                	beqz	a5,80000efa <strlen+0x26>
    80000ee0:	0505                	addi	a0,a0,1
    80000ee2:	87aa                	mv	a5,a0
    80000ee4:	4685                	li	a3,1
    80000ee6:	9e89                	subw	a3,a3,a0
    80000ee8:	00f6853b          	addw	a0,a3,a5
    80000eec:	0785                	addi	a5,a5,1
    80000eee:	fff7c703          	lbu	a4,-1(a5)
    80000ef2:	fb7d                	bnez	a4,80000ee8 <strlen+0x14>
    ;
  return n;
}
    80000ef4:	6422                	ld	s0,8(sp)
    80000ef6:	0141                	addi	sp,sp,16
    80000ef8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000efa:	4501                	li	a0,0
    80000efc:	bfe5                	j	80000ef4 <strlen+0x20>

0000000080000efe <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e406                	sd	ra,8(sp)
    80000f02:	e022                	sd	s0,0(sp)
    80000f04:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f06:	00001097          	auipc	ra,0x1
    80000f0a:	b06080e7          	jalr	-1274(ra) # 80001a0c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f0e:	00008717          	auipc	a4,0x8
    80000f12:	10a70713          	addi	a4,a4,266 # 80009018 <started>
  if(cpuid() == 0){
    80000f16:	c139                	beqz	a0,80000f5c <main+0x5e>
    while(started == 0)
    80000f18:	431c                	lw	a5,0(a4)
    80000f1a:	2781                	sext.w	a5,a5
    80000f1c:	dff5                	beqz	a5,80000f18 <main+0x1a>
      ;
    __sync_synchronize();
    80000f1e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f22:	00001097          	auipc	ra,0x1
    80000f26:	aea080e7          	jalr	-1302(ra) # 80001a0c <cpuid>
    80000f2a:	85aa                	mv	a1,a0
    80000f2c:	00007517          	auipc	a0,0x7
    80000f30:	18c50513          	addi	a0,a0,396 # 800080b8 <digits+0xa0>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	67c080e7          	jalr	1660(ra) # 800005b0 <printf>
    kvminithart();    // turn on paging
    80000f3c:	00000097          	auipc	ra,0x0
    80000f40:	0d8080e7          	jalr	216(ra) # 80001014 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f44:	00002097          	auipc	ra,0x2
    80000f48:	ab6080e7          	jalr	-1354(ra) # 800029fa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f4c:	00005097          	auipc	ra,0x5
    80000f50:	344080e7          	jalr	836(ra) # 80006290 <plicinithart>
  }

  scheduler();        
    80000f54:	00001097          	auipc	ra,0x1
    80000f58:	0a2080e7          	jalr	162(ra) # 80001ff6 <scheduler>
    consoleinit();
    80000f5c:	fffff097          	auipc	ra,0xfffff
    80000f60:	518080e7          	jalr	1304(ra) # 80000474 <consoleinit>
    printfinit();
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	832080e7          	jalr	-1998(ra) # 80000796 <printfinit>
    printf("\n");
    80000f6c:	00007517          	auipc	a0,0x7
    80000f70:	15c50513          	addi	a0,a0,348 # 800080c8 <digits+0xb0>
    80000f74:	fffff097          	auipc	ra,0xfffff
    80000f78:	63c080e7          	jalr	1596(ra) # 800005b0 <printf>
    printf("xv6 kernel is booting\n");
    80000f7c:	00007517          	auipc	a0,0x7
    80000f80:	12450513          	addi	a0,a0,292 # 800080a0 <digits+0x88>
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	62c080e7          	jalr	1580(ra) # 800005b0 <printf>
    printf("\n");
    80000f8c:	00007517          	auipc	a0,0x7
    80000f90:	13c50513          	addi	a0,a0,316 # 800080c8 <digits+0xb0>
    80000f94:	fffff097          	auipc	ra,0xfffff
    80000f98:	61c080e7          	jalr	1564(ra) # 800005b0 <printf>
    kinit();         // physical page allocator
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	b6a080e7          	jalr	-1174(ra) # 80000b06 <kinit>
    kvminit();       // create kernel page table
    80000fa4:	00000097          	auipc	ra,0x0
    80000fa8:	322080e7          	jalr	802(ra) # 800012c6 <kvminit>
    kvminithart();   // turn on paging
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	068080e7          	jalr	104(ra) # 80001014 <kvminithart>
    procinit();      // process table
    80000fb4:	00001097          	auipc	ra,0x1
    80000fb8:	9a8080e7          	jalr	-1624(ra) # 8000195c <procinit>
    trapinit();      // trap vectors
    80000fbc:	00002097          	auipc	ra,0x2
    80000fc0:	a16080e7          	jalr	-1514(ra) # 800029d2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fc4:	00002097          	auipc	ra,0x2
    80000fc8:	a36080e7          	jalr	-1482(ra) # 800029fa <trapinithart>
    plicinit();      // set up interrupt controller
    80000fcc:	00005097          	auipc	ra,0x5
    80000fd0:	2ae080e7          	jalr	686(ra) # 8000627a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fd4:	00005097          	auipc	ra,0x5
    80000fd8:	2bc080e7          	jalr	700(ra) # 80006290 <plicinithart>
    binit();         // buffer cache
    80000fdc:	00002097          	auipc	ra,0x2
    80000fe0:	3ce080e7          	jalr	974(ra) # 800033aa <binit>
    iinit();         // inode table
    80000fe4:	00003097          	auipc	ra,0x3
    80000fe8:	aa0080e7          	jalr	-1376(ra) # 80003a84 <iinit>
    fileinit();      // file table
    80000fec:	00004097          	auipc	ra,0x4
    80000ff0:	a74080e7          	jalr	-1420(ra) # 80004a60 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ff4:	00005097          	auipc	ra,0x5
    80000ff8:	3be080e7          	jalr	958(ra) # 800063b2 <virtio_disk_init>
    userinit();      // first user process
    80000ffc:	00001097          	auipc	ra,0x1
    80001000:	d56080e7          	jalr	-682(ra) # 80001d52 <userinit>
    __sync_synchronize();
    80001004:	0ff0000f          	fence
    started = 1;
    80001008:	4785                	li	a5,1
    8000100a:	00008717          	auipc	a4,0x8
    8000100e:	00f72723          	sw	a5,14(a4) # 80009018 <started>
    80001012:	b789                	j	80000f54 <main+0x56>

0000000080001014 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001014:	1141                	addi	sp,sp,-16
    80001016:	e422                	sd	s0,8(sp)
    80001018:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000101a:	00008797          	auipc	a5,0x8
    8000101e:	00678793          	addi	a5,a5,6 # 80009020 <kernel_pagetable>
    80001022:	639c                	ld	a5,0(a5)
    80001024:	83b1                	srli	a5,a5,0xc
    80001026:	577d                	li	a4,-1
    80001028:	177e                	slli	a4,a4,0x3f
    8000102a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000102c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001030:	12000073          	sfence.vma
  sfence_vma();
}
    80001034:	6422                	ld	s0,8(sp)
    80001036:	0141                	addi	sp,sp,16
    80001038:	8082                	ret

000000008000103a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000103a:	7139                	addi	sp,sp,-64
    8000103c:	fc06                	sd	ra,56(sp)
    8000103e:	f822                	sd	s0,48(sp)
    80001040:	f426                	sd	s1,40(sp)
    80001042:	f04a                	sd	s2,32(sp)
    80001044:	ec4e                	sd	s3,24(sp)
    80001046:	e852                	sd	s4,16(sp)
    80001048:	e456                	sd	s5,8(sp)
    8000104a:	e05a                	sd	s6,0(sp)
    8000104c:	0080                	addi	s0,sp,64
    8000104e:	84aa                	mv	s1,a0
    80001050:	89ae                	mv	s3,a1
    80001052:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80001054:	57fd                	li	a5,-1
    80001056:	83e9                	srli	a5,a5,0x1a
    80001058:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000105a:	4ab1                	li	s5,12
  if(va >= MAXVA)
    8000105c:	04b7f263          	bgeu	a5,a1,800010a0 <walk+0x66>
    panic("walk");
    80001060:	00007517          	auipc	a0,0x7
    80001064:	07050513          	addi	a0,a0,112 # 800080d0 <digits+0xb8>
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	4fe080e7          	jalr	1278(ra) # 80000566 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001070:	060b0663          	beqz	s6,800010dc <walk+0xa2>
    80001074:	00000097          	auipc	ra,0x0
    80001078:	ace080e7          	jalr	-1330(ra) # 80000b42 <kalloc>
    8000107c:	84aa                	mv	s1,a0
    8000107e:	c529                	beqz	a0,800010c8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001080:	6605                	lui	a2,0x1
    80001082:	4581                	li	a1,0
    80001084:	00000097          	auipc	ra,0x0
    80001088:	caa080e7          	jalr	-854(ra) # 80000d2e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000108c:	00c4d793          	srli	a5,s1,0xc
    80001090:	07aa                	slli	a5,a5,0xa
    80001092:	0017e793          	ori	a5,a5,1
    80001096:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000109a:	3a5d                	addiw	s4,s4,-9
    8000109c:	035a0063          	beq	s4,s5,800010bc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010a0:	0149d933          	srl	s2,s3,s4
    800010a4:	1ff97913          	andi	s2,s2,511
    800010a8:	090e                	slli	s2,s2,0x3
    800010aa:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010ac:	00093483          	ld	s1,0(s2)
    800010b0:	0014f793          	andi	a5,s1,1
    800010b4:	dfd5                	beqz	a5,80001070 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010b6:	80a9                	srli	s1,s1,0xa
    800010b8:	04b2                	slli	s1,s1,0xc
    800010ba:	b7c5                	j	8000109a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010bc:	00c9d513          	srli	a0,s3,0xc
    800010c0:	1ff57513          	andi	a0,a0,511
    800010c4:	050e                	slli	a0,a0,0x3
    800010c6:	9526                	add	a0,a0,s1
}
    800010c8:	70e2                	ld	ra,56(sp)
    800010ca:	7442                	ld	s0,48(sp)
    800010cc:	74a2                	ld	s1,40(sp)
    800010ce:	7902                	ld	s2,32(sp)
    800010d0:	69e2                	ld	s3,24(sp)
    800010d2:	6a42                	ld	s4,16(sp)
    800010d4:	6aa2                	ld	s5,8(sp)
    800010d6:	6b02                	ld	s6,0(sp)
    800010d8:	6121                	addi	sp,sp,64
    800010da:	8082                	ret
        return 0;
    800010dc:	4501                	li	a0,0
    800010de:	b7ed                	j	800010c8 <walk+0x8e>

00000000800010e0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010e0:	57fd                	li	a5,-1
    800010e2:	83e9                	srli	a5,a5,0x1a
    800010e4:	00b7f463          	bgeu	a5,a1,800010ec <walkaddr+0xc>
    return 0;
    800010e8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010ea:	8082                	ret
{
    800010ec:	1141                	addi	sp,sp,-16
    800010ee:	e406                	sd	ra,8(sp)
    800010f0:	e022                	sd	s0,0(sp)
    800010f2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010f4:	4601                	li	a2,0
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	f44080e7          	jalr	-188(ra) # 8000103a <walk>
  if(pte == 0)
    800010fe:	c105                	beqz	a0,8000111e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001100:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001102:	0117f693          	andi	a3,a5,17
    80001106:	4745                	li	a4,17
    return 0;
    80001108:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000110a:	00e68663          	beq	a3,a4,80001116 <walkaddr+0x36>
}
    8000110e:	60a2                	ld	ra,8(sp)
    80001110:	6402                	ld	s0,0(sp)
    80001112:	0141                	addi	sp,sp,16
    80001114:	8082                	ret
  pa = PTE2PA(*pte);
    80001116:	00a7d513          	srli	a0,a5,0xa
    8000111a:	0532                	slli	a0,a0,0xc
  return pa;
    8000111c:	bfcd                	j	8000110e <walkaddr+0x2e>
    return 0;
    8000111e:	4501                	li	a0,0
    80001120:	b7fd                	j	8000110e <walkaddr+0x2e>

0000000080001122 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001122:	715d                	addi	sp,sp,-80
    80001124:	e486                	sd	ra,72(sp)
    80001126:	e0a2                	sd	s0,64(sp)
    80001128:	fc26                	sd	s1,56(sp)
    8000112a:	f84a                	sd	s2,48(sp)
    8000112c:	f44e                	sd	s3,40(sp)
    8000112e:	f052                	sd	s4,32(sp)
    80001130:	ec56                	sd	s5,24(sp)
    80001132:	e85a                	sd	s6,16(sp)
    80001134:	e45e                	sd	s7,8(sp)
    80001136:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001138:	ce19                	beqz	a2,80001156 <mappages+0x34>
    8000113a:	8aaa                	mv	s5,a0
    8000113c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000113e:	79fd                	lui	s3,0xfffff
    80001140:	0135f7b3          	and	a5,a1,s3
  last = PGROUNDDOWN(va + size - 1);
    80001144:	15fd                	addi	a1,a1,-1
    80001146:	95b2                	add	a1,a1,a2
    80001148:	0135f9b3          	and	s3,a1,s3
  a = PGROUNDDOWN(va);
    8000114c:	893e                	mv	s2,a5
    8000114e:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001152:	6b85                	lui	s7,0x1
    80001154:	a015                	j	80001178 <mappages+0x56>
    panic("mappages: size");
    80001156:	00007517          	auipc	a0,0x7
    8000115a:	f8250513          	addi	a0,a0,-126 # 800080d8 <digits+0xc0>
    8000115e:	fffff097          	auipc	ra,0xfffff
    80001162:	408080e7          	jalr	1032(ra) # 80000566 <panic>
      panic("mappages: remap");
    80001166:	00007517          	auipc	a0,0x7
    8000116a:	f8250513          	addi	a0,a0,-126 # 800080e8 <digits+0xd0>
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	3f8080e7          	jalr	1016(ra) # 80000566 <panic>
    a += PGSIZE;
    80001176:	995e                	add	s2,s2,s7
  for(;;){
    80001178:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000117c:	4605                	li	a2,1
    8000117e:	85ca                	mv	a1,s2
    80001180:	8556                	mv	a0,s5
    80001182:	00000097          	auipc	ra,0x0
    80001186:	eb8080e7          	jalr	-328(ra) # 8000103a <walk>
    8000118a:	cd19                	beqz	a0,800011a8 <mappages+0x86>
    if(*pte & PTE_V)
    8000118c:	611c                	ld	a5,0(a0)
    8000118e:	8b85                	andi	a5,a5,1
    80001190:	fbf9                	bnez	a5,80001166 <mappages+0x44>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001192:	80b1                	srli	s1,s1,0xc
    80001194:	04aa                	slli	s1,s1,0xa
    80001196:	0164e4b3          	or	s1,s1,s6
    8000119a:	0014e493          	ori	s1,s1,1
    8000119e:	e104                	sd	s1,0(a0)
    if(a == last)
    800011a0:	fd391be3          	bne	s2,s3,80001176 <mappages+0x54>
    pa += PGSIZE;
  }
  return 0;
    800011a4:	4501                	li	a0,0
    800011a6:	a011                	j	800011aa <mappages+0x88>
      return -1;
    800011a8:	557d                	li	a0,-1
}
    800011aa:	60a6                	ld	ra,72(sp)
    800011ac:	6406                	ld	s0,64(sp)
    800011ae:	74e2                	ld	s1,56(sp)
    800011b0:	7942                	ld	s2,48(sp)
    800011b2:	79a2                	ld	s3,40(sp)
    800011b4:	7a02                	ld	s4,32(sp)
    800011b6:	6ae2                	ld	s5,24(sp)
    800011b8:	6b42                	ld	s6,16(sp)
    800011ba:	6ba2                	ld	s7,8(sp)
    800011bc:	6161                	addi	sp,sp,80
    800011be:	8082                	ret

00000000800011c0 <kvmmap>:
{
    800011c0:	1141                	addi	sp,sp,-16
    800011c2:	e406                	sd	ra,8(sp)
    800011c4:	e022                	sd	s0,0(sp)
    800011c6:	0800                	addi	s0,sp,16
    800011c8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011ca:	86b2                	mv	a3,a2
    800011cc:	863e                	mv	a2,a5
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f54080e7          	jalr	-172(ra) # 80001122 <mappages>
    800011d6:	e509                	bnez	a0,800011e0 <kvmmap+0x20>
}
    800011d8:	60a2                	ld	ra,8(sp)
    800011da:	6402                	ld	s0,0(sp)
    800011dc:	0141                	addi	sp,sp,16
    800011de:	8082                	ret
    panic("kvmmap");
    800011e0:	00007517          	auipc	a0,0x7
    800011e4:	f1850513          	addi	a0,a0,-232 # 800080f8 <digits+0xe0>
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	37e080e7          	jalr	894(ra) # 80000566 <panic>

00000000800011f0 <kvmmake>:
{
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	e04a                	sd	s2,0(sp)
    800011fa:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	946080e7          	jalr	-1722(ra) # 80000b42 <kalloc>
    80001204:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001206:	6605                	lui	a2,0x1
    80001208:	4581                	li	a1,0
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	b24080e7          	jalr	-1244(ra) # 80000d2e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001212:	4719                	li	a4,6
    80001214:	6685                	lui	a3,0x1
    80001216:	10000637          	lui	a2,0x10000
    8000121a:	100005b7          	lui	a1,0x10000
    8000121e:	8526                	mv	a0,s1
    80001220:	00000097          	auipc	ra,0x0
    80001224:	fa0080e7          	jalr	-96(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001228:	4719                	li	a4,6
    8000122a:	6685                	lui	a3,0x1
    8000122c:	10001637          	lui	a2,0x10001
    80001230:	100015b7          	lui	a1,0x10001
    80001234:	8526                	mv	a0,s1
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f8a080e7          	jalr	-118(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000123e:	4719                	li	a4,6
    80001240:	004006b7          	lui	a3,0x400
    80001244:	0c000637          	lui	a2,0xc000
    80001248:	0c0005b7          	lui	a1,0xc000
    8000124c:	8526                	mv	a0,s1
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	f72080e7          	jalr	-142(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001256:	00007917          	auipc	s2,0x7
    8000125a:	daa90913          	addi	s2,s2,-598 # 80008000 <etext>
    8000125e:	4729                	li	a4,10
    80001260:	80007697          	auipc	a3,0x80007
    80001264:	da068693          	addi	a3,a3,-608 # 8000 <_entry-0x7fff8000>
    80001268:	4605                	li	a2,1
    8000126a:	067e                	slli	a2,a2,0x1f
    8000126c:	85b2                	mv	a1,a2
    8000126e:	8526                	mv	a0,s1
    80001270:	00000097          	auipc	ra,0x0
    80001274:	f50080e7          	jalr	-176(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001278:	4719                	li	a4,6
    8000127a:	46c5                	li	a3,17
    8000127c:	06ee                	slli	a3,a3,0x1b
    8000127e:	412686b3          	sub	a3,a3,s2
    80001282:	864a                	mv	a2,s2
    80001284:	85ca                	mv	a1,s2
    80001286:	8526                	mv	a0,s1
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	f38080e7          	jalr	-200(ra) # 800011c0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001290:	4729                	li	a4,10
    80001292:	6685                	lui	a3,0x1
    80001294:	00006617          	auipc	a2,0x6
    80001298:	d6c60613          	addi	a2,a2,-660 # 80007000 <_trampoline>
    8000129c:	040005b7          	lui	a1,0x4000
    800012a0:	15fd                	addi	a1,a1,-1
    800012a2:	05b2                	slli	a1,a1,0xc
    800012a4:	8526                	mv	a0,s1
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f1a080e7          	jalr	-230(ra) # 800011c0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800012ae:	8526                	mv	a0,s1
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	616080e7          	jalr	1558(ra) # 800018c6 <proc_mapstacks>
}
    800012b8:	8526                	mv	a0,s1
    800012ba:	60e2                	ld	ra,24(sp)
    800012bc:	6442                	ld	s0,16(sp)
    800012be:	64a2                	ld	s1,8(sp)
    800012c0:	6902                	ld	s2,0(sp)
    800012c2:	6105                	addi	sp,sp,32
    800012c4:	8082                	ret

00000000800012c6 <kvminit>:
{
    800012c6:	1141                	addi	sp,sp,-16
    800012c8:	e406                	sd	ra,8(sp)
    800012ca:	e022                	sd	s0,0(sp)
    800012cc:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	f22080e7          	jalr	-222(ra) # 800011f0 <kvmmake>
    800012d6:	00008797          	auipc	a5,0x8
    800012da:	d4a7b523          	sd	a0,-694(a5) # 80009020 <kernel_pagetable>
}
    800012de:	60a2                	ld	ra,8(sp)
    800012e0:	6402                	ld	s0,0(sp)
    800012e2:	0141                	addi	sp,sp,16
    800012e4:	8082                	ret

00000000800012e6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012e6:	715d                	addi	sp,sp,-80
    800012e8:	e486                	sd	ra,72(sp)
    800012ea:	e0a2                	sd	s0,64(sp)
    800012ec:	fc26                	sd	s1,56(sp)
    800012ee:	f84a                	sd	s2,48(sp)
    800012f0:	f44e                	sd	s3,40(sp)
    800012f2:	f052                	sd	s4,32(sp)
    800012f4:	ec56                	sd	s5,24(sp)
    800012f6:	e85a                	sd	s6,16(sp)
    800012f8:	e45e                	sd	s7,8(sp)
    800012fa:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012fc:	6785                	lui	a5,0x1
    800012fe:	17fd                	addi	a5,a5,-1
    80001300:	8fed                	and	a5,a5,a1
    80001302:	e795                	bnez	a5,8000132e <uvmunmap+0x48>
    80001304:	8a2a                	mv	s4,a0
    80001306:	84ae                	mv	s1,a1
    80001308:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000130a:	0632                	slli	a2,a2,0xc
    8000130c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001310:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001312:	6b05                	lui	s6,0x1
    80001314:	0735e863          	bltu	a1,s3,80001384 <uvmunmap+0x9e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001318:	60a6                	ld	ra,72(sp)
    8000131a:	6406                	ld	s0,64(sp)
    8000131c:	74e2                	ld	s1,56(sp)
    8000131e:	7942                	ld	s2,48(sp)
    80001320:	79a2                	ld	s3,40(sp)
    80001322:	7a02                	ld	s4,32(sp)
    80001324:	6ae2                	ld	s5,24(sp)
    80001326:	6b42                	ld	s6,16(sp)
    80001328:	6ba2                	ld	s7,8(sp)
    8000132a:	6161                	addi	sp,sp,80
    8000132c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000132e:	00007517          	auipc	a0,0x7
    80001332:	dd250513          	addi	a0,a0,-558 # 80008100 <digits+0xe8>
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	230080e7          	jalr	560(ra) # 80000566 <panic>
      panic("uvmunmap: walk");
    8000133e:	00007517          	auipc	a0,0x7
    80001342:	dda50513          	addi	a0,a0,-550 # 80008118 <digits+0x100>
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	220080e7          	jalr	544(ra) # 80000566 <panic>
      panic("uvmunmap: not mapped");
    8000134e:	00007517          	auipc	a0,0x7
    80001352:	dda50513          	addi	a0,a0,-550 # 80008128 <digits+0x110>
    80001356:	fffff097          	auipc	ra,0xfffff
    8000135a:	210080e7          	jalr	528(ra) # 80000566 <panic>
      panic("uvmunmap: not a leaf");
    8000135e:	00007517          	auipc	a0,0x7
    80001362:	de250513          	addi	a0,a0,-542 # 80008140 <digits+0x128>
    80001366:	fffff097          	auipc	ra,0xfffff
    8000136a:	200080e7          	jalr	512(ra) # 80000566 <panic>
      uint64 pa = PTE2PA(*pte);
    8000136e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001370:	0532                	slli	a0,a0,0xc
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	6d0080e7          	jalr	1744(ra) # 80000a42 <kfree>
    *pte = 0;
    8000137a:	00093023          	sd	zero,0(s2)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000137e:	94da                	add	s1,s1,s6
    80001380:	f934fce3          	bgeu	s1,s3,80001318 <uvmunmap+0x32>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001384:	4601                	li	a2,0
    80001386:	85a6                	mv	a1,s1
    80001388:	8552                	mv	a0,s4
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	cb0080e7          	jalr	-848(ra) # 8000103a <walk>
    80001392:	892a                	mv	s2,a0
    80001394:	d54d                	beqz	a0,8000133e <uvmunmap+0x58>
    if((*pte & PTE_V) == 0)
    80001396:	6108                	ld	a0,0(a0)
    80001398:	00157793          	andi	a5,a0,1
    8000139c:	dbcd                	beqz	a5,8000134e <uvmunmap+0x68>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000139e:	3ff57793          	andi	a5,a0,1023
    800013a2:	fb778ee3          	beq	a5,s7,8000135e <uvmunmap+0x78>
    if(do_free){
    800013a6:	fc0a8ae3          	beqz	s5,8000137a <uvmunmap+0x94>
    800013aa:	b7d1                	j	8000136e <uvmunmap+0x88>

00000000800013ac <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013ac:	1101                	addi	sp,sp,-32
    800013ae:	ec06                	sd	ra,24(sp)
    800013b0:	e822                	sd	s0,16(sp)
    800013b2:	e426                	sd	s1,8(sp)
    800013b4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	78c080e7          	jalr	1932(ra) # 80000b42 <kalloc>
    800013be:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013c0:	c519                	beqz	a0,800013ce <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013c2:	6605                	lui	a2,0x1
    800013c4:	4581                	li	a1,0
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	968080e7          	jalr	-1688(ra) # 80000d2e <memset>
  return pagetable;
}
    800013ce:	8526                	mv	a0,s1
    800013d0:	60e2                	ld	ra,24(sp)
    800013d2:	6442                	ld	s0,16(sp)
    800013d4:	64a2                	ld	s1,8(sp)
    800013d6:	6105                	addi	sp,sp,32
    800013d8:	8082                	ret

00000000800013da <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013da:	7179                	addi	sp,sp,-48
    800013dc:	f406                	sd	ra,40(sp)
    800013de:	f022                	sd	s0,32(sp)
    800013e0:	ec26                	sd	s1,24(sp)
    800013e2:	e84a                	sd	s2,16(sp)
    800013e4:	e44e                	sd	s3,8(sp)
    800013e6:	e052                	sd	s4,0(sp)
    800013e8:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013ea:	6785                	lui	a5,0x1
    800013ec:	04f67863          	bgeu	a2,a5,8000143c <uvminit+0x62>
    800013f0:	8a2a                	mv	s4,a0
    800013f2:	89ae                	mv	s3,a1
    800013f4:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013f6:	fffff097          	auipc	ra,0xfffff
    800013fa:	74c080e7          	jalr	1868(ra) # 80000b42 <kalloc>
    800013fe:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001400:	6605                	lui	a2,0x1
    80001402:	4581                	li	a1,0
    80001404:	00000097          	auipc	ra,0x0
    80001408:	92a080e7          	jalr	-1750(ra) # 80000d2e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000140c:	4779                	li	a4,30
    8000140e:	86ca                	mv	a3,s2
    80001410:	6605                	lui	a2,0x1
    80001412:	4581                	li	a1,0
    80001414:	8552                	mv	a0,s4
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	d0c080e7          	jalr	-756(ra) # 80001122 <mappages>
  memmove(mem, src, sz);
    8000141e:	8626                	mv	a2,s1
    80001420:	85ce                	mv	a1,s3
    80001422:	854a                	mv	a0,s2
    80001424:	00000097          	auipc	ra,0x0
    80001428:	976080e7          	jalr	-1674(ra) # 80000d9a <memmove>
}
    8000142c:	70a2                	ld	ra,40(sp)
    8000142e:	7402                	ld	s0,32(sp)
    80001430:	64e2                	ld	s1,24(sp)
    80001432:	6942                	ld	s2,16(sp)
    80001434:	69a2                	ld	s3,8(sp)
    80001436:	6a02                	ld	s4,0(sp)
    80001438:	6145                	addi	sp,sp,48
    8000143a:	8082                	ret
    panic("inituvm: more than a page");
    8000143c:	00007517          	auipc	a0,0x7
    80001440:	d1c50513          	addi	a0,a0,-740 # 80008158 <digits+0x140>
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	122080e7          	jalr	290(ra) # 80000566 <panic>

000000008000144c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000144c:	1101                	addi	sp,sp,-32
    8000144e:	ec06                	sd	ra,24(sp)
    80001450:	e822                	sd	s0,16(sp)
    80001452:	e426                	sd	s1,8(sp)
    80001454:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001456:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001458:	00b67d63          	bgeu	a2,a1,80001472 <uvmdealloc+0x26>
    8000145c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000145e:	6605                	lui	a2,0x1
    80001460:	167d                	addi	a2,a2,-1
    80001462:	00c487b3          	add	a5,s1,a2
    80001466:	777d                	lui	a4,0xfffff
    80001468:	8ff9                	and	a5,a5,a4
    8000146a:	962e                	add	a2,a2,a1
    8000146c:	8e79                	and	a2,a2,a4
    8000146e:	00c7e863          	bltu	a5,a2,8000147e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001472:	8526                	mv	a0,s1
    80001474:	60e2                	ld	ra,24(sp)
    80001476:	6442                	ld	s0,16(sp)
    80001478:	64a2                	ld	s1,8(sp)
    8000147a:	6105                	addi	sp,sp,32
    8000147c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000147e:	8e1d                	sub	a2,a2,a5
    80001480:	8231                	srli	a2,a2,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001482:	4685                	li	a3,1
    80001484:	2601                	sext.w	a2,a2
    80001486:	85be                	mv	a1,a5
    80001488:	00000097          	auipc	ra,0x0
    8000148c:	e5e080e7          	jalr	-418(ra) # 800012e6 <uvmunmap>
    80001490:	b7cd                	j	80001472 <uvmdealloc+0x26>

0000000080001492 <uvmalloc>:
  if(newsz < oldsz)
    80001492:	0ab66163          	bltu	a2,a1,80001534 <uvmalloc+0xa2>
{
    80001496:	7139                	addi	sp,sp,-64
    80001498:	fc06                	sd	ra,56(sp)
    8000149a:	f822                	sd	s0,48(sp)
    8000149c:	f426                	sd	s1,40(sp)
    8000149e:	f04a                	sd	s2,32(sp)
    800014a0:	ec4e                	sd	s3,24(sp)
    800014a2:	e852                	sd	s4,16(sp)
    800014a4:	e456                	sd	s5,8(sp)
    800014a6:	0080                	addi	s0,sp,64
  oldsz = PGROUNDUP(oldsz);
    800014a8:	6a05                	lui	s4,0x1
    800014aa:	1a7d                	addi	s4,s4,-1
    800014ac:	95d2                	add	a1,a1,s4
    800014ae:	7a7d                	lui	s4,0xfffff
    800014b0:	0145fa33          	and	s4,a1,s4
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014b4:	08ca7263          	bgeu	s4,a2,80001538 <uvmalloc+0xa6>
    800014b8:	89b2                	mv	s3,a2
    800014ba:	8aaa                	mv	s5,a0
    800014bc:	8952                	mv	s2,s4
    mem = kalloc();
    800014be:	fffff097          	auipc	ra,0xfffff
    800014c2:	684080e7          	jalr	1668(ra) # 80000b42 <kalloc>
    800014c6:	84aa                	mv	s1,a0
    if(mem == 0){
    800014c8:	c51d                	beqz	a0,800014f6 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014ca:	6605                	lui	a2,0x1
    800014cc:	4581                	li	a1,0
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	860080e7          	jalr	-1952(ra) # 80000d2e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014d6:	4779                	li	a4,30
    800014d8:	86a6                	mv	a3,s1
    800014da:	6605                	lui	a2,0x1
    800014dc:	85ca                	mv	a1,s2
    800014de:	8556                	mv	a0,s5
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	c42080e7          	jalr	-958(ra) # 80001122 <mappages>
    800014e8:	e905                	bnez	a0,80001518 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014ea:	6785                	lui	a5,0x1
    800014ec:	993e                	add	s2,s2,a5
    800014ee:	fd3968e3          	bltu	s2,s3,800014be <uvmalloc+0x2c>
  return newsz;
    800014f2:	854e                	mv	a0,s3
    800014f4:	a809                	j	80001506 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014f6:	8652                	mv	a2,s4
    800014f8:	85ca                	mv	a1,s2
    800014fa:	8556                	mv	a0,s5
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	f50080e7          	jalr	-176(ra) # 8000144c <uvmdealloc>
      return 0;
    80001504:	4501                	li	a0,0
}
    80001506:	70e2                	ld	ra,56(sp)
    80001508:	7442                	ld	s0,48(sp)
    8000150a:	74a2                	ld	s1,40(sp)
    8000150c:	7902                	ld	s2,32(sp)
    8000150e:	69e2                	ld	s3,24(sp)
    80001510:	6a42                	ld	s4,16(sp)
    80001512:	6aa2                	ld	s5,8(sp)
    80001514:	6121                	addi	sp,sp,64
    80001516:	8082                	ret
      kfree(mem);
    80001518:	8526                	mv	a0,s1
    8000151a:	fffff097          	auipc	ra,0xfffff
    8000151e:	528080e7          	jalr	1320(ra) # 80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001522:	8652                	mv	a2,s4
    80001524:	85ca                	mv	a1,s2
    80001526:	8556                	mv	a0,s5
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	f24080e7          	jalr	-220(ra) # 8000144c <uvmdealloc>
      return 0;
    80001530:	4501                	li	a0,0
    80001532:	bfd1                	j	80001506 <uvmalloc+0x74>
    return oldsz;
    80001534:	852e                	mv	a0,a1
}
    80001536:	8082                	ret
  return newsz;
    80001538:	8532                	mv	a0,a2
    8000153a:	b7f1                	j	80001506 <uvmalloc+0x74>

000000008000153c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000153c:	7179                	addi	sp,sp,-48
    8000153e:	f406                	sd	ra,40(sp)
    80001540:	f022                	sd	s0,32(sp)
    80001542:	ec26                	sd	s1,24(sp)
    80001544:	e84a                	sd	s2,16(sp)
    80001546:	e44e                	sd	s3,8(sp)
    80001548:	e052                	sd	s4,0(sp)
    8000154a:	1800                	addi	s0,sp,48
    8000154c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000154e:	84aa                	mv	s1,a0
    80001550:	6905                	lui	s2,0x1
    80001552:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001554:	4985                	li	s3,1
    80001556:	a821                	j	8000156e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001558:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000155a:	0532                	slli	a0,a0,0xc
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	fe0080e7          	jalr	-32(ra) # 8000153c <freewalk>
      pagetable[i] = 0;
    80001564:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001568:	04a1                	addi	s1,s1,8
    8000156a:	03248163          	beq	s1,s2,8000158c <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000156e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001570:	00f57793          	andi	a5,a0,15
    80001574:	ff3782e3          	beq	a5,s3,80001558 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001578:	8905                	andi	a0,a0,1
    8000157a:	d57d                	beqz	a0,80001568 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000157c:	00007517          	auipc	a0,0x7
    80001580:	bfc50513          	addi	a0,a0,-1028 # 80008178 <digits+0x160>
    80001584:	fffff097          	auipc	ra,0xfffff
    80001588:	fe2080e7          	jalr	-30(ra) # 80000566 <panic>
    }
  }
  kfree((void*)pagetable);
    8000158c:	8552                	mv	a0,s4
    8000158e:	fffff097          	auipc	ra,0xfffff
    80001592:	4b4080e7          	jalr	1204(ra) # 80000a42 <kfree>
}
    80001596:	70a2                	ld	ra,40(sp)
    80001598:	7402                	ld	s0,32(sp)
    8000159a:	64e2                	ld	s1,24(sp)
    8000159c:	6942                	ld	s2,16(sp)
    8000159e:	69a2                	ld	s3,8(sp)
    800015a0:	6a02                	ld	s4,0(sp)
    800015a2:	6145                	addi	sp,sp,48
    800015a4:	8082                	ret

00000000800015a6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015a6:	1101                	addi	sp,sp,-32
    800015a8:	ec06                	sd	ra,24(sp)
    800015aa:	e822                	sd	s0,16(sp)
    800015ac:	e426                	sd	s1,8(sp)
    800015ae:	1000                	addi	s0,sp,32
    800015b0:	84aa                	mv	s1,a0
  if(sz > 0)
    800015b2:	e999                	bnez	a1,800015c8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015b4:	8526                	mv	a0,s1
    800015b6:	00000097          	auipc	ra,0x0
    800015ba:	f86080e7          	jalr	-122(ra) # 8000153c <freewalk>
}
    800015be:	60e2                	ld	ra,24(sp)
    800015c0:	6442                	ld	s0,16(sp)
    800015c2:	64a2                	ld	s1,8(sp)
    800015c4:	6105                	addi	sp,sp,32
    800015c6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015c8:	6605                	lui	a2,0x1
    800015ca:	167d                	addi	a2,a2,-1
    800015cc:	962e                	add	a2,a2,a1
    800015ce:	4685                	li	a3,1
    800015d0:	8231                	srli	a2,a2,0xc
    800015d2:	4581                	li	a1,0
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	d12080e7          	jalr	-750(ra) # 800012e6 <uvmunmap>
    800015dc:	bfe1                	j	800015b4 <uvmfree+0xe>

00000000800015de <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015de:	c679                	beqz	a2,800016ac <uvmcopy+0xce>
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	0880                	addi	s0,sp,80
    800015f6:	8ab2                	mv	s5,a2
    800015f8:	8b2e                	mv	s6,a1
    800015fa:	8baa                	mv	s7,a0
  for(i = 0; i < sz; i += PGSIZE){
    800015fc:	4901                	li	s2,0
    if((pte = walk(old, i, 0)) == 0)
    800015fe:	4601                	li	a2,0
    80001600:	85ca                	mv	a1,s2
    80001602:	855e                	mv	a0,s7
    80001604:	00000097          	auipc	ra,0x0
    80001608:	a36080e7          	jalr	-1482(ra) # 8000103a <walk>
    8000160c:	c531                	beqz	a0,80001658 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000160e:	6118                	ld	a4,0(a0)
    80001610:	00177793          	andi	a5,a4,1
    80001614:	cbb1                	beqz	a5,80001668 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001616:	00a75593          	srli	a1,a4,0xa
    8000161a:	00c59993          	slli	s3,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000161e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	520080e7          	jalr	1312(ra) # 80000b42 <kalloc>
    8000162a:	8a2a                	mv	s4,a0
    8000162c:	c939                	beqz	a0,80001682 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162e:	6605                	lui	a2,0x1
    80001630:	85ce                	mv	a1,s3
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	768080e7          	jalr	1896(ra) # 80000d9a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000163a:	8726                	mv	a4,s1
    8000163c:	86d2                	mv	a3,s4
    8000163e:	6605                	lui	a2,0x1
    80001640:	85ca                	mv	a1,s2
    80001642:	855a                	mv	a0,s6
    80001644:	00000097          	auipc	ra,0x0
    80001648:	ade080e7          	jalr	-1314(ra) # 80001122 <mappages>
    8000164c:	e515                	bnez	a0,80001678 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000164e:	6785                	lui	a5,0x1
    80001650:	993e                	add	s2,s2,a5
    80001652:	fb5966e3          	bltu	s2,s5,800015fe <uvmcopy+0x20>
    80001656:	a081                	j	80001696 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b3050513          	addi	a0,a0,-1232 # 80008188 <digits+0x170>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	f06080e7          	jalr	-250(ra) # 80000566 <panic>
      panic("uvmcopy: page not present");
    80001668:	00007517          	auipc	a0,0x7
    8000166c:	b4050513          	addi	a0,a0,-1216 # 800081a8 <digits+0x190>
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	ef6080e7          	jalr	-266(ra) # 80000566 <panic>
      kfree(mem);
    80001678:	8552                	mv	a0,s4
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	3c8080e7          	jalr	968(ra) # 80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001682:	4685                	li	a3,1
    80001684:	00c95613          	srli	a2,s2,0xc
    80001688:	4581                	li	a1,0
    8000168a:	855a                	mv	a0,s6
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	c5a080e7          	jalr	-934(ra) # 800012e6 <uvmunmap>
  return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6161                	addi	sp,sp,80
    800016aa:	8082                	ret
  return 0;
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret

00000000800016b0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016b0:	1141                	addi	sp,sp,-16
    800016b2:	e406                	sd	ra,8(sp)
    800016b4:	e022                	sd	s0,0(sp)
    800016b6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016b8:	4601                	li	a2,0
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	980080e7          	jalr	-1664(ra) # 8000103a <walk>
  if(pte == 0)
    800016c2:	c901                	beqz	a0,800016d2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016c4:	611c                	ld	a5,0(a0)
    800016c6:	9bbd                	andi	a5,a5,-17
    800016c8:	e11c                	sd	a5,0(a0)
}
    800016ca:	60a2                	ld	ra,8(sp)
    800016cc:	6402                	ld	s0,0(sp)
    800016ce:	0141                	addi	sp,sp,16
    800016d0:	8082                	ret
    panic("uvmclear");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	af650513          	addi	a0,a0,-1290 # 800081c8 <digits+0x1b0>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	e8c080e7          	jalr	-372(ra) # 80000566 <panic>

00000000800016e2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e2:	c6bd                	beqz	a3,80001750 <copyout+0x6e>
{
    800016e4:	715d                	addi	sp,sp,-80
    800016e6:	e486                	sd	ra,72(sp)
    800016e8:	e0a2                	sd	s0,64(sp)
    800016ea:	fc26                	sd	s1,56(sp)
    800016ec:	f84a                	sd	s2,48(sp)
    800016ee:	f44e                	sd	s3,40(sp)
    800016f0:	f052                	sd	s4,32(sp)
    800016f2:	ec56                	sd	s5,24(sp)
    800016f4:	e85a                	sd	s6,16(sp)
    800016f6:	e45e                	sd	s7,8(sp)
    800016f8:	e062                	sd	s8,0(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8baa                	mv	s7,a0
    800016fe:	8a2e                	mv	s4,a1
    80001700:	8ab2                	mv	s5,a2
    80001702:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001704:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001706:	6b05                	lui	s6,0x1
    80001708:	a015                	j	8000172c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000170a:	9552                	add	a0,a0,s4
    8000170c:	0004861b          	sext.w	a2,s1
    80001710:	85d6                	mv	a1,s5
    80001712:	41250533          	sub	a0,a0,s2
    80001716:	fffff097          	auipc	ra,0xfffff
    8000171a:	684080e7          	jalr	1668(ra) # 80000d9a <memmove>

    len -= n;
    8000171e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001722:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001724:	01690a33          	add	s4,s2,s6
  while(len > 0){
    80001728:	02098263          	beqz	s3,8000174c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000172c:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    80001730:	85ca                	mv	a1,s2
    80001732:	855e                	mv	a0,s7
    80001734:	00000097          	auipc	ra,0x0
    80001738:	9ac080e7          	jalr	-1620(ra) # 800010e0 <walkaddr>
    if(pa0 == 0)
    8000173c:	cd01                	beqz	a0,80001754 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000173e:	414904b3          	sub	s1,s2,s4
    80001742:	94da                	add	s1,s1,s6
    if(n > len)
    80001744:	fc99f3e3          	bgeu	s3,s1,8000170a <copyout+0x28>
    80001748:	84ce                	mv	s1,s3
    8000174a:	b7c1                	j	8000170a <copyout+0x28>
  }
  return 0;
    8000174c:	4501                	li	a0,0
    8000174e:	a021                	j	80001756 <copyout+0x74>
    80001750:	4501                	li	a0,0
}
    80001752:	8082                	ret
      return -1;
    80001754:	557d                	li	a0,-1
}
    80001756:	60a6                	ld	ra,72(sp)
    80001758:	6406                	ld	s0,64(sp)
    8000175a:	74e2                	ld	s1,56(sp)
    8000175c:	7942                	ld	s2,48(sp)
    8000175e:	79a2                	ld	s3,40(sp)
    80001760:	7a02                	ld	s4,32(sp)
    80001762:	6ae2                	ld	s5,24(sp)
    80001764:	6b42                	ld	s6,16(sp)
    80001766:	6ba2                	ld	s7,8(sp)
    80001768:	6c02                	ld	s8,0(sp)
    8000176a:	6161                	addi	sp,sp,80
    8000176c:	8082                	ret

000000008000176e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000176e:	caa5                	beqz	a3,800017de <copyin+0x70>
{
    80001770:	715d                	addi	sp,sp,-80
    80001772:	e486                	sd	ra,72(sp)
    80001774:	e0a2                	sd	s0,64(sp)
    80001776:	fc26                	sd	s1,56(sp)
    80001778:	f84a                	sd	s2,48(sp)
    8000177a:	f44e                	sd	s3,40(sp)
    8000177c:	f052                	sd	s4,32(sp)
    8000177e:	ec56                	sd	s5,24(sp)
    80001780:	e85a                	sd	s6,16(sp)
    80001782:	e45e                	sd	s7,8(sp)
    80001784:	e062                	sd	s8,0(sp)
    80001786:	0880                	addi	s0,sp,80
    80001788:	8baa                	mv	s7,a0
    8000178a:	8aae                	mv	s5,a1
    8000178c:	8a32                	mv	s4,a2
    8000178e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001790:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001792:	6b05                	lui	s6,0x1
    80001794:	a01d                	j	800017ba <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001796:	014505b3          	add	a1,a0,s4
    8000179a:	0004861b          	sext.w	a2,s1
    8000179e:	412585b3          	sub	a1,a1,s2
    800017a2:	8556                	mv	a0,s5
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	5f6080e7          	jalr	1526(ra) # 80000d9a <memmove>

    len -= n;
    800017ac:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017b0:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    800017b2:	01690a33          	add	s4,s2,s6
  while(len > 0){
    800017b6:	02098263          	beqz	s3,800017da <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017ba:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    800017be:	85ca                	mv	a1,s2
    800017c0:	855e                	mv	a0,s7
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	91e080e7          	jalr	-1762(ra) # 800010e0 <walkaddr>
    if(pa0 == 0)
    800017ca:	cd01                	beqz	a0,800017e2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017cc:	414904b3          	sub	s1,s2,s4
    800017d0:	94da                	add	s1,s1,s6
    if(n > len)
    800017d2:	fc99f2e3          	bgeu	s3,s1,80001796 <copyin+0x28>
    800017d6:	84ce                	mv	s1,s3
    800017d8:	bf7d                	j	80001796 <copyin+0x28>
  }
  return 0;
    800017da:	4501                	li	a0,0
    800017dc:	a021                	j	800017e4 <copyin+0x76>
    800017de:	4501                	li	a0,0
}
    800017e0:	8082                	ret
      return -1;
    800017e2:	557d                	li	a0,-1
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6c02                	ld	s8,0(sp)
    800017f8:	6161                	addi	sp,sp,80
    800017fa:	8082                	ret

00000000800017fc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017fc:	ced5                	beqz	a3,800018b8 <copyinstr+0xbc>
{
    800017fe:	715d                	addi	sp,sp,-80
    80001800:	e486                	sd	ra,72(sp)
    80001802:	e0a2                	sd	s0,64(sp)
    80001804:	fc26                	sd	s1,56(sp)
    80001806:	f84a                	sd	s2,48(sp)
    80001808:	f44e                	sd	s3,40(sp)
    8000180a:	f052                	sd	s4,32(sp)
    8000180c:	ec56                	sd	s5,24(sp)
    8000180e:	e85a                	sd	s6,16(sp)
    80001810:	e45e                	sd	s7,8(sp)
    80001812:	e062                	sd	s8,0(sp)
    80001814:	0880                	addi	s0,sp,80
    80001816:	8aaa                	mv	s5,a0
    80001818:	84ae                	mv	s1,a1
    8000181a:	8c32                	mv	s8,a2
    8000181c:	8bb6                	mv	s7,a3
    va0 = PGROUNDDOWN(srcva);
    8000181e:	7a7d                	lui	s4,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001820:	6985                	lui	s3,0x1
    80001822:	4b05                	li	s6,1
    80001824:	a801                	j	80001834 <copyinstr+0x38>
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
    80001826:	87a6                	mv	a5,s1
    80001828:	a085                	j	80001888 <copyinstr+0x8c>
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    8000182a:	84b2                	mv	s1,a2
    }

    srcva = va0 + PGSIZE;
    8000182c:	01390c33          	add	s8,s2,s3
  while(got_null == 0 && max > 0){
    80001830:	080b8063          	beqz	s7,800018b0 <copyinstr+0xb4>
    va0 = PGROUNDDOWN(srcva);
    80001834:	014c7933          	and	s2,s8,s4
    pa0 = walkaddr(pagetable, va0);
    80001838:	85ca                	mv	a1,s2
    8000183a:	8556                	mv	a0,s5
    8000183c:	00000097          	auipc	ra,0x0
    80001840:	8a4080e7          	jalr	-1884(ra) # 800010e0 <walkaddr>
    if(pa0 == 0)
    80001844:	c925                	beqz	a0,800018b4 <copyinstr+0xb8>
    n = PGSIZE - (srcva - va0);
    80001846:	41890633          	sub	a2,s2,s8
    8000184a:	964e                	add	a2,a2,s3
    if(n > max)
    8000184c:	00cbf363          	bgeu	s7,a2,80001852 <copyinstr+0x56>
    80001850:	865e                	mv	a2,s7
    char *p = (char *) (pa0 + (srcva - va0));
    80001852:	9562                	add	a0,a0,s8
    80001854:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001858:	da71                	beqz	a2,8000182c <copyinstr+0x30>
      if(*p == '\0'){
    8000185a:	00054703          	lbu	a4,0(a0)
    8000185e:	d761                	beqz	a4,80001826 <copyinstr+0x2a>
    80001860:	9626                	add	a2,a2,s1
    80001862:	87a6                	mv	a5,s1
    80001864:	1bfd                	addi	s7,s7,-1
    80001866:	009b86b3          	add	a3,s7,s1
    8000186a:	409b04b3          	sub	s1,s6,s1
    8000186e:	94aa                	add	s1,s1,a0
        *dst = *p;
    80001870:	00e78023          	sb	a4,0(a5) # 1000 <_entry-0x7ffff000>
      --max;
    80001874:	40f68bb3          	sub	s7,a3,a5
      p++;
    80001878:	00f48733          	add	a4,s1,a5
      dst++;
    8000187c:	0785                	addi	a5,a5,1
    while(n > 0){
    8000187e:	faf606e3          	beq	a2,a5,8000182a <copyinstr+0x2e>
      if(*p == '\0'){
    80001882:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8000>
    80001886:	f76d                	bnez	a4,80001870 <copyinstr+0x74>
        *dst = '\0';
    80001888:	00078023          	sb	zero,0(a5)
    8000188c:	4785                	li	a5,1
  }
  if(got_null){
    8000188e:	0017b513          	seqz	a0,a5
    80001892:	40a0053b          	negw	a0,a0
    80001896:	2501                	sext.w	a0,a0
    return 0;
  } else {
    return -1;
  }
}
    80001898:	60a6                	ld	ra,72(sp)
    8000189a:	6406                	ld	s0,64(sp)
    8000189c:	74e2                	ld	s1,56(sp)
    8000189e:	7942                	ld	s2,48(sp)
    800018a0:	79a2                	ld	s3,40(sp)
    800018a2:	7a02                	ld	s4,32(sp)
    800018a4:	6ae2                	ld	s5,24(sp)
    800018a6:	6b42                	ld	s6,16(sp)
    800018a8:	6ba2                	ld	s7,8(sp)
    800018aa:	6c02                	ld	s8,0(sp)
    800018ac:	6161                	addi	sp,sp,80
    800018ae:	8082                	ret
    800018b0:	4781                	li	a5,0
    800018b2:	bff1                	j	8000188e <copyinstr+0x92>
      return -1;
    800018b4:	557d                	li	a0,-1
    800018b6:	b7cd                	j	80001898 <copyinstr+0x9c>
  int got_null = 0;
    800018b8:	4781                	li	a5,0
  if(got_null){
    800018ba:	0017b513          	seqz	a0,a5
    800018be:	40a0053b          	negw	a0,a0
    800018c2:	2501                	sext.w	a0,a0
}
    800018c4:	8082                	ret

00000000800018c6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    800018c6:	7139                	addi	sp,sp,-64
    800018c8:	fc06                	sd	ra,56(sp)
    800018ca:	f822                	sd	s0,48(sp)
    800018cc:	f426                	sd	s1,40(sp)
    800018ce:	f04a                	sd	s2,32(sp)
    800018d0:	ec4e                	sd	s3,24(sp)
    800018d2:	e852                	sd	s4,16(sp)
    800018d4:	e456                	sd	s5,8(sp)
    800018d6:	e05a                	sd	s6,0(sp)
    800018d8:	0080                	addi	s0,sp,64
    800018da:	8b2a                	mv	s6,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800018dc:	00010497          	auipc	s1,0x10
    800018e0:	df448493          	addi	s1,s1,-524 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800018e4:	8aa6                	mv	s5,s1
    800018e6:	00006a17          	auipc	s4,0x6
    800018ea:	71aa0a13          	addi	s4,s4,1818 # 80008000 <etext>
    800018ee:	04000937          	lui	s2,0x4000
    800018f2:	197d                	addi	s2,s2,-1
    800018f4:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018f6:	00016997          	auipc	s3,0x16
    800018fa:	5da98993          	addi	s3,s3,1498 # 80017ed0 <tickslock>
    char *pa = kalloc();
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	244080e7          	jalr	580(ra) # 80000b42 <kalloc>
    80001906:	862a                	mv	a2,a0
    if(pa == 0)
    80001908:	c131                	beqz	a0,8000194c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000190a:	415485b3          	sub	a1,s1,s5
    8000190e:	8595                	srai	a1,a1,0x5
    80001910:	000a3783          	ld	a5,0(s4)
    80001914:	02f585b3          	mul	a1,a1,a5
    80001918:	2585                	addiw	a1,a1,1
    8000191a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000191e:	4719                	li	a4,6
    80001920:	6685                	lui	a3,0x1
    80001922:	40b905b3          	sub	a1,s2,a1
    80001926:	855a                	mv	a0,s6
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	898080e7          	jalr	-1896(ra) # 800011c0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001930:	1a048493          	addi	s1,s1,416
    80001934:	fd3495e3          	bne	s1,s3,800018fe <proc_mapstacks+0x38>
  }
}
    80001938:	70e2                	ld	ra,56(sp)
    8000193a:	7442                	ld	s0,48(sp)
    8000193c:	74a2                	ld	s1,40(sp)
    8000193e:	7902                	ld	s2,32(sp)
    80001940:	69e2                	ld	s3,24(sp)
    80001942:	6a42                	ld	s4,16(sp)
    80001944:	6aa2                	ld	s5,8(sp)
    80001946:	6b02                	ld	s6,0(sp)
    80001948:	6121                	addi	sp,sp,64
    8000194a:	8082                	ret
      panic("kalloc");
    8000194c:	00007517          	auipc	a0,0x7
    80001950:	8bc50513          	addi	a0,a0,-1860 # 80008208 <states.1771+0x30>
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	c12080e7          	jalr	-1006(ra) # 80000566 <panic>

000000008000195c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    8000195c:	7139                	addi	sp,sp,-64
    8000195e:	fc06                	sd	ra,56(sp)
    80001960:	f822                	sd	s0,48(sp)
    80001962:	f426                	sd	s1,40(sp)
    80001964:	f04a                	sd	s2,32(sp)
    80001966:	ec4e                	sd	s3,24(sp)
    80001968:	e852                	sd	s4,16(sp)
    8000196a:	e456                	sd	s5,8(sp)
    8000196c:	e05a                	sd	s6,0(sp)
    8000196e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001970:	00007597          	auipc	a1,0x7
    80001974:	8a058593          	addi	a1,a1,-1888 # 80008210 <states.1771+0x38>
    80001978:	00010517          	auipc	a0,0x10
    8000197c:	92850513          	addi	a0,a0,-1752 # 800112a0 <pid_lock>
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	222080e7          	jalr	546(ra) # 80000ba2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001988:	00007597          	auipc	a1,0x7
    8000198c:	89058593          	addi	a1,a1,-1904 # 80008218 <states.1771+0x40>
    80001990:	00010517          	auipc	a0,0x10
    80001994:	92850513          	addi	a0,a0,-1752 # 800112b8 <wait_lock>
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	20a080e7          	jalr	522(ra) # 80000ba2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019a0:	00010497          	auipc	s1,0x10
    800019a4:	d3048493          	addi	s1,s1,-720 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    800019a8:	00007b17          	auipc	s6,0x7
    800019ac:	880b0b13          	addi	s6,s6,-1920 # 80008228 <states.1771+0x50>
      p->kstack = KSTACK((int) (p - proc));
    800019b0:	8aa6                	mv	s5,s1
    800019b2:	00006a17          	auipc	s4,0x6
    800019b6:	64ea0a13          	addi	s4,s4,1614 # 80008000 <etext>
    800019ba:	04000937          	lui	s2,0x4000
    800019be:	197d                	addi	s2,s2,-1
    800019c0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019c2:	00016997          	auipc	s3,0x16
    800019c6:	50e98993          	addi	s3,s3,1294 # 80017ed0 <tickslock>
      initlock(&p->lock, "proc");
    800019ca:	85da                	mv	a1,s6
    800019cc:	8526                	mv	a0,s1
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	1d4080e7          	jalr	468(ra) # 80000ba2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    800019d6:	415487b3          	sub	a5,s1,s5
    800019da:	8795                	srai	a5,a5,0x5
    800019dc:	000a3703          	ld	a4,0(s4)
    800019e0:	02e787b3          	mul	a5,a5,a4
    800019e4:	2785                	addiw	a5,a5,1
    800019e6:	00d7979b          	slliw	a5,a5,0xd
    800019ea:	40f907b3          	sub	a5,s2,a5
    800019ee:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019f0:	1a048493          	addi	s1,s1,416
    800019f4:	fd349be3          	bne	s1,s3,800019ca <procinit+0x6e>
  }
}
    800019f8:	70e2                	ld	ra,56(sp)
    800019fa:	7442                	ld	s0,48(sp)
    800019fc:	74a2                	ld	s1,40(sp)
    800019fe:	7902                	ld	s2,32(sp)
    80001a00:	69e2                	ld	s3,24(sp)
    80001a02:	6a42                	ld	s4,16(sp)
    80001a04:	6aa2                	ld	s5,8(sp)
    80001a06:	6b02                	ld	s6,0(sp)
    80001a08:	6121                	addi	sp,sp,64
    80001a0a:	8082                	ret

0000000080001a0c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a0c:	1141                	addi	sp,sp,-16
    80001a0e:	e422                	sd	s0,8(sp)
    80001a10:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a12:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a14:	2501                	sext.w	a0,a0
    80001a16:	6422                	ld	s0,8(sp)
    80001a18:	0141                	addi	sp,sp,16
    80001a1a:	8082                	ret

0000000080001a1c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001a1c:	1141                	addi	sp,sp,-16
    80001a1e:	e422                	sd	s0,8(sp)
    80001a20:	0800                	addi	s0,sp,16
    80001a22:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a24:	2781                	sext.w	a5,a5
    80001a26:	079e                	slli	a5,a5,0x7
  return c;
}
    80001a28:	00010517          	auipc	a0,0x10
    80001a2c:	8a850513          	addi	a0,a0,-1880 # 800112d0 <cpus>
    80001a30:	953e                	add	a0,a0,a5
    80001a32:	6422                	ld	s0,8(sp)
    80001a34:	0141                	addi	sp,sp,16
    80001a36:	8082                	ret

0000000080001a38 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001a38:	1101                	addi	sp,sp,-32
    80001a3a:	ec06                	sd	ra,24(sp)
    80001a3c:	e822                	sd	s0,16(sp)
    80001a3e:	e426                	sd	s1,8(sp)
    80001a40:	1000                	addi	s0,sp,32
  push_off();
    80001a42:	fffff097          	auipc	ra,0xfffff
    80001a46:	1a4080e7          	jalr	420(ra) # 80000be6 <push_off>
    80001a4a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a4c:	2781                	sext.w	a5,a5
    80001a4e:	079e                	slli	a5,a5,0x7
    80001a50:	00010717          	auipc	a4,0x10
    80001a54:	85070713          	addi	a4,a4,-1968 # 800112a0 <pid_lock>
    80001a58:	97ba                	add	a5,a5,a4
    80001a5a:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a5c:	fffff097          	auipc	ra,0xfffff
    80001a60:	22a080e7          	jalr	554(ra) # 80000c86 <pop_off>
  return p;
}
    80001a64:	8526                	mv	a0,s1
    80001a66:	60e2                	ld	ra,24(sp)
    80001a68:	6442                	ld	s0,16(sp)
    80001a6a:	64a2                	ld	s1,8(sp)
    80001a6c:	6105                	addi	sp,sp,32
    80001a6e:	8082                	ret

0000000080001a70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a70:	1141                	addi	sp,sp,-16
    80001a72:	e406                	sd	ra,8(sp)
    80001a74:	e022                	sd	s0,0(sp)
    80001a76:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a78:	00000097          	auipc	ra,0x0
    80001a7c:	fc0080e7          	jalr	-64(ra) # 80001a38 <myproc>
    80001a80:	fffff097          	auipc	ra,0xfffff
    80001a84:	266080e7          	jalr	614(ra) # 80000ce6 <release>

  if (first) {
    80001a88:	00007797          	auipc	a5,0x7
    80001a8c:	ed878793          	addi	a5,a5,-296 # 80008960 <first.1734>
    80001a90:	439c                	lw	a5,0(a5)
    80001a92:	eb89                	bnez	a5,80001aa4 <forkret+0x34>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a94:	00001097          	auipc	ra,0x1
    80001a98:	f7e080e7          	jalr	-130(ra) # 80002a12 <usertrapret>
}
    80001a9c:	60a2                	ld	ra,8(sp)
    80001a9e:	6402                	ld	s0,0(sp)
    80001aa0:	0141                	addi	sp,sp,16
    80001aa2:	8082                	ret
    first = 0;
    80001aa4:	00007797          	auipc	a5,0x7
    80001aa8:	ea07ae23          	sw	zero,-324(a5) # 80008960 <first.1734>
    fsinit(ROOTDEV);
    80001aac:	4505                	li	a0,1
    80001aae:	00002097          	auipc	ra,0x2
    80001ab2:	f58080e7          	jalr	-168(ra) # 80003a06 <fsinit>
    80001ab6:	bff9                	j	80001a94 <forkret+0x24>

0000000080001ab8 <allocpid>:
allocpid() {
    80001ab8:	1101                	addi	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	e04a                	sd	s2,0(sp)
    80001ac2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ac4:	0000f917          	auipc	s2,0xf
    80001ac8:	7dc90913          	addi	s2,s2,2012 # 800112a0 <pid_lock>
    80001acc:	854a                	mv	a0,s2
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	164080e7          	jalr	356(ra) # 80000c32 <acquire>
  pid = nextpid;
    80001ad6:	00007797          	auipc	a5,0x7
    80001ada:	e8e78793          	addi	a5,a5,-370 # 80008964 <nextpid>
    80001ade:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ae0:	0014871b          	addiw	a4,s1,1
    80001ae4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ae6:	854a                	mv	a0,s2
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	1fe080e7          	jalr	510(ra) # 80000ce6 <release>
}
    80001af0:	8526                	mv	a0,s1
    80001af2:	60e2                	ld	ra,24(sp)
    80001af4:	6442                	ld	s0,16(sp)
    80001af6:	64a2                	ld	s1,8(sp)
    80001af8:	6902                	ld	s2,0(sp)
    80001afa:	6105                	addi	sp,sp,32
    80001afc:	8082                	ret

0000000080001afe <proc_pagetable>:
{
    80001afe:	1101                	addi	sp,sp,-32
    80001b00:	ec06                	sd	ra,24(sp)
    80001b02:	e822                	sd	s0,16(sp)
    80001b04:	e426                	sd	s1,8(sp)
    80001b06:	e04a                	sd	s2,0(sp)
    80001b08:	1000                	addi	s0,sp,32
    80001b0a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b0c:	00000097          	auipc	ra,0x0
    80001b10:	8a0080e7          	jalr	-1888(ra) # 800013ac <uvmcreate>
    80001b14:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b16:	c121                	beqz	a0,80001b56 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b18:	4729                	li	a4,10
    80001b1a:	00005697          	auipc	a3,0x5
    80001b1e:	4e668693          	addi	a3,a3,1254 # 80007000 <_trampoline>
    80001b22:	6605                	lui	a2,0x1
    80001b24:	040005b7          	lui	a1,0x4000
    80001b28:	15fd                	addi	a1,a1,-1
    80001b2a:	05b2                	slli	a1,a1,0xc
    80001b2c:	fffff097          	auipc	ra,0xfffff
    80001b30:	5f6080e7          	jalr	1526(ra) # 80001122 <mappages>
    80001b34:	02054863          	bltz	a0,80001b64 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b38:	4719                	li	a4,6
    80001b3a:	05893683          	ld	a3,88(s2)
    80001b3e:	6605                	lui	a2,0x1
    80001b40:	020005b7          	lui	a1,0x2000
    80001b44:	15fd                	addi	a1,a1,-1
    80001b46:	05b6                	slli	a1,a1,0xd
    80001b48:	8526                	mv	a0,s1
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	5d8080e7          	jalr	1496(ra) # 80001122 <mappages>
    80001b52:	02054163          	bltz	a0,80001b74 <proc_pagetable+0x76>
}
    80001b56:	8526                	mv	a0,s1
    80001b58:	60e2                	ld	ra,24(sp)
    80001b5a:	6442                	ld	s0,16(sp)
    80001b5c:	64a2                	ld	s1,8(sp)
    80001b5e:	6902                	ld	s2,0(sp)
    80001b60:	6105                	addi	sp,sp,32
    80001b62:	8082                	ret
    uvmfree(pagetable, 0);
    80001b64:	4581                	li	a1,0
    80001b66:	8526                	mv	a0,s1
    80001b68:	00000097          	auipc	ra,0x0
    80001b6c:	a3e080e7          	jalr	-1474(ra) # 800015a6 <uvmfree>
    return 0;
    80001b70:	4481                	li	s1,0
    80001b72:	b7d5                	j	80001b56 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b74:	4681                	li	a3,0
    80001b76:	4605                	li	a2,1
    80001b78:	040005b7          	lui	a1,0x4000
    80001b7c:	15fd                	addi	a1,a1,-1
    80001b7e:	05b2                	slli	a1,a1,0xc
    80001b80:	8526                	mv	a0,s1
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	764080e7          	jalr	1892(ra) # 800012e6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b8a:	4581                	li	a1,0
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	00000097          	auipc	ra,0x0
    80001b92:	a18080e7          	jalr	-1512(ra) # 800015a6 <uvmfree>
    return 0;
    80001b96:	4481                	li	s1,0
    80001b98:	bf7d                	j	80001b56 <proc_pagetable+0x58>

0000000080001b9a <proc_freepagetable>:
{
    80001b9a:	1101                	addi	sp,sp,-32
    80001b9c:	ec06                	sd	ra,24(sp)
    80001b9e:	e822                	sd	s0,16(sp)
    80001ba0:	e426                	sd	s1,8(sp)
    80001ba2:	e04a                	sd	s2,0(sp)
    80001ba4:	1000                	addi	s0,sp,32
    80001ba6:	84aa                	mv	s1,a0
    80001ba8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001baa:	4681                	li	a3,0
    80001bac:	4605                	li	a2,1
    80001bae:	040005b7          	lui	a1,0x4000
    80001bb2:	15fd                	addi	a1,a1,-1
    80001bb4:	05b2                	slli	a1,a1,0xc
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	730080e7          	jalr	1840(ra) # 800012e6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bbe:	4681                	li	a3,0
    80001bc0:	4605                	li	a2,1
    80001bc2:	020005b7          	lui	a1,0x2000
    80001bc6:	15fd                	addi	a1,a1,-1
    80001bc8:	05b6                	slli	a1,a1,0xd
    80001bca:	8526                	mv	a0,s1
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	71a080e7          	jalr	1818(ra) # 800012e6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001bd4:	85ca                	mv	a1,s2
    80001bd6:	8526                	mv	a0,s1
    80001bd8:	00000097          	auipc	ra,0x0
    80001bdc:	9ce080e7          	jalr	-1586(ra) # 800015a6 <uvmfree>
}
    80001be0:	60e2                	ld	ra,24(sp)
    80001be2:	6442                	ld	s0,16(sp)
    80001be4:	64a2                	ld	s1,8(sp)
    80001be6:	6902                	ld	s2,0(sp)
    80001be8:	6105                	addi	sp,sp,32
    80001bea:	8082                	ret

0000000080001bec <freeproc>:
{
    80001bec:	1101                	addi	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	e426                	sd	s1,8(sp)
    80001bf4:	1000                	addi	s0,sp,32
    80001bf6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bf8:	6d28                	ld	a0,88(a0)
    80001bfa:	c509                	beqz	a0,80001c04 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bfc:	fffff097          	auipc	ra,0xfffff
    80001c00:	e46080e7          	jalr	-442(ra) # 80000a42 <kfree>
  p->trapframe = 0;
    80001c04:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c08:	68a8                	ld	a0,80(s1)
    80001c0a:	c511                	beqz	a0,80001c16 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c0c:	64ac                	ld	a1,72(s1)
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	f8c080e7          	jalr	-116(ra) # 80001b9a <proc_freepagetable>
  p->pagetable = 0;
    80001c16:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c1a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c1e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c22:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c26:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c2a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c2e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c32:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c36:	0004ac23          	sw	zero,24(s1)
}
    80001c3a:	60e2                	ld	ra,24(sp)
    80001c3c:	6442                	ld	s0,16(sp)
    80001c3e:	64a2                	ld	s1,8(sp)
    80001c40:	6105                	addi	sp,sp,32
    80001c42:	8082                	ret

0000000080001c44 <allocproc>:
{
    80001c44:	1101                	addi	sp,sp,-32
    80001c46:	ec06                	sd	ra,24(sp)
    80001c48:	e822                	sd	s0,16(sp)
    80001c4a:	e426                	sd	s1,8(sp)
    80001c4c:	e04a                	sd	s2,0(sp)
    80001c4e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c50:	00010497          	auipc	s1,0x10
    80001c54:	a8048493          	addi	s1,s1,-1408 # 800116d0 <proc>
    80001c58:	00016917          	auipc	s2,0x16
    80001c5c:	27890913          	addi	s2,s2,632 # 80017ed0 <tickslock>
    acquire(&p->lock);
    80001c60:	8526                	mv	a0,s1
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	fd0080e7          	jalr	-48(ra) # 80000c32 <acquire>
    if(p->state == UNUSED) {
    80001c6a:	4c9c                	lw	a5,24(s1)
    80001c6c:	cf81                	beqz	a5,80001c84 <allocproc+0x40>
      release(&p->lock);
    80001c6e:	8526                	mv	a0,s1
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	076080e7          	jalr	118(ra) # 80000ce6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c78:	1a048493          	addi	s1,s1,416
    80001c7c:	ff2492e3          	bne	s1,s2,80001c60 <allocproc+0x1c>
  return 0;
    80001c80:	4481                	li	s1,0
    80001c82:	a849                	j	80001d14 <allocproc+0xd0>
  p->pid = allocpid();
    80001c84:	00000097          	auipc	ra,0x0
    80001c88:	e34080e7          	jalr	-460(ra) # 80001ab8 <allocpid>
    80001c8c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c8e:	4785                	li	a5,1
    80001c90:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c92:	fffff097          	auipc	ra,0xfffff
    80001c96:	eb0080e7          	jalr	-336(ra) # 80000b42 <kalloc>
    80001c9a:	892a                	mv	s2,a0
    80001c9c:	eca8                	sd	a0,88(s1)
    80001c9e:	c151                	beqz	a0,80001d22 <allocproc+0xde>
  p->pagetable = proc_pagetable(p);
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	e5c080e7          	jalr	-420(ra) # 80001afe <proc_pagetable>
    80001caa:	892a                	mv	s2,a0
    80001cac:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cae:	c551                	beqz	a0,80001d3a <allocproc+0xf6>
  memset(&p->context, 0, sizeof(p->context));
    80001cb0:	07000613          	li	a2,112
    80001cb4:	4581                	li	a1,0
    80001cb6:	06048513          	addi	a0,s1,96
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	074080e7          	jalr	116(ra) # 80000d2e <memset>
  p->context.ra = (uint64)forkret;
    80001cc2:	00000797          	auipc	a5,0x0
    80001cc6:	dae78793          	addi	a5,a5,-594 # 80001a70 <forkret>
    80001cca:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ccc:	60bc                	ld	a5,64(s1)
    80001cce:	6705                	lui	a4,0x1
    80001cd0:	97ba                	add	a5,a5,a4
    80001cd2:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001cd4:	1604a423          	sw	zero,360(s1)
  p->etime = -1;
    80001cd8:	57fd                	li	a5,-1
    80001cda:	16f4a823          	sw	a5,368(s1)
  p->ctime = ticks;
    80001cde:	00007797          	auipc	a5,0x7
    80001ce2:	35278793          	addi	a5,a5,850 # 80009030 <ticks>
    80001ce6:	439c                	lw	a5,0(a5)
    80001ce8:	16f4a623          	sw	a5,364(s1)
  p->ntime = 0;
    80001cec:	1604ac23          	sw	zero,376(s1)
  p->priority = 60;
    80001cf0:	03c00713          	li	a4,60
    80001cf4:	18e4a023          	sw	a4,384(s1)
  p->last_qtime = ticks;
    80001cf8:	18f4a423          	sw	a5,392(s1)
  p->queue = 0;
    80001cfc:	1804a223          	sw	zero,388(s1)
    p->qticks[x] = 0;
    80001d00:	1804a623          	sw	zero,396(s1)
    80001d04:	1804a823          	sw	zero,400(s1)
    80001d08:	1804aa23          	sw	zero,404(s1)
    80001d0c:	1804ac23          	sw	zero,408(s1)
    80001d10:	1804ae23          	sw	zero,412(s1)
}
    80001d14:	8526                	mv	a0,s1
    80001d16:	60e2                	ld	ra,24(sp)
    80001d18:	6442                	ld	s0,16(sp)
    80001d1a:	64a2                	ld	s1,8(sp)
    80001d1c:	6902                	ld	s2,0(sp)
    80001d1e:	6105                	addi	sp,sp,32
    80001d20:	8082                	ret
    freeproc(p);
    80001d22:	8526                	mv	a0,s1
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	ec8080e7          	jalr	-312(ra) # 80001bec <freeproc>
    release(&p->lock);
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	fffff097          	auipc	ra,0xfffff
    80001d32:	fb8080e7          	jalr	-72(ra) # 80000ce6 <release>
    return 0;
    80001d36:	84ca                	mv	s1,s2
    80001d38:	bff1                	j	80001d14 <allocproc+0xd0>
    freeproc(p);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	eb0080e7          	jalr	-336(ra) # 80001bec <freeproc>
    release(&p->lock);
    80001d44:	8526                	mv	a0,s1
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	fa0080e7          	jalr	-96(ra) # 80000ce6 <release>
    return 0;
    80001d4e:	84ca                	mv	s1,s2
    80001d50:	b7d1                	j	80001d14 <allocproc+0xd0>

0000000080001d52 <userinit>:
{
    80001d52:	1101                	addi	sp,sp,-32
    80001d54:	ec06                	sd	ra,24(sp)
    80001d56:	e822                	sd	s0,16(sp)
    80001d58:	e426                	sd	s1,8(sp)
    80001d5a:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	ee8080e7          	jalr	-280(ra) # 80001c44 <allocproc>
    80001d64:	84aa                	mv	s1,a0
  initproc = p;
    80001d66:	00007797          	auipc	a5,0x7
    80001d6a:	2ca7b123          	sd	a0,706(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d6e:	03400613          	li	a2,52
    80001d72:	00007597          	auipc	a1,0x7
    80001d76:	bfe58593          	addi	a1,a1,-1026 # 80008970 <initcode>
    80001d7a:	6928                	ld	a0,80(a0)
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	65e080e7          	jalr	1630(ra) # 800013da <uvminit>
  p->sz = PGSIZE;
    80001d84:	6785                	lui	a5,0x1
    80001d86:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d88:	6cb8                	ld	a4,88(s1)
    80001d8a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d8e:	6cb8                	ld	a4,88(s1)
    80001d90:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d92:	4641                	li	a2,16
    80001d94:	00006597          	auipc	a1,0x6
    80001d98:	49c58593          	addi	a1,a1,1180 # 80008230 <states.1771+0x58>
    80001d9c:	15848513          	addi	a0,s1,344
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	102080e7          	jalr	258(ra) # 80000ea2 <safestrcpy>
  p->cwd = namei("/");
    80001da8:	00006517          	auipc	a0,0x6
    80001dac:	49850513          	addi	a0,a0,1176 # 80008240 <states.1771+0x68>
    80001db0:	00002097          	auipc	ra,0x2
    80001db4:	690080e7          	jalr	1680(ra) # 80004440 <namei>
    80001db8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001dbc:	478d                	li	a5,3
    80001dbe:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001dc0:	8526                	mv	a0,s1
    80001dc2:	fffff097          	auipc	ra,0xfffff
    80001dc6:	f24080e7          	jalr	-220(ra) # 80000ce6 <release>
}
    80001dca:	60e2                	ld	ra,24(sp)
    80001dcc:	6442                	ld	s0,16(sp)
    80001dce:	64a2                	ld	s1,8(sp)
    80001dd0:	6105                	addi	sp,sp,32
    80001dd2:	8082                	ret

0000000080001dd4 <growproc>:
{
    80001dd4:	1101                	addi	sp,sp,-32
    80001dd6:	ec06                	sd	ra,24(sp)
    80001dd8:	e822                	sd	s0,16(sp)
    80001dda:	e426                	sd	s1,8(sp)
    80001ddc:	e04a                	sd	s2,0(sp)
    80001dde:	1000                	addi	s0,sp,32
    80001de0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	c56080e7          	jalr	-938(ra) # 80001a38 <myproc>
    80001dea:	892a                	mv	s2,a0
  sz = p->sz;
    80001dec:	652c                	ld	a1,72(a0)
    80001dee:	0005851b          	sext.w	a0,a1
  if(n > 0){
    80001df2:	00904f63          	bgtz	s1,80001e10 <growproc+0x3c>
  } else if(n < 0){
    80001df6:	0204cd63          	bltz	s1,80001e30 <growproc+0x5c>
  p->sz = sz;
    80001dfa:	1502                	slli	a0,a0,0x20
    80001dfc:	9101                	srli	a0,a0,0x20
    80001dfe:	04a93423          	sd	a0,72(s2)
  return 0;
    80001e02:	4501                	li	a0,0
}
    80001e04:	60e2                	ld	ra,24(sp)
    80001e06:	6442                	ld	s0,16(sp)
    80001e08:	64a2                	ld	s1,8(sp)
    80001e0a:	6902                	ld	s2,0(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001e10:	00a4863b          	addw	a2,s1,a0
    80001e14:	1602                	slli	a2,a2,0x20
    80001e16:	9201                	srli	a2,a2,0x20
    80001e18:	1582                	slli	a1,a1,0x20
    80001e1a:	9181                	srli	a1,a1,0x20
    80001e1c:	05093503          	ld	a0,80(s2)
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	672080e7          	jalr	1650(ra) # 80001492 <uvmalloc>
    80001e28:	2501                	sext.w	a0,a0
    80001e2a:	f961                	bnez	a0,80001dfa <growproc+0x26>
      return -1;
    80001e2c:	557d                	li	a0,-1
    80001e2e:	bfd9                	j	80001e04 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e30:	00a4863b          	addw	a2,s1,a0
    80001e34:	1602                	slli	a2,a2,0x20
    80001e36:	9201                	srli	a2,a2,0x20
    80001e38:	1582                	slli	a1,a1,0x20
    80001e3a:	9181                	srli	a1,a1,0x20
    80001e3c:	05093503          	ld	a0,80(s2)
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	60c080e7          	jalr	1548(ra) # 8000144c <uvmdealloc>
    80001e48:	2501                	sext.w	a0,a0
    80001e4a:	bf45                	j	80001dfa <growproc+0x26>

0000000080001e4c <fork>:
{
    80001e4c:	7179                	addi	sp,sp,-48
    80001e4e:	f406                	sd	ra,40(sp)
    80001e50:	f022                	sd	s0,32(sp)
    80001e52:	ec26                	sd	s1,24(sp)
    80001e54:	e84a                	sd	s2,16(sp)
    80001e56:	e44e                	sd	s3,8(sp)
    80001e58:	e052                	sd	s4,0(sp)
    80001e5a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	bdc080e7          	jalr	-1060(ra) # 80001a38 <myproc>
    80001e64:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	dde080e7          	jalr	-546(ra) # 80001c44 <allocproc>
    80001e6e:	12050363          	beqz	a0,80001f94 <fork+0x148>
    80001e72:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e74:	04893603          	ld	a2,72(s2)
    80001e78:	692c                	ld	a1,80(a0)
    80001e7a:	05093503          	ld	a0,80(s2)
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	760080e7          	jalr	1888(ra) # 800015de <uvmcopy>
    80001e86:	04054663          	bltz	a0,80001ed2 <fork+0x86>
  np->sz = p->sz;
    80001e8a:	04893783          	ld	a5,72(s2)
    80001e8e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e92:	05893683          	ld	a3,88(s2)
    80001e96:	87b6                	mv	a5,a3
    80001e98:	0589b703          	ld	a4,88(s3)
    80001e9c:	12068693          	addi	a3,a3,288
    80001ea0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ea4:	6788                	ld	a0,8(a5)
    80001ea6:	6b8c                	ld	a1,16(a5)
    80001ea8:	6f90                	ld	a2,24(a5)
    80001eaa:	01073023          	sd	a6,0(a4)
    80001eae:	e708                	sd	a0,8(a4)
    80001eb0:	eb0c                	sd	a1,16(a4)
    80001eb2:	ef10                	sd	a2,24(a4)
    80001eb4:	02078793          	addi	a5,a5,32
    80001eb8:	02070713          	addi	a4,a4,32
    80001ebc:	fed792e3          	bne	a5,a3,80001ea0 <fork+0x54>
  np->trapframe->a0 = 0;
    80001ec0:	0589b783          	ld	a5,88(s3)
    80001ec4:	0607b823          	sd	zero,112(a5)
    80001ec8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001ecc:	15000a13          	li	s4,336
    80001ed0:	a03d                	j	80001efe <fork+0xb2>
    freeproc(np);
    80001ed2:	854e                	mv	a0,s3
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	d18080e7          	jalr	-744(ra) # 80001bec <freeproc>
    release(&np->lock);
    80001edc:	854e                	mv	a0,s3
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	e08080e7          	jalr	-504(ra) # 80000ce6 <release>
    return -1;
    80001ee6:	5a7d                	li	s4,-1
    80001ee8:	a869                	j	80001f82 <fork+0x136>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eea:	00003097          	auipc	ra,0x3
    80001eee:	c1c080e7          	jalr	-996(ra) # 80004b06 <filedup>
    80001ef2:	009987b3          	add	a5,s3,s1
    80001ef6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001ef8:	04a1                	addi	s1,s1,8
    80001efa:	01448763          	beq	s1,s4,80001f08 <fork+0xbc>
    if(p->ofile[i])
    80001efe:	009907b3          	add	a5,s2,s1
    80001f02:	6388                	ld	a0,0(a5)
    80001f04:	f17d                	bnez	a0,80001eea <fork+0x9e>
    80001f06:	bfcd                	j	80001ef8 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001f08:	15093503          	ld	a0,336(s2)
    80001f0c:	00002097          	auipc	ra,0x2
    80001f10:	d36080e7          	jalr	-714(ra) # 80003c42 <idup>
    80001f14:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f18:	4641                	li	a2,16
    80001f1a:	15890593          	addi	a1,s2,344
    80001f1e:	15898513          	addi	a0,s3,344
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	f80080e7          	jalr	-128(ra) # 80000ea2 <safestrcpy>
  pid = np->pid;
    80001f2a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001f2e:	854e                	mv	a0,s3
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	db6080e7          	jalr	-586(ra) # 80000ce6 <release>
  acquire(&wait_lock);
    80001f38:	0000f497          	auipc	s1,0xf
    80001f3c:	38048493          	addi	s1,s1,896 # 800112b8 <wait_lock>
    80001f40:	8526                	mv	a0,s1
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	cf0080e7          	jalr	-784(ra) # 80000c32 <acquire>
  np->parent = p;
    80001f4a:	0329bc23          	sd	s2,56(s3)
  np->mask = p->mask; // copy mask
    80001f4e:	17c92783          	lw	a5,380(s2)
    80001f52:	16f9ae23          	sw	a5,380(s3)
  np->queue = p->queue;
    80001f56:	18492783          	lw	a5,388(s2)
    80001f5a:	18f9a223          	sw	a5,388(s3)
  release(&wait_lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	d86080e7          	jalr	-634(ra) # 80000ce6 <release>
  acquire(&np->lock);
    80001f68:	854e                	mv	a0,s3
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	cc8080e7          	jalr	-824(ra) # 80000c32 <acquire>
  np->state = RUNNABLE;
    80001f72:	478d                	li	a5,3
    80001f74:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f78:	854e                	mv	a0,s3
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	d6c080e7          	jalr	-660(ra) # 80000ce6 <release>
}
    80001f82:	8552                	mv	a0,s4
    80001f84:	70a2                	ld	ra,40(sp)
    80001f86:	7402                	ld	s0,32(sp)
    80001f88:	64e2                	ld	s1,24(sp)
    80001f8a:	6942                	ld	s2,16(sp)
    80001f8c:	69a2                	ld	s3,8(sp)
    80001f8e:	6a02                	ld	s4,0(sp)
    80001f90:	6145                	addi	sp,sp,48
    80001f92:	8082                	ret
    return -1;
    80001f94:	5a7d                	li	s4,-1
    80001f96:	b7f5                	j	80001f82 <fork+0x136>

0000000080001f98 <update_time>:
{
    80001f98:	7179                	addi	sp,sp,-48
    80001f9a:	f406                	sd	ra,40(sp)
    80001f9c:	f022                	sd	s0,32(sp)
    80001f9e:	ec26                	sd	s1,24(sp)
    80001fa0:	e84a                	sd	s2,16(sp)
    80001fa2:	e44e                	sd	s3,8(sp)
    80001fa4:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fa6:	0000f497          	auipc	s1,0xf
    80001faa:	72a48493          	addi	s1,s1,1834 # 800116d0 <proc>
    if (p->state == RUNNING) {
    80001fae:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fb0:	00016917          	auipc	s2,0x16
    80001fb4:	f2090913          	addi	s2,s2,-224 # 80017ed0 <tickslock>
    80001fb8:	a811                	j	80001fcc <update_time+0x34>
    release(&p->lock); 
    80001fba:	8526                	mv	a0,s1
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	d2a080e7          	jalr	-726(ra) # 80000ce6 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fc4:	1a048493          	addi	s1,s1,416
    80001fc8:	03248063          	beq	s1,s2,80001fe8 <update_time+0x50>
    acquire(&p->lock);
    80001fcc:	8526                	mv	a0,s1
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	c64080e7          	jalr	-924(ra) # 80000c32 <acquire>
    if (p->state == RUNNING) {
    80001fd6:	4c9c                	lw	a5,24(s1)
    80001fd8:	ff3791e3          	bne	a5,s3,80001fba <update_time+0x22>
      p->rtime++;
    80001fdc:	1684a783          	lw	a5,360(s1)
    80001fe0:	2785                	addiw	a5,a5,1
    80001fe2:	16f4a423          	sw	a5,360(s1)
    80001fe6:	bfd1                	j	80001fba <update_time+0x22>
}
    80001fe8:	70a2                	ld	ra,40(sp)
    80001fea:	7402                	ld	s0,32(sp)
    80001fec:	64e2                	ld	s1,24(sp)
    80001fee:	6942                	ld	s2,16(sp)
    80001ff0:	69a2                	ld	s3,8(sp)
    80001ff2:	6145                	addi	sp,sp,48
    80001ff4:	8082                	ret

0000000080001ff6 <scheduler>:
{
    80001ff6:	7139                	addi	sp,sp,-64
    80001ff8:	fc06                	sd	ra,56(sp)
    80001ffa:	f822                	sd	s0,48(sp)
    80001ffc:	f426                	sd	s1,40(sp)
    80001ffe:	f04a                	sd	s2,32(sp)
    80002000:	ec4e                	sd	s3,24(sp)
    80002002:	e852                	sd	s4,16(sp)
    80002004:	e456                	sd	s5,8(sp)
    80002006:	e05a                	sd	s6,0(sp)
    80002008:	0080                	addi	s0,sp,64
    8000200a:	8792                	mv	a5,tp
  int id = r_tp();
    8000200c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000200e:	00779a93          	slli	s5,a5,0x7
    80002012:	0000f717          	auipc	a4,0xf
    80002016:	28e70713          	addi	a4,a4,654 # 800112a0 <pid_lock>
    8000201a:	9756                	add	a4,a4,s5
    8000201c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002020:	0000f717          	auipc	a4,0xf
    80002024:	2b870713          	addi	a4,a4,696 # 800112d8 <cpus+0x8>
    80002028:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000202a:	498d                	li	s3,3
        p->state = RUNNING;
    8000202c:	4b11                	li	s6,4
        c->proc = p;
    8000202e:	079e                	slli	a5,a5,0x7
    80002030:	0000fa17          	auipc	s4,0xf
    80002034:	270a0a13          	addi	s4,s4,624 # 800112a0 <pid_lock>
    80002038:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000203a:	00016917          	auipc	s2,0x16
    8000203e:	e9690913          	addi	s2,s2,-362 # 80017ed0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002042:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002046:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000204a:	10079073          	csrw	sstatus,a5
    8000204e:	0000f497          	auipc	s1,0xf
    80002052:	68248493          	addi	s1,s1,1666 # 800116d0 <proc>
    80002056:	a03d                	j	80002084 <scheduler+0x8e>
        p->state = RUNNING;
    80002058:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000205c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002060:	06048593          	addi	a1,s1,96
    80002064:	8556                	mv	a0,s5
    80002066:	00001097          	auipc	ra,0x1
    8000206a:	902080e7          	jalr	-1790(ra) # 80002968 <swtch>
        c->proc = 0;
    8000206e:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80002072:	8526                	mv	a0,s1
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	c72080e7          	jalr	-910(ra) # 80000ce6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000207c:	1a048493          	addi	s1,s1,416
    80002080:	fd2481e3          	beq	s1,s2,80002042 <scheduler+0x4c>
      acquire(&p->lock);
    80002084:	8526                	mv	a0,s1
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	bac080e7          	jalr	-1108(ra) # 80000c32 <acquire>
      if(p->state == RUNNABLE) {
    8000208e:	4c9c                	lw	a5,24(s1)
    80002090:	ff3791e3          	bne	a5,s3,80002072 <scheduler+0x7c>
    80002094:	b7d1                	j	80002058 <scheduler+0x62>

0000000080002096 <sched>:
{
    80002096:	7179                	addi	sp,sp,-48
    80002098:	f406                	sd	ra,40(sp)
    8000209a:	f022                	sd	s0,32(sp)
    8000209c:	ec26                	sd	s1,24(sp)
    8000209e:	e84a                	sd	s2,16(sp)
    800020a0:	e44e                	sd	s3,8(sp)
    800020a2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800020a4:	00000097          	auipc	ra,0x0
    800020a8:	994080e7          	jalr	-1644(ra) # 80001a38 <myproc>
    800020ac:	892a                	mv	s2,a0
  if(!holding(&p->lock))
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	b0a080e7          	jalr	-1270(ra) # 80000bb8 <holding>
    800020b6:	cd25                	beqz	a0,8000212e <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020b8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020ba:	2781                	sext.w	a5,a5
    800020bc:	079e                	slli	a5,a5,0x7
    800020be:	0000f717          	auipc	a4,0xf
    800020c2:	1e270713          	addi	a4,a4,482 # 800112a0 <pid_lock>
    800020c6:	97ba                	add	a5,a5,a4
    800020c8:	0a87a703          	lw	a4,168(a5)
    800020cc:	4785                	li	a5,1
    800020ce:	06f71863          	bne	a4,a5,8000213e <sched+0xa8>
  if(p->state == RUNNING)
    800020d2:	01892703          	lw	a4,24(s2)
    800020d6:	4791                	li	a5,4
    800020d8:	06f70b63          	beq	a4,a5,8000214e <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020dc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020e0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020e2:	efb5                	bnez	a5,8000215e <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020e4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020e6:	0000f497          	auipc	s1,0xf
    800020ea:	1ba48493          	addi	s1,s1,442 # 800112a0 <pid_lock>
    800020ee:	2781                	sext.w	a5,a5
    800020f0:	079e                	slli	a5,a5,0x7
    800020f2:	97a6                	add	a5,a5,s1
    800020f4:	0ac7a983          	lw	s3,172(a5)
    800020f8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020fa:	2781                	sext.w	a5,a5
    800020fc:	079e                	slli	a5,a5,0x7
    800020fe:	0000f597          	auipc	a1,0xf
    80002102:	1da58593          	addi	a1,a1,474 # 800112d8 <cpus+0x8>
    80002106:	95be                	add	a1,a1,a5
    80002108:	06090513          	addi	a0,s2,96
    8000210c:	00001097          	auipc	ra,0x1
    80002110:	85c080e7          	jalr	-1956(ra) # 80002968 <swtch>
    80002114:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002116:	2781                	sext.w	a5,a5
    80002118:	079e                	slli	a5,a5,0x7
    8000211a:	97a6                	add	a5,a5,s1
    8000211c:	0b37a623          	sw	s3,172(a5)
}
    80002120:	70a2                	ld	ra,40(sp)
    80002122:	7402                	ld	s0,32(sp)
    80002124:	64e2                	ld	s1,24(sp)
    80002126:	6942                	ld	s2,16(sp)
    80002128:	69a2                	ld	s3,8(sp)
    8000212a:	6145                	addi	sp,sp,48
    8000212c:	8082                	ret
    panic("sched p->lock");
    8000212e:	00006517          	auipc	a0,0x6
    80002132:	11a50513          	addi	a0,a0,282 # 80008248 <states.1771+0x70>
    80002136:	ffffe097          	auipc	ra,0xffffe
    8000213a:	430080e7          	jalr	1072(ra) # 80000566 <panic>
    panic("sched locks");
    8000213e:	00006517          	auipc	a0,0x6
    80002142:	11a50513          	addi	a0,a0,282 # 80008258 <states.1771+0x80>
    80002146:	ffffe097          	auipc	ra,0xffffe
    8000214a:	420080e7          	jalr	1056(ra) # 80000566 <panic>
    panic("sched running");
    8000214e:	00006517          	auipc	a0,0x6
    80002152:	11a50513          	addi	a0,a0,282 # 80008268 <states.1771+0x90>
    80002156:	ffffe097          	auipc	ra,0xffffe
    8000215a:	410080e7          	jalr	1040(ra) # 80000566 <panic>
    panic("sched interruptible");
    8000215e:	00006517          	auipc	a0,0x6
    80002162:	11a50513          	addi	a0,a0,282 # 80008278 <states.1771+0xa0>
    80002166:	ffffe097          	auipc	ra,0xffffe
    8000216a:	400080e7          	jalr	1024(ra) # 80000566 <panic>

000000008000216e <yield>:
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	e426                	sd	s1,8(sp)
    80002176:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	8c0080e7          	jalr	-1856(ra) # 80001a38 <myproc>
    80002180:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	ab0080e7          	jalr	-1360(ra) # 80000c32 <acquire>
  p->state = RUNNABLE;
    8000218a:	478d                	li	a5,3
    8000218c:	cc9c                	sw	a5,24(s1)
  sched();
    8000218e:	00000097          	auipc	ra,0x0
    80002192:	f08080e7          	jalr	-248(ra) # 80002096 <sched>
  release(&p->lock);
    80002196:	8526                	mv	a0,s1
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	b4e080e7          	jalr	-1202(ra) # 80000ce6 <release>
}
    800021a0:	60e2                	ld	ra,24(sp)
    800021a2:	6442                	ld	s0,16(sp)
    800021a4:	64a2                	ld	s1,8(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800021aa:	7179                	addi	sp,sp,-48
    800021ac:	f406                	sd	ra,40(sp)
    800021ae:	f022                	sd	s0,32(sp)
    800021b0:	ec26                	sd	s1,24(sp)
    800021b2:	e84a                	sd	s2,16(sp)
    800021b4:	e44e                	sd	s3,8(sp)
    800021b6:	1800                	addi	s0,sp,48
    800021b8:	89aa                	mv	s3,a0
    800021ba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021bc:	00000097          	auipc	ra,0x0
    800021c0:	87c080e7          	jalr	-1924(ra) # 80001a38 <myproc>
    800021c4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	a6c080e7          	jalr	-1428(ra) # 80000c32 <acquire>
  release(lk);
    800021ce:	854a                	mv	a0,s2
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	b16080e7          	jalr	-1258(ra) # 80000ce6 <release>

  // Go to sleep.
  p->chan = chan;
    800021d8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800021dc:	4789                	li	a5,2
    800021de:	cc9c                	sw	a5,24(s1)
  p->stime = ticks;
    800021e0:	00007797          	auipc	a5,0x7
    800021e4:	e5078793          	addi	a5,a5,-432 # 80009030 <ticks>
    800021e8:	439c                	lw	a5,0(a5)
    800021ea:	16f4aa23          	sw	a5,372(s1)
  sched();
    800021ee:	00000097          	auipc	ra,0x0
    800021f2:	ea8080e7          	jalr	-344(ra) # 80002096 <sched>

  // Tidy up.
  p->chan = 0;
    800021f6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800021fa:	8526                	mv	a0,s1
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	aea080e7          	jalr	-1302(ra) # 80000ce6 <release>
  acquire(lk);
    80002204:	854a                	mv	a0,s2
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	a2c080e7          	jalr	-1492(ra) # 80000c32 <acquire>
}
    8000220e:	70a2                	ld	ra,40(sp)
    80002210:	7402                	ld	s0,32(sp)
    80002212:	64e2                	ld	s1,24(sp)
    80002214:	6942                	ld	s2,16(sp)
    80002216:	69a2                	ld	s3,8(sp)
    80002218:	6145                	addi	sp,sp,48
    8000221a:	8082                	ret

000000008000221c <wait>:
{
    8000221c:	715d                	addi	sp,sp,-80
    8000221e:	e486                	sd	ra,72(sp)
    80002220:	e0a2                	sd	s0,64(sp)
    80002222:	fc26                	sd	s1,56(sp)
    80002224:	f84a                	sd	s2,48(sp)
    80002226:	f44e                	sd	s3,40(sp)
    80002228:	f052                	sd	s4,32(sp)
    8000222a:	ec56                	sd	s5,24(sp)
    8000222c:	e85a                	sd	s6,16(sp)
    8000222e:	e45e                	sd	s7,8(sp)
    80002230:	e062                	sd	s8,0(sp)
    80002232:	0880                	addi	s0,sp,80
    80002234:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	802080e7          	jalr	-2046(ra) # 80001a38 <myproc>
    8000223e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002240:	0000f517          	auipc	a0,0xf
    80002244:	07850513          	addi	a0,a0,120 # 800112b8 <wait_lock>
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	9ea080e7          	jalr	-1558(ra) # 80000c32 <acquire>
    havekids = 0;
    80002250:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    80002252:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80002254:	00016997          	auipc	s3,0x16
    80002258:	c7c98993          	addi	s3,s3,-900 # 80017ed0 <tickslock>
        havekids = 1;
    8000225c:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000225e:	0000fc17          	auipc	s8,0xf
    80002262:	05ac0c13          	addi	s8,s8,90 # 800112b8 <wait_lock>
    havekids = 0;
    80002266:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    80002268:	0000f497          	auipc	s1,0xf
    8000226c:	46848493          	addi	s1,s1,1128 # 800116d0 <proc>
    80002270:	a0bd                	j	800022de <wait+0xc2>
          pid = np->pid;
    80002272:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002276:	000b8e63          	beqz	s7,80002292 <wait+0x76>
    8000227a:	4691                	li	a3,4
    8000227c:	02c48613          	addi	a2,s1,44
    80002280:	85de                	mv	a1,s7
    80002282:	05093503          	ld	a0,80(s2)
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	45c080e7          	jalr	1116(ra) # 800016e2 <copyout>
    8000228e:	02054563          	bltz	a0,800022b8 <wait+0x9c>
          freeproc(np);
    80002292:	8526                	mv	a0,s1
    80002294:	00000097          	auipc	ra,0x0
    80002298:	958080e7          	jalr	-1704(ra) # 80001bec <freeproc>
          release(&np->lock);
    8000229c:	8526                	mv	a0,s1
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	a48080e7          	jalr	-1464(ra) # 80000ce6 <release>
          release(&wait_lock);
    800022a6:	0000f517          	auipc	a0,0xf
    800022aa:	01250513          	addi	a0,a0,18 # 800112b8 <wait_lock>
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	a38080e7          	jalr	-1480(ra) # 80000ce6 <release>
          return pid;
    800022b6:	a09d                	j	8000231c <wait+0x100>
            release(&np->lock);
    800022b8:	8526                	mv	a0,s1
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	a2c080e7          	jalr	-1492(ra) # 80000ce6 <release>
            release(&wait_lock);
    800022c2:	0000f517          	auipc	a0,0xf
    800022c6:	ff650513          	addi	a0,a0,-10 # 800112b8 <wait_lock>
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	a1c080e7          	jalr	-1508(ra) # 80000ce6 <release>
            return -1;
    800022d2:	59fd                	li	s3,-1
    800022d4:	a0a1                	j	8000231c <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800022d6:	1a048493          	addi	s1,s1,416
    800022da:	03348463          	beq	s1,s3,80002302 <wait+0xe6>
      if(np->parent == p){
    800022de:	7c9c                	ld	a5,56(s1)
    800022e0:	ff279be3          	bne	a5,s2,800022d6 <wait+0xba>
        acquire(&np->lock);
    800022e4:	8526                	mv	a0,s1
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	94c080e7          	jalr	-1716(ra) # 80000c32 <acquire>
        if(np->state == ZOMBIE){
    800022ee:	4c9c                	lw	a5,24(s1)
    800022f0:	f94781e3          	beq	a5,s4,80002272 <wait+0x56>
        release(&np->lock);
    800022f4:	8526                	mv	a0,s1
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	9f0080e7          	jalr	-1552(ra) # 80000ce6 <release>
        havekids = 1;
    800022fe:	8756                	mv	a4,s5
    80002300:	bfd9                	j	800022d6 <wait+0xba>
    if(!havekids || p->killed){
    80002302:	c701                	beqz	a4,8000230a <wait+0xee>
    80002304:	02892783          	lw	a5,40(s2)
    80002308:	c79d                	beqz	a5,80002336 <wait+0x11a>
      release(&wait_lock);
    8000230a:	0000f517          	auipc	a0,0xf
    8000230e:	fae50513          	addi	a0,a0,-82 # 800112b8 <wait_lock>
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	9d4080e7          	jalr	-1580(ra) # 80000ce6 <release>
      return -1;
    8000231a:	59fd                	li	s3,-1
}
    8000231c:	854e                	mv	a0,s3
    8000231e:	60a6                	ld	ra,72(sp)
    80002320:	6406                	ld	s0,64(sp)
    80002322:	74e2                	ld	s1,56(sp)
    80002324:	7942                	ld	s2,48(sp)
    80002326:	79a2                	ld	s3,40(sp)
    80002328:	7a02                	ld	s4,32(sp)
    8000232a:	6ae2                	ld	s5,24(sp)
    8000232c:	6b42                	ld	s6,16(sp)
    8000232e:	6ba2                	ld	s7,8(sp)
    80002330:	6c02                	ld	s8,0(sp)
    80002332:	6161                	addi	sp,sp,80
    80002334:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002336:	85e2                	mv	a1,s8
    80002338:	854a                	mv	a0,s2
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	e70080e7          	jalr	-400(ra) # 800021aa <sleep>
    havekids = 0;
    80002342:	b715                	j	80002266 <wait+0x4a>

0000000080002344 <waitx>:
{
    80002344:	711d                	addi	sp,sp,-96
    80002346:	ec86                	sd	ra,88(sp)
    80002348:	e8a2                	sd	s0,80(sp)
    8000234a:	e4a6                	sd	s1,72(sp)
    8000234c:	e0ca                	sd	s2,64(sp)
    8000234e:	fc4e                	sd	s3,56(sp)
    80002350:	f852                	sd	s4,48(sp)
    80002352:	f456                	sd	s5,40(sp)
    80002354:	f05a                	sd	s6,32(sp)
    80002356:	ec5e                	sd	s7,24(sp)
    80002358:	e862                	sd	s8,16(sp)
    8000235a:	e466                	sd	s9,8(sp)
    8000235c:	e06a                	sd	s10,0(sp)
    8000235e:	1080                	addi	s0,sp,96
    80002360:	8baa                	mv	s7,a0
    80002362:	8cae                	mv	s9,a1
    80002364:	8c32                	mv	s8,a2
  struct proc *p = myproc();
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	6d2080e7          	jalr	1746(ra) # 80001a38 <myproc>
    8000236e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002370:	0000f517          	auipc	a0,0xf
    80002374:	f4850513          	addi	a0,a0,-184 # 800112b8 <wait_lock>
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	8ba080e7          	jalr	-1862(ra) # 80000c32 <acquire>
    havekids = 0;
    80002380:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    80002382:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80002384:	00016997          	auipc	s3,0x16
    80002388:	b4c98993          	addi	s3,s3,-1204 # 80017ed0 <tickslock>
        havekids = 1;
    8000238c:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000238e:	0000fd17          	auipc	s10,0xf
    80002392:	f2ad0d13          	addi	s10,s10,-214 # 800112b8 <wait_lock>
    havekids = 0;
    80002396:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    80002398:	0000f497          	auipc	s1,0xf
    8000239c:	33848493          	addi	s1,s1,824 # 800116d0 <proc>
    800023a0:	a059                	j	80002426 <waitx+0xe2>
          pid = np->pid;
    800023a2:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    800023a6:	1684a703          	lw	a4,360(s1)
    800023aa:	00eca023          	sw	a4,0(s9)
          *wtime = np->etime - np->ctime - np->rtime;
    800023ae:	16c4a783          	lw	a5,364(s1)
    800023b2:	9f3d                	addw	a4,a4,a5
    800023b4:	1704a783          	lw	a5,368(s1)
    800023b8:	9f99                	subw	a5,a5,a4
    800023ba:	00fc2023          	sw	a5,0(s8)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800023be:	000b8e63          	beqz	s7,800023da <waitx+0x96>
    800023c2:	4691                	li	a3,4
    800023c4:	02c48613          	addi	a2,s1,44
    800023c8:	85de                	mv	a1,s7
    800023ca:	05093503          	ld	a0,80(s2)
    800023ce:	fffff097          	auipc	ra,0xfffff
    800023d2:	314080e7          	jalr	788(ra) # 800016e2 <copyout>
    800023d6:	02054563          	bltz	a0,80002400 <waitx+0xbc>
          freeproc(np);
    800023da:	8526                	mv	a0,s1
    800023dc:	00000097          	auipc	ra,0x0
    800023e0:	810080e7          	jalr	-2032(ra) # 80001bec <freeproc>
          release(&np->lock);
    800023e4:	8526                	mv	a0,s1
    800023e6:	fffff097          	auipc	ra,0xfffff
    800023ea:	900080e7          	jalr	-1792(ra) # 80000ce6 <release>
          release(&wait_lock);
    800023ee:	0000f517          	auipc	a0,0xf
    800023f2:	eca50513          	addi	a0,a0,-310 # 800112b8 <wait_lock>
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	8f0080e7          	jalr	-1808(ra) # 80000ce6 <release>
          return pid;
    800023fe:	a09d                	j	80002464 <waitx+0x120>
            release(&np->lock);
    80002400:	8526                	mv	a0,s1
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	8e4080e7          	jalr	-1820(ra) # 80000ce6 <release>
            release(&wait_lock);
    8000240a:	0000f517          	auipc	a0,0xf
    8000240e:	eae50513          	addi	a0,a0,-338 # 800112b8 <wait_lock>
    80002412:	fffff097          	auipc	ra,0xfffff
    80002416:	8d4080e7          	jalr	-1836(ra) # 80000ce6 <release>
            return -1;
    8000241a:	59fd                	li	s3,-1
    8000241c:	a0a1                	j	80002464 <waitx+0x120>
    for(np = proc; np < &proc[NPROC]; np++){
    8000241e:	1a048493          	addi	s1,s1,416
    80002422:	03348463          	beq	s1,s3,8000244a <waitx+0x106>
      if(np->parent == p){
    80002426:	7c9c                	ld	a5,56(s1)
    80002428:	ff279be3          	bne	a5,s2,8000241e <waitx+0xda>
        acquire(&np->lock);
    8000242c:	8526                	mv	a0,s1
    8000242e:	fffff097          	auipc	ra,0xfffff
    80002432:	804080e7          	jalr	-2044(ra) # 80000c32 <acquire>
        if(np->state == ZOMBIE){
    80002436:	4c9c                	lw	a5,24(s1)
    80002438:	f74785e3          	beq	a5,s4,800023a2 <waitx+0x5e>
        release(&np->lock);
    8000243c:	8526                	mv	a0,s1
    8000243e:	fffff097          	auipc	ra,0xfffff
    80002442:	8a8080e7          	jalr	-1880(ra) # 80000ce6 <release>
        havekids = 1;
    80002446:	8756                	mv	a4,s5
    80002448:	bfd9                	j	8000241e <waitx+0xda>
    if(!havekids || p->killed){
    8000244a:	c701                	beqz	a4,80002452 <waitx+0x10e>
    8000244c:	02892783          	lw	a5,40(s2)
    80002450:	cb8d                	beqz	a5,80002482 <waitx+0x13e>
      release(&wait_lock);
    80002452:	0000f517          	auipc	a0,0xf
    80002456:	e6650513          	addi	a0,a0,-410 # 800112b8 <wait_lock>
    8000245a:	fffff097          	auipc	ra,0xfffff
    8000245e:	88c080e7          	jalr	-1908(ra) # 80000ce6 <release>
      return -1;
    80002462:	59fd                	li	s3,-1
}
    80002464:	854e                	mv	a0,s3
    80002466:	60e6                	ld	ra,88(sp)
    80002468:	6446                	ld	s0,80(sp)
    8000246a:	64a6                	ld	s1,72(sp)
    8000246c:	6906                	ld	s2,64(sp)
    8000246e:	79e2                	ld	s3,56(sp)
    80002470:	7a42                	ld	s4,48(sp)
    80002472:	7aa2                	ld	s5,40(sp)
    80002474:	7b02                	ld	s6,32(sp)
    80002476:	6be2                	ld	s7,24(sp)
    80002478:	6c42                	ld	s8,16(sp)
    8000247a:	6ca2                	ld	s9,8(sp)
    8000247c:	6d02                	ld	s10,0(sp)
    8000247e:	6125                	addi	sp,sp,96
    80002480:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002482:	85ea                	mv	a1,s10
    80002484:	854a                	mv	a0,s2
    80002486:	00000097          	auipc	ra,0x0
    8000248a:	d24080e7          	jalr	-732(ra) # 800021aa <sleep>
    havekids = 0;
    8000248e:	b721                	j	80002396 <waitx+0x52>

0000000080002490 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002490:	7139                	addi	sp,sp,-64
    80002492:	fc06                	sd	ra,56(sp)
    80002494:	f822                	sd	s0,48(sp)
    80002496:	f426                	sd	s1,40(sp)
    80002498:	f04a                	sd	s2,32(sp)
    8000249a:	ec4e                	sd	s3,24(sp)
    8000249c:	e852                	sd	s4,16(sp)
    8000249e:	e456                	sd	s5,8(sp)
    800024a0:	e05a                	sd	s6,0(sp)
    800024a2:	0080                	addi	s0,sp,64
    800024a4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800024a6:	0000f497          	auipc	s1,0xf
    800024aa:	22a48493          	addi	s1,s1,554 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800024ae:	4989                	li	s3,2
        p->state = RUNNABLE;
    800024b0:	4b0d                	li	s6,3
        p->stime = ticks - p->stime;
    800024b2:	00007a97          	auipc	s5,0x7
    800024b6:	b7ea8a93          	addi	s5,s5,-1154 # 80009030 <ticks>
  for(p = proc; p < &proc[NPROC]; p++) {
    800024ba:	00016917          	auipc	s2,0x16
    800024be:	a1690913          	addi	s2,s2,-1514 # 80017ed0 <tickslock>
    800024c2:	a01d                	j	800024e8 <wakeup+0x58>
        p->state = RUNNABLE;
    800024c4:	0164ac23          	sw	s6,24(s1)
        p->stime = ticks - p->stime;
    800024c8:	000aa783          	lw	a5,0(s5)
    800024cc:	1744a703          	lw	a4,372(s1)
    800024d0:	9f99                	subw	a5,a5,a4
    800024d2:	16f4aa23          	sw	a5,372(s1)
      }
      release(&p->lock);
    800024d6:	8526                	mv	a0,s1
    800024d8:	fffff097          	auipc	ra,0xfffff
    800024dc:	80e080e7          	jalr	-2034(ra) # 80000ce6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800024e0:	1a048493          	addi	s1,s1,416
    800024e4:	03248463          	beq	s1,s2,8000250c <wakeup+0x7c>
    if(p != myproc()){
    800024e8:	fffff097          	auipc	ra,0xfffff
    800024ec:	550080e7          	jalr	1360(ra) # 80001a38 <myproc>
    800024f0:	fea488e3          	beq	s1,a0,800024e0 <wakeup+0x50>
      acquire(&p->lock);
    800024f4:	8526                	mv	a0,s1
    800024f6:	ffffe097          	auipc	ra,0xffffe
    800024fa:	73c080e7          	jalr	1852(ra) # 80000c32 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800024fe:	4c9c                	lw	a5,24(s1)
    80002500:	fd379be3          	bne	a5,s3,800024d6 <wakeup+0x46>
    80002504:	709c                	ld	a5,32(s1)
    80002506:	fd4798e3          	bne	a5,s4,800024d6 <wakeup+0x46>
    8000250a:	bf6d                	j	800024c4 <wakeup+0x34>
    }
  }
}
    8000250c:	70e2                	ld	ra,56(sp)
    8000250e:	7442                	ld	s0,48(sp)
    80002510:	74a2                	ld	s1,40(sp)
    80002512:	7902                	ld	s2,32(sp)
    80002514:	69e2                	ld	s3,24(sp)
    80002516:	6a42                	ld	s4,16(sp)
    80002518:	6aa2                	ld	s5,8(sp)
    8000251a:	6b02                	ld	s6,0(sp)
    8000251c:	6121                	addi	sp,sp,64
    8000251e:	8082                	ret

0000000080002520 <reparent>:
{
    80002520:	7179                	addi	sp,sp,-48
    80002522:	f406                	sd	ra,40(sp)
    80002524:	f022                	sd	s0,32(sp)
    80002526:	ec26                	sd	s1,24(sp)
    80002528:	e84a                	sd	s2,16(sp)
    8000252a:	e44e                	sd	s3,8(sp)
    8000252c:	e052                	sd	s4,0(sp)
    8000252e:	1800                	addi	s0,sp,48
    80002530:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002532:	0000f497          	auipc	s1,0xf
    80002536:	19e48493          	addi	s1,s1,414 # 800116d0 <proc>
      pp->parent = initproc;
    8000253a:	00007a17          	auipc	s4,0x7
    8000253e:	aeea0a13          	addi	s4,s4,-1298 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002542:	00016917          	auipc	s2,0x16
    80002546:	98e90913          	addi	s2,s2,-1650 # 80017ed0 <tickslock>
    8000254a:	a029                	j	80002554 <reparent+0x34>
    8000254c:	1a048493          	addi	s1,s1,416
    80002550:	01248d63          	beq	s1,s2,8000256a <reparent+0x4a>
    if(pp->parent == p){
    80002554:	7c9c                	ld	a5,56(s1)
    80002556:	ff379be3          	bne	a5,s3,8000254c <reparent+0x2c>
      pp->parent = initproc;
    8000255a:	000a3503          	ld	a0,0(s4)
    8000255e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002560:	00000097          	auipc	ra,0x0
    80002564:	f30080e7          	jalr	-208(ra) # 80002490 <wakeup>
    80002568:	b7d5                	j	8000254c <reparent+0x2c>
}
    8000256a:	70a2                	ld	ra,40(sp)
    8000256c:	7402                	ld	s0,32(sp)
    8000256e:	64e2                	ld	s1,24(sp)
    80002570:	6942                	ld	s2,16(sp)
    80002572:	69a2                	ld	s3,8(sp)
    80002574:	6a02                	ld	s4,0(sp)
    80002576:	6145                	addi	sp,sp,48
    80002578:	8082                	ret

000000008000257a <exit>:
{
    8000257a:	7179                	addi	sp,sp,-48
    8000257c:	f406                	sd	ra,40(sp)
    8000257e:	f022                	sd	s0,32(sp)
    80002580:	ec26                	sd	s1,24(sp)
    80002582:	e84a                	sd	s2,16(sp)
    80002584:	e44e                	sd	s3,8(sp)
    80002586:	e052                	sd	s4,0(sp)
    80002588:	1800                	addi	s0,sp,48
    8000258a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000258c:	fffff097          	auipc	ra,0xfffff
    80002590:	4ac080e7          	jalr	1196(ra) # 80001a38 <myproc>
    80002594:	89aa                	mv	s3,a0
  if(p == initproc)
    80002596:	00007797          	auipc	a5,0x7
    8000259a:	a9278793          	addi	a5,a5,-1390 # 80009028 <initproc>
    8000259e:	639c                	ld	a5,0(a5)
    800025a0:	0d050493          	addi	s1,a0,208
    800025a4:	15050913          	addi	s2,a0,336
    800025a8:	02a79363          	bne	a5,a0,800025ce <exit+0x54>
    panic("init exiting");
    800025ac:	00006517          	auipc	a0,0x6
    800025b0:	ce450513          	addi	a0,a0,-796 # 80008290 <states.1771+0xb8>
    800025b4:	ffffe097          	auipc	ra,0xffffe
    800025b8:	fb2080e7          	jalr	-78(ra) # 80000566 <panic>
      fileclose(f);
    800025bc:	00002097          	auipc	ra,0x2
    800025c0:	59c080e7          	jalr	1436(ra) # 80004b58 <fileclose>
      p->ofile[fd] = 0;
    800025c4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800025c8:	04a1                	addi	s1,s1,8
    800025ca:	01248563          	beq	s1,s2,800025d4 <exit+0x5a>
    if(p->ofile[fd]){
    800025ce:	6088                	ld	a0,0(s1)
    800025d0:	f575                	bnez	a0,800025bc <exit+0x42>
    800025d2:	bfdd                	j	800025c8 <exit+0x4e>
  begin_op();
    800025d4:	00002097          	auipc	ra,0x2
    800025d8:	08a080e7          	jalr	138(ra) # 8000465e <begin_op>
  iput(p->cwd);
    800025dc:	1509b503          	ld	a0,336(s3)
    800025e0:	00002097          	auipc	ra,0x2
    800025e4:	85c080e7          	jalr	-1956(ra) # 80003e3c <iput>
  end_op();
    800025e8:	00002097          	auipc	ra,0x2
    800025ec:	0f6080e7          	jalr	246(ra) # 800046de <end_op>
  p->cwd = 0;
    800025f0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800025f4:	0000f497          	auipc	s1,0xf
    800025f8:	cc448493          	addi	s1,s1,-828 # 800112b8 <wait_lock>
    800025fc:	8526                	mv	a0,s1
    800025fe:	ffffe097          	auipc	ra,0xffffe
    80002602:	634080e7          	jalr	1588(ra) # 80000c32 <acquire>
  reparent(p);
    80002606:	854e                	mv	a0,s3
    80002608:	00000097          	auipc	ra,0x0
    8000260c:	f18080e7          	jalr	-232(ra) # 80002520 <reparent>
  wakeup(p->parent);
    80002610:	0389b503          	ld	a0,56(s3)
    80002614:	00000097          	auipc	ra,0x0
    80002618:	e7c080e7          	jalr	-388(ra) # 80002490 <wakeup>
  acquire(&p->lock);
    8000261c:	854e                	mv	a0,s3
    8000261e:	ffffe097          	auipc	ra,0xffffe
    80002622:	614080e7          	jalr	1556(ra) # 80000c32 <acquire>
  p->xstate = status;
    80002626:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000262a:	4795                	li	a5,5
    8000262c:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    80002630:	00007797          	auipc	a5,0x7
    80002634:	a0078793          	addi	a5,a5,-1536 # 80009030 <ticks>
    80002638:	439c                	lw	a5,0(a5)
    8000263a:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    8000263e:	8526                	mv	a0,s1
    80002640:	ffffe097          	auipc	ra,0xffffe
    80002644:	6a6080e7          	jalr	1702(ra) # 80000ce6 <release>
  sched();
    80002648:	00000097          	auipc	ra,0x0
    8000264c:	a4e080e7          	jalr	-1458(ra) # 80002096 <sched>
  panic("zombie exit");
    80002650:	00006517          	auipc	a0,0x6
    80002654:	c5050513          	addi	a0,a0,-944 # 800082a0 <states.1771+0xc8>
    80002658:	ffffe097          	auipc	ra,0xffffe
    8000265c:	f0e080e7          	jalr	-242(ra) # 80000566 <panic>

0000000080002660 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002660:	7179                	addi	sp,sp,-48
    80002662:	f406                	sd	ra,40(sp)
    80002664:	f022                	sd	s0,32(sp)
    80002666:	ec26                	sd	s1,24(sp)
    80002668:	e84a                	sd	s2,16(sp)
    8000266a:	e44e                	sd	s3,8(sp)
    8000266c:	1800                	addi	s0,sp,48
    8000266e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002670:	0000f497          	auipc	s1,0xf
    80002674:	06048493          	addi	s1,s1,96 # 800116d0 <proc>
    80002678:	00016997          	auipc	s3,0x16
    8000267c:	85898993          	addi	s3,s3,-1960 # 80017ed0 <tickslock>
    acquire(&p->lock);
    80002680:	8526                	mv	a0,s1
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	5b0080e7          	jalr	1456(ra) # 80000c32 <acquire>
    if(p->pid == pid){
    8000268a:	589c                	lw	a5,48(s1)
    8000268c:	01278d63          	beq	a5,s2,800026a6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002690:	8526                	mv	a0,s1
    80002692:	ffffe097          	auipc	ra,0xffffe
    80002696:	654080e7          	jalr	1620(ra) # 80000ce6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000269a:	1a048493          	addi	s1,s1,416
    8000269e:	ff3491e3          	bne	s1,s3,80002680 <kill+0x20>
  }
  return -1;
    800026a2:	557d                	li	a0,-1
    800026a4:	a829                	j	800026be <kill+0x5e>
      p->killed = 1;
    800026a6:	4785                	li	a5,1
    800026a8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800026aa:	4c98                	lw	a4,24(s1)
    800026ac:	4789                	li	a5,2
    800026ae:	00f70f63          	beq	a4,a5,800026cc <kill+0x6c>
      release(&p->lock);
    800026b2:	8526                	mv	a0,s1
    800026b4:	ffffe097          	auipc	ra,0xffffe
    800026b8:	632080e7          	jalr	1586(ra) # 80000ce6 <release>
      return 0;
    800026bc:	4501                	li	a0,0
}
    800026be:	70a2                	ld	ra,40(sp)
    800026c0:	7402                	ld	s0,32(sp)
    800026c2:	64e2                	ld	s1,24(sp)
    800026c4:	6942                	ld	s2,16(sp)
    800026c6:	69a2                	ld	s3,8(sp)
    800026c8:	6145                	addi	sp,sp,48
    800026ca:	8082                	ret
        p->state = RUNNABLE;
    800026cc:	478d                	li	a5,3
    800026ce:	cc9c                	sw	a5,24(s1)
    800026d0:	b7cd                	j	800026b2 <kill+0x52>

00000000800026d2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800026d2:	7179                	addi	sp,sp,-48
    800026d4:	f406                	sd	ra,40(sp)
    800026d6:	f022                	sd	s0,32(sp)
    800026d8:	ec26                	sd	s1,24(sp)
    800026da:	e84a                	sd	s2,16(sp)
    800026dc:	e44e                	sd	s3,8(sp)
    800026de:	e052                	sd	s4,0(sp)
    800026e0:	1800                	addi	s0,sp,48
    800026e2:	84aa                	mv	s1,a0
    800026e4:	892e                	mv	s2,a1
    800026e6:	89b2                	mv	s3,a2
    800026e8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026ea:	fffff097          	auipc	ra,0xfffff
    800026ee:	34e080e7          	jalr	846(ra) # 80001a38 <myproc>
  if(user_dst){
    800026f2:	c08d                	beqz	s1,80002714 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800026f4:	86d2                	mv	a3,s4
    800026f6:	864e                	mv	a2,s3
    800026f8:	85ca                	mv	a1,s2
    800026fa:	6928                	ld	a0,80(a0)
    800026fc:	fffff097          	auipc	ra,0xfffff
    80002700:	fe6080e7          	jalr	-26(ra) # 800016e2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002704:	70a2                	ld	ra,40(sp)
    80002706:	7402                	ld	s0,32(sp)
    80002708:	64e2                	ld	s1,24(sp)
    8000270a:	6942                	ld	s2,16(sp)
    8000270c:	69a2                	ld	s3,8(sp)
    8000270e:	6a02                	ld	s4,0(sp)
    80002710:	6145                	addi	sp,sp,48
    80002712:	8082                	ret
    memmove((char *)dst, src, len);
    80002714:	000a061b          	sext.w	a2,s4
    80002718:	85ce                	mv	a1,s3
    8000271a:	854a                	mv	a0,s2
    8000271c:	ffffe097          	auipc	ra,0xffffe
    80002720:	67e080e7          	jalr	1662(ra) # 80000d9a <memmove>
    return 0;
    80002724:	8526                	mv	a0,s1
    80002726:	bff9                	j	80002704 <either_copyout+0x32>

0000000080002728 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002728:	7179                	addi	sp,sp,-48
    8000272a:	f406                	sd	ra,40(sp)
    8000272c:	f022                	sd	s0,32(sp)
    8000272e:	ec26                	sd	s1,24(sp)
    80002730:	e84a                	sd	s2,16(sp)
    80002732:	e44e                	sd	s3,8(sp)
    80002734:	e052                	sd	s4,0(sp)
    80002736:	1800                	addi	s0,sp,48
    80002738:	892a                	mv	s2,a0
    8000273a:	84ae                	mv	s1,a1
    8000273c:	89b2                	mv	s3,a2
    8000273e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002740:	fffff097          	auipc	ra,0xfffff
    80002744:	2f8080e7          	jalr	760(ra) # 80001a38 <myproc>
  if(user_src){
    80002748:	c08d                	beqz	s1,8000276a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000274a:	86d2                	mv	a3,s4
    8000274c:	864e                	mv	a2,s3
    8000274e:	85ca                	mv	a1,s2
    80002750:	6928                	ld	a0,80(a0)
    80002752:	fffff097          	auipc	ra,0xfffff
    80002756:	01c080e7          	jalr	28(ra) # 8000176e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000275a:	70a2                	ld	ra,40(sp)
    8000275c:	7402                	ld	s0,32(sp)
    8000275e:	64e2                	ld	s1,24(sp)
    80002760:	6942                	ld	s2,16(sp)
    80002762:	69a2                	ld	s3,8(sp)
    80002764:	6a02                	ld	s4,0(sp)
    80002766:	6145                	addi	sp,sp,48
    80002768:	8082                	ret
    memmove(dst, (char*)src, len);
    8000276a:	000a061b          	sext.w	a2,s4
    8000276e:	85ce                	mv	a1,s3
    80002770:	854a                	mv	a0,s2
    80002772:	ffffe097          	auipc	ra,0xffffe
    80002776:	628080e7          	jalr	1576(ra) # 80000d9a <memmove>
    return 0;
    8000277a:	8526                	mv	a0,s1
    8000277c:	bff9                	j	8000275a <either_copyin+0x32>

000000008000277e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000277e:	711d                	addi	sp,sp,-96
    80002780:	ec86                	sd	ra,88(sp)
    80002782:	e8a2                	sd	s0,80(sp)
    80002784:	e4a6                	sd	s1,72(sp)
    80002786:	e0ca                	sd	s2,64(sp)
    80002788:	fc4e                	sd	s3,56(sp)
    8000278a:	f852                	sd	s4,48(sp)
    8000278c:	f456                	sd	s5,40(sp)
    8000278e:	f05a                	sd	s6,32(sp)
    80002790:	ec5e                	sd	s7,24(sp)
    80002792:	e862                	sd	s8,16(sp)
    80002794:	e466                	sd	s9,8(sp)
    80002796:	1080                	addi	s0,sp,96
  [RUNNING]   "run ",
  [ZOMBIE]    "zombie  "
  };
  struct proc *p;
  char *state;
  printf("\n");
    80002798:	00006517          	auipc	a0,0x6
    8000279c:	93050513          	addi	a0,a0,-1744 # 800080c8 <digits+0xb0>
    800027a0:	ffffe097          	auipc	ra,0xffffe
    800027a4:	e10080e7          	jalr	-496(ra) # 800005b0 <printf>
      printf("\n");
    }
  #endif
  
  #if defined(RR) || defined(FCFS)  
    printf("%s\t%s\t%s\t%s\t%s\n","PID","State","rtime","wtime","nrun");
    800027a8:	00006797          	auipc	a5,0x6
    800027ac:	b1078793          	addi	a5,a5,-1264 # 800082b8 <states.1771+0xe0>
    800027b0:	00006717          	auipc	a4,0x6
    800027b4:	b1070713          	addi	a4,a4,-1264 # 800082c0 <states.1771+0xe8>
    800027b8:	00006697          	auipc	a3,0x6
    800027bc:	b1068693          	addi	a3,a3,-1264 # 800082c8 <states.1771+0xf0>
    800027c0:	00006617          	auipc	a2,0x6
    800027c4:	b1060613          	addi	a2,a2,-1264 # 800082d0 <states.1771+0xf8>
    800027c8:	00006597          	auipc	a1,0x6
    800027cc:	b1058593          	addi	a1,a1,-1264 # 800082d8 <states.1771+0x100>
    800027d0:	00006517          	auipc	a0,0x6
    800027d4:	b1050513          	addi	a0,a0,-1264 # 800082e0 <states.1771+0x108>
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	dd8080e7          	jalr	-552(ra) # 800005b0 <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    800027e0:	0000f497          	auipc	s1,0xf
    800027e4:	ef048493          	addi	s1,s1,-272 # 800116d0 <proc>
      if(p->state == UNUSED)
        continue;
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027e8:	4b95                	li	s7,5
        state = states[p->state];
      else
        state = "???";
    800027ea:	00006997          	auipc	s3,0x6
    800027ee:	ac698993          	addi	s3,s3,-1338 # 800082b0 <states.1771+0xd8>
      int waittime = 0;
      if(p->etime == -1)
    800027f2:	5b7d                	li	s6,-1
        waittime = ticks-p->stime-p->rtime;
      else
        waittime = p->etime-p->stime-p->rtime;
      printf("%d\t%s\t%d\t%d\t%d", p->pid, state, p->rtime,waittime,p->ntime);
    800027f4:	00006a97          	auipc	s5,0x6
    800027f8:	afca8a93          	addi	s5,s5,-1284 # 800082f0 <states.1771+0x118>
      printf("\n");
    800027fc:	00006a17          	auipc	s4,0x6
    80002800:	8cca0a13          	addi	s4,s4,-1844 # 800080c8 <digits+0xb0>
        waittime = ticks-p->stime-p->rtime;
    80002804:	00007c97          	auipc	s9,0x7
    80002808:	82cc8c93          	addi	s9,s9,-2004 # 80009030 <ticks>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000280c:	00006c17          	auipc	s8,0x6
    80002810:	9ccc0c13          	addi	s8,s8,-1588 # 800081d8 <states.1771>
    for(p = proc; p < &proc[NPROC]; p++){
    80002814:	00015917          	auipc	s2,0x15
    80002818:	6bc90913          	addi	s2,s2,1724 # 80017ed0 <tickslock>
    8000281c:	a835                	j	80002858 <procdump+0xda>
      if(p->etime == -1)
    8000281e:	1704a703          	lw	a4,368(s1)
    80002822:	05670863          	beq	a4,s6,80002872 <procdump+0xf4>
        waittime = p->etime-p->stime-p->rtime;
    80002826:	1744a783          	lw	a5,372(s1)
    8000282a:	1684a683          	lw	a3,360(s1)
    8000282e:	9fb5                	addw	a5,a5,a3
    80002830:	9f1d                	subw	a4,a4,a5
      printf("%d\t%s\t%d\t%d\t%d", p->pid, state, p->rtime,waittime,p->ntime);
    80002832:	1784a783          	lw	a5,376(s1)
    80002836:	1684a683          	lw	a3,360(s1)
    8000283a:	588c                	lw	a1,48(s1)
    8000283c:	8556                	mv	a0,s5
    8000283e:	ffffe097          	auipc	ra,0xffffe
    80002842:	d72080e7          	jalr	-654(ra) # 800005b0 <printf>
      printf("\n");
    80002846:	8552                	mv	a0,s4
    80002848:	ffffe097          	auipc	ra,0xffffe
    8000284c:	d68080e7          	jalr	-664(ra) # 800005b0 <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    80002850:	1a048493          	addi	s1,s1,416
    80002854:	03248863          	beq	s1,s2,80002884 <procdump+0x106>
      if(p->state == UNUSED)
    80002858:	4c9c                	lw	a5,24(s1)
    8000285a:	dbfd                	beqz	a5,80002850 <procdump+0xd2>
        state = "???";
    8000285c:	864e                	mv	a2,s3
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000285e:	fcfbe0e3          	bltu	s7,a5,8000281e <procdump+0xa0>
    80002862:	1782                	slli	a5,a5,0x20
    80002864:	9381                	srli	a5,a5,0x20
    80002866:	078e                	slli	a5,a5,0x3
    80002868:	97e2                	add	a5,a5,s8
    8000286a:	6390                	ld	a2,0(a5)
    8000286c:	fa4d                	bnez	a2,8000281e <procdump+0xa0>
        state = "???";
    8000286e:	864e                	mv	a2,s3
    80002870:	b77d                	j	8000281e <procdump+0xa0>
        waittime = ticks-p->stime-p->rtime;
    80002872:	1744a703          	lw	a4,372(s1)
    80002876:	1684a783          	lw	a5,360(s1)
    8000287a:	9fb9                	addw	a5,a5,a4
    8000287c:	000ca703          	lw	a4,0(s9)
    80002880:	9f1d                	subw	a4,a4,a5
    80002882:	bf45                	j	80002832 <procdump+0xb4>
    }
  #endif
}
    80002884:	60e6                	ld	ra,88(sp)
    80002886:	6446                	ld	s0,80(sp)
    80002888:	64a6                	ld	s1,72(sp)
    8000288a:	6906                	ld	s2,64(sp)
    8000288c:	79e2                	ld	s3,56(sp)
    8000288e:	7a42                	ld	s4,48(sp)
    80002890:	7aa2                	ld	s5,40(sp)
    80002892:	7b02                	ld	s6,32(sp)
    80002894:	6be2                	ld	s7,24(sp)
    80002896:	6c42                	ld	s8,16(sp)
    80002898:	6ca2                	ld	s9,8(sp)
    8000289a:	6125                	addi	sp,sp,96
    8000289c:	8082                	ret

000000008000289e <setpriority>:

int 
setpriority(int priority, int pid)
{
    8000289e:	1101                	addi	sp,sp,-32
    800028a0:	ec06                	sd	ra,24(sp)
    800028a2:	e822                	sd	s0,16(sp)
    800028a4:	e426                	sd	s1,8(sp)
    800028a6:	1000                	addi	s0,sp,32
  int old_priority = 0;
  int flag = 0;
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
    800028a8:	0000f797          	auipc	a5,0xf
    800028ac:	e2878793          	addi	a5,a5,-472 # 800116d0 <proc>
    800028b0:	5b9c                	lw	a5,48(a5)
    800028b2:	02b78363          	beq	a5,a1,800028d8 <setpriority+0x3a>
  for(p = proc; p < &proc[NPROC]; p++){
    800028b6:	0000f797          	auipc	a5,0xf
    800028ba:	fba78793          	addi	a5,a5,-70 # 80011870 <proc+0x1a0>
    800028be:	00015697          	auipc	a3,0x15
    800028c2:	61268693          	addi	a3,a3,1554 # 80017ed0 <tickslock>
    if(p->pid == pid){
    800028c6:	5b98                	lw	a4,48(a5)
    800028c8:	00b70c63          	beq	a4,a1,800028e0 <setpriority+0x42>
  for(p = proc; p < &proc[NPROC]; p++){
    800028cc:	1a078793          	addi	a5,a5,416
    800028d0:	fed79be3          	bne	a5,a3,800028c6 <setpriority+0x28>
    }
  }
  if(flag)
    return old_priority;
  else
    return -1;
    800028d4:	54fd                	li	s1,-1
    800028d6:	a8b5                	j	80002952 <setpriority+0xb4>
  for(p = proc; p < &proc[NPROC]; p++){
    800028d8:	0000f797          	auipc	a5,0xf
    800028dc:	df878793          	addi	a5,a5,-520 # 800116d0 <proc>
      old_priority = p->priority;
    800028e0:	1807a483          	lw	s1,384(a5)
      if(p->rtime + p->stime != 0){
    800028e4:	1747a603          	lw	a2,372(a5)
    800028e8:	1687a683          	lw	a3,360(a5)
    800028ec:	9eb1                	addw	a3,a3,a2
    800028ee:	0006859b          	sext.w	a1,a3
      int niceness1 = 5;
    800028f2:	4715                	li	a4,5
      if(p->rtime + p->stime != 0){
    800028f4:	c981                	beqz	a1,80002904 <setpriority+0x66>
        niceness1 = p->stime * 10 / (p->rtime + p->stime);
    800028f6:	0026171b          	slliw	a4,a2,0x2
    800028fa:	9f31                	addw	a4,a4,a2
    800028fc:	0017171b          	slliw	a4,a4,0x1
    80002900:	02d7573b          	divuw	a4,a4,a3
      int dp1 = p->priority - niceness1 + 5;
    80002904:	40e4873b          	subw	a4,s1,a4
    80002908:	2715                	addiw	a4,a4,5
    8000290a:	0007069b          	sext.w	a3,a4
    8000290e:	fff6c693          	not	a3,a3
    80002912:	96fd                	srai	a3,a3,0x3f
    80002914:	8f75                	and	a4,a4,a3
    80002916:	2701                	sext.w	a4,a4
      p->rtime = 0;
    80002918:	1607a423          	sw	zero,360(a5)
      p->stime = 0;
    8000291c:	1607aa23          	sw	zero,372(a5)
      p->priority = priority;
    80002920:	18a7a023          	sw	a0,384(a5)
      if(dp2<dp1){
    80002924:	fff54793          	not	a5,a0
    80002928:	97fd                	srai	a5,a5,0x3f
    8000292a:	8d7d                	and	a0,a0,a5
    8000292c:	0005069b          	sext.w	a3,a0
    80002930:	06400793          	li	a5,100
    80002934:	00d7d463          	bge	a5,a3,8000293c <setpriority+0x9e>
    80002938:	06400513          	li	a0,100
    8000293c:	87ba                	mv	a5,a4
    8000293e:	06400693          	li	a3,100
    80002942:	00e6d463          	bge	a3,a4,8000294a <setpriority+0xac>
    80002946:	06400793          	li	a5,100
    8000294a:	2501                	sext.w	a0,a0
    8000294c:	2781                	sext.w	a5,a5
    8000294e:	00f54863          	blt	a0,a5,8000295e <setpriority+0xc0>
    80002952:	8526                	mv	a0,s1
    80002954:	60e2                	ld	ra,24(sp)
    80002956:	6442                	ld	s0,16(sp)
    80002958:	64a2                	ld	s1,8(sp)
    8000295a:	6105                	addi	sp,sp,32
    8000295c:	8082                	ret
        yield();
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	810080e7          	jalr	-2032(ra) # 8000216e <yield>
  if(flag)
    80002966:	b7f5                	j	80002952 <setpriority+0xb4>

0000000080002968 <swtch>:
    80002968:	00153023          	sd	ra,0(a0)
    8000296c:	00253423          	sd	sp,8(a0)
    80002970:	e900                	sd	s0,16(a0)
    80002972:	ed04                	sd	s1,24(a0)
    80002974:	03253023          	sd	s2,32(a0)
    80002978:	03353423          	sd	s3,40(a0)
    8000297c:	03453823          	sd	s4,48(a0)
    80002980:	03553c23          	sd	s5,56(a0)
    80002984:	05653023          	sd	s6,64(a0)
    80002988:	05753423          	sd	s7,72(a0)
    8000298c:	05853823          	sd	s8,80(a0)
    80002990:	05953c23          	sd	s9,88(a0)
    80002994:	07a53023          	sd	s10,96(a0)
    80002998:	07b53423          	sd	s11,104(a0)
    8000299c:	0005b083          	ld	ra,0(a1)
    800029a0:	0085b103          	ld	sp,8(a1)
    800029a4:	6980                	ld	s0,16(a1)
    800029a6:	6d84                	ld	s1,24(a1)
    800029a8:	0205b903          	ld	s2,32(a1)
    800029ac:	0285b983          	ld	s3,40(a1)
    800029b0:	0305ba03          	ld	s4,48(a1)
    800029b4:	0385ba83          	ld	s5,56(a1)
    800029b8:	0405bb03          	ld	s6,64(a1)
    800029bc:	0485bb83          	ld	s7,72(a1)
    800029c0:	0505bc03          	ld	s8,80(a1)
    800029c4:	0585bc83          	ld	s9,88(a1)
    800029c8:	0605bd03          	ld	s10,96(a1)
    800029cc:	0685bd83          	ld	s11,104(a1)
    800029d0:	8082                	ret

00000000800029d2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800029d2:	1141                	addi	sp,sp,-16
    800029d4:	e406                	sd	ra,8(sp)
    800029d6:	e022                	sd	s0,0(sp)
    800029d8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800029da:	00006597          	auipc	a1,0x6
    800029de:	95e58593          	addi	a1,a1,-1698 # 80008338 <states.1771+0x160>
    800029e2:	00015517          	auipc	a0,0x15
    800029e6:	4ee50513          	addi	a0,a0,1262 # 80017ed0 <tickslock>
    800029ea:	ffffe097          	auipc	ra,0xffffe
    800029ee:	1b8080e7          	jalr	440(ra) # 80000ba2 <initlock>
}
    800029f2:	60a2                	ld	ra,8(sp)
    800029f4:	6402                	ld	s0,0(sp)
    800029f6:	0141                	addi	sp,sp,16
    800029f8:	8082                	ret

00000000800029fa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800029fa:	1141                	addi	sp,sp,-16
    800029fc:	e422                	sd	s0,8(sp)
    800029fe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a00:	00003797          	auipc	a5,0x3
    80002a04:	7c078793          	addi	a5,a5,1984 # 800061c0 <kernelvec>
    80002a08:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a0c:	6422                	ld	s0,8(sp)
    80002a0e:	0141                	addi	sp,sp,16
    80002a10:	8082                	ret

0000000080002a12 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a12:	1141                	addi	sp,sp,-16
    80002a14:	e406                	sd	ra,8(sp)
    80002a16:	e022                	sd	s0,0(sp)
    80002a18:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a1a:	fffff097          	auipc	ra,0xfffff
    80002a1e:	01e080e7          	jalr	30(ra) # 80001a38 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a28:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a2c:	00004617          	auipc	a2,0x4
    80002a30:	5d460613          	addi	a2,a2,1492 # 80007000 <_trampoline>
    80002a34:	00004697          	auipc	a3,0x4
    80002a38:	5cc68693          	addi	a3,a3,1484 # 80007000 <_trampoline>
    80002a3c:	8e91                	sub	a3,a3,a2
    80002a3e:	040007b7          	lui	a5,0x4000
    80002a42:	17fd                	addi	a5,a5,-1
    80002a44:	07b2                	slli	a5,a5,0xc
    80002a46:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a48:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a4c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a4e:	180026f3          	csrr	a3,satp
    80002a52:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a54:	6d38                	ld	a4,88(a0)
    80002a56:	6134                	ld	a3,64(a0)
    80002a58:	6585                	lui	a1,0x1
    80002a5a:	96ae                	add	a3,a3,a1
    80002a5c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002a5e:	6d38                	ld	a4,88(a0)
    80002a60:	00000697          	auipc	a3,0x0
    80002a64:	14668693          	addi	a3,a3,326 # 80002ba6 <usertrap>
    80002a68:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002a6a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a6c:	8692                	mv	a3,tp
    80002a6e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a70:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a74:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a78:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a7c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002a80:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a82:	6f18                	ld	a4,24(a4)
    80002a84:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002a88:	692c                	ld	a1,80(a0)
    80002a8a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002a8c:	00004717          	auipc	a4,0x4
    80002a90:	60470713          	addi	a4,a4,1540 # 80007090 <userret>
    80002a94:	8f11                	sub	a4,a4,a2
    80002a96:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002a98:	577d                	li	a4,-1
    80002a9a:	177e                	slli	a4,a4,0x3f
    80002a9c:	8dd9                	or	a1,a1,a4
    80002a9e:	02000537          	lui	a0,0x2000
    80002aa2:	157d                	addi	a0,a0,-1
    80002aa4:	0536                	slli	a0,a0,0xd
    80002aa6:	9782                	jalr	a5
}
    80002aa8:	60a2                	ld	ra,8(sp)
    80002aaa:	6402                	ld	s0,0(sp)
    80002aac:	0141                	addi	sp,sp,16
    80002aae:	8082                	ret

0000000080002ab0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002ab0:	1101                	addi	sp,sp,-32
    80002ab2:	ec06                	sd	ra,24(sp)
    80002ab4:	e822                	sd	s0,16(sp)
    80002ab6:	e426                	sd	s1,8(sp)
    80002ab8:	e04a                	sd	s2,0(sp)
    80002aba:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002abc:	00015917          	auipc	s2,0x15
    80002ac0:	41490913          	addi	s2,s2,1044 # 80017ed0 <tickslock>
    80002ac4:	854a                	mv	a0,s2
    80002ac6:	ffffe097          	auipc	ra,0xffffe
    80002aca:	16c080e7          	jalr	364(ra) # 80000c32 <acquire>
  ticks++;
    80002ace:	00006497          	auipc	s1,0x6
    80002ad2:	56248493          	addi	s1,s1,1378 # 80009030 <ticks>
    80002ad6:	409c                	lw	a5,0(s1)
    80002ad8:	2785                	addiw	a5,a5,1
    80002ada:	c09c                	sw	a5,0(s1)
  update_time();
    80002adc:	fffff097          	auipc	ra,0xfffff
    80002ae0:	4bc080e7          	jalr	1212(ra) # 80001f98 <update_time>
  wakeup(&ticks);
    80002ae4:	8526                	mv	a0,s1
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	9aa080e7          	jalr	-1622(ra) # 80002490 <wakeup>
  release(&tickslock);
    80002aee:	854a                	mv	a0,s2
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	1f6080e7          	jalr	502(ra) # 80000ce6 <release>
}
    80002af8:	60e2                	ld	ra,24(sp)
    80002afa:	6442                	ld	s0,16(sp)
    80002afc:	64a2                	ld	s1,8(sp)
    80002afe:	6902                	ld	s2,0(sp)
    80002b00:	6105                	addi	sp,sp,32
    80002b02:	8082                	ret

0000000080002b04 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b04:	1101                	addi	sp,sp,-32
    80002b06:	ec06                	sd	ra,24(sp)
    80002b08:	e822                	sd	s0,16(sp)
    80002b0a:	e426                	sd	s1,8(sp)
    80002b0c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b0e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002b12:	00074d63          	bltz	a4,80002b2c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b16:	57fd                	li	a5,-1
    80002b18:	17fe                	slli	a5,a5,0x3f
    80002b1a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b1c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b1e:	06f70363          	beq	a4,a5,80002b84 <devintr+0x80>
  }
}
    80002b22:	60e2                	ld	ra,24(sp)
    80002b24:	6442                	ld	s0,16(sp)
    80002b26:	64a2                	ld	s1,8(sp)
    80002b28:	6105                	addi	sp,sp,32
    80002b2a:	8082                	ret
     (scause & 0xff) == 9){
    80002b2c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b30:	46a5                	li	a3,9
    80002b32:	fed792e3          	bne	a5,a3,80002b16 <devintr+0x12>
    int irq = plic_claim();
    80002b36:	00003097          	auipc	ra,0x3
    80002b3a:	792080e7          	jalr	1938(ra) # 800062c8 <plic_claim>
    80002b3e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b40:	47a9                	li	a5,10
    80002b42:	02f50763          	beq	a0,a5,80002b70 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002b46:	4785                	li	a5,1
    80002b48:	02f50963          	beq	a0,a5,80002b7a <devintr+0x76>
    return 1;
    80002b4c:	4505                	li	a0,1
    } else if(irq){
    80002b4e:	d8f1                	beqz	s1,80002b22 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b50:	85a6                	mv	a1,s1
    80002b52:	00005517          	auipc	a0,0x5
    80002b56:	7ee50513          	addi	a0,a0,2030 # 80008340 <states.1771+0x168>
    80002b5a:	ffffe097          	auipc	ra,0xffffe
    80002b5e:	a56080e7          	jalr	-1450(ra) # 800005b0 <printf>
      plic_complete(irq);
    80002b62:	8526                	mv	a0,s1
    80002b64:	00003097          	auipc	ra,0x3
    80002b68:	788080e7          	jalr	1928(ra) # 800062ec <plic_complete>
    return 1;
    80002b6c:	4505                	li	a0,1
    80002b6e:	bf55                	j	80002b22 <devintr+0x1e>
      uartintr();
    80002b70:	ffffe097          	auipc	ra,0xffffe
    80002b74:	e82080e7          	jalr	-382(ra) # 800009f2 <uartintr>
    80002b78:	b7ed                	j	80002b62 <devintr+0x5e>
      virtio_disk_intr();
    80002b7a:	00004097          	auipc	ra,0x4
    80002b7e:	c70080e7          	jalr	-912(ra) # 800067ea <virtio_disk_intr>
    80002b82:	b7c5                	j	80002b62 <devintr+0x5e>
    if(cpuid() == 0){
    80002b84:	fffff097          	auipc	ra,0xfffff
    80002b88:	e88080e7          	jalr	-376(ra) # 80001a0c <cpuid>
    80002b8c:	c901                	beqz	a0,80002b9c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002b8e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002b92:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002b94:	14479073          	csrw	sip,a5
    return 2;
    80002b98:	4509                	li	a0,2
    80002b9a:	b761                	j	80002b22 <devintr+0x1e>
      clockintr();
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	f14080e7          	jalr	-236(ra) # 80002ab0 <clockintr>
    80002ba4:	b7ed                	j	80002b8e <devintr+0x8a>

0000000080002ba6 <usertrap>:
{
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	e04a                	sd	s2,0(sp)
    80002bb0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bb2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002bb6:	1007f793          	andi	a5,a5,256
    80002bba:	e3ad                	bnez	a5,80002c1c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bbc:	00003797          	auipc	a5,0x3
    80002bc0:	60478793          	addi	a5,a5,1540 # 800061c0 <kernelvec>
    80002bc4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002bc8:	fffff097          	auipc	ra,0xfffff
    80002bcc:	e70080e7          	jalr	-400(ra) # 80001a38 <myproc>
    80002bd0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002bd2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002bd4:	14102773          	csrr	a4,sepc
    80002bd8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002bda:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002bde:	47a1                	li	a5,8
    80002be0:	04f71c63          	bne	a4,a5,80002c38 <usertrap+0x92>
    if(p->killed)
    80002be4:	551c                	lw	a5,40(a0)
    80002be6:	e3b9                	bnez	a5,80002c2c <usertrap+0x86>
    p->trapframe->epc += 4;
    80002be8:	6cb8                	ld	a4,88(s1)
    80002bea:	6f1c                	ld	a5,24(a4)
    80002bec:	0791                	addi	a5,a5,4
    80002bee:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bf0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002bf4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bf8:	10079073          	csrw	sstatus,a5
    syscall();
    80002bfc:	00000097          	auipc	ra,0x0
    80002c00:	2e6080e7          	jalr	742(ra) # 80002ee2 <syscall>
  if(p->killed)
    80002c04:	549c                	lw	a5,40(s1)
    80002c06:	ebc1                	bnez	a5,80002c96 <usertrap+0xf0>
  usertrapret();
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	e0a080e7          	jalr	-502(ra) # 80002a12 <usertrapret>
}
    80002c10:	60e2                	ld	ra,24(sp)
    80002c12:	6442                	ld	s0,16(sp)
    80002c14:	64a2                	ld	s1,8(sp)
    80002c16:	6902                	ld	s2,0(sp)
    80002c18:	6105                	addi	sp,sp,32
    80002c1a:	8082                	ret
    panic("usertrap: not from user mode");
    80002c1c:	00005517          	auipc	a0,0x5
    80002c20:	74450513          	addi	a0,a0,1860 # 80008360 <states.1771+0x188>
    80002c24:	ffffe097          	auipc	ra,0xffffe
    80002c28:	942080e7          	jalr	-1726(ra) # 80000566 <panic>
      exit(-1);
    80002c2c:	557d                	li	a0,-1
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	94c080e7          	jalr	-1716(ra) # 8000257a <exit>
    80002c36:	bf4d                	j	80002be8 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c38:	00000097          	auipc	ra,0x0
    80002c3c:	ecc080e7          	jalr	-308(ra) # 80002b04 <devintr>
    80002c40:	892a                	mv	s2,a0
    80002c42:	c501                	beqz	a0,80002c4a <usertrap+0xa4>
  if(p->killed)
    80002c44:	549c                	lw	a5,40(s1)
    80002c46:	c3a1                	beqz	a5,80002c86 <usertrap+0xe0>
    80002c48:	a815                	j	80002c7c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c4a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c4e:	5890                	lw	a2,48(s1)
    80002c50:	00005517          	auipc	a0,0x5
    80002c54:	73050513          	addi	a0,a0,1840 # 80008380 <states.1771+0x1a8>
    80002c58:	ffffe097          	auipc	ra,0xffffe
    80002c5c:	958080e7          	jalr	-1704(ra) # 800005b0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c60:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c64:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c68:	00005517          	auipc	a0,0x5
    80002c6c:	74850513          	addi	a0,a0,1864 # 800083b0 <states.1771+0x1d8>
    80002c70:	ffffe097          	auipc	ra,0xffffe
    80002c74:	940080e7          	jalr	-1728(ra) # 800005b0 <printf>
    p->killed = 1;
    80002c78:	4785                	li	a5,1
    80002c7a:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002c7c:	557d                	li	a0,-1
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	8fc080e7          	jalr	-1796(ra) # 8000257a <exit>
  if(which_dev == 2)
    80002c86:	4789                	li	a5,2
    80002c88:	f8f910e3          	bne	s2,a5,80002c08 <usertrap+0x62>
    yield();
    80002c8c:	fffff097          	auipc	ra,0xfffff
    80002c90:	4e2080e7          	jalr	1250(ra) # 8000216e <yield>
    80002c94:	bf95                	j	80002c08 <usertrap+0x62>
  int which_dev = 0;
    80002c96:	4901                	li	s2,0
    80002c98:	b7d5                	j	80002c7c <usertrap+0xd6>

0000000080002c9a <kerneltrap>:
{
    80002c9a:	7179                	addi	sp,sp,-48
    80002c9c:	f406                	sd	ra,40(sp)
    80002c9e:	f022                	sd	s0,32(sp)
    80002ca0:	ec26                	sd	s1,24(sp)
    80002ca2:	e84a                	sd	s2,16(sp)
    80002ca4:	e44e                	sd	s3,8(sp)
    80002ca6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ca8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cb0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002cb4:	1004f793          	andi	a5,s1,256
    80002cb8:	cb85                	beqz	a5,80002ce8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002cbe:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002cc0:	ef85                	bnez	a5,80002cf8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	e42080e7          	jalr	-446(ra) # 80002b04 <devintr>
    80002cca:	cd1d                	beqz	a0,80002d08 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ccc:	4789                	li	a5,2
    80002cce:	06f50a63          	beq	a0,a5,80002d42 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cd2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cd6:	10049073          	csrw	sstatus,s1
}
    80002cda:	70a2                	ld	ra,40(sp)
    80002cdc:	7402                	ld	s0,32(sp)
    80002cde:	64e2                	ld	s1,24(sp)
    80002ce0:	6942                	ld	s2,16(sp)
    80002ce2:	69a2                	ld	s3,8(sp)
    80002ce4:	6145                	addi	sp,sp,48
    80002ce6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002ce8:	00005517          	auipc	a0,0x5
    80002cec:	6e850513          	addi	a0,a0,1768 # 800083d0 <states.1771+0x1f8>
    80002cf0:	ffffe097          	auipc	ra,0xffffe
    80002cf4:	876080e7          	jalr	-1930(ra) # 80000566 <panic>
    panic("kerneltrap: interrupts enabled");
    80002cf8:	00005517          	auipc	a0,0x5
    80002cfc:	70050513          	addi	a0,a0,1792 # 800083f8 <states.1771+0x220>
    80002d00:	ffffe097          	auipc	ra,0xffffe
    80002d04:	866080e7          	jalr	-1946(ra) # 80000566 <panic>
    printf("scause %p\n", scause);
    80002d08:	85ce                	mv	a1,s3
    80002d0a:	00005517          	auipc	a0,0x5
    80002d0e:	70e50513          	addi	a0,a0,1806 # 80008418 <states.1771+0x240>
    80002d12:	ffffe097          	auipc	ra,0xffffe
    80002d16:	89e080e7          	jalr	-1890(ra) # 800005b0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d1a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d1e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d22:	00005517          	auipc	a0,0x5
    80002d26:	70650513          	addi	a0,a0,1798 # 80008428 <states.1771+0x250>
    80002d2a:	ffffe097          	auipc	ra,0xffffe
    80002d2e:	886080e7          	jalr	-1914(ra) # 800005b0 <printf>
    panic("kerneltrap");
    80002d32:	00005517          	auipc	a0,0x5
    80002d36:	70e50513          	addi	a0,a0,1806 # 80008440 <states.1771+0x268>
    80002d3a:	ffffe097          	auipc	ra,0xffffe
    80002d3e:	82c080e7          	jalr	-2004(ra) # 80000566 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d42:	fffff097          	auipc	ra,0xfffff
    80002d46:	cf6080e7          	jalr	-778(ra) # 80001a38 <myproc>
    80002d4a:	d541                	beqz	a0,80002cd2 <kerneltrap+0x38>
    80002d4c:	fffff097          	auipc	ra,0xfffff
    80002d50:	cec080e7          	jalr	-788(ra) # 80001a38 <myproc>
    80002d54:	4d18                	lw	a4,24(a0)
    80002d56:	4791                	li	a5,4
    80002d58:	f6f71de3          	bne	a4,a5,80002cd2 <kerneltrap+0x38>
    yield();
    80002d5c:	fffff097          	auipc	ra,0xfffff
    80002d60:	412080e7          	jalr	1042(ra) # 8000216e <yield>
    80002d64:	b7bd                	j	80002cd2 <kerneltrap+0x38>

0000000080002d66 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d66:	1101                	addi	sp,sp,-32
    80002d68:	ec06                	sd	ra,24(sp)
    80002d6a:	e822                	sd	s0,16(sp)
    80002d6c:	e426                	sd	s1,8(sp)
    80002d6e:	1000                	addi	s0,sp,32
    80002d70:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d72:	fffff097          	auipc	ra,0xfffff
    80002d76:	cc6080e7          	jalr	-826(ra) # 80001a38 <myproc>
  switch (n) {
    80002d7a:	4795                	li	a5,5
    80002d7c:	0497e363          	bltu	a5,s1,80002dc2 <argraw+0x5c>
    80002d80:	1482                	slli	s1,s1,0x20
    80002d82:	9081                	srli	s1,s1,0x20
    80002d84:	048a                	slli	s1,s1,0x2
    80002d86:	00005717          	auipc	a4,0x5
    80002d8a:	6ca70713          	addi	a4,a4,1738 # 80008450 <states.1771+0x278>
    80002d8e:	94ba                	add	s1,s1,a4
    80002d90:	409c                	lw	a5,0(s1)
    80002d92:	97ba                	add	a5,a5,a4
    80002d94:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002d96:	6d3c                	ld	a5,88(a0)
    80002d98:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002d9a:	60e2                	ld	ra,24(sp)
    80002d9c:	6442                	ld	s0,16(sp)
    80002d9e:	64a2                	ld	s1,8(sp)
    80002da0:	6105                	addi	sp,sp,32
    80002da2:	8082                	ret
    return p->trapframe->a1;
    80002da4:	6d3c                	ld	a5,88(a0)
    80002da6:	7fa8                	ld	a0,120(a5)
    80002da8:	bfcd                	j	80002d9a <argraw+0x34>
    return p->trapframe->a2;
    80002daa:	6d3c                	ld	a5,88(a0)
    80002dac:	63c8                	ld	a0,128(a5)
    80002dae:	b7f5                	j	80002d9a <argraw+0x34>
    return p->trapframe->a3;
    80002db0:	6d3c                	ld	a5,88(a0)
    80002db2:	67c8                	ld	a0,136(a5)
    80002db4:	b7dd                	j	80002d9a <argraw+0x34>
    return p->trapframe->a4;
    80002db6:	6d3c                	ld	a5,88(a0)
    80002db8:	6bc8                	ld	a0,144(a5)
    80002dba:	b7c5                	j	80002d9a <argraw+0x34>
    return p->trapframe->a5;
    80002dbc:	6d3c                	ld	a5,88(a0)
    80002dbe:	6fc8                	ld	a0,152(a5)
    80002dc0:	bfe9                	j	80002d9a <argraw+0x34>
  panic("argraw");
    80002dc2:	00005517          	auipc	a0,0x5
    80002dc6:	76e50513          	addi	a0,a0,1902 # 80008530 <syscalls+0xc8>
    80002dca:	ffffd097          	auipc	ra,0xffffd
    80002dce:	79c080e7          	jalr	1948(ra) # 80000566 <panic>

0000000080002dd2 <fetchaddr>:
{
    80002dd2:	1101                	addi	sp,sp,-32
    80002dd4:	ec06                	sd	ra,24(sp)
    80002dd6:	e822                	sd	s0,16(sp)
    80002dd8:	e426                	sd	s1,8(sp)
    80002dda:	e04a                	sd	s2,0(sp)
    80002ddc:	1000                	addi	s0,sp,32
    80002dde:	84aa                	mv	s1,a0
    80002de0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002de2:	fffff097          	auipc	ra,0xfffff
    80002de6:	c56080e7          	jalr	-938(ra) # 80001a38 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002dea:	653c                	ld	a5,72(a0)
    80002dec:	02f4f963          	bgeu	s1,a5,80002e1e <fetchaddr+0x4c>
    80002df0:	00848713          	addi	a4,s1,8
    80002df4:	02e7e763          	bltu	a5,a4,80002e22 <fetchaddr+0x50>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002df8:	46a1                	li	a3,8
    80002dfa:	8626                	mv	a2,s1
    80002dfc:	85ca                	mv	a1,s2
    80002dfe:	6928                	ld	a0,80(a0)
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	96e080e7          	jalr	-1682(ra) # 8000176e <copyin>
    80002e08:	00a03533          	snez	a0,a0
    80002e0c:	40a0053b          	negw	a0,a0
    80002e10:	2501                	sext.w	a0,a0
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6902                	ld	s2,0(sp)
    80002e1a:	6105                	addi	sp,sp,32
    80002e1c:	8082                	ret
    return -1;
    80002e1e:	557d                	li	a0,-1
    80002e20:	bfcd                	j	80002e12 <fetchaddr+0x40>
    80002e22:	557d                	li	a0,-1
    80002e24:	b7fd                	j	80002e12 <fetchaddr+0x40>

0000000080002e26 <fetchstr>:
{
    80002e26:	7179                	addi	sp,sp,-48
    80002e28:	f406                	sd	ra,40(sp)
    80002e2a:	f022                	sd	s0,32(sp)
    80002e2c:	ec26                	sd	s1,24(sp)
    80002e2e:	e84a                	sd	s2,16(sp)
    80002e30:	e44e                	sd	s3,8(sp)
    80002e32:	1800                	addi	s0,sp,48
    80002e34:	892a                	mv	s2,a0
    80002e36:	84ae                	mv	s1,a1
    80002e38:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	bfe080e7          	jalr	-1026(ra) # 80001a38 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002e42:	86ce                	mv	a3,s3
    80002e44:	864a                	mv	a2,s2
    80002e46:	85a6                	mv	a1,s1
    80002e48:	6928                	ld	a0,80(a0)
    80002e4a:	fffff097          	auipc	ra,0xfffff
    80002e4e:	9b2080e7          	jalr	-1614(ra) # 800017fc <copyinstr>
  if(err < 0)
    80002e52:	00054763          	bltz	a0,80002e60 <fetchstr+0x3a>
  return strlen(buf);
    80002e56:	8526                	mv	a0,s1
    80002e58:	ffffe097          	auipc	ra,0xffffe
    80002e5c:	07c080e7          	jalr	124(ra) # 80000ed4 <strlen>
}
    80002e60:	70a2                	ld	ra,40(sp)
    80002e62:	7402                	ld	s0,32(sp)
    80002e64:	64e2                	ld	s1,24(sp)
    80002e66:	6942                	ld	s2,16(sp)
    80002e68:	69a2                	ld	s3,8(sp)
    80002e6a:	6145                	addi	sp,sp,48
    80002e6c:	8082                	ret

0000000080002e6e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002e6e:	1101                	addi	sp,sp,-32
    80002e70:	ec06                	sd	ra,24(sp)
    80002e72:	e822                	sd	s0,16(sp)
    80002e74:	e426                	sd	s1,8(sp)
    80002e76:	1000                	addi	s0,sp,32
    80002e78:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	eec080e7          	jalr	-276(ra) # 80002d66 <argraw>
    80002e82:	c088                	sw	a0,0(s1)
  return 0;
}
    80002e84:	4501                	li	a0,0
    80002e86:	60e2                	ld	ra,24(sp)
    80002e88:	6442                	ld	s0,16(sp)
    80002e8a:	64a2                	ld	s1,8(sp)
    80002e8c:	6105                	addi	sp,sp,32
    80002e8e:	8082                	ret

0000000080002e90 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002e90:	1101                	addi	sp,sp,-32
    80002e92:	ec06                	sd	ra,24(sp)
    80002e94:	e822                	sd	s0,16(sp)
    80002e96:	e426                	sd	s1,8(sp)
    80002e98:	1000                	addi	s0,sp,32
    80002e9a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e9c:	00000097          	auipc	ra,0x0
    80002ea0:	eca080e7          	jalr	-310(ra) # 80002d66 <argraw>
    80002ea4:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ea6:	4501                	li	a0,0
    80002ea8:	60e2                	ld	ra,24(sp)
    80002eaa:	6442                	ld	s0,16(sp)
    80002eac:	64a2                	ld	s1,8(sp)
    80002eae:	6105                	addi	sp,sp,32
    80002eb0:	8082                	ret

0000000080002eb2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002eb2:	1101                	addi	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	e426                	sd	s1,8(sp)
    80002eba:	e04a                	sd	s2,0(sp)
    80002ebc:	1000                	addi	s0,sp,32
    80002ebe:	84ae                	mv	s1,a1
    80002ec0:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	ea4080e7          	jalr	-348(ra) # 80002d66 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002eca:	864a                	mv	a2,s2
    80002ecc:	85a6                	mv	a1,s1
    80002ece:	00000097          	auipc	ra,0x0
    80002ed2:	f58080e7          	jalr	-168(ra) # 80002e26 <fetchstr>
}
    80002ed6:	60e2                	ld	ra,24(sp)
    80002ed8:	6442                	ld	s0,16(sp)
    80002eda:	64a2                	ld	s1,8(sp)
    80002edc:	6902                	ld	s2,0(sp)
    80002ede:	6105                	addi	sp,sp,32
    80002ee0:	8082                	ret

0000000080002ee2 <syscall>:
int numOfArgs[] = 
{ 0, 0, 1, 1, 1, 3, 1, 2, 2, 1, 1, 0, 1, 1, 0, 2, 3, 2, 1, 2, 1, 1, 3, 1, 2};

void
syscall(void)
{
    80002ee2:	715d                	addi	sp,sp,-80
    80002ee4:	e486                	sd	ra,72(sp)
    80002ee6:	e0a2                	sd	s0,64(sp)
    80002ee8:	fc26                	sd	s1,56(sp)
    80002eea:	f84a                	sd	s2,48(sp)
    80002eec:	f44e                	sd	s3,40(sp)
    80002eee:	f052                	sd	s4,32(sp)
    80002ef0:	ec56                	sd	s5,24(sp)
    80002ef2:	e85a                	sd	s6,16(sp)
    80002ef4:	e45e                	sd	s7,8(sp)
    80002ef6:	e062                	sd	s8,0(sp)
    80002ef8:	0880                	addi	s0,sp,80
  int num;
  struct proc *p = myproc();
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	b3e080e7          	jalr	-1218(ra) # 80001a38 <myproc>
    80002f02:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002f04:	05853983          	ld	s3,88(a0)
    80002f08:	0a89b783          	ld	a5,168(s3)
    80002f0c:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f10:	37fd                	addiw	a5,a5,-1
    80002f12:	475d                	li	a4,23
    80002f14:	10f76e63          	bltu	a4,a5,80003030 <syscall+0x14e>
    80002f18:	00391713          	slli	a4,s2,0x3
    80002f1c:	00005797          	auipc	a5,0x5
    80002f20:	54c78793          	addi	a5,a5,1356 # 80008468 <syscalls>
    80002f24:	97ba                	add	a5,a5,a4
    80002f26:	639c                	ld	a5,0(a5)
    80002f28:	10078463          	beqz	a5,80003030 <syscall+0x14e>
    int trapframea0_cpy = p->trapframe->a0;
    80002f2c:	0709ba03          	ld	s4,112(s3)
    p->trapframe->a0 = syscalls[num]();
    80002f30:	9782                	jalr	a5
    80002f32:	06a9b823          	sd	a0,112(s3)
    int mask = p->mask;
    if ((mask >> num) & 1){
    80002f36:	17c4a783          	lw	a5,380(s1)
    80002f3a:	4127d7bb          	sraw	a5,a5,s2
    80002f3e:	8b85                	andi	a5,a5,1
    80002f40:	10078763          	beqz	a5,8000304e <syscall+0x16c>
      printf("%d: syscall %s ", p->pid, sysCallName[num]);
    80002f44:	00006997          	auipc	s3,0x6
    80002f48:	a6498993          	addi	s3,s3,-1436 # 800089a8 <sysCallName>
    80002f4c:	00391793          	slli	a5,s2,0x3
    80002f50:	97ce                	add	a5,a5,s3
    80002f52:	6390                	ld	a2,0(a5)
    80002f54:	588c                	lw	a1,48(s1)
    80002f56:	00005517          	auipc	a0,0x5
    80002f5a:	5e250513          	addi	a0,a0,1506 # 80008538 <syscalls+0xd0>
    80002f5e:	ffffd097          	auipc	ra,0xffffd
    80002f62:	652080e7          	jalr	1618(ra) # 800005b0 <printf>
      if(numOfArgs[num] > 0){
    80002f66:	00291793          	slli	a5,s2,0x2
    80002f6a:	99be                	add	s3,s3,a5
    80002f6c:	0c89a783          	lw	a5,200(s3)
    80002f70:	00f04d63          	bgtz	a5,80002f8a <syscall+0xa8>
          else if(i==2) 
            printf("%d", p->trapframe->a2);
        }
        printf(")");
      }
      printf(" -> %d\n", p->trapframe->a0);
    80002f74:	6cbc                	ld	a5,88(s1)
    80002f76:	7bac                	ld	a1,112(a5)
    80002f78:	00005517          	auipc	a0,0x5
    80002f7c:	5f050513          	addi	a0,a0,1520 # 80008568 <syscalls+0x100>
    80002f80:	ffffd097          	auipc	ra,0xffffd
    80002f84:	630080e7          	jalr	1584(ra) # 800005b0 <printf>
    80002f88:	a0d9                	j	8000304e <syscall+0x16c>
        printf("(");
    80002f8a:	00005517          	auipc	a0,0x5
    80002f8e:	5be50513          	addi	a0,a0,1470 # 80008548 <syscalls+0xe0>
    80002f92:	ffffd097          	auipc	ra,0xffffd
    80002f96:	61e080e7          	jalr	1566(ra) # 800005b0 <printf>
        for(int i = 0; i < numOfArgs[num]; i++){
    80002f9a:	00291713          	slli	a4,s2,0x2
    80002f9e:	0c89a783          	lw	a5,200(s3)
    80002fa2:	06f05e63          	blez	a5,8000301e <syscall+0x13c>
    int trapframea0_cpy = p->trapframe->a0;
    80002fa6:	2a01                	sext.w	s4,s4
        for(int i = 0; i < numOfArgs[num]; i++){
    80002fa8:	4981                	li	s3,0
            printf("%d", trapframea0_cpy);
    80002faa:	00005a97          	auipc	s5,0x5
    80002fae:	5aea8a93          	addi	s5,s5,1454 # 80008558 <syscalls+0xf0>
            printf(", ");
    80002fb2:	00005b97          	auipc	s7,0x5
    80002fb6:	59eb8b93          	addi	s7,s7,1438 # 80008550 <syscalls+0xe8>
          else if(i==1) 
    80002fba:	4b05                	li	s6,1
          else if(i==2) 
    80002fbc:	4c09                	li	s8,2
        for(int i = 0; i < numOfArgs[num]; i++){
    80002fbe:	00006797          	auipc	a5,0x6
    80002fc2:	9ea78793          	addi	a5,a5,-1558 # 800089a8 <sysCallName>
    80002fc6:	00e78933          	add	s2,a5,a4
    80002fca:	a82d                	j	80003004 <syscall+0x122>
            printf(", ");
    80002fcc:	855e                	mv	a0,s7
    80002fce:	ffffd097          	auipc	ra,0xffffd
    80002fd2:	5e2080e7          	jalr	1506(ra) # 800005b0 <printf>
          else if(i==1) 
    80002fd6:	03698c63          	beq	s3,s6,8000300e <syscall+0x12c>
          else if(i==2) 
    80002fda:	03899063          	bne	s3,s8,80002ffa <syscall+0x118>
            printf("%d", p->trapframe->a2);
    80002fde:	6cbc                	ld	a5,88(s1)
    80002fe0:	63cc                	ld	a1,128(a5)
    80002fe2:	8556                	mv	a0,s5
    80002fe4:	ffffd097          	auipc	ra,0xffffd
    80002fe8:	5cc080e7          	jalr	1484(ra) # 800005b0 <printf>
    80002fec:	a039                	j	80002ffa <syscall+0x118>
            printf("%d", trapframea0_cpy);
    80002fee:	85d2                	mv	a1,s4
    80002ff0:	8556                	mv	a0,s5
    80002ff2:	ffffd097          	auipc	ra,0xffffd
    80002ff6:	5be080e7          	jalr	1470(ra) # 800005b0 <printf>
        for(int i = 0; i < numOfArgs[num]; i++){
    80002ffa:	2985                	addiw	s3,s3,1
    80002ffc:	0c892783          	lw	a5,200(s2)
    80003000:	00f9df63          	bge	s3,a5,8000301e <syscall+0x13c>
          if(i > 0) 
    80003004:	fd3044e3          	bgtz	s3,80002fcc <syscall+0xea>
          if(i == 0) 
    80003008:	fe0983e3          	beqz	s3,80002fee <syscall+0x10c>
    8000300c:	b7fd                	j	80002ffa <syscall+0x118>
            printf("%d", p->trapframe->a1);
    8000300e:	6cbc                	ld	a5,88(s1)
    80003010:	7fac                	ld	a1,120(a5)
    80003012:	8556                	mv	a0,s5
    80003014:	ffffd097          	auipc	ra,0xffffd
    80003018:	59c080e7          	jalr	1436(ra) # 800005b0 <printf>
    8000301c:	bff9                	j	80002ffa <syscall+0x118>
        printf(")");
    8000301e:	00005517          	auipc	a0,0x5
    80003022:	54250513          	addi	a0,a0,1346 # 80008560 <syscalls+0xf8>
    80003026:	ffffd097          	auipc	ra,0xffffd
    8000302a:	58a080e7          	jalr	1418(ra) # 800005b0 <printf>
    8000302e:	b799                	j	80002f74 <syscall+0x92>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003030:	86ca                	mv	a3,s2
    80003032:	15848613          	addi	a2,s1,344
    80003036:	588c                	lw	a1,48(s1)
    80003038:	00005517          	auipc	a0,0x5
    8000303c:	53850513          	addi	a0,a0,1336 # 80008570 <syscalls+0x108>
    80003040:	ffffd097          	auipc	ra,0xffffd
    80003044:	570080e7          	jalr	1392(ra) # 800005b0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003048:	6cbc                	ld	a5,88(s1)
    8000304a:	577d                	li	a4,-1
    8000304c:	fbb8                	sd	a4,112(a5)
  }
}
    8000304e:	60a6                	ld	ra,72(sp)
    80003050:	6406                	ld	s0,64(sp)
    80003052:	74e2                	ld	s1,56(sp)
    80003054:	7942                	ld	s2,48(sp)
    80003056:	79a2                	ld	s3,40(sp)
    80003058:	7a02                	ld	s4,32(sp)
    8000305a:	6ae2                	ld	s5,24(sp)
    8000305c:	6b42                	ld	s6,16(sp)
    8000305e:	6ba2                	ld	s7,8(sp)
    80003060:	6c02                	ld	s8,0(sp)
    80003062:	6161                	addi	sp,sp,80
    80003064:	8082                	ret

0000000080003066 <sys_exit>:
#include "proc.h"


uint64
sys_exit(void)
{
    80003066:	1101                	addi	sp,sp,-32
    80003068:	ec06                	sd	ra,24(sp)
    8000306a:	e822                	sd	s0,16(sp)
    8000306c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000306e:	fec40593          	addi	a1,s0,-20
    80003072:	4501                	li	a0,0
    80003074:	00000097          	auipc	ra,0x0
    80003078:	dfa080e7          	jalr	-518(ra) # 80002e6e <argint>
    return -1;
    8000307c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000307e:	00054963          	bltz	a0,80003090 <sys_exit+0x2a>
  exit(n);
    80003082:	fec42503          	lw	a0,-20(s0)
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	4f4080e7          	jalr	1268(ra) # 8000257a <exit>
  return 0;  // not reached
    8000308e:	4781                	li	a5,0
}
    80003090:	853e                	mv	a0,a5
    80003092:	60e2                	ld	ra,24(sp)
    80003094:	6442                	ld	s0,16(sp)
    80003096:	6105                	addi	sp,sp,32
    80003098:	8082                	ret

000000008000309a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000309a:	1141                	addi	sp,sp,-16
    8000309c:	e406                	sd	ra,8(sp)
    8000309e:	e022                	sd	s0,0(sp)
    800030a0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	996080e7          	jalr	-1642(ra) # 80001a38 <myproc>
}
    800030aa:	5908                	lw	a0,48(a0)
    800030ac:	60a2                	ld	ra,8(sp)
    800030ae:	6402                	ld	s0,0(sp)
    800030b0:	0141                	addi	sp,sp,16
    800030b2:	8082                	ret

00000000800030b4 <sys_fork>:

uint64
sys_fork(void)
{
    800030b4:	1141                	addi	sp,sp,-16
    800030b6:	e406                	sd	ra,8(sp)
    800030b8:	e022                	sd	s0,0(sp)
    800030ba:	0800                	addi	s0,sp,16
  return fork();
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	d90080e7          	jalr	-624(ra) # 80001e4c <fork>
}
    800030c4:	60a2                	ld	ra,8(sp)
    800030c6:	6402                	ld	s0,0(sp)
    800030c8:	0141                	addi	sp,sp,16
    800030ca:	8082                	ret

00000000800030cc <sys_wait>:

uint64
sys_wait(void)
{
    800030cc:	1101                	addi	sp,sp,-32
    800030ce:	ec06                	sd	ra,24(sp)
    800030d0:	e822                	sd	s0,16(sp)
    800030d2:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800030d4:	fe840593          	addi	a1,s0,-24
    800030d8:	4501                	li	a0,0
    800030da:	00000097          	auipc	ra,0x0
    800030de:	db6080e7          	jalr	-586(ra) # 80002e90 <argaddr>
    return -1;
    800030e2:	57fd                	li	a5,-1
  if(argaddr(0, &p) < 0)
    800030e4:	00054963          	bltz	a0,800030f6 <sys_wait+0x2a>
  return wait(p);
    800030e8:	fe843503          	ld	a0,-24(s0)
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	130080e7          	jalr	304(ra) # 8000221c <wait>
    800030f4:	87aa                	mv	a5,a0
}
    800030f6:	853e                	mv	a0,a5
    800030f8:	60e2                	ld	ra,24(sp)
    800030fa:	6442                	ld	s0,16(sp)
    800030fc:	6105                	addi	sp,sp,32
    800030fe:	8082                	ret

0000000080003100 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003100:	7139                	addi	sp,sp,-64
    80003102:	fc06                	sd	ra,56(sp)
    80003104:	f822                	sd	s0,48(sp)
    80003106:	f426                	sd	s1,40(sp)
    80003108:	f04a                	sd	s2,32(sp)
    8000310a:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  if(argaddr(0, &addr) < 0)
    8000310c:	fd840593          	addi	a1,s0,-40
    80003110:	4501                	li	a0,0
    80003112:	00000097          	auipc	ra,0x0
    80003116:	d7e080e7          	jalr	-642(ra) # 80002e90 <argaddr>
    return -1;
    8000311a:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0)
    8000311c:	08054063          	bltz	a0,8000319c <sys_waitx+0x9c>
  if(argaddr(1, &addr1) < 0) // user virtual memory
    80003120:	fd040593          	addi	a1,s0,-48
    80003124:	4505                	li	a0,1
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	d6a080e7          	jalr	-662(ra) # 80002e90 <argaddr>
    return -1;
    8000312e:	57fd                	li	a5,-1
  if(argaddr(1, &addr1) < 0) // user virtual memory
    80003130:	06054663          	bltz	a0,8000319c <sys_waitx+0x9c>
  if(argaddr(2, &addr2) < 0)
    80003134:	fc840593          	addi	a1,s0,-56
    80003138:	4509                	li	a0,2
    8000313a:	00000097          	auipc	ra,0x0
    8000313e:	d56080e7          	jalr	-682(ra) # 80002e90 <argaddr>
    return -1;
    80003142:	57fd                	li	a5,-1
  if(argaddr(2, &addr2) < 0)
    80003144:	04054c63          	bltz	a0,8000319c <sys_waitx+0x9c>
  int ret = waitx(addr, &wtime, &rtime);
    80003148:	fc040613          	addi	a2,s0,-64
    8000314c:	fc440593          	addi	a1,s0,-60
    80003150:	fd843503          	ld	a0,-40(s0)
    80003154:	fffff097          	auipc	ra,0xfffff
    80003158:	1f0080e7          	jalr	496(ra) # 80002344 <waitx>
    8000315c:	892a                	mv	s2,a0
  struct proc* p = myproc();
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	8da080e7          	jalr	-1830(ra) # 80001a38 <myproc>
    80003166:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1,(char*)&wtime, sizeof(int)) < 0)
    80003168:	4691                	li	a3,4
    8000316a:	fc440613          	addi	a2,s0,-60
    8000316e:	fd043583          	ld	a1,-48(s0)
    80003172:	6928                	ld	a0,80(a0)
    80003174:	ffffe097          	auipc	ra,0xffffe
    80003178:	56e080e7          	jalr	1390(ra) # 800016e2 <copyout>
    return -1;
    8000317c:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1,(char*)&wtime, sizeof(int)) < 0)
    8000317e:	00054f63          	bltz	a0,8000319c <sys_waitx+0x9c>
  if (copyout(p->pagetable, addr2,(char*)&rtime, sizeof(int)) < 0)
    80003182:	4691                	li	a3,4
    80003184:	fc040613          	addi	a2,s0,-64
    80003188:	fc843583          	ld	a1,-56(s0)
    8000318c:	68a8                	ld	a0,80(s1)
    8000318e:	ffffe097          	auipc	ra,0xffffe
    80003192:	554080e7          	jalr	1364(ra) # 800016e2 <copyout>
    80003196:	00054a63          	bltz	a0,800031aa <sys_waitx+0xaa>
    return -1;
  return ret;
    8000319a:	87ca                	mv	a5,s2
}
    8000319c:	853e                	mv	a0,a5
    8000319e:	70e2                	ld	ra,56(sp)
    800031a0:	7442                	ld	s0,48(sp)
    800031a2:	74a2                	ld	s1,40(sp)
    800031a4:	7902                	ld	s2,32(sp)
    800031a6:	6121                	addi	sp,sp,64
    800031a8:	8082                	ret
    return -1;
    800031aa:	57fd                	li	a5,-1
    800031ac:	bfc5                	j	8000319c <sys_waitx+0x9c>

00000000800031ae <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800031ae:	7179                	addi	sp,sp,-48
    800031b0:	f406                	sd	ra,40(sp)
    800031b2:	f022                	sd	s0,32(sp)
    800031b4:	ec26                	sd	s1,24(sp)
    800031b6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800031b8:	fdc40593          	addi	a1,s0,-36
    800031bc:	4501                	li	a0,0
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	cb0080e7          	jalr	-848(ra) # 80002e6e <argint>
    return -1;
    800031c6:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    800031c8:	00054f63          	bltz	a0,800031e6 <sys_sbrk+0x38>
  addr = myproc()->sz;
    800031cc:	fffff097          	auipc	ra,0xfffff
    800031d0:	86c080e7          	jalr	-1940(ra) # 80001a38 <myproc>
    800031d4:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800031d6:	fdc42503          	lw	a0,-36(s0)
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	bfa080e7          	jalr	-1030(ra) # 80001dd4 <growproc>
    800031e2:	00054863          	bltz	a0,800031f2 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    800031e6:	8526                	mv	a0,s1
    800031e8:	70a2                	ld	ra,40(sp)
    800031ea:	7402                	ld	s0,32(sp)
    800031ec:	64e2                	ld	s1,24(sp)
    800031ee:	6145                	addi	sp,sp,48
    800031f0:	8082                	ret
    return -1;
    800031f2:	54fd                	li	s1,-1
    800031f4:	bfcd                	j	800031e6 <sys_sbrk+0x38>

00000000800031f6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800031f6:	7139                	addi	sp,sp,-64
    800031f8:	fc06                	sd	ra,56(sp)
    800031fa:	f822                	sd	s0,48(sp)
    800031fc:	f426                	sd	s1,40(sp)
    800031fe:	f04a                	sd	s2,32(sp)
    80003200:	ec4e                	sd	s3,24(sp)
    80003202:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003204:	fcc40593          	addi	a1,s0,-52
    80003208:	4501                	li	a0,0
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	c64080e7          	jalr	-924(ra) # 80002e6e <argint>
    return -1;
    80003212:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80003214:	06054763          	bltz	a0,80003282 <sys_sleep+0x8c>
  acquire(&tickslock);
    80003218:	00015517          	auipc	a0,0x15
    8000321c:	cb850513          	addi	a0,a0,-840 # 80017ed0 <tickslock>
    80003220:	ffffe097          	auipc	ra,0xffffe
    80003224:	a12080e7          	jalr	-1518(ra) # 80000c32 <acquire>
  ticks0 = ticks;
    80003228:	00006797          	auipc	a5,0x6
    8000322c:	e0878793          	addi	a5,a5,-504 # 80009030 <ticks>
    80003230:	0007a903          	lw	s2,0(a5)
  while(ticks - ticks0 < n){
    80003234:	fcc42783          	lw	a5,-52(s0)
    80003238:	cf85                	beqz	a5,80003270 <sys_sleep+0x7a>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000323a:	00015997          	auipc	s3,0x15
    8000323e:	c9698993          	addi	s3,s3,-874 # 80017ed0 <tickslock>
    80003242:	00006497          	auipc	s1,0x6
    80003246:	dee48493          	addi	s1,s1,-530 # 80009030 <ticks>
    if(myproc()->killed){
    8000324a:	ffffe097          	auipc	ra,0xffffe
    8000324e:	7ee080e7          	jalr	2030(ra) # 80001a38 <myproc>
    80003252:	551c                	lw	a5,40(a0)
    80003254:	ef9d                	bnez	a5,80003292 <sys_sleep+0x9c>
    sleep(&ticks, &tickslock);
    80003256:	85ce                	mv	a1,s3
    80003258:	8526                	mv	a0,s1
    8000325a:	fffff097          	auipc	ra,0xfffff
    8000325e:	f50080e7          	jalr	-176(ra) # 800021aa <sleep>
  while(ticks - ticks0 < n){
    80003262:	409c                	lw	a5,0(s1)
    80003264:	412787bb          	subw	a5,a5,s2
    80003268:	fcc42703          	lw	a4,-52(s0)
    8000326c:	fce7efe3          	bltu	a5,a4,8000324a <sys_sleep+0x54>
  }
  release(&tickslock);
    80003270:	00015517          	auipc	a0,0x15
    80003274:	c6050513          	addi	a0,a0,-928 # 80017ed0 <tickslock>
    80003278:	ffffe097          	auipc	ra,0xffffe
    8000327c:	a6e080e7          	jalr	-1426(ra) # 80000ce6 <release>
  return 0;
    80003280:	4781                	li	a5,0
}
    80003282:	853e                	mv	a0,a5
    80003284:	70e2                	ld	ra,56(sp)
    80003286:	7442                	ld	s0,48(sp)
    80003288:	74a2                	ld	s1,40(sp)
    8000328a:	7902                	ld	s2,32(sp)
    8000328c:	69e2                	ld	s3,24(sp)
    8000328e:	6121                	addi	sp,sp,64
    80003290:	8082                	ret
      release(&tickslock);
    80003292:	00015517          	auipc	a0,0x15
    80003296:	c3e50513          	addi	a0,a0,-962 # 80017ed0 <tickslock>
    8000329a:	ffffe097          	auipc	ra,0xffffe
    8000329e:	a4c080e7          	jalr	-1460(ra) # 80000ce6 <release>
      return -1;
    800032a2:	57fd                	li	a5,-1
    800032a4:	bff9                	j	80003282 <sys_sleep+0x8c>

00000000800032a6 <sys_kill>:

uint64
sys_kill(void)
{
    800032a6:	1101                	addi	sp,sp,-32
    800032a8:	ec06                	sd	ra,24(sp)
    800032aa:	e822                	sd	s0,16(sp)
    800032ac:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800032ae:	fec40593          	addi	a1,s0,-20
    800032b2:	4501                	li	a0,0
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	bba080e7          	jalr	-1094(ra) # 80002e6e <argint>
    return -1;
    800032bc:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0)
    800032be:	00054963          	bltz	a0,800032d0 <sys_kill+0x2a>
  return kill(pid);
    800032c2:	fec42503          	lw	a0,-20(s0)
    800032c6:	fffff097          	auipc	ra,0xfffff
    800032ca:	39a080e7          	jalr	922(ra) # 80002660 <kill>
    800032ce:	87aa                	mv	a5,a0
}
    800032d0:	853e                	mv	a0,a5
    800032d2:	60e2                	ld	ra,24(sp)
    800032d4:	6442                	ld	s0,16(sp)
    800032d6:	6105                	addi	sp,sp,32
    800032d8:	8082                	ret

00000000800032da <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800032da:	1101                	addi	sp,sp,-32
    800032dc:	ec06                	sd	ra,24(sp)
    800032de:	e822                	sd	s0,16(sp)
    800032e0:	e426                	sd	s1,8(sp)
    800032e2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800032e4:	00015517          	auipc	a0,0x15
    800032e8:	bec50513          	addi	a0,a0,-1044 # 80017ed0 <tickslock>
    800032ec:	ffffe097          	auipc	ra,0xffffe
    800032f0:	946080e7          	jalr	-1722(ra) # 80000c32 <acquire>
  xticks = ticks;
    800032f4:	00006797          	auipc	a5,0x6
    800032f8:	d3c78793          	addi	a5,a5,-708 # 80009030 <ticks>
    800032fc:	4384                	lw	s1,0(a5)
  release(&tickslock);
    800032fe:	00015517          	auipc	a0,0x15
    80003302:	bd250513          	addi	a0,a0,-1070 # 80017ed0 <tickslock>
    80003306:	ffffe097          	auipc	ra,0xffffe
    8000330a:	9e0080e7          	jalr	-1568(ra) # 80000ce6 <release>
  return xticks;
}
    8000330e:	02049513          	slli	a0,s1,0x20
    80003312:	9101                	srli	a0,a0,0x20
    80003314:	60e2                	ld	ra,24(sp)
    80003316:	6442                	ld	s0,16(sp)
    80003318:	64a2                	ld	s1,8(sp)
    8000331a:	6105                	addi	sp,sp,32
    8000331c:	8082                	ret

000000008000331e <sys_trace>:

uint64
sys_trace(void)
{
    8000331e:	7179                	addi	sp,sp,-48
    80003320:	f406                	sd	ra,40(sp)
    80003322:	f022                	sd	s0,32(sp)
    80003324:	ec26                	sd	s1,24(sp)
    80003326:	1800                	addi	s0,sp,48
  int mask = 0;
    80003328:	fc042e23          	sw	zero,-36(s0)
  if (argint(0, &mask) < 0)
    8000332c:	fdc40593          	addi	a1,s0,-36
    80003330:	4501                	li	a0,0
    80003332:	00000097          	auipc	ra,0x0
    80003336:	b3c080e7          	jalr	-1220(ra) # 80002e6e <argint>
    return -1;
    8000333a:	57fd                	li	a5,-1
  if (argint(0, &mask) < 0)
    8000333c:	00054b63          	bltz	a0,80003352 <sys_trace+0x34>
  myproc()->mask = mask;
    80003340:	fdc42483          	lw	s1,-36(s0)
    80003344:	ffffe097          	auipc	ra,0xffffe
    80003348:	6f4080e7          	jalr	1780(ra) # 80001a38 <myproc>
    8000334c:	16952e23          	sw	s1,380(a0)
  return 0;
    80003350:	4781                	li	a5,0
}
    80003352:	853e                	mv	a0,a5
    80003354:	70a2                	ld	ra,40(sp)
    80003356:	7402                	ld	s0,32(sp)
    80003358:	64e2                	ld	s1,24(sp)
    8000335a:	6145                	addi	sp,sp,48
    8000335c:	8082                	ret

000000008000335e <sys_setpriority>:

uint64
sys_setpriority(void)
{
    8000335e:	1101                	addi	sp,sp,-32
    80003360:	ec06                	sd	ra,24(sp)
    80003362:	e822                	sd	s0,16(sp)
    80003364:	1000                	addi	s0,sp,32
  int priority, pid;
  if (argint(0, &priority) < 0)
    80003366:	fec40593          	addi	a1,s0,-20
    8000336a:	4501                	li	a0,0
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	b02080e7          	jalr	-1278(ra) # 80002e6e <argint>
    return -1;
    80003374:	57fd                	li	a5,-1
  if (argint(0, &priority) < 0)
    80003376:	02054563          	bltz	a0,800033a0 <sys_setpriority+0x42>
  if (argint(1, &pid) < 0)
    8000337a:	fe840593          	addi	a1,s0,-24
    8000337e:	4505                	li	a0,1
    80003380:	00000097          	auipc	ra,0x0
    80003384:	aee080e7          	jalr	-1298(ra) # 80002e6e <argint>
    return -1;
    80003388:	57fd                	li	a5,-1
  if (argint(1, &pid) < 0)
    8000338a:	00054b63          	bltz	a0,800033a0 <sys_setpriority+0x42>
  return setpriority(priority, pid);
    8000338e:	fe842583          	lw	a1,-24(s0)
    80003392:	fec42503          	lw	a0,-20(s0)
    80003396:	fffff097          	auipc	ra,0xfffff
    8000339a:	508080e7          	jalr	1288(ra) # 8000289e <setpriority>
    8000339e:	87aa                	mv	a5,a0
    800033a0:	853e                	mv	a0,a5
    800033a2:	60e2                	ld	ra,24(sp)
    800033a4:	6442                	ld	s0,16(sp)
    800033a6:	6105                	addi	sp,sp,32
    800033a8:	8082                	ret

00000000800033aa <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800033aa:	7179                	addi	sp,sp,-48
    800033ac:	f406                	sd	ra,40(sp)
    800033ae:	f022                	sd	s0,32(sp)
    800033b0:	ec26                	sd	s1,24(sp)
    800033b2:	e84a                	sd	s2,16(sp)
    800033b4:	e44e                	sd	s3,8(sp)
    800033b6:	e052                	sd	s4,0(sp)
    800033b8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800033ba:	00005597          	auipc	a1,0x5
    800033be:	28e58593          	addi	a1,a1,654 # 80008648 <syscalls+0x1e0>
    800033c2:	00015517          	auipc	a0,0x15
    800033c6:	b2650513          	addi	a0,a0,-1242 # 80017ee8 <bcache>
    800033ca:	ffffd097          	auipc	ra,0xffffd
    800033ce:	7d8080e7          	jalr	2008(ra) # 80000ba2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800033d2:	0001d797          	auipc	a5,0x1d
    800033d6:	b1678793          	addi	a5,a5,-1258 # 8001fee8 <bcache+0x8000>
    800033da:	0001d717          	auipc	a4,0x1d
    800033de:	d7670713          	addi	a4,a4,-650 # 80020150 <bcache+0x8268>
    800033e2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800033e6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033ea:	00015497          	auipc	s1,0x15
    800033ee:	b1648493          	addi	s1,s1,-1258 # 80017f00 <bcache+0x18>
    b->next = bcache.head.next;
    800033f2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800033f4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800033f6:	00005a17          	auipc	s4,0x5
    800033fa:	25aa0a13          	addi	s4,s4,602 # 80008650 <syscalls+0x1e8>
    b->next = bcache.head.next;
    800033fe:	2b893783          	ld	a5,696(s2)
    80003402:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003404:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003408:	85d2                	mv	a1,s4
    8000340a:	01048513          	addi	a0,s1,16
    8000340e:	00001097          	auipc	ra,0x1
    80003412:	528080e7          	jalr	1320(ra) # 80004936 <initsleeplock>
    bcache.head.next->prev = b;
    80003416:	2b893783          	ld	a5,696(s2)
    8000341a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000341c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003420:	45848493          	addi	s1,s1,1112
    80003424:	fd349de3          	bne	s1,s3,800033fe <binit+0x54>
  }
}
    80003428:	70a2                	ld	ra,40(sp)
    8000342a:	7402                	ld	s0,32(sp)
    8000342c:	64e2                	ld	s1,24(sp)
    8000342e:	6942                	ld	s2,16(sp)
    80003430:	69a2                	ld	s3,8(sp)
    80003432:	6a02                	ld	s4,0(sp)
    80003434:	6145                	addi	sp,sp,48
    80003436:	8082                	ret

0000000080003438 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003438:	7179                	addi	sp,sp,-48
    8000343a:	f406                	sd	ra,40(sp)
    8000343c:	f022                	sd	s0,32(sp)
    8000343e:	ec26                	sd	s1,24(sp)
    80003440:	e84a                	sd	s2,16(sp)
    80003442:	e44e                	sd	s3,8(sp)
    80003444:	1800                	addi	s0,sp,48
    80003446:	89aa                	mv	s3,a0
    80003448:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000344a:	00015517          	auipc	a0,0x15
    8000344e:	a9e50513          	addi	a0,a0,-1378 # 80017ee8 <bcache>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	7e0080e7          	jalr	2016(ra) # 80000c32 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000345a:	0001d797          	auipc	a5,0x1d
    8000345e:	a8e78793          	addi	a5,a5,-1394 # 8001fee8 <bcache+0x8000>
    80003462:	2b87b483          	ld	s1,696(a5)
    80003466:	0001d797          	auipc	a5,0x1d
    8000346a:	cea78793          	addi	a5,a5,-790 # 80020150 <bcache+0x8268>
    8000346e:	02f48f63          	beq	s1,a5,800034ac <bread+0x74>
    80003472:	873e                	mv	a4,a5
    80003474:	a021                	j	8000347c <bread+0x44>
    80003476:	68a4                	ld	s1,80(s1)
    80003478:	02e48a63          	beq	s1,a4,800034ac <bread+0x74>
    if(b->dev == dev && b->blockno == blockno){
    8000347c:	449c                	lw	a5,8(s1)
    8000347e:	ff379ce3          	bne	a5,s3,80003476 <bread+0x3e>
    80003482:	44dc                	lw	a5,12(s1)
    80003484:	ff2799e3          	bne	a5,s2,80003476 <bread+0x3e>
      b->refcnt++;
    80003488:	40bc                	lw	a5,64(s1)
    8000348a:	2785                	addiw	a5,a5,1
    8000348c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000348e:	00015517          	auipc	a0,0x15
    80003492:	a5a50513          	addi	a0,a0,-1446 # 80017ee8 <bcache>
    80003496:	ffffe097          	auipc	ra,0xffffe
    8000349a:	850080e7          	jalr	-1968(ra) # 80000ce6 <release>
      acquiresleep(&b->lock);
    8000349e:	01048513          	addi	a0,s1,16
    800034a2:	00001097          	auipc	ra,0x1
    800034a6:	4ce080e7          	jalr	1230(ra) # 80004970 <acquiresleep>
      return b;
    800034aa:	a8b1                	j	80003506 <bread+0xce>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034ac:	0001d797          	auipc	a5,0x1d
    800034b0:	a3c78793          	addi	a5,a5,-1476 # 8001fee8 <bcache+0x8000>
    800034b4:	2b07b483          	ld	s1,688(a5)
    800034b8:	0001d797          	auipc	a5,0x1d
    800034bc:	c9878793          	addi	a5,a5,-872 # 80020150 <bcache+0x8268>
    800034c0:	04f48d63          	beq	s1,a5,8000351a <bread+0xe2>
    if(b->refcnt == 0) {
    800034c4:	40bc                	lw	a5,64(s1)
    800034c6:	cb91                	beqz	a5,800034da <bread+0xa2>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034c8:	0001d717          	auipc	a4,0x1d
    800034cc:	c8870713          	addi	a4,a4,-888 # 80020150 <bcache+0x8268>
    800034d0:	64a4                	ld	s1,72(s1)
    800034d2:	04e48463          	beq	s1,a4,8000351a <bread+0xe2>
    if(b->refcnt == 0) {
    800034d6:	40bc                	lw	a5,64(s1)
    800034d8:	ffe5                	bnez	a5,800034d0 <bread+0x98>
      b->dev = dev;
    800034da:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800034de:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800034e2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800034e6:	4785                	li	a5,1
    800034e8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034ea:	00015517          	auipc	a0,0x15
    800034ee:	9fe50513          	addi	a0,a0,-1538 # 80017ee8 <bcache>
    800034f2:	ffffd097          	auipc	ra,0xffffd
    800034f6:	7f4080e7          	jalr	2036(ra) # 80000ce6 <release>
      acquiresleep(&b->lock);
    800034fa:	01048513          	addi	a0,s1,16
    800034fe:	00001097          	auipc	ra,0x1
    80003502:	472080e7          	jalr	1138(ra) # 80004970 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003506:	409c                	lw	a5,0(s1)
    80003508:	c38d                	beqz	a5,8000352a <bread+0xf2>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000350a:	8526                	mv	a0,s1
    8000350c:	70a2                	ld	ra,40(sp)
    8000350e:	7402                	ld	s0,32(sp)
    80003510:	64e2                	ld	s1,24(sp)
    80003512:	6942                	ld	s2,16(sp)
    80003514:	69a2                	ld	s3,8(sp)
    80003516:	6145                	addi	sp,sp,48
    80003518:	8082                	ret
  panic("bget: no buffers");
    8000351a:	00005517          	auipc	a0,0x5
    8000351e:	13e50513          	addi	a0,a0,318 # 80008658 <syscalls+0x1f0>
    80003522:	ffffd097          	auipc	ra,0xffffd
    80003526:	044080e7          	jalr	68(ra) # 80000566 <panic>
    virtio_disk_rw(b, 0);
    8000352a:	4581                	li	a1,0
    8000352c:	8526                	mv	a0,s1
    8000352e:	00003097          	auipc	ra,0x3
    80003532:	fc8080e7          	jalr	-56(ra) # 800064f6 <virtio_disk_rw>
    b->valid = 1;
    80003536:	4785                	li	a5,1
    80003538:	c09c                	sw	a5,0(s1)
  return b;
    8000353a:	bfc1                	j	8000350a <bread+0xd2>

000000008000353c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	e426                	sd	s1,8(sp)
    80003544:	1000                	addi	s0,sp,32
    80003546:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003548:	0541                	addi	a0,a0,16
    8000354a:	00001097          	auipc	ra,0x1
    8000354e:	4c0080e7          	jalr	1216(ra) # 80004a0a <holdingsleep>
    80003552:	cd01                	beqz	a0,8000356a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003554:	4585                	li	a1,1
    80003556:	8526                	mv	a0,s1
    80003558:	00003097          	auipc	ra,0x3
    8000355c:	f9e080e7          	jalr	-98(ra) # 800064f6 <virtio_disk_rw>
}
    80003560:	60e2                	ld	ra,24(sp)
    80003562:	6442                	ld	s0,16(sp)
    80003564:	64a2                	ld	s1,8(sp)
    80003566:	6105                	addi	sp,sp,32
    80003568:	8082                	ret
    panic("bwrite");
    8000356a:	00005517          	auipc	a0,0x5
    8000356e:	10650513          	addi	a0,a0,262 # 80008670 <syscalls+0x208>
    80003572:	ffffd097          	auipc	ra,0xffffd
    80003576:	ff4080e7          	jalr	-12(ra) # 80000566 <panic>

000000008000357a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000357a:	1101                	addi	sp,sp,-32
    8000357c:	ec06                	sd	ra,24(sp)
    8000357e:	e822                	sd	s0,16(sp)
    80003580:	e426                	sd	s1,8(sp)
    80003582:	e04a                	sd	s2,0(sp)
    80003584:	1000                	addi	s0,sp,32
    80003586:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003588:	01050913          	addi	s2,a0,16
    8000358c:	854a                	mv	a0,s2
    8000358e:	00001097          	auipc	ra,0x1
    80003592:	47c080e7          	jalr	1148(ra) # 80004a0a <holdingsleep>
    80003596:	c92d                	beqz	a0,80003608 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003598:	854a                	mv	a0,s2
    8000359a:	00001097          	auipc	ra,0x1
    8000359e:	42c080e7          	jalr	1068(ra) # 800049c6 <releasesleep>

  acquire(&bcache.lock);
    800035a2:	00015517          	auipc	a0,0x15
    800035a6:	94650513          	addi	a0,a0,-1722 # 80017ee8 <bcache>
    800035aa:	ffffd097          	auipc	ra,0xffffd
    800035ae:	688080e7          	jalr	1672(ra) # 80000c32 <acquire>
  b->refcnt--;
    800035b2:	40bc                	lw	a5,64(s1)
    800035b4:	37fd                	addiw	a5,a5,-1
    800035b6:	0007871b          	sext.w	a4,a5
    800035ba:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800035bc:	eb05                	bnez	a4,800035ec <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035be:	68bc                	ld	a5,80(s1)
    800035c0:	64b8                	ld	a4,72(s1)
    800035c2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800035c4:	64bc                	ld	a5,72(s1)
    800035c6:	68b8                	ld	a4,80(s1)
    800035c8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800035ca:	0001d797          	auipc	a5,0x1d
    800035ce:	91e78793          	addi	a5,a5,-1762 # 8001fee8 <bcache+0x8000>
    800035d2:	2b87b703          	ld	a4,696(a5)
    800035d6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800035d8:	0001d717          	auipc	a4,0x1d
    800035dc:	b7870713          	addi	a4,a4,-1160 # 80020150 <bcache+0x8268>
    800035e0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800035e2:	2b87b703          	ld	a4,696(a5)
    800035e6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800035e8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800035ec:	00015517          	auipc	a0,0x15
    800035f0:	8fc50513          	addi	a0,a0,-1796 # 80017ee8 <bcache>
    800035f4:	ffffd097          	auipc	ra,0xffffd
    800035f8:	6f2080e7          	jalr	1778(ra) # 80000ce6 <release>
}
    800035fc:	60e2                	ld	ra,24(sp)
    800035fe:	6442                	ld	s0,16(sp)
    80003600:	64a2                	ld	s1,8(sp)
    80003602:	6902                	ld	s2,0(sp)
    80003604:	6105                	addi	sp,sp,32
    80003606:	8082                	ret
    panic("brelse");
    80003608:	00005517          	auipc	a0,0x5
    8000360c:	07050513          	addi	a0,a0,112 # 80008678 <syscalls+0x210>
    80003610:	ffffd097          	auipc	ra,0xffffd
    80003614:	f56080e7          	jalr	-170(ra) # 80000566 <panic>

0000000080003618 <bpin>:

void
bpin(struct buf *b) {
    80003618:	1101                	addi	sp,sp,-32
    8000361a:	ec06                	sd	ra,24(sp)
    8000361c:	e822                	sd	s0,16(sp)
    8000361e:	e426                	sd	s1,8(sp)
    80003620:	1000                	addi	s0,sp,32
    80003622:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003624:	00015517          	auipc	a0,0x15
    80003628:	8c450513          	addi	a0,a0,-1852 # 80017ee8 <bcache>
    8000362c:	ffffd097          	auipc	ra,0xffffd
    80003630:	606080e7          	jalr	1542(ra) # 80000c32 <acquire>
  b->refcnt++;
    80003634:	40bc                	lw	a5,64(s1)
    80003636:	2785                	addiw	a5,a5,1
    80003638:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000363a:	00015517          	auipc	a0,0x15
    8000363e:	8ae50513          	addi	a0,a0,-1874 # 80017ee8 <bcache>
    80003642:	ffffd097          	auipc	ra,0xffffd
    80003646:	6a4080e7          	jalr	1700(ra) # 80000ce6 <release>
}
    8000364a:	60e2                	ld	ra,24(sp)
    8000364c:	6442                	ld	s0,16(sp)
    8000364e:	64a2                	ld	s1,8(sp)
    80003650:	6105                	addi	sp,sp,32
    80003652:	8082                	ret

0000000080003654 <bunpin>:

void
bunpin(struct buf *b) {
    80003654:	1101                	addi	sp,sp,-32
    80003656:	ec06                	sd	ra,24(sp)
    80003658:	e822                	sd	s0,16(sp)
    8000365a:	e426                	sd	s1,8(sp)
    8000365c:	1000                	addi	s0,sp,32
    8000365e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003660:	00015517          	auipc	a0,0x15
    80003664:	88850513          	addi	a0,a0,-1912 # 80017ee8 <bcache>
    80003668:	ffffd097          	auipc	ra,0xffffd
    8000366c:	5ca080e7          	jalr	1482(ra) # 80000c32 <acquire>
  b->refcnt--;
    80003670:	40bc                	lw	a5,64(s1)
    80003672:	37fd                	addiw	a5,a5,-1
    80003674:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003676:	00015517          	auipc	a0,0x15
    8000367a:	87250513          	addi	a0,a0,-1934 # 80017ee8 <bcache>
    8000367e:	ffffd097          	auipc	ra,0xffffd
    80003682:	668080e7          	jalr	1640(ra) # 80000ce6 <release>
}
    80003686:	60e2                	ld	ra,24(sp)
    80003688:	6442                	ld	s0,16(sp)
    8000368a:	64a2                	ld	s1,8(sp)
    8000368c:	6105                	addi	sp,sp,32
    8000368e:	8082                	ret

0000000080003690 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003690:	1101                	addi	sp,sp,-32
    80003692:	ec06                	sd	ra,24(sp)
    80003694:	e822                	sd	s0,16(sp)
    80003696:	e426                	sd	s1,8(sp)
    80003698:	e04a                	sd	s2,0(sp)
    8000369a:	1000                	addi	s0,sp,32
    8000369c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000369e:	00d5d59b          	srliw	a1,a1,0xd
    800036a2:	0001d797          	auipc	a5,0x1d
    800036a6:	f0678793          	addi	a5,a5,-250 # 800205a8 <sb>
    800036aa:	4fdc                	lw	a5,28(a5)
    800036ac:	9dbd                	addw	a1,a1,a5
    800036ae:	00000097          	auipc	ra,0x0
    800036b2:	d8a080e7          	jalr	-630(ra) # 80003438 <bread>
  bi = b % BPB;
    800036b6:	2481                	sext.w	s1,s1
  m = 1 << (bi % 8);
    800036b8:	0074f793          	andi	a5,s1,7
    800036bc:	4705                	li	a4,1
    800036be:	00f7173b          	sllw	a4,a4,a5
  bi = b % BPB;
    800036c2:	6789                	lui	a5,0x2
    800036c4:	17fd                	addi	a5,a5,-1
    800036c6:	8cfd                	and	s1,s1,a5
  if((bp->data[bi/8] & m) == 0)
    800036c8:	41f4d79b          	sraiw	a5,s1,0x1f
    800036cc:	01d7d79b          	srliw	a5,a5,0x1d
    800036d0:	9fa5                	addw	a5,a5,s1
    800036d2:	4037d79b          	sraiw	a5,a5,0x3
    800036d6:	00f506b3          	add	a3,a0,a5
    800036da:	0586c683          	lbu	a3,88(a3)
    800036de:	00d77633          	and	a2,a4,a3
    800036e2:	c61d                	beqz	a2,80003710 <bfree+0x80>
    800036e4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800036e6:	97aa                	add	a5,a5,a0
    800036e8:	fff74713          	not	a4,a4
    800036ec:	8f75                	and	a4,a4,a3
    800036ee:	04e78c23          	sb	a4,88(a5) # 2058 <_entry-0x7fffdfa8>
  log_write(bp);
    800036f2:	00001097          	auipc	ra,0x1
    800036f6:	14a080e7          	jalr	330(ra) # 8000483c <log_write>
  brelse(bp);
    800036fa:	854a                	mv	a0,s2
    800036fc:	00000097          	auipc	ra,0x0
    80003700:	e7e080e7          	jalr	-386(ra) # 8000357a <brelse>
}
    80003704:	60e2                	ld	ra,24(sp)
    80003706:	6442                	ld	s0,16(sp)
    80003708:	64a2                	ld	s1,8(sp)
    8000370a:	6902                	ld	s2,0(sp)
    8000370c:	6105                	addi	sp,sp,32
    8000370e:	8082                	ret
    panic("freeing free block");
    80003710:	00005517          	auipc	a0,0x5
    80003714:	f7050513          	addi	a0,a0,-144 # 80008680 <syscalls+0x218>
    80003718:	ffffd097          	auipc	ra,0xffffd
    8000371c:	e4e080e7          	jalr	-434(ra) # 80000566 <panic>

0000000080003720 <balloc>:
{
    80003720:	711d                	addi	sp,sp,-96
    80003722:	ec86                	sd	ra,88(sp)
    80003724:	e8a2                	sd	s0,80(sp)
    80003726:	e4a6                	sd	s1,72(sp)
    80003728:	e0ca                	sd	s2,64(sp)
    8000372a:	fc4e                	sd	s3,56(sp)
    8000372c:	f852                	sd	s4,48(sp)
    8000372e:	f456                	sd	s5,40(sp)
    80003730:	f05a                	sd	s6,32(sp)
    80003732:	ec5e                	sd	s7,24(sp)
    80003734:	e862                	sd	s8,16(sp)
    80003736:	e466                	sd	s9,8(sp)
    80003738:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000373a:	0001d797          	auipc	a5,0x1d
    8000373e:	e6e78793          	addi	a5,a5,-402 # 800205a8 <sb>
    80003742:	43dc                	lw	a5,4(a5)
    80003744:	10078e63          	beqz	a5,80003860 <balloc+0x140>
    80003748:	8baa                	mv	s7,a0
    8000374a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000374c:	0001db17          	auipc	s6,0x1d
    80003750:	e5cb0b13          	addi	s6,s6,-420 # 800205a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003754:	4c05                	li	s8,1
      m = 1 << (bi % 8);
    80003756:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003758:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000375a:	6c89                	lui	s9,0x2
    8000375c:	a079                	j	800037ea <balloc+0xca>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000375e:	8942                	mv	s2,a6
      m = 1 << (bi % 8);
    80003760:	4705                	li	a4,1
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003762:	4681                	li	a3,0
        bp->data[bi/8] |= m;  // Mark block in use.
    80003764:	96a6                	add	a3,a3,s1
    80003766:	8f51                	or	a4,a4,a2
    80003768:	04e68c23          	sb	a4,88(a3)
        log_write(bp);
    8000376c:	8526                	mv	a0,s1
    8000376e:	00001097          	auipc	ra,0x1
    80003772:	0ce080e7          	jalr	206(ra) # 8000483c <log_write>
        brelse(bp);
    80003776:	8526                	mv	a0,s1
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	e02080e7          	jalr	-510(ra) # 8000357a <brelse>
  bp = bread(dev, bno);
    80003780:	85ca                	mv	a1,s2
    80003782:	855e                	mv	a0,s7
    80003784:	00000097          	auipc	ra,0x0
    80003788:	cb4080e7          	jalr	-844(ra) # 80003438 <bread>
    8000378c:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    8000378e:	40000613          	li	a2,1024
    80003792:	4581                	li	a1,0
    80003794:	05850513          	addi	a0,a0,88
    80003798:	ffffd097          	auipc	ra,0xffffd
    8000379c:	596080e7          	jalr	1430(ra) # 80000d2e <memset>
  log_write(bp);
    800037a0:	8526                	mv	a0,s1
    800037a2:	00001097          	auipc	ra,0x1
    800037a6:	09a080e7          	jalr	154(ra) # 8000483c <log_write>
  brelse(bp);
    800037aa:	8526                	mv	a0,s1
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	dce080e7          	jalr	-562(ra) # 8000357a <brelse>
}
    800037b4:	854a                	mv	a0,s2
    800037b6:	60e6                	ld	ra,88(sp)
    800037b8:	6446                	ld	s0,80(sp)
    800037ba:	64a6                	ld	s1,72(sp)
    800037bc:	6906                	ld	s2,64(sp)
    800037be:	79e2                	ld	s3,56(sp)
    800037c0:	7a42                	ld	s4,48(sp)
    800037c2:	7aa2                	ld	s5,40(sp)
    800037c4:	7b02                	ld	s6,32(sp)
    800037c6:	6be2                	ld	s7,24(sp)
    800037c8:	6c42                	ld	s8,16(sp)
    800037ca:	6ca2                	ld	s9,8(sp)
    800037cc:	6125                	addi	sp,sp,96
    800037ce:	8082                	ret
    brelse(bp);
    800037d0:	8526                	mv	a0,s1
    800037d2:	00000097          	auipc	ra,0x0
    800037d6:	da8080e7          	jalr	-600(ra) # 8000357a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800037da:	015c87bb          	addw	a5,s9,s5
    800037de:	00078a9b          	sext.w	s5,a5
    800037e2:	004b2703          	lw	a4,4(s6)
    800037e6:	06eafd63          	bgeu	s5,a4,80003860 <balloc+0x140>
    bp = bread(dev, BBLOCK(b, sb));
    800037ea:	41fad79b          	sraiw	a5,s5,0x1f
    800037ee:	0137d79b          	srliw	a5,a5,0x13
    800037f2:	015787bb          	addw	a5,a5,s5
    800037f6:	40d7d79b          	sraiw	a5,a5,0xd
    800037fa:	01cb2583          	lw	a1,28(s6)
    800037fe:	9dbd                	addw	a1,a1,a5
    80003800:	855e                	mv	a0,s7
    80003802:	00000097          	auipc	ra,0x0
    80003806:	c36080e7          	jalr	-970(ra) # 80003438 <bread>
    8000380a:	84aa                	mv	s1,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000380c:	000a881b          	sext.w	a6,s5
    80003810:	004b2503          	lw	a0,4(s6)
    80003814:	faa87ee3          	bgeu	a6,a0,800037d0 <balloc+0xb0>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003818:	0584c603          	lbu	a2,88(s1)
    8000381c:	00167793          	andi	a5,a2,1
    80003820:	df9d                	beqz	a5,8000375e <balloc+0x3e>
    80003822:	4105053b          	subw	a0,a0,a6
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003826:	87e2                	mv	a5,s8
    80003828:	0107893b          	addw	s2,a5,a6
    8000382c:	faa782e3          	beq	a5,a0,800037d0 <balloc+0xb0>
      m = 1 << (bi % 8);
    80003830:	41f7d71b          	sraiw	a4,a5,0x1f
    80003834:	01d7561b          	srliw	a2,a4,0x1d
    80003838:	00f606bb          	addw	a3,a2,a5
    8000383c:	0076f713          	andi	a4,a3,7
    80003840:	9f11                	subw	a4,a4,a2
    80003842:	00e9973b          	sllw	a4,s3,a4
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003846:	4036d69b          	sraiw	a3,a3,0x3
    8000384a:	00d48633          	add	a2,s1,a3
    8000384e:	05864603          	lbu	a2,88(a2)
    80003852:	00c775b3          	and	a1,a4,a2
    80003856:	d599                	beqz	a1,80003764 <balloc+0x44>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003858:	2785                	addiw	a5,a5,1
    8000385a:	fd4797e3          	bne	a5,s4,80003828 <balloc+0x108>
    8000385e:	bf8d                	j	800037d0 <balloc+0xb0>
  panic("balloc: out of blocks");
    80003860:	00005517          	auipc	a0,0x5
    80003864:	e3850513          	addi	a0,a0,-456 # 80008698 <syscalls+0x230>
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	cfe080e7          	jalr	-770(ra) # 80000566 <panic>

0000000080003870 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003870:	7179                	addi	sp,sp,-48
    80003872:	f406                	sd	ra,40(sp)
    80003874:	f022                	sd	s0,32(sp)
    80003876:	ec26                	sd	s1,24(sp)
    80003878:	e84a                	sd	s2,16(sp)
    8000387a:	e44e                	sd	s3,8(sp)
    8000387c:	e052                	sd	s4,0(sp)
    8000387e:	1800                	addi	s0,sp,48
    80003880:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003882:	47ad                	li	a5,11
    80003884:	04b7fe63          	bgeu	a5,a1,800038e0 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003888:	ff45849b          	addiw	s1,a1,-12
    8000388c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003890:	0ff00793          	li	a5,255
    80003894:	0ae7e363          	bltu	a5,a4,8000393a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003898:	08052583          	lw	a1,128(a0)
    8000389c:	c5ad                	beqz	a1,80003906 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000389e:	0009a503          	lw	a0,0(s3)
    800038a2:	00000097          	auipc	ra,0x0
    800038a6:	b96080e7          	jalr	-1130(ra) # 80003438 <bread>
    800038aa:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800038ac:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800038b0:	02049593          	slli	a1,s1,0x20
    800038b4:	9181                	srli	a1,a1,0x20
    800038b6:	058a                	slli	a1,a1,0x2
    800038b8:	00b784b3          	add	s1,a5,a1
    800038bc:	0004a903          	lw	s2,0(s1)
    800038c0:	04090d63          	beqz	s2,8000391a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800038c4:	8552                	mv	a0,s4
    800038c6:	00000097          	auipc	ra,0x0
    800038ca:	cb4080e7          	jalr	-844(ra) # 8000357a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800038ce:	854a                	mv	a0,s2
    800038d0:	70a2                	ld	ra,40(sp)
    800038d2:	7402                	ld	s0,32(sp)
    800038d4:	64e2                	ld	s1,24(sp)
    800038d6:	6942                	ld	s2,16(sp)
    800038d8:	69a2                	ld	s3,8(sp)
    800038da:	6a02                	ld	s4,0(sp)
    800038dc:	6145                	addi	sp,sp,48
    800038de:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800038e0:	02059493          	slli	s1,a1,0x20
    800038e4:	9081                	srli	s1,s1,0x20
    800038e6:	048a                	slli	s1,s1,0x2
    800038e8:	94aa                	add	s1,s1,a0
    800038ea:	0504a903          	lw	s2,80(s1)
    800038ee:	fe0910e3          	bnez	s2,800038ce <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800038f2:	4108                	lw	a0,0(a0)
    800038f4:	00000097          	auipc	ra,0x0
    800038f8:	e2c080e7          	jalr	-468(ra) # 80003720 <balloc>
    800038fc:	0005091b          	sext.w	s2,a0
    80003900:	0524a823          	sw	s2,80(s1)
    80003904:	b7e9                	j	800038ce <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003906:	4108                	lw	a0,0(a0)
    80003908:	00000097          	auipc	ra,0x0
    8000390c:	e18080e7          	jalr	-488(ra) # 80003720 <balloc>
    80003910:	0005059b          	sext.w	a1,a0
    80003914:	08b9a023          	sw	a1,128(s3)
    80003918:	b759                	j	8000389e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000391a:	0009a503          	lw	a0,0(s3)
    8000391e:	00000097          	auipc	ra,0x0
    80003922:	e02080e7          	jalr	-510(ra) # 80003720 <balloc>
    80003926:	0005091b          	sext.w	s2,a0
    8000392a:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    8000392e:	8552                	mv	a0,s4
    80003930:	00001097          	auipc	ra,0x1
    80003934:	f0c080e7          	jalr	-244(ra) # 8000483c <log_write>
    80003938:	b771                	j	800038c4 <bmap+0x54>
  panic("bmap: out of range");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	d7650513          	addi	a0,a0,-650 # 800086b0 <syscalls+0x248>
    80003942:	ffffd097          	auipc	ra,0xffffd
    80003946:	c24080e7          	jalr	-988(ra) # 80000566 <panic>

000000008000394a <iget>:
{
    8000394a:	7179                	addi	sp,sp,-48
    8000394c:	f406                	sd	ra,40(sp)
    8000394e:	f022                	sd	s0,32(sp)
    80003950:	ec26                	sd	s1,24(sp)
    80003952:	e84a                	sd	s2,16(sp)
    80003954:	e44e                	sd	s3,8(sp)
    80003956:	e052                	sd	s4,0(sp)
    80003958:	1800                	addi	s0,sp,48
    8000395a:	89aa                	mv	s3,a0
    8000395c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000395e:	0001d517          	auipc	a0,0x1d
    80003962:	c6a50513          	addi	a0,a0,-918 # 800205c8 <itable>
    80003966:	ffffd097          	auipc	ra,0xffffd
    8000396a:	2cc080e7          	jalr	716(ra) # 80000c32 <acquire>
  empty = 0;
    8000396e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003970:	0001d497          	auipc	s1,0x1d
    80003974:	c7048493          	addi	s1,s1,-912 # 800205e0 <itable+0x18>
    80003978:	0001e697          	auipc	a3,0x1e
    8000397c:	6f868693          	addi	a3,a3,1784 # 80022070 <log>
    80003980:	a039                	j	8000398e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003982:	02090b63          	beqz	s2,800039b8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003986:	08848493          	addi	s1,s1,136
    8000398a:	02d48a63          	beq	s1,a3,800039be <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000398e:	449c                	lw	a5,8(s1)
    80003990:	fef059e3          	blez	a5,80003982 <iget+0x38>
    80003994:	4098                	lw	a4,0(s1)
    80003996:	ff3716e3          	bne	a4,s3,80003982 <iget+0x38>
    8000399a:	40d8                	lw	a4,4(s1)
    8000399c:	ff4713e3          	bne	a4,s4,80003982 <iget+0x38>
      ip->ref++;
    800039a0:	2785                	addiw	a5,a5,1
    800039a2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800039a4:	0001d517          	auipc	a0,0x1d
    800039a8:	c2450513          	addi	a0,a0,-988 # 800205c8 <itable>
    800039ac:	ffffd097          	auipc	ra,0xffffd
    800039b0:	33a080e7          	jalr	826(ra) # 80000ce6 <release>
      return ip;
    800039b4:	8926                	mv	s2,s1
    800039b6:	a03d                	j	800039e4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039b8:	f7f9                	bnez	a5,80003986 <iget+0x3c>
    800039ba:	8926                	mv	s2,s1
    800039bc:	b7e9                	j	80003986 <iget+0x3c>
  if(empty == 0)
    800039be:	02090c63          	beqz	s2,800039f6 <iget+0xac>
  ip->dev = dev;
    800039c2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800039c6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800039ca:	4785                	li	a5,1
    800039cc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800039d0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800039d4:	0001d517          	auipc	a0,0x1d
    800039d8:	bf450513          	addi	a0,a0,-1036 # 800205c8 <itable>
    800039dc:	ffffd097          	auipc	ra,0xffffd
    800039e0:	30a080e7          	jalr	778(ra) # 80000ce6 <release>
}
    800039e4:	854a                	mv	a0,s2
    800039e6:	70a2                	ld	ra,40(sp)
    800039e8:	7402                	ld	s0,32(sp)
    800039ea:	64e2                	ld	s1,24(sp)
    800039ec:	6942                	ld	s2,16(sp)
    800039ee:	69a2                	ld	s3,8(sp)
    800039f0:	6a02                	ld	s4,0(sp)
    800039f2:	6145                	addi	sp,sp,48
    800039f4:	8082                	ret
    panic("iget: no inodes");
    800039f6:	00005517          	auipc	a0,0x5
    800039fa:	cd250513          	addi	a0,a0,-814 # 800086c8 <syscalls+0x260>
    800039fe:	ffffd097          	auipc	ra,0xffffd
    80003a02:	b68080e7          	jalr	-1176(ra) # 80000566 <panic>

0000000080003a06 <fsinit>:
fsinit(int dev) {
    80003a06:	7179                	addi	sp,sp,-48
    80003a08:	f406                	sd	ra,40(sp)
    80003a0a:	f022                	sd	s0,32(sp)
    80003a0c:	ec26                	sd	s1,24(sp)
    80003a0e:	e84a                	sd	s2,16(sp)
    80003a10:	e44e                	sd	s3,8(sp)
    80003a12:	1800                	addi	s0,sp,48
    80003a14:	89aa                	mv	s3,a0
  bp = bread(dev, 1);
    80003a16:	4585                	li	a1,1
    80003a18:	00000097          	auipc	ra,0x0
    80003a1c:	a20080e7          	jalr	-1504(ra) # 80003438 <bread>
    80003a20:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a22:	0001d497          	auipc	s1,0x1d
    80003a26:	b8648493          	addi	s1,s1,-1146 # 800205a8 <sb>
    80003a2a:	02000613          	li	a2,32
    80003a2e:	05850593          	addi	a1,a0,88
    80003a32:	8526                	mv	a0,s1
    80003a34:	ffffd097          	auipc	ra,0xffffd
    80003a38:	366080e7          	jalr	870(ra) # 80000d9a <memmove>
  brelse(bp);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	b3c080e7          	jalr	-1220(ra) # 8000357a <brelse>
  if(sb.magic != FSMAGIC)
    80003a46:	4098                	lw	a4,0(s1)
    80003a48:	102037b7          	lui	a5,0x10203
    80003a4c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a50:	02f71263          	bne	a4,a5,80003a74 <fsinit+0x6e>
  initlog(dev, &sb);
    80003a54:	0001d597          	auipc	a1,0x1d
    80003a58:	b5458593          	addi	a1,a1,-1196 # 800205a8 <sb>
    80003a5c:	854e                	mv	a0,s3
    80003a5e:	00001097          	auipc	ra,0x1
    80003a62:	b5c080e7          	jalr	-1188(ra) # 800045ba <initlog>
}
    80003a66:	70a2                	ld	ra,40(sp)
    80003a68:	7402                	ld	s0,32(sp)
    80003a6a:	64e2                	ld	s1,24(sp)
    80003a6c:	6942                	ld	s2,16(sp)
    80003a6e:	69a2                	ld	s3,8(sp)
    80003a70:	6145                	addi	sp,sp,48
    80003a72:	8082                	ret
    panic("invalid file system");
    80003a74:	00005517          	auipc	a0,0x5
    80003a78:	c6450513          	addi	a0,a0,-924 # 800086d8 <syscalls+0x270>
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	aea080e7          	jalr	-1302(ra) # 80000566 <panic>

0000000080003a84 <iinit>:
{
    80003a84:	7179                	addi	sp,sp,-48
    80003a86:	f406                	sd	ra,40(sp)
    80003a88:	f022                	sd	s0,32(sp)
    80003a8a:	ec26                	sd	s1,24(sp)
    80003a8c:	e84a                	sd	s2,16(sp)
    80003a8e:	e44e                	sd	s3,8(sp)
    80003a90:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a92:	00005597          	auipc	a1,0x5
    80003a96:	c5e58593          	addi	a1,a1,-930 # 800086f0 <syscalls+0x288>
    80003a9a:	0001d517          	auipc	a0,0x1d
    80003a9e:	b2e50513          	addi	a0,a0,-1234 # 800205c8 <itable>
    80003aa2:	ffffd097          	auipc	ra,0xffffd
    80003aa6:	100080e7          	jalr	256(ra) # 80000ba2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003aaa:	0001d497          	auipc	s1,0x1d
    80003aae:	b4648493          	addi	s1,s1,-1210 # 800205f0 <itable+0x28>
    80003ab2:	0001e997          	auipc	s3,0x1e
    80003ab6:	5ce98993          	addi	s3,s3,1486 # 80022080 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003aba:	00005917          	auipc	s2,0x5
    80003abe:	c3e90913          	addi	s2,s2,-962 # 800086f8 <syscalls+0x290>
    80003ac2:	85ca                	mv	a1,s2
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	00001097          	auipc	ra,0x1
    80003aca:	e70080e7          	jalr	-400(ra) # 80004936 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003ace:	08848493          	addi	s1,s1,136
    80003ad2:	ff3498e3          	bne	s1,s3,80003ac2 <iinit+0x3e>
}
    80003ad6:	70a2                	ld	ra,40(sp)
    80003ad8:	7402                	ld	s0,32(sp)
    80003ada:	64e2                	ld	s1,24(sp)
    80003adc:	6942                	ld	s2,16(sp)
    80003ade:	69a2                	ld	s3,8(sp)
    80003ae0:	6145                	addi	sp,sp,48
    80003ae2:	8082                	ret

0000000080003ae4 <ialloc>:
{
    80003ae4:	715d                	addi	sp,sp,-80
    80003ae6:	e486                	sd	ra,72(sp)
    80003ae8:	e0a2                	sd	s0,64(sp)
    80003aea:	fc26                	sd	s1,56(sp)
    80003aec:	f84a                	sd	s2,48(sp)
    80003aee:	f44e                	sd	s3,40(sp)
    80003af0:	f052                	sd	s4,32(sp)
    80003af2:	ec56                	sd	s5,24(sp)
    80003af4:	e85a                	sd	s6,16(sp)
    80003af6:	e45e                	sd	s7,8(sp)
    80003af8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003afa:	0001d797          	auipc	a5,0x1d
    80003afe:	aae78793          	addi	a5,a5,-1362 # 800205a8 <sb>
    80003b02:	47d8                	lw	a4,12(a5)
    80003b04:	4785                	li	a5,1
    80003b06:	04e7fa63          	bgeu	a5,a4,80003b5a <ialloc+0x76>
    80003b0a:	8a2a                	mv	s4,a0
    80003b0c:	8b2e                	mv	s6,a1
    80003b0e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003b10:	0001d997          	auipc	s3,0x1d
    80003b14:	a9898993          	addi	s3,s3,-1384 # 800205a8 <sb>
    80003b18:	00048a9b          	sext.w	s5,s1
    80003b1c:	0044d593          	srli	a1,s1,0x4
    80003b20:	0189a783          	lw	a5,24(s3)
    80003b24:	9dbd                	addw	a1,a1,a5
    80003b26:	8552                	mv	a0,s4
    80003b28:	00000097          	auipc	ra,0x0
    80003b2c:	910080e7          	jalr	-1776(ra) # 80003438 <bread>
    80003b30:	8baa                	mv	s7,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b32:	05850913          	addi	s2,a0,88
    80003b36:	00f4f793          	andi	a5,s1,15
    80003b3a:	079a                	slli	a5,a5,0x6
    80003b3c:	993e                	add	s2,s2,a5
    if(dip->type == 0){  // a free inode
    80003b3e:	00091783          	lh	a5,0(s2)
    80003b42:	c785                	beqz	a5,80003b6a <ialloc+0x86>
    brelse(bp);
    80003b44:	00000097          	auipc	ra,0x0
    80003b48:	a36080e7          	jalr	-1482(ra) # 8000357a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b4c:	0485                	addi	s1,s1,1
    80003b4e:	00c9a703          	lw	a4,12(s3)
    80003b52:	0004879b          	sext.w	a5,s1
    80003b56:	fce7e1e3          	bltu	a5,a4,80003b18 <ialloc+0x34>
  panic("ialloc: no inodes");
    80003b5a:	00005517          	auipc	a0,0x5
    80003b5e:	ba650513          	addi	a0,a0,-1114 # 80008700 <syscalls+0x298>
    80003b62:	ffffd097          	auipc	ra,0xffffd
    80003b66:	a04080e7          	jalr	-1532(ra) # 80000566 <panic>
      memset(dip, 0, sizeof(*dip));
    80003b6a:	04000613          	li	a2,64
    80003b6e:	4581                	li	a1,0
    80003b70:	854a                	mv	a0,s2
    80003b72:	ffffd097          	auipc	ra,0xffffd
    80003b76:	1bc080e7          	jalr	444(ra) # 80000d2e <memset>
      dip->type = type;
    80003b7a:	01691023          	sh	s6,0(s2)
      log_write(bp);   // mark it allocated on the disk
    80003b7e:	855e                	mv	a0,s7
    80003b80:	00001097          	auipc	ra,0x1
    80003b84:	cbc080e7          	jalr	-836(ra) # 8000483c <log_write>
      brelse(bp);
    80003b88:	855e                	mv	a0,s7
    80003b8a:	00000097          	auipc	ra,0x0
    80003b8e:	9f0080e7          	jalr	-1552(ra) # 8000357a <brelse>
      return iget(dev, inum);
    80003b92:	85d6                	mv	a1,s5
    80003b94:	8552                	mv	a0,s4
    80003b96:	00000097          	auipc	ra,0x0
    80003b9a:	db4080e7          	jalr	-588(ra) # 8000394a <iget>
}
    80003b9e:	60a6                	ld	ra,72(sp)
    80003ba0:	6406                	ld	s0,64(sp)
    80003ba2:	74e2                	ld	s1,56(sp)
    80003ba4:	7942                	ld	s2,48(sp)
    80003ba6:	79a2                	ld	s3,40(sp)
    80003ba8:	7a02                	ld	s4,32(sp)
    80003baa:	6ae2                	ld	s5,24(sp)
    80003bac:	6b42                	ld	s6,16(sp)
    80003bae:	6ba2                	ld	s7,8(sp)
    80003bb0:	6161                	addi	sp,sp,80
    80003bb2:	8082                	ret

0000000080003bb4 <iupdate>:
{
    80003bb4:	1101                	addi	sp,sp,-32
    80003bb6:	ec06                	sd	ra,24(sp)
    80003bb8:	e822                	sd	s0,16(sp)
    80003bba:	e426                	sd	s1,8(sp)
    80003bbc:	e04a                	sd	s2,0(sp)
    80003bbe:	1000                	addi	s0,sp,32
    80003bc0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003bc2:	415c                	lw	a5,4(a0)
    80003bc4:	0047d79b          	srliw	a5,a5,0x4
    80003bc8:	0001d717          	auipc	a4,0x1d
    80003bcc:	9e070713          	addi	a4,a4,-1568 # 800205a8 <sb>
    80003bd0:	4f0c                	lw	a1,24(a4)
    80003bd2:	9dbd                	addw	a1,a1,a5
    80003bd4:	4108                	lw	a0,0(a0)
    80003bd6:	00000097          	auipc	ra,0x0
    80003bda:	862080e7          	jalr	-1950(ra) # 80003438 <bread>
    80003bde:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003be0:	05850513          	addi	a0,a0,88
    80003be4:	40dc                	lw	a5,4(s1)
    80003be6:	8bbd                	andi	a5,a5,15
    80003be8:	079a                	slli	a5,a5,0x6
    80003bea:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003bec:	04449783          	lh	a5,68(s1)
    80003bf0:	00f51023          	sh	a5,0(a0)
  dip->major = ip->major;
    80003bf4:	04649783          	lh	a5,70(s1)
    80003bf8:	00f51123          	sh	a5,2(a0)
  dip->minor = ip->minor;
    80003bfc:	04849783          	lh	a5,72(s1)
    80003c00:	00f51223          	sh	a5,4(a0)
  dip->nlink = ip->nlink;
    80003c04:	04a49783          	lh	a5,74(s1)
    80003c08:	00f51323          	sh	a5,6(a0)
  dip->size = ip->size;
    80003c0c:	44fc                	lw	a5,76(s1)
    80003c0e:	c51c                	sw	a5,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c10:	03400613          	li	a2,52
    80003c14:	05048593          	addi	a1,s1,80
    80003c18:	0531                	addi	a0,a0,12
    80003c1a:	ffffd097          	auipc	ra,0xffffd
    80003c1e:	180080e7          	jalr	384(ra) # 80000d9a <memmove>
  log_write(bp);
    80003c22:	854a                	mv	a0,s2
    80003c24:	00001097          	auipc	ra,0x1
    80003c28:	c18080e7          	jalr	-1000(ra) # 8000483c <log_write>
  brelse(bp);
    80003c2c:	854a                	mv	a0,s2
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	94c080e7          	jalr	-1716(ra) # 8000357a <brelse>
}
    80003c36:	60e2                	ld	ra,24(sp)
    80003c38:	6442                	ld	s0,16(sp)
    80003c3a:	64a2                	ld	s1,8(sp)
    80003c3c:	6902                	ld	s2,0(sp)
    80003c3e:	6105                	addi	sp,sp,32
    80003c40:	8082                	ret

0000000080003c42 <idup>:
{
    80003c42:	1101                	addi	sp,sp,-32
    80003c44:	ec06                	sd	ra,24(sp)
    80003c46:	e822                	sd	s0,16(sp)
    80003c48:	e426                	sd	s1,8(sp)
    80003c4a:	1000                	addi	s0,sp,32
    80003c4c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c4e:	0001d517          	auipc	a0,0x1d
    80003c52:	97a50513          	addi	a0,a0,-1670 # 800205c8 <itable>
    80003c56:	ffffd097          	auipc	ra,0xffffd
    80003c5a:	fdc080e7          	jalr	-36(ra) # 80000c32 <acquire>
  ip->ref++;
    80003c5e:	449c                	lw	a5,8(s1)
    80003c60:	2785                	addiw	a5,a5,1
    80003c62:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c64:	0001d517          	auipc	a0,0x1d
    80003c68:	96450513          	addi	a0,a0,-1692 # 800205c8 <itable>
    80003c6c:	ffffd097          	auipc	ra,0xffffd
    80003c70:	07a080e7          	jalr	122(ra) # 80000ce6 <release>
}
    80003c74:	8526                	mv	a0,s1
    80003c76:	60e2                	ld	ra,24(sp)
    80003c78:	6442                	ld	s0,16(sp)
    80003c7a:	64a2                	ld	s1,8(sp)
    80003c7c:	6105                	addi	sp,sp,32
    80003c7e:	8082                	ret

0000000080003c80 <ilock>:
{
    80003c80:	1101                	addi	sp,sp,-32
    80003c82:	ec06                	sd	ra,24(sp)
    80003c84:	e822                	sd	s0,16(sp)
    80003c86:	e426                	sd	s1,8(sp)
    80003c88:	e04a                	sd	s2,0(sp)
    80003c8a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c8c:	c115                	beqz	a0,80003cb0 <ilock+0x30>
    80003c8e:	84aa                	mv	s1,a0
    80003c90:	451c                	lw	a5,8(a0)
    80003c92:	00f05f63          	blez	a5,80003cb0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003c96:	0541                	addi	a0,a0,16
    80003c98:	00001097          	auipc	ra,0x1
    80003c9c:	cd8080e7          	jalr	-808(ra) # 80004970 <acquiresleep>
  if(ip->valid == 0){
    80003ca0:	40bc                	lw	a5,64(s1)
    80003ca2:	cf99                	beqz	a5,80003cc0 <ilock+0x40>
}
    80003ca4:	60e2                	ld	ra,24(sp)
    80003ca6:	6442                	ld	s0,16(sp)
    80003ca8:	64a2                	ld	s1,8(sp)
    80003caa:	6902                	ld	s2,0(sp)
    80003cac:	6105                	addi	sp,sp,32
    80003cae:	8082                	ret
    panic("ilock");
    80003cb0:	00005517          	auipc	a0,0x5
    80003cb4:	a6850513          	addi	a0,a0,-1432 # 80008718 <syscalls+0x2b0>
    80003cb8:	ffffd097          	auipc	ra,0xffffd
    80003cbc:	8ae080e7          	jalr	-1874(ra) # 80000566 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cc0:	40dc                	lw	a5,4(s1)
    80003cc2:	0047d79b          	srliw	a5,a5,0x4
    80003cc6:	0001d717          	auipc	a4,0x1d
    80003cca:	8e270713          	addi	a4,a4,-1822 # 800205a8 <sb>
    80003cce:	4f0c                	lw	a1,24(a4)
    80003cd0:	9dbd                	addw	a1,a1,a5
    80003cd2:	4088                	lw	a0,0(s1)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	764080e7          	jalr	1892(ra) # 80003438 <bread>
    80003cdc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003cde:	05850593          	addi	a1,a0,88
    80003ce2:	40dc                	lw	a5,4(s1)
    80003ce4:	8bbd                	andi	a5,a5,15
    80003ce6:	079a                	slli	a5,a5,0x6
    80003ce8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003cea:	00059783          	lh	a5,0(a1)
    80003cee:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003cf2:	00259783          	lh	a5,2(a1)
    80003cf6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003cfa:	00459783          	lh	a5,4(a1)
    80003cfe:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d02:	00659783          	lh	a5,6(a1)
    80003d06:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d0a:	459c                	lw	a5,8(a1)
    80003d0c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d0e:	03400613          	li	a2,52
    80003d12:	05b1                	addi	a1,a1,12
    80003d14:	05048513          	addi	a0,s1,80
    80003d18:	ffffd097          	auipc	ra,0xffffd
    80003d1c:	082080e7          	jalr	130(ra) # 80000d9a <memmove>
    brelse(bp);
    80003d20:	854a                	mv	a0,s2
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	858080e7          	jalr	-1960(ra) # 8000357a <brelse>
    ip->valid = 1;
    80003d2a:	4785                	li	a5,1
    80003d2c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d2e:	04449783          	lh	a5,68(s1)
    80003d32:	fbad                	bnez	a5,80003ca4 <ilock+0x24>
      panic("ilock: no type");
    80003d34:	00005517          	auipc	a0,0x5
    80003d38:	9ec50513          	addi	a0,a0,-1556 # 80008720 <syscalls+0x2b8>
    80003d3c:	ffffd097          	auipc	ra,0xffffd
    80003d40:	82a080e7          	jalr	-2006(ra) # 80000566 <panic>

0000000080003d44 <iunlock>:
{
    80003d44:	1101                	addi	sp,sp,-32
    80003d46:	ec06                	sd	ra,24(sp)
    80003d48:	e822                	sd	s0,16(sp)
    80003d4a:	e426                	sd	s1,8(sp)
    80003d4c:	e04a                	sd	s2,0(sp)
    80003d4e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d50:	c905                	beqz	a0,80003d80 <iunlock+0x3c>
    80003d52:	84aa                	mv	s1,a0
    80003d54:	01050913          	addi	s2,a0,16
    80003d58:	854a                	mv	a0,s2
    80003d5a:	00001097          	auipc	ra,0x1
    80003d5e:	cb0080e7          	jalr	-848(ra) # 80004a0a <holdingsleep>
    80003d62:	cd19                	beqz	a0,80003d80 <iunlock+0x3c>
    80003d64:	449c                	lw	a5,8(s1)
    80003d66:	00f05d63          	blez	a5,80003d80 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d6a:	854a                	mv	a0,s2
    80003d6c:	00001097          	auipc	ra,0x1
    80003d70:	c5a080e7          	jalr	-934(ra) # 800049c6 <releasesleep>
}
    80003d74:	60e2                	ld	ra,24(sp)
    80003d76:	6442                	ld	s0,16(sp)
    80003d78:	64a2                	ld	s1,8(sp)
    80003d7a:	6902                	ld	s2,0(sp)
    80003d7c:	6105                	addi	sp,sp,32
    80003d7e:	8082                	ret
    panic("iunlock");
    80003d80:	00005517          	auipc	a0,0x5
    80003d84:	9b050513          	addi	a0,a0,-1616 # 80008730 <syscalls+0x2c8>
    80003d88:	ffffc097          	auipc	ra,0xffffc
    80003d8c:	7de080e7          	jalr	2014(ra) # 80000566 <panic>

0000000080003d90 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d90:	7179                	addi	sp,sp,-48
    80003d92:	f406                	sd	ra,40(sp)
    80003d94:	f022                	sd	s0,32(sp)
    80003d96:	ec26                	sd	s1,24(sp)
    80003d98:	e84a                	sd	s2,16(sp)
    80003d9a:	e44e                	sd	s3,8(sp)
    80003d9c:	e052                	sd	s4,0(sp)
    80003d9e:	1800                	addi	s0,sp,48
    80003da0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003da2:	05050493          	addi	s1,a0,80
    80003da6:	08050913          	addi	s2,a0,128
    80003daa:	a821                	j	80003dc2 <itrunc+0x32>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003dac:	0009a503          	lw	a0,0(s3)
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	8e0080e7          	jalr	-1824(ra) # 80003690 <bfree>
      ip->addrs[i] = 0;
    80003db8:	0004a023          	sw	zero,0(s1)
  for(i = 0; i < NDIRECT; i++){
    80003dbc:	0491                	addi	s1,s1,4
    80003dbe:	01248563          	beq	s1,s2,80003dc8 <itrunc+0x38>
    if(ip->addrs[i]){
    80003dc2:	408c                	lw	a1,0(s1)
    80003dc4:	dde5                	beqz	a1,80003dbc <itrunc+0x2c>
    80003dc6:	b7dd                	j	80003dac <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003dc8:	0809a583          	lw	a1,128(s3)
    80003dcc:	e185                	bnez	a1,80003dec <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003dce:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003dd2:	854e                	mv	a0,s3
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	de0080e7          	jalr	-544(ra) # 80003bb4 <iupdate>
}
    80003ddc:	70a2                	ld	ra,40(sp)
    80003dde:	7402                	ld	s0,32(sp)
    80003de0:	64e2                	ld	s1,24(sp)
    80003de2:	6942                	ld	s2,16(sp)
    80003de4:	69a2                	ld	s3,8(sp)
    80003de6:	6a02                	ld	s4,0(sp)
    80003de8:	6145                	addi	sp,sp,48
    80003dea:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003dec:	0009a503          	lw	a0,0(s3)
    80003df0:	fffff097          	auipc	ra,0xfffff
    80003df4:	648080e7          	jalr	1608(ra) # 80003438 <bread>
    80003df8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003dfa:	05850493          	addi	s1,a0,88
    80003dfe:	45850913          	addi	s2,a0,1112
    80003e02:	a811                	j	80003e16 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003e04:	0009a503          	lw	a0,0(s3)
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	888080e7          	jalr	-1912(ra) # 80003690 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003e10:	0491                	addi	s1,s1,4
    80003e12:	01248563          	beq	s1,s2,80003e1c <itrunc+0x8c>
      if(a[j])
    80003e16:	408c                	lw	a1,0(s1)
    80003e18:	dde5                	beqz	a1,80003e10 <itrunc+0x80>
    80003e1a:	b7ed                	j	80003e04 <itrunc+0x74>
    brelse(bp);
    80003e1c:	8552                	mv	a0,s4
    80003e1e:	fffff097          	auipc	ra,0xfffff
    80003e22:	75c080e7          	jalr	1884(ra) # 8000357a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e26:	0809a583          	lw	a1,128(s3)
    80003e2a:	0009a503          	lw	a0,0(s3)
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	862080e7          	jalr	-1950(ra) # 80003690 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e36:	0809a023          	sw	zero,128(s3)
    80003e3a:	bf51                	j	80003dce <itrunc+0x3e>

0000000080003e3c <iput>:
{
    80003e3c:	1101                	addi	sp,sp,-32
    80003e3e:	ec06                	sd	ra,24(sp)
    80003e40:	e822                	sd	s0,16(sp)
    80003e42:	e426                	sd	s1,8(sp)
    80003e44:	e04a                	sd	s2,0(sp)
    80003e46:	1000                	addi	s0,sp,32
    80003e48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e4a:	0001c517          	auipc	a0,0x1c
    80003e4e:	77e50513          	addi	a0,a0,1918 # 800205c8 <itable>
    80003e52:	ffffd097          	auipc	ra,0xffffd
    80003e56:	de0080e7          	jalr	-544(ra) # 80000c32 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e5a:	4498                	lw	a4,8(s1)
    80003e5c:	4785                	li	a5,1
    80003e5e:	02f70363          	beq	a4,a5,80003e84 <iput+0x48>
  ip->ref--;
    80003e62:	449c                	lw	a5,8(s1)
    80003e64:	37fd                	addiw	a5,a5,-1
    80003e66:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e68:	0001c517          	auipc	a0,0x1c
    80003e6c:	76050513          	addi	a0,a0,1888 # 800205c8 <itable>
    80003e70:	ffffd097          	auipc	ra,0xffffd
    80003e74:	e76080e7          	jalr	-394(ra) # 80000ce6 <release>
}
    80003e78:	60e2                	ld	ra,24(sp)
    80003e7a:	6442                	ld	s0,16(sp)
    80003e7c:	64a2                	ld	s1,8(sp)
    80003e7e:	6902                	ld	s2,0(sp)
    80003e80:	6105                	addi	sp,sp,32
    80003e82:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e84:	40bc                	lw	a5,64(s1)
    80003e86:	dff1                	beqz	a5,80003e62 <iput+0x26>
    80003e88:	04a49783          	lh	a5,74(s1)
    80003e8c:	fbf9                	bnez	a5,80003e62 <iput+0x26>
    acquiresleep(&ip->lock);
    80003e8e:	01048913          	addi	s2,s1,16
    80003e92:	854a                	mv	a0,s2
    80003e94:	00001097          	auipc	ra,0x1
    80003e98:	adc080e7          	jalr	-1316(ra) # 80004970 <acquiresleep>
    release(&itable.lock);
    80003e9c:	0001c517          	auipc	a0,0x1c
    80003ea0:	72c50513          	addi	a0,a0,1836 # 800205c8 <itable>
    80003ea4:	ffffd097          	auipc	ra,0xffffd
    80003ea8:	e42080e7          	jalr	-446(ra) # 80000ce6 <release>
    itrunc(ip);
    80003eac:	8526                	mv	a0,s1
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	ee2080e7          	jalr	-286(ra) # 80003d90 <itrunc>
    ip->type = 0;
    80003eb6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003eba:	8526                	mv	a0,s1
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	cf8080e7          	jalr	-776(ra) # 80003bb4 <iupdate>
    ip->valid = 0;
    80003ec4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ec8:	854a                	mv	a0,s2
    80003eca:	00001097          	auipc	ra,0x1
    80003ece:	afc080e7          	jalr	-1284(ra) # 800049c6 <releasesleep>
    acquire(&itable.lock);
    80003ed2:	0001c517          	auipc	a0,0x1c
    80003ed6:	6f650513          	addi	a0,a0,1782 # 800205c8 <itable>
    80003eda:	ffffd097          	auipc	ra,0xffffd
    80003ede:	d58080e7          	jalr	-680(ra) # 80000c32 <acquire>
    80003ee2:	b741                	j	80003e62 <iput+0x26>

0000000080003ee4 <iunlockput>:
{
    80003ee4:	1101                	addi	sp,sp,-32
    80003ee6:	ec06                	sd	ra,24(sp)
    80003ee8:	e822                	sd	s0,16(sp)
    80003eea:	e426                	sd	s1,8(sp)
    80003eec:	1000                	addi	s0,sp,32
    80003eee:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ef0:	00000097          	auipc	ra,0x0
    80003ef4:	e54080e7          	jalr	-428(ra) # 80003d44 <iunlock>
  iput(ip);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	00000097          	auipc	ra,0x0
    80003efe:	f42080e7          	jalr	-190(ra) # 80003e3c <iput>
}
    80003f02:	60e2                	ld	ra,24(sp)
    80003f04:	6442                	ld	s0,16(sp)
    80003f06:	64a2                	ld	s1,8(sp)
    80003f08:	6105                	addi	sp,sp,32
    80003f0a:	8082                	ret

0000000080003f0c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f0c:	1141                	addi	sp,sp,-16
    80003f0e:	e422                	sd	s0,8(sp)
    80003f10:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f12:	411c                	lw	a5,0(a0)
    80003f14:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f16:	415c                	lw	a5,4(a0)
    80003f18:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f1a:	04451783          	lh	a5,68(a0)
    80003f1e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f22:	04a51783          	lh	a5,74(a0)
    80003f26:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f2a:	04c56783          	lwu	a5,76(a0)
    80003f2e:	e99c                	sd	a5,16(a1)
}
    80003f30:	6422                	ld	s0,8(sp)
    80003f32:	0141                	addi	sp,sp,16
    80003f34:	8082                	ret

0000000080003f36 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f36:	457c                	lw	a5,76(a0)
    80003f38:	0ed7e963          	bltu	a5,a3,8000402a <readi+0xf4>
{
    80003f3c:	7159                	addi	sp,sp,-112
    80003f3e:	f486                	sd	ra,104(sp)
    80003f40:	f0a2                	sd	s0,96(sp)
    80003f42:	eca6                	sd	s1,88(sp)
    80003f44:	e8ca                	sd	s2,80(sp)
    80003f46:	e4ce                	sd	s3,72(sp)
    80003f48:	e0d2                	sd	s4,64(sp)
    80003f4a:	fc56                	sd	s5,56(sp)
    80003f4c:	f85a                	sd	s6,48(sp)
    80003f4e:	f45e                	sd	s7,40(sp)
    80003f50:	f062                	sd	s8,32(sp)
    80003f52:	ec66                	sd	s9,24(sp)
    80003f54:	e86a                	sd	s10,16(sp)
    80003f56:	e46e                	sd	s11,8(sp)
    80003f58:	1880                	addi	s0,sp,112
    80003f5a:	8baa                	mv	s7,a0
    80003f5c:	8c2e                	mv	s8,a1
    80003f5e:	8a32                	mv	s4,a2
    80003f60:	84b6                	mv	s1,a3
    80003f62:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f64:	9f35                	addw	a4,a4,a3
    return 0;
    80003f66:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f68:	0ad76063          	bltu	a4,a3,80004008 <readi+0xd2>
  if(off + n > ip->size)
    80003f6c:	00e7f463          	bgeu	a5,a4,80003f74 <readi+0x3e>
    n = ip->size - off;
    80003f70:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f74:	0a0b0963          	beqz	s6,80004026 <readi+0xf0>
    80003f78:	4901                	li	s2,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f7a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f7e:	5cfd                	li	s9,-1
    80003f80:	a82d                	j	80003fba <readi+0x84>
    80003f82:	02099d93          	slli	s11,s3,0x20
    80003f86:	020ddd93          	srli	s11,s11,0x20
    80003f8a:	058a8613          	addi	a2,s5,88
    80003f8e:	86ee                	mv	a3,s11
    80003f90:	963a                	add	a2,a2,a4
    80003f92:	85d2                	mv	a1,s4
    80003f94:	8562                	mv	a0,s8
    80003f96:	ffffe097          	auipc	ra,0xffffe
    80003f9a:	73c080e7          	jalr	1852(ra) # 800026d2 <either_copyout>
    80003f9e:	05950d63          	beq	a0,s9,80003ff8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003fa2:	8556                	mv	a0,s5
    80003fa4:	fffff097          	auipc	ra,0xfffff
    80003fa8:	5d6080e7          	jalr	1494(ra) # 8000357a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fac:	0129893b          	addw	s2,s3,s2
    80003fb0:	009984bb          	addw	s1,s3,s1
    80003fb4:	9a6e                	add	s4,s4,s11
    80003fb6:	05697763          	bgeu	s2,s6,80004004 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003fba:	000ba983          	lw	s3,0(s7)
    80003fbe:	00a4d59b          	srliw	a1,s1,0xa
    80003fc2:	855e                	mv	a0,s7
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	8ac080e7          	jalr	-1876(ra) # 80003870 <bmap>
    80003fcc:	0005059b          	sext.w	a1,a0
    80003fd0:	854e                	mv	a0,s3
    80003fd2:	fffff097          	auipc	ra,0xfffff
    80003fd6:	466080e7          	jalr	1126(ra) # 80003438 <bread>
    80003fda:	8aaa                	mv	s5,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fdc:	3ff4f713          	andi	a4,s1,1023
    80003fe0:	40ed07bb          	subw	a5,s10,a4
    80003fe4:	412b06bb          	subw	a3,s6,s2
    80003fe8:	89be                	mv	s3,a5
    80003fea:	2781                	sext.w	a5,a5
    80003fec:	0006861b          	sext.w	a2,a3
    80003ff0:	f8f679e3          	bgeu	a2,a5,80003f82 <readi+0x4c>
    80003ff4:	89b6                	mv	s3,a3
    80003ff6:	b771                	j	80003f82 <readi+0x4c>
      brelse(bp);
    80003ff8:	8556                	mv	a0,s5
    80003ffa:	fffff097          	auipc	ra,0xfffff
    80003ffe:	580080e7          	jalr	1408(ra) # 8000357a <brelse>
      tot = -1;
    80004002:	597d                	li	s2,-1
  }
  return tot;
    80004004:	0009051b          	sext.w	a0,s2
}
    80004008:	70a6                	ld	ra,104(sp)
    8000400a:	7406                	ld	s0,96(sp)
    8000400c:	64e6                	ld	s1,88(sp)
    8000400e:	6946                	ld	s2,80(sp)
    80004010:	69a6                	ld	s3,72(sp)
    80004012:	6a06                	ld	s4,64(sp)
    80004014:	7ae2                	ld	s5,56(sp)
    80004016:	7b42                	ld	s6,48(sp)
    80004018:	7ba2                	ld	s7,40(sp)
    8000401a:	7c02                	ld	s8,32(sp)
    8000401c:	6ce2                	ld	s9,24(sp)
    8000401e:	6d42                	ld	s10,16(sp)
    80004020:	6da2                	ld	s11,8(sp)
    80004022:	6165                	addi	sp,sp,112
    80004024:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004026:	895a                	mv	s2,s6
    80004028:	bff1                	j	80004004 <readi+0xce>
    return 0;
    8000402a:	4501                	li	a0,0
}
    8000402c:	8082                	ret

000000008000402e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000402e:	457c                	lw	a5,76(a0)
    80004030:	10d7e863          	bltu	a5,a3,80004140 <writei+0x112>
{
    80004034:	7159                	addi	sp,sp,-112
    80004036:	f486                	sd	ra,104(sp)
    80004038:	f0a2                	sd	s0,96(sp)
    8000403a:	eca6                	sd	s1,88(sp)
    8000403c:	e8ca                	sd	s2,80(sp)
    8000403e:	e4ce                	sd	s3,72(sp)
    80004040:	e0d2                	sd	s4,64(sp)
    80004042:	fc56                	sd	s5,56(sp)
    80004044:	f85a                	sd	s6,48(sp)
    80004046:	f45e                	sd	s7,40(sp)
    80004048:	f062                	sd	s8,32(sp)
    8000404a:	ec66                	sd	s9,24(sp)
    8000404c:	e86a                	sd	s10,16(sp)
    8000404e:	e46e                	sd	s11,8(sp)
    80004050:	1880                	addi	s0,sp,112
    80004052:	8b2a                	mv	s6,a0
    80004054:	8c2e                	mv	s8,a1
    80004056:	8ab2                	mv	s5,a2
    80004058:	84b6                	mv	s1,a3
    8000405a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000405c:	00e687bb          	addw	a5,a3,a4
    80004060:	0ed7e263          	bltu	a5,a3,80004144 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004064:	00043737          	lui	a4,0x43
    80004068:	0ef76063          	bltu	a4,a5,80004148 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000406c:	0c0b8863          	beqz	s7,8000413c <writei+0x10e>
    80004070:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80004072:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004076:	5cfd                	li	s9,-1
    80004078:	a091                	j	800040bc <writei+0x8e>
    8000407a:	02091d93          	slli	s11,s2,0x20
    8000407e:	020ddd93          	srli	s11,s11,0x20
    80004082:	058a0513          	addi	a0,s4,88 # 2058 <_entry-0x7fffdfa8>
    80004086:	86ee                	mv	a3,s11
    80004088:	8656                	mv	a2,s5
    8000408a:	85e2                	mv	a1,s8
    8000408c:	953a                	add	a0,a0,a4
    8000408e:	ffffe097          	auipc	ra,0xffffe
    80004092:	69a080e7          	jalr	1690(ra) # 80002728 <either_copyin>
    80004096:	07950263          	beq	a0,s9,800040fa <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000409a:	8552                	mv	a0,s4
    8000409c:	00000097          	auipc	ra,0x0
    800040a0:	7a0080e7          	jalr	1952(ra) # 8000483c <log_write>
    brelse(bp);
    800040a4:	8552                	mv	a0,s4
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	4d4080e7          	jalr	1236(ra) # 8000357a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040ae:	013909bb          	addw	s3,s2,s3
    800040b2:	009904bb          	addw	s1,s2,s1
    800040b6:	9aee                	add	s5,s5,s11
    800040b8:	0579f663          	bgeu	s3,s7,80004104 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800040bc:	000b2903          	lw	s2,0(s6)
    800040c0:	00a4d59b          	srliw	a1,s1,0xa
    800040c4:	855a                	mv	a0,s6
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	7aa080e7          	jalr	1962(ra) # 80003870 <bmap>
    800040ce:	0005059b          	sext.w	a1,a0
    800040d2:	854a                	mv	a0,s2
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	364080e7          	jalr	868(ra) # 80003438 <bread>
    800040dc:	8a2a                	mv	s4,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040de:	3ff4f713          	andi	a4,s1,1023
    800040e2:	40ed07bb          	subw	a5,s10,a4
    800040e6:	413b86bb          	subw	a3,s7,s3
    800040ea:	893e                	mv	s2,a5
    800040ec:	2781                	sext.w	a5,a5
    800040ee:	0006861b          	sext.w	a2,a3
    800040f2:	f8f674e3          	bgeu	a2,a5,8000407a <writei+0x4c>
    800040f6:	8936                	mv	s2,a3
    800040f8:	b749                	j	8000407a <writei+0x4c>
      brelse(bp);
    800040fa:	8552                	mv	a0,s4
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	47e080e7          	jalr	1150(ra) # 8000357a <brelse>
  }

  if(off > ip->size)
    80004104:	04cb2783          	lw	a5,76(s6)
    80004108:	0097f463          	bgeu	a5,s1,80004110 <writei+0xe2>
    ip->size = off;
    8000410c:	049b2623          	sw	s1,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004110:	855a                	mv	a0,s6
    80004112:	00000097          	auipc	ra,0x0
    80004116:	aa2080e7          	jalr	-1374(ra) # 80003bb4 <iupdate>

  return tot;
    8000411a:	0009851b          	sext.w	a0,s3
}
    8000411e:	70a6                	ld	ra,104(sp)
    80004120:	7406                	ld	s0,96(sp)
    80004122:	64e6                	ld	s1,88(sp)
    80004124:	6946                	ld	s2,80(sp)
    80004126:	69a6                	ld	s3,72(sp)
    80004128:	6a06                	ld	s4,64(sp)
    8000412a:	7ae2                	ld	s5,56(sp)
    8000412c:	7b42                	ld	s6,48(sp)
    8000412e:	7ba2                	ld	s7,40(sp)
    80004130:	7c02                	ld	s8,32(sp)
    80004132:	6ce2                	ld	s9,24(sp)
    80004134:	6d42                	ld	s10,16(sp)
    80004136:	6da2                	ld	s11,8(sp)
    80004138:	6165                	addi	sp,sp,112
    8000413a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000413c:	89de                	mv	s3,s7
    8000413e:	bfc9                	j	80004110 <writei+0xe2>
    return -1;
    80004140:	557d                	li	a0,-1
}
    80004142:	8082                	ret
    return -1;
    80004144:	557d                	li	a0,-1
    80004146:	bfe1                	j	8000411e <writei+0xf0>
    return -1;
    80004148:	557d                	li	a0,-1
    8000414a:	bfd1                	j	8000411e <writei+0xf0>

000000008000414c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000414c:	1141                	addi	sp,sp,-16
    8000414e:	e406                	sd	ra,8(sp)
    80004150:	e022                	sd	s0,0(sp)
    80004152:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004154:	4639                	li	a2,14
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	cbc080e7          	jalr	-836(ra) # 80000e12 <strncmp>
}
    8000415e:	60a2                	ld	ra,8(sp)
    80004160:	6402                	ld	s0,0(sp)
    80004162:	0141                	addi	sp,sp,16
    80004164:	8082                	ret

0000000080004166 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004166:	7139                	addi	sp,sp,-64
    80004168:	fc06                	sd	ra,56(sp)
    8000416a:	f822                	sd	s0,48(sp)
    8000416c:	f426                	sd	s1,40(sp)
    8000416e:	f04a                	sd	s2,32(sp)
    80004170:	ec4e                	sd	s3,24(sp)
    80004172:	e852                	sd	s4,16(sp)
    80004174:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004176:	04451703          	lh	a4,68(a0)
    8000417a:	4785                	li	a5,1
    8000417c:	00f71a63          	bne	a4,a5,80004190 <dirlookup+0x2a>
    80004180:	892a                	mv	s2,a0
    80004182:	89ae                	mv	s3,a1
    80004184:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004186:	457c                	lw	a5,76(a0)
    80004188:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000418a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000418c:	e79d                	bnez	a5,800041ba <dirlookup+0x54>
    8000418e:	a8a5                	j	80004206 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004190:	00004517          	auipc	a0,0x4
    80004194:	5a850513          	addi	a0,a0,1448 # 80008738 <syscalls+0x2d0>
    80004198:	ffffc097          	auipc	ra,0xffffc
    8000419c:	3ce080e7          	jalr	974(ra) # 80000566 <panic>
      panic("dirlookup read");
    800041a0:	00004517          	auipc	a0,0x4
    800041a4:	5b050513          	addi	a0,a0,1456 # 80008750 <syscalls+0x2e8>
    800041a8:	ffffc097          	auipc	ra,0xffffc
    800041ac:	3be080e7          	jalr	958(ra) # 80000566 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041b0:	24c1                	addiw	s1,s1,16
    800041b2:	04c92783          	lw	a5,76(s2)
    800041b6:	04f4f763          	bgeu	s1,a5,80004204 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041ba:	4741                	li	a4,16
    800041bc:	86a6                	mv	a3,s1
    800041be:	fc040613          	addi	a2,s0,-64
    800041c2:	4581                	li	a1,0
    800041c4:	854a                	mv	a0,s2
    800041c6:	00000097          	auipc	ra,0x0
    800041ca:	d70080e7          	jalr	-656(ra) # 80003f36 <readi>
    800041ce:	47c1                	li	a5,16
    800041d0:	fcf518e3          	bne	a0,a5,800041a0 <dirlookup+0x3a>
    if(de.inum == 0)
    800041d4:	fc045783          	lhu	a5,-64(s0)
    800041d8:	dfe1                	beqz	a5,800041b0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800041da:	fc240593          	addi	a1,s0,-62
    800041de:	854e                	mv	a0,s3
    800041e0:	00000097          	auipc	ra,0x0
    800041e4:	f6c080e7          	jalr	-148(ra) # 8000414c <namecmp>
    800041e8:	f561                	bnez	a0,800041b0 <dirlookup+0x4a>
      if(poff)
    800041ea:	000a0463          	beqz	s4,800041f2 <dirlookup+0x8c>
        *poff = off;
    800041ee:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800041f2:	fc045583          	lhu	a1,-64(s0)
    800041f6:	00092503          	lw	a0,0(s2)
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	750080e7          	jalr	1872(ra) # 8000394a <iget>
    80004202:	a011                	j	80004206 <dirlookup+0xa0>
  return 0;
    80004204:	4501                	li	a0,0
}
    80004206:	70e2                	ld	ra,56(sp)
    80004208:	7442                	ld	s0,48(sp)
    8000420a:	74a2                	ld	s1,40(sp)
    8000420c:	7902                	ld	s2,32(sp)
    8000420e:	69e2                	ld	s3,24(sp)
    80004210:	6a42                	ld	s4,16(sp)
    80004212:	6121                	addi	sp,sp,64
    80004214:	8082                	ret

0000000080004216 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004216:	711d                	addi	sp,sp,-96
    80004218:	ec86                	sd	ra,88(sp)
    8000421a:	e8a2                	sd	s0,80(sp)
    8000421c:	e4a6                	sd	s1,72(sp)
    8000421e:	e0ca                	sd	s2,64(sp)
    80004220:	fc4e                	sd	s3,56(sp)
    80004222:	f852                	sd	s4,48(sp)
    80004224:	f456                	sd	s5,40(sp)
    80004226:	f05a                	sd	s6,32(sp)
    80004228:	ec5e                	sd	s7,24(sp)
    8000422a:	e862                	sd	s8,16(sp)
    8000422c:	e466                	sd	s9,8(sp)
    8000422e:	1080                	addi	s0,sp,96
    80004230:	84aa                	mv	s1,a0
    80004232:	8bae                	mv	s7,a1
    80004234:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004236:	00054703          	lbu	a4,0(a0)
    8000423a:	02f00793          	li	a5,47
    8000423e:	02f70363          	beq	a4,a5,80004264 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004242:	ffffd097          	auipc	ra,0xffffd
    80004246:	7f6080e7          	jalr	2038(ra) # 80001a38 <myproc>
    8000424a:	15053503          	ld	a0,336(a0)
    8000424e:	00000097          	auipc	ra,0x0
    80004252:	9f4080e7          	jalr	-1548(ra) # 80003c42 <idup>
    80004256:	89aa                	mv	s3,a0
  while(*path == '/')
    80004258:	02f00913          	li	s2,47
  len = path - s;
    8000425c:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000425e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004260:	4c05                	li	s8,1
    80004262:	a865                	j	8000431a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004264:	4585                	li	a1,1
    80004266:	4505                	li	a0,1
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	6e2080e7          	jalr	1762(ra) # 8000394a <iget>
    80004270:	89aa                	mv	s3,a0
    80004272:	b7dd                	j	80004258 <namex+0x42>
      iunlockput(ip);
    80004274:	854e                	mv	a0,s3
    80004276:	00000097          	auipc	ra,0x0
    8000427a:	c6e080e7          	jalr	-914(ra) # 80003ee4 <iunlockput>
      return 0;
    8000427e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004280:	854e                	mv	a0,s3
    80004282:	60e6                	ld	ra,88(sp)
    80004284:	6446                	ld	s0,80(sp)
    80004286:	64a6                	ld	s1,72(sp)
    80004288:	6906                	ld	s2,64(sp)
    8000428a:	79e2                	ld	s3,56(sp)
    8000428c:	7a42                	ld	s4,48(sp)
    8000428e:	7aa2                	ld	s5,40(sp)
    80004290:	7b02                	ld	s6,32(sp)
    80004292:	6be2                	ld	s7,24(sp)
    80004294:	6c42                	ld	s8,16(sp)
    80004296:	6ca2                	ld	s9,8(sp)
    80004298:	6125                	addi	sp,sp,96
    8000429a:	8082                	ret
      iunlock(ip);
    8000429c:	854e                	mv	a0,s3
    8000429e:	00000097          	auipc	ra,0x0
    800042a2:	aa6080e7          	jalr	-1370(ra) # 80003d44 <iunlock>
      return ip;
    800042a6:	bfe9                	j	80004280 <namex+0x6a>
      iunlockput(ip);
    800042a8:	854e                	mv	a0,s3
    800042aa:	00000097          	auipc	ra,0x0
    800042ae:	c3a080e7          	jalr	-966(ra) # 80003ee4 <iunlockput>
      return 0;
    800042b2:	89d2                	mv	s3,s4
    800042b4:	b7f1                	j	80004280 <namex+0x6a>
  len = path - s;
    800042b6:	40b48633          	sub	a2,s1,a1
    800042ba:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800042be:	094cd663          	bge	s9,s4,8000434a <namex+0x134>
    memmove(name, s, DIRSIZ);
    800042c2:	4639                	li	a2,14
    800042c4:	8556                	mv	a0,s5
    800042c6:	ffffd097          	auipc	ra,0xffffd
    800042ca:	ad4080e7          	jalr	-1324(ra) # 80000d9a <memmove>
  while(*path == '/')
    800042ce:	0004c783          	lbu	a5,0(s1)
    800042d2:	01279763          	bne	a5,s2,800042e0 <namex+0xca>
    path++;
    800042d6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042d8:	0004c783          	lbu	a5,0(s1)
    800042dc:	ff278de3          	beq	a5,s2,800042d6 <namex+0xc0>
    ilock(ip);
    800042e0:	854e                	mv	a0,s3
    800042e2:	00000097          	auipc	ra,0x0
    800042e6:	99e080e7          	jalr	-1634(ra) # 80003c80 <ilock>
    if(ip->type != T_DIR){
    800042ea:	04499783          	lh	a5,68(s3)
    800042ee:	f98793e3          	bne	a5,s8,80004274 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800042f2:	000b8563          	beqz	s7,800042fc <namex+0xe6>
    800042f6:	0004c783          	lbu	a5,0(s1)
    800042fa:	d3cd                	beqz	a5,8000429c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800042fc:	865a                	mv	a2,s6
    800042fe:	85d6                	mv	a1,s5
    80004300:	854e                	mv	a0,s3
    80004302:	00000097          	auipc	ra,0x0
    80004306:	e64080e7          	jalr	-412(ra) # 80004166 <dirlookup>
    8000430a:	8a2a                	mv	s4,a0
    8000430c:	dd51                	beqz	a0,800042a8 <namex+0x92>
    iunlockput(ip);
    8000430e:	854e                	mv	a0,s3
    80004310:	00000097          	auipc	ra,0x0
    80004314:	bd4080e7          	jalr	-1068(ra) # 80003ee4 <iunlockput>
    ip = next;
    80004318:	89d2                	mv	s3,s4
  while(*path == '/')
    8000431a:	0004c783          	lbu	a5,0(s1)
    8000431e:	05279d63          	bne	a5,s2,80004378 <namex+0x162>
    path++;
    80004322:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004324:	0004c783          	lbu	a5,0(s1)
    80004328:	ff278de3          	beq	a5,s2,80004322 <namex+0x10c>
  if(*path == 0)
    8000432c:	cf8d                	beqz	a5,80004366 <namex+0x150>
  while(*path != '/' && *path != 0)
    8000432e:	01278b63          	beq	a5,s2,80004344 <namex+0x12e>
    80004332:	c795                	beqz	a5,8000435e <namex+0x148>
    path++;
    80004334:	85a6                	mv	a1,s1
    path++;
    80004336:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004338:	0004c783          	lbu	a5,0(s1)
    8000433c:	f7278de3          	beq	a5,s2,800042b6 <namex+0xa0>
    80004340:	fbfd                	bnez	a5,80004336 <namex+0x120>
    80004342:	bf95                	j	800042b6 <namex+0xa0>
    80004344:	85a6                	mv	a1,s1
  len = path - s;
    80004346:	8a5a                	mv	s4,s6
    80004348:	865a                	mv	a2,s6
    memmove(name, s, len);
    8000434a:	2601                	sext.w	a2,a2
    8000434c:	8556                	mv	a0,s5
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	a4c080e7          	jalr	-1460(ra) # 80000d9a <memmove>
    name[len] = 0;
    80004356:	9a56                	add	s4,s4,s5
    80004358:	000a0023          	sb	zero,0(s4)
    8000435c:	bf8d                	j	800042ce <namex+0xb8>
  while(*path != '/' && *path != 0)
    8000435e:	85a6                	mv	a1,s1
  len = path - s;
    80004360:	8a5a                	mv	s4,s6
    80004362:	865a                	mv	a2,s6
    80004364:	b7dd                	j	8000434a <namex+0x134>
  if(nameiparent){
    80004366:	f00b8de3          	beqz	s7,80004280 <namex+0x6a>
    iput(ip);
    8000436a:	854e                	mv	a0,s3
    8000436c:	00000097          	auipc	ra,0x0
    80004370:	ad0080e7          	jalr	-1328(ra) # 80003e3c <iput>
    return 0;
    80004374:	4981                	li	s3,0
    80004376:	b729                	j	80004280 <namex+0x6a>
  if(*path == 0)
    80004378:	d7fd                	beqz	a5,80004366 <namex+0x150>
    8000437a:	85a6                	mv	a1,s1
    8000437c:	bf6d                	j	80004336 <namex+0x120>

000000008000437e <dirlink>:
{
    8000437e:	7139                	addi	sp,sp,-64
    80004380:	fc06                	sd	ra,56(sp)
    80004382:	f822                	sd	s0,48(sp)
    80004384:	f426                	sd	s1,40(sp)
    80004386:	f04a                	sd	s2,32(sp)
    80004388:	ec4e                	sd	s3,24(sp)
    8000438a:	e852                	sd	s4,16(sp)
    8000438c:	0080                	addi	s0,sp,64
    8000438e:	892a                	mv	s2,a0
    80004390:	8a2e                	mv	s4,a1
    80004392:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004394:	4601                	li	a2,0
    80004396:	00000097          	auipc	ra,0x0
    8000439a:	dd0080e7          	jalr	-560(ra) # 80004166 <dirlookup>
    8000439e:	e93d                	bnez	a0,80004414 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043a0:	04c92483          	lw	s1,76(s2)
    800043a4:	c49d                	beqz	s1,800043d2 <dirlink+0x54>
    800043a6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043a8:	4741                	li	a4,16
    800043aa:	86a6                	mv	a3,s1
    800043ac:	fc040613          	addi	a2,s0,-64
    800043b0:	4581                	li	a1,0
    800043b2:	854a                	mv	a0,s2
    800043b4:	00000097          	auipc	ra,0x0
    800043b8:	b82080e7          	jalr	-1150(ra) # 80003f36 <readi>
    800043bc:	47c1                	li	a5,16
    800043be:	06f51163          	bne	a0,a5,80004420 <dirlink+0xa2>
    if(de.inum == 0)
    800043c2:	fc045783          	lhu	a5,-64(s0)
    800043c6:	c791                	beqz	a5,800043d2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043c8:	24c1                	addiw	s1,s1,16
    800043ca:	04c92783          	lw	a5,76(s2)
    800043ce:	fcf4ede3          	bltu	s1,a5,800043a8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800043d2:	4639                	li	a2,14
    800043d4:	85d2                	mv	a1,s4
    800043d6:	fc240513          	addi	a0,s0,-62
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	a88080e7          	jalr	-1400(ra) # 80000e62 <strncpy>
  de.inum = inum;
    800043e2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043e6:	4741                	li	a4,16
    800043e8:	86a6                	mv	a3,s1
    800043ea:	fc040613          	addi	a2,s0,-64
    800043ee:	4581                	li	a1,0
    800043f0:	854a                	mv	a0,s2
    800043f2:	00000097          	auipc	ra,0x0
    800043f6:	c3c080e7          	jalr	-964(ra) # 8000402e <writei>
    800043fa:	4741                	li	a4,16
  return 0;
    800043fc:	4781                	li	a5,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043fe:	02e51963          	bne	a0,a4,80004430 <dirlink+0xb2>
}
    80004402:	853e                	mv	a0,a5
    80004404:	70e2                	ld	ra,56(sp)
    80004406:	7442                	ld	s0,48(sp)
    80004408:	74a2                	ld	s1,40(sp)
    8000440a:	7902                	ld	s2,32(sp)
    8000440c:	69e2                	ld	s3,24(sp)
    8000440e:	6a42                	ld	s4,16(sp)
    80004410:	6121                	addi	sp,sp,64
    80004412:	8082                	ret
    iput(ip);
    80004414:	00000097          	auipc	ra,0x0
    80004418:	a28080e7          	jalr	-1496(ra) # 80003e3c <iput>
    return -1;
    8000441c:	57fd                	li	a5,-1
    8000441e:	b7d5                	j	80004402 <dirlink+0x84>
      panic("dirlink read");
    80004420:	00004517          	auipc	a0,0x4
    80004424:	34050513          	addi	a0,a0,832 # 80008760 <syscalls+0x2f8>
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	13e080e7          	jalr	318(ra) # 80000566 <panic>
    panic("dirlink");
    80004430:	00004517          	auipc	a0,0x4
    80004434:	43850513          	addi	a0,a0,1080 # 80008868 <syscalls+0x400>
    80004438:	ffffc097          	auipc	ra,0xffffc
    8000443c:	12e080e7          	jalr	302(ra) # 80000566 <panic>

0000000080004440 <namei>:

struct inode*
namei(char *path)
{
    80004440:	1101                	addi	sp,sp,-32
    80004442:	ec06                	sd	ra,24(sp)
    80004444:	e822                	sd	s0,16(sp)
    80004446:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004448:	fe040613          	addi	a2,s0,-32
    8000444c:	4581                	li	a1,0
    8000444e:	00000097          	auipc	ra,0x0
    80004452:	dc8080e7          	jalr	-568(ra) # 80004216 <namex>
}
    80004456:	60e2                	ld	ra,24(sp)
    80004458:	6442                	ld	s0,16(sp)
    8000445a:	6105                	addi	sp,sp,32
    8000445c:	8082                	ret

000000008000445e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000445e:	1141                	addi	sp,sp,-16
    80004460:	e406                	sd	ra,8(sp)
    80004462:	e022                	sd	s0,0(sp)
    80004464:	0800                	addi	s0,sp,16
  return namex(path, 1, name);
    80004466:	862e                	mv	a2,a1
    80004468:	4585                	li	a1,1
    8000446a:	00000097          	auipc	ra,0x0
    8000446e:	dac080e7          	jalr	-596(ra) # 80004216 <namex>
}
    80004472:	60a2                	ld	ra,8(sp)
    80004474:	6402                	ld	s0,0(sp)
    80004476:	0141                	addi	sp,sp,16
    80004478:	8082                	ret

000000008000447a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000447a:	1101                	addi	sp,sp,-32
    8000447c:	ec06                	sd	ra,24(sp)
    8000447e:	e822                	sd	s0,16(sp)
    80004480:	e426                	sd	s1,8(sp)
    80004482:	e04a                	sd	s2,0(sp)
    80004484:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004486:	0001e917          	auipc	s2,0x1e
    8000448a:	bea90913          	addi	s2,s2,-1046 # 80022070 <log>
    8000448e:	01892583          	lw	a1,24(s2)
    80004492:	02892503          	lw	a0,40(s2)
    80004496:	fffff097          	auipc	ra,0xfffff
    8000449a:	fa2080e7          	jalr	-94(ra) # 80003438 <bread>
    8000449e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800044a0:	02c92683          	lw	a3,44(s2)
    800044a4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800044a6:	02d05763          	blez	a3,800044d4 <write_head+0x5a>
    800044aa:	0001e797          	auipc	a5,0x1e
    800044ae:	bf678793          	addi	a5,a5,-1034 # 800220a0 <log+0x30>
    800044b2:	05c50713          	addi	a4,a0,92
    800044b6:	36fd                	addiw	a3,a3,-1
    800044b8:	1682                	slli	a3,a3,0x20
    800044ba:	9281                	srli	a3,a3,0x20
    800044bc:	068a                	slli	a3,a3,0x2
    800044be:	0001e617          	auipc	a2,0x1e
    800044c2:	be660613          	addi	a2,a2,-1050 # 800220a4 <log+0x34>
    800044c6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800044c8:	4390                	lw	a2,0(a5)
    800044ca:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800044cc:	0791                	addi	a5,a5,4
    800044ce:	0711                	addi	a4,a4,4
    800044d0:	fed79ce3          	bne	a5,a3,800044c8 <write_head+0x4e>
  }
  bwrite(buf);
    800044d4:	8526                	mv	a0,s1
    800044d6:	fffff097          	auipc	ra,0xfffff
    800044da:	066080e7          	jalr	102(ra) # 8000353c <bwrite>
  brelse(buf);
    800044de:	8526                	mv	a0,s1
    800044e0:	fffff097          	auipc	ra,0xfffff
    800044e4:	09a080e7          	jalr	154(ra) # 8000357a <brelse>
}
    800044e8:	60e2                	ld	ra,24(sp)
    800044ea:	6442                	ld	s0,16(sp)
    800044ec:	64a2                	ld	s1,8(sp)
    800044ee:	6902                	ld	s2,0(sp)
    800044f0:	6105                	addi	sp,sp,32
    800044f2:	8082                	ret

00000000800044f4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044f4:	0001e797          	auipc	a5,0x1e
    800044f8:	b7c78793          	addi	a5,a5,-1156 # 80022070 <log>
    800044fc:	57dc                	lw	a5,44(a5)
    800044fe:	0af05d63          	blez	a5,800045b8 <install_trans+0xc4>
{
    80004502:	7139                	addi	sp,sp,-64
    80004504:	fc06                	sd	ra,56(sp)
    80004506:	f822                	sd	s0,48(sp)
    80004508:	f426                	sd	s1,40(sp)
    8000450a:	f04a                	sd	s2,32(sp)
    8000450c:	ec4e                	sd	s3,24(sp)
    8000450e:	e852                	sd	s4,16(sp)
    80004510:	e456                	sd	s5,8(sp)
    80004512:	e05a                	sd	s6,0(sp)
    80004514:	0080                	addi	s0,sp,64
    80004516:	8b2a                	mv	s6,a0
    80004518:	0001ea17          	auipc	s4,0x1e
    8000451c:	b88a0a13          	addi	s4,s4,-1144 # 800220a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004520:	4981                	li	s3,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004522:	0001e917          	auipc	s2,0x1e
    80004526:	b4e90913          	addi	s2,s2,-1202 # 80022070 <log>
    8000452a:	a035                	j	80004556 <install_trans+0x62>
      bunpin(dbuf);
    8000452c:	8526                	mv	a0,s1
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	126080e7          	jalr	294(ra) # 80003654 <bunpin>
    brelse(lbuf);
    80004536:	8556                	mv	a0,s5
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	042080e7          	jalr	66(ra) # 8000357a <brelse>
    brelse(dbuf);
    80004540:	8526                	mv	a0,s1
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	038080e7          	jalr	56(ra) # 8000357a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000454a:	2985                	addiw	s3,s3,1
    8000454c:	0a11                	addi	s4,s4,4
    8000454e:	02c92783          	lw	a5,44(s2)
    80004552:	04f9d963          	bge	s3,a5,800045a4 <install_trans+0xb0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004556:	01892583          	lw	a1,24(s2)
    8000455a:	013585bb          	addw	a1,a1,s3
    8000455e:	2585                	addiw	a1,a1,1
    80004560:	02892503          	lw	a0,40(s2)
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	ed4080e7          	jalr	-300(ra) # 80003438 <bread>
    8000456c:	8aaa                	mv	s5,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000456e:	000a2583          	lw	a1,0(s4)
    80004572:	02892503          	lw	a0,40(s2)
    80004576:	fffff097          	auipc	ra,0xfffff
    8000457a:	ec2080e7          	jalr	-318(ra) # 80003438 <bread>
    8000457e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004580:	40000613          	li	a2,1024
    80004584:	058a8593          	addi	a1,s5,88
    80004588:	05850513          	addi	a0,a0,88
    8000458c:	ffffd097          	auipc	ra,0xffffd
    80004590:	80e080e7          	jalr	-2034(ra) # 80000d9a <memmove>
    bwrite(dbuf);  // write dst to disk
    80004594:	8526                	mv	a0,s1
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	fa6080e7          	jalr	-90(ra) # 8000353c <bwrite>
    if(recovering == 0)
    8000459e:	f80b1ce3          	bnez	s6,80004536 <install_trans+0x42>
    800045a2:	b769                	j	8000452c <install_trans+0x38>
}
    800045a4:	70e2                	ld	ra,56(sp)
    800045a6:	7442                	ld	s0,48(sp)
    800045a8:	74a2                	ld	s1,40(sp)
    800045aa:	7902                	ld	s2,32(sp)
    800045ac:	69e2                	ld	s3,24(sp)
    800045ae:	6a42                	ld	s4,16(sp)
    800045b0:	6aa2                	ld	s5,8(sp)
    800045b2:	6b02                	ld	s6,0(sp)
    800045b4:	6121                	addi	sp,sp,64
    800045b6:	8082                	ret
    800045b8:	8082                	ret

00000000800045ba <initlog>:
{
    800045ba:	7179                	addi	sp,sp,-48
    800045bc:	f406                	sd	ra,40(sp)
    800045be:	f022                	sd	s0,32(sp)
    800045c0:	ec26                	sd	s1,24(sp)
    800045c2:	e84a                	sd	s2,16(sp)
    800045c4:	e44e                	sd	s3,8(sp)
    800045c6:	1800                	addi	s0,sp,48
    800045c8:	892a                	mv	s2,a0
    800045ca:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800045cc:	0001e497          	auipc	s1,0x1e
    800045d0:	aa448493          	addi	s1,s1,-1372 # 80022070 <log>
    800045d4:	00004597          	auipc	a1,0x4
    800045d8:	19c58593          	addi	a1,a1,412 # 80008770 <syscalls+0x308>
    800045dc:	8526                	mv	a0,s1
    800045de:	ffffc097          	auipc	ra,0xffffc
    800045e2:	5c4080e7          	jalr	1476(ra) # 80000ba2 <initlock>
  log.start = sb->logstart;
    800045e6:	0149a583          	lw	a1,20(s3)
    800045ea:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800045ec:	0109a783          	lw	a5,16(s3)
    800045f0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800045f2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045f6:	854a                	mv	a0,s2
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	e40080e7          	jalr	-448(ra) # 80003438 <bread>
  log.lh.n = lh->n;
    80004600:	4d3c                	lw	a5,88(a0)
    80004602:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004604:	02f05563          	blez	a5,8000462e <initlog+0x74>
    80004608:	05c50713          	addi	a4,a0,92
    8000460c:	0001e697          	auipc	a3,0x1e
    80004610:	a9468693          	addi	a3,a3,-1388 # 800220a0 <log+0x30>
    80004614:	37fd                	addiw	a5,a5,-1
    80004616:	1782                	slli	a5,a5,0x20
    80004618:	9381                	srli	a5,a5,0x20
    8000461a:	078a                	slli	a5,a5,0x2
    8000461c:	06050613          	addi	a2,a0,96
    80004620:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80004622:	4310                	lw	a2,0(a4)
    80004624:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80004626:	0711                	addi	a4,a4,4
    80004628:	0691                	addi	a3,a3,4
    8000462a:	fef71ce3          	bne	a4,a5,80004622 <initlog+0x68>
  brelse(buf);
    8000462e:	fffff097          	auipc	ra,0xfffff
    80004632:	f4c080e7          	jalr	-180(ra) # 8000357a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004636:	4505                	li	a0,1
    80004638:	00000097          	auipc	ra,0x0
    8000463c:	ebc080e7          	jalr	-324(ra) # 800044f4 <install_trans>
  log.lh.n = 0;
    80004640:	0001e797          	auipc	a5,0x1e
    80004644:	a407ae23          	sw	zero,-1444(a5) # 8002209c <log+0x2c>
  write_head(); // clear the log
    80004648:	00000097          	auipc	ra,0x0
    8000464c:	e32080e7          	jalr	-462(ra) # 8000447a <write_head>
}
    80004650:	70a2                	ld	ra,40(sp)
    80004652:	7402                	ld	s0,32(sp)
    80004654:	64e2                	ld	s1,24(sp)
    80004656:	6942                	ld	s2,16(sp)
    80004658:	69a2                	ld	s3,8(sp)
    8000465a:	6145                	addi	sp,sp,48
    8000465c:	8082                	ret

000000008000465e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000465e:	1101                	addi	sp,sp,-32
    80004660:	ec06                	sd	ra,24(sp)
    80004662:	e822                	sd	s0,16(sp)
    80004664:	e426                	sd	s1,8(sp)
    80004666:	e04a                	sd	s2,0(sp)
    80004668:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000466a:	0001e517          	auipc	a0,0x1e
    8000466e:	a0650513          	addi	a0,a0,-1530 # 80022070 <log>
    80004672:	ffffc097          	auipc	ra,0xffffc
    80004676:	5c0080e7          	jalr	1472(ra) # 80000c32 <acquire>
  while(1){
    if(log.committing){
    8000467a:	0001e497          	auipc	s1,0x1e
    8000467e:	9f648493          	addi	s1,s1,-1546 # 80022070 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004682:	4979                	li	s2,30
    80004684:	a039                	j	80004692 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004686:	85a6                	mv	a1,s1
    80004688:	8526                	mv	a0,s1
    8000468a:	ffffe097          	auipc	ra,0xffffe
    8000468e:	b20080e7          	jalr	-1248(ra) # 800021aa <sleep>
    if(log.committing){
    80004692:	50dc                	lw	a5,36(s1)
    80004694:	fbed                	bnez	a5,80004686 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004696:	509c                	lw	a5,32(s1)
    80004698:	0017871b          	addiw	a4,a5,1
    8000469c:	0007069b          	sext.w	a3,a4
    800046a0:	0027179b          	slliw	a5,a4,0x2
    800046a4:	9fb9                	addw	a5,a5,a4
    800046a6:	0017979b          	slliw	a5,a5,0x1
    800046aa:	54d8                	lw	a4,44(s1)
    800046ac:	9fb9                	addw	a5,a5,a4
    800046ae:	00f95963          	bge	s2,a5,800046c0 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800046b2:	85a6                	mv	a1,s1
    800046b4:	8526                	mv	a0,s1
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	af4080e7          	jalr	-1292(ra) # 800021aa <sleep>
    800046be:	bfd1                	j	80004692 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800046c0:	0001e517          	auipc	a0,0x1e
    800046c4:	9b050513          	addi	a0,a0,-1616 # 80022070 <log>
    800046c8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800046ca:	ffffc097          	auipc	ra,0xffffc
    800046ce:	61c080e7          	jalr	1564(ra) # 80000ce6 <release>
      break;
    }
  }
}
    800046d2:	60e2                	ld	ra,24(sp)
    800046d4:	6442                	ld	s0,16(sp)
    800046d6:	64a2                	ld	s1,8(sp)
    800046d8:	6902                	ld	s2,0(sp)
    800046da:	6105                	addi	sp,sp,32
    800046dc:	8082                	ret

00000000800046de <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800046de:	7139                	addi	sp,sp,-64
    800046e0:	fc06                	sd	ra,56(sp)
    800046e2:	f822                	sd	s0,48(sp)
    800046e4:	f426                	sd	s1,40(sp)
    800046e6:	f04a                	sd	s2,32(sp)
    800046e8:	ec4e                	sd	s3,24(sp)
    800046ea:	e852                	sd	s4,16(sp)
    800046ec:	e456                	sd	s5,8(sp)
    800046ee:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800046f0:	0001e917          	auipc	s2,0x1e
    800046f4:	98090913          	addi	s2,s2,-1664 # 80022070 <log>
    800046f8:	854a                	mv	a0,s2
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	538080e7          	jalr	1336(ra) # 80000c32 <acquire>
  log.outstanding -= 1;
    80004702:	02092783          	lw	a5,32(s2)
    80004706:	37fd                	addiw	a5,a5,-1
    80004708:	0007849b          	sext.w	s1,a5
    8000470c:	02f92023          	sw	a5,32(s2)
  if(log.committing)
    80004710:	02492783          	lw	a5,36(s2)
    80004714:	eba1                	bnez	a5,80004764 <end_op+0x86>
    panic("log.committing");
  if(log.outstanding == 0){
    80004716:	ecb9                	bnez	s1,80004774 <end_op+0x96>
    do_commit = 1;
    log.committing = 1;
    80004718:	0001e917          	auipc	s2,0x1e
    8000471c:	95890913          	addi	s2,s2,-1704 # 80022070 <log>
    80004720:	4785                	li	a5,1
    80004722:	02f92223          	sw	a5,36(s2)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004726:	854a                	mv	a0,s2
    80004728:	ffffc097          	auipc	ra,0xffffc
    8000472c:	5be080e7          	jalr	1470(ra) # 80000ce6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004730:	02c92783          	lw	a5,44(s2)
    80004734:	06f04763          	bgtz	a5,800047a2 <end_op+0xc4>
    acquire(&log.lock);
    80004738:	0001e497          	auipc	s1,0x1e
    8000473c:	93848493          	addi	s1,s1,-1736 # 80022070 <log>
    80004740:	8526                	mv	a0,s1
    80004742:	ffffc097          	auipc	ra,0xffffc
    80004746:	4f0080e7          	jalr	1264(ra) # 80000c32 <acquire>
    log.committing = 0;
    8000474a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000474e:	8526                	mv	a0,s1
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	d40080e7          	jalr	-704(ra) # 80002490 <wakeup>
    release(&log.lock);
    80004758:	8526                	mv	a0,s1
    8000475a:	ffffc097          	auipc	ra,0xffffc
    8000475e:	58c080e7          	jalr	1420(ra) # 80000ce6 <release>
}
    80004762:	a03d                	j	80004790 <end_op+0xb2>
    panic("log.committing");
    80004764:	00004517          	auipc	a0,0x4
    80004768:	01450513          	addi	a0,a0,20 # 80008778 <syscalls+0x310>
    8000476c:	ffffc097          	auipc	ra,0xffffc
    80004770:	dfa080e7          	jalr	-518(ra) # 80000566 <panic>
    wakeup(&log);
    80004774:	0001e497          	auipc	s1,0x1e
    80004778:	8fc48493          	addi	s1,s1,-1796 # 80022070 <log>
    8000477c:	8526                	mv	a0,s1
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	d12080e7          	jalr	-750(ra) # 80002490 <wakeup>
  release(&log.lock);
    80004786:	8526                	mv	a0,s1
    80004788:	ffffc097          	auipc	ra,0xffffc
    8000478c:	55e080e7          	jalr	1374(ra) # 80000ce6 <release>
}
    80004790:	70e2                	ld	ra,56(sp)
    80004792:	7442                	ld	s0,48(sp)
    80004794:	74a2                	ld	s1,40(sp)
    80004796:	7902                	ld	s2,32(sp)
    80004798:	69e2                	ld	s3,24(sp)
    8000479a:	6a42                	ld	s4,16(sp)
    8000479c:	6aa2                	ld	s5,8(sp)
    8000479e:	6121                	addi	sp,sp,64
    800047a0:	8082                	ret
    800047a2:	0001ea17          	auipc	s4,0x1e
    800047a6:	8fea0a13          	addi	s4,s4,-1794 # 800220a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047aa:	0001e917          	auipc	s2,0x1e
    800047ae:	8c690913          	addi	s2,s2,-1850 # 80022070 <log>
    800047b2:	01892583          	lw	a1,24(s2)
    800047b6:	9da5                	addw	a1,a1,s1
    800047b8:	2585                	addiw	a1,a1,1
    800047ba:	02892503          	lw	a0,40(s2)
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	c7a080e7          	jalr	-902(ra) # 80003438 <bread>
    800047c6:	89aa                	mv	s3,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800047c8:	000a2583          	lw	a1,0(s4)
    800047cc:	02892503          	lw	a0,40(s2)
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	c68080e7          	jalr	-920(ra) # 80003438 <bread>
    800047d8:	8aaa                	mv	s5,a0
    memmove(to->data, from->data, BSIZE);
    800047da:	40000613          	li	a2,1024
    800047de:	05850593          	addi	a1,a0,88
    800047e2:	05898513          	addi	a0,s3,88
    800047e6:	ffffc097          	auipc	ra,0xffffc
    800047ea:	5b4080e7          	jalr	1460(ra) # 80000d9a <memmove>
    bwrite(to);  // write the log
    800047ee:	854e                	mv	a0,s3
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	d4c080e7          	jalr	-692(ra) # 8000353c <bwrite>
    brelse(from);
    800047f8:	8556                	mv	a0,s5
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	d80080e7          	jalr	-640(ra) # 8000357a <brelse>
    brelse(to);
    80004802:	854e                	mv	a0,s3
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	d76080e7          	jalr	-650(ra) # 8000357a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000480c:	2485                	addiw	s1,s1,1
    8000480e:	0a11                	addi	s4,s4,4
    80004810:	02c92783          	lw	a5,44(s2)
    80004814:	f8f4cfe3          	blt	s1,a5,800047b2 <end_op+0xd4>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004818:	00000097          	auipc	ra,0x0
    8000481c:	c62080e7          	jalr	-926(ra) # 8000447a <write_head>
    install_trans(0); // Now install writes to home locations
    80004820:	4501                	li	a0,0
    80004822:	00000097          	auipc	ra,0x0
    80004826:	cd2080e7          	jalr	-814(ra) # 800044f4 <install_trans>
    log.lh.n = 0;
    8000482a:	0001e797          	auipc	a5,0x1e
    8000482e:	8607a923          	sw	zero,-1934(a5) # 8002209c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004832:	00000097          	auipc	ra,0x0
    80004836:	c48080e7          	jalr	-952(ra) # 8000447a <write_head>
    8000483a:	bdfd                	j	80004738 <end_op+0x5a>

000000008000483c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000483c:	1101                	addi	sp,sp,-32
    8000483e:	ec06                	sd	ra,24(sp)
    80004840:	e822                	sd	s0,16(sp)
    80004842:	e426                	sd	s1,8(sp)
    80004844:	e04a                	sd	s2,0(sp)
    80004846:	1000                	addi	s0,sp,32
    80004848:	892a                	mv	s2,a0
  int i;

  acquire(&log.lock);
    8000484a:	0001e497          	auipc	s1,0x1e
    8000484e:	82648493          	addi	s1,s1,-2010 # 80022070 <log>
    80004852:	8526                	mv	a0,s1
    80004854:	ffffc097          	auipc	ra,0xffffc
    80004858:	3de080e7          	jalr	990(ra) # 80000c32 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000485c:	54d0                	lw	a2,44(s1)
    8000485e:	47f5                	li	a5,29
    80004860:	06c7ca63          	blt	a5,a2,800048d4 <log_write+0x98>
    80004864:	4cdc                	lw	a5,28(s1)
    80004866:	37fd                	addiw	a5,a5,-1
    80004868:	06f65663          	bge	a2,a5,800048d4 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000486c:	0001e797          	auipc	a5,0x1e
    80004870:	80478793          	addi	a5,a5,-2044 # 80022070 <log>
    80004874:	539c                	lw	a5,32(a5)
    80004876:	06f05763          	blez	a5,800048e4 <log_write+0xa8>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000487a:	0ac05463          	blez	a2,80004922 <log_write+0xe6>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000487e:	00c92583          	lw	a1,12(s2)
    80004882:	0001d797          	auipc	a5,0x1d
    80004886:	7ee78793          	addi	a5,a5,2030 # 80022070 <log>
    8000488a:	5b9c                	lw	a5,48(a5)
    8000488c:	0ab78363          	beq	a5,a1,80004932 <log_write+0xf6>
    80004890:	0001e717          	auipc	a4,0x1e
    80004894:	81470713          	addi	a4,a4,-2028 # 800220a4 <log+0x34>
  for (i = 0; i < log.lh.n; i++) {
    80004898:	4781                	li	a5,0
    8000489a:	2785                	addiw	a5,a5,1
    8000489c:	04f60c63          	beq	a2,a5,800048f4 <log_write+0xb8>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048a0:	4314                	lw	a3,0(a4)
    800048a2:	0711                	addi	a4,a4,4
    800048a4:	feb69be3          	bne	a3,a1,8000489a <log_write+0x5e>
      break;
  }
  log.lh.block[i] = b->blockno;
    800048a8:	07a1                	addi	a5,a5,8
    800048aa:	078a                	slli	a5,a5,0x2
    800048ac:	0001d717          	auipc	a4,0x1d
    800048b0:	7c470713          	addi	a4,a4,1988 # 80022070 <log>
    800048b4:	97ba                	add	a5,a5,a4
    800048b6:	cb8c                	sw	a1,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    log.lh.n++;
  }
  release(&log.lock);
    800048b8:	0001d517          	auipc	a0,0x1d
    800048bc:	7b850513          	addi	a0,a0,1976 # 80022070 <log>
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	426080e7          	jalr	1062(ra) # 80000ce6 <release>
}
    800048c8:	60e2                	ld	ra,24(sp)
    800048ca:	6442                	ld	s0,16(sp)
    800048cc:	64a2                	ld	s1,8(sp)
    800048ce:	6902                	ld	s2,0(sp)
    800048d0:	6105                	addi	sp,sp,32
    800048d2:	8082                	ret
    panic("too big a transaction");
    800048d4:	00004517          	auipc	a0,0x4
    800048d8:	eb450513          	addi	a0,a0,-332 # 80008788 <syscalls+0x320>
    800048dc:	ffffc097          	auipc	ra,0xffffc
    800048e0:	c8a080e7          	jalr	-886(ra) # 80000566 <panic>
    panic("log_write outside of trans");
    800048e4:	00004517          	auipc	a0,0x4
    800048e8:	ebc50513          	addi	a0,a0,-324 # 800087a0 <syscalls+0x338>
    800048ec:	ffffc097          	auipc	ra,0xffffc
    800048f0:	c7a080e7          	jalr	-902(ra) # 80000566 <panic>
  log.lh.block[i] = b->blockno;
    800048f4:	0621                	addi	a2,a2,8
    800048f6:	060a                	slli	a2,a2,0x2
    800048f8:	0001d797          	auipc	a5,0x1d
    800048fc:	77878793          	addi	a5,a5,1912 # 80022070 <log>
    80004900:	963e                	add	a2,a2,a5
    80004902:	00c92783          	lw	a5,12(s2)
    80004906:	ca1c                	sw	a5,16(a2)
    bpin(b);
    80004908:	854a                	mv	a0,s2
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	d0e080e7          	jalr	-754(ra) # 80003618 <bpin>
    log.lh.n++;
    80004912:	0001d717          	auipc	a4,0x1d
    80004916:	75e70713          	addi	a4,a4,1886 # 80022070 <log>
    8000491a:	575c                	lw	a5,44(a4)
    8000491c:	2785                	addiw	a5,a5,1
    8000491e:	d75c                	sw	a5,44(a4)
    80004920:	bf61                	j	800048b8 <log_write+0x7c>
  log.lh.block[i] = b->blockno;
    80004922:	00c92783          	lw	a5,12(s2)
    80004926:	0001d717          	auipc	a4,0x1d
    8000492a:	76f72d23          	sw	a5,1914(a4) # 800220a0 <log+0x30>
  if (i == log.lh.n) {  // Add new block to log?
    8000492e:	f649                	bnez	a2,800048b8 <log_write+0x7c>
    80004930:	bfe1                	j	80004908 <log_write+0xcc>
  for (i = 0; i < log.lh.n; i++) {
    80004932:	4781                	li	a5,0
    80004934:	bf95                	j	800048a8 <log_write+0x6c>

0000000080004936 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004936:	1101                	addi	sp,sp,-32
    80004938:	ec06                	sd	ra,24(sp)
    8000493a:	e822                	sd	s0,16(sp)
    8000493c:	e426                	sd	s1,8(sp)
    8000493e:	e04a                	sd	s2,0(sp)
    80004940:	1000                	addi	s0,sp,32
    80004942:	84aa                	mv	s1,a0
    80004944:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004946:	00004597          	auipc	a1,0x4
    8000494a:	e7a58593          	addi	a1,a1,-390 # 800087c0 <syscalls+0x358>
    8000494e:	0521                	addi	a0,a0,8
    80004950:	ffffc097          	auipc	ra,0xffffc
    80004954:	252080e7          	jalr	594(ra) # 80000ba2 <initlock>
  lk->name = name;
    80004958:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000495c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004960:	0204a423          	sw	zero,40(s1)
}
    80004964:	60e2                	ld	ra,24(sp)
    80004966:	6442                	ld	s0,16(sp)
    80004968:	64a2                	ld	s1,8(sp)
    8000496a:	6902                	ld	s2,0(sp)
    8000496c:	6105                	addi	sp,sp,32
    8000496e:	8082                	ret

0000000080004970 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004970:	1101                	addi	sp,sp,-32
    80004972:	ec06                	sd	ra,24(sp)
    80004974:	e822                	sd	s0,16(sp)
    80004976:	e426                	sd	s1,8(sp)
    80004978:	e04a                	sd	s2,0(sp)
    8000497a:	1000                	addi	s0,sp,32
    8000497c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000497e:	00850913          	addi	s2,a0,8
    80004982:	854a                	mv	a0,s2
    80004984:	ffffc097          	auipc	ra,0xffffc
    80004988:	2ae080e7          	jalr	686(ra) # 80000c32 <acquire>
  while (lk->locked) {
    8000498c:	409c                	lw	a5,0(s1)
    8000498e:	cb89                	beqz	a5,800049a0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004990:	85ca                	mv	a1,s2
    80004992:	8526                	mv	a0,s1
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	816080e7          	jalr	-2026(ra) # 800021aa <sleep>
  while (lk->locked) {
    8000499c:	409c                	lw	a5,0(s1)
    8000499e:	fbed                	bnez	a5,80004990 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049a0:	4785                	li	a5,1
    800049a2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	094080e7          	jalr	148(ra) # 80001a38 <myproc>
    800049ac:	591c                	lw	a5,48(a0)
    800049ae:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ffffc097          	auipc	ra,0xffffc
    800049b6:	334080e7          	jalr	820(ra) # 80000ce6 <release>
}
    800049ba:	60e2                	ld	ra,24(sp)
    800049bc:	6442                	ld	s0,16(sp)
    800049be:	64a2                	ld	s1,8(sp)
    800049c0:	6902                	ld	s2,0(sp)
    800049c2:	6105                	addi	sp,sp,32
    800049c4:	8082                	ret

00000000800049c6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800049c6:	1101                	addi	sp,sp,-32
    800049c8:	ec06                	sd	ra,24(sp)
    800049ca:	e822                	sd	s0,16(sp)
    800049cc:	e426                	sd	s1,8(sp)
    800049ce:	e04a                	sd	s2,0(sp)
    800049d0:	1000                	addi	s0,sp,32
    800049d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049d4:	00850913          	addi	s2,a0,8
    800049d8:	854a                	mv	a0,s2
    800049da:	ffffc097          	auipc	ra,0xffffc
    800049de:	258080e7          	jalr	600(ra) # 80000c32 <acquire>
  lk->locked = 0;
    800049e2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049e6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	aa4080e7          	jalr	-1372(ra) # 80002490 <wakeup>
  release(&lk->lk);
    800049f4:	854a                	mv	a0,s2
    800049f6:	ffffc097          	auipc	ra,0xffffc
    800049fa:	2f0080e7          	jalr	752(ra) # 80000ce6 <release>
}
    800049fe:	60e2                	ld	ra,24(sp)
    80004a00:	6442                	ld	s0,16(sp)
    80004a02:	64a2                	ld	s1,8(sp)
    80004a04:	6902                	ld	s2,0(sp)
    80004a06:	6105                	addi	sp,sp,32
    80004a08:	8082                	ret

0000000080004a0a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a0a:	7179                	addi	sp,sp,-48
    80004a0c:	f406                	sd	ra,40(sp)
    80004a0e:	f022                	sd	s0,32(sp)
    80004a10:	ec26                	sd	s1,24(sp)
    80004a12:	e84a                	sd	s2,16(sp)
    80004a14:	e44e                	sd	s3,8(sp)
    80004a16:	1800                	addi	s0,sp,48
    80004a18:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a1a:	00850913          	addi	s2,a0,8
    80004a1e:	854a                	mv	a0,s2
    80004a20:	ffffc097          	auipc	ra,0xffffc
    80004a24:	212080e7          	jalr	530(ra) # 80000c32 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a28:	409c                	lw	a5,0(s1)
    80004a2a:	ef99                	bnez	a5,80004a48 <holdingsleep+0x3e>
    80004a2c:	4481                	li	s1,0
  release(&lk->lk);
    80004a2e:	854a                	mv	a0,s2
    80004a30:	ffffc097          	auipc	ra,0xffffc
    80004a34:	2b6080e7          	jalr	694(ra) # 80000ce6 <release>
  return r;
}
    80004a38:	8526                	mv	a0,s1
    80004a3a:	70a2                	ld	ra,40(sp)
    80004a3c:	7402                	ld	s0,32(sp)
    80004a3e:	64e2                	ld	s1,24(sp)
    80004a40:	6942                	ld	s2,16(sp)
    80004a42:	69a2                	ld	s3,8(sp)
    80004a44:	6145                	addi	sp,sp,48
    80004a46:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a48:	0284a983          	lw	s3,40(s1)
    80004a4c:	ffffd097          	auipc	ra,0xffffd
    80004a50:	fec080e7          	jalr	-20(ra) # 80001a38 <myproc>
    80004a54:	5904                	lw	s1,48(a0)
    80004a56:	413484b3          	sub	s1,s1,s3
    80004a5a:	0014b493          	seqz	s1,s1
    80004a5e:	bfc1                	j	80004a2e <holdingsleep+0x24>

0000000080004a60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a60:	1141                	addi	sp,sp,-16
    80004a62:	e406                	sd	ra,8(sp)
    80004a64:	e022                	sd	s0,0(sp)
    80004a66:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a68:	00004597          	auipc	a1,0x4
    80004a6c:	d6858593          	addi	a1,a1,-664 # 800087d0 <syscalls+0x368>
    80004a70:	0001d517          	auipc	a0,0x1d
    80004a74:	74850513          	addi	a0,a0,1864 # 800221b8 <ftable>
    80004a78:	ffffc097          	auipc	ra,0xffffc
    80004a7c:	12a080e7          	jalr	298(ra) # 80000ba2 <initlock>
}
    80004a80:	60a2                	ld	ra,8(sp)
    80004a82:	6402                	ld	s0,0(sp)
    80004a84:	0141                	addi	sp,sp,16
    80004a86:	8082                	ret

0000000080004a88 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a88:	1101                	addi	sp,sp,-32
    80004a8a:	ec06                	sd	ra,24(sp)
    80004a8c:	e822                	sd	s0,16(sp)
    80004a8e:	e426                	sd	s1,8(sp)
    80004a90:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a92:	0001d517          	auipc	a0,0x1d
    80004a96:	72650513          	addi	a0,a0,1830 # 800221b8 <ftable>
    80004a9a:	ffffc097          	auipc	ra,0xffffc
    80004a9e:	198080e7          	jalr	408(ra) # 80000c32 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
    80004aa2:	0001d797          	auipc	a5,0x1d
    80004aa6:	71678793          	addi	a5,a5,1814 # 800221b8 <ftable>
    80004aaa:	4fdc                	lw	a5,28(a5)
    80004aac:	cb8d                	beqz	a5,80004ade <filealloc+0x56>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004aae:	0001d497          	auipc	s1,0x1d
    80004ab2:	74a48493          	addi	s1,s1,1866 # 800221f8 <ftable+0x40>
    80004ab6:	0001e717          	auipc	a4,0x1e
    80004aba:	6ba70713          	addi	a4,a4,1722 # 80023170 <ftable+0xfb8>
    if(f->ref == 0){
    80004abe:	40dc                	lw	a5,4(s1)
    80004ac0:	c39d                	beqz	a5,80004ae6 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ac2:	02848493          	addi	s1,s1,40
    80004ac6:	fee49ce3          	bne	s1,a4,80004abe <filealloc+0x36>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004aca:	0001d517          	auipc	a0,0x1d
    80004ace:	6ee50513          	addi	a0,a0,1774 # 800221b8 <ftable>
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	214080e7          	jalr	532(ra) # 80000ce6 <release>
  return 0;
    80004ada:	4481                	li	s1,0
    80004adc:	a839                	j	80004afa <filealloc+0x72>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004ade:	0001d497          	auipc	s1,0x1d
    80004ae2:	6f248493          	addi	s1,s1,1778 # 800221d0 <ftable+0x18>
      f->ref = 1;
    80004ae6:	4785                	li	a5,1
    80004ae8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004aea:	0001d517          	auipc	a0,0x1d
    80004aee:	6ce50513          	addi	a0,a0,1742 # 800221b8 <ftable>
    80004af2:	ffffc097          	auipc	ra,0xffffc
    80004af6:	1f4080e7          	jalr	500(ra) # 80000ce6 <release>
}
    80004afa:	8526                	mv	a0,s1
    80004afc:	60e2                	ld	ra,24(sp)
    80004afe:	6442                	ld	s0,16(sp)
    80004b00:	64a2                	ld	s1,8(sp)
    80004b02:	6105                	addi	sp,sp,32
    80004b04:	8082                	ret

0000000080004b06 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b06:	1101                	addi	sp,sp,-32
    80004b08:	ec06                	sd	ra,24(sp)
    80004b0a:	e822                	sd	s0,16(sp)
    80004b0c:	e426                	sd	s1,8(sp)
    80004b0e:	1000                	addi	s0,sp,32
    80004b10:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b12:	0001d517          	auipc	a0,0x1d
    80004b16:	6a650513          	addi	a0,a0,1702 # 800221b8 <ftable>
    80004b1a:	ffffc097          	auipc	ra,0xffffc
    80004b1e:	118080e7          	jalr	280(ra) # 80000c32 <acquire>
  if(f->ref < 1)
    80004b22:	40dc                	lw	a5,4(s1)
    80004b24:	02f05263          	blez	a5,80004b48 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b28:	2785                	addiw	a5,a5,1
    80004b2a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b2c:	0001d517          	auipc	a0,0x1d
    80004b30:	68c50513          	addi	a0,a0,1676 # 800221b8 <ftable>
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	1b2080e7          	jalr	434(ra) # 80000ce6 <release>
  return f;
}
    80004b3c:	8526                	mv	a0,s1
    80004b3e:	60e2                	ld	ra,24(sp)
    80004b40:	6442                	ld	s0,16(sp)
    80004b42:	64a2                	ld	s1,8(sp)
    80004b44:	6105                	addi	sp,sp,32
    80004b46:	8082                	ret
    panic("filedup");
    80004b48:	00004517          	auipc	a0,0x4
    80004b4c:	c9050513          	addi	a0,a0,-880 # 800087d8 <syscalls+0x370>
    80004b50:	ffffc097          	auipc	ra,0xffffc
    80004b54:	a16080e7          	jalr	-1514(ra) # 80000566 <panic>

0000000080004b58 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b58:	7139                	addi	sp,sp,-64
    80004b5a:	fc06                	sd	ra,56(sp)
    80004b5c:	f822                	sd	s0,48(sp)
    80004b5e:	f426                	sd	s1,40(sp)
    80004b60:	f04a                	sd	s2,32(sp)
    80004b62:	ec4e                	sd	s3,24(sp)
    80004b64:	e852                	sd	s4,16(sp)
    80004b66:	e456                	sd	s5,8(sp)
    80004b68:	0080                	addi	s0,sp,64
    80004b6a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b6c:	0001d517          	auipc	a0,0x1d
    80004b70:	64c50513          	addi	a0,a0,1612 # 800221b8 <ftable>
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	0be080e7          	jalr	190(ra) # 80000c32 <acquire>
  if(f->ref < 1)
    80004b7c:	40dc                	lw	a5,4(s1)
    80004b7e:	06f05163          	blez	a5,80004be0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004b82:	37fd                	addiw	a5,a5,-1
    80004b84:	0007871b          	sext.w	a4,a5
    80004b88:	c0dc                	sw	a5,4(s1)
    80004b8a:	06e04363          	bgtz	a4,80004bf0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b8e:	0004a903          	lw	s2,0(s1)
    80004b92:	0094ca83          	lbu	s5,9(s1)
    80004b96:	0104ba03          	ld	s4,16(s1)
    80004b9a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b9e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004ba2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004ba6:	0001d517          	auipc	a0,0x1d
    80004baa:	61250513          	addi	a0,a0,1554 # 800221b8 <ftable>
    80004bae:	ffffc097          	auipc	ra,0xffffc
    80004bb2:	138080e7          	jalr	312(ra) # 80000ce6 <release>

  if(ff.type == FD_PIPE){
    80004bb6:	4785                	li	a5,1
    80004bb8:	04f90d63          	beq	s2,a5,80004c12 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bbc:	3979                	addiw	s2,s2,-2
    80004bbe:	4785                	li	a5,1
    80004bc0:	0527e063          	bltu	a5,s2,80004c00 <fileclose+0xa8>
    begin_op();
    80004bc4:	00000097          	auipc	ra,0x0
    80004bc8:	a9a080e7          	jalr	-1382(ra) # 8000465e <begin_op>
    iput(ff.ip);
    80004bcc:	854e                	mv	a0,s3
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	26e080e7          	jalr	622(ra) # 80003e3c <iput>
    end_op();
    80004bd6:	00000097          	auipc	ra,0x0
    80004bda:	b08080e7          	jalr	-1272(ra) # 800046de <end_op>
    80004bde:	a00d                	j	80004c00 <fileclose+0xa8>
    panic("fileclose");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	c0050513          	addi	a0,a0,-1024 # 800087e0 <syscalls+0x378>
    80004be8:	ffffc097          	auipc	ra,0xffffc
    80004bec:	97e080e7          	jalr	-1666(ra) # 80000566 <panic>
    release(&ftable.lock);
    80004bf0:	0001d517          	auipc	a0,0x1d
    80004bf4:	5c850513          	addi	a0,a0,1480 # 800221b8 <ftable>
    80004bf8:	ffffc097          	auipc	ra,0xffffc
    80004bfc:	0ee080e7          	jalr	238(ra) # 80000ce6 <release>
  }
}
    80004c00:	70e2                	ld	ra,56(sp)
    80004c02:	7442                	ld	s0,48(sp)
    80004c04:	74a2                	ld	s1,40(sp)
    80004c06:	7902                	ld	s2,32(sp)
    80004c08:	69e2                	ld	s3,24(sp)
    80004c0a:	6a42                	ld	s4,16(sp)
    80004c0c:	6aa2                	ld	s5,8(sp)
    80004c0e:	6121                	addi	sp,sp,64
    80004c10:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c12:	85d6                	mv	a1,s5
    80004c14:	8552                	mv	a0,s4
    80004c16:	00000097          	auipc	ra,0x0
    80004c1a:	340080e7          	jalr	832(ra) # 80004f56 <pipeclose>
    80004c1e:	b7cd                	j	80004c00 <fileclose+0xa8>

0000000080004c20 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c20:	715d                	addi	sp,sp,-80
    80004c22:	e486                	sd	ra,72(sp)
    80004c24:	e0a2                	sd	s0,64(sp)
    80004c26:	fc26                	sd	s1,56(sp)
    80004c28:	f84a                	sd	s2,48(sp)
    80004c2a:	f44e                	sd	s3,40(sp)
    80004c2c:	0880                	addi	s0,sp,80
    80004c2e:	84aa                	mv	s1,a0
    80004c30:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c32:	ffffd097          	auipc	ra,0xffffd
    80004c36:	e06080e7          	jalr	-506(ra) # 80001a38 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c3a:	409c                	lw	a5,0(s1)
    80004c3c:	37f9                	addiw	a5,a5,-2
    80004c3e:	4705                	li	a4,1
    80004c40:	04f76763          	bltu	a4,a5,80004c8e <filestat+0x6e>
    80004c44:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c46:	6c88                	ld	a0,24(s1)
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	038080e7          	jalr	56(ra) # 80003c80 <ilock>
    stati(f->ip, &st);
    80004c50:	fb840593          	addi	a1,s0,-72
    80004c54:	6c88                	ld	a0,24(s1)
    80004c56:	fffff097          	auipc	ra,0xfffff
    80004c5a:	2b6080e7          	jalr	694(ra) # 80003f0c <stati>
    iunlock(f->ip);
    80004c5e:	6c88                	ld	a0,24(s1)
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	0e4080e7          	jalr	228(ra) # 80003d44 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c68:	46e1                	li	a3,24
    80004c6a:	fb840613          	addi	a2,s0,-72
    80004c6e:	85ce                	mv	a1,s3
    80004c70:	05093503          	ld	a0,80(s2)
    80004c74:	ffffd097          	auipc	ra,0xffffd
    80004c78:	a6e080e7          	jalr	-1426(ra) # 800016e2 <copyout>
    80004c7c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004c80:	60a6                	ld	ra,72(sp)
    80004c82:	6406                	ld	s0,64(sp)
    80004c84:	74e2                	ld	s1,56(sp)
    80004c86:	7942                	ld	s2,48(sp)
    80004c88:	79a2                	ld	s3,40(sp)
    80004c8a:	6161                	addi	sp,sp,80
    80004c8c:	8082                	ret
  return -1;
    80004c8e:	557d                	li	a0,-1
    80004c90:	bfc5                	j	80004c80 <filestat+0x60>

0000000080004c92 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c92:	7179                	addi	sp,sp,-48
    80004c94:	f406                	sd	ra,40(sp)
    80004c96:	f022                	sd	s0,32(sp)
    80004c98:	ec26                	sd	s1,24(sp)
    80004c9a:	e84a                	sd	s2,16(sp)
    80004c9c:	e44e                	sd	s3,8(sp)
    80004c9e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ca0:	00854783          	lbu	a5,8(a0)
    80004ca4:	c3d5                	beqz	a5,80004d48 <fileread+0xb6>
    80004ca6:	89b2                	mv	s3,a2
    80004ca8:	892e                	mv	s2,a1
    80004caa:	84aa                	mv	s1,a0
    return -1;

  if(f->type == FD_PIPE){
    80004cac:	411c                	lw	a5,0(a0)
    80004cae:	4705                	li	a4,1
    80004cb0:	04e78963          	beq	a5,a4,80004d02 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cb4:	470d                	li	a4,3
    80004cb6:	04e78d63          	beq	a5,a4,80004d10 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cba:	4709                	li	a4,2
    80004cbc:	06e79e63          	bne	a5,a4,80004d38 <fileread+0xa6>
    ilock(f->ip);
    80004cc0:	6d08                	ld	a0,24(a0)
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	fbe080e7          	jalr	-66(ra) # 80003c80 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004cca:	874e                	mv	a4,s3
    80004ccc:	5094                	lw	a3,32(s1)
    80004cce:	864a                	mv	a2,s2
    80004cd0:	4585                	li	a1,1
    80004cd2:	6c88                	ld	a0,24(s1)
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	262080e7          	jalr	610(ra) # 80003f36 <readi>
    80004cdc:	892a                	mv	s2,a0
    80004cde:	00a05563          	blez	a0,80004ce8 <fileread+0x56>
      f->off += r;
    80004ce2:	509c                	lw	a5,32(s1)
    80004ce4:	9fa9                	addw	a5,a5,a0
    80004ce6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ce8:	6c88                	ld	a0,24(s1)
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	05a080e7          	jalr	90(ra) # 80003d44 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004cf2:	854a                	mv	a0,s2
    80004cf4:	70a2                	ld	ra,40(sp)
    80004cf6:	7402                	ld	s0,32(sp)
    80004cf8:	64e2                	ld	s1,24(sp)
    80004cfa:	6942                	ld	s2,16(sp)
    80004cfc:	69a2                	ld	s3,8(sp)
    80004cfe:	6145                	addi	sp,sp,48
    80004d00:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d02:	6908                	ld	a0,16(a0)
    80004d04:	00000097          	auipc	ra,0x0
    80004d08:	3c8080e7          	jalr	968(ra) # 800050cc <piperead>
    80004d0c:	892a                	mv	s2,a0
    80004d0e:	b7d5                	j	80004cf2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d10:	02451783          	lh	a5,36(a0)
    80004d14:	03079693          	slli	a3,a5,0x30
    80004d18:	92c1                	srli	a3,a3,0x30
    80004d1a:	4725                	li	a4,9
    80004d1c:	02d76863          	bltu	a4,a3,80004d4c <fileread+0xba>
    80004d20:	0792                	slli	a5,a5,0x4
    80004d22:	0001d717          	auipc	a4,0x1d
    80004d26:	3f670713          	addi	a4,a4,1014 # 80022118 <devsw>
    80004d2a:	97ba                	add	a5,a5,a4
    80004d2c:	639c                	ld	a5,0(a5)
    80004d2e:	c38d                	beqz	a5,80004d50 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004d30:	4505                	li	a0,1
    80004d32:	9782                	jalr	a5
    80004d34:	892a                	mv	s2,a0
    80004d36:	bf75                	j	80004cf2 <fileread+0x60>
    panic("fileread");
    80004d38:	00004517          	auipc	a0,0x4
    80004d3c:	ab850513          	addi	a0,a0,-1352 # 800087f0 <syscalls+0x388>
    80004d40:	ffffc097          	auipc	ra,0xffffc
    80004d44:	826080e7          	jalr	-2010(ra) # 80000566 <panic>
    return -1;
    80004d48:	597d                	li	s2,-1
    80004d4a:	b765                	j	80004cf2 <fileread+0x60>
      return -1;
    80004d4c:	597d                	li	s2,-1
    80004d4e:	b755                	j	80004cf2 <fileread+0x60>
    80004d50:	597d                	li	s2,-1
    80004d52:	b745                	j	80004cf2 <fileread+0x60>

0000000080004d54 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004d54:	715d                	addi	sp,sp,-80
    80004d56:	e486                	sd	ra,72(sp)
    80004d58:	e0a2                	sd	s0,64(sp)
    80004d5a:	fc26                	sd	s1,56(sp)
    80004d5c:	f84a                	sd	s2,48(sp)
    80004d5e:	f44e                	sd	s3,40(sp)
    80004d60:	f052                	sd	s4,32(sp)
    80004d62:	ec56                	sd	s5,24(sp)
    80004d64:	e85a                	sd	s6,16(sp)
    80004d66:	e45e                	sd	s7,8(sp)
    80004d68:	e062                	sd	s8,0(sp)
    80004d6a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004d6c:	00954783          	lbu	a5,9(a0)
    80004d70:	10078063          	beqz	a5,80004e70 <filewrite+0x11c>
    80004d74:	84aa                	mv	s1,a0
    80004d76:	8bae                	mv	s7,a1
    80004d78:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d7a:	411c                	lw	a5,0(a0)
    80004d7c:	4705                	li	a4,1
    80004d7e:	02e78263          	beq	a5,a4,80004da2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d82:	470d                	li	a4,3
    80004d84:	02e78663          	beq	a5,a4,80004db0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d88:	4709                	li	a4,2
    80004d8a:	0ce79b63          	bne	a5,a4,80004e60 <filewrite+0x10c>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d8e:	0ac05763          	blez	a2,80004e3c <filewrite+0xe8>
    int i = 0;
    80004d92:	4901                	li	s2,0
    80004d94:	6b05                	lui	s6,0x1
    80004d96:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004d9a:	6c05                	lui	s8,0x1
    80004d9c:	c00c0c1b          	addiw	s8,s8,-1024
    80004da0:	a071                	j	80004e2c <filewrite+0xd8>
    ret = pipewrite(f->pipe, addr, n);
    80004da2:	6908                	ld	a0,16(a0)
    80004da4:	00000097          	auipc	ra,0x0
    80004da8:	222080e7          	jalr	546(ra) # 80004fc6 <pipewrite>
    80004dac:	8aaa                	mv	s5,a0
    80004dae:	a851                	j	80004e42 <filewrite+0xee>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004db0:	02451783          	lh	a5,36(a0)
    80004db4:	03079693          	slli	a3,a5,0x30
    80004db8:	92c1                	srli	a3,a3,0x30
    80004dba:	4725                	li	a4,9
    80004dbc:	0ad76c63          	bltu	a4,a3,80004e74 <filewrite+0x120>
    80004dc0:	0792                	slli	a5,a5,0x4
    80004dc2:	0001d717          	auipc	a4,0x1d
    80004dc6:	35670713          	addi	a4,a4,854 # 80022118 <devsw>
    80004dca:	97ba                	add	a5,a5,a4
    80004dcc:	679c                	ld	a5,8(a5)
    80004dce:	c7cd                	beqz	a5,80004e78 <filewrite+0x124>
    ret = devsw[f->major].write(1, addr, n);
    80004dd0:	4505                	li	a0,1
    80004dd2:	9782                	jalr	a5
    80004dd4:	8aaa                	mv	s5,a0
    80004dd6:	a0b5                	j	80004e42 <filewrite+0xee>
    80004dd8:	00098a1b          	sext.w	s4,s3
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004ddc:	00000097          	auipc	ra,0x0
    80004de0:	882080e7          	jalr	-1918(ra) # 8000465e <begin_op>
      ilock(f->ip);
    80004de4:	6c88                	ld	a0,24(s1)
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	e9a080e7          	jalr	-358(ra) # 80003c80 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004dee:	8752                	mv	a4,s4
    80004df0:	5094                	lw	a3,32(s1)
    80004df2:	01790633          	add	a2,s2,s7
    80004df6:	4585                	li	a1,1
    80004df8:	6c88                	ld	a0,24(s1)
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	234080e7          	jalr	564(ra) # 8000402e <writei>
    80004e02:	89aa                	mv	s3,a0
    80004e04:	00a05563          	blez	a0,80004e0e <filewrite+0xba>
        f->off += r;
    80004e08:	509c                	lw	a5,32(s1)
    80004e0a:	9fa9                	addw	a5,a5,a0
    80004e0c:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80004e0e:	6c88                	ld	a0,24(s1)
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	f34080e7          	jalr	-204(ra) # 80003d44 <iunlock>
      end_op();
    80004e18:	00000097          	auipc	ra,0x0
    80004e1c:	8c6080e7          	jalr	-1850(ra) # 800046de <end_op>

      if(r != n1){
    80004e20:	01499f63          	bne	s3,s4,80004e3e <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004e24:	012a093b          	addw	s2,s4,s2
    while(i < n){
    80004e28:	01595b63          	bge	s2,s5,80004e3e <filewrite+0xea>
      int n1 = n - i;
    80004e2c:	412a87bb          	subw	a5,s5,s2
      if(n1 > max)
    80004e30:	89be                	mv	s3,a5
    80004e32:	2781                	sext.w	a5,a5
    80004e34:	fafb52e3          	bge	s6,a5,80004dd8 <filewrite+0x84>
    80004e38:	89e2                	mv	s3,s8
    80004e3a:	bf79                	j	80004dd8 <filewrite+0x84>
    int i = 0;
    80004e3c:	4901                	li	s2,0
    }
    ret = (i == n ? n : -1);
    80004e3e:	012a9f63          	bne	s5,s2,80004e5c <filewrite+0x108>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e42:	8556                	mv	a0,s5
    80004e44:	60a6                	ld	ra,72(sp)
    80004e46:	6406                	ld	s0,64(sp)
    80004e48:	74e2                	ld	s1,56(sp)
    80004e4a:	7942                	ld	s2,48(sp)
    80004e4c:	79a2                	ld	s3,40(sp)
    80004e4e:	7a02                	ld	s4,32(sp)
    80004e50:	6ae2                	ld	s5,24(sp)
    80004e52:	6b42                	ld	s6,16(sp)
    80004e54:	6ba2                	ld	s7,8(sp)
    80004e56:	6c02                	ld	s8,0(sp)
    80004e58:	6161                	addi	sp,sp,80
    80004e5a:	8082                	ret
    ret = (i == n ? n : -1);
    80004e5c:	5afd                	li	s5,-1
    80004e5e:	b7d5                	j	80004e42 <filewrite+0xee>
    panic("filewrite");
    80004e60:	00004517          	auipc	a0,0x4
    80004e64:	9a050513          	addi	a0,a0,-1632 # 80008800 <syscalls+0x398>
    80004e68:	ffffb097          	auipc	ra,0xffffb
    80004e6c:	6fe080e7          	jalr	1790(ra) # 80000566 <panic>
    return -1;
    80004e70:	5afd                	li	s5,-1
    80004e72:	bfc1                	j	80004e42 <filewrite+0xee>
      return -1;
    80004e74:	5afd                	li	s5,-1
    80004e76:	b7f1                	j	80004e42 <filewrite+0xee>
    80004e78:	5afd                	li	s5,-1
    80004e7a:	b7e1                	j	80004e42 <filewrite+0xee>

0000000080004e7c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e7c:	7179                	addi	sp,sp,-48
    80004e7e:	f406                	sd	ra,40(sp)
    80004e80:	f022                	sd	s0,32(sp)
    80004e82:	ec26                	sd	s1,24(sp)
    80004e84:	e84a                	sd	s2,16(sp)
    80004e86:	e44e                	sd	s3,8(sp)
    80004e88:	e052                	sd	s4,0(sp)
    80004e8a:	1800                	addi	s0,sp,48
    80004e8c:	84aa                	mv	s1,a0
    80004e8e:	892e                	mv	s2,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e90:	0005b023          	sd	zero,0(a1)
    80004e94:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e98:	00000097          	auipc	ra,0x0
    80004e9c:	bf0080e7          	jalr	-1040(ra) # 80004a88 <filealloc>
    80004ea0:	e088                	sd	a0,0(s1)
    80004ea2:	c551                	beqz	a0,80004f2e <pipealloc+0xb2>
    80004ea4:	00000097          	auipc	ra,0x0
    80004ea8:	be4080e7          	jalr	-1052(ra) # 80004a88 <filealloc>
    80004eac:	00a93023          	sd	a0,0(s2)
    80004eb0:	c92d                	beqz	a0,80004f22 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004eb2:	ffffc097          	auipc	ra,0xffffc
    80004eb6:	c90080e7          	jalr	-880(ra) # 80000b42 <kalloc>
    80004eba:	89aa                	mv	s3,a0
    80004ebc:	c125                	beqz	a0,80004f1c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004ebe:	4a05                	li	s4,1
    80004ec0:	23452023          	sw	s4,544(a0)
  pi->writeopen = 1;
    80004ec4:	23452223          	sw	s4,548(a0)
  pi->nwrite = 0;
    80004ec8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004ecc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ed0:	00003597          	auipc	a1,0x3
    80004ed4:	6d858593          	addi	a1,a1,1752 # 800085a8 <syscalls+0x140>
    80004ed8:	ffffc097          	auipc	ra,0xffffc
    80004edc:	cca080e7          	jalr	-822(ra) # 80000ba2 <initlock>
  (*f0)->type = FD_PIPE;
    80004ee0:	609c                	ld	a5,0(s1)
    80004ee2:	0147a023          	sw	s4,0(a5)
  (*f0)->readable = 1;
    80004ee6:	609c                	ld	a5,0(s1)
    80004ee8:	01478423          	sb	s4,8(a5)
  (*f0)->writable = 0;
    80004eec:	609c                	ld	a5,0(s1)
    80004eee:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004ef2:	609c                	ld	a5,0(s1)
    80004ef4:	0137b823          	sd	s3,16(a5)
  (*f1)->type = FD_PIPE;
    80004ef8:	00093783          	ld	a5,0(s2)
    80004efc:	0147a023          	sw	s4,0(a5)
  (*f1)->readable = 0;
    80004f00:	00093783          	ld	a5,0(s2)
    80004f04:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f08:	00093783          	ld	a5,0(s2)
    80004f0c:	014784a3          	sb	s4,9(a5)
  (*f1)->pipe = pi;
    80004f10:	00093783          	ld	a5,0(s2)
    80004f14:	0137b823          	sd	s3,16(a5)
  return 0;
    80004f18:	4501                	li	a0,0
    80004f1a:	a025                	j	80004f42 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004f1c:	6088                	ld	a0,0(s1)
    80004f1e:	e501                	bnez	a0,80004f26 <pipealloc+0xaa>
    80004f20:	a039                	j	80004f2e <pipealloc+0xb2>
    80004f22:	6088                	ld	a0,0(s1)
    80004f24:	c51d                	beqz	a0,80004f52 <pipealloc+0xd6>
    fileclose(*f0);
    80004f26:	00000097          	auipc	ra,0x0
    80004f2a:	c32080e7          	jalr	-974(ra) # 80004b58 <fileclose>
  if(*f1)
    80004f2e:	00093783          	ld	a5,0(s2)
    fileclose(*f1);
  return -1;
    80004f32:	557d                	li	a0,-1
  if(*f1)
    80004f34:	c799                	beqz	a5,80004f42 <pipealloc+0xc6>
    fileclose(*f1);
    80004f36:	853e                	mv	a0,a5
    80004f38:	00000097          	auipc	ra,0x0
    80004f3c:	c20080e7          	jalr	-992(ra) # 80004b58 <fileclose>
  return -1;
    80004f40:	557d                	li	a0,-1
}
    80004f42:	70a2                	ld	ra,40(sp)
    80004f44:	7402                	ld	s0,32(sp)
    80004f46:	64e2                	ld	s1,24(sp)
    80004f48:	6942                	ld	s2,16(sp)
    80004f4a:	69a2                	ld	s3,8(sp)
    80004f4c:	6a02                	ld	s4,0(sp)
    80004f4e:	6145                	addi	sp,sp,48
    80004f50:	8082                	ret
  return -1;
    80004f52:	557d                	li	a0,-1
    80004f54:	b7fd                	j	80004f42 <pipealloc+0xc6>

0000000080004f56 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f56:	1101                	addi	sp,sp,-32
    80004f58:	ec06                	sd	ra,24(sp)
    80004f5a:	e822                	sd	s0,16(sp)
    80004f5c:	e426                	sd	s1,8(sp)
    80004f5e:	e04a                	sd	s2,0(sp)
    80004f60:	1000                	addi	s0,sp,32
    80004f62:	84aa                	mv	s1,a0
    80004f64:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f66:	ffffc097          	auipc	ra,0xffffc
    80004f6a:	ccc080e7          	jalr	-820(ra) # 80000c32 <acquire>
  if(writable){
    80004f6e:	02090d63          	beqz	s2,80004fa8 <pipeclose+0x52>
    pi->writeopen = 0;
    80004f72:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f76:	21848513          	addi	a0,s1,536
    80004f7a:	ffffd097          	auipc	ra,0xffffd
    80004f7e:	516080e7          	jalr	1302(ra) # 80002490 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f82:	2204b783          	ld	a5,544(s1)
    80004f86:	eb95                	bnez	a5,80004fba <pipeclose+0x64>
    release(&pi->lock);
    80004f88:	8526                	mv	a0,s1
    80004f8a:	ffffc097          	auipc	ra,0xffffc
    80004f8e:	d5c080e7          	jalr	-676(ra) # 80000ce6 <release>
    kfree((char*)pi);
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffc097          	auipc	ra,0xffffc
    80004f98:	aae080e7          	jalr	-1362(ra) # 80000a42 <kfree>
  } else
    release(&pi->lock);
}
    80004f9c:	60e2                	ld	ra,24(sp)
    80004f9e:	6442                	ld	s0,16(sp)
    80004fa0:	64a2                	ld	s1,8(sp)
    80004fa2:	6902                	ld	s2,0(sp)
    80004fa4:	6105                	addi	sp,sp,32
    80004fa6:	8082                	ret
    pi->readopen = 0;
    80004fa8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004fac:	21c48513          	addi	a0,s1,540
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	4e0080e7          	jalr	1248(ra) # 80002490 <wakeup>
    80004fb8:	b7e9                	j	80004f82 <pipeclose+0x2c>
    release(&pi->lock);
    80004fba:	8526                	mv	a0,s1
    80004fbc:	ffffc097          	auipc	ra,0xffffc
    80004fc0:	d2a080e7          	jalr	-726(ra) # 80000ce6 <release>
}
    80004fc4:	bfe1                	j	80004f9c <pipeclose+0x46>

0000000080004fc6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004fc6:	7159                	addi	sp,sp,-112
    80004fc8:	f486                	sd	ra,104(sp)
    80004fca:	f0a2                	sd	s0,96(sp)
    80004fcc:	eca6                	sd	s1,88(sp)
    80004fce:	e8ca                	sd	s2,80(sp)
    80004fd0:	e4ce                	sd	s3,72(sp)
    80004fd2:	e0d2                	sd	s4,64(sp)
    80004fd4:	fc56                	sd	s5,56(sp)
    80004fd6:	f85a                	sd	s6,48(sp)
    80004fd8:	f45e                	sd	s7,40(sp)
    80004fda:	f062                	sd	s8,32(sp)
    80004fdc:	ec66                	sd	s9,24(sp)
    80004fde:	1880                	addi	s0,sp,112
    80004fe0:	84aa                	mv	s1,a0
    80004fe2:	8aae                	mv	s5,a1
    80004fe4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	a52080e7          	jalr	-1454(ra) # 80001a38 <myproc>
    80004fee:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	ffffc097          	auipc	ra,0xffffc
    80004ff6:	c40080e7          	jalr	-960(ra) # 80000c32 <acquire>
  while(i < n){
    80004ffa:	0d405763          	blez	s4,800050c8 <pipewrite+0x102>
    80004ffe:	8ba6                	mv	s7,s1
    if(pi->readopen == 0 || pr->killed){
    80005000:	2204a783          	lw	a5,544(s1)
    80005004:	cb99                	beqz	a5,8000501a <pipewrite+0x54>
    80005006:	0289a903          	lw	s2,40(s3)
    8000500a:	00091863          	bnez	s2,8000501a <pipewrite+0x54>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000500e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005010:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005014:	21c48c13          	addi	s8,s1,540
    80005018:	a0bd                	j	80005086 <pipewrite+0xc0>
      release(&pi->lock);
    8000501a:	8526                	mv	a0,s1
    8000501c:	ffffc097          	auipc	ra,0xffffc
    80005020:	cca080e7          	jalr	-822(ra) # 80000ce6 <release>
      return -1;
    80005024:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005026:	854a                	mv	a0,s2
    80005028:	70a6                	ld	ra,104(sp)
    8000502a:	7406                	ld	s0,96(sp)
    8000502c:	64e6                	ld	s1,88(sp)
    8000502e:	6946                	ld	s2,80(sp)
    80005030:	69a6                	ld	s3,72(sp)
    80005032:	6a06                	ld	s4,64(sp)
    80005034:	7ae2                	ld	s5,56(sp)
    80005036:	7b42                	ld	s6,48(sp)
    80005038:	7ba2                	ld	s7,40(sp)
    8000503a:	7c02                	ld	s8,32(sp)
    8000503c:	6ce2                	ld	s9,24(sp)
    8000503e:	6165                	addi	sp,sp,112
    80005040:	8082                	ret
      wakeup(&pi->nread);
    80005042:	8566                	mv	a0,s9
    80005044:	ffffd097          	auipc	ra,0xffffd
    80005048:	44c080e7          	jalr	1100(ra) # 80002490 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000504c:	85de                	mv	a1,s7
    8000504e:	8562                	mv	a0,s8
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	15a080e7          	jalr	346(ra) # 800021aa <sleep>
    80005058:	a839                	j	80005076 <pipewrite+0xb0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000505a:	21c4a783          	lw	a5,540(s1)
    8000505e:	0017871b          	addiw	a4,a5,1
    80005062:	20e4ae23          	sw	a4,540(s1)
    80005066:	1ff7f793          	andi	a5,a5,511
    8000506a:	97a6                	add	a5,a5,s1
    8000506c:	f9f44703          	lbu	a4,-97(s0)
    80005070:	00e78c23          	sb	a4,24(a5)
      i++;
    80005074:	2905                	addiw	s2,s2,1
  while(i < n){
    80005076:	03495d63          	bge	s2,s4,800050b0 <pipewrite+0xea>
    if(pi->readopen == 0 || pr->killed){
    8000507a:	2204a783          	lw	a5,544(s1)
    8000507e:	dfd1                	beqz	a5,8000501a <pipewrite+0x54>
    80005080:	0289a783          	lw	a5,40(s3)
    80005084:	fbd9                	bnez	a5,8000501a <pipewrite+0x54>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005086:	2184a783          	lw	a5,536(s1)
    8000508a:	21c4a703          	lw	a4,540(s1)
    8000508e:	2007879b          	addiw	a5,a5,512
    80005092:	faf708e3          	beq	a4,a5,80005042 <pipewrite+0x7c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005096:	4685                	li	a3,1
    80005098:	01590633          	add	a2,s2,s5
    8000509c:	f9f40593          	addi	a1,s0,-97
    800050a0:	0509b503          	ld	a0,80(s3)
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	6ca080e7          	jalr	1738(ra) # 8000176e <copyin>
    800050ac:	fb6517e3          	bne	a0,s6,8000505a <pipewrite+0x94>
  wakeup(&pi->nread);
    800050b0:	21848513          	addi	a0,s1,536
    800050b4:	ffffd097          	auipc	ra,0xffffd
    800050b8:	3dc080e7          	jalr	988(ra) # 80002490 <wakeup>
  release(&pi->lock);
    800050bc:	8526                	mv	a0,s1
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	c28080e7          	jalr	-984(ra) # 80000ce6 <release>
  return i;
    800050c6:	b785                	j	80005026 <pipewrite+0x60>
  int i = 0;
    800050c8:	4901                	li	s2,0
    800050ca:	b7dd                	j	800050b0 <pipewrite+0xea>

00000000800050cc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800050cc:	715d                	addi	sp,sp,-80
    800050ce:	e486                	sd	ra,72(sp)
    800050d0:	e0a2                	sd	s0,64(sp)
    800050d2:	fc26                	sd	s1,56(sp)
    800050d4:	f84a                	sd	s2,48(sp)
    800050d6:	f44e                	sd	s3,40(sp)
    800050d8:	f052                	sd	s4,32(sp)
    800050da:	ec56                	sd	s5,24(sp)
    800050dc:	e85a                	sd	s6,16(sp)
    800050de:	0880                	addi	s0,sp,80
    800050e0:	84aa                	mv	s1,a0
    800050e2:	89ae                	mv	s3,a1
    800050e4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800050e6:	ffffd097          	auipc	ra,0xffffd
    800050ea:	952080e7          	jalr	-1710(ra) # 80001a38 <myproc>
    800050ee:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800050f0:	8526                	mv	a0,s1
    800050f2:	ffffc097          	auipc	ra,0xffffc
    800050f6:	b40080e7          	jalr	-1216(ra) # 80000c32 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050fa:	2184a703          	lw	a4,536(s1)
    800050fe:	21c4a783          	lw	a5,540(s1)
    80005102:	06f71b63          	bne	a4,a5,80005178 <piperead+0xac>
    80005106:	8926                	mv	s2,s1
    80005108:	2244a783          	lw	a5,548(s1)
    8000510c:	cf9d                	beqz	a5,8000514a <piperead+0x7e>
    if(pr->killed){
    8000510e:	028a2783          	lw	a5,40(s4)
    80005112:	e78d                	bnez	a5,8000513c <piperead+0x70>
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005114:	21848b13          	addi	s6,s1,536
    80005118:	85ca                	mv	a1,s2
    8000511a:	855a                	mv	a0,s6
    8000511c:	ffffd097          	auipc	ra,0xffffd
    80005120:	08e080e7          	jalr	142(ra) # 800021aa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005124:	2184a703          	lw	a4,536(s1)
    80005128:	21c4a783          	lw	a5,540(s1)
    8000512c:	04f71663          	bne	a4,a5,80005178 <piperead+0xac>
    80005130:	2244a783          	lw	a5,548(s1)
    80005134:	cb99                	beqz	a5,8000514a <piperead+0x7e>
    if(pr->killed){
    80005136:	028a2783          	lw	a5,40(s4)
    8000513a:	dff9                	beqz	a5,80005118 <piperead+0x4c>
      release(&pi->lock);
    8000513c:	8526                	mv	a0,s1
    8000513e:	ffffc097          	auipc	ra,0xffffc
    80005142:	ba8080e7          	jalr	-1112(ra) # 80000ce6 <release>
      return -1;
    80005146:	597d                	li	s2,-1
    80005148:	a829                	j	80005162 <piperead+0x96>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(pi->nread == pi->nwrite)
    8000514a:	4901                	li	s2,0
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000514c:	21c48513          	addi	a0,s1,540
    80005150:	ffffd097          	auipc	ra,0xffffd
    80005154:	340080e7          	jalr	832(ra) # 80002490 <wakeup>
  release(&pi->lock);
    80005158:	8526                	mv	a0,s1
    8000515a:	ffffc097          	auipc	ra,0xffffc
    8000515e:	b8c080e7          	jalr	-1140(ra) # 80000ce6 <release>
  return i;
}
    80005162:	854a                	mv	a0,s2
    80005164:	60a6                	ld	ra,72(sp)
    80005166:	6406                	ld	s0,64(sp)
    80005168:	74e2                	ld	s1,56(sp)
    8000516a:	7942                	ld	s2,48(sp)
    8000516c:	79a2                	ld	s3,40(sp)
    8000516e:	7a02                	ld	s4,32(sp)
    80005170:	6ae2                	ld	s5,24(sp)
    80005172:	6b42                	ld	s6,16(sp)
    80005174:	6161                	addi	sp,sp,80
    80005176:	8082                	ret
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005178:	4901                	li	s2,0
    8000517a:	fd5059e3          	blez	s5,8000514c <piperead+0x80>
    if(pi->nread == pi->nwrite)
    8000517e:	2184a783          	lw	a5,536(s1)
    80005182:	4901                	li	s2,0
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005184:	5b7d                	li	s6,-1
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005186:	0017871b          	addiw	a4,a5,1
    8000518a:	20e4ac23          	sw	a4,536(s1)
    8000518e:	1ff7f793          	andi	a5,a5,511
    80005192:	97a6                	add	a5,a5,s1
    80005194:	0187c783          	lbu	a5,24(a5)
    80005198:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000519c:	4685                	li	a3,1
    8000519e:	fbf40613          	addi	a2,s0,-65
    800051a2:	85ce                	mv	a1,s3
    800051a4:	050a3503          	ld	a0,80(s4)
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	53a080e7          	jalr	1338(ra) # 800016e2 <copyout>
    800051b0:	f9650ee3          	beq	a0,s6,8000514c <piperead+0x80>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051b4:	2905                	addiw	s2,s2,1
    800051b6:	f92a8be3          	beq	s5,s2,8000514c <piperead+0x80>
    if(pi->nread == pi->nwrite)
    800051ba:	2184a783          	lw	a5,536(s1)
    800051be:	0985                	addi	s3,s3,1
    800051c0:	21c4a703          	lw	a4,540(s1)
    800051c4:	fcf711e3          	bne	a4,a5,80005186 <piperead+0xba>
    800051c8:	b751                	j	8000514c <piperead+0x80>

00000000800051ca <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800051ca:	de010113          	addi	sp,sp,-544
    800051ce:	20113c23          	sd	ra,536(sp)
    800051d2:	20813823          	sd	s0,528(sp)
    800051d6:	20913423          	sd	s1,520(sp)
    800051da:	21213023          	sd	s2,512(sp)
    800051de:	ffce                	sd	s3,504(sp)
    800051e0:	fbd2                	sd	s4,496(sp)
    800051e2:	f7d6                	sd	s5,488(sp)
    800051e4:	f3da                	sd	s6,480(sp)
    800051e6:	efde                	sd	s7,472(sp)
    800051e8:	ebe2                	sd	s8,464(sp)
    800051ea:	e7e6                	sd	s9,456(sp)
    800051ec:	e3ea                	sd	s10,448(sp)
    800051ee:	ff6e                	sd	s11,440(sp)
    800051f0:	1400                	addi	s0,sp,544
    800051f2:	892a                	mv	s2,a0
    800051f4:	dea43823          	sd	a0,-528(s0)
    800051f8:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800051fc:	ffffd097          	auipc	ra,0xffffd
    80005200:	83c080e7          	jalr	-1988(ra) # 80001a38 <myproc>
    80005204:	84aa                	mv	s1,a0

  begin_op();
    80005206:	fffff097          	auipc	ra,0xfffff
    8000520a:	458080e7          	jalr	1112(ra) # 8000465e <begin_op>

  if((ip = namei(path)) == 0){
    8000520e:	854a                	mv	a0,s2
    80005210:	fffff097          	auipc	ra,0xfffff
    80005214:	230080e7          	jalr	560(ra) # 80004440 <namei>
    80005218:	c93d                	beqz	a0,8000528e <exec+0xc4>
    8000521a:	892a                	mv	s2,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	a64080e7          	jalr	-1436(ra) # 80003c80 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005224:	04000713          	li	a4,64
    80005228:	4681                	li	a3,0
    8000522a:	e5040613          	addi	a2,s0,-432
    8000522e:	4581                	li	a1,0
    80005230:	854a                	mv	a0,s2
    80005232:	fffff097          	auipc	ra,0xfffff
    80005236:	d04080e7          	jalr	-764(ra) # 80003f36 <readi>
    8000523a:	04000793          	li	a5,64
    8000523e:	00f51a63          	bne	a0,a5,80005252 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80005242:	e5042703          	lw	a4,-432(s0)
    80005246:	464c47b7          	lui	a5,0x464c4
    8000524a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000524e:	04f70663          	beq	a4,a5,8000529a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005252:	854a                	mv	a0,s2
    80005254:	fffff097          	auipc	ra,0xfffff
    80005258:	c90080e7          	jalr	-880(ra) # 80003ee4 <iunlockput>
    end_op();
    8000525c:	fffff097          	auipc	ra,0xfffff
    80005260:	482080e7          	jalr	1154(ra) # 800046de <end_op>
  }
  return -1;
    80005264:	557d                	li	a0,-1
}
    80005266:	21813083          	ld	ra,536(sp)
    8000526a:	21013403          	ld	s0,528(sp)
    8000526e:	20813483          	ld	s1,520(sp)
    80005272:	20013903          	ld	s2,512(sp)
    80005276:	79fe                	ld	s3,504(sp)
    80005278:	7a5e                	ld	s4,496(sp)
    8000527a:	7abe                	ld	s5,488(sp)
    8000527c:	7b1e                	ld	s6,480(sp)
    8000527e:	6bfe                	ld	s7,472(sp)
    80005280:	6c5e                	ld	s8,464(sp)
    80005282:	6cbe                	ld	s9,456(sp)
    80005284:	6d1e                	ld	s10,448(sp)
    80005286:	7dfa                	ld	s11,440(sp)
    80005288:	22010113          	addi	sp,sp,544
    8000528c:	8082                	ret
    end_op();
    8000528e:	fffff097          	auipc	ra,0xfffff
    80005292:	450080e7          	jalr	1104(ra) # 800046de <end_op>
    return -1;
    80005296:	557d                	li	a0,-1
    80005298:	b7f9                	j	80005266 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000529a:	8526                	mv	a0,s1
    8000529c:	ffffd097          	auipc	ra,0xffffd
    800052a0:	862080e7          	jalr	-1950(ra) # 80001afe <proc_pagetable>
    800052a4:	e0a43423          	sd	a0,-504(s0)
    800052a8:	d54d                	beqz	a0,80005252 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052aa:	e7042983          	lw	s3,-400(s0)
    800052ae:	e8845783          	lhu	a5,-376(s0)
    800052b2:	c7ad                	beqz	a5,8000531c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052b4:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052b6:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800052b8:	6c05                	lui	s8,0x1
    800052ba:	fffc0793          	addi	a5,s8,-1 # fff <_entry-0x7ffff001>
    800052be:	def43423          	sd	a5,-536(s0)
    800052c2:	7cfd                	lui	s9,0xfffff
    800052c4:	ac1d                	j	800054fa <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800052c6:	00003517          	auipc	a0,0x3
    800052ca:	54a50513          	addi	a0,a0,1354 # 80008810 <syscalls+0x3a8>
    800052ce:	ffffb097          	auipc	ra,0xffffb
    800052d2:	298080e7          	jalr	664(ra) # 80000566 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800052d6:	8756                	mv	a4,s5
    800052d8:	009d86bb          	addw	a3,s11,s1
    800052dc:	4581                	li	a1,0
    800052de:	854a                	mv	a0,s2
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	c56080e7          	jalr	-938(ra) # 80003f36 <readi>
    800052e8:	2501                	sext.w	a0,a0
    800052ea:	1aaa9e63          	bne	s5,a0,800054a6 <exec+0x2dc>
  for(i = 0; i < sz; i += PGSIZE){
    800052ee:	6785                	lui	a5,0x1
    800052f0:	9cbd                	addw	s1,s1,a5
    800052f2:	014c8a3b          	addw	s4,s9,s4
    800052f6:	1f74f963          	bgeu	s1,s7,800054e8 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    800052fa:	02049593          	slli	a1,s1,0x20
    800052fe:	9181                	srli	a1,a1,0x20
    80005300:	95ea                	add	a1,a1,s10
    80005302:	e0843503          	ld	a0,-504(s0)
    80005306:	ffffc097          	auipc	ra,0xffffc
    8000530a:	dda080e7          	jalr	-550(ra) # 800010e0 <walkaddr>
    8000530e:	862a                	mv	a2,a0
    if(pa == 0)
    80005310:	d95d                	beqz	a0,800052c6 <exec+0xfc>
      n = PGSIZE;
    80005312:	8ae2                	mv	s5,s8
    if(sz - i < PGSIZE)
    80005314:	fd8a71e3          	bgeu	s4,s8,800052d6 <exec+0x10c>
      n = sz - i;
    80005318:	8ad2                	mv	s5,s4
    8000531a:	bf75                	j	800052d6 <exec+0x10c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000531c:	4481                	li	s1,0
  iunlockput(ip);
    8000531e:	854a                	mv	a0,s2
    80005320:	fffff097          	auipc	ra,0xfffff
    80005324:	bc4080e7          	jalr	-1084(ra) # 80003ee4 <iunlockput>
  end_op();
    80005328:	fffff097          	auipc	ra,0xfffff
    8000532c:	3b6080e7          	jalr	950(ra) # 800046de <end_op>
  p = myproc();
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	708080e7          	jalr	1800(ra) # 80001a38 <myproc>
    80005338:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000533a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000533e:	6785                	lui	a5,0x1
    80005340:	17fd                	addi	a5,a5,-1
    80005342:	94be                	add	s1,s1,a5
    80005344:	77fd                	lui	a5,0xfffff
    80005346:	8fe5                	and	a5,a5,s1
    80005348:	e0f43023          	sd	a5,-512(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000534c:	6609                	lui	a2,0x2
    8000534e:	963e                	add	a2,a2,a5
    80005350:	85be                	mv	a1,a5
    80005352:	e0843483          	ld	s1,-504(s0)
    80005356:	8526                	mv	a0,s1
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	13a080e7          	jalr	314(ra) # 80001492 <uvmalloc>
    80005360:	8b2a                	mv	s6,a0
  ip = 0;
    80005362:	4901                	li	s2,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005364:	14050163          	beqz	a0,800054a6 <exec+0x2dc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005368:	75f9                	lui	a1,0xffffe
    8000536a:	95aa                	add	a1,a1,a0
    8000536c:	8526                	mv	a0,s1
    8000536e:	ffffc097          	auipc	ra,0xffffc
    80005372:	342080e7          	jalr	834(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    80005376:	7bfd                	lui	s7,0xfffff
    80005378:	9bda                	add	s7,s7,s6
  for(argc = 0; argv[argc]; argc++) {
    8000537a:	df843783          	ld	a5,-520(s0)
    8000537e:	6388                	ld	a0,0(a5)
    80005380:	c925                	beqz	a0,800053f0 <exec+0x226>
    80005382:	e9040993          	addi	s3,s0,-368
    80005386:	f9040c13          	addi	s8,s0,-112
  sp = sz;
    8000538a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000538c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000538e:	ffffc097          	auipc	ra,0xffffc
    80005392:	b46080e7          	jalr	-1210(ra) # 80000ed4 <strlen>
    80005396:	2505                	addiw	a0,a0,1
    80005398:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000539c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800053a0:	13796863          	bltu	s2,s7,800054d0 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800053a4:	df843c83          	ld	s9,-520(s0)
    800053a8:	000cba03          	ld	s4,0(s9) # fffffffffffff000 <end+0xffffffff7ffd8000>
    800053ac:	8552                	mv	a0,s4
    800053ae:	ffffc097          	auipc	ra,0xffffc
    800053b2:	b26080e7          	jalr	-1242(ra) # 80000ed4 <strlen>
    800053b6:	0015069b          	addiw	a3,a0,1
    800053ba:	8652                	mv	a2,s4
    800053bc:	85ca                	mv	a1,s2
    800053be:	e0843503          	ld	a0,-504(s0)
    800053c2:	ffffc097          	auipc	ra,0xffffc
    800053c6:	320080e7          	jalr	800(ra) # 800016e2 <copyout>
    800053ca:	10054763          	bltz	a0,800054d8 <exec+0x30e>
    ustack[argc] = sp;
    800053ce:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800053d2:	0485                	addi	s1,s1,1
    800053d4:	008c8793          	addi	a5,s9,8
    800053d8:	def43c23          	sd	a5,-520(s0)
    800053dc:	008cb503          	ld	a0,8(s9)
    800053e0:	c911                	beqz	a0,800053f4 <exec+0x22a>
    if(argc >= MAXARG)
    800053e2:	09a1                	addi	s3,s3,8
    800053e4:	fb8995e3          	bne	s3,s8,8000538e <exec+0x1c4>
  sz = sz1;
    800053e8:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    800053ec:	4901                	li	s2,0
    800053ee:	a865                	j	800054a6 <exec+0x2dc>
  sp = sz;
    800053f0:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800053f2:	4481                	li	s1,0
  ustack[argc] = 0;
    800053f4:	00349793          	slli	a5,s1,0x3
    800053f8:	f9040713          	addi	a4,s0,-112
    800053fc:	97ba                	add	a5,a5,a4
    800053fe:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd7f00>
  sp -= (argc+1) * sizeof(uint64);
    80005402:	00148693          	addi	a3,s1,1
    80005406:	068e                	slli	a3,a3,0x3
    80005408:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000540c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005410:	01797663          	bgeu	s2,s7,8000541c <exec+0x252>
  sz = sz1;
    80005414:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80005418:	4901                	li	s2,0
    8000541a:	a071                	j	800054a6 <exec+0x2dc>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000541c:	e9040613          	addi	a2,s0,-368
    80005420:	85ca                	mv	a1,s2
    80005422:	e0843503          	ld	a0,-504(s0)
    80005426:	ffffc097          	auipc	ra,0xffffc
    8000542a:	2bc080e7          	jalr	700(ra) # 800016e2 <copyout>
    8000542e:	0a054963          	bltz	a0,800054e0 <exec+0x316>
  p->trapframe->a1 = sp;
    80005432:	058ab783          	ld	a5,88(s5)
    80005436:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000543a:	df043783          	ld	a5,-528(s0)
    8000543e:	0007c703          	lbu	a4,0(a5)
    80005442:	cf11                	beqz	a4,8000545e <exec+0x294>
    80005444:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005446:	02f00693          	li	a3,47
    8000544a:	a039                	j	80005458 <exec+0x28e>
      last = s+1;
    8000544c:	def43823          	sd	a5,-528(s0)
  for(last=s=path; *s; s++)
    80005450:	0785                	addi	a5,a5,1
    80005452:	fff7c703          	lbu	a4,-1(a5)
    80005456:	c701                	beqz	a4,8000545e <exec+0x294>
    if(*s == '/')
    80005458:	fed71ce3          	bne	a4,a3,80005450 <exec+0x286>
    8000545c:	bfc5                	j	8000544c <exec+0x282>
  safestrcpy(p->name, last, sizeof(p->name));
    8000545e:	4641                	li	a2,16
    80005460:	df043583          	ld	a1,-528(s0)
    80005464:	158a8513          	addi	a0,s5,344
    80005468:	ffffc097          	auipc	ra,0xffffc
    8000546c:	a3a080e7          	jalr	-1478(ra) # 80000ea2 <safestrcpy>
  oldpagetable = p->pagetable;
    80005470:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005474:	e0843783          	ld	a5,-504(s0)
    80005478:	04fab823          	sd	a5,80(s5)
  p->sz = sz;
    8000547c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005480:	058ab783          	ld	a5,88(s5)
    80005484:	e6843703          	ld	a4,-408(s0)
    80005488:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000548a:	058ab783          	ld	a5,88(s5)
    8000548e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005492:	85ea                	mv	a1,s10
    80005494:	ffffc097          	auipc	ra,0xffffc
    80005498:	706080e7          	jalr	1798(ra) # 80001b9a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000549c:	0004851b          	sext.w	a0,s1
    800054a0:	b3d9                	j	80005266 <exec+0x9c>
    800054a2:	e0943023          	sd	s1,-512(s0)
    proc_freepagetable(pagetable, sz);
    800054a6:	e0043583          	ld	a1,-512(s0)
    800054aa:	e0843503          	ld	a0,-504(s0)
    800054ae:	ffffc097          	auipc	ra,0xffffc
    800054b2:	6ec080e7          	jalr	1772(ra) # 80001b9a <proc_freepagetable>
  if(ip){
    800054b6:	d8091ee3          	bnez	s2,80005252 <exec+0x88>
  return -1;
    800054ba:	557d                	li	a0,-1
    800054bc:	b36d                	j	80005266 <exec+0x9c>
    800054be:	e0943023          	sd	s1,-512(s0)
    800054c2:	b7d5                	j	800054a6 <exec+0x2dc>
    800054c4:	e0943023          	sd	s1,-512(s0)
    800054c8:	bff9                	j	800054a6 <exec+0x2dc>
    800054ca:	e0943023          	sd	s1,-512(s0)
    800054ce:	bfe1                	j	800054a6 <exec+0x2dc>
  sz = sz1;
    800054d0:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    800054d4:	4901                	li	s2,0
    800054d6:	bfc1                	j	800054a6 <exec+0x2dc>
  sz = sz1;
    800054d8:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    800054dc:	4901                	li	s2,0
    800054de:	b7e1                	j	800054a6 <exec+0x2dc>
  sz = sz1;
    800054e0:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    800054e4:	4901                	li	s2,0
    800054e6:	b7c1                	j	800054a6 <exec+0x2dc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800054e8:	e0043483          	ld	s1,-512(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054ec:	2b05                	addiw	s6,s6,1
    800054ee:	0389899b          	addiw	s3,s3,56
    800054f2:	e8845783          	lhu	a5,-376(s0)
    800054f6:	e2fb54e3          	bge	s6,a5,8000531e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800054fa:	2981                	sext.w	s3,s3
    800054fc:	03800713          	li	a4,56
    80005500:	86ce                	mv	a3,s3
    80005502:	e1840613          	addi	a2,s0,-488
    80005506:	4581                	li	a1,0
    80005508:	854a                	mv	a0,s2
    8000550a:	fffff097          	auipc	ra,0xfffff
    8000550e:	a2c080e7          	jalr	-1492(ra) # 80003f36 <readi>
    80005512:	03800793          	li	a5,56
    80005516:	f8f516e3          	bne	a0,a5,800054a2 <exec+0x2d8>
    if(ph.type != ELF_PROG_LOAD)
    8000551a:	e1842783          	lw	a5,-488(s0)
    8000551e:	4705                	li	a4,1
    80005520:	fce796e3          	bne	a5,a4,800054ec <exec+0x322>
    if(ph.memsz < ph.filesz)
    80005524:	e4043603          	ld	a2,-448(s0)
    80005528:	e3843783          	ld	a5,-456(s0)
    8000552c:	f8f669e3          	bltu	a2,a5,800054be <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005530:	e2843783          	ld	a5,-472(s0)
    80005534:	963e                	add	a2,a2,a5
    80005536:	f8f667e3          	bltu	a2,a5,800054c4 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000553a:	85a6                	mv	a1,s1
    8000553c:	e0843503          	ld	a0,-504(s0)
    80005540:	ffffc097          	auipc	ra,0xffffc
    80005544:	f52080e7          	jalr	-174(ra) # 80001492 <uvmalloc>
    80005548:	e0a43023          	sd	a0,-512(s0)
    8000554c:	dd3d                	beqz	a0,800054ca <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    8000554e:	e2843d03          	ld	s10,-472(s0)
    80005552:	de843783          	ld	a5,-536(s0)
    80005556:	00fd77b3          	and	a5,s10,a5
    8000555a:	f7b1                	bnez	a5,800054a6 <exec+0x2dc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000555c:	e2042d83          	lw	s11,-480(s0)
    80005560:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005564:	f80b82e3          	beqz	s7,800054e8 <exec+0x31e>
    80005568:	8a5e                	mv	s4,s7
    8000556a:	4481                	li	s1,0
    8000556c:	b379                	j	800052fa <exec+0x130>

000000008000556e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000556e:	7179                	addi	sp,sp,-48
    80005570:	f406                	sd	ra,40(sp)
    80005572:	f022                	sd	s0,32(sp)
    80005574:	ec26                	sd	s1,24(sp)
    80005576:	e84a                	sd	s2,16(sp)
    80005578:	1800                	addi	s0,sp,48
    8000557a:	892e                	mv	s2,a1
    8000557c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000557e:	fdc40593          	addi	a1,s0,-36
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	8ec080e7          	jalr	-1812(ra) # 80002e6e <argint>
    8000558a:	04054063          	bltz	a0,800055ca <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000558e:	fdc42703          	lw	a4,-36(s0)
    80005592:	47bd                	li	a5,15
    80005594:	02e7ed63          	bltu	a5,a4,800055ce <argfd+0x60>
    80005598:	ffffc097          	auipc	ra,0xffffc
    8000559c:	4a0080e7          	jalr	1184(ra) # 80001a38 <myproc>
    800055a0:	fdc42703          	lw	a4,-36(s0)
    800055a4:	01a70793          	addi	a5,a4,26
    800055a8:	078e                	slli	a5,a5,0x3
    800055aa:	953e                	add	a0,a0,a5
    800055ac:	611c                	ld	a5,0(a0)
    800055ae:	c395                	beqz	a5,800055d2 <argfd+0x64>
    return -1;
  if(pfd)
    800055b0:	00090463          	beqz	s2,800055b8 <argfd+0x4a>
    *pfd = fd;
    800055b4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800055b8:	4501                	li	a0,0
  if(pf)
    800055ba:	c091                	beqz	s1,800055be <argfd+0x50>
    *pf = f;
    800055bc:	e09c                	sd	a5,0(s1)
}
    800055be:	70a2                	ld	ra,40(sp)
    800055c0:	7402                	ld	s0,32(sp)
    800055c2:	64e2                	ld	s1,24(sp)
    800055c4:	6942                	ld	s2,16(sp)
    800055c6:	6145                	addi	sp,sp,48
    800055c8:	8082                	ret
    return -1;
    800055ca:	557d                	li	a0,-1
    800055cc:	bfcd                	j	800055be <argfd+0x50>
    return -1;
    800055ce:	557d                	li	a0,-1
    800055d0:	b7fd                	j	800055be <argfd+0x50>
    800055d2:	557d                	li	a0,-1
    800055d4:	b7ed                	j	800055be <argfd+0x50>

00000000800055d6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800055d6:	1101                	addi	sp,sp,-32
    800055d8:	ec06                	sd	ra,24(sp)
    800055da:	e822                	sd	s0,16(sp)
    800055dc:	e426                	sd	s1,8(sp)
    800055de:	1000                	addi	s0,sp,32
    800055e0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	456080e7          	jalr	1110(ra) # 80001a38 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
    800055ea:	697c                	ld	a5,208(a0)
    800055ec:	c395                	beqz	a5,80005610 <fdalloc+0x3a>
    800055ee:	0d850713          	addi	a4,a0,216
  for(fd = 0; fd < NOFILE; fd++){
    800055f2:	4785                	li	a5,1
    800055f4:	4641                	li	a2,16
    if(p->ofile[fd] == 0){
    800055f6:	6314                	ld	a3,0(a4)
    800055f8:	ce89                	beqz	a3,80005612 <fdalloc+0x3c>
  for(fd = 0; fd < NOFILE; fd++){
    800055fa:	2785                	addiw	a5,a5,1
    800055fc:	0721                	addi	a4,a4,8
    800055fe:	fec79ce3          	bne	a5,a2,800055f6 <fdalloc+0x20>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005602:	57fd                	li	a5,-1
}
    80005604:	853e                	mv	a0,a5
    80005606:	60e2                	ld	ra,24(sp)
    80005608:	6442                	ld	s0,16(sp)
    8000560a:	64a2                	ld	s1,8(sp)
    8000560c:	6105                	addi	sp,sp,32
    8000560e:	8082                	ret
  for(fd = 0; fd < NOFILE; fd++){
    80005610:	4781                	li	a5,0
      p->ofile[fd] = f;
    80005612:	01a78713          	addi	a4,a5,26
    80005616:	070e                	slli	a4,a4,0x3
    80005618:	953a                	add	a0,a0,a4
    8000561a:	e104                	sd	s1,0(a0)
      return fd;
    8000561c:	b7e5                	j	80005604 <fdalloc+0x2e>

000000008000561e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000561e:	715d                	addi	sp,sp,-80
    80005620:	e486                	sd	ra,72(sp)
    80005622:	e0a2                	sd	s0,64(sp)
    80005624:	fc26                	sd	s1,56(sp)
    80005626:	f84a                	sd	s2,48(sp)
    80005628:	f44e                	sd	s3,40(sp)
    8000562a:	f052                	sd	s4,32(sp)
    8000562c:	ec56                	sd	s5,24(sp)
    8000562e:	0880                	addi	s0,sp,80
    80005630:	89ae                	mv	s3,a1
    80005632:	8ab2                	mv	s5,a2
    80005634:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005636:	fb040593          	addi	a1,s0,-80
    8000563a:	fffff097          	auipc	ra,0xfffff
    8000563e:	e24080e7          	jalr	-476(ra) # 8000445e <nameiparent>
    80005642:	892a                	mv	s2,a0
    80005644:	12050f63          	beqz	a0,80005782 <create+0x164>
    return 0;

  ilock(dp);
    80005648:	ffffe097          	auipc	ra,0xffffe
    8000564c:	638080e7          	jalr	1592(ra) # 80003c80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005650:	4601                	li	a2,0
    80005652:	fb040593          	addi	a1,s0,-80
    80005656:	854a                	mv	a0,s2
    80005658:	fffff097          	auipc	ra,0xfffff
    8000565c:	b0e080e7          	jalr	-1266(ra) # 80004166 <dirlookup>
    80005660:	84aa                	mv	s1,a0
    80005662:	c921                	beqz	a0,800056b2 <create+0x94>
    iunlockput(dp);
    80005664:	854a                	mv	a0,s2
    80005666:	fffff097          	auipc	ra,0xfffff
    8000566a:	87e080e7          	jalr	-1922(ra) # 80003ee4 <iunlockput>
    ilock(ip);
    8000566e:	8526                	mv	a0,s1
    80005670:	ffffe097          	auipc	ra,0xffffe
    80005674:	610080e7          	jalr	1552(ra) # 80003c80 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005678:	2981                	sext.w	s3,s3
    8000567a:	4789                	li	a5,2
    8000567c:	02f99463          	bne	s3,a5,800056a4 <create+0x86>
    80005680:	0444d783          	lhu	a5,68(s1)
    80005684:	37f9                	addiw	a5,a5,-2
    80005686:	17c2                	slli	a5,a5,0x30
    80005688:	93c1                	srli	a5,a5,0x30
    8000568a:	4705                	li	a4,1
    8000568c:	00f76c63          	bltu	a4,a5,800056a4 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005690:	8526                	mv	a0,s1
    80005692:	60a6                	ld	ra,72(sp)
    80005694:	6406                	ld	s0,64(sp)
    80005696:	74e2                	ld	s1,56(sp)
    80005698:	7942                	ld	s2,48(sp)
    8000569a:	79a2                	ld	s3,40(sp)
    8000569c:	7a02                	ld	s4,32(sp)
    8000569e:	6ae2                	ld	s5,24(sp)
    800056a0:	6161                	addi	sp,sp,80
    800056a2:	8082                	ret
    iunlockput(ip);
    800056a4:	8526                	mv	a0,s1
    800056a6:	fffff097          	auipc	ra,0xfffff
    800056aa:	83e080e7          	jalr	-1986(ra) # 80003ee4 <iunlockput>
    return 0;
    800056ae:	4481                	li	s1,0
    800056b0:	b7c5                	j	80005690 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800056b2:	85ce                	mv	a1,s3
    800056b4:	00092503          	lw	a0,0(s2)
    800056b8:	ffffe097          	auipc	ra,0xffffe
    800056bc:	42c080e7          	jalr	1068(ra) # 80003ae4 <ialloc>
    800056c0:	84aa                	mv	s1,a0
    800056c2:	c529                	beqz	a0,8000570c <create+0xee>
  ilock(ip);
    800056c4:	ffffe097          	auipc	ra,0xffffe
    800056c8:	5bc080e7          	jalr	1468(ra) # 80003c80 <ilock>
  ip->major = major;
    800056cc:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800056d0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800056d4:	4785                	li	a5,1
    800056d6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800056da:	8526                	mv	a0,s1
    800056dc:	ffffe097          	auipc	ra,0xffffe
    800056e0:	4d8080e7          	jalr	1240(ra) # 80003bb4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056e4:	2981                	sext.w	s3,s3
    800056e6:	4785                	li	a5,1
    800056e8:	02f98a63          	beq	s3,a5,8000571c <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800056ec:	40d0                	lw	a2,4(s1)
    800056ee:	fb040593          	addi	a1,s0,-80
    800056f2:	854a                	mv	a0,s2
    800056f4:	fffff097          	auipc	ra,0xfffff
    800056f8:	c8a080e7          	jalr	-886(ra) # 8000437e <dirlink>
    800056fc:	06054b63          	bltz	a0,80005772 <create+0x154>
  iunlockput(dp);
    80005700:	854a                	mv	a0,s2
    80005702:	ffffe097          	auipc	ra,0xffffe
    80005706:	7e2080e7          	jalr	2018(ra) # 80003ee4 <iunlockput>
  return ip;
    8000570a:	b759                	j	80005690 <create+0x72>
    panic("create: ialloc");
    8000570c:	00003517          	auipc	a0,0x3
    80005710:	12450513          	addi	a0,a0,292 # 80008830 <syscalls+0x3c8>
    80005714:	ffffb097          	auipc	ra,0xffffb
    80005718:	e52080e7          	jalr	-430(ra) # 80000566 <panic>
    dp->nlink++;  // for ".."
    8000571c:	04a95783          	lhu	a5,74(s2)
    80005720:	2785                	addiw	a5,a5,1
    80005722:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005726:	854a                	mv	a0,s2
    80005728:	ffffe097          	auipc	ra,0xffffe
    8000572c:	48c080e7          	jalr	1164(ra) # 80003bb4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005730:	40d0                	lw	a2,4(s1)
    80005732:	00003597          	auipc	a1,0x3
    80005736:	10e58593          	addi	a1,a1,270 # 80008840 <syscalls+0x3d8>
    8000573a:	8526                	mv	a0,s1
    8000573c:	fffff097          	auipc	ra,0xfffff
    80005740:	c42080e7          	jalr	-958(ra) # 8000437e <dirlink>
    80005744:	00054f63          	bltz	a0,80005762 <create+0x144>
    80005748:	00492603          	lw	a2,4(s2)
    8000574c:	00003597          	auipc	a1,0x3
    80005750:	0fc58593          	addi	a1,a1,252 # 80008848 <syscalls+0x3e0>
    80005754:	8526                	mv	a0,s1
    80005756:	fffff097          	auipc	ra,0xfffff
    8000575a:	c28080e7          	jalr	-984(ra) # 8000437e <dirlink>
    8000575e:	f80557e3          	bgez	a0,800056ec <create+0xce>
      panic("create dots");
    80005762:	00003517          	auipc	a0,0x3
    80005766:	0ee50513          	addi	a0,a0,238 # 80008850 <syscalls+0x3e8>
    8000576a:	ffffb097          	auipc	ra,0xffffb
    8000576e:	dfc080e7          	jalr	-516(ra) # 80000566 <panic>
    panic("create: dirlink");
    80005772:	00003517          	auipc	a0,0x3
    80005776:	0ee50513          	addi	a0,a0,238 # 80008860 <syscalls+0x3f8>
    8000577a:	ffffb097          	auipc	ra,0xffffb
    8000577e:	dec080e7          	jalr	-532(ra) # 80000566 <panic>
    return 0;
    80005782:	84aa                	mv	s1,a0
    80005784:	b731                	j	80005690 <create+0x72>

0000000080005786 <sys_dup>:
{
    80005786:	7179                	addi	sp,sp,-48
    80005788:	f406                	sd	ra,40(sp)
    8000578a:	f022                	sd	s0,32(sp)
    8000578c:	ec26                	sd	s1,24(sp)
    8000578e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005790:	fd840613          	addi	a2,s0,-40
    80005794:	4581                	li	a1,0
    80005796:	4501                	li	a0,0
    80005798:	00000097          	auipc	ra,0x0
    8000579c:	dd6080e7          	jalr	-554(ra) # 8000556e <argfd>
    return -1;
    800057a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800057a2:	02054363          	bltz	a0,800057c8 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800057a6:	fd843503          	ld	a0,-40(s0)
    800057aa:	00000097          	auipc	ra,0x0
    800057ae:	e2c080e7          	jalr	-468(ra) # 800055d6 <fdalloc>
    800057b2:	84aa                	mv	s1,a0
    return -1;
    800057b4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057b6:	00054963          	bltz	a0,800057c8 <sys_dup+0x42>
  filedup(f);
    800057ba:	fd843503          	ld	a0,-40(s0)
    800057be:	fffff097          	auipc	ra,0xfffff
    800057c2:	348080e7          	jalr	840(ra) # 80004b06 <filedup>
  return fd;
    800057c6:	87a6                	mv	a5,s1
}
    800057c8:	853e                	mv	a0,a5
    800057ca:	70a2                	ld	ra,40(sp)
    800057cc:	7402                	ld	s0,32(sp)
    800057ce:	64e2                	ld	s1,24(sp)
    800057d0:	6145                	addi	sp,sp,48
    800057d2:	8082                	ret

00000000800057d4 <sys_read>:
{
    800057d4:	7179                	addi	sp,sp,-48
    800057d6:	f406                	sd	ra,40(sp)
    800057d8:	f022                	sd	s0,32(sp)
    800057da:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057dc:	fe840613          	addi	a2,s0,-24
    800057e0:	4581                	li	a1,0
    800057e2:	4501                	li	a0,0
    800057e4:	00000097          	auipc	ra,0x0
    800057e8:	d8a080e7          	jalr	-630(ra) # 8000556e <argfd>
    return -1;
    800057ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800057ee:	04054163          	bltz	a0,80005830 <sys_read+0x5c>
    800057f2:	fe440593          	addi	a1,s0,-28
    800057f6:	4509                	li	a0,2
    800057f8:	ffffd097          	auipc	ra,0xffffd
    800057fc:	676080e7          	jalr	1654(ra) # 80002e6e <argint>
    return -1;
    80005800:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005802:	02054763          	bltz	a0,80005830 <sys_read+0x5c>
    80005806:	fd840593          	addi	a1,s0,-40
    8000580a:	4505                	li	a0,1
    8000580c:	ffffd097          	auipc	ra,0xffffd
    80005810:	684080e7          	jalr	1668(ra) # 80002e90 <argaddr>
    return -1;
    80005814:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005816:	00054d63          	bltz	a0,80005830 <sys_read+0x5c>
  return fileread(f, p, n);
    8000581a:	fe442603          	lw	a2,-28(s0)
    8000581e:	fd843583          	ld	a1,-40(s0)
    80005822:	fe843503          	ld	a0,-24(s0)
    80005826:	fffff097          	auipc	ra,0xfffff
    8000582a:	46c080e7          	jalr	1132(ra) # 80004c92 <fileread>
    8000582e:	87aa                	mv	a5,a0
}
    80005830:	853e                	mv	a0,a5
    80005832:	70a2                	ld	ra,40(sp)
    80005834:	7402                	ld	s0,32(sp)
    80005836:	6145                	addi	sp,sp,48
    80005838:	8082                	ret

000000008000583a <sys_write>:
{
    8000583a:	7179                	addi	sp,sp,-48
    8000583c:	f406                	sd	ra,40(sp)
    8000583e:	f022                	sd	s0,32(sp)
    80005840:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005842:	fe840613          	addi	a2,s0,-24
    80005846:	4581                	li	a1,0
    80005848:	4501                	li	a0,0
    8000584a:	00000097          	auipc	ra,0x0
    8000584e:	d24080e7          	jalr	-732(ra) # 8000556e <argfd>
    return -1;
    80005852:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005854:	04054163          	bltz	a0,80005896 <sys_write+0x5c>
    80005858:	fe440593          	addi	a1,s0,-28
    8000585c:	4509                	li	a0,2
    8000585e:	ffffd097          	auipc	ra,0xffffd
    80005862:	610080e7          	jalr	1552(ra) # 80002e6e <argint>
    return -1;
    80005866:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005868:	02054763          	bltz	a0,80005896 <sys_write+0x5c>
    8000586c:	fd840593          	addi	a1,s0,-40
    80005870:	4505                	li	a0,1
    80005872:	ffffd097          	auipc	ra,0xffffd
    80005876:	61e080e7          	jalr	1566(ra) # 80002e90 <argaddr>
    return -1;
    8000587a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000587c:	00054d63          	bltz	a0,80005896 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005880:	fe442603          	lw	a2,-28(s0)
    80005884:	fd843583          	ld	a1,-40(s0)
    80005888:	fe843503          	ld	a0,-24(s0)
    8000588c:	fffff097          	auipc	ra,0xfffff
    80005890:	4c8080e7          	jalr	1224(ra) # 80004d54 <filewrite>
    80005894:	87aa                	mv	a5,a0
}
    80005896:	853e                	mv	a0,a5
    80005898:	70a2                	ld	ra,40(sp)
    8000589a:	7402                	ld	s0,32(sp)
    8000589c:	6145                	addi	sp,sp,48
    8000589e:	8082                	ret

00000000800058a0 <sys_close>:
{
    800058a0:	1101                	addi	sp,sp,-32
    800058a2:	ec06                	sd	ra,24(sp)
    800058a4:	e822                	sd	s0,16(sp)
    800058a6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800058a8:	fe040613          	addi	a2,s0,-32
    800058ac:	fec40593          	addi	a1,s0,-20
    800058b0:	4501                	li	a0,0
    800058b2:	00000097          	auipc	ra,0x0
    800058b6:	cbc080e7          	jalr	-836(ra) # 8000556e <argfd>
    return -1;
    800058ba:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800058bc:	02054463          	bltz	a0,800058e4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800058c0:	ffffc097          	auipc	ra,0xffffc
    800058c4:	178080e7          	jalr	376(ra) # 80001a38 <myproc>
    800058c8:	fec42783          	lw	a5,-20(s0)
    800058cc:	07e9                	addi	a5,a5,26
    800058ce:	078e                	slli	a5,a5,0x3
    800058d0:	953e                	add	a0,a0,a5
    800058d2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800058d6:	fe043503          	ld	a0,-32(s0)
    800058da:	fffff097          	auipc	ra,0xfffff
    800058de:	27e080e7          	jalr	638(ra) # 80004b58 <fileclose>
  return 0;
    800058e2:	4781                	li	a5,0
}
    800058e4:	853e                	mv	a0,a5
    800058e6:	60e2                	ld	ra,24(sp)
    800058e8:	6442                	ld	s0,16(sp)
    800058ea:	6105                	addi	sp,sp,32
    800058ec:	8082                	ret

00000000800058ee <sys_fstat>:
{
    800058ee:	1101                	addi	sp,sp,-32
    800058f0:	ec06                	sd	ra,24(sp)
    800058f2:	e822                	sd	s0,16(sp)
    800058f4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800058f6:	fe840613          	addi	a2,s0,-24
    800058fa:	4581                	li	a1,0
    800058fc:	4501                	li	a0,0
    800058fe:	00000097          	auipc	ra,0x0
    80005902:	c70080e7          	jalr	-912(ra) # 8000556e <argfd>
    return -1;
    80005906:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005908:	02054563          	bltz	a0,80005932 <sys_fstat+0x44>
    8000590c:	fe040593          	addi	a1,s0,-32
    80005910:	4505                	li	a0,1
    80005912:	ffffd097          	auipc	ra,0xffffd
    80005916:	57e080e7          	jalr	1406(ra) # 80002e90 <argaddr>
    return -1;
    8000591a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000591c:	00054b63          	bltz	a0,80005932 <sys_fstat+0x44>
  return filestat(f, st);
    80005920:	fe043583          	ld	a1,-32(s0)
    80005924:	fe843503          	ld	a0,-24(s0)
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	2f8080e7          	jalr	760(ra) # 80004c20 <filestat>
    80005930:	87aa                	mv	a5,a0
}
    80005932:	853e                	mv	a0,a5
    80005934:	60e2                	ld	ra,24(sp)
    80005936:	6442                	ld	s0,16(sp)
    80005938:	6105                	addi	sp,sp,32
    8000593a:	8082                	ret

000000008000593c <sys_link>:
{
    8000593c:	7169                	addi	sp,sp,-304
    8000593e:	f606                	sd	ra,296(sp)
    80005940:	f222                	sd	s0,288(sp)
    80005942:	ee26                	sd	s1,280(sp)
    80005944:	ea4a                	sd	s2,272(sp)
    80005946:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005948:	08000613          	li	a2,128
    8000594c:	ed040593          	addi	a1,s0,-304
    80005950:	4501                	li	a0,0
    80005952:	ffffd097          	auipc	ra,0xffffd
    80005956:	560080e7          	jalr	1376(ra) # 80002eb2 <argstr>
    return -1;
    8000595a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000595c:	10054e63          	bltz	a0,80005a78 <sys_link+0x13c>
    80005960:	08000613          	li	a2,128
    80005964:	f5040593          	addi	a1,s0,-176
    80005968:	4505                	li	a0,1
    8000596a:	ffffd097          	auipc	ra,0xffffd
    8000596e:	548080e7          	jalr	1352(ra) # 80002eb2 <argstr>
    return -1;
    80005972:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005974:	10054263          	bltz	a0,80005a78 <sys_link+0x13c>
  begin_op();
    80005978:	fffff097          	auipc	ra,0xfffff
    8000597c:	ce6080e7          	jalr	-794(ra) # 8000465e <begin_op>
  if((ip = namei(old)) == 0){
    80005980:	ed040513          	addi	a0,s0,-304
    80005984:	fffff097          	auipc	ra,0xfffff
    80005988:	abc080e7          	jalr	-1348(ra) # 80004440 <namei>
    8000598c:	84aa                	mv	s1,a0
    8000598e:	c551                	beqz	a0,80005a1a <sys_link+0xde>
  ilock(ip);
    80005990:	ffffe097          	auipc	ra,0xffffe
    80005994:	2f0080e7          	jalr	752(ra) # 80003c80 <ilock>
  if(ip->type == T_DIR){
    80005998:	04449703          	lh	a4,68(s1)
    8000599c:	4785                	li	a5,1
    8000599e:	08f70463          	beq	a4,a5,80005a26 <sys_link+0xea>
  ip->nlink++;
    800059a2:	04a4d783          	lhu	a5,74(s1)
    800059a6:	2785                	addiw	a5,a5,1
    800059a8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059ac:	8526                	mv	a0,s1
    800059ae:	ffffe097          	auipc	ra,0xffffe
    800059b2:	206080e7          	jalr	518(ra) # 80003bb4 <iupdate>
  iunlock(ip);
    800059b6:	8526                	mv	a0,s1
    800059b8:	ffffe097          	auipc	ra,0xffffe
    800059bc:	38c080e7          	jalr	908(ra) # 80003d44 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800059c0:	fd040593          	addi	a1,s0,-48
    800059c4:	f5040513          	addi	a0,s0,-176
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	a96080e7          	jalr	-1386(ra) # 8000445e <nameiparent>
    800059d0:	892a                	mv	s2,a0
    800059d2:	c935                	beqz	a0,80005a46 <sys_link+0x10a>
  ilock(dp);
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	2ac080e7          	jalr	684(ra) # 80003c80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059dc:	00092703          	lw	a4,0(s2)
    800059e0:	409c                	lw	a5,0(s1)
    800059e2:	04f71d63          	bne	a4,a5,80005a3c <sys_link+0x100>
    800059e6:	40d0                	lw	a2,4(s1)
    800059e8:	fd040593          	addi	a1,s0,-48
    800059ec:	854a                	mv	a0,s2
    800059ee:	fffff097          	auipc	ra,0xfffff
    800059f2:	990080e7          	jalr	-1648(ra) # 8000437e <dirlink>
    800059f6:	04054363          	bltz	a0,80005a3c <sys_link+0x100>
  iunlockput(dp);
    800059fa:	854a                	mv	a0,s2
    800059fc:	ffffe097          	auipc	ra,0xffffe
    80005a00:	4e8080e7          	jalr	1256(ra) # 80003ee4 <iunlockput>
  iput(ip);
    80005a04:	8526                	mv	a0,s1
    80005a06:	ffffe097          	auipc	ra,0xffffe
    80005a0a:	436080e7          	jalr	1078(ra) # 80003e3c <iput>
  end_op();
    80005a0e:	fffff097          	auipc	ra,0xfffff
    80005a12:	cd0080e7          	jalr	-816(ra) # 800046de <end_op>
  return 0;
    80005a16:	4781                	li	a5,0
    80005a18:	a085                	j	80005a78 <sys_link+0x13c>
    end_op();
    80005a1a:	fffff097          	auipc	ra,0xfffff
    80005a1e:	cc4080e7          	jalr	-828(ra) # 800046de <end_op>
    return -1;
    80005a22:	57fd                	li	a5,-1
    80005a24:	a891                	j	80005a78 <sys_link+0x13c>
    iunlockput(ip);
    80005a26:	8526                	mv	a0,s1
    80005a28:	ffffe097          	auipc	ra,0xffffe
    80005a2c:	4bc080e7          	jalr	1212(ra) # 80003ee4 <iunlockput>
    end_op();
    80005a30:	fffff097          	auipc	ra,0xfffff
    80005a34:	cae080e7          	jalr	-850(ra) # 800046de <end_op>
    return -1;
    80005a38:	57fd                	li	a5,-1
    80005a3a:	a83d                	j	80005a78 <sys_link+0x13c>
    iunlockput(dp);
    80005a3c:	854a                	mv	a0,s2
    80005a3e:	ffffe097          	auipc	ra,0xffffe
    80005a42:	4a6080e7          	jalr	1190(ra) # 80003ee4 <iunlockput>
  ilock(ip);
    80005a46:	8526                	mv	a0,s1
    80005a48:	ffffe097          	auipc	ra,0xffffe
    80005a4c:	238080e7          	jalr	568(ra) # 80003c80 <ilock>
  ip->nlink--;
    80005a50:	04a4d783          	lhu	a5,74(s1)
    80005a54:	37fd                	addiw	a5,a5,-1
    80005a56:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a5a:	8526                	mv	a0,s1
    80005a5c:	ffffe097          	auipc	ra,0xffffe
    80005a60:	158080e7          	jalr	344(ra) # 80003bb4 <iupdate>
  iunlockput(ip);
    80005a64:	8526                	mv	a0,s1
    80005a66:	ffffe097          	auipc	ra,0xffffe
    80005a6a:	47e080e7          	jalr	1150(ra) # 80003ee4 <iunlockput>
  end_op();
    80005a6e:	fffff097          	auipc	ra,0xfffff
    80005a72:	c70080e7          	jalr	-912(ra) # 800046de <end_op>
  return -1;
    80005a76:	57fd                	li	a5,-1
}
    80005a78:	853e                	mv	a0,a5
    80005a7a:	70b2                	ld	ra,296(sp)
    80005a7c:	7412                	ld	s0,288(sp)
    80005a7e:	64f2                	ld	s1,280(sp)
    80005a80:	6952                	ld	s2,272(sp)
    80005a82:	6155                	addi	sp,sp,304
    80005a84:	8082                	ret

0000000080005a86 <sys_unlink>:
{
    80005a86:	7151                	addi	sp,sp,-240
    80005a88:	f586                	sd	ra,232(sp)
    80005a8a:	f1a2                	sd	s0,224(sp)
    80005a8c:	eda6                	sd	s1,216(sp)
    80005a8e:	e9ca                	sd	s2,208(sp)
    80005a90:	e5ce                	sd	s3,200(sp)
    80005a92:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005a94:	08000613          	li	a2,128
    80005a98:	f3040593          	addi	a1,s0,-208
    80005a9c:	4501                	li	a0,0
    80005a9e:	ffffd097          	auipc	ra,0xffffd
    80005aa2:	414080e7          	jalr	1044(ra) # 80002eb2 <argstr>
    80005aa6:	16054f63          	bltz	a0,80005c24 <sys_unlink+0x19e>
  begin_op();
    80005aaa:	fffff097          	auipc	ra,0xfffff
    80005aae:	bb4080e7          	jalr	-1100(ra) # 8000465e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005ab2:	fb040593          	addi	a1,s0,-80
    80005ab6:	f3040513          	addi	a0,s0,-208
    80005aba:	fffff097          	auipc	ra,0xfffff
    80005abe:	9a4080e7          	jalr	-1628(ra) # 8000445e <nameiparent>
    80005ac2:	89aa                	mv	s3,a0
    80005ac4:	c979                	beqz	a0,80005b9a <sys_unlink+0x114>
  ilock(dp);
    80005ac6:	ffffe097          	auipc	ra,0xffffe
    80005aca:	1ba080e7          	jalr	442(ra) # 80003c80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ace:	00003597          	auipc	a1,0x3
    80005ad2:	d7258593          	addi	a1,a1,-654 # 80008840 <syscalls+0x3d8>
    80005ad6:	fb040513          	addi	a0,s0,-80
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	672080e7          	jalr	1650(ra) # 8000414c <namecmp>
    80005ae2:	14050863          	beqz	a0,80005c32 <sys_unlink+0x1ac>
    80005ae6:	00003597          	auipc	a1,0x3
    80005aea:	d6258593          	addi	a1,a1,-670 # 80008848 <syscalls+0x3e0>
    80005aee:	fb040513          	addi	a0,s0,-80
    80005af2:	ffffe097          	auipc	ra,0xffffe
    80005af6:	65a080e7          	jalr	1626(ra) # 8000414c <namecmp>
    80005afa:	12050c63          	beqz	a0,80005c32 <sys_unlink+0x1ac>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005afe:	f2c40613          	addi	a2,s0,-212
    80005b02:	fb040593          	addi	a1,s0,-80
    80005b06:	854e                	mv	a0,s3
    80005b08:	ffffe097          	auipc	ra,0xffffe
    80005b0c:	65e080e7          	jalr	1630(ra) # 80004166 <dirlookup>
    80005b10:	84aa                	mv	s1,a0
    80005b12:	12050063          	beqz	a0,80005c32 <sys_unlink+0x1ac>
  ilock(ip);
    80005b16:	ffffe097          	auipc	ra,0xffffe
    80005b1a:	16a080e7          	jalr	362(ra) # 80003c80 <ilock>
  if(ip->nlink < 1)
    80005b1e:	04a49783          	lh	a5,74(s1)
    80005b22:	08f05263          	blez	a5,80005ba6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b26:	04449703          	lh	a4,68(s1)
    80005b2a:	4785                	li	a5,1
    80005b2c:	08f70563          	beq	a4,a5,80005bb6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005b30:	4641                	li	a2,16
    80005b32:	4581                	li	a1,0
    80005b34:	fc040513          	addi	a0,s0,-64
    80005b38:	ffffb097          	auipc	ra,0xffffb
    80005b3c:	1f6080e7          	jalr	502(ra) # 80000d2e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b40:	4741                	li	a4,16
    80005b42:	f2c42683          	lw	a3,-212(s0)
    80005b46:	fc040613          	addi	a2,s0,-64
    80005b4a:	4581                	li	a1,0
    80005b4c:	854e                	mv	a0,s3
    80005b4e:	ffffe097          	auipc	ra,0xffffe
    80005b52:	4e0080e7          	jalr	1248(ra) # 8000402e <writei>
    80005b56:	47c1                	li	a5,16
    80005b58:	0af51363          	bne	a0,a5,80005bfe <sys_unlink+0x178>
  if(ip->type == T_DIR){
    80005b5c:	04449703          	lh	a4,68(s1)
    80005b60:	4785                	li	a5,1
    80005b62:	0af70663          	beq	a4,a5,80005c0e <sys_unlink+0x188>
  iunlockput(dp);
    80005b66:	854e                	mv	a0,s3
    80005b68:	ffffe097          	auipc	ra,0xffffe
    80005b6c:	37c080e7          	jalr	892(ra) # 80003ee4 <iunlockput>
  ip->nlink--;
    80005b70:	04a4d783          	lhu	a5,74(s1)
    80005b74:	37fd                	addiw	a5,a5,-1
    80005b76:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b7a:	8526                	mv	a0,s1
    80005b7c:	ffffe097          	auipc	ra,0xffffe
    80005b80:	038080e7          	jalr	56(ra) # 80003bb4 <iupdate>
  iunlockput(ip);
    80005b84:	8526                	mv	a0,s1
    80005b86:	ffffe097          	auipc	ra,0xffffe
    80005b8a:	35e080e7          	jalr	862(ra) # 80003ee4 <iunlockput>
  end_op();
    80005b8e:	fffff097          	auipc	ra,0xfffff
    80005b92:	b50080e7          	jalr	-1200(ra) # 800046de <end_op>
  return 0;
    80005b96:	4501                	li	a0,0
    80005b98:	a07d                	j	80005c46 <sys_unlink+0x1c0>
    end_op();
    80005b9a:	fffff097          	auipc	ra,0xfffff
    80005b9e:	b44080e7          	jalr	-1212(ra) # 800046de <end_op>
    return -1;
    80005ba2:	557d                	li	a0,-1
    80005ba4:	a04d                	j	80005c46 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005ba6:	00003517          	auipc	a0,0x3
    80005baa:	cca50513          	addi	a0,a0,-822 # 80008870 <syscalls+0x408>
    80005bae:	ffffb097          	auipc	ra,0xffffb
    80005bb2:	9b8080e7          	jalr	-1608(ra) # 80000566 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bb6:	44f8                	lw	a4,76(s1)
    80005bb8:	02000793          	li	a5,32
    80005bbc:	f6e7fae3          	bgeu	a5,a4,80005b30 <sys_unlink+0xaa>
    80005bc0:	02000913          	li	s2,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bc4:	4741                	li	a4,16
    80005bc6:	86ca                	mv	a3,s2
    80005bc8:	f1840613          	addi	a2,s0,-232
    80005bcc:	4581                	li	a1,0
    80005bce:	8526                	mv	a0,s1
    80005bd0:	ffffe097          	auipc	ra,0xffffe
    80005bd4:	366080e7          	jalr	870(ra) # 80003f36 <readi>
    80005bd8:	47c1                	li	a5,16
    80005bda:	00f51a63          	bne	a0,a5,80005bee <sys_unlink+0x168>
    if(de.inum != 0)
    80005bde:	f1845783          	lhu	a5,-232(s0)
    80005be2:	e3b9                	bnez	a5,80005c28 <sys_unlink+0x1a2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005be4:	2941                	addiw	s2,s2,16
    80005be6:	44fc                	lw	a5,76(s1)
    80005be8:	fcf96ee3          	bltu	s2,a5,80005bc4 <sys_unlink+0x13e>
    80005bec:	b791                	j	80005b30 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005bee:	00003517          	auipc	a0,0x3
    80005bf2:	c9a50513          	addi	a0,a0,-870 # 80008888 <syscalls+0x420>
    80005bf6:	ffffb097          	auipc	ra,0xffffb
    80005bfa:	970080e7          	jalr	-1680(ra) # 80000566 <panic>
    panic("unlink: writei");
    80005bfe:	00003517          	auipc	a0,0x3
    80005c02:	ca250513          	addi	a0,a0,-862 # 800088a0 <syscalls+0x438>
    80005c06:	ffffb097          	auipc	ra,0xffffb
    80005c0a:	960080e7          	jalr	-1696(ra) # 80000566 <panic>
    dp->nlink--;
    80005c0e:	04a9d783          	lhu	a5,74(s3)
    80005c12:	37fd                	addiw	a5,a5,-1
    80005c14:	04f99523          	sh	a5,74(s3)
    iupdate(dp);
    80005c18:	854e                	mv	a0,s3
    80005c1a:	ffffe097          	auipc	ra,0xffffe
    80005c1e:	f9a080e7          	jalr	-102(ra) # 80003bb4 <iupdate>
    80005c22:	b791                	j	80005b66 <sys_unlink+0xe0>
    return -1;
    80005c24:	557d                	li	a0,-1
    80005c26:	a005                	j	80005c46 <sys_unlink+0x1c0>
    iunlockput(ip);
    80005c28:	8526                	mv	a0,s1
    80005c2a:	ffffe097          	auipc	ra,0xffffe
    80005c2e:	2ba080e7          	jalr	698(ra) # 80003ee4 <iunlockput>
  iunlockput(dp);
    80005c32:	854e                	mv	a0,s3
    80005c34:	ffffe097          	auipc	ra,0xffffe
    80005c38:	2b0080e7          	jalr	688(ra) # 80003ee4 <iunlockput>
  end_op();
    80005c3c:	fffff097          	auipc	ra,0xfffff
    80005c40:	aa2080e7          	jalr	-1374(ra) # 800046de <end_op>
  return -1;
    80005c44:	557d                	li	a0,-1
}
    80005c46:	70ae                	ld	ra,232(sp)
    80005c48:	740e                	ld	s0,224(sp)
    80005c4a:	64ee                	ld	s1,216(sp)
    80005c4c:	694e                	ld	s2,208(sp)
    80005c4e:	69ae                	ld	s3,200(sp)
    80005c50:	616d                	addi	sp,sp,240
    80005c52:	8082                	ret

0000000080005c54 <sys_open>:

uint64
sys_open(void)
{
    80005c54:	7131                	addi	sp,sp,-192
    80005c56:	fd06                	sd	ra,184(sp)
    80005c58:	f922                	sd	s0,176(sp)
    80005c5a:	f526                	sd	s1,168(sp)
    80005c5c:	f14a                	sd	s2,160(sp)
    80005c5e:	ed4e                	sd	s3,152(sp)
    80005c60:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005c62:	08000613          	li	a2,128
    80005c66:	f5040593          	addi	a1,s0,-176
    80005c6a:	4501                	li	a0,0
    80005c6c:	ffffd097          	auipc	ra,0xffffd
    80005c70:	246080e7          	jalr	582(ra) # 80002eb2 <argstr>
    return -1;
    80005c74:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005c76:	0c054163          	bltz	a0,80005d38 <sys_open+0xe4>
    80005c7a:	f4c40593          	addi	a1,s0,-180
    80005c7e:	4505                	li	a0,1
    80005c80:	ffffd097          	auipc	ra,0xffffd
    80005c84:	1ee080e7          	jalr	494(ra) # 80002e6e <argint>
    80005c88:	0a054863          	bltz	a0,80005d38 <sys_open+0xe4>

  begin_op();
    80005c8c:	fffff097          	auipc	ra,0xfffff
    80005c90:	9d2080e7          	jalr	-1582(ra) # 8000465e <begin_op>

  if(omode & O_CREATE){
    80005c94:	f4c42783          	lw	a5,-180(s0)
    80005c98:	2007f793          	andi	a5,a5,512
    80005c9c:	cbdd                	beqz	a5,80005d52 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005c9e:	4681                	li	a3,0
    80005ca0:	4601                	li	a2,0
    80005ca2:	4589                	li	a1,2
    80005ca4:	f5040513          	addi	a0,s0,-176
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	976080e7          	jalr	-1674(ra) # 8000561e <create>
    80005cb0:	892a                	mv	s2,a0
    if(ip == 0){
    80005cb2:	c959                	beqz	a0,80005d48 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005cb4:	04491703          	lh	a4,68(s2)
    80005cb8:	478d                	li	a5,3
    80005cba:	00f71763          	bne	a4,a5,80005cc8 <sys_open+0x74>
    80005cbe:	04695703          	lhu	a4,70(s2)
    80005cc2:	47a5                	li	a5,9
    80005cc4:	0ce7ec63          	bltu	a5,a4,80005d9c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005cc8:	fffff097          	auipc	ra,0xfffff
    80005ccc:	dc0080e7          	jalr	-576(ra) # 80004a88 <filealloc>
    80005cd0:	89aa                	mv	s3,a0
    80005cd2:	10050263          	beqz	a0,80005dd6 <sys_open+0x182>
    80005cd6:	00000097          	auipc	ra,0x0
    80005cda:	900080e7          	jalr	-1792(ra) # 800055d6 <fdalloc>
    80005cde:	84aa                	mv	s1,a0
    80005ce0:	0e054663          	bltz	a0,80005dcc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005ce4:	04491703          	lh	a4,68(s2)
    80005ce8:	478d                	li	a5,3
    80005cea:	0cf70463          	beq	a4,a5,80005db2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005cee:	4789                	li	a5,2
    80005cf0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005cf4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005cf8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005cfc:	f4c42783          	lw	a5,-180(s0)
    80005d00:	0017c713          	xori	a4,a5,1
    80005d04:	8b05                	andi	a4,a4,1
    80005d06:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d0a:	0037f713          	andi	a4,a5,3
    80005d0e:	00e03733          	snez	a4,a4
    80005d12:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005d16:	4007f793          	andi	a5,a5,1024
    80005d1a:	c791                	beqz	a5,80005d26 <sys_open+0xd2>
    80005d1c:	04491703          	lh	a4,68(s2)
    80005d20:	4789                	li	a5,2
    80005d22:	08f70f63          	beq	a4,a5,80005dc0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005d26:	854a                	mv	a0,s2
    80005d28:	ffffe097          	auipc	ra,0xffffe
    80005d2c:	01c080e7          	jalr	28(ra) # 80003d44 <iunlock>
  end_op();
    80005d30:	fffff097          	auipc	ra,0xfffff
    80005d34:	9ae080e7          	jalr	-1618(ra) # 800046de <end_op>

  return fd;
}
    80005d38:	8526                	mv	a0,s1
    80005d3a:	70ea                	ld	ra,184(sp)
    80005d3c:	744a                	ld	s0,176(sp)
    80005d3e:	74aa                	ld	s1,168(sp)
    80005d40:	790a                	ld	s2,160(sp)
    80005d42:	69ea                	ld	s3,152(sp)
    80005d44:	6129                	addi	sp,sp,192
    80005d46:	8082                	ret
      end_op();
    80005d48:	fffff097          	auipc	ra,0xfffff
    80005d4c:	996080e7          	jalr	-1642(ra) # 800046de <end_op>
      return -1;
    80005d50:	b7e5                	j	80005d38 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005d52:	f5040513          	addi	a0,s0,-176
    80005d56:	ffffe097          	auipc	ra,0xffffe
    80005d5a:	6ea080e7          	jalr	1770(ra) # 80004440 <namei>
    80005d5e:	892a                	mv	s2,a0
    80005d60:	c905                	beqz	a0,80005d90 <sys_open+0x13c>
    ilock(ip);
    80005d62:	ffffe097          	auipc	ra,0xffffe
    80005d66:	f1e080e7          	jalr	-226(ra) # 80003c80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005d6a:	04491703          	lh	a4,68(s2)
    80005d6e:	4785                	li	a5,1
    80005d70:	f4f712e3          	bne	a4,a5,80005cb4 <sys_open+0x60>
    80005d74:	f4c42783          	lw	a5,-180(s0)
    80005d78:	dba1                	beqz	a5,80005cc8 <sys_open+0x74>
      iunlockput(ip);
    80005d7a:	854a                	mv	a0,s2
    80005d7c:	ffffe097          	auipc	ra,0xffffe
    80005d80:	168080e7          	jalr	360(ra) # 80003ee4 <iunlockput>
      end_op();
    80005d84:	fffff097          	auipc	ra,0xfffff
    80005d88:	95a080e7          	jalr	-1702(ra) # 800046de <end_op>
      return -1;
    80005d8c:	54fd                	li	s1,-1
    80005d8e:	b76d                	j	80005d38 <sys_open+0xe4>
      end_op();
    80005d90:	fffff097          	auipc	ra,0xfffff
    80005d94:	94e080e7          	jalr	-1714(ra) # 800046de <end_op>
      return -1;
    80005d98:	54fd                	li	s1,-1
    80005d9a:	bf79                	j	80005d38 <sys_open+0xe4>
    iunlockput(ip);
    80005d9c:	854a                	mv	a0,s2
    80005d9e:	ffffe097          	auipc	ra,0xffffe
    80005da2:	146080e7          	jalr	326(ra) # 80003ee4 <iunlockput>
    end_op();
    80005da6:	fffff097          	auipc	ra,0xfffff
    80005daa:	938080e7          	jalr	-1736(ra) # 800046de <end_op>
    return -1;
    80005dae:	54fd                	li	s1,-1
    80005db0:	b761                	j	80005d38 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005db2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005db6:	04691783          	lh	a5,70(s2)
    80005dba:	02f99223          	sh	a5,36(s3)
    80005dbe:	bf2d                	j	80005cf8 <sys_open+0xa4>
    itrunc(ip);
    80005dc0:	854a                	mv	a0,s2
    80005dc2:	ffffe097          	auipc	ra,0xffffe
    80005dc6:	fce080e7          	jalr	-50(ra) # 80003d90 <itrunc>
    80005dca:	bfb1                	j	80005d26 <sys_open+0xd2>
      fileclose(f);
    80005dcc:	854e                	mv	a0,s3
    80005dce:	fffff097          	auipc	ra,0xfffff
    80005dd2:	d8a080e7          	jalr	-630(ra) # 80004b58 <fileclose>
    iunlockput(ip);
    80005dd6:	854a                	mv	a0,s2
    80005dd8:	ffffe097          	auipc	ra,0xffffe
    80005ddc:	10c080e7          	jalr	268(ra) # 80003ee4 <iunlockput>
    end_op();
    80005de0:	fffff097          	auipc	ra,0xfffff
    80005de4:	8fe080e7          	jalr	-1794(ra) # 800046de <end_op>
    return -1;
    80005de8:	54fd                	li	s1,-1
    80005dea:	b7b9                	j	80005d38 <sys_open+0xe4>

0000000080005dec <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005dec:	7175                	addi	sp,sp,-144
    80005dee:	e506                	sd	ra,136(sp)
    80005df0:	e122                	sd	s0,128(sp)
    80005df2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005df4:	fffff097          	auipc	ra,0xfffff
    80005df8:	86a080e7          	jalr	-1942(ra) # 8000465e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005dfc:	08000613          	li	a2,128
    80005e00:	f7040593          	addi	a1,s0,-144
    80005e04:	4501                	li	a0,0
    80005e06:	ffffd097          	auipc	ra,0xffffd
    80005e0a:	0ac080e7          	jalr	172(ra) # 80002eb2 <argstr>
    80005e0e:	02054963          	bltz	a0,80005e40 <sys_mkdir+0x54>
    80005e12:	4681                	li	a3,0
    80005e14:	4601                	li	a2,0
    80005e16:	4585                	li	a1,1
    80005e18:	f7040513          	addi	a0,s0,-144
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	802080e7          	jalr	-2046(ra) # 8000561e <create>
    80005e24:	cd11                	beqz	a0,80005e40 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e26:	ffffe097          	auipc	ra,0xffffe
    80005e2a:	0be080e7          	jalr	190(ra) # 80003ee4 <iunlockput>
  end_op();
    80005e2e:	fffff097          	auipc	ra,0xfffff
    80005e32:	8b0080e7          	jalr	-1872(ra) # 800046de <end_op>
  return 0;
    80005e36:	4501                	li	a0,0
}
    80005e38:	60aa                	ld	ra,136(sp)
    80005e3a:	640a                	ld	s0,128(sp)
    80005e3c:	6149                	addi	sp,sp,144
    80005e3e:	8082                	ret
    end_op();
    80005e40:	fffff097          	auipc	ra,0xfffff
    80005e44:	89e080e7          	jalr	-1890(ra) # 800046de <end_op>
    return -1;
    80005e48:	557d                	li	a0,-1
    80005e4a:	b7fd                	j	80005e38 <sys_mkdir+0x4c>

0000000080005e4c <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e4c:	7135                	addi	sp,sp,-160
    80005e4e:	ed06                	sd	ra,152(sp)
    80005e50:	e922                	sd	s0,144(sp)
    80005e52:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e54:	fffff097          	auipc	ra,0xfffff
    80005e58:	80a080e7          	jalr	-2038(ra) # 8000465e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e5c:	08000613          	li	a2,128
    80005e60:	f7040593          	addi	a1,s0,-144
    80005e64:	4501                	li	a0,0
    80005e66:	ffffd097          	auipc	ra,0xffffd
    80005e6a:	04c080e7          	jalr	76(ra) # 80002eb2 <argstr>
    80005e6e:	04054a63          	bltz	a0,80005ec2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005e72:	f6c40593          	addi	a1,s0,-148
    80005e76:	4505                	li	a0,1
    80005e78:	ffffd097          	auipc	ra,0xffffd
    80005e7c:	ff6080e7          	jalr	-10(ra) # 80002e6e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e80:	04054163          	bltz	a0,80005ec2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005e84:	f6840593          	addi	a1,s0,-152
    80005e88:	4509                	li	a0,2
    80005e8a:	ffffd097          	auipc	ra,0xffffd
    80005e8e:	fe4080e7          	jalr	-28(ra) # 80002e6e <argint>
     argint(1, &major) < 0 ||
    80005e92:	02054863          	bltz	a0,80005ec2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005e96:	f6841683          	lh	a3,-152(s0)
    80005e9a:	f6c41603          	lh	a2,-148(s0)
    80005e9e:	458d                	li	a1,3
    80005ea0:	f7040513          	addi	a0,s0,-144
    80005ea4:	fffff097          	auipc	ra,0xfffff
    80005ea8:	77a080e7          	jalr	1914(ra) # 8000561e <create>
     argint(2, &minor) < 0 ||
    80005eac:	c919                	beqz	a0,80005ec2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005eae:	ffffe097          	auipc	ra,0xffffe
    80005eb2:	036080e7          	jalr	54(ra) # 80003ee4 <iunlockput>
  end_op();
    80005eb6:	fffff097          	auipc	ra,0xfffff
    80005eba:	828080e7          	jalr	-2008(ra) # 800046de <end_op>
  return 0;
    80005ebe:	4501                	li	a0,0
    80005ec0:	a031                	j	80005ecc <sys_mknod+0x80>
    end_op();
    80005ec2:	fffff097          	auipc	ra,0xfffff
    80005ec6:	81c080e7          	jalr	-2020(ra) # 800046de <end_op>
    return -1;
    80005eca:	557d                	li	a0,-1
}
    80005ecc:	60ea                	ld	ra,152(sp)
    80005ece:	644a                	ld	s0,144(sp)
    80005ed0:	610d                	addi	sp,sp,160
    80005ed2:	8082                	ret

0000000080005ed4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005ed4:	7135                	addi	sp,sp,-160
    80005ed6:	ed06                	sd	ra,152(sp)
    80005ed8:	e922                	sd	s0,144(sp)
    80005eda:	e526                	sd	s1,136(sp)
    80005edc:	e14a                	sd	s2,128(sp)
    80005ede:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ee0:	ffffc097          	auipc	ra,0xffffc
    80005ee4:	b58080e7          	jalr	-1192(ra) # 80001a38 <myproc>
    80005ee8:	892a                	mv	s2,a0
  
  begin_op();
    80005eea:	ffffe097          	auipc	ra,0xffffe
    80005eee:	774080e7          	jalr	1908(ra) # 8000465e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005ef2:	08000613          	li	a2,128
    80005ef6:	f6040593          	addi	a1,s0,-160
    80005efa:	4501                	li	a0,0
    80005efc:	ffffd097          	auipc	ra,0xffffd
    80005f00:	fb6080e7          	jalr	-74(ra) # 80002eb2 <argstr>
    80005f04:	04054b63          	bltz	a0,80005f5a <sys_chdir+0x86>
    80005f08:	f6040513          	addi	a0,s0,-160
    80005f0c:	ffffe097          	auipc	ra,0xffffe
    80005f10:	534080e7          	jalr	1332(ra) # 80004440 <namei>
    80005f14:	84aa                	mv	s1,a0
    80005f16:	c131                	beqz	a0,80005f5a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f18:	ffffe097          	auipc	ra,0xffffe
    80005f1c:	d68080e7          	jalr	-664(ra) # 80003c80 <ilock>
  if(ip->type != T_DIR){
    80005f20:	04449703          	lh	a4,68(s1)
    80005f24:	4785                	li	a5,1
    80005f26:	04f71063          	bne	a4,a5,80005f66 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f2a:	8526                	mv	a0,s1
    80005f2c:	ffffe097          	auipc	ra,0xffffe
    80005f30:	e18080e7          	jalr	-488(ra) # 80003d44 <iunlock>
  iput(p->cwd);
    80005f34:	15093503          	ld	a0,336(s2)
    80005f38:	ffffe097          	auipc	ra,0xffffe
    80005f3c:	f04080e7          	jalr	-252(ra) # 80003e3c <iput>
  end_op();
    80005f40:	ffffe097          	auipc	ra,0xffffe
    80005f44:	79e080e7          	jalr	1950(ra) # 800046de <end_op>
  p->cwd = ip;
    80005f48:	14993823          	sd	s1,336(s2)
  return 0;
    80005f4c:	4501                	li	a0,0
}
    80005f4e:	60ea                	ld	ra,152(sp)
    80005f50:	644a                	ld	s0,144(sp)
    80005f52:	64aa                	ld	s1,136(sp)
    80005f54:	690a                	ld	s2,128(sp)
    80005f56:	610d                	addi	sp,sp,160
    80005f58:	8082                	ret
    end_op();
    80005f5a:	ffffe097          	auipc	ra,0xffffe
    80005f5e:	784080e7          	jalr	1924(ra) # 800046de <end_op>
    return -1;
    80005f62:	557d                	li	a0,-1
    80005f64:	b7ed                	j	80005f4e <sys_chdir+0x7a>
    iunlockput(ip);
    80005f66:	8526                	mv	a0,s1
    80005f68:	ffffe097          	auipc	ra,0xffffe
    80005f6c:	f7c080e7          	jalr	-132(ra) # 80003ee4 <iunlockput>
    end_op();
    80005f70:	ffffe097          	auipc	ra,0xffffe
    80005f74:	76e080e7          	jalr	1902(ra) # 800046de <end_op>
    return -1;
    80005f78:	557d                	li	a0,-1
    80005f7a:	bfd1                	j	80005f4e <sys_chdir+0x7a>

0000000080005f7c <sys_exec>:

uint64
sys_exec(void)
{
    80005f7c:	7145                	addi	sp,sp,-464
    80005f7e:	e786                	sd	ra,456(sp)
    80005f80:	e3a2                	sd	s0,448(sp)
    80005f82:	ff26                	sd	s1,440(sp)
    80005f84:	fb4a                	sd	s2,432(sp)
    80005f86:	f74e                	sd	s3,424(sp)
    80005f88:	f352                	sd	s4,416(sp)
    80005f8a:	ef56                	sd	s5,408(sp)
    80005f8c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005f8e:	08000613          	li	a2,128
    80005f92:	f4040593          	addi	a1,s0,-192
    80005f96:	4501                	li	a0,0
    80005f98:	ffffd097          	auipc	ra,0xffffd
    80005f9c:	f1a080e7          	jalr	-230(ra) # 80002eb2 <argstr>
    return -1;
    80005fa0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005fa2:	0e054c63          	bltz	a0,8000609a <sys_exec+0x11e>
    80005fa6:	e3840593          	addi	a1,s0,-456
    80005faa:	4505                	li	a0,1
    80005fac:	ffffd097          	auipc	ra,0xffffd
    80005fb0:	ee4080e7          	jalr	-284(ra) # 80002e90 <argaddr>
    80005fb4:	0e054363          	bltz	a0,8000609a <sys_exec+0x11e>
  }
  memset(argv, 0, sizeof(argv));
    80005fb8:	e4040913          	addi	s2,s0,-448
    80005fbc:	10000613          	li	a2,256
    80005fc0:	4581                	li	a1,0
    80005fc2:	854a                	mv	a0,s2
    80005fc4:	ffffb097          	auipc	ra,0xffffb
    80005fc8:	d6a080e7          	jalr	-662(ra) # 80000d2e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005fcc:	89ca                	mv	s3,s2
  memset(argv, 0, sizeof(argv));
    80005fce:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005fd0:	02000a93          	li	s5,32
    80005fd4:	00048a1b          	sext.w	s4,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005fd8:	00349513          	slli	a0,s1,0x3
    80005fdc:	e3040593          	addi	a1,s0,-464
    80005fe0:	e3843783          	ld	a5,-456(s0)
    80005fe4:	953e                	add	a0,a0,a5
    80005fe6:	ffffd097          	auipc	ra,0xffffd
    80005fea:	dec080e7          	jalr	-532(ra) # 80002dd2 <fetchaddr>
    80005fee:	02054a63          	bltz	a0,80006022 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005ff2:	e3043783          	ld	a5,-464(s0)
    80005ff6:	cfa9                	beqz	a5,80006050 <sys_exec+0xd4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ff8:	ffffb097          	auipc	ra,0xffffb
    80005ffc:	b4a080e7          	jalr	-1206(ra) # 80000b42 <kalloc>
    80006000:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    80006004:	cd19                	beqz	a0,80006022 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006006:	6605                	lui	a2,0x1
    80006008:	85aa                	mv	a1,a0
    8000600a:	e3043503          	ld	a0,-464(s0)
    8000600e:	ffffd097          	auipc	ra,0xffffd
    80006012:	e18080e7          	jalr	-488(ra) # 80002e26 <fetchstr>
    80006016:	00054663          	bltz	a0,80006022 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    8000601a:	0485                	addi	s1,s1,1
    8000601c:	0921                	addi	s2,s2,8
    8000601e:	fb549be3          	bne	s1,s5,80005fd4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006022:	e4043503          	ld	a0,-448(s0)
    kfree(argv[i]);
  return -1;
    80006026:	597d                	li	s2,-1
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006028:	c92d                	beqz	a0,8000609a <sys_exec+0x11e>
    kfree(argv[i]);
    8000602a:	ffffb097          	auipc	ra,0xffffb
    8000602e:	a18080e7          	jalr	-1512(ra) # 80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006032:	e4840493          	addi	s1,s0,-440
    80006036:	10098993          	addi	s3,s3,256
    8000603a:	6088                	ld	a0,0(s1)
    8000603c:	cd31                	beqz	a0,80006098 <sys_exec+0x11c>
    kfree(argv[i]);
    8000603e:	ffffb097          	auipc	ra,0xffffb
    80006042:	a04080e7          	jalr	-1532(ra) # 80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006046:	04a1                	addi	s1,s1,8
    80006048:	ff3499e3          	bne	s1,s3,8000603a <sys_exec+0xbe>
  return -1;
    8000604c:	597d                	li	s2,-1
    8000604e:	a0b1                	j	8000609a <sys_exec+0x11e>
      argv[i] = 0;
    80006050:	0a0e                	slli	s4,s4,0x3
    80006052:	fc040793          	addi	a5,s0,-64
    80006056:	9a3e                	add	s4,s4,a5
    80006058:	e80a3023          	sd	zero,-384(s4)
  int ret = exec(path, argv);
    8000605c:	e4040593          	addi	a1,s0,-448
    80006060:	f4040513          	addi	a0,s0,-192
    80006064:	fffff097          	auipc	ra,0xfffff
    80006068:	166080e7          	jalr	358(ra) # 800051ca <exec>
    8000606c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000606e:	e4043503          	ld	a0,-448(s0)
    80006072:	c505                	beqz	a0,8000609a <sys_exec+0x11e>
    kfree(argv[i]);
    80006074:	ffffb097          	auipc	ra,0xffffb
    80006078:	9ce080e7          	jalr	-1586(ra) # 80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000607c:	e4840493          	addi	s1,s0,-440
    80006080:	10098993          	addi	s3,s3,256
    80006084:	6088                	ld	a0,0(s1)
    80006086:	c911                	beqz	a0,8000609a <sys_exec+0x11e>
    kfree(argv[i]);
    80006088:	ffffb097          	auipc	ra,0xffffb
    8000608c:	9ba080e7          	jalr	-1606(ra) # 80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006090:	04a1                	addi	s1,s1,8
    80006092:	ff3499e3          	bne	s1,s3,80006084 <sys_exec+0x108>
    80006096:	a011                	j	8000609a <sys_exec+0x11e>
  return -1;
    80006098:	597d                	li	s2,-1
}
    8000609a:	854a                	mv	a0,s2
    8000609c:	60be                	ld	ra,456(sp)
    8000609e:	641e                	ld	s0,448(sp)
    800060a0:	74fa                	ld	s1,440(sp)
    800060a2:	795a                	ld	s2,432(sp)
    800060a4:	79ba                	ld	s3,424(sp)
    800060a6:	7a1a                	ld	s4,416(sp)
    800060a8:	6afa                	ld	s5,408(sp)
    800060aa:	6179                	addi	sp,sp,464
    800060ac:	8082                	ret

00000000800060ae <sys_pipe>:

uint64
sys_pipe(void)
{
    800060ae:	7139                	addi	sp,sp,-64
    800060b0:	fc06                	sd	ra,56(sp)
    800060b2:	f822                	sd	s0,48(sp)
    800060b4:	f426                	sd	s1,40(sp)
    800060b6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060b8:	ffffc097          	auipc	ra,0xffffc
    800060bc:	980080e7          	jalr	-1664(ra) # 80001a38 <myproc>
    800060c0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800060c2:	fd840593          	addi	a1,s0,-40
    800060c6:	4501                	li	a0,0
    800060c8:	ffffd097          	auipc	ra,0xffffd
    800060cc:	dc8080e7          	jalr	-568(ra) # 80002e90 <argaddr>
    return -1;
    800060d0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800060d2:	0c054f63          	bltz	a0,800061b0 <sys_pipe+0x102>
  if(pipealloc(&rf, &wf) < 0)
    800060d6:	fc840593          	addi	a1,s0,-56
    800060da:	fd040513          	addi	a0,s0,-48
    800060de:	fffff097          	auipc	ra,0xfffff
    800060e2:	d9e080e7          	jalr	-610(ra) # 80004e7c <pipealloc>
    return -1;
    800060e6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800060e8:	0c054463          	bltz	a0,800061b0 <sys_pipe+0x102>
  fd0 = -1;
    800060ec:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800060f0:	fd043503          	ld	a0,-48(s0)
    800060f4:	fffff097          	auipc	ra,0xfffff
    800060f8:	4e2080e7          	jalr	1250(ra) # 800055d6 <fdalloc>
    800060fc:	fca42223          	sw	a0,-60(s0)
    80006100:	08054b63          	bltz	a0,80006196 <sys_pipe+0xe8>
    80006104:	fc843503          	ld	a0,-56(s0)
    80006108:	fffff097          	auipc	ra,0xfffff
    8000610c:	4ce080e7          	jalr	1230(ra) # 800055d6 <fdalloc>
    80006110:	fca42023          	sw	a0,-64(s0)
    80006114:	06054863          	bltz	a0,80006184 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006118:	4691                	li	a3,4
    8000611a:	fc440613          	addi	a2,s0,-60
    8000611e:	fd843583          	ld	a1,-40(s0)
    80006122:	68a8                	ld	a0,80(s1)
    80006124:	ffffb097          	auipc	ra,0xffffb
    80006128:	5be080e7          	jalr	1470(ra) # 800016e2 <copyout>
    8000612c:	02054063          	bltz	a0,8000614c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006130:	4691                	li	a3,4
    80006132:	fc040613          	addi	a2,s0,-64
    80006136:	fd843583          	ld	a1,-40(s0)
    8000613a:	0591                	addi	a1,a1,4
    8000613c:	68a8                	ld	a0,80(s1)
    8000613e:	ffffb097          	auipc	ra,0xffffb
    80006142:	5a4080e7          	jalr	1444(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006146:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006148:	06055463          	bgez	a0,800061b0 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    8000614c:	fc442783          	lw	a5,-60(s0)
    80006150:	07e9                	addi	a5,a5,26
    80006152:	078e                	slli	a5,a5,0x3
    80006154:	97a6                	add	a5,a5,s1
    80006156:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000615a:	fc042783          	lw	a5,-64(s0)
    8000615e:	07e9                	addi	a5,a5,26
    80006160:	078e                	slli	a5,a5,0x3
    80006162:	94be                	add	s1,s1,a5
    80006164:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006168:	fd043503          	ld	a0,-48(s0)
    8000616c:	fffff097          	auipc	ra,0xfffff
    80006170:	9ec080e7          	jalr	-1556(ra) # 80004b58 <fileclose>
    fileclose(wf);
    80006174:	fc843503          	ld	a0,-56(s0)
    80006178:	fffff097          	auipc	ra,0xfffff
    8000617c:	9e0080e7          	jalr	-1568(ra) # 80004b58 <fileclose>
    return -1;
    80006180:	57fd                	li	a5,-1
    80006182:	a03d                	j	800061b0 <sys_pipe+0x102>
    if(fd0 >= 0)
    80006184:	fc442783          	lw	a5,-60(s0)
    80006188:	0007c763          	bltz	a5,80006196 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    8000618c:	07e9                	addi	a5,a5,26
    8000618e:	078e                	slli	a5,a5,0x3
    80006190:	94be                	add	s1,s1,a5
    80006192:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006196:	fd043503          	ld	a0,-48(s0)
    8000619a:	fffff097          	auipc	ra,0xfffff
    8000619e:	9be080e7          	jalr	-1602(ra) # 80004b58 <fileclose>
    fileclose(wf);
    800061a2:	fc843503          	ld	a0,-56(s0)
    800061a6:	fffff097          	auipc	ra,0xfffff
    800061aa:	9b2080e7          	jalr	-1614(ra) # 80004b58 <fileclose>
    return -1;
    800061ae:	57fd                	li	a5,-1
}
    800061b0:	853e                	mv	a0,a5
    800061b2:	70e2                	ld	ra,56(sp)
    800061b4:	7442                	ld	s0,48(sp)
    800061b6:	74a2                	ld	s1,40(sp)
    800061b8:	6121                	addi	sp,sp,64
    800061ba:	8082                	ret
    800061bc:	0000                	unimp
	...

00000000800061c0 <kernelvec>:
    800061c0:	7111                	addi	sp,sp,-256
    800061c2:	e006                	sd	ra,0(sp)
    800061c4:	e40a                	sd	sp,8(sp)
    800061c6:	e80e                	sd	gp,16(sp)
    800061c8:	ec12                	sd	tp,24(sp)
    800061ca:	f016                	sd	t0,32(sp)
    800061cc:	f41a                	sd	t1,40(sp)
    800061ce:	f81e                	sd	t2,48(sp)
    800061d0:	fc22                	sd	s0,56(sp)
    800061d2:	e0a6                	sd	s1,64(sp)
    800061d4:	e4aa                	sd	a0,72(sp)
    800061d6:	e8ae                	sd	a1,80(sp)
    800061d8:	ecb2                	sd	a2,88(sp)
    800061da:	f0b6                	sd	a3,96(sp)
    800061dc:	f4ba                	sd	a4,104(sp)
    800061de:	f8be                	sd	a5,112(sp)
    800061e0:	fcc2                	sd	a6,120(sp)
    800061e2:	e146                	sd	a7,128(sp)
    800061e4:	e54a                	sd	s2,136(sp)
    800061e6:	e94e                	sd	s3,144(sp)
    800061e8:	ed52                	sd	s4,152(sp)
    800061ea:	f156                	sd	s5,160(sp)
    800061ec:	f55a                	sd	s6,168(sp)
    800061ee:	f95e                	sd	s7,176(sp)
    800061f0:	fd62                	sd	s8,184(sp)
    800061f2:	e1e6                	sd	s9,192(sp)
    800061f4:	e5ea                	sd	s10,200(sp)
    800061f6:	e9ee                	sd	s11,208(sp)
    800061f8:	edf2                	sd	t3,216(sp)
    800061fa:	f1f6                	sd	t4,224(sp)
    800061fc:	f5fa                	sd	t5,232(sp)
    800061fe:	f9fe                	sd	t6,240(sp)
    80006200:	a9bfc0ef          	jal	ra,80002c9a <kerneltrap>
    80006204:	6082                	ld	ra,0(sp)
    80006206:	6122                	ld	sp,8(sp)
    80006208:	61c2                	ld	gp,16(sp)
    8000620a:	7282                	ld	t0,32(sp)
    8000620c:	7322                	ld	t1,40(sp)
    8000620e:	73c2                	ld	t2,48(sp)
    80006210:	7462                	ld	s0,56(sp)
    80006212:	6486                	ld	s1,64(sp)
    80006214:	6526                	ld	a0,72(sp)
    80006216:	65c6                	ld	a1,80(sp)
    80006218:	6666                	ld	a2,88(sp)
    8000621a:	7686                	ld	a3,96(sp)
    8000621c:	7726                	ld	a4,104(sp)
    8000621e:	77c6                	ld	a5,112(sp)
    80006220:	7866                	ld	a6,120(sp)
    80006222:	688a                	ld	a7,128(sp)
    80006224:	692a                	ld	s2,136(sp)
    80006226:	69ca                	ld	s3,144(sp)
    80006228:	6a6a                	ld	s4,152(sp)
    8000622a:	7a8a                	ld	s5,160(sp)
    8000622c:	7b2a                	ld	s6,168(sp)
    8000622e:	7bca                	ld	s7,176(sp)
    80006230:	7c6a                	ld	s8,184(sp)
    80006232:	6c8e                	ld	s9,192(sp)
    80006234:	6d2e                	ld	s10,200(sp)
    80006236:	6dce                	ld	s11,208(sp)
    80006238:	6e6e                	ld	t3,216(sp)
    8000623a:	7e8e                	ld	t4,224(sp)
    8000623c:	7f2e                	ld	t5,232(sp)
    8000623e:	7fce                	ld	t6,240(sp)
    80006240:	6111                	addi	sp,sp,256
    80006242:	10200073          	sret
    80006246:	00000013          	nop
    8000624a:	00000013          	nop
    8000624e:	0001                	nop

0000000080006250 <timervec>:
    80006250:	34051573          	csrrw	a0,mscratch,a0
    80006254:	e10c                	sd	a1,0(a0)
    80006256:	e510                	sd	a2,8(a0)
    80006258:	e914                	sd	a3,16(a0)
    8000625a:	6d0c                	ld	a1,24(a0)
    8000625c:	7110                	ld	a2,32(a0)
    8000625e:	6194                	ld	a3,0(a1)
    80006260:	96b2                	add	a3,a3,a2
    80006262:	e194                	sd	a3,0(a1)
    80006264:	4589                	li	a1,2
    80006266:	14459073          	csrw	sip,a1
    8000626a:	6914                	ld	a3,16(a0)
    8000626c:	6510                	ld	a2,8(a0)
    8000626e:	610c                	ld	a1,0(a0)
    80006270:	34051573          	csrrw	a0,mscratch,a0
    80006274:	30200073          	mret
	...

000000008000627a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000627a:	1141                	addi	sp,sp,-16
    8000627c:	e422                	sd	s0,8(sp)
    8000627e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006280:	0c0007b7          	lui	a5,0xc000
    80006284:	4705                	li	a4,1
    80006286:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006288:	c3d8                	sw	a4,4(a5)
}
    8000628a:	6422                	ld	s0,8(sp)
    8000628c:	0141                	addi	sp,sp,16
    8000628e:	8082                	ret

0000000080006290 <plicinithart>:

void
plicinithart(void)
{
    80006290:	1141                	addi	sp,sp,-16
    80006292:	e406                	sd	ra,8(sp)
    80006294:	e022                	sd	s0,0(sp)
    80006296:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006298:	ffffb097          	auipc	ra,0xffffb
    8000629c:	774080e7          	jalr	1908(ra) # 80001a0c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800062a0:	0085171b          	slliw	a4,a0,0x8
    800062a4:	0c0027b7          	lui	a5,0xc002
    800062a8:	97ba                	add	a5,a5,a4
    800062aa:	40200713          	li	a4,1026
    800062ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800062b2:	00d5151b          	slliw	a0,a0,0xd
    800062b6:	0c2017b7          	lui	a5,0xc201
    800062ba:	953e                	add	a0,a0,a5
    800062bc:	00052023          	sw	zero,0(a0)
}
    800062c0:	60a2                	ld	ra,8(sp)
    800062c2:	6402                	ld	s0,0(sp)
    800062c4:	0141                	addi	sp,sp,16
    800062c6:	8082                	ret

00000000800062c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800062c8:	1141                	addi	sp,sp,-16
    800062ca:	e406                	sd	ra,8(sp)
    800062cc:	e022                	sd	s0,0(sp)
    800062ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800062d0:	ffffb097          	auipc	ra,0xffffb
    800062d4:	73c080e7          	jalr	1852(ra) # 80001a0c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800062d8:	00d5151b          	slliw	a0,a0,0xd
    800062dc:	0c2017b7          	lui	a5,0xc201
    800062e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800062e2:	43c8                	lw	a0,4(a5)
    800062e4:	60a2                	ld	ra,8(sp)
    800062e6:	6402                	ld	s0,0(sp)
    800062e8:	0141                	addi	sp,sp,16
    800062ea:	8082                	ret

00000000800062ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800062ec:	1101                	addi	sp,sp,-32
    800062ee:	ec06                	sd	ra,24(sp)
    800062f0:	e822                	sd	s0,16(sp)
    800062f2:	e426                	sd	s1,8(sp)
    800062f4:	1000                	addi	s0,sp,32
    800062f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800062f8:	ffffb097          	auipc	ra,0xffffb
    800062fc:	714080e7          	jalr	1812(ra) # 80001a0c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006300:	00d5151b          	slliw	a0,a0,0xd
    80006304:	0c2017b7          	lui	a5,0xc201
    80006308:	97aa                	add	a5,a5,a0
    8000630a:	c3c4                	sw	s1,4(a5)
}
    8000630c:	60e2                	ld	ra,24(sp)
    8000630e:	6442                	ld	s0,16(sp)
    80006310:	64a2                	ld	s1,8(sp)
    80006312:	6105                	addi	sp,sp,32
    80006314:	8082                	ret

0000000080006316 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006316:	1141                	addi	sp,sp,-16
    80006318:	e406                	sd	ra,8(sp)
    8000631a:	e022                	sd	s0,0(sp)
    8000631c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000631e:	479d                	li	a5,7
    80006320:	06a7c963          	blt	a5,a0,80006392 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80006324:	0001e797          	auipc	a5,0x1e
    80006328:	cdc78793          	addi	a5,a5,-804 # 80024000 <disk>
    8000632c:	00a78733          	add	a4,a5,a0
    80006330:	6789                	lui	a5,0x2
    80006332:	97ba                	add	a5,a5,a4
    80006334:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006338:	e7ad                	bnez	a5,800063a2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000633a:	00451793          	slli	a5,a0,0x4
    8000633e:	00020717          	auipc	a4,0x20
    80006342:	cc270713          	addi	a4,a4,-830 # 80026000 <disk+0x2000>
    80006346:	6314                	ld	a3,0(a4)
    80006348:	96be                	add	a3,a3,a5
    8000634a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000634e:	6314                	ld	a3,0(a4)
    80006350:	96be                	add	a3,a3,a5
    80006352:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006356:	6314                	ld	a3,0(a4)
    80006358:	96be                	add	a3,a3,a5
    8000635a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000635e:	6318                	ld	a4,0(a4)
    80006360:	97ba                	add	a5,a5,a4
    80006362:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006366:	0001e797          	auipc	a5,0x1e
    8000636a:	c9a78793          	addi	a5,a5,-870 # 80024000 <disk>
    8000636e:	97aa                	add	a5,a5,a0
    80006370:	6509                	lui	a0,0x2
    80006372:	953e                	add	a0,a0,a5
    80006374:	4785                	li	a5,1
    80006376:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000637a:	00020517          	auipc	a0,0x20
    8000637e:	c9e50513          	addi	a0,a0,-866 # 80026018 <disk+0x2018>
    80006382:	ffffc097          	auipc	ra,0xffffc
    80006386:	10e080e7          	jalr	270(ra) # 80002490 <wakeup>
}
    8000638a:	60a2                	ld	ra,8(sp)
    8000638c:	6402                	ld	s0,0(sp)
    8000638e:	0141                	addi	sp,sp,16
    80006390:	8082                	ret
    panic("free_desc 1");
    80006392:	00002517          	auipc	a0,0x2
    80006396:	51e50513          	addi	a0,a0,1310 # 800088b0 <syscalls+0x448>
    8000639a:	ffffa097          	auipc	ra,0xffffa
    8000639e:	1cc080e7          	jalr	460(ra) # 80000566 <panic>
    panic("free_desc 2");
    800063a2:	00002517          	auipc	a0,0x2
    800063a6:	51e50513          	addi	a0,a0,1310 # 800088c0 <syscalls+0x458>
    800063aa:	ffffa097          	auipc	ra,0xffffa
    800063ae:	1bc080e7          	jalr	444(ra) # 80000566 <panic>

00000000800063b2 <virtio_disk_init>:
{
    800063b2:	1101                	addi	sp,sp,-32
    800063b4:	ec06                	sd	ra,24(sp)
    800063b6:	e822                	sd	s0,16(sp)
    800063b8:	e426                	sd	s1,8(sp)
    800063ba:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800063bc:	00002597          	auipc	a1,0x2
    800063c0:	51458593          	addi	a1,a1,1300 # 800088d0 <syscalls+0x468>
    800063c4:	00020517          	auipc	a0,0x20
    800063c8:	d6450513          	addi	a0,a0,-668 # 80026128 <disk+0x2128>
    800063cc:	ffffa097          	auipc	ra,0xffffa
    800063d0:	7d6080e7          	jalr	2006(ra) # 80000ba2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800063d4:	100017b7          	lui	a5,0x10001
    800063d8:	4398                	lw	a4,0(a5)
    800063da:	2701                	sext.w	a4,a4
    800063dc:	747277b7          	lui	a5,0x74727
    800063e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800063e4:	0ef71163          	bne	a4,a5,800064c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800063e8:	100017b7          	lui	a5,0x10001
    800063ec:	43dc                	lw	a5,4(a5)
    800063ee:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800063f0:	4705                	li	a4,1
    800063f2:	0ce79a63          	bne	a5,a4,800064c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063f6:	100017b7          	lui	a5,0x10001
    800063fa:	479c                	lw	a5,8(a5)
    800063fc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800063fe:	4709                	li	a4,2
    80006400:	0ce79363          	bne	a5,a4,800064c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006404:	100017b7          	lui	a5,0x10001
    80006408:	47d8                	lw	a4,12(a5)
    8000640a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000640c:	554d47b7          	lui	a5,0x554d4
    80006410:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006414:	0af71963          	bne	a4,a5,800064c6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006418:	100017b7          	lui	a5,0x10001
    8000641c:	4705                	li	a4,1
    8000641e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006420:	470d                	li	a4,3
    80006422:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006424:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006426:	c7ffe737          	lui	a4,0xc7ffe
    8000642a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd775f>
    8000642e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006430:	2701                	sext.w	a4,a4
    80006432:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006434:	472d                	li	a4,11
    80006436:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006438:	473d                	li	a4,15
    8000643a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000643c:	6705                	lui	a4,0x1
    8000643e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006440:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006444:	5bdc                	lw	a5,52(a5)
    80006446:	2781                	sext.w	a5,a5
  if(max == 0)
    80006448:	c7d9                	beqz	a5,800064d6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000644a:	471d                	li	a4,7
    8000644c:	08f77d63          	bgeu	a4,a5,800064e6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006450:	100014b7          	lui	s1,0x10001
    80006454:	47a1                	li	a5,8
    80006456:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80006458:	6609                	lui	a2,0x2
    8000645a:	4581                	li	a1,0
    8000645c:	0001e517          	auipc	a0,0x1e
    80006460:	ba450513          	addi	a0,a0,-1116 # 80024000 <disk>
    80006464:	ffffb097          	auipc	ra,0xffffb
    80006468:	8ca080e7          	jalr	-1846(ra) # 80000d2e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000646c:	0001e717          	auipc	a4,0x1e
    80006470:	b9470713          	addi	a4,a4,-1132 # 80024000 <disk>
    80006474:	00c75793          	srli	a5,a4,0xc
    80006478:	2781                	sext.w	a5,a5
    8000647a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000647c:	00020797          	auipc	a5,0x20
    80006480:	b8478793          	addi	a5,a5,-1148 # 80026000 <disk+0x2000>
    80006484:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006486:	0001e717          	auipc	a4,0x1e
    8000648a:	bfa70713          	addi	a4,a4,-1030 # 80024080 <disk+0x80>
    8000648e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006490:	0001f717          	auipc	a4,0x1f
    80006494:	b7070713          	addi	a4,a4,-1168 # 80025000 <disk+0x1000>
    80006498:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000649a:	4705                	li	a4,1
    8000649c:	00e78c23          	sb	a4,24(a5)
    800064a0:	00e78ca3          	sb	a4,25(a5)
    800064a4:	00e78d23          	sb	a4,26(a5)
    800064a8:	00e78da3          	sb	a4,27(a5)
    800064ac:	00e78e23          	sb	a4,28(a5)
    800064b0:	00e78ea3          	sb	a4,29(a5)
    800064b4:	00e78f23          	sb	a4,30(a5)
    800064b8:	00e78fa3          	sb	a4,31(a5)
}
    800064bc:	60e2                	ld	ra,24(sp)
    800064be:	6442                	ld	s0,16(sp)
    800064c0:	64a2                	ld	s1,8(sp)
    800064c2:	6105                	addi	sp,sp,32
    800064c4:	8082                	ret
    panic("could not find virtio disk");
    800064c6:	00002517          	auipc	a0,0x2
    800064ca:	41a50513          	addi	a0,a0,1050 # 800088e0 <syscalls+0x478>
    800064ce:	ffffa097          	auipc	ra,0xffffa
    800064d2:	098080e7          	jalr	152(ra) # 80000566 <panic>
    panic("virtio disk has no queue 0");
    800064d6:	00002517          	auipc	a0,0x2
    800064da:	42a50513          	addi	a0,a0,1066 # 80008900 <syscalls+0x498>
    800064de:	ffffa097          	auipc	ra,0xffffa
    800064e2:	088080e7          	jalr	136(ra) # 80000566 <panic>
    panic("virtio disk max queue too short");
    800064e6:	00002517          	auipc	a0,0x2
    800064ea:	43a50513          	addi	a0,a0,1082 # 80008920 <syscalls+0x4b8>
    800064ee:	ffffa097          	auipc	ra,0xffffa
    800064f2:	078080e7          	jalr	120(ra) # 80000566 <panic>

00000000800064f6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800064f6:	711d                	addi	sp,sp,-96
    800064f8:	ec86                	sd	ra,88(sp)
    800064fa:	e8a2                	sd	s0,80(sp)
    800064fc:	e4a6                	sd	s1,72(sp)
    800064fe:	e0ca                	sd	s2,64(sp)
    80006500:	fc4e                	sd	s3,56(sp)
    80006502:	f852                	sd	s4,48(sp)
    80006504:	f456                	sd	s5,40(sp)
    80006506:	f05a                	sd	s6,32(sp)
    80006508:	ec5e                	sd	s7,24(sp)
    8000650a:	e862                	sd	s8,16(sp)
    8000650c:	1080                	addi	s0,sp,96
    8000650e:	892a                	mv	s2,a0
    80006510:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006512:	00c52b83          	lw	s7,12(a0)
    80006516:	001b9b9b          	slliw	s7,s7,0x1
    8000651a:	1b82                	slli	s7,s7,0x20
    8000651c:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006520:	00020517          	auipc	a0,0x20
    80006524:	c0850513          	addi	a0,a0,-1016 # 80026128 <disk+0x2128>
    80006528:	ffffa097          	auipc	ra,0xffffa
    8000652c:	70a080e7          	jalr	1802(ra) # 80000c32 <acquire>
    if(disk.free[i]){
    80006530:	00020997          	auipc	s3,0x20
    80006534:	ad098993          	addi	s3,s3,-1328 # 80026000 <disk+0x2000>
  for(int i = 0; i < NUM; i++){
    80006538:	4b21                	li	s6,8
      disk.free[i] = 0;
    8000653a:	0001ea97          	auipc	s5,0x1e
    8000653e:	ac6a8a93          	addi	s5,s5,-1338 # 80024000 <disk>
  for(int i = 0; i < 3; i++){
    80006542:	4a0d                	li	s4,3
    80006544:	a079                	j	800065d2 <virtio_disk_rw+0xdc>
      disk.free[i] = 0;
    80006546:	00fa86b3          	add	a3,s5,a5
    8000654a:	96ae                	add	a3,a3,a1
    8000654c:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80006550:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80006552:	0207ca63          	bltz	a5,80006586 <virtio_disk_rw+0x90>
  for(int i = 0; i < 3; i++){
    80006556:	2485                	addiw	s1,s1,1
    80006558:	0711                	addi	a4,a4,4
    8000655a:	25448b63          	beq	s1,s4,800067b0 <virtio_disk_rw+0x2ba>
    idx[i] = alloc_desc();
    8000655e:	863a                	mv	a2,a4
    if(disk.free[i]){
    80006560:	0189c783          	lbu	a5,24(s3)
    80006564:	26079e63          	bnez	a5,800067e0 <virtio_disk_rw+0x2ea>
    80006568:	00020697          	auipc	a3,0x20
    8000656c:	ab168693          	addi	a3,a3,-1359 # 80026019 <disk+0x2019>
  for(int i = 0; i < NUM; i++){
    80006570:	87aa                	mv	a5,a0
    if(disk.free[i]){
    80006572:	0006c803          	lbu	a6,0(a3)
    80006576:	fc0818e3          	bnez	a6,80006546 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    8000657a:	2785                	addiw	a5,a5,1
    8000657c:	0685                	addi	a3,a3,1
    8000657e:	ff679ae3          	bne	a5,s6,80006572 <virtio_disk_rw+0x7c>
    idx[i] = alloc_desc();
    80006582:	57fd                	li	a5,-1
    80006584:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80006586:	02905a63          	blez	s1,800065ba <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    8000658a:	fa042503          	lw	a0,-96(s0)
    8000658e:	00000097          	auipc	ra,0x0
    80006592:	d88080e7          	jalr	-632(ra) # 80006316 <free_desc>
      for(int j = 0; j < i; j++)
    80006596:	4785                	li	a5,1
    80006598:	0297d163          	bge	a5,s1,800065ba <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    8000659c:	fa442503          	lw	a0,-92(s0)
    800065a0:	00000097          	auipc	ra,0x0
    800065a4:	d76080e7          	jalr	-650(ra) # 80006316 <free_desc>
      for(int j = 0; j < i; j++)
    800065a8:	4789                	li	a5,2
    800065aa:	0097d863          	bge	a5,s1,800065ba <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    800065ae:	fa842503          	lw	a0,-88(s0)
    800065b2:	00000097          	auipc	ra,0x0
    800065b6:	d64080e7          	jalr	-668(ra) # 80006316 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800065ba:	00020597          	auipc	a1,0x20
    800065be:	b6e58593          	addi	a1,a1,-1170 # 80026128 <disk+0x2128>
    800065c2:	00020517          	auipc	a0,0x20
    800065c6:	a5650513          	addi	a0,a0,-1450 # 80026018 <disk+0x2018>
    800065ca:	ffffc097          	auipc	ra,0xffffc
    800065ce:	be0080e7          	jalr	-1056(ra) # 800021aa <sleep>
  for(int i = 0; i < 3; i++){
    800065d2:	fa040713          	addi	a4,s0,-96
    800065d6:	4481                	li	s1,0
  for(int i = 0; i < NUM; i++){
    800065d8:	4505                	li	a0,1
      disk.free[i] = 0;
    800065da:	6589                	lui	a1,0x2
    800065dc:	b749                	j	8000655e <virtio_disk_rw+0x68>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800065de:	20058793          	addi	a5,a1,512 # 2200 <_entry-0x7fffde00>
    800065e2:	00479613          	slli	a2,a5,0x4
    800065e6:	0001e797          	auipc	a5,0x1e
    800065ea:	a1a78793          	addi	a5,a5,-1510 # 80024000 <disk>
    800065ee:	97b2                	add	a5,a5,a2
    800065f0:	4605                	li	a2,1
    800065f2:	0ac7a423          	sw	a2,168(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800065f6:	20058793          	addi	a5,a1,512
    800065fa:	00479613          	slli	a2,a5,0x4
    800065fe:	0001e797          	auipc	a5,0x1e
    80006602:	a0278793          	addi	a5,a5,-1534 # 80024000 <disk>
    80006606:	97b2                	add	a5,a5,a2
    80006608:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000660c:	0b77b823          	sd	s7,176(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006610:	00020797          	auipc	a5,0x20
    80006614:	9f078793          	addi	a5,a5,-1552 # 80026000 <disk+0x2000>
    80006618:	6390                	ld	a2,0(a5)
    8000661a:	963a                	add	a2,a2,a4
    8000661c:	7779                	lui	a4,0xffffe
    8000661e:	9732                	add	a4,a4,a2
    80006620:	e314                	sd	a3,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006622:	00459713          	slli	a4,a1,0x4
    80006626:	6394                	ld	a3,0(a5)
    80006628:	96ba                	add	a3,a3,a4
    8000662a:	4641                	li	a2,16
    8000662c:	c690                	sw	a2,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000662e:	6394                	ld	a3,0(a5)
    80006630:	96ba                	add	a3,a3,a4
    80006632:	4605                	li	a2,1
    80006634:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006638:	fa442683          	lw	a3,-92(s0)
    8000663c:	6390                	ld	a2,0(a5)
    8000663e:	963a                	add	a2,a2,a4
    80006640:	00d61723          	sh	a3,14(a2) # 200e <_entry-0x7fffdff2>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006644:	0692                	slli	a3,a3,0x4
    80006646:	6390                	ld	a2,0(a5)
    80006648:	9636                	add	a2,a2,a3
    8000664a:	05890513          	addi	a0,s2,88
    8000664e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006650:	639c                	ld	a5,0(a5)
    80006652:	97b6                	add	a5,a5,a3
    80006654:	40000613          	li	a2,1024
    80006658:	c790                	sw	a2,8(a5)
  if(write)
    8000665a:	140c0163          	beqz	s8,8000679c <virtio_disk_rw+0x2a6>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000665e:	00020797          	auipc	a5,0x20
    80006662:	9a278793          	addi	a5,a5,-1630 # 80026000 <disk+0x2000>
    80006666:	639c                	ld	a5,0(a5)
    80006668:	97b6                	add	a5,a5,a3
    8000666a:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000666e:	0001e897          	auipc	a7,0x1e
    80006672:	99288893          	addi	a7,a7,-1646 # 80024000 <disk>
    80006676:	00020797          	auipc	a5,0x20
    8000667a:	98a78793          	addi	a5,a5,-1654 # 80026000 <disk+0x2000>
    8000667e:	6390                	ld	a2,0(a5)
    80006680:	9636                	add	a2,a2,a3
    80006682:	00c65503          	lhu	a0,12(a2)
    80006686:	00156513          	ori	a0,a0,1
    8000668a:	00a61623          	sh	a0,12(a2)
  disk.desc[idx[1]].next = idx[2];
    8000668e:	fa842603          	lw	a2,-88(s0)
    80006692:	6388                	ld	a0,0(a5)
    80006694:	96aa                	add	a3,a3,a0
    80006696:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000669a:	20058513          	addi	a0,a1,512
    8000669e:	0512                	slli	a0,a0,0x4
    800066a0:	9546                	add	a0,a0,a7
    800066a2:	56fd                	li	a3,-1
    800066a4:	02d50823          	sb	a3,48(a0)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800066a8:	00461693          	slli	a3,a2,0x4
    800066ac:	6390                	ld	a2,0(a5)
    800066ae:	9636                	add	a2,a2,a3
    800066b0:	6809                	lui	a6,0x2
    800066b2:	03080813          	addi	a6,a6,48 # 2030 <_entry-0x7fffdfd0>
    800066b6:	9742                	add	a4,a4,a6
    800066b8:	9746                	add	a4,a4,a7
    800066ba:	e218                	sd	a4,0(a2)
  disk.desc[idx[2]].len = 1;
    800066bc:	6398                	ld	a4,0(a5)
    800066be:	9736                	add	a4,a4,a3
    800066c0:	4605                	li	a2,1
    800066c2:	c710                	sw	a2,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800066c4:	6398                	ld	a4,0(a5)
    800066c6:	9736                	add	a4,a4,a3
    800066c8:	4809                	li	a6,2
    800066ca:	01071623          	sh	a6,12(a4) # ffffffffffffe00c <end+0xffffffff7ffd700c>
  disk.desc[idx[2]].next = 0;
    800066ce:	6398                	ld	a4,0(a5)
    800066d0:	96ba                	add	a3,a3,a4
    800066d2:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800066d6:	00c92223          	sw	a2,4(s2)
  disk.info[idx[0]].b = b;
    800066da:	03253423          	sd	s2,40(a0)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800066de:	6794                	ld	a3,8(a5)
    800066e0:	0026d703          	lhu	a4,2(a3)
    800066e4:	8b1d                	andi	a4,a4,7
    800066e6:	0706                	slli	a4,a4,0x1
    800066e8:	9736                	add	a4,a4,a3
    800066ea:	00b71223          	sh	a1,4(a4)

  __sync_synchronize();
    800066ee:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800066f2:	6798                	ld	a4,8(a5)
    800066f4:	00275783          	lhu	a5,2(a4)
    800066f8:	2785                	addiw	a5,a5,1
    800066fa:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800066fe:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006702:	100017b7          	lui	a5,0x10001
    80006706:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000670a:	00492703          	lw	a4,4(s2)
    8000670e:	4785                	li	a5,1
    80006710:	02f71163          	bne	a4,a5,80006732 <virtio_disk_rw+0x23c>
    sleep(b, &disk.vdisk_lock);
    80006714:	00020997          	auipc	s3,0x20
    80006718:	a1498993          	addi	s3,s3,-1516 # 80026128 <disk+0x2128>
  while(b->disk == 1) {
    8000671c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000671e:	85ce                	mv	a1,s3
    80006720:	854a                	mv	a0,s2
    80006722:	ffffc097          	auipc	ra,0xffffc
    80006726:	a88080e7          	jalr	-1400(ra) # 800021aa <sleep>
  while(b->disk == 1) {
    8000672a:	00492783          	lw	a5,4(s2)
    8000672e:	fe9788e3          	beq	a5,s1,8000671e <virtio_disk_rw+0x228>
  }

  disk.info[idx[0]].b = 0;
    80006732:	fa042503          	lw	a0,-96(s0)
    80006736:	20050793          	addi	a5,a0,512
    8000673a:	00479713          	slli	a4,a5,0x4
    8000673e:	0001e797          	auipc	a5,0x1e
    80006742:	8c278793          	addi	a5,a5,-1854 # 80024000 <disk>
    80006746:	97ba                	add	a5,a5,a4
    80006748:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000674c:	00020997          	auipc	s3,0x20
    80006750:	8b498993          	addi	s3,s3,-1868 # 80026000 <disk+0x2000>
    80006754:	00451713          	slli	a4,a0,0x4
    80006758:	0009b783          	ld	a5,0(s3)
    8000675c:	97ba                	add	a5,a5,a4
    8000675e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006762:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006766:	00000097          	auipc	ra,0x0
    8000676a:	bb0080e7          	jalr	-1104(ra) # 80006316 <free_desc>
      i = nxt;
    8000676e:	854a                	mv	a0,s2
    if(flag & VRING_DESC_F_NEXT)
    80006770:	8885                	andi	s1,s1,1
    80006772:	f0ed                	bnez	s1,80006754 <virtio_disk_rw+0x25e>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006774:	00020517          	auipc	a0,0x20
    80006778:	9b450513          	addi	a0,a0,-1612 # 80026128 <disk+0x2128>
    8000677c:	ffffa097          	auipc	ra,0xffffa
    80006780:	56a080e7          	jalr	1386(ra) # 80000ce6 <release>
}
    80006784:	60e6                	ld	ra,88(sp)
    80006786:	6446                	ld	s0,80(sp)
    80006788:	64a6                	ld	s1,72(sp)
    8000678a:	6906                	ld	s2,64(sp)
    8000678c:	79e2                	ld	s3,56(sp)
    8000678e:	7a42                	ld	s4,48(sp)
    80006790:	7aa2                	ld	s5,40(sp)
    80006792:	7b02                	ld	s6,32(sp)
    80006794:	6be2                	ld	s7,24(sp)
    80006796:	6c42                	ld	s8,16(sp)
    80006798:	6125                	addi	sp,sp,96
    8000679a:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000679c:	00020797          	auipc	a5,0x20
    800067a0:	86478793          	addi	a5,a5,-1948 # 80026000 <disk+0x2000>
    800067a4:	639c                	ld	a5,0(a5)
    800067a6:	97b6                	add	a5,a5,a3
    800067a8:	4609                	li	a2,2
    800067aa:	00c79623          	sh	a2,12(a5)
    800067ae:	b5c1                	j	8000666e <virtio_disk_rw+0x178>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800067b0:	fa042583          	lw	a1,-96(s0)
    800067b4:	20058713          	addi	a4,a1,512
    800067b8:	0712                	slli	a4,a4,0x4
    800067ba:	0001e697          	auipc	a3,0x1e
    800067be:	8ee68693          	addi	a3,a3,-1810 # 800240a8 <disk+0xa8>
    800067c2:	96ba                	add	a3,a3,a4
  if(write)
    800067c4:	e00c1de3          	bnez	s8,800065de <virtio_disk_rw+0xe8>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800067c8:	20058793          	addi	a5,a1,512
    800067cc:	00479613          	slli	a2,a5,0x4
    800067d0:	0001e797          	auipc	a5,0x1e
    800067d4:	83078793          	addi	a5,a5,-2000 # 80024000 <disk>
    800067d8:	97b2                	add	a5,a5,a2
    800067da:	0a07a423          	sw	zero,168(a5)
    800067de:	bd21                	j	800065f6 <virtio_disk_rw+0x100>
      disk.free[i] = 0;
    800067e0:	00098c23          	sb	zero,24(s3)
    idx[i] = alloc_desc();
    800067e4:	00072023          	sw	zero,0(a4)
    if(idx[i] < 0){
    800067e8:	b3bd                	j	80006556 <virtio_disk_rw+0x60>

00000000800067ea <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800067ea:	1101                	addi	sp,sp,-32
    800067ec:	ec06                	sd	ra,24(sp)
    800067ee:	e822                	sd	s0,16(sp)
    800067f0:	e426                	sd	s1,8(sp)
    800067f2:	e04a                	sd	s2,0(sp)
    800067f4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800067f6:	00020517          	auipc	a0,0x20
    800067fa:	93250513          	addi	a0,a0,-1742 # 80026128 <disk+0x2128>
    800067fe:	ffffa097          	auipc	ra,0xffffa
    80006802:	434080e7          	jalr	1076(ra) # 80000c32 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006806:	10001737          	lui	a4,0x10001
    8000680a:	533c                	lw	a5,96(a4)
    8000680c:	8b8d                	andi	a5,a5,3
    8000680e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006810:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006814:	0001f797          	auipc	a5,0x1f
    80006818:	7ec78793          	addi	a5,a5,2028 # 80026000 <disk+0x2000>
    8000681c:	6b94                	ld	a3,16(a5)
    8000681e:	0207d703          	lhu	a4,32(a5)
    80006822:	0026d783          	lhu	a5,2(a3)
    80006826:	06f70163          	beq	a4,a5,80006888 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000682a:	0001d917          	auipc	s2,0x1d
    8000682e:	7d690913          	addi	s2,s2,2006 # 80024000 <disk>
    80006832:	0001f497          	auipc	s1,0x1f
    80006836:	7ce48493          	addi	s1,s1,1998 # 80026000 <disk+0x2000>
    __sync_synchronize();
    8000683a:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000683e:	6898                	ld	a4,16(s1)
    80006840:	0204d783          	lhu	a5,32(s1)
    80006844:	8b9d                	andi	a5,a5,7
    80006846:	078e                	slli	a5,a5,0x3
    80006848:	97ba                	add	a5,a5,a4
    8000684a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000684c:	20078713          	addi	a4,a5,512
    80006850:	0712                	slli	a4,a4,0x4
    80006852:	974a                	add	a4,a4,s2
    80006854:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80006858:	e731                	bnez	a4,800068a4 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000685a:	20078793          	addi	a5,a5,512
    8000685e:	0792                	slli	a5,a5,0x4
    80006860:	97ca                	add	a5,a5,s2
    80006862:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006864:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006868:	ffffc097          	auipc	ra,0xffffc
    8000686c:	c28080e7          	jalr	-984(ra) # 80002490 <wakeup>

    disk.used_idx += 1;
    80006870:	0204d783          	lhu	a5,32(s1)
    80006874:	2785                	addiw	a5,a5,1
    80006876:	17c2                	slli	a5,a5,0x30
    80006878:	93c1                	srli	a5,a5,0x30
    8000687a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000687e:	6898                	ld	a4,16(s1)
    80006880:	00275703          	lhu	a4,2(a4)
    80006884:	faf71be3          	bne	a4,a5,8000683a <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80006888:	00020517          	auipc	a0,0x20
    8000688c:	8a050513          	addi	a0,a0,-1888 # 80026128 <disk+0x2128>
    80006890:	ffffa097          	auipc	ra,0xffffa
    80006894:	456080e7          	jalr	1110(ra) # 80000ce6 <release>
}
    80006898:	60e2                	ld	ra,24(sp)
    8000689a:	6442                	ld	s0,16(sp)
    8000689c:	64a2                	ld	s1,8(sp)
    8000689e:	6902                	ld	s2,0(sp)
    800068a0:	6105                	addi	sp,sp,32
    800068a2:	8082                	ret
      panic("virtio_disk_intr status");
    800068a4:	00002517          	auipc	a0,0x2
    800068a8:	09c50513          	addi	a0,a0,156 # 80008940 <syscalls+0x4d8>
    800068ac:	ffffa097          	auipc	ra,0xffffa
    800068b0:	cba080e7          	jalr	-838(ra) # 80000566 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
