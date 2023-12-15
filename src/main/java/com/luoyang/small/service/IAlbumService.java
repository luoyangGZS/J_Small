package com.luoyang.small.service;

import com.luoyang.small.pojo.dto.AlbumAddNewDTO;
import com.luoyang.small.pojo.entity.Album;

import java.util.List;

/**
 * 添加相册接口
 *
 * @author luoyang
 * @Date 2023/12/12
 */
public interface IAlbumService {
    void addNew(AlbumAddNewDTO albumAddNewDTO);

    void deleteAlbum(String name);

    void updateAlbum(AlbumAddNewDTO albumAddNewDTO);

    List<Album> selectAllAlbum();
}
