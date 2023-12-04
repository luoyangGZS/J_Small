# 50. 根据id删除相册--Mapper层

需要执行的SQL语句大致是：

```mysql
DELETE FROM pms_album WHERE id=?
```

此功能此前已完成！

目前缺少SKU表对应的“根据相册id统计数据的数量”的功能，需要补充！需要执行的SQL语句大致是：

```mysql
SELECT count(*) FROM sku WHERE album_id=?
```

则在`SkuMapper.java`接口中添加抽象方法：

```java
/**
 * 根据相册统计SKU数据的数量
 *
 * @param albumId 相册id
 * @return 与此相册关联的图片数据的数量
 */
int countByAlbumId(Long albumId);
```

并在`SkuMapper.xml`中配置以上抽象方法映射的SQL：

```xml
<!-- int countByAlbumId(Long albumId); -->
<select id="countByAlbumId" resultType="int">
    SELECT count(*) FROM pms_sku WHERE album_id=#{albumId}
</select>
```

完成后，在`SkuMapperTests`中编写并执行测试：

```java
@Test
void countByAlbumId() {
    Long albumId = 1L;
    int count = mapper.countByAlbumId(albumId);
    log.debug("统计完成，根据相册【{}】统计SKU的数量，结果：{}", albumId, count);
}
```

# 51. 根据id删除相册--Service层

在`IAlbumService`接口中添加抽象方法：

```java
/**
 * 根据id删除相册
 *
 * @param id 相册id
 */
void delete(Long id);
```

在`AlbumServiceImpl`类中实现以上方法：

```java
public void delete(Long id) {
    // 调用Mapper的getStandardById()执行查询，检查数据是否不存在
    // 是：数据不存在，抛出异常
    
    // 调用PictureMapper的countByAlbumId()执行统计，根据统计结果是否大于0，检查此相册是否关联到图片数据
    // 是：此相册关联了若干张图片（若干张图片归属此相册），抛出异常
    
    // 调用SpuMapper的countByAlbumId()执行统计，根据统计结果是否大于0，检查此相册是否关联到SPU数据
    // 是：此相册关联了若干个SPU，抛出异常
    
    // 调用SkuMapper的countByAlbumId()执行统计，根据统计结果是否大于0，检查此相册是否关联到SKU数据
    // 是：此相册关联了若干个SKU，抛出异常
    
    // 调用Mapper的deleteById()执行删除
}
```

具体实现为：

```java
@Override
public void delete(Long id) {
    log.debug("开始处理【根据id删除相册】的业务，参数：{}", id);
    // 调用Mapper的getStandardById()执行查询，检查数据是否不存在
    AlbumStandardVO album = albumMapper.getStandardById(id);
    // 是：数据不存在，抛出异常
    if (album == null) {
        String message = "删除相册失败，尝试访问的数据不存在！";
        log.warn(message);
        throw new ServiceException(ServiceCode.ERR_NOT_FOUND, message);
    }

    {
        // 调用PictureMapper的countByAlbumId()执行统计，根据统计结果是否大于0，检查此相册是否关联到图片数据
        int count = pictureMapper.countByAlbumId(id);
        // 是：此相册关联了若干张图片（若干张图片归属此相册），抛出异常
        if (count > 0) {
            String message = "删除相册失败，尝试访问相册存在关联的图片数据！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
        }
    }

    {
        // 调用SpuMapper的countByAlbumId()执行统计，根据统计结果是否大于0，检查此相册是否关联到SPU数据
        int count = spuMapper.countByAlbum(id);
        // 是：此相册关联了若干个SPU，抛出异常
        if (count > 0) {
            String message = "删除相册失败，尝试访问相册存在关联的SPU数据！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
        }
    }

    {
        // 调用SkuMapper的countByAlbumId()执行统计，根据统计结果是否大于0，检查此相册是否关联到SKU数据
        int count = skuMapper.countByAlbumId(id);
        // 是：此相册关联了若干个SKU，抛出异常
        if (count > 0) {
            String message = "删除相册失败，尝试访问相册存在关联的SKU数据！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
        }
    }

    // 调用Mapper的deleteById()执行删除
    log.debug("即将执行删除，参数：{}", id);
    albumMapper.deleteById(id);
}
```

在`AlbumServiceTests`测试类中编写并执行测试（请自行补充测试数据，进行各种情况下的测试）：

```java
@Test
void delete() {
    Long id = 11L;

    try {
        service.delete(id);
        log.debug("删除相册成功！");
    } catch (ServiceException e) {
        log.debug("捕获到异常，其中的消息：{}", e.getMessage());
    }
}
```

# 52. 根据id删除相册--Controller层

在`AlbumController`中处理请求：

```java
// http://localhost:9080/albums/9527/delete
@PostMapping("/{id:[0-9]+}/delete")
@ApiOperation("根据id删除相册")
@ApiOperationSupport(order = 200)
@ApiImplicitParam(name = "id", value = "相册ID", required = true, example = "9527", dataType = "long")
public JsonResult delete(@Range(min = 1, max = 10000, message = "删除相册失败，相册ID非法！")
                     @PathVariable Long id) {
    log.debug("开始处理【根据id删除相册】的请求，参数：{}", id);
    albumService.delete(id);
    return JsonResult.ok();
}
```

# 53. 修改相册数据--Mapper层

此功能此前已完成！

# 54. 修改相册数据--Service层

在项目的根包下创建`pojo.dto.AlbumUpdateDTO`类：

```java
@Data
public class AlbumUpdateDTO implements Serializable {
    private Long id;
    private String name;
    private String description;
    private Integer sort;
}
```

在`IAlbumService`接口中添加抽象方法：

```java
/**
 * 修改相册详情
 *
 * @param id 被修改的相册id
 * @param albumUpdateDTO 封装了新数据的对象
 */
void updateInfoById(Long id, AlbumUpdateDTO albumUpdateDTO);
```

在`AlbumServiceImpl`类中实现以上抽象方法：

```java
public void updateInfoById(AlbumUpdateDTO albumUpdateDTO) {
    // 调用Mapper的getStandardById()执行查询，检查数据是否不存在
    // 是：数据不存在，抛出异常

    // 调用Mapper的countByNameAndNotId()执行查询，检查新的名称是否已经被别的数据占用
    // 是：名称被别的数据占用，抛出异常（NOT_CONFLICT）
    
    // 创建Album对象
    // 将参数对象的属性值复制到以上新创建的Album对象中
    // 调用Mapper的update(Album album)方法执行修改
}
```

具体实现为：

```java
@Override
public void updateInfoById(Long id, AlbumUpdateDTO albumUpdateDTO) {
    log.debug("开始处理【修改相册详情】的业务，参数ID：{}，新数据：{}",id, albumUpdateDTO);

    {
        // 调用Mapper的getStandardById()执行查询，检查数据是否不存在
        AlbumStandardVO album = albumMapper.getStandardById(id);
        // 是：数据不存在，抛出异常
        if (album == null) {
            String message = "修改相册详情失败，尝试访问的数据不存在！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_NOT_FOUND, message);
        }
    }

    {
        // 调用Mapper的countByNameAndNotId()执行查询，检查新的名称是否已经被别的数据占用
        int count = albumMapper.countByNameAndNotId(id, albumUpdateDTO.getName());
        // 是：名称被别的数据占用，抛出异常（NOT_CONFLICT）
        if (count > 0) {
            String message = "修改相册详情失败，新的相册名称已经被占用！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
        }
    }

    // 创建Album对象
    Album album = new Album();
    // 将参数对象的属性值复制到以上新创建的Album对象中
    BeanUtils.copyProperties(albumUpdateDTO, album);
    album.setId(id);
    // 调用Mapper的update(Album album)方法执行修改
    log.debug("即将执行修改数据，参数：{}", album);
    albumMapper.update(album);
}
```

在`AlbumServiceTests`中编写并执行测试：

```java
@Test
void updateInfoById() {
    Long id = 1L;

    AlbumUpdateDTO albumUpdateDTO = new AlbumUpdateDTO();
    albumUpdateDTO.setName("华为Mate10的相册");
    albumUpdateDTO.setDescription("华为Mate10的相册的简介");
    albumUpdateDTO.setSort(199);

    try {
        service.updateInfoById(id, albumUpdateDTO);
        log.debug("修改相册详情成功！");
    } catch (ServiceException e) {
        log.debug("捕获到异常，其中的消息：{}", e.getMessage());
    }
}
```

# 55. 修改相册数据--Controller层

在`AlbumController`中配置：

```java
// http://localhost:9080/albums/9527/update
@PostMapping("/{id:[0-9]+}/update")
@ApiOperation("修改相册详情")
@ApiOperationSupport(order = 300)
public JsonResult updateInfoById(@PathVariable Long id, 
                                 AlbumUpdateDTO albumUpdateDTO) {
    log.debug("开始处理【修改相册详情】的请求，参数：{}", albumUpdateDTO);
    albumService.updateInfoById(id, albumUpdateDTO);
    return JsonResult.ok();
}
```

# 56. 根据id查询相册详情--Mapper层

此前已完成

# 57. 根据id查询相册详情--Service层

在`IAlbumService`接口中添加抽象方法：

```java
/**
 * 根据相册id查询相册详情
 *
 * @param id 相册id
 * @return 匹配的相册详情，如果没有匹配的数据，将抛出异常
 */
AlbumStandardVO getStandardById(Long id);
```

在`AlbumServiceImpl`中实现以上抽象方法：

```java
public AlbumStandardVO getStandardById(Long id) {
    // 调用Mapper的getStandardById()方法执行查询
    // 判断查询结果是否为null
    // 是：没有匹配的数据，抛出异常（NOT_FOUND）
    
    // 返回查询结果
}
```

具体实现为：

```java
@Override
public AlbumStandardVO getStandardById(Long id) {
    log.debug("开始处理【根据id查询相册详情】的业务，参数：{}", id);

    // 调用Mapper的getStandardById()执行查询
    AlbumStandardVO album = albumMapper.getStandardById(id);
    // 判断查询结果是否为null
    // 是：没有匹配的数据，抛出异常（NOT_FOUND）
    if (album == null) {
        String message = "查询相册详情失败，尝试访问的数据不存在！";
        log.warn(message);
        throw new ServiceException(ServiceCode.ERR_NOT_FOUND, message);
    }

    log.debug("即将返回查询结果：{}", album);
    return album;
}
```

在`AlbumServiceTests`中编写并执行测试：

```java
@Test
void getStandardById() {
    Long id = 10L;

    try {
        AlbumStandardVO album = service.getStandardById(id);
        log.debug("查询相册详情成功！结果：{}", album);
    } catch (ServiceException e) {
        log.debug("捕获到异常，其中的消息：{}", e.getMessage());
    }
}
```

# 58. 根据id查询相册详情--Controller层

由于需要向客户端响应数据，且，目前控制器中处理请求的**统一结果类型**是`JsonResult`类，则需要在此类中添加新的属性，以表示需要响应到客户端的数据，并且数据类型可能无法确定（有时需要响应相册数据，有时需要响应品牌数据，等等），则新的属性需要能够表示若干种无法确定的类型，可以考虑使用`Object`类型进行声明：

```java
/**
 * 操作“成功”时响应的数据
 */
private Object data;
```

为了便于快速的创建`JsonResult`对象，并为属性赋值，在`JsonResult`类中添加新的静态方法：

```json
public static JsonResult ok(Object data) {
    JsonResult jsonResult = new JsonResult();
    jsonResult.setState(ServiceCode.OK.getValue());
    jsonResult.setData(data);
    return jsonResult;
}
```

接下来，在`AlbumController`中处理请求：

```java
// http://localhost:9080/albums/9527
@GetMapping("/{id:[0-9]+}")
@ApiOperation("根据id查询相册详情")
@ApiOperationSupport(order = 410)
@ApiImplicitParam(name = "id", value = "相册ID", required = true, example = "9527", dataType = "long")
public JsonResult getStandardById(@Range(min = 1, max = 1000000, message = "查询相册详情失败，相册ID非法！")
                                  @PathVariable Long id) {
    log.debug("开始处理【根据id查询相册详情】的请求，参数：{}", id);
    AlbumStandardVO albumStandardVO = albumService.getStandardById(id);
    return JsonResult.ok(albumStandardVO);
}
```

# 59. 调整`JsonResult`

当客户端请求数据时，服务器端应该响应数据，但是，不同的请求，需要响应的数据类型可能不同，更推荐使用泛型来声明，则：

```java
package cn.tedu.csmall.product.web;

import cn.tedu.csmall.product.ex.ServiceException;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * 统一的响应结果类型
 *
 * @author java@tedu.cn
 * @version 0.0.1
 */
@Data
public class JsonResult<T> implements Serializable {

    /**
     * 操作结果的状态码
     */
    @ApiModelProperty("业务状态码")
    private Integer state;
    /**
     * 操作“失败”时响应的提示文本
     */
    @ApiModelProperty("消息")
    private String message;
    /**
     * 操作“成功”时响应的数据
     */
    @ApiModelProperty("数据")
    private T data; // T=Type, E=Element, K=Key, V=Value

    public static JsonResult<Void> ok() {
        return ok(null);
    }

    public static <T> JsonResult<T> ok(T data) {
        JsonResult jsonResult = new JsonResult();
        jsonResult.setState(ServiceCode.OK.getValue());
        jsonResult.setData(data);
        return jsonResult;
    }

    public static JsonResult<Void> fail(ServiceException e) {
        return fail(e.getServiceCode(), e.getMessage());
    }

    public static JsonResult<Void> fail(ServiceCode serviceCode, String message) {
        JsonResult jsonResult = new JsonResult();
        jsonResult.setState(serviceCode.getValue());
        jsonResult.setMessage(message);
        return jsonResult;
    }

}
```

# 60. 查询相册列表--Mapper层

此前已经完成

# 61. 查询相册列表--Service层

在`IAlbumService`接口中添加抽象方法：

```java
/**
 * 查询相册数据列表
 *
 * @return 相册数据列表
 */
List<AlbumListItemVO> list();
```

在`AlbumServiceImpl`中实现以上抽象方法：

```java
public List<AlbumListItemVO> list() {
    // 调用Mapper的list()方法查询列表，获取返回结果
    // 返回以上查询的返回结果
}
```

具体实现为：

```java
@Override
public List<AlbumListItemVO> list() {
    log.debug("开始处理【查询相册列表】的业务，无参数");
    List<AlbumListItemVO> list = albumMapper.list();
    log.debug("即将返回查询结果：{}", list);
    return list;
}
```

在`AlbumServiceTests`中编写并执行测试：

```java
@Test
void list() {
    try {
        List<?> list = service.list();
        log.debug("查询列表完成，列表中的数据的数量：{}", list.size());
        for (Object item : list) {
            log.debug("{}", item);
        }
    } catch (ServiceException e) {
        log.debug("捕获到异常，其中的消息：{}", e.getMessage());
    }
}
```

# 62. 查询相册列表--Controller层

```java
// http://localhost:9080/albums
@GetMapping("")
@ApiOperation("查询相册列表")
@ApiOperationSupport(order = 420)
public JsonResult<List<AlbumListItemVO>> list() {
    log.debug("开始处理【查询相册列表】的业务，无参数");
    List<AlbumListItemVO> list = albumService.list();
    return JsonResult.ok(list);
}
```







