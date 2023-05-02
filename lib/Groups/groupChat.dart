import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:projecttest/profile_widget.dart';
import 'package:provider/provider.dart';
import '../Theme/themeConstants.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({
    Key? key,
    required this.groupName,
    required this.groupAdmin,
    required this.userName,
  }) : super(key: key);

  //final Group group;
  final String groupName;
  final String groupAdmin;

  final String userName;

  @override
  State<GroupChat> createState() => _GroupChat();
}

class _GroupChat extends State<GroupChat> {
  final myController = TextEditingController();
  final chatList = List.empty(growable: true);
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://192.121.208.57:25565/ws'),
  );
  late Stream<dynamic> _stream;

  @override
  void initState() {
    super.initState();
    _stream =
        channel.stream; // Assign the WebSocket stream to the _stream variable
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    channel.sink.close();
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

  void handleMessage(dynamic data) {
    setState(() {
      chatList.add(data.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;

    final body = Column(
      children: [
        chatLog(),
        chatBox(),
        streamWidget(),
      ],
    );

    populateChatList();
    return Scaffold(appBar: appBar(context), body: body);
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
          labelText: 'Skicka ett meddelande',
        ),
        onFieldSubmitted: (_) async {
          chatInput(myController.text, widget.groupName, widget.groupAdmin,
              widget.userName);
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

  Widget streamWidget() {
    return StreamBuilder(
      stream: _stream, // Pass the WebSocket stream to the stream parameter
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          handleMessage(snapshot.data);
        }
        return SizedBox.shrink();
      },
    );
  }

  void populateChatList() {
    //TODO: Servercall
  }

  chatInput(
      String input, String groupName, String userName, String groupAdmin) {
    setState(() {
      chatList.add(Text(input));
    });
    final message = {
      'senderName': userName,
      'receiverGroup': groupName,
      'receiverGroupAdmin': groupAdmin,
      'timeStamp': DateTime.now().toString(),
      'message': input,
    };
    final encodedMSG = jsonEncode(message);

    channel.sink.add(encodedMSG);
  }
}
