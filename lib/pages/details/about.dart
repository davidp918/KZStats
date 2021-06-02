import 'package:flutter/material.dart';
import 'package:kzstats/common/appbars/simpleAppbar.dart';
import 'package:kzstats/look/colors.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: defaultAppbar('About'),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'KZStats',
                    style: TextStyle(
                      fontSize: 45,
                    ),
                  ),
                  Text(
                    'Version - 1.4.0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            height: 34,
            width: size.width,
            color: secondarythemeBlue(),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '© 2021 Exusiai - Developed using Flutter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
