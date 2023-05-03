import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import 'Event/EventData.dart';
import 'package:http/http.dart' as http;

import 'Groups/GroupData.dart';
import 'Groups/groupParticipnats.dart';

import 'package:image_to_byte/image_to_byte.dart';



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


Future<Uint8List> getImage(String group_name, String group_admin) async {
  print("fetching image");
        final pic_url = 'http://192.121.208.57:8080/group/getpicture/' + group_name + '&' + group_admin;
        final response = await http.get(Uri.parse(pic_url));

        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
       else {
        print('Error fetching image: ${response.statusCode}');
        // returnera wallstenbild i bytes
         Uint8List iByte = await imageToByte("images/wallsten.jpg");
        return iByte;
      }
}