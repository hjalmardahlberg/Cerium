package com.tempus.serverAPI.Models;

import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

//Detta ska nog vara en persistent entity som ska ha ett eget table etc. Inte riktigt säker än.
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class GroupSchedule {

    private String u_id;
    private List<UserSchedule> schedules = new ArrayList<>();

    public String getU_id() {
        return u_id;
    }

    public List<UserSchedule> getSchedules() {
        return schedules;
    }



}

