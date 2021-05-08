import 'package:evil_icons_flutter/evil_icons_flutter.dart';
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
        debounceDelay: Duration.zero,
        builder: (context, _) => builder(provider),
        body: buildBody(context, provider),
      ),
    );
  }

  Widget buildBody(BuildContext context, SearchProvider provider) {
    Color light = Colors.grey.shade200.withOpacity(0.9);
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('History', style: TextStyle(fontSize: 24)),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    provider.expand();
                  },
                  child: Text(
                    provider.expanded ? 'show less' : 'show more',
                    style: TextStyle(fontSize: 12, color: light),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            this.historyTags(context, provider),
            Row(
              children: [
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    // clear history
                    UserSharedPreferences.clearHistory();
                    provider.refresh();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(EvilIcons.trash, color: light),
                      Text(
                        'Clear History',
                        style: TextStyle(color: light, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
            Divider(color: dividerColor()),
            Text('Explore', style: TextStyle(fontSize: 24)),
            SizedBox(height: 4),
            Divider(color: dividerColor()),
          ],
        ),
      ),
    );
  }

  Widget historyTags(BuildContext context, SearchProvider provider) {
    //provider.refresh();
    final _history = provider.expanded
        ? UserSharedPreferences.getHistory()
        : UserSharedPreferences.getHistory().take(6).toList();
    return Container(
      child: Wrap(
        spacing: 8,
        runSpacing: 0,
        children: _history.map((each) => tag(context, each, provider)).toList(),
      ),
    );
  }

  Widget tag(BuildContext context, MapInfo each, SearchProvider provider) {
    return ActionChip(
      labelPadding: EdgeInsets.all(0),
      avatar: CircleAvatar(
        child: Center(
            child: Text(
          '${each.difficulty}',
          style: TextStyle(fontSize: 14),
        )),
        backgroundColor: primarythemeBlue().withOpacity(0.8),
      ),
      label: Text(' ${each.mapName!} '),
      labelStyle: TextStyle(fontSize: 12),
      backgroundColor: Colors.white54,
      onPressed: () {
        UserSharedPreferences.updateHistory(each);
        provider.refresh();
        Navigator.of(context).pushNamed('/map_detail', arguments: each);
      },
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
          const Divider(height: 4),
      ],
    );
  }
}
