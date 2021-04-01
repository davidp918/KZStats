import 'package:kzstats/model/model.dart';

class AddItemAction {
  static int _mode = 0;
  static int _tickrate = 0;
  final String Item;

  AddItemAction(this.Item) {
    _mode++;
    _tickrate++;
  }

  int get mode => _mode;
  int get tickrate => _tickrate;
}

class RemoveItemAction {
  final Item item;
  RemoveItemAction(this.item);
}

class RemoveItemsAction {}
