package com.tempus.serverAPI.Controller;

import com.tempus.serverAPI.Models.Users;
import com.tempus.serverAPI.Models.Groups;
import com.tempus.serverAPI.Models.Events;

import com.tempus.serverAPI.Repo.GoogleEventRepo;
import com.tempus.serverAPI.Repo.GroupRepo;
import com.tempus.serverAPI.Repo.UserRepo;
import com.tempus.serverAPI.Repo.EventRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
public class Controller {

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private GroupRepo groupRepo;

    @Autowired
    private EventRepo eventRepo;

    @Autowired
    private GoogleEventRepo googleEventRepo;

    @GetMapping(value = "/")
    public String getPage(){
        return "test";
    }

    @GetMapping(value = "/users")
    public List<Users> getUsers() {

        return userRepo.findAll();
    }



    @GetMapping(value = "/user/{u_id}/groups")
    public List<Groups> getUserGroups(@PathVariable String u_id) {
        Users user = userRepo.findById(u_id).get();
        return user.getGroups();
    }

    @GetMapping(value = "/groups/{g_name}/users")
    public List<Users> getUsersFromGroup(@PathVariable String g_name) {
        List<Groups> QueryResult = groupRepo.findByName(g_name);//TODO: Förbättra detta med Lista av user ids i Groups.
        System.out.println("Group size: " + QueryResult.size());
        List<Users> toReturn = new ArrayList<>();
        for(int i = 0; i < QueryResult.size(); i++) {
            Users currUser = (QueryResult.get(i).getUser());
            toReturn.add(currUser);
        }
        return toReturn;
    }


    @PostMapping(value = "/save")
    public String saveUser(@RequestBody Users user) {
        if(userRepo.findByEmail(user.getEmail()) != null){
            throw new RuntimeException("Email already exists");
        }
        else{
            userRepo.save(user);
            return "Saved user";
        }
    }

    @PutMapping(value = "/group/create/{g_name}")
    public String createGroup(@PathVariable String g_name, @RequestBody Users user) {

        if (!groupRepo.findByNameAndAdmin(g_name, user.getEmail()).isEmpty()) {
            throw new RuntimeException("Cannot create a group with already existing name");
        }
        else {
        Users updatedUser = userRepo.findById(user.getId()).get();
        Groups gCreate = new Groups();
        gCreate.setName(g_name);
        gCreate.setUser(updatedUser);
        gCreate.setAdmin(updatedUser.getEmail());
        user.getGroups().add(gCreate);
        groupRepo.save(gCreate);
        userRepo.save(updatedUser);
        return "Created a group with the ID: " + gCreate.getId() + "to the user: " + updatedUser.getName();
        }

    }

    @PutMapping(value = "/group/join/{g_name}&{a_email}")
    public String joinGroup(@PathVariable String g_name, @PathVariable String a_email, @RequestBody Users user) {

        Users userJoin = userRepo.findById(user.getId()).get();
        List<Groups> Queries = groupRepo.findByNameAndAdmin(g_name, a_email);

        if(Queries.isEmpty()) {
            throw new RuntimeException("Error joining group, this error should not occur");
        }
        else {
            for (int i = 0; i < Queries.size(); i++) {
                Groups currGroup = Queries.get(i);
                if(currGroup.getUser().getId() == userJoin.getId()){
                    throw new RuntimeException("Cannot join a group that user is already a member of!");
                }
            }
            Groups groupToJoin = new Groups();
            groupToJoin.setUser(userJoin);
            groupToJoin.setName(g_name);
            groupToJoin.setAdmin(Queries.get(0).getAdmin());
            user.getGroups().add(groupToJoin);
            groupRepo.save(groupToJoin);
            userRepo.save(userJoin);
            return "Successfully joined the group: " + groupToJoin.getName();
        }

    }


    @PutMapping(value = "/group/leave/{g_name}&{a_email}")
    public String leaveGroup(@PathVariable String g_name, @PathVariable String a_email, @RequestBody Users user) {
        Users updateUser = userRepo.findById(user.getId()).get();
        List<Groups> groupToDelete = updateUser.getGroup(g_name);
        if (groupToDelete.isEmpty()) {
            throw new RuntimeException("Fatal error, this error should not occur");
        }
        for (int i = 0; i < groupToDelete.size(); i++) {
            Groups curr = groupToDelete.get(i);

            if (curr.getAdmin().equals(a_email)) {
                updateUser.getGroups().remove(i);
                groupRepo.delete(curr);
                return "User successfully left the group: " + curr.getName();
            }
        }
        throw new RuntimeException("Fatal error occured when user " + user.getEmail() + " tried to leave group: " + g_name);
    }

    //FIXME
    @PutMapping(value = "/event/create/{e_name}")
    public String createEvent(@RequestBody Groups group, @PathVariable String e_name) {
        Groups selectedGroup = groupRepo.findById(group.getG_id()).get();
        List<Events> gEvents = eventRepo.findByName(e_name);
        for(int i = 0; i < gEvents.size(); i++) {
            Events selEvent = gEvents.get(i);
            if(selEvent.getGroup().getName().equals(group.getName())) {
                throw new RuntimeException("Event with given name already exists within that group");
            }
        }
        Events createdEvent = new Events();
        createdEvent.setName(e_name);
        createdEvent.setGroup(selectedGroup);
        gEvents.add(createdEvent);
        eventRepo.save(createdEvent);
        groupRepo.save(selectedGroup);
        return "Successfully created a event within the group: " + group.getName();

    }

    //FIXME
    @DeleteMapping(value = "/event/delete/{e_name}")
    public String delEvent(@PathVariable String e_name, @RequestBody Groups group) {
        Groups selectedGroup = groupRepo.findById(group.getG_id()).get();
        //Events selectedEvent = eventRepo.
        return "Success";
    }



    @PutMapping(value = "/update/{id}")
    public String updateUser(@PathVariable String id, @RequestBody Users user) {
        Users updatedUser = userRepo.findById(id).get();
        updatedUser.setName(user.getName());
        updatedUser.setEmail(user.getEmail());
        userRepo.save(updatedUser);
        return "Updated user info";
    }


    @DeleteMapping(value = "/group/delete/{g_name}")
    public String delGroup(@PathVariable String g_name, @RequestBody Users user) {
        List<Groups> selectedGroup = groupRepo.findByNameAndAdmin(g_name, user.getEmail());
        if (selectedGroup.isEmpty()) {
            throw new RuntimeException("Cannot delete a group that does not exist");
        }
        else if (selectedGroup.get(0).getAdmin().equals(user.getEmail())){
            for (int i = 0; i < selectedGroup.size(); i++) {
                Groups currGroup = selectedGroup.get(i);
                Users currUser = selectedGroup.get(i).getUser();
                int hmm = currUser.getGroups().indexOf(currGroup);
                currUser.getGroups().remove(hmm);
                groupRepo.delete(currGroup);

            }
            return "Successfully deleted " + selectedGroup.get(0).getName();
        }
        else {
            throw new RuntimeException("User not admin");
        }

    }

    @PostMapping(value = "/gEvent/new")
    public String importEvents(@RequestBody Users user) {
        return "hmm";
    }

    @DeleteMapping(value = "/delete/{id}")
    public String delUser(@PathVariable String u_id) {
        Users delUser = userRepo.findById(u_id).get();
        userRepo.delete(delUser);
        return "Deleted user";
    }


}
