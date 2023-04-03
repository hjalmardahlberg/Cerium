package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.Events;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EventRepo extends JpaRepository<Events, Long> {


}
