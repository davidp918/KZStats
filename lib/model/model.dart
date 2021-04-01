import 'package:flutter/foundation.dart';

class Item {
  final int mode;
  final int tickrate;
  Item({
    @required this.mode,
    @required this.tickrate,
  });

  Item copyWith({int mode, int tickrate}) {
    return Item(
      mode: mode ?? this.mode,
      tickrate: tickrate ?? this.tickrate,
    );
  }
}

class AppState {
  final List<Item> items;

  AppState({@required this.items});

  AppState.initialState() : items = List.unmodifiable(<Item>[]);
}
