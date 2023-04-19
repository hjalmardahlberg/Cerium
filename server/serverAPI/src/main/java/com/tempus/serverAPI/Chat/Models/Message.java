package com.tempus.serverAPI.Chat.Models;

import com.tempus.serverAPI.Models.ChatMessage;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Message extends ChatMessage {
    private String senderName;
    private String receiverGroup;
    private String receiverGroupAdmin;
    private String date;

}
