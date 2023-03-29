import 'package:cerium/googleSignIn.dart';
import 'package:cerium/logged_in_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData){
          return LoggedInWidget();
        } else if (snapshot.hasError){
          return Center(child: Text('Something Went Wrong!'));
        } else{
          return SignUpWidget();
        }
      }
    ),
  );
}