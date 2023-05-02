import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecttest/fetch.dart';

import 'Event/EventData.dart';
import 'Event/event.dart';
import 'Event/addEvent.dart';
import 'Groups/GroupData.dart';
import 'Groups/myGroups.dart';
import 'Groups/addGroup.dart';
import 'profile_widget.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,required this.pageIndex});

  final int pageIndex;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double baseWidth = 390;
  double fem = 0;
  double ffem = 0;
  double width = 0;
  double height = 0;
  int _currentIndex = 0;

  Future<List<EventData>> eventData = getEventData();

  @override
  void initState() {
    super.initState();
    eventData = getEventData();
  }


  @override
  Widget build(BuildContext context) {
    //Sizes
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

    //appbar
    final appbar = homeAppBar();

    //bottomNavigationBar

    PageController _pageController = PageController(initialPage: widget.pageIndex);
    final _bottomNavigationBarItems = [
      const BottomNavigationBarItem(
          icon: Icon(Icons.event),
          backgroundColor: Colors.white,
          label: 'Event'),
      BottomNavigationBarItem(
        icon: const Icon(Icons.add),
        label: _currentIndex == 0 ? 'Lägg till event' : 'Lägg till grupp',
      ),
      const BottomNavigationBarItem(
          icon: Icon(Icons.group),
          backgroundColor: Colors.white,
          label: 'Grupper')
    ];

    return Scaffold(
      appBar: appbar,
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex * 2;
          });
        },
        children: [
          Container(
            decoration: _currentIndex == 2
                ? const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            )
                : null,
            child: MyEvents(),
          ),
          Container(
            decoration: _currentIndex == 0
                ? const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            )
                : null,
            child: MyGroups(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        backgroundColor: Theme
            .of(context)
            .brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        currentIndex: _currentIndex,
        items: _bottomNavigationBarItems,
        onTap: (index) {
          if (index == 1) {
            // middle item
            setState(() {
              _currentIndex == 0
                  ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AddEventPage(
                          appbar: homeAppBar(),
                        )),
              )
                  : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AddGroupPage(
                          appbar: homeAppBar(),
                        )),
              ); // set current index to middle page index
            });
          } else {
            _pageController.animateToPage(index,
                duration: const Duration(microseconds: 500),
                curve: Curves.ease);
          }
        },
      ), //bottomAppBar,
    );
  }

  Widget buildGroups(List<EventData> eventData) =>
      ListView.builder(
        itemCount: eventData.length,
        itemBuilder: (context, index) {
          final event = eventData[index];
          return eventBox('images/wallsten.jpg','Info','TBD','TBD',event.event_name);
        },
      );


  Column MyEvents() {
    return Column(
      children: [
        eventText(),
        Expanded(
          child: FutureBuilder<List<EventData>>(
              future: eventData, builder: (context, snapshot) {
            if (snapshot.hasData) {
              final eventData = snapshot.data!;
              return buildGroups(eventData);
            }
            else {
              return const Padding(padding:EdgeInsets.only(top:10), child:Text(''));
            }
          }),
        ),
        TextButton( onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    EventPage(
                      picture: 'images/wallsten.jpg',
                      appbar: homeAppBar(),
                      theEventName: 'EventName',
                      eventInfo: 'eventInfo',
                      date: 'TBD',
                      time: 'TBD',
                    )),
          );
        },child: const Text('Event page'))
    ]
    );
  }


  Center eventText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          'Event',
          style: TextStyle(
            fontSize: 24.0,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  //AppBar that takes you back to event screen
  AppBar homeAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      backgroundColor:Theme
          .of(context)
          .brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.white,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
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
                    MaterialPageRoute(builder: (_) => const ProfileWidget()));
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector eventBox(String eventImage,
      String eventInfo,
      String eventDate,
      String eventTime,
      String eventName,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  EventPage(
                    picture: eventImage,
                    appbar: homeAppBar(),
                    theEventName: eventName,
                    eventInfo: eventInfo,
                    date: eventDate,
                    time: eventTime,
                  )),
        );
      },
    child: Padding(padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                top: 10 * fem,
                left: (140 * fem),
                child: SizedBox(
                  height: width / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          eventName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.2125 * ffem / fem,
                          ),
                        ),
                        //  ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventDate,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2125 * ffem / fem,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Kl: $eventTime',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    ),
    );
  }
}
