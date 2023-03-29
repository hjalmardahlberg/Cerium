package com.tempus.serverAPI.Models;

import jakarta.persistence.*;

import java.util.Set;


@Entity
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column(name = "name")
    private String name;
    @Column(name = "email")
    private String email;

    @ElementCollection //FIXME: Ska inte vara element collection (tror jag)
    private Set<Long> user_id;

    @ElementCollection //FIXME: Ska inte vara element collection (tror jag)
    private Set<Long> group_id;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


}
