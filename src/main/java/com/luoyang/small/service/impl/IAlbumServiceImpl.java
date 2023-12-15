package com.luoyang.small.service.impl;

import com.luoyang.small.mapper.AlbumMapper;
import com.luoyang.small.pojo.dto.AlbumAddNewDTO;
import com.luoyang.small.pojo.entity.Album;
import com.luoyang.small.service.IAlbumService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 接口实现
 *
 * @author luoyang
 * @Date 2023/12/12
 */
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
            throw new RuntimeException("相册名称已经被占用1111");
        }

        //创建Album对象
        Album album = new Album();
        //复制属性到album
        BeanUtils.copyProperties(albumAddNewDTO, album);

        //执行插入数据
        albumMapper.insert(album);
    }
}
