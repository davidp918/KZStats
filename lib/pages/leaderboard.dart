import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: true,
      currentPage: 'Leaderboard',
      builder: (context, constraints) {
        return BlocBuilder<ModeCubit, ModeState>(
          builder: (context, state) {
            return FutureBuilder(
              future: Future.wait(
                [
                  getRequest(
                    globalApiLeaderboardPoints(state.mode, state.nub, 20),
                    leaderboardPointsFromJson,
                  ),
                ],
              ),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<dynamic>> snapshot,
              ) {
                return transition(snapshot);
              },
            );
          },
        );
      },
    );
  }

  Widget transition(AsyncSnapshot<List<dynamic>> snapshot) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData
            ? mainBody()
            : errorScreen()
        : loadingFromApi();
  }

  Widget mainBody() {
    return Container();
  }
}
