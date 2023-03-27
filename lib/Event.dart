import 'package:flutter/cupertino.dart';
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
    return Scaffold(
      appBar: widget.appbar,
      body: Center(
        child: Column(
          children: [
            EventImage(height, width),
            EventName(),
            DateAndTime(),
            Expanded(child:EventInformation(height, width)),
            Expanded(child:EventParticipants()),
          ],
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Row EventParticipants() {
    return Row(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(Icons.group, size: 24),
              ),
              Text('deltagare', style: TextStyle(fontSize: 24)),
            ],
          );
  }

  SizedBox EventInformation(double height, double width) {
    return SizedBox(
            height: height/5,
            width: width/1.1,
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
                    padding: EdgeInsets.all(8.0),
                    child: Text("Möte med Wallsten",
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ),
          );
  }

  Row DateAndTime() {
    return Row(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.calendar_month, size: 24),
              ),
              Text('2023-03-23', style: TextStyle(fontSize: 24)),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.access_time,
                  size: 24,
                ),
              ),
              Text('20:00-21:00', style: TextStyle(fontSize: 24))
            ],
          );
  }

  Padding EventName() {
    return Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: const Text('Möte med Wallsten',
                style: TextStyle(fontSize: 24)),
          );
  }

  SizedBox EventImage(double height, double width) {
    return SizedBox(
            height: height/4,
              child: FittedBox(
                fit:BoxFit.cover,
                child: Image(image: AssetImage(widget.picture),fit:BoxFit.cover,),
              ),
          );
  }
}
