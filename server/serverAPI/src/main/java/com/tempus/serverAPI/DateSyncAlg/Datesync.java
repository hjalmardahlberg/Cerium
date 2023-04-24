package com.tempus.serverAPI.DateSyncAlg;

import com.tempus.serverAPI.Models.Events;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class Datesync {
    public List<Event> findFreeSpots(List<Event> events, LocalDateTime start, LocalDateTime end, Duration minDuration, LocalTime ItvHoursStart, LocalTime ItvHoursEnd) {
        List<Event> freeSpots = new ArrayList<>();

        // iterera över varje dag
        LocalDate currentDate = start.toLocalDate();
        while (!currentDate.isAfter(end.toLocalDate())) {
            LocalDateTime currentDateTime = LocalDateTime.of(currentDate, ItvHoursStart);

            // iterera över varje timme för de valda timintervalet för varje dag
            while (!currentDateTime.toLocalTime().isAfter(ItvHoursEnd)) {
                LocalDateTime nextDateTime = currentDateTime.plus(minDuration);

                // kolla om något överlappar
                boolean overlap = false;
                for (Event event : events) {
                    if ((event.getStart().isBefore(nextDateTime) && event.getEnd().isAfter(currentDateTime))
                            || (event.getStart().isEqual(currentDateTime) || event.getEnd().isEqual(nextDateTime))) {
                        overlap = true;
                        break;
                    }
                }

                // om inga överlappar lägg till
                if (!overlap && currentDateTime.isAfter(start) && nextDateTime.isBefore(end)) {
                    freeSpots.add(new Event(currentDateTime, nextDateTime));
                }

                currentDateTime = nextDateTime;
            }

            currentDate = currentDate.plusDays(1);
        }

        return freeSpots;
    }
}


