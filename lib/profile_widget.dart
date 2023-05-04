import 'dart:convert';

import 'package:googleapis/calendar/v3.dart' show Event;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Theme/ChangeTheme.dart';
import 'Theme/themeConstants.dart';
import 'provider.dart';
import 'package:http/http.dart' as http;

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  ProfileWidgetState createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inställningar',
          style: TextStyle(
            fontSize: 20,
            color: themeManager.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/login'));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                user.displayName!,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Email:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              user.email!,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            const Divider(),
            theme(themeManager),
            const SizedBox(height: 10),
            sendCalender(context, user, themeManager),
            const SizedBox(height: 10),
            logOut(context),
          ],
        ),
        ),
      );
  }

  SizedBox theme(themeManager) {
    return SizedBox(
      width: 175,
      child: ElevatedButton.icon(
        onPressed: () async {
          final provider = Provider.of<ThemeManager>(context, listen: false);
          provider.toggleTheme(!themeManager.isDarkMode);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor:
              themeManager.isDarkMode ? Colors.white : Colors.black,
          side: BorderSide(
              color: themeManager.isDarkMode ? Colors.white : Colors.black),
        ),
        icon: Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: themeManager.isDarkMode
              ? Icon(Icons.wb_sunny_outlined)
              : Icon(Icons.nightlight_round),
        ),
        label: Center(
          child: Text(
            themeManager.isDarkMode ? "Light mode" : "Dark mode",
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }

  Expanded logOut(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            child: const Text('Logga ut'),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              Navigator.popUntil(context, (route) {
                print(route.settings.name);
                return route.isFirst;
              });
            //  provider.logout();
            //  Navigator.popUntil(context, ModalRoute.withName('/login'));
            },
          ),
        ),
      ),
    );
  }

  SizedBox sendCalender(BuildContext context, User user, themeManager) {
    return SizedBox(
      width: 175,
      child: ElevatedButton.icon(
        onPressed: () async {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);


          final events = await provider.getEvents1Week();

          for (var ev in events){
            print(ev.summary);//ev.start!.dateTime.toString() +' <--> '+ ev.end!.dateTime.toString());
          }

          List<Map<String, dynamic>> ev_lst = [];

          for (Event event in events) {
            // FILTRERA BORT NULL
            if (event.start?.dateTime != null || event.end?.dateTime != null) {
              final ev_data = {
                'start': event.start?.dateTime?.toLocal().toIso8601String(),
                'end': event.end?.dateTime?.toLocal().toIso8601String(),
              };

              ev_lst.add(ev_data);
            }
          }


          final final_data_body = {
            'u_id': user.uid,
            'schedules': ev_lst,
          };

          print(final_data_body);

          const url = 'http://192.121.208.57:8080/gEvent/import';
          final headers = {'Content-Type': 'application/json'};
          final body = jsonEncode(final_data_body);

          final response =
              await http.post(Uri.parse(url), headers: headers, body: body);
          print(response.body);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor:
              themeManager.isDarkMode ? Colors.white : Colors.black,
          side: BorderSide(
              color: themeManager.isDarkMode ? Colors.white : Colors.black),
        ),
        icon: Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: Icon(Icons.send),
        ),
        label: Center(
          child: Text(
            'Skicka Kalender',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
