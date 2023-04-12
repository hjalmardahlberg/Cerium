import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import 'groupParticipants.dart';

class Group extends StatefulWidget {
  const Group(
      {Key? key,
      required this.groupName,
      required this.picture,
      //required this.group,
      required this.appbar,
      required this.bottomNavigationBar})
      : super(key: key);

  //final Group group;
  final String groupName;
  final String picture;
  final AppBar appbar;
  final BottomAppBar bottomNavigationBar;

  @override
  State<Group> createState() => _Group();
}

class _Group extends State<Group> {
  final chatList = List.empty(growable: true);
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: Column(
              children: [
                const Icon(Icons.group),
                const Text(
                  'Deltagare',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      GroupParticipants(
                        groupName: widget.groupName,
                        bottomNavigationBar: widget.bottomNavigationBar,
                      ),
                  transitionDuration: Duration.zero,
                ),
              );
            },
          ),
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
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        groupNameAndExit(),
        chatLog(),
        chatBox(),
        sendAndSyncCalenders(),
      ],
    );

    populateChatList();
    return Scaffold(
      appBar: appBar(context),
      body: body,
      //bottomNavigationBar: widget.bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
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
                    fontSize: 24.0, decoration: TextDecoration.underline),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {},
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

  Expanded sendAndSyncCalenders() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), // Adjust the value as needed
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              sendCalender(),
              syncCalenders(),
            ],
          ),
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

  ElevatedButton sendCalender() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade300,
      ),
      icon: const Icon(
        Icons.send,
        size: 24.0,
      ),
      label: const Text('Send calender'),
    );
  }

  Padding chatBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: myController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Send a message',
        ),
        onFieldSubmitted: (_) async {
          chatInput(myController.text);
          myController.clear();
        },
      ),
    );
  }

  Padding chatLog() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          if (index < chatList.length) {
            return chatList[index];
          }
        },
      ),
    );
  }

  void populateChatList() {
    //TODO: Servercall
  }

  chatInput(String input) {
    setState(() {
      chatList.add(Text(input));
    });
    //TODO: Sent message to others in group
  }
}


