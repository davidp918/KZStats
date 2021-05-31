import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';

class MapsFilter extends StatefulWidget {
  MapsFilter({Key? key}) : super(key: key);

  @override
  MapsFilterState createState() => MapsFilterState();
}

class MapsFilterState extends State<MapsFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor(),
        centerTitle: true,
        title: Text(
          'Filter',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: ListView(
        children: [
          buildCard(
              'Sort by', ['Alphabetical Order', 'Latest Released', 'Map Size']),
        ],
      ),
    );
  }

  Widget buildCard(String title, List<String> options) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: primarythemeBlue(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
