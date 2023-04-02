package com.tempus.serverAPI.Repo;

import com.tempus.serverAPI.Models.Users;
import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

//@EnableJpaRepositories
public interface UserRepo extends JpaRepository<Users, Long>{
}

