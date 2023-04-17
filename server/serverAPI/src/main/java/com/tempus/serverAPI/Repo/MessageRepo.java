package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MessageRepo extends JpaRepository<ChatMessage, String> {

}
