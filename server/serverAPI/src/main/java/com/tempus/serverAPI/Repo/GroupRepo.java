package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.Groups;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface GroupRepo extends JpaRepository<Groups, Long> {

    List<Groups> findByName(String name);

    List<Groups> findByNameAndAdmin(String name, String admin);




}
