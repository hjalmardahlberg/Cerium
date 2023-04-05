import 'googleSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'HomePage.dart';


class StartPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          print("WE ARE WAITING");
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData){
          print("WE ARE LOGGED IN POG");
          return MyHomePage(title: "Tempus");
        } else if (snapshot.hasError){
          return Center(child: Text('Something Went Wrong!'));
        } else{
          print("WE ARE LOGGED OUT");
          return SignUpWidget();
        }
      }
    ),
  );
}