package com.tempus.serverAPI.Models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
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
    private String id;
    @Column(name = "name")
    private String name;
    @Column(name = "email")
    private String email;
    @Transient
    private Boolean joinFlag = false;

    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    //@JoinColumn(name = "uid_fk", referencedColumnName = "id") // här refererar vi till grupp-tabellen. Vi kommer få en till kolonn i Group-tabellen som heter uid_fk som pekar på användarens id. Vi slipper då att använda en till tabell.
    private List<Groups> g_id = new ArrayList<Groups>();


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

    public Groups getGroup(String groupName) {
        for (int i = 0; i < this.g_id.size(); i++ ) {
            Groups currGroup = this.g_id.get(i);
            if(currGroup.getName().equals(groupName)){
                return currGroup;
            }
        }
        throw new RuntimeException("Unable to find group with given name!");
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
