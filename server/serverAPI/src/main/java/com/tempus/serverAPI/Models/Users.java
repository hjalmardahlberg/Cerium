package com.tempus.serverAPI.Models;

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
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column(name = "name")
    private String name;
    @Column(name = "email")
    private String email;


    @OneToMany(targetEntity = Groups.class,cascade = CascadeType.ALL)
    @JoinColumn(name = "uid_fk", referencedColumnName = "id") // här refererar vi till grupp-tabellen. Vi kommer få en till kolonn i Group-tabellen som heter uid_fk som pekar på användarens id. Vi slipper då att använda en till tabell.
    private List<Groups> g_id = new ArrayList<Groups>();


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

    public List<Groups> getGroups(){
        return g_id;
    }

    public void setGroups(List<Groups> groups) {
        this.g_id = groups;
    }

}
