import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'package:kzstats/cubit/search_cubit.dart';
import 'package:kzstats/data/searchProvider.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SearchBody(context: context),
    );
  }
}

class SearchBody extends StatefulWidget {
  final BuildContext context;
  const SearchBody({
    Key? key,
    required this.context,
  }) : super(key: key);
  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  late BuildContext context;
  List<MapInfo>? allMapData = UserSharedPreferences.getMapData();

  @override
  void initState() {
    super.initState();
    this.context = widget.context;
  }

  final List<FloatingSearchBarAction> actions = [
    FloatingSearchBarAction(
      showIfOpened: false,
      child: CircularButton(
        icon: const Icon(Icons.map_sharp),
        onPressed: () {},
      ),
    ),
    FloatingSearchBarAction.searchToClear(
      showIfClosed: false,
    ),
  ];

  onQueryChanged(String query) {
    if (query.isEmpty || allMapData == null) {
      BlocProvider.of<SearchCubit>(context).suggest([]);
    } else {
      List<MapInfo> back = [];
      for (MapInfo each in allMapData!) {
        if (each.mapName!.contains(query)) {
          back.add(each);
        }
      }
      back.sort((a, b) =>
          a.mapName!.indexOf(query).compareTo(b.mapName!.indexOf(query)));
      BlocProvider.of<SearchCubit>(context).suggest(back);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      actions: actions,
      automaticallyImplyBackButton: true,
      iconColor: Colors.white,
      backgroundColor: appbarColor(),
      shadowColor: primarythemeBlue(),
      transitionCurve: Curves.easeInOutCubic,
      hintStyle: TextStyle(color: Colors.white70),
      queryStyle: TextStyle(color: Colors.white),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      onQueryChanged: onQueryChanged,
      builder: (context, _) => builder(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return FloatingSearchAppBar(
      height: 58,
      transitionDuration: Duration(milliseconds: 400),
      color: backgroundColor(),
      colorOnScroll: backgroundColor(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('History', style: TextStyle(fontSize: 16)),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return Text('${state.history}');
              },
            ),
            Divider(color: dividerColor()),
            Text('Explore', style: TextStyle(fontSize: 16)),
            Divider(color: dividerColor()),
          ],
        ),
      ),
    );
  }

  Widget builder() {
    return Material(
      color: backgroundColor(),
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      // create a type of SearchItem to include both type
      child: ImplicitlyAnimatedList<MapInfo>(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // need to deal with null
        items: BlocProvider.of<SearchCubit>(context).state.suggestions,
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, each, i) {
          return SizeFadeTransition(
            animation: animation,
            child: buildItem(context, each),
          );
        },
        updateItemBuilder: (context, animation, each) {
          return FadeTransition(
            opacity: animation,
            child: buildItem(context, each),
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, MapInfo each) {
    final searchState = context.watch<SearchCubit>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            BlocProvider.of<SearchCubit>(context).addToHistory(each.mapName!);
            Navigator.of(context).pushNamed(
              '/map_detail',
              arguments: each,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: searchState.suggestions == searchState.history
                        ? Icon(Icons.history, color: Colors.white)
                        : Icon(Icons.map_sharp, color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: SubstringHighlight(
                          text: each.mapName!,
                          term: '',
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          textStyleHighlight: TextStyle(
                            color: inkWellBlue(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tier: ${identifyTier(each.difficulty)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
