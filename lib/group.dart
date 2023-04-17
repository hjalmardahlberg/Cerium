import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'provider.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/calendar/v3.dart' show Event;

import 'package:projecttest/profile_widget.dart';
import 'groupParticipants.dart';

class Group extends StatefulWidget {
  const Group(
      {Key? key,
      required this.groupName,
      required this.picture,
      //required this.group,
      required this.appbar,
    })
      : super(key: key);

  //final Group group;
  final String groupName;
  final String picture;
  final AppBar appbar;


  @override
  State<Group> createState() => _Group();
}

class _Group extends State<Group> {
  final chatList = List.empty(growable: true);
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: Column(
              children: [
                const Icon(Icons.group),
                const Text(
                  'Deltagare',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      GroupParticipants(
                        groupName: widget.groupName,
                      ),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Image.asset(
                "images/tempus_logo_tansp_horizontal.png",
                height: 160,
                width: 160,
              ),
              //child: Text(widget.title, style: const TextStyle(fontSize: 28)),
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
                    MaterialPageRoute(builder: (_) => ProfileWidget()));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;


    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        groupNameAndExit(),
        chatLog(),
        chatBox(),
        sendAndSyncCalenders(),
      ],
    );

    populateChatList();
    return Scaffold(
      appBar: appBar(context),
      body: body,
      //bottomNavigationBar: widget.bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }



  Stack groupNameAndExit() {
    final user = FirebaseAuth.instance.currentUser!;
    return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Text(
                widget.groupName,
                style: const TextStyle(
                    fontSize: 24.0, decoration: TextDecoration.underline),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () async {
                // Innan denna implementation fixa sådana att man är i den faktiska gruppen
                // Så man kan fetcha group name
                // Lägg till "are you sure you want to leave the group" popup innan också.
                /*
                String? groupName =

                final userData = {
                  'id': user.uid,
                  'name': user.displayName,
                  'email': user.email,
                };

                final url = 'http://192.121.208.57:8080/group/leave/' + groupName;
                final headers = {'Content-Type': 'application/json'};
                final body = jsonEncode(userData);
                //print(body.toString());
                final response =
                    await http.put(Uri.parse(url), headers: headers, body: body);

                if (response.statusCode == 200) {
                  print('Left Group successfully!');
                } else {
                  print('Error sending user data: ${response.statusCode}');
                }
                */
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

  Expanded sendAndSyncCalenders() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), // Adjust the value as needed
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              sendCalender(),
              syncCalenders(),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton syncCalenders() {
    return ElevatedButton.icon(
      onPressed: () async
      {
        final userData = {
          'g_name': "Kings only",
          'a_email': "viktorkangasniemi@gmail.com",
          'start_time': "2023-04-01T03:30:00.000Z",
          'end_time': "2023-04-01T23:30:00.000Z",
        };

        final url = "http://192.121.208.57:8080/event/sync/"+ userData["g_name"]! + '&' + userData["a_email"]! + '/' + userData["start_time"]! +'&' + userData["end_time"]!;
        final headers = {'Content-Type': 'application/json'};
        final response =
            await http.get(Uri.parse(url), headers: headers);

        print(response.body);
        print("AND DECODE: :DDDDDDDD");
        print(jsonDecode(response.body));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        Icons.sync,
        size: 24.0,
      ),
      label: const Text('sync calendars'),
    );
  }

  ElevatedButton sendCalender() {
    return ElevatedButton.icon(
      onPressed: () async {
        final provider =
        Provider.of<GoogleSignInProvider>(context, listen: false);

        // kommer fetcha första veckan i april (TEMP)
        final start = DateTime(2023, 4, 1);
        final end = DateTime(2023, 4, 7);
        final events =
            await provider.getCalendarEventsInterval(start, end);

        final eventData = {
          'start': events[0].start?.dateTime?.toIso8601String(),
          'end': events[0].end?.dateTime?.toIso8601String(),
        };

        print(jsonEncode(eventData));

        /*
        print("BODY:");
        print(jsonEncode(events));
        print("");

        for (Event event in events) {
          // print(jsonEncode(event));
          print('Event summary: ${event.summary}');
          print('Event start time: ${event.start?.dateTime}');
          print('Event end time: ${event.end?.dateTime}');
          print("");
        }
        */
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        Icons.send,
        size: 24.0,
      ),
      label: const Text('Send calendar'),
    );
  }

  Padding chatBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: myController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Send a message',
        ),
        onFieldSubmitted: (_) async {
          chatInput(myController.text);
          myController.clear();
        },
      ),
    );
  }

  Padding chatLog() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          if (index < chatList.length) {
            return chatList[index];
          }
        },
      ),
    );
  }

  void populateChatList() {
    //TODO: Servercall
  }

  chatInput(String input) {
    setState(() {
      chatList.add(Text(input));
    });
    //TODO: Sent message to others in group
  }
}


