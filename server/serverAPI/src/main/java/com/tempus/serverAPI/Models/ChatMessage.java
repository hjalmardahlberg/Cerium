package com.tempus.serverAPI.Models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Entity
public class ChatMessage {

    @Id
    @Column(name = "senderName")
    @NotNull
    private String senderName;

    @Column(name = "receiverGroup")
    @NotNull
    private String receiverGroup;
    @Column(name = "receiverGroupAdmin")
    @NotNull
    private String receiverGroupAdmin;
    @Column(name = "date")
    @NotNull
    private String date;

}
