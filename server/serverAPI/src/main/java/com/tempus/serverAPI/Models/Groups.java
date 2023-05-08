package com.tempus.serverAPI.Models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.ArrayList;
import java.util.List;


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
  @NotNull
  private String name;

  @ManyToOne(fetch = FetchType.EAGER)
  @JoinColumn(name = "u_id")
  @JsonIgnore
  private Users user;

  @Column(name = "owner")
  private String admin;

  @Column(name = "image")
  private String image;

  @Column(name = "adminusername")
  private String adminusername;

  /*
  @Transient
  private List<String> userID = new ArrayList<>(); */


  @OneToMany(mappedBy = "group",cascade = CascadeType.ALL, orphanRemoval = true)
  @OnDelete(action = OnDeleteAction.CASCADE)
  @JsonIgnore
  private List<Events> events = new ArrayList<Events>();

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