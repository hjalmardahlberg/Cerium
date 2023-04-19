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

    public Event(String startTime, String endTime) {
        LocalDateTime s_time = LocalDateTime.parse(startTime, formatter);
        LocalDateTime e_time = LocalDateTime.parse(endTime, formatter);
        /*
        LocalDateTime s_time = LocalDateTime.parse(startTime);
        LocalDateTime e_time = LocalDateTime.parse(endTime); */
        this.startTime = s_time;
        this.endTime = e_time;
    }


    public void TheSuperReasonableIntervalChecker(String start_hour, String end_hour){ // kör på eventet vi vill kolla
        //Detta suger kuk, lägg in ett nytt event som börjar på endtime och slutar på start time, så att vi får kollisioner om något event gåt utanför intervalet
        LocalDateTime start = this.startTime; // tar ner start
        LocalDateTime end = this.endTime; // tar ner end

        LocalDate start_to_localdate = start.toLocalDate(); //gör om till LocalDate
        LocalDate end_to_localdate = end.toLocalDate();

        LocalTime start_hour_in_localtimeObj = LocalTime.parse(start_hour); // sätter om timmen till den start_timme som angivits, nu kan vi använda isBefore
        LocalTime end_hour_in_localtimeObj = LocalTime.parse(end_hour); // sätter om timmen till den end_timme som angivits, nu kan vi använda isAfter

        LocalDateTime start_timePlusStart_hour = start_to_localdate.atTime(start_hour_in_localtimeObj); // gör om tillbaka till LocalDateTime
        LocalDateTime end_timePlusStart_hour = end_to_localdate.atTime(end_hour_in_localtimeObj);

        System.out.print(this.startTime + "\n");
        System.out.print(start_timePlusStart_hour + "\n");

        System.out.print(this.endTime + "\n");
        System.out.print(end_timePlusStart_hour + "\n");

        if (start.isBefore(start_timePlusStart_hour)){ //om tiden i eventet är innan den givna tiden sätt den till den nya
            this.startTime = start_timePlusStart_hour;
            System.out.print(this.startTime);
            System.out.print(start_timePlusStart_hour);

        }

        if (start.isAfter(start_timePlusStart_hour)){ // om eventet tex börjar 20

        }
        if (end.isAfter(end_timePlusStart_hour)){
            this.endTime = end_timePlusStart_hour;
            System.out.print(this.endTime);
            System.out.print(end_timePlusStart_hour);

        }
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