package com.tempus.serverAPI.Models;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.cglib.core.Local;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
public class SetDate {

    private LocalDateTime Start_Date;
    private LocalDateTime End_Date;
    private Duration MeetDuration;
    private LocalTime Start_Hour;
    private LocalTime End_hour;


    public LocalDateTime getStart_Date() {
        return Start_Date;
    }

    public LocalDateTime getEnd_Date() {
        return End_Date;
    }

    public Duration getDuration() {
        return MeetDuration;
    }

    public LocalTime getStart_Hour() {
        return Start_Hour;
    }

    public LocalTime getEnd_hour() {
        return End_hour;
    }

}
