package com.luoyang.small.config;


import lombok.extern.slf4j.Slf4j;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;


/**
 * @author luoyang
 * @date 2023/11/28
 */
@Slf4j
@Configuration
@MapperScan("com.luoyang.small.mapper")
public class MybatisConfiguration {
    public MybatisConfiguration() {
        log.trace("创建配置类对象：MybatisConfiguration");
        log.debug("创建配置类对象：MybatisConfiguration");
        log.info("创建配置类对象：MybatisConfiguration");
    }
}
