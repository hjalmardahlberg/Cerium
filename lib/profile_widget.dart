import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Theme/ChangeTheme.dart';
import 'Theme/themeConstants.dart';
import 'provider.dart';


class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text('Settings', style: TextStyle(fontSize: 20,color:themeManager.isDarkMode?Colors.white:Colors.black,),),
        centerTitle: true,
        backgroundColor:Theme
            .of(context)
            .brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                user.displayName!,
                style: const TextStyle(fontSize: 20),
              ),
            ),
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
            const Divider(),
            Row(
              children: [
                Text(
                  themeManager.isDarkMode ? "Light mode:" : "Dark mode:",
                  style: TextStyle(fontSize: 20),
                ),
                ChangeTheme()
              ],
            ),
            const SizedBox(height: 10),
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
                      Navigator.popUntil(
                          context, ModalRoute.withName('/login'));
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
