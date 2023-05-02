import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'Event/EventData.dart';
import 'package:http/http.dart' as http;

import 'Groups/GroupData.dart';
import 'Groups/groupParticipnats.dart';



Future<List<EventData>> getEventData() async {
final user = FirebaseAuth.instance.currentUser!;

final theUser = {
  'u_id': user.uid,
  'email': user.email,
  'name':user.displayName,
  'latest_schedule': null,
};

final UserBody = jsonEncode(theUser);

final url = 'http://192.121.208.57:8080/user/events';

final headers = {'Content-Type': 'application/json'};
final response = await http.put(Uri.parse(url), headers: headers,body: UserBody);

final body = json.decode(response.body);

print('Events:'+response.body);

return body.map<EventData>(EventData.fromJson).toList();
}


Future<List<GroupData>> getGroupData() async {
final user = FirebaseAuth.instance.currentUser!;

final url = 'http://192.121.208.57:8080/user/groups/${user.uid}';

final headers = {'Content-Type': 'application/json'};
final response = await http.get(Uri.parse(url), headers: headers);

final body = json.decode(response.body);

print('Groups:' + response.body);

return body.map<GroupData>(GroupData.fromJson).toList();
}



Future<String> getUserName(mail) async{
  final url = 'http://192.121.208.57:8080/user/' + mail;

  final headers = {'Content-Type': 'application/json'};
  final response = await http.get(Uri.parse(url), headers: headers);

  final body = json.decode(response.body);

  print('Owner:'+response.body);

  return body['name'];
}


Future<List<GroupParticipants>> getGroupParticipants(
admin, groupName) async {
final url =
    'http://192.121.208.57:8080/groups/users/' + groupName + '&' + admin;

final headers = {'Content-Type': 'application/json'};
final response = await http.get(Uri.parse(url), headers: headers);

final body = json.decode(response.body);

print(response.body);
try{body.map<GroupParticipants>(GroupParticipants.fromJson).toList();}catch(e){print(e);};
print("oj");
return body.map<GroupParticipants>(GroupParticipants.fromJson).toList();
}