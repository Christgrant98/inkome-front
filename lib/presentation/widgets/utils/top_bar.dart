import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkome_front/logic/cubits/adverts.dart';
import 'package:inkome_front/presentation/router/app_router.dart';

import '../../../data/models/user.dart';
import 'advert_search_field.dart';
import 'indicator_progress.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.searchText,
    required this.navState,
    required this.token,
    required this.isLogged,
    required this.currentUser,
  });

  final String? searchText;
  final int navState;
  final String? token;
  final bool isLogged;
  final User? currentUser;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;
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
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      centerTitle: true,
      title: widget.navState == 0
          ? SizedBox(
              width: isLargeScreen ? screenWidth * .4 : screenWidth,
              child: AdvertSearchField(
                searchText: widget.searchText,
                onChange: (value, shouldSearch) {
                  if (value.length >= 3 || value.isEmpty) {
                    context
                        .read<AdvertsCubit>()
                        .fetchAdverts(widget.token, searchText: value);
                  }
                },
              ),
            )
          : Container(),
      actions: [
        IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.indexPage),
          icon: const Icon(
            CupertinoIcons.home,
            size: 25,
            color: Colors.black,
          ),
        ),
        !widget.isLogged
            ? Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: IconButton(
                  onPressed: () {
                    !widget.isLogged
                        ? Navigator.pushReplacementNamed(
                            context, Routes.loginPage)
                        : Navigator.pushReplacementNamed(
                            context, Routes.editProfile);
                  },
                  icon: const Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                child: InkWell(
                  child: widget.currentUser?.image != null
                      ? _builProfilePicture(
                          MemoryImage(widget.currentUser!.image!),
                        )
                      : _builProfilePicture(
                          const AssetImage('assets/user_default1.jpg'),
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

  Widget _builProfilePicture(ImageProvider<Object>? pic) {
    if (pic != null) {
      setState(() {
        isLoading = false;
      });
      return CircleAvatar(
        backgroundImage: pic,
      );
    } else {
      setState(() {
        isLoading = true;
      });
      return const Center(
        child: CustomIndicatorProgress(),
      );
    }
  }
}
