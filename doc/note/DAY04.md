# 18. 添加Web开发的依赖项

在Spring Boot项目中，当需要实现Web开发（例如使用控制器接收客户端的请求并响应）时，需要添加`spring-boot-starter-web`依赖项（在创建项目时，勾选`Web`本质上也是添加此依赖项），此依赖项中包含了`spring-boot-starter`这个基础依赖项，所以，在现有的项目中，只需要将`spring-boot-starter`改为`spring-boot-starter-web`即可：

```xml
<!-- Spring Boot Web依赖项 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

当添加了以上依赖项，你的项目会有以下明显的变化：

- 启用项目时，会自动启用Tomcat（你的项目也会部署到这个Tomcat上），默认占用`8080`端口
- 在`src/main/resources`下的`static`文件夹会是默认的静态资源文件夹，在此文件夹下的资源（例如网页、图片等）可以直接通过HTTP协议的URL直接访问
  - 如果创建项目时勾选了`Web`依赖项，会自动创建此文件夹，如果创建项目时未勾选`Web`依赖项，而是手动添加`spring-boot-starter-web`，不会自动创建此文件夹，但可以手动创建，是等效的

在配置文件中，可以通过`server.port`属性指定Tomcat占用的端口号。

**提示：**端口号的最大值是`65535`，并且，一般不推荐使用低位端口，因为一些低位端口是默认用于特定的服务的，例如`21`端口用于FTP服务，`110`端口用于邮件服务，`80`端口用于HTTP服务，等等。

例如，在`application-dev.yml`中添加配置：

```yaml
# 服务器配置
server:
  # 服务端口
  port: 9080
```

# 19. 使用控制器接收并处理“添加相册”的请求

在项目的根包下创建`controller.AlbumController`类，在类上添加`@RestController`注解，在类中自动装配`IAlbumService`的对象，并且，自定义方法处理“添加相册”的请求：

```java
@RestController
public class AlbumController {
    
    @Autowired
    private IAlbumService albumService;
    
    // http://localhost:9080/album/add-new?name=TestAlbum001&description=TestDescription001&sort=88
    @RequestMapping("/album/add-new")
    public String xxx(AlbumAddNewDTO albumAddNewDTO) {
        try {
            albumService.addNew(albumAddNewDTO);
            return "添加相册成功！";
        } catch (ServiceException e) {
            return e.getMessage();
        }
    }
    
}
```

完成后，启动项目，可以通过 http://localhost:9080/album/add-new?name=TestAlbum001&description=TestDescription001&sort=88 测试访问，也可以修改此URL中的参数值多次尝试访问，当成功添加相册数据时，在浏览器中可以看到`添加相册成功！`的字样，如果相册名称被占用，可以看到`添加相册失败，相册名称已经被占用！`的字样。

**关于以上自动装配的`IAlbumService`**：不建议声明为具体的实现类，那样不利于代码“解耦”！

# 20. 关于`@RequestMapping`注解

在Spring MVC框架中，`@RequestMapping`注解的主要作用是配置“请求路径”与“处理请求的方法”的映射关系。

在`@RequestMapping`的源代码中，可以看到它的声明：

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Mapping
public @interface RequestMapping {
    // 暂不关心内部代码
}
```

声明上的`@Target`注解表示当前注解（`@RequestMapping`）可以添加在哪里，`@Target`注解参数为`{ElementType.TYPE, ElementType.METHOD}`，表示可以添加在“类型”上，也可以添加在“方法”上。

通常，建议在每个控制器类上都使用`@RequestMapping`配置当前类中多个处理的请求的路径的共有部分，例如：

```java
@RestController
@RequestMapping("/album") // 【重要】
public class AlbumController {

    // http://localhost:9080/album/add-new
    @RequestMapping("/add-new")
    public String addNew() {
        // 暂不关心方法的实现
        return null;
    }

    // http://localhost:9080/album/delete
    @RequestMapping("/delete")
    public String delete() {
        // 暂不关心方法的实现
        return null;
    }
    
    // http://localhost:9080/album/update
    @RequestMapping("/update")
    public String update() {
        // 暂不关心方法的实现
        return null;
    }
    
    // http://localhost:9080/album/list
    @RequestMapping("/list")
    public String list() {
        // 暂不关心方法的实现
        return null;
    }

}
```

在配置路径时，Spring MVC会自动处理必要的`/`（如果缺少，则添加，如果多余，则去除），例如，以下几种配置是完全等效的：

| 类上的配置值 | 方法上的配置值 |
| ------------ | -------------- |
| /album       | /add-new       |
| /album       | add-new        |
| /album/      | /add-new       |
| /album/      | add-new        |
| album/       | /add-new       |
| album/       | add-new        |
| album        | /add-new       |
| album        | add-new        |

具体使用哪组配置，并没有明确的要求，只需要保证同一个项目中的风格统一即可，例如，推荐使用第1组，或最后一组，不推荐偶尔使用某一组，在其它类中又使用其它组，另外，第1组或最后一组在阅读理解上通常没有歧义，但其它组可能会产生歧义，不太推荐。

在`@RequestMapping`的源代码中还有：

```java
String[] value() default {};
```

以上`value()`表示此注解中可以配置名为`value`的属性，例如：`@RequestMapping(value = ???)`。

以上`String[]`表示`value`属性的值类型，例如：`@RequestMapping(value = {"a", "b"})`。

以上`default {}`表示`value`属性的默认值是空数组。

在Java语言中，`value`是注解的默认属性，当配置注解参数时，只配置`value`这1个属性时，可以不必显式的写出属性名称，例如以下2种配置是完全等效的：

```java
@RequestMapping(value = {"a", "b"})
```

```java
@RequestMapping({"a", "b"})
```

在Java语言中，如果需要配置的注解属性的值是某种数组类型的，但是当前只配置1个值（数组只有1个元素）时，可以不必使用大括号将值框住，例如以下2种配置是完全等效的：

```java
@RequestMapping(value = {"a"})
```

```java
@RequestMapping(value = "a")
```

所以，在以上的控制器类中，配置的`@RequestMapping("/add-new")`其实配置的就是注解的`value`属性！

在`@RequestMapping`的源代码中，`value`属性的声明上还有`@AliasFor`注解的配置：

```java
@AliasFor("path")
String[] value() default {};
```

以上`@AliasFor`表示当前属性（`value`）等效于同注解内的`path`属性！

在`@RequestMapping`的源代码中，`path`属性的源代码为：

```java
@AliasFor("value")
String[] path() default {};
```



在`@RequestMapping`的源代码中，还有`method`属性：

```java
RequestMethod[] method() default {};
```

此`method`属性的作用是**限制请求方式**，当没有配置此属性时，所有请求方式都是允许的！

此`method`属性的值类型是`RequestMethod`（是一种枚举类型）的数组。

例如，可以配置为：

```java
@RequestMapping(value = "/add-new", method = RequestMethod.POST)
```

如果要允许多种请求方式，可以将`method`属性值配置为数组，例如：

```java
@RequestMapping(value = "/add-new", method = {RequestMethod.POST, RequestMethod.GET})
```

在同一个项目中，允许存在多个请求方式不同，但请求路径相同的配置，例如：

```java
@RequestMapping(value = "/add-new", method = RequestMethod.GET)
public String xxx() {
    // 暂不关心方法的实现
}
```

```java
@RequestMapping(value = "/add-new", method = RequestMethod.POST)
public String xxx() {
    // 暂不关心方法的实现
}
```

以上2段代码是允许共存的！

为了简化限制请求方式的配置语法，Spring MVC框架还提供了基于`@RequestMapping`的衍生注解，例如：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@RequestMapping(method = RequestMethod.GET)
public @interface GetMapping {
    // 内部的各属性都是等效于@RequestMapping的同名属性的，并且，没有声明method属性
}
```

以上`@GetMapping`就相当于是将请求方式限制为`GET`的`@RequestMapping`，并且，其源代码中的`@Target`的参数值决定了它只能添加在方法上。

与`@GetMapping`类似的注解还有：`@PostMapping`、`@PutMapping`、`@DeleteMapping`、`@PatchMapping`。

# 21. 关于Knife4j框架

Knife4j是一款在线API文档框架，可以基于当前项目的控制器类中的配置生成文档，并自带调试功能。

在项目中使用Knife4j需要3个步骤：

- 添加依赖
  - **注意：**本次使用的Knife4j的版本，要求项目中的Spring Boot版本必须是2.6以下版本（不包含2.6）
- 在主配置文件（`application.properties` / `application.yml`）中开启增强模式
  - 配置`knife4j.enable`属性，取值为`true`
- 添加配置类
  - 是相对固定的代码，复制粘贴即可
  - **注意：**需要检查配置类中所配置的包名，必须是当前项目中控制器类所在的包

先在`pom.xml`中添加依赖：

```xml
<!-- Knife4j Spring Boot：在线API -->
<dependency>
    <groupId>com.github.xiaoymin</groupId>
    <artifactId>knife4j-spring-boot-starter</artifactId>
    <version>2.0.9</version>
</dependency>
```

然后，在`application.yml`中添加配置：

```yaml
# Knife4j配置
knife4j:
  # 开启增强模式
  enable: true
```

最后，在项目的根包下的`config`包中，创建`Knife4jConfiguration`配置类，代码如下：

```java
package cn.tedu.csmall.product.config;

import com.github.xiaoymin.knife4j.spring.extension.OpenApiExtensionResolver;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2WebMvc;

/**
 * Knife4j配置类
 *
 * @author java@tedu.cn
 * @version 0.0.1
 */
@Slf4j
@Configuration
@EnableSwagger2WebMvc
public class Knife4jConfiguration {

    /**
     * 【重要】指定Controller包路径
     */
    private String basePackage = "cn.tedu.csmall.product.controller";
    /**
     * 分组名称
     */
    private String groupName = "product";
    /**
     * 主机名
     */
    private String host = "http://java.tedu.cn";
    /**
     * 标题
     */
    private String title = "酷鲨商城在线API文档--商品管理";
    /**
     * 简介
     */
    private String description = "酷鲨商城在线API文档--商品管理";
    /**
     * 服务条款URL
     */
    private String termsOfServiceUrl = "http://www.apache.org/licenses/LICENSE-2.0";
    /**
     * 联系人
     */
    private String contactName = "Java教学研发部";
    /**
     * 联系网址
     */
    private String contactUrl = "http://java.tedu.cn";
    /**
     * 联系邮箱
     */
    private String contactEmail = "java@tedu.cn";
    /**
     * 版本号
     */
    private String version = "1.0.0";

    @Autowired
    private OpenApiExtensionResolver openApiExtensionResolver;

    public Knife4jConfiguration() {
        log.debug("创建配置类对象：Knife4jConfiguration");
    }

    @Bean
    public Docket docket() {
        String groupName = "1.0.0";
        Docket docket = new Docket(DocumentationType.SWAGGER_2)
                .host(host)
                .apiInfo(apiInfo())
                .groupName(groupName)
                .select()
                .apis(RequestHandlerSelectors.basePackage(basePackage))
                .paths(PathSelectors.any())
                .build()
                .extensions(openApiExtensionResolver.buildExtensions(groupName));
        return docket;
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title(title)
                .description(description)
                .termsOfServiceUrl(termsOfServiceUrl)
                .contact(new Contact(contactName, contactUrl, contactEmail))
                .version(version)
                .build();
    }
}
```

完成后，启用项目，通过 doc.html 即可访问在线API文档，即：http://localhost:9080/doc.html

为了更好的显示API文档，应该通过相关注解进行配置：

- `@Api`：添加在控制器类上，通过此注解的`tags`属性，可配置管理模块的名称，在配置管理模块名称时，可以在各名称前面添加数字或字母进行序号的排列，使得各管理模块的显示顺序是自定义的顺序
  - 例如：`@Api(tags = "1. 相册管理模块")`
- `@ApiOperation`：添加在控制器类中处理请求的方法上，通过此注解的`value`属性，可配置业务的名称
  - 例如：`@ApiOperation("添加相册")`
- `@ApiOperationSupport`：添加在控制器类中处理请求的方法上，通过此注解的`order`属性（`int`类型），可配置业务的排序序号，各业务将按照此序号升序排列
  - 例如：`@ApiOperationSupport(order = 400)`
  - 提示：不建议将序号排列的过于紧凑，否则，不利于在已有的顺序中插入新的内容

- `@ApiModelProperty`：添加在POJO类型的属性上，通过此注解的`value`属性，可配置属性的名称，通过此注解的`required`属性，可配置是否必须提交此参数（但不具备检查功能），通过此注解的`example`属性，可配置示例值（需要注意数据类型的问题，例如数值型的属性不要配置字母或符号作为示例值），通过此注解的`dataType`属性，可配置数据类型，例如配置为`dataType = "long"`，但此属性通常不需要配置此属性

  - ```java
    public class AlbumAddNewDTO implements Serializable {
        @ApiModelProperty(value = "相册名称", required = true, example = "小米手机的相册")
        private String name;
    }
    ```

- `@ApiImplicitParam`：添加在控制器类中处理请求的方法上，用于对未封装的请求参数进行配置，必须通过此注解的`name`属性，指定配置哪个参数，其它属性的配置可参考`@ApiModelProperty`中的属性，需要注意的是，一旦通过此注解进行配置，在API文档上显示的数据类型默认是`string`，对于非字符串类型的属性，应该显式的配置`dataType`属性

  - 例如：`@ApiImplicitParam(name = "id", value = "相册ID", required = true, example = "9527", dataType = "long")`

- `@ApiImplicitParams`：添加在控制器类中处理请求的方法上，当方法的参数超过1个，且都需要配置API文档说明时，必须将多个`@ApiImplicitParam`注解配置作为此注解（`@ApiImplicitParams`）的参数（此注解参数是`@ApiImplicitParam`数组类型）

  - ```java
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "相册ID", required = true, example = "9527", dataType = "long"),
            @ApiImplicitParam(name = "userId", value = "用户ID", required = true, example = "9527", dataType = "long")
    })
    public String delete(Long id, Long userId) {
        return null;
    }
    ```

# 22. 关于处理请求的方法的返回值

在Spring MVC框架中，处理请求的方法的返回值，默认表示“视图组件的名称”，即“处理完请求后，由哪个视图来负责显示”，这**不是**前后端分离的做法。

在前后端分离的做法中，服务器端是**不处理**视图的，而是将处理请求后得到的**数据**响应到客户端，由客户端决定如何处理此数据。

在处理请求的方法上，使用`@ResponseBody`注解，可以使得此方法是**响应正文**的，即：方法的返回值会直接响应到客户端去！

还可以将`@ResponseBody`注解添加在控制器类上，则当前控制器类中所有处理请求的方法都是**响应正文**的。

添加了`@Controller`注解的类会被作为控制器类，也可以改为使用`@RestController`，其源代码如下：

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Controller
@ResponseBody
public @interface RestController {

	@AliasFor(annotation = Controller.class)
	String value() default "";

}
```

所以，在类上添加`@RestController`，可以将此类标记为控制器类，并且，表示此类中所有处理请求的方法都是响应正文的！









