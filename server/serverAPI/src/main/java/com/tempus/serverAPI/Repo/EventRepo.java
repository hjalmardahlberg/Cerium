package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.Events;
import com.tempus.serverAPI.Models.Groups;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EventRepo extends JpaRepository<Events, Long> {

    List<Events> findByName(String event_name);

    Events findByNameAndGroup(String event_name, Groups group);

    List<Events> findByGroup(Groups g_id);
}
