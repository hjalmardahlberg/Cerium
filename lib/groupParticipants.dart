import 'dart:io';


import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import 'package:provider/provider.dart';
import 'Theme/themeConstants.dart';

class GroupParticipants extends StatefulWidget {
  const GroupParticipants({Key? key,
    required this.groupName,
    required this.bottomNavigationBar})
      : super(key: key);

  //final Group group;
  final String groupName;
  final BottomAppBar bottomNavigationBar;

  @override
  State<GroupParticipants> createState() => _GroupParticipants();
}

class _GroupParticipants extends State<GroupParticipants> {
  List<Widget> groupList = <Widget>[];

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 0,
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

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    double baseWidth = 390;
    double fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;


    Padding groupName() {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Center(
          child: Text(
            widget.groupName,
            style: const TextStyle(
                fontSize: 24.0, decoration: TextDecoration.underline),
          ),
        ),
      );
    }

    SizedBox profileBox(name, image) {
      return SizedBox(
        width: double.infinity,
        height: width / 6,
        child: Row(
          children: [
            Padding(
              // wallstoeno8C (23:38)
              padding: EdgeInsets.only(left: 0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(image),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              name,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 1.2125 * ffem / fem,
              ),
            ),
          ],
        ),
      );
    }

    groupList.add(profileBox("Wallsten", 'images/wallsten.jpg'));

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        groupName(),
        const Padding(padding: EdgeInsets.only(left: 20, top: 20),
            child: Text("Deltagare")),
        Padding(padding: const EdgeInsets.only(left: 20, top: 10),
          child: TextButton.icon(
            onPressed: () {
              // Do something when the button is pressed
            },
            icon: Icon(Icons.add_circle_outline,
                color: themeManager.isDarkMode ? Colors.white : Colors.black),
            label: Text('Lägg till deltagare', style: TextStyle(
              color: themeManager.isDarkMode ? Colors.white : Colors.black,)),

          ),),
        Divider(color: Colors.grey),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: groupList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: groupList[index],
              );
            },
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar(context),
      body: body,
      //bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
  
