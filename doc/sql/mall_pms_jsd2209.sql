-- mall_pms

DROP TABLE IF EXISTS pms_brand;
CREATE TABLE pms_brand
(
    id                     bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    name                   varchar(50)         DEFAULT NULL COMMENT '品牌名称',
    pinyin                 varchar(50)         DEFAULT NULL COMMENT '品牌名称的拼音',
    logo                   varchar(255)        DEFAULT NULL COMMENT '品牌logo的URL',
    description            varchar(255)        DEFAULT NULL COMMENT '品牌简介',
    keywords               varchar(255)        DEFAULT NULL COMMENT '关键词列表，各关键词使用英文的逗号分隔',
    sort                   tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    sales                  int(10) unsigned    DEFAULT '0' COMMENT '销量（冗余）',
    product_count          int(10) unsigned    DEFAULT '0' COMMENT '商品种类数量总和（冗余）',
    comment_count          int(10) unsigned    DEFAULT '0' COMMENT '买家评论数量总和（冗余）',
    positive_comment_count int(10) unsigned    DEFAULT '0' COMMENT '买家好评数量总和（冗余）',
    enable                 tinyint(3) unsigned DEFAULT '0' COMMENT '是否启用，1=启用，0=未启用',
    gmt_create             datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified           datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='品牌';

DROP TABLE IF EXISTS pms_category;
CREATE TABLE pms_category
(
    id           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    name         varchar(50)         DEFAULT NULL COMMENT '类别名称',
    parent_id    bigint(20) unsigned DEFAULT '0' COMMENT '父级类别id，如果无父级，则为0',
    depth        tinyint(3) unsigned DEFAULT '1' COMMENT '深度，最顶级类别的深度为1，次级为2，以此类推',
    keywords     varchar(255)        DEFAULT NULL COMMENT '关键词列表，各关键词使用英文的逗号分隔',
    sort         tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    icon         varchar(255)        DEFAULT NULL COMMENT '图标图片的URL',
    enable       tinyint(3) unsigned DEFAULT '0' COMMENT '是否启用，1=启用，0=未启用',
    is_parent    tinyint(3) unsigned DEFAULT '0' COMMENT '是否为父级（是否包含子级），1=是父级，0=不是父级',
    is_display   tinyint(3) unsigned DEFAULT '0' COMMENT '是否显示在导航栏中，1=启用，0=未启用',
    gmt_create   datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='类别';

DROP TABLE IF EXISTS pms_brand_category;
CREATE TABLE pms_brand_category
(
    id           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    brand_id     bigint(20) unsigned DEFAULT NULL COMMENT '品牌id',
    category_id  bigint(20) unsigned DEFAULT NULL COMMENT '类别id',
    gmt_create   datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='品牌与类别关联';

DROP TABLE IF EXISTS pms_picture;
CREATE TABLE pms_picture
(
    id           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    album_id     bigint(20) unsigned  DEFAULT NULL COMMENT '相册id',
    url          varchar(255)         DEFAULT NULL COMMENT '图片url',
    description  varchar(255)         DEFAULT NULL COMMENT '图片简介',
    width        smallint(5) unsigned DEFAULT NULL COMMENT '图片宽度，单位：px',
    height       smallint(5) unsigned DEFAULT NULL COMMENT '图片高度，单位：px',
    is_cover     tinyint(3) unsigned  DEFAULT '0' COMMENT '是否为封面图片，1=是，0=否',
    sort         tinyint(3) unsigned  DEFAULT '0' COMMENT '排序序号',
    gmt_create   datetime             DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified datetime             DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='图片';

DROP TABLE IF EXISTS pms_album;
CREATE TABLE pms_album
(
    id           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    name         varchar(50)         DEFAULT NULL COMMENT '相册名称',
    description  varchar(255)        DEFAULT NULL COMMENT '相册简介',
    sort         tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    gmt_create   datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='相册';

DROP TABLE IF EXISTS pms_attribute_template;
CREATE TABLE pms_attribute_template
(
    id           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    name         varchar(50)         DEFAULT NULL COMMENT '属性模版名称',
    pinyin       varchar(50)         DEFAULT NULL COMMENT '属性模版名称的拼音',
    keywords     varchar(255)        DEFAULT NULL COMMENT '关键词列表，各关键词使用英文的逗号分隔',
    sort         tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    gmt_create   datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='属性模版';

DROP TABLE IF EXISTS pms_attribute;
CREATE TABLE pms_attribute
(
    id                 bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    template_id        bigint(20) unsigned DEFAULT NULL COMMENT '所属属性模版id',
    name               varchar(50)         DEFAULT NULL COMMENT '属性名称',
    description        varchar(255)        DEFAULT NULL COMMENT '属性简介（某些属性名称可能相同，通过简介补充描述）',
    type               tinyint(3) unsigned DEFAULT '0' COMMENT '属性类型，1=销售属性，0=非销售属性',
    input_type         tinyint(3) unsigned DEFAULT '0' COMMENT '输入类型，0=手动录入，1=单选，2=多选，3=单选（下拉列表），4=多选（下拉列表）',
    value_list         varchar(255)        DEFAULT NULL COMMENT '备选值列表',
    unit               varchar(50)         DEFAULT NULL COMMENT '计量单位',
    sort               tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    is_allow_customize tinyint(3) unsigned DEFAULT '0' COMMENT '是否允许自定义，1=允许，0=禁止',
    gmt_create         datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified       datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='属性';

DROP TABLE IF EXISTS pms_category_attribute_template;
CREATE TABLE pms_category_attribute_template
(
    id                    bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    category_id           bigint(20) unsigned DEFAULT NULL COMMENT '类别id',
    attribute_template_id bigint(20) unsigned DEFAULT NULL COMMENT '属性模版id',
    gmt_create            datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified          datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='类别与属性模版关联';

DROP TABLE IF EXISTS pms_spu;
CREATE TABLE pms_spu
(
    id                     bigint(20) unsigned NOT NULL COMMENT '数据id',
    name                   varchar(50)         DEFAULT NULL COMMENT 'SPU名称',
    type_number            varchar(50)         DEFAULT NULL COMMENT 'SPU编号',
    title                  varchar(255)        DEFAULT NULL COMMENT '标题',
    description            varchar(255)        DEFAULT NULL COMMENT 'SPU简介',
    list_price             decimal(10, 2)      DEFAULT NULL COMMENT '价格（显示在列表中）',
    stock                  int(10) unsigned    DEFAULT '0' COMMENT '当前库存（冗余）',
    stock_threshold        int(10) unsigned    DEFAULT '0' COMMENT '库存预警阈值（冗余）',
    unit                   varchar(50)         DEFAULT NULL COMMENT '计件单位',
    brand_id               bigint(20) unsigned DEFAULT NULL COMMENT '品牌id',
    brand_name             varchar(50)         DEFAULT NULL COMMENT '品牌名称（冗余）',
    category_id            bigint(20) unsigned DEFAULT NULL COMMENT '类别id',
    category_name          varchar(50)         DEFAULT NULL COMMENT '类别名称（冗余）',
    attribute_template_id  bigint(20) unsigned DEFAULT NULL COMMENT '属性模版id',
    album_id               bigint(20) unsigned DEFAULT NULL COMMENT '相册id',
    pictures               varchar(500)        DEFAULT NULL COMMENT '组图URLs，使用JSON数组表示',
    keywords               varchar(255)        DEFAULT NULL COMMENT '关键词列表，各关键词使用英文的逗号分隔',
    tags                   varchar(255)        DEFAULT NULL COMMENT '标签列表，各标签使用英文的逗号分隔，原则上最多3个',
    sales                  int(10) unsigned    DEFAULT '0' COMMENT '销量（冗余）',
    comment_count          int(10) unsigned    DEFAULT '0' COMMENT '买家评论数量总和（冗余）',
    positive_comment_count int(10) unsigned    DEFAULT '0' COMMENT '买家好评数量总和（冗余）',
    sort                   tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    is_deleted             tinyint(3) unsigned DEFAULT '0' COMMENT '是否标记为删除，1=已删除，0=未删除',
    is_published           tinyint(3) unsigned DEFAULT '0' COMMENT '是否上架（发布），1=已上架，0=未上架（下架）',
    is_new_arrival         tinyint(3) unsigned DEFAULT '0' COMMENT '是否新品，1=新品，0=非新品',
    is_recommend           tinyint(3) unsigned DEFAULT '0' COMMENT '是否推荐，1=推荐，0=不推荐',
    is_checked             tinyint(3) unsigned DEFAULT '0' COMMENT '是否已审核，1=已审核，0=未审核',
    check_user             varchar(50)         DEFAULT NULL COMMENT '审核人（冗余）',
    gmt_check              datetime            DEFAULT NULL COMMENT '审核通过时间（冗余）',
    gmt_create             datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified           datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='SPU（Standard Product Unit）';

DROP TABLE IF EXISTS pms_spu_detail;
CREATE TABLE pms_spu_detail
(
    id           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    spu_id       bigint(20) unsigned DEFAULT NULL COMMENT 'SPU id',
    detail       text COMMENT 'SPU详情，应该使用HTML富文本，通常内容是若干张图片',
    gmt_create   datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='SPU详情';

DROP TABLE IF EXISTS pms_sku;
CREATE TABLE pms_sku
(
    id                     bigint(20) unsigned NOT NULL COMMENT '数据id',
    spu_id                 bigint(20) unsigned DEFAULT NULL COMMENT 'SPU id',
    title                  varchar(255)        DEFAULT NULL COMMENT '标题',
    bar_code               varchar(255)        DEFAULT NULL COMMENT '条型码',
    attribute_template_id  bigint(20) unsigned DEFAULT NULL COMMENT '属性模版id',
    specifications         varchar(2500)       DEFAULT NULL COMMENT '全部属性，使用JSON格式表示（冗余）',
    album_id               bigint(20) unsigned DEFAULT NULL COMMENT '相册id',
    pictures               varchar(500)        DEFAULT NULL COMMENT '组图URLs，使用JSON格式表示',
    price                  decimal(10, 2)      DEFAULT NULL COMMENT '单价',
    stock                  int(10) unsigned    DEFAULT '0' COMMENT '当前库存',
    stock_threshold        int(10) unsigned    DEFAULT '0' COMMENT '库存预警阈值',
    sales                  int(10) unsigned    DEFAULT '0' COMMENT '销量（冗余）',
    comment_count          int(10) unsigned    DEFAULT '0' COMMENT '买家评论数量总和（冗余）',
    positive_comment_count int(10) unsigned    DEFAULT '0' COMMENT '买家好评数量总和（冗余）',
    sort                   tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    gmt_create             datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified           datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='SKU（Stock Keeping Unit）';

DROP TABLE IF EXISTS pms_sku_specification;
CREATE TABLE pms_sku_specification
(
    id              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '数据id',
    sku_id          bigint(20) unsigned DEFAULT NULL COMMENT 'SKU id',
    attribute_id    bigint(20) unsigned DEFAULT NULL COMMENT '属性id',
    attribute_name  varchar(50)         DEFAULT NULL COMMENT '属性名称',
    attribute_value varchar(50)         DEFAULT NULL COMMENT '属性值',
    unit            varchar(10)         DEFAULT NULL COMMENT '自动补充的计量单位',
    sort            tinyint(3) unsigned DEFAULT '0' COMMENT '排序序号',
    gmt_create      datetime            DEFAULT NULL COMMENT '数据创建时间',
    gmt_modified    datetime            DEFAULT NULL COMMENT '数据最后修改时间',
    PRIMARY KEY (id)
) DEFAULT CHARSET = utf8mb4 COMMENT ='SKU数据';

INSERT INTO pms_brand
VALUES (1, '华为', 'huawei', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (2, '小米', 'xiaomi', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (3, '格力', 'geli', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (4, '华硕', 'huashuo', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (5, '荣耀', 'rongyao', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (6, '微软', 'weiruan', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (7, '奥克斯', 'aokesi', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (8, '海尔', 'haier', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (9, '美的', 'meidi', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (10, '真我', 'realme', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (11, 'VIVO', 'vivo', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (12, 'OPPO', 'oppo', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (13, '小天鹅', 'xiaotiane', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (14, '志高', 'zhigao', 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', '暂无', '暂无', 0, 0, 0, 0, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44');

INSERT INTO pms_category
VALUES (1, '家用电器', 0, 1, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (2, '电视', 1, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (3, '空调', 1, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (4, '洗衣机', 1, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (5, '冰箱', 1, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (6, '全面屏电视', 2, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (7, 'OLED电视', 2, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (8, '智慧屏', 2, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (9, '空调挂机', 3, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (10, '空调柜机', 3, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (11, '新风空调', 3, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (12, '滚桶洗衣机', 4, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (13, '洗烘一体机', 4, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (14, '迷你洗衣机', 4, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (15, '洗衣机配件', 4, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (16, '双门冰箱', 5, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (17, '三门冰箱', 5, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (18, '对开门冰箱', 5, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (19, '冰柜', 5, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (20, '手机数码', 0, 1, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (21, '手机通讯', 20, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (22, '拍照手机', 21, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (23, '游戏手机', 21, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (24, '全面屏手机', 21, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (25, '5G手机', 21, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (26, '对讲机', 21, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (27, '手机配件', 20, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (28, '手机壳', 27, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (29, '贴膜', 27, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (30, '数据线', 27, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (31, '充电器', 27, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (32, '手机饰品', 27, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (33, '摄影摄像', 20, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (34, '数码相机', 33, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (35, '微单相机', 33, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (36, '单反相机', 33, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (37, '拍立得', 33, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (38, '影音娱乐', 20, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (39, '耳机', 38, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (40, '音箱', 38, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (41, '麦克风', 38, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (42, '收音机', 38, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (43, '电脑办公', 0, 1, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (44, '电脑整机', 43, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (45, '台式机', 44, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (46, '笔记本', 44, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (47, '游戏机', 44, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (48, '平板电脑', 44, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (49, '一体机', 44, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (50, '服务器', 44, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (51, '电脑配件', 43, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (52, '鼠标', 51, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (53, '键盘', 51, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (54, '显卡', 51, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (55, '主板', 51, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (56, 'CPU', 51, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (57, '内存条', 51, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (58, '硬盘', 51, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (59, '移动硬盘', 58, 4, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (60, '机械硬盘', 58, 4, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (61, '固态硬盘', 58, 4, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (62, '无线鼠标', 52, 4, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (63, '有线鼠标', 52, 4, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (64, '游戏鼠标', 52, 4, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (65, '家具', 0, 1, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (66, '灯具', 65, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 1, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (67, '吸顶灯', 66, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (68, '台灯', 66, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (69, '筒灯', 66, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (70, '应急灯', 66, 3, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (71, '沙发', 65, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (72, '茶几', 65, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (73, '床', 65, 2, '无', 0, 'https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png', 1, 0, 1, '2022-07-08 11:30:44', '2022-07-08 11:30:44');

INSERT INTO pms_album
VALUES (1, '华为Mate10的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (2, '华为Mate20的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (3, '华为Mate30的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (4, '华为Mate40的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (5, '华为Mate50的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (6, '华为P10的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (7, '华为P20的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (8, '华为P30的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (9, '华为P40的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (10, '华为P50的相册', '暂无', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44');

INSERT INTO pms_attribute_template
VALUES (1, '华为Mate10的属性模板', 'HUAWEIMATE10', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (2, '华为Mate20的属性模板', 'HUAWEIMATE20', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (3, '华为Mate30的属性模板', 'HUAWEIMATE30', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (4, '华为Mate40的属性模板', 'HUAWEIMATE40', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (5, '华为Mate50的属性模板', 'HUAWEIMATE50', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (6, '华为P10的属性模板', 'HUAWEIP10', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (7, '华为P20的属性模板', 'HUAWEIP20', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (8, '华为P30的属性模板', 'HUAWEIP30', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (9, '华为P40的属性模板', 'HUAWEIP40', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (10, '华为P50的属性模板', 'HUAWEIP50', '关键词1,关键词2,关键词3', 99, '2022-07-08 11:30:44', '2022-07-08 11:30:44');

INSERT INTO pms_attribute
VALUES (1, 1, 'CPU型号', '暂无', 1, 1, '骁龙888', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (2, 1, '运行内存', '暂无', 1, 1, '8,16', 'GB', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (3, 1, '机身内存', '暂无', 1, 1, '256,512', 'GB', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (4, 1, '机身颜色', '暂无', 1, 1, '曜金黑,冰霜银,流光紫', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (5, 1, '商品名称', '暂无', 0, 1, '华为HUAWEI Mate 50', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (6, 1, '商品产地', '暂无', 0, 1, '中国大陆', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (7, 1, '商品毛重', '暂无', 0, 1, '0.54', 'KG', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (8, 2, 'CPU型号', '暂无', 1, 1, 'Kirin 990E', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (9, 2, '运行内存', '暂无', 1, 1, '4,8,16', 'GB', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (10, 2, '机身内存', '暂无', 1, 1, '128,256,512', 'GB', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (11, 2, '机身颜色', '暂无', 1, 1, '亮黑色,釉白色', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (12, 2, '商品名称', '暂无', 0, 1, '华为HUAWEI Mate 40', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (13, 2, '商品产地', '暂无', 0, 1, '中国大陆', '', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44'),
       (14, 2, '商品毛重', '暂无', 0, 1, '0.5', 'KG', 99, 0, '2022-07-08 11:30:44', '2022-07-08 11:30:44');