import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/model/kzjson.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/web/get.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/others/timeConversion.dart';

class Homepage extends StatelessWidget {
  final String currentPage = 'KZStats';
  final Widget trophy = SvgPicture.asset(
    'assets/trophy.svg',
    height: 14,
    width: 14,
  );

  Widget notifySwitching(String str, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switching to $str'),
        duration: Duration(milliseconds: 4000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff4a5568),
      ),
      home: Scaffold(
        appBar: HomepageAppBar(currentPage),
        drawer: HomepageDrawer(),
        body: BlocConsumer<ModeCubit, ModeState>(
            listener: (context, state) =>
                notifySwitching('${state.mode}', context),
            builder: (context, state) {
              return FutureBuilder<List<KzTime>>(
                future: getTopRecords(state.mode, false),
                builder: (BuildContext context,
                    AsyncSnapshot<List<KzTime>> snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: snapshot.connectionState == ConnectionState.done
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Column(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(35, 15, 0, 15),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 11),
                                        child: Container(
                                          height: 90,
                                          width: 160.71,
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Center(
                                              child: SizedBox(
                                                child:
                                                    CircularProgressIndicator(),
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.error_outline,
                                              color: Colors.red.shade200,
                                            ),
                                            imageUrl:
                                                '$imageBaseURL${snapshot.data[index].mapName}.webp',
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            child: Text(
                                              '${lenCheck(snapshot.data[index].mapName, 20)}',
                                              style: TextStyle(
                                                color: Colors.blue.shade100,
                                                fontSize: 16,
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '${toMinSec(snapshot.data[index].time)}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              trophy,
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                snapshot.data[index]
                                                            .teleports ==
                                                        1
                                                    ? '(${snapshot.data[index].teleports.toString()} tp)'
                                                    : snapshot.data[index]
                                                                .teleports >
                                                            1
                                                        ? '(${snapshot.data[index].teleports.toString()} tps)'
                                                        : '',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'by ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.5,
                                                ),
                                              ),
                                              InkWell(
                                                child: Text(
                                                  '${lenCheck(snapshot.data[index].playerName, 15)}',
                                                  style: TextStyle(
                                                    color: Colors.blue.shade100,
                                                    fontSize: 14.5,
                                                  ),
                                                ),
                                                onTap: () {
                                                  print(snapshot.data);
                                                },
                                              ),
                                              SizedBox(
                                                width: 4.5,
                                              ),
                                              Image.network(
                                                'https://www.kzstats.com/img/flag/cn.png',
                                                // create a new json obtaining steam user info from
                                                // http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002?key=D382A350B768E5203415355D707065FD&steamids=76561198149087452
                                                // where key = my stean web api key, steamids = ${snapshot.data[index].steamid64}
                                                // use the loccountrycode to obtain image of country flag, ideally from local
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            '${diffofNow(snapshot.data[index].createdOn)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.5,
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
              );
            }),
      ),
    );
  }
}
