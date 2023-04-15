import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import '../Theme/themeConstants.dart';
import 'package:provider/provider.dart';
import 'groupChat.dart';


class Group extends StatefulWidget {
  const Group({
    Key? key,
    required this.groupName,
    required this.picture,
    //required this.group,

  }) : super(key: key);

  //final Group group;
  final String groupName;
  final String picture;


  @override
  State<Group> createState() => _Group();
}

class _Group extends State<Group> {
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
                    MaterialPageRoute(builder: (_) => const ProfileWidget()));
              },
            ),
          ),
        ],
      ),
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
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeManager = Provider.of<ThemeManager>(context);

    SizedBox profileBox(name, image) {
      return SizedBox(
        width: double.infinity,
        height: width / 6,
        child: Row(
          children: [
            Padding(
              // wallstoeno8C (23:38)
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
            ),),
          ],
        ),
      );
    }

    groupList.add(profileBox("Wallsten", 'images/wallsten.jpg'));

    Expanded profiler() {
      return Expanded(
        child:SizedBox(
          height:height,
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
          padding: const EdgeInsets.only(top: 8),
          child: Center(
            child: Text(
              widget.groupName,
              style: const TextStyle(
                  fontSize: 32.0,
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
              size: 36.0,
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
}
