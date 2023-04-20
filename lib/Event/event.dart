import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import '../Theme/themeConstants.dart';
import 'eventParticipants.dart';

class EventPage extends StatefulWidget {
  const EventPage(
      {Key? key,
      required this.picture,
      required this.appbar,
      required this.theEventName,
      required this.eventInfo,
      required this.date,
      required this.time})
      : super(key: key);

  final String picture;
  final AppBar appbar;
  final String theEventName;
  final String eventInfo;
  final String date;
  final String time;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  double sidePadding = 15;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeManager = Provider.of<ThemeManager>(context);


    return Scaffold(
      appBar: appBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eventImage(height, width),
          eventName(widget.theEventName),
          dateAndTime(widget.date, widget.time),
          eventInformation(widget.eventInfo, height, width, themeManager),
        ],
      ),
      //bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  void _handleschemasyncButtonPressed(schema) async {
    if (schema != null && widget.date == null && widget.time == null) {
      final schemaData = {
        'schema': schema,
      };
      const url = 'http://192.121.208.57:8080/save';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(schemaData);
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('User data sent successfully!');
      } else {
        print('Error sending user data: ${response.statusCode}');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Här ska man skicka in sitt schema sen'),
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

  AppBar appBar(context) {
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
              //child: Text(widget.title, style: const TextStyle(fontSize: 28)),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.only(top:10,bottom: 10,left:sidePadding,right:sidePadding),
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

  Expanded eventInformation(
      String eventInfo, double height, double width, themeManager) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top:10,bottom: 10,left:sidePadding,right:sidePadding),
        child: SizedBox(
          height: height / 5,
          width: width,
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  color: themeManager.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 15),
                    child:
                        Text(eventInfo, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding dateAndTime(String date, String time) {
    return Padding(
      padding: EdgeInsets.only(top:10,left:sidePadding,right:sidePadding),
      child: Row(
        children: [
          Icon(Icons.calendar_month, size: 24),
          Text(date, style: const TextStyle(fontSize: 24)),
          Icon(
            Icons.access_time,
            size: 24,
          ),
          Text(time, style: const TextStyle(fontSize: 24)),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Column(
                  children: const [
                    Icon(Icons.group),
                    Text(
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
                          EventParticipants(
                        eventName: widget.theEventName,
                      ),
                      transitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding eventName(String eventName) {
    return Padding(
      padding: EdgeInsets.only(top:5,left:sidePadding,right:sidePadding),
      child: Text(eventName, style: const TextStyle(fontSize: 24)),
    );
  }

  SizedBox eventImage(double height, double width) {
    return SizedBox(
      height: height / 3,
      child: ClipRRect(
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            //border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0xffffffff),
          ),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image(
              image: AssetImage(widget.picture),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
