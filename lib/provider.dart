import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  //final storage = FlutterSecureStorage();

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
      final fire_base_user = FirebaseAuth.instance.currentUser!;

      // SAVE ACCESS TOKEN FOR LATER USE
      //final storedAccessToken = googleAuth.accessToken;
      //await storage.write(key: 'google_auth', value: json.encode({
      //  'access_token': storedAccessToken,
      //}));

      //print(fire_base_user.uid);

      final userData = {
        'id': fire_base_user.uid,
        'name' : fire_base_user.displayName,
        'email' : fire_base_user.email,
      };

      final url = 'http://192.121.208.57:8080/save';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(userData);
      //print(body.toString());
      final response = await http.post(Uri.parse(url),headers: headers, body: body);

      if (response.statusCode == 200){
        print('User data sent successfully!');
      }else{
        print('Error sending user data: ${response.statusCode}');
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // Checks if user is signed in
  Future<bool> isSignedIn() async {
    final currentUser = await googleSignIn.signInSilently();
    return currentUser != null;
  }

  Future logout() async{
    try {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    }catch(e){
      print("Error logging out: $e");
    }
  }
/*
  Future<String?> getAccessToken() async {

    final jsonString = await storage.read(key: 'google_auth');
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      final accessToken = jsonMap['access_token'];
      if (accessToken != null) {
        final jwt = jsonDecode(accessToken);
        final expiry = jwt.claims['exp'];
        if (expiry != null) {
          final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          if (now < expiry) {
            return accessToken;
          } else {
            final googleUser = await googleSignIn.signIn();
            final googleAuth = await googleUser!.authentication;
            final newAccessToken = googleAuth.accessToken;
            await storage.write(
              key: 'google_auth',
              value: json.encode({
                'access_token': newAccessToken,
              }),
            );
            return newAccessToken;
          }
        }
      }
    }
    return null;
  }
*/





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

  Future<List<Event>> GetEvents1month() async  {
    final now = DateTime.now();
    final start = now;
    final end = now.add(Duration(days: 30));
    final events = await getCalendarEventsInterval(start, end);
    return events;
  }

}