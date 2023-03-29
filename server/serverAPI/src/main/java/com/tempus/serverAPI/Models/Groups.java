package com.tempus.serverAPI.Models;

import com.tempus.serverAPI.Models.Users;
import jakarta.persistence.*;

import java.util.List;
import java.util.Set;

@Entity
public class Groups {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;

  @ElementCollection
  private Set<Long> user_ids;



}
