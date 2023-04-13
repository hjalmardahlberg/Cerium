package com.tempus.serverAPI.Models;

import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.ToString;


//Icke-persistent data, kommer bara tas in som ett JSON-objekt från klienten

@AllArgsConstructor
@NoArgsConstructor
@ToString
public class UserSchedule {

    private String start;
    private String end;

    public String getStart() {
        return start;
    }

    public String getEnd() {
        return end;
    }
    //TODO: En ny datastruktur som tar hänsyn till google calendars datastruktur som t.ex veckodagar och schemalagda objekt
    //TODO: Fixa en metod som plockar ut alla tider som en användare inte har något schemalagt på dagen
}
