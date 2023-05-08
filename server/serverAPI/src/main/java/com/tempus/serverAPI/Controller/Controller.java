package com.tempus.serverAPI.Controller;

import com.tempus.serverAPI.DateSyncAlg.Datesync;
import com.tempus.serverAPI.DateSyncAlg.Event;
import com.tempus.serverAPI.Exceptions.ApiException;
import com.tempus.serverAPI.Exceptions.ApiForbiddenException;

import com.tempus.serverAPI.Models.*;

import com.tempus.serverAPI.Repo.GoogleEventRepo;
import com.tempus.serverAPI.Repo.GroupRepo;
import com.tempus.serverAPI.Repo.UserRepo;
import com.tempus.serverAPI.Repo.EventRepo;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
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

    @GetMapping(value = "/user/{u_email}")
    public Users getUser(@PathVariable String u_email) {
        Users toReturn = userRepo.findByEmail(u_email);
        if (toReturn == null) {
            throw new ApiException("User is not found");
        }
        else {
            return toReturn;
        }
    }


    @GetMapping(value = "/user/groups/{u_id}")
    public List<Groups> getUserGroups(@PathVariable String u_id) {
        if (userRepo.findById(u_id).isPresent()) {
            Users result = userRepo.findById(u_id).get();
            return result.getGroups();
        }
        else {
            throw new ApiException("Error when processing the request, user does not exist");
        }

    }

    //TODO: Förbättra detta med Lista av user ids i Groups.
    @GetMapping(value = "/groups/users/{g_name}&{a_email}")
    public List<Users> getUsersFromGroup(@PathVariable String g_name, @PathVariable String a_email) {
        List<Groups> QueryResult = groupRepo.findByNameAndAdmin(g_name, a_email);
        List<Users> toReturn = new ArrayList<>();
        for (int i = 0; i < QueryResult.size(); i++) {
            Users toAdd = new Users();
            toAdd.setId(QueryResult.get(i).getUser().getId());
            toAdd.setName(QueryResult.get(i).getUser().getName());
            toAdd.setLatestSchedule(QueryResult.get(i).getUser().getLatestSchedule());
            toAdd.setEmail(QueryResult.get(i).getUser().getEmail());
            toReturn.add(toAdd);
        }
        return toReturn;
    }


    @PostMapping(value = "/save")
    public String saveUser(@RequestBody Users user) {
        if(userRepo.findByEmail(user.getEmail()) != null){
            throw new ApiForbiddenException("Email already exists");
        }
        else{
            userRepo.save(user);
            return "Saved user";
        }
    }

    @PutMapping(value = "/user/picture/save&{u_email}")
    public String saveUserPicture(@RequestBody String Image, @PathVariable String u_email){
        Users user = userRepo.findByEmail(u_email);
        if (user == null) {
            throw new ApiException("User is not found");
        }
        user.setImage(Image);
        userRepo.save(user);
        return "Saved user picture";
    }
    @PutMapping(value = "/user/picture/get")
    public String getUserPicture(@RequestBody Users user){
        Users usr = userRepo.findByEmail(user.getEmail());
        if (usr == null) {
            throw new ApiException("User is not found");
        }
        return usr.getImage();
    }


    @PutMapping(value = "/group/create/{g_name}")
    public String createGroup(@PathVariable String g_name, @RequestBody Users user) {

        if (!groupRepo.findByNameAndAdmin(g_name, user.getEmail()).isEmpty()) {
            throw new ApiForbiddenException("Cannot create a group with already existing name");
        }
        else {
            if (userRepo.findById(user.getId()).isEmpty()) {
                throw new ApiException("Error when processing the request, user does not exist");
            }
            else {
                Users updatedUser = userRepo.findById(user.getId()).get();
                Groups gCreate = new Groups();
                gCreate.setName(g_name);
                gCreate.setUser(updatedUser);
                gCreate.setAdmin(updatedUser.getEmail());
                gCreate.setAdminusername(updatedUser.getName());
                user.getGroups().add(gCreate);
                groupRepo.save(gCreate);
                userRepo.save(updatedUser);
                return "Created a group with the ID: " + gCreate.getId() + "to the user: " + updatedUser.getName();
            }

        }

    }

    @PutMapping(value = "/group/setpicture/{g_name}&{a_email}")
    public String setpicture(@PathVariable String g_name, @PathVariable String a_email, @RequestBody byte[] Image){
        List<Groups> QueryResult = groupRepo.findByNameAndAdmin(g_name, a_email);

        try {
            Path path = Paths.get("src/main/resources/static/images/"+g_name+a_email+".txt");
            Files.deleteIfExists(path);
            Files.createFile(path);
            Files.write(path, Image);
            for (Groups currgroup : QueryResult) {
                currgroup.setImage(path.toString()); //?? kanske ska vara ngt annat än tostring
                groupRepo.save(currgroup);
            }
            return "Group picture updated";
        }catch (Exception e){
            throw new ApiException("Error when processing the request, image is not valid");
        }


    }
    //https://mkyong.com/java/how-to-convert-array-of-bytes-into-file/
    //https://www.youtube.com/watch?v=Tpwnvi-3pGw
    @GetMapping(value = "/group/getpicture/{g_name}&{a_email}")
    public byte[] getPicture(@PathVariable String g_name, @PathVariable String a_email) {
        Groups QueryResult = groupRepo.findByNameAndAdmin(g_name, a_email).get(0);
        if (QueryResult.getImage() == null) {
            throw new ApiException("Error when processing the request, group does not have an image");
        }
        Path path = Paths.get(QueryResult.getImage());
        try {
            return Files.readAllBytes(path);
        } catch (Exception e) {
            e.printStackTrace();
        }
    throw new ApiException("Error occured when reading image from database");
    }

    @PutMapping(value = "/group/join/{g_name}&{a_email}")
    public String joinGroup(@PathVariable String g_name, @PathVariable String a_email, @RequestBody Users user) {

       if (userRepo.findById(user.getId()).isEmpty()) {
           throw new ApiException("Error when processing the request, user does not exist");
       }
        Users userJoin = userRepo.findById(user.getId()).get();
        List<Groups> Queries = groupRepo.findByNameAndAdmin(g_name, a_email);

        if(Queries.isEmpty()) {
            throw new ApiForbiddenException("Error when user tried joining group, the user is not a member of the given group");
        }
        else {
            for (Groups currGroup : Queries) {
                if (currGroup.getUser().getId().equals(userJoin.getId())) {
                    throw new ApiForbiddenException("Cannot join a group that user is already a member of!");
                }
            }

            Groups groupToJoin = new Groups();
            groupToJoin.setUser(userJoin);
            groupToJoin.setName(g_name);
            groupToJoin.setAdmin(Queries.get(0).getAdmin());
            groupToJoin.setImage(Queries.get(0).getImage());
            userJoin.getGroups().add(groupToJoin);
            groupToJoin.setAdminusername(Queries.get(0).getAdminusername());
            userJoin.getEvents().addAll(Queries.get(0).getEvents());
            groupRepo.save(groupToJoin);
            userRepo.save(userJoin);
            return "Successfully joined the group: " + groupToJoin.getName();
        }

    }

    //FIXME: Bugg när vi lämnar grupp som admin
    @PutMapping(value = "/group/leave/{g_name}&{a_email}")
    public String leaveGroup(@PathVariable String g_name, @PathVariable String a_email, @RequestBody Users user) {
        if (userRepo.findById(user.getId()).isEmpty()) {
            throw new ApiException("Error when processing the request, user does not exist");
        }
        else if (user.getEmail().equals(a_email)) {
            throw new ApiForbiddenException("Cannot leave a group if owner");
        }
        else {
            Users updateUser = userRepo.findById(user.getId()).get();
            List<Groups> groupToDelete = updateUser.getGroup(g_name);
            if (groupToDelete.isEmpty()) {
                throw new ApiForbiddenException("Error when trying leave group " + g_name + ", user is not a member of that group");
            }
            for (int i = 0; i < groupToDelete.size(); i++) {
                Groups curr = groupToDelete.get(i);

                if (curr.getAdmin().equals(a_email) && curr.getName().equals(g_name)) {
                    int hmm = updateUser.getGroups().indexOf(curr);
                    updateUser.getGroups().remove(hmm);
                    groupRepo.delete(curr);
                    return "User successfully left the group: " + curr.getName();
                }
            }
            throw new ApiForbiddenException("Fatal error occured when user " + user.getEmail() + " tried to leave group: " + g_name);
        }

    }


    @DeleteMapping(value = "/group/delete/{g_name}")
    public String delGroup(@PathVariable String g_name, @RequestBody Users user) {
        List<Groups> selectedGroup = groupRepo.findByNameAndAdmin(g_name, user.getEmail());
        if (selectedGroup.isEmpty()) {
            throw new ApiException("Cannot delete a group that does not exist");
        }
        else if (selectedGroup.get(0).getAdmin().equals(user.getEmail())){
            for (int i = 0; i < selectedGroup.size(); i++) {
                Groups currGroup = selectedGroup.get(i);
                Users currUser = selectedGroup.get(i).getUser();

                int hmm = currUser.getGroups().indexOf(currGroup);
                currUser.getGroups().remove(hmm);
                for (int j = 0; j < currGroup.getEvents().size(); j++) {
                    Events currEvent = currGroup.getEvents().get(j);

                    /*

                    Users currEventUser = currEvent.getUser();
                    for (int k = 0; k < currEventUser.getEvents().size(); k++) { // Här kollar vi att eventet finns i user och det är rätt event som tas bort
                           if (currEventUser.getEvents().get(k).getGroup().equals(currGroup)) {
                               currEventUser.getEvents().remove(k);
                           }
                    } */
                    currGroup.getEvents().remove(j);
                    eventRepo.delete(currEvent);
                }
                try {
                    Files.delete(Paths.get(currGroup.getImage()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                groupRepo.delete(currGroup);

            }
            return "Successfully deleted " + selectedGroup.get(0).getName();
        }
        else {
            throw new ApiForbiddenException("User not admin");
        }

    }

    @PutMapping(value = "/event/create/{g_name}&{a_email}")
    public String createEvent(@RequestBody Events event, @PathVariable String g_name, @PathVariable String a_email) {
        List<Groups> updateGroup = groupRepo.findByNameAndAdmin(g_name, a_email);
        if (groupRepo.findByNameAndAdmin(g_name, a_email).isEmpty()) {
            throw new ApiException("Error when creating event inside group: group does not exist");
        }
        Groups selectedGroup = updateGroup.get(0);
        List<Events> gEvents = eventRepo.findByName(event.getName());
        for(int i = 0; i < gEvents.size(); i++) {
            Events selEvent = gEvents.get(i);
            if(selEvent.getGroup().getName().equals(selectedGroup.getName())) {
                throw new ApiForbiddenException("Event with given name already exists within that group");
            }
        }

        Events createdEvent = new Events();
        createdEvent.setName(event.getName());
        createdEvent.setDescription(event.getDescription());
        createdEvent.setDate(event.getDate());
        createdEvent.setStart_time(event.getStart_time());
        createdEvent.setEnd_time(event.getEnd_time());
        //FIXME: Dubbletter
        createdEvent.setGroup(selectedGroup); // KOMMER ENDAST VARA PÅ GRUPPÄGAREN
        /*
        //Behöver nog inte ha user event relation
        for (int i = 0; i < updateGroup.size(); i++) { // Lägger till eventet i alla users som är med i gruppen
            Users usr = updateGroup.get(i).getUser();
            List<Events> usrEv = usr.getEvents();
            usrEv.add(createdEvent);
            //createdEvent.setUser(updateGroup.get(i).getUser());
            userRepo.save(usr);
        }*/

        eventRepo.save(createdEvent);
        groupRepo.save(selectedGroup);


        return "Successfully created a event within the group: " + selectedGroup.getName();

    }
    @PutMapping(value = "/event/picture/save/{e_name}&{g_name}&{a_email}")
    public String setEventPicture(@RequestBody byte[] image, @PathVariable String e_name, @PathVariable String g_name, @PathVariable String a_email) {
        List<Groups> QueryResult = groupRepo.findByNameAndAdmin(g_name, a_email);
        Events eventResult = eventRepo.findByNameAndGroup(e_name, QueryResult.get(0));
        try {
            Path path = Paths.get("src/main/resources/static/images/"+a_email+g_name+e_name+".txt");
            Files.deleteIfExists(path);
            Files.createFile(path);
            Files.write(path, image);
            eventResult.setImage(path.toString());
            eventRepo.save(eventResult);
            return "Event-picture updated";
        }catch (Exception e){
            throw new ApiException("Error when processing the request, image is not valid");
        }
    }

    @GetMapping(value = "/event/picture/get/{e_name}&{g_name}&{a_email}")
    public byte[] getEventPicture(@PathVariable String e_name, @PathVariable String g_name, @PathVariable String a_email) {
        List<Groups> QueryResult = groupRepo.findByNameAndAdmin(g_name, a_email);
        if (QueryResult.isEmpty()) {
            throw new ApiException("Error when processing the request, group does not exist");
        }
        Events eventResult = eventRepo.findByNameAndGroup(e_name, QueryResult.get(0));
        if (eventResult.getImage() == null) {
            throw new ApiException("Error when processing the request, event does not have an image");
        }
        try {
            Path path = Paths.get(eventResult.getImage());
            return Files.readAllBytes(path);
        }catch (Exception e){
            throw new ApiException("Error when processing the request, image is not valid");
        }
    }


    @PutMapping(value = "/user/events")
    public List<Events> getEvents(@RequestBody Users user) {
        Users selectedUser = userRepo.findByEmail(user.getEmail());
        if (selectedUser == null) {
            throw new ApiException("Cannot find user");
        }
        else {


                List<Events> toReturn = new ArrayList<>();
                List<Groups> usrGroups = selectedUser.getGroups();
                for(int i = 0; i < usrGroups.size(); i++) {
                    Groups currGroup = usrGroups.get(i);
                    Groups topGroup = groupRepo.findByNameAndAdmin(currGroup.getName(), currGroup.getAdmin()).get(0);
                    toReturn.addAll(topGroup.getEvents());
                }
                return toReturn;

        }
    }

    //FIXME
    @DeleteMapping(value = "/event/delete/{e_name}")
    public String delEvent(@PathVariable String e_name, @RequestBody Groups group) {
        List<Groups> QueryResults = groupRepo.findByNameAndAdmin(group.getName(), group.getAdmin());
        Groups selectedGroup = QueryResults.get(0);
        List<Events> selectedEvent = eventRepo.findByGroup(selectedGroup);
        if (selectedEvent.isEmpty()) {
            throw new ApiException("Cannot delete a event that does not exist");
        }
        for (int i = 0; i < selectedEvent.size(); i++) {
            if(selectedEvent.get(i).getName().equals(e_name)) {
                selectedGroup.getEvents().remove(i);
                try {
                    Path path = Paths.get(selectedEvent.get(i).getImage());
                    Files.deleteIfExists(path);
                }catch (Exception e){
                    e.printStackTrace();
                }
                eventRepo.delete(selectedEvent.get(i));
            }
        } //FIXME: Vi vill gå in i gruppen som har eventet och ta bort rätt event.
        for (int i = 0; i < QueryResults.size(); i++) {
            Users currUser = QueryResults.get(i).getUser();
            for (int j = 0; j < currUser.getEvents().size(); j++) {
                if (currUser.getEvents().get(j).getName().equals(e_name) && currUser.getEvents().get(j).getGroup().equals(selectedGroup)) {
                    currUser.getEvents().remove(j);
                    userRepo.save(currUser);
                }
            }
        }

        /*
        for (int i = 0; i < selectedEvent.size(); i++) {
            //Users currUser = selectedEvent.get(i).getUser();
            List<Events> userEvents = currUser.getEvents();
            for (int j = 0; j < userEvents.size(); j++) {
                if (userEvents.get(j).getName().equals(e_name) && userEvents.get(j).getGroup().equals(selectedGroup)) {
                    userEvents.remove(j);
                }
            }
        } */
        return "Successfully deleted event: " + e_name + " from group: " + group.getName();

    }



    @PutMapping(value = "/update")
    public String updateUser(@RequestBody Users user) {
        if (userRepo.findById(user.getId()).isEmpty()) {
            throw new ApiException("Error when processing the request, user does not exist");
        }
        else {
            Users updatedUser = userRepo.findById(user.getId()).get();
            updatedUser.setName(user.getName());
            updatedUser.setEmail(user.getEmail());
            userRepo.save(updatedUser);
            return "Updated user info";
        }

    }




    @Transactional
    @PostMapping(value = "/gEvent/import")
    public String importEvents(@RequestBody GroupSchedule hmm) {

        List<GoogleEvent> toDelete = googleEventRepo.findByUserid(hmm.getU_id());
        for(int i = 0; i < toDelete.size(); i++) {
            googleEventRepo.delete(toDelete.get(i));
        }
        for (int i = 0; i < hmm.getSchedules().size(); i++) {
            UserSchedule currSchedule = hmm.getSchedules().get(i);
            GoogleEvent currEvent = new GoogleEvent();
            currEvent.setStart(currSchedule.getStart());
            currEvent.setEnd(currSchedule.getEnd());
            currEvent.setUserid(hmm.getU_id());
            googleEventRepo.save(currEvent);
        }
        Users toUpdate = userRepo.findById(hmm.getU_id()).get();
        LocalDateTime now = LocalDateTime.now();
        toUpdate.setLatestSchedule(now.toString());
        userRepo.save(toUpdate);
        return "Successfully imported user schedule";

    }


    //FIXME: Sketchy code, fixa säkerhet och permissions
     @PutMapping(value = "/event/sync/{g_name}&{a_email}")
     public List<Event> syncSchedules(@PathVariable String g_name, @PathVariable String a_email, @RequestBody SetDate setDate) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");
        List<Groups> Query = groupRepo.findByNameAndAdmin(g_name, a_email);
        if (!Query.isEmpty()) {
            List<Event> events = new ArrayList<>();

            for (int i = 0; i < Query.size(); i++) {
                if (googleEventRepo.findByUserid(Query.get(i).getUser().getId()).isEmpty()) {
                    break;
                }
                for (int j = 0; j < googleEventRepo.findByUserid(Query.get(i).getUser().getId()).size(); j++) {
                    GoogleEvent currGEv = googleEventRepo.findByUserid(Query.get(i).getUser().getId()).get(j);
                    Event evCreate = new Event(LocalDateTime.parse(currGEv.getStart(),formatter), LocalDateTime.parse(currGEv.getEnd(), formatter));
                    events.add(evCreate);
                }
            }
            System.out.println(setDate.getStart_Date());
            System.out.println(setDate.getEnd_Date());
            System.out.println(setDate.getStart_Hour());
            System.out.println(setDate.getEnd_hour());
            System.out.println(setDate.getDuration());

            Datesync freespots = new Datesync();
            System.out.println(freespots.findFreeSpots(events, LocalDateTime.parse(setDate.getStart_Date(), formatter), LocalDateTime.parse(setDate.getEnd_Date(), formatter),
                    Duration.ofMinutes(setDate.getDuration()), LocalTime.parse(setDate.getStart_Hour()), LocalTime.parse(setDate.getEnd_hour())));
            return freespots.findFreeSpots(events, LocalDateTime.parse(setDate.getStart_Date(), formatter), LocalDateTime.parse(setDate.getEnd_Date(), formatter),
                    Duration.ofMinutes(setDate.getDuration()), LocalTime.parse(setDate.getStart_Hour()), LocalTime.parse(setDate.getEnd_hour()));

        }
        else {
            throw new ApiForbiddenException("User isn't admin"); //Extrem limitation
        }
     }

    @DeleteMapping(value = "/delete/{id}")
    public String delUser(@PathVariable String u_id) {
        Users delUser = userRepo.findById(u_id).get();
        userRepo.delete(delUser);
        return "Deleted user";
    }


}
