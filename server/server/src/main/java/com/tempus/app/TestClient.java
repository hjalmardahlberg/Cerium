package com.tempus.app;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

public class TestClient {
    public static void main(String [] args){
        String host = "127.0.0.1";
        int port = 25565;
        try(Socket socket = new Socket(host, port)) {
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            Scanner scanner = new Scanner(System.in);
            String line = null;
            while (!"exit".equalsIgnoreCase(line)) {
                line = scanner.nextLine();
                out.println(line);
                out.flush();
                System.out.println("Server replied " + in.readLine());
            }
            scanner.close();
        } catch(IOException e) {
             e.printStackTrace();
        }
    }    
}
