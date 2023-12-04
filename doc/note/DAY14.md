# 关于Session

服务器端的程序通常是基于HTTP协议的，HTTP协议本身是一种“无状态”的，所以，它并不能保存客户端的状态，也就是说，当同一个客户端多次访问同一个服务器时，服务器并不能识别后续访问其实和前序的访问来自同一个客户端。

在开发实际中，需要识别客户端的身份，所以，在编程技术上，可以使用Session机制来解决此问题。

Session的本质是存储在服务器端的内存中的一个K-V结构的数据，服务器端会为每一个来访的客户端的首次访问分配一个Session ID（是一个UUID值，如果客户端的请求没有携带Session ID，则分配，如果已携带Session ID，则不分配），此Session ID就是客户端访问Session数据时使用的Key，所以，每个客户端在服务器端都有一份对应的Session数据（K-V中的Value）。

由于Session是存储在服务器端的内存中的，内存是非常重要的，且容量相对较小的存储设备，所以，必须要设置一种清除Session的机制，默认的清除机制就是“超时自动清除”，即某个客户端在最后一次提求的多长时间内没有再次提交请求（默认的超时时间一般是15分钟或30分钟），则服务器端将自动清除此客户端对应的Session数据。

由于Session是存储在服务器端的内存中的，所以会存在一些缺点：

- 不合适存储大量数据
  - 应该通过规范的开发，避免此问题
- 不便于应用到集群或分布式系统中
  - 可以通过共享Session解决此问题
- 不可以长时间的存储
  - 对于Session机制是无解的

# 关于Token

**Token：**令牌，或票据

在使用Token机制时，当客户端向服务器端第1次提交请求时，或提交登录请求时，客户端不需要做特殊的处理，而服务器端会在识别此客户端身份后，会将客户端的身份数据生成为Token，并将此Token响应到客户端去，后续，客户端需要携带此Token提交各种请求，服务器端会根据Token中的数据来识别客户端的身份。

在处理过程中，服务器端只需要具体检查Token、从Token中解析出客户端身份的相关数据即可，并不需要在服务器端保存各Token数据，所以，Token是可以设置较长时间的有效期的，不会消耗服务器端存储资源！

同时，Token天生就适用于集群或分布式系统，因为各服务器只需要具有相同的验证、解析Token的程序即可识别客户端的身份。

其实，Token的传输流程与Session ID基本上是相同的，最大的区别在于Session ID并没有实际的数据含义，它只是一段无意义的、可以保证唯一性的随机数据而已，而Token是具有数据含义的，是有意义的数据！

# 关于JWT

**JWT：**JSON Web Token

关于JWT的官网：https://jwt.io/

每个JWT数据都包含3个组成部分：

- Header：关于算法与Token类型的声明
- Payload：数据
- Signature：验证签名

关于JWT编程的工具包：https://jwt.io/libraries?language=Java

例如，在项目的`pom.xml`中添加依赖项：

```xml
<!-- JJWT（Java JWT） -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

接下来，就可以在项目中尝试生成、解析JWT：

```java
package cn.tedu.csmall.passport;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.junit.jupiter.api.Test;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JwtTests {

    String secretKey = "8ugLIU$#%^*&dlii9MutjKJoHhldSF)JFDL*urfda(&%&^invjfdsa";

    @Test
    void generate() {
        Date date = new Date(System.currentTimeMillis() + 5 * 60 * 1000);

        Map<String, Object> claims = new HashMap<>();
        claims.put("id", 9527);
        claims.put("username", "Zhangsan");

        String jwt = Jwts.builder()
                // Header
                .setHeaderParam("alg", "HS256")
                .setHeaderParam("typ", "JWT")
                // Payload
                .setClaims(claims)
                // Signature
                .setExpiration(date)
                .signWith(SignatureAlgorithm.HS256, secretKey)
                // 完成
                .compact();
        System.out.println(jwt);
    }

    @Test
    void parse() {
        String jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OTUyNywiZXhwIjoxNjc1ODM3Mzc3LCJ1c2VybmFtZSI6IlpoYW5nc2FuIn0._9XtdKoj5CmNEW99dYE9FZLGPoN12pOQHhMr1PLQLs0";
        Claims claims = Jwts.parser()
                .setSigningKey(secretKey)
                .parseClaimsJws(jwt)
                .getBody();
        Object id = claims.get("id");
        Object username = claims.get("username");
        System.out.println("id=" + id);
        System.out.println("username=" + username);
    }

}
```

当尝试解析的JWT已经过期时，会出现错误：

```
io.jsonwebtoken.ExpiredJwtException: JWT expired at 2023-02-08T14:12:35Z. Current time: 2023-02-08T14:16:45Z, a difference of 250374 milliseconds.  Allowed clock skew: 0 milliseconds.
```

当尝试解析的JWT数据格式错误时，会出现错误：

```
io.jsonwebtoken.MalformedJwtException: Unable to read JSON value: {"id":9525�"exp":1676701619,"username":"Zhangsan"}
```

当尝试解析的JWT验证签名错误时，会出现错误：

```
io.jsonwebtoken.SignatureException: JWT signature does not match locally computed signature. JWT validity cannot be asserted and should not be trusted.
```

**注意：**JWT数据是可能被客户端篡改的，所以，当解析失败时，应该不信任对此JWT数据！并且，即使不知道生成JWT时的secretKey的情况下，仍有很多办法可以解析出JWT中的内容，所以，不要在JWT中存入敏感数据。

# 在项目中使用JWT识别用户的身份

## 核心流程概述

在项目中使用JWT识别用户的身份，大致需要：

- 当用户通过认证（登录成功）后，服务器端应该生成此用户对应的JWT数据，并响应到客户端
  - 当视为通过认证后，不再需要将用户的相关信息存入到`SecurityContext`中
- 当用户尝试执行需要认证的操作时，用户应该携带JWT数据，服务器端应该解析此JWT数据，从而验证JWT的真伪，并识别用户的身份，将用户的相关信息存入到`SecurityContext`中

## 认证成功后响应JWT

首先，在`AdminServiceImpl`中执行认证且通过认证后，不再向`SecurityContext`中存入认证信息：

```java
@Override
public void login(AdminLoginDTO adminLoginDTO) {
    // 暂不关心前序代码
    
    // ========== 删除以下代码 ==========
    // 将认证信息存入到SecurityContext
    SecurityContext securityContext = SecurityContextHolder.getContext();
    securityContext.setAuthentication(authenticationResult);
}
```

然后，将`IAdminService`中的登录方法的返回值类型改成`String`，表示此方法在处理认证成功后，将返回JWT（`String`类型）数据：

```java
String login(AdminLoginDTO adminLoginDTO);
```

同时，也将`AdminServiceImpl`中的登录方法的返回值类型的声明做同样的调整，并在通过认证后生成JWT数据、返回JWT数据：

```java
@Override
public String login(AdminLoginDTO adminLoginDTO) {
    log.debug("开始处理【管理员登录】的业务，参数：{}", adminLoginDTO);
    // 执行认证
    Authentication authentication = new UsernamePasswordAuthenticationToken(
            adminLoginDTO.getUsername(), adminLoginDTO.getPassword());
    Authentication authenticationResult
            = authenticationManager.authenticate(authentication);
    log.debug("认证通过，认证结果：{}", authenticationResult);
    log.debug("认证通过，认证结果中的当事人：{}", authenticationResult.getPrincipal());

    // =========== 新增以下代码 ==========
    // 将通过认证的管理员的相关信息存入到JWT中
    // 准备生成JWT的相关数据
    String secretKey = "8ugLIU$#%^*&dlii9MutjKJoHhldSF)JFDL*urfda(&%&^invjfdsa";
    Date date = new Date(System.currentTimeMillis() + 10 * 24 * 60 * 60 * 1000);
    AdminDetails principal = (AdminDetails) authenticationResult.getPrincipal();
    Map<String, Object> claims = new HashMap<>();
    claims.put("id", principal.getId());
    claims.put("username", principal.getUsername());
    // 生成JWT
    String jwt = Jwts.builder()
            // Header
            .setHeaderParam("alg", "HS256")
            .setHeaderParam("typ", "JWT")
            // Payload
            .setClaims(claims)
            // Signature
            .setExpiration(date)
            .signWith(SignatureAlgorithm.HS256, secretKey)
            // 完成
            .compact();
    // 返回JWT
    return jwt;
}
```

在`AdminController`中处理登录时，调用Service方法时获取返回值，并响应到客户端：

```java
@PostMapping("/login")
public JsonResult<String> login(AdminLoginDTO adminLoginDTO) {
    log.debug("开始处理【管理员登录】的请求，参数：{}", adminLoginDTO);
    String jwt = adminService.login(adminLoginDTO);
    return JsonResult.ok(jwt);
}
```

通过API文档测试访问，当登录成功后，响应的结果例如：

```json
{
  "state": 20000,
  "data": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiZXhwIjoxNjc2NzA0NjM4LCJ1c2VybmFtZSI6ImxpdWNhbmdzb25nIn0.9YOVO3nIEewCCUIn5aon_wOJcbFaaHLwpDrOSeA36v4"
}
```

## 解析客户端携带的JWT



客户端提交若干种不同请求时，可能都需要携带JWT，在服务器，处理若干种不同的请求之前也都需要获取并尝试解析JWT，则应该使用**过滤器（`Filter`）**组件进行处理！

> 提示：过滤器是Java服务器端组件中，最早接收到请求的组件，它执行在其它任何组件之前！在同一个项目中，允许存在若干个过滤器，形成过滤器链（Filter Chain）！任何一个请求，必须被所有过滤器“放行”才可以被处理！

则在项目的根包下创建`filter.JwtAuthorizationFilter`类，继承自`OncePerRequestFilter`，并在类上添加组件注解：

```java
@Component
public class JwtAuthorizationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

    }

}
```

首先，需要尝试接收客户端携带的JWT：

```java
@Slf4j
@Component
public class JwtAuthorizationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        // 根据业内惯用的做法，客户端应该将JWT保存在请求头（Request Header）中的名为Authorization的属性中
        String jwt = request.getHeader("Authorization");
        log.debug("尝试接收客户端携带的JWT数据，JWT：{}", jwt);
    }

}
```

然后，在`SecurityConfiguration`中自动装配以上过滤器对象：

```java
@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

    // 新增
    @Autowired
    private JwtAuthorizationFilter jwtAuthorizationFilter;
    
    // 暂不关心其它代码
    
}
```

并且，在此配置类的`void configuere(HttpSecurity http)`方法中，添加此过滤器：

```java
http.addFilterBefore(jwtAuthorizationFilter, 
                     UsernamePasswordAuthenticationFilter.class)
```

在API文档中，通过“全局参数设置”中的“添加参数”，可以配置每个请求都将携带JWT数据：

![image-20230208155152295](images/image-20230208155152295.png)

![image-20230208155320701](images/image-20230208155320701.png)

当通过API文档的调试发出任何请求，在API文档界面中看到的结果都将是一片空白，并且，在服务器端的控制台中可以看到输出了对应的JWT数据！

接下来，应该在`JwtAuthorizationFilter`中尝试解析JWT，并将解析成功时得到的数据用于创建认证对象，再把认证对象存入到`SecurityContext`中：

```java
package cn.tedu.csmall.passport.filter;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>处理JWT的过滤器类</p>
 *
 * <p>此过滤器类的主要职责</p>
 * <ul>
 *     <li>接收客户端可能提交的JWT</li>
 *     <li>尝试解析客户端提交的JWT</li>
 *     <li>将解析得到的结果存入到SecurityContext中</li>
 * </ul>
 *
 * @author java@tedu.cn
 * @version 0.0.1
 */
@Slf4j
@Component
public class JwtAuthorizationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        // 根据业内惯用的做法，客户端应该将JWT保存在请求头（Request Header）中的名为Authorization的属性中
        String jwt = request.getHeader("Authorization");
        log.debug("尝试接收客户端携带的JWT数据，JWT：{}", jwt);

        // 判断客户端是否提交了有效的JWT
        if (!StringUtils.hasText(jwt) || jwt.length() < 113) {
            // 直接放行
            filterChain.doFilter(request, response);
            // 【重要】终止当前方法的执行，不执行当前方法接下来的代码
            return;
        }

        // 尝试解析JWT
        String secretKey = "8ugLIU$#%^*&dlii9MutjKJoHhldSF)JFDL*urfda(&%&^invjfdsa";
        Claims claims = Jwts.parser()
                .setSigningKey(secretKey)
                .parseClaimsJws(jwt)
                .getBody();
        Object id = claims.get("id");
        Object username = claims.get("username");
        log.debug("从JWT中解析得到的管理员ID：{}", id);
        log.debug("从JWT中解析得到的管理员用户名：{}", username);

        // 基于解析JWT的结果创建认证信息
        Object principal = username; // 使用用户名作为当事人数据（临时）
        Object credentials = null; // 应该为null
        List<GrantedAuthority> authorities = new ArrayList<>();
        SimpleGrantedAuthority simpleGrantedAuthority = new SimpleGrantedAuthority("暂时给个山寨的权限");
        authorities.add(simpleGrantedAuthority);
        Authentication authentication = new UsernamePasswordAuthenticationToken(
                principal, credentials, authorities);

        // 将认证信息存入到SecurityContext中
        SecurityContext securityContext = SecurityContextHolder.getContext();
        securityContext.setAuthentication(authentication);

        // 过滤器链继承向后执行，即：放行
        // 如果没有执行以下代码，表示“阻止”，即此请求的处理过程到此结束，在浏览器中将显示一片空白
        filterChain.doFilter(request, response);
    }

}
```

为了便于观察测试结果，应该暂时取消控制器类中的：

- 检查权限
- 注入当事人信息

即临时注释掉一部分代码：

```java
// @PreAuthorize("hasAuthority('/ams/admin/read')")
@GetMapping("")
// public JsonResult<List<AdminListItemVO>> list(@ApiIgnore @AuthenticationPrincipal AdminDetails adminDetails) {
public JsonResult<List<AdminListItemVO>> list() {
    log.debug("开始处理【查询管理员列表】的请求，参数：无");
    // log.debug("当事人：{}", adminDetails);
    // log.debug("当事人的ID：{}", adminDetails.getId());
    // log.debug("当事人的用户名：{}", adminDetails.getUsername());
    List<AdminListItemVO> list = adminService.list();
    return JsonResult.ok(list);
}
```

完成后，只要携带有效的JWT，即可访问，如果未携带有效的JWT，将禁止访问（可能需要重启服务器端）。

# 关于secretKey的定义

应该将secretKey定义在配置文件（`application.yml`系列文件）中，以便于统一管理此值，并且，客户可以修改此值（如果定义在`.java`文件中，经过编译后，此值将无法修改）。

在`application-dev.yml`中添加自定义配置：

```yaml
# 当前项目中的自定义配置
csmall:
  # 与JWT相关的配置
  jwt:
    # 生成和解析JWT时使用的secret-key
    secret-key: 8ugLIU$#%^*&dlii9MutjKJoHhldSF)JFDL*urfda(&%&^invjfdsa
    # JWT的有效时长
    duration-in-minute: 14400
```

在`JwtAuthorizationFilter`中使用此配置：

```java
@Value("${csmall.jwt.secret-key}")
private String secretKey;

// 注意：删除原代码中解析JWT时使用的同名的局部变量
```

在`AdminServiceImpl`中作类似的处理！具体代码参考老师的源文件！







