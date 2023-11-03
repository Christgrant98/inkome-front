import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inkome_front/logic/cubits/adverts.dart';
import 'package:inkome_front/logic/cubits/authentication_cubit.dart';
import 'package:inkome_front/logic/cubits/navigation.dart';
import 'package:inkome_front/presentation/router/app_router.dart';
import 'package:inkome_front/presentation/widgets/utils/advert_search_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:inkome_front/presentation/widgets/utils/bottom_sheet_menu.dart';
import 'package:inkome_front/presentation/widgets/utils/text_view.dart';

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
                            _buildDrawerHeader(),
                            _buildMenuOption(
                              context: context,
                              title: 'home',
                              icon: CupertinoIcons.house_alt,
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, Routes.indexPage),
                            ),
                            SizedBox(height: isLogged ? 5 : 0),
                            if (isLogged)
                              _buildMenuOption(
                                context: context,
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
                                context: context,
                                title: 'add a new advert',
                                icon: CupertinoIcons.add_circled_solid,
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, Routes.createAdvertPage),
                              ),
                            SizedBox(height: isLogged ? 5 : 0),
                            if (isLogged)
                              _buildMenuOption(
                                context: context,
                                title: 'My adverts',
                                icon: CupertinoIcons.square_stack_3d_down_right,
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, Routes.myAdsPage),
                              ),
                            SizedBox(height: isLogged ? 5 : 0),
                            if (isLogged)
                              _buildMenuOption(
                                context: context,
                                title: 'My Wallet',
                                icon: CupertinoIcons.macwindow,
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, Routes.walletPage),
                              ),
                            const SizedBox(height: 5),
                            _buildMenuOption(
                              context: context,
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
                          context: context,
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
                      //       context: context,
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
          appBar: _buildAppBar(
            navState: navState,
            constraints: constraints,
            context: context,
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

  Padding _buildDrawerHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Image.asset('assets/sqr_logo.png'),
      ),
    );
  }

  Widget _buildLogActionButton({
    required bool isLogged,
    required BuildContext context,
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
        // gradient: LinearGradient(
        //   colors: [
        //     Colors.black,
        //     Colors.black,
        //   ],
        //   begin: Alignment.center,
        //   end: Alignment.bottomCenter,
        // ),
      ),
      child: Stack(
        children: [
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: ClipPath(
          //     clipper: WaveClipperTwo(reverse: true),
          //     child: Container(
          //       height: constraints.maxHeight * 0.2,
          //       width: constraints.maxWidth,
          //       decoration: const BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [
          //             Color.fromARGB(255, 76, 5, 0),
          //             Colors.black,
          //           ],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          content,
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required String title,
    required void Function() onTap,
    required IconData icon,
  }) {
    return Card(
      elevation: 1.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
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

  AppBar _buildAppBar({
    required int navState,
    required BoxConstraints constraints,
    required BuildContext context,
    required String? token,
    required bool isLogged,
    required User? currentUser,
  }) {
    return AppBar(
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      centerTitle: true,
      title: navState == 0
          ? SizedBox(
              width: constraints.maxWidth * .55,
              child: AdvertSearchField(
                searchText: searchText,
                onChange: (value, shouldSearch) {
                  if (value.length >= 3) {
                    context
                        .read<AdvertsCubit>()
                        .fetchAdverts(token, searchText: value);
                  } else if (value.isEmpty) {
                    context.read<AdvertsCubit>().fetchAdverts(token);
                  }
                },
              ),
            )
          : Container(),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, Routes.indexPage);
          },
          icon: const Icon(
            CupertinoIcons.home,
            size: 25,
            color: Colors.black,
          ),
        ),
        !isLogged
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: IconButton(
                  onPressed: () {
                    !isLogged
                        ? Navigator.pushReplacementNamed(
                            context, Routes.loginPage)
                        : Navigator.pushReplacementNamed(
                            context, Routes.editProfile);
                  },
                  icon: const Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                child: InkWell(
                  child: currentUser?.image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(currentUser!.image!),
                        )
                      : const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/user_default1.jpg'),
                        ),
                  onTap: () => Navigator.pushReplacementNamed(
                      context, Routes.editProfile),
                ),
              ),
      ],
      toolbarHeight: 60,
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
    );
  }
}
