
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a7010113          	addi	sp,sp,-1424 # 80008a70 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
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
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	8de70713          	addi	a4,a4,-1826 # 80008930 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	58c78793          	addi	a5,a5,1420 # 800065f0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd924f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dca78793          	addi	a5,a5,-566 # 80000e78 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00003097          	auipc	ra,0x3
    80000130:	850080e7          	jalr	-1968(ra) # 8000297c <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8e650513          	addi	a0,a0,-1818 # 80010a70 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8d648493          	addi	s1,s1,-1834 # 80010a70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	96690913          	addi	s2,s2,-1690 # 80010b08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	820080e7          	jalr	-2016(ra) # 800019e0 <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	5fe080e7          	jalr	1534(ra) # 800027c6 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	2fa080e7          	jalr	762(ra) # 800024d0 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	714080e7          	jalr	1812(ra) # 80002926 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	84a50513          	addi	a0,a0,-1974 # 80010a70 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	83450513          	addi	a0,a0,-1996 # 80010a70 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a46080e7          	jalr	-1466(ra) # 80000c8a <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	88f72b23          	sw	a5,-1898(a4) # 80010b08 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54c080e7          	jalr	1356(ra) # 800007ea <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	540080e7          	jalr	1344(ra) # 800007ea <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	536080e7          	jalr	1334(ra) # 800007ea <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	7a450513          	addi	a0,a0,1956 # 80010a70 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	902080e7          	jalr	-1790(ra) # 80000bd6 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	6e0080e7          	jalr	1760(ra) # 800029d2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	77650513          	addi	a0,a0,1910 # 80010a70 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	988080e7          	jalr	-1656(ra) # 80000c8a <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	75270713          	addi	a4,a4,1874 # 80010a70 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	72878793          	addi	a5,a5,1832 # 80010a70 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7927a783          	lw	a5,1938(a5) # 80010b08 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6e670713          	addi	a4,a4,1766 # 80010a70 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6d648493          	addi	s1,s1,1750 # 80010a70 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	69a70713          	addi	a4,a4,1690 # 80010a70 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	72f72223          	sw	a5,1828(a4) # 80010b10 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	65e78793          	addi	a5,a5,1630 # 80010a70 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	6cc7ab23          	sw	a2,1750(a5) # 80010b0c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6ca50513          	addi	a0,a0,1738 # 80010b08 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	0ee080e7          	jalr	238(ra) # 80002534 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	61050513          	addi	a0,a0,1552 # 80010a70 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00024797          	auipc	a5,0x24
    8000047c:	fa078793          	addi	a5,a5,-96 # 80024418 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	2ae60613          	addi	a2,a2,686 # 80008768 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    buf[i++] = '-';
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00010797          	auipc	a5,0x10
    8000054e:	5e07a323          	sw	zero,1510(a5) # 80010b30 <pr+0x18>
  printf("panic: ");
    80000552:	00008517          	auipc	a0,0x8
    80000556:	ac650513          	addi	a0,a0,-1338 # 80008018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	ab450513          	addi	a0,a0,-1356 # 80008020 <etext+0x20>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00008717          	auipc	a4,0x8
    80000582:	36f72923          	sw	a5,882(a4) # 800088f0 <panicked>
  for(;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ba:	00010d97          	auipc	s11,0x10
    800005be:	576dad83          	lw	s11,1398(s11) # 80010b30 <pr+0x18>
  if(locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if(c != '%'){
    800005dc:	02500a93          	li	s5,37
    switch(c){
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00008b17          	auipc	s6,0x8
    800005ea:	182b0b13          	addi	s6,s6,386 # 80008768 <digits>
    switch(c){
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00010517          	auipc	a0,0x10
    800005fc:	52050513          	addi	a0,a0,1312 # 80010b18 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	5d6080e7          	jalr	1494(ra) # 80000bd6 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00008517          	auipc	a0,0x8
    8000060e:	a2650513          	addi	a0,a0,-1498 # 80008030 <etext+0x30>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if(c != '%'){
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch(c){
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch(c){
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for(; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00008497          	auipc	s1,0x8
    80000708:	92448493          	addi	s1,s1,-1756 # 80008028 <etext+0x28>
      for(; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if(locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    release(&pr.lock);
    80000756:	00010517          	auipc	a0,0x10
    8000075a:	3c250513          	addi	a0,a0,962 # 80010b18 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	52c080e7          	jalr	1324(ra) # 80000c8a <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00010497          	auipc	s1,0x10
    80000776:	3a648493          	addi	s1,s1,934 # 80010b18 <pr>
    8000077a:	00008597          	auipc	a1,0x8
    8000077e:	8c658593          	addi	a1,a1,-1850 # 80008040 <etext+0x40>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	3c2080e7          	jalr	962(ra) # 80000b46 <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00008597          	auipc	a1,0x8
    800007ce:	87e58593          	addi	a1,a1,-1922 # 80008048 <etext+0x48>
    800007d2:	00010517          	auipc	a0,0x10
    800007d6:	36650513          	addi	a0,a0,870 # 80010b38 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	36c080e7          	jalr	876(ra) # 80000b46 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	394080e7          	jalr	916(ra) # 80000b8a <push_off>

  if(panicked){
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	0f27a783          	lw	a5,242(a5) # 800088f0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for(;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	zext.b	a0,s1
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	406080e7          	jalr	1030(ra) # 80000c2a <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000836:	00008797          	auipc	a5,0x8
    8000083a:	0c27b783          	ld	a5,194(a5) # 800088f8 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	0c273703          	ld	a4,194(a4) # 80008900 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00010a17          	auipc	s4,0x10
    80000864:	2d8a0a13          	addi	s4,s4,728 # 80010b38 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	09048493          	addi	s1,s1,144 # 800088f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	09098993          	addi	s3,s3,144 # 80008900 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	ca2080e7          	jalr	-862(ra) # 80002534 <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00010517          	auipc	a0,0x10
    800008d2:	26a50513          	addi	a0,a0,618 # 80010b38 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	300080e7          	jalr	768(ra) # 80000bd6 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	0127a783          	lw	a5,18(a5) # 800088f0 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	01873703          	ld	a4,24(a4) # 80008900 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	0087b783          	ld	a5,8(a5) # 800088f8 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	23c98993          	addi	s3,s3,572 # 80010b38 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	ff448493          	addi	s1,s1,-12 # 800088f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	ff490913          	addi	s2,s2,-12 # 80008900 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	bb4080e7          	jalr	-1100(ra) # 800024d0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	20648493          	addi	s1,s1,518 # 80010b38 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	fae7bd23          	sd	a4,-70(a5) # 80008900 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	332080e7          	jalr	818(ra) # 80000c8a <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	zext.b	a0,a0
  } else {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00010497          	auipc	s1,0x10
    800009c0:	17c48493          	addi	s1,s1,380 # 80010b38 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	210080e7          	jalr	528(ra) # 80000bd6 <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	2b2080e7          	jalr	690(ra) # 80000c8a <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	e04a                	sd	s2,0(sp)
    800009f4:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f6:	03451793          	slli	a5,a0,0x34
    800009fa:	ebb9                	bnez	a5,80000a50 <kfree+0x66>
    800009fc:	84aa                	mv	s1,a0
    800009fe:	00025797          	auipc	a5,0x25
    80000a02:	bb278793          	addi	a5,a5,-1102 # 800255b0 <end>
    80000a06:	04f56563          	bltu	a0,a5,80000a50 <kfree+0x66>
    80000a0a:	47c5                	li	a5,17
    80000a0c:	07ee                	slli	a5,a5,0x1b
    80000a0e:	04f57163          	bgeu	a0,a5,80000a50 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4585                	li	a1,1
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	2bc080e7          	jalr	700(ra) # 80000cd2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1e:	00010917          	auipc	s2,0x10
    80000a22:	15290913          	addi	s2,s2,338 # 80010b70 <kmem>
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	1ae080e7          	jalr	430(ra) # 80000bd6 <acquire>
  r->next = kmem.freelist;
    80000a30:	01893783          	ld	a5,24(s2)
    80000a34:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a36:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a3a:	854a                	mv	a0,s2
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	24e080e7          	jalr	590(ra) # 80000c8a <release>
}
    80000a44:	60e2                	ld	ra,24(sp)
    80000a46:	6442                	ld	s0,16(sp)
    80000a48:	64a2                	ld	s1,8(sp)
    80000a4a:	6902                	ld	s2,0(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret
    panic("kfree");
    80000a50:	00007517          	auipc	a0,0x7
    80000a54:	60050513          	addi	a0,a0,1536 # 80008050 <etext+0x50>
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	ae6080e7          	jalr	-1306(ra) # 8000053e <panic>

0000000080000a60 <freerange>:
{
    80000a60:	7179                	addi	sp,sp,-48
    80000a62:	f406                	sd	ra,40(sp)
    80000a64:	f022                	sd	s0,32(sp)
    80000a66:	ec26                	sd	s1,24(sp)
    80000a68:	e84a                	sd	s2,16(sp)
    80000a6a:	e44e                	sd	s3,8(sp)
    80000a6c:	e052                	sd	s4,0(sp)
    80000a6e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a70:	6785                	lui	a5,0x1
    80000a72:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a76:	94aa                	add	s1,s1,a0
    80000a78:	757d                	lui	a0,0xfffff
    80000a7a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3a>
    80000a82:	892e                	mv	s2,a1
    kfree(p);
    80000a84:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	6985                	lui	s3,0x1
    kfree(p);
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5e080e7          	jalr	-162(ra) # 800009ea <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x28>
}
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
{
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5a658593          	addi	a1,a1,1446 # 80008058 <etext+0x58>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	0b650513          	addi	a0,a0,182 # 80010b70 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00025517          	auipc	a0,0x25
    80000ad2:	ae250513          	addi	a0,a0,-1310 # 800255b0 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f8a080e7          	jalr	-118(ra) # 80000a60 <freerange>
}
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	08048493          	addi	s1,s1,128 # 80010b70 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
  r = kmem.freelist;
    80000b02:	6c84                	ld	s1,24(s1)
  if(r)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	06850513          	addi	a0,a0,104 # 80010b70 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	178080e7          	jalr	376(ra) # 80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1b2080e7          	jalr	434(ra) # 80000cd2 <memset>
  return (void*)r;
}
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
  release(&kmem.lock);
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	03c50513          	addi	a0,a0,60 # 80010b70 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	14e080e7          	jalr	334(ra) # 80000c8a <release>
  if(r)
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e422                	sd	s0,8(sp)
    80000b4a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b4c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b52:	00053823          	sd	zero,16(a0)
}
    80000b56:	6422                	ld	s0,8(sp)
    80000b58:	0141                	addi	sp,sp,16
    80000b5a:	8082                	ret

0000000080000b5c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b5c:	411c                	lw	a5,0(a0)
    80000b5e:	e399                	bnez	a5,80000b64 <holding+0x8>
    80000b60:	4501                	li	a0,0
  return r;
}
    80000b62:	8082                	ret
{
    80000b64:	1101                	addi	sp,sp,-32
    80000b66:	ec06                	sd	ra,24(sp)
    80000b68:	e822                	sd	s0,16(sp)
    80000b6a:	e426                	sd	s1,8(sp)
    80000b6c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6e:	6904                	ld	s1,16(a0)
    80000b70:	00001097          	auipc	ra,0x1
    80000b74:	e54080e7          	jalr	-428(ra) # 800019c4 <mycpu>
    80000b78:	40a48533          	sub	a0,s1,a0
    80000b7c:	00153513          	seqz	a0,a0
}
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret

0000000080000b8a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b94:	100024f3          	csrr	s1,sstatus
    80000b98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b9c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ba2:	00001097          	auipc	ra,0x1
    80000ba6:	e22080e7          	jalr	-478(ra) # 800019c4 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cf89                	beqz	a5,80000bc6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	e16080e7          	jalr	-490(ra) # 800019c4 <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	2785                	addiw	a5,a5,1
    80000bba:	dd3c                	sw	a5,120(a0)
}
    80000bbc:	60e2                	ld	ra,24(sp)
    80000bbe:	6442                	ld	s0,16(sp)
    80000bc0:	64a2                	ld	s1,8(sp)
    80000bc2:	6105                	addi	sp,sp,32
    80000bc4:	8082                	ret
    mycpu()->intena = old;
    80000bc6:	00001097          	auipc	ra,0x1
    80000bca:	dfe080e7          	jalr	-514(ra) # 800019c4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bce:	8085                	srli	s1,s1,0x1
    80000bd0:	8885                	andi	s1,s1,1
    80000bd2:	dd64                	sw	s1,124(a0)
    80000bd4:	bfe9                	j	80000bae <push_off+0x24>

0000000080000bd6 <acquire>:
{
    80000bd6:	1101                	addi	sp,sp,-32
    80000bd8:	ec06                	sd	ra,24(sp)
    80000bda:	e822                	sd	s0,16(sp)
    80000bdc:	e426                	sd	s1,8(sp)
    80000bde:	1000                	addi	s0,sp,32
    80000be0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	fa8080e7          	jalr	-88(ra) # 80000b8a <push_off>
  if(holding(lk))
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	4705                	li	a4,1
  if(holding(lk))
    80000bf6:	e115                	bnez	a0,80000c1a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf8:	87ba                	mv	a5,a4
    80000bfa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfe:	2781                	sext.w	a5,a5
    80000c00:	ffe5                	bnez	a5,80000bf8 <acquire+0x22>
  __sync_synchronize();
    80000c02:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	dbe080e7          	jalr	-578(ra) # 800019c4 <mycpu>
    80000c0e:	e888                	sd	a0,16(s1)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    panic("acquire");
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	44650513          	addi	a0,a0,1094 # 80008060 <etext+0x60>
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	91c080e7          	jalr	-1764(ra) # 8000053e <panic>

0000000080000c2a <pop_off>:

void
pop_off(void)
{
    80000c2a:	1141                	addi	sp,sp,-16
    80000c2c:	e406                	sd	ra,8(sp)
    80000c2e:	e022                	sd	s0,0(sp)
    80000c30:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d92080e7          	jalr	-622(ra) # 800019c4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c40:	e78d                	bnez	a5,80000c6a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	02f05b63          	blez	a5,80000c7a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c48:	37fd                	addiw	a5,a5,-1
    80000c4a:	0007871b          	sext.w	a4,a5
    80000c4e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c50:	eb09                	bnez	a4,80000c62 <pop_off+0x38>
    80000c52:	5d7c                	lw	a5,124(a0)
    80000c54:	c799                	beqz	a5,80000c62 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    panic("pop_off - interruptible");
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	3fe50513          	addi	a0,a0,1022 # 80008068 <etext+0x68>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8cc080e7          	jalr	-1844(ra) # 8000053e <panic>
    panic("pop_off");
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	40650513          	addi	a0,a0,1030 # 80008080 <etext+0x80>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	8bc080e7          	jalr	-1860(ra) # 8000053e <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	ec6080e7          	jalr	-314(ra) # 80000b5c <holding>
    80000c9e:	c115                	beqz	a0,80000cc2 <release+0x38>
  lk->cpu = 0;
    80000ca0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	f7a080e7          	jalr	-134(ra) # 80000c2a <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3c650513          	addi	a0,a0,966 # 80008088 <etext+0x88>
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	874080e7          	jalr	-1932(ra) # 8000053e <panic>

0000000080000cd2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd2:	1141                	addi	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd8:	ca19                	beqz	a2,80000cee <memset+0x1c>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	1602                	slli	a2,a2,0x20
    80000cde:	9201                	srli	a2,a2,0x20
    80000ce0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce8:	0785                	addi	a5,a5,1
    80000cea:	fee79de3          	bne	a5,a4,80000ce4 <memset+0x12>
  }
  return dst;
}
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfa:	ca05                	beqz	a2,80000d2a <memcmp+0x36>
    80000cfc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d00:	1682                	slli	a3,a3,0x20
    80000d02:	9281                	srli	a3,a3,0x20
    80000d04:	0685                	addi	a3,a3,1
    80000d06:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d08:	00054783          	lbu	a5,0(a0)
    80000d0c:	0005c703          	lbu	a4,0(a1)
    80000d10:	00e79863          	bne	a5,a4,80000d20 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d14:	0505                	addi	a0,a0,1
    80000d16:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d18:	fed518e3          	bne	a0,a3,80000d08 <memcmp+0x14>
  }

  return 0;
    80000d1c:	4501                	li	a0,0
    80000d1e:	a019                	j	80000d24 <memcmp+0x30>
      return *s1 - *s2;
    80000d20:	40e7853b          	subw	a0,a5,a4
}
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
  return 0;
    80000d2a:	4501                	li	a0,0
    80000d2c:	bfe5                	j	80000d24 <memcmp+0x30>

0000000080000d2e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d34:	c205                	beqz	a2,80000d54 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d36:	02a5e263          	bltu	a1,a0,80000d5a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d3a:	1602                	slli	a2,a2,0x20
    80000d3c:	9201                	srli	a2,a2,0x20
    80000d3e:	00c587b3          	add	a5,a1,a2
{
    80000d42:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d44:	0585                	addi	a1,a1,1
    80000d46:	0705                	addi	a4,a4,1
    80000d48:	fff5c683          	lbu	a3,-1(a1)
    80000d4c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d50:	fef59ae3          	bne	a1,a5,80000d44 <memmove+0x16>

  return dst;
}
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
  if(s < d && s + n > d){
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57be3          	bgeu	a0,a4,80000d3a <memmove+0xc>
    d += n;
    80000d68:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4a>
    80000d88:	b7f1                	j	80000d54 <memmove+0x26>

0000000080000d8a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	f9c080e7          	jalr	-100(ra) # 80000d2e <memmove>
}
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a809                	j	80000dd4 <strncmp+0x32>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a039                	j	80000dd4 <strncmp+0x32>
  if(n == 0)
    80000dc8:	ca09                	beqz	a2,80000dda <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dca:	00054503          	lbu	a0,0(a0)
    80000dce:	0005c783          	lbu	a5,0(a1)
    80000dd2:	9d1d                	subw	a0,a0,a5
}
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
    return 0;
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <strncmp+0x32>

0000000080000dde <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de4:	872a                	mv	a4,a0
    80000de6:	8832                	mv	a6,a2
    80000de8:	367d                	addiw	a2,a2,-1
    80000dea:	01005963          	blez	a6,80000dfc <strncpy+0x1e>
    80000dee:	0705                	addi	a4,a4,1
    80000df0:	0005c783          	lbu	a5,0(a1)
    80000df4:	fef70fa3          	sb	a5,-1(a4)
    80000df8:	0585                	addi	a1,a1,1
    80000dfa:	f7f5                	bnez	a5,80000de6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfc:	86ba                	mv	a3,a4
    80000dfe:	00c05c63          	blez	a2,80000e16 <strncpy+0x38>
    *s++ = 0;
    80000e02:	0685                	addi	a3,a3,1
    80000e04:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e08:	fff6c793          	not	a5,a3
    80000e0c:	9fb9                	addw	a5,a5,a4
    80000e0e:	010787bb          	addw	a5,a5,a6
    80000e12:	fef048e3          	bgtz	a5,80000e02 <strncpy+0x24>
  return os;
}
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e22:	02c05363          	blez	a2,80000e48 <safestrcpy+0x2c>
    80000e26:	fff6069b          	addiw	a3,a2,-1
    80000e2a:	1682                	slli	a3,a3,0x20
    80000e2c:	9281                	srli	a3,a3,0x20
    80000e2e:	96ae                	add	a3,a3,a1
    80000e30:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e32:	00d58963          	beq	a1,a3,80000e44 <safestrcpy+0x28>
    80000e36:	0585                	addi	a1,a1,1
    80000e38:	0785                	addi	a5,a5,1
    80000e3a:	fff5c703          	lbu	a4,-1(a1)
    80000e3e:	fee78fa3          	sb	a4,-1(a5)
    80000e42:	fb65                	bnez	a4,80000e32 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e44:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:

int
strlen(const char *s)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e54:	00054783          	lbu	a5,0(a0)
    80000e58:	cf91                	beqz	a5,80000e74 <strlen+0x26>
    80000e5a:	0505                	addi	a0,a0,1
    80000e5c:	87aa                	mv	a5,a0
    80000e5e:	4685                	li	a3,1
    80000e60:	9e89                	subw	a3,a3,a0
    80000e62:	00f6853b          	addw	a0,a3,a5
    80000e66:	0785                	addi	a5,a5,1
    80000e68:	fff7c703          	lbu	a4,-1(a5)
    80000e6c:	fb7d                	bnez	a4,80000e62 <strlen+0x14>
    ;
  return n;
}
    80000e6e:	6422                	ld	s0,8(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e74:	4501                	li	a0,0
    80000e76:	bfe5                	j	80000e6e <strlen+0x20>

0000000080000e78 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e406                	sd	ra,8(sp)
    80000e7c:	e022                	sd	s0,0(sp)
    80000e7e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e80:	00001097          	auipc	ra,0x1
    80000e84:	b34080e7          	jalr	-1228(ra) # 800019b4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e88:	00008717          	auipc	a4,0x8
    80000e8c:	a8070713          	addi	a4,a4,-1408 # 80008908 <started>
  if(cpuid() == 0){
    80000e90:	c139                	beqz	a0,80000ed6 <main+0x5e>
    while(started == 0)
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x1a>
      ;
    __sync_synchronize();
    80000e98:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	b18080e7          	jalr	-1256(ra) # 800019b4 <cpuid>
    80000ea4:	85aa                	mv	a1,a0
    80000ea6:	00007517          	auipc	a0,0x7
    80000eaa:	20250513          	addi	a0,a0,514 # 800080a8 <etext+0xa8>
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	6da080e7          	jalr	1754(ra) # 80000588 <printf>
    kvminithart();    // turn on paging
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	0d8080e7          	jalr	216(ra) # 80000f8e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ebe:	00002097          	auipc	ra,0x2
    80000ec2:	e9e080e7          	jalr	-354(ra) # 80002d5c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	76a080e7          	jalr	1898(ra) # 80006630 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	274080e7          	jalr	628(ra) # 80002142 <scheduler>
    consoleinit();
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	57a080e7          	jalr	1402(ra) # 80000450 <consoleinit>
    printfinit();
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	88a080e7          	jalr	-1910(ra) # 80000768 <printfinit>
    printf("\n");
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	13a50513          	addi	a0,a0,314 # 80008020 <etext+0x20>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	69a080e7          	jalr	1690(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    80000ef6:	00007517          	auipc	a0,0x7
    80000efa:	19a50513          	addi	a0,a0,410 # 80008090 <etext+0x90>
    80000efe:	fffff097          	auipc	ra,0xfffff
    80000f02:	68a080e7          	jalr	1674(ra) # 80000588 <printf>
    printf("\n");
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	11a50513          	addi	a0,a0,282 # 80008020 <etext+0x20>
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	67a080e7          	jalr	1658(ra) # 80000588 <printf>
    kinit();         // physical page allocator
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	b94080e7          	jalr	-1132(ra) # 80000aaa <kinit>
    kvminit();       // create kernel page table
    80000f1e:	00000097          	auipc	ra,0x0
    80000f22:	326080e7          	jalr	806(ra) # 80001244 <kvminit>
    kvminithart();   // turn on paging
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	068080e7          	jalr	104(ra) # 80000f8e <kvminithart>
    procinit();      // process table
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	99e080e7          	jalr	-1634(ra) # 800018cc <procinit>
    trapinit();      // trap vectors
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	dfe080e7          	jalr	-514(ra) # 80002d34 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00002097          	auipc	ra,0x2
    80000f42:	e1e080e7          	jalr	-482(ra) # 80002d5c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	6d4080e7          	jalr	1748(ra) # 8000661a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	6e2080e7          	jalr	1762(ra) # 80006630 <plicinithart>
    binit();         // buffer cache
    80000f56:	00003097          	auipc	ra,0x3
    80000f5a:	880080e7          	jalr	-1920(ra) # 800037d6 <binit>
    iinit();         // inode table
    80000f5e:	00003097          	auipc	ra,0x3
    80000f62:	f24080e7          	jalr	-220(ra) # 80003e82 <iinit>
    fileinit();      // file table
    80000f66:	00004097          	auipc	ra,0x4
    80000f6a:	ec2080e7          	jalr	-318(ra) # 80004e28 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	7ca080e7          	jalr	1994(ra) # 80006738 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	f1a080e7          	jalr	-230(ra) # 80001e90 <userinit>
    __sync_synchronize();
    80000f7e:	0ff0000f          	fence
    started = 1;
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	98f72223          	sw	a5,-1660(a4) # 80008908 <started>
    80000f8c:	b789                	j	80000ece <main+0x56>

0000000080000f8e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e422                	sd	s0,8(sp)
    80000f92:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f94:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	9787b783          	ld	a5,-1672(a5) # 80008910 <kernel_pagetable>
    80000fa0:	83b1                	srli	a5,a5,0xc
    80000fa2:	577d                	li	a4,-1
    80000fa4:	177e                	slli	a4,a4,0x3f
    80000fa6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000fac:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000fb0:	6422                	ld	s0,8(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret

0000000080000fb6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb6:	7139                	addi	sp,sp,-64
    80000fb8:	fc06                	sd	ra,56(sp)
    80000fba:	f822                	sd	s0,48(sp)
    80000fbc:	f426                	sd	s1,40(sp)
    80000fbe:	f04a                	sd	s2,32(sp)
    80000fc0:	ec4e                	sd	s3,24(sp)
    80000fc2:	e852                	sd	s4,16(sp)
    80000fc4:	e456                	sd	s5,8(sp)
    80000fc6:	e05a                	sd	s6,0(sp)
    80000fc8:	0080                	addi	s0,sp,64
    80000fca:	84aa                	mv	s1,a0
    80000fcc:	89ae                	mv	s3,a1
    80000fce:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fd0:	57fd                	li	a5,-1
    80000fd2:	83e9                	srli	a5,a5,0x1a
    80000fd4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd8:	04b7f263          	bgeu	a5,a1,8000101c <walk+0x66>
    panic("walk");
    80000fdc:	00007517          	auipc	a0,0x7
    80000fe0:	0e450513          	addi	a0,a0,228 # 800080c0 <etext+0xc0>
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	55a080e7          	jalr	1370(ra) # 8000053e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fec:	060a8663          	beqz	s5,80001058 <walk+0xa2>
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	af6080e7          	jalr	-1290(ra) # 80000ae6 <kalloc>
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	c529                	beqz	a0,80001044 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffc:	6605                	lui	a2,0x1
    80000ffe:	4581                	li	a1,0
    80001000:	00000097          	auipc	ra,0x0
    80001004:	cd2080e7          	jalr	-814(ra) # 80000cd2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001008:	00c4d793          	srli	a5,s1,0xc
    8000100c:	07aa                	slli	a5,a5,0xa
    8000100e:	0017e793          	ori	a5,a5,1
    80001012:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001016:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd9a47>
    80001018:	036a0063          	beq	s4,s6,80001038 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101c:	0149d933          	srl	s2,s3,s4
    80001020:	1ff97913          	andi	s2,s2,511
    80001024:	090e                	slli	s2,s2,0x3
    80001026:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001028:	00093483          	ld	s1,0(s2)
    8000102c:	0014f793          	andi	a5,s1,1
    80001030:	dfd5                	beqz	a5,80000fec <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001032:	80a9                	srli	s1,s1,0xa
    80001034:	04b2                	slli	s1,s1,0xc
    80001036:	b7c5                	j	80001016 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001038:	00c9d513          	srli	a0,s3,0xc
    8000103c:	1ff57513          	andi	a0,a0,511
    80001040:	050e                	slli	a0,a0,0x3
    80001042:	9526                	add	a0,a0,s1
}
    80001044:	70e2                	ld	ra,56(sp)
    80001046:	7442                	ld	s0,48(sp)
    80001048:	74a2                	ld	s1,40(sp)
    8000104a:	7902                	ld	s2,32(sp)
    8000104c:	69e2                	ld	s3,24(sp)
    8000104e:	6a42                	ld	s4,16(sp)
    80001050:	6aa2                	ld	s5,8(sp)
    80001052:	6b02                	ld	s6,0(sp)
    80001054:	6121                	addi	sp,sp,64
    80001056:	8082                	ret
        return 0;
    80001058:	4501                	li	a0,0
    8000105a:	b7ed                	j	80001044 <walk+0x8e>

000000008000105c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105c:	57fd                	li	a5,-1
    8000105e:	83e9                	srli	a5,a5,0x1a
    80001060:	00b7f463          	bgeu	a5,a1,80001068 <walkaddr+0xc>
    return 0;
    80001064:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001066:	8082                	ret
{
    80001068:	1141                	addi	sp,sp,-16
    8000106a:	e406                	sd	ra,8(sp)
    8000106c:	e022                	sd	s0,0(sp)
    8000106e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001070:	4601                	li	a2,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	f44080e7          	jalr	-188(ra) # 80000fb6 <walk>
  if(pte == 0)
    8000107a:	c105                	beqz	a0,8000109a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107e:	0117f693          	andi	a3,a5,17
    80001082:	4745                	li	a4,17
    return 0;
    80001084:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001086:	00e68663          	beq	a3,a4,80001092 <walkaddr+0x36>
}
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	addi	sp,sp,16
    80001090:	8082                	ret
  pa = PTE2PA(*pte);
    80001092:	00a7d513          	srli	a0,a5,0xa
    80001096:	0532                	slli	a0,a0,0xc
  return pa;
    80001098:	bfcd                	j	8000108a <walkaddr+0x2e>
    return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7fd                	j	8000108a <walkaddr+0x2e>

000000008000109e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109e:	715d                	addi	sp,sp,-80
    800010a0:	e486                	sd	ra,72(sp)
    800010a2:	e0a2                	sd	s0,64(sp)
    800010a4:	fc26                	sd	s1,56(sp)
    800010a6:	f84a                	sd	s2,48(sp)
    800010a8:	f44e                	sd	s3,40(sp)
    800010aa:	f052                	sd	s4,32(sp)
    800010ac:	ec56                	sd	s5,24(sp)
    800010ae:	e85a                	sd	s6,16(sp)
    800010b0:	e45e                	sd	s7,8(sp)
    800010b2:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010b4:	c639                	beqz	a2,80001102 <mappages+0x64>
    800010b6:	8aaa                	mv	s5,a0
    800010b8:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010ba:	77fd                	lui	a5,0xfffff
    800010bc:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800010c0:	15fd                	addi	a1,a1,-1
    800010c2:	00c589b3          	add	s3,a1,a2
    800010c6:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800010ca:	8952                	mv	s2,s4
    800010cc:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010d0:	6b85                	lui	s7,0x1
    800010d2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d6:	4605                	li	a2,1
    800010d8:	85ca                	mv	a1,s2
    800010da:	8556                	mv	a0,s5
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	eda080e7          	jalr	-294(ra) # 80000fb6 <walk>
    800010e4:	cd1d                	beqz	a0,80001122 <mappages+0x84>
    if(*pte & PTE_V)
    800010e6:	611c                	ld	a5,0(a0)
    800010e8:	8b85                	andi	a5,a5,1
    800010ea:	e785                	bnez	a5,80001112 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010ec:	80b1                	srli	s1,s1,0xc
    800010ee:	04aa                	slli	s1,s1,0xa
    800010f0:	0164e4b3          	or	s1,s1,s6
    800010f4:	0014e493          	ori	s1,s1,1
    800010f8:	e104                	sd	s1,0(a0)
    if(a == last)
    800010fa:	05390063          	beq	s2,s3,8000113a <mappages+0x9c>
    a += PGSIZE;
    800010fe:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001100:	bfc9                	j	800010d2 <mappages+0x34>
    panic("mappages: size");
    80001102:	00007517          	auipc	a0,0x7
    80001106:	fc650513          	addi	a0,a0,-58 # 800080c8 <etext+0xc8>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	434080e7          	jalr	1076(ra) # 8000053e <panic>
      panic("mappages: remap");
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fc650513          	addi	a0,a0,-58 # 800080d8 <etext+0xd8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	424080e7          	jalr	1060(ra) # 8000053e <panic>
      return -1;
    80001122:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001124:	60a6                	ld	ra,72(sp)
    80001126:	6406                	ld	s0,64(sp)
    80001128:	74e2                	ld	s1,56(sp)
    8000112a:	7942                	ld	s2,48(sp)
    8000112c:	79a2                	ld	s3,40(sp)
    8000112e:	7a02                	ld	s4,32(sp)
    80001130:	6ae2                	ld	s5,24(sp)
    80001132:	6b42                	ld	s6,16(sp)
    80001134:	6ba2                	ld	s7,8(sp)
    80001136:	6161                	addi	sp,sp,80
    80001138:	8082                	ret
  return 0;
    8000113a:	4501                	li	a0,0
    8000113c:	b7e5                	j	80001124 <mappages+0x86>

000000008000113e <kvmmap>:
{
    8000113e:	1141                	addi	sp,sp,-16
    80001140:	e406                	sd	ra,8(sp)
    80001142:	e022                	sd	s0,0(sp)
    80001144:	0800                	addi	s0,sp,16
    80001146:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001148:	86b2                	mv	a3,a2
    8000114a:	863e                	mv	a2,a5
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f52080e7          	jalr	-174(ra) # 8000109e <mappages>
    80001154:	e509                	bnez	a0,8000115e <kvmmap+0x20>
}
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
    panic("kvmmap");
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f8a50513          	addi	a0,a0,-118 # 800080e8 <etext+0xe8>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3d8080e7          	jalr	984(ra) # 8000053e <panic>

000000008000116e <kvmmake>:
{
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	e04a                	sd	s2,0(sp)
    80001178:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	96c080e7          	jalr	-1684(ra) # 80000ae6 <kalloc>
    80001182:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001184:	6605                	lui	a2,0x1
    80001186:	4581                	li	a1,0
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	b4a080e7          	jalr	-1206(ra) # 80000cd2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001190:	4719                	li	a4,6
    80001192:	6685                	lui	a3,0x1
    80001194:	10000637          	lui	a2,0x10000
    80001198:	100005b7          	lui	a1,0x10000
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	fa0080e7          	jalr	-96(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a6:	4719                	li	a4,6
    800011a8:	6685                	lui	a3,0x1
    800011aa:	10001637          	lui	a2,0x10001
    800011ae:	100015b7          	lui	a1,0x10001
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f8a080e7          	jalr	-118(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011bc:	4719                	li	a4,6
    800011be:	004006b7          	lui	a3,0x400
    800011c2:	0c000637          	lui	a2,0xc000
    800011c6:	0c0005b7          	lui	a1,0xc000
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f72080e7          	jalr	-142(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011d4:	00007917          	auipc	s2,0x7
    800011d8:	e2c90913          	addi	s2,s2,-468 # 80008000 <etext>
    800011dc:	4729                	li	a4,10
    800011de:	80007697          	auipc	a3,0x80007
    800011e2:	e2268693          	addi	a3,a3,-478 # 8000 <_entry-0x7fff8000>
    800011e6:	4605                	li	a2,1
    800011e8:	067e                	slli	a2,a2,0x1f
    800011ea:	85b2                	mv	a1,a2
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f50080e7          	jalr	-176(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f6:	4719                	li	a4,6
    800011f8:	46c5                	li	a3,17
    800011fa:	06ee                	slli	a3,a3,0x1b
    800011fc:	412686b3          	sub	a3,a3,s2
    80001200:	864a                	mv	a2,s2
    80001202:	85ca                	mv	a1,s2
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	f38080e7          	jalr	-200(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000120e:	4729                	li	a4,10
    80001210:	6685                	lui	a3,0x1
    80001212:	00006617          	auipc	a2,0x6
    80001216:	dee60613          	addi	a2,a2,-530 # 80007000 <_trampoline>
    8000121a:	040005b7          	lui	a1,0x4000
    8000121e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001220:	05b2                	slli	a1,a1,0xc
    80001222:	8526                	mv	a0,s1
    80001224:	00000097          	auipc	ra,0x0
    80001228:	f1a080e7          	jalr	-230(ra) # 8000113e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	608080e7          	jalr	1544(ra) # 80001836 <proc_mapstacks>
}
    80001236:	8526                	mv	a0,s1
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6902                	ld	s2,0(sp)
    80001240:	6105                	addi	sp,sp,32
    80001242:	8082                	ret

0000000080001244 <kvminit>:
{
    80001244:	1141                	addi	sp,sp,-16
    80001246:	e406                	sd	ra,8(sp)
    80001248:	e022                	sd	s0,0(sp)
    8000124a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f22080e7          	jalr	-222(ra) # 8000116e <kvmmake>
    80001254:	00007797          	auipc	a5,0x7
    80001258:	6aa7be23          	sd	a0,1724(a5) # 80008910 <kernel_pagetable>
}
    8000125c:	60a2                	ld	ra,8(sp)
    8000125e:	6402                	ld	s0,0(sp)
    80001260:	0141                	addi	sp,sp,16
    80001262:	8082                	ret

0000000080001264 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001264:	715d                	addi	sp,sp,-80
    80001266:	e486                	sd	ra,72(sp)
    80001268:	e0a2                	sd	s0,64(sp)
    8000126a:	fc26                	sd	s1,56(sp)
    8000126c:	f84a                	sd	s2,48(sp)
    8000126e:	f44e                	sd	s3,40(sp)
    80001270:	f052                	sd	s4,32(sp)
    80001272:	ec56                	sd	s5,24(sp)
    80001274:	e85a                	sd	s6,16(sp)
    80001276:	e45e                	sd	s7,8(sp)
    80001278:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000127a:	03459793          	slli	a5,a1,0x34
    8000127e:	e795                	bnez	a5,800012aa <uvmunmap+0x46>
    80001280:	8a2a                	mv	s4,a0
    80001282:	892e                	mv	s2,a1
    80001284:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001286:	0632                	slli	a2,a2,0xc
    80001288:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000128c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000128e:	6b05                	lui	s6,0x1
    80001290:	0735e263          	bltu	a1,s3,800012f4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	74e2                	ld	s1,56(sp)
    8000129a:	7942                	ld	s2,48(sp)
    8000129c:	79a2                	ld	s3,40(sp)
    8000129e:	7a02                	ld	s4,32(sp)
    800012a0:	6ae2                	ld	s5,24(sp)
    800012a2:	6b42                	ld	s6,16(sp)
    800012a4:	6ba2                	ld	s7,8(sp)
    800012a6:	6161                	addi	sp,sp,80
    800012a8:	8082                	ret
    panic("uvmunmap: not aligned");
    800012aa:	00007517          	auipc	a0,0x7
    800012ae:	e4650513          	addi	a0,a0,-442 # 800080f0 <etext+0xf0>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	28c080e7          	jalr	652(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    800012ba:	00007517          	auipc	a0,0x7
    800012be:	e4e50513          	addi	a0,a0,-434 # 80008108 <etext+0x108>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	27c080e7          	jalr	636(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    800012ca:	00007517          	auipc	a0,0x7
    800012ce:	e4e50513          	addi	a0,a0,-434 # 80008118 <etext+0x118>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	26c080e7          	jalr	620(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    800012da:	00007517          	auipc	a0,0x7
    800012de:	e5650513          	addi	a0,a0,-426 # 80008130 <etext+0x130>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	25c080e7          	jalr	604(ra) # 8000053e <panic>
    *pte = 0;
    800012ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ee:	995a                	add	s2,s2,s6
    800012f0:	fb3972e3          	bgeu	s2,s3,80001294 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012f4:	4601                	li	a2,0
    800012f6:	85ca                	mv	a1,s2
    800012f8:	8552                	mv	a0,s4
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	cbc080e7          	jalr	-836(ra) # 80000fb6 <walk>
    80001302:	84aa                	mv	s1,a0
    80001304:	d95d                	beqz	a0,800012ba <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001306:	6108                	ld	a0,0(a0)
    80001308:	00157793          	andi	a5,a0,1
    8000130c:	dfdd                	beqz	a5,800012ca <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000130e:	3ff57793          	andi	a5,a0,1023
    80001312:	fd7784e3          	beq	a5,s7,800012da <uvmunmap+0x76>
    if(do_free){
    80001316:	fc0a8ae3          	beqz	s5,800012ea <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000131a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000131c:	0532                	slli	a0,a0,0xc
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	6cc080e7          	jalr	1740(ra) # 800009ea <kfree>
    80001326:	b7d1                	j	800012ea <uvmunmap+0x86>

0000000080001328 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	7b4080e7          	jalr	1972(ra) # 80000ae6 <kalloc>
    8000133a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000133c:	c519                	beqz	a0,8000134a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000133e:	6605                	lui	a2,0x1
    80001340:	4581                	li	a1,0
    80001342:	00000097          	auipc	ra,0x0
    80001346:	990080e7          	jalr	-1648(ra) # 80000cd2 <memset>
  return pagetable;
}
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001356:	7179                	addi	sp,sp,-48
    80001358:	f406                	sd	ra,40(sp)
    8000135a:	f022                	sd	s0,32(sp)
    8000135c:	ec26                	sd	s1,24(sp)
    8000135e:	e84a                	sd	s2,16(sp)
    80001360:	e44e                	sd	s3,8(sp)
    80001362:	e052                	sd	s4,0(sp)
    80001364:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001366:	6785                	lui	a5,0x1
    80001368:	04f67863          	bgeu	a2,a5,800013b8 <uvmfirst+0x62>
    8000136c:	8a2a                	mv	s4,a0
    8000136e:	89ae                	mv	s3,a1
    80001370:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	774080e7          	jalr	1908(ra) # 80000ae6 <kalloc>
    8000137a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000137c:	6605                	lui	a2,0x1
    8000137e:	4581                	li	a1,0
    80001380:	00000097          	auipc	ra,0x0
    80001384:	952080e7          	jalr	-1710(ra) # 80000cd2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001388:	4779                	li	a4,30
    8000138a:	86ca                	mv	a3,s2
    8000138c:	6605                	lui	a2,0x1
    8000138e:	4581                	li	a1,0
    80001390:	8552                	mv	a0,s4
    80001392:	00000097          	auipc	ra,0x0
    80001396:	d0c080e7          	jalr	-756(ra) # 8000109e <mappages>
  memmove(mem, src, sz);
    8000139a:	8626                	mv	a2,s1
    8000139c:	85ce                	mv	a1,s3
    8000139e:	854a                	mv	a0,s2
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	98e080e7          	jalr	-1650(ra) # 80000d2e <memmove>
}
    800013a8:	70a2                	ld	ra,40(sp)
    800013aa:	7402                	ld	s0,32(sp)
    800013ac:	64e2                	ld	s1,24(sp)
    800013ae:	6942                	ld	s2,16(sp)
    800013b0:	69a2                	ld	s3,8(sp)
    800013b2:	6a02                	ld	s4,0(sp)
    800013b4:	6145                	addi	sp,sp,48
    800013b6:	8082                	ret
    panic("uvmfirst: more than a page");
    800013b8:	00007517          	auipc	a0,0x7
    800013bc:	d9050513          	addi	a0,a0,-624 # 80008148 <etext+0x148>
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	17e080e7          	jalr	382(ra) # 8000053e <panic>

00000000800013c8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013c8:	1101                	addi	sp,sp,-32
    800013ca:	ec06                	sd	ra,24(sp)
    800013cc:	e822                	sd	s0,16(sp)
    800013ce:	e426                	sd	s1,8(sp)
    800013d0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013d2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013d4:	00b67d63          	bgeu	a2,a1,800013ee <uvmdealloc+0x26>
    800013d8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013da:	6785                	lui	a5,0x1
    800013dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013de:	00f60733          	add	a4,a2,a5
    800013e2:	767d                	lui	a2,0xfffff
    800013e4:	8f71                	and	a4,a4,a2
    800013e6:	97ae                	add	a5,a5,a1
    800013e8:	8ff1                	and	a5,a5,a2
    800013ea:	00f76863          	bltu	a4,a5,800013fa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013fa:	8f99                	sub	a5,a5,a4
    800013fc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013fe:	4685                	li	a3,1
    80001400:	0007861b          	sext.w	a2,a5
    80001404:	85ba                	mv	a1,a4
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	e5e080e7          	jalr	-418(ra) # 80001264 <uvmunmap>
    8000140e:	b7c5                	j	800013ee <uvmdealloc+0x26>

0000000080001410 <uvmalloc>:
  if(newsz < oldsz)
    80001410:	0ab66563          	bltu	a2,a1,800014ba <uvmalloc+0xaa>
{
    80001414:	7139                	addi	sp,sp,-64
    80001416:	fc06                	sd	ra,56(sp)
    80001418:	f822                	sd	s0,48(sp)
    8000141a:	f426                	sd	s1,40(sp)
    8000141c:	f04a                	sd	s2,32(sp)
    8000141e:	ec4e                	sd	s3,24(sp)
    80001420:	e852                	sd	s4,16(sp)
    80001422:	e456                	sd	s5,8(sp)
    80001424:	e05a                	sd	s6,0(sp)
    80001426:	0080                	addi	s0,sp,64
    80001428:	8aaa                	mv	s5,a0
    8000142a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000142c:	6985                	lui	s3,0x1
    8000142e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80001430:	95ce                	add	a1,a1,s3
    80001432:	79fd                	lui	s3,0xfffff
    80001434:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001438:	08c9f363          	bgeu	s3,a2,800014be <uvmalloc+0xae>
    8000143c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000143e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	6a4080e7          	jalr	1700(ra) # 80000ae6 <kalloc>
    8000144a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000144c:	c51d                	beqz	a0,8000147a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000144e:	6605                	lui	a2,0x1
    80001450:	4581                	li	a1,0
    80001452:	00000097          	auipc	ra,0x0
    80001456:	880080e7          	jalr	-1920(ra) # 80000cd2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000145a:	875a                	mv	a4,s6
    8000145c:	86a6                	mv	a3,s1
    8000145e:	6605                	lui	a2,0x1
    80001460:	85ca                	mv	a1,s2
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	c3a080e7          	jalr	-966(ra) # 8000109e <mappages>
    8000146c:	e90d                	bnez	a0,8000149e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000146e:	6785                	lui	a5,0x1
    80001470:	993e                	add	s2,s2,a5
    80001472:	fd4968e3          	bltu	s2,s4,80001442 <uvmalloc+0x32>
  return newsz;
    80001476:	8552                	mv	a0,s4
    80001478:	a809                	j	8000148a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000147a:	864e                	mv	a2,s3
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	f48080e7          	jalr	-184(ra) # 800013c8 <uvmdealloc>
      return 0;
    80001488:	4501                	li	a0,0
}
    8000148a:	70e2                	ld	ra,56(sp)
    8000148c:	7442                	ld	s0,48(sp)
    8000148e:	74a2                	ld	s1,40(sp)
    80001490:	7902                	ld	s2,32(sp)
    80001492:	69e2                	ld	s3,24(sp)
    80001494:	6a42                	ld	s4,16(sp)
    80001496:	6aa2                	ld	s5,8(sp)
    80001498:	6b02                	ld	s6,0(sp)
    8000149a:	6121                	addi	sp,sp,64
    8000149c:	8082                	ret
      kfree(mem);
    8000149e:	8526                	mv	a0,s1
    800014a0:	fffff097          	auipc	ra,0xfffff
    800014a4:	54a080e7          	jalr	1354(ra) # 800009ea <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014a8:	864e                	mv	a2,s3
    800014aa:	85ca                	mv	a1,s2
    800014ac:	8556                	mv	a0,s5
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	f1a080e7          	jalr	-230(ra) # 800013c8 <uvmdealloc>
      return 0;
    800014b6:	4501                	li	a0,0
    800014b8:	bfc9                	j	8000148a <uvmalloc+0x7a>
    return oldsz;
    800014ba:	852e                	mv	a0,a1
}
    800014bc:	8082                	ret
  return newsz;
    800014be:	8532                	mv	a0,a2
    800014c0:	b7e9                	j	8000148a <uvmalloc+0x7a>

00000000800014c2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	e052                	sd	s4,0(sp)
    800014d0:	1800                	addi	s0,sp,48
    800014d2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014d4:	84aa                	mv	s1,a0
    800014d6:	6905                	lui	s2,0x1
    800014d8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014da:	4985                	li	s3,1
    800014dc:	a821                	j	800014f4 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014de:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014e0:	0532                	slli	a0,a0,0xc
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	fe0080e7          	jalr	-32(ra) # 800014c2 <freewalk>
      pagetable[i] = 0;
    800014ea:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014ee:	04a1                	addi	s1,s1,8
    800014f0:	03248163          	beq	s1,s2,80001512 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014f4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f6:	00f57793          	andi	a5,a0,15
    800014fa:	ff3782e3          	beq	a5,s3,800014de <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014fe:	8905                	andi	a0,a0,1
    80001500:	d57d                	beqz	a0,800014ee <freewalk+0x2c>
      panic("freewalk: leaf");
    80001502:	00007517          	auipc	a0,0x7
    80001506:	c6650513          	addi	a0,a0,-922 # 80008168 <etext+0x168>
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	034080e7          	jalr	52(ra) # 8000053e <panic>
    }
  }
  kfree((void*)pagetable);
    80001512:	8552                	mv	a0,s4
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	4d6080e7          	jalr	1238(ra) # 800009ea <kfree>
}
    8000151c:	70a2                	ld	ra,40(sp)
    8000151e:	7402                	ld	s0,32(sp)
    80001520:	64e2                	ld	s1,24(sp)
    80001522:	6942                	ld	s2,16(sp)
    80001524:	69a2                	ld	s3,8(sp)
    80001526:	6a02                	ld	s4,0(sp)
    80001528:	6145                	addi	sp,sp,48
    8000152a:	8082                	ret

000000008000152c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
    80001536:	84aa                	mv	s1,a0
  if(sz > 0)
    80001538:	e999                	bnez	a1,8000154e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000153a:	8526                	mv	a0,s1
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f86080e7          	jalr	-122(ra) # 800014c2 <freewalk>
}
    80001544:	60e2                	ld	ra,24(sp)
    80001546:	6442                	ld	s0,16(sp)
    80001548:	64a2                	ld	s1,8(sp)
    8000154a:	6105                	addi	sp,sp,32
    8000154c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000154e:	6605                	lui	a2,0x1
    80001550:	167d                	addi	a2,a2,-1 # fff <_entry-0x7ffff001>
    80001552:	962e                	add	a2,a2,a1
    80001554:	4685                	li	a3,1
    80001556:	8231                	srli	a2,a2,0xc
    80001558:	4581                	li	a1,0
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	d0a080e7          	jalr	-758(ra) # 80001264 <uvmunmap>
    80001562:	bfe1                	j	8000153a <uvmfree+0xe>

0000000080001564 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001564:	c679                	beqz	a2,80001632 <uvmcopy+0xce>
{
    80001566:	715d                	addi	sp,sp,-80
    80001568:	e486                	sd	ra,72(sp)
    8000156a:	e0a2                	sd	s0,64(sp)
    8000156c:	fc26                	sd	s1,56(sp)
    8000156e:	f84a                	sd	s2,48(sp)
    80001570:	f44e                	sd	s3,40(sp)
    80001572:	f052                	sd	s4,32(sp)
    80001574:	ec56                	sd	s5,24(sp)
    80001576:	e85a                	sd	s6,16(sp)
    80001578:	e45e                	sd	s7,8(sp)
    8000157a:	0880                	addi	s0,sp,80
    8000157c:	8b2a                	mv	s6,a0
    8000157e:	8aae                	mv	s5,a1
    80001580:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001582:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001584:	4601                	li	a2,0
    80001586:	85ce                	mv	a1,s3
    80001588:	855a                	mv	a0,s6
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	a2c080e7          	jalr	-1492(ra) # 80000fb6 <walk>
    80001592:	c531                	beqz	a0,800015de <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001594:	6118                	ld	a4,0(a0)
    80001596:	00177793          	andi	a5,a4,1
    8000159a:	cbb1                	beqz	a5,800015ee <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000159c:	00a75593          	srli	a1,a4,0xa
    800015a0:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015a4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015a8:	fffff097          	auipc	ra,0xfffff
    800015ac:	53e080e7          	jalr	1342(ra) # 80000ae6 <kalloc>
    800015b0:	892a                	mv	s2,a0
    800015b2:	c939                	beqz	a0,80001608 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015b4:	6605                	lui	a2,0x1
    800015b6:	85de                	mv	a1,s7
    800015b8:	fffff097          	auipc	ra,0xfffff
    800015bc:	776080e7          	jalr	1910(ra) # 80000d2e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015c0:	8726                	mv	a4,s1
    800015c2:	86ca                	mv	a3,s2
    800015c4:	6605                	lui	a2,0x1
    800015c6:	85ce                	mv	a1,s3
    800015c8:	8556                	mv	a0,s5
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	ad4080e7          	jalr	-1324(ra) # 8000109e <mappages>
    800015d2:	e515                	bnez	a0,800015fe <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015d4:	6785                	lui	a5,0x1
    800015d6:	99be                	add	s3,s3,a5
    800015d8:	fb49e6e3          	bltu	s3,s4,80001584 <uvmcopy+0x20>
    800015dc:	a081                	j	8000161c <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015de:	00007517          	auipc	a0,0x7
    800015e2:	b9a50513          	addi	a0,a0,-1126 # 80008178 <etext+0x178>
    800015e6:	fffff097          	auipc	ra,0xfffff
    800015ea:	f58080e7          	jalr	-168(ra) # 8000053e <panic>
      panic("uvmcopy: page not present");
    800015ee:	00007517          	auipc	a0,0x7
    800015f2:	baa50513          	addi	a0,a0,-1110 # 80008198 <etext+0x198>
    800015f6:	fffff097          	auipc	ra,0xfffff
    800015fa:	f48080e7          	jalr	-184(ra) # 8000053e <panic>
      kfree(mem);
    800015fe:	854a                	mv	a0,s2
    80001600:	fffff097          	auipc	ra,0xfffff
    80001604:	3ea080e7          	jalr	1002(ra) # 800009ea <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001608:	4685                	li	a3,1
    8000160a:	00c9d613          	srli	a2,s3,0xc
    8000160e:	4581                	li	a1,0
    80001610:	8556                	mv	a0,s5
    80001612:	00000097          	auipc	ra,0x0
    80001616:	c52080e7          	jalr	-942(ra) # 80001264 <uvmunmap>
  return -1;
    8000161a:	557d                	li	a0,-1
}
    8000161c:	60a6                	ld	ra,72(sp)
    8000161e:	6406                	ld	s0,64(sp)
    80001620:	74e2                	ld	s1,56(sp)
    80001622:	7942                	ld	s2,48(sp)
    80001624:	79a2                	ld	s3,40(sp)
    80001626:	7a02                	ld	s4,32(sp)
    80001628:	6ae2                	ld	s5,24(sp)
    8000162a:	6b42                	ld	s6,16(sp)
    8000162c:	6ba2                	ld	s7,8(sp)
    8000162e:	6161                	addi	sp,sp,80
    80001630:	8082                	ret
  return 0;
    80001632:	4501                	li	a0,0
}
    80001634:	8082                	ret

0000000080001636 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001636:	1141                	addi	sp,sp,-16
    80001638:	e406                	sd	ra,8(sp)
    8000163a:	e022                	sd	s0,0(sp)
    8000163c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000163e:	4601                	li	a2,0
    80001640:	00000097          	auipc	ra,0x0
    80001644:	976080e7          	jalr	-1674(ra) # 80000fb6 <walk>
  if(pte == 0)
    80001648:	c901                	beqz	a0,80001658 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000164a:	611c                	ld	a5,0(a0)
    8000164c:	9bbd                	andi	a5,a5,-17
    8000164e:	e11c                	sd	a5,0(a0)
}
    80001650:	60a2                	ld	ra,8(sp)
    80001652:	6402                	ld	s0,0(sp)
    80001654:	0141                	addi	sp,sp,16
    80001656:	8082                	ret
    panic("uvmclear");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b6050513          	addi	a0,a0,-1184 # 800081b8 <etext+0x1b8>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	ede080e7          	jalr	-290(ra) # 8000053e <panic>

0000000080001668 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001668:	c6bd                	beqz	a3,800016d6 <copyout+0x6e>
{
    8000166a:	715d                	addi	sp,sp,-80
    8000166c:	e486                	sd	ra,72(sp)
    8000166e:	e0a2                	sd	s0,64(sp)
    80001670:	fc26                	sd	s1,56(sp)
    80001672:	f84a                	sd	s2,48(sp)
    80001674:	f44e                	sd	s3,40(sp)
    80001676:	f052                	sd	s4,32(sp)
    80001678:	ec56                	sd	s5,24(sp)
    8000167a:	e85a                	sd	s6,16(sp)
    8000167c:	e45e                	sd	s7,8(sp)
    8000167e:	e062                	sd	s8,0(sp)
    80001680:	0880                	addi	s0,sp,80
    80001682:	8b2a                	mv	s6,a0
    80001684:	8c2e                	mv	s8,a1
    80001686:	8a32                	mv	s4,a2
    80001688:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000168a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000168c:	6a85                	lui	s5,0x1
    8000168e:	a015                	j	800016b2 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001690:	9562                	add	a0,a0,s8
    80001692:	0004861b          	sext.w	a2,s1
    80001696:	85d2                	mv	a1,s4
    80001698:	41250533          	sub	a0,a0,s2
    8000169c:	fffff097          	auipc	ra,0xfffff
    800016a0:	692080e7          	jalr	1682(ra) # 80000d2e <memmove>

    len -= n;
    800016a4:	409989b3          	sub	s3,s3,s1
    src += n;
    800016a8:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016aa:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016ae:	02098263          	beqz	s3,800016d2 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016b2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016b6:	85ca                	mv	a1,s2
    800016b8:	855a                	mv	a0,s6
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	9a2080e7          	jalr	-1630(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800016c2:	cd01                	beqz	a0,800016da <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016c4:	418904b3          	sub	s1,s2,s8
    800016c8:	94d6                	add	s1,s1,s5
    if(n > len)
    800016ca:	fc99f3e3          	bgeu	s3,s1,80001690 <copyout+0x28>
    800016ce:	84ce                	mv	s1,s3
    800016d0:	b7c1                	j	80001690 <copyout+0x28>
  }
  return 0;
    800016d2:	4501                	li	a0,0
    800016d4:	a021                	j	800016dc <copyout+0x74>
    800016d6:	4501                	li	a0,0
}
    800016d8:	8082                	ret
      return -1;
    800016da:	557d                	li	a0,-1
}
    800016dc:	60a6                	ld	ra,72(sp)
    800016de:	6406                	ld	s0,64(sp)
    800016e0:	74e2                	ld	s1,56(sp)
    800016e2:	7942                	ld	s2,48(sp)
    800016e4:	79a2                	ld	s3,40(sp)
    800016e6:	7a02                	ld	s4,32(sp)
    800016e8:	6ae2                	ld	s5,24(sp)
    800016ea:	6b42                	ld	s6,16(sp)
    800016ec:	6ba2                	ld	s7,8(sp)
    800016ee:	6c02                	ld	s8,0(sp)
    800016f0:	6161                	addi	sp,sp,80
    800016f2:	8082                	ret

00000000800016f4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016f4:	caa5                	beqz	a3,80001764 <copyin+0x70>
{
    800016f6:	715d                	addi	sp,sp,-80
    800016f8:	e486                	sd	ra,72(sp)
    800016fa:	e0a2                	sd	s0,64(sp)
    800016fc:	fc26                	sd	s1,56(sp)
    800016fe:	f84a                	sd	s2,48(sp)
    80001700:	f44e                	sd	s3,40(sp)
    80001702:	f052                	sd	s4,32(sp)
    80001704:	ec56                	sd	s5,24(sp)
    80001706:	e85a                	sd	s6,16(sp)
    80001708:	e45e                	sd	s7,8(sp)
    8000170a:	e062                	sd	s8,0(sp)
    8000170c:	0880                	addi	s0,sp,80
    8000170e:	8b2a                	mv	s6,a0
    80001710:	8a2e                	mv	s4,a1
    80001712:	8c32                	mv	s8,a2
    80001714:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001716:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001718:	6a85                	lui	s5,0x1
    8000171a:	a01d                	j	80001740 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000171c:	018505b3          	add	a1,a0,s8
    80001720:	0004861b          	sext.w	a2,s1
    80001724:	412585b3          	sub	a1,a1,s2
    80001728:	8552                	mv	a0,s4
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	604080e7          	jalr	1540(ra) # 80000d2e <memmove>

    len -= n;
    80001732:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001736:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001738:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000173c:	02098263          	beqz	s3,80001760 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001740:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001744:	85ca                	mv	a1,s2
    80001746:	855a                	mv	a0,s6
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	914080e7          	jalr	-1772(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    80001750:	cd01                	beqz	a0,80001768 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001752:	418904b3          	sub	s1,s2,s8
    80001756:	94d6                	add	s1,s1,s5
    if(n > len)
    80001758:	fc99f2e3          	bgeu	s3,s1,8000171c <copyin+0x28>
    8000175c:	84ce                	mv	s1,s3
    8000175e:	bf7d                	j	8000171c <copyin+0x28>
  }
  return 0;
    80001760:	4501                	li	a0,0
    80001762:	a021                	j	8000176a <copyin+0x76>
    80001764:	4501                	li	a0,0
}
    80001766:	8082                	ret
      return -1;
    80001768:	557d                	li	a0,-1
}
    8000176a:	60a6                	ld	ra,72(sp)
    8000176c:	6406                	ld	s0,64(sp)
    8000176e:	74e2                	ld	s1,56(sp)
    80001770:	7942                	ld	s2,48(sp)
    80001772:	79a2                	ld	s3,40(sp)
    80001774:	7a02                	ld	s4,32(sp)
    80001776:	6ae2                	ld	s5,24(sp)
    80001778:	6b42                	ld	s6,16(sp)
    8000177a:	6ba2                	ld	s7,8(sp)
    8000177c:	6c02                	ld	s8,0(sp)
    8000177e:	6161                	addi	sp,sp,80
    80001780:	8082                	ret

0000000080001782 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001782:	c6c5                	beqz	a3,8000182a <copyinstr+0xa8>
{
    80001784:	715d                	addi	sp,sp,-80
    80001786:	e486                	sd	ra,72(sp)
    80001788:	e0a2                	sd	s0,64(sp)
    8000178a:	fc26                	sd	s1,56(sp)
    8000178c:	f84a                	sd	s2,48(sp)
    8000178e:	f44e                	sd	s3,40(sp)
    80001790:	f052                	sd	s4,32(sp)
    80001792:	ec56                	sd	s5,24(sp)
    80001794:	e85a                	sd	s6,16(sp)
    80001796:	e45e                	sd	s7,8(sp)
    80001798:	0880                	addi	s0,sp,80
    8000179a:	8a2a                	mv	s4,a0
    8000179c:	8b2e                	mv	s6,a1
    8000179e:	8bb2                	mv	s7,a2
    800017a0:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017a2:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017a4:	6985                	lui	s3,0x1
    800017a6:	a035                	j	800017d2 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017a8:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017ac:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017ae:	0017b793          	seqz	a5,a5
    800017b2:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017b6:	60a6                	ld	ra,72(sp)
    800017b8:	6406                	ld	s0,64(sp)
    800017ba:	74e2                	ld	s1,56(sp)
    800017bc:	7942                	ld	s2,48(sp)
    800017be:	79a2                	ld	s3,40(sp)
    800017c0:	7a02                	ld	s4,32(sp)
    800017c2:	6ae2                	ld	s5,24(sp)
    800017c4:	6b42                	ld	s6,16(sp)
    800017c6:	6ba2                	ld	s7,8(sp)
    800017c8:	6161                	addi	sp,sp,80
    800017ca:	8082                	ret
    srcva = va0 + PGSIZE;
    800017cc:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017d0:	c8a9                	beqz	s1,80001822 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017d2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017d6:	85ca                	mv	a1,s2
    800017d8:	8552                	mv	a0,s4
    800017da:	00000097          	auipc	ra,0x0
    800017de:	882080e7          	jalr	-1918(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800017e2:	c131                	beqz	a0,80001826 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017e4:	41790833          	sub	a6,s2,s7
    800017e8:	984e                	add	a6,a6,s3
    if(n > max)
    800017ea:	0104f363          	bgeu	s1,a6,800017f0 <copyinstr+0x6e>
    800017ee:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017f0:	955e                	add	a0,a0,s7
    800017f2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017f6:	fc080be3          	beqz	a6,800017cc <copyinstr+0x4a>
    800017fa:	985a                	add	a6,a6,s6
    800017fc:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017fe:	41650633          	sub	a2,a0,s6
    80001802:	14fd                	addi	s1,s1,-1
    80001804:	9b26                	add	s6,s6,s1
    80001806:	00f60733          	add	a4,a2,a5
    8000180a:	00074703          	lbu	a4,0(a4)
    8000180e:	df49                	beqz	a4,800017a8 <copyinstr+0x26>
        *dst = *p;
    80001810:	00e78023          	sb	a4,0(a5)
      --max;
    80001814:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001818:	0785                	addi	a5,a5,1
    while(n > 0){
    8000181a:	ff0796e3          	bne	a5,a6,80001806 <copyinstr+0x84>
      dst++;
    8000181e:	8b42                	mv	s6,a6
    80001820:	b775                	j	800017cc <copyinstr+0x4a>
    80001822:	4781                	li	a5,0
    80001824:	b769                	j	800017ae <copyinstr+0x2c>
      return -1;
    80001826:	557d                	li	a0,-1
    80001828:	b779                	j	800017b6 <copyinstr+0x34>
  int got_null = 0;
    8000182a:	4781                	li	a5,0
  if(got_null){
    8000182c:	0017b793          	seqz	a5,a5
    80001830:	40f00533          	neg	a0,a5
}
    80001834:	8082                	ret

0000000080001836 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001836:	7139                	addi	sp,sp,-64
    80001838:	fc06                	sd	ra,56(sp)
    8000183a:	f822                	sd	s0,48(sp)
    8000183c:	f426                	sd	s1,40(sp)
    8000183e:	f04a                	sd	s2,32(sp)
    80001840:	ec4e                	sd	s3,24(sp)
    80001842:	e852                	sd	s4,16(sp)
    80001844:	e456                	sd	s5,8(sp)
    80001846:	e05a                	sd	s6,0(sp)
    80001848:	0080                	addi	s0,sp,64
    8000184a:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000184c:	0000f497          	auipc	s1,0xf
    80001850:	78448493          	addi	s1,s1,1924 # 80010fd0 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001854:	8b26                	mv	s6,s1
    80001856:	00006a97          	auipc	s5,0x6
    8000185a:	7aaa8a93          	addi	s5,s5,1962 # 80008000 <etext>
    8000185e:	04000937          	lui	s2,0x4000
    80001862:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001864:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001866:	00018a17          	auipc	s4,0x18
    8000186a:	16aa0a13          	addi	s4,s4,362 # 800199d0 <mlfq>
    char *pa = kalloc();
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	278080e7          	jalr	632(ra) # 80000ae6 <kalloc>
    80001876:	862a                	mv	a2,a0
    if (pa == 0)
    80001878:	c131                	beqz	a0,800018bc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    8000187a:	416485b3          	sub	a1,s1,s6
    8000187e:	858d                	srai	a1,a1,0x3
    80001880:	000ab783          	ld	a5,0(s5)
    80001884:	02f585b3          	mul	a1,a1,a5
    80001888:	2585                	addiw	a1,a1,1
    8000188a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000188e:	4719                	li	a4,6
    80001890:	6685                	lui	a3,0x1
    80001892:	40b905b3          	sub	a1,s2,a1
    80001896:	854e                	mv	a0,s3
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	8a6080e7          	jalr	-1882(ra) # 8000113e <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    800018a0:	22848493          	addi	s1,s1,552
    800018a4:	fd4495e3          	bne	s1,s4,8000186e <proc_mapstacks+0x38>
  }
}
    800018a8:	70e2                	ld	ra,56(sp)
    800018aa:	7442                	ld	s0,48(sp)
    800018ac:	74a2                	ld	s1,40(sp)
    800018ae:	7902                	ld	s2,32(sp)
    800018b0:	69e2                	ld	s3,24(sp)
    800018b2:	6a42                	ld	s4,16(sp)
    800018b4:	6aa2                	ld	s5,8(sp)
    800018b6:	6b02                	ld	s6,0(sp)
    800018b8:	6121                	addi	sp,sp,64
    800018ba:	8082                	ret
      panic("kalloc");
    800018bc:	00007517          	auipc	a0,0x7
    800018c0:	90c50513          	addi	a0,a0,-1780 # 800081c8 <etext+0x1c8>
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	c7a080e7          	jalr	-902(ra) # 8000053e <panic>

00000000800018cc <procinit>:

// initialize the proc table.
void procinit(void)
{
    800018cc:	7139                	addi	sp,sp,-64
    800018ce:	fc06                	sd	ra,56(sp)
    800018d0:	f822                	sd	s0,48(sp)
    800018d2:	f426                	sd	s1,40(sp)
    800018d4:	f04a                	sd	s2,32(sp)
    800018d6:	ec4e                	sd	s3,24(sp)
    800018d8:	e852                	sd	s4,16(sp)
    800018da:	e456                	sd	s5,8(sp)
    800018dc:	e05a                	sd	s6,0(sp)
    800018de:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    800018e0:	00007597          	auipc	a1,0x7
    800018e4:	8f058593          	addi	a1,a1,-1808 # 800081d0 <etext+0x1d0>
    800018e8:	0000f517          	auipc	a0,0xf
    800018ec:	2a850513          	addi	a0,a0,680 # 80010b90 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8e058593          	addi	a1,a1,-1824 # 800081d8 <etext+0x1d8>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	2a850513          	addi	a0,a0,680 # 80010ba8 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001910:	0000f497          	auipc	s1,0xf
    80001914:	6c048493          	addi	s1,s1,1728 # 80010fd0 <proc>
  {
    initlock(&p->lock, "proc");
    80001918:	00007b17          	auipc	s6,0x7
    8000191c:	8d0b0b13          	addi	s6,s6,-1840 # 800081e8 <etext+0x1e8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001920:	8aa6                	mv	s5,s1
    80001922:	00006a17          	auipc	s4,0x6
    80001926:	6dea0a13          	addi	s4,s4,1758 # 80008000 <etext>
    8000192a:	04000937          	lui	s2,0x4000
    8000192e:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001930:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001932:	00018997          	auipc	s3,0x18
    80001936:	09e98993          	addi	s3,s3,158 # 800199d0 <mlfq>
    initlock(&p->lock, "proc");
    8000193a:	85da                	mv	a1,s6
    8000193c:	8526                	mv	a0,s1
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	208080e7          	jalr	520(ra) # 80000b46 <initlock>
    p->state = UNUSED;
    80001946:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000194a:	415487b3          	sub	a5,s1,s5
    8000194e:	878d                	srai	a5,a5,0x3
    80001950:	000a3703          	ld	a4,0(s4)
    80001954:	02e787b3          	mul	a5,a5,a4
    80001958:	2785                	addiw	a5,a5,1
    8000195a:	00d7979b          	slliw	a5,a5,0xd
    8000195e:	40f907b3          	sub	a5,s2,a5
    80001962:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001964:	22848493          	addi	s1,s1,552
    80001968:	fd3499e3          	bne	s1,s3,8000193a <procinit+0x6e>
    8000196c:	0000f697          	auipc	a3,0xf
    80001970:	25468693          	addi	a3,a3,596 # 80010bc0 <queue_size>
    80001974:	00018717          	auipc	a4,0x18
    80001978:	25c70713          	addi	a4,a4,604 # 80019bd0 <mlfq+0x200>
    8000197c:	00019617          	auipc	a2,0x19
    80001980:	a5460613          	addi	a2,a2,-1452 # 8001a3d0 <bcache+0x1e8>
  }

  #ifdef MLFQ
  for (int i = 0; i < 4; i++) {
    queue_size[i] = 0;
    80001984:	0006a023          	sw	zero,0(a3)
    for (int j = 0; j < NPROC; j++) {
    80001988:	e0070793          	addi	a5,a4,-512
      mlfq[i][j] = 0;
    8000198c:	0007b023          	sd	zero,0(a5)
    for (int j = 0; j < NPROC; j++) {
    80001990:	07a1                	addi	a5,a5,8
    80001992:	fee79de3          	bne	a5,a4,8000198c <procinit+0xc0>
  for (int i = 0; i < 4; i++) {
    80001996:	0691                	addi	a3,a3,4
    80001998:	20070713          	addi	a4,a4,512
    8000199c:	fec714e3          	bne	a4,a2,80001984 <procinit+0xb8>
    }
  }
  #endif
}
    800019a0:	70e2                	ld	ra,56(sp)
    800019a2:	7442                	ld	s0,48(sp)
    800019a4:	74a2                	ld	s1,40(sp)
    800019a6:	7902                	ld	s2,32(sp)
    800019a8:	69e2                	ld	s3,24(sp)
    800019aa:	6a42                	ld	s4,16(sp)
    800019ac:	6aa2                	ld	s5,8(sp)
    800019ae:	6b02                	ld	s6,0(sp)
    800019b0:	6121                	addi	sp,sp,64
    800019b2:	8082                	ret

00000000800019b4 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    800019b4:	1141                	addi	sp,sp,-16
    800019b6:	e422                	sd	s0,8(sp)
    800019b8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019ba:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800019bc:	2501                	sext.w	a0,a0
    800019be:	6422                	ld	s0,8(sp)
    800019c0:	0141                	addi	sp,sp,16
    800019c2:	8082                	ret

00000000800019c4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800019c4:	1141                	addi	sp,sp,-16
    800019c6:	e422                	sd	s0,8(sp)
    800019c8:	0800                	addi	s0,sp,16
    800019ca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019cc:	2781                	sext.w	a5,a5
    800019ce:	079e                	slli	a5,a5,0x7
  return c;
}
    800019d0:	0000f517          	auipc	a0,0xf
    800019d4:	20050513          	addi	a0,a0,512 # 80010bd0 <cpus>
    800019d8:	953e                	add	a0,a0,a5
    800019da:	6422                	ld	s0,8(sp)
    800019dc:	0141                	addi	sp,sp,16
    800019de:	8082                	ret

00000000800019e0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800019e0:	1101                	addi	sp,sp,-32
    800019e2:	ec06                	sd	ra,24(sp)
    800019e4:	e822                	sd	s0,16(sp)
    800019e6:	e426                	sd	s1,8(sp)
    800019e8:	1000                	addi	s0,sp,32
  push_off();
    800019ea:	fffff097          	auipc	ra,0xfffff
    800019ee:	1a0080e7          	jalr	416(ra) # 80000b8a <push_off>
    800019f2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019f4:	2781                	sext.w	a5,a5
    800019f6:	079e                	slli	a5,a5,0x7
    800019f8:	0000f717          	auipc	a4,0xf
    800019fc:	19870713          	addi	a4,a4,408 # 80010b90 <pid_lock>
    80001a00:	97ba                	add	a5,a5,a4
    80001a02:	63a4                	ld	s1,64(a5)
  pop_off();
    80001a04:	fffff097          	auipc	ra,0xfffff
    80001a08:	226080e7          	jalr	550(ra) # 80000c2a <pop_off>
  return p;
}
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	60e2                	ld	ra,24(sp)
    80001a10:	6442                	ld	s0,16(sp)
    80001a12:	64a2                	ld	s1,8(sp)
    80001a14:	6105                	addi	sp,sp,32
    80001a16:	8082                	ret

0000000080001a18 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001a18:	1141                	addi	sp,sp,-16
    80001a1a:	e406                	sd	ra,8(sp)
    80001a1c:	e022                	sd	s0,0(sp)
    80001a1e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a20:	00000097          	auipc	ra,0x0
    80001a24:	fc0080e7          	jalr	-64(ra) # 800019e0 <myproc>
    80001a28:	fffff097          	auipc	ra,0xfffff
    80001a2c:	262080e7          	jalr	610(ra) # 80000c8a <release>

  if (first)
    80001a30:	00007797          	auipc	a5,0x7
    80001a34:	e707a783          	lw	a5,-400(a5) # 800088a0 <first.1>
    80001a38:	eb89                	bnez	a5,80001a4a <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a3a:	00001097          	auipc	ra,0x1
    80001a3e:	33a080e7          	jalr	826(ra) # 80002d74 <usertrapret>
}
    80001a42:	60a2                	ld	ra,8(sp)
    80001a44:	6402                	ld	s0,0(sp)
    80001a46:	0141                	addi	sp,sp,16
    80001a48:	8082                	ret
    first = 0;
    80001a4a:	00007797          	auipc	a5,0x7
    80001a4e:	e407ab23          	sw	zero,-426(a5) # 800088a0 <first.1>
    fsinit(ROOTDEV);
    80001a52:	4505                	li	a0,1
    80001a54:	00002097          	auipc	ra,0x2
    80001a58:	3ae080e7          	jalr	942(ra) # 80003e02 <fsinit>
    80001a5c:	bff9                	j	80001a3a <forkret+0x22>

0000000080001a5e <allocpid>:
{
    80001a5e:	1101                	addi	sp,sp,-32
    80001a60:	ec06                	sd	ra,24(sp)
    80001a62:	e822                	sd	s0,16(sp)
    80001a64:	e426                	sd	s1,8(sp)
    80001a66:	e04a                	sd	s2,0(sp)
    80001a68:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a6a:	0000f917          	auipc	s2,0xf
    80001a6e:	12690913          	addi	s2,s2,294 # 80010b90 <pid_lock>
    80001a72:	854a                	mv	a0,s2
    80001a74:	fffff097          	auipc	ra,0xfffff
    80001a78:	162080e7          	jalr	354(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a7c:	00007797          	auipc	a5,0x7
    80001a80:	e2c78793          	addi	a5,a5,-468 # 800088a8 <nextpid>
    80001a84:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a86:	0014871b          	addiw	a4,s1,1
    80001a8a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a8c:	854a                	mv	a0,s2
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	1fc080e7          	jalr	508(ra) # 80000c8a <release>
}
    80001a96:	8526                	mv	a0,s1
    80001a98:	60e2                	ld	ra,24(sp)
    80001a9a:	6442                	ld	s0,16(sp)
    80001a9c:	64a2                	ld	s1,8(sp)
    80001a9e:	6902                	ld	s2,0(sp)
    80001aa0:	6105                	addi	sp,sp,32
    80001aa2:	8082                	ret

0000000080001aa4 <proc_pagetable>:
{
    80001aa4:	1101                	addi	sp,sp,-32
    80001aa6:	ec06                	sd	ra,24(sp)
    80001aa8:	e822                	sd	s0,16(sp)
    80001aaa:	e426                	sd	s1,8(sp)
    80001aac:	e04a                	sd	s2,0(sp)
    80001aae:	1000                	addi	s0,sp,32
    80001ab0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ab2:	00000097          	auipc	ra,0x0
    80001ab6:	876080e7          	jalr	-1930(ra) # 80001328 <uvmcreate>
    80001aba:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001abc:	c121                	beqz	a0,80001afc <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001abe:	4729                	li	a4,10
    80001ac0:	00005697          	auipc	a3,0x5
    80001ac4:	54068693          	addi	a3,a3,1344 # 80007000 <_trampoline>
    80001ac8:	6605                	lui	a2,0x1
    80001aca:	040005b7          	lui	a1,0x4000
    80001ace:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad0:	05b2                	slli	a1,a1,0xc
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	5cc080e7          	jalr	1484(ra) # 8000109e <mappages>
    80001ada:	02054863          	bltz	a0,80001b0a <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ade:	4719                	li	a4,6
    80001ae0:	05893683          	ld	a3,88(s2)
    80001ae4:	6605                	lui	a2,0x1
    80001ae6:	020005b7          	lui	a1,0x2000
    80001aea:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aec:	05b6                	slli	a1,a1,0xd
    80001aee:	8526                	mv	a0,s1
    80001af0:	fffff097          	auipc	ra,0xfffff
    80001af4:	5ae080e7          	jalr	1454(ra) # 8000109e <mappages>
    80001af8:	02054163          	bltz	a0,80001b1a <proc_pagetable+0x76>
}
    80001afc:	8526                	mv	a0,s1
    80001afe:	60e2                	ld	ra,24(sp)
    80001b00:	6442                	ld	s0,16(sp)
    80001b02:	64a2                	ld	s1,8(sp)
    80001b04:	6902                	ld	s2,0(sp)
    80001b06:	6105                	addi	sp,sp,32
    80001b08:	8082                	ret
    uvmfree(pagetable, 0);
    80001b0a:	4581                	li	a1,0
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	00000097          	auipc	ra,0x0
    80001b12:	a1e080e7          	jalr	-1506(ra) # 8000152c <uvmfree>
    return 0;
    80001b16:	4481                	li	s1,0
    80001b18:	b7d5                	j	80001afc <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1a:	4681                	li	a3,0
    80001b1c:	4605                	li	a2,1
    80001b1e:	040005b7          	lui	a1,0x4000
    80001b22:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b24:	05b2                	slli	a1,a1,0xc
    80001b26:	8526                	mv	a0,s1
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	73c080e7          	jalr	1852(ra) # 80001264 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b30:	4581                	li	a1,0
    80001b32:	8526                	mv	a0,s1
    80001b34:	00000097          	auipc	ra,0x0
    80001b38:	9f8080e7          	jalr	-1544(ra) # 8000152c <uvmfree>
    return 0;
    80001b3c:	4481                	li	s1,0
    80001b3e:	bf7d                	j	80001afc <proc_pagetable+0x58>

0000000080001b40 <proc_freepagetable>:
{
    80001b40:	1101                	addi	sp,sp,-32
    80001b42:	ec06                	sd	ra,24(sp)
    80001b44:	e822                	sd	s0,16(sp)
    80001b46:	e426                	sd	s1,8(sp)
    80001b48:	e04a                	sd	s2,0(sp)
    80001b4a:	1000                	addi	s0,sp,32
    80001b4c:	84aa                	mv	s1,a0
    80001b4e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b50:	4681                	li	a3,0
    80001b52:	4605                	li	a2,1
    80001b54:	040005b7          	lui	a1,0x4000
    80001b58:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b5a:	05b2                	slli	a1,a1,0xc
    80001b5c:	fffff097          	auipc	ra,0xfffff
    80001b60:	708080e7          	jalr	1800(ra) # 80001264 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b64:	4681                	li	a3,0
    80001b66:	4605                	li	a2,1
    80001b68:	020005b7          	lui	a1,0x2000
    80001b6c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b6e:	05b6                	slli	a1,a1,0xd
    80001b70:	8526                	mv	a0,s1
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	6f2080e7          	jalr	1778(ra) # 80001264 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b7a:	85ca                	mv	a1,s2
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	00000097          	auipc	ra,0x0
    80001b82:	9ae080e7          	jalr	-1618(ra) # 8000152c <uvmfree>
}
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6902                	ld	s2,0(sp)
    80001b8e:	6105                	addi	sp,sp,32
    80001b90:	8082                	ret

0000000080001b92 <freeproc>:
{
    80001b92:	1101                	addi	sp,sp,-32
    80001b94:	ec06                	sd	ra,24(sp)
    80001b96:	e822                	sd	s0,16(sp)
    80001b98:	e426                	sd	s1,8(sp)
    80001b9a:	1000                	addi	s0,sp,32
    80001b9c:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001b9e:	6d28                	ld	a0,88(a0)
    80001ba0:	c509                	beqz	a0,80001baa <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	e48080e7          	jalr	-440(ra) # 800009ea <kfree>
  p->trapframe = 0;
    80001baa:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001bae:	68a8                	ld	a0,80(s1)
    80001bb0:	c511                	beqz	a0,80001bbc <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001bb2:	64ac                	ld	a1,72(s1)
    80001bb4:	00000097          	auipc	ra,0x0
    80001bb8:	f8c080e7          	jalr	-116(ra) # 80001b40 <proc_freepagetable>
  if (p->alarm_trapframe) 
    80001bbc:	2084b503          	ld	a0,520(s1)
    80001bc0:	c509                	beqz	a0,80001bca <freeproc+0x38>
    kfree((void *)p->alarm_trapframe);
    80001bc2:	fffff097          	auipc	ra,0xfffff
    80001bc6:	e28080e7          	jalr	-472(ra) # 800009ea <kfree>
  memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
    80001bca:	4621                	li	a2,8
    80001bcc:	4581                	li	a1,0
    80001bce:	20848513          	addi	a0,s1,520
    80001bd2:	fffff097          	auipc	ra,0xfffff
    80001bd6:	100080e7          	jalr	256(ra) # 80000cd2 <memset>
  p->pagetable = 0;
    80001bda:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001bde:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001be2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001be6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001bea:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bee:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001bf2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001bf6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001bfa:	0004ac23          	sw	zero,24(s1)
}
    80001bfe:	60e2                	ld	ra,24(sp)
    80001c00:	6442                	ld	s0,16(sp)
    80001c02:	64a2                	ld	s1,8(sp)
    80001c04:	6105                	addi	sp,sp,32
    80001c06:	8082                	ret

0000000080001c08 <growproc>:
{
    80001c08:	1101                	addi	sp,sp,-32
    80001c0a:	ec06                	sd	ra,24(sp)
    80001c0c:	e822                	sd	s0,16(sp)
    80001c0e:	e426                	sd	s1,8(sp)
    80001c10:	e04a                	sd	s2,0(sp)
    80001c12:	1000                	addi	s0,sp,32
    80001c14:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001c16:	00000097          	auipc	ra,0x0
    80001c1a:	dca080e7          	jalr	-566(ra) # 800019e0 <myproc>
    80001c1e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001c20:	652c                	ld	a1,72(a0)
  if (n > 0)
    80001c22:	01204c63          	bgtz	s2,80001c3a <growproc+0x32>
  else if (n < 0)
    80001c26:	02094663          	bltz	s2,80001c52 <growproc+0x4a>
  p->sz = sz;
    80001c2a:	e4ac                	sd	a1,72(s1)
  return 0;
    80001c2c:	4501                	li	a0,0
}
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6902                	ld	s2,0(sp)
    80001c36:	6105                	addi	sp,sp,32
    80001c38:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001c3a:	4691                	li	a3,4
    80001c3c:	00b90633          	add	a2,s2,a1
    80001c40:	6928                	ld	a0,80(a0)
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	7ce080e7          	jalr	1998(ra) # 80001410 <uvmalloc>
    80001c4a:	85aa                	mv	a1,a0
    80001c4c:	fd79                	bnez	a0,80001c2a <growproc+0x22>
      return -1;
    80001c4e:	557d                	li	a0,-1
    80001c50:	bff9                	j	80001c2e <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c52:	00b90633          	add	a2,s2,a1
    80001c56:	6928                	ld	a0,80(a0)
    80001c58:	fffff097          	auipc	ra,0xfffff
    80001c5c:	770080e7          	jalr	1904(ra) # 800013c8 <uvmdealloc>
    80001c60:	85aa                	mv	a1,a0
    80001c62:	b7e1                	j	80001c2a <growproc+0x22>

0000000080001c64 <getsyscount>:
{
    80001c64:	1101                	addi	sp,sp,-32
    80001c66:	ec06                	sd	ra,24(sp)
    80001c68:	e822                	sd	s0,16(sp)
    80001c6a:	e426                	sd	s1,8(sp)
    80001c6c:	e04a                	sd	s2,0(sp)
    80001c6e:	1000                	addi	s0,sp,32
    80001c70:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001c72:	00000097          	auipc	ra,0x0
    80001c76:	d6e080e7          	jalr	-658(ra) # 800019e0 <myproc>
    80001c7a:	84aa                	mv	s1,a0
  int index = get_syscall_index(mask);
    80001c7c:	854a                	mv	a0,s2
    80001c7e:	00001097          	auipc	ra,0x1
    80001c82:	74a080e7          	jalr	1866(ra) # 800033c8 <get_syscall_index>
  if (index == -1) {
    80001c86:	57fd                	li	a5,-1
    80001c88:	00f50863          	beq	a0,a5,80001c98 <getsyscount+0x34>
  return p->syscalls[index];
    80001c8c:	05c50793          	addi	a5,a0,92
    80001c90:	078a                	slli	a5,a5,0x2
    80001c92:	00f48533          	add	a0,s1,a5
    80001c96:	4148                	lw	a0,4(a0)
}
    80001c98:	60e2                	ld	ra,24(sp)
    80001c9a:	6442                	ld	s0,16(sp)
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	6902                	ld	s2,0(sp)
    80001ca0:	6105                	addi	sp,sp,32
    80001ca2:	8082                	ret

0000000080001ca4 <rand>:
{
    80001ca4:	1141                	addi	sp,sp,-16
    80001ca6:	e422                	sd	s0,8(sp)
    80001ca8:	0800                	addi	s0,sp,16
  seed = seed * 1103515245 + 12345;
    80001caa:	00007717          	auipc	a4,0x7
    80001cae:	bfa70713          	addi	a4,a4,-1030 # 800088a4 <seed.2>
    80001cb2:	4308                	lw	a0,0(a4)
    80001cb4:	41c657b7          	lui	a5,0x41c65
    80001cb8:	e6d7879b          	addiw	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80001cbc:	02f5053b          	mulw	a0,a0,a5
    80001cc0:	678d                	lui	a5,0x3
    80001cc2:	0397879b          	addiw	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80001cc6:	9d3d                	addw	a0,a0,a5
    80001cc8:	c308                	sw	a0,0(a4)
}
    80001cca:	2501                	sext.w	a0,a0
    80001ccc:	6422                	ld	s0,8(sp)
    80001cce:	0141                	addi	sp,sp,16
    80001cd0:	8082                	ret

0000000080001cd2 <log_event>:
void log_event(int time, int pid, int queue_id) {
    80001cd2:	1141                	addi	sp,sp,-16
    80001cd4:	e406                	sd	ra,8(sp)
    80001cd6:	e022                	sd	s0,0(sp)
    80001cd8:	0800                	addi	s0,sp,16
    80001cda:	86b2                	mv	a3,a2
  printf("%d,%d,%d\n", pid, time, queue_id);
    80001cdc:	862a                	mv	a2,a0
    80001cde:	00006517          	auipc	a0,0x6
    80001ce2:	51250513          	addi	a0,a0,1298 # 800081f0 <etext+0x1f0>
    80001ce6:	fffff097          	auipc	ra,0xfffff
    80001cea:	8a2080e7          	jalr	-1886(ra) # 80000588 <printf>
}
    80001cee:	60a2                	ld	ra,8(sp)
    80001cf0:	6402                	ld	s0,0(sp)
    80001cf2:	0141                	addi	sp,sp,16
    80001cf4:	8082                	ret

0000000080001cf6 <enqueue>:
{
    80001cf6:	1141                	addi	sp,sp,-16
    80001cf8:	e422                	sd	s0,8(sp)
    80001cfa:	0800                	addi	s0,sp,16
  mlfq[queue][queue_size[queue]++] = p;
    80001cfc:	00259713          	slli	a4,a1,0x2
    80001d00:	0000f797          	auipc	a5,0xf
    80001d04:	e9078793          	addi	a5,a5,-368 # 80010b90 <pid_lock>
    80001d08:	97ba                	add	a5,a5,a4
    80001d0a:	5b98                	lw	a4,48(a5)
    80001d0c:	0017069b          	addiw	a3,a4,1
    80001d10:	db94                	sw	a3,48(a5)
    80001d12:	059a                	slli	a1,a1,0x6
    80001d14:	95ba                	add	a1,a1,a4
    80001d16:	058e                	slli	a1,a1,0x3
    80001d18:	00018797          	auipc	a5,0x18
    80001d1c:	cb878793          	addi	a5,a5,-840 # 800199d0 <mlfq>
    80001d20:	95be                	add	a1,a1,a5
    80001d22:	e188                	sd	a0,0(a1)
}
    80001d24:	6422                	ld	s0,8(sp)
    80001d26:	0141                	addi	sp,sp,16
    80001d28:	8082                	ret

0000000080001d2a <allocproc>:
{
    80001d2a:	1101                	addi	sp,sp,-32
    80001d2c:	ec06                	sd	ra,24(sp)
    80001d2e:	e822                	sd	s0,16(sp)
    80001d30:	e426                	sd	s1,8(sp)
    80001d32:	e04a                	sd	s2,0(sp)
    80001d34:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001d36:	0000f497          	auipc	s1,0xf
    80001d3a:	29a48493          	addi	s1,s1,666 # 80010fd0 <proc>
    80001d3e:	00018917          	auipc	s2,0x18
    80001d42:	c9290913          	addi	s2,s2,-878 # 800199d0 <mlfq>
    acquire(&p->lock);
    80001d46:	8526                	mv	a0,s1
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	e8e080e7          	jalr	-370(ra) # 80000bd6 <acquire>
    if (p->state == UNUSED)
    80001d50:	4c9c                	lw	a5,24(s1)
    80001d52:	cf81                	beqz	a5,80001d6a <allocproc+0x40>
      release(&p->lock);
    80001d54:	8526                	mv	a0,s1
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	f34080e7          	jalr	-204(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001d5e:	22848493          	addi	s1,s1,552
    80001d62:	ff2492e3          	bne	s1,s2,80001d46 <allocproc+0x1c>
  return 0;
    80001d66:	4481                	li	s1,0
    80001d68:	a0ed                	j	80001e52 <allocproc+0x128>
  p->pid = allocpid();
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	cf4080e7          	jalr	-780(ra) # 80001a5e <allocpid>
    80001d72:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d74:	4785                	li	a5,1
    80001d76:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	d6e080e7          	jalr	-658(ra) # 80000ae6 <kalloc>
    80001d80:	892a                	mv	s2,a0
    80001d82:	eca8                	sd	a0,88(s1)
    80001d84:	cd71                	beqz	a0,80001e60 <allocproc+0x136>
  p->pagetable = proc_pagetable(p);
    80001d86:	8526                	mv	a0,s1
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	d1c080e7          	jalr	-740(ra) # 80001aa4 <proc_pagetable>
    80001d90:	892a                	mv	s2,a0
    80001d92:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001d94:	c175                	beqz	a0,80001e78 <allocproc+0x14e>
  memset(&p->context, 0, sizeof(p->context));
    80001d96:	07000613          	li	a2,112
    80001d9a:	4581                	li	a1,0
    80001d9c:	06048513          	addi	a0,s1,96
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	f32080e7          	jalr	-206(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001da8:	00000797          	auipc	a5,0x0
    80001dac:	c7078793          	addi	a5,a5,-912 # 80001a18 <forkret>
    80001db0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001db2:	60bc                	ld	a5,64(s1)
    80001db4:	6705                	lui	a4,0x1
    80001db6:	97ba                	add	a5,a5,a4
    80001db8:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001dba:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001dbe:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001dc2:	00007797          	auipc	a5,0x7
    80001dc6:	b627a783          	lw	a5,-1182(a5) # 80008924 <ticks>
    80001dca:	16f4a623          	sw	a5,364(s1)
  p->tickets = 1;
    80001dce:	4905                	li	s2,1
    80001dd0:	2124a823          	sw	s2,528(s1)
  memset(p->syscalls, 0, sizeof(p->syscalls));
    80001dd4:	08000613          	li	a2,128
    80001dd8:	4581                	li	a1,0
    80001dda:	17448513          	addi	a0,s1,372
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	ef4080e7          	jalr	-268(ra) # 80000cd2 <memset>
  memset(&p->ticks_count, 0, sizeof(p->ticks_count));
    80001de6:	4611                	li	a2,4
    80001de8:	4581                	li	a1,0
    80001dea:	1f448513          	addi	a0,s1,500
    80001dee:	fffff097          	auipc	ra,0xfffff
    80001df2:	ee4080e7          	jalr	-284(ra) # 80000cd2 <memset>
  memset(&p->alarm_on, 0, sizeof(p->alarm_on));
    80001df6:	4611                	li	a2,4
    80001df8:	4581                	li	a1,0
    80001dfa:	1f848513          	addi	a0,s1,504
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	ed4080e7          	jalr	-300(ra) # 80000cd2 <memset>
  memset(&p->alarm_interval, 0, sizeof(p->alarm_interval));
    80001e06:	4611                	li	a2,4
    80001e08:	4581                	li	a1,0
    80001e0a:	1fc48513          	addi	a0,s1,508
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	ec4080e7          	jalr	-316(ra) # 80000cd2 <memset>
  memset(&p->alarm_handler, 0, sizeof(p->alarm_handler));
    80001e16:	4621                	li	a2,8
    80001e18:	4581                	li	a1,0
    80001e1a:	20048513          	addi	a0,s1,512
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	eb4080e7          	jalr	-332(ra) # 80000cd2 <memset>
  memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
    80001e26:	4621                	li	a2,8
    80001e28:	4581                	li	a1,0
    80001e2a:	20848513          	addi	a0,s1,520
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	ea4080e7          	jalr	-348(ra) # 80000cd2 <memset>
  p->mlfq_priority = 0;  // Start in highest priority queue
    80001e36:	2004aa23          	sw	zero,532(s1)
  p->time_slice = 1;     // Initial time slice
    80001e3a:	2124ac23          	sw	s2,536(s1)
  p->mlfq_ticks = 0;
    80001e3e:	2004ae23          	sw	zero,540(s1)
  p->total_ticks = 0;
    80001e42:	2204a023          	sw	zero,544(s1)
  enqueue(p, 0); 
    80001e46:	4581                	li	a1,0
    80001e48:	8526                	mv	a0,s1
    80001e4a:	00000097          	auipc	ra,0x0
    80001e4e:	eac080e7          	jalr	-340(ra) # 80001cf6 <enqueue>
}
    80001e52:	8526                	mv	a0,s1
    80001e54:	60e2                	ld	ra,24(sp)
    80001e56:	6442                	ld	s0,16(sp)
    80001e58:	64a2                	ld	s1,8(sp)
    80001e5a:	6902                	ld	s2,0(sp)
    80001e5c:	6105                	addi	sp,sp,32
    80001e5e:	8082                	ret
    freeproc(p);
    80001e60:	8526                	mv	a0,s1
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	d30080e7          	jalr	-720(ra) # 80001b92 <freeproc>
    release(&p->lock);
    80001e6a:	8526                	mv	a0,s1
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	e1e080e7          	jalr	-482(ra) # 80000c8a <release>
    return 0;
    80001e74:	84ca                	mv	s1,s2
    80001e76:	bff1                	j	80001e52 <allocproc+0x128>
    freeproc(p);
    80001e78:	8526                	mv	a0,s1
    80001e7a:	00000097          	auipc	ra,0x0
    80001e7e:	d18080e7          	jalr	-744(ra) # 80001b92 <freeproc>
    release(&p->lock);
    80001e82:	8526                	mv	a0,s1
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	e06080e7          	jalr	-506(ra) # 80000c8a <release>
    return 0;
    80001e8c:	84ca                	mv	s1,s2
    80001e8e:	b7d1                	j	80001e52 <allocproc+0x128>

0000000080001e90 <userinit>:
{
    80001e90:	1101                	addi	sp,sp,-32
    80001e92:	ec06                	sd	ra,24(sp)
    80001e94:	e822                	sd	s0,16(sp)
    80001e96:	e426                	sd	s1,8(sp)
    80001e98:	1000                	addi	s0,sp,32
  p = allocproc();
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	e90080e7          	jalr	-368(ra) # 80001d2a <allocproc>
    80001ea2:	84aa                	mv	s1,a0
  initproc = p;
    80001ea4:	00007797          	auipc	a5,0x7
    80001ea8:	a6a7ba23          	sd	a0,-1420(a5) # 80008918 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001eac:	03400613          	li	a2,52
    80001eb0:	00007597          	auipc	a1,0x7
    80001eb4:	a0058593          	addi	a1,a1,-1536 # 800088b0 <initcode>
    80001eb8:	6928                	ld	a0,80(a0)
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	49c080e7          	jalr	1180(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001ec2:	6785                	lui	a5,0x1
    80001ec4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001ec6:	6cb8                	ld	a4,88(s1)
    80001ec8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001ecc:	6cb8                	ld	a4,88(s1)
    80001ece:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ed0:	4641                	li	a2,16
    80001ed2:	00006597          	auipc	a1,0x6
    80001ed6:	32e58593          	addi	a1,a1,814 # 80008200 <etext+0x200>
    80001eda:	15848513          	addi	a0,s1,344
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	f3e080e7          	jalr	-194(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	32a50513          	addi	a0,a0,810 # 80008210 <etext+0x210>
    80001eee:	00003097          	auipc	ra,0x3
    80001ef2:	936080e7          	jalr	-1738(ra) # 80004824 <namei>
    80001ef6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001efa:	478d                	li	a5,3
    80001efc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001efe:	8526                	mv	a0,s1
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	d8a080e7          	jalr	-630(ra) # 80000c8a <release>
}
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	64a2                	ld	s1,8(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret

0000000080001f12 <fork>:
{
    80001f12:	7139                	addi	sp,sp,-64
    80001f14:	fc06                	sd	ra,56(sp)
    80001f16:	f822                	sd	s0,48(sp)
    80001f18:	f426                	sd	s1,40(sp)
    80001f1a:	f04a                	sd	s2,32(sp)
    80001f1c:	ec4e                	sd	s3,24(sp)
    80001f1e:	e852                	sd	s4,16(sp)
    80001f20:	e456                	sd	s5,8(sp)
    80001f22:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001f24:	00000097          	auipc	ra,0x0
    80001f28:	abc080e7          	jalr	-1348(ra) # 800019e0 <myproc>
    80001f2c:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	dfc080e7          	jalr	-516(ra) # 80001d2a <allocproc>
    80001f36:	12050063          	beqz	a0,80002056 <fork+0x144>
    80001f3a:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001f3c:	048ab603          	ld	a2,72(s5)
    80001f40:	692c                	ld	a1,80(a0)
    80001f42:	050ab503          	ld	a0,80(s5)
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	61e080e7          	jalr	1566(ra) # 80001564 <uvmcopy>
    80001f4e:	04054c63          	bltz	a0,80001fa6 <fork+0x94>
  np->sz = p->sz;
    80001f52:	048ab783          	ld	a5,72(s5)
    80001f56:	04f9b423          	sd	a5,72(s3)
  np->tickets = p->tickets;
    80001f5a:	210aa783          	lw	a5,528(s5)
    80001f5e:	20f9a823          	sw	a5,528(s3)
  *(np->trapframe) = *(p->trapframe);
    80001f62:	058ab683          	ld	a3,88(s5)
    80001f66:	87b6                	mv	a5,a3
    80001f68:	0589b703          	ld	a4,88(s3)
    80001f6c:	12068693          	addi	a3,a3,288
    80001f70:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f74:	6788                	ld	a0,8(a5)
    80001f76:	6b8c                	ld	a1,16(a5)
    80001f78:	6f90                	ld	a2,24(a5)
    80001f7a:	01073023          	sd	a6,0(a4)
    80001f7e:	e708                	sd	a0,8(a4)
    80001f80:	eb0c                	sd	a1,16(a4)
    80001f82:	ef10                	sd	a2,24(a4)
    80001f84:	02078793          	addi	a5,a5,32
    80001f88:	02070713          	addi	a4,a4,32
    80001f8c:	fed792e3          	bne	a5,a3,80001f70 <fork+0x5e>
  np->trapframe->a0 = 0;
    80001f90:	0589b783          	ld	a5,88(s3)
    80001f94:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001f98:	0d0a8493          	addi	s1,s5,208
    80001f9c:	0d098913          	addi	s2,s3,208
    80001fa0:	150a8a13          	addi	s4,s5,336
    80001fa4:	a00d                	j	80001fc6 <fork+0xb4>
    freeproc(np);
    80001fa6:	854e                	mv	a0,s3
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	bea080e7          	jalr	-1046(ra) # 80001b92 <freeproc>
    release(&np->lock);
    80001fb0:	854e                	mv	a0,s3
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	cd8080e7          	jalr	-808(ra) # 80000c8a <release>
    return -1;
    80001fba:	597d                	li	s2,-1
    80001fbc:	a059                	j	80002042 <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    80001fbe:	04a1                	addi	s1,s1,8
    80001fc0:	0921                	addi	s2,s2,8
    80001fc2:	01448b63          	beq	s1,s4,80001fd8 <fork+0xc6>
    if (p->ofile[i])
    80001fc6:	6088                	ld	a0,0(s1)
    80001fc8:	d97d                	beqz	a0,80001fbe <fork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    80001fca:	00003097          	auipc	ra,0x3
    80001fce:	ef0080e7          	jalr	-272(ra) # 80004eba <filedup>
    80001fd2:	00a93023          	sd	a0,0(s2)
    80001fd6:	b7e5                	j	80001fbe <fork+0xac>
  np->cwd = idup(p->cwd);
    80001fd8:	150ab503          	ld	a0,336(s5)
    80001fdc:	00002097          	auipc	ra,0x2
    80001fe0:	064080e7          	jalr	100(ra) # 80004040 <idup>
    80001fe4:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001fe8:	4641                	li	a2,16
    80001fea:	158a8593          	addi	a1,s5,344
    80001fee:	15898513          	addi	a0,s3,344
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	e2a080e7          	jalr	-470(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001ffa:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001ffe:	854e                	mv	a0,s3
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	c8a080e7          	jalr	-886(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80002008:	0000f497          	auipc	s1,0xf
    8000200c:	ba048493          	addi	s1,s1,-1120 # 80010ba8 <wait_lock>
    80002010:	8526                	mv	a0,s1
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	bc4080e7          	jalr	-1084(ra) # 80000bd6 <acquire>
  np->parent = p;
    8000201a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000201e:	8526                	mv	a0,s1
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	c6a080e7          	jalr	-918(ra) # 80000c8a <release>
  acquire(&np->lock);
    80002028:	854e                	mv	a0,s3
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	bac080e7          	jalr	-1108(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80002032:	478d                	li	a5,3
    80002034:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002038:	854e                	mv	a0,s3
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	c50080e7          	jalr	-944(ra) # 80000c8a <release>
}
    80002042:	854a                	mv	a0,s2
    80002044:	70e2                	ld	ra,56(sp)
    80002046:	7442                	ld	s0,48(sp)
    80002048:	74a2                	ld	s1,40(sp)
    8000204a:	7902                	ld	s2,32(sp)
    8000204c:	69e2                	ld	s3,24(sp)
    8000204e:	6a42                	ld	s4,16(sp)
    80002050:	6aa2                	ld	s5,8(sp)
    80002052:	6121                	addi	sp,sp,64
    80002054:	8082                	ret
    return -1;
    80002056:	597d                	li	s2,-1
    80002058:	b7ed                	j	80002042 <fork+0x130>

000000008000205a <dequeue>:
{
    8000205a:	1141                	addi	sp,sp,-16
    8000205c:	e422                	sd	s0,8(sp)
    8000205e:	0800                	addi	s0,sp,16
  if (queue_size[queue] == 0)
    80002060:	00251713          	slli	a4,a0,0x2
    80002064:	0000f797          	auipc	a5,0xf
    80002068:	b2c78793          	addi	a5,a5,-1236 # 80010b90 <pid_lock>
    8000206c:	97ba                	add	a5,a5,a4
    8000206e:	5b98                	lw	a4,48(a5)
    80002070:	c32d                	beqz	a4,800020d2 <dequeue+0x78>
    80002072:	862a                	mv	a2,a0
  struct proc *p = mlfq[queue][0];
    80002074:	00951693          	slli	a3,a0,0x9
    80002078:	00018797          	auipc	a5,0x18
    8000207c:	95878793          	addi	a5,a5,-1704 # 800199d0 <mlfq>
    80002080:	97b6                	add	a5,a5,a3
    80002082:	6388                	ld	a0,0(a5)
  for (int i = 0; i < queue_size[queue] - 1; i++) {
    80002084:	fff7059b          	addiw	a1,a4,-1
    80002088:	0005879b          	sext.w	a5,a1
    8000208c:	02f05963          	blez	a5,800020be <dequeue+0x64>
    80002090:	87b6                	mv	a5,a3
    80002092:	00018697          	auipc	a3,0x18
    80002096:	93e68693          	addi	a3,a3,-1730 # 800199d0 <mlfq>
    8000209a:	97b6                	add	a5,a5,a3
    8000209c:	00661693          	slli	a3,a2,0x6
    800020a0:	3779                	addiw	a4,a4,-2
    800020a2:	1702                	slli	a4,a4,0x20
    800020a4:	9301                	srli	a4,a4,0x20
    800020a6:	96ba                	add	a3,a3,a4
    800020a8:	068e                	slli	a3,a3,0x3
    800020aa:	00018717          	auipc	a4,0x18
    800020ae:	92e70713          	addi	a4,a4,-1746 # 800199d8 <mlfq+0x8>
    800020b2:	96ba                	add	a3,a3,a4
    mlfq[queue][i] = mlfq[queue][i+1];
    800020b4:	6798                	ld	a4,8(a5)
    800020b6:	e398                	sd	a4,0(a5)
  for (int i = 0; i < queue_size[queue] - 1; i++) {
    800020b8:	07a1                	addi	a5,a5,8
    800020ba:	fed79de3          	bne	a5,a3,800020b4 <dequeue+0x5a>
  queue_size[queue]--;
    800020be:	060a                	slli	a2,a2,0x2
    800020c0:	0000f797          	auipc	a5,0xf
    800020c4:	ad078793          	addi	a5,a5,-1328 # 80010b90 <pid_lock>
    800020c8:	963e                	add	a2,a2,a5
    800020ca:	da0c                	sw	a1,48(a2)
}
    800020cc:	6422                	ld	s0,8(sp)
    800020ce:	0141                	addi	sp,sp,16
    800020d0:	8082                	ret
    return 0;
    800020d2:	4501                	li	a0,0
    800020d4:	bfe5                	j	800020cc <dequeue+0x72>

00000000800020d6 <priority_boost>:
{
    800020d6:	7139                	addi	sp,sp,-64
    800020d8:	fc06                	sd	ra,56(sp)
    800020da:	f822                	sd	s0,48(sp)
    800020dc:	f426                	sd	s1,40(sp)
    800020de:	f04a                	sd	s2,32(sp)
    800020e0:	ec4e                	sd	s3,24(sp)
    800020e2:	e852                	sd	s4,16(sp)
    800020e4:	e456                	sd	s5,8(sp)
    800020e6:	0080                	addi	s0,sp,64
  for (int i = 1; i < 4; i++) {
    800020e8:	0000fa17          	auipc	s4,0xf
    800020ec:	ad8a0a13          	addi	s4,s4,-1320 # 80010bc0 <queue_size>
    800020f0:	4485                	li	s1,1
      p->time_slice = 1;
    800020f2:	4985                	li	s3,1
  for (int i = 1; i < 4; i++) {
    800020f4:	4a91                	li	s5,4
    while (queue_size[i] > 0) {
    800020f6:	8952                	mv	s2,s4
    800020f8:	004a2783          	lw	a5,4(s4)
    800020fc:	02f05663          	blez	a5,80002128 <priority_boost+0x52>
      p = dequeue(i);
    80002100:	8526                	mv	a0,s1
    80002102:	00000097          	auipc	ra,0x0
    80002106:	f58080e7          	jalr	-168(ra) # 8000205a <dequeue>
      p->mlfq_priority = 0;
    8000210a:	20052a23          	sw	zero,532(a0)
      p->mlfq_ticks = 0;
    8000210e:	20052e23          	sw	zero,540(a0)
      p->time_slice = 1;
    80002112:	21352c23          	sw	s3,536(a0)
      enqueue(p, 0);
    80002116:	4581                	li	a1,0
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	bde080e7          	jalr	-1058(ra) # 80001cf6 <enqueue>
    while (queue_size[i] > 0) {
    80002120:	00492783          	lw	a5,4(s2)
    80002124:	fcf04ee3          	bgtz	a5,80002100 <priority_boost+0x2a>
  for (int i = 1; i < 4; i++) {
    80002128:	2485                	addiw	s1,s1,1
    8000212a:	0a11                	addi	s4,s4,4
    8000212c:	fd5495e3          	bne	s1,s5,800020f6 <priority_boost+0x20>
}
    80002130:	70e2                	ld	ra,56(sp)
    80002132:	7442                	ld	s0,48(sp)
    80002134:	74a2                	ld	s1,40(sp)
    80002136:	7902                	ld	s2,32(sp)
    80002138:	69e2                	ld	s3,24(sp)
    8000213a:	6a42                	ld	s4,16(sp)
    8000213c:	6aa2                	ld	s5,8(sp)
    8000213e:	6121                	addi	sp,sp,64
    80002140:	8082                	ret

0000000080002142 <scheduler>:
{
    80002142:	7119                	addi	sp,sp,-128
    80002144:	fc86                	sd	ra,120(sp)
    80002146:	f8a2                	sd	s0,112(sp)
    80002148:	f4a6                	sd	s1,104(sp)
    8000214a:	f0ca                	sd	s2,96(sp)
    8000214c:	ecce                	sd	s3,88(sp)
    8000214e:	e8d2                	sd	s4,80(sp)
    80002150:	e4d6                	sd	s5,72(sp)
    80002152:	e0da                	sd	s6,64(sp)
    80002154:	fc5e                	sd	s7,56(sp)
    80002156:	f862                	sd	s8,48(sp)
    80002158:	f466                	sd	s9,40(sp)
    8000215a:	f06a                	sd	s10,32(sp)
    8000215c:	ec6e                	sd	s11,24(sp)
    8000215e:	0100                	addi	s0,sp,128
    80002160:	8792                	mv	a5,tp
  int id = r_tp();
    80002162:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002164:	00779693          	slli	a3,a5,0x7
    80002168:	0000f717          	auipc	a4,0xf
    8000216c:	a2870713          	addi	a4,a4,-1496 # 80010b90 <pid_lock>
    80002170:	9736                	add	a4,a4,a3
    80002172:	04073023          	sd	zero,64(a4)
            swtch(&c->context, &p->context);
    80002176:	0000f717          	auipc	a4,0xf
    8000217a:	a6270713          	addi	a4,a4,-1438 # 80010bd8 <cpus+0x8>
    8000217e:	9736                	add	a4,a4,a3
    80002180:	f8e43423          	sd	a4,-120(s0)
    80002184:	0000fd97          	auipc	s11,0xf
    80002188:	a48d8d93          	addi	s11,s11,-1464 # 80010bcc <queue_size+0xc>
            c->proc = p;
    8000218c:	0000f717          	auipc	a4,0xf
    80002190:	a0470713          	addi	a4,a4,-1532 # 80010b90 <pid_lock>
    80002194:	00d707b3          	add	a5,a4,a3
    80002198:	f8f43023          	sd	a5,-128(s0)
    8000219c:	a049                	j	8000221e <scheduler+0xdc>
            p->state = RUNNING;
    8000219e:	01a4ac23          	sw	s10,24(s1)
            c->proc = p;
    800021a2:	f8043b83          	ld	s7,-128(s0)
    800021a6:	049bb023          	sd	s1,64(s7) # fffffffffffff040 <end+0xffffffff7ffd9a90>
            swtch(&c->context, &p->context);
    800021aa:	06048593          	addi	a1,s1,96
    800021ae:	f8843503          	ld	a0,-120(s0)
    800021b2:	00001097          	auipc	ra,0x1
    800021b6:	b18080e7          	jalr	-1256(ra) # 80002cca <swtch>
            c->proc = 0;
    800021ba:	040bb023          	sd	zero,64(s7)
            found = 1;
    800021be:	8be6                	mv	s7,s9
    800021c0:	a035                	j	800021ec <scheduler+0xaa>
      for (int j = 0; j < queue_size[i] && !found; j++) {
    800021c2:	2905                	addiw	s2,s2,1
    800021c4:	000a2783          	lw	a5,0(s4)
    800021c8:	06f95b63          	bge	s2,a5,8000223e <scheduler+0xfc>
    800021cc:	09a1                	addi	s3,s3,8
        p = mlfq[i][j];
    800021ce:	0009b483          	ld	s1,0(s3)
        if(p && p->state == RUNNABLE) {
    800021d2:	d8e5                	beqz	s1,800021c2 <scheduler+0x80>
    800021d4:	4c9c                	lw	a5,24(s1)
    800021d6:	ff5796e3          	bne	a5,s5,800021c2 <scheduler+0x80>
          acquire(&p->lock);
    800021da:	8526                	mv	a0,s1
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	9fa080e7          	jalr	-1542(ra) # 80000bd6 <acquire>
          if(p->state == RUNNABLE) {
    800021e4:	4c9c                	lw	a5,24(s1)
    800021e6:	4b81                	li	s7,0
    800021e8:	fb578be3          	beq	a5,s5,8000219e <scheduler+0x5c>
          release(&p->lock);
    800021ec:	8526                	mv	a0,s1
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	a9c080e7          	jalr	-1380(ra) # 80000c8a <release>
      for (int j = 0; j < queue_size[i] && !found; j++) {
    800021f6:	2905                	addiw	s2,s2,1
    800021f8:	000a2783          	lw	a5,0(s4)
    800021fc:	04f95263          	bge	s2,a5,80002240 <scheduler+0xfe>
    80002200:	09a1                	addi	s3,s3,8
    80002202:	fc0b86e3          	beqz	s7,800021ce <scheduler+0x8c>
    for (int i = 0; i < 4 && !found; i++) {
    80002206:	01bb1d63          	bne	s6,s11,80002220 <scheduler+0xde>
    if (!found) {
    8000220a:	000b9b63          	bnez	s7,80002220 <scheduler+0xde>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000220e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002212:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002216:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000221a:	10500073          	wfi
        if(p && p->state == RUNNABLE) {
    8000221e:	4a8d                	li	s5,3
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002220:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002224:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002228:	10079073          	csrw	sstatus,a5
    for (int i = 0; i < 4 && !found; i++) {
    8000222c:	0000fb17          	auipc	s6,0xf
    80002230:	994b0b13          	addi	s6,s6,-1644 # 80010bc0 <queue_size>
    80002234:	00017c17          	auipc	s8,0x17
    80002238:	79cc0c13          	addi	s8,s8,1948 # 800199d0 <mlfq>
    8000223c:	a809                	j	8000224e <scheduler+0x10c>
      for (int j = 0; j < queue_size[i] && !found; j++) {
    8000223e:	4b81                	li	s7,0
    for (int i = 0; i < 4 && !found; i++) {
    80002240:	fdbb05e3          	beq	s6,s11,8000220a <scheduler+0xc8>
    80002244:	0b11                	addi	s6,s6,4
    80002246:	200c0c13          	addi	s8,s8,512
    8000224a:	fc0b9be3          	bnez	s7,80002220 <scheduler+0xde>
      for (int j = 0; j < queue_size[i] && !found; j++) {
    8000224e:	8a5a                	mv	s4,s6
    80002250:	000b2783          	lw	a5,0(s6)
    80002254:	89e2                	mv	s3,s8
    80002256:	4901                	li	s2,0
            p->state = RUNNING;
    80002258:	4d11                	li	s10,4
            found = 1;
    8000225a:	4c85                	li	s9,1
      for (int j = 0; j < queue_size[i] && !found; j++) {
    8000225c:	f6f049e3          	bgtz	a5,800021ce <scheduler+0x8c>
    for (int i = 0; i < 4 && !found; i++) {
    80002260:	fbbb07e3          	beq	s6,s11,8000220e <scheduler+0xcc>
    80002264:	4b81                	li	s7,0
    80002266:	bff9                	j	80002244 <scheduler+0x102>

0000000080002268 <sched>:
{
    80002268:	7179                	addi	sp,sp,-48
    8000226a:	f406                	sd	ra,40(sp)
    8000226c:	f022                	sd	s0,32(sp)
    8000226e:	ec26                	sd	s1,24(sp)
    80002270:	e84a                	sd	s2,16(sp)
    80002272:	e44e                	sd	s3,8(sp)
    80002274:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	76a080e7          	jalr	1898(ra) # 800019e0 <myproc>
    8000227e:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	8dc080e7          	jalr	-1828(ra) # 80000b5c <holding>
    80002288:	c93d                	beqz	a0,800022fe <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000228a:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000228c:	2781                	sext.w	a5,a5
    8000228e:	079e                	slli	a5,a5,0x7
    80002290:	0000f717          	auipc	a4,0xf
    80002294:	90070713          	addi	a4,a4,-1792 # 80010b90 <pid_lock>
    80002298:	97ba                	add	a5,a5,a4
    8000229a:	0b87a703          	lw	a4,184(a5)
    8000229e:	4785                	li	a5,1
    800022a0:	06f71763          	bne	a4,a5,8000230e <sched+0xa6>
  if (p->state == RUNNING)
    800022a4:	4c98                	lw	a4,24(s1)
    800022a6:	4791                	li	a5,4
    800022a8:	06f70b63          	beq	a4,a5,8000231e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022ac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800022b0:	8b89                	andi	a5,a5,2
  if (intr_get())
    800022b2:	efb5                	bnez	a5,8000232e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800022b4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800022b6:	0000f917          	auipc	s2,0xf
    800022ba:	8da90913          	addi	s2,s2,-1830 # 80010b90 <pid_lock>
    800022be:	2781                	sext.w	a5,a5
    800022c0:	079e                	slli	a5,a5,0x7
    800022c2:	97ca                	add	a5,a5,s2
    800022c4:	0bc7a983          	lw	s3,188(a5)
    800022c8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800022ca:	2781                	sext.w	a5,a5
    800022cc:	079e                	slli	a5,a5,0x7
    800022ce:	0000f597          	auipc	a1,0xf
    800022d2:	90a58593          	addi	a1,a1,-1782 # 80010bd8 <cpus+0x8>
    800022d6:	95be                	add	a1,a1,a5
    800022d8:	06048513          	addi	a0,s1,96
    800022dc:	00001097          	auipc	ra,0x1
    800022e0:	9ee080e7          	jalr	-1554(ra) # 80002cca <swtch>
    800022e4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800022e6:	2781                	sext.w	a5,a5
    800022e8:	079e                	slli	a5,a5,0x7
    800022ea:	97ca                	add	a5,a5,s2
    800022ec:	0b37ae23          	sw	s3,188(a5)
}
    800022f0:	70a2                	ld	ra,40(sp)
    800022f2:	7402                	ld	s0,32(sp)
    800022f4:	64e2                	ld	s1,24(sp)
    800022f6:	6942                	ld	s2,16(sp)
    800022f8:	69a2                	ld	s3,8(sp)
    800022fa:	6145                	addi	sp,sp,48
    800022fc:	8082                	ret
    panic("sched p->lock");
    800022fe:	00006517          	auipc	a0,0x6
    80002302:	f1a50513          	addi	a0,a0,-230 # 80008218 <etext+0x218>
    80002306:	ffffe097          	auipc	ra,0xffffe
    8000230a:	238080e7          	jalr	568(ra) # 8000053e <panic>
    panic("sched locks");
    8000230e:	00006517          	auipc	a0,0x6
    80002312:	f1a50513          	addi	a0,a0,-230 # 80008228 <etext+0x228>
    80002316:	ffffe097          	auipc	ra,0xffffe
    8000231a:	228080e7          	jalr	552(ra) # 8000053e <panic>
    panic("sched running");
    8000231e:	00006517          	auipc	a0,0x6
    80002322:	f1a50513          	addi	a0,a0,-230 # 80008238 <etext+0x238>
    80002326:	ffffe097          	auipc	ra,0xffffe
    8000232a:	218080e7          	jalr	536(ra) # 8000053e <panic>
    panic("sched interruptible");
    8000232e:	00006517          	auipc	a0,0x6
    80002332:	f1a50513          	addi	a0,a0,-230 # 80008248 <etext+0x248>
    80002336:	ffffe097          	auipc	ra,0xffffe
    8000233a:	208080e7          	jalr	520(ra) # 8000053e <panic>

000000008000233e <yield>:
{
    8000233e:	715d                	addi	sp,sp,-80
    80002340:	e486                	sd	ra,72(sp)
    80002342:	e0a2                	sd	s0,64(sp)
    80002344:	fc26                	sd	s1,56(sp)
    80002346:	f84a                	sd	s2,48(sp)
    80002348:	f44e                	sd	s3,40(sp)
    8000234a:	f052                	sd	s4,32(sp)
    8000234c:	ec56                	sd	s5,24(sp)
    8000234e:	e85a                	sd	s6,16(sp)
    80002350:	e45e                	sd	s7,8(sp)
    80002352:	e062                	sd	s8,0(sp)
    80002354:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	68a080e7          	jalr	1674(ra) # 800019e0 <myproc>
    8000235e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002360:	fffff097          	auipc	ra,0xfffff
    80002364:	876080e7          	jalr	-1930(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    80002368:	478d                	li	a5,3
    8000236a:	cc9c                	sw	a5,24(s1)
  for (int i = 0; i < 4; i++) {
    8000236c:	0000f917          	auipc	s2,0xf
    80002370:	85490913          	addi	s2,s2,-1964 # 80010bc0 <queue_size>
    80002374:	00017a97          	auipc	s5,0x17
    80002378:	65ca8a93          	addi	s5,s5,1628 # 800199d0 <mlfq>
  p->state = RUNNABLE;
    8000237c:	8a56                	mv	s4,s5
    8000237e:	4981                	li	s3,0
    for (int j = 0; j < queue_size[i]; j++) {
    80002380:	4b81                	li	s7,0
    80002382:	8c56                	mv	s8,s5
    80002384:	0aa1                	addi	s5,s5,8
  for (int i = 0; i < 4; i++) {
    80002386:	10000b13          	li	s6,256
    8000238a:	a881                	j	800023da <yield+0x9c>
        for (int k = j; k < queue_size[i] - 1; k++) {
    8000238c:	fff6861b          	addiw	a2,a3,-1
    80002390:	0006071b          	sext.w	a4,a2
    80002394:	02e7d463          	bge	a5,a4,800023bc <yield+0x7e>
    80002398:	01378533          	add	a0,a5,s3
    8000239c:	00351713          	slli	a4,a0,0x3
    800023a0:	9762                	add	a4,a4,s8
    800023a2:	36f9                	addiw	a3,a3,-2
    800023a4:	40f687bb          	subw	a5,a3,a5
    800023a8:	1782                	slli	a5,a5,0x20
    800023aa:	9381                	srli	a5,a5,0x20
    800023ac:	97aa                	add	a5,a5,a0
    800023ae:	078e                	slli	a5,a5,0x3
    800023b0:	97d6                	add	a5,a5,s5
          mlfq[i][k] = mlfq[i][k+1];
    800023b2:	6714                	ld	a3,8(a4)
    800023b4:	e314                	sd	a3,0(a4)
        for (int k = j; k < queue_size[i] - 1; k++) {
    800023b6:	0721                	addi	a4,a4,8
    800023b8:	fef71de3          	bne	a4,a5,800023b2 <yield+0x74>
        queue_size[i]--;
    800023bc:	c190                	sw	a2,0(a1)
        enqueue(p, p->mlfq_priority);
    800023be:	2144a583          	lw	a1,532(s1)
    800023c2:	8526                	mv	a0,s1
    800023c4:	00000097          	auipc	ra,0x0
    800023c8:	932080e7          	jalr	-1742(ra) # 80001cf6 <enqueue>
  for (int i = 0; i < 4; i++) {
    800023cc:	0911                	addi	s2,s2,4
    800023ce:	200a0a13          	addi	s4,s4,512
    800023d2:	04098993          	addi	s3,s3,64
    800023d6:	03698163          	beq	s3,s6,800023f8 <yield+0xba>
    for (int j = 0; j < queue_size[i]; j++) {
    800023da:	85ca                	mv	a1,s2
    800023dc:	00092683          	lw	a3,0(s2)
    800023e0:	8752                	mv	a4,s4
    800023e2:	87de                	mv	a5,s7
    800023e4:	fed054e3          	blez	a3,800023cc <yield+0x8e>
      if (mlfq[i][j] == p) {
    800023e8:	6310                	ld	a2,0(a4)
    800023ea:	fa9601e3          	beq	a2,s1,8000238c <yield+0x4e>
    for (int j = 0; j < queue_size[i]; j++) {
    800023ee:	2785                	addiw	a5,a5,1
    800023f0:	0721                	addi	a4,a4,8
    800023f2:	fed79be3          	bne	a5,a3,800023e8 <yield+0xaa>
    800023f6:	bfd9                	j	800023cc <yield+0x8e>
  sched();
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	e70080e7          	jalr	-400(ra) # 80002268 <sched>
  release(&p->lock);
    80002400:	8526                	mv	a0,s1
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	888080e7          	jalr	-1912(ra) # 80000c8a <release>
}
    8000240a:	60a6                	ld	ra,72(sp)
    8000240c:	6406                	ld	s0,64(sp)
    8000240e:	74e2                	ld	s1,56(sp)
    80002410:	7942                	ld	s2,48(sp)
    80002412:	79a2                	ld	s3,40(sp)
    80002414:	7a02                	ld	s4,32(sp)
    80002416:	6ae2                	ld	s5,24(sp)
    80002418:	6b42                	ld	s6,16(sp)
    8000241a:	6ba2                	ld	s7,8(sp)
    8000241c:	6c02                	ld	s8,0(sp)
    8000241e:	6161                	addi	sp,sp,80
    80002420:	8082                	ret

0000000080002422 <update_ticks>:
{
    80002422:	1101                	addi	sp,sp,-32
    80002424:	ec06                	sd	ra,24(sp)
    80002426:	e822                	sd	s0,16(sp)
    80002428:	e426                	sd	s1,8(sp)
    8000242a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	5b4080e7          	jalr	1460(ra) # 800019e0 <myproc>
  if(p != 0) {
    80002434:	cd15                	beqz	a0,80002470 <update_ticks+0x4e>
    80002436:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002438:	ffffe097          	auipc	ra,0xffffe
    8000243c:	79e080e7          	jalr	1950(ra) # 80000bd6 <acquire>
    p->total_ticks++;
    80002440:	2204a783          	lw	a5,544(s1)
    80002444:	2785                	addiw	a5,a5,1
    80002446:	22f4a023          	sw	a5,544(s1)
    p->mlfq_ticks++;
    8000244a:	21c4a783          	lw	a5,540(s1)
    8000244e:	2785                	addiw	a5,a5,1
    80002450:	20f4ae23          	sw	a5,540(s1)
    p->time_slice--;
    80002454:	2184a783          	lw	a5,536(s1)
    80002458:	37fd                	addiw	a5,a5,-1
    8000245a:	0007871b          	sext.w	a4,a5
    8000245e:	20f4ac23          	sw	a5,536(s1)
    if(p->time_slice <= 0) {
    80002462:	04e05963          	blez	a4,800024b4 <update_ticks+0x92>
    release(&p->lock);
    80002466:	8526                	mv	a0,s1
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	822080e7          	jalr	-2014(ra) # 80000c8a <release>
  acquire(&tickslock);
    80002470:	00018517          	auipc	a0,0x18
    80002474:	d6050513          	addi	a0,a0,-672 # 8001a1d0 <tickslock>
    80002478:	ffffe097          	auipc	ra,0xffffe
    8000247c:	75e080e7          	jalr	1886(ra) # 80000bd6 <acquire>
  global_ticks++;
    80002480:	00006717          	auipc	a4,0x6
    80002484:	4a070713          	addi	a4,a4,1184 # 80008920 <global_ticks>
    80002488:	431c                	lw	a5,0(a4)
    8000248a:	2785                	addiw	a5,a5,1
    8000248c:	0007869b          	sext.w	a3,a5
    80002490:	c31c                	sw	a5,0(a4)
  if(global_ticks >= 48) {
    80002492:	02f00793          	li	a5,47
    80002496:	02d7c463          	blt	a5,a3,800024be <update_ticks+0x9c>
  release(&tickslock);
    8000249a:	00018517          	auipc	a0,0x18
    8000249e:	d3650513          	addi	a0,a0,-714 # 8001a1d0 <tickslock>
    800024a2:	ffffe097          	auipc	ra,0xffffe
    800024a6:	7e8080e7          	jalr	2024(ra) # 80000c8a <release>
}
    800024aa:	60e2                	ld	ra,24(sp)
    800024ac:	6442                	ld	s0,16(sp)
    800024ae:	64a2                	ld	s1,8(sp)
    800024b0:	6105                	addi	sp,sp,32
    800024b2:	8082                	ret
      yield();
    800024b4:	00000097          	auipc	ra,0x0
    800024b8:	e8a080e7          	jalr	-374(ra) # 8000233e <yield>
    800024bc:	b76d                	j	80002466 <update_ticks+0x44>
    priority_boost();
    800024be:	00000097          	auipc	ra,0x0
    800024c2:	c18080e7          	jalr	-1000(ra) # 800020d6 <priority_boost>
    global_ticks = 0;
    800024c6:	00006797          	auipc	a5,0x6
    800024ca:	4407ad23          	sw	zero,1114(a5) # 80008920 <global_ticks>
    800024ce:	b7f1                	j	8000249a <update_ticks+0x78>

00000000800024d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	e84a                	sd	s2,16(sp)
    800024da:	e44e                	sd	s3,8(sp)
    800024dc:	1800                	addi	s0,sp,48
    800024de:	89aa                	mv	s3,a0
    800024e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800024e2:	fffff097          	auipc	ra,0xfffff
    800024e6:	4fe080e7          	jalr	1278(ra) # 800019e0 <myproc>
    800024ea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800024ec:	ffffe097          	auipc	ra,0xffffe
    800024f0:	6ea080e7          	jalr	1770(ra) # 80000bd6 <acquire>
  release(lk);
    800024f4:	854a                	mv	a0,s2
    800024f6:	ffffe097          	auipc	ra,0xffffe
    800024fa:	794080e7          	jalr	1940(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    800024fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002502:	4789                	li	a5,2
    80002504:	cc9c                	sw	a5,24(s1)

  sched();
    80002506:	00000097          	auipc	ra,0x0
    8000250a:	d62080e7          	jalr	-670(ra) # 80002268 <sched>

  // Tidy up.
  p->chan = 0;
    8000250e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002512:	8526                	mv	a0,s1
    80002514:	ffffe097          	auipc	ra,0xffffe
    80002518:	776080e7          	jalr	1910(ra) # 80000c8a <release>
  acquire(lk);
    8000251c:	854a                	mv	a0,s2
    8000251e:	ffffe097          	auipc	ra,0xffffe
    80002522:	6b8080e7          	jalr	1720(ra) # 80000bd6 <acquire>
}
    80002526:	70a2                	ld	ra,40(sp)
    80002528:	7402                	ld	s0,32(sp)
    8000252a:	64e2                	ld	s1,24(sp)
    8000252c:	6942                	ld	s2,16(sp)
    8000252e:	69a2                	ld	s3,8(sp)
    80002530:	6145                	addi	sp,sp,48
    80002532:	8082                	ret

0000000080002534 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002534:	7139                	addi	sp,sp,-64
    80002536:	fc06                	sd	ra,56(sp)
    80002538:	f822                	sd	s0,48(sp)
    8000253a:	f426                	sd	s1,40(sp)
    8000253c:	f04a                	sd	s2,32(sp)
    8000253e:	ec4e                	sd	s3,24(sp)
    80002540:	e852                	sd	s4,16(sp)
    80002542:	e456                	sd	s5,8(sp)
    80002544:	0080                	addi	s0,sp,64
    80002546:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002548:	0000f497          	auipc	s1,0xf
    8000254c:	a8848493          	addi	s1,s1,-1400 # 80010fd0 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002550:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    80002552:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002554:	00017917          	auipc	s2,0x17
    80002558:	47c90913          	addi	s2,s2,1148 # 800199d0 <mlfq>
    8000255c:	a811                	j	80002570 <wakeup+0x3c>
      }
      release(&p->lock);
    8000255e:	8526                	mv	a0,s1
    80002560:	ffffe097          	auipc	ra,0xffffe
    80002564:	72a080e7          	jalr	1834(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002568:	22848493          	addi	s1,s1,552
    8000256c:	03248663          	beq	s1,s2,80002598 <wakeup+0x64>
    if (p != myproc())
    80002570:	fffff097          	auipc	ra,0xfffff
    80002574:	470080e7          	jalr	1136(ra) # 800019e0 <myproc>
    80002578:	fea488e3          	beq	s1,a0,80002568 <wakeup+0x34>
      acquire(&p->lock);
    8000257c:	8526                	mv	a0,s1
    8000257e:	ffffe097          	auipc	ra,0xffffe
    80002582:	658080e7          	jalr	1624(ra) # 80000bd6 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80002586:	4c9c                	lw	a5,24(s1)
    80002588:	fd379be3          	bne	a5,s3,8000255e <wakeup+0x2a>
    8000258c:	709c                	ld	a5,32(s1)
    8000258e:	fd4798e3          	bne	a5,s4,8000255e <wakeup+0x2a>
        p->state = RUNNABLE;
    80002592:	0154ac23          	sw	s5,24(s1)
    80002596:	b7e1                	j	8000255e <wakeup+0x2a>
    }
  }
}
    80002598:	70e2                	ld	ra,56(sp)
    8000259a:	7442                	ld	s0,48(sp)
    8000259c:	74a2                	ld	s1,40(sp)
    8000259e:	7902                	ld	s2,32(sp)
    800025a0:	69e2                	ld	s3,24(sp)
    800025a2:	6a42                	ld	s4,16(sp)
    800025a4:	6aa2                	ld	s5,8(sp)
    800025a6:	6121                	addi	sp,sp,64
    800025a8:	8082                	ret

00000000800025aa <reparent>:
{
    800025aa:	7179                	addi	sp,sp,-48
    800025ac:	f406                	sd	ra,40(sp)
    800025ae:	f022                	sd	s0,32(sp)
    800025b0:	ec26                	sd	s1,24(sp)
    800025b2:	e84a                	sd	s2,16(sp)
    800025b4:	e44e                	sd	s3,8(sp)
    800025b6:	e052                	sd	s4,0(sp)
    800025b8:	1800                	addi	s0,sp,48
    800025ba:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800025bc:	0000f497          	auipc	s1,0xf
    800025c0:	a1448493          	addi	s1,s1,-1516 # 80010fd0 <proc>
      pp->parent = initproc;
    800025c4:	00006a17          	auipc	s4,0x6
    800025c8:	354a0a13          	addi	s4,s4,852 # 80008918 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800025cc:	00017997          	auipc	s3,0x17
    800025d0:	40498993          	addi	s3,s3,1028 # 800199d0 <mlfq>
    800025d4:	a029                	j	800025de <reparent+0x34>
    800025d6:	22848493          	addi	s1,s1,552
    800025da:	01348d63          	beq	s1,s3,800025f4 <reparent+0x4a>
    if (pp->parent == p)
    800025de:	7c9c                	ld	a5,56(s1)
    800025e0:	ff279be3          	bne	a5,s2,800025d6 <reparent+0x2c>
      pp->parent = initproc;
    800025e4:	000a3503          	ld	a0,0(s4)
    800025e8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800025ea:	00000097          	auipc	ra,0x0
    800025ee:	f4a080e7          	jalr	-182(ra) # 80002534 <wakeup>
    800025f2:	b7d5                	j	800025d6 <reparent+0x2c>
}
    800025f4:	70a2                	ld	ra,40(sp)
    800025f6:	7402                	ld	s0,32(sp)
    800025f8:	64e2                	ld	s1,24(sp)
    800025fa:	6942                	ld	s2,16(sp)
    800025fc:	69a2                	ld	s3,8(sp)
    800025fe:	6a02                	ld	s4,0(sp)
    80002600:	6145                	addi	sp,sp,48
    80002602:	8082                	ret

0000000080002604 <exit>:
{
    80002604:	7179                	addi	sp,sp,-48
    80002606:	f406                	sd	ra,40(sp)
    80002608:	f022                	sd	s0,32(sp)
    8000260a:	ec26                	sd	s1,24(sp)
    8000260c:	e84a                	sd	s2,16(sp)
    8000260e:	e44e                	sd	s3,8(sp)
    80002610:	e052                	sd	s4,0(sp)
    80002612:	1800                	addi	s0,sp,48
    80002614:	89aa                	mv	s3,a0
  struct proc *p = myproc();
    80002616:	fffff097          	auipc	ra,0xfffff
    8000261a:	3ca080e7          	jalr	970(ra) # 800019e0 <myproc>
    8000261e:	892a                	mv	s2,a0
  if (p == initproc)
    80002620:	00006797          	auipc	a5,0x6
    80002624:	2f87b783          	ld	a5,760(a5) # 80008918 <initproc>
    80002628:	0d050493          	addi	s1,a0,208
    8000262c:	15050a13          	addi	s4,a0,336
    80002630:	00a79d63          	bne	a5,a0,8000264a <exit+0x46>
    panic("init exiting");
    80002634:	00006517          	auipc	a0,0x6
    80002638:	c2c50513          	addi	a0,a0,-980 # 80008260 <etext+0x260>
    8000263c:	ffffe097          	auipc	ra,0xffffe
    80002640:	f02080e7          	jalr	-254(ra) # 8000053e <panic>
  for (int fd = 0; fd < NOFILE; fd++)
    80002644:	04a1                	addi	s1,s1,8
    80002646:	01448b63          	beq	s1,s4,8000265c <exit+0x58>
    if (p->ofile[fd])
    8000264a:	6088                	ld	a0,0(s1)
    8000264c:	dd65                	beqz	a0,80002644 <exit+0x40>
      fileclose(f);
    8000264e:	00003097          	auipc	ra,0x3
    80002652:	8be080e7          	jalr	-1858(ra) # 80004f0c <fileclose>
      p->ofile[fd] = 0;
    80002656:	0004b023          	sd	zero,0(s1)
    8000265a:	b7ed                	j	80002644 <exit+0x40>
  if (p->parent) {
    8000265c:	03893503          	ld	a0,56(s2)
    80002660:	cd1d                	beqz	a0,8000269e <exit+0x9a>
    acquire(&p->parent->lock);
    80002662:	ffffe097          	auipc	ra,0xffffe
    80002666:	574080e7          	jalr	1396(ra) # 80000bd6 <acquire>
    for (int i = 0; i < 32; i++) {
    8000266a:	17490613          	addi	a2,s2,372
    8000266e:	4701                	li	a4,0
    80002670:	02000513          	li	a0,32
      p->parent->syscalls[i] += p->syscalls[i];
    80002674:	00271693          	slli	a3,a4,0x2
    80002678:	03893783          	ld	a5,56(s2)
    8000267c:	97b6                	add	a5,a5,a3
    8000267e:	1747a683          	lw	a3,372(a5)
    80002682:	420c                	lw	a1,0(a2)
    80002684:	9ead                	addw	a3,a3,a1
    80002686:	16d7aa23          	sw	a3,372(a5)
    for (int i = 0; i < 32; i++) {
    8000268a:	2705                	addiw	a4,a4,1
    8000268c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000268e:	fea713e3          	bne	a4,a0,80002674 <exit+0x70>
    release(&p->parent->lock);
    80002692:	03893503          	ld	a0,56(s2)
    80002696:	ffffe097          	auipc	ra,0xffffe
    8000269a:	5f4080e7          	jalr	1524(ra) # 80000c8a <release>
  begin_op();
    8000269e:	00002097          	auipc	ra,0x2
    800026a2:	3a2080e7          	jalr	930(ra) # 80004a40 <begin_op>
  iput(p->cwd);
    800026a6:	15093503          	ld	a0,336(s2)
    800026aa:	00002097          	auipc	ra,0x2
    800026ae:	b8e080e7          	jalr	-1138(ra) # 80004238 <iput>
  end_op();
    800026b2:	00002097          	auipc	ra,0x2
    800026b6:	40e080e7          	jalr	1038(ra) # 80004ac0 <end_op>
  p->cwd = 0;
    800026ba:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800026be:	0000e497          	auipc	s1,0xe
    800026c2:	4ea48493          	addi	s1,s1,1258 # 80010ba8 <wait_lock>
    800026c6:	8526                	mv	a0,s1
    800026c8:	ffffe097          	auipc	ra,0xffffe
    800026cc:	50e080e7          	jalr	1294(ra) # 80000bd6 <acquire>
  reparent(p);
    800026d0:	854a                	mv	a0,s2
    800026d2:	00000097          	auipc	ra,0x0
    800026d6:	ed8080e7          	jalr	-296(ra) # 800025aa <reparent>
  wakeup(p->parent);
    800026da:	03893503          	ld	a0,56(s2)
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	e56080e7          	jalr	-426(ra) # 80002534 <wakeup>
  acquire(&p->lock);
    800026e6:	854a                	mv	a0,s2
    800026e8:	ffffe097          	auipc	ra,0xffffe
    800026ec:	4ee080e7          	jalr	1262(ra) # 80000bd6 <acquire>
  p->xstate = status;
    800026f0:	03392623          	sw	s3,44(s2)
  p->state = ZOMBIE;
    800026f4:	4795                	li	a5,5
    800026f6:	00f92c23          	sw	a5,24(s2)
  p->etime = ticks;
    800026fa:	00006797          	auipc	a5,0x6
    800026fe:	22a7a783          	lw	a5,554(a5) # 80008924 <ticks>
    80002702:	16f92823          	sw	a5,368(s2)
  release(&wait_lock);
    80002706:	8526                	mv	a0,s1
    80002708:	ffffe097          	auipc	ra,0xffffe
    8000270c:	582080e7          	jalr	1410(ra) # 80000c8a <release>
  sched();
    80002710:	00000097          	auipc	ra,0x0
    80002714:	b58080e7          	jalr	-1192(ra) # 80002268 <sched>
  panic("zombie exit");
    80002718:	00006517          	auipc	a0,0x6
    8000271c:	b5850513          	addi	a0,a0,-1192 # 80008270 <etext+0x270>
    80002720:	ffffe097          	auipc	ra,0xffffe
    80002724:	e1e080e7          	jalr	-482(ra) # 8000053e <panic>

0000000080002728 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002728:	7179                	addi	sp,sp,-48
    8000272a:	f406                	sd	ra,40(sp)
    8000272c:	f022                	sd	s0,32(sp)
    8000272e:	ec26                	sd	s1,24(sp)
    80002730:	e84a                	sd	s2,16(sp)
    80002732:	e44e                	sd	s3,8(sp)
    80002734:	1800                	addi	s0,sp,48
    80002736:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002738:	0000f497          	auipc	s1,0xf
    8000273c:	89848493          	addi	s1,s1,-1896 # 80010fd0 <proc>
    80002740:	00017997          	auipc	s3,0x17
    80002744:	29098993          	addi	s3,s3,656 # 800199d0 <mlfq>
  {
    acquire(&p->lock);
    80002748:	8526                	mv	a0,s1
    8000274a:	ffffe097          	auipc	ra,0xffffe
    8000274e:	48c080e7          	jalr	1164(ra) # 80000bd6 <acquire>
    if (p->pid == pid)
    80002752:	589c                	lw	a5,48(s1)
    80002754:	01278d63          	beq	a5,s2,8000276e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002758:	8526                	mv	a0,s1
    8000275a:	ffffe097          	auipc	ra,0xffffe
    8000275e:	530080e7          	jalr	1328(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002762:	22848493          	addi	s1,s1,552
    80002766:	ff3491e3          	bne	s1,s3,80002748 <kill+0x20>
  }
  return -1;
    8000276a:	557d                	li	a0,-1
    8000276c:	a829                	j	80002786 <kill+0x5e>
      p->killed = 1;
    8000276e:	4785                	li	a5,1
    80002770:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002772:	4c98                	lw	a4,24(s1)
    80002774:	4789                	li	a5,2
    80002776:	00f70f63          	beq	a4,a5,80002794 <kill+0x6c>
      release(&p->lock);
    8000277a:	8526                	mv	a0,s1
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	50e080e7          	jalr	1294(ra) # 80000c8a <release>
      return 0;
    80002784:	4501                	li	a0,0
}
    80002786:	70a2                	ld	ra,40(sp)
    80002788:	7402                	ld	s0,32(sp)
    8000278a:	64e2                	ld	s1,24(sp)
    8000278c:	6942                	ld	s2,16(sp)
    8000278e:	69a2                	ld	s3,8(sp)
    80002790:	6145                	addi	sp,sp,48
    80002792:	8082                	ret
        p->state = RUNNABLE;
    80002794:	478d                	li	a5,3
    80002796:	cc9c                	sw	a5,24(s1)
    80002798:	b7cd                	j	8000277a <kill+0x52>

000000008000279a <setkilled>:

void setkilled(struct proc *p)
{
    8000279a:	1101                	addi	sp,sp,-32
    8000279c:	ec06                	sd	ra,24(sp)
    8000279e:	e822                	sd	s0,16(sp)
    800027a0:	e426                	sd	s1,8(sp)
    800027a2:	1000                	addi	s0,sp,32
    800027a4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800027a6:	ffffe097          	auipc	ra,0xffffe
    800027aa:	430080e7          	jalr	1072(ra) # 80000bd6 <acquire>
  p->killed = 1;
    800027ae:	4785                	li	a5,1
    800027b0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800027b2:	8526                	mv	a0,s1
    800027b4:	ffffe097          	auipc	ra,0xffffe
    800027b8:	4d6080e7          	jalr	1238(ra) # 80000c8a <release>
}
    800027bc:	60e2                	ld	ra,24(sp)
    800027be:	6442                	ld	s0,16(sp)
    800027c0:	64a2                	ld	s1,8(sp)
    800027c2:	6105                	addi	sp,sp,32
    800027c4:	8082                	ret

00000000800027c6 <killed>:

int killed(struct proc *p)
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	e04a                	sd	s2,0(sp)
    800027d0:	1000                	addi	s0,sp,32
    800027d2:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800027d4:	ffffe097          	auipc	ra,0xffffe
    800027d8:	402080e7          	jalr	1026(ra) # 80000bd6 <acquire>
  k = p->killed;
    800027dc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800027e0:	8526                	mv	a0,s1
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	4a8080e7          	jalr	1192(ra) # 80000c8a <release>
  return k;
}
    800027ea:	854a                	mv	a0,s2
    800027ec:	60e2                	ld	ra,24(sp)
    800027ee:	6442                	ld	s0,16(sp)
    800027f0:	64a2                	ld	s1,8(sp)
    800027f2:	6902                	ld	s2,0(sp)
    800027f4:	6105                	addi	sp,sp,32
    800027f6:	8082                	ret

00000000800027f8 <wait>:
{
    800027f8:	715d                	addi	sp,sp,-80
    800027fa:	e486                	sd	ra,72(sp)
    800027fc:	e0a2                	sd	s0,64(sp)
    800027fe:	fc26                	sd	s1,56(sp)
    80002800:	f84a                	sd	s2,48(sp)
    80002802:	f44e                	sd	s3,40(sp)
    80002804:	f052                	sd	s4,32(sp)
    80002806:	ec56                	sd	s5,24(sp)
    80002808:	e85a                	sd	s6,16(sp)
    8000280a:	e45e                	sd	s7,8(sp)
    8000280c:	e062                	sd	s8,0(sp)
    8000280e:	0880                	addi	s0,sp,80
    80002810:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002812:	fffff097          	auipc	ra,0xfffff
    80002816:	1ce080e7          	jalr	462(ra) # 800019e0 <myproc>
    8000281a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000281c:	0000e517          	auipc	a0,0xe
    80002820:	38c50513          	addi	a0,a0,908 # 80010ba8 <wait_lock>
    80002824:	ffffe097          	auipc	ra,0xffffe
    80002828:	3b2080e7          	jalr	946(ra) # 80000bd6 <acquire>
    havekids = 0;
    8000282c:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    8000282e:	4a15                	li	s4,5
        havekids = 1;
    80002830:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002832:	00017997          	auipc	s3,0x17
    80002836:	19e98993          	addi	s3,s3,414 # 800199d0 <mlfq>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000283a:	0000ec17          	auipc	s8,0xe
    8000283e:	36ec0c13          	addi	s8,s8,878 # 80010ba8 <wait_lock>
    havekids = 0;
    80002842:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002844:	0000e497          	auipc	s1,0xe
    80002848:	78c48493          	addi	s1,s1,1932 # 80010fd0 <proc>
    8000284c:	a0bd                	j	800028ba <wait+0xc2>
          pid = pp->pid;
    8000284e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002852:	000b0e63          	beqz	s6,8000286e <wait+0x76>
    80002856:	4691                	li	a3,4
    80002858:	02c48613          	addi	a2,s1,44
    8000285c:	85da                	mv	a1,s6
    8000285e:	05093503          	ld	a0,80(s2)
    80002862:	fffff097          	auipc	ra,0xfffff
    80002866:	e06080e7          	jalr	-506(ra) # 80001668 <copyout>
    8000286a:	02054563          	bltz	a0,80002894 <wait+0x9c>
          freeproc(pp);
    8000286e:	8526                	mv	a0,s1
    80002870:	fffff097          	auipc	ra,0xfffff
    80002874:	322080e7          	jalr	802(ra) # 80001b92 <freeproc>
          release(&pp->lock);
    80002878:	8526                	mv	a0,s1
    8000287a:	ffffe097          	auipc	ra,0xffffe
    8000287e:	410080e7          	jalr	1040(ra) # 80000c8a <release>
          release(&wait_lock);
    80002882:	0000e517          	auipc	a0,0xe
    80002886:	32650513          	addi	a0,a0,806 # 80010ba8 <wait_lock>
    8000288a:	ffffe097          	auipc	ra,0xffffe
    8000288e:	400080e7          	jalr	1024(ra) # 80000c8a <release>
          return pid;
    80002892:	a0b5                	j	800028fe <wait+0x106>
            release(&pp->lock);
    80002894:	8526                	mv	a0,s1
    80002896:	ffffe097          	auipc	ra,0xffffe
    8000289a:	3f4080e7          	jalr	1012(ra) # 80000c8a <release>
            release(&wait_lock);
    8000289e:	0000e517          	auipc	a0,0xe
    800028a2:	30a50513          	addi	a0,a0,778 # 80010ba8 <wait_lock>
    800028a6:	ffffe097          	auipc	ra,0xffffe
    800028aa:	3e4080e7          	jalr	996(ra) # 80000c8a <release>
            return -1;
    800028ae:	59fd                	li	s3,-1
    800028b0:	a0b9                	j	800028fe <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800028b2:	22848493          	addi	s1,s1,552
    800028b6:	03348463          	beq	s1,s3,800028de <wait+0xe6>
      if (pp->parent == p)
    800028ba:	7c9c                	ld	a5,56(s1)
    800028bc:	ff279be3          	bne	a5,s2,800028b2 <wait+0xba>
        acquire(&pp->lock);
    800028c0:	8526                	mv	a0,s1
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	314080e7          	jalr	788(ra) # 80000bd6 <acquire>
        if (pp->state == ZOMBIE)
    800028ca:	4c9c                	lw	a5,24(s1)
    800028cc:	f94781e3          	beq	a5,s4,8000284e <wait+0x56>
        release(&pp->lock);
    800028d0:	8526                	mv	a0,s1
    800028d2:	ffffe097          	auipc	ra,0xffffe
    800028d6:	3b8080e7          	jalr	952(ra) # 80000c8a <release>
        havekids = 1;
    800028da:	8756                	mv	a4,s5
    800028dc:	bfd9                	j	800028b2 <wait+0xba>
    if (!havekids || killed(p))
    800028de:	c719                	beqz	a4,800028ec <wait+0xf4>
    800028e0:	854a                	mv	a0,s2
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	ee4080e7          	jalr	-284(ra) # 800027c6 <killed>
    800028ea:	c51d                	beqz	a0,80002918 <wait+0x120>
      release(&wait_lock);
    800028ec:	0000e517          	auipc	a0,0xe
    800028f0:	2bc50513          	addi	a0,a0,700 # 80010ba8 <wait_lock>
    800028f4:	ffffe097          	auipc	ra,0xffffe
    800028f8:	396080e7          	jalr	918(ra) # 80000c8a <release>
      return -1;
    800028fc:	59fd                	li	s3,-1
}
    800028fe:	854e                	mv	a0,s3
    80002900:	60a6                	ld	ra,72(sp)
    80002902:	6406                	ld	s0,64(sp)
    80002904:	74e2                	ld	s1,56(sp)
    80002906:	7942                	ld	s2,48(sp)
    80002908:	79a2                	ld	s3,40(sp)
    8000290a:	7a02                	ld	s4,32(sp)
    8000290c:	6ae2                	ld	s5,24(sp)
    8000290e:	6b42                	ld	s6,16(sp)
    80002910:	6ba2                	ld	s7,8(sp)
    80002912:	6c02                	ld	s8,0(sp)
    80002914:	6161                	addi	sp,sp,80
    80002916:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002918:	85e2                	mv	a1,s8
    8000291a:	854a                	mv	a0,s2
    8000291c:	00000097          	auipc	ra,0x0
    80002920:	bb4080e7          	jalr	-1100(ra) # 800024d0 <sleep>
    havekids = 0;
    80002924:	bf39                	j	80002842 <wait+0x4a>

0000000080002926 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002926:	7179                	addi	sp,sp,-48
    80002928:	f406                	sd	ra,40(sp)
    8000292a:	f022                	sd	s0,32(sp)
    8000292c:	ec26                	sd	s1,24(sp)
    8000292e:	e84a                	sd	s2,16(sp)
    80002930:	e44e                	sd	s3,8(sp)
    80002932:	e052                	sd	s4,0(sp)
    80002934:	1800                	addi	s0,sp,48
    80002936:	84aa                	mv	s1,a0
    80002938:	892e                	mv	s2,a1
    8000293a:	89b2                	mv	s3,a2
    8000293c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000293e:	fffff097          	auipc	ra,0xfffff
    80002942:	0a2080e7          	jalr	162(ra) # 800019e0 <myproc>
  if (user_dst)
    80002946:	c08d                	beqz	s1,80002968 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80002948:	86d2                	mv	a3,s4
    8000294a:	864e                	mv	a2,s3
    8000294c:	85ca                	mv	a1,s2
    8000294e:	6928                	ld	a0,80(a0)
    80002950:	fffff097          	auipc	ra,0xfffff
    80002954:	d18080e7          	jalr	-744(ra) # 80001668 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002958:	70a2                	ld	ra,40(sp)
    8000295a:	7402                	ld	s0,32(sp)
    8000295c:	64e2                	ld	s1,24(sp)
    8000295e:	6942                	ld	s2,16(sp)
    80002960:	69a2                	ld	s3,8(sp)
    80002962:	6a02                	ld	s4,0(sp)
    80002964:	6145                	addi	sp,sp,48
    80002966:	8082                	ret
    memmove((char *)dst, src, len);
    80002968:	000a061b          	sext.w	a2,s4
    8000296c:	85ce                	mv	a1,s3
    8000296e:	854a                	mv	a0,s2
    80002970:	ffffe097          	auipc	ra,0xffffe
    80002974:	3be080e7          	jalr	958(ra) # 80000d2e <memmove>
    return 0;
    80002978:	8526                	mv	a0,s1
    8000297a:	bff9                	j	80002958 <either_copyout+0x32>

000000008000297c <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000297c:	7179                	addi	sp,sp,-48
    8000297e:	f406                	sd	ra,40(sp)
    80002980:	f022                	sd	s0,32(sp)
    80002982:	ec26                	sd	s1,24(sp)
    80002984:	e84a                	sd	s2,16(sp)
    80002986:	e44e                	sd	s3,8(sp)
    80002988:	e052                	sd	s4,0(sp)
    8000298a:	1800                	addi	s0,sp,48
    8000298c:	892a                	mv	s2,a0
    8000298e:	84ae                	mv	s1,a1
    80002990:	89b2                	mv	s3,a2
    80002992:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002994:	fffff097          	auipc	ra,0xfffff
    80002998:	04c080e7          	jalr	76(ra) # 800019e0 <myproc>
  if (user_src)
    8000299c:	c08d                	beqz	s1,800029be <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    8000299e:	86d2                	mv	a3,s4
    800029a0:	864e                	mv	a2,s3
    800029a2:	85ca                	mv	a1,s2
    800029a4:	6928                	ld	a0,80(a0)
    800029a6:	fffff097          	auipc	ra,0xfffff
    800029aa:	d4e080e7          	jalr	-690(ra) # 800016f4 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800029ae:	70a2                	ld	ra,40(sp)
    800029b0:	7402                	ld	s0,32(sp)
    800029b2:	64e2                	ld	s1,24(sp)
    800029b4:	6942                	ld	s2,16(sp)
    800029b6:	69a2                	ld	s3,8(sp)
    800029b8:	6a02                	ld	s4,0(sp)
    800029ba:	6145                	addi	sp,sp,48
    800029bc:	8082                	ret
    memmove(dst, (char *)src, len);
    800029be:	000a061b          	sext.w	a2,s4
    800029c2:	85ce                	mv	a1,s3
    800029c4:	854a                	mv	a0,s2
    800029c6:	ffffe097          	auipc	ra,0xffffe
    800029ca:	368080e7          	jalr	872(ra) # 80000d2e <memmove>
    return 0;
    800029ce:	8526                	mv	a0,s1
    800029d0:	bff9                	j	800029ae <either_copyin+0x32>

00000000800029d2 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800029d2:	715d                	addi	sp,sp,-80
    800029d4:	e486                	sd	ra,72(sp)
    800029d6:	e0a2                	sd	s0,64(sp)
    800029d8:	fc26                	sd	s1,56(sp)
    800029da:	f84a                	sd	s2,48(sp)
    800029dc:	f44e                	sd	s3,40(sp)
    800029de:	f052                	sd	s4,32(sp)
    800029e0:	ec56                	sd	s5,24(sp)
    800029e2:	e85a                	sd	s6,16(sp)
    800029e4:	e45e                	sd	s7,8(sp)
    800029e6:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800029e8:	00005517          	auipc	a0,0x5
    800029ec:	63850513          	addi	a0,a0,1592 # 80008020 <etext+0x20>
    800029f0:	ffffe097          	auipc	ra,0xffffe
    800029f4:	b98080e7          	jalr	-1128(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800029f8:	0000e497          	auipc	s1,0xe
    800029fc:	73048493          	addi	s1,s1,1840 # 80011128 <proc+0x158>
    80002a00:	00017917          	auipc	s2,0x17
    80002a04:	12890913          	addi	s2,s2,296 # 80019b28 <mlfq+0x158>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a08:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002a0a:	00006997          	auipc	s3,0x6
    80002a0e:	87698993          	addi	s3,s3,-1930 # 80008280 <etext+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002a12:	00006a97          	auipc	s5,0x6
    80002a16:	876a8a93          	addi	s5,s5,-1930 # 80008288 <etext+0x288>
    printf("\n");
    80002a1a:	00005a17          	auipc	s4,0x5
    80002a1e:	606a0a13          	addi	s4,s4,1542 # 80008020 <etext+0x20>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a22:	00006b97          	auipc	s7,0x6
    80002a26:	d5eb8b93          	addi	s7,s7,-674 # 80008780 <states.0>
    80002a2a:	a00d                	j	80002a4c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002a2c:	ed86a583          	lw	a1,-296(a3)
    80002a30:	8556                	mv	a0,s5
    80002a32:	ffffe097          	auipc	ra,0xffffe
    80002a36:	b56080e7          	jalr	-1194(ra) # 80000588 <printf>
    printf("\n");
    80002a3a:	8552                	mv	a0,s4
    80002a3c:	ffffe097          	auipc	ra,0xffffe
    80002a40:	b4c080e7          	jalr	-1204(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002a44:	22848493          	addi	s1,s1,552
    80002a48:	03248163          	beq	s1,s2,80002a6a <procdump+0x98>
    if (p->state == UNUSED)
    80002a4c:	86a6                	mv	a3,s1
    80002a4e:	ec04a783          	lw	a5,-320(s1)
    80002a52:	dbed                	beqz	a5,80002a44 <procdump+0x72>
      state = "???";
    80002a54:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a56:	fcfb6be3          	bltu	s6,a5,80002a2c <procdump+0x5a>
    80002a5a:	1782                	slli	a5,a5,0x20
    80002a5c:	9381                	srli	a5,a5,0x20
    80002a5e:	078e                	slli	a5,a5,0x3
    80002a60:	97de                	add	a5,a5,s7
    80002a62:	6390                	ld	a2,0(a5)
    80002a64:	f661                	bnez	a2,80002a2c <procdump+0x5a>
      state = "???";
    80002a66:	864e                	mv	a2,s3
    80002a68:	b7d1                	j	80002a2c <procdump+0x5a>
  }
}
    80002a6a:	60a6                	ld	ra,72(sp)
    80002a6c:	6406                	ld	s0,64(sp)
    80002a6e:	74e2                	ld	s1,56(sp)
    80002a70:	7942                	ld	s2,48(sp)
    80002a72:	79a2                	ld	s3,40(sp)
    80002a74:	7a02                	ld	s4,32(sp)
    80002a76:	6ae2                	ld	s5,24(sp)
    80002a78:	6b42                	ld	s6,16(sp)
    80002a7a:	6ba2                	ld	s7,8(sp)
    80002a7c:	6161                	addi	sp,sp,80
    80002a7e:	8082                	ret

0000000080002a80 <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002a80:	711d                	addi	sp,sp,-96
    80002a82:	ec86                	sd	ra,88(sp)
    80002a84:	e8a2                	sd	s0,80(sp)
    80002a86:	e4a6                	sd	s1,72(sp)
    80002a88:	e0ca                	sd	s2,64(sp)
    80002a8a:	fc4e                	sd	s3,56(sp)
    80002a8c:	f852                	sd	s4,48(sp)
    80002a8e:	f456                	sd	s5,40(sp)
    80002a90:	f05a                	sd	s6,32(sp)
    80002a92:	ec5e                	sd	s7,24(sp)
    80002a94:	e862                	sd	s8,16(sp)
    80002a96:	e466                	sd	s9,8(sp)
    80002a98:	e06a                	sd	s10,0(sp)
    80002a9a:	1080                	addi	s0,sp,96
    80002a9c:	8b2a                	mv	s6,a0
    80002a9e:	8bae                	mv	s7,a1
    80002aa0:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002aa2:	fffff097          	auipc	ra,0xfffff
    80002aa6:	f3e080e7          	jalr	-194(ra) # 800019e0 <myproc>
    80002aaa:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002aac:	0000e517          	auipc	a0,0xe
    80002ab0:	0fc50513          	addi	a0,a0,252 # 80010ba8 <wait_lock>
    80002ab4:	ffffe097          	auipc	ra,0xffffe
    80002ab8:	122080e7          	jalr	290(ra) # 80000bd6 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002abc:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002abe:	4a15                	li	s4,5
        havekids = 1;
    80002ac0:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002ac2:	00017997          	auipc	s3,0x17
    80002ac6:	f0e98993          	addi	s3,s3,-242 # 800199d0 <mlfq>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002aca:	0000ed17          	auipc	s10,0xe
    80002ace:	0ded0d13          	addi	s10,s10,222 # 80010ba8 <wait_lock>
    havekids = 0;
    80002ad2:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002ad4:	0000e497          	auipc	s1,0xe
    80002ad8:	4fc48493          	addi	s1,s1,1276 # 80010fd0 <proc>
    80002adc:	a059                	j	80002b62 <waitx+0xe2>
          pid = np->pid;
    80002ade:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002ae2:	1684a703          	lw	a4,360(s1)
    80002ae6:	00ec2023          	sw	a4,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002aea:	16c4a783          	lw	a5,364(s1)
    80002aee:	9f3d                	addw	a4,a4,a5
    80002af0:	1704a783          	lw	a5,368(s1)
    80002af4:	9f99                	subw	a5,a5,a4
    80002af6:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002afa:	000b0e63          	beqz	s6,80002b16 <waitx+0x96>
    80002afe:	4691                	li	a3,4
    80002b00:	02c48613          	addi	a2,s1,44
    80002b04:	85da                	mv	a1,s6
    80002b06:	05093503          	ld	a0,80(s2)
    80002b0a:	fffff097          	auipc	ra,0xfffff
    80002b0e:	b5e080e7          	jalr	-1186(ra) # 80001668 <copyout>
    80002b12:	02054563          	bltz	a0,80002b3c <waitx+0xbc>
          freeproc(np);
    80002b16:	8526                	mv	a0,s1
    80002b18:	fffff097          	auipc	ra,0xfffff
    80002b1c:	07a080e7          	jalr	122(ra) # 80001b92 <freeproc>
          release(&np->lock);
    80002b20:	8526                	mv	a0,s1
    80002b22:	ffffe097          	auipc	ra,0xffffe
    80002b26:	168080e7          	jalr	360(ra) # 80000c8a <release>
          release(&wait_lock);
    80002b2a:	0000e517          	auipc	a0,0xe
    80002b2e:	07e50513          	addi	a0,a0,126 # 80010ba8 <wait_lock>
    80002b32:	ffffe097          	auipc	ra,0xffffe
    80002b36:	158080e7          	jalr	344(ra) # 80000c8a <release>
          return pid;
    80002b3a:	a09d                	j	80002ba0 <waitx+0x120>
            release(&np->lock);
    80002b3c:	8526                	mv	a0,s1
    80002b3e:	ffffe097          	auipc	ra,0xffffe
    80002b42:	14c080e7          	jalr	332(ra) # 80000c8a <release>
            release(&wait_lock);
    80002b46:	0000e517          	auipc	a0,0xe
    80002b4a:	06250513          	addi	a0,a0,98 # 80010ba8 <wait_lock>
    80002b4e:	ffffe097          	auipc	ra,0xffffe
    80002b52:	13c080e7          	jalr	316(ra) # 80000c8a <release>
            return -1;
    80002b56:	59fd                	li	s3,-1
    80002b58:	a0a1                	j	80002ba0 <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    80002b5a:	22848493          	addi	s1,s1,552
    80002b5e:	03348463          	beq	s1,s3,80002b86 <waitx+0x106>
      if (np->parent == p)
    80002b62:	7c9c                	ld	a5,56(s1)
    80002b64:	ff279be3          	bne	a5,s2,80002b5a <waitx+0xda>
        acquire(&np->lock);
    80002b68:	8526                	mv	a0,s1
    80002b6a:	ffffe097          	auipc	ra,0xffffe
    80002b6e:	06c080e7          	jalr	108(ra) # 80000bd6 <acquire>
        if (np->state == ZOMBIE)
    80002b72:	4c9c                	lw	a5,24(s1)
    80002b74:	f74785e3          	beq	a5,s4,80002ade <waitx+0x5e>
        release(&np->lock);
    80002b78:	8526                	mv	a0,s1
    80002b7a:	ffffe097          	auipc	ra,0xffffe
    80002b7e:	110080e7          	jalr	272(ra) # 80000c8a <release>
        havekids = 1;
    80002b82:	8756                	mv	a4,s5
    80002b84:	bfd9                	j	80002b5a <waitx+0xda>
    if (!havekids || p->killed)
    80002b86:	c701                	beqz	a4,80002b8e <waitx+0x10e>
    80002b88:	02892783          	lw	a5,40(s2)
    80002b8c:	cb8d                	beqz	a5,80002bbe <waitx+0x13e>
      release(&wait_lock);
    80002b8e:	0000e517          	auipc	a0,0xe
    80002b92:	01a50513          	addi	a0,a0,26 # 80010ba8 <wait_lock>
    80002b96:	ffffe097          	auipc	ra,0xffffe
    80002b9a:	0f4080e7          	jalr	244(ra) # 80000c8a <release>
      return -1;
    80002b9e:	59fd                	li	s3,-1
  }
}
    80002ba0:	854e                	mv	a0,s3
    80002ba2:	60e6                	ld	ra,88(sp)
    80002ba4:	6446                	ld	s0,80(sp)
    80002ba6:	64a6                	ld	s1,72(sp)
    80002ba8:	6906                	ld	s2,64(sp)
    80002baa:	79e2                	ld	s3,56(sp)
    80002bac:	7a42                	ld	s4,48(sp)
    80002bae:	7aa2                	ld	s5,40(sp)
    80002bb0:	7b02                	ld	s6,32(sp)
    80002bb2:	6be2                	ld	s7,24(sp)
    80002bb4:	6c42                	ld	s8,16(sp)
    80002bb6:	6ca2                	ld	s9,8(sp)
    80002bb8:	6d02                	ld	s10,0(sp)
    80002bba:	6125                	addi	sp,sp,96
    80002bbc:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002bbe:	85ea                	mv	a1,s10
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	90e080e7          	jalr	-1778(ra) # 800024d0 <sleep>
    havekids = 0;
    80002bca:	b721                	j	80002ad2 <waitx+0x52>

0000000080002bcc <update_time>:

void update_time()
{
    80002bcc:	7179                	addi	sp,sp,-48
    80002bce:	f406                	sd	ra,40(sp)
    80002bd0:	f022                	sd	s0,32(sp)
    80002bd2:	ec26                	sd	s1,24(sp)
    80002bd4:	e84a                	sd	s2,16(sp)
    80002bd6:	e44e                	sd	s3,8(sp)
    80002bd8:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002bda:	0000e497          	auipc	s1,0xe
    80002bde:	3f648493          	addi	s1,s1,1014 # 80010fd0 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002be2:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002be4:	00017917          	auipc	s2,0x17
    80002be8:	dec90913          	addi	s2,s2,-532 # 800199d0 <mlfq>
    80002bec:	a811                	j	80002c00 <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    80002bee:	8526                	mv	a0,s1
    80002bf0:	ffffe097          	auipc	ra,0xffffe
    80002bf4:	09a080e7          	jalr	154(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002bf8:	22848493          	addi	s1,s1,552
    80002bfc:	03248063          	beq	s1,s2,80002c1c <update_time+0x50>
    acquire(&p->lock);
    80002c00:	8526                	mv	a0,s1
    80002c02:	ffffe097          	auipc	ra,0xffffe
    80002c06:	fd4080e7          	jalr	-44(ra) # 80000bd6 <acquire>
    if (p->state == RUNNING)
    80002c0a:	4c9c                	lw	a5,24(s1)
    80002c0c:	ff3791e3          	bne	a5,s3,80002bee <update_time+0x22>
      p->rtime++;
    80002c10:	1684a783          	lw	a5,360(s1)
    80002c14:	2785                	addiw	a5,a5,1
    80002c16:	16f4a423          	sw	a5,360(s1)
    80002c1a:	bfd1                	j	80002bee <update_time+0x22>
  }
}
    80002c1c:	70a2                	ld	ra,40(sp)
    80002c1e:	7402                	ld	s0,32(sp)
    80002c20:	64e2                	ld	s1,24(sp)
    80002c22:	6942                	ld	s2,16(sp)
    80002c24:	69a2                	ld	s3,8(sp)
    80002c26:	6145                	addi	sp,sp,48
    80002c28:	8082                	ret

0000000080002c2a <sigalarm>:

int
sigalarm(int interval, void (*handler)())
{
    80002c2a:	7179                	addi	sp,sp,-48
    80002c2c:	f406                	sd	ra,40(sp)
    80002c2e:	f022                	sd	s0,32(sp)
    80002c30:	ec26                	sd	s1,24(sp)
    80002c32:	e84a                	sd	s2,16(sp)
    80002c34:	e44e                	sd	s3,8(sp)
    80002c36:	1800                	addi	s0,sp,48
    80002c38:	892a                	mv	s2,a0
    80002c3a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	da4080e7          	jalr	-604(ra) # 800019e0 <myproc>
    80002c44:	84aa                	mv	s1,a0
  p->alarm_interval = interval;
    80002c46:	1f252e23          	sw	s2,508(a0)
  p->alarm_handler = (uint64)handler;
    80002c4a:	21353023          	sd	s3,512(a0)
  memset(&p->ticks_count, 0, sizeof(p->ticks_count));
    80002c4e:	4611                	li	a2,4
    80002c50:	4581                	li	a1,0
    80002c52:	1f450513          	addi	a0,a0,500
    80002c56:	ffffe097          	auipc	ra,0xffffe
    80002c5a:	07c080e7          	jalr	124(ra) # 80000cd2 <memset>
  if (interval > 0) p->alarm_on = 1;
    80002c5e:	01202933          	sgtz	s2,s2
    80002c62:	1f24ac23          	sw	s2,504(s1)
  else p->alarm_on = 0;
  return 0;
}
    80002c66:	4501                	li	a0,0
    80002c68:	70a2                	ld	ra,40(sp)
    80002c6a:	7402                	ld	s0,32(sp)
    80002c6c:	64e2                	ld	s1,24(sp)
    80002c6e:	6942                	ld	s2,16(sp)
    80002c70:	69a2                	ld	s3,8(sp)
    80002c72:	6145                	addi	sp,sp,48
    80002c74:	8082                	ret

0000000080002c76 <sigreturn>:

int
sigreturn(void)
{
    80002c76:	1101                	addi	sp,sp,-32
    80002c78:	ec06                	sd	ra,24(sp)
    80002c7a:	e822                	sd	s0,16(sp)
    80002c7c:	e426                	sd	s1,8(sp)
    80002c7e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002c80:	fffff097          	auipc	ra,0xfffff
    80002c84:	d60080e7          	jalr	-672(ra) # 800019e0 <myproc>
  if(p->alarm_trapframe == 0)
    80002c88:	20853583          	ld	a1,520(a0)
    80002c8c:	cd8d                	beqz	a1,80002cc6 <sigreturn+0x50>
    80002c8e:	84aa                	mv	s1,a0
    return -1;
  memmove(p->trapframe, p->alarm_trapframe, sizeof(struct trapframe));
    80002c90:	12000613          	li	a2,288
    80002c94:	6d28                	ld	a0,88(a0)
    80002c96:	ffffe097          	auipc	ra,0xffffe
    80002c9a:	098080e7          	jalr	152(ra) # 80000d2e <memmove>
  kfree(p->alarm_trapframe);
    80002c9e:	2084b503          	ld	a0,520(s1)
    80002ca2:	ffffe097          	auipc	ra,0xffffe
    80002ca6:	d48080e7          	jalr	-696(ra) # 800009ea <kfree>
  memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
    80002caa:	4621                	li	a2,8
    80002cac:	4581                	li	a1,0
    80002cae:	20848513          	addi	a0,s1,520
    80002cb2:	ffffe097          	auipc	ra,0xffffe
    80002cb6:	020080e7          	jalr	32(ra) # 80000cd2 <memset>
  return 0;
    80002cba:	4501                	li	a0,0
    80002cbc:	60e2                	ld	ra,24(sp)
    80002cbe:	6442                	ld	s0,16(sp)
    80002cc0:	64a2                	ld	s1,8(sp)
    80002cc2:	6105                	addi	sp,sp,32
    80002cc4:	8082                	ret
    return -1;
    80002cc6:	557d                	li	a0,-1
    80002cc8:	bfd5                	j	80002cbc <sigreturn+0x46>

0000000080002cca <swtch>:
    80002cca:	00153023          	sd	ra,0(a0)
    80002cce:	00253423          	sd	sp,8(a0)
    80002cd2:	e900                	sd	s0,16(a0)
    80002cd4:	ed04                	sd	s1,24(a0)
    80002cd6:	03253023          	sd	s2,32(a0)
    80002cda:	03353423          	sd	s3,40(a0)
    80002cde:	03453823          	sd	s4,48(a0)
    80002ce2:	03553c23          	sd	s5,56(a0)
    80002ce6:	05653023          	sd	s6,64(a0)
    80002cea:	05753423          	sd	s7,72(a0)
    80002cee:	05853823          	sd	s8,80(a0)
    80002cf2:	05953c23          	sd	s9,88(a0)
    80002cf6:	07a53023          	sd	s10,96(a0)
    80002cfa:	07b53423          	sd	s11,104(a0)
    80002cfe:	0005b083          	ld	ra,0(a1)
    80002d02:	0085b103          	ld	sp,8(a1)
    80002d06:	6980                	ld	s0,16(a1)
    80002d08:	6d84                	ld	s1,24(a1)
    80002d0a:	0205b903          	ld	s2,32(a1)
    80002d0e:	0285b983          	ld	s3,40(a1)
    80002d12:	0305ba03          	ld	s4,48(a1)
    80002d16:	0385ba83          	ld	s5,56(a1)
    80002d1a:	0405bb03          	ld	s6,64(a1)
    80002d1e:	0485bb83          	ld	s7,72(a1)
    80002d22:	0505bc03          	ld	s8,80(a1)
    80002d26:	0585bc83          	ld	s9,88(a1)
    80002d2a:	0605bd03          	ld	s10,96(a1)
    80002d2e:	0685bd83          	ld	s11,104(a1)
    80002d32:	8082                	ret

0000000080002d34 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002d34:	1141                	addi	sp,sp,-16
    80002d36:	e406                	sd	ra,8(sp)
    80002d38:	e022                	sd	s0,0(sp)
    80002d3a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002d3c:	00005597          	auipc	a1,0x5
    80002d40:	58c58593          	addi	a1,a1,1420 # 800082c8 <etext+0x2c8>
    80002d44:	00017517          	auipc	a0,0x17
    80002d48:	48c50513          	addi	a0,a0,1164 # 8001a1d0 <tickslock>
    80002d4c:	ffffe097          	auipc	ra,0xffffe
    80002d50:	dfa080e7          	jalr	-518(ra) # 80000b46 <initlock>
}
    80002d54:	60a2                	ld	ra,8(sp)
    80002d56:	6402                	ld	s0,0(sp)
    80002d58:	0141                	addi	sp,sp,16
    80002d5a:	8082                	ret

0000000080002d5c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002d5c:	1141                	addi	sp,sp,-16
    80002d5e:	e422                	sd	s0,8(sp)
    80002d60:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d62:	00003797          	auipc	a5,0x3
    80002d66:	7fe78793          	addi	a5,a5,2046 # 80006560 <kernelvec>
    80002d6a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002d6e:	6422                	ld	s0,8(sp)
    80002d70:	0141                	addi	sp,sp,16
    80002d72:	8082                	ret

0000000080002d74 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002d74:	1141                	addi	sp,sp,-16
    80002d76:	e406                	sd	ra,8(sp)
    80002d78:	e022                	sd	s0,0(sp)
    80002d7a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002d7c:	fffff097          	auipc	ra,0xfffff
    80002d80:	c64080e7          	jalr	-924(ra) # 800019e0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d8a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002d8e:	00004617          	auipc	a2,0x4
    80002d92:	27260613          	addi	a2,a2,626 # 80007000 <_trampoline>
    80002d96:	00004697          	auipc	a3,0x4
    80002d9a:	26a68693          	addi	a3,a3,618 # 80007000 <_trampoline>
    80002d9e:	8e91                	sub	a3,a3,a2
    80002da0:	040007b7          	lui	a5,0x4000
    80002da4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002da6:	07b2                	slli	a5,a5,0xc
    80002da8:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002daa:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002dae:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002db0:	180026f3          	csrr	a3,satp
    80002db4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002db6:	6d38                	ld	a4,88(a0)
    80002db8:	6134                	ld	a3,64(a0)
    80002dba:	6585                	lui	a1,0x1
    80002dbc:	96ae                	add	a3,a3,a1
    80002dbe:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002dc0:	6d38                	ld	a4,88(a0)
    80002dc2:	00000697          	auipc	a3,0x0
    80002dc6:	13e68693          	addi	a3,a3,318 # 80002f00 <usertrap>
    80002dca:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002dcc:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002dce:	8692                	mv	a3,tp
    80002dd0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dd2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002dd6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002dda:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002dde:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002de2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002de4:	6f18                	ld	a4,24(a4)
    80002de6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002dea:	6928                	ld	a0,80(a0)
    80002dec:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002dee:	00004717          	auipc	a4,0x4
    80002df2:	2ae70713          	addi	a4,a4,686 # 8000709c <userret>
    80002df6:	8f11                	sub	a4,a4,a2
    80002df8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002dfa:	577d                	li	a4,-1
    80002dfc:	177e                	slli	a4,a4,0x3f
    80002dfe:	8d59                	or	a0,a0,a4
    80002e00:	9782                	jalr	a5
}
    80002e02:	60a2                	ld	ra,8(sp)
    80002e04:	6402                	ld	s0,0(sp)
    80002e06:	0141                	addi	sp,sp,16
    80002e08:	8082                	ret

0000000080002e0a <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002e0a:	1101                	addi	sp,sp,-32
    80002e0c:	ec06                	sd	ra,24(sp)
    80002e0e:	e822                	sd	s0,16(sp)
    80002e10:	e426                	sd	s1,8(sp)
    80002e12:	e04a                	sd	s2,0(sp)
    80002e14:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002e16:	00017917          	auipc	s2,0x17
    80002e1a:	3ba90913          	addi	s2,s2,954 # 8001a1d0 <tickslock>
    80002e1e:	854a                	mv	a0,s2
    80002e20:	ffffe097          	auipc	ra,0xffffe
    80002e24:	db6080e7          	jalr	-586(ra) # 80000bd6 <acquire>
  ticks++;
    80002e28:	00006497          	auipc	s1,0x6
    80002e2c:	afc48493          	addi	s1,s1,-1284 # 80008924 <ticks>
    80002e30:	409c                	lw	a5,0(s1)
    80002e32:	2785                	addiw	a5,a5,1
    80002e34:	c09c                	sw	a5,0(s1)
  update_time();
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	d96080e7          	jalr	-618(ra) # 80002bcc <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    80002e3e:	8526                	mv	a0,s1
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	6f4080e7          	jalr	1780(ra) # 80002534 <wakeup>
  release(&tickslock);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	ffffe097          	auipc	ra,0xffffe
    80002e4e:	e40080e7          	jalr	-448(ra) # 80000c8a <release>
}
    80002e52:	60e2                	ld	ra,24(sp)
    80002e54:	6442                	ld	s0,16(sp)
    80002e56:	64a2                	ld	s1,8(sp)
    80002e58:	6902                	ld	s2,0(sp)
    80002e5a:	6105                	addi	sp,sp,32
    80002e5c:	8082                	ret

0000000080002e5e <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002e5e:	1101                	addi	sp,sp,-32
    80002e60:	ec06                	sd	ra,24(sp)
    80002e62:	e822                	sd	s0,16(sp)
    80002e64:	e426                	sd	s1,8(sp)
    80002e66:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e68:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80002e6c:	00074d63          	bltz	a4,80002e86 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80002e70:	57fd                	li	a5,-1
    80002e72:	17fe                	slli	a5,a5,0x3f
    80002e74:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002e76:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002e78:	06f70363          	beq	a4,a5,80002ede <devintr+0x80>
  }
}
    80002e7c:	60e2                	ld	ra,24(sp)
    80002e7e:	6442                	ld	s0,16(sp)
    80002e80:	64a2                	ld	s1,8(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret
      (scause & 0xff) == 9)
    80002e86:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80002e8a:	46a5                	li	a3,9
    80002e8c:	fed792e3          	bne	a5,a3,80002e70 <devintr+0x12>
    int irq = plic_claim();
    80002e90:	00003097          	auipc	ra,0x3
    80002e94:	7d8080e7          	jalr	2008(ra) # 80006668 <plic_claim>
    80002e98:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002e9a:	47a9                	li	a5,10
    80002e9c:	02f50763          	beq	a0,a5,80002eca <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002ea0:	4785                	li	a5,1
    80002ea2:	02f50963          	beq	a0,a5,80002ed4 <devintr+0x76>
    return 1;
    80002ea6:	4505                	li	a0,1
    else if (irq)
    80002ea8:	d8f1                	beqz	s1,80002e7c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002eaa:	85a6                	mv	a1,s1
    80002eac:	00005517          	auipc	a0,0x5
    80002eb0:	42450513          	addi	a0,a0,1060 # 800082d0 <etext+0x2d0>
    80002eb4:	ffffd097          	auipc	ra,0xffffd
    80002eb8:	6d4080e7          	jalr	1748(ra) # 80000588 <printf>
      plic_complete(irq);
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	00003097          	auipc	ra,0x3
    80002ec2:	7ce080e7          	jalr	1998(ra) # 8000668c <plic_complete>
    return 1;
    80002ec6:	4505                	li	a0,1
    80002ec8:	bf55                	j	80002e7c <devintr+0x1e>
      uartintr();
    80002eca:	ffffe097          	auipc	ra,0xffffe
    80002ece:	ad0080e7          	jalr	-1328(ra) # 8000099a <uartintr>
    80002ed2:	b7ed                	j	80002ebc <devintr+0x5e>
      virtio_disk_intr();
    80002ed4:	00004097          	auipc	ra,0x4
    80002ed8:	c84080e7          	jalr	-892(ra) # 80006b58 <virtio_disk_intr>
    80002edc:	b7c5                	j	80002ebc <devintr+0x5e>
    if (cpuid() == 0)
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	ad6080e7          	jalr	-1322(ra) # 800019b4 <cpuid>
    80002ee6:	c901                	beqz	a0,80002ef6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002ee8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002eec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002eee:	14479073          	csrw	sip,a5
    return 2;
    80002ef2:	4509                	li	a0,2
    80002ef4:	b761                	j	80002e7c <devintr+0x1e>
      clockintr();
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	f14080e7          	jalr	-236(ra) # 80002e0a <clockintr>
    80002efe:	b7ed                	j	80002ee8 <devintr+0x8a>

0000000080002f00 <usertrap>:
{
    80002f00:	1101                	addi	sp,sp,-32
    80002f02:	ec06                	sd	ra,24(sp)
    80002f04:	e822                	sd	s0,16(sp)
    80002f06:	e426                	sd	s1,8(sp)
    80002f08:	e04a                	sd	s2,0(sp)
    80002f0a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f0c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002f10:	1007f793          	andi	a5,a5,256
    80002f14:	e3b1                	bnez	a5,80002f58 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002f16:	00003797          	auipc	a5,0x3
    80002f1a:	64a78793          	addi	a5,a5,1610 # 80006560 <kernelvec>
    80002f1e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002f22:	fffff097          	auipc	ra,0xfffff
    80002f26:	abe080e7          	jalr	-1346(ra) # 800019e0 <myproc>
    80002f2a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002f2c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f2e:	14102773          	csrr	a4,sepc
    80002f32:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f34:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002f38:	47a1                	li	a5,8
    80002f3a:	02f70763          	beq	a4,a5,80002f68 <usertrap+0x68>
  else if ((which_dev = devintr()) != 0)
    80002f3e:	00000097          	auipc	ra,0x0
    80002f42:	f20080e7          	jalr	-224(ra) # 80002e5e <devintr>
    80002f46:	892a                	mv	s2,a0
    80002f48:	c92d                	beqz	a0,80002fba <usertrap+0xba>
  if (killed(p))
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	00000097          	auipc	ra,0x0
    80002f50:	87a080e7          	jalr	-1926(ra) # 800027c6 <killed>
    80002f54:	c555                	beqz	a0,80003000 <usertrap+0x100>
    80002f56:	a045                	j	80002ff6 <usertrap+0xf6>
    panic("usertrap: not from user mode");
    80002f58:	00005517          	auipc	a0,0x5
    80002f5c:	39850513          	addi	a0,a0,920 # 800082f0 <etext+0x2f0>
    80002f60:	ffffd097          	auipc	ra,0xffffd
    80002f64:	5de080e7          	jalr	1502(ra) # 8000053e <panic>
    if (killed(p))
    80002f68:	00000097          	auipc	ra,0x0
    80002f6c:	85e080e7          	jalr	-1954(ra) # 800027c6 <killed>
    80002f70:	ed1d                	bnez	a0,80002fae <usertrap+0xae>
    p->trapframe->epc += 4;
    80002f72:	6cb8                	ld	a4,88(s1)
    80002f74:	6f1c                	ld	a5,24(a4)
    80002f76:	0791                	addi	a5,a5,4
    80002f78:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002f7e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f82:	10079073          	csrw	sstatus,a5
    syscall();
    80002f86:	00000097          	auipc	ra,0x0
    80002f8a:	3c6080e7          	jalr	966(ra) # 8000334c <syscall>
  if (killed(p))
    80002f8e:	8526                	mv	a0,s1
    80002f90:	00000097          	auipc	ra,0x0
    80002f94:	836080e7          	jalr	-1994(ra) # 800027c6 <killed>
    80002f98:	ed31                	bnez	a0,80002ff4 <usertrap+0xf4>
  usertrapret();
    80002f9a:	00000097          	auipc	ra,0x0
    80002f9e:	dda080e7          	jalr	-550(ra) # 80002d74 <usertrapret>
}
    80002fa2:	60e2                	ld	ra,24(sp)
    80002fa4:	6442                	ld	s0,16(sp)
    80002fa6:	64a2                	ld	s1,8(sp)
    80002fa8:	6902                	ld	s2,0(sp)
    80002faa:	6105                	addi	sp,sp,32
    80002fac:	8082                	ret
      exit(-1);
    80002fae:	557d                	li	a0,-1
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	654080e7          	jalr	1620(ra) # 80002604 <exit>
    80002fb8:	bf6d                	j	80002f72 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fba:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002fbe:	5890                	lw	a2,48(s1)
    80002fc0:	00005517          	auipc	a0,0x5
    80002fc4:	35050513          	addi	a0,a0,848 # 80008310 <etext+0x310>
    80002fc8:	ffffd097          	auipc	ra,0xffffd
    80002fcc:	5c0080e7          	jalr	1472(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002fd0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002fd4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002fd8:	00005517          	auipc	a0,0x5
    80002fdc:	36850513          	addi	a0,a0,872 # 80008340 <etext+0x340>
    80002fe0:	ffffd097          	auipc	ra,0xffffd
    80002fe4:	5a8080e7          	jalr	1448(ra) # 80000588 <printf>
    setkilled(p);
    80002fe8:	8526                	mv	a0,s1
    80002fea:	fffff097          	auipc	ra,0xfffff
    80002fee:	7b0080e7          	jalr	1968(ra) # 8000279a <setkilled>
    80002ff2:	bf71                	j	80002f8e <usertrap+0x8e>
  if (killed(p))
    80002ff4:	4901                	li	s2,0
    exit(-1);
    80002ff6:	557d                	li	a0,-1
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	60c080e7          	jalr	1548(ra) # 80002604 <exit>
  if(which_dev == 2) {
    80003000:	4789                	li	a5,2
    80003002:	f8f91ce3          	bne	s2,a5,80002f9a <usertrap+0x9a>
    if(p->alarm_on && p->alarm_interval > 0) {
    80003006:	1f84a783          	lw	a5,504(s1)
    8000300a:	cf91                	beqz	a5,80003026 <usertrap+0x126>
    8000300c:	1fc4a703          	lw	a4,508(s1)
    80003010:	00e05b63          	blez	a4,80003026 <usertrap+0x126>
      p->ticks_count++;
    80003014:	1f44a783          	lw	a5,500(s1)
    80003018:	2785                	addiw	a5,a5,1
    8000301a:	0007869b          	sext.w	a3,a5
      if(p->ticks_count >= p->alarm_interval) {
    8000301e:	02e6d663          	bge	a3,a4,8000304a <usertrap+0x14a>
      p->ticks_count++;
    80003022:	1ef4aa23          	sw	a5,500(s1)
    if(p->state == RUNNING) {
    80003026:	4c98                	lw	a4,24(s1)
    80003028:	4791                	li	a5,4
    8000302a:	06f70363          	beq	a4,a5,80003090 <usertrap+0x190>
    if(ticks % 48 == 0) {  
    8000302e:	00006797          	auipc	a5,0x6
    80003032:	8f67a783          	lw	a5,-1802(a5) # 80008924 <ticks>
    80003036:	03000713          	li	a4,48
    8000303a:	02e7f7bb          	remuw	a5,a5,a4
    8000303e:	ffb1                	bnez	a5,80002f9a <usertrap+0x9a>
      priority_boost();
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	096080e7          	jalr	150(ra) # 800020d6 <priority_boost>
    80003048:	bf89                	j	80002f9a <usertrap+0x9a>
        p->ticks_count = 0;
    8000304a:	1e04aa23          	sw	zero,500(s1)
        if(p->alarm_trapframe == 0) {
    8000304e:	2084b783          	ld	a5,520(s1)
    80003052:	fbf1                	bnez	a5,80003026 <usertrap+0x126>
          p->alarm_trapframe = kalloc();
    80003054:	ffffe097          	auipc	ra,0xffffe
    80003058:	a92080e7          	jalr	-1390(ra) # 80000ae6 <kalloc>
    8000305c:	20a4b423          	sd	a0,520(s1)
          if(p->alarm_trapframe == 0) {
    80003060:	cd09                	beqz	a0,8000307a <usertrap+0x17a>
            memmove(p->alarm_trapframe, p->trapframe, sizeof(struct trapframe));
    80003062:	12000613          	li	a2,288
    80003066:	6cac                	ld	a1,88(s1)
    80003068:	ffffe097          	auipc	ra,0xffffe
    8000306c:	cc6080e7          	jalr	-826(ra) # 80000d2e <memmove>
            p->trapframe->epc = p->alarm_handler;
    80003070:	6cbc                	ld	a5,88(s1)
    80003072:	2004b703          	ld	a4,512(s1)
    80003076:	ef98                	sd	a4,24(a5)
    80003078:	b77d                	j	80003026 <usertrap+0x126>
            printf("usertrap: out of memory\n");
    8000307a:	00005517          	auipc	a0,0x5
    8000307e:	2e650513          	addi	a0,a0,742 # 80008360 <etext+0x360>
    80003082:	ffffd097          	auipc	ra,0xffffd
    80003086:	506080e7          	jalr	1286(ra) # 80000588 <printf>
            p->killed = 1;
    8000308a:	4785                	li	a5,1
    8000308c:	d49c                	sw	a5,40(s1)
    8000308e:	bf61                	j	80003026 <usertrap+0x126>
      p->rtime++;
    80003090:	1684a783          	lw	a5,360(s1)
    80003094:	2785                	addiw	a5,a5,1
    80003096:	16f4a423          	sw	a5,360(s1)
      p->mlfq_ticks++;
    8000309a:	21c4a783          	lw	a5,540(s1)
    8000309e:	2785                	addiw	a5,a5,1
    800030a0:	0007861b          	sext.w	a2,a5
    800030a4:	20f4ae23          	sw	a5,540(s1)
      p->time_slice--;
    800030a8:	2184a703          	lw	a4,536(s1)
    800030ac:	377d                	addiw	a4,a4,-1
    800030ae:	0007069b          	sext.w	a3,a4
    800030b2:	20e4ac23          	sw	a4,536(s1)
      if(p->mlfq_ticks % 10 == 0) {
    800030b6:	4729                	li	a4,10
    800030b8:	02e7e7bb          	remw	a5,a5,a4
    800030bc:	cf95                	beqz	a5,800030f8 <usertrap+0x1f8>
      else if(p->time_slice <= 0 || p->mlfq_ticks >= (1 << p->mlfq_priority)) {
    800030be:	00d05963          	blez	a3,800030d0 <usertrap+0x1d0>
    800030c2:	2144a703          	lw	a4,532(s1)
    800030c6:	4785                	li	a5,1
    800030c8:	00e797bb          	sllw	a5,a5,a4
    800030cc:	f6f641e3          	blt	a2,a5,8000302e <usertrap+0x12e>
        if(p->mlfq_priority < 3) {
    800030d0:	2144a783          	lw	a5,532(s1)
    800030d4:	4709                	li	a4,2
    800030d6:	00f74563          	blt	a4,a5,800030e0 <usertrap+0x1e0>
          p->mlfq_priority++;
    800030da:	2785                	addiw	a5,a5,1
    800030dc:	20f4aa23          	sw	a5,532(s1)
        p->time_slice = 1 << p->mlfq_priority;
    800030e0:	2144a703          	lw	a4,532(s1)
    800030e4:	4785                	li	a5,1
    800030e6:	00e797bb          	sllw	a5,a5,a4
    800030ea:	20f4ac23          	sw	a5,536(s1)
        yield();
    800030ee:	fffff097          	auipc	ra,0xfffff
    800030f2:	250080e7          	jalr	592(ra) # 8000233e <yield>
    800030f6:	bf25                	j	8000302e <usertrap+0x12e>
        yield();
    800030f8:	fffff097          	auipc	ra,0xfffff
    800030fc:	246080e7          	jalr	582(ra) # 8000233e <yield>
    80003100:	b73d                	j	8000302e <usertrap+0x12e>

0000000080003102 <kerneltrap>:
{
    80003102:	7179                	addi	sp,sp,-48
    80003104:	f406                	sd	ra,40(sp)
    80003106:	f022                	sd	s0,32(sp)
    80003108:	ec26                	sd	s1,24(sp)
    8000310a:	e84a                	sd	s2,16(sp)
    8000310c:	e44e                	sd	s3,8(sp)
    8000310e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003110:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003114:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003118:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    8000311c:	1004f793          	andi	a5,s1,256
    80003120:	cb85                	beqz	a5,80003150 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003122:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003126:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80003128:	ef85                	bnez	a5,80003160 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	d34080e7          	jalr	-716(ra) # 80002e5e <devintr>
    80003132:	cd1d                	beqz	a0,80003170 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003134:	4789                	li	a5,2
    80003136:	06f50a63          	beq	a0,a5,800031aa <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000313a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000313e:	10049073          	csrw	sstatus,s1
}
    80003142:	70a2                	ld	ra,40(sp)
    80003144:	7402                	ld	s0,32(sp)
    80003146:	64e2                	ld	s1,24(sp)
    80003148:	6942                	ld	s2,16(sp)
    8000314a:	69a2                	ld	s3,8(sp)
    8000314c:	6145                	addi	sp,sp,48
    8000314e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003150:	00005517          	auipc	a0,0x5
    80003154:	23050513          	addi	a0,a0,560 # 80008380 <etext+0x380>
    80003158:	ffffd097          	auipc	ra,0xffffd
    8000315c:	3e6080e7          	jalr	998(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80003160:	00005517          	auipc	a0,0x5
    80003164:	24850513          	addi	a0,a0,584 # 800083a8 <etext+0x3a8>
    80003168:	ffffd097          	auipc	ra,0xffffd
    8000316c:	3d6080e7          	jalr	982(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80003170:	85ce                	mv	a1,s3
    80003172:	00005517          	auipc	a0,0x5
    80003176:	25650513          	addi	a0,a0,598 # 800083c8 <etext+0x3c8>
    8000317a:	ffffd097          	auipc	ra,0xffffd
    8000317e:	40e080e7          	jalr	1038(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003182:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003186:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000318a:	00005517          	auipc	a0,0x5
    8000318e:	24e50513          	addi	a0,a0,590 # 800083d8 <etext+0x3d8>
    80003192:	ffffd097          	auipc	ra,0xffffd
    80003196:	3f6080e7          	jalr	1014(ra) # 80000588 <printf>
    panic("kerneltrap");
    8000319a:	00005517          	auipc	a0,0x5
    8000319e:	25650513          	addi	a0,a0,598 # 800083f0 <etext+0x3f0>
    800031a2:	ffffd097          	auipc	ra,0xffffd
    800031a6:	39c080e7          	jalr	924(ra) # 8000053e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	836080e7          	jalr	-1994(ra) # 800019e0 <myproc>
    800031b2:	d541                	beqz	a0,8000313a <kerneltrap+0x38>
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	82c080e7          	jalr	-2004(ra) # 800019e0 <myproc>
    800031bc:	4d18                	lw	a4,24(a0)
    800031be:	4791                	li	a5,4
    800031c0:	f6f71de3          	bne	a4,a5,8000313a <kerneltrap+0x38>
    yield();
    800031c4:	fffff097          	auipc	ra,0xfffff
    800031c8:	17a080e7          	jalr	378(ra) # 8000233e <yield>
    800031cc:	b7bd                	j	8000313a <kerneltrap+0x38>

00000000800031ce <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800031ce:	1101                	addi	sp,sp,-32
    800031d0:	ec06                	sd	ra,24(sp)
    800031d2:	e822                	sd	s0,16(sp)
    800031d4:	e426                	sd	s1,8(sp)
    800031d6:	1000                	addi	s0,sp,32
    800031d8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	806080e7          	jalr	-2042(ra) # 800019e0 <myproc>
  switch (n) {
    800031e2:	4795                	li	a5,5
    800031e4:	0497e163          	bltu	a5,s1,80003226 <argraw+0x58>
    800031e8:	048a                	slli	s1,s1,0x2
    800031ea:	00005717          	auipc	a4,0x5
    800031ee:	5c670713          	addi	a4,a4,1478 # 800087b0 <states.0+0x30>
    800031f2:	94ba                	add	s1,s1,a4
    800031f4:	409c                	lw	a5,0(s1)
    800031f6:	97ba                	add	a5,a5,a4
    800031f8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800031fa:	6d3c                	ld	a5,88(a0)
    800031fc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800031fe:	60e2                	ld	ra,24(sp)
    80003200:	6442                	ld	s0,16(sp)
    80003202:	64a2                	ld	s1,8(sp)
    80003204:	6105                	addi	sp,sp,32
    80003206:	8082                	ret
    return p->trapframe->a1;
    80003208:	6d3c                	ld	a5,88(a0)
    8000320a:	7fa8                	ld	a0,120(a5)
    8000320c:	bfcd                	j	800031fe <argraw+0x30>
    return p->trapframe->a2;
    8000320e:	6d3c                	ld	a5,88(a0)
    80003210:	63c8                	ld	a0,128(a5)
    80003212:	b7f5                	j	800031fe <argraw+0x30>
    return p->trapframe->a3;
    80003214:	6d3c                	ld	a5,88(a0)
    80003216:	67c8                	ld	a0,136(a5)
    80003218:	b7dd                	j	800031fe <argraw+0x30>
    return p->trapframe->a4;
    8000321a:	6d3c                	ld	a5,88(a0)
    8000321c:	6bc8                	ld	a0,144(a5)
    8000321e:	b7c5                	j	800031fe <argraw+0x30>
    return p->trapframe->a5;
    80003220:	6d3c                	ld	a5,88(a0)
    80003222:	6fc8                	ld	a0,152(a5)
    80003224:	bfe9                	j	800031fe <argraw+0x30>
  panic("argraw");
    80003226:	00005517          	auipc	a0,0x5
    8000322a:	1da50513          	addi	a0,a0,474 # 80008400 <etext+0x400>
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	310080e7          	jalr	784(ra) # 8000053e <panic>

0000000080003236 <fetchaddr>:
{
    80003236:	1101                	addi	sp,sp,-32
    80003238:	ec06                	sd	ra,24(sp)
    8000323a:	e822                	sd	s0,16(sp)
    8000323c:	e426                	sd	s1,8(sp)
    8000323e:	e04a                	sd	s2,0(sp)
    80003240:	1000                	addi	s0,sp,32
    80003242:	84aa                	mv	s1,a0
    80003244:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003246:	ffffe097          	auipc	ra,0xffffe
    8000324a:	79a080e7          	jalr	1946(ra) # 800019e0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000324e:	653c                	ld	a5,72(a0)
    80003250:	02f4f863          	bgeu	s1,a5,80003280 <fetchaddr+0x4a>
    80003254:	00848713          	addi	a4,s1,8
    80003258:	02e7e663          	bltu	a5,a4,80003284 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000325c:	46a1                	li	a3,8
    8000325e:	8626                	mv	a2,s1
    80003260:	85ca                	mv	a1,s2
    80003262:	6928                	ld	a0,80(a0)
    80003264:	ffffe097          	auipc	ra,0xffffe
    80003268:	490080e7          	jalr	1168(ra) # 800016f4 <copyin>
    8000326c:	00a03533          	snez	a0,a0
    80003270:	40a00533          	neg	a0,a0
}
    80003274:	60e2                	ld	ra,24(sp)
    80003276:	6442                	ld	s0,16(sp)
    80003278:	64a2                	ld	s1,8(sp)
    8000327a:	6902                	ld	s2,0(sp)
    8000327c:	6105                	addi	sp,sp,32
    8000327e:	8082                	ret
    return -1;
    80003280:	557d                	li	a0,-1
    80003282:	bfcd                	j	80003274 <fetchaddr+0x3e>
    80003284:	557d                	li	a0,-1
    80003286:	b7fd                	j	80003274 <fetchaddr+0x3e>

0000000080003288 <fetchstr>:
{
    80003288:	7179                	addi	sp,sp,-48
    8000328a:	f406                	sd	ra,40(sp)
    8000328c:	f022                	sd	s0,32(sp)
    8000328e:	ec26                	sd	s1,24(sp)
    80003290:	e84a                	sd	s2,16(sp)
    80003292:	e44e                	sd	s3,8(sp)
    80003294:	1800                	addi	s0,sp,48
    80003296:	892a                	mv	s2,a0
    80003298:	84ae                	mv	s1,a1
    8000329a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000329c:	ffffe097          	auipc	ra,0xffffe
    800032a0:	744080e7          	jalr	1860(ra) # 800019e0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800032a4:	86ce                	mv	a3,s3
    800032a6:	864a                	mv	a2,s2
    800032a8:	85a6                	mv	a1,s1
    800032aa:	6928                	ld	a0,80(a0)
    800032ac:	ffffe097          	auipc	ra,0xffffe
    800032b0:	4d6080e7          	jalr	1238(ra) # 80001782 <copyinstr>
    800032b4:	00054e63          	bltz	a0,800032d0 <fetchstr+0x48>
  return strlen(buf);
    800032b8:	8526                	mv	a0,s1
    800032ba:	ffffe097          	auipc	ra,0xffffe
    800032be:	b94080e7          	jalr	-1132(ra) # 80000e4e <strlen>
}
    800032c2:	70a2                	ld	ra,40(sp)
    800032c4:	7402                	ld	s0,32(sp)
    800032c6:	64e2                	ld	s1,24(sp)
    800032c8:	6942                	ld	s2,16(sp)
    800032ca:	69a2                	ld	s3,8(sp)
    800032cc:	6145                	addi	sp,sp,48
    800032ce:	8082                	ret
    return -1;
    800032d0:	557d                	li	a0,-1
    800032d2:	bfc5                	j	800032c2 <fetchstr+0x3a>

00000000800032d4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800032d4:	1101                	addi	sp,sp,-32
    800032d6:	ec06                	sd	ra,24(sp)
    800032d8:	e822                	sd	s0,16(sp)
    800032da:	e426                	sd	s1,8(sp)
    800032dc:	1000                	addi	s0,sp,32
    800032de:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	eee080e7          	jalr	-274(ra) # 800031ce <argraw>
    800032e8:	c088                	sw	a0,0(s1)
}
    800032ea:	60e2                	ld	ra,24(sp)
    800032ec:	6442                	ld	s0,16(sp)
    800032ee:	64a2                	ld	s1,8(sp)
    800032f0:	6105                	addi	sp,sp,32
    800032f2:	8082                	ret

00000000800032f4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800032f4:	1101                	addi	sp,sp,-32
    800032f6:	ec06                	sd	ra,24(sp)
    800032f8:	e822                	sd	s0,16(sp)
    800032fa:	e426                	sd	s1,8(sp)
    800032fc:	1000                	addi	s0,sp,32
    800032fe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003300:	00000097          	auipc	ra,0x0
    80003304:	ece080e7          	jalr	-306(ra) # 800031ce <argraw>
    80003308:	e088                	sd	a0,0(s1)
}
    8000330a:	60e2                	ld	ra,24(sp)
    8000330c:	6442                	ld	s0,16(sp)
    8000330e:	64a2                	ld	s1,8(sp)
    80003310:	6105                	addi	sp,sp,32
    80003312:	8082                	ret

0000000080003314 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003314:	7179                	addi	sp,sp,-48
    80003316:	f406                	sd	ra,40(sp)
    80003318:	f022                	sd	s0,32(sp)
    8000331a:	ec26                	sd	s1,24(sp)
    8000331c:	e84a                	sd	s2,16(sp)
    8000331e:	1800                	addi	s0,sp,48
    80003320:	84ae                	mv	s1,a1
    80003322:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003324:	fd840593          	addi	a1,s0,-40
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	fcc080e7          	jalr	-52(ra) # 800032f4 <argaddr>
  return fetchstr(addr, buf, max);
    80003330:	864a                	mv	a2,s2
    80003332:	85a6                	mv	a1,s1
    80003334:	fd843503          	ld	a0,-40(s0)
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	f50080e7          	jalr	-176(ra) # 80003288 <fetchstr>
}
    80003340:	70a2                	ld	ra,40(sp)
    80003342:	7402                	ld	s0,32(sp)
    80003344:	64e2                	ld	s1,24(sp)
    80003346:	6942                	ld	s2,16(sp)
    80003348:	6145                	addi	sp,sp,48
    8000334a:	8082                	ret

000000008000334c <syscall>:
[SYS_settickets] sys_settickets,
};

void
syscall(void)
{
    8000334c:	1101                	addi	sp,sp,-32
    8000334e:	ec06                	sd	ra,24(sp)
    80003350:	e822                	sd	s0,16(sp)
    80003352:	e426                	sd	s1,8(sp)
    80003354:	e04a                	sd	s2,0(sp)
    80003356:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003358:	ffffe097          	auipc	ra,0xffffe
    8000335c:	688080e7          	jalr	1672(ra) # 800019e0 <myproc>
    80003360:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003362:	05853903          	ld	s2,88(a0)
    80003366:	0a893783          	ld	a5,168(s2)
    8000336a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000336e:	37fd                	addiw	a5,a5,-1
    80003370:	4765                	li	a4,25
    80003372:	02f76763          	bltu	a4,a5,800033a0 <syscall+0x54>
    80003376:	00369713          	slli	a4,a3,0x3
    8000337a:	00005797          	auipc	a5,0x5
    8000337e:	44e78793          	addi	a5,a5,1102 # 800087c8 <syscalls>
    80003382:	97ba                	add	a5,a5,a4
    80003384:	6398                	ld	a4,0(a5)
    80003386:	cf09                	beqz	a4,800033a0 <syscall+0x54>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->syscalls[num]++;
    80003388:	068a                	slli	a3,a3,0x2
    8000338a:	00d504b3          	add	s1,a0,a3
    8000338e:	1744a783          	lw	a5,372(s1)
    80003392:	2785                	addiw	a5,a5,1
    80003394:	16f4aa23          	sw	a5,372(s1)
    p->trapframe->a0 = syscalls[num]();
    80003398:	9702                	jalr	a4
    8000339a:	06a93823          	sd	a0,112(s2)
    8000339e:	a839                	j	800033bc <syscall+0x70>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800033a0:	15848613          	addi	a2,s1,344
    800033a4:	588c                	lw	a1,48(s1)
    800033a6:	00005517          	auipc	a0,0x5
    800033aa:	06250513          	addi	a0,a0,98 # 80008408 <etext+0x408>
    800033ae:	ffffd097          	auipc	ra,0xffffd
    800033b2:	1da080e7          	jalr	474(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800033b6:	6cbc                	ld	a5,88(s1)
    800033b8:	577d                	li	a4,-1
    800033ba:	fbb8                	sd	a4,112(a5)
  }
}
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	64a2                	ld	s1,8(sp)
    800033c2:	6902                	ld	s2,0(sp)
    800033c4:	6105                	addi	sp,sp,32
    800033c6:	8082                	ret

00000000800033c8 <get_syscall_index>:

int get_syscall_index(int mask) {
    800033c8:	1141                	addi	sp,sp,-16
    800033ca:	e422                	sd	s0,8(sp)
    800033cc:	0800                	addi	s0,sp,16
  for (int i = 0; i < 32; i++) {
    if (mask == (1 << i)) {
    800033ce:	4785                	li	a5,1
    800033d0:	02f50263          	beq	a0,a5,800033f4 <get_syscall_index+0x2c>
    800033d4:	872a                	mv	a4,a0
  for (int i = 0; i < 32; i++) {
    800033d6:	4505                	li	a0,1
    if (mask == (1 << i)) {
    800033d8:	4685                	li	a3,1
  for (int i = 0; i < 32; i++) {
    800033da:	02000613          	li	a2,32
    if (mask == (1 << i)) {
    800033de:	00a697bb          	sllw	a5,a3,a0
    800033e2:	00e78663          	beq	a5,a4,800033ee <get_syscall_index+0x26>
  for (int i = 0; i < 32; i++) {
    800033e6:	2505                	addiw	a0,a0,1
    800033e8:	fec51be3          	bne	a0,a2,800033de <get_syscall_index+0x16>
      return i;
    }
  }
  return -1;
    800033ec:	557d                	li	a0,-1
}
    800033ee:	6422                	ld	s0,8(sp)
    800033f0:	0141                	addi	sp,sp,16
    800033f2:	8082                	ret
  for (int i = 0; i < 32; i++) {
    800033f4:	4501                	li	a0,0
    800033f6:	bfe5                	j	800033ee <get_syscall_index+0x26>

00000000800033f8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800033f8:	1101                	addi	sp,sp,-32
    800033fa:	ec06                	sd	ra,24(sp)
    800033fc:	e822                	sd	s0,16(sp)
    800033fe:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003400:	fec40593          	addi	a1,s0,-20
    80003404:	4501                	li	a0,0
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	ece080e7          	jalr	-306(ra) # 800032d4 <argint>
  exit(n);
    8000340e:	fec42503          	lw	a0,-20(s0)
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	1f2080e7          	jalr	498(ra) # 80002604 <exit>
  return 0; // not reached
}
    8000341a:	4501                	li	a0,0
    8000341c:	60e2                	ld	ra,24(sp)
    8000341e:	6442                	ld	s0,16(sp)
    80003420:	6105                	addi	sp,sp,32
    80003422:	8082                	ret

0000000080003424 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003424:	1141                	addi	sp,sp,-16
    80003426:	e406                	sd	ra,8(sp)
    80003428:	e022                	sd	s0,0(sp)
    8000342a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000342c:	ffffe097          	auipc	ra,0xffffe
    80003430:	5b4080e7          	jalr	1460(ra) # 800019e0 <myproc>
}
    80003434:	5908                	lw	a0,48(a0)
    80003436:	60a2                	ld	ra,8(sp)
    80003438:	6402                	ld	s0,0(sp)
    8000343a:	0141                	addi	sp,sp,16
    8000343c:	8082                	ret

000000008000343e <sys_fork>:

uint64
sys_fork(void)
{
    8000343e:	1141                	addi	sp,sp,-16
    80003440:	e406                	sd	ra,8(sp)
    80003442:	e022                	sd	s0,0(sp)
    80003444:	0800                	addi	s0,sp,16
  return fork();
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	acc080e7          	jalr	-1332(ra) # 80001f12 <fork>
}
    8000344e:	60a2                	ld	ra,8(sp)
    80003450:	6402                	ld	s0,0(sp)
    80003452:	0141                	addi	sp,sp,16
    80003454:	8082                	ret

0000000080003456 <sys_wait>:

uint64
sys_wait(void)
{
    80003456:	1101                	addi	sp,sp,-32
    80003458:	ec06                	sd	ra,24(sp)
    8000345a:	e822                	sd	s0,16(sp)
    8000345c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000345e:	fe840593          	addi	a1,s0,-24
    80003462:	4501                	li	a0,0
    80003464:	00000097          	auipc	ra,0x0
    80003468:	e90080e7          	jalr	-368(ra) # 800032f4 <argaddr>
  return wait(p);
    8000346c:	fe843503          	ld	a0,-24(s0)
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	388080e7          	jalr	904(ra) # 800027f8 <wait>
}
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret

0000000080003480 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000348a:	fdc40593          	addi	a1,s0,-36
    8000348e:	4501                	li	a0,0
    80003490:	00000097          	auipc	ra,0x0
    80003494:	e44080e7          	jalr	-444(ra) # 800032d4 <argint>
  addr = myproc()->sz;
    80003498:	ffffe097          	auipc	ra,0xffffe
    8000349c:	548080e7          	jalr	1352(ra) # 800019e0 <myproc>
    800034a0:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800034a2:	fdc42503          	lw	a0,-36(s0)
    800034a6:	ffffe097          	auipc	ra,0xffffe
    800034aa:	762080e7          	jalr	1890(ra) # 80001c08 <growproc>
    800034ae:	00054863          	bltz	a0,800034be <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800034b2:	8526                	mv	a0,s1
    800034b4:	70a2                	ld	ra,40(sp)
    800034b6:	7402                	ld	s0,32(sp)
    800034b8:	64e2                	ld	s1,24(sp)
    800034ba:	6145                	addi	sp,sp,48
    800034bc:	8082                	ret
    return -1;
    800034be:	54fd                	li	s1,-1
    800034c0:	bfcd                	j	800034b2 <sys_sbrk+0x32>

00000000800034c2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800034c2:	7139                	addi	sp,sp,-64
    800034c4:	fc06                	sd	ra,56(sp)
    800034c6:	f822                	sd	s0,48(sp)
    800034c8:	f426                	sd	s1,40(sp)
    800034ca:	f04a                	sd	s2,32(sp)
    800034cc:	ec4e                	sd	s3,24(sp)
    800034ce:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800034d0:	fcc40593          	addi	a1,s0,-52
    800034d4:	4501                	li	a0,0
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	dfe080e7          	jalr	-514(ra) # 800032d4 <argint>
  acquire(&tickslock);
    800034de:	00017517          	auipc	a0,0x17
    800034e2:	cf250513          	addi	a0,a0,-782 # 8001a1d0 <tickslock>
    800034e6:	ffffd097          	auipc	ra,0xffffd
    800034ea:	6f0080e7          	jalr	1776(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    800034ee:	00005917          	auipc	s2,0x5
    800034f2:	43692903          	lw	s2,1078(s2) # 80008924 <ticks>
  while (ticks - ticks0 < n)
    800034f6:	fcc42783          	lw	a5,-52(s0)
    800034fa:	cf9d                	beqz	a5,80003538 <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800034fc:	00017997          	auipc	s3,0x17
    80003500:	cd498993          	addi	s3,s3,-812 # 8001a1d0 <tickslock>
    80003504:	00005497          	auipc	s1,0x5
    80003508:	42048493          	addi	s1,s1,1056 # 80008924 <ticks>
    if (killed(myproc()))
    8000350c:	ffffe097          	auipc	ra,0xffffe
    80003510:	4d4080e7          	jalr	1236(ra) # 800019e0 <myproc>
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	2b2080e7          	jalr	690(ra) # 800027c6 <killed>
    8000351c:	ed15                	bnez	a0,80003558 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000351e:	85ce                	mv	a1,s3
    80003520:	8526                	mv	a0,s1
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	fae080e7          	jalr	-82(ra) # 800024d0 <sleep>
  while (ticks - ticks0 < n)
    8000352a:	409c                	lw	a5,0(s1)
    8000352c:	412787bb          	subw	a5,a5,s2
    80003530:	fcc42703          	lw	a4,-52(s0)
    80003534:	fce7ece3          	bltu	a5,a4,8000350c <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003538:	00017517          	auipc	a0,0x17
    8000353c:	c9850513          	addi	a0,a0,-872 # 8001a1d0 <tickslock>
    80003540:	ffffd097          	auipc	ra,0xffffd
    80003544:	74a080e7          	jalr	1866(ra) # 80000c8a <release>
  return 0;
    80003548:	4501                	li	a0,0
}
    8000354a:	70e2                	ld	ra,56(sp)
    8000354c:	7442                	ld	s0,48(sp)
    8000354e:	74a2                	ld	s1,40(sp)
    80003550:	7902                	ld	s2,32(sp)
    80003552:	69e2                	ld	s3,24(sp)
    80003554:	6121                	addi	sp,sp,64
    80003556:	8082                	ret
      release(&tickslock);
    80003558:	00017517          	auipc	a0,0x17
    8000355c:	c7850513          	addi	a0,a0,-904 # 8001a1d0 <tickslock>
    80003560:	ffffd097          	auipc	ra,0xffffd
    80003564:	72a080e7          	jalr	1834(ra) # 80000c8a <release>
      return -1;
    80003568:	557d                	li	a0,-1
    8000356a:	b7c5                	j	8000354a <sys_sleep+0x88>

000000008000356c <sys_kill>:

uint64
sys_kill(void)
{
    8000356c:	1101                	addi	sp,sp,-32
    8000356e:	ec06                	sd	ra,24(sp)
    80003570:	e822                	sd	s0,16(sp)
    80003572:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003574:	fec40593          	addi	a1,s0,-20
    80003578:	4501                	li	a0,0
    8000357a:	00000097          	auipc	ra,0x0
    8000357e:	d5a080e7          	jalr	-678(ra) # 800032d4 <argint>
  return kill(pid);
    80003582:	fec42503          	lw	a0,-20(s0)
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	1a2080e7          	jalr	418(ra) # 80002728 <kill>
}
    8000358e:	60e2                	ld	ra,24(sp)
    80003590:	6442                	ld	s0,16(sp)
    80003592:	6105                	addi	sp,sp,32
    80003594:	8082                	ret

0000000080003596 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003596:	1101                	addi	sp,sp,-32
    80003598:	ec06                	sd	ra,24(sp)
    8000359a:	e822                	sd	s0,16(sp)
    8000359c:	e426                	sd	s1,8(sp)
    8000359e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800035a0:	00017517          	auipc	a0,0x17
    800035a4:	c3050513          	addi	a0,a0,-976 # 8001a1d0 <tickslock>
    800035a8:	ffffd097          	auipc	ra,0xffffd
    800035ac:	62e080e7          	jalr	1582(ra) # 80000bd6 <acquire>
  xticks = ticks;
    800035b0:	00005497          	auipc	s1,0x5
    800035b4:	3744a483          	lw	s1,884(s1) # 80008924 <ticks>
  release(&tickslock);
    800035b8:	00017517          	auipc	a0,0x17
    800035bc:	c1850513          	addi	a0,a0,-1000 # 8001a1d0 <tickslock>
    800035c0:	ffffd097          	auipc	ra,0xffffd
    800035c4:	6ca080e7          	jalr	1738(ra) # 80000c8a <release>
  return xticks;
}
    800035c8:	02049513          	slli	a0,s1,0x20
    800035cc:	9101                	srli	a0,a0,0x20
    800035ce:	60e2                	ld	ra,24(sp)
    800035d0:	6442                	ld	s0,16(sp)
    800035d2:	64a2                	ld	s1,8(sp)
    800035d4:	6105                	addi	sp,sp,32
    800035d6:	8082                	ret

00000000800035d8 <sys_waitx>:

uint64
sys_waitx(void)
{
    800035d8:	7139                	addi	sp,sp,-64
    800035da:	fc06                	sd	ra,56(sp)
    800035dc:	f822                	sd	s0,48(sp)
    800035de:	f426                	sd	s1,40(sp)
    800035e0:	f04a                	sd	s2,32(sp)
    800035e2:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    800035e4:	fd840593          	addi	a1,s0,-40
    800035e8:	4501                	li	a0,0
    800035ea:	00000097          	auipc	ra,0x0
    800035ee:	d0a080e7          	jalr	-758(ra) # 800032f4 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    800035f2:	fd040593          	addi	a1,s0,-48
    800035f6:	4505                	li	a0,1
    800035f8:	00000097          	auipc	ra,0x0
    800035fc:	cfc080e7          	jalr	-772(ra) # 800032f4 <argaddr>
  argaddr(2, &addr2);
    80003600:	fc840593          	addi	a1,s0,-56
    80003604:	4509                	li	a0,2
    80003606:	00000097          	auipc	ra,0x0
    8000360a:	cee080e7          	jalr	-786(ra) # 800032f4 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    8000360e:	fc040613          	addi	a2,s0,-64
    80003612:	fc440593          	addi	a1,s0,-60
    80003616:	fd843503          	ld	a0,-40(s0)
    8000361a:	fffff097          	auipc	ra,0xfffff
    8000361e:	466080e7          	jalr	1126(ra) # 80002a80 <waitx>
    80003622:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80003624:	ffffe097          	auipc	ra,0xffffe
    80003628:	3bc080e7          	jalr	956(ra) # 800019e0 <myproc>
    8000362c:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000362e:	4691                	li	a3,4
    80003630:	fc440613          	addi	a2,s0,-60
    80003634:	fd043583          	ld	a1,-48(s0)
    80003638:	6928                	ld	a0,80(a0)
    8000363a:	ffffe097          	auipc	ra,0xffffe
    8000363e:	02e080e7          	jalr	46(ra) # 80001668 <copyout>
    return -1;
    80003642:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003644:	00054f63          	bltz	a0,80003662 <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003648:	4691                	li	a3,4
    8000364a:	fc040613          	addi	a2,s0,-64
    8000364e:	fc843583          	ld	a1,-56(s0)
    80003652:	68a8                	ld	a0,80(s1)
    80003654:	ffffe097          	auipc	ra,0xffffe
    80003658:	014080e7          	jalr	20(ra) # 80001668 <copyout>
    8000365c:	00054a63          	bltz	a0,80003670 <sys_waitx+0x98>
    return -1;
  return ret;
    80003660:	87ca                	mv	a5,s2
}
    80003662:	853e                	mv	a0,a5
    80003664:	70e2                	ld	ra,56(sp)
    80003666:	7442                	ld	s0,48(sp)
    80003668:	74a2                	ld	s1,40(sp)
    8000366a:	7902                	ld	s2,32(sp)
    8000366c:	6121                	addi	sp,sp,64
    8000366e:	8082                	ret
    return -1;
    80003670:	57fd                	li	a5,-1
    80003672:	bfc5                	j	80003662 <sys_waitx+0x8a>

0000000080003674 <sys_getsyscount>:
//   return p->syscalls[index];
// }

uint64
sys_getsyscount(void)
{
    80003674:	1101                	addi	sp,sp,-32
    80003676:	ec06                	sd	ra,24(sp)
    80003678:	e822                	sd	s0,16(sp)
    8000367a:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    8000367c:	fec40593          	addi	a1,s0,-20
    80003680:	4501                	li	a0,0
    80003682:	00000097          	auipc	ra,0x0
    80003686:	c52080e7          	jalr	-942(ra) # 800032d4 <argint>

  struct proc *p = myproc();
    8000368a:	ffffe097          	auipc	ra,0xffffe
    8000368e:	356080e7          	jalr	854(ra) # 800019e0 <myproc>
  int index = get_syscall_index(mask);
    80003692:	fec42503          	lw	a0,-20(s0)
    80003696:	00000097          	auipc	ra,0x0
    8000369a:	d32080e7          	jalr	-718(ra) # 800033c8 <get_syscall_index>
    index = p->syscalls[index]; 
  }
  // printf("Debug: Counting syscall %d for PID %d\n", index, p->pid);
  // printf("Debug: Count for syscall %d: %d\n", index, p->syscall_count[index]);

  index = get_syscall_index(mask);
    8000369e:	fec42503          	lw	a0,-20(s0)
    800036a2:	00000097          	auipc	ra,0x0
    800036a6:	d26080e7          	jalr	-730(ra) # 800033c8 <get_syscall_index>
    800036aa:	872a                	mv	a4,a0
  if (index == -1) return -1;
    800036ac:	57fd                	li	a5,-1
    800036ae:	557d                	li	a0,-1
    800036b0:	00f70863          	beq	a4,a5,800036c0 <sys_getsyscount+0x4c>
  int count = getsyscount(mask);
    800036b4:	fec42503          	lw	a0,-20(s0)
    800036b8:	ffffe097          	auipc	ra,0xffffe
    800036bc:	5ac080e7          	jalr	1452(ra) # 80001c64 <getsyscount>
  return count;
}
    800036c0:	60e2                	ld	ra,24(sp)
    800036c2:	6442                	ld	s0,16(sp)
    800036c4:	6105                	addi	sp,sp,32
    800036c6:	8082                	ret

00000000800036c8 <sys_sigalarm>:
// printf("Debug: Invalid mask %d\n", mask); // Debug print
// printf("Debug: sys_getsyscount called with mask %d (index %d), count %d\n", mask, index, count); // Debug print

uint64
sys_sigalarm(void)
{
    800036c8:	7179                	addi	sp,sp,-48
    800036ca:	f406                	sd	ra,40(sp)
    800036cc:	f022                	sd	s0,32(sp)
    800036ce:	ec26                	sd	s1,24(sp)
    800036d0:	1800                	addi	s0,sp,48
  int interval;
  argint(0, &interval);
    800036d2:	fdc40593          	addi	a1,s0,-36
    800036d6:	4501                	li	a0,0
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	bfc080e7          	jalr	-1028(ra) # 800032d4 <argint>
  uint64 handler;
  argaddr(1, &handler);
    800036e0:	fd040593          	addi	a1,s0,-48
    800036e4:	4505                	li	a0,1
    800036e6:	00000097          	auipc	ra,0x0
    800036ea:	c0e080e7          	jalr	-1010(ra) # 800032f4 <argaddr>
  struct proc *p = myproc();
    800036ee:	ffffe097          	auipc	ra,0xffffe
    800036f2:	2f2080e7          	jalr	754(ra) # 800019e0 <myproc>
    800036f6:	84aa                	mv	s1,a0
  memset(&p->ticks_count, 0, sizeof(p->ticks_count));
    800036f8:	4611                	li	a2,4
    800036fa:	4581                	li	a1,0
    800036fc:	1f450513          	addi	a0,a0,500
    80003700:	ffffd097          	auipc	ra,0xffffd
    80003704:	5d2080e7          	jalr	1490(ra) # 80000cd2 <memset>
  if (interval > 0) p->alarm_on = 1;
    80003708:	fdc42783          	lw	a5,-36(s0)
    8000370c:	00f02733          	sgtz	a4,a5
    80003710:	1ee4ac23          	sw	a4,504(s1)
  else p->alarm_on = 0;
  p->alarm_interval = interval;
    80003714:	1ef4ae23          	sw	a5,508(s1)
  p->alarm_handler = handler;
    80003718:	fd043783          	ld	a5,-48(s0)
    8000371c:	20f4b023          	sd	a5,512(s1)
  if (p->alarm_trapframe) {
    80003720:	2084b503          	ld	a0,520(s1)
    80003724:	cd09                	beqz	a0,8000373e <sys_sigalarm+0x76>
    kfree(p->alarm_trapframe);
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	2c4080e7          	jalr	708(ra) # 800009ea <kfree>
    memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
    8000372e:	4621                	li	a2,8
    80003730:	4581                	li	a1,0
    80003732:	20848513          	addi	a0,s1,520
    80003736:	ffffd097          	auipc	ra,0xffffd
    8000373a:	59c080e7          	jalr	1436(ra) # 80000cd2 <memset>
  }
  return 0;
}
    8000373e:	4501                	li	a0,0
    80003740:	70a2                	ld	ra,40(sp)
    80003742:	7402                	ld	s0,32(sp)
    80003744:	64e2                	ld	s1,24(sp)
    80003746:	6145                	addi	sp,sp,48
    80003748:	8082                	ret

000000008000374a <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    8000374a:	1101                	addi	sp,sp,-32
    8000374c:	ec06                	sd	ra,24(sp)
    8000374e:	e822                	sd	s0,16(sp)
    80003750:	e426                	sd	s1,8(sp)
    80003752:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003754:	ffffe097          	auipc	ra,0xffffe
    80003758:	28c080e7          	jalr	652(ra) # 800019e0 <myproc>
    8000375c:	84aa                	mv	s1,a0
  if (p->alarm_trapframe) {
    8000375e:	20853583          	ld	a1,520(a0)
    memmove(p->trapframe, p->alarm_trapframe, sizeof(struct trapframe));
    kfree(p->alarm_trapframe);
    memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
    return 0;
  }
  return -1;
    80003762:	557d                	li	a0,-1
  if (p->alarm_trapframe) {
    80003764:	c59d                	beqz	a1,80003792 <sys_sigreturn+0x48>
    memmove(p->trapframe, p->alarm_trapframe, sizeof(struct trapframe));
    80003766:	12000613          	li	a2,288
    8000376a:	6ca8                	ld	a0,88(s1)
    8000376c:	ffffd097          	auipc	ra,0xffffd
    80003770:	5c2080e7          	jalr	1474(ra) # 80000d2e <memmove>
    kfree(p->alarm_trapframe);
    80003774:	2084b503          	ld	a0,520(s1)
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	272080e7          	jalr	626(ra) # 800009ea <kfree>
    memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
    80003780:	4621                	li	a2,8
    80003782:	4581                	li	a1,0
    80003784:	20848513          	addi	a0,s1,520
    80003788:	ffffd097          	auipc	ra,0xffffd
    8000378c:	54a080e7          	jalr	1354(ra) # 80000cd2 <memset>
    return 0;
    80003790:	4501                	li	a0,0
}
    80003792:	60e2                	ld	ra,24(sp)
    80003794:	6442                	ld	s0,16(sp)
    80003796:	64a2                	ld	s1,8(sp)
    80003798:	6105                	addi	sp,sp,32
    8000379a:	8082                	ret

000000008000379c <sys_settickets>:

uint64  
sys_settickets(void)
{
    8000379c:	1101                	addi	sp,sp,-32
    8000379e:	ec06                	sd	ra,24(sp)
    800037a0:	e822                	sd	s0,16(sp)
    800037a2:	1000                	addi	s0,sp,32
  int tickets;
  argint(0, &tickets);
    800037a4:	fec40593          	addi	a1,s0,-20
    800037a8:	4501                	li	a0,0
    800037aa:	00000097          	auipc	ra,0x0
    800037ae:	b2a080e7          	jalr	-1238(ra) # 800032d4 <argint>
  if (tickets <= 0) return -1;
    800037b2:	fec42783          	lw	a5,-20(s0)
    800037b6:	557d                	li	a0,-1
    800037b8:	00f05b63          	blez	a5,800037ce <sys_settickets+0x32>
  myproc()->tickets = tickets;
    800037bc:	ffffe097          	auipc	ra,0xffffe
    800037c0:	224080e7          	jalr	548(ra) # 800019e0 <myproc>
    800037c4:	fec42783          	lw	a5,-20(s0)
    800037c8:	20f52823          	sw	a5,528(a0)
  return tickets;
    800037cc:	853e                	mv	a0,a5
}
    800037ce:	60e2                	ld	ra,24(sp)
    800037d0:	6442                	ld	s0,16(sp)
    800037d2:	6105                	addi	sp,sp,32
    800037d4:	8082                	ret

00000000800037d6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800037d6:	7179                	addi	sp,sp,-48
    800037d8:	f406                	sd	ra,40(sp)
    800037da:	f022                	sd	s0,32(sp)
    800037dc:	ec26                	sd	s1,24(sp)
    800037de:	e84a                	sd	s2,16(sp)
    800037e0:	e44e                	sd	s3,8(sp)
    800037e2:	e052                	sd	s4,0(sp)
    800037e4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800037e6:	00005597          	auipc	a1,0x5
    800037ea:	c4258593          	addi	a1,a1,-958 # 80008428 <etext+0x428>
    800037ee:	00017517          	auipc	a0,0x17
    800037f2:	9fa50513          	addi	a0,a0,-1542 # 8001a1e8 <bcache>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	350080e7          	jalr	848(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800037fe:	0001f797          	auipc	a5,0x1f
    80003802:	9ea78793          	addi	a5,a5,-1558 # 800221e8 <bcache+0x8000>
    80003806:	0001f717          	auipc	a4,0x1f
    8000380a:	c4a70713          	addi	a4,a4,-950 # 80022450 <bcache+0x8268>
    8000380e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003812:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003816:	00017497          	auipc	s1,0x17
    8000381a:	9ea48493          	addi	s1,s1,-1558 # 8001a200 <bcache+0x18>
    b->next = bcache.head.next;
    8000381e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003820:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003822:	00005a17          	auipc	s4,0x5
    80003826:	c0ea0a13          	addi	s4,s4,-1010 # 80008430 <etext+0x430>
    b->next = bcache.head.next;
    8000382a:	2b893783          	ld	a5,696(s2)
    8000382e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003830:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003834:	85d2                	mv	a1,s4
    80003836:	01048513          	addi	a0,s1,16
    8000383a:	00001097          	auipc	ra,0x1
    8000383e:	4c4080e7          	jalr	1220(ra) # 80004cfe <initsleeplock>
    bcache.head.next->prev = b;
    80003842:	2b893783          	ld	a5,696(s2)
    80003846:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003848:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000384c:	45848493          	addi	s1,s1,1112
    80003850:	fd349de3          	bne	s1,s3,8000382a <binit+0x54>
  }
}
    80003854:	70a2                	ld	ra,40(sp)
    80003856:	7402                	ld	s0,32(sp)
    80003858:	64e2                	ld	s1,24(sp)
    8000385a:	6942                	ld	s2,16(sp)
    8000385c:	69a2                	ld	s3,8(sp)
    8000385e:	6a02                	ld	s4,0(sp)
    80003860:	6145                	addi	sp,sp,48
    80003862:	8082                	ret

0000000080003864 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003864:	7179                	addi	sp,sp,-48
    80003866:	f406                	sd	ra,40(sp)
    80003868:	f022                	sd	s0,32(sp)
    8000386a:	ec26                	sd	s1,24(sp)
    8000386c:	e84a                	sd	s2,16(sp)
    8000386e:	e44e                	sd	s3,8(sp)
    80003870:	1800                	addi	s0,sp,48
    80003872:	892a                	mv	s2,a0
    80003874:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003876:	00017517          	auipc	a0,0x17
    8000387a:	97250513          	addi	a0,a0,-1678 # 8001a1e8 <bcache>
    8000387e:	ffffd097          	auipc	ra,0xffffd
    80003882:	358080e7          	jalr	856(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003886:	0001f497          	auipc	s1,0x1f
    8000388a:	c1a4b483          	ld	s1,-998(s1) # 800224a0 <bcache+0x82b8>
    8000388e:	0001f797          	auipc	a5,0x1f
    80003892:	bc278793          	addi	a5,a5,-1086 # 80022450 <bcache+0x8268>
    80003896:	02f48f63          	beq	s1,a5,800038d4 <bread+0x70>
    8000389a:	873e                	mv	a4,a5
    8000389c:	a021                	j	800038a4 <bread+0x40>
    8000389e:	68a4                	ld	s1,80(s1)
    800038a0:	02e48a63          	beq	s1,a4,800038d4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800038a4:	449c                	lw	a5,8(s1)
    800038a6:	ff279ce3          	bne	a5,s2,8000389e <bread+0x3a>
    800038aa:	44dc                	lw	a5,12(s1)
    800038ac:	ff3799e3          	bne	a5,s3,8000389e <bread+0x3a>
      b->refcnt++;
    800038b0:	40bc                	lw	a5,64(s1)
    800038b2:	2785                	addiw	a5,a5,1
    800038b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800038b6:	00017517          	auipc	a0,0x17
    800038ba:	93250513          	addi	a0,a0,-1742 # 8001a1e8 <bcache>
    800038be:	ffffd097          	auipc	ra,0xffffd
    800038c2:	3cc080e7          	jalr	972(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    800038c6:	01048513          	addi	a0,s1,16
    800038ca:	00001097          	auipc	ra,0x1
    800038ce:	46e080e7          	jalr	1134(ra) # 80004d38 <acquiresleep>
      return b;
    800038d2:	a8b9                	j	80003930 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800038d4:	0001f497          	auipc	s1,0x1f
    800038d8:	bc44b483          	ld	s1,-1084(s1) # 80022498 <bcache+0x82b0>
    800038dc:	0001f797          	auipc	a5,0x1f
    800038e0:	b7478793          	addi	a5,a5,-1164 # 80022450 <bcache+0x8268>
    800038e4:	00f48863          	beq	s1,a5,800038f4 <bread+0x90>
    800038e8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800038ea:	40bc                	lw	a5,64(s1)
    800038ec:	cf81                	beqz	a5,80003904 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800038ee:	64a4                	ld	s1,72(s1)
    800038f0:	fee49de3          	bne	s1,a4,800038ea <bread+0x86>
  panic("bget: no buffers");
    800038f4:	00005517          	auipc	a0,0x5
    800038f8:	b4450513          	addi	a0,a0,-1212 # 80008438 <etext+0x438>
    800038fc:	ffffd097          	auipc	ra,0xffffd
    80003900:	c42080e7          	jalr	-958(ra) # 8000053e <panic>
      b->dev = dev;
    80003904:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003908:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000390c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003910:	4785                	li	a5,1
    80003912:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003914:	00017517          	auipc	a0,0x17
    80003918:	8d450513          	addi	a0,a0,-1836 # 8001a1e8 <bcache>
    8000391c:	ffffd097          	auipc	ra,0xffffd
    80003920:	36e080e7          	jalr	878(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80003924:	01048513          	addi	a0,s1,16
    80003928:	00001097          	auipc	ra,0x1
    8000392c:	410080e7          	jalr	1040(ra) # 80004d38 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003930:	409c                	lw	a5,0(s1)
    80003932:	cb89                	beqz	a5,80003944 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003934:	8526                	mv	a0,s1
    80003936:	70a2                	ld	ra,40(sp)
    80003938:	7402                	ld	s0,32(sp)
    8000393a:	64e2                	ld	s1,24(sp)
    8000393c:	6942                	ld	s2,16(sp)
    8000393e:	69a2                	ld	s3,8(sp)
    80003940:	6145                	addi	sp,sp,48
    80003942:	8082                	ret
    virtio_disk_rw(b, 0);
    80003944:	4581                	li	a1,0
    80003946:	8526                	mv	a0,s1
    80003948:	00003097          	auipc	ra,0x3
    8000394c:	fdc080e7          	jalr	-36(ra) # 80006924 <virtio_disk_rw>
    b->valid = 1;
    80003950:	4785                	li	a5,1
    80003952:	c09c                	sw	a5,0(s1)
  return b;
    80003954:	b7c5                	j	80003934 <bread+0xd0>

0000000080003956 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003956:	1101                	addi	sp,sp,-32
    80003958:	ec06                	sd	ra,24(sp)
    8000395a:	e822                	sd	s0,16(sp)
    8000395c:	e426                	sd	s1,8(sp)
    8000395e:	1000                	addi	s0,sp,32
    80003960:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003962:	0541                	addi	a0,a0,16
    80003964:	00001097          	auipc	ra,0x1
    80003968:	46e080e7          	jalr	1134(ra) # 80004dd2 <holdingsleep>
    8000396c:	cd01                	beqz	a0,80003984 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000396e:	4585                	li	a1,1
    80003970:	8526                	mv	a0,s1
    80003972:	00003097          	auipc	ra,0x3
    80003976:	fb2080e7          	jalr	-78(ra) # 80006924 <virtio_disk_rw>
}
    8000397a:	60e2                	ld	ra,24(sp)
    8000397c:	6442                	ld	s0,16(sp)
    8000397e:	64a2                	ld	s1,8(sp)
    80003980:	6105                	addi	sp,sp,32
    80003982:	8082                	ret
    panic("bwrite");
    80003984:	00005517          	auipc	a0,0x5
    80003988:	acc50513          	addi	a0,a0,-1332 # 80008450 <etext+0x450>
    8000398c:	ffffd097          	auipc	ra,0xffffd
    80003990:	bb2080e7          	jalr	-1102(ra) # 8000053e <panic>

0000000080003994 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003994:	1101                	addi	sp,sp,-32
    80003996:	ec06                	sd	ra,24(sp)
    80003998:	e822                	sd	s0,16(sp)
    8000399a:	e426                	sd	s1,8(sp)
    8000399c:	e04a                	sd	s2,0(sp)
    8000399e:	1000                	addi	s0,sp,32
    800039a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800039a2:	01050913          	addi	s2,a0,16
    800039a6:	854a                	mv	a0,s2
    800039a8:	00001097          	auipc	ra,0x1
    800039ac:	42a080e7          	jalr	1066(ra) # 80004dd2 <holdingsleep>
    800039b0:	c92d                	beqz	a0,80003a22 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800039b2:	854a                	mv	a0,s2
    800039b4:	00001097          	auipc	ra,0x1
    800039b8:	3da080e7          	jalr	986(ra) # 80004d8e <releasesleep>

  acquire(&bcache.lock);
    800039bc:	00017517          	auipc	a0,0x17
    800039c0:	82c50513          	addi	a0,a0,-2004 # 8001a1e8 <bcache>
    800039c4:	ffffd097          	auipc	ra,0xffffd
    800039c8:	212080e7          	jalr	530(ra) # 80000bd6 <acquire>
  b->refcnt--;
    800039cc:	40bc                	lw	a5,64(s1)
    800039ce:	37fd                	addiw	a5,a5,-1
    800039d0:	0007871b          	sext.w	a4,a5
    800039d4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800039d6:	eb05                	bnez	a4,80003a06 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800039d8:	68bc                	ld	a5,80(s1)
    800039da:	64b8                	ld	a4,72(s1)
    800039dc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800039de:	64bc                	ld	a5,72(s1)
    800039e0:	68b8                	ld	a4,80(s1)
    800039e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800039e4:	0001f797          	auipc	a5,0x1f
    800039e8:	80478793          	addi	a5,a5,-2044 # 800221e8 <bcache+0x8000>
    800039ec:	2b87b703          	ld	a4,696(a5)
    800039f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800039f2:	0001f717          	auipc	a4,0x1f
    800039f6:	a5e70713          	addi	a4,a4,-1442 # 80022450 <bcache+0x8268>
    800039fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800039fc:	2b87b703          	ld	a4,696(a5)
    80003a00:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003a02:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003a06:	00016517          	auipc	a0,0x16
    80003a0a:	7e250513          	addi	a0,a0,2018 # 8001a1e8 <bcache>
    80003a0e:	ffffd097          	auipc	ra,0xffffd
    80003a12:	27c080e7          	jalr	636(ra) # 80000c8a <release>
}
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6902                	ld	s2,0(sp)
    80003a1e:	6105                	addi	sp,sp,32
    80003a20:	8082                	ret
    panic("brelse");
    80003a22:	00005517          	auipc	a0,0x5
    80003a26:	a3650513          	addi	a0,a0,-1482 # 80008458 <etext+0x458>
    80003a2a:	ffffd097          	auipc	ra,0xffffd
    80003a2e:	b14080e7          	jalr	-1260(ra) # 8000053e <panic>

0000000080003a32 <bpin>:

void
bpin(struct buf *b) {
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	1000                	addi	s0,sp,32
    80003a3c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003a3e:	00016517          	auipc	a0,0x16
    80003a42:	7aa50513          	addi	a0,a0,1962 # 8001a1e8 <bcache>
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	190080e7          	jalr	400(ra) # 80000bd6 <acquire>
  b->refcnt++;
    80003a4e:	40bc                	lw	a5,64(s1)
    80003a50:	2785                	addiw	a5,a5,1
    80003a52:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003a54:	00016517          	auipc	a0,0x16
    80003a58:	79450513          	addi	a0,a0,1940 # 8001a1e8 <bcache>
    80003a5c:	ffffd097          	auipc	ra,0xffffd
    80003a60:	22e080e7          	jalr	558(ra) # 80000c8a <release>
}
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	64a2                	ld	s1,8(sp)
    80003a6a:	6105                	addi	sp,sp,32
    80003a6c:	8082                	ret

0000000080003a6e <bunpin>:

void
bunpin(struct buf *b) {
    80003a6e:	1101                	addi	sp,sp,-32
    80003a70:	ec06                	sd	ra,24(sp)
    80003a72:	e822                	sd	s0,16(sp)
    80003a74:	e426                	sd	s1,8(sp)
    80003a76:	1000                	addi	s0,sp,32
    80003a78:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003a7a:	00016517          	auipc	a0,0x16
    80003a7e:	76e50513          	addi	a0,a0,1902 # 8001a1e8 <bcache>
    80003a82:	ffffd097          	auipc	ra,0xffffd
    80003a86:	154080e7          	jalr	340(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003a8a:	40bc                	lw	a5,64(s1)
    80003a8c:	37fd                	addiw	a5,a5,-1
    80003a8e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003a90:	00016517          	auipc	a0,0x16
    80003a94:	75850513          	addi	a0,a0,1880 # 8001a1e8 <bcache>
    80003a98:	ffffd097          	auipc	ra,0xffffd
    80003a9c:	1f2080e7          	jalr	498(ra) # 80000c8a <release>
}
    80003aa0:	60e2                	ld	ra,24(sp)
    80003aa2:	6442                	ld	s0,16(sp)
    80003aa4:	64a2                	ld	s1,8(sp)
    80003aa6:	6105                	addi	sp,sp,32
    80003aa8:	8082                	ret

0000000080003aaa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003aaa:	1101                	addi	sp,sp,-32
    80003aac:	ec06                	sd	ra,24(sp)
    80003aae:	e822                	sd	s0,16(sp)
    80003ab0:	e426                	sd	s1,8(sp)
    80003ab2:	e04a                	sd	s2,0(sp)
    80003ab4:	1000                	addi	s0,sp,32
    80003ab6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003ab8:	00d5d59b          	srliw	a1,a1,0xd
    80003abc:	0001f797          	auipc	a5,0x1f
    80003ac0:	e087a783          	lw	a5,-504(a5) # 800228c4 <sb+0x1c>
    80003ac4:	9dbd                	addw	a1,a1,a5
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	d9e080e7          	jalr	-610(ra) # 80003864 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003ace:	0074f713          	andi	a4,s1,7
    80003ad2:	4785                	li	a5,1
    80003ad4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003ad8:	14ce                	slli	s1,s1,0x33
    80003ada:	90d9                	srli	s1,s1,0x36
    80003adc:	00950733          	add	a4,a0,s1
    80003ae0:	05874703          	lbu	a4,88(a4)
    80003ae4:	00e7f6b3          	and	a3,a5,a4
    80003ae8:	c69d                	beqz	a3,80003b16 <bfree+0x6c>
    80003aea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003aec:	94aa                	add	s1,s1,a0
    80003aee:	fff7c793          	not	a5,a5
    80003af2:	8ff9                	and	a5,a5,a4
    80003af4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003af8:	00001097          	auipc	ra,0x1
    80003afc:	120080e7          	jalr	288(ra) # 80004c18 <log_write>
  brelse(bp);
    80003b00:	854a                	mv	a0,s2
    80003b02:	00000097          	auipc	ra,0x0
    80003b06:	e92080e7          	jalr	-366(ra) # 80003994 <brelse>
}
    80003b0a:	60e2                	ld	ra,24(sp)
    80003b0c:	6442                	ld	s0,16(sp)
    80003b0e:	64a2                	ld	s1,8(sp)
    80003b10:	6902                	ld	s2,0(sp)
    80003b12:	6105                	addi	sp,sp,32
    80003b14:	8082                	ret
    panic("freeing free block");
    80003b16:	00005517          	auipc	a0,0x5
    80003b1a:	94a50513          	addi	a0,a0,-1718 # 80008460 <etext+0x460>
    80003b1e:	ffffd097          	auipc	ra,0xffffd
    80003b22:	a20080e7          	jalr	-1504(ra) # 8000053e <panic>

0000000080003b26 <balloc>:
{
    80003b26:	711d                	addi	sp,sp,-96
    80003b28:	ec86                	sd	ra,88(sp)
    80003b2a:	e8a2                	sd	s0,80(sp)
    80003b2c:	e4a6                	sd	s1,72(sp)
    80003b2e:	e0ca                	sd	s2,64(sp)
    80003b30:	fc4e                	sd	s3,56(sp)
    80003b32:	f852                	sd	s4,48(sp)
    80003b34:	f456                	sd	s5,40(sp)
    80003b36:	f05a                	sd	s6,32(sp)
    80003b38:	ec5e                	sd	s7,24(sp)
    80003b3a:	e862                	sd	s8,16(sp)
    80003b3c:	e466                	sd	s9,8(sp)
    80003b3e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003b40:	0001f797          	auipc	a5,0x1f
    80003b44:	d6c7a783          	lw	a5,-660(a5) # 800228ac <sb+0x4>
    80003b48:	10078163          	beqz	a5,80003c4a <balloc+0x124>
    80003b4c:	8baa                	mv	s7,a0
    80003b4e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003b50:	0001fb17          	auipc	s6,0x1f
    80003b54:	d58b0b13          	addi	s6,s6,-680 # 800228a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b58:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003b5a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b5c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003b5e:	6c89                	lui	s9,0x2
    80003b60:	a061                	j	80003be8 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003b62:	974a                	add	a4,a4,s2
    80003b64:	8fd5                	or	a5,a5,a3
    80003b66:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003b6a:	854a                	mv	a0,s2
    80003b6c:	00001097          	auipc	ra,0x1
    80003b70:	0ac080e7          	jalr	172(ra) # 80004c18 <log_write>
        brelse(bp);
    80003b74:	854a                	mv	a0,s2
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	e1e080e7          	jalr	-482(ra) # 80003994 <brelse>
  bp = bread(dev, bno);
    80003b7e:	85a6                	mv	a1,s1
    80003b80:	855e                	mv	a0,s7
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	ce2080e7          	jalr	-798(ra) # 80003864 <bread>
    80003b8a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003b8c:	40000613          	li	a2,1024
    80003b90:	4581                	li	a1,0
    80003b92:	05850513          	addi	a0,a0,88
    80003b96:	ffffd097          	auipc	ra,0xffffd
    80003b9a:	13c080e7          	jalr	316(ra) # 80000cd2 <memset>
  log_write(bp);
    80003b9e:	854a                	mv	a0,s2
    80003ba0:	00001097          	auipc	ra,0x1
    80003ba4:	078080e7          	jalr	120(ra) # 80004c18 <log_write>
  brelse(bp);
    80003ba8:	854a                	mv	a0,s2
    80003baa:	00000097          	auipc	ra,0x0
    80003bae:	dea080e7          	jalr	-534(ra) # 80003994 <brelse>
}
    80003bb2:	8526                	mv	a0,s1
    80003bb4:	60e6                	ld	ra,88(sp)
    80003bb6:	6446                	ld	s0,80(sp)
    80003bb8:	64a6                	ld	s1,72(sp)
    80003bba:	6906                	ld	s2,64(sp)
    80003bbc:	79e2                	ld	s3,56(sp)
    80003bbe:	7a42                	ld	s4,48(sp)
    80003bc0:	7aa2                	ld	s5,40(sp)
    80003bc2:	7b02                	ld	s6,32(sp)
    80003bc4:	6be2                	ld	s7,24(sp)
    80003bc6:	6c42                	ld	s8,16(sp)
    80003bc8:	6ca2                	ld	s9,8(sp)
    80003bca:	6125                	addi	sp,sp,96
    80003bcc:	8082                	ret
    brelse(bp);
    80003bce:	854a                	mv	a0,s2
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	dc4080e7          	jalr	-572(ra) # 80003994 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003bd8:	015c87bb          	addw	a5,s9,s5
    80003bdc:	00078a9b          	sext.w	s5,a5
    80003be0:	004b2703          	lw	a4,4(s6)
    80003be4:	06eaf363          	bgeu	s5,a4,80003c4a <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003be8:	41fad79b          	sraiw	a5,s5,0x1f
    80003bec:	0137d79b          	srliw	a5,a5,0x13
    80003bf0:	015787bb          	addw	a5,a5,s5
    80003bf4:	40d7d79b          	sraiw	a5,a5,0xd
    80003bf8:	01cb2583          	lw	a1,28(s6)
    80003bfc:	9dbd                	addw	a1,a1,a5
    80003bfe:	855e                	mv	a0,s7
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	c64080e7          	jalr	-924(ra) # 80003864 <bread>
    80003c08:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003c0a:	004b2503          	lw	a0,4(s6)
    80003c0e:	000a849b          	sext.w	s1,s5
    80003c12:	8662                	mv	a2,s8
    80003c14:	faa4fde3          	bgeu	s1,a0,80003bce <balloc+0xa8>
      m = 1 << (bi % 8);
    80003c18:	41f6579b          	sraiw	a5,a2,0x1f
    80003c1c:	01d7d69b          	srliw	a3,a5,0x1d
    80003c20:	00c6873b          	addw	a4,a3,a2
    80003c24:	00777793          	andi	a5,a4,7
    80003c28:	9f95                	subw	a5,a5,a3
    80003c2a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003c2e:	4037571b          	sraiw	a4,a4,0x3
    80003c32:	00e906b3          	add	a3,s2,a4
    80003c36:	0586c683          	lbu	a3,88(a3)
    80003c3a:	00d7f5b3          	and	a1,a5,a3
    80003c3e:	d195                	beqz	a1,80003b62 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003c40:	2605                	addiw	a2,a2,1
    80003c42:	2485                	addiw	s1,s1,1
    80003c44:	fd4618e3          	bne	a2,s4,80003c14 <balloc+0xee>
    80003c48:	b759                	j	80003bce <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003c4a:	00005517          	auipc	a0,0x5
    80003c4e:	82e50513          	addi	a0,a0,-2002 # 80008478 <etext+0x478>
    80003c52:	ffffd097          	auipc	ra,0xffffd
    80003c56:	936080e7          	jalr	-1738(ra) # 80000588 <printf>
  return 0;
    80003c5a:	4481                	li	s1,0
    80003c5c:	bf99                	j	80003bb2 <balloc+0x8c>

0000000080003c5e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003c5e:	7179                	addi	sp,sp,-48
    80003c60:	f406                	sd	ra,40(sp)
    80003c62:	f022                	sd	s0,32(sp)
    80003c64:	ec26                	sd	s1,24(sp)
    80003c66:	e84a                	sd	s2,16(sp)
    80003c68:	e44e                	sd	s3,8(sp)
    80003c6a:	e052                	sd	s4,0(sp)
    80003c6c:	1800                	addi	s0,sp,48
    80003c6e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003c70:	47ad                	li	a5,11
    80003c72:	02b7e763          	bltu	a5,a1,80003ca0 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003c76:	02059493          	slli	s1,a1,0x20
    80003c7a:	9081                	srli	s1,s1,0x20
    80003c7c:	048a                	slli	s1,s1,0x2
    80003c7e:	94aa                	add	s1,s1,a0
    80003c80:	0504a903          	lw	s2,80(s1)
    80003c84:	06091e63          	bnez	s2,80003d00 <bmap+0xa2>
      addr = balloc(ip->dev);
    80003c88:	4108                	lw	a0,0(a0)
    80003c8a:	00000097          	auipc	ra,0x0
    80003c8e:	e9c080e7          	jalr	-356(ra) # 80003b26 <balloc>
    80003c92:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003c96:	06090563          	beqz	s2,80003d00 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003c9a:	0524a823          	sw	s2,80(s1)
    80003c9e:	a08d                	j	80003d00 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003ca0:	ff45849b          	addiw	s1,a1,-12
    80003ca4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003ca8:	0ff00793          	li	a5,255
    80003cac:	08e7e563          	bltu	a5,a4,80003d36 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003cb0:	08052903          	lw	s2,128(a0)
    80003cb4:	00091d63          	bnez	s2,80003cce <bmap+0x70>
      addr = balloc(ip->dev);
    80003cb8:	4108                	lw	a0,0(a0)
    80003cba:	00000097          	auipc	ra,0x0
    80003cbe:	e6c080e7          	jalr	-404(ra) # 80003b26 <balloc>
    80003cc2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003cc6:	02090d63          	beqz	s2,80003d00 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003cca:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003cce:	85ca                	mv	a1,s2
    80003cd0:	0009a503          	lw	a0,0(s3)
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	b90080e7          	jalr	-1136(ra) # 80003864 <bread>
    80003cdc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003cde:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003ce2:	02049593          	slli	a1,s1,0x20
    80003ce6:	9181                	srli	a1,a1,0x20
    80003ce8:	058a                	slli	a1,a1,0x2
    80003cea:	00b784b3          	add	s1,a5,a1
    80003cee:	0004a903          	lw	s2,0(s1)
    80003cf2:	02090063          	beqz	s2,80003d12 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003cf6:	8552                	mv	a0,s4
    80003cf8:	00000097          	auipc	ra,0x0
    80003cfc:	c9c080e7          	jalr	-868(ra) # 80003994 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003d00:	854a                	mv	a0,s2
    80003d02:	70a2                	ld	ra,40(sp)
    80003d04:	7402                	ld	s0,32(sp)
    80003d06:	64e2                	ld	s1,24(sp)
    80003d08:	6942                	ld	s2,16(sp)
    80003d0a:	69a2                	ld	s3,8(sp)
    80003d0c:	6a02                	ld	s4,0(sp)
    80003d0e:	6145                	addi	sp,sp,48
    80003d10:	8082                	ret
      addr = balloc(ip->dev);
    80003d12:	0009a503          	lw	a0,0(s3)
    80003d16:	00000097          	auipc	ra,0x0
    80003d1a:	e10080e7          	jalr	-496(ra) # 80003b26 <balloc>
    80003d1e:	0005091b          	sext.w	s2,a0
      if(addr){
    80003d22:	fc090ae3          	beqz	s2,80003cf6 <bmap+0x98>
        a[bn] = addr;
    80003d26:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003d2a:	8552                	mv	a0,s4
    80003d2c:	00001097          	auipc	ra,0x1
    80003d30:	eec080e7          	jalr	-276(ra) # 80004c18 <log_write>
    80003d34:	b7c9                	j	80003cf6 <bmap+0x98>
  panic("bmap: out of range");
    80003d36:	00004517          	auipc	a0,0x4
    80003d3a:	75a50513          	addi	a0,a0,1882 # 80008490 <etext+0x490>
    80003d3e:	ffffd097          	auipc	ra,0xffffd
    80003d42:	800080e7          	jalr	-2048(ra) # 8000053e <panic>

0000000080003d46 <iget>:
{
    80003d46:	7179                	addi	sp,sp,-48
    80003d48:	f406                	sd	ra,40(sp)
    80003d4a:	f022                	sd	s0,32(sp)
    80003d4c:	ec26                	sd	s1,24(sp)
    80003d4e:	e84a                	sd	s2,16(sp)
    80003d50:	e44e                	sd	s3,8(sp)
    80003d52:	e052                	sd	s4,0(sp)
    80003d54:	1800                	addi	s0,sp,48
    80003d56:	89aa                	mv	s3,a0
    80003d58:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003d5a:	0001f517          	auipc	a0,0x1f
    80003d5e:	b6e50513          	addi	a0,a0,-1170 # 800228c8 <itable>
    80003d62:	ffffd097          	auipc	ra,0xffffd
    80003d66:	e74080e7          	jalr	-396(ra) # 80000bd6 <acquire>
  empty = 0;
    80003d6a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003d6c:	0001f497          	auipc	s1,0x1f
    80003d70:	b7448493          	addi	s1,s1,-1164 # 800228e0 <itable+0x18>
    80003d74:	00020697          	auipc	a3,0x20
    80003d78:	5fc68693          	addi	a3,a3,1532 # 80024370 <log>
    80003d7c:	a039                	j	80003d8a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003d7e:	02090b63          	beqz	s2,80003db4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003d82:	08848493          	addi	s1,s1,136
    80003d86:	02d48a63          	beq	s1,a3,80003dba <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003d8a:	449c                	lw	a5,8(s1)
    80003d8c:	fef059e3          	blez	a5,80003d7e <iget+0x38>
    80003d90:	4098                	lw	a4,0(s1)
    80003d92:	ff3716e3          	bne	a4,s3,80003d7e <iget+0x38>
    80003d96:	40d8                	lw	a4,4(s1)
    80003d98:	ff4713e3          	bne	a4,s4,80003d7e <iget+0x38>
      ip->ref++;
    80003d9c:	2785                	addiw	a5,a5,1
    80003d9e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003da0:	0001f517          	auipc	a0,0x1f
    80003da4:	b2850513          	addi	a0,a0,-1240 # 800228c8 <itable>
    80003da8:	ffffd097          	auipc	ra,0xffffd
    80003dac:	ee2080e7          	jalr	-286(ra) # 80000c8a <release>
      return ip;
    80003db0:	8926                	mv	s2,s1
    80003db2:	a03d                	j	80003de0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003db4:	f7f9                	bnez	a5,80003d82 <iget+0x3c>
    80003db6:	8926                	mv	s2,s1
    80003db8:	b7e9                	j	80003d82 <iget+0x3c>
  if(empty == 0)
    80003dba:	02090c63          	beqz	s2,80003df2 <iget+0xac>
  ip->dev = dev;
    80003dbe:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003dc2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003dc6:	4785                	li	a5,1
    80003dc8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003dcc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003dd0:	0001f517          	auipc	a0,0x1f
    80003dd4:	af850513          	addi	a0,a0,-1288 # 800228c8 <itable>
    80003dd8:	ffffd097          	auipc	ra,0xffffd
    80003ddc:	eb2080e7          	jalr	-334(ra) # 80000c8a <release>
}
    80003de0:	854a                	mv	a0,s2
    80003de2:	70a2                	ld	ra,40(sp)
    80003de4:	7402                	ld	s0,32(sp)
    80003de6:	64e2                	ld	s1,24(sp)
    80003de8:	6942                	ld	s2,16(sp)
    80003dea:	69a2                	ld	s3,8(sp)
    80003dec:	6a02                	ld	s4,0(sp)
    80003dee:	6145                	addi	sp,sp,48
    80003df0:	8082                	ret
    panic("iget: no inodes");
    80003df2:	00004517          	auipc	a0,0x4
    80003df6:	6b650513          	addi	a0,a0,1718 # 800084a8 <etext+0x4a8>
    80003dfa:	ffffc097          	auipc	ra,0xffffc
    80003dfe:	744080e7          	jalr	1860(ra) # 8000053e <panic>

0000000080003e02 <fsinit>:
fsinit(int dev) {
    80003e02:	7179                	addi	sp,sp,-48
    80003e04:	f406                	sd	ra,40(sp)
    80003e06:	f022                	sd	s0,32(sp)
    80003e08:	ec26                	sd	s1,24(sp)
    80003e0a:	e84a                	sd	s2,16(sp)
    80003e0c:	e44e                	sd	s3,8(sp)
    80003e0e:	1800                	addi	s0,sp,48
    80003e10:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003e12:	4585                	li	a1,1
    80003e14:	00000097          	auipc	ra,0x0
    80003e18:	a50080e7          	jalr	-1456(ra) # 80003864 <bread>
    80003e1c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003e1e:	0001f997          	auipc	s3,0x1f
    80003e22:	a8a98993          	addi	s3,s3,-1398 # 800228a8 <sb>
    80003e26:	02000613          	li	a2,32
    80003e2a:	05850593          	addi	a1,a0,88
    80003e2e:	854e                	mv	a0,s3
    80003e30:	ffffd097          	auipc	ra,0xffffd
    80003e34:	efe080e7          	jalr	-258(ra) # 80000d2e <memmove>
  brelse(bp);
    80003e38:	8526                	mv	a0,s1
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	b5a080e7          	jalr	-1190(ra) # 80003994 <brelse>
  if(sb.magic != FSMAGIC)
    80003e42:	0009a703          	lw	a4,0(s3)
    80003e46:	102037b7          	lui	a5,0x10203
    80003e4a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003e4e:	02f71263          	bne	a4,a5,80003e72 <fsinit+0x70>
  initlog(dev, &sb);
    80003e52:	0001f597          	auipc	a1,0x1f
    80003e56:	a5658593          	addi	a1,a1,-1450 # 800228a8 <sb>
    80003e5a:	854a                	mv	a0,s2
    80003e5c:	00001097          	auipc	ra,0x1
    80003e60:	b40080e7          	jalr	-1216(ra) # 8000499c <initlog>
}
    80003e64:	70a2                	ld	ra,40(sp)
    80003e66:	7402                	ld	s0,32(sp)
    80003e68:	64e2                	ld	s1,24(sp)
    80003e6a:	6942                	ld	s2,16(sp)
    80003e6c:	69a2                	ld	s3,8(sp)
    80003e6e:	6145                	addi	sp,sp,48
    80003e70:	8082                	ret
    panic("invalid file system");
    80003e72:	00004517          	auipc	a0,0x4
    80003e76:	64650513          	addi	a0,a0,1606 # 800084b8 <etext+0x4b8>
    80003e7a:	ffffc097          	auipc	ra,0xffffc
    80003e7e:	6c4080e7          	jalr	1732(ra) # 8000053e <panic>

0000000080003e82 <iinit>:
{
    80003e82:	7179                	addi	sp,sp,-48
    80003e84:	f406                	sd	ra,40(sp)
    80003e86:	f022                	sd	s0,32(sp)
    80003e88:	ec26                	sd	s1,24(sp)
    80003e8a:	e84a                	sd	s2,16(sp)
    80003e8c:	e44e                	sd	s3,8(sp)
    80003e8e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003e90:	00004597          	auipc	a1,0x4
    80003e94:	64058593          	addi	a1,a1,1600 # 800084d0 <etext+0x4d0>
    80003e98:	0001f517          	auipc	a0,0x1f
    80003e9c:	a3050513          	addi	a0,a0,-1488 # 800228c8 <itable>
    80003ea0:	ffffd097          	auipc	ra,0xffffd
    80003ea4:	ca6080e7          	jalr	-858(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003ea8:	0001f497          	auipc	s1,0x1f
    80003eac:	a4848493          	addi	s1,s1,-1464 # 800228f0 <itable+0x28>
    80003eb0:	00020997          	auipc	s3,0x20
    80003eb4:	4d098993          	addi	s3,s3,1232 # 80024380 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003eb8:	00004917          	auipc	s2,0x4
    80003ebc:	62090913          	addi	s2,s2,1568 # 800084d8 <etext+0x4d8>
    80003ec0:	85ca                	mv	a1,s2
    80003ec2:	8526                	mv	a0,s1
    80003ec4:	00001097          	auipc	ra,0x1
    80003ec8:	e3a080e7          	jalr	-454(ra) # 80004cfe <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003ecc:	08848493          	addi	s1,s1,136
    80003ed0:	ff3498e3          	bne	s1,s3,80003ec0 <iinit+0x3e>
}
    80003ed4:	70a2                	ld	ra,40(sp)
    80003ed6:	7402                	ld	s0,32(sp)
    80003ed8:	64e2                	ld	s1,24(sp)
    80003eda:	6942                	ld	s2,16(sp)
    80003edc:	69a2                	ld	s3,8(sp)
    80003ede:	6145                	addi	sp,sp,48
    80003ee0:	8082                	ret

0000000080003ee2 <ialloc>:
{
    80003ee2:	715d                	addi	sp,sp,-80
    80003ee4:	e486                	sd	ra,72(sp)
    80003ee6:	e0a2                	sd	s0,64(sp)
    80003ee8:	fc26                	sd	s1,56(sp)
    80003eea:	f84a                	sd	s2,48(sp)
    80003eec:	f44e                	sd	s3,40(sp)
    80003eee:	f052                	sd	s4,32(sp)
    80003ef0:	ec56                	sd	s5,24(sp)
    80003ef2:	e85a                	sd	s6,16(sp)
    80003ef4:	e45e                	sd	s7,8(sp)
    80003ef6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ef8:	0001f717          	auipc	a4,0x1f
    80003efc:	9bc72703          	lw	a4,-1604(a4) # 800228b4 <sb+0xc>
    80003f00:	4785                	li	a5,1
    80003f02:	04e7fa63          	bgeu	a5,a4,80003f56 <ialloc+0x74>
    80003f06:	8aaa                	mv	s5,a0
    80003f08:	8bae                	mv	s7,a1
    80003f0a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003f0c:	0001fa17          	auipc	s4,0x1f
    80003f10:	99ca0a13          	addi	s4,s4,-1636 # 800228a8 <sb>
    80003f14:	00048b1b          	sext.w	s6,s1
    80003f18:	0044d793          	srli	a5,s1,0x4
    80003f1c:	018a2583          	lw	a1,24(s4)
    80003f20:	9dbd                	addw	a1,a1,a5
    80003f22:	8556                	mv	a0,s5
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	940080e7          	jalr	-1728(ra) # 80003864 <bread>
    80003f2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003f2e:	05850993          	addi	s3,a0,88
    80003f32:	00f4f793          	andi	a5,s1,15
    80003f36:	079a                	slli	a5,a5,0x6
    80003f38:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003f3a:	00099783          	lh	a5,0(s3)
    80003f3e:	c3a1                	beqz	a5,80003f7e <ialloc+0x9c>
    brelse(bp);
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	a54080e7          	jalr	-1452(ra) # 80003994 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003f48:	0485                	addi	s1,s1,1
    80003f4a:	00ca2703          	lw	a4,12(s4)
    80003f4e:	0004879b          	sext.w	a5,s1
    80003f52:	fce7e1e3          	bltu	a5,a4,80003f14 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003f56:	00004517          	auipc	a0,0x4
    80003f5a:	58a50513          	addi	a0,a0,1418 # 800084e0 <etext+0x4e0>
    80003f5e:	ffffc097          	auipc	ra,0xffffc
    80003f62:	62a080e7          	jalr	1578(ra) # 80000588 <printf>
  return 0;
    80003f66:	4501                	li	a0,0
}
    80003f68:	60a6                	ld	ra,72(sp)
    80003f6a:	6406                	ld	s0,64(sp)
    80003f6c:	74e2                	ld	s1,56(sp)
    80003f6e:	7942                	ld	s2,48(sp)
    80003f70:	79a2                	ld	s3,40(sp)
    80003f72:	7a02                	ld	s4,32(sp)
    80003f74:	6ae2                	ld	s5,24(sp)
    80003f76:	6b42                	ld	s6,16(sp)
    80003f78:	6ba2                	ld	s7,8(sp)
    80003f7a:	6161                	addi	sp,sp,80
    80003f7c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003f7e:	04000613          	li	a2,64
    80003f82:	4581                	li	a1,0
    80003f84:	854e                	mv	a0,s3
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	d4c080e7          	jalr	-692(ra) # 80000cd2 <memset>
      dip->type = type;
    80003f8e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003f92:	854a                	mv	a0,s2
    80003f94:	00001097          	auipc	ra,0x1
    80003f98:	c84080e7          	jalr	-892(ra) # 80004c18 <log_write>
      brelse(bp);
    80003f9c:	854a                	mv	a0,s2
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	9f6080e7          	jalr	-1546(ra) # 80003994 <brelse>
      return iget(dev, inum);
    80003fa6:	85da                	mv	a1,s6
    80003fa8:	8556                	mv	a0,s5
    80003faa:	00000097          	auipc	ra,0x0
    80003fae:	d9c080e7          	jalr	-612(ra) # 80003d46 <iget>
    80003fb2:	bf5d                	j	80003f68 <ialloc+0x86>

0000000080003fb4 <iupdate>:
{
    80003fb4:	1101                	addi	sp,sp,-32
    80003fb6:	ec06                	sd	ra,24(sp)
    80003fb8:	e822                	sd	s0,16(sp)
    80003fba:	e426                	sd	s1,8(sp)
    80003fbc:	e04a                	sd	s2,0(sp)
    80003fbe:	1000                	addi	s0,sp,32
    80003fc0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003fc2:	415c                	lw	a5,4(a0)
    80003fc4:	0047d79b          	srliw	a5,a5,0x4
    80003fc8:	0001f597          	auipc	a1,0x1f
    80003fcc:	8f85a583          	lw	a1,-1800(a1) # 800228c0 <sb+0x18>
    80003fd0:	9dbd                	addw	a1,a1,a5
    80003fd2:	4108                	lw	a0,0(a0)
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	890080e7          	jalr	-1904(ra) # 80003864 <bread>
    80003fdc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003fde:	05850793          	addi	a5,a0,88
    80003fe2:	40c8                	lw	a0,4(s1)
    80003fe4:	893d                	andi	a0,a0,15
    80003fe6:	051a                	slli	a0,a0,0x6
    80003fe8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003fea:	04449703          	lh	a4,68(s1)
    80003fee:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003ff2:	04649703          	lh	a4,70(s1)
    80003ff6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003ffa:	04849703          	lh	a4,72(s1)
    80003ffe:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80004002:	04a49703          	lh	a4,74(s1)
    80004006:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000400a:	44f8                	lw	a4,76(s1)
    8000400c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000400e:	03400613          	li	a2,52
    80004012:	05048593          	addi	a1,s1,80
    80004016:	0531                	addi	a0,a0,12
    80004018:	ffffd097          	auipc	ra,0xffffd
    8000401c:	d16080e7          	jalr	-746(ra) # 80000d2e <memmove>
  log_write(bp);
    80004020:	854a                	mv	a0,s2
    80004022:	00001097          	auipc	ra,0x1
    80004026:	bf6080e7          	jalr	-1034(ra) # 80004c18 <log_write>
  brelse(bp);
    8000402a:	854a                	mv	a0,s2
    8000402c:	00000097          	auipc	ra,0x0
    80004030:	968080e7          	jalr	-1688(ra) # 80003994 <brelse>
}
    80004034:	60e2                	ld	ra,24(sp)
    80004036:	6442                	ld	s0,16(sp)
    80004038:	64a2                	ld	s1,8(sp)
    8000403a:	6902                	ld	s2,0(sp)
    8000403c:	6105                	addi	sp,sp,32
    8000403e:	8082                	ret

0000000080004040 <idup>:
{
    80004040:	1101                	addi	sp,sp,-32
    80004042:	ec06                	sd	ra,24(sp)
    80004044:	e822                	sd	s0,16(sp)
    80004046:	e426                	sd	s1,8(sp)
    80004048:	1000                	addi	s0,sp,32
    8000404a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000404c:	0001f517          	auipc	a0,0x1f
    80004050:	87c50513          	addi	a0,a0,-1924 # 800228c8 <itable>
    80004054:	ffffd097          	auipc	ra,0xffffd
    80004058:	b82080e7          	jalr	-1150(ra) # 80000bd6 <acquire>
  ip->ref++;
    8000405c:	449c                	lw	a5,8(s1)
    8000405e:	2785                	addiw	a5,a5,1
    80004060:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004062:	0001f517          	auipc	a0,0x1f
    80004066:	86650513          	addi	a0,a0,-1946 # 800228c8 <itable>
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	c20080e7          	jalr	-992(ra) # 80000c8a <release>
}
    80004072:	8526                	mv	a0,s1
    80004074:	60e2                	ld	ra,24(sp)
    80004076:	6442                	ld	s0,16(sp)
    80004078:	64a2                	ld	s1,8(sp)
    8000407a:	6105                	addi	sp,sp,32
    8000407c:	8082                	ret

000000008000407e <ilock>:
{
    8000407e:	1101                	addi	sp,sp,-32
    80004080:	ec06                	sd	ra,24(sp)
    80004082:	e822                	sd	s0,16(sp)
    80004084:	e426                	sd	s1,8(sp)
    80004086:	e04a                	sd	s2,0(sp)
    80004088:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000408a:	c115                	beqz	a0,800040ae <ilock+0x30>
    8000408c:	84aa                	mv	s1,a0
    8000408e:	451c                	lw	a5,8(a0)
    80004090:	00f05f63          	blez	a5,800040ae <ilock+0x30>
  acquiresleep(&ip->lock);
    80004094:	0541                	addi	a0,a0,16
    80004096:	00001097          	auipc	ra,0x1
    8000409a:	ca2080e7          	jalr	-862(ra) # 80004d38 <acquiresleep>
  if(ip->valid == 0){
    8000409e:	40bc                	lw	a5,64(s1)
    800040a0:	cf99                	beqz	a5,800040be <ilock+0x40>
}
    800040a2:	60e2                	ld	ra,24(sp)
    800040a4:	6442                	ld	s0,16(sp)
    800040a6:	64a2                	ld	s1,8(sp)
    800040a8:	6902                	ld	s2,0(sp)
    800040aa:	6105                	addi	sp,sp,32
    800040ac:	8082                	ret
    panic("ilock");
    800040ae:	00004517          	auipc	a0,0x4
    800040b2:	44a50513          	addi	a0,a0,1098 # 800084f8 <etext+0x4f8>
    800040b6:	ffffc097          	auipc	ra,0xffffc
    800040ba:	488080e7          	jalr	1160(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800040be:	40dc                	lw	a5,4(s1)
    800040c0:	0047d79b          	srliw	a5,a5,0x4
    800040c4:	0001e597          	auipc	a1,0x1e
    800040c8:	7fc5a583          	lw	a1,2044(a1) # 800228c0 <sb+0x18>
    800040cc:	9dbd                	addw	a1,a1,a5
    800040ce:	4088                	lw	a0,0(s1)
    800040d0:	fffff097          	auipc	ra,0xfffff
    800040d4:	794080e7          	jalr	1940(ra) # 80003864 <bread>
    800040d8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800040da:	05850593          	addi	a1,a0,88
    800040de:	40dc                	lw	a5,4(s1)
    800040e0:	8bbd                	andi	a5,a5,15
    800040e2:	079a                	slli	a5,a5,0x6
    800040e4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800040e6:	00059783          	lh	a5,0(a1)
    800040ea:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800040ee:	00259783          	lh	a5,2(a1)
    800040f2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800040f6:	00459783          	lh	a5,4(a1)
    800040fa:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800040fe:	00659783          	lh	a5,6(a1)
    80004102:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004106:	459c                	lw	a5,8(a1)
    80004108:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000410a:	03400613          	li	a2,52
    8000410e:	05b1                	addi	a1,a1,12
    80004110:	05048513          	addi	a0,s1,80
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	c1a080e7          	jalr	-998(ra) # 80000d2e <memmove>
    brelse(bp);
    8000411c:	854a                	mv	a0,s2
    8000411e:	00000097          	auipc	ra,0x0
    80004122:	876080e7          	jalr	-1930(ra) # 80003994 <brelse>
    ip->valid = 1;
    80004126:	4785                	li	a5,1
    80004128:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000412a:	04449783          	lh	a5,68(s1)
    8000412e:	fbb5                	bnez	a5,800040a2 <ilock+0x24>
      panic("ilock: no type");
    80004130:	00004517          	auipc	a0,0x4
    80004134:	3d050513          	addi	a0,a0,976 # 80008500 <etext+0x500>
    80004138:	ffffc097          	auipc	ra,0xffffc
    8000413c:	406080e7          	jalr	1030(ra) # 8000053e <panic>

0000000080004140 <iunlock>:
{
    80004140:	1101                	addi	sp,sp,-32
    80004142:	ec06                	sd	ra,24(sp)
    80004144:	e822                	sd	s0,16(sp)
    80004146:	e426                	sd	s1,8(sp)
    80004148:	e04a                	sd	s2,0(sp)
    8000414a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000414c:	c905                	beqz	a0,8000417c <iunlock+0x3c>
    8000414e:	84aa                	mv	s1,a0
    80004150:	01050913          	addi	s2,a0,16
    80004154:	854a                	mv	a0,s2
    80004156:	00001097          	auipc	ra,0x1
    8000415a:	c7c080e7          	jalr	-900(ra) # 80004dd2 <holdingsleep>
    8000415e:	cd19                	beqz	a0,8000417c <iunlock+0x3c>
    80004160:	449c                	lw	a5,8(s1)
    80004162:	00f05d63          	blez	a5,8000417c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004166:	854a                	mv	a0,s2
    80004168:	00001097          	auipc	ra,0x1
    8000416c:	c26080e7          	jalr	-986(ra) # 80004d8e <releasesleep>
}
    80004170:	60e2                	ld	ra,24(sp)
    80004172:	6442                	ld	s0,16(sp)
    80004174:	64a2                	ld	s1,8(sp)
    80004176:	6902                	ld	s2,0(sp)
    80004178:	6105                	addi	sp,sp,32
    8000417a:	8082                	ret
    panic("iunlock");
    8000417c:	00004517          	auipc	a0,0x4
    80004180:	39450513          	addi	a0,a0,916 # 80008510 <etext+0x510>
    80004184:	ffffc097          	auipc	ra,0xffffc
    80004188:	3ba080e7          	jalr	954(ra) # 8000053e <panic>

000000008000418c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000418c:	7179                	addi	sp,sp,-48
    8000418e:	f406                	sd	ra,40(sp)
    80004190:	f022                	sd	s0,32(sp)
    80004192:	ec26                	sd	s1,24(sp)
    80004194:	e84a                	sd	s2,16(sp)
    80004196:	e44e                	sd	s3,8(sp)
    80004198:	e052                	sd	s4,0(sp)
    8000419a:	1800                	addi	s0,sp,48
    8000419c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000419e:	05050493          	addi	s1,a0,80
    800041a2:	08050913          	addi	s2,a0,128
    800041a6:	a021                	j	800041ae <itrunc+0x22>
    800041a8:	0491                	addi	s1,s1,4
    800041aa:	01248d63          	beq	s1,s2,800041c4 <itrunc+0x38>
    if(ip->addrs[i]){
    800041ae:	408c                	lw	a1,0(s1)
    800041b0:	dde5                	beqz	a1,800041a8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800041b2:	0009a503          	lw	a0,0(s3)
    800041b6:	00000097          	auipc	ra,0x0
    800041ba:	8f4080e7          	jalr	-1804(ra) # 80003aaa <bfree>
      ip->addrs[i] = 0;
    800041be:	0004a023          	sw	zero,0(s1)
    800041c2:	b7dd                	j	800041a8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800041c4:	0809a583          	lw	a1,128(s3)
    800041c8:	e185                	bnez	a1,800041e8 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800041ca:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800041ce:	854e                	mv	a0,s3
    800041d0:	00000097          	auipc	ra,0x0
    800041d4:	de4080e7          	jalr	-540(ra) # 80003fb4 <iupdate>
}
    800041d8:	70a2                	ld	ra,40(sp)
    800041da:	7402                	ld	s0,32(sp)
    800041dc:	64e2                	ld	s1,24(sp)
    800041de:	6942                	ld	s2,16(sp)
    800041e0:	69a2                	ld	s3,8(sp)
    800041e2:	6a02                	ld	s4,0(sp)
    800041e4:	6145                	addi	sp,sp,48
    800041e6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800041e8:	0009a503          	lw	a0,0(s3)
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	678080e7          	jalr	1656(ra) # 80003864 <bread>
    800041f4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800041f6:	05850493          	addi	s1,a0,88
    800041fa:	45850913          	addi	s2,a0,1112
    800041fe:	a021                	j	80004206 <itrunc+0x7a>
    80004200:	0491                	addi	s1,s1,4
    80004202:	01248b63          	beq	s1,s2,80004218 <itrunc+0x8c>
      if(a[j])
    80004206:	408c                	lw	a1,0(s1)
    80004208:	dde5                	beqz	a1,80004200 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000420a:	0009a503          	lw	a0,0(s3)
    8000420e:	00000097          	auipc	ra,0x0
    80004212:	89c080e7          	jalr	-1892(ra) # 80003aaa <bfree>
    80004216:	b7ed                	j	80004200 <itrunc+0x74>
    brelse(bp);
    80004218:	8552                	mv	a0,s4
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	77a080e7          	jalr	1914(ra) # 80003994 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004222:	0809a583          	lw	a1,128(s3)
    80004226:	0009a503          	lw	a0,0(s3)
    8000422a:	00000097          	auipc	ra,0x0
    8000422e:	880080e7          	jalr	-1920(ra) # 80003aaa <bfree>
    ip->addrs[NDIRECT] = 0;
    80004232:	0809a023          	sw	zero,128(s3)
    80004236:	bf51                	j	800041ca <itrunc+0x3e>

0000000080004238 <iput>:
{
    80004238:	1101                	addi	sp,sp,-32
    8000423a:	ec06                	sd	ra,24(sp)
    8000423c:	e822                	sd	s0,16(sp)
    8000423e:	e426                	sd	s1,8(sp)
    80004240:	e04a                	sd	s2,0(sp)
    80004242:	1000                	addi	s0,sp,32
    80004244:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004246:	0001e517          	auipc	a0,0x1e
    8000424a:	68250513          	addi	a0,a0,1666 # 800228c8 <itable>
    8000424e:	ffffd097          	auipc	ra,0xffffd
    80004252:	988080e7          	jalr	-1656(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004256:	4498                	lw	a4,8(s1)
    80004258:	4785                	li	a5,1
    8000425a:	02f70363          	beq	a4,a5,80004280 <iput+0x48>
  ip->ref--;
    8000425e:	449c                	lw	a5,8(s1)
    80004260:	37fd                	addiw	a5,a5,-1
    80004262:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004264:	0001e517          	auipc	a0,0x1e
    80004268:	66450513          	addi	a0,a0,1636 # 800228c8 <itable>
    8000426c:	ffffd097          	auipc	ra,0xffffd
    80004270:	a1e080e7          	jalr	-1506(ra) # 80000c8a <release>
}
    80004274:	60e2                	ld	ra,24(sp)
    80004276:	6442                	ld	s0,16(sp)
    80004278:	64a2                	ld	s1,8(sp)
    8000427a:	6902                	ld	s2,0(sp)
    8000427c:	6105                	addi	sp,sp,32
    8000427e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004280:	40bc                	lw	a5,64(s1)
    80004282:	dff1                	beqz	a5,8000425e <iput+0x26>
    80004284:	04a49783          	lh	a5,74(s1)
    80004288:	fbf9                	bnez	a5,8000425e <iput+0x26>
    acquiresleep(&ip->lock);
    8000428a:	01048913          	addi	s2,s1,16
    8000428e:	854a                	mv	a0,s2
    80004290:	00001097          	auipc	ra,0x1
    80004294:	aa8080e7          	jalr	-1368(ra) # 80004d38 <acquiresleep>
    release(&itable.lock);
    80004298:	0001e517          	auipc	a0,0x1e
    8000429c:	63050513          	addi	a0,a0,1584 # 800228c8 <itable>
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	9ea080e7          	jalr	-1558(ra) # 80000c8a <release>
    itrunc(ip);
    800042a8:	8526                	mv	a0,s1
    800042aa:	00000097          	auipc	ra,0x0
    800042ae:	ee2080e7          	jalr	-286(ra) # 8000418c <itrunc>
    ip->type = 0;
    800042b2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800042b6:	8526                	mv	a0,s1
    800042b8:	00000097          	auipc	ra,0x0
    800042bc:	cfc080e7          	jalr	-772(ra) # 80003fb4 <iupdate>
    ip->valid = 0;
    800042c0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800042c4:	854a                	mv	a0,s2
    800042c6:	00001097          	auipc	ra,0x1
    800042ca:	ac8080e7          	jalr	-1336(ra) # 80004d8e <releasesleep>
    acquire(&itable.lock);
    800042ce:	0001e517          	auipc	a0,0x1e
    800042d2:	5fa50513          	addi	a0,a0,1530 # 800228c8 <itable>
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	900080e7          	jalr	-1792(ra) # 80000bd6 <acquire>
    800042de:	b741                	j	8000425e <iput+0x26>

00000000800042e0 <iunlockput>:
{
    800042e0:	1101                	addi	sp,sp,-32
    800042e2:	ec06                	sd	ra,24(sp)
    800042e4:	e822                	sd	s0,16(sp)
    800042e6:	e426                	sd	s1,8(sp)
    800042e8:	1000                	addi	s0,sp,32
    800042ea:	84aa                	mv	s1,a0
  iunlock(ip);
    800042ec:	00000097          	auipc	ra,0x0
    800042f0:	e54080e7          	jalr	-428(ra) # 80004140 <iunlock>
  iput(ip);
    800042f4:	8526                	mv	a0,s1
    800042f6:	00000097          	auipc	ra,0x0
    800042fa:	f42080e7          	jalr	-190(ra) # 80004238 <iput>
}
    800042fe:	60e2                	ld	ra,24(sp)
    80004300:	6442                	ld	s0,16(sp)
    80004302:	64a2                	ld	s1,8(sp)
    80004304:	6105                	addi	sp,sp,32
    80004306:	8082                	ret

0000000080004308 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004308:	1141                	addi	sp,sp,-16
    8000430a:	e422                	sd	s0,8(sp)
    8000430c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000430e:	411c                	lw	a5,0(a0)
    80004310:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004312:	415c                	lw	a5,4(a0)
    80004314:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004316:	04451783          	lh	a5,68(a0)
    8000431a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000431e:	04a51783          	lh	a5,74(a0)
    80004322:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004326:	04c56783          	lwu	a5,76(a0)
    8000432a:	e99c                	sd	a5,16(a1)
}
    8000432c:	6422                	ld	s0,8(sp)
    8000432e:	0141                	addi	sp,sp,16
    80004330:	8082                	ret

0000000080004332 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004332:	457c                	lw	a5,76(a0)
    80004334:	0ed7e963          	bltu	a5,a3,80004426 <readi+0xf4>
{
    80004338:	7159                	addi	sp,sp,-112
    8000433a:	f486                	sd	ra,104(sp)
    8000433c:	f0a2                	sd	s0,96(sp)
    8000433e:	eca6                	sd	s1,88(sp)
    80004340:	e8ca                	sd	s2,80(sp)
    80004342:	e4ce                	sd	s3,72(sp)
    80004344:	e0d2                	sd	s4,64(sp)
    80004346:	fc56                	sd	s5,56(sp)
    80004348:	f85a                	sd	s6,48(sp)
    8000434a:	f45e                	sd	s7,40(sp)
    8000434c:	f062                	sd	s8,32(sp)
    8000434e:	ec66                	sd	s9,24(sp)
    80004350:	e86a                	sd	s10,16(sp)
    80004352:	e46e                	sd	s11,8(sp)
    80004354:	1880                	addi	s0,sp,112
    80004356:	8b2a                	mv	s6,a0
    80004358:	8bae                	mv	s7,a1
    8000435a:	8a32                	mv	s4,a2
    8000435c:	84b6                	mv	s1,a3
    8000435e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004360:	9f35                	addw	a4,a4,a3
    return 0;
    80004362:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004364:	0ad76063          	bltu	a4,a3,80004404 <readi+0xd2>
  if(off + n > ip->size)
    80004368:	00e7f463          	bgeu	a5,a4,80004370 <readi+0x3e>
    n = ip->size - off;
    8000436c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004370:	0a0a8963          	beqz	s5,80004422 <readi+0xf0>
    80004374:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004376:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000437a:	5c7d                	li	s8,-1
    8000437c:	a82d                	j	800043b6 <readi+0x84>
    8000437e:	020d1d93          	slli	s11,s10,0x20
    80004382:	020ddd93          	srli	s11,s11,0x20
    80004386:	05890793          	addi	a5,s2,88
    8000438a:	86ee                	mv	a3,s11
    8000438c:	963e                	add	a2,a2,a5
    8000438e:	85d2                	mv	a1,s4
    80004390:	855e                	mv	a0,s7
    80004392:	ffffe097          	auipc	ra,0xffffe
    80004396:	594080e7          	jalr	1428(ra) # 80002926 <either_copyout>
    8000439a:	05850d63          	beq	a0,s8,800043f4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000439e:	854a                	mv	a0,s2
    800043a0:	fffff097          	auipc	ra,0xfffff
    800043a4:	5f4080e7          	jalr	1524(ra) # 80003994 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800043a8:	013d09bb          	addw	s3,s10,s3
    800043ac:	009d04bb          	addw	s1,s10,s1
    800043b0:	9a6e                	add	s4,s4,s11
    800043b2:	0559f763          	bgeu	s3,s5,80004400 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800043b6:	00a4d59b          	srliw	a1,s1,0xa
    800043ba:	855a                	mv	a0,s6
    800043bc:	00000097          	auipc	ra,0x0
    800043c0:	8a2080e7          	jalr	-1886(ra) # 80003c5e <bmap>
    800043c4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800043c8:	cd85                	beqz	a1,80004400 <readi+0xce>
    bp = bread(ip->dev, addr);
    800043ca:	000b2503          	lw	a0,0(s6)
    800043ce:	fffff097          	auipc	ra,0xfffff
    800043d2:	496080e7          	jalr	1174(ra) # 80003864 <bread>
    800043d6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800043d8:	3ff4f613          	andi	a2,s1,1023
    800043dc:	40cc87bb          	subw	a5,s9,a2
    800043e0:	413a873b          	subw	a4,s5,s3
    800043e4:	8d3e                	mv	s10,a5
    800043e6:	2781                	sext.w	a5,a5
    800043e8:	0007069b          	sext.w	a3,a4
    800043ec:	f8f6f9e3          	bgeu	a3,a5,8000437e <readi+0x4c>
    800043f0:	8d3a                	mv	s10,a4
    800043f2:	b771                	j	8000437e <readi+0x4c>
      brelse(bp);
    800043f4:	854a                	mv	a0,s2
    800043f6:	fffff097          	auipc	ra,0xfffff
    800043fa:	59e080e7          	jalr	1438(ra) # 80003994 <brelse>
      tot = -1;
    800043fe:	59fd                	li	s3,-1
  }
  return tot;
    80004400:	0009851b          	sext.w	a0,s3
}
    80004404:	70a6                	ld	ra,104(sp)
    80004406:	7406                	ld	s0,96(sp)
    80004408:	64e6                	ld	s1,88(sp)
    8000440a:	6946                	ld	s2,80(sp)
    8000440c:	69a6                	ld	s3,72(sp)
    8000440e:	6a06                	ld	s4,64(sp)
    80004410:	7ae2                	ld	s5,56(sp)
    80004412:	7b42                	ld	s6,48(sp)
    80004414:	7ba2                	ld	s7,40(sp)
    80004416:	7c02                	ld	s8,32(sp)
    80004418:	6ce2                	ld	s9,24(sp)
    8000441a:	6d42                	ld	s10,16(sp)
    8000441c:	6da2                	ld	s11,8(sp)
    8000441e:	6165                	addi	sp,sp,112
    80004420:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004422:	89d6                	mv	s3,s5
    80004424:	bff1                	j	80004400 <readi+0xce>
    return 0;
    80004426:	4501                	li	a0,0
}
    80004428:	8082                	ret

000000008000442a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000442a:	457c                	lw	a5,76(a0)
    8000442c:	10d7e863          	bltu	a5,a3,8000453c <writei+0x112>
{
    80004430:	7159                	addi	sp,sp,-112
    80004432:	f486                	sd	ra,104(sp)
    80004434:	f0a2                	sd	s0,96(sp)
    80004436:	eca6                	sd	s1,88(sp)
    80004438:	e8ca                	sd	s2,80(sp)
    8000443a:	e4ce                	sd	s3,72(sp)
    8000443c:	e0d2                	sd	s4,64(sp)
    8000443e:	fc56                	sd	s5,56(sp)
    80004440:	f85a                	sd	s6,48(sp)
    80004442:	f45e                	sd	s7,40(sp)
    80004444:	f062                	sd	s8,32(sp)
    80004446:	ec66                	sd	s9,24(sp)
    80004448:	e86a                	sd	s10,16(sp)
    8000444a:	e46e                	sd	s11,8(sp)
    8000444c:	1880                	addi	s0,sp,112
    8000444e:	8aaa                	mv	s5,a0
    80004450:	8bae                	mv	s7,a1
    80004452:	8a32                	mv	s4,a2
    80004454:	8936                	mv	s2,a3
    80004456:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004458:	00e687bb          	addw	a5,a3,a4
    8000445c:	0ed7e263          	bltu	a5,a3,80004540 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004460:	00043737          	lui	a4,0x43
    80004464:	0ef76063          	bltu	a4,a5,80004544 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004468:	0c0b0863          	beqz	s6,80004538 <writei+0x10e>
    8000446c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000446e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004472:	5c7d                	li	s8,-1
    80004474:	a091                	j	800044b8 <writei+0x8e>
    80004476:	020d1d93          	slli	s11,s10,0x20
    8000447a:	020ddd93          	srli	s11,s11,0x20
    8000447e:	05848793          	addi	a5,s1,88
    80004482:	86ee                	mv	a3,s11
    80004484:	8652                	mv	a2,s4
    80004486:	85de                	mv	a1,s7
    80004488:	953e                	add	a0,a0,a5
    8000448a:	ffffe097          	auipc	ra,0xffffe
    8000448e:	4f2080e7          	jalr	1266(ra) # 8000297c <either_copyin>
    80004492:	07850263          	beq	a0,s8,800044f6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004496:	8526                	mv	a0,s1
    80004498:	00000097          	auipc	ra,0x0
    8000449c:	780080e7          	jalr	1920(ra) # 80004c18 <log_write>
    brelse(bp);
    800044a0:	8526                	mv	a0,s1
    800044a2:	fffff097          	auipc	ra,0xfffff
    800044a6:	4f2080e7          	jalr	1266(ra) # 80003994 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800044aa:	013d09bb          	addw	s3,s10,s3
    800044ae:	012d093b          	addw	s2,s10,s2
    800044b2:	9a6e                	add	s4,s4,s11
    800044b4:	0569f663          	bgeu	s3,s6,80004500 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800044b8:	00a9559b          	srliw	a1,s2,0xa
    800044bc:	8556                	mv	a0,s5
    800044be:	fffff097          	auipc	ra,0xfffff
    800044c2:	7a0080e7          	jalr	1952(ra) # 80003c5e <bmap>
    800044c6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800044ca:	c99d                	beqz	a1,80004500 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800044cc:	000aa503          	lw	a0,0(s5)
    800044d0:	fffff097          	auipc	ra,0xfffff
    800044d4:	394080e7          	jalr	916(ra) # 80003864 <bread>
    800044d8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800044da:	3ff97513          	andi	a0,s2,1023
    800044de:	40ac87bb          	subw	a5,s9,a0
    800044e2:	413b073b          	subw	a4,s6,s3
    800044e6:	8d3e                	mv	s10,a5
    800044e8:	2781                	sext.w	a5,a5
    800044ea:	0007069b          	sext.w	a3,a4
    800044ee:	f8f6f4e3          	bgeu	a3,a5,80004476 <writei+0x4c>
    800044f2:	8d3a                	mv	s10,a4
    800044f4:	b749                	j	80004476 <writei+0x4c>
      brelse(bp);
    800044f6:	8526                	mv	a0,s1
    800044f8:	fffff097          	auipc	ra,0xfffff
    800044fc:	49c080e7          	jalr	1180(ra) # 80003994 <brelse>
  }

  if(off > ip->size)
    80004500:	04caa783          	lw	a5,76(s5)
    80004504:	0127f463          	bgeu	a5,s2,8000450c <writei+0xe2>
    ip->size = off;
    80004508:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000450c:	8556                	mv	a0,s5
    8000450e:	00000097          	auipc	ra,0x0
    80004512:	aa6080e7          	jalr	-1370(ra) # 80003fb4 <iupdate>

  return tot;
    80004516:	0009851b          	sext.w	a0,s3
}
    8000451a:	70a6                	ld	ra,104(sp)
    8000451c:	7406                	ld	s0,96(sp)
    8000451e:	64e6                	ld	s1,88(sp)
    80004520:	6946                	ld	s2,80(sp)
    80004522:	69a6                	ld	s3,72(sp)
    80004524:	6a06                	ld	s4,64(sp)
    80004526:	7ae2                	ld	s5,56(sp)
    80004528:	7b42                	ld	s6,48(sp)
    8000452a:	7ba2                	ld	s7,40(sp)
    8000452c:	7c02                	ld	s8,32(sp)
    8000452e:	6ce2                	ld	s9,24(sp)
    80004530:	6d42                	ld	s10,16(sp)
    80004532:	6da2                	ld	s11,8(sp)
    80004534:	6165                	addi	sp,sp,112
    80004536:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004538:	89da                	mv	s3,s6
    8000453a:	bfc9                	j	8000450c <writei+0xe2>
    return -1;
    8000453c:	557d                	li	a0,-1
}
    8000453e:	8082                	ret
    return -1;
    80004540:	557d                	li	a0,-1
    80004542:	bfe1                	j	8000451a <writei+0xf0>
    return -1;
    80004544:	557d                	li	a0,-1
    80004546:	bfd1                	j	8000451a <writei+0xf0>

0000000080004548 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004548:	1141                	addi	sp,sp,-16
    8000454a:	e406                	sd	ra,8(sp)
    8000454c:	e022                	sd	s0,0(sp)
    8000454e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004550:	4639                	li	a2,14
    80004552:	ffffd097          	auipc	ra,0xffffd
    80004556:	850080e7          	jalr	-1968(ra) # 80000da2 <strncmp>
}
    8000455a:	60a2                	ld	ra,8(sp)
    8000455c:	6402                	ld	s0,0(sp)
    8000455e:	0141                	addi	sp,sp,16
    80004560:	8082                	ret

0000000080004562 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004562:	7139                	addi	sp,sp,-64
    80004564:	fc06                	sd	ra,56(sp)
    80004566:	f822                	sd	s0,48(sp)
    80004568:	f426                	sd	s1,40(sp)
    8000456a:	f04a                	sd	s2,32(sp)
    8000456c:	ec4e                	sd	s3,24(sp)
    8000456e:	e852                	sd	s4,16(sp)
    80004570:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004572:	04451703          	lh	a4,68(a0)
    80004576:	4785                	li	a5,1
    80004578:	00f71a63          	bne	a4,a5,8000458c <dirlookup+0x2a>
    8000457c:	892a                	mv	s2,a0
    8000457e:	89ae                	mv	s3,a1
    80004580:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004582:	457c                	lw	a5,76(a0)
    80004584:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004586:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004588:	e79d                	bnez	a5,800045b6 <dirlookup+0x54>
    8000458a:	a8a5                	j	80004602 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000458c:	00004517          	auipc	a0,0x4
    80004590:	f8c50513          	addi	a0,a0,-116 # 80008518 <etext+0x518>
    80004594:	ffffc097          	auipc	ra,0xffffc
    80004598:	faa080e7          	jalr	-86(ra) # 8000053e <panic>
      panic("dirlookup read");
    8000459c:	00004517          	auipc	a0,0x4
    800045a0:	f9450513          	addi	a0,a0,-108 # 80008530 <etext+0x530>
    800045a4:	ffffc097          	auipc	ra,0xffffc
    800045a8:	f9a080e7          	jalr	-102(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045ac:	24c1                	addiw	s1,s1,16
    800045ae:	04c92783          	lw	a5,76(s2)
    800045b2:	04f4f763          	bgeu	s1,a5,80004600 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045b6:	4741                	li	a4,16
    800045b8:	86a6                	mv	a3,s1
    800045ba:	fc040613          	addi	a2,s0,-64
    800045be:	4581                	li	a1,0
    800045c0:	854a                	mv	a0,s2
    800045c2:	00000097          	auipc	ra,0x0
    800045c6:	d70080e7          	jalr	-656(ra) # 80004332 <readi>
    800045ca:	47c1                	li	a5,16
    800045cc:	fcf518e3          	bne	a0,a5,8000459c <dirlookup+0x3a>
    if(de.inum == 0)
    800045d0:	fc045783          	lhu	a5,-64(s0)
    800045d4:	dfe1                	beqz	a5,800045ac <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800045d6:	fc240593          	addi	a1,s0,-62
    800045da:	854e                	mv	a0,s3
    800045dc:	00000097          	auipc	ra,0x0
    800045e0:	f6c080e7          	jalr	-148(ra) # 80004548 <namecmp>
    800045e4:	f561                	bnez	a0,800045ac <dirlookup+0x4a>
      if(poff)
    800045e6:	000a0463          	beqz	s4,800045ee <dirlookup+0x8c>
        *poff = off;
    800045ea:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800045ee:	fc045583          	lhu	a1,-64(s0)
    800045f2:	00092503          	lw	a0,0(s2)
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	750080e7          	jalr	1872(ra) # 80003d46 <iget>
    800045fe:	a011                	j	80004602 <dirlookup+0xa0>
  return 0;
    80004600:	4501                	li	a0,0
}
    80004602:	70e2                	ld	ra,56(sp)
    80004604:	7442                	ld	s0,48(sp)
    80004606:	74a2                	ld	s1,40(sp)
    80004608:	7902                	ld	s2,32(sp)
    8000460a:	69e2                	ld	s3,24(sp)
    8000460c:	6a42                	ld	s4,16(sp)
    8000460e:	6121                	addi	sp,sp,64
    80004610:	8082                	ret

0000000080004612 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004612:	711d                	addi	sp,sp,-96
    80004614:	ec86                	sd	ra,88(sp)
    80004616:	e8a2                	sd	s0,80(sp)
    80004618:	e4a6                	sd	s1,72(sp)
    8000461a:	e0ca                	sd	s2,64(sp)
    8000461c:	fc4e                	sd	s3,56(sp)
    8000461e:	f852                	sd	s4,48(sp)
    80004620:	f456                	sd	s5,40(sp)
    80004622:	f05a                	sd	s6,32(sp)
    80004624:	ec5e                	sd	s7,24(sp)
    80004626:	e862                	sd	s8,16(sp)
    80004628:	e466                	sd	s9,8(sp)
    8000462a:	1080                	addi	s0,sp,96
    8000462c:	84aa                	mv	s1,a0
    8000462e:	8aae                	mv	s5,a1
    80004630:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004632:	00054703          	lbu	a4,0(a0)
    80004636:	02f00793          	li	a5,47
    8000463a:	02f70363          	beq	a4,a5,80004660 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000463e:	ffffd097          	auipc	ra,0xffffd
    80004642:	3a2080e7          	jalr	930(ra) # 800019e0 <myproc>
    80004646:	15053503          	ld	a0,336(a0)
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	9f6080e7          	jalr	-1546(ra) # 80004040 <idup>
    80004652:	89aa                	mv	s3,a0
  while(*path == '/')
    80004654:	02f00913          	li	s2,47
  len = path - s;
    80004658:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    8000465a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000465c:	4b85                	li	s7,1
    8000465e:	a865                	j	80004716 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004660:	4585                	li	a1,1
    80004662:	4505                	li	a0,1
    80004664:	fffff097          	auipc	ra,0xfffff
    80004668:	6e2080e7          	jalr	1762(ra) # 80003d46 <iget>
    8000466c:	89aa                	mv	s3,a0
    8000466e:	b7dd                	j	80004654 <namex+0x42>
      iunlockput(ip);
    80004670:	854e                	mv	a0,s3
    80004672:	00000097          	auipc	ra,0x0
    80004676:	c6e080e7          	jalr	-914(ra) # 800042e0 <iunlockput>
      return 0;
    8000467a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000467c:	854e                	mv	a0,s3
    8000467e:	60e6                	ld	ra,88(sp)
    80004680:	6446                	ld	s0,80(sp)
    80004682:	64a6                	ld	s1,72(sp)
    80004684:	6906                	ld	s2,64(sp)
    80004686:	79e2                	ld	s3,56(sp)
    80004688:	7a42                	ld	s4,48(sp)
    8000468a:	7aa2                	ld	s5,40(sp)
    8000468c:	7b02                	ld	s6,32(sp)
    8000468e:	6be2                	ld	s7,24(sp)
    80004690:	6c42                	ld	s8,16(sp)
    80004692:	6ca2                	ld	s9,8(sp)
    80004694:	6125                	addi	sp,sp,96
    80004696:	8082                	ret
      iunlock(ip);
    80004698:	854e                	mv	a0,s3
    8000469a:	00000097          	auipc	ra,0x0
    8000469e:	aa6080e7          	jalr	-1370(ra) # 80004140 <iunlock>
      return ip;
    800046a2:	bfe9                	j	8000467c <namex+0x6a>
      iunlockput(ip);
    800046a4:	854e                	mv	a0,s3
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	c3a080e7          	jalr	-966(ra) # 800042e0 <iunlockput>
      return 0;
    800046ae:	89e6                	mv	s3,s9
    800046b0:	b7f1                	j	8000467c <namex+0x6a>
  len = path - s;
    800046b2:	40b48633          	sub	a2,s1,a1
    800046b6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800046ba:	099c5463          	bge	s8,s9,80004742 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800046be:	4639                	li	a2,14
    800046c0:	8552                	mv	a0,s4
    800046c2:	ffffc097          	auipc	ra,0xffffc
    800046c6:	66c080e7          	jalr	1644(ra) # 80000d2e <memmove>
  while(*path == '/')
    800046ca:	0004c783          	lbu	a5,0(s1)
    800046ce:	01279763          	bne	a5,s2,800046dc <namex+0xca>
    path++;
    800046d2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800046d4:	0004c783          	lbu	a5,0(s1)
    800046d8:	ff278de3          	beq	a5,s2,800046d2 <namex+0xc0>
    ilock(ip);
    800046dc:	854e                	mv	a0,s3
    800046de:	00000097          	auipc	ra,0x0
    800046e2:	9a0080e7          	jalr	-1632(ra) # 8000407e <ilock>
    if(ip->type != T_DIR){
    800046e6:	04499783          	lh	a5,68(s3)
    800046ea:	f97793e3          	bne	a5,s7,80004670 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800046ee:	000a8563          	beqz	s5,800046f8 <namex+0xe6>
    800046f2:	0004c783          	lbu	a5,0(s1)
    800046f6:	d3cd                	beqz	a5,80004698 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800046f8:	865a                	mv	a2,s6
    800046fa:	85d2                	mv	a1,s4
    800046fc:	854e                	mv	a0,s3
    800046fe:	00000097          	auipc	ra,0x0
    80004702:	e64080e7          	jalr	-412(ra) # 80004562 <dirlookup>
    80004706:	8caa                	mv	s9,a0
    80004708:	dd51                	beqz	a0,800046a4 <namex+0x92>
    iunlockput(ip);
    8000470a:	854e                	mv	a0,s3
    8000470c:	00000097          	auipc	ra,0x0
    80004710:	bd4080e7          	jalr	-1068(ra) # 800042e0 <iunlockput>
    ip = next;
    80004714:	89e6                	mv	s3,s9
  while(*path == '/')
    80004716:	0004c783          	lbu	a5,0(s1)
    8000471a:	05279763          	bne	a5,s2,80004768 <namex+0x156>
    path++;
    8000471e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004720:	0004c783          	lbu	a5,0(s1)
    80004724:	ff278de3          	beq	a5,s2,8000471e <namex+0x10c>
  if(*path == 0)
    80004728:	c79d                	beqz	a5,80004756 <namex+0x144>
    path++;
    8000472a:	85a6                	mv	a1,s1
  len = path - s;
    8000472c:	8cda                	mv	s9,s6
    8000472e:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004730:	01278963          	beq	a5,s2,80004742 <namex+0x130>
    80004734:	dfbd                	beqz	a5,800046b2 <namex+0xa0>
    path++;
    80004736:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004738:	0004c783          	lbu	a5,0(s1)
    8000473c:	ff279ce3          	bne	a5,s2,80004734 <namex+0x122>
    80004740:	bf8d                	j	800046b2 <namex+0xa0>
    memmove(name, s, len);
    80004742:	2601                	sext.w	a2,a2
    80004744:	8552                	mv	a0,s4
    80004746:	ffffc097          	auipc	ra,0xffffc
    8000474a:	5e8080e7          	jalr	1512(ra) # 80000d2e <memmove>
    name[len] = 0;
    8000474e:	9cd2                	add	s9,s9,s4
    80004750:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004754:	bf9d                	j	800046ca <namex+0xb8>
  if(nameiparent){
    80004756:	f20a83e3          	beqz	s5,8000467c <namex+0x6a>
    iput(ip);
    8000475a:	854e                	mv	a0,s3
    8000475c:	00000097          	auipc	ra,0x0
    80004760:	adc080e7          	jalr	-1316(ra) # 80004238 <iput>
    return 0;
    80004764:	4981                	li	s3,0
    80004766:	bf19                	j	8000467c <namex+0x6a>
  if(*path == 0)
    80004768:	d7fd                	beqz	a5,80004756 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000476a:	0004c783          	lbu	a5,0(s1)
    8000476e:	85a6                	mv	a1,s1
    80004770:	b7d1                	j	80004734 <namex+0x122>

0000000080004772 <dirlink>:
{
    80004772:	7139                	addi	sp,sp,-64
    80004774:	fc06                	sd	ra,56(sp)
    80004776:	f822                	sd	s0,48(sp)
    80004778:	f426                	sd	s1,40(sp)
    8000477a:	f04a                	sd	s2,32(sp)
    8000477c:	ec4e                	sd	s3,24(sp)
    8000477e:	e852                	sd	s4,16(sp)
    80004780:	0080                	addi	s0,sp,64
    80004782:	892a                	mv	s2,a0
    80004784:	8a2e                	mv	s4,a1
    80004786:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004788:	4601                	li	a2,0
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	dd8080e7          	jalr	-552(ra) # 80004562 <dirlookup>
    80004792:	e93d                	bnez	a0,80004808 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004794:	04c92483          	lw	s1,76(s2)
    80004798:	c49d                	beqz	s1,800047c6 <dirlink+0x54>
    8000479a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000479c:	4741                	li	a4,16
    8000479e:	86a6                	mv	a3,s1
    800047a0:	fc040613          	addi	a2,s0,-64
    800047a4:	4581                	li	a1,0
    800047a6:	854a                	mv	a0,s2
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	b8a080e7          	jalr	-1142(ra) # 80004332 <readi>
    800047b0:	47c1                	li	a5,16
    800047b2:	06f51163          	bne	a0,a5,80004814 <dirlink+0xa2>
    if(de.inum == 0)
    800047b6:	fc045783          	lhu	a5,-64(s0)
    800047ba:	c791                	beqz	a5,800047c6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800047bc:	24c1                	addiw	s1,s1,16
    800047be:	04c92783          	lw	a5,76(s2)
    800047c2:	fcf4ede3          	bltu	s1,a5,8000479c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800047c6:	4639                	li	a2,14
    800047c8:	85d2                	mv	a1,s4
    800047ca:	fc240513          	addi	a0,s0,-62
    800047ce:	ffffc097          	auipc	ra,0xffffc
    800047d2:	610080e7          	jalr	1552(ra) # 80000dde <strncpy>
  de.inum = inum;
    800047d6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800047da:	4741                	li	a4,16
    800047dc:	86a6                	mv	a3,s1
    800047de:	fc040613          	addi	a2,s0,-64
    800047e2:	4581                	li	a1,0
    800047e4:	854a                	mv	a0,s2
    800047e6:	00000097          	auipc	ra,0x0
    800047ea:	c44080e7          	jalr	-956(ra) # 8000442a <writei>
    800047ee:	1541                	addi	a0,a0,-16
    800047f0:	00a03533          	snez	a0,a0
    800047f4:	40a00533          	neg	a0,a0
}
    800047f8:	70e2                	ld	ra,56(sp)
    800047fa:	7442                	ld	s0,48(sp)
    800047fc:	74a2                	ld	s1,40(sp)
    800047fe:	7902                	ld	s2,32(sp)
    80004800:	69e2                	ld	s3,24(sp)
    80004802:	6a42                	ld	s4,16(sp)
    80004804:	6121                	addi	sp,sp,64
    80004806:	8082                	ret
    iput(ip);
    80004808:	00000097          	auipc	ra,0x0
    8000480c:	a30080e7          	jalr	-1488(ra) # 80004238 <iput>
    return -1;
    80004810:	557d                	li	a0,-1
    80004812:	b7dd                	j	800047f8 <dirlink+0x86>
      panic("dirlink read");
    80004814:	00004517          	auipc	a0,0x4
    80004818:	d2c50513          	addi	a0,a0,-724 # 80008540 <etext+0x540>
    8000481c:	ffffc097          	auipc	ra,0xffffc
    80004820:	d22080e7          	jalr	-734(ra) # 8000053e <panic>

0000000080004824 <namei>:

struct inode*
namei(char *path)
{
    80004824:	1101                	addi	sp,sp,-32
    80004826:	ec06                	sd	ra,24(sp)
    80004828:	e822                	sd	s0,16(sp)
    8000482a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000482c:	fe040613          	addi	a2,s0,-32
    80004830:	4581                	li	a1,0
    80004832:	00000097          	auipc	ra,0x0
    80004836:	de0080e7          	jalr	-544(ra) # 80004612 <namex>
}
    8000483a:	60e2                	ld	ra,24(sp)
    8000483c:	6442                	ld	s0,16(sp)
    8000483e:	6105                	addi	sp,sp,32
    80004840:	8082                	ret

0000000080004842 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004842:	1141                	addi	sp,sp,-16
    80004844:	e406                	sd	ra,8(sp)
    80004846:	e022                	sd	s0,0(sp)
    80004848:	0800                	addi	s0,sp,16
    8000484a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000484c:	4585                	li	a1,1
    8000484e:	00000097          	auipc	ra,0x0
    80004852:	dc4080e7          	jalr	-572(ra) # 80004612 <namex>
}
    80004856:	60a2                	ld	ra,8(sp)
    80004858:	6402                	ld	s0,0(sp)
    8000485a:	0141                	addi	sp,sp,16
    8000485c:	8082                	ret

000000008000485e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000485e:	1101                	addi	sp,sp,-32
    80004860:	ec06                	sd	ra,24(sp)
    80004862:	e822                	sd	s0,16(sp)
    80004864:	e426                	sd	s1,8(sp)
    80004866:	e04a                	sd	s2,0(sp)
    80004868:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000486a:	00020917          	auipc	s2,0x20
    8000486e:	b0690913          	addi	s2,s2,-1274 # 80024370 <log>
    80004872:	01892583          	lw	a1,24(s2)
    80004876:	02892503          	lw	a0,40(s2)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	fea080e7          	jalr	-22(ra) # 80003864 <bread>
    80004882:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004884:	02c92683          	lw	a3,44(s2)
    80004888:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000488a:	02d05763          	blez	a3,800048b8 <write_head+0x5a>
    8000488e:	00020797          	auipc	a5,0x20
    80004892:	b1278793          	addi	a5,a5,-1262 # 800243a0 <log+0x30>
    80004896:	05c50713          	addi	a4,a0,92
    8000489a:	36fd                	addiw	a3,a3,-1
    8000489c:	1682                	slli	a3,a3,0x20
    8000489e:	9281                	srli	a3,a3,0x20
    800048a0:	068a                	slli	a3,a3,0x2
    800048a2:	00020617          	auipc	a2,0x20
    800048a6:	b0260613          	addi	a2,a2,-1278 # 800243a4 <log+0x34>
    800048aa:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800048ac:	4390                	lw	a2,0(a5)
    800048ae:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800048b0:	0791                	addi	a5,a5,4
    800048b2:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800048b4:	fed79ce3          	bne	a5,a3,800048ac <write_head+0x4e>
  }
  bwrite(buf);
    800048b8:	8526                	mv	a0,s1
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	09c080e7          	jalr	156(ra) # 80003956 <bwrite>
  brelse(buf);
    800048c2:	8526                	mv	a0,s1
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	0d0080e7          	jalr	208(ra) # 80003994 <brelse>
}
    800048cc:	60e2                	ld	ra,24(sp)
    800048ce:	6442                	ld	s0,16(sp)
    800048d0:	64a2                	ld	s1,8(sp)
    800048d2:	6902                	ld	s2,0(sp)
    800048d4:	6105                	addi	sp,sp,32
    800048d6:	8082                	ret

00000000800048d8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800048d8:	00020797          	auipc	a5,0x20
    800048dc:	ac47a783          	lw	a5,-1340(a5) # 8002439c <log+0x2c>
    800048e0:	0af05d63          	blez	a5,8000499a <install_trans+0xc2>
{
    800048e4:	7139                	addi	sp,sp,-64
    800048e6:	fc06                	sd	ra,56(sp)
    800048e8:	f822                	sd	s0,48(sp)
    800048ea:	f426                	sd	s1,40(sp)
    800048ec:	f04a                	sd	s2,32(sp)
    800048ee:	ec4e                	sd	s3,24(sp)
    800048f0:	e852                	sd	s4,16(sp)
    800048f2:	e456                	sd	s5,8(sp)
    800048f4:	e05a                	sd	s6,0(sp)
    800048f6:	0080                	addi	s0,sp,64
    800048f8:	8b2a                	mv	s6,a0
    800048fa:	00020a97          	auipc	s5,0x20
    800048fe:	aa6a8a93          	addi	s5,s5,-1370 # 800243a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004902:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004904:	00020997          	auipc	s3,0x20
    80004908:	a6c98993          	addi	s3,s3,-1428 # 80024370 <log>
    8000490c:	a00d                	j	8000492e <install_trans+0x56>
    brelse(lbuf);
    8000490e:	854a                	mv	a0,s2
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	084080e7          	jalr	132(ra) # 80003994 <brelse>
    brelse(dbuf);
    80004918:	8526                	mv	a0,s1
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	07a080e7          	jalr	122(ra) # 80003994 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004922:	2a05                	addiw	s4,s4,1
    80004924:	0a91                	addi	s5,s5,4
    80004926:	02c9a783          	lw	a5,44(s3)
    8000492a:	04fa5e63          	bge	s4,a5,80004986 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000492e:	0189a583          	lw	a1,24(s3)
    80004932:	014585bb          	addw	a1,a1,s4
    80004936:	2585                	addiw	a1,a1,1
    80004938:	0289a503          	lw	a0,40(s3)
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	f28080e7          	jalr	-216(ra) # 80003864 <bread>
    80004944:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004946:	000aa583          	lw	a1,0(s5)
    8000494a:	0289a503          	lw	a0,40(s3)
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	f16080e7          	jalr	-234(ra) # 80003864 <bread>
    80004956:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004958:	40000613          	li	a2,1024
    8000495c:	05890593          	addi	a1,s2,88
    80004960:	05850513          	addi	a0,a0,88
    80004964:	ffffc097          	auipc	ra,0xffffc
    80004968:	3ca080e7          	jalr	970(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    8000496c:	8526                	mv	a0,s1
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	fe8080e7          	jalr	-24(ra) # 80003956 <bwrite>
    if(recovering == 0)
    80004976:	f80b1ce3          	bnez	s6,8000490e <install_trans+0x36>
      bunpin(dbuf);
    8000497a:	8526                	mv	a0,s1
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	0f2080e7          	jalr	242(ra) # 80003a6e <bunpin>
    80004984:	b769                	j	8000490e <install_trans+0x36>
}
    80004986:	70e2                	ld	ra,56(sp)
    80004988:	7442                	ld	s0,48(sp)
    8000498a:	74a2                	ld	s1,40(sp)
    8000498c:	7902                	ld	s2,32(sp)
    8000498e:	69e2                	ld	s3,24(sp)
    80004990:	6a42                	ld	s4,16(sp)
    80004992:	6aa2                	ld	s5,8(sp)
    80004994:	6b02                	ld	s6,0(sp)
    80004996:	6121                	addi	sp,sp,64
    80004998:	8082                	ret
    8000499a:	8082                	ret

000000008000499c <initlog>:
{
    8000499c:	7179                	addi	sp,sp,-48
    8000499e:	f406                	sd	ra,40(sp)
    800049a0:	f022                	sd	s0,32(sp)
    800049a2:	ec26                	sd	s1,24(sp)
    800049a4:	e84a                	sd	s2,16(sp)
    800049a6:	e44e                	sd	s3,8(sp)
    800049a8:	1800                	addi	s0,sp,48
    800049aa:	892a                	mv	s2,a0
    800049ac:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800049ae:	00020497          	auipc	s1,0x20
    800049b2:	9c248493          	addi	s1,s1,-1598 # 80024370 <log>
    800049b6:	00004597          	auipc	a1,0x4
    800049ba:	b9a58593          	addi	a1,a1,-1126 # 80008550 <etext+0x550>
    800049be:	8526                	mv	a0,s1
    800049c0:	ffffc097          	auipc	ra,0xffffc
    800049c4:	186080e7          	jalr	390(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    800049c8:	0149a583          	lw	a1,20(s3)
    800049cc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800049ce:	0109a783          	lw	a5,16(s3)
    800049d2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800049d4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800049d8:	854a                	mv	a0,s2
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	e8a080e7          	jalr	-374(ra) # 80003864 <bread>
  log.lh.n = lh->n;
    800049e2:	4d34                	lw	a3,88(a0)
    800049e4:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800049e6:	02d05563          	blez	a3,80004a10 <initlog+0x74>
    800049ea:	05c50793          	addi	a5,a0,92
    800049ee:	00020717          	auipc	a4,0x20
    800049f2:	9b270713          	addi	a4,a4,-1614 # 800243a0 <log+0x30>
    800049f6:	36fd                	addiw	a3,a3,-1
    800049f8:	1682                	slli	a3,a3,0x20
    800049fa:	9281                	srli	a3,a3,0x20
    800049fc:	068a                	slli	a3,a3,0x2
    800049fe:	06050613          	addi	a2,a0,96
    80004a02:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004a04:	4390                	lw	a2,0(a5)
    80004a06:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004a08:	0791                	addi	a5,a5,4
    80004a0a:	0711                	addi	a4,a4,4
    80004a0c:	fed79ce3          	bne	a5,a3,80004a04 <initlog+0x68>
  brelse(buf);
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	f84080e7          	jalr	-124(ra) # 80003994 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004a18:	4505                	li	a0,1
    80004a1a:	00000097          	auipc	ra,0x0
    80004a1e:	ebe080e7          	jalr	-322(ra) # 800048d8 <install_trans>
  log.lh.n = 0;
    80004a22:	00020797          	auipc	a5,0x20
    80004a26:	9607ad23          	sw	zero,-1670(a5) # 8002439c <log+0x2c>
  write_head(); // clear the log
    80004a2a:	00000097          	auipc	ra,0x0
    80004a2e:	e34080e7          	jalr	-460(ra) # 8000485e <write_head>
}
    80004a32:	70a2                	ld	ra,40(sp)
    80004a34:	7402                	ld	s0,32(sp)
    80004a36:	64e2                	ld	s1,24(sp)
    80004a38:	6942                	ld	s2,16(sp)
    80004a3a:	69a2                	ld	s3,8(sp)
    80004a3c:	6145                	addi	sp,sp,48
    80004a3e:	8082                	ret

0000000080004a40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004a40:	1101                	addi	sp,sp,-32
    80004a42:	ec06                	sd	ra,24(sp)
    80004a44:	e822                	sd	s0,16(sp)
    80004a46:	e426                	sd	s1,8(sp)
    80004a48:	e04a                	sd	s2,0(sp)
    80004a4a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004a4c:	00020517          	auipc	a0,0x20
    80004a50:	92450513          	addi	a0,a0,-1756 # 80024370 <log>
    80004a54:	ffffc097          	auipc	ra,0xffffc
    80004a58:	182080e7          	jalr	386(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    80004a5c:	00020497          	auipc	s1,0x20
    80004a60:	91448493          	addi	s1,s1,-1772 # 80024370 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004a64:	4979                	li	s2,30
    80004a66:	a039                	j	80004a74 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004a68:	85a6                	mv	a1,s1
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	a64080e7          	jalr	-1436(ra) # 800024d0 <sleep>
    if(log.committing){
    80004a74:	50dc                	lw	a5,36(s1)
    80004a76:	fbed                	bnez	a5,80004a68 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004a78:	509c                	lw	a5,32(s1)
    80004a7a:	0017871b          	addiw	a4,a5,1
    80004a7e:	0007069b          	sext.w	a3,a4
    80004a82:	0027179b          	slliw	a5,a4,0x2
    80004a86:	9fb9                	addw	a5,a5,a4
    80004a88:	0017979b          	slliw	a5,a5,0x1
    80004a8c:	54d8                	lw	a4,44(s1)
    80004a8e:	9fb9                	addw	a5,a5,a4
    80004a90:	00f95963          	bge	s2,a5,80004aa2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004a94:	85a6                	mv	a1,s1
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	a38080e7          	jalr	-1480(ra) # 800024d0 <sleep>
    80004aa0:	bfd1                	j	80004a74 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004aa2:	00020517          	auipc	a0,0x20
    80004aa6:	8ce50513          	addi	a0,a0,-1842 # 80024370 <log>
    80004aaa:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	1de080e7          	jalr	478(ra) # 80000c8a <release>
      break;
    }
  }
}
    80004ab4:	60e2                	ld	ra,24(sp)
    80004ab6:	6442                	ld	s0,16(sp)
    80004ab8:	64a2                	ld	s1,8(sp)
    80004aba:	6902                	ld	s2,0(sp)
    80004abc:	6105                	addi	sp,sp,32
    80004abe:	8082                	ret

0000000080004ac0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004ac0:	7139                	addi	sp,sp,-64
    80004ac2:	fc06                	sd	ra,56(sp)
    80004ac4:	f822                	sd	s0,48(sp)
    80004ac6:	f426                	sd	s1,40(sp)
    80004ac8:	f04a                	sd	s2,32(sp)
    80004aca:	ec4e                	sd	s3,24(sp)
    80004acc:	e852                	sd	s4,16(sp)
    80004ace:	e456                	sd	s5,8(sp)
    80004ad0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004ad2:	00020497          	auipc	s1,0x20
    80004ad6:	89e48493          	addi	s1,s1,-1890 # 80024370 <log>
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	0fa080e7          	jalr	250(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    80004ae4:	509c                	lw	a5,32(s1)
    80004ae6:	37fd                	addiw	a5,a5,-1
    80004ae8:	0007891b          	sext.w	s2,a5
    80004aec:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004aee:	50dc                	lw	a5,36(s1)
    80004af0:	e7b9                	bnez	a5,80004b3e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004af2:	04091e63          	bnez	s2,80004b4e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004af6:	00020497          	auipc	s1,0x20
    80004afa:	87a48493          	addi	s1,s1,-1926 # 80024370 <log>
    80004afe:	4785                	li	a5,1
    80004b00:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffc097          	auipc	ra,0xffffc
    80004b08:	186080e7          	jalr	390(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004b0c:	54dc                	lw	a5,44(s1)
    80004b0e:	06f04763          	bgtz	a5,80004b7c <end_op+0xbc>
    acquire(&log.lock);
    80004b12:	00020497          	auipc	s1,0x20
    80004b16:	85e48493          	addi	s1,s1,-1954 # 80024370 <log>
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffc097          	auipc	ra,0xffffc
    80004b20:	0ba080e7          	jalr	186(ra) # 80000bd6 <acquire>
    log.committing = 0;
    80004b24:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	a0a080e7          	jalr	-1526(ra) # 80002534 <wakeup>
    release(&log.lock);
    80004b32:	8526                	mv	a0,s1
    80004b34:	ffffc097          	auipc	ra,0xffffc
    80004b38:	156080e7          	jalr	342(ra) # 80000c8a <release>
}
    80004b3c:	a03d                	j	80004b6a <end_op+0xaa>
    panic("log.committing");
    80004b3e:	00004517          	auipc	a0,0x4
    80004b42:	a1a50513          	addi	a0,a0,-1510 # 80008558 <etext+0x558>
    80004b46:	ffffc097          	auipc	ra,0xffffc
    80004b4a:	9f8080e7          	jalr	-1544(ra) # 8000053e <panic>
    wakeup(&log);
    80004b4e:	00020497          	auipc	s1,0x20
    80004b52:	82248493          	addi	s1,s1,-2014 # 80024370 <log>
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	9dc080e7          	jalr	-1572(ra) # 80002534 <wakeup>
  release(&log.lock);
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffc097          	auipc	ra,0xffffc
    80004b66:	128080e7          	jalr	296(ra) # 80000c8a <release>
}
    80004b6a:	70e2                	ld	ra,56(sp)
    80004b6c:	7442                	ld	s0,48(sp)
    80004b6e:	74a2                	ld	s1,40(sp)
    80004b70:	7902                	ld	s2,32(sp)
    80004b72:	69e2                	ld	s3,24(sp)
    80004b74:	6a42                	ld	s4,16(sp)
    80004b76:	6aa2                	ld	s5,8(sp)
    80004b78:	6121                	addi	sp,sp,64
    80004b7a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b7c:	00020a97          	auipc	s5,0x20
    80004b80:	824a8a93          	addi	s5,s5,-2012 # 800243a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004b84:	0001fa17          	auipc	s4,0x1f
    80004b88:	7eca0a13          	addi	s4,s4,2028 # 80024370 <log>
    80004b8c:	018a2583          	lw	a1,24(s4)
    80004b90:	012585bb          	addw	a1,a1,s2
    80004b94:	2585                	addiw	a1,a1,1
    80004b96:	028a2503          	lw	a0,40(s4)
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	cca080e7          	jalr	-822(ra) # 80003864 <bread>
    80004ba2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004ba4:	000aa583          	lw	a1,0(s5)
    80004ba8:	028a2503          	lw	a0,40(s4)
    80004bac:	fffff097          	auipc	ra,0xfffff
    80004bb0:	cb8080e7          	jalr	-840(ra) # 80003864 <bread>
    80004bb4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004bb6:	40000613          	li	a2,1024
    80004bba:	05850593          	addi	a1,a0,88
    80004bbe:	05848513          	addi	a0,s1,88
    80004bc2:	ffffc097          	auipc	ra,0xffffc
    80004bc6:	16c080e7          	jalr	364(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    80004bca:	8526                	mv	a0,s1
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	d8a080e7          	jalr	-630(ra) # 80003956 <bwrite>
    brelse(from);
    80004bd4:	854e                	mv	a0,s3
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	dbe080e7          	jalr	-578(ra) # 80003994 <brelse>
    brelse(to);
    80004bde:	8526                	mv	a0,s1
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	db4080e7          	jalr	-588(ra) # 80003994 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004be8:	2905                	addiw	s2,s2,1
    80004bea:	0a91                	addi	s5,s5,4
    80004bec:	02ca2783          	lw	a5,44(s4)
    80004bf0:	f8f94ee3          	blt	s2,a5,80004b8c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004bf4:	00000097          	auipc	ra,0x0
    80004bf8:	c6a080e7          	jalr	-918(ra) # 8000485e <write_head>
    install_trans(0); // Now install writes to home locations
    80004bfc:	4501                	li	a0,0
    80004bfe:	00000097          	auipc	ra,0x0
    80004c02:	cda080e7          	jalr	-806(ra) # 800048d8 <install_trans>
    log.lh.n = 0;
    80004c06:	0001f797          	auipc	a5,0x1f
    80004c0a:	7807ab23          	sw	zero,1942(a5) # 8002439c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004c0e:	00000097          	auipc	ra,0x0
    80004c12:	c50080e7          	jalr	-944(ra) # 8000485e <write_head>
    80004c16:	bdf5                	j	80004b12 <end_op+0x52>

0000000080004c18 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004c18:	1101                	addi	sp,sp,-32
    80004c1a:	ec06                	sd	ra,24(sp)
    80004c1c:	e822                	sd	s0,16(sp)
    80004c1e:	e426                	sd	s1,8(sp)
    80004c20:	e04a                	sd	s2,0(sp)
    80004c22:	1000                	addi	s0,sp,32
    80004c24:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004c26:	0001f917          	auipc	s2,0x1f
    80004c2a:	74a90913          	addi	s2,s2,1866 # 80024370 <log>
    80004c2e:	854a                	mv	a0,s2
    80004c30:	ffffc097          	auipc	ra,0xffffc
    80004c34:	fa6080e7          	jalr	-90(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004c38:	02c92603          	lw	a2,44(s2)
    80004c3c:	47f5                	li	a5,29
    80004c3e:	06c7c563          	blt	a5,a2,80004ca8 <log_write+0x90>
    80004c42:	0001f797          	auipc	a5,0x1f
    80004c46:	74a7a783          	lw	a5,1866(a5) # 8002438c <log+0x1c>
    80004c4a:	37fd                	addiw	a5,a5,-1
    80004c4c:	04f65e63          	bge	a2,a5,80004ca8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004c50:	0001f797          	auipc	a5,0x1f
    80004c54:	7407a783          	lw	a5,1856(a5) # 80024390 <log+0x20>
    80004c58:	06f05063          	blez	a5,80004cb8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004c5c:	4781                	li	a5,0
    80004c5e:	06c05563          	blez	a2,80004cc8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004c62:	44cc                	lw	a1,12(s1)
    80004c64:	0001f717          	auipc	a4,0x1f
    80004c68:	73c70713          	addi	a4,a4,1852 # 800243a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004c6c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004c6e:	4314                	lw	a3,0(a4)
    80004c70:	04b68c63          	beq	a3,a1,80004cc8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004c74:	2785                	addiw	a5,a5,1
    80004c76:	0711                	addi	a4,a4,4
    80004c78:	fef61be3          	bne	a2,a5,80004c6e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004c7c:	0621                	addi	a2,a2,8
    80004c7e:	060a                	slli	a2,a2,0x2
    80004c80:	0001f797          	auipc	a5,0x1f
    80004c84:	6f078793          	addi	a5,a5,1776 # 80024370 <log>
    80004c88:	963e                	add	a2,a2,a5
    80004c8a:	44dc                	lw	a5,12(s1)
    80004c8c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004c8e:	8526                	mv	a0,s1
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	da2080e7          	jalr	-606(ra) # 80003a32 <bpin>
    log.lh.n++;
    80004c98:	0001f717          	auipc	a4,0x1f
    80004c9c:	6d870713          	addi	a4,a4,1752 # 80024370 <log>
    80004ca0:	575c                	lw	a5,44(a4)
    80004ca2:	2785                	addiw	a5,a5,1
    80004ca4:	d75c                	sw	a5,44(a4)
    80004ca6:	a835                	j	80004ce2 <log_write+0xca>
    panic("too big a transaction");
    80004ca8:	00004517          	auipc	a0,0x4
    80004cac:	8c050513          	addi	a0,a0,-1856 # 80008568 <etext+0x568>
    80004cb0:	ffffc097          	auipc	ra,0xffffc
    80004cb4:	88e080e7          	jalr	-1906(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004cb8:	00004517          	auipc	a0,0x4
    80004cbc:	8c850513          	addi	a0,a0,-1848 # 80008580 <etext+0x580>
    80004cc0:	ffffc097          	auipc	ra,0xffffc
    80004cc4:	87e080e7          	jalr	-1922(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004cc8:	00878713          	addi	a4,a5,8
    80004ccc:	00271693          	slli	a3,a4,0x2
    80004cd0:	0001f717          	auipc	a4,0x1f
    80004cd4:	6a070713          	addi	a4,a4,1696 # 80024370 <log>
    80004cd8:	9736                	add	a4,a4,a3
    80004cda:	44d4                	lw	a3,12(s1)
    80004cdc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004cde:	faf608e3          	beq	a2,a5,80004c8e <log_write+0x76>
  }
  release(&log.lock);
    80004ce2:	0001f517          	auipc	a0,0x1f
    80004ce6:	68e50513          	addi	a0,a0,1678 # 80024370 <log>
    80004cea:	ffffc097          	auipc	ra,0xffffc
    80004cee:	fa0080e7          	jalr	-96(ra) # 80000c8a <release>
}
    80004cf2:	60e2                	ld	ra,24(sp)
    80004cf4:	6442                	ld	s0,16(sp)
    80004cf6:	64a2                	ld	s1,8(sp)
    80004cf8:	6902                	ld	s2,0(sp)
    80004cfa:	6105                	addi	sp,sp,32
    80004cfc:	8082                	ret

0000000080004cfe <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004cfe:	1101                	addi	sp,sp,-32
    80004d00:	ec06                	sd	ra,24(sp)
    80004d02:	e822                	sd	s0,16(sp)
    80004d04:	e426                	sd	s1,8(sp)
    80004d06:	e04a                	sd	s2,0(sp)
    80004d08:	1000                	addi	s0,sp,32
    80004d0a:	84aa                	mv	s1,a0
    80004d0c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004d0e:	00004597          	auipc	a1,0x4
    80004d12:	89258593          	addi	a1,a1,-1902 # 800085a0 <etext+0x5a0>
    80004d16:	0521                	addi	a0,a0,8
    80004d18:	ffffc097          	auipc	ra,0xffffc
    80004d1c:	e2e080e7          	jalr	-466(ra) # 80000b46 <initlock>
  lk->name = name;
    80004d20:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004d24:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004d28:	0204a423          	sw	zero,40(s1)
}
    80004d2c:	60e2                	ld	ra,24(sp)
    80004d2e:	6442                	ld	s0,16(sp)
    80004d30:	64a2                	ld	s1,8(sp)
    80004d32:	6902                	ld	s2,0(sp)
    80004d34:	6105                	addi	sp,sp,32
    80004d36:	8082                	ret

0000000080004d38 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004d38:	1101                	addi	sp,sp,-32
    80004d3a:	ec06                	sd	ra,24(sp)
    80004d3c:	e822                	sd	s0,16(sp)
    80004d3e:	e426                	sd	s1,8(sp)
    80004d40:	e04a                	sd	s2,0(sp)
    80004d42:	1000                	addi	s0,sp,32
    80004d44:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004d46:	00850913          	addi	s2,a0,8
    80004d4a:	854a                	mv	a0,s2
    80004d4c:	ffffc097          	auipc	ra,0xffffc
    80004d50:	e8a080e7          	jalr	-374(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    80004d54:	409c                	lw	a5,0(s1)
    80004d56:	cb89                	beqz	a5,80004d68 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004d58:	85ca                	mv	a1,s2
    80004d5a:	8526                	mv	a0,s1
    80004d5c:	ffffd097          	auipc	ra,0xffffd
    80004d60:	774080e7          	jalr	1908(ra) # 800024d0 <sleep>
  while (lk->locked) {
    80004d64:	409c                	lw	a5,0(s1)
    80004d66:	fbed                	bnez	a5,80004d58 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004d68:	4785                	li	a5,1
    80004d6a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004d6c:	ffffd097          	auipc	ra,0xffffd
    80004d70:	c74080e7          	jalr	-908(ra) # 800019e0 <myproc>
    80004d74:	591c                	lw	a5,48(a0)
    80004d76:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004d78:	854a                	mv	a0,s2
    80004d7a:	ffffc097          	auipc	ra,0xffffc
    80004d7e:	f10080e7          	jalr	-240(ra) # 80000c8a <release>
}
    80004d82:	60e2                	ld	ra,24(sp)
    80004d84:	6442                	ld	s0,16(sp)
    80004d86:	64a2                	ld	s1,8(sp)
    80004d88:	6902                	ld	s2,0(sp)
    80004d8a:	6105                	addi	sp,sp,32
    80004d8c:	8082                	ret

0000000080004d8e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004d8e:	1101                	addi	sp,sp,-32
    80004d90:	ec06                	sd	ra,24(sp)
    80004d92:	e822                	sd	s0,16(sp)
    80004d94:	e426                	sd	s1,8(sp)
    80004d96:	e04a                	sd	s2,0(sp)
    80004d98:	1000                	addi	s0,sp,32
    80004d9a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004d9c:	00850913          	addi	s2,a0,8
    80004da0:	854a                	mv	a0,s2
    80004da2:	ffffc097          	auipc	ra,0xffffc
    80004da6:	e34080e7          	jalr	-460(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    80004daa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004dae:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004db2:	8526                	mv	a0,s1
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	780080e7          	jalr	1920(ra) # 80002534 <wakeup>
  release(&lk->lk);
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	ffffc097          	auipc	ra,0xffffc
    80004dc2:	ecc080e7          	jalr	-308(ra) # 80000c8a <release>
}
    80004dc6:	60e2                	ld	ra,24(sp)
    80004dc8:	6442                	ld	s0,16(sp)
    80004dca:	64a2                	ld	s1,8(sp)
    80004dcc:	6902                	ld	s2,0(sp)
    80004dce:	6105                	addi	sp,sp,32
    80004dd0:	8082                	ret

0000000080004dd2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004dd2:	7179                	addi	sp,sp,-48
    80004dd4:	f406                	sd	ra,40(sp)
    80004dd6:	f022                	sd	s0,32(sp)
    80004dd8:	ec26                	sd	s1,24(sp)
    80004dda:	e84a                	sd	s2,16(sp)
    80004ddc:	e44e                	sd	s3,8(sp)
    80004dde:	1800                	addi	s0,sp,48
    80004de0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004de2:	00850913          	addi	s2,a0,8
    80004de6:	854a                	mv	a0,s2
    80004de8:	ffffc097          	auipc	ra,0xffffc
    80004dec:	dee080e7          	jalr	-530(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004df0:	409c                	lw	a5,0(s1)
    80004df2:	ef99                	bnez	a5,80004e10 <holdingsleep+0x3e>
    80004df4:	4481                	li	s1,0
  release(&lk->lk);
    80004df6:	854a                	mv	a0,s2
    80004df8:	ffffc097          	auipc	ra,0xffffc
    80004dfc:	e92080e7          	jalr	-366(ra) # 80000c8a <release>
  return r;
}
    80004e00:	8526                	mv	a0,s1
    80004e02:	70a2                	ld	ra,40(sp)
    80004e04:	7402                	ld	s0,32(sp)
    80004e06:	64e2                	ld	s1,24(sp)
    80004e08:	6942                	ld	s2,16(sp)
    80004e0a:	69a2                	ld	s3,8(sp)
    80004e0c:	6145                	addi	sp,sp,48
    80004e0e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004e10:	0284a983          	lw	s3,40(s1)
    80004e14:	ffffd097          	auipc	ra,0xffffd
    80004e18:	bcc080e7          	jalr	-1076(ra) # 800019e0 <myproc>
    80004e1c:	5904                	lw	s1,48(a0)
    80004e1e:	413484b3          	sub	s1,s1,s3
    80004e22:	0014b493          	seqz	s1,s1
    80004e26:	bfc1                	j	80004df6 <holdingsleep+0x24>

0000000080004e28 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004e28:	1141                	addi	sp,sp,-16
    80004e2a:	e406                	sd	ra,8(sp)
    80004e2c:	e022                	sd	s0,0(sp)
    80004e2e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004e30:	00003597          	auipc	a1,0x3
    80004e34:	78058593          	addi	a1,a1,1920 # 800085b0 <etext+0x5b0>
    80004e38:	0001f517          	auipc	a0,0x1f
    80004e3c:	68050513          	addi	a0,a0,1664 # 800244b8 <ftable>
    80004e40:	ffffc097          	auipc	ra,0xffffc
    80004e44:	d06080e7          	jalr	-762(ra) # 80000b46 <initlock>
}
    80004e48:	60a2                	ld	ra,8(sp)
    80004e4a:	6402                	ld	s0,0(sp)
    80004e4c:	0141                	addi	sp,sp,16
    80004e4e:	8082                	ret

0000000080004e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004e50:	1101                	addi	sp,sp,-32
    80004e52:	ec06                	sd	ra,24(sp)
    80004e54:	e822                	sd	s0,16(sp)
    80004e56:	e426                	sd	s1,8(sp)
    80004e58:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004e5a:	0001f517          	auipc	a0,0x1f
    80004e5e:	65e50513          	addi	a0,a0,1630 # 800244b8 <ftable>
    80004e62:	ffffc097          	auipc	ra,0xffffc
    80004e66:	d74080e7          	jalr	-652(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004e6a:	0001f497          	auipc	s1,0x1f
    80004e6e:	66648493          	addi	s1,s1,1638 # 800244d0 <ftable+0x18>
    80004e72:	00020717          	auipc	a4,0x20
    80004e76:	5fe70713          	addi	a4,a4,1534 # 80025470 <disk>
    if(f->ref == 0){
    80004e7a:	40dc                	lw	a5,4(s1)
    80004e7c:	cf99                	beqz	a5,80004e9a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004e7e:	02848493          	addi	s1,s1,40
    80004e82:	fee49ce3          	bne	s1,a4,80004e7a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004e86:	0001f517          	auipc	a0,0x1f
    80004e8a:	63250513          	addi	a0,a0,1586 # 800244b8 <ftable>
    80004e8e:	ffffc097          	auipc	ra,0xffffc
    80004e92:	dfc080e7          	jalr	-516(ra) # 80000c8a <release>
  return 0;
    80004e96:	4481                	li	s1,0
    80004e98:	a819                	j	80004eae <filealloc+0x5e>
      f->ref = 1;
    80004e9a:	4785                	li	a5,1
    80004e9c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004e9e:	0001f517          	auipc	a0,0x1f
    80004ea2:	61a50513          	addi	a0,a0,1562 # 800244b8 <ftable>
    80004ea6:	ffffc097          	auipc	ra,0xffffc
    80004eaa:	de4080e7          	jalr	-540(ra) # 80000c8a <release>
}
    80004eae:	8526                	mv	a0,s1
    80004eb0:	60e2                	ld	ra,24(sp)
    80004eb2:	6442                	ld	s0,16(sp)
    80004eb4:	64a2                	ld	s1,8(sp)
    80004eb6:	6105                	addi	sp,sp,32
    80004eb8:	8082                	ret

0000000080004eba <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004eba:	1101                	addi	sp,sp,-32
    80004ebc:	ec06                	sd	ra,24(sp)
    80004ebe:	e822                	sd	s0,16(sp)
    80004ec0:	e426                	sd	s1,8(sp)
    80004ec2:	1000                	addi	s0,sp,32
    80004ec4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004ec6:	0001f517          	auipc	a0,0x1f
    80004eca:	5f250513          	addi	a0,a0,1522 # 800244b8 <ftable>
    80004ece:	ffffc097          	auipc	ra,0xffffc
    80004ed2:	d08080e7          	jalr	-760(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004ed6:	40dc                	lw	a5,4(s1)
    80004ed8:	02f05263          	blez	a5,80004efc <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004edc:	2785                	addiw	a5,a5,1
    80004ede:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ee0:	0001f517          	auipc	a0,0x1f
    80004ee4:	5d850513          	addi	a0,a0,1496 # 800244b8 <ftable>
    80004ee8:	ffffc097          	auipc	ra,0xffffc
    80004eec:	da2080e7          	jalr	-606(ra) # 80000c8a <release>
  return f;
}
    80004ef0:	8526                	mv	a0,s1
    80004ef2:	60e2                	ld	ra,24(sp)
    80004ef4:	6442                	ld	s0,16(sp)
    80004ef6:	64a2                	ld	s1,8(sp)
    80004ef8:	6105                	addi	sp,sp,32
    80004efa:	8082                	ret
    panic("filedup");
    80004efc:	00003517          	auipc	a0,0x3
    80004f00:	6bc50513          	addi	a0,a0,1724 # 800085b8 <etext+0x5b8>
    80004f04:	ffffb097          	auipc	ra,0xffffb
    80004f08:	63a080e7          	jalr	1594(ra) # 8000053e <panic>

0000000080004f0c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004f0c:	7139                	addi	sp,sp,-64
    80004f0e:	fc06                	sd	ra,56(sp)
    80004f10:	f822                	sd	s0,48(sp)
    80004f12:	f426                	sd	s1,40(sp)
    80004f14:	f04a                	sd	s2,32(sp)
    80004f16:	ec4e                	sd	s3,24(sp)
    80004f18:	e852                	sd	s4,16(sp)
    80004f1a:	e456                	sd	s5,8(sp)
    80004f1c:	0080                	addi	s0,sp,64
    80004f1e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004f20:	0001f517          	auipc	a0,0x1f
    80004f24:	59850513          	addi	a0,a0,1432 # 800244b8 <ftable>
    80004f28:	ffffc097          	auipc	ra,0xffffc
    80004f2c:	cae080e7          	jalr	-850(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004f30:	40dc                	lw	a5,4(s1)
    80004f32:	06f05163          	blez	a5,80004f94 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004f36:	37fd                	addiw	a5,a5,-1
    80004f38:	0007871b          	sext.w	a4,a5
    80004f3c:	c0dc                	sw	a5,4(s1)
    80004f3e:	06e04363          	bgtz	a4,80004fa4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004f42:	0004a903          	lw	s2,0(s1)
    80004f46:	0094ca83          	lbu	s5,9(s1)
    80004f4a:	0104ba03          	ld	s4,16(s1)
    80004f4e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004f52:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004f56:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004f5a:	0001f517          	auipc	a0,0x1f
    80004f5e:	55e50513          	addi	a0,a0,1374 # 800244b8 <ftable>
    80004f62:	ffffc097          	auipc	ra,0xffffc
    80004f66:	d28080e7          	jalr	-728(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    80004f6a:	4785                	li	a5,1
    80004f6c:	04f90d63          	beq	s2,a5,80004fc6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004f70:	3979                	addiw	s2,s2,-2
    80004f72:	4785                	li	a5,1
    80004f74:	0527e063          	bltu	a5,s2,80004fb4 <fileclose+0xa8>
    begin_op();
    80004f78:	00000097          	auipc	ra,0x0
    80004f7c:	ac8080e7          	jalr	-1336(ra) # 80004a40 <begin_op>
    iput(ff.ip);
    80004f80:	854e                	mv	a0,s3
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	2b6080e7          	jalr	694(ra) # 80004238 <iput>
    end_op();
    80004f8a:	00000097          	auipc	ra,0x0
    80004f8e:	b36080e7          	jalr	-1226(ra) # 80004ac0 <end_op>
    80004f92:	a00d                	j	80004fb4 <fileclose+0xa8>
    panic("fileclose");
    80004f94:	00003517          	auipc	a0,0x3
    80004f98:	62c50513          	addi	a0,a0,1580 # 800085c0 <etext+0x5c0>
    80004f9c:	ffffb097          	auipc	ra,0xffffb
    80004fa0:	5a2080e7          	jalr	1442(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004fa4:	0001f517          	auipc	a0,0x1f
    80004fa8:	51450513          	addi	a0,a0,1300 # 800244b8 <ftable>
    80004fac:	ffffc097          	auipc	ra,0xffffc
    80004fb0:	cde080e7          	jalr	-802(ra) # 80000c8a <release>
  }
}
    80004fb4:	70e2                	ld	ra,56(sp)
    80004fb6:	7442                	ld	s0,48(sp)
    80004fb8:	74a2                	ld	s1,40(sp)
    80004fba:	7902                	ld	s2,32(sp)
    80004fbc:	69e2                	ld	s3,24(sp)
    80004fbe:	6a42                	ld	s4,16(sp)
    80004fc0:	6aa2                	ld	s5,8(sp)
    80004fc2:	6121                	addi	sp,sp,64
    80004fc4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004fc6:	85d6                	mv	a1,s5
    80004fc8:	8552                	mv	a0,s4
    80004fca:	00000097          	auipc	ra,0x0
    80004fce:	34c080e7          	jalr	844(ra) # 80005316 <pipeclose>
    80004fd2:	b7cd                	j	80004fb4 <fileclose+0xa8>

0000000080004fd4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004fd4:	715d                	addi	sp,sp,-80
    80004fd6:	e486                	sd	ra,72(sp)
    80004fd8:	e0a2                	sd	s0,64(sp)
    80004fda:	fc26                	sd	s1,56(sp)
    80004fdc:	f84a                	sd	s2,48(sp)
    80004fde:	f44e                	sd	s3,40(sp)
    80004fe0:	0880                	addi	s0,sp,80
    80004fe2:	84aa                	mv	s1,a0
    80004fe4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	9fa080e7          	jalr	-1542(ra) # 800019e0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004fee:	409c                	lw	a5,0(s1)
    80004ff0:	37f9                	addiw	a5,a5,-2
    80004ff2:	4705                	li	a4,1
    80004ff4:	04f76763          	bltu	a4,a5,80005042 <filestat+0x6e>
    80004ff8:	892a                	mv	s2,a0
    ilock(f->ip);
    80004ffa:	6c88                	ld	a0,24(s1)
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	082080e7          	jalr	130(ra) # 8000407e <ilock>
    stati(f->ip, &st);
    80005004:	fb840593          	addi	a1,s0,-72
    80005008:	6c88                	ld	a0,24(s1)
    8000500a:	fffff097          	auipc	ra,0xfffff
    8000500e:	2fe080e7          	jalr	766(ra) # 80004308 <stati>
    iunlock(f->ip);
    80005012:	6c88                	ld	a0,24(s1)
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	12c080e7          	jalr	300(ra) # 80004140 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000501c:	46e1                	li	a3,24
    8000501e:	fb840613          	addi	a2,s0,-72
    80005022:	85ce                	mv	a1,s3
    80005024:	05093503          	ld	a0,80(s2)
    80005028:	ffffc097          	auipc	ra,0xffffc
    8000502c:	640080e7          	jalr	1600(ra) # 80001668 <copyout>
    80005030:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80005034:	60a6                	ld	ra,72(sp)
    80005036:	6406                	ld	s0,64(sp)
    80005038:	74e2                	ld	s1,56(sp)
    8000503a:	7942                	ld	s2,48(sp)
    8000503c:	79a2                	ld	s3,40(sp)
    8000503e:	6161                	addi	sp,sp,80
    80005040:	8082                	ret
  return -1;
    80005042:	557d                	li	a0,-1
    80005044:	bfc5                	j	80005034 <filestat+0x60>

0000000080005046 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005046:	7179                	addi	sp,sp,-48
    80005048:	f406                	sd	ra,40(sp)
    8000504a:	f022                	sd	s0,32(sp)
    8000504c:	ec26                	sd	s1,24(sp)
    8000504e:	e84a                	sd	s2,16(sp)
    80005050:	e44e                	sd	s3,8(sp)
    80005052:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80005054:	00854783          	lbu	a5,8(a0)
    80005058:	c3d5                	beqz	a5,800050fc <fileread+0xb6>
    8000505a:	84aa                	mv	s1,a0
    8000505c:	89ae                	mv	s3,a1
    8000505e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80005060:	411c                	lw	a5,0(a0)
    80005062:	4705                	li	a4,1
    80005064:	04e78963          	beq	a5,a4,800050b6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005068:	470d                	li	a4,3
    8000506a:	04e78d63          	beq	a5,a4,800050c4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000506e:	4709                	li	a4,2
    80005070:	06e79e63          	bne	a5,a4,800050ec <fileread+0xa6>
    ilock(f->ip);
    80005074:	6d08                	ld	a0,24(a0)
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	008080e7          	jalr	8(ra) # 8000407e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000507e:	874a                	mv	a4,s2
    80005080:	5094                	lw	a3,32(s1)
    80005082:	864e                	mv	a2,s3
    80005084:	4585                	li	a1,1
    80005086:	6c88                	ld	a0,24(s1)
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	2aa080e7          	jalr	682(ra) # 80004332 <readi>
    80005090:	892a                	mv	s2,a0
    80005092:	00a05563          	blez	a0,8000509c <fileread+0x56>
      f->off += r;
    80005096:	509c                	lw	a5,32(s1)
    80005098:	9fa9                	addw	a5,a5,a0
    8000509a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000509c:	6c88                	ld	a0,24(s1)
    8000509e:	fffff097          	auipc	ra,0xfffff
    800050a2:	0a2080e7          	jalr	162(ra) # 80004140 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800050a6:	854a                	mv	a0,s2
    800050a8:	70a2                	ld	ra,40(sp)
    800050aa:	7402                	ld	s0,32(sp)
    800050ac:	64e2                	ld	s1,24(sp)
    800050ae:	6942                	ld	s2,16(sp)
    800050b0:	69a2                	ld	s3,8(sp)
    800050b2:	6145                	addi	sp,sp,48
    800050b4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800050b6:	6908                	ld	a0,16(a0)
    800050b8:	00000097          	auipc	ra,0x0
    800050bc:	3c6080e7          	jalr	966(ra) # 8000547e <piperead>
    800050c0:	892a                	mv	s2,a0
    800050c2:	b7d5                	j	800050a6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800050c4:	02451783          	lh	a5,36(a0)
    800050c8:	03079693          	slli	a3,a5,0x30
    800050cc:	92c1                	srli	a3,a3,0x30
    800050ce:	4725                	li	a4,9
    800050d0:	02d76863          	bltu	a4,a3,80005100 <fileread+0xba>
    800050d4:	0792                	slli	a5,a5,0x4
    800050d6:	0001f717          	auipc	a4,0x1f
    800050da:	34270713          	addi	a4,a4,834 # 80024418 <devsw>
    800050de:	97ba                	add	a5,a5,a4
    800050e0:	639c                	ld	a5,0(a5)
    800050e2:	c38d                	beqz	a5,80005104 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800050e4:	4505                	li	a0,1
    800050e6:	9782                	jalr	a5
    800050e8:	892a                	mv	s2,a0
    800050ea:	bf75                	j	800050a6 <fileread+0x60>
    panic("fileread");
    800050ec:	00003517          	auipc	a0,0x3
    800050f0:	4e450513          	addi	a0,a0,1252 # 800085d0 <etext+0x5d0>
    800050f4:	ffffb097          	auipc	ra,0xffffb
    800050f8:	44a080e7          	jalr	1098(ra) # 8000053e <panic>
    return -1;
    800050fc:	597d                	li	s2,-1
    800050fe:	b765                	j	800050a6 <fileread+0x60>
      return -1;
    80005100:	597d                	li	s2,-1
    80005102:	b755                	j	800050a6 <fileread+0x60>
    80005104:	597d                	li	s2,-1
    80005106:	b745                	j	800050a6 <fileread+0x60>

0000000080005108 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80005108:	715d                	addi	sp,sp,-80
    8000510a:	e486                	sd	ra,72(sp)
    8000510c:	e0a2                	sd	s0,64(sp)
    8000510e:	fc26                	sd	s1,56(sp)
    80005110:	f84a                	sd	s2,48(sp)
    80005112:	f44e                	sd	s3,40(sp)
    80005114:	f052                	sd	s4,32(sp)
    80005116:	ec56                	sd	s5,24(sp)
    80005118:	e85a                	sd	s6,16(sp)
    8000511a:	e45e                	sd	s7,8(sp)
    8000511c:	e062                	sd	s8,0(sp)
    8000511e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80005120:	00954783          	lbu	a5,9(a0)
    80005124:	10078663          	beqz	a5,80005230 <filewrite+0x128>
    80005128:	892a                	mv	s2,a0
    8000512a:	8aae                	mv	s5,a1
    8000512c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000512e:	411c                	lw	a5,0(a0)
    80005130:	4705                	li	a4,1
    80005132:	02e78263          	beq	a5,a4,80005156 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005136:	470d                	li	a4,3
    80005138:	02e78663          	beq	a5,a4,80005164 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000513c:	4709                	li	a4,2
    8000513e:	0ee79163          	bne	a5,a4,80005220 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005142:	0ac05d63          	blez	a2,800051fc <filewrite+0xf4>
    int i = 0;
    80005146:	4981                	li	s3,0
    80005148:	6b05                	lui	s6,0x1
    8000514a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000514e:	6b85                	lui	s7,0x1
    80005150:	c00b8b9b          	addiw	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005154:	a861                	j	800051ec <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80005156:	6908                	ld	a0,16(a0)
    80005158:	00000097          	auipc	ra,0x0
    8000515c:	22e080e7          	jalr	558(ra) # 80005386 <pipewrite>
    80005160:	8a2a                	mv	s4,a0
    80005162:	a045                	j	80005202 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005164:	02451783          	lh	a5,36(a0)
    80005168:	03079693          	slli	a3,a5,0x30
    8000516c:	92c1                	srli	a3,a3,0x30
    8000516e:	4725                	li	a4,9
    80005170:	0cd76263          	bltu	a4,a3,80005234 <filewrite+0x12c>
    80005174:	0792                	slli	a5,a5,0x4
    80005176:	0001f717          	auipc	a4,0x1f
    8000517a:	2a270713          	addi	a4,a4,674 # 80024418 <devsw>
    8000517e:	97ba                	add	a5,a5,a4
    80005180:	679c                	ld	a5,8(a5)
    80005182:	cbdd                	beqz	a5,80005238 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80005184:	4505                	li	a0,1
    80005186:	9782                	jalr	a5
    80005188:	8a2a                	mv	s4,a0
    8000518a:	a8a5                	j	80005202 <filewrite+0xfa>
    8000518c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80005190:	00000097          	auipc	ra,0x0
    80005194:	8b0080e7          	jalr	-1872(ra) # 80004a40 <begin_op>
      ilock(f->ip);
    80005198:	01893503          	ld	a0,24(s2)
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	ee2080e7          	jalr	-286(ra) # 8000407e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800051a4:	8762                	mv	a4,s8
    800051a6:	02092683          	lw	a3,32(s2)
    800051aa:	01598633          	add	a2,s3,s5
    800051ae:	4585                	li	a1,1
    800051b0:	01893503          	ld	a0,24(s2)
    800051b4:	fffff097          	auipc	ra,0xfffff
    800051b8:	276080e7          	jalr	630(ra) # 8000442a <writei>
    800051bc:	84aa                	mv	s1,a0
    800051be:	00a05763          	blez	a0,800051cc <filewrite+0xc4>
        f->off += r;
    800051c2:	02092783          	lw	a5,32(s2)
    800051c6:	9fa9                	addw	a5,a5,a0
    800051c8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800051cc:	01893503          	ld	a0,24(s2)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	f70080e7          	jalr	-144(ra) # 80004140 <iunlock>
      end_op();
    800051d8:	00000097          	auipc	ra,0x0
    800051dc:	8e8080e7          	jalr	-1816(ra) # 80004ac0 <end_op>

      if(r != n1){
    800051e0:	009c1f63          	bne	s8,s1,800051fe <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800051e4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800051e8:	0149db63          	bge	s3,s4,800051fe <filewrite+0xf6>
      int n1 = n - i;
    800051ec:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800051f0:	84be                	mv	s1,a5
    800051f2:	2781                	sext.w	a5,a5
    800051f4:	f8fb5ce3          	bge	s6,a5,8000518c <filewrite+0x84>
    800051f8:	84de                	mv	s1,s7
    800051fa:	bf49                	j	8000518c <filewrite+0x84>
    int i = 0;
    800051fc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800051fe:	013a1f63          	bne	s4,s3,8000521c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005202:	8552                	mv	a0,s4
    80005204:	60a6                	ld	ra,72(sp)
    80005206:	6406                	ld	s0,64(sp)
    80005208:	74e2                	ld	s1,56(sp)
    8000520a:	7942                	ld	s2,48(sp)
    8000520c:	79a2                	ld	s3,40(sp)
    8000520e:	7a02                	ld	s4,32(sp)
    80005210:	6ae2                	ld	s5,24(sp)
    80005212:	6b42                	ld	s6,16(sp)
    80005214:	6ba2                	ld	s7,8(sp)
    80005216:	6c02                	ld	s8,0(sp)
    80005218:	6161                	addi	sp,sp,80
    8000521a:	8082                	ret
    ret = (i == n ? n : -1);
    8000521c:	5a7d                	li	s4,-1
    8000521e:	b7d5                	j	80005202 <filewrite+0xfa>
    panic("filewrite");
    80005220:	00003517          	auipc	a0,0x3
    80005224:	3c050513          	addi	a0,a0,960 # 800085e0 <etext+0x5e0>
    80005228:	ffffb097          	auipc	ra,0xffffb
    8000522c:	316080e7          	jalr	790(ra) # 8000053e <panic>
    return -1;
    80005230:	5a7d                	li	s4,-1
    80005232:	bfc1                	j	80005202 <filewrite+0xfa>
      return -1;
    80005234:	5a7d                	li	s4,-1
    80005236:	b7f1                	j	80005202 <filewrite+0xfa>
    80005238:	5a7d                	li	s4,-1
    8000523a:	b7e1                	j	80005202 <filewrite+0xfa>

000000008000523c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000523c:	7179                	addi	sp,sp,-48
    8000523e:	f406                	sd	ra,40(sp)
    80005240:	f022                	sd	s0,32(sp)
    80005242:	ec26                	sd	s1,24(sp)
    80005244:	e84a                	sd	s2,16(sp)
    80005246:	e44e                	sd	s3,8(sp)
    80005248:	e052                	sd	s4,0(sp)
    8000524a:	1800                	addi	s0,sp,48
    8000524c:	84aa                	mv	s1,a0
    8000524e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005250:	0005b023          	sd	zero,0(a1)
    80005254:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005258:	00000097          	auipc	ra,0x0
    8000525c:	bf8080e7          	jalr	-1032(ra) # 80004e50 <filealloc>
    80005260:	e088                	sd	a0,0(s1)
    80005262:	c551                	beqz	a0,800052ee <pipealloc+0xb2>
    80005264:	00000097          	auipc	ra,0x0
    80005268:	bec080e7          	jalr	-1044(ra) # 80004e50 <filealloc>
    8000526c:	00aa3023          	sd	a0,0(s4)
    80005270:	c92d                	beqz	a0,800052e2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	874080e7          	jalr	-1932(ra) # 80000ae6 <kalloc>
    8000527a:	892a                	mv	s2,a0
    8000527c:	c125                	beqz	a0,800052dc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000527e:	4985                	li	s3,1
    80005280:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005284:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005288:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000528c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005290:	00003597          	auipc	a1,0x3
    80005294:	36058593          	addi	a1,a1,864 # 800085f0 <etext+0x5f0>
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	8ae080e7          	jalr	-1874(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    800052a0:	609c                	ld	a5,0(s1)
    800052a2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800052a6:	609c                	ld	a5,0(s1)
    800052a8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800052ac:	609c                	ld	a5,0(s1)
    800052ae:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800052b2:	609c                	ld	a5,0(s1)
    800052b4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800052b8:	000a3783          	ld	a5,0(s4)
    800052bc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800052c0:	000a3783          	ld	a5,0(s4)
    800052c4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800052c8:	000a3783          	ld	a5,0(s4)
    800052cc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800052d0:	000a3783          	ld	a5,0(s4)
    800052d4:	0127b823          	sd	s2,16(a5)
  return 0;
    800052d8:	4501                	li	a0,0
    800052da:	a025                	j	80005302 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800052dc:	6088                	ld	a0,0(s1)
    800052de:	e501                	bnez	a0,800052e6 <pipealloc+0xaa>
    800052e0:	a039                	j	800052ee <pipealloc+0xb2>
    800052e2:	6088                	ld	a0,0(s1)
    800052e4:	c51d                	beqz	a0,80005312 <pipealloc+0xd6>
    fileclose(*f0);
    800052e6:	00000097          	auipc	ra,0x0
    800052ea:	c26080e7          	jalr	-986(ra) # 80004f0c <fileclose>
  if(*f1)
    800052ee:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800052f2:	557d                	li	a0,-1
  if(*f1)
    800052f4:	c799                	beqz	a5,80005302 <pipealloc+0xc6>
    fileclose(*f1);
    800052f6:	853e                	mv	a0,a5
    800052f8:	00000097          	auipc	ra,0x0
    800052fc:	c14080e7          	jalr	-1004(ra) # 80004f0c <fileclose>
  return -1;
    80005300:	557d                	li	a0,-1
}
    80005302:	70a2                	ld	ra,40(sp)
    80005304:	7402                	ld	s0,32(sp)
    80005306:	64e2                	ld	s1,24(sp)
    80005308:	6942                	ld	s2,16(sp)
    8000530a:	69a2                	ld	s3,8(sp)
    8000530c:	6a02                	ld	s4,0(sp)
    8000530e:	6145                	addi	sp,sp,48
    80005310:	8082                	ret
  return -1;
    80005312:	557d                	li	a0,-1
    80005314:	b7fd                	j	80005302 <pipealloc+0xc6>

0000000080005316 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005316:	1101                	addi	sp,sp,-32
    80005318:	ec06                	sd	ra,24(sp)
    8000531a:	e822                	sd	s0,16(sp)
    8000531c:	e426                	sd	s1,8(sp)
    8000531e:	e04a                	sd	s2,0(sp)
    80005320:	1000                	addi	s0,sp,32
    80005322:	84aa                	mv	s1,a0
    80005324:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005326:	ffffc097          	auipc	ra,0xffffc
    8000532a:	8b0080e7          	jalr	-1872(ra) # 80000bd6 <acquire>
  if(writable){
    8000532e:	02090d63          	beqz	s2,80005368 <pipeclose+0x52>
    pi->writeopen = 0;
    80005332:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005336:	21848513          	addi	a0,s1,536
    8000533a:	ffffd097          	auipc	ra,0xffffd
    8000533e:	1fa080e7          	jalr	506(ra) # 80002534 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005342:	2204b783          	ld	a5,544(s1)
    80005346:	eb95                	bnez	a5,8000537a <pipeclose+0x64>
    release(&pi->lock);
    80005348:	8526                	mv	a0,s1
    8000534a:	ffffc097          	auipc	ra,0xffffc
    8000534e:	940080e7          	jalr	-1728(ra) # 80000c8a <release>
    kfree((char*)pi);
    80005352:	8526                	mv	a0,s1
    80005354:	ffffb097          	auipc	ra,0xffffb
    80005358:	696080e7          	jalr	1686(ra) # 800009ea <kfree>
  } else
    release(&pi->lock);
}
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	64a2                	ld	s1,8(sp)
    80005362:	6902                	ld	s2,0(sp)
    80005364:	6105                	addi	sp,sp,32
    80005366:	8082                	ret
    pi->readopen = 0;
    80005368:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000536c:	21c48513          	addi	a0,s1,540
    80005370:	ffffd097          	auipc	ra,0xffffd
    80005374:	1c4080e7          	jalr	452(ra) # 80002534 <wakeup>
    80005378:	b7e9                	j	80005342 <pipeclose+0x2c>
    release(&pi->lock);
    8000537a:	8526                	mv	a0,s1
    8000537c:	ffffc097          	auipc	ra,0xffffc
    80005380:	90e080e7          	jalr	-1778(ra) # 80000c8a <release>
}
    80005384:	bfe1                	j	8000535c <pipeclose+0x46>

0000000080005386 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005386:	711d                	addi	sp,sp,-96
    80005388:	ec86                	sd	ra,88(sp)
    8000538a:	e8a2                	sd	s0,80(sp)
    8000538c:	e4a6                	sd	s1,72(sp)
    8000538e:	e0ca                	sd	s2,64(sp)
    80005390:	fc4e                	sd	s3,56(sp)
    80005392:	f852                	sd	s4,48(sp)
    80005394:	f456                	sd	s5,40(sp)
    80005396:	f05a                	sd	s6,32(sp)
    80005398:	ec5e                	sd	s7,24(sp)
    8000539a:	e862                	sd	s8,16(sp)
    8000539c:	1080                	addi	s0,sp,96
    8000539e:	84aa                	mv	s1,a0
    800053a0:	8aae                	mv	s5,a1
    800053a2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800053a4:	ffffc097          	auipc	ra,0xffffc
    800053a8:	63c080e7          	jalr	1596(ra) # 800019e0 <myproc>
    800053ac:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800053ae:	8526                	mv	a0,s1
    800053b0:	ffffc097          	auipc	ra,0xffffc
    800053b4:	826080e7          	jalr	-2010(ra) # 80000bd6 <acquire>
  while(i < n){
    800053b8:	0b405663          	blez	s4,80005464 <pipewrite+0xde>
  int i = 0;
    800053bc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800053be:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800053c0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800053c4:	21c48b93          	addi	s7,s1,540
    800053c8:	a089                	j	8000540a <pipewrite+0x84>
      release(&pi->lock);
    800053ca:	8526                	mv	a0,s1
    800053cc:	ffffc097          	auipc	ra,0xffffc
    800053d0:	8be080e7          	jalr	-1858(ra) # 80000c8a <release>
      return -1;
    800053d4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800053d6:	854a                	mv	a0,s2
    800053d8:	60e6                	ld	ra,88(sp)
    800053da:	6446                	ld	s0,80(sp)
    800053dc:	64a6                	ld	s1,72(sp)
    800053de:	6906                	ld	s2,64(sp)
    800053e0:	79e2                	ld	s3,56(sp)
    800053e2:	7a42                	ld	s4,48(sp)
    800053e4:	7aa2                	ld	s5,40(sp)
    800053e6:	7b02                	ld	s6,32(sp)
    800053e8:	6be2                	ld	s7,24(sp)
    800053ea:	6c42                	ld	s8,16(sp)
    800053ec:	6125                	addi	sp,sp,96
    800053ee:	8082                	ret
      wakeup(&pi->nread);
    800053f0:	8562                	mv	a0,s8
    800053f2:	ffffd097          	auipc	ra,0xffffd
    800053f6:	142080e7          	jalr	322(ra) # 80002534 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800053fa:	85a6                	mv	a1,s1
    800053fc:	855e                	mv	a0,s7
    800053fe:	ffffd097          	auipc	ra,0xffffd
    80005402:	0d2080e7          	jalr	210(ra) # 800024d0 <sleep>
  while(i < n){
    80005406:	07495063          	bge	s2,s4,80005466 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000540a:	2204a783          	lw	a5,544(s1)
    8000540e:	dfd5                	beqz	a5,800053ca <pipewrite+0x44>
    80005410:	854e                	mv	a0,s3
    80005412:	ffffd097          	auipc	ra,0xffffd
    80005416:	3b4080e7          	jalr	948(ra) # 800027c6 <killed>
    8000541a:	f945                	bnez	a0,800053ca <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000541c:	2184a783          	lw	a5,536(s1)
    80005420:	21c4a703          	lw	a4,540(s1)
    80005424:	2007879b          	addiw	a5,a5,512
    80005428:	fcf704e3          	beq	a4,a5,800053f0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000542c:	4685                	li	a3,1
    8000542e:	01590633          	add	a2,s2,s5
    80005432:	faf40593          	addi	a1,s0,-81
    80005436:	0509b503          	ld	a0,80(s3)
    8000543a:	ffffc097          	auipc	ra,0xffffc
    8000543e:	2ba080e7          	jalr	698(ra) # 800016f4 <copyin>
    80005442:	03650263          	beq	a0,s6,80005466 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005446:	21c4a783          	lw	a5,540(s1)
    8000544a:	0017871b          	addiw	a4,a5,1
    8000544e:	20e4ae23          	sw	a4,540(s1)
    80005452:	1ff7f793          	andi	a5,a5,511
    80005456:	97a6                	add	a5,a5,s1
    80005458:	faf44703          	lbu	a4,-81(s0)
    8000545c:	00e78c23          	sb	a4,24(a5)
      i++;
    80005460:	2905                	addiw	s2,s2,1
    80005462:	b755                	j	80005406 <pipewrite+0x80>
  int i = 0;
    80005464:	4901                	li	s2,0
  wakeup(&pi->nread);
    80005466:	21848513          	addi	a0,s1,536
    8000546a:	ffffd097          	auipc	ra,0xffffd
    8000546e:	0ca080e7          	jalr	202(ra) # 80002534 <wakeup>
  release(&pi->lock);
    80005472:	8526                	mv	a0,s1
    80005474:	ffffc097          	auipc	ra,0xffffc
    80005478:	816080e7          	jalr	-2026(ra) # 80000c8a <release>
  return i;
    8000547c:	bfa9                	j	800053d6 <pipewrite+0x50>

000000008000547e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000547e:	715d                	addi	sp,sp,-80
    80005480:	e486                	sd	ra,72(sp)
    80005482:	e0a2                	sd	s0,64(sp)
    80005484:	fc26                	sd	s1,56(sp)
    80005486:	f84a                	sd	s2,48(sp)
    80005488:	f44e                	sd	s3,40(sp)
    8000548a:	f052                	sd	s4,32(sp)
    8000548c:	ec56                	sd	s5,24(sp)
    8000548e:	e85a                	sd	s6,16(sp)
    80005490:	0880                	addi	s0,sp,80
    80005492:	84aa                	mv	s1,a0
    80005494:	892e                	mv	s2,a1
    80005496:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005498:	ffffc097          	auipc	ra,0xffffc
    8000549c:	548080e7          	jalr	1352(ra) # 800019e0 <myproc>
    800054a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800054a2:	8526                	mv	a0,s1
    800054a4:	ffffb097          	auipc	ra,0xffffb
    800054a8:	732080e7          	jalr	1842(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800054ac:	2184a703          	lw	a4,536(s1)
    800054b0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800054b4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800054b8:	02f71763          	bne	a4,a5,800054e6 <piperead+0x68>
    800054bc:	2244a783          	lw	a5,548(s1)
    800054c0:	c39d                	beqz	a5,800054e6 <piperead+0x68>
    if(killed(pr)){
    800054c2:	8552                	mv	a0,s4
    800054c4:	ffffd097          	auipc	ra,0xffffd
    800054c8:	302080e7          	jalr	770(ra) # 800027c6 <killed>
    800054cc:	e941                	bnez	a0,8000555c <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800054ce:	85a6                	mv	a1,s1
    800054d0:	854e                	mv	a0,s3
    800054d2:	ffffd097          	auipc	ra,0xffffd
    800054d6:	ffe080e7          	jalr	-2(ra) # 800024d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800054da:	2184a703          	lw	a4,536(s1)
    800054de:	21c4a783          	lw	a5,540(s1)
    800054e2:	fcf70de3          	beq	a4,a5,800054bc <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800054e6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800054e8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800054ea:	05505363          	blez	s5,80005530 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800054ee:	2184a783          	lw	a5,536(s1)
    800054f2:	21c4a703          	lw	a4,540(s1)
    800054f6:	02f70d63          	beq	a4,a5,80005530 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800054fa:	0017871b          	addiw	a4,a5,1
    800054fe:	20e4ac23          	sw	a4,536(s1)
    80005502:	1ff7f793          	andi	a5,a5,511
    80005506:	97a6                	add	a5,a5,s1
    80005508:	0187c783          	lbu	a5,24(a5)
    8000550c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005510:	4685                	li	a3,1
    80005512:	fbf40613          	addi	a2,s0,-65
    80005516:	85ca                	mv	a1,s2
    80005518:	050a3503          	ld	a0,80(s4)
    8000551c:	ffffc097          	auipc	ra,0xffffc
    80005520:	14c080e7          	jalr	332(ra) # 80001668 <copyout>
    80005524:	01650663          	beq	a0,s6,80005530 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005528:	2985                	addiw	s3,s3,1
    8000552a:	0905                	addi	s2,s2,1
    8000552c:	fd3a91e3          	bne	s5,s3,800054ee <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005530:	21c48513          	addi	a0,s1,540
    80005534:	ffffd097          	auipc	ra,0xffffd
    80005538:	000080e7          	jalr	ra # 80002534 <wakeup>
  release(&pi->lock);
    8000553c:	8526                	mv	a0,s1
    8000553e:	ffffb097          	auipc	ra,0xffffb
    80005542:	74c080e7          	jalr	1868(ra) # 80000c8a <release>
  return i;
}
    80005546:	854e                	mv	a0,s3
    80005548:	60a6                	ld	ra,72(sp)
    8000554a:	6406                	ld	s0,64(sp)
    8000554c:	74e2                	ld	s1,56(sp)
    8000554e:	7942                	ld	s2,48(sp)
    80005550:	79a2                	ld	s3,40(sp)
    80005552:	7a02                	ld	s4,32(sp)
    80005554:	6ae2                	ld	s5,24(sp)
    80005556:	6b42                	ld	s6,16(sp)
    80005558:	6161                	addi	sp,sp,80
    8000555a:	8082                	ret
      release(&pi->lock);
    8000555c:	8526                	mv	a0,s1
    8000555e:	ffffb097          	auipc	ra,0xffffb
    80005562:	72c080e7          	jalr	1836(ra) # 80000c8a <release>
      return -1;
    80005566:	59fd                	li	s3,-1
    80005568:	bff9                	j	80005546 <piperead+0xc8>

000000008000556a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000556a:	1141                	addi	sp,sp,-16
    8000556c:	e422                	sd	s0,8(sp)
    8000556e:	0800                	addi	s0,sp,16
    80005570:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005572:	8905                	andi	a0,a0,1
    80005574:	c111                	beqz	a0,80005578 <flags2perm+0xe>
      perm = PTE_X;
    80005576:	4521                	li	a0,8
    if(flags & 0x2)
    80005578:	8b89                	andi	a5,a5,2
    8000557a:	c399                	beqz	a5,80005580 <flags2perm+0x16>
      perm |= PTE_W;
    8000557c:	00456513          	ori	a0,a0,4
    return perm;
}
    80005580:	6422                	ld	s0,8(sp)
    80005582:	0141                	addi	sp,sp,16
    80005584:	8082                	ret

0000000080005586 <exec>:

int
exec(char *path, char **argv)
{
    80005586:	de010113          	addi	sp,sp,-544
    8000558a:	20113c23          	sd	ra,536(sp)
    8000558e:	20813823          	sd	s0,528(sp)
    80005592:	20913423          	sd	s1,520(sp)
    80005596:	21213023          	sd	s2,512(sp)
    8000559a:	ffce                	sd	s3,504(sp)
    8000559c:	fbd2                	sd	s4,496(sp)
    8000559e:	f7d6                	sd	s5,488(sp)
    800055a0:	f3da                	sd	s6,480(sp)
    800055a2:	efde                	sd	s7,472(sp)
    800055a4:	ebe2                	sd	s8,464(sp)
    800055a6:	e7e6                	sd	s9,456(sp)
    800055a8:	e3ea                	sd	s10,448(sp)
    800055aa:	ff6e                	sd	s11,440(sp)
    800055ac:	1400                	addi	s0,sp,544
    800055ae:	892a                	mv	s2,a0
    800055b0:	dea43423          	sd	a0,-536(s0)
    800055b4:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800055b8:	ffffc097          	auipc	ra,0xffffc
    800055bc:	428080e7          	jalr	1064(ra) # 800019e0 <myproc>
    800055c0:	84aa                	mv	s1,a0

  begin_op();
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	47e080e7          	jalr	1150(ra) # 80004a40 <begin_op>

  if((ip = namei(path)) == 0){
    800055ca:	854a                	mv	a0,s2
    800055cc:	fffff097          	auipc	ra,0xfffff
    800055d0:	258080e7          	jalr	600(ra) # 80004824 <namei>
    800055d4:	c93d                	beqz	a0,8000564a <exec+0xc4>
    800055d6:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800055d8:	fffff097          	auipc	ra,0xfffff
    800055dc:	aa6080e7          	jalr	-1370(ra) # 8000407e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800055e0:	04000713          	li	a4,64
    800055e4:	4681                	li	a3,0
    800055e6:	e5040613          	addi	a2,s0,-432
    800055ea:	4581                	li	a1,0
    800055ec:	8556                	mv	a0,s5
    800055ee:	fffff097          	auipc	ra,0xfffff
    800055f2:	d44080e7          	jalr	-700(ra) # 80004332 <readi>
    800055f6:	04000793          	li	a5,64
    800055fa:	00f51a63          	bne	a0,a5,8000560e <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800055fe:	e5042703          	lw	a4,-432(s0)
    80005602:	464c47b7          	lui	a5,0x464c4
    80005606:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000560a:	04f70663          	beq	a4,a5,80005656 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000560e:	8556                	mv	a0,s5
    80005610:	fffff097          	auipc	ra,0xfffff
    80005614:	cd0080e7          	jalr	-816(ra) # 800042e0 <iunlockput>
    end_op();
    80005618:	fffff097          	auipc	ra,0xfffff
    8000561c:	4a8080e7          	jalr	1192(ra) # 80004ac0 <end_op>
  }
  return -1;
    80005620:	557d                	li	a0,-1
}
    80005622:	21813083          	ld	ra,536(sp)
    80005626:	21013403          	ld	s0,528(sp)
    8000562a:	20813483          	ld	s1,520(sp)
    8000562e:	20013903          	ld	s2,512(sp)
    80005632:	79fe                	ld	s3,504(sp)
    80005634:	7a5e                	ld	s4,496(sp)
    80005636:	7abe                	ld	s5,488(sp)
    80005638:	7b1e                	ld	s6,480(sp)
    8000563a:	6bfe                	ld	s7,472(sp)
    8000563c:	6c5e                	ld	s8,464(sp)
    8000563e:	6cbe                	ld	s9,456(sp)
    80005640:	6d1e                	ld	s10,448(sp)
    80005642:	7dfa                	ld	s11,440(sp)
    80005644:	22010113          	addi	sp,sp,544
    80005648:	8082                	ret
    end_op();
    8000564a:	fffff097          	auipc	ra,0xfffff
    8000564e:	476080e7          	jalr	1142(ra) # 80004ac0 <end_op>
    return -1;
    80005652:	557d                	li	a0,-1
    80005654:	b7f9                	j	80005622 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80005656:	8526                	mv	a0,s1
    80005658:	ffffc097          	auipc	ra,0xffffc
    8000565c:	44c080e7          	jalr	1100(ra) # 80001aa4 <proc_pagetable>
    80005660:	8b2a                	mv	s6,a0
    80005662:	d555                	beqz	a0,8000560e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005664:	e7042783          	lw	a5,-400(s0)
    80005668:	e8845703          	lhu	a4,-376(s0)
    8000566c:	c735                	beqz	a4,800056d8 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000566e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005670:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005674:	6a05                	lui	s4,0x1
    80005676:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000567a:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000567e:	6d85                	lui	s11,0x1
    80005680:	7d7d                	lui	s10,0xfffff
    80005682:	a481                	j	800058c2 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005684:	00003517          	auipc	a0,0x3
    80005688:	f7450513          	addi	a0,a0,-140 # 800085f8 <etext+0x5f8>
    8000568c:	ffffb097          	auipc	ra,0xffffb
    80005690:	eb2080e7          	jalr	-334(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005694:	874a                	mv	a4,s2
    80005696:	009c86bb          	addw	a3,s9,s1
    8000569a:	4581                	li	a1,0
    8000569c:	8556                	mv	a0,s5
    8000569e:	fffff097          	auipc	ra,0xfffff
    800056a2:	c94080e7          	jalr	-876(ra) # 80004332 <readi>
    800056a6:	2501                	sext.w	a0,a0
    800056a8:	1aa91a63          	bne	s2,a0,8000585c <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    800056ac:	009d84bb          	addw	s1,s11,s1
    800056b0:	013d09bb          	addw	s3,s10,s3
    800056b4:	1f74f763          	bgeu	s1,s7,800058a2 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800056b8:	02049593          	slli	a1,s1,0x20
    800056bc:	9181                	srli	a1,a1,0x20
    800056be:	95e2                	add	a1,a1,s8
    800056c0:	855a                	mv	a0,s6
    800056c2:	ffffc097          	auipc	ra,0xffffc
    800056c6:	99a080e7          	jalr	-1638(ra) # 8000105c <walkaddr>
    800056ca:	862a                	mv	a2,a0
    if(pa == 0)
    800056cc:	dd45                	beqz	a0,80005684 <exec+0xfe>
      n = PGSIZE;
    800056ce:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800056d0:	fd49f2e3          	bgeu	s3,s4,80005694 <exec+0x10e>
      n = sz - i;
    800056d4:	894e                	mv	s2,s3
    800056d6:	bf7d                	j	80005694 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800056d8:	4901                	li	s2,0
  iunlockput(ip);
    800056da:	8556                	mv	a0,s5
    800056dc:	fffff097          	auipc	ra,0xfffff
    800056e0:	c04080e7          	jalr	-1020(ra) # 800042e0 <iunlockput>
  end_op();
    800056e4:	fffff097          	auipc	ra,0xfffff
    800056e8:	3dc080e7          	jalr	988(ra) # 80004ac0 <end_op>
  p = myproc();
    800056ec:	ffffc097          	auipc	ra,0xffffc
    800056f0:	2f4080e7          	jalr	756(ra) # 800019e0 <myproc>
    800056f4:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800056f6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800056fa:	6785                	lui	a5,0x1
    800056fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800056fe:	993e                	add	s2,s2,a5
    80005700:	77fd                	lui	a5,0xfffff
    80005702:	00f977b3          	and	a5,s2,a5
    80005706:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000570a:	4691                	li	a3,4
    8000570c:	6609                	lui	a2,0x2
    8000570e:	963e                	add	a2,a2,a5
    80005710:	85be                	mv	a1,a5
    80005712:	855a                	mv	a0,s6
    80005714:	ffffc097          	auipc	ra,0xffffc
    80005718:	cfc080e7          	jalr	-772(ra) # 80001410 <uvmalloc>
    8000571c:	8c2a                	mv	s8,a0
  ip = 0;
    8000571e:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005720:	12050e63          	beqz	a0,8000585c <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005724:	75f9                	lui	a1,0xffffe
    80005726:	95aa                	add	a1,a1,a0
    80005728:	855a                	mv	a0,s6
    8000572a:	ffffc097          	auipc	ra,0xffffc
    8000572e:	f0c080e7          	jalr	-244(ra) # 80001636 <uvmclear>
  stackbase = sp - PGSIZE;
    80005732:	7afd                	lui	s5,0xfffff
    80005734:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005736:	df043783          	ld	a5,-528(s0)
    8000573a:	6388                	ld	a0,0(a5)
    8000573c:	c925                	beqz	a0,800057ac <exec+0x226>
    8000573e:	e9040993          	addi	s3,s0,-368
    80005742:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80005746:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005748:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000574a:	ffffb097          	auipc	ra,0xffffb
    8000574e:	704080e7          	jalr	1796(ra) # 80000e4e <strlen>
    80005752:	0015079b          	addiw	a5,a0,1
    80005756:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000575a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000575e:	13596663          	bltu	s2,s5,8000588a <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005762:	df043d83          	ld	s11,-528(s0)
    80005766:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000576a:	8552                	mv	a0,s4
    8000576c:	ffffb097          	auipc	ra,0xffffb
    80005770:	6e2080e7          	jalr	1762(ra) # 80000e4e <strlen>
    80005774:	0015069b          	addiw	a3,a0,1
    80005778:	8652                	mv	a2,s4
    8000577a:	85ca                	mv	a1,s2
    8000577c:	855a                	mv	a0,s6
    8000577e:	ffffc097          	auipc	ra,0xffffc
    80005782:	eea080e7          	jalr	-278(ra) # 80001668 <copyout>
    80005786:	10054663          	bltz	a0,80005892 <exec+0x30c>
    ustack[argc] = sp;
    8000578a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000578e:	0485                	addi	s1,s1,1
    80005790:	008d8793          	addi	a5,s11,8
    80005794:	def43823          	sd	a5,-528(s0)
    80005798:	008db503          	ld	a0,8(s11)
    8000579c:	c911                	beqz	a0,800057b0 <exec+0x22a>
    if(argc >= MAXARG)
    8000579e:	09a1                	addi	s3,s3,8
    800057a0:	fb3c95e3          	bne	s9,s3,8000574a <exec+0x1c4>
  sz = sz1;
    800057a4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800057a8:	4a81                	li	s5,0
    800057aa:	a84d                	j	8000585c <exec+0x2d6>
  sp = sz;
    800057ac:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800057ae:	4481                	li	s1,0
  ustack[argc] = 0;
    800057b0:	00349793          	slli	a5,s1,0x3
    800057b4:	f9040713          	addi	a4,s0,-112
    800057b8:	97ba                	add	a5,a5,a4
    800057ba:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffd9950>
  sp -= (argc+1) * sizeof(uint64);
    800057be:	00148693          	addi	a3,s1,1
    800057c2:	068e                	slli	a3,a3,0x3
    800057c4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800057c8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800057cc:	01597663          	bgeu	s2,s5,800057d8 <exec+0x252>
  sz = sz1;
    800057d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800057d4:	4a81                	li	s5,0
    800057d6:	a059                	j	8000585c <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800057d8:	e9040613          	addi	a2,s0,-368
    800057dc:	85ca                	mv	a1,s2
    800057de:	855a                	mv	a0,s6
    800057e0:	ffffc097          	auipc	ra,0xffffc
    800057e4:	e88080e7          	jalr	-376(ra) # 80001668 <copyout>
    800057e8:	0a054963          	bltz	a0,8000589a <exec+0x314>
  p->trapframe->a1 = sp;
    800057ec:	058bb783          	ld	a5,88(s7)
    800057f0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800057f4:	de843783          	ld	a5,-536(s0)
    800057f8:	0007c703          	lbu	a4,0(a5)
    800057fc:	cf11                	beqz	a4,80005818 <exec+0x292>
    800057fe:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005800:	02f00693          	li	a3,47
    80005804:	a039                	j	80005812 <exec+0x28c>
      last = s+1;
    80005806:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000580a:	0785                	addi	a5,a5,1
    8000580c:	fff7c703          	lbu	a4,-1(a5)
    80005810:	c701                	beqz	a4,80005818 <exec+0x292>
    if(*s == '/')
    80005812:	fed71ce3          	bne	a4,a3,8000580a <exec+0x284>
    80005816:	bfc5                	j	80005806 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80005818:	4641                	li	a2,16
    8000581a:	de843583          	ld	a1,-536(s0)
    8000581e:	158b8513          	addi	a0,s7,344
    80005822:	ffffb097          	auipc	ra,0xffffb
    80005826:	5fa080e7          	jalr	1530(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    8000582a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000582e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005832:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005836:	058bb783          	ld	a5,88(s7)
    8000583a:	e6843703          	ld	a4,-408(s0)
    8000583e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005840:	058bb783          	ld	a5,88(s7)
    80005844:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005848:	85ea                	mv	a1,s10
    8000584a:	ffffc097          	auipc	ra,0xffffc
    8000584e:	2f6080e7          	jalr	758(ra) # 80001b40 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005852:	0004851b          	sext.w	a0,s1
    80005856:	b3f1                	j	80005622 <exec+0x9c>
    80005858:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000585c:	df843583          	ld	a1,-520(s0)
    80005860:	855a                	mv	a0,s6
    80005862:	ffffc097          	auipc	ra,0xffffc
    80005866:	2de080e7          	jalr	734(ra) # 80001b40 <proc_freepagetable>
  if(ip){
    8000586a:	da0a92e3          	bnez	s5,8000560e <exec+0x88>
  return -1;
    8000586e:	557d                	li	a0,-1
    80005870:	bb4d                	j	80005622 <exec+0x9c>
    80005872:	df243c23          	sd	s2,-520(s0)
    80005876:	b7dd                	j	8000585c <exec+0x2d6>
    80005878:	df243c23          	sd	s2,-520(s0)
    8000587c:	b7c5                	j	8000585c <exec+0x2d6>
    8000587e:	df243c23          	sd	s2,-520(s0)
    80005882:	bfe9                	j	8000585c <exec+0x2d6>
    80005884:	df243c23          	sd	s2,-520(s0)
    80005888:	bfd1                	j	8000585c <exec+0x2d6>
  sz = sz1;
    8000588a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000588e:	4a81                	li	s5,0
    80005890:	b7f1                	j	8000585c <exec+0x2d6>
  sz = sz1;
    80005892:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005896:	4a81                	li	s5,0
    80005898:	b7d1                	j	8000585c <exec+0x2d6>
  sz = sz1;
    8000589a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000589e:	4a81                	li	s5,0
    800058a0:	bf75                	j	8000585c <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800058a2:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800058a6:	e0843783          	ld	a5,-504(s0)
    800058aa:	0017869b          	addiw	a3,a5,1
    800058ae:	e0d43423          	sd	a3,-504(s0)
    800058b2:	e0043783          	ld	a5,-512(s0)
    800058b6:	0387879b          	addiw	a5,a5,56
    800058ba:	e8845703          	lhu	a4,-376(s0)
    800058be:	e0e6dee3          	bge	a3,a4,800056da <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800058c2:	2781                	sext.w	a5,a5
    800058c4:	e0f43023          	sd	a5,-512(s0)
    800058c8:	03800713          	li	a4,56
    800058cc:	86be                	mv	a3,a5
    800058ce:	e1840613          	addi	a2,s0,-488
    800058d2:	4581                	li	a1,0
    800058d4:	8556                	mv	a0,s5
    800058d6:	fffff097          	auipc	ra,0xfffff
    800058da:	a5c080e7          	jalr	-1444(ra) # 80004332 <readi>
    800058de:	03800793          	li	a5,56
    800058e2:	f6f51be3          	bne	a0,a5,80005858 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800058e6:	e1842783          	lw	a5,-488(s0)
    800058ea:	4705                	li	a4,1
    800058ec:	fae79de3          	bne	a5,a4,800058a6 <exec+0x320>
    if(ph.memsz < ph.filesz)
    800058f0:	e4043483          	ld	s1,-448(s0)
    800058f4:	e3843783          	ld	a5,-456(s0)
    800058f8:	f6f4ede3          	bltu	s1,a5,80005872 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800058fc:	e2843783          	ld	a5,-472(s0)
    80005900:	94be                	add	s1,s1,a5
    80005902:	f6f4ebe3          	bltu	s1,a5,80005878 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80005906:	de043703          	ld	a4,-544(s0)
    8000590a:	8ff9                	and	a5,a5,a4
    8000590c:	fbad                	bnez	a5,8000587e <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000590e:	e1c42503          	lw	a0,-484(s0)
    80005912:	00000097          	auipc	ra,0x0
    80005916:	c58080e7          	jalr	-936(ra) # 8000556a <flags2perm>
    8000591a:	86aa                	mv	a3,a0
    8000591c:	8626                	mv	a2,s1
    8000591e:	85ca                	mv	a1,s2
    80005920:	855a                	mv	a0,s6
    80005922:	ffffc097          	auipc	ra,0xffffc
    80005926:	aee080e7          	jalr	-1298(ra) # 80001410 <uvmalloc>
    8000592a:	dea43c23          	sd	a0,-520(s0)
    8000592e:	d939                	beqz	a0,80005884 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005930:	e2843c03          	ld	s8,-472(s0)
    80005934:	e2042c83          	lw	s9,-480(s0)
    80005938:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000593c:	f60b83e3          	beqz	s7,800058a2 <exec+0x31c>
    80005940:	89de                	mv	s3,s7
    80005942:	4481                	li	s1,0
    80005944:	bb95                	j	800056b8 <exec+0x132>

0000000080005946 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005946:	7179                	addi	sp,sp,-48
    80005948:	f406                	sd	ra,40(sp)
    8000594a:	f022                	sd	s0,32(sp)
    8000594c:	ec26                	sd	s1,24(sp)
    8000594e:	e84a                	sd	s2,16(sp)
    80005950:	1800                	addi	s0,sp,48
    80005952:	892e                	mv	s2,a1
    80005954:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005956:	fdc40593          	addi	a1,s0,-36
    8000595a:	ffffe097          	auipc	ra,0xffffe
    8000595e:	97a080e7          	jalr	-1670(ra) # 800032d4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005962:	fdc42703          	lw	a4,-36(s0)
    80005966:	47bd                	li	a5,15
    80005968:	02e7eb63          	bltu	a5,a4,8000599e <argfd+0x58>
    8000596c:	ffffc097          	auipc	ra,0xffffc
    80005970:	074080e7          	jalr	116(ra) # 800019e0 <myproc>
    80005974:	fdc42703          	lw	a4,-36(s0)
    80005978:	01a70793          	addi	a5,a4,26
    8000597c:	078e                	slli	a5,a5,0x3
    8000597e:	953e                	add	a0,a0,a5
    80005980:	611c                	ld	a5,0(a0)
    80005982:	c385                	beqz	a5,800059a2 <argfd+0x5c>
    return -1;
  if(pfd)
    80005984:	00090463          	beqz	s2,8000598c <argfd+0x46>
    *pfd = fd;
    80005988:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000598c:	4501                	li	a0,0
  if(pf)
    8000598e:	c091                	beqz	s1,80005992 <argfd+0x4c>
    *pf = f;
    80005990:	e09c                	sd	a5,0(s1)
}
    80005992:	70a2                	ld	ra,40(sp)
    80005994:	7402                	ld	s0,32(sp)
    80005996:	64e2                	ld	s1,24(sp)
    80005998:	6942                	ld	s2,16(sp)
    8000599a:	6145                	addi	sp,sp,48
    8000599c:	8082                	ret
    return -1;
    8000599e:	557d                	li	a0,-1
    800059a0:	bfcd                	j	80005992 <argfd+0x4c>
    800059a2:	557d                	li	a0,-1
    800059a4:	b7fd                	j	80005992 <argfd+0x4c>

00000000800059a6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800059a6:	1101                	addi	sp,sp,-32
    800059a8:	ec06                	sd	ra,24(sp)
    800059aa:	e822                	sd	s0,16(sp)
    800059ac:	e426                	sd	s1,8(sp)
    800059ae:	1000                	addi	s0,sp,32
    800059b0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800059b2:	ffffc097          	auipc	ra,0xffffc
    800059b6:	02e080e7          	jalr	46(ra) # 800019e0 <myproc>
    800059ba:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800059bc:	0d050793          	addi	a5,a0,208
    800059c0:	4501                	li	a0,0
    800059c2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800059c4:	6398                	ld	a4,0(a5)
    800059c6:	cb19                	beqz	a4,800059dc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800059c8:	2505                	addiw	a0,a0,1
    800059ca:	07a1                	addi	a5,a5,8
    800059cc:	fed51ce3          	bne	a0,a3,800059c4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800059d0:	557d                	li	a0,-1
}
    800059d2:	60e2                	ld	ra,24(sp)
    800059d4:	6442                	ld	s0,16(sp)
    800059d6:	64a2                	ld	s1,8(sp)
    800059d8:	6105                	addi	sp,sp,32
    800059da:	8082                	ret
      p->ofile[fd] = f;
    800059dc:	01a50793          	addi	a5,a0,26
    800059e0:	078e                	slli	a5,a5,0x3
    800059e2:	963e                	add	a2,a2,a5
    800059e4:	e204                	sd	s1,0(a2)
      return fd;
    800059e6:	b7f5                	j	800059d2 <fdalloc+0x2c>

00000000800059e8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800059e8:	715d                	addi	sp,sp,-80
    800059ea:	e486                	sd	ra,72(sp)
    800059ec:	e0a2                	sd	s0,64(sp)
    800059ee:	fc26                	sd	s1,56(sp)
    800059f0:	f84a                	sd	s2,48(sp)
    800059f2:	f44e                	sd	s3,40(sp)
    800059f4:	f052                	sd	s4,32(sp)
    800059f6:	ec56                	sd	s5,24(sp)
    800059f8:	e85a                	sd	s6,16(sp)
    800059fa:	0880                	addi	s0,sp,80
    800059fc:	8b2e                	mv	s6,a1
    800059fe:	89b2                	mv	s3,a2
    80005a00:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005a02:	fb040593          	addi	a1,s0,-80
    80005a06:	fffff097          	auipc	ra,0xfffff
    80005a0a:	e3c080e7          	jalr	-452(ra) # 80004842 <nameiparent>
    80005a0e:	84aa                	mv	s1,a0
    80005a10:	14050f63          	beqz	a0,80005b6e <create+0x186>
    return 0;

  ilock(dp);
    80005a14:	ffffe097          	auipc	ra,0xffffe
    80005a18:	66a080e7          	jalr	1642(ra) # 8000407e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005a1c:	4601                	li	a2,0
    80005a1e:	fb040593          	addi	a1,s0,-80
    80005a22:	8526                	mv	a0,s1
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	b3e080e7          	jalr	-1218(ra) # 80004562 <dirlookup>
    80005a2c:	8aaa                	mv	s5,a0
    80005a2e:	c931                	beqz	a0,80005a82 <create+0x9a>
    iunlockput(dp);
    80005a30:	8526                	mv	a0,s1
    80005a32:	fffff097          	auipc	ra,0xfffff
    80005a36:	8ae080e7          	jalr	-1874(ra) # 800042e0 <iunlockput>
    ilock(ip);
    80005a3a:	8556                	mv	a0,s5
    80005a3c:	ffffe097          	auipc	ra,0xffffe
    80005a40:	642080e7          	jalr	1602(ra) # 8000407e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005a44:	000b059b          	sext.w	a1,s6
    80005a48:	4789                	li	a5,2
    80005a4a:	02f59563          	bne	a1,a5,80005a74 <create+0x8c>
    80005a4e:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffd9a94>
    80005a52:	37f9                	addiw	a5,a5,-2
    80005a54:	17c2                	slli	a5,a5,0x30
    80005a56:	93c1                	srli	a5,a5,0x30
    80005a58:	4705                	li	a4,1
    80005a5a:	00f76d63          	bltu	a4,a5,80005a74 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005a5e:	8556                	mv	a0,s5
    80005a60:	60a6                	ld	ra,72(sp)
    80005a62:	6406                	ld	s0,64(sp)
    80005a64:	74e2                	ld	s1,56(sp)
    80005a66:	7942                	ld	s2,48(sp)
    80005a68:	79a2                	ld	s3,40(sp)
    80005a6a:	7a02                	ld	s4,32(sp)
    80005a6c:	6ae2                	ld	s5,24(sp)
    80005a6e:	6b42                	ld	s6,16(sp)
    80005a70:	6161                	addi	sp,sp,80
    80005a72:	8082                	ret
    iunlockput(ip);
    80005a74:	8556                	mv	a0,s5
    80005a76:	fffff097          	auipc	ra,0xfffff
    80005a7a:	86a080e7          	jalr	-1942(ra) # 800042e0 <iunlockput>
    return 0;
    80005a7e:	4a81                	li	s5,0
    80005a80:	bff9                	j	80005a5e <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005a82:	85da                	mv	a1,s6
    80005a84:	4088                	lw	a0,0(s1)
    80005a86:	ffffe097          	auipc	ra,0xffffe
    80005a8a:	45c080e7          	jalr	1116(ra) # 80003ee2 <ialloc>
    80005a8e:	8a2a                	mv	s4,a0
    80005a90:	c539                	beqz	a0,80005ade <create+0xf6>
  ilock(ip);
    80005a92:	ffffe097          	auipc	ra,0xffffe
    80005a96:	5ec080e7          	jalr	1516(ra) # 8000407e <ilock>
  ip->major = major;
    80005a9a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005a9e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005aa2:	4905                	li	s2,1
    80005aa4:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005aa8:	8552                	mv	a0,s4
    80005aaa:	ffffe097          	auipc	ra,0xffffe
    80005aae:	50a080e7          	jalr	1290(ra) # 80003fb4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005ab2:	000b059b          	sext.w	a1,s6
    80005ab6:	03258b63          	beq	a1,s2,80005aec <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005aba:	004a2603          	lw	a2,4(s4)
    80005abe:	fb040593          	addi	a1,s0,-80
    80005ac2:	8526                	mv	a0,s1
    80005ac4:	fffff097          	auipc	ra,0xfffff
    80005ac8:	cae080e7          	jalr	-850(ra) # 80004772 <dirlink>
    80005acc:	06054f63          	bltz	a0,80005b4a <create+0x162>
  iunlockput(dp);
    80005ad0:	8526                	mv	a0,s1
    80005ad2:	fffff097          	auipc	ra,0xfffff
    80005ad6:	80e080e7          	jalr	-2034(ra) # 800042e0 <iunlockput>
  return ip;
    80005ada:	8ad2                	mv	s5,s4
    80005adc:	b749                	j	80005a5e <create+0x76>
    iunlockput(dp);
    80005ade:	8526                	mv	a0,s1
    80005ae0:	fffff097          	auipc	ra,0xfffff
    80005ae4:	800080e7          	jalr	-2048(ra) # 800042e0 <iunlockput>
    return 0;
    80005ae8:	8ad2                	mv	s5,s4
    80005aea:	bf95                	j	80005a5e <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005aec:	004a2603          	lw	a2,4(s4)
    80005af0:	00003597          	auipc	a1,0x3
    80005af4:	b2858593          	addi	a1,a1,-1240 # 80008618 <etext+0x618>
    80005af8:	8552                	mv	a0,s4
    80005afa:	fffff097          	auipc	ra,0xfffff
    80005afe:	c78080e7          	jalr	-904(ra) # 80004772 <dirlink>
    80005b02:	04054463          	bltz	a0,80005b4a <create+0x162>
    80005b06:	40d0                	lw	a2,4(s1)
    80005b08:	00003597          	auipc	a1,0x3
    80005b0c:	b1858593          	addi	a1,a1,-1256 # 80008620 <etext+0x620>
    80005b10:	8552                	mv	a0,s4
    80005b12:	fffff097          	auipc	ra,0xfffff
    80005b16:	c60080e7          	jalr	-928(ra) # 80004772 <dirlink>
    80005b1a:	02054863          	bltz	a0,80005b4a <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005b1e:	004a2603          	lw	a2,4(s4)
    80005b22:	fb040593          	addi	a1,s0,-80
    80005b26:	8526                	mv	a0,s1
    80005b28:	fffff097          	auipc	ra,0xfffff
    80005b2c:	c4a080e7          	jalr	-950(ra) # 80004772 <dirlink>
    80005b30:	00054d63          	bltz	a0,80005b4a <create+0x162>
    dp->nlink++;  // for ".."
    80005b34:	04a4d783          	lhu	a5,74(s1)
    80005b38:	2785                	addiw	a5,a5,1
    80005b3a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b3e:	8526                	mv	a0,s1
    80005b40:	ffffe097          	auipc	ra,0xffffe
    80005b44:	474080e7          	jalr	1140(ra) # 80003fb4 <iupdate>
    80005b48:	b761                	j	80005ad0 <create+0xe8>
  ip->nlink = 0;
    80005b4a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005b4e:	8552                	mv	a0,s4
    80005b50:	ffffe097          	auipc	ra,0xffffe
    80005b54:	464080e7          	jalr	1124(ra) # 80003fb4 <iupdate>
  iunlockput(ip);
    80005b58:	8552                	mv	a0,s4
    80005b5a:	ffffe097          	auipc	ra,0xffffe
    80005b5e:	786080e7          	jalr	1926(ra) # 800042e0 <iunlockput>
  iunlockput(dp);
    80005b62:	8526                	mv	a0,s1
    80005b64:	ffffe097          	auipc	ra,0xffffe
    80005b68:	77c080e7          	jalr	1916(ra) # 800042e0 <iunlockput>
  return 0;
    80005b6c:	bdcd                	j	80005a5e <create+0x76>
    return 0;
    80005b6e:	8aaa                	mv	s5,a0
    80005b70:	b5fd                	j	80005a5e <create+0x76>

0000000080005b72 <sys_dup>:
{
    80005b72:	7179                	addi	sp,sp,-48
    80005b74:	f406                	sd	ra,40(sp)
    80005b76:	f022                	sd	s0,32(sp)
    80005b78:	ec26                	sd	s1,24(sp)
    80005b7a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005b7c:	fd840613          	addi	a2,s0,-40
    80005b80:	4581                	li	a1,0
    80005b82:	4501                	li	a0,0
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	dc2080e7          	jalr	-574(ra) # 80005946 <argfd>
    return -1;
    80005b8c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005b8e:	02054363          	bltz	a0,80005bb4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005b92:	fd843503          	ld	a0,-40(s0)
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	e10080e7          	jalr	-496(ra) # 800059a6 <fdalloc>
    80005b9e:	84aa                	mv	s1,a0
    return -1;
    80005ba0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005ba2:	00054963          	bltz	a0,80005bb4 <sys_dup+0x42>
  filedup(f);
    80005ba6:	fd843503          	ld	a0,-40(s0)
    80005baa:	fffff097          	auipc	ra,0xfffff
    80005bae:	310080e7          	jalr	784(ra) # 80004eba <filedup>
  return fd;
    80005bb2:	87a6                	mv	a5,s1
}
    80005bb4:	853e                	mv	a0,a5
    80005bb6:	70a2                	ld	ra,40(sp)
    80005bb8:	7402                	ld	s0,32(sp)
    80005bba:	64e2                	ld	s1,24(sp)
    80005bbc:	6145                	addi	sp,sp,48
    80005bbe:	8082                	ret

0000000080005bc0 <sys_read>:
{
    80005bc0:	7179                	addi	sp,sp,-48
    80005bc2:	f406                	sd	ra,40(sp)
    80005bc4:	f022                	sd	s0,32(sp)
    80005bc6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005bc8:	fd840593          	addi	a1,s0,-40
    80005bcc:	4505                	li	a0,1
    80005bce:	ffffd097          	auipc	ra,0xffffd
    80005bd2:	726080e7          	jalr	1830(ra) # 800032f4 <argaddr>
  argint(2, &n);
    80005bd6:	fe440593          	addi	a1,s0,-28
    80005bda:	4509                	li	a0,2
    80005bdc:	ffffd097          	auipc	ra,0xffffd
    80005be0:	6f8080e7          	jalr	1784(ra) # 800032d4 <argint>
  if(argfd(0, 0, &f) < 0)
    80005be4:	fe840613          	addi	a2,s0,-24
    80005be8:	4581                	li	a1,0
    80005bea:	4501                	li	a0,0
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	d5a080e7          	jalr	-678(ra) # 80005946 <argfd>
    80005bf4:	87aa                	mv	a5,a0
    return -1;
    80005bf6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005bf8:	0007cc63          	bltz	a5,80005c10 <sys_read+0x50>
  return fileread(f, p, n);
    80005bfc:	fe442603          	lw	a2,-28(s0)
    80005c00:	fd843583          	ld	a1,-40(s0)
    80005c04:	fe843503          	ld	a0,-24(s0)
    80005c08:	fffff097          	auipc	ra,0xfffff
    80005c0c:	43e080e7          	jalr	1086(ra) # 80005046 <fileread>
}
    80005c10:	70a2                	ld	ra,40(sp)
    80005c12:	7402                	ld	s0,32(sp)
    80005c14:	6145                	addi	sp,sp,48
    80005c16:	8082                	ret

0000000080005c18 <sys_write>:
{
    80005c18:	7179                	addi	sp,sp,-48
    80005c1a:	f406                	sd	ra,40(sp)
    80005c1c:	f022                	sd	s0,32(sp)
    80005c1e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005c20:	fd840593          	addi	a1,s0,-40
    80005c24:	4505                	li	a0,1
    80005c26:	ffffd097          	auipc	ra,0xffffd
    80005c2a:	6ce080e7          	jalr	1742(ra) # 800032f4 <argaddr>
  argint(2, &n);
    80005c2e:	fe440593          	addi	a1,s0,-28
    80005c32:	4509                	li	a0,2
    80005c34:	ffffd097          	auipc	ra,0xffffd
    80005c38:	6a0080e7          	jalr	1696(ra) # 800032d4 <argint>
  if(argfd(0, 0, &f) < 0)
    80005c3c:	fe840613          	addi	a2,s0,-24
    80005c40:	4581                	li	a1,0
    80005c42:	4501                	li	a0,0
    80005c44:	00000097          	auipc	ra,0x0
    80005c48:	d02080e7          	jalr	-766(ra) # 80005946 <argfd>
    80005c4c:	87aa                	mv	a5,a0
    return -1;
    80005c4e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c50:	0007cc63          	bltz	a5,80005c68 <sys_write+0x50>
  return filewrite(f, p, n);
    80005c54:	fe442603          	lw	a2,-28(s0)
    80005c58:	fd843583          	ld	a1,-40(s0)
    80005c5c:	fe843503          	ld	a0,-24(s0)
    80005c60:	fffff097          	auipc	ra,0xfffff
    80005c64:	4a8080e7          	jalr	1192(ra) # 80005108 <filewrite>
}
    80005c68:	70a2                	ld	ra,40(sp)
    80005c6a:	7402                	ld	s0,32(sp)
    80005c6c:	6145                	addi	sp,sp,48
    80005c6e:	8082                	ret

0000000080005c70 <sys_close>:
{
    80005c70:	1101                	addi	sp,sp,-32
    80005c72:	ec06                	sd	ra,24(sp)
    80005c74:	e822                	sd	s0,16(sp)
    80005c76:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005c78:	fe040613          	addi	a2,s0,-32
    80005c7c:	fec40593          	addi	a1,s0,-20
    80005c80:	4501                	li	a0,0
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	cc4080e7          	jalr	-828(ra) # 80005946 <argfd>
    return -1;
    80005c8a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005c8c:	02054463          	bltz	a0,80005cb4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005c90:	ffffc097          	auipc	ra,0xffffc
    80005c94:	d50080e7          	jalr	-688(ra) # 800019e0 <myproc>
    80005c98:	fec42783          	lw	a5,-20(s0)
    80005c9c:	07e9                	addi	a5,a5,26
    80005c9e:	078e                	slli	a5,a5,0x3
    80005ca0:	97aa                	add	a5,a5,a0
    80005ca2:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005ca6:	fe043503          	ld	a0,-32(s0)
    80005caa:	fffff097          	auipc	ra,0xfffff
    80005cae:	262080e7          	jalr	610(ra) # 80004f0c <fileclose>
  return 0;
    80005cb2:	4781                	li	a5,0
}
    80005cb4:	853e                	mv	a0,a5
    80005cb6:	60e2                	ld	ra,24(sp)
    80005cb8:	6442                	ld	s0,16(sp)
    80005cba:	6105                	addi	sp,sp,32
    80005cbc:	8082                	ret

0000000080005cbe <sys_fstat>:
{
    80005cbe:	1101                	addi	sp,sp,-32
    80005cc0:	ec06                	sd	ra,24(sp)
    80005cc2:	e822                	sd	s0,16(sp)
    80005cc4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005cc6:	fe040593          	addi	a1,s0,-32
    80005cca:	4505                	li	a0,1
    80005ccc:	ffffd097          	auipc	ra,0xffffd
    80005cd0:	628080e7          	jalr	1576(ra) # 800032f4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005cd4:	fe840613          	addi	a2,s0,-24
    80005cd8:	4581                	li	a1,0
    80005cda:	4501                	li	a0,0
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	c6a080e7          	jalr	-918(ra) # 80005946 <argfd>
    80005ce4:	87aa                	mv	a5,a0
    return -1;
    80005ce6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005ce8:	0007ca63          	bltz	a5,80005cfc <sys_fstat+0x3e>
  return filestat(f, st);
    80005cec:	fe043583          	ld	a1,-32(s0)
    80005cf0:	fe843503          	ld	a0,-24(s0)
    80005cf4:	fffff097          	auipc	ra,0xfffff
    80005cf8:	2e0080e7          	jalr	736(ra) # 80004fd4 <filestat>
}
    80005cfc:	60e2                	ld	ra,24(sp)
    80005cfe:	6442                	ld	s0,16(sp)
    80005d00:	6105                	addi	sp,sp,32
    80005d02:	8082                	ret

0000000080005d04 <sys_link>:
{
    80005d04:	7169                	addi	sp,sp,-304
    80005d06:	f606                	sd	ra,296(sp)
    80005d08:	f222                	sd	s0,288(sp)
    80005d0a:	ee26                	sd	s1,280(sp)
    80005d0c:	ea4a                	sd	s2,272(sp)
    80005d0e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d10:	08000613          	li	a2,128
    80005d14:	ed040593          	addi	a1,s0,-304
    80005d18:	4501                	li	a0,0
    80005d1a:	ffffd097          	auipc	ra,0xffffd
    80005d1e:	5fa080e7          	jalr	1530(ra) # 80003314 <argstr>
    return -1;
    80005d22:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d24:	10054e63          	bltz	a0,80005e40 <sys_link+0x13c>
    80005d28:	08000613          	li	a2,128
    80005d2c:	f5040593          	addi	a1,s0,-176
    80005d30:	4505                	li	a0,1
    80005d32:	ffffd097          	auipc	ra,0xffffd
    80005d36:	5e2080e7          	jalr	1506(ra) # 80003314 <argstr>
    return -1;
    80005d3a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d3c:	10054263          	bltz	a0,80005e40 <sys_link+0x13c>
  begin_op();
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	d00080e7          	jalr	-768(ra) # 80004a40 <begin_op>
  if((ip = namei(old)) == 0){
    80005d48:	ed040513          	addi	a0,s0,-304
    80005d4c:	fffff097          	auipc	ra,0xfffff
    80005d50:	ad8080e7          	jalr	-1320(ra) # 80004824 <namei>
    80005d54:	84aa                	mv	s1,a0
    80005d56:	c551                	beqz	a0,80005de2 <sys_link+0xde>
  ilock(ip);
    80005d58:	ffffe097          	auipc	ra,0xffffe
    80005d5c:	326080e7          	jalr	806(ra) # 8000407e <ilock>
  if(ip->type == T_DIR){
    80005d60:	04449703          	lh	a4,68(s1)
    80005d64:	4785                	li	a5,1
    80005d66:	08f70463          	beq	a4,a5,80005dee <sys_link+0xea>
  ip->nlink++;
    80005d6a:	04a4d783          	lhu	a5,74(s1)
    80005d6e:	2785                	addiw	a5,a5,1
    80005d70:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005d74:	8526                	mv	a0,s1
    80005d76:	ffffe097          	auipc	ra,0xffffe
    80005d7a:	23e080e7          	jalr	574(ra) # 80003fb4 <iupdate>
  iunlock(ip);
    80005d7e:	8526                	mv	a0,s1
    80005d80:	ffffe097          	auipc	ra,0xffffe
    80005d84:	3c0080e7          	jalr	960(ra) # 80004140 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005d88:	fd040593          	addi	a1,s0,-48
    80005d8c:	f5040513          	addi	a0,s0,-176
    80005d90:	fffff097          	auipc	ra,0xfffff
    80005d94:	ab2080e7          	jalr	-1358(ra) # 80004842 <nameiparent>
    80005d98:	892a                	mv	s2,a0
    80005d9a:	c935                	beqz	a0,80005e0e <sys_link+0x10a>
  ilock(dp);
    80005d9c:	ffffe097          	auipc	ra,0xffffe
    80005da0:	2e2080e7          	jalr	738(ra) # 8000407e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005da4:	00092703          	lw	a4,0(s2)
    80005da8:	409c                	lw	a5,0(s1)
    80005daa:	04f71d63          	bne	a4,a5,80005e04 <sys_link+0x100>
    80005dae:	40d0                	lw	a2,4(s1)
    80005db0:	fd040593          	addi	a1,s0,-48
    80005db4:	854a                	mv	a0,s2
    80005db6:	fffff097          	auipc	ra,0xfffff
    80005dba:	9bc080e7          	jalr	-1604(ra) # 80004772 <dirlink>
    80005dbe:	04054363          	bltz	a0,80005e04 <sys_link+0x100>
  iunlockput(dp);
    80005dc2:	854a                	mv	a0,s2
    80005dc4:	ffffe097          	auipc	ra,0xffffe
    80005dc8:	51c080e7          	jalr	1308(ra) # 800042e0 <iunlockput>
  iput(ip);
    80005dcc:	8526                	mv	a0,s1
    80005dce:	ffffe097          	auipc	ra,0xffffe
    80005dd2:	46a080e7          	jalr	1130(ra) # 80004238 <iput>
  end_op();
    80005dd6:	fffff097          	auipc	ra,0xfffff
    80005dda:	cea080e7          	jalr	-790(ra) # 80004ac0 <end_op>
  return 0;
    80005dde:	4781                	li	a5,0
    80005de0:	a085                	j	80005e40 <sys_link+0x13c>
    end_op();
    80005de2:	fffff097          	auipc	ra,0xfffff
    80005de6:	cde080e7          	jalr	-802(ra) # 80004ac0 <end_op>
    return -1;
    80005dea:	57fd                	li	a5,-1
    80005dec:	a891                	j	80005e40 <sys_link+0x13c>
    iunlockput(ip);
    80005dee:	8526                	mv	a0,s1
    80005df0:	ffffe097          	auipc	ra,0xffffe
    80005df4:	4f0080e7          	jalr	1264(ra) # 800042e0 <iunlockput>
    end_op();
    80005df8:	fffff097          	auipc	ra,0xfffff
    80005dfc:	cc8080e7          	jalr	-824(ra) # 80004ac0 <end_op>
    return -1;
    80005e00:	57fd                	li	a5,-1
    80005e02:	a83d                	j	80005e40 <sys_link+0x13c>
    iunlockput(dp);
    80005e04:	854a                	mv	a0,s2
    80005e06:	ffffe097          	auipc	ra,0xffffe
    80005e0a:	4da080e7          	jalr	1242(ra) # 800042e0 <iunlockput>
  ilock(ip);
    80005e0e:	8526                	mv	a0,s1
    80005e10:	ffffe097          	auipc	ra,0xffffe
    80005e14:	26e080e7          	jalr	622(ra) # 8000407e <ilock>
  ip->nlink--;
    80005e18:	04a4d783          	lhu	a5,74(s1)
    80005e1c:	37fd                	addiw	a5,a5,-1
    80005e1e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005e22:	8526                	mv	a0,s1
    80005e24:	ffffe097          	auipc	ra,0xffffe
    80005e28:	190080e7          	jalr	400(ra) # 80003fb4 <iupdate>
  iunlockput(ip);
    80005e2c:	8526                	mv	a0,s1
    80005e2e:	ffffe097          	auipc	ra,0xffffe
    80005e32:	4b2080e7          	jalr	1202(ra) # 800042e0 <iunlockput>
  end_op();
    80005e36:	fffff097          	auipc	ra,0xfffff
    80005e3a:	c8a080e7          	jalr	-886(ra) # 80004ac0 <end_op>
  return -1;
    80005e3e:	57fd                	li	a5,-1
}
    80005e40:	853e                	mv	a0,a5
    80005e42:	70b2                	ld	ra,296(sp)
    80005e44:	7412                	ld	s0,288(sp)
    80005e46:	64f2                	ld	s1,280(sp)
    80005e48:	6952                	ld	s2,272(sp)
    80005e4a:	6155                	addi	sp,sp,304
    80005e4c:	8082                	ret

0000000080005e4e <sys_unlink>:
{
    80005e4e:	7151                	addi	sp,sp,-240
    80005e50:	f586                	sd	ra,232(sp)
    80005e52:	f1a2                	sd	s0,224(sp)
    80005e54:	eda6                	sd	s1,216(sp)
    80005e56:	e9ca                	sd	s2,208(sp)
    80005e58:	e5ce                	sd	s3,200(sp)
    80005e5a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005e5c:	08000613          	li	a2,128
    80005e60:	f3040593          	addi	a1,s0,-208
    80005e64:	4501                	li	a0,0
    80005e66:	ffffd097          	auipc	ra,0xffffd
    80005e6a:	4ae080e7          	jalr	1198(ra) # 80003314 <argstr>
    80005e6e:	18054163          	bltz	a0,80005ff0 <sys_unlink+0x1a2>
  begin_op();
    80005e72:	fffff097          	auipc	ra,0xfffff
    80005e76:	bce080e7          	jalr	-1074(ra) # 80004a40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005e7a:	fb040593          	addi	a1,s0,-80
    80005e7e:	f3040513          	addi	a0,s0,-208
    80005e82:	fffff097          	auipc	ra,0xfffff
    80005e86:	9c0080e7          	jalr	-1600(ra) # 80004842 <nameiparent>
    80005e8a:	84aa                	mv	s1,a0
    80005e8c:	c979                	beqz	a0,80005f62 <sys_unlink+0x114>
  ilock(dp);
    80005e8e:	ffffe097          	auipc	ra,0xffffe
    80005e92:	1f0080e7          	jalr	496(ra) # 8000407e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005e96:	00002597          	auipc	a1,0x2
    80005e9a:	78258593          	addi	a1,a1,1922 # 80008618 <etext+0x618>
    80005e9e:	fb040513          	addi	a0,s0,-80
    80005ea2:	ffffe097          	auipc	ra,0xffffe
    80005ea6:	6a6080e7          	jalr	1702(ra) # 80004548 <namecmp>
    80005eaa:	14050a63          	beqz	a0,80005ffe <sys_unlink+0x1b0>
    80005eae:	00002597          	auipc	a1,0x2
    80005eb2:	77258593          	addi	a1,a1,1906 # 80008620 <etext+0x620>
    80005eb6:	fb040513          	addi	a0,s0,-80
    80005eba:	ffffe097          	auipc	ra,0xffffe
    80005ebe:	68e080e7          	jalr	1678(ra) # 80004548 <namecmp>
    80005ec2:	12050e63          	beqz	a0,80005ffe <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ec6:	f2c40613          	addi	a2,s0,-212
    80005eca:	fb040593          	addi	a1,s0,-80
    80005ece:	8526                	mv	a0,s1
    80005ed0:	ffffe097          	auipc	ra,0xffffe
    80005ed4:	692080e7          	jalr	1682(ra) # 80004562 <dirlookup>
    80005ed8:	892a                	mv	s2,a0
    80005eda:	12050263          	beqz	a0,80005ffe <sys_unlink+0x1b0>
  ilock(ip);
    80005ede:	ffffe097          	auipc	ra,0xffffe
    80005ee2:	1a0080e7          	jalr	416(ra) # 8000407e <ilock>
  if(ip->nlink < 1)
    80005ee6:	04a91783          	lh	a5,74(s2)
    80005eea:	08f05263          	blez	a5,80005f6e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005eee:	04491703          	lh	a4,68(s2)
    80005ef2:	4785                	li	a5,1
    80005ef4:	08f70563          	beq	a4,a5,80005f7e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005ef8:	4641                	li	a2,16
    80005efa:	4581                	li	a1,0
    80005efc:	fc040513          	addi	a0,s0,-64
    80005f00:	ffffb097          	auipc	ra,0xffffb
    80005f04:	dd2080e7          	jalr	-558(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005f08:	4741                	li	a4,16
    80005f0a:	f2c42683          	lw	a3,-212(s0)
    80005f0e:	fc040613          	addi	a2,s0,-64
    80005f12:	4581                	li	a1,0
    80005f14:	8526                	mv	a0,s1
    80005f16:	ffffe097          	auipc	ra,0xffffe
    80005f1a:	514080e7          	jalr	1300(ra) # 8000442a <writei>
    80005f1e:	47c1                	li	a5,16
    80005f20:	0af51563          	bne	a0,a5,80005fca <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005f24:	04491703          	lh	a4,68(s2)
    80005f28:	4785                	li	a5,1
    80005f2a:	0af70863          	beq	a4,a5,80005fda <sys_unlink+0x18c>
  iunlockput(dp);
    80005f2e:	8526                	mv	a0,s1
    80005f30:	ffffe097          	auipc	ra,0xffffe
    80005f34:	3b0080e7          	jalr	944(ra) # 800042e0 <iunlockput>
  ip->nlink--;
    80005f38:	04a95783          	lhu	a5,74(s2)
    80005f3c:	37fd                	addiw	a5,a5,-1
    80005f3e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005f42:	854a                	mv	a0,s2
    80005f44:	ffffe097          	auipc	ra,0xffffe
    80005f48:	070080e7          	jalr	112(ra) # 80003fb4 <iupdate>
  iunlockput(ip);
    80005f4c:	854a                	mv	a0,s2
    80005f4e:	ffffe097          	auipc	ra,0xffffe
    80005f52:	392080e7          	jalr	914(ra) # 800042e0 <iunlockput>
  end_op();
    80005f56:	fffff097          	auipc	ra,0xfffff
    80005f5a:	b6a080e7          	jalr	-1174(ra) # 80004ac0 <end_op>
  return 0;
    80005f5e:	4501                	li	a0,0
    80005f60:	a84d                	j	80006012 <sys_unlink+0x1c4>
    end_op();
    80005f62:	fffff097          	auipc	ra,0xfffff
    80005f66:	b5e080e7          	jalr	-1186(ra) # 80004ac0 <end_op>
    return -1;
    80005f6a:	557d                	li	a0,-1
    80005f6c:	a05d                	j	80006012 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005f6e:	00002517          	auipc	a0,0x2
    80005f72:	6ba50513          	addi	a0,a0,1722 # 80008628 <etext+0x628>
    80005f76:	ffffa097          	auipc	ra,0xffffa
    80005f7a:	5c8080e7          	jalr	1480(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005f7e:	04c92703          	lw	a4,76(s2)
    80005f82:	02000793          	li	a5,32
    80005f86:	f6e7f9e3          	bgeu	a5,a4,80005ef8 <sys_unlink+0xaa>
    80005f8a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005f8e:	4741                	li	a4,16
    80005f90:	86ce                	mv	a3,s3
    80005f92:	f1840613          	addi	a2,s0,-232
    80005f96:	4581                	li	a1,0
    80005f98:	854a                	mv	a0,s2
    80005f9a:	ffffe097          	auipc	ra,0xffffe
    80005f9e:	398080e7          	jalr	920(ra) # 80004332 <readi>
    80005fa2:	47c1                	li	a5,16
    80005fa4:	00f51b63          	bne	a0,a5,80005fba <sys_unlink+0x16c>
    if(de.inum != 0)
    80005fa8:	f1845783          	lhu	a5,-232(s0)
    80005fac:	e7a1                	bnez	a5,80005ff4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005fae:	29c1                	addiw	s3,s3,16
    80005fb0:	04c92783          	lw	a5,76(s2)
    80005fb4:	fcf9ede3          	bltu	s3,a5,80005f8e <sys_unlink+0x140>
    80005fb8:	b781                	j	80005ef8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005fba:	00002517          	auipc	a0,0x2
    80005fbe:	68650513          	addi	a0,a0,1670 # 80008640 <etext+0x640>
    80005fc2:	ffffa097          	auipc	ra,0xffffa
    80005fc6:	57c080e7          	jalr	1404(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005fca:	00002517          	auipc	a0,0x2
    80005fce:	68e50513          	addi	a0,a0,1678 # 80008658 <etext+0x658>
    80005fd2:	ffffa097          	auipc	ra,0xffffa
    80005fd6:	56c080e7          	jalr	1388(ra) # 8000053e <panic>
    dp->nlink--;
    80005fda:	04a4d783          	lhu	a5,74(s1)
    80005fde:	37fd                	addiw	a5,a5,-1
    80005fe0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005fe4:	8526                	mv	a0,s1
    80005fe6:	ffffe097          	auipc	ra,0xffffe
    80005fea:	fce080e7          	jalr	-50(ra) # 80003fb4 <iupdate>
    80005fee:	b781                	j	80005f2e <sys_unlink+0xe0>
    return -1;
    80005ff0:	557d                	li	a0,-1
    80005ff2:	a005                	j	80006012 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005ff4:	854a                	mv	a0,s2
    80005ff6:	ffffe097          	auipc	ra,0xffffe
    80005ffa:	2ea080e7          	jalr	746(ra) # 800042e0 <iunlockput>
  iunlockput(dp);
    80005ffe:	8526                	mv	a0,s1
    80006000:	ffffe097          	auipc	ra,0xffffe
    80006004:	2e0080e7          	jalr	736(ra) # 800042e0 <iunlockput>
  end_op();
    80006008:	fffff097          	auipc	ra,0xfffff
    8000600c:	ab8080e7          	jalr	-1352(ra) # 80004ac0 <end_op>
  return -1;
    80006010:	557d                	li	a0,-1
}
    80006012:	70ae                	ld	ra,232(sp)
    80006014:	740e                	ld	s0,224(sp)
    80006016:	64ee                	ld	s1,216(sp)
    80006018:	694e                	ld	s2,208(sp)
    8000601a:	69ae                	ld	s3,200(sp)
    8000601c:	616d                	addi	sp,sp,240
    8000601e:	8082                	ret

0000000080006020 <sys_open>:

uint64
sys_open(void)
{
    80006020:	7131                	addi	sp,sp,-192
    80006022:	fd06                	sd	ra,184(sp)
    80006024:	f922                	sd	s0,176(sp)
    80006026:	f526                	sd	s1,168(sp)
    80006028:	f14a                	sd	s2,160(sp)
    8000602a:	ed4e                	sd	s3,152(sp)
    8000602c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000602e:	f4c40593          	addi	a1,s0,-180
    80006032:	4505                	li	a0,1
    80006034:	ffffd097          	auipc	ra,0xffffd
    80006038:	2a0080e7          	jalr	672(ra) # 800032d4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000603c:	08000613          	li	a2,128
    80006040:	f5040593          	addi	a1,s0,-176
    80006044:	4501                	li	a0,0
    80006046:	ffffd097          	auipc	ra,0xffffd
    8000604a:	2ce080e7          	jalr	718(ra) # 80003314 <argstr>
    8000604e:	87aa                	mv	a5,a0
    return -1;
    80006050:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006052:	0a07c963          	bltz	a5,80006104 <sys_open+0xe4>

  begin_op();
    80006056:	fffff097          	auipc	ra,0xfffff
    8000605a:	9ea080e7          	jalr	-1558(ra) # 80004a40 <begin_op>

  if(omode & O_CREATE){
    8000605e:	f4c42783          	lw	a5,-180(s0)
    80006062:	2007f793          	andi	a5,a5,512
    80006066:	cfc5                	beqz	a5,8000611e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80006068:	4681                	li	a3,0
    8000606a:	4601                	li	a2,0
    8000606c:	4589                	li	a1,2
    8000606e:	f5040513          	addi	a0,s0,-176
    80006072:	00000097          	auipc	ra,0x0
    80006076:	976080e7          	jalr	-1674(ra) # 800059e8 <create>
    8000607a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000607c:	c959                	beqz	a0,80006112 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000607e:	04449703          	lh	a4,68(s1)
    80006082:	478d                	li	a5,3
    80006084:	00f71763          	bne	a4,a5,80006092 <sys_open+0x72>
    80006088:	0464d703          	lhu	a4,70(s1)
    8000608c:	47a5                	li	a5,9
    8000608e:	0ce7ed63          	bltu	a5,a4,80006168 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006092:	fffff097          	auipc	ra,0xfffff
    80006096:	dbe080e7          	jalr	-578(ra) # 80004e50 <filealloc>
    8000609a:	89aa                	mv	s3,a0
    8000609c:	10050363          	beqz	a0,800061a2 <sys_open+0x182>
    800060a0:	00000097          	auipc	ra,0x0
    800060a4:	906080e7          	jalr	-1786(ra) # 800059a6 <fdalloc>
    800060a8:	892a                	mv	s2,a0
    800060aa:	0e054763          	bltz	a0,80006198 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800060ae:	04449703          	lh	a4,68(s1)
    800060b2:	478d                	li	a5,3
    800060b4:	0cf70563          	beq	a4,a5,8000617e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800060b8:	4789                	li	a5,2
    800060ba:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800060be:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800060c2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800060c6:	f4c42783          	lw	a5,-180(s0)
    800060ca:	0017c713          	xori	a4,a5,1
    800060ce:	8b05                	andi	a4,a4,1
    800060d0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800060d4:	0037f713          	andi	a4,a5,3
    800060d8:	00e03733          	snez	a4,a4
    800060dc:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800060e0:	4007f793          	andi	a5,a5,1024
    800060e4:	c791                	beqz	a5,800060f0 <sys_open+0xd0>
    800060e6:	04449703          	lh	a4,68(s1)
    800060ea:	4789                	li	a5,2
    800060ec:	0af70063          	beq	a4,a5,8000618c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800060f0:	8526                	mv	a0,s1
    800060f2:	ffffe097          	auipc	ra,0xffffe
    800060f6:	04e080e7          	jalr	78(ra) # 80004140 <iunlock>
  end_op();
    800060fa:	fffff097          	auipc	ra,0xfffff
    800060fe:	9c6080e7          	jalr	-1594(ra) # 80004ac0 <end_op>

  return fd;
    80006102:	854a                	mv	a0,s2
}
    80006104:	70ea                	ld	ra,184(sp)
    80006106:	744a                	ld	s0,176(sp)
    80006108:	74aa                	ld	s1,168(sp)
    8000610a:	790a                	ld	s2,160(sp)
    8000610c:	69ea                	ld	s3,152(sp)
    8000610e:	6129                	addi	sp,sp,192
    80006110:	8082                	ret
      end_op();
    80006112:	fffff097          	auipc	ra,0xfffff
    80006116:	9ae080e7          	jalr	-1618(ra) # 80004ac0 <end_op>
      return -1;
    8000611a:	557d                	li	a0,-1
    8000611c:	b7e5                	j	80006104 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000611e:	f5040513          	addi	a0,s0,-176
    80006122:	ffffe097          	auipc	ra,0xffffe
    80006126:	702080e7          	jalr	1794(ra) # 80004824 <namei>
    8000612a:	84aa                	mv	s1,a0
    8000612c:	c905                	beqz	a0,8000615c <sys_open+0x13c>
    ilock(ip);
    8000612e:	ffffe097          	auipc	ra,0xffffe
    80006132:	f50080e7          	jalr	-176(ra) # 8000407e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006136:	04449703          	lh	a4,68(s1)
    8000613a:	4785                	li	a5,1
    8000613c:	f4f711e3          	bne	a4,a5,8000607e <sys_open+0x5e>
    80006140:	f4c42783          	lw	a5,-180(s0)
    80006144:	d7b9                	beqz	a5,80006092 <sys_open+0x72>
      iunlockput(ip);
    80006146:	8526                	mv	a0,s1
    80006148:	ffffe097          	auipc	ra,0xffffe
    8000614c:	198080e7          	jalr	408(ra) # 800042e0 <iunlockput>
      end_op();
    80006150:	fffff097          	auipc	ra,0xfffff
    80006154:	970080e7          	jalr	-1680(ra) # 80004ac0 <end_op>
      return -1;
    80006158:	557d                	li	a0,-1
    8000615a:	b76d                	j	80006104 <sys_open+0xe4>
      end_op();
    8000615c:	fffff097          	auipc	ra,0xfffff
    80006160:	964080e7          	jalr	-1692(ra) # 80004ac0 <end_op>
      return -1;
    80006164:	557d                	li	a0,-1
    80006166:	bf79                	j	80006104 <sys_open+0xe4>
    iunlockput(ip);
    80006168:	8526                	mv	a0,s1
    8000616a:	ffffe097          	auipc	ra,0xffffe
    8000616e:	176080e7          	jalr	374(ra) # 800042e0 <iunlockput>
    end_op();
    80006172:	fffff097          	auipc	ra,0xfffff
    80006176:	94e080e7          	jalr	-1714(ra) # 80004ac0 <end_op>
    return -1;
    8000617a:	557d                	li	a0,-1
    8000617c:	b761                	j	80006104 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000617e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006182:	04649783          	lh	a5,70(s1)
    80006186:	02f99223          	sh	a5,36(s3)
    8000618a:	bf25                	j	800060c2 <sys_open+0xa2>
    itrunc(ip);
    8000618c:	8526                	mv	a0,s1
    8000618e:	ffffe097          	auipc	ra,0xffffe
    80006192:	ffe080e7          	jalr	-2(ra) # 8000418c <itrunc>
    80006196:	bfa9                	j	800060f0 <sys_open+0xd0>
      fileclose(f);
    80006198:	854e                	mv	a0,s3
    8000619a:	fffff097          	auipc	ra,0xfffff
    8000619e:	d72080e7          	jalr	-654(ra) # 80004f0c <fileclose>
    iunlockput(ip);
    800061a2:	8526                	mv	a0,s1
    800061a4:	ffffe097          	auipc	ra,0xffffe
    800061a8:	13c080e7          	jalr	316(ra) # 800042e0 <iunlockput>
    end_op();
    800061ac:	fffff097          	auipc	ra,0xfffff
    800061b0:	914080e7          	jalr	-1772(ra) # 80004ac0 <end_op>
    return -1;
    800061b4:	557d                	li	a0,-1
    800061b6:	b7b9                	j	80006104 <sys_open+0xe4>

00000000800061b8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800061b8:	7175                	addi	sp,sp,-144
    800061ba:	e506                	sd	ra,136(sp)
    800061bc:	e122                	sd	s0,128(sp)
    800061be:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800061c0:	fffff097          	auipc	ra,0xfffff
    800061c4:	880080e7          	jalr	-1920(ra) # 80004a40 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800061c8:	08000613          	li	a2,128
    800061cc:	f7040593          	addi	a1,s0,-144
    800061d0:	4501                	li	a0,0
    800061d2:	ffffd097          	auipc	ra,0xffffd
    800061d6:	142080e7          	jalr	322(ra) # 80003314 <argstr>
    800061da:	02054963          	bltz	a0,8000620c <sys_mkdir+0x54>
    800061de:	4681                	li	a3,0
    800061e0:	4601                	li	a2,0
    800061e2:	4585                	li	a1,1
    800061e4:	f7040513          	addi	a0,s0,-144
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	800080e7          	jalr	-2048(ra) # 800059e8 <create>
    800061f0:	cd11                	beqz	a0,8000620c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800061f2:	ffffe097          	auipc	ra,0xffffe
    800061f6:	0ee080e7          	jalr	238(ra) # 800042e0 <iunlockput>
  end_op();
    800061fa:	fffff097          	auipc	ra,0xfffff
    800061fe:	8c6080e7          	jalr	-1850(ra) # 80004ac0 <end_op>
  return 0;
    80006202:	4501                	li	a0,0
}
    80006204:	60aa                	ld	ra,136(sp)
    80006206:	640a                	ld	s0,128(sp)
    80006208:	6149                	addi	sp,sp,144
    8000620a:	8082                	ret
    end_op();
    8000620c:	fffff097          	auipc	ra,0xfffff
    80006210:	8b4080e7          	jalr	-1868(ra) # 80004ac0 <end_op>
    return -1;
    80006214:	557d                	li	a0,-1
    80006216:	b7fd                	j	80006204 <sys_mkdir+0x4c>

0000000080006218 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006218:	7135                	addi	sp,sp,-160
    8000621a:	ed06                	sd	ra,152(sp)
    8000621c:	e922                	sd	s0,144(sp)
    8000621e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006220:	fffff097          	auipc	ra,0xfffff
    80006224:	820080e7          	jalr	-2016(ra) # 80004a40 <begin_op>
  argint(1, &major);
    80006228:	f6c40593          	addi	a1,s0,-148
    8000622c:	4505                	li	a0,1
    8000622e:	ffffd097          	auipc	ra,0xffffd
    80006232:	0a6080e7          	jalr	166(ra) # 800032d4 <argint>
  argint(2, &minor);
    80006236:	f6840593          	addi	a1,s0,-152
    8000623a:	4509                	li	a0,2
    8000623c:	ffffd097          	auipc	ra,0xffffd
    80006240:	098080e7          	jalr	152(ra) # 800032d4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006244:	08000613          	li	a2,128
    80006248:	f7040593          	addi	a1,s0,-144
    8000624c:	4501                	li	a0,0
    8000624e:	ffffd097          	auipc	ra,0xffffd
    80006252:	0c6080e7          	jalr	198(ra) # 80003314 <argstr>
    80006256:	02054b63          	bltz	a0,8000628c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000625a:	f6841683          	lh	a3,-152(s0)
    8000625e:	f6c41603          	lh	a2,-148(s0)
    80006262:	458d                	li	a1,3
    80006264:	f7040513          	addi	a0,s0,-144
    80006268:	fffff097          	auipc	ra,0xfffff
    8000626c:	780080e7          	jalr	1920(ra) # 800059e8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006270:	cd11                	beqz	a0,8000628c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006272:	ffffe097          	auipc	ra,0xffffe
    80006276:	06e080e7          	jalr	110(ra) # 800042e0 <iunlockput>
  end_op();
    8000627a:	fffff097          	auipc	ra,0xfffff
    8000627e:	846080e7          	jalr	-1978(ra) # 80004ac0 <end_op>
  return 0;
    80006282:	4501                	li	a0,0
}
    80006284:	60ea                	ld	ra,152(sp)
    80006286:	644a                	ld	s0,144(sp)
    80006288:	610d                	addi	sp,sp,160
    8000628a:	8082                	ret
    end_op();
    8000628c:	fffff097          	auipc	ra,0xfffff
    80006290:	834080e7          	jalr	-1996(ra) # 80004ac0 <end_op>
    return -1;
    80006294:	557d                	li	a0,-1
    80006296:	b7fd                	j	80006284 <sys_mknod+0x6c>

0000000080006298 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006298:	7135                	addi	sp,sp,-160
    8000629a:	ed06                	sd	ra,152(sp)
    8000629c:	e922                	sd	s0,144(sp)
    8000629e:	e526                	sd	s1,136(sp)
    800062a0:	e14a                	sd	s2,128(sp)
    800062a2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	73c080e7          	jalr	1852(ra) # 800019e0 <myproc>
    800062ac:	892a                	mv	s2,a0
  
  begin_op();
    800062ae:	ffffe097          	auipc	ra,0xffffe
    800062b2:	792080e7          	jalr	1938(ra) # 80004a40 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800062b6:	08000613          	li	a2,128
    800062ba:	f6040593          	addi	a1,s0,-160
    800062be:	4501                	li	a0,0
    800062c0:	ffffd097          	auipc	ra,0xffffd
    800062c4:	054080e7          	jalr	84(ra) # 80003314 <argstr>
    800062c8:	04054b63          	bltz	a0,8000631e <sys_chdir+0x86>
    800062cc:	f6040513          	addi	a0,s0,-160
    800062d0:	ffffe097          	auipc	ra,0xffffe
    800062d4:	554080e7          	jalr	1364(ra) # 80004824 <namei>
    800062d8:	84aa                	mv	s1,a0
    800062da:	c131                	beqz	a0,8000631e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800062dc:	ffffe097          	auipc	ra,0xffffe
    800062e0:	da2080e7          	jalr	-606(ra) # 8000407e <ilock>
  if(ip->type != T_DIR){
    800062e4:	04449703          	lh	a4,68(s1)
    800062e8:	4785                	li	a5,1
    800062ea:	04f71063          	bne	a4,a5,8000632a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800062ee:	8526                	mv	a0,s1
    800062f0:	ffffe097          	auipc	ra,0xffffe
    800062f4:	e50080e7          	jalr	-432(ra) # 80004140 <iunlock>
  iput(p->cwd);
    800062f8:	15093503          	ld	a0,336(s2)
    800062fc:	ffffe097          	auipc	ra,0xffffe
    80006300:	f3c080e7          	jalr	-196(ra) # 80004238 <iput>
  end_op();
    80006304:	ffffe097          	auipc	ra,0xffffe
    80006308:	7bc080e7          	jalr	1980(ra) # 80004ac0 <end_op>
  p->cwd = ip;
    8000630c:	14993823          	sd	s1,336(s2)
  return 0;
    80006310:	4501                	li	a0,0
}
    80006312:	60ea                	ld	ra,152(sp)
    80006314:	644a                	ld	s0,144(sp)
    80006316:	64aa                	ld	s1,136(sp)
    80006318:	690a                	ld	s2,128(sp)
    8000631a:	610d                	addi	sp,sp,160
    8000631c:	8082                	ret
    end_op();
    8000631e:	ffffe097          	auipc	ra,0xffffe
    80006322:	7a2080e7          	jalr	1954(ra) # 80004ac0 <end_op>
    return -1;
    80006326:	557d                	li	a0,-1
    80006328:	b7ed                	j	80006312 <sys_chdir+0x7a>
    iunlockput(ip);
    8000632a:	8526                	mv	a0,s1
    8000632c:	ffffe097          	auipc	ra,0xffffe
    80006330:	fb4080e7          	jalr	-76(ra) # 800042e0 <iunlockput>
    end_op();
    80006334:	ffffe097          	auipc	ra,0xffffe
    80006338:	78c080e7          	jalr	1932(ra) # 80004ac0 <end_op>
    return -1;
    8000633c:	557d                	li	a0,-1
    8000633e:	bfd1                	j	80006312 <sys_chdir+0x7a>

0000000080006340 <sys_exec>:

uint64
sys_exec(void)
{
    80006340:	7145                	addi	sp,sp,-464
    80006342:	e786                	sd	ra,456(sp)
    80006344:	e3a2                	sd	s0,448(sp)
    80006346:	ff26                	sd	s1,440(sp)
    80006348:	fb4a                	sd	s2,432(sp)
    8000634a:	f74e                	sd	s3,424(sp)
    8000634c:	f352                	sd	s4,416(sp)
    8000634e:	ef56                	sd	s5,408(sp)
    80006350:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006352:	e3840593          	addi	a1,s0,-456
    80006356:	4505                	li	a0,1
    80006358:	ffffd097          	auipc	ra,0xffffd
    8000635c:	f9c080e7          	jalr	-100(ra) # 800032f4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006360:	08000613          	li	a2,128
    80006364:	f4040593          	addi	a1,s0,-192
    80006368:	4501                	li	a0,0
    8000636a:	ffffd097          	auipc	ra,0xffffd
    8000636e:	faa080e7          	jalr	-86(ra) # 80003314 <argstr>
    80006372:	87aa                	mv	a5,a0
    return -1;
    80006374:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006376:	0c07c263          	bltz	a5,8000643a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000637a:	10000613          	li	a2,256
    8000637e:	4581                	li	a1,0
    80006380:	e4040513          	addi	a0,s0,-448
    80006384:	ffffb097          	auipc	ra,0xffffb
    80006388:	94e080e7          	jalr	-1714(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000638c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80006390:	89a6                	mv	s3,s1
    80006392:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006394:	02000a13          	li	s4,32
    80006398:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000639c:	00391793          	slli	a5,s2,0x3
    800063a0:	e3040593          	addi	a1,s0,-464
    800063a4:	e3843503          	ld	a0,-456(s0)
    800063a8:	953e                	add	a0,a0,a5
    800063aa:	ffffd097          	auipc	ra,0xffffd
    800063ae:	e8c080e7          	jalr	-372(ra) # 80003236 <fetchaddr>
    800063b2:	02054a63          	bltz	a0,800063e6 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800063b6:	e3043783          	ld	a5,-464(s0)
    800063ba:	c3b9                	beqz	a5,80006400 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800063bc:	ffffa097          	auipc	ra,0xffffa
    800063c0:	72a080e7          	jalr	1834(ra) # 80000ae6 <kalloc>
    800063c4:	85aa                	mv	a1,a0
    800063c6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800063ca:	cd11                	beqz	a0,800063e6 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800063cc:	6605                	lui	a2,0x1
    800063ce:	e3043503          	ld	a0,-464(s0)
    800063d2:	ffffd097          	auipc	ra,0xffffd
    800063d6:	eb6080e7          	jalr	-330(ra) # 80003288 <fetchstr>
    800063da:	00054663          	bltz	a0,800063e6 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800063de:	0905                	addi	s2,s2,1
    800063e0:	09a1                	addi	s3,s3,8
    800063e2:	fb491be3          	bne	s2,s4,80006398 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063e6:	10048913          	addi	s2,s1,256
    800063ea:	6088                	ld	a0,0(s1)
    800063ec:	c531                	beqz	a0,80006438 <sys_exec+0xf8>
    kfree(argv[i]);
    800063ee:	ffffa097          	auipc	ra,0xffffa
    800063f2:	5fc080e7          	jalr	1532(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063f6:	04a1                	addi	s1,s1,8
    800063f8:	ff2499e3          	bne	s1,s2,800063ea <sys_exec+0xaa>
  return -1;
    800063fc:	557d                	li	a0,-1
    800063fe:	a835                	j	8000643a <sys_exec+0xfa>
      argv[i] = 0;
    80006400:	0a8e                	slli	s5,s5,0x3
    80006402:	fc040793          	addi	a5,s0,-64
    80006406:	9abe                	add	s5,s5,a5
    80006408:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000640c:	e4040593          	addi	a1,s0,-448
    80006410:	f4040513          	addi	a0,s0,-192
    80006414:	fffff097          	auipc	ra,0xfffff
    80006418:	172080e7          	jalr	370(ra) # 80005586 <exec>
    8000641c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000641e:	10048993          	addi	s3,s1,256
    80006422:	6088                	ld	a0,0(s1)
    80006424:	c901                	beqz	a0,80006434 <sys_exec+0xf4>
    kfree(argv[i]);
    80006426:	ffffa097          	auipc	ra,0xffffa
    8000642a:	5c4080e7          	jalr	1476(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000642e:	04a1                	addi	s1,s1,8
    80006430:	ff3499e3          	bne	s1,s3,80006422 <sys_exec+0xe2>
  return ret;
    80006434:	854a                	mv	a0,s2
    80006436:	a011                	j	8000643a <sys_exec+0xfa>
  return -1;
    80006438:	557d                	li	a0,-1
}
    8000643a:	60be                	ld	ra,456(sp)
    8000643c:	641e                	ld	s0,448(sp)
    8000643e:	74fa                	ld	s1,440(sp)
    80006440:	795a                	ld	s2,432(sp)
    80006442:	79ba                	ld	s3,424(sp)
    80006444:	7a1a                	ld	s4,416(sp)
    80006446:	6afa                	ld	s5,408(sp)
    80006448:	6179                	addi	sp,sp,464
    8000644a:	8082                	ret

000000008000644c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000644c:	7139                	addi	sp,sp,-64
    8000644e:	fc06                	sd	ra,56(sp)
    80006450:	f822                	sd	s0,48(sp)
    80006452:	f426                	sd	s1,40(sp)
    80006454:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006456:	ffffb097          	auipc	ra,0xffffb
    8000645a:	58a080e7          	jalr	1418(ra) # 800019e0 <myproc>
    8000645e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006460:	fd840593          	addi	a1,s0,-40
    80006464:	4501                	li	a0,0
    80006466:	ffffd097          	auipc	ra,0xffffd
    8000646a:	e8e080e7          	jalr	-370(ra) # 800032f4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000646e:	fc840593          	addi	a1,s0,-56
    80006472:	fd040513          	addi	a0,s0,-48
    80006476:	fffff097          	auipc	ra,0xfffff
    8000647a:	dc6080e7          	jalr	-570(ra) # 8000523c <pipealloc>
    return -1;
    8000647e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006480:	0c054463          	bltz	a0,80006548 <sys_pipe+0xfc>
  fd0 = -1;
    80006484:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006488:	fd043503          	ld	a0,-48(s0)
    8000648c:	fffff097          	auipc	ra,0xfffff
    80006490:	51a080e7          	jalr	1306(ra) # 800059a6 <fdalloc>
    80006494:	fca42223          	sw	a0,-60(s0)
    80006498:	08054b63          	bltz	a0,8000652e <sys_pipe+0xe2>
    8000649c:	fc843503          	ld	a0,-56(s0)
    800064a0:	fffff097          	auipc	ra,0xfffff
    800064a4:	506080e7          	jalr	1286(ra) # 800059a6 <fdalloc>
    800064a8:	fca42023          	sw	a0,-64(s0)
    800064ac:	06054863          	bltz	a0,8000651c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800064b0:	4691                	li	a3,4
    800064b2:	fc440613          	addi	a2,s0,-60
    800064b6:	fd843583          	ld	a1,-40(s0)
    800064ba:	68a8                	ld	a0,80(s1)
    800064bc:	ffffb097          	auipc	ra,0xffffb
    800064c0:	1ac080e7          	jalr	428(ra) # 80001668 <copyout>
    800064c4:	02054063          	bltz	a0,800064e4 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800064c8:	4691                	li	a3,4
    800064ca:	fc040613          	addi	a2,s0,-64
    800064ce:	fd843583          	ld	a1,-40(s0)
    800064d2:	0591                	addi	a1,a1,4
    800064d4:	68a8                	ld	a0,80(s1)
    800064d6:	ffffb097          	auipc	ra,0xffffb
    800064da:	192080e7          	jalr	402(ra) # 80001668 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800064de:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800064e0:	06055463          	bgez	a0,80006548 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800064e4:	fc442783          	lw	a5,-60(s0)
    800064e8:	07e9                	addi	a5,a5,26
    800064ea:	078e                	slli	a5,a5,0x3
    800064ec:	97a6                	add	a5,a5,s1
    800064ee:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800064f2:	fc042503          	lw	a0,-64(s0)
    800064f6:	0569                	addi	a0,a0,26
    800064f8:	050e                	slli	a0,a0,0x3
    800064fa:	94aa                	add	s1,s1,a0
    800064fc:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006500:	fd043503          	ld	a0,-48(s0)
    80006504:	fffff097          	auipc	ra,0xfffff
    80006508:	a08080e7          	jalr	-1528(ra) # 80004f0c <fileclose>
    fileclose(wf);
    8000650c:	fc843503          	ld	a0,-56(s0)
    80006510:	fffff097          	auipc	ra,0xfffff
    80006514:	9fc080e7          	jalr	-1540(ra) # 80004f0c <fileclose>
    return -1;
    80006518:	57fd                	li	a5,-1
    8000651a:	a03d                	j	80006548 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000651c:	fc442783          	lw	a5,-60(s0)
    80006520:	0007c763          	bltz	a5,8000652e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006524:	07e9                	addi	a5,a5,26
    80006526:	078e                	slli	a5,a5,0x3
    80006528:	94be                	add	s1,s1,a5
    8000652a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000652e:	fd043503          	ld	a0,-48(s0)
    80006532:	fffff097          	auipc	ra,0xfffff
    80006536:	9da080e7          	jalr	-1574(ra) # 80004f0c <fileclose>
    fileclose(wf);
    8000653a:	fc843503          	ld	a0,-56(s0)
    8000653e:	fffff097          	auipc	ra,0xfffff
    80006542:	9ce080e7          	jalr	-1586(ra) # 80004f0c <fileclose>
    return -1;
    80006546:	57fd                	li	a5,-1
}
    80006548:	853e                	mv	a0,a5
    8000654a:	70e2                	ld	ra,56(sp)
    8000654c:	7442                	ld	s0,48(sp)
    8000654e:	74a2                	ld	s1,40(sp)
    80006550:	6121                	addi	sp,sp,64
    80006552:	8082                	ret
	...

0000000080006560 <kernelvec>:
    80006560:	7111                	addi	sp,sp,-256
    80006562:	e006                	sd	ra,0(sp)
    80006564:	e40a                	sd	sp,8(sp)
    80006566:	e80e                	sd	gp,16(sp)
    80006568:	ec12                	sd	tp,24(sp)
    8000656a:	f016                	sd	t0,32(sp)
    8000656c:	f41a                	sd	t1,40(sp)
    8000656e:	f81e                	sd	t2,48(sp)
    80006570:	fc22                	sd	s0,56(sp)
    80006572:	e0a6                	sd	s1,64(sp)
    80006574:	e4aa                	sd	a0,72(sp)
    80006576:	e8ae                	sd	a1,80(sp)
    80006578:	ecb2                	sd	a2,88(sp)
    8000657a:	f0b6                	sd	a3,96(sp)
    8000657c:	f4ba                	sd	a4,104(sp)
    8000657e:	f8be                	sd	a5,112(sp)
    80006580:	fcc2                	sd	a6,120(sp)
    80006582:	e146                	sd	a7,128(sp)
    80006584:	e54a                	sd	s2,136(sp)
    80006586:	e94e                	sd	s3,144(sp)
    80006588:	ed52                	sd	s4,152(sp)
    8000658a:	f156                	sd	s5,160(sp)
    8000658c:	f55a                	sd	s6,168(sp)
    8000658e:	f95e                	sd	s7,176(sp)
    80006590:	fd62                	sd	s8,184(sp)
    80006592:	e1e6                	sd	s9,192(sp)
    80006594:	e5ea                	sd	s10,200(sp)
    80006596:	e9ee                	sd	s11,208(sp)
    80006598:	edf2                	sd	t3,216(sp)
    8000659a:	f1f6                	sd	t4,224(sp)
    8000659c:	f5fa                	sd	t5,232(sp)
    8000659e:	f9fe                	sd	t6,240(sp)
    800065a0:	b63fc0ef          	jal	80003102 <kerneltrap>
    800065a4:	6082                	ld	ra,0(sp)
    800065a6:	6122                	ld	sp,8(sp)
    800065a8:	61c2                	ld	gp,16(sp)
    800065aa:	7282                	ld	t0,32(sp)
    800065ac:	7322                	ld	t1,40(sp)
    800065ae:	73c2                	ld	t2,48(sp)
    800065b0:	7462                	ld	s0,56(sp)
    800065b2:	6486                	ld	s1,64(sp)
    800065b4:	6526                	ld	a0,72(sp)
    800065b6:	65c6                	ld	a1,80(sp)
    800065b8:	6666                	ld	a2,88(sp)
    800065ba:	7686                	ld	a3,96(sp)
    800065bc:	7726                	ld	a4,104(sp)
    800065be:	77c6                	ld	a5,112(sp)
    800065c0:	7866                	ld	a6,120(sp)
    800065c2:	688a                	ld	a7,128(sp)
    800065c4:	692a                	ld	s2,136(sp)
    800065c6:	69ca                	ld	s3,144(sp)
    800065c8:	6a6a                	ld	s4,152(sp)
    800065ca:	7a8a                	ld	s5,160(sp)
    800065cc:	7b2a                	ld	s6,168(sp)
    800065ce:	7bca                	ld	s7,176(sp)
    800065d0:	7c6a                	ld	s8,184(sp)
    800065d2:	6c8e                	ld	s9,192(sp)
    800065d4:	6d2e                	ld	s10,200(sp)
    800065d6:	6dce                	ld	s11,208(sp)
    800065d8:	6e6e                	ld	t3,216(sp)
    800065da:	7e8e                	ld	t4,224(sp)
    800065dc:	7f2e                	ld	t5,232(sp)
    800065de:	7fce                	ld	t6,240(sp)
    800065e0:	6111                	addi	sp,sp,256
    800065e2:	10200073          	sret
    800065e6:	00000013          	nop
    800065ea:	00000013          	nop
    800065ee:	0001                	nop

00000000800065f0 <timervec>:
    800065f0:	34051573          	csrrw	a0,mscratch,a0
    800065f4:	e10c                	sd	a1,0(a0)
    800065f6:	e510                	sd	a2,8(a0)
    800065f8:	e914                	sd	a3,16(a0)
    800065fa:	6d0c                	ld	a1,24(a0)
    800065fc:	7110                	ld	a2,32(a0)
    800065fe:	6194                	ld	a3,0(a1)
    80006600:	96b2                	add	a3,a3,a2
    80006602:	e194                	sd	a3,0(a1)
    80006604:	4589                	li	a1,2
    80006606:	14459073          	csrw	sip,a1
    8000660a:	6914                	ld	a3,16(a0)
    8000660c:	6510                	ld	a2,8(a0)
    8000660e:	610c                	ld	a1,0(a0)
    80006610:	34051573          	csrrw	a0,mscratch,a0
    80006614:	30200073          	mret
	...

000000008000661a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000661a:	1141                	addi	sp,sp,-16
    8000661c:	e422                	sd	s0,8(sp)
    8000661e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006620:	0c0007b7          	lui	a5,0xc000
    80006624:	4705                	li	a4,1
    80006626:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006628:	c3d8                	sw	a4,4(a5)
}
    8000662a:	6422                	ld	s0,8(sp)
    8000662c:	0141                	addi	sp,sp,16
    8000662e:	8082                	ret

0000000080006630 <plicinithart>:

void
plicinithart(void)
{
    80006630:	1141                	addi	sp,sp,-16
    80006632:	e406                	sd	ra,8(sp)
    80006634:	e022                	sd	s0,0(sp)
    80006636:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006638:	ffffb097          	auipc	ra,0xffffb
    8000663c:	37c080e7          	jalr	892(ra) # 800019b4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006640:	0085171b          	slliw	a4,a0,0x8
    80006644:	0c0027b7          	lui	a5,0xc002
    80006648:	97ba                	add	a5,a5,a4
    8000664a:	40200713          	li	a4,1026
    8000664e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006652:	00d5151b          	slliw	a0,a0,0xd
    80006656:	0c2017b7          	lui	a5,0xc201
    8000665a:	953e                	add	a0,a0,a5
    8000665c:	00052023          	sw	zero,0(a0)
}
    80006660:	60a2                	ld	ra,8(sp)
    80006662:	6402                	ld	s0,0(sp)
    80006664:	0141                	addi	sp,sp,16
    80006666:	8082                	ret

0000000080006668 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006668:	1141                	addi	sp,sp,-16
    8000666a:	e406                	sd	ra,8(sp)
    8000666c:	e022                	sd	s0,0(sp)
    8000666e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006670:	ffffb097          	auipc	ra,0xffffb
    80006674:	344080e7          	jalr	836(ra) # 800019b4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006678:	00d5179b          	slliw	a5,a0,0xd
    8000667c:	0c201537          	lui	a0,0xc201
    80006680:	953e                	add	a0,a0,a5
  return irq;
}
    80006682:	4148                	lw	a0,4(a0)
    80006684:	60a2                	ld	ra,8(sp)
    80006686:	6402                	ld	s0,0(sp)
    80006688:	0141                	addi	sp,sp,16
    8000668a:	8082                	ret

000000008000668c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000668c:	1101                	addi	sp,sp,-32
    8000668e:	ec06                	sd	ra,24(sp)
    80006690:	e822                	sd	s0,16(sp)
    80006692:	e426                	sd	s1,8(sp)
    80006694:	1000                	addi	s0,sp,32
    80006696:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006698:	ffffb097          	auipc	ra,0xffffb
    8000669c:	31c080e7          	jalr	796(ra) # 800019b4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800066a0:	00d5151b          	slliw	a0,a0,0xd
    800066a4:	0c2017b7          	lui	a5,0xc201
    800066a8:	97aa                	add	a5,a5,a0
    800066aa:	c3c4                	sw	s1,4(a5)
}
    800066ac:	60e2                	ld	ra,24(sp)
    800066ae:	6442                	ld	s0,16(sp)
    800066b0:	64a2                	ld	s1,8(sp)
    800066b2:	6105                	addi	sp,sp,32
    800066b4:	8082                	ret

00000000800066b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800066b6:	1141                	addi	sp,sp,-16
    800066b8:	e406                	sd	ra,8(sp)
    800066ba:	e022                	sd	s0,0(sp)
    800066bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800066be:	479d                	li	a5,7
    800066c0:	04a7cc63          	blt	a5,a0,80006718 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800066c4:	0001f797          	auipc	a5,0x1f
    800066c8:	dac78793          	addi	a5,a5,-596 # 80025470 <disk>
    800066cc:	97aa                	add	a5,a5,a0
    800066ce:	0187c783          	lbu	a5,24(a5)
    800066d2:	ebb9                	bnez	a5,80006728 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800066d4:	00451613          	slli	a2,a0,0x4
    800066d8:	0001f797          	auipc	a5,0x1f
    800066dc:	d9878793          	addi	a5,a5,-616 # 80025470 <disk>
    800066e0:	6394                	ld	a3,0(a5)
    800066e2:	96b2                	add	a3,a3,a2
    800066e4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800066e8:	6398                	ld	a4,0(a5)
    800066ea:	9732                	add	a4,a4,a2
    800066ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800066f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800066f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800066f8:	953e                	add	a0,a0,a5
    800066fa:	4785                	li	a5,1
    800066fc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80006700:	0001f517          	auipc	a0,0x1f
    80006704:	d8850513          	addi	a0,a0,-632 # 80025488 <disk+0x18>
    80006708:	ffffc097          	auipc	ra,0xffffc
    8000670c:	e2c080e7          	jalr	-468(ra) # 80002534 <wakeup>
}
    80006710:	60a2                	ld	ra,8(sp)
    80006712:	6402                	ld	s0,0(sp)
    80006714:	0141                	addi	sp,sp,16
    80006716:	8082                	ret
    panic("free_desc 1");
    80006718:	00002517          	auipc	a0,0x2
    8000671c:	f5050513          	addi	a0,a0,-176 # 80008668 <etext+0x668>
    80006720:	ffffa097          	auipc	ra,0xffffa
    80006724:	e1e080e7          	jalr	-482(ra) # 8000053e <panic>
    panic("free_desc 2");
    80006728:	00002517          	auipc	a0,0x2
    8000672c:	f5050513          	addi	a0,a0,-176 # 80008678 <etext+0x678>
    80006730:	ffffa097          	auipc	ra,0xffffa
    80006734:	e0e080e7          	jalr	-498(ra) # 8000053e <panic>

0000000080006738 <virtio_disk_init>:
{
    80006738:	1101                	addi	sp,sp,-32
    8000673a:	ec06                	sd	ra,24(sp)
    8000673c:	e822                	sd	s0,16(sp)
    8000673e:	e426                	sd	s1,8(sp)
    80006740:	e04a                	sd	s2,0(sp)
    80006742:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006744:	00002597          	auipc	a1,0x2
    80006748:	f4458593          	addi	a1,a1,-188 # 80008688 <etext+0x688>
    8000674c:	0001f517          	auipc	a0,0x1f
    80006750:	e4c50513          	addi	a0,a0,-436 # 80025598 <disk+0x128>
    80006754:	ffffa097          	auipc	ra,0xffffa
    80006758:	3f2080e7          	jalr	1010(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000675c:	100017b7          	lui	a5,0x10001
    80006760:	4398                	lw	a4,0(a5)
    80006762:	2701                	sext.w	a4,a4
    80006764:	747277b7          	lui	a5,0x74727
    80006768:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000676c:	14f71c63          	bne	a4,a5,800068c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006770:	100017b7          	lui	a5,0x10001
    80006774:	43dc                	lw	a5,4(a5)
    80006776:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006778:	4709                	li	a4,2
    8000677a:	14e79563          	bne	a5,a4,800068c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000677e:	100017b7          	lui	a5,0x10001
    80006782:	479c                	lw	a5,8(a5)
    80006784:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006786:	12e79f63          	bne	a5,a4,800068c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000678a:	100017b7          	lui	a5,0x10001
    8000678e:	47d8                	lw	a4,12(a5)
    80006790:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006792:	554d47b7          	lui	a5,0x554d4
    80006796:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000679a:	12f71563          	bne	a4,a5,800068c4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000679e:	100017b7          	lui	a5,0x10001
    800067a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800067a6:	4705                	li	a4,1
    800067a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800067aa:	470d                	li	a4,3
    800067ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800067ae:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800067b0:	c7ffe737          	lui	a4,0xc7ffe
    800067b4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd91af>
    800067b8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800067ba:	2701                	sext.w	a4,a4
    800067bc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800067be:	472d                	li	a4,11
    800067c0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800067c2:	5bbc                	lw	a5,112(a5)
    800067c4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800067c8:	8ba1                	andi	a5,a5,8
    800067ca:	10078563          	beqz	a5,800068d4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800067ce:	100017b7          	lui	a5,0x10001
    800067d2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800067d6:	43fc                	lw	a5,68(a5)
    800067d8:	2781                	sext.w	a5,a5
    800067da:	10079563          	bnez	a5,800068e4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800067de:	100017b7          	lui	a5,0x10001
    800067e2:	5bdc                	lw	a5,52(a5)
    800067e4:	2781                	sext.w	a5,a5
  if(max == 0)
    800067e6:	10078763          	beqz	a5,800068f4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800067ea:	471d                	li	a4,7
    800067ec:	10f77c63          	bgeu	a4,a5,80006904 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800067f0:	ffffa097          	auipc	ra,0xffffa
    800067f4:	2f6080e7          	jalr	758(ra) # 80000ae6 <kalloc>
    800067f8:	0001f497          	auipc	s1,0x1f
    800067fc:	c7848493          	addi	s1,s1,-904 # 80025470 <disk>
    80006800:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006802:	ffffa097          	auipc	ra,0xffffa
    80006806:	2e4080e7          	jalr	740(ra) # 80000ae6 <kalloc>
    8000680a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000680c:	ffffa097          	auipc	ra,0xffffa
    80006810:	2da080e7          	jalr	730(ra) # 80000ae6 <kalloc>
    80006814:	87aa                	mv	a5,a0
    80006816:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006818:	6088                	ld	a0,0(s1)
    8000681a:	cd6d                	beqz	a0,80006914 <virtio_disk_init+0x1dc>
    8000681c:	0001f717          	auipc	a4,0x1f
    80006820:	c5c73703          	ld	a4,-932(a4) # 80025478 <disk+0x8>
    80006824:	cb65                	beqz	a4,80006914 <virtio_disk_init+0x1dc>
    80006826:	c7fd                	beqz	a5,80006914 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80006828:	6605                	lui	a2,0x1
    8000682a:	4581                	li	a1,0
    8000682c:	ffffa097          	auipc	ra,0xffffa
    80006830:	4a6080e7          	jalr	1190(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006834:	0001f497          	auipc	s1,0x1f
    80006838:	c3c48493          	addi	s1,s1,-964 # 80025470 <disk>
    8000683c:	6605                	lui	a2,0x1
    8000683e:	4581                	li	a1,0
    80006840:	6488                	ld	a0,8(s1)
    80006842:	ffffa097          	auipc	ra,0xffffa
    80006846:	490080e7          	jalr	1168(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    8000684a:	6605                	lui	a2,0x1
    8000684c:	4581                	li	a1,0
    8000684e:	6888                	ld	a0,16(s1)
    80006850:	ffffa097          	auipc	ra,0xffffa
    80006854:	482080e7          	jalr	1154(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006858:	100017b7          	lui	a5,0x10001
    8000685c:	4721                	li	a4,8
    8000685e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006860:	4098                	lw	a4,0(s1)
    80006862:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006866:	40d8                	lw	a4,4(s1)
    80006868:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000686c:	6498                	ld	a4,8(s1)
    8000686e:	0007069b          	sext.w	a3,a4
    80006872:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006876:	9701                	srai	a4,a4,0x20
    80006878:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000687c:	6898                	ld	a4,16(s1)
    8000687e:	0007069b          	sext.w	a3,a4
    80006882:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006886:	9701                	srai	a4,a4,0x20
    80006888:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000688c:	4705                	li	a4,1
    8000688e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006890:	00e48c23          	sb	a4,24(s1)
    80006894:	00e48ca3          	sb	a4,25(s1)
    80006898:	00e48d23          	sb	a4,26(s1)
    8000689c:	00e48da3          	sb	a4,27(s1)
    800068a0:	00e48e23          	sb	a4,28(s1)
    800068a4:	00e48ea3          	sb	a4,29(s1)
    800068a8:	00e48f23          	sb	a4,30(s1)
    800068ac:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800068b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800068b4:	0727a823          	sw	s2,112(a5)
}
    800068b8:	60e2                	ld	ra,24(sp)
    800068ba:	6442                	ld	s0,16(sp)
    800068bc:	64a2                	ld	s1,8(sp)
    800068be:	6902                	ld	s2,0(sp)
    800068c0:	6105                	addi	sp,sp,32
    800068c2:	8082                	ret
    panic("could not find virtio disk");
    800068c4:	00002517          	auipc	a0,0x2
    800068c8:	dd450513          	addi	a0,a0,-556 # 80008698 <etext+0x698>
    800068cc:	ffffa097          	auipc	ra,0xffffa
    800068d0:	c72080e7          	jalr	-910(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    800068d4:	00002517          	auipc	a0,0x2
    800068d8:	de450513          	addi	a0,a0,-540 # 800086b8 <etext+0x6b8>
    800068dc:	ffffa097          	auipc	ra,0xffffa
    800068e0:	c62080e7          	jalr	-926(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    800068e4:	00002517          	auipc	a0,0x2
    800068e8:	df450513          	addi	a0,a0,-524 # 800086d8 <etext+0x6d8>
    800068ec:	ffffa097          	auipc	ra,0xffffa
    800068f0:	c52080e7          	jalr	-942(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    800068f4:	00002517          	auipc	a0,0x2
    800068f8:	e0450513          	addi	a0,a0,-508 # 800086f8 <etext+0x6f8>
    800068fc:	ffffa097          	auipc	ra,0xffffa
    80006900:	c42080e7          	jalr	-958(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006904:	00002517          	auipc	a0,0x2
    80006908:	e1450513          	addi	a0,a0,-492 # 80008718 <etext+0x718>
    8000690c:	ffffa097          	auipc	ra,0xffffa
    80006910:	c32080e7          	jalr	-974(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80006914:	00002517          	auipc	a0,0x2
    80006918:	e2450513          	addi	a0,a0,-476 # 80008738 <etext+0x738>
    8000691c:	ffffa097          	auipc	ra,0xffffa
    80006920:	c22080e7          	jalr	-990(ra) # 8000053e <panic>

0000000080006924 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006924:	7119                	addi	sp,sp,-128
    80006926:	fc86                	sd	ra,120(sp)
    80006928:	f8a2                	sd	s0,112(sp)
    8000692a:	f4a6                	sd	s1,104(sp)
    8000692c:	f0ca                	sd	s2,96(sp)
    8000692e:	ecce                	sd	s3,88(sp)
    80006930:	e8d2                	sd	s4,80(sp)
    80006932:	e4d6                	sd	s5,72(sp)
    80006934:	e0da                	sd	s6,64(sp)
    80006936:	fc5e                	sd	s7,56(sp)
    80006938:	f862                	sd	s8,48(sp)
    8000693a:	f466                	sd	s9,40(sp)
    8000693c:	f06a                	sd	s10,32(sp)
    8000693e:	ec6e                	sd	s11,24(sp)
    80006940:	0100                	addi	s0,sp,128
    80006942:	8aaa                	mv	s5,a0
    80006944:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006946:	00c52d03          	lw	s10,12(a0)
    8000694a:	001d1d1b          	slliw	s10,s10,0x1
    8000694e:	1d02                	slli	s10,s10,0x20
    80006950:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006954:	0001f517          	auipc	a0,0x1f
    80006958:	c4450513          	addi	a0,a0,-956 # 80025598 <disk+0x128>
    8000695c:	ffffa097          	auipc	ra,0xffffa
    80006960:	27a080e7          	jalr	634(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80006964:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006966:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006968:	0001fb97          	auipc	s7,0x1f
    8000696c:	b08b8b93          	addi	s7,s7,-1272 # 80025470 <disk>
  for(int i = 0; i < 3; i++){
    80006970:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006972:	0001fc97          	auipc	s9,0x1f
    80006976:	c26c8c93          	addi	s9,s9,-986 # 80025598 <disk+0x128>
    8000697a:	a08d                	j	800069dc <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000697c:	00fb8733          	add	a4,s7,a5
    80006980:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006984:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006986:	0207c563          	bltz	a5,800069b0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000698a:	2905                	addiw	s2,s2,1
    8000698c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000698e:	05690c63          	beq	s2,s6,800069e6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006992:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006994:	0001f717          	auipc	a4,0x1f
    80006998:	adc70713          	addi	a4,a4,-1316 # 80025470 <disk>
    8000699c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000699e:	01874683          	lbu	a3,24(a4)
    800069a2:	fee9                	bnez	a3,8000697c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800069a4:	2785                	addiw	a5,a5,1
    800069a6:	0705                	addi	a4,a4,1
    800069a8:	fe979be3          	bne	a5,s1,8000699e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800069ac:	57fd                	li	a5,-1
    800069ae:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800069b0:	01205d63          	blez	s2,800069ca <virtio_disk_rw+0xa6>
    800069b4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800069b6:	000a2503          	lw	a0,0(s4)
    800069ba:	00000097          	auipc	ra,0x0
    800069be:	cfc080e7          	jalr	-772(ra) # 800066b6 <free_desc>
      for(int j = 0; j < i; j++)
    800069c2:	2d85                	addiw	s11,s11,1
    800069c4:	0a11                	addi	s4,s4,4
    800069c6:	ffb918e3          	bne	s2,s11,800069b6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800069ca:	85e6                	mv	a1,s9
    800069cc:	0001f517          	auipc	a0,0x1f
    800069d0:	abc50513          	addi	a0,a0,-1348 # 80025488 <disk+0x18>
    800069d4:	ffffc097          	auipc	ra,0xffffc
    800069d8:	afc080e7          	jalr	-1284(ra) # 800024d0 <sleep>
  for(int i = 0; i < 3; i++){
    800069dc:	f8040a13          	addi	s4,s0,-128
{
    800069e0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800069e2:	894e                	mv	s2,s3
    800069e4:	b77d                	j	80006992 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800069e6:	f8042583          	lw	a1,-128(s0)
    800069ea:	00a58793          	addi	a5,a1,10
    800069ee:	0792                	slli	a5,a5,0x4

  if(write)
    800069f0:	0001f617          	auipc	a2,0x1f
    800069f4:	a8060613          	addi	a2,a2,-1408 # 80025470 <disk>
    800069f8:	00f60733          	add	a4,a2,a5
    800069fc:	018036b3          	snez	a3,s8
    80006a00:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006a02:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006a06:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006a0a:	f6078693          	addi	a3,a5,-160
    80006a0e:	6218                	ld	a4,0(a2)
    80006a10:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006a12:	00878513          	addi	a0,a5,8
    80006a16:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006a18:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006a1a:	6208                	ld	a0,0(a2)
    80006a1c:	96aa                	add	a3,a3,a0
    80006a1e:	4741                	li	a4,16
    80006a20:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006a22:	4705                	li	a4,1
    80006a24:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006a28:	f8442703          	lw	a4,-124(s0)
    80006a2c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006a30:	0712                	slli	a4,a4,0x4
    80006a32:	953a                	add	a0,a0,a4
    80006a34:	058a8693          	addi	a3,s5,88
    80006a38:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80006a3a:	6208                	ld	a0,0(a2)
    80006a3c:	972a                	add	a4,a4,a0
    80006a3e:	40000693          	li	a3,1024
    80006a42:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006a44:	001c3c13          	seqz	s8,s8
    80006a48:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006a4a:	001c6c13          	ori	s8,s8,1
    80006a4e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006a52:	f8842603          	lw	a2,-120(s0)
    80006a56:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006a5a:	0001f697          	auipc	a3,0x1f
    80006a5e:	a1668693          	addi	a3,a3,-1514 # 80025470 <disk>
    80006a62:	00258713          	addi	a4,a1,2
    80006a66:	0712                	slli	a4,a4,0x4
    80006a68:	9736                	add	a4,a4,a3
    80006a6a:	587d                	li	a6,-1
    80006a6c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006a70:	0612                	slli	a2,a2,0x4
    80006a72:	9532                	add	a0,a0,a2
    80006a74:	f9078793          	addi	a5,a5,-112
    80006a78:	97b6                	add	a5,a5,a3
    80006a7a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80006a7c:	629c                	ld	a5,0(a3)
    80006a7e:	97b2                	add	a5,a5,a2
    80006a80:	4605                	li	a2,1
    80006a82:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006a84:	4509                	li	a0,2
    80006a86:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80006a8a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006a8e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006a92:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006a96:	6698                	ld	a4,8(a3)
    80006a98:	00275783          	lhu	a5,2(a4)
    80006a9c:	8b9d                	andi	a5,a5,7
    80006a9e:	0786                	slli	a5,a5,0x1
    80006aa0:	97ba                	add	a5,a5,a4
    80006aa2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006aa6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006aaa:	6698                	ld	a4,8(a3)
    80006aac:	00275783          	lhu	a5,2(a4)
    80006ab0:	2785                	addiw	a5,a5,1
    80006ab2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006ab6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006aba:	100017b7          	lui	a5,0x10001
    80006abe:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006ac2:	004aa783          	lw	a5,4(s5)
    80006ac6:	02c79163          	bne	a5,a2,80006ae8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006aca:	0001f917          	auipc	s2,0x1f
    80006ace:	ace90913          	addi	s2,s2,-1330 # 80025598 <disk+0x128>
  while(b->disk == 1) {
    80006ad2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006ad4:	85ca                	mv	a1,s2
    80006ad6:	8556                	mv	a0,s5
    80006ad8:	ffffc097          	auipc	ra,0xffffc
    80006adc:	9f8080e7          	jalr	-1544(ra) # 800024d0 <sleep>
  while(b->disk == 1) {
    80006ae0:	004aa783          	lw	a5,4(s5)
    80006ae4:	fe9788e3          	beq	a5,s1,80006ad4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006ae8:	f8042903          	lw	s2,-128(s0)
    80006aec:	00290793          	addi	a5,s2,2
    80006af0:	00479713          	slli	a4,a5,0x4
    80006af4:	0001f797          	auipc	a5,0x1f
    80006af8:	97c78793          	addi	a5,a5,-1668 # 80025470 <disk>
    80006afc:	97ba                	add	a5,a5,a4
    80006afe:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006b02:	0001f997          	auipc	s3,0x1f
    80006b06:	96e98993          	addi	s3,s3,-1682 # 80025470 <disk>
    80006b0a:	00491713          	slli	a4,s2,0x4
    80006b0e:	0009b783          	ld	a5,0(s3)
    80006b12:	97ba                	add	a5,a5,a4
    80006b14:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006b18:	854a                	mv	a0,s2
    80006b1a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006b1e:	00000097          	auipc	ra,0x0
    80006b22:	b98080e7          	jalr	-1128(ra) # 800066b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006b26:	8885                	andi	s1,s1,1
    80006b28:	f0ed                	bnez	s1,80006b0a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006b2a:	0001f517          	auipc	a0,0x1f
    80006b2e:	a6e50513          	addi	a0,a0,-1426 # 80025598 <disk+0x128>
    80006b32:	ffffa097          	auipc	ra,0xffffa
    80006b36:	158080e7          	jalr	344(ra) # 80000c8a <release>
}
    80006b3a:	70e6                	ld	ra,120(sp)
    80006b3c:	7446                	ld	s0,112(sp)
    80006b3e:	74a6                	ld	s1,104(sp)
    80006b40:	7906                	ld	s2,96(sp)
    80006b42:	69e6                	ld	s3,88(sp)
    80006b44:	6a46                	ld	s4,80(sp)
    80006b46:	6aa6                	ld	s5,72(sp)
    80006b48:	6b06                	ld	s6,64(sp)
    80006b4a:	7be2                	ld	s7,56(sp)
    80006b4c:	7c42                	ld	s8,48(sp)
    80006b4e:	7ca2                	ld	s9,40(sp)
    80006b50:	7d02                	ld	s10,32(sp)
    80006b52:	6de2                	ld	s11,24(sp)
    80006b54:	6109                	addi	sp,sp,128
    80006b56:	8082                	ret

0000000080006b58 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006b58:	1101                	addi	sp,sp,-32
    80006b5a:	ec06                	sd	ra,24(sp)
    80006b5c:	e822                	sd	s0,16(sp)
    80006b5e:	e426                	sd	s1,8(sp)
    80006b60:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006b62:	0001f497          	auipc	s1,0x1f
    80006b66:	90e48493          	addi	s1,s1,-1778 # 80025470 <disk>
    80006b6a:	0001f517          	auipc	a0,0x1f
    80006b6e:	a2e50513          	addi	a0,a0,-1490 # 80025598 <disk+0x128>
    80006b72:	ffffa097          	auipc	ra,0xffffa
    80006b76:	064080e7          	jalr	100(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006b7a:	10001737          	lui	a4,0x10001
    80006b7e:	533c                	lw	a5,96(a4)
    80006b80:	8b8d                	andi	a5,a5,3
    80006b82:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006b84:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006b88:	689c                	ld	a5,16(s1)
    80006b8a:	0204d703          	lhu	a4,32(s1)
    80006b8e:	0027d783          	lhu	a5,2(a5)
    80006b92:	04f70863          	beq	a4,a5,80006be2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006b96:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006b9a:	6898                	ld	a4,16(s1)
    80006b9c:	0204d783          	lhu	a5,32(s1)
    80006ba0:	8b9d                	andi	a5,a5,7
    80006ba2:	078e                	slli	a5,a5,0x3
    80006ba4:	97ba                	add	a5,a5,a4
    80006ba6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006ba8:	00278713          	addi	a4,a5,2
    80006bac:	0712                	slli	a4,a4,0x4
    80006bae:	9726                	add	a4,a4,s1
    80006bb0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006bb4:	e721                	bnez	a4,80006bfc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006bb6:	0789                	addi	a5,a5,2
    80006bb8:	0792                	slli	a5,a5,0x4
    80006bba:	97a6                	add	a5,a5,s1
    80006bbc:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006bbe:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006bc2:	ffffc097          	auipc	ra,0xffffc
    80006bc6:	972080e7          	jalr	-1678(ra) # 80002534 <wakeup>

    disk.used_idx += 1;
    80006bca:	0204d783          	lhu	a5,32(s1)
    80006bce:	2785                	addiw	a5,a5,1
    80006bd0:	17c2                	slli	a5,a5,0x30
    80006bd2:	93c1                	srli	a5,a5,0x30
    80006bd4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006bd8:	6898                	ld	a4,16(s1)
    80006bda:	00275703          	lhu	a4,2(a4)
    80006bde:	faf71ce3          	bne	a4,a5,80006b96 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006be2:	0001f517          	auipc	a0,0x1f
    80006be6:	9b650513          	addi	a0,a0,-1610 # 80025598 <disk+0x128>
    80006bea:	ffffa097          	auipc	ra,0xffffa
    80006bee:	0a0080e7          	jalr	160(ra) # 80000c8a <release>
}
    80006bf2:	60e2                	ld	ra,24(sp)
    80006bf4:	6442                	ld	s0,16(sp)
    80006bf6:	64a2                	ld	s1,8(sp)
    80006bf8:	6105                	addi	sp,sp,32
    80006bfa:	8082                	ret
      panic("virtio_disk_intr status");
    80006bfc:	00002517          	auipc	a0,0x2
    80006c00:	b5450513          	addi	a0,a0,-1196 # 80008750 <etext+0x750>
    80006c04:	ffffa097          	auipc	ra,0xffffa
    80006c08:	93a080e7          	jalr	-1734(ra) # 8000053e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
