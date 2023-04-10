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
public class GoogleEvent {

    @Id
    @Column(name = "u_id")
    @NotNull
    private String u_id;

    @Column(name = "start")
    @NotNull
    private String start;

    @Column(name = "end")
    @NotNull
    private String end;



}
