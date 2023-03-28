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
    String eventName = 'Möte med Wallsten';
    String date ='2023-03-23';
    String time = '20:00-21:00';
    String eventInfo = 'Möte med Wallsten';

    return Scaffold(
      appBar: widget.appbar,
      body: Center(
        child: Column(
          children: [
            EventImage(height, width),
            EventName(eventName),
            DateAndTime(date,time),
            Expanded(child:EventInformation(eventInfo,height, width)),
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

  SizedBox EventInformation(String eventInfo,double height, double width) {
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
                    child: Text(eventInfo,
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ),
          );
  }

  Row DateAndTime(String date,String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.calendar_month, size: 24),
              ),
              Text(date, style: TextStyle(fontSize: 24)),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.access_time,
                  size: 24,
                ),
              ),
              Text(time, style: TextStyle(fontSize: 24))
            ],
          );
  }

  Padding EventName(String eventName) {
    return Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(eventName,
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
