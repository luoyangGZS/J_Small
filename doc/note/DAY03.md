# 17. 关于Service

## 17.1. Service的基本作用

Service是项目中非常重要的组件，用于设计业务流程、业务逻辑，以保障数据的完整性、有效性、安全性。

Service在代码中的的作用是调用Mapper、被Controller调用。

## 17.2. Service的规范

在《阿里巴巴Java手册》中的**强制**规约：

```
【强制】对于 Service 和 DAO 类，基于 SOA 的理念，暴露出来的服务一定是接口，内部
的实现类用 Impl 的后缀与接口区别。
正例：CacheServiceImpl 实现 CacheService 接口。
```

## 17.3. 关于Service接口中的方法

在Service接口中声明的抽象方法，应该：

- 返回值类型：仅以操作成功为前提来设计返回值类型
  - 如果视为操作失败，可以通过抛出异常来表示
- 方法名称：自定义
- 参数列表：绝大部分情况下，以客户端会提交的请求参数作为参考，并且，可以按需封装，使用封装的POJO类型作为业务方法的参数


```java
封装的类型 login(String username, String password) throws 用户名错误异常, 密码错误异常, 账号状态异常;
```

```java
try {
    封装的类型 xxx = service.login(xx,xx);
    // 处理登录成功的后续操作
} catch (用户名错误异常 e) {
    // 处理用户名错误的后续操作
} catch (密码错误异常 e) {
    // 处理密码错误的后续操作
} catch (账号状态异常 e) {
    // 处理账号状态错误的后续操作
}
```

## 17.4. 在Service中实现“添加相册”

在项目的根包下创建`pojo.dto.AlbumAddNewDTO`类，用于封装业务方法所需的参数：

```java
@Data
public class AlbumAddNewDTO implements Serializable {
    private String name;
    private String description;
    private Integer sort;
}
```

再在项目的根包下创建`service.IAlbumService`接口，并在接口添加“添加相册”的抽象方法：

```java
public interface IAlbumService {
    void addNew(AlbumAddNewDTO albumAddNewDTO);
}
```

再在项目的根包下创建`service.impl.AlbumServiceImpl`类，实现以上接口，重写接口中声明的抽象方法：

```java
public class AlbumServiceImpl implements IAlbumService {

    @Override
    public void addNew(AlbumAddNewDTO albumAddNewDTO) {
    }

}
```

关于具体的实现，应该是：

```java
@Service
public class AlbumServiceImpl implements IAlbumService {
    
    @Autowired
    private AlbumMapper albumMapper;
    
    @Override
    public void addNew(AlbumAddNewDTO albumAddNewDTO) {
        // 检查相册名称是否已经被占用
        // 如果已经被占用，抛出异常
        
        // 创建Album对象
        // 补全Album对象中的属性值：来自参数albumAddNewDTO
		// 执行插入数据：albumMapper.insert(album)
    }

}
```

在实现以上业务之前，需要在Mapper中补充功能，用于检查相册名称是否已经被占用，需要执行的SQL语句大致是：

```mysql
select count(*) from pms_album where name=?
```

在`AlbumMapper.java`接口中添加抽象方法：

```java
/**
 * 根据相册名称统计相册数据的数量
 * @param name 相册名称
 * @return 匹配相册名称的相册数据的数量
 */
int countByName(String name);
```

并在`AlbumMapper.xml`中配置SQL语句：

```xml
<!-- int countByName(String name); -->
<select id="countByName" resultType="int">
	SELECT count(*) FROM pms_album WHERE name=#{name}
</select>
```

完成后，在`AlbumMapperTests`中编写并执行测试：

```java
@Test
void countByName() {
    String name = "华为Mate10的相册";
    int count = mapper.countByName(name);
    log.debug("根据名称【{}】统计数据完成，结果：{}", name, count);
}
```

接下来，可以补全业务实现类中的代码：

```java
package cn.tedu.csmall.product.service.impl;

import cn.tedu.csmall.product.mapper.AlbumMapper;
import cn.tedu.csmall.product.pojo.dto.AlbumAddNewDTO;
import cn.tedu.csmall.product.pojo.entity.Album;
import cn.tedu.csmall.product.service.IAlbumService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 处理相册数据的业务实现类
 *
 * @author java@tedu.cn
 * @version 0.0.1
 */
@Service
public class AlbumServiceImpl implements IAlbumService {

    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public void addNew(AlbumAddNewDTO albumAddNewDTO) {
        // 检查相册名称是否已经被占用
        String name = albumAddNewDTO.getName();
        int countByName = albumMapper.countByName(name);
        if (countByName > 0) {
            // 如果已经被占用，抛出异常
            throw new RuntimeException();
        }

        // 创建Album对象
        Album album = new Album();
        // 补全Album对象中的属性值：来自参数albumAddNewDTO
        // album.setName(albumAddNewDTO.getName());
        // album.setDescription(albumAddNewDTO.getDescription());
        // album.setSort(albumAddNewDTO.getSort());
        BeanUtils.copyProperties(albumAddNewDTO, album);
        // 执行插入数据：albumMapper.insert(album)
        albumMapper.insert(album);
    }

}
```

完成后，在`src/test/java`的根包下创建`service.AlbumServiceTests`测试类，在此类中编写并执行测试：

```java
package cn.tedu.csmall.product.service;

import cn.tedu.csmall.product.pojo.dto.AlbumAddNewDTO;
import cn.tedu.csmall.product.pojo.entity.Album;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@Slf4j
@SpringBootTest
public class AlbumServiceTests {

    @Autowired
    IAlbumService service; // 不建议声明为实现类类型

    @Test
    void addNew() {
        AlbumAddNewDTO album = new AlbumAddNewDTO();
        album.setName("测试名称001");
        album.setDescription("测试简介001");
        album.setSort(101); // 注意：由于MySQL中表设计的限制，此值只能是[0,255]区间内的

        try {
            service.addNew(album);
            log.debug("添加相册成功！");
        } catch (RuntimeException e) {
            log.debug("添加相册失败，相册名称已经被占用！");
        }
    }

}
```

## 17.5. 关于抛出异常

当使用抛出异常的方式表示“操作失败”时，**不可以**使用任何已有的异常（JDK中原生的异常类型，及添加的依赖项中包含的异常类型），**必须自定义异常**，则后续捕获并处理时，一定符合抛出异常时的情景。

自定义异常必须继承自某个已存在的异常类型，强烈建议继承自`RuntimeException`，其原因有：

- **原因1：**在项目中将使用全局异常处理器统一处理异常，要想统一处理，则Service组件、Controller组件都必须抛出异常，才能由Spring MVC框架捕获到异常，进而通过全局异常处理器进行统一的处理！`RuntimeException`不会受到异常的相关语句约束，而非`RuntimeException`一旦被抛出，方法的声明、方法的调用者的声明等都需要声明抛出此异常，由于抛出异常是固定的做法，没有必要在各个方法上都声明抛出此异常，所以，应该使用`RuntimeException`
- **原因2**：配合Spring JDBC框架实现事务管理！

则在项目的根包下创建`ex.ServiceException`类，继承自`RuntimeException`：

```java
package cn.tedu.csmall.product.ex;

/**
 * 业务异常
 *
 * @author java@tedu.cn
 * @version 0.0.1
 */
public class ServiceException extends RuntimeException {
}
```

并且，在`AlbumServiceImpl`中，当需要抛出异常时，改为抛出此类异常，在测试时，也捕获此类异常。

每次抛出异常，都应该是出现了某种“错误”，应该对此“错误”进行描述，关于此描述，应该是“谁抛出，谁描述”！应该在自定义异常类中添加基于父类异常的带`String message`参数的构造方法，例如：

```java
public class ServiceException extends RuntimeException {

    // 关键需要此构造方法
    public ServiceException(String message) {
        super(message);
    }
    
}
```

后续，抛出异常时，应该通过以上构造方法封装对异常的描述：

```java
// 检查相册名称是否已经被占用
String name = albumAddNewDTO.getName();
int countByName = albumMapper.countByName(name);
if (countByName > 0) {
    String message = "添加相册失败，相册名称已经被占用！";
    log.warn(message);
    throw new ServiceException(message); // 【调整】在构造方法中封装message
}
```

后续，捕获异常的位置，将不再需要“猜测”出现异常的原因，而是从捕获到的异常对象中直接获取以上封装的描述信息即可：

```java
try {
    service.addNew(album);
    log.debug("添加相册成功！");
} catch (ServiceException e) {
    log.debug("捕获到异常，其中的消息：{}", e.getMessage()); // 【调整】从异常对象中获取信息
}
```















