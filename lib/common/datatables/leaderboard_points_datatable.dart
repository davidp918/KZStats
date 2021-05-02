import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/widgets/dataCells.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/json.dart';

class LeaderboardPointsTable extends StatefulWidget {
  final List<LeaderboardPoints>? data;

  LeaderboardPointsTable({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _LeaderboardPointsTableState createState() => _LeaderboardPointsTableState();
}

class _LeaderboardPointsTableState extends State<LeaderboardPointsTable> {
  late final List<LeaderboardPoints>? _data;
  int? _sortColumnIndex;
  bool _isAscending = false;
  List<String> columns = [
    '#',
    'Player',
    'Average',
    'Points',
    'Rating',
    'Finishes',
  ];

  @override
  void initState() {
    super.initState();
    this._data = widget.data;
  }

  void onSort(
    int columnIndex,
    bool isAscending,
  ) {
    switch (columnIndex) {
      case 0:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.points, value2.points));
        break;
      case 1:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.playerName, value2.playerName));
        break;
      case 2:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.average, value2.average));
        break;
      case 3:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.points, value2.points));
        break;
      case 4:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.rating, value2.rating));
        break;
      case 5:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.finishes, value2.finishes));
        break;
      default:
        throw (UnimplementedError);
    }
    setState(
      () {
        this._sortColumnIndex = columnIndex;
        this._isAscending = isAscending;
      },
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(
            '$column',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onSort: onSort,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: dividerColor(),
        textTheme: TextTheme(
          caption: TextStyle(color: Colors.white),
        ),
        cardTheme: CardTheme(
          color: Color(0xff1D202C),
        ),
      ),
      child: buildDataTable(context, _data),
    );
  }

  Widget buildDataTable(
      BuildContext context, List<LeaderboardPoints>? records) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: PaginatedDataTable(
        dragStartBehavior: DragStartBehavior.down,
        headingRowHeight: 46,
        dataRowHeight: 42,
        horizontalMargin: 12,
        columnSpacing: 15,
        columns: getColumns(columns),
        source: RecordsSource(context, records),
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _isAscending,
      ),
    );
  }
}

class RecordsSource extends DataTableSource {
  BuildContext context;
  List<LeaderboardPoints>? _data;

  RecordsSource(
    this.context,
    this._data,
  );
  List<DataCell> selectDataCells(
    BuildContext context,
    int index,
    LeaderboardPoints data,
  ) {
    return <DataCell>[
/*       '#',
      'Player',
      'Average',
      'Points',
      'Rating',
      'Finishes', */
      indexDataCell(index),
      playerNameDataCell(context, data.steamid64!, data.playerName!),
      averageDataCell(data.average),
      pointsDataCell(data.points),

      //leftof
    ];
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    final LeaderboardPoints record = _data![index];
    return DataRow.byIndex(
      index: index,
      color: MaterialStateColor.resolveWith(
        (states) {
          if (index % 2 == 0) {
            return primarythemeBlue();
          } else {
            return secondarythemeBlue();
          }
        },
      ),
      cells: selectDataCells(context, index, record),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data?.length == null ? 0 : _data!.length;

  @override
  int get selectedRowCount => 0;
}
