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

    @PostMapping(value = "/save")
    public String saveUser(@RequestBody Users user) {
        userRepo.save(user);
        return "Saved user";
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
