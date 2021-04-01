import 'package:kzstats/model/model.dart';
import 'package:kzstats/redux/actions.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    items: itemReducer(state.items, action),
  );
}

List<Item> itemReducer(List<Item> state, action) {
  if (action is AddItemAction) {
    return []
      ..addAll(state)
      ..add(Item(mode: action.mode, tickrate: action.tickrate));
  }
  if (action is RemoveItemAction) {
    return List.unmodifiable(List.from(state)..remove(action.item));
  }
  if (action is RemoveItemsAction) {
    return [];
  }

  return state;
}
