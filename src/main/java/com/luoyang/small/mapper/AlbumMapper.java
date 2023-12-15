package com.luoyang.small.mapper;


import com.luoyang.small.pojo.entity.Album;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author luoyang
 * @date 2023/11/28
 */
//标记当前类是数据访问组件类
@Repository
public interface AlbumMapper {

    /**
     * 插入相册数据
     *
     * @param album 相册数据
     * @return 受影响的行数
     */
    int insert(Album album);


    /**
     * 根据相册名称统计数据的数量
     *
     * @param name 相册名称
     * @return 匹配名称的相册数据的数量
     */
    int countByName(String name);


    /**
     * 根据相册名删除
     *
     * @param name 相册名称
     * @return 受影响的行数
     */
    int deleteByName(String name);

    /**
     * 根据相册名删除
     *
     * @param album 相册信息
     * @return 受影响的行数
     */
    int updateByName(Album album);

    /**
     * 根据相册名删除
     *
     * @return 受影响的行数
     */
    List<Album> selectAll();

}