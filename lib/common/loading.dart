import 'package:flutter/widgets.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;

Widget loadingFromApi() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: Image.asset('assets/icon/loading.gif'),
          width: 120,
          height: 120,
        ),
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}

class LoadingGifHeader extends RefreshIndicator {
  LoadingGifHeader() : super(height: 110.0, refreshStyle: RefreshStyle.Follow);
  @override
  State<StatefulWidget> createState() {
    return LoadingGifHeaderState();
  }
}

class LoadingGifHeaderState extends RefreshIndicatorState<LoadingGifHeader>
    with SingleTickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    // init frame is 2
    _gifController = GifController(
      vsync: this,
      value: 1,
    );
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    if (mode == RefreshStatus.refreshing) {
      _gifController.repeat(
          min: 0, max: 100, period: Duration(milliseconds: 2300));
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    _gifController.value = 60;
    return _gifController.animateTo(60, duration: Duration(milliseconds: 1500));
  }

  @override
  void resetValue() {
    _gifController.value = 0;
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return Column(
      children: [
        GifImage(
          image: AssetImage("assets/icon/loading.gif"),
          controller: _gifController,
          height: 100.0,
        ),
        Container(
          width: 100,
          child: Divider(height: 4, color: dividerColor()),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }
}

class LoadingGifFooter extends StatefulWidget {
  LoadingGifFooter() : super();

  @override
  State<StatefulWidget> createState() {
    return _LoadingGifFooterState();
  }
}

class _LoadingGifFooterState extends State<LoadingGifFooter>
    with SingleTickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    _gifController = GifController(
      vsync: this,
      value: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: 100,
      builder: (context, mode) {
        return GifImage(
          image: AssetImage("assets/icon/loading.gif"),
          controller: _gifController,
          height: 100.0,
        );
      },
      loadStyle: LoadStyle.ShowWhenLoading,
      onModeChange: (mode) {
        if (mode == LoadStatus.loading) {
          _gifController.repeat(
              min: 0, max: 100, period: Duration(milliseconds: 2300));
        }
      },
      endLoading: () async {
        _gifController.value = 60;
        return _gifController.animateTo(60,
            duration: Duration(milliseconds: 1500));
      },
    );
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }
}
