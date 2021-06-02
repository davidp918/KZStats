import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/cubit/user_cubit.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final bool showProfile;
  final List<Widget>? actions;
  final double? height;
  BaseAppBar(this.currentPage, this.showProfile, [this.actions, this.height]);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      toolbarHeight: height ?? kToolbarHeight * 0.9,
      snap: false,
      centerTitle: !this.showProfile,
      leading: leadingIcon(context),
      title: Text(
        '$currentPage',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      brightness: Brightness.dark,
      actions: this.actions,
    );
  }

  Widget? leadingIcon(BuildContext context) => this.showProfile
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
