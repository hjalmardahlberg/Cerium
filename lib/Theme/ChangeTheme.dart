import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projecttest/Theme/themeConstants.dart';
import 'package:provider/provider.dart';

class ChangeTheme extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Switch.adaptive(value: themeManager.isDarkMode, onChanged: (value){
      final provider = Provider.of<ThemeManager>(context, listen: false);
      provider.toggleTheme(value);
    });
  }
  
}