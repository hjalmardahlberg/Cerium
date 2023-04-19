package com.tempus.serverAPI.Chat;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import javax.swing.*;
import java.util.Collections;

@SpringBootApplication(scanBasePackages = {"com.tempus.serverAPI"})
public class ChatServerApplication {



    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(ChatServerApplication.class);
        app.setDefaultProperties(Collections.singletonMap("server.port", "25565"));
        app.run(args);
    }
}
