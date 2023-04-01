import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis/calendar/v3.dart';

//import 'package:googleapis/calendar/v3.dart';


class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn(
    scopes: ["https://www.googleapis.com/auth/calendar",
      'https://www.googleapis.com/auth/calendar.events.readonly',
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
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
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


}