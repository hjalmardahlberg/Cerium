package com.tempus.serverAPI.Models;

import lombok.*;
import org.springframework.cglib.core.Local;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class SetDate {

    private String start_Date;
    private String end_Date;
    private Long meetDuration;
    private String start_Hour;
    private String end_Hour;


    public String getStart_Date() {
        return start_Date;
    }

    public String getEnd_Date() {
        return end_Date;
    }

    public Long getDuration() {
        return meetDuration;
    }

    public String getStart_Hour() {
        return start_Hour;
    }

    public String getEnd_hour() {
        return end_Hour;
    }

}
