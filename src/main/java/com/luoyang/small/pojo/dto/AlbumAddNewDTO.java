package com.luoyang.small.pojo.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * service操作相册数据实体类
 *
 * @author luoyang
 * @Date 2023/12/12
 */
@Data
public class AlbumAddNewDTO implements Serializable {
    @ApiModelProperty(value = "相册名称", required = true, example = "小米手机的相册")
    private String name;
    @ApiModelProperty(value = "描述", example = "简单相册")
    private String description;
    @ApiModelProperty(value = "排序权重", example = "100")
    private Integer sort;
}
