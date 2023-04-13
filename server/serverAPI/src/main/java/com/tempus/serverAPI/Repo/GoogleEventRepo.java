package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.GoogleEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface GoogleEventRepo extends JpaRepository<GoogleEvent, String> {

    List<GoogleEvent> findByUserid(String userid);
}
