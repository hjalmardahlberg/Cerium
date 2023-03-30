import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage(
      {Key? key,
        required this.appbar,
        required this.bottomNavigationBar})
      : super(key: key);

  final AppBar appbar;
  final BottomAppBar bottomNavigationBar;


  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: widget.appbar,
    body:Text("hej"),
    bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}