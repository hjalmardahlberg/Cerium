package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.Events;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EventRepo extends JpaRepository<Events, Long> {

    List<Events> findByName(String name);
}
