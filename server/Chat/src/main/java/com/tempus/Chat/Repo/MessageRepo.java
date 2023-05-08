package com.tempus.Chat.Repo;

import com.tempus.Chat.Models.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MessageRepo extends JpaRepository<Message, Long> {
    List<Message> findByReceiverGroupAndReceiverGroupAdmin(String receiverGroup, String receiverGroupAdmin);

    List<Message> findByReceiverGroupAndReceiverGroupAdminAndSenderName(String receiverGroup, String receiverGroupAdmin, String senderName);
}