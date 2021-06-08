import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kzstats/cubit/table_cubit.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/utils/pointsClassification.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDataTable extends StatefulWidget {
  //TODO: center
  final List<dynamic> data;
  final List<String> columns;
  CustomDataTable({
    Key? key,
    required this.data,
    required this.columns,
  }) : super(key: key);

  @override
  _CustomDataTableState createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  List<Map<String, dynamic>> data = [];

  late List<GridTextColumn> _columns;
  late TableDataSource _tableDataSource;
  late int rowsPerPage;
  final Map<String, double> _width = {
    '#': 50,
    'Player': 130,
    'Count': 100,
    'Average': 100,
    'Points': 78,
    'Rating': 80,
    'Finishes': 100,
    'Map': 160,
    'Time': 80,
    'TPs': 70,
    'Date': 180,
    'Server': 200,
    'Points in total': 140,
  };

  @override
  void initState() {
    super.initState();
    this.rowsPerPage = context.read<TableCubit>().state.rowCount;

    this._columns = widget.columns
        .map(
          (String column) => GridTextColumn(
              width: this._width[column] ?? double.nan,
              columnName: column,
              label: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: appbarColor(),
                child: Text(
                  '$column',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              allowSorting: true),
        )
        .toList();
    for (int i = 0; i < widget.data.length; i++) {
      Map<String, dynamic> cur = widget.data[i].toJson();
      cur['index'] = i + 1;
      this.data.add(cur);
    }
    for (int i = 0; i < this.data.length; i++) this.data[i]['index'] = i + 1;
    this._tableDataSource = TableDataSource(
      data: this.data,
      columns: widget.columns,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final int rowsPerPage = min(this.rowsPerPage, this.data.length);
    final double dataPagerHeight = 60.0;
    final double contentRowHeight = 44.0;
    final double headerRowHeight = 49.0;
    final double tableHeight = headerRowHeight + rowsPerPage * contentRowHeight;
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: appbarColor(),
        gridLineStrokeWidth: 0,
        sortIconColor: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: tableHeight,
            width: size.width,
            child: SfDataGrid(
              rowHeight: contentRowHeight,
              headerRowHeight: headerRowHeight,
              allowSorting: true,
              allowMultiColumnSorting: true,
              allowTriStateSorting: true,
              showSortNumbers: true,
              isScrollbarAlwaysShown: false,
              columns: this._columns,
              source: this._tableDataSource,
              verticalScrollPhysics: NeverScrollableScrollPhysics(),
            ),
          ),
          SizedBox(
            height: dataPagerHeight,
            child: SfDataPagerTheme(
              data: SfDataPagerThemeData(
                brightness: Brightness.dark,
                itemTextStyle: TextStyle(
                    color: inkWellBlue(), fontWeight: FontWeight.w400),
                itemColor: primarythemeBlue(),
                selectedItemColor: backgroundColor(),
                selectedItemTextStyle: TextStyle(
                    color: inkWellBlue(), fontWeight: FontWeight.w800),
                itemBorderRadius: BorderRadius.circular(5),
                backgroundColor: primarythemeBlue(),
                disabledItemColor: primarythemeBlue(),
              ),
              child: SfDataPager(
                visibleItemsCount: rowsPerPage,
                delegate: _tableDataSource,
                pageCount: this.data.length / rowsPerPage,
                direction: Axis.horizontal,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TableDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  late int rowsPerPage;
  late BuildContext context;
  late List<Map<String, dynamic>> paginated;
  late List<Map<String, dynamic>> data;
  late List<String> columns;
  final Map<String, String> identifyAttr = {
    'Player': 'player_name',
    'Count': 'count',
    'Average': 'average',
    'Points': 'points',
    'Rating': 'rating',
    'Finishes': 'finishes',
    'Map': 'map_name',
    'Time': 'time',
    'TPs': 'teleports',
    'Date': 'created_on',
    'Server': 'server_name',
    'Points in total': 'totalPoints',
  };

  TableDataSource({
    required List<Map<String, dynamic>> data,
    required List<String> columns,
    required BuildContext context,
  }) {
    this.context = context;
    this.data = data;
    this.columns = columns;
    this.rowsPerPage =
        min(context.read<TableCubit>().state.rowCount, this.data.length);
    this.paginated =
        this.data.getRange(0, min(this.data.length, 9)).toList(growable: false);
    this.buildPaginatedDataGridRows();
  }

  void buildPaginatedDataGridRows() {
    this._rows = this
        .paginated
        .map<DataGridRow>((dynamic each) => DataGridRow(
              cells: [
                for (String column in columns)
                  DataGridCell(
                    columnName: column,
                    value: each,
                  )
              ],
            ))
        .toList();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < data.length && endIndex <= data.length) {
      this.paginated =
          this.data.getRange(startIndex, endIndex).toList(growable: false);
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      this.paginated = [];
    }
    return true;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    List<String> centeredColumns = [
      '#',
      'TPs',
      'Points',
      'Average',
      'Rating',
      'Finishes',
      'Points in total'
    ];

    return DataGridRowAdapter(
      color: primarythemeBlue(),
      cells: row.getCells().map<Widget>((each) {
        String name = each.columnName;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          alignment: centeredColumns.contains(name)
              ? Alignment.center
              : Alignment.centerLeft,
          child: getCell(
            each.columnName,
            each.value,
          ),
        );
      }).toList(),
    );
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    final dynamic value1 = a
        ?.getCells()
        .firstWhereOrNull((element) => element.columnName == sortColumn.name)
        ?.value[identifyAttr[sortColumn.name]];
    final dynamic value2 = b
        ?.getCells()
        .firstWhereOrNull((element) => element.columnName == sortColumn.name)
        ?.value[identifyAttr[sortColumn.name]];

    if (value1 == null || value2 == null) {
      return 0;
    }

    if (value1.compareTo(value2) > 0) {
      return sortColumn.sortDirection == DataGridSortDirection.ascending
          ? 1
          : -1;
    } else if (value1.compareTo(value2) == -1) {
      return sortColumn.sortDirection == DataGridSortDirection.ascending
          ? -1
          : 1;
    } else {
      return 0;
    }
  }

  @override
  List<DataGridRow> get rows => _rows;

  Widget vanillaDataCell(dynamic data) => Text(
        '${data == null ? '<Unknown>' : Characters(data.toString())}',
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      );

  Widget buttonDataCell(BuildContext context, dynamic data, String destination,
          dynamic parameter) =>
      data == null
          ? vanillaDataCell(data)
          : InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(destination, arguments: parameter),
              child: Text(
                '${Characters(data.toString())}',
                style: TextStyle(color: inkWellBlue()),
                overflow: TextOverflow.ellipsis,
              ));

  Widget getCell(String column, dynamic data) {
    switch (column) {
      case '#':
        return vanillaDataCell(data?['index']);
      case 'Player':
        return buttonDataCell(context, data?['player_name'], '/player_detail',
            [data?['steamid64'], data?['player_name']]);
      case 'Count':
        return vanillaDataCell(data?['count']);
      case 'Average':
        return vanillaDataCell(data?['average']);
      case 'Points':
        return classifyPoints(data?['points']);
      case 'Rating':
        return vanillaDataCell(data?['rating'].toString().substring(0, 6));
      case 'Finishes':
        return vanillaDataCell(data?['finishes']);
      case 'Map':
        return buttonDataCell(context, data?['map_name'], '/map_detail',
            [data['mapId'], data['map_name']]);
      case 'Time':
        return vanillaDataCell(toMinSec(data?['time']));
      case 'TPs':
        return vanillaDataCell(data?['teleports']);
      case 'Date':
        String? date = data?['created_on'].toString();
        return vanillaDataCell(
            '${date?.substring(0, 11)} ${date?.substring(11, 19)}');
      case 'Server':
        return vanillaDataCell(data?['server_name']);
      case 'Points in total':
        return vanillaDataCell(data?['totalPoints']);
      default:
        return vanillaDataCell('error');
    }
  }
}