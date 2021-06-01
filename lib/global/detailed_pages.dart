import 'package:flutter/material.dart';
import 'package:kzstats/common/Popup_mode.dart';
import 'package:kzstats/common/appbars/baseAppbar.dart';
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
  late bool marked;
  late List<String> data;

  @override
  void initState() {
    super.initState();
    this._scrollController = ScrollController();
    this.data = widget.markedType == 'player'
        ? UserSharedPreferences.getMarkedPlayers()
        : UserSharedPreferences.getMarkedMaps();
    this.marked = this.data.contains(widget.current);
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  void addMarked() {
    data.add(widget.current);
    widget.markedType == 'player'
        ? UserSharedPreferences.setMarkedPlayers(data)
        : UserSharedPreferences.setMarkedMaps(data);
    this.marked = true;
    print(this.marked);
    setState(() {});
  }

  void removeMarked() {
    data.remove(widget.current);
    widget.markedType == 'player'
        ? UserSharedPreferences.setMarkedPlayers(data)
        : UserSharedPreferences.setMarkedMaps(data);
    this.marked = false;
    setState(() {});
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
                this.marked
                    ? IconButton(
                        icon: Icon(Icons.star, color: Colors.amber),
                        onPressed: () => removeMarked(),
                      )
                    : IconButton(
                        icon: Icon(Icons.star_border),
                        onPressed: () => addMarked(),
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
}
