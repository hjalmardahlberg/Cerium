package com.tempus.serverAPI.Chat.Service;

import com.tempus.serverAPI.Chat.Models.Message;
import com.tempus.serverAPI.Models.ChatMessage;
import com.tempus.serverAPI.Repo.MessageRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import java.util.List;

@Service
public class ChatService {

    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @Autowired
    MessageRepo messageRepo;

    public void sendMessage(String groupName, String adminEmail, Message msg) {
        messageRepo.save(msg);
        simpMessagingTemplate.convertAndSend("/group/messages/"+groupName+"&"+adminEmail, msg);
    }

    public List<ChatMessage> fetchGroupMessages(String groupName, String adminEmail) {
        return messageRepo.findByReceiverGroupAndReceiverGroupAdmin(groupName, adminEmail);
    }
    public List<ChatMessage> fetchUserMessages(String groupName, String adminEmail, String user) {
        return messageRepo.findByReceiverGroupAndReceiverGroupAdminAndSenderName(groupName, adminEmail, user);
    }
}
