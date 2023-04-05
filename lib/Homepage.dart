import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'Event.dart';
import 'addEvent.dart';
import 'MyGroups.dart';
import 'profile_widget.dart';
import 'provider.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/calendar/v3.dart' show Event;

import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

import 'package:jwt_decoder/jwt_decoder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> eventList = <Widget>[];
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final appbar = finalAppBar();

    final bottomNavigationBar = finalBottomAppBar(context, 'MyHomePage');

    eventList.add(EventBox(
        'images/wallsten.jpg',
        '2023-03-23  kl:14:00',
        'Möte med Wallsten',
        fem,
        ffem,
        width,
        height,
        appbar,
        bottomNavigationBar,
        context));
    eventList.add(EventBox(
        'images/edvard_inception.png',
        '2023-03-23  kl:17:00',
        'Möte med Frugan',
        fem,
        ffem,
        width,
        height,
        appbar,
        bottomNavigationBar,
        context));

    return Scaffold(
      appBar: appbar,
      body: ListView(
        children: eventList,
      ),
      bottomNavigationBar: bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  AppBar finalAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 153, 255, 255),
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              padding: EdgeInsets.all(5),
              icon: Icon(Icons.group),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MyGroups(title: 'Groups',appbar: finalAppBar(),bottomNavigationBar: finalBottomAppBar(context, 'MyGroups'),)));
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Image.asset("images/tempus_logo_tansp_horizontal.png",
              height: 160,
              width: 160,
              ),
              //child: Text(widget.title, style: const TextStyle(fontSize: 28)),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.person),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                builder: (_) => ProfileWidget()));
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
            icon: Icon(Icons.event),
            onPressed: () async {
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              final events = await provider.getPrimaryCalendarEvents();

              for (Event event in events) {
                //print('Event ID: ${event.id}');
                print('Event summary: ${event.summary}');
                print('Event start time: ${event.start?.dateTime}');
                print('Event end time: ${event.end?.dateTime}');
                //print('Event location: ${event.location}');
                //print('Event description: ${event.description}');
              }

              /*
              String? events;
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              try {
                events = await provider.getCalendarEvents();
              }catch(e){
                print(e.toString());
              }
              print(events);
              */
            },
          ),
          IconButton(
            icon: Icon(Icons.hail_rounded),
            onPressed: () async{
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

              if (pageName != 'AddEventPage') {
                // kommer fetcha första veckan i april (TEMP)
                final start = DateTime(2023, 4, 1);
                final end = DateTime(2023, 4, 7);
                final events = await provider.getCalendarEventsInterval(start, end);

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
            icon: Icon(Icons.arrow_upward),
            onPressed: () async{

              final userData = {
                'id': user.uid,
                'name' :user.displayName,
                'email' : user.email,
              };

              final url = 'http://192.121.208.57:8080/save';
              final headers = {'Content-Type': 'application/json'};
              final body = jsonEncode(userData);
              //print(body.toString());
              final response = await http.post(Uri.parse(url),headers: headers, body: body);

              if (response.statusCode == 200){
                print('User data sent successfully!');
              }else{
                print('Error sending user data: ${response.statusCode}');
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (pageName != 'AddEventPage') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEventPage(
                          appbar: finalAppBar(),
                          bottomNavigationBar:
                              finalBottomAppBar(context, 'AddEventPage'))),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () { //TEMP LOGIN BUTTON!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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

Container EventBox(
    String eventImage,
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
                  bottomNavigationBar: bottomNavigationBar)),
        );
      },
      child: Container(
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
                      border: Border.all(color: Color(0xff000000)),
                      color: Color(0xffffffff),
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
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // kl1400okU (23:36)
              left: 113 * fem,
              top: 116 * fem,
              child: Align(
                child: SizedBox(
                  width: 122 * fem,
                  height: 15 * fem,
                  child: Text(
                    eventTime,
                    style: TextStyle(
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000),
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
                      color: Color(0xff000000),
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
  );
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade800,
        title: const Text('Create'),
      ),
      body:
          const Center(child: Image(image: AssetImage('images/wallsten.jpg'))),
    );
  }
}
