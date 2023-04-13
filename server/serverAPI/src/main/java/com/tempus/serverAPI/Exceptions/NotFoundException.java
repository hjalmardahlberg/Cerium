package com.tempus.serverAPI.Exceptions;

public class NotFoundException extends RuntimeException{

    public NotFoundException(String msg) {
        super("Not found: " + msg);
    }
}
