# 2022.12.26  星期一

在`csmall-product`项目中，创建出与`mall_pms`中每一张数据表对应的实体类，并要求添加相关的注释。

作业提交截止时间：明天（12.27）早上9点。

# 2022.12.28  星期三

在`csmall-product`项目中，完成所有数据表的：

- 插入数据功能
- 批量插入数据功能

作业提交截止时间：明天（12.29）早上9点。

# 2022.12.29  星期四

在`csmall-product`项目中，完成所有数据表的：

- 根据id删除数据功能
- 批量删除数据功能
- 修改数据功能

注意：只需要完成Mapper的开发即可。

作业提交截止时间：明天（12.30）早上9点。

# 2022.12.30  星期五

在`csmall-product`项目中，完成所有数据表的：

- 统计当前表中数据的数量
- 根据id查询数据详情
- 查询数据列表

在`csmall-product`项目中，完成对以下各表的数据访问功能：

- `pms_album`
  - 根据名称统计数量
    - 抽象方法名称建议声明为：`countByName`
  - 根据名称和“非此id”统计数量
    - 抽象方法名称建议声明为：`countByNameAndNotId`
    - 此抽象方法将有2个参数：`Long id`、`String name`，推荐在每个参数上添加`@Param`并配置参数名称，即：`int countByNameAndNotId(@Param("id") Long id, @Param("name") String name);`
    - SQL语句中的条件为：`WHERE name=#{name} AND id!=#{id}`
    - 此方法将用于“有没有别的数据使用此名称”
- `pms_attribute`
  - 根据属性模板ID统计数量
    - 抽象方法名称建议声明为：`countByTemplateId`
    - 此数据表中有`template_id`字段，表示“属性模板ID”
  - 根据名称和属性模板ID统计数量
    - 抽象方法建议声明为：`int countByNameAndTemplate(@Param("name") String name, @Param("templateId") Long templateId);`
    - SQL语句中的条件为：`WHERE name=#{name} AND template_id=#{templateId}`
  - 根据名称、属性模板ID和“非此ID”统计数量
    - 抽象方法建议声明为：`int countByNameAndTemplateAndNotId(@Param("id") Long id, @Param("name") String name, @Param("templateId") Long templateId);`
    - SQL语句中的条件为：`WHERE name=#{name} AND template_id=#{templateId} AND id!=#{id}`
- `pms_attribute_template`
  - 根据名称统计数量
  - 根据名称和“非此id”统计数量
- `pms_brand_category`
  - 根据品牌ID统计数量
    - 抽象方法建议声明为：`countByBrand`
    - 此数据表中有`brand_id`字段，表示“品牌ID”
  - 根据类别ID统计数量
    - 抽象方法建议声明为：`countByCategory`
    - 此数据表中有`category_id`字段，表示“类别ID”
  - 根据品牌ID和类别ID统计数量
    - 抽象方法建议声明为：`int countByBrandAndCategory(@Param("brandId") Long brandId, @Param("categoryId") Long categoryId);`
    - SQL语句中的条件为：`WHERE brand_id=#{brandId} AND category_id=#{categoryId}`
- `pms_brand`
  - 根据名称统计数量
  - 根据名称和“非此id”统计数量
- `pms_category_attribute_template`
  - 根据类别ID统计数量
    - 抽象方法建议声明为：`countByCategory`
    - 此数据表中有`category_id`字段，表示“类别ID”
  - 根据属性模板ID统计数量
    - 抽象方法名称建议声明为：`countByAttributeTemplate`
    - 此数据表中有`template_id`字段，表示“属性模板ID”
- `pms_category`
  - 根据名称统计数量
  - 根据名称和“非此id”统计数量
  - 根据父级类别ID统计数量
    - 抽象方法名称建议声明为：`countByParentId`
    - 此数据表中有`parent_id`字段，表示“父级类别ID”
  - 根据父级类别ID查询列表
    - 抽象方法名称建议声明为：`listByParentId`
- `pms_picture`
  - 根据相册ID统计数量
    - 抽象方法名称建议声明为：`countByAlbum`
    - 此数据表中有`album_id`字段，表示“相册ID”
- `pms_spu`
  - 根据相册ID统计数量
    - 抽象方法名称建议声明为：`countByAlbum`
    - 此数据表中有`album_id`字段，表示“相册ID”
  - 根据品牌ID统计数量
    - 抽象方法建议声明为：`countByBrand`
    - 此数据表中有`brand_id`字段，表示“品牌ID”
  - 根据类别ID统计数量
    - 抽象方法建议声明为：`countByCategory`
    - 此数据表中有`category_id`字段，表示“类别ID”
  - 根据属性模板ID统计数量
    - 抽象方法名称建议声明为：`countByAttributeTemplate`
    - 此数据表中有`template_id`字段，表示“属性模板ID”

注意：只需要完成Mapper的开发即可。

注意：查询详情和查询列表需要配置对应的`<sql>`、`<resultMap>`，并创建必要的VO类，在配置`<resultMap>`时，主键字段值与属性的映射关系使用`<id>`标签配置，其它字段值与属性的映射关系使用`<result>`标签配置，这2种标签都是配置`column="列名/字段名"`和`property="属性名"`。

作业提交截止时间：下个授课日（2023.1.3）早上9点。

# 2023.01.04  星期三

参考《csmall-design.pdf》（在老师的`cmsll-product`项目中），在`csmall-web-client`项目中完成菜单内容的设计（不需要处理样式）

作业提交截止时间：明天（2023.01.05）早上9点。

# 2023.01.05  星期四

在`csmall-product`中，参考已经实现的“添加相册”的`AlbumController`，实现通过控制器接收并处理“添加属性模板”的请求。

在`csmall-web-client`中，参考已经实现的“添加相册”的视图组件，实现：显示“添加属性模板”表单，并且，点击提交按钮时，与服务器端交互，实现添加功能。

作业提交截止时间：明天（2023.01.06）早上9点。

# 2023.02.04. 星期六

在`csmall-product`与`csmall-web-client`中，参考已经实现的“相册管理模块”中已实现的功能，完成如下功能：

- 添加属性模板（部分代码可能需要参考“添加相册”进行调整，保证风格统一）
- 查看属性模板列表
- 删除属性模板
- 修改属性模板

另外，请检查假期作业中的`csmall-passport`中的部分是否已完成，并参考`csmall-product`中近期更新的内容，进行必要的调整，以保证代码风格统一，至少包括：

- 在Service中调用Mapper对象的增、删、改时，获取返回的受影响行数，判断是否符合预期值，如果不符合，应抛出异常
- 修改`JsonResult`，与`csmall-product`中的一致，且在各声明位置，保证`JsonResult`明确的声明了泛型

作业提交截止时间：下周一（2023.02.06）早上9点。

# 2023.02.06. 星期一

在`csmall-passport`项目中，实现“查询管理员列表”功能，要求完成Mapper层、Service层、Controller层。

作业提交截止时间：明天（2023.02.07）早上9点。

# 2023.02.07. 星期二

在`csmall-product`与`csmall-web-client`中，参考已经实现的“相册管理模块”中已实现的功能，完成如下功能：

- 添加品牌
- 查看品牌列表
- 删除品牌
- 修改品牌

作业提交截止时间：后天（2023.02.09）早上9点。

# 2023.02.09. 星期四

在`csmall-web-client`中，参考已经实现的功能，完成如下功能：

- 添加管理员

在`csmall-passport`中，参考`csmall-product`已经实现的功能，完成如下功能：

- 删除管理员
  - 注意：请求参数为1时应该抛出异常，不允许删除1号管理员
- 启用管理员
  - 注意：请求参数为1时应该抛出异常，不允许启用1号管理员
- 禁用管理员
  - 注意：请求参数为1时应该抛出异常，不允许禁用1号管理员

作业提交截止时间：明天（2023.02.10）早上9点。

# 2023.02.10. 星期五

在`csmall-product`项目中，完成以下功能（需要通过API文档可调试）：

- 添加属性
- 查询属性列表
- 根据ID查询属性详情
- 删除属性
- 修改属性
- 添加图片
- 删除图片

提示：“属性”与“属性模板”是有关联的，类似“文件”与“文件夹”的关系。

在`csmall-web-client`项目中，完成以下视图及功能：

- 添加属性视图
  - 添加属性功能
- 属性列表视图
  - 显示属性列表功能
  - 删除属性功能
  - 修改属性功能

另外，创建新的项目（项目名称等参数可自定义），在新项目中完成`csmall-passport`中的基于Spring Security + JWT的认证、授权功能【此项不需要提交】。

作业提交截止时间：下周一（2023.02.13）早上9点。























