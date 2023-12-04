# 注解大全（第四阶段）

| 注解                          | 所属框架          | 作用                                                         |
| ----------------------------- | ----------------- | ------------------------------------------------------------ |
| `@ComponentScan`              | Spring            | 添加在配置类上，开启组件扫描。<br />如果没有配置包名，则扫描当前配置类所在的包，<br />如果配置了包名，则扫描所配置的包及其子孙包 |
| `@Component`                  | Spring            | 添加在类上，标记当前类是组件类，可以通过参数配置Spring Bean名称 |
| `@Controller`                 | Spring            | 添加在类上，标记当前类是控制器组件类，用法同`@Component`     |
| `@Service`                    | Spring            | 添加在类上，标记当前类是业务逻辑组件类，用法同`@Component`   |
| `@Repository`                 | Spring            | 添加在类上，标记当前类是数据访问组件类，用法同`@Component`   |
| `@Configuration`              | Spring            | 添加在类上，仅添加此注解的类才被视为配置类，通常不配置注解参数 |
| `@Bean`                       | Spring            | 添加在方法上，标记此方法将返回某个类型的对象，<br />且Spring会自动调用此方法，并将对象保存在Spring容器中 |
| `@Autowired`                  | Spring            | 添加在属性上，使得Spring自动装配此属性的值<br />添加在构造方法上，使得Spring自动调用此构造方法<br />添加在Setter方法上，使得Spring自动调用此方法 |
| `@Qualifier`                  | Spring            | 添加在属性上，或添加在方法的参数上，<br />配合自动装配机制，用于指定需要装配的Spring Bean的名称 |
| `@Scope`                      | Spring            | 添加在组件类上，或添加在已经添加了`@Bean`注解的方法上，<br />用于指定作用域，注解参数为`singleton`（默认）时为“单例”，注解参数为`prototype`时为“非单例” |
| `@Lazy`                       | Spring            | 添加在组件类上，或添加在已经添加了`@Bean`注解的方法上，<br />用于指定作用域，当Spring Bean是单例时，注解参数为`true`（默认）时为“懒加载”，注解参数为`false`时为“预加载” |
| `@Value`                      | Spring            | 添加在属性上，或添加在被Spring调用的方法的参数上，用于读取`Environment`中的属性值，为对象的属性或方法的参数注入值 |
| `@Resource`                   | Spring            | 此注解是`javax`包中的注解，<br />添加在属性上，使得Spring自动装配此属性的值，<br />通常不推荐使用此注解 |
| `@ResponseBody`               | Spring MVC        | 添加在方法上，标记此方法是“响应正文”的，<br />添加在类上，标记此类中所有方法都是“响应正文”的 |
| `@RestController`             | Spring MVC        | 添加在类上，标记此类是一个“响应正文”的控制器类               |
| `@RequestMapping`             | Spring MVC        | 添加在类上，也可以添加在处理请求的方法上，<br />通常用于配置请求路径 |
| `@GetMapping`                 | Spring MVC        | 添加在方法上，是将请求方式限制为`GET`的`@RequestMapping`     |
| `@PostMapping`                | Spring MVC        | 添加在方法上，是将请求方式限制为`POST`的`@RequestMapping`    |
| `@DeleteMapping`              | Spring MVC        | 添加在方法上，是将请求方式限制为`DELETE`的`@RequestMapping`  |
| `@PutMapping`                 | Spring MVC        | 添加在方法上，是将请求方式限制为`PUT`的`@RequestMapping`     |
| `@RequestParam`               | Spring MVC        | 添加在请求参数上，可以：<br />1. 指定请求参数名称<br />2. 要求必须提交此参数<br />3. 指定请求参数的默认值 |
| `@PathVariable`               | Spring MVC        | 添加在请求参数上，用于标记此参数的值来自URL中的占位符，如果URL中的占位符名称与方法的参数名称不同，需要配置此注解参数来指定URL中的占位符名称 |
| `@RequestBody`                | Spring MVC        | 添加在请求参数上，用于标记此参数必须是对象格式的参数，如果未添加此注解，参数必须是FormData格式的 |
| `@ExceptionHandler`           | Spring MVC        | 添加在方法上，标记此方法是处理异常的方法，可以通过配置注解参数来指定需要处理的异常类型，如果没有配置注解参数，所处理的异常类型取决于方法的参数列表中的异常类型 |
| `@ControllerAdvice`           | Spring MVC        | 添加在类上，标记此类中特定的方法将作用于每次处理请求的过程中 |
| `@RestControllerAdvice`       | Spring MVC        | 添加在类上，是`@ControllerAdvice`和`@ResponseBody`的组合注解 |
| `@MapperScan`                 | Mybatis           | 添加在配置类上，用于指定Mapper接口的根包，Mybatis将根据此根包执行扫描，以找到各Mapper接口 |
| `@Mapper`                     | Mybatis           | 添加在Mapper接口上，用于标记此接口是Mybatis的Mapper接口，如果已经通过`@MapperScan`配置能够找到此接口，则不需要使用此注解 |
| `@Param`                      | Mybatis           | 添加在Mapper接口中的抽象方法的参数上，用于指定参数名称，当使用此注解指定参数名称后，SQL中的`#{}` / `${}`占位符中的名称必须是此注解指定的名称，通常，当抽象方法的参数超过1个时，强烈建议在每个参数上使用此注解配置名称 |
| `@Select`                     | Mybatis           | 添加在Mapper接口的抽象方法上，可以通过此注解直接配置此抽象方法对应的SQL语句（不必将SQL语句配置在XML文件中），用于配置`SELECT`类的SQL语句，但是，非常不推荐这种做法 |
| `@Insert`                     | Mybatis           | 同上，用于配置`INSERT`类的SQL语句                            |
| `@Update`                     | Mybatis           | 同上，用于配置`UPDATE`类的SQL语句                            |
| `@Delete`                     | Mybatis           | 同上，用于配置`DELETE`类的SQL语句                            |
| `@Transactional`              | Spring JDBC       | 推荐添加的业务接口上，用于标记此接口中所有方法都是事务性的，或业务接口中的抽象方法上，用于此方法是事务性的 |
| `@SpringBootApplication`      | Spring Boot       | 添加在类上，用于标记此类是Spring Boot的启动类，每个Spring Boot项目应该只有1个类添加了此注解 |
| `@SpringBootConfiguration`    | Spring Boot       | 通常不需要显式的使用，它是`@SpringBootApplication`的元注解之一 |
| `@SpringBootTest`             | Spring Boot       | 添加在类上，用于标记此类是加载Spring环境的测试类             |
| `@Valid`                      | Spring Validation | 添加在方法的参数上，标记此参数需要经过Validation框架的检查   |
| `@Validated`                  | Spring Validation | 添加在方法的参数上，标记此参数需要经过Validation框架的检查；添加在类上，并结合方法上的检查注解（例如`@NotNull`等）实现对未封装的参数的检查 |
| `@NotNull`                    | Spring Validation | 添加在需要被检查的参数上，或添加在需要被检查的封装类型的属性上，用于配置“不允许为`null`”的检查规则 |
| `@NotEmpty`                   | Spring Validation | 使用位置同`@NotNull`，用于配置“不允许为空字符串”的检查规则   |
| `@NotBlank`                   | Spring Validation | 使用位置同`@NotNull`，用于配置“不允许为空白”的检查规则       |
| `@Pattern`                    | Spring Validation | 使用位置同`@NotNull`，用于配置正则表达式的检查规则           |
| `@Range`                      | Spring Validation | 使用位置同`@NotNull`，用于配置“数值必须在某个取值区间”的检查规则 |
| `@Api`                        | Knife4j           | 添加在控制器类上，通过此注解的`tags`属性配置API文档中的模块名称 |
| `@ApiOperation`               | Knife4j           | 添加在控制器类中处理请求的方法上，用于配置业务名称           |
| `@ApiOperationSupport`        | Knife4j           | 添加在控制器类中处理请求的方法上，通过此注解的`order`属性配置业务显示在API文档中时的排序序号 |
| `@ApiModelProperty`           | Knife4j           | 添加在封装的请求参数类型中的属性上，用于配置请求参数的详细说明，包括：名称、数据类型、是否必须等 |
| `@ApiImplicitParam`           | Knife4j           | 添加在控制器类中处理请求的方法上，用于配置请求参数的详细说明，包括：名称、数据类型、是否必须等 |
| `@ApiImplicitParams`          | Knife4j           | 添加在控制器类中处理请求的方法上，如果需要通过`@ApiImplicitParam`注解配置的参数超过1个，则必须将多个`@ApiImplicitParam`注解作为此注解的参数 |
| `@ApiIgnore`                  | Knife4j           | 添加在请求参数上，用于标记API文档中将不关心此参数            |
| `@EnableGlobalMethodSecurity` | Spring Security   | 添加在配置类上，用于开启全局的方法级别的权限控制             |
| `@PreAuthorize`               | Spring Security   | 添加在方法上，用于配置权限                                   |
| `@AuthenticationPrincipal`    | Spring Security   | 添加在方法的参数上，且此参数应该是Security上下文中的认证信息中的当事人类型，用于为此参数注入值 |
| `@Data`                       | Lombok            | 添加在类上，将在编译期生成此类中所有属性的Setter、Getter方法，及`hashCode()`、`equals()`、`toString()`方法 |
| `@Setter`                     | Lombok            | 添加在类上，将在编译期生成此类中所有属性的Setter方法，也可以添加在类的属性上，将在编译期生成此属性的Setter方法 |
| `@Getter`                     | Lombok            | 添加在类上，将在编译期生成此类中所有属性的Getter方法，也可以添加在类的属性上，将在编译期生成此属性的Getter方法 |
| `@EqualsAndHashcode`          | Lombok            | 添加在类上，将在编译期生成基于此类中所有属性的`hashCode()`、`equals()`方法 |
| `@ToString`                   | Lombok            | 添加在类上，将在编译期生成基于此类中所有属性的`toString()`方法 |
| `@NoArgConstructor`           | Lombok            | 添加在类上，将在编译期生成此类的无参数构造方法               |
| `@AllArgsConstructor`         | Lombok            | 添加在类上，将在编译期生成基于此类中所有属性的全参构造方法   |
