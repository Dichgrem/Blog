+++
title = "乱七八糟:Baci实验笔记"
date = 2025-04-23

[taxonomies]
tags = ["乱七八糟"]
+++

前言 ​BACI是一个简化的并发程序模拟器，这里对其语法与运行环境进行说明。
<!-- more -->

​BACI（``Ben-Ari Concurrent Interpreter``）由计算机科学家 M. Ben-Ari 开发，是一个用于教学目的的并发程序模拟器，提供了一个简化的编程环境，使学习者能够编写、编译和执行并发程序，从而深入``理解进程同步、互斥、信号量``等核心概念。

# 官方指南

``BACI C−− User’s Guide``：详细介绍了 C−− 编译器（bacc）与 PCODE 解释器（bainterp）的使用方法、语法说明及示例程序。该指南``包含编译命令、信号量、监视器等并发原语``介绍。 这里对官方文档进行了汉化：

> 作者：Bill Bynum/Tracy Camp 威廉玛丽学院/科罗拉多矿业学院 2002年11月5日

## 目录
```bash
1. 引言
2. C-- 编译器语法
3. 并发结构
   3.1 cobegin 块
   3.2 信号量
      3.2.1 初始化信号量
      3.2.2 p (或 wait) 和 v (或 signal) 函数
      3.2.3 信号量使用示例
   3.3 管程
      3.3.1 条件变量
      3.3.2 waitc 和 signalc 函数
      3.3.3 立即恢复要求
      3.3.4 管程示例
   3.4 其他并发结构
      3.4.1 atomic 关键字
      3.4.2 void suspend( void );
      3.4.3 void revive( int process_number );
      3.4.4 int which_proc( void );
      3.4.5 int random( int range );
4. 内置字符串处理函数
   4.1 void stringCopy(string dest, string src);
   4.2 void stringConcat(string dest, string src);
   4.3 int stringCompare(string x, string y);
   4.4 int stringLength(string x);
   4.5 int sscanf(string x, rawstring fmt,...);
   4.6 void sprintf(string x, rawstring fmt,...);
5. 使用 BACI C-- 编译器和 PCODE 解释器
6. 示例程序和输出
```
## 1. 引言

本文档旨在简要描述 C-- BACI 编译器和并发 PCODE 解释器程序，并说明如何使用它们。C-- 编译器首先将用户程序编译成一种称为 PCODE 的中间目标代码，然后由解释器执行。C-- 编译器支持二进制和计数信号量以及 Hoare 管程。解释器模拟并发进程执行。

BACI 系统程序：

| 程序 | 功能 | 相关文档 |
|------|------|----------|
| bacc | BACI C-- 到 PCODE 编译器 | 本指南 (cmimi.ps) |
| bapas | BACI Pascal 到 PCODE 编译器 | guidepas.ps |
| bainterp | 命令行 PCODE 解释器 | cmimi.ps, guidepas.ps, disasm.ps |
| bagui | PCODE 解释器的图形用户界面（仅限 UNIX 系统） | guiguide.ps |
| badis | PCODE 反编译器 | disasm.ps |
| baar | PCODE 归档程序 | sepcomp.ps |
| bald | PCODE 链接器 | sepcomp.ps |

Pascal 版本的编译器和解释器最初是 M. Ben-Ari 编写的程序中的过程，基于 Niklaus Wirth 的原始 Pascal 编译器。程序源代码作为附录包含在 Ben-Ari 的著作《并发编程原理》中。BACI 编译器和解释器的原始版本就是从该源代码创建的。最终，Pascal 编译器和解释器被分成两个独立的程序，并开发了 C-- 编译器，用于将用 C++ 的受限子集编写的源程序编译成可由解释器执行的 PCODE。

下面将解释 C-- 编译器的语法。本指南仅适用于 C-- 编译器，不适用于 BACI 并发 Pascal 编译器。对 Pascal 编译器感兴趣的用户应参考其用户指南（见文件 guidepas.ps）。

## 2. C-- 编译器语法

1. 如同 C++，注释可以用 '/*' 和 '*/' 或 '//' 来界定。

2. 除了标准输入和输出外没有其他文件：cout、cin 和 endl 在 C-- BACI 中的行为与标准 C++ 一致。主程序必须具有以下形式之一：
   ```c
   int main()
   void main()
   main()
   ```

3. C-- BACI 中唯一可用的简单 C/C++ 类型是 int 和 char。还有其他与并发控制相关的类型，将在下面讨论。

   所有变量必须在它们出现的代码块开头声明。特别是，for 循环的索引变量不能在循环头中声明，而必须在包含该 for 循环的块的开头声明。

4. 支持 string 类型。声明字符串时，必须指定字符串的长度。以下声明定义了一个长度为 20 的字符串：
   ```c
   string[20] string_name;
   ```

   长度说明符应该是字符串应具有的字符数，不应包括终止字节的空间。编译器负责为终止字节保留空间。长度说明符必须是字面常量或程序常量。

   在函数声明中，string 关键字用于声明 string 类型的参数：
   ```c
   void proc(string formal_parm)
   ```

   此声明断言 formal_parm 的类型为 string[n]，其中 n 为某个正值。string 类型的参数是通过引用传递的。不执行字符串溢出检查。

5. 支持任何有效类型的数组。数组声明遵循通常的 C 语法：
   ```c
   element_type arrayname[index1][index2][index3]...[indexN];
   ```

6. C-- BACI 支持关键字 typedef。例如，要使变量名 length 成为 int 的同义词：
   ```c
   typedef int length;
   ```

7. 支持简单类型的常量 (const)：
   ```c
   const int m = 5;
   ```

8. 在声明 int 和 char 类型的变量时，支持初始化器。初始化器的值必须是字面量或程序常量：
   ```c
   const int m = 5;
   int j = m;
   int k = 3;
   char c = 'a';
   ```

9. 支持过程和函数。适用标准作用域规则。支持递归。参数声明为传值或传引用：
   ```c
   int afunc(int a, /* 传值 */
           int& b) /* 传引用 */
   ```

   每个程序必须有一个 int 或 void 类型的 main() 函数，并且该函数必须是源文件中的最后一个函数。执行从 main() 的调用开始。

10. 可执行语句包括 if-else、switch/case、for、while、do-while、break 和 continue。这些语句的语法与标准 C/C++ 相同。代码的括号也是标准的，即 { ... }。

11. 支持标准 C/C++ 文件包含：
    ```c
    #include < ... >
    #include " ... "
    ```
    
    两种包含语句风格具有相同的语义，因为没有"系统"包含目录。

12. 支持用于定义外部变量的 extern 关键字。外部变量可以是任何有效的 C-- 类型。外部变量不能使用初始化器。extern 关键字只能出现在全局（"外部"）级别。典型示例：
    ```c
    extern int i;
    extern char a[20];
    extern string[30] b;
    // 不允许初始化器 ----> extern int i = 30;
    // (如果有初始化，必须在 i 定义的地方进行)
    extern int func(int k);
    extern monitor monSemaphore { // 见第 3 节。这里只需给出
      void monP();              // 管程的外部可见细节
      void monV();
    }
    ```

    使用 bacc 编译包含外部引用的源文件时，必须使用 -c 选项。有关使用外部变量的更多信息，请参阅 BACI 系统分离编译指南。

## 3. 并发结构

### 3.1 cobegin 块

C-- 进程是一个 void 函数。在 BACI 系统中，"并发进程"一词与"并发线程"一词同义。要并发运行的进程列表封装在一个 cobegin 块中。这种块不能嵌套，必须出现在主程序中。

```c
cobegin {
  proc1(...); proc2(...); ... ; procN(...);
}
```

列出的过程中的 PCODE 语句由解释器以任意的"随机"顺序交错执行，因此，包含 cobegin 块的同一程序的多次执行将表现为非确定性的。主程序被挂起，直到 cobegin 块中的所有进程终止，此时主程序在块结尾后的语句处恢复执行。

### 3.2 信号量

解释器有一个预先声明的 semaphore 类型。也就是说，C-- 中的信号量是一个非负整数变量（见下面的定义），只能以受限方式访问。二进制信号量，即只取值 0 和 1 的信号量，由 semaphore 类型的 binarysem 子类型支持。在编译和执行过程中，编译器和解释器强制限制 binarysem 变量只能取值 0 或 1，而 semaphore 类型只能是非负的。

#### 3.2.1 初始化信号量

只有在定义信号量变量时才允许对其赋值。例如，以下任一声明都是有效的：

```c
semaphore s = 17;
binarysem b = 0;
```

内置过程：

```c
initialsem(semaphore, integer_expression);
```

是在运行时初始化任一类型信号量的唯一可用方法。在调用中，integer_expression 可以是计算结果为整数且对信号量类型有效的任何表达式（semaphore 类型为非负，binarysem 类型为 0 或 1）。例如，以下两个 initialsem 调用显示了初始化上述两个信号量的另一种方式：

```c
initialsem(s, 17);
initialsem(b, 0);
```

#### 3.2.2 p (或 wait) 和 v (或 signal) 函数

p 函数（或同义的 wait）和 v 函数（或同义的 signal）由并发执行的进程用于同步它们的操作。这些函数为用户提供了更改信号量值的唯一方式。

这两个函数的原型如下：

```c
void p(semaphore& s);
```

或等效地：

```c
void wait(semaphore& s);
```

以及：

```c
void v(semaphore& s);
```

或等效地：

```c
void signal(semaphore& s);
```

每个函数的信号量参数显示为引用参数，因为函数会修改信号量的值。

p 和 v 函数调用的语义如下：

p(sem);
- 如果 sem > 0，则将 sem 减 1 并返回，允许 p 的调用者继续。
- 如果 sem = 0，则使 p 的调用者休眠。这些操作是原子的，即它们是不可中断的，从开始到结束执行。

v(sem);
- 如果 sem = 0 且一个或多个进程正在 sem 上休眠，则唤醒其中一个进程。如果没有进程在 sem 上等待，则将 sem 加一。在任何情况下，v 的调用者都被允许继续。这些操作是原子的，即它们是不可中断的，从开始到结束执行。
- v 的某些实现要求按 FIFO 顺序唤醒等待信号量的进程（队列信号量），但 BACI 符合 Dijkstra 的原始提议，在信号到达时随机选择要重新唤醒的进程。

#### 3.2.3 信号量使用示例

为帮助解释信号量的使用，我们提供以下简短示例：

```java
BACI System: C-- to PCODE Compiler, 09:24 2 May 2002
Source file: semexample.cm Sun Apr 28 20:40:12 2002
line pc
1 0 // C-- 信号量使用示例
2 0
3 0 semaphore count; // 一个"通用"信号量
4 0 binarysem output; // 一个二进制（0 或 1）信号量，用于解除输出混乱
5 0
6 0 void increment()
7 0 {
8 0 p(output); // 获取对标准输出的独占访问权
9 2 cout << "before v(count) value of count is " << count << endl;
10 6 v(output);
11 8 v(count); // 增加信号量
12 10 } // increment
13 11
14 11 void decrement()
15 11 {
16 11 p(output); // 获取对标准输出的独占访问权
17 13 cout << "before p(count) value of count is " << count << endl;
18 17 v(output);
19 19 p(count); // 减少信号量（或停止 -- 见手册文本）
20 21 } // decrement
21 22
22 22 main()
23 23 {
24 23 initialsem(count,0);
25 26 initialsem(output,1);
26 29 cobegin {
27 30 decrement(); increment();
28 36 }
29 37 } // main
```

该程序使用两个信号量。一个信号量 count 属于 semaphore 类型，这向 BACI 系统表明该信号量将被允许具有任何非负值。两个并发过程 increment 和 decrement 通过 count 信号量相互"发送信号"。另一个信号量 output 属于 binarysem 类型，这向 BACI 系统表明该信号量应始终具有值 0 或 1；任何其他值都会导致运行时异常。该信号量用于防止两个并发执行的过程 increment 和 decrement 的输出混合在一起。

我们使用以下命令生成上述编译器列表：

```bash
prompt% bacc semexample
Pcode and tables are stored in semexample.pco
Compilation listing is stored in semexample.lst
```

然后可以使用 BACI PCODE 解释器执行 semexample.pco 文件：

```bash
prompt% bainterp semexample
Source file: semexample.cm Sun Apr 28 20:40:12 2002
Executing PCODE ...
before v(count) value of count is 0
before p(count) value of count is 1
```

这是程序可能产生的三种可能输出之一。另外两种可能的程序输出是：

```bash
prompt% bainterp semexample
Source file: semexample.cm Sun Apr 28 20:40:12 2002
Executing PCODE ...
before p(count) value of count is 0
before v(count) value of count is 0
```

```bash
prompt% bainterp semexample
Source file: semexample.cm Sun Apr 28 20:40:12 2002
Executing PCODE ...
before v(count) value of count is 0
before p(count) value of count is 0
```

有兴趣的读者可能会发现，提供这三种程序输出生成方式的解释，并证明这三种输出是唯一可能的输出，是很有指导意义的。

### 3.3 管程

支持 Hoare 提出的管程概念，但有一些限制。管程是一个 C-- 块，类似于由过程或函数定义的块，但具有一些额外的属性。管程块中的所有函数都是可见的（即可从块外部调用的入口过程），但管程变量在块外部不可访问，并且只能由管程函数访问。

在 C-- 中，管程只能在最外层、全局级别声明。管程不能嵌套。管程可以选择在最后一个块中有一个 init{} 块，用于初始化管程变量的值。这段代码在主程序启动时运行。

管程块的只有一个过程或函数可以在任何时候执行。这一特性使得可以使用管程来实现互斥。使用管程控制并发是有优势的，因为所有控制并发的代码都位于管程中，而不是像使用信号量那样广泛分布在调用者中。

管程的过程和函数使用三种结构来控制并发：条件变量、waitc（等待条件）和 signalc（表示条件）。

#### 3.3.1 条件变量

条件变量只能在管程中定义，因此只能由管程的进程访问。条件变量实际上从不"有"值；它是等待的地方或信号的东西。管程进程可以通过 waitc 和 signalc 调用等待条件成立或表示给定条件现在成立。

#### 3.3.2 waitc 和 signalc 函数

waitc 和 signalc 调用具有以下语法和语义：

```c
void waitc(condition cond, int prio);
```

管程进程（因此，也是调用管程进程的外部进程）被阻塞并被分配优先级 prio 以便被重新唤醒（见下面的 signalc）。请注意，这种阻塞操作允许另一个管程进程执行，如果有的话。

```c
void waitc(condition cond);
```

此调用具有与上面的 waitc 调用相同的语义，但等待被分配默认优先级 10。

```c
void signalc(condition cond);
```

唤醒在 cond 上等待的、具有最小（最高）优先级的某个进程；否则，不执行任何操作。请注意，这与信号量 v 或 signal 完全不同，因为如果没有人等待，signalc 是一个空操作，而 v(sem) 在没有人等待时会增加 sem，从而在将来的 p(sem) 发生时"记住"该操作。

优先级方案可用于实现重新唤醒等待者的 FIFO 规则。如果每个管程进程都增加与当前分配给条件的优先级相关联的管程变量，那么对该条件的连续 signalc 将按照 FIFO 顺序唤醒休眠进程。

C-- 编译器提供了一个 int 函数 empty(cond)，如果条件 cond 的队列中没有进程等待，则返回 1，否则返回 0。

#### 3.3.3 立即恢复要求

这是指刚刚被发送信号的条件上等待的进程应该优先于新调用管程进程（那些想要"从顶部"进入的进程）重新进入管程的要求。该要求基于这样的假设：刚刚被发送信号的条件比新进入管程的情况具有更"紧急"的业务要执行。立即恢复要求在 BACI 中通过挂起条件的发送者并随机选择一个具有适当优先级的条件等待者来运行来实现。因此，signalc 条件的管程过程通常将其作为最后一条指令。

当被 signalc 重新唤醒的进程离开管程时，在发出 signalc 调用后被挂起的在管程中执行的进程被允许优先于尝试"从顶部"进入管程的进程恢复在管程中的执行。

#### 3.3.4 管程示例

以下通过管程实现通用信号量的示例说明了管程语法：

```c
monitor monSemaphore {
  int semvalue;
  condition notbusy;
  void monP()
  {
    if (!semvalue)
      waitc(notbusy);
    else
      semvalue--;
  }
  void monV()
  {
    if (empty(notbusy))
      semvalue++;
    else
      signalc(notbusy);
  }
  init{ semvalue = 1; }
} // monSemaphore 管程结束
```

### 3.4 其他并发结构

BACI C-- 提供了几个低级并发结构，可用于创建新的并发控制原语：这些函数可用于创建"公平"（FIFO）队列信号量。实现这一点的代码超出了本用户指南的范围。

#### 3.4.1 atomic 关键字

如果一个函数被定义为 atomic，那么该函数是不可抢占的。解释器不会用上下文切换中断一个原子函数。这为用户提供了定义新原语的方法。以下程序说明了如何定义 test_and_set 原语并使用它来强制互斥：

```c
atomic int test_and_set(int& target) {
  int u;
  u = target;
  target = 1;
  return u;
}

int lock = 0;

void proc(int id) {
  int i = 0;
  while(i < 10) {
    while (test_and_set(lock)) /* wait */ ;
    cout << id;
    lock = 0;
    i++;
  }
}

main() {
  cobegin { proc(1); proc(2); proc(3); }
}
```

#### 3.4.2 void suspend(void);

suspend 函数使调用线程休眠。

#### 3.4.3 void revive(int process_number);

revive 函数重新激活给定编号的进程。

#### 3.4.4 int which_proc(void);

which_proc 函数返回当前线程的进程编号。

#### 3.4.5 int random(int range);

random 函数返回一个在 0 到 range - 1（包含）之间"随机选择"的整数。它使用与解释器使用的不同的随机数生成器流；也就是说，random() 调用不会影响解释器执行。

## 4. 内置字符串处理函数

### 4.1 void stringCopy(string dest, string src);

stringCopy 函数将 src 字符串复制到 dest 字符串中。不执行字符串溢出检查。例如：

```c
string[20] x;
...
stringCopy(x,"Hello, world!");
stringCopy(x,"");
```

将把字符串 x 初始化为一个众所周知的值。第二个 stringCopy 将字符串 x 重置为零长度字符串。

### 4.2 void stringConcat(string dest, string src);

stringConcat 函数将 src 字符串连接到 dest 的末尾。不执行字符串溢出检查。

### 4.3 int stringCompare(string x, string y);

stringCompare 函数与 C 字符串库中的 strcmp 函数具有相同的语义：如果字符串 x 按字典顺序在字符串 y 之后，则返回正数；如果字符串相等，则返回零；如果字符串 x 按字典顺序在字符串 y 之前，则返回负数。

### 4.4 int stringLength(string x);

stringLength 函数返回字符串 x 的长度，不包括终止字节。

### 4.5 int sscanf(string x, rawstring fmt,...);

与"真正的" sscanf 一样，sscanf 函数根据格式字符串 fmt 扫描字符串 x，将扫描到的值存储到参数列表中提供的变量中，并返回扫描到的项目数。仅支持真正的 sscanf 的 %d、%x 和 %s 格式说明符。还支持 BACI 独有的附加格式说明符 %q（带引号的字符串）。对于此说明符，所有由一对双引号（"）分隔的字符都将被扫描到相应的字符串变量中。当在格式字符串中遇到 %q 说明符时，如果要扫描的字符串中的下一个非空白字符不是双引号，则 %q 扫描失败，并且字符串的扫描终止。

格式字符串后面出现的变量是引用变量（即，不需要 & 符号）。

在以下示例中，sscanf 调用返回的 i 值将为 4，存储在变量 j 中的值将为 202，存储在字符串 x 中的字符串值将为 alongstring，存储在变量 k 中的值将为 0x3c03，存储在字符串 y 中的字符串将为 a long string。

```c
string[50] x,y;
int i,j,k;
stringCopy(x,"202 alongstring 3c03 \"a long string\"");
i = sscanf(x,"%d %s %x %q",j,x,k,y);
```

### 4.6 void sprintf(string x, rawstring fmt,...);

与 C 库中的"真正的" sprintf 函数一样，sprintf 函数使用格式字符串 fmt 和格式字符串后面的变量创建存储在变量 x 中的字符串。

支持 %d、%o、%x、%X、%c 和 %s 格式说明符，其全部功能与真正的 sprintf 相同。此外，%q 格式说明符将在输出字符串中插入带双引号的字符串。%q 格式说明符等同于 \"%s\" 说明符。

例如，在以下代码片段中：

```c
string[80] x;
string[15] y,z;
stringCopy(y,"alongstring");
stringCopy(z,"a long string");
sprintf(x,".%12d. .%-20s. .%q. .%08X.",202,y,z,0x3c03);
```

字符串 x 变为：

```
. 202. .alongstring . ."a long string". .00003C03.
```

## 5. 使用 BACI C-- 编译器和 PCODE 解释器

使用 BACI 系统执行程序有两个步骤。

1. 编译 ".cm" 文件以获取 ".pco" 文件。

   用法：bacc [可选标志] 源文件名

   可选标志：
   ```
   -h 显示此帮助
   -c 创建一个 .pob 目标文件以便后续链接
   ```
   源文件名是必需的。如果缺少，您将被提示输入。如果您不提供，将附加文件后缀 ".cm"。

2. 解释 ".pco" 文件以执行程序

   用法：baininterp [可选标志] pcode文件名

   可选标志：
   ```
   -d 进入调试器，单步执行，设置断点
   -e 在进入每个进程时显示活动记录 (AR)
   -x 在退出每个进程时显示 AR
   -t 宣布进程终止
   -h 显示此帮助
   -p 显示正在执行的 PCODE 指令
   ```
   PCODE 文件名是必需的。如果缺少，您将被提示输入。文件后缀 ".pco" 将附加到您给出的文件名。

每次用 bainterp 执行 .pco 文件时，不必重新编译源文件。有一个 shell 脚本 baccint，它将为您调用编译器，然后调用解释器。它会将您给它的选项（见上文）传递给解释器。

## 6. 示例程序和输出

以下列表由 C-- BACI 编译器生成。行号右侧的数字是开始该行的指令的 PCODE 偏移量。BACI 编译器从文件 "incremen.cm" 创建此列表。该列表被放置在文件 "incremen.lst" 中。还创建了一个 "incremen.pco" 文件；此文件由解释器使用。

```java
BACI System: C-- to PCODE Compiler, 09:24 2 May 2002
Source file: incremen.cm Wed Oct 22 21:18:02 1997
line pc
1 0 const int m = 5;
2 0 int n;
3 0
4 0 void incr(char id)
5 0 {
6 0 int i;
7 0
8 0 for(i = 1; i <= m; i = i + 1)
9 14 {
10 14 n = n + 1;
11 19 cout << id << " n =" << n << " i =";
12 25 cout << i << " " << id << endl;
13 31 }
14 32 }
15 33
16 33 main()
17 34 {
18 34 n = 0;
19 37 cobegin
20 38 {
21 38 incr( 'A'); incr( 'B' ); incr('C');
22 50 }
23 51 cout << "The sum is " << n << endl;
24 55 }
```

以下列表由 BACI 解释器生成。解释器执行编译到文件 "incremen.pco" 中的程序。

```java
Source file: incremen.cm Wed Oct 22 21:18:02 1997
Executing PCODE ...
C n =1 i =A n =1 C2 i =
1 A
C n =4 i =2 C
B n =A n =5 i =24 A
i =1 B
AC n = n =6 i =3 C6 i =3
A
C n =7 i =4 C
B n =9 i =2 BA n =8
i =4 A
C n =8 i =5 A n =9C
i =5 A
B n =10 i =3 B
B n =11 i =4 B
B n =12 i =5 B
The sum is 12
```


# linux环境运行baci

- 首先安装jdk和dos2unix
```
apt install jdk-openjdk  dos2unix
```
- 使用dos2unix转换格式
```
dos2unix ~/Git/java/baci/scripts/baci
```

- 编写baci脚本
```bash
#!/usr/bin/env bash
# 定位到项目根目录（包含 javabaci 子目录的目录）
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 将 javabaci/bin（默认包类）和项目根目录（javabaci 包根）加入 classpath
CLASSPATH="$BASEDIR/javabaci/bin:$BASEDIR"

# 将所有参数原样传递给 java 运行
exec java -cp "$CLASSPATH" "$@"
```

- 给baci授予可执行权限
```bash
chmod +x ~/Git/java/baci/scripts/baci
```
- 添加系统环境变量
```bash
fish_add_path ~/Git/java/baci/scripts
```
- 查看baci是否存在
```bash
which baci
```
- 现在即可编译运行
```bash
baci bacc ex3_1.cm
baci bainterp ex3_1
```

---
**Done.**