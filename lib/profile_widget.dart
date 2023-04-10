import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Theme/ChangeTheme.dart';
import 'provider.dart';
import 'googleSignIn.dart';

class ProfileWidget extends StatelessWidget {
  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        //alignment: Alignment.center,
        //color: Colors.blueGrey.shade900,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 32),
            Center(
            child:CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL!),
            ),),
            const SizedBox(height: 8),
            Center(
            child:Text(
              user.displayName!,
              style: const TextStyle(fontSize: 20),
            ),),
            const SizedBox(height: 32),
            const Text(
              'Email:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              user.email!,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Theme:',
                  style: TextStyle(fontSize: 20),
                ),
                ChangeTheme()
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'USER ID:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              user.uid!,
              style: const TextStyle(fontSize: 15),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.logout();
                      Navigator.popUntil(context,ModalRoute.withName('/login'));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
