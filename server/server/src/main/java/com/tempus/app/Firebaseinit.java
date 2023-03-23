package com.tempus.app;

import java.io.*;

import com.google.firebase.*;

import com.google.auth.oauth2.*;


import javax.annotation.PostConstruct;

public class Firebaseinit {

    @PostConstruct
    public void init() {
        try{
        FileInputStream serviceAccount = new FileInputStream("/home/panama/Desktop/DSP/Cerium/server/key");
        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .setDatabaseUrl("https://tempusdb-default-rtdb.europe-west1.firebasedatabase.app")
                .build();

        FirebaseApp.initializeApp(options);
        }catch (Exception e) {
            e.printStackTrace();
        }
        
    }
}