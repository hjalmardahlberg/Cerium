package com.tempus.serverAPI.DateSyncAlg;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Main {
    public static void main(String[] args) {

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");


        /* Vi kommer egentligen få in data i formatet "yyyy-MM-dd HH:mm:ss.SSS'Z'" från DB som vi sedan inom
         * Event classen kommer att konvertera till LocalDateTime
         * Därmed måste man komma ihåg att konvertera tillbaka till vårat format
         * när vi returnerar resultatet
         */

        String date_8 = "2023-04-01T13:00:00.000";
        String date_7 = "2023-04-01T14:00:00.000";

        String date_5 = "2023-04-01T10:00:00.000";
        String date_6 = "2023-04-01T12:00:00.000";
        
        String date_1 = "2023-04-01T11:00:00.000";
        String date_2 = "2023-04-01T13:30:00.000";
        
        String date_3 = "2023-04-01T17:00:00.000";
        String date_4 = "2023-04-01T19:00:00.000";
        
        String date_17 = "2023-04-01T16:00:00.000";
        String date_18 = "2023-04-01T18:00:00.000";

        String date_9  ="2023-04-01T19:10:00.000";
        String date_10 ="2023-04-01T20:00:00.000";

        String date_11 ="2023-04-02T13:00:00.000";
        String date_12 ="2023-04-02T14:00:00.000";

        String date_13 ="2023-04-02T13:30:00.000";
        String date_14 ="2023-04-02T15:00:00.000";

        String date_15 ="2023-04-02T16:00:00.000";
        String date_16 ="2023-04-02T17:00:00.000";



        //Skapar alla event med de skapade datumen och konverterar om till vårat format
        Event e_1 = new Event(date_1, date_2);
        Event e_2 = new Event( date_3, date_4);
        Event e_3 = new Event(date_5, date_6);
        Event e_4 = new Event(date_8, date_7);
        Event e_5 = new Event(date_9, date_10);
        Event e_6 = new Event(date_11, date_12);
        Event e_7 = new Event(date_13, date_14);
        Event e_8 = new Event(date_15, date_16);
        Event e_9 = new Event(date_17, date_18);


        List<Event> lst = new ArrayList<>();
        lst.add(e_1);
        lst.add(e_3);
        lst.add(e_4);
        lst.add(e_2);
        lst.add(e_8);
        lst.add(e_5);
        lst.add(e_7);
        lst.add(e_6);
        lst.add(e_9);


        Datesync lesgo = new Datesync();
        lesgo.setDateSyncLst(lst);
        String haha1 = "2023-04-01T03:00:00.000";
        String haha2 = "2023-04-03T04:00:00.000";

        Event haha_event = new Event(haha1, haha2);

        //LocalDateTime D1 = LocalDateTime.parse(haha1,formatter);
        //LocalDateTime D2 = LocalDateTime.parse(haha2,formatter);

        System.out.print("here?" + "\n");


        lesgo.addDateBuffer("2023-04-01T03:00:00.000", "2023-04-03T04:00:00.000");

        lesgo.sortDates(); //Sorterar listan

        lesgo.pickPossDates("2023-04-01T08:00:00.000","2023-04-03T18:00:00.000"); // Väljer ut bästa tider


        System.out.println("\n" + lesgo.listofdates+"\n");
        System.out.println(lesgo.possDates);

        // System.out.println(lesgo.listofdates);

        // lesgo.sortDates();
        
        // System.out.println(lesgo.listofdates);


        // System.out.println(date_1.format(formatter) + "  " + date_2.format(formatter));
        // System.out.println(e_1);
        // System.out.println(e_1.toOurString());
        

        // String formattedDate = date_1.format(formatter);
        // System.out.println(formattedDate);



        // Date date_1 = new Date(71,0,6, 16, 00);
        // Date date_2 = new Date(71,0,6, 16, 30);

        // Date date_3 = new Date(71,0,7, 13, 43);
        // Date date_4 = new Date(71,0,7, 15,59);

        // Date date_5 = new Date(71,0,8, 9,45);
        // Date date_6 = new Date(71,0,8, 12, 56);

        // Date date_7 = new Date(71,0,7, 13, 8);
        // Date date_8 = new Date(71,0,7, 13, 50);

        // Event e_2 = new Event(date_3, date_4);
        // Event e_1 = new Event(date_1, date_2);
        // Event e_4 = new Event(date_7, date_8);
        // Event e_3 = new Event(date_5, date_6);

        // Datesync lesgo = new Datesync();
        // List<Event> e = new ArrayList<>();
        // e.add(e_2);
        // e.add(e_3);
        // e.add(e_1);
        // e.add(e_4);

        // lesgo.setdatesync(e);

        // System.out.println(lesgo.listofdates);

        // lesgo.sortDates();
        // System.out.println(lesgo.listofdates);

        // lesgo.pickdate();
        // System.out.println(lesgo.possTimes);

    }
}