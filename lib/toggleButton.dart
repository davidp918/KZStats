import 'package:flutter/material.dart';

//import 'package:kzstats/details/settings.dart';

class ToggleButton extends StatefulWidget {
  final List<dynamic> list;
  ToggleButton(this.list);

  @override
  State createState() => new _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  List<bool> _selections = [true, false, false];
  int mode = 0;
  int tickrate = 0;
  String sample = 'asdf';
  void initSample() {
    sample = widget.list[0];
    super.initState();
  }
  //sample.length() > 4 ? mode = _selections.indexOf(true) : tickrate = _selections.indexOf(true);

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
          ...(widget.list).map<Widget>((str) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                str,
                style: TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
        ],
        onPressed: (int index) {
          setState(() {
            //initSample();
            for (int i = 0; i < _selections.length; i++) {
              if (index == i) {
                _selections[i] = true;
                //  sample.length > 4 ? mode = i : tickrate = i;
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
