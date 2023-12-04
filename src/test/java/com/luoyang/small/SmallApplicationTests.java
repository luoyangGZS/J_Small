package com.luoyang.small;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.sql.DataSource;

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

}
