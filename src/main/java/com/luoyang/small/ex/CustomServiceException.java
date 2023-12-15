package com.luoyang.small.ex;

/**
 * 自定义异常
 * 自定义异常必须继承自某个已存在的异常类型，强烈建议继承自RuntimeException，其原因有：
 *
 * **原因1：**在项目中将使用全局异常处理器统一处理异常，要想统一处理，则Service组件、Controller组件都必须抛出异常，
 * 才能由Spring MVC框架捕获到异常，进而通过全局异常处理器进行统一的处理！
 * RuntimeException不会受到异常的相关语句约束，而非RuntimeException一旦被抛出，方法的声明、方法的调用者的声明等都需要声明抛出此异常，
 * 由于抛出异常是固定的做法，没有必要在各个方法上都声明抛出此异常，所以，应该使用RuntimeException
 * 原因2：配合Spring JDBC框架实现事务管理！
 *
 * @author luoyang
 * @Date 2023/12/12
 */
public class CustomServiceException extends RuntimeException {
    public CustomServiceException(String message) {
        super(message);
    }
}
