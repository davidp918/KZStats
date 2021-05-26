import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/Popup_mode.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/theme/colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final bool leading;
  BaseAppBar(this.currentPage, this.leading);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: appbarColor(),
      leading: leadingIcon(context),
      title: Text(currentPage),
      centerTitle: true,
      brightness: Brightness.dark,
      actions: <Widget>[
        IconButton(
          icon: Icon(EvilIcons.search),
          onPressed: () => Navigator.pushNamed(context, '/search'),
        ),
        PopUpModeSelect(),
      ],
    );
  }

  Widget? leadingIcon(BuildContext context) => this.leading
      ? BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            return IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                if (userState.info.avatarUrl == '' &&
                    userState.info.steam32 == '') {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.pushNamed(
                    context,
                    '/player_detail',
                    arguments: [userState.info.steam64, userState.info.name],
                  );
                }
              },
            );
          },
        )
      : null;
}
