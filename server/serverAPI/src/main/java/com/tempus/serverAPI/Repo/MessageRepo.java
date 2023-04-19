package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MessageRepo extends JpaRepository<ChatMessage, String> {
    List<ChatMessage> findByReceiverGroupAndReceiverGroupAdmin(String receiverGroup, String receiverGroupAdmin);

    List<ChatMessage> findByReceiverGroupAndReceiverGroupAdminAndSenderName(String receiverGroup, String receiverGroupAdmin, String senderName);
}
