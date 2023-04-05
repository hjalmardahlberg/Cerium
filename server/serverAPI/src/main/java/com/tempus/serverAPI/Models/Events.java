package com.tempus.serverAPI.Models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

//
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Entity
public class Events {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "e_id")
    private long id;

    @Column(name = "event_name")
    private String name;

    @Column(name = "date")
    private String date;

    @Column(name = "start")
    private String start_time;

    @Column(name = "end")
    private String end_time;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "g_id")
    @JsonIgnore
    private Groups group;



    //TODO: Lägg till mer fält
}
