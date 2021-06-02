import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/look/colors.dart';

class ContainerAnimationWidget extends StatefulWidget {
  final Widget Function(BuildContext, void Function()) closedBuilder;
  final Widget Function(BuildContext, void Function({Never? returnValue}))
      openBuilder;
  ContainerAnimationWidget({
    Key? key,
    required this.closedBuilder,
    required this.openBuilder,
  }) : super(key: key);

  @override
  _ContainerAnimationWidgetState createState() =>
      _ContainerAnimationWidgetState();
}

class _ContainerAnimationWidgetState extends State<ContainerAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        openColor: backgroundColor(),
        closedColor: backgroundColor(),
        middleColor: backgroundColor(),
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: widget.closedBuilder,
        openBuilder: widget.openBuilder);
  }
}
