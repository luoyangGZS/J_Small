package com.luoyang.small;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 学习商城后端项目
 */
@Slf4j
@SpringBootApplication
public class SmallApplication {

    public static void main(String[] args) {
        log.trace("trace初始化启动类：SmallApplication");
        log.debug("debug初始化启动类：SmallApplication");
        log.info("info初始化启动类：SmallApplication");
        SpringApplication.run(SmallApplication.class, args);
    }

}
