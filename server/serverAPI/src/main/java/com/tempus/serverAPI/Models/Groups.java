package com.tempus.serverAPI.Models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;


@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Entity
public class Groups {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "g_id")
  private long g_id;

  @Column(name = "name")
  private String name;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "u_id")
  @JsonIgnore
  private Users user;

  @Column(name = "owner")
  private String admin;


  public long getId() {

    return g_id;
  }
  public void setId(long id) {

    this.g_id = id;
  }

  public String getName() {
    return name;
  }

  public Users getUser() {
    return user;
  }



}
