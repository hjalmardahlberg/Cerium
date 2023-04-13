package com.tempus.serverAPI.Exceptions;

public class UserNotFoundException extends RuntimeException{

    public UserNotFoundException() {
        super("Error when processing the request, user does not exist");
    }

}
