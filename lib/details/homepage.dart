import 'package:flutter/material.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/web/kzjson.dart';
import 'package:kzstats/web/get.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String currentPage = 'KZStats';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
      body: FutureBuilder<List<KzTimer>>(
        future: gettimerTopRecords(),
        builder: (BuildContext context, AsyncSnapshot<List<KzTimer>> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      color: Colors.white,
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Image.network('https://picsum.photos/250?image=9'),

                          // https://picsum.photos/250?image=9
                          // $ImageBaseURL
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Loading data from API...'),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
