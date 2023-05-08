package com.tempus.Chat.Service;

import com.tempus.Chat.Models.Message;
import com.tempus.Chat.Repo.MessageRepo;
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
        simpMessagingTemplate.convertAndSend("/topic/group/messages/"+groupName+"&"+adminEmail, msg);
    }

    public List<Message> fetchGroupMessages(String groupName, String adminEmail) {
        return messageRepo.findByReceiverGroupAndReceiverGroupAdmin(groupName, adminEmail);
    }
    public List<Message> fetchUserMessages(String groupName, String adminEmail, String user) {
        return messageRepo.findByReceiverGroupAndReceiverGroupAdminAndSenderName(groupName, adminEmail, user);
    }
}