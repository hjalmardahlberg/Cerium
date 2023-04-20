import 'dart:convert';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import '../Theme/themeConstants.dart';
import 'package:provider/provider.dart';
import '../homePage.dart';
import 'groupChat.dart';
import 'package:http/http.dart' as http;

import 'groupParticipnats.dart';


class Group extends StatefulWidget {
  const Group({
    Key? key,
    required this.admin,
    required this.groupName,
    required this.picture,

  }) : super(key: key);

  //final Group group;
  final String admin;
  final String groupName;
  final String picture;


  @override
  State<Group> createState() => _Group();
}

class _Group extends State<Group> {
  late Future<List<GroupParticipants>> groupParticipants;

  @override
  void initState() {
    super.initState();
    groupParticipants = getGroupParticipants(widget.admin,widget.groupName);
  }

  static Future<List<GroupParticipants>> getGroupParticipants(admin,groupName) async {

    final url = 'http://192.121.208.57:8080/groups/users/'+groupName+'&'+admin;

    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(Uri.parse(url), headers: headers);

    final body = json.decode(response.body);

    print(response.body);

    return body.map<GroupParticipants>(GroupParticipants.fromJson).toList();
  }

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor:Theme
        .of(context)
        .brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.white,
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
                    MaterialPageRoute(builder: (_) => const ProfileWidget()));
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteGroup(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Du är ägare av gruppen om du lämnar kommer den att försvinna. \n Är du fortfarande säker på att du vill lämna gruppen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Avbryt'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lämna',style: TextStyle(color: Colors.red),),
              onPressed: () async {
                final url = 'http://192.121.208.57:8080/group/delete/'+widget.groupName;

                final headers = {'Content-Type': 'application/json'};
                final response = await http.delete(Uri.parse(url), headers: headers);
                print(response.body);
                if (response.statusCode == 200) {
                  print('User data sent successfully!');
                  Navigator.of(context).pop();
                }
                else {
                  print('Error sending user data: ${response.statusCode}');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showLeaveGroup(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Är du säker på att du vill lämna gruppen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Avbryt'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lämna',style: TextStyle(color: Colors.red),),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser!;
                print(widget.groupName);
                final url = 'http://192.121.208.57:8080/group/leave/'+widget.groupName+'&'+widget.admin;
                final userData = {
                  'id': user.uid,
                  'name': user.displayName,
                  'email': user.email,
                };
                final userBody = jsonEncode(userData);
                final headers = {'Content-Type': 'application/json'};
                final response = await http.put(Uri.parse(url), headers: headers,body: userBody);
                print(response.body);
                if (response.statusCode == 200) {
                  print('User data sent successfully!');
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => MyHomePage(pageIndex: 2,)),
                  );}
                else {
                  print('Error sending user data: ${response.statusCode}');
                }
              },
            ),
          ],
        );
      },
    );
  }

  double baseWidth = 390;
  double fem = 0;
  double ffem = 0;
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {

     fem = MediaQuery.of(context).size.width / baseWidth;
     ffem = fem * 0.97;
     width = MediaQuery.of(context).size.width;
     height = MediaQuery.of(context).size.height;
    final themeManager = Provider.of<ThemeManager>(context);

    Expanded profiler() {
      return Expanded(
        child:SizedBox(
          height:height,
            child: FutureBuilder<List<GroupParticipants>>(
                future: groupParticipants, builder: (context, snapshot) {
              if (snapshot.hasData) {
                final groupParticipants = snapshot.data!;
                return buildParticipantsList(groupParticipants);
              }
              else {
                return const Padding(padding:EdgeInsets.only(left:10,top:10), child:Text('Error...'));
              }
            }),
        ),
      );
    }



    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        groupNameAndExit(),
        const Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text("Deltagare")),

        Row(children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: TextButton.icon(
            onPressed: () {
              // Do something when the button is pressed
            },
            icon: Icon(Icons.add_circle_outline,
                color: themeManager.isDarkMode ? Colors.white : Colors.black),
            label: Text('Lägg till deltagare',
                style: TextStyle(
                  color: themeManager.isDarkMode ? Colors.white : Colors.black,
                )),
          ),
        ),

          const Expanded(child:
          Padding(
            padding: EdgeInsets.only(right: 10),
          child:Text('Senaste\nuppdatering',textAlign: TextAlign.end,style: TextStyle(fontSize: 20)),),
    )],),
        const Divider(color: Colors.grey),
        profiler(),
        goToChat(context),
        sendAndSyncCalenders(),
      ],
    );

    return Scaffold(
      appBar: appBar(context),
      body: body,
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }

  Align goToChat(BuildContext context) {
    return
        Align(
        alignment: Alignment.bottomRight,
     child: Padding(
       padding: const EdgeInsets.only(right:16),
     child: FloatingActionButton.extended(
      backgroundColor: Colors.lightBlue.shade300,
        icon:const Icon(CupertinoIcons.chat_bubble_fill ,color: Colors.white,),
        label:const Text('chat',style: TextStyle(color: Colors.white),),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  GroupChat(
                groupName: widget.groupName,
              ),
              transitionDuration: Duration.zero,
            ),
          );
        },
     ),
    ),
      );
  }

  Stack groupNameAndExit() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8,right:5),
          child: Center(
            child: Text(
              widget.groupName,
              style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              _showLeaveGroup(context);
            },
            icon: const Icon(
              Icons.exit_to_app_outlined,
              size: 30.0,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Container sendAndSyncCalenders() {
    return  Container(
        margin: const EdgeInsets.only(top:8,bottom: 16), // Adjust the value as needed
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CreateEvent(),
              syncCalenders(),
            ],
          ),
      ),
    );
  }

  ElevatedButton syncCalenders() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        Icons.sync,
        size: 24.0,
      ),
      label: const Text('sync calenders'),
    );
  }

  ElevatedButton CreateEvent() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        Icons.add,
        size: 24.0,
      ),
      label: const Text('Create Event'),
    );
  }

  SizedBox profileBox(name, image) {
    return SizedBox(
      width: double.infinity,
      height: width / 6,
      child:Padding(padding: const EdgeInsets.only(left:15,right:15,bottom: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(image),
            ),
          ),
          const SizedBox(
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
          Expanded(
            child:Text(
                "27/03",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.2125 * ffem / fem,
                )
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget buildParticipantsList(List<GroupParticipants> participantData) =>
      ListView.builder(
        itemCount: participantData.length,
        itemBuilder: (context, index) {
          final participant = participantData[index];
          return profileBox(participant.participantName, 'images/wallsten.jpg');
        },
      );

}
