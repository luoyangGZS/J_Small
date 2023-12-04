# 使用Mybatis拦截器处理插入和修改数据时更新时间字段的值

在项目的根包下创建`mybatis.InsertUpdateTimeInterceptor`类，此类需要实现Mybatis的`Interceptor`接口，并在类上通过`@Intercepts`注解来配置拦截目标，然后，通过重写`intercept()`方法来拦截SQL语句，并对SQL进行必要的修改：

```java
package cn.tedu.csmall.passport.mybatis;

import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.plugin.*;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * <p>基于MyBatis的自动插入“创建时间”、更新"最后修改时间"的拦截器</p>
 *
 * <p>需要SQL语法预编译之前进行拦截，则拦截类型为StatementHandler，拦截方法是prepare</p>
 *
 * <p>具体的拦截处理由内部的intercept()方法实现</p>
 *
 * <p>注意：由于仅适用于当前项目，并不具备范用性，所以：</p>
 *
 * <ul>
 * <li>拦截所有的update方法（根据SQL语句以update前缀进行判定），无法不拦截某些update方法</li>
 * <li>所有数据表中"最后修改时间"的字段名必须一致，由本拦截器的FIELD_MODIFIED属性进行设置</li>
 * </ul>
 *
 * @author java@tedu.cn
 * @version 0.0.1
 */
@Slf4j
@Intercepts({@Signature(
        type = StatementHandler.class,
        method = "prepare",
        args = {Connection.class, Integer.class}
)})
public class InsertUpdateTimeInterceptor implements Interceptor {

    /**
     * 自动添加的创建时间字段
     */
    private static final String FIELD_CREATE = "gmt_create";
    /**
     * 自动更新时间的字段
     */
    private static final String FIELD_MODIFIED = "gmt_modified";
    /**
     * SQL语句类型：其它（暂无实际用途）
     */
    private static final int SQL_TYPE_OTHER = 0;
    /**
     * SQL语句类型：INSERT
     */
    private static final int SQL_TYPE_INSERT = 1;
    /**
     * SQL语句类型：UPDATE
     */
    private static final int SQL_TYPE_UPDATE = 2;
    /**
     * 查找SQL类型的正则表达式：INSERT
     */
    private static final String SQL_TYPE_PATTERN_INSERT = "^insert\\s";
    /**
     * 查找SQL类型的正则表达式：UPDATE
     */
    private static final String SQL_TYPE_PATTERN_UPDATE = "^update\\s";
    /**
     * 查询SQL语句片段的正则表达式：gmt_modified片段
     */
    private static final String SQL_STATEMENT_PATTERN_MODIFIED = ",\\s*" + FIELD_MODIFIED + "\\s*=";
    /**
     * 查询SQL语句片段的正则表达式：gmt_create片段
     */
    private static final String SQL_STATEMENT_PATTERN_CREATE = ",\\s*" + FIELD_CREATE + "\\s*[,)]?";
    /**
     * 查询SQL语句片段的正则表达式：WHERE子句
     */
    private static final String SQL_STATEMENT_PATTERN_WHERE = "\\s+where\\s+";
    /**
     * 查询SQL语句片段的正则表达式：VALUES子句
     */
    private static final String SQL_STATEMENT_PATTERN_VALUES = "\\)\\s*values?\\s*\\(";

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        // 日志
        log.debug("准备拦截SQL语句……");
        // 获取boundSql，即：封装了即将执行的SQL语句及相关数据的对象
        BoundSql boundSql = getBoundSql(invocation);
        // 从boundSql中获取SQL语句
        String sql = getSql(boundSql);
        // 日志
        log.debug("原SQL语句：{}", sql);
        // 准备新SQL语句
        String newSql = null;
        // 判断原SQL类型
        switch (getOriginalSqlType(sql)) {
            case SQL_TYPE_INSERT:
                // 日志
                log.debug("原SQL语句是【INSERT】语句，准备补充更新时间……");
                // 准备新SQL语句
                newSql = appendCreateTimeField(sql, LocalDateTime.now());
                break;
            case SQL_TYPE_UPDATE:
                // 日志
                log.debug("原SQL语句是【UPDATE】语句，准备补充更新时间……");
                // 准备新SQL语句
                newSql = appendModifiedTimeField(sql, LocalDateTime.now());
                break;
        }
        // 应用新SQL
        if (newSql != null) {
            // 日志
            log.debug("新SQL语句：{}", newSql);
            reflectAttributeValue(boundSql, "sql", newSql);
        }

        // 执行调用，即拦截器放行，执行后续部分
        return invocation.proceed();
    }

    public String appendModifiedTimeField(String sqlStatement, LocalDateTime dateTime) {
        Pattern gmtPattern = Pattern.compile(SQL_STATEMENT_PATTERN_MODIFIED, Pattern.CASE_INSENSITIVE);
        if (gmtPattern.matcher(sqlStatement).find()) {
            log.debug("原SQL语句中已经包含gmt_modified，将不补充添加时间字段");
            return null;
        }
        StringBuilder sql = new StringBuilder(sqlStatement);
        Pattern whereClausePattern = Pattern.compile(SQL_STATEMENT_PATTERN_WHERE, Pattern.CASE_INSENSITIVE);
        Matcher whereClauseMatcher = whereClausePattern.matcher(sql);
        // 查找 where 子句的位置
        if (whereClauseMatcher.find()) {
            int start = whereClauseMatcher.start();
            int end = whereClauseMatcher.end();
            String clause = whereClauseMatcher.group();
            log.debug("在原SQL语句 {} 到 {} 找到 {}", start, end, clause);
            String newSetClause = ", " + FIELD_MODIFIED + "='" + dateTime + "'";
            sql.insert(start, newSetClause);
            log.debug("在原SQL语句 {} 插入 {}", start, newSetClause);
            log.debug("生成SQL: {}", sql);
            return sql.toString();
        }
        return null;
    }

    public String appendCreateTimeField(String sqlStatement, LocalDateTime dateTime) {
        // 如果 SQL 中已经包含 gmt_create 就不在添加这两个字段了
        Pattern gmtPattern = Pattern.compile(SQL_STATEMENT_PATTERN_CREATE, Pattern.CASE_INSENSITIVE);
        if (gmtPattern.matcher(sqlStatement).find()) {
            log.debug("已经包含 gmt_create 不再添加 时间字段");
            return null;
        }
        // INSERT into table (xx, xx, xx ) values (?,?,?)
        // 查找 ) values ( 的位置
        StringBuilder sql = new StringBuilder(sqlStatement);
        Pattern valuesClausePattern = Pattern.compile(SQL_STATEMENT_PATTERN_VALUES, Pattern.CASE_INSENSITIVE);
        Matcher valuesClauseMatcher = valuesClausePattern.matcher(sql);
        // 查找 ") values " 的位置
        if (valuesClauseMatcher.find()) {
            int start = valuesClauseMatcher.start();
            int end = valuesClauseMatcher.end();
            String str = valuesClauseMatcher.group();
            log.debug("找到value字符串：{} 的位置 {}, {}", str, start, end);
            // 插入字段列表
            String fieldNames = ", " + FIELD_CREATE + ", " + FIELD_MODIFIED;
            sql.insert(start, fieldNames);
            log.debug("插入字段列表{}", fieldNames);
            // 定义查找参数值位置的 正则表达 “)”
            Pattern paramPositionPattern = Pattern.compile("\\)");
            Matcher paramPositionMatcher = paramPositionPattern.matcher(sql);
            // 从 ) values ( 的后面位置 end 开始查找 结束括号的位置
            String param = ", '" + dateTime + "', '" + dateTime + "'";
            int position = end + fieldNames.length();
            while (paramPositionMatcher.find(position)) {
                start = paramPositionMatcher.start();
                end = paramPositionMatcher.end();
                str = paramPositionMatcher.group();
                log.debug("找到参数值插入位置 {}, {}, {}", str, start, end);
                sql.insert(start, param);
                log.debug("在 {} 插入参数值 {}", start, param);
                position = end + param.length();
            }
            if (position == end) {
                log.warn("没有找到插入数据的位置！");
                return null;
            }
        } else {
            log.warn("没有找到 ) values (");
            return null;
        }
        log.debug("生成SQL: {}", sql);
        return sql.toString();
    }

    @Override
    public Object plugin(Object target) {
        // 本方法的代码是相对固定的
        if (target instanceof StatementHandler) {
            return Plugin.wrap(target, this);
        } else {
            return target;
        }
    }

    @Override
    public void setProperties(Properties properties) {
        // 无须执行操作
    }

    /**
     * <p>获取BoundSql对象，此部分代码相对固定</p>
     *
     * <p>注意：根据拦截类型不同，获取BoundSql的步骤并不相同，此处并未穷举所有方式！</p>
     *
     * @param invocation 调用对象
     * @return 绑定SQL的对象
     */
    private BoundSql getBoundSql(Invocation invocation) {
        Object invocationTarget = invocation.getTarget();
        if (invocationTarget instanceof StatementHandler) {
            StatementHandler statementHandler = (StatementHandler) invocationTarget;
            return statementHandler.getBoundSql();
        } else {
            throw new RuntimeException("获取StatementHandler失败！请检查拦截器配置！");
        }
    }

    /**
     * 从BoundSql对象中获取SQL语句
     *
     * @param boundSql BoundSql对象
     * @return 将BoundSql对象中封装的SQL语句进行转换小写、去除多余空白后的SQL语句
     */
    private String getSql(BoundSql boundSql) {
        return boundSql.getSql().toLowerCase().replaceAll("\\s+", " ").trim();
    }

    /**
     * <p>通过反射，设置某个对象的某个属性的值</p>
     *
     * @param object         需要设置值的对象
     * @param attributeName  需要设置值的属性名称
     * @param attributeValue 新的值
     * @throws NoSuchFieldException   无此字段异常
     * @throws IllegalAccessException 非法访问异常
     */
    private void reflectAttributeValue(Object object, String attributeName, String attributeValue) throws NoSuchFieldException, IllegalAccessException {
        Field field = object.getClass().getDeclaredField(attributeName);
        field.setAccessible(true);
        field.set(object, attributeValue);
    }

    /**
     * 获取原SQL语句类型
     *
     * @param sql 原SQL语句
     * @return SQL语句类型
     */
    private int getOriginalSqlType(String sql) {
        Pattern pattern;
        pattern = Pattern.compile(SQL_TYPE_PATTERN_INSERT, Pattern.CASE_INSENSITIVE);
        if (pattern.matcher(sql).find()) {
            return SQL_TYPE_INSERT;
        }
        pattern = Pattern.compile(SQL_TYPE_PATTERN_UPDATE, Pattern.CASE_INSENSITIVE);
        if (pattern.matcher(sql).find()) {
            return SQL_TYPE_UPDATE;
        }
        return SQL_TYPE_OTHER;
    }

}
```

完成后，在`MybatisConfiguration`中配置此拦截器，使之生效：

```java
@Autowired
private List<SqlSessionFactory> sqlSessionFactoryList;

@PostConstruct // 在方法上添加@PostConstruct注解，表示此方法是Spring Bean的生命周期方法的初始化方法，会在创建对象之后自动执行
public void addInterceptor() {
    InsertUpdateTimeInterceptor interceptor = new InsertUpdateTimeInterceptor();
    for (SqlSessionFactory sqlSessionFactory : sqlSessionFactoryList) {
        sqlSessionFactory.getConfiguration().addInterceptor(interceptor);
    }
}
```

# 基于Spring Security与JWT的单点登录

**SSO**：**S**ingle **S**ign **O**n，单点登录，在集群或分布式系统中，用户只需要在其中某1个服务器登录，后续访问其它服务器时，都可以识别此用户的身份。

在`csmall-passport`中已经完成了基于Spring Security + JWT的身份验证，判断“是否已登录”是根据`SecurityContext`中是否存在认证信息来决定的，而认证信息是由解析客户端提交的JWT得到的！

在集群或分布式系统中，当需要实现单点登录时，只需要各服务器都可以解析JWT，进而生成认证信息并存入到`SecurityContext`中即可，各服务器并不要求实现处理认证的过程。

如果需要将`csmall-product`也处理为需要认证，甚至某些操作需要检查权限，那么，相关的代码处理：

- 添加依赖
  - `spring-boot-starter-security`
  - `jjwt`
  - `fastjson`
- 复制配置文件中关于JWT的自定义配置
- 更新`ServiceCode`中的枚举值
- 更新`GlobalExceptionHandler`中处理异常的方法
- `LoginPrincipal`
- `JwtAuthorizationFilter`
- `SecurityConfiguration`
  - 删除`PasswordEncoder`对应的`@Bean`方法
  - 删除`AuthenticationManager`对应的`@Bean`方法
  - 删除“白名单”中的`/admins/login`路径

# 关于Redis

Redis是一款基于内存的使用K-V结构存取数据的NoSQL非关系型数据库。

Redis的主要作用就是缓存数据，通常，会将关系型数据库（例如MySQL等）中的数据读取出来，写入到Redis中，后续，当需要获取数据时，将优先从Redis中读取，而不是从关系型数据库中读取。由于Redis是基于内存的，读写效率远高于关系型数据库，进而可以提高查询效率，并且，可以起到“保护”关系型数据库的作用。

# Redis的经典数据类型

Redis的经典数据类型有：string / hash / list / set / z-set

另外，还有：bitmap / hyperloglog / Geo / 流

# Redis的常用命令

当登录Redis客户端（命令提示符变成`127.0.0.1:6379>`状态）后，可以：

- `set KEY VALUE`：存入数据，例如`set username root`，如果反复使用同一个KEY执行此命令，后续存入的数据会覆盖前序存入的数据，如果使用的是从未使用过的KEY，相当于新增了一条数据
- `get KEY`：读取数据，例如`get username`，如果KEY存在，则获取到对应的数据，如果KEY不存在，将返回`(nil)`，相当于Java中的`null`
- `keys PATTERN`：获取KEY，例如`keys username`，如果此KEY是存在的，则返回，如果不存在，则返回`(empty list or set)`，在PATTERN处可以使用星号（`*`）作为通配符，例如`keys *`可以返回当前Redis中已经存在的所有KEY
  - **注意：**在生产环境中，禁止使用此命令
- `del KEY`：删除指定KEY对应的数据，例如`del username`，如果此KEY是存在的，将返回`1`，如果不存在，则返回`0`
- `flushdb`：清空

更多命令可参考：https://www.cnblogs.com/antLaddie/p/15362191.html

# 基于Spring Boot的项目中的Redis编程

首先，需要添加依赖：

```xml
<!-- Spring Boot Data Redis依赖项，用于实现Redis编程 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

然后，需要在配置类中通过`@Bean`方法创建`RedisTemplate`类型的对象，它是用于读写Redis的工具。

则在项目的根包下创建`config.RedisConfiguration`类，并配置：

```java
package cn.tedu.csmall.product.config;

import lombok.extern.slf4j.Slf4j;
import org.hibernate.validator.HibernateValidator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.RedisSerializer;

import javax.validation.Validation;
import java.io.Serializable;

/**
 * Redis配置类
 *
 * @author java@tedu.cn
 * @version 0.0.1
 */
@Slf4j
@Configuration
public class RedisConfiguration {

    public RedisConfiguration() {
        log.debug("创建配置类对象：RedisConfiguration");
    }

    @Bean
    public RedisTemplate<String, Serializable> redisTemplate(
            RedisConnectionFactory redisConnectionFactory) {
        RedisTemplate<String, Serializable> redisTemplate = new RedisTemplate<>();
        redisTemplate.setConnectionFactory(redisConnectionFactory);
        redisTemplate.setKeySerializer(RedisSerializer.string());
        redisTemplate.setValueSerializer(RedisSerializer.json());
        return redisTemplate;
    }

}
```

















