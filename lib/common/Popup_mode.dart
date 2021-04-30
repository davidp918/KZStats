import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/cubit/mode_cubit.dart';

class PopUpModeSelect extends StatelessWidget {
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
    return PopupMenuButton(
      color: Color(0xff4a5568),
      icon: Icon(EvilIcons.chevron_down),
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
    );
  }
}
