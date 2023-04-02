package com.tempus.serverAPI;

import com.tempus.serverAPI.Controller.Controller;
import com.tempus.serverAPI.Models.Groups;
import com.tempus.serverAPI.Models.Users;
import com.tempus.serverAPI.Repo.GroupRepo;
import com.tempus.serverAPI.Repo.UserRepo;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.junit4.SpringRunner;
import org.junit.runner.RunWith;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@SpringBootTest
@ExtendWith(SpringExtension.class)
public class ServerApiApplicationTests {

	@MockBean
	private GroupRepo groupRepo;
	@MockBean //skapar "fake" så vi nte använder riktiga databasen
	private UserRepo userRepo;

	@Test
	public void test_save_user(){
		List<Groups> hmm = new ArrayList<Groups>();
		Users user = new Users(1L, "Viktor", "dsp@test.com", false, hmm);
		when(userRepo.save(user)).thenReturn(user);
		assertEquals(user, userRepo.save(user));
	}
	@Test
	public void test_create() {
		List<Groups> hmm = new ArrayList<Groups>();
		when(userRepo.findAll()).thenReturn(Stream.of(new Users(1L, "Eddy", "recce@snerk.com", false, hmm), new Users(2L, "Kangussy", "kan@ga.com", false, hmm)).collect(Collectors.toList()));
		assertEquals(2, userRepo.findAll().size());
	}


	//TODO: Fixa tester
}
