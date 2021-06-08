import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/leaderboardPoints_json.dart';
import 'package:kzstats/web/json/leaderboardRecords_json.dart';
import 'package:kzstats/web/urls.dart';

class Leaderboard extends StatefulWidget {
  final String type;

  const Leaderboard({Key? key, required this.type}) : super(key: key);
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Leaderboard> {
  late Future _future;
  late ModeState modeState;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    modeState = context.watch<ModeCubit>().state;
    this._future = widget.type == 'Points'
        ? getRequest(
            globalApiLeaderboardPoints(modeState.mode, modeState.nub, 100),
            leaderboardPointsFromJson,
          )
        : getRequest(
            globalApiLeaderboardRecords(modeState.mode, modeState.nub, 100),
            leaderboardRecordsFromJson,
          );
  }

  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData && snapshot.data != null
                ? mainBody(snapshot.data)
                : errorScreen()
            : loadingFromApi();
      },
    );
  }

  Widget mainBody(List<dynamic> data) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        SizedBox(height: 12),
        Center(
          child: Text(
            '${widget.type} Leaderboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 8),
        widget.type == 'Points'
            ? CustomDataTable(
                data: data,
                columns: [
                  '#',
                  'Player',
                  'Average',
                  'Rating',
                  'Finishes',
                  'Points in total'
                ],
              )
            : CustomDataTable(
                data: data,
                columns: ['#', 'Player', 'Count'],
              ),
        Container(height: 100),
      ],
    );
  }
}
