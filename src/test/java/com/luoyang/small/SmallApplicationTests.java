package com.luoyang.small;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.sql.DataSource;

@Slf4j
@SpringBootTest
class SmallApplicationTests {
    /**
     *  注意：导java.sql包中的接口
     */
    @Autowired
    DataSource dataSource;

    @Test
    void getConnection() throws Throwable {
        // 调用getConnection()时会连接数据库，则可以判断配置的连接信息是否正确
        dataSource.getConnection();
    }

    @Test
    void contextLoads() {
    }

    @Test
    void logTest(){
        int x = 1;
        int y = 2;
        System.out.println("x = " + x + ", y = " + y + ", x + y = " + (x + y)); // 传统做法
        log.trace("111x = {}, y = {}, x + y = {}", x , y , x + y); // 使用日志输出变量的做法
        log.debug("222x = {}, y = {}, x + y = {}", x , y , x + y); // 使用日志输出变量的做法
        log.info("333x = {}, y = {}, x + y = {}", x , y , x + y); // 使用日志输出变量的做法
        log.warn("444x = {}, y = {}, x + y = {}", x , y , x + y); // 使用日志输出变量的做法
        log.error("555x = {}, y = {}, x + y = {}", x , y , x + y); // 使用日志输出变量的做法

    }

}
