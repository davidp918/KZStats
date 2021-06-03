import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/wr_json.dart';
import 'package:kzstats/web/urls.dart';

Future<List<String>> getPlayerKzstatsNation(
  List<Wr> kzInfosnapshot,
) async {
  return Future.wait(
    kzInfosnapshot.map(
      (item) {
        return getRequest(
          kzstatsApiPlayerInfoUrl(item.steamid64),
          kzstatsApiPlayerFromJson,
        ).then(
          (value) {
            return value != null && value!.loccountrycode != null
                // if the player's country is not visible
                ? value.loccountrycode!.toLowerCase()
                : 'null';
          },
        );
      },
    ),
  );
}
