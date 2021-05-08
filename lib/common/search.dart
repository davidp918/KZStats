import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'package:kzstats/data/searchProvider.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SearchBody(),
      ),
    );
  }
}

class SearchBody extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchProvider>(
      builder: (context, provider, _) => FloatingSearchBar(
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
        onQueryChanged: provider.onQueryChanged,
        progress: provider.isLoading,
        builder: (context, _) => builder(provider),
        body: buildBody(),
      ),
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
            Text('${UserSharedPreferences.getHistory().toString()}'),
            Divider(color: dividerColor()),
            Text('Explore', style: TextStyle(fontSize: 16)),
            Divider(color: dividerColor()),
          ],
        ),
      ),
    );
  }

  Widget builder(SearchProvider provider) {
    return Material(
      color: backgroundColor(),
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      // create a type of SearchItem to include both type
      child: ImplicitlyAnimatedList<MapInfo>(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // need to deal with null
        items: provider.suggestions,
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
    final provider = Provider.of<SearchProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            UserSharedPreferences.updateHistory(each);
            Navigator.of(context).pushNamed('/map_detail', arguments: each);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: provider.suggestions ==
                            UserSharedPreferences.getHistory()
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
                          term: provider.query,
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
        if (provider.suggestions.isNotEmpty &&
            each != provider.suggestions.last)
          const Divider(height: 0),
      ],
    );
  }
}
