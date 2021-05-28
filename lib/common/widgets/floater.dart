import 'package:flutter/material.dart';

class Floater extends StatefulWidget {
  int amount;
  Floater({Key? key, required this.amount}) : super(key: key);

  @override
  _FloaterState createState() => _FloaterState();
}

class _FloaterState extends State<Floater> {
  late List<Animation> _animations;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CircularFloatingButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final onClick;

  CircularFloatingButton({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}
