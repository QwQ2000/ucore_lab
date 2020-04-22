
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 40 fd 10 00       	mov    $0x10fd40,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 9e 2b 00 00       	call   102bca <memset>

    cons_init();                // init the console
  10002c:	e8 42 15 00 00       	call   101573 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 33 10 00 	movl   $0x1033e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 33 10 00 	movl   $0x1033fc,(%esp)
  100046:	e8 11 02 00 00       	call   10025c <cprintf>

    print_kerninfo();
  10004b:	e8 b2 08 00 00       	call   100902 <print_kerninfo>

    grade_backtrace();
  100050:	e8 89 00 00 00       	call   1000de <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 45 28 00 00       	call   10289f <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 53 16 00 00       	call   1016b2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 b3 17 00 00       	call   101817 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 eb 0c 00 00       	call   100d54 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 7e 17 00 00       	call   1017ec <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 b0 0c 00 00       	call   100d42 <mon_backtrace>
}
  100092:	90                   	nop
  100093:	c9                   	leave  
  100094:	c3                   	ret    

00100095 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	53                   	push   %ebx
  100099:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10009f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b4:	89 04 24             	mov    %eax,(%esp)
  1000b7:	e8 b4 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bc:	90                   	nop
  1000bd:	83 c4 14             	add    $0x14,%esp
  1000c0:	5b                   	pop    %ebx
  1000c1:	5d                   	pop    %ebp
  1000c2:	c3                   	ret    

001000c3 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c3:	55                   	push   %ebp
  1000c4:	89 e5                	mov    %esp,%ebp
  1000c6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d3:	89 04 24             	mov    %eax,(%esp)
  1000d6:	e8 ba ff ff ff       	call   100095 <grade_backtrace1>
}
  1000db:	90                   	nop
  1000dc:	c9                   	leave  
  1000dd:	c3                   	ret    

001000de <grade_backtrace>:

void
grade_backtrace(void) {
  1000de:	55                   	push   %ebp
  1000df:	89 e5                	mov    %esp,%ebp
  1000e1:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e4:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e9:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f0:	ff 
  1000f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fc:	e8 c2 ff ff ff       	call   1000c3 <grade_backtrace0>
}
  100101:	90                   	nop
  100102:	c9                   	leave  
  100103:	c3                   	ret    

00100104 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100104:	55                   	push   %ebp
  100105:	89 e5                	mov    %esp,%ebp
  100107:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100110:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100113:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100116:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011a:	83 e0 03             	and    $0x3,%eax
  10011d:	89 c2                	mov    %eax,%edx
  10011f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100124:	89 54 24 08          	mov    %edx,0x8(%esp)
  100128:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012c:	c7 04 24 01 34 10 00 	movl   $0x103401,(%esp)
  100133:	e8 24 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100138:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013c:	89 c2                	mov    %eax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 0f 34 10 00 	movl   $0x10340f,(%esp)
  100152:	e8 05 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	89 c2                	mov    %eax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	89 54 24 08          	mov    %edx,0x8(%esp)
  100166:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016a:	c7 04 24 1d 34 10 00 	movl   $0x10341d,(%esp)
  100171:	e8 e6 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100176:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017a:	89 c2                	mov    %eax,%edx
  10017c:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100181:	89 54 24 08          	mov    %edx,0x8(%esp)
  100185:	89 44 24 04          	mov    %eax,0x4(%esp)
  100189:	c7 04 24 2b 34 10 00 	movl   $0x10342b,(%esp)
  100190:	e8 c7 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100195:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100199:	89 c2                	mov    %eax,%edx
  10019b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a8:	c7 04 24 39 34 10 00 	movl   $0x103439,(%esp)
  1001af:	e8 a8 00 00 00       	call   10025c <cprintf>
    round ++;
  1001b4:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001b9:	40                   	inc    %eax
  1001ba:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001bf:	90                   	nop
  1001c0:	c9                   	leave  
  1001c1:	c3                   	ret    

001001c2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c2:	55                   	push   %ebp
  1001c3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c5:	90                   	nop
  1001c6:	5d                   	pop    %ebp
  1001c7:	c3                   	ret    

001001c8 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001c8:	55                   	push   %ebp
  1001c9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001cb:	90                   	nop
  1001cc:	5d                   	pop    %ebp
  1001cd:	c3                   	ret    

001001ce <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ce:	55                   	push   %ebp
  1001cf:	89 e5                	mov    %esp,%ebp
  1001d1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d4:	e8 2b ff ff ff       	call   100104 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001d9:	c7 04 24 48 34 10 00 	movl   $0x103448,(%esp)
  1001e0:	e8 77 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_user();
  1001e5:	e8 d8 ff ff ff       	call   1001c2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ea:	e8 15 ff ff ff       	call   100104 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ef:	c7 04 24 68 34 10 00 	movl   $0x103468,(%esp)
  1001f6:	e8 61 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_kernel();
  1001fb:	e8 c8 ff ff ff       	call   1001c8 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100200:	e8 ff fe ff ff       	call   100104 <lab1_print_cur_status>
}
  100205:	90                   	nop
  100206:	c9                   	leave  
  100207:	c3                   	ret    

00100208 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100208:	55                   	push   %ebp
  100209:	89 e5                	mov    %esp,%ebp
  10020b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10020e:	8b 45 08             	mov    0x8(%ebp),%eax
  100211:	89 04 24             	mov    %eax,(%esp)
  100214:	e8 87 13 00 00       	call   1015a0 <cons_putc>
    (*cnt) ++;
  100219:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021c:	8b 00                	mov    (%eax),%eax
  10021e:	8d 50 01             	lea    0x1(%eax),%edx
  100221:	8b 45 0c             	mov    0xc(%ebp),%eax
  100224:	89 10                	mov    %edx,(%eax)
}
  100226:	90                   	nop
  100227:	c9                   	leave  
  100228:	c3                   	ret    

00100229 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100229:	55                   	push   %ebp
  10022a:	89 e5                	mov    %esp,%ebp
  10022c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10022f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10023d:	8b 45 08             	mov    0x8(%ebp),%eax
  100240:	89 44 24 08          	mov    %eax,0x8(%esp)
  100244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024b:	c7 04 24 08 02 10 00 	movl   $0x100208,(%esp)
  100252:	e8 c6 2c 00 00       	call   102f1d <vprintfmt>
    return cnt;
  100257:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10025a:	c9                   	leave  
  10025b:	c3                   	ret    

0010025c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10025c:	55                   	push   %ebp
  10025d:	89 e5                	mov    %esp,%ebp
  10025f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100262:	8d 45 0c             	lea    0xc(%ebp),%eax
  100265:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10026f:	8b 45 08             	mov    0x8(%ebp),%eax
  100272:	89 04 24             	mov    %eax,(%esp)
  100275:	e8 af ff ff ff       	call   100229 <vcprintf>
  10027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10027d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100280:	c9                   	leave  
  100281:	c3                   	ret    

00100282 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100282:	55                   	push   %ebp
  100283:	89 e5                	mov    %esp,%ebp
  100285:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100288:	8b 45 08             	mov    0x8(%ebp),%eax
  10028b:	89 04 24             	mov    %eax,(%esp)
  10028e:	e8 0d 13 00 00       	call   1015a0 <cons_putc>
}
  100293:	90                   	nop
  100294:	c9                   	leave  
  100295:	c3                   	ret    

00100296 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100296:	55                   	push   %ebp
  100297:	89 e5                	mov    %esp,%ebp
  100299:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10029c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002a3:	eb 13                	jmp    1002b8 <cputs+0x22>
        cputch(c, &cnt);
  1002a5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002a9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002b0:	89 04 24             	mov    %eax,(%esp)
  1002b3:	e8 50 ff ff ff       	call   100208 <cputch>
    while ((c = *str ++) != '\0') {
  1002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bb:	8d 50 01             	lea    0x1(%eax),%edx
  1002be:	89 55 08             	mov    %edx,0x8(%ebp)
  1002c1:	0f b6 00             	movzbl (%eax),%eax
  1002c4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002c7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002cb:	75 d8                	jne    1002a5 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002d4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002db:	e8 28 ff ff ff       	call   100208 <cputch>
    return cnt;
  1002e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002e3:	c9                   	leave  
  1002e4:	c3                   	ret    

001002e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002e5:	55                   	push   %ebp
  1002e6:	89 e5                	mov    %esp,%ebp
  1002e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002eb:	e8 da 12 00 00       	call   1015ca <cons_getc>
  1002f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002f7:	74 f2                	je     1002eb <getchar+0x6>
        /* do nothing */;
    return c;
  1002f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002fc:	c9                   	leave  
  1002fd:	c3                   	ret    

001002fe <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002fe:	55                   	push   %ebp
  1002ff:	89 e5                	mov    %esp,%ebp
  100301:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100308:	74 13                	je     10031d <readline+0x1f>
        cprintf("%s", prompt);
  10030a:	8b 45 08             	mov    0x8(%ebp),%eax
  10030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100311:	c7 04 24 87 34 10 00 	movl   $0x103487,(%esp)
  100318:	e8 3f ff ff ff       	call   10025c <cprintf>
    }
    int i = 0, c;
  10031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100324:	e8 bc ff ff ff       	call   1002e5 <getchar>
  100329:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10032c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100330:	79 07                	jns    100339 <readline+0x3b>
            return NULL;
  100332:	b8 00 00 00 00       	mov    $0x0,%eax
  100337:	eb 78                	jmp    1003b1 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100339:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10033d:	7e 28                	jle    100367 <readline+0x69>
  10033f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100346:	7f 1f                	jg     100367 <readline+0x69>
            cputchar(c);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 04 24             	mov    %eax,(%esp)
  10034e:	e8 2f ff ff ff       	call   100282 <cputchar>
            buf[i ++] = c;
  100353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100356:	8d 50 01             	lea    0x1(%eax),%edx
  100359:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10035c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10035f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100365:	eb 45                	jmp    1003ac <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100367:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10036b:	75 16                	jne    100383 <readline+0x85>
  10036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100371:	7e 10                	jle    100383 <readline+0x85>
            cputchar(c);
  100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100376:	89 04 24             	mov    %eax,(%esp)
  100379:	e8 04 ff ff ff       	call   100282 <cputchar>
            i --;
  10037e:	ff 4d f4             	decl   -0xc(%ebp)
  100381:	eb 29                	jmp    1003ac <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100383:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100387:	74 06                	je     10038f <readline+0x91>
  100389:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038d:	75 95                	jne    100324 <readline+0x26>
            cputchar(c);
  10038f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100392:	89 04 24             	mov    %eax,(%esp)
  100395:	e8 e8 fe ff ff       	call   100282 <cputchar>
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xb3>
        c = getchar();
  1003ac:	e9 73 ff ff ff       	jmp    100324 <readline+0x26>
        }
    }
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	75 5b                	jne    10041d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003c2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1003dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e0:	c7 04 24 8a 34 10 00 	movl   $0x10348a,(%esp)
  1003e7:	e8 70 fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  1003ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f6:	89 04 24             	mov    %eax,(%esp)
  1003f9:	e8 2b fe ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  1003fe:	c7 04 24 a6 34 10 00 	movl   $0x1034a6,(%esp)
  100405:	e8 52 fe ff ff       	call   10025c <cprintf>
    
    cprintf("stack trackback:\n");
  10040a:	c7 04 24 a8 34 10 00 	movl   $0x1034a8,(%esp)
  100411:	e8 46 fe ff ff       	call   10025c <cprintf>
    print_stackframe();
  100416:	e8 32 06 00 00       	call   100a4d <print_stackframe>
  10041b:	eb 01                	jmp    10041e <__panic+0x6b>
        goto panic_dead;
  10041d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10041e:	e8 d0 13 00 00       	call   1017f3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100423:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10042a:	e8 46 08 00 00       	call   100c75 <kmonitor>
  10042f:	eb f2                	jmp    100423 <__panic+0x70>

00100431 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100431:	55                   	push   %ebp
  100432:	89 e5                	mov    %esp,%ebp
  100434:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100437:	8d 45 14             	lea    0x14(%ebp),%eax
  10043a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100440:	89 44 24 08          	mov    %eax,0x8(%esp)
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	89 44 24 04          	mov    %eax,0x4(%esp)
  10044b:	c7 04 24 ba 34 10 00 	movl   $0x1034ba,(%esp)
  100452:	e8 05 fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  100457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10045a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045e:	8b 45 10             	mov    0x10(%ebp),%eax
  100461:	89 04 24             	mov    %eax,(%esp)
  100464:	e8 c0 fd ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  100469:	c7 04 24 a6 34 10 00 	movl   $0x1034a6,(%esp)
  100470:	e8 e7 fd ff ff       	call   10025c <cprintf>
    va_end(ap);
}
  100475:	90                   	nop
  100476:	c9                   	leave  
  100477:	c3                   	ret    

00100478 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100478:	55                   	push   %ebp
  100479:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10047b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100480:	5d                   	pop    %ebp
  100481:	c3                   	ret    

00100482 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100482:	55                   	push   %ebp
  100483:	89 e5                	mov    %esp,%ebp
  100485:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100488:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048b:	8b 00                	mov    (%eax),%eax
  10048d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100490:	8b 45 10             	mov    0x10(%ebp),%eax
  100493:	8b 00                	mov    (%eax),%eax
  100495:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100498:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10049f:	e9 ca 00 00 00       	jmp    10056e <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004aa:	01 d0                	add    %edx,%eax
  1004ac:	89 c2                	mov    %eax,%edx
  1004ae:	c1 ea 1f             	shr    $0x1f,%edx
  1004b1:	01 d0                	add    %edx,%eax
  1004b3:	d1 f8                	sar    %eax
  1004b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004bb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004be:	eb 03                	jmp    1004c3 <stab_binsearch+0x41>
            m --;
  1004c0:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004c9:	7c 1f                	jl     1004ea <stab_binsearch+0x68>
  1004cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ce:	89 d0                	mov    %edx,%eax
  1004d0:	01 c0                	add    %eax,%eax
  1004d2:	01 d0                	add    %edx,%eax
  1004d4:	c1 e0 02             	shl    $0x2,%eax
  1004d7:	89 c2                	mov    %eax,%edx
  1004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004dc:	01 d0                	add    %edx,%eax
  1004de:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004e2:	0f b6 c0             	movzbl %al,%eax
  1004e5:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004e8:	75 d6                	jne    1004c0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004f0:	7d 09                	jge    1004fb <stab_binsearch+0x79>
            l = true_m + 1;
  1004f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f5:	40                   	inc    %eax
  1004f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004f9:	eb 73                	jmp    10056e <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  1004fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100502:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100505:	89 d0                	mov    %edx,%eax
  100507:	01 c0                	add    %eax,%eax
  100509:	01 d0                	add    %edx,%eax
  10050b:	c1 e0 02             	shl    $0x2,%eax
  10050e:	89 c2                	mov    %eax,%edx
  100510:	8b 45 08             	mov    0x8(%ebp),%eax
  100513:	01 d0                	add    %edx,%eax
  100515:	8b 40 08             	mov    0x8(%eax),%eax
  100518:	39 45 18             	cmp    %eax,0x18(%ebp)
  10051b:	76 11                	jbe    10052e <stab_binsearch+0xac>
            *region_left = m;
  10051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100520:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100523:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100528:	40                   	inc    %eax
  100529:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10052c:	eb 40                	jmp    10056e <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10052e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100531:	89 d0                	mov    %edx,%eax
  100533:	01 c0                	add    %eax,%eax
  100535:	01 d0                	add    %edx,%eax
  100537:	c1 e0 02             	shl    $0x2,%eax
  10053a:	89 c2                	mov    %eax,%edx
  10053c:	8b 45 08             	mov    0x8(%ebp),%eax
  10053f:	01 d0                	add    %edx,%eax
  100541:	8b 40 08             	mov    0x8(%eax),%eax
  100544:	39 45 18             	cmp    %eax,0x18(%ebp)
  100547:	73 14                	jae    10055d <stab_binsearch+0xdb>
            *region_right = m - 1;
  100549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10054f:	8b 45 10             	mov    0x10(%ebp),%eax
  100552:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100557:	48                   	dec    %eax
  100558:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10055b:	eb 11                	jmp    10056e <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100563:	89 10                	mov    %edx,(%eax)
            l = m;
  100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100568:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10056b:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  10056e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100571:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100574:	0f 8e 2a ff ff ff    	jle    1004a4 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10057a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10057e:	75 0f                	jne    10058f <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  100580:	8b 45 0c             	mov    0xc(%ebp),%eax
  100583:	8b 00                	mov    (%eax),%eax
  100585:	8d 50 ff             	lea    -0x1(%eax),%edx
  100588:	8b 45 10             	mov    0x10(%ebp),%eax
  10058b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10058d:	eb 3e                	jmp    1005cd <stab_binsearch+0x14b>
        l = *region_right;
  10058f:	8b 45 10             	mov    0x10(%ebp),%eax
  100592:	8b 00                	mov    (%eax),%eax
  100594:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100597:	eb 03                	jmp    10059c <stab_binsearch+0x11a>
  100599:	ff 4d fc             	decl   -0x4(%ebp)
  10059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10059f:	8b 00                	mov    (%eax),%eax
  1005a1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005a4:	7e 1f                	jle    1005c5 <stab_binsearch+0x143>
  1005a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005a9:	89 d0                	mov    %edx,%eax
  1005ab:	01 c0                	add    %eax,%eax
  1005ad:	01 d0                	add    %edx,%eax
  1005af:	c1 e0 02             	shl    $0x2,%eax
  1005b2:	89 c2                	mov    %eax,%edx
  1005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b7:	01 d0                	add    %edx,%eax
  1005b9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005bd:	0f b6 c0             	movzbl %al,%eax
  1005c0:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005c3:	75 d4                	jne    100599 <stab_binsearch+0x117>
        *region_left = l;
  1005c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005cb:	89 10                	mov    %edx,(%eax)
}
  1005cd:	90                   	nop
  1005ce:	c9                   	leave  
  1005cf:	c3                   	ret    

001005d0 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005d0:	55                   	push   %ebp
  1005d1:	89 e5                	mov    %esp,%ebp
  1005d3:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;
    
    info->eip_file = "<unknown>";
  1005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d9:	c7 00 d8 34 10 00    	movl   $0x1034d8,(%eax)
    info->eip_line = 0;
  1005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	c7 40 08 d8 34 10 00 	movl   $0x1034d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f6:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100600:	8b 55 08             	mov    0x8(%ebp),%edx
  100603:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100606:	8b 45 0c             	mov    0xc(%ebp),%eax
  100609:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100610:	c7 45 f4 ec 3c 10 00 	movl   $0x103cec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100617:	c7 45 f0 e4 b9 10 00 	movl   $0x10b9e4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10061e:	c7 45 ec e5 b9 10 00 	movl   $0x10b9e5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100625:	c7 45 e8 c5 da 10 00 	movl   $0x10dac5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10062c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10062f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100632:	76 0b                	jbe    10063f <debuginfo_eip+0x6f>
  100634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100637:	48                   	dec    %eax
  100638:	0f b6 00             	movzbl (%eax),%eax
  10063b:	84 c0                	test   %al,%al
  10063d:	74 0a                	je     100649 <debuginfo_eip+0x79>
        return -1;
  10063f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100644:	e9 b7 02 00 00       	jmp    100900 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100649:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100650:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100656:	29 c2                	sub    %eax,%edx
  100658:	89 d0                	mov    %edx,%eax
  10065a:	c1 f8 02             	sar    $0x2,%eax
  10065d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100663:	48                   	dec    %eax
  100664:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100667:	8b 45 08             	mov    0x8(%ebp),%eax
  10066a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10066e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100675:	00 
  100676:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100679:	89 44 24 08          	mov    %eax,0x8(%esp)
  10067d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100680:	89 44 24 04          	mov    %eax,0x4(%esp)
  100684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100687:	89 04 24             	mov    %eax,(%esp)
  10068a:	e8 f3 fd ff ff       	call   100482 <stab_binsearch>
    if (lfile == 0)
  10068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100692:	85 c0                	test   %eax,%eax
  100694:	75 0a                	jne    1006a0 <debuginfo_eip+0xd0>
        return -1;
  100696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10069b:	e9 60 02 00 00       	jmp    100900 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1006af:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006b3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006ba:	00 
  1006bb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006be:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006c2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006cc:	89 04 24             	mov    %eax,(%esp)
  1006cf:	e8 ae fd ff ff       	call   100482 <stab_binsearch>

    if (lfun <= rfun) {
  1006d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006da:	39 c2                	cmp    %eax,%edx
  1006dc:	7f 7c                	jg     10075a <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e1:	89 c2                	mov    %eax,%edx
  1006e3:	89 d0                	mov    %edx,%eax
  1006e5:	01 c0                	add    %eax,%eax
  1006e7:	01 d0                	add    %edx,%eax
  1006e9:	c1 e0 02             	shl    $0x2,%eax
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f1:	01 d0                	add    %edx,%eax
  1006f3:	8b 00                	mov    (%eax),%eax
  1006f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006fb:	29 d1                	sub    %edx,%ecx
  1006fd:	89 ca                	mov    %ecx,%edx
  1006ff:	39 d0                	cmp    %edx,%eax
  100701:	73 22                	jae    100725 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100703:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	89 d0                	mov    %edx,%eax
  10070a:	01 c0                	add    %eax,%eax
  10070c:	01 d0                	add    %edx,%eax
  10070e:	c1 e0 02             	shl    $0x2,%eax
  100711:	89 c2                	mov    %eax,%edx
  100713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100716:	01 d0                	add    %edx,%eax
  100718:	8b 10                	mov    (%eax),%edx
  10071a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10071d:	01 c2                	add    %eax,%edx
  10071f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100722:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100725:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100728:	89 c2                	mov    %eax,%edx
  10072a:	89 d0                	mov    %edx,%eax
  10072c:	01 c0                	add    %eax,%eax
  10072e:	01 d0                	add    %edx,%eax
  100730:	c1 e0 02             	shl    $0x2,%eax
  100733:	89 c2                	mov    %eax,%edx
  100735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100738:	01 d0                	add    %edx,%eax
  10073a:	8b 50 08             	mov    0x8(%eax),%edx
  10073d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100740:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100743:	8b 45 0c             	mov    0xc(%ebp),%eax
  100746:	8b 40 10             	mov    0x10(%eax),%eax
  100749:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10074c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100752:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100755:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100758:	eb 15                	jmp    10076f <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	8b 55 08             	mov    0x8(%ebp),%edx
  100760:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100766:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10076c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100772:	8b 40 08             	mov    0x8(%eax),%eax
  100775:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10077c:	00 
  10077d:	89 04 24             	mov    %eax,(%esp)
  100780:	e8 c1 22 00 00       	call   102a46 <strfind>
  100785:	89 c2                	mov    %eax,%edx
  100787:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078a:	8b 40 08             	mov    0x8(%eax),%eax
  10078d:	29 c2                	sub    %eax,%edx
  10078f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100792:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100795:	8b 45 08             	mov    0x8(%ebp),%eax
  100798:	89 44 24 10          	mov    %eax,0x10(%esp)
  10079c:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007a3:	00 
  1007a4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007ab:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b5:	89 04 24             	mov    %eax,(%esp)
  1007b8:	e8 c5 fc ff ff       	call   100482 <stab_binsearch>
    if (lline <= rline) {
  1007bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007c3:	39 c2                	cmp    %eax,%edx
  1007c5:	7f 23                	jg     1007ea <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ca:	89 c2                	mov    %eax,%edx
  1007cc:	89 d0                	mov    %edx,%eax
  1007ce:	01 c0                	add    %eax,%eax
  1007d0:	01 d0                	add    %edx,%eax
  1007d2:	c1 e0 02             	shl    $0x2,%eax
  1007d5:	89 c2                	mov    %eax,%edx
  1007d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007da:	01 d0                	add    %edx,%eax
  1007dc:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007e0:	89 c2                	mov    %eax,%edx
  1007e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e8:	eb 11                	jmp    1007fb <debuginfo_eip+0x22b>
        return -1;
  1007ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ef:	e9 0c 01 00 00       	jmp    100900 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	48                   	dec    %eax
  1007f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7c 56                	jl     10085b <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  100805:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100808:	89 c2                	mov    %eax,%edx
  10080a:	89 d0                	mov    %edx,%eax
  10080c:	01 c0                	add    %eax,%eax
  10080e:	01 d0                	add    %edx,%eax
  100810:	c1 e0 02             	shl    $0x2,%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100818:	01 d0                	add    %edx,%eax
  10081a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10081e:	3c 84                	cmp    $0x84,%al
  100820:	74 39                	je     10085b <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c 64                	cmp    $0x64,%al
  10083d:	75 b5                	jne    1007f4 <debuginfo_eip+0x224>
  10083f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100842:	89 c2                	mov    %eax,%edx
  100844:	89 d0                	mov    %edx,%eax
  100846:	01 c0                	add    %eax,%eax
  100848:	01 d0                	add    %edx,%eax
  10084a:	c1 e0 02             	shl    $0x2,%eax
  10084d:	89 c2                	mov    %eax,%edx
  10084f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100852:	01 d0                	add    %edx,%eax
  100854:	8b 40 08             	mov    0x8(%eax),%eax
  100857:	85 c0                	test   %eax,%eax
  100859:	74 99                	je     1007f4 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10085b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10085e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100861:	39 c2                	cmp    %eax,%edx
  100863:	7c 46                	jl     1008ab <debuginfo_eip+0x2db>
  100865:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100868:	89 c2                	mov    %eax,%edx
  10086a:	89 d0                	mov    %edx,%eax
  10086c:	01 c0                	add    %eax,%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	c1 e0 02             	shl    $0x2,%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100878:	01 d0                	add    %edx,%eax
  10087a:	8b 00                	mov    (%eax),%eax
  10087c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10087f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100882:	29 d1                	sub    %edx,%ecx
  100884:	89 ca                	mov    %ecx,%edx
  100886:	39 d0                	cmp    %edx,%eax
  100888:	73 21                	jae    1008ab <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10088a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088d:	89 c2                	mov    %eax,%edx
  10088f:	89 d0                	mov    %edx,%eax
  100891:	01 c0                	add    %eax,%eax
  100893:	01 d0                	add    %edx,%eax
  100895:	c1 e0 02             	shl    $0x2,%eax
  100898:	89 c2                	mov    %eax,%edx
  10089a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089d:	01 d0                	add    %edx,%eax
  10089f:	8b 10                	mov    (%eax),%edx
  1008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008a4:	01 c2                	add    %eax,%edx
  1008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008b1:	39 c2                	cmp    %eax,%edx
  1008b3:	7d 46                	jge    1008fb <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008b8:	40                   	inc    %eax
  1008b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008bc:	eb 16                	jmp    1008d4 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c1:	8b 40 14             	mov    0x14(%eax),%eax
  1008c4:	8d 50 01             	lea    0x1(%eax),%edx
  1008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ca:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	40                   	inc    %eax
  1008d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008da:	39 c2                	cmp    %eax,%edx
  1008dc:	7d 1d                	jge    1008fb <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e1:	89 c2                	mov    %eax,%edx
  1008e3:	89 d0                	mov    %edx,%eax
  1008e5:	01 c0                	add    %eax,%eax
  1008e7:	01 d0                	add    %edx,%eax
  1008e9:	c1 e0 02             	shl    $0x2,%eax
  1008ec:	89 c2                	mov    %eax,%edx
  1008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f1:	01 d0                	add    %edx,%eax
  1008f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008f7:	3c a0                	cmp    $0xa0,%al
  1008f9:	74 c3                	je     1008be <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  1008fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100900:	c9                   	leave  
  100901:	c3                   	ret    

00100902 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100902:	55                   	push   %ebp
  100903:	89 e5                	mov    %esp,%ebp
  100905:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100908:	c7 04 24 e2 34 10 00 	movl   $0x1034e2,(%esp)
  10090f:	e8 48 f9 ff ff       	call   10025c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100914:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10091b:	00 
  10091c:	c7 04 24 fb 34 10 00 	movl   $0x1034fb,(%esp)
  100923:	e8 34 f9 ff ff       	call   10025c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100928:	c7 44 24 04 c4 33 10 	movl   $0x1033c4,0x4(%esp)
  10092f:	00 
  100930:	c7 04 24 13 35 10 00 	movl   $0x103513,(%esp)
  100937:	e8 20 f9 ff ff       	call   10025c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10093c:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100943:	00 
  100944:	c7 04 24 2b 35 10 00 	movl   $0x10352b,(%esp)
  10094b:	e8 0c f9 ff ff       	call   10025c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100950:	c7 44 24 04 40 fd 10 	movl   $0x10fd40,0x4(%esp)
  100957:	00 
  100958:	c7 04 24 43 35 10 00 	movl   $0x103543,(%esp)
  10095f:	e8 f8 f8 ff ff       	call   10025c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100964:	b8 40 fd 10 00       	mov    $0x10fd40,%eax
  100969:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10096f:	b8 00 00 10 00       	mov    $0x100000,%eax
  100974:	29 c2                	sub    %eax,%edx
  100976:	89 d0                	mov    %edx,%eax
  100978:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097e:	85 c0                	test   %eax,%eax
  100980:	0f 48 c2             	cmovs  %edx,%eax
  100983:	c1 f8 0a             	sar    $0xa,%eax
  100986:	89 44 24 04          	mov    %eax,0x4(%esp)
  10098a:	c7 04 24 5c 35 10 00 	movl   $0x10355c,(%esp)
  100991:	e8 c6 f8 ff ff       	call   10025c <cprintf>
}
  100996:	90                   	nop
  100997:	c9                   	leave  
  100998:	c3                   	ret    

00100999 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100999:	55                   	push   %ebp
  10099a:	89 e5                	mov    %esp,%ebp
  10099c:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ac:	89 04 24             	mov    %eax,(%esp)
  1009af:	e8 1c fc ff ff       	call   1005d0 <debuginfo_eip>
  1009b4:	85 c0                	test   %eax,%eax
  1009b6:	74 15                	je     1009cd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009bf:	c7 04 24 86 35 10 00 	movl   $0x103586,(%esp)
  1009c6:	e8 91 f8 ff ff       	call   10025c <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009cb:	eb 6c                	jmp    100a39 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009d4:	eb 1b                	jmp    1009f1 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009dc:	01 d0                	add    %edx,%eax
  1009de:	0f b6 00             	movzbl (%eax),%eax
  1009e1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009ea:	01 ca                	add    %ecx,%edx
  1009ec:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009ee:	ff 45 f4             	incl   -0xc(%ebp)
  1009f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009f7:	7c dd                	jl     1009d6 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1009f9:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a02:	01 d0                	add    %edx,%eax
  100a04:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a0d:	89 d1                	mov    %edx,%ecx
  100a0f:	29 c1                	sub    %eax,%ecx
  100a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a17:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a1b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a21:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a25:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2d:	c7 04 24 a2 35 10 00 	movl   $0x1035a2,(%esp)
  100a34:	e8 23 f8 ff ff       	call   10025c <cprintf>
}
  100a39:	90                   	nop
  100a3a:	c9                   	leave  
  100a3b:	c3                   	ret    

00100a3c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a3c:	55                   	push   %ebp
  100a3d:	89 e5                	mov    %esp,%ebp
  100a3f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a42:	8b 45 04             	mov    0x4(%ebp),%eax
  100a45:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a4b:	c9                   	leave  
  100a4c:	c3                   	ret    

00100a4d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a4d:	55                   	push   %ebp
  100a4e:	89 e5                	mov    %esp,%ebp
  100a50:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a53:	89 e8                	mov    %ebp,%eax
  100a55:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
    uint32_t ebp=read_ebp(),eip=read_eip();
  100a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a5e:	e8 d9 ff ff ff       	call   100a3c <read_eip>
  100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (int i=0;ebp && i<STACKFRAME_DEPTH;++i) {
  100a66:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a6d:	e9 84 00 00 00       	jmp    100af6 <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  100a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a80:	c7 04 24 b4 35 10 00 	movl   $0x1035b4,(%esp)
  100a87:	e8 d0 f7 ff ff       	call   10025c <cprintf>
        uint32_t* args=ebp+8;
  100a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8f:	83 c0 08             	add    $0x8,%eax
  100a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (int j=0;j<4;++j)
  100a95:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a9c:	eb 24                	jmp    100ac2 <print_stackframe+0x75>
            cprintf("0x%08x ",args[j]);
  100a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aa1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100aab:	01 d0                	add    %edx,%eax
  100aad:	8b 00                	mov    (%eax),%eax
  100aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab3:	c7 04 24 d0 35 10 00 	movl   $0x1035d0,(%esp)
  100aba:	e8 9d f7 ff ff       	call   10025c <cprintf>
        for (int j=0;j<4;++j)
  100abf:	ff 45 e8             	incl   -0x18(%ebp)
  100ac2:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ac6:	7e d6                	jle    100a9e <print_stackframe+0x51>
        cprintf("\n");
  100ac8:	c7 04 24 d8 35 10 00 	movl   $0x1035d8,(%esp)
  100acf:	e8 88 f7 ff ff       	call   10025c <cprintf>
        print_debuginfo(eip-1);
  100ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad7:	48                   	dec    %eax
  100ad8:	89 04 24             	mov    %eax,(%esp)
  100adb:	e8 b9 fe ff ff       	call   100999 <print_debuginfo>
        eip=*(uint32_t*)(ebp+4);
  100ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae3:	83 c0 04             	add    $0x4,%eax
  100ae6:	8b 00                	mov    (%eax),%eax
  100ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp=*(uint32_t*)(ebp);
  100aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aee:	8b 00                	mov    (%eax),%eax
  100af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i=0;ebp && i<STACKFRAME_DEPTH;++i) {
  100af3:	ff 45 ec             	incl   -0x14(%ebp)
  100af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100afa:	74 0a                	je     100b06 <print_stackframe+0xb9>
  100afc:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b00:	0f 8e 6c ff ff ff    	jle    100a72 <print_stackframe+0x25>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100b06:	90                   	nop
  100b07:	c9                   	leave  
  100b08:	c3                   	ret    

00100b09 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b09:	55                   	push   %ebp
  100b0a:	89 e5                	mov    %esp,%ebp
  100b0c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b16:	eb 0c                	jmp    100b24 <parse+0x1b>
            *buf ++ = '\0';
  100b18:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1b:	8d 50 01             	lea    0x1(%eax),%edx
  100b1e:	89 55 08             	mov    %edx,0x8(%ebp)
  100b21:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b24:	8b 45 08             	mov    0x8(%ebp),%eax
  100b27:	0f b6 00             	movzbl (%eax),%eax
  100b2a:	84 c0                	test   %al,%al
  100b2c:	74 1d                	je     100b4b <parse+0x42>
  100b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b31:	0f b6 00             	movzbl (%eax),%eax
  100b34:	0f be c0             	movsbl %al,%eax
  100b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3b:	c7 04 24 5c 36 10 00 	movl   $0x10365c,(%esp)
  100b42:	e8 cd 1e 00 00       	call   102a14 <strchr>
  100b47:	85 c0                	test   %eax,%eax
  100b49:	75 cd                	jne    100b18 <parse+0xf>
        }
        if (*buf == '\0') {
  100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4e:	0f b6 00             	movzbl (%eax),%eax
  100b51:	84 c0                	test   %al,%al
  100b53:	74 65                	je     100bba <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b55:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b59:	75 14                	jne    100b6f <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b5b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b62:	00 
  100b63:	c7 04 24 61 36 10 00 	movl   $0x103661,(%esp)
  100b6a:	e8 ed f6 ff ff       	call   10025c <cprintf>
        }
        argv[argc ++] = buf;
  100b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b72:	8d 50 01             	lea    0x1(%eax),%edx
  100b75:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b82:	01 c2                	add    %eax,%edx
  100b84:	8b 45 08             	mov    0x8(%ebp),%eax
  100b87:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b89:	eb 03                	jmp    100b8e <parse+0x85>
            buf ++;
  100b8b:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b91:	0f b6 00             	movzbl (%eax),%eax
  100b94:	84 c0                	test   %al,%al
  100b96:	74 8c                	je     100b24 <parse+0x1b>
  100b98:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9b:	0f b6 00             	movzbl (%eax),%eax
  100b9e:	0f be c0             	movsbl %al,%eax
  100ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba5:	c7 04 24 5c 36 10 00 	movl   $0x10365c,(%esp)
  100bac:	e8 63 1e 00 00       	call   102a14 <strchr>
  100bb1:	85 c0                	test   %eax,%eax
  100bb3:	74 d6                	je     100b8b <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bb5:	e9 6a ff ff ff       	jmp    100b24 <parse+0x1b>
            break;
  100bba:	90                   	nop
        }
    }
    return argc;
  100bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bbe:	c9                   	leave  
  100bbf:	c3                   	ret    

00100bc0 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bc0:	55                   	push   %ebp
  100bc1:	89 e5                	mov    %esp,%ebp
  100bc3:	53                   	push   %ebx
  100bc4:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bc7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bce:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd1:	89 04 24             	mov    %eax,(%esp)
  100bd4:	e8 30 ff ff ff       	call   100b09 <parse>
  100bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100be0:	75 0a                	jne    100bec <runcmd+0x2c>
        return 0;
  100be2:	b8 00 00 00 00       	mov    $0x0,%eax
  100be7:	e9 83 00 00 00       	jmp    100c6f <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bf3:	eb 5a                	jmp    100c4f <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bf5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bfb:	89 d0                	mov    %edx,%eax
  100bfd:	01 c0                	add    %eax,%eax
  100bff:	01 d0                	add    %edx,%eax
  100c01:	c1 e0 02             	shl    $0x2,%eax
  100c04:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c09:	8b 00                	mov    (%eax),%eax
  100c0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c0f:	89 04 24             	mov    %eax,(%esp)
  100c12:	e8 60 1d 00 00       	call   102977 <strcmp>
  100c17:	85 c0                	test   %eax,%eax
  100c19:	75 31                	jne    100c4c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c1e:	89 d0                	mov    %edx,%eax
  100c20:	01 c0                	add    %eax,%eax
  100c22:	01 d0                	add    %edx,%eax
  100c24:	c1 e0 02             	shl    $0x2,%eax
  100c27:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c2c:	8b 10                	mov    (%eax),%edx
  100c2e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c31:	83 c0 04             	add    $0x4,%eax
  100c34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c37:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c45:	89 1c 24             	mov    %ebx,(%esp)
  100c48:	ff d2                	call   *%edx
  100c4a:	eb 23                	jmp    100c6f <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4c:	ff 45 f4             	incl   -0xc(%ebp)
  100c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c52:	83 f8 02             	cmp    $0x2,%eax
  100c55:	76 9e                	jbe    100bf5 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c57:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5e:	c7 04 24 7f 36 10 00 	movl   $0x10367f,(%esp)
  100c65:	e8 f2 f5 ff ff       	call   10025c <cprintf>
    return 0;
  100c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c6f:	83 c4 64             	add    $0x64,%esp
  100c72:	5b                   	pop    %ebx
  100c73:	5d                   	pop    %ebp
  100c74:	c3                   	ret    

00100c75 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c75:	55                   	push   %ebp
  100c76:	89 e5                	mov    %esp,%ebp
  100c78:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c7b:	c7 04 24 98 36 10 00 	movl   $0x103698,(%esp)
  100c82:	e8 d5 f5 ff ff       	call   10025c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c87:	c7 04 24 c0 36 10 00 	movl   $0x1036c0,(%esp)
  100c8e:	e8 c9 f5 ff ff       	call   10025c <cprintf>

    if (tf != NULL) {
  100c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c97:	74 0b                	je     100ca4 <kmonitor+0x2f>
        print_trapframe(tf);
  100c99:	8b 45 08             	mov    0x8(%ebp),%eax
  100c9c:	89 04 24             	mov    %eax,(%esp)
  100c9f:	e8 ac 0c 00 00       	call   101950 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ca4:	c7 04 24 e5 36 10 00 	movl   $0x1036e5,(%esp)
  100cab:	e8 4e f6 ff ff       	call   1002fe <readline>
  100cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cb7:	74 eb                	je     100ca4 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc3:	89 04 24             	mov    %eax,(%esp)
  100cc6:	e8 f5 fe ff ff       	call   100bc0 <runcmd>
  100ccb:	85 c0                	test   %eax,%eax
  100ccd:	78 02                	js     100cd1 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100ccf:	eb d3                	jmp    100ca4 <kmonitor+0x2f>
                break;
  100cd1:	90                   	nop
            }
        }
    }
}
  100cd2:	90                   	nop
  100cd3:	c9                   	leave  
  100cd4:	c3                   	ret    

00100cd5 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cd5:	55                   	push   %ebp
  100cd6:	89 e5                	mov    %esp,%ebp
  100cd8:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ce2:	eb 3d                	jmp    100d21 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce7:	89 d0                	mov    %edx,%eax
  100ce9:	01 c0                	add    %eax,%eax
  100ceb:	01 d0                	add    %edx,%eax
  100ced:	c1 e0 02             	shl    $0x2,%eax
  100cf0:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cf5:	8b 08                	mov    (%eax),%ecx
  100cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfa:	89 d0                	mov    %edx,%eax
  100cfc:	01 c0                	add    %eax,%eax
  100cfe:	01 d0                	add    %edx,%eax
  100d00:	c1 e0 02             	shl    $0x2,%eax
  100d03:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d08:	8b 00                	mov    (%eax),%eax
  100d0a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d12:	c7 04 24 e9 36 10 00 	movl   $0x1036e9,(%esp)
  100d19:	e8 3e f5 ff ff       	call   10025c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d1e:	ff 45 f4             	incl   -0xc(%ebp)
  100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d24:	83 f8 02             	cmp    $0x2,%eax
  100d27:	76 bb                	jbe    100ce4 <mon_help+0xf>
    }
    return 0;
  100d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2e:	c9                   	leave  
  100d2f:	c3                   	ret    

00100d30 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d30:	55                   	push   %ebp
  100d31:	89 e5                	mov    %esp,%ebp
  100d33:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d36:	e8 c7 fb ff ff       	call   100902 <print_kerninfo>
    return 0;
  100d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d40:	c9                   	leave  
  100d41:	c3                   	ret    

00100d42 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d42:	55                   	push   %ebp
  100d43:	89 e5                	mov    %esp,%ebp
  100d45:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d48:	e8 00 fd ff ff       	call   100a4d <print_stackframe>
    return 0;
  100d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d52:	c9                   	leave  
  100d53:	c3                   	ret    

00100d54 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d54:	55                   	push   %ebp
  100d55:	89 e5                	mov    %esp,%ebp
  100d57:	83 ec 28             	sub    $0x28,%esp
  100d5a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d60:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d64:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d68:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d6c:	ee                   	out    %al,(%dx)
  100d6d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d73:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d77:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d7f:	ee                   	out    %al,(%dx)
  100d80:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d86:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d8a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d8e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d92:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d93:	c7 05 28 f9 10 00 00 	movl   $0x0,0x10f928
  100d9a:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9d:	c7 04 24 f2 36 10 00 	movl   $0x1036f2,(%esp)
  100da4:	e8 b3 f4 ff ff       	call   10025c <cprintf>
    pic_enable(IRQ_TIMER);
  100da9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100db0:	e8 ca 08 00 00       	call   10167f <pic_enable>
}
  100db5:	90                   	nop
  100db6:	c9                   	leave  
  100db7:	c3                   	ret    

00100db8 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100db8:	55                   	push   %ebp
  100db9:	89 e5                	mov    %esp,%ebp
  100dbb:	83 ec 10             	sub    $0x10,%esp
  100dbe:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dc8:	89 c2                	mov    %eax,%edx
  100dca:	ec                   	in     (%dx),%al
  100dcb:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dce:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dd4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dd8:	89 c2                	mov    %eax,%edx
  100dda:	ec                   	in     (%dx),%al
  100ddb:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dde:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100de8:	89 c2                	mov    %eax,%edx
  100dea:	ec                   	in     (%dx),%al
  100deb:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dee:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100df4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100df8:	89 c2                	mov    %eax,%edx
  100dfa:	ec                   	in     (%dx),%al
  100dfb:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dfe:	90                   	nop
  100dff:	c9                   	leave  
  100e00:	c3                   	ret    

00100e01 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e01:	55                   	push   %ebp
  100e02:	89 e5                	mov    %esp,%ebp
  100e04:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e07:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	0f b7 00             	movzwl (%eax),%eax
  100e14:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e23:	0f b7 00             	movzwl (%eax),%eax
  100e26:	0f b7 c0             	movzwl %ax,%eax
  100e29:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e2e:	74 12                	je     100e42 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e30:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e37:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3e:	b4 03 
  100e40:	eb 13                	jmp    100e55 <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e45:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e49:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e4c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e53:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e55:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e60:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e64:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e68:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e6c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e6d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e74:	40                   	inc    %eax
  100e75:	0f b7 c0             	movzwl %ax,%eax
  100e78:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e80:	89 c2                	mov    %eax,%edx
  100e82:	ec                   	in     (%dx),%al
  100e83:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e86:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e8a:	0f b6 c0             	movzbl %al,%eax
  100e8d:	c1 e0 08             	shl    $0x8,%eax
  100e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e93:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e9e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ea6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eaa:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eab:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb2:	40                   	inc    %eax
  100eb3:	0f b7 c0             	movzwl %ax,%eax
  100eb6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eba:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ebe:	89 c2                	mov    %eax,%edx
  100ec0:	ec                   	in     (%dx),%al
  100ec1:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100ec4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ec8:	0f b6 c0             	movzbl %al,%eax
  100ecb:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed1:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed9:	0f b7 c0             	movzwl %ax,%eax
  100edc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee2:	90                   	nop
  100ee3:	c9                   	leave  
  100ee4:	c3                   	ret    

00100ee5 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee5:	55                   	push   %ebp
  100ee6:	89 e5                	mov    %esp,%ebp
  100ee8:	83 ec 48             	sub    $0x48,%esp
  100eeb:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ef1:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ef9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100efd:	ee                   	out    %al,(%dx)
  100efe:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f04:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f08:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f0c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f10:	ee                   	out    %al,(%dx)
  100f11:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f17:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f1b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f1f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f23:	ee                   	out    %al,(%dx)
  100f24:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f2a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f2e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f32:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f36:	ee                   	out    %al,(%dx)
  100f37:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f3d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f41:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f45:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f49:	ee                   	out    %al,(%dx)
  100f4a:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f50:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f54:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f58:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5c:	ee                   	out    %al,(%dx)
  100f5d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f63:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f67:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f6b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f6f:	ee                   	out    %al,(%dx)
  100f70:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f76:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f7a:	89 c2                	mov    %eax,%edx
  100f7c:	ec                   	in     (%dx),%al
  100f7d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f84:	3c ff                	cmp    $0xff,%al
  100f86:	0f 95 c0             	setne  %al
  100f89:	0f b6 c0             	movzbl %al,%eax
  100f8c:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f91:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f97:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f9b:	89 c2                	mov    %eax,%edx
  100f9d:	ec                   	in     (%dx),%al
  100f9e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fa1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fa7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fab:	89 c2                	mov    %eax,%edx
  100fad:	ec                   	in     (%dx),%al
  100fae:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb1:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fb6:	85 c0                	test   %eax,%eax
  100fb8:	74 0c                	je     100fc6 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fba:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fc1:	e8 b9 06 00 00       	call   10167f <pic_enable>
    }
}
  100fc6:	90                   	nop
  100fc7:	c9                   	leave  
  100fc8:	c3                   	ret    

00100fc9 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc9:	55                   	push   %ebp
  100fca:	89 e5                	mov    %esp,%ebp
  100fcc:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd6:	eb 08                	jmp    100fe0 <lpt_putc_sub+0x17>
        delay();
  100fd8:	e8 db fd ff ff       	call   100db8 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fdd:	ff 45 fc             	incl   -0x4(%ebp)
  100fe0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fe6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff4:	84 c0                	test   %al,%al
  100ff6:	78 09                	js     101001 <lpt_putc_sub+0x38>
  100ff8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fff:	7e d7                	jle    100fd8 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101001:	8b 45 08             	mov    0x8(%ebp),%eax
  101004:	0f b6 c0             	movzbl %al,%eax
  101007:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10100d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101010:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101014:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101018:	ee                   	out    %al,(%dx)
  101019:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10101f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101023:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101027:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10102b:	ee                   	out    %al,(%dx)
  10102c:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101032:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101036:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10103a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10103e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10103f:	90                   	nop
  101040:	c9                   	leave  
  101041:	c3                   	ret    

00101042 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101042:	55                   	push   %ebp
  101043:	89 e5                	mov    %esp,%ebp
  101045:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101048:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104c:	74 0d                	je     10105b <lpt_putc+0x19>
        lpt_putc_sub(c);
  10104e:	8b 45 08             	mov    0x8(%ebp),%eax
  101051:	89 04 24             	mov    %eax,(%esp)
  101054:	e8 70 ff ff ff       	call   100fc9 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101059:	eb 24                	jmp    10107f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10105b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101062:	e8 62 ff ff ff       	call   100fc9 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101067:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10106e:	e8 56 ff ff ff       	call   100fc9 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101073:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107a:	e8 4a ff ff ff       	call   100fc9 <lpt_putc_sub>
}
  10107f:	90                   	nop
  101080:	c9                   	leave  
  101081:	c3                   	ret    

00101082 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101082:	55                   	push   %ebp
  101083:	89 e5                	mov    %esp,%ebp
  101085:	53                   	push   %ebx
  101086:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101089:	8b 45 08             	mov    0x8(%ebp),%eax
  10108c:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101091:	85 c0                	test   %eax,%eax
  101093:	75 07                	jne    10109c <cga_putc+0x1a>
        c |= 0x0700;
  101095:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10109c:	8b 45 08             	mov    0x8(%ebp),%eax
  10109f:	0f b6 c0             	movzbl %al,%eax
  1010a2:	83 f8 0a             	cmp    $0xa,%eax
  1010a5:	74 55                	je     1010fc <cga_putc+0x7a>
  1010a7:	83 f8 0d             	cmp    $0xd,%eax
  1010aa:	74 63                	je     10110f <cga_putc+0x8d>
  1010ac:	83 f8 08             	cmp    $0x8,%eax
  1010af:	0f 85 94 00 00 00    	jne    101149 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  1010b5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010bc:	85 c0                	test   %eax,%eax
  1010be:	0f 84 af 00 00 00    	je     101173 <cga_putc+0xf1>
            crt_pos --;
  1010c4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cb:	48                   	dec    %eax
  1010cc:	0f b7 c0             	movzwl %ax,%eax
  1010cf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d8:	98                   	cwtl   
  1010d9:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010de:	98                   	cwtl   
  1010df:	83 c8 20             	or     $0x20,%eax
  1010e2:	98                   	cwtl   
  1010e3:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  1010e9:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010f0:	01 c9                	add    %ecx,%ecx
  1010f2:	01 ca                	add    %ecx,%edx
  1010f4:	0f b7 c0             	movzwl %ax,%eax
  1010f7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010fa:	eb 77                	jmp    101173 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  1010fc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101103:	83 c0 50             	add    $0x50,%eax
  101106:	0f b7 c0             	movzwl %ax,%eax
  101109:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10110f:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101116:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10111d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101122:	89 c8                	mov    %ecx,%eax
  101124:	f7 e2                	mul    %edx
  101126:	c1 ea 06             	shr    $0x6,%edx
  101129:	89 d0                	mov    %edx,%eax
  10112b:	c1 e0 02             	shl    $0x2,%eax
  10112e:	01 d0                	add    %edx,%eax
  101130:	c1 e0 04             	shl    $0x4,%eax
  101133:	29 c1                	sub    %eax,%ecx
  101135:	89 c8                	mov    %ecx,%eax
  101137:	0f b7 c0             	movzwl %ax,%eax
  10113a:	29 c3                	sub    %eax,%ebx
  10113c:	89 d8                	mov    %ebx,%eax
  10113e:	0f b7 c0             	movzwl %ax,%eax
  101141:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101147:	eb 2b                	jmp    101174 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101149:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10114f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101156:	8d 50 01             	lea    0x1(%eax),%edx
  101159:	0f b7 d2             	movzwl %dx,%edx
  10115c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101163:	01 c0                	add    %eax,%eax
  101165:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101168:	8b 45 08             	mov    0x8(%ebp),%eax
  10116b:	0f b7 c0             	movzwl %ax,%eax
  10116e:	66 89 02             	mov    %ax,(%edx)
        break;
  101171:	eb 01                	jmp    101174 <cga_putc+0xf2>
        break;
  101173:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101174:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10117b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101180:	76 5d                	jbe    1011df <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101182:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101187:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10118d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101192:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101199:	00 
  10119a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10119e:	89 04 24             	mov    %eax,(%esp)
  1011a1:	e8 64 1a 00 00       	call   102c0a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a6:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ad:	eb 14                	jmp    1011c3 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  1011af:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011b7:	01 d2                	add    %edx,%edx
  1011b9:	01 d0                	add    %edx,%eax
  1011bb:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c0:	ff 45 f4             	incl   -0xc(%ebp)
  1011c3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011ca:	7e e3                	jle    1011af <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  1011cc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d3:	83 e8 50             	sub    $0x50,%eax
  1011d6:	0f b7 c0             	movzwl %ax,%eax
  1011d9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011df:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011ea:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011ee:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011f2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011f6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011f7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011fe:	c1 e8 08             	shr    $0x8,%eax
  101201:	0f b7 c0             	movzwl %ax,%eax
  101204:	0f b6 c0             	movzbl %al,%eax
  101207:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10120e:	42                   	inc    %edx
  10120f:	0f b7 d2             	movzwl %dx,%edx
  101212:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101216:	88 45 e9             	mov    %al,-0x17(%ebp)
  101219:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10121d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101221:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101222:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101229:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10122d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101231:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101235:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101239:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10123a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101241:	0f b6 c0             	movzbl %al,%eax
  101244:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10124b:	42                   	inc    %edx
  10124c:	0f b7 d2             	movzwl %dx,%edx
  10124f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101253:	88 45 f1             	mov    %al,-0xf(%ebp)
  101256:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10125a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10125e:	ee                   	out    %al,(%dx)
}
  10125f:	90                   	nop
  101260:	83 c4 34             	add    $0x34,%esp
  101263:	5b                   	pop    %ebx
  101264:	5d                   	pop    %ebp
  101265:	c3                   	ret    

00101266 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101266:	55                   	push   %ebp
  101267:	89 e5                	mov    %esp,%ebp
  101269:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101273:	eb 08                	jmp    10127d <serial_putc_sub+0x17>
        delay();
  101275:	e8 3e fb ff ff       	call   100db8 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127a:	ff 45 fc             	incl   -0x4(%ebp)
  10127d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101283:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101287:	89 c2                	mov    %eax,%edx
  101289:	ec                   	in     (%dx),%al
  10128a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10128d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101291:	0f b6 c0             	movzbl %al,%eax
  101294:	83 e0 20             	and    $0x20,%eax
  101297:	85 c0                	test   %eax,%eax
  101299:	75 09                	jne    1012a4 <serial_putc_sub+0x3e>
  10129b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a2:	7e d1                	jle    101275 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a7:	0f b6 c0             	movzbl %al,%eax
  1012aa:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012b0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012b7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012bb:	ee                   	out    %al,(%dx)
}
  1012bc:	90                   	nop
  1012bd:	c9                   	leave  
  1012be:	c3                   	ret    

001012bf <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c9:	74 0d                	je     1012d8 <serial_putc+0x19>
        serial_putc_sub(c);
  1012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ce:	89 04 24             	mov    %eax,(%esp)
  1012d1:	e8 90 ff ff ff       	call   101266 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012d6:	eb 24                	jmp    1012fc <serial_putc+0x3d>
        serial_putc_sub('\b');
  1012d8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012df:	e8 82 ff ff ff       	call   101266 <serial_putc_sub>
        serial_putc_sub(' ');
  1012e4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012eb:	e8 76 ff ff ff       	call   101266 <serial_putc_sub>
        serial_putc_sub('\b');
  1012f0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f7:	e8 6a ff ff ff       	call   101266 <serial_putc_sub>
}
  1012fc:	90                   	nop
  1012fd:	c9                   	leave  
  1012fe:	c3                   	ret    

001012ff <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ff:	55                   	push   %ebp
  101300:	89 e5                	mov    %esp,%ebp
  101302:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101305:	eb 33                	jmp    10133a <cons_intr+0x3b>
        if (c != 0) {
  101307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10130b:	74 2d                	je     10133a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10130d:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101312:	8d 50 01             	lea    0x1(%eax),%edx
  101315:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10131b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10131e:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101324:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101329:	3d 00 02 00 00       	cmp    $0x200,%eax
  10132e:	75 0a                	jne    10133a <cons_intr+0x3b>
                cons.wpos = 0;
  101330:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101337:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10133a:	8b 45 08             	mov    0x8(%ebp),%eax
  10133d:	ff d0                	call   *%eax
  10133f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101342:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101346:	75 bf                	jne    101307 <cons_intr+0x8>
            }
        }
    }
}
  101348:	90                   	nop
  101349:	c9                   	leave  
  10134a:	c3                   	ret    

0010134b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10134b:	55                   	push   %ebp
  10134c:	89 e5                	mov    %esp,%ebp
  10134e:	83 ec 10             	sub    $0x10,%esp
  101351:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101357:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135b:	89 c2                	mov    %eax,%edx
  10135d:	ec                   	in     (%dx),%al
  10135e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101361:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101365:	0f b6 c0             	movzbl %al,%eax
  101368:	83 e0 01             	and    $0x1,%eax
  10136b:	85 c0                	test   %eax,%eax
  10136d:	75 07                	jne    101376 <serial_proc_data+0x2b>
        return -1;
  10136f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101374:	eb 2a                	jmp    1013a0 <serial_proc_data+0x55>
  101376:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10137c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101380:	89 c2                	mov    %eax,%edx
  101382:	ec                   	in     (%dx),%al
  101383:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101386:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10138a:	0f b6 c0             	movzbl %al,%eax
  10138d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101390:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101394:	75 07                	jne    10139d <serial_proc_data+0x52>
        c = '\b';
  101396:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10139d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013a8:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013ad:	85 c0                	test   %eax,%eax
  1013af:	74 0c                	je     1013bd <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b1:	c7 04 24 4b 13 10 00 	movl   $0x10134b,(%esp)
  1013b8:	e8 42 ff ff ff       	call   1012ff <cons_intr>
    }
}
  1013bd:	90                   	nop
  1013be:	c9                   	leave  
  1013bf:	c3                   	ret    

001013c0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c0:	55                   	push   %ebp
  1013c1:	89 e5                	mov    %esp,%ebp
  1013c3:	83 ec 38             	sub    $0x38,%esp
  1013c6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013cf:	89 c2                	mov    %eax,%edx
  1013d1:	ec                   	in     (%dx),%al
  1013d2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013d9:	0f b6 c0             	movzbl %al,%eax
  1013dc:	83 e0 01             	and    $0x1,%eax
  1013df:	85 c0                	test   %eax,%eax
  1013e1:	75 0a                	jne    1013ed <kbd_proc_data+0x2d>
        return -1;
  1013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e8:	e9 55 01 00 00       	jmp    101542 <kbd_proc_data+0x182>
  1013ed:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1013f6:	89 c2                	mov    %eax,%edx
  1013f8:	ec                   	in     (%dx),%al
  1013f9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013fc:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101400:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101403:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101407:	75 17                	jne    101420 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101409:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140e:	83 c8 40             	or     $0x40,%eax
  101411:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101416:	b8 00 00 00 00       	mov    $0x0,%eax
  10141b:	e9 22 01 00 00       	jmp    101542 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101420:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101424:	84 c0                	test   %al,%al
  101426:	79 45                	jns    10146d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101428:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142d:	83 e0 40             	and    $0x40,%eax
  101430:	85 c0                	test   %eax,%eax
  101432:	75 08                	jne    10143c <kbd_proc_data+0x7c>
  101434:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101438:	24 7f                	and    $0x7f,%al
  10143a:	eb 04                	jmp    101440 <kbd_proc_data+0x80>
  10143c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101440:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101443:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101447:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10144e:	0c 40                	or     $0x40,%al
  101450:	0f b6 c0             	movzbl %al,%eax
  101453:	f7 d0                	not    %eax
  101455:	89 c2                	mov    %eax,%edx
  101457:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145c:	21 d0                	and    %edx,%eax
  10145e:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101463:	b8 00 00 00 00       	mov    $0x0,%eax
  101468:	e9 d5 00 00 00       	jmp    101542 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  10146d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101472:	83 e0 40             	and    $0x40,%eax
  101475:	85 c0                	test   %eax,%eax
  101477:	74 11                	je     10148a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101479:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10147d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101482:	83 e0 bf             	and    $0xffffffbf,%eax
  101485:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101495:	0f b6 d0             	movzbl %al,%edx
  101498:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149d:	09 d0                	or     %edx,%eax
  10149f:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a8:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014af:	0f b6 d0             	movzbl %al,%edx
  1014b2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b7:	31 d0                	xor    %edx,%eax
  1014b9:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014be:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c3:	83 e0 03             	and    $0x3,%eax
  1014c6:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d1:	01 d0                	add    %edx,%eax
  1014d3:	0f b6 00             	movzbl (%eax),%eax
  1014d6:	0f b6 c0             	movzbl %al,%eax
  1014d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014dc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e1:	83 e0 08             	and    $0x8,%eax
  1014e4:	85 c0                	test   %eax,%eax
  1014e6:	74 22                	je     10150a <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1014e8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014ec:	7e 0c                	jle    1014fa <kbd_proc_data+0x13a>
  1014ee:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f2:	7f 06                	jg     1014fa <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1014f4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f8:	eb 10                	jmp    10150a <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1014fa:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014fe:	7e 0a                	jle    10150a <kbd_proc_data+0x14a>
  101500:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101504:	7f 04                	jg     10150a <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101506:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10150a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10150f:	f7 d0                	not    %eax
  101511:	83 e0 06             	and    $0x6,%eax
  101514:	85 c0                	test   %eax,%eax
  101516:	75 27                	jne    10153f <kbd_proc_data+0x17f>
  101518:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10151f:	75 1e                	jne    10153f <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  101521:	c7 04 24 0d 37 10 00 	movl   $0x10370d,(%esp)
  101528:	e8 2f ed ff ff       	call   10025c <cprintf>
  10152d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101533:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101537:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10153b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10153e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101542:	c9                   	leave  
  101543:	c3                   	ret    

00101544 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101544:	55                   	push   %ebp
  101545:	89 e5                	mov    %esp,%ebp
  101547:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10154a:	c7 04 24 c0 13 10 00 	movl   $0x1013c0,(%esp)
  101551:	e8 a9 fd ff ff       	call   1012ff <cons_intr>
}
  101556:	90                   	nop
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <kbd_init>:

static void
kbd_init(void) {
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10155f:	e8 e0 ff ff ff       	call   101544 <kbd_intr>
    pic_enable(IRQ_KBD);
  101564:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10156b:	e8 0f 01 00 00       	call   10167f <pic_enable>
}
  101570:	90                   	nop
  101571:	c9                   	leave  
  101572:	c3                   	ret    

00101573 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101573:	55                   	push   %ebp
  101574:	89 e5                	mov    %esp,%ebp
  101576:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101579:	e8 83 f8 ff ff       	call   100e01 <cga_init>
    serial_init();
  10157e:	e8 62 f9 ff ff       	call   100ee5 <serial_init>
    kbd_init();
  101583:	e8 d1 ff ff ff       	call   101559 <kbd_init>
    if (!serial_exists) {
  101588:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10158d:	85 c0                	test   %eax,%eax
  10158f:	75 0c                	jne    10159d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101591:	c7 04 24 19 37 10 00 	movl   $0x103719,(%esp)
  101598:	e8 bf ec ff ff       	call   10025c <cprintf>
    }
}
  10159d:	90                   	nop
  10159e:	c9                   	leave  
  10159f:	c3                   	ret    

001015a0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a0:	55                   	push   %ebp
  1015a1:	89 e5                	mov    %esp,%ebp
  1015a3:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a9:	89 04 24             	mov    %eax,(%esp)
  1015ac:	e8 91 fa ff ff       	call   101042 <lpt_putc>
    cga_putc(c);
  1015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b4:	89 04 24             	mov    %eax,(%esp)
  1015b7:	e8 c6 fa ff ff       	call   101082 <cga_putc>
    serial_putc(c);
  1015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bf:	89 04 24             	mov    %eax,(%esp)
  1015c2:	e8 f8 fc ff ff       	call   1012bf <serial_putc>
}
  1015c7:	90                   	nop
  1015c8:	c9                   	leave  
  1015c9:	c3                   	ret    

001015ca <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ca:	55                   	push   %ebp
  1015cb:	89 e5                	mov    %esp,%ebp
  1015cd:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d0:	e8 cd fd ff ff       	call   1013a2 <serial_intr>
    kbd_intr();
  1015d5:	e8 6a ff ff ff       	call   101544 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015da:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015e5:	39 c2                	cmp    %eax,%edx
  1015e7:	74 36                	je     10161f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015e9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ee:	8d 50 01             	lea    0x1(%eax),%edx
  1015f1:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015f7:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015fe:	0f b6 c0             	movzbl %al,%eax
  101601:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101604:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101609:	3d 00 02 00 00       	cmp    $0x200,%eax
  10160e:	75 0a                	jne    10161a <cons_getc+0x50>
            cons.rpos = 0;
  101610:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101617:	00 00 00 
        }
        return c;
  10161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10161d:	eb 05                	jmp    101624 <cons_getc+0x5a>
    }
    return 0;
  10161f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101624:	c9                   	leave  
  101625:	c3                   	ret    

00101626 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101626:	55                   	push   %ebp
  101627:	89 e5                	mov    %esp,%ebp
  101629:	83 ec 14             	sub    $0x14,%esp
  10162c:	8b 45 08             	mov    0x8(%ebp),%eax
  10162f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101636:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10163c:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101641:	85 c0                	test   %eax,%eax
  101643:	74 37                	je     10167c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101648:	0f b6 c0             	movzbl %al,%eax
  10164b:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101651:	88 45 f9             	mov    %al,-0x7(%ebp)
  101654:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101658:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10165c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10165d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101661:	c1 e8 08             	shr    $0x8,%eax
  101664:	0f b7 c0             	movzwl %ax,%eax
  101667:	0f b6 c0             	movzbl %al,%eax
  10166a:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101670:	88 45 fd             	mov    %al,-0x3(%ebp)
  101673:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101677:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10167b:	ee                   	out    %al,(%dx)
    }
}
  10167c:	90                   	nop
  10167d:	c9                   	leave  
  10167e:	c3                   	ret    

0010167f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10167f:	55                   	push   %ebp
  101680:	89 e5                	mov    %esp,%ebp
  101682:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101685:	8b 45 08             	mov    0x8(%ebp),%eax
  101688:	ba 01 00 00 00       	mov    $0x1,%edx
  10168d:	88 c1                	mov    %al,%cl
  10168f:	d3 e2                	shl    %cl,%edx
  101691:	89 d0                	mov    %edx,%eax
  101693:	98                   	cwtl   
  101694:	f7 d0                	not    %eax
  101696:	0f bf d0             	movswl %ax,%edx
  101699:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a0:	98                   	cwtl   
  1016a1:	21 d0                	and    %edx,%eax
  1016a3:	98                   	cwtl   
  1016a4:	0f b7 c0             	movzwl %ax,%eax
  1016a7:	89 04 24             	mov    %eax,(%esp)
  1016aa:	e8 77 ff ff ff       	call   101626 <pic_setmask>
}
  1016af:	90                   	nop
  1016b0:	c9                   	leave  
  1016b1:	c3                   	ret    

001016b2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp
  1016b5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016b8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016bf:	00 00 00 
  1016c2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016c8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016cc:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016d0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
  1016d5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016db:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016df:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016e3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
  1016e8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016ee:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016f2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016f6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
  1016fb:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101701:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101705:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101709:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
  10170e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101714:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101718:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10171c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
  101721:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101727:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  10172b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10172f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101733:	ee                   	out    %al,(%dx)
  101734:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10173a:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10173e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101742:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
  101747:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10174d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101751:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101755:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101759:	ee                   	out    %al,(%dx)
  10175a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101760:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101764:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101768:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
  10176d:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101773:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101777:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10177b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
  101780:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101786:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10178a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
  101793:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101799:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10179d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017a1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017a5:	ee                   	out    %al,(%dx)
  1017a6:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017ac:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017b0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017b4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017b8:	ee                   	out    %al,(%dx)
  1017b9:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017bf:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017c3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017c7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017cb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017cc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d3:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017d8:	74 0f                	je     1017e9 <pic_init+0x137>
        pic_setmask(irq_mask);
  1017da:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e1:	89 04 24             	mov    %eax,(%esp)
  1017e4:	e8 3d fe ff ff       	call   101626 <pic_setmask>
    }
}
  1017e9:	90                   	nop
  1017ea:	c9                   	leave  
  1017eb:	c3                   	ret    

001017ec <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017ec:	55                   	push   %ebp
  1017ed:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017ef:	fb                   	sti    
    sti();
}
  1017f0:	90                   	nop
  1017f1:	5d                   	pop    %ebp
  1017f2:	c3                   	ret    

001017f3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017f6:	fa                   	cli    
    cli();
}
  1017f7:	90                   	nop
  1017f8:	5d                   	pop    %ebp
  1017f9:	c3                   	ret    

001017fa <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fa:	55                   	push   %ebp
  1017fb:	89 e5                	mov    %esp,%ebp
  1017fd:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101800:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101807:	00 
  101808:	c7 04 24 40 37 10 00 	movl   $0x103740,(%esp)
  10180f:	e8 48 ea ff ff       	call   10025c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101814:	90                   	nop
  101815:	c9                   	leave  
  101816:	c3                   	ret    

00101817 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101817:	55                   	push   %ebp
  101818:	89 e5                	mov    %esp,%ebp
  10181a:	83 ec 10             	sub    $0x10,%esp
    extern uintptr_t __vectors[];
    for (int i=0;i<256;++i)
  10181d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101824:	e9 c4 00 00 00       	jmp    1018ed <idt_init+0xd6>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
  101829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101833:	0f b7 d0             	movzwl %ax,%edx
  101836:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101839:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101840:	00 
  101841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101844:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10184b:	00 08 00 
  10184e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101851:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101858:	00 
  101859:	80 e2 e0             	and    $0xe0,%dl
  10185c:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101866:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10186d:	00 
  10186e:	80 e2 1f             	and    $0x1f,%dl
  101871:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187b:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101882:	00 
  101883:	80 e2 f0             	and    $0xf0,%dl
  101886:	80 ca 0e             	or     $0xe,%dl
  101889:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101890:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101893:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189a:	00 
  10189b:	80 e2 ef             	and    $0xef,%dl
  10189e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018af:	00 
  1018b0:	80 e2 9f             	and    $0x9f,%dl
  1018b3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c4:	00 
  1018c5:	80 ca 80             	or     $0x80,%dl
  1018c8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d2:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018d9:	c1 e8 10             	shr    $0x10,%eax
  1018dc:	0f b7 d0             	movzwl %ax,%edx
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018e9:	00 
    for (int i=0;i<256;++i)
  1018ea:	ff 45 fc             	incl   -0x4(%ebp)
  1018ed:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018f4:	0f 8e 2f ff ff ff    	jle    101829 <idt_init+0x12>
  1018fa:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101901:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101904:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101907:	90                   	nop
  101908:	c9                   	leave  
  101909:	c3                   	ret    

0010190a <trapname>:

static const char *
trapname(int trapno) {
  10190a:	55                   	push   %ebp
  10190b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10190d:	8b 45 08             	mov    0x8(%ebp),%eax
  101910:	83 f8 13             	cmp    $0x13,%eax
  101913:	77 0c                	ja     101921 <trapname+0x17>
        return excnames[trapno];
  101915:	8b 45 08             	mov    0x8(%ebp),%eax
  101918:	8b 04 85 a0 3a 10 00 	mov    0x103aa0(,%eax,4),%eax
  10191f:	eb 18                	jmp    101939 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101921:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101925:	7e 0d                	jle    101934 <trapname+0x2a>
  101927:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10192b:	7f 07                	jg     101934 <trapname+0x2a>
        return "Hardware Interrupt";
  10192d:	b8 4a 37 10 00       	mov    $0x10374a,%eax
  101932:	eb 05                	jmp    101939 <trapname+0x2f>
    }
    return "(unknown trap)";
  101934:	b8 5d 37 10 00       	mov    $0x10375d,%eax
}
  101939:	5d                   	pop    %ebp
  10193a:	c3                   	ret    

0010193b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10193b:	55                   	push   %ebp
  10193c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10193e:	8b 45 08             	mov    0x8(%ebp),%eax
  101941:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101945:	83 f8 08             	cmp    $0x8,%eax
  101948:	0f 94 c0             	sete   %al
  10194b:	0f b6 c0             	movzbl %al,%eax
}
  10194e:	5d                   	pop    %ebp
  10194f:	c3                   	ret    

00101950 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101950:	55                   	push   %ebp
  101951:	89 e5                	mov    %esp,%ebp
  101953:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101956:	8b 45 08             	mov    0x8(%ebp),%eax
  101959:	89 44 24 04          	mov    %eax,0x4(%esp)
  10195d:	c7 04 24 9e 37 10 00 	movl   $0x10379e,(%esp)
  101964:	e8 f3 e8 ff ff       	call   10025c <cprintf>
    print_regs(&tf->tf_regs);
  101969:	8b 45 08             	mov    0x8(%ebp),%eax
  10196c:	89 04 24             	mov    %eax,(%esp)
  10196f:	e8 8f 01 00 00       	call   101b03 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101974:	8b 45 08             	mov    0x8(%ebp),%eax
  101977:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  10197b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10197f:	c7 04 24 af 37 10 00 	movl   $0x1037af,(%esp)
  101986:	e8 d1 e8 ff ff       	call   10025c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  10198b:	8b 45 08             	mov    0x8(%ebp),%eax
  10198e:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101992:	89 44 24 04          	mov    %eax,0x4(%esp)
  101996:	c7 04 24 c2 37 10 00 	movl   $0x1037c2,(%esp)
  10199d:	e8 ba e8 ff ff       	call   10025c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a5:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ad:	c7 04 24 d5 37 10 00 	movl   $0x1037d5,(%esp)
  1019b4:	e8 a3 e8 ff ff       	call   10025c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019bc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c4:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  1019cb:	e8 8c e8 ff ff       	call   10025c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d3:	8b 40 30             	mov    0x30(%eax),%eax
  1019d6:	89 04 24             	mov    %eax,(%esp)
  1019d9:	e8 2c ff ff ff       	call   10190a <trapname>
  1019de:	89 c2                	mov    %eax,%edx
  1019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e3:	8b 40 30             	mov    0x30(%eax),%eax
  1019e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  1019ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ee:	c7 04 24 fb 37 10 00 	movl   $0x1037fb,(%esp)
  1019f5:	e8 62 e8 ff ff       	call   10025c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  1019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fd:	8b 40 34             	mov    0x34(%eax),%eax
  101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a04:	c7 04 24 0d 38 10 00 	movl   $0x10380d,(%esp)
  101a0b:	e8 4c e8 ff ff       	call   10025c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a10:	8b 45 08             	mov    0x8(%ebp),%eax
  101a13:	8b 40 38             	mov    0x38(%eax),%eax
  101a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1a:	c7 04 24 1c 38 10 00 	movl   $0x10381c,(%esp)
  101a21:	e8 36 e8 ff ff       	call   10025c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a26:	8b 45 08             	mov    0x8(%ebp),%eax
  101a29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a31:	c7 04 24 2b 38 10 00 	movl   $0x10382b,(%esp)
  101a38:	e8 1f e8 ff ff       	call   10025c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	8b 40 40             	mov    0x40(%eax),%eax
  101a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a47:	c7 04 24 3e 38 10 00 	movl   $0x10383e,(%esp)
  101a4e:	e8 09 e8 ff ff       	call   10025c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a5a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a61:	eb 3d                	jmp    101aa0 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a63:	8b 45 08             	mov    0x8(%ebp),%eax
  101a66:	8b 50 40             	mov    0x40(%eax),%edx
  101a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a6c:	21 d0                	and    %edx,%eax
  101a6e:	85 c0                	test   %eax,%eax
  101a70:	74 28                	je     101a9a <print_trapframe+0x14a>
  101a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a75:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a7c:	85 c0                	test   %eax,%eax
  101a7e:	74 1a                	je     101a9a <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a83:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8e:	c7 04 24 4d 38 10 00 	movl   $0x10384d,(%esp)
  101a95:	e8 c2 e7 ff ff       	call   10025c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a9a:	ff 45 f4             	incl   -0xc(%ebp)
  101a9d:	d1 65 f0             	shll   -0x10(%ebp)
  101aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aa3:	83 f8 17             	cmp    $0x17,%eax
  101aa6:	76 bb                	jbe    101a63 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aab:	8b 40 40             	mov    0x40(%eax),%eax
  101aae:	c1 e8 0c             	shr    $0xc,%eax
  101ab1:	83 e0 03             	and    $0x3,%eax
  101ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab8:	c7 04 24 51 38 10 00 	movl   $0x103851,(%esp)
  101abf:	e8 98 e7 ff ff       	call   10025c <cprintf>

    if (!trap_in_kernel(tf)) {
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	89 04 24             	mov    %eax,(%esp)
  101aca:	e8 6c fe ff ff       	call   10193b <trap_in_kernel>
  101acf:	85 c0                	test   %eax,%eax
  101ad1:	75 2d                	jne    101b00 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad6:	8b 40 44             	mov    0x44(%eax),%eax
  101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101add:	c7 04 24 5a 38 10 00 	movl   $0x10385a,(%esp)
  101ae4:	e8 73 e7 ff ff       	call   10025c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af4:	c7 04 24 69 38 10 00 	movl   $0x103869,(%esp)
  101afb:	e8 5c e7 ff ff       	call   10025c <cprintf>
    }
}
  101b00:	90                   	nop
  101b01:	c9                   	leave  
  101b02:	c3                   	ret    

00101b03 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b03:	55                   	push   %ebp
  101b04:	89 e5                	mov    %esp,%ebp
  101b06:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b09:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0c:	8b 00                	mov    (%eax),%eax
  101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b12:	c7 04 24 7c 38 10 00 	movl   $0x10387c,(%esp)
  101b19:	e8 3e e7 ff ff       	call   10025c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b21:	8b 40 04             	mov    0x4(%eax),%eax
  101b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b28:	c7 04 24 8b 38 10 00 	movl   $0x10388b,(%esp)
  101b2f:	e8 28 e7 ff ff       	call   10025c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b34:	8b 45 08             	mov    0x8(%ebp),%eax
  101b37:	8b 40 08             	mov    0x8(%eax),%eax
  101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3e:	c7 04 24 9a 38 10 00 	movl   $0x10389a,(%esp)
  101b45:	e8 12 e7 ff ff       	call   10025c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	8b 40 0c             	mov    0xc(%eax),%eax
  101b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b54:	c7 04 24 a9 38 10 00 	movl   $0x1038a9,(%esp)
  101b5b:	e8 fc e6 ff ff       	call   10025c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b60:	8b 45 08             	mov    0x8(%ebp),%eax
  101b63:	8b 40 10             	mov    0x10(%eax),%eax
  101b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6a:	c7 04 24 b8 38 10 00 	movl   $0x1038b8,(%esp)
  101b71:	e8 e6 e6 ff ff       	call   10025c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b76:	8b 45 08             	mov    0x8(%ebp),%eax
  101b79:	8b 40 14             	mov    0x14(%eax),%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 c7 38 10 00 	movl   $0x1038c7,(%esp)
  101b87:	e8 d0 e6 ff ff       	call   10025c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	8b 40 18             	mov    0x18(%eax),%eax
  101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b96:	c7 04 24 d6 38 10 00 	movl   $0x1038d6,(%esp)
  101b9d:	e8 ba e6 ff ff       	call   10025c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba5:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bac:	c7 04 24 e5 38 10 00 	movl   $0x1038e5,(%esp)
  101bb3:	e8 a4 e6 ff ff       	call   10025c <cprintf>
}
  101bb8:	90                   	nop
  101bb9:	c9                   	leave  
  101bba:	c3                   	ret    

00101bbb <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101bbb:	55                   	push   %ebp
  101bbc:	89 e5                	mov    %esp,%ebp
  101bbe:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int clock_cnt=0;
    switch (tf->tf_trapno) {
  101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc4:	8b 40 30             	mov    0x30(%eax),%eax
  101bc7:	83 f8 2f             	cmp    $0x2f,%eax
  101bca:	77 1d                	ja     101be9 <trap_dispatch+0x2e>
  101bcc:	83 f8 2e             	cmp    $0x2e,%eax
  101bcf:	0f 83 ec 00 00 00    	jae    101cc1 <trap_dispatch+0x106>
  101bd5:	83 f8 21             	cmp    $0x21,%eax
  101bd8:	74 70                	je     101c4a <trap_dispatch+0x8f>
  101bda:	83 f8 24             	cmp    $0x24,%eax
  101bdd:	74 45                	je     101c24 <trap_dispatch+0x69>
  101bdf:	83 f8 20             	cmp    $0x20,%eax
  101be2:	74 13                	je     101bf7 <trap_dispatch+0x3c>
  101be4:	e9 a3 00 00 00       	jmp    101c8c <trap_dispatch+0xd1>
  101be9:	83 e8 78             	sub    $0x78,%eax
  101bec:	83 f8 01             	cmp    $0x1,%eax
  101bef:	0f 87 97 00 00 00    	ja     101c8c <trap_dispatch+0xd1>
  101bf5:	eb 79                	jmp    101c70 <trap_dispatch+0xb5>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ++clock_cnt;
  101bf7:	a1 a0 f8 10 00       	mov    0x10f8a0,%eax
  101bfc:	40                   	inc    %eax
  101bfd:	a3 a0 f8 10 00       	mov    %eax,0x10f8a0
        if (clock_cnt==TICK_NUM)
  101c02:	a1 a0 f8 10 00       	mov    0x10f8a0,%eax
  101c07:	83 f8 64             	cmp    $0x64,%eax
  101c0a:	0f 85 b4 00 00 00    	jne    101cc4 <trap_dispatch+0x109>
            print_ticks(),clock_cnt=0;
  101c10:	e8 e5 fb ff ff       	call   1017fa <print_ticks>
  101c15:	c7 05 a0 f8 10 00 00 	movl   $0x0,0x10f8a0
  101c1c:	00 00 00 
        break;
  101c1f:	e9 a0 00 00 00       	jmp    101cc4 <trap_dispatch+0x109>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c24:	e8 a1 f9 ff ff       	call   1015ca <cons_getc>
  101c29:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c2c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c30:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c34:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3c:	c7 04 24 f4 38 10 00 	movl   $0x1038f4,(%esp)
  101c43:	e8 14 e6 ff ff       	call   10025c <cprintf>
        break;
  101c48:	eb 7b                	jmp    101cc5 <trap_dispatch+0x10a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c4a:	e8 7b f9 ff ff       	call   1015ca <cons_getc>
  101c4f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c52:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c56:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c5a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c62:	c7 04 24 06 39 10 00 	movl   $0x103906,(%esp)
  101c69:	e8 ee e5 ff ff       	call   10025c <cprintf>
        break;
  101c6e:	eb 55                	jmp    101cc5 <trap_dispatch+0x10a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101c70:	c7 44 24 08 15 39 10 	movl   $0x103915,0x8(%esp)
  101c77:	00 
  101c78:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  101c7f:	00 
  101c80:	c7 04 24 25 39 10 00 	movl   $0x103925,(%esp)
  101c87:	e8 27 e7 ff ff       	call   1003b3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c93:	83 e0 03             	and    $0x3,%eax
  101c96:	85 c0                	test   %eax,%eax
  101c98:	75 2b                	jne    101cc5 <trap_dispatch+0x10a>
            print_trapframe(tf);
  101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9d:	89 04 24             	mov    %eax,(%esp)
  101ca0:	e8 ab fc ff ff       	call   101950 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ca5:	c7 44 24 08 36 39 10 	movl   $0x103936,0x8(%esp)
  101cac:	00 
  101cad:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  101cb4:	00 
  101cb5:	c7 04 24 25 39 10 00 	movl   $0x103925,(%esp)
  101cbc:	e8 f2 e6 ff ff       	call   1003b3 <__panic>
        break;
  101cc1:	90                   	nop
  101cc2:	eb 01                	jmp    101cc5 <trap_dispatch+0x10a>
        break;
  101cc4:	90                   	nop
        }
    }
}
  101cc5:	90                   	nop
  101cc6:	c9                   	leave  
  101cc7:	c3                   	ret    

00101cc8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101cc8:	55                   	push   %ebp
  101cc9:	89 e5                	mov    %esp,%ebp
  101ccb:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101cce:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd1:	89 04 24             	mov    %eax,(%esp)
  101cd4:	e8 e2 fe ff ff       	call   101bbb <trap_dispatch>
}
  101cd9:	90                   	nop
  101cda:	c9                   	leave  
  101cdb:	c3                   	ret    

00101cdc <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101cdc:	6a 00                	push   $0x0
  pushl $0
  101cde:	6a 00                	push   $0x0
  jmp __alltraps
  101ce0:	e9 69 0a 00 00       	jmp    10274e <__alltraps>

00101ce5 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ce5:	6a 00                	push   $0x0
  pushl $1
  101ce7:	6a 01                	push   $0x1
  jmp __alltraps
  101ce9:	e9 60 0a 00 00       	jmp    10274e <__alltraps>

00101cee <vector2>:
.globl vector2
vector2:
  pushl $0
  101cee:	6a 00                	push   $0x0
  pushl $2
  101cf0:	6a 02                	push   $0x2
  jmp __alltraps
  101cf2:	e9 57 0a 00 00       	jmp    10274e <__alltraps>

00101cf7 <vector3>:
.globl vector3
vector3:
  pushl $0
  101cf7:	6a 00                	push   $0x0
  pushl $3
  101cf9:	6a 03                	push   $0x3
  jmp __alltraps
  101cfb:	e9 4e 0a 00 00       	jmp    10274e <__alltraps>

00101d00 <vector4>:
.globl vector4
vector4:
  pushl $0
  101d00:	6a 00                	push   $0x0
  pushl $4
  101d02:	6a 04                	push   $0x4
  jmp __alltraps
  101d04:	e9 45 0a 00 00       	jmp    10274e <__alltraps>

00101d09 <vector5>:
.globl vector5
vector5:
  pushl $0
  101d09:	6a 00                	push   $0x0
  pushl $5
  101d0b:	6a 05                	push   $0x5
  jmp __alltraps
  101d0d:	e9 3c 0a 00 00       	jmp    10274e <__alltraps>

00101d12 <vector6>:
.globl vector6
vector6:
  pushl $0
  101d12:	6a 00                	push   $0x0
  pushl $6
  101d14:	6a 06                	push   $0x6
  jmp __alltraps
  101d16:	e9 33 0a 00 00       	jmp    10274e <__alltraps>

00101d1b <vector7>:
.globl vector7
vector7:
  pushl $0
  101d1b:	6a 00                	push   $0x0
  pushl $7
  101d1d:	6a 07                	push   $0x7
  jmp __alltraps
  101d1f:	e9 2a 0a 00 00       	jmp    10274e <__alltraps>

00101d24 <vector8>:
.globl vector8
vector8:
  pushl $8
  101d24:	6a 08                	push   $0x8
  jmp __alltraps
  101d26:	e9 23 0a 00 00       	jmp    10274e <__alltraps>

00101d2b <vector9>:
.globl vector9
vector9:
  pushl $0
  101d2b:	6a 00                	push   $0x0
  pushl $9
  101d2d:	6a 09                	push   $0x9
  jmp __alltraps
  101d2f:	e9 1a 0a 00 00       	jmp    10274e <__alltraps>

00101d34 <vector10>:
.globl vector10
vector10:
  pushl $10
  101d34:	6a 0a                	push   $0xa
  jmp __alltraps
  101d36:	e9 13 0a 00 00       	jmp    10274e <__alltraps>

00101d3b <vector11>:
.globl vector11
vector11:
  pushl $11
  101d3b:	6a 0b                	push   $0xb
  jmp __alltraps
  101d3d:	e9 0c 0a 00 00       	jmp    10274e <__alltraps>

00101d42 <vector12>:
.globl vector12
vector12:
  pushl $12
  101d42:	6a 0c                	push   $0xc
  jmp __alltraps
  101d44:	e9 05 0a 00 00       	jmp    10274e <__alltraps>

00101d49 <vector13>:
.globl vector13
vector13:
  pushl $13
  101d49:	6a 0d                	push   $0xd
  jmp __alltraps
  101d4b:	e9 fe 09 00 00       	jmp    10274e <__alltraps>

00101d50 <vector14>:
.globl vector14
vector14:
  pushl $14
  101d50:	6a 0e                	push   $0xe
  jmp __alltraps
  101d52:	e9 f7 09 00 00       	jmp    10274e <__alltraps>

00101d57 <vector15>:
.globl vector15
vector15:
  pushl $0
  101d57:	6a 00                	push   $0x0
  pushl $15
  101d59:	6a 0f                	push   $0xf
  jmp __alltraps
  101d5b:	e9 ee 09 00 00       	jmp    10274e <__alltraps>

00101d60 <vector16>:
.globl vector16
vector16:
  pushl $0
  101d60:	6a 00                	push   $0x0
  pushl $16
  101d62:	6a 10                	push   $0x10
  jmp __alltraps
  101d64:	e9 e5 09 00 00       	jmp    10274e <__alltraps>

00101d69 <vector17>:
.globl vector17
vector17:
  pushl $17
  101d69:	6a 11                	push   $0x11
  jmp __alltraps
  101d6b:	e9 de 09 00 00       	jmp    10274e <__alltraps>

00101d70 <vector18>:
.globl vector18
vector18:
  pushl $0
  101d70:	6a 00                	push   $0x0
  pushl $18
  101d72:	6a 12                	push   $0x12
  jmp __alltraps
  101d74:	e9 d5 09 00 00       	jmp    10274e <__alltraps>

00101d79 <vector19>:
.globl vector19
vector19:
  pushl $0
  101d79:	6a 00                	push   $0x0
  pushl $19
  101d7b:	6a 13                	push   $0x13
  jmp __alltraps
  101d7d:	e9 cc 09 00 00       	jmp    10274e <__alltraps>

00101d82 <vector20>:
.globl vector20
vector20:
  pushl $0
  101d82:	6a 00                	push   $0x0
  pushl $20
  101d84:	6a 14                	push   $0x14
  jmp __alltraps
  101d86:	e9 c3 09 00 00       	jmp    10274e <__alltraps>

00101d8b <vector21>:
.globl vector21
vector21:
  pushl $0
  101d8b:	6a 00                	push   $0x0
  pushl $21
  101d8d:	6a 15                	push   $0x15
  jmp __alltraps
  101d8f:	e9 ba 09 00 00       	jmp    10274e <__alltraps>

00101d94 <vector22>:
.globl vector22
vector22:
  pushl $0
  101d94:	6a 00                	push   $0x0
  pushl $22
  101d96:	6a 16                	push   $0x16
  jmp __alltraps
  101d98:	e9 b1 09 00 00       	jmp    10274e <__alltraps>

00101d9d <vector23>:
.globl vector23
vector23:
  pushl $0
  101d9d:	6a 00                	push   $0x0
  pushl $23
  101d9f:	6a 17                	push   $0x17
  jmp __alltraps
  101da1:	e9 a8 09 00 00       	jmp    10274e <__alltraps>

00101da6 <vector24>:
.globl vector24
vector24:
  pushl $0
  101da6:	6a 00                	push   $0x0
  pushl $24
  101da8:	6a 18                	push   $0x18
  jmp __alltraps
  101daa:	e9 9f 09 00 00       	jmp    10274e <__alltraps>

00101daf <vector25>:
.globl vector25
vector25:
  pushl $0
  101daf:	6a 00                	push   $0x0
  pushl $25
  101db1:	6a 19                	push   $0x19
  jmp __alltraps
  101db3:	e9 96 09 00 00       	jmp    10274e <__alltraps>

00101db8 <vector26>:
.globl vector26
vector26:
  pushl $0
  101db8:	6a 00                	push   $0x0
  pushl $26
  101dba:	6a 1a                	push   $0x1a
  jmp __alltraps
  101dbc:	e9 8d 09 00 00       	jmp    10274e <__alltraps>

00101dc1 <vector27>:
.globl vector27
vector27:
  pushl $0
  101dc1:	6a 00                	push   $0x0
  pushl $27
  101dc3:	6a 1b                	push   $0x1b
  jmp __alltraps
  101dc5:	e9 84 09 00 00       	jmp    10274e <__alltraps>

00101dca <vector28>:
.globl vector28
vector28:
  pushl $0
  101dca:	6a 00                	push   $0x0
  pushl $28
  101dcc:	6a 1c                	push   $0x1c
  jmp __alltraps
  101dce:	e9 7b 09 00 00       	jmp    10274e <__alltraps>

00101dd3 <vector29>:
.globl vector29
vector29:
  pushl $0
  101dd3:	6a 00                	push   $0x0
  pushl $29
  101dd5:	6a 1d                	push   $0x1d
  jmp __alltraps
  101dd7:	e9 72 09 00 00       	jmp    10274e <__alltraps>

00101ddc <vector30>:
.globl vector30
vector30:
  pushl $0
  101ddc:	6a 00                	push   $0x0
  pushl $30
  101dde:	6a 1e                	push   $0x1e
  jmp __alltraps
  101de0:	e9 69 09 00 00       	jmp    10274e <__alltraps>

00101de5 <vector31>:
.globl vector31
vector31:
  pushl $0
  101de5:	6a 00                	push   $0x0
  pushl $31
  101de7:	6a 1f                	push   $0x1f
  jmp __alltraps
  101de9:	e9 60 09 00 00       	jmp    10274e <__alltraps>

00101dee <vector32>:
.globl vector32
vector32:
  pushl $0
  101dee:	6a 00                	push   $0x0
  pushl $32
  101df0:	6a 20                	push   $0x20
  jmp __alltraps
  101df2:	e9 57 09 00 00       	jmp    10274e <__alltraps>

00101df7 <vector33>:
.globl vector33
vector33:
  pushl $0
  101df7:	6a 00                	push   $0x0
  pushl $33
  101df9:	6a 21                	push   $0x21
  jmp __alltraps
  101dfb:	e9 4e 09 00 00       	jmp    10274e <__alltraps>

00101e00 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e00:	6a 00                	push   $0x0
  pushl $34
  101e02:	6a 22                	push   $0x22
  jmp __alltraps
  101e04:	e9 45 09 00 00       	jmp    10274e <__alltraps>

00101e09 <vector35>:
.globl vector35
vector35:
  pushl $0
  101e09:	6a 00                	push   $0x0
  pushl $35
  101e0b:	6a 23                	push   $0x23
  jmp __alltraps
  101e0d:	e9 3c 09 00 00       	jmp    10274e <__alltraps>

00101e12 <vector36>:
.globl vector36
vector36:
  pushl $0
  101e12:	6a 00                	push   $0x0
  pushl $36
  101e14:	6a 24                	push   $0x24
  jmp __alltraps
  101e16:	e9 33 09 00 00       	jmp    10274e <__alltraps>

00101e1b <vector37>:
.globl vector37
vector37:
  pushl $0
  101e1b:	6a 00                	push   $0x0
  pushl $37
  101e1d:	6a 25                	push   $0x25
  jmp __alltraps
  101e1f:	e9 2a 09 00 00       	jmp    10274e <__alltraps>

00101e24 <vector38>:
.globl vector38
vector38:
  pushl $0
  101e24:	6a 00                	push   $0x0
  pushl $38
  101e26:	6a 26                	push   $0x26
  jmp __alltraps
  101e28:	e9 21 09 00 00       	jmp    10274e <__alltraps>

00101e2d <vector39>:
.globl vector39
vector39:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $39
  101e2f:	6a 27                	push   $0x27
  jmp __alltraps
  101e31:	e9 18 09 00 00       	jmp    10274e <__alltraps>

00101e36 <vector40>:
.globl vector40
vector40:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $40
  101e38:	6a 28                	push   $0x28
  jmp __alltraps
  101e3a:	e9 0f 09 00 00       	jmp    10274e <__alltraps>

00101e3f <vector41>:
.globl vector41
vector41:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $41
  101e41:	6a 29                	push   $0x29
  jmp __alltraps
  101e43:	e9 06 09 00 00       	jmp    10274e <__alltraps>

00101e48 <vector42>:
.globl vector42
vector42:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $42
  101e4a:	6a 2a                	push   $0x2a
  jmp __alltraps
  101e4c:	e9 fd 08 00 00       	jmp    10274e <__alltraps>

00101e51 <vector43>:
.globl vector43
vector43:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $43
  101e53:	6a 2b                	push   $0x2b
  jmp __alltraps
  101e55:	e9 f4 08 00 00       	jmp    10274e <__alltraps>

00101e5a <vector44>:
.globl vector44
vector44:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $44
  101e5c:	6a 2c                	push   $0x2c
  jmp __alltraps
  101e5e:	e9 eb 08 00 00       	jmp    10274e <__alltraps>

00101e63 <vector45>:
.globl vector45
vector45:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $45
  101e65:	6a 2d                	push   $0x2d
  jmp __alltraps
  101e67:	e9 e2 08 00 00       	jmp    10274e <__alltraps>

00101e6c <vector46>:
.globl vector46
vector46:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $46
  101e6e:	6a 2e                	push   $0x2e
  jmp __alltraps
  101e70:	e9 d9 08 00 00       	jmp    10274e <__alltraps>

00101e75 <vector47>:
.globl vector47
vector47:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $47
  101e77:	6a 2f                	push   $0x2f
  jmp __alltraps
  101e79:	e9 d0 08 00 00       	jmp    10274e <__alltraps>

00101e7e <vector48>:
.globl vector48
vector48:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $48
  101e80:	6a 30                	push   $0x30
  jmp __alltraps
  101e82:	e9 c7 08 00 00       	jmp    10274e <__alltraps>

00101e87 <vector49>:
.globl vector49
vector49:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $49
  101e89:	6a 31                	push   $0x31
  jmp __alltraps
  101e8b:	e9 be 08 00 00       	jmp    10274e <__alltraps>

00101e90 <vector50>:
.globl vector50
vector50:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $50
  101e92:	6a 32                	push   $0x32
  jmp __alltraps
  101e94:	e9 b5 08 00 00       	jmp    10274e <__alltraps>

00101e99 <vector51>:
.globl vector51
vector51:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $51
  101e9b:	6a 33                	push   $0x33
  jmp __alltraps
  101e9d:	e9 ac 08 00 00       	jmp    10274e <__alltraps>

00101ea2 <vector52>:
.globl vector52
vector52:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $52
  101ea4:	6a 34                	push   $0x34
  jmp __alltraps
  101ea6:	e9 a3 08 00 00       	jmp    10274e <__alltraps>

00101eab <vector53>:
.globl vector53
vector53:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $53
  101ead:	6a 35                	push   $0x35
  jmp __alltraps
  101eaf:	e9 9a 08 00 00       	jmp    10274e <__alltraps>

00101eb4 <vector54>:
.globl vector54
vector54:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $54
  101eb6:	6a 36                	push   $0x36
  jmp __alltraps
  101eb8:	e9 91 08 00 00       	jmp    10274e <__alltraps>

00101ebd <vector55>:
.globl vector55
vector55:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $55
  101ebf:	6a 37                	push   $0x37
  jmp __alltraps
  101ec1:	e9 88 08 00 00       	jmp    10274e <__alltraps>

00101ec6 <vector56>:
.globl vector56
vector56:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $56
  101ec8:	6a 38                	push   $0x38
  jmp __alltraps
  101eca:	e9 7f 08 00 00       	jmp    10274e <__alltraps>

00101ecf <vector57>:
.globl vector57
vector57:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $57
  101ed1:	6a 39                	push   $0x39
  jmp __alltraps
  101ed3:	e9 76 08 00 00       	jmp    10274e <__alltraps>

00101ed8 <vector58>:
.globl vector58
vector58:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $58
  101eda:	6a 3a                	push   $0x3a
  jmp __alltraps
  101edc:	e9 6d 08 00 00       	jmp    10274e <__alltraps>

00101ee1 <vector59>:
.globl vector59
vector59:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $59
  101ee3:	6a 3b                	push   $0x3b
  jmp __alltraps
  101ee5:	e9 64 08 00 00       	jmp    10274e <__alltraps>

00101eea <vector60>:
.globl vector60
vector60:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $60
  101eec:	6a 3c                	push   $0x3c
  jmp __alltraps
  101eee:	e9 5b 08 00 00       	jmp    10274e <__alltraps>

00101ef3 <vector61>:
.globl vector61
vector61:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $61
  101ef5:	6a 3d                	push   $0x3d
  jmp __alltraps
  101ef7:	e9 52 08 00 00       	jmp    10274e <__alltraps>

00101efc <vector62>:
.globl vector62
vector62:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $62
  101efe:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f00:	e9 49 08 00 00       	jmp    10274e <__alltraps>

00101f05 <vector63>:
.globl vector63
vector63:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $63
  101f07:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f09:	e9 40 08 00 00       	jmp    10274e <__alltraps>

00101f0e <vector64>:
.globl vector64
vector64:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $64
  101f10:	6a 40                	push   $0x40
  jmp __alltraps
  101f12:	e9 37 08 00 00       	jmp    10274e <__alltraps>

00101f17 <vector65>:
.globl vector65
vector65:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $65
  101f19:	6a 41                	push   $0x41
  jmp __alltraps
  101f1b:	e9 2e 08 00 00       	jmp    10274e <__alltraps>

00101f20 <vector66>:
.globl vector66
vector66:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $66
  101f22:	6a 42                	push   $0x42
  jmp __alltraps
  101f24:	e9 25 08 00 00       	jmp    10274e <__alltraps>

00101f29 <vector67>:
.globl vector67
vector67:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $67
  101f2b:	6a 43                	push   $0x43
  jmp __alltraps
  101f2d:	e9 1c 08 00 00       	jmp    10274e <__alltraps>

00101f32 <vector68>:
.globl vector68
vector68:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $68
  101f34:	6a 44                	push   $0x44
  jmp __alltraps
  101f36:	e9 13 08 00 00       	jmp    10274e <__alltraps>

00101f3b <vector69>:
.globl vector69
vector69:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $69
  101f3d:	6a 45                	push   $0x45
  jmp __alltraps
  101f3f:	e9 0a 08 00 00       	jmp    10274e <__alltraps>

00101f44 <vector70>:
.globl vector70
vector70:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $70
  101f46:	6a 46                	push   $0x46
  jmp __alltraps
  101f48:	e9 01 08 00 00       	jmp    10274e <__alltraps>

00101f4d <vector71>:
.globl vector71
vector71:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $71
  101f4f:	6a 47                	push   $0x47
  jmp __alltraps
  101f51:	e9 f8 07 00 00       	jmp    10274e <__alltraps>

00101f56 <vector72>:
.globl vector72
vector72:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $72
  101f58:	6a 48                	push   $0x48
  jmp __alltraps
  101f5a:	e9 ef 07 00 00       	jmp    10274e <__alltraps>

00101f5f <vector73>:
.globl vector73
vector73:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $73
  101f61:	6a 49                	push   $0x49
  jmp __alltraps
  101f63:	e9 e6 07 00 00       	jmp    10274e <__alltraps>

00101f68 <vector74>:
.globl vector74
vector74:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $74
  101f6a:	6a 4a                	push   $0x4a
  jmp __alltraps
  101f6c:	e9 dd 07 00 00       	jmp    10274e <__alltraps>

00101f71 <vector75>:
.globl vector75
vector75:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $75
  101f73:	6a 4b                	push   $0x4b
  jmp __alltraps
  101f75:	e9 d4 07 00 00       	jmp    10274e <__alltraps>

00101f7a <vector76>:
.globl vector76
vector76:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $76
  101f7c:	6a 4c                	push   $0x4c
  jmp __alltraps
  101f7e:	e9 cb 07 00 00       	jmp    10274e <__alltraps>

00101f83 <vector77>:
.globl vector77
vector77:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $77
  101f85:	6a 4d                	push   $0x4d
  jmp __alltraps
  101f87:	e9 c2 07 00 00       	jmp    10274e <__alltraps>

00101f8c <vector78>:
.globl vector78
vector78:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $78
  101f8e:	6a 4e                	push   $0x4e
  jmp __alltraps
  101f90:	e9 b9 07 00 00       	jmp    10274e <__alltraps>

00101f95 <vector79>:
.globl vector79
vector79:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $79
  101f97:	6a 4f                	push   $0x4f
  jmp __alltraps
  101f99:	e9 b0 07 00 00       	jmp    10274e <__alltraps>

00101f9e <vector80>:
.globl vector80
vector80:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $80
  101fa0:	6a 50                	push   $0x50
  jmp __alltraps
  101fa2:	e9 a7 07 00 00       	jmp    10274e <__alltraps>

00101fa7 <vector81>:
.globl vector81
vector81:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $81
  101fa9:	6a 51                	push   $0x51
  jmp __alltraps
  101fab:	e9 9e 07 00 00       	jmp    10274e <__alltraps>

00101fb0 <vector82>:
.globl vector82
vector82:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $82
  101fb2:	6a 52                	push   $0x52
  jmp __alltraps
  101fb4:	e9 95 07 00 00       	jmp    10274e <__alltraps>

00101fb9 <vector83>:
.globl vector83
vector83:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $83
  101fbb:	6a 53                	push   $0x53
  jmp __alltraps
  101fbd:	e9 8c 07 00 00       	jmp    10274e <__alltraps>

00101fc2 <vector84>:
.globl vector84
vector84:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $84
  101fc4:	6a 54                	push   $0x54
  jmp __alltraps
  101fc6:	e9 83 07 00 00       	jmp    10274e <__alltraps>

00101fcb <vector85>:
.globl vector85
vector85:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $85
  101fcd:	6a 55                	push   $0x55
  jmp __alltraps
  101fcf:	e9 7a 07 00 00       	jmp    10274e <__alltraps>

00101fd4 <vector86>:
.globl vector86
vector86:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $86
  101fd6:	6a 56                	push   $0x56
  jmp __alltraps
  101fd8:	e9 71 07 00 00       	jmp    10274e <__alltraps>

00101fdd <vector87>:
.globl vector87
vector87:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $87
  101fdf:	6a 57                	push   $0x57
  jmp __alltraps
  101fe1:	e9 68 07 00 00       	jmp    10274e <__alltraps>

00101fe6 <vector88>:
.globl vector88
vector88:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $88
  101fe8:	6a 58                	push   $0x58
  jmp __alltraps
  101fea:	e9 5f 07 00 00       	jmp    10274e <__alltraps>

00101fef <vector89>:
.globl vector89
vector89:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $89
  101ff1:	6a 59                	push   $0x59
  jmp __alltraps
  101ff3:	e9 56 07 00 00       	jmp    10274e <__alltraps>

00101ff8 <vector90>:
.globl vector90
vector90:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $90
  101ffa:	6a 5a                	push   $0x5a
  jmp __alltraps
  101ffc:	e9 4d 07 00 00       	jmp    10274e <__alltraps>

00102001 <vector91>:
.globl vector91
vector91:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $91
  102003:	6a 5b                	push   $0x5b
  jmp __alltraps
  102005:	e9 44 07 00 00       	jmp    10274e <__alltraps>

0010200a <vector92>:
.globl vector92
vector92:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $92
  10200c:	6a 5c                	push   $0x5c
  jmp __alltraps
  10200e:	e9 3b 07 00 00       	jmp    10274e <__alltraps>

00102013 <vector93>:
.globl vector93
vector93:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $93
  102015:	6a 5d                	push   $0x5d
  jmp __alltraps
  102017:	e9 32 07 00 00       	jmp    10274e <__alltraps>

0010201c <vector94>:
.globl vector94
vector94:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $94
  10201e:	6a 5e                	push   $0x5e
  jmp __alltraps
  102020:	e9 29 07 00 00       	jmp    10274e <__alltraps>

00102025 <vector95>:
.globl vector95
vector95:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $95
  102027:	6a 5f                	push   $0x5f
  jmp __alltraps
  102029:	e9 20 07 00 00       	jmp    10274e <__alltraps>

0010202e <vector96>:
.globl vector96
vector96:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $96
  102030:	6a 60                	push   $0x60
  jmp __alltraps
  102032:	e9 17 07 00 00       	jmp    10274e <__alltraps>

00102037 <vector97>:
.globl vector97
vector97:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $97
  102039:	6a 61                	push   $0x61
  jmp __alltraps
  10203b:	e9 0e 07 00 00       	jmp    10274e <__alltraps>

00102040 <vector98>:
.globl vector98
vector98:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $98
  102042:	6a 62                	push   $0x62
  jmp __alltraps
  102044:	e9 05 07 00 00       	jmp    10274e <__alltraps>

00102049 <vector99>:
.globl vector99
vector99:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $99
  10204b:	6a 63                	push   $0x63
  jmp __alltraps
  10204d:	e9 fc 06 00 00       	jmp    10274e <__alltraps>

00102052 <vector100>:
.globl vector100
vector100:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $100
  102054:	6a 64                	push   $0x64
  jmp __alltraps
  102056:	e9 f3 06 00 00       	jmp    10274e <__alltraps>

0010205b <vector101>:
.globl vector101
vector101:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $101
  10205d:	6a 65                	push   $0x65
  jmp __alltraps
  10205f:	e9 ea 06 00 00       	jmp    10274e <__alltraps>

00102064 <vector102>:
.globl vector102
vector102:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $102
  102066:	6a 66                	push   $0x66
  jmp __alltraps
  102068:	e9 e1 06 00 00       	jmp    10274e <__alltraps>

0010206d <vector103>:
.globl vector103
vector103:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $103
  10206f:	6a 67                	push   $0x67
  jmp __alltraps
  102071:	e9 d8 06 00 00       	jmp    10274e <__alltraps>

00102076 <vector104>:
.globl vector104
vector104:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $104
  102078:	6a 68                	push   $0x68
  jmp __alltraps
  10207a:	e9 cf 06 00 00       	jmp    10274e <__alltraps>

0010207f <vector105>:
.globl vector105
vector105:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $105
  102081:	6a 69                	push   $0x69
  jmp __alltraps
  102083:	e9 c6 06 00 00       	jmp    10274e <__alltraps>

00102088 <vector106>:
.globl vector106
vector106:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $106
  10208a:	6a 6a                	push   $0x6a
  jmp __alltraps
  10208c:	e9 bd 06 00 00       	jmp    10274e <__alltraps>

00102091 <vector107>:
.globl vector107
vector107:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $107
  102093:	6a 6b                	push   $0x6b
  jmp __alltraps
  102095:	e9 b4 06 00 00       	jmp    10274e <__alltraps>

0010209a <vector108>:
.globl vector108
vector108:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $108
  10209c:	6a 6c                	push   $0x6c
  jmp __alltraps
  10209e:	e9 ab 06 00 00       	jmp    10274e <__alltraps>

001020a3 <vector109>:
.globl vector109
vector109:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $109
  1020a5:	6a 6d                	push   $0x6d
  jmp __alltraps
  1020a7:	e9 a2 06 00 00       	jmp    10274e <__alltraps>

001020ac <vector110>:
.globl vector110
vector110:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $110
  1020ae:	6a 6e                	push   $0x6e
  jmp __alltraps
  1020b0:	e9 99 06 00 00       	jmp    10274e <__alltraps>

001020b5 <vector111>:
.globl vector111
vector111:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $111
  1020b7:	6a 6f                	push   $0x6f
  jmp __alltraps
  1020b9:	e9 90 06 00 00       	jmp    10274e <__alltraps>

001020be <vector112>:
.globl vector112
vector112:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $112
  1020c0:	6a 70                	push   $0x70
  jmp __alltraps
  1020c2:	e9 87 06 00 00       	jmp    10274e <__alltraps>

001020c7 <vector113>:
.globl vector113
vector113:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $113
  1020c9:	6a 71                	push   $0x71
  jmp __alltraps
  1020cb:	e9 7e 06 00 00       	jmp    10274e <__alltraps>

001020d0 <vector114>:
.globl vector114
vector114:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $114
  1020d2:	6a 72                	push   $0x72
  jmp __alltraps
  1020d4:	e9 75 06 00 00       	jmp    10274e <__alltraps>

001020d9 <vector115>:
.globl vector115
vector115:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $115
  1020db:	6a 73                	push   $0x73
  jmp __alltraps
  1020dd:	e9 6c 06 00 00       	jmp    10274e <__alltraps>

001020e2 <vector116>:
.globl vector116
vector116:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $116
  1020e4:	6a 74                	push   $0x74
  jmp __alltraps
  1020e6:	e9 63 06 00 00       	jmp    10274e <__alltraps>

001020eb <vector117>:
.globl vector117
vector117:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $117
  1020ed:	6a 75                	push   $0x75
  jmp __alltraps
  1020ef:	e9 5a 06 00 00       	jmp    10274e <__alltraps>

001020f4 <vector118>:
.globl vector118
vector118:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $118
  1020f6:	6a 76                	push   $0x76
  jmp __alltraps
  1020f8:	e9 51 06 00 00       	jmp    10274e <__alltraps>

001020fd <vector119>:
.globl vector119
vector119:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $119
  1020ff:	6a 77                	push   $0x77
  jmp __alltraps
  102101:	e9 48 06 00 00       	jmp    10274e <__alltraps>

00102106 <vector120>:
.globl vector120
vector120:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $120
  102108:	6a 78                	push   $0x78
  jmp __alltraps
  10210a:	e9 3f 06 00 00       	jmp    10274e <__alltraps>

0010210f <vector121>:
.globl vector121
vector121:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $121
  102111:	6a 79                	push   $0x79
  jmp __alltraps
  102113:	e9 36 06 00 00       	jmp    10274e <__alltraps>

00102118 <vector122>:
.globl vector122
vector122:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $122
  10211a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10211c:	e9 2d 06 00 00       	jmp    10274e <__alltraps>

00102121 <vector123>:
.globl vector123
vector123:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $123
  102123:	6a 7b                	push   $0x7b
  jmp __alltraps
  102125:	e9 24 06 00 00       	jmp    10274e <__alltraps>

0010212a <vector124>:
.globl vector124
vector124:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $124
  10212c:	6a 7c                	push   $0x7c
  jmp __alltraps
  10212e:	e9 1b 06 00 00       	jmp    10274e <__alltraps>

00102133 <vector125>:
.globl vector125
vector125:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $125
  102135:	6a 7d                	push   $0x7d
  jmp __alltraps
  102137:	e9 12 06 00 00       	jmp    10274e <__alltraps>

0010213c <vector126>:
.globl vector126
vector126:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $126
  10213e:	6a 7e                	push   $0x7e
  jmp __alltraps
  102140:	e9 09 06 00 00       	jmp    10274e <__alltraps>

00102145 <vector127>:
.globl vector127
vector127:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $127
  102147:	6a 7f                	push   $0x7f
  jmp __alltraps
  102149:	e9 00 06 00 00       	jmp    10274e <__alltraps>

0010214e <vector128>:
.globl vector128
vector128:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $128
  102150:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102155:	e9 f4 05 00 00       	jmp    10274e <__alltraps>

0010215a <vector129>:
.globl vector129
vector129:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $129
  10215c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102161:	e9 e8 05 00 00       	jmp    10274e <__alltraps>

00102166 <vector130>:
.globl vector130
vector130:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $130
  102168:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10216d:	e9 dc 05 00 00       	jmp    10274e <__alltraps>

00102172 <vector131>:
.globl vector131
vector131:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $131
  102174:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102179:	e9 d0 05 00 00       	jmp    10274e <__alltraps>

0010217e <vector132>:
.globl vector132
vector132:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $132
  102180:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102185:	e9 c4 05 00 00       	jmp    10274e <__alltraps>

0010218a <vector133>:
.globl vector133
vector133:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $133
  10218c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102191:	e9 b8 05 00 00       	jmp    10274e <__alltraps>

00102196 <vector134>:
.globl vector134
vector134:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $134
  102198:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10219d:	e9 ac 05 00 00       	jmp    10274e <__alltraps>

001021a2 <vector135>:
.globl vector135
vector135:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $135
  1021a4:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1021a9:	e9 a0 05 00 00       	jmp    10274e <__alltraps>

001021ae <vector136>:
.globl vector136
vector136:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $136
  1021b0:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1021b5:	e9 94 05 00 00       	jmp    10274e <__alltraps>

001021ba <vector137>:
.globl vector137
vector137:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $137
  1021bc:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1021c1:	e9 88 05 00 00       	jmp    10274e <__alltraps>

001021c6 <vector138>:
.globl vector138
vector138:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $138
  1021c8:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1021cd:	e9 7c 05 00 00       	jmp    10274e <__alltraps>

001021d2 <vector139>:
.globl vector139
vector139:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $139
  1021d4:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1021d9:	e9 70 05 00 00       	jmp    10274e <__alltraps>

001021de <vector140>:
.globl vector140
vector140:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $140
  1021e0:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1021e5:	e9 64 05 00 00       	jmp    10274e <__alltraps>

001021ea <vector141>:
.globl vector141
vector141:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $141
  1021ec:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1021f1:	e9 58 05 00 00       	jmp    10274e <__alltraps>

001021f6 <vector142>:
.globl vector142
vector142:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $142
  1021f8:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1021fd:	e9 4c 05 00 00       	jmp    10274e <__alltraps>

00102202 <vector143>:
.globl vector143
vector143:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $143
  102204:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102209:	e9 40 05 00 00       	jmp    10274e <__alltraps>

0010220e <vector144>:
.globl vector144
vector144:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $144
  102210:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102215:	e9 34 05 00 00       	jmp    10274e <__alltraps>

0010221a <vector145>:
.globl vector145
vector145:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $145
  10221c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102221:	e9 28 05 00 00       	jmp    10274e <__alltraps>

00102226 <vector146>:
.globl vector146
vector146:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $146
  102228:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10222d:	e9 1c 05 00 00       	jmp    10274e <__alltraps>

00102232 <vector147>:
.globl vector147
vector147:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $147
  102234:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102239:	e9 10 05 00 00       	jmp    10274e <__alltraps>

0010223e <vector148>:
.globl vector148
vector148:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $148
  102240:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102245:	e9 04 05 00 00       	jmp    10274e <__alltraps>

0010224a <vector149>:
.globl vector149
vector149:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $149
  10224c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102251:	e9 f8 04 00 00       	jmp    10274e <__alltraps>

00102256 <vector150>:
.globl vector150
vector150:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $150
  102258:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10225d:	e9 ec 04 00 00       	jmp    10274e <__alltraps>

00102262 <vector151>:
.globl vector151
vector151:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $151
  102264:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102269:	e9 e0 04 00 00       	jmp    10274e <__alltraps>

0010226e <vector152>:
.globl vector152
vector152:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $152
  102270:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102275:	e9 d4 04 00 00       	jmp    10274e <__alltraps>

0010227a <vector153>:
.globl vector153
vector153:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $153
  10227c:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102281:	e9 c8 04 00 00       	jmp    10274e <__alltraps>

00102286 <vector154>:
.globl vector154
vector154:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $154
  102288:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10228d:	e9 bc 04 00 00       	jmp    10274e <__alltraps>

00102292 <vector155>:
.globl vector155
vector155:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $155
  102294:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102299:	e9 b0 04 00 00       	jmp    10274e <__alltraps>

0010229e <vector156>:
.globl vector156
vector156:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $156
  1022a0:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1022a5:	e9 a4 04 00 00       	jmp    10274e <__alltraps>

001022aa <vector157>:
.globl vector157
vector157:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $157
  1022ac:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1022b1:	e9 98 04 00 00       	jmp    10274e <__alltraps>

001022b6 <vector158>:
.globl vector158
vector158:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $158
  1022b8:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1022bd:	e9 8c 04 00 00       	jmp    10274e <__alltraps>

001022c2 <vector159>:
.globl vector159
vector159:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $159
  1022c4:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1022c9:	e9 80 04 00 00       	jmp    10274e <__alltraps>

001022ce <vector160>:
.globl vector160
vector160:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $160
  1022d0:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1022d5:	e9 74 04 00 00       	jmp    10274e <__alltraps>

001022da <vector161>:
.globl vector161
vector161:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $161
  1022dc:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1022e1:	e9 68 04 00 00       	jmp    10274e <__alltraps>

001022e6 <vector162>:
.globl vector162
vector162:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $162
  1022e8:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1022ed:	e9 5c 04 00 00       	jmp    10274e <__alltraps>

001022f2 <vector163>:
.globl vector163
vector163:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $163
  1022f4:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1022f9:	e9 50 04 00 00       	jmp    10274e <__alltraps>

001022fe <vector164>:
.globl vector164
vector164:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $164
  102300:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102305:	e9 44 04 00 00       	jmp    10274e <__alltraps>

0010230a <vector165>:
.globl vector165
vector165:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $165
  10230c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102311:	e9 38 04 00 00       	jmp    10274e <__alltraps>

00102316 <vector166>:
.globl vector166
vector166:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $166
  102318:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10231d:	e9 2c 04 00 00       	jmp    10274e <__alltraps>

00102322 <vector167>:
.globl vector167
vector167:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $167
  102324:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102329:	e9 20 04 00 00       	jmp    10274e <__alltraps>

0010232e <vector168>:
.globl vector168
vector168:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $168
  102330:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102335:	e9 14 04 00 00       	jmp    10274e <__alltraps>

0010233a <vector169>:
.globl vector169
vector169:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $169
  10233c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102341:	e9 08 04 00 00       	jmp    10274e <__alltraps>

00102346 <vector170>:
.globl vector170
vector170:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $170
  102348:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10234d:	e9 fc 03 00 00       	jmp    10274e <__alltraps>

00102352 <vector171>:
.globl vector171
vector171:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $171
  102354:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102359:	e9 f0 03 00 00       	jmp    10274e <__alltraps>

0010235e <vector172>:
.globl vector172
vector172:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $172
  102360:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102365:	e9 e4 03 00 00       	jmp    10274e <__alltraps>

0010236a <vector173>:
.globl vector173
vector173:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $173
  10236c:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102371:	e9 d8 03 00 00       	jmp    10274e <__alltraps>

00102376 <vector174>:
.globl vector174
vector174:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $174
  102378:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10237d:	e9 cc 03 00 00       	jmp    10274e <__alltraps>

00102382 <vector175>:
.globl vector175
vector175:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $175
  102384:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102389:	e9 c0 03 00 00       	jmp    10274e <__alltraps>

0010238e <vector176>:
.globl vector176
vector176:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $176
  102390:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102395:	e9 b4 03 00 00       	jmp    10274e <__alltraps>

0010239a <vector177>:
.globl vector177
vector177:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $177
  10239c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1023a1:	e9 a8 03 00 00       	jmp    10274e <__alltraps>

001023a6 <vector178>:
.globl vector178
vector178:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $178
  1023a8:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1023ad:	e9 9c 03 00 00       	jmp    10274e <__alltraps>

001023b2 <vector179>:
.globl vector179
vector179:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $179
  1023b4:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1023b9:	e9 90 03 00 00       	jmp    10274e <__alltraps>

001023be <vector180>:
.globl vector180
vector180:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $180
  1023c0:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1023c5:	e9 84 03 00 00       	jmp    10274e <__alltraps>

001023ca <vector181>:
.globl vector181
vector181:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $181
  1023cc:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1023d1:	e9 78 03 00 00       	jmp    10274e <__alltraps>

001023d6 <vector182>:
.globl vector182
vector182:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $182
  1023d8:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1023dd:	e9 6c 03 00 00       	jmp    10274e <__alltraps>

001023e2 <vector183>:
.globl vector183
vector183:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $183
  1023e4:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1023e9:	e9 60 03 00 00       	jmp    10274e <__alltraps>

001023ee <vector184>:
.globl vector184
vector184:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $184
  1023f0:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1023f5:	e9 54 03 00 00       	jmp    10274e <__alltraps>

001023fa <vector185>:
.globl vector185
vector185:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $185
  1023fc:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102401:	e9 48 03 00 00       	jmp    10274e <__alltraps>

00102406 <vector186>:
.globl vector186
vector186:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $186
  102408:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10240d:	e9 3c 03 00 00       	jmp    10274e <__alltraps>

00102412 <vector187>:
.globl vector187
vector187:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $187
  102414:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102419:	e9 30 03 00 00       	jmp    10274e <__alltraps>

0010241e <vector188>:
.globl vector188
vector188:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $188
  102420:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102425:	e9 24 03 00 00       	jmp    10274e <__alltraps>

0010242a <vector189>:
.globl vector189
vector189:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $189
  10242c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102431:	e9 18 03 00 00       	jmp    10274e <__alltraps>

00102436 <vector190>:
.globl vector190
vector190:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $190
  102438:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10243d:	e9 0c 03 00 00       	jmp    10274e <__alltraps>

00102442 <vector191>:
.globl vector191
vector191:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $191
  102444:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102449:	e9 00 03 00 00       	jmp    10274e <__alltraps>

0010244e <vector192>:
.globl vector192
vector192:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $192
  102450:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102455:	e9 f4 02 00 00       	jmp    10274e <__alltraps>

0010245a <vector193>:
.globl vector193
vector193:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $193
  10245c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102461:	e9 e8 02 00 00       	jmp    10274e <__alltraps>

00102466 <vector194>:
.globl vector194
vector194:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $194
  102468:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10246d:	e9 dc 02 00 00       	jmp    10274e <__alltraps>

00102472 <vector195>:
.globl vector195
vector195:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $195
  102474:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102479:	e9 d0 02 00 00       	jmp    10274e <__alltraps>

0010247e <vector196>:
.globl vector196
vector196:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $196
  102480:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102485:	e9 c4 02 00 00       	jmp    10274e <__alltraps>

0010248a <vector197>:
.globl vector197
vector197:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $197
  10248c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102491:	e9 b8 02 00 00       	jmp    10274e <__alltraps>

00102496 <vector198>:
.globl vector198
vector198:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $198
  102498:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10249d:	e9 ac 02 00 00       	jmp    10274e <__alltraps>

001024a2 <vector199>:
.globl vector199
vector199:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $199
  1024a4:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1024a9:	e9 a0 02 00 00       	jmp    10274e <__alltraps>

001024ae <vector200>:
.globl vector200
vector200:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $200
  1024b0:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1024b5:	e9 94 02 00 00       	jmp    10274e <__alltraps>

001024ba <vector201>:
.globl vector201
vector201:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $201
  1024bc:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1024c1:	e9 88 02 00 00       	jmp    10274e <__alltraps>

001024c6 <vector202>:
.globl vector202
vector202:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $202
  1024c8:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1024cd:	e9 7c 02 00 00       	jmp    10274e <__alltraps>

001024d2 <vector203>:
.globl vector203
vector203:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $203
  1024d4:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1024d9:	e9 70 02 00 00       	jmp    10274e <__alltraps>

001024de <vector204>:
.globl vector204
vector204:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $204
  1024e0:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1024e5:	e9 64 02 00 00       	jmp    10274e <__alltraps>

001024ea <vector205>:
.globl vector205
vector205:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $205
  1024ec:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1024f1:	e9 58 02 00 00       	jmp    10274e <__alltraps>

001024f6 <vector206>:
.globl vector206
vector206:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $206
  1024f8:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1024fd:	e9 4c 02 00 00       	jmp    10274e <__alltraps>

00102502 <vector207>:
.globl vector207
vector207:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $207
  102504:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102509:	e9 40 02 00 00       	jmp    10274e <__alltraps>

0010250e <vector208>:
.globl vector208
vector208:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $208
  102510:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102515:	e9 34 02 00 00       	jmp    10274e <__alltraps>

0010251a <vector209>:
.globl vector209
vector209:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $209
  10251c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102521:	e9 28 02 00 00       	jmp    10274e <__alltraps>

00102526 <vector210>:
.globl vector210
vector210:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $210
  102528:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10252d:	e9 1c 02 00 00       	jmp    10274e <__alltraps>

00102532 <vector211>:
.globl vector211
vector211:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $211
  102534:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102539:	e9 10 02 00 00       	jmp    10274e <__alltraps>

0010253e <vector212>:
.globl vector212
vector212:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $212
  102540:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102545:	e9 04 02 00 00       	jmp    10274e <__alltraps>

0010254a <vector213>:
.globl vector213
vector213:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $213
  10254c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102551:	e9 f8 01 00 00       	jmp    10274e <__alltraps>

00102556 <vector214>:
.globl vector214
vector214:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $214
  102558:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10255d:	e9 ec 01 00 00       	jmp    10274e <__alltraps>

00102562 <vector215>:
.globl vector215
vector215:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $215
  102564:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102569:	e9 e0 01 00 00       	jmp    10274e <__alltraps>

0010256e <vector216>:
.globl vector216
vector216:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $216
  102570:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102575:	e9 d4 01 00 00       	jmp    10274e <__alltraps>

0010257a <vector217>:
.globl vector217
vector217:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $217
  10257c:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102581:	e9 c8 01 00 00       	jmp    10274e <__alltraps>

00102586 <vector218>:
.globl vector218
vector218:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $218
  102588:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10258d:	e9 bc 01 00 00       	jmp    10274e <__alltraps>

00102592 <vector219>:
.globl vector219
vector219:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $219
  102594:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102599:	e9 b0 01 00 00       	jmp    10274e <__alltraps>

0010259e <vector220>:
.globl vector220
vector220:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $220
  1025a0:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1025a5:	e9 a4 01 00 00       	jmp    10274e <__alltraps>

001025aa <vector221>:
.globl vector221
vector221:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $221
  1025ac:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1025b1:	e9 98 01 00 00       	jmp    10274e <__alltraps>

001025b6 <vector222>:
.globl vector222
vector222:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $222
  1025b8:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1025bd:	e9 8c 01 00 00       	jmp    10274e <__alltraps>

001025c2 <vector223>:
.globl vector223
vector223:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $223
  1025c4:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1025c9:	e9 80 01 00 00       	jmp    10274e <__alltraps>

001025ce <vector224>:
.globl vector224
vector224:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $224
  1025d0:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1025d5:	e9 74 01 00 00       	jmp    10274e <__alltraps>

001025da <vector225>:
.globl vector225
vector225:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $225
  1025dc:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1025e1:	e9 68 01 00 00       	jmp    10274e <__alltraps>

001025e6 <vector226>:
.globl vector226
vector226:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $226
  1025e8:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1025ed:	e9 5c 01 00 00       	jmp    10274e <__alltraps>

001025f2 <vector227>:
.globl vector227
vector227:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $227
  1025f4:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1025f9:	e9 50 01 00 00       	jmp    10274e <__alltraps>

001025fe <vector228>:
.globl vector228
vector228:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $228
  102600:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102605:	e9 44 01 00 00       	jmp    10274e <__alltraps>

0010260a <vector229>:
.globl vector229
vector229:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $229
  10260c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102611:	e9 38 01 00 00       	jmp    10274e <__alltraps>

00102616 <vector230>:
.globl vector230
vector230:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $230
  102618:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10261d:	e9 2c 01 00 00       	jmp    10274e <__alltraps>

00102622 <vector231>:
.globl vector231
vector231:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $231
  102624:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102629:	e9 20 01 00 00       	jmp    10274e <__alltraps>

0010262e <vector232>:
.globl vector232
vector232:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $232
  102630:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102635:	e9 14 01 00 00       	jmp    10274e <__alltraps>

0010263a <vector233>:
.globl vector233
vector233:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $233
  10263c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102641:	e9 08 01 00 00       	jmp    10274e <__alltraps>

00102646 <vector234>:
.globl vector234
vector234:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $234
  102648:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10264d:	e9 fc 00 00 00       	jmp    10274e <__alltraps>

00102652 <vector235>:
.globl vector235
vector235:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $235
  102654:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102659:	e9 f0 00 00 00       	jmp    10274e <__alltraps>

0010265e <vector236>:
.globl vector236
vector236:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $236
  102660:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102665:	e9 e4 00 00 00       	jmp    10274e <__alltraps>

0010266a <vector237>:
.globl vector237
vector237:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $237
  10266c:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102671:	e9 d8 00 00 00       	jmp    10274e <__alltraps>

00102676 <vector238>:
.globl vector238
vector238:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $238
  102678:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10267d:	e9 cc 00 00 00       	jmp    10274e <__alltraps>

00102682 <vector239>:
.globl vector239
vector239:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $239
  102684:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102689:	e9 c0 00 00 00       	jmp    10274e <__alltraps>

0010268e <vector240>:
.globl vector240
vector240:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $240
  102690:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102695:	e9 b4 00 00 00       	jmp    10274e <__alltraps>

0010269a <vector241>:
.globl vector241
vector241:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $241
  10269c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1026a1:	e9 a8 00 00 00       	jmp    10274e <__alltraps>

001026a6 <vector242>:
.globl vector242
vector242:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $242
  1026a8:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1026ad:	e9 9c 00 00 00       	jmp    10274e <__alltraps>

001026b2 <vector243>:
.globl vector243
vector243:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $243
  1026b4:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1026b9:	e9 90 00 00 00       	jmp    10274e <__alltraps>

001026be <vector244>:
.globl vector244
vector244:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $244
  1026c0:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1026c5:	e9 84 00 00 00       	jmp    10274e <__alltraps>

001026ca <vector245>:
.globl vector245
vector245:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $245
  1026cc:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1026d1:	e9 78 00 00 00       	jmp    10274e <__alltraps>

001026d6 <vector246>:
.globl vector246
vector246:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $246
  1026d8:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1026dd:	e9 6c 00 00 00       	jmp    10274e <__alltraps>

001026e2 <vector247>:
.globl vector247
vector247:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $247
  1026e4:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1026e9:	e9 60 00 00 00       	jmp    10274e <__alltraps>

001026ee <vector248>:
.globl vector248
vector248:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $248
  1026f0:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1026f5:	e9 54 00 00 00       	jmp    10274e <__alltraps>

001026fa <vector249>:
.globl vector249
vector249:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $249
  1026fc:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102701:	e9 48 00 00 00       	jmp    10274e <__alltraps>

00102706 <vector250>:
.globl vector250
vector250:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $250
  102708:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10270d:	e9 3c 00 00 00       	jmp    10274e <__alltraps>

00102712 <vector251>:
.globl vector251
vector251:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $251
  102714:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102719:	e9 30 00 00 00       	jmp    10274e <__alltraps>

0010271e <vector252>:
.globl vector252
vector252:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $252
  102720:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102725:	e9 24 00 00 00       	jmp    10274e <__alltraps>

0010272a <vector253>:
.globl vector253
vector253:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $253
  10272c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102731:	e9 18 00 00 00       	jmp    10274e <__alltraps>

00102736 <vector254>:
.globl vector254
vector254:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $254
  102738:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10273d:	e9 0c 00 00 00       	jmp    10274e <__alltraps>

00102742 <vector255>:
.globl vector255
vector255:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $255
  102744:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102749:	e9 00 00 00 00       	jmp    10274e <__alltraps>

0010274e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10274e:	1e                   	push   %ds
    pushl %es
  10274f:	06                   	push   %es
    pushl %fs
  102750:	0f a0                	push   %fs
    pushl %gs
  102752:	0f a8                	push   %gs
    pushal
  102754:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102755:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10275a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10275c:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10275e:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10275f:	e8 64 f5 ff ff       	call   101cc8 <trap>

    # pop the pushed stack pointer
    popl %esp
  102764:	5c                   	pop    %esp

00102765 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102765:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102766:	0f a9                	pop    %gs
    popl %fs
  102768:	0f a1                	pop    %fs
    popl %es
  10276a:	07                   	pop    %es
    popl %ds
  10276b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10276c:	83 c4 08             	add    $0x8,%esp
    iret
  10276f:	cf                   	iret   

00102770 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102770:	55                   	push   %ebp
  102771:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102773:	8b 45 08             	mov    0x8(%ebp),%eax
  102776:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102779:	b8 23 00 00 00       	mov    $0x23,%eax
  10277e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102780:	b8 23 00 00 00       	mov    $0x23,%eax
  102785:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102787:	b8 10 00 00 00       	mov    $0x10,%eax
  10278c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10278e:	b8 10 00 00 00       	mov    $0x10,%eax
  102793:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102795:	b8 10 00 00 00       	mov    $0x10,%eax
  10279a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10279c:	ea a3 27 10 00 08 00 	ljmp   $0x8,$0x1027a3
}
  1027a3:	90                   	nop
  1027a4:	5d                   	pop    %ebp
  1027a5:	c3                   	ret    

001027a6 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1027a6:	55                   	push   %ebp
  1027a7:	89 e5                	mov    %esp,%ebp
  1027a9:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1027ac:	b8 40 f9 10 00       	mov    $0x10f940,%eax
  1027b1:	05 00 04 00 00       	add    $0x400,%eax
  1027b6:	a3 c4 f8 10 00       	mov    %eax,0x10f8c4
    ts.ts_ss0 = KERNEL_DS;
  1027bb:	66 c7 05 c8 f8 10 00 	movw   $0x10,0x10f8c8
  1027c2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1027c4:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1027cb:	68 00 
  1027cd:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  1027d2:	0f b7 c0             	movzwl %ax,%eax
  1027d5:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1027db:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  1027e0:	c1 e8 10             	shr    $0x10,%eax
  1027e3:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1027e8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1027ef:	24 f0                	and    $0xf0,%al
  1027f1:	0c 09                	or     $0x9,%al
  1027f3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1027f8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1027ff:	0c 10                	or     $0x10,%al
  102801:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102806:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10280d:	24 9f                	and    $0x9f,%al
  10280f:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102814:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10281b:	0c 80                	or     $0x80,%al
  10281d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102822:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102829:	24 f0                	and    $0xf0,%al
  10282b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102830:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102837:	24 ef                	and    $0xef,%al
  102839:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10283e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102845:	24 df                	and    $0xdf,%al
  102847:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10284c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102853:	0c 40                	or     $0x40,%al
  102855:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10285a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102861:	24 7f                	and    $0x7f,%al
  102863:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102868:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  10286d:	c1 e8 18             	shr    $0x18,%eax
  102870:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102875:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10287c:	24 ef                	and    $0xef,%al
  10287e:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102883:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10288a:	e8 e1 fe ff ff       	call   102770 <lgdt>
  10288f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102895:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102899:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10289c:	90                   	nop
  10289d:	c9                   	leave  
  10289e:	c3                   	ret    

0010289f <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10289f:	55                   	push   %ebp
  1028a0:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1028a2:	e8 ff fe ff ff       	call   1027a6 <gdt_init>
}
  1028a7:	90                   	nop
  1028a8:	5d                   	pop    %ebp
  1028a9:	c3                   	ret    

001028aa <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1028aa:	55                   	push   %ebp
  1028ab:	89 e5                	mov    %esp,%ebp
  1028ad:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1028b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1028b7:	eb 03                	jmp    1028bc <strlen+0x12>
        cnt ++;
  1028b9:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1028bf:	8d 50 01             	lea    0x1(%eax),%edx
  1028c2:	89 55 08             	mov    %edx,0x8(%ebp)
  1028c5:	0f b6 00             	movzbl (%eax),%eax
  1028c8:	84 c0                	test   %al,%al
  1028ca:	75 ed                	jne    1028b9 <strlen+0xf>
    }
    return cnt;
  1028cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1028cf:	c9                   	leave  
  1028d0:	c3                   	ret    

001028d1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1028d1:	55                   	push   %ebp
  1028d2:	89 e5                	mov    %esp,%ebp
  1028d4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1028d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1028de:	eb 03                	jmp    1028e3 <strnlen+0x12>
        cnt ++;
  1028e0:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1028e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1028e9:	73 10                	jae    1028fb <strnlen+0x2a>
  1028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ee:	8d 50 01             	lea    0x1(%eax),%edx
  1028f1:	89 55 08             	mov    %edx,0x8(%ebp)
  1028f4:	0f b6 00             	movzbl (%eax),%eax
  1028f7:	84 c0                	test   %al,%al
  1028f9:	75 e5                	jne    1028e0 <strnlen+0xf>
    }
    return cnt;
  1028fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1028fe:	c9                   	leave  
  1028ff:	c3                   	ret    

00102900 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102900:	55                   	push   %ebp
  102901:	89 e5                	mov    %esp,%ebp
  102903:	57                   	push   %edi
  102904:	56                   	push   %esi
  102905:	83 ec 20             	sub    $0x20,%esp
  102908:	8b 45 08             	mov    0x8(%ebp),%eax
  10290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10290e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102911:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102914:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10291a:	89 d1                	mov    %edx,%ecx
  10291c:	89 c2                	mov    %eax,%edx
  10291e:	89 ce                	mov    %ecx,%esi
  102920:	89 d7                	mov    %edx,%edi
  102922:	ac                   	lods   %ds:(%esi),%al
  102923:	aa                   	stos   %al,%es:(%edi)
  102924:	84 c0                	test   %al,%al
  102926:	75 fa                	jne    102922 <strcpy+0x22>
  102928:	89 fa                	mov    %edi,%edx
  10292a:	89 f1                	mov    %esi,%ecx
  10292c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10292f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102932:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102935:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102938:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102939:	83 c4 20             	add    $0x20,%esp
  10293c:	5e                   	pop    %esi
  10293d:	5f                   	pop    %edi
  10293e:	5d                   	pop    %ebp
  10293f:	c3                   	ret    

00102940 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102940:	55                   	push   %ebp
  102941:	89 e5                	mov    %esp,%ebp
  102943:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102946:	8b 45 08             	mov    0x8(%ebp),%eax
  102949:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10294c:	eb 1e                	jmp    10296c <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  10294e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102951:	0f b6 10             	movzbl (%eax),%edx
  102954:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102957:	88 10                	mov    %dl,(%eax)
  102959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10295c:	0f b6 00             	movzbl (%eax),%eax
  10295f:	84 c0                	test   %al,%al
  102961:	74 03                	je     102966 <strncpy+0x26>
            src ++;
  102963:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102966:	ff 45 fc             	incl   -0x4(%ebp)
  102969:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  10296c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102970:	75 dc                	jne    10294e <strncpy+0xe>
    }
    return dst;
  102972:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102975:	c9                   	leave  
  102976:	c3                   	ret    

00102977 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102977:	55                   	push   %ebp
  102978:	89 e5                	mov    %esp,%ebp
  10297a:	57                   	push   %edi
  10297b:	56                   	push   %esi
  10297c:	83 ec 20             	sub    $0x20,%esp
  10297f:	8b 45 08             	mov    0x8(%ebp),%eax
  102982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102985:	8b 45 0c             	mov    0xc(%ebp),%eax
  102988:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10298b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10298e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102991:	89 d1                	mov    %edx,%ecx
  102993:	89 c2                	mov    %eax,%edx
  102995:	89 ce                	mov    %ecx,%esi
  102997:	89 d7                	mov    %edx,%edi
  102999:	ac                   	lods   %ds:(%esi),%al
  10299a:	ae                   	scas   %es:(%edi),%al
  10299b:	75 08                	jne    1029a5 <strcmp+0x2e>
  10299d:	84 c0                	test   %al,%al
  10299f:	75 f8                	jne    102999 <strcmp+0x22>
  1029a1:	31 c0                	xor    %eax,%eax
  1029a3:	eb 04                	jmp    1029a9 <strcmp+0x32>
  1029a5:	19 c0                	sbb    %eax,%eax
  1029a7:	0c 01                	or     $0x1,%al
  1029a9:	89 fa                	mov    %edi,%edx
  1029ab:	89 f1                	mov    %esi,%ecx
  1029ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1029b0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1029b3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1029b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1029b9:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1029ba:	83 c4 20             	add    $0x20,%esp
  1029bd:	5e                   	pop    %esi
  1029be:	5f                   	pop    %edi
  1029bf:	5d                   	pop    %ebp
  1029c0:	c3                   	ret    

001029c1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1029c1:	55                   	push   %ebp
  1029c2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1029c4:	eb 09                	jmp    1029cf <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1029c6:	ff 4d 10             	decl   0x10(%ebp)
  1029c9:	ff 45 08             	incl   0x8(%ebp)
  1029cc:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1029cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029d3:	74 1a                	je     1029ef <strncmp+0x2e>
  1029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d8:	0f b6 00             	movzbl (%eax),%eax
  1029db:	84 c0                	test   %al,%al
  1029dd:	74 10                	je     1029ef <strncmp+0x2e>
  1029df:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e2:	0f b6 10             	movzbl (%eax),%edx
  1029e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029e8:	0f b6 00             	movzbl (%eax),%eax
  1029eb:	38 c2                	cmp    %al,%dl
  1029ed:	74 d7                	je     1029c6 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1029ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029f3:	74 18                	je     102a0d <strncmp+0x4c>
  1029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f8:	0f b6 00             	movzbl (%eax),%eax
  1029fb:	0f b6 d0             	movzbl %al,%edx
  1029fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a01:	0f b6 00             	movzbl (%eax),%eax
  102a04:	0f b6 c0             	movzbl %al,%eax
  102a07:	29 c2                	sub    %eax,%edx
  102a09:	89 d0                	mov    %edx,%eax
  102a0b:	eb 05                	jmp    102a12 <strncmp+0x51>
  102a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a12:	5d                   	pop    %ebp
  102a13:	c3                   	ret    

00102a14 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102a14:	55                   	push   %ebp
  102a15:	89 e5                	mov    %esp,%ebp
  102a17:	83 ec 04             	sub    $0x4,%esp
  102a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a1d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102a20:	eb 13                	jmp    102a35 <strchr+0x21>
        if (*s == c) {
  102a22:	8b 45 08             	mov    0x8(%ebp),%eax
  102a25:	0f b6 00             	movzbl (%eax),%eax
  102a28:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102a2b:	75 05                	jne    102a32 <strchr+0x1e>
            return (char *)s;
  102a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a30:	eb 12                	jmp    102a44 <strchr+0x30>
        }
        s ++;
  102a32:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102a35:	8b 45 08             	mov    0x8(%ebp),%eax
  102a38:	0f b6 00             	movzbl (%eax),%eax
  102a3b:	84 c0                	test   %al,%al
  102a3d:	75 e3                	jne    102a22 <strchr+0xe>
    }
    return NULL;
  102a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a44:	c9                   	leave  
  102a45:	c3                   	ret    

00102a46 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102a46:	55                   	push   %ebp
  102a47:	89 e5                	mov    %esp,%ebp
  102a49:	83 ec 04             	sub    $0x4,%esp
  102a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a4f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102a52:	eb 0e                	jmp    102a62 <strfind+0x1c>
        if (*s == c) {
  102a54:	8b 45 08             	mov    0x8(%ebp),%eax
  102a57:	0f b6 00             	movzbl (%eax),%eax
  102a5a:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102a5d:	74 0f                	je     102a6e <strfind+0x28>
            break;
        }
        s ++;
  102a5f:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102a62:	8b 45 08             	mov    0x8(%ebp),%eax
  102a65:	0f b6 00             	movzbl (%eax),%eax
  102a68:	84 c0                	test   %al,%al
  102a6a:	75 e8                	jne    102a54 <strfind+0xe>
  102a6c:	eb 01                	jmp    102a6f <strfind+0x29>
            break;
  102a6e:	90                   	nop
    }
    return (char *)s;
  102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102a72:	c9                   	leave  
  102a73:	c3                   	ret    

00102a74 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102a74:	55                   	push   %ebp
  102a75:	89 e5                	mov    %esp,%ebp
  102a77:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102a7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102a81:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102a88:	eb 03                	jmp    102a8d <strtol+0x19>
        s ++;
  102a8a:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a90:	0f b6 00             	movzbl (%eax),%eax
  102a93:	3c 20                	cmp    $0x20,%al
  102a95:	74 f3                	je     102a8a <strtol+0x16>
  102a97:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9a:	0f b6 00             	movzbl (%eax),%eax
  102a9d:	3c 09                	cmp    $0x9,%al
  102a9f:	74 e9                	je     102a8a <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa4:	0f b6 00             	movzbl (%eax),%eax
  102aa7:	3c 2b                	cmp    $0x2b,%al
  102aa9:	75 05                	jne    102ab0 <strtol+0x3c>
        s ++;
  102aab:	ff 45 08             	incl   0x8(%ebp)
  102aae:	eb 14                	jmp    102ac4 <strtol+0x50>
    }
    else if (*s == '-') {
  102ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab3:	0f b6 00             	movzbl (%eax),%eax
  102ab6:	3c 2d                	cmp    $0x2d,%al
  102ab8:	75 0a                	jne    102ac4 <strtol+0x50>
        s ++, neg = 1;
  102aba:	ff 45 08             	incl   0x8(%ebp)
  102abd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102ac4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ac8:	74 06                	je     102ad0 <strtol+0x5c>
  102aca:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102ace:	75 22                	jne    102af2 <strtol+0x7e>
  102ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad3:	0f b6 00             	movzbl (%eax),%eax
  102ad6:	3c 30                	cmp    $0x30,%al
  102ad8:	75 18                	jne    102af2 <strtol+0x7e>
  102ada:	8b 45 08             	mov    0x8(%ebp),%eax
  102add:	40                   	inc    %eax
  102ade:	0f b6 00             	movzbl (%eax),%eax
  102ae1:	3c 78                	cmp    $0x78,%al
  102ae3:	75 0d                	jne    102af2 <strtol+0x7e>
        s += 2, base = 16;
  102ae5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ae9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102af0:	eb 29                	jmp    102b1b <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  102af2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102af6:	75 16                	jne    102b0e <strtol+0x9a>
  102af8:	8b 45 08             	mov    0x8(%ebp),%eax
  102afb:	0f b6 00             	movzbl (%eax),%eax
  102afe:	3c 30                	cmp    $0x30,%al
  102b00:	75 0c                	jne    102b0e <strtol+0x9a>
        s ++, base = 8;
  102b02:	ff 45 08             	incl   0x8(%ebp)
  102b05:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102b0c:	eb 0d                	jmp    102b1b <strtol+0xa7>
    }
    else if (base == 0) {
  102b0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b12:	75 07                	jne    102b1b <strtol+0xa7>
        base = 10;
  102b14:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1e:	0f b6 00             	movzbl (%eax),%eax
  102b21:	3c 2f                	cmp    $0x2f,%al
  102b23:	7e 1b                	jle    102b40 <strtol+0xcc>
  102b25:	8b 45 08             	mov    0x8(%ebp),%eax
  102b28:	0f b6 00             	movzbl (%eax),%eax
  102b2b:	3c 39                	cmp    $0x39,%al
  102b2d:	7f 11                	jg     102b40 <strtol+0xcc>
            dig = *s - '0';
  102b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b32:	0f b6 00             	movzbl (%eax),%eax
  102b35:	0f be c0             	movsbl %al,%eax
  102b38:	83 e8 30             	sub    $0x30,%eax
  102b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b3e:	eb 48                	jmp    102b88 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102b40:	8b 45 08             	mov    0x8(%ebp),%eax
  102b43:	0f b6 00             	movzbl (%eax),%eax
  102b46:	3c 60                	cmp    $0x60,%al
  102b48:	7e 1b                	jle    102b65 <strtol+0xf1>
  102b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4d:	0f b6 00             	movzbl (%eax),%eax
  102b50:	3c 7a                	cmp    $0x7a,%al
  102b52:	7f 11                	jg     102b65 <strtol+0xf1>
            dig = *s - 'a' + 10;
  102b54:	8b 45 08             	mov    0x8(%ebp),%eax
  102b57:	0f b6 00             	movzbl (%eax),%eax
  102b5a:	0f be c0             	movsbl %al,%eax
  102b5d:	83 e8 57             	sub    $0x57,%eax
  102b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b63:	eb 23                	jmp    102b88 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102b65:	8b 45 08             	mov    0x8(%ebp),%eax
  102b68:	0f b6 00             	movzbl (%eax),%eax
  102b6b:	3c 40                	cmp    $0x40,%al
  102b6d:	7e 3b                	jle    102baa <strtol+0x136>
  102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b72:	0f b6 00             	movzbl (%eax),%eax
  102b75:	3c 5a                	cmp    $0x5a,%al
  102b77:	7f 31                	jg     102baa <strtol+0x136>
            dig = *s - 'A' + 10;
  102b79:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7c:	0f b6 00             	movzbl (%eax),%eax
  102b7f:	0f be c0             	movsbl %al,%eax
  102b82:	83 e8 37             	sub    $0x37,%eax
  102b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  102b8e:	7d 19                	jge    102ba9 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  102b90:	ff 45 08             	incl   0x8(%ebp)
  102b93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102b96:	0f af 45 10          	imul   0x10(%ebp),%eax
  102b9a:	89 c2                	mov    %eax,%edx
  102b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b9f:	01 d0                	add    %edx,%eax
  102ba1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102ba4:	e9 72 ff ff ff       	jmp    102b1b <strtol+0xa7>
            break;
  102ba9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102baa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bae:	74 08                	je     102bb8 <strtol+0x144>
        *endptr = (char *) s;
  102bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb3:	8b 55 08             	mov    0x8(%ebp),%edx
  102bb6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102bbc:	74 07                	je     102bc5 <strtol+0x151>
  102bbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102bc1:	f7 d8                	neg    %eax
  102bc3:	eb 03                	jmp    102bc8 <strtol+0x154>
  102bc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102bc8:	c9                   	leave  
  102bc9:	c3                   	ret    

00102bca <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102bca:	55                   	push   %ebp
  102bcb:	89 e5                	mov    %esp,%ebp
  102bcd:	57                   	push   %edi
  102bce:	83 ec 24             	sub    $0x24,%esp
  102bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bd4:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102bd7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  102bde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102be1:	88 45 f7             	mov    %al,-0x9(%ebp)
  102be4:	8b 45 10             	mov    0x10(%ebp),%eax
  102be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102bea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102bed:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102bf1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102bf4:	89 d7                	mov    %edx,%edi
  102bf6:	f3 aa                	rep stos %al,%es:(%edi)
  102bf8:	89 fa                	mov    %edi,%edx
  102bfa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102bfd:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102c00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c03:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102c04:	83 c4 24             	add    $0x24,%esp
  102c07:	5f                   	pop    %edi
  102c08:	5d                   	pop    %ebp
  102c09:	c3                   	ret    

00102c0a <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102c0a:	55                   	push   %ebp
  102c0b:	89 e5                	mov    %esp,%ebp
  102c0d:	57                   	push   %edi
  102c0e:	56                   	push   %esi
  102c0f:	53                   	push   %ebx
  102c10:	83 ec 30             	sub    $0x30,%esp
  102c13:	8b 45 08             	mov    0x8(%ebp),%eax
  102c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  102c22:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102c2b:	73 42                	jae    102c6f <memmove+0x65>
  102c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c36:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c3c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c42:	c1 e8 02             	shr    $0x2,%eax
  102c45:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c4d:	89 d7                	mov    %edx,%edi
  102c4f:	89 c6                	mov    %eax,%esi
  102c51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102c53:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102c56:	83 e1 03             	and    $0x3,%ecx
  102c59:	74 02                	je     102c5d <memmove+0x53>
  102c5b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c5d:	89 f0                	mov    %esi,%eax
  102c5f:	89 fa                	mov    %edi,%edx
  102c61:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102c64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c67:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102c6d:	eb 36                	jmp    102ca5 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c72:	8d 50 ff             	lea    -0x1(%eax),%edx
  102c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c78:	01 c2                	add    %eax,%edx
  102c7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c7d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c83:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c89:	89 c1                	mov    %eax,%ecx
  102c8b:	89 d8                	mov    %ebx,%eax
  102c8d:	89 d6                	mov    %edx,%esi
  102c8f:	89 c7                	mov    %eax,%edi
  102c91:	fd                   	std    
  102c92:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102c94:	fc                   	cld    
  102c95:	89 f8                	mov    %edi,%eax
  102c97:	89 f2                	mov    %esi,%edx
  102c99:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102c9c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102c9f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102ca5:	83 c4 30             	add    $0x30,%esp
  102ca8:	5b                   	pop    %ebx
  102ca9:	5e                   	pop    %esi
  102caa:	5f                   	pop    %edi
  102cab:	5d                   	pop    %ebp
  102cac:	c3                   	ret    

00102cad <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102cad:	55                   	push   %ebp
  102cae:	89 e5                	mov    %esp,%ebp
  102cb0:	57                   	push   %edi
  102cb1:	56                   	push   %esi
  102cb2:	83 ec 20             	sub    $0x20,%esp
  102cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  102cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cca:	c1 e8 02             	shr    $0x2,%eax
  102ccd:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cd5:	89 d7                	mov    %edx,%edi
  102cd7:	89 c6                	mov    %eax,%esi
  102cd9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102cdb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102cde:	83 e1 03             	and    $0x3,%ecx
  102ce1:	74 02                	je     102ce5 <memcpy+0x38>
  102ce3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ce5:	89 f0                	mov    %esi,%eax
  102ce7:	89 fa                	mov    %edi,%edx
  102ce9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102cec:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102cf5:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102cf6:	83 c4 20             	add    $0x20,%esp
  102cf9:	5e                   	pop    %esi
  102cfa:	5f                   	pop    %edi
  102cfb:	5d                   	pop    %ebp
  102cfc:	c3                   	ret    

00102cfd <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102cfd:	55                   	push   %ebp
  102cfe:	89 e5                	mov    %esp,%ebp
  102d00:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
  102d06:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102d0f:	eb 2e                	jmp    102d3f <memcmp+0x42>
        if (*s1 != *s2) {
  102d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d14:	0f b6 10             	movzbl (%eax),%edx
  102d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d1a:	0f b6 00             	movzbl (%eax),%eax
  102d1d:	38 c2                	cmp    %al,%dl
  102d1f:	74 18                	je     102d39 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d24:	0f b6 00             	movzbl (%eax),%eax
  102d27:	0f b6 d0             	movzbl %al,%edx
  102d2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d2d:	0f b6 00             	movzbl (%eax),%eax
  102d30:	0f b6 c0             	movzbl %al,%eax
  102d33:	29 c2                	sub    %eax,%edx
  102d35:	89 d0                	mov    %edx,%eax
  102d37:	eb 18                	jmp    102d51 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  102d39:	ff 45 fc             	incl   -0x4(%ebp)
  102d3c:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  102d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  102d42:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d45:	89 55 10             	mov    %edx,0x10(%ebp)
  102d48:	85 c0                	test   %eax,%eax
  102d4a:	75 c5                	jne    102d11 <memcmp+0x14>
    }
    return 0;
  102d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d51:	c9                   	leave  
  102d52:	c3                   	ret    

00102d53 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102d53:	55                   	push   %ebp
  102d54:	89 e5                	mov    %esp,%ebp
  102d56:	83 ec 58             	sub    $0x58,%esp
  102d59:	8b 45 10             	mov    0x10(%ebp),%eax
  102d5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102d5f:	8b 45 14             	mov    0x14(%ebp),%eax
  102d62:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102d65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d6e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102d71:	8b 45 18             	mov    0x18(%ebp),%eax
  102d74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d80:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102d8d:	74 1c                	je     102dab <printnum+0x58>
  102d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d92:	ba 00 00 00 00       	mov    $0x0,%edx
  102d97:	f7 75 e4             	divl   -0x1c(%ebp)
  102d9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da0:	ba 00 00 00 00       	mov    $0x0,%edx
  102da5:	f7 75 e4             	divl   -0x1c(%ebp)
  102da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102db1:	f7 75 e4             	divl   -0x1c(%ebp)
  102db4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102db7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102dba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102dc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102dc3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102dc9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102dcc:	8b 45 18             	mov    0x18(%ebp),%eax
  102dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  102dd4:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102dd7:	72 56                	jb     102e2f <printnum+0xdc>
  102dd9:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102ddc:	77 05                	ja     102de3 <printnum+0x90>
  102dde:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102de1:	72 4c                	jb     102e2f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102de3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102de6:	8d 50 ff             	lea    -0x1(%eax),%edx
  102de9:	8b 45 20             	mov    0x20(%ebp),%eax
  102dec:	89 44 24 18          	mov    %eax,0x18(%esp)
  102df0:	89 54 24 14          	mov    %edx,0x14(%esp)
  102df4:	8b 45 18             	mov    0x18(%ebp),%eax
  102df7:	89 44 24 10          	mov    %eax,0x10(%esp)
  102dfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e01:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e05:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e10:	8b 45 08             	mov    0x8(%ebp),%eax
  102e13:	89 04 24             	mov    %eax,(%esp)
  102e16:	e8 38 ff ff ff       	call   102d53 <printnum>
  102e1b:	eb 1b                	jmp    102e38 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e24:	8b 45 20             	mov    0x20(%ebp),%eax
  102e27:	89 04 24             	mov    %eax,(%esp)
  102e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2d:	ff d0                	call   *%eax
        while (-- width > 0)
  102e2f:	ff 4d 1c             	decl   0x1c(%ebp)
  102e32:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102e36:	7f e5                	jg     102e1d <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102e38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102e3b:	05 70 3b 10 00       	add    $0x103b70,%eax
  102e40:	0f b6 00             	movzbl (%eax),%eax
  102e43:	0f be c0             	movsbl %al,%eax
  102e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e49:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e4d:	89 04 24             	mov    %eax,(%esp)
  102e50:	8b 45 08             	mov    0x8(%ebp),%eax
  102e53:	ff d0                	call   *%eax
}
  102e55:	90                   	nop
  102e56:	c9                   	leave  
  102e57:	c3                   	ret    

00102e58 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102e58:	55                   	push   %ebp
  102e59:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102e5b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102e5f:	7e 14                	jle    102e75 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102e61:	8b 45 08             	mov    0x8(%ebp),%eax
  102e64:	8b 00                	mov    (%eax),%eax
  102e66:	8d 48 08             	lea    0x8(%eax),%ecx
  102e69:	8b 55 08             	mov    0x8(%ebp),%edx
  102e6c:	89 0a                	mov    %ecx,(%edx)
  102e6e:	8b 50 04             	mov    0x4(%eax),%edx
  102e71:	8b 00                	mov    (%eax),%eax
  102e73:	eb 30                	jmp    102ea5 <getuint+0x4d>
    }
    else if (lflag) {
  102e75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e79:	74 16                	je     102e91 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7e:	8b 00                	mov    (%eax),%eax
  102e80:	8d 48 04             	lea    0x4(%eax),%ecx
  102e83:	8b 55 08             	mov    0x8(%ebp),%edx
  102e86:	89 0a                	mov    %ecx,(%edx)
  102e88:	8b 00                	mov    (%eax),%eax
  102e8a:	ba 00 00 00 00       	mov    $0x0,%edx
  102e8f:	eb 14                	jmp    102ea5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102e91:	8b 45 08             	mov    0x8(%ebp),%eax
  102e94:	8b 00                	mov    (%eax),%eax
  102e96:	8d 48 04             	lea    0x4(%eax),%ecx
  102e99:	8b 55 08             	mov    0x8(%ebp),%edx
  102e9c:	89 0a                	mov    %ecx,(%edx)
  102e9e:	8b 00                	mov    (%eax),%eax
  102ea0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ea5:	5d                   	pop    %ebp
  102ea6:	c3                   	ret    

00102ea7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ea7:	55                   	push   %ebp
  102ea8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102eaa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102eae:	7e 14                	jle    102ec4 <getint+0x1d>
        return va_arg(*ap, long long);
  102eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb3:	8b 00                	mov    (%eax),%eax
  102eb5:	8d 48 08             	lea    0x8(%eax),%ecx
  102eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  102ebb:	89 0a                	mov    %ecx,(%edx)
  102ebd:	8b 50 04             	mov    0x4(%eax),%edx
  102ec0:	8b 00                	mov    (%eax),%eax
  102ec2:	eb 28                	jmp    102eec <getint+0x45>
    }
    else if (lflag) {
  102ec4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ec8:	74 12                	je     102edc <getint+0x35>
        return va_arg(*ap, long);
  102eca:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecd:	8b 00                	mov    (%eax),%eax
  102ecf:	8d 48 04             	lea    0x4(%eax),%ecx
  102ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  102ed5:	89 0a                	mov    %ecx,(%edx)
  102ed7:	8b 00                	mov    (%eax),%eax
  102ed9:	99                   	cltd   
  102eda:	eb 10                	jmp    102eec <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102edc:	8b 45 08             	mov    0x8(%ebp),%eax
  102edf:	8b 00                	mov    (%eax),%eax
  102ee1:	8d 48 04             	lea    0x4(%eax),%ecx
  102ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  102ee7:	89 0a                	mov    %ecx,(%edx)
  102ee9:	8b 00                	mov    (%eax),%eax
  102eeb:	99                   	cltd   
    }
}
  102eec:	5d                   	pop    %ebp
  102eed:	c3                   	ret    

00102eee <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102eee:	55                   	push   %ebp
  102eef:	89 e5                	mov    %esp,%ebp
  102ef1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102ef4:	8d 45 14             	lea    0x14(%ebp),%eax
  102ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102efd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f01:	8b 45 10             	mov    0x10(%ebp),%eax
  102f04:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f12:	89 04 24             	mov    %eax,(%esp)
  102f15:	e8 03 00 00 00       	call   102f1d <vprintfmt>
    va_end(ap);
}
  102f1a:	90                   	nop
  102f1b:	c9                   	leave  
  102f1c:	c3                   	ret    

00102f1d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102f1d:	55                   	push   %ebp
  102f1e:	89 e5                	mov    %esp,%ebp
  102f20:	56                   	push   %esi
  102f21:	53                   	push   %ebx
  102f22:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f25:	eb 17                	jmp    102f3e <vprintfmt+0x21>
            if (ch == '\0') {
  102f27:	85 db                	test   %ebx,%ebx
  102f29:	0f 84 bf 03 00 00    	je     1032ee <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f32:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f36:	89 1c 24             	mov    %ebx,(%esp)
  102f39:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3c:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f41:	8d 50 01             	lea    0x1(%eax),%edx
  102f44:	89 55 10             	mov    %edx,0x10(%ebp)
  102f47:	0f b6 00             	movzbl (%eax),%eax
  102f4a:	0f b6 d8             	movzbl %al,%ebx
  102f4d:	83 fb 25             	cmp    $0x25,%ebx
  102f50:	75 d5                	jne    102f27 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102f52:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102f56:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f60:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102f63:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f6d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102f70:	8b 45 10             	mov    0x10(%ebp),%eax
  102f73:	8d 50 01             	lea    0x1(%eax),%edx
  102f76:	89 55 10             	mov    %edx,0x10(%ebp)
  102f79:	0f b6 00             	movzbl (%eax),%eax
  102f7c:	0f b6 d8             	movzbl %al,%ebx
  102f7f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102f82:	83 f8 55             	cmp    $0x55,%eax
  102f85:	0f 87 37 03 00 00    	ja     1032c2 <vprintfmt+0x3a5>
  102f8b:	8b 04 85 94 3b 10 00 	mov    0x103b94(,%eax,4),%eax
  102f92:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102f94:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102f98:	eb d6                	jmp    102f70 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102f9a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102f9e:	eb d0                	jmp    102f70 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102fa0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102fa7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102faa:	89 d0                	mov    %edx,%eax
  102fac:	c1 e0 02             	shl    $0x2,%eax
  102faf:	01 d0                	add    %edx,%eax
  102fb1:	01 c0                	add    %eax,%eax
  102fb3:	01 d8                	add    %ebx,%eax
  102fb5:	83 e8 30             	sub    $0x30,%eax
  102fb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  102fbe:	0f b6 00             	movzbl (%eax),%eax
  102fc1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102fc4:	83 fb 2f             	cmp    $0x2f,%ebx
  102fc7:	7e 38                	jle    103001 <vprintfmt+0xe4>
  102fc9:	83 fb 39             	cmp    $0x39,%ebx
  102fcc:	7f 33                	jg     103001 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102fce:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102fd1:	eb d4                	jmp    102fa7 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102fd3:	8b 45 14             	mov    0x14(%ebp),%eax
  102fd6:	8d 50 04             	lea    0x4(%eax),%edx
  102fd9:	89 55 14             	mov    %edx,0x14(%ebp)
  102fdc:	8b 00                	mov    (%eax),%eax
  102fde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102fe1:	eb 1f                	jmp    103002 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102fe3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fe7:	79 87                	jns    102f70 <vprintfmt+0x53>
                width = 0;
  102fe9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102ff0:	e9 7b ff ff ff       	jmp    102f70 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102ff5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102ffc:	e9 6f ff ff ff       	jmp    102f70 <vprintfmt+0x53>
            goto process_precision;
  103001:	90                   	nop

        process_precision:
            if (width < 0)
  103002:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103006:	0f 89 64 ff ff ff    	jns    102f70 <vprintfmt+0x53>
                width = precision, precision = -1;
  10300c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10300f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103012:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103019:	e9 52 ff ff ff       	jmp    102f70 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10301e:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103021:	e9 4a ff ff ff       	jmp    102f70 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103026:	8b 45 14             	mov    0x14(%ebp),%eax
  103029:	8d 50 04             	lea    0x4(%eax),%edx
  10302c:	89 55 14             	mov    %edx,0x14(%ebp)
  10302f:	8b 00                	mov    (%eax),%eax
  103031:	8b 55 0c             	mov    0xc(%ebp),%edx
  103034:	89 54 24 04          	mov    %edx,0x4(%esp)
  103038:	89 04 24             	mov    %eax,(%esp)
  10303b:	8b 45 08             	mov    0x8(%ebp),%eax
  10303e:	ff d0                	call   *%eax
            break;
  103040:	e9 a4 02 00 00       	jmp    1032e9 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103045:	8b 45 14             	mov    0x14(%ebp),%eax
  103048:	8d 50 04             	lea    0x4(%eax),%edx
  10304b:	89 55 14             	mov    %edx,0x14(%ebp)
  10304e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103050:	85 db                	test   %ebx,%ebx
  103052:	79 02                	jns    103056 <vprintfmt+0x139>
                err = -err;
  103054:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103056:	83 fb 06             	cmp    $0x6,%ebx
  103059:	7f 0b                	jg     103066 <vprintfmt+0x149>
  10305b:	8b 34 9d 54 3b 10 00 	mov    0x103b54(,%ebx,4),%esi
  103062:	85 f6                	test   %esi,%esi
  103064:	75 23                	jne    103089 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  103066:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10306a:	c7 44 24 08 81 3b 10 	movl   $0x103b81,0x8(%esp)
  103071:	00 
  103072:	8b 45 0c             	mov    0xc(%ebp),%eax
  103075:	89 44 24 04          	mov    %eax,0x4(%esp)
  103079:	8b 45 08             	mov    0x8(%ebp),%eax
  10307c:	89 04 24             	mov    %eax,(%esp)
  10307f:	e8 6a fe ff ff       	call   102eee <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103084:	e9 60 02 00 00       	jmp    1032e9 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  103089:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10308d:	c7 44 24 08 8a 3b 10 	movl   $0x103b8a,0x8(%esp)
  103094:	00 
  103095:	8b 45 0c             	mov    0xc(%ebp),%eax
  103098:	89 44 24 04          	mov    %eax,0x4(%esp)
  10309c:	8b 45 08             	mov    0x8(%ebp),%eax
  10309f:	89 04 24             	mov    %eax,(%esp)
  1030a2:	e8 47 fe ff ff       	call   102eee <printfmt>
            break;
  1030a7:	e9 3d 02 00 00       	jmp    1032e9 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1030ac:	8b 45 14             	mov    0x14(%ebp),%eax
  1030af:	8d 50 04             	lea    0x4(%eax),%edx
  1030b2:	89 55 14             	mov    %edx,0x14(%ebp)
  1030b5:	8b 30                	mov    (%eax),%esi
  1030b7:	85 f6                	test   %esi,%esi
  1030b9:	75 05                	jne    1030c0 <vprintfmt+0x1a3>
                p = "(null)";
  1030bb:	be 8d 3b 10 00       	mov    $0x103b8d,%esi
            }
            if (width > 0 && padc != '-') {
  1030c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030c4:	7e 76                	jle    10313c <vprintfmt+0x21f>
  1030c6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1030ca:	74 70                	je     10313c <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1030cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030d3:	89 34 24             	mov    %esi,(%esp)
  1030d6:	e8 f6 f7 ff ff       	call   1028d1 <strnlen>
  1030db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1030de:	29 c2                	sub    %eax,%edx
  1030e0:	89 d0                	mov    %edx,%eax
  1030e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030e5:	eb 16                	jmp    1030fd <vprintfmt+0x1e0>
                    putch(padc, putdat);
  1030e7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1030eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1030f2:	89 04 24             	mov    %eax,(%esp)
  1030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f8:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1030fa:	ff 4d e8             	decl   -0x18(%ebp)
  1030fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103101:	7f e4                	jg     1030e7 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103103:	eb 37                	jmp    10313c <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  103105:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103109:	74 1f                	je     10312a <vprintfmt+0x20d>
  10310b:	83 fb 1f             	cmp    $0x1f,%ebx
  10310e:	7e 05                	jle    103115 <vprintfmt+0x1f8>
  103110:	83 fb 7e             	cmp    $0x7e,%ebx
  103113:	7e 15                	jle    10312a <vprintfmt+0x20d>
                    putch('?', putdat);
  103115:	8b 45 0c             	mov    0xc(%ebp),%eax
  103118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10311c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103123:	8b 45 08             	mov    0x8(%ebp),%eax
  103126:	ff d0                	call   *%eax
  103128:	eb 0f                	jmp    103139 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  10312a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10312d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103131:	89 1c 24             	mov    %ebx,(%esp)
  103134:	8b 45 08             	mov    0x8(%ebp),%eax
  103137:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103139:	ff 4d e8             	decl   -0x18(%ebp)
  10313c:	89 f0                	mov    %esi,%eax
  10313e:	8d 70 01             	lea    0x1(%eax),%esi
  103141:	0f b6 00             	movzbl (%eax),%eax
  103144:	0f be d8             	movsbl %al,%ebx
  103147:	85 db                	test   %ebx,%ebx
  103149:	74 27                	je     103172 <vprintfmt+0x255>
  10314b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10314f:	78 b4                	js     103105 <vprintfmt+0x1e8>
  103151:	ff 4d e4             	decl   -0x1c(%ebp)
  103154:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103158:	79 ab                	jns    103105 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  10315a:	eb 16                	jmp    103172 <vprintfmt+0x255>
                putch(' ', putdat);
  10315c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10315f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103163:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10316a:	8b 45 08             	mov    0x8(%ebp),%eax
  10316d:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10316f:	ff 4d e8             	decl   -0x18(%ebp)
  103172:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103176:	7f e4                	jg     10315c <vprintfmt+0x23f>
            }
            break;
  103178:	e9 6c 01 00 00       	jmp    1032e9 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10317d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103180:	89 44 24 04          	mov    %eax,0x4(%esp)
  103184:	8d 45 14             	lea    0x14(%ebp),%eax
  103187:	89 04 24             	mov    %eax,(%esp)
  10318a:	e8 18 fd ff ff       	call   102ea7 <getint>
  10318f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103192:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103198:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10319b:	85 d2                	test   %edx,%edx
  10319d:	79 26                	jns    1031c5 <vprintfmt+0x2a8>
                putch('-', putdat);
  10319f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b0:	ff d0                	call   *%eax
                num = -(long long)num;
  1031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031b8:	f7 d8                	neg    %eax
  1031ba:	83 d2 00             	adc    $0x0,%edx
  1031bd:	f7 da                	neg    %edx
  1031bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1031c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1031cc:	e9 a8 00 00 00       	jmp    103279 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1031d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031d8:	8d 45 14             	lea    0x14(%ebp),%eax
  1031db:	89 04 24             	mov    %eax,(%esp)
  1031de:	e8 75 fc ff ff       	call   102e58 <getuint>
  1031e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1031e9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1031f0:	e9 84 00 00 00       	jmp    103279 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1031f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031fc:	8d 45 14             	lea    0x14(%ebp),%eax
  1031ff:	89 04 24             	mov    %eax,(%esp)
  103202:	e8 51 fc ff ff       	call   102e58 <getuint>
  103207:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10320a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10320d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103214:	eb 63                	jmp    103279 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  103216:	8b 45 0c             	mov    0xc(%ebp),%eax
  103219:	89 44 24 04          	mov    %eax,0x4(%esp)
  10321d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103224:	8b 45 08             	mov    0x8(%ebp),%eax
  103227:	ff d0                	call   *%eax
            putch('x', putdat);
  103229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103230:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103237:	8b 45 08             	mov    0x8(%ebp),%eax
  10323a:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10323c:	8b 45 14             	mov    0x14(%ebp),%eax
  10323f:	8d 50 04             	lea    0x4(%eax),%edx
  103242:	89 55 14             	mov    %edx,0x14(%ebp)
  103245:	8b 00                	mov    (%eax),%eax
  103247:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10324a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103251:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103258:	eb 1f                	jmp    103279 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10325a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10325d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103261:	8d 45 14             	lea    0x14(%ebp),%eax
  103264:	89 04 24             	mov    %eax,(%esp)
  103267:	e8 ec fb ff ff       	call   102e58 <getuint>
  10326c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10326f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103272:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103279:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10327d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103280:	89 54 24 18          	mov    %edx,0x18(%esp)
  103284:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103287:	89 54 24 14          	mov    %edx,0x14(%esp)
  10328b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10328f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103295:	89 44 24 08          	mov    %eax,0x8(%esp)
  103299:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10329d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a7:	89 04 24             	mov    %eax,(%esp)
  1032aa:	e8 a4 fa ff ff       	call   102d53 <printnum>
            break;
  1032af:	eb 38                	jmp    1032e9 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1032b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032b8:	89 1c 24             	mov    %ebx,(%esp)
  1032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032be:	ff d0                	call   *%eax
            break;
  1032c0:	eb 27                	jmp    1032e9 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1032c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032c9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d3:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1032d5:	ff 4d 10             	decl   0x10(%ebp)
  1032d8:	eb 03                	jmp    1032dd <vprintfmt+0x3c0>
  1032da:	ff 4d 10             	decl   0x10(%ebp)
  1032dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1032e0:	48                   	dec    %eax
  1032e1:	0f b6 00             	movzbl (%eax),%eax
  1032e4:	3c 25                	cmp    $0x25,%al
  1032e6:	75 f2                	jne    1032da <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1032e8:	90                   	nop
    while (1) {
  1032e9:	e9 37 fc ff ff       	jmp    102f25 <vprintfmt+0x8>
                return;
  1032ee:	90                   	nop
        }
    }
}
  1032ef:	83 c4 40             	add    $0x40,%esp
  1032f2:	5b                   	pop    %ebx
  1032f3:	5e                   	pop    %esi
  1032f4:	5d                   	pop    %ebp
  1032f5:	c3                   	ret    

001032f6 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1032f6:	55                   	push   %ebp
  1032f7:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1032f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032fc:	8b 40 08             	mov    0x8(%eax),%eax
  1032ff:	8d 50 01             	lea    0x1(%eax),%edx
  103302:	8b 45 0c             	mov    0xc(%ebp),%eax
  103305:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103308:	8b 45 0c             	mov    0xc(%ebp),%eax
  10330b:	8b 10                	mov    (%eax),%edx
  10330d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103310:	8b 40 04             	mov    0x4(%eax),%eax
  103313:	39 c2                	cmp    %eax,%edx
  103315:	73 12                	jae    103329 <sprintputch+0x33>
        *b->buf ++ = ch;
  103317:	8b 45 0c             	mov    0xc(%ebp),%eax
  10331a:	8b 00                	mov    (%eax),%eax
  10331c:	8d 48 01             	lea    0x1(%eax),%ecx
  10331f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103322:	89 0a                	mov    %ecx,(%edx)
  103324:	8b 55 08             	mov    0x8(%ebp),%edx
  103327:	88 10                	mov    %dl,(%eax)
    }
}
  103329:	90                   	nop
  10332a:	5d                   	pop    %ebp
  10332b:	c3                   	ret    

0010332c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10332c:	55                   	push   %ebp
  10332d:	89 e5                	mov    %esp,%ebp
  10332f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103332:	8d 45 14             	lea    0x14(%ebp),%eax
  103335:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10333f:	8b 45 10             	mov    0x10(%ebp),%eax
  103342:	89 44 24 08          	mov    %eax,0x8(%esp)
  103346:	8b 45 0c             	mov    0xc(%ebp),%eax
  103349:	89 44 24 04          	mov    %eax,0x4(%esp)
  10334d:	8b 45 08             	mov    0x8(%ebp),%eax
  103350:	89 04 24             	mov    %eax,(%esp)
  103353:	e8 08 00 00 00       	call   103360 <vsnprintf>
  103358:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10335e:	c9                   	leave  
  10335f:	c3                   	ret    

00103360 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103360:	55                   	push   %ebp
  103361:	89 e5                	mov    %esp,%ebp
  103363:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103366:	8b 45 08             	mov    0x8(%ebp),%eax
  103369:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10336c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10336f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103372:	8b 45 08             	mov    0x8(%ebp),%eax
  103375:	01 d0                	add    %edx,%eax
  103377:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10337a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103385:	74 0a                	je     103391 <vsnprintf+0x31>
  103387:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10338a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10338d:	39 c2                	cmp    %eax,%edx
  10338f:	76 07                	jbe    103398 <vsnprintf+0x38>
        return -E_INVAL;
  103391:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103396:	eb 2a                	jmp    1033c2 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103398:	8b 45 14             	mov    0x14(%ebp),%eax
  10339b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10339f:	8b 45 10             	mov    0x10(%ebp),%eax
  1033a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1033a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1033a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033ad:	c7 04 24 f6 32 10 00 	movl   $0x1032f6,(%esp)
  1033b4:	e8 64 fb ff ff       	call   102f1d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1033b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033bc:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1033c2:	c9                   	leave  
  1033c3:	c3                   	ret    
