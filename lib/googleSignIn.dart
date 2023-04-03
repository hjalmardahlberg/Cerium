import 'package:provider/provider.dart';
import 'provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Image.asset(
          'images/tempus_logo_tansp.png',
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
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: Colors.grey
          ),
          onPressed: () {
            //TODO: Implement log in functionality
            final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleLogin();

          },
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.deepOrange),
          label: Text('Sign in with Google'),
        ),
        SizedBox(height: 40),
        RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            children: [
              TextSpan(
                text: 'Log in',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
