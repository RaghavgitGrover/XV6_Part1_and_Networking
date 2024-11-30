
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
      14:	bf6080e7          	jalr	-1034(ra) # 5c06 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	be4080e7          	jalr	-1052(ra) # 5c06 <open>
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
      42:	0e250513          	addi	a0,a0,226 # 6120 <malloc+0x104>
      46:	00006097          	auipc	ra,0x6
      4a:	f18080e7          	jalr	-232(ra) # 5f5e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b76080e7          	jalr	-1162(ra) # 5bc6 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	4c078793          	addi	a5,a5,1216 # a518 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	bc868693          	addi	a3,a3,-1080 # cc28 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0c050513          	addi	a0,a0,192 # 6140 <malloc+0x124>
      88:	00006097          	auipc	ra,0x6
      8c:	ed6080e7          	jalr	-298(ra) # 5f5e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b34080e7          	jalr	-1228(ra) # 5bc6 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0b050513          	addi	a0,a0,176 # 6158 <malloc+0x13c>
      b0:	00006097          	auipc	ra,0x6
      b4:	b56080e7          	jalr	-1194(ra) # 5c06 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b32080e7          	jalr	-1230(ra) # 5bee <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0b250513          	addi	a0,a0,178 # 6178 <malloc+0x15c>
      ce:	00006097          	auipc	ra,0x6
      d2:	b38080e7          	jalr	-1224(ra) # 5c06 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	07a50513          	addi	a0,a0,122 # 6160 <malloc+0x144>
      ee:	00006097          	auipc	ra,0x6
      f2:	e70080e7          	jalr	-400(ra) # 5f5e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	ace080e7          	jalr	-1330(ra) # 5bc6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	08650513          	addi	a0,a0,134 # 6188 <malloc+0x16c>
     10a:	00006097          	auipc	ra,0x6
     10e:	e54080e7          	jalr	-428(ra) # 5f5e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	ab2080e7          	jalr	-1358(ra) # 5bc6 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	08450513          	addi	a0,a0,132 # 61b0 <malloc+0x194>
     134:	00006097          	auipc	ra,0x6
     138:	ae2080e7          	jalr	-1310(ra) # 5c16 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	07050513          	addi	a0,a0,112 # 61b0 <malloc+0x194>
     148:	00006097          	auipc	ra,0x6
     14c:	abe080e7          	jalr	-1346(ra) # 5c06 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	06c58593          	addi	a1,a1,108 # 61c0 <malloc+0x1a4>
     15c:	00006097          	auipc	ra,0x6
     160:	a8a080e7          	jalr	-1398(ra) # 5be6 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	04850513          	addi	a0,a0,72 # 61b0 <malloc+0x194>
     170:	00006097          	auipc	ra,0x6
     174:	a96080e7          	jalr	-1386(ra) # 5c06 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	04c58593          	addi	a1,a1,76 # 61c8 <malloc+0x1ac>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a60080e7          	jalr	-1440(ra) # 5be6 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	01c50513          	addi	a0,a0,28 # 61b0 <malloc+0x194>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a7a080e7          	jalr	-1414(ra) # 5c16 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a48080e7          	jalr	-1464(ra) # 5bee <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a3e080e7          	jalr	-1474(ra) # 5bee <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	00650513          	addi	a0,a0,6 # 61d0 <malloc+0x1b4>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d8c080e7          	jalr	-628(ra) # 5f5e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9ea080e7          	jalr	-1558(ra) # 5bc6 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9f6080e7          	jalr	-1546(ra) # 5c06 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9d6080e7          	jalr	-1578(ra) # 5bee <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9d0080e7          	jalr	-1584(ra) # 5c16 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f7c50513          	addi	a0,a0,-132 # 61f8 <malloc+0x1dc>
     284:	00006097          	auipc	ra,0x6
     288:	992080e7          	jalr	-1646(ra) # 5c16 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f68a8a93          	addi	s5,s5,-152 # 61f8 <malloc+0x1dc>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	990a0a13          	addi	s4,s4,-1648 # cc28 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x1cd>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	95a080e7          	jalr	-1702(ra) # 5c06 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	928080e7          	jalr	-1752(ra) # 5be6 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	914080e7          	jalr	-1772(ra) # 5be6 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	90e080e7          	jalr	-1778(ra) # 5bee <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	92c080e7          	jalr	-1748(ra) # 5c16 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	ef650513          	addi	a0,a0,-266 # 6208 <malloc+0x1ec>
     31a:	00006097          	auipc	ra,0x6
     31e:	c44080e7          	jalr	-956(ra) # 5f5e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8a2080e7          	jalr	-1886(ra) # 5bc6 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	ef250513          	addi	a0,a0,-270 # 6228 <malloc+0x20c>
     33e:	00006097          	auipc	ra,0x6
     342:	c20080e7          	jalr	-992(ra) # 5f5e <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00006097          	auipc	ra,0x6
     34c:	87e080e7          	jalr	-1922(ra) # 5bc6 <exit>

0000000000000350 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	e052                	sd	s4,0(sp)
     35e:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     360:	00006517          	auipc	a0,0x6
     364:	ee050513          	addi	a0,a0,-288 # 6240 <malloc+0x224>
     368:	00006097          	auipc	ra,0x6
     36c:	8ae080e7          	jalr	-1874(ra) # 5c16 <unlink>
     370:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     374:	00006997          	auipc	s3,0x6
     378:	ecc98993          	addi	s3,s3,-308 # 6240 <malloc+0x224>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37c:	5a7d                	li	s4,-1
     37e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     382:	20100593          	li	a1,513
     386:	854e                	mv	a0,s3
     388:	00006097          	auipc	ra,0x6
     38c:	87e080e7          	jalr	-1922(ra) # 5c06 <open>
     390:	84aa                	mv	s1,a0
    if(fd < 0){
     392:	06054b63          	bltz	a0,408 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     396:	4605                	li	a2,1
     398:	85d2                	mv	a1,s4
     39a:	00006097          	auipc	ra,0x6
     39e:	84c080e7          	jalr	-1972(ra) # 5be6 <write>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00006097          	auipc	ra,0x6
     3a8:	84a080e7          	jalr	-1974(ra) # 5bee <close>
    unlink("junk");
     3ac:	854e                	mv	a0,s3
     3ae:	00006097          	auipc	ra,0x6
     3b2:	868080e7          	jalr	-1944(ra) # 5c16 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b6:	397d                	addiw	s2,s2,-1
     3b8:	fc0915e3          	bnez	s2,382 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100593          	li	a1,513
     3c0:	00006517          	auipc	a0,0x6
     3c4:	e8050513          	addi	a0,a0,-384 # 6240 <malloc+0x224>
     3c8:	00006097          	auipc	ra,0x6
     3cc:	83e080e7          	jalr	-1986(ra) # 5c06 <open>
     3d0:	84aa                	mv	s1,a0
  if(fd < 0){
     3d2:	04054863          	bltz	a0,422 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d6:	4605                	li	a2,1
     3d8:	00006597          	auipc	a1,0x6
     3dc:	df058593          	addi	a1,a1,-528 # 61c8 <malloc+0x1ac>
     3e0:	00006097          	auipc	ra,0x6
     3e4:	806080e7          	jalr	-2042(ra) # 5be6 <write>
     3e8:	4785                	li	a5,1
     3ea:	04f50963          	beq	a0,a5,43c <badwrite+0xec>
    printf("write failed\n");
     3ee:	00006517          	auipc	a0,0x6
     3f2:	e7250513          	addi	a0,a0,-398 # 6260 <malloc+0x244>
     3f6:	00006097          	auipc	ra,0x6
     3fa:	b68080e7          	jalr	-1176(ra) # 5f5e <printf>
    exit(1);
     3fe:	4505                	li	a0,1
     400:	00005097          	auipc	ra,0x5
     404:	7c6080e7          	jalr	1990(ra) # 5bc6 <exit>
      printf("open junk failed\n");
     408:	00006517          	auipc	a0,0x6
     40c:	e4050513          	addi	a0,a0,-448 # 6248 <malloc+0x22c>
     410:	00006097          	auipc	ra,0x6
     414:	b4e080e7          	jalr	-1202(ra) # 5f5e <printf>
      exit(1);
     418:	4505                	li	a0,1
     41a:	00005097          	auipc	ra,0x5
     41e:	7ac080e7          	jalr	1964(ra) # 5bc6 <exit>
    printf("open junk failed\n");
     422:	00006517          	auipc	a0,0x6
     426:	e2650513          	addi	a0,a0,-474 # 6248 <malloc+0x22c>
     42a:	00006097          	auipc	ra,0x6
     42e:	b34080e7          	jalr	-1228(ra) # 5f5e <printf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00005097          	auipc	ra,0x5
     438:	792080e7          	jalr	1938(ra) # 5bc6 <exit>
  }
  close(fd);
     43c:	8526                	mv	a0,s1
     43e:	00005097          	auipc	ra,0x5
     442:	7b0080e7          	jalr	1968(ra) # 5bee <close>
  unlink("junk");
     446:	00006517          	auipc	a0,0x6
     44a:	dfa50513          	addi	a0,a0,-518 # 6240 <malloc+0x224>
     44e:	00005097          	auipc	ra,0x5
     452:	7c8080e7          	jalr	1992(ra) # 5c16 <unlink>

  exit(0);
     456:	4501                	li	a0,0
     458:	00005097          	auipc	ra,0x5
     45c:	76e080e7          	jalr	1902(ra) # 5bc6 <exit>

0000000000000460 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     460:	715d                	addi	sp,sp,-80
     462:	e486                	sd	ra,72(sp)
     464:	e0a2                	sd	s0,64(sp)
     466:	fc26                	sd	s1,56(sp)
     468:	f84a                	sd	s2,48(sp)
     46a:	f44e                	sd	s3,40(sp)
     46c:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     470:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d79b          	sraiw	a5,s1,0x1f
     484:	01b7d71b          	srliw	a4,a5,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a4:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a8:	fb040513          	addi	a0,s0,-80
     4ac:	00005097          	auipc	ra,0x5
     4b0:	76a080e7          	jalr	1898(ra) # 5c16 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b4:	60200593          	li	a1,1538
     4b8:	fb040513          	addi	a0,s0,-80
     4bc:	00005097          	auipc	ra,0x5
     4c0:	74a080e7          	jalr	1866(ra) # 5c06 <open>
    if(fd < 0){
     4c4:	00054963          	bltz	a0,4d6 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c8:	00005097          	auipc	ra,0x5
     4cc:	726080e7          	jalr	1830(ra) # 5bee <close>
  for(int i = 0; i < nzz; i++){
     4d0:	2485                	addiw	s1,s1,1
     4d2:	fb3493e3          	bne	s1,s3,478 <outofinodes+0x18>
     4d6:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4dc:	40000993          	li	s3,1024
    name[0] = 'z';
     4e0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e8:	41f4d79b          	sraiw	a5,s1,0x1f
     4ec:	01b7d71b          	srliw	a4,a5,0x1b
     4f0:	009707bb          	addw	a5,a4,s1
     4f4:	4057d69b          	sraiw	a3,a5,0x5
     4f8:	0306869b          	addiw	a3,a3,48
     4fc:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     500:	8bfd                	andi	a5,a5,31
     502:	9f99                	subw	a5,a5,a4
     504:	0307879b          	addiw	a5,a5,48
     508:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     510:	fb040513          	addi	a0,s0,-80
     514:	00005097          	auipc	ra,0x5
     518:	702080e7          	jalr	1794(ra) # 5c16 <unlink>
  for(int i = 0; i < nzz; i++){
     51c:	2485                	addiw	s1,s1,1
     51e:	fd3491e3          	bne	s1,s3,4e0 <outofinodes+0x80>
  }
}
     522:	60a6                	ld	ra,72(sp)
     524:	6406                	ld	s0,64(sp)
     526:	74e2                	ld	s1,56(sp)
     528:	7942                	ld	s2,48(sp)
     52a:	79a2                	ld	s3,40(sp)
     52c:	6161                	addi	sp,sp,80
     52e:	8082                	ret

0000000000000530 <copyin>:
{
     530:	715d                	addi	sp,sp,-80
     532:	e486                	sd	ra,72(sp)
     534:	e0a2                	sd	s0,64(sp)
     536:	fc26                	sd	s1,56(sp)
     538:	f84a                	sd	s2,48(sp)
     53a:	f44e                	sd	s3,40(sp)
     53c:	f052                	sd	s4,32(sp)
     53e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     540:	4785                	li	a5,1
     542:	07fe                	slli	a5,a5,0x1f
     544:	fcf43023          	sd	a5,-64(s0)
     548:	57fd                	li	a5,-1
     54a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     552:	00006a17          	auipc	s4,0x6
     556:	d1ea0a13          	addi	s4,s4,-738 # 6270 <malloc+0x254>
    uint64 addr = addrs[ai];
     55a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55e:	20100593          	li	a1,513
     562:	8552                	mv	a0,s4
     564:	00005097          	auipc	ra,0x5
     568:	6a2080e7          	jalr	1698(ra) # 5c06 <open>
     56c:	84aa                	mv	s1,a0
    if(fd < 0){
     56e:	08054863          	bltz	a0,5fe <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     572:	6609                	lui	a2,0x2
     574:	85ce                	mv	a1,s3
     576:	00005097          	auipc	ra,0x5
     57a:	670080e7          	jalr	1648(ra) # 5be6 <write>
    if(n >= 0){
     57e:	08055d63          	bgez	a0,618 <copyin+0xe8>
    close(fd);
     582:	8526                	mv	a0,s1
     584:	00005097          	auipc	ra,0x5
     588:	66a080e7          	jalr	1642(ra) # 5bee <close>
    unlink("copyin1");
     58c:	8552                	mv	a0,s4
     58e:	00005097          	auipc	ra,0x5
     592:	688080e7          	jalr	1672(ra) # 5c16 <unlink>
    n = write(1, (char*)addr, 8192);
     596:	6609                	lui	a2,0x2
     598:	85ce                	mv	a1,s3
     59a:	4505                	li	a0,1
     59c:	00005097          	auipc	ra,0x5
     5a0:	64a080e7          	jalr	1610(ra) # 5be6 <write>
    if(n > 0){
     5a4:	08a04963          	bgtz	a0,636 <copyin+0x106>
    if(pipe(fds) < 0){
     5a8:	fb840513          	addi	a0,s0,-72
     5ac:	00005097          	auipc	ra,0x5
     5b0:	62a080e7          	jalr	1578(ra) # 5bd6 <pipe>
     5b4:	0a054063          	bltz	a0,654 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b8:	6609                	lui	a2,0x2
     5ba:	85ce                	mv	a1,s3
     5bc:	fbc42503          	lw	a0,-68(s0)
     5c0:	00005097          	auipc	ra,0x5
     5c4:	626080e7          	jalr	1574(ra) # 5be6 <write>
    if(n > 0){
     5c8:	0aa04363          	bgtz	a0,66e <copyin+0x13e>
    close(fds[0]);
     5cc:	fb842503          	lw	a0,-72(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	61e080e7          	jalr	1566(ra) # 5bee <close>
    close(fds[1]);
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	612080e7          	jalr	1554(ra) # 5bee <close>
  for(int ai = 0; ai < 2; ai++){
     5e4:	0921                	addi	s2,s2,8
     5e6:	fd040793          	addi	a5,s0,-48
     5ea:	f6f918e3          	bne	s2,a5,55a <copyin+0x2a>
}
     5ee:	60a6                	ld	ra,72(sp)
     5f0:	6406                	ld	s0,64(sp)
     5f2:	74e2                	ld	s1,56(sp)
     5f4:	7942                	ld	s2,48(sp)
     5f6:	79a2                	ld	s3,40(sp)
     5f8:	7a02                	ld	s4,32(sp)
     5fa:	6161                	addi	sp,sp,80
     5fc:	8082                	ret
      printf("open(copyin1) failed\n");
     5fe:	00006517          	auipc	a0,0x6
     602:	c7a50513          	addi	a0,a0,-902 # 6278 <malloc+0x25c>
     606:	00006097          	auipc	ra,0x6
     60a:	958080e7          	jalr	-1704(ra) # 5f5e <printf>
      exit(1);
     60e:	4505                	li	a0,1
     610:	00005097          	auipc	ra,0x5
     614:	5b6080e7          	jalr	1462(ra) # 5bc6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     618:	862a                	mv	a2,a0
     61a:	85ce                	mv	a1,s3
     61c:	00006517          	auipc	a0,0x6
     620:	c7450513          	addi	a0,a0,-908 # 6290 <malloc+0x274>
     624:	00006097          	auipc	ra,0x6
     628:	93a080e7          	jalr	-1734(ra) # 5f5e <printf>
      exit(1);
     62c:	4505                	li	a0,1
     62e:	00005097          	auipc	ra,0x5
     632:	598080e7          	jalr	1432(ra) # 5bc6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     636:	862a                	mv	a2,a0
     638:	85ce                	mv	a1,s3
     63a:	00006517          	auipc	a0,0x6
     63e:	c8650513          	addi	a0,a0,-890 # 62c0 <malloc+0x2a4>
     642:	00006097          	auipc	ra,0x6
     646:	91c080e7          	jalr	-1764(ra) # 5f5e <printf>
      exit(1);
     64a:	4505                	li	a0,1
     64c:	00005097          	auipc	ra,0x5
     650:	57a080e7          	jalr	1402(ra) # 5bc6 <exit>
      printf("pipe() failed\n");
     654:	00006517          	auipc	a0,0x6
     658:	c9c50513          	addi	a0,a0,-868 # 62f0 <malloc+0x2d4>
     65c:	00006097          	auipc	ra,0x6
     660:	902080e7          	jalr	-1790(ra) # 5f5e <printf>
      exit(1);
     664:	4505                	li	a0,1
     666:	00005097          	auipc	ra,0x5
     66a:	560080e7          	jalr	1376(ra) # 5bc6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66e:	862a                	mv	a2,a0
     670:	85ce                	mv	a1,s3
     672:	00006517          	auipc	a0,0x6
     676:	c8e50513          	addi	a0,a0,-882 # 6300 <malloc+0x2e4>
     67a:	00006097          	auipc	ra,0x6
     67e:	8e4080e7          	jalr	-1820(ra) # 5f5e <printf>
      exit(1);
     682:	4505                	li	a0,1
     684:	00005097          	auipc	ra,0x5
     688:	542080e7          	jalr	1346(ra) # 5bc6 <exit>

000000000000068c <copyout>:
{
     68c:	711d                	addi	sp,sp,-96
     68e:	ec86                	sd	ra,88(sp)
     690:	e8a2                	sd	s0,80(sp)
     692:	e4a6                	sd	s1,72(sp)
     694:	e0ca                	sd	s2,64(sp)
     696:	fc4e                	sd	s3,56(sp)
     698:	f852                	sd	s4,48(sp)
     69a:	f456                	sd	s5,40(sp)
     69c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69e:	4785                	li	a5,1
     6a0:	07fe                	slli	a5,a5,0x1f
     6a2:	faf43823          	sd	a5,-80(s0)
     6a6:	57fd                	li	a5,-1
     6a8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6ac:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6b0:	00006a17          	auipc	s4,0x6
     6b4:	c80a0a13          	addi	s4,s4,-896 # 6330 <malloc+0x314>
    n = write(fds[1], "x", 1);
     6b8:	00006a97          	auipc	s5,0x6
     6bc:	b10a8a93          	addi	s5,s5,-1264 # 61c8 <malloc+0x1ac>
    uint64 addr = addrs[ai];
     6c0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c4:	4581                	li	a1,0
     6c6:	8552                	mv	a0,s4
     6c8:	00005097          	auipc	ra,0x5
     6cc:	53e080e7          	jalr	1342(ra) # 5c06 <open>
     6d0:	84aa                	mv	s1,a0
    if(fd < 0){
     6d2:	08054663          	bltz	a0,75e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d6:	6609                	lui	a2,0x2
     6d8:	85ce                	mv	a1,s3
     6da:	00005097          	auipc	ra,0x5
     6de:	504080e7          	jalr	1284(ra) # 5bde <read>
    if(n > 0){
     6e2:	08a04b63          	bgtz	a0,778 <copyout+0xec>
    close(fd);
     6e6:	8526                	mv	a0,s1
     6e8:	00005097          	auipc	ra,0x5
     6ec:	506080e7          	jalr	1286(ra) # 5bee <close>
    if(pipe(fds) < 0){
     6f0:	fa840513          	addi	a0,s0,-88
     6f4:	00005097          	auipc	ra,0x5
     6f8:	4e2080e7          	jalr	1250(ra) # 5bd6 <pipe>
     6fc:	08054d63          	bltz	a0,796 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     700:	4605                	li	a2,1
     702:	85d6                	mv	a1,s5
     704:	fac42503          	lw	a0,-84(s0)
     708:	00005097          	auipc	ra,0x5
     70c:	4de080e7          	jalr	1246(ra) # 5be6 <write>
    if(n != 1){
     710:	4785                	li	a5,1
     712:	08f51f63          	bne	a0,a5,7b0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     716:	6609                	lui	a2,0x2
     718:	85ce                	mv	a1,s3
     71a:	fa842503          	lw	a0,-88(s0)
     71e:	00005097          	auipc	ra,0x5
     722:	4c0080e7          	jalr	1216(ra) # 5bde <read>
    if(n > 0){
     726:	0aa04263          	bgtz	a0,7ca <copyout+0x13e>
    close(fds[0]);
     72a:	fa842503          	lw	a0,-88(s0)
     72e:	00005097          	auipc	ra,0x5
     732:	4c0080e7          	jalr	1216(ra) # 5bee <close>
    close(fds[1]);
     736:	fac42503          	lw	a0,-84(s0)
     73a:	00005097          	auipc	ra,0x5
     73e:	4b4080e7          	jalr	1204(ra) # 5bee <close>
  for(int ai = 0; ai < 2; ai++){
     742:	0921                	addi	s2,s2,8
     744:	fc040793          	addi	a5,s0,-64
     748:	f6f91ce3          	bne	s2,a5,6c0 <copyout+0x34>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
      printf("open(README) failed\n");
     75e:	00006517          	auipc	a0,0x6
     762:	bda50513          	addi	a0,a0,-1062 # 6338 <malloc+0x31c>
     766:	00005097          	auipc	ra,0x5
     76a:	7f8080e7          	jalr	2040(ra) # 5f5e <printf>
      exit(1);
     76e:	4505                	li	a0,1
     770:	00005097          	auipc	ra,0x5
     774:	456080e7          	jalr	1110(ra) # 5bc6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     778:	862a                	mv	a2,a0
     77a:	85ce                	mv	a1,s3
     77c:	00006517          	auipc	a0,0x6
     780:	bd450513          	addi	a0,a0,-1068 # 6350 <malloc+0x334>
     784:	00005097          	auipc	ra,0x5
     788:	7da080e7          	jalr	2010(ra) # 5f5e <printf>
      exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	438080e7          	jalr	1080(ra) # 5bc6 <exit>
      printf("pipe() failed\n");
     796:	00006517          	auipc	a0,0x6
     79a:	b5a50513          	addi	a0,a0,-1190 # 62f0 <malloc+0x2d4>
     79e:	00005097          	auipc	ra,0x5
     7a2:	7c0080e7          	jalr	1984(ra) # 5f5e <printf>
      exit(1);
     7a6:	4505                	li	a0,1
     7a8:	00005097          	auipc	ra,0x5
     7ac:	41e080e7          	jalr	1054(ra) # 5bc6 <exit>
      printf("pipe write failed\n");
     7b0:	00006517          	auipc	a0,0x6
     7b4:	bd050513          	addi	a0,a0,-1072 # 6380 <malloc+0x364>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	7a6080e7          	jalr	1958(ra) # 5f5e <printf>
      exit(1);
     7c0:	4505                	li	a0,1
     7c2:	00005097          	auipc	ra,0x5
     7c6:	404080e7          	jalr	1028(ra) # 5bc6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7ca:	862a                	mv	a2,a0
     7cc:	85ce                	mv	a1,s3
     7ce:	00006517          	auipc	a0,0x6
     7d2:	bca50513          	addi	a0,a0,-1078 # 6398 <malloc+0x37c>
     7d6:	00005097          	auipc	ra,0x5
     7da:	788080e7          	jalr	1928(ra) # 5f5e <printf>
      exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	3e6080e7          	jalr	998(ra) # 5bc6 <exit>

00000000000007e8 <truncate1>:
{
     7e8:	711d                	addi	sp,sp,-96
     7ea:	ec86                	sd	ra,88(sp)
     7ec:	e8a2                	sd	s0,80(sp)
     7ee:	e4a6                	sd	s1,72(sp)
     7f0:	e0ca                	sd	s2,64(sp)
     7f2:	fc4e                	sd	s3,56(sp)
     7f4:	f852                	sd	s4,48(sp)
     7f6:	f456                	sd	s5,40(sp)
     7f8:	1080                	addi	s0,sp,96
     7fa:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fc:	00006517          	auipc	a0,0x6
     800:	9b450513          	addi	a0,a0,-1612 # 61b0 <malloc+0x194>
     804:	00005097          	auipc	ra,0x5
     808:	412080e7          	jalr	1042(ra) # 5c16 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80c:	60100593          	li	a1,1537
     810:	00006517          	auipc	a0,0x6
     814:	9a050513          	addi	a0,a0,-1632 # 61b0 <malloc+0x194>
     818:	00005097          	auipc	ra,0x5
     81c:	3ee080e7          	jalr	1006(ra) # 5c06 <open>
     820:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     822:	4611                	li	a2,4
     824:	00006597          	auipc	a1,0x6
     828:	99c58593          	addi	a1,a1,-1636 # 61c0 <malloc+0x1a4>
     82c:	00005097          	auipc	ra,0x5
     830:	3ba080e7          	jalr	954(ra) # 5be6 <write>
  close(fd1);
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	3b8080e7          	jalr	952(ra) # 5bee <close>
  int fd2 = open("truncfile", O_RDONLY);
     83e:	4581                	li	a1,0
     840:	00006517          	auipc	a0,0x6
     844:	97050513          	addi	a0,a0,-1680 # 61b0 <malloc+0x194>
     848:	00005097          	auipc	ra,0x5
     84c:	3be080e7          	jalr	958(ra) # 5c06 <open>
     850:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     852:	02000613          	li	a2,32
     856:	fa040593          	addi	a1,s0,-96
     85a:	00005097          	auipc	ra,0x5
     85e:	384080e7          	jalr	900(ra) # 5bde <read>
  if(n != 4){
     862:	4791                	li	a5,4
     864:	0cf51e63          	bne	a0,a5,940 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     868:	40100593          	li	a1,1025
     86c:	00006517          	auipc	a0,0x6
     870:	94450513          	addi	a0,a0,-1724 # 61b0 <malloc+0x194>
     874:	00005097          	auipc	ra,0x5
     878:	392080e7          	jalr	914(ra) # 5c06 <open>
     87c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87e:	4581                	li	a1,0
     880:	00006517          	auipc	a0,0x6
     884:	93050513          	addi	a0,a0,-1744 # 61b0 <malloc+0x194>
     888:	00005097          	auipc	ra,0x5
     88c:	37e080e7          	jalr	894(ra) # 5c06 <open>
     890:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     892:	02000613          	li	a2,32
     896:	fa040593          	addi	a1,s0,-96
     89a:	00005097          	auipc	ra,0x5
     89e:	344080e7          	jalr	836(ra) # 5bde <read>
     8a2:	8a2a                	mv	s4,a0
  if(n != 0){
     8a4:	ed4d                	bnez	a0,95e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a6:	02000613          	li	a2,32
     8aa:	fa040593          	addi	a1,s0,-96
     8ae:	8526                	mv	a0,s1
     8b0:	00005097          	auipc	ra,0x5
     8b4:	32e080e7          	jalr	814(ra) # 5bde <read>
     8b8:	8a2a                	mv	s4,a0
  if(n != 0){
     8ba:	e971                	bnez	a0,98e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8bc:	4619                	li	a2,6
     8be:	00006597          	auipc	a1,0x6
     8c2:	b6a58593          	addi	a1,a1,-1174 # 6428 <malloc+0x40c>
     8c6:	854e                	mv	a0,s3
     8c8:	00005097          	auipc	ra,0x5
     8cc:	31e080e7          	jalr	798(ra) # 5be6 <write>
  n = read(fd3, buf, sizeof(buf));
     8d0:	02000613          	li	a2,32
     8d4:	fa040593          	addi	a1,s0,-96
     8d8:	854a                	mv	a0,s2
     8da:	00005097          	auipc	ra,0x5
     8de:	304080e7          	jalr	772(ra) # 5bde <read>
  if(n != 6){
     8e2:	4799                	li	a5,6
     8e4:	0cf51d63          	bne	a0,a5,9be <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e8:	02000613          	li	a2,32
     8ec:	fa040593          	addi	a1,s0,-96
     8f0:	8526                	mv	a0,s1
     8f2:	00005097          	auipc	ra,0x5
     8f6:	2ec080e7          	jalr	748(ra) # 5bde <read>
  if(n != 2){
     8fa:	4789                	li	a5,2
     8fc:	0ef51063          	bne	a0,a5,9dc <truncate1+0x1f4>
  unlink("truncfile");
     900:	00006517          	auipc	a0,0x6
     904:	8b050513          	addi	a0,a0,-1872 # 61b0 <malloc+0x194>
     908:	00005097          	auipc	ra,0x5
     90c:	30e080e7          	jalr	782(ra) # 5c16 <unlink>
  close(fd1);
     910:	854e                	mv	a0,s3
     912:	00005097          	auipc	ra,0x5
     916:	2dc080e7          	jalr	732(ra) # 5bee <close>
  close(fd2);
     91a:	8526                	mv	a0,s1
     91c:	00005097          	auipc	ra,0x5
     920:	2d2080e7          	jalr	722(ra) # 5bee <close>
  close(fd3);
     924:	854a                	mv	a0,s2
     926:	00005097          	auipc	ra,0x5
     92a:	2c8080e7          	jalr	712(ra) # 5bee <close>
}
     92e:	60e6                	ld	ra,88(sp)
     930:	6446                	ld	s0,80(sp)
     932:	64a6                	ld	s1,72(sp)
     934:	6906                	ld	s2,64(sp)
     936:	79e2                	ld	s3,56(sp)
     938:	7a42                	ld	s4,48(sp)
     93a:	7aa2                	ld	s5,40(sp)
     93c:	6125                	addi	sp,sp,96
     93e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     940:	862a                	mv	a2,a0
     942:	85d6                	mv	a1,s5
     944:	00006517          	auipc	a0,0x6
     948:	a8450513          	addi	a0,a0,-1404 # 63c8 <malloc+0x3ac>
     94c:	00005097          	auipc	ra,0x5
     950:	612080e7          	jalr	1554(ra) # 5f5e <printf>
    exit(1);
     954:	4505                	li	a0,1
     956:	00005097          	auipc	ra,0x5
     95a:	270080e7          	jalr	624(ra) # 5bc6 <exit>
    printf("aaa fd3=%d\n", fd3);
     95e:	85ca                	mv	a1,s2
     960:	00006517          	auipc	a0,0x6
     964:	a8850513          	addi	a0,a0,-1400 # 63e8 <malloc+0x3cc>
     968:	00005097          	auipc	ra,0x5
     96c:	5f6080e7          	jalr	1526(ra) # 5f5e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     970:	8652                	mv	a2,s4
     972:	85d6                	mv	a1,s5
     974:	00006517          	auipc	a0,0x6
     978:	a8450513          	addi	a0,a0,-1404 # 63f8 <malloc+0x3dc>
     97c:	00005097          	auipc	ra,0x5
     980:	5e2080e7          	jalr	1506(ra) # 5f5e <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	240080e7          	jalr	576(ra) # 5bc6 <exit>
    printf("bbb fd2=%d\n", fd2);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	a8850513          	addi	a0,a0,-1400 # 6418 <malloc+0x3fc>
     998:	00005097          	auipc	ra,0x5
     99c:	5c6080e7          	jalr	1478(ra) # 5f5e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a0:	8652                	mv	a2,s4
     9a2:	85d6                	mv	a1,s5
     9a4:	00006517          	auipc	a0,0x6
     9a8:	a5450513          	addi	a0,a0,-1452 # 63f8 <malloc+0x3dc>
     9ac:	00005097          	auipc	ra,0x5
     9b0:	5b2080e7          	jalr	1458(ra) # 5f5e <printf>
    exit(1);
     9b4:	4505                	li	a0,1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	210080e7          	jalr	528(ra) # 5bc6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9be:	862a                	mv	a2,a0
     9c0:	85d6                	mv	a1,s5
     9c2:	00006517          	auipc	a0,0x6
     9c6:	a6e50513          	addi	a0,a0,-1426 # 6430 <malloc+0x414>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	594080e7          	jalr	1428(ra) # 5f5e <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	1f2080e7          	jalr	498(ra) # 5bc6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9dc:	862a                	mv	a2,a0
     9de:	85d6                	mv	a1,s5
     9e0:	00006517          	auipc	a0,0x6
     9e4:	a7050513          	addi	a0,a0,-1424 # 6450 <malloc+0x434>
     9e8:	00005097          	auipc	ra,0x5
     9ec:	576080e7          	jalr	1398(ra) # 5f5e <printf>
    exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	1d4080e7          	jalr	468(ra) # 5bc6 <exit>

00000000000009fa <writetest>:
{
     9fa:	7139                	addi	sp,sp,-64
     9fc:	fc06                	sd	ra,56(sp)
     9fe:	f822                	sd	s0,48(sp)
     a00:	f426                	sd	s1,40(sp)
     a02:	f04a                	sd	s2,32(sp)
     a04:	ec4e                	sd	s3,24(sp)
     a06:	e852                	sd	s4,16(sp)
     a08:	e456                	sd	s5,8(sp)
     a0a:	e05a                	sd	s6,0(sp)
     a0c:	0080                	addi	s0,sp,64
     a0e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a10:	20200593          	li	a1,514
     a14:	00006517          	auipc	a0,0x6
     a18:	a5c50513          	addi	a0,a0,-1444 # 6470 <malloc+0x454>
     a1c:	00005097          	auipc	ra,0x5
     a20:	1ea080e7          	jalr	490(ra) # 5c06 <open>
  if(fd < 0){
     a24:	0a054d63          	bltz	a0,ade <writetest+0xe4>
     a28:	892a                	mv	s2,a0
     a2a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2c:	00006997          	auipc	s3,0x6
     a30:	a6c98993          	addi	s3,s3,-1428 # 6498 <malloc+0x47c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a34:	00006a97          	auipc	s5,0x6
     a38:	a9ca8a93          	addi	s5,s5,-1380 # 64d0 <malloc+0x4b4>
  for(i = 0; i < N; i++){
     a3c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a40:	4629                	li	a2,10
     a42:	85ce                	mv	a1,s3
     a44:	854a                	mv	a0,s2
     a46:	00005097          	auipc	ra,0x5
     a4a:	1a0080e7          	jalr	416(ra) # 5be6 <write>
     a4e:	47a9                	li	a5,10
     a50:	0af51563          	bne	a0,a5,afa <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a54:	4629                	li	a2,10
     a56:	85d6                	mv	a1,s5
     a58:	854a                	mv	a0,s2
     a5a:	00005097          	auipc	ra,0x5
     a5e:	18c080e7          	jalr	396(ra) # 5be6 <write>
     a62:	47a9                	li	a5,10
     a64:	0af51a63          	bne	a0,a5,b18 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	fd449be3          	bne	s1,s4,a40 <writetest+0x46>
  close(fd);
     a6e:	854a                	mv	a0,s2
     a70:	00005097          	auipc	ra,0x5
     a74:	17e080e7          	jalr	382(ra) # 5bee <close>
  fd = open("small", O_RDONLY);
     a78:	4581                	li	a1,0
     a7a:	00006517          	auipc	a0,0x6
     a7e:	9f650513          	addi	a0,a0,-1546 # 6470 <malloc+0x454>
     a82:	00005097          	auipc	ra,0x5
     a86:	184080e7          	jalr	388(ra) # 5c06 <open>
     a8a:	84aa                	mv	s1,a0
  if(fd < 0){
     a8c:	0a054563          	bltz	a0,b36 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a90:	7d000613          	li	a2,2000
     a94:	0000c597          	auipc	a1,0xc
     a98:	19458593          	addi	a1,a1,404 # cc28 <buf>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	142080e7          	jalr	322(ra) # 5bde <read>
  if(i != N*SZ*2){
     aa4:	7d000793          	li	a5,2000
     aa8:	0af51563          	bne	a0,a5,b52 <writetest+0x158>
  close(fd);
     aac:	8526                	mv	a0,s1
     aae:	00005097          	auipc	ra,0x5
     ab2:	140080e7          	jalr	320(ra) # 5bee <close>
  if(unlink("small") < 0){
     ab6:	00006517          	auipc	a0,0x6
     aba:	9ba50513          	addi	a0,a0,-1606 # 6470 <malloc+0x454>
     abe:	00005097          	auipc	ra,0x5
     ac2:	158080e7          	jalr	344(ra) # 5c16 <unlink>
     ac6:	0a054463          	bltz	a0,b6e <writetest+0x174>
}
     aca:	70e2                	ld	ra,56(sp)
     acc:	7442                	ld	s0,48(sp)
     ace:	74a2                	ld	s1,40(sp)
     ad0:	7902                	ld	s2,32(sp)
     ad2:	69e2                	ld	s3,24(sp)
     ad4:	6a42                	ld	s4,16(sp)
     ad6:	6aa2                	ld	s5,8(sp)
     ad8:	6b02                	ld	s6,0(sp)
     ada:	6121                	addi	sp,sp,64
     adc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ade:	85da                	mv	a1,s6
     ae0:	00006517          	auipc	a0,0x6
     ae4:	99850513          	addi	a0,a0,-1640 # 6478 <malloc+0x45c>
     ae8:	00005097          	auipc	ra,0x5
     aec:	476080e7          	jalr	1142(ra) # 5f5e <printf>
    exit(1);
     af0:	4505                	li	a0,1
     af2:	00005097          	auipc	ra,0x5
     af6:	0d4080e7          	jalr	212(ra) # 5bc6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     afa:	8626                	mv	a2,s1
     afc:	85da                	mv	a1,s6
     afe:	00006517          	auipc	a0,0x6
     b02:	9aa50513          	addi	a0,a0,-1622 # 64a8 <malloc+0x48c>
     b06:	00005097          	auipc	ra,0x5
     b0a:	458080e7          	jalr	1112(ra) # 5f5e <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	00005097          	auipc	ra,0x5
     b14:	0b6080e7          	jalr	182(ra) # 5bc6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b18:	8626                	mv	a2,s1
     b1a:	85da                	mv	a1,s6
     b1c:	00006517          	auipc	a0,0x6
     b20:	9c450513          	addi	a0,a0,-1596 # 64e0 <malloc+0x4c4>
     b24:	00005097          	auipc	ra,0x5
     b28:	43a080e7          	jalr	1082(ra) # 5f5e <printf>
      exit(1);
     b2c:	4505                	li	a0,1
     b2e:	00005097          	auipc	ra,0x5
     b32:	098080e7          	jalr	152(ra) # 5bc6 <exit>
    printf("%s: error: open small failed!\n", s);
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	9d050513          	addi	a0,a0,-1584 # 6508 <malloc+0x4ec>
     b40:	00005097          	auipc	ra,0x5
     b44:	41e080e7          	jalr	1054(ra) # 5f5e <printf>
    exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	07c080e7          	jalr	124(ra) # 5bc6 <exit>
    printf("%s: read failed\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00006517          	auipc	a0,0x6
     b58:	9d450513          	addi	a0,a0,-1580 # 6528 <malloc+0x50c>
     b5c:	00005097          	auipc	ra,0x5
     b60:	402080e7          	jalr	1026(ra) # 5f5e <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	060080e7          	jalr	96(ra) # 5bc6 <exit>
    printf("%s: unlink small failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00006517          	auipc	a0,0x6
     b74:	9d050513          	addi	a0,a0,-1584 # 6540 <malloc+0x524>
     b78:	00005097          	auipc	ra,0x5
     b7c:	3e6080e7          	jalr	998(ra) # 5f5e <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	044080e7          	jalr	68(ra) # 5bc6 <exit>

0000000000000b8a <writebig>:
{
     b8a:	7139                	addi	sp,sp,-64
     b8c:	fc06                	sd	ra,56(sp)
     b8e:	f822                	sd	s0,48(sp)
     b90:	f426                	sd	s1,40(sp)
     b92:	f04a                	sd	s2,32(sp)
     b94:	ec4e                	sd	s3,24(sp)
     b96:	e852                	sd	s4,16(sp)
     b98:	e456                	sd	s5,8(sp)
     b9a:	0080                	addi	s0,sp,64
     b9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9e:	20200593          	li	a1,514
     ba2:	00006517          	auipc	a0,0x6
     ba6:	9be50513          	addi	a0,a0,-1602 # 6560 <malloc+0x544>
     baa:	00005097          	auipc	ra,0x5
     bae:	05c080e7          	jalr	92(ra) # 5c06 <open>
     bb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb6:	0000c917          	auipc	s2,0xc
     bba:	07290913          	addi	s2,s2,114 # cc28 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbe:	10c00a13          	li	s4,268
  if(fd < 0){
     bc2:	06054c63          	bltz	a0,c3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	014080e7          	jalr	20(ra) # 5be6 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3c>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	004080e7          	jalr	4(ra) # 5bee <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	96c50513          	addi	a0,a0,-1684 # 6560 <malloc+0x544>
     bfc:	00005097          	auipc	ra,0x5
     c00:	00a080e7          	jalr	10(ra) # 5c06 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000c917          	auipc	s2,0xc
     c0c:	02090913          	addi	s2,s2,32 # cc28 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	fc2080e7          	jalr	-62(ra) # 5bde <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x106>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17c>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	92c50513          	addi	a0,a0,-1748 # 6568 <malloc+0x54c>
     c44:	00005097          	auipc	ra,0x5
     c48:	31a080e7          	jalr	794(ra) # 5f5e <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	f78080e7          	jalr	-136(ra) # 5bc6 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	92e50513          	addi	a0,a0,-1746 # 6588 <malloc+0x56c>
     c62:	00005097          	auipc	ra,0x5
     c66:	2fc080e7          	jalr	764(ra) # 5f5e <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	f5a080e7          	jalr	-166(ra) # 5bc6 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	93a50513          	addi	a0,a0,-1734 # 65b0 <malloc+0x594>
     c7e:	00005097          	auipc	ra,0x5
     c82:	2e0080e7          	jalr	736(ra) # 5f5e <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	f3e080e7          	jalr	-194(ra) # 5bc6 <exit>
      if(n == MAXFILE - 1){
     c90:	10b00793          	li	a5,267
     c94:	02f48a63          	beq	s1,a5,cc8 <writebig+0x13e>
  close(fd);
     c98:	854e                	mv	a0,s3
     c9a:	00005097          	auipc	ra,0x5
     c9e:	f54080e7          	jalr	-172(ra) # 5bee <close>
  if(unlink("big") < 0){
     ca2:	00006517          	auipc	a0,0x6
     ca6:	8be50513          	addi	a0,a0,-1858 # 6560 <malloc+0x544>
     caa:	00005097          	auipc	ra,0x5
     cae:	f6c080e7          	jalr	-148(ra) # 5c16 <unlink>
     cb2:	06054963          	bltz	a0,d24 <writebig+0x19a>
}
     cb6:	70e2                	ld	ra,56(sp)
     cb8:	7442                	ld	s0,48(sp)
     cba:	74a2                	ld	s1,40(sp)
     cbc:	7902                	ld	s2,32(sp)
     cbe:	69e2                	ld	s3,24(sp)
     cc0:	6a42                	ld	s4,16(sp)
     cc2:	6aa2                	ld	s5,8(sp)
     cc4:	6121                	addi	sp,sp,64
     cc6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc8:	10b00613          	li	a2,267
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	90250513          	addi	a0,a0,-1790 # 65d0 <malloc+0x5b4>
     cd6:	00005097          	auipc	ra,0x5
     cda:	288080e7          	jalr	648(ra) # 5f5e <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	ee6080e7          	jalr	-282(ra) # 5bc6 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	90c50513          	addi	a0,a0,-1780 # 65f8 <malloc+0x5dc>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	26a080e7          	jalr	618(ra) # 5f5e <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	ec8080e7          	jalr	-312(ra) # 5bc6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	90650513          	addi	a0,a0,-1786 # 6610 <malloc+0x5f4>
     d12:	00005097          	auipc	ra,0x5
     d16:	24c080e7          	jalr	588(ra) # 5f5e <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	eaa080e7          	jalr	-342(ra) # 5bc6 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	91250513          	addi	a0,a0,-1774 # 6638 <malloc+0x61c>
     d2e:	00005097          	auipc	ra,0x5
     d32:	230080e7          	jalr	560(ra) # 5f5e <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	e8e080e7          	jalr	-370(ra) # 5bc6 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	8fc50513          	addi	a0,a0,-1796 # 6650 <malloc+0x634>
     d5c:	00005097          	auipc	ra,0x5
     d60:	eaa080e7          	jalr	-342(ra) # 5c06 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	91458593          	addi	a1,a1,-1772 # 6680 <malloc+0x664>
     d74:	00005097          	auipc	ra,0x5
     d78:	e72080e7          	jalr	-398(ra) # 5be6 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	e70080e7          	jalr	-400(ra) # 5bee <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	8c850513          	addi	a0,a0,-1848 # 6650 <malloc+0x634>
     d90:	00005097          	auipc	ra,0x5
     d94:	e76080e7          	jalr	-394(ra) # 5c06 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	8b250513          	addi	a0,a0,-1870 # 6650 <malloc+0x634>
     da6:	00005097          	auipc	ra,0x5
     daa:	e70080e7          	jalr	-400(ra) # 5c16 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	89c50513          	addi	a0,a0,-1892 # 6650 <malloc+0x634>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	e4a080e7          	jalr	-438(ra) # 5c06 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	90058593          	addi	a1,a1,-1792 # 66c8 <malloc+0x6ac>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e16080e7          	jalr	-490(ra) # 5be6 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e14080e7          	jalr	-492(ra) # 5bee <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000c597          	auipc	a1,0xc
     de8:	e4458593          	addi	a1,a1,-444 # cc28 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	df0080e7          	jalr	-528(ra) # 5bde <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000c717          	auipc	a4,0xc
     e00:	e2c74703          	lbu	a4,-468(a4) # cc28 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000c597          	auipc	a1,0xc
     e12:	e1a58593          	addi	a1,a1,-486 # cc28 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	dce080e7          	jalr	-562(ra) # 5be6 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	dc6080e7          	jalr	-570(ra) # 5bee <close>
  unlink("unlinkread");
     e30:	00006517          	auipc	a0,0x6
     e34:	82050513          	addi	a0,a0,-2016 # 6650 <malloc+0x634>
     e38:	00005097          	auipc	ra,0x5
     e3c:	dde080e7          	jalr	-546(ra) # 5c16 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00006517          	auipc	a0,0x6
     e54:	81050513          	addi	a0,a0,-2032 # 6660 <malloc+0x644>
     e58:	00005097          	auipc	ra,0x5
     e5c:	106080e7          	jalr	262(ra) # 5f5e <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	d64080e7          	jalr	-668(ra) # 5bc6 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00006517          	auipc	a0,0x6
     e70:	81c50513          	addi	a0,a0,-2020 # 6688 <malloc+0x66c>
     e74:	00005097          	auipc	ra,0x5
     e78:	0ea080e7          	jalr	234(ra) # 5f5e <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	d48080e7          	jalr	-696(ra) # 5bc6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00006517          	auipc	a0,0x6
     e8c:	82050513          	addi	a0,a0,-2016 # 66a8 <malloc+0x68c>
     e90:	00005097          	auipc	ra,0x5
     e94:	0ce080e7          	jalr	206(ra) # 5f5e <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	d2c080e7          	jalr	-724(ra) # 5bc6 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00006517          	auipc	a0,0x6
     ea8:	82c50513          	addi	a0,a0,-2004 # 66d0 <malloc+0x6b4>
     eac:	00005097          	auipc	ra,0x5
     eb0:	0b2080e7          	jalr	178(ra) # 5f5e <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d10080e7          	jalr	-752(ra) # 5bc6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	83050513          	addi	a0,a0,-2000 # 66f0 <malloc+0x6d4>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	096080e7          	jalr	150(ra) # 5f5e <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	cf4080e7          	jalr	-780(ra) # 5bc6 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	83450513          	addi	a0,a0,-1996 # 6710 <malloc+0x6f4>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	07a080e7          	jalr	122(ra) # 5f5e <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	cd8080e7          	jalr	-808(ra) # 5bc6 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00006517          	auipc	a0,0x6
     f08:	82c50513          	addi	a0,a0,-2004 # 6730 <malloc+0x714>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d0a080e7          	jalr	-758(ra) # 5c16 <unlink>
  unlink("lf2");
     f14:	00006517          	auipc	a0,0x6
     f18:	82450513          	addi	a0,a0,-2012 # 6738 <malloc+0x71c>
     f1c:	00005097          	auipc	ra,0x5
     f20:	cfa080e7          	jalr	-774(ra) # 5c16 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00006517          	auipc	a0,0x6
     f2c:	80850513          	addi	a0,a0,-2040 # 6730 <malloc+0x714>
     f30:	00005097          	auipc	ra,0x5
     f34:	cd6080e7          	jalr	-810(ra) # 5c06 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	74058593          	addi	a1,a1,1856 # 6680 <malloc+0x664>
     f48:	00005097          	auipc	ra,0x5
     f4c:	c9e080e7          	jalr	-866(ra) # 5be6 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	c96080e7          	jalr	-874(ra) # 5bee <close>
  if(link("lf1", "lf2") < 0){
     f60:	00005597          	auipc	a1,0x5
     f64:	7d858593          	addi	a1,a1,2008 # 6738 <malloc+0x71c>
     f68:	00005517          	auipc	a0,0x5
     f6c:	7c850513          	addi	a0,a0,1992 # 6730 <malloc+0x714>
     f70:	00005097          	auipc	ra,0x5
     f74:	cb6080e7          	jalr	-842(ra) # 5c26 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	7b450513          	addi	a0,a0,1972 # 6730 <malloc+0x714>
     f84:	00005097          	auipc	ra,0x5
     f88:	c92080e7          	jalr	-878(ra) # 5c16 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	7a250513          	addi	a0,a0,1954 # 6730 <malloc+0x714>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c70080e7          	jalr	-912(ra) # 5c06 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	79450513          	addi	a0,a0,1940 # 6738 <malloc+0x71c>
     fac:	00005097          	auipc	ra,0x5
     fb0:	c5a080e7          	jalr	-934(ra) # 5c06 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000c597          	auipc	a1,0xc
     fc0:	c6c58593          	addi	a1,a1,-916 # cc28 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c1a080e7          	jalr	-998(ra) # 5bde <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c1a080e7          	jalr	-998(ra) # 5bee <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	75c58593          	addi	a1,a1,1884 # 6738 <malloc+0x71c>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c40080e7          	jalr	-960(ra) # 5c26 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	74650513          	addi	a0,a0,1862 # 6738 <malloc+0x71c>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c1c080e7          	jalr	-996(ra) # 5c16 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	72e58593          	addi	a1,a1,1838 # 6730 <malloc+0x714>
    100a:	00005517          	auipc	a0,0x5
    100e:	72e50513          	addi	a0,a0,1838 # 6738 <malloc+0x71c>
    1012:	00005097          	auipc	ra,0x5
    1016:	c14080e7          	jalr	-1004(ra) # 5c26 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	71258593          	addi	a1,a1,1810 # 6730 <malloc+0x714>
    1026:	00006517          	auipc	a0,0x6
    102a:	81a50513          	addi	a0,a0,-2022 # 6840 <malloc+0x824>
    102e:	00005097          	auipc	ra,0x5
    1032:	bf8080e7          	jalr	-1032(ra) # 5c26 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	6f850513          	addi	a0,a0,1784 # 6740 <malloc+0x724>
    1050:	00005097          	auipc	ra,0x5
    1054:	f0e080e7          	jalr	-242(ra) # 5f5e <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	b6c080e7          	jalr	-1172(ra) # 5bc6 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	6f450513          	addi	a0,a0,1780 # 6758 <malloc+0x73c>
    106c:	00005097          	auipc	ra,0x5
    1070:	ef2080e7          	jalr	-270(ra) # 5f5e <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	b50080e7          	jalr	-1200(ra) # 5bc6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	6f050513          	addi	a0,a0,1776 # 6770 <malloc+0x754>
    1088:	00005097          	auipc	ra,0x5
    108c:	ed6080e7          	jalr	-298(ra) # 5f5e <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b34080e7          	jalr	-1228(ra) # 5bc6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	6f450513          	addi	a0,a0,1780 # 6790 <malloc+0x774>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	eba080e7          	jalr	-326(ra) # 5f5e <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b18080e7          	jalr	-1256(ra) # 5bc6 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	70850513          	addi	a0,a0,1800 # 67c0 <malloc+0x7a4>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	e9e080e7          	jalr	-354(ra) # 5f5e <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	afc080e7          	jalr	-1284(ra) # 5bc6 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	70450513          	addi	a0,a0,1796 # 67d8 <malloc+0x7bc>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	e82080e7          	jalr	-382(ra) # 5f5e <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	ae0080e7          	jalr	-1312(ra) # 5bc6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	70050513          	addi	a0,a0,1792 # 67f0 <malloc+0x7d4>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	e66080e7          	jalr	-410(ra) # 5f5e <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	ac4080e7          	jalr	-1340(ra) # 5bc6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	70c50513          	addi	a0,a0,1804 # 6818 <malloc+0x7fc>
    1114:	00005097          	auipc	ra,0x5
    1118:	e4a080e7          	jalr	-438(ra) # 5f5e <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	aa8080e7          	jalr	-1368(ra) # 5bc6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	72050513          	addi	a0,a0,1824 # 6848 <malloc+0x82c>
    1130:	00005097          	auipc	ra,0x5
    1134:	e2e080e7          	jalr	-466(ra) # 5f5e <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	a8c080e7          	jalr	-1396(ra) # 5bc6 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	70e98993          	addi	s3,s3,1806 # 6868 <malloc+0x84c>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	ab8080e7          	jalr	-1352(ra) # 5c26 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	6e250513          	addi	a0,a0,1762 # 6878 <malloc+0x85c>
    119e:	00005097          	auipc	ra,0x5
    11a2:	dc0080e7          	jalr	-576(ra) # 5f5e <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a1e080e7          	jalr	-1506(ra) # 5bc6 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	6d250513          	addi	a0,a0,1746 # 6898 <malloc+0x87c>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a48080e7          	jalr	-1464(ra) # 5c16 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	6be50513          	addi	a0,a0,1726 # 6898 <malloc+0x87c>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	a24080e7          	jalr	-1500(ra) # 5c06 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	a00080e7          	jalr	-1536(ra) # 5bee <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	69ca0a13          	addi	s4,s4,1692 # 6898 <malloc+0x87c>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9579b          	sraiw	a5,s2,0x1f
    1210:	01a7d71b          	srliw	a4,a5,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	9ea080e7          	jalr	-1558(ra) # 5c26 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	64a50513          	addi	a0,a0,1610 # 6898 <malloc+0x87c>
    1256:	00005097          	auipc	ra,0x5
    125a:	9c0080e7          	jalr	-1600(ra) # 5c16 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d79b          	sraiw	a5,s1,0x1f
    126e:	01a7d71b          	srliw	a4,a5,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	97e080e7          	jalr	-1666(ra) # 5c16 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	5e250513          	addi	a0,a0,1506 # 68a0 <malloc+0x884>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	c98080e7          	jalr	-872(ra) # 5f5e <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	8f6080e7          	jalr	-1802(ra) # 5bc6 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	5e250513          	addi	a0,a0,1506 # 68c0 <malloc+0x8a4>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	c78080e7          	jalr	-904(ra) # 5f5e <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	8d6080e7          	jalr	-1834(ra) # 5bc6 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	5e650513          	addi	a0,a0,1510 # 68e0 <malloc+0x8c4>
    1302:	00005097          	auipc	ra,0x5
    1306:	c5c080e7          	jalr	-932(ra) # 5f5e <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	8ba080e7          	jalr	-1862(ra) # 5bc6 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00008497          	auipc	s1,0x8
    1326:	cde48493          	addi	s1,s1,-802 # 9000 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	8ce080e7          	jalr	-1842(ra) # 5bfe <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	89c080e7          	jalr	-1892(ra) # 5bd6 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	882080e7          	jalr	-1918(ra) # 5bc6 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1e38>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	df298993          	addi	s3,s3,-526 # 6158 <malloc+0x13c>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	882080e7          	jalr	-1918(ra) # 5bfe <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	83c080e7          	jalr	-1988(ra) # 5bc6 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	85e080e7          	jalr	-1954(ra) # 5c16 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	838080e7          	jalr	-1992(ra) # 5c06 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	844080e7          	jalr	-1980(ra) # 5c26 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	71878793          	addi	a5,a5,1816 # 7b08 <malloc+0x1aec>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00004097          	auipc	ra,0x4
    140c:	7f6080e7          	jalr	2038(ra) # 5bfe <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00004097          	auipc	ra,0x4
    141a:	7a8080e7          	jalr	1960(ra) # 5bbe <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00008797          	auipc	a5,0x8
    142a:	0ea78793          	addi	a5,a5,234 # 9510 <big.0>
    142e:	00009697          	auipc	a3,0x9
    1432:	0e268693          	addi	a3,a3,226 # a510 <big.0+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	00009797          	auipc	a5,0x9
    1448:	0c078623          	sb	zero,204(a5) # a510 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	0c478793          	addi	a5,a5,196 # 8510 <malloc+0x24f4>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	ce850513          	addi	a0,a0,-792 # 6158 <malloc+0x13c>
    1478:	00004097          	auipc	ra,0x4
    147c:	786080e7          	jalr	1926(ra) # 5bfe <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	50050513          	addi	a0,a0,1280 # 6988 <malloc+0x96c>
    1490:	00005097          	auipc	ra,0x5
    1494:	ace080e7          	jalr	-1330(ra) # 5f5e <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	72c080e7          	jalr	1836(ra) # 5bc6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	45850513          	addi	a0,a0,1112 # 6900 <malloc+0x8e4>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	aae080e7          	jalr	-1362(ra) # 5f5e <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	70c080e7          	jalr	1804(ra) # 5bc6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	45850513          	addi	a0,a0,1112 # 6920 <malloc+0x904>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	a8e080e7          	jalr	-1394(ra) # 5f5e <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	6ec080e7          	jalr	1772(ra) # 5bc6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	45650513          	addi	a0,a0,1110 # 6940 <malloc+0x924>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	a6c080e7          	jalr	-1428(ra) # 5f5e <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	6ca080e7          	jalr	1738(ra) # 5bc6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	45e50513          	addi	a0,a0,1118 # 6968 <malloc+0x94c>
    1512:	00005097          	auipc	ra,0x5
    1516:	a4c080e7          	jalr	-1460(ra) # 5f5e <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	6aa080e7          	jalr	1706(ra) # 5bc6 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	89450513          	addi	a0,a0,-1900 # 6db8 <malloc+0xd9c>
    152c:	00005097          	auipc	ra,0x5
    1530:	a32080e7          	jalr	-1486(ra) # 5f5e <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	690080e7          	jalr	1680(ra) # 5bc6 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	684080e7          	jalr	1668(ra) # 5bc6 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	67c080e7          	jalr	1660(ra) # 5bce <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	44250513          	addi	a0,a0,1090 # 69b0 <malloc+0x994>
    1576:	00005097          	auipc	ra,0x5
    157a:	9e8080e7          	jalr	-1560(ra) # 5f5e <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	646080e7          	jalr	1606(ra) # 5bc6 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e8ca                	sd	s2,80(sp)
    1592:	e4ce                	sd	s3,72(sp)
    1594:	e0d2                	sd	s4,64(sp)
    1596:	fc56                	sd	s5,56(sp)
    1598:	1880                	addi	s0,sp,112
    159a:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159c:	60100593          	li	a1,1537
    15a0:	00005517          	auipc	a0,0x5
    15a4:	c1050513          	addi	a0,a0,-1008 # 61b0 <malloc+0x194>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	65e080e7          	jalr	1630(ra) # 5c06 <open>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	63e080e7          	jalr	1598(ra) # 5bee <close>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	606080e7          	jalr	1542(ra) # 5bbe <fork>
  if(pid < 0){
    15c0:	08054063          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15c4:	e969                	bnez	a0,1696 <truncate3+0x10e>
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	be6a0a13          	addi	s4,s4,-1050 # 61b0 <malloc+0x194>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	43ea8a93          	addi	s5,s5,1086 # 6a10 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	628080e7          	jalr	1576(ra) # 5c06 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054a63          	bltz	a0,165c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	5f6080e7          	jalr	1526(ra) # 5be6 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	06f51f63          	bne	a0,a5,1678 <truncate3+0xf0>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	5ee080e7          	jalr	1518(ra) # 5bee <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	5fa080e7          	jalr	1530(ra) # 5c06 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	5c0080e7          	jalr	1472(ra) # 5bde <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	5c6080e7          	jalr	1478(ra) # 5bee <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	58e080e7          	jalr	1422(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	39e50513          	addi	a0,a0,926 # 69e0 <malloc+0x9c4>
    164a:	00005097          	auipc	ra,0x5
    164e:	914080e7          	jalr	-1772(ra) # 5f5e <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	572080e7          	jalr	1394(ra) # 5bc6 <exit>
        printf("%s: open failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	39a50513          	addi	a0,a0,922 # 69f8 <malloc+0x9dc>
    1666:	00005097          	auipc	ra,0x5
    166a:	8f8080e7          	jalr	-1800(ra) # 5f5e <printf>
        exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	556080e7          	jalr	1366(ra) # 5bc6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1678:	862a                	mv	a2,a0
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	3a450513          	addi	a0,a0,932 # 6a20 <malloc+0xa04>
    1684:	00005097          	auipc	ra,0x5
    1688:	8da080e7          	jalr	-1830(ra) # 5f5e <printf>
        exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	538080e7          	jalr	1336(ra) # 5bc6 <exit>
    1696:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    169a:	00005a17          	auipc	s4,0x5
    169e:	b16a0a13          	addi	s4,s4,-1258 # 61b0 <malloc+0x194>
    int n = write(fd, "xxx", 3);
    16a2:	00005a97          	auipc	s5,0x5
    16a6:	39ea8a93          	addi	s5,s5,926 # 6a40 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	60100593          	li	a1,1537
    16ae:	8552                	mv	a0,s4
    16b0:	00004097          	auipc	ra,0x4
    16b4:	556080e7          	jalr	1366(ra) # 5c06 <open>
    16b8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ba:	04054763          	bltz	a0,1708 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16be:	460d                	li	a2,3
    16c0:	85d6                	mv	a1,s5
    16c2:	00004097          	auipc	ra,0x4
    16c6:	524080e7          	jalr	1316(ra) # 5be6 <write>
    if(n != 3){
    16ca:	478d                	li	a5,3
    16cc:	04f51c63          	bne	a0,a5,1724 <truncate3+0x19c>
    close(fd);
    16d0:	8526                	mv	a0,s1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	51c080e7          	jalr	1308(ra) # 5bee <close>
  for(int i = 0; i < 150; i++){
    16da:	39fd                	addiw	s3,s3,-1
    16dc:	fc0997e3          	bnez	s3,16aa <truncate3+0x122>
  wait(&xstatus);
    16e0:	fbc40513          	addi	a0,s0,-68
    16e4:	00004097          	auipc	ra,0x4
    16e8:	4ea080e7          	jalr	1258(ra) # 5bce <wait>
  unlink("truncfile");
    16ec:	00005517          	auipc	a0,0x5
    16f0:	ac450513          	addi	a0,a0,-1340 # 61b0 <malloc+0x194>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	522080e7          	jalr	1314(ra) # 5c16 <unlink>
  exit(xstatus);
    16fc:	fbc42503          	lw	a0,-68(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	4c6080e7          	jalr	1222(ra) # 5bc6 <exit>
      printf("%s: open failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	2ee50513          	addi	a0,a0,750 # 69f8 <malloc+0x9dc>
    1712:	00005097          	auipc	ra,0x5
    1716:	84c080e7          	jalr	-1972(ra) # 5f5e <printf>
      exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	4aa080e7          	jalr	1194(ra) # 5bc6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1724:	862a                	mv	a2,a0
    1726:	85ca                	mv	a1,s2
    1728:	00005517          	auipc	a0,0x5
    172c:	32050513          	addi	a0,a0,800 # 6a48 <malloc+0xa2c>
    1730:	00005097          	auipc	ra,0x5
    1734:	82e080e7          	jalr	-2002(ra) # 5f5e <printf>
      exit(1);
    1738:	4505                	li	a0,1
    173a:	00004097          	auipc	ra,0x4
    173e:	48c080e7          	jalr	1164(ra) # 5bc6 <exit>

0000000000001742 <exectest>:
{
    1742:	715d                	addi	sp,sp,-80
    1744:	e486                	sd	ra,72(sp)
    1746:	e0a2                	sd	s0,64(sp)
    1748:	fc26                	sd	s1,56(sp)
    174a:	f84a                	sd	s2,48(sp)
    174c:	0880                	addi	s0,sp,80
    174e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1750:	00005797          	auipc	a5,0x5
    1754:	a0878793          	addi	a5,a5,-1528 # 6158 <malloc+0x13c>
    1758:	fcf43023          	sd	a5,-64(s0)
    175c:	00005797          	auipc	a5,0x5
    1760:	30c78793          	addi	a5,a5,780 # 6a68 <malloc+0xa4c>
    1764:	fcf43423          	sd	a5,-56(s0)
    1768:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176c:	00005517          	auipc	a0,0x5
    1770:	30450513          	addi	a0,a0,772 # 6a70 <malloc+0xa54>
    1774:	00004097          	auipc	ra,0x4
    1778:	4a2080e7          	jalr	1186(ra) # 5c16 <unlink>
  pid = fork();
    177c:	00004097          	auipc	ra,0x4
    1780:	442080e7          	jalr	1090(ra) # 5bbe <fork>
  if(pid < 0) {
    1784:	04054663          	bltz	a0,17d0 <exectest+0x8e>
    1788:	84aa                	mv	s1,a0
  if(pid == 0) {
    178a:	e959                	bnez	a0,1820 <exectest+0xde>
    close(1);
    178c:	4505                	li	a0,1
    178e:	00004097          	auipc	ra,0x4
    1792:	460080e7          	jalr	1120(ra) # 5bee <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1796:	20100593          	li	a1,513
    179a:	00005517          	auipc	a0,0x5
    179e:	2d650513          	addi	a0,a0,726 # 6a70 <malloc+0xa54>
    17a2:	00004097          	auipc	ra,0x4
    17a6:	464080e7          	jalr	1124(ra) # 5c06 <open>
    if(fd < 0) {
    17aa:	04054163          	bltz	a0,17ec <exectest+0xaa>
    if(fd != 1) {
    17ae:	4785                	li	a5,1
    17b0:	04f50c63          	beq	a0,a5,1808 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b4:	85ca                	mv	a1,s2
    17b6:	00005517          	auipc	a0,0x5
    17ba:	2da50513          	addi	a0,a0,730 # 6a90 <malloc+0xa74>
    17be:	00004097          	auipc	ra,0x4
    17c2:	7a0080e7          	jalr	1952(ra) # 5f5e <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	00004097          	auipc	ra,0x4
    17cc:	3fe080e7          	jalr	1022(ra) # 5bc6 <exit>
     printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	20e50513          	addi	a0,a0,526 # 69e0 <malloc+0x9c4>
    17da:	00004097          	auipc	ra,0x4
    17de:	784080e7          	jalr	1924(ra) # 5f5e <printf>
     exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	3e2080e7          	jalr	994(ra) # 5bc6 <exit>
      printf("%s: create failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	28a50513          	addi	a0,a0,650 # 6a78 <malloc+0xa5c>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	768080e7          	jalr	1896(ra) # 5f5e <printf>
      exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	3c6080e7          	jalr	966(ra) # 5bc6 <exit>
    if(exec("echo", echoargv) < 0){
    1808:	fc040593          	addi	a1,s0,-64
    180c:	00005517          	auipc	a0,0x5
    1810:	94c50513          	addi	a0,a0,-1716 # 6158 <malloc+0x13c>
    1814:	00004097          	auipc	ra,0x4
    1818:	3ea080e7          	jalr	1002(ra) # 5bfe <exec>
    181c:	02054163          	bltz	a0,183e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1820:	fdc40513          	addi	a0,s0,-36
    1824:	00004097          	auipc	ra,0x4
    1828:	3aa080e7          	jalr	938(ra) # 5bce <wait>
    182c:	02951763          	bne	a0,s1,185a <exectest+0x118>
  if(xstatus != 0)
    1830:	fdc42503          	lw	a0,-36(s0)
    1834:	cd0d                	beqz	a0,186e <exectest+0x12c>
    exit(xstatus);
    1836:	00004097          	auipc	ra,0x4
    183a:	390080e7          	jalr	912(ra) # 5bc6 <exit>
      printf("%s: exec echo failed\n", s);
    183e:	85ca                	mv	a1,s2
    1840:	00005517          	auipc	a0,0x5
    1844:	26050513          	addi	a0,a0,608 # 6aa0 <malloc+0xa84>
    1848:	00004097          	auipc	ra,0x4
    184c:	716080e7          	jalr	1814(ra) # 5f5e <printf>
      exit(1);
    1850:	4505                	li	a0,1
    1852:	00004097          	auipc	ra,0x4
    1856:	374080e7          	jalr	884(ra) # 5bc6 <exit>
    printf("%s: wait failed!\n", s);
    185a:	85ca                	mv	a1,s2
    185c:	00005517          	auipc	a0,0x5
    1860:	25c50513          	addi	a0,a0,604 # 6ab8 <malloc+0xa9c>
    1864:	00004097          	auipc	ra,0x4
    1868:	6fa080e7          	jalr	1786(ra) # 5f5e <printf>
    186c:	b7d1                	j	1830 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186e:	4581                	li	a1,0
    1870:	00005517          	auipc	a0,0x5
    1874:	20050513          	addi	a0,a0,512 # 6a70 <malloc+0xa54>
    1878:	00004097          	auipc	ra,0x4
    187c:	38e080e7          	jalr	910(ra) # 5c06 <open>
  if(fd < 0) {
    1880:	02054a63          	bltz	a0,18b4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1884:	4609                	li	a2,2
    1886:	fb840593          	addi	a1,s0,-72
    188a:	00004097          	auipc	ra,0x4
    188e:	354080e7          	jalr	852(ra) # 5bde <read>
    1892:	4789                	li	a5,2
    1894:	02f50e63          	beq	a0,a5,18d0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1898:	85ca                	mv	a1,s2
    189a:	00005517          	auipc	a0,0x5
    189e:	c8e50513          	addi	a0,a0,-882 # 6528 <malloc+0x50c>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	6bc080e7          	jalr	1724(ra) # 5f5e <printf>
    exit(1);
    18aa:	4505                	li	a0,1
    18ac:	00004097          	auipc	ra,0x4
    18b0:	31a080e7          	jalr	794(ra) # 5bc6 <exit>
    printf("%s: open failed\n", s);
    18b4:	85ca                	mv	a1,s2
    18b6:	00005517          	auipc	a0,0x5
    18ba:	14250513          	addi	a0,a0,322 # 69f8 <malloc+0x9dc>
    18be:	00004097          	auipc	ra,0x4
    18c2:	6a0080e7          	jalr	1696(ra) # 5f5e <printf>
    exit(1);
    18c6:	4505                	li	a0,1
    18c8:	00004097          	auipc	ra,0x4
    18cc:	2fe080e7          	jalr	766(ra) # 5bc6 <exit>
  unlink("echo-ok");
    18d0:	00005517          	auipc	a0,0x5
    18d4:	1a050513          	addi	a0,a0,416 # 6a70 <malloc+0xa54>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	33e080e7          	jalr	830(ra) # 5c16 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e0:	fb844703          	lbu	a4,-72(s0)
    18e4:	04f00793          	li	a5,79
    18e8:	00f71863          	bne	a4,a5,18f8 <exectest+0x1b6>
    18ec:	fb944703          	lbu	a4,-71(s0)
    18f0:	04b00793          	li	a5,75
    18f4:	02f70063          	beq	a4,a5,1914 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f8:	85ca                	mv	a1,s2
    18fa:	00005517          	auipc	a0,0x5
    18fe:	1d650513          	addi	a0,a0,470 # 6ad0 <malloc+0xab4>
    1902:	00004097          	auipc	ra,0x4
    1906:	65c080e7          	jalr	1628(ra) # 5f5e <printf>
    exit(1);
    190a:	4505                	li	a0,1
    190c:	00004097          	auipc	ra,0x4
    1910:	2ba080e7          	jalr	698(ra) # 5bc6 <exit>
    exit(0);
    1914:	4501                	li	a0,0
    1916:	00004097          	auipc	ra,0x4
    191a:	2b0080e7          	jalr	688(ra) # 5bc6 <exit>

000000000000191e <pipe1>:
{
    191e:	711d                	addi	sp,sp,-96
    1920:	ec86                	sd	ra,88(sp)
    1922:	e8a2                	sd	s0,80(sp)
    1924:	e4a6                	sd	s1,72(sp)
    1926:	e0ca                	sd	s2,64(sp)
    1928:	fc4e                	sd	s3,56(sp)
    192a:	f852                	sd	s4,48(sp)
    192c:	f456                	sd	s5,40(sp)
    192e:	f05a                	sd	s6,32(sp)
    1930:	ec5e                	sd	s7,24(sp)
    1932:	1080                	addi	s0,sp,96
    1934:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1936:	fa840513          	addi	a0,s0,-88
    193a:	00004097          	auipc	ra,0x4
    193e:	29c080e7          	jalr	668(ra) # 5bd6 <pipe>
    1942:	ed25                	bnez	a0,19ba <pipe1+0x9c>
    1944:	84aa                	mv	s1,a0
  pid = fork();
    1946:	00004097          	auipc	ra,0x4
    194a:	278080e7          	jalr	632(ra) # 5bbe <fork>
    194e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1950:	c159                	beqz	a0,19d6 <pipe1+0xb8>
  } else if(pid > 0){
    1952:	16a05e63          	blez	a0,1ace <pipe1+0x1b0>
    close(fds[1]);
    1956:	fac42503          	lw	a0,-84(s0)
    195a:	00004097          	auipc	ra,0x4
    195e:	294080e7          	jalr	660(ra) # 5bee <close>
    total = 0;
    1962:	8a26                	mv	s4,s1
    cc = 1;
    1964:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1966:	0000ba97          	auipc	s5,0xb
    196a:	2c2a8a93          	addi	s5,s5,706 # cc28 <buf>
      if(cc > sizeof(buf))
    196e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1970:	864e                	mv	a2,s3
    1972:	85d6                	mv	a1,s5
    1974:	fa842503          	lw	a0,-88(s0)
    1978:	00004097          	auipc	ra,0x4
    197c:	266080e7          	jalr	614(ra) # 5bde <read>
    1980:	10a05263          	blez	a0,1a84 <pipe1+0x166>
      for(i = 0; i < n; i++){
    1984:	0000b717          	auipc	a4,0xb
    1988:	2a470713          	addi	a4,a4,676 # cc28 <buf>
    198c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1990:	00074683          	lbu	a3,0(a4)
    1994:	0ff4f793          	zext.b	a5,s1
    1998:	2485                	addiw	s1,s1,1
    199a:	0cf69163          	bne	a3,a5,1a5c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    199e:	0705                	addi	a4,a4,1
    19a0:	fec498e3          	bne	s1,a2,1990 <pipe1+0x72>
      total += n;
    19a4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a8:	0019979b          	slliw	a5,s3,0x1
    19ac:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b0:	013b7363          	bgeu	s6,s3,19b6 <pipe1+0x98>
        cc = sizeof(buf);
    19b4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19b6:	84b2                	mv	s1,a2
    19b8:	bf65                	j	1970 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19ba:	85ca                	mv	a1,s2
    19bc:	00005517          	auipc	a0,0x5
    19c0:	12c50513          	addi	a0,a0,300 # 6ae8 <malloc+0xacc>
    19c4:	00004097          	auipc	ra,0x4
    19c8:	59a080e7          	jalr	1434(ra) # 5f5e <printf>
    exit(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	1f8080e7          	jalr	504(ra) # 5bc6 <exit>
    close(fds[0]);
    19d6:	fa842503          	lw	a0,-88(s0)
    19da:	00004097          	auipc	ra,0x4
    19de:	214080e7          	jalr	532(ra) # 5bee <close>
    for(n = 0; n < N; n++){
    19e2:	0000bb17          	auipc	s6,0xb
    19e6:	246b0b13          	addi	s6,s6,582 # cc28 <buf>
    19ea:	416004bb          	negw	s1,s6
    19ee:	0ff4f493          	zext.b	s1,s1
    19f2:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f6:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f8:	6a85                	lui	s5,0x1
    19fa:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    19fe:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a00:	0097873b          	addw	a4,a5,s1
    1a04:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a08:	0785                	addi	a5,a5,1
    1a0a:	fef99be3          	bne	s3,a5,1a00 <pipe1+0xe2>
        buf[i] = seq++;
    1a0e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a12:	40900613          	li	a2,1033
    1a16:	85de                	mv	a1,s7
    1a18:	fac42503          	lw	a0,-84(s0)
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	1ca080e7          	jalr	458(ra) # 5be6 <write>
    1a24:	40900793          	li	a5,1033
    1a28:	00f51c63          	bne	a0,a5,1a40 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a2c:	24a5                	addiw	s1,s1,9
    1a2e:	0ff4f493          	zext.b	s1,s1
    1a32:	fd5a16e3          	bne	s4,s5,19fe <pipe1+0xe0>
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	00004097          	auipc	ra,0x4
    1a3c:	18e080e7          	jalr	398(ra) # 5bc6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a40:	85ca                	mv	a1,s2
    1a42:	00005517          	auipc	a0,0x5
    1a46:	0be50513          	addi	a0,a0,190 # 6b00 <malloc+0xae4>
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	514080e7          	jalr	1300(ra) # 5f5e <printf>
        exit(1);
    1a52:	4505                	li	a0,1
    1a54:	00004097          	auipc	ra,0x4
    1a58:	172080e7          	jalr	370(ra) # 5bc6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a5c:	85ca                	mv	a1,s2
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	0ba50513          	addi	a0,a0,186 # 6b18 <malloc+0xafc>
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	4f8080e7          	jalr	1272(ra) # 5f5e <printf>
}
    1a6e:	60e6                	ld	ra,88(sp)
    1a70:	6446                	ld	s0,80(sp)
    1a72:	64a6                	ld	s1,72(sp)
    1a74:	6906                	ld	s2,64(sp)
    1a76:	79e2                	ld	s3,56(sp)
    1a78:	7a42                	ld	s4,48(sp)
    1a7a:	7aa2                	ld	s5,40(sp)
    1a7c:	7b02                	ld	s6,32(sp)
    1a7e:	6be2                	ld	s7,24(sp)
    1a80:	6125                	addi	sp,sp,96
    1a82:	8082                	ret
    if(total != N * SZ){
    1a84:	6785                	lui	a5,0x1
    1a86:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1a8a:	02fa0063          	beq	s4,a5,1aaa <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8e:	85d2                	mv	a1,s4
    1a90:	00005517          	auipc	a0,0x5
    1a94:	0a050513          	addi	a0,a0,160 # 6b30 <malloc+0xb14>
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	4c6080e7          	jalr	1222(ra) # 5f5e <printf>
      exit(1);
    1aa0:	4505                	li	a0,1
    1aa2:	00004097          	auipc	ra,0x4
    1aa6:	124080e7          	jalr	292(ra) # 5bc6 <exit>
    close(fds[0]);
    1aaa:	fa842503          	lw	a0,-88(s0)
    1aae:	00004097          	auipc	ra,0x4
    1ab2:	140080e7          	jalr	320(ra) # 5bee <close>
    wait(&xstatus);
    1ab6:	fa440513          	addi	a0,s0,-92
    1aba:	00004097          	auipc	ra,0x4
    1abe:	114080e7          	jalr	276(ra) # 5bce <wait>
    exit(xstatus);
    1ac2:	fa442503          	lw	a0,-92(s0)
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	100080e7          	jalr	256(ra) # 5bc6 <exit>
    printf("%s: fork() failed\n", s);
    1ace:	85ca                	mv	a1,s2
    1ad0:	00005517          	auipc	a0,0x5
    1ad4:	08050513          	addi	a0,a0,128 # 6b50 <malloc+0xb34>
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	486080e7          	jalr	1158(ra) # 5f5e <printf>
    exit(1);
    1ae0:	4505                	li	a0,1
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	0e4080e7          	jalr	228(ra) # 5bc6 <exit>

0000000000001aea <exitwait>:
{
    1aea:	7139                	addi	sp,sp,-64
    1aec:	fc06                	sd	ra,56(sp)
    1aee:	f822                	sd	s0,48(sp)
    1af0:	f426                	sd	s1,40(sp)
    1af2:	f04a                	sd	s2,32(sp)
    1af4:	ec4e                	sd	s3,24(sp)
    1af6:	e852                	sd	s4,16(sp)
    1af8:	0080                	addi	s0,sp,64
    1afa:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1afc:	4901                	li	s2,0
    1afe:	06400993          	li	s3,100
    pid = fork();
    1b02:	00004097          	auipc	ra,0x4
    1b06:	0bc080e7          	jalr	188(ra) # 5bbe <fork>
    1b0a:	84aa                	mv	s1,a0
    if(pid < 0){
    1b0c:	02054a63          	bltz	a0,1b40 <exitwait+0x56>
    if(pid){
    1b10:	c151                	beqz	a0,1b94 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b12:	fcc40513          	addi	a0,s0,-52
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	0b8080e7          	jalr	184(ra) # 5bce <wait>
    1b1e:	02951f63          	bne	a0,s1,1b5c <exitwait+0x72>
      if(i != xstate) {
    1b22:	fcc42783          	lw	a5,-52(s0)
    1b26:	05279963          	bne	a5,s2,1b78 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b2a:	2905                	addiw	s2,s2,1
    1b2c:	fd391be3          	bne	s2,s3,1b02 <exitwait+0x18>
}
    1b30:	70e2                	ld	ra,56(sp)
    1b32:	7442                	ld	s0,48(sp)
    1b34:	74a2                	ld	s1,40(sp)
    1b36:	7902                	ld	s2,32(sp)
    1b38:	69e2                	ld	s3,24(sp)
    1b3a:	6a42                	ld	s4,16(sp)
    1b3c:	6121                	addi	sp,sp,64
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85d2                	mv	a1,s4
    1b42:	00005517          	auipc	a0,0x5
    1b46:	e9e50513          	addi	a0,a0,-354 # 69e0 <malloc+0x9c4>
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	414080e7          	jalr	1044(ra) # 5f5e <printf>
      exit(1);
    1b52:	4505                	li	a0,1
    1b54:	00004097          	auipc	ra,0x4
    1b58:	072080e7          	jalr	114(ra) # 5bc6 <exit>
        printf("%s: wait wrong pid\n", s);
    1b5c:	85d2                	mv	a1,s4
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	00a50513          	addi	a0,a0,10 # 6b68 <malloc+0xb4c>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	3f8080e7          	jalr	1016(ra) # 5f5e <printf>
        exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	056080e7          	jalr	86(ra) # 5bc6 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b78:	85d2                	mv	a1,s4
    1b7a:	00005517          	auipc	a0,0x5
    1b7e:	00650513          	addi	a0,a0,6 # 6b80 <malloc+0xb64>
    1b82:	00004097          	auipc	ra,0x4
    1b86:	3dc080e7          	jalr	988(ra) # 5f5e <printf>
        exit(1);
    1b8a:	4505                	li	a0,1
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	03a080e7          	jalr	58(ra) # 5bc6 <exit>
      exit(i);
    1b94:	854a                	mv	a0,s2
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	030080e7          	jalr	48(ra) # 5bc6 <exit>

0000000000001b9e <createdelete>:
{
    1b9e:	7175                	addi	sp,sp,-144
    1ba0:	e506                	sd	ra,136(sp)
    1ba2:	e122                	sd	s0,128(sp)
    1ba4:	fca6                	sd	s1,120(sp)
    1ba6:	f8ca                	sd	s2,112(sp)
    1ba8:	f4ce                	sd	s3,104(sp)
    1baa:	f0d2                	sd	s4,96(sp)
    1bac:	ecd6                	sd	s5,88(sp)
    1bae:	e8da                	sd	s6,80(sp)
    1bb0:	e4de                	sd	s7,72(sp)
    1bb2:	e0e2                	sd	s8,64(sp)
    1bb4:	fc66                	sd	s9,56(sp)
    1bb6:	0900                	addi	s0,sp,144
    1bb8:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bba:	4901                	li	s2,0
    1bbc:	4991                	li	s3,4
    pid = fork();
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	000080e7          	jalr	ra # 5bbe <fork>
    1bc6:	84aa                	mv	s1,a0
    if(pid < 0){
    1bc8:	02054f63          	bltz	a0,1c06 <createdelete+0x68>
    if(pid == 0){
    1bcc:	c939                	beqz	a0,1c22 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bce:	2905                	addiw	s2,s2,1
    1bd0:	ff3917e3          	bne	s2,s3,1bbe <createdelete+0x20>
    1bd4:	4491                	li	s1,4
    wait(&xstatus);
    1bd6:	f7c40513          	addi	a0,s0,-132
    1bda:	00004097          	auipc	ra,0x4
    1bde:	ff4080e7          	jalr	-12(ra) # 5bce <wait>
    if(xstatus != 0)
    1be2:	f7c42903          	lw	s2,-132(s0)
    1be6:	0e091263          	bnez	s2,1cca <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bea:	34fd                	addiw	s1,s1,-1
    1bec:	f4ed                	bnez	s1,1bd6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bee:	f8040123          	sb	zero,-126(s0)
    1bf2:	03000993          	li	s3,48
    1bf6:	5a7d                	li	s4,-1
    1bf8:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bfc:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bfe:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1c00:	07400a93          	li	s5,116
    1c04:	a29d                	j	1d6a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1c06:	85e6                	mv	a1,s9
    1c08:	00005517          	auipc	a0,0x5
    1c0c:	1b050513          	addi	a0,a0,432 # 6db8 <malloc+0xd9c>
    1c10:	00004097          	auipc	ra,0x4
    1c14:	34e080e7          	jalr	846(ra) # 5f5e <printf>
      exit(1);
    1c18:	4505                	li	a0,1
    1c1a:	00004097          	auipc	ra,0x4
    1c1e:	fac080e7          	jalr	-84(ra) # 5bc6 <exit>
      name[0] = 'p' + pi;
    1c22:	0709091b          	addiw	s2,s2,112
    1c26:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c2a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c2e:	4951                	li	s2,20
    1c30:	a015                	j	1c54 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c32:	85e6                	mv	a1,s9
    1c34:	00005517          	auipc	a0,0x5
    1c38:	e4450513          	addi	a0,a0,-444 # 6a78 <malloc+0xa5c>
    1c3c:	00004097          	auipc	ra,0x4
    1c40:	322080e7          	jalr	802(ra) # 5f5e <printf>
          exit(1);
    1c44:	4505                	li	a0,1
    1c46:	00004097          	auipc	ra,0x4
    1c4a:	f80080e7          	jalr	-128(ra) # 5bc6 <exit>
      for(i = 0; i < N; i++){
    1c4e:	2485                	addiw	s1,s1,1
    1c50:	07248863          	beq	s1,s2,1cc0 <createdelete+0x122>
        name[1] = '0' + i;
    1c54:	0304879b          	addiw	a5,s1,48
    1c58:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c5c:	20200593          	li	a1,514
    1c60:	f8040513          	addi	a0,s0,-128
    1c64:	00004097          	auipc	ra,0x4
    1c68:	fa2080e7          	jalr	-94(ra) # 5c06 <open>
        if(fd < 0){
    1c6c:	fc0543e3          	bltz	a0,1c32 <createdelete+0x94>
        close(fd);
    1c70:	00004097          	auipc	ra,0x4
    1c74:	f7e080e7          	jalr	-130(ra) # 5bee <close>
        if(i > 0 && (i % 2 ) == 0){
    1c78:	fc905be3          	blez	s1,1c4e <createdelete+0xb0>
    1c7c:	0014f793          	andi	a5,s1,1
    1c80:	f7f9                	bnez	a5,1c4e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c82:	01f4d79b          	srliw	a5,s1,0x1f
    1c86:	9fa5                	addw	a5,a5,s1
    1c88:	4017d79b          	sraiw	a5,a5,0x1
    1c8c:	0307879b          	addiw	a5,a5,48
    1c90:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c94:	f8040513          	addi	a0,s0,-128
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	f7e080e7          	jalr	-130(ra) # 5c16 <unlink>
    1ca0:	fa0557e3          	bgez	a0,1c4e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1ca4:	85e6                	mv	a1,s9
    1ca6:	00005517          	auipc	a0,0x5
    1caa:	efa50513          	addi	a0,a0,-262 # 6ba0 <malloc+0xb84>
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	2b0080e7          	jalr	688(ra) # 5f5e <printf>
            exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	f0e080e7          	jalr	-242(ra) # 5bc6 <exit>
      exit(0);
    1cc0:	4501                	li	a0,0
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	f04080e7          	jalr	-252(ra) # 5bc6 <exit>
      exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	efa080e7          	jalr	-262(ra) # 5bc6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cd4:	f8040613          	addi	a2,s0,-128
    1cd8:	85e6                	mv	a1,s9
    1cda:	00005517          	auipc	a0,0x5
    1cde:	ede50513          	addi	a0,a0,-290 # 6bb8 <malloc+0xb9c>
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	27c080e7          	jalr	636(ra) # 5f5e <printf>
        exit(1);
    1cea:	4505                	li	a0,1
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	eda080e7          	jalr	-294(ra) # 5bc6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cf4:	054b7163          	bgeu	s6,s4,1d36 <createdelete+0x198>
      if(fd >= 0)
    1cf8:	02055a63          	bgez	a0,1d2c <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cfc:	2485                	addiw	s1,s1,1
    1cfe:	0ff4f493          	zext.b	s1,s1
    1d02:	05548c63          	beq	s1,s5,1d5a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1d06:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d0a:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d0e:	4581                	li	a1,0
    1d10:	f8040513          	addi	a0,s0,-128
    1d14:	00004097          	auipc	ra,0x4
    1d18:	ef2080e7          	jalr	-270(ra) # 5c06 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d1c:	00090463          	beqz	s2,1d24 <createdelete+0x186>
    1d20:	fd2bdae3          	bge	s7,s2,1cf4 <createdelete+0x156>
    1d24:	fa0548e3          	bltz	a0,1cd4 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d28:	014b7963          	bgeu	s6,s4,1d3a <createdelete+0x19c>
        close(fd);
    1d2c:	00004097          	auipc	ra,0x4
    1d30:	ec2080e7          	jalr	-318(ra) # 5bee <close>
    1d34:	b7e1                	j	1cfc <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d36:	fc0543e3          	bltz	a0,1cfc <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d3a:	f8040613          	addi	a2,s0,-128
    1d3e:	85e6                	mv	a1,s9
    1d40:	00005517          	auipc	a0,0x5
    1d44:	ea050513          	addi	a0,a0,-352 # 6be0 <malloc+0xbc4>
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	216080e7          	jalr	534(ra) # 5f5e <printf>
        exit(1);
    1d50:	4505                	li	a0,1
    1d52:	00004097          	auipc	ra,0x4
    1d56:	e74080e7          	jalr	-396(ra) # 5bc6 <exit>
  for(i = 0; i < N; i++){
    1d5a:	2905                	addiw	s2,s2,1
    1d5c:	2a05                	addiw	s4,s4,1
    1d5e:	2985                	addiw	s3,s3,1
    1d60:	0ff9f993          	zext.b	s3,s3
    1d64:	47d1                	li	a5,20
    1d66:	02f90a63          	beq	s2,a5,1d9a <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d6a:	84e2                	mv	s1,s8
    1d6c:	bf69                	j	1d06 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d6e:	2905                	addiw	s2,s2,1
    1d70:	0ff97913          	zext.b	s2,s2
    1d74:	2985                	addiw	s3,s3,1
    1d76:	0ff9f993          	zext.b	s3,s3
    1d7a:	03490863          	beq	s2,s4,1daa <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d7e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d80:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d84:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d88:	f8040513          	addi	a0,s0,-128
    1d8c:	00004097          	auipc	ra,0x4
    1d90:	e8a080e7          	jalr	-374(ra) # 5c16 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d94:	34fd                	addiw	s1,s1,-1
    1d96:	f4ed                	bnez	s1,1d80 <createdelete+0x1e2>
    1d98:	bfd9                	j	1d6e <createdelete+0x1d0>
    1d9a:	03000993          	li	s3,48
    1d9e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1da2:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1da4:	08400a13          	li	s4,132
    1da8:	bfd9                	j	1d7e <createdelete+0x1e0>
}
    1daa:	60aa                	ld	ra,136(sp)
    1dac:	640a                	ld	s0,128(sp)
    1dae:	74e6                	ld	s1,120(sp)
    1db0:	7946                	ld	s2,112(sp)
    1db2:	79a6                	ld	s3,104(sp)
    1db4:	7a06                	ld	s4,96(sp)
    1db6:	6ae6                	ld	s5,88(sp)
    1db8:	6b46                	ld	s6,80(sp)
    1dba:	6ba6                	ld	s7,72(sp)
    1dbc:	6c06                	ld	s8,64(sp)
    1dbe:	7ce2                	ld	s9,56(sp)
    1dc0:	6149                	addi	sp,sp,144
    1dc2:	8082                	ret

0000000000001dc4 <linkunlink>:
{
    1dc4:	711d                	addi	sp,sp,-96
    1dc6:	ec86                	sd	ra,88(sp)
    1dc8:	e8a2                	sd	s0,80(sp)
    1dca:	e4a6                	sd	s1,72(sp)
    1dcc:	e0ca                	sd	s2,64(sp)
    1dce:	fc4e                	sd	s3,56(sp)
    1dd0:	f852                	sd	s4,48(sp)
    1dd2:	f456                	sd	s5,40(sp)
    1dd4:	f05a                	sd	s6,32(sp)
    1dd6:	ec5e                	sd	s7,24(sp)
    1dd8:	e862                	sd	s8,16(sp)
    1dda:	e466                	sd	s9,8(sp)
    1ddc:	1080                	addi	s0,sp,96
    1dde:	84aa                	mv	s1,a0
  unlink("x");
    1de0:	00004517          	auipc	a0,0x4
    1de4:	3e850513          	addi	a0,a0,1000 # 61c8 <malloc+0x1ac>
    1de8:	00004097          	auipc	ra,0x4
    1dec:	e2e080e7          	jalr	-466(ra) # 5c16 <unlink>
  pid = fork();
    1df0:	00004097          	auipc	ra,0x4
    1df4:	dce080e7          	jalr	-562(ra) # 5bbe <fork>
  if(pid < 0){
    1df8:	02054b63          	bltz	a0,1e2e <linkunlink+0x6a>
    1dfc:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dfe:	4c85                	li	s9,1
    1e00:	e119                	bnez	a0,1e06 <linkunlink+0x42>
    1e02:	06100c93          	li	s9,97
    1e06:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e0a:	41c659b7          	lui	s3,0x41c65
    1e0e:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c55245>
    1e12:	690d                	lui	s2,0x3
    1e14:	0399091b          	addiw	s2,s2,57 # 3039 <diskfull+0x3d>
    if((x % 3) == 0){
    1e18:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e1a:	4b05                	li	s6,1
      unlink("x");
    1e1c:	00004a97          	auipc	s5,0x4
    1e20:	3aca8a93          	addi	s5,s5,940 # 61c8 <malloc+0x1ac>
      link("cat", "x");
    1e24:	00005b97          	auipc	s7,0x5
    1e28:	de4b8b93          	addi	s7,s7,-540 # 6c08 <malloc+0xbec>
    1e2c:	a825                	j	1e64 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e2e:	85a6                	mv	a1,s1
    1e30:	00005517          	auipc	a0,0x5
    1e34:	bb050513          	addi	a0,a0,-1104 # 69e0 <malloc+0x9c4>
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	126080e7          	jalr	294(ra) # 5f5e <printf>
    exit(1);
    1e40:	4505                	li	a0,1
    1e42:	00004097          	auipc	ra,0x4
    1e46:	d84080e7          	jalr	-636(ra) # 5bc6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e4a:	20200593          	li	a1,514
    1e4e:	8556                	mv	a0,s5
    1e50:	00004097          	auipc	ra,0x4
    1e54:	db6080e7          	jalr	-586(ra) # 5c06 <open>
    1e58:	00004097          	auipc	ra,0x4
    1e5c:	d96080e7          	jalr	-618(ra) # 5bee <close>
  for(i = 0; i < 100; i++){
    1e60:	34fd                	addiw	s1,s1,-1
    1e62:	c88d                	beqz	s1,1e94 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e64:	033c87bb          	mulw	a5,s9,s3
    1e68:	012787bb          	addw	a5,a5,s2
    1e6c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e70:	0347f7bb          	remuw	a5,a5,s4
    1e74:	dbf9                	beqz	a5,1e4a <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e76:	01678863          	beq	a5,s6,1e86 <linkunlink+0xc2>
      unlink("x");
    1e7a:	8556                	mv	a0,s5
    1e7c:	00004097          	auipc	ra,0x4
    1e80:	d9a080e7          	jalr	-614(ra) # 5c16 <unlink>
    1e84:	bff1                	j	1e60 <linkunlink+0x9c>
      link("cat", "x");
    1e86:	85d6                	mv	a1,s5
    1e88:	855e                	mv	a0,s7
    1e8a:	00004097          	auipc	ra,0x4
    1e8e:	d9c080e7          	jalr	-612(ra) # 5c26 <link>
    1e92:	b7f9                	j	1e60 <linkunlink+0x9c>
  if(pid)
    1e94:	020c0463          	beqz	s8,1ebc <linkunlink+0xf8>
    wait(0);
    1e98:	4501                	li	a0,0
    1e9a:	00004097          	auipc	ra,0x4
    1e9e:	d34080e7          	jalr	-716(ra) # 5bce <wait>
}
    1ea2:	60e6                	ld	ra,88(sp)
    1ea4:	6446                	ld	s0,80(sp)
    1ea6:	64a6                	ld	s1,72(sp)
    1ea8:	6906                	ld	s2,64(sp)
    1eaa:	79e2                	ld	s3,56(sp)
    1eac:	7a42                	ld	s4,48(sp)
    1eae:	7aa2                	ld	s5,40(sp)
    1eb0:	7b02                	ld	s6,32(sp)
    1eb2:	6be2                	ld	s7,24(sp)
    1eb4:	6c42                	ld	s8,16(sp)
    1eb6:	6ca2                	ld	s9,8(sp)
    1eb8:	6125                	addi	sp,sp,96
    1eba:	8082                	ret
    exit(0);
    1ebc:	4501                	li	a0,0
    1ebe:	00004097          	auipc	ra,0x4
    1ec2:	d08080e7          	jalr	-760(ra) # 5bc6 <exit>

0000000000001ec6 <forktest>:
{
    1ec6:	7179                	addi	sp,sp,-48
    1ec8:	f406                	sd	ra,40(sp)
    1eca:	f022                	sd	s0,32(sp)
    1ecc:	ec26                	sd	s1,24(sp)
    1ece:	e84a                	sd	s2,16(sp)
    1ed0:	e44e                	sd	s3,8(sp)
    1ed2:	1800                	addi	s0,sp,48
    1ed4:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ed6:	4481                	li	s1,0
    1ed8:	3e800913          	li	s2,1000
    pid = fork();
    1edc:	00004097          	auipc	ra,0x4
    1ee0:	ce2080e7          	jalr	-798(ra) # 5bbe <fork>
    if(pid < 0)
    1ee4:	02054863          	bltz	a0,1f14 <forktest+0x4e>
    if(pid == 0)
    1ee8:	c115                	beqz	a0,1f0c <forktest+0x46>
  for(n=0; n<N; n++){
    1eea:	2485                	addiw	s1,s1,1
    1eec:	ff2498e3          	bne	s1,s2,1edc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ef0:	85ce                	mv	a1,s3
    1ef2:	00005517          	auipc	a0,0x5
    1ef6:	d3650513          	addi	a0,a0,-714 # 6c28 <malloc+0xc0c>
    1efa:	00004097          	auipc	ra,0x4
    1efe:	064080e7          	jalr	100(ra) # 5f5e <printf>
    exit(1);
    1f02:	4505                	li	a0,1
    1f04:	00004097          	auipc	ra,0x4
    1f08:	cc2080e7          	jalr	-830(ra) # 5bc6 <exit>
      exit(0);
    1f0c:	00004097          	auipc	ra,0x4
    1f10:	cba080e7          	jalr	-838(ra) # 5bc6 <exit>
  if (n == 0) {
    1f14:	cc9d                	beqz	s1,1f52 <forktest+0x8c>
  if(n == N){
    1f16:	3e800793          	li	a5,1000
    1f1a:	fcf48be3          	beq	s1,a5,1ef0 <forktest+0x2a>
  for(; n > 0; n--){
    1f1e:	00905b63          	blez	s1,1f34 <forktest+0x6e>
    if(wait(0) < 0){
    1f22:	4501                	li	a0,0
    1f24:	00004097          	auipc	ra,0x4
    1f28:	caa080e7          	jalr	-854(ra) # 5bce <wait>
    1f2c:	04054163          	bltz	a0,1f6e <forktest+0xa8>
  for(; n > 0; n--){
    1f30:	34fd                	addiw	s1,s1,-1
    1f32:	f8e5                	bnez	s1,1f22 <forktest+0x5c>
  if(wait(0) != -1){
    1f34:	4501                	li	a0,0
    1f36:	00004097          	auipc	ra,0x4
    1f3a:	c98080e7          	jalr	-872(ra) # 5bce <wait>
    1f3e:	57fd                	li	a5,-1
    1f40:	04f51563          	bne	a0,a5,1f8a <forktest+0xc4>
}
    1f44:	70a2                	ld	ra,40(sp)
    1f46:	7402                	ld	s0,32(sp)
    1f48:	64e2                	ld	s1,24(sp)
    1f4a:	6942                	ld	s2,16(sp)
    1f4c:	69a2                	ld	s3,8(sp)
    1f4e:	6145                	addi	sp,sp,48
    1f50:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f52:	85ce                	mv	a1,s3
    1f54:	00005517          	auipc	a0,0x5
    1f58:	cbc50513          	addi	a0,a0,-836 # 6c10 <malloc+0xbf4>
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	002080e7          	jalr	2(ra) # 5f5e <printf>
    exit(1);
    1f64:	4505                	li	a0,1
    1f66:	00004097          	auipc	ra,0x4
    1f6a:	c60080e7          	jalr	-928(ra) # 5bc6 <exit>
      printf("%s: wait stopped early\n", s);
    1f6e:	85ce                	mv	a1,s3
    1f70:	00005517          	auipc	a0,0x5
    1f74:	ce050513          	addi	a0,a0,-800 # 6c50 <malloc+0xc34>
    1f78:	00004097          	auipc	ra,0x4
    1f7c:	fe6080e7          	jalr	-26(ra) # 5f5e <printf>
      exit(1);
    1f80:	4505                	li	a0,1
    1f82:	00004097          	auipc	ra,0x4
    1f86:	c44080e7          	jalr	-956(ra) # 5bc6 <exit>
    printf("%s: wait got too many\n", s);
    1f8a:	85ce                	mv	a1,s3
    1f8c:	00005517          	auipc	a0,0x5
    1f90:	cdc50513          	addi	a0,a0,-804 # 6c68 <malloc+0xc4c>
    1f94:	00004097          	auipc	ra,0x4
    1f98:	fca080e7          	jalr	-54(ra) # 5f5e <printf>
    exit(1);
    1f9c:	4505                	li	a0,1
    1f9e:	00004097          	auipc	ra,0x4
    1fa2:	c28080e7          	jalr	-984(ra) # 5bc6 <exit>

0000000000001fa6 <kernmem>:
{
    1fa6:	715d                	addi	sp,sp,-80
    1fa8:	e486                	sd	ra,72(sp)
    1faa:	e0a2                	sd	s0,64(sp)
    1fac:	fc26                	sd	s1,56(sp)
    1fae:	f84a                	sd	s2,48(sp)
    1fb0:	f44e                	sd	s3,40(sp)
    1fb2:	f052                	sd	s4,32(sp)
    1fb4:	ec56                	sd	s5,24(sp)
    1fb6:	0880                	addi	s0,sp,80
    1fb8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fba:	4485                	li	s1,1
    1fbc:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fbe:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fc0:	69b1                	lui	s3,0xc
    1fc2:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1e38>
    1fc6:	1003d937          	lui	s2,0x1003d
    1fca:	090e                	slli	s2,s2,0x3
    1fcc:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d858>
    pid = fork();
    1fd0:	00004097          	auipc	ra,0x4
    1fd4:	bee080e7          	jalr	-1042(ra) # 5bbe <fork>
    if(pid < 0){
    1fd8:	02054963          	bltz	a0,200a <kernmem+0x64>
    if(pid == 0){
    1fdc:	c529                	beqz	a0,2026 <kernmem+0x80>
    wait(&xstatus);
    1fde:	fbc40513          	addi	a0,s0,-68
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	bec080e7          	jalr	-1044(ra) # 5bce <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fea:	fbc42783          	lw	a5,-68(s0)
    1fee:	05579d63          	bne	a5,s5,2048 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ff2:	94ce                	add	s1,s1,s3
    1ff4:	fd249ee3          	bne	s1,s2,1fd0 <kernmem+0x2a>
}
    1ff8:	60a6                	ld	ra,72(sp)
    1ffa:	6406                	ld	s0,64(sp)
    1ffc:	74e2                	ld	s1,56(sp)
    1ffe:	7942                	ld	s2,48(sp)
    2000:	79a2                	ld	s3,40(sp)
    2002:	7a02                	ld	s4,32(sp)
    2004:	6ae2                	ld	s5,24(sp)
    2006:	6161                	addi	sp,sp,80
    2008:	8082                	ret
      printf("%s: fork failed\n", s);
    200a:	85d2                	mv	a1,s4
    200c:	00005517          	auipc	a0,0x5
    2010:	9d450513          	addi	a0,a0,-1580 # 69e0 <malloc+0x9c4>
    2014:	00004097          	auipc	ra,0x4
    2018:	f4a080e7          	jalr	-182(ra) # 5f5e <printf>
      exit(1);
    201c:	4505                	li	a0,1
    201e:	00004097          	auipc	ra,0x4
    2022:	ba8080e7          	jalr	-1112(ra) # 5bc6 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2026:	0004c683          	lbu	a3,0(s1)
    202a:	8626                	mv	a2,s1
    202c:	85d2                	mv	a1,s4
    202e:	00005517          	auipc	a0,0x5
    2032:	c5250513          	addi	a0,a0,-942 # 6c80 <malloc+0xc64>
    2036:	00004097          	auipc	ra,0x4
    203a:	f28080e7          	jalr	-216(ra) # 5f5e <printf>
      exit(1);
    203e:	4505                	li	a0,1
    2040:	00004097          	auipc	ra,0x4
    2044:	b86080e7          	jalr	-1146(ra) # 5bc6 <exit>
      exit(1);
    2048:	4505                	li	a0,1
    204a:	00004097          	auipc	ra,0x4
    204e:	b7c080e7          	jalr	-1156(ra) # 5bc6 <exit>

0000000000002052 <MAXVAplus>:
{
    2052:	7179                	addi	sp,sp,-48
    2054:	f406                	sd	ra,40(sp)
    2056:	f022                	sd	s0,32(sp)
    2058:	ec26                	sd	s1,24(sp)
    205a:	e84a                	sd	s2,16(sp)
    205c:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    205e:	4785                	li	a5,1
    2060:	179a                	slli	a5,a5,0x26
    2062:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2066:	fd843783          	ld	a5,-40(s0)
    206a:	cf85                	beqz	a5,20a2 <MAXVAplus+0x50>
    206c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    206e:	54fd                	li	s1,-1
    pid = fork();
    2070:	00004097          	auipc	ra,0x4
    2074:	b4e080e7          	jalr	-1202(ra) # 5bbe <fork>
    if(pid < 0){
    2078:	02054b63          	bltz	a0,20ae <MAXVAplus+0x5c>
    if(pid == 0){
    207c:	c539                	beqz	a0,20ca <MAXVAplus+0x78>
    wait(&xstatus);
    207e:	fd440513          	addi	a0,s0,-44
    2082:	00004097          	auipc	ra,0x4
    2086:	b4c080e7          	jalr	-1204(ra) # 5bce <wait>
    if(xstatus != -1)  // did kernel kill child?
    208a:	fd442783          	lw	a5,-44(s0)
    208e:	06979463          	bne	a5,s1,20f6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2092:	fd843783          	ld	a5,-40(s0)
    2096:	0786                	slli	a5,a5,0x1
    2098:	fcf43c23          	sd	a5,-40(s0)
    209c:	fd843783          	ld	a5,-40(s0)
    20a0:	fbe1                	bnez	a5,2070 <MAXVAplus+0x1e>
}
    20a2:	70a2                	ld	ra,40(sp)
    20a4:	7402                	ld	s0,32(sp)
    20a6:	64e2                	ld	s1,24(sp)
    20a8:	6942                	ld	s2,16(sp)
    20aa:	6145                	addi	sp,sp,48
    20ac:	8082                	ret
      printf("%s: fork failed\n", s);
    20ae:	85ca                	mv	a1,s2
    20b0:	00005517          	auipc	a0,0x5
    20b4:	93050513          	addi	a0,a0,-1744 # 69e0 <malloc+0x9c4>
    20b8:	00004097          	auipc	ra,0x4
    20bc:	ea6080e7          	jalr	-346(ra) # 5f5e <printf>
      exit(1);
    20c0:	4505                	li	a0,1
    20c2:	00004097          	auipc	ra,0x4
    20c6:	b04080e7          	jalr	-1276(ra) # 5bc6 <exit>
      *(char*)a = 99;
    20ca:	fd843783          	ld	a5,-40(s0)
    20ce:	06300713          	li	a4,99
    20d2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    20d6:	fd843603          	ld	a2,-40(s0)
    20da:	85ca                	mv	a1,s2
    20dc:	00005517          	auipc	a0,0x5
    20e0:	bc450513          	addi	a0,a0,-1084 # 6ca0 <malloc+0xc84>
    20e4:	00004097          	auipc	ra,0x4
    20e8:	e7a080e7          	jalr	-390(ra) # 5f5e <printf>
      exit(1);
    20ec:	4505                	li	a0,1
    20ee:	00004097          	auipc	ra,0x4
    20f2:	ad8080e7          	jalr	-1320(ra) # 5bc6 <exit>
      exit(1);
    20f6:	4505                	li	a0,1
    20f8:	00004097          	auipc	ra,0x4
    20fc:	ace080e7          	jalr	-1330(ra) # 5bc6 <exit>

0000000000002100 <bigargtest>:
{
    2100:	7179                	addi	sp,sp,-48
    2102:	f406                	sd	ra,40(sp)
    2104:	f022                	sd	s0,32(sp)
    2106:	ec26                	sd	s1,24(sp)
    2108:	1800                	addi	s0,sp,48
    210a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    210c:	00005517          	auipc	a0,0x5
    2110:	bac50513          	addi	a0,a0,-1108 # 6cb8 <malloc+0xc9c>
    2114:	00004097          	auipc	ra,0x4
    2118:	b02080e7          	jalr	-1278(ra) # 5c16 <unlink>
  pid = fork();
    211c:	00004097          	auipc	ra,0x4
    2120:	aa2080e7          	jalr	-1374(ra) # 5bbe <fork>
  if(pid == 0){
    2124:	c121                	beqz	a0,2164 <bigargtest+0x64>
  } else if(pid < 0){
    2126:	0a054063          	bltz	a0,21c6 <bigargtest+0xc6>
  wait(&xstatus);
    212a:	fdc40513          	addi	a0,s0,-36
    212e:	00004097          	auipc	ra,0x4
    2132:	aa0080e7          	jalr	-1376(ra) # 5bce <wait>
  if(xstatus != 0)
    2136:	fdc42503          	lw	a0,-36(s0)
    213a:	e545                	bnez	a0,21e2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    213c:	4581                	li	a1,0
    213e:	00005517          	auipc	a0,0x5
    2142:	b7a50513          	addi	a0,a0,-1158 # 6cb8 <malloc+0xc9c>
    2146:	00004097          	auipc	ra,0x4
    214a:	ac0080e7          	jalr	-1344(ra) # 5c06 <open>
  if(fd < 0){
    214e:	08054e63          	bltz	a0,21ea <bigargtest+0xea>
  close(fd);
    2152:	00004097          	auipc	ra,0x4
    2156:	a9c080e7          	jalr	-1380(ra) # 5bee <close>
}
    215a:	70a2                	ld	ra,40(sp)
    215c:	7402                	ld	s0,32(sp)
    215e:	64e2                	ld	s1,24(sp)
    2160:	6145                	addi	sp,sp,48
    2162:	8082                	ret
    2164:	00007797          	auipc	a5,0x7
    2168:	2ac78793          	addi	a5,a5,684 # 9410 <args.1>
    216c:	00007697          	auipc	a3,0x7
    2170:	39c68693          	addi	a3,a3,924 # 9508 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2174:	00005717          	auipc	a4,0x5
    2178:	b5470713          	addi	a4,a4,-1196 # 6cc8 <malloc+0xcac>
    217c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    217e:	07a1                	addi	a5,a5,8
    2180:	fed79ee3          	bne	a5,a3,217c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2184:	00007597          	auipc	a1,0x7
    2188:	28c58593          	addi	a1,a1,652 # 9410 <args.1>
    218c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2190:	00004517          	auipc	a0,0x4
    2194:	fc850513          	addi	a0,a0,-56 # 6158 <malloc+0x13c>
    2198:	00004097          	auipc	ra,0x4
    219c:	a66080e7          	jalr	-1434(ra) # 5bfe <exec>
    fd = open("bigarg-ok", O_CREATE);
    21a0:	20000593          	li	a1,512
    21a4:	00005517          	auipc	a0,0x5
    21a8:	b1450513          	addi	a0,a0,-1260 # 6cb8 <malloc+0xc9c>
    21ac:	00004097          	auipc	ra,0x4
    21b0:	a5a080e7          	jalr	-1446(ra) # 5c06 <open>
    close(fd);
    21b4:	00004097          	auipc	ra,0x4
    21b8:	a3a080e7          	jalr	-1478(ra) # 5bee <close>
    exit(0);
    21bc:	4501                	li	a0,0
    21be:	00004097          	auipc	ra,0x4
    21c2:	a08080e7          	jalr	-1528(ra) # 5bc6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    21c6:	85a6                	mv	a1,s1
    21c8:	00005517          	auipc	a0,0x5
    21cc:	be050513          	addi	a0,a0,-1056 # 6da8 <malloc+0xd8c>
    21d0:	00004097          	auipc	ra,0x4
    21d4:	d8e080e7          	jalr	-626(ra) # 5f5e <printf>
    exit(1);
    21d8:	4505                	li	a0,1
    21da:	00004097          	auipc	ra,0x4
    21de:	9ec080e7          	jalr	-1556(ra) # 5bc6 <exit>
    exit(xstatus);
    21e2:	00004097          	auipc	ra,0x4
    21e6:	9e4080e7          	jalr	-1564(ra) # 5bc6 <exit>
    printf("%s: bigarg test failed!\n", s);
    21ea:	85a6                	mv	a1,s1
    21ec:	00005517          	auipc	a0,0x5
    21f0:	bdc50513          	addi	a0,a0,-1060 # 6dc8 <malloc+0xdac>
    21f4:	00004097          	auipc	ra,0x4
    21f8:	d6a080e7          	jalr	-662(ra) # 5f5e <printf>
    exit(1);
    21fc:	4505                	li	a0,1
    21fe:	00004097          	auipc	ra,0x4
    2202:	9c8080e7          	jalr	-1592(ra) # 5bc6 <exit>

0000000000002206 <stacktest>:
{
    2206:	7179                	addi	sp,sp,-48
    2208:	f406                	sd	ra,40(sp)
    220a:	f022                	sd	s0,32(sp)
    220c:	ec26                	sd	s1,24(sp)
    220e:	1800                	addi	s0,sp,48
    2210:	84aa                	mv	s1,a0
  pid = fork();
    2212:	00004097          	auipc	ra,0x4
    2216:	9ac080e7          	jalr	-1620(ra) # 5bbe <fork>
  if(pid == 0) {
    221a:	c115                	beqz	a0,223e <stacktest+0x38>
  } else if(pid < 0){
    221c:	04054463          	bltz	a0,2264 <stacktest+0x5e>
  wait(&xstatus);
    2220:	fdc40513          	addi	a0,s0,-36
    2224:	00004097          	auipc	ra,0x4
    2228:	9aa080e7          	jalr	-1622(ra) # 5bce <wait>
  if(xstatus == -1)  // kernel killed child?
    222c:	fdc42503          	lw	a0,-36(s0)
    2230:	57fd                	li	a5,-1
    2232:	04f50763          	beq	a0,a5,2280 <stacktest+0x7a>
    exit(xstatus);
    2236:	00004097          	auipc	ra,0x4
    223a:	990080e7          	jalr	-1648(ra) # 5bc6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    223e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2240:	77fd                	lui	a5,0xfffff
    2242:	97ba                	add	a5,a5,a4
    2244:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef3d8>
    2248:	85a6                	mv	a1,s1
    224a:	00005517          	auipc	a0,0x5
    224e:	b9e50513          	addi	a0,a0,-1122 # 6de8 <malloc+0xdcc>
    2252:	00004097          	auipc	ra,0x4
    2256:	d0c080e7          	jalr	-756(ra) # 5f5e <printf>
    exit(1);
    225a:	4505                	li	a0,1
    225c:	00004097          	auipc	ra,0x4
    2260:	96a080e7          	jalr	-1686(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    2264:	85a6                	mv	a1,s1
    2266:	00004517          	auipc	a0,0x4
    226a:	77a50513          	addi	a0,a0,1914 # 69e0 <malloc+0x9c4>
    226e:	00004097          	auipc	ra,0x4
    2272:	cf0080e7          	jalr	-784(ra) # 5f5e <printf>
    exit(1);
    2276:	4505                	li	a0,1
    2278:	00004097          	auipc	ra,0x4
    227c:	94e080e7          	jalr	-1714(ra) # 5bc6 <exit>
    exit(0);
    2280:	4501                	li	a0,0
    2282:	00004097          	auipc	ra,0x4
    2286:	944080e7          	jalr	-1724(ra) # 5bc6 <exit>

000000000000228a <textwrite>:
{
    228a:	7179                	addi	sp,sp,-48
    228c:	f406                	sd	ra,40(sp)
    228e:	f022                	sd	s0,32(sp)
    2290:	ec26                	sd	s1,24(sp)
    2292:	1800                	addi	s0,sp,48
    2294:	84aa                	mv	s1,a0
  pid = fork();
    2296:	00004097          	auipc	ra,0x4
    229a:	928080e7          	jalr	-1752(ra) # 5bbe <fork>
  if(pid == 0) {
    229e:	c115                	beqz	a0,22c2 <textwrite+0x38>
  } else if(pid < 0){
    22a0:	02054963          	bltz	a0,22d2 <textwrite+0x48>
  wait(&xstatus);
    22a4:	fdc40513          	addi	a0,s0,-36
    22a8:	00004097          	auipc	ra,0x4
    22ac:	926080e7          	jalr	-1754(ra) # 5bce <wait>
  if(xstatus == -1)  // kernel killed child?
    22b0:	fdc42503          	lw	a0,-36(s0)
    22b4:	57fd                	li	a5,-1
    22b6:	02f50c63          	beq	a0,a5,22ee <textwrite+0x64>
    exit(xstatus);
    22ba:	00004097          	auipc	ra,0x4
    22be:	90c080e7          	jalr	-1780(ra) # 5bc6 <exit>
    *addr = 10;
    22c2:	47a9                	li	a5,10
    22c4:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    22c8:	4505                	li	a0,1
    22ca:	00004097          	auipc	ra,0x4
    22ce:	8fc080e7          	jalr	-1796(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    22d2:	85a6                	mv	a1,s1
    22d4:	00004517          	auipc	a0,0x4
    22d8:	70c50513          	addi	a0,a0,1804 # 69e0 <malloc+0x9c4>
    22dc:	00004097          	auipc	ra,0x4
    22e0:	c82080e7          	jalr	-894(ra) # 5f5e <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	00004097          	auipc	ra,0x4
    22ea:	8e0080e7          	jalr	-1824(ra) # 5bc6 <exit>
    exit(0);
    22ee:	4501                	li	a0,0
    22f0:	00004097          	auipc	ra,0x4
    22f4:	8d6080e7          	jalr	-1834(ra) # 5bc6 <exit>

00000000000022f8 <manywrites>:
{
    22f8:	711d                	addi	sp,sp,-96
    22fa:	ec86                	sd	ra,88(sp)
    22fc:	e8a2                	sd	s0,80(sp)
    22fe:	e4a6                	sd	s1,72(sp)
    2300:	e0ca                	sd	s2,64(sp)
    2302:	fc4e                	sd	s3,56(sp)
    2304:	f852                	sd	s4,48(sp)
    2306:	f456                	sd	s5,40(sp)
    2308:	f05a                	sd	s6,32(sp)
    230a:	ec5e                	sd	s7,24(sp)
    230c:	1080                	addi	s0,sp,96
    230e:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    2310:	4981                	li	s3,0
    2312:	4911                	li	s2,4
    int pid = fork();
    2314:	00004097          	auipc	ra,0x4
    2318:	8aa080e7          	jalr	-1878(ra) # 5bbe <fork>
    231c:	84aa                	mv	s1,a0
    if(pid < 0){
    231e:	02054963          	bltz	a0,2350 <manywrites+0x58>
    if(pid == 0){
    2322:	c521                	beqz	a0,236a <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    2324:	2985                	addiw	s3,s3,1
    2326:	ff2997e3          	bne	s3,s2,2314 <manywrites+0x1c>
    232a:	4491                	li	s1,4
    int st = 0;
    232c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2330:	fa840513          	addi	a0,s0,-88
    2334:	00004097          	auipc	ra,0x4
    2338:	89a080e7          	jalr	-1894(ra) # 5bce <wait>
    if(st != 0)
    233c:	fa842503          	lw	a0,-88(s0)
    2340:	ed6d                	bnez	a0,243a <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2342:	34fd                	addiw	s1,s1,-1
    2344:	f4e5                	bnez	s1,232c <manywrites+0x34>
  exit(0);
    2346:	4501                	li	a0,0
    2348:	00004097          	auipc	ra,0x4
    234c:	87e080e7          	jalr	-1922(ra) # 5bc6 <exit>
      printf("fork failed\n");
    2350:	00005517          	auipc	a0,0x5
    2354:	a6850513          	addi	a0,a0,-1432 # 6db8 <malloc+0xd9c>
    2358:	00004097          	auipc	ra,0x4
    235c:	c06080e7          	jalr	-1018(ra) # 5f5e <printf>
      exit(1);
    2360:	4505                	li	a0,1
    2362:	00004097          	auipc	ra,0x4
    2366:	864080e7          	jalr	-1948(ra) # 5bc6 <exit>
      name[0] = 'b';
    236a:	06200793          	li	a5,98
    236e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2372:	0619879b          	addiw	a5,s3,97
    2376:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    237a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    237e:	fa840513          	addi	a0,s0,-88
    2382:	00004097          	auipc	ra,0x4
    2386:	894080e7          	jalr	-1900(ra) # 5c16 <unlink>
    238a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    238c:	0000bb17          	auipc	s6,0xb
    2390:	89cb0b13          	addi	s6,s6,-1892 # cc28 <buf>
        for(int i = 0; i < ci+1; i++){
    2394:	8a26                	mv	s4,s1
    2396:	0209ce63          	bltz	s3,23d2 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    239a:	20200593          	li	a1,514
    239e:	fa840513          	addi	a0,s0,-88
    23a2:	00004097          	auipc	ra,0x4
    23a6:	864080e7          	jalr	-1948(ra) # 5c06 <open>
    23aa:	892a                	mv	s2,a0
          if(fd < 0){
    23ac:	04054763          	bltz	a0,23fa <manywrites+0x102>
          int cc = write(fd, buf, sz);
    23b0:	660d                	lui	a2,0x3
    23b2:	85da                	mv	a1,s6
    23b4:	00004097          	auipc	ra,0x4
    23b8:	832080e7          	jalr	-1998(ra) # 5be6 <write>
          if(cc != sz){
    23bc:	678d                	lui	a5,0x3
    23be:	04f51e63          	bne	a0,a5,241a <manywrites+0x122>
          close(fd);
    23c2:	854a                	mv	a0,s2
    23c4:	00004097          	auipc	ra,0x4
    23c8:	82a080e7          	jalr	-2006(ra) # 5bee <close>
        for(int i = 0; i < ci+1; i++){
    23cc:	2a05                	addiw	s4,s4,1
    23ce:	fd49d6e3          	bge	s3,s4,239a <manywrites+0xa2>
        unlink(name);
    23d2:	fa840513          	addi	a0,s0,-88
    23d6:	00004097          	auipc	ra,0x4
    23da:	840080e7          	jalr	-1984(ra) # 5c16 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    23de:	3bfd                	addiw	s7,s7,-1
    23e0:	fa0b9ae3          	bnez	s7,2394 <manywrites+0x9c>
      unlink(name);
    23e4:	fa840513          	addi	a0,s0,-88
    23e8:	00004097          	auipc	ra,0x4
    23ec:	82e080e7          	jalr	-2002(ra) # 5c16 <unlink>
      exit(0);
    23f0:	4501                	li	a0,0
    23f2:	00003097          	auipc	ra,0x3
    23f6:	7d4080e7          	jalr	2004(ra) # 5bc6 <exit>
            printf("%s: cannot create %s\n", s, name);
    23fa:	fa840613          	addi	a2,s0,-88
    23fe:	85d6                	mv	a1,s5
    2400:	00005517          	auipc	a0,0x5
    2404:	a1050513          	addi	a0,a0,-1520 # 6e10 <malloc+0xdf4>
    2408:	00004097          	auipc	ra,0x4
    240c:	b56080e7          	jalr	-1194(ra) # 5f5e <printf>
            exit(1);
    2410:	4505                	li	a0,1
    2412:	00003097          	auipc	ra,0x3
    2416:	7b4080e7          	jalr	1972(ra) # 5bc6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    241a:	86aa                	mv	a3,a0
    241c:	660d                	lui	a2,0x3
    241e:	85d6                	mv	a1,s5
    2420:	00004517          	auipc	a0,0x4
    2424:	e0850513          	addi	a0,a0,-504 # 6228 <malloc+0x20c>
    2428:	00004097          	auipc	ra,0x4
    242c:	b36080e7          	jalr	-1226(ra) # 5f5e <printf>
            exit(1);
    2430:	4505                	li	a0,1
    2432:	00003097          	auipc	ra,0x3
    2436:	794080e7          	jalr	1940(ra) # 5bc6 <exit>
      exit(st);
    243a:	00003097          	auipc	ra,0x3
    243e:	78c080e7          	jalr	1932(ra) # 5bc6 <exit>

0000000000002442 <copyinstr3>:
{
    2442:	7179                	addi	sp,sp,-48
    2444:	f406                	sd	ra,40(sp)
    2446:	f022                	sd	s0,32(sp)
    2448:	ec26                	sd	s1,24(sp)
    244a:	1800                	addi	s0,sp,48
  sbrk(8192);
    244c:	6509                	lui	a0,0x2
    244e:	00004097          	auipc	ra,0x4
    2452:	800080e7          	jalr	-2048(ra) # 5c4e <sbrk>
  uint64 top = (uint64) sbrk(0);
    2456:	4501                	li	a0,0
    2458:	00003097          	auipc	ra,0x3
    245c:	7f6080e7          	jalr	2038(ra) # 5c4e <sbrk>
  if((top % PGSIZE) != 0){
    2460:	03451793          	slli	a5,a0,0x34
    2464:	e3c9                	bnez	a5,24e6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2466:	4501                	li	a0,0
    2468:	00003097          	auipc	ra,0x3
    246c:	7e6080e7          	jalr	2022(ra) # 5c4e <sbrk>
  if(top % PGSIZE){
    2470:	03451793          	slli	a5,a0,0x34
    2474:	e3d9                	bnez	a5,24fa <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2476:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x59>
  *b = 'x';
    247a:	07800793          	li	a5,120
    247e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2482:	8526                	mv	a0,s1
    2484:	00003097          	auipc	ra,0x3
    2488:	792080e7          	jalr	1938(ra) # 5c16 <unlink>
  if(ret != -1){
    248c:	57fd                	li	a5,-1
    248e:	08f51363          	bne	a0,a5,2514 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2492:	20100593          	li	a1,513
    2496:	8526                	mv	a0,s1
    2498:	00003097          	auipc	ra,0x3
    249c:	76e080e7          	jalr	1902(ra) # 5c06 <open>
  if(fd != -1){
    24a0:	57fd                	li	a5,-1
    24a2:	08f51863          	bne	a0,a5,2532 <copyinstr3+0xf0>
  ret = link(b, b);
    24a6:	85a6                	mv	a1,s1
    24a8:	8526                	mv	a0,s1
    24aa:	00003097          	auipc	ra,0x3
    24ae:	77c080e7          	jalr	1916(ra) # 5c26 <link>
  if(ret != -1){
    24b2:	57fd                	li	a5,-1
    24b4:	08f51e63          	bne	a0,a5,2550 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    24b8:	00005797          	auipc	a5,0x5
    24bc:	65078793          	addi	a5,a5,1616 # 7b08 <malloc+0x1aec>
    24c0:	fcf43823          	sd	a5,-48(s0)
    24c4:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    24c8:	fd040593          	addi	a1,s0,-48
    24cc:	8526                	mv	a0,s1
    24ce:	00003097          	auipc	ra,0x3
    24d2:	730080e7          	jalr	1840(ra) # 5bfe <exec>
  if(ret != -1){
    24d6:	57fd                	li	a5,-1
    24d8:	08f51c63          	bne	a0,a5,2570 <copyinstr3+0x12e>
}
    24dc:	70a2                	ld	ra,40(sp)
    24de:	7402                	ld	s0,32(sp)
    24e0:	64e2                	ld	s1,24(sp)
    24e2:	6145                	addi	sp,sp,48
    24e4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    24e6:	0347d513          	srli	a0,a5,0x34
    24ea:	6785                	lui	a5,0x1
    24ec:	40a7853b          	subw	a0,a5,a0
    24f0:	00003097          	auipc	ra,0x3
    24f4:	75e080e7          	jalr	1886(ra) # 5c4e <sbrk>
    24f8:	b7bd                	j	2466 <copyinstr3+0x24>
    printf("oops\n");
    24fa:	00005517          	auipc	a0,0x5
    24fe:	92e50513          	addi	a0,a0,-1746 # 6e28 <malloc+0xe0c>
    2502:	00004097          	auipc	ra,0x4
    2506:	a5c080e7          	jalr	-1444(ra) # 5f5e <printf>
    exit(1);
    250a:	4505                	li	a0,1
    250c:	00003097          	auipc	ra,0x3
    2510:	6ba080e7          	jalr	1722(ra) # 5bc6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2514:	862a                	mv	a2,a0
    2516:	85a6                	mv	a1,s1
    2518:	00004517          	auipc	a0,0x4
    251c:	3e850513          	addi	a0,a0,1000 # 6900 <malloc+0x8e4>
    2520:	00004097          	auipc	ra,0x4
    2524:	a3e080e7          	jalr	-1474(ra) # 5f5e <printf>
    exit(1);
    2528:	4505                	li	a0,1
    252a:	00003097          	auipc	ra,0x3
    252e:	69c080e7          	jalr	1692(ra) # 5bc6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2532:	862a                	mv	a2,a0
    2534:	85a6                	mv	a1,s1
    2536:	00004517          	auipc	a0,0x4
    253a:	3ea50513          	addi	a0,a0,1002 # 6920 <malloc+0x904>
    253e:	00004097          	auipc	ra,0x4
    2542:	a20080e7          	jalr	-1504(ra) # 5f5e <printf>
    exit(1);
    2546:	4505                	li	a0,1
    2548:	00003097          	auipc	ra,0x3
    254c:	67e080e7          	jalr	1662(ra) # 5bc6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2550:	86aa                	mv	a3,a0
    2552:	8626                	mv	a2,s1
    2554:	85a6                	mv	a1,s1
    2556:	00004517          	auipc	a0,0x4
    255a:	3ea50513          	addi	a0,a0,1002 # 6940 <malloc+0x924>
    255e:	00004097          	auipc	ra,0x4
    2562:	a00080e7          	jalr	-1536(ra) # 5f5e <printf>
    exit(1);
    2566:	4505                	li	a0,1
    2568:	00003097          	auipc	ra,0x3
    256c:	65e080e7          	jalr	1630(ra) # 5bc6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2570:	567d                	li	a2,-1
    2572:	85a6                	mv	a1,s1
    2574:	00004517          	auipc	a0,0x4
    2578:	3f450513          	addi	a0,a0,1012 # 6968 <malloc+0x94c>
    257c:	00004097          	auipc	ra,0x4
    2580:	9e2080e7          	jalr	-1566(ra) # 5f5e <printf>
    exit(1);
    2584:	4505                	li	a0,1
    2586:	00003097          	auipc	ra,0x3
    258a:	640080e7          	jalr	1600(ra) # 5bc6 <exit>

000000000000258e <rwsbrk>:
{
    258e:	1101                	addi	sp,sp,-32
    2590:	ec06                	sd	ra,24(sp)
    2592:	e822                	sd	s0,16(sp)
    2594:	e426                	sd	s1,8(sp)
    2596:	e04a                	sd	s2,0(sp)
    2598:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    259a:	6509                	lui	a0,0x2
    259c:	00003097          	auipc	ra,0x3
    25a0:	6b2080e7          	jalr	1714(ra) # 5c4e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    25a4:	57fd                	li	a5,-1
    25a6:	06f50363          	beq	a0,a5,260c <rwsbrk+0x7e>
    25aa:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    25ac:	7579                	lui	a0,0xffffe
    25ae:	00003097          	auipc	ra,0x3
    25b2:	6a0080e7          	jalr	1696(ra) # 5c4e <sbrk>
    25b6:	57fd                	li	a5,-1
    25b8:	06f50763          	beq	a0,a5,2626 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    25bc:	20100593          	li	a1,513
    25c0:	00005517          	auipc	a0,0x5
    25c4:	8a850513          	addi	a0,a0,-1880 # 6e68 <malloc+0xe4c>
    25c8:	00003097          	auipc	ra,0x3
    25cc:	63e080e7          	jalr	1598(ra) # 5c06 <open>
    25d0:	892a                	mv	s2,a0
  if(fd < 0){
    25d2:	06054763          	bltz	a0,2640 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    25d6:	6505                	lui	a0,0x1
    25d8:	94aa                	add	s1,s1,a0
    25da:	40000613          	li	a2,1024
    25de:	85a6                	mv	a1,s1
    25e0:	854a                	mv	a0,s2
    25e2:	00003097          	auipc	ra,0x3
    25e6:	604080e7          	jalr	1540(ra) # 5be6 <write>
    25ea:	862a                	mv	a2,a0
  if(n >= 0){
    25ec:	06054763          	bltz	a0,265a <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    25f0:	85a6                	mv	a1,s1
    25f2:	00005517          	auipc	a0,0x5
    25f6:	89650513          	addi	a0,a0,-1898 # 6e88 <malloc+0xe6c>
    25fa:	00004097          	auipc	ra,0x4
    25fe:	964080e7          	jalr	-1692(ra) # 5f5e <printf>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	5c2080e7          	jalr	1474(ra) # 5bc6 <exit>
    printf("sbrk(rwsbrk) failed\n");
    260c:	00005517          	auipc	a0,0x5
    2610:	82450513          	addi	a0,a0,-2012 # 6e30 <malloc+0xe14>
    2614:	00004097          	auipc	ra,0x4
    2618:	94a080e7          	jalr	-1718(ra) # 5f5e <printf>
    exit(1);
    261c:	4505                	li	a0,1
    261e:	00003097          	auipc	ra,0x3
    2622:	5a8080e7          	jalr	1448(ra) # 5bc6 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2626:	00005517          	auipc	a0,0x5
    262a:	82250513          	addi	a0,a0,-2014 # 6e48 <malloc+0xe2c>
    262e:	00004097          	auipc	ra,0x4
    2632:	930080e7          	jalr	-1744(ra) # 5f5e <printf>
    exit(1);
    2636:	4505                	li	a0,1
    2638:	00003097          	auipc	ra,0x3
    263c:	58e080e7          	jalr	1422(ra) # 5bc6 <exit>
    printf("open(rwsbrk) failed\n");
    2640:	00005517          	auipc	a0,0x5
    2644:	83050513          	addi	a0,a0,-2000 # 6e70 <malloc+0xe54>
    2648:	00004097          	auipc	ra,0x4
    264c:	916080e7          	jalr	-1770(ra) # 5f5e <printf>
    exit(1);
    2650:	4505                	li	a0,1
    2652:	00003097          	auipc	ra,0x3
    2656:	574080e7          	jalr	1396(ra) # 5bc6 <exit>
  close(fd);
    265a:	854a                	mv	a0,s2
    265c:	00003097          	auipc	ra,0x3
    2660:	592080e7          	jalr	1426(ra) # 5bee <close>
  unlink("rwsbrk");
    2664:	00005517          	auipc	a0,0x5
    2668:	80450513          	addi	a0,a0,-2044 # 6e68 <malloc+0xe4c>
    266c:	00003097          	auipc	ra,0x3
    2670:	5aa080e7          	jalr	1450(ra) # 5c16 <unlink>
  fd = open("README", O_RDONLY);
    2674:	4581                	li	a1,0
    2676:	00004517          	auipc	a0,0x4
    267a:	cba50513          	addi	a0,a0,-838 # 6330 <malloc+0x314>
    267e:	00003097          	auipc	ra,0x3
    2682:	588080e7          	jalr	1416(ra) # 5c06 <open>
    2686:	892a                	mv	s2,a0
  if(fd < 0){
    2688:	02054963          	bltz	a0,26ba <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    268c:	4629                	li	a2,10
    268e:	85a6                	mv	a1,s1
    2690:	00003097          	auipc	ra,0x3
    2694:	54e080e7          	jalr	1358(ra) # 5bde <read>
    2698:	862a                	mv	a2,a0
  if(n >= 0){
    269a:	02054d63          	bltz	a0,26d4 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    269e:	85a6                	mv	a1,s1
    26a0:	00005517          	auipc	a0,0x5
    26a4:	81850513          	addi	a0,a0,-2024 # 6eb8 <malloc+0xe9c>
    26a8:	00004097          	auipc	ra,0x4
    26ac:	8b6080e7          	jalr	-1866(ra) # 5f5e <printf>
    exit(1);
    26b0:	4505                	li	a0,1
    26b2:	00003097          	auipc	ra,0x3
    26b6:	514080e7          	jalr	1300(ra) # 5bc6 <exit>
    printf("open(rwsbrk) failed\n");
    26ba:	00004517          	auipc	a0,0x4
    26be:	7b650513          	addi	a0,a0,1974 # 6e70 <malloc+0xe54>
    26c2:	00004097          	auipc	ra,0x4
    26c6:	89c080e7          	jalr	-1892(ra) # 5f5e <printf>
    exit(1);
    26ca:	4505                	li	a0,1
    26cc:	00003097          	auipc	ra,0x3
    26d0:	4fa080e7          	jalr	1274(ra) # 5bc6 <exit>
  close(fd);
    26d4:	854a                	mv	a0,s2
    26d6:	00003097          	auipc	ra,0x3
    26da:	518080e7          	jalr	1304(ra) # 5bee <close>
  exit(0);
    26de:	4501                	li	a0,0
    26e0:	00003097          	auipc	ra,0x3
    26e4:	4e6080e7          	jalr	1254(ra) # 5bc6 <exit>

00000000000026e8 <sbrkbasic>:
{
    26e8:	7139                	addi	sp,sp,-64
    26ea:	fc06                	sd	ra,56(sp)
    26ec:	f822                	sd	s0,48(sp)
    26ee:	f426                	sd	s1,40(sp)
    26f0:	f04a                	sd	s2,32(sp)
    26f2:	ec4e                	sd	s3,24(sp)
    26f4:	e852                	sd	s4,16(sp)
    26f6:	0080                	addi	s0,sp,64
    26f8:	8a2a                	mv	s4,a0
  pid = fork();
    26fa:	00003097          	auipc	ra,0x3
    26fe:	4c4080e7          	jalr	1220(ra) # 5bbe <fork>
  if(pid < 0){
    2702:	02054c63          	bltz	a0,273a <sbrkbasic+0x52>
  if(pid == 0){
    2706:	ed21                	bnez	a0,275e <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2708:	40000537          	lui	a0,0x40000
    270c:	00003097          	auipc	ra,0x3
    2710:	542080e7          	jalr	1346(ra) # 5c4e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2714:	57fd                	li	a5,-1
    2716:	02f50f63          	beq	a0,a5,2754 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    271a:	400007b7          	lui	a5,0x40000
    271e:	97aa                	add	a5,a5,a0
      *b = 99;
    2720:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2724:	6705                	lui	a4,0x1
      *b = 99;
    2726:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff03d8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    272a:	953a                	add	a0,a0,a4
    272c:	fef51de3          	bne	a0,a5,2726 <sbrkbasic+0x3e>
    exit(1);
    2730:	4505                	li	a0,1
    2732:	00003097          	auipc	ra,0x3
    2736:	494080e7          	jalr	1172(ra) # 5bc6 <exit>
    printf("fork failed in sbrkbasic\n");
    273a:	00004517          	auipc	a0,0x4
    273e:	7a650513          	addi	a0,a0,1958 # 6ee0 <malloc+0xec4>
    2742:	00004097          	auipc	ra,0x4
    2746:	81c080e7          	jalr	-2020(ra) # 5f5e <printf>
    exit(1);
    274a:	4505                	li	a0,1
    274c:	00003097          	auipc	ra,0x3
    2750:	47a080e7          	jalr	1146(ra) # 5bc6 <exit>
      exit(0);
    2754:	4501                	li	a0,0
    2756:	00003097          	auipc	ra,0x3
    275a:	470080e7          	jalr	1136(ra) # 5bc6 <exit>
  wait(&xstatus);
    275e:	fcc40513          	addi	a0,s0,-52
    2762:	00003097          	auipc	ra,0x3
    2766:	46c080e7          	jalr	1132(ra) # 5bce <wait>
  if(xstatus == 1){
    276a:	fcc42703          	lw	a4,-52(s0)
    276e:	4785                	li	a5,1
    2770:	00f70d63          	beq	a4,a5,278a <sbrkbasic+0xa2>
  a = sbrk(0);
    2774:	4501                	li	a0,0
    2776:	00003097          	auipc	ra,0x3
    277a:	4d8080e7          	jalr	1240(ra) # 5c4e <sbrk>
    277e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2780:	4901                	li	s2,0
    2782:	6985                	lui	s3,0x1
    2784:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3c>
    2788:	a005                	j	27a8 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    278a:	85d2                	mv	a1,s4
    278c:	00004517          	auipc	a0,0x4
    2790:	77450513          	addi	a0,a0,1908 # 6f00 <malloc+0xee4>
    2794:	00003097          	auipc	ra,0x3
    2798:	7ca080e7          	jalr	1994(ra) # 5f5e <printf>
    exit(1);
    279c:	4505                	li	a0,1
    279e:	00003097          	auipc	ra,0x3
    27a2:	428080e7          	jalr	1064(ra) # 5bc6 <exit>
    a = b + 1;
    27a6:	84be                	mv	s1,a5
    b = sbrk(1);
    27a8:	4505                	li	a0,1
    27aa:	00003097          	auipc	ra,0x3
    27ae:	4a4080e7          	jalr	1188(ra) # 5c4e <sbrk>
    if(b != a){
    27b2:	04951c63          	bne	a0,s1,280a <sbrkbasic+0x122>
    *b = 1;
    27b6:	4785                	li	a5,1
    27b8:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    27bc:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    27c0:	2905                	addiw	s2,s2,1
    27c2:	ff3912e3          	bne	s2,s3,27a6 <sbrkbasic+0xbe>
  pid = fork();
    27c6:	00003097          	auipc	ra,0x3
    27ca:	3f8080e7          	jalr	1016(ra) # 5bbe <fork>
    27ce:	892a                	mv	s2,a0
  if(pid < 0){
    27d0:	04054e63          	bltz	a0,282c <sbrkbasic+0x144>
  c = sbrk(1);
    27d4:	4505                	li	a0,1
    27d6:	00003097          	auipc	ra,0x3
    27da:	478080e7          	jalr	1144(ra) # 5c4e <sbrk>
  c = sbrk(1);
    27de:	4505                	li	a0,1
    27e0:	00003097          	auipc	ra,0x3
    27e4:	46e080e7          	jalr	1134(ra) # 5c4e <sbrk>
  if(c != a + 1){
    27e8:	0489                	addi	s1,s1,2
    27ea:	04a48f63          	beq	s1,a0,2848 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    27ee:	85d2                	mv	a1,s4
    27f0:	00004517          	auipc	a0,0x4
    27f4:	77050513          	addi	a0,a0,1904 # 6f60 <malloc+0xf44>
    27f8:	00003097          	auipc	ra,0x3
    27fc:	766080e7          	jalr	1894(ra) # 5f5e <printf>
    exit(1);
    2800:	4505                	li	a0,1
    2802:	00003097          	auipc	ra,0x3
    2806:	3c4080e7          	jalr	964(ra) # 5bc6 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    280a:	872a                	mv	a4,a0
    280c:	86a6                	mv	a3,s1
    280e:	864a                	mv	a2,s2
    2810:	85d2                	mv	a1,s4
    2812:	00004517          	auipc	a0,0x4
    2816:	70e50513          	addi	a0,a0,1806 # 6f20 <malloc+0xf04>
    281a:	00003097          	auipc	ra,0x3
    281e:	744080e7          	jalr	1860(ra) # 5f5e <printf>
      exit(1);
    2822:	4505                	li	a0,1
    2824:	00003097          	auipc	ra,0x3
    2828:	3a2080e7          	jalr	930(ra) # 5bc6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    282c:	85d2                	mv	a1,s4
    282e:	00004517          	auipc	a0,0x4
    2832:	71250513          	addi	a0,a0,1810 # 6f40 <malloc+0xf24>
    2836:	00003097          	auipc	ra,0x3
    283a:	728080e7          	jalr	1832(ra) # 5f5e <printf>
    exit(1);
    283e:	4505                	li	a0,1
    2840:	00003097          	auipc	ra,0x3
    2844:	386080e7          	jalr	902(ra) # 5bc6 <exit>
  if(pid == 0)
    2848:	00091763          	bnez	s2,2856 <sbrkbasic+0x16e>
    exit(0);
    284c:	4501                	li	a0,0
    284e:	00003097          	auipc	ra,0x3
    2852:	378080e7          	jalr	888(ra) # 5bc6 <exit>
  wait(&xstatus);
    2856:	fcc40513          	addi	a0,s0,-52
    285a:	00003097          	auipc	ra,0x3
    285e:	374080e7          	jalr	884(ra) # 5bce <wait>
  exit(xstatus);
    2862:	fcc42503          	lw	a0,-52(s0)
    2866:	00003097          	auipc	ra,0x3
    286a:	360080e7          	jalr	864(ra) # 5bc6 <exit>

000000000000286e <sbrkmuch>:
{
    286e:	7179                	addi	sp,sp,-48
    2870:	f406                	sd	ra,40(sp)
    2872:	f022                	sd	s0,32(sp)
    2874:	ec26                	sd	s1,24(sp)
    2876:	e84a                	sd	s2,16(sp)
    2878:	e44e                	sd	s3,8(sp)
    287a:	e052                	sd	s4,0(sp)
    287c:	1800                	addi	s0,sp,48
    287e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2880:	4501                	li	a0,0
    2882:	00003097          	auipc	ra,0x3
    2886:	3cc080e7          	jalr	972(ra) # 5c4e <sbrk>
    288a:	892a                	mv	s2,a0
  a = sbrk(0);
    288c:	4501                	li	a0,0
    288e:	00003097          	auipc	ra,0x3
    2892:	3c0080e7          	jalr	960(ra) # 5c4e <sbrk>
    2896:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2898:	06400537          	lui	a0,0x6400
    289c:	9d05                	subw	a0,a0,s1
    289e:	00003097          	auipc	ra,0x3
    28a2:	3b0080e7          	jalr	944(ra) # 5c4e <sbrk>
  if (p != a) {
    28a6:	0ca49863          	bne	s1,a0,2976 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	3a2080e7          	jalr	930(ra) # 5c4e <sbrk>
    28b4:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    28b6:	00a4f963          	bgeu	s1,a0,28c8 <sbrkmuch+0x5a>
    *pp = 1;
    28ba:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    28bc:	6705                	lui	a4,0x1
    *pp = 1;
    28be:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    28c2:	94ba                	add	s1,s1,a4
    28c4:	fef4ede3          	bltu	s1,a5,28be <sbrkmuch+0x50>
  *lastaddr = 99;
    28c8:	064007b7          	lui	a5,0x6400
    28cc:	06300713          	li	a4,99
    28d0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f03d7>
  a = sbrk(0);
    28d4:	4501                	li	a0,0
    28d6:	00003097          	auipc	ra,0x3
    28da:	378080e7          	jalr	888(ra) # 5c4e <sbrk>
    28de:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    28e0:	757d                	lui	a0,0xfffff
    28e2:	00003097          	auipc	ra,0x3
    28e6:	36c080e7          	jalr	876(ra) # 5c4e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    28ea:	57fd                	li	a5,-1
    28ec:	0af50363          	beq	a0,a5,2992 <sbrkmuch+0x124>
  c = sbrk(0);
    28f0:	4501                	li	a0,0
    28f2:	00003097          	auipc	ra,0x3
    28f6:	35c080e7          	jalr	860(ra) # 5c4e <sbrk>
  if(c != a - PGSIZE){
    28fa:	77fd                	lui	a5,0xfffff
    28fc:	97a6                	add	a5,a5,s1
    28fe:	0af51863          	bne	a0,a5,29ae <sbrkmuch+0x140>
  a = sbrk(0);
    2902:	4501                	li	a0,0
    2904:	00003097          	auipc	ra,0x3
    2908:	34a080e7          	jalr	842(ra) # 5c4e <sbrk>
    290c:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    290e:	6505                	lui	a0,0x1
    2910:	00003097          	auipc	ra,0x3
    2914:	33e080e7          	jalr	830(ra) # 5c4e <sbrk>
    2918:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    291a:	0aa49a63          	bne	s1,a0,29ce <sbrkmuch+0x160>
    291e:	4501                	li	a0,0
    2920:	00003097          	auipc	ra,0x3
    2924:	32e080e7          	jalr	814(ra) # 5c4e <sbrk>
    2928:	6785                	lui	a5,0x1
    292a:	97a6                	add	a5,a5,s1
    292c:	0af51163          	bne	a0,a5,29ce <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2930:	064007b7          	lui	a5,0x6400
    2934:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f03d7>
    2938:	06300793          	li	a5,99
    293c:	0af70963          	beq	a4,a5,29ee <sbrkmuch+0x180>
  a = sbrk(0);
    2940:	4501                	li	a0,0
    2942:	00003097          	auipc	ra,0x3
    2946:	30c080e7          	jalr	780(ra) # 5c4e <sbrk>
    294a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    294c:	4501                	li	a0,0
    294e:	00003097          	auipc	ra,0x3
    2952:	300080e7          	jalr	768(ra) # 5c4e <sbrk>
    2956:	40a9053b          	subw	a0,s2,a0
    295a:	00003097          	auipc	ra,0x3
    295e:	2f4080e7          	jalr	756(ra) # 5c4e <sbrk>
  if(c != a){
    2962:	0aa49463          	bne	s1,a0,2a0a <sbrkmuch+0x19c>
}
    2966:	70a2                	ld	ra,40(sp)
    2968:	7402                	ld	s0,32(sp)
    296a:	64e2                	ld	s1,24(sp)
    296c:	6942                	ld	s2,16(sp)
    296e:	69a2                	ld	s3,8(sp)
    2970:	6a02                	ld	s4,0(sp)
    2972:	6145                	addi	sp,sp,48
    2974:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2976:	85ce                	mv	a1,s3
    2978:	00004517          	auipc	a0,0x4
    297c:	60850513          	addi	a0,a0,1544 # 6f80 <malloc+0xf64>
    2980:	00003097          	auipc	ra,0x3
    2984:	5de080e7          	jalr	1502(ra) # 5f5e <printf>
    exit(1);
    2988:	4505                	li	a0,1
    298a:	00003097          	auipc	ra,0x3
    298e:	23c080e7          	jalr	572(ra) # 5bc6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2992:	85ce                	mv	a1,s3
    2994:	00004517          	auipc	a0,0x4
    2998:	63450513          	addi	a0,a0,1588 # 6fc8 <malloc+0xfac>
    299c:	00003097          	auipc	ra,0x3
    29a0:	5c2080e7          	jalr	1474(ra) # 5f5e <printf>
    exit(1);
    29a4:	4505                	li	a0,1
    29a6:	00003097          	auipc	ra,0x3
    29aa:	220080e7          	jalr	544(ra) # 5bc6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    29ae:	86aa                	mv	a3,a0
    29b0:	8626                	mv	a2,s1
    29b2:	85ce                	mv	a1,s3
    29b4:	00004517          	auipc	a0,0x4
    29b8:	63450513          	addi	a0,a0,1588 # 6fe8 <malloc+0xfcc>
    29bc:	00003097          	auipc	ra,0x3
    29c0:	5a2080e7          	jalr	1442(ra) # 5f5e <printf>
    exit(1);
    29c4:	4505                	li	a0,1
    29c6:	00003097          	auipc	ra,0x3
    29ca:	200080e7          	jalr	512(ra) # 5bc6 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    29ce:	86d2                	mv	a3,s4
    29d0:	8626                	mv	a2,s1
    29d2:	85ce                	mv	a1,s3
    29d4:	00004517          	auipc	a0,0x4
    29d8:	65450513          	addi	a0,a0,1620 # 7028 <malloc+0x100c>
    29dc:	00003097          	auipc	ra,0x3
    29e0:	582080e7          	jalr	1410(ra) # 5f5e <printf>
    exit(1);
    29e4:	4505                	li	a0,1
    29e6:	00003097          	auipc	ra,0x3
    29ea:	1e0080e7          	jalr	480(ra) # 5bc6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    29ee:	85ce                	mv	a1,s3
    29f0:	00004517          	auipc	a0,0x4
    29f4:	66850513          	addi	a0,a0,1640 # 7058 <malloc+0x103c>
    29f8:	00003097          	auipc	ra,0x3
    29fc:	566080e7          	jalr	1382(ra) # 5f5e <printf>
    exit(1);
    2a00:	4505                	li	a0,1
    2a02:	00003097          	auipc	ra,0x3
    2a06:	1c4080e7          	jalr	452(ra) # 5bc6 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2a0a:	86aa                	mv	a3,a0
    2a0c:	8626                	mv	a2,s1
    2a0e:	85ce                	mv	a1,s3
    2a10:	00004517          	auipc	a0,0x4
    2a14:	68050513          	addi	a0,a0,1664 # 7090 <malloc+0x1074>
    2a18:	00003097          	auipc	ra,0x3
    2a1c:	546080e7          	jalr	1350(ra) # 5f5e <printf>
    exit(1);
    2a20:	4505                	li	a0,1
    2a22:	00003097          	auipc	ra,0x3
    2a26:	1a4080e7          	jalr	420(ra) # 5bc6 <exit>

0000000000002a2a <sbrkarg>:
{
    2a2a:	7179                	addi	sp,sp,-48
    2a2c:	f406                	sd	ra,40(sp)
    2a2e:	f022                	sd	s0,32(sp)
    2a30:	ec26                	sd	s1,24(sp)
    2a32:	e84a                	sd	s2,16(sp)
    2a34:	e44e                	sd	s3,8(sp)
    2a36:	1800                	addi	s0,sp,48
    2a38:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2a3a:	6505                	lui	a0,0x1
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	212080e7          	jalr	530(ra) # 5c4e <sbrk>
    2a44:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2a46:	20100593          	li	a1,513
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	66e50513          	addi	a0,a0,1646 # 70b8 <malloc+0x109c>
    2a52:	00003097          	auipc	ra,0x3
    2a56:	1b4080e7          	jalr	436(ra) # 5c06 <open>
    2a5a:	84aa                	mv	s1,a0
  unlink("sbrk");
    2a5c:	00004517          	auipc	a0,0x4
    2a60:	65c50513          	addi	a0,a0,1628 # 70b8 <malloc+0x109c>
    2a64:	00003097          	auipc	ra,0x3
    2a68:	1b2080e7          	jalr	434(ra) # 5c16 <unlink>
  if(fd < 0)  {
    2a6c:	0404c163          	bltz	s1,2aae <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2a70:	6605                	lui	a2,0x1
    2a72:	85ca                	mv	a1,s2
    2a74:	8526                	mv	a0,s1
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	170080e7          	jalr	368(ra) # 5be6 <write>
    2a7e:	04054663          	bltz	a0,2aca <sbrkarg+0xa0>
  close(fd);
    2a82:	8526                	mv	a0,s1
    2a84:	00003097          	auipc	ra,0x3
    2a88:	16a080e7          	jalr	362(ra) # 5bee <close>
  a = sbrk(PGSIZE);
    2a8c:	6505                	lui	a0,0x1
    2a8e:	00003097          	auipc	ra,0x3
    2a92:	1c0080e7          	jalr	448(ra) # 5c4e <sbrk>
  if(pipe((int *) a) != 0){
    2a96:	00003097          	auipc	ra,0x3
    2a9a:	140080e7          	jalr	320(ra) # 5bd6 <pipe>
    2a9e:	e521                	bnez	a0,2ae6 <sbrkarg+0xbc>
}
    2aa0:	70a2                	ld	ra,40(sp)
    2aa2:	7402                	ld	s0,32(sp)
    2aa4:	64e2                	ld	s1,24(sp)
    2aa6:	6942                	ld	s2,16(sp)
    2aa8:	69a2                	ld	s3,8(sp)
    2aaa:	6145                	addi	sp,sp,48
    2aac:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2aae:	85ce                	mv	a1,s3
    2ab0:	00004517          	auipc	a0,0x4
    2ab4:	61050513          	addi	a0,a0,1552 # 70c0 <malloc+0x10a4>
    2ab8:	00003097          	auipc	ra,0x3
    2abc:	4a6080e7          	jalr	1190(ra) # 5f5e <printf>
    exit(1);
    2ac0:	4505                	li	a0,1
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	104080e7          	jalr	260(ra) # 5bc6 <exit>
    printf("%s: write sbrk failed\n", s);
    2aca:	85ce                	mv	a1,s3
    2acc:	00004517          	auipc	a0,0x4
    2ad0:	60c50513          	addi	a0,a0,1548 # 70d8 <malloc+0x10bc>
    2ad4:	00003097          	auipc	ra,0x3
    2ad8:	48a080e7          	jalr	1162(ra) # 5f5e <printf>
    exit(1);
    2adc:	4505                	li	a0,1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	0e8080e7          	jalr	232(ra) # 5bc6 <exit>
    printf("%s: pipe() failed\n", s);
    2ae6:	85ce                	mv	a1,s3
    2ae8:	00004517          	auipc	a0,0x4
    2aec:	00050513          	mv	a0,a0
    2af0:	00003097          	auipc	ra,0x3
    2af4:	46e080e7          	jalr	1134(ra) # 5f5e <printf>
    exit(1);
    2af8:	4505                	li	a0,1
    2afa:	00003097          	auipc	ra,0x3
    2afe:	0cc080e7          	jalr	204(ra) # 5bc6 <exit>

0000000000002b02 <argptest>:
{
    2b02:	1101                	addi	sp,sp,-32
    2b04:	ec06                	sd	ra,24(sp)
    2b06:	e822                	sd	s0,16(sp)
    2b08:	e426                	sd	s1,8(sp)
    2b0a:	e04a                	sd	s2,0(sp)
    2b0c:	1000                	addi	s0,sp,32
    2b0e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2b10:	4581                	li	a1,0
    2b12:	00004517          	auipc	a0,0x4
    2b16:	5de50513          	addi	a0,a0,1502 # 70f0 <malloc+0x10d4>
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	0ec080e7          	jalr	236(ra) # 5c06 <open>
  if (fd < 0) {
    2b22:	02054b63          	bltz	a0,2b58 <argptest+0x56>
    2b26:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2b28:	4501                	li	a0,0
    2b2a:	00003097          	auipc	ra,0x3
    2b2e:	124080e7          	jalr	292(ra) # 5c4e <sbrk>
    2b32:	567d                	li	a2,-1
    2b34:	fff50593          	addi	a1,a0,-1
    2b38:	8526                	mv	a0,s1
    2b3a:	00003097          	auipc	ra,0x3
    2b3e:	0a4080e7          	jalr	164(ra) # 5bde <read>
  close(fd);
    2b42:	8526                	mv	a0,s1
    2b44:	00003097          	auipc	ra,0x3
    2b48:	0aa080e7          	jalr	170(ra) # 5bee <close>
}
    2b4c:	60e2                	ld	ra,24(sp)
    2b4e:	6442                	ld	s0,16(sp)
    2b50:	64a2                	ld	s1,8(sp)
    2b52:	6902                	ld	s2,0(sp)
    2b54:	6105                	addi	sp,sp,32
    2b56:	8082                	ret
    printf("%s: open failed\n", s);
    2b58:	85ca                	mv	a1,s2
    2b5a:	00004517          	auipc	a0,0x4
    2b5e:	e9e50513          	addi	a0,a0,-354 # 69f8 <malloc+0x9dc>
    2b62:	00003097          	auipc	ra,0x3
    2b66:	3fc080e7          	jalr	1020(ra) # 5f5e <printf>
    exit(1);
    2b6a:	4505                	li	a0,1
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	05a080e7          	jalr	90(ra) # 5bc6 <exit>

0000000000002b74 <sbrkbugs>:
{
    2b74:	1141                	addi	sp,sp,-16
    2b76:	e406                	sd	ra,8(sp)
    2b78:	e022                	sd	s0,0(sp)
    2b7a:	0800                	addi	s0,sp,16
  int pid = fork();
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	042080e7          	jalr	66(ra) # 5bbe <fork>
  if(pid < 0){
    2b84:	02054263          	bltz	a0,2ba8 <sbrkbugs+0x34>
  if(pid == 0){
    2b88:	ed0d                	bnez	a0,2bc2 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	0c4080e7          	jalr	196(ra) # 5c4e <sbrk>
    sbrk(-sz);
    2b92:	40a0053b          	negw	a0,a0
    2b96:	00003097          	auipc	ra,0x3
    2b9a:	0b8080e7          	jalr	184(ra) # 5c4e <sbrk>
    exit(0);
    2b9e:	4501                	li	a0,0
    2ba0:	00003097          	auipc	ra,0x3
    2ba4:	026080e7          	jalr	38(ra) # 5bc6 <exit>
    printf("fork failed\n");
    2ba8:	00004517          	auipc	a0,0x4
    2bac:	21050513          	addi	a0,a0,528 # 6db8 <malloc+0xd9c>
    2bb0:	00003097          	auipc	ra,0x3
    2bb4:	3ae080e7          	jalr	942(ra) # 5f5e <printf>
    exit(1);
    2bb8:	4505                	li	a0,1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	00c080e7          	jalr	12(ra) # 5bc6 <exit>
  wait(0);
    2bc2:	4501                	li	a0,0
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	00a080e7          	jalr	10(ra) # 5bce <wait>
  pid = fork();
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	ff2080e7          	jalr	-14(ra) # 5bbe <fork>
  if(pid < 0){
    2bd4:	02054563          	bltz	a0,2bfe <sbrkbugs+0x8a>
  if(pid == 0){
    2bd8:	e121                	bnez	a0,2c18 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2bda:	00003097          	auipc	ra,0x3
    2bde:	074080e7          	jalr	116(ra) # 5c4e <sbrk>
    sbrk(-(sz - 3500));
    2be2:	6785                	lui	a5,0x1
    2be4:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6c>
    2be8:	40a7853b          	subw	a0,a5,a0
    2bec:	00003097          	auipc	ra,0x3
    2bf0:	062080e7          	jalr	98(ra) # 5c4e <sbrk>
    exit(0);
    2bf4:	4501                	li	a0,0
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	fd0080e7          	jalr	-48(ra) # 5bc6 <exit>
    printf("fork failed\n");
    2bfe:	00004517          	auipc	a0,0x4
    2c02:	1ba50513          	addi	a0,a0,442 # 6db8 <malloc+0xd9c>
    2c06:	00003097          	auipc	ra,0x3
    2c0a:	358080e7          	jalr	856(ra) # 5f5e <printf>
    exit(1);
    2c0e:	4505                	li	a0,1
    2c10:	00003097          	auipc	ra,0x3
    2c14:	fb6080e7          	jalr	-74(ra) # 5bc6 <exit>
  wait(0);
    2c18:	4501                	li	a0,0
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	fb4080e7          	jalr	-76(ra) # 5bce <wait>
  pid = fork();
    2c22:	00003097          	auipc	ra,0x3
    2c26:	f9c080e7          	jalr	-100(ra) # 5bbe <fork>
  if(pid < 0){
    2c2a:	02054a63          	bltz	a0,2c5e <sbrkbugs+0xea>
  if(pid == 0){
    2c2e:	e529                	bnez	a0,2c78 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2c30:	00003097          	auipc	ra,0x3
    2c34:	01e080e7          	jalr	30(ra) # 5c4e <sbrk>
    2c38:	67ad                	lui	a5,0xb
    2c3a:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x2e8>
    2c3e:	40a7853b          	subw	a0,a5,a0
    2c42:	00003097          	auipc	ra,0x3
    2c46:	00c080e7          	jalr	12(ra) # 5c4e <sbrk>
    sbrk(-10);
    2c4a:	5559                	li	a0,-10
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	002080e7          	jalr	2(ra) # 5c4e <sbrk>
    exit(0);
    2c54:	4501                	li	a0,0
    2c56:	00003097          	auipc	ra,0x3
    2c5a:	f70080e7          	jalr	-144(ra) # 5bc6 <exit>
    printf("fork failed\n");
    2c5e:	00004517          	auipc	a0,0x4
    2c62:	15a50513          	addi	a0,a0,346 # 6db8 <malloc+0xd9c>
    2c66:	00003097          	auipc	ra,0x3
    2c6a:	2f8080e7          	jalr	760(ra) # 5f5e <printf>
    exit(1);
    2c6e:	4505                	li	a0,1
    2c70:	00003097          	auipc	ra,0x3
    2c74:	f56080e7          	jalr	-170(ra) # 5bc6 <exit>
  wait(0);
    2c78:	4501                	li	a0,0
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	f54080e7          	jalr	-172(ra) # 5bce <wait>
  exit(0);
    2c82:	4501                	li	a0,0
    2c84:	00003097          	auipc	ra,0x3
    2c88:	f42080e7          	jalr	-190(ra) # 5bc6 <exit>

0000000000002c8c <sbrklast>:
{
    2c8c:	7179                	addi	sp,sp,-48
    2c8e:	f406                	sd	ra,40(sp)
    2c90:	f022                	sd	s0,32(sp)
    2c92:	ec26                	sd	s1,24(sp)
    2c94:	e84a                	sd	s2,16(sp)
    2c96:	e44e                	sd	s3,8(sp)
    2c98:	e052                	sd	s4,0(sp)
    2c9a:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c9c:	4501                	li	a0,0
    2c9e:	00003097          	auipc	ra,0x3
    2ca2:	fb0080e7          	jalr	-80(ra) # 5c4e <sbrk>
  if((top % 4096) != 0)
    2ca6:	03451793          	slli	a5,a0,0x34
    2caa:	ebd9                	bnez	a5,2d40 <sbrklast+0xb4>
  sbrk(4096);
    2cac:	6505                	lui	a0,0x1
    2cae:	00003097          	auipc	ra,0x3
    2cb2:	fa0080e7          	jalr	-96(ra) # 5c4e <sbrk>
  sbrk(10);
    2cb6:	4529                	li	a0,10
    2cb8:	00003097          	auipc	ra,0x3
    2cbc:	f96080e7          	jalr	-106(ra) # 5c4e <sbrk>
  sbrk(-20);
    2cc0:	5531                	li	a0,-20
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	f8c080e7          	jalr	-116(ra) # 5c4e <sbrk>
  top = (uint64) sbrk(0);
    2cca:	4501                	li	a0,0
    2ccc:	00003097          	auipc	ra,0x3
    2cd0:	f82080e7          	jalr	-126(ra) # 5c4e <sbrk>
    2cd4:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2cd6:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2cda:	07800a13          	li	s4,120
    2cde:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2ce2:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2ce6:	20200593          	li	a1,514
    2cea:	854a                	mv	a0,s2
    2cec:	00003097          	auipc	ra,0x3
    2cf0:	f1a080e7          	jalr	-230(ra) # 5c06 <open>
    2cf4:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2cf6:	4605                	li	a2,1
    2cf8:	85ca                	mv	a1,s2
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	eec080e7          	jalr	-276(ra) # 5be6 <write>
  close(fd);
    2d02:	854e                	mv	a0,s3
    2d04:	00003097          	auipc	ra,0x3
    2d08:	eea080e7          	jalr	-278(ra) # 5bee <close>
  fd = open(p, O_RDWR);
    2d0c:	4589                	li	a1,2
    2d0e:	854a                	mv	a0,s2
    2d10:	00003097          	auipc	ra,0x3
    2d14:	ef6080e7          	jalr	-266(ra) # 5c06 <open>
  p[0] = '\0';
    2d18:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2d1c:	4605                	li	a2,1
    2d1e:	85ca                	mv	a1,s2
    2d20:	00003097          	auipc	ra,0x3
    2d24:	ebe080e7          	jalr	-322(ra) # 5bde <read>
  if(p[0] != 'x')
    2d28:	fc04c783          	lbu	a5,-64(s1)
    2d2c:	03479463          	bne	a5,s4,2d54 <sbrklast+0xc8>
}
    2d30:	70a2                	ld	ra,40(sp)
    2d32:	7402                	ld	s0,32(sp)
    2d34:	64e2                	ld	s1,24(sp)
    2d36:	6942                	ld	s2,16(sp)
    2d38:	69a2                	ld	s3,8(sp)
    2d3a:	6a02                	ld	s4,0(sp)
    2d3c:	6145                	addi	sp,sp,48
    2d3e:	8082                	ret
    sbrk(4096 - (top % 4096));
    2d40:	0347d513          	srli	a0,a5,0x34
    2d44:	6785                	lui	a5,0x1
    2d46:	40a7853b          	subw	a0,a5,a0
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	f04080e7          	jalr	-252(ra) # 5c4e <sbrk>
    2d52:	bfa9                	j	2cac <sbrklast+0x20>
    exit(1);
    2d54:	4505                	li	a0,1
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	e70080e7          	jalr	-400(ra) # 5bc6 <exit>

0000000000002d5e <sbrk8000>:
{
    2d5e:	1141                	addi	sp,sp,-16
    2d60:	e406                	sd	ra,8(sp)
    2d62:	e022                	sd	s0,0(sp)
    2d64:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2d66:	80000537          	lui	a0,0x80000
    2d6a:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff03dc>
    2d6c:	00003097          	auipc	ra,0x3
    2d70:	ee2080e7          	jalr	-286(ra) # 5c4e <sbrk>
  volatile char *top = sbrk(0);
    2d74:	4501                	li	a0,0
    2d76:	00003097          	auipc	ra,0x3
    2d7a:	ed8080e7          	jalr	-296(ra) # 5c4e <sbrk>
  *(top-1) = *(top-1) + 1;
    2d7e:	fff54783          	lbu	a5,-1(a0)
    2d82:	0785                	addi	a5,a5,1 # 1001 <linktest+0x10b>
    2d84:	0ff7f793          	zext.b	a5,a5
    2d88:	fef50fa3          	sb	a5,-1(a0)
}
    2d8c:	60a2                	ld	ra,8(sp)
    2d8e:	6402                	ld	s0,0(sp)
    2d90:	0141                	addi	sp,sp,16
    2d92:	8082                	ret

0000000000002d94 <execout>:
{
    2d94:	715d                	addi	sp,sp,-80
    2d96:	e486                	sd	ra,72(sp)
    2d98:	e0a2                	sd	s0,64(sp)
    2d9a:	fc26                	sd	s1,56(sp)
    2d9c:	f84a                	sd	s2,48(sp)
    2d9e:	f44e                	sd	s3,40(sp)
    2da0:	f052                	sd	s4,32(sp)
    2da2:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2da4:	4901                	li	s2,0
    2da6:	49bd                	li	s3,15
    int pid = fork();
    2da8:	00003097          	auipc	ra,0x3
    2dac:	e16080e7          	jalr	-490(ra) # 5bbe <fork>
    2db0:	84aa                	mv	s1,a0
    if(pid < 0){
    2db2:	02054063          	bltz	a0,2dd2 <execout+0x3e>
    } else if(pid == 0){
    2db6:	c91d                	beqz	a0,2dec <execout+0x58>
      wait((int*)0);
    2db8:	4501                	li	a0,0
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	e14080e7          	jalr	-492(ra) # 5bce <wait>
  for(int avail = 0; avail < 15; avail++){
    2dc2:	2905                	addiw	s2,s2,1
    2dc4:	ff3912e3          	bne	s2,s3,2da8 <execout+0x14>
  exit(0);
    2dc8:	4501                	li	a0,0
    2dca:	00003097          	auipc	ra,0x3
    2dce:	dfc080e7          	jalr	-516(ra) # 5bc6 <exit>
      printf("fork failed\n");
    2dd2:	00004517          	auipc	a0,0x4
    2dd6:	fe650513          	addi	a0,a0,-26 # 6db8 <malloc+0xd9c>
    2dda:	00003097          	auipc	ra,0x3
    2dde:	184080e7          	jalr	388(ra) # 5f5e <printf>
      exit(1);
    2de2:	4505                	li	a0,1
    2de4:	00003097          	auipc	ra,0x3
    2de8:	de2080e7          	jalr	-542(ra) # 5bc6 <exit>
        if(a == 0xffffffffffffffffLL)
    2dec:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2dee:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2df0:	6505                	lui	a0,0x1
    2df2:	00003097          	auipc	ra,0x3
    2df6:	e5c080e7          	jalr	-420(ra) # 5c4e <sbrk>
        if(a == 0xffffffffffffffffLL)
    2dfa:	01350763          	beq	a0,s3,2e08 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2dfe:	6785                	lui	a5,0x1
    2e00:	953e                	add	a0,a0,a5
    2e02:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0x109>
      while(1){
    2e06:	b7ed                	j	2df0 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2e08:	01205a63          	blez	s2,2e1c <execout+0x88>
        sbrk(-4096);
    2e0c:	757d                	lui	a0,0xfffff
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	e40080e7          	jalr	-448(ra) # 5c4e <sbrk>
      for(int i = 0; i < avail; i++)
    2e16:	2485                	addiw	s1,s1,1
    2e18:	ff249ae3          	bne	s1,s2,2e0c <execout+0x78>
      close(1);
    2e1c:	4505                	li	a0,1
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	dd0080e7          	jalr	-560(ra) # 5bee <close>
      char *args[] = { "echo", "x", 0 };
    2e26:	00003517          	auipc	a0,0x3
    2e2a:	33250513          	addi	a0,a0,818 # 6158 <malloc+0x13c>
    2e2e:	faa43c23          	sd	a0,-72(s0)
    2e32:	00003797          	auipc	a5,0x3
    2e36:	39678793          	addi	a5,a5,918 # 61c8 <malloc+0x1ac>
    2e3a:	fcf43023          	sd	a5,-64(s0)
    2e3e:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2e42:	fb840593          	addi	a1,s0,-72
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	db8080e7          	jalr	-584(ra) # 5bfe <exec>
      exit(0);
    2e4e:	4501                	li	a0,0
    2e50:	00003097          	auipc	ra,0x3
    2e54:	d76080e7          	jalr	-650(ra) # 5bc6 <exit>

0000000000002e58 <fourteen>:
{
    2e58:	1101                	addi	sp,sp,-32
    2e5a:	ec06                	sd	ra,24(sp)
    2e5c:	e822                	sd	s0,16(sp)
    2e5e:	e426                	sd	s1,8(sp)
    2e60:	1000                	addi	s0,sp,32
    2e62:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2e64:	00004517          	auipc	a0,0x4
    2e68:	46450513          	addi	a0,a0,1124 # 72c8 <malloc+0x12ac>
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	dc2080e7          	jalr	-574(ra) # 5c2e <mkdir>
    2e74:	e165                	bnez	a0,2f54 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2e76:	00004517          	auipc	a0,0x4
    2e7a:	2aa50513          	addi	a0,a0,682 # 7120 <malloc+0x1104>
    2e7e:	00003097          	auipc	ra,0x3
    2e82:	db0080e7          	jalr	-592(ra) # 5c2e <mkdir>
    2e86:	e56d                	bnez	a0,2f70 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e88:	20000593          	li	a1,512
    2e8c:	00004517          	auipc	a0,0x4
    2e90:	2ec50513          	addi	a0,a0,748 # 7178 <malloc+0x115c>
    2e94:	00003097          	auipc	ra,0x3
    2e98:	d72080e7          	jalr	-654(ra) # 5c06 <open>
  if(fd < 0){
    2e9c:	0e054863          	bltz	a0,2f8c <fourteen+0x134>
  close(fd);
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	d4e080e7          	jalr	-690(ra) # 5bee <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2ea8:	4581                	li	a1,0
    2eaa:	00004517          	auipc	a0,0x4
    2eae:	34650513          	addi	a0,a0,838 # 71f0 <malloc+0x11d4>
    2eb2:	00003097          	auipc	ra,0x3
    2eb6:	d54080e7          	jalr	-684(ra) # 5c06 <open>
  if(fd < 0){
    2eba:	0e054763          	bltz	a0,2fa8 <fourteen+0x150>
  close(fd);
    2ebe:	00003097          	auipc	ra,0x3
    2ec2:	d30080e7          	jalr	-720(ra) # 5bee <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2ec6:	00004517          	auipc	a0,0x4
    2eca:	39a50513          	addi	a0,a0,922 # 7260 <malloc+0x1244>
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	d60080e7          	jalr	-672(ra) # 5c2e <mkdir>
    2ed6:	c57d                	beqz	a0,2fc4 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2ed8:	00004517          	auipc	a0,0x4
    2edc:	3e050513          	addi	a0,a0,992 # 72b8 <malloc+0x129c>
    2ee0:	00003097          	auipc	ra,0x3
    2ee4:	d4e080e7          	jalr	-690(ra) # 5c2e <mkdir>
    2ee8:	cd65                	beqz	a0,2fe0 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2eea:	00004517          	auipc	a0,0x4
    2eee:	3ce50513          	addi	a0,a0,974 # 72b8 <malloc+0x129c>
    2ef2:	00003097          	auipc	ra,0x3
    2ef6:	d24080e7          	jalr	-732(ra) # 5c16 <unlink>
  unlink("12345678901234/12345678901234");
    2efa:	00004517          	auipc	a0,0x4
    2efe:	36650513          	addi	a0,a0,870 # 7260 <malloc+0x1244>
    2f02:	00003097          	auipc	ra,0x3
    2f06:	d14080e7          	jalr	-748(ra) # 5c16 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2f0a:	00004517          	auipc	a0,0x4
    2f0e:	2e650513          	addi	a0,a0,742 # 71f0 <malloc+0x11d4>
    2f12:	00003097          	auipc	ra,0x3
    2f16:	d04080e7          	jalr	-764(ra) # 5c16 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2f1a:	00004517          	auipc	a0,0x4
    2f1e:	25e50513          	addi	a0,a0,606 # 7178 <malloc+0x115c>
    2f22:	00003097          	auipc	ra,0x3
    2f26:	cf4080e7          	jalr	-780(ra) # 5c16 <unlink>
  unlink("12345678901234/123456789012345");
    2f2a:	00004517          	auipc	a0,0x4
    2f2e:	1f650513          	addi	a0,a0,502 # 7120 <malloc+0x1104>
    2f32:	00003097          	auipc	ra,0x3
    2f36:	ce4080e7          	jalr	-796(ra) # 5c16 <unlink>
  unlink("12345678901234");
    2f3a:	00004517          	auipc	a0,0x4
    2f3e:	38e50513          	addi	a0,a0,910 # 72c8 <malloc+0x12ac>
    2f42:	00003097          	auipc	ra,0x3
    2f46:	cd4080e7          	jalr	-812(ra) # 5c16 <unlink>
}
    2f4a:	60e2                	ld	ra,24(sp)
    2f4c:	6442                	ld	s0,16(sp)
    2f4e:	64a2                	ld	s1,8(sp)
    2f50:	6105                	addi	sp,sp,32
    2f52:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2f54:	85a6                	mv	a1,s1
    2f56:	00004517          	auipc	a0,0x4
    2f5a:	1a250513          	addi	a0,a0,418 # 70f8 <malloc+0x10dc>
    2f5e:	00003097          	auipc	ra,0x3
    2f62:	000080e7          	jalr	ra # 5f5e <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	00003097          	auipc	ra,0x3
    2f6c:	c5e080e7          	jalr	-930(ra) # 5bc6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2f70:	85a6                	mv	a1,s1
    2f72:	00004517          	auipc	a0,0x4
    2f76:	1ce50513          	addi	a0,a0,462 # 7140 <malloc+0x1124>
    2f7a:	00003097          	auipc	ra,0x3
    2f7e:	fe4080e7          	jalr	-28(ra) # 5f5e <printf>
    exit(1);
    2f82:	4505                	li	a0,1
    2f84:	00003097          	auipc	ra,0x3
    2f88:	c42080e7          	jalr	-958(ra) # 5bc6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f8c:	85a6                	mv	a1,s1
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	21a50513          	addi	a0,a0,538 # 71a8 <malloc+0x118c>
    2f96:	00003097          	auipc	ra,0x3
    2f9a:	fc8080e7          	jalr	-56(ra) # 5f5e <printf>
    exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	c26080e7          	jalr	-986(ra) # 5bc6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2fa8:	85a6                	mv	a1,s1
    2faa:	00004517          	auipc	a0,0x4
    2fae:	27650513          	addi	a0,a0,630 # 7220 <malloc+0x1204>
    2fb2:	00003097          	auipc	ra,0x3
    2fb6:	fac080e7          	jalr	-84(ra) # 5f5e <printf>
    exit(1);
    2fba:	4505                	li	a0,1
    2fbc:	00003097          	auipc	ra,0x3
    2fc0:	c0a080e7          	jalr	-1014(ra) # 5bc6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2fc4:	85a6                	mv	a1,s1
    2fc6:	00004517          	auipc	a0,0x4
    2fca:	2ba50513          	addi	a0,a0,698 # 7280 <malloc+0x1264>
    2fce:	00003097          	auipc	ra,0x3
    2fd2:	f90080e7          	jalr	-112(ra) # 5f5e <printf>
    exit(1);
    2fd6:	4505                	li	a0,1
    2fd8:	00003097          	auipc	ra,0x3
    2fdc:	bee080e7          	jalr	-1042(ra) # 5bc6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2fe0:	85a6                	mv	a1,s1
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	2f650513          	addi	a0,a0,758 # 72d8 <malloc+0x12bc>
    2fea:	00003097          	auipc	ra,0x3
    2fee:	f74080e7          	jalr	-140(ra) # 5f5e <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	00003097          	auipc	ra,0x3
    2ff8:	bd2080e7          	jalr	-1070(ra) # 5bc6 <exit>

0000000000002ffc <diskfull>:
{
    2ffc:	b9010113          	addi	sp,sp,-1136
    3000:	46113423          	sd	ra,1128(sp)
    3004:	46813023          	sd	s0,1120(sp)
    3008:	44913c23          	sd	s1,1112(sp)
    300c:	45213823          	sd	s2,1104(sp)
    3010:	45313423          	sd	s3,1096(sp)
    3014:	45413023          	sd	s4,1088(sp)
    3018:	43513c23          	sd	s5,1080(sp)
    301c:	43613823          	sd	s6,1072(sp)
    3020:	43713423          	sd	s7,1064(sp)
    3024:	43813023          	sd	s8,1056(sp)
    3028:	47010413          	addi	s0,sp,1136
    302c:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    302e:	00004517          	auipc	a0,0x4
    3032:	2e250513          	addi	a0,a0,738 # 7310 <malloc+0x12f4>
    3036:	00003097          	auipc	ra,0x3
    303a:	be0080e7          	jalr	-1056(ra) # 5c16 <unlink>
  for(fi = 0; done == 0; fi++){
    303e:	4a01                	li	s4,0
    name[0] = 'b';
    3040:	06200b13          	li	s6,98
    name[1] = 'i';
    3044:	06900a93          	li	s5,105
    name[2] = 'g';
    3048:	06700993          	li	s3,103
    304c:	10c00b93          	li	s7,268
    3050:	aabd                	j	31ce <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3052:	b9040613          	addi	a2,s0,-1136
    3056:	85e2                	mv	a1,s8
    3058:	00004517          	auipc	a0,0x4
    305c:	2c850513          	addi	a0,a0,712 # 7320 <malloc+0x1304>
    3060:	00003097          	auipc	ra,0x3
    3064:	efe080e7          	jalr	-258(ra) # 5f5e <printf>
      break;
    3068:	a821                	j	3080 <diskfull+0x84>
        close(fd);
    306a:	854a                	mv	a0,s2
    306c:	00003097          	auipc	ra,0x3
    3070:	b82080e7          	jalr	-1150(ra) # 5bee <close>
    close(fd);
    3074:	854a                	mv	a0,s2
    3076:	00003097          	auipc	ra,0x3
    307a:	b78080e7          	jalr	-1160(ra) # 5bee <close>
  for(fi = 0; done == 0; fi++){
    307e:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    3080:	4481                	li	s1,0
    name[0] = 'z';
    3082:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3086:	08000993          	li	s3,128
    name[0] = 'z';
    308a:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    308e:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3092:	41f4d79b          	sraiw	a5,s1,0x1f
    3096:	01b7d71b          	srliw	a4,a5,0x1b
    309a:	009707bb          	addw	a5,a4,s1
    309e:	4057d69b          	sraiw	a3,a5,0x5
    30a2:	0306869b          	addiw	a3,a3,48
    30a6:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    30aa:	8bfd                	andi	a5,a5,31
    30ac:	9f99                	subw	a5,a5,a4
    30ae:	0307879b          	addiw	a5,a5,48
    30b2:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    30b6:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    30ba:	bb040513          	addi	a0,s0,-1104
    30be:	00003097          	auipc	ra,0x3
    30c2:	b58080e7          	jalr	-1192(ra) # 5c16 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    30c6:	60200593          	li	a1,1538
    30ca:	bb040513          	addi	a0,s0,-1104
    30ce:	00003097          	auipc	ra,0x3
    30d2:	b38080e7          	jalr	-1224(ra) # 5c06 <open>
    if(fd < 0)
    30d6:	00054963          	bltz	a0,30e8 <diskfull+0xec>
    close(fd);
    30da:	00003097          	auipc	ra,0x3
    30de:	b14080e7          	jalr	-1260(ra) # 5bee <close>
  for(int i = 0; i < nzz; i++){
    30e2:	2485                	addiw	s1,s1,1
    30e4:	fb3493e3          	bne	s1,s3,308a <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    30e8:	00004517          	auipc	a0,0x4
    30ec:	22850513          	addi	a0,a0,552 # 7310 <malloc+0x12f4>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	b3e080e7          	jalr	-1218(ra) # 5c2e <mkdir>
    30f8:	12050963          	beqz	a0,322a <diskfull+0x22e>
  unlink("diskfulldir");
    30fc:	00004517          	auipc	a0,0x4
    3100:	21450513          	addi	a0,a0,532 # 7310 <malloc+0x12f4>
    3104:	00003097          	auipc	ra,0x3
    3108:	b12080e7          	jalr	-1262(ra) # 5c16 <unlink>
  for(int i = 0; i < nzz; i++){
    310c:	4481                	li	s1,0
    name[0] = 'z';
    310e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3112:	08000993          	li	s3,128
    name[0] = 'z';
    3116:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    311a:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    311e:	41f4d79b          	sraiw	a5,s1,0x1f
    3122:	01b7d71b          	srliw	a4,a5,0x1b
    3126:	009707bb          	addw	a5,a4,s1
    312a:	4057d69b          	sraiw	a3,a5,0x5
    312e:	0306869b          	addiw	a3,a3,48
    3132:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3136:	8bfd                	andi	a5,a5,31
    3138:	9f99                	subw	a5,a5,a4
    313a:	0307879b          	addiw	a5,a5,48
    313e:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3142:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3146:	bb040513          	addi	a0,s0,-1104
    314a:	00003097          	auipc	ra,0x3
    314e:	acc080e7          	jalr	-1332(ra) # 5c16 <unlink>
  for(int i = 0; i < nzz; i++){
    3152:	2485                	addiw	s1,s1,1
    3154:	fd3491e3          	bne	s1,s3,3116 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3158:	03405e63          	blez	s4,3194 <diskfull+0x198>
    315c:	4481                	li	s1,0
    name[0] = 'b';
    315e:	06200a93          	li	s5,98
    name[1] = 'i';
    3162:	06900993          	li	s3,105
    name[2] = 'g';
    3166:	06700913          	li	s2,103
    name[0] = 'b';
    316a:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    316e:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3172:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3176:	0304879b          	addiw	a5,s1,48
    317a:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    317e:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3182:	bb040513          	addi	a0,s0,-1104
    3186:	00003097          	auipc	ra,0x3
    318a:	a90080e7          	jalr	-1392(ra) # 5c16 <unlink>
  for(int i = 0; i < fi; i++){
    318e:	2485                	addiw	s1,s1,1
    3190:	fd449de3          	bne	s1,s4,316a <diskfull+0x16e>
}
    3194:	46813083          	ld	ra,1128(sp)
    3198:	46013403          	ld	s0,1120(sp)
    319c:	45813483          	ld	s1,1112(sp)
    31a0:	45013903          	ld	s2,1104(sp)
    31a4:	44813983          	ld	s3,1096(sp)
    31a8:	44013a03          	ld	s4,1088(sp)
    31ac:	43813a83          	ld	s5,1080(sp)
    31b0:	43013b03          	ld	s6,1072(sp)
    31b4:	42813b83          	ld	s7,1064(sp)
    31b8:	42013c03          	ld	s8,1056(sp)
    31bc:	47010113          	addi	sp,sp,1136
    31c0:	8082                	ret
    close(fd);
    31c2:	854a                	mv	a0,s2
    31c4:	00003097          	auipc	ra,0x3
    31c8:	a2a080e7          	jalr	-1494(ra) # 5bee <close>
  for(fi = 0; done == 0; fi++){
    31cc:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    31ce:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    31d2:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    31d6:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    31da:	030a079b          	addiw	a5,s4,48
    31de:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    31e2:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    31e6:	b9040513          	addi	a0,s0,-1136
    31ea:	00003097          	auipc	ra,0x3
    31ee:	a2c080e7          	jalr	-1492(ra) # 5c16 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    31f2:	60200593          	li	a1,1538
    31f6:	b9040513          	addi	a0,s0,-1136
    31fa:	00003097          	auipc	ra,0x3
    31fe:	a0c080e7          	jalr	-1524(ra) # 5c06 <open>
    3202:	892a                	mv	s2,a0
    if(fd < 0){
    3204:	e40547e3          	bltz	a0,3052 <diskfull+0x56>
    3208:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    320a:	40000613          	li	a2,1024
    320e:	bb040593          	addi	a1,s0,-1104
    3212:	854a                	mv	a0,s2
    3214:	00003097          	auipc	ra,0x3
    3218:	9d2080e7          	jalr	-1582(ra) # 5be6 <write>
    321c:	40000793          	li	a5,1024
    3220:	e4f515e3          	bne	a0,a5,306a <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    3224:	34fd                	addiw	s1,s1,-1
    3226:	f0f5                	bnez	s1,320a <diskfull+0x20e>
    3228:	bf69                	j	31c2 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    322a:	00004517          	auipc	a0,0x4
    322e:	11650513          	addi	a0,a0,278 # 7340 <malloc+0x1324>
    3232:	00003097          	auipc	ra,0x3
    3236:	d2c080e7          	jalr	-724(ra) # 5f5e <printf>
    323a:	b5c9                	j	30fc <diskfull+0x100>

000000000000323c <iputtest>:
{
    323c:	1101                	addi	sp,sp,-32
    323e:	ec06                	sd	ra,24(sp)
    3240:	e822                	sd	s0,16(sp)
    3242:	e426                	sd	s1,8(sp)
    3244:	1000                	addi	s0,sp,32
    3246:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3248:	00004517          	auipc	a0,0x4
    324c:	12850513          	addi	a0,a0,296 # 7370 <malloc+0x1354>
    3250:	00003097          	auipc	ra,0x3
    3254:	9de080e7          	jalr	-1570(ra) # 5c2e <mkdir>
    3258:	04054563          	bltz	a0,32a2 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    325c:	00004517          	auipc	a0,0x4
    3260:	11450513          	addi	a0,a0,276 # 7370 <malloc+0x1354>
    3264:	00003097          	auipc	ra,0x3
    3268:	9d2080e7          	jalr	-1582(ra) # 5c36 <chdir>
    326c:	04054963          	bltz	a0,32be <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    3270:	00004517          	auipc	a0,0x4
    3274:	14050513          	addi	a0,a0,320 # 73b0 <malloc+0x1394>
    3278:	00003097          	auipc	ra,0x3
    327c:	99e080e7          	jalr	-1634(ra) # 5c16 <unlink>
    3280:	04054d63          	bltz	a0,32da <iputtest+0x9e>
  if(chdir("/") < 0){
    3284:	00004517          	auipc	a0,0x4
    3288:	15c50513          	addi	a0,a0,348 # 73e0 <malloc+0x13c4>
    328c:	00003097          	auipc	ra,0x3
    3290:	9aa080e7          	jalr	-1622(ra) # 5c36 <chdir>
    3294:	06054163          	bltz	a0,32f6 <iputtest+0xba>
}
    3298:	60e2                	ld	ra,24(sp)
    329a:	6442                	ld	s0,16(sp)
    329c:	64a2                	ld	s1,8(sp)
    329e:	6105                	addi	sp,sp,32
    32a0:	8082                	ret
    printf("%s: mkdir failed\n", s);
    32a2:	85a6                	mv	a1,s1
    32a4:	00004517          	auipc	a0,0x4
    32a8:	0d450513          	addi	a0,a0,212 # 7378 <malloc+0x135c>
    32ac:	00003097          	auipc	ra,0x3
    32b0:	cb2080e7          	jalr	-846(ra) # 5f5e <printf>
    exit(1);
    32b4:	4505                	li	a0,1
    32b6:	00003097          	auipc	ra,0x3
    32ba:	910080e7          	jalr	-1776(ra) # 5bc6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    32be:	85a6                	mv	a1,s1
    32c0:	00004517          	auipc	a0,0x4
    32c4:	0d050513          	addi	a0,a0,208 # 7390 <malloc+0x1374>
    32c8:	00003097          	auipc	ra,0x3
    32cc:	c96080e7          	jalr	-874(ra) # 5f5e <printf>
    exit(1);
    32d0:	4505                	li	a0,1
    32d2:	00003097          	auipc	ra,0x3
    32d6:	8f4080e7          	jalr	-1804(ra) # 5bc6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    32da:	85a6                	mv	a1,s1
    32dc:	00004517          	auipc	a0,0x4
    32e0:	0e450513          	addi	a0,a0,228 # 73c0 <malloc+0x13a4>
    32e4:	00003097          	auipc	ra,0x3
    32e8:	c7a080e7          	jalr	-902(ra) # 5f5e <printf>
    exit(1);
    32ec:	4505                	li	a0,1
    32ee:	00003097          	auipc	ra,0x3
    32f2:	8d8080e7          	jalr	-1832(ra) # 5bc6 <exit>
    printf("%s: chdir / failed\n", s);
    32f6:	85a6                	mv	a1,s1
    32f8:	00004517          	auipc	a0,0x4
    32fc:	0f050513          	addi	a0,a0,240 # 73e8 <malloc+0x13cc>
    3300:	00003097          	auipc	ra,0x3
    3304:	c5e080e7          	jalr	-930(ra) # 5f5e <printf>
    exit(1);
    3308:	4505                	li	a0,1
    330a:	00003097          	auipc	ra,0x3
    330e:	8bc080e7          	jalr	-1860(ra) # 5bc6 <exit>

0000000000003312 <exitiputtest>:
{
    3312:	7179                	addi	sp,sp,-48
    3314:	f406                	sd	ra,40(sp)
    3316:	f022                	sd	s0,32(sp)
    3318:	ec26                	sd	s1,24(sp)
    331a:	1800                	addi	s0,sp,48
    331c:	84aa                	mv	s1,a0
  pid = fork();
    331e:	00003097          	auipc	ra,0x3
    3322:	8a0080e7          	jalr	-1888(ra) # 5bbe <fork>
  if(pid < 0){
    3326:	04054663          	bltz	a0,3372 <exitiputtest+0x60>
  if(pid == 0){
    332a:	ed45                	bnez	a0,33e2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    332c:	00004517          	auipc	a0,0x4
    3330:	04450513          	addi	a0,a0,68 # 7370 <malloc+0x1354>
    3334:	00003097          	auipc	ra,0x3
    3338:	8fa080e7          	jalr	-1798(ra) # 5c2e <mkdir>
    333c:	04054963          	bltz	a0,338e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3340:	00004517          	auipc	a0,0x4
    3344:	03050513          	addi	a0,a0,48 # 7370 <malloc+0x1354>
    3348:	00003097          	auipc	ra,0x3
    334c:	8ee080e7          	jalr	-1810(ra) # 5c36 <chdir>
    3350:	04054d63          	bltz	a0,33aa <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3354:	00004517          	auipc	a0,0x4
    3358:	05c50513          	addi	a0,a0,92 # 73b0 <malloc+0x1394>
    335c:	00003097          	auipc	ra,0x3
    3360:	8ba080e7          	jalr	-1862(ra) # 5c16 <unlink>
    3364:	06054163          	bltz	a0,33c6 <exitiputtest+0xb4>
    exit(0);
    3368:	4501                	li	a0,0
    336a:	00003097          	auipc	ra,0x3
    336e:	85c080e7          	jalr	-1956(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    3372:	85a6                	mv	a1,s1
    3374:	00003517          	auipc	a0,0x3
    3378:	66c50513          	addi	a0,a0,1644 # 69e0 <malloc+0x9c4>
    337c:	00003097          	auipc	ra,0x3
    3380:	be2080e7          	jalr	-1054(ra) # 5f5e <printf>
    exit(1);
    3384:	4505                	li	a0,1
    3386:	00003097          	auipc	ra,0x3
    338a:	840080e7          	jalr	-1984(ra) # 5bc6 <exit>
      printf("%s: mkdir failed\n", s);
    338e:	85a6                	mv	a1,s1
    3390:	00004517          	auipc	a0,0x4
    3394:	fe850513          	addi	a0,a0,-24 # 7378 <malloc+0x135c>
    3398:	00003097          	auipc	ra,0x3
    339c:	bc6080e7          	jalr	-1082(ra) # 5f5e <printf>
      exit(1);
    33a0:	4505                	li	a0,1
    33a2:	00003097          	auipc	ra,0x3
    33a6:	824080e7          	jalr	-2012(ra) # 5bc6 <exit>
      printf("%s: child chdir failed\n", s);
    33aa:	85a6                	mv	a1,s1
    33ac:	00004517          	auipc	a0,0x4
    33b0:	05450513          	addi	a0,a0,84 # 7400 <malloc+0x13e4>
    33b4:	00003097          	auipc	ra,0x3
    33b8:	baa080e7          	jalr	-1110(ra) # 5f5e <printf>
      exit(1);
    33bc:	4505                	li	a0,1
    33be:	00003097          	auipc	ra,0x3
    33c2:	808080e7          	jalr	-2040(ra) # 5bc6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    33c6:	85a6                	mv	a1,s1
    33c8:	00004517          	auipc	a0,0x4
    33cc:	ff850513          	addi	a0,a0,-8 # 73c0 <malloc+0x13a4>
    33d0:	00003097          	auipc	ra,0x3
    33d4:	b8e080e7          	jalr	-1138(ra) # 5f5e <printf>
      exit(1);
    33d8:	4505                	li	a0,1
    33da:	00002097          	auipc	ra,0x2
    33de:	7ec080e7          	jalr	2028(ra) # 5bc6 <exit>
  wait(&xstatus);
    33e2:	fdc40513          	addi	a0,s0,-36
    33e6:	00002097          	auipc	ra,0x2
    33ea:	7e8080e7          	jalr	2024(ra) # 5bce <wait>
  exit(xstatus);
    33ee:	fdc42503          	lw	a0,-36(s0)
    33f2:	00002097          	auipc	ra,0x2
    33f6:	7d4080e7          	jalr	2004(ra) # 5bc6 <exit>

00000000000033fa <dirtest>:
{
    33fa:	1101                	addi	sp,sp,-32
    33fc:	ec06                	sd	ra,24(sp)
    33fe:	e822                	sd	s0,16(sp)
    3400:	e426                	sd	s1,8(sp)
    3402:	1000                	addi	s0,sp,32
    3404:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3406:	00004517          	auipc	a0,0x4
    340a:	01250513          	addi	a0,a0,18 # 7418 <malloc+0x13fc>
    340e:	00003097          	auipc	ra,0x3
    3412:	820080e7          	jalr	-2016(ra) # 5c2e <mkdir>
    3416:	04054563          	bltz	a0,3460 <dirtest+0x66>
  if(chdir("dir0") < 0){
    341a:	00004517          	auipc	a0,0x4
    341e:	ffe50513          	addi	a0,a0,-2 # 7418 <malloc+0x13fc>
    3422:	00003097          	auipc	ra,0x3
    3426:	814080e7          	jalr	-2028(ra) # 5c36 <chdir>
    342a:	04054963          	bltz	a0,347c <dirtest+0x82>
  if(chdir("..") < 0){
    342e:	00004517          	auipc	a0,0x4
    3432:	00a50513          	addi	a0,a0,10 # 7438 <malloc+0x141c>
    3436:	00003097          	auipc	ra,0x3
    343a:	800080e7          	jalr	-2048(ra) # 5c36 <chdir>
    343e:	04054d63          	bltz	a0,3498 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3442:	00004517          	auipc	a0,0x4
    3446:	fd650513          	addi	a0,a0,-42 # 7418 <malloc+0x13fc>
    344a:	00002097          	auipc	ra,0x2
    344e:	7cc080e7          	jalr	1996(ra) # 5c16 <unlink>
    3452:	06054163          	bltz	a0,34b4 <dirtest+0xba>
}
    3456:	60e2                	ld	ra,24(sp)
    3458:	6442                	ld	s0,16(sp)
    345a:	64a2                	ld	s1,8(sp)
    345c:	6105                	addi	sp,sp,32
    345e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3460:	85a6                	mv	a1,s1
    3462:	00004517          	auipc	a0,0x4
    3466:	f1650513          	addi	a0,a0,-234 # 7378 <malloc+0x135c>
    346a:	00003097          	auipc	ra,0x3
    346e:	af4080e7          	jalr	-1292(ra) # 5f5e <printf>
    exit(1);
    3472:	4505                	li	a0,1
    3474:	00002097          	auipc	ra,0x2
    3478:	752080e7          	jalr	1874(ra) # 5bc6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    347c:	85a6                	mv	a1,s1
    347e:	00004517          	auipc	a0,0x4
    3482:	fa250513          	addi	a0,a0,-94 # 7420 <malloc+0x1404>
    3486:	00003097          	auipc	ra,0x3
    348a:	ad8080e7          	jalr	-1320(ra) # 5f5e <printf>
    exit(1);
    348e:	4505                	li	a0,1
    3490:	00002097          	auipc	ra,0x2
    3494:	736080e7          	jalr	1846(ra) # 5bc6 <exit>
    printf("%s: chdir .. failed\n", s);
    3498:	85a6                	mv	a1,s1
    349a:	00004517          	auipc	a0,0x4
    349e:	fa650513          	addi	a0,a0,-90 # 7440 <malloc+0x1424>
    34a2:	00003097          	auipc	ra,0x3
    34a6:	abc080e7          	jalr	-1348(ra) # 5f5e <printf>
    exit(1);
    34aa:	4505                	li	a0,1
    34ac:	00002097          	auipc	ra,0x2
    34b0:	71a080e7          	jalr	1818(ra) # 5bc6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    34b4:	85a6                	mv	a1,s1
    34b6:	00004517          	auipc	a0,0x4
    34ba:	fa250513          	addi	a0,a0,-94 # 7458 <malloc+0x143c>
    34be:	00003097          	auipc	ra,0x3
    34c2:	aa0080e7          	jalr	-1376(ra) # 5f5e <printf>
    exit(1);
    34c6:	4505                	li	a0,1
    34c8:	00002097          	auipc	ra,0x2
    34cc:	6fe080e7          	jalr	1790(ra) # 5bc6 <exit>

00000000000034d0 <subdir>:
{
    34d0:	1101                	addi	sp,sp,-32
    34d2:	ec06                	sd	ra,24(sp)
    34d4:	e822                	sd	s0,16(sp)
    34d6:	e426                	sd	s1,8(sp)
    34d8:	e04a                	sd	s2,0(sp)
    34da:	1000                	addi	s0,sp,32
    34dc:	892a                	mv	s2,a0
  unlink("ff");
    34de:	00004517          	auipc	a0,0x4
    34e2:	0c250513          	addi	a0,a0,194 # 75a0 <malloc+0x1584>
    34e6:	00002097          	auipc	ra,0x2
    34ea:	730080e7          	jalr	1840(ra) # 5c16 <unlink>
  if(mkdir("dd") != 0){
    34ee:	00004517          	auipc	a0,0x4
    34f2:	f8250513          	addi	a0,a0,-126 # 7470 <malloc+0x1454>
    34f6:	00002097          	auipc	ra,0x2
    34fa:	738080e7          	jalr	1848(ra) # 5c2e <mkdir>
    34fe:	38051663          	bnez	a0,388a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3502:	20200593          	li	a1,514
    3506:	00004517          	auipc	a0,0x4
    350a:	f8a50513          	addi	a0,a0,-118 # 7490 <malloc+0x1474>
    350e:	00002097          	auipc	ra,0x2
    3512:	6f8080e7          	jalr	1784(ra) # 5c06 <open>
    3516:	84aa                	mv	s1,a0
  if(fd < 0){
    3518:	38054763          	bltz	a0,38a6 <subdir+0x3d6>
  write(fd, "ff", 2);
    351c:	4609                	li	a2,2
    351e:	00004597          	auipc	a1,0x4
    3522:	08258593          	addi	a1,a1,130 # 75a0 <malloc+0x1584>
    3526:	00002097          	auipc	ra,0x2
    352a:	6c0080e7          	jalr	1728(ra) # 5be6 <write>
  close(fd);
    352e:	8526                	mv	a0,s1
    3530:	00002097          	auipc	ra,0x2
    3534:	6be080e7          	jalr	1726(ra) # 5bee <close>
  if(unlink("dd") >= 0){
    3538:	00004517          	auipc	a0,0x4
    353c:	f3850513          	addi	a0,a0,-200 # 7470 <malloc+0x1454>
    3540:	00002097          	auipc	ra,0x2
    3544:	6d6080e7          	jalr	1750(ra) # 5c16 <unlink>
    3548:	36055d63          	bgez	a0,38c2 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    354c:	00004517          	auipc	a0,0x4
    3550:	f9c50513          	addi	a0,a0,-100 # 74e8 <malloc+0x14cc>
    3554:	00002097          	auipc	ra,0x2
    3558:	6da080e7          	jalr	1754(ra) # 5c2e <mkdir>
    355c:	38051163          	bnez	a0,38de <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3560:	20200593          	li	a1,514
    3564:	00004517          	auipc	a0,0x4
    3568:	fac50513          	addi	a0,a0,-84 # 7510 <malloc+0x14f4>
    356c:	00002097          	auipc	ra,0x2
    3570:	69a080e7          	jalr	1690(ra) # 5c06 <open>
    3574:	84aa                	mv	s1,a0
  if(fd < 0){
    3576:	38054263          	bltz	a0,38fa <subdir+0x42a>
  write(fd, "FF", 2);
    357a:	4609                	li	a2,2
    357c:	00004597          	auipc	a1,0x4
    3580:	fc458593          	addi	a1,a1,-60 # 7540 <malloc+0x1524>
    3584:	00002097          	auipc	ra,0x2
    3588:	662080e7          	jalr	1634(ra) # 5be6 <write>
  close(fd);
    358c:	8526                	mv	a0,s1
    358e:	00002097          	auipc	ra,0x2
    3592:	660080e7          	jalr	1632(ra) # 5bee <close>
  fd = open("dd/dd/../ff", 0);
    3596:	4581                	li	a1,0
    3598:	00004517          	auipc	a0,0x4
    359c:	fb050513          	addi	a0,a0,-80 # 7548 <malloc+0x152c>
    35a0:	00002097          	auipc	ra,0x2
    35a4:	666080e7          	jalr	1638(ra) # 5c06 <open>
    35a8:	84aa                	mv	s1,a0
  if(fd < 0){
    35aa:	36054663          	bltz	a0,3916 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    35ae:	660d                	lui	a2,0x3
    35b0:	00009597          	auipc	a1,0x9
    35b4:	67858593          	addi	a1,a1,1656 # cc28 <buf>
    35b8:	00002097          	auipc	ra,0x2
    35bc:	626080e7          	jalr	1574(ra) # 5bde <read>
  if(cc != 2 || buf[0] != 'f'){
    35c0:	4789                	li	a5,2
    35c2:	36f51863          	bne	a0,a5,3932 <subdir+0x462>
    35c6:	00009717          	auipc	a4,0x9
    35ca:	66274703          	lbu	a4,1634(a4) # cc28 <buf>
    35ce:	06600793          	li	a5,102
    35d2:	36f71063          	bne	a4,a5,3932 <subdir+0x462>
  close(fd);
    35d6:	8526                	mv	a0,s1
    35d8:	00002097          	auipc	ra,0x2
    35dc:	616080e7          	jalr	1558(ra) # 5bee <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    35e0:	00004597          	auipc	a1,0x4
    35e4:	fb858593          	addi	a1,a1,-72 # 7598 <malloc+0x157c>
    35e8:	00004517          	auipc	a0,0x4
    35ec:	f2850513          	addi	a0,a0,-216 # 7510 <malloc+0x14f4>
    35f0:	00002097          	auipc	ra,0x2
    35f4:	636080e7          	jalr	1590(ra) # 5c26 <link>
    35f8:	34051b63          	bnez	a0,394e <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    35fc:	00004517          	auipc	a0,0x4
    3600:	f1450513          	addi	a0,a0,-236 # 7510 <malloc+0x14f4>
    3604:	00002097          	auipc	ra,0x2
    3608:	612080e7          	jalr	1554(ra) # 5c16 <unlink>
    360c:	34051f63          	bnez	a0,396a <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3610:	4581                	li	a1,0
    3612:	00004517          	auipc	a0,0x4
    3616:	efe50513          	addi	a0,a0,-258 # 7510 <malloc+0x14f4>
    361a:	00002097          	auipc	ra,0x2
    361e:	5ec080e7          	jalr	1516(ra) # 5c06 <open>
    3622:	36055263          	bgez	a0,3986 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3626:	00004517          	auipc	a0,0x4
    362a:	e4a50513          	addi	a0,a0,-438 # 7470 <malloc+0x1454>
    362e:	00002097          	auipc	ra,0x2
    3632:	608080e7          	jalr	1544(ra) # 5c36 <chdir>
    3636:	36051663          	bnez	a0,39a2 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    363a:	00004517          	auipc	a0,0x4
    363e:	ff650513          	addi	a0,a0,-10 # 7630 <malloc+0x1614>
    3642:	00002097          	auipc	ra,0x2
    3646:	5f4080e7          	jalr	1524(ra) # 5c36 <chdir>
    364a:	36051a63          	bnez	a0,39be <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    364e:	00004517          	auipc	a0,0x4
    3652:	01250513          	addi	a0,a0,18 # 7660 <malloc+0x1644>
    3656:	00002097          	auipc	ra,0x2
    365a:	5e0080e7          	jalr	1504(ra) # 5c36 <chdir>
    365e:	36051e63          	bnez	a0,39da <subdir+0x50a>
  if(chdir("./..") != 0){
    3662:	00004517          	auipc	a0,0x4
    3666:	02e50513          	addi	a0,a0,46 # 7690 <malloc+0x1674>
    366a:	00002097          	auipc	ra,0x2
    366e:	5cc080e7          	jalr	1484(ra) # 5c36 <chdir>
    3672:	38051263          	bnez	a0,39f6 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3676:	4581                	li	a1,0
    3678:	00004517          	auipc	a0,0x4
    367c:	f2050513          	addi	a0,a0,-224 # 7598 <malloc+0x157c>
    3680:	00002097          	auipc	ra,0x2
    3684:	586080e7          	jalr	1414(ra) # 5c06 <open>
    3688:	84aa                	mv	s1,a0
  if(fd < 0){
    368a:	38054463          	bltz	a0,3a12 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    368e:	660d                	lui	a2,0x3
    3690:	00009597          	auipc	a1,0x9
    3694:	59858593          	addi	a1,a1,1432 # cc28 <buf>
    3698:	00002097          	auipc	ra,0x2
    369c:	546080e7          	jalr	1350(ra) # 5bde <read>
    36a0:	4789                	li	a5,2
    36a2:	38f51663          	bne	a0,a5,3a2e <subdir+0x55e>
  close(fd);
    36a6:	8526                	mv	a0,s1
    36a8:	00002097          	auipc	ra,0x2
    36ac:	546080e7          	jalr	1350(ra) # 5bee <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    36b0:	4581                	li	a1,0
    36b2:	00004517          	auipc	a0,0x4
    36b6:	e5e50513          	addi	a0,a0,-418 # 7510 <malloc+0x14f4>
    36ba:	00002097          	auipc	ra,0x2
    36be:	54c080e7          	jalr	1356(ra) # 5c06 <open>
    36c2:	38055463          	bgez	a0,3a4a <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    36c6:	20200593          	li	a1,514
    36ca:	00004517          	auipc	a0,0x4
    36ce:	05650513          	addi	a0,a0,86 # 7720 <malloc+0x1704>
    36d2:	00002097          	auipc	ra,0x2
    36d6:	534080e7          	jalr	1332(ra) # 5c06 <open>
    36da:	38055663          	bgez	a0,3a66 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    36de:	20200593          	li	a1,514
    36e2:	00004517          	auipc	a0,0x4
    36e6:	06e50513          	addi	a0,a0,110 # 7750 <malloc+0x1734>
    36ea:	00002097          	auipc	ra,0x2
    36ee:	51c080e7          	jalr	1308(ra) # 5c06 <open>
    36f2:	38055863          	bgez	a0,3a82 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    36f6:	20000593          	li	a1,512
    36fa:	00004517          	auipc	a0,0x4
    36fe:	d7650513          	addi	a0,a0,-650 # 7470 <malloc+0x1454>
    3702:	00002097          	auipc	ra,0x2
    3706:	504080e7          	jalr	1284(ra) # 5c06 <open>
    370a:	38055a63          	bgez	a0,3a9e <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    370e:	4589                	li	a1,2
    3710:	00004517          	auipc	a0,0x4
    3714:	d6050513          	addi	a0,a0,-672 # 7470 <malloc+0x1454>
    3718:	00002097          	auipc	ra,0x2
    371c:	4ee080e7          	jalr	1262(ra) # 5c06 <open>
    3720:	38055d63          	bgez	a0,3aba <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3724:	4585                	li	a1,1
    3726:	00004517          	auipc	a0,0x4
    372a:	d4a50513          	addi	a0,a0,-694 # 7470 <malloc+0x1454>
    372e:	00002097          	auipc	ra,0x2
    3732:	4d8080e7          	jalr	1240(ra) # 5c06 <open>
    3736:	3a055063          	bgez	a0,3ad6 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    373a:	00004597          	auipc	a1,0x4
    373e:	0a658593          	addi	a1,a1,166 # 77e0 <malloc+0x17c4>
    3742:	00004517          	auipc	a0,0x4
    3746:	fde50513          	addi	a0,a0,-34 # 7720 <malloc+0x1704>
    374a:	00002097          	auipc	ra,0x2
    374e:	4dc080e7          	jalr	1244(ra) # 5c26 <link>
    3752:	3a050063          	beqz	a0,3af2 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3756:	00004597          	auipc	a1,0x4
    375a:	08a58593          	addi	a1,a1,138 # 77e0 <malloc+0x17c4>
    375e:	00004517          	auipc	a0,0x4
    3762:	ff250513          	addi	a0,a0,-14 # 7750 <malloc+0x1734>
    3766:	00002097          	auipc	ra,0x2
    376a:	4c0080e7          	jalr	1216(ra) # 5c26 <link>
    376e:	3a050063          	beqz	a0,3b0e <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3772:	00004597          	auipc	a1,0x4
    3776:	e2658593          	addi	a1,a1,-474 # 7598 <malloc+0x157c>
    377a:	00004517          	auipc	a0,0x4
    377e:	d1650513          	addi	a0,a0,-746 # 7490 <malloc+0x1474>
    3782:	00002097          	auipc	ra,0x2
    3786:	4a4080e7          	jalr	1188(ra) # 5c26 <link>
    378a:	3a050063          	beqz	a0,3b2a <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    378e:	00004517          	auipc	a0,0x4
    3792:	f9250513          	addi	a0,a0,-110 # 7720 <malloc+0x1704>
    3796:	00002097          	auipc	ra,0x2
    379a:	498080e7          	jalr	1176(ra) # 5c2e <mkdir>
    379e:	3a050463          	beqz	a0,3b46 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    37a2:	00004517          	auipc	a0,0x4
    37a6:	fae50513          	addi	a0,a0,-82 # 7750 <malloc+0x1734>
    37aa:	00002097          	auipc	ra,0x2
    37ae:	484080e7          	jalr	1156(ra) # 5c2e <mkdir>
    37b2:	3a050863          	beqz	a0,3b62 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    37b6:	00004517          	auipc	a0,0x4
    37ba:	de250513          	addi	a0,a0,-542 # 7598 <malloc+0x157c>
    37be:	00002097          	auipc	ra,0x2
    37c2:	470080e7          	jalr	1136(ra) # 5c2e <mkdir>
    37c6:	3a050c63          	beqz	a0,3b7e <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    37ca:	00004517          	auipc	a0,0x4
    37ce:	f8650513          	addi	a0,a0,-122 # 7750 <malloc+0x1734>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	444080e7          	jalr	1092(ra) # 5c16 <unlink>
    37da:	3c050063          	beqz	a0,3b9a <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    37de:	00004517          	auipc	a0,0x4
    37e2:	f4250513          	addi	a0,a0,-190 # 7720 <malloc+0x1704>
    37e6:	00002097          	auipc	ra,0x2
    37ea:	430080e7          	jalr	1072(ra) # 5c16 <unlink>
    37ee:	3c050463          	beqz	a0,3bb6 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    37f2:	00004517          	auipc	a0,0x4
    37f6:	c9e50513          	addi	a0,a0,-866 # 7490 <malloc+0x1474>
    37fa:	00002097          	auipc	ra,0x2
    37fe:	43c080e7          	jalr	1084(ra) # 5c36 <chdir>
    3802:	3c050863          	beqz	a0,3bd2 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3806:	00004517          	auipc	a0,0x4
    380a:	12a50513          	addi	a0,a0,298 # 7930 <malloc+0x1914>
    380e:	00002097          	auipc	ra,0x2
    3812:	428080e7          	jalr	1064(ra) # 5c36 <chdir>
    3816:	3c050c63          	beqz	a0,3bee <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    381a:	00004517          	auipc	a0,0x4
    381e:	d7e50513          	addi	a0,a0,-642 # 7598 <malloc+0x157c>
    3822:	00002097          	auipc	ra,0x2
    3826:	3f4080e7          	jalr	1012(ra) # 5c16 <unlink>
    382a:	3e051063          	bnez	a0,3c0a <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    382e:	00004517          	auipc	a0,0x4
    3832:	c6250513          	addi	a0,a0,-926 # 7490 <malloc+0x1474>
    3836:	00002097          	auipc	ra,0x2
    383a:	3e0080e7          	jalr	992(ra) # 5c16 <unlink>
    383e:	3e051463          	bnez	a0,3c26 <subdir+0x756>
  if(unlink("dd") == 0){
    3842:	00004517          	auipc	a0,0x4
    3846:	c2e50513          	addi	a0,a0,-978 # 7470 <malloc+0x1454>
    384a:	00002097          	auipc	ra,0x2
    384e:	3cc080e7          	jalr	972(ra) # 5c16 <unlink>
    3852:	3e050863          	beqz	a0,3c42 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3856:	00004517          	auipc	a0,0x4
    385a:	14a50513          	addi	a0,a0,330 # 79a0 <malloc+0x1984>
    385e:	00002097          	auipc	ra,0x2
    3862:	3b8080e7          	jalr	952(ra) # 5c16 <unlink>
    3866:	3e054c63          	bltz	a0,3c5e <subdir+0x78e>
  if(unlink("dd") < 0){
    386a:	00004517          	auipc	a0,0x4
    386e:	c0650513          	addi	a0,a0,-1018 # 7470 <malloc+0x1454>
    3872:	00002097          	auipc	ra,0x2
    3876:	3a4080e7          	jalr	932(ra) # 5c16 <unlink>
    387a:	40054063          	bltz	a0,3c7a <subdir+0x7aa>
}
    387e:	60e2                	ld	ra,24(sp)
    3880:	6442                	ld	s0,16(sp)
    3882:	64a2                	ld	s1,8(sp)
    3884:	6902                	ld	s2,0(sp)
    3886:	6105                	addi	sp,sp,32
    3888:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    388a:	85ca                	mv	a1,s2
    388c:	00004517          	auipc	a0,0x4
    3890:	bec50513          	addi	a0,a0,-1044 # 7478 <malloc+0x145c>
    3894:	00002097          	auipc	ra,0x2
    3898:	6ca080e7          	jalr	1738(ra) # 5f5e <printf>
    exit(1);
    389c:	4505                	li	a0,1
    389e:	00002097          	auipc	ra,0x2
    38a2:	328080e7          	jalr	808(ra) # 5bc6 <exit>
    printf("%s: create dd/ff failed\n", s);
    38a6:	85ca                	mv	a1,s2
    38a8:	00004517          	auipc	a0,0x4
    38ac:	bf050513          	addi	a0,a0,-1040 # 7498 <malloc+0x147c>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	6ae080e7          	jalr	1710(ra) # 5f5e <printf>
    exit(1);
    38b8:	4505                	li	a0,1
    38ba:	00002097          	auipc	ra,0x2
    38be:	30c080e7          	jalr	780(ra) # 5bc6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    38c2:	85ca                	mv	a1,s2
    38c4:	00004517          	auipc	a0,0x4
    38c8:	bf450513          	addi	a0,a0,-1036 # 74b8 <malloc+0x149c>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	692080e7          	jalr	1682(ra) # 5f5e <printf>
    exit(1);
    38d4:	4505                	li	a0,1
    38d6:	00002097          	auipc	ra,0x2
    38da:	2f0080e7          	jalr	752(ra) # 5bc6 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    38de:	85ca                	mv	a1,s2
    38e0:	00004517          	auipc	a0,0x4
    38e4:	c1050513          	addi	a0,a0,-1008 # 74f0 <malloc+0x14d4>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	676080e7          	jalr	1654(ra) # 5f5e <printf>
    exit(1);
    38f0:	4505                	li	a0,1
    38f2:	00002097          	auipc	ra,0x2
    38f6:	2d4080e7          	jalr	724(ra) # 5bc6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    38fa:	85ca                	mv	a1,s2
    38fc:	00004517          	auipc	a0,0x4
    3900:	c2450513          	addi	a0,a0,-988 # 7520 <malloc+0x1504>
    3904:	00002097          	auipc	ra,0x2
    3908:	65a080e7          	jalr	1626(ra) # 5f5e <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	00002097          	auipc	ra,0x2
    3912:	2b8080e7          	jalr	696(ra) # 5bc6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3916:	85ca                	mv	a1,s2
    3918:	00004517          	auipc	a0,0x4
    391c:	c4050513          	addi	a0,a0,-960 # 7558 <malloc+0x153c>
    3920:	00002097          	auipc	ra,0x2
    3924:	63e080e7          	jalr	1598(ra) # 5f5e <printf>
    exit(1);
    3928:	4505                	li	a0,1
    392a:	00002097          	auipc	ra,0x2
    392e:	29c080e7          	jalr	668(ra) # 5bc6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3932:	85ca                	mv	a1,s2
    3934:	00004517          	auipc	a0,0x4
    3938:	c4450513          	addi	a0,a0,-956 # 7578 <malloc+0x155c>
    393c:	00002097          	auipc	ra,0x2
    3940:	622080e7          	jalr	1570(ra) # 5f5e <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	00002097          	auipc	ra,0x2
    394a:	280080e7          	jalr	640(ra) # 5bc6 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    394e:	85ca                	mv	a1,s2
    3950:	00004517          	auipc	a0,0x4
    3954:	c5850513          	addi	a0,a0,-936 # 75a8 <malloc+0x158c>
    3958:	00002097          	auipc	ra,0x2
    395c:	606080e7          	jalr	1542(ra) # 5f5e <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	00002097          	auipc	ra,0x2
    3966:	264080e7          	jalr	612(ra) # 5bc6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    396a:	85ca                	mv	a1,s2
    396c:	00004517          	auipc	a0,0x4
    3970:	c6450513          	addi	a0,a0,-924 # 75d0 <malloc+0x15b4>
    3974:	00002097          	auipc	ra,0x2
    3978:	5ea080e7          	jalr	1514(ra) # 5f5e <printf>
    exit(1);
    397c:	4505                	li	a0,1
    397e:	00002097          	auipc	ra,0x2
    3982:	248080e7          	jalr	584(ra) # 5bc6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3986:	85ca                	mv	a1,s2
    3988:	00004517          	auipc	a0,0x4
    398c:	c6850513          	addi	a0,a0,-920 # 75f0 <malloc+0x15d4>
    3990:	00002097          	auipc	ra,0x2
    3994:	5ce080e7          	jalr	1486(ra) # 5f5e <printf>
    exit(1);
    3998:	4505                	li	a0,1
    399a:	00002097          	auipc	ra,0x2
    399e:	22c080e7          	jalr	556(ra) # 5bc6 <exit>
    printf("%s: chdir dd failed\n", s);
    39a2:	85ca                	mv	a1,s2
    39a4:	00004517          	auipc	a0,0x4
    39a8:	c7450513          	addi	a0,a0,-908 # 7618 <malloc+0x15fc>
    39ac:	00002097          	auipc	ra,0x2
    39b0:	5b2080e7          	jalr	1458(ra) # 5f5e <printf>
    exit(1);
    39b4:	4505                	li	a0,1
    39b6:	00002097          	auipc	ra,0x2
    39ba:	210080e7          	jalr	528(ra) # 5bc6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    39be:	85ca                	mv	a1,s2
    39c0:	00004517          	auipc	a0,0x4
    39c4:	c8050513          	addi	a0,a0,-896 # 7640 <malloc+0x1624>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	596080e7          	jalr	1430(ra) # 5f5e <printf>
    exit(1);
    39d0:	4505                	li	a0,1
    39d2:	00002097          	auipc	ra,0x2
    39d6:	1f4080e7          	jalr	500(ra) # 5bc6 <exit>
    printf("chdir dd/../../dd failed\n", s);
    39da:	85ca                	mv	a1,s2
    39dc:	00004517          	auipc	a0,0x4
    39e0:	c9450513          	addi	a0,a0,-876 # 7670 <malloc+0x1654>
    39e4:	00002097          	auipc	ra,0x2
    39e8:	57a080e7          	jalr	1402(ra) # 5f5e <printf>
    exit(1);
    39ec:	4505                	li	a0,1
    39ee:	00002097          	auipc	ra,0x2
    39f2:	1d8080e7          	jalr	472(ra) # 5bc6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    39f6:	85ca                	mv	a1,s2
    39f8:	00004517          	auipc	a0,0x4
    39fc:	ca050513          	addi	a0,a0,-864 # 7698 <malloc+0x167c>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	55e080e7          	jalr	1374(ra) # 5f5e <printf>
    exit(1);
    3a08:	4505                	li	a0,1
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	1bc080e7          	jalr	444(ra) # 5bc6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3a12:	85ca                	mv	a1,s2
    3a14:	00004517          	auipc	a0,0x4
    3a18:	c9c50513          	addi	a0,a0,-868 # 76b0 <malloc+0x1694>
    3a1c:	00002097          	auipc	ra,0x2
    3a20:	542080e7          	jalr	1346(ra) # 5f5e <printf>
    exit(1);
    3a24:	4505                	li	a0,1
    3a26:	00002097          	auipc	ra,0x2
    3a2a:	1a0080e7          	jalr	416(ra) # 5bc6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3a2e:	85ca                	mv	a1,s2
    3a30:	00004517          	auipc	a0,0x4
    3a34:	ca050513          	addi	a0,a0,-864 # 76d0 <malloc+0x16b4>
    3a38:	00002097          	auipc	ra,0x2
    3a3c:	526080e7          	jalr	1318(ra) # 5f5e <printf>
    exit(1);
    3a40:	4505                	li	a0,1
    3a42:	00002097          	auipc	ra,0x2
    3a46:	184080e7          	jalr	388(ra) # 5bc6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3a4a:	85ca                	mv	a1,s2
    3a4c:	00004517          	auipc	a0,0x4
    3a50:	ca450513          	addi	a0,a0,-860 # 76f0 <malloc+0x16d4>
    3a54:	00002097          	auipc	ra,0x2
    3a58:	50a080e7          	jalr	1290(ra) # 5f5e <printf>
    exit(1);
    3a5c:	4505                	li	a0,1
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	168080e7          	jalr	360(ra) # 5bc6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3a66:	85ca                	mv	a1,s2
    3a68:	00004517          	auipc	a0,0x4
    3a6c:	cc850513          	addi	a0,a0,-824 # 7730 <malloc+0x1714>
    3a70:	00002097          	auipc	ra,0x2
    3a74:	4ee080e7          	jalr	1262(ra) # 5f5e <printf>
    exit(1);
    3a78:	4505                	li	a0,1
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	14c080e7          	jalr	332(ra) # 5bc6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3a82:	85ca                	mv	a1,s2
    3a84:	00004517          	auipc	a0,0x4
    3a88:	cdc50513          	addi	a0,a0,-804 # 7760 <malloc+0x1744>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	4d2080e7          	jalr	1234(ra) # 5f5e <printf>
    exit(1);
    3a94:	4505                	li	a0,1
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	130080e7          	jalr	304(ra) # 5bc6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3a9e:	85ca                	mv	a1,s2
    3aa0:	00004517          	auipc	a0,0x4
    3aa4:	ce050513          	addi	a0,a0,-800 # 7780 <malloc+0x1764>
    3aa8:	00002097          	auipc	ra,0x2
    3aac:	4b6080e7          	jalr	1206(ra) # 5f5e <printf>
    exit(1);
    3ab0:	4505                	li	a0,1
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	114080e7          	jalr	276(ra) # 5bc6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3aba:	85ca                	mv	a1,s2
    3abc:	00004517          	auipc	a0,0x4
    3ac0:	ce450513          	addi	a0,a0,-796 # 77a0 <malloc+0x1784>
    3ac4:	00002097          	auipc	ra,0x2
    3ac8:	49a080e7          	jalr	1178(ra) # 5f5e <printf>
    exit(1);
    3acc:	4505                	li	a0,1
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	0f8080e7          	jalr	248(ra) # 5bc6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3ad6:	85ca                	mv	a1,s2
    3ad8:	00004517          	auipc	a0,0x4
    3adc:	ce850513          	addi	a0,a0,-792 # 77c0 <malloc+0x17a4>
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	47e080e7          	jalr	1150(ra) # 5f5e <printf>
    exit(1);
    3ae8:	4505                	li	a0,1
    3aea:	00002097          	auipc	ra,0x2
    3aee:	0dc080e7          	jalr	220(ra) # 5bc6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3af2:	85ca                	mv	a1,s2
    3af4:	00004517          	auipc	a0,0x4
    3af8:	cfc50513          	addi	a0,a0,-772 # 77f0 <malloc+0x17d4>
    3afc:	00002097          	auipc	ra,0x2
    3b00:	462080e7          	jalr	1122(ra) # 5f5e <printf>
    exit(1);
    3b04:	4505                	li	a0,1
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	0c0080e7          	jalr	192(ra) # 5bc6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3b0e:	85ca                	mv	a1,s2
    3b10:	00004517          	auipc	a0,0x4
    3b14:	d0850513          	addi	a0,a0,-760 # 7818 <malloc+0x17fc>
    3b18:	00002097          	auipc	ra,0x2
    3b1c:	446080e7          	jalr	1094(ra) # 5f5e <printf>
    exit(1);
    3b20:	4505                	li	a0,1
    3b22:	00002097          	auipc	ra,0x2
    3b26:	0a4080e7          	jalr	164(ra) # 5bc6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3b2a:	85ca                	mv	a1,s2
    3b2c:	00004517          	auipc	a0,0x4
    3b30:	d1450513          	addi	a0,a0,-748 # 7840 <malloc+0x1824>
    3b34:	00002097          	auipc	ra,0x2
    3b38:	42a080e7          	jalr	1066(ra) # 5f5e <printf>
    exit(1);
    3b3c:	4505                	li	a0,1
    3b3e:	00002097          	auipc	ra,0x2
    3b42:	088080e7          	jalr	136(ra) # 5bc6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3b46:	85ca                	mv	a1,s2
    3b48:	00004517          	auipc	a0,0x4
    3b4c:	d2050513          	addi	a0,a0,-736 # 7868 <malloc+0x184c>
    3b50:	00002097          	auipc	ra,0x2
    3b54:	40e080e7          	jalr	1038(ra) # 5f5e <printf>
    exit(1);
    3b58:	4505                	li	a0,1
    3b5a:	00002097          	auipc	ra,0x2
    3b5e:	06c080e7          	jalr	108(ra) # 5bc6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3b62:	85ca                	mv	a1,s2
    3b64:	00004517          	auipc	a0,0x4
    3b68:	d2450513          	addi	a0,a0,-732 # 7888 <malloc+0x186c>
    3b6c:	00002097          	auipc	ra,0x2
    3b70:	3f2080e7          	jalr	1010(ra) # 5f5e <printf>
    exit(1);
    3b74:	4505                	li	a0,1
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	050080e7          	jalr	80(ra) # 5bc6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3b7e:	85ca                	mv	a1,s2
    3b80:	00004517          	auipc	a0,0x4
    3b84:	d2850513          	addi	a0,a0,-728 # 78a8 <malloc+0x188c>
    3b88:	00002097          	auipc	ra,0x2
    3b8c:	3d6080e7          	jalr	982(ra) # 5f5e <printf>
    exit(1);
    3b90:	4505                	li	a0,1
    3b92:	00002097          	auipc	ra,0x2
    3b96:	034080e7          	jalr	52(ra) # 5bc6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3b9a:	85ca                	mv	a1,s2
    3b9c:	00004517          	auipc	a0,0x4
    3ba0:	d3450513          	addi	a0,a0,-716 # 78d0 <malloc+0x18b4>
    3ba4:	00002097          	auipc	ra,0x2
    3ba8:	3ba080e7          	jalr	954(ra) # 5f5e <printf>
    exit(1);
    3bac:	4505                	li	a0,1
    3bae:	00002097          	auipc	ra,0x2
    3bb2:	018080e7          	jalr	24(ra) # 5bc6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3bb6:	85ca                	mv	a1,s2
    3bb8:	00004517          	auipc	a0,0x4
    3bbc:	d3850513          	addi	a0,a0,-712 # 78f0 <malloc+0x18d4>
    3bc0:	00002097          	auipc	ra,0x2
    3bc4:	39e080e7          	jalr	926(ra) # 5f5e <printf>
    exit(1);
    3bc8:	4505                	li	a0,1
    3bca:	00002097          	auipc	ra,0x2
    3bce:	ffc080e7          	jalr	-4(ra) # 5bc6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3bd2:	85ca                	mv	a1,s2
    3bd4:	00004517          	auipc	a0,0x4
    3bd8:	d3c50513          	addi	a0,a0,-708 # 7910 <malloc+0x18f4>
    3bdc:	00002097          	auipc	ra,0x2
    3be0:	382080e7          	jalr	898(ra) # 5f5e <printf>
    exit(1);
    3be4:	4505                	li	a0,1
    3be6:	00002097          	auipc	ra,0x2
    3bea:	fe0080e7          	jalr	-32(ra) # 5bc6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3bee:	85ca                	mv	a1,s2
    3bf0:	00004517          	auipc	a0,0x4
    3bf4:	d4850513          	addi	a0,a0,-696 # 7938 <malloc+0x191c>
    3bf8:	00002097          	auipc	ra,0x2
    3bfc:	366080e7          	jalr	870(ra) # 5f5e <printf>
    exit(1);
    3c00:	4505                	li	a0,1
    3c02:	00002097          	auipc	ra,0x2
    3c06:	fc4080e7          	jalr	-60(ra) # 5bc6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3c0a:	85ca                	mv	a1,s2
    3c0c:	00004517          	auipc	a0,0x4
    3c10:	9c450513          	addi	a0,a0,-1596 # 75d0 <malloc+0x15b4>
    3c14:	00002097          	auipc	ra,0x2
    3c18:	34a080e7          	jalr	842(ra) # 5f5e <printf>
    exit(1);
    3c1c:	4505                	li	a0,1
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	fa8080e7          	jalr	-88(ra) # 5bc6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3c26:	85ca                	mv	a1,s2
    3c28:	00004517          	auipc	a0,0x4
    3c2c:	d3050513          	addi	a0,a0,-720 # 7958 <malloc+0x193c>
    3c30:	00002097          	auipc	ra,0x2
    3c34:	32e080e7          	jalr	814(ra) # 5f5e <printf>
    exit(1);
    3c38:	4505                	li	a0,1
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	f8c080e7          	jalr	-116(ra) # 5bc6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3c42:	85ca                	mv	a1,s2
    3c44:	00004517          	auipc	a0,0x4
    3c48:	d3450513          	addi	a0,a0,-716 # 7978 <malloc+0x195c>
    3c4c:	00002097          	auipc	ra,0x2
    3c50:	312080e7          	jalr	786(ra) # 5f5e <printf>
    exit(1);
    3c54:	4505                	li	a0,1
    3c56:	00002097          	auipc	ra,0x2
    3c5a:	f70080e7          	jalr	-144(ra) # 5bc6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3c5e:	85ca                	mv	a1,s2
    3c60:	00004517          	auipc	a0,0x4
    3c64:	d4850513          	addi	a0,a0,-696 # 79a8 <malloc+0x198c>
    3c68:	00002097          	auipc	ra,0x2
    3c6c:	2f6080e7          	jalr	758(ra) # 5f5e <printf>
    exit(1);
    3c70:	4505                	li	a0,1
    3c72:	00002097          	auipc	ra,0x2
    3c76:	f54080e7          	jalr	-172(ra) # 5bc6 <exit>
    printf("%s: unlink dd failed\n", s);
    3c7a:	85ca                	mv	a1,s2
    3c7c:	00004517          	auipc	a0,0x4
    3c80:	d4c50513          	addi	a0,a0,-692 # 79c8 <malloc+0x19ac>
    3c84:	00002097          	auipc	ra,0x2
    3c88:	2da080e7          	jalr	730(ra) # 5f5e <printf>
    exit(1);
    3c8c:	4505                	li	a0,1
    3c8e:	00002097          	auipc	ra,0x2
    3c92:	f38080e7          	jalr	-200(ra) # 5bc6 <exit>

0000000000003c96 <rmdot>:
{
    3c96:	1101                	addi	sp,sp,-32
    3c98:	ec06                	sd	ra,24(sp)
    3c9a:	e822                	sd	s0,16(sp)
    3c9c:	e426                	sd	s1,8(sp)
    3c9e:	1000                	addi	s0,sp,32
    3ca0:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3ca2:	00004517          	auipc	a0,0x4
    3ca6:	d3e50513          	addi	a0,a0,-706 # 79e0 <malloc+0x19c4>
    3caa:	00002097          	auipc	ra,0x2
    3cae:	f84080e7          	jalr	-124(ra) # 5c2e <mkdir>
    3cb2:	e549                	bnez	a0,3d3c <rmdot+0xa6>
  if(chdir("dots") != 0){
    3cb4:	00004517          	auipc	a0,0x4
    3cb8:	d2c50513          	addi	a0,a0,-724 # 79e0 <malloc+0x19c4>
    3cbc:	00002097          	auipc	ra,0x2
    3cc0:	f7a080e7          	jalr	-134(ra) # 5c36 <chdir>
    3cc4:	e951                	bnez	a0,3d58 <rmdot+0xc2>
  if(unlink(".") == 0){
    3cc6:	00003517          	auipc	a0,0x3
    3cca:	b7a50513          	addi	a0,a0,-1158 # 6840 <malloc+0x824>
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	f48080e7          	jalr	-184(ra) # 5c16 <unlink>
    3cd6:	cd59                	beqz	a0,3d74 <rmdot+0xde>
  if(unlink("..") == 0){
    3cd8:	00003517          	auipc	a0,0x3
    3cdc:	76050513          	addi	a0,a0,1888 # 7438 <malloc+0x141c>
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	f36080e7          	jalr	-202(ra) # 5c16 <unlink>
    3ce8:	c545                	beqz	a0,3d90 <rmdot+0xfa>
  if(chdir("/") != 0){
    3cea:	00003517          	auipc	a0,0x3
    3cee:	6f650513          	addi	a0,a0,1782 # 73e0 <malloc+0x13c4>
    3cf2:	00002097          	auipc	ra,0x2
    3cf6:	f44080e7          	jalr	-188(ra) # 5c36 <chdir>
    3cfa:	e94d                	bnez	a0,3dac <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3cfc:	00004517          	auipc	a0,0x4
    3d00:	d4c50513          	addi	a0,a0,-692 # 7a48 <malloc+0x1a2c>
    3d04:	00002097          	auipc	ra,0x2
    3d08:	f12080e7          	jalr	-238(ra) # 5c16 <unlink>
    3d0c:	cd55                	beqz	a0,3dc8 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3d0e:	00004517          	auipc	a0,0x4
    3d12:	d6250513          	addi	a0,a0,-670 # 7a70 <malloc+0x1a54>
    3d16:	00002097          	auipc	ra,0x2
    3d1a:	f00080e7          	jalr	-256(ra) # 5c16 <unlink>
    3d1e:	c179                	beqz	a0,3de4 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3d20:	00004517          	auipc	a0,0x4
    3d24:	cc050513          	addi	a0,a0,-832 # 79e0 <malloc+0x19c4>
    3d28:	00002097          	auipc	ra,0x2
    3d2c:	eee080e7          	jalr	-274(ra) # 5c16 <unlink>
    3d30:	e961                	bnez	a0,3e00 <rmdot+0x16a>
}
    3d32:	60e2                	ld	ra,24(sp)
    3d34:	6442                	ld	s0,16(sp)
    3d36:	64a2                	ld	s1,8(sp)
    3d38:	6105                	addi	sp,sp,32
    3d3a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3d3c:	85a6                	mv	a1,s1
    3d3e:	00004517          	auipc	a0,0x4
    3d42:	caa50513          	addi	a0,a0,-854 # 79e8 <malloc+0x19cc>
    3d46:	00002097          	auipc	ra,0x2
    3d4a:	218080e7          	jalr	536(ra) # 5f5e <printf>
    exit(1);
    3d4e:	4505                	li	a0,1
    3d50:	00002097          	auipc	ra,0x2
    3d54:	e76080e7          	jalr	-394(ra) # 5bc6 <exit>
    printf("%s: chdir dots failed\n", s);
    3d58:	85a6                	mv	a1,s1
    3d5a:	00004517          	auipc	a0,0x4
    3d5e:	ca650513          	addi	a0,a0,-858 # 7a00 <malloc+0x19e4>
    3d62:	00002097          	auipc	ra,0x2
    3d66:	1fc080e7          	jalr	508(ra) # 5f5e <printf>
    exit(1);
    3d6a:	4505                	li	a0,1
    3d6c:	00002097          	auipc	ra,0x2
    3d70:	e5a080e7          	jalr	-422(ra) # 5bc6 <exit>
    printf("%s: rm . worked!\n", s);
    3d74:	85a6                	mv	a1,s1
    3d76:	00004517          	auipc	a0,0x4
    3d7a:	ca250513          	addi	a0,a0,-862 # 7a18 <malloc+0x19fc>
    3d7e:	00002097          	auipc	ra,0x2
    3d82:	1e0080e7          	jalr	480(ra) # 5f5e <printf>
    exit(1);
    3d86:	4505                	li	a0,1
    3d88:	00002097          	auipc	ra,0x2
    3d8c:	e3e080e7          	jalr	-450(ra) # 5bc6 <exit>
    printf("%s: rm .. worked!\n", s);
    3d90:	85a6                	mv	a1,s1
    3d92:	00004517          	auipc	a0,0x4
    3d96:	c9e50513          	addi	a0,a0,-866 # 7a30 <malloc+0x1a14>
    3d9a:	00002097          	auipc	ra,0x2
    3d9e:	1c4080e7          	jalr	452(ra) # 5f5e <printf>
    exit(1);
    3da2:	4505                	li	a0,1
    3da4:	00002097          	auipc	ra,0x2
    3da8:	e22080e7          	jalr	-478(ra) # 5bc6 <exit>
    printf("%s: chdir / failed\n", s);
    3dac:	85a6                	mv	a1,s1
    3dae:	00003517          	auipc	a0,0x3
    3db2:	63a50513          	addi	a0,a0,1594 # 73e8 <malloc+0x13cc>
    3db6:	00002097          	auipc	ra,0x2
    3dba:	1a8080e7          	jalr	424(ra) # 5f5e <printf>
    exit(1);
    3dbe:	4505                	li	a0,1
    3dc0:	00002097          	auipc	ra,0x2
    3dc4:	e06080e7          	jalr	-506(ra) # 5bc6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3dc8:	85a6                	mv	a1,s1
    3dca:	00004517          	auipc	a0,0x4
    3dce:	c8650513          	addi	a0,a0,-890 # 7a50 <malloc+0x1a34>
    3dd2:	00002097          	auipc	ra,0x2
    3dd6:	18c080e7          	jalr	396(ra) # 5f5e <printf>
    exit(1);
    3dda:	4505                	li	a0,1
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	dea080e7          	jalr	-534(ra) # 5bc6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3de4:	85a6                	mv	a1,s1
    3de6:	00004517          	auipc	a0,0x4
    3dea:	c9250513          	addi	a0,a0,-878 # 7a78 <malloc+0x1a5c>
    3dee:	00002097          	auipc	ra,0x2
    3df2:	170080e7          	jalr	368(ra) # 5f5e <printf>
    exit(1);
    3df6:	4505                	li	a0,1
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	dce080e7          	jalr	-562(ra) # 5bc6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3e00:	85a6                	mv	a1,s1
    3e02:	00004517          	auipc	a0,0x4
    3e06:	c9650513          	addi	a0,a0,-874 # 7a98 <malloc+0x1a7c>
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	154080e7          	jalr	340(ra) # 5f5e <printf>
    exit(1);
    3e12:	4505                	li	a0,1
    3e14:	00002097          	auipc	ra,0x2
    3e18:	db2080e7          	jalr	-590(ra) # 5bc6 <exit>

0000000000003e1c <dirfile>:
{
    3e1c:	1101                	addi	sp,sp,-32
    3e1e:	ec06                	sd	ra,24(sp)
    3e20:	e822                	sd	s0,16(sp)
    3e22:	e426                	sd	s1,8(sp)
    3e24:	e04a                	sd	s2,0(sp)
    3e26:	1000                	addi	s0,sp,32
    3e28:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3e2a:	20000593          	li	a1,512
    3e2e:	00004517          	auipc	a0,0x4
    3e32:	c8a50513          	addi	a0,a0,-886 # 7ab8 <malloc+0x1a9c>
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	dd0080e7          	jalr	-560(ra) # 5c06 <open>
  if(fd < 0){
    3e3e:	0e054d63          	bltz	a0,3f38 <dirfile+0x11c>
  close(fd);
    3e42:	00002097          	auipc	ra,0x2
    3e46:	dac080e7          	jalr	-596(ra) # 5bee <close>
  if(chdir("dirfile") == 0){
    3e4a:	00004517          	auipc	a0,0x4
    3e4e:	c6e50513          	addi	a0,a0,-914 # 7ab8 <malloc+0x1a9c>
    3e52:	00002097          	auipc	ra,0x2
    3e56:	de4080e7          	jalr	-540(ra) # 5c36 <chdir>
    3e5a:	cd6d                	beqz	a0,3f54 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3e5c:	4581                	li	a1,0
    3e5e:	00004517          	auipc	a0,0x4
    3e62:	ca250513          	addi	a0,a0,-862 # 7b00 <malloc+0x1ae4>
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	da0080e7          	jalr	-608(ra) # 5c06 <open>
  if(fd >= 0){
    3e6e:	10055163          	bgez	a0,3f70 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3e72:	20000593          	li	a1,512
    3e76:	00004517          	auipc	a0,0x4
    3e7a:	c8a50513          	addi	a0,a0,-886 # 7b00 <malloc+0x1ae4>
    3e7e:	00002097          	auipc	ra,0x2
    3e82:	d88080e7          	jalr	-632(ra) # 5c06 <open>
  if(fd >= 0){
    3e86:	10055363          	bgez	a0,3f8c <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3e8a:	00004517          	auipc	a0,0x4
    3e8e:	c7650513          	addi	a0,a0,-906 # 7b00 <malloc+0x1ae4>
    3e92:	00002097          	auipc	ra,0x2
    3e96:	d9c080e7          	jalr	-612(ra) # 5c2e <mkdir>
    3e9a:	10050763          	beqz	a0,3fa8 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3e9e:	00004517          	auipc	a0,0x4
    3ea2:	c6250513          	addi	a0,a0,-926 # 7b00 <malloc+0x1ae4>
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	d70080e7          	jalr	-656(ra) # 5c16 <unlink>
    3eae:	10050b63          	beqz	a0,3fc4 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3eb2:	00004597          	auipc	a1,0x4
    3eb6:	c4e58593          	addi	a1,a1,-946 # 7b00 <malloc+0x1ae4>
    3eba:	00002517          	auipc	a0,0x2
    3ebe:	47650513          	addi	a0,a0,1142 # 6330 <malloc+0x314>
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	d64080e7          	jalr	-668(ra) # 5c26 <link>
    3eca:	10050b63          	beqz	a0,3fe0 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3ece:	00004517          	auipc	a0,0x4
    3ed2:	bea50513          	addi	a0,a0,-1046 # 7ab8 <malloc+0x1a9c>
    3ed6:	00002097          	auipc	ra,0x2
    3eda:	d40080e7          	jalr	-704(ra) # 5c16 <unlink>
    3ede:	10051f63          	bnez	a0,3ffc <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3ee2:	4589                	li	a1,2
    3ee4:	00003517          	auipc	a0,0x3
    3ee8:	95c50513          	addi	a0,a0,-1700 # 6840 <malloc+0x824>
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	d1a080e7          	jalr	-742(ra) # 5c06 <open>
  if(fd >= 0){
    3ef4:	12055263          	bgez	a0,4018 <dirfile+0x1fc>
  fd = open(".", 0);
    3ef8:	4581                	li	a1,0
    3efa:	00003517          	auipc	a0,0x3
    3efe:	94650513          	addi	a0,a0,-1722 # 6840 <malloc+0x824>
    3f02:	00002097          	auipc	ra,0x2
    3f06:	d04080e7          	jalr	-764(ra) # 5c06 <open>
    3f0a:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3f0c:	4605                	li	a2,1
    3f0e:	00002597          	auipc	a1,0x2
    3f12:	2ba58593          	addi	a1,a1,698 # 61c8 <malloc+0x1ac>
    3f16:	00002097          	auipc	ra,0x2
    3f1a:	cd0080e7          	jalr	-816(ra) # 5be6 <write>
    3f1e:	10a04b63          	bgtz	a0,4034 <dirfile+0x218>
  close(fd);
    3f22:	8526                	mv	a0,s1
    3f24:	00002097          	auipc	ra,0x2
    3f28:	cca080e7          	jalr	-822(ra) # 5bee <close>
}
    3f2c:	60e2                	ld	ra,24(sp)
    3f2e:	6442                	ld	s0,16(sp)
    3f30:	64a2                	ld	s1,8(sp)
    3f32:	6902                	ld	s2,0(sp)
    3f34:	6105                	addi	sp,sp,32
    3f36:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3f38:	85ca                	mv	a1,s2
    3f3a:	00004517          	auipc	a0,0x4
    3f3e:	b8650513          	addi	a0,a0,-1146 # 7ac0 <malloc+0x1aa4>
    3f42:	00002097          	auipc	ra,0x2
    3f46:	01c080e7          	jalr	28(ra) # 5f5e <printf>
    exit(1);
    3f4a:	4505                	li	a0,1
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	c7a080e7          	jalr	-902(ra) # 5bc6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3f54:	85ca                	mv	a1,s2
    3f56:	00004517          	auipc	a0,0x4
    3f5a:	b8a50513          	addi	a0,a0,-1142 # 7ae0 <malloc+0x1ac4>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	000080e7          	jalr	ra # 5f5e <printf>
    exit(1);
    3f66:	4505                	li	a0,1
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	c5e080e7          	jalr	-930(ra) # 5bc6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3f70:	85ca                	mv	a1,s2
    3f72:	00004517          	auipc	a0,0x4
    3f76:	b9e50513          	addi	a0,a0,-1122 # 7b10 <malloc+0x1af4>
    3f7a:	00002097          	auipc	ra,0x2
    3f7e:	fe4080e7          	jalr	-28(ra) # 5f5e <printf>
    exit(1);
    3f82:	4505                	li	a0,1
    3f84:	00002097          	auipc	ra,0x2
    3f88:	c42080e7          	jalr	-958(ra) # 5bc6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3f8c:	85ca                	mv	a1,s2
    3f8e:	00004517          	auipc	a0,0x4
    3f92:	b8250513          	addi	a0,a0,-1150 # 7b10 <malloc+0x1af4>
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	fc8080e7          	jalr	-56(ra) # 5f5e <printf>
    exit(1);
    3f9e:	4505                	li	a0,1
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	c26080e7          	jalr	-986(ra) # 5bc6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3fa8:	85ca                	mv	a1,s2
    3faa:	00004517          	auipc	a0,0x4
    3fae:	b8e50513          	addi	a0,a0,-1138 # 7b38 <malloc+0x1b1c>
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	fac080e7          	jalr	-84(ra) # 5f5e <printf>
    exit(1);
    3fba:	4505                	li	a0,1
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	c0a080e7          	jalr	-1014(ra) # 5bc6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3fc4:	85ca                	mv	a1,s2
    3fc6:	00004517          	auipc	a0,0x4
    3fca:	b9a50513          	addi	a0,a0,-1126 # 7b60 <malloc+0x1b44>
    3fce:	00002097          	auipc	ra,0x2
    3fd2:	f90080e7          	jalr	-112(ra) # 5f5e <printf>
    exit(1);
    3fd6:	4505                	li	a0,1
    3fd8:	00002097          	auipc	ra,0x2
    3fdc:	bee080e7          	jalr	-1042(ra) # 5bc6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3fe0:	85ca                	mv	a1,s2
    3fe2:	00004517          	auipc	a0,0x4
    3fe6:	ba650513          	addi	a0,a0,-1114 # 7b88 <malloc+0x1b6c>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	f74080e7          	jalr	-140(ra) # 5f5e <printf>
    exit(1);
    3ff2:	4505                	li	a0,1
    3ff4:	00002097          	auipc	ra,0x2
    3ff8:	bd2080e7          	jalr	-1070(ra) # 5bc6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3ffc:	85ca                	mv	a1,s2
    3ffe:	00004517          	auipc	a0,0x4
    4002:	bb250513          	addi	a0,a0,-1102 # 7bb0 <malloc+0x1b94>
    4006:	00002097          	auipc	ra,0x2
    400a:	f58080e7          	jalr	-168(ra) # 5f5e <printf>
    exit(1);
    400e:	4505                	li	a0,1
    4010:	00002097          	auipc	ra,0x2
    4014:	bb6080e7          	jalr	-1098(ra) # 5bc6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4018:	85ca                	mv	a1,s2
    401a:	00004517          	auipc	a0,0x4
    401e:	bb650513          	addi	a0,a0,-1098 # 7bd0 <malloc+0x1bb4>
    4022:	00002097          	auipc	ra,0x2
    4026:	f3c080e7          	jalr	-196(ra) # 5f5e <printf>
    exit(1);
    402a:	4505                	li	a0,1
    402c:	00002097          	auipc	ra,0x2
    4030:	b9a080e7          	jalr	-1126(ra) # 5bc6 <exit>
    printf("%s: write . succeeded!\n", s);
    4034:	85ca                	mv	a1,s2
    4036:	00004517          	auipc	a0,0x4
    403a:	bc250513          	addi	a0,a0,-1086 # 7bf8 <malloc+0x1bdc>
    403e:	00002097          	auipc	ra,0x2
    4042:	f20080e7          	jalr	-224(ra) # 5f5e <printf>
    exit(1);
    4046:	4505                	li	a0,1
    4048:	00002097          	auipc	ra,0x2
    404c:	b7e080e7          	jalr	-1154(ra) # 5bc6 <exit>

0000000000004050 <iref>:
{
    4050:	7139                	addi	sp,sp,-64
    4052:	fc06                	sd	ra,56(sp)
    4054:	f822                	sd	s0,48(sp)
    4056:	f426                	sd	s1,40(sp)
    4058:	f04a                	sd	s2,32(sp)
    405a:	ec4e                	sd	s3,24(sp)
    405c:	e852                	sd	s4,16(sp)
    405e:	e456                	sd	s5,8(sp)
    4060:	e05a                	sd	s6,0(sp)
    4062:	0080                	addi	s0,sp,64
    4064:	8b2a                	mv	s6,a0
    4066:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    406a:	00004a17          	auipc	s4,0x4
    406e:	ba6a0a13          	addi	s4,s4,-1114 # 7c10 <malloc+0x1bf4>
    mkdir("");
    4072:	00003497          	auipc	s1,0x3
    4076:	6a648493          	addi	s1,s1,1702 # 7718 <malloc+0x16fc>
    link("README", "");
    407a:	00002a97          	auipc	s5,0x2
    407e:	2b6a8a93          	addi	s5,s5,694 # 6330 <malloc+0x314>
    fd = open("xx", O_CREATE);
    4082:	00004997          	auipc	s3,0x4
    4086:	a8698993          	addi	s3,s3,-1402 # 7b08 <malloc+0x1aec>
    408a:	a891                	j	40de <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    408c:	85da                	mv	a1,s6
    408e:	00004517          	auipc	a0,0x4
    4092:	b8a50513          	addi	a0,a0,-1142 # 7c18 <malloc+0x1bfc>
    4096:	00002097          	auipc	ra,0x2
    409a:	ec8080e7          	jalr	-312(ra) # 5f5e <printf>
      exit(1);
    409e:	4505                	li	a0,1
    40a0:	00002097          	auipc	ra,0x2
    40a4:	b26080e7          	jalr	-1242(ra) # 5bc6 <exit>
      printf("%s: chdir irefd failed\n", s);
    40a8:	85da                	mv	a1,s6
    40aa:	00004517          	auipc	a0,0x4
    40ae:	b8650513          	addi	a0,a0,-1146 # 7c30 <malloc+0x1c14>
    40b2:	00002097          	auipc	ra,0x2
    40b6:	eac080e7          	jalr	-340(ra) # 5f5e <printf>
      exit(1);
    40ba:	4505                	li	a0,1
    40bc:	00002097          	auipc	ra,0x2
    40c0:	b0a080e7          	jalr	-1270(ra) # 5bc6 <exit>
      close(fd);
    40c4:	00002097          	auipc	ra,0x2
    40c8:	b2a080e7          	jalr	-1238(ra) # 5bee <close>
    40cc:	a889                	j	411e <iref+0xce>
    unlink("xx");
    40ce:	854e                	mv	a0,s3
    40d0:	00002097          	auipc	ra,0x2
    40d4:	b46080e7          	jalr	-1210(ra) # 5c16 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    40d8:	397d                	addiw	s2,s2,-1
    40da:	06090063          	beqz	s2,413a <iref+0xea>
    if(mkdir("irefd") != 0){
    40de:	8552                	mv	a0,s4
    40e0:	00002097          	auipc	ra,0x2
    40e4:	b4e080e7          	jalr	-1202(ra) # 5c2e <mkdir>
    40e8:	f155                	bnez	a0,408c <iref+0x3c>
    if(chdir("irefd") != 0){
    40ea:	8552                	mv	a0,s4
    40ec:	00002097          	auipc	ra,0x2
    40f0:	b4a080e7          	jalr	-1206(ra) # 5c36 <chdir>
    40f4:	f955                	bnez	a0,40a8 <iref+0x58>
    mkdir("");
    40f6:	8526                	mv	a0,s1
    40f8:	00002097          	auipc	ra,0x2
    40fc:	b36080e7          	jalr	-1226(ra) # 5c2e <mkdir>
    link("README", "");
    4100:	85a6                	mv	a1,s1
    4102:	8556                	mv	a0,s5
    4104:	00002097          	auipc	ra,0x2
    4108:	b22080e7          	jalr	-1246(ra) # 5c26 <link>
    fd = open("", O_CREATE);
    410c:	20000593          	li	a1,512
    4110:	8526                	mv	a0,s1
    4112:	00002097          	auipc	ra,0x2
    4116:	af4080e7          	jalr	-1292(ra) # 5c06 <open>
    if(fd >= 0)
    411a:	fa0555e3          	bgez	a0,40c4 <iref+0x74>
    fd = open("xx", O_CREATE);
    411e:	20000593          	li	a1,512
    4122:	854e                	mv	a0,s3
    4124:	00002097          	auipc	ra,0x2
    4128:	ae2080e7          	jalr	-1310(ra) # 5c06 <open>
    if(fd >= 0)
    412c:	fa0541e3          	bltz	a0,40ce <iref+0x7e>
      close(fd);
    4130:	00002097          	auipc	ra,0x2
    4134:	abe080e7          	jalr	-1346(ra) # 5bee <close>
    4138:	bf59                	j	40ce <iref+0x7e>
    413a:	03300493          	li	s1,51
    chdir("..");
    413e:	00003997          	auipc	s3,0x3
    4142:	2fa98993          	addi	s3,s3,762 # 7438 <malloc+0x141c>
    unlink("irefd");
    4146:	00004917          	auipc	s2,0x4
    414a:	aca90913          	addi	s2,s2,-1334 # 7c10 <malloc+0x1bf4>
    chdir("..");
    414e:	854e                	mv	a0,s3
    4150:	00002097          	auipc	ra,0x2
    4154:	ae6080e7          	jalr	-1306(ra) # 5c36 <chdir>
    unlink("irefd");
    4158:	854a                	mv	a0,s2
    415a:	00002097          	auipc	ra,0x2
    415e:	abc080e7          	jalr	-1348(ra) # 5c16 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4162:	34fd                	addiw	s1,s1,-1
    4164:	f4ed                	bnez	s1,414e <iref+0xfe>
  chdir("/");
    4166:	00003517          	auipc	a0,0x3
    416a:	27a50513          	addi	a0,a0,634 # 73e0 <malloc+0x13c4>
    416e:	00002097          	auipc	ra,0x2
    4172:	ac8080e7          	jalr	-1336(ra) # 5c36 <chdir>
}
    4176:	70e2                	ld	ra,56(sp)
    4178:	7442                	ld	s0,48(sp)
    417a:	74a2                	ld	s1,40(sp)
    417c:	7902                	ld	s2,32(sp)
    417e:	69e2                	ld	s3,24(sp)
    4180:	6a42                	ld	s4,16(sp)
    4182:	6aa2                	ld	s5,8(sp)
    4184:	6b02                	ld	s6,0(sp)
    4186:	6121                	addi	sp,sp,64
    4188:	8082                	ret

000000000000418a <openiputtest>:
{
    418a:	7179                	addi	sp,sp,-48
    418c:	f406                	sd	ra,40(sp)
    418e:	f022                	sd	s0,32(sp)
    4190:	ec26                	sd	s1,24(sp)
    4192:	1800                	addi	s0,sp,48
    4194:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4196:	00004517          	auipc	a0,0x4
    419a:	ab250513          	addi	a0,a0,-1358 # 7c48 <malloc+0x1c2c>
    419e:	00002097          	auipc	ra,0x2
    41a2:	a90080e7          	jalr	-1392(ra) # 5c2e <mkdir>
    41a6:	04054263          	bltz	a0,41ea <openiputtest+0x60>
  pid = fork();
    41aa:	00002097          	auipc	ra,0x2
    41ae:	a14080e7          	jalr	-1516(ra) # 5bbe <fork>
  if(pid < 0){
    41b2:	04054a63          	bltz	a0,4206 <openiputtest+0x7c>
  if(pid == 0){
    41b6:	e93d                	bnez	a0,422c <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    41b8:	4589                	li	a1,2
    41ba:	00004517          	auipc	a0,0x4
    41be:	a8e50513          	addi	a0,a0,-1394 # 7c48 <malloc+0x1c2c>
    41c2:	00002097          	auipc	ra,0x2
    41c6:	a44080e7          	jalr	-1468(ra) # 5c06 <open>
    if(fd >= 0){
    41ca:	04054c63          	bltz	a0,4222 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    41ce:	85a6                	mv	a1,s1
    41d0:	00004517          	auipc	a0,0x4
    41d4:	a9850513          	addi	a0,a0,-1384 # 7c68 <malloc+0x1c4c>
    41d8:	00002097          	auipc	ra,0x2
    41dc:	d86080e7          	jalr	-634(ra) # 5f5e <printf>
      exit(1);
    41e0:	4505                	li	a0,1
    41e2:	00002097          	auipc	ra,0x2
    41e6:	9e4080e7          	jalr	-1564(ra) # 5bc6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    41ea:	85a6                	mv	a1,s1
    41ec:	00004517          	auipc	a0,0x4
    41f0:	a6450513          	addi	a0,a0,-1436 # 7c50 <malloc+0x1c34>
    41f4:	00002097          	auipc	ra,0x2
    41f8:	d6a080e7          	jalr	-662(ra) # 5f5e <printf>
    exit(1);
    41fc:	4505                	li	a0,1
    41fe:	00002097          	auipc	ra,0x2
    4202:	9c8080e7          	jalr	-1592(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    4206:	85a6                	mv	a1,s1
    4208:	00002517          	auipc	a0,0x2
    420c:	7d850513          	addi	a0,a0,2008 # 69e0 <malloc+0x9c4>
    4210:	00002097          	auipc	ra,0x2
    4214:	d4e080e7          	jalr	-690(ra) # 5f5e <printf>
    exit(1);
    4218:	4505                	li	a0,1
    421a:	00002097          	auipc	ra,0x2
    421e:	9ac080e7          	jalr	-1620(ra) # 5bc6 <exit>
    exit(0);
    4222:	4501                	li	a0,0
    4224:	00002097          	auipc	ra,0x2
    4228:	9a2080e7          	jalr	-1630(ra) # 5bc6 <exit>
  sleep(1);
    422c:	4505                	li	a0,1
    422e:	00002097          	auipc	ra,0x2
    4232:	a28080e7          	jalr	-1496(ra) # 5c56 <sleep>
  if(unlink("oidir") != 0){
    4236:	00004517          	auipc	a0,0x4
    423a:	a1250513          	addi	a0,a0,-1518 # 7c48 <malloc+0x1c2c>
    423e:	00002097          	auipc	ra,0x2
    4242:	9d8080e7          	jalr	-1576(ra) # 5c16 <unlink>
    4246:	cd19                	beqz	a0,4264 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4248:	85a6                	mv	a1,s1
    424a:	00003517          	auipc	a0,0x3
    424e:	95650513          	addi	a0,a0,-1706 # 6ba0 <malloc+0xb84>
    4252:	00002097          	auipc	ra,0x2
    4256:	d0c080e7          	jalr	-756(ra) # 5f5e <printf>
    exit(1);
    425a:	4505                	li	a0,1
    425c:	00002097          	auipc	ra,0x2
    4260:	96a080e7          	jalr	-1686(ra) # 5bc6 <exit>
  wait(&xstatus);
    4264:	fdc40513          	addi	a0,s0,-36
    4268:	00002097          	auipc	ra,0x2
    426c:	966080e7          	jalr	-1690(ra) # 5bce <wait>
  exit(xstatus);
    4270:	fdc42503          	lw	a0,-36(s0)
    4274:	00002097          	auipc	ra,0x2
    4278:	952080e7          	jalr	-1710(ra) # 5bc6 <exit>

000000000000427c <killstatus>:
{
    427c:	7139                	addi	sp,sp,-64
    427e:	fc06                	sd	ra,56(sp)
    4280:	f822                	sd	s0,48(sp)
    4282:	f426                	sd	s1,40(sp)
    4284:	f04a                	sd	s2,32(sp)
    4286:	ec4e                	sd	s3,24(sp)
    4288:	e852                	sd	s4,16(sp)
    428a:	0080                	addi	s0,sp,64
    428c:	8a2a                	mv	s4,a0
    428e:	06400913          	li	s2,100
    if(xst != -1) {
    4292:	59fd                	li	s3,-1
    int pid1 = fork();
    4294:	00002097          	auipc	ra,0x2
    4298:	92a080e7          	jalr	-1750(ra) # 5bbe <fork>
    429c:	84aa                	mv	s1,a0
    if(pid1 < 0){
    429e:	02054f63          	bltz	a0,42dc <killstatus+0x60>
    if(pid1 == 0){
    42a2:	c939                	beqz	a0,42f8 <killstatus+0x7c>
    sleep(1);
    42a4:	4505                	li	a0,1
    42a6:	00002097          	auipc	ra,0x2
    42aa:	9b0080e7          	jalr	-1616(ra) # 5c56 <sleep>
    kill(pid1);
    42ae:	8526                	mv	a0,s1
    42b0:	00002097          	auipc	ra,0x2
    42b4:	946080e7          	jalr	-1722(ra) # 5bf6 <kill>
    wait(&xst);
    42b8:	fcc40513          	addi	a0,s0,-52
    42bc:	00002097          	auipc	ra,0x2
    42c0:	912080e7          	jalr	-1774(ra) # 5bce <wait>
    if(xst != -1) {
    42c4:	fcc42783          	lw	a5,-52(s0)
    42c8:	03379d63          	bne	a5,s3,4302 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    42cc:	397d                	addiw	s2,s2,-1
    42ce:	fc0913e3          	bnez	s2,4294 <killstatus+0x18>
  exit(0);
    42d2:	4501                	li	a0,0
    42d4:	00002097          	auipc	ra,0x2
    42d8:	8f2080e7          	jalr	-1806(ra) # 5bc6 <exit>
      printf("%s: fork failed\n", s);
    42dc:	85d2                	mv	a1,s4
    42de:	00002517          	auipc	a0,0x2
    42e2:	70250513          	addi	a0,a0,1794 # 69e0 <malloc+0x9c4>
    42e6:	00002097          	auipc	ra,0x2
    42ea:	c78080e7          	jalr	-904(ra) # 5f5e <printf>
      exit(1);
    42ee:	4505                	li	a0,1
    42f0:	00002097          	auipc	ra,0x2
    42f4:	8d6080e7          	jalr	-1834(ra) # 5bc6 <exit>
        getpid();
    42f8:	00002097          	auipc	ra,0x2
    42fc:	94e080e7          	jalr	-1714(ra) # 5c46 <getpid>
      while(1) {
    4300:	bfe5                	j	42f8 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4302:	85d2                	mv	a1,s4
    4304:	00004517          	auipc	a0,0x4
    4308:	98c50513          	addi	a0,a0,-1652 # 7c90 <malloc+0x1c74>
    430c:	00002097          	auipc	ra,0x2
    4310:	c52080e7          	jalr	-942(ra) # 5f5e <printf>
       exit(1);
    4314:	4505                	li	a0,1
    4316:	00002097          	auipc	ra,0x2
    431a:	8b0080e7          	jalr	-1872(ra) # 5bc6 <exit>

000000000000431e <preempt>:
{
    431e:	7139                	addi	sp,sp,-64
    4320:	fc06                	sd	ra,56(sp)
    4322:	f822                	sd	s0,48(sp)
    4324:	f426                	sd	s1,40(sp)
    4326:	f04a                	sd	s2,32(sp)
    4328:	ec4e                	sd	s3,24(sp)
    432a:	e852                	sd	s4,16(sp)
    432c:	0080                	addi	s0,sp,64
    432e:	892a                	mv	s2,a0
  pid1 = fork();
    4330:	00002097          	auipc	ra,0x2
    4334:	88e080e7          	jalr	-1906(ra) # 5bbe <fork>
  if(pid1 < 0) {
    4338:	00054563          	bltz	a0,4342 <preempt+0x24>
    433c:	84aa                	mv	s1,a0
  if(pid1 == 0)
    433e:	e105                	bnez	a0,435e <preempt+0x40>
    for(;;)
    4340:	a001                	j	4340 <preempt+0x22>
    printf("%s: fork failed", s);
    4342:	85ca                	mv	a1,s2
    4344:	00004517          	auipc	a0,0x4
    4348:	96c50513          	addi	a0,a0,-1684 # 7cb0 <malloc+0x1c94>
    434c:	00002097          	auipc	ra,0x2
    4350:	c12080e7          	jalr	-1006(ra) # 5f5e <printf>
    exit(1);
    4354:	4505                	li	a0,1
    4356:	00002097          	auipc	ra,0x2
    435a:	870080e7          	jalr	-1936(ra) # 5bc6 <exit>
  pid2 = fork();
    435e:	00002097          	auipc	ra,0x2
    4362:	860080e7          	jalr	-1952(ra) # 5bbe <fork>
    4366:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4368:	00054463          	bltz	a0,4370 <preempt+0x52>
  if(pid2 == 0)
    436c:	e105                	bnez	a0,438c <preempt+0x6e>
    for(;;)
    436e:	a001                	j	436e <preempt+0x50>
    printf("%s: fork failed\n", s);
    4370:	85ca                	mv	a1,s2
    4372:	00002517          	auipc	a0,0x2
    4376:	66e50513          	addi	a0,a0,1646 # 69e0 <malloc+0x9c4>
    437a:	00002097          	auipc	ra,0x2
    437e:	be4080e7          	jalr	-1052(ra) # 5f5e <printf>
    exit(1);
    4382:	4505                	li	a0,1
    4384:	00002097          	auipc	ra,0x2
    4388:	842080e7          	jalr	-1982(ra) # 5bc6 <exit>
  pipe(pfds);
    438c:	fc840513          	addi	a0,s0,-56
    4390:	00002097          	auipc	ra,0x2
    4394:	846080e7          	jalr	-1978(ra) # 5bd6 <pipe>
  pid3 = fork();
    4398:	00002097          	auipc	ra,0x2
    439c:	826080e7          	jalr	-2010(ra) # 5bbe <fork>
    43a0:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    43a2:	02054e63          	bltz	a0,43de <preempt+0xc0>
  if(pid3 == 0){
    43a6:	e525                	bnez	a0,440e <preempt+0xf0>
    close(pfds[0]);
    43a8:	fc842503          	lw	a0,-56(s0)
    43ac:	00002097          	auipc	ra,0x2
    43b0:	842080e7          	jalr	-1982(ra) # 5bee <close>
    if(write(pfds[1], "x", 1) != 1)
    43b4:	4605                	li	a2,1
    43b6:	00002597          	auipc	a1,0x2
    43ba:	e1258593          	addi	a1,a1,-494 # 61c8 <malloc+0x1ac>
    43be:	fcc42503          	lw	a0,-52(s0)
    43c2:	00002097          	auipc	ra,0x2
    43c6:	824080e7          	jalr	-2012(ra) # 5be6 <write>
    43ca:	4785                	li	a5,1
    43cc:	02f51763          	bne	a0,a5,43fa <preempt+0xdc>
    close(pfds[1]);
    43d0:	fcc42503          	lw	a0,-52(s0)
    43d4:	00002097          	auipc	ra,0x2
    43d8:	81a080e7          	jalr	-2022(ra) # 5bee <close>
    for(;;)
    43dc:	a001                	j	43dc <preempt+0xbe>
     printf("%s: fork failed\n", s);
    43de:	85ca                	mv	a1,s2
    43e0:	00002517          	auipc	a0,0x2
    43e4:	60050513          	addi	a0,a0,1536 # 69e0 <malloc+0x9c4>
    43e8:	00002097          	auipc	ra,0x2
    43ec:	b76080e7          	jalr	-1162(ra) # 5f5e <printf>
     exit(1);
    43f0:	4505                	li	a0,1
    43f2:	00001097          	auipc	ra,0x1
    43f6:	7d4080e7          	jalr	2004(ra) # 5bc6 <exit>
      printf("%s: preempt write error", s);
    43fa:	85ca                	mv	a1,s2
    43fc:	00004517          	auipc	a0,0x4
    4400:	8c450513          	addi	a0,a0,-1852 # 7cc0 <malloc+0x1ca4>
    4404:	00002097          	auipc	ra,0x2
    4408:	b5a080e7          	jalr	-1190(ra) # 5f5e <printf>
    440c:	b7d1                	j	43d0 <preempt+0xb2>
  close(pfds[1]);
    440e:	fcc42503          	lw	a0,-52(s0)
    4412:	00001097          	auipc	ra,0x1
    4416:	7dc080e7          	jalr	2012(ra) # 5bee <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    441a:	660d                	lui	a2,0x3
    441c:	00009597          	auipc	a1,0x9
    4420:	80c58593          	addi	a1,a1,-2036 # cc28 <buf>
    4424:	fc842503          	lw	a0,-56(s0)
    4428:	00001097          	auipc	ra,0x1
    442c:	7b6080e7          	jalr	1974(ra) # 5bde <read>
    4430:	4785                	li	a5,1
    4432:	02f50363          	beq	a0,a5,4458 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4436:	85ca                	mv	a1,s2
    4438:	00004517          	auipc	a0,0x4
    443c:	8a050513          	addi	a0,a0,-1888 # 7cd8 <malloc+0x1cbc>
    4440:	00002097          	auipc	ra,0x2
    4444:	b1e080e7          	jalr	-1250(ra) # 5f5e <printf>
}
    4448:	70e2                	ld	ra,56(sp)
    444a:	7442                	ld	s0,48(sp)
    444c:	74a2                	ld	s1,40(sp)
    444e:	7902                	ld	s2,32(sp)
    4450:	69e2                	ld	s3,24(sp)
    4452:	6a42                	ld	s4,16(sp)
    4454:	6121                	addi	sp,sp,64
    4456:	8082                	ret
  close(pfds[0]);
    4458:	fc842503          	lw	a0,-56(s0)
    445c:	00001097          	auipc	ra,0x1
    4460:	792080e7          	jalr	1938(ra) # 5bee <close>
  printf("kill... ");
    4464:	00004517          	auipc	a0,0x4
    4468:	88c50513          	addi	a0,a0,-1908 # 7cf0 <malloc+0x1cd4>
    446c:	00002097          	auipc	ra,0x2
    4470:	af2080e7          	jalr	-1294(ra) # 5f5e <printf>
  kill(pid1);
    4474:	8526                	mv	a0,s1
    4476:	00001097          	auipc	ra,0x1
    447a:	780080e7          	jalr	1920(ra) # 5bf6 <kill>
  kill(pid2);
    447e:	854e                	mv	a0,s3
    4480:	00001097          	auipc	ra,0x1
    4484:	776080e7          	jalr	1910(ra) # 5bf6 <kill>
  kill(pid3);
    4488:	8552                	mv	a0,s4
    448a:	00001097          	auipc	ra,0x1
    448e:	76c080e7          	jalr	1900(ra) # 5bf6 <kill>
  printf("wait... ");
    4492:	00004517          	auipc	a0,0x4
    4496:	86e50513          	addi	a0,a0,-1938 # 7d00 <malloc+0x1ce4>
    449a:	00002097          	auipc	ra,0x2
    449e:	ac4080e7          	jalr	-1340(ra) # 5f5e <printf>
  wait(0);
    44a2:	4501                	li	a0,0
    44a4:	00001097          	auipc	ra,0x1
    44a8:	72a080e7          	jalr	1834(ra) # 5bce <wait>
  wait(0);
    44ac:	4501                	li	a0,0
    44ae:	00001097          	auipc	ra,0x1
    44b2:	720080e7          	jalr	1824(ra) # 5bce <wait>
  wait(0);
    44b6:	4501                	li	a0,0
    44b8:	00001097          	auipc	ra,0x1
    44bc:	716080e7          	jalr	1814(ra) # 5bce <wait>
    44c0:	b761                	j	4448 <preempt+0x12a>

00000000000044c2 <sbrkfail>:
{
    44c2:	7119                	addi	sp,sp,-128
    44c4:	fc86                	sd	ra,120(sp)
    44c6:	f8a2                	sd	s0,112(sp)
    44c8:	f4a6                	sd	s1,104(sp)
    44ca:	f0ca                	sd	s2,96(sp)
    44cc:	ecce                	sd	s3,88(sp)
    44ce:	e8d2                	sd	s4,80(sp)
    44d0:	e4d6                	sd	s5,72(sp)
    44d2:	0100                	addi	s0,sp,128
    44d4:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    44d6:	fb040513          	addi	a0,s0,-80
    44da:	00001097          	auipc	ra,0x1
    44de:	6fc080e7          	jalr	1788(ra) # 5bd6 <pipe>
    44e2:	e901                	bnez	a0,44f2 <sbrkfail+0x30>
    44e4:	f8040493          	addi	s1,s0,-128
    44e8:	fa840993          	addi	s3,s0,-88
    44ec:	8926                	mv	s2,s1
    if(pids[i] != -1)
    44ee:	5a7d                	li	s4,-1
    44f0:	a085                	j	4550 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    44f2:	85d6                	mv	a1,s5
    44f4:	00002517          	auipc	a0,0x2
    44f8:	5f450513          	addi	a0,a0,1524 # 6ae8 <malloc+0xacc>
    44fc:	00002097          	auipc	ra,0x2
    4500:	a62080e7          	jalr	-1438(ra) # 5f5e <printf>
    exit(1);
    4504:	4505                	li	a0,1
    4506:	00001097          	auipc	ra,0x1
    450a:	6c0080e7          	jalr	1728(ra) # 5bc6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    450e:	00001097          	auipc	ra,0x1
    4512:	740080e7          	jalr	1856(ra) # 5c4e <sbrk>
    4516:	064007b7          	lui	a5,0x6400
    451a:	40a7853b          	subw	a0,a5,a0
    451e:	00001097          	auipc	ra,0x1
    4522:	730080e7          	jalr	1840(ra) # 5c4e <sbrk>
      write(fds[1], "x", 1);
    4526:	4605                	li	a2,1
    4528:	00002597          	auipc	a1,0x2
    452c:	ca058593          	addi	a1,a1,-864 # 61c8 <malloc+0x1ac>
    4530:	fb442503          	lw	a0,-76(s0)
    4534:	00001097          	auipc	ra,0x1
    4538:	6b2080e7          	jalr	1714(ra) # 5be6 <write>
      for(;;) sleep(1000);
    453c:	3e800513          	li	a0,1000
    4540:	00001097          	auipc	ra,0x1
    4544:	716080e7          	jalr	1814(ra) # 5c56 <sleep>
    4548:	bfd5                	j	453c <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    454a:	0911                	addi	s2,s2,4
    454c:	03390563          	beq	s2,s3,4576 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4550:	00001097          	auipc	ra,0x1
    4554:	66e080e7          	jalr	1646(ra) # 5bbe <fork>
    4558:	00a92023          	sw	a0,0(s2)
    455c:	d94d                	beqz	a0,450e <sbrkfail+0x4c>
    if(pids[i] != -1)
    455e:	ff4506e3          	beq	a0,s4,454a <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4562:	4605                	li	a2,1
    4564:	faf40593          	addi	a1,s0,-81
    4568:	fb042503          	lw	a0,-80(s0)
    456c:	00001097          	auipc	ra,0x1
    4570:	672080e7          	jalr	1650(ra) # 5bde <read>
    4574:	bfd9                	j	454a <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4576:	6505                	lui	a0,0x1
    4578:	00001097          	auipc	ra,0x1
    457c:	6d6080e7          	jalr	1750(ra) # 5c4e <sbrk>
    4580:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4582:	597d                	li	s2,-1
    4584:	a021                	j	458c <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4586:	0491                	addi	s1,s1,4
    4588:	01348f63          	beq	s1,s3,45a6 <sbrkfail+0xe4>
    if(pids[i] == -1)
    458c:	4088                	lw	a0,0(s1)
    458e:	ff250ce3          	beq	a0,s2,4586 <sbrkfail+0xc4>
    kill(pids[i]);
    4592:	00001097          	auipc	ra,0x1
    4596:	664080e7          	jalr	1636(ra) # 5bf6 <kill>
    wait(0);
    459a:	4501                	li	a0,0
    459c:	00001097          	auipc	ra,0x1
    45a0:	632080e7          	jalr	1586(ra) # 5bce <wait>
    45a4:	b7cd                	j	4586 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    45a6:	57fd                	li	a5,-1
    45a8:	04fa0163          	beq	s4,a5,45ea <sbrkfail+0x128>
  pid = fork();
    45ac:	00001097          	auipc	ra,0x1
    45b0:	612080e7          	jalr	1554(ra) # 5bbe <fork>
    45b4:	84aa                	mv	s1,a0
  if(pid < 0){
    45b6:	04054863          	bltz	a0,4606 <sbrkfail+0x144>
  if(pid == 0){
    45ba:	c525                	beqz	a0,4622 <sbrkfail+0x160>
  wait(&xstatus);
    45bc:	fbc40513          	addi	a0,s0,-68
    45c0:	00001097          	auipc	ra,0x1
    45c4:	60e080e7          	jalr	1550(ra) # 5bce <wait>
  if(xstatus != -1 && xstatus != 2)
    45c8:	fbc42783          	lw	a5,-68(s0)
    45cc:	577d                	li	a4,-1
    45ce:	00e78563          	beq	a5,a4,45d8 <sbrkfail+0x116>
    45d2:	4709                	li	a4,2
    45d4:	08e79d63          	bne	a5,a4,466e <sbrkfail+0x1ac>
}
    45d8:	70e6                	ld	ra,120(sp)
    45da:	7446                	ld	s0,112(sp)
    45dc:	74a6                	ld	s1,104(sp)
    45de:	7906                	ld	s2,96(sp)
    45e0:	69e6                	ld	s3,88(sp)
    45e2:	6a46                	ld	s4,80(sp)
    45e4:	6aa6                	ld	s5,72(sp)
    45e6:	6109                	addi	sp,sp,128
    45e8:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    45ea:	85d6                	mv	a1,s5
    45ec:	00003517          	auipc	a0,0x3
    45f0:	72450513          	addi	a0,a0,1828 # 7d10 <malloc+0x1cf4>
    45f4:	00002097          	auipc	ra,0x2
    45f8:	96a080e7          	jalr	-1686(ra) # 5f5e <printf>
    exit(1);
    45fc:	4505                	li	a0,1
    45fe:	00001097          	auipc	ra,0x1
    4602:	5c8080e7          	jalr	1480(ra) # 5bc6 <exit>
    printf("%s: fork failed\n", s);
    4606:	85d6                	mv	a1,s5
    4608:	00002517          	auipc	a0,0x2
    460c:	3d850513          	addi	a0,a0,984 # 69e0 <malloc+0x9c4>
    4610:	00002097          	auipc	ra,0x2
    4614:	94e080e7          	jalr	-1714(ra) # 5f5e <printf>
    exit(1);
    4618:	4505                	li	a0,1
    461a:	00001097          	auipc	ra,0x1
    461e:	5ac080e7          	jalr	1452(ra) # 5bc6 <exit>
    a = sbrk(0);
    4622:	4501                	li	a0,0
    4624:	00001097          	auipc	ra,0x1
    4628:	62a080e7          	jalr	1578(ra) # 5c4e <sbrk>
    462c:	892a                	mv	s2,a0
    sbrk(10*BIG);
    462e:	3e800537          	lui	a0,0x3e800
    4632:	00001097          	auipc	ra,0x1
    4636:	61c080e7          	jalr	1564(ra) # 5c4e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    463a:	87ca                	mv	a5,s2
    463c:	3e800737          	lui	a4,0x3e800
    4640:	993a                	add	s2,s2,a4
    4642:	6705                	lui	a4,0x1
      n += *(a+i);
    4644:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f03d8>
    4648:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    464a:	97ba                	add	a5,a5,a4
    464c:	ff279ce3          	bne	a5,s2,4644 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4650:	8626                	mv	a2,s1
    4652:	85d6                	mv	a1,s5
    4654:	00003517          	auipc	a0,0x3
    4658:	6dc50513          	addi	a0,a0,1756 # 7d30 <malloc+0x1d14>
    465c:	00002097          	auipc	ra,0x2
    4660:	902080e7          	jalr	-1790(ra) # 5f5e <printf>
    exit(1);
    4664:	4505                	li	a0,1
    4666:	00001097          	auipc	ra,0x1
    466a:	560080e7          	jalr	1376(ra) # 5bc6 <exit>
    exit(1);
    466e:	4505                	li	a0,1
    4670:	00001097          	auipc	ra,0x1
    4674:	556080e7          	jalr	1366(ra) # 5bc6 <exit>

0000000000004678 <mem>:
{
    4678:	7139                	addi	sp,sp,-64
    467a:	fc06                	sd	ra,56(sp)
    467c:	f822                	sd	s0,48(sp)
    467e:	f426                	sd	s1,40(sp)
    4680:	f04a                	sd	s2,32(sp)
    4682:	ec4e                	sd	s3,24(sp)
    4684:	0080                	addi	s0,sp,64
    4686:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4688:	00001097          	auipc	ra,0x1
    468c:	536080e7          	jalr	1334(ra) # 5bbe <fork>
    m1 = 0;
    4690:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4692:	6909                	lui	s2,0x2
    4694:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x29>
  if((pid = fork()) == 0){
    4698:	c115                	beqz	a0,46bc <mem+0x44>
    wait(&xstatus);
    469a:	fcc40513          	addi	a0,s0,-52
    469e:	00001097          	auipc	ra,0x1
    46a2:	530080e7          	jalr	1328(ra) # 5bce <wait>
    if(xstatus == -1){
    46a6:	fcc42503          	lw	a0,-52(s0)
    46aa:	57fd                	li	a5,-1
    46ac:	06f50363          	beq	a0,a5,4712 <mem+0x9a>
    exit(xstatus);
    46b0:	00001097          	auipc	ra,0x1
    46b4:	516080e7          	jalr	1302(ra) # 5bc6 <exit>
      *(char**)m2 = m1;
    46b8:	e104                	sd	s1,0(a0)
      m1 = m2;
    46ba:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    46bc:	854a                	mv	a0,s2
    46be:	00002097          	auipc	ra,0x2
    46c2:	95e080e7          	jalr	-1698(ra) # 601c <malloc>
    46c6:	f96d                	bnez	a0,46b8 <mem+0x40>
    while(m1){
    46c8:	c881                	beqz	s1,46d8 <mem+0x60>
      m2 = *(char**)m1;
    46ca:	8526                	mv	a0,s1
    46cc:	6084                	ld	s1,0(s1)
      free(m1);
    46ce:	00002097          	auipc	ra,0x2
    46d2:	8c6080e7          	jalr	-1850(ra) # 5f94 <free>
    while(m1){
    46d6:	f8f5                	bnez	s1,46ca <mem+0x52>
    m1 = malloc(1024*20);
    46d8:	6515                	lui	a0,0x5
    46da:	00002097          	auipc	ra,0x2
    46de:	942080e7          	jalr	-1726(ra) # 601c <malloc>
    if(m1 == 0){
    46e2:	c911                	beqz	a0,46f6 <mem+0x7e>
    free(m1);
    46e4:	00002097          	auipc	ra,0x2
    46e8:	8b0080e7          	jalr	-1872(ra) # 5f94 <free>
    exit(0);
    46ec:	4501                	li	a0,0
    46ee:	00001097          	auipc	ra,0x1
    46f2:	4d8080e7          	jalr	1240(ra) # 5bc6 <exit>
      printf("couldn't allocate mem?!!\n", s);
    46f6:	85ce                	mv	a1,s3
    46f8:	00003517          	auipc	a0,0x3
    46fc:	66850513          	addi	a0,a0,1640 # 7d60 <malloc+0x1d44>
    4700:	00002097          	auipc	ra,0x2
    4704:	85e080e7          	jalr	-1954(ra) # 5f5e <printf>
      exit(1);
    4708:	4505                	li	a0,1
    470a:	00001097          	auipc	ra,0x1
    470e:	4bc080e7          	jalr	1212(ra) # 5bc6 <exit>
      exit(0);
    4712:	4501                	li	a0,0
    4714:	00001097          	auipc	ra,0x1
    4718:	4b2080e7          	jalr	1202(ra) # 5bc6 <exit>

000000000000471c <sharedfd>:
{
    471c:	7159                	addi	sp,sp,-112
    471e:	f486                	sd	ra,104(sp)
    4720:	f0a2                	sd	s0,96(sp)
    4722:	eca6                	sd	s1,88(sp)
    4724:	e8ca                	sd	s2,80(sp)
    4726:	e4ce                	sd	s3,72(sp)
    4728:	e0d2                	sd	s4,64(sp)
    472a:	fc56                	sd	s5,56(sp)
    472c:	f85a                	sd	s6,48(sp)
    472e:	f45e                	sd	s7,40(sp)
    4730:	1880                	addi	s0,sp,112
    4732:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4734:	00003517          	auipc	a0,0x3
    4738:	64c50513          	addi	a0,a0,1612 # 7d80 <malloc+0x1d64>
    473c:	00001097          	auipc	ra,0x1
    4740:	4da080e7          	jalr	1242(ra) # 5c16 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4744:	20200593          	li	a1,514
    4748:	00003517          	auipc	a0,0x3
    474c:	63850513          	addi	a0,a0,1592 # 7d80 <malloc+0x1d64>
    4750:	00001097          	auipc	ra,0x1
    4754:	4b6080e7          	jalr	1206(ra) # 5c06 <open>
  if(fd < 0){
    4758:	04054a63          	bltz	a0,47ac <sharedfd+0x90>
    475c:	892a                	mv	s2,a0
  pid = fork();
    475e:	00001097          	auipc	ra,0x1
    4762:	460080e7          	jalr	1120(ra) # 5bbe <fork>
    4766:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4768:	06300593          	li	a1,99
    476c:	c119                	beqz	a0,4772 <sharedfd+0x56>
    476e:	07000593          	li	a1,112
    4772:	4629                	li	a2,10
    4774:	fa040513          	addi	a0,s0,-96
    4778:	00001097          	auipc	ra,0x1
    477c:	252080e7          	jalr	594(ra) # 59ca <memset>
    4780:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4784:	4629                	li	a2,10
    4786:	fa040593          	addi	a1,s0,-96
    478a:	854a                	mv	a0,s2
    478c:	00001097          	auipc	ra,0x1
    4790:	45a080e7          	jalr	1114(ra) # 5be6 <write>
    4794:	47a9                	li	a5,10
    4796:	02f51963          	bne	a0,a5,47c8 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    479a:	34fd                	addiw	s1,s1,-1
    479c:	f4e5                	bnez	s1,4784 <sharedfd+0x68>
  if(pid == 0) {
    479e:	04099363          	bnez	s3,47e4 <sharedfd+0xc8>
    exit(0);
    47a2:	4501                	li	a0,0
    47a4:	00001097          	auipc	ra,0x1
    47a8:	422080e7          	jalr	1058(ra) # 5bc6 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    47ac:	85d2                	mv	a1,s4
    47ae:	00003517          	auipc	a0,0x3
    47b2:	5e250513          	addi	a0,a0,1506 # 7d90 <malloc+0x1d74>
    47b6:	00001097          	auipc	ra,0x1
    47ba:	7a8080e7          	jalr	1960(ra) # 5f5e <printf>
    exit(1);
    47be:	4505                	li	a0,1
    47c0:	00001097          	auipc	ra,0x1
    47c4:	406080e7          	jalr	1030(ra) # 5bc6 <exit>
      printf("%s: write sharedfd failed\n", s);
    47c8:	85d2                	mv	a1,s4
    47ca:	00003517          	auipc	a0,0x3
    47ce:	5ee50513          	addi	a0,a0,1518 # 7db8 <malloc+0x1d9c>
    47d2:	00001097          	auipc	ra,0x1
    47d6:	78c080e7          	jalr	1932(ra) # 5f5e <printf>
      exit(1);
    47da:	4505                	li	a0,1
    47dc:	00001097          	auipc	ra,0x1
    47e0:	3ea080e7          	jalr	1002(ra) # 5bc6 <exit>
    wait(&xstatus);
    47e4:	f9c40513          	addi	a0,s0,-100
    47e8:	00001097          	auipc	ra,0x1
    47ec:	3e6080e7          	jalr	998(ra) # 5bce <wait>
    if(xstatus != 0)
    47f0:	f9c42983          	lw	s3,-100(s0)
    47f4:	00098763          	beqz	s3,4802 <sharedfd+0xe6>
      exit(xstatus);
    47f8:	854e                	mv	a0,s3
    47fa:	00001097          	auipc	ra,0x1
    47fe:	3cc080e7          	jalr	972(ra) # 5bc6 <exit>
  close(fd);
    4802:	854a                	mv	a0,s2
    4804:	00001097          	auipc	ra,0x1
    4808:	3ea080e7          	jalr	1002(ra) # 5bee <close>
  fd = open("sharedfd", 0);
    480c:	4581                	li	a1,0
    480e:	00003517          	auipc	a0,0x3
    4812:	57250513          	addi	a0,a0,1394 # 7d80 <malloc+0x1d64>
    4816:	00001097          	auipc	ra,0x1
    481a:	3f0080e7          	jalr	1008(ra) # 5c06 <open>
    481e:	8baa                	mv	s7,a0
  nc = np = 0;
    4820:	8ace                	mv	s5,s3
  if(fd < 0){
    4822:	02054563          	bltz	a0,484c <sharedfd+0x130>
    4826:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    482a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    482e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4832:	4629                	li	a2,10
    4834:	fa040593          	addi	a1,s0,-96
    4838:	855e                	mv	a0,s7
    483a:	00001097          	auipc	ra,0x1
    483e:	3a4080e7          	jalr	932(ra) # 5bde <read>
    4842:	02a05f63          	blez	a0,4880 <sharedfd+0x164>
    4846:	fa040793          	addi	a5,s0,-96
    484a:	a01d                	j	4870 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    484c:	85d2                	mv	a1,s4
    484e:	00003517          	auipc	a0,0x3
    4852:	58a50513          	addi	a0,a0,1418 # 7dd8 <malloc+0x1dbc>
    4856:	00001097          	auipc	ra,0x1
    485a:	708080e7          	jalr	1800(ra) # 5f5e <printf>
    exit(1);
    485e:	4505                	li	a0,1
    4860:	00001097          	auipc	ra,0x1
    4864:	366080e7          	jalr	870(ra) # 5bc6 <exit>
        nc++;
    4868:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    486a:	0785                	addi	a5,a5,1
    486c:	fd2783e3          	beq	a5,s2,4832 <sharedfd+0x116>
      if(buf[i] == 'c')
    4870:	0007c703          	lbu	a4,0(a5)
    4874:	fe970ae3          	beq	a4,s1,4868 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4878:	ff6719e3          	bne	a4,s6,486a <sharedfd+0x14e>
        np++;
    487c:	2a85                	addiw	s5,s5,1
    487e:	b7f5                	j	486a <sharedfd+0x14e>
  close(fd);
    4880:	855e                	mv	a0,s7
    4882:	00001097          	auipc	ra,0x1
    4886:	36c080e7          	jalr	876(ra) # 5bee <close>
  unlink("sharedfd");
    488a:	00003517          	auipc	a0,0x3
    488e:	4f650513          	addi	a0,a0,1270 # 7d80 <malloc+0x1d64>
    4892:	00001097          	auipc	ra,0x1
    4896:	384080e7          	jalr	900(ra) # 5c16 <unlink>
  if(nc == N*SZ && np == N*SZ){
    489a:	6789                	lui	a5,0x2
    489c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x28>
    48a0:	00f99763          	bne	s3,a5,48ae <sharedfd+0x192>
    48a4:	6789                	lui	a5,0x2
    48a6:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x28>
    48aa:	02fa8063          	beq	s5,a5,48ca <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    48ae:	85d2                	mv	a1,s4
    48b0:	00003517          	auipc	a0,0x3
    48b4:	55050513          	addi	a0,a0,1360 # 7e00 <malloc+0x1de4>
    48b8:	00001097          	auipc	ra,0x1
    48bc:	6a6080e7          	jalr	1702(ra) # 5f5e <printf>
    exit(1);
    48c0:	4505                	li	a0,1
    48c2:	00001097          	auipc	ra,0x1
    48c6:	304080e7          	jalr	772(ra) # 5bc6 <exit>
    exit(0);
    48ca:	4501                	li	a0,0
    48cc:	00001097          	auipc	ra,0x1
    48d0:	2fa080e7          	jalr	762(ra) # 5bc6 <exit>

00000000000048d4 <fourfiles>:
{
    48d4:	7171                	addi	sp,sp,-176
    48d6:	f506                	sd	ra,168(sp)
    48d8:	f122                	sd	s0,160(sp)
    48da:	ed26                	sd	s1,152(sp)
    48dc:	e94a                	sd	s2,144(sp)
    48de:	e54e                	sd	s3,136(sp)
    48e0:	e152                	sd	s4,128(sp)
    48e2:	fcd6                	sd	s5,120(sp)
    48e4:	f8da                	sd	s6,112(sp)
    48e6:	f4de                	sd	s7,104(sp)
    48e8:	f0e2                	sd	s8,96(sp)
    48ea:	ece6                	sd	s9,88(sp)
    48ec:	e8ea                	sd	s10,80(sp)
    48ee:	e4ee                	sd	s11,72(sp)
    48f0:	1900                	addi	s0,sp,176
    48f2:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    48f6:	00002797          	auipc	a5,0x2
    48fa:	80a78793          	addi	a5,a5,-2038 # 6100 <malloc+0xe4>
    48fe:	f6f43823          	sd	a5,-144(s0)
    4902:	00002797          	auipc	a5,0x2
    4906:	80678793          	addi	a5,a5,-2042 # 6108 <malloc+0xec>
    490a:	f6f43c23          	sd	a5,-136(s0)
    490e:	00002797          	auipc	a5,0x2
    4912:	80278793          	addi	a5,a5,-2046 # 6110 <malloc+0xf4>
    4916:	f8f43023          	sd	a5,-128(s0)
    491a:	00001797          	auipc	a5,0x1
    491e:	7fe78793          	addi	a5,a5,2046 # 6118 <malloc+0xfc>
    4922:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4926:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    492a:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    492c:	4481                	li	s1,0
    492e:	4a11                	li	s4,4
    fname = names[pi];
    4930:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4934:	854e                	mv	a0,s3
    4936:	00001097          	auipc	ra,0x1
    493a:	2e0080e7          	jalr	736(ra) # 5c16 <unlink>
    pid = fork();
    493e:	00001097          	auipc	ra,0x1
    4942:	280080e7          	jalr	640(ra) # 5bbe <fork>
    if(pid < 0){
    4946:	04054463          	bltz	a0,498e <fourfiles+0xba>
    if(pid == 0){
    494a:	c12d                	beqz	a0,49ac <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    494c:	2485                	addiw	s1,s1,1
    494e:	0921                	addi	s2,s2,8
    4950:	ff4490e3          	bne	s1,s4,4930 <fourfiles+0x5c>
    4954:	4491                	li	s1,4
    wait(&xstatus);
    4956:	f6c40513          	addi	a0,s0,-148
    495a:	00001097          	auipc	ra,0x1
    495e:	274080e7          	jalr	628(ra) # 5bce <wait>
    if(xstatus != 0)
    4962:	f6c42b03          	lw	s6,-148(s0)
    4966:	0c0b1e63          	bnez	s6,4a42 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    496a:	34fd                	addiw	s1,s1,-1
    496c:	f4ed                	bnez	s1,4956 <fourfiles+0x82>
    496e:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4972:	00008a17          	auipc	s4,0x8
    4976:	2b6a0a13          	addi	s4,s4,694 # cc28 <buf>
    497a:	00008a97          	auipc	s5,0x8
    497e:	2afa8a93          	addi	s5,s5,687 # cc29 <buf+0x1>
    if(total != N*SZ){
    4982:	6d85                	lui	s11,0x1
    4984:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x2e>
  for(i = 0; i < NCHILD; i++){
    4988:	03400d13          	li	s10,52
    498c:	aa1d                	j	4ac2 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    498e:	f5843583          	ld	a1,-168(s0)
    4992:	00002517          	auipc	a0,0x2
    4996:	42650513          	addi	a0,a0,1062 # 6db8 <malloc+0xd9c>
    499a:	00001097          	auipc	ra,0x1
    499e:	5c4080e7          	jalr	1476(ra) # 5f5e <printf>
      exit(1);
    49a2:	4505                	li	a0,1
    49a4:	00001097          	auipc	ra,0x1
    49a8:	222080e7          	jalr	546(ra) # 5bc6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    49ac:	20200593          	li	a1,514
    49b0:	854e                	mv	a0,s3
    49b2:	00001097          	auipc	ra,0x1
    49b6:	254080e7          	jalr	596(ra) # 5c06 <open>
    49ba:	892a                	mv	s2,a0
      if(fd < 0){
    49bc:	04054763          	bltz	a0,4a0a <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    49c0:	1f400613          	li	a2,500
    49c4:	0304859b          	addiw	a1,s1,48
    49c8:	00008517          	auipc	a0,0x8
    49cc:	26050513          	addi	a0,a0,608 # cc28 <buf>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	ffa080e7          	jalr	-6(ra) # 59ca <memset>
    49d8:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    49da:	00008997          	auipc	s3,0x8
    49de:	24e98993          	addi	s3,s3,590 # cc28 <buf>
    49e2:	1f400613          	li	a2,500
    49e6:	85ce                	mv	a1,s3
    49e8:	854a                	mv	a0,s2
    49ea:	00001097          	auipc	ra,0x1
    49ee:	1fc080e7          	jalr	508(ra) # 5be6 <write>
    49f2:	85aa                	mv	a1,a0
    49f4:	1f400793          	li	a5,500
    49f8:	02f51863          	bne	a0,a5,4a28 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    49fc:	34fd                	addiw	s1,s1,-1
    49fe:	f0f5                	bnez	s1,49e2 <fourfiles+0x10e>
      exit(0);
    4a00:	4501                	li	a0,0
    4a02:	00001097          	auipc	ra,0x1
    4a06:	1c4080e7          	jalr	452(ra) # 5bc6 <exit>
        printf("create failed\n", s);
    4a0a:	f5843583          	ld	a1,-168(s0)
    4a0e:	00003517          	auipc	a0,0x3
    4a12:	40a50513          	addi	a0,a0,1034 # 7e18 <malloc+0x1dfc>
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	548080e7          	jalr	1352(ra) # 5f5e <printf>
        exit(1);
    4a1e:	4505                	li	a0,1
    4a20:	00001097          	auipc	ra,0x1
    4a24:	1a6080e7          	jalr	422(ra) # 5bc6 <exit>
          printf("write failed %d\n", n);
    4a28:	00003517          	auipc	a0,0x3
    4a2c:	40050513          	addi	a0,a0,1024 # 7e28 <malloc+0x1e0c>
    4a30:	00001097          	auipc	ra,0x1
    4a34:	52e080e7          	jalr	1326(ra) # 5f5e <printf>
          exit(1);
    4a38:	4505                	li	a0,1
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	18c080e7          	jalr	396(ra) # 5bc6 <exit>
      exit(xstatus);
    4a42:	855a                	mv	a0,s6
    4a44:	00001097          	auipc	ra,0x1
    4a48:	182080e7          	jalr	386(ra) # 5bc6 <exit>
          printf("wrong char\n", s);
    4a4c:	f5843583          	ld	a1,-168(s0)
    4a50:	00003517          	auipc	a0,0x3
    4a54:	3f050513          	addi	a0,a0,1008 # 7e40 <malloc+0x1e24>
    4a58:	00001097          	auipc	ra,0x1
    4a5c:	506080e7          	jalr	1286(ra) # 5f5e <printf>
          exit(1);
    4a60:	4505                	li	a0,1
    4a62:	00001097          	auipc	ra,0x1
    4a66:	164080e7          	jalr	356(ra) # 5bc6 <exit>
      total += n;
    4a6a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4a6e:	660d                	lui	a2,0x3
    4a70:	85d2                	mv	a1,s4
    4a72:	854e                	mv	a0,s3
    4a74:	00001097          	auipc	ra,0x1
    4a78:	16a080e7          	jalr	362(ra) # 5bde <read>
    4a7c:	02a05363          	blez	a0,4aa2 <fourfiles+0x1ce>
    4a80:	00008797          	auipc	a5,0x8
    4a84:	1a878793          	addi	a5,a5,424 # cc28 <buf>
    4a88:	fff5069b          	addiw	a3,a0,-1
    4a8c:	1682                	slli	a3,a3,0x20
    4a8e:	9281                	srli	a3,a3,0x20
    4a90:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4a92:	0007c703          	lbu	a4,0(a5)
    4a96:	fa971be3          	bne	a4,s1,4a4c <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4a9a:	0785                	addi	a5,a5,1
    4a9c:	fed79be3          	bne	a5,a3,4a92 <fourfiles+0x1be>
    4aa0:	b7e9                	j	4a6a <fourfiles+0x196>
    close(fd);
    4aa2:	854e                	mv	a0,s3
    4aa4:	00001097          	auipc	ra,0x1
    4aa8:	14a080e7          	jalr	330(ra) # 5bee <close>
    if(total != N*SZ){
    4aac:	03b91863          	bne	s2,s11,4adc <fourfiles+0x208>
    unlink(fname);
    4ab0:	8566                	mv	a0,s9
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	164080e7          	jalr	356(ra) # 5c16 <unlink>
  for(i = 0; i < NCHILD; i++){
    4aba:	0c21                	addi	s8,s8,8
    4abc:	2b85                	addiw	s7,s7,1
    4abe:	03ab8d63          	beq	s7,s10,4af8 <fourfiles+0x224>
    fname = names[i];
    4ac2:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4ac6:	4581                	li	a1,0
    4ac8:	8566                	mv	a0,s9
    4aca:	00001097          	auipc	ra,0x1
    4ace:	13c080e7          	jalr	316(ra) # 5c06 <open>
    4ad2:	89aa                	mv	s3,a0
    total = 0;
    4ad4:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4ad6:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4ada:	bf51                	j	4a6e <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4adc:	85ca                	mv	a1,s2
    4ade:	00003517          	auipc	a0,0x3
    4ae2:	37250513          	addi	a0,a0,882 # 7e50 <malloc+0x1e34>
    4ae6:	00001097          	auipc	ra,0x1
    4aea:	478080e7          	jalr	1144(ra) # 5f5e <printf>
      exit(1);
    4aee:	4505                	li	a0,1
    4af0:	00001097          	auipc	ra,0x1
    4af4:	0d6080e7          	jalr	214(ra) # 5bc6 <exit>
}
    4af8:	70aa                	ld	ra,168(sp)
    4afa:	740a                	ld	s0,160(sp)
    4afc:	64ea                	ld	s1,152(sp)
    4afe:	694a                	ld	s2,144(sp)
    4b00:	69aa                	ld	s3,136(sp)
    4b02:	6a0a                	ld	s4,128(sp)
    4b04:	7ae6                	ld	s5,120(sp)
    4b06:	7b46                	ld	s6,112(sp)
    4b08:	7ba6                	ld	s7,104(sp)
    4b0a:	7c06                	ld	s8,96(sp)
    4b0c:	6ce6                	ld	s9,88(sp)
    4b0e:	6d46                	ld	s10,80(sp)
    4b10:	6da6                	ld	s11,72(sp)
    4b12:	614d                	addi	sp,sp,176
    4b14:	8082                	ret

0000000000004b16 <concreate>:
{
    4b16:	7135                	addi	sp,sp,-160
    4b18:	ed06                	sd	ra,152(sp)
    4b1a:	e922                	sd	s0,144(sp)
    4b1c:	e526                	sd	s1,136(sp)
    4b1e:	e14a                	sd	s2,128(sp)
    4b20:	fcce                	sd	s3,120(sp)
    4b22:	f8d2                	sd	s4,112(sp)
    4b24:	f4d6                	sd	s5,104(sp)
    4b26:	f0da                	sd	s6,96(sp)
    4b28:	ecde                	sd	s7,88(sp)
    4b2a:	1100                	addi	s0,sp,160
    4b2c:	89aa                	mv	s3,a0
  file[0] = 'C';
    4b2e:	04300793          	li	a5,67
    4b32:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4b36:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4b3a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4b3c:	4b0d                	li	s6,3
    4b3e:	4a85                	li	s5,1
      link("C0", file);
    4b40:	00003b97          	auipc	s7,0x3
    4b44:	328b8b93          	addi	s7,s7,808 # 7e68 <malloc+0x1e4c>
  for(i = 0; i < N; i++){
    4b48:	02800a13          	li	s4,40
    4b4c:	acc1                	j	4e1c <concreate+0x306>
      link("C0", file);
    4b4e:	fa840593          	addi	a1,s0,-88
    4b52:	855e                	mv	a0,s7
    4b54:	00001097          	auipc	ra,0x1
    4b58:	0d2080e7          	jalr	210(ra) # 5c26 <link>
    if(pid == 0) {
    4b5c:	a45d                	j	4e02 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4b5e:	4795                	li	a5,5
    4b60:	02f9693b          	remw	s2,s2,a5
    4b64:	4785                	li	a5,1
    4b66:	02f90b63          	beq	s2,a5,4b9c <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4b6a:	20200593          	li	a1,514
    4b6e:	fa840513          	addi	a0,s0,-88
    4b72:	00001097          	auipc	ra,0x1
    4b76:	094080e7          	jalr	148(ra) # 5c06 <open>
      if(fd < 0){
    4b7a:	26055b63          	bgez	a0,4df0 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4b7e:	fa840593          	addi	a1,s0,-88
    4b82:	00003517          	auipc	a0,0x3
    4b86:	2ee50513          	addi	a0,a0,750 # 7e70 <malloc+0x1e54>
    4b8a:	00001097          	auipc	ra,0x1
    4b8e:	3d4080e7          	jalr	980(ra) # 5f5e <printf>
        exit(1);
    4b92:	4505                	li	a0,1
    4b94:	00001097          	auipc	ra,0x1
    4b98:	032080e7          	jalr	50(ra) # 5bc6 <exit>
      link("C0", file);
    4b9c:	fa840593          	addi	a1,s0,-88
    4ba0:	00003517          	auipc	a0,0x3
    4ba4:	2c850513          	addi	a0,a0,712 # 7e68 <malloc+0x1e4c>
    4ba8:	00001097          	auipc	ra,0x1
    4bac:	07e080e7          	jalr	126(ra) # 5c26 <link>
      exit(0);
    4bb0:	4501                	li	a0,0
    4bb2:	00001097          	auipc	ra,0x1
    4bb6:	014080e7          	jalr	20(ra) # 5bc6 <exit>
        exit(1);
    4bba:	4505                	li	a0,1
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	00a080e7          	jalr	10(ra) # 5bc6 <exit>
  memset(fa, 0, sizeof(fa));
    4bc4:	02800613          	li	a2,40
    4bc8:	4581                	li	a1,0
    4bca:	f8040513          	addi	a0,s0,-128
    4bce:	00001097          	auipc	ra,0x1
    4bd2:	dfc080e7          	jalr	-516(ra) # 59ca <memset>
  fd = open(".", 0);
    4bd6:	4581                	li	a1,0
    4bd8:	00002517          	auipc	a0,0x2
    4bdc:	c6850513          	addi	a0,a0,-920 # 6840 <malloc+0x824>
    4be0:	00001097          	auipc	ra,0x1
    4be4:	026080e7          	jalr	38(ra) # 5c06 <open>
    4be8:	892a                	mv	s2,a0
  n = 0;
    4bea:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4bec:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4bf0:	02700b13          	li	s6,39
      fa[i] = 1;
    4bf4:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4bf6:	4641                	li	a2,16
    4bf8:	f7040593          	addi	a1,s0,-144
    4bfc:	854a                	mv	a0,s2
    4bfe:	00001097          	auipc	ra,0x1
    4c02:	fe0080e7          	jalr	-32(ra) # 5bde <read>
    4c06:	08a05163          	blez	a0,4c88 <concreate+0x172>
    if(de.inum == 0)
    4c0a:	f7045783          	lhu	a5,-144(s0)
    4c0e:	d7e5                	beqz	a5,4bf6 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4c10:	f7244783          	lbu	a5,-142(s0)
    4c14:	ff4791e3          	bne	a5,s4,4bf6 <concreate+0xe0>
    4c18:	f7444783          	lbu	a5,-140(s0)
    4c1c:	ffe9                	bnez	a5,4bf6 <concreate+0xe0>
      i = de.name[1] - '0';
    4c1e:	f7344783          	lbu	a5,-141(s0)
    4c22:	fd07879b          	addiw	a5,a5,-48
    4c26:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4c2a:	00eb6f63          	bltu	s6,a4,4c48 <concreate+0x132>
      if(fa[i]){
    4c2e:	fb040793          	addi	a5,s0,-80
    4c32:	97ba                	add	a5,a5,a4
    4c34:	fd07c783          	lbu	a5,-48(a5)
    4c38:	eb85                	bnez	a5,4c68 <concreate+0x152>
      fa[i] = 1;
    4c3a:	fb040793          	addi	a5,s0,-80
    4c3e:	973e                	add	a4,a4,a5
    4c40:	fd770823          	sb	s7,-48(a4) # fd0 <linktest+0xda>
      n++;
    4c44:	2a85                	addiw	s5,s5,1
    4c46:	bf45                	j	4bf6 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4c48:	f7240613          	addi	a2,s0,-142
    4c4c:	85ce                	mv	a1,s3
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	24250513          	addi	a0,a0,578 # 7e90 <malloc+0x1e74>
    4c56:	00001097          	auipc	ra,0x1
    4c5a:	308080e7          	jalr	776(ra) # 5f5e <printf>
        exit(1);
    4c5e:	4505                	li	a0,1
    4c60:	00001097          	auipc	ra,0x1
    4c64:	f66080e7          	jalr	-154(ra) # 5bc6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4c68:	f7240613          	addi	a2,s0,-142
    4c6c:	85ce                	mv	a1,s3
    4c6e:	00003517          	auipc	a0,0x3
    4c72:	24250513          	addi	a0,a0,578 # 7eb0 <malloc+0x1e94>
    4c76:	00001097          	auipc	ra,0x1
    4c7a:	2e8080e7          	jalr	744(ra) # 5f5e <printf>
        exit(1);
    4c7e:	4505                	li	a0,1
    4c80:	00001097          	auipc	ra,0x1
    4c84:	f46080e7          	jalr	-186(ra) # 5bc6 <exit>
  close(fd);
    4c88:	854a                	mv	a0,s2
    4c8a:	00001097          	auipc	ra,0x1
    4c8e:	f64080e7          	jalr	-156(ra) # 5bee <close>
  if(n != N){
    4c92:	02800793          	li	a5,40
    4c96:	00fa9763          	bne	s5,a5,4ca4 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4c9a:	4a8d                	li	s5,3
    4c9c:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4c9e:	02800a13          	li	s4,40
    4ca2:	a8c9                	j	4d74 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ca4:	85ce                	mv	a1,s3
    4ca6:	00003517          	auipc	a0,0x3
    4caa:	23250513          	addi	a0,a0,562 # 7ed8 <malloc+0x1ebc>
    4cae:	00001097          	auipc	ra,0x1
    4cb2:	2b0080e7          	jalr	688(ra) # 5f5e <printf>
    exit(1);
    4cb6:	4505                	li	a0,1
    4cb8:	00001097          	auipc	ra,0x1
    4cbc:	f0e080e7          	jalr	-242(ra) # 5bc6 <exit>
      printf("%s: fork failed\n", s);
    4cc0:	85ce                	mv	a1,s3
    4cc2:	00002517          	auipc	a0,0x2
    4cc6:	d1e50513          	addi	a0,a0,-738 # 69e0 <malloc+0x9c4>
    4cca:	00001097          	auipc	ra,0x1
    4cce:	294080e7          	jalr	660(ra) # 5f5e <printf>
      exit(1);
    4cd2:	4505                	li	a0,1
    4cd4:	00001097          	auipc	ra,0x1
    4cd8:	ef2080e7          	jalr	-270(ra) # 5bc6 <exit>
      close(open(file, 0));
    4cdc:	4581                	li	a1,0
    4cde:	fa840513          	addi	a0,s0,-88
    4ce2:	00001097          	auipc	ra,0x1
    4ce6:	f24080e7          	jalr	-220(ra) # 5c06 <open>
    4cea:	00001097          	auipc	ra,0x1
    4cee:	f04080e7          	jalr	-252(ra) # 5bee <close>
      close(open(file, 0));
    4cf2:	4581                	li	a1,0
    4cf4:	fa840513          	addi	a0,s0,-88
    4cf8:	00001097          	auipc	ra,0x1
    4cfc:	f0e080e7          	jalr	-242(ra) # 5c06 <open>
    4d00:	00001097          	auipc	ra,0x1
    4d04:	eee080e7          	jalr	-274(ra) # 5bee <close>
      close(open(file, 0));
    4d08:	4581                	li	a1,0
    4d0a:	fa840513          	addi	a0,s0,-88
    4d0e:	00001097          	auipc	ra,0x1
    4d12:	ef8080e7          	jalr	-264(ra) # 5c06 <open>
    4d16:	00001097          	auipc	ra,0x1
    4d1a:	ed8080e7          	jalr	-296(ra) # 5bee <close>
      close(open(file, 0));
    4d1e:	4581                	li	a1,0
    4d20:	fa840513          	addi	a0,s0,-88
    4d24:	00001097          	auipc	ra,0x1
    4d28:	ee2080e7          	jalr	-286(ra) # 5c06 <open>
    4d2c:	00001097          	auipc	ra,0x1
    4d30:	ec2080e7          	jalr	-318(ra) # 5bee <close>
      close(open(file, 0));
    4d34:	4581                	li	a1,0
    4d36:	fa840513          	addi	a0,s0,-88
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	ecc080e7          	jalr	-308(ra) # 5c06 <open>
    4d42:	00001097          	auipc	ra,0x1
    4d46:	eac080e7          	jalr	-340(ra) # 5bee <close>
      close(open(file, 0));
    4d4a:	4581                	li	a1,0
    4d4c:	fa840513          	addi	a0,s0,-88
    4d50:	00001097          	auipc	ra,0x1
    4d54:	eb6080e7          	jalr	-330(ra) # 5c06 <open>
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	e96080e7          	jalr	-362(ra) # 5bee <close>
    if(pid == 0)
    4d60:	08090363          	beqz	s2,4de6 <concreate+0x2d0>
      wait(0);
    4d64:	4501                	li	a0,0
    4d66:	00001097          	auipc	ra,0x1
    4d6a:	e68080e7          	jalr	-408(ra) # 5bce <wait>
  for(i = 0; i < N; i++){
    4d6e:	2485                	addiw	s1,s1,1
    4d70:	0f448563          	beq	s1,s4,4e5a <concreate+0x344>
    file[1] = '0' + i;
    4d74:	0304879b          	addiw	a5,s1,48
    4d78:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	e42080e7          	jalr	-446(ra) # 5bbe <fork>
    4d84:	892a                	mv	s2,a0
    if(pid < 0){
    4d86:	f2054de3          	bltz	a0,4cc0 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4d8a:	0354e73b          	remw	a4,s1,s5
    4d8e:	00a767b3          	or	a5,a4,a0
    4d92:	2781                	sext.w	a5,a5
    4d94:	d7a1                	beqz	a5,4cdc <concreate+0x1c6>
    4d96:	01671363          	bne	a4,s6,4d9c <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4d9a:	f129                	bnez	a0,4cdc <concreate+0x1c6>
      unlink(file);
    4d9c:	fa840513          	addi	a0,s0,-88
    4da0:	00001097          	auipc	ra,0x1
    4da4:	e76080e7          	jalr	-394(ra) # 5c16 <unlink>
      unlink(file);
    4da8:	fa840513          	addi	a0,s0,-88
    4dac:	00001097          	auipc	ra,0x1
    4db0:	e6a080e7          	jalr	-406(ra) # 5c16 <unlink>
      unlink(file);
    4db4:	fa840513          	addi	a0,s0,-88
    4db8:	00001097          	auipc	ra,0x1
    4dbc:	e5e080e7          	jalr	-418(ra) # 5c16 <unlink>
      unlink(file);
    4dc0:	fa840513          	addi	a0,s0,-88
    4dc4:	00001097          	auipc	ra,0x1
    4dc8:	e52080e7          	jalr	-430(ra) # 5c16 <unlink>
      unlink(file);
    4dcc:	fa840513          	addi	a0,s0,-88
    4dd0:	00001097          	auipc	ra,0x1
    4dd4:	e46080e7          	jalr	-442(ra) # 5c16 <unlink>
      unlink(file);
    4dd8:	fa840513          	addi	a0,s0,-88
    4ddc:	00001097          	auipc	ra,0x1
    4de0:	e3a080e7          	jalr	-454(ra) # 5c16 <unlink>
    4de4:	bfb5                	j	4d60 <concreate+0x24a>
      exit(0);
    4de6:	4501                	li	a0,0
    4de8:	00001097          	auipc	ra,0x1
    4dec:	dde080e7          	jalr	-546(ra) # 5bc6 <exit>
      close(fd);
    4df0:	00001097          	auipc	ra,0x1
    4df4:	dfe080e7          	jalr	-514(ra) # 5bee <close>
    if(pid == 0) {
    4df8:	bb65                	j	4bb0 <concreate+0x9a>
      close(fd);
    4dfa:	00001097          	auipc	ra,0x1
    4dfe:	df4080e7          	jalr	-524(ra) # 5bee <close>
      wait(&xstatus);
    4e02:	f6c40513          	addi	a0,s0,-148
    4e06:	00001097          	auipc	ra,0x1
    4e0a:	dc8080e7          	jalr	-568(ra) # 5bce <wait>
      if(xstatus != 0)
    4e0e:	f6c42483          	lw	s1,-148(s0)
    4e12:	da0494e3          	bnez	s1,4bba <concreate+0xa4>
  for(i = 0; i < N; i++){
    4e16:	2905                	addiw	s2,s2,1
    4e18:	db4906e3          	beq	s2,s4,4bc4 <concreate+0xae>
    file[1] = '0' + i;
    4e1c:	0309079b          	addiw	a5,s2,48
    4e20:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4e24:	fa840513          	addi	a0,s0,-88
    4e28:	00001097          	auipc	ra,0x1
    4e2c:	dee080e7          	jalr	-530(ra) # 5c16 <unlink>
    pid = fork();
    4e30:	00001097          	auipc	ra,0x1
    4e34:	d8e080e7          	jalr	-626(ra) # 5bbe <fork>
    if(pid && (i % 3) == 1){
    4e38:	d20503e3          	beqz	a0,4b5e <concreate+0x48>
    4e3c:	036967bb          	remw	a5,s2,s6
    4e40:	d15787e3          	beq	a5,s5,4b4e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4e44:	20200593          	li	a1,514
    4e48:	fa840513          	addi	a0,s0,-88
    4e4c:	00001097          	auipc	ra,0x1
    4e50:	dba080e7          	jalr	-582(ra) # 5c06 <open>
      if(fd < 0){
    4e54:	fa0553e3          	bgez	a0,4dfa <concreate+0x2e4>
    4e58:	b31d                	j	4b7e <concreate+0x68>
}
    4e5a:	60ea                	ld	ra,152(sp)
    4e5c:	644a                	ld	s0,144(sp)
    4e5e:	64aa                	ld	s1,136(sp)
    4e60:	690a                	ld	s2,128(sp)
    4e62:	79e6                	ld	s3,120(sp)
    4e64:	7a46                	ld	s4,112(sp)
    4e66:	7aa6                	ld	s5,104(sp)
    4e68:	7b06                	ld	s6,96(sp)
    4e6a:	6be6                	ld	s7,88(sp)
    4e6c:	610d                	addi	sp,sp,160
    4e6e:	8082                	ret

0000000000004e70 <bigfile>:
{
    4e70:	7139                	addi	sp,sp,-64
    4e72:	fc06                	sd	ra,56(sp)
    4e74:	f822                	sd	s0,48(sp)
    4e76:	f426                	sd	s1,40(sp)
    4e78:	f04a                	sd	s2,32(sp)
    4e7a:	ec4e                	sd	s3,24(sp)
    4e7c:	e852                	sd	s4,16(sp)
    4e7e:	e456                	sd	s5,8(sp)
    4e80:	0080                	addi	s0,sp,64
    4e82:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4e84:	00003517          	auipc	a0,0x3
    4e88:	08c50513          	addi	a0,a0,140 # 7f10 <malloc+0x1ef4>
    4e8c:	00001097          	auipc	ra,0x1
    4e90:	d8a080e7          	jalr	-630(ra) # 5c16 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4e94:	20200593          	li	a1,514
    4e98:	00003517          	auipc	a0,0x3
    4e9c:	07850513          	addi	a0,a0,120 # 7f10 <malloc+0x1ef4>
    4ea0:	00001097          	auipc	ra,0x1
    4ea4:	d66080e7          	jalr	-666(ra) # 5c06 <open>
    4ea8:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4eaa:	4481                	li	s1,0
    memset(buf, i, SZ);
    4eac:	00008917          	auipc	s2,0x8
    4eb0:	d7c90913          	addi	s2,s2,-644 # cc28 <buf>
  for(i = 0; i < N; i++){
    4eb4:	4a51                	li	s4,20
  if(fd < 0){
    4eb6:	0a054063          	bltz	a0,4f56 <bigfile+0xe6>
    memset(buf, i, SZ);
    4eba:	25800613          	li	a2,600
    4ebe:	85a6                	mv	a1,s1
    4ec0:	854a                	mv	a0,s2
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	b08080e7          	jalr	-1272(ra) # 59ca <memset>
    if(write(fd, buf, SZ) != SZ){
    4eca:	25800613          	li	a2,600
    4ece:	85ca                	mv	a1,s2
    4ed0:	854e                	mv	a0,s3
    4ed2:	00001097          	auipc	ra,0x1
    4ed6:	d14080e7          	jalr	-748(ra) # 5be6 <write>
    4eda:	25800793          	li	a5,600
    4ede:	08f51a63          	bne	a0,a5,4f72 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4ee2:	2485                	addiw	s1,s1,1
    4ee4:	fd449be3          	bne	s1,s4,4eba <bigfile+0x4a>
  close(fd);
    4ee8:	854e                	mv	a0,s3
    4eea:	00001097          	auipc	ra,0x1
    4eee:	d04080e7          	jalr	-764(ra) # 5bee <close>
  fd = open("bigfile.dat", 0);
    4ef2:	4581                	li	a1,0
    4ef4:	00003517          	auipc	a0,0x3
    4ef8:	01c50513          	addi	a0,a0,28 # 7f10 <malloc+0x1ef4>
    4efc:	00001097          	auipc	ra,0x1
    4f00:	d0a080e7          	jalr	-758(ra) # 5c06 <open>
    4f04:	8a2a                	mv	s4,a0
  total = 0;
    4f06:	4981                	li	s3,0
  for(i = 0; ; i++){
    4f08:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4f0a:	00008917          	auipc	s2,0x8
    4f0e:	d1e90913          	addi	s2,s2,-738 # cc28 <buf>
  if(fd < 0){
    4f12:	06054e63          	bltz	a0,4f8e <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4f16:	12c00613          	li	a2,300
    4f1a:	85ca                	mv	a1,s2
    4f1c:	8552                	mv	a0,s4
    4f1e:	00001097          	auipc	ra,0x1
    4f22:	cc0080e7          	jalr	-832(ra) # 5bde <read>
    if(cc < 0){
    4f26:	08054263          	bltz	a0,4faa <bigfile+0x13a>
    if(cc == 0)
    4f2a:	c971                	beqz	a0,4ffe <bigfile+0x18e>
    if(cc != SZ/2){
    4f2c:	12c00793          	li	a5,300
    4f30:	08f51b63          	bne	a0,a5,4fc6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4f34:	01f4d79b          	srliw	a5,s1,0x1f
    4f38:	9fa5                	addw	a5,a5,s1
    4f3a:	4017d79b          	sraiw	a5,a5,0x1
    4f3e:	00094703          	lbu	a4,0(s2)
    4f42:	0af71063          	bne	a4,a5,4fe2 <bigfile+0x172>
    4f46:	12b94703          	lbu	a4,299(s2)
    4f4a:	08f71c63          	bne	a4,a5,4fe2 <bigfile+0x172>
    total += cc;
    4f4e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4f52:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4f54:	b7c9                	j	4f16 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4f56:	85d6                	mv	a1,s5
    4f58:	00003517          	auipc	a0,0x3
    4f5c:	fc850513          	addi	a0,a0,-56 # 7f20 <malloc+0x1f04>
    4f60:	00001097          	auipc	ra,0x1
    4f64:	ffe080e7          	jalr	-2(ra) # 5f5e <printf>
    exit(1);
    4f68:	4505                	li	a0,1
    4f6a:	00001097          	auipc	ra,0x1
    4f6e:	c5c080e7          	jalr	-932(ra) # 5bc6 <exit>
      printf("%s: write bigfile failed\n", s);
    4f72:	85d6                	mv	a1,s5
    4f74:	00003517          	auipc	a0,0x3
    4f78:	fcc50513          	addi	a0,a0,-52 # 7f40 <malloc+0x1f24>
    4f7c:	00001097          	auipc	ra,0x1
    4f80:	fe2080e7          	jalr	-30(ra) # 5f5e <printf>
      exit(1);
    4f84:	4505                	li	a0,1
    4f86:	00001097          	auipc	ra,0x1
    4f8a:	c40080e7          	jalr	-960(ra) # 5bc6 <exit>
    printf("%s: cannot open bigfile\n", s);
    4f8e:	85d6                	mv	a1,s5
    4f90:	00003517          	auipc	a0,0x3
    4f94:	fd050513          	addi	a0,a0,-48 # 7f60 <malloc+0x1f44>
    4f98:	00001097          	auipc	ra,0x1
    4f9c:	fc6080e7          	jalr	-58(ra) # 5f5e <printf>
    exit(1);
    4fa0:	4505                	li	a0,1
    4fa2:	00001097          	auipc	ra,0x1
    4fa6:	c24080e7          	jalr	-988(ra) # 5bc6 <exit>
      printf("%s: read bigfile failed\n", s);
    4faa:	85d6                	mv	a1,s5
    4fac:	00003517          	auipc	a0,0x3
    4fb0:	fd450513          	addi	a0,a0,-44 # 7f80 <malloc+0x1f64>
    4fb4:	00001097          	auipc	ra,0x1
    4fb8:	faa080e7          	jalr	-86(ra) # 5f5e <printf>
      exit(1);
    4fbc:	4505                	li	a0,1
    4fbe:	00001097          	auipc	ra,0x1
    4fc2:	c08080e7          	jalr	-1016(ra) # 5bc6 <exit>
      printf("%s: short read bigfile\n", s);
    4fc6:	85d6                	mv	a1,s5
    4fc8:	00003517          	auipc	a0,0x3
    4fcc:	fd850513          	addi	a0,a0,-40 # 7fa0 <malloc+0x1f84>
    4fd0:	00001097          	auipc	ra,0x1
    4fd4:	f8e080e7          	jalr	-114(ra) # 5f5e <printf>
      exit(1);
    4fd8:	4505                	li	a0,1
    4fda:	00001097          	auipc	ra,0x1
    4fde:	bec080e7          	jalr	-1044(ra) # 5bc6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4fe2:	85d6                	mv	a1,s5
    4fe4:	00003517          	auipc	a0,0x3
    4fe8:	fd450513          	addi	a0,a0,-44 # 7fb8 <malloc+0x1f9c>
    4fec:	00001097          	auipc	ra,0x1
    4ff0:	f72080e7          	jalr	-142(ra) # 5f5e <printf>
      exit(1);
    4ff4:	4505                	li	a0,1
    4ff6:	00001097          	auipc	ra,0x1
    4ffa:	bd0080e7          	jalr	-1072(ra) # 5bc6 <exit>
  close(fd);
    4ffe:	8552                	mv	a0,s4
    5000:	00001097          	auipc	ra,0x1
    5004:	bee080e7          	jalr	-1042(ra) # 5bee <close>
  if(total != N*SZ){
    5008:	678d                	lui	a5,0x3
    500a:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0x88>
    500e:	02f99363          	bne	s3,a5,5034 <bigfile+0x1c4>
  unlink("bigfile.dat");
    5012:	00003517          	auipc	a0,0x3
    5016:	efe50513          	addi	a0,a0,-258 # 7f10 <malloc+0x1ef4>
    501a:	00001097          	auipc	ra,0x1
    501e:	bfc080e7          	jalr	-1028(ra) # 5c16 <unlink>
}
    5022:	70e2                	ld	ra,56(sp)
    5024:	7442                	ld	s0,48(sp)
    5026:	74a2                	ld	s1,40(sp)
    5028:	7902                	ld	s2,32(sp)
    502a:	69e2                	ld	s3,24(sp)
    502c:	6a42                	ld	s4,16(sp)
    502e:	6aa2                	ld	s5,8(sp)
    5030:	6121                	addi	sp,sp,64
    5032:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5034:	85d6                	mv	a1,s5
    5036:	00003517          	auipc	a0,0x3
    503a:	fa250513          	addi	a0,a0,-94 # 7fd8 <malloc+0x1fbc>
    503e:	00001097          	auipc	ra,0x1
    5042:	f20080e7          	jalr	-224(ra) # 5f5e <printf>
    exit(1);
    5046:	4505                	li	a0,1
    5048:	00001097          	auipc	ra,0x1
    504c:	b7e080e7          	jalr	-1154(ra) # 5bc6 <exit>

0000000000005050 <reparent>:
{
    5050:	7179                	addi	sp,sp,-48
    5052:	f406                	sd	ra,40(sp)
    5054:	f022                	sd	s0,32(sp)
    5056:	ec26                	sd	s1,24(sp)
    5058:	e84a                	sd	s2,16(sp)
    505a:	e44e                	sd	s3,8(sp)
    505c:	e052                	sd	s4,0(sp)
    505e:	1800                	addi	s0,sp,48
    5060:	89aa                	mv	s3,a0
  int master_pid = getpid();
    5062:	00001097          	auipc	ra,0x1
    5066:	be4080e7          	jalr	-1052(ra) # 5c46 <getpid>
    506a:	8a2a                	mv	s4,a0
    506c:	0c800913          	li	s2,200
    int pid = fork();
    5070:	00001097          	auipc	ra,0x1
    5074:	b4e080e7          	jalr	-1202(ra) # 5bbe <fork>
    5078:	84aa                	mv	s1,a0
    if(pid < 0){
    507a:	02054263          	bltz	a0,509e <reparent+0x4e>
    if(pid){
    507e:	cd21                	beqz	a0,50d6 <reparent+0x86>
      if(wait(0) != pid){
    5080:	4501                	li	a0,0
    5082:	00001097          	auipc	ra,0x1
    5086:	b4c080e7          	jalr	-1204(ra) # 5bce <wait>
    508a:	02951863          	bne	a0,s1,50ba <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    508e:	397d                	addiw	s2,s2,-1
    5090:	fe0910e3          	bnez	s2,5070 <reparent+0x20>
  exit(0);
    5094:	4501                	li	a0,0
    5096:	00001097          	auipc	ra,0x1
    509a:	b30080e7          	jalr	-1232(ra) # 5bc6 <exit>
      printf("%s: fork failed\n", s);
    509e:	85ce                	mv	a1,s3
    50a0:	00002517          	auipc	a0,0x2
    50a4:	94050513          	addi	a0,a0,-1728 # 69e0 <malloc+0x9c4>
    50a8:	00001097          	auipc	ra,0x1
    50ac:	eb6080e7          	jalr	-330(ra) # 5f5e <printf>
      exit(1);
    50b0:	4505                	li	a0,1
    50b2:	00001097          	auipc	ra,0x1
    50b6:	b14080e7          	jalr	-1260(ra) # 5bc6 <exit>
        printf("%s: wait wrong pid\n", s);
    50ba:	85ce                	mv	a1,s3
    50bc:	00002517          	auipc	a0,0x2
    50c0:	aac50513          	addi	a0,a0,-1364 # 6b68 <malloc+0xb4c>
    50c4:	00001097          	auipc	ra,0x1
    50c8:	e9a080e7          	jalr	-358(ra) # 5f5e <printf>
        exit(1);
    50cc:	4505                	li	a0,1
    50ce:	00001097          	auipc	ra,0x1
    50d2:	af8080e7          	jalr	-1288(ra) # 5bc6 <exit>
      int pid2 = fork();
    50d6:	00001097          	auipc	ra,0x1
    50da:	ae8080e7          	jalr	-1304(ra) # 5bbe <fork>
      if(pid2 < 0){
    50de:	00054763          	bltz	a0,50ec <reparent+0x9c>
      exit(0);
    50e2:	4501                	li	a0,0
    50e4:	00001097          	auipc	ra,0x1
    50e8:	ae2080e7          	jalr	-1310(ra) # 5bc6 <exit>
        kill(master_pid);
    50ec:	8552                	mv	a0,s4
    50ee:	00001097          	auipc	ra,0x1
    50f2:	b08080e7          	jalr	-1272(ra) # 5bf6 <kill>
        exit(1);
    50f6:	4505                	li	a0,1
    50f8:	00001097          	auipc	ra,0x1
    50fc:	ace080e7          	jalr	-1330(ra) # 5bc6 <exit>

0000000000005100 <twochildren>:
{
    5100:	1101                	addi	sp,sp,-32
    5102:	ec06                	sd	ra,24(sp)
    5104:	e822                	sd	s0,16(sp)
    5106:	e426                	sd	s1,8(sp)
    5108:	e04a                	sd	s2,0(sp)
    510a:	1000                	addi	s0,sp,32
    510c:	892a                	mv	s2,a0
    510e:	3e800493          	li	s1,1000
    int pid1 = fork();
    5112:	00001097          	auipc	ra,0x1
    5116:	aac080e7          	jalr	-1364(ra) # 5bbe <fork>
    if(pid1 < 0){
    511a:	02054c63          	bltz	a0,5152 <twochildren+0x52>
    if(pid1 == 0){
    511e:	c921                	beqz	a0,516e <twochildren+0x6e>
      int pid2 = fork();
    5120:	00001097          	auipc	ra,0x1
    5124:	a9e080e7          	jalr	-1378(ra) # 5bbe <fork>
      if(pid2 < 0){
    5128:	04054763          	bltz	a0,5176 <twochildren+0x76>
      if(pid2 == 0){
    512c:	c13d                	beqz	a0,5192 <twochildren+0x92>
        wait(0);
    512e:	4501                	li	a0,0
    5130:	00001097          	auipc	ra,0x1
    5134:	a9e080e7          	jalr	-1378(ra) # 5bce <wait>
        wait(0);
    5138:	4501                	li	a0,0
    513a:	00001097          	auipc	ra,0x1
    513e:	a94080e7          	jalr	-1388(ra) # 5bce <wait>
  for(int i = 0; i < 1000; i++){
    5142:	34fd                	addiw	s1,s1,-1
    5144:	f4f9                	bnez	s1,5112 <twochildren+0x12>
}
    5146:	60e2                	ld	ra,24(sp)
    5148:	6442                	ld	s0,16(sp)
    514a:	64a2                	ld	s1,8(sp)
    514c:	6902                	ld	s2,0(sp)
    514e:	6105                	addi	sp,sp,32
    5150:	8082                	ret
      printf("%s: fork failed\n", s);
    5152:	85ca                	mv	a1,s2
    5154:	00002517          	auipc	a0,0x2
    5158:	88c50513          	addi	a0,a0,-1908 # 69e0 <malloc+0x9c4>
    515c:	00001097          	auipc	ra,0x1
    5160:	e02080e7          	jalr	-510(ra) # 5f5e <printf>
      exit(1);
    5164:	4505                	li	a0,1
    5166:	00001097          	auipc	ra,0x1
    516a:	a60080e7          	jalr	-1440(ra) # 5bc6 <exit>
      exit(0);
    516e:	00001097          	auipc	ra,0x1
    5172:	a58080e7          	jalr	-1448(ra) # 5bc6 <exit>
        printf("%s: fork failed\n", s);
    5176:	85ca                	mv	a1,s2
    5178:	00002517          	auipc	a0,0x2
    517c:	86850513          	addi	a0,a0,-1944 # 69e0 <malloc+0x9c4>
    5180:	00001097          	auipc	ra,0x1
    5184:	dde080e7          	jalr	-546(ra) # 5f5e <printf>
        exit(1);
    5188:	4505                	li	a0,1
    518a:	00001097          	auipc	ra,0x1
    518e:	a3c080e7          	jalr	-1476(ra) # 5bc6 <exit>
        exit(0);
    5192:	00001097          	auipc	ra,0x1
    5196:	a34080e7          	jalr	-1484(ra) # 5bc6 <exit>

000000000000519a <forkfork>:
{
    519a:	7179                	addi	sp,sp,-48
    519c:	f406                	sd	ra,40(sp)
    519e:	f022                	sd	s0,32(sp)
    51a0:	ec26                	sd	s1,24(sp)
    51a2:	1800                	addi	s0,sp,48
    51a4:	84aa                	mv	s1,a0
    int pid = fork();
    51a6:	00001097          	auipc	ra,0x1
    51aa:	a18080e7          	jalr	-1512(ra) # 5bbe <fork>
    if(pid < 0){
    51ae:	04054163          	bltz	a0,51f0 <forkfork+0x56>
    if(pid == 0){
    51b2:	cd29                	beqz	a0,520c <forkfork+0x72>
    int pid = fork();
    51b4:	00001097          	auipc	ra,0x1
    51b8:	a0a080e7          	jalr	-1526(ra) # 5bbe <fork>
    if(pid < 0){
    51bc:	02054a63          	bltz	a0,51f0 <forkfork+0x56>
    if(pid == 0){
    51c0:	c531                	beqz	a0,520c <forkfork+0x72>
    wait(&xstatus);
    51c2:	fdc40513          	addi	a0,s0,-36
    51c6:	00001097          	auipc	ra,0x1
    51ca:	a08080e7          	jalr	-1528(ra) # 5bce <wait>
    if(xstatus != 0) {
    51ce:	fdc42783          	lw	a5,-36(s0)
    51d2:	ebbd                	bnez	a5,5248 <forkfork+0xae>
    wait(&xstatus);
    51d4:	fdc40513          	addi	a0,s0,-36
    51d8:	00001097          	auipc	ra,0x1
    51dc:	9f6080e7          	jalr	-1546(ra) # 5bce <wait>
    if(xstatus != 0) {
    51e0:	fdc42783          	lw	a5,-36(s0)
    51e4:	e3b5                	bnez	a5,5248 <forkfork+0xae>
}
    51e6:	70a2                	ld	ra,40(sp)
    51e8:	7402                	ld	s0,32(sp)
    51ea:	64e2                	ld	s1,24(sp)
    51ec:	6145                	addi	sp,sp,48
    51ee:	8082                	ret
      printf("%s: fork failed", s);
    51f0:	85a6                	mv	a1,s1
    51f2:	00003517          	auipc	a0,0x3
    51f6:	abe50513          	addi	a0,a0,-1346 # 7cb0 <malloc+0x1c94>
    51fa:	00001097          	auipc	ra,0x1
    51fe:	d64080e7          	jalr	-668(ra) # 5f5e <printf>
      exit(1);
    5202:	4505                	li	a0,1
    5204:	00001097          	auipc	ra,0x1
    5208:	9c2080e7          	jalr	-1598(ra) # 5bc6 <exit>
{
    520c:	0c800493          	li	s1,200
        int pid1 = fork();
    5210:	00001097          	auipc	ra,0x1
    5214:	9ae080e7          	jalr	-1618(ra) # 5bbe <fork>
        if(pid1 < 0){
    5218:	00054f63          	bltz	a0,5236 <forkfork+0x9c>
        if(pid1 == 0){
    521c:	c115                	beqz	a0,5240 <forkfork+0xa6>
        wait(0);
    521e:	4501                	li	a0,0
    5220:	00001097          	auipc	ra,0x1
    5224:	9ae080e7          	jalr	-1618(ra) # 5bce <wait>
      for(int j = 0; j < 200; j++){
    5228:	34fd                	addiw	s1,s1,-1
    522a:	f0fd                	bnez	s1,5210 <forkfork+0x76>
      exit(0);
    522c:	4501                	li	a0,0
    522e:	00001097          	auipc	ra,0x1
    5232:	998080e7          	jalr	-1640(ra) # 5bc6 <exit>
          exit(1);
    5236:	4505                	li	a0,1
    5238:	00001097          	auipc	ra,0x1
    523c:	98e080e7          	jalr	-1650(ra) # 5bc6 <exit>
          exit(0);
    5240:	00001097          	auipc	ra,0x1
    5244:	986080e7          	jalr	-1658(ra) # 5bc6 <exit>
      printf("%s: fork in child failed", s);
    5248:	85a6                	mv	a1,s1
    524a:	00003517          	auipc	a0,0x3
    524e:	dae50513          	addi	a0,a0,-594 # 7ff8 <malloc+0x1fdc>
    5252:	00001097          	auipc	ra,0x1
    5256:	d0c080e7          	jalr	-756(ra) # 5f5e <printf>
      exit(1);
    525a:	4505                	li	a0,1
    525c:	00001097          	auipc	ra,0x1
    5260:	96a080e7          	jalr	-1686(ra) # 5bc6 <exit>

0000000000005264 <forkforkfork>:
{
    5264:	1101                	addi	sp,sp,-32
    5266:	ec06                	sd	ra,24(sp)
    5268:	e822                	sd	s0,16(sp)
    526a:	e426                	sd	s1,8(sp)
    526c:	1000                	addi	s0,sp,32
    526e:	84aa                	mv	s1,a0
  unlink("stopforking");
    5270:	00003517          	auipc	a0,0x3
    5274:	da850513          	addi	a0,a0,-600 # 8018 <malloc+0x1ffc>
    5278:	00001097          	auipc	ra,0x1
    527c:	99e080e7          	jalr	-1634(ra) # 5c16 <unlink>
  int pid = fork();
    5280:	00001097          	auipc	ra,0x1
    5284:	93e080e7          	jalr	-1730(ra) # 5bbe <fork>
  if(pid < 0){
    5288:	04054563          	bltz	a0,52d2 <forkforkfork+0x6e>
  if(pid == 0){
    528c:	c12d                	beqz	a0,52ee <forkforkfork+0x8a>
  sleep(20); // two seconds
    528e:	4551                	li	a0,20
    5290:	00001097          	auipc	ra,0x1
    5294:	9c6080e7          	jalr	-1594(ra) # 5c56 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    5298:	20200593          	li	a1,514
    529c:	00003517          	auipc	a0,0x3
    52a0:	d7c50513          	addi	a0,a0,-644 # 8018 <malloc+0x1ffc>
    52a4:	00001097          	auipc	ra,0x1
    52a8:	962080e7          	jalr	-1694(ra) # 5c06 <open>
    52ac:	00001097          	auipc	ra,0x1
    52b0:	942080e7          	jalr	-1726(ra) # 5bee <close>
  wait(0);
    52b4:	4501                	li	a0,0
    52b6:	00001097          	auipc	ra,0x1
    52ba:	918080e7          	jalr	-1768(ra) # 5bce <wait>
  sleep(10); // one second
    52be:	4529                	li	a0,10
    52c0:	00001097          	auipc	ra,0x1
    52c4:	996080e7          	jalr	-1642(ra) # 5c56 <sleep>
}
    52c8:	60e2                	ld	ra,24(sp)
    52ca:	6442                	ld	s0,16(sp)
    52cc:	64a2                	ld	s1,8(sp)
    52ce:	6105                	addi	sp,sp,32
    52d0:	8082                	ret
    printf("%s: fork failed", s);
    52d2:	85a6                	mv	a1,s1
    52d4:	00003517          	auipc	a0,0x3
    52d8:	9dc50513          	addi	a0,a0,-1572 # 7cb0 <malloc+0x1c94>
    52dc:	00001097          	auipc	ra,0x1
    52e0:	c82080e7          	jalr	-894(ra) # 5f5e <printf>
    exit(1);
    52e4:	4505                	li	a0,1
    52e6:	00001097          	auipc	ra,0x1
    52ea:	8e0080e7          	jalr	-1824(ra) # 5bc6 <exit>
      int fd = open("stopforking", 0);
    52ee:	00003497          	auipc	s1,0x3
    52f2:	d2a48493          	addi	s1,s1,-726 # 8018 <malloc+0x1ffc>
    52f6:	4581                	li	a1,0
    52f8:	8526                	mv	a0,s1
    52fa:	00001097          	auipc	ra,0x1
    52fe:	90c080e7          	jalr	-1780(ra) # 5c06 <open>
      if(fd >= 0){
    5302:	02055463          	bgez	a0,532a <forkforkfork+0xc6>
      if(fork() < 0){
    5306:	00001097          	auipc	ra,0x1
    530a:	8b8080e7          	jalr	-1864(ra) # 5bbe <fork>
    530e:	fe0554e3          	bgez	a0,52f6 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    5312:	20200593          	li	a1,514
    5316:	8526                	mv	a0,s1
    5318:	00001097          	auipc	ra,0x1
    531c:	8ee080e7          	jalr	-1810(ra) # 5c06 <open>
    5320:	00001097          	auipc	ra,0x1
    5324:	8ce080e7          	jalr	-1842(ra) # 5bee <close>
    5328:	b7f9                	j	52f6 <forkforkfork+0x92>
        exit(0);
    532a:	4501                	li	a0,0
    532c:	00001097          	auipc	ra,0x1
    5330:	89a080e7          	jalr	-1894(ra) # 5bc6 <exit>

0000000000005334 <reparent2>:
{
    5334:	1101                	addi	sp,sp,-32
    5336:	ec06                	sd	ra,24(sp)
    5338:	e822                	sd	s0,16(sp)
    533a:	e426                	sd	s1,8(sp)
    533c:	1000                	addi	s0,sp,32
    533e:	32000493          	li	s1,800
    int pid1 = fork();
    5342:	00001097          	auipc	ra,0x1
    5346:	87c080e7          	jalr	-1924(ra) # 5bbe <fork>
    if(pid1 < 0){
    534a:	00054f63          	bltz	a0,5368 <reparent2+0x34>
    if(pid1 == 0){
    534e:	c915                	beqz	a0,5382 <reparent2+0x4e>
    wait(0);
    5350:	4501                	li	a0,0
    5352:	00001097          	auipc	ra,0x1
    5356:	87c080e7          	jalr	-1924(ra) # 5bce <wait>
  for(int i = 0; i < 800; i++){
    535a:	34fd                	addiw	s1,s1,-1
    535c:	f0fd                	bnez	s1,5342 <reparent2+0xe>
  exit(0);
    535e:	4501                	li	a0,0
    5360:	00001097          	auipc	ra,0x1
    5364:	866080e7          	jalr	-1946(ra) # 5bc6 <exit>
      printf("fork failed\n");
    5368:	00002517          	auipc	a0,0x2
    536c:	a5050513          	addi	a0,a0,-1456 # 6db8 <malloc+0xd9c>
    5370:	00001097          	auipc	ra,0x1
    5374:	bee080e7          	jalr	-1042(ra) # 5f5e <printf>
      exit(1);
    5378:	4505                	li	a0,1
    537a:	00001097          	auipc	ra,0x1
    537e:	84c080e7          	jalr	-1972(ra) # 5bc6 <exit>
      fork();
    5382:	00001097          	auipc	ra,0x1
    5386:	83c080e7          	jalr	-1988(ra) # 5bbe <fork>
      fork();
    538a:	00001097          	auipc	ra,0x1
    538e:	834080e7          	jalr	-1996(ra) # 5bbe <fork>
      exit(0);
    5392:	4501                	li	a0,0
    5394:	00001097          	auipc	ra,0x1
    5398:	832080e7          	jalr	-1998(ra) # 5bc6 <exit>

000000000000539c <fsfull>:
{
    539c:	7171                	addi	sp,sp,-176
    539e:	f506                	sd	ra,168(sp)
    53a0:	f122                	sd	s0,160(sp)
    53a2:	ed26                	sd	s1,152(sp)
    53a4:	e94a                	sd	s2,144(sp)
    53a6:	e54e                	sd	s3,136(sp)
    53a8:	e152                	sd	s4,128(sp)
    53aa:	fcd6                	sd	s5,120(sp)
    53ac:	f8da                	sd	s6,112(sp)
    53ae:	f4de                	sd	s7,104(sp)
    53b0:	f0e2                	sd	s8,96(sp)
    53b2:	ece6                	sd	s9,88(sp)
    53b4:	e8ea                	sd	s10,80(sp)
    53b6:	e4ee                	sd	s11,72(sp)
    53b8:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53ba:	00003517          	auipc	a0,0x3
    53be:	c6e50513          	addi	a0,a0,-914 # 8028 <malloc+0x200c>
    53c2:	00001097          	auipc	ra,0x1
    53c6:	b9c080e7          	jalr	-1124(ra) # 5f5e <printf>
  for(nfiles = 0; ; nfiles++){
    53ca:	4481                	li	s1,0
    name[0] = 'f';
    53cc:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53d0:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53d4:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53d8:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53da:	00003c97          	auipc	s9,0x3
    53de:	c5ec8c93          	addi	s9,s9,-930 # 8038 <malloc+0x201c>
    int total = 0;
    53e2:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    53e4:	00008a17          	auipc	s4,0x8
    53e8:	844a0a13          	addi	s4,s4,-1980 # cc28 <buf>
    name[0] = 'f';
    53ec:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    53f0:	0384c7bb          	divw	a5,s1,s8
    53f4:	0307879b          	addiw	a5,a5,48
    53f8:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53fc:	0384e7bb          	remw	a5,s1,s8
    5400:	0377c7bb          	divw	a5,a5,s7
    5404:	0307879b          	addiw	a5,a5,48
    5408:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    540c:	0374e7bb          	remw	a5,s1,s7
    5410:	0367c7bb          	divw	a5,a5,s6
    5414:	0307879b          	addiw	a5,a5,48
    5418:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    541c:	0364e7bb          	remw	a5,s1,s6
    5420:	0307879b          	addiw	a5,a5,48
    5424:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5428:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    542c:	f5040593          	addi	a1,s0,-176
    5430:	8566                	mv	a0,s9
    5432:	00001097          	auipc	ra,0x1
    5436:	b2c080e7          	jalr	-1236(ra) # 5f5e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    543a:	20200593          	li	a1,514
    543e:	f5040513          	addi	a0,s0,-176
    5442:	00000097          	auipc	ra,0x0
    5446:	7c4080e7          	jalr	1988(ra) # 5c06 <open>
    544a:	892a                	mv	s2,a0
    if(fd < 0){
    544c:	0a055663          	bgez	a0,54f8 <fsfull+0x15c>
      printf("open %s failed\n", name);
    5450:	f5040593          	addi	a1,s0,-176
    5454:	00003517          	auipc	a0,0x3
    5458:	bf450513          	addi	a0,a0,-1036 # 8048 <malloc+0x202c>
    545c:	00001097          	auipc	ra,0x1
    5460:	b02080e7          	jalr	-1278(ra) # 5f5e <printf>
  while(nfiles >= 0){
    5464:	0604c363          	bltz	s1,54ca <fsfull+0x12e>
    name[0] = 'f';
    5468:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    546c:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5470:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5474:	4929                	li	s2,10
  while(nfiles >= 0){
    5476:	5afd                	li	s5,-1
    name[0] = 'f';
    5478:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    547c:	0344c7bb          	divw	a5,s1,s4
    5480:	0307879b          	addiw	a5,a5,48
    5484:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5488:	0344e7bb          	remw	a5,s1,s4
    548c:	0337c7bb          	divw	a5,a5,s3
    5490:	0307879b          	addiw	a5,a5,48
    5494:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5498:	0334e7bb          	remw	a5,s1,s3
    549c:	0327c7bb          	divw	a5,a5,s2
    54a0:	0307879b          	addiw	a5,a5,48
    54a4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54a8:	0324e7bb          	remw	a5,s1,s2
    54ac:	0307879b          	addiw	a5,a5,48
    54b0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54b4:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54b8:	f5040513          	addi	a0,s0,-176
    54bc:	00000097          	auipc	ra,0x0
    54c0:	75a080e7          	jalr	1882(ra) # 5c16 <unlink>
    nfiles--;
    54c4:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54c6:	fb5499e3          	bne	s1,s5,5478 <fsfull+0xdc>
  printf("fsfull test finished\n");
    54ca:	00003517          	auipc	a0,0x3
    54ce:	b9e50513          	addi	a0,a0,-1122 # 8068 <malloc+0x204c>
    54d2:	00001097          	auipc	ra,0x1
    54d6:	a8c080e7          	jalr	-1396(ra) # 5f5e <printf>
}
    54da:	70aa                	ld	ra,168(sp)
    54dc:	740a                	ld	s0,160(sp)
    54de:	64ea                	ld	s1,152(sp)
    54e0:	694a                	ld	s2,144(sp)
    54e2:	69aa                	ld	s3,136(sp)
    54e4:	6a0a                	ld	s4,128(sp)
    54e6:	7ae6                	ld	s5,120(sp)
    54e8:	7b46                	ld	s6,112(sp)
    54ea:	7ba6                	ld	s7,104(sp)
    54ec:	7c06                	ld	s8,96(sp)
    54ee:	6ce6                	ld	s9,88(sp)
    54f0:	6d46                	ld	s10,80(sp)
    54f2:	6da6                	ld	s11,72(sp)
    54f4:	614d                	addi	sp,sp,176
    54f6:	8082                	ret
    int total = 0;
    54f8:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    54fa:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    54fe:	40000613          	li	a2,1024
    5502:	85d2                	mv	a1,s4
    5504:	854a                	mv	a0,s2
    5506:	00000097          	auipc	ra,0x0
    550a:	6e0080e7          	jalr	1760(ra) # 5be6 <write>
      if(cc < BSIZE)
    550e:	00aad563          	bge	s5,a0,5518 <fsfull+0x17c>
      total += cc;
    5512:	00a989bb          	addw	s3,s3,a0
    while(1){
    5516:	b7e5                	j	54fe <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5518:	85ce                	mv	a1,s3
    551a:	00003517          	auipc	a0,0x3
    551e:	b3e50513          	addi	a0,a0,-1218 # 8058 <malloc+0x203c>
    5522:	00001097          	auipc	ra,0x1
    5526:	a3c080e7          	jalr	-1476(ra) # 5f5e <printf>
    close(fd);
    552a:	854a                	mv	a0,s2
    552c:	00000097          	auipc	ra,0x0
    5530:	6c2080e7          	jalr	1730(ra) # 5bee <close>
    if(total == 0)
    5534:	f20988e3          	beqz	s3,5464 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5538:	2485                	addiw	s1,s1,1
    553a:	bd4d                	j	53ec <fsfull+0x50>

000000000000553c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    553c:	7179                	addi	sp,sp,-48
    553e:	f406                	sd	ra,40(sp)
    5540:	f022                	sd	s0,32(sp)
    5542:	ec26                	sd	s1,24(sp)
    5544:	e84a                	sd	s2,16(sp)
    5546:	1800                	addi	s0,sp,48
    5548:	84aa                	mv	s1,a0
    554a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554c:	00003517          	auipc	a0,0x3
    5550:	b3450513          	addi	a0,a0,-1228 # 8080 <malloc+0x2064>
    5554:	00001097          	auipc	ra,0x1
    5558:	a0a080e7          	jalr	-1526(ra) # 5f5e <printf>
  if((pid = fork()) < 0) {
    555c:	00000097          	auipc	ra,0x0
    5560:	662080e7          	jalr	1634(ra) # 5bbe <fork>
    5564:	02054e63          	bltz	a0,55a0 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5568:	c929                	beqz	a0,55ba <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    556a:	fdc40513          	addi	a0,s0,-36
    556e:	00000097          	auipc	ra,0x0
    5572:	660080e7          	jalr	1632(ra) # 5bce <wait>
    if(xstatus != 0) 
    5576:	fdc42783          	lw	a5,-36(s0)
    557a:	c7b9                	beqz	a5,55c8 <run+0x8c>
      printf("FAILED\n");
    557c:	00003517          	auipc	a0,0x3
    5580:	b2c50513          	addi	a0,a0,-1236 # 80a8 <malloc+0x208c>
    5584:	00001097          	auipc	ra,0x1
    5588:	9da080e7          	jalr	-1574(ra) # 5f5e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5590:	00153513          	seqz	a0,a0
    5594:	70a2                	ld	ra,40(sp)
    5596:	7402                	ld	s0,32(sp)
    5598:	64e2                	ld	s1,24(sp)
    559a:	6942                	ld	s2,16(sp)
    559c:	6145                	addi	sp,sp,48
    559e:	8082                	ret
    printf("runtest: fork error\n");
    55a0:	00003517          	auipc	a0,0x3
    55a4:	af050513          	addi	a0,a0,-1296 # 8090 <malloc+0x2074>
    55a8:	00001097          	auipc	ra,0x1
    55ac:	9b6080e7          	jalr	-1610(ra) # 5f5e <printf>
    exit(1);
    55b0:	4505                	li	a0,1
    55b2:	00000097          	auipc	ra,0x0
    55b6:	614080e7          	jalr	1556(ra) # 5bc6 <exit>
    f(s);
    55ba:	854a                	mv	a0,s2
    55bc:	9482                	jalr	s1
    exit(0);
    55be:	4501                	li	a0,0
    55c0:	00000097          	auipc	ra,0x0
    55c4:	606080e7          	jalr	1542(ra) # 5bc6 <exit>
      printf("OK\n");
    55c8:	00003517          	auipc	a0,0x3
    55cc:	ae850513          	addi	a0,a0,-1304 # 80b0 <malloc+0x2094>
    55d0:	00001097          	auipc	ra,0x1
    55d4:	98e080e7          	jalr	-1650(ra) # 5f5e <printf>
    55d8:	bf55                	j	558c <run+0x50>

00000000000055da <runtests>:

int
runtests(struct test *tests, char *justone) {
    55da:	1101                	addi	sp,sp,-32
    55dc:	ec06                	sd	ra,24(sp)
    55de:	e822                	sd	s0,16(sp)
    55e0:	e426                	sd	s1,8(sp)
    55e2:	e04a                	sd	s2,0(sp)
    55e4:	1000                	addi	s0,sp,32
    55e6:	84aa                	mv	s1,a0
    55e8:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55ea:	6508                	ld	a0,8(a0)
    55ec:	ed09                	bnez	a0,5606 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55ee:	4501                	li	a0,0
    55f0:	a82d                	j	562a <runtests+0x50>
      if(!run(t->f, t->s)){
    55f2:	648c                	ld	a1,8(s1)
    55f4:	6088                	ld	a0,0(s1)
    55f6:	00000097          	auipc	ra,0x0
    55fa:	f46080e7          	jalr	-186(ra) # 553c <run>
    55fe:	cd09                	beqz	a0,5618 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5600:	04c1                	addi	s1,s1,16
    5602:	6488                	ld	a0,8(s1)
    5604:	c11d                	beqz	a0,562a <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5606:	fe0906e3          	beqz	s2,55f2 <runtests+0x18>
    560a:	85ca                	mv	a1,s2
    560c:	00000097          	auipc	ra,0x0
    5610:	368080e7          	jalr	872(ra) # 5974 <strcmp>
    5614:	f575                	bnez	a0,5600 <runtests+0x26>
    5616:	bff1                	j	55f2 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5618:	00003517          	auipc	a0,0x3
    561c:	aa050513          	addi	a0,a0,-1376 # 80b8 <malloc+0x209c>
    5620:	00001097          	auipc	ra,0x1
    5624:	93e080e7          	jalr	-1730(ra) # 5f5e <printf>
        return 1;
    5628:	4505                	li	a0,1
}
    562a:	60e2                	ld	ra,24(sp)
    562c:	6442                	ld	s0,16(sp)
    562e:	64a2                	ld	s1,8(sp)
    5630:	6902                	ld	s2,0(sp)
    5632:	6105                	addi	sp,sp,32
    5634:	8082                	ret

0000000000005636 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5636:	7139                	addi	sp,sp,-64
    5638:	fc06                	sd	ra,56(sp)
    563a:	f822                	sd	s0,48(sp)
    563c:	f426                	sd	s1,40(sp)
    563e:	f04a                	sd	s2,32(sp)
    5640:	ec4e                	sd	s3,24(sp)
    5642:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5644:	fc840513          	addi	a0,s0,-56
    5648:	00000097          	auipc	ra,0x0
    564c:	58e080e7          	jalr	1422(ra) # 5bd6 <pipe>
    5650:	06054763          	bltz	a0,56be <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5654:	00000097          	auipc	ra,0x0
    5658:	56a080e7          	jalr	1386(ra) # 5bbe <fork>

  if(pid < 0){
    565c:	06054e63          	bltz	a0,56d8 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5660:	ed51                	bnez	a0,56fc <countfree+0xc6>
    close(fds[0]);
    5662:	fc842503          	lw	a0,-56(s0)
    5666:	00000097          	auipc	ra,0x0
    566a:	588080e7          	jalr	1416(ra) # 5bee <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    566e:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5670:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5672:	00001997          	auipc	s3,0x1
    5676:	b5698993          	addi	s3,s3,-1194 # 61c8 <malloc+0x1ac>
      uint64 a = (uint64) sbrk(4096);
    567a:	6505                	lui	a0,0x1
    567c:	00000097          	auipc	ra,0x0
    5680:	5d2080e7          	jalr	1490(ra) # 5c4e <sbrk>
      if(a == 0xffffffffffffffff){
    5684:	07250763          	beq	a0,s2,56f2 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5688:	6785                	lui	a5,0x1
    568a:	953e                	add	a0,a0,a5
    568c:	fe950fa3          	sb	s1,-1(a0) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5690:	8626                	mv	a2,s1
    5692:	85ce                	mv	a1,s3
    5694:	fcc42503          	lw	a0,-52(s0)
    5698:	00000097          	auipc	ra,0x0
    569c:	54e080e7          	jalr	1358(ra) # 5be6 <write>
    56a0:	fc950de3          	beq	a0,s1,567a <countfree+0x44>
        printf("write() failed in countfree()\n");
    56a4:	00003517          	auipc	a0,0x3
    56a8:	a6c50513          	addi	a0,a0,-1428 # 8110 <malloc+0x20f4>
    56ac:	00001097          	auipc	ra,0x1
    56b0:	8b2080e7          	jalr	-1870(ra) # 5f5e <printf>
        exit(1);
    56b4:	4505                	li	a0,1
    56b6:	00000097          	auipc	ra,0x0
    56ba:	510080e7          	jalr	1296(ra) # 5bc6 <exit>
    printf("pipe() failed in countfree()\n");
    56be:	00003517          	auipc	a0,0x3
    56c2:	a1250513          	addi	a0,a0,-1518 # 80d0 <malloc+0x20b4>
    56c6:	00001097          	auipc	ra,0x1
    56ca:	898080e7          	jalr	-1896(ra) # 5f5e <printf>
    exit(1);
    56ce:	4505                	li	a0,1
    56d0:	00000097          	auipc	ra,0x0
    56d4:	4f6080e7          	jalr	1270(ra) # 5bc6 <exit>
    printf("fork failed in countfree()\n");
    56d8:	00003517          	auipc	a0,0x3
    56dc:	a1850513          	addi	a0,a0,-1512 # 80f0 <malloc+0x20d4>
    56e0:	00001097          	auipc	ra,0x1
    56e4:	87e080e7          	jalr	-1922(ra) # 5f5e <printf>
    exit(1);
    56e8:	4505                	li	a0,1
    56ea:	00000097          	auipc	ra,0x0
    56ee:	4dc080e7          	jalr	1244(ra) # 5bc6 <exit>
      }
    }

    exit(0);
    56f2:	4501                	li	a0,0
    56f4:	00000097          	auipc	ra,0x0
    56f8:	4d2080e7          	jalr	1234(ra) # 5bc6 <exit>
  }

  close(fds[1]);
    56fc:	fcc42503          	lw	a0,-52(s0)
    5700:	00000097          	auipc	ra,0x0
    5704:	4ee080e7          	jalr	1262(ra) # 5bee <close>

  int n = 0;
    5708:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    570a:	4605                	li	a2,1
    570c:	fc740593          	addi	a1,s0,-57
    5710:	fc842503          	lw	a0,-56(s0)
    5714:	00000097          	auipc	ra,0x0
    5718:	4ca080e7          	jalr	1226(ra) # 5bde <read>
    if(cc < 0){
    571c:	00054563          	bltz	a0,5726 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5720:	c105                	beqz	a0,5740 <countfree+0x10a>
      break;
    n += 1;
    5722:	2485                	addiw	s1,s1,1
  while(1){
    5724:	b7dd                	j	570a <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5726:	00003517          	auipc	a0,0x3
    572a:	a0a50513          	addi	a0,a0,-1526 # 8130 <malloc+0x2114>
    572e:	00001097          	auipc	ra,0x1
    5732:	830080e7          	jalr	-2000(ra) # 5f5e <printf>
      exit(1);
    5736:	4505                	li	a0,1
    5738:	00000097          	auipc	ra,0x0
    573c:	48e080e7          	jalr	1166(ra) # 5bc6 <exit>
  }

  close(fds[0]);
    5740:	fc842503          	lw	a0,-56(s0)
    5744:	00000097          	auipc	ra,0x0
    5748:	4aa080e7          	jalr	1194(ra) # 5bee <close>
  wait((int*)0);
    574c:	4501                	li	a0,0
    574e:	00000097          	auipc	ra,0x0
    5752:	480080e7          	jalr	1152(ra) # 5bce <wait>
  
  return n;
}
    5756:	8526                	mv	a0,s1
    5758:	70e2                	ld	ra,56(sp)
    575a:	7442                	ld	s0,48(sp)
    575c:	74a2                	ld	s1,40(sp)
    575e:	7902                	ld	s2,32(sp)
    5760:	69e2                	ld	s3,24(sp)
    5762:	6121                	addi	sp,sp,64
    5764:	8082                	ret

0000000000005766 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5766:	711d                	addi	sp,sp,-96
    5768:	ec86                	sd	ra,88(sp)
    576a:	e8a2                	sd	s0,80(sp)
    576c:	e4a6                	sd	s1,72(sp)
    576e:	e0ca                	sd	s2,64(sp)
    5770:	fc4e                	sd	s3,56(sp)
    5772:	f852                	sd	s4,48(sp)
    5774:	f456                	sd	s5,40(sp)
    5776:	f05a                	sd	s6,32(sp)
    5778:	ec5e                	sd	s7,24(sp)
    577a:	e862                	sd	s8,16(sp)
    577c:	e466                	sd	s9,8(sp)
    577e:	e06a                	sd	s10,0(sp)
    5780:	1080                	addi	s0,sp,96
    5782:	8a2a                	mv	s4,a0
    5784:	89ae                	mv	s3,a1
    5786:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    5788:	00003b97          	auipc	s7,0x3
    578c:	9c8b8b93          	addi	s7,s7,-1592 # 8150 <malloc+0x2134>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5790:	00004b17          	auipc	s6,0x4
    5794:	880b0b13          	addi	s6,s6,-1920 # 9010 <quicktests>
      if(continuous != 2) {
    5798:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    579a:	00003c97          	auipc	s9,0x3
    579e:	9eec8c93          	addi	s9,s9,-1554 # 8188 <malloc+0x216c>
      if (runtests(slowtests, justone)) {
    57a2:	00004c17          	auipc	s8,0x4
    57a6:	beec0c13          	addi	s8,s8,-1042 # 9390 <slowtests>
        printf("usertests slow tests starting\n");
    57aa:	00003d17          	auipc	s10,0x3
    57ae:	9bed0d13          	addi	s10,s10,-1602 # 8168 <malloc+0x214c>
    57b2:	a839                	j	57d0 <drivetests+0x6a>
    57b4:	856a                	mv	a0,s10
    57b6:	00000097          	auipc	ra,0x0
    57ba:	7a8080e7          	jalr	1960(ra) # 5f5e <printf>
    57be:	a081                	j	57fe <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57c0:	00000097          	auipc	ra,0x0
    57c4:	e76080e7          	jalr	-394(ra) # 5636 <countfree>
    57c8:	06954263          	blt	a0,s1,582c <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57cc:	06098f63          	beqz	s3,584a <drivetests+0xe4>
    printf("usertests starting\n");
    57d0:	855e                	mv	a0,s7
    57d2:	00000097          	auipc	ra,0x0
    57d6:	78c080e7          	jalr	1932(ra) # 5f5e <printf>
    int free0 = countfree();
    57da:	00000097          	auipc	ra,0x0
    57de:	e5c080e7          	jalr	-420(ra) # 5636 <countfree>
    57e2:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57e4:	85ca                	mv	a1,s2
    57e6:	855a                	mv	a0,s6
    57e8:	00000097          	auipc	ra,0x0
    57ec:	df2080e7          	jalr	-526(ra) # 55da <runtests>
    57f0:	c119                	beqz	a0,57f6 <drivetests+0x90>
      if(continuous != 2) {
    57f2:	05599863          	bne	s3,s5,5842 <drivetests+0xdc>
    if(!quick) {
    57f6:	fc0a15e3          	bnez	s4,57c0 <drivetests+0x5a>
      if (justone == 0)
    57fa:	fa090de3          	beqz	s2,57b4 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    57fe:	85ca                	mv	a1,s2
    5800:	8562                	mv	a0,s8
    5802:	00000097          	auipc	ra,0x0
    5806:	dd8080e7          	jalr	-552(ra) # 55da <runtests>
    580a:	d95d                	beqz	a0,57c0 <drivetests+0x5a>
        if(continuous != 2) {
    580c:	03599d63          	bne	s3,s5,5846 <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    5810:	00000097          	auipc	ra,0x0
    5814:	e26080e7          	jalr	-474(ra) # 5636 <countfree>
    5818:	fa955ae3          	bge	a0,s1,57cc <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    581c:	8626                	mv	a2,s1
    581e:	85aa                	mv	a1,a0
    5820:	8566                	mv	a0,s9
    5822:	00000097          	auipc	ra,0x0
    5826:	73c080e7          	jalr	1852(ra) # 5f5e <printf>
      if(continuous != 2) {
    582a:	b75d                	j	57d0 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    582c:	8626                	mv	a2,s1
    582e:	85aa                	mv	a1,a0
    5830:	8566                	mv	a0,s9
    5832:	00000097          	auipc	ra,0x0
    5836:	72c080e7          	jalr	1836(ra) # 5f5e <printf>
      if(continuous != 2) {
    583a:	f9598be3          	beq	s3,s5,57d0 <drivetests+0x6a>
        return 1;
    583e:	4505                	li	a0,1
    5840:	a031                	j	584c <drivetests+0xe6>
        return 1;
    5842:	4505                	li	a0,1
    5844:	a021                	j	584c <drivetests+0xe6>
          return 1;
    5846:	4505                	li	a0,1
    5848:	a011                	j	584c <drivetests+0xe6>
  return 0;
    584a:	854e                	mv	a0,s3
}
    584c:	60e6                	ld	ra,88(sp)
    584e:	6446                	ld	s0,80(sp)
    5850:	64a6                	ld	s1,72(sp)
    5852:	6906                	ld	s2,64(sp)
    5854:	79e2                	ld	s3,56(sp)
    5856:	7a42                	ld	s4,48(sp)
    5858:	7aa2                	ld	s5,40(sp)
    585a:	7b02                	ld	s6,32(sp)
    585c:	6be2                	ld	s7,24(sp)
    585e:	6c42                	ld	s8,16(sp)
    5860:	6ca2                	ld	s9,8(sp)
    5862:	6d02                	ld	s10,0(sp)
    5864:	6125                	addi	sp,sp,96
    5866:	8082                	ret

0000000000005868 <main>:

int
main(int argc, char *argv[])
{
    5868:	1101                	addi	sp,sp,-32
    586a:	ec06                	sd	ra,24(sp)
    586c:	e822                	sd	s0,16(sp)
    586e:	e426                	sd	s1,8(sp)
    5870:	e04a                	sd	s2,0(sp)
    5872:	1000                	addi	s0,sp,32
    5874:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5876:	4789                	li	a5,2
    5878:	02f50363          	beq	a0,a5,589e <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    587c:	4785                	li	a5,1
    587e:	06a7cd63          	blt	a5,a0,58f8 <main+0x90>
  char *justone = 0;
    5882:	4601                	li	a2,0
  int quick = 0;
    5884:	4501                	li	a0,0
  int continuous = 0;
    5886:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5888:	85a6                	mv	a1,s1
    588a:	00000097          	auipc	ra,0x0
    588e:	edc080e7          	jalr	-292(ra) # 5766 <drivetests>
    5892:	c949                	beqz	a0,5924 <main+0xbc>
    exit(1);
    5894:	4505                	li	a0,1
    5896:	00000097          	auipc	ra,0x0
    589a:	330080e7          	jalr	816(ra) # 5bc6 <exit>
    589e:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a0:	00003597          	auipc	a1,0x3
    58a4:	91858593          	addi	a1,a1,-1768 # 81b8 <malloc+0x219c>
    58a8:	00893503          	ld	a0,8(s2)
    58ac:	00000097          	auipc	ra,0x0
    58b0:	0c8080e7          	jalr	200(ra) # 5974 <strcmp>
    58b4:	cd39                	beqz	a0,5912 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58b6:	00003597          	auipc	a1,0x3
    58ba:	95a58593          	addi	a1,a1,-1702 # 8210 <malloc+0x21f4>
    58be:	00893503          	ld	a0,8(s2)
    58c2:	00000097          	auipc	ra,0x0
    58c6:	0b2080e7          	jalr	178(ra) # 5974 <strcmp>
    58ca:	c931                	beqz	a0,591e <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58cc:	00003597          	auipc	a1,0x3
    58d0:	93c58593          	addi	a1,a1,-1732 # 8208 <malloc+0x21ec>
    58d4:	00893503          	ld	a0,8(s2)
    58d8:	00000097          	auipc	ra,0x0
    58dc:	09c080e7          	jalr	156(ra) # 5974 <strcmp>
    58e0:	cd0d                	beqz	a0,591a <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    58e2:	00893603          	ld	a2,8(s2)
    58e6:	00064703          	lbu	a4,0(a2) # 3000 <diskfull+0x4>
    58ea:	02d00793          	li	a5,45
    58ee:	00f70563          	beq	a4,a5,58f8 <main+0x90>
  int quick = 0;
    58f2:	4501                	li	a0,0
  int continuous = 0;
    58f4:	4481                	li	s1,0
    58f6:	bf49                	j	5888 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58f8:	00003517          	auipc	a0,0x3
    58fc:	8c850513          	addi	a0,a0,-1848 # 81c0 <malloc+0x21a4>
    5900:	00000097          	auipc	ra,0x0
    5904:	65e080e7          	jalr	1630(ra) # 5f5e <printf>
    exit(1);
    5908:	4505                	li	a0,1
    590a:	00000097          	auipc	ra,0x0
    590e:	2bc080e7          	jalr	700(ra) # 5bc6 <exit>
  int continuous = 0;
    5912:	84aa                	mv	s1,a0
  char *justone = 0;
    5914:	4601                	li	a2,0
    quick = 1;
    5916:	4505                	li	a0,1
    5918:	bf85                	j	5888 <main+0x20>
  char *justone = 0;
    591a:	4601                	li	a2,0
    591c:	b7b5                	j	5888 <main+0x20>
    591e:	4601                	li	a2,0
    continuous = 1;
    5920:	4485                	li	s1,1
    5922:	b79d                	j	5888 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5924:	00003517          	auipc	a0,0x3
    5928:	8cc50513          	addi	a0,a0,-1844 # 81f0 <malloc+0x21d4>
    592c:	00000097          	auipc	ra,0x0
    5930:	632080e7          	jalr	1586(ra) # 5f5e <printf>
  exit(0);
    5934:	4501                	li	a0,0
    5936:	00000097          	auipc	ra,0x0
    593a:	290080e7          	jalr	656(ra) # 5bc6 <exit>

000000000000593e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    593e:	1141                	addi	sp,sp,-16
    5940:	e406                	sd	ra,8(sp)
    5942:	e022                	sd	s0,0(sp)
    5944:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5946:	00000097          	auipc	ra,0x0
    594a:	f22080e7          	jalr	-222(ra) # 5868 <main>
  exit(0);
    594e:	4501                	li	a0,0
    5950:	00000097          	auipc	ra,0x0
    5954:	276080e7          	jalr	630(ra) # 5bc6 <exit>

0000000000005958 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5958:	1141                	addi	sp,sp,-16
    595a:	e422                	sd	s0,8(sp)
    595c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    595e:	87aa                	mv	a5,a0
    5960:	0585                	addi	a1,a1,1
    5962:	0785                	addi	a5,a5,1 # 1001 <linktest+0x10b>
    5964:	fff5c703          	lbu	a4,-1(a1)
    5968:	fee78fa3          	sb	a4,-1(a5)
    596c:	fb75                	bnez	a4,5960 <strcpy+0x8>
    ;
  return os;
}
    596e:	6422                	ld	s0,8(sp)
    5970:	0141                	addi	sp,sp,16
    5972:	8082                	ret

0000000000005974 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5974:	1141                	addi	sp,sp,-16
    5976:	e422                	sd	s0,8(sp)
    5978:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    597a:	00054783          	lbu	a5,0(a0)
    597e:	cb91                	beqz	a5,5992 <strcmp+0x1e>
    5980:	0005c703          	lbu	a4,0(a1)
    5984:	00f71763          	bne	a4,a5,5992 <strcmp+0x1e>
    p++, q++;
    5988:	0505                	addi	a0,a0,1
    598a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    598c:	00054783          	lbu	a5,0(a0)
    5990:	fbe5                	bnez	a5,5980 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5992:	0005c503          	lbu	a0,0(a1)
}
    5996:	40a7853b          	subw	a0,a5,a0
    599a:	6422                	ld	s0,8(sp)
    599c:	0141                	addi	sp,sp,16
    599e:	8082                	ret

00000000000059a0 <strlen>:

uint
strlen(const char *s)
{
    59a0:	1141                	addi	sp,sp,-16
    59a2:	e422                	sd	s0,8(sp)
    59a4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59a6:	00054783          	lbu	a5,0(a0)
    59aa:	cf91                	beqz	a5,59c6 <strlen+0x26>
    59ac:	0505                	addi	a0,a0,1
    59ae:	87aa                	mv	a5,a0
    59b0:	4685                	li	a3,1
    59b2:	9e89                	subw	a3,a3,a0
    59b4:	00f6853b          	addw	a0,a3,a5
    59b8:	0785                	addi	a5,a5,1
    59ba:	fff7c703          	lbu	a4,-1(a5)
    59be:	fb7d                	bnez	a4,59b4 <strlen+0x14>
    ;
  return n;
}
    59c0:	6422                	ld	s0,8(sp)
    59c2:	0141                	addi	sp,sp,16
    59c4:	8082                	ret
  for(n = 0; s[n]; n++)
    59c6:	4501                	li	a0,0
    59c8:	bfe5                	j	59c0 <strlen+0x20>

00000000000059ca <memset>:

void*
memset(void *dst, int c, uint n)
{
    59ca:	1141                	addi	sp,sp,-16
    59cc:	e422                	sd	s0,8(sp)
    59ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59d0:	ca19                	beqz	a2,59e6 <memset+0x1c>
    59d2:	87aa                	mv	a5,a0
    59d4:	1602                	slli	a2,a2,0x20
    59d6:	9201                	srli	a2,a2,0x20
    59d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59e0:	0785                	addi	a5,a5,1
    59e2:	fee79de3          	bne	a5,a4,59dc <memset+0x12>
  }
  return dst;
}
    59e6:	6422                	ld	s0,8(sp)
    59e8:	0141                	addi	sp,sp,16
    59ea:	8082                	ret

00000000000059ec <strchr>:

char*
strchr(const char *s, char c)
{
    59ec:	1141                	addi	sp,sp,-16
    59ee:	e422                	sd	s0,8(sp)
    59f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59f2:	00054783          	lbu	a5,0(a0)
    59f6:	cb99                	beqz	a5,5a0c <strchr+0x20>
    if(*s == c)
    59f8:	00f58763          	beq	a1,a5,5a06 <strchr+0x1a>
  for(; *s; s++)
    59fc:	0505                	addi	a0,a0,1
    59fe:	00054783          	lbu	a5,0(a0)
    5a02:	fbfd                	bnez	a5,59f8 <strchr+0xc>
      return (char*)s;
  return 0;
    5a04:	4501                	li	a0,0
}
    5a06:	6422                	ld	s0,8(sp)
    5a08:	0141                	addi	sp,sp,16
    5a0a:	8082                	ret
  return 0;
    5a0c:	4501                	li	a0,0
    5a0e:	bfe5                	j	5a06 <strchr+0x1a>

0000000000005a10 <gets>:

char*
gets(char *buf, int max)
{
    5a10:	711d                	addi	sp,sp,-96
    5a12:	ec86                	sd	ra,88(sp)
    5a14:	e8a2                	sd	s0,80(sp)
    5a16:	e4a6                	sd	s1,72(sp)
    5a18:	e0ca                	sd	s2,64(sp)
    5a1a:	fc4e                	sd	s3,56(sp)
    5a1c:	f852                	sd	s4,48(sp)
    5a1e:	f456                	sd	s5,40(sp)
    5a20:	f05a                	sd	s6,32(sp)
    5a22:	ec5e                	sd	s7,24(sp)
    5a24:	1080                	addi	s0,sp,96
    5a26:	8baa                	mv	s7,a0
    5a28:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a2a:	892a                	mv	s2,a0
    5a2c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a2e:	4aa9                	li	s5,10
    5a30:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a32:	89a6                	mv	s3,s1
    5a34:	2485                	addiw	s1,s1,1
    5a36:	0344d863          	bge	s1,s4,5a66 <gets+0x56>
    cc = read(0, &c, 1);
    5a3a:	4605                	li	a2,1
    5a3c:	faf40593          	addi	a1,s0,-81
    5a40:	4501                	li	a0,0
    5a42:	00000097          	auipc	ra,0x0
    5a46:	19c080e7          	jalr	412(ra) # 5bde <read>
    if(cc < 1)
    5a4a:	00a05e63          	blez	a0,5a66 <gets+0x56>
    buf[i++] = c;
    5a4e:	faf44783          	lbu	a5,-81(s0)
    5a52:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a56:	01578763          	beq	a5,s5,5a64 <gets+0x54>
    5a5a:	0905                	addi	s2,s2,1
    5a5c:	fd679be3          	bne	a5,s6,5a32 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a60:	89a6                	mv	s3,s1
    5a62:	a011                	j	5a66 <gets+0x56>
    5a64:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a66:	99de                	add	s3,s3,s7
    5a68:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a6c:	855e                	mv	a0,s7
    5a6e:	60e6                	ld	ra,88(sp)
    5a70:	6446                	ld	s0,80(sp)
    5a72:	64a6                	ld	s1,72(sp)
    5a74:	6906                	ld	s2,64(sp)
    5a76:	79e2                	ld	s3,56(sp)
    5a78:	7a42                	ld	s4,48(sp)
    5a7a:	7aa2                	ld	s5,40(sp)
    5a7c:	7b02                	ld	s6,32(sp)
    5a7e:	6be2                	ld	s7,24(sp)
    5a80:	6125                	addi	sp,sp,96
    5a82:	8082                	ret

0000000000005a84 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a84:	1101                	addi	sp,sp,-32
    5a86:	ec06                	sd	ra,24(sp)
    5a88:	e822                	sd	s0,16(sp)
    5a8a:	e426                	sd	s1,8(sp)
    5a8c:	e04a                	sd	s2,0(sp)
    5a8e:	1000                	addi	s0,sp,32
    5a90:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a92:	4581                	li	a1,0
    5a94:	00000097          	auipc	ra,0x0
    5a98:	172080e7          	jalr	370(ra) # 5c06 <open>
  if(fd < 0)
    5a9c:	02054563          	bltz	a0,5ac6 <stat+0x42>
    5aa0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5aa2:	85ca                	mv	a1,s2
    5aa4:	00000097          	auipc	ra,0x0
    5aa8:	17a080e7          	jalr	378(ra) # 5c1e <fstat>
    5aac:	892a                	mv	s2,a0
  close(fd);
    5aae:	8526                	mv	a0,s1
    5ab0:	00000097          	auipc	ra,0x0
    5ab4:	13e080e7          	jalr	318(ra) # 5bee <close>
  return r;
}
    5ab8:	854a                	mv	a0,s2
    5aba:	60e2                	ld	ra,24(sp)
    5abc:	6442                	ld	s0,16(sp)
    5abe:	64a2                	ld	s1,8(sp)
    5ac0:	6902                	ld	s2,0(sp)
    5ac2:	6105                	addi	sp,sp,32
    5ac4:	8082                	ret
    return -1;
    5ac6:	597d                	li	s2,-1
    5ac8:	bfc5                	j	5ab8 <stat+0x34>

0000000000005aca <atoi>:

int
atoi(const char *s)
{
    5aca:	1141                	addi	sp,sp,-16
    5acc:	e422                	sd	s0,8(sp)
    5ace:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ad0:	00054603          	lbu	a2,0(a0)
    5ad4:	fd06079b          	addiw	a5,a2,-48
    5ad8:	0ff7f793          	zext.b	a5,a5
    5adc:	4725                	li	a4,9
    5ade:	02f76963          	bltu	a4,a5,5b10 <atoi+0x46>
    5ae2:	86aa                	mv	a3,a0
  n = 0;
    5ae4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5ae6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5ae8:	0685                	addi	a3,a3,1
    5aea:	0025179b          	slliw	a5,a0,0x2
    5aee:	9fa9                	addw	a5,a5,a0
    5af0:	0017979b          	slliw	a5,a5,0x1
    5af4:	9fb1                	addw	a5,a5,a2
    5af6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5afa:	0006c603          	lbu	a2,0(a3)
    5afe:	fd06071b          	addiw	a4,a2,-48
    5b02:	0ff77713          	zext.b	a4,a4
    5b06:	fee5f1e3          	bgeu	a1,a4,5ae8 <atoi+0x1e>
  return n;
}
    5b0a:	6422                	ld	s0,8(sp)
    5b0c:	0141                	addi	sp,sp,16
    5b0e:	8082                	ret
  n = 0;
    5b10:	4501                	li	a0,0
    5b12:	bfe5                	j	5b0a <atoi+0x40>

0000000000005b14 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b14:	1141                	addi	sp,sp,-16
    5b16:	e422                	sd	s0,8(sp)
    5b18:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b1a:	02b57463          	bgeu	a0,a1,5b42 <memmove+0x2e>
    while(n-- > 0)
    5b1e:	00c05f63          	blez	a2,5b3c <memmove+0x28>
    5b22:	1602                	slli	a2,a2,0x20
    5b24:	9201                	srli	a2,a2,0x20
    5b26:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b2a:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b2c:	0585                	addi	a1,a1,1
    5b2e:	0705                	addi	a4,a4,1
    5b30:	fff5c683          	lbu	a3,-1(a1)
    5b34:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b38:	fee79ae3          	bne	a5,a4,5b2c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b3c:	6422                	ld	s0,8(sp)
    5b3e:	0141                	addi	sp,sp,16
    5b40:	8082                	ret
    dst += n;
    5b42:	00c50733          	add	a4,a0,a2
    src += n;
    5b46:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b48:	fec05ae3          	blez	a2,5b3c <memmove+0x28>
    5b4c:	fff6079b          	addiw	a5,a2,-1
    5b50:	1782                	slli	a5,a5,0x20
    5b52:	9381                	srli	a5,a5,0x20
    5b54:	fff7c793          	not	a5,a5
    5b58:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b5a:	15fd                	addi	a1,a1,-1
    5b5c:	177d                	addi	a4,a4,-1
    5b5e:	0005c683          	lbu	a3,0(a1)
    5b62:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b66:	fee79ae3          	bne	a5,a4,5b5a <memmove+0x46>
    5b6a:	bfc9                	j	5b3c <memmove+0x28>

0000000000005b6c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b6c:	1141                	addi	sp,sp,-16
    5b6e:	e422                	sd	s0,8(sp)
    5b70:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b72:	ca05                	beqz	a2,5ba2 <memcmp+0x36>
    5b74:	fff6069b          	addiw	a3,a2,-1
    5b78:	1682                	slli	a3,a3,0x20
    5b7a:	9281                	srli	a3,a3,0x20
    5b7c:	0685                	addi	a3,a3,1
    5b7e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b80:	00054783          	lbu	a5,0(a0)
    5b84:	0005c703          	lbu	a4,0(a1)
    5b88:	00e79863          	bne	a5,a4,5b98 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b8c:	0505                	addi	a0,a0,1
    p2++;
    5b8e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b90:	fed518e3          	bne	a0,a3,5b80 <memcmp+0x14>
  }
  return 0;
    5b94:	4501                	li	a0,0
    5b96:	a019                	j	5b9c <memcmp+0x30>
      return *p1 - *p2;
    5b98:	40e7853b          	subw	a0,a5,a4
}
    5b9c:	6422                	ld	s0,8(sp)
    5b9e:	0141                	addi	sp,sp,16
    5ba0:	8082                	ret
  return 0;
    5ba2:	4501                	li	a0,0
    5ba4:	bfe5                	j	5b9c <memcmp+0x30>

0000000000005ba6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5ba6:	1141                	addi	sp,sp,-16
    5ba8:	e406                	sd	ra,8(sp)
    5baa:	e022                	sd	s0,0(sp)
    5bac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bae:	00000097          	auipc	ra,0x0
    5bb2:	f66080e7          	jalr	-154(ra) # 5b14 <memmove>
}
    5bb6:	60a2                	ld	ra,8(sp)
    5bb8:	6402                	ld	s0,0(sp)
    5bba:	0141                	addi	sp,sp,16
    5bbc:	8082                	ret

0000000000005bbe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bbe:	4885                	li	a7,1
 ecall
    5bc0:	00000073          	ecall
 ret
    5bc4:	8082                	ret

0000000000005bc6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bc6:	4889                	li	a7,2
 ecall
    5bc8:	00000073          	ecall
 ret
    5bcc:	8082                	ret

0000000000005bce <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bce:	488d                	li	a7,3
 ecall
    5bd0:	00000073          	ecall
 ret
    5bd4:	8082                	ret

0000000000005bd6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bd6:	4891                	li	a7,4
 ecall
    5bd8:	00000073          	ecall
 ret
    5bdc:	8082                	ret

0000000000005bde <read>:
.global read
read:
 li a7, SYS_read
    5bde:	4895                	li	a7,5
 ecall
    5be0:	00000073          	ecall
 ret
    5be4:	8082                	ret

0000000000005be6 <write>:
.global write
write:
 li a7, SYS_write
    5be6:	48c1                	li	a7,16
 ecall
    5be8:	00000073          	ecall
 ret
    5bec:	8082                	ret

0000000000005bee <close>:
.global close
close:
 li a7, SYS_close
    5bee:	48d5                	li	a7,21
 ecall
    5bf0:	00000073          	ecall
 ret
    5bf4:	8082                	ret

0000000000005bf6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bf6:	4899                	li	a7,6
 ecall
    5bf8:	00000073          	ecall
 ret
    5bfc:	8082                	ret

0000000000005bfe <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bfe:	489d                	li	a7,7
 ecall
    5c00:	00000073          	ecall
 ret
    5c04:	8082                	ret

0000000000005c06 <open>:
.global open
open:
 li a7, SYS_open
    5c06:	48bd                	li	a7,15
 ecall
    5c08:	00000073          	ecall
 ret
    5c0c:	8082                	ret

0000000000005c0e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c0e:	48c5                	li	a7,17
 ecall
    5c10:	00000073          	ecall
 ret
    5c14:	8082                	ret

0000000000005c16 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c16:	48c9                	li	a7,18
 ecall
    5c18:	00000073          	ecall
 ret
    5c1c:	8082                	ret

0000000000005c1e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c1e:	48a1                	li	a7,8
 ecall
    5c20:	00000073          	ecall
 ret
    5c24:	8082                	ret

0000000000005c26 <link>:
.global link
link:
 li a7, SYS_link
    5c26:	48cd                	li	a7,19
 ecall
    5c28:	00000073          	ecall
 ret
    5c2c:	8082                	ret

0000000000005c2e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c2e:	48d1                	li	a7,20
 ecall
    5c30:	00000073          	ecall
 ret
    5c34:	8082                	ret

0000000000005c36 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c36:	48a5                	li	a7,9
 ecall
    5c38:	00000073          	ecall
 ret
    5c3c:	8082                	ret

0000000000005c3e <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c3e:	48a9                	li	a7,10
 ecall
    5c40:	00000073          	ecall
 ret
    5c44:	8082                	ret

0000000000005c46 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c46:	48ad                	li	a7,11
 ecall
    5c48:	00000073          	ecall
 ret
    5c4c:	8082                	ret

0000000000005c4e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c4e:	48b1                	li	a7,12
 ecall
    5c50:	00000073          	ecall
 ret
    5c54:	8082                	ret

0000000000005c56 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c56:	48b5                	li	a7,13
 ecall
    5c58:	00000073          	ecall
 ret
    5c5c:	8082                	ret

0000000000005c5e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c5e:	48b9                	li	a7,14
 ecall
    5c60:	00000073          	ecall
 ret
    5c64:	8082                	ret

0000000000005c66 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c66:	48d9                	li	a7,22
 ecall
    5c68:	00000073          	ecall
 ret
    5c6c:	8082                	ret

0000000000005c6e <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
    5c6e:	48dd                	li	a7,23
 ecall
    5c70:	00000073          	ecall
 ret
    5c74:	8082                	ret

0000000000005c76 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5c76:	48e1                	li	a7,24
 ecall
    5c78:	00000073          	ecall
 ret
    5c7c:	8082                	ret

0000000000005c7e <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5c7e:	48e5                	li	a7,25
 ecall
    5c80:	00000073          	ecall
 ret
    5c84:	8082                	ret

0000000000005c86 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c86:	1101                	addi	sp,sp,-32
    5c88:	ec06                	sd	ra,24(sp)
    5c8a:	e822                	sd	s0,16(sp)
    5c8c:	1000                	addi	s0,sp,32
    5c8e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c92:	4605                	li	a2,1
    5c94:	fef40593          	addi	a1,s0,-17
    5c98:	00000097          	auipc	ra,0x0
    5c9c:	f4e080e7          	jalr	-178(ra) # 5be6 <write>
}
    5ca0:	60e2                	ld	ra,24(sp)
    5ca2:	6442                	ld	s0,16(sp)
    5ca4:	6105                	addi	sp,sp,32
    5ca6:	8082                	ret

0000000000005ca8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5ca8:	7139                	addi	sp,sp,-64
    5caa:	fc06                	sd	ra,56(sp)
    5cac:	f822                	sd	s0,48(sp)
    5cae:	f426                	sd	s1,40(sp)
    5cb0:	f04a                	sd	s2,32(sp)
    5cb2:	ec4e                	sd	s3,24(sp)
    5cb4:	0080                	addi	s0,sp,64
    5cb6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5cb8:	c299                	beqz	a3,5cbe <printint+0x16>
    5cba:	0805c863          	bltz	a1,5d4a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cbe:	2581                	sext.w	a1,a1
  neg = 0;
    5cc0:	4881                	li	a7,0
    5cc2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cc6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cc8:	2601                	sext.w	a2,a2
    5cca:	00003517          	auipc	a0,0x3
    5cce:	86650513          	addi	a0,a0,-1946 # 8530 <digits>
    5cd2:	883a                	mv	a6,a4
    5cd4:	2705                	addiw	a4,a4,1
    5cd6:	02c5f7bb          	remuw	a5,a1,a2
    5cda:	1782                	slli	a5,a5,0x20
    5cdc:	9381                	srli	a5,a5,0x20
    5cde:	97aa                	add	a5,a5,a0
    5ce0:	0007c783          	lbu	a5,0(a5)
    5ce4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5ce8:	0005879b          	sext.w	a5,a1
    5cec:	02c5d5bb          	divuw	a1,a1,a2
    5cf0:	0685                	addi	a3,a3,1
    5cf2:	fec7f0e3          	bgeu	a5,a2,5cd2 <printint+0x2a>
  if(neg)
    5cf6:	00088b63          	beqz	a7,5d0c <printint+0x64>
    buf[i++] = '-';
    5cfa:	fd040793          	addi	a5,s0,-48
    5cfe:	973e                	add	a4,a4,a5
    5d00:	02d00793          	li	a5,45
    5d04:	fef70823          	sb	a5,-16(a4)
    5d08:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d0c:	02e05863          	blez	a4,5d3c <printint+0x94>
    5d10:	fc040793          	addi	a5,s0,-64
    5d14:	00e78933          	add	s2,a5,a4
    5d18:	fff78993          	addi	s3,a5,-1
    5d1c:	99ba                	add	s3,s3,a4
    5d1e:	377d                	addiw	a4,a4,-1
    5d20:	1702                	slli	a4,a4,0x20
    5d22:	9301                	srli	a4,a4,0x20
    5d24:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d28:	fff94583          	lbu	a1,-1(s2)
    5d2c:	8526                	mv	a0,s1
    5d2e:	00000097          	auipc	ra,0x0
    5d32:	f58080e7          	jalr	-168(ra) # 5c86 <putc>
  while(--i >= 0)
    5d36:	197d                	addi	s2,s2,-1
    5d38:	ff3918e3          	bne	s2,s3,5d28 <printint+0x80>
}
    5d3c:	70e2                	ld	ra,56(sp)
    5d3e:	7442                	ld	s0,48(sp)
    5d40:	74a2                	ld	s1,40(sp)
    5d42:	7902                	ld	s2,32(sp)
    5d44:	69e2                	ld	s3,24(sp)
    5d46:	6121                	addi	sp,sp,64
    5d48:	8082                	ret
    x = -xx;
    5d4a:	40b005bb          	negw	a1,a1
    neg = 1;
    5d4e:	4885                	li	a7,1
    x = -xx;
    5d50:	bf8d                	j	5cc2 <printint+0x1a>

0000000000005d52 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d52:	7119                	addi	sp,sp,-128
    5d54:	fc86                	sd	ra,120(sp)
    5d56:	f8a2                	sd	s0,112(sp)
    5d58:	f4a6                	sd	s1,104(sp)
    5d5a:	f0ca                	sd	s2,96(sp)
    5d5c:	ecce                	sd	s3,88(sp)
    5d5e:	e8d2                	sd	s4,80(sp)
    5d60:	e4d6                	sd	s5,72(sp)
    5d62:	e0da                	sd	s6,64(sp)
    5d64:	fc5e                	sd	s7,56(sp)
    5d66:	f862                	sd	s8,48(sp)
    5d68:	f466                	sd	s9,40(sp)
    5d6a:	f06a                	sd	s10,32(sp)
    5d6c:	ec6e                	sd	s11,24(sp)
    5d6e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d70:	0005c903          	lbu	s2,0(a1)
    5d74:	18090f63          	beqz	s2,5f12 <vprintf+0x1c0>
    5d78:	8aaa                	mv	s5,a0
    5d7a:	8b32                	mv	s6,a2
    5d7c:	00158493          	addi	s1,a1,1
  state = 0;
    5d80:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d82:	02500a13          	li	s4,37
      if(c == 'd'){
    5d86:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5d8a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5d8e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5d92:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d96:	00002b97          	auipc	s7,0x2
    5d9a:	79ab8b93          	addi	s7,s7,1946 # 8530 <digits>
    5d9e:	a839                	j	5dbc <vprintf+0x6a>
        putc(fd, c);
    5da0:	85ca                	mv	a1,s2
    5da2:	8556                	mv	a0,s5
    5da4:	00000097          	auipc	ra,0x0
    5da8:	ee2080e7          	jalr	-286(ra) # 5c86 <putc>
    5dac:	a019                	j	5db2 <vprintf+0x60>
    } else if(state == '%'){
    5dae:	01498f63          	beq	s3,s4,5dcc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5db2:	0485                	addi	s1,s1,1
    5db4:	fff4c903          	lbu	s2,-1(s1)
    5db8:	14090d63          	beqz	s2,5f12 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5dbc:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5dc0:	fe0997e3          	bnez	s3,5dae <vprintf+0x5c>
      if(c == '%'){
    5dc4:	fd479ee3          	bne	a5,s4,5da0 <vprintf+0x4e>
        state = '%';
    5dc8:	89be                	mv	s3,a5
    5dca:	b7e5                	j	5db2 <vprintf+0x60>
      if(c == 'd'){
    5dcc:	05878063          	beq	a5,s8,5e0c <vprintf+0xba>
      } else if(c == 'l') {
    5dd0:	05978c63          	beq	a5,s9,5e28 <vprintf+0xd6>
      } else if(c == 'x') {
    5dd4:	07a78863          	beq	a5,s10,5e44 <vprintf+0xf2>
      } else if(c == 'p') {
    5dd8:	09b78463          	beq	a5,s11,5e60 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5ddc:	07300713          	li	a4,115
    5de0:	0ce78663          	beq	a5,a4,5eac <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5de4:	06300713          	li	a4,99
    5de8:	0ee78e63          	beq	a5,a4,5ee4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5dec:	11478863          	beq	a5,s4,5efc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5df0:	85d2                	mv	a1,s4
    5df2:	8556                	mv	a0,s5
    5df4:	00000097          	auipc	ra,0x0
    5df8:	e92080e7          	jalr	-366(ra) # 5c86 <putc>
        putc(fd, c);
    5dfc:	85ca                	mv	a1,s2
    5dfe:	8556                	mv	a0,s5
    5e00:	00000097          	auipc	ra,0x0
    5e04:	e86080e7          	jalr	-378(ra) # 5c86 <putc>
      }
      state = 0;
    5e08:	4981                	li	s3,0
    5e0a:	b765                	j	5db2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5e0c:	008b0913          	addi	s2,s6,8
    5e10:	4685                	li	a3,1
    5e12:	4629                	li	a2,10
    5e14:	000b2583          	lw	a1,0(s6)
    5e18:	8556                	mv	a0,s5
    5e1a:	00000097          	auipc	ra,0x0
    5e1e:	e8e080e7          	jalr	-370(ra) # 5ca8 <printint>
    5e22:	8b4a                	mv	s6,s2
      state = 0;
    5e24:	4981                	li	s3,0
    5e26:	b771                	j	5db2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e28:	008b0913          	addi	s2,s6,8
    5e2c:	4681                	li	a3,0
    5e2e:	4629                	li	a2,10
    5e30:	000b2583          	lw	a1,0(s6)
    5e34:	8556                	mv	a0,s5
    5e36:	00000097          	auipc	ra,0x0
    5e3a:	e72080e7          	jalr	-398(ra) # 5ca8 <printint>
    5e3e:	8b4a                	mv	s6,s2
      state = 0;
    5e40:	4981                	li	s3,0
    5e42:	bf85                	j	5db2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e44:	008b0913          	addi	s2,s6,8
    5e48:	4681                	li	a3,0
    5e4a:	4641                	li	a2,16
    5e4c:	000b2583          	lw	a1,0(s6)
    5e50:	8556                	mv	a0,s5
    5e52:	00000097          	auipc	ra,0x0
    5e56:	e56080e7          	jalr	-426(ra) # 5ca8 <printint>
    5e5a:	8b4a                	mv	s6,s2
      state = 0;
    5e5c:	4981                	li	s3,0
    5e5e:	bf91                	j	5db2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e60:	008b0793          	addi	a5,s6,8
    5e64:	f8f43423          	sd	a5,-120(s0)
    5e68:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e6c:	03000593          	li	a1,48
    5e70:	8556                	mv	a0,s5
    5e72:	00000097          	auipc	ra,0x0
    5e76:	e14080e7          	jalr	-492(ra) # 5c86 <putc>
  putc(fd, 'x');
    5e7a:	85ea                	mv	a1,s10
    5e7c:	8556                	mv	a0,s5
    5e7e:	00000097          	auipc	ra,0x0
    5e82:	e08080e7          	jalr	-504(ra) # 5c86 <putc>
    5e86:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e88:	03c9d793          	srli	a5,s3,0x3c
    5e8c:	97de                	add	a5,a5,s7
    5e8e:	0007c583          	lbu	a1,0(a5)
    5e92:	8556                	mv	a0,s5
    5e94:	00000097          	auipc	ra,0x0
    5e98:	df2080e7          	jalr	-526(ra) # 5c86 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e9c:	0992                	slli	s3,s3,0x4
    5e9e:	397d                	addiw	s2,s2,-1
    5ea0:	fe0914e3          	bnez	s2,5e88 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5ea4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5ea8:	4981                	li	s3,0
    5eaa:	b721                	j	5db2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5eac:	008b0993          	addi	s3,s6,8
    5eb0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5eb4:	02090163          	beqz	s2,5ed6 <vprintf+0x184>
        while(*s != 0){
    5eb8:	00094583          	lbu	a1,0(s2)
    5ebc:	c9a1                	beqz	a1,5f0c <vprintf+0x1ba>
          putc(fd, *s);
    5ebe:	8556                	mv	a0,s5
    5ec0:	00000097          	auipc	ra,0x0
    5ec4:	dc6080e7          	jalr	-570(ra) # 5c86 <putc>
          s++;
    5ec8:	0905                	addi	s2,s2,1
        while(*s != 0){
    5eca:	00094583          	lbu	a1,0(s2)
    5ece:	f9e5                	bnez	a1,5ebe <vprintf+0x16c>
        s = va_arg(ap, char*);
    5ed0:	8b4e                	mv	s6,s3
      state = 0;
    5ed2:	4981                	li	s3,0
    5ed4:	bdf9                	j	5db2 <vprintf+0x60>
          s = "(null)";
    5ed6:	00002917          	auipc	s2,0x2
    5eda:	63290913          	addi	s2,s2,1586 # 8508 <malloc+0x24ec>
        while(*s != 0){
    5ede:	02800593          	li	a1,40
    5ee2:	bff1                	j	5ebe <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5ee4:	008b0913          	addi	s2,s6,8
    5ee8:	000b4583          	lbu	a1,0(s6)
    5eec:	8556                	mv	a0,s5
    5eee:	00000097          	auipc	ra,0x0
    5ef2:	d98080e7          	jalr	-616(ra) # 5c86 <putc>
    5ef6:	8b4a                	mv	s6,s2
      state = 0;
    5ef8:	4981                	li	s3,0
    5efa:	bd65                	j	5db2 <vprintf+0x60>
        putc(fd, c);
    5efc:	85d2                	mv	a1,s4
    5efe:	8556                	mv	a0,s5
    5f00:	00000097          	auipc	ra,0x0
    5f04:	d86080e7          	jalr	-634(ra) # 5c86 <putc>
      state = 0;
    5f08:	4981                	li	s3,0
    5f0a:	b565                	j	5db2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5f0c:	8b4e                	mv	s6,s3
      state = 0;
    5f0e:	4981                	li	s3,0
    5f10:	b54d                	j	5db2 <vprintf+0x60>
    }
  }
}
    5f12:	70e6                	ld	ra,120(sp)
    5f14:	7446                	ld	s0,112(sp)
    5f16:	74a6                	ld	s1,104(sp)
    5f18:	7906                	ld	s2,96(sp)
    5f1a:	69e6                	ld	s3,88(sp)
    5f1c:	6a46                	ld	s4,80(sp)
    5f1e:	6aa6                	ld	s5,72(sp)
    5f20:	6b06                	ld	s6,64(sp)
    5f22:	7be2                	ld	s7,56(sp)
    5f24:	7c42                	ld	s8,48(sp)
    5f26:	7ca2                	ld	s9,40(sp)
    5f28:	7d02                	ld	s10,32(sp)
    5f2a:	6de2                	ld	s11,24(sp)
    5f2c:	6109                	addi	sp,sp,128
    5f2e:	8082                	ret

0000000000005f30 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f30:	715d                	addi	sp,sp,-80
    5f32:	ec06                	sd	ra,24(sp)
    5f34:	e822                	sd	s0,16(sp)
    5f36:	1000                	addi	s0,sp,32
    5f38:	e010                	sd	a2,0(s0)
    5f3a:	e414                	sd	a3,8(s0)
    5f3c:	e818                	sd	a4,16(s0)
    5f3e:	ec1c                	sd	a5,24(s0)
    5f40:	03043023          	sd	a6,32(s0)
    5f44:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f48:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f4c:	8622                	mv	a2,s0
    5f4e:	00000097          	auipc	ra,0x0
    5f52:	e04080e7          	jalr	-508(ra) # 5d52 <vprintf>
}
    5f56:	60e2                	ld	ra,24(sp)
    5f58:	6442                	ld	s0,16(sp)
    5f5a:	6161                	addi	sp,sp,80
    5f5c:	8082                	ret

0000000000005f5e <printf>:

void
printf(const char *fmt, ...)
{
    5f5e:	711d                	addi	sp,sp,-96
    5f60:	ec06                	sd	ra,24(sp)
    5f62:	e822                	sd	s0,16(sp)
    5f64:	1000                	addi	s0,sp,32
    5f66:	e40c                	sd	a1,8(s0)
    5f68:	e810                	sd	a2,16(s0)
    5f6a:	ec14                	sd	a3,24(s0)
    5f6c:	f018                	sd	a4,32(s0)
    5f6e:	f41c                	sd	a5,40(s0)
    5f70:	03043823          	sd	a6,48(s0)
    5f74:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f78:	00840613          	addi	a2,s0,8
    5f7c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f80:	85aa                	mv	a1,a0
    5f82:	4505                	li	a0,1
    5f84:	00000097          	auipc	ra,0x0
    5f88:	dce080e7          	jalr	-562(ra) # 5d52 <vprintf>
}
    5f8c:	60e2                	ld	ra,24(sp)
    5f8e:	6442                	ld	s0,16(sp)
    5f90:	6125                	addi	sp,sp,96
    5f92:	8082                	ret

0000000000005f94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f94:	1141                	addi	sp,sp,-16
    5f96:	e422                	sd	s0,8(sp)
    5f98:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f9a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f9e:	00003797          	auipc	a5,0x3
    5fa2:	4627b783          	ld	a5,1122(a5) # 9400 <freep>
    5fa6:	a805                	j	5fd6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fa8:	4618                	lw	a4,8(a2)
    5faa:	9db9                	addw	a1,a1,a4
    5fac:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fb0:	6398                	ld	a4,0(a5)
    5fb2:	6318                	ld	a4,0(a4)
    5fb4:	fee53823          	sd	a4,-16(a0)
    5fb8:	a091                	j	5ffc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fba:	ff852703          	lw	a4,-8(a0)
    5fbe:	9e39                	addw	a2,a2,a4
    5fc0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5fc2:	ff053703          	ld	a4,-16(a0)
    5fc6:	e398                	sd	a4,0(a5)
    5fc8:	a099                	j	600e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fca:	6398                	ld	a4,0(a5)
    5fcc:	00e7e463          	bltu	a5,a4,5fd4 <free+0x40>
    5fd0:	00e6ea63          	bltu	a3,a4,5fe4 <free+0x50>
{
    5fd4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fd6:	fed7fae3          	bgeu	a5,a3,5fca <free+0x36>
    5fda:	6398                	ld	a4,0(a5)
    5fdc:	00e6e463          	bltu	a3,a4,5fe4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fe0:	fee7eae3          	bltu	a5,a4,5fd4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5fe4:	ff852583          	lw	a1,-8(a0)
    5fe8:	6390                	ld	a2,0(a5)
    5fea:	02059713          	slli	a4,a1,0x20
    5fee:	9301                	srli	a4,a4,0x20
    5ff0:	0712                	slli	a4,a4,0x4
    5ff2:	9736                	add	a4,a4,a3
    5ff4:	fae60ae3          	beq	a2,a4,5fa8 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5ff8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5ffc:	4790                	lw	a2,8(a5)
    5ffe:	02061713          	slli	a4,a2,0x20
    6002:	9301                	srli	a4,a4,0x20
    6004:	0712                	slli	a4,a4,0x4
    6006:	973e                	add	a4,a4,a5
    6008:	fae689e3          	beq	a3,a4,5fba <free+0x26>
  } else
    p->s.ptr = bp;
    600c:	e394                	sd	a3,0(a5)
  freep = p;
    600e:	00003717          	auipc	a4,0x3
    6012:	3ef73923          	sd	a5,1010(a4) # 9400 <freep>
}
    6016:	6422                	ld	s0,8(sp)
    6018:	0141                	addi	sp,sp,16
    601a:	8082                	ret

000000000000601c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    601c:	7139                	addi	sp,sp,-64
    601e:	fc06                	sd	ra,56(sp)
    6020:	f822                	sd	s0,48(sp)
    6022:	f426                	sd	s1,40(sp)
    6024:	f04a                	sd	s2,32(sp)
    6026:	ec4e                	sd	s3,24(sp)
    6028:	e852                	sd	s4,16(sp)
    602a:	e456                	sd	s5,8(sp)
    602c:	e05a                	sd	s6,0(sp)
    602e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6030:	02051493          	slli	s1,a0,0x20
    6034:	9081                	srli	s1,s1,0x20
    6036:	04bd                	addi	s1,s1,15
    6038:	8091                	srli	s1,s1,0x4
    603a:	0014899b          	addiw	s3,s1,1
    603e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6040:	00003517          	auipc	a0,0x3
    6044:	3c053503          	ld	a0,960(a0) # 9400 <freep>
    6048:	c515                	beqz	a0,6074 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    604a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    604c:	4798                	lw	a4,8(a5)
    604e:	02977f63          	bgeu	a4,s1,608c <malloc+0x70>
    6052:	8a4e                	mv	s4,s3
    6054:	0009871b          	sext.w	a4,s3
    6058:	6685                	lui	a3,0x1
    605a:	00d77363          	bgeu	a4,a3,6060 <malloc+0x44>
    605e:	6a05                	lui	s4,0x1
    6060:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6064:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6068:	00003917          	auipc	s2,0x3
    606c:	39890913          	addi	s2,s2,920 # 9400 <freep>
  if(p == (char*)-1)
    6070:	5afd                	li	s5,-1
    6072:	a88d                	j	60e4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6074:	0000a797          	auipc	a5,0xa
    6078:	bb478793          	addi	a5,a5,-1100 # fc28 <base>
    607c:	00003717          	auipc	a4,0x3
    6080:	38f73223          	sd	a5,900(a4) # 9400 <freep>
    6084:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6086:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    608a:	b7e1                	j	6052 <malloc+0x36>
      if(p->s.size == nunits)
    608c:	02e48b63          	beq	s1,a4,60c2 <malloc+0xa6>
        p->s.size -= nunits;
    6090:	4137073b          	subw	a4,a4,s3
    6094:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6096:	1702                	slli	a4,a4,0x20
    6098:	9301                	srli	a4,a4,0x20
    609a:	0712                	slli	a4,a4,0x4
    609c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    609e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60a2:	00003717          	auipc	a4,0x3
    60a6:	34a73f23          	sd	a0,862(a4) # 9400 <freep>
      return (void*)(p + 1);
    60aa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    60ae:	70e2                	ld	ra,56(sp)
    60b0:	7442                	ld	s0,48(sp)
    60b2:	74a2                	ld	s1,40(sp)
    60b4:	7902                	ld	s2,32(sp)
    60b6:	69e2                	ld	s3,24(sp)
    60b8:	6a42                	ld	s4,16(sp)
    60ba:	6aa2                	ld	s5,8(sp)
    60bc:	6b02                	ld	s6,0(sp)
    60be:	6121                	addi	sp,sp,64
    60c0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60c2:	6398                	ld	a4,0(a5)
    60c4:	e118                	sd	a4,0(a0)
    60c6:	bff1                	j	60a2 <malloc+0x86>
  hp->s.size = nu;
    60c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60cc:	0541                	addi	a0,a0,16
    60ce:	00000097          	auipc	ra,0x0
    60d2:	ec6080e7          	jalr	-314(ra) # 5f94 <free>
  return freep;
    60d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60da:	d971                	beqz	a0,60ae <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60de:	4798                	lw	a4,8(a5)
    60e0:	fa9776e3          	bgeu	a4,s1,608c <malloc+0x70>
    if(p == freep)
    60e4:	00093703          	ld	a4,0(s2)
    60e8:	853e                	mv	a0,a5
    60ea:	fef719e3          	bne	a4,a5,60dc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    60ee:	8552                	mv	a0,s4
    60f0:	00000097          	auipc	ra,0x0
    60f4:	b5e080e7          	jalr	-1186(ra) # 5c4e <sbrk>
  if(p == (char*)-1)
    60f8:	fd5518e3          	bne	a0,s5,60c8 <malloc+0xac>
        return 0;
    60fc:	4501                	li	a0,0
    60fe:	bf45                	j	60ae <malloc+0x92>
