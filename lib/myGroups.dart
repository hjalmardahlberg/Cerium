import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'group.dart';
import 'groupListProvider.dart';

import 'provider.dart';

import 'package:http/http.dart' as http;
import 'package:googleapis/calendar/v3.dart' show Event;

class MyGroups extends StatefulWidget {
  const MyGroups(
      {super.key,
      required this.title,
      required this.appbar,
      required this.appbar2,
      });

  final String title;
  final AppBar appbar;
  final AppBar appbar2;

  @override
  State<MyGroups> createState() => _MyGroups();
}

class _MyGroups extends State<MyGroups> {
  List<Widget> list = <Widget>[];
  double baseWidth = 390;
  double fem = 0;
  double ffem = 0;
  double width = 0;
  double height = 0;
  final TextEditingController _joinGroupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<GroupProvider>(context);
    double baseWidth = 390;
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;



    return Scaffold(
      //appBar: widget.appbar,
      body: Column(
        children: [
          groupText(),
          Expanded(child: groupList(listProvider)),
          joinGroup(listProvider),
        ],
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  ElevatedButton addToList(name, a_mail, groupImage, listProvider) {
    return ElevatedButton(
        onPressed: () async {
          final groupData = {"name": name, "a_mail": a_mail};
          final body = jsonEncode(groupData);
          jsonDecoder(body, groupImage, listProvider);
        },
        child: const Text('skicka grupp!'));
  }


  Center groupText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          'Grupper',
          style: TextStyle(
            fontSize: 24.0, // Set the font size to 24
            decoration: TextDecoration.underline, // Underline the text
          ),
        ),
      ),
    );
  }

  void jsonDecoder(String test, groupImage, listProvider) {
    final result = jsonDecode(test);
    print(result['name']);
    setState(() {
      listProvider.addItem(groupBox(
          fem, ffem, width, height, context, groupImage, result['name']));
    });
  }

  void drawGroups(String name, listProvider){
    setState(() {
      listProvider.addItem(groupBox(
          fem, ffem, width, height, context, "images/wallsten.jpg", name));
    });
  }


  void _showJoinGroup(TextEditingController joinGroupController, context) {
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

  Container joinGroup(listProvider) {
    final user = FirebaseAuth.instance.currentUser!;
    return Container(
      margin: const EdgeInsets.all(16),
      // Adjust the value as needed
      child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);

                      // kommer fetcha första veckan i april (TEMP)
                      final start = DateTime(2023, 4, 1);
                      final end = DateTime(2023, 4, 7);
                      final events =
                      await provider.getCalendarEventsInterval(start, end);

                      //print("BODY:");
                      //print(events);
                      //print("");

                      List<Map<String, dynamic>> ev_lst = [];

                      for (Event event in events) {

                        final ev_data =
                        {
                          'start': event.start?.dateTime?.toIso8601String(),
                          'end': event.end?.dateTime?.toIso8601String(),
                        };

                        ev_lst.add(ev_data);

                      }

                      final final_data_body =
                      {
                        'u_id' : user.uid,
                        'schedules': ev_lst,
                      };

                      print(final_data_body);

                      final url = 'http://192.121.208.57:8080/gEvent/import';
                      final headers = {'Content-Type': 'application/json'};
                      final body = jsonEncode(final_data_body);

                      final response = await http.post(Uri.parse(url), headers: headers, body: body);
                      print(response.body);

                    },
                    child: const Text('Send Calendar')),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                      setState(() {
                        listProvider.emptyItem();
                      });
                    },
                    child: const Text('Rensa grupp')),
              ),
              Expanded(
                flex: 1,
                child:TextButton(
                  onPressed: () {
                    _showJoinGroup(_joinGroupController,context);
                  },
                  child: Text('Join event',style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,),),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {

                      final userBody = {
                        'id':user.uid,
                      };

                      final url = 'http://192.121.208.57:8080/user/groups/' + user.uid;
                      //final uri = Uri.http("http://192.121.208.57:8080", "/user/groups", userBody);

                      final headers = {'Content-Type': 'application/json'};
                      //print(body.toString());
                      final response = await http.get(Uri.parse(url), headers: headers);

                      print(response);
                      print(response.body);
                      
                      List<dynamic> groups_lst = jsonDecode(response.body);
                      
                      for (var group in groups_lst)
                      {
                        //addToList(group["name"], group["admin"], "images/wallsten.jpg", listProvider);
                        drawGroups(group["name"], listProvider);
                      }




                    },
                    child: const Text('REFRESH')),
              ),
            ],
          )),
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
        });
  }

  GestureDetector groupBox(double fem, double ffem, double width, double height,
      context, String groupImage, String groupName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              //TODO:Fix
              builder: (_) => Group(
                  groupName: groupName,
                  picture: groupImage,
                  appbar: widget.appbar2,
                  )),
        );
      },
      child: Material(
        elevation: 15.0,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: width / 4,
          child: Stack(
            children: [
              Positioned(
                // eventboxQTS (23:34)
                left: 0 * fem,
                top: 0 * fem,
                child: SizedBox(
                  height: 135 * fem,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 * fem),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0 * fem,
                left: (140 * fem),
                child: SizedBox(
                  height: width / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                        Padding(
                          padding: EdgeInsets.only(top:20),
                        child: Text(
                          groupName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.2125 * ffem / fem,
                          ),
                        ),
                        //  ),
                      ),
                      Text(
                        'Ägare: Wallsten',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.withOpacity(0.9),
                          height: 1.2125 * ffem / fem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                // wallstoeno8C (23:38)
                left: 0 * fem,
                top: 0 * fem,
                child: Align(
                  child: SizedBox(
                    width: width / 3,
                    height: width / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10 * fem),
                        bottomLeft: Radius.circular(10 * fem),
                      ),
                      child: Image.asset(
                        groupImage,
                        fit: BoxFit.fill,
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