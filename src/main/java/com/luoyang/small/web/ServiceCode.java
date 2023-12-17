package com.luoyang.small.web;


/**
 * @author luoyang
 * @date 2023/12/16
 */
public enum ServiceCode {

    // 注意：每一个枚举值，其实都是当前枚举类型的对象
    // 注意：请将以下语法理解为“通过带参数的构造方法创建枚举类型的对象”
    // 注意：由于通过构造方法传入了值，所以，每个枚举类型的对象都带有一个数字值，后续可以getValue()取出
    OK(200),
    ERR_NOT_FOUND(404),
    ERR_CONFLICT(409),
    ERR_CUSTOM(1000);

    // 以下属性，表示每个枚举类型的对象都有一个Integer value属性，此属性的值将通过构造方法传入
    private Integer value;

    // 显式的声明枚举的带Integer参数的构造方法，用于创建枚举类型的对象时，为其Integer value属性赋值
    // 注意：枚举的构造方法的访问权限固定是私有的（Java语法特征）
    //      不写访问权限，并不表示“默认的”，而是“私有的”
    //      写public / protected是错误的
    //      写private是多余的
    ServiceCode(Integer value) {
        this.value = value;
    }

    // 用于通过枚举对象获取Integer value属性的值
    public Integer getValue() {
        return value;
    }
}
