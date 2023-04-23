import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../homePage.dart';
import '../refresh.dart';
import 'GroupData.dart';
import 'group.dart';

class MyGroups extends StatefulWidget {
  const MyGroups({
    super.key,
  });

  @override
  State<MyGroups> createState() => _MyGroups();
}

class _MyGroups extends State<MyGroups> {
  final Future<List<GroupData>> groupData = getGroupData();
  late Future<List<GroupData>> displayedGroupData;

  @override
  void initState() {
    super.initState();
    displayedGroupData = groupData;
  }

  double baseWidth = 390;
  double fem = 0;
  double ffem = 0;
  double width = 0;
  double height = 0;
  final TextEditingController joinGroupController = TextEditingController();
  final TextEditingController joinGroupAdminController =
      TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      //appBar: widget.appbar,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  groupText(),
                 // refreshButton(),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<GroupData>>(
                future: displayedGroupData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final groupData = snapshot.data!;
                    return buildGroups(groupData);
                  } else {
                    return const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(''));
                  }
                }),
          ),
          joinGroup(),
        ],
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  IconButton refreshButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          displayedGroupData = getGroupData();
        });
      },
      icon: const Icon(Icons.refresh),
    );
  }

  Text groupText() {
    return const Text(
      'Grupper',
      style: TextStyle(
        fontSize: 24.0, // Set the font size to 24
        decoration: TextDecoration.underline, // Underline the text
      ),
    );
  }

  void showJoinGroupFaild() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kunde inte gå med gruppen'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showJoinGroup(TextEditingController joinGroupNameController,
      TextEditingController joinGroupAdminController, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gå med i grupp'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: joinGroupNameController,
                decoration: const InputDecoration(hintText: 'Grupp namn...'),
              ),
              TextFormField(
                controller: joinGroupAdminController,
                decoration:
                    const InputDecoration(hintText: 'Grupp admins mail...'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Avbryt'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Gå med'),
              onPressed: () async {
                // do something with the text entered in the TextFormField
                String groupName = joinGroupNameController.text;
                print('Entered Text: $groupName');
                String groupAdmin = joinGroupAdminController.text;
                print('Entered Text: $groupAdmin');
                Navigator.pop(context);

                final user = FirebaseAuth.instance.currentUser!;

                final url =
                    'http://192.121.208.57:8080/group/join/$groupName&$groupAdmin';
                final userData = {
                  'id': user.uid,
                  'name': user.displayName,
                  'email': user.email,
                };
                final userBody = jsonEncode(userData);
                final headers = {'Content-Type': 'application/json'};
                final response = await http.put(Uri.parse(url),
                    headers: headers, body: userBody);
                print(response.body);
                if (response.statusCode == 200) {
                  print('User data sent successfully!');
                  setState(() {
                    displayedGroupData = getGroupData();
                  });
                } else {
                  print('Error sending user data: ${response.statusCode}');

                  showJoinGroupFaild();
                }
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
                    _showJoinGroup(
                        joinGroupController, joinGroupAdminController, context);
                  },
                  child: Text(
                    'Gå med i grupp',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
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

  Widget buildGroups(List<GroupData> groupData) => ListView.builder(
        itemCount: groupData.length,
        itemBuilder: (context, index) {
          final group = groupData[index];
          return groupBox('images/wallsten.jpg', group);
        },
      );

  Future<String> getOwnerName(group) async {
    print(group.adminEmail);
    final url = 'http://192.121.208.57:8080/user/' + group.adminEmail;

    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(Uri.parse(url), headers: headers);

    final body = json.decode(response.body);
    print(body);
    final ownerName = body['name'];
    return ownerName;
  }

  GestureDetector groupBox(String groupImage, GroupData group) {
    //  late Future<String> owner = getOwnerName(group);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Group(
                    group: group,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Material(
          elevation: 15.0,
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
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
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            group.groupName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.2125 * ffem / fem,
                            ),
                          ),
                          //  ),
                        ),
                        //TODO: Fix to be the right owner
                        Text(
                          'Ägare: Inte fixat än',

                          //'Ägare: $owner',
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
