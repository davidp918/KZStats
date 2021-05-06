import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kzstats/global/responsive.dart';

class SettingsTableLayout extends StatefulWidget {
  SettingsTableLayout({Key? key}) : super(key: key);

  @override
  _SettingsTableLayoutState createState() => _SettingsTableLayoutState();
}

class _SettingsTableLayoutState extends State<SettingsTableLayout> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: false,
      currentPage: 'Layout',
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No. of Table Rows:',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Enter your number"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: new TextFormField(
                  maxLines: 1,
                  decoration: new InputDecoration(
                      labelText: 'Username',
                      suffixIcon: new IconButton(
                        highlightColor: Colors.transparent,
                        icon: new Container(
                            width: 36.0, child: new Icon(Icons.clear)),
                        splashColor: Colors.transparent,
                        onPressed: () {},
                      ),
                      prefixIcon: new Icon(Icons.account_circle)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
