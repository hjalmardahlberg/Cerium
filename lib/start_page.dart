import 'googleSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'homePage.dart';


class StartPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          print("WE ARE WAITING");
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData){
          print("WE ARE LOGGED IN POG");
          return const MyHomePage(pageIndex: 0);
        } else if (snapshot.hasError){
          return const Center(child: Text('Something Went Wrong!'));
        } else{
          print("WE ARE LOGGED OUT");
          return SignUpWidget();
        }
      }
    ),
  );
}