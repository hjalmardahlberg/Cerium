import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'GroupData.dart';
import 'group.dart';


class MyGroups extends StatefulWidget {
  const MyGroups({
    super.key,
  });

  @override
  State<MyGroups> createState() => _MyGroups();
}

class _MyGroups extends State<MyGroups>  {
  double baseWidth = 390;
  double fem = 0;
  double ffem = 0;
  double width = 0;
  double height = 0;
  final TextEditingController _joinGroupController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<GroupData>> groupData = getGroupData();

  static Future<List<GroupData>> getGroupData() async {
    final user = FirebaseAuth.instance.currentUser!;

    final url = 'http://192.121.208.57:8080/user/groups/' + user.uid;

    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(Uri.parse(url), headers: headers);

    final body = json.decode(response.body);

    print(response.body);

    return body.map<GroupData>(GroupData.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    ffem = fem * 0.97;
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      //appBar: widget.appbar,
      body: Column(
        children: [
          groupText(),
          Expanded(
            child: FutureBuilder<List<GroupData>>(
                future: groupData, builder: (context, snapshot) {
               if (snapshot.hasData) {
                final groupData = snapshot.data!;
                return buildGroups(groupData);
              }
              else {
                return const Padding(padding:EdgeInsets.only(top:10), child:Text('No Groups'));
              }
            }),
          ),
          joinGroup()
        ],
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }


  Center groupText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          'Grupper',
          style: TextStyle(
            fontSize: 24.0, // Set the font size to 24
            decoration: TextDecoration.underline, // Underline the text
          ),
        ),
      ),
    );
  }


  void _showJoinGroup(TextEditingController joinGroupController, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter The Group Name'),
          content: TextFormField(
            controller: joinGroupController,
            decoration: const InputDecoration(hintText: 'Group name...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('JOIN'),
              onPressed: () {
                // do something with the text entered in the TextFormField
                String enteredText = joinGroupController.text;
                print('Entered Text: $enteredText');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Container joinGroup() {
    return Container(
      margin: const EdgeInsets.all(10),
      // Adjust the value as needed
      child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
                    _showJoinGroup(_joinGroupController, context);
                  },
                  child: Text(
                    'Gå med i grupp',
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }


  Widget buildGroups(List<GroupData> groupData) =>
      ListView.builder(
        itemCount: groupData.length,
        itemBuilder: (context, index) {
          final group = groupData[index];
          return groupBox('images/wallsten.jpg', group.groupName);
        },
      );

  GestureDetector groupBox(String groupImage, String groupName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(//TODO:Fix
              builder: (_) => Group(
                  groupName: groupName,
                  picture: groupImage,
                 )),
        );
      },
      child: Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Material(
          elevation: 15.0,
          borderRadius: BorderRadius.circular(10),
          color: Theme
              .of(context)
              .brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: width / 4,
            child: Stack(
              children: [
                Positioned(
                  // eventboxQTS (23:34)
                  left: 0 * fem,
                  top: 0 * fem,
                  child: SizedBox(
                    height: 135 * fem,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * fem),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0 * fem,
                  left: (140 * fem),
                  child: SizedBox(
                    height: width / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Expanded(
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            groupName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.2125 * ffem / fem,
                            ),
                          ),
                          //  ),
                        ),
                        Text(
                          'Ägare: Wallsten',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.withOpacity(0.9),
                            height: 1.2125 * ffem / fem,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // wallstoeno8C (23:38)
                  left: 0 * fem,
                  top: 0 * fem,
                  child: Align(
                    child: SizedBox(
                      width: width / 3,
                      height: width / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10 * fem),
                          bottomLeft: Radius.circular(10 * fem),
                        ),
                        child: Image.asset(
                          groupImage,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}