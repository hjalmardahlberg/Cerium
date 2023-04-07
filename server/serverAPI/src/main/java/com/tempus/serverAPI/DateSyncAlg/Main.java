package com.tempus.serverAPI.DateSyncAlg;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Main {
    public static void main(String[] args) {
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS'Z'");
       
        /* Vi kommer egentligen få in data i formatet "yyyy-MM-dd HH:mm:ss.SSS'Z'" från DB som vi sedan inom
         * Event classen kommer att konvertera till LocalDateTime
         * Därmed måste man komma ihåg att konvertera tillbaka till vårat format
         * när vi returnerar resultatet
         */

        LocalDateTime date_7 = LocalDateTime.of(1999, 12, 24, 13, 8, 0);
        LocalDateTime date_8 = LocalDateTime.of(1999, 12, 24, 13, 50, 0);

        LocalDateTime date_5 = LocalDateTime.of(1999, 12, 24, 13, 13, 0);
        LocalDateTime date_6 = LocalDateTime.of(1999, 12, 24, 19, 14, 0);
        
        LocalDateTime date_1 = LocalDateTime.of(1999, 12, 24, 13, 15, 0);
        LocalDateTime date_2 = LocalDateTime.of(1999, 12, 24, 14, 16, 0);
        
        LocalDateTime date_3 = LocalDateTime.of(1999, 12, 24, 14, 15, 0);
        LocalDateTime date_4 = LocalDateTime.of(1999, 12, 24, 17, 17, 0);
        
        LocalDateTime date_17  = LocalDateTime.of(1999, 12, 25, 3, 50, 0);
        LocalDateTime date_18 = LocalDateTime.of(1999, 12, 25, 6, 50, 0);

        LocalDateTime date_9  = LocalDateTime.of(1999, 12, 25, 9, 50, 0);
        LocalDateTime date_10 = LocalDateTime.of(1999, 12, 25, 10, 50, 0);

        LocalDateTime date_11 = LocalDateTime.of(1999, 12, 25, 11, 50, 0);
        LocalDateTime date_12 = LocalDateTime.of(1999, 12, 25, 13, 50, 0);

        LocalDateTime date_13 = LocalDateTime.of(1999, 12, 25, 13, 51, 0);
        LocalDateTime date_14 = LocalDateTime.of(1999, 12, 25, 13, 59, 0);

        LocalDateTime date_15 = LocalDateTime.of(1999, 12, 26, 13, 50, 0);
        LocalDateTime date_16 = LocalDateTime.of(1999, 12, 26, 14, 50, 0);

        //Skapar alla event med de skapade datumen och konverterar om till vårat format
        Event e_1 = new Event("e1", date_1.format(formatter), date_2.format(formatter)); 
        Event e_2 = new Event("e2", date_3.format(formatter), date_4.format(formatter));
        Event e_3 = new Event("e3", date_5.format(formatter), date_6.format(formatter));
        Event e_4 = new Event("e4", date_7.format(formatter), date_8.format(formatter));
        Event e_5 = new Event("e5", date_9.format(formatter), date_10.format(formatter));
        Event e_6 = new Event("e6", date_11.format(formatter), date_12.format(formatter));
        Event e_7 = new Event("e7", date_13.format(formatter), date_14.format(formatter));
        Event e_8 = new Event("e8", date_15.format(formatter), date_16.format(formatter));
        Event e_9 = new Event("e9", date_17.format(formatter), date_18.format(formatter));


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

        lesgo.sortDates(); //Sorterar listan

        lesgo.pickPossDates(); // Väljer ut bästa tider


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