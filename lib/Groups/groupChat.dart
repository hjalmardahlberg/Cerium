import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:projecttest/profilePage.dart';
import 'package:provider/provider.dart';
import '../Theme/themeConstants.dart';
import 'package:http/http.dart' as http;

import 'Message.dart';

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

void onConnectCallback(StompFrame connectFrame) {
  print("Connected to server");
}

final client = StompClient(
  config: StompConfig.SockJS(
    url: 'http://192.121.208.57:25565/ws',
    onConnect: onConnectCallback,
    beforeConnect: () async {
      print('waiting to connect...');
      //await Future.delayed(Duration(milliseconds: 200));
      print('connecting...');
    },
    onWebSocketError: (dynamic error) => print(error.toString()),
    stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
    webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  ),
);

class _GroupChat extends State<GroupChat> {

  final myController = TextEditingController();
  final chatList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    client.activate();
    populateChatList();
    subscribe();
  }

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

  Future<void> subscribe() async {
    await Future.delayed(Duration(milliseconds: 200));
    client.subscribe(
      destination: '/topic/group/messages/${widget.groupName}&${widget
          .groupAdmin}',
      callback: (frame) {
        List<dynamic>? result = json.decode(frame.body!);
        print("result:"+result.toString());
        chatList.add(result.toString());
        print(result.toString());
        setState(() {});
      },
    );
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
      ],
    );


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



  Future<void> populateChatList() async {
    final url = 'http://192.121.208.57:25565/chat/group/messages/${widget.groupName}&${widget.groupAdmin}';
    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(Uri.parse(url), headers: headers);
    final messageList = jsonDecode(response.body);


    print(response.body);
    messageList.forEach((element) {
        //Message message = element as Message;
        chatList.add(Text(element.toString()));
    });
    setState(() {});


  }

  chatInput(
      String input, String groupName, String groupAdmin, String userName) {
    setState(() {
      chatList.add(Text(input));
    });
    final message = {
      'senderName': userName,
      'receiverGroup': groupName,
      'receiverGroupAdmin': groupAdmin,
      'date': DateTime.now().toString(),
      'message': input,
    };
    final encodedMSG = jsonEncode(message);

    client.send(
      destination: '/app/chat/group/${widget.groupName}&${widget.groupAdmin}',
      body: encodedMSG,
    );
  }
}
