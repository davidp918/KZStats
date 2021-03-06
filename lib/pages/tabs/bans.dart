import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/globalApiBans_json.dart';

class Bans extends StatefulWidget {
  static const int pageSize = 10;

  @override
  _BansState createState() => _BansState();
}

class _BansState extends State<Bans> with AutomaticKeepAliveClientMixin<Bans> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PagewiseListView<Ban>(
      padding: EdgeInsets.symmetric(horizontal: 12),
      shrinkWrap: true,
      pageSize: Bans.pageSize,
      itemBuilder: this._itemBuilder,
      pageFuture: (pageIndex) =>
          getBans(Bans.pageSize, Bans.pageSize * pageIndex!, banFromJson),
      loadingBuilder: (context) => loadingFromApi(),
    );
  }

  Widget _itemBuilder(context, Ban entry, _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 8),
        ListTile(
          dense: false,
          leading: Icon(
            Icons.person,
            color: Colors.brown[200],
          ),
          title: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                    text: '${entry.playerName} ',
                    style: TextStyle(fontSize: 20)),
                TextSpan(
                  text: '(${entry.steamId})',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Banned since ',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextSpan(
                      text: '${entry.banType}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade100,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text:
                          'From ${entry.createdOn.toString().substring(0, 10)} to ',
                      style: TextStyle(fontSize: 14),
                    ),
                    entry.expiresOn.toString().substring(0, 4) == '9999'
                        ? TextSpan(
                            text: 'Never',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red.shade200,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : TextSpan(
                            text:
                                '${entry.expiresOn.toString().substring(0, 10)}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Divider(height: 4, color: dividerColor()),
      ],
    );
  }
}
