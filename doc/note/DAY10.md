# 63. 添加类别--Mapper层

插入类别数据的功能此前已经完成！

# 64. 添加类别--Service层

在项目的根包下创建`pojo.dto.CategoryAddNewDTO`类：

```java
@Data
public class CategoryAddNewDTO implements Serializable {

    /**
     * 类别名称
     */
    private String name;

    /**
     * 父级类别id，如果无父级，则为0
     */
    private Long parentId;

    /**
     * 关键词列表，各关键词使用英文的逗号分隔
     */
    private String keywords;

    /**
     * 排序序号
     */
    private Integer sort;

    /**
     * 图标图片的URL
     */
    private String icon;

    /**
     * 是否启用，1=启用，0=未启用
     */
    private Integer enable;

    /**
     * 是否显示在导航栏中，1=启用，0=未启用
     */
    private Integer isDisplay;

}
```

在项目的根包下创建`service.ICategoryService`接口，并在接口中添加抽象方法：

```java
public interface ICategoryService {
    void addNew(CategoryAddNewDTO categoryAddNewDTO);
}
```

在项目的根包下创建`service.impl.CategoryServiceImpl`类，实现以上接口，并在类上添加`@Service`注解，然后，实现接口中的方法：

```java
@Service
public class CategoryServiceImpl implements ICategoryService {
    
    public void addNew(CategoryAddNewDTO categoryAddNewDTO) {
        // 调用Mapper对象的countByName()检查类别名称是否已经被占用
        // 是：抛出异常（ERR_CONFLICT）
        
        // 如果parentId不是0，调用Mapper对象的getStandardById()查询类别详情
        // 判断查询结果是否为null
        // 是：父级类别不存在，抛出异常（NOT_FOUND）
        
        // depth（深度）的值：如果父级类别id为0，则depth为1，否则，depth为父级depth+1
        
        // 创建Category类的对象
        // 将参数对象中的各属性值复制到以上新创建的Category类的对象中
        // 补全Category类的对象的属性值：depth
        // 补全Category类的对象的属性值：isParent >>> 固定为0
        // 调用Mapper对象的insert()方法插入类别数据
        
        // 如果现在添加的类别的父级类别不是0，
        // 如果父级类别的isParent仍为0
        // 则将父级类别的isParent更新为1
    }
    
}
```

具体实现为：

```java
@Override
public void addNew(CategoryAddNewDTO categoryAddNewDTO) {
    log.debug("开始处理【添加类别】的业务，参数：{}", categoryAddNewDTO);
    // 调用Mapper对象的countByName()检查类别名称是否已经被占用
    String name = categoryAddNewDTO.getName();
    int countByName = categoryMapper.countByName(name);
    if (countByName > 0) {
        // 是：抛出异常（ERR_CONFLICT）
        String message = "添加类别失败，尝试添加的类别名称【" + name + "】已经被占用！";
        log.warn(message);
        throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
    }

    Integer depth = 1;
    CategoryStandardVO parentCategory = null;
    Long parentId = categoryAddNewDTO.getParentId();
    if (parentId != 0) {
        // 如果parentId不是0，调用Mapper对象的getStandardById()查询类别详情
        parentCategory = categoryMapper.getStandardById(parentId);
        // 判断查询结果是否为null
        if (parentCategory == null) {
            // 是：父级类别不存在，抛出异常（NOT_FOUND）
            String message = "添加类别失败，选定的父级类别不存在！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_NOT_FOUND, message);
        } else {
            depth = parentCategory.getDepth() + 1;
        }
    }

    // 创建Category类的对象
    Category category = new Category();
    // 将参数对象中的各属性值复制到以上新创建的Category类的对象中
    BeanUtils.copyProperties(categoryAddNewDTO, category);
    // 补全Category类的对象的属性值：depth
    category.setDepth(depth);
    // 补全Category类的对象的属性值：isParent >>> 固定为0
    category.setIsParent(0);
    // 调用Mapper对象的insert()方法插入类别数据
    categoryMapper.insert(category);

    // 如果现在添加的类别的父级类别不是0
    if (parentId != 0) {
        // 如果父级类别的isParent仍为0
        if (parentCategory.getIsParent() == 0) {
            // 则将父级类别的isParent更新为1
            Category updateParentCategory = new Category();
            updateParentCategory.setId(parentId);
            updateParentCategory.setIsParent(1);
            categoryMapper.update(updateParentCategory);
        }
    }
}
```

在项目的`src/test/java`下的根包下创建`CategoryServiceTests`类，对以上方法进行测试：

```java
@Slf4j
@SpringBootTest
public class CategoryServiceTests {

    @Autowired
    ICategoryService service;

    @Test
    void addNew() {
        CategoryAddNewDTO categoryAddNewDTO = new CategoryAddNewDTO();
        categoryAddNewDTO.setParentId(74L);
        categoryAddNewDTO.setName("热带水果");

        try {
            service.addNew(categoryAddNewDTO);
            log.debug("添加类别成功！");
        } catch (ServiceException e) {
            log.debug("捕获到异常，其中的消息：{}", e.getMessage());
        }
    }

}
```

# 65. 添加类别--Controller层

在项目的根包下创建`controller.CategoryController`类，在类上添加`@RestController`注解和`@RequestMapping("/categories")`注解，在类中自动装配`ICategoryService`类型的对象：

```java
@RestController
@RequestMapping("/categories")
public class CategoryController {
    @Autowired
    private ICategoryService categoryService;
}
```

然后，在此类中处理请求：

```java
@PostMapping("/add-new")
public JsonResult<Void> addNew(CategoryAddNewDTO categoryAddNewDTO) {
    log.debug("xxx");
    categoryService.addNew(categoryAddNewDTO);
    return JsonResult.ok();
}
```

完成后，重启项目，可以通过在线API文档进行调试。

调试通过后，应该补充在线API文档的相关说明。

提示：接下来，在课上不再对请求参数的基本格式进行检查。

# 66. 删除类别--Mapper层

# 67. 删除类别--Service层

在`ICategoryService`接口中添加抽象方法：

```java
/**
 * 根据id删除类别
 *
 * @param id 类别id
 */
void delete(Long id);
```

在`CategoryServiceImpl`中实现以上方法：

```java
public void delete(Long id) {
    // 调用Mapper对象的getStandardById()执行查询
    // 判断查询结果是否为null
    // 是：数据已经不存在，抛出异常（NOT_FOUND）
    
    // 判断以上查询结果中的isParent是否为1
    // 是：当前尝试删除的是父级类别，抛出异常（CONFLICT）
    
    // 调用BrandCategoryMapper对象的countByCategory()执行统计
    // 判断统计结果是否大于0
    // 是：当前尝试删除的类别关联到了某些品牌，抛出异常（CONFLICT）
    
    // 调用CategoryAttributeTemplateMapper对象的countByCategory()执行统计
    // 判断统计结果是否大于0
    // 是：当前尝试删除的类别关联到了某些属性模板，抛出异常（CONFLICT）
    
    // 调用SpuMapper对象的countByCategory()执行统计
    // 判断统计结果是否大于0
    // 是：当前尝试删除的类别关联到了某些SPU，抛出异常（CONFLICT）
    
    // 调用Mapper对象的deleteById()执行删除
    
    // 从此前的查询结果中找到当前删除的类别的父级类别ID
    // 判断父级类别ID是否不为0
    // 调用Mapper对象的countByParentId()执行统计
    // 判断统计结果是否等于0
    // 是：将父级类别的isParent更新为0
}
```

具体实现为：

```java
@Override
public void delete(Long id) {
    // 调用Mapper对象的getStandardById()执行查询
    CategoryStandardVO currentCategory = categoryMapper.getStandardById(id);
    // 判断查询结果是否为null
    if (currentCategory == null) {
        // 是：数据已经不存在，抛出异常（NOT_FOUND）
        String message = "删除类别失败，尝试删除的类别不存在！";
        log.warn(message);
        throw new ServiceException(ServiceCode.ERR_NOT_FOUND, message);
    }

    // 判断以上查询结果中的isParent是否为1
    if (currentCategory.getIsParent() == 1) {
        // 是：当前尝试删除的是父级类别，抛出异常（CONFLICT）
        String message = "删除类别失败，尝试删除的类别仍包含子级类别！";
        log.warn(message);
        throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
    }

    {
        // 调用BrandCategoryMapper对象的countByCategory()执行统计
        int count = brandCategoryMapper.countByCategory(id);
        // 判断统计结果是否大于0
        if (count > 0) {
            // 是：当前尝试删除的类别关联到了某些品牌，抛出异常（CONFLICT）
            String message = "删除类别失败，尝试删除的类别关联了某些品牌！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
        }
    }

    {
        // 调用CategoryAttributeTemplateMapper对象的countByCategory()执行统计
        int count = categoryAttributeTemplateMapper.countByCategory(id);
        // 判断统计结果是否大于0
        if (count > 0) {
            // 是：当前尝试删除的类别关联到了某些属性模板，抛出异常（CONFLICT）
            String message = "删除类别失败，尝试删除的类别关联了某些属性模板！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
        }
    }

    {
        // 调用SpuMapper对象的countByCategory()执行统计
        int count = spuMapper.countByCategory(id);
        // 判断统计结果是否大于0
        if (count > 0) {
            // 是：当前尝试删除的类别关联到了某些SPU，抛出异常（CONFLICT）
            String message = "删除类别失败，尝试删除的类别关联了某些SPU！";
            log.warn(message);
            throw new ServiceException(ServiceCode.ERR_CONFLICT, message);
        }
    }

    // 调用Mapper对象的deleteById()执行删除
    log.debug("即将执行删除类别，参数：{}", id);
    categoryMapper.deleteById(id);

    // 从此前的查询结果中找到当前删除的类别的父级类别ID
    Long parentId = currentCategory.getParentId();
    // 判断父级类别ID是否不为0
    if (parentId != 0) {
        // 调用Mapper对象的countByParentId()执行统计
        int count = categoryMapper.countByParentId(parentId);
        // 判断统计结果是否等于0
        if (count == 0) {
            // 是：将父级类别的isParent更新为0
            Category parentCategory = new Category();
            parentCategory.setId(parentId);
            parentCategory.setIsParent(0);
            categoryMapper.update(parentCategory);
        }
    }
}
```

在`CategoryServiceTests`中编写并执行测试：

```java
@Test
void delete() {
    Long id = 74L;

    try {
        service.delete(id);
        log.debug("删除类别成功！");
    } catch (ServiceException e) {
        log.debug("捕获到异常，其中的消息：{}", e.getMessage());
    }
}
```





