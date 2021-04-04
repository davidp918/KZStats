import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/cubit/mode_cubit.dart';

import 'SearchBar.dart';

class HomepageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  HomepageAppBar(this.currentPage);

  static const modes = <String>[
    'Kztimer',
    'SimpleKZ',
    'Vanila',
  ];

  final List<PopupMenuItem<String>> _modeSelections = modes
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

/*   void callUpdateMode(String res){
    res == 'Kztimer'
    ? 
  } */

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
          itemBuilder: (BuildContext context) => _modeSelections,
          onSelected: (String result) {
            result == 'SimpleKZ'
                ? BlocProvider.of<ModeCubit>(context).skz()
                : result == 'Kztimer'
                    ? BlocProvider.of<ModeCubit>(context).kzt()
                    : BlocProvider.of<ModeCubit>(context).vnl();
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
