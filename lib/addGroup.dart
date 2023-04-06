import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart'; //for fetching user
import 'package:http/http.dart' as http; //https requests
import 'dart:convert'; //converting json to arbitrary shit or vice verca


class AddGroupPage extends StatefulWidget {
  const AddGroupPage(
      {Key? key, required this.appbar, required this.bottomNavigationBar})
      : super(key: key);

  final AppBar appbar;
  final BottomAppBar bottomNavigationBar;

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  File? _imageFile;
  DateTime? _startSelectedDate;
  DateTime? _stopSelectedDate;
  TimeOfDay? _startSelectedTime;
  TimeOfDay? _stopSelectedTime;
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventInfoController = TextEditingController();

  Future<void> _getImage() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permission denied');
      } else {
        print('Error picking image: $e');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: widget.appbar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (_imageFile == null) EventPickImage(height, width, _imageFile),
              if (_imageFile != null) EventImage(height, width, _imageFile),
              SizedBox(height: 16),
              AddEventTextForm('Enter your Group name', _eventNameController),
              SizedBox(height: 16),
              AddEventTextForm('Enter your group info', _eventInfoController),
              SizedBox(height: 16),
              addGroupButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  ElevatedButton addGroupButton() {
    final user = FirebaseAuth.instance.currentUser!;

    return ElevatedButton.icon(
      onPressed: () async {
        String? groupName = _eventNameController.text;

        final userData = {
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
        };

        final url = 'http://192.121.208.57:8080/group/create/' + groupName;
        final headers = {'Content-Type': 'application/json'};
        final body = jsonEncode(userData);
        //print(body.toString());
        final response =
            await http.put(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          print('Created Group successfully!');
        } else {
          print('Error sending user data: ${response.statusCode}');
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      icon: const Icon(
        Icons.add,
        size: 24.0,
      ),
      label: const Text('Create Group'), // <-- Text
    );
  }

  TextFormField AddEventTextForm(
      String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: text,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter last Name';
        }
        return null;
      },
    );
  }

  SizedBox EventPickImage(double height, double width, File? _imageFile) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Color(0xBBABA6A6),
          ),
          child: IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _getImage,
          ),
        ));
  }

  SizedBox EventImage(double height, double width, File? _imageFile) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0x0000000),
          ),
          child: Image.file(_imageFile!),
        ));
  }
}
