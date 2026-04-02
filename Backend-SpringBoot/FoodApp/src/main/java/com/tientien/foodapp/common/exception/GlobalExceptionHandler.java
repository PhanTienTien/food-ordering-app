package com.tientien.foodapp.common.exception;

import com.tientien.foodapp.common.response.ApiResponse;
import org.springframework.web.bind.annotation.*;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(AppException.class)
    public ApiResponse<?> handleAppException(AppException ex) {
        return ApiResponse.builder()
                .success(false)
                .message(ex.getMessage())
                .build();
    }

    @ExceptionHandler(Exception.class)
    public ApiResponse<?> handleException(Exception ex) {
        return ApiResponse.builder()
                .success(false)
                .message("Internal Server Error")
                .build();
    }
}