
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 48 af 11 c0       	mov    $0xc011af48,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 f1 56 00 00       	call   c0105753 <memset>

    cons_init();                // init the console
c0100062:	e8 80 15 00 00       	call   c01015e7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 60 5f 10 c0 	movl   $0xc0105f60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 7c 5f 10 c0 	movl   $0xc0105f7c,(%esp)
c010007c:	e8 11 02 00 00       	call   c0100292 <cprintf>

    print_kerninfo();
c0100081:	e8 b2 08 00 00       	call   c0100938 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 89 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 9e 30 00 00       	call   c010312e <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 b7 16 00 00       	call   c010174c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 3c 18 00 00       	call   c01018d6 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 eb 0c 00 00       	call   c0100d8a <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 e2 17 00 00       	call   c0101886 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 b0 0c 00 00       	call   c0100d78 <mon_backtrace>
}
c01000c8:	90                   	nop
c01000c9:	c9                   	leave  
c01000ca:	c3                   	ret    

c01000cb <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cb:	55                   	push   %ebp
c01000cc:	89 e5                	mov    %esp,%ebp
c01000ce:	53                   	push   %ebx
c01000cf:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b4 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	83 c4 14             	add    $0x14,%esp
c01000f6:	5b                   	pop    %ebx
c01000f7:	5d                   	pop    %ebp
c01000f8:	c3                   	ret    

c01000f9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f9:	55                   	push   %ebp
c01000fa:	89 e5                	mov    %esp,%ebp
c01000fc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0100102:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100106:	8b 45 08             	mov    0x8(%ebp),%eax
c0100109:	89 04 24             	mov    %eax,(%esp)
c010010c:	e8 ba ff ff ff       	call   c01000cb <grade_backtrace1>
}
c0100111:	90                   	nop
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c2 ff ff ff       	call   c01000f9 <grade_backtrace0>
}
c0100137:	90                   	nop
c0100138:	c9                   	leave  
c0100139:	c3                   	ret    

c010013a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013a:	55                   	push   %ebp
c010013b:	89 e5                	mov    %esp,%ebp
c010013d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100140:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100143:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100146:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100149:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100150:	83 e0 03             	and    $0x3,%eax
c0100153:	89 c2                	mov    %eax,%edx
c0100155:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010015a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100162:	c7 04 24 81 5f 10 c0 	movl   $0xc0105f81,(%esp)
c0100169:	e8 24 01 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100172:	89 c2                	mov    %eax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 8f 5f 10 c0 	movl   $0xc0105f8f,(%esp)
c0100188:	e8 05 01 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	89 c2                	mov    %eax,%edx
c0100193:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100198:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a0:	c7 04 24 9d 5f 10 c0 	movl   $0xc0105f9d,(%esp)
c01001a7:	e8 e6 00 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ac:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b0:	89 c2                	mov    %eax,%edx
c01001b2:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001bf:	c7 04 24 ab 5f 10 c0 	movl   $0xc0105fab,(%esp)
c01001c6:	e8 c7 00 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001cf:	89 c2                	mov    %eax,%edx
c01001d1:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001de:	c7 04 24 b9 5f 10 c0 	movl   $0xc0105fb9,(%esp)
c01001e5:	e8 a8 00 00 00       	call   c0100292 <cprintf>
    round ++;
c01001ea:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001ef:	40                   	inc    %eax
c01001f0:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001f5:	90                   	nop
c01001f6:	c9                   	leave  
c01001f7:	c3                   	ret    

c01001f8 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f8:	55                   	push   %ebp
c01001f9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001fb:	90                   	nop
c01001fc:	5d                   	pop    %ebp
c01001fd:	c3                   	ret    

c01001fe <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fe:	55                   	push   %ebp
c01001ff:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100201:	90                   	nop
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
c0100207:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020a:	e8 2b ff ff ff       	call   c010013a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020f:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
c0100216:	e8 77 00 00 00       	call   c0100292 <cprintf>
    lab1_switch_to_user();
c010021b:	e8 d8 ff ff ff       	call   c01001f8 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100220:	e8 15 ff ff ff       	call   c010013a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100225:	c7 04 24 e8 5f 10 c0 	movl   $0xc0105fe8,(%esp)
c010022c:	e8 61 00 00 00       	call   c0100292 <cprintf>
    lab1_switch_to_kernel();
c0100231:	e8 c8 ff ff ff       	call   c01001fe <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100236:	e8 ff fe ff ff       	call   c010013a <lab1_print_cur_status>
}
c010023b:	90                   	nop
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100244:	8b 45 08             	mov    0x8(%ebp),%eax
c0100247:	89 04 24             	mov    %eax,(%esp)
c010024a:	e8 c5 13 00 00       	call   c0101614 <cons_putc>
    (*cnt) ++;
c010024f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100252:	8b 00                	mov    (%eax),%eax
c0100254:	8d 50 01             	lea    0x1(%eax),%edx
c0100257:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025a:	89 10                	mov    %edx,(%eax)
}
c010025c:	90                   	nop
c010025d:	c9                   	leave  
c010025e:	c3                   	ret    

c010025f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010025f:	55                   	push   %ebp
c0100260:	89 e5                	mov    %esp,%ebp
c0100262:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010026c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100273:	8b 45 08             	mov    0x8(%ebp),%eax
c0100276:	89 44 24 08          	mov    %eax,0x8(%esp)
c010027a:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010027d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100281:	c7 04 24 3e 02 10 c0 	movl   $0xc010023e,(%esp)
c0100288:	e8 19 58 00 00       	call   c0105aa6 <vprintfmt>
    return cnt;
c010028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100290:	c9                   	leave  
c0100291:	c3                   	ret    

c0100292 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100292:	55                   	push   %ebp
c0100293:	89 e5                	mov    %esp,%ebp
c0100295:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100298:	8d 45 0c             	lea    0xc(%ebp),%eax
c010029b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010029e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a8:	89 04 24             	mov    %eax,(%esp)
c01002ab:	e8 af ff ff ff       	call   c010025f <vcprintf>
c01002b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b6:	c9                   	leave  
c01002b7:	c3                   	ret    

c01002b8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b8:	55                   	push   %ebp
c01002b9:	89 e5                	mov    %esp,%ebp
c01002bb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002be:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c1:	89 04 24             	mov    %eax,(%esp)
c01002c4:	e8 4b 13 00 00       	call   c0101614 <cons_putc>
}
c01002c9:	90                   	nop
c01002ca:	c9                   	leave  
c01002cb:	c3                   	ret    

c01002cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002cc:	55                   	push   %ebp
c01002cd:	89 e5                	mov    %esp,%ebp
c01002cf:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d9:	eb 13                	jmp    c01002ee <cputs+0x22>
        cputch(c, &cnt);
c01002db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002df:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002e6:	89 04 24             	mov    %eax,(%esp)
c01002e9:	e8 50 ff ff ff       	call   c010023e <cputch>
    while ((c = *str ++) != '\0') {
c01002ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f1:	8d 50 01             	lea    0x1(%eax),%edx
c01002f4:	89 55 08             	mov    %edx,0x8(%ebp)
c01002f7:	0f b6 00             	movzbl (%eax),%eax
c01002fa:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002fd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100301:	75 d8                	jne    c01002db <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100303:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100306:	89 44 24 04          	mov    %eax,0x4(%esp)
c010030a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100311:	e8 28 ff ff ff       	call   c010023e <cputch>
    return cnt;
c0100316:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100319:	c9                   	leave  
c010031a:	c3                   	ret    

c010031b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010031b:	55                   	push   %ebp
c010031c:	89 e5                	mov    %esp,%ebp
c010031e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100321:	e8 2b 13 00 00       	call   c0101651 <cons_getc>
c0100326:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100329:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010032d:	74 f2                	je     c0100321 <getchar+0x6>
        /* do nothing */;
    return c;
c010032f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100332:	c9                   	leave  
c0100333:	c3                   	ret    

c0100334 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100334:	55                   	push   %ebp
c0100335:	89 e5                	mov    %esp,%ebp
c0100337:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010033a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010033e:	74 13                	je     c0100353 <readline+0x1f>
        cprintf("%s", prompt);
c0100340:	8b 45 08             	mov    0x8(%ebp),%eax
c0100343:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100347:	c7 04 24 07 60 10 c0 	movl   $0xc0106007,(%esp)
c010034e:	e8 3f ff ff ff       	call   c0100292 <cprintf>
    }
    int i = 0, c;
c0100353:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010035a:	e8 bc ff ff ff       	call   c010031b <getchar>
c010035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100366:	79 07                	jns    c010036f <readline+0x3b>
            return NULL;
c0100368:	b8 00 00 00 00       	mov    $0x0,%eax
c010036d:	eb 78                	jmp    c01003e7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010036f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100373:	7e 28                	jle    c010039d <readline+0x69>
c0100375:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010037c:	7f 1f                	jg     c010039d <readline+0x69>
            cputchar(c);
c010037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100381:	89 04 24             	mov    %eax,(%esp)
c0100384:	e8 2f ff ff ff       	call   c01002b8 <cputchar>
            buf[i ++] = c;
c0100389:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010038c:	8d 50 01             	lea    0x1(%eax),%edx
c010038f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100392:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100395:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c010039b:	eb 45                	jmp    c01003e2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c010039d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003a1:	75 16                	jne    c01003b9 <readline+0x85>
c01003a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003a7:	7e 10                	jle    c01003b9 <readline+0x85>
            cputchar(c);
c01003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003ac:	89 04 24             	mov    %eax,(%esp)
c01003af:	e8 04 ff ff ff       	call   c01002b8 <cputchar>
            i --;
c01003b4:	ff 4d f4             	decl   -0xc(%ebp)
c01003b7:	eb 29                	jmp    c01003e2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003bd:	74 06                	je     c01003c5 <readline+0x91>
c01003bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003c3:	75 95                	jne    c010035a <readline+0x26>
            cputchar(c);
c01003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c8:	89 04 24             	mov    %eax,(%esp)
c01003cb:	e8 e8 fe ff ff       	call   c01002b8 <cputchar>
            buf[i] = '\0';
c01003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d3:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01003d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003db:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01003e0:	eb 05                	jmp    c01003e7 <readline+0xb3>
        c = getchar();
c01003e2:	e9 73 ff ff ff       	jmp    c010035a <readline+0x26>
        }
    }
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ef:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c01003f4:	85 c0                	test   %eax,%eax
c01003f6:	75 5b                	jne    c0100453 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c01003f8:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c01003ff:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100402:	8d 45 14             	lea    0x14(%ebp),%eax
c0100405:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010040f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100412:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100416:	c7 04 24 0a 60 10 c0 	movl   $0xc010600a,(%esp)
c010041d:	e8 70 fe ff ff       	call   c0100292 <cprintf>
    vcprintf(fmt, ap);
c0100422:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100425:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100429:	8b 45 10             	mov    0x10(%ebp),%eax
c010042c:	89 04 24             	mov    %eax,(%esp)
c010042f:	e8 2b fe ff ff       	call   c010025f <vcprintf>
    cprintf("\n");
c0100434:	c7 04 24 26 60 10 c0 	movl   $0xc0106026,(%esp)
c010043b:	e8 52 fe ff ff       	call   c0100292 <cprintf>
    
    cprintf("stack trackback:\n");
c0100440:	c7 04 24 28 60 10 c0 	movl   $0xc0106028,(%esp)
c0100447:	e8 46 fe ff ff       	call   c0100292 <cprintf>
    print_stackframe();
c010044c:	e8 32 06 00 00       	call   c0100a83 <print_stackframe>
c0100451:	eb 01                	jmp    c0100454 <__panic+0x6b>
        goto panic_dead;
c0100453:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100454:	e8 34 14 00 00       	call   c010188d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100460:	e8 46 08 00 00       	call   c0100cab <kmonitor>
c0100465:	eb f2                	jmp    c0100459 <__panic+0x70>

c0100467 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100467:	55                   	push   %ebp
c0100468:	89 e5                	mov    %esp,%ebp
c010046a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010046d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100470:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100473:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100476:	89 44 24 08          	mov    %eax,0x8(%esp)
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100481:	c7 04 24 3a 60 10 c0 	movl   $0xc010603a,(%esp)
c0100488:	e8 05 fe ff ff       	call   c0100292 <cprintf>
    vcprintf(fmt, ap);
c010048d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100490:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100494:	8b 45 10             	mov    0x10(%ebp),%eax
c0100497:	89 04 24             	mov    %eax,(%esp)
c010049a:	e8 c0 fd ff ff       	call   c010025f <vcprintf>
    cprintf("\n");
c010049f:	c7 04 24 26 60 10 c0 	movl   $0xc0106026,(%esp)
c01004a6:	e8 e7 fd ff ff       	call   c0100292 <cprintf>
    va_end(ap);
}
c01004ab:	90                   	nop
c01004ac:	c9                   	leave  
c01004ad:	c3                   	ret    

c01004ae <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004ae:	55                   	push   %ebp
c01004af:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004b1:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c01004b6:	5d                   	pop    %ebp
c01004b7:	c3                   	ret    

c01004b8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004b8:	55                   	push   %ebp
c01004b9:	89 e5                	mov    %esp,%ebp
c01004bb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c1:	8b 00                	mov    (%eax),%eax
c01004c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	8b 00                	mov    (%eax),%eax
c01004cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004d5:	e9 ca 00 00 00       	jmp    c01005a4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004da:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004e0:	01 d0                	add    %edx,%eax
c01004e2:	89 c2                	mov    %eax,%edx
c01004e4:	c1 ea 1f             	shr    $0x1f,%edx
c01004e7:	01 d0                	add    %edx,%eax
c01004e9:	d1 f8                	sar    %eax
c01004eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004f1:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004f4:	eb 03                	jmp    c01004f9 <stab_binsearch+0x41>
            m --;
c01004f6:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004ff:	7c 1f                	jl     c0100520 <stab_binsearch+0x68>
c0100501:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100504:	89 d0                	mov    %edx,%eax
c0100506:	01 c0                	add    %eax,%eax
c0100508:	01 d0                	add    %edx,%eax
c010050a:	c1 e0 02             	shl    $0x2,%eax
c010050d:	89 c2                	mov    %eax,%edx
c010050f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100512:	01 d0                	add    %edx,%eax
c0100514:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100518:	0f b6 c0             	movzbl %al,%eax
c010051b:	39 45 14             	cmp    %eax,0x14(%ebp)
c010051e:	75 d6                	jne    c01004f6 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100526:	7d 09                	jge    c0100531 <stab_binsearch+0x79>
            l = true_m + 1;
c0100528:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010052b:	40                   	inc    %eax
c010052c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010052f:	eb 73                	jmp    c01005a4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100531:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100538:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010053b:	89 d0                	mov    %edx,%eax
c010053d:	01 c0                	add    %eax,%eax
c010053f:	01 d0                	add    %edx,%eax
c0100541:	c1 e0 02             	shl    $0x2,%eax
c0100544:	89 c2                	mov    %eax,%edx
c0100546:	8b 45 08             	mov    0x8(%ebp),%eax
c0100549:	01 d0                	add    %edx,%eax
c010054b:	8b 40 08             	mov    0x8(%eax),%eax
c010054e:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100551:	76 11                	jbe    c0100564 <stab_binsearch+0xac>
            *region_left = m;
c0100553:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100556:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100559:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010055b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010055e:	40                   	inc    %eax
c010055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100562:	eb 40                	jmp    c01005a4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c0100564:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100567:	89 d0                	mov    %edx,%eax
c0100569:	01 c0                	add    %eax,%eax
c010056b:	01 d0                	add    %edx,%eax
c010056d:	c1 e0 02             	shl    $0x2,%eax
c0100570:	89 c2                	mov    %eax,%edx
c0100572:	8b 45 08             	mov    0x8(%ebp),%eax
c0100575:	01 d0                	add    %edx,%eax
c0100577:	8b 40 08             	mov    0x8(%eax),%eax
c010057a:	39 45 18             	cmp    %eax,0x18(%ebp)
c010057d:	73 14                	jae    c0100593 <stab_binsearch+0xdb>
            *region_right = m - 1;
c010057f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100582:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100585:	8b 45 10             	mov    0x10(%ebp),%eax
c0100588:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010058d:	48                   	dec    %eax
c010058e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100591:	eb 11                	jmp    c01005a4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100593:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100596:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100599:	89 10                	mov    %edx,(%eax)
            l = m;
c010059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005a1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005aa:	0f 8e 2a ff ff ff    	jle    c01004da <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005b4:	75 0f                	jne    c01005c5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b9:	8b 00                	mov    (%eax),%eax
c01005bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005be:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005c3:	eb 3e                	jmp    c0100603 <stab_binsearch+0x14b>
        l = *region_right;
c01005c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c8:	8b 00                	mov    (%eax),%eax
c01005ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005cd:	eb 03                	jmp    c01005d2 <stab_binsearch+0x11a>
c01005cf:	ff 4d fc             	decl   -0x4(%ebp)
c01005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d5:	8b 00                	mov    (%eax),%eax
c01005d7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005da:	7e 1f                	jle    c01005fb <stab_binsearch+0x143>
c01005dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005df:	89 d0                	mov    %edx,%eax
c01005e1:	01 c0                	add    %eax,%eax
c01005e3:	01 d0                	add    %edx,%eax
c01005e5:	c1 e0 02             	shl    $0x2,%eax
c01005e8:	89 c2                	mov    %eax,%edx
c01005ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ed:	01 d0                	add    %edx,%eax
c01005ef:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005f3:	0f b6 c0             	movzbl %al,%eax
c01005f6:	39 45 14             	cmp    %eax,0x14(%ebp)
c01005f9:	75 d4                	jne    c01005cf <stab_binsearch+0x117>
        *region_left = l;
c01005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100601:	89 10                	mov    %edx,(%eax)
}
c0100603:	90                   	nop
c0100604:	c9                   	leave  
c0100605:	c3                   	ret    

c0100606 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100606:	55                   	push   %ebp
c0100607:	89 e5                	mov    %esp,%ebp
c0100609:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010060c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060f:	c7 00 58 60 10 c0    	movl   $0xc0106058,(%eax)
    info->eip_line = 0;
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100622:	c7 40 08 58 60 10 c0 	movl   $0xc0106058,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100629:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100633:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100636:	8b 55 08             	mov    0x8(%ebp),%edx
c0100639:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010063c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100646:	c7 45 f4 88 72 10 c0 	movl   $0xc0107288,-0xc(%ebp)
    stab_end = __STAB_END__;
c010064d:	c7 45 f0 a8 24 11 c0 	movl   $0xc01124a8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100654:	c7 45 ec a9 24 11 c0 	movl   $0xc01124a9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010065b:	c7 45 e8 b7 4f 11 c0 	movl   $0xc0114fb7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100662:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100665:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100668:	76 0b                	jbe    c0100675 <debuginfo_eip+0x6f>
c010066a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010066d:	48                   	dec    %eax
c010066e:	0f b6 00             	movzbl (%eax),%eax
c0100671:	84 c0                	test   %al,%al
c0100673:	74 0a                	je     c010067f <debuginfo_eip+0x79>
        return -1;
c0100675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010067a:	e9 b7 02 00 00       	jmp    c0100936 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010067f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100686:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	29 c2                	sub    %eax,%edx
c010068e:	89 d0                	mov    %edx,%eax
c0100690:	c1 f8 02             	sar    $0x2,%eax
c0100693:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100699:	48                   	dec    %eax
c010069a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010069d:	8b 45 08             	mov    0x8(%ebp),%eax
c01006a0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006a4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006ab:	00 
c01006ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006af:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006bd:	89 04 24             	mov    %eax,(%esp)
c01006c0:	e8 f3 fd ff ff       	call   c01004b8 <stab_binsearch>
    if (lfile == 0)
c01006c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c8:	85 c0                	test   %eax,%eax
c01006ca:	75 0a                	jne    c01006d6 <debuginfo_eip+0xd0>
        return -1;
c01006cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006d1:	e9 60 02 00 00       	jmp    c0100936 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006f0:	00 
c01006f1:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f8:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100702:	89 04 24             	mov    %eax,(%esp)
c0100705:	e8 ae fd ff ff       	call   c01004b8 <stab_binsearch>

    if (lfun <= rfun) {
c010070a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010070d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100710:	39 c2                	cmp    %eax,%edx
c0100712:	7f 7c                	jg     c0100790 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100714:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100717:	89 c2                	mov    %eax,%edx
c0100719:	89 d0                	mov    %edx,%eax
c010071b:	01 c0                	add    %eax,%eax
c010071d:	01 d0                	add    %edx,%eax
c010071f:	c1 e0 02             	shl    $0x2,%eax
c0100722:	89 c2                	mov    %eax,%edx
c0100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100727:	01 d0                	add    %edx,%eax
c0100729:	8b 00                	mov    (%eax),%eax
c010072b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010072e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100731:	29 d1                	sub    %edx,%ecx
c0100733:	89 ca                	mov    %ecx,%edx
c0100735:	39 d0                	cmp    %edx,%eax
c0100737:	73 22                	jae    c010075b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100739:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	89 d0                	mov    %edx,%eax
c0100740:	01 c0                	add    %eax,%eax
c0100742:	01 d0                	add    %edx,%eax
c0100744:	c1 e0 02             	shl    $0x2,%eax
c0100747:	89 c2                	mov    %eax,%edx
c0100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074c:	01 d0                	add    %edx,%eax
c010074e:	8b 10                	mov    (%eax),%edx
c0100750:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100753:	01 c2                	add    %eax,%edx
c0100755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100758:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010075b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010075e:	89 c2                	mov    %eax,%edx
c0100760:	89 d0                	mov    %edx,%eax
c0100762:	01 c0                	add    %eax,%eax
c0100764:	01 d0                	add    %edx,%eax
c0100766:	c1 e0 02             	shl    $0x2,%eax
c0100769:	89 c2                	mov    %eax,%edx
c010076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010076e:	01 d0                	add    %edx,%eax
c0100770:	8b 50 08             	mov    0x8(%eax),%edx
c0100773:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100776:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100779:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077c:	8b 40 10             	mov    0x10(%eax),%eax
c010077f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100788:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010078b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010078e:	eb 15                	jmp    c01007a5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100790:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100793:	8b 55 08             	mov    0x8(%ebp),%edx
c0100796:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010079c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c010079f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a8:	8b 40 08             	mov    0x8(%eax),%eax
c01007ab:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007b2:	00 
c01007b3:	89 04 24             	mov    %eax,(%esp)
c01007b6:	e8 14 4e 00 00       	call   c01055cf <strfind>
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c0:	8b 40 08             	mov    0x8(%eax),%eax
c01007c3:	29 c2                	sub    %eax,%edx
c01007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01007ce:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007d2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007d9:	00 
c01007da:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007dd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007e1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007eb:	89 04 24             	mov    %eax,(%esp)
c01007ee:	e8 c5 fc ff ff       	call   c01004b8 <stab_binsearch>
    if (lline <= rline) {
c01007f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f9:	39 c2                	cmp    %eax,%edx
c01007fb:	7f 23                	jg     c0100820 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c01007fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100800:	89 c2                	mov    %eax,%edx
c0100802:	89 d0                	mov    %edx,%eax
c0100804:	01 c0                	add    %eax,%eax
c0100806:	01 d0                	add    %edx,%eax
c0100808:	c1 e0 02             	shl    $0x2,%eax
c010080b:	89 c2                	mov    %eax,%edx
c010080d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100810:	01 d0                	add    %edx,%eax
c0100812:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100816:	89 c2                	mov    %eax,%edx
c0100818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010081e:	eb 11                	jmp    c0100831 <debuginfo_eip+0x22b>
        return -1;
c0100820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100825:	e9 0c 01 00 00       	jmp    c0100936 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082d:	48                   	dec    %eax
c010082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100831:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100837:	39 c2                	cmp    %eax,%edx
c0100839:	7c 56                	jl     c0100891 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c010083b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083e:	89 c2                	mov    %eax,%edx
c0100840:	89 d0                	mov    %edx,%eax
c0100842:	01 c0                	add    %eax,%eax
c0100844:	01 d0                	add    %edx,%eax
c0100846:	c1 e0 02             	shl    $0x2,%eax
c0100849:	89 c2                	mov    %eax,%edx
c010084b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010084e:	01 d0                	add    %edx,%eax
c0100850:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100854:	3c 84                	cmp    $0x84,%al
c0100856:	74 39                	je     c0100891 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c 64                	cmp    $0x64,%al
c0100873:	75 b5                	jne    c010082a <debuginfo_eip+0x224>
c0100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	89 d0                	mov    %edx,%eax
c010087c:	01 c0                	add    %eax,%eax
c010087e:	01 d0                	add    %edx,%eax
c0100880:	c1 e0 02             	shl    $0x2,%eax
c0100883:	89 c2                	mov    %eax,%edx
c0100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100888:	01 d0                	add    %edx,%eax
c010088a:	8b 40 08             	mov    0x8(%eax),%eax
c010088d:	85 c0                	test   %eax,%eax
c010088f:	74 99                	je     c010082a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100891:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100897:	39 c2                	cmp    %eax,%edx
c0100899:	7c 46                	jl     c01008e1 <debuginfo_eip+0x2db>
c010089b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	89 d0                	mov    %edx,%eax
c01008a2:	01 c0                	add    %eax,%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	c1 e0 02             	shl    $0x2,%eax
c01008a9:	89 c2                	mov    %eax,%edx
c01008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ae:	01 d0                	add    %edx,%eax
c01008b0:	8b 00                	mov    (%eax),%eax
c01008b2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008b8:	29 d1                	sub    %edx,%ecx
c01008ba:	89 ca                	mov    %ecx,%edx
c01008bc:	39 d0                	cmp    %edx,%eax
c01008be:	73 21                	jae    c01008e1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c3:	89 c2                	mov    %eax,%edx
c01008c5:	89 d0                	mov    %edx,%eax
c01008c7:	01 c0                	add    %eax,%eax
c01008c9:	01 d0                	add    %edx,%eax
c01008cb:	c1 e0 02             	shl    $0x2,%eax
c01008ce:	89 c2                	mov    %eax,%edx
c01008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008d3:	01 d0                	add    %edx,%eax
c01008d5:	8b 10                	mov    (%eax),%edx
c01008d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008da:	01 c2                	add    %eax,%edx
c01008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008df:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008e7:	39 c2                	cmp    %eax,%edx
c01008e9:	7d 46                	jge    c0100931 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c01008eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008ee:	40                   	inc    %eax
c01008ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008f2:	eb 16                	jmp    c010090a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f7:	8b 40 14             	mov    0x14(%eax),%eax
c01008fa:	8d 50 01             	lea    0x1(%eax),%edx
c01008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100900:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100906:	40                   	inc    %eax
c0100907:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010090a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010090d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100910:	39 c2                	cmp    %eax,%edx
c0100912:	7d 1d                	jge    c0100931 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100917:	89 c2                	mov    %eax,%edx
c0100919:	89 d0                	mov    %edx,%eax
c010091b:	01 c0                	add    %eax,%eax
c010091d:	01 d0                	add    %edx,%eax
c010091f:	c1 e0 02             	shl    $0x2,%eax
c0100922:	89 c2                	mov    %eax,%edx
c0100924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100927:	01 d0                	add    %edx,%eax
c0100929:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010092d:	3c a0                	cmp    $0xa0,%al
c010092f:	74 c3                	je     c01008f4 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
c0100931:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100936:	c9                   	leave  
c0100937:	c3                   	ret    

c0100938 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100938:	55                   	push   %ebp
c0100939:	89 e5                	mov    %esp,%ebp
c010093b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010093e:	c7 04 24 62 60 10 c0 	movl   $0xc0106062,(%esp)
c0100945:	e8 48 f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010094a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100951:	c0 
c0100952:	c7 04 24 7b 60 10 c0 	movl   $0xc010607b,(%esp)
c0100959:	e8 34 f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010095e:	c7 44 24 04 4d 5f 10 	movl   $0xc0105f4d,0x4(%esp)
c0100965:	c0 
c0100966:	c7 04 24 93 60 10 c0 	movl   $0xc0106093,(%esp)
c010096d:	e8 20 f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100972:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c0100979:	c0 
c010097a:	c7 04 24 ab 60 10 c0 	movl   $0xc01060ab,(%esp)
c0100981:	e8 0c f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100986:	c7 44 24 04 48 af 11 	movl   $0xc011af48,0x4(%esp)
c010098d:	c0 
c010098e:	c7 04 24 c3 60 10 c0 	movl   $0xc01060c3,(%esp)
c0100995:	e8 f8 f8 ff ff       	call   c0100292 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010099a:	b8 48 af 11 c0       	mov    $0xc011af48,%eax
c010099f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009a5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009aa:	29 c2                	sub    %eax,%edx
c01009ac:	89 d0                	mov    %edx,%eax
c01009ae:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b4:	85 c0                	test   %eax,%eax
c01009b6:	0f 48 c2             	cmovs  %edx,%eax
c01009b9:	c1 f8 0a             	sar    $0xa,%eax
c01009bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009c0:	c7 04 24 dc 60 10 c0 	movl   $0xc01060dc,(%esp)
c01009c7:	e8 c6 f8 ff ff       	call   c0100292 <cprintf>
}
c01009cc:	90                   	nop
c01009cd:	c9                   	leave  
c01009ce:	c3                   	ret    

c01009cf <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009cf:	55                   	push   %ebp
c01009d0:	89 e5                	mov    %esp,%ebp
c01009d2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d8:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009df:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e2:	89 04 24             	mov    %eax,(%esp)
c01009e5:	e8 1c fc ff ff       	call   c0100606 <debuginfo_eip>
c01009ea:	85 c0                	test   %eax,%eax
c01009ec:	74 15                	je     c0100a03 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f5:	c7 04 24 06 61 10 c0 	movl   $0xc0106106,(%esp)
c01009fc:	e8 91 f8 ff ff       	call   c0100292 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a01:	eb 6c                	jmp    c0100a6f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a0a:	eb 1b                	jmp    c0100a27 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a12:	01 d0                	add    %edx,%eax
c0100a14:	0f b6 00             	movzbl (%eax),%eax
c0100a17:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a20:	01 ca                	add    %ecx,%edx
c0100a22:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a24:	ff 45 f4             	incl   -0xc(%ebp)
c0100a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a2d:	7c dd                	jl     c0100a0c <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a2f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a38:	01 d0                	add    %edx,%eax
c0100a3a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a40:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a43:	89 d1                	mov    %edx,%ecx
c0100a45:	29 c1                	sub    %eax,%ecx
c0100a47:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a4d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a51:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a5b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a63:	c7 04 24 22 61 10 c0 	movl   $0xc0106122,(%esp)
c0100a6a:	e8 23 f8 ff ff       	call   c0100292 <cprintf>
}
c0100a6f:	90                   	nop
c0100a70:	c9                   	leave  
c0100a71:	c3                   	ret    

c0100a72 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a72:	55                   	push   %ebp
c0100a73:	89 e5                	mov    %esp,%ebp
c0100a75:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a78:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a81:	c9                   	leave  
c0100a82:	c3                   	ret    

c0100a83 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a83:	55                   	push   %ebp
c0100a84:	89 e5                	mov    %esp,%ebp
c0100a86:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a89:	89 e8                	mov    %ebp,%eax
c0100a8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     uint32_t ebp=read_ebp(),eip=read_eip();
c0100a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100a94:	e8 d9 ff ff ff       	call   c0100a72 <read_eip>
c0100a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (int i=0;ebp && i<STACKFRAME_DEPTH;++i) {
c0100a9c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aa3:	e9 84 00 00 00       	jmp    c0100b2c <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
c0100aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aab:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab6:	c7 04 24 34 61 10 c0 	movl   $0xc0106134,(%esp)
c0100abd:	e8 d0 f7 ff ff       	call   c0100292 <cprintf>
        uint32_t* args=ebp+8;
c0100ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac5:	83 c0 08             	add    $0x8,%eax
c0100ac8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (int j=0;j<4;++j)
c0100acb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100ad2:	eb 24                	jmp    c0100af8 <print_stackframe+0x75>
            cprintf("0x%08x ",args[j]);
c0100ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ad7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ade:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ae1:	01 d0                	add    %edx,%eax
c0100ae3:	8b 00                	mov    (%eax),%eax
c0100ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ae9:	c7 04 24 50 61 10 c0 	movl   $0xc0106150,(%esp)
c0100af0:	e8 9d f7 ff ff       	call   c0100292 <cprintf>
        for (int j=0;j<4;++j)
c0100af5:	ff 45 e8             	incl   -0x18(%ebp)
c0100af8:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100afc:	7e d6                	jle    c0100ad4 <print_stackframe+0x51>
        cprintf("\n");
c0100afe:	c7 04 24 58 61 10 c0 	movl   $0xc0106158,(%esp)
c0100b05:	e8 88 f7 ff ff       	call   c0100292 <cprintf>
        print_debuginfo(eip-1);
c0100b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b0d:	48                   	dec    %eax
c0100b0e:	89 04 24             	mov    %eax,(%esp)
c0100b11:	e8 b9 fe ff ff       	call   c01009cf <print_debuginfo>
        eip=*(uint32_t*)(ebp+4);
c0100b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b19:	83 c0 04             	add    $0x4,%eax
c0100b1c:	8b 00                	mov    (%eax),%eax
c0100b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp=*(uint32_t*)(ebp);
c0100b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b24:	8b 00                	mov    (%eax),%eax
c0100b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (int i=0;ebp && i<STACKFRAME_DEPTH;++i) {
c0100b29:	ff 45 ec             	incl   -0x14(%ebp)
c0100b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b30:	74 0a                	je     c0100b3c <print_stackframe+0xb9>
c0100b32:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b36:	0f 8e 6c ff ff ff    	jle    c0100aa8 <print_stackframe+0x25>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100b3c:	90                   	nop
c0100b3d:	c9                   	leave  
c0100b3e:	c3                   	ret    

c0100b3f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b3f:	55                   	push   %ebp
c0100b40:	89 e5                	mov    %esp,%ebp
c0100b42:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b4c:	eb 0c                	jmp    c0100b5a <parse+0x1b>
            *buf ++ = '\0';
c0100b4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b51:	8d 50 01             	lea    0x1(%eax),%edx
c0100b54:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b57:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5d:	0f b6 00             	movzbl (%eax),%eax
c0100b60:	84 c0                	test   %al,%al
c0100b62:	74 1d                	je     c0100b81 <parse+0x42>
c0100b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b67:	0f b6 00             	movzbl (%eax),%eax
c0100b6a:	0f be c0             	movsbl %al,%eax
c0100b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b71:	c7 04 24 dc 61 10 c0 	movl   $0xc01061dc,(%esp)
c0100b78:	e8 20 4a 00 00       	call   c010559d <strchr>
c0100b7d:	85 c0                	test   %eax,%eax
c0100b7f:	75 cd                	jne    c0100b4e <parse+0xf>
        }
        if (*buf == '\0') {
c0100b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b84:	0f b6 00             	movzbl (%eax),%eax
c0100b87:	84 c0                	test   %al,%al
c0100b89:	74 65                	je     c0100bf0 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b8b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b8f:	75 14                	jne    c0100ba5 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b91:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100b98:	00 
c0100b99:	c7 04 24 e1 61 10 c0 	movl   $0xc01061e1,(%esp)
c0100ba0:	e8 ed f6 ff ff       	call   c0100292 <cprintf>
        }
        argv[argc ++] = buf;
c0100ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ba8:	8d 50 01             	lea    0x1(%eax),%edx
c0100bab:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bb8:	01 c2                	add    %eax,%edx
c0100bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bbd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bbf:	eb 03                	jmp    c0100bc4 <parse+0x85>
            buf ++;
c0100bc1:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc7:	0f b6 00             	movzbl (%eax),%eax
c0100bca:	84 c0                	test   %al,%al
c0100bcc:	74 8c                	je     c0100b5a <parse+0x1b>
c0100bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd1:	0f b6 00             	movzbl (%eax),%eax
c0100bd4:	0f be c0             	movsbl %al,%eax
c0100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdb:	c7 04 24 dc 61 10 c0 	movl   $0xc01061dc,(%esp)
c0100be2:	e8 b6 49 00 00       	call   c010559d <strchr>
c0100be7:	85 c0                	test   %eax,%eax
c0100be9:	74 d6                	je     c0100bc1 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100beb:	e9 6a ff ff ff       	jmp    c0100b5a <parse+0x1b>
            break;
c0100bf0:	90                   	nop
        }
    }
    return argc;
c0100bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bf4:	c9                   	leave  
c0100bf5:	c3                   	ret    

c0100bf6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bf6:	55                   	push   %ebp
c0100bf7:	89 e5                	mov    %esp,%ebp
c0100bf9:	53                   	push   %ebx
c0100bfa:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bfd:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c07:	89 04 24             	mov    %eax,(%esp)
c0100c0a:	e8 30 ff ff ff       	call   c0100b3f <parse>
c0100c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c16:	75 0a                	jne    c0100c22 <runcmd+0x2c>
        return 0;
c0100c18:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c1d:	e9 83 00 00 00       	jmp    c0100ca5 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c29:	eb 5a                	jmp    c0100c85 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c2b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c31:	89 d0                	mov    %edx,%eax
c0100c33:	01 c0                	add    %eax,%eax
c0100c35:	01 d0                	add    %edx,%eax
c0100c37:	c1 e0 02             	shl    $0x2,%eax
c0100c3a:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c3f:	8b 00                	mov    (%eax),%eax
c0100c41:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c45:	89 04 24             	mov    %eax,(%esp)
c0100c48:	e8 b3 48 00 00       	call   c0105500 <strcmp>
c0100c4d:	85 c0                	test   %eax,%eax
c0100c4f:	75 31                	jne    c0100c82 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c54:	89 d0                	mov    %edx,%eax
c0100c56:	01 c0                	add    %eax,%eax
c0100c58:	01 d0                	add    %edx,%eax
c0100c5a:	c1 e0 02             	shl    $0x2,%eax
c0100c5d:	05 08 70 11 c0       	add    $0xc0117008,%eax
c0100c62:	8b 10                	mov    (%eax),%edx
c0100c64:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c67:	83 c0 04             	add    $0x4,%eax
c0100c6a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c6d:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100c73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c7b:	89 1c 24             	mov    %ebx,(%esp)
c0100c7e:	ff d2                	call   *%edx
c0100c80:	eb 23                	jmp    c0100ca5 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c82:	ff 45 f4             	incl   -0xc(%ebp)
c0100c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c88:	83 f8 02             	cmp    $0x2,%eax
c0100c8b:	76 9e                	jbe    c0100c2b <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c94:	c7 04 24 ff 61 10 c0 	movl   $0xc01061ff,(%esp)
c0100c9b:	e8 f2 f5 ff ff       	call   c0100292 <cprintf>
    return 0;
c0100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca5:	83 c4 64             	add    $0x64,%esp
c0100ca8:	5b                   	pop    %ebx
c0100ca9:	5d                   	pop    %ebp
c0100caa:	c3                   	ret    

c0100cab <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cab:	55                   	push   %ebp
c0100cac:	89 e5                	mov    %esp,%ebp
c0100cae:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cb1:	c7 04 24 18 62 10 c0 	movl   $0xc0106218,(%esp)
c0100cb8:	e8 d5 f5 ff ff       	call   c0100292 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cbd:	c7 04 24 40 62 10 c0 	movl   $0xc0106240,(%esp)
c0100cc4:	e8 c9 f5 ff ff       	call   c0100292 <cprintf>

    if (tf != NULL) {
c0100cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ccd:	74 0b                	je     c0100cda <kmonitor+0x2f>
        print_trapframe(tf);
c0100ccf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cd2:	89 04 24             	mov    %eax,(%esp)
c0100cd5:	e8 35 0d 00 00       	call   c0101a0f <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cda:	c7 04 24 65 62 10 c0 	movl   $0xc0106265,(%esp)
c0100ce1:	e8 4e f6 ff ff       	call   c0100334 <readline>
c0100ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ced:	74 eb                	je     c0100cda <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cf9:	89 04 24             	mov    %eax,(%esp)
c0100cfc:	e8 f5 fe ff ff       	call   c0100bf6 <runcmd>
c0100d01:	85 c0                	test   %eax,%eax
c0100d03:	78 02                	js     c0100d07 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100d05:	eb d3                	jmp    c0100cda <kmonitor+0x2f>
                break;
c0100d07:	90                   	nop
            }
        }
    }
}
c0100d08:	90                   	nop
c0100d09:	c9                   	leave  
c0100d0a:	c3                   	ret    

c0100d0b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d0b:	55                   	push   %ebp
c0100d0c:	89 e5                	mov    %esp,%ebp
c0100d0e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d18:	eb 3d                	jmp    c0100d57 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d1d:	89 d0                	mov    %edx,%eax
c0100d1f:	01 c0                	add    %eax,%eax
c0100d21:	01 d0                	add    %edx,%eax
c0100d23:	c1 e0 02             	shl    $0x2,%eax
c0100d26:	05 04 70 11 c0       	add    $0xc0117004,%eax
c0100d2b:	8b 08                	mov    (%eax),%ecx
c0100d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d30:	89 d0                	mov    %edx,%eax
c0100d32:	01 c0                	add    %eax,%eax
c0100d34:	01 d0                	add    %edx,%eax
c0100d36:	c1 e0 02             	shl    $0x2,%eax
c0100d39:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100d3e:	8b 00                	mov    (%eax),%eax
c0100d40:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d48:	c7 04 24 69 62 10 c0 	movl   $0xc0106269,(%esp)
c0100d4f:	e8 3e f5 ff ff       	call   c0100292 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d54:	ff 45 f4             	incl   -0xc(%ebp)
c0100d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5a:	83 f8 02             	cmp    $0x2,%eax
c0100d5d:	76 bb                	jbe    c0100d1a <mon_help+0xf>
    }
    return 0;
c0100d5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d64:	c9                   	leave  
c0100d65:	c3                   	ret    

c0100d66 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d66:	55                   	push   %ebp
c0100d67:	89 e5                	mov    %esp,%ebp
c0100d69:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d6c:	e8 c7 fb ff ff       	call   c0100938 <print_kerninfo>
    return 0;
c0100d71:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
c0100d7b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d7e:	e8 00 fd ff ff       	call   c0100a83 <print_stackframe>
    return 0;
c0100d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d88:	c9                   	leave  
c0100d89:	c3                   	ret    

c0100d8a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d8a:	55                   	push   %ebp
c0100d8b:	89 e5                	mov    %esp,%ebp
c0100d8d:	83 ec 28             	sub    $0x28,%esp
c0100d90:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d96:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d9e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100da2:	ee                   	out    %al,(%dx)
c0100da3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dad:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db5:	ee                   	out    %al,(%dx)
c0100db6:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100dbc:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100dc0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dc4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dc8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc9:	c7 05 2c af 11 c0 00 	movl   $0x0,0xc011af2c
c0100dd0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd3:	c7 04 24 72 62 10 c0 	movl   $0xc0106272,(%esp)
c0100dda:	e8 b3 f4 ff ff       	call   c0100292 <cprintf>
    pic_enable(IRQ_TIMER);
c0100ddf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de6:	e8 2e 09 00 00       	call   c0101719 <pic_enable>
}
c0100deb:	90                   	nop
c0100dec:	c9                   	leave  
c0100ded:	c3                   	ret    

c0100dee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dee:	55                   	push   %ebp
c0100def:	89 e5                	mov    %esp,%ebp
c0100df1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df4:	9c                   	pushf  
c0100df5:	58                   	pop    %eax
c0100df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfc:	25 00 02 00 00       	and    $0x200,%eax
c0100e01:	85 c0                	test   %eax,%eax
c0100e03:	74 0c                	je     c0100e11 <__intr_save+0x23>
        intr_disable();
c0100e05:	e8 83 0a 00 00       	call   c010188d <intr_disable>
        return 1;
c0100e0a:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0f:	eb 05                	jmp    c0100e16 <__intr_save+0x28>
    }
    return 0;
c0100e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e16:	c9                   	leave  
c0100e17:	c3                   	ret    

c0100e18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e18:	55                   	push   %ebp
c0100e19:	89 e5                	mov    %esp,%ebp
c0100e1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e22:	74 05                	je     c0100e29 <__intr_restore+0x11>
        intr_enable();
c0100e24:	e8 5d 0a 00 00       	call   c0101886 <intr_enable>
    }
}
c0100e29:	90                   	nop
c0100e2a:	c9                   	leave  
c0100e2b:	c3                   	ret    

c0100e2c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2c:	55                   	push   %ebp
c0100e2d:	89 e5                	mov    %esp,%ebp
c0100e2f:	83 ec 10             	sub    $0x10,%esp
c0100e32:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e38:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e3c:	89 c2                	mov    %eax,%edx
c0100e3e:	ec                   	in     (%dx),%al
c0100e3f:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e42:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e48:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e4c:	89 c2                	mov    %eax,%edx
c0100e4e:	ec                   	in     (%dx),%al
c0100e4f:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e52:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e58:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e5c:	89 c2                	mov    %eax,%edx
c0100e5e:	ec                   	in     (%dx),%al
c0100e5f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e62:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e68:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e6c:	89 c2                	mov    %eax,%edx
c0100e6e:	ec                   	in     (%dx),%al
c0100e6f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e72:	90                   	nop
c0100e73:	c9                   	leave  
c0100e74:	c3                   	ret    

c0100e75 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e75:	55                   	push   %ebp
c0100e76:	89 e5                	mov    %esp,%ebp
c0100e78:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e85:	0f b7 00             	movzwl (%eax),%eax
c0100e88:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 00             	movzwl (%eax),%eax
c0100e9a:	0f b7 c0             	movzwl %ax,%eax
c0100e9d:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ea2:	74 12                	je     c0100eb6 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eab:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100eb2:	b4 03 
c0100eb4:	eb 13                	jmp    c0100ec9 <cga_init+0x54>
    } else {
        *cp = was;
c0100eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ebd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec0:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ec7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec9:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ed0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ed4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100edc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ee0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee1:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ee8:	40                   	inc    %eax
c0100ee9:	0f b7 c0             	movzwl %ax,%eax
c0100eec:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ef4:	89 c2                	mov    %eax,%edx
c0100ef6:	ec                   	in     (%dx),%al
c0100ef7:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100efa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100efe:	0f b6 c0             	movzbl %al,%eax
c0100f01:	c1 e0 08             	shl    $0x8,%eax
c0100f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f07:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f0e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f12:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f16:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f1a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f26:	40                   	inc    %eax
c0100f27:	0f b7 c0             	movzwl %ax,%eax
c0100f2a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f32:	89 c2                	mov    %eax,%edx
c0100f34:	ec                   	in     (%dx),%al
c0100f35:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f38:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f3c:	0f b6 c0             	movzbl %al,%eax
c0100f3f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f45:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4d:	0f b7 c0             	movzwl %ax,%eax
c0100f50:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f56:	90                   	nop
c0100f57:	c9                   	leave  
c0100f58:	c3                   	ret    

c0100f59 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f59:	55                   	push   %ebp
c0100f5a:	89 e5                	mov    %esp,%ebp
c0100f5c:	83 ec 48             	sub    $0x48,%esp
c0100f5f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f65:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f69:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f6d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f71:	ee                   	out    %al,(%dx)
c0100f72:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f78:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f7c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f80:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f84:	ee                   	out    %al,(%dx)
c0100f85:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f8b:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100f8f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f93:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f97:	ee                   	out    %al,(%dx)
c0100f98:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f9e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100fa2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fa6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100faa:	ee                   	out    %al,(%dx)
c0100fab:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fb1:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100fb5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fb9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fbd:	ee                   	out    %al,(%dx)
c0100fbe:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fc4:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fc8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fcc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fd0:	ee                   	out    %al,(%dx)
c0100fd1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fd7:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100fdb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fdf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
c0100fe4:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fea:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100fee:	89 c2                	mov    %eax,%edx
c0100ff0:	ec                   	in     (%dx),%al
c0100ff1:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ff4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff8:	3c ff                	cmp    $0xff,%al
c0100ffa:	0f 95 c0             	setne  %al
c0100ffd:	0f b6 c0             	movzbl %al,%eax
c0101000:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0101005:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010100f:	89 c2                	mov    %eax,%edx
c0101011:	ec                   	in     (%dx),%al
c0101012:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101015:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010101b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010101f:	89 c2                	mov    %eax,%edx
c0101021:	ec                   	in     (%dx),%al
c0101022:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101025:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010102a:	85 c0                	test   %eax,%eax
c010102c:	74 0c                	je     c010103a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101035:	e8 df 06 00 00       	call   c0101719 <pic_enable>
    }
}
c010103a:	90                   	nop
c010103b:	c9                   	leave  
c010103c:	c3                   	ret    

c010103d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103d:	55                   	push   %ebp
c010103e:	89 e5                	mov    %esp,%ebp
c0101040:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101043:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010104a:	eb 08                	jmp    c0101054 <lpt_putc_sub+0x17>
        delay();
c010104c:	e8 db fd ff ff       	call   c0100e2c <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101051:	ff 45 fc             	incl   -0x4(%ebp)
c0101054:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010105a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105e:	89 c2                	mov    %eax,%edx
c0101060:	ec                   	in     (%dx),%al
c0101061:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101064:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101068:	84 c0                	test   %al,%al
c010106a:	78 09                	js     c0101075 <lpt_putc_sub+0x38>
c010106c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101073:	7e d7                	jle    c010104c <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101075:	8b 45 08             	mov    0x8(%ebp),%eax
c0101078:	0f b6 c0             	movzbl %al,%eax
c010107b:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101081:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101084:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101088:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010108c:	ee                   	out    %al,(%dx)
c010108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109f:	ee                   	out    %al,(%dx)
c01010a0:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010a6:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c01010aa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010ae:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b3:	90                   	nop
c01010b4:	c9                   	leave  
c01010b5:	c3                   	ret    

c01010b6 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b6:	55                   	push   %ebp
c01010b7:	89 e5                	mov    %esp,%ebp
c01010b9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010bc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c0:	74 0d                	je     c01010cf <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c5:	89 04 24             	mov    %eax,(%esp)
c01010c8:	e8 70 ff ff ff       	call   c010103d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010cd:	eb 24                	jmp    c01010f3 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c01010cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d6:	e8 62 ff ff ff       	call   c010103d <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010db:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e2:	e8 56 ff ff ff       	call   c010103d <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ee:	e8 4a ff ff ff       	call   c010103d <lpt_putc_sub>
}
c01010f3:	90                   	nop
c01010f4:	c9                   	leave  
c01010f5:	c3                   	ret    

c01010f6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f6:	55                   	push   %ebp
c01010f7:	89 e5                	mov    %esp,%ebp
c01010f9:	53                   	push   %ebx
c01010fa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101100:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101105:	85 c0                	test   %eax,%eax
c0101107:	75 07                	jne    c0101110 <cga_putc+0x1a>
        c |= 0x0700;
c0101109:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101110:	8b 45 08             	mov    0x8(%ebp),%eax
c0101113:	0f b6 c0             	movzbl %al,%eax
c0101116:	83 f8 0a             	cmp    $0xa,%eax
c0101119:	74 55                	je     c0101170 <cga_putc+0x7a>
c010111b:	83 f8 0d             	cmp    $0xd,%eax
c010111e:	74 63                	je     c0101183 <cga_putc+0x8d>
c0101120:	83 f8 08             	cmp    $0x8,%eax
c0101123:	0f 85 94 00 00 00    	jne    c01011bd <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c0101129:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101130:	85 c0                	test   %eax,%eax
c0101132:	0f 84 af 00 00 00    	je     c01011e7 <cga_putc+0xf1>
            crt_pos --;
c0101138:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010113f:	48                   	dec    %eax
c0101140:	0f b7 c0             	movzwl %ax,%eax
c0101143:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101149:	8b 45 08             	mov    0x8(%ebp),%eax
c010114c:	98                   	cwtl   
c010114d:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101152:	98                   	cwtl   
c0101153:	83 c8 20             	or     $0x20,%eax
c0101156:	98                   	cwtl   
c0101157:	8b 15 40 a4 11 c0    	mov    0xc011a440,%edx
c010115d:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101164:	01 c9                	add    %ecx,%ecx
c0101166:	01 ca                	add    %ecx,%edx
c0101168:	0f b7 c0             	movzwl %ax,%eax
c010116b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116e:	eb 77                	jmp    c01011e7 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c0101170:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101177:	83 c0 50             	add    $0x50,%eax
c010117a:	0f b7 c0             	movzwl %ax,%eax
c010117d:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101183:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c010118a:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101191:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101196:	89 c8                	mov    %ecx,%eax
c0101198:	f7 e2                	mul    %edx
c010119a:	c1 ea 06             	shr    $0x6,%edx
c010119d:	89 d0                	mov    %edx,%eax
c010119f:	c1 e0 02             	shl    $0x2,%eax
c01011a2:	01 d0                	add    %edx,%eax
c01011a4:	c1 e0 04             	shl    $0x4,%eax
c01011a7:	29 c1                	sub    %eax,%ecx
c01011a9:	89 c8                	mov    %ecx,%eax
c01011ab:	0f b7 c0             	movzwl %ax,%eax
c01011ae:	29 c3                	sub    %eax,%ebx
c01011b0:	89 d8                	mov    %ebx,%eax
c01011b2:	0f b7 c0             	movzwl %ax,%eax
c01011b5:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011bb:	eb 2b                	jmp    c01011e8 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011bd:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011c3:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ca:	8d 50 01             	lea    0x1(%eax),%edx
c01011cd:	0f b7 d2             	movzwl %dx,%edx
c01011d0:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011d7:	01 c0                	add    %eax,%eax
c01011d9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011df:	0f b7 c0             	movzwl %ax,%eax
c01011e2:	66 89 02             	mov    %ax,(%edx)
        break;
c01011e5:	eb 01                	jmp    c01011e8 <cga_putc+0xf2>
        break;
c01011e7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e8:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ef:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c01011f4:	76 5d                	jbe    c0101253 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011f6:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011fb:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101201:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101206:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010120d:	00 
c010120e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101212:	89 04 24             	mov    %eax,(%esp)
c0101215:	e8 79 45 00 00       	call   c0105793 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101221:	eb 14                	jmp    c0101237 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c0101223:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101228:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010122b:	01 d2                	add    %edx,%edx
c010122d:	01 d0                	add    %edx,%eax
c010122f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101234:	ff 45 f4             	incl   -0xc(%ebp)
c0101237:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010123e:	7e e3                	jle    c0101223 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c0101240:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101247:	83 e8 50             	sub    $0x50,%eax
c010124a:	0f b7 c0             	movzwl %ax,%eax
c010124d:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101253:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010125a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010125e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c0101262:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101266:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010126a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010126b:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101272:	c1 e8 08             	shr    $0x8,%eax
c0101275:	0f b7 c0             	movzwl %ax,%eax
c0101278:	0f b6 c0             	movzbl %al,%eax
c010127b:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c0101282:	42                   	inc    %edx
c0101283:	0f b7 d2             	movzwl %dx,%edx
c0101286:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010128a:	88 45 e9             	mov    %al,-0x17(%ebp)
c010128d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101291:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101295:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101296:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010129d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012a1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c01012a5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012a9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012ad:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012ae:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012b5:	0f b6 c0             	movzbl %al,%eax
c01012b8:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012bf:	42                   	inc    %edx
c01012c0:	0f b7 d2             	movzwl %dx,%edx
c01012c3:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012c7:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012ca:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012ce:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012d2:	ee                   	out    %al,(%dx)
}
c01012d3:	90                   	nop
c01012d4:	83 c4 34             	add    $0x34,%esp
c01012d7:	5b                   	pop    %ebx
c01012d8:	5d                   	pop    %ebp
c01012d9:	c3                   	ret    

c01012da <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012da:	55                   	push   %ebp
c01012db:	89 e5                	mov    %esp,%ebp
c01012dd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e7:	eb 08                	jmp    c01012f1 <serial_putc_sub+0x17>
        delay();
c01012e9:	e8 3e fb ff ff       	call   c0100e2c <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ee:	ff 45 fc             	incl   -0x4(%ebp)
c01012f1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012fb:	89 c2                	mov    %eax,%edx
c01012fd:	ec                   	in     (%dx),%al
c01012fe:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101301:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101305:	0f b6 c0             	movzbl %al,%eax
c0101308:	83 e0 20             	and    $0x20,%eax
c010130b:	85 c0                	test   %eax,%eax
c010130d:	75 09                	jne    c0101318 <serial_putc_sub+0x3e>
c010130f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101316:	7e d1                	jle    c01012e9 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101318:	8b 45 08             	mov    0x8(%ebp),%eax
c010131b:	0f b6 c0             	movzbl %al,%eax
c010131e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101324:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101327:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010132b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132f:	ee                   	out    %al,(%dx)
}
c0101330:	90                   	nop
c0101331:	c9                   	leave  
c0101332:	c3                   	ret    

c0101333 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101333:	55                   	push   %ebp
c0101334:	89 e5                	mov    %esp,%ebp
c0101336:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101339:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010133d:	74 0d                	je     c010134c <serial_putc+0x19>
        serial_putc_sub(c);
c010133f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101342:	89 04 24             	mov    %eax,(%esp)
c0101345:	e8 90 ff ff ff       	call   c01012da <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c010134a:	eb 24                	jmp    c0101370 <serial_putc+0x3d>
        serial_putc_sub('\b');
c010134c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101353:	e8 82 ff ff ff       	call   c01012da <serial_putc_sub>
        serial_putc_sub(' ');
c0101358:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135f:	e8 76 ff ff ff       	call   c01012da <serial_putc_sub>
        serial_putc_sub('\b');
c0101364:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010136b:	e8 6a ff ff ff       	call   c01012da <serial_putc_sub>
}
c0101370:	90                   	nop
c0101371:	c9                   	leave  
c0101372:	c3                   	ret    

c0101373 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101373:	55                   	push   %ebp
c0101374:	89 e5                	mov    %esp,%ebp
c0101376:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101379:	eb 33                	jmp    c01013ae <cons_intr+0x3b>
        if (c != 0) {
c010137b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010137f:	74 2d                	je     c01013ae <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101381:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101386:	8d 50 01             	lea    0x1(%eax),%edx
c0101389:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c010138f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101392:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101398:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010139d:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013a2:	75 0a                	jne    c01013ae <cons_intr+0x3b>
                cons.wpos = 0;
c01013a4:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013ab:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b1:	ff d0                	call   *%eax
c01013b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ba:	75 bf                	jne    c010137b <cons_intr+0x8>
            }
        }
    }
}
c01013bc:	90                   	nop
c01013bd:	c9                   	leave  
c01013be:	c3                   	ret    

c01013bf <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013bf:	55                   	push   %ebp
c01013c0:	89 e5                	mov    %esp,%ebp
c01013c2:	83 ec 10             	sub    $0x10,%esp
c01013c5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013cb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013cf:	89 c2                	mov    %eax,%edx
c01013d1:	ec                   	in     (%dx),%al
c01013d2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d9:	0f b6 c0             	movzbl %al,%eax
c01013dc:	83 e0 01             	and    $0x1,%eax
c01013df:	85 c0                	test   %eax,%eax
c01013e1:	75 07                	jne    c01013ea <serial_proc_data+0x2b>
        return -1;
c01013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e8:	eb 2a                	jmp    c0101414 <serial_proc_data+0x55>
c01013ea:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013f4:	89 c2                	mov    %eax,%edx
c01013f6:	ec                   	in     (%dx),%al
c01013f7:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013fa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013fe:	0f b6 c0             	movzbl %al,%eax
c0101401:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101404:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101408:	75 07                	jne    c0101411 <serial_proc_data+0x52>
        c = '\b';
c010140a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010141c:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101421:	85 c0                	test   %eax,%eax
c0101423:	74 0c                	je     c0101431 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101425:	c7 04 24 bf 13 10 c0 	movl   $0xc01013bf,(%esp)
c010142c:	e8 42 ff ff ff       	call   c0101373 <cons_intr>
    }
}
c0101431:	90                   	nop
c0101432:	c9                   	leave  
c0101433:	c3                   	ret    

c0101434 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101434:	55                   	push   %ebp
c0101435:	89 e5                	mov    %esp,%ebp
c0101437:	83 ec 38             	sub    $0x38,%esp
c010143a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101440:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101443:	89 c2                	mov    %eax,%edx
c0101445:	ec                   	in     (%dx),%al
c0101446:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101449:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010144d:	0f b6 c0             	movzbl %al,%eax
c0101450:	83 e0 01             	and    $0x1,%eax
c0101453:	85 c0                	test   %eax,%eax
c0101455:	75 0a                	jne    c0101461 <kbd_proc_data+0x2d>
        return -1;
c0101457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010145c:	e9 55 01 00 00       	jmp    c01015b6 <kbd_proc_data+0x182>
c0101461:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101467:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010146a:	89 c2                	mov    %eax,%edx
c010146c:	ec                   	in     (%dx),%al
c010146d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101470:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101474:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101477:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010147b:	75 17                	jne    c0101494 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c010147d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101482:	83 c8 40             	or     $0x40,%eax
c0101485:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c010148a:	b8 00 00 00 00       	mov    $0x0,%eax
c010148f:	e9 22 01 00 00       	jmp    c01015b6 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c0101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101498:	84 c0                	test   %al,%al
c010149a:	79 45                	jns    c01014e1 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010149c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014a1:	83 e0 40             	and    $0x40,%eax
c01014a4:	85 c0                	test   %eax,%eax
c01014a6:	75 08                	jne    c01014b0 <kbd_proc_data+0x7c>
c01014a8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ac:	24 7f                	and    $0x7f,%al
c01014ae:	eb 04                	jmp    c01014b4 <kbd_proc_data+0x80>
c01014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bb:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014c2:	0c 40                	or     $0x40,%al
c01014c4:	0f b6 c0             	movzbl %al,%eax
c01014c7:	f7 d0                	not    %eax
c01014c9:	89 c2                	mov    %eax,%edx
c01014cb:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014d0:	21 d0                	and    %edx,%eax
c01014d2:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014d7:	b8 00 00 00 00       	mov    $0x0,%eax
c01014dc:	e9 d5 00 00 00       	jmp    c01015b6 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014e1:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014e6:	83 e0 40             	and    $0x40,%eax
c01014e9:	85 c0                	test   %eax,%eax
c01014eb:	74 11                	je     c01014fe <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ed:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014f1:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f6:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f9:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101511:	09 d0                	or     %edx,%eax
c0101513:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c0101518:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151c:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101523:	0f b6 d0             	movzbl %al,%edx
c0101526:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010152b:	31 d0                	xor    %edx,%eax
c010152d:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101532:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101537:	83 e0 03             	and    $0x3,%eax
c010153a:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101541:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101545:	01 d0                	add    %edx,%eax
c0101547:	0f b6 00             	movzbl (%eax),%eax
c010154a:	0f b6 c0             	movzbl %al,%eax
c010154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101550:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101555:	83 e0 08             	and    $0x8,%eax
c0101558:	85 c0                	test   %eax,%eax
c010155a:	74 22                	je     c010157e <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c010155c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101560:	7e 0c                	jle    c010156e <kbd_proc_data+0x13a>
c0101562:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101566:	7f 06                	jg     c010156e <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101568:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010156c:	eb 10                	jmp    c010157e <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c010156e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101572:	7e 0a                	jle    c010157e <kbd_proc_data+0x14a>
c0101574:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101578:	7f 04                	jg     c010157e <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c010157a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157e:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101583:	f7 d0                	not    %eax
c0101585:	83 e0 06             	and    $0x6,%eax
c0101588:	85 c0                	test   %eax,%eax
c010158a:	75 27                	jne    c01015b3 <kbd_proc_data+0x17f>
c010158c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101593:	75 1e                	jne    c01015b3 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c0101595:	c7 04 24 8d 62 10 c0 	movl   $0xc010628d,(%esp)
c010159c:	e8 f1 ec ff ff       	call   c0100292 <cprintf>
c01015a1:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a7:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015af:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01015b2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b6:	c9                   	leave  
c01015b7:	c3                   	ret    

c01015b8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b8:	55                   	push   %ebp
c01015b9:	89 e5                	mov    %esp,%ebp
c01015bb:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015be:	c7 04 24 34 14 10 c0 	movl   $0xc0101434,(%esp)
c01015c5:	e8 a9 fd ff ff       	call   c0101373 <cons_intr>
}
c01015ca:	90                   	nop
c01015cb:	c9                   	leave  
c01015cc:	c3                   	ret    

c01015cd <kbd_init>:

static void
kbd_init(void) {
c01015cd:	55                   	push   %ebp
c01015ce:	89 e5                	mov    %esp,%ebp
c01015d0:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d3:	e8 e0 ff ff ff       	call   c01015b8 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015df:	e8 35 01 00 00       	call   c0101719 <pic_enable>
}
c01015e4:	90                   	nop
c01015e5:	c9                   	leave  
c01015e6:	c3                   	ret    

c01015e7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e7:	55                   	push   %ebp
c01015e8:	89 e5                	mov    %esp,%ebp
c01015ea:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015ed:	e8 83 f8 ff ff       	call   c0100e75 <cga_init>
    serial_init();
c01015f2:	e8 62 f9 ff ff       	call   c0100f59 <serial_init>
    kbd_init();
c01015f7:	e8 d1 ff ff ff       	call   c01015cd <kbd_init>
    if (!serial_exists) {
c01015fc:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101601:	85 c0                	test   %eax,%eax
c0101603:	75 0c                	jne    c0101611 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101605:	c7 04 24 99 62 10 c0 	movl   $0xc0106299,(%esp)
c010160c:	e8 81 ec ff ff       	call   c0100292 <cprintf>
    }
}
c0101611:	90                   	nop
c0101612:	c9                   	leave  
c0101613:	c3                   	ret    

c0101614 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101614:	55                   	push   %ebp
c0101615:	89 e5                	mov    %esp,%ebp
c0101617:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010161a:	e8 cf f7 ff ff       	call   c0100dee <__intr_save>
c010161f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101622:	8b 45 08             	mov    0x8(%ebp),%eax
c0101625:	89 04 24             	mov    %eax,(%esp)
c0101628:	e8 89 fa ff ff       	call   c01010b6 <lpt_putc>
        cga_putc(c);
c010162d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101630:	89 04 24             	mov    %eax,(%esp)
c0101633:	e8 be fa ff ff       	call   c01010f6 <cga_putc>
        serial_putc(c);
c0101638:	8b 45 08             	mov    0x8(%ebp),%eax
c010163b:	89 04 24             	mov    %eax,(%esp)
c010163e:	e8 f0 fc ff ff       	call   c0101333 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101643:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101646:	89 04 24             	mov    %eax,(%esp)
c0101649:	e8 ca f7 ff ff       	call   c0100e18 <__intr_restore>
}
c010164e:	90                   	nop
c010164f:	c9                   	leave  
c0101650:	c3                   	ret    

c0101651 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101651:	55                   	push   %ebp
c0101652:	89 e5                	mov    %esp,%ebp
c0101654:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010165e:	e8 8b f7 ff ff       	call   c0100dee <__intr_save>
c0101663:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101666:	e8 ab fd ff ff       	call   c0101416 <serial_intr>
        kbd_intr();
c010166b:	e8 48 ff ff ff       	call   c01015b8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101670:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101676:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010167b:	39 c2                	cmp    %eax,%edx
c010167d:	74 31                	je     c01016b0 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010167f:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101684:	8d 50 01             	lea    0x1(%eax),%edx
c0101687:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c010168d:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c0101694:	0f b6 c0             	movzbl %al,%eax
c0101697:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010169a:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010169f:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016a4:	75 0a                	jne    c01016b0 <cons_getc+0x5f>
                cons.rpos = 0;
c01016a6:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016ad:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016b3:	89 04 24             	mov    %eax,(%esp)
c01016b6:	e8 5d f7 ff ff       	call   c0100e18 <__intr_restore>
    return c;
c01016bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016be:	c9                   	leave  
c01016bf:	c3                   	ret    

c01016c0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016c0:	55                   	push   %ebp
c01016c1:	89 e5                	mov    %esp,%ebp
c01016c3:	83 ec 14             	sub    $0x14,%esp
c01016c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016d0:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016d6:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016db:	85 c0                	test   %eax,%eax
c01016dd:	74 37                	je     c0101716 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016e2:	0f b6 c0             	movzbl %al,%eax
c01016e5:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016eb:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016f2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016f6:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016fb:	c1 e8 08             	shr    $0x8,%eax
c01016fe:	0f b7 c0             	movzwl %ax,%eax
c0101701:	0f b6 c0             	movzbl %al,%eax
c0101704:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c010170a:	88 45 fd             	mov    %al,-0x3(%ebp)
c010170d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101711:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101715:	ee                   	out    %al,(%dx)
    }
}
c0101716:	90                   	nop
c0101717:	c9                   	leave  
c0101718:	c3                   	ret    

c0101719 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101719:	55                   	push   %ebp
c010171a:	89 e5                	mov    %esp,%ebp
c010171c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010171f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101722:	ba 01 00 00 00       	mov    $0x1,%edx
c0101727:	88 c1                	mov    %al,%cl
c0101729:	d3 e2                	shl    %cl,%edx
c010172b:	89 d0                	mov    %edx,%eax
c010172d:	98                   	cwtl   
c010172e:	f7 d0                	not    %eax
c0101730:	0f bf d0             	movswl %ax,%edx
c0101733:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010173a:	98                   	cwtl   
c010173b:	21 d0                	and    %edx,%eax
c010173d:	98                   	cwtl   
c010173e:	0f b7 c0             	movzwl %ax,%eax
c0101741:	89 04 24             	mov    %eax,(%esp)
c0101744:	e8 77 ff ff ff       	call   c01016c0 <pic_setmask>
}
c0101749:	90                   	nop
c010174a:	c9                   	leave  
c010174b:	c3                   	ret    

c010174c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010174c:	55                   	push   %ebp
c010174d:	89 e5                	mov    %esp,%ebp
c010174f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101752:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c0101759:	00 00 00 
c010175c:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101762:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101766:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010176a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
c010176f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101775:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101779:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010177d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101781:	ee                   	out    %al,(%dx)
c0101782:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101788:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c010178c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101790:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101794:	ee                   	out    %al,(%dx)
c0101795:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c010179b:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c010179f:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017a3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017a7:	ee                   	out    %al,(%dx)
c01017a8:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017ae:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c01017b2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017b6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017ba:	ee                   	out    %al,(%dx)
c01017bb:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017c1:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017c5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017c9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017cd:	ee                   	out    %al,(%dx)
c01017ce:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017d4:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017d8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017dc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e0:	ee                   	out    %al,(%dx)
c01017e1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017e7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01017eb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017ef:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017f3:	ee                   	out    %al,(%dx)
c01017f4:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01017fa:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c01017fe:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101802:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101806:	ee                   	out    %al,(%dx)
c0101807:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010180d:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c0101811:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101815:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101819:	ee                   	out    %al,(%dx)
c010181a:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101820:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0101824:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101828:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010182c:	ee                   	out    %al,(%dx)
c010182d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101833:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101837:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010183b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010183f:	ee                   	out    %al,(%dx)
c0101840:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101846:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c010184a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010184e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101852:	ee                   	out    %al,(%dx)
c0101853:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101859:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c010185d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101861:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101865:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101866:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010186d:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101872:	74 0f                	je     c0101883 <pic_init+0x137>
        pic_setmask(irq_mask);
c0101874:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010187b:	89 04 24             	mov    %eax,(%esp)
c010187e:	e8 3d fe ff ff       	call   c01016c0 <pic_setmask>
    }
}
c0101883:	90                   	nop
c0101884:	c9                   	leave  
c0101885:	c3                   	ret    

c0101886 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101886:	55                   	push   %ebp
c0101887:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101889:	fb                   	sti    
    sti();
}
c010188a:	90                   	nop
c010188b:	5d                   	pop    %ebp
c010188c:	c3                   	ret    

c010188d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010188d:	55                   	push   %ebp
c010188e:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101890:	fa                   	cli    
    cli();
}
c0101891:	90                   	nop
c0101892:	5d                   	pop    %ebp
c0101893:	c3                   	ret    

c0101894 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101894:	55                   	push   %ebp
c0101895:	89 e5                	mov    %esp,%ebp
c0101897:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010189a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018a1:	00 
c01018a2:	c7 04 24 c0 62 10 c0 	movl   $0xc01062c0,(%esp)
c01018a9:	e8 e4 e9 ff ff       	call   c0100292 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018ae:	c7 04 24 ca 62 10 c0 	movl   $0xc01062ca,(%esp)
c01018b5:	e8 d8 e9 ff ff       	call   c0100292 <cprintf>
    panic("EOT: kernel seems ok.");
c01018ba:	c7 44 24 08 d8 62 10 	movl   $0xc01062d8,0x8(%esp)
c01018c1:	c0 
c01018c2:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018c9:	00 
c01018ca:	c7 04 24 ee 62 10 c0 	movl   $0xc01062ee,(%esp)
c01018d1:	e8 13 eb ff ff       	call   c01003e9 <__panic>

c01018d6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018d6:	55                   	push   %ebp
c01018d7:	89 e5                	mov    %esp,%ebp
c01018d9:	83 ec 10             	sub    $0x10,%esp
    extern uintptr_t __vectors[];
    for (int i=0;i<256;++i)
c01018dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018e3:	e9 c4 00 00 00       	jmp    c01019ac <idt_init+0xd6>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
c01018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018eb:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018f2:	0f b7 d0             	movzwl %ax,%edx
c01018f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f8:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018ff:	c0 
c0101900:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101903:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c010190a:	c0 08 00 
c010190d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101910:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101917:	c0 
c0101918:	80 e2 e0             	and    $0xe0,%dl
c010191b:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101925:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c010192c:	c0 
c010192d:	80 e2 1f             	and    $0x1f,%dl
c0101930:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101937:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193a:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101941:	c0 
c0101942:	80 e2 f0             	and    $0xf0,%dl
c0101945:	80 ca 0e             	or     $0xe,%dl
c0101948:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101952:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101959:	c0 
c010195a:	80 e2 ef             	and    $0xef,%dl
c010195d:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101967:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010196e:	c0 
c010196f:	80 e2 9f             	and    $0x9f,%dl
c0101972:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197c:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101983:	c0 
c0101984:	80 ca 80             	or     $0x80,%dl
c0101987:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101991:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101998:	c1 e8 10             	shr    $0x10,%eax
c010199b:	0f b7 d0             	movzwl %ax,%edx
c010199e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a1:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c01019a8:	c0 
    for (int i=0;i<256;++i)
c01019a9:	ff 45 fc             	incl   -0x4(%ebp)
c01019ac:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019b3:	0f 8e 2f ff ff ff    	jle    c01018e8 <idt_init+0x12>
c01019b9:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019c3:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c01019c6:	90                   	nop
c01019c7:	c9                   	leave  
c01019c8:	c3                   	ret    

c01019c9 <trapname>:

static const char *
trapname(int trapno) {
c01019c9:	55                   	push   %ebp
c01019ca:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019cf:	83 f8 13             	cmp    $0x13,%eax
c01019d2:	77 0c                	ja     c01019e0 <trapname+0x17>
        return excnames[trapno];
c01019d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d7:	8b 04 85 40 66 10 c0 	mov    -0x3fef99c0(,%eax,4),%eax
c01019de:	eb 18                	jmp    c01019f8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019e0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019e4:	7e 0d                	jle    c01019f3 <trapname+0x2a>
c01019e6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019ea:	7f 07                	jg     c01019f3 <trapname+0x2a>
        return "Hardware Interrupt";
c01019ec:	b8 ff 62 10 c0       	mov    $0xc01062ff,%eax
c01019f1:	eb 05                	jmp    c01019f8 <trapname+0x2f>
    }
    return "(unknown trap)";
c01019f3:	b8 12 63 10 c0       	mov    $0xc0106312,%eax
}
c01019f8:	5d                   	pop    %ebp
c01019f9:	c3                   	ret    

c01019fa <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019fa:	55                   	push   %ebp
c01019fb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a00:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a04:	83 f8 08             	cmp    $0x8,%eax
c0101a07:	0f 94 c0             	sete   %al
c0101a0a:	0f b6 c0             	movzbl %al,%eax
}
c0101a0d:	5d                   	pop    %ebp
c0101a0e:	c3                   	ret    

c0101a0f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a0f:	55                   	push   %ebp
c0101a10:	89 e5                	mov    %esp,%ebp
c0101a12:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a1c:	c7 04 24 53 63 10 c0 	movl   $0xc0106353,(%esp)
c0101a23:	e8 6a e8 ff ff       	call   c0100292 <cprintf>
    print_regs(&tf->tf_regs);
c0101a28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2b:	89 04 24             	mov    %eax,(%esp)
c0101a2e:	e8 8f 01 00 00       	call   c0101bc2 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a36:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a3e:	c7 04 24 64 63 10 c0 	movl   $0xc0106364,(%esp)
c0101a45:	e8 48 e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a55:	c7 04 24 77 63 10 c0 	movl   $0xc0106377,(%esp)
c0101a5c:	e8 31 e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a64:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a6c:	c7 04 24 8a 63 10 c0 	movl   $0xc010638a,(%esp)
c0101a73:	e8 1a e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a83:	c7 04 24 9d 63 10 c0 	movl   $0xc010639d,(%esp)
c0101a8a:	e8 03 e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a92:	8b 40 30             	mov    0x30(%eax),%eax
c0101a95:	89 04 24             	mov    %eax,(%esp)
c0101a98:	e8 2c ff ff ff       	call   c01019c9 <trapname>
c0101a9d:	89 c2                	mov    %eax,%edx
c0101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa2:	8b 40 30             	mov    0x30(%eax),%eax
c0101aa5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aad:	c7 04 24 b0 63 10 c0 	movl   $0xc01063b0,(%esp)
c0101ab4:	e8 d9 e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abc:	8b 40 34             	mov    0x34(%eax),%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 c2 63 10 c0 	movl   $0xc01063c2,(%esp)
c0101aca:	e8 c3 e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	8b 40 38             	mov    0x38(%eax),%eax
c0101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad9:	c7 04 24 d1 63 10 c0 	movl   $0xc01063d1,(%esp)
c0101ae0:	e8 ad e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af0:	c7 04 24 e0 63 10 c0 	movl   $0xc01063e0,(%esp)
c0101af7:	e8 96 e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aff:	8b 40 40             	mov    0x40(%eax),%eax
c0101b02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b06:	c7 04 24 f3 63 10 c0 	movl   $0xc01063f3,(%esp)
c0101b0d:	e8 80 e7 ff ff       	call   c0100292 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b19:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b20:	eb 3d                	jmp    c0101b5f <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b25:	8b 50 40             	mov    0x40(%eax),%edx
c0101b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b2b:	21 d0                	and    %edx,%eax
c0101b2d:	85 c0                	test   %eax,%eax
c0101b2f:	74 28                	je     c0101b59 <print_trapframe+0x14a>
c0101b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b34:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b3b:	85 c0                	test   %eax,%eax
c0101b3d:	74 1a                	je     c0101b59 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b42:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4d:	c7 04 24 02 64 10 c0 	movl   $0xc0106402,(%esp)
c0101b54:	e8 39 e7 ff ff       	call   c0100292 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b59:	ff 45 f4             	incl   -0xc(%ebp)
c0101b5c:	d1 65 f0             	shll   -0x10(%ebp)
c0101b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b62:	83 f8 17             	cmp    $0x17,%eax
c0101b65:	76 bb                	jbe    c0101b22 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6a:	8b 40 40             	mov    0x40(%eax),%eax
c0101b6d:	c1 e8 0c             	shr    $0xc,%eax
c0101b70:	83 e0 03             	and    $0x3,%eax
c0101b73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b77:	c7 04 24 06 64 10 c0 	movl   $0xc0106406,(%esp)
c0101b7e:	e8 0f e7 ff ff       	call   c0100292 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b86:	89 04 24             	mov    %eax,(%esp)
c0101b89:	e8 6c fe ff ff       	call   c01019fa <trap_in_kernel>
c0101b8e:	85 c0                	test   %eax,%eax
c0101b90:	75 2d                	jne    c0101bbf <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b95:	8b 40 44             	mov    0x44(%eax),%eax
c0101b98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b9c:	c7 04 24 0f 64 10 c0 	movl   $0xc010640f,(%esp)
c0101ba3:	e8 ea e6 ff ff       	call   c0100292 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bab:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101baf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb3:	c7 04 24 1e 64 10 c0 	movl   $0xc010641e,(%esp)
c0101bba:	e8 d3 e6 ff ff       	call   c0100292 <cprintf>
    }
}
c0101bbf:	90                   	nop
c0101bc0:	c9                   	leave  
c0101bc1:	c3                   	ret    

c0101bc2 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bc2:	55                   	push   %ebp
c0101bc3:	89 e5                	mov    %esp,%ebp
c0101bc5:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bcb:	8b 00                	mov    (%eax),%eax
c0101bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd1:	c7 04 24 31 64 10 c0 	movl   $0xc0106431,(%esp)
c0101bd8:	e8 b5 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be0:	8b 40 04             	mov    0x4(%eax),%eax
c0101be3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be7:	c7 04 24 40 64 10 c0 	movl   $0xc0106440,(%esp)
c0101bee:	e8 9f e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf6:	8b 40 08             	mov    0x8(%eax),%eax
c0101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfd:	c7 04 24 4f 64 10 c0 	movl   $0xc010644f,(%esp)
c0101c04:	e8 89 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0c:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c13:	c7 04 24 5e 64 10 c0 	movl   $0xc010645e,(%esp)
c0101c1a:	e8 73 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c22:	8b 40 10             	mov    0x10(%eax),%eax
c0101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c29:	c7 04 24 6d 64 10 c0 	movl   $0xc010646d,(%esp)
c0101c30:	e8 5d e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c38:	8b 40 14             	mov    0x14(%eax),%eax
c0101c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3f:	c7 04 24 7c 64 10 c0 	movl   $0xc010647c,(%esp)
c0101c46:	e8 47 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4e:	8b 40 18             	mov    0x18(%eax),%eax
c0101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c55:	c7 04 24 8b 64 10 c0 	movl   $0xc010648b,(%esp)
c0101c5c:	e8 31 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c64:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6b:	c7 04 24 9a 64 10 c0 	movl   $0xc010649a,(%esp)
c0101c72:	e8 1b e6 ff ff       	call   c0100292 <cprintf>
}
c0101c77:	90                   	nop
c0101c78:	c9                   	leave  
c0101c79:	c3                   	ret    

c0101c7a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c7a:	55                   	push   %ebp
c0101c7b:	89 e5                	mov    %esp,%ebp
c0101c7d:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int clock_cnt=0;
    switch (tf->tf_trapno) {
c0101c80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c83:	8b 40 30             	mov    0x30(%eax),%eax
c0101c86:	83 f8 2f             	cmp    $0x2f,%eax
c0101c89:	77 1d                	ja     c0101ca8 <trap_dispatch+0x2e>
c0101c8b:	83 f8 2e             	cmp    $0x2e,%eax
c0101c8e:	0f 83 ec 00 00 00    	jae    c0101d80 <trap_dispatch+0x106>
c0101c94:	83 f8 21             	cmp    $0x21,%eax
c0101c97:	74 70                	je     c0101d09 <trap_dispatch+0x8f>
c0101c99:	83 f8 24             	cmp    $0x24,%eax
c0101c9c:	74 45                	je     c0101ce3 <trap_dispatch+0x69>
c0101c9e:	83 f8 20             	cmp    $0x20,%eax
c0101ca1:	74 13                	je     c0101cb6 <trap_dispatch+0x3c>
c0101ca3:	e9 a3 00 00 00       	jmp    c0101d4b <trap_dispatch+0xd1>
c0101ca8:	83 e8 78             	sub    $0x78,%eax
c0101cab:	83 f8 01             	cmp    $0x1,%eax
c0101cae:	0f 87 97 00 00 00    	ja     c0101d4b <trap_dispatch+0xd1>
c0101cb4:	eb 79                	jmp    c0101d2f <trap_dispatch+0xb5>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ++clock_cnt;
c0101cb6:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0101cbb:	40                   	inc    %eax
c0101cbc:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
        if (clock_cnt==TICK_NUM)
c0101cc1:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0101cc6:	83 f8 64             	cmp    $0x64,%eax
c0101cc9:	0f 85 b4 00 00 00    	jne    c0101d83 <trap_dispatch+0x109>
            print_ticks(),clock_cnt=0;
c0101ccf:	e8 c0 fb ff ff       	call   c0101894 <print_ticks>
c0101cd4:	c7 05 80 ae 11 c0 00 	movl   $0x0,0xc011ae80
c0101cdb:	00 00 00 
        break;
c0101cde:	e9 a0 00 00 00       	jmp    c0101d83 <trap_dispatch+0x109>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ce3:	e8 69 f9 ff ff       	call   c0101651 <cons_getc>
c0101ce8:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ceb:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cef:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cf3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfb:	c7 04 24 a9 64 10 c0 	movl   $0xc01064a9,(%esp)
c0101d02:	e8 8b e5 ff ff       	call   c0100292 <cprintf>
        break;
c0101d07:	eb 7b                	jmp    c0101d84 <trap_dispatch+0x10a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d09:	e8 43 f9 ff ff       	call   c0101651 <cons_getc>
c0101d0e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d11:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d15:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d19:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d21:	c7 04 24 bb 64 10 c0 	movl   $0xc01064bb,(%esp)
c0101d28:	e8 65 e5 ff ff       	call   c0100292 <cprintf>
        break;
c0101d2d:	eb 55                	jmp    c0101d84 <trap_dispatch+0x10a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d2f:	c7 44 24 08 ca 64 10 	movl   $0xc01064ca,0x8(%esp)
c0101d36:	c0 
c0101d37:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0101d3e:	00 
c0101d3f:	c7 04 24 ee 62 10 c0 	movl   $0xc01062ee,(%esp)
c0101d46:	e8 9e e6 ff ff       	call   c01003e9 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d52:	83 e0 03             	and    $0x3,%eax
c0101d55:	85 c0                	test   %eax,%eax
c0101d57:	75 2b                	jne    c0101d84 <trap_dispatch+0x10a>
            print_trapframe(tf);
c0101d59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5c:	89 04 24             	mov    %eax,(%esp)
c0101d5f:	e8 ab fc ff ff       	call   c0101a0f <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d64:	c7 44 24 08 da 64 10 	movl   $0xc01064da,0x8(%esp)
c0101d6b:	c0 
c0101d6c:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0101d73:	00 
c0101d74:	c7 04 24 ee 62 10 c0 	movl   $0xc01062ee,(%esp)
c0101d7b:	e8 69 e6 ff ff       	call   c01003e9 <__panic>
        break;
c0101d80:	90                   	nop
c0101d81:	eb 01                	jmp    c0101d84 <trap_dispatch+0x10a>
        break;
c0101d83:	90                   	nop
        }
    }
}
c0101d84:	90                   	nop
c0101d85:	c9                   	leave  
c0101d86:	c3                   	ret    

c0101d87 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d87:	55                   	push   %ebp
c0101d88:	89 e5                	mov    %esp,%ebp
c0101d8a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d90:	89 04 24             	mov    %eax,(%esp)
c0101d93:	e8 e2 fe ff ff       	call   c0101c7a <trap_dispatch>
}
c0101d98:	90                   	nop
c0101d99:	c9                   	leave  
c0101d9a:	c3                   	ret    

c0101d9b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101d9b:	6a 00                	push   $0x0
  pushl $0
c0101d9d:	6a 00                	push   $0x0
  jmp __alltraps
c0101d9f:	e9 69 0a 00 00       	jmp    c010280d <__alltraps>

c0101da4 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101da4:	6a 00                	push   $0x0
  pushl $1
c0101da6:	6a 01                	push   $0x1
  jmp __alltraps
c0101da8:	e9 60 0a 00 00       	jmp    c010280d <__alltraps>

c0101dad <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dad:	6a 00                	push   $0x0
  pushl $2
c0101daf:	6a 02                	push   $0x2
  jmp __alltraps
c0101db1:	e9 57 0a 00 00       	jmp    c010280d <__alltraps>

c0101db6 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101db6:	6a 00                	push   $0x0
  pushl $3
c0101db8:	6a 03                	push   $0x3
  jmp __alltraps
c0101dba:	e9 4e 0a 00 00       	jmp    c010280d <__alltraps>

c0101dbf <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dbf:	6a 00                	push   $0x0
  pushl $4
c0101dc1:	6a 04                	push   $0x4
  jmp __alltraps
c0101dc3:	e9 45 0a 00 00       	jmp    c010280d <__alltraps>

c0101dc8 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101dc8:	6a 00                	push   $0x0
  pushl $5
c0101dca:	6a 05                	push   $0x5
  jmp __alltraps
c0101dcc:	e9 3c 0a 00 00       	jmp    c010280d <__alltraps>

c0101dd1 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101dd1:	6a 00                	push   $0x0
  pushl $6
c0101dd3:	6a 06                	push   $0x6
  jmp __alltraps
c0101dd5:	e9 33 0a 00 00       	jmp    c010280d <__alltraps>

c0101dda <vector7>:
.globl vector7
vector7:
  pushl $0
c0101dda:	6a 00                	push   $0x0
  pushl $7
c0101ddc:	6a 07                	push   $0x7
  jmp __alltraps
c0101dde:	e9 2a 0a 00 00       	jmp    c010280d <__alltraps>

c0101de3 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101de3:	6a 08                	push   $0x8
  jmp __alltraps
c0101de5:	e9 23 0a 00 00       	jmp    c010280d <__alltraps>

c0101dea <vector9>:
.globl vector9
vector9:
  pushl $0
c0101dea:	6a 00                	push   $0x0
  pushl $9
c0101dec:	6a 09                	push   $0x9
  jmp __alltraps
c0101dee:	e9 1a 0a 00 00       	jmp    c010280d <__alltraps>

c0101df3 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101df3:	6a 0a                	push   $0xa
  jmp __alltraps
c0101df5:	e9 13 0a 00 00       	jmp    c010280d <__alltraps>

c0101dfa <vector11>:
.globl vector11
vector11:
  pushl $11
c0101dfa:	6a 0b                	push   $0xb
  jmp __alltraps
c0101dfc:	e9 0c 0a 00 00       	jmp    c010280d <__alltraps>

c0101e01 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e01:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e03:	e9 05 0a 00 00       	jmp    c010280d <__alltraps>

c0101e08 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e08:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e0a:	e9 fe 09 00 00       	jmp    c010280d <__alltraps>

c0101e0f <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e0f:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e11:	e9 f7 09 00 00       	jmp    c010280d <__alltraps>

c0101e16 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e16:	6a 00                	push   $0x0
  pushl $15
c0101e18:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e1a:	e9 ee 09 00 00       	jmp    c010280d <__alltraps>

c0101e1f <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e1f:	6a 00                	push   $0x0
  pushl $16
c0101e21:	6a 10                	push   $0x10
  jmp __alltraps
c0101e23:	e9 e5 09 00 00       	jmp    c010280d <__alltraps>

c0101e28 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e28:	6a 11                	push   $0x11
  jmp __alltraps
c0101e2a:	e9 de 09 00 00       	jmp    c010280d <__alltraps>

c0101e2f <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e2f:	6a 00                	push   $0x0
  pushl $18
c0101e31:	6a 12                	push   $0x12
  jmp __alltraps
c0101e33:	e9 d5 09 00 00       	jmp    c010280d <__alltraps>

c0101e38 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e38:	6a 00                	push   $0x0
  pushl $19
c0101e3a:	6a 13                	push   $0x13
  jmp __alltraps
c0101e3c:	e9 cc 09 00 00       	jmp    c010280d <__alltraps>

c0101e41 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e41:	6a 00                	push   $0x0
  pushl $20
c0101e43:	6a 14                	push   $0x14
  jmp __alltraps
c0101e45:	e9 c3 09 00 00       	jmp    c010280d <__alltraps>

c0101e4a <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e4a:	6a 00                	push   $0x0
  pushl $21
c0101e4c:	6a 15                	push   $0x15
  jmp __alltraps
c0101e4e:	e9 ba 09 00 00       	jmp    c010280d <__alltraps>

c0101e53 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e53:	6a 00                	push   $0x0
  pushl $22
c0101e55:	6a 16                	push   $0x16
  jmp __alltraps
c0101e57:	e9 b1 09 00 00       	jmp    c010280d <__alltraps>

c0101e5c <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e5c:	6a 00                	push   $0x0
  pushl $23
c0101e5e:	6a 17                	push   $0x17
  jmp __alltraps
c0101e60:	e9 a8 09 00 00       	jmp    c010280d <__alltraps>

c0101e65 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e65:	6a 00                	push   $0x0
  pushl $24
c0101e67:	6a 18                	push   $0x18
  jmp __alltraps
c0101e69:	e9 9f 09 00 00       	jmp    c010280d <__alltraps>

c0101e6e <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e6e:	6a 00                	push   $0x0
  pushl $25
c0101e70:	6a 19                	push   $0x19
  jmp __alltraps
c0101e72:	e9 96 09 00 00       	jmp    c010280d <__alltraps>

c0101e77 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e77:	6a 00                	push   $0x0
  pushl $26
c0101e79:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e7b:	e9 8d 09 00 00       	jmp    c010280d <__alltraps>

c0101e80 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e80:	6a 00                	push   $0x0
  pushl $27
c0101e82:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e84:	e9 84 09 00 00       	jmp    c010280d <__alltraps>

c0101e89 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101e89:	6a 00                	push   $0x0
  pushl $28
c0101e8b:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101e8d:	e9 7b 09 00 00       	jmp    c010280d <__alltraps>

c0101e92 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101e92:	6a 00                	push   $0x0
  pushl $29
c0101e94:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101e96:	e9 72 09 00 00       	jmp    c010280d <__alltraps>

c0101e9b <vector30>:
.globl vector30
vector30:
  pushl $0
c0101e9b:	6a 00                	push   $0x0
  pushl $30
c0101e9d:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101e9f:	e9 69 09 00 00       	jmp    c010280d <__alltraps>

c0101ea4 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ea4:	6a 00                	push   $0x0
  pushl $31
c0101ea6:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ea8:	e9 60 09 00 00       	jmp    c010280d <__alltraps>

c0101ead <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ead:	6a 00                	push   $0x0
  pushl $32
c0101eaf:	6a 20                	push   $0x20
  jmp __alltraps
c0101eb1:	e9 57 09 00 00       	jmp    c010280d <__alltraps>

c0101eb6 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  pushl $33
c0101eb8:	6a 21                	push   $0x21
  jmp __alltraps
c0101eba:	e9 4e 09 00 00       	jmp    c010280d <__alltraps>

c0101ebf <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ebf:	6a 00                	push   $0x0
  pushl $34
c0101ec1:	6a 22                	push   $0x22
  jmp __alltraps
c0101ec3:	e9 45 09 00 00       	jmp    c010280d <__alltraps>

c0101ec8 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ec8:	6a 00                	push   $0x0
  pushl $35
c0101eca:	6a 23                	push   $0x23
  jmp __alltraps
c0101ecc:	e9 3c 09 00 00       	jmp    c010280d <__alltraps>

c0101ed1 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ed1:	6a 00                	push   $0x0
  pushl $36
c0101ed3:	6a 24                	push   $0x24
  jmp __alltraps
c0101ed5:	e9 33 09 00 00       	jmp    c010280d <__alltraps>

c0101eda <vector37>:
.globl vector37
vector37:
  pushl $0
c0101eda:	6a 00                	push   $0x0
  pushl $37
c0101edc:	6a 25                	push   $0x25
  jmp __alltraps
c0101ede:	e9 2a 09 00 00       	jmp    c010280d <__alltraps>

c0101ee3 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ee3:	6a 00                	push   $0x0
  pushl $38
c0101ee5:	6a 26                	push   $0x26
  jmp __alltraps
c0101ee7:	e9 21 09 00 00       	jmp    c010280d <__alltraps>

c0101eec <vector39>:
.globl vector39
vector39:
  pushl $0
c0101eec:	6a 00                	push   $0x0
  pushl $39
c0101eee:	6a 27                	push   $0x27
  jmp __alltraps
c0101ef0:	e9 18 09 00 00       	jmp    c010280d <__alltraps>

c0101ef5 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101ef5:	6a 00                	push   $0x0
  pushl $40
c0101ef7:	6a 28                	push   $0x28
  jmp __alltraps
c0101ef9:	e9 0f 09 00 00       	jmp    c010280d <__alltraps>

c0101efe <vector41>:
.globl vector41
vector41:
  pushl $0
c0101efe:	6a 00                	push   $0x0
  pushl $41
c0101f00:	6a 29                	push   $0x29
  jmp __alltraps
c0101f02:	e9 06 09 00 00       	jmp    c010280d <__alltraps>

c0101f07 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f07:	6a 00                	push   $0x0
  pushl $42
c0101f09:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f0b:	e9 fd 08 00 00       	jmp    c010280d <__alltraps>

c0101f10 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f10:	6a 00                	push   $0x0
  pushl $43
c0101f12:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f14:	e9 f4 08 00 00       	jmp    c010280d <__alltraps>

c0101f19 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f19:	6a 00                	push   $0x0
  pushl $44
c0101f1b:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f1d:	e9 eb 08 00 00       	jmp    c010280d <__alltraps>

c0101f22 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f22:	6a 00                	push   $0x0
  pushl $45
c0101f24:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f26:	e9 e2 08 00 00       	jmp    c010280d <__alltraps>

c0101f2b <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f2b:	6a 00                	push   $0x0
  pushl $46
c0101f2d:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f2f:	e9 d9 08 00 00       	jmp    c010280d <__alltraps>

c0101f34 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f34:	6a 00                	push   $0x0
  pushl $47
c0101f36:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f38:	e9 d0 08 00 00       	jmp    c010280d <__alltraps>

c0101f3d <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f3d:	6a 00                	push   $0x0
  pushl $48
c0101f3f:	6a 30                	push   $0x30
  jmp __alltraps
c0101f41:	e9 c7 08 00 00       	jmp    c010280d <__alltraps>

c0101f46 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $49
c0101f48:	6a 31                	push   $0x31
  jmp __alltraps
c0101f4a:	e9 be 08 00 00       	jmp    c010280d <__alltraps>

c0101f4f <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $50
c0101f51:	6a 32                	push   $0x32
  jmp __alltraps
c0101f53:	e9 b5 08 00 00       	jmp    c010280d <__alltraps>

c0101f58 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $51
c0101f5a:	6a 33                	push   $0x33
  jmp __alltraps
c0101f5c:	e9 ac 08 00 00       	jmp    c010280d <__alltraps>

c0101f61 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $52
c0101f63:	6a 34                	push   $0x34
  jmp __alltraps
c0101f65:	e9 a3 08 00 00       	jmp    c010280d <__alltraps>

c0101f6a <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $53
c0101f6c:	6a 35                	push   $0x35
  jmp __alltraps
c0101f6e:	e9 9a 08 00 00       	jmp    c010280d <__alltraps>

c0101f73 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $54
c0101f75:	6a 36                	push   $0x36
  jmp __alltraps
c0101f77:	e9 91 08 00 00       	jmp    c010280d <__alltraps>

c0101f7c <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $55
c0101f7e:	6a 37                	push   $0x37
  jmp __alltraps
c0101f80:	e9 88 08 00 00       	jmp    c010280d <__alltraps>

c0101f85 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $56
c0101f87:	6a 38                	push   $0x38
  jmp __alltraps
c0101f89:	e9 7f 08 00 00       	jmp    c010280d <__alltraps>

c0101f8e <vector57>:
.globl vector57
vector57:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $57
c0101f90:	6a 39                	push   $0x39
  jmp __alltraps
c0101f92:	e9 76 08 00 00       	jmp    c010280d <__alltraps>

c0101f97 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $58
c0101f99:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101f9b:	e9 6d 08 00 00       	jmp    c010280d <__alltraps>

c0101fa0 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $59
c0101fa2:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fa4:	e9 64 08 00 00       	jmp    c010280d <__alltraps>

c0101fa9 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $60
c0101fab:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fad:	e9 5b 08 00 00       	jmp    c010280d <__alltraps>

c0101fb2 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $61
c0101fb4:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fb6:	e9 52 08 00 00       	jmp    c010280d <__alltraps>

c0101fbb <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $62
c0101fbd:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fbf:	e9 49 08 00 00       	jmp    c010280d <__alltraps>

c0101fc4 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $63
c0101fc6:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fc8:	e9 40 08 00 00       	jmp    c010280d <__alltraps>

c0101fcd <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $64
c0101fcf:	6a 40                	push   $0x40
  jmp __alltraps
c0101fd1:	e9 37 08 00 00       	jmp    c010280d <__alltraps>

c0101fd6 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $65
c0101fd8:	6a 41                	push   $0x41
  jmp __alltraps
c0101fda:	e9 2e 08 00 00       	jmp    c010280d <__alltraps>

c0101fdf <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $66
c0101fe1:	6a 42                	push   $0x42
  jmp __alltraps
c0101fe3:	e9 25 08 00 00       	jmp    c010280d <__alltraps>

c0101fe8 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $67
c0101fea:	6a 43                	push   $0x43
  jmp __alltraps
c0101fec:	e9 1c 08 00 00       	jmp    c010280d <__alltraps>

c0101ff1 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $68
c0101ff3:	6a 44                	push   $0x44
  jmp __alltraps
c0101ff5:	e9 13 08 00 00       	jmp    c010280d <__alltraps>

c0101ffa <vector69>:
.globl vector69
vector69:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $69
c0101ffc:	6a 45                	push   $0x45
  jmp __alltraps
c0101ffe:	e9 0a 08 00 00       	jmp    c010280d <__alltraps>

c0102003 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $70
c0102005:	6a 46                	push   $0x46
  jmp __alltraps
c0102007:	e9 01 08 00 00       	jmp    c010280d <__alltraps>

c010200c <vector71>:
.globl vector71
vector71:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $71
c010200e:	6a 47                	push   $0x47
  jmp __alltraps
c0102010:	e9 f8 07 00 00       	jmp    c010280d <__alltraps>

c0102015 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $72
c0102017:	6a 48                	push   $0x48
  jmp __alltraps
c0102019:	e9 ef 07 00 00       	jmp    c010280d <__alltraps>

c010201e <vector73>:
.globl vector73
vector73:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $73
c0102020:	6a 49                	push   $0x49
  jmp __alltraps
c0102022:	e9 e6 07 00 00       	jmp    c010280d <__alltraps>

c0102027 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $74
c0102029:	6a 4a                	push   $0x4a
  jmp __alltraps
c010202b:	e9 dd 07 00 00       	jmp    c010280d <__alltraps>

c0102030 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $75
c0102032:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102034:	e9 d4 07 00 00       	jmp    c010280d <__alltraps>

c0102039 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $76
c010203b:	6a 4c                	push   $0x4c
  jmp __alltraps
c010203d:	e9 cb 07 00 00       	jmp    c010280d <__alltraps>

c0102042 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $77
c0102044:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102046:	e9 c2 07 00 00       	jmp    c010280d <__alltraps>

c010204b <vector78>:
.globl vector78
vector78:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $78
c010204d:	6a 4e                	push   $0x4e
  jmp __alltraps
c010204f:	e9 b9 07 00 00       	jmp    c010280d <__alltraps>

c0102054 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $79
c0102056:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102058:	e9 b0 07 00 00       	jmp    c010280d <__alltraps>

c010205d <vector80>:
.globl vector80
vector80:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $80
c010205f:	6a 50                	push   $0x50
  jmp __alltraps
c0102061:	e9 a7 07 00 00       	jmp    c010280d <__alltraps>

c0102066 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $81
c0102068:	6a 51                	push   $0x51
  jmp __alltraps
c010206a:	e9 9e 07 00 00       	jmp    c010280d <__alltraps>

c010206f <vector82>:
.globl vector82
vector82:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $82
c0102071:	6a 52                	push   $0x52
  jmp __alltraps
c0102073:	e9 95 07 00 00       	jmp    c010280d <__alltraps>

c0102078 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $83
c010207a:	6a 53                	push   $0x53
  jmp __alltraps
c010207c:	e9 8c 07 00 00       	jmp    c010280d <__alltraps>

c0102081 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $84
c0102083:	6a 54                	push   $0x54
  jmp __alltraps
c0102085:	e9 83 07 00 00       	jmp    c010280d <__alltraps>

c010208a <vector85>:
.globl vector85
vector85:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $85
c010208c:	6a 55                	push   $0x55
  jmp __alltraps
c010208e:	e9 7a 07 00 00       	jmp    c010280d <__alltraps>

c0102093 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $86
c0102095:	6a 56                	push   $0x56
  jmp __alltraps
c0102097:	e9 71 07 00 00       	jmp    c010280d <__alltraps>

c010209c <vector87>:
.globl vector87
vector87:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $87
c010209e:	6a 57                	push   $0x57
  jmp __alltraps
c01020a0:	e9 68 07 00 00       	jmp    c010280d <__alltraps>

c01020a5 <vector88>:
.globl vector88
vector88:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $88
c01020a7:	6a 58                	push   $0x58
  jmp __alltraps
c01020a9:	e9 5f 07 00 00       	jmp    c010280d <__alltraps>

c01020ae <vector89>:
.globl vector89
vector89:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $89
c01020b0:	6a 59                	push   $0x59
  jmp __alltraps
c01020b2:	e9 56 07 00 00       	jmp    c010280d <__alltraps>

c01020b7 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $90
c01020b9:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020bb:	e9 4d 07 00 00       	jmp    c010280d <__alltraps>

c01020c0 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $91
c01020c2:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020c4:	e9 44 07 00 00       	jmp    c010280d <__alltraps>

c01020c9 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $92
c01020cb:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020cd:	e9 3b 07 00 00       	jmp    c010280d <__alltraps>

c01020d2 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $93
c01020d4:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020d6:	e9 32 07 00 00       	jmp    c010280d <__alltraps>

c01020db <vector94>:
.globl vector94
vector94:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $94
c01020dd:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020df:	e9 29 07 00 00       	jmp    c010280d <__alltraps>

c01020e4 <vector95>:
.globl vector95
vector95:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $95
c01020e6:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020e8:	e9 20 07 00 00       	jmp    c010280d <__alltraps>

c01020ed <vector96>:
.globl vector96
vector96:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $96
c01020ef:	6a 60                	push   $0x60
  jmp __alltraps
c01020f1:	e9 17 07 00 00       	jmp    c010280d <__alltraps>

c01020f6 <vector97>:
.globl vector97
vector97:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $97
c01020f8:	6a 61                	push   $0x61
  jmp __alltraps
c01020fa:	e9 0e 07 00 00       	jmp    c010280d <__alltraps>

c01020ff <vector98>:
.globl vector98
vector98:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $98
c0102101:	6a 62                	push   $0x62
  jmp __alltraps
c0102103:	e9 05 07 00 00       	jmp    c010280d <__alltraps>

c0102108 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $99
c010210a:	6a 63                	push   $0x63
  jmp __alltraps
c010210c:	e9 fc 06 00 00       	jmp    c010280d <__alltraps>

c0102111 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $100
c0102113:	6a 64                	push   $0x64
  jmp __alltraps
c0102115:	e9 f3 06 00 00       	jmp    c010280d <__alltraps>

c010211a <vector101>:
.globl vector101
vector101:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $101
c010211c:	6a 65                	push   $0x65
  jmp __alltraps
c010211e:	e9 ea 06 00 00       	jmp    c010280d <__alltraps>

c0102123 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $102
c0102125:	6a 66                	push   $0x66
  jmp __alltraps
c0102127:	e9 e1 06 00 00       	jmp    c010280d <__alltraps>

c010212c <vector103>:
.globl vector103
vector103:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $103
c010212e:	6a 67                	push   $0x67
  jmp __alltraps
c0102130:	e9 d8 06 00 00       	jmp    c010280d <__alltraps>

c0102135 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $104
c0102137:	6a 68                	push   $0x68
  jmp __alltraps
c0102139:	e9 cf 06 00 00       	jmp    c010280d <__alltraps>

c010213e <vector105>:
.globl vector105
vector105:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $105
c0102140:	6a 69                	push   $0x69
  jmp __alltraps
c0102142:	e9 c6 06 00 00       	jmp    c010280d <__alltraps>

c0102147 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $106
c0102149:	6a 6a                	push   $0x6a
  jmp __alltraps
c010214b:	e9 bd 06 00 00       	jmp    c010280d <__alltraps>

c0102150 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $107
c0102152:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102154:	e9 b4 06 00 00       	jmp    c010280d <__alltraps>

c0102159 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $108
c010215b:	6a 6c                	push   $0x6c
  jmp __alltraps
c010215d:	e9 ab 06 00 00       	jmp    c010280d <__alltraps>

c0102162 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $109
c0102164:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102166:	e9 a2 06 00 00       	jmp    c010280d <__alltraps>

c010216b <vector110>:
.globl vector110
vector110:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $110
c010216d:	6a 6e                	push   $0x6e
  jmp __alltraps
c010216f:	e9 99 06 00 00       	jmp    c010280d <__alltraps>

c0102174 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $111
c0102176:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102178:	e9 90 06 00 00       	jmp    c010280d <__alltraps>

c010217d <vector112>:
.globl vector112
vector112:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $112
c010217f:	6a 70                	push   $0x70
  jmp __alltraps
c0102181:	e9 87 06 00 00       	jmp    c010280d <__alltraps>

c0102186 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $113
c0102188:	6a 71                	push   $0x71
  jmp __alltraps
c010218a:	e9 7e 06 00 00       	jmp    c010280d <__alltraps>

c010218f <vector114>:
.globl vector114
vector114:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $114
c0102191:	6a 72                	push   $0x72
  jmp __alltraps
c0102193:	e9 75 06 00 00       	jmp    c010280d <__alltraps>

c0102198 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $115
c010219a:	6a 73                	push   $0x73
  jmp __alltraps
c010219c:	e9 6c 06 00 00       	jmp    c010280d <__alltraps>

c01021a1 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $116
c01021a3:	6a 74                	push   $0x74
  jmp __alltraps
c01021a5:	e9 63 06 00 00       	jmp    c010280d <__alltraps>

c01021aa <vector117>:
.globl vector117
vector117:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $117
c01021ac:	6a 75                	push   $0x75
  jmp __alltraps
c01021ae:	e9 5a 06 00 00       	jmp    c010280d <__alltraps>

c01021b3 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $118
c01021b5:	6a 76                	push   $0x76
  jmp __alltraps
c01021b7:	e9 51 06 00 00       	jmp    c010280d <__alltraps>

c01021bc <vector119>:
.globl vector119
vector119:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $119
c01021be:	6a 77                	push   $0x77
  jmp __alltraps
c01021c0:	e9 48 06 00 00       	jmp    c010280d <__alltraps>

c01021c5 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $120
c01021c7:	6a 78                	push   $0x78
  jmp __alltraps
c01021c9:	e9 3f 06 00 00       	jmp    c010280d <__alltraps>

c01021ce <vector121>:
.globl vector121
vector121:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $121
c01021d0:	6a 79                	push   $0x79
  jmp __alltraps
c01021d2:	e9 36 06 00 00       	jmp    c010280d <__alltraps>

c01021d7 <vector122>:
.globl vector122
vector122:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $122
c01021d9:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021db:	e9 2d 06 00 00       	jmp    c010280d <__alltraps>

c01021e0 <vector123>:
.globl vector123
vector123:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $123
c01021e2:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021e4:	e9 24 06 00 00       	jmp    c010280d <__alltraps>

c01021e9 <vector124>:
.globl vector124
vector124:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $124
c01021eb:	6a 7c                	push   $0x7c
  jmp __alltraps
c01021ed:	e9 1b 06 00 00       	jmp    c010280d <__alltraps>

c01021f2 <vector125>:
.globl vector125
vector125:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $125
c01021f4:	6a 7d                	push   $0x7d
  jmp __alltraps
c01021f6:	e9 12 06 00 00       	jmp    c010280d <__alltraps>

c01021fb <vector126>:
.globl vector126
vector126:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $126
c01021fd:	6a 7e                	push   $0x7e
  jmp __alltraps
c01021ff:	e9 09 06 00 00       	jmp    c010280d <__alltraps>

c0102204 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $127
c0102206:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102208:	e9 00 06 00 00       	jmp    c010280d <__alltraps>

c010220d <vector128>:
.globl vector128
vector128:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $128
c010220f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102214:	e9 f4 05 00 00       	jmp    c010280d <__alltraps>

c0102219 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $129
c010221b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102220:	e9 e8 05 00 00       	jmp    c010280d <__alltraps>

c0102225 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $130
c0102227:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010222c:	e9 dc 05 00 00       	jmp    c010280d <__alltraps>

c0102231 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $131
c0102233:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102238:	e9 d0 05 00 00       	jmp    c010280d <__alltraps>

c010223d <vector132>:
.globl vector132
vector132:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $132
c010223f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102244:	e9 c4 05 00 00       	jmp    c010280d <__alltraps>

c0102249 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102249:	6a 00                	push   $0x0
  pushl $133
c010224b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102250:	e9 b8 05 00 00       	jmp    c010280d <__alltraps>

c0102255 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $134
c0102257:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010225c:	e9 ac 05 00 00       	jmp    c010280d <__alltraps>

c0102261 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $135
c0102263:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102268:	e9 a0 05 00 00       	jmp    c010280d <__alltraps>

c010226d <vector136>:
.globl vector136
vector136:
  pushl $0
c010226d:	6a 00                	push   $0x0
  pushl $136
c010226f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102274:	e9 94 05 00 00       	jmp    c010280d <__alltraps>

c0102279 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $137
c010227b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102280:	e9 88 05 00 00       	jmp    c010280d <__alltraps>

c0102285 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $138
c0102287:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010228c:	e9 7c 05 00 00       	jmp    c010280d <__alltraps>

c0102291 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102291:	6a 00                	push   $0x0
  pushl $139
c0102293:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102298:	e9 70 05 00 00       	jmp    c010280d <__alltraps>

c010229d <vector140>:
.globl vector140
vector140:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $140
c010229f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022a4:	e9 64 05 00 00       	jmp    c010280d <__alltraps>

c01022a9 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $141
c01022ab:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022b0:	e9 58 05 00 00       	jmp    c010280d <__alltraps>

c01022b5 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022b5:	6a 00                	push   $0x0
  pushl $142
c01022b7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022bc:	e9 4c 05 00 00       	jmp    c010280d <__alltraps>

c01022c1 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $143
c01022c3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022c8:	e9 40 05 00 00       	jmp    c010280d <__alltraps>

c01022cd <vector144>:
.globl vector144
vector144:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $144
c01022cf:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022d4:	e9 34 05 00 00       	jmp    c010280d <__alltraps>

c01022d9 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022d9:	6a 00                	push   $0x0
  pushl $145
c01022db:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022e0:	e9 28 05 00 00       	jmp    c010280d <__alltraps>

c01022e5 <vector146>:
.globl vector146
vector146:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $146
c01022e7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01022ec:	e9 1c 05 00 00       	jmp    c010280d <__alltraps>

c01022f1 <vector147>:
.globl vector147
vector147:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $147
c01022f3:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01022f8:	e9 10 05 00 00       	jmp    c010280d <__alltraps>

c01022fd <vector148>:
.globl vector148
vector148:
  pushl $0
c01022fd:	6a 00                	push   $0x0
  pushl $148
c01022ff:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102304:	e9 04 05 00 00       	jmp    c010280d <__alltraps>

c0102309 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $149
c010230b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102310:	e9 f8 04 00 00       	jmp    c010280d <__alltraps>

c0102315 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $150
c0102317:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010231c:	e9 ec 04 00 00       	jmp    c010280d <__alltraps>

c0102321 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102321:	6a 00                	push   $0x0
  pushl $151
c0102323:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102328:	e9 e0 04 00 00       	jmp    c010280d <__alltraps>

c010232d <vector152>:
.globl vector152
vector152:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $152
c010232f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102334:	e9 d4 04 00 00       	jmp    c010280d <__alltraps>

c0102339 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $153
c010233b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102340:	e9 c8 04 00 00       	jmp    c010280d <__alltraps>

c0102345 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102345:	6a 00                	push   $0x0
  pushl $154
c0102347:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010234c:	e9 bc 04 00 00       	jmp    c010280d <__alltraps>

c0102351 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $155
c0102353:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102358:	e9 b0 04 00 00       	jmp    c010280d <__alltraps>

c010235d <vector156>:
.globl vector156
vector156:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $156
c010235f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102364:	e9 a4 04 00 00       	jmp    c010280d <__alltraps>

c0102369 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102369:	6a 00                	push   $0x0
  pushl $157
c010236b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102370:	e9 98 04 00 00       	jmp    c010280d <__alltraps>

c0102375 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $158
c0102377:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010237c:	e9 8c 04 00 00       	jmp    c010280d <__alltraps>

c0102381 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $159
c0102383:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102388:	e9 80 04 00 00       	jmp    c010280d <__alltraps>

c010238d <vector160>:
.globl vector160
vector160:
  pushl $0
c010238d:	6a 00                	push   $0x0
  pushl $160
c010238f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102394:	e9 74 04 00 00       	jmp    c010280d <__alltraps>

c0102399 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $161
c010239b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023a0:	e9 68 04 00 00       	jmp    c010280d <__alltraps>

c01023a5 <vector162>:
.globl vector162
vector162:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $162
c01023a7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023ac:	e9 5c 04 00 00       	jmp    c010280d <__alltraps>

c01023b1 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023b1:	6a 00                	push   $0x0
  pushl $163
c01023b3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023b8:	e9 50 04 00 00       	jmp    c010280d <__alltraps>

c01023bd <vector164>:
.globl vector164
vector164:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $164
c01023bf:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023c4:	e9 44 04 00 00       	jmp    c010280d <__alltraps>

c01023c9 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $165
c01023cb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023d0:	e9 38 04 00 00       	jmp    c010280d <__alltraps>

c01023d5 <vector166>:
.globl vector166
vector166:
  pushl $0
c01023d5:	6a 00                	push   $0x0
  pushl $166
c01023d7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023dc:	e9 2c 04 00 00       	jmp    c010280d <__alltraps>

c01023e1 <vector167>:
.globl vector167
vector167:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $167
c01023e3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023e8:	e9 20 04 00 00       	jmp    c010280d <__alltraps>

c01023ed <vector168>:
.globl vector168
vector168:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $168
c01023ef:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01023f4:	e9 14 04 00 00       	jmp    c010280d <__alltraps>

c01023f9 <vector169>:
.globl vector169
vector169:
  pushl $0
c01023f9:	6a 00                	push   $0x0
  pushl $169
c01023fb:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102400:	e9 08 04 00 00       	jmp    c010280d <__alltraps>

c0102405 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $170
c0102407:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010240c:	e9 fc 03 00 00       	jmp    c010280d <__alltraps>

c0102411 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $171
c0102413:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102418:	e9 f0 03 00 00       	jmp    c010280d <__alltraps>

c010241d <vector172>:
.globl vector172
vector172:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $172
c010241f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102424:	e9 e4 03 00 00       	jmp    c010280d <__alltraps>

c0102429 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $173
c010242b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102430:	e9 d8 03 00 00       	jmp    c010280d <__alltraps>

c0102435 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $174
c0102437:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010243c:	e9 cc 03 00 00       	jmp    c010280d <__alltraps>

c0102441 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $175
c0102443:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102448:	e9 c0 03 00 00       	jmp    c010280d <__alltraps>

c010244d <vector176>:
.globl vector176
vector176:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $176
c010244f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102454:	e9 b4 03 00 00       	jmp    c010280d <__alltraps>

c0102459 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $177
c010245b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102460:	e9 a8 03 00 00       	jmp    c010280d <__alltraps>

c0102465 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $178
c0102467:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010246c:	e9 9c 03 00 00       	jmp    c010280d <__alltraps>

c0102471 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $179
c0102473:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102478:	e9 90 03 00 00       	jmp    c010280d <__alltraps>

c010247d <vector180>:
.globl vector180
vector180:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $180
c010247f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102484:	e9 84 03 00 00       	jmp    c010280d <__alltraps>

c0102489 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $181
c010248b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102490:	e9 78 03 00 00       	jmp    c010280d <__alltraps>

c0102495 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $182
c0102497:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010249c:	e9 6c 03 00 00       	jmp    c010280d <__alltraps>

c01024a1 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $183
c01024a3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024a8:	e9 60 03 00 00       	jmp    c010280d <__alltraps>

c01024ad <vector184>:
.globl vector184
vector184:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $184
c01024af:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024b4:	e9 54 03 00 00       	jmp    c010280d <__alltraps>

c01024b9 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $185
c01024bb:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024c0:	e9 48 03 00 00       	jmp    c010280d <__alltraps>

c01024c5 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $186
c01024c7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024cc:	e9 3c 03 00 00       	jmp    c010280d <__alltraps>

c01024d1 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $187
c01024d3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024d8:	e9 30 03 00 00       	jmp    c010280d <__alltraps>

c01024dd <vector188>:
.globl vector188
vector188:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $188
c01024df:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024e4:	e9 24 03 00 00       	jmp    c010280d <__alltraps>

c01024e9 <vector189>:
.globl vector189
vector189:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $189
c01024eb:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01024f0:	e9 18 03 00 00       	jmp    c010280d <__alltraps>

c01024f5 <vector190>:
.globl vector190
vector190:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $190
c01024f7:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01024fc:	e9 0c 03 00 00       	jmp    c010280d <__alltraps>

c0102501 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $191
c0102503:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102508:	e9 00 03 00 00       	jmp    c010280d <__alltraps>

c010250d <vector192>:
.globl vector192
vector192:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $192
c010250f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102514:	e9 f4 02 00 00       	jmp    c010280d <__alltraps>

c0102519 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $193
c010251b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102520:	e9 e8 02 00 00       	jmp    c010280d <__alltraps>

c0102525 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $194
c0102527:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010252c:	e9 dc 02 00 00       	jmp    c010280d <__alltraps>

c0102531 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $195
c0102533:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102538:	e9 d0 02 00 00       	jmp    c010280d <__alltraps>

c010253d <vector196>:
.globl vector196
vector196:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $196
c010253f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102544:	e9 c4 02 00 00       	jmp    c010280d <__alltraps>

c0102549 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $197
c010254b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102550:	e9 b8 02 00 00       	jmp    c010280d <__alltraps>

c0102555 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $198
c0102557:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010255c:	e9 ac 02 00 00       	jmp    c010280d <__alltraps>

c0102561 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $199
c0102563:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102568:	e9 a0 02 00 00       	jmp    c010280d <__alltraps>

c010256d <vector200>:
.globl vector200
vector200:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $200
c010256f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102574:	e9 94 02 00 00       	jmp    c010280d <__alltraps>

c0102579 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $201
c010257b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102580:	e9 88 02 00 00       	jmp    c010280d <__alltraps>

c0102585 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $202
c0102587:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010258c:	e9 7c 02 00 00       	jmp    c010280d <__alltraps>

c0102591 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $203
c0102593:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102598:	e9 70 02 00 00       	jmp    c010280d <__alltraps>

c010259d <vector204>:
.globl vector204
vector204:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $204
c010259f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025a4:	e9 64 02 00 00       	jmp    c010280d <__alltraps>

c01025a9 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $205
c01025ab:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025b0:	e9 58 02 00 00       	jmp    c010280d <__alltraps>

c01025b5 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $206
c01025b7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025bc:	e9 4c 02 00 00       	jmp    c010280d <__alltraps>

c01025c1 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $207
c01025c3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025c8:	e9 40 02 00 00       	jmp    c010280d <__alltraps>

c01025cd <vector208>:
.globl vector208
vector208:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $208
c01025cf:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025d4:	e9 34 02 00 00       	jmp    c010280d <__alltraps>

c01025d9 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $209
c01025db:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025e0:	e9 28 02 00 00       	jmp    c010280d <__alltraps>

c01025e5 <vector210>:
.globl vector210
vector210:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $210
c01025e7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01025ec:	e9 1c 02 00 00       	jmp    c010280d <__alltraps>

c01025f1 <vector211>:
.globl vector211
vector211:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $211
c01025f3:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01025f8:	e9 10 02 00 00       	jmp    c010280d <__alltraps>

c01025fd <vector212>:
.globl vector212
vector212:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $212
c01025ff:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102604:	e9 04 02 00 00       	jmp    c010280d <__alltraps>

c0102609 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $213
c010260b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102610:	e9 f8 01 00 00       	jmp    c010280d <__alltraps>

c0102615 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $214
c0102617:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010261c:	e9 ec 01 00 00       	jmp    c010280d <__alltraps>

c0102621 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $215
c0102623:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102628:	e9 e0 01 00 00       	jmp    c010280d <__alltraps>

c010262d <vector216>:
.globl vector216
vector216:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $216
c010262f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102634:	e9 d4 01 00 00       	jmp    c010280d <__alltraps>

c0102639 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $217
c010263b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102640:	e9 c8 01 00 00       	jmp    c010280d <__alltraps>

c0102645 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $218
c0102647:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010264c:	e9 bc 01 00 00       	jmp    c010280d <__alltraps>

c0102651 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $219
c0102653:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102658:	e9 b0 01 00 00       	jmp    c010280d <__alltraps>

c010265d <vector220>:
.globl vector220
vector220:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $220
c010265f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102664:	e9 a4 01 00 00       	jmp    c010280d <__alltraps>

c0102669 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $221
c010266b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102670:	e9 98 01 00 00       	jmp    c010280d <__alltraps>

c0102675 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $222
c0102677:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010267c:	e9 8c 01 00 00       	jmp    c010280d <__alltraps>

c0102681 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $223
c0102683:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102688:	e9 80 01 00 00       	jmp    c010280d <__alltraps>

c010268d <vector224>:
.globl vector224
vector224:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $224
c010268f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102694:	e9 74 01 00 00       	jmp    c010280d <__alltraps>

c0102699 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $225
c010269b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026a0:	e9 68 01 00 00       	jmp    c010280d <__alltraps>

c01026a5 <vector226>:
.globl vector226
vector226:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $226
c01026a7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026ac:	e9 5c 01 00 00       	jmp    c010280d <__alltraps>

c01026b1 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $227
c01026b3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026b8:	e9 50 01 00 00       	jmp    c010280d <__alltraps>

c01026bd <vector228>:
.globl vector228
vector228:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $228
c01026bf:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026c4:	e9 44 01 00 00       	jmp    c010280d <__alltraps>

c01026c9 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $229
c01026cb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026d0:	e9 38 01 00 00       	jmp    c010280d <__alltraps>

c01026d5 <vector230>:
.globl vector230
vector230:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $230
c01026d7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026dc:	e9 2c 01 00 00       	jmp    c010280d <__alltraps>

c01026e1 <vector231>:
.globl vector231
vector231:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $231
c01026e3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026e8:	e9 20 01 00 00       	jmp    c010280d <__alltraps>

c01026ed <vector232>:
.globl vector232
vector232:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $232
c01026ef:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01026f4:	e9 14 01 00 00       	jmp    c010280d <__alltraps>

c01026f9 <vector233>:
.globl vector233
vector233:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $233
c01026fb:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102700:	e9 08 01 00 00       	jmp    c010280d <__alltraps>

c0102705 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $234
c0102707:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010270c:	e9 fc 00 00 00       	jmp    c010280d <__alltraps>

c0102711 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $235
c0102713:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102718:	e9 f0 00 00 00       	jmp    c010280d <__alltraps>

c010271d <vector236>:
.globl vector236
vector236:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $236
c010271f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102724:	e9 e4 00 00 00       	jmp    c010280d <__alltraps>

c0102729 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $237
c010272b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102730:	e9 d8 00 00 00       	jmp    c010280d <__alltraps>

c0102735 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $238
c0102737:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010273c:	e9 cc 00 00 00       	jmp    c010280d <__alltraps>

c0102741 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $239
c0102743:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102748:	e9 c0 00 00 00       	jmp    c010280d <__alltraps>

c010274d <vector240>:
.globl vector240
vector240:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $240
c010274f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102754:	e9 b4 00 00 00       	jmp    c010280d <__alltraps>

c0102759 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $241
c010275b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102760:	e9 a8 00 00 00       	jmp    c010280d <__alltraps>

c0102765 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $242
c0102767:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010276c:	e9 9c 00 00 00       	jmp    c010280d <__alltraps>

c0102771 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $243
c0102773:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102778:	e9 90 00 00 00       	jmp    c010280d <__alltraps>

c010277d <vector244>:
.globl vector244
vector244:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $244
c010277f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102784:	e9 84 00 00 00       	jmp    c010280d <__alltraps>

c0102789 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $245
c010278b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102790:	e9 78 00 00 00       	jmp    c010280d <__alltraps>

c0102795 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $246
c0102797:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010279c:	e9 6c 00 00 00       	jmp    c010280d <__alltraps>

c01027a1 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $247
c01027a3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027a8:	e9 60 00 00 00       	jmp    c010280d <__alltraps>

c01027ad <vector248>:
.globl vector248
vector248:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $248
c01027af:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027b4:	e9 54 00 00 00       	jmp    c010280d <__alltraps>

c01027b9 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $249
c01027bb:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027c0:	e9 48 00 00 00       	jmp    c010280d <__alltraps>

c01027c5 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $250
c01027c7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027cc:	e9 3c 00 00 00       	jmp    c010280d <__alltraps>

c01027d1 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $251
c01027d3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027d8:	e9 30 00 00 00       	jmp    c010280d <__alltraps>

c01027dd <vector252>:
.globl vector252
vector252:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $252
c01027df:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027e4:	e9 24 00 00 00       	jmp    c010280d <__alltraps>

c01027e9 <vector253>:
.globl vector253
vector253:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $253
c01027eb:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01027f0:	e9 18 00 00 00       	jmp    c010280d <__alltraps>

c01027f5 <vector254>:
.globl vector254
vector254:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $254
c01027f7:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01027fc:	e9 0c 00 00 00       	jmp    c010280d <__alltraps>

c0102801 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $255
c0102803:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102808:	e9 00 00 00 00       	jmp    c010280d <__alltraps>

c010280d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010280d:	1e                   	push   %ds
    pushl %es
c010280e:	06                   	push   %es
    pushl %fs
c010280f:	0f a0                	push   %fs
    pushl %gs
c0102811:	0f a8                	push   %gs
    pushal
c0102813:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102814:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102819:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010281b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010281d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010281e:	e8 64 f5 ff ff       	call   c0101d87 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102823:	5c                   	pop    %esp

c0102824 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102824:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102825:	0f a9                	pop    %gs
    popl %fs
c0102827:	0f a1                	pop    %fs
    popl %es
c0102829:	07                   	pop    %es
    popl %ds
c010282a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010282b:	83 c4 08             	add    $0x8,%esp
    iret
c010282e:	cf                   	iret   

c010282f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010282f:	55                   	push   %ebp
c0102830:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102832:	8b 45 08             	mov    0x8(%ebp),%eax
c0102835:	8b 15 38 af 11 c0    	mov    0xc011af38,%edx
c010283b:	29 d0                	sub    %edx,%eax
c010283d:	c1 f8 02             	sar    $0x2,%eax
c0102840:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102846:	5d                   	pop    %ebp
c0102847:	c3                   	ret    

c0102848 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102848:	55                   	push   %ebp
c0102849:	89 e5                	mov    %esp,%ebp
c010284b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010284e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102851:	89 04 24             	mov    %eax,(%esp)
c0102854:	e8 d6 ff ff ff       	call   c010282f <page2ppn>
c0102859:	c1 e0 0c             	shl    $0xc,%eax
}
c010285c:	c9                   	leave  
c010285d:	c3                   	ret    

c010285e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010285e:	55                   	push   %ebp
c010285f:	89 e5                	mov    %esp,%ebp
c0102861:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102864:	8b 45 08             	mov    0x8(%ebp),%eax
c0102867:	c1 e8 0c             	shr    $0xc,%eax
c010286a:	89 c2                	mov    %eax,%edx
c010286c:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0102871:	39 c2                	cmp    %eax,%edx
c0102873:	72 1c                	jb     c0102891 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102875:	c7 44 24 08 90 66 10 	movl   $0xc0106690,0x8(%esp)
c010287c:	c0 
c010287d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102884:	00 
c0102885:	c7 04 24 af 66 10 c0 	movl   $0xc01066af,(%esp)
c010288c:	e8 58 db ff ff       	call   c01003e9 <__panic>
    }
    return &pages[PPN(pa)];
c0102891:	8b 0d 38 af 11 c0    	mov    0xc011af38,%ecx
c0102897:	8b 45 08             	mov    0x8(%ebp),%eax
c010289a:	c1 e8 0c             	shr    $0xc,%eax
c010289d:	89 c2                	mov    %eax,%edx
c010289f:	89 d0                	mov    %edx,%eax
c01028a1:	c1 e0 02             	shl    $0x2,%eax
c01028a4:	01 d0                	add    %edx,%eax
c01028a6:	c1 e0 02             	shl    $0x2,%eax
c01028a9:	01 c8                	add    %ecx,%eax
}
c01028ab:	c9                   	leave  
c01028ac:	c3                   	ret    

c01028ad <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01028ad:	55                   	push   %ebp
c01028ae:	89 e5                	mov    %esp,%ebp
c01028b0:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01028b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b6:	89 04 24             	mov    %eax,(%esp)
c01028b9:	e8 8a ff ff ff       	call   c0102848 <page2pa>
c01028be:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028c4:	c1 e8 0c             	shr    $0xc,%eax
c01028c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01028ca:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c01028cf:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01028d2:	72 23                	jb     c01028f7 <page2kva+0x4a>
c01028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01028db:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c01028e2:	c0 
c01028e3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01028ea:	00 
c01028eb:	c7 04 24 af 66 10 c0 	movl   $0xc01066af,(%esp)
c01028f2:	e8 f2 da ff ff       	call   c01003e9 <__panic>
c01028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028fa:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01028ff:	c9                   	leave  
c0102900:	c3                   	ret    

c0102901 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102901:	55                   	push   %ebp
c0102902:	89 e5                	mov    %esp,%ebp
c0102904:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102907:	8b 45 08             	mov    0x8(%ebp),%eax
c010290a:	83 e0 01             	and    $0x1,%eax
c010290d:	85 c0                	test   %eax,%eax
c010290f:	75 1c                	jne    c010292d <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102911:	c7 44 24 08 e4 66 10 	movl   $0xc01066e4,0x8(%esp)
c0102918:	c0 
c0102919:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102920:	00 
c0102921:	c7 04 24 af 66 10 c0 	movl   $0xc01066af,(%esp)
c0102928:	e8 bc da ff ff       	call   c01003e9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010292d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102930:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102935:	89 04 24             	mov    %eax,(%esp)
c0102938:	e8 21 ff ff ff       	call   c010285e <pa2page>
}
c010293d:	c9                   	leave  
c010293e:	c3                   	ret    

c010293f <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c010293f:	55                   	push   %ebp
c0102940:	89 e5                	mov    %esp,%ebp
c0102942:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102945:	8b 45 08             	mov    0x8(%ebp),%eax
c0102948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010294d:	89 04 24             	mov    %eax,(%esp)
c0102950:	e8 09 ff ff ff       	call   c010285e <pa2page>
}
c0102955:	c9                   	leave  
c0102956:	c3                   	ret    

c0102957 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102957:	55                   	push   %ebp
c0102958:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010295a:	8b 45 08             	mov    0x8(%ebp),%eax
c010295d:	8b 00                	mov    (%eax),%eax
}
c010295f:	5d                   	pop    %ebp
c0102960:	c3                   	ret    

c0102961 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102961:	55                   	push   %ebp
c0102962:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102964:	8b 45 08             	mov    0x8(%ebp),%eax
c0102967:	8b 55 0c             	mov    0xc(%ebp),%edx
c010296a:	89 10                	mov    %edx,(%eax)
}
c010296c:	90                   	nop
c010296d:	5d                   	pop    %ebp
c010296e:	c3                   	ret    

c010296f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010296f:	55                   	push   %ebp
c0102970:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102972:	8b 45 08             	mov    0x8(%ebp),%eax
c0102975:	8b 00                	mov    (%eax),%eax
c0102977:	8d 50 01             	lea    0x1(%eax),%edx
c010297a:	8b 45 08             	mov    0x8(%ebp),%eax
c010297d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010297f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102982:	8b 00                	mov    (%eax),%eax
}
c0102984:	5d                   	pop    %ebp
c0102985:	c3                   	ret    

c0102986 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102986:	55                   	push   %ebp
c0102987:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102989:	8b 45 08             	mov    0x8(%ebp),%eax
c010298c:	8b 00                	mov    (%eax),%eax
c010298e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102991:	8b 45 08             	mov    0x8(%ebp),%eax
c0102994:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102996:	8b 45 08             	mov    0x8(%ebp),%eax
c0102999:	8b 00                	mov    (%eax),%eax
}
c010299b:	5d                   	pop    %ebp
c010299c:	c3                   	ret    

c010299d <__intr_save>:
__intr_save(void) {
c010299d:	55                   	push   %ebp
c010299e:	89 e5                	mov    %esp,%ebp
c01029a0:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01029a3:	9c                   	pushf  
c01029a4:	58                   	pop    %eax
c01029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01029ab:	25 00 02 00 00       	and    $0x200,%eax
c01029b0:	85 c0                	test   %eax,%eax
c01029b2:	74 0c                	je     c01029c0 <__intr_save+0x23>
        intr_disable();
c01029b4:	e8 d4 ee ff ff       	call   c010188d <intr_disable>
        return 1;
c01029b9:	b8 01 00 00 00       	mov    $0x1,%eax
c01029be:	eb 05                	jmp    c01029c5 <__intr_save+0x28>
    return 0;
c01029c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01029c5:	c9                   	leave  
c01029c6:	c3                   	ret    

c01029c7 <__intr_restore>:
__intr_restore(bool flag) {
c01029c7:	55                   	push   %ebp
c01029c8:	89 e5                	mov    %esp,%ebp
c01029ca:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01029cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029d1:	74 05                	je     c01029d8 <__intr_restore+0x11>
        intr_enable();
c01029d3:	e8 ae ee ff ff       	call   c0101886 <intr_enable>
}
c01029d8:	90                   	nop
c01029d9:	c9                   	leave  
c01029da:	c3                   	ret    

c01029db <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01029db:	55                   	push   %ebp
c01029dc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01029de:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01029e4:	b8 23 00 00 00       	mov    $0x23,%eax
c01029e9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01029eb:	b8 23 00 00 00       	mov    $0x23,%eax
c01029f0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01029f2:	b8 10 00 00 00       	mov    $0x10,%eax
c01029f7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01029f9:	b8 10 00 00 00       	mov    $0x10,%eax
c01029fe:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102a00:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a05:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a07:	ea 0e 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a0e
}
c0102a0e:	90                   	nop
c0102a0f:	5d                   	pop    %ebp
c0102a10:	c3                   	ret    

c0102a11 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a11:	55                   	push   %ebp
c0102a12:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a17:	a3 c4 ae 11 c0       	mov    %eax,0xc011aec4
}
c0102a1c:	90                   	nop
c0102a1d:	5d                   	pop    %ebp
c0102a1e:	c3                   	ret    

c0102a1f <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a1f:	55                   	push   %ebp
c0102a20:	89 e5                	mov    %esp,%ebp
c0102a22:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a25:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102a2a:	89 04 24             	mov    %eax,(%esp)
c0102a2d:	e8 df ff ff ff       	call   c0102a11 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102a32:	66 c7 05 c8 ae 11 c0 	movw   $0x10,0xc011aec8
c0102a39:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102a3b:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102a42:	68 00 
c0102a44:	b8 c0 ae 11 c0       	mov    $0xc011aec0,%eax
c0102a49:	0f b7 c0             	movzwl %ax,%eax
c0102a4c:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102a52:	b8 c0 ae 11 c0       	mov    $0xc011aec0,%eax
c0102a57:	c1 e8 10             	shr    $0x10,%eax
c0102a5a:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102a5f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a66:	24 f0                	and    $0xf0,%al
c0102a68:	0c 09                	or     $0x9,%al
c0102a6a:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a6f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a76:	24 ef                	and    $0xef,%al
c0102a78:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a7d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a84:	24 9f                	and    $0x9f,%al
c0102a86:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a8b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a92:	0c 80                	or     $0x80,%al
c0102a94:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a99:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aa0:	24 f0                	and    $0xf0,%al
c0102aa2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102aa7:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aae:	24 ef                	and    $0xef,%al
c0102ab0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ab5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102abc:	24 df                	and    $0xdf,%al
c0102abe:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ac3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aca:	0c 40                	or     $0x40,%al
c0102acc:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ad1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ad8:	24 7f                	and    $0x7f,%al
c0102ada:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102adf:	b8 c0 ae 11 c0       	mov    $0xc011aec0,%eax
c0102ae4:	c1 e8 18             	shr    $0x18,%eax
c0102ae7:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102aec:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0102af3:	e8 e3 fe ff ff       	call   c01029db <lgdt>
c0102af8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102afe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b02:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b05:	90                   	nop
c0102b06:	c9                   	leave  
c0102b07:	c3                   	ret    

c0102b08 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b08:	55                   	push   %ebp
c0102b09:	89 e5                	mov    %esp,%ebp
c0102b0b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102b0e:	c7 05 30 af 11 c0 70 	movl   $0xc0107070,0xc011af30
c0102b15:	70 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b18:	a1 30 af 11 c0       	mov    0xc011af30,%eax
c0102b1d:	8b 00                	mov    (%eax),%eax
c0102b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102b23:	c7 04 24 10 67 10 c0 	movl   $0xc0106710,(%esp)
c0102b2a:	e8 63 d7 ff ff       	call   c0100292 <cprintf>
    pmm_manager->init();
c0102b2f:	a1 30 af 11 c0       	mov    0xc011af30,%eax
c0102b34:	8b 40 04             	mov    0x4(%eax),%eax
c0102b37:	ff d0                	call   *%eax
}
c0102b39:	90                   	nop
c0102b3a:	c9                   	leave  
c0102b3b:	c3                   	ret    

c0102b3c <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102b3c:	55                   	push   %ebp
c0102b3d:	89 e5                	mov    %esp,%ebp
c0102b3f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102b42:	a1 30 af 11 c0       	mov    0xc011af30,%eax
c0102b47:	8b 40 08             	mov    0x8(%eax),%eax
c0102b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b4d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102b51:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b54:	89 14 24             	mov    %edx,(%esp)
c0102b57:	ff d0                	call   *%eax
}
c0102b59:	90                   	nop
c0102b5a:	c9                   	leave  
c0102b5b:	c3                   	ret    

c0102b5c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102b5c:	55                   	push   %ebp
c0102b5d:	89 e5                	mov    %esp,%ebp
c0102b5f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102b69:	e8 2f fe ff ff       	call   c010299d <__intr_save>
c0102b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102b71:	a1 30 af 11 c0       	mov    0xc011af30,%eax
c0102b76:	8b 40 0c             	mov    0xc(%eax),%eax
c0102b79:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b7c:	89 14 24             	mov    %edx,(%esp)
c0102b7f:	ff d0                	call   *%eax
c0102b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b87:	89 04 24             	mov    %eax,(%esp)
c0102b8a:	e8 38 fe ff ff       	call   c01029c7 <__intr_restore>
    return page;
c0102b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b92:	c9                   	leave  
c0102b93:	c3                   	ret    

c0102b94 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102b94:	55                   	push   %ebp
c0102b95:	89 e5                	mov    %esp,%ebp
c0102b97:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102b9a:	e8 fe fd ff ff       	call   c010299d <__intr_save>
c0102b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102ba2:	a1 30 af 11 c0       	mov    0xc011af30,%eax
c0102ba7:	8b 40 10             	mov    0x10(%eax),%eax
c0102baa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102bad:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102bb1:	8b 55 08             	mov    0x8(%ebp),%edx
c0102bb4:	89 14 24             	mov    %edx,(%esp)
c0102bb7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bbc:	89 04 24             	mov    %eax,(%esp)
c0102bbf:	e8 03 fe ff ff       	call   c01029c7 <__intr_restore>
}
c0102bc4:	90                   	nop
c0102bc5:	c9                   	leave  
c0102bc6:	c3                   	ret    

c0102bc7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102bc7:	55                   	push   %ebp
c0102bc8:	89 e5                	mov    %esp,%ebp
c0102bca:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bcd:	e8 cb fd ff ff       	call   c010299d <__intr_save>
c0102bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102bd5:	a1 30 af 11 c0       	mov    0xc011af30,%eax
c0102bda:	8b 40 14             	mov    0x14(%eax),%eax
c0102bdd:	ff d0                	call   *%eax
c0102bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be5:	89 04 24             	mov    %eax,(%esp)
c0102be8:	e8 da fd ff ff       	call   c01029c7 <__intr_restore>
    return ret;
c0102bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102bf0:	c9                   	leave  
c0102bf1:	c3                   	ret    

c0102bf2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102bf2:	55                   	push   %ebp
c0102bf3:	89 e5                	mov    %esp,%ebp
c0102bf5:	57                   	push   %edi
c0102bf6:	56                   	push   %esi
c0102bf7:	53                   	push   %ebx
c0102bf8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102bfe:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c13:	c7 04 24 27 67 10 c0 	movl   $0xc0106727,(%esp)
c0102c1a:	e8 73 d6 ff ff       	call   c0100292 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c26:	e9 22 01 00 00       	jmp    c0102d4d <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c2b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c31:	89 d0                	mov    %edx,%eax
c0102c33:	c1 e0 02             	shl    $0x2,%eax
c0102c36:	01 d0                	add    %edx,%eax
c0102c38:	c1 e0 02             	shl    $0x2,%eax
c0102c3b:	01 c8                	add    %ecx,%eax
c0102c3d:	8b 50 08             	mov    0x8(%eax),%edx
c0102c40:	8b 40 04             	mov    0x4(%eax),%eax
c0102c43:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102c46:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102c49:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c4f:	89 d0                	mov    %edx,%eax
c0102c51:	c1 e0 02             	shl    $0x2,%eax
c0102c54:	01 d0                	add    %edx,%eax
c0102c56:	c1 e0 02             	shl    $0x2,%eax
c0102c59:	01 c8                	add    %ecx,%eax
c0102c5b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102c5e:	8b 58 10             	mov    0x10(%eax),%ebx
c0102c61:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102c64:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102c67:	01 c8                	add    %ecx,%eax
c0102c69:	11 da                	adc    %ebx,%edx
c0102c6b:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102c6e:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102c71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c74:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c77:	89 d0                	mov    %edx,%eax
c0102c79:	c1 e0 02             	shl    $0x2,%eax
c0102c7c:	01 d0                	add    %edx,%eax
c0102c7e:	c1 e0 02             	shl    $0x2,%eax
c0102c81:	01 c8                	add    %ecx,%eax
c0102c83:	83 c0 14             	add    $0x14,%eax
c0102c86:	8b 00                	mov    (%eax),%eax
c0102c88:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102c8b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102c8e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102c91:	83 c0 ff             	add    $0xffffffff,%eax
c0102c94:	83 d2 ff             	adc    $0xffffffff,%edx
c0102c97:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102c9d:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102ca3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ca6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ca9:	89 d0                	mov    %edx,%eax
c0102cab:	c1 e0 02             	shl    $0x2,%eax
c0102cae:	01 d0                	add    %edx,%eax
c0102cb0:	c1 e0 02             	shl    $0x2,%eax
c0102cb3:	01 c8                	add    %ecx,%eax
c0102cb5:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102cb8:	8b 58 10             	mov    0x10(%eax),%ebx
c0102cbb:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102cbe:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102cc2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102cc8:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102cce:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102cd2:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102cd6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102cd9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102cdc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102ce0:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102ce4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102ce8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102cec:	c7 04 24 34 67 10 c0 	movl   $0xc0106734,(%esp)
c0102cf3:	e8 9a d5 ff ff       	call   c0100292 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102cf8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cfe:	89 d0                	mov    %edx,%eax
c0102d00:	c1 e0 02             	shl    $0x2,%eax
c0102d03:	01 d0                	add    %edx,%eax
c0102d05:	c1 e0 02             	shl    $0x2,%eax
c0102d08:	01 c8                	add    %ecx,%eax
c0102d0a:	83 c0 14             	add    $0x14,%eax
c0102d0d:	8b 00                	mov    (%eax),%eax
c0102d0f:	83 f8 01             	cmp    $0x1,%eax
c0102d12:	75 36                	jne    c0102d4a <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0102d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d1a:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102d1d:	77 2b                	ja     c0102d4a <page_init+0x158>
c0102d1f:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102d22:	72 05                	jb     c0102d29 <page_init+0x137>
c0102d24:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102d27:	73 21                	jae    c0102d4a <page_init+0x158>
c0102d29:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102d2d:	77 1b                	ja     c0102d4a <page_init+0x158>
c0102d2f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102d33:	72 09                	jb     c0102d3e <page_init+0x14c>
c0102d35:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0102d3c:	77 0c                	ja     c0102d4a <page_init+0x158>
                maxpa = end;
c0102d3e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102d41:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102d47:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d4a:	ff 45 dc             	incl   -0x24(%ebp)
c0102d4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d50:	8b 00                	mov    (%eax),%eax
c0102d52:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102d55:	0f 8c d0 fe ff ff    	jl     c0102c2b <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102d5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d5f:	72 1d                	jb     c0102d7e <page_init+0x18c>
c0102d61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d65:	77 09                	ja     c0102d70 <page_init+0x17e>
c0102d67:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102d6e:	76 0e                	jbe    c0102d7e <page_init+0x18c>
        maxpa = KMEMSIZE;
c0102d70:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102d77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d84:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102d88:	c1 ea 0c             	shr    $0xc,%edx
c0102d8b:	89 c1                	mov    %eax,%ecx
c0102d8d:	89 d3                	mov    %edx,%ebx
c0102d8f:	89 c8                	mov    %ecx,%eax
c0102d91:	a3 a0 ae 11 c0       	mov    %eax,0xc011aea0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102d96:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102d9d:	b8 48 af 11 c0       	mov    $0xc011af48,%eax
c0102da2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102da5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102da8:	01 d0                	add    %edx,%eax
c0102daa:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102dad:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102db0:	ba 00 00 00 00       	mov    $0x0,%edx
c0102db5:	f7 75 c0             	divl   -0x40(%ebp)
c0102db8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102dbb:	29 d0                	sub    %edx,%eax
c0102dbd:	a3 38 af 11 c0       	mov    %eax,0xc011af38

    for (i = 0; i < npage; i ++) {
c0102dc2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102dc9:	eb 2e                	jmp    c0102df9 <page_init+0x207>
        SetPageReserved(pages + i);
c0102dcb:	8b 0d 38 af 11 c0    	mov    0xc011af38,%ecx
c0102dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dd4:	89 d0                	mov    %edx,%eax
c0102dd6:	c1 e0 02             	shl    $0x2,%eax
c0102dd9:	01 d0                	add    %edx,%eax
c0102ddb:	c1 e0 02             	shl    $0x2,%eax
c0102dde:	01 c8                	add    %ecx,%eax
c0102de0:	83 c0 04             	add    $0x4,%eax
c0102de3:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102dea:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ded:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102df0:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102df3:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102df6:	ff 45 dc             	incl   -0x24(%ebp)
c0102df9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dfc:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0102e01:	39 c2                	cmp    %eax,%edx
c0102e03:	72 c6                	jb     c0102dcb <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102e05:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c0102e0b:	89 d0                	mov    %edx,%eax
c0102e0d:	c1 e0 02             	shl    $0x2,%eax
c0102e10:	01 d0                	add    %edx,%eax
c0102e12:	c1 e0 02             	shl    $0x2,%eax
c0102e15:	89 c2                	mov    %eax,%edx
c0102e17:	a1 38 af 11 c0       	mov    0xc011af38,%eax
c0102e1c:	01 d0                	add    %edx,%eax
c0102e1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102e21:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102e28:	77 23                	ja     c0102e4d <page_init+0x25b>
c0102e2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e31:	c7 44 24 08 64 67 10 	movl   $0xc0106764,0x8(%esp)
c0102e38:	c0 
c0102e39:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102e40:	00 
c0102e41:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0102e48:	e8 9c d5 ff ff       	call   c01003e9 <__panic>
c0102e4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e50:	05 00 00 00 40       	add    $0x40000000,%eax
c0102e55:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e5f:	e9 69 01 00 00       	jmp    c0102fcd <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e64:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e67:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e6a:	89 d0                	mov    %edx,%eax
c0102e6c:	c1 e0 02             	shl    $0x2,%eax
c0102e6f:	01 d0                	add    %edx,%eax
c0102e71:	c1 e0 02             	shl    $0x2,%eax
c0102e74:	01 c8                	add    %ecx,%eax
c0102e76:	8b 50 08             	mov    0x8(%eax),%edx
c0102e79:	8b 40 04             	mov    0x4(%eax),%eax
c0102e7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e7f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102e82:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e85:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e88:	89 d0                	mov    %edx,%eax
c0102e8a:	c1 e0 02             	shl    $0x2,%eax
c0102e8d:	01 d0                	add    %edx,%eax
c0102e8f:	c1 e0 02             	shl    $0x2,%eax
c0102e92:	01 c8                	add    %ecx,%eax
c0102e94:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e97:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ea0:	01 c8                	add    %ecx,%eax
c0102ea2:	11 da                	adc    %ebx,%edx
c0102ea4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ea7:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102eaa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ead:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eb0:	89 d0                	mov    %edx,%eax
c0102eb2:	c1 e0 02             	shl    $0x2,%eax
c0102eb5:	01 d0                	add    %edx,%eax
c0102eb7:	c1 e0 02             	shl    $0x2,%eax
c0102eba:	01 c8                	add    %ecx,%eax
c0102ebc:	83 c0 14             	add    $0x14,%eax
c0102ebf:	8b 00                	mov    (%eax),%eax
c0102ec1:	83 f8 01             	cmp    $0x1,%eax
c0102ec4:	0f 85 00 01 00 00    	jne    c0102fca <page_init+0x3d8>
            if (begin < freemem) {
c0102eca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ecd:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ed2:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0102ed5:	77 17                	ja     c0102eee <page_init+0x2fc>
c0102ed7:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0102eda:	72 05                	jb     c0102ee1 <page_init+0x2ef>
c0102edc:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0102edf:	73 0d                	jae    c0102eee <page_init+0x2fc>
                begin = freemem;
c0102ee1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ee4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ee7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102eee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ef2:	72 1d                	jb     c0102f11 <page_init+0x31f>
c0102ef4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ef8:	77 09                	ja     c0102f03 <page_init+0x311>
c0102efa:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102f01:	76 0e                	jbe    c0102f11 <page_init+0x31f>
                end = KMEMSIZE;
c0102f03:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102f0a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102f11:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f17:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f1a:	0f 87 aa 00 00 00    	ja     c0102fca <page_init+0x3d8>
c0102f20:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f23:	72 09                	jb     c0102f2e <page_init+0x33c>
c0102f25:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f28:	0f 83 9c 00 00 00    	jae    c0102fca <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
c0102f2e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0102f35:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f38:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f3b:	01 d0                	add    %edx,%eax
c0102f3d:	48                   	dec    %eax
c0102f3e:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102f41:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f44:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f49:	f7 75 b0             	divl   -0x50(%ebp)
c0102f4c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f4f:	29 d0                	sub    %edx,%eax
c0102f51:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f56:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f59:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102f5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f5f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102f62:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f65:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f6a:	89 c3                	mov    %eax,%ebx
c0102f6c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102f72:	89 de                	mov    %ebx,%esi
c0102f74:	89 d0                	mov    %edx,%eax
c0102f76:	83 e0 00             	and    $0x0,%eax
c0102f79:	89 c7                	mov    %eax,%edi
c0102f7b:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102f7e:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102f81:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f87:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f8a:	77 3e                	ja     c0102fca <page_init+0x3d8>
c0102f8c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f8f:	72 05                	jb     c0102f96 <page_init+0x3a4>
c0102f91:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f94:	73 34                	jae    c0102fca <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102f96:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f99:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102f9c:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102f9f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102fa2:	89 c1                	mov    %eax,%ecx
c0102fa4:	89 d3                	mov    %edx,%ebx
c0102fa6:	89 c8                	mov    %ecx,%eax
c0102fa8:	89 da                	mov    %ebx,%edx
c0102faa:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102fae:	c1 ea 0c             	shr    $0xc,%edx
c0102fb1:	89 c3                	mov    %eax,%ebx
c0102fb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fb6:	89 04 24             	mov    %eax,(%esp)
c0102fb9:	e8 a0 f8 ff ff       	call   c010285e <pa2page>
c0102fbe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102fc2:	89 04 24             	mov    %eax,(%esp)
c0102fc5:	e8 72 fb ff ff       	call   c0102b3c <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0102fca:	ff 45 dc             	incl   -0x24(%ebp)
c0102fcd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fd0:	8b 00                	mov    (%eax),%eax
c0102fd2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fd5:	0f 8c 89 fe ff ff    	jl     c0102e64 <page_init+0x272>
                }
            }
        }
    }
}
c0102fdb:	90                   	nop
c0102fdc:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0102fe2:	5b                   	pop    %ebx
c0102fe3:	5e                   	pop    %esi
c0102fe4:	5f                   	pop    %edi
c0102fe5:	5d                   	pop    %ebp
c0102fe6:	c3                   	ret    

c0102fe7 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0102fe7:	55                   	push   %ebp
c0102fe8:	89 e5                	mov    %esp,%ebp
c0102fea:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0102fed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ff0:	33 45 14             	xor    0x14(%ebp),%eax
c0102ff3:	25 ff 0f 00 00       	and    $0xfff,%eax
c0102ff8:	85 c0                	test   %eax,%eax
c0102ffa:	74 24                	je     c0103020 <boot_map_segment+0x39>
c0102ffc:	c7 44 24 0c 96 67 10 	movl   $0xc0106796,0xc(%esp)
c0103003:	c0 
c0103004:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c010300b:	c0 
c010300c:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103013:	00 
c0103014:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c010301b:	e8 c9 d3 ff ff       	call   c01003e9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103020:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103027:	8b 45 0c             	mov    0xc(%ebp),%eax
c010302a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010302f:	89 c2                	mov    %eax,%edx
c0103031:	8b 45 10             	mov    0x10(%ebp),%eax
c0103034:	01 c2                	add    %eax,%edx
c0103036:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103039:	01 d0                	add    %edx,%eax
c010303b:	48                   	dec    %eax
c010303c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103042:	ba 00 00 00 00       	mov    $0x0,%edx
c0103047:	f7 75 f0             	divl   -0x10(%ebp)
c010304a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010304d:	29 d0                	sub    %edx,%eax
c010304f:	c1 e8 0c             	shr    $0xc,%eax
c0103052:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103055:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103058:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010305e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103063:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103066:	8b 45 14             	mov    0x14(%ebp),%eax
c0103069:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010306c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010306f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103074:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103077:	eb 68                	jmp    c01030e1 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103079:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103080:	00 
c0103081:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103084:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103088:	8b 45 08             	mov    0x8(%ebp),%eax
c010308b:	89 04 24             	mov    %eax,(%esp)
c010308e:	e8 81 01 00 00       	call   c0103214 <get_pte>
c0103093:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103096:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010309a:	75 24                	jne    c01030c0 <boot_map_segment+0xd9>
c010309c:	c7 44 24 0c c2 67 10 	movl   $0xc01067c2,0xc(%esp)
c01030a3:	c0 
c01030a4:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c01030ab:	c0 
c01030ac:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01030b3:	00 
c01030b4:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01030bb:	e8 29 d3 ff ff       	call   c01003e9 <__panic>
        *ptep = pa | PTE_P | perm;
c01030c0:	8b 45 14             	mov    0x14(%ebp),%eax
c01030c3:	0b 45 18             	or     0x18(%ebp),%eax
c01030c6:	83 c8 01             	or     $0x1,%eax
c01030c9:	89 c2                	mov    %eax,%edx
c01030cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030ce:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030d0:	ff 4d f4             	decl   -0xc(%ebp)
c01030d3:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01030da:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01030e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030e5:	75 92                	jne    c0103079 <boot_map_segment+0x92>
    }
}
c01030e7:	90                   	nop
c01030e8:	c9                   	leave  
c01030e9:	c3                   	ret    

c01030ea <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01030ea:	55                   	push   %ebp
c01030eb:	89 e5                	mov    %esp,%ebp
c01030ed:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01030f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030f7:	e8 60 fa ff ff       	call   c0102b5c <alloc_pages>
c01030fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01030ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103103:	75 1c                	jne    c0103121 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0103105:	c7 44 24 08 cf 67 10 	movl   $0xc01067cf,0x8(%esp)
c010310c:	c0 
c010310d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103114:	00 
c0103115:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c010311c:	e8 c8 d2 ff ff       	call   c01003e9 <__panic>
    }
    return page2kva(p);
c0103121:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103124:	89 04 24             	mov    %eax,(%esp)
c0103127:	e8 81 f7 ff ff       	call   c01028ad <page2kva>
}
c010312c:	c9                   	leave  
c010312d:	c3                   	ret    

c010312e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010312e:	55                   	push   %ebp
c010312f:	89 e5                	mov    %esp,%ebp
c0103131:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0103134:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010313c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103143:	77 23                	ja     c0103168 <pmm_init+0x3a>
c0103145:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103148:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010314c:	c7 44 24 08 64 67 10 	movl   $0xc0106764,0x8(%esp)
c0103153:	c0 
c0103154:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010315b:	00 
c010315c:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103163:	e8 81 d2 ff ff       	call   c01003e9 <__panic>
c0103168:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010316b:	05 00 00 00 40       	add    $0x40000000,%eax
c0103170:	a3 34 af 11 c0       	mov    %eax,0xc011af34
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103175:	e8 8e f9 ff ff       	call   c0102b08 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010317a:	e8 73 fa ff ff       	call   c0102bf2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010317f:	e8 20 04 00 00       	call   c01035a4 <check_alloc_page>

    check_pgdir();
c0103184:	e8 3a 04 00 00       	call   c01035c3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103189:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010318e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103191:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103198:	77 23                	ja     c01031bd <pmm_init+0x8f>
c010319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010319d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01031a1:	c7 44 24 08 64 67 10 	movl   $0xc0106764,0x8(%esp)
c01031a8:	c0 
c01031a9:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01031b0:	00 
c01031b1:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01031b8:	e8 2c d2 ff ff       	call   c01003e9 <__panic>
c01031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031c0:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01031c6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01031cb:	05 ac 0f 00 00       	add    $0xfac,%eax
c01031d0:	83 ca 03             	or     $0x3,%edx
c01031d3:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01031d5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01031da:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01031e1:	00 
c01031e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01031e9:	00 
c01031ea:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01031f1:	38 
c01031f2:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01031f9:	c0 
c01031fa:	89 04 24             	mov    %eax,(%esp)
c01031fd:	e8 e5 fd ff ff       	call   c0102fe7 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103202:	e8 18 f8 ff ff       	call   c0102a1f <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103207:	e8 53 0a 00 00       	call   c0103c5f <check_boot_pgdir>

    print_pgdir();
c010320c:	e8 cc 0e 00 00       	call   c01040dd <print_pgdir>

}
c0103211:	90                   	nop
c0103212:	c9                   	leave  
c0103213:	c3                   	ret    

c0103214 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103214:	55                   	push   %ebp
c0103215:	89 e5                	mov    %esp,%ebp
c0103217:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

    pde_t *pdep = pgdir + PDX(la); //PDX意为取前十位的页表目录索引
c010321a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010321d:	c1 e8 16             	shr    $0x16,%eax
c0103220:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103227:	8b 45 08             	mov    0x8(%ebp),%eax
c010322a:	01 d0                	add    %edx,%eax
c010322c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pte_t *ptep = ((pte_t *) (KADDR(*pdep & ~0XFFF)) + PTX(la)); 
c010322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103232:	8b 00                	mov    (%eax),%eax
c0103234:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103239:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010323f:	c1 e8 0c             	shr    $0xc,%eax
c0103242:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103245:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c010324a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010324d:	72 23                	jb     c0103272 <get_pte+0x5e>
c010324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103252:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103256:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c010325d:	c0 
c010325e:	c7 44 24 04 60 01 00 	movl   $0x160,0x4(%esp)
c0103265:	00 
c0103266:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c010326d:	e8 77 d1 ff ff       	call   c01003e9 <__panic>
c0103272:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103275:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010327a:	89 c2                	mov    %eax,%edx
c010327c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010327f:	c1 e8 0c             	shr    $0xc,%eax
c0103282:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103287:	c1 e0 02             	shl    $0x2,%eax
c010328a:	01 d0                	add    %edx,%eax
c010328c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    //得到二级页表的首地址后用PTX计算二级页表中的索引
    if (*pdep & PTE_P) 
c010328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103292:	8b 00                	mov    (%eax),%eax
c0103294:	83 e0 01             	and    $0x1,%eax
c0103297:	85 c0                	test   %eax,%eax
c0103299:	74 08                	je     c01032a3 <get_pte+0x8f>
        return ptep; 
c010329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010329e:	e9 dd 00 00 00       	jmp    c0103380 <get_pte+0x16c>
    //返回存在的页表项，对于不存在的页表项根据create参数决定是否创建
    if (!create) 
c01032a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01032a7:	75 0a                	jne    c01032b3 <get_pte+0x9f>
        return NULL;
c01032a9:	b8 00 00 00 00       	mov    $0x0,%eax
c01032ae:	e9 cd 00 00 00       	jmp    c0103380 <get_pte+0x16c>
    struct Page* pt = alloc_page();
c01032b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032ba:	e8 9d f8 ff ff       	call   c0102b5c <alloc_pages>
c01032bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (pt == NULL) 
c01032c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01032c6:	75 0a                	jne    c01032d2 <get_pte+0xbe>
        return NULL;
c01032c8:	b8 00 00 00 00       	mov    $0x0,%eax
c01032cd:	e9 ae 00 00 00       	jmp    c0103380 <get_pte+0x16c>
    set_page_ref(pt, 1);
c01032d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032d9:	00 
c01032da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032dd:	89 04 24             	mov    %eax,(%esp)
c01032e0:	e8 7c f6 ff ff       	call   c0102961 <set_page_ref>
    //分配一个新的内存页来存储新的页表项
    ptep = KADDR(page2pa(pt)); //页面->物理地址->虚拟地址
c01032e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032e8:	89 04 24             	mov    %eax,(%esp)
c01032eb:	e8 58 f5 ff ff       	call   c0102848 <page2pa>
c01032f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01032f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032f6:	c1 e8 0c             	shr    $0xc,%eax
c01032f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01032fc:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0103301:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103304:	72 23                	jb     c0103329 <get_pte+0x115>
c0103306:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103309:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010330d:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c0103314:	c0 
c0103315:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
c010331c:	00 
c010331d:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103324:	e8 c0 d0 ff ff       	call   c01003e9 <__panic>
c0103329:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010332c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103331:	89 45 e8             	mov    %eax,-0x18(%ebp)
    memset(ptep, 0, PGSIZE); 
c0103334:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010333b:	00 
c010333c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103343:	00 
c0103344:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103347:	89 04 24             	mov    %eax,(%esp)
c010334a:	e8 04 24 00 00       	call   c0105753 <memset>
    *pdep = (page2pa(pt) & ~0XFFF) | PTE_U | PTE_W | PTE_P;
c010334f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103352:	89 04 24             	mov    %eax,(%esp)
c0103355:	e8 ee f4 ff ff       	call   c0102848 <page2pa>
c010335a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010335f:	83 c8 07             	or     $0x7,%eax
c0103362:	89 c2                	mov    %eax,%edx
c0103364:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103367:	89 10                	mov    %edx,(%eax)
    return ptep + PTX(la);
c0103369:	8b 45 0c             	mov    0xc(%ebp),%eax
c010336c:	c1 e8 0c             	shr    $0xc,%eax
c010336f:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010337e:	01 d0                	add    %edx,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0103380:	c9                   	leave  
c0103381:	c3                   	ret    

c0103382 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103382:	55                   	push   %ebp
c0103383:	89 e5                	mov    %esp,%ebp
c0103385:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103388:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010338f:	00 
c0103390:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103393:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103397:	8b 45 08             	mov    0x8(%ebp),%eax
c010339a:	89 04 24             	mov    %eax,(%esp)
c010339d:	e8 72 fe ff ff       	call   c0103214 <get_pte>
c01033a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01033a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01033a9:	74 08                	je     c01033b3 <get_page+0x31>
        *ptep_store = ptep;
c01033ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01033ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01033b1:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01033b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033b7:	74 1b                	je     c01033d4 <get_page+0x52>
c01033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033bc:	8b 00                	mov    (%eax),%eax
c01033be:	83 e0 01             	and    $0x1,%eax
c01033c1:	85 c0                	test   %eax,%eax
c01033c3:	74 0f                	je     c01033d4 <get_page+0x52>
        return pte2page(*ptep);
c01033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033c8:	8b 00                	mov    (%eax),%eax
c01033ca:	89 04 24             	mov    %eax,(%esp)
c01033cd:	e8 2f f5 ff ff       	call   c0102901 <pte2page>
c01033d2:	eb 05                	jmp    c01033d9 <get_page+0x57>
    }
    return NULL;
c01033d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01033d9:	c9                   	leave  
c01033da:	c3                   	ret    

c01033db <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01033db:	55                   	push   %ebp
c01033dc:	89 e5                	mov    %esp,%ebp
c01033de:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if (*ptep & PTE_P) {
c01033e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01033e4:	8b 00                	mov    (%eax),%eax
c01033e6:	83 e0 01             	and    $0x1,%eax
c01033e9:	85 c0                	test   %eax,%eax
c01033eb:	74 5a                	je     c0103447 <page_remove_pte+0x6c>
        struct Page *page = pte2page(*ptep);
c01033ed:	8b 45 10             	mov    0x10(%ebp),%eax
c01033f0:	8b 00                	mov    (%eax),%eax
c01033f2:	89 04 24             	mov    %eax,(%esp)
c01033f5:	e8 07 f5 ff ff       	call   c0102901 <pte2page>
c01033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //引用计数变为0则释放空间
        if (!--(page->ref)) 
c01033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103400:	8b 00                	mov    (%eax),%eax
c0103402:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103405:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103408:	89 10                	mov    %edx,(%eax)
c010340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010340d:	8b 00                	mov    (%eax),%eax
c010340f:	85 c0                	test   %eax,%eax
c0103411:	75 13                	jne    c0103426 <page_remove_pte+0x4b>
            free_page(page);
c0103413:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010341a:	00 
c010341b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010341e:	89 04 24             	mov    %eax,(%esp)
c0103421:	e8 6e f7 ff ff       	call   c0102b94 <free_pages>
        //无效化二级页表项 
        *ptep &= (~PTE_P);
c0103426:	8b 45 10             	mov    0x10(%ebp),%eax
c0103429:	8b 00                	mov    (%eax),%eax
c010342b:	83 e0 fe             	and    $0xfffffffe,%eax
c010342e:	89 c2                	mov    %eax,%edx
c0103430:	8b 45 10             	mov    0x10(%ebp),%eax
c0103433:	89 10                	mov    %edx,(%eax)
        tlb_invalidate(pgdir, la);//刷新tlb
c0103435:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103438:	89 44 24 04          	mov    %eax,0x4(%esp)
c010343c:	8b 45 08             	mov    0x8(%ebp),%eax
c010343f:	89 04 24             	mov    %eax,(%esp)
c0103442:	e8 01 01 00 00       	call   c0103548 <tlb_invalidate>
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103447:	90                   	nop
c0103448:	c9                   	leave  
c0103449:	c3                   	ret    

c010344a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010344a:	55                   	push   %ebp
c010344b:	89 e5                	mov    %esp,%ebp
c010344d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103450:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103457:	00 
c0103458:	8b 45 0c             	mov    0xc(%ebp),%eax
c010345b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010345f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103462:	89 04 24             	mov    %eax,(%esp)
c0103465:	e8 aa fd ff ff       	call   c0103214 <get_pte>
c010346a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010346d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103471:	74 19                	je     c010348c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0103473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103476:	89 44 24 08          	mov    %eax,0x8(%esp)
c010347a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010347d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103481:	8b 45 08             	mov    0x8(%ebp),%eax
c0103484:	89 04 24             	mov    %eax,(%esp)
c0103487:	e8 4f ff ff ff       	call   c01033db <page_remove_pte>
    }
}
c010348c:	90                   	nop
c010348d:	c9                   	leave  
c010348e:	c3                   	ret    

c010348f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010348f:	55                   	push   %ebp
c0103490:	89 e5                	mov    %esp,%ebp
c0103492:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103495:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010349c:	00 
c010349d:	8b 45 10             	mov    0x10(%ebp),%eax
c01034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01034a7:	89 04 24             	mov    %eax,(%esp)
c01034aa:	e8 65 fd ff ff       	call   c0103214 <get_pte>
c01034af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01034b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034b6:	75 0a                	jne    c01034c2 <page_insert+0x33>
        return -E_NO_MEM;
c01034b8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01034bd:	e9 84 00 00 00       	jmp    c0103546 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01034c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034c5:	89 04 24             	mov    %eax,(%esp)
c01034c8:	e8 a2 f4 ff ff       	call   c010296f <page_ref_inc>
    if (*ptep & PTE_P) {
c01034cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d0:	8b 00                	mov    (%eax),%eax
c01034d2:	83 e0 01             	and    $0x1,%eax
c01034d5:	85 c0                	test   %eax,%eax
c01034d7:	74 3e                	je     c0103517 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034dc:	8b 00                	mov    (%eax),%eax
c01034de:	89 04 24             	mov    %eax,(%esp)
c01034e1:	e8 1b f4 ff ff       	call   c0102901 <pte2page>
c01034e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01034e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01034ef:	75 0d                	jne    c01034fe <page_insert+0x6f>
            page_ref_dec(page);
c01034f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034f4:	89 04 24             	mov    %eax,(%esp)
c01034f7:	e8 8a f4 ff ff       	call   c0102986 <page_ref_dec>
c01034fc:	eb 19                	jmp    c0103517 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01034fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103501:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103505:	8b 45 10             	mov    0x10(%ebp),%eax
c0103508:	89 44 24 04          	mov    %eax,0x4(%esp)
c010350c:	8b 45 08             	mov    0x8(%ebp),%eax
c010350f:	89 04 24             	mov    %eax,(%esp)
c0103512:	e8 c4 fe ff ff       	call   c01033db <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010351a:	89 04 24             	mov    %eax,(%esp)
c010351d:	e8 26 f3 ff ff       	call   c0102848 <page2pa>
c0103522:	0b 45 14             	or     0x14(%ebp),%eax
c0103525:	83 c8 01             	or     $0x1,%eax
c0103528:	89 c2                	mov    %eax,%edx
c010352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010352d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010352f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103532:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103536:	8b 45 08             	mov    0x8(%ebp),%eax
c0103539:	89 04 24             	mov    %eax,(%esp)
c010353c:	e8 07 00 00 00       	call   c0103548 <tlb_invalidate>
    return 0;
c0103541:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103546:	c9                   	leave  
c0103547:	c3                   	ret    

c0103548 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103548:	55                   	push   %ebp
c0103549:	89 e5                	mov    %esp,%ebp
c010354b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010354e:	0f 20 d8             	mov    %cr3,%eax
c0103551:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103554:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103557:	8b 45 08             	mov    0x8(%ebp),%eax
c010355a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010355d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103564:	77 23                	ja     c0103589 <tlb_invalidate+0x41>
c0103566:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103569:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010356d:	c7 44 24 08 64 67 10 	movl   $0xc0106764,0x8(%esp)
c0103574:	c0 
c0103575:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c010357c:	00 
c010357d:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103584:	e8 60 ce ff ff       	call   c01003e9 <__panic>
c0103589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358c:	05 00 00 00 40       	add    $0x40000000,%eax
c0103591:	39 d0                	cmp    %edx,%eax
c0103593:	75 0c                	jne    c01035a1 <tlb_invalidate+0x59>
        invlpg((void *)la);
c0103595:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103598:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010359b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010359e:	0f 01 38             	invlpg (%eax)
    }
}
c01035a1:	90                   	nop
c01035a2:	c9                   	leave  
c01035a3:	c3                   	ret    

c01035a4 <check_alloc_page>:

static void
check_alloc_page(void) {
c01035a4:	55                   	push   %ebp
c01035a5:	89 e5                	mov    %esp,%ebp
c01035a7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01035aa:	a1 30 af 11 c0       	mov    0xc011af30,%eax
c01035af:	8b 40 18             	mov    0x18(%eax),%eax
c01035b2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01035b4:	c7 04 24 e8 67 10 c0 	movl   $0xc01067e8,(%esp)
c01035bb:	e8 d2 cc ff ff       	call   c0100292 <cprintf>
}
c01035c0:	90                   	nop
c01035c1:	c9                   	leave  
c01035c2:	c3                   	ret    

c01035c3 <check_pgdir>:

static void
check_pgdir(void) {
c01035c3:	55                   	push   %ebp
c01035c4:	89 e5                	mov    %esp,%ebp
c01035c6:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01035c9:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c01035ce:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01035d3:	76 24                	jbe    c01035f9 <check_pgdir+0x36>
c01035d5:	c7 44 24 0c 07 68 10 	movl   $0xc0106807,0xc(%esp)
c01035dc:	c0 
c01035dd:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c01035e4:	c0 
c01035e5:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01035ec:	00 
c01035ed:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01035f4:	e8 f0 cd ff ff       	call   c01003e9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01035f9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01035fe:	85 c0                	test   %eax,%eax
c0103600:	74 0e                	je     c0103610 <check_pgdir+0x4d>
c0103602:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103607:	25 ff 0f 00 00       	and    $0xfff,%eax
c010360c:	85 c0                	test   %eax,%eax
c010360e:	74 24                	je     c0103634 <check_pgdir+0x71>
c0103610:	c7 44 24 0c 24 68 10 	movl   $0xc0106824,0xc(%esp)
c0103617:	c0 
c0103618:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c010361f:	c0 
c0103620:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103627:	00 
c0103628:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c010362f:	e8 b5 cd ff ff       	call   c01003e9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103634:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103639:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103640:	00 
c0103641:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103648:	00 
c0103649:	89 04 24             	mov    %eax,(%esp)
c010364c:	e8 31 fd ff ff       	call   c0103382 <get_page>
c0103651:	85 c0                	test   %eax,%eax
c0103653:	74 24                	je     c0103679 <check_pgdir+0xb6>
c0103655:	c7 44 24 0c 5c 68 10 	movl   $0xc010685c,0xc(%esp)
c010365c:	c0 
c010365d:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103664:	c0 
c0103665:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c010366c:	00 
c010366d:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103674:	e8 70 cd ff ff       	call   c01003e9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103679:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103680:	e8 d7 f4 ff ff       	call   c0102b5c <alloc_pages>
c0103685:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103688:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010368d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103694:	00 
c0103695:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010369c:	00 
c010369d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01036a0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01036a4:	89 04 24             	mov    %eax,(%esp)
c01036a7:	e8 e3 fd ff ff       	call   c010348f <page_insert>
c01036ac:	85 c0                	test   %eax,%eax
c01036ae:	74 24                	je     c01036d4 <check_pgdir+0x111>
c01036b0:	c7 44 24 0c 84 68 10 	movl   $0xc0106884,0xc(%esp)
c01036b7:	c0 
c01036b8:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c01036bf:	c0 
c01036c0:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c01036c7:	00 
c01036c8:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01036cf:	e8 15 cd ff ff       	call   c01003e9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01036d4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01036d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036e0:	00 
c01036e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036e8:	00 
c01036e9:	89 04 24             	mov    %eax,(%esp)
c01036ec:	e8 23 fb ff ff       	call   c0103214 <get_pte>
c01036f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01036f8:	75 24                	jne    c010371e <check_pgdir+0x15b>
c01036fa:	c7 44 24 0c b0 68 10 	movl   $0xc01068b0,0xc(%esp)
c0103701:	c0 
c0103702:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103709:	c0 
c010370a:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103711:	00 
c0103712:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103719:	e8 cb cc ff ff       	call   c01003e9 <__panic>
    assert(pte2page(*ptep) == p1);
c010371e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103721:	8b 00                	mov    (%eax),%eax
c0103723:	89 04 24             	mov    %eax,(%esp)
c0103726:	e8 d6 f1 ff ff       	call   c0102901 <pte2page>
c010372b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010372e:	74 24                	je     c0103754 <check_pgdir+0x191>
c0103730:	c7 44 24 0c dd 68 10 	movl   $0xc01068dd,0xc(%esp)
c0103737:	c0 
c0103738:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c010373f:	c0 
c0103740:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103747:	00 
c0103748:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c010374f:	e8 95 cc ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p1) == 1);
c0103754:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103757:	89 04 24             	mov    %eax,(%esp)
c010375a:	e8 f8 f1 ff ff       	call   c0102957 <page_ref>
c010375f:	83 f8 01             	cmp    $0x1,%eax
c0103762:	74 24                	je     c0103788 <check_pgdir+0x1c5>
c0103764:	c7 44 24 0c f3 68 10 	movl   $0xc01068f3,0xc(%esp)
c010376b:	c0 
c010376c:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103773:	c0 
c0103774:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c010377b:	00 
c010377c:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103783:	e8 61 cc ff ff       	call   c01003e9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103788:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010378d:	8b 00                	mov    (%eax),%eax
c010378f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103794:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103797:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010379a:	c1 e8 0c             	shr    $0xc,%eax
c010379d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01037a0:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c01037a5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01037a8:	72 23                	jb     c01037cd <check_pgdir+0x20a>
c01037aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01037b1:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c01037b8:	c0 
c01037b9:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c01037c0:	00 
c01037c1:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01037c8:	e8 1c cc ff ff       	call   c01003e9 <__panic>
c01037cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037d0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037d5:	83 c0 04             	add    $0x4,%eax
c01037d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01037db:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01037e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037e7:	00 
c01037e8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01037ef:	00 
c01037f0:	89 04 24             	mov    %eax,(%esp)
c01037f3:	e8 1c fa ff ff       	call   c0103214 <get_pte>
c01037f8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01037fb:	74 24                	je     c0103821 <check_pgdir+0x25e>
c01037fd:	c7 44 24 0c 08 69 10 	movl   $0xc0106908,0xc(%esp)
c0103804:	c0 
c0103805:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c010380c:	c0 
c010380d:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103814:	00 
c0103815:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c010381c:	e8 c8 cb ff ff       	call   c01003e9 <__panic>

    p2 = alloc_page();
c0103821:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103828:	e8 2f f3 ff ff       	call   c0102b5c <alloc_pages>
c010382d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103830:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103835:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010383c:	00 
c010383d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103844:	00 
c0103845:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103848:	89 54 24 04          	mov    %edx,0x4(%esp)
c010384c:	89 04 24             	mov    %eax,(%esp)
c010384f:	e8 3b fc ff ff       	call   c010348f <page_insert>
c0103854:	85 c0                	test   %eax,%eax
c0103856:	74 24                	je     c010387c <check_pgdir+0x2b9>
c0103858:	c7 44 24 0c 30 69 10 	movl   $0xc0106930,0xc(%esp)
c010385f:	c0 
c0103860:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103867:	c0 
c0103868:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c010386f:	00 
c0103870:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103877:	e8 6d cb ff ff       	call   c01003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010387c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103881:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103888:	00 
c0103889:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103890:	00 
c0103891:	89 04 24             	mov    %eax,(%esp)
c0103894:	e8 7b f9 ff ff       	call   c0103214 <get_pte>
c0103899:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010389c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038a0:	75 24                	jne    c01038c6 <check_pgdir+0x303>
c01038a2:	c7 44 24 0c 68 69 10 	movl   $0xc0106968,0xc(%esp)
c01038a9:	c0 
c01038aa:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c01038b1:	c0 
c01038b2:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c01038b9:	00 
c01038ba:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01038c1:	e8 23 cb ff ff       	call   c01003e9 <__panic>
    assert(*ptep & PTE_U);
c01038c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038c9:	8b 00                	mov    (%eax),%eax
c01038cb:	83 e0 04             	and    $0x4,%eax
c01038ce:	85 c0                	test   %eax,%eax
c01038d0:	75 24                	jne    c01038f6 <check_pgdir+0x333>
c01038d2:	c7 44 24 0c 98 69 10 	movl   $0xc0106998,0xc(%esp)
c01038d9:	c0 
c01038da:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c01038e1:	c0 
c01038e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01038e9:	00 
c01038ea:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01038f1:	e8 f3 ca ff ff       	call   c01003e9 <__panic>
    assert(*ptep & PTE_W);
c01038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038f9:	8b 00                	mov    (%eax),%eax
c01038fb:	83 e0 02             	and    $0x2,%eax
c01038fe:	85 c0                	test   %eax,%eax
c0103900:	75 24                	jne    c0103926 <check_pgdir+0x363>
c0103902:	c7 44 24 0c a6 69 10 	movl   $0xc01069a6,0xc(%esp)
c0103909:	c0 
c010390a:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103911:	c0 
c0103912:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103919:	00 
c010391a:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103921:	e8 c3 ca ff ff       	call   c01003e9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103926:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010392b:	8b 00                	mov    (%eax),%eax
c010392d:	83 e0 04             	and    $0x4,%eax
c0103930:	85 c0                	test   %eax,%eax
c0103932:	75 24                	jne    c0103958 <check_pgdir+0x395>
c0103934:	c7 44 24 0c b4 69 10 	movl   $0xc01069b4,0xc(%esp)
c010393b:	c0 
c010393c:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103943:	c0 
c0103944:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c010394b:	00 
c010394c:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103953:	e8 91 ca ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 1);
c0103958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010395b:	89 04 24             	mov    %eax,(%esp)
c010395e:	e8 f4 ef ff ff       	call   c0102957 <page_ref>
c0103963:	83 f8 01             	cmp    $0x1,%eax
c0103966:	74 24                	je     c010398c <check_pgdir+0x3c9>
c0103968:	c7 44 24 0c ca 69 10 	movl   $0xc01069ca,0xc(%esp)
c010396f:	c0 
c0103970:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103977:	c0 
c0103978:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c010397f:	00 
c0103980:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103987:	e8 5d ca ff ff       	call   c01003e9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010398c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103991:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103998:	00 
c0103999:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01039a0:	00 
c01039a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01039a4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039a8:	89 04 24             	mov    %eax,(%esp)
c01039ab:	e8 df fa ff ff       	call   c010348f <page_insert>
c01039b0:	85 c0                	test   %eax,%eax
c01039b2:	74 24                	je     c01039d8 <check_pgdir+0x415>
c01039b4:	c7 44 24 0c dc 69 10 	movl   $0xc01069dc,0xc(%esp)
c01039bb:	c0 
c01039bc:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c01039c3:	c0 
c01039c4:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c01039cb:	00 
c01039cc:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c01039d3:	e8 11 ca ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p1) == 2);
c01039d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039db:	89 04 24             	mov    %eax,(%esp)
c01039de:	e8 74 ef ff ff       	call   c0102957 <page_ref>
c01039e3:	83 f8 02             	cmp    $0x2,%eax
c01039e6:	74 24                	je     c0103a0c <check_pgdir+0x449>
c01039e8:	c7 44 24 0c 08 6a 10 	movl   $0xc0106a08,0xc(%esp)
c01039ef:	c0 
c01039f0:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c01039f7:	c0 
c01039f8:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c01039ff:	00 
c0103a00:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103a07:	e8 dd c9 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 0);
c0103a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a0f:	89 04 24             	mov    %eax,(%esp)
c0103a12:	e8 40 ef ff ff       	call   c0102957 <page_ref>
c0103a17:	85 c0                	test   %eax,%eax
c0103a19:	74 24                	je     c0103a3f <check_pgdir+0x47c>
c0103a1b:	c7 44 24 0c 1a 6a 10 	movl   $0xc0106a1a,0xc(%esp)
c0103a22:	c0 
c0103a23:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103a2a:	c0 
c0103a2b:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103a32:	00 
c0103a33:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103a3a:	e8 aa c9 ff ff       	call   c01003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a3f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a44:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a4b:	00 
c0103a4c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a53:	00 
c0103a54:	89 04 24             	mov    %eax,(%esp)
c0103a57:	e8 b8 f7 ff ff       	call   c0103214 <get_pte>
c0103a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a63:	75 24                	jne    c0103a89 <check_pgdir+0x4c6>
c0103a65:	c7 44 24 0c 68 69 10 	movl   $0xc0106968,0xc(%esp)
c0103a6c:	c0 
c0103a6d:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103a74:	c0 
c0103a75:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0103a7c:	00 
c0103a7d:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103a84:	e8 60 c9 ff ff       	call   c01003e9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a8c:	8b 00                	mov    (%eax),%eax
c0103a8e:	89 04 24             	mov    %eax,(%esp)
c0103a91:	e8 6b ee ff ff       	call   c0102901 <pte2page>
c0103a96:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a99:	74 24                	je     c0103abf <check_pgdir+0x4fc>
c0103a9b:	c7 44 24 0c dd 68 10 	movl   $0xc01068dd,0xc(%esp)
c0103aa2:	c0 
c0103aa3:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103aaa:	c0 
c0103aab:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0103ab2:	00 
c0103ab3:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103aba:	e8 2a c9 ff ff       	call   c01003e9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ac2:	8b 00                	mov    (%eax),%eax
c0103ac4:	83 e0 04             	and    $0x4,%eax
c0103ac7:	85 c0                	test   %eax,%eax
c0103ac9:	74 24                	je     c0103aef <check_pgdir+0x52c>
c0103acb:	c7 44 24 0c 2c 6a 10 	movl   $0xc0106a2c,0xc(%esp)
c0103ad2:	c0 
c0103ad3:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103ada:	c0 
c0103adb:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0103ae2:	00 
c0103ae3:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103aea:	e8 fa c8 ff ff       	call   c01003e9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103aef:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103af4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103afb:	00 
c0103afc:	89 04 24             	mov    %eax,(%esp)
c0103aff:	e8 46 f9 ff ff       	call   c010344a <page_remove>
    assert(page_ref(p1) == 1);
c0103b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b07:	89 04 24             	mov    %eax,(%esp)
c0103b0a:	e8 48 ee ff ff       	call   c0102957 <page_ref>
c0103b0f:	83 f8 01             	cmp    $0x1,%eax
c0103b12:	74 24                	je     c0103b38 <check_pgdir+0x575>
c0103b14:	c7 44 24 0c f3 68 10 	movl   $0xc01068f3,0xc(%esp)
c0103b1b:	c0 
c0103b1c:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103b23:	c0 
c0103b24:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103b2b:	00 
c0103b2c:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103b33:	e8 b1 c8 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 0);
c0103b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b3b:	89 04 24             	mov    %eax,(%esp)
c0103b3e:	e8 14 ee ff ff       	call   c0102957 <page_ref>
c0103b43:	85 c0                	test   %eax,%eax
c0103b45:	74 24                	je     c0103b6b <check_pgdir+0x5a8>
c0103b47:	c7 44 24 0c 1a 6a 10 	movl   $0xc0106a1a,0xc(%esp)
c0103b4e:	c0 
c0103b4f:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103b56:	c0 
c0103b57:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103b5e:	00 
c0103b5f:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103b66:	e8 7e c8 ff ff       	call   c01003e9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103b6b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b70:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b77:	00 
c0103b78:	89 04 24             	mov    %eax,(%esp)
c0103b7b:	e8 ca f8 ff ff       	call   c010344a <page_remove>
    assert(page_ref(p1) == 0);
c0103b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b83:	89 04 24             	mov    %eax,(%esp)
c0103b86:	e8 cc ed ff ff       	call   c0102957 <page_ref>
c0103b8b:	85 c0                	test   %eax,%eax
c0103b8d:	74 24                	je     c0103bb3 <check_pgdir+0x5f0>
c0103b8f:	c7 44 24 0c 41 6a 10 	movl   $0xc0106a41,0xc(%esp)
c0103b96:	c0 
c0103b97:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103b9e:	c0 
c0103b9f:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0103ba6:	00 
c0103ba7:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103bae:	e8 36 c8 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 0);
c0103bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bb6:	89 04 24             	mov    %eax,(%esp)
c0103bb9:	e8 99 ed ff ff       	call   c0102957 <page_ref>
c0103bbe:	85 c0                	test   %eax,%eax
c0103bc0:	74 24                	je     c0103be6 <check_pgdir+0x623>
c0103bc2:	c7 44 24 0c 1a 6a 10 	movl   $0xc0106a1a,0xc(%esp)
c0103bc9:	c0 
c0103bca:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103bd1:	c0 
c0103bd2:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0103bd9:	00 
c0103bda:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103be1:	e8 03 c8 ff ff       	call   c01003e9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103be6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103beb:	8b 00                	mov    (%eax),%eax
c0103bed:	89 04 24             	mov    %eax,(%esp)
c0103bf0:	e8 4a ed ff ff       	call   c010293f <pde2page>
c0103bf5:	89 04 24             	mov    %eax,(%esp)
c0103bf8:	e8 5a ed ff ff       	call   c0102957 <page_ref>
c0103bfd:	83 f8 01             	cmp    $0x1,%eax
c0103c00:	74 24                	je     c0103c26 <check_pgdir+0x663>
c0103c02:	c7 44 24 0c 54 6a 10 	movl   $0xc0106a54,0xc(%esp)
c0103c09:	c0 
c0103c0a:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103c11:	c0 
c0103c12:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0103c19:	00 
c0103c1a:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103c21:	e8 c3 c7 ff ff       	call   c01003e9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103c26:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c2b:	8b 00                	mov    (%eax),%eax
c0103c2d:	89 04 24             	mov    %eax,(%esp)
c0103c30:	e8 0a ed ff ff       	call   c010293f <pde2page>
c0103c35:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c3c:	00 
c0103c3d:	89 04 24             	mov    %eax,(%esp)
c0103c40:	e8 4f ef ff ff       	call   c0102b94 <free_pages>
    boot_pgdir[0] = 0;
c0103c45:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103c50:	c7 04 24 7b 6a 10 c0 	movl   $0xc0106a7b,(%esp)
c0103c57:	e8 36 c6 ff ff       	call   c0100292 <cprintf>
}
c0103c5c:	90                   	nop
c0103c5d:	c9                   	leave  
c0103c5e:	c3                   	ret    

c0103c5f <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103c5f:	55                   	push   %ebp
c0103c60:	89 e5                	mov    %esp,%ebp
c0103c62:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c6c:	e9 ca 00 00 00       	jmp    c0103d3b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c7a:	c1 e8 0c             	shr    $0xc,%eax
c0103c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103c80:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0103c85:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103c88:	72 23                	jb     c0103cad <check_boot_pgdir+0x4e>
c0103c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c91:	c7 44 24 08 c0 66 10 	movl   $0xc01066c0,0x8(%esp)
c0103c98:	c0 
c0103c99:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0103ca0:	00 
c0103ca1:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103ca8:	e8 3c c7 ff ff       	call   c01003e9 <__panic>
c0103cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cb0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103cb5:	89 c2                	mov    %eax,%edx
c0103cb7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103cbc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103cc3:	00 
c0103cc4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cc8:	89 04 24             	mov    %eax,(%esp)
c0103ccb:	e8 44 f5 ff ff       	call   c0103214 <get_pte>
c0103cd0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103cd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103cd7:	75 24                	jne    c0103cfd <check_boot_pgdir+0x9e>
c0103cd9:	c7 44 24 0c 98 6a 10 	movl   $0xc0106a98,0xc(%esp)
c0103ce0:	c0 
c0103ce1:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103ce8:	c0 
c0103ce9:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0103cf0:	00 
c0103cf1:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103cf8:	e8 ec c6 ff ff       	call   c01003e9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103cfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d00:	8b 00                	mov    (%eax),%eax
c0103d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d07:	89 c2                	mov    %eax,%edx
c0103d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d0c:	39 c2                	cmp    %eax,%edx
c0103d0e:	74 24                	je     c0103d34 <check_boot_pgdir+0xd5>
c0103d10:	c7 44 24 0c d5 6a 10 	movl   $0xc0106ad5,0xc(%esp)
c0103d17:	c0 
c0103d18:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103d1f:	c0 
c0103d20:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0103d27:	00 
c0103d28:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103d2f:	e8 b5 c6 ff ff       	call   c01003e9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103d34:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d3e:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0103d43:	39 c2                	cmp    %eax,%edx
c0103d45:	0f 82 26 ff ff ff    	jb     c0103c71 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103d4b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d50:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103d55:	8b 00                	mov    (%eax),%eax
c0103d57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d5c:	89 c2                	mov    %eax,%edx
c0103d5e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d66:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103d6d:	77 23                	ja     c0103d92 <check_boot_pgdir+0x133>
c0103d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d72:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d76:	c7 44 24 08 64 67 10 	movl   $0xc0106764,0x8(%esp)
c0103d7d:	c0 
c0103d7e:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0103d85:	00 
c0103d86:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103d8d:	e8 57 c6 ff ff       	call   c01003e9 <__panic>
c0103d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d95:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d9a:	39 d0                	cmp    %edx,%eax
c0103d9c:	74 24                	je     c0103dc2 <check_boot_pgdir+0x163>
c0103d9e:	c7 44 24 0c ec 6a 10 	movl   $0xc0106aec,0xc(%esp)
c0103da5:	c0 
c0103da6:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103dad:	c0 
c0103dae:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0103db5:	00 
c0103db6:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103dbd:	e8 27 c6 ff ff       	call   c01003e9 <__panic>

    assert(boot_pgdir[0] == 0);
c0103dc2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103dc7:	8b 00                	mov    (%eax),%eax
c0103dc9:	85 c0                	test   %eax,%eax
c0103dcb:	74 24                	je     c0103df1 <check_boot_pgdir+0x192>
c0103dcd:	c7 44 24 0c 20 6b 10 	movl   $0xc0106b20,0xc(%esp)
c0103dd4:	c0 
c0103dd5:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103ddc:	c0 
c0103ddd:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0103de4:	00 
c0103de5:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103dec:	e8 f8 c5 ff ff       	call   c01003e9 <__panic>

    struct Page *p;
    p = alloc_page();
c0103df1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103df8:	e8 5f ed ff ff       	call   c0102b5c <alloc_pages>
c0103dfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103e00:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103e05:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103e0c:	00 
c0103e0d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103e14:	00 
c0103e15:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103e18:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e1c:	89 04 24             	mov    %eax,(%esp)
c0103e1f:	e8 6b f6 ff ff       	call   c010348f <page_insert>
c0103e24:	85 c0                	test   %eax,%eax
c0103e26:	74 24                	je     c0103e4c <check_boot_pgdir+0x1ed>
c0103e28:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c0103e2f:	c0 
c0103e30:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103e37:	c0 
c0103e38:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0103e3f:	00 
c0103e40:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103e47:	e8 9d c5 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p) == 1);
c0103e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e4f:	89 04 24             	mov    %eax,(%esp)
c0103e52:	e8 00 eb ff ff       	call   c0102957 <page_ref>
c0103e57:	83 f8 01             	cmp    $0x1,%eax
c0103e5a:	74 24                	je     c0103e80 <check_boot_pgdir+0x221>
c0103e5c:	c7 44 24 0c 62 6b 10 	movl   $0xc0106b62,0xc(%esp)
c0103e63:	c0 
c0103e64:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103e6b:	c0 
c0103e6c:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0103e73:	00 
c0103e74:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103e7b:	e8 69 c5 ff ff       	call   c01003e9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103e80:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103e85:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103e8c:	00 
c0103e8d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103e94:	00 
c0103e95:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103e98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e9c:	89 04 24             	mov    %eax,(%esp)
c0103e9f:	e8 eb f5 ff ff       	call   c010348f <page_insert>
c0103ea4:	85 c0                	test   %eax,%eax
c0103ea6:	74 24                	je     c0103ecc <check_boot_pgdir+0x26d>
c0103ea8:	c7 44 24 0c 74 6b 10 	movl   $0xc0106b74,0xc(%esp)
c0103eaf:	c0 
c0103eb0:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103eb7:	c0 
c0103eb8:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0103ebf:	00 
c0103ec0:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103ec7:	e8 1d c5 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p) == 2);
c0103ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ecf:	89 04 24             	mov    %eax,(%esp)
c0103ed2:	e8 80 ea ff ff       	call   c0102957 <page_ref>
c0103ed7:	83 f8 02             	cmp    $0x2,%eax
c0103eda:	74 24                	je     c0103f00 <check_boot_pgdir+0x2a1>
c0103edc:	c7 44 24 0c ab 6b 10 	movl   $0xc0106bab,0xc(%esp)
c0103ee3:	c0 
c0103ee4:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103eeb:	c0 
c0103eec:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0103ef3:	00 
c0103ef4:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103efb:	e8 e9 c4 ff ff       	call   c01003e9 <__panic>

    const char *str = "ucore: Hello world!!";
c0103f00:	c7 45 e8 bc 6b 10 c0 	movl   $0xc0106bbc,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f0e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f15:	e8 6f 15 00 00       	call   c0105489 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103f1a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0103f21:	00 
c0103f22:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f29:	e8 d2 15 00 00       	call   c0105500 <strcmp>
c0103f2e:	85 c0                	test   %eax,%eax
c0103f30:	74 24                	je     c0103f56 <check_boot_pgdir+0x2f7>
c0103f32:	c7 44 24 0c d4 6b 10 	movl   $0xc0106bd4,0xc(%esp)
c0103f39:	c0 
c0103f3a:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103f41:	c0 
c0103f42:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0103f49:	00 
c0103f4a:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103f51:	e8 93 c4 ff ff       	call   c01003e9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f59:	89 04 24             	mov    %eax,(%esp)
c0103f5c:	e8 4c e9 ff ff       	call   c01028ad <page2kva>
c0103f61:	05 00 01 00 00       	add    $0x100,%eax
c0103f66:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103f69:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f70:	e8 be 14 00 00       	call   c0105433 <strlen>
c0103f75:	85 c0                	test   %eax,%eax
c0103f77:	74 24                	je     c0103f9d <check_boot_pgdir+0x33e>
c0103f79:	c7 44 24 0c 0c 6c 10 	movl   $0xc0106c0c,0xc(%esp)
c0103f80:	c0 
c0103f81:	c7 44 24 08 ad 67 10 	movl   $0xc01067ad,0x8(%esp)
c0103f88:	c0 
c0103f89:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0103f90:	00 
c0103f91:	c7 04 24 88 67 10 c0 	movl   $0xc0106788,(%esp)
c0103f98:	e8 4c c4 ff ff       	call   c01003e9 <__panic>

    free_page(p);
c0103f9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fa4:	00 
c0103fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fa8:	89 04 24             	mov    %eax,(%esp)
c0103fab:	e8 e4 eb ff ff       	call   c0102b94 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0103fb0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103fb5:	8b 00                	mov    (%eax),%eax
c0103fb7:	89 04 24             	mov    %eax,(%esp)
c0103fba:	e8 80 e9 ff ff       	call   c010293f <pde2page>
c0103fbf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fc6:	00 
c0103fc7:	89 04 24             	mov    %eax,(%esp)
c0103fca:	e8 c5 eb ff ff       	call   c0102b94 <free_pages>
    boot_pgdir[0] = 0;
c0103fcf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103fd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103fda:	c7 04 24 30 6c 10 c0 	movl   $0xc0106c30,(%esp)
c0103fe1:	e8 ac c2 ff ff       	call   c0100292 <cprintf>
}
c0103fe6:	90                   	nop
c0103fe7:	c9                   	leave  
c0103fe8:	c3                   	ret    

c0103fe9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103fe9:	55                   	push   %ebp
c0103fea:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103fec:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fef:	83 e0 04             	and    $0x4,%eax
c0103ff2:	85 c0                	test   %eax,%eax
c0103ff4:	74 04                	je     c0103ffa <perm2str+0x11>
c0103ff6:	b0 75                	mov    $0x75,%al
c0103ff8:	eb 02                	jmp    c0103ffc <perm2str+0x13>
c0103ffa:	b0 2d                	mov    $0x2d,%al
c0103ffc:	a2 28 af 11 c0       	mov    %al,0xc011af28
    str[1] = 'r';
c0104001:	c6 05 29 af 11 c0 72 	movb   $0x72,0xc011af29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104008:	8b 45 08             	mov    0x8(%ebp),%eax
c010400b:	83 e0 02             	and    $0x2,%eax
c010400e:	85 c0                	test   %eax,%eax
c0104010:	74 04                	je     c0104016 <perm2str+0x2d>
c0104012:	b0 77                	mov    $0x77,%al
c0104014:	eb 02                	jmp    c0104018 <perm2str+0x2f>
c0104016:	b0 2d                	mov    $0x2d,%al
c0104018:	a2 2a af 11 c0       	mov    %al,0xc011af2a
    str[3] = '\0';
c010401d:	c6 05 2b af 11 c0 00 	movb   $0x0,0xc011af2b
    return str;
c0104024:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
}
c0104029:	5d                   	pop    %ebp
c010402a:	c3                   	ret    

c010402b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010402b:	55                   	push   %ebp
c010402c:	89 e5                	mov    %esp,%ebp
c010402e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104031:	8b 45 10             	mov    0x10(%ebp),%eax
c0104034:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104037:	72 0d                	jb     c0104046 <get_pgtable_items+0x1b>
        return 0;
c0104039:	b8 00 00 00 00       	mov    $0x0,%eax
c010403e:	e9 98 00 00 00       	jmp    c01040db <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104043:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104046:	8b 45 10             	mov    0x10(%ebp),%eax
c0104049:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010404c:	73 18                	jae    c0104066 <get_pgtable_items+0x3b>
c010404e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104051:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104058:	8b 45 14             	mov    0x14(%ebp),%eax
c010405b:	01 d0                	add    %edx,%eax
c010405d:	8b 00                	mov    (%eax),%eax
c010405f:	83 e0 01             	and    $0x1,%eax
c0104062:	85 c0                	test   %eax,%eax
c0104064:	74 dd                	je     c0104043 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104066:	8b 45 10             	mov    0x10(%ebp),%eax
c0104069:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010406c:	73 68                	jae    c01040d6 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c010406e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104072:	74 08                	je     c010407c <get_pgtable_items+0x51>
            *left_store = start;
c0104074:	8b 45 18             	mov    0x18(%ebp),%eax
c0104077:	8b 55 10             	mov    0x10(%ebp),%edx
c010407a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010407c:	8b 45 10             	mov    0x10(%ebp),%eax
c010407f:	8d 50 01             	lea    0x1(%eax),%edx
c0104082:	89 55 10             	mov    %edx,0x10(%ebp)
c0104085:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010408c:	8b 45 14             	mov    0x14(%ebp),%eax
c010408f:	01 d0                	add    %edx,%eax
c0104091:	8b 00                	mov    (%eax),%eax
c0104093:	83 e0 07             	and    $0x7,%eax
c0104096:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104099:	eb 03                	jmp    c010409e <get_pgtable_items+0x73>
            start ++;
c010409b:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010409e:	8b 45 10             	mov    0x10(%ebp),%eax
c01040a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01040a4:	73 1d                	jae    c01040c3 <get_pgtable_items+0x98>
c01040a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01040a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01040b0:	8b 45 14             	mov    0x14(%ebp),%eax
c01040b3:	01 d0                	add    %edx,%eax
c01040b5:	8b 00                	mov    (%eax),%eax
c01040b7:	83 e0 07             	and    $0x7,%eax
c01040ba:	89 c2                	mov    %eax,%edx
c01040bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040bf:	39 c2                	cmp    %eax,%edx
c01040c1:	74 d8                	je     c010409b <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c01040c3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01040c7:	74 08                	je     c01040d1 <get_pgtable_items+0xa6>
            *right_store = start;
c01040c9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01040cc:	8b 55 10             	mov    0x10(%ebp),%edx
c01040cf:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01040d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040d4:	eb 05                	jmp    c01040db <get_pgtable_items+0xb0>
    }
    return 0;
c01040d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01040db:	c9                   	leave  
c01040dc:	c3                   	ret    

c01040dd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01040dd:	55                   	push   %ebp
c01040de:	89 e5                	mov    %esp,%ebp
c01040e0:	57                   	push   %edi
c01040e1:	56                   	push   %esi
c01040e2:	53                   	push   %ebx
c01040e3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01040e6:	c7 04 24 50 6c 10 c0 	movl   $0xc0106c50,(%esp)
c01040ed:	e8 a0 c1 ff ff       	call   c0100292 <cprintf>
    size_t left, right = 0, perm;
c01040f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01040f9:	e9 fa 00 00 00       	jmp    c01041f8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01040fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104101:	89 04 24             	mov    %eax,(%esp)
c0104104:	e8 e0 fe ff ff       	call   c0103fe9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104109:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010410c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010410f:	29 d1                	sub    %edx,%ecx
c0104111:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104113:	89 d6                	mov    %edx,%esi
c0104115:	c1 e6 16             	shl    $0x16,%esi
c0104118:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010411b:	89 d3                	mov    %edx,%ebx
c010411d:	c1 e3 16             	shl    $0x16,%ebx
c0104120:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104123:	89 d1                	mov    %edx,%ecx
c0104125:	c1 e1 16             	shl    $0x16,%ecx
c0104128:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010412b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010412e:	29 d7                	sub    %edx,%edi
c0104130:	89 fa                	mov    %edi,%edx
c0104132:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104136:	89 74 24 10          	mov    %esi,0x10(%esp)
c010413a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010413e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104142:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104146:	c7 04 24 81 6c 10 c0 	movl   $0xc0106c81,(%esp)
c010414d:	e8 40 c1 ff ff       	call   c0100292 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0104152:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104155:	c1 e0 0a             	shl    $0xa,%eax
c0104158:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010415b:	eb 54                	jmp    c01041b1 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010415d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104160:	89 04 24             	mov    %eax,(%esp)
c0104163:	e8 81 fe ff ff       	call   c0103fe9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104168:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010416b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010416e:	29 d1                	sub    %edx,%ecx
c0104170:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104172:	89 d6                	mov    %edx,%esi
c0104174:	c1 e6 0c             	shl    $0xc,%esi
c0104177:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010417a:	89 d3                	mov    %edx,%ebx
c010417c:	c1 e3 0c             	shl    $0xc,%ebx
c010417f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104182:	89 d1                	mov    %edx,%ecx
c0104184:	c1 e1 0c             	shl    $0xc,%ecx
c0104187:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010418a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010418d:	29 d7                	sub    %edx,%edi
c010418f:	89 fa                	mov    %edi,%edx
c0104191:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104195:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104199:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010419d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01041a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041a5:	c7 04 24 a0 6c 10 c0 	movl   $0xc0106ca0,(%esp)
c01041ac:	e8 e1 c0 ff ff       	call   c0100292 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01041b1:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01041b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041bc:	89 d3                	mov    %edx,%ebx
c01041be:	c1 e3 0a             	shl    $0xa,%ebx
c01041c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041c4:	89 d1                	mov    %edx,%ecx
c01041c6:	c1 e1 0a             	shl    $0xa,%ecx
c01041c9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01041cc:	89 54 24 14          	mov    %edx,0x14(%esp)
c01041d0:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01041d3:	89 54 24 10          	mov    %edx,0x10(%esp)
c01041d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01041db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01041df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041e3:	89 0c 24             	mov    %ecx,(%esp)
c01041e6:	e8 40 fe ff ff       	call   c010402b <get_pgtable_items>
c01041eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041f2:	0f 85 65 ff ff ff    	jne    c010415d <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01041f8:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01041fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104200:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104203:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104207:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010420a:	89 54 24 10          	mov    %edx,0x10(%esp)
c010420e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104212:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104216:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010421d:	00 
c010421e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104225:	e8 01 fe ff ff       	call   c010402b <get_pgtable_items>
c010422a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010422d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104231:	0f 85 c7 fe ff ff    	jne    c01040fe <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104237:	c7 04 24 c4 6c 10 c0 	movl   $0xc0106cc4,(%esp)
c010423e:	e8 4f c0 ff ff       	call   c0100292 <cprintf>
}
c0104243:	90                   	nop
c0104244:	83 c4 4c             	add    $0x4c,%esp
c0104247:	5b                   	pop    %ebx
c0104248:	5e                   	pop    %esi
c0104249:	5f                   	pop    %edi
c010424a:	5d                   	pop    %ebp
c010424b:	c3                   	ret    

c010424c <page2ppn>:
page2ppn(struct Page *page) {
c010424c:	55                   	push   %ebp
c010424d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010424f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104252:	8b 15 38 af 11 c0    	mov    0xc011af38,%edx
c0104258:	29 d0                	sub    %edx,%eax
c010425a:	c1 f8 02             	sar    $0x2,%eax
c010425d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104263:	5d                   	pop    %ebp
c0104264:	c3                   	ret    

c0104265 <page2pa>:
page2pa(struct Page *page) {
c0104265:	55                   	push   %ebp
c0104266:	89 e5                	mov    %esp,%ebp
c0104268:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010426b:	8b 45 08             	mov    0x8(%ebp),%eax
c010426e:	89 04 24             	mov    %eax,(%esp)
c0104271:	e8 d6 ff ff ff       	call   c010424c <page2ppn>
c0104276:	c1 e0 0c             	shl    $0xc,%eax
}
c0104279:	c9                   	leave  
c010427a:	c3                   	ret    

c010427b <page_ref>:
page_ref(struct Page *page) {
c010427b:	55                   	push   %ebp
c010427c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010427e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104281:	8b 00                	mov    (%eax),%eax
}
c0104283:	5d                   	pop    %ebp
c0104284:	c3                   	ret    

c0104285 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104285:	55                   	push   %ebp
c0104286:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104288:	8b 45 08             	mov    0x8(%ebp),%eax
c010428b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010428e:	89 10                	mov    %edx,(%eax)
}
c0104290:	90                   	nop
c0104291:	5d                   	pop    %ebp
c0104292:	c3                   	ret    

c0104293 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104293:	55                   	push   %ebp
c0104294:	89 e5                	mov    %esp,%ebp
c0104296:	83 ec 10             	sub    $0x10,%esp
c0104299:	c7 45 fc 3c af 11 c0 	movl   $0xc011af3c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01042a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01042a6:	89 50 04             	mov    %edx,0x4(%eax)
c01042a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042ac:	8b 50 04             	mov    0x4(%eax),%edx
c01042af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042b2:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01042b4:	c7 05 44 af 11 c0 00 	movl   $0x0,0xc011af44
c01042bb:	00 00 00 
}
c01042be:	90                   	nop
c01042bf:	c9                   	leave  
c01042c0:	c3                   	ret    

c01042c1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01042c1:	55                   	push   %ebp
c01042c2:	89 e5                	mov    %esp,%ebp
c01042c4:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01042c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01042cb:	75 24                	jne    c01042f1 <default_init_memmap+0x30>
c01042cd:	c7 44 24 0c f8 6c 10 	movl   $0xc0106cf8,0xc(%esp)
c01042d4:	c0 
c01042d5:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01042dc:	c0 
c01042dd:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01042e4:	00 
c01042e5:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01042ec:	e8 f8 c0 ff ff       	call   c01003e9 <__panic>
    struct Page *p = base;
c01042f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01042f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01042f7:	eb 7d                	jmp    c0104376 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01042f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042fc:	83 c0 04             	add    $0x4,%eax
c01042ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104306:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104309:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010430c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010430f:	0f a3 10             	bt     %edx,(%eax)
c0104312:	19 c0                	sbb    %eax,%eax
c0104314:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104317:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010431b:	0f 95 c0             	setne  %al
c010431e:	0f b6 c0             	movzbl %al,%eax
c0104321:	85 c0                	test   %eax,%eax
c0104323:	75 24                	jne    c0104349 <default_init_memmap+0x88>
c0104325:	c7 44 24 0c 29 6d 10 	movl   $0xc0106d29,0xc(%esp)
c010432c:	c0 
c010432d:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104334:	c0 
c0104335:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010433c:	00 
c010433d:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104344:	e8 a0 c0 ff ff       	call   c01003e9 <__panic>
        p->flags = p->property = 0;
c0104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104353:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104356:	8b 50 08             	mov    0x8(%eax),%edx
c0104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010435c:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010435f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104366:	00 
c0104367:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010436a:	89 04 24             	mov    %eax,(%esp)
c010436d:	e8 13 ff ff ff       	call   c0104285 <set_page_ref>
    for (; p != base + n; p ++) {
c0104372:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104376:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104379:	89 d0                	mov    %edx,%eax
c010437b:	c1 e0 02             	shl    $0x2,%eax
c010437e:	01 d0                	add    %edx,%eax
c0104380:	c1 e0 02             	shl    $0x2,%eax
c0104383:	89 c2                	mov    %eax,%edx
c0104385:	8b 45 08             	mov    0x8(%ebp),%eax
c0104388:	01 d0                	add    %edx,%eax
c010438a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010438d:	0f 85 66 ff ff ff    	jne    c01042f9 <default_init_memmap+0x38>
    }
    base->property = n;
c0104393:	8b 45 08             	mov    0x8(%ebp),%eax
c0104396:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104399:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010439c:	8b 45 08             	mov    0x8(%ebp),%eax
c010439f:	83 c0 04             	add    $0x4,%eax
c01043a2:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01043a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01043ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043af:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01043b2:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01043b5:	8b 15 44 af 11 c0    	mov    0xc011af44,%edx
c01043bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043be:	01 d0                	add    %edx,%eax
c01043c0:	a3 44 af 11 c0       	mov    %eax,0xc011af44
    list_add(&free_list, &(base->page_link));
c01043c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c8:	83 c0 0c             	add    $0xc,%eax
c01043cb:	c7 45 e4 3c af 11 c0 	movl   $0xc011af3c,-0x1c(%ebp)
c01043d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01043d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01043db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043de:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01043e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043e4:	8b 40 04             	mov    0x4(%eax),%eax
c01043e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01043ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043f0:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01043f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01043f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01043f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043fc:	89 10                	mov    %edx,(%eax)
c01043fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104401:	8b 10                	mov    (%eax),%edx
c0104403:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104406:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104409:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010440c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010440f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104412:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104415:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104418:	89 10                	mov    %edx,(%eax)
}
c010441a:	90                   	nop
c010441b:	c9                   	leave  
c010441c:	c3                   	ret    

c010441d <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010441d:	55                   	push   %ebp
c010441e:	89 e5                	mov    %esp,%ebp
c0104420:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104423:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104427:	75 24                	jne    c010444d <default_alloc_pages+0x30>
c0104429:	c7 44 24 0c f8 6c 10 	movl   $0xc0106cf8,0xc(%esp)
c0104430:	c0 
c0104431:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104438:	c0 
c0104439:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0104440:	00 
c0104441:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104448:	e8 9c bf ff ff       	call   c01003e9 <__panic>
    if (n > nr_free) {
c010444d:	a1 44 af 11 c0       	mov    0xc011af44,%eax
c0104452:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104455:	76 0a                	jbe    c0104461 <default_alloc_pages+0x44>
        return NULL;
c0104457:	b8 00 00 00 00       	mov    $0x0,%eax
c010445c:	e9 51 01 00 00       	jmp    c01045b2 <default_alloc_pages+0x195>
    }
    struct Page *page = NULL;
c0104461:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104468:	c7 45 f0 3c af 11 c0 	movl   $0xc011af3c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010446f:	eb 1c                	jmp    c010448d <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0104471:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104474:	83 e8 0c             	sub    $0xc,%eax
c0104477:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c010447a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010447d:	8b 40 08             	mov    0x8(%eax),%eax
c0104480:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104483:	77 08                	ja     c010448d <default_alloc_pages+0x70>
            page = p;
c0104485:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104488:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010448b:	eb 18                	jmp    c01044a5 <default_alloc_pages+0x88>
c010448d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104490:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0104493:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104496:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104499:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010449c:	81 7d f0 3c af 11 c0 	cmpl   $0xc011af3c,-0x10(%ebp)
c01044a3:	75 cc                	jne    c0104471 <default_alloc_pages+0x54>
        }
    }
    
    if (page != NULL) { 
c01044a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044a9:	0f 84 00 01 00 00    	je     c01045af <default_alloc_pages+0x192>
        //页面在内存上是连续的
        for (struct Page *p=page;p!=page+n;++p) 
c01044af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01044b5:	eb 1d                	jmp    c01044d4 <default_alloc_pages+0xb7>
            ClearPageProperty(p); //标记页面为非空闲
c01044b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044ba:	83 c0 04             	add    $0x4,%eax
c01044bd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01044c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044cd:	0f b3 10             	btr    %edx,(%eax)
        for (struct Page *p=page;p!=page+n;++p) 
c01044d0:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c01044d4:	8b 55 08             	mov    0x8(%ebp),%edx
c01044d7:	89 d0                	mov    %edx,%eax
c01044d9:	c1 e0 02             	shl    $0x2,%eax
c01044dc:	01 d0                	add    %edx,%eax
c01044de:	c1 e0 02             	shl    $0x2,%eax
c01044e1:	89 c2                	mov    %eax,%edx
c01044e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e6:	01 d0                	add    %edx,%eax
c01044e8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01044eb:	75 ca                	jne    c01044b7 <default_alloc_pages+0x9a>
        //多余的内存组成新的空闲块，插入到链表中
        if (page->property > n) {
c01044ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f0:	8b 40 08             	mov    0x8(%eax),%eax
c01044f3:	39 45 08             	cmp    %eax,0x8(%ebp)
c01044f6:	73 7f                	jae    c0104577 <default_alloc_pages+0x15a>
            struct Page *p=page+n;
c01044f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01044fb:	89 d0                	mov    %edx,%eax
c01044fd:	c1 e0 02             	shl    $0x2,%eax
c0104500:	01 d0                	add    %edx,%eax
c0104502:	c1 e0 02             	shl    $0x2,%eax
c0104505:	89 c2                	mov    %eax,%edx
c0104507:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010450a:	01 d0                	add    %edx,%eax
c010450c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property=page->property-n;
c010450f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104512:	8b 40 08             	mov    0x8(%eax),%eax
c0104515:	2b 45 08             	sub    0x8(%ebp),%eax
c0104518:	89 c2                	mov    %eax,%edx
c010451a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010451d:	89 50 08             	mov    %edx,0x8(%eax)
            //在原先的链表节点后插入新的空闲块节点
            list_add(&(page->page_link),&(p->page_link));
c0104520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104523:	83 c0 0c             	add    $0xc,%eax
c0104526:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104529:	83 c2 0c             	add    $0xc,%edx
c010452c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010452f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104535:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0104538:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010453b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c010453e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104541:	8b 40 04             	mov    0x4(%eax),%eax
c0104544:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104547:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010454a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010454d:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104550:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c0104553:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104556:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104559:	89 10                	mov    %edx,(%eax)
c010455b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010455e:	8b 10                	mov    (%eax),%edx
c0104560:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104563:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104566:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104569:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010456c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010456f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104572:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104575:	89 10                	mov    %edx,(%eax)
        }
        //原来的空闲块已经不再空闲了，从链表中删除
        list_del(&(page->page_link));
c0104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010457a:	83 c0 0c             	add    $0xc,%eax
c010457d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104580:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104583:	8b 40 04             	mov    0x4(%eax),%eax
c0104586:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104589:	8b 12                	mov    (%edx),%edx
c010458b:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c010458e:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104591:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104594:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104597:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010459a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010459d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01045a0:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01045a2:	a1 44 af 11 c0       	mov    0xc011af44,%eax
c01045a7:	2b 45 08             	sub    0x8(%ebp),%eax
c01045aa:	a3 44 af 11 c0       	mov    %eax,0xc011af44
    }
    return page;
c01045af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01045b2:	c9                   	leave  
c01045b3:	c3                   	ret    

c01045b4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01045b4:	55                   	push   %ebp
c01045b5:	89 e5                	mov    %esp,%ebp
c01045b7:	81 ec 98 00 00 00    	sub    $0x98,%esp
 assert(n > 0);
c01045bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01045c1:	75 24                	jne    c01045e7 <default_free_pages+0x33>
c01045c3:	c7 44 24 0c f8 6c 10 	movl   $0xc0106cf8,0xc(%esp)
c01045ca:	c0 
c01045cb:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01045d2:	c0 
c01045d3:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01045da:	00 
c01045db:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01045e2:	e8 02 be ff ff       	call   c01003e9 <__panic>
    struct Page *p = base;
c01045e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01045ed:	e9 9d 00 00 00       	jmp    c010468f <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01045f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f5:	83 c0 04             	add    $0x4,%eax
c01045f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01045ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104602:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104605:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104608:	0f a3 10             	bt     %edx,(%eax)
c010460b:	19 c0                	sbb    %eax,%eax
c010460d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104614:	0f 95 c0             	setne  %al
c0104617:	0f b6 c0             	movzbl %al,%eax
c010461a:	85 c0                	test   %eax,%eax
c010461c:	75 2c                	jne    c010464a <default_free_pages+0x96>
c010461e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104621:	83 c0 04             	add    $0x4,%eax
c0104624:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010462b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010462e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104631:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104634:	0f a3 10             	bt     %edx,(%eax)
c0104637:	19 c0                	sbb    %eax,%eax
c0104639:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010463c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104640:	0f 95 c0             	setne  %al
c0104643:	0f b6 c0             	movzbl %al,%eax
c0104646:	85 c0                	test   %eax,%eax
c0104648:	74 24                	je     c010466e <default_free_pages+0xba>
c010464a:	c7 44 24 0c 3c 6d 10 	movl   $0xc0106d3c,0xc(%esp)
c0104651:	c0 
c0104652:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104659:	c0 
c010465a:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0104661:	00 
c0104662:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104669:	e8 7b bd ff ff       	call   c01003e9 <__panic>
        p->flags = 0;
c010466e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104678:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010467f:	00 
c0104680:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104683:	89 04 24             	mov    %eax,(%esp)
c0104686:	e8 fa fb ff ff       	call   c0104285 <set_page_ref>
    for (; p != base + n; p ++) {
c010468b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010468f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104692:	89 d0                	mov    %edx,%eax
c0104694:	c1 e0 02             	shl    $0x2,%eax
c0104697:	01 d0                	add    %edx,%eax
c0104699:	c1 e0 02             	shl    $0x2,%eax
c010469c:	89 c2                	mov    %eax,%edx
c010469e:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a1:	01 d0                	add    %edx,%eax
c01046a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046a6:	0f 85 46 ff ff ff    	jne    c01045f2 <default_free_pages+0x3e>
    }
    base->property = n;
c01046ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01046af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046b2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01046b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b8:	83 c0 04             	add    $0x4,%eax
c01046bb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01046c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01046c8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01046cb:	0f ab 10             	bts    %edx,(%eax)
c01046ce:	c7 45 d4 3c af 11 c0 	movl   $0xc011af3c,-0x2c(%ebp)
    return listelm->next;
c01046d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046d8:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01046db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01046de:	e9 08 01 00 00       	jmp    c01047eb <default_free_pages+0x237>
        p = le2page(le, page_link);
c01046e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e6:	83 e8 0c             	sub    $0xc,%eax
c01046e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01046f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01046f5:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01046f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c01046fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046fe:	8b 50 08             	mov    0x8(%eax),%edx
c0104701:	89 d0                	mov    %edx,%eax
c0104703:	c1 e0 02             	shl    $0x2,%eax
c0104706:	01 d0                	add    %edx,%eax
c0104708:	c1 e0 02             	shl    $0x2,%eax
c010470b:	89 c2                	mov    %eax,%edx
c010470d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104710:	01 d0                	add    %edx,%eax
c0104712:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104715:	75 5a                	jne    c0104771 <default_free_pages+0x1bd>
            base->property += p->property;
c0104717:	8b 45 08             	mov    0x8(%ebp),%eax
c010471a:	8b 50 08             	mov    0x8(%eax),%edx
c010471d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104720:	8b 40 08             	mov    0x8(%eax),%eax
c0104723:	01 c2                	add    %eax,%edx
c0104725:	8b 45 08             	mov    0x8(%ebp),%eax
c0104728:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010472b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472e:	83 c0 04             	add    $0x4,%eax
c0104731:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104738:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010473b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010473e:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104741:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104744:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104747:	83 c0 0c             	add    $0xc,%eax
c010474a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c010474d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104750:	8b 40 04             	mov    0x4(%eax),%eax
c0104753:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104756:	8b 12                	mov    (%edx),%edx
c0104758:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010475b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c010475e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104761:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104764:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104767:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010476a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010476d:	89 10                	mov    %edx,(%eax)
c010476f:	eb 7a                	jmp    c01047eb <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104774:	8b 50 08             	mov    0x8(%eax),%edx
c0104777:	89 d0                	mov    %edx,%eax
c0104779:	c1 e0 02             	shl    $0x2,%eax
c010477c:	01 d0                	add    %edx,%eax
c010477e:	c1 e0 02             	shl    $0x2,%eax
c0104781:	89 c2                	mov    %eax,%edx
c0104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104786:	01 d0                	add    %edx,%eax
c0104788:	39 45 08             	cmp    %eax,0x8(%ebp)
c010478b:	75 5e                	jne    c01047eb <default_free_pages+0x237>
            p->property += base->property;
c010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104790:	8b 50 08             	mov    0x8(%eax),%edx
c0104793:	8b 45 08             	mov    0x8(%ebp),%eax
c0104796:	8b 40 08             	mov    0x8(%eax),%eax
c0104799:	01 c2                	add    %eax,%edx
c010479b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01047a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a4:	83 c0 04             	add    $0x4,%eax
c01047a7:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c01047ae:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01047b1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01047b4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01047b7:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01047ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047bd:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01047c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c3:	83 c0 0c             	add    $0xc,%eax
c01047c6:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c01047c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01047cc:	8b 40 04             	mov    0x4(%eax),%eax
c01047cf:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01047d2:	8b 12                	mov    (%edx),%edx
c01047d4:	89 55 ac             	mov    %edx,-0x54(%ebp)
c01047d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c01047da:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01047dd:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01047e0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01047e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01047e6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01047e9:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c01047eb:	81 7d f0 3c af 11 c0 	cmpl   $0xc011af3c,-0x10(%ebp)
c01047f2:	0f 85 eb fe ff ff    	jne    c01046e3 <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c01047f8:	8b 15 44 af 11 c0    	mov    0xc011af44,%edx
c01047fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104801:	01 d0                	add    %edx,%eax
c0104803:	a3 44 af 11 c0       	mov    %eax,0xc011af44
c0104808:	c7 45 9c 3c af 11 c0 	movl   $0xc011af3c,-0x64(%ebp)
    return listelm->next;
c010480f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104812:	8b 40 04             	mov    0x4(%eax),%eax
    for (le=list_next(&free_list);le!=&free_list;le=list_next(le))
c0104815:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104818:	eb 2b                	jmp    c0104845 <default_free_pages+0x291>
        if (base + base->property <= p) //base后的第一个内存块
c010481a:	8b 45 08             	mov    0x8(%ebp),%eax
c010481d:	8b 50 08             	mov    0x8(%eax),%edx
c0104820:	89 d0                	mov    %edx,%eax
c0104822:	c1 e0 02             	shl    $0x2,%eax
c0104825:	01 d0                	add    %edx,%eax
c0104827:	c1 e0 02             	shl    $0x2,%eax
c010482a:	89 c2                	mov    %eax,%edx
c010482c:	8b 45 08             	mov    0x8(%ebp),%eax
c010482f:	01 d0                	add    %edx,%eax
c0104831:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104834:	73 1a                	jae    c0104850 <default_free_pages+0x29c>
c0104836:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104839:	89 45 98             	mov    %eax,-0x68(%ebp)
c010483c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010483f:	8b 40 04             	mov    0x4(%eax),%eax
    for (le=list_next(&free_list);le!=&free_list;le=list_next(le))
c0104842:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104845:	81 7d f0 3c af 11 c0 	cmpl   $0xc011af3c,-0x10(%ebp)
c010484c:	75 cc                	jne    c010481a <default_free_pages+0x266>
c010484e:	eb 01                	jmp    c0104851 <default_free_pages+0x29d>
            break;
c0104850:	90                   	nop
    //插入到base后第一个内存块之前
    list_add_before(le, &(base->page_link));
c0104851:	8b 45 08             	mov    0x8(%ebp),%eax
c0104854:	8d 50 0c             	lea    0xc(%eax),%edx
c0104857:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010485a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010485d:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104860:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104863:	8b 00                	mov    (%eax),%eax
c0104865:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104868:	89 55 8c             	mov    %edx,-0x74(%ebp)
c010486b:	89 45 88             	mov    %eax,-0x78(%ebp)
c010486e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104871:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104874:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104877:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010487a:	89 10                	mov    %edx,(%eax)
c010487c:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010487f:	8b 10                	mov    (%eax),%edx
c0104881:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104884:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104887:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010488a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010488d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104890:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104893:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104896:	89 10                	mov    %edx,(%eax)
} 
c0104898:	90                   	nop
c0104899:	c9                   	leave  
c010489a:	c3                   	ret    

c010489b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010489b:	55                   	push   %ebp
c010489c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010489e:	a1 44 af 11 c0       	mov    0xc011af44,%eax
}
c01048a3:	5d                   	pop    %ebp
c01048a4:	c3                   	ret    

c01048a5 <basic_check>:

static void
basic_check(void) {
c01048a5:	55                   	push   %ebp
c01048a6:	89 e5                	mov    %esp,%ebp
c01048a8:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01048ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01048be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048c5:	e8 92 e2 ff ff       	call   c0102b5c <alloc_pages>
c01048ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01048d1:	75 24                	jne    c01048f7 <basic_check+0x52>
c01048d3:	c7 44 24 0c 61 6d 10 	movl   $0xc0106d61,0xc(%esp)
c01048da:	c0 
c01048db:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01048e2:	c0 
c01048e3:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c01048ea:	00 
c01048eb:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01048f2:	e8 f2 ba ff ff       	call   c01003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01048f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048fe:	e8 59 e2 ff ff       	call   c0102b5c <alloc_pages>
c0104903:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010490a:	75 24                	jne    c0104930 <basic_check+0x8b>
c010490c:	c7 44 24 0c 7d 6d 10 	movl   $0xc0106d7d,0xc(%esp)
c0104913:	c0 
c0104914:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010491b:	c0 
c010491c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0104923:	00 
c0104924:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010492b:	e8 b9 ba ff ff       	call   c01003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104930:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104937:	e8 20 e2 ff ff       	call   c0102b5c <alloc_pages>
c010493c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010493f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104943:	75 24                	jne    c0104969 <basic_check+0xc4>
c0104945:	c7 44 24 0c 99 6d 10 	movl   $0xc0106d99,0xc(%esp)
c010494c:	c0 
c010494d:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104954:	c0 
c0104955:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c010495c:	00 
c010495d:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104964:	e8 80 ba ff ff       	call   c01003e9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104969:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010496c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010496f:	74 10                	je     c0104981 <basic_check+0xdc>
c0104971:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104974:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104977:	74 08                	je     c0104981 <basic_check+0xdc>
c0104979:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010497c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010497f:	75 24                	jne    c01049a5 <basic_check+0x100>
c0104981:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104988:	c0 
c0104989:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104990:	c0 
c0104991:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104998:	00 
c0104999:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01049a0:	e8 44 ba ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01049a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049a8:	89 04 24             	mov    %eax,(%esp)
c01049ab:	e8 cb f8 ff ff       	call   c010427b <page_ref>
c01049b0:	85 c0                	test   %eax,%eax
c01049b2:	75 1e                	jne    c01049d2 <basic_check+0x12d>
c01049b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049b7:	89 04 24             	mov    %eax,(%esp)
c01049ba:	e8 bc f8 ff ff       	call   c010427b <page_ref>
c01049bf:	85 c0                	test   %eax,%eax
c01049c1:	75 0f                	jne    c01049d2 <basic_check+0x12d>
c01049c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c6:	89 04 24             	mov    %eax,(%esp)
c01049c9:	e8 ad f8 ff ff       	call   c010427b <page_ref>
c01049ce:	85 c0                	test   %eax,%eax
c01049d0:	74 24                	je     c01049f6 <basic_check+0x151>
c01049d2:	c7 44 24 0c dc 6d 10 	movl   $0xc0106ddc,0xc(%esp)
c01049d9:	c0 
c01049da:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01049e1:	c0 
c01049e2:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01049e9:	00 
c01049ea:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01049f1:	e8 f3 b9 ff ff       	call   c01003e9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01049f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049f9:	89 04 24             	mov    %eax,(%esp)
c01049fc:	e8 64 f8 ff ff       	call   c0104265 <page2pa>
c0104a01:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c0104a07:	c1 e2 0c             	shl    $0xc,%edx
c0104a0a:	39 d0                	cmp    %edx,%eax
c0104a0c:	72 24                	jb     c0104a32 <basic_check+0x18d>
c0104a0e:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c0104a15:	c0 
c0104a16:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104a1d:	c0 
c0104a1e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104a25:	00 
c0104a26:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104a2d:	e8 b7 b9 ff ff       	call   c01003e9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a35:	89 04 24             	mov    %eax,(%esp)
c0104a38:	e8 28 f8 ff ff       	call   c0104265 <page2pa>
c0104a3d:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c0104a43:	c1 e2 0c             	shl    $0xc,%edx
c0104a46:	39 d0                	cmp    %edx,%eax
c0104a48:	72 24                	jb     c0104a6e <basic_check+0x1c9>
c0104a4a:	c7 44 24 0c 35 6e 10 	movl   $0xc0106e35,0xc(%esp)
c0104a51:	c0 
c0104a52:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104a59:	c0 
c0104a5a:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104a61:	00 
c0104a62:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104a69:	e8 7b b9 ff ff       	call   c01003e9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a71:	89 04 24             	mov    %eax,(%esp)
c0104a74:	e8 ec f7 ff ff       	call   c0104265 <page2pa>
c0104a79:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c0104a7f:	c1 e2 0c             	shl    $0xc,%edx
c0104a82:	39 d0                	cmp    %edx,%eax
c0104a84:	72 24                	jb     c0104aaa <basic_check+0x205>
c0104a86:	c7 44 24 0c 52 6e 10 	movl   $0xc0106e52,0xc(%esp)
c0104a8d:	c0 
c0104a8e:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104a95:	c0 
c0104a96:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0104a9d:	00 
c0104a9e:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104aa5:	e8 3f b9 ff ff       	call   c01003e9 <__panic>

    list_entry_t free_list_store = free_list;
c0104aaa:	a1 3c af 11 c0       	mov    0xc011af3c,%eax
c0104aaf:	8b 15 40 af 11 c0    	mov    0xc011af40,%edx
c0104ab5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ab8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104abb:	c7 45 dc 3c af 11 c0 	movl   $0xc011af3c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104ac2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ac5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ac8:	89 50 04             	mov    %edx,0x4(%eax)
c0104acb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ace:	8b 50 04             	mov    0x4(%eax),%edx
c0104ad1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ad4:	89 10                	mov    %edx,(%eax)
c0104ad6:	c7 45 e0 3c af 11 c0 	movl   $0xc011af3c,-0x20(%ebp)
    return list->next == list;
c0104add:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ae0:	8b 40 04             	mov    0x4(%eax),%eax
c0104ae3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104ae6:	0f 94 c0             	sete   %al
c0104ae9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104aec:	85 c0                	test   %eax,%eax
c0104aee:	75 24                	jne    c0104b14 <basic_check+0x26f>
c0104af0:	c7 44 24 0c 6f 6e 10 	movl   $0xc0106e6f,0xc(%esp)
c0104af7:	c0 
c0104af8:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104aff:	c0 
c0104b00:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0104b07:	00 
c0104b08:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104b0f:	e8 d5 b8 ff ff       	call   c01003e9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104b14:	a1 44 af 11 c0       	mov    0xc011af44,%eax
c0104b19:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104b1c:	c7 05 44 af 11 c0 00 	movl   $0x0,0xc011af44
c0104b23:	00 00 00 

    assert(alloc_page() == NULL);
c0104b26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b2d:	e8 2a e0 ff ff       	call   c0102b5c <alloc_pages>
c0104b32:	85 c0                	test   %eax,%eax
c0104b34:	74 24                	je     c0104b5a <basic_check+0x2b5>
c0104b36:	c7 44 24 0c 86 6e 10 	movl   $0xc0106e86,0xc(%esp)
c0104b3d:	c0 
c0104b3e:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104b45:	c0 
c0104b46:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104b4d:	00 
c0104b4e:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104b55:	e8 8f b8 ff ff       	call   c01003e9 <__panic>

    free_page(p0);
c0104b5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b61:	00 
c0104b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b65:	89 04 24             	mov    %eax,(%esp)
c0104b68:	e8 27 e0 ff ff       	call   c0102b94 <free_pages>
    free_page(p1);
c0104b6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b74:	00 
c0104b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b78:	89 04 24             	mov    %eax,(%esp)
c0104b7b:	e8 14 e0 ff ff       	call   c0102b94 <free_pages>
    free_page(p2);
c0104b80:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104b87:	00 
c0104b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b8b:	89 04 24             	mov    %eax,(%esp)
c0104b8e:	e8 01 e0 ff ff       	call   c0102b94 <free_pages>
    assert(nr_free == 3);
c0104b93:	a1 44 af 11 c0       	mov    0xc011af44,%eax
c0104b98:	83 f8 03             	cmp    $0x3,%eax
c0104b9b:	74 24                	je     c0104bc1 <basic_check+0x31c>
c0104b9d:	c7 44 24 0c 9b 6e 10 	movl   $0xc0106e9b,0xc(%esp)
c0104ba4:	c0 
c0104ba5:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104bac:	c0 
c0104bad:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0104bb4:	00 
c0104bb5:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104bbc:	e8 28 b8 ff ff       	call   c01003e9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104bc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bc8:	e8 8f df ff ff       	call   c0102b5c <alloc_pages>
c0104bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104bd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104bd4:	75 24                	jne    c0104bfa <basic_check+0x355>
c0104bd6:	c7 44 24 0c 61 6d 10 	movl   $0xc0106d61,0xc(%esp)
c0104bdd:	c0 
c0104bde:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104be5:	c0 
c0104be6:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104bed:	00 
c0104bee:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104bf5:	e8 ef b7 ff ff       	call   c01003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104bfa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c01:	e8 56 df ff ff       	call   c0102b5c <alloc_pages>
c0104c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c0d:	75 24                	jne    c0104c33 <basic_check+0x38e>
c0104c0f:	c7 44 24 0c 7d 6d 10 	movl   $0xc0106d7d,0xc(%esp)
c0104c16:	c0 
c0104c17:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104c1e:	c0 
c0104c1f:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104c26:	00 
c0104c27:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104c2e:	e8 b6 b7 ff ff       	call   c01003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104c33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c3a:	e8 1d df ff ff       	call   c0102b5c <alloc_pages>
c0104c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c46:	75 24                	jne    c0104c6c <basic_check+0x3c7>
c0104c48:	c7 44 24 0c 99 6d 10 	movl   $0xc0106d99,0xc(%esp)
c0104c4f:	c0 
c0104c50:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104c57:	c0 
c0104c58:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0104c5f:	00 
c0104c60:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104c67:	e8 7d b7 ff ff       	call   c01003e9 <__panic>

    assert(alloc_page() == NULL);
c0104c6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c73:	e8 e4 de ff ff       	call   c0102b5c <alloc_pages>
c0104c78:	85 c0                	test   %eax,%eax
c0104c7a:	74 24                	je     c0104ca0 <basic_check+0x3fb>
c0104c7c:	c7 44 24 0c 86 6e 10 	movl   $0xc0106e86,0xc(%esp)
c0104c83:	c0 
c0104c84:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104c8b:	c0 
c0104c8c:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0104c93:	00 
c0104c94:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104c9b:	e8 49 b7 ff ff       	call   c01003e9 <__panic>

    free_page(p0);
c0104ca0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ca7:	00 
c0104ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cab:	89 04 24             	mov    %eax,(%esp)
c0104cae:	e8 e1 de ff ff       	call   c0102b94 <free_pages>
c0104cb3:	c7 45 d8 3c af 11 c0 	movl   $0xc011af3c,-0x28(%ebp)
c0104cba:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104cbd:	8b 40 04             	mov    0x4(%eax),%eax
c0104cc0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104cc3:	0f 94 c0             	sete   %al
c0104cc6:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104cc9:	85 c0                	test   %eax,%eax
c0104ccb:	74 24                	je     c0104cf1 <basic_check+0x44c>
c0104ccd:	c7 44 24 0c a8 6e 10 	movl   $0xc0106ea8,0xc(%esp)
c0104cd4:	c0 
c0104cd5:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104cdc:	c0 
c0104cdd:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104ce4:	00 
c0104ce5:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104cec:	e8 f8 b6 ff ff       	call   c01003e9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104cf1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cf8:	e8 5f de ff ff       	call   c0102b5c <alloc_pages>
c0104cfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104d00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104d06:	74 24                	je     c0104d2c <basic_check+0x487>
c0104d08:	c7 44 24 0c c0 6e 10 	movl   $0xc0106ec0,0xc(%esp)
c0104d0f:	c0 
c0104d10:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104d17:	c0 
c0104d18:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0104d1f:	00 
c0104d20:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104d27:	e8 bd b6 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c0104d2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d33:	e8 24 de ff ff       	call   c0102b5c <alloc_pages>
c0104d38:	85 c0                	test   %eax,%eax
c0104d3a:	74 24                	je     c0104d60 <basic_check+0x4bb>
c0104d3c:	c7 44 24 0c 86 6e 10 	movl   $0xc0106e86,0xc(%esp)
c0104d43:	c0 
c0104d44:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104d4b:	c0 
c0104d4c:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104d53:	00 
c0104d54:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104d5b:	e8 89 b6 ff ff       	call   c01003e9 <__panic>

    assert(nr_free == 0);
c0104d60:	a1 44 af 11 c0       	mov    0xc011af44,%eax
c0104d65:	85 c0                	test   %eax,%eax
c0104d67:	74 24                	je     c0104d8d <basic_check+0x4e8>
c0104d69:	c7 44 24 0c d9 6e 10 	movl   $0xc0106ed9,0xc(%esp)
c0104d70:	c0 
c0104d71:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104d78:	c0 
c0104d79:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0104d80:	00 
c0104d81:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104d88:	e8 5c b6 ff ff       	call   c01003e9 <__panic>
    free_list = free_list_store;
c0104d8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104d93:	a3 3c af 11 c0       	mov    %eax,0xc011af3c
c0104d98:	89 15 40 af 11 c0    	mov    %edx,0xc011af40
    nr_free = nr_free_store;
c0104d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104da1:	a3 44 af 11 c0       	mov    %eax,0xc011af44

    free_page(p);
c0104da6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104dad:	00 
c0104dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104db1:	89 04 24             	mov    %eax,(%esp)
c0104db4:	e8 db dd ff ff       	call   c0102b94 <free_pages>
    free_page(p1);
c0104db9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104dc0:	00 
c0104dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dc4:	89 04 24             	mov    %eax,(%esp)
c0104dc7:	e8 c8 dd ff ff       	call   c0102b94 <free_pages>
    free_page(p2);
c0104dcc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104dd3:	00 
c0104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd7:	89 04 24             	mov    %eax,(%esp)
c0104dda:	e8 b5 dd ff ff       	call   c0102b94 <free_pages>
}
c0104ddf:	90                   	nop
c0104de0:	c9                   	leave  
c0104de1:	c3                   	ret    

c0104de2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104de2:	55                   	push   %ebp
c0104de3:	89 e5                	mov    %esp,%ebp
c0104de5:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0104deb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104df2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104df9:	c7 45 ec 3c af 11 c0 	movl   $0xc011af3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104e00:	eb 6a                	jmp    c0104e6c <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0104e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e05:	83 e8 0c             	sub    $0xc,%eax
c0104e08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104e0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104e0e:	83 c0 04             	add    $0x4,%eax
c0104e11:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104e18:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104e1e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104e21:	0f a3 10             	bt     %edx,(%eax)
c0104e24:	19 c0                	sbb    %eax,%eax
c0104e26:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104e29:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104e2d:	0f 95 c0             	setne  %al
c0104e30:	0f b6 c0             	movzbl %al,%eax
c0104e33:	85 c0                	test   %eax,%eax
c0104e35:	75 24                	jne    c0104e5b <default_check+0x79>
c0104e37:	c7 44 24 0c e6 6e 10 	movl   $0xc0106ee6,0xc(%esp)
c0104e3e:	c0 
c0104e3f:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104e46:	c0 
c0104e47:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104e4e:	00 
c0104e4f:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104e56:	e8 8e b5 ff ff       	call   c01003e9 <__panic>
        count ++, total += p->property;
c0104e5b:	ff 45 f4             	incl   -0xc(%ebp)
c0104e5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104e61:	8b 50 08             	mov    0x8(%eax),%edx
c0104e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e67:	01 d0                	add    %edx,%eax
c0104e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e6f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104e72:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e75:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e7b:	81 7d ec 3c af 11 c0 	cmpl   $0xc011af3c,-0x14(%ebp)
c0104e82:	0f 85 7a ff ff ff    	jne    c0104e02 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0104e88:	e8 3a dd ff ff       	call   c0102bc7 <nr_free_pages>
c0104e8d:	89 c2                	mov    %eax,%edx
c0104e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e92:	39 c2                	cmp    %eax,%edx
c0104e94:	74 24                	je     c0104eba <default_check+0xd8>
c0104e96:	c7 44 24 0c f6 6e 10 	movl   $0xc0106ef6,0xc(%esp)
c0104e9d:	c0 
c0104e9e:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104ea5:	c0 
c0104ea6:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104ead:	00 
c0104eae:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104eb5:	e8 2f b5 ff ff       	call   c01003e9 <__panic>

    basic_check();
c0104eba:	e8 e6 f9 ff ff       	call   c01048a5 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104ebf:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104ec6:	e8 91 dc ff ff       	call   c0102b5c <alloc_pages>
c0104ecb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104ece:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ed2:	75 24                	jne    c0104ef8 <default_check+0x116>
c0104ed4:	c7 44 24 0c 0f 6f 10 	movl   $0xc0106f0f,0xc(%esp)
c0104edb:	c0 
c0104edc:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104ee3:	c0 
c0104ee4:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104eeb:	00 
c0104eec:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104ef3:	e8 f1 b4 ff ff       	call   c01003e9 <__panic>
    assert(!PageProperty(p0));
c0104ef8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104efb:	83 c0 04             	add    $0x4,%eax
c0104efe:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104f05:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f08:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104f0b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104f0e:	0f a3 10             	bt     %edx,(%eax)
c0104f11:	19 c0                	sbb    %eax,%eax
c0104f13:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104f16:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104f1a:	0f 95 c0             	setne  %al
c0104f1d:	0f b6 c0             	movzbl %al,%eax
c0104f20:	85 c0                	test   %eax,%eax
c0104f22:	74 24                	je     c0104f48 <default_check+0x166>
c0104f24:	c7 44 24 0c 1a 6f 10 	movl   $0xc0106f1a,0xc(%esp)
c0104f2b:	c0 
c0104f2c:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104f33:	c0 
c0104f34:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0104f3b:	00 
c0104f3c:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104f43:	e8 a1 b4 ff ff       	call   c01003e9 <__panic>

    list_entry_t free_list_store = free_list;
c0104f48:	a1 3c af 11 c0       	mov    0xc011af3c,%eax
c0104f4d:	8b 15 40 af 11 c0    	mov    0xc011af40,%edx
c0104f53:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104f56:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104f59:	c7 45 b0 3c af 11 c0 	movl   $0xc011af3c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104f60:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f63:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104f66:	89 50 04             	mov    %edx,0x4(%eax)
c0104f69:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f6c:	8b 50 04             	mov    0x4(%eax),%edx
c0104f6f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f72:	89 10                	mov    %edx,(%eax)
c0104f74:	c7 45 b4 3c af 11 c0 	movl   $0xc011af3c,-0x4c(%ebp)
    return list->next == list;
c0104f7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104f7e:	8b 40 04             	mov    0x4(%eax),%eax
c0104f81:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104f84:	0f 94 c0             	sete   %al
c0104f87:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104f8a:	85 c0                	test   %eax,%eax
c0104f8c:	75 24                	jne    c0104fb2 <default_check+0x1d0>
c0104f8e:	c7 44 24 0c 6f 6e 10 	movl   $0xc0106e6f,0xc(%esp)
c0104f95:	c0 
c0104f96:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104f9d:	c0 
c0104f9e:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104fa5:	00 
c0104fa6:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104fad:	e8 37 b4 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c0104fb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fb9:	e8 9e db ff ff       	call   c0102b5c <alloc_pages>
c0104fbe:	85 c0                	test   %eax,%eax
c0104fc0:	74 24                	je     c0104fe6 <default_check+0x204>
c0104fc2:	c7 44 24 0c 86 6e 10 	movl   $0xc0106e86,0xc(%esp)
c0104fc9:	c0 
c0104fca:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0104fd1:	c0 
c0104fd2:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0104fd9:	00 
c0104fda:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0104fe1:	e8 03 b4 ff ff       	call   c01003e9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104fe6:	a1 44 af 11 c0       	mov    0xc011af44,%eax
c0104feb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104fee:	c7 05 44 af 11 c0 00 	movl   $0x0,0xc011af44
c0104ff5:	00 00 00 

    free_pages(p0 + 2, 3);
c0104ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ffb:	83 c0 28             	add    $0x28,%eax
c0104ffe:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105005:	00 
c0105006:	89 04 24             	mov    %eax,(%esp)
c0105009:	e8 86 db ff ff       	call   c0102b94 <free_pages>
    assert(alloc_pages(4) == NULL);
c010500e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0105015:	e8 42 db ff ff       	call   c0102b5c <alloc_pages>
c010501a:	85 c0                	test   %eax,%eax
c010501c:	74 24                	je     c0105042 <default_check+0x260>
c010501e:	c7 44 24 0c 2c 6f 10 	movl   $0xc0106f2c,0xc(%esp)
c0105025:	c0 
c0105026:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010502d:	c0 
c010502e:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0105035:	00 
c0105036:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010503d:	e8 a7 b3 ff ff       	call   c01003e9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105042:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105045:	83 c0 28             	add    $0x28,%eax
c0105048:	83 c0 04             	add    $0x4,%eax
c010504b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105052:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105055:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105058:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010505b:	0f a3 10             	bt     %edx,(%eax)
c010505e:	19 c0                	sbb    %eax,%eax
c0105060:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105063:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105067:	0f 95 c0             	setne  %al
c010506a:	0f b6 c0             	movzbl %al,%eax
c010506d:	85 c0                	test   %eax,%eax
c010506f:	74 0e                	je     c010507f <default_check+0x29d>
c0105071:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105074:	83 c0 28             	add    $0x28,%eax
c0105077:	8b 40 08             	mov    0x8(%eax),%eax
c010507a:	83 f8 03             	cmp    $0x3,%eax
c010507d:	74 24                	je     c01050a3 <default_check+0x2c1>
c010507f:	c7 44 24 0c 44 6f 10 	movl   $0xc0106f44,0xc(%esp)
c0105086:	c0 
c0105087:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010508e:	c0 
c010508f:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0105096:	00 
c0105097:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010509e:	e8 46 b3 ff ff       	call   c01003e9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01050a3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01050aa:	e8 ad da ff ff       	call   c0102b5c <alloc_pages>
c01050af:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01050b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01050b6:	75 24                	jne    c01050dc <default_check+0x2fa>
c01050b8:	c7 44 24 0c 70 6f 10 	movl   $0xc0106f70,0xc(%esp)
c01050bf:	c0 
c01050c0:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01050c7:	c0 
c01050c8:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01050cf:	00 
c01050d0:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01050d7:	e8 0d b3 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c01050dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050e3:	e8 74 da ff ff       	call   c0102b5c <alloc_pages>
c01050e8:	85 c0                	test   %eax,%eax
c01050ea:	74 24                	je     c0105110 <default_check+0x32e>
c01050ec:	c7 44 24 0c 86 6e 10 	movl   $0xc0106e86,0xc(%esp)
c01050f3:	c0 
c01050f4:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01050fb:	c0 
c01050fc:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0105103:	00 
c0105104:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010510b:	e8 d9 b2 ff ff       	call   c01003e9 <__panic>
    assert(p0 + 2 == p1);
c0105110:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105113:	83 c0 28             	add    $0x28,%eax
c0105116:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105119:	74 24                	je     c010513f <default_check+0x35d>
c010511b:	c7 44 24 0c 8e 6f 10 	movl   $0xc0106f8e,0xc(%esp)
c0105122:	c0 
c0105123:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010512a:	c0 
c010512b:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0105132:	00 
c0105133:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010513a:	e8 aa b2 ff ff       	call   c01003e9 <__panic>

    p2 = p0 + 1;
c010513f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105142:	83 c0 14             	add    $0x14,%eax
c0105145:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0105148:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010514f:	00 
c0105150:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105153:	89 04 24             	mov    %eax,(%esp)
c0105156:	e8 39 da ff ff       	call   c0102b94 <free_pages>
    free_pages(p1, 3);
c010515b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105162:	00 
c0105163:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105166:	89 04 24             	mov    %eax,(%esp)
c0105169:	e8 26 da ff ff       	call   c0102b94 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010516e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105171:	83 c0 04             	add    $0x4,%eax
c0105174:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010517b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010517e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105181:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105184:	0f a3 10             	bt     %edx,(%eax)
c0105187:	19 c0                	sbb    %eax,%eax
c0105189:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010518c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105190:	0f 95 c0             	setne  %al
c0105193:	0f b6 c0             	movzbl %al,%eax
c0105196:	85 c0                	test   %eax,%eax
c0105198:	74 0b                	je     c01051a5 <default_check+0x3c3>
c010519a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010519d:	8b 40 08             	mov    0x8(%eax),%eax
c01051a0:	83 f8 01             	cmp    $0x1,%eax
c01051a3:	74 24                	je     c01051c9 <default_check+0x3e7>
c01051a5:	c7 44 24 0c 9c 6f 10 	movl   $0xc0106f9c,0xc(%esp)
c01051ac:	c0 
c01051ad:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01051b4:	c0 
c01051b5:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01051bc:	00 
c01051bd:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01051c4:	e8 20 b2 ff ff       	call   c01003e9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01051c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051cc:	83 c0 04             	add    $0x4,%eax
c01051cf:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01051d6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01051d9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01051dc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01051df:	0f a3 10             	bt     %edx,(%eax)
c01051e2:	19 c0                	sbb    %eax,%eax
c01051e4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01051e7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01051eb:	0f 95 c0             	setne  %al
c01051ee:	0f b6 c0             	movzbl %al,%eax
c01051f1:	85 c0                	test   %eax,%eax
c01051f3:	74 0b                	je     c0105200 <default_check+0x41e>
c01051f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051f8:	8b 40 08             	mov    0x8(%eax),%eax
c01051fb:	83 f8 03             	cmp    $0x3,%eax
c01051fe:	74 24                	je     c0105224 <default_check+0x442>
c0105200:	c7 44 24 0c c4 6f 10 	movl   $0xc0106fc4,0xc(%esp)
c0105207:	c0 
c0105208:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010520f:	c0 
c0105210:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0105217:	00 
c0105218:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010521f:	e8 c5 b1 ff ff       	call   c01003e9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105224:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010522b:	e8 2c d9 ff ff       	call   c0102b5c <alloc_pages>
c0105230:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105233:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105236:	83 e8 14             	sub    $0x14,%eax
c0105239:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010523c:	74 24                	je     c0105262 <default_check+0x480>
c010523e:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0105245:	c0 
c0105246:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010524d:	c0 
c010524e:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0105255:	00 
c0105256:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010525d:	e8 87 b1 ff ff       	call   c01003e9 <__panic>
    free_page(p0);
c0105262:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105269:	00 
c010526a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010526d:	89 04 24             	mov    %eax,(%esp)
c0105270:	e8 1f d9 ff ff       	call   c0102b94 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105275:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010527c:	e8 db d8 ff ff       	call   c0102b5c <alloc_pages>
c0105281:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105284:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105287:	83 c0 14             	add    $0x14,%eax
c010528a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010528d:	74 24                	je     c01052b3 <default_check+0x4d1>
c010528f:	c7 44 24 0c 08 70 10 	movl   $0xc0107008,0xc(%esp)
c0105296:	c0 
c0105297:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010529e:	c0 
c010529f:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01052a6:	00 
c01052a7:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c01052ae:	e8 36 b1 ff ff       	call   c01003e9 <__panic>

    free_pages(p0, 2);
c01052b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01052ba:	00 
c01052bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052be:	89 04 24             	mov    %eax,(%esp)
c01052c1:	e8 ce d8 ff ff       	call   c0102b94 <free_pages>
    free_page(p2);
c01052c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01052cd:	00 
c01052ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052d1:	89 04 24             	mov    %eax,(%esp)
c01052d4:	e8 bb d8 ff ff       	call   c0102b94 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01052d9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01052e0:	e8 77 d8 ff ff       	call   c0102b5c <alloc_pages>
c01052e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01052ec:	75 24                	jne    c0105312 <default_check+0x530>
c01052ee:	c7 44 24 0c 28 70 10 	movl   $0xc0107028,0xc(%esp)
c01052f5:	c0 
c01052f6:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01052fd:	c0 
c01052fe:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c0105305:	00 
c0105306:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010530d:	e8 d7 b0 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c0105312:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105319:	e8 3e d8 ff ff       	call   c0102b5c <alloc_pages>
c010531e:	85 c0                	test   %eax,%eax
c0105320:	74 24                	je     c0105346 <default_check+0x564>
c0105322:	c7 44 24 0c 86 6e 10 	movl   $0xc0106e86,0xc(%esp)
c0105329:	c0 
c010532a:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c0105331:	c0 
c0105332:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c0105339:	00 
c010533a:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0105341:	e8 a3 b0 ff ff       	call   c01003e9 <__panic>

    assert(nr_free == 0);
c0105346:	a1 44 af 11 c0       	mov    0xc011af44,%eax
c010534b:	85 c0                	test   %eax,%eax
c010534d:	74 24                	je     c0105373 <default_check+0x591>
c010534f:	c7 44 24 0c d9 6e 10 	movl   $0xc0106ed9,0xc(%esp)
c0105356:	c0 
c0105357:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010535e:	c0 
c010535f:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0105366:	00 
c0105367:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010536e:	e8 76 b0 ff ff       	call   c01003e9 <__panic>
    nr_free = nr_free_store;
c0105373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105376:	a3 44 af 11 c0       	mov    %eax,0xc011af44

    free_list = free_list_store;
c010537b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010537e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105381:	a3 3c af 11 c0       	mov    %eax,0xc011af3c
c0105386:	89 15 40 af 11 c0    	mov    %edx,0xc011af40
    free_pages(p0, 5);
c010538c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105393:	00 
c0105394:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105397:	89 04 24             	mov    %eax,(%esp)
c010539a:	e8 f5 d7 ff ff       	call   c0102b94 <free_pages>

    le = &free_list;
c010539f:	c7 45 ec 3c af 11 c0 	movl   $0xc011af3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01053a6:	eb 1c                	jmp    c01053c4 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
c01053a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053ab:	83 e8 0c             	sub    $0xc,%eax
c01053ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01053b1:	ff 4d f4             	decl   -0xc(%ebp)
c01053b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01053b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053ba:	8b 40 08             	mov    0x8(%eax),%eax
c01053bd:	29 c2                	sub    %eax,%edx
c01053bf:	89 d0                	mov    %edx,%eax
c01053c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053c7:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01053ca:	8b 45 88             	mov    -0x78(%ebp),%eax
c01053cd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01053d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053d3:	81 7d ec 3c af 11 c0 	cmpl   $0xc011af3c,-0x14(%ebp)
c01053da:	75 cc                	jne    c01053a8 <default_check+0x5c6>
    }
    assert(count == 0);
c01053dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01053e0:	74 24                	je     c0105406 <default_check+0x624>
c01053e2:	c7 44 24 0c 46 70 10 	movl   $0xc0107046,0xc(%esp)
c01053e9:	c0 
c01053ea:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01053f1:	c0 
c01053f2:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c01053f9:	00 
c01053fa:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c0105401:	e8 e3 af ff ff       	call   c01003e9 <__panic>
    assert(total == 0);
c0105406:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010540a:	74 24                	je     c0105430 <default_check+0x64e>
c010540c:	c7 44 24 0c 51 70 10 	movl   $0xc0107051,0xc(%esp)
c0105413:	c0 
c0105414:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c010541b:	c0 
c010541c:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c0105423:	00 
c0105424:	c7 04 24 13 6d 10 c0 	movl   $0xc0106d13,(%esp)
c010542b:	e8 b9 af ff ff       	call   c01003e9 <__panic>
}
c0105430:	90                   	nop
c0105431:	c9                   	leave  
c0105432:	c3                   	ret    

c0105433 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105433:	55                   	push   %ebp
c0105434:	89 e5                	mov    %esp,%ebp
c0105436:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105439:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105440:	eb 03                	jmp    c0105445 <strlen+0x12>
        cnt ++;
c0105442:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105445:	8b 45 08             	mov    0x8(%ebp),%eax
c0105448:	8d 50 01             	lea    0x1(%eax),%edx
c010544b:	89 55 08             	mov    %edx,0x8(%ebp)
c010544e:	0f b6 00             	movzbl (%eax),%eax
c0105451:	84 c0                	test   %al,%al
c0105453:	75 ed                	jne    c0105442 <strlen+0xf>
    }
    return cnt;
c0105455:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105458:	c9                   	leave  
c0105459:	c3                   	ret    

c010545a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010545a:	55                   	push   %ebp
c010545b:	89 e5                	mov    %esp,%ebp
c010545d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105467:	eb 03                	jmp    c010546c <strnlen+0x12>
        cnt ++;
c0105469:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010546c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010546f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105472:	73 10                	jae    c0105484 <strnlen+0x2a>
c0105474:	8b 45 08             	mov    0x8(%ebp),%eax
c0105477:	8d 50 01             	lea    0x1(%eax),%edx
c010547a:	89 55 08             	mov    %edx,0x8(%ebp)
c010547d:	0f b6 00             	movzbl (%eax),%eax
c0105480:	84 c0                	test   %al,%al
c0105482:	75 e5                	jne    c0105469 <strnlen+0xf>
    }
    return cnt;
c0105484:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105487:	c9                   	leave  
c0105488:	c3                   	ret    

c0105489 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105489:	55                   	push   %ebp
c010548a:	89 e5                	mov    %esp,%ebp
c010548c:	57                   	push   %edi
c010548d:	56                   	push   %esi
c010548e:	83 ec 20             	sub    $0x20,%esp
c0105491:	8b 45 08             	mov    0x8(%ebp),%eax
c0105494:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105497:	8b 45 0c             	mov    0xc(%ebp),%eax
c010549a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010549d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054a3:	89 d1                	mov    %edx,%ecx
c01054a5:	89 c2                	mov    %eax,%edx
c01054a7:	89 ce                	mov    %ecx,%esi
c01054a9:	89 d7                	mov    %edx,%edi
c01054ab:	ac                   	lods   %ds:(%esi),%al
c01054ac:	aa                   	stos   %al,%es:(%edi)
c01054ad:	84 c0                	test   %al,%al
c01054af:	75 fa                	jne    c01054ab <strcpy+0x22>
c01054b1:	89 fa                	mov    %edi,%edx
c01054b3:	89 f1                	mov    %esi,%ecx
c01054b5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01054b8:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01054bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01054be:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c01054c1:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01054c2:	83 c4 20             	add    $0x20,%esp
c01054c5:	5e                   	pop    %esi
c01054c6:	5f                   	pop    %edi
c01054c7:	5d                   	pop    %ebp
c01054c8:	c3                   	ret    

c01054c9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01054c9:	55                   	push   %ebp
c01054ca:	89 e5                	mov    %esp,%ebp
c01054cc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01054cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01054d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01054d5:	eb 1e                	jmp    c01054f5 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c01054d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054da:	0f b6 10             	movzbl (%eax),%edx
c01054dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054e0:	88 10                	mov    %dl,(%eax)
c01054e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054e5:	0f b6 00             	movzbl (%eax),%eax
c01054e8:	84 c0                	test   %al,%al
c01054ea:	74 03                	je     c01054ef <strncpy+0x26>
            src ++;
c01054ec:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01054ef:	ff 45 fc             	incl   -0x4(%ebp)
c01054f2:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01054f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054f9:	75 dc                	jne    c01054d7 <strncpy+0xe>
    }
    return dst;
c01054fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01054fe:	c9                   	leave  
c01054ff:	c3                   	ret    

c0105500 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105500:	55                   	push   %ebp
c0105501:	89 e5                	mov    %esp,%ebp
c0105503:	57                   	push   %edi
c0105504:	56                   	push   %esi
c0105505:	83 ec 20             	sub    $0x20,%esp
c0105508:	8b 45 08             	mov    0x8(%ebp),%eax
c010550b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010550e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105511:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105514:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105517:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010551a:	89 d1                	mov    %edx,%ecx
c010551c:	89 c2                	mov    %eax,%edx
c010551e:	89 ce                	mov    %ecx,%esi
c0105520:	89 d7                	mov    %edx,%edi
c0105522:	ac                   	lods   %ds:(%esi),%al
c0105523:	ae                   	scas   %es:(%edi),%al
c0105524:	75 08                	jne    c010552e <strcmp+0x2e>
c0105526:	84 c0                	test   %al,%al
c0105528:	75 f8                	jne    c0105522 <strcmp+0x22>
c010552a:	31 c0                	xor    %eax,%eax
c010552c:	eb 04                	jmp    c0105532 <strcmp+0x32>
c010552e:	19 c0                	sbb    %eax,%eax
c0105530:	0c 01                	or     $0x1,%al
c0105532:	89 fa                	mov    %edi,%edx
c0105534:	89 f1                	mov    %esi,%ecx
c0105536:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105539:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010553c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c010553f:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105542:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105543:	83 c4 20             	add    $0x20,%esp
c0105546:	5e                   	pop    %esi
c0105547:	5f                   	pop    %edi
c0105548:	5d                   	pop    %ebp
c0105549:	c3                   	ret    

c010554a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010554a:	55                   	push   %ebp
c010554b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010554d:	eb 09                	jmp    c0105558 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c010554f:	ff 4d 10             	decl   0x10(%ebp)
c0105552:	ff 45 08             	incl   0x8(%ebp)
c0105555:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105558:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010555c:	74 1a                	je     c0105578 <strncmp+0x2e>
c010555e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105561:	0f b6 00             	movzbl (%eax),%eax
c0105564:	84 c0                	test   %al,%al
c0105566:	74 10                	je     c0105578 <strncmp+0x2e>
c0105568:	8b 45 08             	mov    0x8(%ebp),%eax
c010556b:	0f b6 10             	movzbl (%eax),%edx
c010556e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105571:	0f b6 00             	movzbl (%eax),%eax
c0105574:	38 c2                	cmp    %al,%dl
c0105576:	74 d7                	je     c010554f <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105578:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010557c:	74 18                	je     c0105596 <strncmp+0x4c>
c010557e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105581:	0f b6 00             	movzbl (%eax),%eax
c0105584:	0f b6 d0             	movzbl %al,%edx
c0105587:	8b 45 0c             	mov    0xc(%ebp),%eax
c010558a:	0f b6 00             	movzbl (%eax),%eax
c010558d:	0f b6 c0             	movzbl %al,%eax
c0105590:	29 c2                	sub    %eax,%edx
c0105592:	89 d0                	mov    %edx,%eax
c0105594:	eb 05                	jmp    c010559b <strncmp+0x51>
c0105596:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010559b:	5d                   	pop    %ebp
c010559c:	c3                   	ret    

c010559d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010559d:	55                   	push   %ebp
c010559e:	89 e5                	mov    %esp,%ebp
c01055a0:	83 ec 04             	sub    $0x4,%esp
c01055a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055a6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01055a9:	eb 13                	jmp    c01055be <strchr+0x21>
        if (*s == c) {
c01055ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ae:	0f b6 00             	movzbl (%eax),%eax
c01055b1:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01055b4:	75 05                	jne    c01055bb <strchr+0x1e>
            return (char *)s;
c01055b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b9:	eb 12                	jmp    c01055cd <strchr+0x30>
        }
        s ++;
c01055bb:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01055be:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c1:	0f b6 00             	movzbl (%eax),%eax
c01055c4:	84 c0                	test   %al,%al
c01055c6:	75 e3                	jne    c01055ab <strchr+0xe>
    }
    return NULL;
c01055c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01055cd:	c9                   	leave  
c01055ce:	c3                   	ret    

c01055cf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01055cf:	55                   	push   %ebp
c01055d0:	89 e5                	mov    %esp,%ebp
c01055d2:	83 ec 04             	sub    $0x4,%esp
c01055d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055d8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01055db:	eb 0e                	jmp    c01055eb <strfind+0x1c>
        if (*s == c) {
c01055dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e0:	0f b6 00             	movzbl (%eax),%eax
c01055e3:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01055e6:	74 0f                	je     c01055f7 <strfind+0x28>
            break;
        }
        s ++;
c01055e8:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01055eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ee:	0f b6 00             	movzbl (%eax),%eax
c01055f1:	84 c0                	test   %al,%al
c01055f3:	75 e8                	jne    c01055dd <strfind+0xe>
c01055f5:	eb 01                	jmp    c01055f8 <strfind+0x29>
            break;
c01055f7:	90                   	nop
    }
    return (char *)s;
c01055f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01055fb:	c9                   	leave  
c01055fc:	c3                   	ret    

c01055fd <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01055fd:	55                   	push   %ebp
c01055fe:	89 e5                	mov    %esp,%ebp
c0105600:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010560a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105611:	eb 03                	jmp    c0105616 <strtol+0x19>
        s ++;
c0105613:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105616:	8b 45 08             	mov    0x8(%ebp),%eax
c0105619:	0f b6 00             	movzbl (%eax),%eax
c010561c:	3c 20                	cmp    $0x20,%al
c010561e:	74 f3                	je     c0105613 <strtol+0x16>
c0105620:	8b 45 08             	mov    0x8(%ebp),%eax
c0105623:	0f b6 00             	movzbl (%eax),%eax
c0105626:	3c 09                	cmp    $0x9,%al
c0105628:	74 e9                	je     c0105613 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c010562a:	8b 45 08             	mov    0x8(%ebp),%eax
c010562d:	0f b6 00             	movzbl (%eax),%eax
c0105630:	3c 2b                	cmp    $0x2b,%al
c0105632:	75 05                	jne    c0105639 <strtol+0x3c>
        s ++;
c0105634:	ff 45 08             	incl   0x8(%ebp)
c0105637:	eb 14                	jmp    c010564d <strtol+0x50>
    }
    else if (*s == '-') {
c0105639:	8b 45 08             	mov    0x8(%ebp),%eax
c010563c:	0f b6 00             	movzbl (%eax),%eax
c010563f:	3c 2d                	cmp    $0x2d,%al
c0105641:	75 0a                	jne    c010564d <strtol+0x50>
        s ++, neg = 1;
c0105643:	ff 45 08             	incl   0x8(%ebp)
c0105646:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010564d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105651:	74 06                	je     c0105659 <strtol+0x5c>
c0105653:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105657:	75 22                	jne    c010567b <strtol+0x7e>
c0105659:	8b 45 08             	mov    0x8(%ebp),%eax
c010565c:	0f b6 00             	movzbl (%eax),%eax
c010565f:	3c 30                	cmp    $0x30,%al
c0105661:	75 18                	jne    c010567b <strtol+0x7e>
c0105663:	8b 45 08             	mov    0x8(%ebp),%eax
c0105666:	40                   	inc    %eax
c0105667:	0f b6 00             	movzbl (%eax),%eax
c010566a:	3c 78                	cmp    $0x78,%al
c010566c:	75 0d                	jne    c010567b <strtol+0x7e>
        s += 2, base = 16;
c010566e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105672:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105679:	eb 29                	jmp    c01056a4 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c010567b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010567f:	75 16                	jne    c0105697 <strtol+0x9a>
c0105681:	8b 45 08             	mov    0x8(%ebp),%eax
c0105684:	0f b6 00             	movzbl (%eax),%eax
c0105687:	3c 30                	cmp    $0x30,%al
c0105689:	75 0c                	jne    c0105697 <strtol+0x9a>
        s ++, base = 8;
c010568b:	ff 45 08             	incl   0x8(%ebp)
c010568e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105695:	eb 0d                	jmp    c01056a4 <strtol+0xa7>
    }
    else if (base == 0) {
c0105697:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010569b:	75 07                	jne    c01056a4 <strtol+0xa7>
        base = 10;
c010569d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01056a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a7:	0f b6 00             	movzbl (%eax),%eax
c01056aa:	3c 2f                	cmp    $0x2f,%al
c01056ac:	7e 1b                	jle    c01056c9 <strtol+0xcc>
c01056ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b1:	0f b6 00             	movzbl (%eax),%eax
c01056b4:	3c 39                	cmp    $0x39,%al
c01056b6:	7f 11                	jg     c01056c9 <strtol+0xcc>
            dig = *s - '0';
c01056b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056bb:	0f b6 00             	movzbl (%eax),%eax
c01056be:	0f be c0             	movsbl %al,%eax
c01056c1:	83 e8 30             	sub    $0x30,%eax
c01056c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056c7:	eb 48                	jmp    c0105711 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01056c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056cc:	0f b6 00             	movzbl (%eax),%eax
c01056cf:	3c 60                	cmp    $0x60,%al
c01056d1:	7e 1b                	jle    c01056ee <strtol+0xf1>
c01056d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d6:	0f b6 00             	movzbl (%eax),%eax
c01056d9:	3c 7a                	cmp    $0x7a,%al
c01056db:	7f 11                	jg     c01056ee <strtol+0xf1>
            dig = *s - 'a' + 10;
c01056dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e0:	0f b6 00             	movzbl (%eax),%eax
c01056e3:	0f be c0             	movsbl %al,%eax
c01056e6:	83 e8 57             	sub    $0x57,%eax
c01056e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056ec:	eb 23                	jmp    c0105711 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01056ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f1:	0f b6 00             	movzbl (%eax),%eax
c01056f4:	3c 40                	cmp    $0x40,%al
c01056f6:	7e 3b                	jle    c0105733 <strtol+0x136>
c01056f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fb:	0f b6 00             	movzbl (%eax),%eax
c01056fe:	3c 5a                	cmp    $0x5a,%al
c0105700:	7f 31                	jg     c0105733 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105702:	8b 45 08             	mov    0x8(%ebp),%eax
c0105705:	0f b6 00             	movzbl (%eax),%eax
c0105708:	0f be c0             	movsbl %al,%eax
c010570b:	83 e8 37             	sub    $0x37,%eax
c010570e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105711:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105714:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105717:	7d 19                	jge    c0105732 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105719:	ff 45 08             	incl   0x8(%ebp)
c010571c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010571f:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105723:	89 c2                	mov    %eax,%edx
c0105725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105728:	01 d0                	add    %edx,%eax
c010572a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c010572d:	e9 72 ff ff ff       	jmp    c01056a4 <strtol+0xa7>
            break;
c0105732:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105733:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105737:	74 08                	je     c0105741 <strtol+0x144>
        *endptr = (char *) s;
c0105739:	8b 45 0c             	mov    0xc(%ebp),%eax
c010573c:	8b 55 08             	mov    0x8(%ebp),%edx
c010573f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105741:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105745:	74 07                	je     c010574e <strtol+0x151>
c0105747:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010574a:	f7 d8                	neg    %eax
c010574c:	eb 03                	jmp    c0105751 <strtol+0x154>
c010574e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105751:	c9                   	leave  
c0105752:	c3                   	ret    

c0105753 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105753:	55                   	push   %ebp
c0105754:	89 e5                	mov    %esp,%ebp
c0105756:	57                   	push   %edi
c0105757:	83 ec 24             	sub    $0x24,%esp
c010575a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010575d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105760:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105764:	8b 55 08             	mov    0x8(%ebp),%edx
c0105767:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010576a:	88 45 f7             	mov    %al,-0x9(%ebp)
c010576d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105770:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105773:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105776:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010577a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010577d:	89 d7                	mov    %edx,%edi
c010577f:	f3 aa                	rep stos %al,%es:(%edi)
c0105781:	89 fa                	mov    %edi,%edx
c0105783:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105786:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105789:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010578c:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010578d:	83 c4 24             	add    $0x24,%esp
c0105790:	5f                   	pop    %edi
c0105791:	5d                   	pop    %ebp
c0105792:	c3                   	ret    

c0105793 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105793:	55                   	push   %ebp
c0105794:	89 e5                	mov    %esp,%ebp
c0105796:	57                   	push   %edi
c0105797:	56                   	push   %esi
c0105798:	53                   	push   %ebx
c0105799:	83 ec 30             	sub    $0x30,%esp
c010579c:	8b 45 08             	mov    0x8(%ebp),%eax
c010579f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01057ab:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01057ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01057b4:	73 42                	jae    c01057f8 <memmove+0x65>
c01057b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01057bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01057c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01057c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057cb:	c1 e8 02             	shr    $0x2,%eax
c01057ce:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01057d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01057d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057d6:	89 d7                	mov    %edx,%edi
c01057d8:	89 c6                	mov    %eax,%esi
c01057da:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01057dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01057df:	83 e1 03             	and    $0x3,%ecx
c01057e2:	74 02                	je     c01057e6 <memmove+0x53>
c01057e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01057e6:	89 f0                	mov    %esi,%eax
c01057e8:	89 fa                	mov    %edi,%edx
c01057ea:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01057ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01057f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01057f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01057f6:	eb 36                	jmp    c010582e <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01057f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057fb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01057fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105801:	01 c2                	add    %eax,%edx
c0105803:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105806:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105809:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010580c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c010580f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105812:	89 c1                	mov    %eax,%ecx
c0105814:	89 d8                	mov    %ebx,%eax
c0105816:	89 d6                	mov    %edx,%esi
c0105818:	89 c7                	mov    %eax,%edi
c010581a:	fd                   	std    
c010581b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010581d:	fc                   	cld    
c010581e:	89 f8                	mov    %edi,%eax
c0105820:	89 f2                	mov    %esi,%edx
c0105822:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105825:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105828:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010582b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010582e:	83 c4 30             	add    $0x30,%esp
c0105831:	5b                   	pop    %ebx
c0105832:	5e                   	pop    %esi
c0105833:	5f                   	pop    %edi
c0105834:	5d                   	pop    %ebp
c0105835:	c3                   	ret    

c0105836 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105836:	55                   	push   %ebp
c0105837:	89 e5                	mov    %esp,%ebp
c0105839:	57                   	push   %edi
c010583a:	56                   	push   %esi
c010583b:	83 ec 20             	sub    $0x20,%esp
c010583e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105841:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105844:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105847:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010584a:	8b 45 10             	mov    0x10(%ebp),%eax
c010584d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105850:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105853:	c1 e8 02             	shr    $0x2,%eax
c0105856:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105858:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010585b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010585e:	89 d7                	mov    %edx,%edi
c0105860:	89 c6                	mov    %eax,%esi
c0105862:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105864:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105867:	83 e1 03             	and    $0x3,%ecx
c010586a:	74 02                	je     c010586e <memcpy+0x38>
c010586c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010586e:	89 f0                	mov    %esi,%eax
c0105870:	89 fa                	mov    %edi,%edx
c0105872:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105875:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105878:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010587b:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010587e:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010587f:	83 c4 20             	add    $0x20,%esp
c0105882:	5e                   	pop    %esi
c0105883:	5f                   	pop    %edi
c0105884:	5d                   	pop    %ebp
c0105885:	c3                   	ret    

c0105886 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105886:	55                   	push   %ebp
c0105887:	89 e5                	mov    %esp,%ebp
c0105889:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010588c:	8b 45 08             	mov    0x8(%ebp),%eax
c010588f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105892:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105895:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105898:	eb 2e                	jmp    c01058c8 <memcmp+0x42>
        if (*s1 != *s2) {
c010589a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010589d:	0f b6 10             	movzbl (%eax),%edx
c01058a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058a3:	0f b6 00             	movzbl (%eax),%eax
c01058a6:	38 c2                	cmp    %al,%dl
c01058a8:	74 18                	je     c01058c2 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01058aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01058ad:	0f b6 00             	movzbl (%eax),%eax
c01058b0:	0f b6 d0             	movzbl %al,%edx
c01058b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058b6:	0f b6 00             	movzbl (%eax),%eax
c01058b9:	0f b6 c0             	movzbl %al,%eax
c01058bc:	29 c2                	sub    %eax,%edx
c01058be:	89 d0                	mov    %edx,%eax
c01058c0:	eb 18                	jmp    c01058da <memcmp+0x54>
        }
        s1 ++, s2 ++;
c01058c2:	ff 45 fc             	incl   -0x4(%ebp)
c01058c5:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c01058c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01058cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058ce:	89 55 10             	mov    %edx,0x10(%ebp)
c01058d1:	85 c0                	test   %eax,%eax
c01058d3:	75 c5                	jne    c010589a <memcmp+0x14>
    }
    return 0;
c01058d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01058da:	c9                   	leave  
c01058db:	c3                   	ret    

c01058dc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01058dc:	55                   	push   %ebp
c01058dd:	89 e5                	mov    %esp,%ebp
c01058df:	83 ec 58             	sub    $0x58,%esp
c01058e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01058e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01058e8:	8b 45 14             	mov    0x14(%ebp),%eax
c01058eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01058ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058f7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01058fa:	8b 45 18             	mov    0x18(%ebp),%eax
c01058fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105900:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105903:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105906:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105909:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010590c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010590f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105912:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105916:	74 1c                	je     c0105934 <printnum+0x58>
c0105918:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010591b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105920:	f7 75 e4             	divl   -0x1c(%ebp)
c0105923:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105926:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105929:	ba 00 00 00 00       	mov    $0x0,%edx
c010592e:	f7 75 e4             	divl   -0x1c(%ebp)
c0105931:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105934:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105937:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010593a:	f7 75 e4             	divl   -0x1c(%ebp)
c010593d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105940:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105943:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105946:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105949:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010594c:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010594f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105952:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105955:	8b 45 18             	mov    0x18(%ebp),%eax
c0105958:	ba 00 00 00 00       	mov    $0x0,%edx
c010595d:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105960:	72 56                	jb     c01059b8 <printnum+0xdc>
c0105962:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105965:	77 05                	ja     c010596c <printnum+0x90>
c0105967:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010596a:	72 4c                	jb     c01059b8 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010596c:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010596f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105972:	8b 45 20             	mov    0x20(%ebp),%eax
c0105975:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105979:	89 54 24 14          	mov    %edx,0x14(%esp)
c010597d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105980:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105984:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105987:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010598a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010598e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105992:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105995:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105999:	8b 45 08             	mov    0x8(%ebp),%eax
c010599c:	89 04 24             	mov    %eax,(%esp)
c010599f:	e8 38 ff ff ff       	call   c01058dc <printnum>
c01059a4:	eb 1b                	jmp    c01059c1 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01059a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ad:	8b 45 20             	mov    0x20(%ebp),%eax
c01059b0:	89 04 24             	mov    %eax,(%esp)
c01059b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b6:	ff d0                	call   *%eax
        while (-- width > 0)
c01059b8:	ff 4d 1c             	decl   0x1c(%ebp)
c01059bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01059bf:	7f e5                	jg     c01059a6 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01059c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01059c4:	05 0c 71 10 c0       	add    $0xc010710c,%eax
c01059c9:	0f b6 00             	movzbl (%eax),%eax
c01059cc:	0f be c0             	movsbl %al,%eax
c01059cf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059d2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059d6:	89 04 24             	mov    %eax,(%esp)
c01059d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059dc:	ff d0                	call   *%eax
}
c01059de:	90                   	nop
c01059df:	c9                   	leave  
c01059e0:	c3                   	ret    

c01059e1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01059e1:	55                   	push   %ebp
c01059e2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01059e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01059e8:	7e 14                	jle    c01059fe <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01059ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ed:	8b 00                	mov    (%eax),%eax
c01059ef:	8d 48 08             	lea    0x8(%eax),%ecx
c01059f2:	8b 55 08             	mov    0x8(%ebp),%edx
c01059f5:	89 0a                	mov    %ecx,(%edx)
c01059f7:	8b 50 04             	mov    0x4(%eax),%edx
c01059fa:	8b 00                	mov    (%eax),%eax
c01059fc:	eb 30                	jmp    c0105a2e <getuint+0x4d>
    }
    else if (lflag) {
c01059fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a02:	74 16                	je     c0105a1a <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105a04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a07:	8b 00                	mov    (%eax),%eax
c0105a09:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a0c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a0f:	89 0a                	mov    %ecx,(%edx)
c0105a11:	8b 00                	mov    (%eax),%eax
c0105a13:	ba 00 00 00 00       	mov    $0x0,%edx
c0105a18:	eb 14                	jmp    c0105a2e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105a1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1d:	8b 00                	mov    (%eax),%eax
c0105a1f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a22:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a25:	89 0a                	mov    %ecx,(%edx)
c0105a27:	8b 00                	mov    (%eax),%eax
c0105a29:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105a2e:	5d                   	pop    %ebp
c0105a2f:	c3                   	ret    

c0105a30 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105a30:	55                   	push   %ebp
c0105a31:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105a33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105a37:	7e 14                	jle    c0105a4d <getint+0x1d>
        return va_arg(*ap, long long);
c0105a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3c:	8b 00                	mov    (%eax),%eax
c0105a3e:	8d 48 08             	lea    0x8(%eax),%ecx
c0105a41:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a44:	89 0a                	mov    %ecx,(%edx)
c0105a46:	8b 50 04             	mov    0x4(%eax),%edx
c0105a49:	8b 00                	mov    (%eax),%eax
c0105a4b:	eb 28                	jmp    c0105a75 <getint+0x45>
    }
    else if (lflag) {
c0105a4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a51:	74 12                	je     c0105a65 <getint+0x35>
        return va_arg(*ap, long);
c0105a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a56:	8b 00                	mov    (%eax),%eax
c0105a58:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a5b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a5e:	89 0a                	mov    %ecx,(%edx)
c0105a60:	8b 00                	mov    (%eax),%eax
c0105a62:	99                   	cltd   
c0105a63:	eb 10                	jmp    c0105a75 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a68:	8b 00                	mov    (%eax),%eax
c0105a6a:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a6d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a70:	89 0a                	mov    %ecx,(%edx)
c0105a72:	8b 00                	mov    (%eax),%eax
c0105a74:	99                   	cltd   
    }
}
c0105a75:	5d                   	pop    %ebp
c0105a76:	c3                   	ret    

c0105a77 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105a77:	55                   	push   %ebp
c0105a78:	89 e5                	mov    %esp,%ebp
c0105a7a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105a7d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a86:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a8d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9b:	89 04 24             	mov    %eax,(%esp)
c0105a9e:	e8 03 00 00 00       	call   c0105aa6 <vprintfmt>
    va_end(ap);
}
c0105aa3:	90                   	nop
c0105aa4:	c9                   	leave  
c0105aa5:	c3                   	ret    

c0105aa6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105aa6:	55                   	push   %ebp
c0105aa7:	89 e5                	mov    %esp,%ebp
c0105aa9:	56                   	push   %esi
c0105aaa:	53                   	push   %ebx
c0105aab:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105aae:	eb 17                	jmp    c0105ac7 <vprintfmt+0x21>
            if (ch == '\0') {
c0105ab0:	85 db                	test   %ebx,%ebx
c0105ab2:	0f 84 bf 03 00 00    	je     c0105e77 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105abb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105abf:	89 1c 24             	mov    %ebx,(%esp)
c0105ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac5:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105ac7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aca:	8d 50 01             	lea    0x1(%eax),%edx
c0105acd:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ad0:	0f b6 00             	movzbl (%eax),%eax
c0105ad3:	0f b6 d8             	movzbl %al,%ebx
c0105ad6:	83 fb 25             	cmp    $0x25,%ebx
c0105ad9:	75 d5                	jne    c0105ab0 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105adb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105adf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ae9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105aec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105af3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105af6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105af9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105afc:	8d 50 01             	lea    0x1(%eax),%edx
c0105aff:	89 55 10             	mov    %edx,0x10(%ebp)
c0105b02:	0f b6 00             	movzbl (%eax),%eax
c0105b05:	0f b6 d8             	movzbl %al,%ebx
c0105b08:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105b0b:	83 f8 55             	cmp    $0x55,%eax
c0105b0e:	0f 87 37 03 00 00    	ja     c0105e4b <vprintfmt+0x3a5>
c0105b14:	8b 04 85 30 71 10 c0 	mov    -0x3fef8ed0(,%eax,4),%eax
c0105b1b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105b1d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105b21:	eb d6                	jmp    c0105af9 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105b23:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105b27:	eb d0                	jmp    c0105af9 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105b29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b33:	89 d0                	mov    %edx,%eax
c0105b35:	c1 e0 02             	shl    $0x2,%eax
c0105b38:	01 d0                	add    %edx,%eax
c0105b3a:	01 c0                	add    %eax,%eax
c0105b3c:	01 d8                	add    %ebx,%eax
c0105b3e:	83 e8 30             	sub    $0x30,%eax
c0105b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105b44:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b47:	0f b6 00             	movzbl (%eax),%eax
c0105b4a:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105b4d:	83 fb 2f             	cmp    $0x2f,%ebx
c0105b50:	7e 38                	jle    c0105b8a <vprintfmt+0xe4>
c0105b52:	83 fb 39             	cmp    $0x39,%ebx
c0105b55:	7f 33                	jg     c0105b8a <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105b57:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105b5a:	eb d4                	jmp    c0105b30 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105b5c:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b5f:	8d 50 04             	lea    0x4(%eax),%edx
c0105b62:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b65:	8b 00                	mov    (%eax),%eax
c0105b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105b6a:	eb 1f                	jmp    c0105b8b <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105b6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b70:	79 87                	jns    c0105af9 <vprintfmt+0x53>
                width = 0;
c0105b72:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105b79:	e9 7b ff ff ff       	jmp    c0105af9 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105b7e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105b85:	e9 6f ff ff ff       	jmp    c0105af9 <vprintfmt+0x53>
            goto process_precision;
c0105b8a:	90                   	nop

        process_precision:
            if (width < 0)
c0105b8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b8f:	0f 89 64 ff ff ff    	jns    c0105af9 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b98:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b9b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105ba2:	e9 52 ff ff ff       	jmp    c0105af9 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105ba7:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105baa:	e9 4a ff ff ff       	jmp    c0105af9 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105baf:	8b 45 14             	mov    0x14(%ebp),%eax
c0105bb2:	8d 50 04             	lea    0x4(%eax),%edx
c0105bb5:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bb8:	8b 00                	mov    (%eax),%eax
c0105bba:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105bc1:	89 04 24             	mov    %eax,(%esp)
c0105bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc7:	ff d0                	call   *%eax
            break;
c0105bc9:	e9 a4 02 00 00       	jmp    c0105e72 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105bce:	8b 45 14             	mov    0x14(%ebp),%eax
c0105bd1:	8d 50 04             	lea    0x4(%eax),%edx
c0105bd4:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bd7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105bd9:	85 db                	test   %ebx,%ebx
c0105bdb:	79 02                	jns    c0105bdf <vprintfmt+0x139>
                err = -err;
c0105bdd:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105bdf:	83 fb 06             	cmp    $0x6,%ebx
c0105be2:	7f 0b                	jg     c0105bef <vprintfmt+0x149>
c0105be4:	8b 34 9d f0 70 10 c0 	mov    -0x3fef8f10(,%ebx,4),%esi
c0105beb:	85 f6                	test   %esi,%esi
c0105bed:	75 23                	jne    c0105c12 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0105bef:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105bf3:	c7 44 24 08 1d 71 10 	movl   $0xc010711d,0x8(%esp)
c0105bfa:	c0 
c0105bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c05:	89 04 24             	mov    %eax,(%esp)
c0105c08:	e8 6a fe ff ff       	call   c0105a77 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105c0d:	e9 60 02 00 00       	jmp    c0105e72 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105c12:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105c16:	c7 44 24 08 26 71 10 	movl   $0xc0107126,0x8(%esp)
c0105c1d:	c0 
c0105c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c28:	89 04 24             	mov    %eax,(%esp)
c0105c2b:	e8 47 fe ff ff       	call   c0105a77 <printfmt>
            break;
c0105c30:	e9 3d 02 00 00       	jmp    c0105e72 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105c35:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c38:	8d 50 04             	lea    0x4(%eax),%edx
c0105c3b:	89 55 14             	mov    %edx,0x14(%ebp)
c0105c3e:	8b 30                	mov    (%eax),%esi
c0105c40:	85 f6                	test   %esi,%esi
c0105c42:	75 05                	jne    c0105c49 <vprintfmt+0x1a3>
                p = "(null)";
c0105c44:	be 29 71 10 c0       	mov    $0xc0107129,%esi
            }
            if (width > 0 && padc != '-') {
c0105c49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c4d:	7e 76                	jle    c0105cc5 <vprintfmt+0x21f>
c0105c4f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105c53:	74 70                	je     c0105cc5 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c5c:	89 34 24             	mov    %esi,(%esp)
c0105c5f:	e8 f6 f7 ff ff       	call   c010545a <strnlen>
c0105c64:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c67:	29 c2                	sub    %eax,%edx
c0105c69:	89 d0                	mov    %edx,%eax
c0105c6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105c6e:	eb 16                	jmp    c0105c86 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0105c70:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105c74:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c77:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c7b:	89 04 24             	mov    %eax,(%esp)
c0105c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c81:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c83:	ff 4d e8             	decl   -0x18(%ebp)
c0105c86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c8a:	7f e4                	jg     c0105c70 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105c8c:	eb 37                	jmp    c0105cc5 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105c8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105c92:	74 1f                	je     c0105cb3 <vprintfmt+0x20d>
c0105c94:	83 fb 1f             	cmp    $0x1f,%ebx
c0105c97:	7e 05                	jle    c0105c9e <vprintfmt+0x1f8>
c0105c99:	83 fb 7e             	cmp    $0x7e,%ebx
c0105c9c:	7e 15                	jle    c0105cb3 <vprintfmt+0x20d>
                    putch('?', putdat);
c0105c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ca5:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105caf:	ff d0                	call   *%eax
c0105cb1:	eb 0f                	jmp    c0105cc2 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cba:	89 1c 24             	mov    %ebx,(%esp)
c0105cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc0:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105cc2:	ff 4d e8             	decl   -0x18(%ebp)
c0105cc5:	89 f0                	mov    %esi,%eax
c0105cc7:	8d 70 01             	lea    0x1(%eax),%esi
c0105cca:	0f b6 00             	movzbl (%eax),%eax
c0105ccd:	0f be d8             	movsbl %al,%ebx
c0105cd0:	85 db                	test   %ebx,%ebx
c0105cd2:	74 27                	je     c0105cfb <vprintfmt+0x255>
c0105cd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105cd8:	78 b4                	js     c0105c8e <vprintfmt+0x1e8>
c0105cda:	ff 4d e4             	decl   -0x1c(%ebp)
c0105cdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ce1:	79 ab                	jns    c0105c8e <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0105ce3:	eb 16                	jmp    c0105cfb <vprintfmt+0x255>
                putch(' ', putdat);
c0105ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105cf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf6:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105cf8:	ff 4d e8             	decl   -0x18(%ebp)
c0105cfb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105cff:	7f e4                	jg     c0105ce5 <vprintfmt+0x23f>
            }
            break;
c0105d01:	e9 6c 01 00 00       	jmp    c0105e72 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d0d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d10:	89 04 24             	mov    %eax,(%esp)
c0105d13:	e8 18 fd ff ff       	call   c0105a30 <getint>
c0105d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d24:	85 d2                	test   %edx,%edx
c0105d26:	79 26                	jns    c0105d4e <vprintfmt+0x2a8>
                putch('-', putdat);
c0105d28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d2f:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d39:	ff d0                	call   *%eax
                num = -(long long)num;
c0105d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d41:	f7 d8                	neg    %eax
c0105d43:	83 d2 00             	adc    $0x0,%edx
c0105d46:	f7 da                	neg    %edx
c0105d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105d4e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d55:	e9 a8 00 00 00       	jmp    c0105e02 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d61:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d64:	89 04 24             	mov    %eax,(%esp)
c0105d67:	e8 75 fc ff ff       	call   c01059e1 <getuint>
c0105d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105d72:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d79:	e9 84 00 00 00       	jmp    c0105e02 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d85:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d88:	89 04 24             	mov    %eax,(%esp)
c0105d8b:	e8 51 fc ff ff       	call   c01059e1 <getuint>
c0105d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d93:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105d96:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105d9d:	eb 63                	jmp    c0105e02 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105da6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db0:	ff d0                	call   *%eax
            putch('x', putdat);
c0105db2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105db5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105db9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105dc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105dc5:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dc8:	8d 50 04             	lea    0x4(%eax),%edx
c0105dcb:	89 55 14             	mov    %edx,0x14(%ebp)
c0105dce:	8b 00                	mov    (%eax),%eax
c0105dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105dd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105dda:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105de1:	eb 1f                	jmp    c0105e02 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105de6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dea:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ded:	89 04 24             	mov    %eax,(%esp)
c0105df0:	e8 ec fb ff ff       	call   c01059e1 <getuint>
c0105df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105df8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105dfb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105e02:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e09:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105e0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105e10:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105e14:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e1e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e22:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e30:	89 04 24             	mov    %eax,(%esp)
c0105e33:	e8 a4 fa ff ff       	call   c01058dc <printnum>
            break;
c0105e38:	eb 38                	jmp    c0105e72 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e41:	89 1c 24             	mov    %ebx,(%esp)
c0105e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e47:	ff d0                	call   *%eax
            break;
c0105e49:	eb 27                	jmp    c0105e72 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e52:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105e5e:	ff 4d 10             	decl   0x10(%ebp)
c0105e61:	eb 03                	jmp    c0105e66 <vprintfmt+0x3c0>
c0105e63:	ff 4d 10             	decl   0x10(%ebp)
c0105e66:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e69:	48                   	dec    %eax
c0105e6a:	0f b6 00             	movzbl (%eax),%eax
c0105e6d:	3c 25                	cmp    $0x25,%al
c0105e6f:	75 f2                	jne    c0105e63 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105e71:	90                   	nop
    while (1) {
c0105e72:	e9 37 fc ff ff       	jmp    c0105aae <vprintfmt+0x8>
                return;
c0105e77:	90                   	nop
        }
    }
}
c0105e78:	83 c4 40             	add    $0x40,%esp
c0105e7b:	5b                   	pop    %ebx
c0105e7c:	5e                   	pop    %esi
c0105e7d:	5d                   	pop    %ebp
c0105e7e:	c3                   	ret    

c0105e7f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105e7f:	55                   	push   %ebp
c0105e80:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105e82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e85:	8b 40 08             	mov    0x8(%eax),%eax
c0105e88:	8d 50 01             	lea    0x1(%eax),%edx
c0105e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e8e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105e91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e94:	8b 10                	mov    (%eax),%edx
c0105e96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e99:	8b 40 04             	mov    0x4(%eax),%eax
c0105e9c:	39 c2                	cmp    %eax,%edx
c0105e9e:	73 12                	jae    c0105eb2 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ea3:	8b 00                	mov    (%eax),%eax
c0105ea5:	8d 48 01             	lea    0x1(%eax),%ecx
c0105ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105eab:	89 0a                	mov    %ecx,(%edx)
c0105ead:	8b 55 08             	mov    0x8(%ebp),%edx
c0105eb0:	88 10                	mov    %dl,(%eax)
    }
}
c0105eb2:	90                   	nop
c0105eb3:	5d                   	pop    %ebp
c0105eb4:	c3                   	ret    

c0105eb5 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105eb5:	55                   	push   %ebp
c0105eb6:	89 e5                	mov    %esp,%ebp
c0105eb8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105ebb:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ec4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ec8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ecb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed9:	89 04 24             	mov    %eax,(%esp)
c0105edc:	e8 08 00 00 00       	call   c0105ee9 <vsnprintf>
c0105ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ee7:	c9                   	leave  
c0105ee8:	c3                   	ret    

c0105ee9 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105ee9:	55                   	push   %ebp
c0105eea:	89 e5                	mov    %esp,%ebp
c0105eec:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105efe:	01 d0                	add    %edx,%eax
c0105f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105f0e:	74 0a                	je     c0105f1a <vsnprintf+0x31>
c0105f10:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f16:	39 c2                	cmp    %eax,%edx
c0105f18:	76 07                	jbe    c0105f21 <vsnprintf+0x38>
        return -E_INVAL;
c0105f1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105f1f:	eb 2a                	jmp    c0105f4b <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105f21:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f24:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f28:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f2b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f2f:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105f32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f36:	c7 04 24 7f 5e 10 c0 	movl   $0xc0105e7f,(%esp)
c0105f3d:	e8 64 fb ff ff       	call   c0105aa6 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f45:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f4b:	c9                   	leave  
c0105f4c:	c3                   	ret    
