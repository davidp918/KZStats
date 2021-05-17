import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/withNation.dart';

class Homepage extends StatelessWidget {
  static int pageSize = 12;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: true,
      currentPage: 'Latest',
      builder: (context, constraints) => BlocBuilder<ModeCubit, ModeState>(
        builder: (context, state) => PagewiseListView<Map>(
          pageSize: pageSize,
          itemBuilder: this._itemBuilder,
          loadingBuilder: (context) => loadingFromApi(),
          pageFuture: (pageIndex) => getInfoWithNation(
              state.mode, state.nub, pageSize, pageSize * pageIndex!),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Map data, int index) {
    Size size = MediaQuery.of(context).size;
    double crossWidth = (size.width / 2) * 33 / 41;
    double crossHeight = (size.height - 56) / 6;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: crossWidth,
                    child: GetNetworkImage(
                      fileName: data['mapName'],
                      url: '$imageBaseURL${data['mapName']}.webp',
                      errorImage: AssetImage('assets/icon/noimage.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: crossWidth,
                    child: GetNetworkImage(
                      fileName: data['mapName'],
                      url: '$imageBaseURL${data['mapName']}.webp',
                      errorImage: AssetImage('assets/icon/noimage.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 4, color: dividerColor()),
      ],
    );
  }
}
