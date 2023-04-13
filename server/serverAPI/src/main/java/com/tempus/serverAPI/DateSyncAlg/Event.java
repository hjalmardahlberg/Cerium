package com.tempus.serverAPI.DateSyncAlg;


import org.springframework.cglib.core.Local;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


public class Event {
    private LocalDateTime startTime;
    private LocalDateTime endTime;

    private DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
;
    public Event(String startTime, String endTime) {
        LocalDateTime s_time = LocalDateTime.parse(startTime, formatter);
        LocalDateTime e_time = LocalDateTime.parse(endTime, formatter);
        /*
        LocalDateTime s_time = LocalDateTime.parse(startTime);
        LocalDateTime e_time = LocalDateTime.parse(endTime); */
        this.startTime = s_time;
        this.endTime = e_time;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }




    @Override
    public String toString() 
    {
        return this.startTime + "  " + this.endTime;
    }

    public String toOurFormat(LocalDateTime date)
    {
        return date.format(formatter);
    }

    public String toOurString(){
        return this.startTime.format(formatter) + "  " + this.endTime.format(formatter);
    }

}