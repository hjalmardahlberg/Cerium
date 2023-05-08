package com.tempus.serverAPI.Models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Entity
public class Users {

    @Id
    @Column(name = "u_id")
    @NotNull
    private String id;

    @Column(name = "name")
    @NotNull
    private String name;
    @Column(name = "email", unique = true)
    @NotNull
    private String email;

    @Column(name = "latestSchedule")
    private String latestSchedule;

    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Groups> g_id = new ArrayList<Groups>();
    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Events> e_id = new ArrayList<Events>();
    //@Transient
    @Column(name = "image")
    private String image;


    public String getId() {
        return id;
    }

    public void setId(String id) {
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

    public List<Events> getEvents() {
        return e_id;
    }

    public List<Groups> getGroup(String groupName) {
        List<Groups> toReturn = new ArrayList<>();
        for (int i = 0; i < this.g_id.size(); i++ ) {
            Groups currGroup = this.g_id.get(i);
            if(currGroup.getName().equals(groupName)) {
                toReturn.add(currGroup);
            }
        }
        return toReturn;
    }

    public Boolean alreadyInGroup(String groupName) {
        for (int i = 0; i < this.g_id.size(); i++ ) {
            Groups currGroup = this.g_id.get(i);
            if(currGroup.getName().equals(groupName)){
                return true;
            }
        }
        return false;
    }

    public void setGroups(List<Groups> groups) {
        this.g_id = groups;
    }

}
