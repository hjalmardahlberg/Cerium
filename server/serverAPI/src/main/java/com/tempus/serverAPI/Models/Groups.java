package com.tempus.serverAPI.Models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.tempus.serverAPI.Models.Users;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Entity
public class Groups {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "g_id")
  private long id;

  @Column(name = "name")
  private String name;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "u_id")
  @JsonIgnore
  private Users user;

  public long getId() {

    return id;
  }
  public void setId(long id) {

    this.id = id;
  }

  public String getName() {
    return name;
  }

  public Users getUser() {
    return user;
  }



}
