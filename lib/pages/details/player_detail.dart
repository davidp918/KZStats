import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/others/modifyDate.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/others/tierIdentifier.dart';
import 'package:kzstats/others/timeConversion.dart';
import 'package:kzstats/svg.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/get/getMapInfo.dart';
import 'package:kzstats/web/get/getMapTop.dart';
import 'package:kzstats/web/get/getSteamPlayer.dart';
import 'package:kzstats/web/json/kztime_json.dart';
import 'package:kzstats/web/json/mapTop_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';

class PlayerDetail extends StatefulWidget {
  final int steamId64;
  const PlayerDetail({Key key, this.steamId64}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState();
}

class _MapDetailState extends State<PlayerDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('Player Name'),
      body: BlocBuilder<ModeCubit, ModeState>(
        builder: (
          context,
          state,
        ) {
          return FutureBuilder<List<dynamic>>(
            future: Future.wait(
              [
                getPlayerSteam(widget.steamId64),
              ],
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot,
            ) {
              return;
            },
          );
        },
      ),
    );
  }

  Widget transition(
    AsyncSnapshot<List<dynamic>> snapshot,
  ) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData
            ? mainBody()
            : errorScreen()
        : loadingFromApi();
  }

  Widget mainBody() {
    return Text('nothing');
  }
}
