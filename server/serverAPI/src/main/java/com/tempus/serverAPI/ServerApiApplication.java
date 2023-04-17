package com.tempus.serverAPI;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ServerApiApplication {

	public static void main(String[] args) {
		System.out.println("Basic REST-API for the course project in DSP. Written by Edvard Axelman and Viktor Wallstén spring 2023");
		System.out.println("Starting SpringBoot application...");

		SpringApplication.run(ServerApiApplication.class, args);

	}

}
