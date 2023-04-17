package com.tempus.serverAPI.Chat.Controller;
import com.tempus.serverAPI.Repo.MessageRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;


// https://medium.com/@arisusantolie/spring-websocket-with-sockjs-using-database-mysql-or-mariadb-html-javascript-21da7d71d936

// https://www.youtube.com/watch?v=o_IjEDAuo8Y&t=2473s

// https://www.youtube.com/watch?v=4Hyv4M1kFeM




@Controller
public class ChatController {

    @Autowired
    private MessageRepo messageRepo;
}
