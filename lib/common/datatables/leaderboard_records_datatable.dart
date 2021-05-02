import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/widgets/dataCells.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/json.dart';

class LeaderboardRecordsTable extends StatefulWidget {
  final List<LeaderboardRecords>? data;

  LeaderboardRecordsTable({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _LeaderboardRecordsTableState createState() =>
      _LeaderboardRecordsTableState();
}

class _LeaderboardRecordsTableState extends State<LeaderboardRecordsTable> {
  late final List<LeaderboardRecords>? _data;
  int? _sortColumnIndex;
  bool _isAscending = false;
  List<String> columns = [
    '#',
    'Player',
    'Count',
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
            compareString(isAscending, value1.count, value2.count));
        break;
      case 1:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.playerName, value2.playerName));
        break;
      case 2:
        _data!.sort((value1, value2) =>
            compareString(isAscending, value1.count, value2.count));
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
    BuildContext context,
    List<LeaderboardRecords>? records,
  ) {
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
        rowsPerPage: 20,
      ),
    );
  }
}

class RecordsSource extends DataTableSource {
  BuildContext context;
  List<LeaderboardRecords>? _data;

  RecordsSource(
    this.context,
    this._data,
  );
  List<DataCell> selectDataCells(
    BuildContext context,
    int index,
    LeaderboardRecords data,
  ) {
    return <DataCell>[
      vanillaDataCell('#${[index, 1].reduce((a, b) => a + b)}'),
      buttonDataCell(
        context,
        data.playerName,
        '/player_detail',
        [data.steamid64, data.playerName],
      ),
      vanillaDataCell('${data.count}'),
    ];
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    final LeaderboardRecords record = _data![index];
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
