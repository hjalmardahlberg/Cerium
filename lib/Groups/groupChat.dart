import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import 'package:provider/provider.dart';
import '../Theme/themeConstants.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({Key? key,
    required this.groupName,})
      : super(key: key);

  //final Group group;
  final String groupName;


  @override
  State<GroupChat> createState() => _GroupChat();
}

class _GroupChat extends State<GroupChat> {
  final myController = TextEditingController();
  final chatList = List.empty(growable: true);


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

    final body = Column(
      children: [
        chatLog(),
        chatBox(),
      ],
    );

    populateChatList();
    return Scaffold(
      appBar: appBar(context),
      body: body,
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
