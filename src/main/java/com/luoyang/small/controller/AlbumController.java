package com.luoyang.small.controller;

import com.github.xiaoymin.knife4j.annotations.ApiOperationSupport;
import com.luoyang.small.ex.CustomServiceException;
import com.luoyang.small.pojo.dto.AlbumAddNewDTO;
import com.luoyang.small.pojo.entity.Album;
import com.luoyang.small.service.IAlbumService;
import com.luoyang.small.web.JsonResult;
import com.luoyang.small.web.ServiceCode;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 相册web控制器
 *
 * @author luoyang
 * @Date 2023/12/13
 */

@Slf4j
@RequestMapping("/album")
@RestController
//Api在线文档注解
@Api(tags = "1.相册管理")
public class AlbumController {

    /**
     * 不建议声明为具体的实现类，那样不利于代码“解耦”！
     */
    @Autowired
    private IAlbumService albumService;

    //在线文档注解
    @ApiOperation("添加相册") //接口名注解
//    @ApiImplicitParam(name = "albumAddNewDTO", value = "相册对象", required = true) //参数名注解
    @ApiOperationSupport(order = 2)//接口展示排序
    //直接网络请求添加
    //http://localhost:8080/album/add?name=TestAlbum001&description=TestDescription001&sort=88
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public JsonResult addNewAlbum(AlbumAddNewDTO albumAddNewDTO) {
        albumService.addNew(albumAddNewDTO);
        return JsonResult.ok();
    }

    //在线文档注解
    @ApiOperation("根据相册对象删除相册")//接口名注解
    @ApiImplicitParam(name = "albumName", value = "相册对象", required = true,
            example = "小米9相册", dataType = "String")//参数名注解
    @ApiOperationSupport(order = 1)//接口展示排序
    //直接网络请求删除
    //http://localhost:8080/album/delete?name=TestAlbum001
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public JsonResult deleteAlbum(String name) {
        log.debug("开始处理【根据相册名删除】的请求，参数：{}", name);
        if (name == null || name.isEmpty()) {
            return JsonResult.fail(ServiceCode.ERR_CUSTOM, "删除相册的名称为空");
        }
        try {
            albumService.deleteAlbum(name);
            return JsonResult.ok();
        } catch (Exception e) {
            String message = e.getMessage();
            log.error("deleteAlbum Exception {}", message);
            return JsonResult.fail(ServiceCode.ERR_CUSTOM, message);
        }
    }

    //在线文档注解
    @ApiOperation("根据相册对象更新相册")//接口名注解
    @ApiOperationSupport(order = 4)//接口展示排序
    //直接web请求地址更新，如下
    //http://localhost:8080/album/update?name=TestAlbum001&description=TestDescription001&sort=88
    @RequestMapping(value = "update", method = RequestMethod.GET)
    public String updateAlbum(AlbumAddNewDTO albumAddNewDTO) {
        if (albumAddNewDTO == null) {
            return "更新对象为空";
        }
        String name = albumAddNewDTO.getName();
        if (name == null || name.isEmpty()) {
            return "更新相册的名称为空";
        }
        try {
            albumService.updateAlbum(albumAddNewDTO);
            return name + "相册，更新成功Ya!";
        } catch (Exception e) {
            String message = e.getMessage();
            log.error("updateAlbum Exception {}", message);
            return message;
        }
    }

    //在线文档注解
    @ApiOperationSupport(order = 3)//接口展示排序
    @ApiOperation("查询所有相册")//接口名注解
    //直接网络请求更新
    //http://localhost:8080/album/selectAll
    @RequestMapping(value = {"selectAll", "selectAllOtherName"}, method = RequestMethod.GET)
    public List<Album> selectAllAlbum() {
        List<Album> albumList = null;
        try {
            albumList = albumService.selectAllAlbum();
        } catch (Exception e) {
            String message = e.getMessage();
            log.error("selectAllAlbum Exception {}", message);
        }
        return albumList;
    }

}
