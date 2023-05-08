import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:googleapis/calendar/v3.dart';
import 'package:projecttest/Groups/groupParticipnats.dart';

import 'secrets.dart';

import 'package:jwt_decoder/jwt_decoder.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn(
    scopes: <String>[
      calendar.CalendarApi.calendarScope,
    ],
  );

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> update_pfp(String? u_email, String? image_url) async {
    print("INT THIS SHIT");
    print(image_url);
    print(u_email);

    var uri = Uri.parse(
        'http://192.121.208.57:8080/user/picture/save&' + u_email.toString());
    print("THIS IS THE FUCKING URL TO SERVER");
    print(uri.toString());

    try {
      var response = await http.put(uri, body: image_url);
      if (response.statusCode != 200) {
        throw Exception('Failed to update profile picture: ${response
            .statusCode}\n${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to update profile picture: $error');
    }
  }

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      String? accessToken = googleAuth.accessToken;
      print("ACCESS TOKEN:");
      print(accessToken);

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final fire_base_user = FirebaseAuth.instance.currentUser!;

      //print(fire_base_user.uid);

      final userData = {
        'id': fire_base_user.uid,
        'name': fire_base_user.displayName,
        'email': fire_base_user.email,
      };

      print("YOOOOOOOOOO");
      update_pfp(fire_base_user.email, fire_base_user.photoURL);

      final url = 'http://192.121.208.57:8080/save';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(userData);
      //print(body.toString());
      final response =
      await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('User data sent successfully!');
      } else {
        print('Error sending user data: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    try {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  Future<String?> getAccessToken() async {
    final GoogleSignInAccount? googleUser = _user;
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    print("ACCESS TOKEN: " + googleAuth.accessToken.toString());
    return googleAuth.accessToken;
  }

  Future<List<String>> getCalendarIds() async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return [];

    final headers = {'Authorization': 'Bearer $accessToken'};
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/calendar/v3/users/me/calendarList'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final calendarsJson = json['items'] as List<dynamic>;
      final calendarIds = calendarsJson.map((c) => c['id'] as String).toList();
      return calendarIds;
    } else {
      throw Exception('Failed to load calendar list: ${response.statusCode}');
    }
  }

  Future<List<Event>> getPrimaryCalendarEvents() async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return [];

    print("GOT ACCESS TOKEN!");
    final headers = {'Authorization': 'Bearer $accessToken'};
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/calendar/v3/calendars/primary/events'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final eventsJson = json['items'] as List<dynamic>;
      final events = eventsJson.map((e) => Event.fromJson(e)).toList();
      return events;
    } else {
      throw Exception('Failed to load calendar events: ${response.statusCode}');
    }
  }

  Future<List<Event>> getCalendarEventsInterval(DateTime start,
      DateTime end) async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return [];
    print("GOT ACCESS TOKEN!");

    // Hämtar alla vettiga Cal ID's som användaren har (egna + subscriptions)
    final cal_ids = await getCalendarIds();
    List<String> filteredIds = cal_ids
        .where((id) => !id.contains("@group"))
        .toList(); // filtrerade cal_id listan
    print("Cal ids:" + filteredIds.toString());

    final headers = {'Authorization': 'Bearer $accessToken'};
    List<Event> allEvents = [];

    for (String id in filteredIds) {
      final Uri uri =
      Uri.https('www.googleapis.com', '/calendar/v3/calendars/$id/events', {
        'timeMin': start.toIso8601String() + 'Z',
        'timeMax': end.toIso8601String() + 'Z',
      });
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final eventsJson = json['items'] as List<dynamic>;
        final events = eventsJson.map((e) => Event.fromJson(e)).toList();
        allEvents.addAll(events);
      } else {
        throw Exception(
            'Failed to load calendar events for $id: ${response.statusCode}');
      }
    }

    return allEvents;
  }

  Future<String?> getCalendarEvents() async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return null;
    print("GOT ACCESS TOKEN!");

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/calendar/v3/calendars/primary/events'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to load calendar events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading calendar events: $e');
      rethrow;
    }
  }

  Future<List<Event>> getEvents1Month() async {
    final now = DateTime.now();
    final start = now;
    final end = now.add(Duration(days: 30));
    final events = await getCalendarEventsInterval(start, end);
    return events;
  }

  Future<List<Event>> getEvents1Week() async {
    final now = DateTime.now();
    final start = now;
    final end = now.add(Duration(days: 7));
    final events = await getCalendarEventsInterval(start, end);
    return events;
  }

  Future<List<Event>> getDataFromCalID(String cal_id) async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return [];

    final headers = {'Authorization': 'Bearer $accessToken'};
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/calendar/v3/calendars/' +
          cal_id +
          '/events'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final eventsJson = json['items'] as List<dynamic>;
      final events = eventsJson.map((e) => Event.fromJson(e)).toList();
      return events;
    } else {
      throw Exception('Failed to load calendar events: ${response.statusCode}');
    }
  }

  Future<bool> evIsUnique(String title, String start, String end,
      String? accessToken) async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final events = await getEvents1Week(); // get all events in the next week

    for (final event in events) {
      print(event.summary.toString() + " <--> " + title);
      print(event.start?.dateTime?.toIso8601String());
      print(start); // + "  OOOOO  " + start);
      if (event.summary == title &&
          event.start?.dateTime?.toIso8601String() == start + "Z" &&
          event.end?.dateTime?.toIso8601String() == end + "Z") {
        print("\n\nIS NOT UNIQUE!!!!!!\n\n");
        return false; // event already exists
      }
    }

    print("EVENT IS UNIQUE!!");
    return true; // event does not exist
  }

  Future<void> exportEventToGoogleCal(String title, String desc,
      String startTime, String endTime) async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return null;

    if (await evIsUnique(title, startTime, endTime, accessToken)) {
      // IF EVENT UNIQUE

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final event_to_export = { //FUNKAR NU BARA I SVENSK TID SÅ VAR BARA I SVERIGE!!!
        'summary': title,
        'description': desc,
        'start': {
          'dateTime': startTime,
          'timeZone': 'Europe/Stockholm',
        },
        'end': {
          'dateTime': endTime,
          'timeZone': 'Europe/Stockholm',
        },
      };

      try {
        final response = await http.post(
          Uri.parse(
              'https://www.googleapis.com/calendar/v3/calendars/primary/events'),
          headers: headers,
          body: jsonEncode(event_to_export),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Event created');
        } else {
          throw Exception(
              'Failed to create event: ${response.statusCode} AND: ${response
                  .body}');
        }
      } catch (e) {
        print('Error creating event: $e');
        rethrow;
      }
    }
  }


  Future<String?> getProfilePic(GroupParticipants user) async {

    final String? accessToken = await getAccessToken();
    if (accessToken == null) return null;

    final userData = {
      'email': user.email,
    };

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(userData);
    final url = 'http://192.121.208.57:8080/user/picture/get';

    final response =
    await http.put(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Successfull fetch');
      print(response.body);
      return response.body;
    } else {
      throw Exception(
          'Failed to create event: ${response.statusCode} AND: ${response
              .body}');
    }
  }
}
