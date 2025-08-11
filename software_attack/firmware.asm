
simpleserial-aes-CWHUSKY.elf:     file format elf32-littlearm


Disassembly of section .text:

00400000 <exception_table>:
  400000:	00 14 00 20 99 06 40 00 95 06 40 00 95 06 40 00     ... ..@...@...@.
  400010:	95 06 40 00 95 06 40 00 95 06 40 00 00 00 00 00     ..@...@...@.....
	...
  40002c:	95 06 40 00 95 06 40 00 00 00 00 00 95 06 40 00     ..@...@.......@.
  40003c:	95 06 40 00 95 06 40 00 95 06 40 00 95 06 40 00     ..@...@...@...@.
  40004c:	95 06 40 00 95 06 40 00 95 06 40 00 95 06 40 00     ..@...@...@...@.
  40005c:	00 00 00 00 95 06 40 00 95 06 40 00 00 00 00 00     ......@...@.....
  40006c:	95 06 40 00 95 06 40 00 00 00 00 00 95 06 40 00     ..@...@.......@.
  40007c:	95 06 40 00 00 00 00 00 00 00 00 00 95 06 40 00     ..@...........@.
  40008c:	95 06 40 00 95 06 40 00 95 06 40 00 95 06 40 00     ..@...@...@...@.
  40009c:	95 06 40 00 95 06 40 00 95 06 40 00 00 00 00 00     ..@...@...@.....
	...
  4000b4:	95 06 40 00 95 06 40 00 95 06 40 00 95 06 40 00     ..@...@...@...@.
  4000c4:	95 06 40 00 95 06 40 00                             ..@...@.

004000cc <deregister_tm_clones>:
  4000cc:	4803      	ldr	r0, [pc, #12]	; (4000dc <deregister_tm_clones+0x10>)
  4000ce:	4b04      	ldr	r3, [pc, #16]	; (4000e0 <deregister_tm_clones+0x14>)
  4000d0:	4283      	cmp	r3, r0
  4000d2:	d002      	beq.n	4000da <deregister_tm_clones+0xe>
  4000d4:	4b03      	ldr	r3, [pc, #12]	; (4000e4 <deregister_tm_clones+0x18>)
  4000d6:	b103      	cbz	r3, 4000da <deregister_tm_clones+0xe>
  4000d8:	4718      	bx	r3
  4000da:	4770      	bx	lr
  4000dc:	00401210 	.word	0x00401210
  4000e0:	00401210 	.word	0x00401210
  4000e4:	00000000 	.word	0x00000000

004000e8 <register_tm_clones>:
  4000e8:	4805      	ldr	r0, [pc, #20]	; (400100 <register_tm_clones+0x18>)
  4000ea:	4b06      	ldr	r3, [pc, #24]	; (400104 <register_tm_clones+0x1c>)
  4000ec:	1a1b      	subs	r3, r3, r0
  4000ee:	0fd9      	lsrs	r1, r3, #31
  4000f0:	eb01 01a3 	add.w	r1, r1, r3, asr #2
  4000f4:	1049      	asrs	r1, r1, #1
  4000f6:	d002      	beq.n	4000fe <register_tm_clones+0x16>
  4000f8:	4b03      	ldr	r3, [pc, #12]	; (400108 <register_tm_clones+0x20>)
  4000fa:	b103      	cbz	r3, 4000fe <register_tm_clones+0x16>
  4000fc:	4718      	bx	r3
  4000fe:	4770      	bx	lr
  400100:	00401210 	.word	0x00401210
  400104:	00401210 	.word	0x00401210
  400108:	00000000 	.word	0x00000000

0040010c <__do_global_dtors_aux>:
  40010c:	b510      	push	{r4, lr}
  40010e:	4c06      	ldr	r4, [pc, #24]	; (400128 <__do_global_dtors_aux+0x1c>)
  400110:	7823      	ldrb	r3, [r4, #0]
  400112:	b943      	cbnz	r3, 400126 <__do_global_dtors_aux+0x1a>
  400114:	f7ff ffda 	bl	4000cc <deregister_tm_clones>
  400118:	4b04      	ldr	r3, [pc, #16]	; (40012c <__do_global_dtors_aux+0x20>)
  40011a:	b113      	cbz	r3, 400122 <__do_global_dtors_aux+0x16>
  40011c:	4804      	ldr	r0, [pc, #16]	; (400130 <__do_global_dtors_aux+0x24>)
  40011e:	f3af 8000 	nop.w
  400122:	2301      	movs	r3, #1
  400124:	7023      	strb	r3, [r4, #0]
  400126:	bd10      	pop	{r4, pc}
  400128:	20000114 	.word	0x20000114
  40012c:	00000000 	.word	0x00000000
  400130:	00401210 	.word	0x00401210

00400134 <frame_dummy>:
  400134:	b508      	push	{r3, lr}
  400136:	4b04      	ldr	r3, [pc, #16]	; (400148 <frame_dummy+0x14>)
  400138:	b11b      	cbz	r3, 400142 <frame_dummy+0xe>
  40013a:	4904      	ldr	r1, [pc, #16]	; (40014c <frame_dummy+0x18>)
  40013c:	4804      	ldr	r0, [pc, #16]	; (400150 <frame_dummy+0x1c>)
  40013e:	f3af 8000 	nop.w
  400142:	e8bd 4008 	ldmia.w	sp!, {r3, lr}
  400146:	e7cf      	b.n	4000e8 <register_tm_clones>
  400148:	00000000 	.word	0x00000000
  40014c:	20000118 	.word	0x20000118
  400150:	00401210 	.word	0x00401210

00400154 <reset>:
  400154:	2000      	movs	r0, #0
  400156:	4770      	bx	lr

00400158 <enc_multi_setnum>:
  400158:	8803      	ldrh	r3, [r0, #0]
  40015a:	4a02      	ldr	r2, [pc, #8]	; (400164 <enc_multi_setnum+0xc>)
  40015c:	ba5b      	rev16	r3, r3
  40015e:	8013      	strh	r3, [r2, #0]
  400160:	2000      	movs	r0, #0
  400162:	4770      	bx	lr
  400164:	20000000 	.word	0x20000000

00400168 <get_mask>:
  400168:	b508      	push	{r3, lr}
  40016a:	4b02      	ldr	r3, [pc, #8]	; (400174 <get_mask+0xc>)
  40016c:	4798      	blx	r3
  40016e:	2000      	movs	r0, #0
  400170:	bd08      	pop	{r3, pc}
  400172:	bf00      	nop
  400174:	00400f99 	.word	0x00400f99

00400178 <get_key>:
  400178:	b508      	push	{r3, lr}
  40017a:	4b02      	ldr	r3, [pc, #8]	; (400184 <get_key+0xc>)
  40017c:	4798      	blx	r3
  40017e:	2000      	movs	r0, #0
  400180:	bd08      	pop	{r3, pc}
  400182:	bf00      	nop
  400184:	00400f85 	.word	0x00400f85

00400188 <get_pt>:
  400188:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
  40018c:	4a52      	ldr	r2, [pc, #328]	; (4002d8 <get_pt+0x150>)
  40018e:	b0a7      	sub	sp, #156	; 0x9c
  400190:	2300      	movs	r3, #0
  400192:	e9cd 2300 	strd	r2, r3, [sp]
  400196:	2200      	movs	r2, #0
  400198:	2300      	movs	r3, #0
  40019a:	e9cd 2302 	strd	r2, r3, [sp, #8]
  40019e:	aa04      	add	r2, sp, #16
  4001a0:	230f      	movs	r3, #15
  4001a2:	f81d 1003 	ldrb.w	r1, [sp, r3]
  4001a6:	f802 1b01 	strb.w	r1, [r2], #1
  4001aa:	3b01      	subs	r3, #1
  4001ac:	d2f9      	bcs.n	4001a2 <get_pt+0x1a>
  4001ae:	e9d0 6500 	ldrd	r6, r5, [r0]
  4001b2:	e9dd 8704 	ldrd	r8, r7, [sp, #16]
  4001b6:	e9dd ba06 	ldrd	fp, sl, [sp, #24]
  4001ba:	e9d0 9402 	ldrd	r9, r4, [r0, #8]
  4001be:	4b47      	ldr	r3, [pc, #284]	; (4002dc <get_pt+0x154>)
  4001c0:	e9cd 650e 	strd	r6, r5, [sp, #56]	; 0x38
  4001c4:	e9cd 870a 	strd	r8, r7, [sp, #40]	; 0x28
  4001c8:	4798      	blx	r3
  4001ca:	ea88 030b 	eor.w	r3, r8, fp
  4001ce:	f484 5c80 	eor.w	ip, r4, #4096	; 0x1000
  4001d2:	f083 0ef0 	eor.w	lr, r3, #240	; 0xf0
  4001d6:	ea87 020a 	eor.w	r2, r7, sl
  4001da:	4941      	ldr	r1, [pc, #260]	; (4002e0 <get_pt+0x158>)
  4001dc:	4841      	ldr	r0, [pc, #260]	; (4002e4 <get_pt+0x15c>)
  4001de:	ea85 0a04 	eor.w	sl, r5, r4
  4001e2:	4673      	mov	r3, lr
  4001e4:	4664      	mov	r4, ip
  4001e6:	43e4      	mvns	r4, r4
  4001e8:	43db      	mvns	r3, r3
  4001ea:	ea86 0b09 	eor.w	fp, r6, r9
  4001ee:	403c      	ands	r4, r7
  4001f0:	4033      	ands	r3, r6
  4001f2:	ea22 0707 	bic.w	r7, r2, r7
  4001f6:	ea89 0101 	eor.w	r1, r9, r1
  4001fa:	e9cd e20c 	strd	lr, r2, [sp, #48]	; 0x30
  4001fe:	ea25 0202 	bic.w	r2, r5, r2
  400202:	e9cd 3216 	strd	r3, r2, [sp, #88]	; 0x58
  400206:	e9cd 1c08 	strd	r1, ip, [sp, #32]
  40020a:	ea89 0000 	eor.w	r0, r9, r0
  40020e:	ea21 010b 	bic.w	r1, r1, fp
  400212:	ea2c 030a 	bic.w	r3, ip, sl
  400216:	ea00 0008 	and.w	r0, r0, r8
  40021a:	e9cd ba10 	strd	fp, sl, [sp, #64]	; 0x40
  40021e:	e9cd 131a 	strd	r1, r3, [sp, #104]	; 0x68
  400222:	e9cd 0412 	strd	r0, r4, [sp, #72]	; 0x48
  400226:	ea2a 0505 	bic.w	r5, sl, r5
  40022a:	ea2e 0008 	bic.w	r0, lr, r8
  40022e:	ea2b 0606 	bic.w	r6, fp, r6
  400232:	ac08      	add	r4, sp, #32
  400234:	e9cd 0714 	strd	r0, r7, [sp, #80]	; 0x50
  400238:	e9cd 6518 	strd	r6, r5, [sp, #96]	; 0x60
  40023c:	2200      	movs	r2, #0
  40023e:	4625      	mov	r5, r4
  400240:	2705      	movs	r7, #5
  400242:	3201      	adds	r2, #1
  400244:	fbb2 f3f7 	udiv	r3, r2, r7
  400248:	eb03 0383 	add.w	r3, r3, r3, lsl #2
  40024c:	ae26      	add	r6, sp, #152	; 0x98
  40024e:	1ad3      	subs	r3, r2, r3
  400250:	eb06 03c3 	add.w	r3, r6, r3, lsl #3
  400254:	e9d5 0100 	ldrd	r0, r1, [r5]
  400258:	e953 6314 	ldrd	r6, r3, [r3, #-80]	; 0x50
  40025c:	4070      	eors	r0, r6
  40025e:	f845 0b08 	str.w	r0, [r5], #8
  400262:	404b      	eors	r3, r1
  400264:	2a05      	cmp	r2, #5
  400266:	f845 3c04 	str.w	r3, [r5, #-4]
  40026a:	d1ea      	bne.n	400242 <get_pt+0xba>
  40026c:	e9dd 0108 	ldrd	r0, r1, [sp, #32]
  400270:	9b0a      	ldr	r3, [sp, #40]	; 0x28
  400272:	ea83 0200 	eor.w	r2, r3, r0
  400276:	9b0b      	ldr	r3, [sp, #44]	; 0x2c
  400278:	404b      	eors	r3, r1
  40027a:	e9cd 230a 	strd	r2, r3, [sp, #40]	; 0x28
  40027e:	9b10      	ldr	r3, [sp, #64]	; 0x40
  400280:	4058      	eors	r0, r3
  400282:	9b11      	ldr	r3, [sp, #68]	; 0x44
  400284:	404b      	eors	r3, r1
  400286:	e9cd 0308 	strd	r0, r3, [sp, #32]
  40028a:	e9dd 230c 	ldrd	r2, r3, [sp, #48]	; 0x30
  40028e:	990e      	ldr	r1, [sp, #56]	; 0x38
  400290:	ea81 0002 	eor.w	r0, r1, r2
  400294:	990f      	ldr	r1, [sp, #60]	; 0x3c
  400296:	43d2      	mvns	r2, r2
  400298:	4059      	eors	r1, r3
  40029a:	43db      	mvns	r3, r3
  40029c:	e9cd 230c 	strd	r2, r3, [sp, #48]	; 0x30
  4002a0:	4b11      	ldr	r3, [pc, #68]	; (4002e8 <get_pt+0x160>)
  4002a2:	e9cd 010e 	strd	r0, r1, [sp, #56]	; 0x38
  4002a6:	4798      	blx	r3
  4002a8:	2100      	movs	r1, #0
  4002aa:	ab1c      	add	r3, sp, #112	; 0x70
  4002ac:	4620      	mov	r0, r4
  4002ae:	3408      	adds	r4, #8
  4002b0:	185a      	adds	r2, r3, r1
  4002b2:	4623      	mov	r3, r4
  4002b4:	f813 5d01 	ldrb.w	r5, [r3, #-1]!
  4002b8:	f802 5b01 	strb.w	r5, [r2], #1
  4002bc:	4283      	cmp	r3, r0
  4002be:	d1f9      	bne.n	4002b4 <get_pt+0x12c>
  4002c0:	3108      	adds	r1, #8
  4002c2:	2928      	cmp	r1, #40	; 0x28
  4002c4:	d1f1      	bne.n	4002aa <get_pt+0x122>
  4002c6:	4b09      	ldr	r3, [pc, #36]	; (4002ec <get_pt+0x164>)
  4002c8:	aa1c      	add	r2, sp, #112	; 0x70
  4002ca:	2072      	movs	r0, #114	; 0x72
  4002cc:	4798      	blx	r3
  4002ce:	2000      	movs	r0, #0
  4002d0:	b027      	add	sp, #156	; 0x9c
  4002d2:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
  4002d6:	bf00      	nop
  4002d8:	00012345 	.word	0x00012345
  4002dc:	004008a9 	.word	0x004008a9
  4002e0:	808c0001 	.word	0x808c0001
  4002e4:	7f73fffe 	.word	0x7f73fffe
  4002e8:	00400889 	.word	0x00400889
  4002ec:	00400689 	.word	0x00400689

004002f0 <enc_multi_getpt>:
  4002f0:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
  4002f4:	4b0e      	ldr	r3, [pc, #56]	; (400330 <enc_multi_getpt+0x40>)
  4002f6:	4e0f      	ldr	r6, [pc, #60]	; (400334 <enc_multi_getpt+0x44>)
  4002f8:	4f0f      	ldr	r7, [pc, #60]	; (400338 <enc_multi_getpt+0x48>)
  4002fa:	f8df 8040 	ldr.w	r8, [pc, #64]	; 40033c <enc_multi_getpt+0x4c>
  4002fe:	4604      	mov	r4, r0
  400300:	4798      	blx	r3
  400302:	2500      	movs	r5, #0
  400304:	8833      	ldrh	r3, [r6, #0]
  400306:	42ab      	cmp	r3, r5
  400308:	d80a      	bhi.n	400320 <enc_multi_getpt+0x30>
  40030a:	4620      	mov	r0, r4
  40030c:	4b0c      	ldr	r3, [pc, #48]	; (400340 <enc_multi_getpt+0x50>)
  40030e:	4798      	blx	r3
  400310:	4b0c      	ldr	r3, [pc, #48]	; (400344 <enc_multi_getpt+0x54>)
  400312:	4622      	mov	r2, r4
  400314:	2110      	movs	r1, #16
  400316:	2072      	movs	r0, #114	; 0x72
  400318:	4798      	blx	r3
  40031a:	2000      	movs	r0, #0
  40031c:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
  400320:	47b8      	blx	r7
  400322:	4620      	mov	r0, r4
  400324:	47c0      	blx	r8
  400326:	4b08      	ldr	r3, [pc, #32]	; (400348 <enc_multi_getpt+0x58>)
  400328:	4798      	blx	r3
  40032a:	3501      	adds	r5, #1
  40032c:	e7ea      	b.n	400304 <enc_multi_getpt+0x14>
  40032e:	bf00      	nop
  400330:	00400f95 	.word	0x00400f95
  400334:	20000000 	.word	0x20000000
  400338:	004008a9 	.word	0x004008a9
  40033c:	00400f8d 	.word	0x00400f8d
  400340:	00400f97 	.word	0x00400f97
  400344:	00400689 	.word	0x00400689
  400348:	00400889 	.word	0x00400889

0040034c <main>:
  40034c:	b51f      	push	{r0, r1, r2, r3, r4, lr}
  40034e:	4b1c      	ldr	r3, [pc, #112]	; (4003c0 <main+0x74>)
  400350:	466a      	mov	r2, sp
  400352:	f103 0610 	add.w	r6, r3, #16
  400356:	4615      	mov	r5, r2
  400358:	6818      	ldr	r0, [r3, #0]
  40035a:	6859      	ldr	r1, [r3, #4]
  40035c:	4614      	mov	r4, r2
  40035e:	c403      	stmia	r4!, {r0, r1}
  400360:	3308      	adds	r3, #8
  400362:	42b3      	cmp	r3, r6
  400364:	4622      	mov	r2, r4
  400366:	d1f7      	bne.n	400358 <main+0xc>
  400368:	4b16      	ldr	r3, [pc, #88]	; (4003c4 <main+0x78>)
  40036a:	4c17      	ldr	r4, [pc, #92]	; (4003c8 <main+0x7c>)
  40036c:	4798      	blx	r3
  40036e:	4b17      	ldr	r3, [pc, #92]	; (4003cc <main+0x80>)
  400370:	4798      	blx	r3
  400372:	4b17      	ldr	r3, [pc, #92]	; (4003d0 <main+0x84>)
  400374:	4798      	blx	r3
  400376:	4b17      	ldr	r3, [pc, #92]	; (4003d4 <main+0x88>)
  400378:	4798      	blx	r3
  40037a:	4628      	mov	r0, r5
  40037c:	4b16      	ldr	r3, [pc, #88]	; (4003d8 <main+0x8c>)
  40037e:	4d17      	ldr	r5, [pc, #92]	; (4003dc <main+0x90>)
  400380:	4798      	blx	r3
  400382:	4b17      	ldr	r3, [pc, #92]	; (4003e0 <main+0x94>)
  400384:	4798      	blx	r3
  400386:	4a17      	ldr	r2, [pc, #92]	; (4003e4 <main+0x98>)
  400388:	2110      	movs	r1, #16
  40038a:	206b      	movs	r0, #107	; 0x6b
  40038c:	47a0      	blx	r4
  40038e:	4a16      	ldr	r2, [pc, #88]	; (4003e8 <main+0x9c>)
  400390:	2110      	movs	r1, #16
  400392:	2070      	movs	r0, #112	; 0x70
  400394:	47a0      	blx	r4
  400396:	4a15      	ldr	r2, [pc, #84]	; (4003ec <main+0xa0>)
  400398:	2100      	movs	r1, #0
  40039a:	2078      	movs	r0, #120	; 0x78
  40039c:	47a0      	blx	r4
  40039e:	2301      	movs	r3, #1
  4003a0:	4a13      	ldr	r2, [pc, #76]	; (4003f0 <main+0xa4>)
  4003a2:	2112      	movs	r1, #18
  4003a4:	206d      	movs	r0, #109	; 0x6d
  4003a6:	47a8      	blx	r5
  4003a8:	4a12      	ldr	r2, [pc, #72]	; (4003f4 <main+0xa8>)
  4003aa:	2102      	movs	r1, #2
  4003ac:	2073      	movs	r0, #115	; 0x73
  4003ae:	47a0      	blx	r4
  4003b0:	4a11      	ldr	r2, [pc, #68]	; (4003f8 <main+0xac>)
  4003b2:	2110      	movs	r1, #16
  4003b4:	2066      	movs	r0, #102	; 0x66
  4003b6:	47a0      	blx	r4
  4003b8:	4c10      	ldr	r4, [pc, #64]	; (4003fc <main+0xb0>)
  4003ba:	47a0      	blx	r4
  4003bc:	e7fd      	b.n	4003ba <main+0x6e>
  4003be:	bf00      	nop
  4003c0:	004011c4 	.word	0x004011c4
  4003c4:	0040072d 	.word	0x0040072d
  4003c8:	00400581 	.word	0x00400581
  4003cc:	004007c5 	.word	0x004007c5
  4003d0:	00400869 	.word	0x00400869
  4003d4:	00400f81 	.word	0x00400f81
  4003d8:	00400f85 	.word	0x00400f85
  4003dc:	00400549 	.word	0x00400549
  4003e0:	00400591 	.word	0x00400591
  4003e4:	00400179 	.word	0x00400179
  4003e8:	00400189 	.word	0x00400189
  4003ec:	00400155 	.word	0x00400155
  4003f0:	00400169 	.word	0x00400169
  4003f4:	00400159 	.word	0x00400159
  4003f8:	004002f1 	.word	0x004002f1
  4003fc:	004005c1 	.word	0x004005c1

00400400 <check_version>:
  400400:	2001      	movs	r0, #1
  400402:	4770      	bx	lr

00400404 <simpleserial_put.part.0>:
  400404:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
  400408:	4c0e      	ldr	r4, [pc, #56]	; (400444 <simpleserial_put.part.0+0x40>)
  40040a:	f8df 803c 	ldr.w	r8, [pc, #60]	; 400448 <simpleserial_put.part.0+0x44>
  40040e:	4615      	mov	r5, r2
  400410:	460f      	mov	r7, r1
  400412:	47a0      	blx	r4
  400414:	1e6e      	subs	r6, r5, #1
  400416:	f1c5 0501 	rsb	r5, r5, #1
  40041a:	19ab      	adds	r3, r5, r6
  40041c:	429f      	cmp	r7, r3
  40041e:	dc04      	bgt.n	40042a <simpleserial_put.part.0+0x26>
  400420:	4623      	mov	r3, r4
  400422:	200a      	movs	r0, #10
  400424:	e8bd 41f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, lr}
  400428:	4718      	bx	r3
  40042a:	f816 3f01 	ldrb.w	r3, [r6, #1]!
  40042e:	091b      	lsrs	r3, r3, #4
  400430:	f818 0003 	ldrb.w	r0, [r8, r3]
  400434:	47a0      	blx	r4
  400436:	7833      	ldrb	r3, [r6, #0]
  400438:	f003 030f 	and.w	r3, r3, #15
  40043c:	f818 0003 	ldrb.w	r0, [r8, r3]
  400440:	47a0      	blx	r4
  400442:	e7ea      	b.n	40041a <simpleserial_put.part.0+0x16>
  400444:	00400829 	.word	0x00400829
  400448:	004011d5 	.word	0x004011d5

0040044c <ss_num_commands>:
  40044c:	b507      	push	{r0, r1, r2, lr}
  40044e:	4b07      	ldr	r3, [pc, #28]	; (40046c <ss_num_commands+0x20>)
  400450:	681b      	ldr	r3, [r3, #0]
  400452:	f88d 3007 	strb.w	r3, [sp, #7]
  400456:	f10d 0207 	add.w	r2, sp, #7
  40045a:	4b05      	ldr	r3, [pc, #20]	; (400470 <ss_num_commands+0x24>)
  40045c:	2101      	movs	r1, #1
  40045e:	2072      	movs	r0, #114	; 0x72
  400460:	4798      	blx	r3
  400462:	2000      	movs	r0, #0
  400464:	b003      	add	sp, #12
  400466:	f85d fb04 	ldr.w	pc, [sp], #4
  40046a:	bf00      	nop
  40046c:	20000330 	.word	0x20000330
  400470:	00400405 	.word	0x00400405

00400474 <ss_get_commands>:
  400474:	b570      	push	{r4, r5, r6, lr}
  400476:	4b13      	ldr	r3, [pc, #76]	; (4004c4 <ss_get_commands+0x50>)
  400478:	4c13      	ldr	r4, [pc, #76]	; (4004c8 <ss_get_commands+0x54>)
  40047a:	6819      	ldr	r1, [r3, #0]
  40047c:	b098      	sub	sp, #96	; 0x60
  40047e:	b2cd      	uxtb	r5, r1
  400480:	2000      	movs	r0, #0
  400482:	b2c3      	uxtb	r3, r0
  400484:	42ab      	cmp	r3, r5
  400486:	f100 0001 	add.w	r0, r0, #1
  40048a:	db09      	blt.n	4004a0 <ss_get_commands+0x2c>
  40048c:	eb01 0141 	add.w	r1, r1, r1, lsl #1
  400490:	4b0e      	ldr	r3, [pc, #56]	; (4004cc <ss_get_commands+0x58>)
  400492:	466a      	mov	r2, sp
  400494:	b2c9      	uxtb	r1, r1
  400496:	2072      	movs	r0, #114	; 0x72
  400498:	4798      	blx	r3
  40049a:	2000      	movs	r0, #0
  40049c:	b018      	add	sp, #96	; 0x60
  40049e:	bd70      	pop	{r4, r5, r6, pc}
  4004a0:	eb03 0243 	add.w	r2, r3, r3, lsl #1
  4004a4:	011e      	lsls	r6, r3, #4
  4004a6:	3260      	adds	r2, #96	; 0x60
  4004a8:	446a      	add	r2, sp
  4004aa:	eb04 1303 	add.w	r3, r4, r3, lsl #4
  4004ae:	5da6      	ldrb	r6, [r4, r6]
  4004b0:	f802 6c60 	strb.w	r6, [r2, #-96]
  4004b4:	685e      	ldr	r6, [r3, #4]
  4004b6:	7b1b      	ldrb	r3, [r3, #12]
  4004b8:	f802 6c5f 	strb.w	r6, [r2, #-95]
  4004bc:	f802 3c5e 	strb.w	r3, [r2, #-94]
  4004c0:	e7df      	b.n	400482 <ss_get_commands+0xe>
  4004c2:	bf00      	nop
  4004c4:	20000330 	.word	0x20000330
  4004c8:	20000130 	.word	0x20000130
  4004cc:	00400405 	.word	0x00400405

004004d0 <hex_decode>:
  4004d0:	b5f0      	push	{r4, r5, r6, r7, lr}
  4004d2:	2500      	movs	r5, #0
  4004d4:	1c4f      	adds	r7, r1, #1
  4004d6:	4285      	cmp	r5, r0
  4004d8:	db01      	blt.n	4004de <hex_decode+0xe>
  4004da:	2000      	movs	r0, #0
  4004dc:	e021      	b.n	400522 <hex_decode+0x52>
  4004de:	f817 4015 	ldrb.w	r4, [r7, r5, lsl #1]
  4004e2:	f811 3015 	ldrb.w	r3, [r1, r5, lsl #1]
  4004e6:	f1a4 0630 	sub.w	r6, r4, #48	; 0x30
  4004ea:	b2f6      	uxtb	r6, r6
  4004ec:	2e09      	cmp	r6, #9
  4004ee:	d80c      	bhi.n	40050a <hex_decode+0x3a>
  4004f0:	7016      	strb	r6, [r2, #0]
  4004f2:	f1a3 0430 	sub.w	r4, r3, #48	; 0x30
  4004f6:	b2e4      	uxtb	r4, r4
  4004f8:	2c09      	cmp	r4, #9
  4004fa:	d815      	bhi.n	400528 <hex_decode+0x58>
  4004fc:	7813      	ldrb	r3, [r2, #0]
  4004fe:	ea43 1304 	orr.w	r3, r3, r4, lsl #4
  400502:	7013      	strb	r3, [r2, #0]
  400504:	3501      	adds	r5, #1
  400506:	3201      	adds	r2, #1
  400508:	e7e5      	b.n	4004d6 <hex_decode+0x6>
  40050a:	f1a4 0641 	sub.w	r6, r4, #65	; 0x41
  40050e:	2e05      	cmp	r6, #5
  400510:	d802      	bhi.n	400518 <hex_decode+0x48>
  400512:	3c37      	subs	r4, #55	; 0x37
  400514:	7014      	strb	r4, [r2, #0]
  400516:	e7ec      	b.n	4004f2 <hex_decode+0x22>
  400518:	f1a4 0661 	sub.w	r6, r4, #97	; 0x61
  40051c:	2e05      	cmp	r6, #5
  40051e:	d901      	bls.n	400524 <hex_decode+0x54>
  400520:	2001      	movs	r0, #1
  400522:	bdf0      	pop	{r4, r5, r6, r7, pc}
  400524:	3c57      	subs	r4, #87	; 0x57
  400526:	e7f5      	b.n	400514 <hex_decode+0x44>
  400528:	f1a3 0441 	sub.w	r4, r3, #65	; 0x41
  40052c:	2c05      	cmp	r4, #5
  40052e:	d802      	bhi.n	400536 <hex_decode+0x66>
  400530:	f1a3 0437 	sub.w	r4, r3, #55	; 0x37
  400534:	e7e2      	b.n	4004fc <hex_decode+0x2c>
  400536:	f1a3 0461 	sub.w	r4, r3, #97	; 0x61
  40053a:	2c05      	cmp	r4, #5
  40053c:	d8f0      	bhi.n	400520 <hex_decode+0x50>
  40053e:	7814      	ldrb	r4, [r2, #0]
  400540:	3b57      	subs	r3, #87	; 0x57
  400542:	ea44 1303 	orr.w	r3, r4, r3, lsl #4
  400546:	e7dc      	b.n	400502 <hex_decode+0x32>

00400548 <simpleserial_addcmd_flags>:
  400548:	b5f0      	push	{r4, r5, r6, r7, lr}
  40054a:	4e0b      	ldr	r6, [pc, #44]	; (400578 <simpleserial_addcmd_flags+0x30>)
  40054c:	6834      	ldr	r4, [r6, #0]
  40054e:	2c1f      	cmp	r4, #31
  400550:	dc0f      	bgt.n	400572 <simpleserial_addcmd_flags+0x2a>
  400552:	293f      	cmp	r1, #63	; 0x3f
  400554:	d80d      	bhi.n	400572 <simpleserial_addcmd_flags+0x2a>
  400556:	4f09      	ldr	r7, [pc, #36]	; (40057c <simpleserial_addcmd_flags+0x34>)
  400558:	eb07 1504 	add.w	r5, r7, r4, lsl #4
  40055c:	ea4f 1c04 	mov.w	ip, r4, lsl #4
  400560:	e9c5 1201 	strd	r1, r2, [r5, #4]
  400564:	3401      	adds	r4, #1
  400566:	f807 000c 	strb.w	r0, [r7, ip]
  40056a:	732b      	strb	r3, [r5, #12]
  40056c:	6034      	str	r4, [r6, #0]
  40056e:	2000      	movs	r0, #0
  400570:	bdf0      	pop	{r4, r5, r6, r7, pc}
  400572:	2001      	movs	r0, #1
  400574:	e7fc      	b.n	400570 <simpleserial_addcmd_flags+0x28>
  400576:	bf00      	nop
  400578:	20000330 	.word	0x20000330
  40057c:	20000130 	.word	0x20000130

00400580 <simpleserial_addcmd>:
  400580:	b410      	push	{r4}
  400582:	4c02      	ldr	r4, [pc, #8]	; (40058c <simpleserial_addcmd+0xc>)
  400584:	2300      	movs	r3, #0
  400586:	46a4      	mov	ip, r4
  400588:	bc10      	pop	{r4}
  40058a:	4760      	bx	ip
  40058c:	00400549 	.word	0x00400549

00400590 <simpleserial_init>:
  400590:	b510      	push	{r4, lr}
  400592:	4a07      	ldr	r2, [pc, #28]	; (4005b0 <simpleserial_init+0x20>)
  400594:	4c07      	ldr	r4, [pc, #28]	; (4005b4 <simpleserial_init+0x24>)
  400596:	2100      	movs	r1, #0
  400598:	2076      	movs	r0, #118	; 0x76
  40059a:	47a0      	blx	r4
  40059c:	4a06      	ldr	r2, [pc, #24]	; (4005b8 <simpleserial_init+0x28>)
  40059e:	2077      	movs	r0, #119	; 0x77
  4005a0:	47a0      	blx	r4
  4005a2:	4623      	mov	r3, r4
  4005a4:	4a05      	ldr	r2, [pc, #20]	; (4005bc <simpleserial_init+0x2c>)
  4005a6:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  4005aa:	2079      	movs	r0, #121	; 0x79
  4005ac:	4718      	bx	r3
  4005ae:	bf00      	nop
  4005b0:	00400401 	.word	0x00400401
  4005b4:	00400581 	.word	0x00400581
  4005b8:	00400475 	.word	0x00400475
  4005bc:	0040044d 	.word	0x0040044d

004005c0 <simpleserial_get>:
  4005c0:	e92d 43f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, lr}
  4005c4:	4e2b      	ldr	r6, [pc, #172]	; (400674 <simpleserial_get+0xb4>)
  4005c6:	b0b3      	sub	sp, #204	; 0xcc
  4005c8:	47b0      	blx	r6
  4005ca:	4b2b      	ldr	r3, [pc, #172]	; (400678 <simpleserial_get+0xb8>)
  4005cc:	492b      	ldr	r1, [pc, #172]	; (40067c <simpleserial_get+0xbc>)
  4005ce:	681a      	ldr	r2, [r3, #0]
  4005d0:	2300      	movs	r3, #0
  4005d2:	429a      	cmp	r2, r3
  4005d4:	dc3e      	bgt.n	400654 <simpleserial_get+0x94>
  4005d6:	d03a      	beq.n	40064e <simpleserial_get+0x8e>
  4005d8:	4c28      	ldr	r4, [pc, #160]	; (40067c <simpleserial_get+0xbc>)
  4005da:	eb04 1503 	add.w	r5, r4, r3, lsl #4
  4005de:	011f      	lsls	r7, r3, #4
  4005e0:	7b2b      	ldrb	r3, [r5, #12]
  4005e2:	07db      	lsls	r3, r3, #31
  4005e4:	d511      	bpl.n	40060a <simpleserial_get+0x4a>
  4005e6:	2300      	movs	r3, #0
  4005e8:	f88d 3008 	strb.w	r3, [sp, #8]
  4005ec:	47b0      	blx	r6
  4005ee:	f88d 0048 	strb.w	r0, [sp, #72]	; 0x48
  4005f2:	47b0      	blx	r6
  4005f4:	4b22      	ldr	r3, [pc, #136]	; (400680 <simpleserial_get+0xc0>)
  4005f6:	f88d 0049 	strb.w	r0, [sp, #73]	; 0x49
  4005fa:	aa02      	add	r2, sp, #8
  4005fc:	a912      	add	r1, sp, #72	; 0x48
  4005fe:	2001      	movs	r0, #1
  400600:	4798      	blx	r3
  400602:	bb20      	cbnz	r0, 40064e <simpleserial_get+0x8e>
  400604:	f89d 3008 	ldrb.w	r3, [sp, #8]
  400608:	606b      	str	r3, [r5, #4]
  40060a:	f10d 0848 	add.w	r8, sp, #72	; 0x48
  40060e:	2500      	movs	r5, #0
  400610:	eb04 0907 	add.w	r9, r4, r7
  400614:	f8d9 3004 	ldr.w	r3, [r9, #4]
  400618:	ebb5 0f43 	cmp.w	r5, r3, lsl #1
  40061c:	d320      	bcc.n	400660 <simpleserial_get+0xa0>
  40061e:	47b0      	blx	r6
  400620:	280a      	cmp	r0, #10
  400622:	d001      	beq.n	400628 <simpleserial_get+0x68>
  400624:	280d      	cmp	r0, #13
  400626:	d112      	bne.n	40064e <simpleserial_get+0x8e>
  400628:	443c      	add	r4, r7
  40062a:	4b15      	ldr	r3, [pc, #84]	; (400680 <simpleserial_get+0xc0>)
  40062c:	6865      	ldr	r5, [r4, #4]
  40062e:	aa02      	add	r2, sp, #8
  400630:	a912      	add	r1, sp, #72	; 0x48
  400632:	4628      	mov	r0, r5
  400634:	4798      	blx	r3
  400636:	b950      	cbnz	r0, 40064e <simpleserial_get+0x8e>
  400638:	68a3      	ldr	r3, [r4, #8]
  40063a:	b2e9      	uxtb	r1, r5
  40063c:	a802      	add	r0, sp, #8
  40063e:	4798      	blx	r3
  400640:	4b10      	ldr	r3, [pc, #64]	; (400684 <simpleserial_get+0xc4>)
  400642:	f88d 0004 	strb.w	r0, [sp, #4]
  400646:	aa01      	add	r2, sp, #4
  400648:	2101      	movs	r1, #1
  40064a:	207a      	movs	r0, #122	; 0x7a
  40064c:	4798      	blx	r3
  40064e:	b033      	add	sp, #204	; 0xcc
  400650:	e8bd 83f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, pc}
  400654:	011c      	lsls	r4, r3, #4
  400656:	5d0c      	ldrb	r4, [r1, r4]
  400658:	4284      	cmp	r4, r0
  40065a:	d0bd      	beq.n	4005d8 <simpleserial_get+0x18>
  40065c:	3301      	adds	r3, #1
  40065e:	e7b8      	b.n	4005d2 <simpleserial_get+0x12>
  400660:	47b0      	blx	r6
  400662:	280a      	cmp	r0, #10
  400664:	d0f3      	beq.n	40064e <simpleserial_get+0x8e>
  400666:	280d      	cmp	r0, #13
  400668:	d0f1      	beq.n	40064e <simpleserial_get+0x8e>
  40066a:	f808 0b01 	strb.w	r0, [r8], #1
  40066e:	3501      	adds	r5, #1
  400670:	e7d0      	b.n	400614 <simpleserial_get+0x54>
  400672:	bf00      	nop
  400674:	00400845 	.word	0x00400845
  400678:	20000330 	.word	0x20000330
  40067c:	20000130 	.word	0x20000130
  400680:	004004d1 	.word	0x004004d1
  400684:	00400405 	.word	0x00400405

00400688 <simpleserial_put>:
  400688:	b10a      	cbz	r2, 40068e <simpleserial_put+0x6>
  40068a:	4b01      	ldr	r3, [pc, #4]	; (400690 <simpleserial_put+0x8>)
  40068c:	4718      	bx	r3
  40068e:	4770      	bx	lr
  400690:	00400405 	.word	0x00400405

00400694 <Dummy_Handler>:
  400694:	e7fe      	b.n	400694 <Dummy_Handler>
	...

00400698 <Reset_Handler>:
  400698:	4919      	ldr	r1, [pc, #100]	; (400700 <Reset_Handler+0x68>)
  40069a:	481a      	ldr	r0, [pc, #104]	; (400704 <Reset_Handler+0x6c>)
  40069c:	4281      	cmp	r1, r0
  40069e:	b510      	push	{r4, lr}
  4006a0:	d920      	bls.n	4006e4 <Reset_Handler+0x4c>
  4006a2:	4b19      	ldr	r3, [pc, #100]	; (400708 <Reset_Handler+0x70>)
  4006a4:	1cda      	adds	r2, r3, #3
  4006a6:	1a12      	subs	r2, r2, r0
  4006a8:	f022 0203 	bic.w	r2, r2, #3
  4006ac:	1ec4      	subs	r4, r0, #3
  4006ae:	429c      	cmp	r4, r3
  4006b0:	bf88      	it	hi
  4006b2:	2200      	movhi	r2, #0
  4006b4:	4b15      	ldr	r3, [pc, #84]	; (40070c <Reset_Handler+0x74>)
  4006b6:	4798      	blx	r3
  4006b8:	bf00      	nop
  4006ba:	4b15      	ldr	r3, [pc, #84]	; (400710 <Reset_Handler+0x78>)
  4006bc:	4815      	ldr	r0, [pc, #84]	; (400714 <Reset_Handler+0x7c>)
  4006be:	1cda      	adds	r2, r3, #3
  4006c0:	1a12      	subs	r2, r2, r0
  4006c2:	1ec1      	subs	r1, r0, #3
  4006c4:	f022 0203 	bic.w	r2, r2, #3
  4006c8:	4299      	cmp	r1, r3
  4006ca:	bf88      	it	hi
  4006cc:	2200      	movhi	r2, #0
  4006ce:	4b12      	ldr	r3, [pc, #72]	; (400718 <Reset_Handler+0x80>)
  4006d0:	2100      	movs	r1, #0
  4006d2:	4798      	blx	r3
  4006d4:	4b11      	ldr	r3, [pc, #68]	; (40071c <Reset_Handler+0x84>)
  4006d6:	4a12      	ldr	r2, [pc, #72]	; (400720 <Reset_Handler+0x88>)
  4006d8:	609a      	str	r2, [r3, #8]
  4006da:	4b12      	ldr	r3, [pc, #72]	; (400724 <Reset_Handler+0x8c>)
  4006dc:	4798      	blx	r3
  4006de:	4b12      	ldr	r3, [pc, #72]	; (400728 <Reset_Handler+0x90>)
  4006e0:	4798      	blx	r3
  4006e2:	e7fe      	b.n	4006e2 <Reset_Handler+0x4a>
  4006e4:	d2e8      	bcs.n	4006b8 <Reset_Handler+0x20>
  4006e6:	4b08      	ldr	r3, [pc, #32]	; (400708 <Reset_Handler+0x70>)
  4006e8:	1f0a      	subs	r2, r1, #4
  4006ea:	1a18      	subs	r0, r3, r0
  4006ec:	4410      	add	r0, r2
  4006ee:	f1c1 0104 	rsb	r1, r1, #4
  4006f2:	42c8      	cmn	r0, r1
  4006f4:	d0e0      	beq.n	4006b8 <Reset_Handler+0x20>
  4006f6:	f850 2904 	ldr.w	r2, [r0], #-4
  4006fa:	f843 2d04 	str.w	r2, [r3, #-4]!
  4006fe:	e7f8      	b.n	4006f2 <Reset_Handler+0x5a>
  400700:	00401210 	.word	0x00401210
  400704:	20000000 	.word	0x20000000
  400708:	20000114 	.word	0x20000114
  40070c:	00401091 	.word	0x00401091
  400710:	200003fc 	.word	0x200003fc
  400714:	20000114 	.word	0x20000114
  400718:	00400fed 	.word	0x00400fed
  40071c:	e000ed00 	.word	0xe000ed00
  400720:	00400000 	.word	0x00400000
  400724:	00400f9d 	.word	0x00400f9d
  400728:	0040034d 	.word	0x0040034d

0040072c <platform_init>:
  40072c:	4b18      	ldr	r3, [pc, #96]	; (400790 <platform_init+0x64>)
  40072e:	f44f 4200 	mov.w	r2, #32768	; 0x8000
  400732:	b570      	push	{r4, r5, r6, lr}
  400734:	2000      	movs	r0, #0
  400736:	655a      	str	r2, [r3, #84]	; 0x54
  400738:	4c16      	ldr	r4, [pc, #88]	; (400794 <platform_init+0x68>)
  40073a:	4d17      	ldr	r5, [pc, #92]	; (400798 <platform_init+0x6c>)
  40073c:	4e17      	ldr	r6, [pc, #92]	; (40079c <platform_init+0x70>)
  40073e:	47a0      	blx	r4
  400740:	2001      	movs	r0, #1
  400742:	47a0      	blx	r4
  400744:	2005      	movs	r0, #5
  400746:	47a0      	blx	r4
  400748:	4b15      	ldr	r3, [pc, #84]	; (4007a0 <platform_init+0x74>)
  40074a:	2000      	movs	r0, #0
  40074c:	4798      	blx	r3
  40074e:	4815      	ldr	r0, [pc, #84]	; (4007a4 <platform_init+0x78>)
  400750:	47a8      	blx	r5
  400752:	4b15      	ldr	r3, [pc, #84]	; (4007a8 <platform_init+0x7c>)
  400754:	2000      	movs	r0, #0
  400756:	4798      	blx	r3
  400758:	4b14      	ldr	r3, [pc, #80]	; (4007ac <platform_init+0x80>)
  40075a:	213e      	movs	r1, #62	; 0x3e
  40075c:	2001      	movs	r0, #1
  40075e:	4798      	blx	r3
  400760:	47b0      	blx	r6
  400762:	2800      	cmp	r0, #0
  400764:	d0fc      	beq.n	400760 <platform_init+0x34>
  400766:	4b12      	ldr	r3, [pc, #72]	; (4007b0 <platform_init+0x84>)
  400768:	2000      	movs	r0, #0
  40076a:	4798      	blx	r3
  40076c:	4b11      	ldr	r3, [pc, #68]	; (4007b4 <platform_init+0x88>)
  40076e:	4798      	blx	r3
  400770:	4811      	ldr	r0, [pc, #68]	; (4007b8 <platform_init+0x8c>)
  400772:	47a8      	blx	r5
  400774:	4a11      	ldr	r2, [pc, #68]	; (4007bc <platform_init+0x90>)
  400776:	6813      	ldr	r3, [r2, #0]
  400778:	f023 6380 	bic.w	r3, r3, #67108864	; 0x4000000
  40077c:	6013      	str	r3, [r2, #0]
  40077e:	200b      	movs	r0, #11
  400780:	47a0      	blx	r4
  400782:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
  400786:	4b0e      	ldr	r3, [pc, #56]	; (4007c0 <platform_init+0x94>)
  400788:	f04f 5160 	mov.w	r1, #939524096	; 0x38000000
  40078c:	200f      	movs	r0, #15
  40078e:	4718      	bx	r3
  400790:	400e1400 	.word	0x400e1400
  400794:	00400ccd 	.word	0x00400ccd
  400798:	00400b89 	.word	0x00400b89
  40079c:	00400cbd 	.word	0x00400cbd
  4007a0:	00400d09 	.word	0x00400d09
  4007a4:	07270e00 	.word	0x07270e00
  4007a8:	00400bed 	.word	0x00400bed
  4007ac:	00400c71 	.word	0x00400c71
  4007b0:	00400c2d 	.word	0x00400c2d
  4007b4:	00400abd 	.word	0x00400abd
  4007b8:	00707510 	.word	0x00707510
  4007bc:	400e0a00 	.word	0x400e0a00
  4007c0:	00400a19 	.word	0x00400a19

004007c4 <init_uart>:
  4007c4:	b51f      	push	{r0, r1, r2, r3, r4, lr}
  4007c6:	4b10      	ldr	r3, [pc, #64]	; (400808 <init_uart+0x44>)
  4007c8:	4c10      	ldr	r4, [pc, #64]	; (40080c <init_uart+0x48>)
  4007ca:	f44f 4216 	mov.w	r2, #38400	; 0x9600
  4007ce:	e9cd 3201 	strd	r3, r2, [sp, #4]
  4007d2:	f44f 6300 	mov.w	r3, #2048	; 0x800
  4007d6:	9303      	str	r3, [sp, #12]
  4007d8:	2008      	movs	r0, #8
  4007da:	4b0d      	ldr	r3, [pc, #52]	; (400810 <init_uart+0x4c>)
  4007dc:	4798      	blx	r3
  4007de:	a901      	add	r1, sp, #4
  4007e0:	4b0c      	ldr	r3, [pc, #48]	; (400814 <init_uart+0x50>)
  4007e2:	4620      	mov	r0, r4
  4007e4:	4798      	blx	r3
  4007e6:	4620      	mov	r0, r4
  4007e8:	4b0b      	ldr	r3, [pc, #44]	; (400818 <init_uart+0x54>)
  4007ea:	4798      	blx	r3
  4007ec:	4b0b      	ldr	r3, [pc, #44]	; (40081c <init_uart+0x58>)
  4007ee:	4620      	mov	r0, r4
  4007f0:	4798      	blx	r3
  4007f2:	4c0b      	ldr	r4, [pc, #44]	; (400820 <init_uart+0x5c>)
  4007f4:	490b      	ldr	r1, [pc, #44]	; (400824 <init_uart+0x60>)
  4007f6:	2009      	movs	r0, #9
  4007f8:	47a0      	blx	r4
  4007fa:	f04f 6100 	mov.w	r1, #134217728	; 0x8000000
  4007fe:	200a      	movs	r0, #10
  400800:	47a0      	blx	r4
  400802:	b004      	add	sp, #16
  400804:	bd10      	pop	{r4, pc}
  400806:	bf00      	nop
  400808:	0071ad90 	.word	0x0071ad90
  40080c:	400e0600 	.word	0x400e0600
  400810:	00400ccd 	.word	0x00400ccd
  400814:	004008c9 	.word	0x004008c9
  400818:	00400903 	.word	0x00400903
  40081c:	004008fd 	.word	0x004008fd
  400820:	00400a19 	.word	0x00400a19
  400824:	08000001 	.word	0x08000001

00400828 <putch>:
  400828:	b570      	push	{r4, r5, r6, lr}
  40082a:	4e04      	ldr	r6, [pc, #16]	; (40083c <putch+0x14>)
  40082c:	4d04      	ldr	r5, [pc, #16]	; (400840 <putch+0x18>)
  40082e:	4604      	mov	r4, r0
  400830:	4621      	mov	r1, r4
  400832:	4630      	mov	r0, r6
  400834:	47a8      	blx	r5
  400836:	2800      	cmp	r0, #0
  400838:	d1fa      	bne.n	400830 <putch+0x8>
  40083a:	bd70      	pop	{r4, r5, r6, pc}
  40083c:	400e0600 	.word	0x400e0600
  400840:	00400909 	.word	0x00400909

00400844 <getch>:
  400844:	b537      	push	{r0, r1, r2, r4, r5, lr}
  400846:	4d06      	ldr	r5, [pc, #24]	; (400860 <getch+0x1c>)
  400848:	4c06      	ldr	r4, [pc, #24]	; (400864 <getch+0x20>)
  40084a:	f10d 0107 	add.w	r1, sp, #7
  40084e:	4628      	mov	r0, r5
  400850:	47a0      	blx	r4
  400852:	2800      	cmp	r0, #0
  400854:	d1f9      	bne.n	40084a <getch+0x6>
  400856:	f89d 0007 	ldrb.w	r0, [sp, #7]
  40085a:	b003      	add	sp, #12
  40085c:	bd30      	pop	{r4, r5, pc}
  40085e:	bf00      	nop
  400860:	400e0600 	.word	0x400e0600
  400864:	00400917 	.word	0x00400917

00400868 <trigger_setup>:
  400868:	b510      	push	{r4, lr}
  40086a:	4b05      	ldr	r3, [pc, #20]	; (400880 <trigger_setup+0x18>)
  40086c:	200b      	movs	r0, #11
  40086e:	4798      	blx	r3
  400870:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400874:	4b03      	ldr	r3, [pc, #12]	; (400884 <trigger_setup+0x1c>)
  400876:	f04f 5140 	mov.w	r1, #805306368	; 0x30000000
  40087a:	2007      	movs	r0, #7
  40087c:	4718      	bx	r3
  40087e:	bf00      	nop
  400880:	00400ccd 	.word	0x00400ccd
  400884:	00400a19 	.word	0x00400a19

00400888 <trigger_low>:
  400888:	b510      	push	{r4, lr}
  40088a:	4b05      	ldr	r3, [pc, #20]	; (4008a0 <trigger_low+0x18>)
  40088c:	2007      	movs	r0, #7
  40088e:	4798      	blx	r3
  400890:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400894:	4b03      	ldr	r3, [pc, #12]	; (4008a4 <trigger_low+0x1c>)
  400896:	f04f 5140 	mov.w	r1, #805306368	; 0x30000000
  40089a:	2007      	movs	r0, #7
  40089c:	4718      	bx	r3
  40089e:	bf00      	nop
  4008a0:	004009ff 	.word	0x004009ff
  4008a4:	00400a19 	.word	0x00400a19

004008a8 <trigger_high>:
  4008a8:	b510      	push	{r4, lr}
  4008aa:	4b05      	ldr	r3, [pc, #20]	; (4008c0 <trigger_high+0x18>)
  4008ac:	2007      	movs	r0, #7
  4008ae:	4798      	blx	r3
  4008b0:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  4008b4:	4b03      	ldr	r3, [pc, #12]	; (4008c4 <trigger_high+0x1c>)
  4008b6:	f04f 5160 	mov.w	r1, #939524096	; 0x38000000
  4008ba:	2007      	movs	r0, #7
  4008bc:	4718      	bx	r3
  4008be:	bf00      	nop
  4008c0:	004009e7 	.word	0x004009e7
  4008c4:	00400a19 	.word	0x00400a19

004008c8 <uart_init>:
  4008c8:	23ac      	movs	r3, #172	; 0xac
  4008ca:	b510      	push	{r4, lr}
  4008cc:	6003      	str	r3, [r0, #0]
  4008ce:	e9d1 3200 	ldrd	r3, r2, [r1]
  4008d2:	fbb3 f3f2 	udiv	r3, r3, r2
  4008d6:	091b      	lsrs	r3, r3, #4
  4008d8:	1e5c      	subs	r4, r3, #1
  4008da:	f64f 72fe 	movw	r2, #65534	; 0xfffe
  4008de:	4294      	cmp	r4, r2
  4008e0:	d80a      	bhi.n	4008f8 <uart_init+0x30>
  4008e2:	6203      	str	r3, [r0, #32]
  4008e4:	688b      	ldr	r3, [r1, #8]
  4008e6:	6043      	str	r3, [r0, #4]
  4008e8:	f240 2302 	movw	r3, #514	; 0x202
  4008ec:	f8c0 3120 	str.w	r3, [r0, #288]	; 0x120
  4008f0:	2350      	movs	r3, #80	; 0x50
  4008f2:	6003      	str	r3, [r0, #0]
  4008f4:	2000      	movs	r0, #0
  4008f6:	bd10      	pop	{r4, pc}
  4008f8:	2001      	movs	r0, #1
  4008fa:	e7fc      	b.n	4008f6 <uart_init+0x2e>

004008fc <uart_enable_tx>:
  4008fc:	2340      	movs	r3, #64	; 0x40
  4008fe:	6003      	str	r3, [r0, #0]
  400900:	4770      	bx	lr

00400902 <uart_enable_rx>:
  400902:	2310      	movs	r3, #16
  400904:	6003      	str	r3, [r0, #0]
  400906:	4770      	bx	lr

00400908 <uart_write>:
  400908:	6943      	ldr	r3, [r0, #20]
  40090a:	079b      	lsls	r3, r3, #30
  40090c:	bf46      	itte	mi
  40090e:	61c1      	strmi	r1, [r0, #28]
  400910:	2000      	movmi	r0, #0
  400912:	2001      	movpl	r0, #1
  400914:	4770      	bx	lr

00400916 <uart_read>:
  400916:	6943      	ldr	r3, [r0, #20]
  400918:	07db      	lsls	r3, r3, #31
  40091a:	bf43      	ittte	mi
  40091c:	6983      	ldrmi	r3, [r0, #24]
  40091e:	700b      	strbmi	r3, [r1, #0]
  400920:	2000      	movmi	r0, #0
  400922:	2001      	movpl	r0, #1
  400924:	4770      	bx	lr

00400926 <pio_set_peripheral>:
  400926:	f1b1 5fc0 	cmp.w	r1, #402653184	; 0x18000000
  40092a:	6442      	str	r2, [r0, #68]	; 0x44
  40092c:	d026      	beq.n	40097c <pio_set_peripheral+0x56>
  40092e:	d807      	bhi.n	400940 <pio_set_peripheral+0x1a>
  400930:	f1b1 6f00 	cmp.w	r1, #134217728	; 0x8000000
  400934:	d011      	beq.n	40095a <pio_set_peripheral+0x34>
  400936:	f1b1 5f80 	cmp.w	r1, #268435456	; 0x10000000
  40093a:	d01c      	beq.n	400976 <pio_set_peripheral+0x50>
  40093c:	b9c9      	cbnz	r1, 400972 <pio_set_peripheral+0x4c>
  40093e:	4770      	bx	lr
  400940:	f1b1 5f00 	cmp.w	r1, #536870912	; 0x20000000
  400944:	d023      	beq.n	40098e <pio_set_peripheral+0x68>
  400946:	d314      	bcc.n	400972 <pio_set_peripheral+0x4c>
  400948:	f1b1 5f40 	cmp.w	r1, #805306368	; 0x30000000
  40094c:	d012      	beq.n	400974 <pio_set_peripheral+0x4e>
  40094e:	f021 5180 	bic.w	r1, r1, #268435456	; 0x10000000
  400952:	f1b1 5f20 	cmp.w	r1, #671088640	; 0x28000000
  400956:	d10c      	bne.n	400972 <pio_set_peripheral+0x4c>
  400958:	4770      	bx	lr
  40095a:	6f01      	ldr	r1, [r0, #112]	; 0x70
  40095c:	6f03      	ldr	r3, [r0, #112]	; 0x70
  40095e:	400b      	ands	r3, r1
  400960:	ea23 0302 	bic.w	r3, r3, r2
  400964:	6703      	str	r3, [r0, #112]	; 0x70
  400966:	6f41      	ldr	r1, [r0, #116]	; 0x74
  400968:	6f43      	ldr	r3, [r0, #116]	; 0x74
  40096a:	400b      	ands	r3, r1
  40096c:	ea23 0302 	bic.w	r3, r3, r2
  400970:	6743      	str	r3, [r0, #116]	; 0x74
  400972:	6042      	str	r2, [r0, #4]
  400974:	4770      	bx	lr
  400976:	6f03      	ldr	r3, [r0, #112]	; 0x70
  400978:	4313      	orrs	r3, r2
  40097a:	e7f3      	b.n	400964 <pio_set_peripheral+0x3e>
  40097c:	6f01      	ldr	r1, [r0, #112]	; 0x70
  40097e:	6f03      	ldr	r3, [r0, #112]	; 0x70
  400980:	400b      	ands	r3, r1
  400982:	ea23 0302 	bic.w	r3, r3, r2
  400986:	6703      	str	r3, [r0, #112]	; 0x70
  400988:	6f43      	ldr	r3, [r0, #116]	; 0x74
  40098a:	4313      	orrs	r3, r2
  40098c:	e7f0      	b.n	400970 <pio_set_peripheral+0x4a>
  40098e:	6f03      	ldr	r3, [r0, #112]	; 0x70
  400990:	4313      	orrs	r3, r2
  400992:	e7f8      	b.n	400986 <pio_set_peripheral+0x60>

00400994 <pio_set_input>:
  400994:	07d3      	lsls	r3, r2, #31
  400996:	6441      	str	r1, [r0, #68]	; 0x44
  400998:	bf4c      	ite	mi
  40099a:	6641      	strmi	r1, [r0, #100]	; 0x64
  40099c:	6601      	strpl	r1, [r0, #96]	; 0x60
  40099e:	f012 0f0a 	tst.w	r2, #10
  4009a2:	d007      	beq.n	4009b4 <pio_set_input+0x20>
  4009a4:	0793      	lsls	r3, r2, #30
  4009a6:	6201      	str	r1, [r0, #32]
  4009a8:	d408      	bmi.n	4009bc <pio_set_input+0x28>
  4009aa:	0713      	lsls	r3, r2, #28
  4009ac:	bf48      	it	mi
  4009ae:	f8c0 1084 	strmi.w	r1, [r0, #132]	; 0x84
  4009b2:	e000      	b.n	4009b6 <pio_set_input+0x22>
  4009b4:	6241      	str	r1, [r0, #36]	; 0x24
  4009b6:	6141      	str	r1, [r0, #20]
  4009b8:	6001      	str	r1, [r0, #0]
  4009ba:	4770      	bx	lr
  4009bc:	f8c0 1080 	str.w	r1, [r0, #128]	; 0x80
  4009c0:	e7f9      	b.n	4009b6 <pio_set_input+0x22>

004009c2 <pio_set_output>:
  4009c2:	b510      	push	{r4, lr}
  4009c4:	9c02      	ldr	r4, [sp, #8]
  4009c6:	6441      	str	r1, [r0, #68]	; 0x44
  4009c8:	b13c      	cbz	r4, 4009da <pio_set_output+0x18>
  4009ca:	6641      	str	r1, [r0, #100]	; 0x64
  4009cc:	b13b      	cbz	r3, 4009de <pio_set_output+0x1c>
  4009ce:	6501      	str	r1, [r0, #80]	; 0x50
  4009d0:	b13a      	cbz	r2, 4009e2 <pio_set_output+0x20>
  4009d2:	6301      	str	r1, [r0, #48]	; 0x30
  4009d4:	6101      	str	r1, [r0, #16]
  4009d6:	6001      	str	r1, [r0, #0]
  4009d8:	bd10      	pop	{r4, pc}
  4009da:	6601      	str	r1, [r0, #96]	; 0x60
  4009dc:	e7f6      	b.n	4009cc <pio_set_output+0xa>
  4009de:	6541      	str	r1, [r0, #84]	; 0x54
  4009e0:	e7f6      	b.n	4009d0 <pio_set_output+0xe>
  4009e2:	6341      	str	r1, [r0, #52]	; 0x34
  4009e4:	e7f6      	b.n	4009d4 <pio_set_output+0x12>

004009e6 <pio_set_pin_high>:
  4009e6:	0943      	lsrs	r3, r0, #5
  4009e8:	f503 1300 	add.w	r3, r3, #2097152	; 0x200000
  4009ec:	f203 7307 	addw	r3, r3, #1799	; 0x707
  4009f0:	025b      	lsls	r3, r3, #9
  4009f2:	f000 001f 	and.w	r0, r0, #31
  4009f6:	2201      	movs	r2, #1
  4009f8:	4082      	lsls	r2, r0
  4009fa:	631a      	str	r2, [r3, #48]	; 0x30
  4009fc:	4770      	bx	lr

004009fe <pio_set_pin_low>:
  4009fe:	0943      	lsrs	r3, r0, #5
  400a00:	f503 1300 	add.w	r3, r3, #2097152	; 0x200000
  400a04:	f203 7307 	addw	r3, r3, #1799	; 0x707
  400a08:	025b      	lsls	r3, r3, #9
  400a0a:	f000 001f 	and.w	r0, r0, #31
  400a0e:	2201      	movs	r2, #1
  400a10:	4082      	lsls	r2, r0
  400a12:	635a      	str	r2, [r3, #52]	; 0x34
  400a14:	4770      	bx	lr
	...

00400a18 <pio_configure_pin>:
  400a18:	b537      	push	{r0, r1, r2, r4, r5, lr}
  400a1a:	4604      	mov	r4, r0
  400a1c:	0940      	lsrs	r0, r0, #5
  400a1e:	460d      	mov	r5, r1
  400a20:	f500 1000 	add.w	r0, r0, #2097152	; 0x200000
  400a24:	f001 41f0 	and.w	r1, r1, #2013265920	; 0x78000000
  400a28:	f200 7007 	addw	r0, r0, #1799	; 0x707
  400a2c:	f1b1 5f00 	cmp.w	r1, #536870912	; 0x20000000
  400a30:	ea4f 2040 	mov.w	r0, r0, lsl #9
  400a34:	d01f      	beq.n	400a76 <pio_configure_pin+0x5e>
  400a36:	d80b      	bhi.n	400a50 <pio_configure_pin+0x38>
  400a38:	f1b1 5f80 	cmp.w	r1, #268435456	; 0x10000000
  400a3c:	d01b      	beq.n	400a76 <pio_configure_pin+0x5e>
  400a3e:	f1b1 5fc0 	cmp.w	r1, #402653184	; 0x18000000
  400a42:	d018      	beq.n	400a76 <pio_configure_pin+0x5e>
  400a44:	f1b1 6f00 	cmp.w	r1, #134217728	; 0x8000000
  400a48:	d015      	beq.n	400a76 <pio_configure_pin+0x5e>
  400a4a:	2000      	movs	r0, #0
  400a4c:	b003      	add	sp, #12
  400a4e:	bd30      	pop	{r4, r5, pc}
  400a50:	f005 43e0 	and.w	r3, r5, #1879048192	; 0x70000000
  400a54:	f1b3 5f40 	cmp.w	r3, #805306368	; 0x30000000
  400a58:	d017      	beq.n	400a8a <pio_configure_pin+0x72>
  400a5a:	f1b1 5f20 	cmp.w	r1, #671088640	; 0x28000000
  400a5e:	d1f4      	bne.n	400a4a <pio_configure_pin+0x32>
  400a60:	f004 041f 	and.w	r4, r4, #31
  400a64:	2101      	movs	r1, #1
  400a66:	4b12      	ldr	r3, [pc, #72]	; (400ab0 <pio_configure_pin+0x98>)
  400a68:	462a      	mov	r2, r5
  400a6a:	40a1      	lsls	r1, r4
  400a6c:	4798      	blx	r3
  400a6e:	e000      	b.n	400a72 <pio_configure_pin+0x5a>
  400a70:	6602      	str	r2, [r0, #96]	; 0x60
  400a72:	2001      	movs	r0, #1
  400a74:	e7ea      	b.n	400a4c <pio_configure_pin+0x34>
  400a76:	f004 041f 	and.w	r4, r4, #31
  400a7a:	2201      	movs	r2, #1
  400a7c:	40a2      	lsls	r2, r4
  400a7e:	4b0d      	ldr	r3, [pc, #52]	; (400ab4 <pio_configure_pin+0x9c>)
  400a80:	4798      	blx	r3
  400a82:	07ec      	lsls	r4, r5, #31
  400a84:	d5f4      	bpl.n	400a70 <pio_configure_pin+0x58>
  400a86:	6642      	str	r2, [r0, #100]	; 0x64
  400a88:	e7f3      	b.n	400a72 <pio_configure_pin+0x5a>
  400a8a:	f005 5260 	and.w	r2, r5, #939524096	; 0x38000000
  400a8e:	f102 4148 	add.w	r1, r2, #3355443200	; 0xc8000000
  400a92:	424a      	negs	r2, r1
  400a94:	f005 0301 	and.w	r3, r5, #1
  400a98:	f004 041f 	and.w	r4, r4, #31
  400a9c:	414a      	adcs	r2, r1
  400a9e:	2101      	movs	r1, #1
  400aa0:	9300      	str	r3, [sp, #0]
  400aa2:	40a1      	lsls	r1, r4
  400aa4:	f3c5 0380 	ubfx	r3, r5, #2, #1
  400aa8:	4c03      	ldr	r4, [pc, #12]	; (400ab8 <pio_configure_pin+0xa0>)
  400aaa:	47a0      	blx	r4
  400aac:	e7e1      	b.n	400a72 <pio_configure_pin+0x5a>
  400aae:	bf00      	nop
  400ab0:	00400995 	.word	0x00400995
  400ab4:	00400927 	.word	0x00400927
  400ab8:	004009c3 	.word	0x004009c3

00400abc <SystemCoreClockUpdate>:
  400abc:	b510      	push	{r4, lr}
  400abe:	4a2c      	ldr	r2, [pc, #176]	; (400b70 <SystemCoreClockUpdate+0xb4>)
  400ac0:	4b2c      	ldr	r3, [pc, #176]	; (400b74 <SystemCoreClockUpdate+0xb8>)
  400ac2:	6b11      	ldr	r1, [r2, #48]	; 0x30
  400ac4:	f001 0103 	and.w	r1, r1, #3
  400ac8:	2901      	cmp	r1, #1
  400aca:	d02a      	beq.n	400b22 <SystemCoreClockUpdate+0x66>
  400acc:	3902      	subs	r1, #2
  400ace:	2901      	cmp	r1, #1
  400ad0:	d81d      	bhi.n	400b0e <SystemCoreClockUpdate+0x52>
  400ad2:	6a11      	ldr	r1, [r2, #32]
  400ad4:	01cc      	lsls	r4, r1, #7
  400ad6:	d448      	bmi.n	400b6a <SystemCoreClockUpdate+0xae>
  400ad8:	4927      	ldr	r1, [pc, #156]	; (400b78 <SystemCoreClockUpdate+0xbc>)
  400ada:	6019      	str	r1, [r3, #0]
  400adc:	6a11      	ldr	r1, [r2, #32]
  400ade:	f001 0170 	and.w	r1, r1, #112	; 0x70
  400ae2:	2910      	cmp	r1, #16
  400ae4:	d03e      	beq.n	400b64 <SystemCoreClockUpdate+0xa8>
  400ae6:	2920      	cmp	r1, #32
  400ae8:	d03f      	beq.n	400b6a <SystemCoreClockUpdate+0xae>
  400aea:	6b10      	ldr	r0, [r2, #48]	; 0x30
  400aec:	6819      	ldr	r1, [r3, #0]
  400aee:	f000 0003 	and.w	r0, r0, #3
  400af2:	2802      	cmp	r0, #2
  400af4:	bf0b      	itete	eq
  400af6:	6a94      	ldreq	r4, [r2, #40]	; 0x28
  400af8:	6ad4      	ldrne	r4, [r2, #44]	; 0x2c
  400afa:	6a90      	ldreq	r0, [r2, #40]	; 0x28
  400afc:	6ad0      	ldrne	r0, [r2, #44]	; 0x2c
  400afe:	f3c4 440a 	ubfx	r4, r4, #16, #11
  400b02:	fb04 1101 	mla	r1, r4, r1, r1
  400b06:	b2c0      	uxtb	r0, r0
  400b08:	fbb1 f1f0 	udiv	r1, r1, r0
  400b0c:	e007      	b.n	400b1e <SystemCoreClockUpdate+0x62>
  400b0e:	491b      	ldr	r1, [pc, #108]	; (400b7c <SystemCoreClockUpdate+0xc0>)
  400b10:	6a49      	ldr	r1, [r1, #36]	; 0x24
  400b12:	0608      	lsls	r0, r1, #24
  400b14:	bf4c      	ite	mi
  400b16:	f44f 4100 	movmi.w	r1, #32768	; 0x8000
  400b1a:	f44f 41fa 	movpl.w	r1, #32000	; 0x7d00
  400b1e:	6019      	str	r1, [r3, #0]
  400b20:	e00d      	b.n	400b3e <SystemCoreClockUpdate+0x82>
  400b22:	6a11      	ldr	r1, [r2, #32]
  400b24:	01c9      	lsls	r1, r1, #7
  400b26:	d501      	bpl.n	400b2c <SystemCoreClockUpdate+0x70>
  400b28:	4915      	ldr	r1, [pc, #84]	; (400b80 <SystemCoreClockUpdate+0xc4>)
  400b2a:	e7f8      	b.n	400b1e <SystemCoreClockUpdate+0x62>
  400b2c:	4912      	ldr	r1, [pc, #72]	; (400b78 <SystemCoreClockUpdate+0xbc>)
  400b2e:	6019      	str	r1, [r3, #0]
  400b30:	6a11      	ldr	r1, [r2, #32]
  400b32:	f001 0170 	and.w	r1, r1, #112	; 0x70
  400b36:	2910      	cmp	r1, #16
  400b38:	d012      	beq.n	400b60 <SystemCoreClockUpdate+0xa4>
  400b3a:	2920      	cmp	r1, #32
  400b3c:	d0f4      	beq.n	400b28 <SystemCoreClockUpdate+0x6c>
  400b3e:	6b10      	ldr	r0, [r2, #48]	; 0x30
  400b40:	6819      	ldr	r1, [r3, #0]
  400b42:	f000 0070 	and.w	r0, r0, #112	; 0x70
  400b46:	2870      	cmp	r0, #112	; 0x70
  400b48:	bf1b      	ittet	ne
  400b4a:	6b12      	ldrne	r2, [r2, #48]	; 0x30
  400b4c:	f3c2 1202 	ubfxne	r2, r2, #4, #3
  400b50:	2203      	moveq	r2, #3
  400b52:	fa21 f202 	lsrne.w	r2, r1, r2
  400b56:	bf08      	it	eq
  400b58:	fbb1 f2f2 	udiveq	r2, r1, r2
  400b5c:	601a      	str	r2, [r3, #0]
  400b5e:	bd10      	pop	{r4, pc}
  400b60:	4908      	ldr	r1, [pc, #32]	; (400b84 <SystemCoreClockUpdate+0xc8>)
  400b62:	e7dc      	b.n	400b1e <SystemCoreClockUpdate+0x62>
  400b64:	4907      	ldr	r1, [pc, #28]	; (400b84 <SystemCoreClockUpdate+0xc8>)
  400b66:	6019      	str	r1, [r3, #0]
  400b68:	e7bf      	b.n	400aea <SystemCoreClockUpdate+0x2e>
  400b6a:	4905      	ldr	r1, [pc, #20]	; (400b80 <SystemCoreClockUpdate+0xc4>)
  400b6c:	e7fb      	b.n	400b66 <SystemCoreClockUpdate+0xaa>
  400b6e:	bf00      	nop
  400b70:	400e0400 	.word	0x400e0400
  400b74:	20000004 	.word	0x20000004
  400b78:	003d0900 	.word	0x003d0900
  400b7c:	400e1400 	.word	0x400e1400
  400b80:	00b71b00 	.word	0x00b71b00
  400b84:	007a1200 	.word	0x007a1200

00400b88 <system_init_flash>:
  400b88:	4b0e      	ldr	r3, [pc, #56]	; (400bc4 <system_init_flash+0x3c>)
  400b8a:	4298      	cmp	r0, r3
  400b8c:	4b0e      	ldr	r3, [pc, #56]	; (400bc8 <system_init_flash+0x40>)
  400b8e:	d803      	bhi.n	400b98 <system_init_flash+0x10>
  400b90:	f04f 6280 	mov.w	r2, #67108864	; 0x4000000
  400b94:	601a      	str	r2, [r3, #0]
  400b96:	4770      	bx	lr
  400b98:	4a0c      	ldr	r2, [pc, #48]	; (400bcc <system_init_flash+0x44>)
  400b9a:	4290      	cmp	r0, r2
  400b9c:	d201      	bcs.n	400ba2 <system_init_flash+0x1a>
  400b9e:	4a0c      	ldr	r2, [pc, #48]	; (400bd0 <system_init_flash+0x48>)
  400ba0:	e7f8      	b.n	400b94 <system_init_flash+0xc>
  400ba2:	4a0c      	ldr	r2, [pc, #48]	; (400bd4 <system_init_flash+0x4c>)
  400ba4:	4290      	cmp	r0, r2
  400ba6:	d201      	bcs.n	400bac <system_init_flash+0x24>
  400ba8:	4a0b      	ldr	r2, [pc, #44]	; (400bd8 <system_init_flash+0x50>)
  400baa:	e7f3      	b.n	400b94 <system_init_flash+0xc>
  400bac:	4a0b      	ldr	r2, [pc, #44]	; (400bdc <system_init_flash+0x54>)
  400bae:	4290      	cmp	r0, r2
  400bb0:	d801      	bhi.n	400bb6 <system_init_flash+0x2e>
  400bb2:	4a0b      	ldr	r2, [pc, #44]	; (400be0 <system_init_flash+0x58>)
  400bb4:	e7ee      	b.n	400b94 <system_init_flash+0xc>
  400bb6:	4a0b      	ldr	r2, [pc, #44]	; (400be4 <system_init_flash+0x5c>)
  400bb8:	4290      	cmp	r0, r2
  400bba:	bf8c      	ite	hi
  400bbc:	4a0a      	ldrhi	r2, [pc, #40]	; (400be8 <system_init_flash+0x60>)
  400bbe:	f04f 2204 	movls.w	r2, #67109888	; 0x4000400
  400bc2:	e7e7      	b.n	400b94 <system_init_flash+0xc>
  400bc4:	01312cff 	.word	0x01312cff
  400bc8:	400e0a00 	.word	0x400e0a00
  400bcc:	02625a00 	.word	0x02625a00
  400bd0:	04000100 	.word	0x04000100
  400bd4:	03938700 	.word	0x03938700
  400bd8:	04000200 	.word	0x04000200
  400bdc:	04c4b3ff 	.word	0x04c4b3ff
  400be0:	04000300 	.word	0x04000300
  400be4:	05f5e0ff 	.word	0x05f5e0ff
  400be8:	04000500 	.word	0x04000500

00400bec <pmc_switch_mck_to_sclk>:
  400bec:	4b0e      	ldr	r3, [pc, #56]	; (400c28 <pmc_switch_mck_to_sclk+0x3c>)
  400bee:	6b1a      	ldr	r2, [r3, #48]	; 0x30
  400bf0:	f022 0203 	bic.w	r2, r2, #3
  400bf4:	631a      	str	r2, [r3, #48]	; 0x30
  400bf6:	f640 0201 	movw	r2, #2049	; 0x801
  400bfa:	6e99      	ldr	r1, [r3, #104]	; 0x68
  400bfc:	0709      	lsls	r1, r1, #28
  400bfe:	d50b      	bpl.n	400c18 <pmc_switch_mck_to_sclk+0x2c>
  400c00:	6b1a      	ldr	r2, [r3, #48]	; 0x30
  400c02:	f022 0270 	bic.w	r2, r2, #112	; 0x70
  400c06:	4310      	orrs	r0, r2
  400c08:	6318      	str	r0, [r3, #48]	; 0x30
  400c0a:	f640 0201 	movw	r2, #2049	; 0x801
  400c0e:	6e99      	ldr	r1, [r3, #104]	; 0x68
  400c10:	0709      	lsls	r1, r1, #28
  400c12:	d505      	bpl.n	400c20 <pmc_switch_mck_to_sclk+0x34>
  400c14:	2000      	movs	r0, #0
  400c16:	4770      	bx	lr
  400c18:	3a01      	subs	r2, #1
  400c1a:	d1ee      	bne.n	400bfa <pmc_switch_mck_to_sclk+0xe>
  400c1c:	2001      	movs	r0, #1
  400c1e:	4770      	bx	lr
  400c20:	3a01      	subs	r2, #1
  400c22:	d1f4      	bne.n	400c0e <pmc_switch_mck_to_sclk+0x22>
  400c24:	e7fa      	b.n	400c1c <pmc_switch_mck_to_sclk+0x30>
  400c26:	bf00      	nop
  400c28:	400e0400 	.word	0x400e0400

00400c2c <pmc_switch_mck_to_mainck>:
  400c2c:	4b0f      	ldr	r3, [pc, #60]	; (400c6c <pmc_switch_mck_to_mainck+0x40>)
  400c2e:	6b1a      	ldr	r2, [r3, #48]	; 0x30
  400c30:	f022 0203 	bic.w	r2, r2, #3
  400c34:	f042 0201 	orr.w	r2, r2, #1
  400c38:	631a      	str	r2, [r3, #48]	; 0x30
  400c3a:	f640 0201 	movw	r2, #2049	; 0x801
  400c3e:	6e99      	ldr	r1, [r3, #104]	; 0x68
  400c40:	0709      	lsls	r1, r1, #28
  400c42:	d50b      	bpl.n	400c5c <pmc_switch_mck_to_mainck+0x30>
  400c44:	6b1a      	ldr	r2, [r3, #48]	; 0x30
  400c46:	f022 0270 	bic.w	r2, r2, #112	; 0x70
  400c4a:	4310      	orrs	r0, r2
  400c4c:	6318      	str	r0, [r3, #48]	; 0x30
  400c4e:	f640 0201 	movw	r2, #2049	; 0x801
  400c52:	6e99      	ldr	r1, [r3, #104]	; 0x68
  400c54:	0709      	lsls	r1, r1, #28
  400c56:	d505      	bpl.n	400c64 <pmc_switch_mck_to_mainck+0x38>
  400c58:	2000      	movs	r0, #0
  400c5a:	4770      	bx	lr
  400c5c:	3a01      	subs	r2, #1
  400c5e:	d1ee      	bne.n	400c3e <pmc_switch_mck_to_mainck+0x12>
  400c60:	2001      	movs	r0, #1
  400c62:	4770      	bx	lr
  400c64:	3a01      	subs	r2, #1
  400c66:	d1f4      	bne.n	400c52 <pmc_switch_mck_to_mainck+0x26>
  400c68:	e7fa      	b.n	400c60 <pmc_switch_mck_to_mainck+0x34>
  400c6a:	bf00      	nop
  400c6c:	400e0400 	.word	0x400e0400

00400c70 <pmc_switch_mainck_to_xtal>:
  400c70:	4a0f      	ldr	r2, [pc, #60]	; (400cb0 <pmc_switch_mainck_to_xtal+0x40>)
  400c72:	b130      	cbz	r0, 400c82 <pmc_switch_mainck_to_xtal+0x12>
  400c74:	6a13      	ldr	r3, [r2, #32]
  400c76:	490f      	ldr	r1, [pc, #60]	; (400cb4 <pmc_switch_mainck_to_xtal+0x44>)
  400c78:	4019      	ands	r1, r3
  400c7a:	4b0f      	ldr	r3, [pc, #60]	; (400cb8 <pmc_switch_mainck_to_xtal+0x48>)
  400c7c:	430b      	orrs	r3, r1
  400c7e:	6213      	str	r3, [r2, #32]
  400c80:	4770      	bx	lr
  400c82:	6a10      	ldr	r0, [r2, #32]
  400c84:	020b      	lsls	r3, r1, #8
  400c86:	f420 115c 	bic.w	r1, r0, #3604480	; 0x370000
  400c8a:	b29b      	uxth	r3, r3
  400c8c:	f021 0103 	bic.w	r1, r1, #3
  400c90:	430b      	orrs	r3, r1
  400c92:	f443 135c 	orr.w	r3, r3, #3604480	; 0x370000
  400c96:	f043 0301 	orr.w	r3, r3, #1
  400c9a:	6213      	str	r3, [r2, #32]
  400c9c:	6e93      	ldr	r3, [r2, #104]	; 0x68
  400c9e:	07db      	lsls	r3, r3, #31
  400ca0:	d5fc      	bpl.n	400c9c <pmc_switch_mainck_to_xtal+0x2c>
  400ca2:	6a13      	ldr	r3, [r2, #32]
  400ca4:	f043 739b 	orr.w	r3, r3, #20316160	; 0x1360000
  400ca8:	f443 3380 	orr.w	r3, r3, #65536	; 0x10000
  400cac:	e7e7      	b.n	400c7e <pmc_switch_mainck_to_xtal+0xe>
  400cae:	bf00      	nop
  400cb0:	400e0400 	.word	0x400e0400
  400cb4:	fec8fffc 	.word	0xfec8fffc
  400cb8:	01370002 	.word	0x01370002

00400cbc <pmc_osc_is_ready_mainck>:
  400cbc:	4b02      	ldr	r3, [pc, #8]	; (400cc8 <pmc_osc_is_ready_mainck+0xc>)
  400cbe:	6e98      	ldr	r0, [r3, #104]	; 0x68
  400cc0:	f400 3080 	and.w	r0, r0, #65536	; 0x10000
  400cc4:	4770      	bx	lr
  400cc6:	bf00      	nop
  400cc8:	400e0400 	.word	0x400e0400

00400ccc <pmc_enable_periph_clk>:
  400ccc:	2822      	cmp	r0, #34	; 0x22
  400cce:	d816      	bhi.n	400cfe <pmc_enable_periph_clk+0x32>
  400cd0:	281f      	cmp	r0, #31
  400cd2:	4a0c      	ldr	r2, [pc, #48]	; (400d04 <pmc_enable_periph_clk+0x38>)
  400cd4:	f04f 0301 	mov.w	r3, #1
  400cd8:	d807      	bhi.n	400cea <pmc_enable_periph_clk+0x1e>
  400cda:	6991      	ldr	r1, [r2, #24]
  400cdc:	4083      	lsls	r3, r0
  400cde:	ea33 0101 	bics.w	r1, r3, r1
  400ce2:	bf18      	it	ne
  400ce4:	6113      	strne	r3, [r2, #16]
  400ce6:	2000      	movs	r0, #0
  400ce8:	4770      	bx	lr
  400cea:	f8d2 1108 	ldr.w	r1, [r2, #264]	; 0x108
  400cee:	3820      	subs	r0, #32
  400cf0:	4083      	lsls	r3, r0
  400cf2:	ea33 0101 	bics.w	r1, r3, r1
  400cf6:	d0f6      	beq.n	400ce6 <pmc_enable_periph_clk+0x1a>
  400cf8:	f8c2 3100 	str.w	r3, [r2, #256]	; 0x100
  400cfc:	e7f3      	b.n	400ce6 <pmc_enable_periph_clk+0x1a>
  400cfe:	2001      	movs	r0, #1
  400d00:	4770      	bx	lr
  400d02:	bf00      	nop
  400d04:	400e0400 	.word	0x400e0400

00400d08 <pmc_set_writeprotect>:
  400d08:	4b03      	ldr	r3, [pc, #12]	; (400d18 <pmc_set_writeprotect+0x10>)
  400d0a:	b118      	cbz	r0, 400d14 <pmc_set_writeprotect+0xc>
  400d0c:	4a03      	ldr	r2, [pc, #12]	; (400d1c <pmc_set_writeprotect+0x14>)
  400d0e:	f8c3 20e4 	str.w	r2, [r3, #228]	; 0xe4
  400d12:	4770      	bx	lr
  400d14:	4a02      	ldr	r2, [pc, #8]	; (400d20 <pmc_set_writeprotect+0x18>)
  400d16:	e7fa      	b.n	400d0e <pmc_set_writeprotect+0x6>
  400d18:	400e0400 	.word	0x400e0400
  400d1c:	504d4301 	.word	0x504d4301
  400d20:	504d4300 	.word	0x504d4300

00400d24 <KeyExpansion>:
  400d24:	b573      	push	{r0, r1, r4, r5, r6, lr}
  400d26:	4b27      	ldr	r3, [pc, #156]	; (400dc4 <KeyExpansion+0xa0>)
  400d28:	4a27      	ldr	r2, [pc, #156]	; (400dc8 <KeyExpansion+0xa4>)
  400d2a:	681b      	ldr	r3, [r3, #0]
  400d2c:	f103 0110 	add.w	r1, r3, #16
  400d30:	7818      	ldrb	r0, [r3, #0]
  400d32:	7010      	strb	r0, [r2, #0]
  400d34:	7858      	ldrb	r0, [r3, #1]
  400d36:	7050      	strb	r0, [r2, #1]
  400d38:	7898      	ldrb	r0, [r3, #2]
  400d3a:	7090      	strb	r0, [r2, #2]
  400d3c:	78d8      	ldrb	r0, [r3, #3]
  400d3e:	70d0      	strb	r0, [r2, #3]
  400d40:	3304      	adds	r3, #4
  400d42:	428b      	cmp	r3, r1
  400d44:	f102 0204 	add.w	r2, r2, #4
  400d48:	d1f2      	bne.n	400d30 <KeyExpansion+0xc>
  400d4a:	4b20      	ldr	r3, [pc, #128]	; (400dcc <KeyExpansion+0xa8>)
  400d4c:	4820      	ldr	r0, [pc, #128]	; (400dd0 <KeyExpansion+0xac>)
  400d4e:	4c21      	ldr	r4, [pc, #132]	; (400dd4 <KeyExpansion+0xb0>)
  400d50:	2104      	movs	r1, #4
  400d52:	681a      	ldr	r2, [r3, #0]
  400d54:	9201      	str	r2, [sp, #4]
  400d56:	078d      	lsls	r5, r1, #30
  400d58:	d114      	bne.n	400d84 <KeyExpansion+0x60>
  400d5a:	f3c2 4607 	ubfx	r6, r2, #16, #8
  400d5e:	f3c2 2507 	ubfx	r5, r2, #8, #8
  400d62:	5d86      	ldrb	r6, [r0, r6]
  400d64:	f88d 6005 	strb.w	r6, [sp, #5]
  400d68:	0e16      	lsrs	r6, r2, #24
  400d6a:	b2d2      	uxtb	r2, r2
  400d6c:	5d45      	ldrb	r5, [r0, r5]
  400d6e:	5c82      	ldrb	r2, [r0, r2]
  400d70:	f88d 2007 	strb.w	r2, [sp, #7]
  400d74:	088a      	lsrs	r2, r1, #2
  400d76:	5d86      	ldrb	r6, [r0, r6]
  400d78:	5ca2      	ldrb	r2, [r4, r2]
  400d7a:	f88d 6006 	strb.w	r6, [sp, #6]
  400d7e:	406a      	eors	r2, r5
  400d80:	f88d 2004 	strb.w	r2, [sp, #4]
  400d84:	f813 2c0c 	ldrb.w	r2, [r3, #-12]
  400d88:	f89d 5004 	ldrb.w	r5, [sp, #4]
  400d8c:	406a      	eors	r2, r5
  400d8e:	711a      	strb	r2, [r3, #4]
  400d90:	f89d 5005 	ldrb.w	r5, [sp, #5]
  400d94:	f813 2c0b 	ldrb.w	r2, [r3, #-11]
  400d98:	406a      	eors	r2, r5
  400d9a:	715a      	strb	r2, [r3, #5]
  400d9c:	f89d 5006 	ldrb.w	r5, [sp, #6]
  400da0:	f813 2c0a 	ldrb.w	r2, [r3, #-10]
  400da4:	406a      	eors	r2, r5
  400da6:	719a      	strb	r2, [r3, #6]
  400da8:	f89d 5007 	ldrb.w	r5, [sp, #7]
  400dac:	f813 2c09 	ldrb.w	r2, [r3, #-9]
  400db0:	3101      	adds	r1, #1
  400db2:	406a      	eors	r2, r5
  400db4:	292c      	cmp	r1, #44	; 0x2c
  400db6:	71da      	strb	r2, [r3, #7]
  400db8:	f103 0304 	add.w	r3, r3, #4
  400dbc:	d1c9      	bne.n	400d52 <KeyExpansion+0x2e>
  400dbe:	b002      	add	sp, #8
  400dc0:	bd70      	pop	{r4, r5, r6, pc}
  400dc2:	bf00      	nop
  400dc4:	20000334 	.word	0x20000334
  400dc8:	20000348 	.word	0x20000348
  400dcc:	20000354 	.word	0x20000354
  400dd0:	20000013 	.word	0x20000013
  400dd4:	20000008 	.word	0x20000008

00400dd8 <AddRoundKey>:
  400dd8:	b5f0      	push	{r4, r5, r6, r7, lr}
  400dda:	4b0a      	ldr	r3, [pc, #40]	; (400e04 <AddRoundKey+0x2c>)
  400ddc:	4d0a      	ldr	r5, [pc, #40]	; (400e08 <AddRoundKey+0x30>)
  400dde:	681b      	ldr	r3, [r3, #0]
  400de0:	0100      	lsls	r0, r0, #4
  400de2:	f103 0610 	add.w	r6, r3, #16
  400de6:	1941      	adds	r1, r0, r5
  400de8:	1d1c      	adds	r4, r3, #4
  400dea:	781a      	ldrb	r2, [r3, #0]
  400dec:	f811 7b01 	ldrb.w	r7, [r1], #1
  400df0:	407a      	eors	r2, r7
  400df2:	f803 2b01 	strb.w	r2, [r3], #1
  400df6:	42a3      	cmp	r3, r4
  400df8:	d1f7      	bne.n	400dea <AddRoundKey+0x12>
  400dfa:	429e      	cmp	r6, r3
  400dfc:	f100 0004 	add.w	r0, r0, #4
  400e00:	d1f1      	bne.n	400de6 <AddRoundKey+0xe>
  400e02:	bdf0      	pop	{r4, r5, r6, r7, pc}
  400e04:	200003f8 	.word	0x200003f8
  400e08:	20000348 	.word	0x20000348

00400e0c <SubBytes>:
  400e0c:	b510      	push	{r4, lr}
  400e0e:	4b08      	ldr	r3, [pc, #32]	; (400e30 <SubBytes+0x24>)
  400e10:	4808      	ldr	r0, [pc, #32]	; (400e34 <SubBytes+0x28>)
  400e12:	681b      	ldr	r3, [r3, #0]
  400e14:	1d19      	adds	r1, r3, #4
  400e16:	2200      	movs	r2, #0
  400e18:	f813 4022 	ldrb.w	r4, [r3, r2, lsl #2]
  400e1c:	5d04      	ldrb	r4, [r0, r4]
  400e1e:	f803 4022 	strb.w	r4, [r3, r2, lsl #2]
  400e22:	3201      	adds	r2, #1
  400e24:	2a04      	cmp	r2, #4
  400e26:	d1f7      	bne.n	400e18 <SubBytes+0xc>
  400e28:	3301      	adds	r3, #1
  400e2a:	428b      	cmp	r3, r1
  400e2c:	d1f3      	bne.n	400e16 <SubBytes+0xa>
  400e2e:	bd10      	pop	{r4, pc}
  400e30:	200003f8 	.word	0x200003f8
  400e34:	20000013 	.word	0x20000013

00400e38 <ShiftRows>:
  400e38:	4b0d      	ldr	r3, [pc, #52]	; (400e70 <ShiftRows+0x38>)
  400e3a:	681b      	ldr	r3, [r3, #0]
  400e3c:	7959      	ldrb	r1, [r3, #5]
  400e3e:	785a      	ldrb	r2, [r3, #1]
  400e40:	7059      	strb	r1, [r3, #1]
  400e42:	7a59      	ldrb	r1, [r3, #9]
  400e44:	7159      	strb	r1, [r3, #5]
  400e46:	7b59      	ldrb	r1, [r3, #13]
  400e48:	7259      	strb	r1, [r3, #9]
  400e4a:	7a99      	ldrb	r1, [r3, #10]
  400e4c:	735a      	strb	r2, [r3, #13]
  400e4e:	789a      	ldrb	r2, [r3, #2]
  400e50:	7099      	strb	r1, [r3, #2]
  400e52:	7b99      	ldrb	r1, [r3, #14]
  400e54:	729a      	strb	r2, [r3, #10]
  400e56:	799a      	ldrb	r2, [r3, #6]
  400e58:	7199      	strb	r1, [r3, #6]
  400e5a:	7bd9      	ldrb	r1, [r3, #15]
  400e5c:	739a      	strb	r2, [r3, #14]
  400e5e:	78da      	ldrb	r2, [r3, #3]
  400e60:	70d9      	strb	r1, [r3, #3]
  400e62:	7ad9      	ldrb	r1, [r3, #11]
  400e64:	73d9      	strb	r1, [r3, #15]
  400e66:	79d9      	ldrb	r1, [r3, #7]
  400e68:	72d9      	strb	r1, [r3, #11]
  400e6a:	71da      	strb	r2, [r3, #7]
  400e6c:	4770      	bx	lr
  400e6e:	bf00      	nop
  400e70:	200003f8 	.word	0x200003f8

00400e74 <xtime>:
  400e74:	09c3      	lsrs	r3, r0, #7
  400e76:	eb03 0343 	add.w	r3, r3, r3, lsl #1
  400e7a:	eb03 03c3 	add.w	r3, r3, r3, lsl #3
  400e7e:	ea83 0040 	eor.w	r0, r3, r0, lsl #1
  400e82:	b2c0      	uxtb	r0, r0
  400e84:	4770      	bx	lr
	...

00400e88 <Cipher>:
  400e88:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
  400e8c:	b085      	sub	sp, #20
  400e8e:	4d24      	ldr	r5, [pc, #144]	; (400f20 <Cipher+0x98>)
  400e90:	f8df 9090 	ldr.w	r9, [pc, #144]	; 400f24 <Cipher+0x9c>
  400e94:	f8df 8090 	ldr.w	r8, [pc, #144]	; 400f28 <Cipher+0xa0>
  400e98:	2000      	movs	r0, #0
  400e9a:	47a8      	blx	r5
  400e9c:	2401      	movs	r4, #1
  400e9e:	9501      	str	r5, [sp, #4]
  400ea0:	47c8      	blx	r9
  400ea2:	47c0      	blx	r8
  400ea4:	4b21      	ldr	r3, [pc, #132]	; (400f2c <Cipher+0xa4>)
  400ea6:	f8df a088 	ldr.w	sl, [pc, #136]	; 400f30 <Cipher+0xa8>
  400eaa:	681a      	ldr	r2, [r3, #0]
  400eac:	f102 0310 	add.w	r3, r2, #16
  400eb0:	9302      	str	r3, [sp, #8]
  400eb2:	f892 b000 	ldrb.w	fp, [r2]
  400eb6:	7855      	ldrb	r5, [r2, #1]
  400eb8:	7891      	ldrb	r1, [r2, #2]
  400eba:	78d7      	ldrb	r7, [r2, #3]
  400ebc:	ea8b 0005 	eor.w	r0, fp, r5
  400ec0:	ea81 0307 	eor.w	r3, r1, r7
  400ec4:	ea80 0603 	eor.w	r6, r0, r3
  400ec8:	9303      	str	r3, [sp, #12]
  400eca:	47d0      	blx	sl
  400ecc:	ea8b 0000 	eor.w	r0, fp, r0
  400ed0:	4070      	eors	r0, r6
  400ed2:	7010      	strb	r0, [r2, #0]
  400ed4:	ea85 0001 	eor.w	r0, r5, r1
  400ed8:	47d0      	blx	sl
  400eda:	9b03      	ldr	r3, [sp, #12]
  400edc:	4045      	eors	r5, r0
  400ede:	4075      	eors	r5, r6
  400ee0:	7055      	strb	r5, [r2, #1]
  400ee2:	4618      	mov	r0, r3
  400ee4:	47d0      	blx	sl
  400ee6:	4041      	eors	r1, r0
  400ee8:	4071      	eors	r1, r6
  400eea:	7091      	strb	r1, [r2, #2]
  400eec:	ea8b 0007 	eor.w	r0, fp, r7
  400ef0:	47d0      	blx	sl
  400ef2:	4047      	eors	r7, r0
  400ef4:	9b02      	ldr	r3, [sp, #8]
  400ef6:	407e      	eors	r6, r7
  400ef8:	70d6      	strb	r6, [r2, #3]
  400efa:	3204      	adds	r2, #4
  400efc:	4293      	cmp	r3, r2
  400efe:	d1d8      	bne.n	400eb2 <Cipher+0x2a>
  400f00:	4620      	mov	r0, r4
  400f02:	3401      	adds	r4, #1
  400f04:	9b01      	ldr	r3, [sp, #4]
  400f06:	b2e4      	uxtb	r4, r4
  400f08:	4798      	blx	r3
  400f0a:	2c0a      	cmp	r4, #10
  400f0c:	d1c8      	bne.n	400ea0 <Cipher+0x18>
  400f0e:	4b05      	ldr	r3, [pc, #20]	; (400f24 <Cipher+0x9c>)
  400f10:	4798      	blx	r3
  400f12:	47c0      	blx	r8
  400f14:	9b01      	ldr	r3, [sp, #4]
  400f16:	4620      	mov	r0, r4
  400f18:	b005      	add	sp, #20
  400f1a:	e8bd 4ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
  400f1e:	4718      	bx	r3
  400f20:	00400dd9 	.word	0x00400dd9
  400f24:	00400e0d 	.word	0x00400e0d
  400f28:	00400e39 	.word	0x00400e39
  400f2c:	200003f8 	.word	0x200003f8
  400f30:	00400e75 	.word	0x00400e75

00400f34 <BlockCopy>:
  400f34:	1e4b      	subs	r3, r1, #1
  400f36:	3801      	subs	r0, #1
  400f38:	310f      	adds	r1, #15
  400f3a:	f813 2f01 	ldrb.w	r2, [r3, #1]!
  400f3e:	f800 2f01 	strb.w	r2, [r0, #1]!
  400f42:	428b      	cmp	r3, r1
  400f44:	d1f9      	bne.n	400f3a <BlockCopy+0x6>
  400f46:	4770      	bx	lr

00400f48 <AES128_ECB_indp_setkey>:
  400f48:	4b01      	ldr	r3, [pc, #4]	; (400f50 <AES128_ECB_indp_setkey+0x8>)
  400f4a:	6018      	str	r0, [r3, #0]
  400f4c:	4b01      	ldr	r3, [pc, #4]	; (400f54 <AES128_ECB_indp_setkey+0xc>)
  400f4e:	4718      	bx	r3
  400f50:	20000334 	.word	0x20000334
  400f54:	00400d25 	.word	0x00400d25

00400f58 <AES128_ECB_indp_crypto>:
  400f58:	b510      	push	{r4, lr}
  400f5a:	4b05      	ldr	r3, [pc, #20]	; (400f70 <AES128_ECB_indp_crypto+0x18>)
  400f5c:	4601      	mov	r1, r0
  400f5e:	6018      	str	r0, [r3, #0]
  400f60:	4b04      	ldr	r3, [pc, #16]	; (400f74 <AES128_ECB_indp_crypto+0x1c>)
  400f62:	4805      	ldr	r0, [pc, #20]	; (400f78 <AES128_ECB_indp_crypto+0x20>)
  400f64:	4798      	blx	r3
  400f66:	e8bd 4010 	ldmia.w	sp!, {r4, lr}
  400f6a:	4b04      	ldr	r3, [pc, #16]	; (400f7c <AES128_ECB_indp_crypto+0x24>)
  400f6c:	4718      	bx	r3
  400f6e:	bf00      	nop
  400f70:	200003f8 	.word	0x200003f8
  400f74:	00400f35 	.word	0x00400f35
  400f78:	20000338 	.word	0x20000338
  400f7c:	00400e89 	.word	0x00400e89

00400f80 <aes_indep_init>:
  400f80:	4770      	bx	lr
	...

00400f84 <aes_indep_key>:
  400f84:	4b00      	ldr	r3, [pc, #0]	; (400f88 <aes_indep_key+0x4>)
  400f86:	4718      	bx	r3
  400f88:	00400f49 	.word	0x00400f49

00400f8c <aes_indep_enc>:
  400f8c:	4b00      	ldr	r3, [pc, #0]	; (400f90 <aes_indep_enc+0x4>)
  400f8e:	4718      	bx	r3
  400f90:	00400f59 	.word	0x00400f59

00400f94 <aes_indep_enc_pretrigger>:
  400f94:	4770      	bx	lr

00400f96 <aes_indep_enc_posttrigger>:
  400f96:	4770      	bx	lr

00400f98 <aes_indep_mask>:
  400f98:	4770      	bx	lr
	...

00400f9c <__libc_init_array>:
  400f9c:	b570      	push	{r4, r5, r6, lr}
  400f9e:	4b0f      	ldr	r3, [pc, #60]	; (400fdc <__libc_init_array+0x40>)
  400fa0:	4d0f      	ldr	r5, [pc, #60]	; (400fe0 <__libc_init_array+0x44>)
  400fa2:	42ab      	cmp	r3, r5
  400fa4:	eba3 0605 	sub.w	r6, r3, r5
  400fa8:	d007      	beq.n	400fba <__libc_init_array+0x1e>
  400faa:	10b6      	asrs	r6, r6, #2
  400fac:	2400      	movs	r4, #0
  400fae:	f855 3b04 	ldr.w	r3, [r5], #4
  400fb2:	3401      	adds	r4, #1
  400fb4:	4798      	blx	r3
  400fb6:	42a6      	cmp	r6, r4
  400fb8:	d8f9      	bhi.n	400fae <__libc_init_array+0x12>
  400fba:	f000 f915 	bl	4011e8 <_init>
  400fbe:	4d09      	ldr	r5, [pc, #36]	; (400fe4 <__libc_init_array+0x48>)
  400fc0:	4b09      	ldr	r3, [pc, #36]	; (400fe8 <__libc_init_array+0x4c>)
  400fc2:	1b5e      	subs	r6, r3, r5
  400fc4:	42ab      	cmp	r3, r5
  400fc6:	ea4f 06a6 	mov.w	r6, r6, asr #2
  400fca:	d006      	beq.n	400fda <__libc_init_array+0x3e>
  400fcc:	2400      	movs	r4, #0
  400fce:	f855 3b04 	ldr.w	r3, [r5], #4
  400fd2:	3401      	adds	r4, #1
  400fd4:	4798      	blx	r3
  400fd6:	42a6      	cmp	r6, r4
  400fd8:	d8f9      	bhi.n	400fce <__libc_init_array+0x32>
  400fda:	bd70      	pop	{r4, r5, r6, pc}
  400fdc:	004011f4 	.word	0x004011f4
  400fe0:	004011f4 	.word	0x004011f4
  400fe4:	004011f4 	.word	0x004011f4
  400fe8:	004011f8 	.word	0x004011f8

00400fec <memset>:
  400fec:	0783      	lsls	r3, r0, #30
  400fee:	b530      	push	{r4, r5, lr}
  400ff0:	d047      	beq.n	401082 <memset+0x96>
  400ff2:	1e54      	subs	r4, r2, #1
  400ff4:	2a00      	cmp	r2, #0
  400ff6:	d03e      	beq.n	401076 <memset+0x8a>
  400ff8:	b2ca      	uxtb	r2, r1
  400ffa:	4603      	mov	r3, r0
  400ffc:	e001      	b.n	401002 <memset+0x16>
  400ffe:	3c01      	subs	r4, #1
  401000:	d339      	bcc.n	401076 <memset+0x8a>
  401002:	f803 2b01 	strb.w	r2, [r3], #1
  401006:	079d      	lsls	r5, r3, #30
  401008:	d1f9      	bne.n	400ffe <memset+0x12>
  40100a:	2c03      	cmp	r4, #3
  40100c:	d92c      	bls.n	401068 <memset+0x7c>
  40100e:	b2cd      	uxtb	r5, r1
  401010:	eb05 2505 	add.w	r5, r5, r5, lsl #8
  401014:	2c0f      	cmp	r4, #15
  401016:	eb05 4505 	add.w	r5, r5, r5, lsl #16
  40101a:	d935      	bls.n	401088 <memset+0x9c>
  40101c:	f1a4 0210 	sub.w	r2, r4, #16
  401020:	f022 0c0f 	bic.w	ip, r2, #15
  401024:	f103 0e10 	add.w	lr, r3, #16
  401028:	44e6      	add	lr, ip
  40102a:	ea4f 1c12 	mov.w	ip, r2, lsr #4
  40102e:	461a      	mov	r2, r3
  401030:	e9c2 5500 	strd	r5, r5, [r2]
  401034:	e9c2 5502 	strd	r5, r5, [r2, #8]
  401038:	3210      	adds	r2, #16
  40103a:	4572      	cmp	r2, lr
  40103c:	d1f8      	bne.n	401030 <memset+0x44>
  40103e:	f10c 0201 	add.w	r2, ip, #1
  401042:	f014 0f0c 	tst.w	r4, #12
  401046:	eb03 1202 	add.w	r2, r3, r2, lsl #4
  40104a:	f004 0c0f 	and.w	ip, r4, #15
  40104e:	d013      	beq.n	401078 <memset+0x8c>
  401050:	f1ac 0304 	sub.w	r3, ip, #4
  401054:	f023 0303 	bic.w	r3, r3, #3
  401058:	3304      	adds	r3, #4
  40105a:	4413      	add	r3, r2
  40105c:	f842 5b04 	str.w	r5, [r2], #4
  401060:	4293      	cmp	r3, r2
  401062:	d1fb      	bne.n	40105c <memset+0x70>
  401064:	f00c 0403 	and.w	r4, ip, #3
  401068:	b12c      	cbz	r4, 401076 <memset+0x8a>
  40106a:	b2c9      	uxtb	r1, r1
  40106c:	441c      	add	r4, r3
  40106e:	f803 1b01 	strb.w	r1, [r3], #1
  401072:	42a3      	cmp	r3, r4
  401074:	d1fb      	bne.n	40106e <memset+0x82>
  401076:	bd30      	pop	{r4, r5, pc}
  401078:	4664      	mov	r4, ip
  40107a:	4613      	mov	r3, r2
  40107c:	2c00      	cmp	r4, #0
  40107e:	d1f4      	bne.n	40106a <memset+0x7e>
  401080:	e7f9      	b.n	401076 <memset+0x8a>
  401082:	4603      	mov	r3, r0
  401084:	4614      	mov	r4, r2
  401086:	e7c0      	b.n	40100a <memset+0x1e>
  401088:	461a      	mov	r2, r3
  40108a:	46a4      	mov	ip, r4
  40108c:	e7e0      	b.n	401050 <memset+0x64>
  40108e:	bf00      	nop

00401090 <memcpy>:
  401090:	4684      	mov	ip, r0
  401092:	ea41 0300 	orr.w	r3, r1, r0
  401096:	f013 0303 	ands.w	r3, r3, #3
  40109a:	d16d      	bne.n	401178 <memcpy+0xe8>
  40109c:	3a40      	subs	r2, #64	; 0x40
  40109e:	d341      	bcc.n	401124 <memcpy+0x94>
  4010a0:	f851 3b04 	ldr.w	r3, [r1], #4
  4010a4:	f840 3b04 	str.w	r3, [r0], #4
  4010a8:	f851 3b04 	ldr.w	r3, [r1], #4
  4010ac:	f840 3b04 	str.w	r3, [r0], #4
  4010b0:	f851 3b04 	ldr.w	r3, [r1], #4
  4010b4:	f840 3b04 	str.w	r3, [r0], #4
  4010b8:	f851 3b04 	ldr.w	r3, [r1], #4
  4010bc:	f840 3b04 	str.w	r3, [r0], #4
  4010c0:	f851 3b04 	ldr.w	r3, [r1], #4
  4010c4:	f840 3b04 	str.w	r3, [r0], #4
  4010c8:	f851 3b04 	ldr.w	r3, [r1], #4
  4010cc:	f840 3b04 	str.w	r3, [r0], #4
  4010d0:	f851 3b04 	ldr.w	r3, [r1], #4
  4010d4:	f840 3b04 	str.w	r3, [r0], #4
  4010d8:	f851 3b04 	ldr.w	r3, [r1], #4
  4010dc:	f840 3b04 	str.w	r3, [r0], #4
  4010e0:	f851 3b04 	ldr.w	r3, [r1], #4
  4010e4:	f840 3b04 	str.w	r3, [r0], #4
  4010e8:	f851 3b04 	ldr.w	r3, [r1], #4
  4010ec:	f840 3b04 	str.w	r3, [r0], #4
  4010f0:	f851 3b04 	ldr.w	r3, [r1], #4
  4010f4:	f840 3b04 	str.w	r3, [r0], #4
  4010f8:	f851 3b04 	ldr.w	r3, [r1], #4
  4010fc:	f840 3b04 	str.w	r3, [r0], #4
  401100:	f851 3b04 	ldr.w	r3, [r1], #4
  401104:	f840 3b04 	str.w	r3, [r0], #4
  401108:	f851 3b04 	ldr.w	r3, [r1], #4
  40110c:	f840 3b04 	str.w	r3, [r0], #4
  401110:	f851 3b04 	ldr.w	r3, [r1], #4
  401114:	f840 3b04 	str.w	r3, [r0], #4
  401118:	f851 3b04 	ldr.w	r3, [r1], #4
  40111c:	f840 3b04 	str.w	r3, [r0], #4
  401120:	3a40      	subs	r2, #64	; 0x40
  401122:	d2bd      	bcs.n	4010a0 <memcpy+0x10>
  401124:	3230      	adds	r2, #48	; 0x30
  401126:	d311      	bcc.n	40114c <memcpy+0xbc>
  401128:	f851 3b04 	ldr.w	r3, [r1], #4
  40112c:	f840 3b04 	str.w	r3, [r0], #4
  401130:	f851 3b04 	ldr.w	r3, [r1], #4
  401134:	f840 3b04 	str.w	r3, [r0], #4
  401138:	f851 3b04 	ldr.w	r3, [r1], #4
  40113c:	f840 3b04 	str.w	r3, [r0], #4
  401140:	f851 3b04 	ldr.w	r3, [r1], #4
  401144:	f840 3b04 	str.w	r3, [r0], #4
  401148:	3a10      	subs	r2, #16
  40114a:	d2ed      	bcs.n	401128 <memcpy+0x98>
  40114c:	320c      	adds	r2, #12
  40114e:	d305      	bcc.n	40115c <memcpy+0xcc>
  401150:	f851 3b04 	ldr.w	r3, [r1], #4
  401154:	f840 3b04 	str.w	r3, [r0], #4
  401158:	3a04      	subs	r2, #4
  40115a:	d2f9      	bcs.n	401150 <memcpy+0xc0>
  40115c:	3204      	adds	r2, #4
  40115e:	d008      	beq.n	401172 <memcpy+0xe2>
  401160:	07d2      	lsls	r2, r2, #31
  401162:	bf1c      	itt	ne
  401164:	f811 3b01 	ldrbne.w	r3, [r1], #1
  401168:	f800 3b01 	strbne.w	r3, [r0], #1
  40116c:	d301      	bcc.n	401172 <memcpy+0xe2>
  40116e:	880b      	ldrh	r3, [r1, #0]
  401170:	8003      	strh	r3, [r0, #0]
  401172:	4660      	mov	r0, ip
  401174:	4770      	bx	lr
  401176:	bf00      	nop
  401178:	2a08      	cmp	r2, #8
  40117a:	d313      	bcc.n	4011a4 <memcpy+0x114>
  40117c:	078b      	lsls	r3, r1, #30
  40117e:	d08d      	beq.n	40109c <memcpy+0xc>
  401180:	f010 0303 	ands.w	r3, r0, #3
  401184:	d08a      	beq.n	40109c <memcpy+0xc>
  401186:	f1c3 0304 	rsb	r3, r3, #4
  40118a:	1ad2      	subs	r2, r2, r3
  40118c:	07db      	lsls	r3, r3, #31
  40118e:	bf1c      	itt	ne
  401190:	f811 3b01 	ldrbne.w	r3, [r1], #1
  401194:	f800 3b01 	strbne.w	r3, [r0], #1
  401198:	d380      	bcc.n	40109c <memcpy+0xc>
  40119a:	f831 3b02 	ldrh.w	r3, [r1], #2
  40119e:	f820 3b02 	strh.w	r3, [r0], #2
  4011a2:	e77b      	b.n	40109c <memcpy+0xc>
  4011a4:	3a04      	subs	r2, #4
  4011a6:	d3d9      	bcc.n	40115c <memcpy+0xcc>
  4011a8:	3a01      	subs	r2, #1
  4011aa:	f811 3b01 	ldrb.w	r3, [r1], #1
  4011ae:	f800 3b01 	strb.w	r3, [r0], #1
  4011b2:	d2f9      	bcs.n	4011a8 <memcpy+0x118>
  4011b4:	780b      	ldrb	r3, [r1, #0]
  4011b6:	7003      	strb	r3, [r0, #0]
  4011b8:	784b      	ldrb	r3, [r1, #1]
  4011ba:	7043      	strb	r3, [r0, #1]
  4011bc:	788b      	ldrb	r3, [r1, #2]
  4011be:	7083      	strb	r3, [r0, #2]
  4011c0:	4660      	mov	r0, ip
  4011c2:	4770      	bx	lr
  4011c4:	16157e2b 	.word	0x16157e2b
  4011c8:	a6d2ae28 	.word	0xa6d2ae28
  4011cc:	8815f7ab 	.word	0x8815f7ab
  4011d0:	3c4fcf09 	.word	0x3c4fcf09
	...

004011d5 <hex_lookup>:
  4011d5:	33323130 37363534 42413938 46454443     0123456789ABCDEF
  4011e5:	                                         ...

004011e8 <_init>:
  4011e8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
  4011ea:	bf00      	nop
  4011ec:	bcf8      	pop	{r3, r4, r5, r6, r7}
  4011ee:	bc08      	pop	{r3}
  4011f0:	469e      	mov	lr, r3
  4011f2:	4770      	bx	lr

004011f4 <__frame_dummy_init_array_entry>:
  4011f4:	0135 0040                                   5.@.

004011f8 <_fini>:
  4011f8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
  4011fa:	bf00      	nop
  4011fc:	bcf8      	pop	{r3, r4, r5, r6, r7}
  4011fe:	bc08      	pop	{r3}
  401200:	469e      	mov	lr, r3
  401202:	4770      	bx	lr

00401204 <__do_global_dtors_aux_fini_array_entry>:
  401204:	010d 0040                                   ..@.
