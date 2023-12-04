package com.luoyang.small;


import com.luoyang.small.mapper.AlbumMapper;
import com.luoyang.small.pojo.entity.Album;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * @author luoyang
 * @date 2023/11/28
 */
@SpringBootTest
public class AlbumMapperTests {

    @Autowired
    AlbumMapper mapper;

    @Test
    void insert() {
        Album album = new Album();
        album.setName("测试名称001");
        album.setDescription("测试简介001l啦啦啦啦啦");
        album.setSort(100); // 注意：由于MySQL中表设计的限制，此值只能是[0,255]区间内的

        int rows = mapper.insert(album);
        System.out.println("插入数据完成，受影响的行数：" + rows);
    }

}