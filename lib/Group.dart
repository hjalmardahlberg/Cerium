import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'Event.dart';

class Group extends StatefulWidget {
  const Group({super.key, required  this.groupName});

  final String groupName;

  @override
  State<Group> createState() => _Group();
}

class _Group extends State<Group> {
  final chatList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final appbar = AppBar(
      backgroundColor: Colors.red.shade800,
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              padding: EdgeInsets.all(5),
              icon: Icon(Icons.group),
              iconSize: 50,
              onPressed: () {},
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(widget.groupName, style: const TextStyle(fontSize: 28)),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.person),
              iconSize: 50,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );

    final bottomNavigationBar = BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.event),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NextPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {},
          ),
        ],
      ),
    );
    //TODO: Create function populateChatList which fills the chatList with old messages stored locally
    chatList.add("Hej");
    return Scaffold(
      appBar: appbar,
      body: ListView.builder(
        itemBuilder: (_, index) {
          if(index<chatList.length) {
            return chatList[index];
          }
        },
      ),
      bottomNavigationBar: bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade800,
        title: const Text('Create'),
      ),
      body:
      const Center(child: Image(image: AssetImage('images/wallsten.jpg'))),
    );
  }
}
