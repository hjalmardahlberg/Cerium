import 'dart:convert';

import 'package:flutter/material.dart';

import 'Event/event.dart';
import 'Event/addEvent.dart';
import 'Groups/myGroups.dart';
import 'Groups/addGroup.dart';
import 'profile_widget.dart';


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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //Event list

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
    final appbar = groupAppBar(context, '');

    //bottomNavigationBar

    PageController _pageController = PageController(initialPage: 0);
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
            child: MyGroups(
              title: 'Groups',
              appbar: homeAppBar(),
              appbar2: groupAppBar(context, 'addGroup'),
            ),
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

  Column MyEvents() {
    return Column(
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
            },
          ),
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
                'Möte med Wallsten om viktiga saker.',
                '2023-03-23',
                '14:00',
                'Möte ned Wallsten'),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    eventList = [];
                  });
                },
                child: const Text('Rensa events')),

          ],
        ),
      ],
    );
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
          context));
    });
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

  //AppBar that takes you back to group screen
  AppBar groupAppBar(context, String page) {
    return AppBar(
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          /*  IconButton(
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
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        MyGroups(
                      title: 'Groups',
                      appbar: homeAppBar(),
                      appbar2: groupAppBar(context, 'addGroup'),
                      bottomNavigationBar:
                          finalBottomAppBar(context, 'MyGroups'),
                    ),
                    transitionDuration: Duration.zero,
                  ),
                );
              }
            },
          ),*/
          Expanded(
            flex: 1,
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
      automaticallyImplyLeading: true,
      titleSpacing: 0,
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
                    MaterialPageRoute(builder: (_) => ProfileWidget()));
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
      double fem,
      double ffem,
      double width,
      double height,
      appbar,
      context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  EventPage(
                    picture: eventImage,
                    appbar: appbar,
                    theEventName: eventName,
                    eventInfo: eventInfo,
                    date: eventDate,
                    time: eventTime,
                  )),
        );
      },
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
    );
  }
}
