import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


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
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _groupInfoController = TextEditingController();

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
              if (_imageFile == null) pickImage(height, width, _imageFile),
              if (_imageFile != null) addImage(height, width, _imageFile),
              const SizedBox(height: 16),
              addTextForm('Enter your Group name', _groupNameController),
              const SizedBox(height: 16),
              addTextForm('Enter your group info', _groupInfoController),
              const SizedBox(height: 16),
              addGroupButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Align addGroupButton() {
  final user = FirebaseAuth.instance.currentUser!;
  
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton.icon(
        onPressed: () async {
        
          String? groupName = _groupNameController.text;

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
          backgroundColor: Colors.lightBlue.shade300,
        ),
        icon: const Icon(
          Icons.add,
          size: 24.0,
        ),
        label: const Text('Group'),
      ),
    );
  }

  TextFormField addTextForm(
      String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
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

  SizedBox pickImage(double height, double width, File? _imageFile) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            color: Color(0xBBABA6A6),
          ),
          child: IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _getImage,
          ),
        ));
  }

  SizedBox addImage(double height, double width, File? _imageFile) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0x0000000),
          ),
          child: Image.file(_imageFile!),
        ));
  }
}
