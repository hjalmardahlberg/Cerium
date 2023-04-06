import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage(
      {Key? key,
      required this.picture,
      required this.appbar,
      required this.bottomNavigationBar})
      : super(key: key);

  final String picture;
  final AppBar appbar;
  final BottomAppBar bottomNavigationBar;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String theEventName = 'Möte med Wallsten';
    String date = '2023-03-23';
    String time = '20:00-21:00';
    String eventInfo = 'Möte med Wallsten';

    return Scaffold(
      appBar: widget.appbar,
      body: Center(
        child: Column(
          children: [
            eventImage(height, width),
            eventName(theEventName),
            dateAndTime(date, time),
            Expanded(child: eventInformation(eventInfo, height, width)),
            Expanded(child: eventParticipants()),
          ],
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Row eventParticipants() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Icon(Icons.group, size: 24),
        ),
        Text('deltagare', style: TextStyle(fontSize: 24)),
      ],
    );
  }

  SizedBox eventInformation(String eventInfo, double height, double width) {
    return SizedBox(
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
              padding: const EdgeInsets.all(8.0),
              child: Text(eventInfo, style: const TextStyle(fontSize: 20)),
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
          padding: EdgeInsets.all(20),
          child: Icon(Icons.calendar_month, size: 24),
        ),
        Text(date, style: const TextStyle(fontSize: 24)),
        const Padding(
          padding: EdgeInsets.all(10.0),
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
      child: Text(eventName, style: const TextStyle(fontSize: 24)),
    );
  }

  SizedBox eventImage(double height, double width) {
    return SizedBox(
      height: height / 4,
      child: Container(
        width: width,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xff000000))),
          color: Color(0xffffffff),
        ),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image(
            image: AssetImage(widget.picture),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
