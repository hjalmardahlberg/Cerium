import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _groupInfoController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

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

  void _handleAddGroupButtonPressed() async {
    if (user.email != null && _groupNameController.text != '' && _groupInfoController.text != '') {
      final eventData = {
        'name': _groupNameController.text,
        'info':_groupInfoController.text,
        'email': user.email,
      };
      const url = 'http://192.121.208.57:8080/save';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(eventData);
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('User data sent successfully!');
      } else {
        print('Error sending user data: ${response.statusCode}');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Expanded addGroupButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton.icon(
          onPressed: () {
            _handleAddGroupButtonPressed();
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
      ),
    );
  }

  TextFormField addTextForm(String text, TextEditingController controller) {
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

  GestureDetector addImage(double height, double width, File? imageFile) {
    return GestureDetector(
      onTap: _getImage,
      child: SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            // border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0x00000000),
          ),
          child: Image.file(imageFile!),
        ),
      ),
    );
  }
}
