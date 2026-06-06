+++
title = "乱七八糟:服务端开发考试"
date = 2026-06-06

[taxonomies]
tags = ["乱七八糟"]
+++

前言 本文记录服务端开发课程复习资料.
<!-- more -->
# 总纲

## 题型与分值

- 选择题 15*1 = 15分
- 判断题 10*1 = 10分
- 填空题 20*1 = 20分
- 简答题 5*5  = 25分
- 设计题 3*10 = 30分

# 课程内容

## 第1章 服务端开发技术概述

### 1.1 课程简介

**课程安排：**

- 1-3周：掌握 Spring Boot 核心机制与全家桶生态
- 4-6周：持久层开发与基础集成: MyBatis-Plus
- 7-10周：前后端分离联调与跨域处理
- 11-16周：复杂场景与通用Web服务开发、容器部署

---

### 1.2 Spring架构演进史

#### 洪荒时代：CGI 与早期静态网页 (1995 以前)

- 接收请求 -> 寻找本地 HTML 文件 -> 直接返回
- 1个请求 = 1个新进程
- 缺乏动态交互能力（无法登录、无数据库交互）

#### 大杂烩时代：Servlet 与 JSP (1996 - 1999)

- 动态网页诞生：Servlet 处理逻辑，JSP 处理页面展示
- 运行特征：在 HTML 标签中强行嵌入 Java 代码
- 服务端"全包"，既处理数据库查询，又负责渲染 UI 页面

**痛点：**
- 代码可读性极差："意大利面条"式的混编代码
- 服务器压力大：渲染页面的计算消耗大量服务端 CPU 资源
- 调试困难：前后端 Bug 难以界定和排查

#### 企业王朝：EJB 与 J2EE (1999 - 2004)

- Java 2 Platform, Enterprise Edition（Java 2 平台企业版），后改名为 Java EE
- J2EE 不是具体软件或框架，而是一套极其庞大的"官方标准规范"
- Servlet、JSP、JDBC（数据库连接）、JMS（消息队列）全都属于 J2EE
- **配置极其冗长的 XML 描述文件**

#### Spring 框架诞生（2004）

**OOP 核心：** 封装（隐藏内部细节）、继承（复用代码）、多态（"一个接口多种玩法"）

**OOP 痛点：**
- 手动 new 对象 → 类与类依赖紧密
- 重复代码多（如日志、异常处理）
- 企业级功能（事务、权限）实现复杂
- 跨程序通信麻烦 → 缺乏统一标准

**问题的本质：** 对象的创建和对象的使用耦合在一起

#### IoC（Inversion of Control）控制反转

一种设计思想，将对象创建、依赖关系管理交给容器处理。IoC 是"思想"，不是技术。

**DI（依赖注入）：** IoC 的实现方式，通过容器将依赖关系注入到组件中——"容器把我需要的对象塞进来"。

#### XML：曾经的万能神药

- 本质：结构化纯文本数据存储格式
- J2EE 时代痛点：硬编码在 .java 里，改参数需重新编译部署
- XML 解救：参数抽离到 .xml 文件，运行时读取，改参数只需改文本

#### 架构演进时间线

| 时期 | 时代 | 特点 |
|------|------|------|
| 1995 以前 | CGI 脚本时代 | 性能极低，稍有高并发即宕机 |
| 1996 - 1999 | Servlet 与 JSP 诞生 | 严重耦合，"意大利面条式代码" |
| 1999 - 2004 | J2EE 与 EJB 霸权 | 简单功能需大量接口和繁琐配置 |
| 2004 - 2012 | Spring 框架 | IoC 和 AOP 解耦；但过度依赖 XML |
| 2014 - 2022 | Spring Boot 时代 | 约定优于配置；Starter 自动装配和内嵌 Tomcat |
| 2022 至今 | Spring Boot 3.x + Vue 3 | 彻底前后端分离；工业级最优解 |

---

### 1.3 Spring Boot 核心理念

#### 核心理念一：约定优于配置

框架为几乎所有技术选型提供"默认最优解"。没有特殊要求就什么都不用配；只有当想改变默认规则时，才需要写配置。

`@Controller`、`@Service`、`@Autowired`——这些注解直接告诉 Spring 如何处理。配置与代码合二为一。

**Spring Boot 启动时做三件事：**
1. 找到所有交给它管理的类
2. 把它们创建成对象
3. 看到 `@Autowired`，就把合适的对象放进去

> 只有被 Spring 管理的对象，才能被 `@Autowired` 注入

#### 核心理念二：启动器 (Starters) 开箱即用

`spring-boot-starter-web` 自动拉取 Web 接口所需的所有底层组件，按完美兼容版本一次性下载。在 `pom.xml` 中写下需要的组件名，Maven 自动联网下载。

#### 核心理念三：内嵌服务器

内置 Tomcat，无需额外部署 WAR 包。

---

### 1.4 环境配置与 Git 团队协作

**开发环境：**
- JDK 17
- 关系型数据库引擎：PostgreSQL 17.8.1
- 数据库图形化管理工具：pgAdmin4 8.14
- 集成开发环境 (IDE)：IntelliJ IDEA 2025.3
- 项目构建与依赖管理：Apache Maven 3.9.12
- 版本控制客户端：Git 2.53.0

**项目初始化：** https://start.spring.io/

**Spring 生态模块：**
- **Spring AOP**：面向方面编程，方法拦截，支持 AspectJ
- **Test**：支持 Spring 应用的各类测试
- **Spring Security**：安全框架
- **Spring Data**：数据库访问（关系型和非关系型），Repository 机制
- **Spring Boot**：简化应用开发，自动配置
- **Spring WebFlux**：响应式编程支持，异步非阻塞

#### GitHub 页面功能

- **`<> Code`**：获取仓库专属 URL 链接（HTTPS 或 SSH），下载云端代码到本地
- **README.md**：项目"说明书"或"门面"，用 Markdown 记录启动步骤、接口文档地址
- **Issues**：任务与缺陷跟踪，"留言板"和"任务清单"，做完一个关一个
- **Pull requests（PR）**：代码合并请求，需 Code Review 后合并
- **Actions**：CI/CD 自动化流水线，代码推送即自动编译打包重启

---

## 第2章 Git操作与核心注解

### 1.5 Git 上传与新建分支

#### HTTPS 方式

在 IDEA 里点击 Log In via GitHub，跳转浏览器授权（OAuth），或在控制台输入 Personal Access Token (PAT)。

```bash
git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/xxx.git
git push -u origin main
```

HTTPS 走 Port 443，本质是加密网页数据提交。国内网络环境下易遭遇 10054、Connection reset 等阻断报错。

#### SSH 方式（附加题）

必须提前生成非对称加密密钥（Ed25519 或 RSA），将公钥配置到 GitHub，IDEA 读取本地私钥进行静默认证。走 Port 22。

```bash
ssh-keygen -t ed25519 -C "邮箱@xxx.com"   # 生成密钥对，敲三下回车
cat ~/.ssh/id_ed25519.pub                  # 提取公钥
ssh -T git@github.com                      # 测试连接（第一次输入 yes）
```

**绑定远程链接：**
```bash
git remote add origin https://github.com/xxx.git    # 绑定 HTTPS
git remote set-url origin git@github.com:xxx/xxx.git  # 更换为 SSH
```

| 对比 | HTTPS 协议 | SSH 协议 |
|------|-----------|----------|
| 认证方式 | 账号授权 (OAuth) 或动态 Token | 非对称加密密钥对 |
| 通信端口 | 443 端口 | 22 端口 |
| 使用体验 | Token 过期需重置；受代理干扰大 | 一次配置，丝滑推送 |
| 国内网络 | 极易遭遇阻断报错 | 穿透力强 |
| 企业规范 | 较少用于核心代码库 | 行业标准 |

---

### 1.6 Git 常用操作

#### 分支管理

- 主页手动新建个人分支
- IDEA 中点击 Push 上传到指定分支

#### 工作区与仓库

- **暂存区 (Staging Area / Index)**：Commit 按钮 → 打包成 .git 文件夹，放本地仓库
- **远程仓库 (origin)**：Push 按钮上传到云端

#### Fetch / Update

从远程拉取最新代码。

---

### 2.1 控制反转 IoC 与 DI

**IoC（控制反转）：** 设计思想，将对象创建、依赖关系管理交给容器。是"思想"不是技术。

**DI（依赖注入）：** IoC 的实现方式，容器将依赖注入到组件中。

#### Spring 启动时做的三件事

1. 让容器找到所有交给它管理的类
2. 把它们创建成对象
3. 看到 `@Autowired`，就把合适的对象放进去

> 只有被 Spring 管理的对象，才能被 `@Autowired` 注入

#### 依赖注入匹配规则

**第一步：默认按类型匹配（By Type）——绝对的第一顺位**

检查 `@Autowired` 标注的变量的数据类型。如果全场只找到 1 个该类型 Bean，直接注入。

```java
@Autowired
private UserService userService;  // 按 UserService 类型查找
```

**第二步：降级按名称匹配（By Name）——类型冲突时的替补方案**

当按类型找到多个候选人时，Spring 退而求其次，去看变量名匹配。

---

### 2.2 Spring Boot 核心注解

#### 组件注解

| 注解 | 层级 | 作用 |
|------|------|------|
| `@Component` | 通用 | 任意组件，取代 XML 的 `<bean>` 标签 |
| `@Service` | 业务层 | 业务逻辑 |
| `@Repository` | 持久层 | 数据访问 |
| `@Controller` | 控制层 | 接收请求 |

> `@Controller`、`@Service`、`@Repository` 底层功能与 `@Component` 毫无区别，纯粹为了代码"自解释"

`@Autowired`：取代 XML 的 `<property>` 标签，自动赋值。

#### 各层职责

- **Controller** → 接请求，接受参数和请求
- **Service** → "大脑"：写业务，业务流程、规则
- **Repository** → 操作数据库的增删改查

#### 配置与 Bean 注解（Spring Boot 3.0）

- `@Configuration`：告诉 Spring "这个 Java 类用来替代 `applicationContext.xml`"
- `@Bean`：贴在方法上，相当于以前 XML 的 `<bean>` 标签，用纯 Java 代码创建第三方对象交给 Spring 管理

#### RESTful 接口注解

- `@RestController` = `@Controller` + `@ResponseBody`，所有方法返回数据
- `@RequestMapping`：定义接口 URL 和 HTTP 方法
- `@GetMapping`：GET 方法（查询，幂等、安全）
- `@PostMapping`：POST 方法（新增，非幂等）
- `@PutMapping`：PUT 方法（全量更新，幂等）
- `@DeleteMapping`：DELETE 方法（删除，幂等）
- `@PathVariable`：获取 URL 路径中的参数
- `@RequestBody`：接收客户端传来的 JSON 数据

#### RESTful 设计风格

**资源（Resource）：** 用户 → `/users`，订单 → `/orders`

**HTTP 方法（动作）：**

| 方法 | 含义 |
|------|------|
| GET | 查询 |
| POST | 新增 |
| PUT | 修改 |
| DELETE | 删除 |

**状态码：** 200 成功、201 创建成功、400 参数错误、404 资源不存在

**测试：** 启动 Spring 项目 → 打开 Postman → 选择 HTTP 方法 → URL `http://localhost:8080/users` → Body → raw → JSON

---

## 第3章 RESTful Web与Service业务层

### 3.1 构建标准 RESTful Web 服务

#### 核心理念

- 每个资源都必须有一个绝对唯一的 URI 指向它
- 互联网不是动作的集合，而是"资源"的集合——图片、商品、订单，这些叫做资源
- **URL 中不再包含动词！动作由 HTTP 协议本身的动词（Method）来承载**

#### 四大操作

| 操作 | HTTP 方法 |
|------|----------|
| 查询 | GET |
| 新增 | POST |
| 修改 | PUT |
| 删除 | DELETE |

#### @PathVariable（路径变量）

- **位置**：URL 路径 `/users/1` 内部
- **作用**：捕获藏在 URL 路径内部的变量
- **场景**：定位具体、唯一的核心资源实体（如查询 ID 为 1 的用户）

#### @RequestParam（查询参数）

- **位置**：URL 问号 `?` 后面，如 `?status=1&page=2`
- **作用**：精准提取 Query String 中的散装参数
- **场景**：模糊搜索、范围筛选、分页处理等附加条件

#### @RequestHeader（截获隐蔽头信息）

- **位置**：HTTP 请求头，如 `Authorization: Bearer xyz123`
- **作用**：截获请求头中的隐藏数据
- **场景**：全站无状态身份认证——前端登录后拿到 JWT，后续请求将 Token 塞在头部，后端通过该注解抓取令牌进行权限校验

#### JSON

JSON（JavaScript Object Notation）是一种极其轻量级的数据交换格式。

- **对象 (Object)**：`{}` 包裹，键值对
- **数组 (Array)**：`[]` 包裹，有序值集合

---

### 3.2 API 设计原则

**核心原则一：命名**

URL 只能包含**名词**，尽量不能包含动词。资源命名通常使用复数。

| 错误示例 | 正确示例 |
|----------|---------|
| `/getUser?id=1` | `GET /users/1` |
| `/createOrder` | `POST /orders` |
| `/deleteArticle/10` | `DELETE /articles/10` |

**核心原则二：集合**

统一使用复数形式。

| 混乱 | 规范 |
|------|------|
| `/user` 查列表 + `/user/1` 查单个 | `GET /users` 集合 + `GET /users/1` 个体 |

**核心原则三：使用连字符（-）**

| 混乱 | 规范 |
|------|------|
| `/userProfiles` (驼峰) | `/user-profiles` |
| `/user_profiles` (下划线) | `/user-profiles` |

**最终原则："团队一致"**

以上规则是行业最佳实践，但具体项目中最重要的是团队内部达成一致并坚持执行。无论选择哪种风格，统一比完美更重要。

---

### 3.3 状态码

#### HTTP 原生状态码（网络层）——5 类

**2xx（成功）：** 200 OK

**3xx（重定向）：** 301/302 网址跳转

**4xx（客户端/前端的锅）：**
- 400 Bad Request：参数格式不对
- 401 Unauthorized：未登录，没有合法 Token
- 403 Forbidden：已登录但权限不足
- 404 Not Found：接口路径写错
- 405 Method Not Allowed：方法不匹配（后端用 POST，前端用 GET）

**5xx（服务端/后端的锅）：**
- 500 Internal Server Error：代码写炸了（空指针、除以 0 等）

#### 自定义业务状态码

在 common 公共包中：
1. 定义全局枚举类
2. 在 `Result<T>` 统一响应类或 `BusinessException` 中调用

#### Result 统一响应类

封装统一响应体 `Result<T>` 或抛出自定义业务异常 `BusinessException`。

---

### 3.4 拦截器控制

#### 请求处理链

```
HTTP 请求 → Filter (过滤器) → Interceptor (拦截器) → AOP (切面) → Controller 方法
```

#### 过滤器 (Filter) —— 最外层

- 属于 Web 容器级别，不依赖 Spring
- 在请求到达 `DispatcherServlet` 之前被拦截
- 实现 `javax.servlet.Filter` 接口，重写 `doFilter` 方法
- **适用场景**：处理乱码、跨域

#### 拦截器 (Interceptor) —— Spring 专属

- Spring MVC 框架独有
- 请求已进入 Spring 容器，但在到达 Controller 方法之前
- 实现 `HandlerInterceptor` 接口，重写 `preHandle`、`postHandle`、`afterCompletion`
- 在 Config 层实现 `WebMvcConfigurer` 进行路径注册
- **适用场景**：JWT Token 登录鉴权、RBAC 权限校验、记录请求耗时

#### Spring Security / Shiro / Sa-Token

专业安全框架，基于 Filter Chain 或 AOP 实现。适用场景：
- 复杂单点登录（SSO）
- 动态细粒度权限控制（按钮级、接口级）
- OAuth2.0 第三方授权体系

#### 选择建议

- 处理乱码、跨域 → **Filter**
- 通用 Token 登录校验 → **Interceptor**
- 权限校验系统 → **Spring Security**

---

## 第4章 Service业务层与数据库基础

### 4.1 Service 层设计

#### 调用链

```
Controller → Service → ServiceImpl → Mapper → Database
```

#### 两种写法

- **单个 Service 类**：简单项目
- **Service 接口 + ServiceImpl 实现类**：企业级推荐

**类比：** `UserService`（接口）= 岗位要求：厨师；`UserServiceImpl`（实现类）= 具体员工：王大厨

#### 面向接口编程的价值

假设用户信息改为从云端查：

**单类方案（痛苦）：** 重写业务逻辑 → 全局搜索所有 Controller → 逐一改为 `CloudUserService` → 一百个 Controller 改一百次

**接口方案（优雅）：**
```java
@Autowired
private UserService userService;  // Controller 代码不用改！
```
1. 新建 `CloudUserServiceImpl` 加 `@Service`
2. 删掉 `LocalUserServiceImpl` 的 `@Service`

#### 底层原理：表面声明接口，实际注入实现类

Spring 使用 `@Autowired` 进行自动装配时：

1. **先实例化（启动时）**：扫描到 `@Service` → `new UserServiceImpl()` → 放 IoC 容器
2. **类型匹配（寻找过程）**：Controller 需要 `UserService` 类型 → Spring 去容器里找
3. **完成注入（偷梁换柱）**：找到 `UserServiceImpl` → 赋值给 Controller 的 `userService` 变量

---

### 4.2 DTO 详解与数据流转

#### Entity vs DTO

| 对比 | Entity | DTO |
|------|--------|-----|
| 作用 | 数据库映射 | 数据传输 |
| 安全性 | 低 | 高 |
| 字段 | 完整（含密码） | 按需暴露 |
| 使用层 | Mapper | Controller/Service |

#### Entity（与数据库一一对应）

- 对应表结构
- 包含全部字段
- 可能包含敏感信息（密码）

#### DTO（Data Transfer Object，数据传输对象）

- 接收前端参数
- 返回给前端
- 放在 `model` 文件夹

#### 直接用 Entity 的风险

- **安全问题**：多字段暴露
- **过度提交（Over-posting）**：黑客可恶意塞入 `is_admin: 1` 或 `balance: 99999` 越权篡改
- **前后端强耦合**

#### DTO 核心价值

- **安全**：防止过度提交攻击
- **解耦**：前后端独立演化
- **灵活**：按需组装字段

---

### 4.3 登录功能

#### Service 层 login 方法流程

```
1. 查库 → 2. 密码比对 → 3. 签发令牌 → 4. 包装返回
```

**1. 查库捞人（验证账号是否存在）：**
调用 Mapper，根据用户名执行 SELECT。查不到 → `Result.error(用户不存在)`

**2. 密码比对：**
提取数据库密码，与前端密码比对。数据库绝不存明文，调用 `BCrypt.checkpw()` 等加密算法进行暗文比对。对不上 → `Result.error(密码错误)`

**3. 签发令牌（生成 Token）：**
系统发"通行证"——UUID 或 JWT 字符串，证明登录成功

**4. 包装返回（统一响应）：**
将 Token 放进 `Result.success(token)` 中返回

#### Controller 接入

1. 把 HTTP 请求里的 JSON 解析成 `UserDTO` 对象
2. 调用 `userService.login(userDTO)` 联动
3. Service 拿到 DTO → 查数据库 → 判断密码 → 生成 Token → 返回 Result
4. Controller 拿到 Result → 直接转换为 JSON 响应给前端

---

### 4.4 数据持久化

#### 关系型数据库 (RDBMS)

基于"表（Table）+ 行（Row）+ 列（Column）"存储数据。

**特点：**
- 结构固定（Schema），每列必须固定
- 使用 SQL 语言
- 支持事务（ACID）
- 强一致性

**常见产品：** MySQL（常用）、Oracle（企业级）、PostgreSQL（开源强大）

#### 非关系型数据库（NoSQL）

不基于表结构，数据存储更灵活（如 JSON）。

**特点：**
- 无固定结构（Schema-Free），每条数据可以不同
- 高性能、高并发
- 易扩展（分布式）
- 弱一致性（部分）

**常见产品：** MongoDB（文档型）、Redis（缓存型）

#### 对比

| 对比项 | 关系型数据库 | 非关系型数据库 |
|--------|-------------|---------------|
| 数据结构 | 表 | JSON / Key-Value |
| 模式 | 固定 Schema | 灵活 Schema |
| 事务 | 强（ACID） | 弱（部分支持） |
| 扩展性 | 较弱 | 强（分布式） |
| 性能 | 中等 | 高 |
| 适用场景 | 业务系统 | 高并发/大数据 |

#### FAQ

**Q1：为什么需要 NoSQL？**
- 关系型数据库扩展困难
- 高并发性能不足
- 数据结构不灵活

**Q2：能不能只用一种数据库？**
- 典型组合：MySQL（主数据库）+ Redis（缓存加速）
- "银行用 MySQL，因为不能错一分钱"
- "抖音用 Redis，因为要快"

| 组件 | 本质 | 作用 |
|------|------|------|
| MySQL | 数据库 | 存数据 |
| Redis | 数据库 | 快速缓存 |
| MyBatis | 框架 | 操作数据库 |

---

## 第5章 数据持久层

### 5.1 ORM 框架

#### ORM（Object Relational Mapping，对象关系映射）

一种用"对象"来操作数据库"表"的技术——"翻译官"。

| 概念 | 映射 |
|------|------|
| 类 | 表 |
| 属性 | 字段 |
| 对象 | 记录 |

#### JDBC（Java Database Connectivity）

Java 访问关系型数据库的标准 API，通过统一接口规范与不同数据库交互。

#### 持久层的演进史 = "程序员偷懒史"

从手动写 JDBC 到全自动 ORM，本质上是在不断提高抽象层次，让开发者少写重复的 SQL 代码。

| ORM 类型 | 代表框架 | 是否写 SQL |
|----------|---------|------------|
| 全自动 ORM | Hibernate / JPA | 基本不写 |
| 增强 ORM | MyBatis-Plus | 少量 |
| 半自动 ORM | MyBatis | 手写 |
| 底层 | JDBC | 手动操作 |

- JDBC 是手动操作 SQL 的底层技术
- ORM 是基于 JDBC 的高级封装技术

---

### 5.2 MyBatis-Plus 增强式开发

#### 使用步骤

1. 引入 MyBatis-Plus 与数据库驱动依赖
2. 配置 YAML 数据源连接（url、username/password、driver-class-name）
3. 启用 Mapper 扫描（`@MapperScan`）
4. Mapper 层继承 `BaseMapper<T>`
5. 通过 Service 调用 Mapper 完成数据访问

#### 启动失败先检查

1. 数据库服务根本没启动
2. 库名拼错
3. 本地端口不是默认端口

#### @MapperScan

MyBatis-Plus 启动时扫描 Mapper 接口，动态生成代理对象，交给 Spring 容器管理。

> Service 和 Mapper 接口都可以被注入，但 Service 是真实实现类，Mapper 是动态代理

#### BaseMapper<T> 内置 CRUD

| 操作 | 方法 |
|------|------|
| 增 | `insert` |
| 删 | `deleteById` |
| 改 | `updateById` |
| 查单条 | `selectById` |
| 查多条 | `selectList` |
| 全查 | `selectList(null)`（谨慎使用） |

#### QueryWrapper：条件构造器

动态生成 SQL WHERE 条件的 Java 工具类。

| 方法 | 含义 | 示例 |
|------|------|------|
| `eq` | 等于 | `wrapper.eq("brand", "苹果")` |
| `ge` | 大于等于 | `wrapper.ge("price", 5000)` |
| `like` | 模糊查询 | `wrapper.like("color", "黑")` |
| `ne` | 不等于 | `ne("name", "老王")` |
| `gt` | 大于 | `gt("age", 18)` |
| `lt` | 小于 | `lt("age", 18)` |
| `groupBy` | 分组 | `groupBy("id", "name")` |

#### LambdaQueryWrapper

- 使用方法引用替代字符串字段名
- 降低拼写错误风险
- 重构时更安全，IDE 更容易跟踪

#### IService 接口

MyBatis-Plus 服务层通用接口，封装常见方法：

- **插入**：`save()`、`saveBatch()`
- **插入/更新**：`saveOrUpdate()`、`saveOrUpdateBatch()`
- **删除**：`removeById()`、`removeByMap()`、`remove()`
- **查询**：`getById()`、`list()`、`listByIds()`、`count()`
- **分页**：`page()`（需配置分页插件）

#### 实战练习

已知 User 实体类包含字段：`id` (Long)、`username` (String)、`age` (Integer)、`deleted` (Integer)。

1. 查询 id=1 的用户信息，并保存到 user 对象中

```java
User user = userMapper.selectById(1L);
```

2. 查询年龄大于 20 岁的所有用户，并保存到 users 集合中

```java
QueryWrapper<User> wrapper = new QueryWrapper<>();
wrapper.gt("age", 20);
List<User> users = userMapper.selectList(wrapper);
```

3. 将 id=2 的用户年龄修改为 25

```java
User user = new User();
user.setId(2L);
user.setAge(25);
userMapper.updateById(user);
```

> 注意：必须设置主键 id，否则 `updateById` 无法定位目标记录。

---

### 5.3 Spring Data JPA 声明式开发

#### JPA（Java Persistence API）

Java 官方持久化规范，常见实现为 Hibernate。

- **核心理念**：你只管操作对象，SQL 的生成交给框架
- **核心注解**：`@Entity`、`@Table`、`@Id`、`@Column`

#### 使用步骤

1. 引入依赖
2. 配置 YAML
3. 定义 Entity 实体类
4. 创建 Repository 接口（继承 `JpaRepository`，类似 BaseMapper）
5. Service 层调用

#### Repository 接口

提供 `save()`、`findById()`、`findAll()`、`deleteById()` 等核心方法。

**派生查询：** 方法名符合英语语法，JPA 自动推导并生成查询。

#### JPA 的缺点

- "不可控"：一切封装为黑盒对象流转
- 排错与调优成本呈指数级上升

#### JPA vs MyBatis-Plus

| 对比项 | JPA | MyBatis-Plus |
|--------|-----|-------------|
| 本质 | ORM 规范/Repository 风格 | MyBatis 增强框架 |
| 条件查询 | 方法名派生、`@Query` | QueryWrapper / LambdaQueryWrapper |
| 逻辑删除 | 自行设计 deleted 字段 | `@TableLogic` 内置支持 |
| SQL 控制 | 较弱，偏自动化 | 较强，更灵活 |
| 适合场景 | 中小项目、快速开发 | 后台管理、复杂查询 |

---

### 5.4 事务、乐观锁、悲观锁

#### 事务（Transaction）

保障数据一致性。一个业务流程包含多次写操作，中途失败时整体回滚。

**典型场景：** 注册初始化、转账、下单扣库存

**`@Transactional`**：Spring 声明式事务注解。

#### 悲观锁（Pessimistic Lock）

**假设**：数据冲突很常发生，操作前先锁住数据，别人暂不能改。

```sql
SELECT * FROM product WHERE id = 1 FOR UPDATE NOWAIT;
```

当前事务没结束前，其他人不能改这条数据。

#### 乐观锁（Optimistic Lock）

**假设**：数据冲突不常发生，平时不加锁，更新时检查数据是否被别人改过。

**做法：**
- 加 `version` 版本号字段
- 更新时带上旧版本号
- 版本不一致说明别人已改过，当前更新失败

```sql
-- 建表
CREATE TABLE product (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    stock INT NOT NULL,
    version INT NOT NULL DEFAULT 1
);

-- 乐观锁更新
UPDATE product
SET stock = stock - 1, version = version + 1
WHERE id = 1 AND version = 3;   -- 版本号不匹配则更新0行
```

> 先提交者胜，后提交者发现版本已变则操作失败

---

## 第6章 数据持久层进阶

### 6.1 MyBatis-Plus 进阶

#### 核心特性

- **强大的 CRUD**：内置通用 Mapper、通用 Service
- **Lambda 支持**：方便编写查询条件
- **主键自动生成**：4 种主键策略，含分布式唯一 ID 生成器
- **内置分页插件**：配置后写分页等同于普通 List 查询

#### 条件构造器详解

`AbstractWrapper` 是所有条件构造器的基类，`QueryWrapper` 和 `UpdateWrapper` 是其子类。

| 方法 | 含义 | 方法签名 |
|------|------|---------|
| `eq` | 等于 | `eq(R column, Object val)` |
| `ne` | 不等于 | `ne(R column, Object val)` |
| `gt` | 大于 | `gt(R column, Object val)` |
| `ge` | 大于等于 | `ge(R column, Object val)` |
| `lt` | 小于 | `lt(R column, Object val)` |
| `groupBy` | 分组 | `groupBy(R column, R... columns)` |

#### MyBatis-Plus 实现流程与反射

**反射（Reflection）：** 程序在**运行时**获取类的信息，动态操作类、对象、属性、方法。平时写代码是"先写死再运行"，反射是"运行时再认识这个类"。

**反射用途：** 框架自动创建对象、读取注解、动态调用方法

#### MyBatis-Plus 启动时做的事

1. **扫描**：扫描到 `UserMapper`
2. **反射读取**：读取 User 类信息：
   - 表名注解：`@TableName("sys_user")`
   - 字段：`id`、`username`、`deleted`
   - 主键注解：`@TableId`

**为什么要用反射？** 框架源码不知道你会写什么实体类（User、Order、Product...），只能在运行时动态认识。

---

### 6.2 Spring Data Redis 入门

#### Spring Data

Spring 提供的开源框架，统一和简化对各种数据库的持久化存储。`Repository` 接口被 IoC 容器识别为 Repository Bean。

#### Spring Data Redis

Spring Data 在 Redis 操作上的具体实现，提供 Java 客户端抽象，可忽略切换客户端带来的影响。

#### 配置步骤

1. 引入依赖
2. 配置 YAML

#### Cache Aside 模式

**查询场景（读流程）：**
```
先查 Redis → 命中直接返回 → 未命中查 PostgreSQL → 查到后写入 Redis → 返回结果
```

**更新场景（写流程）：**
```
先更新 PostgreSQL → 再删除 Redis 中对应缓存
```

**删除场景：**
```
删除 PostgreSQL 数据 → 删除 Redis 缓存
```

> 为什么不是先更新 Redis？数据库才是最终真实数据源，Redis 只是缓存

#### 声明式缓存

- `@Cacheable`：标记方法结果需要缓存
- `@CacheEvict`：标记方法执行后清除缓存

#### 热点数据缓存

把访问频率高的数据放入 Redis，减少 MySQL 压力。

#### Redis 常见 API

| 方法 | 说明 |
|------|------|
| `opsForValue()` | 操作 String 类型 |
| `opsForList()` | 操作 List 类型 |
| `opsForSet()` | 操作 Set 类型 |
| `opsForZSet()` | 操作 SortedSet 类型 |
| `opsForHash()` | 操作 Hash 类型 |
| `boundValueOps(K key)` | 绑定 String Key |
| `boundListOps(K key)` | 绑定 List Key |
| `boundSetOps(K key)` | 绑定 Set Key |
| `boundZSetOps(K key)` | 绑定 SortedSet Key |
| `boundHashOps(K key)` | 绑定 Hash Key |

#### Redis 注解

- `@RedisHash`：将数据类映射到 Redis 存储空间
- `@Id`：标示实体类主键
- `@Indexed`：标识属性在 Redis 中生成二级索引

---

### 6.3 多表联查

#### 系统架构

```
前端：Vue 3 + Axios + Router → 后端：Spring Boot + Controller + Service + Mapper
→ 数据库：PostgreSQL → 缓存：Redis
```

#### JOIN 查询

同时访问多张表的查询。本质：按照关联条件，把一张表的行与另一张表的行配对。

**常见类型：** INNER JOIN、LEFT JOIN、RIGHT JOIN、FULL JOIN

#### 多表联查原则

- 表太多时拆成主查询 + 子查询更清晰
- 前端只展示主信息，详情页再查明细更合理
- **建立合理索引**

#### 索引建议

- JOIN 条件列应建索引（如 `user_id`、`order_id`、`product_id`）
- 排序字段、过滤字段结合业务建立索引
- 没有索引时大表 JOIN 容易变慢
- PostgreSQL 通过 `EXPLAIN` 分析执行计划

#### BaseMapper 与复杂查询

- BaseMapper 提供的方法更偏单表
- 复杂 JOIN 涉及别名、聚合、动态条件、分页统计
- 推荐在 Mapper 中使用 `@Select` 手写原生 SQL 或 Mapper XML
- MyBatis-Plus 和手写 SQL 可以共存

> 避免在 Java 中循环单表查 → N+1 查询问题

---

### 6.4 反射思想

#### 反射（Reflection）核心概念

程序在**运行时**去获取类的信息，动态操作类、对象、属性、方法。平时写代码是"先写死再运行"，反射是"运行时再认识这个类"。

**类比：** 前台去系统里查——这个人是不是存在、属于哪个房间、有哪些权限、能不能执行某个操作。反射就像前台查系统档案：一开始不一定认识这个人，但可以在运行时查到他的身份和信息。

**为什么框架需要反射？** 框架源码不知道你会写什么实体类（User、Order、Product...），只能在运行时通过反射动态认识。MyBatis-Plus 启动时扫描到 UserMapper，通过反射读取 User 类的表名注解 `@TableName`、字段、主键注解 `@TableId`，然后自动生成对应的 SQL。

**操作 private 字段的正确流程：**
1. `getDeclaredFields()` → 获取本类声明的所有字段（含 private）
2. `setAccessible(true)` → 暴力解除访问限制
3. `field.set(目标对象, 注入值)` → 完成赋值

> `getFields()` 只能获取 public 字段。Spring 框架大量依赖反射实现依赖注入。

---

## 第7章 前后端联动与工程协同

### 7.1 跨域、同源策略

#### 同源策略（Same-Origin Policy，SOP）

浏览器的一种安全规则：一个网页默认只能访问和自己"同源"的资源。

**同源条件（三者完全相同）：** 协议相同 + 域名相同 + 端口相同

#### 同源检测示例

基准 URL：`http://store.company.com/dir/page.html`

| URL | 结果 | 原因 |
|-----|------|------|
| `http://store.company.com/dir2/other.html` | 同源 | 只有路径不同 |
| `https://store.company.com/secure.html` | 失败 | 协议不同 |
| `http://store.company.com:81/dir/etc.html` | 失败 | 端口不同 |
| `http://news.company.com/dir/other.html` | 失败 | 主机不同 |

#### 跨域

网页去请求了一个和自己不同源的地址。

```
前端页面：http://localhost:5173
后端服务：http://localhost:8080
```

---

### 7.2 前后端跨域联动与 CORS

#### 方案 A：代理

```
Browser → Vite 开发服务器 → Spring Boot 后端
```

1. 前端运行在 `http://localhost:5173`
2. 前端代码里请求 `/api/users`
3. Vite 代理转发到 `http://localhost:8080/api/users`
4. 浏览器"看到"的仍是前端同源地址

**优点：** 前端统一请求 `/api/...`，不需要写后端完整地址

#### 方案 B：后端配置 CORS（跨源资源共享）

```
Browser → Spring Boot
```

1. 浏览器直接跨域访问后端
2. 直接请求 `http://localhost:8080/api/users`
3. 后端必须返回合适的 CORS 响应头
4. 浏览器看见头信息后，才把响应交给前端代码

#### 两种方案对比

| 对比 | 方案 A（Vite 代理） | 方案 B（CORS） |
|------|-------------------|----------------|
| 工作位置 | 前端开发服务器 | 后端 Spring Boot |
| 浏览器看到的请求 | 请求前端站点 | 直接跨域请求后端 |
| 适用阶段 | 本地开发 | 真实跨域场景 |

#### 生产环境方案

| 解决方案 | 适用阶段 |
|----------|---------|
| 前端 Vite 代理 | 本地开发 |
| Nginx 代理 | 生产环境（前后端同域名部署的标准架构） |
| 后端全局 CORS | 多前端域名访问同一后端 / 开放 Web API |

#### 预检请求（Preflight）

某些跨域请求，浏览器会先发 `OPTIONS` 预检请求询问服务器是否允许。如果服务器允许，浏览器才继续发送实际请求。

---

### 7.3 CORS 常见用法、同步调试

#### 三种配置方式

**1. 局部配置：`@CrossOrigin`**

可加在类上或方法上。适合快速演示和少量接口，接口多时不利于统一管理。

**2. Spring MVC 全局配置**

通过 Config 实现 `WebMvcConfigurer` 统一配置 CORS。

**3. Spring Security 集成配置**

把 CORS 放进 Security 体系中：
- 方式 A：已有 Spring MVC 全局 CORS，添加 FilterChain
- 方式 B：显式提供 `CorsConfigurationSource`

#### CORS 使用注意细则

1. **不要只配 `@CrossOrigin`**：如果项目启用了 Spring Security 但未在 Security 里开启 CORS，预检请求仍可能被拦

2. **MVC 全局 CORS 和局部 `@CrossOrigin` 可以一起用**：全局定义规则，局部细粒度配置，两者组合

3. **CORS 不是权限系统**：CORS 只在浏览器层面决定"能不能读到跨域响应"。`allowedOrigins` 不等于"这个前端就能调用所有接口"

4. **登录接口必须放行**：登录是未认证用户的入口。在 `authorizeHttpRequests` 里单独 `permitAll()` 登录接口

---

### 7.4 JWT 令牌与 Spring Security

#### JWT = JSON Web Token

本质是一个字符串令牌，常用于前后端分离项目中表示"当前用户已经登录"。

**JWT 组成：**

| 部分 | 内容 |
|------|------|
| Header | 令牌类型和签名算法 |
| Payload | 用户信息：userId、username、role、exp（过期时间） |
| Signature | 签名，防止令牌被篡改 |

#### Spring Security

Spring 体系里的安全框架，负责：
- 认证（Authentication）——"你是谁"
- 授权（Authorization）——"你能做什么"
- 接口保护
- 安全过滤链

#### JWT vs Spring Security

| 对比维度 | JWT | Spring Security |
|----------|-----|-----------------|
| 本质定位 | 数据格式（令牌字符串） | 安全框架（拦截器） |
| 核心角色 | 身份凭证（"门禁卡"） | 认证与授权（"安检员"） |
| 工作机制 | 登录后生成，前端保存，后续携带 | 请求到达前拦截，决定是否放行 |

#### 常见使用流程

```
1. 登录接口放行
2. 用户名密码校验
3. 登录成功生成 JWT
4. 前端保存 token
5. 后续请求携带 Authorization
6. 后端解析 JWT 并写入安全上下文
```

- **登录时**：前端提交用户名密码 → 后端校验 → 生成 JWT
- **访问接口时**：前端携带 JWT → Spring Security 解析校验 → 决定放行

---

## 第8章 AI Agent 接入与智能服务扩展（上）

### 8.1 大模型基础

#### 领域关系

- **人工智能（AI）**：模拟人类智能的科学/技术
- **机器学习（ML）**：强调从数据中学习规律
- **深度学习（DL）**：依赖多层神经网络自动学习数据表示

#### 深度学习

- 使用多层神经网络学习数据表示，"深"指多层结构
- 能自动学习特征，不完全手工设计
- 应用领域：CV（计算机视觉）/ NLP（自然语言处理）

#### 深度学习：2012-2016

- 图像：CNN（卷积神经网络）
- 文本/时间序列：RNN/LSTM（循环神经网络）

**痛点：** RNN 处理长文本易"遗忘"，串行计算无法 GPU 并行训练，算力瓶颈严重。

#### Transformer：2017

论文《Attention Is All You Need》彻底抛弃 RNN 和 CNN，提出完全基于**自注意力机制（Self-Attention）**的网络架构。

- 解决了长文本依赖问题
- 实现高度并行计算，完美契合 GPU
- 让千亿级参数超大模型训练成为可能

#### Transformer 后的两派

| 架构 | 代表 | 擅长 |
|------|------|------|
| Encoder 架构 | Google BERT | 阅读理解、填空 |
| Decoder 架构 | OpenAI GPT | 单向生成、下一个词预测 |

> 大模型不是"会所有事情"，而是"在很多任务上具备较强泛化能力"

#### 大模型（LLM）

具有大规模参数、大规模数据训练、较强通用能力的模型。

---

### 8.2 大模型的训练与使用

#### 训练阶段

```
前向传播 + 损失计算 + 反向传播 + 参数更新
```

1. **前向传播**：得到预测结果
2. **损失函数**：衡量预测误差
3. **反向传播**：按链式法则计算梯度
4. **优化器**：根据梯度更新参数

> 反向传播只在训练阶段；推理时只有前向传播

#### 模型蒸馏（Knowledge Distillation）

让"庞大聪明的老师"把毕生功力传授给"小巧笨拙的学生"。小公司收集 GPT 输出训练自己的小模型，也是一种广义蒸馏。

#### 大模型微调

- **全量微调（FFT）**：Full Fine-Tuning
- **参数高效微调（PEFT）**：Parameter-Efficient Fine-Tuning（如 LoRA）

#### 大模型使用

**5 大核心要素及含义：**

| 要素 | 说明 | 解决的问题 |
|------|------|-----------|
| Prompt | 精心设计的输入指令 | 让模型理解任务 |
| RAG | 检索外部知识库补充上下文 | 让模型基于事实回答 |
| Memory | 存储和利用历史对话信息 | 让模型记住上下文 |
| Tool | 调用外部 API 和服务 | 让模型执行实际操作 |
| Workflow | 编排多个步骤和 Agent 协作 | 让模型完成复杂任务 |

**使用历程：** 接模型 → 设计 Prompt → 管理上下文 → 调用工具 → 检索资料 → 接入业务流程

#### 智能体类型

| 类型 | 特点 |
|------|------|
| Agentic 智能体 | 能动性与自主性：自主决策 |
| Workflow 智能体 | 将任务分解为具体步骤，多 Agent 协作 |

---

### 8.3 Prompt 工程、上下文工程

#### 开发框架与平台

- **低代码编排平台**：Coze、Dify、n8n
- **Java 框架**：Spring AI、Spring AI Alibaba、Langchain4j
- **Python 框架**：Langchain、LangGraph

#### Spring AI Alibaba 入门

**环境要求：** JDK 17+、Maven 3.8+、API-KEY（阿里云百炼：https://www.aliyun.com/product/bailian）

**步骤：**
1. 添加依赖
2. 配置 API_KEY（环境变量，临时 `setx` 或永久配置）
3. YAML 配置
4. 构建基础 ChatClient

#### Prompt Engineering（提示工程）

通过精心设计、优化输入 LLM 的文本指令，引导模型精准完成特定任务、生成高质量内容。

- **System Prompt**：设定模型角色、限制和工作流程
- **User Prompt**：用户的实时问题或请求

**良好 Prompt 的组成：**

| 要素 | 说明 |
|------|------|
| 指令 (Instruction) | 明确让模型执行的具体任务 |
| 上下文 (Context) | 提供背景信息 |
| 输入数据 (Input Data) | 具体需要处理的内容 |
| 输出指示 (Output Indicator) | 定义输出格式、风格或长度 |

#### 上下文工程（Context Engineering）

专注于优化、管理和动态构建输入 LLM 中"上下文窗口"的技术学科。

**涵盖内容：** 系统指令、用户输入、外部知识检索（RAG）、工具定义与输出、状态与对话历史

---

### 8.4 RAG：让模型"基于资料回答"

#### RAG（Retrieval Augmented Generation，检索增强生成）

克服 LLM 在长文本、事实准确性和上下文感知方面局限性的技术。Spring AI 提供模块化架构支持自定义 RAG 流程。

#### 向量数据库

专门存储和查询向量数据的数据库，提供快速相似性搜索。

| 产品 | 特点 |
|------|------|
| Pinecone | 托管云原生，简单 API |
| Milvus | 开源，高效相似搜索 |
| Weaviate | 云原生开源，弹性可扩展 |
| pgvector | PostgreSQL 扩展，数据库内向量查询 |

#### RAG 分片机制（Chunking）

**为什么分片？**
- 大模型上下文窗口有限
- 向量数据库字段长度限制
- 粒度过大影响精确召回
- 粒度过小破坏上下文语义

**分片原理：**
```
原始文档 → 按规则切分 → Chunk 1/2/3... → 向量化与建立索引 → 供后续召回使用
```

#### 向量化（Embedding）

文本块输入 Embedding 模型 → 吐出浮点数数组（如 `[0.12, -0.45, 0.88, ...]`，通常 768 维或 1536 维）——这就是文本块在高维几何空间中的"绝对坐标"。

#### 分片模式

| 模式 | 说明 | 适用场景 |
|------|------|---------|
| 固定长度分片 | 按字符数固定切分 | 简单场景 |
| 基于句法/标点 | 保证每块为完整句子（防语义断裂） | 小说、新闻 |
| 重叠分片 (Overlap) | 前后保留部分内容，减少语义断裂 | 通用 |
| 按段落分片 | 自然段为边界 | 结构化文档 |
| 按标题层级 | 结合章节、小节组织 | 技术文档 |
| 语义分片 | 按主题变化或语义边界切分 | 复杂知识库 |
| 特殊类型 | 表格、代码、FAQ 专门规则 | 特定格式 |

#### 召回方式

| 方式 | 说明 |
|------|------|
| 向量召回 | 基于语义相似度找到相关 chunk |
| 关键词召回 | BM25 / 倒排索引匹配词项 |
| 混合召回 | 语义 + 关键词，兼顾精确与泛化 |
| 条件过滤召回 | 按时间、来源、标签、权限过滤 |
| 多路召回 | 从多个索引或知识源同时检索 |

---

## 第9章 AI Agent 接入与智能服务扩展（下）

### 8.5 Tool Calling 工具调用

#### 为什么需要 Tool Calling

模型要接入外部能力。聊天只能输出文本，真实业务还需要**查、算、调、写**，因此需要 Tool/Function Calling。

#### MCP（模型上下文协议）

由 Anthropic 在 2024 年末推出的开源标准协议。为所有 AI 和工具制定"通用 USB 接口标准"，让任何 AI 都能即插即用各类数据源和工具。

**传统痛点：** 让 AI 读取 GitHub 需写一套代码，读取 Google Drive 又要写另一套完全不同代码。

**MCP 架构（Client-Server）：**
- **MCP 服务器（Server）**：连接特定数据源或工具
- **MCP 客户端（Client）**：任何支持 MCP 的 AI 应用

#### Tool Calling vs MCP

| 维度 | Tool Calling | MCP |
|------|-------------|-----|
| 本质 | AI 模型的一种核心能力（认知与规划） | 软件系统间的通信标准协议（基础设施） |
| 实际 | AI 决定调用某个工具 | 工具的具体连接和数据传输通过 MCP 实现 |

#### Tool Calling 流程

```
1. 注册工具 (Tool Definition)
2. 模型决策、提出调用请求
3. 程序执行真实工具
4. 工具结果回填模型
5. 业务系统拦截
6. 返回执行结果
```

#### Tool 分类

| 类型 | 特点 | 风险 |
|------|------|------|
| 查询型 Tool | 只读 | 低 |
| 执行型 Tool | 有副作用 | 高 |

> Tool Calling 的本质：模型输出包含工具名称和参数的"调用意图"（JSON 格式），由后端宿主程序真正执行，结果回传模型。模型本身不执行代码。

---

### 8.6 Skill 封装

#### Skill 概念的诞生

最早由 Amazon 在 2014 年发布 Alexa 智能音箱时全面定义推广。

**Skill（技能）：** 将专业知识、操作流程或复杂任务封装成可复用、自动化功能的能力模块。

#### Skill 的 3 种分类

| 类型 | 作用 | 示例 |
|------|------|------|
| 感知类/检索类 | 帮助模型获取外部信息 | 联网搜索、读取文件、RAG 提取知识 |
| 执行类/动作类 | 改变外部世界状态 | 发送邮件、写入数据库、高亮前端元素 |
| 认知类/数据处理类 | 调用外部专业算法 | 处理模型无法处理的特定格式数据 |

#### Skill 示例：异常处理系统的三种方案

**传统软件时代（无 AI）：** 纯工作流，代码把 JSON 拼接成模板 → 调用发信接口。

**工作流处理：** 大模型嵌在 if-else 中，代码调 LLM 总结 → 判断合法性 → 自动发消息。

**Skill 工具箱：** 大模型被赋予三个 Skill：【查异常】、【写报告】、【发消息】。大模型自己决定先查异常 → 分析违规 → 写好报告 → 自主调用发消息 Skill。

> 区别：系统不再是一条死板的流水线（工作流弱化了）

#### 设计建议

- 需要**绝对可控、严肃、不出错** → 多写工作流
- 需要**智能化、自主决策** → 封装为 Skill

> Skill 是对 Prompt、Tool、RAG、Memory 及约束条件的高级业务封装。像后端的 Service 层，解决超长 Prompt 难以复用、维护和测试的工程痛点。

---

### 8.7 Memory 记忆

#### 大模型记忆（Memory）

LLM Agent 在交互过程中用于存储、总结、检索和利用历史信息的机制。模拟人类记忆方式，突破上下文窗口限制，实现长期、跨会话的智能。

#### 三种记忆类型

**短期记忆 (Short-Term Memory / Session Memory)**

最常见类型，等同于大模型的上下文窗口。

- **概念**：保存当前对话或任务的连续记录
- **实现**：后端用数组缓存最近 N 轮对话，发新消息时拼接全部历史发给大模型
- **局限**：受 Token 长度限制（8K、128K），任务结束、刷新页面或字数超限后丢失

**长期记忆 (Long-Term Memory)**

Agent 走向真正智能的关键，让系统具备"跨时间""跨会话"学习能力。

- **概念**：将重要信息、知识、经验、用户偏好永久存储到外部数据库
- **实现**：通常结合 RAG 使用向量数据库（如 ChromaDB、Milvus）

**工作记忆 (Working Memory / Scratchpad)**

专为 Agent 执行复杂任务设计的临时草稿本。

- **概念**：Agent 在得出结论前产生的中间推导过程、工具调用结果或暂存变量

#### Memory vs RAG

| 对比 | Memory | RAG |
|------|--------|-----|
| 解决的问题 | 当前会话的连续性（聊天上下文） | 外部知识的补充（资料上下文） |
| 数据类型 | 对话历史、用户偏好 | 企业文档、知识库 |
| 存储方式 | 短期缓存 + 长期向量库 | 向量数据库 |

---

### 8.8 技术选型与工程治理

#### 大模型使用的 6 大问题

在真实项目中接入大模型，需要解决以下核心问题：

| 问题 | 说明 |
|------|------|
| 怎么调用 | 选择 API 直连还是框架封装（Spring AI、Langchain4j） |
| 怎么鉴权 | API-KEY 管理、环境变量配置、权限控制 |
| 怎么控成本 | Token 用量监控、模型选择（大模型 vs 蒸馏小模型） |
| 怎么控输出 | 约束格式（JSON Schema）、内容过滤、安全审查 |
| 怎么补知识 | RAG 检索增强、知识库建设、向量数据库选型 |
| 怎么接业务 | 工作流编排、Skill 封装、错误处理和降级策略 |

#### 智能体类型

| 类型 | 特点 | 适用场景 |
|------|------|---------|
| Agentic 智能体 | 自主决策，能动性强，自己规划执行路径 | 开放性问题、探索性任务 |
| Workflow 智能体 | 任务分解为固定步骤，按流程执行，多 Agent 协作 | 可预定义的业务流程 |

---

## 上机：Spring Data Redis

### Redis 序列化

Java 的世界全是"对象（Object）"，Redis 的底层世界只认识"字节（Byte）"。

- **序列化**：把 Java 对象翻译成字节存进 Redis
- **反序列化**：把 Redis 里的字节重新组装成 Java 对象

#### Spring Boot 中的 Redis 序列化方式

**1. JDK 序列化 (JdkSerializationRedisSerializer)**

使用 Java 原生序列化机制。存储 `"admin"`，Redis 客户端看到的是 `\xAC\xED\x00\x05t\x00\x05admin` 乱码。

- 极其不可读（运维不友好）
- 内存占用极大（带 Java 类元数据）
- 跨语言障碍

**2. 字符串序列化 (StringRedisSerializer)**

使用 `StringRedisTemplate`，将字符串按 UTF-8 编码转字节数组。

- 可读性高、跨语言友好
- 只能处理 String 类型，存对象需手动转 JSON

**3. JSON 序列化 (GenericJackson2JsonRedisSerializer)**

底层借用 Jackson，自动把 Java 对象转 JSON 存入 Redis。

存入后样子：`{"@class":"com.stu.helloserver.entity.User","id":1,"name":"张三"}`

- 缺点：为了反序列化时知道还原成什么类，会在 JSON 中插入 `@class` 字段，浪费空间

**4. StringRedisTemplate + JSON 工具类（推荐）**

**写入时：**
```java
// ObjectMapper 转纯净 JSON（不带 @class）
String jsonStr = objectMapper.writeValueAsString(user);
stringRedisTemplate.opsForValue().set("user:detail:1", jsonStr);
```

**读取时：**
```java
String jsonStr = stringRedisTemplate.opsForValue().get("user:detail:1");
User user = objectMapper.readValue(jsonStr, User.class);
```

---

### Redis 数据库基础

#### Redis vs PostgreSQL

| 对比 | PostgreSQL | Redis |
|------|-----------|-------|
| 类型 | 关系型数据库 | NoSQL 键值对数据库 |
| 本质 | 结构化数据存储 | 运行在内存里的超级 `HashMap<String, String>` |

#### Key 命名规范

由于没有"表"概念，Redis 社区约定使用冒号（`:`）充当分类"命名空间"。

```
String key = "user:detail:" + userId;
```

- `user` → 看作"表名"
- `detail` → 看作"业务类型"
- `1` → 主键 ID

```
user
└── detail
    └── 1 (存着张三的数据)
```

#### Redis 逻辑数据库

默认内置 16 个逻辑数据库（编号 0-15）：
- 每个库互相不干扰数据
- 不需要 `CREATE DATABASE`，安装好就存在且为空
- Spring Boot `application.yml` 中配置 `database: 0`

#### 操作 API

**非绑定操作：**

| 方法 | 说明 |
|------|------|
| `opsForValue()` | 操作 String 类型 |
| `opsForList()` | 操作 List 类型 |
| `opsForSet()` | 操作 Set 类型 |
| `opsForZSet()` | 操作 SortedSet 类型 |
| `opsForHash()` | 操作 Hash 类型 |

**绑定操作：**

| 方法 | 说明 |
|------|------|
| `boundValueOps(K key)` | 绑定 String Key |
| `boundListOps(K key)` | 绑定 List Key |
| `boundSetOps(K key)` | 绑定 Set Key |
| `boundZSetOps(K key)` | 绑定 SortedSet Key |
| `boundHashOps(K key)` | 绑定 Hash Key |

#### Redis 注解

| 注解 | 说明 |
|------|------|
| `@RedisHash` | 将数据类映射到 Redis 存储空间 |
| `@Id` | 标示实体类主键 |
| `@Indexed` | 标识属性在 Redis 中生成二级索引 |

#### Cache Aside 模式复习

- **查询**：Redis → 数据库 → 回写 Redis → 返回前端
- **更新**：数据库 → 删除 Redis
- **删除**：数据库 → 删除 Redis

> 数据库才是最终真实数据源，Redis 只是缓存


# 选择题

> 课件原题如下

## 第1章 服务端开发技术概述

1. 在"现代前后端分离"架构中，正确的是

- A 后端仅作为纯粹的 API 接口提供者，只负责吐出轻量级的 JSON 数据
- B 前端框架（如 Vue 3）主要部署在 Java 服务器内部运行，负责在服务器端把页面画好再发给用户
- C 因为引入了 Thymeleaf 和 JSP 等先进的模板引擎，现在的前后端代码可以更紧密地写在同一个文件里，极大提升了开发效率
- D 后端负责查询数据库，并将数据和 HTML 标签紧密拼接在一起，生成完整的网页后返回给用户浏览器

```text
答案：A
解析：在"现代前后端分离"架构中，后端仅作为纯粹的 API 接口提供者，只负责吐出轻量级的 JSON 数据。前端独立部署（如 Nginx 托管静态资源），后端不再负责渲染页面。B 错误：前端独立部署，不运行在 Java 服务器内部。C 错误：前后端分离，代码是独立的。D 错误：那是 JSP/Servlet 时代的做法。
```

2. 关于 Spring Boot 的"约定优于配置"，正确的是

- A 开发者必须严格遵守官方约定，手动编写大量的 XML 配置文件才能让项目成功运行
- B 框架要求前后端开发人员必须约定使用完全一样的编程语言，以减少团队联调成本
- C 框架为绝大多数场景提供了行业标准的默认配置（如默认的 Tomcat 端口和连接池），开发者只有在需要改变默认行为时，才需要编写配置覆盖它
- D Spring Boot 彻底废弃了所有的配置文件（包括 yml 和 properties），无论什么复杂的业务场景，都不允许开发者自定义任何环境参数

```text
答案：C
解析："约定优于配置"的核心：框架为绝大多数场景提供了行业标准的默认配置，开发者只有在需要改变默认行为时，才需要编写配置覆盖它。A 错误：约定优于配置恰恰是减少 XML。B 错误：与编程语言无关。D 错误：yml 和 properties 配置文件依然存在，只是默认值已设定好。
```

## 第2章 IoC/DI与核心注解

3. 关于Spring核心注解与依赖注入（DI），以下说法正确的是？

- A 在 Spring Boot 中，所有的对象都必须由开发者手动 new 出来，然后再交由 IoC 容器管理
- B @Service 注解底层与 @Component 完全不同，不能互相替换使用
- C 使用 @Autowired 进行依赖注入时，Spring 默认是根据 Bean 的名称（Name）进行匹配的
- D 如果需要将第三方 Jar 包中的类（如数据库连接池）注入到 Spring 容器中，通常使用 @Configuration 配合 @Bean 注解来实现

```text
答案：D
解析：将第三方 Jar 包中的类注入到 Spring 容器时，使用 @Configuration + @Bean 注解。因为无法修改第三方类的源码加 @Component，只能在配置类中用 @Bean 方法返回实例交给 Spring 管理。A 错误：Spring 管理的对象由容器自动创建。B 错误：@Service 底层就是 @Component，加了 @Service 的语义化别名。C 错误：@Autowired 默认按类型（By Type）匹配，只有在类型冲突时才降级按名称（By Name）匹配。
```

4. 在前后端分离的实战项目中，我们希望后端的接口能直接向 Vue 等前端框架返回 JSON 格式的数据，而不是去寻找并跳转到一个传统的 HTML 网页。此时，我们必须在该控制类（Controller）的头上打上哪个核心注解？

- A @Service
- B @Component
- C @RestController
- D @Configuration

```text
答案：C
解析：@RestController = @Controller + @ResponseBody，所有方法返回 JSON 数据而非跳转 HTML 页面。这是前后端分离项目 Controller 层的标准注解。
```

## 第3章 RESTful Web与Service业务层

5. 在设计符合规范的 RESTful API 时，以下关于 URL 路径设计的选项中，哪一项是完全正确的？

- A GET /api/getUser?id=1
- B POST /api/createOrder
- C GET /api/users/1
- D DELETE /api/deleteUser/1

```text
答案：C
解析：RESTful 规范要求 URL 只含名词不含动词。GET /api/users/1 符合规范（用 HTTP GET 表达"查询"，/users/1 表达"ID 为 1 的用户资源"）。A、B、D 都在 URL 中包含了动词（getUser、createOrder、deleteUser），违反 RESTful 原则。
```

6. 在开发用户列表查询接口时，前端需要传递分页参数（如当前页码 page 和每页条数 size）以及一个可选的搜索关键词 keyword，哪个是对的？

- A 将分页参数作为 URL 路径的一部分，后端用 @PathVariable 接收，GET /api/users/page/1/size/20
- B 将参数全部封装成 JSON 放在请求体中，后端用 @RequestBody 接收，GET /api/users 并 Body 中携带 JSON
- C 将参数作为查询字符串附加在 URL 问号之后，后端用 @RequestParam 接收，例如：GET /api/users?page=1&size=20&keyword=admin
- D 将分页等非机密参数统一放在 HTTP 请求头（Header）中，后端用 @RequestHeader 接收

```text
答案：C
解析：分页参数和搜索关键词属于附加筛选条件，应作为 Query String 附加在 URL 问号之后，后端用 @RequestParam 接收。A 错误：分页参数不是资源的唯一标识，不应放在路径中。B 错误：GET 请求通常不携带 Body。D 错误：分页参数不是元数据，不应放在 Header 中。
```

7. 在前后端分离架构中，前端使用 Vue 并通过 POST 请求向后端发送了一段结构极其庞大且包含多层嵌套的 JSON 格式表单数据。Spring Boot 后端的方法参数中，应该使用以下哪个注解来精准捕获并反序列化该数据？

- A @RequestParam
- B @PathVariable
- C @RequestBody
- D @RequestHeader

```text
答案：C
解析：前端通过 POST 发送 JSON 格式的表单数据，后端用 @RequestBody 注解精准捕获并反序列化为 Java 对象。@RequestParam 用于接收 URL 查询参数，@PathVariable 用于接收路径参数，@RequestHeader 用于接收请求头信息。
```

## 第4章 Service业务层与数据库基础

8. 在开发用户注册功能时，直接在 Controller 的参数里使用数据库实体类 `@RequestBody User user` 来接收前端传来的 JSON 数据。这种做法被严厉禁止的最核心的原因是什么？

- A 因为实体类（Entity）没有实现序列化接口，Spring Boot 无法将其转换为 JSON
- B 因为 MyBatis-Plus 底层不支持直接插入携带前端数据的实体类
- C 会引发"过度提交（Over-posting）"安全漏洞。黑客可以在 JSON 中恶意塞入 is_admin: 1 或 balance: 99999 等敏感字段，直接越权篡改数据库
- D 因为实体类通常会被存放在 Mapper 包下，Controller 无法直接调用

```text
答案：C
解析：直接用 Entity 接收前端 JSON 会引发"过度提交（Over-posting）"安全漏洞。黑客可在 JSON 中恶意注入 is_admin: 1 或 balance: 99999 等敏感字段，直接越权篡改数据库。应使用 DTO 只暴露允许前端传递的字段，防范此类攻击。
```

9. 定义了一个 UserService 接口，并且写了两个实现类分别加上了 `@Service("adminService")` 和 `@Service("normalService")`，启动项目时会发生什么？

- A Spring 会自动随机挑选一个实现类注入到内存中
- B Spring 启动直接报错抛出
- C Spring 会直接将 UserService 接口实例化，而忽略那两个实现类
- D 正常启动，无论调用哪个实现类，都会执行默认的 Object 方法

```text
答案：B
解析：Spring 按类型注入时发现一个 UserService 类型对应两个 Bean（adminService 和 normalService），无法抉择到底注入哪一个，启动直接报错。除非在注入点使用 @Qualifier 指定具体名称，或在一个 Bean 上标注 @Primary，否则按类型匹配冲突会导致 NoUniqueBeanDefinitionException。
```

## 第5章 数据持久层

10. 某用户修改接口使用乐观锁，表中有字段 version。当前数据库中记录为：id=1, age=20, version=3。前端提交更新时携带的版本号也是 3，执行后数据库中变为：id=1, age=25, version=4。另一个用户仍然拿着旧页面中的 version=3 再次提交更新。下面哪种结果最符合乐观锁设计？

- A 第二次更新直接成功，version 仍然保持 4
- B 第二次更新失败，因为旧版本号 3 已经过期
- C 第二次更新成功，并把 version 回退到 3
- D 第二次更新会自动转成悲观锁

```text
答案：B
解析：第一次更新（age 20→25，version 3→4）成功后，数据库中的 version 已是 4。第二个用户仍拿着旧页面中的 version=3 提交更新，`WHERE version = 3` 条件不满足（数据库已是 4），受影响行数为 0，更新失败。这正是乐观锁的核心——"先提交者胜，后提交者发现数据已被修改则操作失败"。
```

11. 某开发者使用 ORM 框架查询 user 表中的一条记录，并得到一个 User 对象。随后他修改了对象中的 age 属性，并希望将修改同步到数据库。下面说法最准确的是：

- A ORM 的核心作用只是查询数据，更新数据必须手写 JDBC
- B ORM 负责建立对象与表的映射关系，使对象的增删改查可以与数据库操作对应起来
- C ORM 会自动替代 Controller、Service、Mapper 三层架构
- D ORM 只能完成单表查询，不能支持更新操作

```text
答案：B
解析：ORM（Object Relational Mapping）的核心作用是建立对象与表的映射关系，使对象的增删改查可以与数据库操作对应起来。它是 JDBC 的高级封装。A 错误：ORM 支持更新操作。C 错误：ORM 是持久层技术，不替代三层架构。D 错误：ORM 支持增删改查全部操作。
```

## 第6章 数据持久层进阶

12. 在 Spring Boot 项目中，我们通常会引入 Redis 作为缓存层。在经典的模式下，当用户请求查询某条商品数据时，后端的标准执行顺序是什么？

- A 第一步先查 MySQL，如果查到了，直接返回给前端，不需要管 Redis
- B 第一步先把查询记录存进 Redis，然后再去 MySQL 里查具体数据
- C 第一步先查 Redis，如果 Redis 里面有数据（命中），直接返回给前端；如果 Redis 里没有，再去查 MySQL，查到后写入 Redis 并返回
- D 同时向 Redis 和 MySQL 发起查询，谁先返回结果就用谁的

```text
答案：C
解析：Cache Aside 模式的标准查询顺序：先查 Redis → 命中直接返回 → 未命中查数据库 → 查到后写入 Redis → 返回结果。标准更新/删除顺序：先操作数据库 → 再删除 Redis 对应缓存。因为数据库才是最终真实数据源，Redis 只是缓存加速层。
```

13. MyBatis-Plus 提供的 BaseMapper 和条件构造器（Wrapper）非常强大，但它们主要针对的是"单表操作"。如果在真实项目中，遇到了需要同时关联三张表（JOIN）的复杂统计查询，最推荐的工程做法是什么？

- A 在 Java 代码中使用 for 循环，循环调用单表查询的方法，然后在内存中手动拼接数据
- B 放弃使用 MyBatis-Plus，把整个项目重构为原生的 JDBC 编写
- C 在 QueryWrapper 里面强行写入大量的 JOIN 字符串来拼凑出多表 SQL
- D 自己在 Mapper 接口中使用 @Select 注解手写原生 SQL，或者在 Mapper XML 文件中编写联表 SQL，将复杂查询交给数据库处理

```text
答案：D
解析：复杂多表联查最推荐的工程做法：在 Mapper 接口中使用 @Select 注解手写原生 SQL，或在 Mapper XML 文件中编写联表 SQL。MyBatis-Plus 和手写 SQL 本来就可以共存。A 会导致 N+1 查询问题和代码复杂。B 没必要因为复杂联查就退回 JDBC。C Wrapper 适合单表条件构造，不适合硬塞 JOIN 字符串，不利于维护。
```

14. 假设你在手写一个简易版的 Spring 框架，需要利用反射把一个对象注入到某个类的 private 私有字段中（且该类没有提供 setter 方法）。为了实现这一目标，你必须使用以下哪组反射 API 的组合？

- A clazz.getFields() 获取字段集合 -> 遍历找到对应字段 -> 直接调用 field.set(目标对象, 注入值)
- B clazz.getDeclaredFields() 获取字段集合 -> 遍历找到对应字段 -> 直接调用 field.set(目标对象, 注入值)
- C clazz.getDeclaredFields() 获取字段集合 -> 遍历找到对应字段 -> 调用 field.setAccessible(true) -> 调用 field.set(目标对象, 注入值)
- D 反射受制于 Java 的安全沙箱机制，绝对无法修改没有 setter 方法的 private 字段，必须依靠 AOP 字节码增强（如 CGLIB）才能实现

```text
答案：C
解析：反射操作 private 字段的正确流程：getDeclaredFields()（获取本类声明的所有字段，含 private）→ setAccessible(true)（暴力解除访问限制）→ set()（完成赋值）。A 错误：getFields() 只能获取 public 字段。B 错误：缺少 setAccessible(true) 无法突破 private 访问限制。D 错误：反射完全可以修改 private 字段，Spring 框架本身大量依赖反射实现依赖注入。
```

## 第7章 前后端联动与工程协同

15. 当运行在 http://localhost:5173 的 Vue 前端去请求 http://localhost:8080/api/users 的 Spring Boot 后端接口时，控制台报错 blocked by CORS policy。导致该跨域问题的根本原因是什么？

- A 因为前端和后端使用了不同的网络传输协议（HTTP 与 HTTPS 不一致）
- B 因为浏览器检测到请求的端口号（5173 与 8080）不同，触发了同源策略的拦截机制
- C 因为前端 Vite 开发服务器主动拒绝了向 8080 端口转发数据的操作
- D 因为 Spring Boot 后端自带的安全机制默认拦截了来自 5173 端口的非法请求

```text
答案：B
解析：同源策略要求协议、域名、端口三者完全相同。前端 5173 端口与后端 8080 端口不同，浏览器触发同源策略拦截，这就是跨域问题。A 错误：两者都是 HTTP 协议。C 错误：Vite 代理是解决跨域的手段而非问题原因。D 错误：CORS 报错是浏览器层面的拦截，不是后端主动拒绝。
```

16. 在引入 Spring Security 来保护基于 JWT 的前后端分离项目时，必须清晰区分"认证（Authentication）"与"授权（Authorization）"。以下关于这两者的解释，哪一个是准确的？

- A 只要系统引入了 JWT，就自动完成了授权，Spring Security 只需要负责认证即可
- B 认证解决的是"你能做什么"的问题，而授权解决的是"你是谁"的问题
- C 认证必须通过前端 Vue 路由守卫来完成，而授权必须通过后端 SecurityFilterChain 来完成
- D 认证解决的是"你是谁"的问题（如校验账号密码），而授权解决的是"你能做什么"的问题（如判断是否有管理员权限）

```text
答案：D
解析：认证（Authentication）：解决"你是谁"的问题，如校验账号密码、验证 JWT Token。授权（Authorization）：解决"你能做什么"的问题，如判断是否有管理员权限。B 刚好说反了。A 错误：JWT 只是令牌格式，授权仍需 Spring Security 配置权限规则。C 错误：认证必须在后端完成，前端路由守卫只是 UI 层面的辅助。
```

17. 在单仓库管理的前后端分离架构（Spring Boot + Vue 3）中，关于前后端职责边界的描述，以下哪项是正确的？

- A 为了提高页面加载速度，前端 Vue 代码可以直接连接数据库读取商品列表信息
- B 后端的首要职责是业务逻辑计算、数据库交互与权限校验，并且只应返回结构统一的 JSON 数据
- C 只要前端配置了 Vue 路由守卫拦截未登录页面，后端接口就可以省去鉴权逻辑
- D 后端负责直接拼接带有 HTML 标签的字符串并将其渲染返回给浏览器

```text
答案：B
解析：后端的首要职责是业务逻辑计算、数据库交互与权限校验，只应返回结构统一的 JSON 数据。A 错误：前端绝不能直连数据库，这是安全底线。C 错误：鉴权必须后端完成，前端路由守卫只是 UI 辅助。D 错误：这是 JSP 时代的做法，现代前后端分离中后端只返回 JSON。
```

## 第8章 AI Agent（上）

18. 从底层原理来看，大语言模型（LLM）生成文本的本质过程是什么？

- A 基于海量参数和上下文，预测序列中的下一个 Token
- B 通过执行预先编写好的 If-Else 逻辑树来拼接句子
- C 将训练集中的原始语料直接复制粘贴
- D 在内置的关系型数据库中精确检索答案并返回

```text
答案：A
解析：LLM 生成文本的本质是自回归生成——基于海量参数和上下文，预测序列中的下一个 Token。这是 GPT 系列 Decoder 架构的核心机制。B 错误：大模型不是硬编码规则。C 错误：大模型生成新内容而非复制。D 错误：大模型没有数据库检索能力。
```

19. 大模型的生命周期主要分为"训练"和"使用"两大环节。以下哪项工作属于所强调的"使用（Serving/Usage）"环节？

- A 收集万亿级别的网页语料进行预训练 (Pre-training)
- B 设计 System Prompt 并动态拼接历史对话记录
- C 使用强化学习 (RLHF) 让模型价值观与人类对齐
- D 优化底层的 Transformer 架构代码

```text
答案：B
解析："设计 System Prompt 并动态拼接历史对话记录"属于使用环节，是 Prompt 工程和上下文工程的核心工作。A 预训练、C RLHF 对齐、D 架构优化都属于训练阶段。使用环节关注的是：接模型、设计 Prompt、管理上下文、调用工具、检索资料、接入业务流程。
```

20. 关于 RAG 系统中的文档分片（Chunking），以下哪种做法或理解是最合理的？

- A 为了极致的精确度，分片（Chunk Size）切得越小越好，最好每个切片只有 10 个字
- B 设置重叠度（Overlap）是为了防止像"张三借给李四 100元"这样的完整长句被物理切断，从而保留上下文的语义连贯性
- C 随着大模型越来越强，现在做 RAG 已经不需要分片了，直接把 10 万字的 PDF 传给大模型处理即可
- D 分片的本质只是为了压缩文件体积，以便能存入 MySQL 的 VARCHAR 字段中

```text
答案：B
解析：RAG 中设置重叠度（Overlap）是为了防止完整长句被物理切断（如"张三借给李四 100元"在"李四"和"100元"之间断开），保留上下文的语义连贯性。A 错误：分片过小会破坏语义完整性。C 错误：模型上下文窗口仍然有限，且大文档直接传入成本高、精度差。D 错误：分片的目的是获取合适的知识粒度和检索精度，与文件体积无关。
```

21. 在系统架构中引入向量数据库（如 PgVector、Milvus）时，以下说法错误的是？

- A 向量数据库不仅存浮点数数组（向量），通常还会存储原始的文本切片（Text Chunk）和业务元数据（Metadata）
- B 向量数据库在海量数据下的检索速度极快，是因为它的底层通常采用了类似 MySQL B+ 树的精确匹配索引结构
- C 在真实业务中，我们经常利用元数据进行"混合检索"，比如先执行类似于 WHERE year=2024 的条件过滤，然后再计算向量相似度
- D 相比于传统 SQL 的 LIKE '%关键字%' 全表扫描，向量检索更能实现"即使字面完全不同，也能基于语义找到目标"的效果

```text
答案：B
解析：向量数据库底层通常采用近似最近邻（ANN）索引（如 HNSW、IVF 等），而非 B+ 树的精确匹配。B+ 树无法高效处理高维向量的相似度搜索。A、C、D 都是正确的描述：向量数据库同时存储向量和元数据、支持过滤+向量混合检索、能实现语义级别的相似度匹配。
```

## 第9章 AI Agent（下）

22. 关于 Tool Calling（工具调用）的核心机制，以下说法最准确的是？

- A 大模型具备极强的代码执行能力，在调用外部工具时，它会直接运行后端的 Java 或 Python 代码来获取数据
- B Tool Calling 的本质是模型输出一个包含工具名称和参数的"调用意图"，由后端宿主程序（如 Spring Boot）真正执行该工具，并将结果回传给模型
- C 为了保证系统安全，Tool Calling 只能用于"只读"的查询操作（如查天气、查订单），绝不能用于写操作（如发邮件、修改状态）
- D 只要在代码里定义了 Tool，大模型就能完美且安全地调用它，不需要开发者在 Prompt 中写工具描述

```text
答案：B
解析：Tool Calling 的本质是模型输出一个包含工具名称和参数的"调用意图"（JSON格式），由后端宿主程序（如 Spring Boot）真正执行该工具，并将结果回传给模型。模型本身不执行任何代码。A 错误：模型不能直接运行后端代码。C 错误：执行型 Tool 也可以使用（如发邮件），只需做好权限控制和安全校验。D 错误：必须在工具定义/Prompt 中清晰描述工具的用途和参数。
```

23. 在企业级 AI 系统设计中，为什么我们提倡将能力封装为"Skill（技能）"，而不是直接写一个"超长的Prompt"？

- A 因为超长的 Prompt 会导致大模型直接报错宕机，无法返回任何结果
- B Skill 只是 Spring AI 框架里强制规定的一个 Java 接口名，不用它就无法调用大模型
- C Skill 是对 Prompt、Tool、RAG、Memory 及约束条件进行的高级业务封装。它像后端的 Service 层一样，解决了超长 Prompt 难以复用、难以维护和难以测试的工程痛点
- D Skill 和 Tool 是完全一样的概念，两者都是底层原子能力，只是叫法不同

```text
答案：C
解析：Skill 是对 Prompt、Tool、RAG、Memory 及约束条件进行的高级业务封装。它像后端的 Service 层一样，将复杂的能力模块化，解决了超长 Prompt 难以复用、难以维护和难以测试的工程痛点。A 错误：问题不是宕机而是工程可维护性。B 错误：Skill 是架构概念，不限于 Spring AI。D 错误：Skill 是高层封装，Tool 是底层原子能力，两者层次不同。
```

24. 大模型本身是"无状态"的。在解决系统上下文问题时，Memory（记忆）和 RAG（检索增强生成）都扮演了重要角色。关于两者的核心区别，以下说法正确的是？

- A Memory 主要解决的是"当前会话的连续性问题"（聊天的上下文），而 RAG 解决的是"外部知识的补充问题"（资料的上下文）
- B Memory 是大模型天生自带的内部硬盘，不需要开发者写代码；而 RAG 需要把数据存入向量数据库
- C 只要上下文窗口（Context Window）无限大，我们就可以把所有文档放进 Memory 中，从而彻底淘汰 RAG
- D Memory 主要用来检索企业的法律法规、产品手册，而 RAG 用来保存用户刚才说过的话

```text
答案：A
解析：Memory 解决"当前会话的连续性问题"（聊天上下文，包括短期/长期/工作记忆），RAG 解决"外部知识的补充问题"（从向量数据库检索资料作为上下文）。B 错误：Memory 也需要开发者编写管理逻辑。C 错误：上下文窗口不是无限大，且全放 Memory 效率低。D 错误：Memory 和 RAG 的作用刚好说反了。
```


---

# 简答题

## 1. Spring Boot 三大核心理念是什么，为什么能提高开发效率？

- 约定优于配置：框架为几乎所有技术选型提供默认最优解，开发者无需手动编写大量配置，只有需改变默认行为时才写配置，大幅减少 XML 和样板代码。
- 启动器开箱即用：引入 ``spring-boot-starter-web`` 等 starter 自动拉取所有兼容的底层组件，解决手动管理依赖版本冲突的问题，Maven 自动解析传递依赖。
- 内嵌服务器：内置 Tomcat，无需部署 WAR 包，打成 jar 包即可 `java -jar` 直接运行。
- 三者加起来，省掉了传统 Spring 的 XML 配置、依赖版本冲突和繁琐部署，开发时不用操心基础设施。

## 2. 控制反转（IoC）与依赖注入（DI）的关系是什么？

- IoC（控制反转）是一种设计思想，将对象创建、依赖关系管理从程序代码中剥离交给容器处理，"反转"指控制权从程序员转到容器。
- DI（依赖注入）是 IoC 的具体实现方式，容器主动将依赖对象注入到需要的组件中，而不是组件自己 `new`。
- 关系：IoC 是思想，DI 是实现。Spring 通过 DI 实现 IoC——容器管理所有 Bean 的生命周期，发现 `@Autowired` 注解时自动装配。传统方式 `UserService service = new UserServiceImpl()` 自己控制创建，Spring 方式只需 `@Autowired private UserService service`，容器自动注入实现类。

## 3. 拦截器（Interceptor）和过滤器（Filter）的区别是什么？

- Filter 属于 Web 容器级别（Servlet），不依赖 Spring，在请求进入 `DispatcherServlet` 之前拦截，实现 `javax.servlet.Filter` 接口重写 `doFilter` 方法，只能访问 Request/Response，适用于编码处理、跨域、安全过滤。
- Interceptor 属于 Spring MVC 框架级别，依赖 Spring 容器，请求已进入 Spring 但在到达 Controller 之前拦截，实现 `HandlerInterceptor` 接口重写 `preHandle` / `postHandle` / `afterCompletion` 方法，可访问 Spring Bean 和 Handler 信息，适用于 Token 鉴权、权限校验、日志记录。
- 请求处理链：``Filter → Interceptor → AOP → Controller``。选择：底层 HTTP 问题用 Filter，业务级拦截用 Interceptor，复杂权限系统用 Spring Security。

## 4. DTO、VO、Entity 的联系和区别是什么？

- Entity（实体类）与数据库表一一映射，包含所有字段（包括密码等敏感信息），仅在 Mapper 层使用。
- DTO（Data Transfer Object，数据传输对象）用于接收前端参数和返回数据，按需选取字段隔绝敏感字段，在 Controller/Service 层使用。
- VO（View Object，视图对象）用于拼装数据返回前端展示，可能跨表聚合多个 Entity 的数据为前端视图定制。
- 三者都放在 model 包下。数据流：前端请求→Controller 用 DTO 接收→Service 将 DTO 转为 Entity→Mapper 操作数据库；查询时 Mapper 返回 Entity→Service 转为 DTO/VO→Controller 返回 JSON。
- 主要目的是各层用各自的模型，避免直接暴露 Entity 导致过度提交（比如黑客在 JSON 里塞 `is_admin: 1` 越权改数据库）。

## 5. Controller、Service、Mapper 三层职责分别是什么？

- Controller（@RestController）负责接收 HTTP 请求、参数校验、调用 Service、返回 JSON 响应。
- Service（@Service）负责业务逻辑处理、流程编排、事务管理，采用接口+实现类模式。
- Mapper（`@Mapper`）负责数据持久化、执行 SQL、与数据库交互，继承 `BaseMapper` 获取 CRUD 能力。
- 调用链：Controller→Service（接口）→ServiceImpl（实现）→Mapper→Database。
- 分层的好处：每层只干一件事，Service 用接口解耦方便换实现，各层能独立 Mock 测试，Controller 不碰数据库安全上更可控。

## 6. 服务端治理包含哪些方面？简要说明。

- 日志（Logging）：记录系统运行状态和异常信息，典型方案 SLF4J+Logback、ELK（Elasticsearch+Logstash+Kibana）。
- 调用链（Tracing）：追踪一次请求在微服务间的完整路径，方案有 Spring Cloud Sleuth、SkyWalking、Jaeger。
- 限流（Rate Limiting）：控制单位时间内的请求量保护系统，方案有 Sentinel、Guava RateLimiter、Nginx 限流。
- 缓存（Caching）：减少数据库压力加速热点数据访问，方案有 Redis（Cache Aside 模式）、本地缓存 Caffeine。
- 回滚（Rollback）：异常时恢复数据一致性，方案有 Spring `@Transactional` 声明式事务、分布式事务 Seata。
- 可观测（Observability）：通过指标、日志、链路全面了解系统状态，三大支柱：Metrics（Prometheus+Grafana）告诉你有没有问题，Tracing（Jaeger）告诉你问题在哪，Logging（ELK）告诉你问题是什么。

## 7. Docker 核心概念有哪些？

- 镜像（Image）：只读模板，包含运行应用所需的代码、运行时、依赖、环境变量和配置文件，通过 `Dockerfile` 定义构建规则，分层存储且每层只读。
- 容器（Container）：镜像的运行实例，是独立进程集合，拥有独立文件系统和网络栈，与宿主机共享内核，启动速度快（秒级）且资源隔离。
- 仓库（Registry）：存储和分发镜像的中心化服务，如 Docker Hub（公共）、私有 Registry。
- 核心流程：`Dockerfile` → `docker build` → Image → `docker run` → Container。
- 与虚拟机区别：Docker 共享宿主机内核无需虚拟化整个 OS，启动快资源占用少；虚拟机需要 Guest OS 隔离性更强但更重。
- 部署流程：编写 ``Dockerfile``→``docker build -t app:v1 .``→``docker run -p 8080:8080 app:v1``→配合 Docker Compose 编排多容器应用（如 Spring Boot+PostgreSQL+Redis）。

---

# 设计题

## 1. 设计一个基于 JWT + Spring Security 的登录认证流程

前后端分离项目，用户用用户名密码登录，后端签发 JWT，后续请求带 JWT 访问受保护接口。

**登录接口**

- 放行 `POST /api/auth/login`，不在 Security 拦截范围内（`.permitAll()`）
- Controller 用 `@RequestBody LoginDTO` 接收用户名密码
- Service 查数据库校验密码（BCrypt），通过后生成 JWT 返回
- JWT Payload 包含 `userId`、`username`、`role`、`exp`（过期时间，通常 24h）
- 返回格式 `{ "code": 200, "data": { "token": "xxx" } }`

**Spring Security 配置**

- 自定义 `JwtAuthenticationFilter` 继承 `OncePerRequestFilter`，在每个请求中从 `Authorization: Bearer xxx` 提取 Token
- 校验 Token 签名和有效期，解析出用户信息写入 `SecurityContextHolder`
- `SecurityFilterChain` 中：关闭 CSRF，无状态 Session，登录接口放行，其余接口需认证
- CORS 配置允许前端域名

**前端配合**

- 登录成功后将 Token 存 `localStorage`
- 请求拦截器自动在 Header 加 `Authorization: Bearer <token>`
- Token 过期（401）时跳转登录页

**安全要点**

- 密钥存配置文件，不硬编码
- 密码用 BCrypt 加密存储，不存明文
- Token 设置合理过期时间，可配合 Refresh Token 延长登录态

---

## 2. 用 Postman 测试 RESTful 接口，写出接口列表和预期状态码

对用户管理模块（User CRUD）编写 Postman 测试方案。

| 功能 | 方法 | URL | 请求体 | 预期状态码 |
|------|------|-----|--------|-----------|
| 查询用户列表 | GET | `/api/users` | — | 200 OK |
| 查询单个用户 | GET | `/api/users/1` | — | 200 OK |
| 查询不存在用户 | GET | `/api/users/999` | — | 404 Not Found |
| 新增用户 | POST | `/api/users` | `{`<br>`  "username": "test",`<br>`  "password": "123"`<br>`}` | 201 Created |
| 新增用户（缺必填字段） | POST | `/api/users` | `{`<br>`  "username": "test"`<br>`}` | 400 Bad Request |
| 修改用户 | PUT | `/api/users/1` | `{`<br>`  "username": "new",`<br>`  "age": 25`<br>`}` | 200 OK |
| 删除用户 | DELETE | `/api/users/1` | — | 200 OK |
| 删除不存在用户 | DELETE | `/api/users/999` | — | 404 Not Found |
| 无认证访问 | GET | `/api/users` | — | 401 Unauthorized |
| 无权限访问 | DELETE | `/api/users/1` | — | 403 Forbidden |
| 方法错误 | GET | `/api/users` (本应POST) | — | 405 Method Not Allowed |

Postman 操作：新建 Collection 管理所有接口；登录接口写在最前面，在 Tests 脚本中用 `pm.environment.set("token", ...)` 提取 Token；后续接口在 Authorization 标签选 Bearer Token，引用 `{{token}}`；Body 选 raw → JSON；检查响应状态码、响应体结构和业务 code 是否匹配预期。

---

## 3. 智能客服系统需要哪些能力组件，说明各自作用和简单功能设计

接入大模型的智能客服系统，支持知识问答、工单创建、人工转接。

**（1）对话引擎**
- 作用：接收用户消息，管理多轮对话上下文，调用大模型生成回复
- 设计：维护会话级别的 Message 列表（System Prompt + 历史对话 + 当前输入），拼接后发给 LLM。System Prompt 设定角色为"XX平台客服"，限定回答范围

**（2）RAG 知识库**
- 作用：从企业文档中检索相关知识，让模型基于资料回答
- 设计：将产品手册、FAQ 等文档切分为 Chunk（500-1000 字），通过 Embedding 模型向量化存入向量数据库（如 Milvus/pgvector）。用户提问时先召回 Top-K 相关 Chunk，拼进 Prompt 作为参考

**（3）工具调用**
- 作用：让模型执行实际操作，不只是聊天
- 设计：定义 Tool Schema（名称、参数、描述），注册到 LLM。Tool 举例：`query_order(order_id)` 查订单状态、`create_ticket(user_id, title, desc)` 创建工单、`transfer_to_human(reason)` 转人工。模型返回调用意图 → 后端执行 → 结果回填 → 模型生成最终回复

**（4）记忆模块**
- 作用：记住用户信息和历史对话，跨会话保持上下文
- 设计：短期记忆用 Redis 缓存近 20 轮对话。长期记忆用向量数据库存用户偏好和历史问题摘要，后续对话时检索注入上下文

**（5）安全与风控**
- 作用：防注入攻击、敏感信息泄露、滥用
- 设计：输入过滤（敏感词、Prompt 注入检测），输出审核（违规内容检查），限流（每人每分钟 N 次），人工审核标记

五个组件协作：用户提问 → 安全过滤 → Memory 注入上下文 → RAG 检索知识 → LLM 生成回复 → 需要操作时调 Tool → 结果回填 → 输出审核 → 返回用户。

---

## 4. 设计一个 Spring Boot 项目的 Docker 部署流程

Spring Boot + PostgreSQL + Redis 项目容器化部署。

**（1）项目准备**

- 打包：`mvn clean package -DskipTests`
- `application.yml` 中数据库和 Redis 地址改为容器服务名（`postgres:5432`、`redis:6379`），不写死 IP

**（2）Dockerfile**

```dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**（3）docker-compose.yml**

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - postgres
      - redis
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/mydb
      - SPRING_REDIS_HOST=redis

  postgres:
    image: postgres:17
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secret
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redisdata:/data

volumes:
  pgdata:
  redisdata:
```

**（4）启动**

```bash
docker-compose up -d              # 后台启动
docker-compose ps                  # 查看状态
docker-compose logs -f app        # 查看日志
```

**（5）生产注意**

- 密码等敏感信息用环境变量或 Docker Secrets，不写进镜像
- 配健康检查确保依赖就绪后再启应用
- 多阶段构建减体积
- 日志挂载到宿主机
- Nginx 反代做 HTTPS 和负载均衡
