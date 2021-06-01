import 'package:flutter/material.dart';
import 'package:kzstats/cubit/tier_cubit.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapsFilter extends StatefulWidget {
  MapsFilter({Key? key}) : super(key: key);

  @override
  MapsFilterState createState() => MapsFilterState();
}

class MapsFilterState extends State<MapsFilter> {
  late FilterState filterState;
  final List<String> sortByOptions = [
    'Alphabetical Order - Ascending',
    'Alphabetical Order - Descending',
    'Tier - Ascending',
    'Tier - Descending',
    'Latest Release',
    'Oldest Release',
    'Largest Map in size',
    'Smallest Map in size',
  ];
  final List<String> tierOptions = [
    'Very Easy',
    'Easy',
    'Medium',
    'Hard',
    'Very Hard',
    'Extreme',
    'Death'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.filterState = context.watch<FilterCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor(),
        centerTitle: true,
        brightness: Brightness.dark,
        title: Text('Filter'),
      ),
      body: ListView(
        addAutomaticKeepAlives: true,
        children: [
          /* buildCard(
              'Sort by', ['Alphabetical Order', 'Latest Released', 'Map Size']), */
          // tier
          // mapper
          OptionsChoice(
            title: 'Sort by',
            child: ChipsChoice<int>.single(
              value: this.filterState.sortBy,
              onChanged: (int val) =>
                  BlocProvider.of<FilterCubit>(context).setSortBy(val),
              choiceItems: C2Choice.listFrom(
                source: this.sortByOptions,
                value: (int i, String v) => i,
                label: (int i, String v) => v,
              ),
              choiceStyle: C2ChoiceStyle(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              wrapped: true,
            ),
          ),
          OptionsChoice(
            title: 'Tier',
            child: ChipsChoice<dynamic>.multiple(
              value: this.filterState.tier,
              choiceItems: C2Choice.listFrom(
                source: this.tierOptions,
                value: (int i, String v) => i,
                label: (int i, String v) => v,
              ),
              onChanged: (List<dynamic> val) {
                BlocProvider.of<FilterCubit>(context).setTier(val);
              },
              wrapped: true,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsChoice extends StatefulWidget {
  final String title;
  final Widget child;

  OptionsChoice({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  _OptionsChoiceState createState() => _OptionsChoiceState();
}

class _OptionsChoiceState extends State<OptionsChoice>
    with AutomaticKeepAliveClientMixin<OptionsChoice> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: primarythemeBlue(),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(fit: FlexFit.loose, child: widget.child),
        ],
      ),
    );
  }
}
