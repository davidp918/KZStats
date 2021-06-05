import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';
import 'package:kzstats/common/appbars/baseAppbar.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';

class DetailedPage extends StatefulWidget {
  const DetailedPage({
    Key? key,
    required this.title,
    required this.markedType,
    required this.current,
    required this.builder,
  }) : super(key: key);
  final String title;
  final String markedType;
  final String current;
  final Widget Function(BuildContext context) builder;

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    this._scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: this._scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            BaseAppBar(
              widget.title,
              false,
              [
                BlocBuilder<MarkCubit, MarkState>(
                  builder: (context, markState) {
                    List<String> data = widget.markedType == 'player'
                        ? markState.playerIds
                        : markState.mapIds;
                    return data.contains(widget.current)
                        ? IconButton(
                            icon: Icon(Icons.star, color: Colors.amber),
                            onPressed: () {
                              data.remove(widget.current);
                              widget.markedType == 'player'
                                  ? BlocProvider.of<MarkCubit>(context)
                                      .setPlayerIds(data, context)
                                  : BlocProvider.of<MarkCubit>(context)
                                      .setMapIds(data);
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.star_border),
                            onPressed: () {
                              data.insert(0, widget.current);
                              if (widget.markedType == 'player') {
                                markPlayer(widget.current, data);
                              } else {
                                BlocProvider.of<MarkCubit>(context)
                                    .setMapIds(data);
                              }
                            },
                          );
                  },
                ),
                PopUpModeSelect(),
              ],
            )
          ];
        },
        body: widget.builder(context),
      ),
    );
  }

  void markPlayer(String steamid64, List<String> data) async {
    await UserSharedPreferences.getPlayerInfo(steamid64);
    if (mounted)
      BlocProvider.of<MarkCubit>(context).setPlayerIds(data, context);
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }
}
