import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kzstats/cubit/table_cubit.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/utils/pointsClassification.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDataTable extends StatefulWidget {
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

  late List<GridColumn> _columns;
  late TableDataSource _tableDataSource;
  late int rowsPerPage;
  late ColumnSizer _sizer;

  @override
  void initState() {
    super.initState();
    this._sizer = ColumnSizer();
    this.rowsPerPage = context.read<TableCubit>().state.rowCount;
    this._columns = widget.columns
        .map(
          (String column) => GridColumn(
              columnName: column,
              label: Container(
                alignment:
                    column == '#' ? Alignment.center : Alignment.centerLeft,
                padding: column == 'Map'
                    ? EdgeInsets.fromLTRB(16, 0, 0, 0)
                    : EdgeInsets.symmetric(horizontal: 8.0),
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
    // Size size = MediaQuery.of(context).size;
    final int rowsPerPage = min(this.rowsPerPage, this.data.length);
    final double dataPagerHeight = 60.0;
    final double contentRowHeight = 44.0;
    final double headerRowHeight = 49.0;
    final double tableHeight = headerRowHeight + rowsPerPage * contentRowHeight;
    // tableWidth = min(tableWidth, size.width);
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: appbarColor(),
        gridLineStrokeWidth: 0,
        sortIconColor: Colors.white,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: tableHeight,
              // width: size.width,
              child: SfDataGrid(
                rowHeight: contentRowHeight,
                headerRowHeight: headerRowHeight,
                allowSorting: true,
                columnWidthMode: ColumnWidthMode.auto,
                columnSizer: this._sizer,
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
  late Map<String, int> mapId = {};
  late Map<String, String> playerId = {};
  late List<String> columns;
  final Map<String, String> identifyAttr = {
    '#': 'index',
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
    this.initializeJump();
    this.buildPaginatedDataGridRows();
  }

  void initializeJump() {
    if (this.columns.contains('Map')) {
      for (Map<String, dynamic> each in this.data) {
        this.mapId['map_name'] = each['map_id'];
      }
    }
    if (this.columns.contains('Player')) {
      Set<String> seen = {};
      for (Map<String, dynamic> each in this.data) {
        String curPlayer = each['player_name'];
        if (seen.contains(curPlayer)) {
          int counter = 1;
          while (seen.contains('$curPlayer($counter)')) {
            counter += 1;
          }
          String alias = '$curPlayer($counter)';
          seen.add(alias);
          each['player_name'] = alias;
          this.playerId[alias] = each['steamid64'];
        } else {
          seen.add(curPlayer);
          this.playerId[curPlayer] = each['steamid64'];
        }
      }
    }
  }

  void buildPaginatedDataGridRows() {
    this._rows = this
        .paginated
        .map<DataGridRow>((dynamic each) => DataGridRow(
              cells: [
                for (String column in columns)
                  DataGridCell(
                    columnName: column,
                    value: each[identifyAttr[column]],
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
    List<String> centeredColumns = ['#'];

    return DataGridRowAdapter(
      color: primarythemeBlue(),
      cells: row.getCells().map<Widget>((each) {
        String name = each.columnName;
        return Container(
          padding: name == 'Map'
              ? EdgeInsets.fromLTRB(18, 0, 0, 0)
              : EdgeInsets.symmetric(horizontal: 8.0),
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
    if (column == 'Player') {
      return buttonDataCell(
          context, data, '/player_detail', [this.playerId[data], data]);
    } else if (column == 'Map') {
      return buttonDataCell(
          context, data, '/map_detail', [this.mapId[data], data]);
    } else if (column == 'Date') {
      String? date = data.toString();
      return vanillaDataCell(
          '${date.substring(0, 11)} ${date.substring(11, 19)}');
    } else if (column == 'Rating') {
      return vanillaDataCell(data.toString().substring(0, 6));
    } else if (column == 'Time') {
      return vanillaDataCell(toMinSec(data));
    } else if (column == 'Points') {
      return classifyPoints(data);
    } else {
      return vanillaDataCell(data);
    }
  }
}
