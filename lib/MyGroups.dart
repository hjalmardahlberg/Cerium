import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

//import 'package:google_fonts/google_fonts.dart';
import 'Group.dart';

class MyGroups extends StatefulWidget {
  const MyGroups(
      {super.key,
      required this.title,
      required this.appbar,
      required this.bottomNavigationBar});

  final String title;
  final AppBar appbar;
  final BottomAppBar bottomNavigationBar;

  @override
  State<MyGroups> createState() => _MyGroups();
}

class _MyGroups extends State<MyGroups> {
  final list = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String groupImage = 'images/wallsten.jpg';
    String groupName = 'Grupp med Wallsten';
    list.add(GroupBox(fem, ffem, width, height, widget.appbar, widget.bottomNavigationBar,
        context, groupImage, groupName));
    return Scaffold(
      appBar: widget.appbar,
      body: ListView.builder(
        itemBuilder: (_, index) {
          if (index < list.length) {
            return list[index];
          }
        },
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}

Container GroupBox(double fem, double ffem, double width, double height, appbar,
    bottomNavigationBar, context, String groupImage, String groupName) {
  return Container(
    // event3JfJ (23:33)
    margin: EdgeInsets.fromLTRB(width / 12, 10 * fem, 0 * fem, 10 * fem),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              //TODO:Fix
              builder: (_) => Group(
                  groupName: groupName,
                  picture: groupImage,
                  appbar: appbar,
                  bottomNavigationBar: bottomNavigationBar)),
        );
      },
      child: Container(
        width: double.infinity,
        height: 138.5 * fem,
        child: Stack(
          children: [
            Positioned(
              // eventboxQTS (23:34)
              left: 0 * fem,
              top: 0 * fem,
              child: Align(
                child: SizedBox(
                  width: 325 * fem,
                  height: 135 * fem,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20 * fem),
                      border: Border.all(color: Color(0xff000000)),
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // mtemedwallstenuHi (23:37)
              left: 19 * fem,
              top: 100 * fem,
              child: Align(
                child: SizedBox(
                  width: 109 * fem,
                  height: 15 * fem,
                  child: Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // wallstoeno8C (23:38)
              left: 0 * fem,
              top: 0 * fem,
              child: Align(
                child: SizedBox(
                  width: 325 * fem,
                  height: 95 * fem,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20 * fem),
                      topRight: Radius.circular(20 * fem),
                    ),
                    child: Image.asset(
                      groupImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
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
