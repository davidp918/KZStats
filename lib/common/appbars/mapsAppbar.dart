import 'package:flutter/material.dart';

class MapsAppbar extends StatelessWidget {
  const MapsAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new TabBar(
            tabs: [
              new Tab(icon: new Icon(Icons.directions_car)),
              new Tab(icon: new Icon(Icons.directions_transit)),
              new Tab(icon: new Icon(Icons.directions_bike)),
            ],
          ),
        ],
      ),
    );
  }
}
