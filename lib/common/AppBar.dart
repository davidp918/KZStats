import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/cubit/cubit_update.dart';

import 'SearchBar.dart';

class HomepageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  HomepageAppBar(this.currentPage);

  static const modes = <String>[
    'Kztimer',
    'SimpleKZ',
    'Vanilla',
    'Pro',
    'Nub',
  ];

  final List<PopupMenuItem<String>> _selections = modes
      .map((String value) => PopupMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 25, 36, 51),
      elevation: 20,
      title: Text(currentPage),
      centerTitle: true,
      actions: <Widget>[
        HomepageSearchBar(),
        PopupMenuButton(
          color: Color(0xff4a5568),
          offset: Offset(20, 26),
          itemBuilder: (BuildContext context) => _selections,
          onSelected: (String result) {
            switch (result) {
              case 'Kztimer':
                {
                  BlocProvider.of<ModeCubit>(context).kzt();
                }
                break;
              case 'SimpleKZ':
                {
                  BlocProvider.of<ModeCubit>(context).skz();
                }
                break;
              case 'Vanilla':
                {
                  BlocProvider.of<ModeCubit>(context).vnl();
                }
                break;
              case 'Nub':
                {
                  BlocProvider.of<ModeCubit>(context).toNub();
                }
                break;
              case 'Pro':
                {
                  BlocProvider.of<ModeCubit>(context).toPro();
                }
                break;
            }
          },
        ),
      ],
    );
  }

  @override
  // ignore: todo
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
