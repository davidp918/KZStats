import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';

class FavouriteAllPlayers extends StatefulWidget {
  FavouriteAllPlayers({Key? key}) : super(key: key);

  @override
  _FavouriteAllPlayersState createState() => _FavouriteAllPlayersState();
}

class _FavouriteAllPlayersState extends State<FavouriteAllPlayers> {
  late Map<String, KzstatsApiPlayer?> playerInfo;
  late MarkState markState;
  late Map<String, bool> ifMarked;
  late List<String> players;

  @override
  void initState() {
    super.initState();
    this.playerInfo = {};
    this.ifMarked = {};
    this.players = [];
    this.markState = context.read<MarkCubit>().state;
    for (String steamid64 in markState.playerIds) {
      this.players.add(steamid64);
      this.ifMarked[steamid64] = true;
      this.playerInfo[steamid64] =
          UserSharedPreferences.readPlayerInfo(steamid64);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 0.9),
        child: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: appbarColor()),
          backgroundColor: appbarColor(),
          centerTitle: true,
          //brightness: Brightness.dark,
          title: Text(
            'My favourites',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: Column(
        children: this
            .playerInfo
            .keys
            .map((steamid64) => customTile(steamid64))
            .toList(),
      ),
    );
  }

  Widget customTile(String steamid64) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ListTile(
          leading: Container(
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: getNetworkImage(
                  steamid64,
                  this.playerInfo[steamid64]?.avatarfull ?? '',
                  AssetImage('assets/icon/noimage.png'),
                ),
              ),
            ),
          ),
          title: Text(
            this.playerInfo[steamid64]?.personaname ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: this.ifMarked[steamid64] ?? true
              ? IconButton(
                  icon: Icon(Icons.star, color: Colors.amber),
                  onPressed: () {
                    this.players.remove(steamid64);
                    this.ifMarked[steamid64] = false;
                    if (mounted) {
                      BlocProvider.of<MarkCubit>(context)
                          .setPlayerIds(this.players, context);
                      setState(() {});
                    }
                  },
                )
              : IconButton(
                  icon: Icon(Icons.star_border),
                  onPressed: () {
                    this.players.add(steamid64);
                    this.ifMarked[steamid64] = true;
                    if (mounted) {
                      BlocProvider.of<MarkCubit>(context)
                          .setPlayerIds(this.players, context);
                      setState(() {});
                    }
                  },
                ),
        ),
      );
}
