import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/utils/getModeId.dart';

Widget searchWidget(BuildContext context) => IconButton(
      icon: Icon(EvilIcons.search),
      onPressed: () => Navigator.pushNamed(context, '/search'),
    );
Widget? userLeadingIcon(BuildContext context) =>
    BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) => IconButton(
        icon: Icon(Icons.person),
        onPressed: () {
          if (userState.playerInfo.steamid == null &&
              userState.playerInfo.avatarfull == null) {
            Navigator.pushNamed(context, '/login');
          } else {
            Navigator.pushNamed(
              context,
              '/player_detail',
              arguments: [
                userState.playerInfo.steamid,
                userState.playerInfo.personaname
              ],
            );
          }
        },
      ),
    );

class PopUpModeSelect extends StatelessWidget {
  static const modes = <String>['Kztimer', 'SimpleKZ', 'Vanilla', 'Pro', 'Nub'];

  List<PopupMenuItem<String>> _selections(ModeState state) {
    return modes
        .map(
          (String value) => PopupMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                decoration: modeConvert(value) == state.mode ||
                        modeConvert(value) == state.nub.toString()
                    ? TextDecoration.underline
                    : null,
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ModeState state = context.watch<ModeCubit>().state;
    return PopupMenuButton(
      color: Color(0xff4a5568),
      icon: Icon(EvilIcons.chevron_down),
      //offset: Offset(20, 26),
      itemBuilder: (BuildContext context) => _selections(state),
      onSelected: (String result) {
        if (result == 'Kztimer') {
          BlocProvider.of<ModeCubit>(context).kzt();
        } else if (result == 'SimpleKZ') {
          BlocProvider.of<ModeCubit>(context).skz();
        } else if (result == 'Vanilla') {
          BlocProvider.of<ModeCubit>(context).vnl();
        } else if (result == 'Nub') {
          BlocProvider.of<ModeCubit>(context).toNub();
        } else if (result == 'Pro') {
          BlocProvider.of<ModeCubit>(context).toPro();
        }
      },
    );
  }
}
