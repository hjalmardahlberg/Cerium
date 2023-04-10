import 'package:flutter/cupertino.dart';


class GroupProvider  extends ChangeNotifier {
  List<Widget> _items = <Widget>[];

  List<Widget> get items => _items;

  void addItem(Widget item) {
    _items.add(item);
    notifyListeners();
  }
}