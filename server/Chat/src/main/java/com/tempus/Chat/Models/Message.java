package com.tempus.Chat.Models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Data
@Entity
public class Message {
    @Id
    @Column(name = "senderName")
    private String senderName;

    @Column(name = "receiverGroup")
    private String receiverGroup;

    @Column(name = "receiverGroupAdmin")
    private String receiverGroupAdmin;

    @Column(name = "message")
    private String message;

    @Column(name = "date")
    private String date;

}