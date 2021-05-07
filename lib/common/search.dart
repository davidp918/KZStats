import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        iconColor: Colors.white,
        backgroundColor: appbarColor(),
        shadowColor: primarythemeBlue(),
        transitionCurve: Curves.easeInOutCubic,
        hintStyle: TextStyle(color: Colors.white70),
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        builder: (context, _) => buildBody(),
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: SearchDelegate.onQueryChange,
        progress: true,
      ),
    );
  }

  Widget buildBody() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

class SearchDelegate {
  static void onQueryChange(String query) async {}
}
