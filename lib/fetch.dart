import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'Event/EventData.dart';
import 'package:http/http.dart' as http;

import 'Groups/GroupData.dart';

Future<List<EventData>> getEventData() async {
final user = FirebaseAuth.instance.currentUser!;

final url = 'http://192.121.208.57:8080/user/events/${user.uid}';

final headers = {'Content-Type': 'application/json'};
final response = await http.get(Uri.parse(url), headers: headers);

final body = json.decode(response.body);

print(response.body);

return body.map<EventData>(EventData.fromJson).toList();
}


Future<List<GroupData>> getGroupData() async {
final user = FirebaseAuth.instance.currentUser!;

final url = 'http://192.121.208.57:8080/user/groups/${user.uid}';

final headers = {'Content-Type': 'application/json'};
final response = await http.get(Uri.parse(url), headers: headers);

final body = json.decode(response.body);

print(response.body);

return body.map<GroupData>(GroupData.fromJson).toList();
}

Future<String> getUserName(mail) async{
  final url = 'http://192.121.208.57:8080/user/' + mail;

  final headers = {'Content-Type': 'application/json'};
  final response = await http.get(Uri.parse(url), headers: headers);

  final body = json.decode(response.body);

  print(response.body);

  return body['name'];
}