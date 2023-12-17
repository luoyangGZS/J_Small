package com.luoyang.small.web;


import com.luoyang.small.ex.CustomServiceException;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.Serializable;

/**
 * 响应json
 *
 * @author luoyang
 * @date 2023/12/16
 */
@Data
@Slf4j
@NoArgsConstructor
@AllArgsConstructor
//@JsonInclude(JsonInclude.Include.NON_NULL) //配置在类上，所以属性为空是都不展示该属性
public class JsonResult implements Serializable {
    private Integer code;
    // @JsonInclude用于配置“此属性什么时候会包含在JSON结果中”
    // NON_NULL 表示 不为null的时候
//    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String message;

    public static JsonResult ok() {
        JsonResult jsonResult = new JsonResult();
        jsonResult.setCode(ServiceCode.OK.getValue());
        return jsonResult;
    }

    public static JsonResult fail(ServiceCode serviceCode, String message) {
        JsonResult jsonResult = new JsonResult();
        jsonResult.setCode(serviceCode.getValue());
        jsonResult.setMessage(message);
        log.error("JsonResult fail  serviceCode {}, message{}", serviceCode, message);
        return jsonResult;
    }

    public static JsonResult fail(CustomServiceException e) {
        return fail(e.getServiceCode(), e.getMessage());
    }
}
