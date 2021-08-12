import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class CustomScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController controller;

  const CustomScrollbar({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollbar(
      controller: widget.controller,
      child: widget.child,
      heightScrollThumb: 48,
      backgroundColor: Colors.blue,
      scrollThumbBuilder: (
        Color backgroundColor,
        Animation<double> thumbAnimation,
        Animation<double> labelAnimation,
        double height, {
        Text? labelText,
        BoxConstraints? labelConstraints,
      }) {
        return FadeTransition(
          opacity: thumbAnimation,
          child: Container(
            height: height,
            width: 10.0,
            color: backgroundColor,
          ),
        );
      },
    );
  }
}
