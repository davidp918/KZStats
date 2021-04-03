import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/model/kzjson.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/web/get.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/others/timeConversion.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String currentPage = 'KZStats';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff4a5568),
      ),
      home: Scaffold(
        appBar: HomepageAppBar(currentPage),
        drawer: HomepageDrawer(),
        body: FutureBuilder<List<KzTime>>(
          future: gettimerTopRecords(),
          builder:
              (BuildContext context, AsyncSnapshot<List<KzTime>> snapshot) {
            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(35, 15, 0, 15),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 90,
                                    width: 160.71,
                                    child: CachedNetworkImage(
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Icon(Icons.blur_circular_rounded),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      imageUrl:
                                          '$imageBaseURL${snapshot.data[index].mapName}.webp',
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        '${mapNameLenCheck(snapshot.data[index].mapName)}',
                                        style: TextStyle(
                                          color: Colors.blue.shade100,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      '${toMinSec(snapshot.data[index].time)}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'by ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        InkWell(
                                          child: Text(
                                            '${mapNameLenCheck(snapshot.data[index].playerName)}',
                                            style: TextStyle(
                                              color: Colors.blue.shade100,
                                              fontSize: 15,
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${diffofNow(snapshot.data[index].createdOn)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1.0,
                            indent: 0,
                            color: Colors.black,
                          ),
                        ]);
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
                              child: Text(
                                'Loading data from API...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ))
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
