import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';

class DetailedPage extends StatefulWidget {
  const DetailedPage({
    Key? key,
    required this.title,
    required this.builder,
  }) : super(key: key);
  final String title;
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
          return <Widget>[BaseAppBar(widget.title, false)];
        },
        body: widget.builder(context),
      ),
    );
  }
}
