import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.picture}) : super(key: key);

  final String picture;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, index) {
          return Container(
            height: 300,
            decoration: const BoxDecoration(
              //  borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              /* border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),*/
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          EventPage(picture: 'images/Widewallsten.jpg')),
                );
              },
              child: Center(
                child: SizedBox(
                  height: 191,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            alignment: Alignment.center,
                            child: Image.asset('images/Widewallsten.jpg',
                                fit: BoxFit.fitHeight),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Möte med Wallsten",
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
