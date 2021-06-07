import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class TableState {
  int rowCount;

  TableState({
    required this.rowCount,
  });

  Map<String, dynamic> toMap() => {
        'rowCount': rowCount,
      };

  factory TableState.fromMap(Map<String, dynamic> map) => TableState(
        rowCount: map['rowCount'],
      );
}

class TableCubit extends Cubit<TableState> with HydratedMixin {
  TableCubit() : super(TableState(rowCount: 10));

  void setRowCount(int count) => emit(TableState(rowCount: count));

  @override
  TableState fromJson(Map<String, dynamic> json) => TableState.fromMap(json);

  @override
  Map<String, dynamic> toJson(TableState state) => state.toMap();
}
