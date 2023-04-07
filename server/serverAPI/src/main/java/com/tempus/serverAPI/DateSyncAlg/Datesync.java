package com.tempus.serverAPI.DateSyncAlg;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;

public class Datesync {
    final List<Event> listofdates = new ArrayList<>(); // Listan av alla events, kommer sedan bli sorterad

    public List<String> possDates = new ArrayList<>(); // Listan som innehåller de tider utan konflikter

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

    public void pickPossDates()
    {
        LocalDateTime curr_latest_end_time = listofdates.get(0).getEndTime(); // sparar den nuvarande senaste endTime
        Long diff_form_latest = 0L;

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
                    this.possDates.add(e1.getEndTime().toString() + " - " + e2.getStartTime().toString() + "  (" + duration.toMinutes() + " min)");
                }
                else // om < 0 vet vi att vi har ett event som slutar efter det vi kollar på och vi vill då lägga till tiden mellan att det senaste slutar och det andra startar
                {
                    duration = Duration.between(curr_latest_end_time, e2.getStartTime());
                    this.possDates.add(curr_latest_end_time.toString() + " - " + e2.getStartTime().toString() + "  (" + duration.toMinutes() + " min)");

                } // vi vill alltid ha det senaste slutdatumet
            }
            if(Duration.between(curr_latest_end_time, e1.getEndTime()).toSeconds() > 0){
                curr_latest_end_time = e1.getEndTime();
            }
        }
    }
}
