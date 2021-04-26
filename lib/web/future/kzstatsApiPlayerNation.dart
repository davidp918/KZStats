import 'package:kzstats/web/get/getPlayerKzstatsApi.dart';
import 'package:kzstats/web/json/record_json.dart';

Future<List<String>> getPlayerKzstatsNation(
  List<Wr> kzInfosnapshot,
) async {
  return Future.wait(
    kzInfosnapshot.map(
      (item) {
        return getPlayerKzstatsApi(item.steamid64).then(
          (value) {
            return value.loccountrycode != null
                ? value.loccountrycode.toLowerCase()
                : 'null';
          },
        );
      },
    ),
  );
}
