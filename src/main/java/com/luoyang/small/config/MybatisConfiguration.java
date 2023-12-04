package com.luoyang.small.config;


import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

import static jdk.nashorn.internal.runtime.regexp.joni.Config.log;

/**
 * @author luoyang
 * @date 2023/11/28
 */
@Configuration
@MapperScan("com.luoyang.small.mapper")
public class MybatisConfiguration {
    public MybatisConfiguration() {
        log.println("创建配置类对象：MybatisConfiguration");
    }
}
