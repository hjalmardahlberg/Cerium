import 'dart:collection';

import 'package:flutter/material.dart';

class Group extends StatefulWidget {
  const Group(
      {Key? key,
      required this.groupName,
      required this.picture,
      required this.appbar,
      required this.bottomNavigationBar})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        grouppNameAndExit(),
        chatLog(),
        chatBox(),
        sendAndSyncCalenders(),
      ],
    );

    populateChatList();
    return Scaffold(
      appBar: widget.appbar,
      body: body,
      bottomNavigationBar: widget.bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Stack grouppNameAndExit() {
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
