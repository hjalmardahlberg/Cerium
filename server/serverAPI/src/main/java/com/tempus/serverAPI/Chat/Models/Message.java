package com.tempus.serverAPI.Chat.Models;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Message {
    private String senderName;
    private String receiverGroup;
    private String receiverGroupAdmin;
    private String date;

    private Status status;
}
