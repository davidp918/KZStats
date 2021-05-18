import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/urls.dart';

import 'future/kzstatsApiPlayerNation.dart';
import 'json/wr_json.dart';
import 'package:kzstats/global/recordInfo_class.dart';

Future<List<RecordInfo>> getInfoWithNation(
    String mode, bool nub, int limit, int offset) async {
  List<dynamic> data = await Future.wait(
    [
      getRequest(
        globalApiWrRecordsUrl(mode, nub, limit, offset),
        wrFromJson,
      ),
      getRequest(
        globalApiWrRecordsUrl(mode, nub, limit, offset),
        wrFromJson,
      ).then((value) => getPlayerKzstatsNation(value!)),
    ],
  );
  List<Wr?>? wrs = data[0];
  List<String?>? nations = data[1];
  int n = wrs?.length ?? 0;
  List<RecordInfo> res = [];
  for (int i = 0; i < n; i++) {
    Wr? wr = wrs![i];

    res.add(
      RecordInfo(
        mapName: wr?.mapName ?? '',
        mapId: wr?.mapId ?? 0,
        playerName: wr?.playerName ?? '',
        playerNation: nations?[i] ?? '',
        steamid64: wr?.steamid64 ?? '',
        teleports: wr?.teleports ?? 0,
        time: wr?.time ?? 0.0,
        nation: nations?[i],
        createdOn: wr?.createdOn,
      ),
    );
  }
  return res;
}
