package com.tempus.serverAPI.Controller;

import com.tempus.serverAPI.DateSyncAlg.Datesync;
import com.tempus.serverAPI.DateSyncAlg.Event;
import com.tempus.serverAPI.Exceptions.UserNotFoundException;
import com.tempus.serverAPI.Models.*;

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



    @GetMapping(value = "/user/groups")
    public List<Groups> getUserGroups(@RequestBody Users user) {
        if (userRepo.findById(user.getId()).isPresent()) {
            Users result = userRepo.findById(user.getId()).get();
            return result.getGroups();
        }
        else {
            throw new UserNotFoundException();
        }

    }


    //TODO: Förbättra detta med Lista av user ids i Groups.
    @GetMapping(value = "/groups/users")
    public List<Users> getUsersFromGroup(@RequestBody Groups group) {
        List<Groups> QueryResult = groupRepo.findByNameAndAdmin(group.getName(), group.getAdmin());
        List<Users> toReturn = new ArrayList<>();
        for (Groups groups : QueryResult) {
            Users currUser = (groups.getUser());
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
            if (userRepo.findById(user.getId()).isEmpty()) {
                throw new UserNotFoundException();
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

    }

    @PutMapping(value = "/group/setpicture/{g_name}&{a_email}")
    public String setpicture(@PathVariable String g_name, @PathVariable String a_email, @RequestBody String Image){
        List<Groups> QueryResult = groupRepo.findByNameAndAdmin(g_name, a_email);
        byte[] imageData = Base64.getDecoder().decode(Image);
        for (Groups currgroup : QueryResult) {
            currgroup.setImage(imageData);
            groupRepo.save(currgroup);
        }
        return "Group picture updated";
    }

    @PutMapping(value = "/group/join/{g_name}&{a_email}")
    public String joinGroup(@PathVariable String g_name, @PathVariable String a_email, @RequestBody Users user) {

       if (userRepo.findById(user.getId()).isEmpty()) {
           throw new UserNotFoundException();
       }
        Users userJoin = userRepo.findById(user.getId()).get();
        List<Groups> Queries = groupRepo.findByNameAndAdmin(g_name, a_email);

        if(Queries.isEmpty()) {
            throw new RuntimeException("Error joining group, this error should not occur");
        }
        else {
            for (Groups currGroup : Queries) {
                if (currGroup.getUser().getId().equals(userJoin.getId())) {
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
        if (userRepo.findById(user.getId()).isEmpty()) {
            throw new UserNotFoundException();
        }
        else {
            Users updateUser = userRepo.findById(user.getId()).get();
            List<Groups> groupToDelete = updateUser.getGroup(g_name);
            if (groupToDelete.isEmpty()) {
                throw new RuntimeException("Error when trying leave group " + g_name + ", user is not a member of that group");
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



    @PutMapping(value = "/update")
    public String updateUser(@RequestBody Users user) {
        if (userRepo.findById(user.getId()).isEmpty()) {
            throw new UserNotFoundException();
        }
        else {
            Users updatedUser = userRepo.findById(user.getId()).get();
            updatedUser.setName(user.getName());
            updatedUser.setEmail(user.getEmail());
            userRepo.save(updatedUser);
            return "Updated user info";
        }

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

    @PostMapping(value = "/gEvent/import")
    public String importEvents(@RequestBody GroupSchedule hmm) {

        if (googleEventRepo.findByUserid(hmm.getU_id()) != null) {
            throw new RuntimeException("User schedule already exist");
        }
        else {
            for (int i = 0; i < hmm.getSchedules().size(); i++) {
                UserSchedule currSchedule = hmm.getSchedules().get(i);
                GoogleEvent currEvent = new GoogleEvent();
                currEvent.setStart(currSchedule.getStart());
                currEvent.setEnd(currSchedule.getEnd());
                currEvent.setUserid(hmm.getU_id());
                googleEventRepo.save(currEvent);
            }
            Users toUpdate = userRepo.findById(hmm.getU_id()).get();
            toUpdate.setSentSchedule(true);
            return "Successfully imported user schedule";
        }
    }


    //FIXME: Sketchy code, fixa säkerhet och permissions
     @GetMapping(value = "/event/sync/{g_name}&{a_email}/{start_time}&{end_time}")
     public List<Event> syncSchedules(@PathVariable String g_name, @PathVariable String a_email, @PathVariable String start_time, @PathVariable String end_time) {
        List<Groups> Query = groupRepo.findByNameAndAdmin(g_name, a_email);
        if (!Query.isEmpty()) {
            List<Event> events = new ArrayList<>();
            Datesync toProcess = new Datesync();
            for (int i = 0; i < Query.size(); i++) {
                if (!Query.get(i).getUser().getSentSchedule()) {
                    throw new RuntimeException("User " + Query.get(i).getUser().getEmail() + " hasn't imported their schedule, this error should've been caught in the frontend");
                } //TODO: Detta ska fångas i frontend
                for (int j = 0; j < googleEventRepo.findByUserid(Query.get(i).getUser().getId()).size(); j++) {
                    GoogleEvent currGEv = googleEventRepo.findByUserid(Query.get(i).getUser().getId()).get(j);
                    Event evCreate = new Event(currGEv.getStart(), currGEv.getEnd());
                    events.add(evCreate);
                }
            }
            toProcess.setDateSyncLst(events);
            toProcess.sortDates();
            toProcess.pickPossDates(start_time,end_time);
            System.out.println(toProcess.possDates);
            return toProcess.possDates;
        }
        else {
            throw new RuntimeException("User isn't admin"); //Extrem limitation
        }
     }

    @DeleteMapping(value = "/delete/{id}")
    public String delUser(@PathVariable String u_id) {
        Users delUser = userRepo.findById(u_id).get();
        userRepo.delete(delUser);
        return "Deleted user";
    }


}
