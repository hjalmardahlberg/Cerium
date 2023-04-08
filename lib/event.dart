import 'package:flutter/material.dart';

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
      appBar: widget.appbar,
      body: Center(
        child: Column(
          children: [
            eventImage(height, width),
            eventName(widget.theEventName),
            dateAndTime(widget.date, widget.time),
            eventInformation(widget.eventInfo, height, width),
            Expanded(child: eventParticipants()),
          ],
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Row eventParticipants() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.only(left:15.0,right: 5),
          child: Icon(Icons.group, size: 30),
        ),
        Text('Deltagare', style: TextStyle(fontSize: 24)),
        Icon(Icons.group_add, size: 30),
      ],
    );
  }

  Expanded eventInformation(String eventInfo, double height, double width) {
    return Expanded(
      child: SizedBox(
        height: height / 5,
        width: width / 1.1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 15),
                child: Text(eventInfo, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row dateAndTime(String date, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Icon(Icons.calendar_month, size: 24),
        ),
        Text(date, style: const TextStyle(fontSize: 24)),
        const Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          child: Icon(
            Icons.access_time,
            size: 24,
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 24))
      ],
    );
  }

  Padding eventName(String eventName) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(eventName,
          style: const TextStyle(
              fontSize: 24, decoration: TextDecoration.underline)),
    );
  }

  SizedBox eventImage(double height, double width) {
    return SizedBox(
      height: height / 4,
      child: ClipRRect(
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0xffffffff),
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image(
              image: AssetImage(widget.picture),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
