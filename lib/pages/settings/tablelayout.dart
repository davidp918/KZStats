import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/data/shared_preferences.dart';

class SettingsTableLayout extends StatefulWidget {
  SettingsTableLayout({Key? key}) : super(key: key);

  @override
  _SettingsTableLayoutState createState() => _SettingsTableLayoutState();
}

class _SettingsTableLayoutState extends State<SettingsTableLayout> {
  late int rowNum;
  @override
  void initState() {
    super.initState();
    this.rowNum = UserSharedPreferences.getRowsPerPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('Datatable'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'No. of Table Rows:',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 25, 10, 35),
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          icon: Container(
                            width: 36.0,
                            child: Icon(Icons.clear),
                          ),
                          splashColor: Colors.transparent,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
