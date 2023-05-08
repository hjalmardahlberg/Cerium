package com.tempus.Chat.Controller;
import com.tempus.Chat.Greeting;
import com.tempus.Chat.Models.Message;
import com.tempus.Chat.Service.ChatService;
import com.tempus.Chat.Repo.MessageRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;


import java.util.List;


// https://medium.com/@arisusantolie/spring-websocket-with-sockjs-using-database-mysql-or-mariadb-html-javascript-21da7d71d936

// https://www.youtube.com/watch?v=o_IjEDAuo8Y&t=2473s

//




@Controller
@RestController
@CrossOrigin
public class ChatController {

    @Autowired
    MessageRepo messageRepo;

    @Autowired
    ChatService chatService;

    @MessageMapping("/chat/group/{g_name}&{a_email}")
    public void sendMessageToGroup(@DestinationVariable String g_name, @DestinationVariable String a_email, Message msg) {
        chatService.sendMessage(g_name, a_email, msg);
        messageRepo.save(msg);
    }

    @GetMapping(value = "/testgreet")
    public String testGreet() {
        return "Hello, World!";
    }

    @GetMapping("/chat/group/messages/{g_name}&{a_email}")
    public List<Message> getMessages(@PathVariable String g_name, @PathVariable String a_email) {
        return chatService.fetchGroupMessages(g_name, a_email);
    }



}
