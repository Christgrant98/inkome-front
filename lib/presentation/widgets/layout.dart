import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/logic/cubits/navigation.dart';
import 'package:inkome_front/presentation/router/app_router.dart';
import 'package:inkome_front/presentation/widgets/logo_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inkome_front/presentation/widgets/utils/bottom_sheet_menu.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';
import 'package:inkome_front/presentation/widgets/utils/top_bar.dart';

import '../../data/models/user.dart';

class Layout extends StatelessWidget {
  final String? searchText;
  final Widget content;
  const Layout({Key? key, required this.content, this.searchText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;
    User? currentUser = context.watch<AuthenticationCubit>().state.user;
    String? token = context.read<AuthenticationCubit>().state.token;
    int navState = context.read<NavigationCubit>().state.selectedIndex;
    bool isLogged = context.watch<AuthenticationCubit>().isLogged();
    AppLocalizations? t = AppLocalizations.of(context);
    if (t == null) throw Exception('AppLocalizations not found');

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          drawer: SafeArea(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: const SizedBox.expand(),
                ),
                Drawer(
                  backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(
                              right: 10, bottom: 10, left: 10, top: 30),
                          children: [
                            _buildDrawerHeader(context),
                            _buildMenuOption(
                              title: 'home',
                              icon: CupertinoIcons.house_alt,
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, Routes.indexPage),
                            ),
                            SizedBox(height: isLogged ? 5 : 0),
                            if (isLogged)
                              _buildMenuOption(
                                title: 'My fav Adverts',
                                icon: CupertinoIcons.suit_heart,
                                onTap: () {
                                  !isLogged
                                      ? Navigator.pushReplacementNamed(
                                          context, Routes.loginPage)
                                      : Navigator.pushReplacementNamed(
                                          context, Routes.favoritesPage);
                                },
                              ),
                            const SizedBox(height: 5),
                            if (isLogged)
                              _buildMenuOption(
                                title: 'add a new advert',
                                icon: CupertinoIcons.add_circled_solid,
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, Routes.createAdvertPage),
                              ),
                            SizedBox(height: isLogged ? 5 : 0),
                            if (isLogged)
                              _buildMenuOption(
                                title: 'My adverts',
                                icon: CupertinoIcons.square_stack_3d_down_right,
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, Routes.myAdsPage),
                              ),
                            SizedBox(height: isLogged ? 5 : 0),
                            if (isLogged)
                              _buildMenuOption(
                                title: 'My Wallet',
                                icon: CupertinoIcons.macwindow,
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, Routes.walletPage),
                              ),
                            const SizedBox(height: 5),
                            _buildMenuOption(
                              title: 'My profile',
                              icon: CupertinoIcons.person_badge_plus,
                              onTap: () {
                                isLogged
                                    ? Navigator.pushReplacementNamed(
                                        context, Routes.editProfile)
                                    : Navigator.pushReplacementNamed(
                                        context, Routes.loginPage);
                              },
                            ),
                          ],
                        ),
                      ),
                      if (!isLogged)
                        _buildLogActionButton(
                          isLogged: isLogged,
                          textBtn: 'Log In',
                          colorBtn: Colors.green,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.loginPage);
                          },
                        ),
                      // if (isLogged)
                      //   _buildLogActionButton(
                      //       isLogged: isLogged,
                      //
                      //       textBtn: 'Log Out',
                      //       colorBtn: Colors.black,
                      //       onTap: () {
                      //         BlocProvider.of<AuthenticationCubit>(context)
                      //             .logout();
                      //         Navigator.pushReplacementNamed(
                      //             context, Routes.indexPage);
                      //       }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          appBar: TopBar(
            searchText: searchText,
            navState: navState,
            token: token,
            isLogged: isLogged,
            currentUser: currentUser,
          ),
          extendBody: true,
          body: _buildBackground(constraints),
          bottomNavigationBar: !isLargeScreen ? const BottomNavigator() : null,
        );
      },
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(color: Colors.transparent),
        ),
        child: const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Logo(type: Type.white),
        ),
      ),
    );
  }

  Widget _buildLogActionButton({
    required bool isLogged,
    required String textBtn,
    required void Function() onTap,
    required Color colorBtn,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: !isLogged ? 20 : 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: colorBtn,
        child: ListTile(
          title: TextView(
              textAlign: TextAlign.center,
              text: textBtn,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildBackground(BoxConstraints constraints) {
    return Container(
      height: constraints.maxHeight,
      width: constraints.maxWidth,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 240, 240, 240),
      ),
      child: content,
    );
  }

  Widget _buildMenuOption({
    required String title,
    required void Function() onTap,
    required IconData icon,
  }) {
    return Card(
      elevation: 1.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: const Color.fromARGB(255, 230, 230, 230),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: TextView(
          text: title,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}
