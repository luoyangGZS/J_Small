package com.luoyang.small.service.impl;

import com.luoyang.small.ex.CustomServiceException;
import com.luoyang.small.mapper.AlbumMapper;
import com.luoyang.small.pojo.dto.AlbumAddNewDTO;
import com.luoyang.small.pojo.entity.Album;
import com.luoyang.small.service.IAlbumService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 接口实现
 *
 * @author luoyang
 * @Date 2023/12/12
 */
@Slf4j
// 添加在类上，标记当前类是业务逻辑组件类，用法同@Component
@Service
public class IAlbumServiceImpl implements IAlbumService {
    /**
     * 添加在属性上，使得Spring自动装配此属性的值
     * 添加在构造方法上，使得Spring自动调用此构造方法
     * 添加在Setter方法上，使得Spring自动调用此方法
     */
    @Autowired
    private AlbumMapper albumMapper;

    @Override
    public void addNew(AlbumAddNewDTO albumAddNewDTO) {
        //检查相册名称是否占用
        String name = albumAddNewDTO.getName();
        int countByName = albumMapper.countByName(name);
        //如果数据已存在还继续插入，我们这边直接报异常，不添加。
        if (countByName > 0) {
            throw new CustomServiceException("相册名称已经被占用，新增失败");
        }

        //创建Album对象
        Album album = new Album();
        //复制属性到album
        BeanUtils.copyProperties(albumAddNewDTO, album);

        //执行插入数据
        int insert = albumMapper.insert(album);
        log.debug("插入结果 {}", insert);
    }

    @Override
    public void deleteAlbum(String name) {
        int delete = albumMapper.deleteByName(name);
        log.debug("删除结果 {}", delete);
    }

    @Override
    public void updateAlbum(AlbumAddNewDTO albumAddNewDTO) {
        //检查相册名称是否占用
        String name = albumAddNewDTO.getName();
        int countByName = albumMapper.countByName(name);
        //如果数据已存在还继续插入，我们这边直接报异常，不添加。
        if (countByName <= 0) {
            throw new CustomServiceException("该相册不存在");
        }

        //创建Album对象
        Album album = new Album();
        //复制属性到album
        BeanUtils.copyProperties(albumAddNewDTO, album);
        int update = albumMapper.updateByName(album);
        log.debug("更新结果 {}", update);
    }

    @Override
    public List<Album> selectAllAlbum() {
        List<Album> listAlbum = albumMapper.selectAll();
        log.debug("查询结果 {}", listAlbum.toString());
        return listAlbum;
    }
}
