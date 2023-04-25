import 'dart:convert';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttest/Event/addEvent.dart';
import 'package:projecttest/profile_widget.dart';
import '../Theme/themeConstants.dart';
import 'package:provider/provider.dart';
import '../homePage.dart';
import 'GroupData.dart';
import 'groupChat.dart';
import 'package:http/http.dart' as http;

import 'groupParticipnats.dart';

class Group extends StatefulWidget {
  const Group({
    Key? key,
    required this.group,
  }) : super(key: key);

  final GroupData group;
  //final String admin;
  //final String groupName;
  //final String picture;

  @override
  State<Group> createState() => _Group();
}

class _Group extends State<Group> {
  final user = FirebaseAuth.instance.currentUser!;
  late Future<List<GroupParticipants>> groupParticipants;

  @override
  void initState() {
    super.initState();
    groupParticipants =
        getGroupParticipants(widget.group.adminEmail, widget.group.groupName);
  }

  static Future<List<GroupParticipants>> getGroupParticipants(
      admin, groupName) async {
    final url =
        'http://192.121.208.57:8080/groups/users/' + groupName + '&' + admin;

    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(Uri.parse(url), headers: headers);

    final body = json.decode(response.body);

    print(response.body);

    return body.map<GroupParticipants>(GroupParticipants.fromJson).toList();
  }

  AppBar appBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.white,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Center(
              child: Image.asset(
                "images/tempus_logo_tansp_horizontal.png",
                height: 160,
                width: 160,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: const EdgeInsets.all(10),
              icon: const Icon(Icons.settings),
              iconSize: 30,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileWidget()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> showDeleteGroup() async {
    bool success = true;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Du är ägare av gruppen om du lämnar kommer den att försvinna. \n Är du fortfarande säker på att du vill lämna gruppen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Avbryt'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Lämna',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                final url = 'http://192.121.208.57:8080/group/delete/' +
                    widget.group.groupName;

                final headers = {'Content-Type': 'application/json'};
                final userData = {
                  'id': user.uid,
                  'name': user.displayName,
                  'email': user.email,
                };
                final userBody = jsonEncode(userData);

                final response = await http.delete(Uri.parse(url),
                    headers: headers, body: userBody);
                print(response.body);
                if (response.statusCode == 200) {
                  print('User data sent successfully!');
                  Navigator.of(context).pop();
                } else {
                  print('Error sending user data: ${response.statusCode}');
                  success = false;
                }
              },
            ),
          ],
        );
      },
    );
    return success;
  }

  Future<bool> _showLeaveGroup(context) async {
    bool success = true;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Är du säker på att du vill lämna gruppen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Avbryt'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Lämna',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.pop(context);
                final user = FirebaseAuth.instance.currentUser!;
                print(widget.group.groupName);
                final url = 'http://192.121.208.57:8080/group/leave/' +
                    widget.group.groupName +
                    '&' +
                    widget.group.adminEmail;
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
                } else {
                  print('Error sending user data: ${response.statusCode}');
                  success = false;
                }
              },
            ),
          ],
        );
      },
    );
    return success;
  }

  double baseWidth = 390;
  double fem = 0;
  double ffem = 0;
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final themeManager = Provider.of<ThemeManager>(context);

    Expanded profiler() {
      return Expanded(
        child: SizedBox(
          height: height,
          child: FutureBuilder<List<GroupParticipants>>(
              future: groupParticipants,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final groupParticipants = snapshot.data!;
                  return buildParticipantsList(groupParticipants);
                } else {
                  return const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text('Error...'));
                }
              }),
        ),
      );
    }

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        groupNameAndExit(),
        const Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text("Deltagare")),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: TextButton.icon(
                onPressed: () {
                  // Do something when the button is pressed
                },
                icon: Icon(Icons.add_circle_outline,
                    color:
                        themeManager.isDarkMode ? Colors.white : Colors.black),
                label: Text('Lägg till deltagare',
                    style: TextStyle(
                      color:
                          themeManager.isDarkMode ? Colors.white : Colors.black,
                    )),
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text('Senaste\nuppdatering',
                    textAlign: TextAlign.end, style: TextStyle(fontSize: 20)),
              ),
            )
          ],
        ),
        const Divider(color: Colors.grey),
        profiler(),
        createEventAndChat(),
      ],
    );

    return Scaffold(
      appBar: appBar(),
      body: body,
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }

  ElevatedButton goToChat() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => GroupChat(
              groupAdmin: widget.group.adminEmail,
              groupName: widget.group.groupName,
              userName: user.displayName.toString(),
            ),
            transitionDuration: Duration.zero,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        CupertinoIcons.chat_bubble_fill,
        color: Colors.white,
      ),
      label: const Text(
        'chattrum ',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Stack groupNameAndExit() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 5),
          child: Center(
            child: Text(
              widget.group.groupName,
              style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () async {
              bool success = false;
              print(widget.group.adminEmail);
              print(user.email);
              if (widget.group.adminEmail == user.email) {
                success = await showDeleteGroup();
              } else {
                success = await _showLeaveGroup(context);
              }
              print(success);
              if (success) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(
                            pageIndex: 2,
                          )),
                );
              }
            },
            icon: const Icon(
              Icons.exit_to_app_outlined,
              size: 30.0,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Container createEventAndChat() {
    return Container(
      margin: const EdgeInsets.only(
          top: 8, bottom: 16), // Adjust the value as needed
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            createEvent(),
            goToChat(),
          ],
        ),
      ),
    );
  }

  ElevatedButton syncCalenders() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        Icons.sync,
        size: 24.0,
      ),
      label: const Text('Synchronisera kalender'),
    );
  }

  ElevatedButton createEvent() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AddEventPage(
                    appbar: appBar(),
                    group: widget.group,
                  )),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        Icons.add,
        size: 24.0,
      ),
      label: const Text('Skapa Event'),
    );
  }

  SizedBox profileBox(name, image) {
    return SizedBox(
      width: double.infinity,
      height: width / 6,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(image),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              name,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 1.2125 * ffem / fem,
              ),
            ),
            Expanded(
              child: Text("27/03",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.2125 * ffem / fem,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildParticipantsList(List<GroupParticipants> participantData) =>
      ListView.builder(
        itemCount: participantData.length,
        itemBuilder: (context, index) {
          final participant = participantData[index];
          return profileBox(participant.participantName, 'images/wallsten.jpg');
        },
      );
}
