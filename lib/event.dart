import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import 'eventParticipants.dart';

class EventPage extends StatefulWidget {
  const EventPage(
      {Key? key,
      required this.picture,
      required this.appbar,
      required this.bottomNavigationBar,
      required this.theEventName,
      required this.eventInfo,
      required this.date,
      required this.time})
      : super(key: key);

  final String picture;
  final AppBar appbar;
  final BottomAppBar bottomNavigationBar;
  final String theEventName;
  final String eventInfo;
  final String date;
  final String time;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eventImage(height, width),
          eventName(widget.theEventName),
          dateAndTime(widget.date, widget.time),
          eventInformation(widget.eventInfo, height, width),
        ],
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
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
            content: Text('Please fill in all fields.'),
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

  IconButton schemaSyncButton() {
    return IconButton(
      onPressed: () async {
        _handleschemasyncButtonPressed("mitt schema");
      },
      icon: const Icon(
        Icons.sync_rounded,
        size: 24.0,
      ),
    );
  }

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.group),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      EventParticipants(
                    eventName: widget.theEventName,
                    bottomNavigationBar: widget.bottomNavigationBar,
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

  Expanded eventInformation(String eventInfo, double height, double width) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(15),
                  //color: Theme.of(context).appBarTheme.foregroundColor,
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

  Row dateAndTime(String date, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
          child: Icon(Icons.calendar_month, size: 24),
        ),
        Text(date, style: const TextStyle(fontSize: 24)),
        const Padding(
          padding: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
          child: Icon(
            Icons.access_time,
            size: 24,
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 24)),
        Visibility(
          visible: date == null || time == null,
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: schemaSyncButton(),
          ),
        ),
      ],
    );
  }

  Padding eventName(String eventName) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10),
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
