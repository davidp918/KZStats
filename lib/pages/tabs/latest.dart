import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/record_view.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/web/withNation.dart';
import 'package:kzstats/global/recordInfo_class.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Latest extends StatefulWidget {
  @override
  _LatestState createState() => _LatestState();
}

class _LatestState extends State<Latest>
    with AutomaticKeepAliveClientMixin<Latest> {
  late ModeState state;
  late Future<List<RecordInfo>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = context.watch<ModeCubit>().state;
    this._future = getInfoWithNation(state.mode, state.nub, 12, 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AsyncBuilder<List<RecordInfo>>(
      future: _future,
      waiting: (context) => loadingFromApi(),
      error: (context, object, stacktrace) => errorScreen(),
      builder: (context, value) {
        return LatestBody(items: value!, state: state);
      },
    );
  }
}

class LatestBody extends StatefulWidget {
  final List<RecordInfo> items;
  final ModeState state;

  const LatestBody({
    Key? key,
    required this.items,
    required this.state,
  }) : super(key: key);
  @override
  _LatestBodyState createState() => _LatestBodyState(items: items);
}

class _LatestBodyState extends State<LatestBody> {
  List<RecordInfo> items;
  _LatestBodyState({required this.items});
  late RefreshController _refreshController;
  int pageSize = 12;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  void _onRefresh(state) async {
    this.items =
        await getInfoWithNation(state.mode, state.nub, this.pageSize, 0);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading(state) async {
    this.items += await getInfoWithNation(
        state.mode, state.nub, this.pageSize, this.items.length);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () => _onRefresh(widget.state),
        onLoading: () => _onLoading(widget.state),
        physics: ClampingScrollPhysics(),
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          itemBuilder: this._itemBuilder,
          itemCount: this.items.length,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return recordCardView(context, this.items[index]);
  }

  @override
  void dispose() {
    this._refreshController.dispose();
    super.dispose();
  }
}
