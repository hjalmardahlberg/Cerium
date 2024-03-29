import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'provider.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget>
    with SingleTickerProviderStateMixin {
  final _lineDirection = LineDirection.Ltr;
  final _lineCount = 20;

  @override
  Widget build(BuildContext context) => AnimatedBackground(
    behaviour: BubblesBehaviour(
      //color: Colors.blue.withOpacity(0.2),
      //direction: _lineDirection,
      //numLines: _lineCount,
    ),
    vsync: this,
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Image.asset(
            'images/scuffed_logo_for_anim.png',
            width: 300,
            height: 300,
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hey There,\nWelcome back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Login to your account to continue',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Spacer(),
          SizedBox(
            width: 180, // Set the desired width
            height: 40,
            // Set the desired height
            child: SignInButton(

              Buttons.GoogleDark,
              onPressed: () async {
                //TODO: Implement log in functionality
                final provider =
                Provider.of<GoogleSignInProvider>(context,
                    listen: false);
                provider.googleLogin();
              },
            ),

          ),
          SizedBox(height: 40),
        ],
      ),
    ),
  );
}
