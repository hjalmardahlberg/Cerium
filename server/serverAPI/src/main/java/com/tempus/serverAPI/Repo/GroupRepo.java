package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.Groups;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GroupRepo extends JpaRepository<Groups, Long> {
}
