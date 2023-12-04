# 68. 基于Spring JDBC框架的事务管理

事务（Transaction）：是数据库（例如MySQL等）中的能够保障若干个写操作（增、删、改）要么全部成功，要么全部失败的机制。

对于数据的管理，无论是全部成功，或全部失败，其实，都是可以接受的结果，而只成功一半，是不可接受的！例如，存在某个转账操作：

```mysql
update 存款表 set 余额=余额-10000 where 账户='国斌';
```

```mysql
update 存款表 set 余额=余额+10000 where 账户='苍松';
```

在基于Spring JDBC框架的事务管理中，使用`@Transcational`注解，即可使得对应的方法是“事务性”的。

> 提示：主流的基于Spring体系的编程框架，在处理数据库编程时，都使用到了Spring JDBC。

使用`@Transactional`注解实现事务，被称之为“声明式事务”。

关于此注解，可以添加在：

- 业务接口上
  - 将作用于实现此接口的实现类中的所有重写的方法上
- 业务接口中的抽象方法上
  - 将作用于实现此接口的实现类中的重写的对应的方法上
- 业务实现类上
  - 将作用于当前类中的所有重写的接口中定义的方法
- 业务实现类中重写的接口中定义的方法上
  - 将作用于当前方法

在应用时，仅当某个业务方法中包含超过1次的写操作（例如2次UPDATE，或1次INSERT加上1次DELETE，或者1次UPDATE加上2次DELETE等），才必须保障此业务是事务性的！反之，如果某个业务方法中的写操作不超过1次，可以不必是事务性的！

在Spring JDBC框架中，对事务的处理大致流程是：

```
try {
    开启事务：BEGIN
    <执行业务方法>
    提交事务：COMMIT
} catch (RuntimeException e) {
	回滚事务：ROLLBACK
}
```

也就是说，在基于Spring JDBC的事务管理中，仅当出现了`RuntimeException`（包含其子孙类异常）时才会执行回滚！所以，当执行写操作后，应该获取返回的“受影响的行数”，并判断是否为预期值，如果不是，必须抛出`RuntimeException`或其子孙类异常，以使得事务回滚！

在`@Transactional`注解中，可以通过`rollbackFor`属性或`rollbackForClassName`属性，来指定根据哪种`RuntimeException`执行回滚，还可以通过`noRollbackFor`属性或`noRollbackForClassName`，来指定对于哪些异常不执行回滚，以上4个属性都是数组类型的。

**【小结】**

- 如果某个业务方法中包含超过1次的写操作，**必须**保障此业务是事务性的
- 在业务方法中调用Mapper的增、删、改操作后，**必须**获取返回的“受影响的行数”，并判断是否为预期值，如果不是，必须抛出`RuntimeException`或其子孙类异常

另外，推荐课后了解以下内容：

- 事务的ACID特性
- 事务的传播
- 事务的隔离

# 69. 删除类别--Controller层

```java
// http://localhost:9080/categories/9527/delete
@PostMapping("/{id:[0-9]+}/delete")
@ApiOperation("根据id删除类别")
@ApiOperationSupport(order = 200)
@ApiImplicitParam(name = "id", value = "类别ID", required = true, example = "9527", dataType = "long")
public JsonResult<Void> delete(@Range(min = 1, max = 1000000, message = "删除类别失败，类别ID非法！")
                               @PathVariable Long id) {
    log.debug("开始处理【根据id删除类别】的请求，参数：{}", id);
    categoryService.delete(id);
    return JsonResult.ok();
}
```

# 70. 启用/禁用类别--Mapper层

此前已经完成！

# 71. 启用/禁用类别--Service层

在`ICategoryService`接口中添加抽象方法：

```java
void setEnable(Long id);
void setDisable(Long id);
```

在`CategoryServiceImpl`类中实现以上方法：

```java
public void setEnable(Long id) {
    updateEnableById(id, 1);
}

public void setDisable(Long id) {
    updateEnableById(id, 0);
}

private void updateEnableById(Long id, Integer enable) {
    // 调用Mapper对象的getStandardById()方法执行查询
    // 判断查询结果是否为null
    // 是：抛出异常（NOT_FOUND）
    
    // 判断以上查询结果中的enable是否与参数enable相同
    // 是：抛出异常（CONFLICT）
    
    // 创建Category对象，并将2个参数的值封装进来
    // 调用Mapper对象的update()执行更新，并获取返回结果，判断是否符合预期值
}
```

在`CategoryServiceTests`中编写并执行测试：

```java

```

# 72. 启用/禁用类别--Controller层

```java
// http://localhost:9080/categories/9527/enable
@PostMapping("/{id:[0-9]+}/enable")
@ApiOperation("启用类别")
@ApiOperationSupport(order = 310)
@ApiImplicitParam(name = "id", value = "类别ID", required = true, example = "9527", dataType = "long")
public JsonResult<Void> setEnable(@Range(min = 1, max = 1000000, message = "启用类别失败，类别ID非法！")
                               @PathVariable Long id) {
    log.debug("开始处理【启用类别】的请求，参数：{}", id);
    categoryService.setEnable(id);
    return JsonResult.ok();
}

// http://localhost:9080/categories/9527/disable
@PostMapping("/{id:[0-9]+}/disable")
@ApiOperation("禁用类别")
@ApiOperationSupport(order = 311)
@ApiImplicitParam(name = "id", value = "类别ID", required = true, example = "9527", dataType = "long")
public JsonResult<Void> setDisable(@Range(min = 1, max = 1000000, message = "禁用类别失败，类别ID非法！")
                                  @PathVariable Long id) {
    log.debug("开始处理【禁用类别】的请求，参数：{}", id);
    categoryService.setDisable(id);
    return JsonResult.ok();
}
```

# 73. Spring框架

## 73.1. 关于Spring框架

Spring框架主要解决了创建对象、管理对象的相关问题。

所有由Spring框架创建的对象，会被Spring框架保存在`ApplicationContext`（应用程序上下文）中，后续，当需要这些对象时，Spring会自动从`ApplicationContext`中取出并使用。

由于Spring的`ApplicationContext`中会保存若干个对象，所以通常也称之为“Spring容器”。

Spring框架的核心包括：

- IoC = Inversion of Controller，即控制反转
- AOP（本阶段末期再讲）

## 73.2. Spring框架创建对象的方式

### 73.2.1. 组件扫描

在配置类（添加了`@Configuration`注解的类）上使用`@ComponentScan`注解，即可实现：当加载此配置类时，Spring框架会执行组件扫描，扫描特定的包及其子级包下是否存在组件类，如果找到组件类，则Spring框架会自动创建此组件类的对象。

如果使用`@ComponentScan`时，没有配置注解参数，扫描的根包就是当前配置类所在的包；使用`@ComponentScan`注解时，还可以配置此注解的`basePackages` / `value`属性来指定需要扫描的若干个包。

在Spring Boot项目中，启动类上添加了`@SpringBootApplication`注解，此注解使用了`@ComponentScan`作为其元注解。

如果被扫描的类添加了组件相关注解，此类就会被视为“组件类”，在Spring框架中，组件注解有：

- `@Component`：通用注解
- `@Controller`：添加在控制器类上
- `@Service`：添加在业务实现类上
- `@Repository`：添加在存取数据的类（例如对数据库做增删改查的类）上

以上4个注解，在Spring框架中，作用、用法是完全相同、完全等效的！以上4个注解只存在语义的不同！

在Spring中，还有一个非常特殊的组件注解：

- `@Configuration`

在Spring MVC中，还新定义了注解用于标识组件类，这些新的注解都是基于`@Component`注解：

- `@RestController`
- `@ControllerAdvice`
- `@RestControllerAdvice`

在Spring Boot中，还存在扩展的组件注解：

- `@SpringBootConfiguration`

### 73.2.2. `@Bean`方法

在配置类中，可以自定义方法，返回特定类型的对象，并在此方法上添加`@Bean`注解，则Spring框架加载此配置类时，会自动调用这些方法，从而得到方法返回的对象。

例如：

```java
@Configuration
public class BeanConfiguration {
	
    @Bean
    public AlbumController albumController() {
        return new AlbumController();
    }
    
}
```

### 73.2.3. 关于用法的选取

如果需要Spring创建的是自定义类的对象，推荐优先选取“组件扫描”的做法。

如果需要Spring创建的不是自定义类的对象，则无法选取“组件扫描”的做法，因为你无法在别人写的类上添加组件注解，只能使用“@Bean方法”的做法。

### 73.2.4. 关于Spring Bean的名称

由Spring框架创建的对象均可称之为Spring Bean。

每个Spring Bean都有名称。

如果使用组件扫描创建的对象，Spring Bean的名称：默认情况下，当类名的第1个字母是大写的，且第2个字母是小写的，则Spring Bean的名称就是将类名的首字母改为小写，例如`CategoryServiceImpl`类的Spring Bean名称就是`categoryServiceImpl`，如果不满足以上条件，则Spring Bean名称就是类名。如果需要自定义为其它名称，可以配置组件注解的参数，例如`@Service("categoryService")`。

如果使用`@Bean`方法创建的对象，Spring Bean的名称默认是方法名称，也可以配置`@Bean`注解的参数，例如`@Bean("categoryService")`。

## 73.3. Spring框架创建的对象的作用域

**由Spring框架创建的对象，默认是“单例”的。**

**注意：**Spring框架并不是使用了单例模式，只是它管理的对象具有与单例模式的特点。

> 单例（单一实例）：在任意时刻，此类型的对象最多只有1个。

可以通过`@Scope`注解修改Spring管理的对象的作用域，在此注解中配置参数值为`"prototype"`时，对象将不再是单例的，与普通的局部变量的作用域相同，当此注解的参数值是`"singleton"`时，对象是单例的，由于单例是默认的状态，所以，通常不会使用到此值。

如果是通过组件扫描的方法来创建对象，则在类的声明上使用`@Scope`注解，例如：

```java
@Scope("prototype")
@RestController
public class AlbumController {
}
```

如果是通过`@Bean`方法来创建对象，则在方法的声明上使用`@Scope`注解，例如：

```java
@Configuration
public class BeanConfiguration {
	
    @Bean
    @Scope("prototype")
    public AlbumController albumController() {
        return new AlbumController();
    }
    
}
```

**由Spring框架创建的对象，如果是“单例”的，默认是“饿汉式”的。**

如果希望被创建的单例对象是“懒汉式”的，可以通过`@Lazy`注解进行配置。与`@Scope`注解的使用方式相同，如果是通过组件扫描创建的对象，可以在类上添加此注解，如果是通过`@Bean`方法创建的对象，可以在方法上添加此注解。

**示例代码 -- 饿汉式单例模式：**

```java
public class Singleton {
    private static Singleton instance = new Singleton();
    
    private Singleton() {}
    
    public static Singleton getInstance() {
        return instance;
    }
}
```

**示例代码 -- 懒汉式单例模式：**

```java
public class Singleton {
    private static Singleton instance = null;
    
    private Singleton() {}
    
    public static Singleton getInstance() {
        if (instance == null) { // 判断有没有必要锁
            synchronized("java") {
                if (instance == null) { // 判断有没有必要创建对象
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

# 73.4. 自动装配

Spring的自动装配机制表现为：当特定的量（类的属性，或被Spring自动调用的方法的参数）需要值时，使用待定的做法，可以使得Spring使用容器中的对象为这些量自动赋值。

最常见的用法是在类的属性上使用`@Autowired`注解，例如：

```java
@RestController
public class CategoryController {

    @Autowired
    private ICategoryService categoryService; // 注意：Spring容器中必须存在匹配的对象
    
}
```

其实，还可以使用`@Resource`注解替代`@Autowired`注解，在以上代码中，执行效果是相同的。

关于`@Autowired`与`@Resource`的区别：

- `@Resource`是Java注解（是`javax.annotation`包中的），`@Autowired`是Spring框架的注解
- `@Resource`注解是优先按照名称进行匹配，再检查类型是否相同，`@Autowired`是先根据类型查找匹配的对象，如果超过1个，再尝试根据名称进行匹配
  - 提示：如果有且仅有1个类型匹配的Spring Bean，这2个注解都可以成功装配，如果匹配类型的Spring Bean超过1个，只要其中1个能匹配名称，这2个注解都可以成功装配，如果都不匹配名称，这2个注解都无法成功装配

关于`@Autowired`的装配机制详解：

- 先根据类型查找匹配的Spring Bean的数量

  - 0个：取决于`@Autowired`注解的`required`属性

    - `true`：装配失败，启动项目或启动测试时就会报错，例如

      ```
      Caused by: org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'cn.tedu.csmall.product.service.ICategoryService' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true)}
      ```

    - `false`：放弃装配，此时尝试自动装配的量的值为`null`，后续可能出现NPE

  - 1个：直接装配，且成功

  - 多个：将尝试按照名称进行匹配，即被自动装配的量的名称，与某个Spring Bean的名称完全相同

    - 如果存在匹配名称的Spring Bean：装配成功

    - 如果不存在匹配名称的Spring Bean：装配失败，启动项目或启动测试时就会报错，例如

      ```
      Caused by: org.springframework.beans.factory.NoUniqueBeanDefinitionException: No qualifying bean of type 'cn.tedu.csmall.product.service.ICategoryService' available: expected single matching bean but found 2: categoryServiceImpl,categoryServiceImpl2
      ```

Spring在处理自动装配时，有多种装配机制：

- 属性注入

- Setter注入

  ```java
  @RestController
  public class CategoryController {
  
      private ICategoryService categoryService;
  
      @Autowired
      public void setCategoryService(ICategoryService categoryService) {
          this.categoryService = categoryService;
      }
      
  }
  ```

- 构造方法注入

  ```java
  @RestController
  public class CategoryController {
  
      private ICategoryService categoryService;
  
      @Autowired
      public CategoryController(ICategoryService categoryService) {
          this.categoryService = categoryService;
      }
      
  }
  ```

  通过构造方法注入时：

  - 如果类中仅有1个构造方法，不必添加`@Autowired`注解
  - 如果类中有多个构造方法，默认情况下，Spring会自动尝试调用无参数构造方法（如果存在的话）
  - 如果类中有多个构造方法，希望Spring调用特定的某个构造方法，需要在此构造方法上添加`@Autowired`注解

另外，在使用`@Autowired`时，如果存在多个匹配类型的Spring Bean，还可以使用`@Qualifier`注解来指定装配的Spring Bean的名称，例如：

```java
@Autowired
@Qualifier("categoryServiceImpl")
private ICategoryService categoryService;
```

注意，以上使用到的`@Qualifier`注解还可以添加的方法的参数上！





