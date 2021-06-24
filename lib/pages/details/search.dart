import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'package:kzstats/data/searchMapProvider.dart';
import 'package:kzstats/data/searchPlayerProvider.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/cubit/search_cubit.dart';
import 'package:kzstats/data/localPlayerClass.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchState = context.watch<SearchCubit>().state;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: searchState.field == 'map'
              ? ChangeNotifierProvider(
                  create: (_) => SearchMapProvider(),
                  child: SearchMapBody(),
                )
              : ChangeNotifierProvider(
                  create: (_) => SearchPlayerProvider(),
                  child: SearchPlayerBody(),
                ),
        ),
      ),
    );
  }
}

class SearchMapBody extends StatelessWidget {
  List<FloatingSearchBarAction> actions(context) => [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.map_sharp),
            onPressed: () {
              BlocProvider.of<SearchCubit>(context).setField('player');
            },
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

    return Consumer<SearchMapProvider>(
      builder: (context, provider, _) => FloatingSearchBar(
        hint: 'Search maps...',
        actions: actions(context),
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

  Widget buildBody(BuildContext context, SearchMapProvider provider) {
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
                    style: TextStyle(fontSize: 12, color: colorLight()),
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
                    UserSharedPreferences.clearMapHistory();
                    provider.refresh();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(EvilIcons.trash, color: colorLight()),
                      Text(
                        'Clear History',
                        style: TextStyle(color: colorLight(), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
            Divider(color: dividerColor()),
          ],
        ),
      ),
    );
  }

  Widget historyTags(BuildContext context, SearchMapProvider provider) {
    //provider.refresh();
    final _history = provider.expanded
        ? UserSharedPreferences.getSearchMapHistory()
        : UserSharedPreferences.getSearchMapHistory().take(6).toList();
    return Container(
      child: Wrap(
        spacing: 8,
        runSpacing: 0,
        children: _history.map((each) => tag(context, each, provider)).toList(),
      ),
    );
  }

  Widget tag(BuildContext context, MapInfo each, SearchMapProvider provider) {
    return ActionChip(
      labelPadding: EdgeInsets.all(1),
      avatar: CircleAvatar(
        child: Center(
          child: Text(
            '${each.difficulty}',
            style: TextStyle(fontSize: 15),
          ),
        ),
        backgroundColor: primarythemeBlue().withOpacity(0.8),
      ),
      label: Text(
        ' ${each.mapName} ',
        style: TextStyle(fontSize: 16),
      ),
      labelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      backgroundColor: Colors.white54,
      onPressed: () {
        UserSharedPreferences.updateMapHistory(each);
        provider.refresh();
        Navigator.of(context)
            .pushNamed('/map_detail', arguments: [each.mapId, each.mapName]);
      },
    );
  }

  Widget builder(SearchMapProvider provider) {
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
    final provider = Provider.of<SearchMapProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            UserSharedPreferences.updateMapHistory(each);
            Navigator.of(context).pushNamed('/map_detail',
                arguments: [each.mapId, each.mapName]);
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
                            UserSharedPreferences.getSearchMapHistory()
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
                          text: each.mapName,
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

class SearchPlayerBody extends StatelessWidget {
  List<FloatingSearchBarAction> actions(context) => [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.person_pin_circle_outlined),
            onPressed: () =>
                BlocProvider.of<SearchCubit>(context).setField('map'),
          ),
        ),
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
      ];

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer<SearchPlayerProvider>(
      builder: (context, provider, _) => FloatingSearchBar(
        hint: 'Search players...',
        actions: actions(context),
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
        debounceDelay: Duration(milliseconds: 500),
        builder: (context, _) => builder(provider),
        body: buildBody(context, provider),
      ),
    );
  }

  Widget buildBody(BuildContext context, SearchPlayerProvider provider) {
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
                    style: TextStyle(fontSize: 12, color: colorLight()),
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
                    UserSharedPreferences.clearPlayerHistory();
                    provider.refresh();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(EvilIcons.trash, color: colorLight()),
                      Text(
                        'Clear History',
                        style: TextStyle(color: colorLight(), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
            Divider(color: dividerColor()),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                ' - search using name or steam 64 id',
                style: TextStyle(
                  color: colorLight(),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget historyTags(BuildContext context, SearchPlayerProvider provider) {
    //provider.refresh();
    final _history = provider.expanded
        ? UserSharedPreferences.getSearchPlayerHistory()
        : UserSharedPreferences.getSearchPlayerHistory().take(6).toList();
    return Container(
      child: Wrap(
        spacing: 8,
        runSpacing: 0,
        children: _history.map((each) => tag(context, each, provider)).toList(),
      ),
    );
  }

  Widget tag(
      BuildContext context, LocalPlayer each, SearchPlayerProvider provider) {
    return ActionChip(
      labelPadding: EdgeInsets.all(0),
      avatar: CircleAvatar(
        child: Text(
          '${each.player_name.substring(0, 1).toUpperCase()}',
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: primarythemeBlue().withOpacity(0.8),
      ),
      label: Text(' ${each.player_name}  '),
      labelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      backgroundColor: Colors.white54,
      onPressed: () {
        UserSharedPreferences.updatePlayerHistory(each);
        provider.refresh();
        Navigator.of(context).pushNamed('/player_detail',
            arguments: [each.steamid64, each.player_name]);
      },
    );
  }

  Widget builder(SearchPlayerProvider provider) {
    return Material(
      color: backgroundColor(),
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: ImplicitlyAnimatedList<LocalPlayer>(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
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

  Widget buildItem(BuildContext context, LocalPlayer each) {
    final provider = Provider.of<SearchPlayerProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            UserSharedPreferences.updatePlayerHistory(each);
            Navigator.of(context).pushNamed(
              '/player_detail',
              arguments: [each.steamid64, each.player_name],
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
                    child: Icon(
                      Icons.person_pin_circle_outlined,
                      color: Colors.white,
                    ),
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
                          text: each.player_name,
                          term: provider.query,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          textStyleHighlight: TextStyle(
                            color: inkWellBlue(),
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        '${each.steamid64}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
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
