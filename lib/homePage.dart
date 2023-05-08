import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:projecttest/fetch.dart';
import 'package:projecttest/provider.dart';

import 'Event/EventData.dart';
import 'Event/event.dart';
import 'Event/addEvent.dart';
import 'Groups/GroupData.dart';
import 'Groups/myGroups.dart';
import 'Groups/addGroup.dart';
import 'profilePage.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.pageIndex});

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

  late Future<List<GroupData>> groupData;
  late Future<List<EventData>> eventData;

  @override
  void initState() {
    super.initState();
    eventData = getEventData();
    groupData = getGroupData();
  }

  @override
  Widget build(BuildContext context) {
    //Sizes
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    //appbar
    final appbar = homeAppBar();

    //bottomNavigationBar

    PageController _pageController =
        PageController(initialPage: widget.pageIndex);
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
            child: MyGroups(groupData: groupData),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        currentIndex: _currentIndex,
        items: _bottomNavigationBarItems,
        onTap: (index) async {
          if (index == 1) {
            bool? result = _currentIndex == 0
                ? await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddEventPage(
                              appbar: homeAppBar(),
                            )),
                  )
                : await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddGroupPage(
                              appbar: homeAppBar(),
                            )),
                  );
            if (result != null && result) {
              setState(() {
                groupData = getGroupData();
                eventData = getEventData();
                _currentIndex = 0;
                _pageController.animateToPage(_currentIndex,
                    duration: const Duration(microseconds: 500),
                    curve: Curves.ease);
              });
            } else {
              // do something else if the group was not successfully added
            } // set current index to middle page index
          } else {
            _pageController.animateToPage(index,
                duration: const Duration(microseconds: 500),
                curve: Curves.ease);
          }
        },
      ), //bottomAppBar,
    );
  }

  Future<void> refreshEvent() async {
    setState(() {
      eventData = getEventData();
    });
  }



  Widget buildGroups(List<EventData> eventData) => RefreshIndicator(
        onRefresh: refreshEvent,
        child: ListView.builder(
          itemCount: eventData.length,
          itemBuilder: (context, index) {
            final event = eventData[index];
            String date_to_disp = event.start.substring(0, event.start.indexOf('T'));

            DateTime start_date = DateTime.parse(event.start);
            DateTime end_date = DateTime.parse(event.end);
            print("startDate:"+ start_date.toString());
            print("today:" + DateTime.now().toString());

            if(start_date.isBefore(DateTime.now())){
              deleteEvent(event);
              refreshEvent();
            }
            else{
             String time_to_disp = start_date.hour.toString().padLeft(2, '0') + ':' + start_date.minute.toString().padLeft(2, '0') + ' - ' + end_date.hour.toString().padLeft(2, '0') + ':' + end_date.minute.toString().padLeft(2, '0');

             return eventBox(event, date_to_disp, time_to_disp);
            }
          },
        ),
      );

  Column MyEvents() {
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: width / 7),
                  child: eventText(),
                ),
              ),
            ),
            //      Padding(
            // padding: EdgeInsets.only(top: 5),
            IconButton(
              padding: const EdgeInsets.only(bottom: 0, top: 10),
              icon: Column(
                children: const [
                  Icon(Icons.ios_share),
                  Text(
                    "Exportera",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
              onPressed: () async {
                List<EventData> ev_lst = await eventData;
                final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

                for(EventData event in ev_lst){
                  print("HELLLOOOOOO HAHAHAHAHA");
                  print(event.name);
                  print(event.start);
                  print(event.end);
                  provider.exportEventToGoogleCal(event.name, event.description, event.start, event.end);
                }
              },
              //  ),
            ),
          ],
        ),
      ),
      Expanded(
        child: FutureBuilder<List<EventData>>(
            future: eventData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final eventData = snapshot.data!;
                return buildGroups(eventData);
              } else {
                return const Padding(
                    padding: EdgeInsets.only(top: 10), child: Text(''));
              }
            }),
      ),
    ]);
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
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

  GestureDetector eventBox(EventData event,String date,String time) {
    Future<Uint8List>? image;
    if (event.image == "null") {
      List <String> group = event.group.split(':');
      print('g_id: ' + event.group);
      print('group' + group.toString());
      image = getEventImage(event.name, group[2].split(' ')[1].split(',')[0], group[3].split(' ')[1].split(',')[0]);
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EventPage(
                    picture: event.image,
                    appbar: homeAppBar(),
                    theEventName: event.name,
                    eventInfo: event.description,
                    date: event.date,
                    time: event.start + event.end,
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
                            event.name,
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
                                  date,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Kl: $time',
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
                        child: event.image == "null"
                            ? FutureBuilder<Uint8List>(
                                future: image,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.done) {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                          left: (width / 3) / 3.5,
                                          top: (width / 4) / 3.5,
                                        ),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 1,
                                          backgroundColor: Colors.blue,
                                        ));
                                  } else {
                                    if (snapshot.hasData) {
                                      final groupImage = snapshot.data!;
                                      print(event.image);

                                      event.addImage(
                                          String.fromCharCodes(groupImage));
                                      print(event.image);
                                      final List<int> imageList =
                                          event.image.codeUnits;
                                      final Uint8List unit8List =
                                          Uint8List.fromList(imageList);
                                      return SizedBox(
                                          width: width / 3,
                                          height: width / 4,
                                          child: Image.memory(
                                            unit8List,
                                            fit: BoxFit.cover,
                                          ));
                                    } else {
                                      print("no group image, temp used");
                                      event.addImage( "images/wallsten.jpg");
                                      return SizedBox(
                                        width: width / 3,
                                        height: width / 4,
                                        child: Image.asset(
                                          "images/wallsten.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                  }
                                })
                            :
                        event.image == "images/wallsten.jpg" ?
                        SizedBox(
                          width: width / 3,
                          height: width / 4,
                          child: Image.asset(
                            "images/wallsten.jpg",
                            fit: BoxFit.cover,
                          ),
                        )
                        :SizedBox(
                                width: width / 3,
                                height: width / 4,
                                child: Image.memory(
                                  Uint8List.fromList(event.image.codeUnits),
                                  fit: BoxFit.cover,
                                ),
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
