
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 48 af 11 00       	mov    $0x11af48,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 f1 56 00 00       	call   105753 <memset>

    cons_init();                // init the console
  100062:	e8 80 15 00 00       	call   1015e7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 60 5f 10 00 	movl   $0x105f60,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 7c 5f 10 00 	movl   $0x105f7c,(%esp)
  10007c:	e8 11 02 00 00       	call   100292 <cprintf>

    print_kerninfo();
  100081:	e8 b2 08 00 00       	call   100938 <print_kerninfo>

    grade_backtrace();
  100086:	e8 89 00 00 00       	call   100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 9e 30 00 00       	call   10312e <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 b7 16 00 00       	call   10174c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 3c 18 00 00       	call   1018d6 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 eb 0c 00 00       	call   100d8a <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 e2 17 00 00       	call   101886 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 b0 0c 00 00       	call   100d78 <mon_backtrace>
}
  1000c8:	90                   	nop
  1000c9:	c9                   	leave  
  1000ca:	c3                   	ret    

001000cb <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cb:	55                   	push   %ebp
  1000cc:	89 e5                	mov    %esp,%ebp
  1000ce:	53                   	push   %ebx
  1000cf:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b4 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	83 c4 14             	add    $0x14,%esp
  1000f6:	5b                   	pop    %ebx
  1000f7:	5d                   	pop    %ebp
  1000f8:	c3                   	ret    

001000f9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f9:	55                   	push   %ebp
  1000fa:	89 e5                	mov    %esp,%ebp
  1000fc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ff:	8b 45 10             	mov    0x10(%ebp),%eax
  100102:	89 44 24 04          	mov    %eax,0x4(%esp)
  100106:	8b 45 08             	mov    0x8(%ebp),%eax
  100109:	89 04 24             	mov    %eax,(%esp)
  10010c:	e8 ba ff ff ff       	call   1000cb <grade_backtrace1>
}
  100111:	90                   	nop
  100112:	c9                   	leave  
  100113:	c3                   	ret    

00100114 <grade_backtrace>:

void
grade_backtrace(void) {
  100114:	55                   	push   %ebp
  100115:	89 e5                	mov    %esp,%ebp
  100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100126:	ff 
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100132:	e8 c2 ff ff ff       	call   1000f9 <grade_backtrace0>
}
  100137:	90                   	nop
  100138:	c9                   	leave  
  100139:	c3                   	ret    

0010013a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013a:	55                   	push   %ebp
  10013b:	89 e5                	mov    %esp,%ebp
  10013d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100140:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100143:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100146:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100149:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100150:	83 e0 03             	and    $0x3,%eax
  100153:	89 c2                	mov    %eax,%edx
  100155:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10015a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100162:	c7 04 24 81 5f 10 00 	movl   $0x105f81,(%esp)
  100169:	e8 24 01 00 00       	call   100292 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100172:	89 c2                	mov    %eax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 8f 5f 10 00 	movl   $0x105f8f,(%esp)
  100188:	e8 05 01 00 00       	call   100292 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	89 c2                	mov    %eax,%edx
  100193:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100198:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a0:	c7 04 24 9d 5f 10 00 	movl   $0x105f9d,(%esp)
  1001a7:	e8 e6 00 00 00       	call   100292 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ac:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b0:	89 c2                	mov    %eax,%edx
  1001b2:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001bf:	c7 04 24 ab 5f 10 00 	movl   $0x105fab,(%esp)
  1001c6:	e8 c7 00 00 00       	call   100292 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001cf:	89 c2                	mov    %eax,%edx
  1001d1:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d6:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001de:	c7 04 24 b9 5f 10 00 	movl   $0x105fb9,(%esp)
  1001e5:	e8 a8 00 00 00       	call   100292 <cprintf>
    round ++;
  1001ea:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001ef:	40                   	inc    %eax
  1001f0:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001f5:	90                   	nop
  1001f6:	c9                   	leave  
  1001f7:	c3                   	ret    

001001f8 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f8:	55                   	push   %ebp
  1001f9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001fb:	90                   	nop
  1001fc:	5d                   	pop    %ebp
  1001fd:	c3                   	ret    

001001fe <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100201:	90                   	nop
  100202:	5d                   	pop    %ebp
  100203:	c3                   	ret    

00100204 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100204:	55                   	push   %ebp
  100205:	89 e5                	mov    %esp,%ebp
  100207:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020a:	e8 2b ff ff ff       	call   10013a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10020f:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
  100216:	e8 77 00 00 00       	call   100292 <cprintf>
    lab1_switch_to_user();
  10021b:	e8 d8 ff ff ff       	call   1001f8 <lab1_switch_to_user>
    lab1_print_cur_status();
  100220:	e8 15 ff ff ff       	call   10013a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100225:	c7 04 24 e8 5f 10 00 	movl   $0x105fe8,(%esp)
  10022c:	e8 61 00 00 00       	call   100292 <cprintf>
    lab1_switch_to_kernel();
  100231:	e8 c8 ff ff ff       	call   1001fe <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100236:	e8 ff fe ff ff       	call   10013a <lab1_print_cur_status>
}
  10023b:	90                   	nop
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100244:	8b 45 08             	mov    0x8(%ebp),%eax
  100247:	89 04 24             	mov    %eax,(%esp)
  10024a:	e8 c5 13 00 00       	call   101614 <cons_putc>
    (*cnt) ++;
  10024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100252:	8b 00                	mov    (%eax),%eax
  100254:	8d 50 01             	lea    0x1(%eax),%edx
  100257:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025a:	89 10                	mov    %edx,(%eax)
}
  10025c:	90                   	nop
  10025d:	c9                   	leave  
  10025e:	c3                   	ret    

0010025f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025f:	55                   	push   %ebp
  100260:	89 e5                	mov    %esp,%ebp
  100262:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100273:	8b 45 08             	mov    0x8(%ebp),%eax
  100276:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100281:	c7 04 24 3e 02 10 00 	movl   $0x10023e,(%esp)
  100288:	e8 19 58 00 00       	call   105aa6 <vprintfmt>
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100298:	8d 45 0c             	lea    0xc(%ebp),%eax
  10029b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10029e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a8:	89 04 24             	mov    %eax,(%esp)
  1002ab:	e8 af ff ff ff       	call   10025f <vcprintf>
  1002b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b6:	c9                   	leave  
  1002b7:	c3                   	ret    

001002b8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002b8:	55                   	push   %ebp
  1002b9:	89 e5                	mov    %esp,%ebp
  1002bb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002be:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c1:	89 04 24             	mov    %eax,(%esp)
  1002c4:	e8 4b 13 00 00       	call   101614 <cons_putc>
}
  1002c9:	90                   	nop
  1002ca:	c9                   	leave  
  1002cb:	c3                   	ret    

001002cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002cc:	55                   	push   %ebp
  1002cd:	89 e5                	mov    %esp,%ebp
  1002cf:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d9:	eb 13                	jmp    1002ee <cputs+0x22>
        cputch(c, &cnt);
  1002db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002df:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e6:	89 04 24             	mov    %eax,(%esp)
  1002e9:	e8 50 ff ff ff       	call   10023e <cputch>
    while ((c = *str ++) != '\0') {
  1002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f1:	8d 50 01             	lea    0x1(%eax),%edx
  1002f4:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f7:	0f b6 00             	movzbl (%eax),%eax
  1002fa:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002fd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100301:	75 d8                	jne    1002db <cputs+0xf>
    }
    cputch('\n', &cnt);
  100303:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100306:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100311:	e8 28 ff ff ff       	call   10023e <cputch>
    return cnt;
  100316:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100319:	c9                   	leave  
  10031a:	c3                   	ret    

0010031b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10031b:	55                   	push   %ebp
  10031c:	89 e5                	mov    %esp,%ebp
  10031e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100321:	e8 2b 13 00 00       	call   101651 <cons_getc>
  100326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100329:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10032d:	74 f2                	je     100321 <getchar+0x6>
        /* do nothing */;
    return c;
  10032f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100332:	c9                   	leave  
  100333:	c3                   	ret    

00100334 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100334:	55                   	push   %ebp
  100335:	89 e5                	mov    %esp,%ebp
  100337:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10033a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10033e:	74 13                	je     100353 <readline+0x1f>
        cprintf("%s", prompt);
  100340:	8b 45 08             	mov    0x8(%ebp),%eax
  100343:	89 44 24 04          	mov    %eax,0x4(%esp)
  100347:	c7 04 24 07 60 10 00 	movl   $0x106007,(%esp)
  10034e:	e8 3f ff ff ff       	call   100292 <cprintf>
    }
    int i = 0, c;
  100353:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10035a:	e8 bc ff ff ff       	call   10031b <getchar>
  10035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100366:	79 07                	jns    10036f <readline+0x3b>
            return NULL;
  100368:	b8 00 00 00 00       	mov    $0x0,%eax
  10036d:	eb 78                	jmp    1003e7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10036f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100373:	7e 28                	jle    10039d <readline+0x69>
  100375:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10037c:	7f 1f                	jg     10039d <readline+0x69>
            cputchar(c);
  10037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100381:	89 04 24             	mov    %eax,(%esp)
  100384:	e8 2f ff ff ff       	call   1002b8 <cputchar>
            buf[i ++] = c;
  100389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038c:	8d 50 01             	lea    0x1(%eax),%edx
  10038f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100392:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100395:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  10039b:	eb 45                	jmp    1003e2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10039d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003a1:	75 16                	jne    1003b9 <readline+0x85>
  1003a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a7:	7e 10                	jle    1003b9 <readline+0x85>
            cputchar(c);
  1003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003ac:	89 04 24             	mov    %eax,(%esp)
  1003af:	e8 04 ff ff ff       	call   1002b8 <cputchar>
            i --;
  1003b4:	ff 4d f4             	decl   -0xc(%ebp)
  1003b7:	eb 29                	jmp    1003e2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003bd:	74 06                	je     1003c5 <readline+0x91>
  1003bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003c3:	75 95                	jne    10035a <readline+0x26>
            cputchar(c);
  1003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c8:	89 04 24             	mov    %eax,(%esp)
  1003cb:	e8 e8 fe ff ff       	call   1002b8 <cputchar>
            buf[i] = '\0';
  1003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d3:	05 20 a0 11 00       	add    $0x11a020,%eax
  1003d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003db:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1003e0:	eb 05                	jmp    1003e7 <readline+0xb3>
        c = getchar();
  1003e2:	e9 73 ff ff ff       	jmp    10035a <readline+0x26>
        }
    }
}
  1003e7:	c9                   	leave  
  1003e8:	c3                   	ret    

001003e9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e9:	55                   	push   %ebp
  1003ea:	89 e5                	mov    %esp,%ebp
  1003ec:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ef:	a1 20 a4 11 00       	mov    0x11a420,%eax
  1003f4:	85 c0                	test   %eax,%eax
  1003f6:	75 5b                	jne    100453 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003f8:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  1003ff:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100402:	8d 45 14             	lea    0x14(%ebp),%eax
  100405:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10040f:	8b 45 08             	mov    0x8(%ebp),%eax
  100412:	89 44 24 04          	mov    %eax,0x4(%esp)
  100416:	c7 04 24 0a 60 10 00 	movl   $0x10600a,(%esp)
  10041d:	e8 70 fe ff ff       	call   100292 <cprintf>
    vcprintf(fmt, ap);
  100422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100425:	89 44 24 04          	mov    %eax,0x4(%esp)
  100429:	8b 45 10             	mov    0x10(%ebp),%eax
  10042c:	89 04 24             	mov    %eax,(%esp)
  10042f:	e8 2b fe ff ff       	call   10025f <vcprintf>
    cprintf("\n");
  100434:	c7 04 24 26 60 10 00 	movl   $0x106026,(%esp)
  10043b:	e8 52 fe ff ff       	call   100292 <cprintf>
    
    cprintf("stack trackback:\n");
  100440:	c7 04 24 28 60 10 00 	movl   $0x106028,(%esp)
  100447:	e8 46 fe ff ff       	call   100292 <cprintf>
    print_stackframe();
  10044c:	e8 32 06 00 00       	call   100a83 <print_stackframe>
  100451:	eb 01                	jmp    100454 <__panic+0x6b>
        goto panic_dead;
  100453:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100454:	e8 34 14 00 00       	call   10188d <intr_disable>
    while (1) {
        kmonitor(NULL);
  100459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100460:	e8 46 08 00 00       	call   100cab <kmonitor>
  100465:	eb f2                	jmp    100459 <__panic+0x70>

00100467 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100467:	55                   	push   %ebp
  100468:	89 e5                	mov    %esp,%ebp
  10046a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10046d:	8d 45 14             	lea    0x14(%ebp),%eax
  100470:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100473:	8b 45 0c             	mov    0xc(%ebp),%eax
  100476:	89 44 24 08          	mov    %eax,0x8(%esp)
  10047a:	8b 45 08             	mov    0x8(%ebp),%eax
  10047d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100481:	c7 04 24 3a 60 10 00 	movl   $0x10603a,(%esp)
  100488:	e8 05 fe ff ff       	call   100292 <cprintf>
    vcprintf(fmt, ap);
  10048d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100490:	89 44 24 04          	mov    %eax,0x4(%esp)
  100494:	8b 45 10             	mov    0x10(%ebp),%eax
  100497:	89 04 24             	mov    %eax,(%esp)
  10049a:	e8 c0 fd ff ff       	call   10025f <vcprintf>
    cprintf("\n");
  10049f:	c7 04 24 26 60 10 00 	movl   $0x106026,(%esp)
  1004a6:	e8 e7 fd ff ff       	call   100292 <cprintf>
    va_end(ap);
}
  1004ab:	90                   	nop
  1004ac:	c9                   	leave  
  1004ad:	c3                   	ret    

001004ae <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004ae:	55                   	push   %ebp
  1004af:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004b1:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  1004b6:	5d                   	pop    %ebp
  1004b7:	c3                   	ret    

001004b8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004b8:	55                   	push   %ebp
  1004b9:	89 e5                	mov    %esp,%ebp
  1004bb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c1:	8b 00                	mov    (%eax),%eax
  1004c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c9:	8b 00                	mov    (%eax),%eax
  1004cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004d5:	e9 ca 00 00 00       	jmp    1005a4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004e0:	01 d0                	add    %edx,%eax
  1004e2:	89 c2                	mov    %eax,%edx
  1004e4:	c1 ea 1f             	shr    $0x1f,%edx
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	d1 f8                	sar    %eax
  1004eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f1:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004f4:	eb 03                	jmp    1004f9 <stab_binsearch+0x41>
            m --;
  1004f6:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ff:	7c 1f                	jl     100520 <stab_binsearch+0x68>
  100501:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100504:	89 d0                	mov    %edx,%eax
  100506:	01 c0                	add    %eax,%eax
  100508:	01 d0                	add    %edx,%eax
  10050a:	c1 e0 02             	shl    $0x2,%eax
  10050d:	89 c2                	mov    %eax,%edx
  10050f:	8b 45 08             	mov    0x8(%ebp),%eax
  100512:	01 d0                	add    %edx,%eax
  100514:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100518:	0f b6 c0             	movzbl %al,%eax
  10051b:	39 45 14             	cmp    %eax,0x14(%ebp)
  10051e:	75 d6                	jne    1004f6 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7d 09                	jge    100531 <stab_binsearch+0x79>
            l = true_m + 1;
  100528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10052b:	40                   	inc    %eax
  10052c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10052f:	eb 73                	jmp    1005a4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100531:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10053b:	89 d0                	mov    %edx,%eax
  10053d:	01 c0                	add    %eax,%eax
  10053f:	01 d0                	add    %edx,%eax
  100541:	c1 e0 02             	shl    $0x2,%eax
  100544:	89 c2                	mov    %eax,%edx
  100546:	8b 45 08             	mov    0x8(%ebp),%eax
  100549:	01 d0                	add    %edx,%eax
  10054b:	8b 40 08             	mov    0x8(%eax),%eax
  10054e:	39 45 18             	cmp    %eax,0x18(%ebp)
  100551:	76 11                	jbe    100564 <stab_binsearch+0xac>
            *region_left = m;
  100553:	8b 45 0c             	mov    0xc(%ebp),%eax
  100556:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100559:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10055b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10055e:	40                   	inc    %eax
  10055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100562:	eb 40                	jmp    1005a4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100567:	89 d0                	mov    %edx,%eax
  100569:	01 c0                	add    %eax,%eax
  10056b:	01 d0                	add    %edx,%eax
  10056d:	c1 e0 02             	shl    $0x2,%eax
  100570:	89 c2                	mov    %eax,%edx
  100572:	8b 45 08             	mov    0x8(%ebp),%eax
  100575:	01 d0                	add    %edx,%eax
  100577:	8b 40 08             	mov    0x8(%eax),%eax
  10057a:	39 45 18             	cmp    %eax,0x18(%ebp)
  10057d:	73 14                	jae    100593 <stab_binsearch+0xdb>
            *region_right = m - 1;
  10057f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100582:	8d 50 ff             	lea    -0x1(%eax),%edx
  100585:	8b 45 10             	mov    0x10(%ebp),%eax
  100588:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058d:	48                   	dec    %eax
  10058e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100591:	eb 11                	jmp    1005a4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100593:	8b 45 0c             	mov    0xc(%ebp),%eax
  100596:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100599:	89 10                	mov    %edx,(%eax)
            l = m;
  10059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005a1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005aa:	0f 8e 2a ff ff ff    	jle    1004da <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005b4:	75 0f                	jne    1005c5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b9:	8b 00                	mov    (%eax),%eax
  1005bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005be:	8b 45 10             	mov    0x10(%ebp),%eax
  1005c1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005c3:	eb 3e                	jmp    100603 <stab_binsearch+0x14b>
        l = *region_right;
  1005c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005c8:	8b 00                	mov    (%eax),%eax
  1005ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005cd:	eb 03                	jmp    1005d2 <stab_binsearch+0x11a>
  1005cf:	ff 4d fc             	decl   -0x4(%ebp)
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	8b 00                	mov    (%eax),%eax
  1005d7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005da:	7e 1f                	jle    1005fb <stab_binsearch+0x143>
  1005dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005df:	89 d0                	mov    %edx,%eax
  1005e1:	01 c0                	add    %eax,%eax
  1005e3:	01 d0                	add    %edx,%eax
  1005e5:	c1 e0 02             	shl    $0x2,%eax
  1005e8:	89 c2                	mov    %eax,%edx
  1005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ed:	01 d0                	add    %edx,%eax
  1005ef:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005f3:	0f b6 c0             	movzbl %al,%eax
  1005f6:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005f9:	75 d4                	jne    1005cf <stab_binsearch+0x117>
        *region_left = l;
  1005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100601:	89 10                	mov    %edx,(%eax)
}
  100603:	90                   	nop
  100604:	c9                   	leave  
  100605:	c3                   	ret    

00100606 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100606:	55                   	push   %ebp
  100607:	89 e5                	mov    %esp,%ebp
  100609:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060f:	c7 00 58 60 10 00    	movl   $0x106058,(%eax)
    info->eip_line = 0;
  100615:	8b 45 0c             	mov    0xc(%ebp),%eax
  100618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100622:	c7 40 08 58 60 10 00 	movl   $0x106058,0x8(%eax)
    info->eip_fn_namelen = 9;
  100629:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100633:	8b 45 0c             	mov    0xc(%ebp),%eax
  100636:	8b 55 08             	mov    0x8(%ebp),%edx
  100639:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100646:	c7 45 f4 88 72 10 00 	movl   $0x107288,-0xc(%ebp)
    stab_end = __STAB_END__;
  10064d:	c7 45 f0 a8 24 11 00 	movl   $0x1124a8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100654:	c7 45 ec a9 24 11 00 	movl   $0x1124a9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10065b:	c7 45 e8 b7 4f 11 00 	movl   $0x114fb7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100665:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100668:	76 0b                	jbe    100675 <debuginfo_eip+0x6f>
  10066a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10066d:	48                   	dec    %eax
  10066e:	0f b6 00             	movzbl (%eax),%eax
  100671:	84 c0                	test   %al,%al
  100673:	74 0a                	je     10067f <debuginfo_eip+0x79>
        return -1;
  100675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10067a:	e9 b7 02 00 00       	jmp    100936 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10067f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100686:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068c:	29 c2                	sub    %eax,%edx
  10068e:	89 d0                	mov    %edx,%eax
  100690:	c1 f8 02             	sar    $0x2,%eax
  100693:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100699:	48                   	dec    %eax
  10069a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10069d:	8b 45 08             	mov    0x8(%ebp),%eax
  1006a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006a4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006ab:	00 
  1006ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006af:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006bd:	89 04 24             	mov    %eax,(%esp)
  1006c0:	e8 f3 fd ff ff       	call   1004b8 <stab_binsearch>
    if (lfile == 0)
  1006c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c8:	85 c0                	test   %eax,%eax
  1006ca:	75 0a                	jne    1006d6 <debuginfo_eip+0xd0>
        return -1;
  1006cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006d1:	e9 60 02 00 00       	jmp    100936 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006f0:	00 
  1006f1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100702:	89 04 24             	mov    %eax,(%esp)
  100705:	e8 ae fd ff ff       	call   1004b8 <stab_binsearch>

    if (lfun <= rfun) {
  10070a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10070d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100710:	39 c2                	cmp    %eax,%edx
  100712:	7f 7c                	jg     100790 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100714:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	89 d0                	mov    %edx,%eax
  10071b:	01 c0                	add    %eax,%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	c1 e0 02             	shl    $0x2,%eax
  100722:	89 c2                	mov    %eax,%edx
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	01 d0                	add    %edx,%eax
  100729:	8b 00                	mov    (%eax),%eax
  10072b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10072e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100731:	29 d1                	sub    %edx,%ecx
  100733:	89 ca                	mov    %ecx,%edx
  100735:	39 d0                	cmp    %edx,%eax
  100737:	73 22                	jae    10075b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100739:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	89 d0                	mov    %edx,%eax
  100740:	01 c0                	add    %eax,%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	c1 e0 02             	shl    $0x2,%eax
  100747:	89 c2                	mov    %eax,%edx
  100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074c:	01 d0                	add    %edx,%eax
  10074e:	8b 10                	mov    (%eax),%edx
  100750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100753:	01 c2                	add    %eax,%edx
  100755:	8b 45 0c             	mov    0xc(%ebp),%eax
  100758:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10075b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075e:	89 c2                	mov    %eax,%edx
  100760:	89 d0                	mov    %edx,%eax
  100762:	01 c0                	add    %eax,%eax
  100764:	01 d0                	add    %edx,%eax
  100766:	c1 e0 02             	shl    $0x2,%eax
  100769:	89 c2                	mov    %eax,%edx
  10076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	8b 50 08             	mov    0x8(%eax),%edx
  100773:	8b 45 0c             	mov    0xc(%ebp),%eax
  100776:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100779:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077c:	8b 40 10             	mov    0x10(%eax),%eax
  10077f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100788:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10078b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10078e:	eb 15                	jmp    1007a5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100790:	8b 45 0c             	mov    0xc(%ebp),%eax
  100793:	8b 55 08             	mov    0x8(%ebp),%edx
  100796:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10079c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10079f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a8:	8b 40 08             	mov    0x8(%eax),%eax
  1007ab:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007b2:	00 
  1007b3:	89 04 24             	mov    %eax,(%esp)
  1007b6:	e8 14 4e 00 00       	call   1055cf <strfind>
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c0:	8b 40 08             	mov    0x8(%eax),%eax
  1007c3:	29 c2                	sub    %eax,%edx
  1007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1007ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007d2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007d9:	00 
  1007da:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007e1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007eb:	89 04 24             	mov    %eax,(%esp)
  1007ee:	e8 c5 fc ff ff       	call   1004b8 <stab_binsearch>
    if (lline <= rline) {
  1007f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f9:	39 c2                	cmp    %eax,%edx
  1007fb:	7f 23                	jg     100820 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100800:	89 c2                	mov    %eax,%edx
  100802:	89 d0                	mov    %edx,%eax
  100804:	01 c0                	add    %eax,%eax
  100806:	01 d0                	add    %edx,%eax
  100808:	c1 e0 02             	shl    $0x2,%eax
  10080b:	89 c2                	mov    %eax,%edx
  10080d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100810:	01 d0                	add    %edx,%eax
  100812:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100816:	89 c2                	mov    %eax,%edx
  100818:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10081e:	eb 11                	jmp    100831 <debuginfo_eip+0x22b>
        return -1;
  100820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100825:	e9 0c 01 00 00       	jmp    100936 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082d:	48                   	dec    %eax
  10082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100831:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100837:	39 c2                	cmp    %eax,%edx
  100839:	7c 56                	jl     100891 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  10083b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083e:	89 c2                	mov    %eax,%edx
  100840:	89 d0                	mov    %edx,%eax
  100842:	01 c0                	add    %eax,%eax
  100844:	01 d0                	add    %edx,%eax
  100846:	c1 e0 02             	shl    $0x2,%eax
  100849:	89 c2                	mov    %eax,%edx
  10084b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10084e:	01 d0                	add    %edx,%eax
  100850:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100854:	3c 84                	cmp    $0x84,%al
  100856:	74 39                	je     100891 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100871:	3c 64                	cmp    $0x64,%al
  100873:	75 b5                	jne    10082a <debuginfo_eip+0x224>
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 40 08             	mov    0x8(%eax),%eax
  10088d:	85 c0                	test   %eax,%eax
  10088f:	74 99                	je     10082a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100891:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100897:	39 c2                	cmp    %eax,%edx
  100899:	7c 46                	jl     1008e1 <debuginfo_eip+0x2db>
  10089b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089e:	89 c2                	mov    %eax,%edx
  1008a0:	89 d0                	mov    %edx,%eax
  1008a2:	01 c0                	add    %eax,%eax
  1008a4:	01 d0                	add    %edx,%eax
  1008a6:	c1 e0 02             	shl    $0x2,%eax
  1008a9:	89 c2                	mov    %eax,%edx
  1008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ae:	01 d0                	add    %edx,%eax
  1008b0:	8b 00                	mov    (%eax),%eax
  1008b2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1008b8:	29 d1                	sub    %edx,%ecx
  1008ba:	89 ca                	mov    %ecx,%edx
  1008bc:	39 d0                	cmp    %edx,%eax
  1008be:	73 21                	jae    1008e1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c3:	89 c2                	mov    %eax,%edx
  1008c5:	89 d0                	mov    %edx,%eax
  1008c7:	01 c0                	add    %eax,%eax
  1008c9:	01 d0                	add    %edx,%eax
  1008cb:	c1 e0 02             	shl    $0x2,%eax
  1008ce:	89 c2                	mov    %eax,%edx
  1008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d3:	01 d0                	add    %edx,%eax
  1008d5:	8b 10                	mov    (%eax),%edx
  1008d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008da:	01 c2                	add    %eax,%edx
  1008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008df:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008e7:	39 c2                	cmp    %eax,%edx
  1008e9:	7d 46                	jge    100931 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008ee:	40                   	inc    %eax
  1008ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008f2:	eb 16                	jmp    10090a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f7:	8b 40 14             	mov    0x14(%eax),%eax
  1008fa:	8d 50 01             	lea    0x1(%eax),%edx
  1008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100900:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100906:	40                   	inc    %eax
  100907:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10090a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10090d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100910:	39 c2                	cmp    %eax,%edx
  100912:	7d 1d                	jge    100931 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100917:	89 c2                	mov    %eax,%edx
  100919:	89 d0                	mov    %edx,%eax
  10091b:	01 c0                	add    %eax,%eax
  10091d:	01 d0                	add    %edx,%eax
  10091f:	c1 e0 02             	shl    $0x2,%eax
  100922:	89 c2                	mov    %eax,%edx
  100924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100927:	01 d0                	add    %edx,%eax
  100929:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10092d:	3c a0                	cmp    $0xa0,%al
  10092f:	74 c3                	je     1008f4 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  100931:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100936:	c9                   	leave  
  100937:	c3                   	ret    

00100938 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100938:	55                   	push   %ebp
  100939:	89 e5                	mov    %esp,%ebp
  10093b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10093e:	c7 04 24 62 60 10 00 	movl   $0x106062,(%esp)
  100945:	e8 48 f9 ff ff       	call   100292 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10094a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100951:	00 
  100952:	c7 04 24 7b 60 10 00 	movl   $0x10607b,(%esp)
  100959:	e8 34 f9 ff ff       	call   100292 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10095e:	c7 44 24 04 4d 5f 10 	movl   $0x105f4d,0x4(%esp)
  100965:	00 
  100966:	c7 04 24 93 60 10 00 	movl   $0x106093,(%esp)
  10096d:	e8 20 f9 ff ff       	call   100292 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100972:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100979:	00 
  10097a:	c7 04 24 ab 60 10 00 	movl   $0x1060ab,(%esp)
  100981:	e8 0c f9 ff ff       	call   100292 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100986:	c7 44 24 04 48 af 11 	movl   $0x11af48,0x4(%esp)
  10098d:	00 
  10098e:	c7 04 24 c3 60 10 00 	movl   $0x1060c3,(%esp)
  100995:	e8 f8 f8 ff ff       	call   100292 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10099a:	b8 48 af 11 00       	mov    $0x11af48,%eax
  10099f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a5:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009aa:	29 c2                	sub    %eax,%edx
  1009ac:	89 d0                	mov    %edx,%eax
  1009ae:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b4:	85 c0                	test   %eax,%eax
  1009b6:	0f 48 c2             	cmovs  %edx,%eax
  1009b9:	c1 f8 0a             	sar    $0xa,%eax
  1009bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c0:	c7 04 24 dc 60 10 00 	movl   $0x1060dc,(%esp)
  1009c7:	e8 c6 f8 ff ff       	call   100292 <cprintf>
}
  1009cc:	90                   	nop
  1009cd:	c9                   	leave  
  1009ce:	c3                   	ret    

001009cf <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009cf:	55                   	push   %ebp
  1009d0:	89 e5                	mov    %esp,%ebp
  1009d2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009df:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e2:	89 04 24             	mov    %eax,(%esp)
  1009e5:	e8 1c fc ff ff       	call   100606 <debuginfo_eip>
  1009ea:	85 c0                	test   %eax,%eax
  1009ec:	74 15                	je     100a03 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f5:	c7 04 24 06 61 10 00 	movl   $0x106106,(%esp)
  1009fc:	e8 91 f8 ff ff       	call   100292 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a01:	eb 6c                	jmp    100a6f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a0a:	eb 1b                	jmp    100a27 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100a0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	0f b6 00             	movzbl (%eax),%eax
  100a17:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a20:	01 ca                	add    %ecx,%edx
  100a22:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a24:	ff 45 f4             	incl   -0xc(%ebp)
  100a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a2d:	7c dd                	jl     100a0c <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a2f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a38:	01 d0                	add    %edx,%eax
  100a3a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a40:	8b 55 08             	mov    0x8(%ebp),%edx
  100a43:	89 d1                	mov    %edx,%ecx
  100a45:	29 c1                	sub    %eax,%ecx
  100a47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a4d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a51:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a63:	c7 04 24 22 61 10 00 	movl   $0x106122,(%esp)
  100a6a:	e8 23 f8 ff ff       	call   100292 <cprintf>
}
  100a6f:	90                   	nop
  100a70:	c9                   	leave  
  100a71:	c3                   	ret    

00100a72 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a72:	55                   	push   %ebp
  100a73:	89 e5                	mov    %esp,%ebp
  100a75:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a78:	8b 45 04             	mov    0x4(%ebp),%eax
  100a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a81:	c9                   	leave  
  100a82:	c3                   	ret    

00100a83 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a83:	55                   	push   %ebp
  100a84:	89 e5                	mov    %esp,%ebp
  100a86:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a89:	89 e8                	mov    %ebp,%eax
  100a8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     uint32_t ebp=read_ebp(),eip=read_eip();
  100a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a94:	e8 d9 ff ff ff       	call   100a72 <read_eip>
  100a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (int i=0;ebp && i<STACKFRAME_DEPTH;++i) {
  100a9c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aa3:	e9 84 00 00 00       	jmp    100b2c <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  100aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aab:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 34 61 10 00 	movl   $0x106134,(%esp)
  100abd:	e8 d0 f7 ff ff       	call   100292 <cprintf>
        uint32_t* args=ebp+8;
  100ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac5:	83 c0 08             	add    $0x8,%eax
  100ac8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (int j=0;j<4;++j)
  100acb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ad2:	eb 24                	jmp    100af8 <print_stackframe+0x75>
            cprintf("0x%08x ",args[j]);
  100ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ad7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ade:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ae1:	01 d0                	add    %edx,%eax
  100ae3:	8b 00                	mov    (%eax),%eax
  100ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae9:	c7 04 24 50 61 10 00 	movl   $0x106150,(%esp)
  100af0:	e8 9d f7 ff ff       	call   100292 <cprintf>
        for (int j=0;j<4;++j)
  100af5:	ff 45 e8             	incl   -0x18(%ebp)
  100af8:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100afc:	7e d6                	jle    100ad4 <print_stackframe+0x51>
        cprintf("\n");
  100afe:	c7 04 24 58 61 10 00 	movl   $0x106158,(%esp)
  100b05:	e8 88 f7 ff ff       	call   100292 <cprintf>
        print_debuginfo(eip-1);
  100b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b0d:	48                   	dec    %eax
  100b0e:	89 04 24             	mov    %eax,(%esp)
  100b11:	e8 b9 fe ff ff       	call   1009cf <print_debuginfo>
        eip=*(uint32_t*)(ebp+4);
  100b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b19:	83 c0 04             	add    $0x4,%eax
  100b1c:	8b 00                	mov    (%eax),%eax
  100b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp=*(uint32_t*)(ebp);
  100b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b24:	8b 00                	mov    (%eax),%eax
  100b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i=0;ebp && i<STACKFRAME_DEPTH;++i) {
  100b29:	ff 45 ec             	incl   -0x14(%ebp)
  100b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b30:	74 0a                	je     100b3c <print_stackframe+0xb9>
  100b32:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b36:	0f 8e 6c ff ff ff    	jle    100aa8 <print_stackframe+0x25>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100b3c:	90                   	nop
  100b3d:	c9                   	leave  
  100b3e:	c3                   	ret    

00100b3f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b3f:	55                   	push   %ebp
  100b40:	89 e5                	mov    %esp,%ebp
  100b42:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b4c:	eb 0c                	jmp    100b5a <parse+0x1b>
            *buf ++ = '\0';
  100b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b51:	8d 50 01             	lea    0x1(%eax),%edx
  100b54:	89 55 08             	mov    %edx,0x8(%ebp)
  100b57:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5d:	0f b6 00             	movzbl (%eax),%eax
  100b60:	84 c0                	test   %al,%al
  100b62:	74 1d                	je     100b81 <parse+0x42>
  100b64:	8b 45 08             	mov    0x8(%ebp),%eax
  100b67:	0f b6 00             	movzbl (%eax),%eax
  100b6a:	0f be c0             	movsbl %al,%eax
  100b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b71:	c7 04 24 dc 61 10 00 	movl   $0x1061dc,(%esp)
  100b78:	e8 20 4a 00 00       	call   10559d <strchr>
  100b7d:	85 c0                	test   %eax,%eax
  100b7f:	75 cd                	jne    100b4e <parse+0xf>
        }
        if (*buf == '\0') {
  100b81:	8b 45 08             	mov    0x8(%ebp),%eax
  100b84:	0f b6 00             	movzbl (%eax),%eax
  100b87:	84 c0                	test   %al,%al
  100b89:	74 65                	je     100bf0 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b8b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b8f:	75 14                	jne    100ba5 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b91:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b98:	00 
  100b99:	c7 04 24 e1 61 10 00 	movl   $0x1061e1,(%esp)
  100ba0:	e8 ed f6 ff ff       	call   100292 <cprintf>
        }
        argv[argc ++] = buf;
  100ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba8:	8d 50 01             	lea    0x1(%eax),%edx
  100bab:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bb8:	01 c2                	add    %eax,%edx
  100bba:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bbf:	eb 03                	jmp    100bc4 <parse+0x85>
            buf ++;
  100bc1:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc7:	0f b6 00             	movzbl (%eax),%eax
  100bca:	84 c0                	test   %al,%al
  100bcc:	74 8c                	je     100b5a <parse+0x1b>
  100bce:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd1:	0f b6 00             	movzbl (%eax),%eax
  100bd4:	0f be c0             	movsbl %al,%eax
  100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdb:	c7 04 24 dc 61 10 00 	movl   $0x1061dc,(%esp)
  100be2:	e8 b6 49 00 00       	call   10559d <strchr>
  100be7:	85 c0                	test   %eax,%eax
  100be9:	74 d6                	je     100bc1 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100beb:	e9 6a ff ff ff       	jmp    100b5a <parse+0x1b>
            break;
  100bf0:	90                   	nop
        }
    }
    return argc;
  100bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bf4:	c9                   	leave  
  100bf5:	c3                   	ret    

00100bf6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bf6:	55                   	push   %ebp
  100bf7:	89 e5                	mov    %esp,%ebp
  100bf9:	53                   	push   %ebx
  100bfa:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bfd:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c04:	8b 45 08             	mov    0x8(%ebp),%eax
  100c07:	89 04 24             	mov    %eax,(%esp)
  100c0a:	e8 30 ff ff ff       	call   100b3f <parse>
  100c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c16:	75 0a                	jne    100c22 <runcmd+0x2c>
        return 0;
  100c18:	b8 00 00 00 00       	mov    $0x0,%eax
  100c1d:	e9 83 00 00 00       	jmp    100ca5 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c29:	eb 5a                	jmp    100c85 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c2b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c31:	89 d0                	mov    %edx,%eax
  100c33:	01 c0                	add    %eax,%eax
  100c35:	01 d0                	add    %edx,%eax
  100c37:	c1 e0 02             	shl    $0x2,%eax
  100c3a:	05 00 70 11 00       	add    $0x117000,%eax
  100c3f:	8b 00                	mov    (%eax),%eax
  100c41:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c45:	89 04 24             	mov    %eax,(%esp)
  100c48:	e8 b3 48 00 00       	call   105500 <strcmp>
  100c4d:	85 c0                	test   %eax,%eax
  100c4f:	75 31                	jne    100c82 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c54:	89 d0                	mov    %edx,%eax
  100c56:	01 c0                	add    %eax,%eax
  100c58:	01 d0                	add    %edx,%eax
  100c5a:	c1 e0 02             	shl    $0x2,%eax
  100c5d:	05 08 70 11 00       	add    $0x117008,%eax
  100c62:	8b 10                	mov    (%eax),%edx
  100c64:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c67:	83 c0 04             	add    $0x4,%eax
  100c6a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c6d:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7b:	89 1c 24             	mov    %ebx,(%esp)
  100c7e:	ff d2                	call   *%edx
  100c80:	eb 23                	jmp    100ca5 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c82:	ff 45 f4             	incl   -0xc(%ebp)
  100c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c88:	83 f8 02             	cmp    $0x2,%eax
  100c8b:	76 9e                	jbe    100c2b <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c94:	c7 04 24 ff 61 10 00 	movl   $0x1061ff,(%esp)
  100c9b:	e8 f2 f5 ff ff       	call   100292 <cprintf>
    return 0;
  100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca5:	83 c4 64             	add    $0x64,%esp
  100ca8:	5b                   	pop    %ebx
  100ca9:	5d                   	pop    %ebp
  100caa:	c3                   	ret    

00100cab <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cab:	55                   	push   %ebp
  100cac:	89 e5                	mov    %esp,%ebp
  100cae:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cb1:	c7 04 24 18 62 10 00 	movl   $0x106218,(%esp)
  100cb8:	e8 d5 f5 ff ff       	call   100292 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cbd:	c7 04 24 40 62 10 00 	movl   $0x106240,(%esp)
  100cc4:	e8 c9 f5 ff ff       	call   100292 <cprintf>

    if (tf != NULL) {
  100cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ccd:	74 0b                	je     100cda <kmonitor+0x2f>
        print_trapframe(tf);
  100ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd2:	89 04 24             	mov    %eax,(%esp)
  100cd5:	e8 35 0d 00 00       	call   101a0f <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cda:	c7 04 24 65 62 10 00 	movl   $0x106265,(%esp)
  100ce1:	e8 4e f6 ff ff       	call   100334 <readline>
  100ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ced:	74 eb                	je     100cda <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cef:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf9:	89 04 24             	mov    %eax,(%esp)
  100cfc:	e8 f5 fe ff ff       	call   100bf6 <runcmd>
  100d01:	85 c0                	test   %eax,%eax
  100d03:	78 02                	js     100d07 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100d05:	eb d3                	jmp    100cda <kmonitor+0x2f>
                break;
  100d07:	90                   	nop
            }
        }
    }
}
  100d08:	90                   	nop
  100d09:	c9                   	leave  
  100d0a:	c3                   	ret    

00100d0b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d0b:	55                   	push   %ebp
  100d0c:	89 e5                	mov    %esp,%ebp
  100d0e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d18:	eb 3d                	jmp    100d57 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d1d:	89 d0                	mov    %edx,%eax
  100d1f:	01 c0                	add    %eax,%eax
  100d21:	01 d0                	add    %edx,%eax
  100d23:	c1 e0 02             	shl    $0x2,%eax
  100d26:	05 04 70 11 00       	add    $0x117004,%eax
  100d2b:	8b 08                	mov    (%eax),%ecx
  100d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d30:	89 d0                	mov    %edx,%eax
  100d32:	01 c0                	add    %eax,%eax
  100d34:	01 d0                	add    %edx,%eax
  100d36:	c1 e0 02             	shl    $0x2,%eax
  100d39:	05 00 70 11 00       	add    $0x117000,%eax
  100d3e:	8b 00                	mov    (%eax),%eax
  100d40:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d48:	c7 04 24 69 62 10 00 	movl   $0x106269,(%esp)
  100d4f:	e8 3e f5 ff ff       	call   100292 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d54:	ff 45 f4             	incl   -0xc(%ebp)
  100d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5a:	83 f8 02             	cmp    $0x2,%eax
  100d5d:	76 bb                	jbe    100d1a <mon_help+0xf>
    }
    return 0;
  100d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d64:	c9                   	leave  
  100d65:	c3                   	ret    

00100d66 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d66:	55                   	push   %ebp
  100d67:	89 e5                	mov    %esp,%ebp
  100d69:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d6c:	e8 c7 fb ff ff       	call   100938 <print_kerninfo>
    return 0;
  100d71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
  100d7b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d7e:	e8 00 fd ff ff       	call   100a83 <print_stackframe>
    return 0;
  100d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d88:	c9                   	leave  
  100d89:	c3                   	ret    

00100d8a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8a:	55                   	push   %ebp
  100d8b:	89 e5                	mov    %esp,%ebp
  100d8d:	83 ec 28             	sub    $0x28,%esp
  100d90:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d96:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d9a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d9e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da2:	ee                   	out    %al,(%dx)
  100da3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dad:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db5:	ee                   	out    %al,(%dx)
  100db6:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dbc:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100dc0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dc4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dc8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc9:	c7 05 2c af 11 00 00 	movl   $0x0,0x11af2c
  100dd0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd3:	c7 04 24 72 62 10 00 	movl   $0x106272,(%esp)
  100dda:	e8 b3 f4 ff ff       	call   100292 <cprintf>
    pic_enable(IRQ_TIMER);
  100ddf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de6:	e8 2e 09 00 00       	call   101719 <pic_enable>
}
  100deb:	90                   	nop
  100dec:	c9                   	leave  
  100ded:	c3                   	ret    

00100dee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dee:	55                   	push   %ebp
  100def:	89 e5                	mov    %esp,%ebp
  100df1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df4:	9c                   	pushf  
  100df5:	58                   	pop    %eax
  100df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfc:	25 00 02 00 00       	and    $0x200,%eax
  100e01:	85 c0                	test   %eax,%eax
  100e03:	74 0c                	je     100e11 <__intr_save+0x23>
        intr_disable();
  100e05:	e8 83 0a 00 00       	call   10188d <intr_disable>
        return 1;
  100e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0f:	eb 05                	jmp    100e16 <__intr_save+0x28>
    }
    return 0;
  100e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e16:	c9                   	leave  
  100e17:	c3                   	ret    

00100e18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e18:	55                   	push   %ebp
  100e19:	89 e5                	mov    %esp,%ebp
  100e1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e22:	74 05                	je     100e29 <__intr_restore+0x11>
        intr_enable();
  100e24:	e8 5d 0a 00 00       	call   101886 <intr_enable>
    }
}
  100e29:	90                   	nop
  100e2a:	c9                   	leave  
  100e2b:	c3                   	ret    

00100e2c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2c:	55                   	push   %ebp
  100e2d:	89 e5                	mov    %esp,%ebp
  100e2f:	83 ec 10             	sub    $0x10,%esp
  100e32:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e38:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e3c:	89 c2                	mov    %eax,%edx
  100e3e:	ec                   	in     (%dx),%al
  100e3f:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e42:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e48:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e4c:	89 c2                	mov    %eax,%edx
  100e4e:	ec                   	in     (%dx),%al
  100e4f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e52:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e58:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e5c:	89 c2                	mov    %eax,%edx
  100e5e:	ec                   	in     (%dx),%al
  100e5f:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e62:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e68:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e6c:	89 c2                	mov    %eax,%edx
  100e6e:	ec                   	in     (%dx),%al
  100e6f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e72:	90                   	nop
  100e73:	c9                   	leave  
  100e74:	c3                   	ret    

00100e75 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e75:	55                   	push   %ebp
  100e76:	89 e5                	mov    %esp,%ebp
  100e78:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e7b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e85:	0f b7 00             	movzwl (%eax),%eax
  100e88:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e97:	0f b7 00             	movzwl (%eax),%eax
  100e9a:	0f b7 c0             	movzwl %ax,%eax
  100e9d:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ea2:	74 12                	je     100eb6 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ea4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eab:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100eb2:	b4 03 
  100eb4:	eb 13                	jmp    100ec9 <cga_init+0x54>
    } else {
        *cp = was;
  100eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ebd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ec0:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ec7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec9:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ed0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ed4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100edc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ee0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ee1:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ee8:	40                   	inc    %eax
  100ee9:	0f b7 c0             	movzwl %ax,%eax
  100eec:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ef4:	89 c2                	mov    %eax,%edx
  100ef6:	ec                   	in     (%dx),%al
  100ef7:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100efa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100efe:	0f b6 c0             	movzbl %al,%eax
  100f01:	c1 e0 08             	shl    $0x8,%eax
  100f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f07:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f0e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f12:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f16:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f1a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f26:	40                   	inc    %eax
  100f27:	0f b7 c0             	movzwl %ax,%eax
  100f2a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f32:	89 c2                	mov    %eax,%edx
  100f34:	ec                   	in     (%dx),%al
  100f35:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f38:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f3c:	0f b6 c0             	movzbl %al,%eax
  100f3f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f45:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4d:	0f b7 c0             	movzwl %ax,%eax
  100f50:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f56:	90                   	nop
  100f57:	c9                   	leave  
  100f58:	c3                   	ret    

00100f59 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f59:	55                   	push   %ebp
  100f5a:	89 e5                	mov    %esp,%ebp
  100f5c:	83 ec 48             	sub    $0x48,%esp
  100f5f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f65:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f69:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f6d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f71:	ee                   	out    %al,(%dx)
  100f72:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f78:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f7c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f80:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f84:	ee                   	out    %al,(%dx)
  100f85:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f8b:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f8f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f93:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f97:	ee                   	out    %al,(%dx)
  100f98:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f9e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100fa2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fa6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100faa:	ee                   	out    %al,(%dx)
  100fab:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fb1:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100fb5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fb9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fbd:	ee                   	out    %al,(%dx)
  100fbe:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fc4:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fc8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fcc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fd0:	ee                   	out    %al,(%dx)
  100fd1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fd7:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100fdb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fdf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fe3:	ee                   	out    %al,(%dx)
  100fe4:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fea:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fee:	89 c2                	mov    %eax,%edx
  100ff0:	ec                   	in     (%dx),%al
  100ff1:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ff4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff8:	3c ff                	cmp    $0xff,%al
  100ffa:	0f 95 c0             	setne  %al
  100ffd:	0f b6 c0             	movzbl %al,%eax
  101000:	a3 48 a4 11 00       	mov    %eax,0x11a448
  101005:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10100f:	89 c2                	mov    %eax,%edx
  101011:	ec                   	in     (%dx),%al
  101012:	88 45 f1             	mov    %al,-0xf(%ebp)
  101015:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10101b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10101f:	89 c2                	mov    %eax,%edx
  101021:	ec                   	in     (%dx),%al
  101022:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101025:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10102a:	85 c0                	test   %eax,%eax
  10102c:	74 0c                	je     10103a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101035:	e8 df 06 00 00       	call   101719 <pic_enable>
    }
}
  10103a:	90                   	nop
  10103b:	c9                   	leave  
  10103c:	c3                   	ret    

0010103d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103d:	55                   	push   %ebp
  10103e:	89 e5                	mov    %esp,%ebp
  101040:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101043:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10104a:	eb 08                	jmp    101054 <lpt_putc_sub+0x17>
        delay();
  10104c:	e8 db fd ff ff       	call   100e2c <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101051:	ff 45 fc             	incl   -0x4(%ebp)
  101054:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10105a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105e:	89 c2                	mov    %eax,%edx
  101060:	ec                   	in     (%dx),%al
  101061:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101064:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101068:	84 c0                	test   %al,%al
  10106a:	78 09                	js     101075 <lpt_putc_sub+0x38>
  10106c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101073:	7e d7                	jle    10104c <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101075:	8b 45 08             	mov    0x8(%ebp),%eax
  101078:	0f b6 c0             	movzbl %al,%eax
  10107b:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101081:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101084:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101088:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10108c:	ee                   	out    %al,(%dx)
  10108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109f:	ee                   	out    %al,(%dx)
  1010a0:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010a6:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  1010aa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010ae:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b3:	90                   	nop
  1010b4:	c9                   	leave  
  1010b5:	c3                   	ret    

001010b6 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b6:	55                   	push   %ebp
  1010b7:	89 e5                	mov    %esp,%ebp
  1010b9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010bc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010c0:	74 0d                	je     1010cf <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c5:	89 04 24             	mov    %eax,(%esp)
  1010c8:	e8 70 ff ff ff       	call   10103d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010cd:	eb 24                	jmp    1010f3 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d6:	e8 62 ff ff ff       	call   10103d <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010db:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010e2:	e8 56 ff ff ff       	call   10103d <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ee:	e8 4a ff ff ff       	call   10103d <lpt_putc_sub>
}
  1010f3:	90                   	nop
  1010f4:	c9                   	leave  
  1010f5:	c3                   	ret    

001010f6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f6:	55                   	push   %ebp
  1010f7:	89 e5                	mov    %esp,%ebp
  1010f9:	53                   	push   %ebx
  1010fa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101100:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101105:	85 c0                	test   %eax,%eax
  101107:	75 07                	jne    101110 <cga_putc+0x1a>
        c |= 0x0700;
  101109:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101110:	8b 45 08             	mov    0x8(%ebp),%eax
  101113:	0f b6 c0             	movzbl %al,%eax
  101116:	83 f8 0a             	cmp    $0xa,%eax
  101119:	74 55                	je     101170 <cga_putc+0x7a>
  10111b:	83 f8 0d             	cmp    $0xd,%eax
  10111e:	74 63                	je     101183 <cga_putc+0x8d>
  101120:	83 f8 08             	cmp    $0x8,%eax
  101123:	0f 85 94 00 00 00    	jne    1011bd <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  101129:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101130:	85 c0                	test   %eax,%eax
  101132:	0f 84 af 00 00 00    	je     1011e7 <cga_putc+0xf1>
            crt_pos --;
  101138:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10113f:	48                   	dec    %eax
  101140:	0f b7 c0             	movzwl %ax,%eax
  101143:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101149:	8b 45 08             	mov    0x8(%ebp),%eax
  10114c:	98                   	cwtl   
  10114d:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101152:	98                   	cwtl   
  101153:	83 c8 20             	or     $0x20,%eax
  101156:	98                   	cwtl   
  101157:	8b 15 40 a4 11 00    	mov    0x11a440,%edx
  10115d:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  101164:	01 c9                	add    %ecx,%ecx
  101166:	01 ca                	add    %ecx,%edx
  101168:	0f b7 c0             	movzwl %ax,%eax
  10116b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10116e:	eb 77                	jmp    1011e7 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  101170:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101177:	83 c0 50             	add    $0x50,%eax
  10117a:	0f b7 c0             	movzwl %ax,%eax
  10117d:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101183:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  10118a:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  101191:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101196:	89 c8                	mov    %ecx,%eax
  101198:	f7 e2                	mul    %edx
  10119a:	c1 ea 06             	shr    $0x6,%edx
  10119d:	89 d0                	mov    %edx,%eax
  10119f:	c1 e0 02             	shl    $0x2,%eax
  1011a2:	01 d0                	add    %edx,%eax
  1011a4:	c1 e0 04             	shl    $0x4,%eax
  1011a7:	29 c1                	sub    %eax,%ecx
  1011a9:	89 c8                	mov    %ecx,%eax
  1011ab:	0f b7 c0             	movzwl %ax,%eax
  1011ae:	29 c3                	sub    %eax,%ebx
  1011b0:	89 d8                	mov    %ebx,%eax
  1011b2:	0f b7 c0             	movzwl %ax,%eax
  1011b5:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011bb:	eb 2b                	jmp    1011e8 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011bd:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011c3:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011ca:	8d 50 01             	lea    0x1(%eax),%edx
  1011cd:	0f b7 d2             	movzwl %dx,%edx
  1011d0:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011d7:	01 c0                	add    %eax,%eax
  1011d9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1011df:	0f b7 c0             	movzwl %ax,%eax
  1011e2:	66 89 02             	mov    %ax,(%edx)
        break;
  1011e5:	eb 01                	jmp    1011e8 <cga_putc+0xf2>
        break;
  1011e7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011e8:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011ef:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011f4:	76 5d                	jbe    101253 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011f6:	a1 40 a4 11 00       	mov    0x11a440,%eax
  1011fb:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101201:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101206:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10120d:	00 
  10120e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101212:	89 04 24             	mov    %eax,(%esp)
  101215:	e8 79 45 00 00       	call   105793 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101221:	eb 14                	jmp    101237 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  101223:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10122b:	01 d2                	add    %edx,%edx
  10122d:	01 d0                	add    %edx,%eax
  10122f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101234:	ff 45 f4             	incl   -0xc(%ebp)
  101237:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10123e:	7e e3                	jle    101223 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  101240:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101247:	83 e8 50             	sub    $0x50,%eax
  10124a:	0f b7 c0             	movzwl %ax,%eax
  10124d:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101253:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  10125a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10125e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101262:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101266:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10126a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10126b:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101272:	c1 e8 08             	shr    $0x8,%eax
  101275:	0f b7 c0             	movzwl %ax,%eax
  101278:	0f b6 c0             	movzbl %al,%eax
  10127b:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  101282:	42                   	inc    %edx
  101283:	0f b7 d2             	movzwl %dx,%edx
  101286:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10128a:	88 45 e9             	mov    %al,-0x17(%ebp)
  10128d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101291:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101295:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101296:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  10129d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012a1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1012a5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012a9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012ad:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012ae:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012b5:	0f b6 c0             	movzbl %al,%eax
  1012b8:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012bf:	42                   	inc    %edx
  1012c0:	0f b7 d2             	movzwl %dx,%edx
  1012c3:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012c7:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012ca:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012ce:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012d2:	ee                   	out    %al,(%dx)
}
  1012d3:	90                   	nop
  1012d4:	83 c4 34             	add    $0x34,%esp
  1012d7:	5b                   	pop    %ebx
  1012d8:	5d                   	pop    %ebp
  1012d9:	c3                   	ret    

001012da <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012da:	55                   	push   %ebp
  1012db:	89 e5                	mov    %esp,%ebp
  1012dd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012e7:	eb 08                	jmp    1012f1 <serial_putc_sub+0x17>
        delay();
  1012e9:	e8 3e fb ff ff       	call   100e2c <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ee:	ff 45 fc             	incl   -0x4(%ebp)
  1012f1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012f7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012fb:	89 c2                	mov    %eax,%edx
  1012fd:	ec                   	in     (%dx),%al
  1012fe:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101301:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101305:	0f b6 c0             	movzbl %al,%eax
  101308:	83 e0 20             	and    $0x20,%eax
  10130b:	85 c0                	test   %eax,%eax
  10130d:	75 09                	jne    101318 <serial_putc_sub+0x3e>
  10130f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101316:	7e d1                	jle    1012e9 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101318:	8b 45 08             	mov    0x8(%ebp),%eax
  10131b:	0f b6 c0             	movzbl %al,%eax
  10131e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101324:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101327:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10132b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10132f:	ee                   	out    %al,(%dx)
}
  101330:	90                   	nop
  101331:	c9                   	leave  
  101332:	c3                   	ret    

00101333 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101333:	55                   	push   %ebp
  101334:	89 e5                	mov    %esp,%ebp
  101336:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101339:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10133d:	74 0d                	je     10134c <serial_putc+0x19>
        serial_putc_sub(c);
  10133f:	8b 45 08             	mov    0x8(%ebp),%eax
  101342:	89 04 24             	mov    %eax,(%esp)
  101345:	e8 90 ff ff ff       	call   1012da <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10134a:	eb 24                	jmp    101370 <serial_putc+0x3d>
        serial_putc_sub('\b');
  10134c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101353:	e8 82 ff ff ff       	call   1012da <serial_putc_sub>
        serial_putc_sub(' ');
  101358:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10135f:	e8 76 ff ff ff       	call   1012da <serial_putc_sub>
        serial_putc_sub('\b');
  101364:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10136b:	e8 6a ff ff ff       	call   1012da <serial_putc_sub>
}
  101370:	90                   	nop
  101371:	c9                   	leave  
  101372:	c3                   	ret    

00101373 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101373:	55                   	push   %ebp
  101374:	89 e5                	mov    %esp,%ebp
  101376:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101379:	eb 33                	jmp    1013ae <cons_intr+0x3b>
        if (c != 0) {
  10137b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10137f:	74 2d                	je     1013ae <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101381:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101386:	8d 50 01             	lea    0x1(%eax),%edx
  101389:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  10138f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101392:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101398:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10139d:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013a2:	75 0a                	jne    1013ae <cons_intr+0x3b>
                cons.wpos = 0;
  1013a4:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013ab:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b1:	ff d0                	call   *%eax
  1013b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013b6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013ba:	75 bf                	jne    10137b <cons_intr+0x8>
            }
        }
    }
}
  1013bc:	90                   	nop
  1013bd:	c9                   	leave  
  1013be:	c3                   	ret    

001013bf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013bf:	55                   	push   %ebp
  1013c0:	89 e5                	mov    %esp,%ebp
  1013c2:	83 ec 10             	sub    $0x10,%esp
  1013c5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013cb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013cf:	89 c2                	mov    %eax,%edx
  1013d1:	ec                   	in     (%dx),%al
  1013d2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013d9:	0f b6 c0             	movzbl %al,%eax
  1013dc:	83 e0 01             	and    $0x1,%eax
  1013df:	85 c0                	test   %eax,%eax
  1013e1:	75 07                	jne    1013ea <serial_proc_data+0x2b>
        return -1;
  1013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e8:	eb 2a                	jmp    101414 <serial_proc_data+0x55>
  1013ea:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013f0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013f4:	89 c2                	mov    %eax,%edx
  1013f6:	ec                   	in     (%dx),%al
  1013f7:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013fa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013fe:	0f b6 c0             	movzbl %al,%eax
  101401:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101404:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101408:	75 07                	jne    101411 <serial_proc_data+0x52>
        c = '\b';
  10140a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10141c:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101421:	85 c0                	test   %eax,%eax
  101423:	74 0c                	je     101431 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101425:	c7 04 24 bf 13 10 00 	movl   $0x1013bf,(%esp)
  10142c:	e8 42 ff ff ff       	call   101373 <cons_intr>
    }
}
  101431:	90                   	nop
  101432:	c9                   	leave  
  101433:	c3                   	ret    

00101434 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101434:	55                   	push   %ebp
  101435:	89 e5                	mov    %esp,%ebp
  101437:	83 ec 38             	sub    $0x38,%esp
  10143a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101443:	89 c2                	mov    %eax,%edx
  101445:	ec                   	in     (%dx),%al
  101446:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101449:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10144d:	0f b6 c0             	movzbl %al,%eax
  101450:	83 e0 01             	and    $0x1,%eax
  101453:	85 c0                	test   %eax,%eax
  101455:	75 0a                	jne    101461 <kbd_proc_data+0x2d>
        return -1;
  101457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10145c:	e9 55 01 00 00       	jmp    1015b6 <kbd_proc_data+0x182>
  101461:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10146a:	89 c2                	mov    %eax,%edx
  10146c:	ec                   	in     (%dx),%al
  10146d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101470:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101474:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101477:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10147b:	75 17                	jne    101494 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  10147d:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101482:	83 c8 40             	or     $0x40,%eax
  101485:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  10148a:	b8 00 00 00 00       	mov    $0x0,%eax
  10148f:	e9 22 01 00 00       	jmp    1015b6 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101498:	84 c0                	test   %al,%al
  10149a:	79 45                	jns    1014e1 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10149c:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014a1:	83 e0 40             	and    $0x40,%eax
  1014a4:	85 c0                	test   %eax,%eax
  1014a6:	75 08                	jne    1014b0 <kbd_proc_data+0x7c>
  1014a8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ac:	24 7f                	and    $0x7f,%al
  1014ae:	eb 04                	jmp    1014b4 <kbd_proc_data+0x80>
  1014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bb:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014c2:	0c 40                	or     $0x40,%al
  1014c4:	0f b6 c0             	movzbl %al,%eax
  1014c7:	f7 d0                	not    %eax
  1014c9:	89 c2                	mov    %eax,%edx
  1014cb:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014d0:	21 d0                	and    %edx,%eax
  1014d2:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014d7:	b8 00 00 00 00       	mov    $0x0,%eax
  1014dc:	e9 d5 00 00 00       	jmp    1015b6 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014e1:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014e6:	83 e0 40             	and    $0x40,%eax
  1014e9:	85 c0                	test   %eax,%eax
  1014eb:	74 11                	je     1014fe <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014ed:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014f1:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f6:	83 e0 bf             	and    $0xffffffbf,%eax
  1014f9:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101511:	09 d0                	or     %edx,%eax
  101513:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  101518:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151c:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101523:	0f b6 d0             	movzbl %al,%edx
  101526:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10152b:	31 d0                	xor    %edx,%eax
  10152d:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101532:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101537:	83 e0 03             	and    $0x3,%eax
  10153a:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101541:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101545:	01 d0                	add    %edx,%eax
  101547:	0f b6 00             	movzbl (%eax),%eax
  10154a:	0f b6 c0             	movzbl %al,%eax
  10154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101550:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101555:	83 e0 08             	and    $0x8,%eax
  101558:	85 c0                	test   %eax,%eax
  10155a:	74 22                	je     10157e <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  10155c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101560:	7e 0c                	jle    10156e <kbd_proc_data+0x13a>
  101562:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101566:	7f 06                	jg     10156e <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101568:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10156c:	eb 10                	jmp    10157e <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  10156e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101572:	7e 0a                	jle    10157e <kbd_proc_data+0x14a>
  101574:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101578:	7f 04                	jg     10157e <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10157a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10157e:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101583:	f7 d0                	not    %eax
  101585:	83 e0 06             	and    $0x6,%eax
  101588:	85 c0                	test   %eax,%eax
  10158a:	75 27                	jne    1015b3 <kbd_proc_data+0x17f>
  10158c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101593:	75 1e                	jne    1015b3 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  101595:	c7 04 24 8d 62 10 00 	movl   $0x10628d,(%esp)
  10159c:	e8 f1 ec ff ff       	call   100292 <cprintf>
  1015a1:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015a7:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015b2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015b6:	c9                   	leave  
  1015b7:	c3                   	ret    

001015b8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015b8:	55                   	push   %ebp
  1015b9:	89 e5                	mov    %esp,%ebp
  1015bb:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015be:	c7 04 24 34 14 10 00 	movl   $0x101434,(%esp)
  1015c5:	e8 a9 fd ff ff       	call   101373 <cons_intr>
}
  1015ca:	90                   	nop
  1015cb:	c9                   	leave  
  1015cc:	c3                   	ret    

001015cd <kbd_init>:

static void
kbd_init(void) {
  1015cd:	55                   	push   %ebp
  1015ce:	89 e5                	mov    %esp,%ebp
  1015d0:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015d3:	e8 e0 ff ff ff       	call   1015b8 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015df:	e8 35 01 00 00       	call   101719 <pic_enable>
}
  1015e4:	90                   	nop
  1015e5:	c9                   	leave  
  1015e6:	c3                   	ret    

001015e7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015e7:	55                   	push   %ebp
  1015e8:	89 e5                	mov    %esp,%ebp
  1015ea:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015ed:	e8 83 f8 ff ff       	call   100e75 <cga_init>
    serial_init();
  1015f2:	e8 62 f9 ff ff       	call   100f59 <serial_init>
    kbd_init();
  1015f7:	e8 d1 ff ff ff       	call   1015cd <kbd_init>
    if (!serial_exists) {
  1015fc:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101601:	85 c0                	test   %eax,%eax
  101603:	75 0c                	jne    101611 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101605:	c7 04 24 99 62 10 00 	movl   $0x106299,(%esp)
  10160c:	e8 81 ec ff ff       	call   100292 <cprintf>
    }
}
  101611:	90                   	nop
  101612:	c9                   	leave  
  101613:	c3                   	ret    

00101614 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
  101617:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10161a:	e8 cf f7 ff ff       	call   100dee <__intr_save>
  10161f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101622:	8b 45 08             	mov    0x8(%ebp),%eax
  101625:	89 04 24             	mov    %eax,(%esp)
  101628:	e8 89 fa ff ff       	call   1010b6 <lpt_putc>
        cga_putc(c);
  10162d:	8b 45 08             	mov    0x8(%ebp),%eax
  101630:	89 04 24             	mov    %eax,(%esp)
  101633:	e8 be fa ff ff       	call   1010f6 <cga_putc>
        serial_putc(c);
  101638:	8b 45 08             	mov    0x8(%ebp),%eax
  10163b:	89 04 24             	mov    %eax,(%esp)
  10163e:	e8 f0 fc ff ff       	call   101333 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101646:	89 04 24             	mov    %eax,(%esp)
  101649:	e8 ca f7 ff ff       	call   100e18 <__intr_restore>
}
  10164e:	90                   	nop
  10164f:	c9                   	leave  
  101650:	c3                   	ret    

00101651 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101651:	55                   	push   %ebp
  101652:	89 e5                	mov    %esp,%ebp
  101654:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10165e:	e8 8b f7 ff ff       	call   100dee <__intr_save>
  101663:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101666:	e8 ab fd ff ff       	call   101416 <serial_intr>
        kbd_intr();
  10166b:	e8 48 ff ff ff       	call   1015b8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101670:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101676:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10167b:	39 c2                	cmp    %eax,%edx
  10167d:	74 31                	je     1016b0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10167f:	a1 60 a6 11 00       	mov    0x11a660,%eax
  101684:	8d 50 01             	lea    0x1(%eax),%edx
  101687:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  10168d:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  101694:	0f b6 c0             	movzbl %al,%eax
  101697:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10169a:	a1 60 a6 11 00       	mov    0x11a660,%eax
  10169f:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016a4:	75 0a                	jne    1016b0 <cons_getc+0x5f>
                cons.rpos = 0;
  1016a6:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016ad:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016b3:	89 04 24             	mov    %eax,(%esp)
  1016b6:	e8 5d f7 ff ff       	call   100e18 <__intr_restore>
    return c;
  1016bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016be:	c9                   	leave  
  1016bf:	c3                   	ret    

001016c0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016c0:	55                   	push   %ebp
  1016c1:	89 e5                	mov    %esp,%ebp
  1016c3:	83 ec 14             	sub    $0x14,%esp
  1016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016d0:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016d6:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016db:	85 c0                	test   %eax,%eax
  1016dd:	74 37                	je     101716 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016e2:	0f b6 c0             	movzbl %al,%eax
  1016e5:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016eb:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016f2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f6:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016fb:	c1 e8 08             	shr    $0x8,%eax
  1016fe:	0f b7 c0             	movzwl %ax,%eax
  101701:	0f b6 c0             	movzbl %al,%eax
  101704:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10170a:	88 45 fd             	mov    %al,-0x3(%ebp)
  10170d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101711:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101715:	ee                   	out    %al,(%dx)
    }
}
  101716:	90                   	nop
  101717:	c9                   	leave  
  101718:	c3                   	ret    

00101719 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101719:	55                   	push   %ebp
  10171a:	89 e5                	mov    %esp,%ebp
  10171c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10171f:	8b 45 08             	mov    0x8(%ebp),%eax
  101722:	ba 01 00 00 00       	mov    $0x1,%edx
  101727:	88 c1                	mov    %al,%cl
  101729:	d3 e2                	shl    %cl,%edx
  10172b:	89 d0                	mov    %edx,%eax
  10172d:	98                   	cwtl   
  10172e:	f7 d0                	not    %eax
  101730:	0f bf d0             	movswl %ax,%edx
  101733:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10173a:	98                   	cwtl   
  10173b:	21 d0                	and    %edx,%eax
  10173d:	98                   	cwtl   
  10173e:	0f b7 c0             	movzwl %ax,%eax
  101741:	89 04 24             	mov    %eax,(%esp)
  101744:	e8 77 ff ff ff       	call   1016c0 <pic_setmask>
}
  101749:	90                   	nop
  10174a:	c9                   	leave  
  10174b:	c3                   	ret    

0010174c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10174c:	55                   	push   %ebp
  10174d:	89 e5                	mov    %esp,%ebp
  10174f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101752:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  101759:	00 00 00 
  10175c:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101762:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101766:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10176a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101775:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101779:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10177d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101788:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  10178c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101790:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
  101795:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10179b:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  10179f:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017a3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017a7:	ee                   	out    %al,(%dx)
  1017a8:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017ae:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1017b2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017b6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
  1017bb:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017c1:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017c5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017c9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017cd:	ee                   	out    %al,(%dx)
  1017ce:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017d4:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017d8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017dc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e0:	ee                   	out    %al,(%dx)
  1017e1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017e7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1017eb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017ef:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017f3:	ee                   	out    %al,(%dx)
  1017f4:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017fa:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  1017fe:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101802:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101806:	ee                   	out    %al,(%dx)
  101807:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10180d:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101811:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101815:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101819:	ee                   	out    %al,(%dx)
  10181a:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101820:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101824:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101828:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10182c:	ee                   	out    %al,(%dx)
  10182d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101833:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101837:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10183b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10183f:	ee                   	out    %al,(%dx)
  101840:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101846:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  10184a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10184e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101852:	ee                   	out    %al,(%dx)
  101853:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101859:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  10185d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101861:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101865:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101866:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10186d:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101872:	74 0f                	je     101883 <pic_init+0x137>
        pic_setmask(irq_mask);
  101874:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10187b:	89 04 24             	mov    %eax,(%esp)
  10187e:	e8 3d fe ff ff       	call   1016c0 <pic_setmask>
    }
}
  101883:	90                   	nop
  101884:	c9                   	leave  
  101885:	c3                   	ret    

00101886 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101886:	55                   	push   %ebp
  101887:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101889:	fb                   	sti    
    sti();
}
  10188a:	90                   	nop
  10188b:	5d                   	pop    %ebp
  10188c:	c3                   	ret    

0010188d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10188d:	55                   	push   %ebp
  10188e:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101890:	fa                   	cli    
    cli();
}
  101891:	90                   	nop
  101892:	5d                   	pop    %ebp
  101893:	c3                   	ret    

00101894 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101894:	55                   	push   %ebp
  101895:	89 e5                	mov    %esp,%ebp
  101897:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10189a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018a1:	00 
  1018a2:	c7 04 24 c0 62 10 00 	movl   $0x1062c0,(%esp)
  1018a9:	e8 e4 e9 ff ff       	call   100292 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018ae:	c7 04 24 ca 62 10 00 	movl   $0x1062ca,(%esp)
  1018b5:	e8 d8 e9 ff ff       	call   100292 <cprintf>
    panic("EOT: kernel seems ok.");
  1018ba:	c7 44 24 08 d8 62 10 	movl   $0x1062d8,0x8(%esp)
  1018c1:	00 
  1018c2:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018c9:	00 
  1018ca:	c7 04 24 ee 62 10 00 	movl   $0x1062ee,(%esp)
  1018d1:	e8 13 eb ff ff       	call   1003e9 <__panic>

001018d6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018d6:	55                   	push   %ebp
  1018d7:	89 e5                	mov    %esp,%ebp
  1018d9:	83 ec 10             	sub    $0x10,%esp
    extern uintptr_t __vectors[];
    for (int i=0;i<256;++i)
  1018dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018e3:	e9 c4 00 00 00       	jmp    1019ac <idt_init+0xd6>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
  1018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018eb:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018f2:	0f b7 d0             	movzwl %ax,%edx
  1018f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f8:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  1018ff:	00 
  101900:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101903:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  10190a:	00 08 00 
  10190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101910:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101917:	00 
  101918:	80 e2 e0             	and    $0xe0,%dl
  10191b:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101925:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  10192c:	00 
  10192d:	80 e2 1f             	and    $0x1f,%dl
  101930:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101937:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193a:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101941:	00 
  101942:	80 e2 f0             	and    $0xf0,%dl
  101945:	80 ca 0e             	or     $0xe,%dl
  101948:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101952:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101959:	00 
  10195a:	80 e2 ef             	and    $0xef,%dl
  10195d:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101967:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10196e:	00 
  10196f:	80 e2 9f             	and    $0x9f,%dl
  101972:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197c:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101983:	00 
  101984:	80 ca 80             	or     $0x80,%dl
  101987:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101991:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101998:	c1 e8 10             	shr    $0x10,%eax
  10199b:	0f b7 d0             	movzwl %ax,%edx
  10199e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a1:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  1019a8:	00 
    for (int i=0;i<256;++i)
  1019a9:	ff 45 fc             	incl   -0x4(%ebp)
  1019ac:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019b3:	0f 8e 2f ff ff ff    	jle    1018e8 <idt_init+0x12>
  1019b9:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019c3:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  1019c6:	90                   	nop
  1019c7:	c9                   	leave  
  1019c8:	c3                   	ret    

001019c9 <trapname>:

static const char *
trapname(int trapno) {
  1019c9:	55                   	push   %ebp
  1019ca:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cf:	83 f8 13             	cmp    $0x13,%eax
  1019d2:	77 0c                	ja     1019e0 <trapname+0x17>
        return excnames[trapno];
  1019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d7:	8b 04 85 40 66 10 00 	mov    0x106640(,%eax,4),%eax
  1019de:	eb 18                	jmp    1019f8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019e0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019e4:	7e 0d                	jle    1019f3 <trapname+0x2a>
  1019e6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019ea:	7f 07                	jg     1019f3 <trapname+0x2a>
        return "Hardware Interrupt";
  1019ec:	b8 ff 62 10 00       	mov    $0x1062ff,%eax
  1019f1:	eb 05                	jmp    1019f8 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019f3:	b8 12 63 10 00       	mov    $0x106312,%eax
}
  1019f8:	5d                   	pop    %ebp
  1019f9:	c3                   	ret    

001019fa <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019fa:	55                   	push   %ebp
  1019fb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101a00:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a04:	83 f8 08             	cmp    $0x8,%eax
  101a07:	0f 94 c0             	sete   %al
  101a0a:	0f b6 c0             	movzbl %al,%eax
}
  101a0d:	5d                   	pop    %ebp
  101a0e:	c3                   	ret    

00101a0f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a0f:	55                   	push   %ebp
  101a10:	89 e5                	mov    %esp,%ebp
  101a12:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a15:	8b 45 08             	mov    0x8(%ebp),%eax
  101a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1c:	c7 04 24 53 63 10 00 	movl   $0x106353,(%esp)
  101a23:	e8 6a e8 ff ff       	call   100292 <cprintf>
    print_regs(&tf->tf_regs);
  101a28:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2b:	89 04 24             	mov    %eax,(%esp)
  101a2e:	e8 8f 01 00 00       	call   101bc2 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a33:	8b 45 08             	mov    0x8(%ebp),%eax
  101a36:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3e:	c7 04 24 64 63 10 00 	movl   $0x106364,(%esp)
  101a45:	e8 48 e8 ff ff       	call   100292 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a55:	c7 04 24 77 63 10 00 	movl   $0x106377,(%esp)
  101a5c:	e8 31 e8 ff ff       	call   100292 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a61:	8b 45 08             	mov    0x8(%ebp),%eax
  101a64:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6c:	c7 04 24 8a 63 10 00 	movl   $0x10638a,(%esp)
  101a73:	e8 1a e8 ff ff       	call   100292 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a78:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a83:	c7 04 24 9d 63 10 00 	movl   $0x10639d,(%esp)
  101a8a:	e8 03 e8 ff ff       	call   100292 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a92:	8b 40 30             	mov    0x30(%eax),%eax
  101a95:	89 04 24             	mov    %eax,(%esp)
  101a98:	e8 2c ff ff ff       	call   1019c9 <trapname>
  101a9d:	89 c2                	mov    %eax,%edx
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 30             	mov    0x30(%eax),%eax
  101aa5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aad:	c7 04 24 b0 63 10 00 	movl   $0x1063b0,(%esp)
  101ab4:	e8 d9 e7 ff ff       	call   100292 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  101abc:	8b 40 34             	mov    0x34(%eax),%eax
  101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac3:	c7 04 24 c2 63 10 00 	movl   $0x1063c2,(%esp)
  101aca:	e8 c3 e7 ff ff       	call   100292 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	8b 40 38             	mov    0x38(%eax),%eax
  101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad9:	c7 04 24 d1 63 10 00 	movl   $0x1063d1,(%esp)
  101ae0:	e8 ad e7 ff ff       	call   100292 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af0:	c7 04 24 e0 63 10 00 	movl   $0x1063e0,(%esp)
  101af7:	e8 96 e7 ff ff       	call   100292 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	8b 40 40             	mov    0x40(%eax),%eax
  101b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b06:	c7 04 24 f3 63 10 00 	movl   $0x1063f3,(%esp)
  101b0d:	e8 80 e7 ff ff       	call   100292 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b19:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b20:	eb 3d                	jmp    101b5f <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b22:	8b 45 08             	mov    0x8(%ebp),%eax
  101b25:	8b 50 40             	mov    0x40(%eax),%edx
  101b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b2b:	21 d0                	and    %edx,%eax
  101b2d:	85 c0                	test   %eax,%eax
  101b2f:	74 28                	je     101b59 <print_trapframe+0x14a>
  101b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b34:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101b3b:	85 c0                	test   %eax,%eax
  101b3d:	74 1a                	je     101b59 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b42:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4d:	c7 04 24 02 64 10 00 	movl   $0x106402,(%esp)
  101b54:	e8 39 e7 ff ff       	call   100292 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b59:	ff 45 f4             	incl   -0xc(%ebp)
  101b5c:	d1 65 f0             	shll   -0x10(%ebp)
  101b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b62:	83 f8 17             	cmp    $0x17,%eax
  101b65:	76 bb                	jbe    101b22 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	8b 40 40             	mov    0x40(%eax),%eax
  101b6d:	c1 e8 0c             	shr    $0xc,%eax
  101b70:	83 e0 03             	and    $0x3,%eax
  101b73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b77:	c7 04 24 06 64 10 00 	movl   $0x106406,(%esp)
  101b7e:	e8 0f e7 ff ff       	call   100292 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b83:	8b 45 08             	mov    0x8(%ebp),%eax
  101b86:	89 04 24             	mov    %eax,(%esp)
  101b89:	e8 6c fe ff ff       	call   1019fa <trap_in_kernel>
  101b8e:	85 c0                	test   %eax,%eax
  101b90:	75 2d                	jne    101bbf <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b92:	8b 45 08             	mov    0x8(%ebp),%eax
  101b95:	8b 40 44             	mov    0x44(%eax),%eax
  101b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9c:	c7 04 24 0f 64 10 00 	movl   $0x10640f,(%esp)
  101ba3:	e8 ea e6 ff ff       	call   100292 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bab:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb3:	c7 04 24 1e 64 10 00 	movl   $0x10641e,(%esp)
  101bba:	e8 d3 e6 ff ff       	call   100292 <cprintf>
    }
}
  101bbf:	90                   	nop
  101bc0:	c9                   	leave  
  101bc1:	c3                   	ret    

00101bc2 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bc2:	55                   	push   %ebp
  101bc3:	89 e5                	mov    %esp,%ebp
  101bc5:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	8b 00                	mov    (%eax),%eax
  101bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd1:	c7 04 24 31 64 10 00 	movl   $0x106431,(%esp)
  101bd8:	e8 b5 e6 ff ff       	call   100292 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101be0:	8b 40 04             	mov    0x4(%eax),%eax
  101be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be7:	c7 04 24 40 64 10 00 	movl   $0x106440,(%esp)
  101bee:	e8 9f e6 ff ff       	call   100292 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf6:	8b 40 08             	mov    0x8(%eax),%eax
  101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfd:	c7 04 24 4f 64 10 00 	movl   $0x10644f,(%esp)
  101c04:	e8 89 e6 ff ff       	call   100292 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  101c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c13:	c7 04 24 5e 64 10 00 	movl   $0x10645e,(%esp)
  101c1a:	e8 73 e6 ff ff       	call   100292 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c22:	8b 40 10             	mov    0x10(%eax),%eax
  101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c29:	c7 04 24 6d 64 10 00 	movl   $0x10646d,(%esp)
  101c30:	e8 5d e6 ff ff       	call   100292 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c35:	8b 45 08             	mov    0x8(%ebp),%eax
  101c38:	8b 40 14             	mov    0x14(%eax),%eax
  101c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3f:	c7 04 24 7c 64 10 00 	movl   $0x10647c,(%esp)
  101c46:	e8 47 e6 ff ff       	call   100292 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4e:	8b 40 18             	mov    0x18(%eax),%eax
  101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c55:	c7 04 24 8b 64 10 00 	movl   $0x10648b,(%esp)
  101c5c:	e8 31 e6 ff ff       	call   100292 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6b:	c7 04 24 9a 64 10 00 	movl   $0x10649a,(%esp)
  101c72:	e8 1b e6 ff ff       	call   100292 <cprintf>
}
  101c77:	90                   	nop
  101c78:	c9                   	leave  
  101c79:	c3                   	ret    

00101c7a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c7a:	55                   	push   %ebp
  101c7b:	89 e5                	mov    %esp,%ebp
  101c7d:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int clock_cnt=0;
    switch (tf->tf_trapno) {
  101c80:	8b 45 08             	mov    0x8(%ebp),%eax
  101c83:	8b 40 30             	mov    0x30(%eax),%eax
  101c86:	83 f8 2f             	cmp    $0x2f,%eax
  101c89:	77 1d                	ja     101ca8 <trap_dispatch+0x2e>
  101c8b:	83 f8 2e             	cmp    $0x2e,%eax
  101c8e:	0f 83 ec 00 00 00    	jae    101d80 <trap_dispatch+0x106>
  101c94:	83 f8 21             	cmp    $0x21,%eax
  101c97:	74 70                	je     101d09 <trap_dispatch+0x8f>
  101c99:	83 f8 24             	cmp    $0x24,%eax
  101c9c:	74 45                	je     101ce3 <trap_dispatch+0x69>
  101c9e:	83 f8 20             	cmp    $0x20,%eax
  101ca1:	74 13                	je     101cb6 <trap_dispatch+0x3c>
  101ca3:	e9 a3 00 00 00       	jmp    101d4b <trap_dispatch+0xd1>
  101ca8:	83 e8 78             	sub    $0x78,%eax
  101cab:	83 f8 01             	cmp    $0x1,%eax
  101cae:	0f 87 97 00 00 00    	ja     101d4b <trap_dispatch+0xd1>
  101cb4:	eb 79                	jmp    101d2f <trap_dispatch+0xb5>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ++clock_cnt;
  101cb6:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  101cbb:	40                   	inc    %eax
  101cbc:	a3 80 ae 11 00       	mov    %eax,0x11ae80
        if (clock_cnt==TICK_NUM)
  101cc1:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  101cc6:	83 f8 64             	cmp    $0x64,%eax
  101cc9:	0f 85 b4 00 00 00    	jne    101d83 <trap_dispatch+0x109>
            print_ticks(),clock_cnt=0;
  101ccf:	e8 c0 fb ff ff       	call   101894 <print_ticks>
  101cd4:	c7 05 80 ae 11 00 00 	movl   $0x0,0x11ae80
  101cdb:	00 00 00 
        break;
  101cde:	e9 a0 00 00 00       	jmp    101d83 <trap_dispatch+0x109>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ce3:	e8 69 f9 ff ff       	call   101651 <cons_getc>
  101ce8:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ceb:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cef:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf3:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfb:	c7 04 24 a9 64 10 00 	movl   $0x1064a9,(%esp)
  101d02:	e8 8b e5 ff ff       	call   100292 <cprintf>
        break;
  101d07:	eb 7b                	jmp    101d84 <trap_dispatch+0x10a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d09:	e8 43 f9 ff ff       	call   101651 <cons_getc>
  101d0e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d11:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d15:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d19:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d21:	c7 04 24 bb 64 10 00 	movl   $0x1064bb,(%esp)
  101d28:	e8 65 e5 ff ff       	call   100292 <cprintf>
        break;
  101d2d:	eb 55                	jmp    101d84 <trap_dispatch+0x10a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d2f:	c7 44 24 08 ca 64 10 	movl   $0x1064ca,0x8(%esp)
  101d36:	00 
  101d37:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  101d3e:	00 
  101d3f:	c7 04 24 ee 62 10 00 	movl   $0x1062ee,(%esp)
  101d46:	e8 9e e6 ff ff       	call   1003e9 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d52:	83 e0 03             	and    $0x3,%eax
  101d55:	85 c0                	test   %eax,%eax
  101d57:	75 2b                	jne    101d84 <trap_dispatch+0x10a>
            print_trapframe(tf);
  101d59:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5c:	89 04 24             	mov    %eax,(%esp)
  101d5f:	e8 ab fc ff ff       	call   101a0f <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d64:	c7 44 24 08 da 64 10 	movl   $0x1064da,0x8(%esp)
  101d6b:	00 
  101d6c:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  101d73:	00 
  101d74:	c7 04 24 ee 62 10 00 	movl   $0x1062ee,(%esp)
  101d7b:	e8 69 e6 ff ff       	call   1003e9 <__panic>
        break;
  101d80:	90                   	nop
  101d81:	eb 01                	jmp    101d84 <trap_dispatch+0x10a>
        break;
  101d83:	90                   	nop
        }
    }
}
  101d84:	90                   	nop
  101d85:	c9                   	leave  
  101d86:	c3                   	ret    

00101d87 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d87:	55                   	push   %ebp
  101d88:	89 e5                	mov    %esp,%ebp
  101d8a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d90:	89 04 24             	mov    %eax,(%esp)
  101d93:	e8 e2 fe ff ff       	call   101c7a <trap_dispatch>
}
  101d98:	90                   	nop
  101d99:	c9                   	leave  
  101d9a:	c3                   	ret    

00101d9b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d9b:	6a 00                	push   $0x0
  pushl $0
  101d9d:	6a 00                	push   $0x0
  jmp __alltraps
  101d9f:	e9 69 0a 00 00       	jmp    10280d <__alltraps>

00101da4 <vector1>:
.globl vector1
vector1:
  pushl $0
  101da4:	6a 00                	push   $0x0
  pushl $1
  101da6:	6a 01                	push   $0x1
  jmp __alltraps
  101da8:	e9 60 0a 00 00       	jmp    10280d <__alltraps>

00101dad <vector2>:
.globl vector2
vector2:
  pushl $0
  101dad:	6a 00                	push   $0x0
  pushl $2
  101daf:	6a 02                	push   $0x2
  jmp __alltraps
  101db1:	e9 57 0a 00 00       	jmp    10280d <__alltraps>

00101db6 <vector3>:
.globl vector3
vector3:
  pushl $0
  101db6:	6a 00                	push   $0x0
  pushl $3
  101db8:	6a 03                	push   $0x3
  jmp __alltraps
  101dba:	e9 4e 0a 00 00       	jmp    10280d <__alltraps>

00101dbf <vector4>:
.globl vector4
vector4:
  pushl $0
  101dbf:	6a 00                	push   $0x0
  pushl $4
  101dc1:	6a 04                	push   $0x4
  jmp __alltraps
  101dc3:	e9 45 0a 00 00       	jmp    10280d <__alltraps>

00101dc8 <vector5>:
.globl vector5
vector5:
  pushl $0
  101dc8:	6a 00                	push   $0x0
  pushl $5
  101dca:	6a 05                	push   $0x5
  jmp __alltraps
  101dcc:	e9 3c 0a 00 00       	jmp    10280d <__alltraps>

00101dd1 <vector6>:
.globl vector6
vector6:
  pushl $0
  101dd1:	6a 00                	push   $0x0
  pushl $6
  101dd3:	6a 06                	push   $0x6
  jmp __alltraps
  101dd5:	e9 33 0a 00 00       	jmp    10280d <__alltraps>

00101dda <vector7>:
.globl vector7
vector7:
  pushl $0
  101dda:	6a 00                	push   $0x0
  pushl $7
  101ddc:	6a 07                	push   $0x7
  jmp __alltraps
  101dde:	e9 2a 0a 00 00       	jmp    10280d <__alltraps>

00101de3 <vector8>:
.globl vector8
vector8:
  pushl $8
  101de3:	6a 08                	push   $0x8
  jmp __alltraps
  101de5:	e9 23 0a 00 00       	jmp    10280d <__alltraps>

00101dea <vector9>:
.globl vector9
vector9:
  pushl $0
  101dea:	6a 00                	push   $0x0
  pushl $9
  101dec:	6a 09                	push   $0x9
  jmp __alltraps
  101dee:	e9 1a 0a 00 00       	jmp    10280d <__alltraps>

00101df3 <vector10>:
.globl vector10
vector10:
  pushl $10
  101df3:	6a 0a                	push   $0xa
  jmp __alltraps
  101df5:	e9 13 0a 00 00       	jmp    10280d <__alltraps>

00101dfa <vector11>:
.globl vector11
vector11:
  pushl $11
  101dfa:	6a 0b                	push   $0xb
  jmp __alltraps
  101dfc:	e9 0c 0a 00 00       	jmp    10280d <__alltraps>

00101e01 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e01:	6a 0c                	push   $0xc
  jmp __alltraps
  101e03:	e9 05 0a 00 00       	jmp    10280d <__alltraps>

00101e08 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e08:	6a 0d                	push   $0xd
  jmp __alltraps
  101e0a:	e9 fe 09 00 00       	jmp    10280d <__alltraps>

00101e0f <vector14>:
.globl vector14
vector14:
  pushl $14
  101e0f:	6a 0e                	push   $0xe
  jmp __alltraps
  101e11:	e9 f7 09 00 00       	jmp    10280d <__alltraps>

00101e16 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e16:	6a 00                	push   $0x0
  pushl $15
  101e18:	6a 0f                	push   $0xf
  jmp __alltraps
  101e1a:	e9 ee 09 00 00       	jmp    10280d <__alltraps>

00101e1f <vector16>:
.globl vector16
vector16:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $16
  101e21:	6a 10                	push   $0x10
  jmp __alltraps
  101e23:	e9 e5 09 00 00       	jmp    10280d <__alltraps>

00101e28 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e28:	6a 11                	push   $0x11
  jmp __alltraps
  101e2a:	e9 de 09 00 00       	jmp    10280d <__alltraps>

00101e2f <vector18>:
.globl vector18
vector18:
  pushl $0
  101e2f:	6a 00                	push   $0x0
  pushl $18
  101e31:	6a 12                	push   $0x12
  jmp __alltraps
  101e33:	e9 d5 09 00 00       	jmp    10280d <__alltraps>

00101e38 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e38:	6a 00                	push   $0x0
  pushl $19
  101e3a:	6a 13                	push   $0x13
  jmp __alltraps
  101e3c:	e9 cc 09 00 00       	jmp    10280d <__alltraps>

00101e41 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e41:	6a 00                	push   $0x0
  pushl $20
  101e43:	6a 14                	push   $0x14
  jmp __alltraps
  101e45:	e9 c3 09 00 00       	jmp    10280d <__alltraps>

00101e4a <vector21>:
.globl vector21
vector21:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $21
  101e4c:	6a 15                	push   $0x15
  jmp __alltraps
  101e4e:	e9 ba 09 00 00       	jmp    10280d <__alltraps>

00101e53 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e53:	6a 00                	push   $0x0
  pushl $22
  101e55:	6a 16                	push   $0x16
  jmp __alltraps
  101e57:	e9 b1 09 00 00       	jmp    10280d <__alltraps>

00101e5c <vector23>:
.globl vector23
vector23:
  pushl $0
  101e5c:	6a 00                	push   $0x0
  pushl $23
  101e5e:	6a 17                	push   $0x17
  jmp __alltraps
  101e60:	e9 a8 09 00 00       	jmp    10280d <__alltraps>

00101e65 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e65:	6a 00                	push   $0x0
  pushl $24
  101e67:	6a 18                	push   $0x18
  jmp __alltraps
  101e69:	e9 9f 09 00 00       	jmp    10280d <__alltraps>

00101e6e <vector25>:
.globl vector25
vector25:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $25
  101e70:	6a 19                	push   $0x19
  jmp __alltraps
  101e72:	e9 96 09 00 00       	jmp    10280d <__alltraps>

00101e77 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e77:	6a 00                	push   $0x0
  pushl $26
  101e79:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e7b:	e9 8d 09 00 00       	jmp    10280d <__alltraps>

00101e80 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $27
  101e82:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e84:	e9 84 09 00 00       	jmp    10280d <__alltraps>

00101e89 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e89:	6a 00                	push   $0x0
  pushl $28
  101e8b:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e8d:	e9 7b 09 00 00       	jmp    10280d <__alltraps>

00101e92 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e92:	6a 00                	push   $0x0
  pushl $29
  101e94:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e96:	e9 72 09 00 00       	jmp    10280d <__alltraps>

00101e9b <vector30>:
.globl vector30
vector30:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $30
  101e9d:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e9f:	e9 69 09 00 00       	jmp    10280d <__alltraps>

00101ea4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $31
  101ea6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ea8:	e9 60 09 00 00       	jmp    10280d <__alltraps>

00101ead <vector32>:
.globl vector32
vector32:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $32
  101eaf:	6a 20                	push   $0x20
  jmp __alltraps
  101eb1:	e9 57 09 00 00       	jmp    10280d <__alltraps>

00101eb6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $33
  101eb8:	6a 21                	push   $0x21
  jmp __alltraps
  101eba:	e9 4e 09 00 00       	jmp    10280d <__alltraps>

00101ebf <vector34>:
.globl vector34
vector34:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $34
  101ec1:	6a 22                	push   $0x22
  jmp __alltraps
  101ec3:	e9 45 09 00 00       	jmp    10280d <__alltraps>

00101ec8 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $35
  101eca:	6a 23                	push   $0x23
  jmp __alltraps
  101ecc:	e9 3c 09 00 00       	jmp    10280d <__alltraps>

00101ed1 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $36
  101ed3:	6a 24                	push   $0x24
  jmp __alltraps
  101ed5:	e9 33 09 00 00       	jmp    10280d <__alltraps>

00101eda <vector37>:
.globl vector37
vector37:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $37
  101edc:	6a 25                	push   $0x25
  jmp __alltraps
  101ede:	e9 2a 09 00 00       	jmp    10280d <__alltraps>

00101ee3 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $38
  101ee5:	6a 26                	push   $0x26
  jmp __alltraps
  101ee7:	e9 21 09 00 00       	jmp    10280d <__alltraps>

00101eec <vector39>:
.globl vector39
vector39:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $39
  101eee:	6a 27                	push   $0x27
  jmp __alltraps
  101ef0:	e9 18 09 00 00       	jmp    10280d <__alltraps>

00101ef5 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $40
  101ef7:	6a 28                	push   $0x28
  jmp __alltraps
  101ef9:	e9 0f 09 00 00       	jmp    10280d <__alltraps>

00101efe <vector41>:
.globl vector41
vector41:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $41
  101f00:	6a 29                	push   $0x29
  jmp __alltraps
  101f02:	e9 06 09 00 00       	jmp    10280d <__alltraps>

00101f07 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $42
  101f09:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f0b:	e9 fd 08 00 00       	jmp    10280d <__alltraps>

00101f10 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $43
  101f12:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f14:	e9 f4 08 00 00       	jmp    10280d <__alltraps>

00101f19 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $44
  101f1b:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f1d:	e9 eb 08 00 00       	jmp    10280d <__alltraps>

00101f22 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $45
  101f24:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f26:	e9 e2 08 00 00       	jmp    10280d <__alltraps>

00101f2b <vector46>:
.globl vector46
vector46:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $46
  101f2d:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f2f:	e9 d9 08 00 00       	jmp    10280d <__alltraps>

00101f34 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $47
  101f36:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f38:	e9 d0 08 00 00       	jmp    10280d <__alltraps>

00101f3d <vector48>:
.globl vector48
vector48:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $48
  101f3f:	6a 30                	push   $0x30
  jmp __alltraps
  101f41:	e9 c7 08 00 00       	jmp    10280d <__alltraps>

00101f46 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $49
  101f48:	6a 31                	push   $0x31
  jmp __alltraps
  101f4a:	e9 be 08 00 00       	jmp    10280d <__alltraps>

00101f4f <vector50>:
.globl vector50
vector50:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $50
  101f51:	6a 32                	push   $0x32
  jmp __alltraps
  101f53:	e9 b5 08 00 00       	jmp    10280d <__alltraps>

00101f58 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $51
  101f5a:	6a 33                	push   $0x33
  jmp __alltraps
  101f5c:	e9 ac 08 00 00       	jmp    10280d <__alltraps>

00101f61 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $52
  101f63:	6a 34                	push   $0x34
  jmp __alltraps
  101f65:	e9 a3 08 00 00       	jmp    10280d <__alltraps>

00101f6a <vector53>:
.globl vector53
vector53:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $53
  101f6c:	6a 35                	push   $0x35
  jmp __alltraps
  101f6e:	e9 9a 08 00 00       	jmp    10280d <__alltraps>

00101f73 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $54
  101f75:	6a 36                	push   $0x36
  jmp __alltraps
  101f77:	e9 91 08 00 00       	jmp    10280d <__alltraps>

00101f7c <vector55>:
.globl vector55
vector55:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $55
  101f7e:	6a 37                	push   $0x37
  jmp __alltraps
  101f80:	e9 88 08 00 00       	jmp    10280d <__alltraps>

00101f85 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $56
  101f87:	6a 38                	push   $0x38
  jmp __alltraps
  101f89:	e9 7f 08 00 00       	jmp    10280d <__alltraps>

00101f8e <vector57>:
.globl vector57
vector57:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $57
  101f90:	6a 39                	push   $0x39
  jmp __alltraps
  101f92:	e9 76 08 00 00       	jmp    10280d <__alltraps>

00101f97 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $58
  101f99:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f9b:	e9 6d 08 00 00       	jmp    10280d <__alltraps>

00101fa0 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $59
  101fa2:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fa4:	e9 64 08 00 00       	jmp    10280d <__alltraps>

00101fa9 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $60
  101fab:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fad:	e9 5b 08 00 00       	jmp    10280d <__alltraps>

00101fb2 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $61
  101fb4:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fb6:	e9 52 08 00 00       	jmp    10280d <__alltraps>

00101fbb <vector62>:
.globl vector62
vector62:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $62
  101fbd:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fbf:	e9 49 08 00 00       	jmp    10280d <__alltraps>

00101fc4 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $63
  101fc6:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fc8:	e9 40 08 00 00       	jmp    10280d <__alltraps>

00101fcd <vector64>:
.globl vector64
vector64:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $64
  101fcf:	6a 40                	push   $0x40
  jmp __alltraps
  101fd1:	e9 37 08 00 00       	jmp    10280d <__alltraps>

00101fd6 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $65
  101fd8:	6a 41                	push   $0x41
  jmp __alltraps
  101fda:	e9 2e 08 00 00       	jmp    10280d <__alltraps>

00101fdf <vector66>:
.globl vector66
vector66:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $66
  101fe1:	6a 42                	push   $0x42
  jmp __alltraps
  101fe3:	e9 25 08 00 00       	jmp    10280d <__alltraps>

00101fe8 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $67
  101fea:	6a 43                	push   $0x43
  jmp __alltraps
  101fec:	e9 1c 08 00 00       	jmp    10280d <__alltraps>

00101ff1 <vector68>:
.globl vector68
vector68:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $68
  101ff3:	6a 44                	push   $0x44
  jmp __alltraps
  101ff5:	e9 13 08 00 00       	jmp    10280d <__alltraps>

00101ffa <vector69>:
.globl vector69
vector69:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $69
  101ffc:	6a 45                	push   $0x45
  jmp __alltraps
  101ffe:	e9 0a 08 00 00       	jmp    10280d <__alltraps>

00102003 <vector70>:
.globl vector70
vector70:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $70
  102005:	6a 46                	push   $0x46
  jmp __alltraps
  102007:	e9 01 08 00 00       	jmp    10280d <__alltraps>

0010200c <vector71>:
.globl vector71
vector71:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $71
  10200e:	6a 47                	push   $0x47
  jmp __alltraps
  102010:	e9 f8 07 00 00       	jmp    10280d <__alltraps>

00102015 <vector72>:
.globl vector72
vector72:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $72
  102017:	6a 48                	push   $0x48
  jmp __alltraps
  102019:	e9 ef 07 00 00       	jmp    10280d <__alltraps>

0010201e <vector73>:
.globl vector73
vector73:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $73
  102020:	6a 49                	push   $0x49
  jmp __alltraps
  102022:	e9 e6 07 00 00       	jmp    10280d <__alltraps>

00102027 <vector74>:
.globl vector74
vector74:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $74
  102029:	6a 4a                	push   $0x4a
  jmp __alltraps
  10202b:	e9 dd 07 00 00       	jmp    10280d <__alltraps>

00102030 <vector75>:
.globl vector75
vector75:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $75
  102032:	6a 4b                	push   $0x4b
  jmp __alltraps
  102034:	e9 d4 07 00 00       	jmp    10280d <__alltraps>

00102039 <vector76>:
.globl vector76
vector76:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $76
  10203b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10203d:	e9 cb 07 00 00       	jmp    10280d <__alltraps>

00102042 <vector77>:
.globl vector77
vector77:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $77
  102044:	6a 4d                	push   $0x4d
  jmp __alltraps
  102046:	e9 c2 07 00 00       	jmp    10280d <__alltraps>

0010204b <vector78>:
.globl vector78
vector78:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $78
  10204d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10204f:	e9 b9 07 00 00       	jmp    10280d <__alltraps>

00102054 <vector79>:
.globl vector79
vector79:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $79
  102056:	6a 4f                	push   $0x4f
  jmp __alltraps
  102058:	e9 b0 07 00 00       	jmp    10280d <__alltraps>

0010205d <vector80>:
.globl vector80
vector80:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $80
  10205f:	6a 50                	push   $0x50
  jmp __alltraps
  102061:	e9 a7 07 00 00       	jmp    10280d <__alltraps>

00102066 <vector81>:
.globl vector81
vector81:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $81
  102068:	6a 51                	push   $0x51
  jmp __alltraps
  10206a:	e9 9e 07 00 00       	jmp    10280d <__alltraps>

0010206f <vector82>:
.globl vector82
vector82:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $82
  102071:	6a 52                	push   $0x52
  jmp __alltraps
  102073:	e9 95 07 00 00       	jmp    10280d <__alltraps>

00102078 <vector83>:
.globl vector83
vector83:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $83
  10207a:	6a 53                	push   $0x53
  jmp __alltraps
  10207c:	e9 8c 07 00 00       	jmp    10280d <__alltraps>

00102081 <vector84>:
.globl vector84
vector84:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $84
  102083:	6a 54                	push   $0x54
  jmp __alltraps
  102085:	e9 83 07 00 00       	jmp    10280d <__alltraps>

0010208a <vector85>:
.globl vector85
vector85:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $85
  10208c:	6a 55                	push   $0x55
  jmp __alltraps
  10208e:	e9 7a 07 00 00       	jmp    10280d <__alltraps>

00102093 <vector86>:
.globl vector86
vector86:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $86
  102095:	6a 56                	push   $0x56
  jmp __alltraps
  102097:	e9 71 07 00 00       	jmp    10280d <__alltraps>

0010209c <vector87>:
.globl vector87
vector87:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $87
  10209e:	6a 57                	push   $0x57
  jmp __alltraps
  1020a0:	e9 68 07 00 00       	jmp    10280d <__alltraps>

001020a5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $88
  1020a7:	6a 58                	push   $0x58
  jmp __alltraps
  1020a9:	e9 5f 07 00 00       	jmp    10280d <__alltraps>

001020ae <vector89>:
.globl vector89
vector89:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $89
  1020b0:	6a 59                	push   $0x59
  jmp __alltraps
  1020b2:	e9 56 07 00 00       	jmp    10280d <__alltraps>

001020b7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $90
  1020b9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020bb:	e9 4d 07 00 00       	jmp    10280d <__alltraps>

001020c0 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $91
  1020c2:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020c4:	e9 44 07 00 00       	jmp    10280d <__alltraps>

001020c9 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $92
  1020cb:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020cd:	e9 3b 07 00 00       	jmp    10280d <__alltraps>

001020d2 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $93
  1020d4:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020d6:	e9 32 07 00 00       	jmp    10280d <__alltraps>

001020db <vector94>:
.globl vector94
vector94:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $94
  1020dd:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020df:	e9 29 07 00 00       	jmp    10280d <__alltraps>

001020e4 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $95
  1020e6:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020e8:	e9 20 07 00 00       	jmp    10280d <__alltraps>

001020ed <vector96>:
.globl vector96
vector96:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $96
  1020ef:	6a 60                	push   $0x60
  jmp __alltraps
  1020f1:	e9 17 07 00 00       	jmp    10280d <__alltraps>

001020f6 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $97
  1020f8:	6a 61                	push   $0x61
  jmp __alltraps
  1020fa:	e9 0e 07 00 00       	jmp    10280d <__alltraps>

001020ff <vector98>:
.globl vector98
vector98:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $98
  102101:	6a 62                	push   $0x62
  jmp __alltraps
  102103:	e9 05 07 00 00       	jmp    10280d <__alltraps>

00102108 <vector99>:
.globl vector99
vector99:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $99
  10210a:	6a 63                	push   $0x63
  jmp __alltraps
  10210c:	e9 fc 06 00 00       	jmp    10280d <__alltraps>

00102111 <vector100>:
.globl vector100
vector100:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $100
  102113:	6a 64                	push   $0x64
  jmp __alltraps
  102115:	e9 f3 06 00 00       	jmp    10280d <__alltraps>

0010211a <vector101>:
.globl vector101
vector101:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $101
  10211c:	6a 65                	push   $0x65
  jmp __alltraps
  10211e:	e9 ea 06 00 00       	jmp    10280d <__alltraps>

00102123 <vector102>:
.globl vector102
vector102:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $102
  102125:	6a 66                	push   $0x66
  jmp __alltraps
  102127:	e9 e1 06 00 00       	jmp    10280d <__alltraps>

0010212c <vector103>:
.globl vector103
vector103:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $103
  10212e:	6a 67                	push   $0x67
  jmp __alltraps
  102130:	e9 d8 06 00 00       	jmp    10280d <__alltraps>

00102135 <vector104>:
.globl vector104
vector104:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $104
  102137:	6a 68                	push   $0x68
  jmp __alltraps
  102139:	e9 cf 06 00 00       	jmp    10280d <__alltraps>

0010213e <vector105>:
.globl vector105
vector105:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $105
  102140:	6a 69                	push   $0x69
  jmp __alltraps
  102142:	e9 c6 06 00 00       	jmp    10280d <__alltraps>

00102147 <vector106>:
.globl vector106
vector106:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $106
  102149:	6a 6a                	push   $0x6a
  jmp __alltraps
  10214b:	e9 bd 06 00 00       	jmp    10280d <__alltraps>

00102150 <vector107>:
.globl vector107
vector107:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $107
  102152:	6a 6b                	push   $0x6b
  jmp __alltraps
  102154:	e9 b4 06 00 00       	jmp    10280d <__alltraps>

00102159 <vector108>:
.globl vector108
vector108:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $108
  10215b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10215d:	e9 ab 06 00 00       	jmp    10280d <__alltraps>

00102162 <vector109>:
.globl vector109
vector109:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $109
  102164:	6a 6d                	push   $0x6d
  jmp __alltraps
  102166:	e9 a2 06 00 00       	jmp    10280d <__alltraps>

0010216b <vector110>:
.globl vector110
vector110:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $110
  10216d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10216f:	e9 99 06 00 00       	jmp    10280d <__alltraps>

00102174 <vector111>:
.globl vector111
vector111:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $111
  102176:	6a 6f                	push   $0x6f
  jmp __alltraps
  102178:	e9 90 06 00 00       	jmp    10280d <__alltraps>

0010217d <vector112>:
.globl vector112
vector112:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $112
  10217f:	6a 70                	push   $0x70
  jmp __alltraps
  102181:	e9 87 06 00 00       	jmp    10280d <__alltraps>

00102186 <vector113>:
.globl vector113
vector113:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $113
  102188:	6a 71                	push   $0x71
  jmp __alltraps
  10218a:	e9 7e 06 00 00       	jmp    10280d <__alltraps>

0010218f <vector114>:
.globl vector114
vector114:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $114
  102191:	6a 72                	push   $0x72
  jmp __alltraps
  102193:	e9 75 06 00 00       	jmp    10280d <__alltraps>

00102198 <vector115>:
.globl vector115
vector115:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $115
  10219a:	6a 73                	push   $0x73
  jmp __alltraps
  10219c:	e9 6c 06 00 00       	jmp    10280d <__alltraps>

001021a1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $116
  1021a3:	6a 74                	push   $0x74
  jmp __alltraps
  1021a5:	e9 63 06 00 00       	jmp    10280d <__alltraps>

001021aa <vector117>:
.globl vector117
vector117:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $117
  1021ac:	6a 75                	push   $0x75
  jmp __alltraps
  1021ae:	e9 5a 06 00 00       	jmp    10280d <__alltraps>

001021b3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $118
  1021b5:	6a 76                	push   $0x76
  jmp __alltraps
  1021b7:	e9 51 06 00 00       	jmp    10280d <__alltraps>

001021bc <vector119>:
.globl vector119
vector119:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $119
  1021be:	6a 77                	push   $0x77
  jmp __alltraps
  1021c0:	e9 48 06 00 00       	jmp    10280d <__alltraps>

001021c5 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $120
  1021c7:	6a 78                	push   $0x78
  jmp __alltraps
  1021c9:	e9 3f 06 00 00       	jmp    10280d <__alltraps>

001021ce <vector121>:
.globl vector121
vector121:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $121
  1021d0:	6a 79                	push   $0x79
  jmp __alltraps
  1021d2:	e9 36 06 00 00       	jmp    10280d <__alltraps>

001021d7 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $122
  1021d9:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021db:	e9 2d 06 00 00       	jmp    10280d <__alltraps>

001021e0 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $123
  1021e2:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021e4:	e9 24 06 00 00       	jmp    10280d <__alltraps>

001021e9 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $124
  1021eb:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021ed:	e9 1b 06 00 00       	jmp    10280d <__alltraps>

001021f2 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $125
  1021f4:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021f6:	e9 12 06 00 00       	jmp    10280d <__alltraps>

001021fb <vector126>:
.globl vector126
vector126:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $126
  1021fd:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021ff:	e9 09 06 00 00       	jmp    10280d <__alltraps>

00102204 <vector127>:
.globl vector127
vector127:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $127
  102206:	6a 7f                	push   $0x7f
  jmp __alltraps
  102208:	e9 00 06 00 00       	jmp    10280d <__alltraps>

0010220d <vector128>:
.globl vector128
vector128:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $128
  10220f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102214:	e9 f4 05 00 00       	jmp    10280d <__alltraps>

00102219 <vector129>:
.globl vector129
vector129:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $129
  10221b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102220:	e9 e8 05 00 00       	jmp    10280d <__alltraps>

00102225 <vector130>:
.globl vector130
vector130:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $130
  102227:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10222c:	e9 dc 05 00 00       	jmp    10280d <__alltraps>

00102231 <vector131>:
.globl vector131
vector131:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $131
  102233:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102238:	e9 d0 05 00 00       	jmp    10280d <__alltraps>

0010223d <vector132>:
.globl vector132
vector132:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $132
  10223f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102244:	e9 c4 05 00 00       	jmp    10280d <__alltraps>

00102249 <vector133>:
.globl vector133
vector133:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $133
  10224b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102250:	e9 b8 05 00 00       	jmp    10280d <__alltraps>

00102255 <vector134>:
.globl vector134
vector134:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $134
  102257:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10225c:	e9 ac 05 00 00       	jmp    10280d <__alltraps>

00102261 <vector135>:
.globl vector135
vector135:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $135
  102263:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102268:	e9 a0 05 00 00       	jmp    10280d <__alltraps>

0010226d <vector136>:
.globl vector136
vector136:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $136
  10226f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102274:	e9 94 05 00 00       	jmp    10280d <__alltraps>

00102279 <vector137>:
.globl vector137
vector137:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $137
  10227b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102280:	e9 88 05 00 00       	jmp    10280d <__alltraps>

00102285 <vector138>:
.globl vector138
vector138:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $138
  102287:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10228c:	e9 7c 05 00 00       	jmp    10280d <__alltraps>

00102291 <vector139>:
.globl vector139
vector139:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $139
  102293:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102298:	e9 70 05 00 00       	jmp    10280d <__alltraps>

0010229d <vector140>:
.globl vector140
vector140:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $140
  10229f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022a4:	e9 64 05 00 00       	jmp    10280d <__alltraps>

001022a9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $141
  1022ab:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022b0:	e9 58 05 00 00       	jmp    10280d <__alltraps>

001022b5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $142
  1022b7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022bc:	e9 4c 05 00 00       	jmp    10280d <__alltraps>

001022c1 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $143
  1022c3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022c8:	e9 40 05 00 00       	jmp    10280d <__alltraps>

001022cd <vector144>:
.globl vector144
vector144:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $144
  1022cf:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022d4:	e9 34 05 00 00       	jmp    10280d <__alltraps>

001022d9 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $145
  1022db:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022e0:	e9 28 05 00 00       	jmp    10280d <__alltraps>

001022e5 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $146
  1022e7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022ec:	e9 1c 05 00 00       	jmp    10280d <__alltraps>

001022f1 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $147
  1022f3:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022f8:	e9 10 05 00 00       	jmp    10280d <__alltraps>

001022fd <vector148>:
.globl vector148
vector148:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $148
  1022ff:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102304:	e9 04 05 00 00       	jmp    10280d <__alltraps>

00102309 <vector149>:
.globl vector149
vector149:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $149
  10230b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102310:	e9 f8 04 00 00       	jmp    10280d <__alltraps>

00102315 <vector150>:
.globl vector150
vector150:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $150
  102317:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10231c:	e9 ec 04 00 00       	jmp    10280d <__alltraps>

00102321 <vector151>:
.globl vector151
vector151:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $151
  102323:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102328:	e9 e0 04 00 00       	jmp    10280d <__alltraps>

0010232d <vector152>:
.globl vector152
vector152:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $152
  10232f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102334:	e9 d4 04 00 00       	jmp    10280d <__alltraps>

00102339 <vector153>:
.globl vector153
vector153:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $153
  10233b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102340:	e9 c8 04 00 00       	jmp    10280d <__alltraps>

00102345 <vector154>:
.globl vector154
vector154:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $154
  102347:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10234c:	e9 bc 04 00 00       	jmp    10280d <__alltraps>

00102351 <vector155>:
.globl vector155
vector155:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $155
  102353:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102358:	e9 b0 04 00 00       	jmp    10280d <__alltraps>

0010235d <vector156>:
.globl vector156
vector156:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $156
  10235f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102364:	e9 a4 04 00 00       	jmp    10280d <__alltraps>

00102369 <vector157>:
.globl vector157
vector157:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $157
  10236b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102370:	e9 98 04 00 00       	jmp    10280d <__alltraps>

00102375 <vector158>:
.globl vector158
vector158:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $158
  102377:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10237c:	e9 8c 04 00 00       	jmp    10280d <__alltraps>

00102381 <vector159>:
.globl vector159
vector159:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $159
  102383:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102388:	e9 80 04 00 00       	jmp    10280d <__alltraps>

0010238d <vector160>:
.globl vector160
vector160:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $160
  10238f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102394:	e9 74 04 00 00       	jmp    10280d <__alltraps>

00102399 <vector161>:
.globl vector161
vector161:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $161
  10239b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023a0:	e9 68 04 00 00       	jmp    10280d <__alltraps>

001023a5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $162
  1023a7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023ac:	e9 5c 04 00 00       	jmp    10280d <__alltraps>

001023b1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $163
  1023b3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023b8:	e9 50 04 00 00       	jmp    10280d <__alltraps>

001023bd <vector164>:
.globl vector164
vector164:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $164
  1023bf:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023c4:	e9 44 04 00 00       	jmp    10280d <__alltraps>

001023c9 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $165
  1023cb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023d0:	e9 38 04 00 00       	jmp    10280d <__alltraps>

001023d5 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $166
  1023d7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023dc:	e9 2c 04 00 00       	jmp    10280d <__alltraps>

001023e1 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $167
  1023e3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023e8:	e9 20 04 00 00       	jmp    10280d <__alltraps>

001023ed <vector168>:
.globl vector168
vector168:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $168
  1023ef:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023f4:	e9 14 04 00 00       	jmp    10280d <__alltraps>

001023f9 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $169
  1023fb:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102400:	e9 08 04 00 00       	jmp    10280d <__alltraps>

00102405 <vector170>:
.globl vector170
vector170:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $170
  102407:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10240c:	e9 fc 03 00 00       	jmp    10280d <__alltraps>

00102411 <vector171>:
.globl vector171
vector171:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $171
  102413:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102418:	e9 f0 03 00 00       	jmp    10280d <__alltraps>

0010241d <vector172>:
.globl vector172
vector172:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $172
  10241f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102424:	e9 e4 03 00 00       	jmp    10280d <__alltraps>

00102429 <vector173>:
.globl vector173
vector173:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $173
  10242b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102430:	e9 d8 03 00 00       	jmp    10280d <__alltraps>

00102435 <vector174>:
.globl vector174
vector174:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $174
  102437:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10243c:	e9 cc 03 00 00       	jmp    10280d <__alltraps>

00102441 <vector175>:
.globl vector175
vector175:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $175
  102443:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102448:	e9 c0 03 00 00       	jmp    10280d <__alltraps>

0010244d <vector176>:
.globl vector176
vector176:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $176
  10244f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102454:	e9 b4 03 00 00       	jmp    10280d <__alltraps>

00102459 <vector177>:
.globl vector177
vector177:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $177
  10245b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102460:	e9 a8 03 00 00       	jmp    10280d <__alltraps>

00102465 <vector178>:
.globl vector178
vector178:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $178
  102467:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10246c:	e9 9c 03 00 00       	jmp    10280d <__alltraps>

00102471 <vector179>:
.globl vector179
vector179:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $179
  102473:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102478:	e9 90 03 00 00       	jmp    10280d <__alltraps>

0010247d <vector180>:
.globl vector180
vector180:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $180
  10247f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102484:	e9 84 03 00 00       	jmp    10280d <__alltraps>

00102489 <vector181>:
.globl vector181
vector181:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $181
  10248b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102490:	e9 78 03 00 00       	jmp    10280d <__alltraps>

00102495 <vector182>:
.globl vector182
vector182:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $182
  102497:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10249c:	e9 6c 03 00 00       	jmp    10280d <__alltraps>

001024a1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $183
  1024a3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024a8:	e9 60 03 00 00       	jmp    10280d <__alltraps>

001024ad <vector184>:
.globl vector184
vector184:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $184
  1024af:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024b4:	e9 54 03 00 00       	jmp    10280d <__alltraps>

001024b9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $185
  1024bb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024c0:	e9 48 03 00 00       	jmp    10280d <__alltraps>

001024c5 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $186
  1024c7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024cc:	e9 3c 03 00 00       	jmp    10280d <__alltraps>

001024d1 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $187
  1024d3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024d8:	e9 30 03 00 00       	jmp    10280d <__alltraps>

001024dd <vector188>:
.globl vector188
vector188:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $188
  1024df:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024e4:	e9 24 03 00 00       	jmp    10280d <__alltraps>

001024e9 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $189
  1024eb:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024f0:	e9 18 03 00 00       	jmp    10280d <__alltraps>

001024f5 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $190
  1024f7:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024fc:	e9 0c 03 00 00       	jmp    10280d <__alltraps>

00102501 <vector191>:
.globl vector191
vector191:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $191
  102503:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102508:	e9 00 03 00 00       	jmp    10280d <__alltraps>

0010250d <vector192>:
.globl vector192
vector192:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $192
  10250f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102514:	e9 f4 02 00 00       	jmp    10280d <__alltraps>

00102519 <vector193>:
.globl vector193
vector193:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $193
  10251b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102520:	e9 e8 02 00 00       	jmp    10280d <__alltraps>

00102525 <vector194>:
.globl vector194
vector194:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $194
  102527:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10252c:	e9 dc 02 00 00       	jmp    10280d <__alltraps>

00102531 <vector195>:
.globl vector195
vector195:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $195
  102533:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102538:	e9 d0 02 00 00       	jmp    10280d <__alltraps>

0010253d <vector196>:
.globl vector196
vector196:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $196
  10253f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102544:	e9 c4 02 00 00       	jmp    10280d <__alltraps>

00102549 <vector197>:
.globl vector197
vector197:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $197
  10254b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102550:	e9 b8 02 00 00       	jmp    10280d <__alltraps>

00102555 <vector198>:
.globl vector198
vector198:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $198
  102557:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10255c:	e9 ac 02 00 00       	jmp    10280d <__alltraps>

00102561 <vector199>:
.globl vector199
vector199:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $199
  102563:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102568:	e9 a0 02 00 00       	jmp    10280d <__alltraps>

0010256d <vector200>:
.globl vector200
vector200:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $200
  10256f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102574:	e9 94 02 00 00       	jmp    10280d <__alltraps>

00102579 <vector201>:
.globl vector201
vector201:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $201
  10257b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102580:	e9 88 02 00 00       	jmp    10280d <__alltraps>

00102585 <vector202>:
.globl vector202
vector202:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $202
  102587:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10258c:	e9 7c 02 00 00       	jmp    10280d <__alltraps>

00102591 <vector203>:
.globl vector203
vector203:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $203
  102593:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102598:	e9 70 02 00 00       	jmp    10280d <__alltraps>

0010259d <vector204>:
.globl vector204
vector204:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $204
  10259f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025a4:	e9 64 02 00 00       	jmp    10280d <__alltraps>

001025a9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $205
  1025ab:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025b0:	e9 58 02 00 00       	jmp    10280d <__alltraps>

001025b5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $206
  1025b7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025bc:	e9 4c 02 00 00       	jmp    10280d <__alltraps>

001025c1 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $207
  1025c3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025c8:	e9 40 02 00 00       	jmp    10280d <__alltraps>

001025cd <vector208>:
.globl vector208
vector208:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $208
  1025cf:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025d4:	e9 34 02 00 00       	jmp    10280d <__alltraps>

001025d9 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $209
  1025db:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025e0:	e9 28 02 00 00       	jmp    10280d <__alltraps>

001025e5 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $210
  1025e7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025ec:	e9 1c 02 00 00       	jmp    10280d <__alltraps>

001025f1 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $211
  1025f3:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025f8:	e9 10 02 00 00       	jmp    10280d <__alltraps>

001025fd <vector212>:
.globl vector212
vector212:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $212
  1025ff:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102604:	e9 04 02 00 00       	jmp    10280d <__alltraps>

00102609 <vector213>:
.globl vector213
vector213:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $213
  10260b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102610:	e9 f8 01 00 00       	jmp    10280d <__alltraps>

00102615 <vector214>:
.globl vector214
vector214:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $214
  102617:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10261c:	e9 ec 01 00 00       	jmp    10280d <__alltraps>

00102621 <vector215>:
.globl vector215
vector215:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $215
  102623:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102628:	e9 e0 01 00 00       	jmp    10280d <__alltraps>

0010262d <vector216>:
.globl vector216
vector216:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $216
  10262f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102634:	e9 d4 01 00 00       	jmp    10280d <__alltraps>

00102639 <vector217>:
.globl vector217
vector217:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $217
  10263b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102640:	e9 c8 01 00 00       	jmp    10280d <__alltraps>

00102645 <vector218>:
.globl vector218
vector218:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $218
  102647:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10264c:	e9 bc 01 00 00       	jmp    10280d <__alltraps>

00102651 <vector219>:
.globl vector219
vector219:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $219
  102653:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102658:	e9 b0 01 00 00       	jmp    10280d <__alltraps>

0010265d <vector220>:
.globl vector220
vector220:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $220
  10265f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102664:	e9 a4 01 00 00       	jmp    10280d <__alltraps>

00102669 <vector221>:
.globl vector221
vector221:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $221
  10266b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102670:	e9 98 01 00 00       	jmp    10280d <__alltraps>

00102675 <vector222>:
.globl vector222
vector222:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $222
  102677:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10267c:	e9 8c 01 00 00       	jmp    10280d <__alltraps>

00102681 <vector223>:
.globl vector223
vector223:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $223
  102683:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102688:	e9 80 01 00 00       	jmp    10280d <__alltraps>

0010268d <vector224>:
.globl vector224
vector224:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $224
  10268f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102694:	e9 74 01 00 00       	jmp    10280d <__alltraps>

00102699 <vector225>:
.globl vector225
vector225:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $225
  10269b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026a0:	e9 68 01 00 00       	jmp    10280d <__alltraps>

001026a5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $226
  1026a7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026ac:	e9 5c 01 00 00       	jmp    10280d <__alltraps>

001026b1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $227
  1026b3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026b8:	e9 50 01 00 00       	jmp    10280d <__alltraps>

001026bd <vector228>:
.globl vector228
vector228:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $228
  1026bf:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026c4:	e9 44 01 00 00       	jmp    10280d <__alltraps>

001026c9 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $229
  1026cb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026d0:	e9 38 01 00 00       	jmp    10280d <__alltraps>

001026d5 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $230
  1026d7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026dc:	e9 2c 01 00 00       	jmp    10280d <__alltraps>

001026e1 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $231
  1026e3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026e8:	e9 20 01 00 00       	jmp    10280d <__alltraps>

001026ed <vector232>:
.globl vector232
vector232:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $232
  1026ef:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026f4:	e9 14 01 00 00       	jmp    10280d <__alltraps>

001026f9 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $233
  1026fb:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102700:	e9 08 01 00 00       	jmp    10280d <__alltraps>

00102705 <vector234>:
.globl vector234
vector234:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $234
  102707:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10270c:	e9 fc 00 00 00       	jmp    10280d <__alltraps>

00102711 <vector235>:
.globl vector235
vector235:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $235
  102713:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102718:	e9 f0 00 00 00       	jmp    10280d <__alltraps>

0010271d <vector236>:
.globl vector236
vector236:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $236
  10271f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102724:	e9 e4 00 00 00       	jmp    10280d <__alltraps>

00102729 <vector237>:
.globl vector237
vector237:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $237
  10272b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102730:	e9 d8 00 00 00       	jmp    10280d <__alltraps>

00102735 <vector238>:
.globl vector238
vector238:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $238
  102737:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10273c:	e9 cc 00 00 00       	jmp    10280d <__alltraps>

00102741 <vector239>:
.globl vector239
vector239:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $239
  102743:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102748:	e9 c0 00 00 00       	jmp    10280d <__alltraps>

0010274d <vector240>:
.globl vector240
vector240:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $240
  10274f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102754:	e9 b4 00 00 00       	jmp    10280d <__alltraps>

00102759 <vector241>:
.globl vector241
vector241:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $241
  10275b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102760:	e9 a8 00 00 00       	jmp    10280d <__alltraps>

00102765 <vector242>:
.globl vector242
vector242:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $242
  102767:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10276c:	e9 9c 00 00 00       	jmp    10280d <__alltraps>

00102771 <vector243>:
.globl vector243
vector243:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $243
  102773:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102778:	e9 90 00 00 00       	jmp    10280d <__alltraps>

0010277d <vector244>:
.globl vector244
vector244:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $244
  10277f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102784:	e9 84 00 00 00       	jmp    10280d <__alltraps>

00102789 <vector245>:
.globl vector245
vector245:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $245
  10278b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102790:	e9 78 00 00 00       	jmp    10280d <__alltraps>

00102795 <vector246>:
.globl vector246
vector246:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $246
  102797:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10279c:	e9 6c 00 00 00       	jmp    10280d <__alltraps>

001027a1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $247
  1027a3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027a8:	e9 60 00 00 00       	jmp    10280d <__alltraps>

001027ad <vector248>:
.globl vector248
vector248:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $248
  1027af:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027b4:	e9 54 00 00 00       	jmp    10280d <__alltraps>

001027b9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $249
  1027bb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027c0:	e9 48 00 00 00       	jmp    10280d <__alltraps>

001027c5 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $250
  1027c7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027cc:	e9 3c 00 00 00       	jmp    10280d <__alltraps>

001027d1 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $251
  1027d3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027d8:	e9 30 00 00 00       	jmp    10280d <__alltraps>

001027dd <vector252>:
.globl vector252
vector252:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $252
  1027df:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027e4:	e9 24 00 00 00       	jmp    10280d <__alltraps>

001027e9 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $253
  1027eb:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027f0:	e9 18 00 00 00       	jmp    10280d <__alltraps>

001027f5 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $254
  1027f7:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027fc:	e9 0c 00 00 00       	jmp    10280d <__alltraps>

00102801 <vector255>:
.globl vector255
vector255:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $255
  102803:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102808:	e9 00 00 00 00       	jmp    10280d <__alltraps>

0010280d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10280d:	1e                   	push   %ds
    pushl %es
  10280e:	06                   	push   %es
    pushl %fs
  10280f:	0f a0                	push   %fs
    pushl %gs
  102811:	0f a8                	push   %gs
    pushal
  102813:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102814:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102819:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10281b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10281d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10281e:	e8 64 f5 ff ff       	call   101d87 <trap>

    # pop the pushed stack pointer
    popl %esp
  102823:	5c                   	pop    %esp

00102824 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102824:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102825:	0f a9                	pop    %gs
    popl %fs
  102827:	0f a1                	pop    %fs
    popl %es
  102829:	07                   	pop    %es
    popl %ds
  10282a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10282b:	83 c4 08             	add    $0x8,%esp
    iret
  10282e:	cf                   	iret   

0010282f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10282f:	55                   	push   %ebp
  102830:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102832:	8b 45 08             	mov    0x8(%ebp),%eax
  102835:	8b 15 38 af 11 00    	mov    0x11af38,%edx
  10283b:	29 d0                	sub    %edx,%eax
  10283d:	c1 f8 02             	sar    $0x2,%eax
  102840:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102846:	5d                   	pop    %ebp
  102847:	c3                   	ret    

00102848 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102848:	55                   	push   %ebp
  102849:	89 e5                	mov    %esp,%ebp
  10284b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10284e:	8b 45 08             	mov    0x8(%ebp),%eax
  102851:	89 04 24             	mov    %eax,(%esp)
  102854:	e8 d6 ff ff ff       	call   10282f <page2ppn>
  102859:	c1 e0 0c             	shl    $0xc,%eax
}
  10285c:	c9                   	leave  
  10285d:	c3                   	ret    

0010285e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  10285e:	55                   	push   %ebp
  10285f:	89 e5                	mov    %esp,%ebp
  102861:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102864:	8b 45 08             	mov    0x8(%ebp),%eax
  102867:	c1 e8 0c             	shr    $0xc,%eax
  10286a:	89 c2                	mov    %eax,%edx
  10286c:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  102871:	39 c2                	cmp    %eax,%edx
  102873:	72 1c                	jb     102891 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102875:	c7 44 24 08 90 66 10 	movl   $0x106690,0x8(%esp)
  10287c:	00 
  10287d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102884:	00 
  102885:	c7 04 24 af 66 10 00 	movl   $0x1066af,(%esp)
  10288c:	e8 58 db ff ff       	call   1003e9 <__panic>
    }
    return &pages[PPN(pa)];
  102891:	8b 0d 38 af 11 00    	mov    0x11af38,%ecx
  102897:	8b 45 08             	mov    0x8(%ebp),%eax
  10289a:	c1 e8 0c             	shr    $0xc,%eax
  10289d:	89 c2                	mov    %eax,%edx
  10289f:	89 d0                	mov    %edx,%eax
  1028a1:	c1 e0 02             	shl    $0x2,%eax
  1028a4:	01 d0                	add    %edx,%eax
  1028a6:	c1 e0 02             	shl    $0x2,%eax
  1028a9:	01 c8                	add    %ecx,%eax
}
  1028ab:	c9                   	leave  
  1028ac:	c3                   	ret    

001028ad <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1028ad:	55                   	push   %ebp
  1028ae:	89 e5                	mov    %esp,%ebp
  1028b0:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b6:	89 04 24             	mov    %eax,(%esp)
  1028b9:	e8 8a ff ff ff       	call   102848 <page2pa>
  1028be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028c4:	c1 e8 0c             	shr    $0xc,%eax
  1028c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1028ca:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  1028cf:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1028d2:	72 23                	jb     1028f7 <page2kva+0x4a>
  1028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1028db:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  1028e2:	00 
  1028e3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  1028ea:	00 
  1028eb:	c7 04 24 af 66 10 00 	movl   $0x1066af,(%esp)
  1028f2:	e8 f2 da ff ff       	call   1003e9 <__panic>
  1028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028fa:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1028ff:	c9                   	leave  
  102900:	c3                   	ret    

00102901 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102901:	55                   	push   %ebp
  102902:	89 e5                	mov    %esp,%ebp
  102904:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102907:	8b 45 08             	mov    0x8(%ebp),%eax
  10290a:	83 e0 01             	and    $0x1,%eax
  10290d:	85 c0                	test   %eax,%eax
  10290f:	75 1c                	jne    10292d <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102911:	c7 44 24 08 e4 66 10 	movl   $0x1066e4,0x8(%esp)
  102918:	00 
  102919:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102920:	00 
  102921:	c7 04 24 af 66 10 00 	movl   $0x1066af,(%esp)
  102928:	e8 bc da ff ff       	call   1003e9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  10292d:	8b 45 08             	mov    0x8(%ebp),%eax
  102930:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102935:	89 04 24             	mov    %eax,(%esp)
  102938:	e8 21 ff ff ff       	call   10285e <pa2page>
}
  10293d:	c9                   	leave  
  10293e:	c3                   	ret    

0010293f <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  10293f:	55                   	push   %ebp
  102940:	89 e5                	mov    %esp,%ebp
  102942:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102945:	8b 45 08             	mov    0x8(%ebp),%eax
  102948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10294d:	89 04 24             	mov    %eax,(%esp)
  102950:	e8 09 ff ff ff       	call   10285e <pa2page>
}
  102955:	c9                   	leave  
  102956:	c3                   	ret    

00102957 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102957:	55                   	push   %ebp
  102958:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10295a:	8b 45 08             	mov    0x8(%ebp),%eax
  10295d:	8b 00                	mov    (%eax),%eax
}
  10295f:	5d                   	pop    %ebp
  102960:	c3                   	ret    

00102961 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102961:	55                   	push   %ebp
  102962:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102964:	8b 45 08             	mov    0x8(%ebp),%eax
  102967:	8b 55 0c             	mov    0xc(%ebp),%edx
  10296a:	89 10                	mov    %edx,(%eax)
}
  10296c:	90                   	nop
  10296d:	5d                   	pop    %ebp
  10296e:	c3                   	ret    

0010296f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  10296f:	55                   	push   %ebp
  102970:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102972:	8b 45 08             	mov    0x8(%ebp),%eax
  102975:	8b 00                	mov    (%eax),%eax
  102977:	8d 50 01             	lea    0x1(%eax),%edx
  10297a:	8b 45 08             	mov    0x8(%ebp),%eax
  10297d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  10297f:	8b 45 08             	mov    0x8(%ebp),%eax
  102982:	8b 00                	mov    (%eax),%eax
}
  102984:	5d                   	pop    %ebp
  102985:	c3                   	ret    

00102986 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102986:	55                   	push   %ebp
  102987:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102989:	8b 45 08             	mov    0x8(%ebp),%eax
  10298c:	8b 00                	mov    (%eax),%eax
  10298e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102991:	8b 45 08             	mov    0x8(%ebp),%eax
  102994:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102996:	8b 45 08             	mov    0x8(%ebp),%eax
  102999:	8b 00                	mov    (%eax),%eax
}
  10299b:	5d                   	pop    %ebp
  10299c:	c3                   	ret    

0010299d <__intr_save>:
__intr_save(void) {
  10299d:	55                   	push   %ebp
  10299e:	89 e5                	mov    %esp,%ebp
  1029a0:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  1029a3:	9c                   	pushf  
  1029a4:	58                   	pop    %eax
  1029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  1029ab:	25 00 02 00 00       	and    $0x200,%eax
  1029b0:	85 c0                	test   %eax,%eax
  1029b2:	74 0c                	je     1029c0 <__intr_save+0x23>
        intr_disable();
  1029b4:	e8 d4 ee ff ff       	call   10188d <intr_disable>
        return 1;
  1029b9:	b8 01 00 00 00       	mov    $0x1,%eax
  1029be:	eb 05                	jmp    1029c5 <__intr_save+0x28>
    return 0;
  1029c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1029c5:	c9                   	leave  
  1029c6:	c3                   	ret    

001029c7 <__intr_restore>:
__intr_restore(bool flag) {
  1029c7:	55                   	push   %ebp
  1029c8:	89 e5                	mov    %esp,%ebp
  1029ca:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  1029cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029d1:	74 05                	je     1029d8 <__intr_restore+0x11>
        intr_enable();
  1029d3:	e8 ae ee ff ff       	call   101886 <intr_enable>
}
  1029d8:	90                   	nop
  1029d9:	c9                   	leave  
  1029da:	c3                   	ret    

001029db <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029db:	55                   	push   %ebp
  1029dc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029de:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029e4:	b8 23 00 00 00       	mov    $0x23,%eax
  1029e9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029eb:	b8 23 00 00 00       	mov    $0x23,%eax
  1029f0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029f2:	b8 10 00 00 00       	mov    $0x10,%eax
  1029f7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029f9:	b8 10 00 00 00       	mov    $0x10,%eax
  1029fe:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a00:	b8 10 00 00 00       	mov    $0x10,%eax
  102a05:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a07:	ea 0e 2a 10 00 08 00 	ljmp   $0x8,$0x102a0e
}
  102a0e:	90                   	nop
  102a0f:	5d                   	pop    %ebp
  102a10:	c3                   	ret    

00102a11 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102a11:	55                   	push   %ebp
  102a12:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102a14:	8b 45 08             	mov    0x8(%ebp),%eax
  102a17:	a3 c4 ae 11 00       	mov    %eax,0x11aec4
}
  102a1c:	90                   	nop
  102a1d:	5d                   	pop    %ebp
  102a1e:	c3                   	ret    

00102a1f <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a1f:	55                   	push   %ebp
  102a20:	89 e5                	mov    %esp,%ebp
  102a22:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102a25:	b8 00 70 11 00       	mov    $0x117000,%eax
  102a2a:	89 04 24             	mov    %eax,(%esp)
  102a2d:	e8 df ff ff ff       	call   102a11 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102a32:	66 c7 05 c8 ae 11 00 	movw   $0x10,0x11aec8
  102a39:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102a3b:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102a42:	68 00 
  102a44:	b8 c0 ae 11 00       	mov    $0x11aec0,%eax
  102a49:	0f b7 c0             	movzwl %ax,%eax
  102a4c:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102a52:	b8 c0 ae 11 00       	mov    $0x11aec0,%eax
  102a57:	c1 e8 10             	shr    $0x10,%eax
  102a5a:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102a5f:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a66:	24 f0                	and    $0xf0,%al
  102a68:	0c 09                	or     $0x9,%al
  102a6a:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a6f:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a76:	24 ef                	and    $0xef,%al
  102a78:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a7d:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a84:	24 9f                	and    $0x9f,%al
  102a86:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a8b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a92:	0c 80                	or     $0x80,%al
  102a94:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a99:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102aa0:	24 f0                	and    $0xf0,%al
  102aa2:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102aa7:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102aae:	24 ef                	and    $0xef,%al
  102ab0:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ab5:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102abc:	24 df                	and    $0xdf,%al
  102abe:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ac3:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102aca:	0c 40                	or     $0x40,%al
  102acc:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ad1:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102ad8:	24 7f                	and    $0x7f,%al
  102ada:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102adf:	b8 c0 ae 11 00       	mov    $0x11aec0,%eax
  102ae4:	c1 e8 18             	shr    $0x18,%eax
  102ae7:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102aec:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  102af3:	e8 e3 fe ff ff       	call   1029db <lgdt>
  102af8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102afe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b02:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b05:	90                   	nop
  102b06:	c9                   	leave  
  102b07:	c3                   	ret    

00102b08 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102b08:	55                   	push   %ebp
  102b09:	89 e5                	mov    %esp,%ebp
  102b0b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102b0e:	c7 05 30 af 11 00 70 	movl   $0x107070,0x11af30
  102b15:	70 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102b18:	a1 30 af 11 00       	mov    0x11af30,%eax
  102b1d:	8b 00                	mov    (%eax),%eax
  102b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b23:	c7 04 24 10 67 10 00 	movl   $0x106710,(%esp)
  102b2a:	e8 63 d7 ff ff       	call   100292 <cprintf>
    pmm_manager->init();
  102b2f:	a1 30 af 11 00       	mov    0x11af30,%eax
  102b34:	8b 40 04             	mov    0x4(%eax),%eax
  102b37:	ff d0                	call   *%eax
}
  102b39:	90                   	nop
  102b3a:	c9                   	leave  
  102b3b:	c3                   	ret    

00102b3c <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102b3c:	55                   	push   %ebp
  102b3d:	89 e5                	mov    %esp,%ebp
  102b3f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102b42:	a1 30 af 11 00       	mov    0x11af30,%eax
  102b47:	8b 40 08             	mov    0x8(%eax),%eax
  102b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b4d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b51:	8b 55 08             	mov    0x8(%ebp),%edx
  102b54:	89 14 24             	mov    %edx,(%esp)
  102b57:	ff d0                	call   *%eax
}
  102b59:	90                   	nop
  102b5a:	c9                   	leave  
  102b5b:	c3                   	ret    

00102b5c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102b5c:	55                   	push   %ebp
  102b5d:	89 e5                	mov    %esp,%ebp
  102b5f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102b69:	e8 2f fe ff ff       	call   10299d <__intr_save>
  102b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102b71:	a1 30 af 11 00       	mov    0x11af30,%eax
  102b76:	8b 40 0c             	mov    0xc(%eax),%eax
  102b79:	8b 55 08             	mov    0x8(%ebp),%edx
  102b7c:	89 14 24             	mov    %edx,(%esp)
  102b7f:	ff d0                	call   *%eax
  102b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b87:	89 04 24             	mov    %eax,(%esp)
  102b8a:	e8 38 fe ff ff       	call   1029c7 <__intr_restore>
    return page;
  102b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102b92:	c9                   	leave  
  102b93:	c3                   	ret    

00102b94 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102b94:	55                   	push   %ebp
  102b95:	89 e5                	mov    %esp,%ebp
  102b97:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102b9a:	e8 fe fd ff ff       	call   10299d <__intr_save>
  102b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102ba2:	a1 30 af 11 00       	mov    0x11af30,%eax
  102ba7:	8b 40 10             	mov    0x10(%eax),%eax
  102baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bad:	89 54 24 04          	mov    %edx,0x4(%esp)
  102bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  102bb4:	89 14 24             	mov    %edx,(%esp)
  102bb7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bbc:	89 04 24             	mov    %eax,(%esp)
  102bbf:	e8 03 fe ff ff       	call   1029c7 <__intr_restore>
}
  102bc4:	90                   	nop
  102bc5:	c9                   	leave  
  102bc6:	c3                   	ret    

00102bc7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102bc7:	55                   	push   %ebp
  102bc8:	89 e5                	mov    %esp,%ebp
  102bca:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102bcd:	e8 cb fd ff ff       	call   10299d <__intr_save>
  102bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102bd5:	a1 30 af 11 00       	mov    0x11af30,%eax
  102bda:	8b 40 14             	mov    0x14(%eax),%eax
  102bdd:	ff d0                	call   *%eax
  102bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be5:	89 04 24             	mov    %eax,(%esp)
  102be8:	e8 da fd ff ff       	call   1029c7 <__intr_restore>
    return ret;
  102bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102bf0:	c9                   	leave  
  102bf1:	c3                   	ret    

00102bf2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102bf2:	55                   	push   %ebp
  102bf3:	89 e5                	mov    %esp,%ebp
  102bf5:	57                   	push   %edi
  102bf6:	56                   	push   %esi
  102bf7:	53                   	push   %ebx
  102bf8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102bfe:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102c05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102c0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102c13:	c7 04 24 27 67 10 00 	movl   $0x106727,(%esp)
  102c1a:	e8 73 d6 ff ff       	call   100292 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102c1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c26:	e9 22 01 00 00       	jmp    102d4d <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102c2b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c31:	89 d0                	mov    %edx,%eax
  102c33:	c1 e0 02             	shl    $0x2,%eax
  102c36:	01 d0                	add    %edx,%eax
  102c38:	c1 e0 02             	shl    $0x2,%eax
  102c3b:	01 c8                	add    %ecx,%eax
  102c3d:	8b 50 08             	mov    0x8(%eax),%edx
  102c40:	8b 40 04             	mov    0x4(%eax),%eax
  102c43:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102c46:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102c49:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c4f:	89 d0                	mov    %edx,%eax
  102c51:	c1 e0 02             	shl    $0x2,%eax
  102c54:	01 d0                	add    %edx,%eax
  102c56:	c1 e0 02             	shl    $0x2,%eax
  102c59:	01 c8                	add    %ecx,%eax
  102c5b:	8b 48 0c             	mov    0xc(%eax),%ecx
  102c5e:	8b 58 10             	mov    0x10(%eax),%ebx
  102c61:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102c64:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102c67:	01 c8                	add    %ecx,%eax
  102c69:	11 da                	adc    %ebx,%edx
  102c6b:	89 45 98             	mov    %eax,-0x68(%ebp)
  102c6e:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102c71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c74:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c77:	89 d0                	mov    %edx,%eax
  102c79:	c1 e0 02             	shl    $0x2,%eax
  102c7c:	01 d0                	add    %edx,%eax
  102c7e:	c1 e0 02             	shl    $0x2,%eax
  102c81:	01 c8                	add    %ecx,%eax
  102c83:	83 c0 14             	add    $0x14,%eax
  102c86:	8b 00                	mov    (%eax),%eax
  102c88:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102c8b:	8b 45 98             	mov    -0x68(%ebp),%eax
  102c8e:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102c91:	83 c0 ff             	add    $0xffffffff,%eax
  102c94:	83 d2 ff             	adc    $0xffffffff,%edx
  102c97:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102c9d:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102ca3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ca6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ca9:	89 d0                	mov    %edx,%eax
  102cab:	c1 e0 02             	shl    $0x2,%eax
  102cae:	01 d0                	add    %edx,%eax
  102cb0:	c1 e0 02             	shl    $0x2,%eax
  102cb3:	01 c8                	add    %ecx,%eax
  102cb5:	8b 48 0c             	mov    0xc(%eax),%ecx
  102cb8:	8b 58 10             	mov    0x10(%eax),%ebx
  102cbb:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102cbe:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102cc2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102cc8:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102cce:	89 44 24 14          	mov    %eax,0x14(%esp)
  102cd2:	89 54 24 18          	mov    %edx,0x18(%esp)
  102cd6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102cd9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102cdc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ce0:	89 54 24 10          	mov    %edx,0x10(%esp)
  102ce4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102ce8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102cec:	c7 04 24 34 67 10 00 	movl   $0x106734,(%esp)
  102cf3:	e8 9a d5 ff ff       	call   100292 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102cf8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cfe:	89 d0                	mov    %edx,%eax
  102d00:	c1 e0 02             	shl    $0x2,%eax
  102d03:	01 d0                	add    %edx,%eax
  102d05:	c1 e0 02             	shl    $0x2,%eax
  102d08:	01 c8                	add    %ecx,%eax
  102d0a:	83 c0 14             	add    $0x14,%eax
  102d0d:	8b 00                	mov    (%eax),%eax
  102d0f:	83 f8 01             	cmp    $0x1,%eax
  102d12:	75 36                	jne    102d4a <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
  102d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d1a:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102d1d:	77 2b                	ja     102d4a <page_init+0x158>
  102d1f:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102d22:	72 05                	jb     102d29 <page_init+0x137>
  102d24:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102d27:	73 21                	jae    102d4a <page_init+0x158>
  102d29:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102d2d:	77 1b                	ja     102d4a <page_init+0x158>
  102d2f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102d33:	72 09                	jb     102d3e <page_init+0x14c>
  102d35:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  102d3c:	77 0c                	ja     102d4a <page_init+0x158>
                maxpa = end;
  102d3e:	8b 45 98             	mov    -0x68(%ebp),%eax
  102d41:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d47:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102d4a:	ff 45 dc             	incl   -0x24(%ebp)
  102d4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d50:	8b 00                	mov    (%eax),%eax
  102d52:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102d55:	0f 8c d0 fe ff ff    	jl     102c2b <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102d5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d5f:	72 1d                	jb     102d7e <page_init+0x18c>
  102d61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d65:	77 09                	ja     102d70 <page_init+0x17e>
  102d67:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102d6e:	76 0e                	jbe    102d7e <page_init+0x18c>
        maxpa = KMEMSIZE;
  102d70:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102d77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d84:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102d88:	c1 ea 0c             	shr    $0xc,%edx
  102d8b:	89 c1                	mov    %eax,%ecx
  102d8d:	89 d3                	mov    %edx,%ebx
  102d8f:	89 c8                	mov    %ecx,%eax
  102d91:	a3 a0 ae 11 00       	mov    %eax,0x11aea0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102d96:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102d9d:	b8 48 af 11 00       	mov    $0x11af48,%eax
  102da2:	8d 50 ff             	lea    -0x1(%eax),%edx
  102da5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102da8:	01 d0                	add    %edx,%eax
  102daa:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102dad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102db0:	ba 00 00 00 00       	mov    $0x0,%edx
  102db5:	f7 75 c0             	divl   -0x40(%ebp)
  102db8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102dbb:	29 d0                	sub    %edx,%eax
  102dbd:	a3 38 af 11 00       	mov    %eax,0x11af38

    for (i = 0; i < npage; i ++) {
  102dc2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102dc9:	eb 2e                	jmp    102df9 <page_init+0x207>
        SetPageReserved(pages + i);
  102dcb:	8b 0d 38 af 11 00    	mov    0x11af38,%ecx
  102dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dd4:	89 d0                	mov    %edx,%eax
  102dd6:	c1 e0 02             	shl    $0x2,%eax
  102dd9:	01 d0                	add    %edx,%eax
  102ddb:	c1 e0 02             	shl    $0x2,%eax
  102dde:	01 c8                	add    %ecx,%eax
  102de0:	83 c0 04             	add    $0x4,%eax
  102de3:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102dea:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ded:	8b 45 90             	mov    -0x70(%ebp),%eax
  102df0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102df3:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  102df6:	ff 45 dc             	incl   -0x24(%ebp)
  102df9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dfc:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  102e01:	39 c2                	cmp    %eax,%edx
  102e03:	72 c6                	jb     102dcb <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102e05:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  102e0b:	89 d0                	mov    %edx,%eax
  102e0d:	c1 e0 02             	shl    $0x2,%eax
  102e10:	01 d0                	add    %edx,%eax
  102e12:	c1 e0 02             	shl    $0x2,%eax
  102e15:	89 c2                	mov    %eax,%edx
  102e17:	a1 38 af 11 00       	mov    0x11af38,%eax
  102e1c:	01 d0                	add    %edx,%eax
  102e1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102e21:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  102e28:	77 23                	ja     102e4d <page_init+0x25b>
  102e2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e31:	c7 44 24 08 64 67 10 	movl   $0x106764,0x8(%esp)
  102e38:	00 
  102e39:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102e40:	00 
  102e41:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  102e48:	e8 9c d5 ff ff       	call   1003e9 <__panic>
  102e4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e50:	05 00 00 00 40       	add    $0x40000000,%eax
  102e55:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102e58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e5f:	e9 69 01 00 00       	jmp    102fcd <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e64:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e6a:	89 d0                	mov    %edx,%eax
  102e6c:	c1 e0 02             	shl    $0x2,%eax
  102e6f:	01 d0                	add    %edx,%eax
  102e71:	c1 e0 02             	shl    $0x2,%eax
  102e74:	01 c8                	add    %ecx,%eax
  102e76:	8b 50 08             	mov    0x8(%eax),%edx
  102e79:	8b 40 04             	mov    0x4(%eax),%eax
  102e7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e7f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e82:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e85:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e88:	89 d0                	mov    %edx,%eax
  102e8a:	c1 e0 02             	shl    $0x2,%eax
  102e8d:	01 d0                	add    %edx,%eax
  102e8f:	c1 e0 02             	shl    $0x2,%eax
  102e92:	01 c8                	add    %ecx,%eax
  102e94:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e97:	8b 58 10             	mov    0x10(%eax),%ebx
  102e9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ea0:	01 c8                	add    %ecx,%eax
  102ea2:	11 da                	adc    %ebx,%edx
  102ea4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ea7:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102eaa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ead:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102eb0:	89 d0                	mov    %edx,%eax
  102eb2:	c1 e0 02             	shl    $0x2,%eax
  102eb5:	01 d0                	add    %edx,%eax
  102eb7:	c1 e0 02             	shl    $0x2,%eax
  102eba:	01 c8                	add    %ecx,%eax
  102ebc:	83 c0 14             	add    $0x14,%eax
  102ebf:	8b 00                	mov    (%eax),%eax
  102ec1:	83 f8 01             	cmp    $0x1,%eax
  102ec4:	0f 85 00 01 00 00    	jne    102fca <page_init+0x3d8>
            if (begin < freemem) {
  102eca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  102ed2:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102ed5:	77 17                	ja     102eee <page_init+0x2fc>
  102ed7:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102eda:	72 05                	jb     102ee1 <page_init+0x2ef>
  102edc:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102edf:	73 0d                	jae    102eee <page_init+0x2fc>
                begin = freemem;
  102ee1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ee4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ee7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102eee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102ef2:	72 1d                	jb     102f11 <page_init+0x31f>
  102ef4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102ef8:	77 09                	ja     102f03 <page_init+0x311>
  102efa:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102f01:	76 0e                	jbe    102f11 <page_init+0x31f>
                end = KMEMSIZE;
  102f03:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102f0a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102f11:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f17:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f1a:	0f 87 aa 00 00 00    	ja     102fca <page_init+0x3d8>
  102f20:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f23:	72 09                	jb     102f2e <page_init+0x33c>
  102f25:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f28:	0f 83 9c 00 00 00    	jae    102fca <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
  102f2e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  102f35:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f38:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102f3b:	01 d0                	add    %edx,%eax
  102f3d:	48                   	dec    %eax
  102f3e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102f41:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f44:	ba 00 00 00 00       	mov    $0x0,%edx
  102f49:	f7 75 b0             	divl   -0x50(%ebp)
  102f4c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f4f:	29 d0                	sub    %edx,%eax
  102f51:	ba 00 00 00 00       	mov    $0x0,%edx
  102f56:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f59:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102f5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f5f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102f62:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f65:	ba 00 00 00 00       	mov    $0x0,%edx
  102f6a:	89 c3                	mov    %eax,%ebx
  102f6c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102f72:	89 de                	mov    %ebx,%esi
  102f74:	89 d0                	mov    %edx,%eax
  102f76:	83 e0 00             	and    $0x0,%eax
  102f79:	89 c7                	mov    %eax,%edi
  102f7b:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102f7e:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102f81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f87:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f8a:	77 3e                	ja     102fca <page_init+0x3d8>
  102f8c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f8f:	72 05                	jb     102f96 <page_init+0x3a4>
  102f91:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f94:	73 34                	jae    102fca <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102f96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f99:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102f9c:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102f9f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102fa2:	89 c1                	mov    %eax,%ecx
  102fa4:	89 d3                	mov    %edx,%ebx
  102fa6:	89 c8                	mov    %ecx,%eax
  102fa8:	89 da                	mov    %ebx,%edx
  102faa:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102fae:	c1 ea 0c             	shr    $0xc,%edx
  102fb1:	89 c3                	mov    %eax,%ebx
  102fb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fb6:	89 04 24             	mov    %eax,(%esp)
  102fb9:	e8 a0 f8 ff ff       	call   10285e <pa2page>
  102fbe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102fc2:	89 04 24             	mov    %eax,(%esp)
  102fc5:	e8 72 fb ff ff       	call   102b3c <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  102fca:	ff 45 dc             	incl   -0x24(%ebp)
  102fcd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102fd0:	8b 00                	mov    (%eax),%eax
  102fd2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102fd5:	0f 8c 89 fe ff ff    	jl     102e64 <page_init+0x272>
                }
            }
        }
    }
}
  102fdb:	90                   	nop
  102fdc:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  102fe2:	5b                   	pop    %ebx
  102fe3:	5e                   	pop    %esi
  102fe4:	5f                   	pop    %edi
  102fe5:	5d                   	pop    %ebp
  102fe6:	c3                   	ret    

00102fe7 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  102fe7:	55                   	push   %ebp
  102fe8:	89 e5                	mov    %esp,%ebp
  102fea:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  102fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff0:	33 45 14             	xor    0x14(%ebp),%eax
  102ff3:	25 ff 0f 00 00       	and    $0xfff,%eax
  102ff8:	85 c0                	test   %eax,%eax
  102ffa:	74 24                	je     103020 <boot_map_segment+0x39>
  102ffc:	c7 44 24 0c 96 67 10 	movl   $0x106796,0xc(%esp)
  103003:	00 
  103004:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  10300b:	00 
  10300c:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103013:	00 
  103014:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  10301b:	e8 c9 d3 ff ff       	call   1003e9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103020:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103027:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302a:	25 ff 0f 00 00       	and    $0xfff,%eax
  10302f:	89 c2                	mov    %eax,%edx
  103031:	8b 45 10             	mov    0x10(%ebp),%eax
  103034:	01 c2                	add    %eax,%edx
  103036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103039:	01 d0                	add    %edx,%eax
  10303b:	48                   	dec    %eax
  10303c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103042:	ba 00 00 00 00       	mov    $0x0,%edx
  103047:	f7 75 f0             	divl   -0x10(%ebp)
  10304a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10304d:	29 d0                	sub    %edx,%eax
  10304f:	c1 e8 0c             	shr    $0xc,%eax
  103052:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103055:	8b 45 0c             	mov    0xc(%ebp),%eax
  103058:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10305e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103063:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103066:	8b 45 14             	mov    0x14(%ebp),%eax
  103069:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10306c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10306f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103074:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103077:	eb 68                	jmp    1030e1 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103079:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103080:	00 
  103081:	8b 45 0c             	mov    0xc(%ebp),%eax
  103084:	89 44 24 04          	mov    %eax,0x4(%esp)
  103088:	8b 45 08             	mov    0x8(%ebp),%eax
  10308b:	89 04 24             	mov    %eax,(%esp)
  10308e:	e8 81 01 00 00       	call   103214 <get_pte>
  103093:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103096:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10309a:	75 24                	jne    1030c0 <boot_map_segment+0xd9>
  10309c:	c7 44 24 0c c2 67 10 	movl   $0x1067c2,0xc(%esp)
  1030a3:	00 
  1030a4:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  1030ab:	00 
  1030ac:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1030b3:	00 
  1030b4:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1030bb:	e8 29 d3 ff ff       	call   1003e9 <__panic>
        *ptep = pa | PTE_P | perm;
  1030c0:	8b 45 14             	mov    0x14(%ebp),%eax
  1030c3:	0b 45 18             	or     0x18(%ebp),%eax
  1030c6:	83 c8 01             	or     $0x1,%eax
  1030c9:	89 c2                	mov    %eax,%edx
  1030cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030ce:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1030d0:	ff 4d f4             	decl   -0xc(%ebp)
  1030d3:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1030da:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1030e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030e5:	75 92                	jne    103079 <boot_map_segment+0x92>
    }
}
  1030e7:	90                   	nop
  1030e8:	c9                   	leave  
  1030e9:	c3                   	ret    

001030ea <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1030ea:	55                   	push   %ebp
  1030eb:	89 e5                	mov    %esp,%ebp
  1030ed:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1030f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030f7:	e8 60 fa ff ff       	call   102b5c <alloc_pages>
  1030fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1030ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103103:	75 1c                	jne    103121 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  103105:	c7 44 24 08 cf 67 10 	movl   $0x1067cf,0x8(%esp)
  10310c:	00 
  10310d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103114:	00 
  103115:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  10311c:	e8 c8 d2 ff ff       	call   1003e9 <__panic>
    }
    return page2kva(p);
  103121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103124:	89 04 24             	mov    %eax,(%esp)
  103127:	e8 81 f7 ff ff       	call   1028ad <page2kva>
}
  10312c:	c9                   	leave  
  10312d:	c3                   	ret    

0010312e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10312e:	55                   	push   %ebp
  10312f:	89 e5                	mov    %esp,%ebp
  103131:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  103134:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10313c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103143:	77 23                	ja     103168 <pmm_init+0x3a>
  103145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103148:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10314c:	c7 44 24 08 64 67 10 	movl   $0x106764,0x8(%esp)
  103153:	00 
  103154:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10315b:	00 
  10315c:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103163:	e8 81 d2 ff ff       	call   1003e9 <__panic>
  103168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10316b:	05 00 00 00 40       	add    $0x40000000,%eax
  103170:	a3 34 af 11 00       	mov    %eax,0x11af34
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103175:	e8 8e f9 ff ff       	call   102b08 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10317a:	e8 73 fa ff ff       	call   102bf2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10317f:	e8 20 04 00 00       	call   1035a4 <check_alloc_page>

    check_pgdir();
  103184:	e8 3a 04 00 00       	call   1035c3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103189:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10318e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103191:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103198:	77 23                	ja     1031bd <pmm_init+0x8f>
  10319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10319d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031a1:	c7 44 24 08 64 67 10 	movl   $0x106764,0x8(%esp)
  1031a8:	00 
  1031a9:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1031b0:	00 
  1031b1:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1031b8:	e8 2c d2 ff ff       	call   1003e9 <__panic>
  1031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c0:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1031c6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1031cb:	05 ac 0f 00 00       	add    $0xfac,%eax
  1031d0:	83 ca 03             	or     $0x3,%edx
  1031d3:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1031d5:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1031da:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1031e1:	00 
  1031e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1031e9:	00 
  1031ea:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1031f1:	38 
  1031f2:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1031f9:	c0 
  1031fa:	89 04 24             	mov    %eax,(%esp)
  1031fd:	e8 e5 fd ff ff       	call   102fe7 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103202:	e8 18 f8 ff ff       	call   102a1f <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103207:	e8 53 0a 00 00       	call   103c5f <check_boot_pgdir>

    print_pgdir();
  10320c:	e8 cc 0e 00 00       	call   1040dd <print_pgdir>

}
  103211:	90                   	nop
  103212:	c9                   	leave  
  103213:	c3                   	ret    

00103214 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103214:	55                   	push   %ebp
  103215:	89 e5                	mov    %esp,%ebp
  103217:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

    pde_t *pdep = pgdir + PDX(la); //PDX意为取前十位的页表目录索引
  10321a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321d:	c1 e8 16             	shr    $0x16,%eax
  103220:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103227:	8b 45 08             	mov    0x8(%ebp),%eax
  10322a:	01 d0                	add    %edx,%eax
  10322c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pte_t *ptep = ((pte_t *) (KADDR(*pdep & ~0XFFF)) + PTX(la)); 
  10322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103232:	8b 00                	mov    (%eax),%eax
  103234:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103239:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10323f:	c1 e8 0c             	shr    $0xc,%eax
  103242:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103245:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  10324a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10324d:	72 23                	jb     103272 <get_pte+0x5e>
  10324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103252:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103256:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  10325d:	00 
  10325e:	c7 44 24 04 60 01 00 	movl   $0x160,0x4(%esp)
  103265:	00 
  103266:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  10326d:	e8 77 d1 ff ff       	call   1003e9 <__panic>
  103272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103275:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10327a:	89 c2                	mov    %eax,%edx
  10327c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10327f:	c1 e8 0c             	shr    $0xc,%eax
  103282:	25 ff 03 00 00       	and    $0x3ff,%eax
  103287:	c1 e0 02             	shl    $0x2,%eax
  10328a:	01 d0                	add    %edx,%eax
  10328c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    //得到二级页表的首地址后用PTX计算二级页表中的索引
    if (*pdep & PTE_P) 
  10328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103292:	8b 00                	mov    (%eax),%eax
  103294:	83 e0 01             	and    $0x1,%eax
  103297:	85 c0                	test   %eax,%eax
  103299:	74 08                	je     1032a3 <get_pte+0x8f>
        return ptep; 
  10329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10329e:	e9 dd 00 00 00       	jmp    103380 <get_pte+0x16c>
    //返回存在的页表项，对于不存在的页表项根据create参数决定是否创建
    if (!create) 
  1032a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032a7:	75 0a                	jne    1032b3 <get_pte+0x9f>
        return NULL;
  1032a9:	b8 00 00 00 00       	mov    $0x0,%eax
  1032ae:	e9 cd 00 00 00       	jmp    103380 <get_pte+0x16c>
    struct Page* pt = alloc_page();
  1032b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032ba:	e8 9d f8 ff ff       	call   102b5c <alloc_pages>
  1032bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (pt == NULL) 
  1032c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1032c6:	75 0a                	jne    1032d2 <get_pte+0xbe>
        return NULL;
  1032c8:	b8 00 00 00 00       	mov    $0x0,%eax
  1032cd:	e9 ae 00 00 00       	jmp    103380 <get_pte+0x16c>
    set_page_ref(pt, 1);
  1032d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032d9:	00 
  1032da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032dd:	89 04 24             	mov    %eax,(%esp)
  1032e0:	e8 7c f6 ff ff       	call   102961 <set_page_ref>
    //分配一个新的内存页来存储新的页表项
    ptep = KADDR(page2pa(pt)); //页面->物理地址->虚拟地址
  1032e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032e8:	89 04 24             	mov    %eax,(%esp)
  1032eb:	e8 58 f5 ff ff       	call   102848 <page2pa>
  1032f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1032f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032f6:	c1 e8 0c             	shr    $0xc,%eax
  1032f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1032fc:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  103301:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103304:	72 23                	jb     103329 <get_pte+0x115>
  103306:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103309:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10330d:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  103314:	00 
  103315:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
  10331c:	00 
  10331d:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103324:	e8 c0 d0 ff ff       	call   1003e9 <__panic>
  103329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10332c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103331:	89 45 e8             	mov    %eax,-0x18(%ebp)
    memset(ptep, 0, PGSIZE); 
  103334:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10333b:	00 
  10333c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103343:	00 
  103344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103347:	89 04 24             	mov    %eax,(%esp)
  10334a:	e8 04 24 00 00       	call   105753 <memset>
    *pdep = (page2pa(pt) & ~0XFFF) | PTE_U | PTE_W | PTE_P;
  10334f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103352:	89 04 24             	mov    %eax,(%esp)
  103355:	e8 ee f4 ff ff       	call   102848 <page2pa>
  10335a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10335f:	83 c8 07             	or     $0x7,%eax
  103362:	89 c2                	mov    %eax,%edx
  103364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103367:	89 10                	mov    %edx,(%eax)
    return ptep + PTX(la);
  103369:	8b 45 0c             	mov    0xc(%ebp),%eax
  10336c:	c1 e8 0c             	shr    $0xc,%eax
  10336f:	25 ff 03 00 00       	and    $0x3ff,%eax
  103374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337e:	01 d0                	add    %edx,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  103380:	c9                   	leave  
  103381:	c3                   	ret    

00103382 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103382:	55                   	push   %ebp
  103383:	89 e5                	mov    %esp,%ebp
  103385:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103388:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10338f:	00 
  103390:	8b 45 0c             	mov    0xc(%ebp),%eax
  103393:	89 44 24 04          	mov    %eax,0x4(%esp)
  103397:	8b 45 08             	mov    0x8(%ebp),%eax
  10339a:	89 04 24             	mov    %eax,(%esp)
  10339d:	e8 72 fe ff ff       	call   103214 <get_pte>
  1033a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1033a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033a9:	74 08                	je     1033b3 <get_page+0x31>
        *ptep_store = ptep;
  1033ab:	8b 45 10             	mov    0x10(%ebp),%eax
  1033ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033b1:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1033b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033b7:	74 1b                	je     1033d4 <get_page+0x52>
  1033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033bc:	8b 00                	mov    (%eax),%eax
  1033be:	83 e0 01             	and    $0x1,%eax
  1033c1:	85 c0                	test   %eax,%eax
  1033c3:	74 0f                	je     1033d4 <get_page+0x52>
        return pte2page(*ptep);
  1033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c8:	8b 00                	mov    (%eax),%eax
  1033ca:	89 04 24             	mov    %eax,(%esp)
  1033cd:	e8 2f f5 ff ff       	call   102901 <pte2page>
  1033d2:	eb 05                	jmp    1033d9 <get_page+0x57>
    }
    return NULL;
  1033d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033d9:	c9                   	leave  
  1033da:	c3                   	ret    

001033db <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1033db:	55                   	push   %ebp
  1033dc:	89 e5                	mov    %esp,%ebp
  1033de:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if (*ptep & PTE_P) {
  1033e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1033e4:	8b 00                	mov    (%eax),%eax
  1033e6:	83 e0 01             	and    $0x1,%eax
  1033e9:	85 c0                	test   %eax,%eax
  1033eb:	74 5a                	je     103447 <page_remove_pte+0x6c>
        struct Page *page = pte2page(*ptep);
  1033ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f0:	8b 00                	mov    (%eax),%eax
  1033f2:	89 04 24             	mov    %eax,(%esp)
  1033f5:	e8 07 f5 ff ff       	call   102901 <pte2page>
  1033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //引用计数变为0则释放空间
        if (!--(page->ref)) 
  1033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103400:	8b 00                	mov    (%eax),%eax
  103402:	8d 50 ff             	lea    -0x1(%eax),%edx
  103405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103408:	89 10                	mov    %edx,(%eax)
  10340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10340d:	8b 00                	mov    (%eax),%eax
  10340f:	85 c0                	test   %eax,%eax
  103411:	75 13                	jne    103426 <page_remove_pte+0x4b>
            free_page(page);
  103413:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10341a:	00 
  10341b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10341e:	89 04 24             	mov    %eax,(%esp)
  103421:	e8 6e f7 ff ff       	call   102b94 <free_pages>
        //无效化二级页表项 
        *ptep &= (~PTE_P);
  103426:	8b 45 10             	mov    0x10(%ebp),%eax
  103429:	8b 00                	mov    (%eax),%eax
  10342b:	83 e0 fe             	and    $0xfffffffe,%eax
  10342e:	89 c2                	mov    %eax,%edx
  103430:	8b 45 10             	mov    0x10(%ebp),%eax
  103433:	89 10                	mov    %edx,(%eax)
        tlb_invalidate(pgdir, la);//刷新tlb
  103435:	8b 45 0c             	mov    0xc(%ebp),%eax
  103438:	89 44 24 04          	mov    %eax,0x4(%esp)
  10343c:	8b 45 08             	mov    0x8(%ebp),%eax
  10343f:	89 04 24             	mov    %eax,(%esp)
  103442:	e8 01 01 00 00       	call   103548 <tlb_invalidate>
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  103447:	90                   	nop
  103448:	c9                   	leave  
  103449:	c3                   	ret    

0010344a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10344a:	55                   	push   %ebp
  10344b:	89 e5                	mov    %esp,%ebp
  10344d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103450:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103457:	00 
  103458:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10345f:	8b 45 08             	mov    0x8(%ebp),%eax
  103462:	89 04 24             	mov    %eax,(%esp)
  103465:	e8 aa fd ff ff       	call   103214 <get_pte>
  10346a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10346d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103471:	74 19                	je     10348c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  103473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103476:	89 44 24 08          	mov    %eax,0x8(%esp)
  10347a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10347d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103481:	8b 45 08             	mov    0x8(%ebp),%eax
  103484:	89 04 24             	mov    %eax,(%esp)
  103487:	e8 4f ff ff ff       	call   1033db <page_remove_pte>
    }
}
  10348c:	90                   	nop
  10348d:	c9                   	leave  
  10348e:	c3                   	ret    

0010348f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10348f:	55                   	push   %ebp
  103490:	89 e5                	mov    %esp,%ebp
  103492:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103495:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10349c:	00 
  10349d:	8b 45 10             	mov    0x10(%ebp),%eax
  1034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a7:	89 04 24             	mov    %eax,(%esp)
  1034aa:	e8 65 fd ff ff       	call   103214 <get_pte>
  1034af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1034b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034b6:	75 0a                	jne    1034c2 <page_insert+0x33>
        return -E_NO_MEM;
  1034b8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1034bd:	e9 84 00 00 00       	jmp    103546 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1034c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c5:	89 04 24             	mov    %eax,(%esp)
  1034c8:	e8 a2 f4 ff ff       	call   10296f <page_ref_inc>
    if (*ptep & PTE_P) {
  1034cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034d0:	8b 00                	mov    (%eax),%eax
  1034d2:	83 e0 01             	and    $0x1,%eax
  1034d5:	85 c0                	test   %eax,%eax
  1034d7:	74 3e                	je     103517 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034dc:	8b 00                	mov    (%eax),%eax
  1034de:	89 04 24             	mov    %eax,(%esp)
  1034e1:	e8 1b f4 ff ff       	call   102901 <pte2page>
  1034e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1034e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1034ef:	75 0d                	jne    1034fe <page_insert+0x6f>
            page_ref_dec(page);
  1034f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f4:	89 04 24             	mov    %eax,(%esp)
  1034f7:	e8 8a f4 ff ff       	call   102986 <page_ref_dec>
  1034fc:	eb 19                	jmp    103517 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103501:	89 44 24 08          	mov    %eax,0x8(%esp)
  103505:	8b 45 10             	mov    0x10(%ebp),%eax
  103508:	89 44 24 04          	mov    %eax,0x4(%esp)
  10350c:	8b 45 08             	mov    0x8(%ebp),%eax
  10350f:	89 04 24             	mov    %eax,(%esp)
  103512:	e8 c4 fe ff ff       	call   1033db <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103517:	8b 45 0c             	mov    0xc(%ebp),%eax
  10351a:	89 04 24             	mov    %eax,(%esp)
  10351d:	e8 26 f3 ff ff       	call   102848 <page2pa>
  103522:	0b 45 14             	or     0x14(%ebp),%eax
  103525:	83 c8 01             	or     $0x1,%eax
  103528:	89 c2                	mov    %eax,%edx
  10352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10352d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10352f:	8b 45 10             	mov    0x10(%ebp),%eax
  103532:	89 44 24 04          	mov    %eax,0x4(%esp)
  103536:	8b 45 08             	mov    0x8(%ebp),%eax
  103539:	89 04 24             	mov    %eax,(%esp)
  10353c:	e8 07 00 00 00       	call   103548 <tlb_invalidate>
    return 0;
  103541:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103546:	c9                   	leave  
  103547:	c3                   	ret    

00103548 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103548:	55                   	push   %ebp
  103549:	89 e5                	mov    %esp,%ebp
  10354b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10354e:	0f 20 d8             	mov    %cr3,%eax
  103551:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103554:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103557:	8b 45 08             	mov    0x8(%ebp),%eax
  10355a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10355d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103564:	77 23                	ja     103589 <tlb_invalidate+0x41>
  103566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103569:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10356d:	c7 44 24 08 64 67 10 	movl   $0x106764,0x8(%esp)
  103574:	00 
  103575:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  10357c:	00 
  10357d:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103584:	e8 60 ce ff ff       	call   1003e9 <__panic>
  103589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10358c:	05 00 00 00 40       	add    $0x40000000,%eax
  103591:	39 d0                	cmp    %edx,%eax
  103593:	75 0c                	jne    1035a1 <tlb_invalidate+0x59>
        invlpg((void *)la);
  103595:	8b 45 0c             	mov    0xc(%ebp),%eax
  103598:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10359b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10359e:	0f 01 38             	invlpg (%eax)
    }
}
  1035a1:	90                   	nop
  1035a2:	c9                   	leave  
  1035a3:	c3                   	ret    

001035a4 <check_alloc_page>:

static void
check_alloc_page(void) {
  1035a4:	55                   	push   %ebp
  1035a5:	89 e5                	mov    %esp,%ebp
  1035a7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1035aa:	a1 30 af 11 00       	mov    0x11af30,%eax
  1035af:	8b 40 18             	mov    0x18(%eax),%eax
  1035b2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1035b4:	c7 04 24 e8 67 10 00 	movl   $0x1067e8,(%esp)
  1035bb:	e8 d2 cc ff ff       	call   100292 <cprintf>
}
  1035c0:	90                   	nop
  1035c1:	c9                   	leave  
  1035c2:	c3                   	ret    

001035c3 <check_pgdir>:

static void
check_pgdir(void) {
  1035c3:	55                   	push   %ebp
  1035c4:	89 e5                	mov    %esp,%ebp
  1035c6:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1035c9:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  1035ce:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1035d3:	76 24                	jbe    1035f9 <check_pgdir+0x36>
  1035d5:	c7 44 24 0c 07 68 10 	movl   $0x106807,0xc(%esp)
  1035dc:	00 
  1035dd:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  1035e4:	00 
  1035e5:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1035ec:	00 
  1035ed:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1035f4:	e8 f0 cd ff ff       	call   1003e9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1035f9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1035fe:	85 c0                	test   %eax,%eax
  103600:	74 0e                	je     103610 <check_pgdir+0x4d>
  103602:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103607:	25 ff 0f 00 00       	and    $0xfff,%eax
  10360c:	85 c0                	test   %eax,%eax
  10360e:	74 24                	je     103634 <check_pgdir+0x71>
  103610:	c7 44 24 0c 24 68 10 	movl   $0x106824,0xc(%esp)
  103617:	00 
  103618:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  10361f:	00 
  103620:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103627:	00 
  103628:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  10362f:	e8 b5 cd ff ff       	call   1003e9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103634:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103639:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103640:	00 
  103641:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103648:	00 
  103649:	89 04 24             	mov    %eax,(%esp)
  10364c:	e8 31 fd ff ff       	call   103382 <get_page>
  103651:	85 c0                	test   %eax,%eax
  103653:	74 24                	je     103679 <check_pgdir+0xb6>
  103655:	c7 44 24 0c 5c 68 10 	movl   $0x10685c,0xc(%esp)
  10365c:	00 
  10365d:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103664:	00 
  103665:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  10366c:	00 
  10366d:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103674:	e8 70 cd ff ff       	call   1003e9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103679:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103680:	e8 d7 f4 ff ff       	call   102b5c <alloc_pages>
  103685:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103688:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10368d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103694:	00 
  103695:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10369c:	00 
  10369d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1036a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1036a4:	89 04 24             	mov    %eax,(%esp)
  1036a7:	e8 e3 fd ff ff       	call   10348f <page_insert>
  1036ac:	85 c0                	test   %eax,%eax
  1036ae:	74 24                	je     1036d4 <check_pgdir+0x111>
  1036b0:	c7 44 24 0c 84 68 10 	movl   $0x106884,0xc(%esp)
  1036b7:	00 
  1036b8:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  1036bf:	00 
  1036c0:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  1036c7:	00 
  1036c8:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1036cf:	e8 15 cd ff ff       	call   1003e9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1036d4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1036d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036e0:	00 
  1036e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036e8:	00 
  1036e9:	89 04 24             	mov    %eax,(%esp)
  1036ec:	e8 23 fb ff ff       	call   103214 <get_pte>
  1036f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1036f8:	75 24                	jne    10371e <check_pgdir+0x15b>
  1036fa:	c7 44 24 0c b0 68 10 	movl   $0x1068b0,0xc(%esp)
  103701:	00 
  103702:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103709:	00 
  10370a:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103711:	00 
  103712:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103719:	e8 cb cc ff ff       	call   1003e9 <__panic>
    assert(pte2page(*ptep) == p1);
  10371e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103721:	8b 00                	mov    (%eax),%eax
  103723:	89 04 24             	mov    %eax,(%esp)
  103726:	e8 d6 f1 ff ff       	call   102901 <pte2page>
  10372b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10372e:	74 24                	je     103754 <check_pgdir+0x191>
  103730:	c7 44 24 0c dd 68 10 	movl   $0x1068dd,0xc(%esp)
  103737:	00 
  103738:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  10373f:	00 
  103740:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103747:	00 
  103748:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  10374f:	e8 95 cc ff ff       	call   1003e9 <__panic>
    assert(page_ref(p1) == 1);
  103754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103757:	89 04 24             	mov    %eax,(%esp)
  10375a:	e8 f8 f1 ff ff       	call   102957 <page_ref>
  10375f:	83 f8 01             	cmp    $0x1,%eax
  103762:	74 24                	je     103788 <check_pgdir+0x1c5>
  103764:	c7 44 24 0c f3 68 10 	movl   $0x1068f3,0xc(%esp)
  10376b:	00 
  10376c:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103773:	00 
  103774:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  10377b:	00 
  10377c:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103783:	e8 61 cc ff ff       	call   1003e9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103788:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10378d:	8b 00                	mov    (%eax),%eax
  10378f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103794:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10379a:	c1 e8 0c             	shr    $0xc,%eax
  10379d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1037a0:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  1037a5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1037a8:	72 23                	jb     1037cd <check_pgdir+0x20a>
  1037aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1037b1:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  1037b8:	00 
  1037b9:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  1037c0:	00 
  1037c1:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1037c8:	e8 1c cc ff ff       	call   1003e9 <__panic>
  1037cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037d0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1037d5:	83 c0 04             	add    $0x4,%eax
  1037d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1037db:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1037e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037e7:	00 
  1037e8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1037ef:	00 
  1037f0:	89 04 24             	mov    %eax,(%esp)
  1037f3:	e8 1c fa ff ff       	call   103214 <get_pte>
  1037f8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1037fb:	74 24                	je     103821 <check_pgdir+0x25e>
  1037fd:	c7 44 24 0c 08 69 10 	movl   $0x106908,0xc(%esp)
  103804:	00 
  103805:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  10380c:	00 
  10380d:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103814:	00 
  103815:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  10381c:	e8 c8 cb ff ff       	call   1003e9 <__panic>

    p2 = alloc_page();
  103821:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103828:	e8 2f f3 ff ff       	call   102b5c <alloc_pages>
  10382d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103830:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103835:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10383c:	00 
  10383d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103844:	00 
  103845:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103848:	89 54 24 04          	mov    %edx,0x4(%esp)
  10384c:	89 04 24             	mov    %eax,(%esp)
  10384f:	e8 3b fc ff ff       	call   10348f <page_insert>
  103854:	85 c0                	test   %eax,%eax
  103856:	74 24                	je     10387c <check_pgdir+0x2b9>
  103858:	c7 44 24 0c 30 69 10 	movl   $0x106930,0xc(%esp)
  10385f:	00 
  103860:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103867:	00 
  103868:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  10386f:	00 
  103870:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103877:	e8 6d cb ff ff       	call   1003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10387c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103881:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103888:	00 
  103889:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103890:	00 
  103891:	89 04 24             	mov    %eax,(%esp)
  103894:	e8 7b f9 ff ff       	call   103214 <get_pte>
  103899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10389c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038a0:	75 24                	jne    1038c6 <check_pgdir+0x303>
  1038a2:	c7 44 24 0c 68 69 10 	movl   $0x106968,0xc(%esp)
  1038a9:	00 
  1038aa:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  1038b1:	00 
  1038b2:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  1038b9:	00 
  1038ba:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1038c1:	e8 23 cb ff ff       	call   1003e9 <__panic>
    assert(*ptep & PTE_U);
  1038c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038c9:	8b 00                	mov    (%eax),%eax
  1038cb:	83 e0 04             	and    $0x4,%eax
  1038ce:	85 c0                	test   %eax,%eax
  1038d0:	75 24                	jne    1038f6 <check_pgdir+0x333>
  1038d2:	c7 44 24 0c 98 69 10 	movl   $0x106998,0xc(%esp)
  1038d9:	00 
  1038da:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  1038e1:	00 
  1038e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1038e9:	00 
  1038ea:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1038f1:	e8 f3 ca ff ff       	call   1003e9 <__panic>
    assert(*ptep & PTE_W);
  1038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038f9:	8b 00                	mov    (%eax),%eax
  1038fb:	83 e0 02             	and    $0x2,%eax
  1038fe:	85 c0                	test   %eax,%eax
  103900:	75 24                	jne    103926 <check_pgdir+0x363>
  103902:	c7 44 24 0c a6 69 10 	movl   $0x1069a6,0xc(%esp)
  103909:	00 
  10390a:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103911:	00 
  103912:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103919:	00 
  10391a:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103921:	e8 c3 ca ff ff       	call   1003e9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103926:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10392b:	8b 00                	mov    (%eax),%eax
  10392d:	83 e0 04             	and    $0x4,%eax
  103930:	85 c0                	test   %eax,%eax
  103932:	75 24                	jne    103958 <check_pgdir+0x395>
  103934:	c7 44 24 0c b4 69 10 	movl   $0x1069b4,0xc(%esp)
  10393b:	00 
  10393c:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103943:	00 
  103944:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  10394b:	00 
  10394c:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103953:	e8 91 ca ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 1);
  103958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10395b:	89 04 24             	mov    %eax,(%esp)
  10395e:	e8 f4 ef ff ff       	call   102957 <page_ref>
  103963:	83 f8 01             	cmp    $0x1,%eax
  103966:	74 24                	je     10398c <check_pgdir+0x3c9>
  103968:	c7 44 24 0c ca 69 10 	movl   $0x1069ca,0xc(%esp)
  10396f:	00 
  103970:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103977:	00 
  103978:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  10397f:	00 
  103980:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103987:	e8 5d ca ff ff       	call   1003e9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10398c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103991:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103998:	00 
  103999:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1039a0:	00 
  1039a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1039a4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039a8:	89 04 24             	mov    %eax,(%esp)
  1039ab:	e8 df fa ff ff       	call   10348f <page_insert>
  1039b0:	85 c0                	test   %eax,%eax
  1039b2:	74 24                	je     1039d8 <check_pgdir+0x415>
  1039b4:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  1039bb:	00 
  1039bc:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  1039c3:	00 
  1039c4:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1039cb:	00 
  1039cc:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  1039d3:	e8 11 ca ff ff       	call   1003e9 <__panic>
    assert(page_ref(p1) == 2);
  1039d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039db:	89 04 24             	mov    %eax,(%esp)
  1039de:	e8 74 ef ff ff       	call   102957 <page_ref>
  1039e3:	83 f8 02             	cmp    $0x2,%eax
  1039e6:	74 24                	je     103a0c <check_pgdir+0x449>
  1039e8:	c7 44 24 0c 08 6a 10 	movl   $0x106a08,0xc(%esp)
  1039ef:	00 
  1039f0:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  1039f7:	00 
  1039f8:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  1039ff:	00 
  103a00:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103a07:	e8 dd c9 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 0);
  103a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a0f:	89 04 24             	mov    %eax,(%esp)
  103a12:	e8 40 ef ff ff       	call   102957 <page_ref>
  103a17:	85 c0                	test   %eax,%eax
  103a19:	74 24                	je     103a3f <check_pgdir+0x47c>
  103a1b:	c7 44 24 0c 1a 6a 10 	movl   $0x106a1a,0xc(%esp)
  103a22:	00 
  103a23:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103a2a:	00 
  103a2b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103a32:	00 
  103a33:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103a3a:	e8 aa c9 ff ff       	call   1003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a3f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103a44:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a4b:	00 
  103a4c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a53:	00 
  103a54:	89 04 24             	mov    %eax,(%esp)
  103a57:	e8 b8 f7 ff ff       	call   103214 <get_pte>
  103a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a63:	75 24                	jne    103a89 <check_pgdir+0x4c6>
  103a65:	c7 44 24 0c 68 69 10 	movl   $0x106968,0xc(%esp)
  103a6c:	00 
  103a6d:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103a74:	00 
  103a75:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103a7c:	00 
  103a7d:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103a84:	e8 60 c9 ff ff       	call   1003e9 <__panic>
    assert(pte2page(*ptep) == p1);
  103a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a8c:	8b 00                	mov    (%eax),%eax
  103a8e:	89 04 24             	mov    %eax,(%esp)
  103a91:	e8 6b ee ff ff       	call   102901 <pte2page>
  103a96:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a99:	74 24                	je     103abf <check_pgdir+0x4fc>
  103a9b:	c7 44 24 0c dd 68 10 	movl   $0x1068dd,0xc(%esp)
  103aa2:	00 
  103aa3:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103aaa:	00 
  103aab:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103ab2:	00 
  103ab3:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103aba:	e8 2a c9 ff ff       	call   1003e9 <__panic>
    assert((*ptep & PTE_U) == 0);
  103abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ac2:	8b 00                	mov    (%eax),%eax
  103ac4:	83 e0 04             	and    $0x4,%eax
  103ac7:	85 c0                	test   %eax,%eax
  103ac9:	74 24                	je     103aef <check_pgdir+0x52c>
  103acb:	c7 44 24 0c 2c 6a 10 	movl   $0x106a2c,0xc(%esp)
  103ad2:	00 
  103ad3:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103ada:	00 
  103adb:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103ae2:	00 
  103ae3:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103aea:	e8 fa c8 ff ff       	call   1003e9 <__panic>

    page_remove(boot_pgdir, 0x0);
  103aef:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103af4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103afb:	00 
  103afc:	89 04 24             	mov    %eax,(%esp)
  103aff:	e8 46 f9 ff ff       	call   10344a <page_remove>
    assert(page_ref(p1) == 1);
  103b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b07:	89 04 24             	mov    %eax,(%esp)
  103b0a:	e8 48 ee ff ff       	call   102957 <page_ref>
  103b0f:	83 f8 01             	cmp    $0x1,%eax
  103b12:	74 24                	je     103b38 <check_pgdir+0x575>
  103b14:	c7 44 24 0c f3 68 10 	movl   $0x1068f3,0xc(%esp)
  103b1b:	00 
  103b1c:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103b23:	00 
  103b24:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103b2b:	00 
  103b2c:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103b33:	e8 b1 c8 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 0);
  103b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b3b:	89 04 24             	mov    %eax,(%esp)
  103b3e:	e8 14 ee ff ff       	call   102957 <page_ref>
  103b43:	85 c0                	test   %eax,%eax
  103b45:	74 24                	je     103b6b <check_pgdir+0x5a8>
  103b47:	c7 44 24 0c 1a 6a 10 	movl   $0x106a1a,0xc(%esp)
  103b4e:	00 
  103b4f:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103b56:	00 
  103b57:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103b5e:	00 
  103b5f:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103b66:	e8 7e c8 ff ff       	call   1003e9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103b6b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103b70:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b77:	00 
  103b78:	89 04 24             	mov    %eax,(%esp)
  103b7b:	e8 ca f8 ff ff       	call   10344a <page_remove>
    assert(page_ref(p1) == 0);
  103b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b83:	89 04 24             	mov    %eax,(%esp)
  103b86:	e8 cc ed ff ff       	call   102957 <page_ref>
  103b8b:	85 c0                	test   %eax,%eax
  103b8d:	74 24                	je     103bb3 <check_pgdir+0x5f0>
  103b8f:	c7 44 24 0c 41 6a 10 	movl   $0x106a41,0xc(%esp)
  103b96:	00 
  103b97:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103b9e:	00 
  103b9f:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  103ba6:	00 
  103ba7:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103bae:	e8 36 c8 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 0);
  103bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bb6:	89 04 24             	mov    %eax,(%esp)
  103bb9:	e8 99 ed ff ff       	call   102957 <page_ref>
  103bbe:	85 c0                	test   %eax,%eax
  103bc0:	74 24                	je     103be6 <check_pgdir+0x623>
  103bc2:	c7 44 24 0c 1a 6a 10 	movl   $0x106a1a,0xc(%esp)
  103bc9:	00 
  103bca:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103bd1:	00 
  103bd2:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103bd9:	00 
  103bda:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103be1:	e8 03 c8 ff ff       	call   1003e9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103be6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103beb:	8b 00                	mov    (%eax),%eax
  103bed:	89 04 24             	mov    %eax,(%esp)
  103bf0:	e8 4a ed ff ff       	call   10293f <pde2page>
  103bf5:	89 04 24             	mov    %eax,(%esp)
  103bf8:	e8 5a ed ff ff       	call   102957 <page_ref>
  103bfd:	83 f8 01             	cmp    $0x1,%eax
  103c00:	74 24                	je     103c26 <check_pgdir+0x663>
  103c02:	c7 44 24 0c 54 6a 10 	movl   $0x106a54,0xc(%esp)
  103c09:	00 
  103c0a:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103c11:	00 
  103c12:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  103c19:	00 
  103c1a:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103c21:	e8 c3 c7 ff ff       	call   1003e9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103c26:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c2b:	8b 00                	mov    (%eax),%eax
  103c2d:	89 04 24             	mov    %eax,(%esp)
  103c30:	e8 0a ed ff ff       	call   10293f <pde2page>
  103c35:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103c3c:	00 
  103c3d:	89 04 24             	mov    %eax,(%esp)
  103c40:	e8 4f ef ff ff       	call   102b94 <free_pages>
    boot_pgdir[0] = 0;
  103c45:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103c50:	c7 04 24 7b 6a 10 00 	movl   $0x106a7b,(%esp)
  103c57:	e8 36 c6 ff ff       	call   100292 <cprintf>
}
  103c5c:	90                   	nop
  103c5d:	c9                   	leave  
  103c5e:	c3                   	ret    

00103c5f <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103c5f:	55                   	push   %ebp
  103c60:	89 e5                	mov    %esp,%ebp
  103c62:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c6c:	e9 ca 00 00 00       	jmp    103d3b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c7a:	c1 e8 0c             	shr    $0xc,%eax
  103c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c80:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  103c85:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103c88:	72 23                	jb     103cad <check_boot_pgdir+0x4e>
  103c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c91:	c7 44 24 08 c0 66 10 	movl   $0x1066c0,0x8(%esp)
  103c98:	00 
  103c99:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103ca0:	00 
  103ca1:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103ca8:	e8 3c c7 ff ff       	call   1003e9 <__panic>
  103cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cb0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103cb5:	89 c2                	mov    %eax,%edx
  103cb7:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103cbc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103cc3:	00 
  103cc4:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cc8:	89 04 24             	mov    %eax,(%esp)
  103ccb:	e8 44 f5 ff ff       	call   103214 <get_pte>
  103cd0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103cd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103cd7:	75 24                	jne    103cfd <check_boot_pgdir+0x9e>
  103cd9:	c7 44 24 0c 98 6a 10 	movl   $0x106a98,0xc(%esp)
  103ce0:	00 
  103ce1:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103ce8:	00 
  103ce9:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103cf0:	00 
  103cf1:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103cf8:	e8 ec c6 ff ff       	call   1003e9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103cfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103d00:	8b 00                	mov    (%eax),%eax
  103d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d07:	89 c2                	mov    %eax,%edx
  103d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d0c:	39 c2                	cmp    %eax,%edx
  103d0e:	74 24                	je     103d34 <check_boot_pgdir+0xd5>
  103d10:	c7 44 24 0c d5 6a 10 	movl   $0x106ad5,0xc(%esp)
  103d17:	00 
  103d18:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103d1f:	00 
  103d20:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  103d27:	00 
  103d28:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103d2f:	e8 b5 c6 ff ff       	call   1003e9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103d34:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d3e:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  103d43:	39 c2                	cmp    %eax,%edx
  103d45:	0f 82 26 ff ff ff    	jb     103c71 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103d4b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d50:	05 ac 0f 00 00       	add    $0xfac,%eax
  103d55:	8b 00                	mov    (%eax),%eax
  103d57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d5c:	89 c2                	mov    %eax,%edx
  103d5e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d66:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103d6d:	77 23                	ja     103d92 <check_boot_pgdir+0x133>
  103d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d76:	c7 44 24 08 64 67 10 	movl   $0x106764,0x8(%esp)
  103d7d:	00 
  103d7e:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  103d85:	00 
  103d86:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103d8d:	e8 57 c6 ff ff       	call   1003e9 <__panic>
  103d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d95:	05 00 00 00 40       	add    $0x40000000,%eax
  103d9a:	39 d0                	cmp    %edx,%eax
  103d9c:	74 24                	je     103dc2 <check_boot_pgdir+0x163>
  103d9e:	c7 44 24 0c ec 6a 10 	movl   $0x106aec,0xc(%esp)
  103da5:	00 
  103da6:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103dad:	00 
  103dae:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  103db5:	00 
  103db6:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103dbd:	e8 27 c6 ff ff       	call   1003e9 <__panic>

    assert(boot_pgdir[0] == 0);
  103dc2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103dc7:	8b 00                	mov    (%eax),%eax
  103dc9:	85 c0                	test   %eax,%eax
  103dcb:	74 24                	je     103df1 <check_boot_pgdir+0x192>
  103dcd:	c7 44 24 0c 20 6b 10 	movl   $0x106b20,0xc(%esp)
  103dd4:	00 
  103dd5:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103ddc:	00 
  103ddd:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  103de4:	00 
  103de5:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103dec:	e8 f8 c5 ff ff       	call   1003e9 <__panic>

    struct Page *p;
    p = alloc_page();
  103df1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103df8:	e8 5f ed ff ff       	call   102b5c <alloc_pages>
  103dfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103e00:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103e05:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103e0c:	00 
  103e0d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103e14:	00 
  103e15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103e18:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e1c:	89 04 24             	mov    %eax,(%esp)
  103e1f:	e8 6b f6 ff ff       	call   10348f <page_insert>
  103e24:	85 c0                	test   %eax,%eax
  103e26:	74 24                	je     103e4c <check_boot_pgdir+0x1ed>
  103e28:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  103e2f:	00 
  103e30:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103e37:	00 
  103e38:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  103e3f:	00 
  103e40:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103e47:	e8 9d c5 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p) == 1);
  103e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e4f:	89 04 24             	mov    %eax,(%esp)
  103e52:	e8 00 eb ff ff       	call   102957 <page_ref>
  103e57:	83 f8 01             	cmp    $0x1,%eax
  103e5a:	74 24                	je     103e80 <check_boot_pgdir+0x221>
  103e5c:	c7 44 24 0c 62 6b 10 	movl   $0x106b62,0xc(%esp)
  103e63:	00 
  103e64:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103e6b:	00 
  103e6c:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  103e73:	00 
  103e74:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103e7b:	e8 69 c5 ff ff       	call   1003e9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103e80:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103e85:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103e8c:	00 
  103e8d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103e94:	00 
  103e95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103e98:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e9c:	89 04 24             	mov    %eax,(%esp)
  103e9f:	e8 eb f5 ff ff       	call   10348f <page_insert>
  103ea4:	85 c0                	test   %eax,%eax
  103ea6:	74 24                	je     103ecc <check_boot_pgdir+0x26d>
  103ea8:	c7 44 24 0c 74 6b 10 	movl   $0x106b74,0xc(%esp)
  103eaf:	00 
  103eb0:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103eb7:	00 
  103eb8:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  103ebf:	00 
  103ec0:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103ec7:	e8 1d c5 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p) == 2);
  103ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ecf:	89 04 24             	mov    %eax,(%esp)
  103ed2:	e8 80 ea ff ff       	call   102957 <page_ref>
  103ed7:	83 f8 02             	cmp    $0x2,%eax
  103eda:	74 24                	je     103f00 <check_boot_pgdir+0x2a1>
  103edc:	c7 44 24 0c ab 6b 10 	movl   $0x106bab,0xc(%esp)
  103ee3:	00 
  103ee4:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103eeb:	00 
  103eec:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  103ef3:	00 
  103ef4:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103efb:	e8 e9 c4 ff ff       	call   1003e9 <__panic>

    const char *str = "ucore: Hello world!!";
  103f00:	c7 45 e8 bc 6b 10 00 	movl   $0x106bbc,-0x18(%ebp)
    strcpy((void *)0x100, str);
  103f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f0e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f15:	e8 6f 15 00 00       	call   105489 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103f1a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  103f21:	00 
  103f22:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f29:	e8 d2 15 00 00       	call   105500 <strcmp>
  103f2e:	85 c0                	test   %eax,%eax
  103f30:	74 24                	je     103f56 <check_boot_pgdir+0x2f7>
  103f32:	c7 44 24 0c d4 6b 10 	movl   $0x106bd4,0xc(%esp)
  103f39:	00 
  103f3a:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103f41:	00 
  103f42:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  103f49:	00 
  103f4a:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103f51:	e8 93 c4 ff ff       	call   1003e9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f59:	89 04 24             	mov    %eax,(%esp)
  103f5c:	e8 4c e9 ff ff       	call   1028ad <page2kva>
  103f61:	05 00 01 00 00       	add    $0x100,%eax
  103f66:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103f69:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f70:	e8 be 14 00 00       	call   105433 <strlen>
  103f75:	85 c0                	test   %eax,%eax
  103f77:	74 24                	je     103f9d <check_boot_pgdir+0x33e>
  103f79:	c7 44 24 0c 0c 6c 10 	movl   $0x106c0c,0xc(%esp)
  103f80:	00 
  103f81:	c7 44 24 08 ad 67 10 	movl   $0x1067ad,0x8(%esp)
  103f88:	00 
  103f89:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  103f90:	00 
  103f91:	c7 04 24 88 67 10 00 	movl   $0x106788,(%esp)
  103f98:	e8 4c c4 ff ff       	call   1003e9 <__panic>

    free_page(p);
  103f9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103fa4:	00 
  103fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fa8:	89 04 24             	mov    %eax,(%esp)
  103fab:	e8 e4 eb ff ff       	call   102b94 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  103fb0:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103fb5:	8b 00                	mov    (%eax),%eax
  103fb7:	89 04 24             	mov    %eax,(%esp)
  103fba:	e8 80 e9 ff ff       	call   10293f <pde2page>
  103fbf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103fc6:	00 
  103fc7:	89 04 24             	mov    %eax,(%esp)
  103fca:	e8 c5 eb ff ff       	call   102b94 <free_pages>
    boot_pgdir[0] = 0;
  103fcf:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103fd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103fda:	c7 04 24 30 6c 10 00 	movl   $0x106c30,(%esp)
  103fe1:	e8 ac c2 ff ff       	call   100292 <cprintf>
}
  103fe6:	90                   	nop
  103fe7:	c9                   	leave  
  103fe8:	c3                   	ret    

00103fe9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103fe9:	55                   	push   %ebp
  103fea:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103fec:	8b 45 08             	mov    0x8(%ebp),%eax
  103fef:	83 e0 04             	and    $0x4,%eax
  103ff2:	85 c0                	test   %eax,%eax
  103ff4:	74 04                	je     103ffa <perm2str+0x11>
  103ff6:	b0 75                	mov    $0x75,%al
  103ff8:	eb 02                	jmp    103ffc <perm2str+0x13>
  103ffa:	b0 2d                	mov    $0x2d,%al
  103ffc:	a2 28 af 11 00       	mov    %al,0x11af28
    str[1] = 'r';
  104001:	c6 05 29 af 11 00 72 	movb   $0x72,0x11af29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104008:	8b 45 08             	mov    0x8(%ebp),%eax
  10400b:	83 e0 02             	and    $0x2,%eax
  10400e:	85 c0                	test   %eax,%eax
  104010:	74 04                	je     104016 <perm2str+0x2d>
  104012:	b0 77                	mov    $0x77,%al
  104014:	eb 02                	jmp    104018 <perm2str+0x2f>
  104016:	b0 2d                	mov    $0x2d,%al
  104018:	a2 2a af 11 00       	mov    %al,0x11af2a
    str[3] = '\0';
  10401d:	c6 05 2b af 11 00 00 	movb   $0x0,0x11af2b
    return str;
  104024:	b8 28 af 11 00       	mov    $0x11af28,%eax
}
  104029:	5d                   	pop    %ebp
  10402a:	c3                   	ret    

0010402b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10402b:	55                   	push   %ebp
  10402c:	89 e5                	mov    %esp,%ebp
  10402e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104031:	8b 45 10             	mov    0x10(%ebp),%eax
  104034:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104037:	72 0d                	jb     104046 <get_pgtable_items+0x1b>
        return 0;
  104039:	b8 00 00 00 00       	mov    $0x0,%eax
  10403e:	e9 98 00 00 00       	jmp    1040db <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104043:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104046:	8b 45 10             	mov    0x10(%ebp),%eax
  104049:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10404c:	73 18                	jae    104066 <get_pgtable_items+0x3b>
  10404e:	8b 45 10             	mov    0x10(%ebp),%eax
  104051:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104058:	8b 45 14             	mov    0x14(%ebp),%eax
  10405b:	01 d0                	add    %edx,%eax
  10405d:	8b 00                	mov    (%eax),%eax
  10405f:	83 e0 01             	and    $0x1,%eax
  104062:	85 c0                	test   %eax,%eax
  104064:	74 dd                	je     104043 <get_pgtable_items+0x18>
    }
    if (start < right) {
  104066:	8b 45 10             	mov    0x10(%ebp),%eax
  104069:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10406c:	73 68                	jae    1040d6 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  10406e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104072:	74 08                	je     10407c <get_pgtable_items+0x51>
            *left_store = start;
  104074:	8b 45 18             	mov    0x18(%ebp),%eax
  104077:	8b 55 10             	mov    0x10(%ebp),%edx
  10407a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10407c:	8b 45 10             	mov    0x10(%ebp),%eax
  10407f:	8d 50 01             	lea    0x1(%eax),%edx
  104082:	89 55 10             	mov    %edx,0x10(%ebp)
  104085:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10408c:	8b 45 14             	mov    0x14(%ebp),%eax
  10408f:	01 d0                	add    %edx,%eax
  104091:	8b 00                	mov    (%eax),%eax
  104093:	83 e0 07             	and    $0x7,%eax
  104096:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104099:	eb 03                	jmp    10409e <get_pgtable_items+0x73>
            start ++;
  10409b:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10409e:	8b 45 10             	mov    0x10(%ebp),%eax
  1040a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1040a4:	73 1d                	jae    1040c3 <get_pgtable_items+0x98>
  1040a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1040a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1040b0:	8b 45 14             	mov    0x14(%ebp),%eax
  1040b3:	01 d0                	add    %edx,%eax
  1040b5:	8b 00                	mov    (%eax),%eax
  1040b7:	83 e0 07             	and    $0x7,%eax
  1040ba:	89 c2                	mov    %eax,%edx
  1040bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040bf:	39 c2                	cmp    %eax,%edx
  1040c1:	74 d8                	je     10409b <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  1040c3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1040c7:	74 08                	je     1040d1 <get_pgtable_items+0xa6>
            *right_store = start;
  1040c9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1040cc:	8b 55 10             	mov    0x10(%ebp),%edx
  1040cf:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1040d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040d4:	eb 05                	jmp    1040db <get_pgtable_items+0xb0>
    }
    return 0;
  1040d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1040db:	c9                   	leave  
  1040dc:	c3                   	ret    

001040dd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1040dd:	55                   	push   %ebp
  1040de:	89 e5                	mov    %esp,%ebp
  1040e0:	57                   	push   %edi
  1040e1:	56                   	push   %esi
  1040e2:	53                   	push   %ebx
  1040e3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1040e6:	c7 04 24 50 6c 10 00 	movl   $0x106c50,(%esp)
  1040ed:	e8 a0 c1 ff ff       	call   100292 <cprintf>
    size_t left, right = 0, perm;
  1040f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1040f9:	e9 fa 00 00 00       	jmp    1041f8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1040fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104101:	89 04 24             	mov    %eax,(%esp)
  104104:	e8 e0 fe ff ff       	call   103fe9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104109:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10410c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10410f:	29 d1                	sub    %edx,%ecx
  104111:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104113:	89 d6                	mov    %edx,%esi
  104115:	c1 e6 16             	shl    $0x16,%esi
  104118:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10411b:	89 d3                	mov    %edx,%ebx
  10411d:	c1 e3 16             	shl    $0x16,%ebx
  104120:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104123:	89 d1                	mov    %edx,%ecx
  104125:	c1 e1 16             	shl    $0x16,%ecx
  104128:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10412b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10412e:	29 d7                	sub    %edx,%edi
  104130:	89 fa                	mov    %edi,%edx
  104132:	89 44 24 14          	mov    %eax,0x14(%esp)
  104136:	89 74 24 10          	mov    %esi,0x10(%esp)
  10413a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10413e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104142:	89 54 24 04          	mov    %edx,0x4(%esp)
  104146:	c7 04 24 81 6c 10 00 	movl   $0x106c81,(%esp)
  10414d:	e8 40 c1 ff ff       	call   100292 <cprintf>
        size_t l, r = left * NPTEENTRY;
  104152:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104155:	c1 e0 0a             	shl    $0xa,%eax
  104158:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10415b:	eb 54                	jmp    1041b1 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10415d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104160:	89 04 24             	mov    %eax,(%esp)
  104163:	e8 81 fe ff ff       	call   103fe9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104168:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10416b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10416e:	29 d1                	sub    %edx,%ecx
  104170:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104172:	89 d6                	mov    %edx,%esi
  104174:	c1 e6 0c             	shl    $0xc,%esi
  104177:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10417a:	89 d3                	mov    %edx,%ebx
  10417c:	c1 e3 0c             	shl    $0xc,%ebx
  10417f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104182:	89 d1                	mov    %edx,%ecx
  104184:	c1 e1 0c             	shl    $0xc,%ecx
  104187:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10418a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10418d:	29 d7                	sub    %edx,%edi
  10418f:	89 fa                	mov    %edi,%edx
  104191:	89 44 24 14          	mov    %eax,0x14(%esp)
  104195:	89 74 24 10          	mov    %esi,0x10(%esp)
  104199:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10419d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1041a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041a5:	c7 04 24 a0 6c 10 00 	movl   $0x106ca0,(%esp)
  1041ac:	e8 e1 c0 ff ff       	call   100292 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1041b1:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1041b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041bc:	89 d3                	mov    %edx,%ebx
  1041be:	c1 e3 0a             	shl    $0xa,%ebx
  1041c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1041c4:	89 d1                	mov    %edx,%ecx
  1041c6:	c1 e1 0a             	shl    $0xa,%ecx
  1041c9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1041cc:	89 54 24 14          	mov    %edx,0x14(%esp)
  1041d0:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1041d3:	89 54 24 10          	mov    %edx,0x10(%esp)
  1041d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1041db:	89 44 24 08          	mov    %eax,0x8(%esp)
  1041df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1041e3:	89 0c 24             	mov    %ecx,(%esp)
  1041e6:	e8 40 fe ff ff       	call   10402b <get_pgtable_items>
  1041eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1041ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1041f2:	0f 85 65 ff ff ff    	jne    10415d <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1041f8:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1041fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104200:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104203:	89 54 24 14          	mov    %edx,0x14(%esp)
  104207:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10420a:	89 54 24 10          	mov    %edx,0x10(%esp)
  10420e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104212:	89 44 24 08          	mov    %eax,0x8(%esp)
  104216:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10421d:	00 
  10421e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104225:	e8 01 fe ff ff       	call   10402b <get_pgtable_items>
  10422a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10422d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104231:	0f 85 c7 fe ff ff    	jne    1040fe <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104237:	c7 04 24 c4 6c 10 00 	movl   $0x106cc4,(%esp)
  10423e:	e8 4f c0 ff ff       	call   100292 <cprintf>
}
  104243:	90                   	nop
  104244:	83 c4 4c             	add    $0x4c,%esp
  104247:	5b                   	pop    %ebx
  104248:	5e                   	pop    %esi
  104249:	5f                   	pop    %edi
  10424a:	5d                   	pop    %ebp
  10424b:	c3                   	ret    

0010424c <page2ppn>:
page2ppn(struct Page *page) {
  10424c:	55                   	push   %ebp
  10424d:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10424f:	8b 45 08             	mov    0x8(%ebp),%eax
  104252:	8b 15 38 af 11 00    	mov    0x11af38,%edx
  104258:	29 d0                	sub    %edx,%eax
  10425a:	c1 f8 02             	sar    $0x2,%eax
  10425d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104263:	5d                   	pop    %ebp
  104264:	c3                   	ret    

00104265 <page2pa>:
page2pa(struct Page *page) {
  104265:	55                   	push   %ebp
  104266:	89 e5                	mov    %esp,%ebp
  104268:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10426b:	8b 45 08             	mov    0x8(%ebp),%eax
  10426e:	89 04 24             	mov    %eax,(%esp)
  104271:	e8 d6 ff ff ff       	call   10424c <page2ppn>
  104276:	c1 e0 0c             	shl    $0xc,%eax
}
  104279:	c9                   	leave  
  10427a:	c3                   	ret    

0010427b <page_ref>:
page_ref(struct Page *page) {
  10427b:	55                   	push   %ebp
  10427c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10427e:	8b 45 08             	mov    0x8(%ebp),%eax
  104281:	8b 00                	mov    (%eax),%eax
}
  104283:	5d                   	pop    %ebp
  104284:	c3                   	ret    

00104285 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104285:	55                   	push   %ebp
  104286:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104288:	8b 45 08             	mov    0x8(%ebp),%eax
  10428b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10428e:	89 10                	mov    %edx,(%eax)
}
  104290:	90                   	nop
  104291:	5d                   	pop    %ebp
  104292:	c3                   	ret    

00104293 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104293:	55                   	push   %ebp
  104294:	89 e5                	mov    %esp,%ebp
  104296:	83 ec 10             	sub    $0x10,%esp
  104299:	c7 45 fc 3c af 11 00 	movl   $0x11af3c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1042a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1042a6:	89 50 04             	mov    %edx,0x4(%eax)
  1042a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042ac:	8b 50 04             	mov    0x4(%eax),%edx
  1042af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042b2:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1042b4:	c7 05 44 af 11 00 00 	movl   $0x0,0x11af44
  1042bb:	00 00 00 
}
  1042be:	90                   	nop
  1042bf:	c9                   	leave  
  1042c0:	c3                   	ret    

001042c1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1042c1:	55                   	push   %ebp
  1042c2:	89 e5                	mov    %esp,%ebp
  1042c4:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1042c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1042cb:	75 24                	jne    1042f1 <default_init_memmap+0x30>
  1042cd:	c7 44 24 0c f8 6c 10 	movl   $0x106cf8,0xc(%esp)
  1042d4:	00 
  1042d5:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1042dc:	00 
  1042dd:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  1042e4:	00 
  1042e5:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1042ec:	e8 f8 c0 ff ff       	call   1003e9 <__panic>
    struct Page *p = base;
  1042f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1042f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1042f7:	eb 7d                	jmp    104376 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  1042f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042fc:	83 c0 04             	add    $0x4,%eax
  1042ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104306:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10430c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10430f:	0f a3 10             	bt     %edx,(%eax)
  104312:	19 c0                	sbb    %eax,%eax
  104314:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104317:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10431b:	0f 95 c0             	setne  %al
  10431e:	0f b6 c0             	movzbl %al,%eax
  104321:	85 c0                	test   %eax,%eax
  104323:	75 24                	jne    104349 <default_init_memmap+0x88>
  104325:	c7 44 24 0c 29 6d 10 	movl   $0x106d29,0xc(%esp)
  10432c:	00 
  10432d:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104334:	00 
  104335:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  10433c:	00 
  10433d:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104344:	e8 a0 c0 ff ff       	call   1003e9 <__panic>
        p->flags = p->property = 0;
  104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10434c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104356:	8b 50 08             	mov    0x8(%eax),%edx
  104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10435c:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10435f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104366:	00 
  104367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10436a:	89 04 24             	mov    %eax,(%esp)
  10436d:	e8 13 ff ff ff       	call   104285 <set_page_ref>
    for (; p != base + n; p ++) {
  104372:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104376:	8b 55 0c             	mov    0xc(%ebp),%edx
  104379:	89 d0                	mov    %edx,%eax
  10437b:	c1 e0 02             	shl    $0x2,%eax
  10437e:	01 d0                	add    %edx,%eax
  104380:	c1 e0 02             	shl    $0x2,%eax
  104383:	89 c2                	mov    %eax,%edx
  104385:	8b 45 08             	mov    0x8(%ebp),%eax
  104388:	01 d0                	add    %edx,%eax
  10438a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10438d:	0f 85 66 ff ff ff    	jne    1042f9 <default_init_memmap+0x38>
    }
    base->property = n;
  104393:	8b 45 08             	mov    0x8(%ebp),%eax
  104396:	8b 55 0c             	mov    0xc(%ebp),%edx
  104399:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10439c:	8b 45 08             	mov    0x8(%ebp),%eax
  10439f:	83 c0 04             	add    $0x4,%eax
  1043a2:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  1043a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1043ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043af:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1043b2:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1043b5:	8b 15 44 af 11 00    	mov    0x11af44,%edx
  1043bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043be:	01 d0                	add    %edx,%eax
  1043c0:	a3 44 af 11 00       	mov    %eax,0x11af44
    list_add(&free_list, &(base->page_link));
  1043c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1043c8:	83 c0 0c             	add    $0xc,%eax
  1043cb:	c7 45 e4 3c af 11 00 	movl   $0x11af3c,-0x1c(%ebp)
  1043d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1043d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1043db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043de:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1043e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043e4:	8b 40 04             	mov    0x4(%eax),%eax
  1043e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1043ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1043ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043f0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1043f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1043f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1043f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043fc:	89 10                	mov    %edx,(%eax)
  1043fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104401:	8b 10                	mov    (%eax),%edx
  104403:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104406:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104409:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10440c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10440f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104412:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104415:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104418:	89 10                	mov    %edx,(%eax)
}
  10441a:	90                   	nop
  10441b:	c9                   	leave  
  10441c:	c3                   	ret    

0010441d <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  10441d:	55                   	push   %ebp
  10441e:	89 e5                	mov    %esp,%ebp
  104420:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104423:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104427:	75 24                	jne    10444d <default_alloc_pages+0x30>
  104429:	c7 44 24 0c f8 6c 10 	movl   $0x106cf8,0xc(%esp)
  104430:	00 
  104431:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104438:	00 
  104439:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  104440:	00 
  104441:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104448:	e8 9c bf ff ff       	call   1003e9 <__panic>
    if (n > nr_free) {
  10444d:	a1 44 af 11 00       	mov    0x11af44,%eax
  104452:	39 45 08             	cmp    %eax,0x8(%ebp)
  104455:	76 0a                	jbe    104461 <default_alloc_pages+0x44>
        return NULL;
  104457:	b8 00 00 00 00       	mov    $0x0,%eax
  10445c:	e9 51 01 00 00       	jmp    1045b2 <default_alloc_pages+0x195>
    }
    struct Page *page = NULL;
  104461:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104468:	c7 45 f0 3c af 11 00 	movl   $0x11af3c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10446f:	eb 1c                	jmp    10448d <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  104471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104474:	83 e8 0c             	sub    $0xc,%eax
  104477:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  10447a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10447d:	8b 40 08             	mov    0x8(%eax),%eax
  104480:	39 45 08             	cmp    %eax,0x8(%ebp)
  104483:	77 08                	ja     10448d <default_alloc_pages+0x70>
            page = p;
  104485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104488:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10448b:	eb 18                	jmp    1044a5 <default_alloc_pages+0x88>
  10448d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104490:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
  104493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104496:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104499:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10449c:	81 7d f0 3c af 11 00 	cmpl   $0x11af3c,-0x10(%ebp)
  1044a3:	75 cc                	jne    104471 <default_alloc_pages+0x54>
        }
    }
    
    if (page != NULL) { 
  1044a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044a9:	0f 84 00 01 00 00    	je     1045af <default_alloc_pages+0x192>
        //页面在内存上是连续的
        for (struct Page *p=page;p!=page+n;++p) 
  1044af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1044b5:	eb 1d                	jmp    1044d4 <default_alloc_pages+0xb7>
            ClearPageProperty(p); //标记页面为非空闲
  1044b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044ba:	83 c0 04             	add    $0x4,%eax
  1044bd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  1044c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1044ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1044cd:	0f b3 10             	btr    %edx,(%eax)
        for (struct Page *p=page;p!=page+n;++p) 
  1044d0:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  1044d4:	8b 55 08             	mov    0x8(%ebp),%edx
  1044d7:	89 d0                	mov    %edx,%eax
  1044d9:	c1 e0 02             	shl    $0x2,%eax
  1044dc:	01 d0                	add    %edx,%eax
  1044de:	c1 e0 02             	shl    $0x2,%eax
  1044e1:	89 c2                	mov    %eax,%edx
  1044e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e6:	01 d0                	add    %edx,%eax
  1044e8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1044eb:	75 ca                	jne    1044b7 <default_alloc_pages+0x9a>
        //多余的内存组成新的空闲块，插入到链表中
        if (page->property > n) {
  1044ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044f0:	8b 40 08             	mov    0x8(%eax),%eax
  1044f3:	39 45 08             	cmp    %eax,0x8(%ebp)
  1044f6:	73 7f                	jae    104577 <default_alloc_pages+0x15a>
            struct Page *p=page+n;
  1044f8:	8b 55 08             	mov    0x8(%ebp),%edx
  1044fb:	89 d0                	mov    %edx,%eax
  1044fd:	c1 e0 02             	shl    $0x2,%eax
  104500:	01 d0                	add    %edx,%eax
  104502:	c1 e0 02             	shl    $0x2,%eax
  104505:	89 c2                	mov    %eax,%edx
  104507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10450a:	01 d0                	add    %edx,%eax
  10450c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property=page->property-n;
  10450f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104512:	8b 40 08             	mov    0x8(%eax),%eax
  104515:	2b 45 08             	sub    0x8(%ebp),%eax
  104518:	89 c2                	mov    %eax,%edx
  10451a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10451d:	89 50 08             	mov    %edx,0x8(%eax)
            //在原先的链表节点后插入新的空闲块节点
            list_add(&(page->page_link),&(p->page_link));
  104520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104523:	83 c0 0c             	add    $0xc,%eax
  104526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104529:	83 c2 0c             	add    $0xc,%edx
  10452c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10452f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104535:	89 45 cc             	mov    %eax,-0x34(%ebp)
  104538:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10453b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  10453e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104541:	8b 40 04             	mov    0x4(%eax),%eax
  104544:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104547:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  10454a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10454d:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104550:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
  104553:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104556:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104559:	89 10                	mov    %edx,(%eax)
  10455b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10455e:	8b 10                	mov    (%eax),%edx
  104560:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104563:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104566:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104569:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10456c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10456f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104572:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104575:	89 10                	mov    %edx,(%eax)
        }
        //原来的空闲块已经不再空闲了，从链表中删除
        list_del(&(page->page_link));
  104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10457a:	83 c0 0c             	add    $0xc,%eax
  10457d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_del(listelm->prev, listelm->next);
  104580:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104583:	8b 40 04             	mov    0x4(%eax),%eax
  104586:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104589:	8b 12                	mov    (%edx),%edx
  10458b:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  10458e:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104591:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104594:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104597:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10459a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10459d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1045a0:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  1045a2:	a1 44 af 11 00       	mov    0x11af44,%eax
  1045a7:	2b 45 08             	sub    0x8(%ebp),%eax
  1045aa:	a3 44 af 11 00       	mov    %eax,0x11af44
    }
    return page;
  1045af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1045b2:	c9                   	leave  
  1045b3:	c3                   	ret    

001045b4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  1045b4:	55                   	push   %ebp
  1045b5:	89 e5                	mov    %esp,%ebp
  1045b7:	81 ec 98 00 00 00    	sub    $0x98,%esp
 assert(n > 0);
  1045bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1045c1:	75 24                	jne    1045e7 <default_free_pages+0x33>
  1045c3:	c7 44 24 0c f8 6c 10 	movl   $0x106cf8,0xc(%esp)
  1045ca:	00 
  1045cb:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1045d2:	00 
  1045d3:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  1045da:	00 
  1045db:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1045e2:	e8 02 be ff ff       	call   1003e9 <__panic>
    struct Page *p = base;
  1045e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1045ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1045ed:	e9 9d 00 00 00       	jmp    10468f <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  1045f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f5:	83 c0 04             	add    $0x4,%eax
  1045f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1045ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104602:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104605:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104608:	0f a3 10             	bt     %edx,(%eax)
  10460b:	19 c0                	sbb    %eax,%eax
  10460d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104614:	0f 95 c0             	setne  %al
  104617:	0f b6 c0             	movzbl %al,%eax
  10461a:	85 c0                	test   %eax,%eax
  10461c:	75 2c                	jne    10464a <default_free_pages+0x96>
  10461e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104621:	83 c0 04             	add    $0x4,%eax
  104624:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10462b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10462e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104631:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104634:	0f a3 10             	bt     %edx,(%eax)
  104637:	19 c0                	sbb    %eax,%eax
  104639:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10463c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104640:	0f 95 c0             	setne  %al
  104643:	0f b6 c0             	movzbl %al,%eax
  104646:	85 c0                	test   %eax,%eax
  104648:	74 24                	je     10466e <default_free_pages+0xba>
  10464a:	c7 44 24 0c 3c 6d 10 	movl   $0x106d3c,0xc(%esp)
  104651:	00 
  104652:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104659:	00 
  10465a:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  104661:	00 
  104662:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104669:	e8 7b bd ff ff       	call   1003e9 <__panic>
        p->flags = 0;
  10466e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104678:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10467f:	00 
  104680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104683:	89 04 24             	mov    %eax,(%esp)
  104686:	e8 fa fb ff ff       	call   104285 <set_page_ref>
    for (; p != base + n; p ++) {
  10468b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10468f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104692:	89 d0                	mov    %edx,%eax
  104694:	c1 e0 02             	shl    $0x2,%eax
  104697:	01 d0                	add    %edx,%eax
  104699:	c1 e0 02             	shl    $0x2,%eax
  10469c:	89 c2                	mov    %eax,%edx
  10469e:	8b 45 08             	mov    0x8(%ebp),%eax
  1046a1:	01 d0                	add    %edx,%eax
  1046a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1046a6:	0f 85 46 ff ff ff    	jne    1045f2 <default_free_pages+0x3e>
    }
    base->property = n;
  1046ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1046af:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046b2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1046b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b8:	83 c0 04             	add    $0x4,%eax
  1046bb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1046c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1046c8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1046cb:	0f ab 10             	bts    %edx,(%eax)
  1046ce:	c7 45 d4 3c af 11 00 	movl   $0x11af3c,-0x2c(%ebp)
    return listelm->next;
  1046d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1046d8:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  1046db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1046de:	e9 08 01 00 00       	jmp    1047eb <default_free_pages+0x237>
        p = le2page(le, page_link);
  1046e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046e6:	83 e8 0c             	sub    $0xc,%eax
  1046e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1046ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1046f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1046f5:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1046f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  1046fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1046fe:	8b 50 08             	mov    0x8(%eax),%edx
  104701:	89 d0                	mov    %edx,%eax
  104703:	c1 e0 02             	shl    $0x2,%eax
  104706:	01 d0                	add    %edx,%eax
  104708:	c1 e0 02             	shl    $0x2,%eax
  10470b:	89 c2                	mov    %eax,%edx
  10470d:	8b 45 08             	mov    0x8(%ebp),%eax
  104710:	01 d0                	add    %edx,%eax
  104712:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104715:	75 5a                	jne    104771 <default_free_pages+0x1bd>
            base->property += p->property;
  104717:	8b 45 08             	mov    0x8(%ebp),%eax
  10471a:	8b 50 08             	mov    0x8(%eax),%edx
  10471d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104720:	8b 40 08             	mov    0x8(%eax),%eax
  104723:	01 c2                	add    %eax,%edx
  104725:	8b 45 08             	mov    0x8(%ebp),%eax
  104728:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  10472b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472e:	83 c0 04             	add    $0x4,%eax
  104731:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104738:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10473b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10473e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104741:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104747:	83 c0 0c             	add    $0xc,%eax
  10474a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  10474d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104750:	8b 40 04             	mov    0x4(%eax),%eax
  104753:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104756:	8b 12                	mov    (%edx),%edx
  104758:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10475b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  10475e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104761:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104764:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104767:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10476a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10476d:	89 10                	mov    %edx,(%eax)
  10476f:	eb 7a                	jmp    1047eb <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104774:	8b 50 08             	mov    0x8(%eax),%edx
  104777:	89 d0                	mov    %edx,%eax
  104779:	c1 e0 02             	shl    $0x2,%eax
  10477c:	01 d0                	add    %edx,%eax
  10477e:	c1 e0 02             	shl    $0x2,%eax
  104781:	89 c2                	mov    %eax,%edx
  104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104786:	01 d0                	add    %edx,%eax
  104788:	39 45 08             	cmp    %eax,0x8(%ebp)
  10478b:	75 5e                	jne    1047eb <default_free_pages+0x237>
            p->property += base->property;
  10478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104790:	8b 50 08             	mov    0x8(%eax),%edx
  104793:	8b 45 08             	mov    0x8(%ebp),%eax
  104796:	8b 40 08             	mov    0x8(%eax),%eax
  104799:	01 c2                	add    %eax,%edx
  10479b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10479e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1047a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047a4:	83 c0 04             	add    $0x4,%eax
  1047a7:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  1047ae:	89 45 a0             	mov    %eax,-0x60(%ebp)
  1047b1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1047b4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1047b7:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  1047ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047bd:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  1047c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c3:	83 c0 0c             	add    $0xc,%eax
  1047c6:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  1047c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1047cc:	8b 40 04             	mov    0x4(%eax),%eax
  1047cf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1047d2:	8b 12                	mov    (%edx),%edx
  1047d4:	89 55 ac             	mov    %edx,-0x54(%ebp)
  1047d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  1047da:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1047dd:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1047e0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1047e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1047e6:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1047e9:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  1047eb:	81 7d f0 3c af 11 00 	cmpl   $0x11af3c,-0x10(%ebp)
  1047f2:	0f 85 eb fe ff ff    	jne    1046e3 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  1047f8:	8b 15 44 af 11 00    	mov    0x11af44,%edx
  1047fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104801:	01 d0                	add    %edx,%eax
  104803:	a3 44 af 11 00       	mov    %eax,0x11af44
  104808:	c7 45 9c 3c af 11 00 	movl   $0x11af3c,-0x64(%ebp)
    return listelm->next;
  10480f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104812:	8b 40 04             	mov    0x4(%eax),%eax
    for (le=list_next(&free_list);le!=&free_list;le=list_next(le))
  104815:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104818:	eb 2b                	jmp    104845 <default_free_pages+0x291>
        if (base + base->property <= p) //base后的第一个内存块
  10481a:	8b 45 08             	mov    0x8(%ebp),%eax
  10481d:	8b 50 08             	mov    0x8(%eax),%edx
  104820:	89 d0                	mov    %edx,%eax
  104822:	c1 e0 02             	shl    $0x2,%eax
  104825:	01 d0                	add    %edx,%eax
  104827:	c1 e0 02             	shl    $0x2,%eax
  10482a:	89 c2                	mov    %eax,%edx
  10482c:	8b 45 08             	mov    0x8(%ebp),%eax
  10482f:	01 d0                	add    %edx,%eax
  104831:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104834:	73 1a                	jae    104850 <default_free_pages+0x29c>
  104836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104839:	89 45 98             	mov    %eax,-0x68(%ebp)
  10483c:	8b 45 98             	mov    -0x68(%ebp),%eax
  10483f:	8b 40 04             	mov    0x4(%eax),%eax
    for (le=list_next(&free_list);le!=&free_list;le=list_next(le))
  104842:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104845:	81 7d f0 3c af 11 00 	cmpl   $0x11af3c,-0x10(%ebp)
  10484c:	75 cc                	jne    10481a <default_free_pages+0x266>
  10484e:	eb 01                	jmp    104851 <default_free_pages+0x29d>
            break;
  104850:	90                   	nop
    //插入到base后第一个内存块之前
    list_add_before(le, &(base->page_link));
  104851:	8b 45 08             	mov    0x8(%ebp),%eax
  104854:	8d 50 0c             	lea    0xc(%eax),%edx
  104857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10485a:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10485d:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104860:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104863:	8b 00                	mov    (%eax),%eax
  104865:	8b 55 90             	mov    -0x70(%ebp),%edx
  104868:	89 55 8c             	mov    %edx,-0x74(%ebp)
  10486b:	89 45 88             	mov    %eax,-0x78(%ebp)
  10486e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104871:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104874:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104877:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10487a:	89 10                	mov    %edx,(%eax)
  10487c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10487f:	8b 10                	mov    (%eax),%edx
  104881:	8b 45 88             	mov    -0x78(%ebp),%eax
  104884:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104887:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10488a:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10488d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104890:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104893:	8b 55 88             	mov    -0x78(%ebp),%edx
  104896:	89 10                	mov    %edx,(%eax)
} 
  104898:	90                   	nop
  104899:	c9                   	leave  
  10489a:	c3                   	ret    

0010489b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10489b:	55                   	push   %ebp
  10489c:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10489e:	a1 44 af 11 00       	mov    0x11af44,%eax
}
  1048a3:	5d                   	pop    %ebp
  1048a4:	c3                   	ret    

001048a5 <basic_check>:

static void
basic_check(void) {
  1048a5:	55                   	push   %ebp
  1048a6:	89 e5                	mov    %esp,%ebp
  1048a8:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1048ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1048be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048c5:	e8 92 e2 ff ff       	call   102b5c <alloc_pages>
  1048ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1048cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1048d1:	75 24                	jne    1048f7 <basic_check+0x52>
  1048d3:	c7 44 24 0c 61 6d 10 	movl   $0x106d61,0xc(%esp)
  1048da:	00 
  1048db:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1048e2:	00 
  1048e3:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  1048ea:	00 
  1048eb:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1048f2:	e8 f2 ba ff ff       	call   1003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1048f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048fe:	e8 59 e2 ff ff       	call   102b5c <alloc_pages>
  104903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10490a:	75 24                	jne    104930 <basic_check+0x8b>
  10490c:	c7 44 24 0c 7d 6d 10 	movl   $0x106d7d,0xc(%esp)
  104913:	00 
  104914:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10491b:	00 
  10491c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  104923:	00 
  104924:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10492b:	e8 b9 ba ff ff       	call   1003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104930:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104937:	e8 20 e2 ff ff       	call   102b5c <alloc_pages>
  10493c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10493f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104943:	75 24                	jne    104969 <basic_check+0xc4>
  104945:	c7 44 24 0c 99 6d 10 	movl   $0x106d99,0xc(%esp)
  10494c:	00 
  10494d:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104954:	00 
  104955:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  10495c:	00 
  10495d:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104964:	e8 80 ba ff ff       	call   1003e9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10496c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10496f:	74 10                	je     104981 <basic_check+0xdc>
  104971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104974:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104977:	74 08                	je     104981 <basic_check+0xdc>
  104979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10497c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10497f:	75 24                	jne    1049a5 <basic_check+0x100>
  104981:	c7 44 24 0c b8 6d 10 	movl   $0x106db8,0xc(%esp)
  104988:	00 
  104989:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104990:	00 
  104991:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104998:	00 
  104999:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1049a0:	e8 44 ba ff ff       	call   1003e9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1049a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049a8:	89 04 24             	mov    %eax,(%esp)
  1049ab:	e8 cb f8 ff ff       	call   10427b <page_ref>
  1049b0:	85 c0                	test   %eax,%eax
  1049b2:	75 1e                	jne    1049d2 <basic_check+0x12d>
  1049b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049b7:	89 04 24             	mov    %eax,(%esp)
  1049ba:	e8 bc f8 ff ff       	call   10427b <page_ref>
  1049bf:	85 c0                	test   %eax,%eax
  1049c1:	75 0f                	jne    1049d2 <basic_check+0x12d>
  1049c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049c6:	89 04 24             	mov    %eax,(%esp)
  1049c9:	e8 ad f8 ff ff       	call   10427b <page_ref>
  1049ce:	85 c0                	test   %eax,%eax
  1049d0:	74 24                	je     1049f6 <basic_check+0x151>
  1049d2:	c7 44 24 0c dc 6d 10 	movl   $0x106ddc,0xc(%esp)
  1049d9:	00 
  1049da:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1049e1:	00 
  1049e2:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1049e9:	00 
  1049ea:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1049f1:	e8 f3 b9 ff ff       	call   1003e9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1049f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049f9:	89 04 24             	mov    %eax,(%esp)
  1049fc:	e8 64 f8 ff ff       	call   104265 <page2pa>
  104a01:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  104a07:	c1 e2 0c             	shl    $0xc,%edx
  104a0a:	39 d0                	cmp    %edx,%eax
  104a0c:	72 24                	jb     104a32 <basic_check+0x18d>
  104a0e:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  104a15:	00 
  104a16:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104a1d:	00 
  104a1e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104a25:	00 
  104a26:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104a2d:	e8 b7 b9 ff ff       	call   1003e9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a35:	89 04 24             	mov    %eax,(%esp)
  104a38:	e8 28 f8 ff ff       	call   104265 <page2pa>
  104a3d:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  104a43:	c1 e2 0c             	shl    $0xc,%edx
  104a46:	39 d0                	cmp    %edx,%eax
  104a48:	72 24                	jb     104a6e <basic_check+0x1c9>
  104a4a:	c7 44 24 0c 35 6e 10 	movl   $0x106e35,0xc(%esp)
  104a51:	00 
  104a52:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104a59:	00 
  104a5a:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104a61:	00 
  104a62:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104a69:	e8 7b b9 ff ff       	call   1003e9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a71:	89 04 24             	mov    %eax,(%esp)
  104a74:	e8 ec f7 ff ff       	call   104265 <page2pa>
  104a79:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  104a7f:	c1 e2 0c             	shl    $0xc,%edx
  104a82:	39 d0                	cmp    %edx,%eax
  104a84:	72 24                	jb     104aaa <basic_check+0x205>
  104a86:	c7 44 24 0c 52 6e 10 	movl   $0x106e52,0xc(%esp)
  104a8d:	00 
  104a8e:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104a95:	00 
  104a96:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104a9d:	00 
  104a9e:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104aa5:	e8 3f b9 ff ff       	call   1003e9 <__panic>

    list_entry_t free_list_store = free_list;
  104aaa:	a1 3c af 11 00       	mov    0x11af3c,%eax
  104aaf:	8b 15 40 af 11 00    	mov    0x11af40,%edx
  104ab5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104ab8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104abb:	c7 45 dc 3c af 11 00 	movl   $0x11af3c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104ac2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ac5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104ac8:	89 50 04             	mov    %edx,0x4(%eax)
  104acb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ace:	8b 50 04             	mov    0x4(%eax),%edx
  104ad1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ad4:	89 10                	mov    %edx,(%eax)
  104ad6:	c7 45 e0 3c af 11 00 	movl   $0x11af3c,-0x20(%ebp)
    return list->next == list;
  104add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ae0:	8b 40 04             	mov    0x4(%eax),%eax
  104ae3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104ae6:	0f 94 c0             	sete   %al
  104ae9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104aec:	85 c0                	test   %eax,%eax
  104aee:	75 24                	jne    104b14 <basic_check+0x26f>
  104af0:	c7 44 24 0c 6f 6e 10 	movl   $0x106e6f,0xc(%esp)
  104af7:	00 
  104af8:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104aff:	00 
  104b00:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104b07:	00 
  104b08:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104b0f:	e8 d5 b8 ff ff       	call   1003e9 <__panic>

    unsigned int nr_free_store = nr_free;
  104b14:	a1 44 af 11 00       	mov    0x11af44,%eax
  104b19:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104b1c:	c7 05 44 af 11 00 00 	movl   $0x0,0x11af44
  104b23:	00 00 00 

    assert(alloc_page() == NULL);
  104b26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b2d:	e8 2a e0 ff ff       	call   102b5c <alloc_pages>
  104b32:	85 c0                	test   %eax,%eax
  104b34:	74 24                	je     104b5a <basic_check+0x2b5>
  104b36:	c7 44 24 0c 86 6e 10 	movl   $0x106e86,0xc(%esp)
  104b3d:	00 
  104b3e:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104b45:	00 
  104b46:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  104b4d:	00 
  104b4e:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104b55:	e8 8f b8 ff ff       	call   1003e9 <__panic>

    free_page(p0);
  104b5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b61:	00 
  104b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b65:	89 04 24             	mov    %eax,(%esp)
  104b68:	e8 27 e0 ff ff       	call   102b94 <free_pages>
    free_page(p1);
  104b6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b74:	00 
  104b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b78:	89 04 24             	mov    %eax,(%esp)
  104b7b:	e8 14 e0 ff ff       	call   102b94 <free_pages>
    free_page(p2);
  104b80:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104b87:	00 
  104b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b8b:	89 04 24             	mov    %eax,(%esp)
  104b8e:	e8 01 e0 ff ff       	call   102b94 <free_pages>
    assert(nr_free == 3);
  104b93:	a1 44 af 11 00       	mov    0x11af44,%eax
  104b98:	83 f8 03             	cmp    $0x3,%eax
  104b9b:	74 24                	je     104bc1 <basic_check+0x31c>
  104b9d:	c7 44 24 0c 9b 6e 10 	movl   $0x106e9b,0xc(%esp)
  104ba4:	00 
  104ba5:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104bac:	00 
  104bad:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  104bb4:	00 
  104bb5:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104bbc:	e8 28 b8 ff ff       	call   1003e9 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104bc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bc8:	e8 8f df ff ff       	call   102b5c <alloc_pages>
  104bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104bd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104bd4:	75 24                	jne    104bfa <basic_check+0x355>
  104bd6:	c7 44 24 0c 61 6d 10 	movl   $0x106d61,0xc(%esp)
  104bdd:	00 
  104bde:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104be5:	00 
  104be6:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104bed:	00 
  104bee:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104bf5:	e8 ef b7 ff ff       	call   1003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104bfa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c01:	e8 56 df ff ff       	call   102b5c <alloc_pages>
  104c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c0d:	75 24                	jne    104c33 <basic_check+0x38e>
  104c0f:	c7 44 24 0c 7d 6d 10 	movl   $0x106d7d,0xc(%esp)
  104c16:	00 
  104c17:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104c1e:	00 
  104c1f:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104c26:	00 
  104c27:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104c2e:	e8 b6 b7 ff ff       	call   1003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104c33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c3a:	e8 1d df ff ff       	call   102b5c <alloc_pages>
  104c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104c42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104c46:	75 24                	jne    104c6c <basic_check+0x3c7>
  104c48:	c7 44 24 0c 99 6d 10 	movl   $0x106d99,0xc(%esp)
  104c4f:	00 
  104c50:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104c57:	00 
  104c58:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  104c5f:	00 
  104c60:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104c67:	e8 7d b7 ff ff       	call   1003e9 <__panic>

    assert(alloc_page() == NULL);
  104c6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c73:	e8 e4 de ff ff       	call   102b5c <alloc_pages>
  104c78:	85 c0                	test   %eax,%eax
  104c7a:	74 24                	je     104ca0 <basic_check+0x3fb>
  104c7c:	c7 44 24 0c 86 6e 10 	movl   $0x106e86,0xc(%esp)
  104c83:	00 
  104c84:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104c8b:	00 
  104c8c:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  104c93:	00 
  104c94:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104c9b:	e8 49 b7 ff ff       	call   1003e9 <__panic>

    free_page(p0);
  104ca0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ca7:	00 
  104ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cab:	89 04 24             	mov    %eax,(%esp)
  104cae:	e8 e1 de ff ff       	call   102b94 <free_pages>
  104cb3:	c7 45 d8 3c af 11 00 	movl   $0x11af3c,-0x28(%ebp)
  104cba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104cbd:	8b 40 04             	mov    0x4(%eax),%eax
  104cc0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104cc3:	0f 94 c0             	sete   %al
  104cc6:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104cc9:	85 c0                	test   %eax,%eax
  104ccb:	74 24                	je     104cf1 <basic_check+0x44c>
  104ccd:	c7 44 24 0c a8 6e 10 	movl   $0x106ea8,0xc(%esp)
  104cd4:	00 
  104cd5:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104cdc:	00 
  104cdd:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  104ce4:	00 
  104ce5:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104cec:	e8 f8 b6 ff ff       	call   1003e9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104cf1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cf8:	e8 5f de ff ff       	call   102b5c <alloc_pages>
  104cfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104d00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104d06:	74 24                	je     104d2c <basic_check+0x487>
  104d08:	c7 44 24 0c c0 6e 10 	movl   $0x106ec0,0xc(%esp)
  104d0f:	00 
  104d10:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104d17:	00 
  104d18:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104d1f:	00 
  104d20:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104d27:	e8 bd b6 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  104d2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d33:	e8 24 de ff ff       	call   102b5c <alloc_pages>
  104d38:	85 c0                	test   %eax,%eax
  104d3a:	74 24                	je     104d60 <basic_check+0x4bb>
  104d3c:	c7 44 24 0c 86 6e 10 	movl   $0x106e86,0xc(%esp)
  104d43:	00 
  104d44:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104d4b:	00 
  104d4c:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  104d53:	00 
  104d54:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104d5b:	e8 89 b6 ff ff       	call   1003e9 <__panic>

    assert(nr_free == 0);
  104d60:	a1 44 af 11 00       	mov    0x11af44,%eax
  104d65:	85 c0                	test   %eax,%eax
  104d67:	74 24                	je     104d8d <basic_check+0x4e8>
  104d69:	c7 44 24 0c d9 6e 10 	movl   $0x106ed9,0xc(%esp)
  104d70:	00 
  104d71:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104d78:	00 
  104d79:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104d80:	00 
  104d81:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104d88:	e8 5c b6 ff ff       	call   1003e9 <__panic>
    free_list = free_list_store;
  104d8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104d93:	a3 3c af 11 00       	mov    %eax,0x11af3c
  104d98:	89 15 40 af 11 00    	mov    %edx,0x11af40
    nr_free = nr_free_store;
  104d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104da1:	a3 44 af 11 00       	mov    %eax,0x11af44

    free_page(p);
  104da6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104dad:	00 
  104dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104db1:	89 04 24             	mov    %eax,(%esp)
  104db4:	e8 db dd ff ff       	call   102b94 <free_pages>
    free_page(p1);
  104db9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104dc0:	00 
  104dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dc4:	89 04 24             	mov    %eax,(%esp)
  104dc7:	e8 c8 dd ff ff       	call   102b94 <free_pages>
    free_page(p2);
  104dcc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104dd3:	00 
  104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dd7:	89 04 24             	mov    %eax,(%esp)
  104dda:	e8 b5 dd ff ff       	call   102b94 <free_pages>
}
  104ddf:	90                   	nop
  104de0:	c9                   	leave  
  104de1:	c3                   	ret    

00104de2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104de2:	55                   	push   %ebp
  104de3:	89 e5                	mov    %esp,%ebp
  104de5:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104df2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104df9:	c7 45 ec 3c af 11 00 	movl   $0x11af3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104e00:	eb 6a                	jmp    104e6c <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  104e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e05:	83 e8 0c             	sub    $0xc,%eax
  104e08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104e0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104e0e:	83 c0 04             	add    $0x4,%eax
  104e11:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104e18:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104e1e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104e21:	0f a3 10             	bt     %edx,(%eax)
  104e24:	19 c0                	sbb    %eax,%eax
  104e26:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104e29:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104e2d:	0f 95 c0             	setne  %al
  104e30:	0f b6 c0             	movzbl %al,%eax
  104e33:	85 c0                	test   %eax,%eax
  104e35:	75 24                	jne    104e5b <default_check+0x79>
  104e37:	c7 44 24 0c e6 6e 10 	movl   $0x106ee6,0xc(%esp)
  104e3e:	00 
  104e3f:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104e46:	00 
  104e47:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  104e4e:	00 
  104e4f:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104e56:	e8 8e b5 ff ff       	call   1003e9 <__panic>
        count ++, total += p->property;
  104e5b:	ff 45 f4             	incl   -0xc(%ebp)
  104e5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104e61:	8b 50 08             	mov    0x8(%eax),%edx
  104e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e67:	01 d0                	add    %edx,%eax
  104e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e6f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104e72:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104e75:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e7b:	81 7d ec 3c af 11 00 	cmpl   $0x11af3c,-0x14(%ebp)
  104e82:	0f 85 7a ff ff ff    	jne    104e02 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  104e88:	e8 3a dd ff ff       	call   102bc7 <nr_free_pages>
  104e8d:	89 c2                	mov    %eax,%edx
  104e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e92:	39 c2                	cmp    %eax,%edx
  104e94:	74 24                	je     104eba <default_check+0xd8>
  104e96:	c7 44 24 0c f6 6e 10 	movl   $0x106ef6,0xc(%esp)
  104e9d:	00 
  104e9e:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104ea5:	00 
  104ea6:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104ead:	00 
  104eae:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104eb5:	e8 2f b5 ff ff       	call   1003e9 <__panic>

    basic_check();
  104eba:	e8 e6 f9 ff ff       	call   1048a5 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104ebf:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104ec6:	e8 91 dc ff ff       	call   102b5c <alloc_pages>
  104ecb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  104ece:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104ed2:	75 24                	jne    104ef8 <default_check+0x116>
  104ed4:	c7 44 24 0c 0f 6f 10 	movl   $0x106f0f,0xc(%esp)
  104edb:	00 
  104edc:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104ee3:	00 
  104ee4:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  104eeb:	00 
  104eec:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104ef3:	e8 f1 b4 ff ff       	call   1003e9 <__panic>
    assert(!PageProperty(p0));
  104ef8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104efb:	83 c0 04             	add    $0x4,%eax
  104efe:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104f05:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f08:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104f0b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104f0e:	0f a3 10             	bt     %edx,(%eax)
  104f11:	19 c0                	sbb    %eax,%eax
  104f13:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104f16:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104f1a:	0f 95 c0             	setne  %al
  104f1d:	0f b6 c0             	movzbl %al,%eax
  104f20:	85 c0                	test   %eax,%eax
  104f22:	74 24                	je     104f48 <default_check+0x166>
  104f24:	c7 44 24 0c 1a 6f 10 	movl   $0x106f1a,0xc(%esp)
  104f2b:	00 
  104f2c:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104f33:	00 
  104f34:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  104f3b:	00 
  104f3c:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104f43:	e8 a1 b4 ff ff       	call   1003e9 <__panic>

    list_entry_t free_list_store = free_list;
  104f48:	a1 3c af 11 00       	mov    0x11af3c,%eax
  104f4d:	8b 15 40 af 11 00    	mov    0x11af40,%edx
  104f53:	89 45 80             	mov    %eax,-0x80(%ebp)
  104f56:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104f59:	c7 45 b0 3c af 11 00 	movl   $0x11af3c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  104f60:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f63:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104f66:	89 50 04             	mov    %edx,0x4(%eax)
  104f69:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f6c:	8b 50 04             	mov    0x4(%eax),%edx
  104f6f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f72:	89 10                	mov    %edx,(%eax)
  104f74:	c7 45 b4 3c af 11 00 	movl   $0x11af3c,-0x4c(%ebp)
    return list->next == list;
  104f7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104f7e:	8b 40 04             	mov    0x4(%eax),%eax
  104f81:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  104f84:	0f 94 c0             	sete   %al
  104f87:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104f8a:	85 c0                	test   %eax,%eax
  104f8c:	75 24                	jne    104fb2 <default_check+0x1d0>
  104f8e:	c7 44 24 0c 6f 6e 10 	movl   $0x106e6f,0xc(%esp)
  104f95:	00 
  104f96:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104f9d:	00 
  104f9e:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104fa5:	00 
  104fa6:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104fad:	e8 37 b4 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  104fb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fb9:	e8 9e db ff ff       	call   102b5c <alloc_pages>
  104fbe:	85 c0                	test   %eax,%eax
  104fc0:	74 24                	je     104fe6 <default_check+0x204>
  104fc2:	c7 44 24 0c 86 6e 10 	movl   $0x106e86,0xc(%esp)
  104fc9:	00 
  104fca:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  104fd1:	00 
  104fd2:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  104fd9:	00 
  104fda:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  104fe1:	e8 03 b4 ff ff       	call   1003e9 <__panic>

    unsigned int nr_free_store = nr_free;
  104fe6:	a1 44 af 11 00       	mov    0x11af44,%eax
  104feb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  104fee:	c7 05 44 af 11 00 00 	movl   $0x0,0x11af44
  104ff5:	00 00 00 

    free_pages(p0 + 2, 3);
  104ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ffb:	83 c0 28             	add    $0x28,%eax
  104ffe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105005:	00 
  105006:	89 04 24             	mov    %eax,(%esp)
  105009:	e8 86 db ff ff       	call   102b94 <free_pages>
    assert(alloc_pages(4) == NULL);
  10500e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105015:	e8 42 db ff ff       	call   102b5c <alloc_pages>
  10501a:	85 c0                	test   %eax,%eax
  10501c:	74 24                	je     105042 <default_check+0x260>
  10501e:	c7 44 24 0c 2c 6f 10 	movl   $0x106f2c,0xc(%esp)
  105025:	00 
  105026:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10502d:	00 
  10502e:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  105035:	00 
  105036:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10503d:	e8 a7 b3 ff ff       	call   1003e9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105045:	83 c0 28             	add    $0x28,%eax
  105048:	83 c0 04             	add    $0x4,%eax
  10504b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105052:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105055:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105058:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10505b:	0f a3 10             	bt     %edx,(%eax)
  10505e:	19 c0                	sbb    %eax,%eax
  105060:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105063:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105067:	0f 95 c0             	setne  %al
  10506a:	0f b6 c0             	movzbl %al,%eax
  10506d:	85 c0                	test   %eax,%eax
  10506f:	74 0e                	je     10507f <default_check+0x29d>
  105071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105074:	83 c0 28             	add    $0x28,%eax
  105077:	8b 40 08             	mov    0x8(%eax),%eax
  10507a:	83 f8 03             	cmp    $0x3,%eax
  10507d:	74 24                	je     1050a3 <default_check+0x2c1>
  10507f:	c7 44 24 0c 44 6f 10 	movl   $0x106f44,0xc(%esp)
  105086:	00 
  105087:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10508e:	00 
  10508f:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  105096:	00 
  105097:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10509e:	e8 46 b3 ff ff       	call   1003e9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1050a3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1050aa:	e8 ad da ff ff       	call   102b5c <alloc_pages>
  1050af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1050b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1050b6:	75 24                	jne    1050dc <default_check+0x2fa>
  1050b8:	c7 44 24 0c 70 6f 10 	movl   $0x106f70,0xc(%esp)
  1050bf:	00 
  1050c0:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1050c7:	00 
  1050c8:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1050cf:	00 
  1050d0:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1050d7:	e8 0d b3 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  1050dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050e3:	e8 74 da ff ff       	call   102b5c <alloc_pages>
  1050e8:	85 c0                	test   %eax,%eax
  1050ea:	74 24                	je     105110 <default_check+0x32e>
  1050ec:	c7 44 24 0c 86 6e 10 	movl   $0x106e86,0xc(%esp)
  1050f3:	00 
  1050f4:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1050fb:	00 
  1050fc:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  105103:	00 
  105104:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10510b:	e8 d9 b2 ff ff       	call   1003e9 <__panic>
    assert(p0 + 2 == p1);
  105110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105113:	83 c0 28             	add    $0x28,%eax
  105116:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105119:	74 24                	je     10513f <default_check+0x35d>
  10511b:	c7 44 24 0c 8e 6f 10 	movl   $0x106f8e,0xc(%esp)
  105122:	00 
  105123:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10512a:	00 
  10512b:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105132:	00 
  105133:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10513a:	e8 aa b2 ff ff       	call   1003e9 <__panic>

    p2 = p0 + 1;
  10513f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105142:	83 c0 14             	add    $0x14,%eax
  105145:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  105148:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10514f:	00 
  105150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105153:	89 04 24             	mov    %eax,(%esp)
  105156:	e8 39 da ff ff       	call   102b94 <free_pages>
    free_pages(p1, 3);
  10515b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105162:	00 
  105163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105166:	89 04 24             	mov    %eax,(%esp)
  105169:	e8 26 da ff ff       	call   102b94 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10516e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105171:	83 c0 04             	add    $0x4,%eax
  105174:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10517b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10517e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105181:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105184:	0f a3 10             	bt     %edx,(%eax)
  105187:	19 c0                	sbb    %eax,%eax
  105189:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10518c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105190:	0f 95 c0             	setne  %al
  105193:	0f b6 c0             	movzbl %al,%eax
  105196:	85 c0                	test   %eax,%eax
  105198:	74 0b                	je     1051a5 <default_check+0x3c3>
  10519a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10519d:	8b 40 08             	mov    0x8(%eax),%eax
  1051a0:	83 f8 01             	cmp    $0x1,%eax
  1051a3:	74 24                	je     1051c9 <default_check+0x3e7>
  1051a5:	c7 44 24 0c 9c 6f 10 	movl   $0x106f9c,0xc(%esp)
  1051ac:	00 
  1051ad:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1051b4:	00 
  1051b5:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1051bc:	00 
  1051bd:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1051c4:	e8 20 b2 ff ff       	call   1003e9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1051c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051cc:	83 c0 04             	add    $0x4,%eax
  1051cf:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1051d6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051d9:	8b 45 90             	mov    -0x70(%ebp),%eax
  1051dc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1051df:	0f a3 10             	bt     %edx,(%eax)
  1051e2:	19 c0                	sbb    %eax,%eax
  1051e4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1051e7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1051eb:	0f 95 c0             	setne  %al
  1051ee:	0f b6 c0             	movzbl %al,%eax
  1051f1:	85 c0                	test   %eax,%eax
  1051f3:	74 0b                	je     105200 <default_check+0x41e>
  1051f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051f8:	8b 40 08             	mov    0x8(%eax),%eax
  1051fb:	83 f8 03             	cmp    $0x3,%eax
  1051fe:	74 24                	je     105224 <default_check+0x442>
  105200:	c7 44 24 0c c4 6f 10 	movl   $0x106fc4,0xc(%esp)
  105207:	00 
  105208:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10520f:	00 
  105210:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  105217:	00 
  105218:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10521f:	e8 c5 b1 ff ff       	call   1003e9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105224:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10522b:	e8 2c d9 ff ff       	call   102b5c <alloc_pages>
  105230:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105233:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105236:	83 e8 14             	sub    $0x14,%eax
  105239:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10523c:	74 24                	je     105262 <default_check+0x480>
  10523e:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  105245:	00 
  105246:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10524d:	00 
  10524e:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  105255:	00 
  105256:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10525d:	e8 87 b1 ff ff       	call   1003e9 <__panic>
    free_page(p0);
  105262:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105269:	00 
  10526a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10526d:	89 04 24             	mov    %eax,(%esp)
  105270:	e8 1f d9 ff ff       	call   102b94 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105275:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10527c:	e8 db d8 ff ff       	call   102b5c <alloc_pages>
  105281:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105284:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105287:	83 c0 14             	add    $0x14,%eax
  10528a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10528d:	74 24                	je     1052b3 <default_check+0x4d1>
  10528f:	c7 44 24 0c 08 70 10 	movl   $0x107008,0xc(%esp)
  105296:	00 
  105297:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10529e:	00 
  10529f:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  1052a6:	00 
  1052a7:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  1052ae:	e8 36 b1 ff ff       	call   1003e9 <__panic>

    free_pages(p0, 2);
  1052b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1052ba:	00 
  1052bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052be:	89 04 24             	mov    %eax,(%esp)
  1052c1:	e8 ce d8 ff ff       	call   102b94 <free_pages>
    free_page(p2);
  1052c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052cd:	00 
  1052ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052d1:	89 04 24             	mov    %eax,(%esp)
  1052d4:	e8 bb d8 ff ff       	call   102b94 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1052d9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1052e0:	e8 77 d8 ff ff       	call   102b5c <alloc_pages>
  1052e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1052ec:	75 24                	jne    105312 <default_check+0x530>
  1052ee:	c7 44 24 0c 28 70 10 	movl   $0x107028,0xc(%esp)
  1052f5:	00 
  1052f6:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1052fd:	00 
  1052fe:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  105305:	00 
  105306:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10530d:	e8 d7 b0 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  105312:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105319:	e8 3e d8 ff ff       	call   102b5c <alloc_pages>
  10531e:	85 c0                	test   %eax,%eax
  105320:	74 24                	je     105346 <default_check+0x564>
  105322:	c7 44 24 0c 86 6e 10 	movl   $0x106e86,0xc(%esp)
  105329:	00 
  10532a:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  105331:	00 
  105332:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  105339:	00 
  10533a:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  105341:	e8 a3 b0 ff ff       	call   1003e9 <__panic>

    assert(nr_free == 0);
  105346:	a1 44 af 11 00       	mov    0x11af44,%eax
  10534b:	85 c0                	test   %eax,%eax
  10534d:	74 24                	je     105373 <default_check+0x591>
  10534f:	c7 44 24 0c d9 6e 10 	movl   $0x106ed9,0xc(%esp)
  105356:	00 
  105357:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10535e:	00 
  10535f:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  105366:	00 
  105367:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10536e:	e8 76 b0 ff ff       	call   1003e9 <__panic>
    nr_free = nr_free_store;
  105373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105376:	a3 44 af 11 00       	mov    %eax,0x11af44

    free_list = free_list_store;
  10537b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10537e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105381:	a3 3c af 11 00       	mov    %eax,0x11af3c
  105386:	89 15 40 af 11 00    	mov    %edx,0x11af40
    free_pages(p0, 5);
  10538c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105393:	00 
  105394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105397:	89 04 24             	mov    %eax,(%esp)
  10539a:	e8 f5 d7 ff ff       	call   102b94 <free_pages>

    le = &free_list;
  10539f:	c7 45 ec 3c af 11 00 	movl   $0x11af3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1053a6:	eb 1c                	jmp    1053c4 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
  1053a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053ab:	83 e8 0c             	sub    $0xc,%eax
  1053ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  1053b1:	ff 4d f4             	decl   -0xc(%ebp)
  1053b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1053b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1053ba:	8b 40 08             	mov    0x8(%eax),%eax
  1053bd:	29 c2                	sub    %eax,%edx
  1053bf:	89 d0                	mov    %edx,%eax
  1053c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053c7:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1053ca:	8b 45 88             	mov    -0x78(%ebp),%eax
  1053cd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1053d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1053d3:	81 7d ec 3c af 11 00 	cmpl   $0x11af3c,-0x14(%ebp)
  1053da:	75 cc                	jne    1053a8 <default_check+0x5c6>
    }
    assert(count == 0);
  1053dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1053e0:	74 24                	je     105406 <default_check+0x624>
  1053e2:	c7 44 24 0c 46 70 10 	movl   $0x107046,0xc(%esp)
  1053e9:	00 
  1053ea:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1053f1:	00 
  1053f2:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  1053f9:	00 
  1053fa:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  105401:	e8 e3 af ff ff       	call   1003e9 <__panic>
    assert(total == 0);
  105406:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10540a:	74 24                	je     105430 <default_check+0x64e>
  10540c:	c7 44 24 0c 51 70 10 	movl   $0x107051,0xc(%esp)
  105413:	00 
  105414:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  10541b:	00 
  10541c:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  105423:	00 
  105424:	c7 04 24 13 6d 10 00 	movl   $0x106d13,(%esp)
  10542b:	e8 b9 af ff ff       	call   1003e9 <__panic>
}
  105430:	90                   	nop
  105431:	c9                   	leave  
  105432:	c3                   	ret    

00105433 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105433:	55                   	push   %ebp
  105434:	89 e5                	mov    %esp,%ebp
  105436:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105439:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105440:	eb 03                	jmp    105445 <strlen+0x12>
        cnt ++;
  105442:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105445:	8b 45 08             	mov    0x8(%ebp),%eax
  105448:	8d 50 01             	lea    0x1(%eax),%edx
  10544b:	89 55 08             	mov    %edx,0x8(%ebp)
  10544e:	0f b6 00             	movzbl (%eax),%eax
  105451:	84 c0                	test   %al,%al
  105453:	75 ed                	jne    105442 <strlen+0xf>
    }
    return cnt;
  105455:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105458:	c9                   	leave  
  105459:	c3                   	ret    

0010545a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10545a:	55                   	push   %ebp
  10545b:	89 e5                	mov    %esp,%ebp
  10545d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105467:	eb 03                	jmp    10546c <strnlen+0x12>
        cnt ++;
  105469:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10546c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10546f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105472:	73 10                	jae    105484 <strnlen+0x2a>
  105474:	8b 45 08             	mov    0x8(%ebp),%eax
  105477:	8d 50 01             	lea    0x1(%eax),%edx
  10547a:	89 55 08             	mov    %edx,0x8(%ebp)
  10547d:	0f b6 00             	movzbl (%eax),%eax
  105480:	84 c0                	test   %al,%al
  105482:	75 e5                	jne    105469 <strnlen+0xf>
    }
    return cnt;
  105484:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105487:	c9                   	leave  
  105488:	c3                   	ret    

00105489 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105489:	55                   	push   %ebp
  10548a:	89 e5                	mov    %esp,%ebp
  10548c:	57                   	push   %edi
  10548d:	56                   	push   %esi
  10548e:	83 ec 20             	sub    $0x20,%esp
  105491:	8b 45 08             	mov    0x8(%ebp),%eax
  105494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105497:	8b 45 0c             	mov    0xc(%ebp),%eax
  10549a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10549d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054a3:	89 d1                	mov    %edx,%ecx
  1054a5:	89 c2                	mov    %eax,%edx
  1054a7:	89 ce                	mov    %ecx,%esi
  1054a9:	89 d7                	mov    %edx,%edi
  1054ab:	ac                   	lods   %ds:(%esi),%al
  1054ac:	aa                   	stos   %al,%es:(%edi)
  1054ad:	84 c0                	test   %al,%al
  1054af:	75 fa                	jne    1054ab <strcpy+0x22>
  1054b1:	89 fa                	mov    %edi,%edx
  1054b3:	89 f1                	mov    %esi,%ecx
  1054b5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1054b8:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1054bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1054be:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1054c1:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1054c2:	83 c4 20             	add    $0x20,%esp
  1054c5:	5e                   	pop    %esi
  1054c6:	5f                   	pop    %edi
  1054c7:	5d                   	pop    %ebp
  1054c8:	c3                   	ret    

001054c9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1054c9:	55                   	push   %ebp
  1054ca:	89 e5                	mov    %esp,%ebp
  1054cc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1054cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1054d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1054d5:	eb 1e                	jmp    1054f5 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  1054d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054da:	0f b6 10             	movzbl (%eax),%edx
  1054dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054e0:	88 10                	mov    %dl,(%eax)
  1054e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054e5:	0f b6 00             	movzbl (%eax),%eax
  1054e8:	84 c0                	test   %al,%al
  1054ea:	74 03                	je     1054ef <strncpy+0x26>
            src ++;
  1054ec:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1054ef:	ff 45 fc             	incl   -0x4(%ebp)
  1054f2:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1054f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1054f9:	75 dc                	jne    1054d7 <strncpy+0xe>
    }
    return dst;
  1054fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1054fe:	c9                   	leave  
  1054ff:	c3                   	ret    

00105500 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105500:	55                   	push   %ebp
  105501:	89 e5                	mov    %esp,%ebp
  105503:	57                   	push   %edi
  105504:	56                   	push   %esi
  105505:	83 ec 20             	sub    $0x20,%esp
  105508:	8b 45 08             	mov    0x8(%ebp),%eax
  10550b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10550e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105511:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10551a:	89 d1                	mov    %edx,%ecx
  10551c:	89 c2                	mov    %eax,%edx
  10551e:	89 ce                	mov    %ecx,%esi
  105520:	89 d7                	mov    %edx,%edi
  105522:	ac                   	lods   %ds:(%esi),%al
  105523:	ae                   	scas   %es:(%edi),%al
  105524:	75 08                	jne    10552e <strcmp+0x2e>
  105526:	84 c0                	test   %al,%al
  105528:	75 f8                	jne    105522 <strcmp+0x22>
  10552a:	31 c0                	xor    %eax,%eax
  10552c:	eb 04                	jmp    105532 <strcmp+0x32>
  10552e:	19 c0                	sbb    %eax,%eax
  105530:	0c 01                	or     $0x1,%al
  105532:	89 fa                	mov    %edi,%edx
  105534:	89 f1                	mov    %esi,%ecx
  105536:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105539:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10553c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  10553f:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105542:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105543:	83 c4 20             	add    $0x20,%esp
  105546:	5e                   	pop    %esi
  105547:	5f                   	pop    %edi
  105548:	5d                   	pop    %ebp
  105549:	c3                   	ret    

0010554a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10554a:	55                   	push   %ebp
  10554b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10554d:	eb 09                	jmp    105558 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  10554f:	ff 4d 10             	decl   0x10(%ebp)
  105552:	ff 45 08             	incl   0x8(%ebp)
  105555:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105558:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10555c:	74 1a                	je     105578 <strncmp+0x2e>
  10555e:	8b 45 08             	mov    0x8(%ebp),%eax
  105561:	0f b6 00             	movzbl (%eax),%eax
  105564:	84 c0                	test   %al,%al
  105566:	74 10                	je     105578 <strncmp+0x2e>
  105568:	8b 45 08             	mov    0x8(%ebp),%eax
  10556b:	0f b6 10             	movzbl (%eax),%edx
  10556e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105571:	0f b6 00             	movzbl (%eax),%eax
  105574:	38 c2                	cmp    %al,%dl
  105576:	74 d7                	je     10554f <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105578:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10557c:	74 18                	je     105596 <strncmp+0x4c>
  10557e:	8b 45 08             	mov    0x8(%ebp),%eax
  105581:	0f b6 00             	movzbl (%eax),%eax
  105584:	0f b6 d0             	movzbl %al,%edx
  105587:	8b 45 0c             	mov    0xc(%ebp),%eax
  10558a:	0f b6 00             	movzbl (%eax),%eax
  10558d:	0f b6 c0             	movzbl %al,%eax
  105590:	29 c2                	sub    %eax,%edx
  105592:	89 d0                	mov    %edx,%eax
  105594:	eb 05                	jmp    10559b <strncmp+0x51>
  105596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10559b:	5d                   	pop    %ebp
  10559c:	c3                   	ret    

0010559d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10559d:	55                   	push   %ebp
  10559e:	89 e5                	mov    %esp,%ebp
  1055a0:	83 ec 04             	sub    $0x4,%esp
  1055a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055a6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1055a9:	eb 13                	jmp    1055be <strchr+0x21>
        if (*s == c) {
  1055ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ae:	0f b6 00             	movzbl (%eax),%eax
  1055b1:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1055b4:	75 05                	jne    1055bb <strchr+0x1e>
            return (char *)s;
  1055b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b9:	eb 12                	jmp    1055cd <strchr+0x30>
        }
        s ++;
  1055bb:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1055be:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c1:	0f b6 00             	movzbl (%eax),%eax
  1055c4:	84 c0                	test   %al,%al
  1055c6:	75 e3                	jne    1055ab <strchr+0xe>
    }
    return NULL;
  1055c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1055cd:	c9                   	leave  
  1055ce:	c3                   	ret    

001055cf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1055cf:	55                   	push   %ebp
  1055d0:	89 e5                	mov    %esp,%ebp
  1055d2:	83 ec 04             	sub    $0x4,%esp
  1055d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055d8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1055db:	eb 0e                	jmp    1055eb <strfind+0x1c>
        if (*s == c) {
  1055dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e0:	0f b6 00             	movzbl (%eax),%eax
  1055e3:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1055e6:	74 0f                	je     1055f7 <strfind+0x28>
            break;
        }
        s ++;
  1055e8:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1055eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ee:	0f b6 00             	movzbl (%eax),%eax
  1055f1:	84 c0                	test   %al,%al
  1055f3:	75 e8                	jne    1055dd <strfind+0xe>
  1055f5:	eb 01                	jmp    1055f8 <strfind+0x29>
            break;
  1055f7:	90                   	nop
    }
    return (char *)s;
  1055f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1055fb:	c9                   	leave  
  1055fc:	c3                   	ret    

001055fd <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1055fd:	55                   	push   %ebp
  1055fe:	89 e5                	mov    %esp,%ebp
  105600:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10560a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105611:	eb 03                	jmp    105616 <strtol+0x19>
        s ++;
  105613:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105616:	8b 45 08             	mov    0x8(%ebp),%eax
  105619:	0f b6 00             	movzbl (%eax),%eax
  10561c:	3c 20                	cmp    $0x20,%al
  10561e:	74 f3                	je     105613 <strtol+0x16>
  105620:	8b 45 08             	mov    0x8(%ebp),%eax
  105623:	0f b6 00             	movzbl (%eax),%eax
  105626:	3c 09                	cmp    $0x9,%al
  105628:	74 e9                	je     105613 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  10562a:	8b 45 08             	mov    0x8(%ebp),%eax
  10562d:	0f b6 00             	movzbl (%eax),%eax
  105630:	3c 2b                	cmp    $0x2b,%al
  105632:	75 05                	jne    105639 <strtol+0x3c>
        s ++;
  105634:	ff 45 08             	incl   0x8(%ebp)
  105637:	eb 14                	jmp    10564d <strtol+0x50>
    }
    else if (*s == '-') {
  105639:	8b 45 08             	mov    0x8(%ebp),%eax
  10563c:	0f b6 00             	movzbl (%eax),%eax
  10563f:	3c 2d                	cmp    $0x2d,%al
  105641:	75 0a                	jne    10564d <strtol+0x50>
        s ++, neg = 1;
  105643:	ff 45 08             	incl   0x8(%ebp)
  105646:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10564d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105651:	74 06                	je     105659 <strtol+0x5c>
  105653:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105657:	75 22                	jne    10567b <strtol+0x7e>
  105659:	8b 45 08             	mov    0x8(%ebp),%eax
  10565c:	0f b6 00             	movzbl (%eax),%eax
  10565f:	3c 30                	cmp    $0x30,%al
  105661:	75 18                	jne    10567b <strtol+0x7e>
  105663:	8b 45 08             	mov    0x8(%ebp),%eax
  105666:	40                   	inc    %eax
  105667:	0f b6 00             	movzbl (%eax),%eax
  10566a:	3c 78                	cmp    $0x78,%al
  10566c:	75 0d                	jne    10567b <strtol+0x7e>
        s += 2, base = 16;
  10566e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105672:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105679:	eb 29                	jmp    1056a4 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  10567b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10567f:	75 16                	jne    105697 <strtol+0x9a>
  105681:	8b 45 08             	mov    0x8(%ebp),%eax
  105684:	0f b6 00             	movzbl (%eax),%eax
  105687:	3c 30                	cmp    $0x30,%al
  105689:	75 0c                	jne    105697 <strtol+0x9a>
        s ++, base = 8;
  10568b:	ff 45 08             	incl   0x8(%ebp)
  10568e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105695:	eb 0d                	jmp    1056a4 <strtol+0xa7>
    }
    else if (base == 0) {
  105697:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10569b:	75 07                	jne    1056a4 <strtol+0xa7>
        base = 10;
  10569d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1056a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a7:	0f b6 00             	movzbl (%eax),%eax
  1056aa:	3c 2f                	cmp    $0x2f,%al
  1056ac:	7e 1b                	jle    1056c9 <strtol+0xcc>
  1056ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b1:	0f b6 00             	movzbl (%eax),%eax
  1056b4:	3c 39                	cmp    $0x39,%al
  1056b6:	7f 11                	jg     1056c9 <strtol+0xcc>
            dig = *s - '0';
  1056b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056bb:	0f b6 00             	movzbl (%eax),%eax
  1056be:	0f be c0             	movsbl %al,%eax
  1056c1:	83 e8 30             	sub    $0x30,%eax
  1056c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056c7:	eb 48                	jmp    105711 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1056c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056cc:	0f b6 00             	movzbl (%eax),%eax
  1056cf:	3c 60                	cmp    $0x60,%al
  1056d1:	7e 1b                	jle    1056ee <strtol+0xf1>
  1056d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d6:	0f b6 00             	movzbl (%eax),%eax
  1056d9:	3c 7a                	cmp    $0x7a,%al
  1056db:	7f 11                	jg     1056ee <strtol+0xf1>
            dig = *s - 'a' + 10;
  1056dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e0:	0f b6 00             	movzbl (%eax),%eax
  1056e3:	0f be c0             	movsbl %al,%eax
  1056e6:	83 e8 57             	sub    $0x57,%eax
  1056e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056ec:	eb 23                	jmp    105711 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1056ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f1:	0f b6 00             	movzbl (%eax),%eax
  1056f4:	3c 40                	cmp    $0x40,%al
  1056f6:	7e 3b                	jle    105733 <strtol+0x136>
  1056f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fb:	0f b6 00             	movzbl (%eax),%eax
  1056fe:	3c 5a                	cmp    $0x5a,%al
  105700:	7f 31                	jg     105733 <strtol+0x136>
            dig = *s - 'A' + 10;
  105702:	8b 45 08             	mov    0x8(%ebp),%eax
  105705:	0f b6 00             	movzbl (%eax),%eax
  105708:	0f be c0             	movsbl %al,%eax
  10570b:	83 e8 37             	sub    $0x37,%eax
  10570e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105714:	3b 45 10             	cmp    0x10(%ebp),%eax
  105717:	7d 19                	jge    105732 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105719:	ff 45 08             	incl   0x8(%ebp)
  10571c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10571f:	0f af 45 10          	imul   0x10(%ebp),%eax
  105723:	89 c2                	mov    %eax,%edx
  105725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105728:	01 d0                	add    %edx,%eax
  10572a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  10572d:	e9 72 ff ff ff       	jmp    1056a4 <strtol+0xa7>
            break;
  105732:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105733:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105737:	74 08                	je     105741 <strtol+0x144>
        *endptr = (char *) s;
  105739:	8b 45 0c             	mov    0xc(%ebp),%eax
  10573c:	8b 55 08             	mov    0x8(%ebp),%edx
  10573f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105741:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105745:	74 07                	je     10574e <strtol+0x151>
  105747:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10574a:	f7 d8                	neg    %eax
  10574c:	eb 03                	jmp    105751 <strtol+0x154>
  10574e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105751:	c9                   	leave  
  105752:	c3                   	ret    

00105753 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105753:	55                   	push   %ebp
  105754:	89 e5                	mov    %esp,%ebp
  105756:	57                   	push   %edi
  105757:	83 ec 24             	sub    $0x24,%esp
  10575a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10575d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105760:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105764:	8b 55 08             	mov    0x8(%ebp),%edx
  105767:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10576a:	88 45 f7             	mov    %al,-0x9(%ebp)
  10576d:	8b 45 10             	mov    0x10(%ebp),%eax
  105770:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105773:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105776:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10577a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10577d:	89 d7                	mov    %edx,%edi
  10577f:	f3 aa                	rep stos %al,%es:(%edi)
  105781:	89 fa                	mov    %edi,%edx
  105783:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105786:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105789:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10578c:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10578d:	83 c4 24             	add    $0x24,%esp
  105790:	5f                   	pop    %edi
  105791:	5d                   	pop    %ebp
  105792:	c3                   	ret    

00105793 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105793:	55                   	push   %ebp
  105794:	89 e5                	mov    %esp,%ebp
  105796:	57                   	push   %edi
  105797:	56                   	push   %esi
  105798:	53                   	push   %ebx
  105799:	83 ec 30             	sub    $0x30,%esp
  10579c:	8b 45 08             	mov    0x8(%ebp),%eax
  10579f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1057a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1057ab:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1057ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1057b4:	73 42                	jae    1057f8 <memmove+0x65>
  1057b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1057bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1057c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1057c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057cb:	c1 e8 02             	shr    $0x2,%eax
  1057ce:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1057d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1057d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057d6:	89 d7                	mov    %edx,%edi
  1057d8:	89 c6                	mov    %eax,%esi
  1057da:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1057dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1057df:	83 e1 03             	and    $0x3,%ecx
  1057e2:	74 02                	je     1057e6 <memmove+0x53>
  1057e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1057e6:	89 f0                	mov    %esi,%eax
  1057e8:	89 fa                	mov    %edi,%edx
  1057ea:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1057ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1057f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1057f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1057f6:	eb 36                	jmp    10582e <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1057f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1057fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105801:	01 c2                	add    %eax,%edx
  105803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105806:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10580c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10580f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105812:	89 c1                	mov    %eax,%ecx
  105814:	89 d8                	mov    %ebx,%eax
  105816:	89 d6                	mov    %edx,%esi
  105818:	89 c7                	mov    %eax,%edi
  10581a:	fd                   	std    
  10581b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10581d:	fc                   	cld    
  10581e:	89 f8                	mov    %edi,%eax
  105820:	89 f2                	mov    %esi,%edx
  105822:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105825:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105828:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10582b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10582e:	83 c4 30             	add    $0x30,%esp
  105831:	5b                   	pop    %ebx
  105832:	5e                   	pop    %esi
  105833:	5f                   	pop    %edi
  105834:	5d                   	pop    %ebp
  105835:	c3                   	ret    

00105836 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105836:	55                   	push   %ebp
  105837:	89 e5                	mov    %esp,%ebp
  105839:	57                   	push   %edi
  10583a:	56                   	push   %esi
  10583b:	83 ec 20             	sub    $0x20,%esp
  10583e:	8b 45 08             	mov    0x8(%ebp),%eax
  105841:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105844:	8b 45 0c             	mov    0xc(%ebp),%eax
  105847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10584a:	8b 45 10             	mov    0x10(%ebp),%eax
  10584d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105853:	c1 e8 02             	shr    $0x2,%eax
  105856:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10585b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10585e:	89 d7                	mov    %edx,%edi
  105860:	89 c6                	mov    %eax,%esi
  105862:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105864:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105867:	83 e1 03             	and    $0x3,%ecx
  10586a:	74 02                	je     10586e <memcpy+0x38>
  10586c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10586e:	89 f0                	mov    %esi,%eax
  105870:	89 fa                	mov    %edi,%edx
  105872:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105875:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105878:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10587b:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  10587e:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10587f:	83 c4 20             	add    $0x20,%esp
  105882:	5e                   	pop    %esi
  105883:	5f                   	pop    %edi
  105884:	5d                   	pop    %ebp
  105885:	c3                   	ret    

00105886 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105886:	55                   	push   %ebp
  105887:	89 e5                	mov    %esp,%ebp
  105889:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10588c:	8b 45 08             	mov    0x8(%ebp),%eax
  10588f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105892:	8b 45 0c             	mov    0xc(%ebp),%eax
  105895:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105898:	eb 2e                	jmp    1058c8 <memcmp+0x42>
        if (*s1 != *s2) {
  10589a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10589d:	0f b6 10             	movzbl (%eax),%edx
  1058a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058a3:	0f b6 00             	movzbl (%eax),%eax
  1058a6:	38 c2                	cmp    %al,%dl
  1058a8:	74 18                	je     1058c2 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1058aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1058ad:	0f b6 00             	movzbl (%eax),%eax
  1058b0:	0f b6 d0             	movzbl %al,%edx
  1058b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058b6:	0f b6 00             	movzbl (%eax),%eax
  1058b9:	0f b6 c0             	movzbl %al,%eax
  1058bc:	29 c2                	sub    %eax,%edx
  1058be:	89 d0                	mov    %edx,%eax
  1058c0:	eb 18                	jmp    1058da <memcmp+0x54>
        }
        s1 ++, s2 ++;
  1058c2:	ff 45 fc             	incl   -0x4(%ebp)
  1058c5:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1058c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1058cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1058ce:	89 55 10             	mov    %edx,0x10(%ebp)
  1058d1:	85 c0                	test   %eax,%eax
  1058d3:	75 c5                	jne    10589a <memcmp+0x14>
    }
    return 0;
  1058d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1058da:	c9                   	leave  
  1058db:	c3                   	ret    

001058dc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1058dc:	55                   	push   %ebp
  1058dd:	89 e5                	mov    %esp,%ebp
  1058df:	83 ec 58             	sub    $0x58,%esp
  1058e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1058e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1058e8:	8b 45 14             	mov    0x14(%ebp),%eax
  1058eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1058ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1058f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1058f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058f7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1058fa:	8b 45 18             	mov    0x18(%ebp),%eax
  1058fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105903:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105906:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105909:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10590c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10590f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105912:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105916:	74 1c                	je     105934 <printnum+0x58>
  105918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10591b:	ba 00 00 00 00       	mov    $0x0,%edx
  105920:	f7 75 e4             	divl   -0x1c(%ebp)
  105923:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105929:	ba 00 00 00 00       	mov    $0x0,%edx
  10592e:	f7 75 e4             	divl   -0x1c(%ebp)
  105931:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105934:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105937:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10593a:	f7 75 e4             	divl   -0x1c(%ebp)
  10593d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105940:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105943:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105949:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10594c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10594f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105952:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105955:	8b 45 18             	mov    0x18(%ebp),%eax
  105958:	ba 00 00 00 00       	mov    $0x0,%edx
  10595d:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105960:	72 56                	jb     1059b8 <printnum+0xdc>
  105962:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105965:	77 05                	ja     10596c <printnum+0x90>
  105967:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10596a:	72 4c                	jb     1059b8 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10596c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10596f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105972:	8b 45 20             	mov    0x20(%ebp),%eax
  105975:	89 44 24 18          	mov    %eax,0x18(%esp)
  105979:	89 54 24 14          	mov    %edx,0x14(%esp)
  10597d:	8b 45 18             	mov    0x18(%ebp),%eax
  105980:	89 44 24 10          	mov    %eax,0x10(%esp)
  105984:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105987:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10598a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10598e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105992:	8b 45 0c             	mov    0xc(%ebp),%eax
  105995:	89 44 24 04          	mov    %eax,0x4(%esp)
  105999:	8b 45 08             	mov    0x8(%ebp),%eax
  10599c:	89 04 24             	mov    %eax,(%esp)
  10599f:	e8 38 ff ff ff       	call   1058dc <printnum>
  1059a4:	eb 1b                	jmp    1059c1 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1059a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ad:	8b 45 20             	mov    0x20(%ebp),%eax
  1059b0:	89 04 24             	mov    %eax,(%esp)
  1059b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b6:	ff d0                	call   *%eax
        while (-- width > 0)
  1059b8:	ff 4d 1c             	decl   0x1c(%ebp)
  1059bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1059bf:	7f e5                	jg     1059a6 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1059c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1059c4:	05 0c 71 10 00       	add    $0x10710c,%eax
  1059c9:	0f b6 00             	movzbl (%eax),%eax
  1059cc:	0f be c0             	movsbl %al,%eax
  1059cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059d6:	89 04 24             	mov    %eax,(%esp)
  1059d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059dc:	ff d0                	call   *%eax
}
  1059de:	90                   	nop
  1059df:	c9                   	leave  
  1059e0:	c3                   	ret    

001059e1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1059e1:	55                   	push   %ebp
  1059e2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1059e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1059e8:	7e 14                	jle    1059fe <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1059ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ed:	8b 00                	mov    (%eax),%eax
  1059ef:	8d 48 08             	lea    0x8(%eax),%ecx
  1059f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1059f5:	89 0a                	mov    %ecx,(%edx)
  1059f7:	8b 50 04             	mov    0x4(%eax),%edx
  1059fa:	8b 00                	mov    (%eax),%eax
  1059fc:	eb 30                	jmp    105a2e <getuint+0x4d>
    }
    else if (lflag) {
  1059fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105a02:	74 16                	je     105a1a <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105a04:	8b 45 08             	mov    0x8(%ebp),%eax
  105a07:	8b 00                	mov    (%eax),%eax
  105a09:	8d 48 04             	lea    0x4(%eax),%ecx
  105a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  105a0f:	89 0a                	mov    %ecx,(%edx)
  105a11:	8b 00                	mov    (%eax),%eax
  105a13:	ba 00 00 00 00       	mov    $0x0,%edx
  105a18:	eb 14                	jmp    105a2e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1d:	8b 00                	mov    (%eax),%eax
  105a1f:	8d 48 04             	lea    0x4(%eax),%ecx
  105a22:	8b 55 08             	mov    0x8(%ebp),%edx
  105a25:	89 0a                	mov    %ecx,(%edx)
  105a27:	8b 00                	mov    (%eax),%eax
  105a29:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105a2e:	5d                   	pop    %ebp
  105a2f:	c3                   	ret    

00105a30 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105a30:	55                   	push   %ebp
  105a31:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105a33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105a37:	7e 14                	jle    105a4d <getint+0x1d>
        return va_arg(*ap, long long);
  105a39:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3c:	8b 00                	mov    (%eax),%eax
  105a3e:	8d 48 08             	lea    0x8(%eax),%ecx
  105a41:	8b 55 08             	mov    0x8(%ebp),%edx
  105a44:	89 0a                	mov    %ecx,(%edx)
  105a46:	8b 50 04             	mov    0x4(%eax),%edx
  105a49:	8b 00                	mov    (%eax),%eax
  105a4b:	eb 28                	jmp    105a75 <getint+0x45>
    }
    else if (lflag) {
  105a4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105a51:	74 12                	je     105a65 <getint+0x35>
        return va_arg(*ap, long);
  105a53:	8b 45 08             	mov    0x8(%ebp),%eax
  105a56:	8b 00                	mov    (%eax),%eax
  105a58:	8d 48 04             	lea    0x4(%eax),%ecx
  105a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  105a5e:	89 0a                	mov    %ecx,(%edx)
  105a60:	8b 00                	mov    (%eax),%eax
  105a62:	99                   	cltd   
  105a63:	eb 10                	jmp    105a75 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105a65:	8b 45 08             	mov    0x8(%ebp),%eax
  105a68:	8b 00                	mov    (%eax),%eax
  105a6a:	8d 48 04             	lea    0x4(%eax),%ecx
  105a6d:	8b 55 08             	mov    0x8(%ebp),%edx
  105a70:	89 0a                	mov    %ecx,(%edx)
  105a72:	8b 00                	mov    (%eax),%eax
  105a74:	99                   	cltd   
    }
}
  105a75:	5d                   	pop    %ebp
  105a76:	c3                   	ret    

00105a77 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105a77:	55                   	push   %ebp
  105a78:	89 e5                	mov    %esp,%ebp
  105a7a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105a7d:	8d 45 14             	lea    0x14(%ebp),%eax
  105a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a86:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  105a8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a98:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9b:	89 04 24             	mov    %eax,(%esp)
  105a9e:	e8 03 00 00 00       	call   105aa6 <vprintfmt>
    va_end(ap);
}
  105aa3:	90                   	nop
  105aa4:	c9                   	leave  
  105aa5:	c3                   	ret    

00105aa6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105aa6:	55                   	push   %ebp
  105aa7:	89 e5                	mov    %esp,%ebp
  105aa9:	56                   	push   %esi
  105aaa:	53                   	push   %ebx
  105aab:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105aae:	eb 17                	jmp    105ac7 <vprintfmt+0x21>
            if (ch == '\0') {
  105ab0:	85 db                	test   %ebx,%ebx
  105ab2:	0f 84 bf 03 00 00    	je     105e77 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105abf:	89 1c 24             	mov    %ebx,(%esp)
  105ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac5:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  105aca:	8d 50 01             	lea    0x1(%eax),%edx
  105acd:	89 55 10             	mov    %edx,0x10(%ebp)
  105ad0:	0f b6 00             	movzbl (%eax),%eax
  105ad3:	0f b6 d8             	movzbl %al,%ebx
  105ad6:	83 fb 25             	cmp    $0x25,%ebx
  105ad9:	75 d5                	jne    105ab0 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105adb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105adf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ae9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105aec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105af3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105af6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105af9:	8b 45 10             	mov    0x10(%ebp),%eax
  105afc:	8d 50 01             	lea    0x1(%eax),%edx
  105aff:	89 55 10             	mov    %edx,0x10(%ebp)
  105b02:	0f b6 00             	movzbl (%eax),%eax
  105b05:	0f b6 d8             	movzbl %al,%ebx
  105b08:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105b0b:	83 f8 55             	cmp    $0x55,%eax
  105b0e:	0f 87 37 03 00 00    	ja     105e4b <vprintfmt+0x3a5>
  105b14:	8b 04 85 30 71 10 00 	mov    0x107130(,%eax,4),%eax
  105b1b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105b1d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105b21:	eb d6                	jmp    105af9 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105b23:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105b27:	eb d0                	jmp    105af9 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105b29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b33:	89 d0                	mov    %edx,%eax
  105b35:	c1 e0 02             	shl    $0x2,%eax
  105b38:	01 d0                	add    %edx,%eax
  105b3a:	01 c0                	add    %eax,%eax
  105b3c:	01 d8                	add    %ebx,%eax
  105b3e:	83 e8 30             	sub    $0x30,%eax
  105b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105b44:	8b 45 10             	mov    0x10(%ebp),%eax
  105b47:	0f b6 00             	movzbl (%eax),%eax
  105b4a:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105b4d:	83 fb 2f             	cmp    $0x2f,%ebx
  105b50:	7e 38                	jle    105b8a <vprintfmt+0xe4>
  105b52:	83 fb 39             	cmp    $0x39,%ebx
  105b55:	7f 33                	jg     105b8a <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105b57:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105b5a:	eb d4                	jmp    105b30 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  105b5f:	8d 50 04             	lea    0x4(%eax),%edx
  105b62:	89 55 14             	mov    %edx,0x14(%ebp)
  105b65:	8b 00                	mov    (%eax),%eax
  105b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105b6a:	eb 1f                	jmp    105b8b <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  105b6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b70:	79 87                	jns    105af9 <vprintfmt+0x53>
                width = 0;
  105b72:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105b79:	e9 7b ff ff ff       	jmp    105af9 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105b7e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105b85:	e9 6f ff ff ff       	jmp    105af9 <vprintfmt+0x53>
            goto process_precision;
  105b8a:	90                   	nop

        process_precision:
            if (width < 0)
  105b8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b8f:	0f 89 64 ff ff ff    	jns    105af9 <vprintfmt+0x53>
                width = precision, precision = -1;
  105b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b98:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b9b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105ba2:	e9 52 ff ff ff       	jmp    105af9 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105ba7:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105baa:	e9 4a ff ff ff       	jmp    105af9 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105baf:	8b 45 14             	mov    0x14(%ebp),%eax
  105bb2:	8d 50 04             	lea    0x4(%eax),%edx
  105bb5:	89 55 14             	mov    %edx,0x14(%ebp)
  105bb8:	8b 00                	mov    (%eax),%eax
  105bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  105bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  105bc1:	89 04 24             	mov    %eax,(%esp)
  105bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc7:	ff d0                	call   *%eax
            break;
  105bc9:	e9 a4 02 00 00       	jmp    105e72 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105bce:	8b 45 14             	mov    0x14(%ebp),%eax
  105bd1:	8d 50 04             	lea    0x4(%eax),%edx
  105bd4:	89 55 14             	mov    %edx,0x14(%ebp)
  105bd7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105bd9:	85 db                	test   %ebx,%ebx
  105bdb:	79 02                	jns    105bdf <vprintfmt+0x139>
                err = -err;
  105bdd:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105bdf:	83 fb 06             	cmp    $0x6,%ebx
  105be2:	7f 0b                	jg     105bef <vprintfmt+0x149>
  105be4:	8b 34 9d f0 70 10 00 	mov    0x1070f0(,%ebx,4),%esi
  105beb:	85 f6                	test   %esi,%esi
  105bed:	75 23                	jne    105c12 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  105bef:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105bf3:	c7 44 24 08 1d 71 10 	movl   $0x10711d,0x8(%esp)
  105bfa:	00 
  105bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c02:	8b 45 08             	mov    0x8(%ebp),%eax
  105c05:	89 04 24             	mov    %eax,(%esp)
  105c08:	e8 6a fe ff ff       	call   105a77 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105c0d:	e9 60 02 00 00       	jmp    105e72 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105c12:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105c16:	c7 44 24 08 26 71 10 	movl   $0x107126,0x8(%esp)
  105c1d:	00 
  105c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c25:	8b 45 08             	mov    0x8(%ebp),%eax
  105c28:	89 04 24             	mov    %eax,(%esp)
  105c2b:	e8 47 fe ff ff       	call   105a77 <printfmt>
            break;
  105c30:	e9 3d 02 00 00       	jmp    105e72 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105c35:	8b 45 14             	mov    0x14(%ebp),%eax
  105c38:	8d 50 04             	lea    0x4(%eax),%edx
  105c3b:	89 55 14             	mov    %edx,0x14(%ebp)
  105c3e:	8b 30                	mov    (%eax),%esi
  105c40:	85 f6                	test   %esi,%esi
  105c42:	75 05                	jne    105c49 <vprintfmt+0x1a3>
                p = "(null)";
  105c44:	be 29 71 10 00       	mov    $0x107129,%esi
            }
            if (width > 0 && padc != '-') {
  105c49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c4d:	7e 76                	jle    105cc5 <vprintfmt+0x21f>
  105c4f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105c53:	74 70                	je     105cc5 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c5c:	89 34 24             	mov    %esi,(%esp)
  105c5f:	e8 f6 f7 ff ff       	call   10545a <strnlen>
  105c64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c67:	29 c2                	sub    %eax,%edx
  105c69:	89 d0                	mov    %edx,%eax
  105c6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105c6e:	eb 16                	jmp    105c86 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  105c70:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c77:	89 54 24 04          	mov    %edx,0x4(%esp)
  105c7b:	89 04 24             	mov    %eax,(%esp)
  105c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c81:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c83:	ff 4d e8             	decl   -0x18(%ebp)
  105c86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c8a:	7f e4                	jg     105c70 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105c8c:	eb 37                	jmp    105cc5 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  105c8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105c92:	74 1f                	je     105cb3 <vprintfmt+0x20d>
  105c94:	83 fb 1f             	cmp    $0x1f,%ebx
  105c97:	7e 05                	jle    105c9e <vprintfmt+0x1f8>
  105c99:	83 fb 7e             	cmp    $0x7e,%ebx
  105c9c:	7e 15                	jle    105cb3 <vprintfmt+0x20d>
                    putch('?', putdat);
  105c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ca5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105cac:	8b 45 08             	mov    0x8(%ebp),%eax
  105caf:	ff d0                	call   *%eax
  105cb1:	eb 0f                	jmp    105cc2 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  105cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cba:	89 1c 24             	mov    %ebx,(%esp)
  105cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc0:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105cc2:	ff 4d e8             	decl   -0x18(%ebp)
  105cc5:	89 f0                	mov    %esi,%eax
  105cc7:	8d 70 01             	lea    0x1(%eax),%esi
  105cca:	0f b6 00             	movzbl (%eax),%eax
  105ccd:	0f be d8             	movsbl %al,%ebx
  105cd0:	85 db                	test   %ebx,%ebx
  105cd2:	74 27                	je     105cfb <vprintfmt+0x255>
  105cd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105cd8:	78 b4                	js     105c8e <vprintfmt+0x1e8>
  105cda:	ff 4d e4             	decl   -0x1c(%ebp)
  105cdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105ce1:	79 ab                	jns    105c8e <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  105ce3:	eb 16                	jmp    105cfb <vprintfmt+0x255>
                putch(' ', putdat);
  105ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf6:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105cf8:	ff 4d e8             	decl   -0x18(%ebp)
  105cfb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105cff:	7f e4                	jg     105ce5 <vprintfmt+0x23f>
            }
            break;
  105d01:	e9 6c 01 00 00       	jmp    105e72 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d0d:	8d 45 14             	lea    0x14(%ebp),%eax
  105d10:	89 04 24             	mov    %eax,(%esp)
  105d13:	e8 18 fd ff ff       	call   105a30 <getint>
  105d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d24:	85 d2                	test   %edx,%edx
  105d26:	79 26                	jns    105d4e <vprintfmt+0x2a8>
                putch('-', putdat);
  105d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d2f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105d36:	8b 45 08             	mov    0x8(%ebp),%eax
  105d39:	ff d0                	call   *%eax
                num = -(long long)num;
  105d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d41:	f7 d8                	neg    %eax
  105d43:	83 d2 00             	adc    $0x0,%edx
  105d46:	f7 da                	neg    %edx
  105d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105d4e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d55:	e9 a8 00 00 00       	jmp    105e02 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d61:	8d 45 14             	lea    0x14(%ebp),%eax
  105d64:	89 04 24             	mov    %eax,(%esp)
  105d67:	e8 75 fc ff ff       	call   1059e1 <getuint>
  105d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105d72:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d79:	e9 84 00 00 00       	jmp    105e02 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d81:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d85:	8d 45 14             	lea    0x14(%ebp),%eax
  105d88:	89 04 24             	mov    %eax,(%esp)
  105d8b:	e8 51 fc ff ff       	call   1059e1 <getuint>
  105d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d93:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105d96:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105d9d:	eb 63                	jmp    105e02 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105da6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105dad:	8b 45 08             	mov    0x8(%ebp),%eax
  105db0:	ff d0                	call   *%eax
            putch('x', putdat);
  105db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105db5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105db9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105dc5:	8b 45 14             	mov    0x14(%ebp),%eax
  105dc8:	8d 50 04             	lea    0x4(%eax),%edx
  105dcb:	89 55 14             	mov    %edx,0x14(%ebp)
  105dce:	8b 00                	mov    (%eax),%eax
  105dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105dd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105dda:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105de1:	eb 1f                	jmp    105e02 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105de6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dea:	8d 45 14             	lea    0x14(%ebp),%eax
  105ded:	89 04 24             	mov    %eax,(%esp)
  105df0:	e8 ec fb ff ff       	call   1059e1 <getuint>
  105df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105df8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105dfb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105e02:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e09:	89 54 24 18          	mov    %edx,0x18(%esp)
  105e0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105e10:	89 54 24 14          	mov    %edx,0x14(%esp)
  105e14:	89 44 24 10          	mov    %eax,0x10(%esp)
  105e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105e22:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e30:	89 04 24             	mov    %eax,(%esp)
  105e33:	e8 a4 fa ff ff       	call   1058dc <printnum>
            break;
  105e38:	eb 38                	jmp    105e72 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e41:	89 1c 24             	mov    %ebx,(%esp)
  105e44:	8b 45 08             	mov    0x8(%ebp),%eax
  105e47:	ff d0                	call   *%eax
            break;
  105e49:	eb 27                	jmp    105e72 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e52:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105e59:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105e5e:	ff 4d 10             	decl   0x10(%ebp)
  105e61:	eb 03                	jmp    105e66 <vprintfmt+0x3c0>
  105e63:	ff 4d 10             	decl   0x10(%ebp)
  105e66:	8b 45 10             	mov    0x10(%ebp),%eax
  105e69:	48                   	dec    %eax
  105e6a:	0f b6 00             	movzbl (%eax),%eax
  105e6d:	3c 25                	cmp    $0x25,%al
  105e6f:	75 f2                	jne    105e63 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105e71:	90                   	nop
    while (1) {
  105e72:	e9 37 fc ff ff       	jmp    105aae <vprintfmt+0x8>
                return;
  105e77:	90                   	nop
        }
    }
}
  105e78:	83 c4 40             	add    $0x40,%esp
  105e7b:	5b                   	pop    %ebx
  105e7c:	5e                   	pop    %esi
  105e7d:	5d                   	pop    %ebp
  105e7e:	c3                   	ret    

00105e7f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105e7f:	55                   	push   %ebp
  105e80:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e85:	8b 40 08             	mov    0x8(%eax),%eax
  105e88:	8d 50 01             	lea    0x1(%eax),%edx
  105e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e8e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e94:	8b 10                	mov    (%eax),%edx
  105e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e99:	8b 40 04             	mov    0x4(%eax),%eax
  105e9c:	39 c2                	cmp    %eax,%edx
  105e9e:	73 12                	jae    105eb2 <sprintputch+0x33>
        *b->buf ++ = ch;
  105ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ea3:	8b 00                	mov    (%eax),%eax
  105ea5:	8d 48 01             	lea    0x1(%eax),%ecx
  105ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  105eab:	89 0a                	mov    %ecx,(%edx)
  105ead:	8b 55 08             	mov    0x8(%ebp),%edx
  105eb0:	88 10                	mov    %dl,(%eax)
    }
}
  105eb2:	90                   	nop
  105eb3:	5d                   	pop    %ebp
  105eb4:	c3                   	ret    

00105eb5 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105eb5:	55                   	push   %ebp
  105eb6:	89 e5                	mov    %esp,%ebp
  105eb8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  105ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ec4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  105ecb:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed9:	89 04 24             	mov    %eax,(%esp)
  105edc:	e8 08 00 00 00       	call   105ee9 <vsnprintf>
  105ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ee7:	c9                   	leave  
  105ee8:	c3                   	ret    

00105ee9 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105ee9:	55                   	push   %ebp
  105eea:	89 e5                	mov    %esp,%ebp
  105eec:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105eef:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef8:	8d 50 ff             	lea    -0x1(%eax),%edx
  105efb:	8b 45 08             	mov    0x8(%ebp),%eax
  105efe:	01 d0                	add    %edx,%eax
  105f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105f0e:	74 0a                	je     105f1a <vsnprintf+0x31>
  105f10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f16:	39 c2                	cmp    %eax,%edx
  105f18:	76 07                	jbe    105f21 <vsnprintf+0x38>
        return -E_INVAL;
  105f1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105f1f:	eb 2a                	jmp    105f4b <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105f21:	8b 45 14             	mov    0x14(%ebp),%eax
  105f24:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105f28:	8b 45 10             	mov    0x10(%ebp),%eax
  105f2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f2f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105f32:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f36:	c7 04 24 7f 5e 10 00 	movl   $0x105e7f,(%esp)
  105f3d:	e8 64 fb ff ff       	call   105aa6 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f45:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105f4b:	c9                   	leave  
  105f4c:	c3                   	ret    
