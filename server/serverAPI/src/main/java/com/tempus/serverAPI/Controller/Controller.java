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

    @PutMapping(value = "/group/create/{g_name}/{u_id}")
    public String createGroup(@PathVariable String g_name, @PathVariable long u_id, @RequestBody Users user) {

        if (groupRepo.findByName(g_name).isEmpty() || user.getJoinFlag()) {
            Users updatedUser = userRepo.findById(u_id).get();
            Groups gCreate = new Groups();
            gCreate.setName(g_name);
            gCreate.setUser(updatedUser);
            user.getGroups().add(gCreate);
            groupRepo.save(gCreate);
            userRepo.save(updatedUser);
            return "Created a group with the ID: " + gCreate.getId() + "to the user: " + updatedUser.getName();
        }
        else {
            throw new RuntimeException("Group-name already exists!");
        }
    }

    @PutMapping(value = "/group/join/{g_name}/{u_id}")
    public String joinGroup(@PathVariable long u_id,@PathVariable String g_name, @RequestBody Users user) {

        Users userJoin = userRepo.findById(u_id).get();
        List<Groups> Queries = groupRepo.findByName(g_name);
        for (int i = 0; i < Queries.size(); i++) {
            Groups currGroup = Queries.get(i);
            if(currGroup.getUser().getId() == userJoin.getId()){
                throw new RuntimeException("Cannot join a group that user is already a member of!");
            }

        }

        if (groupRepo.findByName(g_name) != null && user.getJoinFlag()) {
            if(userJoin.alreadyInGroup(g_name)) {
                throw new RuntimeException("Cannot join a group that user is already a member of!");
            }
            else{
                Groups groupToJoin = new Groups();
                groupToJoin.setUser(userJoin);
                groupToJoin.setName(g_name);
                user.getGroups().add(groupToJoin);
                groupRepo.save(groupToJoin);
                userRepo.save(userJoin);
                return "Successfully joined the group: " + groupToJoin.getName();
            }
        }
        else {
            throw new RuntimeException("Cannot join a group that doesn't exist!");
        }

    }

    @PutMapping(value = "/group/leave/{g_name}/{u_id}")
    public String leaveGroup(@PathVariable long u_id, @PathVariable String g_name, @RequestBody Users user) {
        Users updateUser = userRepo.findById(u_id).get();
        Groups groupToDelete = updateUser.getGroup(g_name);
        
        updateUser.getGroups().remove(updateUser.getGroups().indexOf(groupToDelete)); //bruuuuh
        groupRepo.delete(groupToDelete);
        return "User successfully left the group: " + groupToDelete.getName();
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
        return "Deleted user";
    }


}
