package com.luoyang.small.service;

import com.luoyang.small.pojo.dto.AlbumAddNewDTO;
import com.luoyang.small.pojo.entity.Album;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

/**
 * @author luoyang
 * @Date 2023/12/12
 */
@Slf4j
@SpringBootTest
public class AlbumServiceTests {
    //不建议声明为实现类型
    @Autowired
    IAlbumService iAlbumService;

    @Test
    void addNew() {
        AlbumAddNewDTO albumAddNewDTO = new AlbumAddNewDTO();
        albumAddNewDTO.setName("测试名称004");
        albumAddNewDTO.setDescription("测试简介004啦啦啦啦啦");
        albumAddNewDTO.setSort(100); // 注意：由于MySQL中表设计的限制，此值只能是[0,255]区间内的
        try {
            iAlbumService.addNew(albumAddNewDTO);
            log.debug("添加相册成功！");
        } catch (Exception e) {
            log.debug("添加相册失败，{}", e.getMessage());
        }
    }

    @Test
    void deleteAlbum() {
        try {
            String name = "测试名称001";
            iAlbumService.deleteAlbum(name);
            log.debug("{} 相册删除成功！", name);
        } catch (Exception e) {
            log.debug("删除相册失败，{}", e.getMessage());
        }
    }


    @Test
    void updateAlbum() {
        AlbumAddNewDTO albumAddNewDTO = new AlbumAddNewDTO();
        albumAddNewDTO.setName("测试名称004");
        albumAddNewDTO.setDescription("测试简介004更新哈哈哈");
        albumAddNewDTO.setSort(101); // 注意：由于MySQL中表设计的限制，此值只能是[0,255]区间内的
        try {
            iAlbumService.updateAlbum(albumAddNewDTO);
            log.debug("更新相册成功！");
        } catch (Exception e) {
            log.debug("更新相册失败，{}", e.getMessage());
        }
    }

    @Test
    void selectAll() {
        try {
            List<Album> albumList = iAlbumService.selectAllAlbum();
            log.debug("查询所有相册成功！{}", albumList.toString());
        } catch (Exception e) {
            log.debug("查询所有相册成功，{}", e.getMessage());
        }
    }

}
