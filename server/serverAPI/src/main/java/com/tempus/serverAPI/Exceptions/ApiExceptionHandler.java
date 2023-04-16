package com.tempus.serverAPI.Exceptions;


import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.time.ZoneId;
import java.time.ZonedDateTime;

@ControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(value = {ApiException.class})
    public ResponseEntity<Object> handleApiException(ApiException e) {
        NotFoundException notFound = new NotFoundException(e.getMessage(), e, HttpStatus.NOT_FOUND, ZonedDateTime.now(ZoneId.of("Z")));
        return new ResponseEntity<>(notFound, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(value = {ApiForbiddenException.class})
    public ResponseEntity<Object> handleForbiddenApiException(ApiForbiddenException e) {
        ForbiddenException forbidden = new ForbiddenException(e.getMessage(), e, HttpStatus.BAD_REQUEST, ZonedDateTime.now(ZoneId.of("Z")));
        return new ResponseEntity<>(forbidden, HttpStatus.BAD_REQUEST);
    }
}
