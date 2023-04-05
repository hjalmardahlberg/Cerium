import 'package:flutter/material.dart';


class MyLogInPage extends StatefulWidget {
  const MyLogInPage({super.key});

  @override
  State<MyLogInPage> createState() => _MyLogInState();
}

class _MyLogInState extends State<MyLogInPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tempus"),
        backgroundColor: Colors.red.shade800,
      ),
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container(
            // login7YH (1:3)
            padding: EdgeInsets.fromLTRB(
                30 * fem, 79 * fem, 30 * fem, 79 * fem),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(5 * fem),
            ),
            child:
            Container(
              // loginbackgroundbTT (69:6)
              padding: EdgeInsets.fromLTRB(
                  17 * fem, 15.46 * fem, 26 * fem, 53.95 * fem),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff000000)),
              color: Color(0xffffffff),
            ),
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
            Container(
            // loginwithgoogleTkZ (69:7)
            margin: EdgeInsets.fromLTRB(5*fem, 0 * fem, 0 * fem, 36.95 * fem),
            child:
            Text(
              'Log in with Google',
              style: TextStyle(
                fontSize: 26 * ffem,
                fontWeight: FontWeight.w400,
                height: 1.2125 * ffem / fem,
                decoration: TextDecoration.underline,
                color: Color(0xff000000),
                decorationColor: Color(0xff000000),
              ),
            ),
          ),
         Expanded(child: Container(
            // usernameboxL3f (1:13)
            margin: EdgeInsets.fromLTRB(0 * fem, 50 * fem, 0 * fem, 42.13 * fem),
              child:
              Container(
                padding: EdgeInsets.fromLTRB(
                    10 * fem, 12.79 * fem, 10 * fem, 8.44 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff000000)),
                color: Color(0xffd9d9d9),
                borderRadius: BorderRadius.circular(5 * fem),
              ),
              child:
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
          ),
         ),
      Expanded(child: Container(
          // passwordboxKgH (1:12)
          margin: EdgeInsets.fromLTRB(0 * fem, 10 * fem, 0 * fem, 2*42.13 * fem),
            child:
            Container(
              padding: EdgeInsets.fromLTRB(
                  10 * fem, 10.23 * fem, 10 * fem, 6.43 * fem),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff000000)),
              color: Color(0xffd9d9d9),
              borderRadius: BorderRadius.circular(5 * fem),
            ),
            child:
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your password',
              ),
            ),
          ),
        ),
      ),
      Expanded(child: Container(
        // loginboxwBs (1:27)
        margin: EdgeInsets.fromLTRB(83 * fem, 50 * fem, 84 * fem, 50 * fem),
        width: double.infinity,
        height: fem,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff000000)),
        color: Color(0xff32cd32),
        borderRadius: BorderRadius.circular(5 * fem),
      ),
      child:
      Center(
        child:
        Text(
          'Log In',
          style: TextStyle(
            fontSize: 12 * ffem,
            fontWeight: FontWeight.w400,
            height: 1.2125 * ffem / fem,
            color: Color(0xff000000),
          ),
        ),
      ),
    ),
      ),
    ],
    ),
    ),
    ),
              ),
    ],
    ),
    );
  }
}
