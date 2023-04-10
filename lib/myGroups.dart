import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:google_fonts/google_fonts.dart';
import 'group.dart';
import 'groupListProvider.dart';

/*
class Group {
  final int id;
  final String owner;
  final String name;
  final String userId;

  Group({required this.id, required this.owner, required this.name, required this.userId});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['g_id'] as int,
      owner: json['owner'] as String,
      name: json['name'] as String,
      userId: json['u_id'] as String,
    );
  }
}*/


class MyGroups extends StatefulWidget {
  const MyGroups(
      {super.key,
      required this.title,
      required this.appbar,
      required this.appbar2,
      required this.bottomNavigationBar});

  final String title;
  final AppBar appbar;
  final AppBar appbar2;
  final BottomAppBar bottomNavigationBar;

  @override
  State<MyGroups> createState() => _MyGroups();
}



class _MyGroups extends State<MyGroups> {

  List<Widget> list = <Widget>[];
  double baseWidth = 390;
  double fem=0;
  double ffem=0;
  double width=0;
  double height =0;


  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<GroupProvider>(context);
    double baseWidth = 390;
    fem = MediaQuery
        .of(context)
        .size
        .width / baseWidth;
    ffem = fem * 0.97;
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;

    TextEditingController _joinGroupController = TextEditingController();

    String groupImage = 'images/wallsten.jpg';
    String groupName = 'Grupp med Wallsten';
    return Scaffold(
      appBar: widget.appbar,
      body: Column(
        children: [
          groupText(),
          Expanded(child: groupList(listProvider)),
          joinGroup(_joinGroupController,listProvider),
        ],

      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  ElevatedButton addToList(name,a_mail,listProvider) {
    return ElevatedButton(
        onPressed: () async {
        final groupData = {
          "name":name,
          "a_mail":a_mail
        };
        final body = jsonEncode(groupData);
        jsonDecoder(body,listProvider);
        }

        ,child: const Text('skicka grupp!'));
  }

  Center groupText() {
    return const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'Groups',
              style: TextStyle(
                fontSize: 24.0, // Set the font size to 24
                decoration: TextDecoration.underline, // Underline the text
              ),
            ),
          ),
        );
  }
  void jsonDecoder(String test,listProvider) {
    final result = jsonDecode(test);
    print(result['name']);
    setState(() {
      listProvider.addItem(groupBox(
          fem,
          ffem,
          width,
          height,
          context,
          "images/wallsten.jpg",
          result['name']
      ));
    });
  }

  Container joinGroup(TextEditingController joinGroupController,listProvider) {
    return Container(
        margin: const EdgeInsets.all(16),
        // Adjust the value as needed
        child: Align(
          alignment: Alignment.bottomRight,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Expanded(child:addToList("Cerium","morganmixtape6@gmail.com",listProvider),),
            const SizedBox(width: 5,),
    Expanded(child:addToList("Katt Älskare","catEater42069@gmail.com",listProvider),),
            const SizedBox(width: 5,),
              Expanded(child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      listProvider.emptyItem();
                    });
                  },
                  child: const Text('Rensa grupp')),),
              const SizedBox(width: 5,),
            ElevatedButton(
              onPressed: () {
                _showJoinGroup(joinGroupController);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue.shade300,
              ),
              child: const Text('Join group'),
            ),
          ],)
        ),
    );
  }

  void _showJoinGroup(TextEditingController joinGroupController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter The Group Name'),
          content: TextFormField(
            controller: joinGroupController,
            decoration: const InputDecoration(hintText: 'Group name...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('JOIN'),
              onPressed: () {
                // do something with the text entered in the TextFormField
                String enteredText = joinGroupController.text;
                print('Entered Text: $enteredText');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ListView groupList(listProvider) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: listProvider.items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: listProvider.items[index],
          );
        }
        );
  }


  GestureDetector groupBox(double fem, double ffem, double width, double height,
            context, String groupImage, String groupName) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              //TODO:Fix
                builder: (_) =>
                    Group(
                        groupName: groupName,
                        picture: groupImage,
                        appbar: widget.appbar2,
                        bottomNavigationBar: widget.bottomNavigationBar)),
          );


        },
         child:Container(
           // event3JfJ (23:33)
           margin: EdgeInsets.fromLTRB(width / 12, 10 * fem, 0 * fem, 10 * fem),
        child: SizedBox(
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
                        border: Border.all(color: Colors.black),
                        color: Theme
                            .of(context)
                            .appBarTheme
                            .backgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // mtemdwallstenuHi (23:37)
                left: 10,
                top: 109 * fem,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 109 * fem,
                    height: 15 * fem,
                    child: Text(
                      groupName,
                      style: TextStyle(
                        fontSize: 12 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2125 * ffem / fem,
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
}