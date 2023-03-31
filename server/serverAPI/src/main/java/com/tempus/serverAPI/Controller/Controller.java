package com.tempus.serverAPI.Controller;

import com.tempus.serverAPI.Models.Users;
import com.tempus.serverAPI.Models.Groups;
import com.tempus.serverAPI.Repo.GroupRepo;
import com.tempus.serverAPI.Repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
public class Controller {

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private GroupRepo groupRepo;
    @GetMapping(value = "/")
    public String getPage(){
        return "test";
    }

    @GetMapping(value = "/users")
    public List<Users> getUsers() {

        return userRepo.findAll();
    }


    @GetMapping(value = "/user/{id}/groups")
    public List<Groups> getUserGroups(@PathVariable long id) {
        Users user = userRepo.findById(id).get();
        return user.getGroups();
    }


    @PostMapping(value = "/save")
    public String saveUser(@RequestBody Users user) {
        userRepo.save(user);
        return "Saved user";
    }

    @PutMapping(value = "/group/create/{g_name}/{id}")
    public String createGroup(@PathVariable String g_name, @PathVariable long id, @RequestBody Users user) {

        Users updatedUser = userRepo.findById(id).get();
        Groups gCreate = new Groups();
        gCreate.setName(g_name);
        gCreate.setUser(updatedUser);
        user.getGroups().add(gCreate);
        groupRepo.save(gCreate);
        userRepo.save(updatedUser);
        return "Created a group with the ID: " + gCreate.getId() + "to the user: " + updatedUser.getName();
    }




    @PutMapping(value = "/user/{u_id}/group/join/{g_name}")
    public String joinGroup(@PathVariable long u_id,@PathVariable String g_name, @RequestBody Users user) {

        Users userJoin = userRepo.findById(u_id).get();
        Groups groupToJoin = new Groups();
        if(groupToJoin != null) {
            groupToJoin.setUser(userJoin);
            groupToJoin.setName(g_name);
            user.getGroups().add(groupToJoin);
            groupRepo.save(groupToJoin);
            userRepo.save(userJoin);
        }

        return "Sucessfully joined the group: " + groupToJoin.getName();
    }

    @PutMapping(value = "/update/{id}")
    public String updateUser(@PathVariable long id, @RequestBody Users user) {
        Users updatedUser = userRepo.findById(id).get();
        updatedUser.setName(user.getName());
        updatedUser.setEmail(user.getEmail());
        userRepo.save(updatedUser);
        return "Updated user info";
    }

    @DeleteMapping(value = "/delete/{id}")
    public String delUser(@PathVariable long id) {
        Users delUser = userRepo.findById(id).get();
        userRepo.delete(delUser);
        return "Deletion complete, r for retard the way im getting this dumb money";
    }


}
