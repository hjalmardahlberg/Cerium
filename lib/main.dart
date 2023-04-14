import 'package:provider/provider.dart';

import 'googleSignIn.dart';
import 'groupListProvider.dart';
import 'provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'start_page.dart';
import 'package:projecttest/Theme/themeConstants.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'MainPage';

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
      ChangeNotifierProvider(create: (context) => ThemeManager()),
      ChangeNotifierProvider(create: (context) => GroupProvider()),
    ],
    builder: (context,_){
      final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: false,
      title: title,
      themeMode: themeManager.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => StartPage(),
      },
    );
  },
  );
}