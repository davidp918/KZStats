import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/urls.dart';

import 'future/kzstatsApiPlayerNation.dart';
import 'json/wr_json.dart';

Future<List<Map>> getInfoWithNation(
    String mode, bool nub, int limit, int offset) async {
  List<dynamic> data = await Future.wait(
    [
      getRequest(
        globalApiWrRecordsUrl(mode, nub, limit,offset),
        wrFromJson,
      ),
      getRequest(
        globalApiWrRecordsUrl(mode, nub, limit,offset),
        wrFromJson,
      ).then((value) => getPlayerKzstatsNation(value!)),
    ],
  );
  List<Wr?>? wrs = data[0];
  List<String?>? nations = data[1];
  int n = wrs?.length ?? 0;
  List<Map> res = [];
  for (int i = 0; i < n; i++) {
    Wr? wr = wrs![i];
    Map<String, dynamic> map = {};
    map['mapName'] = wr?.mapName ?? '';
    map['time'] = wr?.time.toString() ?? '';
    map['teleports'] = wr?.teleports.toString() ?? '';
    map['playerName'] = wr?.playerName ?? '';
    map['steamid64'] = wr?.steamid64 ?? '';
    map['playerNation'] = nations?[i] ?? '';
    res.add(map);
  }
  return res;
}
