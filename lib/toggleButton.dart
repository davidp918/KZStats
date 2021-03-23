import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final List<String> list;
  ToggleButton(this.list);

  @override
  State createState() => new _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  List<bool> _selections = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade200,
      child: ToggleButtons(
        isSelected: _selections,
        fillColor: Colors.lightBlue,
        color: Colors.black,
        selectedColor: Colors.white,
        renderBorder: false,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              list[0],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              t2,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              t3,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < _selections.length; i++) {
              if (index == i) {
                _selections[i] = true;
              } else {
                _selections[i] = false;
              }
            }
          });
        },
      ),
    );
  }
}
