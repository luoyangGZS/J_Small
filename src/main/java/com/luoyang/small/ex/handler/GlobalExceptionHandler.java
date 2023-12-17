package com.luoyang.small.ex.handler;


import com.luoyang.small.ex.CustomServiceException;
import com.luoyang.small.web.JsonResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 统一处理异常
 *
 * @author luoyang
 * @date 2023/12/17
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler
    public JsonResult handleServiceException(CustomServiceException e) {
        log.warn("统一处理CustomServiceException，异常信息：{}", e.getMessage());
        return JsonResult.fail(e);
    }
}
