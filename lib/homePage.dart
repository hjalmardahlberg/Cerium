import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';

//import 'package:google_fonts/google_fonts.dart';
import 'event.dart';
import 'addEvent.dart';
import 'myGroups.dart';
import 'addGroup.dart';
import 'profile_widget.dart';
import 'provider.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/calendar/v3.dart' show Event;

import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

//import 'package:jwt_decoder/jwt_decoder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> eventList = <Widget>[];
  final double baseWidth = 390;
  double fem = 0;
  double ffem = 0;
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    //Event list

    //Sizes
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    //appbar
    final appbar = groupAppBar(context, '');

    //bottomNavigationBar
    final bottomNavigationBar = finalBottomAppBar(context, 'MyHomePage');

    return Scaffold(
      appBar: appbar,
      body: Column(
        children: [
          eventText(),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: eventList[index],
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              addToList(
                  'images/edvard_inception.png',
                  'Det ska tittas serier med frugan',
                  '2023-03-23',
                  '17:00',
                  'Möte med Frugan'),
              const SizedBox(
                width: 5,
              ),
              addToList(
                  'images/wallsten.jpg',
                  'Möte med Wallsten om viktiga saker',
                  '2023-03-23',
                  '14:00',
                  'Möte med Wallsten'),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      eventList = [];
                    });
                  },
                  child: const Text('Rensa events'))
            ],
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  ElevatedButton addToList(image, info, date, time, name) {
    return ElevatedButton(
        onPressed: () async {
          final groupData = {
            "image": image,
            "info": info,
            "date": date,
            "time": time,
            "name": name,
          };
          final body = jsonEncode(groupData);
          jsonDecoder(body);
        },
        child: const Text('skicka event!'));
  }

  void jsonDecoder(String test) {
    final result = jsonDecode(test);
    print(
      result['name'],
    );
    setState(() {
      eventList.add(eventBox(
          result['image'],
          result['info'],
          result['date'],
          result['time'],
          result['name'],
          fem,
          ffem,
          width,
          height,
          homeAppBar(),
          finalBottomAppBar(context, 'event'),
          context));
    });
  }

  Center eventText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          'Events',
          style: TextStyle(
            fontSize: 24.0,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  //AppBar that takes you back to group screen
  AppBar groupAppBar(context, String page) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.group),
            iconSize: 30,
            onPressed: () {
              if (page == 'addGroup') {
                Navigator.pop(context);
              } else {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => MyGroups(
                      title: 'Groups',
                      appbar: homeAppBar(),
                      appbar2: groupAppBar(context, 'addGroup'),
                      bottomNavigationBar: finalBottomAppBar(context, 'MyGroups'),
                    ),
                    transitionDuration: Duration.zero,
                  ),
                );
              }
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

  //AppBar that takes you back to event screen
  AppBar homeAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      // backgroundColor: const Color.fromARGB(255, 153, 255, 255),
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.home),
            iconSize: 30,
            onPressed: () {

              Navigator.pop(context, MyHomePage(title: 'title'));

              

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

  BottomAppBar finalBottomAppBar(BuildContext context, String pageName) {
    final user = FirebaseAuth.instance.currentUser!;
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.event),
            onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              final events = await provider.getPrimaryCalendarEvents();

              for (Event event in events) {
                //print('Event ID: ${event.id}');
                print('Event summary: ${event.summary}');
                print('Event start time: ${event.start?.dateTime}');
                print('Event end time: ${event.end?.dateTime}');
                //print('Event location: ${event.location}');
                //print('Event description: ${event.description}');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.hail_rounded),
            onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);

              if (pageName != 'AddEventPage') {
                // kommer fetcha första veckan i april (TEMP)
                final start = DateTime(2023, 4, 1);
                final end = DateTime(2023, 4, 7);
                final events =
                    await provider.getCalendarEventsInterval(start, end);

                print("BODY:");
                print(events);
                print("");
                for (Event event in events) {
                  //print('Event ID: ${event.id}');
                  print('Event summary: ${event.summary}');
                  print('Event start time: ${event.start?.dateTime}');
                  print('Event end time: ${event.end?.dateTime}');
                  //print('Event location: ${event.location}');
                  //print('Event description: ${event.description}');
                  print("");
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () async {
              final userData = {
                'id': user.uid,
                'name': user.displayName,
                'email': user.email,
              };

              const url = 'http://192.121.208.57:8080/save';
              final headers = {'Content-Type': 'application/json'};
              final body = jsonEncode(userData);
              //print(body.toString());
              final response =
                  await http.post(Uri.parse(url), headers: headers, body: body);

              if (response.statusCode == 200) {
                print('User data sent successfully!');
              } else {
                print('Error sending user data: ${response.statusCode}');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (pageName == 'MyGroups') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddGroupPage(
                          appbar: groupAppBar(context, 'addGroup'),
                          bottomNavigationBar:
                              finalBottomAppBar(context, 'AddGroupPage'))),
                );
              } else if (pageName != 'AddEventPage') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEventPage(
                          appbar: homeAppBar(),
                          bottomNavigationBar:
                              finalBottomAppBar(context, 'AddEventPage'))),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              //TEMP LOGIN BUTTON!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
          ),
        ],
      ),
    );
  }
}

Container eventBox(
    String eventImage,
    String eventInfo,
    String eventDate,
    String eventTime,
    String eventName,
    double fem,
    double ffem,
    double width,
    double height,
    appbar,
    bottomNavigationBar,
    context) {
  return Container(
    // event3JfJ (23:33)
    margin: EdgeInsets.fromLTRB(width / 12, 10 * fem, 0 * fem, 10 * fem),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EventPage(
                    picture: eventImage,
                    appbar: appbar,
                    bottomNavigationBar: bottomNavigationBar,
                    theEventName: eventName,
                    eventInfo: eventInfo,
                    date: eventDate,
                    time: eventTime,
                  )),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 138.5 * fem,
        child: Stack(
          children: [
            Positioned(
              // eventboxQTS (23:34)
              left: 0 * fem,
              top: 0 * fem,
              child: Align(
                child: SizedBox(
                  width: 325 * fem,
                  height: 135 * fem,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20 * fem),
                      border: Border.all(color: const Color(0xff000000)),
                      color: Theme.of(context).appBarTheme.backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // tidWFa (23:35)
              left: 19 * fem,
              top: 116 * fem,
              child: Align(
                child: SizedBox(
                  width: 85 * fem,
                  height: 15 * fem,
                  child: Text(
                    'Tid och datum:',
                    style: TextStyle(
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // kl1400okU (23:36)
              left: 105 * fem,
              top: 116 * fem,
              child: Align(
                child: SizedBox(
                  width: 122 * fem,
                  height: 15 * fem,
                  child: Text(
                    '$eventTime $eventDate',
                    style: TextStyle(
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // mtemedwallstenuHi (23:37)
              left: 19 * fem,
              top: 100 * fem,
              child: Align(
                child: SizedBox(
                  width: 109 * fem,
                  height: 15 * fem,
                  child: Text(
                    eventName,
                    style: TextStyle(
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // wallstoeno8C (23:38)
              left: 0 * fem,
              top: 0 * fem,
              child: Align(
                child: SizedBox(
                  width: 325 * fem,
                  height: 95 * fem,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20 * fem),
                      topRight: Radius.circular(20 * fem),
                    ),
                    child: Image.asset(
                      eventImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
