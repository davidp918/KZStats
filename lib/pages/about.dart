import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/theme/colors.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: HomepageAppBar('About'),
      drawer: HomepageDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
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
                        'Version - 1.2.0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6),
                      /* SizedBox(
                        height: size.width / 3,
                        width: size.width / 3,
                        child: Image.asset('assets/icon/icon.png'),
                      ),
                      SizedBox(height: 12), */
                      /* Text(
                        'My Discord id: Exusiai#7677',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ), */
                      /* Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Source code available at ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              String url =
                                  'https://github.com/davidp918/KZStats';
                              await canLaunch(url)
                                  ? await launch(url)
                                  : throw ('could not launch $url');
                            },
                            child: Text(
                              'Github',
                              style: TextStyle(
                                color: inkWellBlue(),
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ), 
                      Divider(color: Colors.white), */
                      /*  Text(
                        'Contact me directly if there is any bug',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Feel free to raise issues',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Feedbacks are always welcoming!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ), */
                    ],
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
