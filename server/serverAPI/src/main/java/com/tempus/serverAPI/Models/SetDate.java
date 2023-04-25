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

    private String Start_Date;
    private String End_Date;
    private Long MeetDuration;
    private String Start_Hour;
    private String End_hour;


    public String getStart_Date() {
        return Start_Date;
    }

    public String getEnd_Date() {
        return End_Date;
    }

    public Long getDuration() {
        return MeetDuration;
    }

    public String getStart_Hour() {
        return Start_Hour;
    }

    public String getEnd_hour() {
        return End_hour;
    }

}
