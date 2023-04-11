import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projecttest/Theme/themeConstants.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class ChangeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return
       IconButton(
        icon: themeManager.isDarkMode
            ? Icon(Icons.wb_sunny_outlined)
            : Icon(Icons.nightlight_round),
        onPressed: () {
          final provider = Provider.of<ThemeManager>(context, listen: false);
          provider.toggleTheme(!themeManager.isDarkMode);
        },
      );
  }
}
