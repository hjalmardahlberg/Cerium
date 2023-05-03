import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../homePage.dart';
import 'myGroups.dart';


class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key, required this.appbar}) : super(key: key);

  final AppBar appbar;

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  File? _imageFile;
  final TextEditingController _groupNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> _getImage() async {
    try {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        String base64Image = await encodeFileToBase64(_imageFile!);
        print(base64Image);
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



  // Encode File (returned from _getImage) to base64
  Future<String> encodeFileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  // Uploads the image to the server
  Future<void> _uploadImage(String? g_name, String? a_email) async {
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: widget.appbar,

      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(left: 5, right: 5),
            children: [
              if (_imageFile == null) pickImage(height, width, _imageFile),
              if (_imageFile != null) addImage(height, width, _imageFile),
              const SizedBox(height: 16),
              addTextForm('Ange grupp namn', _groupNameController),
              const SizedBox(height: 16),
              addGroupButton(),
            ],
          ),

      ),

      //  bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  void _handleAddGroupButtonPressed() async {
    print('http://192.121.208.57:8080/group/create/' + _groupNameController.text);
    if (user.email != null && _groupNameController.text != '') {

      final groupData = {
        'id':user.uid,
        'name': _groupNameController.text,
        'email': user.email,
      };


      final url = 'http://192.121.208.57:8080/group/create/' + _groupNameController.text;
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(groupData);
      final response = await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('User data sent successfully!');

        // Call the image upload function after the group has been created
        await _uploadImage(_groupNameController.text, user.email);

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage(pageIndex: 2,)),
        );
      } else {
        print('Error sending user data: ${response.statusCode}');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Fel'),
            content: Text('Fyll i alla fällt.'),
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


  Align addGroupButton() {
    return
       Align(
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
          label: const Text('Grupp'),
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
          return 'Ange efternamn';
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
