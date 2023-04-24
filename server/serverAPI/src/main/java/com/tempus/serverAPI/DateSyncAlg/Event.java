package com.tempus.serverAPI.DateSyncAlg;


import org.springframework.cglib.core.Local;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;


public class Event {
    private LocalDateTime startTime;
    private LocalDateTime endTime;

    final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");

    public Event(LocalDateTime startTime, LocalDateTime endTime) {

        this.startTime = startTime;
        this.endTime = endTime;
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

    public LocalDateTime getStart() {
        return startTime;
    }

    public LocalDateTime getEnd() {
        return endTime;
    }
}


