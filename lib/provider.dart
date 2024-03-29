import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:googleapis/calendar/v3.dart';

import 'secrets.dart';

import 'package:jwt_decoder/jwt_decoder.dart';


class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn(
    scopes: <String>[
      calendar.CalendarApi.calendarScope,

    ],
  );


  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async{
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
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async{
    try {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    }catch(e){
      print("Error logging out: $e");
    }
  }

  Future<String?> getAccessToken() async {
    final GoogleSignInAccount? googleUser = _user;
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    print("ACCESS TOKEN: " + googleAuth.accessToken.toString());
    return googleAuth.accessToken;
  }


  Future<List<Event>> getPrimaryCalendarEvents() async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return [];

    print("GOT ACCESS TOKEN!");
    final headers = {'Authorization': 'Bearer $accessToken'};
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/calendar/v3/calendars/primary/events'),
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

  Future<List<Event>> getCalendarEventsInterval(DateTime start, DateTime end) async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) return [];

    print("GOT ACCESS TOKEN!");
    final headers = {'Authorization': 'Bearer $accessToken'};
    final Uri uri = Uri.https('www.googleapis.com', '/calendar/v3/calendars/primary/events', {
      'timeMin': start.toIso8601String() + 'Z',
      'timeMax': end.toIso8601String() + 'Z',
    });
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final eventsJson = json['items'] as List<dynamic>;
      final events = eventsJson.map((e) => Event.fromJson(e)).toList();
      return events;
    } else {
      throw Exception('Failed to load calendar events: ${response.statusCode}');
    }
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
        Uri.parse('https://www.googleapis.com/calendar/v3/calendars/primary/events'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load calendar events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading calendar events: $e');
      rethrow;
    }
  }

/*
Combine the events from both users into a single list.

Sort the list of events by their start time.

Iterate through the list of events and identify overlapping events.

Identify the gaps between overlapping events as potential free time.

Determine the common free time between both users based on their availability.

Display the common free time to the users.
*/

}