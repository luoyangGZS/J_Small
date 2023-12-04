# 30. 关于REST（RESTful）

关于RESTful（通常简称为：REST）：

> 【百科资料】RESTFUL是一种网络应用程序的设计风格和开发方式，基于HTTP，可以使用XML格式定义或JSON格式定义。RESTFUL适用于移动互联网厂商作为业务接口的场景，实现第三方OTT调用移动网络资源的功能，动作类型为新增、变更、删除所调用资源。

重点：RESTful是一种设计风格。

RESTful风格的典型特征有：

- 服务器端处理请求后，是响应正文的，是前后端分离的

- 可能将某些具有唯一性，且不敏感的参数值，设计为URL的一部分，例如：

  ```
  https://blog.csdn.net/gjs935219/article/details/102531854
  ```

  如果采取传统的做法，以上URL应该设计为：

  ```
  https://blog.csdn.net/article/details?username=gjs935219&id=102531854
  ```

- 同一个URL，可能用于多种不同的数据处理，当然，请求方式会被设计为不同的（增：`POST` / 删：`DELETE` / 改：`PUT` / 查：`GET`），例如：

  - 请求路径：`/album/9527`，请求方式：`GET`，操作：查询id值为`9527`的相册数据
  - 请求路径：`/album/9527`，请求方式：`DELETE`，操作：删除id值为`9527`的相册数据
  - 请求路径：`/album/9527`，请求方式：`PUT`，操作：修改id值为`9527`的相册数据
  - 注意：这种设计的做法在绝大部分业务系统中并不适用，在业务系统中，通常仍是只采用`GET`和`POST`这2种请求方式，并且，以查询为主要目的请求会设计为`GET`，除此以外的所有请求都会设计为`POST`
  - 提示：这种设计通常用于对数据源直接操作的场景，例如在Elasticsearch的学习中可以接触到

注意：RESTful中是一种设计风格，并不一定是必须遵守的！

Spring MVC框架很好的支持了RESTful，在设计URL时，可以使用`{自定义名称}`的占位符表示此处应该是某个参数值，例如：

```java
@PostMapping("/{id}/delete")
```

当设计成以上格式，则客户端提交请求时，占位符位置无论是什么值，都可以匹配上以上设计的路径！

然后，在处理请求的方法的参数列表中，添加对应此占位符参数值的请求参数，并且，在此请求参数上使用`@PathVariable`注解，例如：

```java
@PostMapping("/{id}/delete")
public ??? delete(@PathVariable Long id) {
    // 暂不关心方法的实现
}
```

如果占位符中的名称，和请求参数的名称不一致，需要在`@PathVariable`注解中配置占位符名称，而请求方法的参数名称就不重要了，例如：

```java
@PostMapping("/{id}/delete")
public ??? delete(@PathVariable("id") Long albumId) {
    // 暂不关心方法的实现
}
```

需要注意：如果客户端提交的请求路径中，占位符位置的内容无法被转换成`Long`类型时，将出现`400`错误。

在设计占位符时，可以在占位符名称的右侧、在右大括号的左侧添加1个冒号，并在冒号的右侧可以添加正则表达式，以限制参数值的基本格式，例如：

```java
@PostMapping("/{id:[0-9]+}/delete")
public ??? delete(@PathVariable Long id) {
    // 暂不关心方法的实现
}
```

如果客户端提交的请求路径中，占位符位置的内容不匹配以上正则表达式时，将出现`404`错误。

另外，你应该知道，不冲突的、使用了占位符及正则表达式的配置，是允许共存的，例如：

```java
@Get("/{id:[0-9]+}")
public ??? getStandardById(@PathVariable Long id) {
    // 暂不关心方法的实现
}

@Get("/{name:[a-z]+}")
public ??? getStandardByName(@PathVariable String name) {
    // 暂不关心方法的实现
}
```

但是，如果同一个请求能够匹配上2个或以上使用了占位符及正则表达式的配置，将出现错误，例如配置为：

```java
@Get("/{id:[0-9]+}")
public ??? getStandardById(@PathVariable Long id) {
    // 暂不关心方法的实现
}

@Get("/{name:[0-9a-z]+}")
public ??? getStandardByName(@PathVariable String name) {
    // 暂不关心方法的实现
}
```

在以上配置中，如果占位符的值是纯数字的，将可以匹配以上2个正则表达式，则Spring MVC框架无法选取，将出现错误！

另外，你还应该知道，不使用占位符的配置，与使用了占位符的配置，是允许共存的，例如：

```java
@Get("/{name:[a-z]+}")
public ??? getStandardByName(@PathVariable String name) {
    // 暂不关心方法的实现
}

@Get("/test")
public ??? testStandardByName(String name) {
    // 暂不关心方法的实现
}
```

当提交了对应 `/test` 的请求时，会执行以上第2个方法，即精准匹配的方法，而不会执行使用了占位符的方法。

在开发实践中，如果没有明确的规定（例如开发团队中尚未决定使用什么样的URL风格），可以参考：

- 获取数据列表：`/数据类型的复数`
  - 例如：`/albums`
- 根据ID获取某条数据：`/数据类型的复数/{id}`
  - 例如：`/albums/{id:[0-9]+}`
- 根据ID对某条数据执行某种操作：`/数据类型的复数/{id}/命令`，或`/数据类型的复数/{id}/数据属性/命令`
  - 例如：`/albums/{id:[0-9]+}/delete`

# 31. Spring Validation

## 31.1. 关于Spring Validation

Spring Validation框架是用于检查请求参数的**基本格式**的框架，例如，检查某个请求参数是否为`null`、检查某个字符串的长度、检查某个字符串是否为空字符串、检查数字值的区间等等。

在Spring Boot项目，添加`spring-boot-starter-validation`依赖项即可使用它：

```xml
<!-- Spring Boot Validation依赖项，用于检查请求参数的基本格式 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

## 31.2. 检查POJO类型的请求参数

当需要对POJO类型的请求参数进行检查时，首先，需要在处理请求的方法的被检查参数上添加`@Valid`或`@Validated`注解，表示需要对此参数进行检查，例如：

```java
@PostMapping("/add-new")
//                       ↓↓↓↓↓↓ 添加注解
public JsonResult addNew(@Valid AlbumAddNewDTO albumAddNewDTO) {
    log.debug("开始处理【添加相册】的请求，参数：{}", albumAddNewDTO);
    albumService.addNew(albumAddNewDTO);
    return JsonResult.ok();
}
```

然后，在POJO类的属性上，添加你需要的检查注解（根据不同的检查规则，使用不同的检查注解），例如，当某个请求参数是必须提交的，可以添加`@NotNull`注解，例如，在`AlbumAddNewDTO`类中：

```java
@Data
public class AlbumAddNewDTO implements Serializable {

    @NotNull // 新增的注解
    private String name;
 
    // 暂不关心其它代码
}
```

至此，已经能够实现对以上`name`属性进行“不允许为`null`”的检查，如果客户端提交的请求参数中不包含`name`属性，服务器端将响应`400`错误。

在使用检查注解（例如`@NotNull`）上可以配置`message`属性，用于配置“检查不通过时的提示文本”，例如：

```java
@NotNull(message = "添加相册失败，必须提交相册名称！")
private String name;
```

## 31.3. 处理BindException

当检查不通过时，服务器端除了响应`400`错误以外，默认情况下，在服务器端的控制台还会出现错误信息：

```
2023-01-03 14:06:02.125  WARN 4540 --- [nio-9080-exec-1] .w.s.m.s.DefaultHandlerExceptionResolver : Resolved [org.springframework.validation.BindException: org.springframework.validation.BeanPropertyBindingResult: 1 errors<LF>Field error in object 'albumAddNewDTO' on field 'name': rejected value [null]; codes [NotNull.albumAddNewDTO.name,NotNull.name,NotNull.java.lang.String,NotNull]; arguments [org.springframework.context.support.DefaultMessageSourceResolvable: codes [albumAddNewDTO.name,name]; arguments []; default message [name]]; default message [添加相册失败，必须提交相册名称！]]
```

先在`ServiceCode`中添加新的枚举值：

```java
public enum ServiceCode {

    OK(20000),
    ERR_BAD_REQUEST(40000), // 新增
    ERR_NOT_FOUND(40400),
    ERR_CONFLICT(40900);
    
    // 暂不关心其它代码
    
}
```

再在全局异常处理器（`GlobalExceptionHandler`）中添加对以外`BindException`的处理。

需要注意，不可以直接`BindException`对象调用`getMessage()`直接获取异常的信息，例如以下做法就是错误的：

```java
@ExceptionHandler
public JsonResult handleBindException(BindException e) {
    log.warn("程序运行过程中出现BindException，将统一处理！");
    log.warn("异常信息：{}", e.getMessage());
    String message = e.getMessage();
    return JsonResult.fail(ServiceCode.ERR_BAD_REQUEST, message);
}
```

如果按照以上处理方式，当检查不通过时，响应的结果为：

```json
{
  "state": 40000,
  "message": "org.springframework.validation.BeanPropertyBindingResult: 1 errors\nField error in object 'albumAddNewDTO' on field 'name': rejected value [null]; codes [NotNull.albumAddNewDTO.name,NotNull.name,NotNull.java.lang.String,NotNull]; arguments [org.springframework.context.support.DefaultMessageSourceResolvable: codes [albumAddNewDTO.name,name]; arguments []; default message [name]]; default message [添加相册失败，必须提交相册名称！]"
}
```

应该从`BindException`对象中获取`FieldError`对象，然后，再通过`FieldError`对象的`getDefaultMessage()`获取此前在`@NotNull`这种检查注解中配置的提示文本，例如：

```java
@ExceptionHandler
public JsonResult handleBindException(BindException e) {
    log.warn("程序运行过程中出现BindException，将统一处理！");
    log.warn("异常信息：{}", e.getMessage());
    FieldError fieldError = e.getFieldError();
    String message = fieldError.getDefaultMessage();
    return JsonResult.fail(ServiceCode.ERR_BAD_REQUEST, message);
}
```

则检查不通过时的响应中，`message`属性中只有检查注解中配置的提示文本，例如：

```json
{
  "state": 40000,
  "message": "添加相册失败，必须提交相册名称！"
}
```

**注意：**如果使用了多个检查注解，并且，客户端提交的请求参数有多个错误，Validation框架会检查所有错误，并汇总所有错误信息！

例如，对所有请求参数都添加`@NotNull`注解：

```java
@Data
public class AlbumAddNewDTO implements Serializable {

    @NotNull(message = "添加相册失败，必须提交相册名称！")
    private String name;

    @NotNull(message = "添加相册失败，必须提交相册简介！")
    private String description;

    @NotNull(message = "添加相册失败，必须提交排序序号！")
    private Integer sort;

}
```

此时，如果暂时不使用全局异常处理器，当提交请求时，所有请求参数都不提交，异常信息为：

```
2023-01-03 14:22:42.357  WARN 15868 --- [nio-9080-exec-1] .w.s.m.s.DefaultHandlerExceptionResolver : Resolved [org.springframework.validation.BindException: org.springframework.validation.BeanPropertyBindingResult: 3 errors<LF>Field error in object 'albumAddNewDTO' on field 'description': rejected value [null]; codes [NotNull.albumAddNewDTO.description,NotNull.description,NotNull.java.lang.String,NotNull]; arguments [org.springframework.context.support.DefaultMessageSourceResolvable: codes [albumAddNewDTO.description,description]; arguments []; default message [description]]; default message [添加相册失败，必须提交相册简介！]<LF>Field error in object 'albumAddNewDTO' on field 'name': rejected value [null]; codes [NotNull.albumAddNewDTO.name,NotNull.name,NotNull.java.lang.String,NotNull]; arguments [org.springframework.context.support.DefaultMessageSourceResolvable: codes [albumAddNewDTO.name,name]; arguments []; default message [name]]; default message [添加相册失败，必须提交相册名称！]<LF>Field error in object 'albumAddNewDTO' on field 'sort': rejected value [null]; codes [NotNull.albumAddNewDTO.sort,NotNull.sort,NotNull.java.lang.Integer,NotNull]; arguments [org.springframework.context.support.DefaultMessageSourceResolvable: codes [albumAddNewDTO.sort,sort]; arguments []; default message [sort]]; default message [添加相册失败，必须提交排序序号！]]
```

可以看到，当出现3种错误时，3种错误的信息都会被包含在`BindException`异常对象中，如果启用全局异常处理器，响应结果中的提示文本将是以上3种错误中的某1个提示文本，具体是哪一个，是不可控的！

当客户端提交的请求参数有多种错误时，可以：

- 一次性提示全部种类的错误
- 固定的提示某1种错误

当需要提示全部种类的错误时，首先，应该调整`@NotNull`注解中的提示文本，应该不要包含共有的部分（否则，多段信息拼接成1个字符串后，存在多个相同的部分），例如配置为：

```java
@Data
public class AlbumAddNewDTO implements Serializable {

    @NotNull(message = "必须提交相册名称")
    private String name;

    @NotNull(message = "必须提交相册简介")
    private String description;

    @NotNull(message = "必须提交排序序号")
    private Integer sort;

}
```

然后，在处理异常时，先通过`BindException`对象的`getFieldErrors()`方法获取所有的错误，然后，对其进行遍历，并拼接每个错误中封装的提示文本，例如：

```java
@ExceptionHandler
public JsonResult handleBindException(BindException e) {
    log.warn("程序运行过程中出现BindException，将统一处理！");
    log.warn("异常信息：{}", e.getMessage());
    StringJoiner stringJoiner = new StringJoiner("，", "请求参数格式错误，", "！");
    List<FieldError> fieldErrors = e.getFieldErrors();
    for (FieldError fieldError : fieldErrors) {
        stringJoiner.add(fieldError.getDefaultMessage());
    }
    return JsonResult.fail(ServiceCode.ERR_BAD_REQUEST, stringJoiner.toString());
}
```

在使用Validation框架检查请求参数格式时，可以将其配置为“快速失败”，即：当检查到第1个错误时，就不再继续检查请求参数的格式了，而是直接反馈错误结果！

关于“快速失败”的配置，需要自定义配置类来配置，在项目的根包下创建`config.ValidationConfiguration`类，在类上添加`@Configuration`注解，并在此类中通过`@Bean`注解配置`Validator`对象：

```java
@Slf4j
@Configuration
public class ValidationConfiguration {

    @Bean
    public javax.validation.Validator validator() {
        return Validation.byProvider(HibernateValidator.class)
                .configure() // 开始配置
                .failFast(true) // 配置快速失败
                .buildValidatorFactory() // 构建Validator工厂
                .getValidator(); // 从Validator工厂中获取Validator对象
    }

}
```

完成以上配置后，再次尝试提交请求，无论请求参数有多少种错误，都只会提示其中固定的1种错误！

当有了快速失败机制后，检查时最多只会有1个错误，在处理异常时，可以不必获取所有错误信息，而是直接获取仅有的那1个错误信息并提示出来即可！

所以，在各属性上可以使用完整的描述，例如：

```java
@Data
public class AlbumAddNewDTO implements Serializable {

    @NotNull(message = "添加相册失败，必须提交相册名称！")
    private String name;

    @NotNull(message = "添加相册失败，必须提交相册简介！")
    private String description;

    @NotNull(message = "添加相册失败，必须提交排序序号！")
    private Integer sort;

}
```

并且，在处理异常时也进行调整：

```java
@ExceptionHandler
public JsonResult handleBindException(BindException e) {
    log.warn("程序运行过程中出现BindException，将统一处理！");
    log.warn("异常信息：{}", e.getMessage());
    return JsonResult.fail(ServiceCode.ERR_BAD_REQUEST, 
                           e.getFieldError().getDefaultMessage());
}
```

## 31.4. 检查未封装的请求参数

如果某些请求的参数数量较少，或各参数并不相关，通常不会将参数封装到POJO类型中，例如：

```java
// http://localhost:9080/albums/9527/delete
@PostMapping("/{id:[0-9]+}/delete")
public String delete(@PathVariable Long id) {
    // 暂不关心方法的具体实现
}
```

当需要检查这类请求参数时，首先，需要在当前类上添加`@Validated`注解，例如：

```java
@RestController
@Validated // 新增
public class AlbumController {
    // 暂不关心类内部的代码
}
```

然后，在需要检查的参数上添加检查注解，例如：

```java
// http://localhost:9080/albums/9527/delete
@PostMapping("/{id:[0-9]+}/delete")
//                   ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 新增的检查注解
public String delete(@Range(min = 1, max = 10000) @PathVariable Long id) {
    // 暂不关心方法的具体实现
}
```

**提示：**以上`@Range`注解是用于检查数值类型的请求参数的值是否在指定的区间范围内的。

**注意：**这种检查方式出现的异常，与检查POJO类型的请求参数的并不相同，这种检查抛出的异常类型是`ConstraintViolationException`。

## 31.5. 处理ConstraintViolationException

为了更好的处理异常，首先，检查注解依然需要配置`message`属性，例如：

```java
@PostMapping("/{id:[0-9]+}/delete")
//												  ↓↓↓↓↓↓↓ 配置message属性
public String delete(@Range(min = 1, max = 10000, message = "删除相册失败，相册ID非法！")
                         @PathVariable Long id) {
    // 暂不关心方法的实现
}
```

然后，在全局异常处理器中添加对此类异常的处理：

```java
@ExceptionHandler
public JsonResult handleConstraintViolationException(ConstraintViolationException e) {
    log.warn("程序运行过程中出现handleConstraintViolationException，将统一处理！");
    log.warn("异常信息：{}", e.getMessage());
    // 由于ConstraintViolationException的API的设计，只能拿到“所有错误”的集合，才能进一步拿到错误的提示文本
    Set<ConstraintViolation<?>> constraintViolations = e.getConstraintViolations();
    String message = "";
    for (ConstraintViolation<?> constraintViolation : constraintViolations) {
        message = constraintViolation.getMessage();
    }
    return JsonResult.fail(ServiceCode.ERR_BAD_REQUEST, message);
}
```

## 31.6. 常用的检查注解

使用Validation框架检查数据的基本格式时，常用的检查注解有：

- `@NotNull`：不允许为`null`值，即客户端必须提交此参数
  - 可用于任何类型的参数
- `@NotEmpty`：不允许为空字符串，即不允许是长度为0的字符串
  - 仅用于字符串类型的参数
- `@NotBlank`：不允许为空白的字符串，即不允许仅由空格、TAB制表位、换行等空白组成的字符串
  - 仅用于字符串类型的参数
- `@Length`：限制字符串的长度，也可以用于检查集合等数据的长度，但不常见
  - 通常仅用于字符串类型的参数
- `@Pattern`：通过正则表达式检查字符串的格式，此注解的`regexp`属性是定义正则表达式的属性
  - 仅用于字符串类型的参数
- `@Min`：限制最小值
  - 仅用于整型数值类型的参数
- `@Max`：限制最大值
  - 仅用于整型数值类型的参数
- `@Range`：限制取值区间，默认最小值为`0`，最大值是`long`类型的上限值
  - 仅用于整型数值类型的参数

**提示：**在源代码中，找到某个检查注解的`import`语句，按住Ctrl键点击此注解的包名，在IntelliJ IDEA的左侧面板中就会显示此包下的内容，即此包下所有的检查注解（检查注解都在同一个包中），需要注意，有2套检查注解的包，例如`@NotNull`和`@Range`这2个注解就在不同的包下。

关于检查注解的使用：

- 所有检查注解都有`message`属性，用于配置**检查失败时的提示文本**
- 每个被检查的请求参数都**可以同时添加多个检查注解**
- `@NotNull`注解可以添加在任何类型的请求参数上，并且，**除了`@NotNull`以外的所有检查注解在参数为`null`时都会视为检查通过**！或理解为**其它检查注解仅当数据不为`null`时才会生效**，所以，许多检查规则都会同时使用`@NotNull`与另1个或多个检查注解，除非你允许这个参数是`null`值。

# 33. 关于检查请求参数的原则

通常，服务器端对客户端提交的请求参数的值应该保持“不信任”的态度，哪怕客户端软件（网页、手机APP等）有严格的检查机制，主要原因在于：

- 客户端软件是运行在用户的设备上的，存在客户端软件被篡改的可能
- 某些项目可能有多种不同的客户端（既有网页端，又有手机端，甚至还有其它客户端），检查规则可能并不统一
- 某些用户没有及时更新客户端软件的版本，旧版的客户端软件的检查规则与服务器端新的规则并不对应

所以，为了保证各请求参数的有效性，**必须在服务器端进行检查**！

**注意：**即使服务器端存在检查请求参数的机制，**客户端仍有必要对即将提交的请求参数进行检查**！因为：

- 客户端的程序是在用户的设备上离线运行，在客户端检查时，不消耗服务器端资源，也不必联网，能够更快的响应用户的操作，对用户的体验更好
- 可以阻止绝大部分错误的请求提交到服务器端，能有效的缓解服务器端的压力
  - 以上列举的“服务器端不信任客户端提交的请求参数”的原因都是极小概率的事件

# 34. 处理Throwable

随着开发进度的推进，需要处理的异常会越来越多，但是，无论添加多少处理异常的方法，仍可能存在遗漏，为了避免因为某个异常未被处理，导致服务器端响应500错误，应该在全局异常处理中添加处理`Throwable`的方法：

```java
// 注意：以下方法存在的意义主要在于：避免因为某个异常未被处理，导致服务器端响应500错误
// 注意：e.printStackTrace()通常是禁止使用的，因为其输出方式是阻塞式的！
//      以下方法中使用了此语句，是因为用于发现错误，并不断的补充处理对应的异常的方法
//      随着开发进度的推进，执行到以下方法的概率会越来越低，
//      出现由于此语句导致的问题的概率也会越来越低，
//      甚至补充足够多的处理异常的方法后，根本就不会执行到以下方法了
//      当项目上线后，可以将此语句删除
@ExceptionHandler
public JsonResult handleThrowable(Throwable e) {
    log.warn("程序运行过程中出现Throwable，将统一处理！");
    log.warn("异常类型：{}", e.getClass());
    log.warn("异常信息：{}", e.getMessage());
    String message = "【开发阶段专用】你的服务器端出了异常，请检查服务器端控制台中的异常信息，并补充处理此类异常的方法！";
    // String message = "服务器忙，请稍后再尝试！"; // 项目上线时应该使用此提示文本
    e.printStackTrace(); // 打印异常的跟踪信息，主要是为了在开发阶段更好的检查出现异常的原因
    return JsonResult.fail(ServiceCode.ERR_UNKNOWN, message);
}
```

并且，每次程序运行至此处时，都应该检查服务器端的控制台，分析问题出现的原因，并添加处理此类异常的方法。



