package com.tempus.serverAPI.DateSyncAlg;

import com.tempus.serverAPI.Models.Events;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class Datesync {
    final List<Event> listofdates = new ArrayList<>(); // Listan av alla events, kommer sedan bli sorterad

    public List<Event> possDates = new ArrayList<>(); // Listan som innehåller de tider utan konflikter


    //lägger till alla event i listan
    public void setDateSyncLst(List<Event> Event)
    {
        this.listofdates.addAll(Event);
    }

    // Sorterar listan i "tids"-ordning
    public void sortDates()
    {
        listofdates.sort(new Comparator<Event>() {
            @Override
            public int compare(Event o1, Event o2) {
                return o1.getStartTime().compareTo(o2.getStartTime());
            }
        });
    }

    public String printList()
    {
        return this.listofdates.toString();
    }

    public void isInInterval(Event event_to_add, LocalDateTime interval_start, LocalDateTime interval_end){

        if (!event_to_add.getEndTime().isBefore(interval_start) || !event_to_add.getStartTime().isAfter(interval_start)){

            if (event_to_add.getStartTime().isBefore(interval_start)){

                event_to_add.setStartTime(interval_start);
            }
            if (event_to_add.getEndTime().isAfter(interval_end)){

                event_to_add.setEndTime(interval_end);
            }

            possDates.add(event_to_add);
        }
    }

    public void pickPossDates(String ItvStart, String ItvEnd)
    {
        LocalDateTime curr_latest_end_time = listofdates.get(0).getEndTime(); // sparar den nuvarande senaste endTime
        Long diff_form_latest = 0L;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");

        LocalDateTime Itv_Date_s = LocalDateTime.parse(ItvStart, formatter);
        LocalDateTime Itv_Date_e = LocalDateTime.parse(ItvEnd, formatter);

        for(int i = 0; i < listofdates.size() - 1; i++) // iterera över events
        {
            System.out.println("CURR LATEST:" + curr_latest_end_time.toString()+"\n");
            Event e1 = listofdates.get(i);
            Event e2 = listofdates.get(i + 1);
            
            Duration duration = Duration.between(e1.getEndTime(), e2.getStartTime()); // kolla tids diff mellan eventen om < 0 kollision
            System.out.println(e1.toOurFormat(e1.getEndTime()) + " <--> " + e2.toOurFormat(e2.getStartTime()));

            System.out.println("DURATION: " + duration.toMinutes());
                
            if(duration.toSeconds() > 0){
                diff_form_latest = Duration.between(curr_latest_end_time, e1.getEndTime()).toSeconds(); // kolla om ett event är "inuti" ett annat
                if(diff_form_latest > 0) //om > 0 vet vi att det eventet vi kollar på är det senaste 
                {
                    //curr_latest_end_time = e1.getEndTime();
                    Event eventToAdd = new Event(e1.getEndTime().format(formatter),e2.getStartTime().format(formatter));
                    isInInterval(eventToAdd, Itv_Date_s, Itv_Date_e);
                }
                else // om < 0 vet vi att vi har ett event som slutar efter det vi kollar på och vi vill då lägga till tiden mellan att det senaste slutar och det andra startar
                {
                    duration = Duration.between(curr_latest_end_time, e2.getStartTime());
                    Event eventToAdd = new Event(curr_latest_end_time.format(formatter),e2.getStartTime().format(formatter));
                    isInInterval(eventToAdd, Itv_Date_s, Itv_Date_e);

                } // vi vill alltid ha det senaste slutdatumet
            }
            if(Duration.between(curr_latest_end_time, e1.getEndTime()).toSeconds() > 0){
                curr_latest_end_time = e1.getEndTime();
            }
        }
    }
}
