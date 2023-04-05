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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              if(index<chatList.length) {
                return chatList[index];
              }
            },
          ),
        ),
        Padding(
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
        ),
      ],
    );

    populateChatList();
    return Scaffold(
      appBar: widget.appbar,
      body: body,
      bottomNavigationBar: widget.bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
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
