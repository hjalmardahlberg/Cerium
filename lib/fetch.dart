import 'dart:convert';
import 'dart:io';
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
for(var group in body){
 try{ Uint8List image = await getImage(group["name"], group["admin"]);
 group["image"] = jsonEncode(String.fromCharCodes(image));
 }catch(e){print(e);};


}


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
return body.map<GroupParticipants>(GroupParticipants.fromJson).toList();
}


Future<void> uploadImage(String? g_name, String? a_email, _imageFile) async {
  try {
    //String base64Image = await encodeFileToBase64(_imageFile!);
    // Uint8List imageBytes = base64.decode(base64Image);

    Uint8List? imageBytes = await _imageFile?.readAsBytes();
    Uint8List bytes = Uint8List.fromList(imageBytes!);

    final response = await http.put(
      Uri.parse('http://192.121.208.57:8080/group/setpicture/' + g_name.toString() + "&" + a_email.toString()),
      headers: {'Content-Type': 'application/octet-stream' },
      body: bytes,
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Error uploading image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
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


Future<void> uploadEventImage(String? e_name,String? g_name, String? a_email, File? _imageFile) async {
  try {
    //String base64Image = await encodeFileToBase64(_imageFile!);
    // Uint8List imageBytes = base64.decode(base64Image);
    print("uploadEventImage:" + e_name! + g_name! + a_email! + _imageFile!.toString());
    Uint8List? imageBytes = await _imageFile?.readAsBytes();
    Uint8List bytes = Uint8List.fromList(imageBytes!);

    print("bytes:" + bytes.toString());

    final response = await http.put(
      Uri.parse('http://192.121.208.57:8080/event/picture/save/' + e_name + '&' +g_name + '&' + a_email),
      headers: {'Content-Type': 'application/octet-stream' },
      body: bytes,
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      print(response.body);
    } else {
      print('Error uploading image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}

Future<Uint8List> getEventImage(String e_name, String g_name,String a_email) async {
  print("fetching image");
  print(e_name);
  print(g_name);
  print(a_email);
  final pic_url = 'http://192.121.208.57:8080/event/picture/get/' + e_name + '&' + g_name + '&' +a_email;
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