package com.luoyang.small.pojo.dto;

import lombok.Data;

/**
 * service操作相册数据实体类
 *
 * @author luoyang
 * @Date 2023/12/12
 */
@Data
public class AlbumAddNewDTO {
    private String name;
    private String description;
    private Integer sort;
}
