package com.luoyang.small.pojo.entity;


import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 相册数据实体类
 *
 * @author luoyang
 * @date 2023/11/28
 */
@Data
public class Album implements Serializable {
    /**
     * 数据id
     */
    private Long id;
    /**
     * 相册名称
     */
    private String name;
    /**
     * 相册简介
     */
    private String description;
    /**
     * 排序序号
     */
    private Integer sort;
    /**
     * 数据创建时间
     */
    private LocalDateTime gmtCreate;
    /**
     * 数据最后修改时间
     */
    private LocalDateTime gmtModified;
}
