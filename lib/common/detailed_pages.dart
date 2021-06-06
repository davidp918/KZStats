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
                    if (widget.markedType == 'player') {
                      if (!markState.readyToMarkPlayer) return Container();
                      List<String> data = markState.playerIds;
                      return data.contains(widget.current)
                          ? IconButton(
                              icon: Icon(Icons.star, color: Colors.amber),
                              onPressed: () {
                                data.remove(widget.current);
                                markPlayer(widget.current, data);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.star_border),
                              onPressed: () {
                                print(markState.playerIds.length >= 10);
                                if (markState.playerIds.length >= 10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Exceeding maximum limit of favourite players, anywhere beyond 10 will cram globalApi.'),
                                    ),
                                  );
                                } else {
                                  data.insert(0, widget.current);
                                  markPlayer(widget.current, data);
                                }
                              },
                            );
                    } else {
                      List<String> data = markState.mapIds;
                      return data.contains(widget.current)
                          ? IconButton(
                              icon: Icon(Icons.star, color: Colors.amber),
                              onPressed: () {
                                data.remove(widget.current);
                                if (mounted)
                                  BlocProvider.of<MarkCubit>(context)
                                      .setMapIds(data);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.star_border),
                              onPressed: () {
                                data.insert(0, widget.current);
                                if (mounted)
                                  BlocProvider.of<MarkCubit>(context)
                                      .setMapIds(data);
                              },
                            );
                    }
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
